# A parte do projeto em linux precisava fazer as seguintes configurações.

## 📦 Instalação e Configuração do NFS
### Instalando o cliente NFS
sudo yum install -y nfs-utils

### Criando pasta que será exportada
sudo mkdir -p /mnt/nfs_share

### Criando pasta que vai receber a exportação
sudo mkdir -p /mnt/nfs

### Configurando arquivo de exportação do NFS
sudo nano /etc/exports
#### Adicionar essa linha
/mnt/nfs_share IP_DO_SERVIDOR_NFS/24(rw,sync)

#### Explicando o motivo de rw e sync na linha
rw: Permite leitura e gravação para clientes NFS. <br>
sync: Garante que as alterações sejam gravadas no disco antes de responder ao cliente NFS. <br>

### Iniciar o serviço NFS
  sudo systemctl start nfs
  
### Configurando pra NFS rodar junto como boot da maquina
  sudo systemctl enable nfs

### Montando o diretório NFS
sudo mount -t nfs IP_DO_SERVIDOR_NFS:/mnt/nfs_share /mnt/nfs

### Configurando pra o diretório sempre ser montado no boot da maquina
sudo nado /etc/fstab

#### Adicionar a linha
IP_DO_SERVIDOR_NFS:/mnt/nfs_share /mnt/nfs nfs defaults 0 0

## 📁 Criação de uma pasta dentro do filesystem do NFS
sudo mkdir  /mnt/nfs_share/seu_nome

### 🌐 Instalação e Configuração do Apache
#### Instalando o apache
sudo yum install httpd -y

#### Iniciando o apache
sudo systemctl start httpd

#### Habilitar o Apache para iniciar automaticamente no boot
sudo systemctl enable httpd

### 🧰 Criação do Script de Validação do Apache
### ⏲ O script deve conter - Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou OFFLINE
### 🛠 script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço OFFLINE
sudo nano /usr/local/bin/teste_apache.sh

#### Adicionar as seguintes linhas

#!/bin/bash <br>
#Variaveis <br>
SERVICE="httpd" <br>
STATUS=$(systemctl is-active $SERVICE) <br>
TIMESTAMP=$(date +"%d-%m-%Y %H:%M:%S") <br>
NFS_DIR="/mnt/nfs_share/thiago" <br>
ONLINE_MSG="Positivo, o Apache está ONLINE" <br>
OFFLINE_MSG="Desculpe, mas o Apache está OFFLINE" <br>

#Verificando se o Apacha está Online ou Offline <br>
if [ "$STATUS" = "active" ]; then <br>
    echo "$TIMESTAMP - $SERVICE - $STATUS - $ONLINE_MSG" >> "$NFS_DIR/apache_online.log" <br>
else <br>
    echo "$TIMESTAMP - $SERVICE - $STATUS - $OFFLINE_MSG" >> "$NFS_DIR/apache_offline.log" <br>
fi 


### 🛠 Permitir que o script seja executável
sudo chmod +x /usr/local/bin/teste_apache.sh

### ⏲ Preparar a execução automatizada do script a cada 5 minutos.
sudo crontab -e

#### Adicionar a seguinte linha
*/5 * * * * /usr/local/bin/teste_apache.sh

### Garantido que o contrab inicie junto com a maquina mesmo que a reinicie ou delligue
sudo systemctl enable crond

