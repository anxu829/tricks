## 1 将下列内容加入 /etc/hosts文件中

#### windows : C:\Windows\System32\drivers\etc
151.101.76.249 http://global-ssl.fastly.net
192.30.255.113 http://github.com

## 2 刷新DNS缓存 
linux：

sudo /etc/init.d/networking restart

windows：

ipconfig /flushdns
