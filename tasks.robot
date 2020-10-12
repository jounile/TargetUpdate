# +
*** Settings ***
Documentation          This robot extracts a software archive and deploys it to Linux. Finally it executes commands remotely to sync the memory and restart the Linux.
...
...                    Connections are handled as part of the suite setup and teardown.

Library                SSHLibrary
Library                OperatingSystem
Library                ArchiveLibrary


*** Variables ***

${BUILD_VERSION}       dihmi_int_nightly_20200924
${SEVENZ_ENV_PATH}     C:\\Program Files (x86)\\7-Zip

#PI
${HOST}                192.168.2.106
${PORT}                22
${USERNAME}            pi
${PASSWORD}            raspberry

${USB_BUILD_DIR}       D:\\_builds
${TEMP_BUILD_DIR}      C:\\temp



*** Keywords ***

Open Putty Connection And Log In
    Open Connection     ${HOST}
    Login               ${USERNAME}        ${PASSWORD}

Close Putty Connection
    Close Connection




*** Test Cases ***



Copy archive from USB to temp directory
    OperatingSystem.Copy File    ${USB_BUILD_DIR}/${BUILD_VERSION}.7z    ${TEMP_BUILD_DIR}/${BUILD_VERSION}.7z
    
Extract archive
    ${output}=    OperatingSystem.Run    "${SEVENZ_ENV_PATH}\\7z.exe" x ${TEMP_BUILD_DIR}\\${BUILD_VERSION}.7z "-o${TEMP_BUILD_DIR}" -r
    Log    ${output}

Open the Putty Connection
    Open Putty Connection And Log In




Remove hmi_old directory
    Write    sudo rm -r /opt/visteon/hmi_old

Rename Old hmi directory
    Write    sudo mv /opt/visteon/hmi /opt/visteon/hmi_old

Create empty hmi destination directory
    Write    sudo mkdir /opt/visteon/hmi

Change permissions on hmi destination directory
    Write    sudo chmod 777 /opt/visteon/hmi

Check the local hmi dir
    OperatingSystem.List Directory    ${TEMP_BUILD_DIR}\\${BUILD_VERSION}\\dihmi_bin\\hmi

Check the remote hmi dir
    SSHLibrary.List Directory    /opt/visteon/hmi

Copy hmi directory from Nightly Build
    Put Directory    ${TEMP_BUILD_DIR}\\${BUILD_VERSION}\\dihmi_bin\\hmi    destination=/opt/visteon    recursive=True

Copy ICHMIMain_IC_H from Nightly Build
    Put File    ${TEMP_BUILD_DIR}\\${BUILD_VERSION}\\dihmi_bin\\bin\\ic\\high\\ICHMIMain_IC_H    destination=/opt/visteon/hmi/ICHMIMain_IC_H




Remove hmihud_old directory
    Write    sudo rm -r /opt/visteon/hmihud_old

Rename Old hmihud directory
    Write    sudo mv /opt/visteon/hmihud /opt/visteon/hmihud_old

Create empty hmihud destination directory
    Write    sudo mkdir /opt/visteon/hmihud

Change permissions on hmihud destination directory
    Write    sudo chmod 777 /opt/visteon/hmihud

Check the local hmihud dir
    OperatingSystem.List Directory    ${TEMP_BUILD_DIR}\\${BUILD_VERSION}\\dihmi_bin\\hmihud

Check the remote hmihud dir
    SSHLibrary.List Directory    /opt/visteon/hmihud

Copy hmihud directory from Nightly Build
    Put Directory    ${TEMP_BUILD_DIR}\\${BUILD_VERSION}\\dihmi_bin\\hmihud    destination=/opt/visteon    recursive=True

Copy HUDHMIMain_IC_H from Nightly Build
    Put File    ${TEMP_BUILD_DIR}\\${BUILD_VERSION}\\dihmi_bin\\bin\\hud\\high\\HUDHMIMain_IC_H    destination=/opt/visteon/hmi/HUDHMIMain_IC_H




Sync files to memory
    [Documentation]    Sync files to memory
    #Write    sudo sync
    Log    Sync files to memory

Reset Target
    [Documentation]    Reset Target
    #Write    sudo rset
    Log    Reset Target
    
Restart the Target
    #Write    sudo shutdown -r now

Close the Putty Connection
    Close Putty Connection










