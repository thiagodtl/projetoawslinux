# 🌐 A parte do AWS consistia em

## • Gerar uma chave pública para acesso ao ambiente;
## • Criar 1 instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16 GB SSD);
## • Gerar 1 elastic IP e anexar à instância EC2;
## • Liberar as portas de comunicação para acesso público: (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP).


## 🔑 Gerar uma Chave Pública para Acesso ao Ambiente

### Criando um Par de Chaves
No Console AWS, navegue até **EC2** e clique em **Pares de Chaves** no painel esquerdo, na seção **Rede e Segurança**
Clique em **Criar par de chaves**. <br>
Nomeie a chave como desejar. <br>
Escolha o formato `pem` para Linux/macOS ou `ppk` para Windows.
Clique em **Criar par de chaves** e o arquivo será baixado automaticamente.


## 🛠️ Criar uma VPC e Subnets

### Criando uma VPC para ter acesso a internet 
Acessar o Painel VPC.
Clicar **Criar VPC**.
[image](https://github.com/user-attachments/assets/4728e760-f281-4ab3-8467-459ad1bf594a)

**Selecionar "Somente VPC"**
Preencher conforme sua necessidade:
   - **Tag de nome**: `minha-vpc`
   - **Marcar** `"Entrada manual de CIDR IPv4"`
   - **CIDR IPv4**: `10.0.0.0/24`
   - **Marcar** `"Nenhum bloco CIDR IPv6"`
**Adicionar tag, se for sua necessidade.**
Por fim, clicar em **Criar VPC VPC**.

### Criando Sub-rede
No painel de VPC, clicar em **Sub-redes** e depois em **Criar sub-rede**.
![image](https://github.com/user-attachments/assets/ab9a319e-0274-4c11-9167-07bf6f9ffc35)

Preencher conforme sua necessidade:
   - **ID da VPC** `selecione a vpc criada anteriormente`
   - **Nome da sub-rede**: `minha-subnet-publica`
   - **Zona de disponibilidade**: Selecione uma AZ disponível (ex: `us-east-1a`)
   - **Bloco CIDR IPv4 da VPC**: `10.0.0.0/24`
Clique em **Criar sub-rede**.


### Configurando uma Internet Gateway
No painel de VPC, clique em **Internet Gateways** e depois em **Criar gateway da internet**.
![image](https://github.com/user-attachments/assets/8b2bd206-92b7-4ed9-b885-4c2d975fe09d)

Nomeie o gateway como  desejar.
Depois de criar, precisamos associa-lá à uma VPC, selecione o Gateway criado e depois vá em **Ações** e depois **Associar à VPC**.
![image](https://github.com/user-attachments/assets/578cfe64-e881-4ce6-b234-19e524f35c23)

Selecione e VPC que foi criada e clique em **Associar à VPC**, no meu caso já tinha feito essa associação.

### Atualizando a Tabela de Rotas
No painel de VPC, clicar em **Tabelas de Rotas** e selecione a tabela de rotas associada à VPC que foi criada.
Clique em **Editar Rotas** e adicione uma nova rota:
   - **Destino**: `10.0.0.0/24`
   - **Alvo**: Selecione o gateway criado
   - No meu caso, ficou assim:
     ![image](https://github.com/user-attachments/assets/44da1dc0-71b9-481a-bf83-ab1685ef6e9f)
Salve as alterações.

## 🖥️ Criando uma Instância EC2

### Configuraando e executando a Instância EC2
No Console AWS, navegue até **EC2** e clique em **Instâncias**.
Clique em **Executar Instâncias**.
Selecione **Amazon Linux 2 AMI**.
![image](https://github.com/user-attachments/assets/66000038-d087-4e4a-a229-1b0e7ddd3a26)

Escolha a família **t3.small** como tipo de instância.
Configure os detalhes da instância:
**Número de instâncias**: `1`
**Configurações de rede**: Selecione a VPC criada anteriormente
**Sub-rede**: Selecione a sub rede criada anteriomente
**Desmarque a opção Atribuir IP público automaticamente**
Adicione um volume de armazenamento:
**(GiB)**: `16`
**Volume raiz (Não criptografado)**: `SSD de uso geral (gp2)`
**Adicione tags (opcional):**
Configure o **Grupo de Segurança**:
   - Adicione regras para permitir o acesso nas seguintes portas:
     - **22/TCP**: Para SSH
     - **111/TCP e UDP**: Para serviços RPC (necessário para NFS)
     - **2049/TCP e UDP**: Para NFS
     - **80/TCP**: Para HTTP
     - **443/TCP**: Para HTTPS
Depois de tudo configurado, clique em **Executar Instância**.

## 🌐 Gerar um Elastic IP e Anexar à Instância EC2

No Console AWS, navegue até **EC2** e clique em **Rede e segurança** e depois em **IPs elásticos** no painel esquerdo.
Clique em **Alocar endereço de IP elástico**.
![image](https://github.com/user-attachments/assets/ced50cc3-ecb4-4e26-86dd-28fa2a08a303)

Marque a opção **Conjunto de endereços IPv4 da Amazon** e depois clique em **Alocar**

### Associar o IP elástico à Instância
Após alocar o IP elástico, clique em **Ações** e selecione **Associar endereço IP elástico**.
Selecione a instância
Clique em **Associar**.

## 🔓 Configurar Regras de Segurança

### Verificar as Regras de Segurança no Security Group
No Console AWS, navegue até **EC2** e clique em **Security groups** que fica dentro de **Rede e segurança** no menu esquerdo.
Localize e selecione o Security Group associado à instância que foi criada
Verifique se as seguintes portas estão liberadas:
   - **22/TCP**: Acesso SSH
   - **111/TCP e UDP**: RPC para NFS
   - **2049/TCP e UDP**: NFS
   - **80/TCP**: HTTP
   - **443/TCP**: HTTPS

Conforme imagem abaixo:

![image](https://github.com/user-attachments/assets/56ff4d6d-a8a5-4c54-9ab1-27ca8c8e38fb)


# Antes de começar o linux, precisamos logar em nossa máquina no AWS.
## Uma forma é com a chave que foi criada direto da sua maquina local rodando linux
`ssh -i "arquivo.pem" usuario@IP_DA_MAQUINA`

## Outra forma é direto no Painel de instância do AWS, selecionado-a e clicando em Conectar.

![image](https://github.com/user-attachments/assets/5d89832a-0d92-4238-8b4e-6a234d47a150)


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

### Garantido que o contrab inicie junto com a maquina mesmo que a reinicie ou desligue
sudo systemctl enable crond

