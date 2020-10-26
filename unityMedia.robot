*** Settings ***
Library  Selenium2Library
Library  OperatingSystem
Resource  userAccounts.robot
Suite Teardown  Close Browser

*** Test Cases ***

Test
  Log To Console  Calling login for user "${USER_NAME}"
  ${account}=  Set Variable  &{accounts}[${USER_NAME}]
  Login  @{account}
  Start Speedtest

*** Keywords ***

Start Speedtest

  Wait For Element And Click
  ...  xpath=(//a[text() = "Hilfe & Service"])[1]
  
  Log To Console  Navigated to "Hilfe & Service"

  Wait For Element And Click
  ...  xpath=//span[@class="accordion-title" and text() = "Service Internet"]
  
  Wait For Element And Click
  ...  xpath=//span[text() = "Speedtest"]
  
  Log To Console  Starting speedtest ...
  
  Wait For Element And Click
  ...  xpath=//p[text() = "Start"]
  
  Wait Until Page Contains Element
  ...  xpath=//p[text() = "Hier sind Deine Messergebnisse"]
  ...  120 seconds
  
  ${download}=  Get Element Attribute
  ...  //div[@id = "download_result"]//*[@data-content="Mbit/s"]  innerText
  
  ${upload}=  Get Element Attribute
  ...  //div[@id = "upload_result"]//*[@data-content="Mbit/s"]  innerText
  
  ${ping}=  Get Element Attribute
  ...  //div[@id = "ping_result"]//*[@data-content="ms"]  innerText

  
  Log To Console  Results: down=${download} - upload=${upload} - ping=${ping}
  
Login

  [Arguments]  ${userId}  ${password}
  
  Open Browser
  ...  url=https://www.unitymedia.de/benutzerkonto/login/zugangsdaten/
  ...  browser=Chrome
  ...  remote_url=http://127.0.0.1:4444/wd/hub
  
  Wait For Element And Click
  ...  xpath://button[text() = "Alle Cookies annehmen"]
  
  Wait Until Page Contains Element
  ...  xpath://input[@name="userId"]
  
  Input Text
  ...  xpath://input[@name="userId"]
  ...  text=${userId}
  
  Input Password
  ...  xpath://input[@name="password"]
  ...  password=${password}
  
  
  Click Element
  ...  xpath://button[@type="submit"]/ancestor::div[@class="floatleft"]
  
  Wait Until Page Contains Element
  ...  xpath://span[@class="js_mn-customerName" and text()="${userId}"]
  
  Log To Console  Successfully logged in

Open Browser

    [Arguments]
    ...  ${url}
    ...  ${browser}
    ...  ${alias}=None
    ...  ${remote_url}=False
    ...  ${desired_capabilities}=None
    ...  ${ff_profile_dir}=None

    ${options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys
    Call Method  ${options}  add_argument  headless
    ${options}=  Call Method  ${options}  to_capabilities

    Create WebDriver
    ...  driver_name=Remote
    ...  alias=${alias}
    ...  command_executor=${remote_url}
    ...  desired_capabilities=${options}

    #Set Window Size  1600  900

    Go To  ${url}
  
Wait For Element And Click

  [Arguments]  ${locator}

  Wait Until Page Contains Element
  ...  ${locator}

  Click Element
  ...  ${locator}

