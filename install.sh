#!/bin/bash
set -e

sudo apt update && sudo apt upgrade -y
sudo apt install -y git python3 python3-pip python3-venv screen

read -p "Apakah Anda ingin menggunakan screen untuk menjalankan bot secara background? (y/n): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    USE_SCREEN=true
else
    USE_SCREEN=false
fi

git clone https://github.com/shareithub/autosave-airdrop.git
cd autosave-airdrop

if [ ! -f .env ]; then
    touch .env
fi

cek_env() {
    TELEGRAM_TOKEN=$(grep "^TELEGRAM_BOT_TOKEN=" .env | cut -d '=' -f2 | tr -d ' ')
    ADMIN_ID=$(grep "^ADMIN_ID=" .env | cut -d '=' -f2 | tr -d ' ')
}

while true; do
    nano .env
    cek_env
    if [[ -z "$TELEGRAM_TOKEN" || -z "$ADMIN_ID" ]]; then
        echo "ERROR: TELEGRAM_TOKEN dan ADMIN_ID harus diisi. Silahkan masukkan kembali."
    else
        break
    fi
done

python3 -m venv shareithub
source shareithub/bin/activate
pip install -r requirements.txt

if [ "$USE_SCREEN" = true ]; then

    screen -dmS auto-list-airdrop bash -c 'source shareithub/bin/activate && python3 bot.py'
    echo "Bot berjalan dalam screen session 'auto-list-airdrop'."
else

    python3 bot.py
fi

echo "Proses berjalan, silahkan test dengan menjalankan bot telegram. Jangan lupa subscribe channel Youtube & Telegram : SHARE IT HUB"
