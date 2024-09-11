#!/bin/bash


sudo apt-get update

check_and_install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Installing Docker..."
        
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

        sudo apt-get update
        sudo apt-get install -y docker-ce

        echo "Docker has been installed."
    else
        echo "Docker is already installed."
    fi
}

check_and_install_docker

VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')

DESTINATION=/usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION

sudo apt-get install npm -y

sudo npm install n -g
sudo n stable
sudo npm i -g yarn

git clone https://github.com/CATProtocol/cat-token-box
cd cat-token-box

sudo yarn install && sudo yarn build

cd ./packages/tracker/

sudo chmod 777 docker/data
sudo chmod 777 docker/pgdata

sudo docker-compose up -d

cd ../../

sudo docker build -t tracker:latest .

sudo docker run -d \
    --name tracker \
    --add-host="host.docker.internal:host-gateway" \
    -e DATABASE_HOST="host.docker.internal" \
    -e RPC_HOST="host.docker.internal" \
    -p 3000:3000 \
    tracker:latest

sudo yarn cli wallet create

sudo yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5

command="sudo yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5"

while true; do
    $command

    if [ $? -ne 0 ]; then
        echo "Command execution failed, exiting loop"
        exit 1
    fi

    sleep 1
done

chmod +x script.sh

