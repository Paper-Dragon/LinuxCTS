#!/usr/bin/env bash

# 版本信息
VERSION="1.0.0"
LOG_FILE="/var/log/linuxcts.log"

# 初始化日志
init_log() {
    mkdir -p $(dirname $LOG_FILE)
    echo "=== LinuxCTS Script v$VERSION ===" >> $LOG_FILE
    echo "Start Time: $(date)" >> $LOG_FILE
}

# 错误处理
handle_error() {
    echo -e "${RedBG}Error: $1${Font}" | tee -a $LOG_FILE
    exit 1
}

# 检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        handle_error "$1 command not found"
    fi
}


#安装依赖
sys_install(){
    echo -e "${RedBG}检查系统依赖...${Font}" | tee -a $LOG_FILE
    
    # 安装wget
    if ! type wget >/dev/null 2>&1; then
        echo -e "${RedBG}wget 未安装，准备安装！${Font}" | tee -a $LOG_FILE
        if ! apt-get install -y wget &>> $LOG_FILE; then
            handle_error "Failed to install wget"
        fi
        echo -e "${Green}wget 安装成功${Font}" | tee -a $LOG_FILE
    fi

    # 安装curl
    if ! type curl >/dev/null 2>&1; then
        echo -e "${RedBG}curl 未安装，准备安装！${Font}" | tee -a $LOG_FILE
        if ! apt-get install -y curl &>> $LOG_FILE; then
            handle_error "Failed to install curl"
        fi
        echo -e "${Green}curl 安装成功${Font}" | tee -a $LOG_FILE
    fi
}



#脚本菜单
start_linux(){
    clear
    echo -e "${GreenBG}您计算机所在的国家地区:${Font} ${Green} ${ipdz} ${Font}"
    headers
    # echo -en "=  ${Green}11${Font}  " && gpt_style_output 'VPS信息和性能测试 VPS information test'
    table_linux="=  ${Green}11${Font}  Linux信息和性能测试 VPS information test
=  ${Green}12${Font}  Bench系统性能测试  Bench performance test  
=  ${Green}13${Font}  Linux常用工具安装  Linux utility function  
=  ${Green}14${Font}  Linux路由追踪检测  Linux traceroute test  
=  ${Green}15${Font}  Ubuntu 新安装系统初始化配置  Initial configuration of a newly Ubuntu system  
=
=  ${Green}21${Font}  Linux修改交换内存  Modify swap memory  
=  ${Green}22${Font}  Linux修改服务器DNS  Modify server DNS  
=  ${Green}23${Font}  流媒体区域限制测试  Streaming media testing  
=  ${Green}24${Font}  Linux系统bbr-tcp加速  System bbr-tcp speed up  
=  ${Green}25${Font}  Linux网络重装dd系统  Network reloading system  
=
=  ${Green}99${Font}  退出当前脚本  Exit the current script  
====================================================="
    echo -e "$table_linux"
    echo -e -n "${Green}请输入对应功能的${Font}  ${Red}数字：${Font}"
    
    read num
    case $num in
    11)
        source <(curl -s ${download_url}/tools/xncs.sh)
        ;;
    12)
        source <(curl -s ${download_url}/tools/bench.sh)
        ;;
    13)
        source <(curl -s ${download_url}/os/all/tools.sh)
        ;;
    14)
        source <(curl -s ${download_url}/tools/lyzz.sh)
        ;;
    15)
        source <(curl -s ${download_url}/os/apt/init.sh)
        ;;
    21)
        source <(curl -s ${download_url}/tools/swap.sh)
        ;;
    22)
        source <(curl -s ${download_url}/tools/dns.sh)
        ;;
    23)
        source <(curl -s ${download_url}/tools/check.sh)
        ;;
    24)
        source <(curl -s ${download_url}/tools/tcp.sh)
        ;;
    25)
        source <(curl -s https://www.cxthhhhh.com/CXT-Library/Network-Reinstall-System-Modify/Network-Reinstall-System-Modify.sh )
        ;;
    99)
        echo -e "\n${GreenBG}感谢使用！欢迎下次使用！${Font}\n" && exit
        ;;
    *)
        clear
        echo -e "${Error}:请输入正确数字 [0-99],${Font} 5秒后刷新"
        countdown_sleep 5
        start_linux
        ;;
    esac
}

url=https://ifconfig.icu
country=$(curl -s ${url}/country)
if [[ $country == *"China"* ]]; then
    download_url=https://gitee.com/muaimingjun/LinuxCTS/raw/main
else
    download_url=https://raw.githubusercontent.com/hyh1750522171/LinuxCTS/main
fi
# 引用全局初始化脚本
source <(curl -s ${download_url}/os/all/init.sh)
check_root
init_log
echo "正在检测机器所在国家和地区...请稍后...." | tee -a $LOG_FILE
check_command curl
check_command wget
sys_install
echo
start_linux
