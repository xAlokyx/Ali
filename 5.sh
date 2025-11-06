#!/bin/sh
# v2ray installation script with status messages
clear

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}بدء التثبيت...${NC}\n"

echo -e "${GREEN}[1/9] تحميل المفتاح العام...${NC}"
wget -q https://downloads.sourceforge.net/project/v2raya/openwrt/v2raya.pub -O /etc/opkg/keys/94cc2a834fb0aa03 2>&1 && \
echo -e "${GREEN}✓ تم تحميل المفتاح العام بنجاح${NC}\n"

echo -e "${GREEN}[2/9] إضافة مصدر التحديث...${NC}"
echo "src/gz v2raya https://downloads.sourceforge.net/project/v2raya/openwrt/$(. /etc/openwrt_release && echo \"$DISTRIB_ARCH\")" >> /etc/opkg/customfeeds.conf 2>/dev/null && \
echo -e "${GREEN}✓ تم إضافة مصدر التحديث بنجاح${NC}\n"

echo -e "${GREEN}[3/9] تحديث قائمة الحزم...${NC}"
opkg update >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تحديث قائمة الحزم بنجاح${NC}\n"

echo -e "${GREEN}[4/9] تثبيت v2raya...${NC}"
opkg install v2raya >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت  بنجاح${NC}\n"

echo -e "${GREEN}[5/9] تثبيت ...${NC}"
opkg install kmod-nft-tproxy >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت  بنجاح${NC}\n"

echo -e "${GREEN}[6/9] تثبيت xray...${NC}"
opkg install xray-core >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت xray-core بنجاح${NC}\n"

echo -e "${GREEN}[7/9] تثبيت v2fly-geoip و v2fly-geosite...${NC}"
opkg install v2fly-geoip v2fly-geosite >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت v2fly-geoip و v2fly-geosite بنجاح${NC}\n"

echo -e "${GREEN}[8/9] تثبيت ...${NC}"
opkg install luci-app-v2raya >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت  بنجاح${NC}\n"

echo -e "${GREEN}[9/9] تكوين وبدء الخدمة...${NC}"
uci set v2raya.config.enabled='1' >/dev/null 2>&1
uci commit v2raya >/dev/null 2>&1
/etc/init.d/v2raya start >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تكوين وبدء الخدمة بنجاح${NC}\n"

echo -e "${GREEN}إعداد إعدادات الشبكة...${NC}"
mkdir -p /usr/share/nftables.d/chain-pre/mangle_postrouting/ >/dev/null 2>&1
echo "ip ttl set 65" > /usr/share/nftables.d/chain-pre/mangle_postrouting/01-set-ttl.nft 2>/dev/null
fw4 reload >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم إعداد إعدادات الشبكة بنجاح${NC}\n"

# Clean up script
rm -- "$0" >/dev/null 2>&1

echo -e "\n${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}  تم إكمال التثبيت بنجاح! ✓${NC}"
echo -e "${GREEN}  powered by Aloky${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}\n"



