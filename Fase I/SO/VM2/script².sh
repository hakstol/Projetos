#!bin/bash

cls
octeto1=$(hostname -I | awk '{print $2}' | awk -F "." '{print $1}')
octeto2=$(hostname -I | awk '{print $2}' | awk -F "." '{print $2}')

id=$octeto1.$octeto2

echo "Iniciando varredura de IPs..."
if [ "$id" = "192.168" ]
then 
nmap -sV 192.168.0-255.1-127 | grep -Eo [0-9.][0-9.][0-9.]+$
ip_VM1=$(nmap -sV 192.168.0-255.1-127 | grep -Eo [0-9.][0-9.][0-9.]+$)
fi

if [ "$id" = "172.16"]
then nmap -sV 172.16.0-255.1-127 | grep -Eo [0-9.][0-9.][0-9.]+$
ip_VM1=$(nmap -sV 172.16.0-255.1-127 | grep -Eo [0-9.][0-9.][0-9.]+$)
fi


if [ "$id" = "10.0" ]
then nmap -sV 10.0-255.1-127 | grep -Eo [0-9.][0-9.][0-9.]+$ 
ip_VM1=$(nmap -sV 10.0-255.1-127 | grep -Eo [0-9.][0-9.][0-9.]+$)
fi

cls
echo ""
echo "O ip da VM2 é: $ip_VM1"
echo ""
echo "Deseja pingá-lo? [s/n]"

read resposta

        if [ $resposta = "s" ]
        then
          echo""
          ping $ip_VM1
          echo""        
        else
        exit
        fi
echo ""

