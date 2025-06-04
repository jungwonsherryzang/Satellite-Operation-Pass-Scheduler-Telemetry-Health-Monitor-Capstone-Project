#!/bin/bash

# === CONFIG ===
TLE_URL="https://celestrak.org/NORAD/elements/stations.txt"
LOG_FILE="tle_status.log"
THRESHOLD_HOURS=24

# === Download the latest TLE (first 3 lines are for ISS) ===
tle_data=$(curl -s "$TLE_URL" | head -n 3)

# === Extract Epoch (YYDDD.DDDDDDDD) ===
epoch=$(echo "$tle_data" | sed -n '3p' | awk '{print $3}')
year="20$(echo $epoch | cut -c1-2)"
doy=$(echo $epoch | cut -c3-5)
fractional_day="0.$(echo $epoch | cut -d. -f2)"

# === Convert Epoch to datetime ===
epoch_date=$(date -ud "$year-01-01 +$((10#$doy - 1)) days ${fractional_day} days" +"%Y-%m-%d %H:%M:%S")
epoch_unix=$(date -ud "$epoch_date" +%s)
now_unix=$(date -u +%s)
age_hours=$(( (now_unix - epoch_unix) / 3600 ))

# === Check freshness ===
echo "[$(date -u)] Epoch: $epoch_date (Age: ${age_hours}h)" >> "$LOG_FILE"

if [[ $age_hours -gt $THRESHOLD_HOURS ]]; then
  echo "⚠️ WARNING: TLE is stale (>$THRESHOLD_HOURS hours old)" | tee -a "$LOG_FILE"
else
  echo "✅ TLE is fresh" | tee -a "$LOG_FILE"
fi