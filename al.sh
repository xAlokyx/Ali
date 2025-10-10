#!/bin/sh
# v2ray installation script with status messages
clear

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}بدء التثبيت...${NC}\n"

# Step 1
echo -e "${GREEN}[1/9] تحميل المفتاح العام...${NC}"
wget -q https://downloads.sourceforge.net/project/v2raya/openwrt/v2raya.pub -O /etc/opkg/keys/94cc2a834fb0aa03 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم تحميل المفتاح العام بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل تحميل المفتاح العام${NC}\n"
fi

# Step 2
echo -e "${GREEN}[2/9] إضافة مصدر التحديث...${NC}"
echo "src/gz v2raya https://downloads.sourceforge.net/project/v2raya/openwrt/$(. /etc/openwrt_release && echo \"$DISTRIB_ARCH\")" >> /etc/opkg/customfeeds.conf 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم إضافة مصدر التحديث بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل إضافة مصدر التحديث${NC}\n"
fi

# Step 3
echo -e "${GREEN}[3/9] تحديث قائمة الحزم...${NC}"
opkg update >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم تحديث قائمة الحزم بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل تحديث قائمة الحزم${NC}\n"
fi

# Step 4
echo -e "${GREEN}[4/9] تثبيت v2raya...${NC}"
opkg install v2raya >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم تثبيت v2raya بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل تثبيت v2raya${NC}\n"
fi

# Step 5
echo -e "${GREEN}[5/9] تثبيت kmod-nft-tproxy...${NC}"
opkg install kmod-nft-tproxy >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم تثبيت kmod-nft-tproxy بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل تثبيت kmod-nft-tproxy${NC}\n"
fi

# Step 6
echo -e "${GREEN}[6/9] تثبيت xray-core...${NC}"
opkg install xray-core >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم تثبيت xray-core بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل تثبيت xray-core${NC}\n"
fi

# Step 7
echo -e "${GREEN}[7/9] تثبيت v2fly-geoip و v2fly-geosite...${NC}"
opkg install v2fly-geoip v2fly-geosite >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم تثبيت v2fly-geoip و v2fly-geosite بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل تثبيت v2fly-geoip و v2fly-geosite${NC}\n"
fi

# Step 8
echo -e "${GREEN}[8/9] تثبيت luci-app-v2raya...${NC}"
opkg install luci-app-v2raya >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم تثبيت luci-app-v2raya بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل تثبيت luci-app-v2raya${NC}\n"
fi

# Step 9
echo -e "${GREEN}[9/9] تكوين وبدء الخدمة...${NC}"
uci set v2raya.config.enabled='1' >/dev/null 2>&1
uci commit v2raya >/dev/null 2>&1
/etc/init.d/v2raya start >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم تكوين وبدء الخدمة بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل تكوين وبدء الخدمة${NC}\n"
fi

# Network settings
echo -e "${GREEN}إعداد إعدادات الشبكة...${NC}"
mkdir -p /usr/share/nftables.d/chain-pre/mangle_postrouting/ >/dev/null 2>&1
echo "ip ttl set 65" > /usr/share/nftables.d/chain-pre/mangle_postrouting/01-set-ttl.nft 2>/dev/null
fw4 reload >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ تم إعداد إعدادات الشبكة بنجاح${NC}\n"
else
    echo -e "${RED}✗ فشل إعداد إعدادات الشبكة${NC}\n"
fi

# Clean up script
rm -- "$0" >/dev/null 2>&1

echo -e "\n${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}  تم إكمال التثبيت! ✓${NC}"
echo -e "${GREEN}  powered by Aloky${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}\n"
