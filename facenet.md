1 compare.py

# about  load_and_align_data()

- load_and_align_data()
  - 总的来说，会对于图像中最像人脸的部分进行提取
  - 参数
    - args.image_files ： list of file place
    - args.image_size : 图像 resize 大小
    - args.margin : unknown
    - args.gpu_memory_fraction : use part of gpu

 
  
  
  - 走读流程
    - pnet, rnet, onet = align.detect_face.create_mtcnn(sess, None)
        - 生成三个网络结构
        - pnet，rnet，onet 为三个匿名函数
          - pnet_fun = lambda img : sess.run(('pnet/conv4-2/BiasAdd:0', 'pnet/prob1:0'), feed_dict={'pnet/input:0':img})
          - rnet_fun = lambda img : sess.run(('rnet/conv5-2/conv5-2:0', 'rnet/prob1:0'), feed_dict={'rnet/input:0':img})
          - onet_fun = lambda img : sess.run(('onet/conv6-2/conv6-2:0', 'onet/conv6-3/conv6-3:0', 'onet/prob1:0'), feed_dict={'onet/input:0':img})

        - 对应到这里的三个网络会被create_mtcnn 构建：
              with tf.variable_scope('onet'):
                data = tf.placeholder(tf.float32, (None,48,48,3), 'input')
                # 相当于构建了一个Onet网络
                onet = ONet({'data':data})
                # load 函数会利用当前的sess 把相关的信息feed进去
                onet.load(os.path.join(model_path, 'det3.npy'), sess)
                  - var = tf.get_variable(param_name)
                  - session.run(var.assign(data))  #tf 中，使用assign来获得数据

  - 对每一张图片调用
    bounding_boxes, _ = align.detect_face.detect_face(img, minsize, pnet, rnet, onet, threshold, factor)
      - 返回一个n*5的向量
    # 获取了第一个人脸的信息
    det = np.squeeze(bounding_boxes[0,0:4])
    # bb相比于det，在各个方向上会做一些扩展（但是我考虑人脸应该理论上来说往长方形扩展效果更好？）
    bb = np.zeros(4, dtype=np.int32)
    bb[0] = np.maximum(det[0]-margin/2, 0)
    bb[1] = np.maximum(det[1]-margin/2, 0)
    bb[2] = np.minimum(det[2]+margin/2, img_size[1])
    bb[3] = np.minimum(det[3]+margin/2, img_size[0])
    cropped = img[bb[1]:bb[3],bb[0]:bb[2],:]
    
    # crop and align
    cropped = img[bb[1]:bb[3],bb[0]:bb[2],:]
    aligned = misc.imresize(cropped, (image_size, image_size), interp='bilinear')
      
    # 图片进行白化
    prewhitened = facenet.prewhiten(aligned)

 
