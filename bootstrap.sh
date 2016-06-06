sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo 'Install Docker Engine'
wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $(whoami)

echo 'Install Docker Compose'
sudo apt-get -y install python-pip
sudo pip install docker-compose

echo 'Pull Docker base images'
# sudo docker pull php:apache
# sudo docker pull postgres:latest
sudo docker pull hnquang112:php7-laravel

echo 'Build Docker images'
# sudo docker build -t hnquang112:php7-laravel ./web/
# sudo docker build -t hnquang112:php7-laravel ./web/