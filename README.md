# Rogue DHCP Detector

A lightweight PowerShell script that detects **rogue DHCP servers** on your network using `tshark` (from Wireshark).  
It continuously monitors DHCP **OFFER** and **ACK** packets and alerts when the responding server is not in your list of trusted DHCP servers.

---

## Features
- Detects unauthorized DHCP servers in real time  
- Logs suspicious activity to a file  
- Highlights rogue servers in red, trusted ones in green  
- Easy to configure with your own trusted DHCP server IPs  

---

## Requirements
- **Windows** with PowerShell  
- [Wireshark](https://www.wireshark.org/#download) (for `tshark.exe`)  
- Administrative privileges (required to capture network traffic)  

---

## Configuration
At the top of the script you can configure:
- Authorized DHCP servers
- LOG file path
- tshark path
- Interface number (you can find it with tshark.exe -D)
