#!/bin/bash

echo ""
echo "               Symfony Starter Installer Script              "
echo "This script requires sudo access. Please enter your password:"
echo ""

echo ""
echo "Please enter a Project Name:"
echo ""

read -r projectname

echo ""
echo " Updating System and installing needed packages... "
echo ""

sudo apt update && sudo apt upgrade -y
sudo apt install curl -y

echo ""
echo " Installing Docker & Docker Compose... "
echo ""

curl -fsSL https://get.docker.com -o get-docker.sh &&
sudo sh get-docker.sh &&
sudo usermod -aG docker "$USER" &&
sudo systemctl enable docker &&
sudo systemctl start docker &&
sudo apt install docker-compose -y

echo ""
echo " Cloning Repository... "
echo ""

git clone https://github.com/RetteDasPlanetGit/SymfonyStarter.git "$projectname" &&
cd "$projectname"

echo ""
echo " Generating new APP_SECRET value... "
echo ""

APP_SECRET=$(openssl rand -hex 32)
sed -i "s|^APP_SECRET=.*$|APP_SECRET=$APP_SECRET|" .env

echo ""
echo "Building and starting containers..."
echo ""

sudo docker-compose build --build-arg APP_UID="$(id -u)" --build-arg APP_GID="$(id -g)" &&
sudo docker-compose up -d

echo ""
echo "Installing Composer Packages..."
echo ""

sudo docker-compose exec app composer install

echo ""
echo "Finished! You can reach your Symfony App at https://localhost"
echo ""
