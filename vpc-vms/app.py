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
Help: Contact server on port 
    /myip -- will return the client (your) IP address
    /cpu/<minutes>  -- will run stress-ng for cpu
    /memory/<minutes> -- will run stress-ng for memory
'''

@app.route('/cpu/<int:duration>')
def stress_cpu(duration):
    threading.Thread(target=run_stress, args=(duration, ['stress-ng', '--cpu', '1', '--timeout', str(duration)+'m'])).start()
    return f'Stressing CPU for {duration} minutes\n'

@app.route('/memory/<int:duration>')
def stress_memory(duration):
    threading.Thread(target=run_stress, args=(duration, ['stress-ng', '--vm', '1', '--vm-bytes', '256M', '--timeout', str(duration)+'m'])).start()
    return f'Stressing memory for {duration} minutes\n'

if __name__ == '__main__':
    app.run(port=4004)


