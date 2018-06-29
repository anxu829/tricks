
## ssh 1 ：首先建立一个ssh，用于启动docker
### linked start

  ssh xingdong@202.121.140.1 / cNNOV136
  ssh fxd@10.2.31.107 /Sufe3.1415

### start your docker container
  #### 注意到我这里把docker的8888端口映射到了fxd的8899端口
  cd /data2/xuan
  
  sudo docker images
  
  sudo stop caffe2_jupyter
  
  sudo rm caffe2_jupyter
  
  sudo nvidia-docker run --name caffe2_jupyter -it -v /data2/xuan:/xuan -p 8899:8888 caffe2/caffe2:snapshot-py2-cuda9.0-cudnn7-ubuntu16.04 sh  -c "cd / && jupyter notebook --no-browser --ip 0.0.0.0 --allow-root"


## ssh2  ：再新建一个窗口，把8899端口映射到本地8899端口

  ### 首先把本地 的 8899 和 xidong 的8899对应起来
  ssh -L8899:localhost:8899 xingdong@202.121.140.1 / cNNOV136
  ### 在上条之后，进入到xingdong，和 fxd的 8899 对应起来
  ssh -L8899:localhost:8899 fxd@10.2.31.107  /Sufe3.1415


## screen tricks

- screen -ls  : check links

- screen -r 1598 : link to 1598 dialog

- c-a d : detach

- c-a n : next

- c-a 0-9 : conversation

- c-a c : create new conversation



## other tricks:

### 1 docker tricks

  sudo docker stop detectron
  
  sudo docker rm detectron
  
  sudo nvidia-docker run  --name detectron -it -p 8899:8888 -v /study/detectron/Detectron/tools/infer_simple.py:/detectron/tools/infer_simple.py   -v /study/detectron:/detectron_data  detectron:c2-cuda9-cudnn7   /bin/bash   -c "source ~/.bashrc && source /etc/profile && cd / && jupyter notebook --no-browser --ip 0.0.0.0 --allow-root --port 8888"



### 2 git tricks 
  
  git checkout -b xuan
  
  git checkout master
  
  git branch -d xuan


