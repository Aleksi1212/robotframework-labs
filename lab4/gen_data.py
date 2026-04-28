import csv, params, random, Modbus

MODES = ["READ", "WRITE"]

FIELD_NAMES = ["*** Test Cases ***", "${id}", "${mode}", "${register}", "${code}", "${value}", "${range}", "${success}", "[Tags]"]

def gen_fail_data():
    data = []
    for i in range(64):
        mode = random.choice(MODES)
        if mode == "READ":
            register = 0
            code = 0
            reg_range = 0

            if i >= 0 and i <= 16:
                register = 100
                code = random.choice(params.READ_FUNCTION_CODES)
            elif i > 16 and i <= 32:
                code =random.choice(params.WRITE_FUNCTION_CODES)
            else:
                from_reg = random.randint(0, 1)
                chosen_registry = params.INPUT_REGISTERS if from_reg == 0 else params.HOLDING_REGISTERS

                register = random.choice(chosen_registry)
                code = 4 if from_reg == 0 else 3
                reg_range = 100

            data.append({
                "${id}": i,
                "${mode}": mode,
                "${register}": register,
                "${code}": code,
                "${value}": 0,
                "${range}": reg_range,
                "${success}": False,
                "[Tags]": mode
            })
        else:
            register = random.choice(params.INPUT_REGISTERS) if i % 2 == 0 else random.choice(params.HOLDING_REGISTERS)
            code = random.choice(params.WRITE_FUNCTION_CODES) if i % 2 == 0 else 1
            data.append({
                "${id}": i,
                "${mode}": mode,
                "${register}": register,
                "${code}": code,
                "${value}": random.randint(0, 2048),
                "${range}": 0,
                "${success}": False,
                "[Tags]": mode
            })

    return data

def gen_success_data():
    data = []
    for i in range(63, 128):
        mode = random.choice(MODES)
        if mode == "READ":
            from_reg = random.randint(0, 1)
            chosen_registry = params.INPUT_REGISTERS if from_reg == 0 else params.HOLDING_REGISTERS

            code = 4 if from_reg == 0 else 3
            register = random.choice(chosen_registry)
            reg_range = Modbus.get_valid_register_range(chosen_registry, register)

            data.append({
                "${id}": i,
                "${mode}": mode,
                "${register}": register,
                "${code}": code,
                "${value}": 0,
                "${range}": reg_range,
                "${success}": True,
                "[Tags]": mode
            })
        else:
            data.append({
                "${id}": i,
                "${mode}": mode,
                "${register}": random.choice(params.HOLDING_REGISTERS),
                "${code}": random.choice(params.WRITE_FUNCTION_CODES),
                "${value}": random.randint(0, 2048),
                "${range}": 0,
                "${success}": True,
                "[Tags]": mode
            })

    return data



with open("test_data.csv", "w", newline="") as csvfile:
    # fieldNames = ["*** Test Cases ***", "${id}", "${mode}", "${register}", "${code}", "${value}", "${range}", "[Tags]"]
    # data = []
    # for i in range(128):
    #     mode = random.choice(MODES)
    #     fieldData = {}
    #     if mode == "READ":
    #         from_reg = random.randint(0, 1)
    #         chosen_registry = params.INPUT_REGISTERS if from_reg == 0 else params.HOLDING_REGISTERS
    #         data.append({
    #             "${id}": i,
    #             "${mode}": mode,
    #             "${register}": random.choice(chosen_registry),
    #             "${code}": random.choice(params.READ_FUNCTION_CODES),
    #             "${value}": 0,
    #             "${range}": random.randint(1, len(chosen_registry)),
    #             "[Tags]": mode
    #         })
    #     else:
    #         data.append({
    #             "${id}": i,
    #             "${mode}": mode,
    #             "${register}": random.choice(params.HOLDING_REGISTERS),
    #             "${code}": random.choice(params.WRITE_FUNCTION_CODES),
    #             "${value}": random.randint(0, 2048),
    #             "${range}": 0,''
    #             "[Tags]": mode
    #         })

    fail_data = gen_fail_data()
    success_data = gen_success_data()
    data = fail_data + success_data

    writer = csv.DictWriter(csvfile, fieldnames=FIELD_NAMES, delimiter=";")
    writer.writeheader()
    writer.writerows(data,)

