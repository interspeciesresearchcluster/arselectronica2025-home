import socket
import threading

#host = 'multispeciesresearchcluster.freeddns.org'
#host = '192.168.2.211'
#host = '79.215.220.170'
host = ''

port = 9999


def handle_client(client_socket, client_address):
    print(f'Connected to {client_address}')
    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break
            print(f'Received from {client_address}: {data.decode()}')
            response = 'Message received successfully'.encode()
            client_socket.send(response)
    finally:
        client_socket.close()


# Create a TCP socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
try:
    server_socket.bind((host, port))
    server_socket.listen(5)
    print(f'Server is listening on port {port}...')
except socket.error as e:
    print(f'Error: {e}')

while True:
    client_socket, client_address = server_socket.accept()
    client_thread = threading.Thread(target=handle_client, args=(client_socket, client_address))
    client_thread.start()
