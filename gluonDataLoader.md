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
```

6 骚操作大全：
1 
```

class VOCDetection(VisionDataset):
    CLASSES = ('aeroplane', 'bicycle', 'bird', 'boat', 'bottle', 'bus', 'car',
               'cat', 'chair', 'cow', 'diningtable', 'dog', 'horse', 'motorbike',
               'person', 'pottedplant', 'sheep', 'sofa', 'train', 'tvmonitor')
    @property
    def classes(self):
        """Category names."""
        return type(self).CLASSES

```






#### 2 关于 VOCDetection 的继承 ：

VOCDetecion <-  .../gluoncv/data/base.py(VisionDataset) <- .../mxnet/python/mxnet/gluon/data/dataset.py(Dataset)


而关于 Dataset 要具有 transform的功能


#### 3 关于 VisionDataset











