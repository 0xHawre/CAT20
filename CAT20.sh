#!/bin/bash

# Update system and install Docker
sudo apt update && sudo apt install -y curl && curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh

# Install curl and jq if they are not already installed
dpkg -l | grep -q '^ii  curl ' || sudo apt-get install -y curl
dpkg -l | grep -q '^ii  jq ' || sudo apt-get install -y jq

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install npm and yarn
sudo apt-get install npm -y
sudo npm i n -g
sudo n stable
sudo npm i -g yarn

# Clone the CAT Protocol repository and build
git clone https://github.com/CATProtocol/cat-token-box && cd cat-token-box
sudo chown -R $USER:$USER ~/cat-token-box
sudo yarn install 
sudo yarn build

# Set up the tracker
cd ./packages/tracker/
sudo chmod 777 docker/data 
sudo chmod 777 docker/pgdata
sudo docker compose up -d

# Build the tracker Docker image
cd ../../ 
sudo docker build -t tracker:latest .

# Read node name from user input
read -p "node name: " vname

# Run the Docker container for the tracker
sudo docker run -d \
  --name $vname \
  --add-host="host.docker.internal:host-gateway" \
  -e DATABASE_HOST="host.docker.internal" \
  -e RPC_HOST="host.docker.internal" \
  -p 3000:3000 \
  tracker:latest

# Set up CLI config
cd cat-token-box/
cd packages/cli

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

# Create and display wallet address
sudo yarn cli wallet create
sudo yarn cli wallet address

# Prompt user if they want to see their seed and validate input
while true; do
    echo "Do you want to see your seed? (yes/no)"
    read answer
    if [ "$answer" = "yes" ]; then
        cat wallet.json
        break
    elif [ "$answer" = "no" ]; then
        echo "Continuing without showing the seed."
        break
    else
        echo "Invalid input. Please enter 'yes' or 'no'."
    fi
done
