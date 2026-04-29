# LPA Certified Copy Stamper - BHP Law

**Automated certification tool for Lasting Power of Attorney (LPA) documents**

---

## Overview

This tool automatically adds solicitor certification stamps to **every page** of a scanned LPA PDF. It saves your team significant time by:

- ✅ Eliminating manual stamping of each page
- ✅ Ensuring consistent, professional placement
- ✅ Auto-populating the date
- ✅ Creating space for wet-ink signatures
- ✅ Supporting all BHP Law office locations

---

## Quick Start

### For Windows Users (Recommended)

**Double-click** `stamp_lpa_easy.bat` and follow the on-screen wizard.

The wizard will guide you through:
1. Selecting the scanned LPA PDF
2. Choosing your office location
3. Entering the Fee Earner name
4. Confirming and processing

### For Advanced Users

**Drag and drop** a PDF onto `stamp_lpa.bat`, or use from command line:

```batch
stamp_lpa.bat client_lpa.pdf --office darlington --fee-earner "John Smith"
```

---

## Certification Stamp Format

### Standard Pages
```
I, [Fee Earner], Solicitor, of [Office Address], certify that this is a true 
and complete copy of the corresponding page of the original Lasting Power of 
Attorney. Signed ...................................... Dated: DD/MM/YYYY
```

### Last Page
```
I, [Fee Earner], Solicitor, of [Office Address], certify that this is a true 
and complete copy of the corresponding page of the original Lasting Power of 
Attorney and I further certify that this is a true and complete copy of the 
Lasting Power of Attorney. Signed ...................................... 
Dated: DD/MM/YYYY
```

---

## Office Locations

| Option | Office | Address |
|--------|--------|---------|
| 1 | **Darlington** | BHP Law, Westgate House, Faverdale, Darlington, DL3 0PZ |
| 2 | **Durham** | BHP Law, Aire House, Mandale Business Park, Belmont, Durham, DH1 1TH |
| 3 | **Newcastle** | BHP Law, Suite 307, Collingwood Buildings, 38 Collingwood Street, Newcastle upon Tyne, NE1 1JF |
| 4 | **Tynemouth** | BHP Law, 39 Percy Park Road, Tynemouth, North Shields, NE30 4LR |

---

## Workflow

### Step 1: Scan the LPA
- Scan the registered LPA (returned from OPG with official stamp)
- Save as PDF
- Ensure all pages are included (minimum 15+ pages)

### Step 2: Run the Stamper
- Double-click `stamp_lpa_easy.bat`
- Follow the wizard prompts
- Wait for processing (usually 5-10 seconds)

### Step 3: Review & Print
- Open the certified PDF (automatically offered)
- Verify stamps appear in bottom right corner of each page
- Print the document

### Step 4: Wet-Ink Signature
- Fee Earner signs each page in the space after "Signed"
- Use black or blue pen
- Add date if not pre-populated

### Step 5: Send to Client
- Scan the signed certified copy (optional)
- Send to client via post or email

---

## Command Line Options

| Option | Short | Description |
|--------|-------|-------------|
| `--office <name>` | | Office: darlington, durham, newcastle, stockton, tynemouth |
| `--fee-earner "Name"` | `-fe` | Solicitor name (prompts if not provided) |
| `--output <path>` | `-o` | Output filename (default: `<input>_certified.pdf`) |
| `--date "DD/MM/YYYY"` | `-d` | Certification date (default: today) |
| `--scale <0.80-0.95>` | `-s` | Content scale (default: 0.90) |
| `--help` | `-h` | Show help message |

### Examples

**Basic usage (interactive prompts):**
```batch
stamp_lpa.bat client_lpa.pdf --office darlington
```

**Fully automated:**
```batch
stamp_lpa.bat client_lpa.pdf --fee-earner "Lucy Brown" --office newcastle -o certified.pdf
```

**Custom date:**
```batch
stamp_lpa.bat client_lpa.pdf --office darlington --date "29/04/2026"
```

**Adjust scale for more space:**
```batch
stamp_lpa.bat client_lpa.pdf --office darlington --scale 0.85
```

---

## Technical Details

### How It Works
1. **Scales** the original PDF to 90% size (pinned top-left)
2. **Creates** a white background box in the bottom right corner
3. **Applies** the certification text with today's date
4. **Preserves** all original content without overlap
5. **Outputs** a new PDF with `_certified` suffix

### System Requirements
- Windows 10/11
- Python 3.10+ (included in virtual environment)
- PyMuPDF and Click libraries (pre-installed)

### File Locations
```
/home/kris/
├── pdf_stamper.py              # Main script
├── stamp_lpa.bat               # Command-line tool
├── stamp_lpa_easy.bat          # Interactive wizard
├── pdf_stamper_env/            # Python virtual environment
└── README_LPA_Stamper.md       # This file
```

---

## Troubleshooting

### "Virtual environment not found"
Ensure the `pdf_stamper_env` folder exists. If missing, contact IT support.

### "File not found"
Check that:
- The PDF file path is correct
- The file is not open in another program
- You have read access to the file

### Text appears clipped or cut off
Try reducing the scale:
```batch
stamp_lpa.bat client_lpa.pdf --office darlington --scale 0.85
```

### Stamp overlaps existing content
The default 90% scale should prevent overlap. If issues persist:
- Try `--scale 0.85` or lower
- Contact IT to adjust positioning

---

## Support

For technical issues or questions, please contact:
- **IT Support**: [Your IT contact details]
- **Training**: [Your training contact details]

---

## Version History

- **v1.0** (April 2026) - Initial release
  - Bottom right corner stamp placement
  - Support for all 5 BHP Law offices
  - Auto-populated date
  - Interactive wizard for easy use

---

**© 2026 BHP Law - Internal Use Only**
