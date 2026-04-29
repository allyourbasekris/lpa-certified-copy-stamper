@echo off
REM ============================================================================
REM LPA Certified Copy Stamper - Setup Script
REM BHP Law - First-Time Installation
REM ============================================================================
REM Run this script once to set up the Python environment and install
REM required dependencies.
REM ============================================================================

setlocal EnableDelayedExpansion

echo.
echo ============================================================================
echo        LPA Certified Copy Stamper - Setup
echo ============================================================================
echo.
echo This script will set up the Python environment and install required
echo libraries for the LPA certification tool.
echo.
echo This only needs to be run once.
echo.
pause

REM Check if Python is installed
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Python is not installed or not in PATH.
    echo.
    echo Please install Python 3.10 or later from:
    echo   https://www.python.org/downloads/
    echo.
    echo During installation, make sure to check:
    echo   [✓] Add Python to PATH
    echo.
    pause
    exit /b 1
)

echo.
echo Python found! Creating virtual environment...
echo.

REM Create virtual environment
python -m venv pdf_stamper_env

if not exist "pdf_stamper_env\Scripts\activate.bat" (
    echo.
    echo [ERROR] Failed to create virtual environment.
    echo Please ensure you have Python 3.10+ installed.
    echo.
    pause
    exit /b 1
)

echo.
echo Virtual environment created successfully!
echo.
echo Installing required libraries (PyMuPDF and Click)...
echo.

REM Install dependencies
call pdf_stamper_env\Scripts\activate.bat
pip install --upgrade pip
pip install pymupdf click

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Failed to install dependencies.
    echo Please check your internet connection and try again.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================================
echo                    Setup Complete!
echo ============================================================================
echo.
echo The LPA Certified Copy Stamper is now ready to use.
echo.
echo To get started:
echo   1. Double-click stamp_lpa_easy.bat for the interactive wizard
echo   2. Or drag a PDF onto stamp_lpa.bat
echo.
echo For more information, see README_LPA_Stamper.md
echo.
pause

REM Open the README
if exist "README_LPA_Stamper.md" (
    start "" "README_LPA_Stamper.md"
)

exit /b 0
