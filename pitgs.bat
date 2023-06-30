@ECHO OFF
REM Lines beginning with "REM" are REMarks, and are ignored by the commandline.
REM You will need ngrok: https://ngrok.com/download
 
REM ##########################
REM ##### CONFIG OPTIONS #####
REM ##########################
 
REM REQUIRED. Should be a file path, e.g. C:/ngrok/. No quotes please.
REM Example: SET NGROK_LOCATION=C:/ngrok
SET NGROK_LOCATION=D:/Games/1Downloads/ngrok-v3-stable-windows-amd64/
 
REM Optional. Additional commandline parameters.
SET ADDITIONAL_PARAMS=
 
REM Optional. This should be the reserved TCP address you have.
REM Will fetch a random one automatically if not set.
REM Example: SET REMOTE_ADDR=example.ngrok.io:1337
SET REMOTE_ADDR=
 
REM Optional. This is the port on your computer that you're hosting the server from.
REM Any number between 1 and 65535, leave blank for mid-run prompt.
REM Example: SET DESIRED_PORT=42069
SET DESIRED_PORT=1337
 
REM ##############################
REM ##### END CONFIG OPTIONS #####
REM ##############################
 
 
REM now the fun begins
REM print something to terminal so the user knows that it loaded
ECHO ngrok loader ready.
IF NOT DEFINED NGROK_LOCATION (
    ECHO File unconfigured. Please edit this file's internal configuration.
    ECHO Right click this file and press EDIT.
    TIMEOUT 120
    EXIT
)
ECHO Beginning sanity checks...
 
REM Let's start by checking if the listed directory above exists
IF EXIST %NGROK_LOCATION% (
    ECHO Changing directory to %NGROK_LOCATION%...
    CD %NGROK_LOCATION%
    ECHO Done.
    ECHO.
 
) ELSE (
    ECHO #######################
    ECHO ##### FATAL ERROR #####
    ECHO #######################
    ECHO.
    ECHO Failed to change directory to %NGROK_LOCATION% - does the directory exist?
    ECHO.
    ECHO Things to try:
    ECHO * Edit the batchfile and ensure the location is set. Trailing slash doesn't matter.
    ECHO * Check for typos or quotation marks in the location name.
    ECHO.
    ECHO Batchfile will now terminate.
    TIMEOUT 120
    EXIT
)
 
REM Check if ngrok exists, it will not work otherwise
ECHO Checking that ngrok.exe exists...
IF EXIST ngrok.exe (
    ECHO Done.
) ELSE (
    ECHO.
    ECHO #######################
    ECHO ##### FATAL ERROR #####
    ECHO #######################
    ECHO.
    ECHO ngrok not found in directory %NGROK_LOCATION%. 
    ECHO.
    ECHO Things to try:
    ECHO * Ensure the ngrok executable is downloaded and in the directory specified by
    ECHO NGROK_LOCATION in the header of this batchfile.
    ECHO * Ensure the ngrok executable is literally named "ngrok.exe"
    ECHO.
    ECHO Batchfile will now terminate.
    TIMEOUT 120
    EXIT
)
ECHO.
 
REM Now we should check if any additional parameters are set.
ECHO Checking additional parameters...
IF NOT DEFINED ADDITIONAL_PARAMS (
    ECHO No additional parameters found.
) ELSE (
    ECHO Additional parameters found: %ADDITIONAL_PARAMS%
)
echo.
 
REM Let's remind the user what the remote address is set to.
ECHO Checking remote address...
IF NOT DEFINED REMOTE_ADDR (
    ECHO !!!!! WARNING !!!!!
    ECHO No remote address configured, a dynamic address may be used...
) ELSE (
    ECHO Remote address found, will use: %REMOTE_ADDR%
)
ECHO.
 
REM Is there a desired port?
:PORT_CHECK
ECHO Checking desired port...
 
IF DEFINED DESIRED_PORT (
    ECHO Desired port found: %DESIRED_PORT%
) ELSE (
    ECHO Desired port not found, prompting user...
    ECHO.
    REM "I am the box ghost."
    ECHO  --------------------------- BEWARE! --------------------------- 
    ECHO   THERE ARE ABSOLUTELY NO SANITY CHECKS ON THE FOLLOWING PROMPT 
    ECHO     BE SURE YOUR INPUT IS WHAT YOU WANT BEFORE PRESSING ENTER   
    ECHO.
    ECHO  ------------------------ COMMON PORTS: ------------------------
    ECHO   Minecraft: 25565      Terraria/BYOND: 7777      Source: 27015
    ECHO  ---------------------------------------------------------------
    ECHO.
    SET /P DESIRED_PORT="Please enter your desired port number [1 ~ 65535]: "
    ECHO.
    CHOICE /M "Confirm port %DESIRED_PORT% "
    IF ERRORLEVEL 2 (
        ECHO.
        ECHO Clearing desired port and restarting checks...
        SET DESIRED_PORT=
        GOTO PORT_CHECK
    )
)
 
 
REM FINAL CONFIRMATION!
ECHO.
ECHO.
ECHO Sanity checks complete.
ECHO.
ECHO Preparing to run the following:
ECHO Path: %NGROK_LOCATION%
IF DEFINED REMOTE_ADDR ECHO Desired inbound address: %REMOTE_ADDR%
ECHO Desired port: %DESIRED_PORT% (this is the port on your computer it will connect to)
ECHO.
CHOICE /M "Confirm? (Cancelling will terminate batchfile)"
IF ERRORLEVEL 2 EXIT
SET ERRORLEVEL=0
ECHO.
CHOICE /M "FINAL CONFIRMATION: [R]un script, or [A]bort script " /C RA
IF ERRORLEVEL 2 EXIT
SET ERRORLEVEL=0
 
CHOICE /M "Start monitor in web browser? (This is bugged and will start it regardless, sorry.) "
IF ERRORLEVEL 1 START "" http://localhost:4040
 
 
IF DEFINED REMOTE_ADDR (
    ngrok tcp --remote-addr=%REMOTE_ADDR% %DESIRED_PORT%
) ELSE (
    ngrok tcp %DESIRED_PORT%
)
 
ECHO End of script. Pressing any key will terminate.
TIMEOUT 30
EXIT
