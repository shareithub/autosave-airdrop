#!/bin/bash
set -e

# Update dan upgrade sistem, serta perbaikan paket yang bermasalah
sudo apt update && sudo apt upgrade -y --fix-missing
sudo apt --fix-broken install -y
sudo apt autoremove -y

# Install paket yang diperlukan
sudo apt install -y git python3 python3-pip python3-venv screen

# Tanya pengguna apakah ingin menggunakan screen
read -p "Apakah Anda ingin menggunakan screen untuk menjalankan bot secara background? (y/n): " answer

case "$answer" in
    [Yy])
        USE_SCREEN=true
        ;;
    *)
        USE_SCREEN=false
        ;;
esac

# Clone repository bot
git clone https://github.com/shareithub/autosave-airdrop.git
cd autosave-airdrop

# Cek & buat file .env jika belum ada
if [ ! -f .env ]; then
    touch .env
fi

cek_env() {
    TELEGRAM_TOKEN=$(grep "^TELEGRAM_BOT_TOKEN=" .env | cut -d '=' -f2 | tr -d ' ')
    ADMIN_ID=$(grep "^ADMIN_ID=" .env | cut -d '=' -f2 | tr -d ' ')
}

# Loop untuk memastikan TELEGRAM_BOT_TOKEN dan ADMIN_ID tidak kosong
while true; do
    nano .env
    cek_env
    if [[ -z "$TELEGRAM_TOKEN" || -z "$ADMIN_ID" ]]; then
        echo "ERROR: TELEGRAM_TOKEN dan ADMIN_ID harus diisi. Silakan masukkan kembali."
    else
        break
    fi
done

# Setup Python virtual environment
python3 -m venv shareithub
source shareithub/bin/activate
pip install -r requirements.txt

# Jalankan bot dengan atau tanpa screen
if [ "$USE_SCREEN" = true ]; then
    screen -dmS auto-list-airdrop bash -c 'source shareithub/bin/activate && python3 bot.py'
    echo "Bot berjalan dalam screen session 'auto-list-airdrop'."
else
    python3 bot.py
fi

echo "Proses berjalan, silakan tes dengan menjalankan bot Telegram."
echo "Jangan lupa subscribe channel YouTube & Telegram: SHARE IT HUB"
