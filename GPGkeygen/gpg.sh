#!/bin/bash

source utils.sh

BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[37m"
BLUE="\e[34m"
MAGENTA=" \e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
RESET="\e[0m"
echo -e "${WHITE}-----WELCOME TO GPG KEY MANAGER------${RESET}"
exit_var=0
while [ $exit_var -eq 0 ];
do
    key_exists
    if [ $keys -eq 0 ];
    then
        echo -e "${GREEN} There are no keys associated with this account. Do you wish to: ${RESET}"
        echo -e "${RED} 0. Exit. ${RESET}"
        echo -e "${YELLOW} 1. Set up a new key. ${RESET}"
    else 
        echo -e "${GREEN} There are ${keys} keys associated with this account. Do you wish to: ${RESET}"
        echo -e "${RED} 0. Exit. ${RESET}"
        echo -e "${YELLOW} 1. Set up a new key. ${RESET}"
        echo -e "${CYAN} 2. Work with an existing key. ${RESET}"
        echo -e "${WHITE} 3. Delete a key. ${RESET}"
        echo -e "${BLUE} 4. View existing keys. ${RESET}"
    fi
    read -p "enter the corresponding number : " num
    if [ $num -eq 1 ];
    then
        key_exists
        gpg --full-generate-key
        newkey = ${key[keys]}
        work_key ${newkey}
    elif [ $num -eq 2 ];
    then
        listkeys
        read numkey
        existkey=${key[keys-numkey+1]}
        work_key ${existkey}
    elif [ $num -eq 3 ];
    then
        listkeys
        read delkey
        exkey=${key[keys-delkey+1]}
        echo $exkey
        del_key ${exkey}
    elif [ $num -eq 4 ];
    then
        listkeys
    else
        echo "invalid input"
        exit
        ((exit_var++))
    fi
done
    


