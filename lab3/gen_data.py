import csv, random


HEART_MIN = 10
HEART_MAX = 360

TEMP_MIN = 30.0
TEMP_MAX = 42.0

TEMP = [x * 0.5 for x in range(60, 85)]

PATIENT_TYPES = ["adult", "child"]

with open("test_data.csv", "w", newline="") as csvfile:
    fieldNames = ["*** Test Cases ***", "${id}", "${heart_rate}", "${temp}", "${stdev}", "${patient_type}", "[Tags]"]
    data = []
    for i in range(128):
        heart_rate_val = random.randint(HEART_MIN, HEART_MAX)
        heart_rate = str(heart_rate_val)
        if heart_rate_val < 100:
            heart_rate = "0" + heart_rate

        temp = str(random.choice(TEMP))
        stdev = str(random.choice(["-0.05", "+0.05"]))

        patient_type = random.choice(PATIENT_TYPES)

        hr_state = "high"
        if heart_rate_val < 100:
            hr_state = "low"

        data.append({
            "${id}": i+1,
            "${heart_rate}": heart_rate,
            "${temp}": temp,
            "${stdev}": stdev,
            "${patient_type}": patient_type,
            "[Tags]": patient_type + "," + hr_state
        })

    writer = csv.DictWriter(csvfile, fieldnames=fieldNames, delimiter=";")
    writer.writeheader()
    writer.writerows(data,)
    
