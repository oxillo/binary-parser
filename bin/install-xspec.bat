@ECHO OFF
:: Install Saxon
SETLOCAL 
:install_xspec
SET BRANCH=%1


IF NOT DEFINED INSTALL_DIR (
    SET INSTALL_DIR=%CD%
)

ECHO Cloning Xspec
git clone -b master https://github.com/xspec/xspec.git %INSTALL_DIR%\xspec

:exit_install_xspec
ECHO.
ECHO.
EXIT /B 0
