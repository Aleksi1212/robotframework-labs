import serial

class SerialComm:
    def __init__(self):
        self._port = serial.Serial('/dev/ttyACM0', 115200, timeout = 5)

    def write(self, text):
        self._port.reset_input_buffer()
        self._port.write(bytes(text + '\n', 'iso-8859-1'))

    def read(self):
        text = self._port.readline().strip().decode('iso-8859-1')
        print(text + '\n')

if __name__ == "__main__":
    serial_comm = SerialComm()
    while True:
        cmd = input("")
        serial_comm.write(cmd)
        serial_comm.read()