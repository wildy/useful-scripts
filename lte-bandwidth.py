#!/usr/bin/python3
import math

#rssi = -78
#rsrp = -105
#rsrq = -9

print ('LTE Bandwidth Calc')
print ('==================\n')

rssi = float(input("RSSI? "))
rsrp = float(input("RSRP? "))
rsrq = float(input("RSRQ? "))

print (f"RSSI: {rssi}\nRSRP: {rsrp}\nRSRQ: {rsrq}\n")

bandwidth = math.floor (math.pow (10, ((rssi - rsrp + rsrq) / 10)) * 0.2 )
print (f"Predicted bandwidth is: {bandwidth} Mbps")
