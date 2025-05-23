#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
#添加root用户的密码，将密码为空改成password
#sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Modify default IP
#修改登陆ip
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#x修改主题
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#修改名称
#sed -i 's/ImmortalWrt/N60Pro/g' package/base-files/files/bin/config_generate
sed -i 's/LEDE/N60Pro/g' package/base-files/files/bin/config_generate

#修改wifi名称（mtwifi-cfg）
#sed -i 's/WHK_Telecom-2.4G/OpenWrt/g' package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
#sed -i 's/WHK_Telecom/OpenWrt5G/g' package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
#或者使用
#sed -i 's/LEDE/OpenWrt-5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#修复immortalwrt下编译istore报错问题
#删除LUCI_EXTRA_DEPENDS行，合并到LUCI_DEPENDS解决格式问题
#sed -i 's/LUCI_DEPENDS:=+luci-lib-xterm +taskd//g' package/feeds/istore/luci-lib-taskd/Makefile 
#sed -i 's/LUCI_EXTRA_DEPENDS:=taskd (>=1.0.3-1)/LUCI_DEPENDS:=+luci-lib-xterm +taskd @>=1.0.3-1/g' package/feeds/istore/luci-lib-taskd/Makefile 

#加入rkp-ipid模块和turboacc
 git clone https://github.com/CHN-beta/rkp-ipid package/rkp-ipid
 #curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

 git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
 git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
