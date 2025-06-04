#!/bin/bash

LOG_FILE="telemetry_log.txt" 
ALERT_LOG="alerts.log"
TEMP_THRESHOLD=55 #set alert above 55
POWER_THRESHOLD=95 #set alert less than 95%

#checking log is existing or not
if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Error: $LOG_FILE not found."
    exit 1
fi

#check TLE is the latest or not
latest=$(tail -n 1 "$LOG_FILE")

#
timestamp=$(echo "$latest" | awk '{print $1}')
temp=$(echo "$latest" | grep -oP 'TEMP=\K[0-9]+')
power=$(echo "$latest" | grep -oP 'POWER=\K[0-9]+')


#alerting
warning=0
message="[$(date -u)]  ✅ Telemetry OK: $latest"

#temperature checking
if [ "$temp" -gt "$TEMP_THRESHOLD" ]; then
    warning=1
    message="[$(date -u)] 🚨 TEMP WARNING ($temp°C) — $latest"
fi

#power checking
if [ "$power" -lt "$TEMP_THRESHOLD" ]; then
    warning=1
    message="[$(date -u)] ⚡ POWER WARNING ($power%) — $latest"
fi

#message output
echo "$message"

#saving to alerts.log
if [ "$warning" -eq 1 ]; then
    echo "$message" >> "$ALERT_LOG"
fi