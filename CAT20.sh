#!/bin/bash

sudo apt update && sudo apt install -y curl && curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh

dpkg -l | grep -q '^ii  curl ' || sudo apt-get install -y curl && dpkg -l | grep -q '^ii  jq ' || sudo apt-get install -y jq

sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo apt-get install npm -y

sudo npm i n -g

sudo n stable

sudo npm i -g yarn

git clone https://github.com/CATProtocol/cat-token-box && cd cat-token-box
sudo chown -R $USER:$USER ~/cat-token-box

sudo yarn install && yarn build

cd packages/tracker

sudo chmod 777 docker/data && sudo chmod 777 docker/pgdata && sudo docker compose up -d

cd $HOME/cat-token-box && sudo docker build -t tracker:latest .

read -p "node name : vname

sudo docker run -d \
  --name $(vname) \
    --add-host="host.docker.internal:host-gateway" \
    -e DATABASE_HOST="host.docker.internal" \
    -e RPC_HOST="host.docker.internal" \
    -p 3000:3000 \
    tracker:latest

cd $HOME/cat-token-box/packages/cli

cat <<EOF > config.json
{
  "network": "fractal-mainnet",
  "tracker": "http://127.0.0.1:3000",
  "dataDir": ".",
  "maxFeeRate": 1000,
  "rpc": {
      "url": "http://127.0.0.1:8332",
      "username": "bitcoin",
      "password": "opcatAwesome"
  }
}
EOF

sudo yarn cli wallet create

sudo yarn cli wallet address


echo "Do you want to see your seed? (yes/no)"
read answer

if [ "$answer" = "yes" ]; then
    cat wallet.json
else
    echo "Continuing without showing the seed."
fi
