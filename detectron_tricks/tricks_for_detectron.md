## tricks for detectron

 - 1 about datasets
 
 
 
 
 - data structure
 
  - data is at /data2/xuan/data
   ```
   data
   |_ train2017
   |  |_ <im-1-name>.jpg
   |  |_ ...
   |  |_ <im-N-name>.jpg
   |_ val2017
   |_ ...
   |_ annotations
      |_ instances_train2017.json
      |_ ...
   ```

  - linked your data to datasets

  ```
  mkdir -p $DETECTRON/detectron/datasets/data/coco
  ln -s /path/to/coco_train2014 $DETECTRON/detectron/datasets/data/coco/
  ln -s /path/to/coco_val2014 $DETECTRON/detectron/datasets/data/coco/
  ln -s /path/to/json/annotations $DETECTRON/detectron/datasets/data/coco/annotations
  ```


 - change the config file
 
  - datasets/dataset_catalog.py
  
```
 change location of your data
 'coco_2014_train': {
        IM_DIR:
            _DATA_DIR + '/animals/images',
        ANN_FN:
            _DATA_DIR + '/animals/annotations/train.json'
},
'coco_2014_val': {
        IM_DIR:
            _DATA_DIR + '/animals/images',
        ANN_FN:
            _DATA_DIR + '/animals/annotations/val.json'
},
 
 
 ```
  
  - change your yaml file
```
 TRAIN:
  WEIGHTS: pretrained_models/ImageNetPretrained/MSRA/R-50.pkl
  DATASETS: ('coco_2014_train',)
  SCALES: (500,)
  SNAPSHOT_ITERS: 5000
  MAX_SIZE: 833
  BATCH_SIZE_PER_IM: 256
  RPN_PRE_NMS_TOP_N: 2000  # Per FPN level
TEST:
  DATASETS: ('coco_2014_val',)
  SCALES: (500,)
  MAX_SIZE: 833
  NMS: 0.5
  RPN_PRE_NMS_TOP_N: 1000  # Per FPN level
  RPN_POST_NMS_TOP_N: 1000
  FORCE_JSON_DATASET_EVAL: True
```
 
 
 - 2 about the structure of json:
 
 
 
 
 - 2 about usage of detectron : train  
 
 - 3 about logic of detectron : config
 
 - 4 about saving / loading / reusing your model 
 
