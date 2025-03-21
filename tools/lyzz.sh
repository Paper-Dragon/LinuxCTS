#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
${Font_suffix}"

#By BlueSkyXN

install_besttrace(){
yum install traceroute mtr -y
wget -O "/root/besttrace" "https://raw.githubusercontent.com/BlueSkyXN/ChangeSource/master/besttrace" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/besttrace"
chmod 777 "/root/besttrace"
clear
}



test_single(){
	echo -e "${Info} 请输入你要测试的目标 ip :"
	read -p "输入 ip 地址:" ip

	while [[ -z "${ip}" ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "输入 ip 地址:" ip
		done

	/root/besttrace -q 1 ${ip} | tee -a -i /root/testrace.log 2>/dev/null

	repeat_test_single
}
repeat_test_single(){
	echo -e "${Info} 是否继续测试其他目标 ip ?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_single
	while [[ ! "${whether_repeat_single}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_single
		done
	[[ "${whether_repeat_single}" == "1" ]] && test_single
	[[ "${whether_repeat_single}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit
}



test_alternative(){
	select_alternative
	set_alternative
	result_alternative
}
select_alternative(){
	echo -e "${Info} 选择需要测速的目标网络: \n1.中国电信\n2.中国联通\n3.中国移动\n4.教育网"
	read -p "输入数字以选择:" ISP

	while [[ ! "${ISP}" =~ ^[1-4]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" ISP
		done
}
set_alternative(){
	[[ "${ISP}" == "1" ]] && node_1
	[[ "${ISP}" == "2" ]] && node_2
	[[ "${ISP}" == "3" ]] && node_3
	[[ "${ISP}" == "4" ]] && node_4
}
node_1(){
	echo -e "1.上海电信(天翼云)\n2.厦门电信CN2\n3.湖北襄阳电信\n4.江西南昌电信\n5.广东深圳电信\n6.广州电信(天翼云)" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-6]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="上海电信(天翼云)" && ip=101.227.255.46
	[[ "${node}" == "2" ]] && ISP_name="厦门电信CN2"	     && ip=117.28.254.129
	[[ "${node}" == "3" ]] && ISP_name="湖北襄阳电信"	     && ip=58.51.94.114
	[[ "${node}" == "4" ]] && ISP_name="江西南昌电信"	     && ip=182.98.238.249
	[[ "${node}" == "5" ]] && ISP_name="广东深圳电信"	     && ip=202.96.128.166
	[[ "${node}" == "6" ]] && ISP_name="广州电信(天翼云)" && ip=14.215.116.1
}
node_2(){
	echo -e "1.西藏拉萨联通\n2.重庆联通\n3.河南郑州联通\n4.安徽合肥联通\n5.江苏南京联通\n6.浙江杭州联通" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-6]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="西藏拉萨联通" && ip=221.13.70.65
	[[ "${node}" == "2" ]] && ISP_name="重庆联通"	 && ip=113.207.32.67
	[[ "${node}" == "3" ]] && ISP_name="河南郑州联通" && ip=61.168.23.97
	[[ "${node}" == "4" ]] && ISP_name="安徽合肥联通" && ip=112.122.10.33
	[[ "${node}" == "5" ]] && ISP_name="江苏南京联通" && ip=58.240.53.81
	[[ "${node}" == "6" ]] && ISP_name="浙江杭州联通" && ip=101.71.241.241
}
node_3(){
	echo -e "1.上海移动\n2.四川成都移动\n3.安徽合肥移动\n4.浙江杭州移动" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-4]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="上海移动"     && ip=221.130.188.252
	[[ "${node}" == "2" ]] && ISP_name="四川成都移动" && ip=183.221.247.9
	[[ "${node}" == "3" ]] && ISP_name="安徽合肥移动" && ip=120.209.140.64
	[[ "${node}" == "4" ]] && ISP_name="浙江杭州移动" && ip=112.17.0.114
}
node_4(){
	ISP_name="北京教育网" && ip=202.38.123.9
}
result_alternative(){
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	/root/besttrace -q 1 ${ip} | tee -a -i /root/testrace.log 2>/dev/null
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"

	repeat_test_alternative
}
repeat_test_alternative(){
	echo -e "${Info} 是否继续测试其他节点?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_alternative
	while [[ ! "${whether_repeat_alternative}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_alternative
		done
	[[ "${whether_repeat_alternative}" == "1" ]] && test_alternative
	[[ "${whether_repeat_alternative}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit
}



test_all(){
	result_all	'101.227.255.45'	'上海电信(天翼云)'
	result_all	'117.28.254.129'	'厦门电信CN2'

	result_all	'101.71.241.238'	'浙江杭州联通'

	result_all	'112.17.0.106'		'浙江杭州移动'

	result_all	'202.205.6.30'		'北京教育网'

	echo -e "${Info} 四网路由快速测试 已完成 ！"
}
result_all(){
	ISP_name=$2
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	/root/besttrace -q 1 $1
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"
}

install_besttrace

echo -e "${Info} 选择你要使用的功能: "
echo -e "1.选择一个节点进行测试\n2.四网路由快速测试\n3.手动输入 ip 进行测试"
read -p "输入数字以选择:" function

	while [[ ! "${function}" =~ ^[1-3]$ ]]
		do
			echo -e "${Error} 缺少或无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" function
		done

	if [[ "${function}" == "1" ]]; then
		test_alternative
	elif [[ "${function}" == "2" ]]; then
		test_all | tee -a -i /root/testrace.log 2>/dev/null
	else
		test_single
	fi