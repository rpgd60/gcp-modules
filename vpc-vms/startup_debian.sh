#! /bin/bash
echo "Hola - Debian" > /tmp/hola.txt
## to prevent apt-get stuck:  process trigger on man-db
rm /var/lib/man-db/auto-update 
apt-get update
apt-get install -y dnsutils  
apt-get install -y nginx-light
apt-get -y install nfs-common
apt-get -y install stress-ng
apt-get -y install python3-pip
pip3 install flask
# apt-get install -y net-tools  (in path using sudo)
cat <<EOF > /var/www/html/index.html
<html><body><p>welcome to $(hostname).</p></body></html>
EOF
mkdir -p /home/app
cat <<EOAPP > /home/app/app.py
from flask import Flask, request
import subprocess
import threading

app = Flask(__name__)

def run_stress(duration, command):
    subprocess.Popen(command)


app = Flask(__name__)

@app.route('/myip')
def return_my_ip():
    return f'Your IPv4 address is: {request.remote_addr}\n'

@app.route('/help')
def help_me():
    return '''
Help: Contact server on port ${application_port} with paths:
    /myip -- will return the client (your) IP address
    /cpu/<minutes>  -- will run stress-ng for cpu
    /memory/<minutes> -- will run stress-ng for memory
    /help -- this info
'''

@app.route('/cpu/<int:duration>')
def stress_cpu(duration):
    threading.Thread(target=run_stress, args=(duration, ['stress-ng', '--cpu', '2', '--cpu-load', '80', '--timeout', str(duration)+'m'])).start()
    return f'Stressing CPU for {duration} minutes\n'

@app.route('/memory/<int:duration>')
def stress_memory(duration):
    threading.Thread(target=run_stress, args=(duration, ['stress-ng', '--vm', '1', '--vm-bytes', '256M', '--timeout', str(duration)+'m'])).start()
    return f'Stressing memory for {duration} minutes\n'

if __name__ == '__main__':
    app.run(host = "0.0.0.0", port=${application_port})
EOAPP
python3 /home/app/app.py &

