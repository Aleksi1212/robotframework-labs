*** Settings ***
Library    String
Library    Dialogs
Library    Collections
Library    Process
Library    SSHLibrary
Library    FakerLibrary    fi_FI
Suite Setup    Connect To Server

*** Variables ***
${ADDRESS_FILE}=    /tmp/address_file.txt
${HOST}=    localhost
${PORT}=    2222
${KEY_FILE}=    key.pem
${USER}=    ssh.user

*** Keywords ***
Connect To Server
    Open Connection    host=${HOST}    port=${PORT}
    Login With Public Key    username=${USER}    keyfile=${KEY_FILE}

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
        ${file_content}=    Execute Command    cat ${file_name}
        @{lines}=    Split To Lines    ${file_content}
        ${first_name}=    Set Variable    ${lines}[0]
        Log To Console    ${first_name}
        Execute Command    rm ${file_name}
    ELSE
        Log To Console    ${file_name} not found.
    END

 
*** Test Cases ***
Remove Existing Addresss File Test
    Remove Existing Addresss File    ${ADDRESS_FILE}

Create New Address File Test
    [Tags]    create
    @{rand_names}=    Get Random Names    5
    ${full_name}=    Get Selection From User    Choose a Name:    @{rand_names}
    ${address}=    Street Address
    ${postcode}=    Postcode
    ${city}=    City

    Execute Command    touch ${ADDRESS_FILE}
    Execute Command
    ...    printf '%s\n%s\n%s %s\n' "${full_name}" "${address}" "${postcode}" "${city}" > ${ADDRESS_FILE}

Address File OK
    ${file_content}=    Execute Command    cat ${ADDRESS_FILE}
    Log To Console    ${file_content}
    @{lines}=    Split To Lines    ${file_content}
    ${line_count}=    Get Length    ${lines}

    IF    ${line_count} != 3
        Fail    Line count should be 3. Got: ${line_count}
    END
    
    

