@ECHO OFF
:: Install Saxon
SETLOCAL 
:install_saxon
SET EDITION=%1
SET VERSION=%2

IF NOT DEFINED INSTALL_DIR (
    SET INSTALL_DIR=%CD%
)

:: Compute Download URL from version and edition
SET SAXON_URL=Saxon%EDITION%%VERSION:.=-%J.zip
GOTO install_saxon_%EDITION%
ECHO Unexpected Edition. Valid values are HE, PE or EE
GOTO exit_install_saxon
:install_saxon_HE
SET /A V=VERSION+0
SET SAXON_URL=https://sourceforge.net/projects/saxon/files/Saxon-HE/%V%/Java/%SAXON_URL%/download
GOTO finish_saxon_install
:install_saxon_PE
:install_saxon_EE
SET SAXON_URL=https://www.saxonica.com/download/%SAXON_URL%
:finish_saxon_install 
ECHO Downloading Saxon %EDITION% %VERSION% from %SAXON_URL%
ECHO.
SET DEST=%INSTALL_DIR%\Saxon%EDITION%%VERSION%
MKDIR %DEST% 2>NUL
CURL --ssl-no-revoke --output saxon.zip -L %SAXON_URL%
TIMEOUT /t 2 /nobreak >NUL 2>NUL
COPY ..\..\saxon-license.lic %DEST%\saxon-license.lic >NUL 2>NUL
::powershell.exe -nologo -noprofile -command "& { $shell = New-Object -COM Shell.Application; $target = $shell.NameSpace('%INSTALL_DIR%\%DEST%'); $zip = $shell.NameSpace('%INSTALL_DIR%\saxon.zip'); $target.CopyHere($zip.Items(), 16); }"
TAR -xf saxon.zip -C %DEST%
DEL saxon.zip
:exit_install_saxon
ECHO.
ECHO.
EXIT /B 0
