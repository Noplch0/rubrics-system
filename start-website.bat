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
for /f "usebackq delims=" %%I in (`powershell.exe -NoProfile -Command "Get-NetIPAddress -AddressFamily IPv4 ^| Where-Object { $_.IPAddress -notlike '127.*' -and $_.AddressState -eq 'Preferred' } ^| ForEach-Object { '  http://' + $_.IPAddress + ':%PORT%/' }"`) do echo %%I
echo.
echo Keep this window open while using the website.
echo Press Ctrl+C to stop the server.
echo ========================================
echo.

where python >nul 2>nul
if %errorlevel% equ 0 (
    python -m http.server %PORT% --bind 0.0.0.0 --directory .
) else (
    where py >nul 2>nul
    if %errorlevel% equ 0 (
        py -m http.server %PORT% --bind 0.0.0.0 --directory .
    ) else (
        echo ERROR: Python was not found.
        echo Install Python and try again.
    )
)

echo.
echo Server stopped.
pause
