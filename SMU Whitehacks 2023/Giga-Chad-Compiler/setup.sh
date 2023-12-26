#!/bin/sh

#Tested on Ubuntu 18.04, running setup.sh as root (running within /home/ubuntu workdir)
cd /home/ubuntu

#Install python3 and pip3
apt-get update
apt-get install -y python3.8 python3-pip systemd
python3.8 -m pip install --upgrade pip
python3.8 -m pip install py-cord==2.4.0

#Add docker repo
apt-get install -y ca-certificates curl gnupg lsb-release
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install Docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

#Create service to run main.py
cat << EOF > /etc/systemd/system/main.service
[Unit]
Description=Bot for WH2023 Giga-Chad-Compiler
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/python3.8 /home/ubuntu/main.py
Restart=always

[Install]
WantedBy=multi-user.target

EOF

#Enable service
systemctl enable main.service

#Start service
systemctl start main.service

echo "Setup complete!"