#!/bin/bash

YELLOW='\033[1;33m'
BLUE='\033[1;34m'
RED='\033[31m'
NC='\033[0m'
VERSION='v4.2'
IP=$(hostname -I)
HOSTNAME=$(hostname)

# Fonction pour afficher les options disponibles
display_menu() {
  clear
  echo -e "${RED}
  
████████╗░█████╗░███╗░░░███╗██╗░██████╗  ████████╗░█████╗░░█████╗░██╗░░░░░░██████╗░░░░██████╗██╗░░██╗
╚══██╔══╝██╔══██╗████╗░████║╚█║██╔════╝  ╚══██╔══╝██╔══██╗██╔══██╗██║░░░░░██╔════╝░░░██╔════╝██║░░██║
░░░██║░░░██║░░██║██╔████╔██║░╚╝╚█████╗░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░╚█████╗░░░░╚█████╗░███████║
░░░██║░░░██║░░██║██║╚██╔╝██║░░░░╚═══██╗  ░░░██║░░░██║░░██║██║░░██║██║░░░░░░╚═══██╗░░░░╚═══██╗██╔══██║
░░░██║░░░╚█████╔╝██║░╚═╝░██║░░░██████╔╝  ░░░██║░░░╚█████╔╝╚█████╔╝███████╗██████╔╝██╗██████╔╝██║░░██║
░░░╚═╝░░░░╚════╝░╚═╝░░░░░╚═╝░░░╚═════╝░  ░░░╚═╝░░░░╚════╝░░╚════╝░╚══════╝╚═════╝░╚═╝╚═════╝░╚═╝░░╚═╝
Version : ${VERSION}
IP : ${IP} 
Hostname : ${HOSTNAME}
  ${NC}"
  echo -e "${BLUE}[1] ${NC}Mettre à jour le système"
  echo -e "${BLUE}[2] ${NC}Installer des packages de base ${BLUE}(bash, curl, sudo, wget, nload, htop, git)"
  echo -e "${BLUE}[3] ${NC}Installer l'utilitaire ${BLUE}Speedtest (Ookla)"
  echo -e "${BLUE}[4] ${NC}Créer un nouvel utilisateur"
  echo -e "${BLUE}[5] ${NC}Tout faire ${BLUE}(1, 2 et 4)"
  echo -e ""
  echo -e "${YELLOW} -------------------------------------- ${RED}SERVEURS DE JEUX ${YELLOW}--------------------------------------"
  echo -e ""
  echo -e "${BLUE}[6] ${NC}Créer et lancer un serveur ${BLUE}Minecraft"
  echo -e "${BLUE}[7] ${NC}Créer et lancer un serveur ${BLUE}Bungeecord"
  echo -e "${BLUE}[8] ${NC}Créer et lancer un serveur ${BLUE}FiveM"
  echo -e "${BLUE}[9] ${NC}Installer le panel de gestion de serveurs ${BLUE}Pterodactyl ${RED}(require Nginx & MariaDB & PhpMyAdmin)"
  echo -e "${BLUE}[10] ${NC}Mettre à jours ${BLUE}Pterodactyl"
  echo -e ""
  echo -e "${YELLOW} ---------------------------------------- ${RED}SERVEURS WEB  ${YELLOW}---------------------------------------"
  echo -e ""
  echo -e "${BLUE}[11] ${NC}Installer un serveur ${BLUE}Nginx"
  echo -e "${BLUE}[12] ${NC}Installer l'interface ${BLUE}PhpMyAdmin (require Nginx & MariaDB)"
  echo -e "${BLUE}[13] ${NC}Installer le gestionnaire d'hébergement web ${BLUE}Plesk"
  echo -e ""
  echo -e "${YELLOW} --------------------------------- ${RED}SERVEURS DE BASE DE DONNEES  ${YELLOW}--------------------------------"
  echo -e ""
  echo -e "${BLUE}[14] ${NC}Installer et configurer un serveur ${BLUE}MariaDB (MySQL)"
  echo -e ""
  echo -e "${YELLOW} ----------------------------------------------------------------------------------------------"
  echo -e ""
  echo -e "${BLUE}[15] ${NC}Quitter"
  echo -e ""
}


