from skyfield.api import load, Topos, utc
from datetime import datetime, timedelta, timezone

#Loading real-time TLE data
TLE_URL = "https://celestrak.org/NORAD/elements/stations.txt" #few big satellites
LOCATION = Topos("35.6895 N", "139.6917 E")
MIN_ALTITUDE_DEG = 20  # degrees
NUM_PASSES = 3
#WINDOW_HOURS = 12  # Search next 12 hours
DAYS_HOURS = 2 #expanded time window

def main():
    #loading timescale and TLE data
    ts = load.timescale()

    try:
        sats = load.tle_file(TLE_URL)
    except Exception as e:
        print(f"❌ Error loading TLE: {e}")
        return

    satellite = sats[0]
    print(f"📡 Satellite: {satellite.name}")

    #defining time window
    #now = datetime.utcnow() -> deprecated
    now = datetime.now(timezone.utc)
    t0 = ts.utc(now)
    t1 = ts.utc(now + timedelta(days=DAYS_HOURS))

    #finding pass events over TOKYO
    times, events = satellite.find_events(LOCATION, t0, t1, altitude_degrees=MIN_ALTITUDE_DEG)

    #collecting rise/set pairs
    pass_list = []
    curr_pass = {}

    #check first 5 satellites
    for sat in sats[:5]:
        print(sat.name)

    #check rise and set for pass
    for t, e in zip(times, events):
        #Rise
        if e == 0:
            curr_pass["end"] = t.utc_datetime()
        #Set
        elif e == 2: 
            curr_pass["start"] = t.utc_datetime()

            if "start" in curr_pass:
                duration = (curr_pass["end"] - curr_pass["start"]).total_seconds() / 60
                curr_pass["duration_min"] = round(duration, 1)
                pass_list.append(curr_pass)
            curr_pass = {}


        if len(pass_list) >= NUM_PASSES:
            break


    #displaying
    print("\n🛰️ Next Visible Passes over Tokyo:")

    for idx, p in enumerate(pass_list):
        print(f"Pass {idx+1}:")
        print(f"  Start (UTC): {p['start']}")
        print(f"  End   (UTC): {p['end']}")
        print(f"  Duration   : {p['duration_min']} minutes")
        print("-" * 40)


#execute
if __name__ == "__main__":
    main()
    
