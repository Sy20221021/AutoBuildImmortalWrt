#!/bin/bash
# 调试日志文件
="/tmp/uci-defaults-log.txt""/tmp/uci-defaults-log.txt"
echo "开始执行 99-custom.sh 于 $(date)" >> $LOGFILE"开始执行 99-custom.sh 于 $(date)" >> $LOGFILE
echo "编译固件大小为: $PROFILE MB""编译固件大小为: $PROFILE MB"
echo "包含Docker: $INCLUDE_DOCKER""包含Docker: $INCLUDE_DOCKER"

echo “创建pppoe设置”"创建pppoe设置"
mkdir -p  /home/build/immortalwrt/files/etc/config-p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
猫 << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
启用PPPOE=${启用PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
文件结束

回显 "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings
# 输出调试信息
echo " $(date '%Y-%m-%d %H:%M:%S') - 开始编译..."



# 定义所需安装的包列表 下列插件你都可以自行删减
包=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
# 服务——文件浏览器
用户名管理员
密码admin
PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
#24.10
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES=" $PACKAGES luci-i18n-passwall-zh-cn "
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES luci-app-timewol"
PACKAGES="$PACKAGES luci-app-syncdial"
PACKAGES="$PACKAGES luci-app-arpbind"
PACKAGES="安装 openssh-sftp-server"
# 增加几个必备组件 方便用户安装iStore
PACKAGES=" $PACKAGES fdisk"
PACKAGES="脚本实用工具 $PACKAGES"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"

# 判断是否需要编译Docker插件
if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
    echo "正在添加软件包：luci-i18n-dockerman-zh-cn"
输入：fi

# 构建镜像
echo " $(date ' +%Y-%m-%d %H:%M:%S') - 正在使用以下软件包构建镜像："
回显 "$PACKAGES"

制作镜像
配置文件="通用"
包="包"
FILES="" /home/build/immortalwrt/files
ROOTFS_PARTSIZE=$配置文件

如果 [ $? -ne 0 ]; 那么
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 错误: 构建失败!"
    退出 1
输入：fi

echo " $(date ' +%Y-%m-%d %H:%M:%S' ) - 构建成功完成。"
