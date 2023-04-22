#!/bin/bash

YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'
VERSION='v1.1.0'

# Fonction pour afficher les options disponibles
display_menu() {
  echo -e "${YELLOW}
  
████████╗░█████╗░███╗░░░███╗██╗░██████╗  ████████╗░█████╗░░█████╗░██╗░░░░░░██████╗░░░░██████╗██╗░░██╗
╚══██╔══╝██╔══██╗████╗░████║╚█║██╔════╝  ╚══██╔══╝██╔══██╗██╔══██╗██║░░░░░██╔════╝░░░██╔════╝██║░░██║
░░░██║░░░██║░░██║██╔████╔██║░╚╝╚█████╗░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░╚█████╗░░░░╚█████╗░███████║
░░░██║░░░██║░░██║██║╚██╔╝██║░░░░╚═══██╗  ░░░██║░░░██║░░██║██║░░██║██║░░░░░░╚═══██╗░░░░╚═══██╗██╔══██║
░░░██║░░░╚█████╔╝██║░╚═╝░██║░░░██████╔╝  ░░░██║░░░╚█████╔╝╚█████╔╝███████╗██████╔╝██╗██████╔╝██║░░██║
░░░╚═╝░░░░╚════╝░╚═╝░░░░░╚═╝░░░╚═════╝░  ░░░╚═╝░░░░╚════╝░░╚════╝░╚══════╝╚═════╝░╚═╝╚═════╝░╚═╝░░╚═╝
  ${NC}"
  echo -e "${YELLOW}Voici les options disponible sur la version actuel du script, que voulez-vous faire ?"
  echo -e "${BLUE}1. ${YELLOW}Mettre à jour le système"
  echo -e "${BLUE}2. ${YELLOW}Installer des packages de base ${BLUE}(bash, curl, sudo, wget, nload, htop, git)"
  echo -e "${BLUE}3. ${YELLOW}Créer un nouvel utilisateur"
  echo -e "${BLUE}4. ${YELLOW}Tout faire ${BLUE}(1, 2 et 3)"
  echo -e "${BLUE}5. ${YELLOW}Créer et lancer un serveur ${BLUE}Minecraft"
  echo -e "${BLUE}6. ${YELLOW}Quitter (Bye bye)"
}


# Vérification des mises à jour
if ! command -v curl &> /dev/null; then
    echo "Curl n'est pas installé. Installation en cours..."
    sudo apt-get update
    apt install curl -y
fi
echo -e "${YELLOW}Vérification des mises à jour...${NC}"
latest_version=$(curl -s https://raw.githubusercontent.com/tomnoel41/Tom-s-Tools/main/last_version.txt)
if [[ "$latest_version" != "$VERSION" ]]; then
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
  read -p "Veuillez saisir le nom d'utilisateur pour le nouvel utilisateur : " new_user
  read -s -p "Veuillez saisir le mot de passe pour le nouvel utilisateur : " new_password
  echo
  sudo adduser $new_user --gecos "User"
  if [[ "$give_permissions" == "y" ]]; then
    sudo usermod -aG sudo $new_user
    sudo usermod -aG root $new_user
  fi
  echo "$new_user:$new_password" | sudo chpasswd
}

create_minecraft_server() {
  # Vérifier si Java est installé
  if ! command -v java &> /dev/null; then
    echo "Java n'est pas installé. Installation en cours..."
    sudo apt-get update
    sudo apt-get install openjdk-17-jdk openjdk-17-jre -y
  fi
  
  # Demander à l'utilisateur de saisir la version du serveur
  read -p "Veuillez entrer la version de Spigot à installer (par exemple, '1.12.2'): " version

  # Demander à l'utilisateur la RAM max qu'il veut
  read -p "Veuillez entrer la valeur maximum de la RAM que vous souhaitez (par exemple, '4096' pour 4GB): " max_ram
  
  # Créer un dossier pour le serveur
  read -p "Veuillez entrer le chemin absolu où vous souhaitez créer le dossier pour le serveur: " server_path
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
    echo -e "${BLUE}D'accord, si vous souhaitez lancer le serveur, vous pouvez utiliser la commande './start.sh'."
  fi
}


# Afficher le menu et demander à l'utilisateur de saisir une option
while true
do
  display_menu
  read -p "Votre choix : " choice
  case $choice in
    1)
      update_system
      ;;
    2)
      install_packages
      ;;
    3)
      read -p "Voulez-vous donner les permissions sudo et root à cet utilisateur ? (y/n) : " give_permissions
      create_user
      ;;
    4)
      update_system
      install_packages
      read -p "Voulez-vous donner les permissions sudo et root à cet utilisateur ? (y/n) : " give_permissions
      create_user
      ;;
    5)
      create_minecraft_server
      ;;
    6)
      echo "Merci d'avoir utiliser le script d'installation Linux de Tom's Tools."
      exit 0
      ;;
    *)
      echo "Option invalide. Veuillez choisir une option valide."
      ;;
  esac
done
