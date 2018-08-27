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
  
  ```