# Vérification des mises à jour
if ! command -v curl &> /dev/null; then
    clear
    echo "Curl n'est pas installé. Installation en cours...${NC}"
    sudo apt-get update
    apt install curl -y
fi
if ! command -v sudo &> /dev/null; then
    clear
    echo "Sudo n'est pas installé. Installation en cours...${NC}"
    sudo apt-get update
    apt install sudo -y
fi
clear
echo -e "${YELLOW}Vérification des mises à jour...${NC}"
latest_version=$(curl -s https://raw.githubusercontent.com/tomnoel41/Tom-s-Tools/main/last_version.txt)
if [[ "$latest_version" != "$VERSION" ]]; then
   clear
   echo -e "${YELLOW}Une nouvelle version de ce script est disponible ! (version $latest_version)${NC}"
   echo -e "${YELLOW}Voulez-vous mettre à jour ? (y/n)${NC}"
   read update_script

   if [[ "$update_script" == "y" ]]; then
      echo -e "${YELLOW}Téléchargement de la dernière version...${NC}"
      curl -s https://raw.githubusercontent.com/tomnoel41/Tom-s-Tools/main/script.sh -o /tmp/script.sh

      if [[ $? -eq 0 ]]; then
         echo -e "${YELLOW}Installation de la dernière version...${NC}"
         mv /tmp/script.sh $0
         chmod +x $0
         echo -e "${YELLOW}Le script a été mis à jour avec succès !${NC}"
         exec $0
      else
         echo -e "${YELLOW}La mise à jour a échoué.${NC}"
      fi
   fi
fi

# Fonction pour mettre à jour le système
update_system() {
  sudo apt update -y
  sudo apt upgrade -y
}

# Fonction pour installer les packages de base
install_packages() {
  sudo apt install -y bash curl sudo wget nload htop git
}

# Fonction pour créer un nouvel utilisateur
create_user() {
  read -p "Voulez-vous donner les permissions sudo et root à cet utilisateur ? (y/n) :" give_permissions
  read -p "Veuillez saisir le nom d'utilisateur pour le nouvel utilisateur :" new_user
  read -s -p "Veuillez saisir le mot de passe pour le nouvel utilisateur :" new_password
  echo
  sudo adduser $new_user --gecos "User"
  if [[ "$give_permissions" == "y" ]]; then
    sudo usermod -aG sudo $new_user
    sudo usermod -aG root $new_user
  fi
  echo "$new_user:$new_password" | sudo chpasswd
}

install_speedtest() {
  if ! command -v speedtest &> /dev/null; then
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    sudo apt-get install speedtest
    echo -e "${YELLOW}Speedtest à été installé avec succès ! (exemple : speedtest -s 24215)${NC}"
  else
    echo -e "${YELLOW}Speedtest est déjà installé sur votre serveur !${NC}"
  fi
}

create_minecraft_server() {
  # Vérifier si Java est installé
  if ! command -v java &> /dev/null; then
    echo "Java n'est pas installé. Installation en cours...${NC}"
    sudo apt-get update
    sudo apt-get install openjdk-17-jdk openjdk-17-jre -y
  fi
  
  # Demander à l'utilisateur de saisir la version du serveur
  read -p "Veuillez entrer la version de Spigot à installer (par exemple, '1.12.2'):" version

  # Demander à l'utilisateur la RAM max qu'il veut
  read -p "Veuillez entrer la valeur maximum de la RAM que vous souhaitez (par exemple, '4096' pour 4GB):" max_ram
  
  # Créer un dossier pour le serveur
  read -p "Veuillez entrer le chemin absolu où vous souhaitez créer le dossier pour le serveur:" server_path
  sudo mkdir -p $server_path
  cd $server_path
  
  # Télécharger le fichier Spigot.jar
  sudo wget https://cdn.getbukkit.org/spigot/spigot-$version.jar

  echo "eula=true" > eula.txt
  echo "sudo java -Xmx${max_ram}M -Xms1024M -jar spigot-${version}.jar nogui" > start.sh

  # Rendre éxécutable le start.sh
  chmod +x start.sh
  read -p "Voulez vous lancer le serveur ? (y/n)" launch
  if [[ "$launch" == "y" ]]; then
    sudo bash start.sh
  fi
  if [[ "$launch" == "n" ]]; then
    echo -e "${BLUE}D'accord, si vous souhaitez lancer le serveur, vous pouvez utiliser la commande './start.sh' dans le répertoire du serveur.${NC}"
  fi
}

create_bungeecord_server() {
  # Vérifier si Java est installé
  if ! command -v java &> /dev/null; then
    echo "Java n'est pas installé. Installation en cours...${NC}"
    sudo apt-get update
    sudo apt-get install openjdk-17-jdk openjdk-17-jre -y
  fi

  # Demander à l'utilisateur la RAM max qu'il veut
  read -p "Veuillez entrer la valeur maximum de la RAM que vous souhaitez (par exemple, '4096' pour 4GB):" max_ram
  
  # Créer un dossier pour le serveur
  read -p "Veuillez entrer le chemin absolu où vous souhaitez créer le dossier pour le serveur:" server_path
  sudo mkdir -p $server_path
  cd $server_path
  
  # Télécharger le fichier Spigot.jar
  sudo wget https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar

  echo "eula=true" > eula.txt
  echo "sudo java -Xmx${max_ram}M -Xms1024M -jar BungeeCord.jar nogui" > start.sh

  # Rendre éxécutable le start.sh
  chmod +x start.sh
  read -p "Voulez vous lancer le serveur ? (y/n)" launch
  if [[ "$launch" == "y" ]]; then
    sudo bash start.sh
  fi
  if [[ "$launch" == "n" ]]; then
    echo -e "${BLUE}D'accord, si vous souhaitez lancer le serveur, vous pouvez utiliser la commande './start.sh' dans le répertoire du serveur.${NC}"
  fi
}

create_fivem_server() {
  # Vérifier si xz-utils est installé
  if ! command -v tar &> /dev/null; then
    echo "xz-utils n'est pas installé. Installation en cours...${NC}"
    sudo apt-get update
    sudo apt-get install xz-utils -y
  fi

  # Vérifier si git est installé
  if ! command -v git &> /dev/null; then
    echo "git n'est pas installé. Installation en cours...${NC}"
    sudo apt-get update
    sudo apt-get install git -y
  fi

  # Vérifier si wget est installé
  if ! command -v wget &> /dev/null; then
    echo "wget n'est pas installé. Installation en cours...${NC}"
    sudo apt-get update
    sudo apt-get install wget -y
  fi

  # Créer un dossier pour le serveur
  read -p "Veuillez entrer le chemin absolu où vous souhaitez créer le dossier pour le serveur:" server_path
  sudo mkdir -p $server_path
  cd $server_path

  # Télécharger l'artefacts (alpine)
  read -p "Veuillez entrer le lien de l'artefacts (alpine) pour le serveur:" artefacts_link
  wget $artefacts_link

  # Unarchive l'artefacts
  tar -xvf fx.tar.xz && rm fx.tar.xz

  # Lancer le serveur
  read -p "Voulez vous lancer le serveur ? (y/n)" launch
  if [[ "$launch" == "y" ]]; then
    cd ${server_path} && sudo bash run.sh
  fi
  if [[ "$launch" == "n" ]]; then
    echo -e "${BLUE}D'accord, si vous souhaitez lancer le serveur, vous pouvez utiliser la commande './run.sh' dans le répertoire du serveur.${NC}"
  fi
}

setup_mariadb_server() {
  # Installation de MariaDB
  sudo apt-get update -y
  sudo apt-get upgrade -y

  # Détection de la version de Linux
  if [[ -e /etc/debian_version ]]; then
    DISTRO=$(lsb_release -is)
    VERSION=$(lsb_release -rs | cut -d. -f1)
  elif [[ -e /etc/lsb-release ]]; then
    DISTRO=$(grep DISTRIB_ID /etc/lsb-release | awk -F= '{print $2}')
    VERSION=$(grep DISTRIB_RELEASE /etc/lsb-release | awk -F= '{print $2}' | cut -d. -f1)
  else
    echo "Distribution non prise en charge."
    exit 1
  fi

  # Ajout du référentiel MariaDB approprié
  if [[ $DISTRO == "Ubuntu" && $VERSION -ge 20 ]]; then
    # Ajout du référentiel MariaDB 11.0 pour Ubuntu 20.04 ou version ultérieure
    sudo apt-get install -y software-properties-common
    sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
    sudo add-apt-repository 'deb [arch=amd64] http://mirror.zol.co.zw/mariadb/repo/11.0/ubuntu focal main'
  elif [[ $DISTRO == "Ubuntu" && $VERSION -lt 20 ]]; then
    # Ajout du référentiel MariaDB 11.0 pour Ubuntu 18.04 ou version antérieure
    sudo apt-get install -y software-properties-common
    sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
    sudo add-apt-repository 'deb [arch=amd64] http://mirror.zol.co.zw/mariadb/repo/11.0/ubuntu bionic main'
  elif [[ $DISTRO == "Debian" && $VERSION -ge 10 ]]; then
    # Ajout du référentiel MariaDB 11.0 pour Debian 10 ou version ultérieure
    sudo apt-get install -y software-properties-common dirmngr gnupg2
    sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
    sudo add-apt-repository 'deb [arch=amd64] http://mirror.zol.co.zw/mariadb/repo/11.0/debian buster main'
  else
    echo "Version non prise en charge de la distribution Linux."
    exit 1
  fi
  apt install mariadb-server -y
  # Configuration de MariaDB
  sudo mysql_secure_installation

  # Ajouter un utilisateur avec les permissions requises
  read -p "Voulez vous créer un utilisateur administrateur ? (y/n)" create_admin_account
  if [[ "$create_admin_account" == "y" ]]; then
  read -p "Entrez le nom d'utilisateur de votre compte:" new_admin_user
  read -s -p "Entrez le mot de passe de votre compte:" new_pass_user
    sudo mysql -e "CREATE USER '${new_admin_user}'@'%' IDENTIFIED BY '${new_pass_user}';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${new_admin_user}'@'%' WITH GRANT OPTION;"
  fi
  echo -e "${BLUE}L'installation de votre serveur MariaDB à été éffectué correctement.${NC}"
}

install_nginx_php() {
    # Installer Nginx
    read -p "Voulez vous supprimer la configuration par défaut ? (y/n)" delete_default
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo apt-get install python3-certbot-nginx -y

    sudo apt -y install software-properties-common
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt-get update
    sudo apt-get install -y php7.4-fpm php7.4-common php7.4-mysql php7.4-gd php7.4-json php7.4-cli

    # Configurer Nginx pour utiliser PHP-FPM
    if [[ "$delete_default" == "y" ]]; then
      rm /etc/nginx/sites-enabled/default
      rm /etc/nginx/sites-available/default
    else
      sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
      sudo touch /etc/nginx/sites-available/default
      sudo sh -c 'echo "<h1>Bienvenue sur votre serveur Nginx !</h1></br><h2>by Toms Tools.</h2>" > /var/www/html/index.html'
      sudo echo "
      server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        index index.php index.html index.htm;
        server_name _;
        location / {
            try_files \$uri \$uri/ =404;
        }
        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        }
      }" | sudo tee /etc/nginx/sites-available/default > /dev/null
    sudo systemctl restart nginx.service
    fi
}

