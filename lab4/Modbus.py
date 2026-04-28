import minimalmodbus
from robot.api.deco import keyword, library


def get_valid_register_range(registers: list[int], register: int) -> int:
    register_index = registers.index(register)
    return len(registers[register_index::])

@library
class Modbus():
    ''' Library for interacting with Modbus
    '''
    #ROBOT_LIBRARY_SCOPE = 'SUITE'
    #ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.mb = minimalmodbus.Instrument("/dev/ttyACM0", 17, mode=minimalmodbus.MODE_ASCII)


    @keyword
    def write_to_register(self, register, value, code): 
        try:
            self.mb.write_register(int(register), int(value), functioncode=int(code))
            return True
        except:
            return False
        # if int(code) not in params.WRITE_FUNCTION_CODES:
        #     # raise AssertionError(f"Invalid function code: {code}")
        #     return False
        # if int(register) not in params.HOLDING_REGISTERS:
        #     return False
        #     # raise AssertionError(f"Invalid register: {register}")
        
        # return True

    @keyword
    def read_from_register(self, register, range, code):
        try:
            return True, self.mb.read_registers(int(register), int(range), int(code))
        except:
            return False, 0
        # if int(code) not in params.READ_FUNCTION_CODES:
        #     return False, 0
        #     # raise AssertionError(f"Invalid function code: {int(code)}")
        
        # if int(code) == 3 and int(register) in params.HOLDING_REGISTERS:
        #     valid_range = get_valid_register_range(params.HOLDING_REGISTERS, int(register))
        #     if valid_range < int(range):
        #         return False, 0
        #         # raise AssertionError("Out of range")
        # elif int(code) == 4 and int(register) in params.INPUT_REGISTERS:
        #     valid_range = get_valid_register_range(params.INPUT_REGISTERS, int(register))
        #     if valid_range < int(range):
        #         return False, 0
        #         # raise AssertionError("Out of range")
        # else:
        #     return False, 0
        #     # raise AssertionError(f"Invalid function code: {int(code)}, for register: {register}")
        
        # return True, self.mb.read_registers(int(register), int(range), int(code))
    