## about float
```python
x = np.nan
float(x) # correct 
x = None
float(x) # wrong : float() argument must be a string or a number, not 'NoneType'

```


## about executing file
```
if not os.path.exists(labels_file):
    !../data/ilsvrc12/get_ilsvrc_aux.sh
```
