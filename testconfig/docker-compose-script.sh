sudo curl -SL https://github.com/docker/compose/releases/download/v2.32.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo DOCKER_IMAGE=$1 docker-compose -f /home/ec2-user/testconfig/docker-compose.yml up -d