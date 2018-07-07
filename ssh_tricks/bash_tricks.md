# shell 传递参数
https://www.cnblogs.com/ceshi2016/p/6029931.html

# shell 中使用变量
https://www.cnblogs.com/-beyond/p/8228967.html



  1 container='detectron_tutorial'
  2 image='anxu5829/caffe:caffe_withopencv'
  3 sudo docker stop $container 
  4 sudo docker rm $container
  5 sudo nvidia-docker run --name $container   -it \
  6            -v /data2/xuan/mtcnn:/xuan \
  7            -p $1:$1 $image \                                                                                 
  8            /bin/bash \
  9            -c "cd / && jupyter lab --port $1  --ip 0.0.0.0 --allow-root"
