*** Settings ***
Library    OperatingSystem
Library    String
Library    Dialogs
Library    Collections
Library    FakerLibrary    fi_FI

*** Keywords ***
Get Random Names
    [Arguments]    ${name_count}
    ${name_list}=    Create List
    FOR    ${i}    IN RANGE    ${name_count}
        ${first_name}=    First Name
        ${last_name}=    Last Name
        Append To List    ${name_list}    ${first_name} ${last_name}
    END
    RETURN    ${name_list}

Remove Existing Addresss File
    [Arguments]    ${file_name}
    ${file_exists}=    Run Keyword And Return Status    File Should Exist    ${file_name}

    IF    ${file_exists}
        ${file_content}=    Get File    ${file_name}
        @{lines}=    Split To Lines    ${file_content}
        ${first_name}=    Set Variable    ${lines}[0]
        Log    ${first_name}
        Remove File    ${file_name}
    ELSE
        Log    ${file_name} not found.
    END

 
*** Test Cases ***
Remove Existing Addresss File Test
    Remove Existing Addresss File    test.txt

Create New Address File Test
    @{rand_names}=    Get Random Names    5
    ${full_name}=    Get Selection From User    Choose a Name:    @{rand_names}
    ${address}=    Street Address
    ${postcode}=    Postcode
    ${city}=    City

    ${file_content}=    Catenate    SEPARATOR=\n
    ...    ${full_name}
    ...    ${address}
    ...    ${postcode} ${city}

    Create File    address_file.txt    ${file_content}

Address File OK
    ${file_content}=    Get File    address_file.txt
    @{lines}=    Split To Lines    ${file_content}
    ${line_count}=    Get Length    ${lines}

    IF    ${line_count} != 3
        Fail    Line count should be 3. Got: ${line_count}
    END
    
    

