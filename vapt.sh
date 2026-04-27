#!/bin/bash

read -p "Enter experiment number: " EXP

print_cmd() {
    echo "$(whoami)@$(hostname):~$ $*"
    eval "$*"
    echo ""
}

# -------- EXPERIMENT 2 --------
if [ "$EXP" = "2" ]; then
    read -p "Enter domain (default: example.com): " INPUT
    INPUT=${INPUT:-example.com}

    DOMAIN=$(echo "$INPUT" | sed -E 's~https?://~~' | cut -d/ -f1)

    print_cmd whois "$DOMAIN"
    print_cmd nslookup "$DOMAIN"
    print_cmd dig "$DOMAIN"
    print_cmd dig MX "$DOMAIN"
    print_cmd dig NS "$DOMAIN"
    print_cmd theHarvester -d "$DOMAIN" -b google,yahoo
fi

# -------- EXPERIMENT 3 --------
if [ "$EXP" = "3" ]; then
    cat << EOF

Google Dorking Commands:

site:testphp.vulnweb.com
site:ves.ac.in ext:doc
site:example.com ext:sql
site:example.com inurl:admin

More commands:
intitle: Search text in page title
inurl: Search text in URL
filetype: Search specific file types
cache: View cached version of a site
ext: File extension search

Google Hacking Database (Exploit-DB):
https://www.exploit-db.com/google-hacking-database
EOF
fi

# -------- EXPERIMENT 4 --------
if [ "$EXP" = "4" ]; then

    if [ "$EUID" -ne 0 ]; then
        sudo "$0"
        exit
    fi

    read -p "Enter domain (default: example.com): " INPUT
    INPUT=${INPUT:-example.com}

    DOMAIN=$(echo "$INPUT" | sed -E 's~https?://~~' | cut -d/ -f1)
    HTTP_URL="http://$DOMAIN"

    TARGET_IP=$(getent hosts "$DOMAIN" | awk '{ print $1 }')

    for cmd in ping nmap nc telnet whatweb nikto timeout getent awk; do
        command -v "$cmd" >/dev/null 2>&1 || exit 1
    done

    print_cmd ping -c 4 "$DOMAIN"
    print_cmd nmap -sn "$DOMAIN"
    print_cmd nmap -sT "$DOMAIN"
    print_cmd nmap -sS "$DOMAIN"
    print_cmd nmap -sU "$DOMAIN"
    print_cmd nmap -sV "$DOMAIN"
    print_cmd nmap -O "$DOMAIN"

    print_cmd nc -vz "$DOMAIN" 80
    print_cmd timeout 5 telnet "$TARGET_IP" 21

    print_cmd whatweb "$HTTP_URL"
    print_cmd nikto -h "$HTTP_URL"
fi

# -------- EXPERIMENT 7 --------
if [ "$EXP" = "7" ]; then

    if ! command -v crunch >/dev/null 2>&1; then
        print_cmd sudo apt install -y crunch
    fi

    print_cmd crunch 2 4 -o wordlist_1.txt
    print_cmd crunch 2 4 -o wordlist_2.txt -t ABC123
    print_cmd crunch 1 3 -o wordlist_3.txt -b 3mb

    echo "run this command to display file: cat wordlist_1.txt"
fi

# -------- EXPERIMENT 10 --------
if [ "$EXP" = "10" ]; then

    cat << 'EOF'
... (your python content unchanged) ...
EOF

fi

# -------- DEFAULT (INVALID EXP) --------
if [ "$EXP" != "2" ] && [ "$EXP" != "3" ] && [ "$EXP" != "4" ] && [ "$EXP" != "7" ] && [ "$EXP" != "10" ]; then
    echo "Invalid experiment number."
    echo "Available experiments:"
    echo "2 - DNS & OSINT tools - whois, etc."
    echo "3 - Google Dorking"
    echo "4 - Network scanning - nmap, etc."
    echo "7 - Wordlist generation (crunch)"
    echo "10 - Keyboard listener demo - python"
fi
