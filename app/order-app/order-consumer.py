import os
import time
from azure.servicebus import ServiceBusClient
from prometheus_client import start_http_server, Counter

CONNECTION_STR = os.getenv('CONNECTION_STR')
QUEUE_NAME = os.getenv('QUEUE_NAME')

start_http_server(8000)
received_messages_counter = Counter('received_messages', 'Received Messages')

servicebus_client = ServiceBusClient.from_connection_string(conn_str=CONNECTION_STR, logging_enable=True)

with servicebus_client:
    receiver = servicebus_client.get_queue_receiver(queue_name=QUEUE_NAME)
    with receiver:
        for msg in receiver:
            print("Order ID Received: " + str(msg))
            time.sleep(0.1)
            receiver.complete_message(msg)
            received_messages_counter.inc()