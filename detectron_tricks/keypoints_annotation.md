1 setup your docker container for working 

```
sudo docker stop myMongoDB
sudo docker rm myMongoDB

sudo docker run -d --name myMongoDB mongo

sudo docker stop anno
sudo docker rm anno
sudo nvidia-docker run --link=myMongoDB:mongodb --name anno \
 -v /data/el-train/TRAIN/mxnet_yinlieClassify/anno:/anno \
 -v /data/el-train/TRAIN/mxnet_yinlieClassify/anno/annoImg:/data \
 -p 14197:14197 \
 -p 6008:6008 \
 -it anxu829/gluoncv:withlab /bin/bash
```

2 stet up your annotation_tools 

1. git clone https://github.com/visipedia/annotation_tools.git
2. set up run.py
```

def main():
  args = parse_args()
  app.run(port=args.port, host = '0.0.0.0'  , debug=args.debug)

```
3 set up annotation_tools.py

```
#https://www.thachmai.info/2015/05/10/docker-container-linking-mongo-node/
#cat /etc/hosts
#env | grep MONGODB
app = Flask(__name__)
app.config.from_object('annotation_tools.default_config')
app.config['MONGO_URI'] = "mongodb://172.17.0.14:27017/myData"

```



4 gen json for annotation
```
keypoints = [
    "left",
    "right",
    "middle",
]

keypoints_style = [
    "#00FF00",
    "#00FFFF",
    "#FFFF00"
]

categories = [{
    "id" : "0",
    "name" : "black mouse",
    "supercategory" : "mouse",
    "keypoints" : keypoints,
    "keypoints_style" : keypoints_style
}
]


import glob
import os
import cv2

image_dir_regx = '/data/el-train/TRAIN/mxnet_yinlieClassify/anno/annoImg/*.jpg'
images = []
for image_path in glob.glob(image_dir_regx):
    image_file_name = os.path.basename(image_path)
    image_height, image_width = cv2.imread(image_path, 0).shape
    image_id = os.path.splitext(image_file_name)[0]
    image_url = "http://localhost:6008/" + image_file_name
    print(image_url)
    images.append({
        "id" : image_id,
        "height": image_height,
        "width": image_width,
        "file_name" : image_file_name,
        "coco_url" : image_url
    })


import json

dataset = {
    "categories" : categories,
    "images" : images,
    "annotations" : [],
    "licenses" : []
}

dataset_file_path = "/data/el-train/TRAIN/mxnet_yinlieClassify/anno/annoImg.json"
with open(dataset_file_path, 'w') as f:
    json.dump(dataset, f)

```

5 run 
1. start docker 
2. install requirement
3. start HTTPSERVER
4. load json
   python -m annotation_tools.db_dataset_utils --action load \
--dataset ~/Downloads/annotations/person_keypoints_val2017.json \
--normalize
5. start annotation_tools
6. export json
   python -m annotation_tools.db_dataset_utils --action export \
--output ~/Downloads/annotations/updated_person_keypoints_val2017.json \
--denormalize
