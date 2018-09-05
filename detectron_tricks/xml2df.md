```
def create_df(xmlroot):
    '''
    create_df：将xml文件中的信息提取出来，做成一个数据框
    xmlroot：原xml文件夹
    '''


    labellist = [data for data in glob.glob(xmlroot + '/*')]
    labelname = [label.split('\\')[-1] for label in labellist]

    name = []
    labelx = []
    xmin, ymin, xmax, ymax = [], [], [], []

    for i in range(len(labelname)):
        tree = ET.ElementTree(file=labellist[i])

        root = tree.getroot()

        for elem in root.iter('xmin'):
            name.append(labelname[i])
            xmin.append(elem.text)
        for elem in root.iter('ymin'):
            ymin.append(elem.text)
        for elem in root.iter('xmax'):
            xmax.append(elem.text)
        for elem in root.iter('ymax'):
            ymax.append(elem.text)
        for elem in root.iter('name'):
            labelx.append(elem.text)

    data = {"fileName" : name,
            "xmin" : xmin,
            "xmax" : xmax,
            "ymin" : ymin,
            "ymax" : ymax,
            "category" : labelx}
    data = DataFrame(data)
    return data
```
