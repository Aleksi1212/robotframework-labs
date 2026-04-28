from robot.api.deco import keyword, library
import serial, os

@library 
class Serial():
    ''' Library for interacting with Serial port
    '''
    # ROBOT_LIBRARY_SCOPE = 'SUITE'
    # ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    

    def __init__(self):
        port = os.environ.get("ATCMD_PORT")
        if port is None:
            raise AssertionError("ATMCD_PORT not found")
        self._port = serial.Serial(port, 115200, timeout = 600)
        
        
    @keyword
    def send_command(self, text):
        self._port.reset_input_buffer()
        self._port.write(bytes(text + '\n', 'iso-8859-1'))

    @keyword
    def read_command(self):
        return self._port.readline().strip().decode('iso-8859-1')


    @keyword
    def response_should_be(self, expected_text):
        text = self._port.readline().strip().decode('iso-8859-1')
        if text != expected_text:
            raise AssertionError('Expected: ' + expected_text + ' got: ' + text)
            

    @keyword
    def ignore_response(self):
        self._port.readline()

# s = Serial()
# s.send_command("ATE0")
# s.response_should_be("OK")
# s.ignore_response()
# s.send_command("AT+SEND=\"test\"")
# print(s.read_command())
