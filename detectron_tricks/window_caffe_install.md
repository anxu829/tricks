  # download requirements
  - ## install vc2013 ( offline - version )
  - ## for gtx10+ , you need download cuda9.0 (cuda8.0 could not support gtx10+)
  - ## download cudnn and upzip them to your cuda folder
  - ## download caffe-windows (i will upload to this project)
  
# uozip caffe-windows:
  - ## modify /windows/CommonSettings.props
  
    - ### attention : cudnn path is the path of your cudnn folder contains floder of 'cuda'
     ```
     <CudaVersion>9.0</CudaVersion>
     <PythonSupport>true</PythonSupport>
     <CuDnnPath>C:\Users\an\Documents\tools\cudnn-9.0-windows10-x64-v7.1\</CuDnnPath>
     <PythonDir>C:\ProgramData\Anaconda2\</PythonDir>
     ```
  - ## open 'Caffe.sln'
    - ### change build mode to 'release':
       - 生成 -> 配置管理器 -> release x64
       - 对右侧的libcaffe: 进行生成
          - this will call NuGet to download nessessary pacakge in your folder
          - then build will failure due to some problems ( will be solve later)
       - solving problems:
          - problem called by opencv
          
          ```
          https://blog.csdn.net/u013277656/article/details/75040459
          第一步：项目->管理NuGet程序包->更新，此时可以看到opencv后面有更新的按钮，点击更新为opencv2.4.11。 
          第二步：
            选择解决方案的每一个项目，右键单击，卸载项目 
            卸载之后，编辑vcxproj文件
            将文件里面所有的OpenCV.2.4.10都换成OpenCV.2.4.11，重新加载项目，再进行编译
          ```
          
          - problem called by  ‘error : too few arguments in function call’
          ```
            https://blog.csdn.net/mao_hui_fei/article/details/80326464

            change the context around 114 line of cudnn.hpp in \caffe\caffe-master\include\caffe\util

            template <typename Dtype>
            inline void setConvolutionDesc(cudnnConvolutionDescriptor_t* conv,
                cudnnTensorDescriptor_t bottom, cudnnFilterDescriptor_t filter,
                int pad_h, int pad_w, int stride_h, int stride_w) {
            #if CUDNN_VERSION_MIN(6, 0, 0)
              CUDNN_CHECK(cudnnSetConvolution2dDescriptor(*conv,
                  pad_h, pad_w, stride_h, stride_w, 1, 1, CUDNN_CROSS_CORRELATION,
                  dataType<Dtype>::type));
            #else
                CUDNN_CHECK(cudnnSetConvolution2dDescriptor(*conv,
                  pad_h, pad_w, stride_h, stride_w, 1, 1, CUDNN_CROSS_CORRELATION));
            #endif
          }

         ```
         - problem caused by ‘error C2220: 警告被视为错误 - 没有生成“object”文件 ’
         
         ```
          点击项目，右击选择属性->配置属性->c/c++->常规，将“警告视为错误”的选项改为“否”。就可以！
         ```
