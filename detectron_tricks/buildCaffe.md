# 1 solve hdf5 problem
  ## 1.1 alter your file
    ```
    1 Makefile.config.example -> Makefile.config
    2 change the following line
      
      INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial/
      LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu/hdf5/serial
      
    3 alter your Makefile
      LIBRARIES += glog gflags protobuf leveldb snappy \
        lmdb \
        boost_system \
        hdf5_serial_hl hdf5_serial \
        opencv_core opencv_highgui opencv_imgproc opencv_imgcodecs
    4 change you CMakeLists
      
      option(CPU_ONLY "Build Caffe without GPU support" OFF)
      option(BUILD_PYTHON "Build Python wrapper" ON)
      option(BUILD_MATLAB "Build Matlab wrapper" OFF)
      option(BUILD_EXAMPLES "Build examples" OFF)
      option(BUILD_SHARED_LIBS "Build SHARED libs if ON and STATIC otherwise" OFF)
    ```
    
  ## 1.2 install libs
  ```
      sudo apt-get install libhdf5-10
      sudo apt-get install libhdf5-serial-dev
      sudo apt-get install libhdf5-dev
      sudo apt-get install libhdf5-cpp-11
      find /usr -iname "*hdf5.h*"
      /usr/include/hdf5/serial/hdf5.h
      export CPATH="/usr/include/hdf5/serial/"
      

   

  ```
  
# 2 build caffe
  ```
  1 make clean && mkdir build
  2 cd build && cmake .. && make all && make pycaffe &&  make install && make runtest
  
  
  
  
  
3 flow：
3.1
mv  caffe-cedn/src/caffe/layers/unpooling*  ~/caffe/src/caffe/layers/
mv  caffe-cedn/src/caffe/test/*unpooling* ~/caffe/src/caffe/test/
mv  caffe-cedn/src/caffe/layers/upsampling*  ~/caffe/src/caffe/layers/
mv  caffe-cedn/src/caffe/test/*upsampling* ~/caffe/src/caffe/test/


3.2 
alter ~/caffe/src/caffe/proto/caffe.proto

```
enum LayerType {
  UNPOOLING = 40;
  UPSAMPLING = 38;
}

optional UnpoolingParameter unpooling_param = 43;
optional UpsamplingParameter upsampling_param = 41;


// Message that stores parameters used by UpsamplingLayer
message UpsamplingParameter {
  // Kernel size is given as a single value for equal
  // dimensions in height and width or as Y, X pairs.
  optional uint32 kernel_size = 1 [default = 2]; // The kernel size (square)
  optional uint32 kernel_h = 2 [default = 2]; // The kernel height
  optional uint32 kernel_w = 3 [default = 2]; // The kernel width
}



// Message that stores parameters used by UnpoolingLayer
message UnpoolingParameter {
  enum UnpoolMethod {
    MAX = 0;
    AVE = 1;
    STOCHASTIC = 2;
  }
  optional UnpoolMethod unpool = 1 [default = MAX]; // The unpooling method
  // Pad, kernel size, and stride are all given as a single value for equal
  // dimensions in height and width or as Y, X pairs.
  optional uint32 pad = 4 [default = 0]; // The padding size (equal in Y, X)
  optional uint32 pad_h = 9 [default = 0]; // The padding height
  optional uint32 pad_w = 10 [default = 0]; // The padding width
  optional uint32 kernel_size = 2; // The kernel size (square)
  optional uint32 kernel_h = 5; // The kernel height
  optional uint32 kernel_w = 6; // The kernel width
  optional uint32 stride = 3 [default = 1]; // The stride (equal in Y, X)
  optional uint32 stride_h = 7; // The stride height
  optional uint32 stride_w = 8; // The stride width
}


```



3.3 

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ```
