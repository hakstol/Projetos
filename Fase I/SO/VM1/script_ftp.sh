#!/bin/sh

#Instalação e confiuração FTP

sudo apt-get update
sudo apt-get install vsftpd -y
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.original # Cria arquivo de backup das config. do ftp
sudo mkdir /home/levi/ftp 
sudo chown nobody:nogroup /home/levi/ftp
sudo chmod a-w /home/levi/ftp
sudo mkdir /home/levi/ftp/arquivos
sudo chown levi:levi /home/levi/ftp/arquivos
sudo chown levi /etc/vsftpd.conf
echo "Isso é um teste" | sudo tee /home/levi/ftp/arquivos/arquivo.txt # Criar arquivo para teste de ftp
sudo sed -i "s/#write_enable=YES/write_enable=YES/g" /etc/vsftpd.conf # Descomentar linha arquivo
sudo sed -i "s/#chroot_local_user=YES/chroot_local_user=YES/g" /etc/vsftpd.conf # Descomentar linha arquivo
sudo echo "allowed_writeable_chroot=YES" >> /etc/vsftpd.conf
sudo echo "pasv_min_port=40000" >> /etc/vsftpd.conf # Adiciona portas de acesso ao arquivo
sudo echo "pasv_max_port=50000" >> /etc/vsftpd.conf # Adiciona portas de acesso ao arquivo
sudo systemctl restart vsftpd.service

HOST='192.168.15.33'
USER='levi'
PASSWD='root'
FILE='/home/levi/scripts/arquivo.txt'

sudo echo "Isso é um teste" >> arquivo.txt

ftp -n $HOST <<END_SCRIPT
quote user $USER
quote PASS $PASSWD
put $FILE
quit
END_SCRIPT
