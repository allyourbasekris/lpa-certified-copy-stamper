@echo off
REM ============================================================================
REM LPA Certified Copy Stamper - Easy Mode
REM BHP Law - Interactive Wizard
REM ============================================================================
REM This wizard guides you through certifying an LPA step-by-step.
REM ============================================================================

setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "VENV_PYTHON=%SCRIPT_DIR%pdf_stamper_env\Scripts\python.exe"
set "STAMPER_SCRIPT=%SCRIPT_DIR%pdf_stamper.py"

REM Check prerequisites
if not exist "%VENV_PYTHON%" (
    echo.
    echo [ERROR] Virtual environment not found!
    echo Please contact IT to set up the pdf_stamper_env folder.
    pause
    exit /b 1
)

:welcome
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
%VENV_PYTHON% "%STAMPER_SCRIPT%" "%INPUT_FILE%" --fee-earner "%FEE_EARNER%" --office %OFFICE% --output "%OUTPUT%"

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
