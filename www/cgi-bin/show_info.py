#! /usr/bin/env python
# -*- coding: utf-8 -*-
import json
import cgi
import urllib2

#取得本机外网IP
myip = urllib2.urlopen('http://members.3322.org/dyndns/getip').read()
myip=myip.strip()
#加载SSR JSON文件
f = file("/usr/local/shadowsocksr/mudb.json");
json = json.load(f);

# 接受表达提交的数据
form = cgi.FieldStorage() 

# 解析处理提交的数据
getport = form['port'].value
getpasswd = form['passwd'].value
#判断端口是否找到
portexist=0
passwdcorrect=0
#循环查找端口
for x in json:
	#当输入的端口与json端口一样时视为找到
	if(str(x[u"port"]) == str(getport)):
		portexist=1
		if(str(x[u"passwd"]) == str(getpasswd)):
			passwdcorrect=1
			transfer_enable_int = int(x[u"transfer_enable"])/1024/1024;
			d_int = round(int(x[u"d"])/1024/1024,0);
			transfer_unit = "MB"
			d_unit = "MB"
			jsonmethod=str(x[u"method"])
			jsonobfs=str(x[u"obfs"])
			jsonprotocol=str(x[u"protocol"])
			#流量单位转换
			if(transfer_enable_int > 1024):
				transfer_enable_int = transfer_enable_int/1024;
				transfer_unit = "GB"
			if(d_int > 1024):
				d_int = round(d_int/1024);
				d_unit = "GB"
		break

if(portexist==0):
	getport = "未找到此端口，请检查是否输入错误！"
	myip = ""
	transfer_enable_int = ""
	d_int = ""
	transfer_unit = ""
	d_unit = ""
	jsonmethod = ""
	jsonprotocol = ""
	jsonobfs = ""

if(portexist!=0 and passwdcorrect==0):
	getport = "连接密码输入错误，请重试"
	myip = ""
	transfer_enable_int = ""
	d_int = ""
	transfer_unit = ""
	d_unit = ""
	jsonmethod = ""
	jsonprotocol = ""
	jsonobfs = ""


#打印返回的内容
html='''

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="initial-scale=1.0, width=device-width" name="viewport">
    <title>端口信息</title>
    <link href="../css/base.min.css" rel="stylesheet">
</head>
<body>
    <div class="content">
        <div class="content-heading">
            <div class="container">
                <h1 class="heading">&nbsp;&nbsp;端口信息</h1>
            </div>
        </div>
        <div class="content-inner">
            <div class="container">
                <div class="card-wrap">
                    <div class="row">
                        <div class="col-lg-4 col-sm-6">
                            <div class="card card-green">
                                <a class="card-side" href="/"><span class="card-heading">端口信息</span></a>
                                <div class="card-main">
                                    <div class="card-inner">
                                        <p>
                                            <strong>服务器IP：</strong> %s </br></br>
                                            <strong>连接端口：</strong> %s </br></br>
                                            <strong>流量信息：</strong> %s %s / %s %s</br></br>
                                            <strong>加密方式：</strong> %s </br></br>
                                            <strong>协议方式：</strong> %s </br></br>
                                            <strong>混淆方式：</strong> %s
                                        </p>
                                    </div>
                                    <div class="card-action">
                                        <ul class="nav nav-list pull-left">
                                            <li>
                                                <a href="../index.html"><span class="icon icon-check"></span>&nbsp;返回</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="footer">
        <div class="container">
            <p>Function Club&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;【Modified by 天意jily】</p>
        </div>
    </footer>
    <script src="../js/base.min.js" type="text/javascript"></script>
</body>
</html>

'''

print html % (myip,getport,d_int,d_unit,transfer_enable_int,transfer_unit,jsonmethod,jsonprotocol,jsonobfs)

f.close();

