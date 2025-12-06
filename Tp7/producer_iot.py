from kafka import KafkaProducer
import json
import time
import random

producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

while True:
    data = {
        "machine_id": 1,
        "temperature": round(random.uniform(40, 90), 2),
        "vibration": round(random.uniform(0.1, 1.5), 2),
        "status": "ON",
        "alert": "PANNE" if random.random() < 0.1 else "OK"
    }
    
    producer.send("chantier_machines", data)
    print("Envoyé :", data)
    time.sleep(2)
