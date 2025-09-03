#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# System Request : Debian 9+/Ubuntu 18.04+/20+/22+
# Developer      : Gemilangkinasih
# Email          : gemilangkinasih@gmail.com
# Telegram       : https://t.me/gemilangkinasih
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Variabel
NS=$(cat /etc/xray/dns 2>/dev/null || echo "localhost")
PUB=$(cat /etc/slowdns/server.pub 2>/dev/null || echo "pubkey")
DOMAIN=$(cat /etc/xray/domain 2>/dev/null || echo "example.com")
BOT_DIR="/opt/kyt"

# Warna
GREEN="\e[92;1m"
NC='\e[0m'

# Update & Install Dependencies
apt update && apt upgrade -y
apt install -y python3 python3-pip git unzip wget

# Buat direktori bot
mkdir -p $BOT_DIR
cd $BOT_DIR || exit

# Download bot dan kyt
wget -q https://raw.githubusercontent.com/gemilangvip/autoscript-free/main/bot/bot.zip -O bot.zip
unzip -o bot.zip && rm -f bot.zip

wget -q https://raw.githubusercontent.com/gemilangvip/autoscript-free/main/bot/kyt.zip -O kyt.zip
unzip -o kyt.zip && rm -f kyt.zip

# Install Python dependencies secara global
python3 -m pip install --upgrade pip
python3 -m pip install -r kyt/requirements.txt

# Input Bot Token & Admin
clear
echo -e "${GREEN}Tutorial Create Bot & ID Telegram${NC}"
echo -e "[»] Create Bot & Token Bot: @BotFather"
echo -e "[»] Info ID Telegram: @MissRose_bot"
echo ""
read -p "[»] Input your Bot Token   : " BOT_TOKEN
read -p "[»] Input your Telegram ID : " ADMIN_ID

# Simpan konfigurasi
cat > $BOT_DIR/var.txt <<EOF
BOT_TOKEN="$BOT_TOKEN"
ADMIN="$ADMIN_ID"
DOMAIN="$DOMAIN"
PUB="$PUB"
HOST="$NS"
EOF

# Buat systemd service
cat > /etc/systemd/system/kyt.service <<EOF
[Unit]
Description=Simple kyt - Telegram Bot
After=network.target

[Service]
Type=simple
WorkingDirectory=$BOT_DIR
ExecStart=/usr/bin/python3 -m kyt
Restart=always
User=root
Environment="PYTHONUNBUFFERED=1"

[Install]
WantedBy=multi-user.target
EOF

# Reload daemon & start service
systemctl daemon-reload
systemctl enable kyt
systemctl restart kyt

# Info selesai
clear
echo -e "${GREEN}Installations complete!${NC}"
echo "Your Bot Information:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Token Bot   : $BOT_TOKEN"
echo "Admin ID    : $ADMIN_ID"
echo "Domain      : $DOMAIN"
echo "PUB Key     : $PUB"
echo "Host        : $NS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Bot service is running. Check with: systemctl status kyt"
