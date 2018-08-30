1 class RCNN

2 class FasterRCNN
  1 forward:
    feat = self.features(x) 
       
     
    # RPN proposals
    if autograd.is_training():
        _, rpn_box, raw_rpn_score, raw_rpn_box, anchors = self.rpn(
            feat, F.zeros_like(x))
        # sample 128 roi
        assert gt_box is not None
        rpn_box, samples, matches = self.sampler(rpn_box, gt_box)
    else:
        _, rpn_box = self.rpn(feat, F.zeros_like(x))
        

    ```
    Sampler
    #A sampler to choose positive/negative samples from RCNN Proposals
    
    self.sampler = RCNNTargetSampler(num_sample, pos_iou_thresh, neg_iou_thresh_high,
                                             neg_iou_thresh_low, pos_ratio)
    
    forward
      all_roi = F.concat(roi.squeeze(axis=0), gt_box.squeeze(axis=0), dim=0)
      # calculate ious between (N, 4) anchors and (M, 4) bbox ground-truths
      # ious is (N, M)
      ious = F.contrib.box_iou(all_roi, gt_box, format='corner').transpose((1, 0, 2)) # 拿到IOU : 每一个N对每一个M 
      
      # self._matcher =  MaximumMatcher(pos_iou_thresh)
      # matchter 策略 ： CompositeMatcher、BipartiteMatcher、MaximumMatcher
      matches = self._matcher(ious)                                                   

      samples = F.Custom(matches, ious, op_type='quota_sampler',                      # sampler glouncv.nn.sampler.py
                         num_sample=self._num_sample,
                         pos_thresh=self._pos_iou_thresh,
                         neg_thresh_high=self._neg_iou_thresh_high,
                         neg_thresh_low=self._neg_iou_thresh_low,
                         pos_ratio=self._pos_ratio)
                         
            ```
            
            
            
            ```
      samples = samples.squeeze(axis=0)   # remove batch axis
      matches = matches.squeeze(axis=0)

      # shuffle and argsort, take first num_sample samples
      sf_samples = F.where(samples == 0, F.ones_like(samples) * -999, samples)
      indices = F.argsort(sf_samples, is_ascend=False).slice_axis(
          axis=0, begin=0, end=self._num_sample)
      new_roi = all_roi.take(indices).expand_dims(0)
      new_samples = samples.take(indices).expand_dims(0)
      new_matches = matches.take(indices).expand_dims(0)

    
    ```


    ```
    RPN
    self.rpn = RPN(rpn_channel, stride, scales=scales, ratios=ratios,
                           train_pre_nms=rpn_train_pre_nms, train_post_nms=rpn_train_post_nms,
                           test_pre_nms=rpn_test_pre_nms, test_post_nms=rpn_test_post_nms)
    RPN:
      1 init
          #  base_size=16, ratios=(0.5, 1, 2),
          #  scales=(8, 16, 32), alloc_size=(128, 128),
          #  nms_thresh=0.7, train_pre_nms=12000, train_post_nms=2000,
          #  test_pre_nms=6000, test_post_nms=300, min_size=16, stds=(1., 1., 1., 1.)
          
          if weight_initializer is None:
            weight_initializer = mx.init.Normal(0.01) 
          with self.name_scope():
            self.anchor_generator = RPNAnchorGenerator(
                stride, base_size, ratios, scales, alloc_size)
            anchor_depth = self.anchor_generator.num_depth            # num_depth = len(ratios) * len(scales)
            self.region_proposaler = RPNProposal(
                nms_thresh, train_pre_nms, train_post_nms,
                test_pre_nms, test_post_nms, min_size, stds)
                 
                # RPNProposal takes RPN anchors, RPN prediction scores and box regression preditions. 
                # It will transform anchors, apply NMS to get clean foreground proposals.
                
            self.conv1 = nn.HybridSequential()
            self.conv1.add(
                nn.Conv2D(channels, 3, 1, 1, weight_initializer=weight_initializer))
            self.conv1.add(nn.Activation('relu'))
            # use sigmoid instead of softmax, reduce channel numbers
            self.score = nn.Conv2D(anchor_depth, 1, 1, 0, weight_initializer=weight_initializer)
            self.loc = nn.Conv2D(anchor_depth * 4, 1, 1, 0, weight_initializer=weight_initializer)
      2 forward
          anchors = self.anchor_generator(x)
          x = self.conv1(x)
          raw_rpn_scores = self.score(x).transpose(axes=(0, 2, 3, 1)).reshape((0, -1, 1)) # 拿到了score
          rpn_scores = F.sigmoid(raw_rpn_scores)                                          # 拿到了sigmod结果 （conv -> sigmod ）
          rpn_box_pred = self.loc(x).transpose(axes=(0, 2, 3, 1)).reshape((0, -1, 4))     # 拿到了reg结果
          rpn_score, rpn_box = self.region_proposaler(
              anchors, rpn_scores, rpn_box_pred, img)                                     # 进行nms抑制
          if autograd.is_training(): 
              # return raw predictions as well in training for bp
              return rpn_score, rpn_box, raw_rpn_scores, rpn_box_pred, anchors
          return rpn_score, rpn_box

    ```

    # create batchid for roi
    with autograd.pause():
        roi_batchid = F.arange(
            0, self._max_batch, repeat=self._max_roi).reshape(
                (-1, self._max_roi))
        roi_batchid = F.slice_like(roi_batchid, rpn_box * 0, axes=(0, 1))
        rpn_roi = F.concat(*[roi_batchid.reshape((-1, 1)), rpn_box.reshape((-1, 4))], dim=-1)
        
        
    # ROI features
    if self._roi_mode == 'pool':
        pooled_feat = F.ROIPooling(feat, rpn_roi, self._roi_size, 1. / self.stride)
    elif self._roi_mode == 'align':
        pooled_feat = F.contrib.ROIAlign(feat, rpn_roi, self._roi_size, 1. / self.stride)
    else:
        raise ValueError("Invalid roi mode: {}".format(self._roi_mode))
 
     # RCNN prediction
    top_feat = self.top_features(pooled_feat)
    # top_feat = F.Pooling(top_feat, global_pool=True, pool_type='avg', kernel=self._roi_size)
    top_feat = self.global_avg_pool(top_feat)
    cls_pred = self.class_predictor(top_feat)
    box_pred = self.box_predictor(top_feat).reshape(
        (-1, self.num_class, 4)).transpose((1, 0, 2))

    return ids, scores, bboxes











