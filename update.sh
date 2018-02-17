#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

echo "1.更新SSR-Bsah"
echo "2.更新SSR"

while :; do echo
    read -p "请选择： " devc
    [ -z "$devc" ] && ssr && break
    if [[ ! $devc =~ ^[1-2]$ ]]; then
        echo "输入错误! 请输入正确的数字!"
    else
        break
    fi
done

if [[ $devc == 1 ]];then
    rm -rf /usr/local/bin/ssr
    cd /usr/local/SSR-Bash-Python/
    git pull
    wget -N --no-check-certificate -O /usr/local/bin/ssr https://raw.githubusercontent.com/lingyongji/SSR-Bash-Python/master/ssr
    chmod +x /usr/local/bin/ssr
    echo "SSR-Bash升级成功！"
    ssr
fi

if [[ $devc == 2 ]];then
    cd /usr/local/shadowsocksr
    git pull
    bash /usr/local/shadowsocksr/stop.sh
    bash /usr/local/shadowsocksr/logrun.sh
	iptables-restore < /etc/iptables.up.rules
	echo "SSR升级成功！"
	ssr
fi
