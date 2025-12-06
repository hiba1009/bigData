from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(
    'chantier_machines',
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda v: json.loads(v.decode('utf-8'))
)

for msg in consumer:
    data = msg.value
    print("Réception :", msg.value)
