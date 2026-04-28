*** Variables ***
${SERIAL_PORT}=    /dev/ttyACM0

*** Settings ***
library    FlukeSerialCommand.py    ${SERIAL_PORT}
library    String

*** Keywords ***
Connect To Fluke
    Send Command    ignore
    Ignore Response
    Send Command    IDENT
    ${ident_response}=    Read Command
    ${split_response}=    Split String    ${ident_response}    ,
    IF    "${split_response[0]}" == "PROSIM8"
        Log    ${split_response[1]}
        Send Command    SN
        ${sn_response}=    Read Command
        Log    ${sn_response}
    ELSE
        Fail
    END

Set Mode
    [Arguments]    ${mode}    ${response}
    Send Command    ${mode}
    Response Should Be    ${response}

Run Command
    [Arguments]    ${command}
    Log To Console    ${command}
    Send Command    ${command}
    Response Should Be    *