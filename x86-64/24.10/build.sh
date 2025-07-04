#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
echo "编译固件大小为: $PROFILE MB"
echo "Include Docker: $INCLUDE_DOCKER"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings
# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始编译..."



# 定义所需安装的包列表 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
# 服务——FileBrowser 用户名admin 密码admin
PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"

#24.10
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
# 终端
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
# 科学
PACKAGES="$PACKAGES luci-i18n-passwall-zh-cn"
# 科学
PACKAGES="$PACKAGES luci-app-openclash"
# 科学
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
# 定时唤醒
PACKAGES="$PACKAGES luci-i18n-timewol-zh-cn"
# 多线多拨
PACKAGES="$PACKAGES luci-app-syncdial"
# 多WAN负载均衡
PACKAGES="$PACKAGES luci-i18n-mwan3-zh-cn"
# 挂载CIFS网络共享
PACKAGES="$PACKAGES luci-i18n-cifs-mount-zh-cn"
# ARP绑定
PACKAGES="$PACKAGES luci-i18n-arpbind-zh-cn"
# 端口转发
# PACKAGES="$PACKAGES luci-i18n-upnp-zh-cn"
# IP限速
# PACKAGES="$PACKAGES luci-i18n-eqos-zh-cn"
# 流量控制
PACKAGES="$PACKAGES luci-i18n-sqm-zh-cn"
# 域名解析
PACKAGES="$PACKAGES luci-i18n-ddns-zh-cn"
# PACKAGES="$PACKAGES luci-i18n-ddns-go-zh-cn"
# VPN服务
PACKAGES="$PACKAGES luci-app-openvpn-server"
PACKAGES="$PACKAGES luci-i18n-openvpn-server-zh-cn"
# VPN服务
PACKAGES="$PACKAGES luci-i18n-ipsec-vpnd-zh-cn"
# VPN服务
PACKAGES="$PACKAGES openssh-sftp-server"
# FTP服务

# 增加几个必备组件 方便用户安装iStore
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"

# 判断是否需要编译 Docker 插件
if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
    echo "Adding package: luci-i18n-dockerman-zh-cn"
fi

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE="generic" PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$PROFILE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
