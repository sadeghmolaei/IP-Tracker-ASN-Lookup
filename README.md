# Iran IP List & IPFinderX

This `README.md` provides an overview of two powerful IP tracking scripts:
1. **Iran IP List Script (`getip.sh`)** - Focuses on fetching Iranian IPs based on country code or ASN.
2. **IPFinderX (`ipfinderx.sh`)** - An advanced version that allows users to fetch IPs based on country, ASN, or even company names (e.g., YouTube, Facebook, Telegram).

---

## 📌 Overview
### **Iran IP List (`getip.sh`)**
- Fetches **ASN numbers** for Iran.
- Downloads **BGP route data**.
- Filters **Iranian ISP-related IPs**.
- Summarizes them using `cidr_merge`.
- Supports **automatic updates**.

### **IPFinderX (`ipfinderx.sh`)**
- Fetches **ASN numbers for any country**.
- Allows **searching for ASN based on company name** (e.g., Google, YouTube, Facebook).
- Extracts **IP ranges for a specific ASN or country**.
- Summarizes IPs using `cidr_merge`.
- Fully automated with **interactive user input**.

---

## ⚙️ Prerequisites
Before running the scripts, ensure you have the following installed:

### 🔹 Linux/macOS Requirements
- **Git** (`sudo apt install git` or `sudo yum install git`)
- **Python 3** (`python3 --version`)
- **Pip & Netaddr library**
  ```bash
  sudo apt install python3-pip -y
  pip3 install netaddr
  ```
- **Curl & Wget (for fetching ASN data)**
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
git clone https://github.com/sadeghmolaei/IP-Tracker-ASN-Lookup.git
cd ipfinderx
```

### 2️⃣ Make the Scripts Executable
```bash
chmod +x getip.sh
chmod +x ipfinderx.sh
```

### 3️⃣ Run the Iran IP List Script
```bash
./getip.sh
```

### 4️⃣ Run the IPFinderX Script (New Version)
```bash
./ipfinderx.sh
```
When prompted, enter one of the following:
- **Country Code** (e.g., `US`, `IR`, `DE`)
- **ASN Number** (e.g., `AS12880`)
- **Company Name** (e.g., `Google`, `Facebook`, `Telegram`)

The script will process and extract the relevant IP ranges.

### 5️⃣ Output Files
After execution, the **final output** will be saved in the `files/` directory:
- **Full List:** `files/final-ip-<timestamp>`
- **Summarized CIDR List:** `files/final-summarized-ip-<timestamp>`

---

## 🛠 Script Details
### 🔹 `getip.sh` (Iran IP List Script)
- Fetches **Iran-specific ASNs**.
- Downloads **latest BGP data**.
- Extracts **IP addresses related to Iran**.
- Summarizes IPs using Python.

### 🔹 `ipfinderx.sh` (Advanced IP Lookup Script)
- 🏴 **Supports country-based lookups** (e.g., `IR` for Iran, `US` for the USA).
- 🔍 **Supports ASN-based lookups** (e.g., `AS12880`).
- 🏢 **Supports company-based lookups** (e.g., `Google`, `Facebook`, `YouTube`).
- 🧠 **Intelligent detection**: Recognizes if the user input is a country, ASN, or company name.
- 📡 **Fetches and processes IPs dynamically**.
- 🚀 **Optimized for speed & accuracy**.

---

## ⏳ Automating with Cronjob
To automatically update the IP list **every 24 hours**, add this to `crontab -e`:
```bash
0 2 * * * /path/to/ipfinderx.sh > /dev/null 2>&1
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
