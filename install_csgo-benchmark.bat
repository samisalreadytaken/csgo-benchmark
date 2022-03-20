@ECHO OFF

SET projectname=csgo-benchmark

ECHO.&&ECHO.
ECHO                     [1mgithub.com/samisalreadytaken/%projectname%[0m
ECHO.&&ECHO.

REG QUERY "HKCU\Software\Valve\Steam">NUL 2>NUL
IF ERRORLEVEL 1 GOTO NOREG

FOR /F "tokens=2* skip=2" %%a IN ('REG QUERY "HKCU\Software\Valve\Steam" /v "SteamPath"') DO SET csgodir=%%b

:CHECKDIR
SET "csgodir=%csgodir%/steamapps/common/Counter-Strike Global Offensive/"
IF NOT EXIST "%csgodir%/csgo/" GOTO NODIR

CD /d %csgodir%
ECHO Found game directory:
ECHO        %csgodir%
ECHO.

IF EXIST "csgo/scripts/vscripts/benchmark.nut" ( ECHO [1mUpdating...[0m ) ELSE ( ECHO [1mInstalling...[0m )

ECHO [90m===============================================================================

curl -L -o %projectname%.tar.gz https://codeload.github.com/samisalreadytaken/%projectname%/tar.gz/master
tar -xzf %projectname%.tar.gz --strip=1 %projectname%-master/csgo && DEL %projectname%.tar.gz

IF ERRORLEVEL 1 GOTO DLFAIL

ECHO ===============================================================================[0m
ECHO [92mSuccess![0m
ECHO.
ECHO Press any key to exit...
PAUSE >NUL
GOTO:EOF

:NODIR
ECHO [91mERROR[0m: Could not find game directory at:
ECHO        %csgodir%
ECHO.
ECHO Enter your CS:GO Steam library directory: (E.g. '[1mD:/SteamLibrary[0m')
SET /p csgodir=[7m^>:[0m 
ECHO.

IF %csgodir%=="" GOTO:EOF

GOTO CHECKDIR

:NOREG
ECHO [91mERROR[0m: Could not find Steam installation!
ECHO.
ECHO Press any key to exit...
PAUSE >NUL
GOTO:EOF

:DLFAIL
ECHO.
ECHO [91mERROR[0m: Download failed.
ECHO.
ECHO Press any key to exit...
PAUSE >NUL
GOTO:EOF
