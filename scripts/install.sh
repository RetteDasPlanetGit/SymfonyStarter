echo ""
echo "               Symfony Starter Installer Script              "
echo "This script requires sudo access. Please enter your password:"
echo ""

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
echo "Updating System and install needed packages..."
echo ""

sudo apt update && apt upgrade -y
sudo apt install curl -y

echo ""
echo "Installing Docker & Docker Compose..."
echo ""

curl -fsSL https://get.docker.com -o get-docker.sh &&
sudo sh get-docker.sh &&
sudo usermod -aG docker "$USER" &&
sudo systemctl enable docker &&
sudo systemctl start docker &&
sudo apt install docker-compose-plugin -y

echo ""
echo "Cloning Repository..."
echo ""

git clone https://github.com/RetteDasPlanetGit/SymfonyStarter.git &&
cd SymfonyStarter

echo ""
echo "Generate new APP_SECRET value..."
echo ""

APP_SECRET=$(openssl rand -hex 32)
sed -i "s|^APP_SECRET=.*$|APP_SECRET=$APP_SECRET|" .env

echo ""
echo "Build and start containers..."
echo ""

sudo docker compose build --build-arg APP_UID="$(id -u)" --build-arg APP_GID="$(id -g)" &&
sudo docker compose up -d

echo ""
echo "Install Composer Packages..."
echo ""

sudo docker compose exec app composer install

echo ""
echo "Finished! You can reach your Symfony App on https://localhost"
echo ""