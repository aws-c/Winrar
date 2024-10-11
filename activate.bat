@echo off

:: Set the URL for the WinRAR key file and download page
set "key_url=https://winrar.cybar.xyz/rarkey.rar"
set "download_url=https://www.win-rar.com/download.html"

:: Set the path to the WinRAR installation directory
set "winrar_path=C:\Program Files\WinRAR"

:: Set the local file path where the .rar file will be saved temporarily
set "rar_file=%TEMP%\rarkey.rar"

:: Check if WinRAR is installed
if not exist "%winrar_path%\WinRAR.exe" (
    echo.
    echo ====================================================
    echo WinRAR is not installed on your system.
    echo Please download and install WinRAR from the following URL:
    echo %download_url%
    echo.
    echo If the download page does not open automatically, copy the URL above into your browser.
    echo After installing WinRAR, run this script again to activate it.
    echo ====================================================
    echo.
    pause
    echo Attempting to open the download page in your browser...

    :: Open the URL using PowerShell to ensure compatibility
    powershell -Command "Start-Process '%download_url%'"

    :: Check if PowerShell failed to open the browser
    if %errorlevel% neq 0 (
        echo Failed to open the URL automatically. Please manually open this link: %download_url%
    )
    exit /b 1
)

:: Download the .rar file using PowerShell
powershell -Command "Invoke-WebRequest -Uri '%key_url%' -OutFile '%rar_file%'"

:: Check if the download was successful
if not exist "%rar_file%" (
    echo Failed to download the rarkey.rar file.
    exit /b 1
)

:: Open the downloaded .rar file with WinRAR to activate the license
start "" "%winrar_path%\WinRAR.exe" "%rar_file%"

:: Pause to allow time for activation
timeout /t 5 /nobreak >nul

:: Check for rarreg.key in common locations
if exist "%winrar_path%\rarreg.key" (
    echo ====================================================
    echo WinRAR license activated permanently.
    echo ====================================================
) else if exist "%APPDATA%\WinRAR\rarreg.key" (
    echo ====================================================
    echo WinRAR license activated permanently.
    echo ====================================================
) else if exist "%ProgramData%\WinRAR\rarreg.key" (
    echo ====================================================
    echo WinRAR license activated permanently.
    echo ====================================================
) else (
    echo Failed to activate WinRAR.
)

:: End
pause
