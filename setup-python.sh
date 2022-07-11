
sudo apt update && sudo apt upgrade
sudo apt install python3.8-venv

python3 -m venv /home/ubuntu/substrate-env
sudo sh /home/ubuntu/substrate-env/bin/activate
sudo apt install python3-pip
pip3 install substrate-interface
