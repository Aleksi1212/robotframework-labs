*** Variables ***
${SERIAL_PORT}=    /dev/ttyACM0

*** Settings ***
library    FlukeSerialCommand.py    ${SERIAL_PORT}
library    String

*** Test Cases ***
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

Set Simulator State
    Send Command    REMOTE
    Response Should Be    RMAIN

    Send Command    TEMP=36.5
    Response Should Be    *

    Send Command    NSRA=078
    Response Should Be    *

    Send Command    STDEV=+0.05
    Response Should Be    *

    Send Command    ECGRUN=TRUE
    Response Should Be    *

