*** Settings ***
Library    SeleniumLibrary
Library    Process
Library    GenCar.py
Suite Setup    Run Process    bash    ./car_start.sh
Suite Teardown    Run Process    bash    ./car_stop.sh
Test Setup    Open Browser    http://localhost:3000
Test Teardown    Close Browser

*** Keywords ***
Add A Car
    [Arguments]    ${make}=None    ${plate}=None
    Click Link    Add a car
    ${car}=    Generate Car    ${make}    ${plate}

    Input Text    make    ${car[0]}
    Input Text    model    ${car[1]}
    Input Text    mileage    ${car[2]}
    Input Text    year    ${car[3]}
    Input Text    plate    ${car[4]}

    Click Element    xpath=//input[@value="Add a new car"]

*** Test Cases ***
Add Cars Part1
    [Tags]    P1
    FOR    ${i}    IN RANGE    3
        Add A Car
    END
    
    Add A Car    plate=ABC-123
    Add A Car
    Add A Car    
    
    Capture Page Screenshot

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'car-plate')]
    Open Context Menu    xpath=//span[text()='ABC-123']
    Handle Alert    action=ACCEPT

    Element Should Not Be Visible    ABC-123

    Capture Page Screenshot

Add Cars Part2
    [Tags]    P2
    FOR    ${i}    IN RANGE    10
        IF    ${i} <= 3
            Add A Car    Toyota
        ELSE IF    ${i} <= 6
            Add A Car    Skoda
        ELSE
            Add A Car    Audi
        END
    END

    Capture Page Screenshot

    ${visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//span[text()='Skoda']
    WHILE    ${visible}
        Open Context Menu    xpath=//span[text()='Skoda']
        Handle Alert    action=ACCEPT
        ${visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//span[text()='Skoda']
    END

    Element Should Not Be Visible    xpath=//span[text()='Skoda']

    Capture Page Screenshot
    
    
    
    
