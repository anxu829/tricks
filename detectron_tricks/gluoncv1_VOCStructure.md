1 VOCdevkit 
  对数据集合： xml 和 jpg 都在对应的文件夹，区别 train 和 test 只有靠txt
  -> VOC2007
    -> Annotations
      -> *.xml
    -> JPEGImages
      -> *.jpg
    -> ImageSets
      -> Main
        -> 1 trainval.txt
        -> 2 test.txt
  -> VOC2012
    -> Annotations
      -> *.xml
    -> JPEGImages
      -> *.jpg
    -> ImageSets
      -> Main
        -> 1 trainval.txt
        -> 2 test.txt
 
 
 2 Gluoncv DataLoader
 
 1 要点：数据按照格式排放
 2 读取数据的核心在使用txt
 
 读取代码
```

train_dataset = VOCDetection(splits=[(2007, 'trainval'), (2012, 'trainval')])

val_dataset = VOCDetection(splits=[(2007, 'test')])

```

难点

```
dataset.transform(加入的变换是对观测的每一个做变换).transform_first(对每个batch的第一项做变换)

# gluon-> data-> datasets
class _LazyTransformDataset(Dataset):
    """Lazily transformed dataset."""
    def __init__(self, data, fn):
        self._data = data
        self._fn = fn

    def __len__(self):
        return len(self._data)

    def __getitem__(self, idx):
        item = self._data[idx]
        if isinstance(item, tuple):
            return self._fn(*item)
        return self._fn(item)
        

def transform(self, fn, lazy=True):

    trans = _LazyTransformDataset(self, fn)
    if lazy:
        return trans
    return SimpleDataset([i for i in trans])

def transform_first(self, fn, lazy=True):

    def base_fn(x, *args):
        if args:
            return (fn(x),) + args
        return fn(x)
    return self.transform(base_fn, lazy)


```

 
代码核心
 
 ```

 root=os.path.join('~', '.mxnet', 'datasets', 'voc')
 splits=((2007, 'trainval'), (2012, 'trainval'))
 self._items = self._load_items(splits)

 def _load_items(self, splits):
    """Load individual image indices from splits."""
    ids = []
    for year, name in splits:
        root = os.path.join(self._root, 'VOC' + str(year))
        lf = os.path.join(root, 'ImageSets', 'Main', name + '.txt')
        with open(lf, 'r') as f:
            ids += [(root, line.strip()) for line in f.readlines()]
    return ids

 ```
 
 
 ```
 
[docs]class VOCDetection(VisionDataset):
    """Pascal VOC detection Dataset.

    Parameters
    ----------
    root : str, default '~/mxnet/datasets/voc'
        Path to folder storing the dataset.
    splits : list of tuples, default ((2007, 'trainval'), (2012, 'trainval'))
        List of combinations of (year, name)
        For years, candidates can be: 2007, 2012.
        For names, candidates can be: 'train', 'val', 'trainval', 'test'.
    transform : callable, defaut None
        A function that takes data and label and transforms them. Refer to
        :doc:`./transforms` for examples.

        A transform function for object detection should take label into consideration,
        because any geometric modification will require label to be modified.
    index_map : dict, default None
        In default, the 20 classes are mapped into indices from 0 to 19. We can
        customize it by providing a str to int dict specifying how to map class
        names to indicies. Use by advanced users only, when you want to swap the orders
        of class labels.
    preload_label : bool, default True
        If True, then parse and load all labels into memory during
        initialization. It often accelerate speed but require more memory
        usage. Typical preloaded labels took tens of MB. You only need to disable it
        when your dataset is extreamly large.
    """
    CLASSES = ('aeroplane', 'bicycle', 'bird', 'boat', 'bottle', 'bus', 'car',
               'cat', 'chair', 'cow', 'diningtable', 'dog', 'horse', 'motorbike',
               'person', 'pottedplant', 'sheep', 'sofa', 'train', 'tvmonitor')

    def __init__(self, root=os.path.join('~', '.mxnet', 'datasets', 'voc'),
                 splits=((2007, 'trainval'), (2012, 'trainval')),
                 transform=None, index_map=None, preload_label=True):
        super(VOCDetection, self).__init__(root)
        self._im_shapes = {}
        self._root = os.path.expanduser(root)
        self._transform = transform
        self._splits = splits
        self._items = self._load_items(splits)
        self._anno_path = os.path.join('{}', 'Annotations', '{}.xml')
        self._image_path = os.path.join('{}', 'JPEGImages', '{}.jpg')
        self.index_map = index_map or dict(zip(self.classes, range(self.num_class)))
        self._label_cache = self._preload_labels() if preload_label else None

    def __str__(self):
        detail = ','.join([str(s[0]) + s[1] for s in self._splits])
        return self.__class__.__name__ + '(' + detail + ')'

    @property
    def classes(self):
        """Category names."""
        return type(self).CLASSES

    def __len__(self):
        return len(self._items)

    def __getitem__(self, idx):
        img_id = self._items[idx]
        img_path = self._image_path.format(*img_id)
        label = self._label_cache[idx] if self._label_cache else self._load_label(idx)
        img = mx.image.imread(img_path, 1)
        if self._transform is not None:
            return self._transform(img, label)
        return img, label

    def _load_items(self, splits):
        """Load individual image indices from splits."""
        ids = []
        for year, name in splits:
            root = os.path.join(self._root, 'VOC' + str(year))
            lf = os.path.join(root, 'ImageSets', 'Main', name + '.txt')
            with open(lf, 'r') as f:
                ids += [(root, line.strip()) for line in f.readlines()]
        return ids

    def _load_label(self, idx):
        """Parse xml file and return labels."""
        img_id = self._items[idx]
        anno_path = self._anno_path.format(*img_id)
        root = ET.parse(anno_path).getroot()
        size = root.find('size')
        width = float(size.find('width').text)
        height = float(size.find('height').text)
        if idx not in self._im_shapes:
            # store the shapes for later usage
            self._im_shapes[idx] = (width, height)
        label = []
        for obj in root.iter('object'):
            difficult = int(obj.find('difficult').text)
            cls_name = obj.find('name').text.strip().lower()
            if cls_name not in self.classes:
                continue
            cls_id = self.index_map[cls_name]
            xml_box = obj.find('bndbox')
            xmin = (float(xml_box.find('xmin').text) - 1)
            ymin = (float(xml_box.find('ymin').text) - 1)
            xmax = (float(xml_box.find('xmax').text) - 1)
            ymax = (float(xml_box.find('ymax').text) - 1)
            try:
                self._validate_label(xmin, ymin, xmax, ymax, width, height)
            except AssertionError as e:
                raise RuntimeError("Invalid label at {}, {}".format(anno_path, e))
            label.append([xmin, ymin, xmax, ymax, cls_id, difficult])
        return np.array(label)

    def _validate_label(self, xmin, ymin, xmax, ymax, width, height):
        """Validate labels."""
        assert 0 <= xmin < width, "xmin must in [0, {}), given {}".format(width, xmin)
        assert 0 <= ymin < height, "ymin must in [0, {}), given {}".format(height, ymin)
        assert xmin < xmax <= width, "xmax must in (xmin, {}], given {}".format(width, xmax)
        assert ymin < ymax <= height, "ymax must in (ymin, {}], given {}".format(height, ymax)

    def _preload_labels(self):
        """Preload all labels into memory."""
        logging.debug("Preloading %s labels into memory...", str(self))
        return [self._load_label(idx) for idx in range(len(self))]
```


3 VOCDataLoader

```
batchify_fn = Tuple(Append(), Append())

train_loader = DataLoader(train_dataset.transform(train_transform), batch_size, shuffle=True,
                          batchify_fn=batchify_fn, last_batch='rollover', num_workers=num_workers)

val_loader = DataLoader(val_dataset.transform(val_transform), batch_size, shuffle=False,
                        batchify_fn=batchify_fn, last_batch='keep', num_workers=num_workers)

```

batchify
```
def default_batchify_fn(data):
    """Collate data into batch."""
    if isinstance(data[0], nd.NDArray):
        return nd.stack(*data)
    elif isinstance(data[0], tuple):
        data = zip(*data)
        return [default_batchify_fn(i) for i in data]
    else:
        data = np.asarray(data)
        return nd.array(data, dtype=data.dtype)
```
