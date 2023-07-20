#!/bin/bash

#Adicionar configuração de interface
nova()
{
cls
funcao="nova"
sudo chown $USER /etc/netplan/50-vagrant.yaml
sudo chown $USER /interfaces
> /etc/netplan/50-vagrant.yaml

#Verifica se existe uma pasta de configuração
if [ -e /interfaces ]
then
echo "  A pasta de configurações já existe"
else
sudo mkdir /interfaces
echo "A pasta de configurações foi criada"
fi
#Termina a verificação
echo    "============================================================"
echo    "|                    Nova configuração                     |"
echo    "============================================================"
echo -n " Escreva o nome da configuração: [ ] "

read nome
if [ -f /interfaces/$nome ]
then
 echo "Já existe uma configuração salva com esse nome. Deseja sobreescrevê-lo? [s/n]"
read resposta2
 case $resposta2 in
 s)
 sudo rm /interfaces/$nome
 ;;
 n)
 echo "Por favor, insira outro nome:"
 read nome1
if [ "$nome" = "$nome1" ]
 then
  echo ""
  echo "Não foi possível criar arquivo de configuração."
  echo""
  exit
 fi
 ;;
 esac
fi


echo ""
echo    "============================================================"
echo -n " Escreva o nome da interface: [ enp0s8 ] "
read interface

   if [ -z $interface ]
   then
      interface=""
   fi

echo    "============================================================"
echo -n " Escreva como deseja usar a interface: 1 [dhcp4] ou 2 [static] "
read modo
echo    "============================================================"
   case $modo in
   2)
   echo -n "Digite o endereço IP (ex. 192.168.0.2): "
   read ip
   echo -n "Digite a mascara (ex. /24): "
   read mascara
   echo -n "Digite o gateway (opcional): "
   read gateway
   modo="static"
   ;;

   1)
   echo "Usando DHCP"
   > /etc/netplan/50-vagrant.yaml
   modo="dhcp4"
   ;;
   esac
echo    "============================================================"
echo -n "Deseja salvar o arquivo de configuração? [s/n] "
read opcao


#Você deseja salvar o arquivo
if [ $opcao = "s" ]
then
opcao=""
        if [ $modo = "dhcp4" ]
        then
        sudo echo "" >> /etc/netplan/50-vagrant.yaml
        sudo echo "#Configuração: $nome" >> /etc/netplan/50-vagrant.yaml
        sudo echo "network:" >> /etc/netplan/50-vagrant.yaml
        sudo echo "    ethernets:" >> /etc/netplan/50-vagrant.yaml
        sudo echo "      $interface:" >> /etc/netplan/50-vagrant.yaml
        sudo echo "        $modo: true" >> /etc/netplan/50-vagrant.yaml
        sudo echo "    version: 2" >> /etc/netplan/50-vagrant.yaml
        fi

        if [ $modo = "static" ]
        then
                estatico
        fi

sudo netplan generate
sudo netplan apply
fi
echo ""
sudo cat /etc/netplan/50-vagrant.yaml
echo ""

echo -n "Salvar a configuração como está? [s/n] "
read salvar

   if [ $salvar = "s" ]
   then
      sudo cp /etc/netplan/50-vagrant.yaml /interfaces/$nome
      echo ""
      echo "Salvo."
      echo ""
   else
      echo ""
      echo "Não salvo." 
      echo ""
   fi

      ifconfig enp0s8
      echo ""
      echo "A VM1 já está com a interface de rede configurada? [s/n]  "
      read resposta3
      case $resposta3 in 
      s)
      resposta3="s"
      if [ $resposta3 = "s" ]
      then
       cls
       pingVM2
      fi
      ;;

      n)
      resposta3="n"
      if [ $resposta3 = "n" ]
      then
      while true
        do
        [ "$tecla" = "a" ]  && break
        echo ""
        echo "Pressione a para continuar..."
        sleep 1
        read tecla
        echo ""
        done
      fi
      ;;
      esac

      echo ""
      echo "A VM1 já está com a interface de rede configurada? [s/n]  "
      read resposta4
      if [ "$resposta4" = "s" ]
      then 
       cls
       pingVM2
      else 
       exit
      fi

}

#Fazer configuração estática
estatico() 
{

#Verifica se foi digitado algo nas variáveis, se não, ele preenche ou ignora

sudo echo "#Configuração: $nome" >> /etc/netplan/50-vagrant.yaml
sudo echo "network:" >> /etc/netplan/50-vagrant.yaml
sudo echo "  version: 2" >> /etc/netplan/50-vagrant.yaml
sudo echo "  renderer: networkd" >> /etc/netplan/50-vagrant.yaml
sudo echo "  ethernets:" >> /etc/netplan/50-vagrant.yaml
sudo echo "    $interface:" >> /etc/netplan/50-vagrant.yaml
sudo echo "       addresses:" >> /etc/netplan/50-vagrant.yaml
sudo echo "       - $ip$mascara" >> /etc/netplan/50-vagrant.yaml


        if [ -z $gateway ]
        then
                sudo echo "          #gateway4" >> /etc/netplan/50-vagrant.yaml
                else
                sudo echo "          gateway4: $gateway" >> /etc/netplan/50-vagrant.yaml
        fi

}

nova
