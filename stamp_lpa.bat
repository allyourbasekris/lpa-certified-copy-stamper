@echo off
REM ============================================================================
REM LPA Certified Copy Stamper
REM BHP Law - Quick Certification Tool
REM ============================================================================
REM This tool automatically adds solicitor certification stamps to all pages
REM of a scanned Lasting Power of Attorney (LPA) PDF.
REM
REM The stamp appears in the bottom right corner of each page, ready for
REM wet-ink signature by the Fee Earner.
REM ============================================================================

setlocal EnableDelayedExpansion

REM Configuration
set "SCRIPT_DIR=%~dp0"
set "VENV_PYTHON=%SCRIPT_DIR%pdf_stamper_env\Scripts\python.exe"
set "STAMPER_SCRIPT=%SCRIPT_DIR%pdf_stamper.py"

REM Check if virtual environment exists
if not exist "%VENV_PYTHON%" (
    echo.
    echo [ERROR] Virtual environment not found!
    echo.
    echo Please ensure the pdf_stamper_env folder exists in:
    echo %SCRIPT_DIR%
    echo.
    echo If you need to set up the environment, run:
    echo   python -m venv pdf_stamper_env
    echo   pdf_stamper_env\Scripts\pip install pymupdf click
    echo.
    pause
    exit /b 1
)

REM Check if input file was provided
if "%~1"=="" (
    goto :show_usage
)

REM Check if input file exists
if not exist "%~1" (
    echo.
    echo [ERROR] File not found: %~1
    echo.
    pause
    exit /b 1
)

set "INPUT_FILE=%~f1"
shift

REM Parse optional arguments
set "OFFICE=darlington"
set "FEE_EARNER="
set "OUTPUT="
set "DATE="
set "SCALE=0.90"

:parse_args
if "%~1"=="" goto :run_stamper
if /i "%~1"=="--office" (
    set "OFFICE=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="--fee-earner" (
    set "FEE_EARNER=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="-fe" (
    set "FEE_EARNER=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="--output" (
    set "OUTPUT=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="-o" (
    set "OUTPUT=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="--date" (
    set "DATE=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="-d" (
    set "DATE=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="--scale" (
    set "SCALE=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="-s" (
    set "SCALE=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="--help" (
    goto :show_usage
)
if /i "%~1"=="-h" (
    goto :show_usage
)
shift
goto :parse_args

:run_stamper
echo.
echo ============================================================================
echo  LPA Certified Copy Stamper
echo ============================================================================
echo.
echo Input File:     %INPUT_FILE%
echo Office:         %OFFICE%
echo Scale:          %SCALE%
if not "%FEE_EARNER%"=="" echo Fee Earner:      %FEE_EARNER%
if not "%DATE%"=="" echo Date:           %DATE%
if not "%OUTPUT%"=="" echo Output:          %OUTPUT%
echo.

REM Build the command
set "CMD=%VENV_PYTHON% "%STAMPER_SCRIPT%" "%INPUT_FILE%" --office %OFFICE% --scale %SCALE%"

if not "%FEE_EARNER%"=="" (
    set "CMD=!CMD! --fee-earner "%FEE_EARNER%""
)

if not "%DATE%"=="" (
    set "CMD=!CMD! --date "%DATE%""
)

if not "%OUTPUT%"=="" (
    set "CMD=!CMD! --output "%OUTPUT%""
)

echo Running certification...
echo.

REM Execute the stamper
%CMD%

echo.
if %ERRORLEVEL% EQU 0 (
    echo ============================================================================
    echo  Success! The certified PDF is ready for printing and wet-ink signature.
    echo ============================================================================
) else (
    echo ============================================================================
    echo  An error occurred. Please check the messages above.
    echo ============================================================================
)

echo.
pause
exit /b %ERRORLEVEL%

:show_usage
echo.
echo ============================================================================
echo  LPA Certified Copy Stamper - BHP Law
echo ============================================================================
echo.
echo Adds solicitor certification stamps to all pages of a scanned LPA PDF.
echo The stamp appears in the bottom right corner, ready for wet-ink signature.
echo.
echo USAGE:
echo   stamp_lpa.bat ^<input.pdf^> [options]
echo.
echo REQUIRED:
echo   input.pdf              Path to the scanned LPA PDF file
echo.
echo OPTIONS:
echo   --office ^<name^>        Office location (default: darlington)
echo                            Choices: darlington, durham, newcastle, 
echo                                     tynemouth
echo.
echo   --fee-earner ^<name^>    Solicitor name (prompts if not provided)
echo   -fe ^<name^>             Short form of --fee-earner
echo.
echo   --output ^<path^>        Output file path (default: ^<input^>_certified.pdf)
echo   -o ^<path^>              Short form of --output
echo.
echo   --date ^<DD/MM/YYYY^>    Certification date (default: today)
echo   -d ^<DD/MM/YYYY^>        Short form of --date
echo.
echo   --scale ^<0.80-0.95^>    Content scale (default: 0.90)
echo   -s ^<0.80-0.95^>         Lower = more space for stamp
echo.
echo   --help, -h               Show this help message
echo.
echo EXAMPLES:
echo   stamp_lpa.bat client_lpa.pdf --office darlington
echo.
echo   stamp_lpa.bat client_lpa.pdf -fe "John Smith" -o certified.pdf
echo.
echo   stamp_lpa.bat client_lpa.pdf --office newcastle --date "29/04/2026"
echo.
echo ============================================================================
echo.
pause
exit /b 0
