@echo off
REM ============================================================================
REM LPA Certified Copy Stamper - BHP Law
REM ============================================================================
REM Single-file launcher that automatically:
REM   1. Installs Python (via winget) if not present
REM   2. Creates virtual environment
REM   3. Installs dependencies
REM   4. Launches the interactive certification wizard
REM ============================================================================

setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "VENV_PYTHON=%SCRIPT_DIR%pdf_stamper_env\Scripts\python.exe"
set "VENV_PIP=%SCRIPT_DIR%pdf_stamper_env\Scripts\pip.exe"
set "STAMPER_SCRIPT=%SCRIPT_DIR%pdf_stamper.py"
set "REQUIREMENTS=%SCRIPT_DIR%requirements.txt"

REM ============================================================================
REM Step 1: Check if Python is installed
REM ============================================================================
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ============================================================================
    echo  Python Not Found - Installing...
    echo ============================================================================
    echo.
    
    REM Check if winget is available
    where winget >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] winget is not available on this system.
        echo.
        echo Please install Python 3.10+ manually from:
        echo   https://www.python.org/downloads/
        echo.
        echo During installation, check: [✓] Add Python to PATH
        echo.
        pause
        exit /b 1
    )
    
    echo Installing Python 3.12 via winget...
    winget install --id Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
    
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo [ERROR] Failed to install Python via winget.
        echo.
        echo Please install Python manually from:
        echo   https://www.python.org/downloads/
        echo.
        pause
        exit /b 1
    )
    
    echo.
    echo ============================================================================
    echo  Python Installed Successfully!
    echo ============================================================================
    echo.
    echo IMPORTANT: Please close this window and double-click stamp_lpa.bat again.
    echo (Windows needs to refresh the PATH environment variable)
    echo.
    pause
    exit /b 0
)

echo Python found!
echo.

REM ============================================================================
REM Step 2: Check/Create Virtual Environment
REM ============================================================================
if not exist "%VENV_PYTHON%" (
    echo ============================================================================
    echo  Setting Up Virtual Environment
    echo ============================================================================
    echo.
    echo Creating virtual environment...
    python -m venv "%SCRIPT_DIR%pdf_stamper_env"
    
    if not exist "%VENV_PYTHON%" (
        echo.
        echo [ERROR] Failed to create virtual environment.
        echo Please ensure Python 3.10+ is installed correctly.
        echo.
        pause
        exit /b 1
    )
    
    echo Virtual environment created!
    echo.
) else (
    echo Virtual environment exists.
    echo.
)

REM ============================================================================
REM Step 3: Install Dependencies
REM ============================================================================
echo Checking dependencies...
"%VENV_PYTHON%" -c "import fitz; import click" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Installing required libraries (PyMuPDF and Click)...
    echo.
    "%VENV_PYTHON%" -m pip install --upgrade pip --quiet
    "%VENV_PIP%" install -r "%REQUIREMENTS%" --quiet
    
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo [ERROR] Failed to install dependencies.
        echo Please check your internet connection and try again.
        echo.
        pause
        exit /b 1
    )
    echo Dependencies installed!
) else (
    echo Dependencies OK.
)
echo.
echo Setup complete! Launching application...
echo.

REM ============================================================================
REM Step 4: Launch Application
REM ============================================================================
cls
echo.
echo ============================================================================
echo           LPA Certified Copy Stamper - BHP Law
echo ============================================================================
echo.
echo This tool will add certification stamps to all pages of your scanned LPA.
echo The stamps will appear in the bottom right corner of each page.
echo.
echo After processing, you can print the PDF and the Fee Earner will sign
echo each page in wet ink.
echo.
echo ============================================================================
echo.
pause

:select_file
cls
echo.
echo ============================================================================
echo  Step 1: Select the Scanned LPA File
echo ============================================================================
echo.
echo Please drag and drop the scanned LPA PDF file onto this window,
echo or type the full path to the file.
echo.
set /p "INPUT_FILE=Enter file path: "

REM Remove quotes if present
set "INPUT_FILE=%INPUT_FILE:"=%"

REM Check if file exists
if not exist "%INPUT_FILE%" (
    echo.
    echo [ERROR] File not found! Please try again.
    echo.
    pause
    goto :select_file
)

echo.
echo Selected: %INPUT_FILE%
echo.
pause

