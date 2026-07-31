@echo off
setlocal
cd /d "%~dp0"
set "PORT=8080"

echo ========================================
echo Local website server
echo ========================================
echo.
echo Website directory: %CD%
echo Local address:     http://127.0.0.1:%PORT%/
echo LAN addresses:
for /f "usebackq delims=" %%I in (`powershell.exe -NoProfile -Command "$addresses = Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred; foreach ($address in $addresses) { if ($address.IPAddress -notlike '127.*') { '  http://' + $address.IPAddress + ':%PORT%/' } }"`) do echo %%I
echo.
echo Keep this window open while using the website.
echo Press Ctrl+C to stop the server.
echo ========================================
echo.

where npm >nul 2>nul
if not %errorlevel% equ 0 (
    echo ERROR: npm was not found.
    echo Install Node.js, then run this script again.
    pause
    exit /b 1
)

if not exist "node_modules\.bin\http-server.cmd" (
    echo ERROR: Project dependencies are not installed.
    echo Run: npm install
    pause
    exit /b 1
)

call npm start
set "exitCode=%errorlevel%"

echo.
echo Server stopped.
pause
exit /b %exitCode%
