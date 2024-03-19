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

    case $num in
    0)
        echo "Exiting."
        exit 2
        ;;
    1|2|3|4)
        echo "You chose option $num."
        ;;
    *)
        handle_error
        ;;
    esac

    if [ $num -eq 1 ];
    then
        setupnewkey
    elif [ $num -eq 2 ];
    then
        workwitholdkey
    elif [ $num -eq 3 ];
    then
        deleteoldkey
    elif [ $num -eq 4 ];
    then
        listkeys
    else
        ex
        exit 2
        ((exit_var++))
    fi
done
    


