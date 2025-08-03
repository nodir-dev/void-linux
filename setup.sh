#!/bin/bash

# ==============================================================
# 🛡️  SoftServis Premium Void Linux Setup Installer - v1.0
# 🔐 Parol bilan himoyalangan, interaktiv tanlov bilan dasturlar
# Author: Nodirbek & GPT-Jigar
# ==============================================================

PASSWORD="1314"

echo "==============================================="
echo "🚀 SoftServis Void Linux Dev Setup (PRO Style)"
echo "🔒 Parol bilan himoyalangan skript"
echo "==============================================="
read -sp "👉 Parolni kiriting: " input

echo ""
if [[ "$input" != "$PASSWORD" ]]; then
    echo "❌ Noto‘g‘ri parol. Chiqmoqda..."
    exit 1
fi

echo "✅ Parol to‘g‘ri. Davom etyapmiz..."
echo
sleep 1

# Tanlanadigan dasturlar
PROGRAMS=(
  "GNOME Desktop Environment"
  "KDE Desktop Environment"
  "XFCE Desktop Environment"
  "Git"
  "Node.js & npm"
  "Yarn"
  "React.js (create-react-app)"
  "Visual Studio Code"
  "Neofetch"
  "Gnome Tweaks"
  "NetworkManager"
)

SELECTIONS=()
echo "🧩 Qaysi komponentlarni o‘rnatamiz? + yoki - bilan tanlang:"
echo "(Masalan: +1 -2 +3)"
echo ""

for i in "${!PROGRAMS[@]}"; do
    echo "$((i+1)). ${PROGRAMS[$i]}"
done

echo
read -p "🧠 Tanlovingiz: " -a choices

# Belgilanganlarni tanlash
for choice in "${choices[@]}"; do
    index="${choice:1}"
    if [[ "$choice" =~ ^\+[0-9]+$ ]]; then
        SELECTIONS+=("${PROGRAMS[$((index-1))]}")
    fi
done

# Paketlarni yangilash
echo "🔁 Paketlar bazasi yangilanmoqda..."
xbps-install -Suy xbps

# O‘rnatish funksiyasi
declare -A INSTALL_CMDS

INSTALL_CMDS=(
  ["GNOME Desktop Environment"]="xbps-install -Sy xorg xinit gnome gnome-terminal gnome-tweaks lightdm lightdm-gtk3-greeter dbus"
  ["KDE Desktop Environment"]="xbps-install -Sy xorg plasma sddm konsole dolphin dbus"
  ["XFCE Desktop Environment"]="xbps-install -Sy xorg xfce4 xfce4-goodies lightdm lightdm-gtk3-greeter dbus"
  ["Git"]="xbps-install -Sy git"
  ["Node.js & npm"]="xbps-install -Sy nodejs npm"
  ["Yarn"]="npm install -g yarn"
  ["React.js (create-react-app)"]="npm install -g create-react-app"
  ["Visual Studio Code"]="curl -L -o /tmp/code.tar.gz https://update.code.visualstudio.com/latest/linux-x64/stable && mkdir -p /opt/vscode && tar -xzf /tmp/code.tar.gz -C /opt/vscode --strip-components=1 && ln -sf /opt/vscode/code /usr/local/bin/code"
  ["Neofetch"]="xbps-install -Sy neofetch"
  ["Gnome Tweaks"]="xbps-install -Sy gnome-tweaks"
  ["NetworkManager"]="xbps-install -Sy NetworkManager && ln -sf /etc/sv/NetworkManager /var/service"
)

for prog in "${SELECTIONS[@]}"; do
    echo "📦 O‘rnatilmoqda: $prog"
    eval "${INSTALL_CMDS[$prog]}"
    echo "✅ Tugadi: $prog"
    echo
    sleep 1

done

# LightDM yoki SDDM xizmatini yoqish (agar kerak bo‘lsa)
if printf '%s\n' "${SELECTIONS[@]}" | grep -q "GNOME\|XFCE"; then
    ln -sf /etc/sv/dbus /var/service/
    ln -sf /etc/sv/lightdm /var/service/
elif printf '%s\n' "${SELECTIONS[@]}" | grep -q "KDE"; then
    ln -sf /etc/sv/dbus /var/service/
    ln -sf /etc/sv/sddm /var/service/
fi

echo "🎉 Barcha tanlangan paketlar muvaffaqiyatli o‘rnatildi!"
echo "🔁 Endi tizimni qayta yuklab, yangi muhitga o‘ting."
echo
read -p "👉 Chiqish uchun Enter bosing..."
exit 0
