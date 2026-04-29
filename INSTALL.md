# Installation Guide - LPA Certified Copy Stamper

## Quick Start (Windows)

### For End Users

If the tool has already been set up on your system:

1. Navigate to the installation folder
2. Double-click `stamp_lpa.bat`
3. Follow the on-screen wizard

**That's it!** You're ready to certify LPAs.

---

## First-Time Setup

### Prerequisites

- **Windows 10 or Windows 11**
- **Python 3.10 or later** (download from [python.org](https://www.python.org/downloads/))
- **Administrator rights** (for initial setup only)

### Installation Steps

#### Step 1: Install Python (if not already installed)

1. Go to https://www.python.org/downloads/
2. Download the latest Python 3.10+ installer
3. Run the installer
4. **IMPORTANT:** Check the box ☑️ **"Add Python to PATH"**
5. Click "Install Now"

#### Step 2: Set Up the Application

`stamp_lpa.bat` handles setup automatically on first run, but if you prefer to set it up manually:

1. Open File Explorer
2. Navigate to the folder containing the downloaded files
3. **Right-click** on `stamp_lpa.bat`
4. Select **"Run as administrator"**
5. Wait for the installation to complete (2-3 minutes). The script will:
   - Install Python if not present
   - Create a Python virtual environment
   - Install PyMuPDF and Click libraries
   - Verify the installation
6. Press any key to close the setup window

#### Step 3: Test the Installation

1. Double-click `stamp_lpa.bat`
2. The welcome screen should appear
3. Press `Ctrl+C` to cancel (it's working!)

---

## Installation for Multiple Users (Network Share)

### For IT Administrators

To deploy on a network share for multiple users:

#### Step 1: Choose a Location

Select a network share accessible by all users, e.g.:
```
S:\Shared\Tools\LPA_Stamper\
```

#### Step 2: Copy Files

Copy all repository files to the network location:
```
LPA_Stamper/
├── stamp_lpa.bat
├── README_LPA_Stamper.md
├── QUICKSTART.md
├── INSTALL.md
├── app/
│   ├── pdf_stamper.py
│   ├── config.py
│   ├── config.json
│   └── requirements.txt
└── docs/
    ├── CONFIG.md
    ├── REPO_README.md
    └── LICENSE
```

#### Step 3: Run Setup Once

1. Log in as a user with write permissions
2. Navigate to the network folder
3. **Right-click** on `stamp_lpa.bat`
4. Select **"Run as administrator"**
5. Wait for completion

**Note:** `stamp_lpa.bat` will automatically install Python (if needed), create the virtual environment inside the `app\` folder, and install dependencies.

#### Step 4: Test with Different User Accounts

Have 2-3 different users test the tool to ensure:
- They can run `stamp_lpa.bat`
- Output PDFs are created successfully
- No permission errors occur

#### Step 5: Create a Desktop Shortcut (Optional)

For easier access, create a shortcut on users' desktops:

1. Right-click on desktop → **New** → **Shortcut**
2. Enter location:
   ```
   S:\Shared\Tools\LPA_Stamper\stamp_lpa.bat
   ```
3. Name it: **LPA Certified Copy Stamper**
4. Click **Finish**

---

## Troubleshooting Installation

### "Python is not installed"

**Solution:** Install Python from [python.org](https://www.python.org/downloads/) and ensure you check "Add Python to PATH" during installation.

### "Access Denied" or "Permission Denied"

**Solution:** 
- Run `stamp_lpa.bat` as Administrator (right-click → Run as administrator)
- Ensure the folder has write permissions for all users

### "Virtual environment creation failed"

**Solution:**
1. Delete the `app\.venv` folder if it exists
2. Run `stamp_lpa.bat` again as Administrator
3. If it still fails, try manually:
   ```cmd
   python -m venv app/.venv
   app/.venv/Scripts/pip install -r app/requirements.txt
   ```

### "ModuleNotFoundError: No module named 'fitz'"

**Solution:**
```cmd
cd [installation_folder]
app\.venv\Scripts\activate
pip install --upgrade pymupdf
```

### "The code execution can't proceed - python310.dll is missing"

**Solution:** Python is not properly installed or not in PATH. Reinstall Python and restart your computer.

---

## Uninstallation

To remove the application:

1. Delete the entire installation folder
2. Remove any desktop shortcuts
3. (Optional) Remove Python if not needed for other applications

---

## Updating

To update to a newer version:

1. **Backup** your current installation folder
2. Download the new version files
3. Replace all files **except** `app\.venv\` folder
4. Run:
   ```cmd
   app\.venv\Scripts\pip install -r app\requirements.txt --upgrade
   ```

---

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Windows 10 | Windows 11 |
| Python | 3.10 | 3.12+ |
| RAM | 2 GB | 4 GB |
| Disk Space | 500 MB | 1 GB |
| Network | N/A | For network installations |

---

## Support

For installation issues, contact:
- **IT Helpdesk**: [Insert contact details]
- **Email**: [Insert email]
- **Phone**: [Insert phone number]

**Hours:** Monday-Friday, 9:00 AM - 5:00 PM

---

## Version Information

- **Current Version:** 1.0
- **Release Date:** April 2026
- **Python Compatibility:** 3.10 - 3.13
- **Last Updated:** April 2026
