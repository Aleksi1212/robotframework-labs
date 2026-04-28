*** Settings ***
Library         DataDriver    file=test_data.csv
Resource        lab3.resource
Suite Setup     Connect To Fluke
Suite Teardown  Set Mode    LOCAL     LOCAL
Test Setup      Set Mode    REMOTE    RMAIN
Test Teardown   Run Command    ECGRUN=FALSE
Test Template   Verify Patient Vitals

*** Test Cases ***
Vitals Check for patient ${id} HR ${heart_rate} Temp ${temp}
    ${id}    ${heart_rate}    ${temp}    ${stdev}    ${patient_type}
    [Tags]    adult    child    high    low

*** Keywords ***
Verify Patient Vitals
    [Arguments]    ${id}    ${heart_rate}    ${temp}    ${stdev}    ${patient_type}
    
    IF    "${patient_type}" == "adult"
        Run Command    NSRA=${heart_rate}
        Run Command    STDEV=${stdev}
    ELSE
        Run Command    NSRP=${heart_rate}
    END

    Run Command    TEMP=${temp}