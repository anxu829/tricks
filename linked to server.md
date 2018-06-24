
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
