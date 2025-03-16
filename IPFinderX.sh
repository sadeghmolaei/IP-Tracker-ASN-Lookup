#!/bin/bash
#############################
####### Dynamic IP Fetching Script (with Company Name Support)
####### Optimized & Interactive
####### GNU V3 License
#############################

# Define directories and files
SCRIPTFOLDER="$(pwd)"
FOLDER="$SCRIPTFOLDER/files"
NOW="$(date +'%s')"

# Use mktemp for temporary files
ASFILE=$(mktemp /tmp/asn-list.XXXXXX)
IPFILE="$FOLDER/final-ip-$NOW"
SUMIPFILE="$FOLDER/final-summarized-ip-$NOW"

# Create the folder if it doesn't exist
mkdir -p "$FOLDER"

# Ask user for country code, ASN, or Company Name
read -p "Enter Country Code (e.g., IR), ASN (e.g., AS12880), or Company Name (e.g., Facebook): " USER_INPUT

# Detect input type (Country Code, ASN, or Company Name)
if [[ $USER_INPUT =~ ^[A-Z]{2}$ ]]; then
    echo "[INFO] Fetching ASNs for country: $USER_INPUT"
    ASN_LIST=$(curl -s -L --user-agent "Mozilla/4.0" "http://bgp.he.net/country/$USER_INPUT" | grep AS[1-9] | cut -d/ -f2 | awk -F\" '{print $1}' | tr -d 'AS')

elif [[ $USER_INPUT =~ ^AS[0-9]+$ ]]; then
    echo "[INFO] Fetching ASN: ${USER_INPUT:2}"
    ASN_LIST=${USER_INPUT:2}

else
    echo "[INFO] Searching for ASN related to company: $USER_INPUT"
    ASN_LIST=$(curl -s -L --user-agent "Mozilla/4.0" "http://bgp.he.net/search?search%5Bsearch%5D=$USER_INPUT" | grep -oP 'AS[0-9]+' | tr -d 'AS' | sort -u)

    if [ -z "$ASN_LIST" ]; then
        echo "[ERROR] No ASNs found for company: $USER_INPUT"
        exit 1
    fi
fi

# Check if ASN list is valid
if [ -z "$ASN_LIST" ]; then
    echo "[ERROR] No ASNs found for the given input!"
    exit 1
fi

# Store ASN numbers
echo "$ASN_LIST" | while read -r line; do
    echo "$line" >> "$ASFILE"
done

# Download BGP data
echo "[INFO] Downloading BGP data..."
wget -q --show-progress -O "$FOLDER/oix-full-snapshot-latest.dat.bz2" http://archive.routeviews.org/oix-route-views/oix-full-snapshot-latest.dat.bz2

# Check if download was successful
if [ ! -f "$FOLDER/oix-full-snapshot-latest.dat.bz2" ]; then
    echo "[ERROR] Failed to download BGP data!"
    exit 1
fi

# Extract the downloaded file
bzip2 -df "$FOLDER/oix-full-snapshot-latest.dat.bz2"

# Check if extraction was successful
if [ ! -f "$FOLDER/oix-full-snapshot-latest.dat" ]; then
    echo "[ERROR] Failed to extract BGP data!"
    exit 1
fi

# Process and extract IPs related to the user input
echo "[INFO] Processing and extracting IPs..."
egrep -f "$ASFILE" "$FOLDER/oix-full-snapshot-latest.dat" | awk '{print $2}' | sort -u > "$IPFILE"

# Check if IP extraction was successful
if [ ! -s "$IPFILE" ]; then
    echo "[ERROR] No IPs found!"
    exit 1
fi

# Summarize IP ranges using Python3
echo "[INFO] Summarizing IP ranges..."
if [ -f "$SCRIPTFOLDER/summarize.py" ]; then
    python3 "$SCRIPTFOLDER/summarize.py" "$IPFILE" > "$SUMIPFILE"
else
    echo "[WARNING] summarize.py not found! Skipping summarization."
    cp "$IPFILE" "$SUMIPFILE"
fi

# Remove temporary files
rm -f "$ASFILE"

# Final message
echo "[SUCCESS] IP files for $USER_INPUT are ready!"
echo "➜ Complete IPs: $IPFILE"
echo "➜ Summarized IPs: $SUMIPFILE"
