:: Get directory of current script (without trailing slash)
set SCRIPT_DIR=%~dp0
set INSTALL_DIR=%SCRIPT_DIR:~0,-1%\..\install

:: Install Xspec
git clone -b master https://github.com/xspec/xspec.git %INSTALL_DIR%\xspec


:: Install Saxon-HE
::curl --output %INSTALL_DIR%\Saxon-HE.jar -L https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/10.6/Saxon-HE-10.6.jar 
PUSHD %INSTALL_DIR% && (
	mkdir saxon
	curl --ssl-no-revoke --output saxon.zip -L https://www.saxonica.com/download/SaxonPE11-4J.zip
	copy ..\..\saxon-license.lic .\saxon\saxon-license.lic
	ping -n 1 127.0.0.1
	tar -xf saxon.zip -C saxon
	del saxon.zip
) && POPD
