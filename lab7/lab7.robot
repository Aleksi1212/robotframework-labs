*** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary

*** Keywords ***
Add A Car
    Click Link    Add a car
    ${make}=    First Name
    ${model}=    First Name
    ${mileage}=    Random Number
    ${year}=    Year
    ${plate}=    License Plate

    Input Text    make    ${make}
    Input Text    model    ${model}
    Input Text    mileage    ${mileage}
    Input Text    year    ${year}
    Input Text    plate    ${plate}

    Click Element    xpath=//input[@value="Add a new car"]


*** Test Cases ***
Add Cars
    Open Browser    http://localhost:3000

    Capture Page Screenshot
    FOR    ${i}    IN RANGE    3
        Add A Car
    END
    Capture Page Screenshot

    Close Browser