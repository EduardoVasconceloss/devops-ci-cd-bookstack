#!/bin/bash

# Atenção: esse script foi criado para instalar o ansible no Debian.

# Atualiza os repositórios e pacotes
sudo apt update -y

# Instala dependências para permitir que o APT use repositórios HTTPS
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Adiciona a chave GPG oficial do Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Configura o repositório estável do Docker
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Atualiza os repositórios mais uma vez
sudo apt update -y

# Instala o Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose 

# Adiciona o usuário atual ao grupo do docker para executar comandos Docker sem o "sudo"
sudo usermod -aG docker $USER

# Habilita e inicia o serviço do Docker
sudo systemctl enable docker
sudo systemctl start docker

# Verifica a versão do Docker instalada
docker --version

