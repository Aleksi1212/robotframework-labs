import csv
import random
import string

FIELD_NAMES = ["*** Test Cases ***", "${id}", "${type}", "${message}", "${speed_ms}", "${speed}", "[Tags]"]

def random_string(n):
    chars = string.ascii_letters + string.digits
    return ''.join(random.choice(chars) for _ in range(n))

def gen_messages(data: list, speed: str) -> list:
    for i in range(3):
        data.append({
            "${id}": i,
            "${type}": "TEXT",
            "${message}": random_string(random.randint(i*10, (i+1)*10)).upper(),
            "${speed_ms}": 0,
            "${speed}": speed,
            "[Tags]": speed
        })

    return data

with open("test_data.csv", "w", newline="") as csvfile:
    data = []
    data.append({
        "${id}": 1,
        "${type}": "SPEED",
        "${message}": "",
        "${speed_ms}": 20,
        "${speed}": "FAST",
        "[Tags]": "FAST"
    })
    gen_messages(data, "FAST")

    data.append({
        "${id}": 2,
        "${type}": "SPEED",
        "${message}": "",
        "${speed_ms}": 20,
        "${speed}": "MEDIUM",
        "[Tags]": "MEDIUM"
    })
    gen_messages(data, "MEDIUM")

    data.append({
        "${id}": 3,
        "${type}": "SPEED",
        "${message}": "",
        "${speed_ms}": 20,
        "${speed}": "SLOW",
        "[Tags]": "SLOW"
    })
    gen_messages(data, "SLOW")

    writer = csv.DictWriter(csvfile, fieldnames=FIELD_NAMES, delimiter=";")
    writer.writeheader()
    writer.writerows(data,)