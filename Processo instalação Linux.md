# Primeiro precisamos baixar a distribuição que queremos instalar, neste caso usaremos o Debian.

## 📥 Download da Imagem ISO do Debian

Acesse o site oficial do Debian: [Debian Downloads](https://www.debian.org/distrib/).

## 💿 Crie um Disco/Pen Drive de Boot com a Imagem ISO

## 🔧 Preparando o Sistema

### Configurar o BIOS/UEFI para Bootar a Partir do USB ou DVD

Reinicie seu computador e entre no BIOS/UEFI. (Geralmente apertando F2)
No menu de boot, configure o pendrive ou DVD como o primeiro dispositivo de boot.
Salve as alterações e reinicie o computador.

## 🚀 Iniciando a Instalação do Debian

### Bootar no Instalador do Debian

Se tudo der certo, o seu computador irá iniciar com o boot da instalação do Debian

Escolha o modo de instalação:
   - **Graphical install**: Para uma instalação com interface gráfica.
   - **Install**: Para uma instalação gráfica básica.
   - **Advanced options**: Para opções avançadas, como recuperação do sistema.

Nesse caso, vamos escolher **Install**

![image](https://github.com/user-attachments/assets/f5983fd4-d6c5-46d2-bce3-f08742aa8da5)

### Proximos passos são os seguintes:
- **Escolher a linguagem**
- **Configurar o teclado**
- **Escolher a rede**
- **Configurar usuários e senhas**
- **Particionar o disco**
Aqui escolheremos **Manual**

### Seleciona-se o disco rigido e será criada 4 partições
**1) 300mb de espaço, primária e o ponto de montagem será o /boot**
**2) 20gb de espaço, primária e o ponto de montagem será /**
**3) 11gb de espaõ, primária e o ponto de montagem será /home**
**4) 1.1gn de espaço, primária, clicar em "usuar como" e mudar a partição para "swap"**

#### A simulação acima foi feita com base num HD com 30gb.

### Os demais passos são os seguintes:
- **Configuração de repositório**
- **Configuração de proxy (se houver)**
- **Participação no concurso de utilização de pacotes (ser informado dos pacotes mais usados)**
- **Seleção de softwares (escolher o de sua preferência)**
- **Configurar o GRUB**

## 🖥️ Pronto, seu Linux Debian foi instalado.

## Reinicie sua maquina e voilà, bem vindos ao Debian.

## Após a instalação, assim que logar como root, atualize os pacotes com os comandos abaixo:

```bash
sudo apt update
sudo apt upgrade -y

