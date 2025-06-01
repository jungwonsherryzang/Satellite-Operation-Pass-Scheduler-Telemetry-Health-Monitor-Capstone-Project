# 🛰️ Satellite Pass Scheduler & Telemetry Health Monitor
A lightweight, real-world inspired satellite operations toolset that simulates a ground segment’s key responsibilities — from orbital pass prediction to real-time telemetry anomaly detection.

## 🚀 Overview
This project contains two core components:

## 📡 Satellite Pass Scheduler (pass_scheduler.py)
A Python script that pulls live TLE data, calculates visible satellite passes (e.g., ISS) over a given location (like Tokyo), and prints predicted pass windows.

## 🩺 Telemetry Health Monitor (telemetry_monitor.sh)
A Bash script that simulates real-time telemetry checks from a log file and raises alerts for out-of-threshold temperature or power readings.

## 🧠 Features
### ✅ Satellite Pass Scheduler
Fetches real-time TLE data from Celestrak(https://celestrak.org/)
Uses Skyfield to compute when a satellite will be visible from a target location
Works with any TLE-compatible object (e.g., ISS, STRiX, Sentinel)

### ✅ Telemetry Health Monitor
Parses latest telemetry entry from a live log file
Triggers warning alerts when temperature or power crosses thresholds
Easily schedulable via cron every 5 minutes

### 🔧 Requirements
For pass.py: pip install skyfield pytz
For telemetry_monitor.sh: A UNIX-like terminal with awk, grep, tail, bc (standard on most Linux/macOS)

### ✍️ How to Use
1. Run Satellite Pass Scheduler
python pass.py

Real Output(based on 06/01/2025)
📡 Satellite: ISS (ZARYA)
ISS (ZARYA)
CSS (TIANHE)
ISS (NAUKA)
FREGAT DEB
CSS (WENTIAN)

🛰️ Next Visible Passes over Tokyo:
Pass 1:
  Start (UTC): 2025-06-02 01:23:14.373810+00:00
  End   (UTC): 2025-06-02 01:19:11.561850+00:00
  Duration   : -4.0 minutes
----------------------------------------
Pass 2:
  Start (UTC): 2025-06-02 07:52:25.649686+00:00
  End   (UTC): 2025-06-02 07:52:00.514558+00:00
  Duration   : -0.4 minutes
----------------------------------------
Pass 3:
  Start (UTC): 2025-06-02 09:30:59.831528+00:00
  End   (UTC): 2025-06-02 09:27:10.362766+00:00
  Duration   : -3.8 minutes
----------------------------------------


2. Run Telemetry Health Monitor
chmod +x telemetry_monitor.sh
./telemetry_monitor.sh


3. Schedule via Cron
Add this to crontab to run every 5 mins:
*/5 * * * * /path/to/telemetry_monitor.sh

🙌 Author
Built by Jungwon Zang




