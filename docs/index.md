## Bem vindo a documentação sobre o meu projeto de Devops e CI/CD!

Irei te ensinar como você pode instalar e fazer o "deploy" de aplicações web com Git, Jenkins, Ansible e Docker.

- Para facilitar a compreensão, recomendo que você analise esse diagrama que mostra como vai funcionar a comunicação entre os servidores:

![diagrama do projeto](assets/projeto_devops.drawio.png)

---

# Configurando os servidores

> **Nota:** Primeiramente, você precisa ter 3 servidores, um para o jenkins, outro para o ansible e o outro para a aplicação que desejamos instalar.

## Configure o arquivo hosts dos nodes

No seu server, você deve declarar quem é o ansible-node, quem é o jenkins-node e quem é o webapp-node para atribuir um IP à esses nodes.

Para fazer isso você deve alterar o arquivo "hosts", para isso, execute o seguinte comando: `nano /etc/hosts`

- Agora você pode modificar o arquivo, use meu arquivo hosts como referência.

```bash
127.0.0.1	localhost
127.0.1.1	ansible-node
172.24.9.81 jenkins-node
172.24.9.80 webapp-node

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

# LEMBRE-SE! Mude os IPs e os hostnames de acordo com sua necessidade, um IP e hostname que sirvam para mim podem não servir para você e vice-versa.
```

## Crie uma chave SSH para os nodes

Antes de tudo, você deve mudar uma linha em um arquivo de configuração do sistema, execute o seguinte comando:

```bash
nano /etc/ssh/sshd_config

# Altere a linha que contém "PermitRootLogin", ela deve ficar desse jeito:
PermitRootLogin yes
```

Para aplicar as alterações feitas, reinicie sua máquina, você pode usar o comando `sudo systemctl sshd`.

Para a conexão do cluster funcionar, precisamos da chave SSH. Somente assim as máquinas poderão comunicar-se entre si com segurança e agilidade. Execute o seguinte comando nos dois nodes para gerar a chave SSH:

```bash
ssh-keygen -t ed-25519
# Agora é só dar enter até cansar
```

Após isso, vamos criar um arquivo de configuração ssh nos dois nodes para automatizar a "passagem" das chaves SSH de um node para o outro. Crie um arquivo de configuração ssh com o comando `nano ~/.ssh/config`.

```bash
Host ansible-node
    Hostname ansible-node
    User root
Host jenkins-node
    Hostname jenkins-node
    User root
Host webapp-node
    Hostname webapp-node
    User root

# LEMBRE-SE! Mude o 'Host' e 'hostname' de acordo com sua necessidade
```

Além disso, mude as permissões do arquivo de configuração nos dois nodes com `chmod 600 ~/.ssh/config`.

Por fim, execute esses comandos, nos três servers, para "enviar" a chave ssh de um node para o outro:

```bash
ssh-copy-id ansible-node
ssh-copy-id jenkins-node
ssh-copy-id webapp-node
```

> **Atenção:** Para que a chave ssh seja autenticada pelo Jenkins, em cada node, você deve acessar cada servidor manualmente via ssh, exemplo:
>
> `ssh root@ansible-node`
>
> `ssh root@jenkins-node`
>
> `ssh root@webapp-node`

---

# Instalando o Jenkins no jenkins-node

Você pode instalar o Jenkins com o script que eu disponibilizei no repositório devops-ci-cd-bookstack. Há duas maneiras que você pode ter acesso ao script.

- **1° Opção:** Clone o repositório para fazer o download do script.

```bash
git clone https://github.com/EduardoVasconceloss/devops-ci-cd-bookstack.git
cd devops-ci-cd-bookstack
./install-jenkins.sh
```

- **2° Opção:** Crie o arquivo do script localmente nano install-jenkins.sh e cole o código abaixo no arquivo.

```bash
#!/bin/bash
# Script de instalação do Jenkins no Debian 12

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y
sudo apt install -y fontconfig openjdk-17-jre-headless openjdk-17-jre
sudo apt install -y jenkins
```

> **Lembre-se:** Se você optar por fazer a **2° opção**, você deve mudar as permissões do arquivo "install-jenkins.sh" com o comando `chmod +x install-jenkins.sh`. Agora para executar o script basta executar `./install-jenkins.sh`.
