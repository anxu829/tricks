- one - one
```python
import statsmodels.api as sm
from statsmodels.stats.outliers_influence import summary_table
data_anova = pd.DataFrame({"y":hist_consider_water,"x":1}).append(pd.DataFrame({"y":curr_consider_water,"x":0}))
regr = sm.OLS(data_anova['y'], data_anova['x'])
res = regr.fit() 
st, data, ss2 = summary_table(res, alpha=0.05)

fitted_values = data[:,2]
```
- multivariate

```python
import pandas as pd
data = pd.read_csv("")
y = data['y']
X = data[['x1','x2']]
regr = sm.OLS(data_anova['y'], data_anova['x'])
res = regr.fit() 
res.summary()
```
