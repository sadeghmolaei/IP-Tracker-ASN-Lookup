import sys
from netaddr import cidr_merge

def summarize_ips(ip_file):
    try:
        # Read the list of IPs
        with open(ip_file, 'r') as fh:
            iplist = [line.strip() for line in fh if line.strip()]  # Remove empty lines

        if not iplist:
            print("[ERROR] The file is empty or contains no valid IPs!")
            return

        # Merge consecutive IP ranges
        summarized_ips = cidr_merge(iplist)

        # Print the output
        print("\n".join(map(str, summarized_ips)))

    except FileNotFoundError:
        print(f"[ERROR] File '{ip_file}' not found!")
    except Exception as e:
        print(f"[ERROR] An error occurred: {e}")

if __name__ == "__main__":
    # Check if input file is provided
    if len(sys.argv) < 2:
        print("[USAGE] python summarize.py <input_file>")
    else:
        summarize_ips(sys.argv[1])

