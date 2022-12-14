import os
import random
import string
import time
from azure.servicebus import ServiceBusClient, ServiceBusMessage
from prometheus_client import start_http_server, Counter

CONNECTION_STR = os.getenv('CONNECTION_STR')
QUEUE_NAME = os.getenv('QUEUE_NAME')

start_http_server(8000)
produced_messages_counter = Counter('produced_messages', 'Produced Messages')

def send_message(sender, content):
    message = ServiceBusMessage(content)
    sender.send_messages(message)
    print("Sent Order ID: " + content)

servicebus_client = ServiceBusClient.from_connection_string(conn_str=CONNECTION_STR, logging_enable=True)

with servicebus_client:
    sender = servicebus_client.get_queue_sender(queue_name=QUEUE_NAME)
    with sender:
        chars = string.digits
        while (True):
            content = ''.join(random.choice(chars) for i in range(10))
            send_message(sender, content)
            time.sleep(0.1)
            produced_messages_counter.inc()