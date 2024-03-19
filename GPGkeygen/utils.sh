declare -a key

key_exists() {
    keyno=$(gpg --list-secret-keys --keyid-format=long|awk /sec/|wc -l)
    keys=$keyno
    keys2=$keyno
    while [ $keyno -gt 0 ];
    do
        key[keyno]=$(gpg --list-secret-keys --keyid-format=long|awk /sec/|cut -b 15-30| sed "${keyno}q;d")
        ((keyno--))
    done
}

handle_error() {
    echo "Invalid input. Please enter a valid number."
    exit 2
}

ex() {
    echo -e "${WHITE}------THANK YOU FOR USING GPGKEYGEN------${RESET}"
}

listkeys() {
    echo -e "${GREEN}Which key would you like to use?${RESET}"
    while [ $keys2 -gt 0 ];
    do
        index=$(($keys+1-$keys2))
        echo -e "${CYAN} $index : "${key[keys2]}" ${RESET}"
        ((keys2--))
    done
}

commit() {
    inpc=$1
    gpg --armor --export $inpc
    echo -e "${WHITE}Add the key to your github account.${RESET}"
    echo -e "${WHITE}~go to your github account settings.${RESET}"
    echo -e "${WHITE}~in the access section, click ssh and gpg keys.${RESET}"
    echo -e "${WHITE}~Next to the "GPG keys" header, click New GPG key.${RESET}"
    echo -e "${WHITE}~fill the details as said.${RESET}"
    echo -e "${WHITE}~click add gpg key.${RESET}"
    echo
    echo -e "${GREEN}Do you wish to use this key: ${RESET}"
    echo -e "${RED}0. Exit.${RESET}"
    echo -e "${CYAN}1. Locally.${RESET}"
    echo -e "${CYAN}2. Globaly.${RESET}"
    read arg
    case $arg in
    0)
        echo "Exiting."
        exit 2
        ;;
    1|2)
        echo "You chose option $arg."
        ;;
    *)
        handle_error
        ;;
    esac
    if [ $arg -eq 1 ];
    then
        git config user.signingkey $inpc
    elif [ $arg -eq 2 ];
    then
        git config --global user.signingkey $inpc
    fi
}

work_key() {
    inp="$1"
    gpg --armor --export $inp
    echo -e "${GREEN}What do you want to do with this key?${RESET}"
    echo -e "${RED}0. Exit.${RESET}"
    echo -e "${CYAN}1. Use it for your commits.${RESET}"
    read work
    case $work in
    0)
        echo "Exiting."
        exit 2
        ;;
    1)
        echo "You chose option $work."
        ;;
    *)
        handle_error
        ;;
    esac
    if [ $work -eq 1 ];
    then
        commit $inp
    fi
}

del_key() {
    inpd=$1
    echo "$inpd"
    gpg --delete-secret-key $inpd
    gpg --delete-key $inpd
}

setupnewkey() {
    key_exists
        gpg --full-generate-key
        newkey = ${key[keys]}
        work_key ${newkey}
}

workwitholdkey() {
    listkeys
        read numkey
        existkey=${key[keys-numkey+1]}
        work_key ${existkey}
}

deleteoldkey() {
    listkeys
        read delkey
        exkey=${key[keys-delkey+1]}
        echo $exkey
        del_key ${exkey}
}