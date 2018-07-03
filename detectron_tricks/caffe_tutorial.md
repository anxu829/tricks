Caffe的模型结构
  一个深度学习模型是由三个部分组成:
    网络结构配置文件
      训练网络结构train.prototxt、测试网络结构test.prototxt及实施网络结构deploy.prototxt
    网络权重参数文件：该文件用于保存网络各层的权重值，是以*.caffemodel格式存储的文件
    训练超参数文件: 比如solver.prototxt
    
    ```
    # train your model
    solver = caffe.SGDSolver('solver.prototxt') # 调用训练器
    solver.solve() # 直接训练模型
    ```
    
    通过网络权重参数及网络结构配置文件调用网络：
    net = caffe.Net('deploy.prototxt', '*.caffemodel',caffe.TEST)
    
    
    通过训练超参数文件及网络权重参数文件进行权重预设的网络训练
