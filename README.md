#  The CAT protocol
##  a new Bitcoin token protocol based on UTXO. It operates on the first layer through Bitcoin scripts and smart contracts (particularly Covenants). Technical features: no need for an indexer, modular and programmable, programmable minting, cross-chain interoperability, and SPV compatibility.

## 📌 Preparation: Create an Ubuntu server (LU), preferably on a foreign server, with a minimum configuration of 2 CPU cores and 4GB+ RAM.

## clone repo 
```sh 
git clone https://github.com/0xHawre/CAT20.git && cd CAT20
```
## run script
```sh 
chmod +x ./CAT20.sh  CAT20.sh && ./CAT20.sh 
```

## Show token balances
```sh
yarn cli wallet balances
```
![Screenshot 2024-09-11 at 10 57 19 PM](https://github.com/user-attachments/assets/10c0e258-a604-4533-bc14-1fd955dad853)

## wait to gain 100% then you can mint CAT 
## Use this command to mint with current market fee
```sh
sudo yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5 --fee-rate $(curl -s https://explorer.unisat.io/fractal-mainnet/api/bitcoin-info/fee | jq '.data.economyFee')```

