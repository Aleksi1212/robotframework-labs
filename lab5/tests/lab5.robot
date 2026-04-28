*** Settings ***
Documentation    Lab5 test
Library    Serial.py
Library    DataDriver    file=test_data.csv
Suite Setup    Setup
Test Template    Morse Test


*** Test Cases ***
Morse Test ${type} ${id} ${speed}
    ${id}    ${type}    ${message}    ${speed_ms}    ${speed}
    [Tags]    FAST    MEDIUM    SLOW


*** Keywords ***
Setup
    [Documentation]    Setup
    Send Command    ignore
    Ignore Response
    Send Command    ATE
    ${result}=    Read Command
    Log To Console    ${result}
    Send Command    ATE0
    IF    "${result}" == "ATE"
        Response Should Be    ATE0
    ELSE
        Response Should Be    OK
    END

Morse Test
    [Documentation]    Morse test
    [Arguments]    ${type}    ${message}    ${speed_ms}

    IF    "${type}" == "TEXT"
        Send Command    AT+SEND="${message}"
        Response Should Be    SENT="${message}"
    ELSE IF    "${type}" == "SPEED"
        Send Command    ATW${speed_ms}
        Response Should Be    OK
    END