:select_office
cls
echo.
echo ============================================================================
echo  Step 2: Select Office Location
echo ============================================================================
echo.
echo Which office address should appear on the stamp?
echo.
echo   1. Darlington - BHP Law, Westgate House, Faverdale, Darlington, DL3 0PZ
echo   2. Durham     - BHP Law, Aire House, Mandale Business Park, Belmont, Durham, DH1 1TH
echo   3. Newcastle  - BHP Law, Suite 307, Collingwood Buildings, 38 Collingwood Street, Newcastle upon Tyne, NE1 1JF
echo   4. Tynemouth  - BHP Law, 39 Percy Park Road, Tynemouth, North Shields, NE30 4LR
echo.
set /p "OFFICE_CHOICE=Enter choice (1-4, default=1): "

if "%OFFICE_CHOICE%"=="1" set "OFFICE=darlington"
if "%OFFICE_CHOICE%"=="2" set "OFFICE=durham"
if "%OFFICE_CHOICE%"=="3" set "OFFICE=newcastle"
if "%OFFICE_CHOICE%"=="4" set "OFFICE=tynemouth"
if "%OFFICE_CHOICE%"=="" set "OFFICE=darlington"

REM Validate
if not defined OFFICE (
    echo.
    echo [ERROR] Invalid choice. Please try again.
    echo.
    pause
    goto :select_office
)

echo.
echo Selected office: %OFFICE%
echo.
pause

:enter_fee_earner
cls
echo.
echo ============================================================================
echo  Step 3: Enter Fee Earner Name
echo ============================================================================
echo.
echo Enter the name of the solicitor who will sign the certification.
echo This will appear as: "I, [Name], Solicitor, of [address]..."
echo.
echo Example: John Smith
echo.
set /p "FEE_EARNER=Fee Earner name: "

if "%FEE_EARNER%"=="" (
    echo.
    echo [ERROR] Name cannot be empty. Please try again.
    echo.
    pause
    goto :enter_fee_earner
)

echo.
echo Fee Earner: %FEE_EARNER%
echo.
pause

:confirm
cls
echo.
echo ============================================================================
echo  Step 4: Confirm Settings
echo ============================================================================
echo.
echo Please confirm the following settings:
echo.
echo   Input File:    %INPUT_FILE%
echo   Office:        %OFFICE%
echo   Fee Earner:    %FEE_EARNER%
echo   Date:          Today (auto)
echo   Scale:         90%% (default)
echo.
echo The output file will be saved as:
echo   %~dpn1_certified.pdf
echo.
set /p "CONFIRM=Proceed with certification? (Y/N): "

if /i not "%CONFIRM%"=="Y" (
    echo.
    echo Certification cancelled.
    echo.
    pause
    exit /b 0
)

:processing
cls
echo.
echo ============================================================================
echo  Processing Your LPA
echo ============================================================================
echo.
echo Please wait while the certification stamps are being applied...
echo.

REM Generate output filename
for %%A in ("%INPUT_FILE%") do (
    set "OUTPUT=%%~dpA%%~nA_certified.pdf"
)

REM Run the stamper
"%VENV_PYTHON%" "%STAMPER_SCRIPT%" "%INPUT_FILE%" --fee-earner "%FEE_EARNER%" --office %OFFICE% --output "%OUTPUT%"

if %ERRORLEVEL% EQU 0 (
    goto :success
) else (
    goto :error
)

:success
cls
echo.
echo ============================================================================
echo                    Certification Complete!
echo ============================================================================
echo.
echo Your certified LPA has been saved to:
echo.
echo   %OUTPUT%
echo.
echo NEXT STEPS:
echo   1. Open the PDF and review the certification stamps
echo   2. Print the document
echo   3. The Fee Earner (%FEE_EARNER%) should sign each page in wet ink
echo      in the space provided after "Signed"
echo.
echo ============================================================================
echo.

REM Ask if user wants to open the file
set /p "OPEN_FILE=Open the certified PDF now? (Y/N): "
if /i "%OPEN_FILE%"=="Y" (
    start "" "%OUTPUT%"
)

echo.
pause
exit /b 0

:error
cls
echo.
echo ============================================================================
echo                    An Error Occurred
echo ============================================================================
echo.
echo There was a problem processing your LPA. Please check:
echo   - The input file is a valid PDF
echo   - The file is not open in another program
echo   - You have write permission in the folder
echo.
echo If the problem persists, please contact IT support.
echo.
pause
exit /b 1
