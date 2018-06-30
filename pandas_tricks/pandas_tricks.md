# pandas_tricks

### config
```
pd.set_option('display.height', 1000)
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)
```

### drop cols
```
 df.drop(['B', 'C'], axis=1)
```

### 关于NaN

pandas 中df 显示为NaN的位置，内部的值都是np.nan
float(np.nan) 返回nan （type(nan)为float）



### 数据读取：
	- datatime 处理方法
	- useCols 节省内存
	- 直接使用dtype
	- skip rows 抽样
		df = pd.read_csv(
         		filename,
         		header=0,
         		skiprows=lambda i: i>0 and random.random() > p
		)

		import pandas as pd
		import numpy as np

		filename = 'hugedatafile.csv'
		nlinesfile = 10000000
		nlinesrandomsample = 10000
		lines2skip = np.random.choice(np.arange(1,nlinesfile+1), (nlinesfile-nlinesrandomsample), replace=False)
		df = pd.read_csv(filename, skiprows=lines2skip)

	- exec+ groupby
	- 分层抽样

### groupby 的使用：
	- 用于去重（一维使用value_counts()）
	- 用于拆分数据
	- 搭配apply处理复杂数据

### transform 的使用：分组标准化处理
	- groupby + transform

### map,apply,applymap
	- map 一个dict，map一个匿名函数

### multiIndex + stack + shift 抽取时间滞后项

### loc 和 iloc的定位和赋值

### str 函数的使用技巧

### 时间类型数据的读入与处理

### query 查询

### nlargest 函数的使用

### rename 函数

### reindex 的使用

### str -> timestamp 方法

###  where

###  to_pickle 加速存储
###  rolling , rolling_apply , expanding 纵向处理，shift拯救世界

### df.name 来拿行号

### isin 函数

### apply时使用name来获得列名
		x.apply(lambda x: str(x.name)+":" + x+":1")

### groupBY +　size函数避免使用count


### 关于pandas 换序


### pandas pd.concat(axis = 1)
		
