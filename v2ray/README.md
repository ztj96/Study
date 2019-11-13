# <center>v2ray配置</center> #


#一.服务端


环境：Ubuntu 18.04 LTS

下载安装脚本

	wget https://install.direct/go.sh
	sudo bash go.sh

启动服务

	systemctl start v2ray	//启动
	systemctl stop v2ray	//停止
	systemctl restart v2ray	//重启
	systemctl enable v2ray	//开机自启动

防火墙

	sudo ufw status	//查看
	sudo ufw enable
	sudo ufw disable

配置目录

	ubuntu:~$ sudo cat /etc/v2ray/config.json
	{
	    "inbounds": [{
	        "port": 35366,
	        "protocol": "vmess",
	        "settings": {
	            "clients": [{
	                "id": "xxx-xxx-xxx-xxx-xxxx",
	                "level": 1,
	                "alterId": 64
	            }]
	        },
	        "streamSettings": {
	            "network": "tcp",
	            "kcpSettings": {
	                "uplinkCapacity": 5,
	                "downlinkCapacity": 100,
	                "congestion": true,
	                "header": {
	                    "type": "none"
	                }
	            }
	        }
	    }],
	    "outbounds": [{
	        "protocol": "freedom",
	        "settings": {}
	    }]
	}


#二.Android客户端


v2rayNG_1.1.9.apk

按照服务器config.json配置

#三.IOS客户端


下载Kitsunebi或者ShadowRocket(需在美区或者港区AppStore)

按照服务器config.json配置


#四.Windows客户端

v2ray-windows-64.zip

配置config.json，浏览器使用代理打开(协议socks，端口1080)

	{
	  "inbounds": [
	    {
	      "port": 1080,
	      "protocol": "socks",
	      "sniffing": {
	        "enabled": true,
	        "destOverride": ["http", "tls"]
	      },
	      "settings": {
	        "auth": "noauth"
	      }
	    }
	  ],
	  "outbounds": [
	    {
	      "protocol": "vmess",
	      "settings": {
	        "vnext": [
	          {
	            "address": "xxx.xxx",
	            "port": 35366,
	            "users": [
	              {
	                "id": "xxx-xxx-xxx-xxx-xxxx",
	                "alterId": 64
	              }
	            ]
	          }
	        ]
	      },
	      "streamSettings": {
	        "network": "tcp",
	        "kcpSettings": {
	          "uplinkCapacity": 5,
	          "downlinkCapacity": 100,
	          "congestion": true,
	          "header": {
	            "type": "none"
	          }
	        }
	      }
	    }
	  ]
	}


