#! /bin/bash

# Atenção: esse script foi criado para instalar o ansible no Debian 12.

# Atualiza os repositórios e pacotes
sudo apt update -y

# Instala o Ansible
sudo apt install -y ansible 

# Verifica a versão do Ansible instalada
ansible --version