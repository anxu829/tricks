# 1 about VocDetection loader

### vocDetection dataloader file path :

```
.../gluoncv/data/pascal_voc/detection.py 
```
### structure

```
class VOCDetection(VisionDataset):
  __init__()
  __str__()
  classes()
  __len__()
  __getitem__()
  _load_items()
  _load_label()
  _validata_label()
  _preload_labels()


```
### 预备知识

#### 1 关于class的几个知识点

1 python 生成器，迭代器
```
http://python.jobbole.com/87805/
```

2 关于python 中使用索引和切片
```
https://www.cnblogs.com/PrettyTom/p/6659425.html
```

3 关于python 中实现len
```
http://www.maixj.net/ict/len-python-14193
```

4 关于python中的property
```
https://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000/001386820062641f3bcc60a4b164f8d91df476445697b9e000
```

5 关于类变量和成员变量
```
https://www.cnblogs.com/20150705-yilushangyouni-Jacksu/p/6238187.html
https://www.cnblogs.com/gtarcoder/p/5005897.html
```

6 init and call
```
https://blog.csdn.net/yaokai_assultmaster/article/details/70256621
```


7 骚操作大全：


```
1 type(instance).CLASSVAR

class VOCDetection(VisionDataset):
    CLASSES = ('aeroplane', 'bicycle', 'bird', 'boat', 'bottle', 'bus', 'car',
               'cat', 'chair', 'cow', 'diningtable', 'dog', 'horse', 'motorbike',
               'person', 'pottedplant', 'sheep', 'sofa', 'train', 'tvmonitor')
    @property
    def classes(self):
        """Category names."""
        return type(self).CLASSES


2 use return to init part of var

class FasterRCNNDefaultTrainTransform(object):
  def __init__(self, net=None)
    ...
    if net is None:
      return
     self.anchors = 1

  
3 use method 'hasattr'

```






#### 2 关于 VOCDetection 的继承 ：

VOCDetecion <-  .../gluoncv/data/base.py(VisionDataset) <- .../mxnet/python/mxnet/gluon/data/dataset.py(Dataset)


而关于 Dataset 要具有 transform的功能


#### 3 关于 VisionDataset

1 __getitem__(self, idx)
```
文件读取的核心是利用 VOCdevkit/VOC*/ImageSets/Main/trainval.txt （具体用啥txt取决于初始化）

然后会去JPEGImages中找到图片，去Annotations 获取坐标


```

# 2 关于数据增强的使用

```
from gluoncv.data.transforms import presets
from gluoncv import utils
from mxnet import nd
short, max_size = 600, 1000  # resize image to short side 600 px, but keep maximum length within 1000
train_transform = presets.rcnn.FasterRCNNDefaultTrainTransform(short, max_size)
val_transform = presets.rcnn.FasterRCNNDefaultValTransform(short, max_size)

train_image2, train_label2 = train_transform(train_image, train_label)

```

源代码中的核心部分

``` 
 def __call__(self, src, label):
        """Apply transform to training image/label."""
        # resize shorter side but keep in max_size
        h, w, _ = src.shape
        img = timage.resize_short_within(src, self._short, self._max_size)
        bbox = tbbox.resize(label, (w, h), (img.shape[1], img.shape[0]))

        # random horizontal flip
        h, w, _ = img.shape
        img, flips = timage.random_flip(img, px=0.5)
        bbox = tbbox.flip(bbox, (w, h), flip_x=flips[0])

        # to tensor
        img = mx.nd.image.to_tensor(img)
        img = mx.nd.image.normalize(img, mean=self._mean, std=self._std)

        if self._anchors is None:
            return img, bbox.astype(img.dtype)

```








# 3 关于dataLoader

```

from gluoncv.data.batchify import Tuple, Append
from mxnet.gluon.data import DataLoader

batch_size = 2  # for tutorial, we use smaller batch-size
num_workers = 0  # you can make it larger(if your CPU has more cores) to accelerate data loading

# behavior of batchify_fn: stack images, and pad labels
batchify_fn = Tuple(Append(), Append())
train_loader = DataLoader(train_dataset.transform(train_transform), batch_size, shuffle=True,
                          batchify_fn=batchify_fn, last_batch='rollover', num_workers=num_workers)
val_loader = DataLoader(val_dataset.transform(val_transform), batch_size, shuffle=False,
                        batchify_fn=batchify_fn, last_batch='keep', num_workers=num_workers)

for ib, batch in enumerate(train_loader):
    if ib > 3:
        break
    print('data 0:', batch[0][0].shape, 'label 0:', batch[1][0].shape)
    print('data 1:', batch[0][1].shape, 'label 1:', batch[1][1].shape)


```






