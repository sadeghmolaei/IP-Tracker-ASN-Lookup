#!/bin/bash
#############################
####### Iran IP List
####### Updated Version
####### Optimized & Secure
####### GNU V3 License
#############################

# Define directories and files
SCRIPTFOLDER="$(pwd)"
FOLDER="$SCRIPTFOLDER/files"
NOW="$(date +'%s')"

# Use mktemp for temporary files
ASFILE_I=$(mktemp /tmp/iran-as-i.XXXXXX)
ASFILE_E=$(mktemp /tmp/iran-as-e.XXXXXX)
ASFILE_U=$(mktemp /tmp/iran-as-u.XXXXXX)
IPFILE="$FOLDER/final-iran-ip-$NOW"
SUMIPFILE="$FOLDER/final-summarized-iran-ip-$NOW"

# Create the folder if it doesn't exist
mkdir -p "$FOLDER"

echo "[INFO] Cleaning old files..."
rm -f "$FOLDER/oix-full-snapshot-latest.dat" "$FOLDER/oix-full-snapshot-latest.dat.bz2"

# Fetch Iran ASN list from bgp.he.net
echo "[INFO] Fetching Iran AS list..."
ASN_LIST=$(curl -s -L --user-agent "Mozilla/4.0" http://bgp.he.net/country/IR | grep AS[1-9] | cut -d/ -f2 | awk -F\" '{print $1}' | tr -d 'AS')

# Check if download was successful
if [ -z "$ASN_LIST" ]; then
    echo "[ERROR] Failed to fetch AS list!"
    exit 1
fi

# Store ASN in respective files
echo "$ASN_LIST" | while read -r line; do
    echo "$line i" >> "$ASFILE_I"
    echo "$line e" >> "$ASFILE_E"
    echo "$line ?" >> "$ASFILE_U"
done

# Download BGP data from RouteViews
echo "[INFO] Downloading BGP data..."
wget -q --show-progress -O "$FOLDER/oix-full-snapshot-latest.dat.bz2" http://archive.routeviews.org/oix-route-views/oix-full-snapshot-latest.dat.bz2

# Check if download was successful
if [ ! -f "$FOLDER/oix-full-snapshot-latest.dat.bz2" ]; then
    echo "[ERROR] Failed to download BGP data!"
    exit 1
fi

# Extract the downloaded file
echo "[INFO] Extracting BGP data..."
bzip2 -df "$FOLDER/oix-full-snapshot-latest.dat.bz2"

# Check if extraction was successful
if [ ! -f "$FOLDER/oix-full-snapshot-latest.dat" ]; then
    echo "[ERROR] Failed to extract BGP data!"
    exit 1
fi

# Process and extract IPs related to Iran
echo "[INFO] Processing and extracting IPs..."
egrep -f "$ASFILE_I" -f "$ASFILE_E" -f "$ASFILE_U" "$FOLDER/oix-full-snapshot-latest.dat" | \
    egrep " (48159|12880|6736)" | \
    sed "s/ \([0-9]\+\) \1/ \1/g" | \
    awk '{print $2}' | \
    sort -u > "$IPFILE"

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
rm -f "$ASFILE_I" "$ASFILE_E" "$ASFILE_U"

# Final message
echo "[SUCCESS] Iran IP files are ready!"
echo "➜ Complete IPs: $IPFILE"
echo "➜ Summarized IPs: $SUMIPFILE"

