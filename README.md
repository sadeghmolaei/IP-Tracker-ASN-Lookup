# Iran IP List Script

This `README.md` provides an overview of the **Iran IP List Script**, including its functionality, installation, and usage.

---

## 📌 Overview
This script fetches **Iran-specific ASN numbers**, downloads **BGP route data**, filters out Iranian IPs, and **summarizes them in CIDR format**. It ensures that **only relevant and up-to-date IPs** are included.

### ✨ Features
- 🚀 **Fetches** latest ASN numbers for Iran from `bgp.he.net`.
- 📥 **Downloads** BGP route data from **RouteViews**.
- 🔍 **Filters** IPs belonging to major Iranian ISPs.
- 🗜 **Summarizes** IPs using `cidr_merge` from `netaddr`.
- 🔄 Supports **automatic updates** with a simple re-run.

---

## 📂 Project Structure
```
├── getip.sh          # Main Bash script
├── summarize.py      # Python script to merge IPs into CIDR
├── files/            # Folder where outputs are stored
└── README.md         # Documentation
```

---

## ⚙️ Prerequisites
Before running the script, ensure you have the following installed:

### 🔹 Linux/macOS Requirements
- 🛠 **Git** (`sudo apt install git` or `sudo yum install git`)
- 🐍 **Python 3** (`python3 --version`)
- 📦 **Pip & Netaddr library**
  ```bash
  sudo apt install python3-pip -y
  pip3 install netaddr
  ```
- 🌐 **Curl & Wget (for fetching ASN data)**
  ```bash
  sudo apt install curl wget -y
  ```

### 🔹 Windows Requirements
- Install **Git Bash** from [git-scm.com](https://git-scm.com/)
- Install **Python 3** from [python.org](https://www.python.org/)
- Install `netaddr`:
  ```bash
  pip install netaddr
  ```
- Use **Git Bash** or **WSL** for execution.

---

## 🚀 Installation & Usage
### 1️⃣ Clone the Repository
```bash
git clone https://github.com/YourUsername/iran-ip-list.git
cd iran-ip-list
```

### 2️⃣ Make the Script Executable
```bash
chmod +x getip.sh
```

### 3️⃣ Run the Script
```bash
./getip.sh
```

### 4️⃣ Output Files
After execution, the **final output** will be saved in the `files/` directory:
- 📜 **Full List:** `files/final-iran-ip-<timestamp>`
- 📋 **Summarized CIDR List:** `files/final-summarized-iran-ip-<timestamp>`

---

## 🛠 Script Details
### 🔹 `getip.sh` (Bash Script)
- 🧹 Cleans old files.
- 🌍 Fetches **Iran-specific AS numbers**.
- 📥 Downloads **latest BGP data** from RouteViews.
- 🕵️ Filters **Iranian ISP IPs**.
- 🗜 Calls **Python script** to summarize IPs.
- 📂 Stores **output in `files/` directory**.

### 🔹 `summarize.py` (Python Script)
Merges IP ranges using **`cidr_merge`** from `netaddr` to optimize IP blocks.
```python
import sys
from netaddr import cidr_merge

def summarize_ips(ip_file):
    try:
        with open(ip_file, 'r') as fh:
            iplist = [line.strip() for line in fh if line.strip()]

        if not iplist:
            print("[ERROR] The file is empty or contains no valid IPs!")
            return

        summarized_ips = cidr_merge(iplist)
        print("
".join(map(str, summarized_ips)))

    except FileNotFoundError:
        print(f"[ERROR] File '{ip_file}' not found!")
    except Exception as e:
        print(f"[ERROR] An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("[USAGE] python3 summarize.py <input_file>")
    else:
        summarize_ips(sys.argv[1])
```

---

## ⏳ Automating with Cronjob
To automatically update the IP list **every 24 hours**, add this to `crontab -e`:
```bash
0 2 * * * /path/to/getip.sh > /dev/null 2>&1
```

---

## 🤝 Contribution
We welcome contributions! If you want to improve the script:
1. **Fork the repository** on GitHub.
2. **Make changes & commit**:
   ```bash
   git add .
   git commit -m "Improved error handling"
   git push origin main
   ```
3. **Submit a Pull Request (PR).**

---

## 📜 License
This project is **open-source** under the **GNU General Public License v3.0**.

---

## 🌟 Support & Issues
If you encounter any issues, feel free to **open an issue** on GitHub or contribute to improving the script.

---
**Now you're all set! 🚀 Happy IP filtering!**
