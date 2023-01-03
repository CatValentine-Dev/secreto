#!/bin/bash

if (( $EUID != 0 )); then
    echo -e "${CYAN}Rode isso com Root"
    exit
fi

clear

instalartema(){
    cd /var/www/
    tar -cvf pterodactylbackup.tar.gz pterodactyl
    echo -e "${CYAN}Instalando Tema Feito por TemuxOS..."
    cd /var/www/pterodactyl
    rm -r secreto
    git clone https://github.com/CatValentine-Dev/secreto.git
    cd secreto
    rm /var/www/pterodactyl/resources/scripts/deluxetheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv deluxetheme.css /var/www/pterodactyl/resources/scripts/deluxetheme.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

instaladordetemas(){
    while true; do
        read -p "Certeza que quer instalar esse tema [y/n]? " yn
        case $yn in
            [Yy]* ) instalartema; break;;
            [Nn]* ) exit;;
            * ) echo "Escolha yes ou no.";;
        esac
    done
}

reparar(){
    bash <(curl https://raw.githubusercontent.com/CatValentine-Dev/pterodactylthemes/main/reparar.sh)
}

restaurarbackup(){
    echo "Restoring Backup..."
    cd /var/www/
    tar -xvf pterodactylbackup.tar.gz
    rm secreto.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}

    CYAN='\033[0;36m'
    echo -e "${CYAN}Copyright 2022 TemuxOS"
    echo -e "${CYAN}Esse Software e open-source."
    echo -e ""
    echo -e "${CYAN}Discord: https://discord.gg/WkVVtTaBRh/"
    echo -e ""
    echo -e "${CYAN} [1] Instalar Tema"
    echo -e "${CYAN} [2] Restaura backup Do Painel"
    echo -e "${CYAN} [3] Reparar Painel (Use caso o Painel tenha dado Merda)"
    echo -e "${CYAN} [4] Sair"

read -p "Enter a number: " choice
if [ $choice == "1" ]
    then
    instaladordetemas
fi
if [ $choice == "2" ]
    then
    restaurarbackup
fi
if [ $choice == "3" ]
    then
    reparar
fi

if [ $choice == "4"]
    then
    exit
fi
