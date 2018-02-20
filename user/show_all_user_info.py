# -*- coding:utf-8 -*-  
import json

f = file("/usr/local/shadowsocksr/mudb.json");

json = json.load(f);

print "用户名\t\t端口\t加密\t\t密码\t\t协议"

for x in json:
  print "%-8s\t%-4s\t%-8s\t%-8s\t%-8s" %(x[u"user"],x[u"port"],x[u"method"],x[u"passwd"],x[u"protocol"])
f.close();
