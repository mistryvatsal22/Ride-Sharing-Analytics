import os
import json
import time
import pandas as pd
from kafka import KafkaProducer

# ==========================================================
# Kafka Configuration
# ==========================================================

TOPIC = "ride_analytics"
BOOTSTRAP_SERVER = "localhost:9092"

producer = KafkaProducer(
    bootstrap_servers=BOOTSTRAP_SERVER,
    value_serializer=lambda x: json.dumps(x).encode("utf-8")
)

# ==========================================================
# Read Dataset
# ==========================================================

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

csv_path = os.path.join(BASE_DIR, "data", "ride_analytics.csv")

df = pd.read_csv(csv_path)

STREAM_DELAY = 0.05

print("=" * 70)
print("        Ride Sharing Analytics - Kafka Producer")
print("=" * 70)

print(f"Kafka Topic      : {TOPIC}")
print(f"Bootstrap Server : {BOOTSTRAP_SERVER}")
print(f"Total Records    : {len(df)}")
print()

# ==========================================================
# Stream Data
# ==========================================================

for index, row in df.iterrows():

 record = row.to_dict()

    producer.send(TOPIC, value=record)

    print(f"[{index+1}/{len(df)}] Booking ID : {record['booking_id']} sent")

    time.sleep(STREAM_DELAY)

producer.flush()

print()
print("=" * 70)
print("All ride records successfully published to Kafka.")
print("=" * 70)
