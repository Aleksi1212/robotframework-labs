*** Settings ***
Library    DataDriver    file=test_data.csv
Library    Modbus.py
Test Template    Test Modbus

*** Test Cases ***
Modbus ${mode} test_${id}. Reg: ${register}, Code: ${code}, Value: ${value}, Range: ${range}
    ${id}    ${mode}    ${register}    ${code}    ${value}    ${range}    ${success}
    [Tags]    READ    WRITE

*** Keywords ***
Test Modbus
    [Arguments]    ${id}    ${mode}    ${register}    ${code}    ${value}    ${range}    ${success}

    IF    "${mode}" == "READ"
        ${result}=    Read From Register    ${register}    ${range}    ${code}
        IF    ${result[0]} != ${success}
            Fail
        ELSE
            Log To Console    ${result[1]}
        END
        
    ELSE
        ${pass}=    Write To Register    ${register}    ${value}    ${code}
        IF    ${pass} != ${success}
            Fail
        END
        
    END
    