@ECHO OFF
SETLOCAL
:: Get directory of current script (without trailing slash)
set SCRIPT_DIR=%~dp0

PUSHD %SCRIPT_DIR:~0,-1%\..\install
    SET INSTALL_DIR=%CD%
POPD

:: Install Xspec
CALL %SCRIPT_DIR%\install-xspec.bat master


:: Install Saxon-HE
::CALL :install_saxon HE,10.8
::CALL :install_saxon HE,11.4
::CALL :install_saxon PE,10.8
CALL %SCRIPT_DIR%\install-saxon.bat PE 11.4



GOTO :EOF






