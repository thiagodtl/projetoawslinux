# 🌐 Guia de Configuração: AWS VPC, EC2, e Segurança

Este documento fornece um passo a passo para configurar uma infraestrutura básica na AWS, incluindo a criação de uma VPC, subnets, uma instância EC2, e as configurações de segurança necessárias.

##🛠️ Criar uma VPC e Subnets

### Criar uma VPC
Acessar o Painel VPC.
Clicar **Criar VPC**.
[image](https://github.com/user-attachments/assets/4728e760-f281-4ab3-8467-459ad1bf594a)

**Selecionar "Somente VPC"**
Preencher conforme sua necessidade:
   - **Tag de nome**: `minha-vpc`
   - **Marcar** `"Entrada manudla de CIDR IPv4"`
   - **CIDR IPv4**: `10.0.0.0/24`
   - **Marcar** `"Nenhum bloco CIDR IPv6"`
**Adicionar tag, se for sua necessidade.**
Por fim, clicar em **Criar VPC VPC**.

### Criar Sub-rede
No painel de VPC, clicar em **Sub-redes** e depois em **Criar sub-rede**.
![image](https://github.com/user-attachments/assets/ab9a319e-0274-4c11-9167-07bf6f9ffc35)

Preencher conforme sua necessidade:
   - **ID da VPC** `selecione a vpc criada anteriormente`
   - **Nome da sub-rede**: `minha-subnet-publica`
   - **Zona de disponibilidade**: Selecione uma AZ disponível (ex: `us-east-1a`)
   - **Bloco CIDR IPv4 da VPC**: `10.0.0.0/24`
Clique em **Criar sub-rede**.


### Configurar uma Internet Gateway
No painel de VPC, clique em **Internet Gateways** e depois em **Criar gateway da internet**.
![image](https://github.com/user-attachments/assets/8b2bd206-92b7-4ed9-b885-4c2d975fe09d)

Nomeie o gateway como  desejar `minha-igw`.
Depois de criar, precisamos associa-lá à uma VPC, selecione o Gateway criado e depois vá em **Ações** e depois **Associar à VPC**.
![image](https://github.com/user-attachments/assets/578cfe64-e881-4ce6-b234-19e524f35c23)

Selecione e VPC que foi criada e clique em **Associar à VPC**, no meu caso já tinha feito essa associação.

### Atualizar a Tabela de Rotas
No painel de VPC, clicar em **Tabelas de Rotas** e selecione a tabela de rotas associada à VPC que foi criada.
Clique em **Editar Rotas** e adicione uma nova rota:
   - **Destino**: `10.0.0.0/24`
   - **Alvo**: Selecione o gateway criado
   - No meu caso, ficou assim:
     ![image](https://github.com/user-attachments/assets/44da1dc0-71b9-481a-bf83-ab1685ef6e9f)
Salve as alterações.

## 🔑 Gerar uma Chave Pública para Acesso ao Ambiente

### Criar um Par de Chaves
No Console AWS, navegue até **EC2** e clique em **Pares de Chaves** no painel esquerdo, na seção **Rede e Segurança**
Clique em **Criar par de chaves**. <br>
![image](https://github.com/user-attachments/assets/d1b6f5dd-aa0d-4645-872f-d6fefd231b4d) <br>
Nomeie a chave como desejar. <br>
Escolha o formato `pem` para Linux/macOS ou `ppk` para Windows.
Clique em **Criar par de chaves** e o arquivo será baixado automaticamente.

## 🖥️ Criar uma Instância EC2

### Configurar e Lançar a Instância EC2
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

##🔓 Configurar Regras de Segurança

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