install_phpmyadmin() {
  if ! command -v unzip &> /dev/null; then
    echo "Unzip n'est pas installé. Installation en cours...${NC}"
    sudo apt-get update
    apt install zip unzip -y
  fi
  apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} tar git redis-server
  export PHPMYADMIN_VERSION=$(curl --silent https://www.phpmyadmin.net/downloads/ | grep "btn btn-success download_popup" | sed -n 's/.*href="\([^"]*\).*/\1/p' | tr '/' '\n' | grep -E '^.*[0-9]+\.[0-9]+\.[0-9]+$')
  read -p "Souhaitez-vous utiliser un nom de domaine ? (y/n)" domain_boolean
  if [[ "$domain_boolean" == "y" ]]; then
    apt install python3-certbot-nginx -y
    echo -e "${RED}Attention, le nom de domaine doit pointer vers l'adresse IP du serveur.${NC}"
    read -p "Entrez le nom de domaine que vous souhaitez utiliser: " domain
    read -p "Entrez le répertoire d'installation : (exemple : /var/www/phpmyadmin)" repertoire
    certbot --nginx -d $domain
    mkdir $repertoire
    cd $repertoire && wget https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.zip && unzip phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.zip && rm phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.zip && mv phpMyAdmin-$PHPMYADMIN_VERSION-all-languages pma
    cd pma
    mv * $repertoire
    cd $repertoire
    rm -r pma
    cat << EOF | sudo tee /etc/nginx/sites-enabled/phpmyadmin.conf > /dev/null
server {
    listen 80;
    server_name $domain;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $domain;

    root /var/www/phpmyadmin;
    index index.php;

    # allow larger file uploads and longer script runtimes
    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
    ssl_prefer_server_ciphers on;

    # See https://hstspreload.org/ before uncommenting the line below.
    # add_header Strict-Transport-Security "max-age=15768000; preload;";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header Content-Security-Policy "frame-ancestors 'self'";
    add_header X-Frame-Options DENY;
    add_header Referrer-Policy same-origin;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        include /etc/nginx/fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
  else
    cd /var/www/html && wget https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.zip && unzip phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.zip && rm phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.zip && mv phpMyAdmin-$PHPMYADMIN_VERSION-all-languages pma
  fi
  systemctl restart nginx
  echo -e "${BLUE}L'installation de votre PhpMyAdmin à été éffectué correctement.${NC}"
}

install_plesk() {
  if ! command -v plesk &> /dev/null; then
    sudo apt-get update
    if ! command -v wget &> /dev/null; then
      apt install wget -y
    fi
    sh <(curl https://autoinstall.plesk.com/one-click-installer || wget -O - https://autoinstall.plesk.com/one-click-installer)
  else
    echo -e "${BLUE}Plesk est déjà installé sur le système.${NC}"
  fi
}

install_ptero() {
    echo -e "${RED}Attention! Vous devez d'abbord installer Nginx, MariaDB et PhpMyAdmin !${NC}"
    echo -e ""
    read -p "Voulez-vous utiliser un nom de domaine pour le Pterodactyl ? (y/n)" ptero_domain_boolean
    if [[ "$ptero_domain_boolean" == "y" ]]; then
      echo $e "${RED}Attention, le nom de domaine doit pointé vers l'adresse IP du serveur."
      read -p "Entrez le nom de domaine: " ptero_domain
    else
      read -p "Entrez l'adresse IP du serveur web (exemple : 10.0.10.12):" ptero_without_ssl_ip
      read -p "Entrez le port à utiliser (exemple : 9443):" ptero_without_ssl_port
    fi
    echo -e ""
    read -p "Entrez le mot de passe de l'utilisateur Pterodactyl (MariaDB) : " pterodactyl_bdd_password

    apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
    curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
    apt update -y
    apt-add-repository universe
    apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} tar unzip git redis-server
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    mkdir -p /var/www/pterodactyl
    cd /var/www/pterodactyl
    curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
    tar -xzvf panel.tar.gz
    chmod -R 755 storage/* bootstrap/cache/
    sudo mysql -e "CREATE USER 'pterodactyl'@'127.0.0.1' IDENTIFIED BY '${pterodactyl_bdd_password}';"
    sudo mysql -e "CREATE DATABASE panel;"
    sudo mysql -e "GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'127.0.0.1' WITH GRANT OPTION;"
    sudo mysql -e "FLUSH PRIVILEGES;"
    cp .env.example .env
    composer install --no-dev --optimize-autoloader
    php artisan key:generate --force
    php artisan p:environment:setup
    php artisan p:environment:database
    php artisan migrate --seed --force
    php artisan p:user:make
    chown -R www-data:www-data /var/www/pterodactyl/*
    
    

    config_file="/etc/systemd/system/pteroq.service"

cat << EOF | sudo tee $config_file > /dev/null
[Unit]
Description=Pterodactyl Queue Worker
After=redis-server.service

[Service]
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable pteroq.service
    sudo systemctl start pteroq.service





    sudo systemctl enable --now redis-server
    sudo systemctl enable --now pteroq.service
    if [[ "$ptero_domain_boolean" == "y" ]]; then
      sudo apt update -y
      sudo apt install python3-certbot-nginx -y
      certbot --nginx -d $ptero_domain
      cat << EOF | sudo tee /etc/nginx/sites-enabled/pterodactyl.conf > /dev/null
server_tokens off;
server {
    listen 80;
    server_name $ptero_domain;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $ptero_domain;

    root /var/www/pterodactyl/public;
    index index.php;

    access_log /var/log/nginx/pterodactyl.app-access.log;
    error_log  /var/log/nginx/pterodactyl.app-error.log error;

    # allow larger file uploads and longer script runtimes
    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    # SSL Configuration - Replace the example $ptero_domain with your domain
    ssl_certificate /etc/letsencrypt/live/$ptero_domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$ptero_domain/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
    ssl_prefer_server_ciphers on;

    # See https://hstspreload.org/ before uncommenting the line below.
    # add_header Strict-Transport-Security "max-age=15768000; preload;";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header Content-Security-Policy "frame-ancestors 'self'";
    add_header X-Frame-Options DENY;
    add_header Referrer-Policy same-origin;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        include /etc/nginx/fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
    else
      cat << EOF | sudo tee /etc/nginx/sites-enabled/pterodactyl.conf > /dev/null
server {
    listen $ptero_without_ssl_port;
    server_name $ptero_without_ssl_ip;

    root /var/www/pterodactyl/public;
    index index.html index.htm index.php;
    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/pterodactyl.app-error.log error;

    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
    fi
    systemctl restart nginx
    curl -sSL https://get.docker.com/ | CHANNEL=stable bash
    systemctl enable --now docker
    GRUB_CMDLINE_LINUX_DEFAULT="swapaccount=1"
    mkdir -p /etc/pterodactyl
    curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
    chmod u+x /usr/local/bin/wings
    cat << EOF | sudo tee /etc/systemd/system/wings.service > /dev/null
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    systemctl enable --now wings
}

update_ptero() {
  cd /var/www/pterodactyl
  php artisan down
  curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
  chmod -R 755 storage/* bootstrap/cache
  composer install --no-dev --optimize-autoloader
  php artisan view:clear
  php artisan config:clear
  php artisan migrate --seed --force
  chown -R www-data:www-data /var/www/pterodactyl/*
  php artisan queue:restart
  php artisan up
  echo -e "${YELLOW}La mise à jours de Pterodactyl a été éffectué.${NC}"
}


# Afficher le menu et demander à l'utilisateur de saisir une option
while true
do
  display_menu
  read -p "Choisissez l'option que vous souhaitez : " choice
  case $choice in
    1)
      update_system
      ;;
    2)
      install_packages
      ;;
    3)
      install_speedtest
      ;;
    4)
      create_user
      ;;
    5)
      update_system
      install_packages
      create_user
      ;;
    6)
      create_minecraft_server
      ;;
    7)
      create_bungeecord_server
      ;;
    8)
      create_fivem_server
      ;;
    9)
      install_ptero
      ;;
    10)
      update_ptero
      ;;
    11)
      install_nginx_php
      ;;
    12)
      install_phpmyadmin
      ;;
    13)
      install_plesk
      ;;
    14)
      setup_mariadb_server
      ;;
    15)
      echo "Merci d'avoir utiliser le script d'installation Linux de Tom's Tools.${NC}"
      exit 0
      ;;
    *)
      echo "Option invalide. Veuillez choisir une option valide.${NC}"
      ;;
  esac
done
