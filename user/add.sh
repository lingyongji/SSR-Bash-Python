#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin


#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ];then
    OS=CentOS
    [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
    [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
    [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
    elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ];then
    OS=CentOS
    CentOS_RHEL_version=6
    elif [ -n "$(grep bian /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Debian' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
    elif [ -n "$(grep Deepin /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Deepin' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
    elif [ -n "$(grep Ubuntu /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Ubuntu' -o -n "$(grep 'Linux Mint' /etc/issue)" ];then
    OS=Ubuntu
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Ubuntu_version=$(lsb_release -sr | awk -F. '{print $1}')
    [ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_version=16
else
    echo "Does not support this OS, Please contact the author! "
    kill -9 $$
fi


#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }


echo "你选择了添加用户"
echo ""
while :; do echo
    read -p "是否批量添加(y/n):" yorn
    if [[ ! $yorn =~ ^[y,n]$ ]];then
        echo "输入错误! 请输入y或者n!"
    else
        if [[ $yorn == "y" ]];then
            echo "端口范围为0-65535，请务必保证最大端口在该范围内"
            read -p "输入批量数量：" portsnum
            read -p "输入起始端口：" startport
            break
        else
            portsnum=1
            read -p "输入用户名： " uname
            read -p "输入端口： " uport
            read -p "输入密码： " upass
            break
        fi
    fi
done


echo ""
echo "加密方式"
echo '1.none'
echo '2.aes-128-ctr'
echo '3.aes-192-ctr'
echo '4.aes-256-ctr'
echo '5.aes-128-cfb'
echo '6.aes-192-cfb'
echo '7.aes-256-cfb'
echo '8.rc4'
echo '9.rc4-md5'
echo '10.rc4-md5-6'
echo '11.salsa20'
echo '12.chacha20'
echo '13.xsalsa20'
echo '14.xchacha20'
echo '15.chacha20-ietf'
while :; do echo
    read -p "输入加密方式： " um
    if [[ $um -ge 1 && $um -le 15 ]]; then
        break
    else
        echo "输入错误! 请输入正确的数字!"
    fi
done

if [[ $um == 1 ]];then
    um1="none"
fi
if [[ $um == 2 ]];then
    um1="aes-128-ctr"
fi
if [[ $um == 3 ]];then
    um1="aes-192-ctr"
fi
if [[ $um == 4 ]];then
    um1="aes-256-ctr"
fi
if [[ $um == 5 ]];then
    um1="aes-128-cfb"
fi
if [[ $um == 6 ]];then
    um1="aes-192-cfb"
fi
if [[ $um == 7 ]];then
    um1="aes-256-cfb"
fi
if [[ $um == 8 ]];then
    um1="rc4"
fi
if [[ $um == 9 ]];then
    um1="rc4-md5"
fi
if [[ $um == 10 ]];then
    um1="rc4-md5-6"
fi
if [[ $um == 11 ]];then
    um1="salsa20"
fi
if [[ $um == 12 ]];then
    um1="chacha20"
fi
if [[ $um == 13 ]];then
    um1="xsalsa20"
fi
if [[ $um == 14 ]];then
    um1="xchacha20"
fi
if [[ $um == 15 ]];then
    um1="chacha20-ietf"
fi


echo "协议方式"
echo '1.origin'
echo '2.auth_aes128_md5'
echo '3.auth_aes128_sha1'
echo '4.auth_chain_a'
echo '5.auth_chain_b'
echo '6.auth_chain_c'
echo '7.auth_chain_d'
echo '8.auth_chain_e'
echo '9.auth_chain_f'
while :; do echo
    read -p "输入协议方式： " ux
    if [[ ! $ux =~ ^[1-9]$ ]]; then
        echo "输入错误! 请输入正确的数字!"
    else
        break
    fi
done

if [[ $ux == 1 ]];then
    ux1="origin"
fi
if [[ $ux == 2 ]];then
    ux1="auth_aes128_md5"
fi
if [[ $ux == 3 ]];then
    ux1="auth_aes128_sha1"
fi
if [[ $ux == 4 ]];then
    ux1="auth_chain_a"
fi
if [[ $ux == 5 ]];then
    ux1="auth_chain_b"
fi
if [[ $ux == 6 ]];then
    ux1="auth_chain_c"
fi
if [[ $ux == 7 ]];then
    ux1="auth_chain_d"
fi
if [[ $ux == 8 ]];then
    ux1="auth_chain_e"
fi
if [[ $ux == 9 ]];then
    ux1="auth_chain_f"
fi


echo "混淆方式"
echo '1.plain'
echo '2.http_simple'
echo '3.http_post'
echo '4.tls1.2_ticket_auth'
while :; do echo
    read -p "输入混淆方式： " uo
    if [[ ! $uo =~ ^[1-4]$ ]]; then
        echo "输入错误! 请输入正确的数字!"
    else
        break
    fi
done

if [[ $uo != 1 ]];then
    while :; do echo
        read -p "是否兼容原版混淆（y/n）： " ifobfscompatible
        if [[ ! $ifobfscompatible =~ ^[y,n]$ ]]; then
            echo "输入错误! 请输入y或者n!"
        else
            break
        fi
    done
fi

if [[ $uo == 1 ]];then
    uo1="plain"
fi
if [[ $uo == 2 ]];then
    uo1="http_simple"
fi
if [[ $uo == 3 ]];then
    uo1="http_post"
fi
if [[ $uo == 4 ]];then
    uo1="tls1.2_ticket_auth"
fi

if [[ $ifobfscompatible == y ]]; then
    uo1=${uo1}"_compatible"
fi


while :; do echo
    read -p "输入流量限制(只需输入数字，单位：GB)： " ut
    if [[ "$ut" =~ ^(-?|\+?)[0-9]+(\.?[0-9]+)?$ ]];then
        break
    else
        echo '输入错误!'
    fi
done


while :; do echo
    read -p "是否开启端口限速（y/n）： " iflimitspeed
    if [[ ! $iflimitspeed =~ ^[y,n]$ ]]; then
        echo "输入错误! 请输入y或者n!"
    else
        break
    fi
done


if [[ $iflimitspeed == y ]]; then
    while :; do echo
        read -p "输入端口总限速(只需输入数字，单位：KB/s)： " us
        if [[ "$us" =~ ^(-?|\+?)[0-9]+(\.?[0-9]+)?$ ]];then
            break
        else
            echo '输入错误!'
        fi
    done
fi


while [ $portsnum -gt 0 ];do
    if [[ $yorn == "y" ]];then
        uname="p"$startport
        uport=$startport
        let startport++
        let portsnum--
    else
        portsnum=0
    fi
    
    #Set Firewalls
    if [[ ${OS} =~ ^Ubuntu$|^Debian$ ]];then
        iptables-restore < /etc/iptables.up.rules
        clear
        iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $uport -j ACCEPT
        iptables -I INPUT -m state --state NEW -m udp -p udp --dport $uport -j ACCEPT
        iptables-save > /etc/iptables.up.rules
    fi
    
    if [[ ${OS} == CentOS ]];then
        if [[ $CentOS_RHEL_version == 7 ]];then
            iptables-restore < /etc/iptables.up.rules
            iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $uport -j ACCEPT
            iptables -I INPUT -m state --state NEW -m udp -p udp --dport $uport -j ACCEPT
            iptables-save > /etc/iptables.up.rules
        else
            iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $uport -j ACCEPT
            iptables -I INPUT -m state --state NEW -m udp -p udp --dport $uport -j ACCEPT
            /etc/init.d/iptables save
            /etc/init.d/iptables restart
        fi
    fi
    
    
    #Run ShadowsocksR
    echo "用户添加成功！用户信息如下："
    cd /usr/local/shadowsocksr
    if [[ $yorn == "n" ]];then
        if [[ $iflimitspeed == y ]]; then
            python mujson_mgr.py -a -u $uname -p $uport -k $upass -m $um1 -O $ux1 -o $uo1 -t $ut -S $us
        else
            python mujson_mgr.py -a -u $uname -p $uport -k $upass -m $um1 -O $ux1 -o $uo1 -t $ut
        fi
    else
        if [[ $iflimitspeed == y ]]; then
            python mujson_mgr.py -a -u $uname -p $uport -m $um1 -O $ux1 -o $uo1 -t $ut -S $us
        else
            python mujson_mgr.py -a -u $uname -p $uport -m $um1 -O $ux1 -o $uo1 -t $ut
        fi
    fi
    
    
    SSRPID=$(ps -ef|grep 'python server.py m' |grep -v grep |awk '{print $2}')
    if [[ $SSRPID == "" ]]; then
        
        if [[ ${OS} =~ ^Ubuntu$|^Debian$ ]];then
            iptables-restore < /etc/iptables.up.rules
        fi
        
        bash /usr/local/shadowsocksr/logrun.sh
        echo "ShadowsocksR服务器已启动"
    fi
done

Randpassword() {
    index=0
    pass=""
    for i in {a..z}; do arr[index]=$i; index=`expr ${index} + 1`; done
    for i in {A..Z}; do arr[index]=$i; index=`expr ${index} + 1`; done
    for i in {0..9}; do arr[index]=$i; index=`expr ${index} + 1`; done
    for i in {1..10}; do pass="$pass${arr[$RANDOM%$index]}"; done
    echo $pass
}
