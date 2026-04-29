# LPA Certified Copy Stamper

**Automated PDF certification tool for Lasting Power of Attorney documents**

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Python](https://img.shields.io/badge/python-3.10+-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-Proprietary-red.svg)

---

## 📖 Overview

A Python-based CLI tool that automatically adds solicitor certification stamps to every page of scanned Lasting Power of Attorney (LPA) PDFs. Designed for BHP Law to streamline the certified copy workflow.

### Key Features

- ✅ **Automated stamping** - No more manual stamping of each page
- ✅ **Smart positioning** - Bottom right corner, avoids OPG official stamp
- ✅ **White background** - Ensures readability over any scanned content
- ✅ **Auto-date** - Pre-populates today's date
- ✅ **Multi-office support** - 4 BHP Law office locations
- ✅ **Last page detection** - Applies extended certification text
- ✅ **Professional output** - Clean, consistent, ready for wet-ink signature

### Time Savings

| Task | Manual | Automated |
|------|--------|-----------|
| **Per LPA (20 pages)** | 10-15 minutes | 30 seconds |
| **Per week (20 LPAs)** | 3-5 hours | 10 minutes |
| **Time saved** | - | **95%** ⏱️ |

---

## 🚀 Quick Start

### For End Users

1. **Launch the wizard:**
   ```batch
   stamp_lpa.bat
   ```

2. **Follow the 4-step wizard** to certify your LPA

`stamp_lpa.bat` handles Python installation, virtual environment creation, and dependency installation automatically on first run.

### For Developers

```bash
# Clone the repository
git clone <repository-url>
cd lpa-certified-copy-stamper

# Create virtual environment
python -m venv app/.venv
app/.venv/Scripts/activate

# Install dependencies
pip install -r app/requirements.txt

# Run the tool
python app/pdf_stamper.py input.pdf --fee-earner "John Smith" --office darlington
```

---

## 📁 Repository Structure

```
lpa-certified-copy-stamper/
├── stamp_lpa.bat              # Windows launcher (wizard + CLI passthrough)
├── README_LPA_Stamper.md      # User documentation
├── QUICKSTART.md              # Quick start guide
├── INSTALL.md                 # Installation guide
├── app/                         # Application code
│   ├── pdf_stamper.py
│   ├── config.py
│   ├── config.json
│   └── requirements.txt
└── docs/                        # Documentation
    ├── CONFIG.md
    ├── REPO_README.md
    └── LICENSE
```

---

## 💻 Usage Examples

### Interactive Wizard (Recommended)
```batch
stamp_lpa.bat
```

### Command Line
```batch
# Basic usage
stamp_lpa.bat client_lpa.pdf --office darlington

# All options
stamp_lpa.bat client_lpa.pdf \
    --fee-earner "Jane Doe" \
    --office newcastle \
    --date "29/04/2026" \
    -o certified_copy.pdf

# Adjust scale for more space
stamp_lpa.bat client_lpa.pdf --office darlington --scale 0.85
```

### Python API
```python
from pathlib import Path
import fitz  # PyMuPDF

# See pdf_stamper.py for implementation details
# The tool can be imported as a module
```

---

## 🏢 Office Locations

| Office | Address |
|--------|---------|
| **Darlington** | BHP Law, Westgate House, Faverdale, Darlington, DL3 0PZ |
| **Durham** | BHP Law, Aire House, Mandale Business Park, Belmont, Durham, DH1 1TH |
| **Newcastle** | BHP Law, Suite 307, Collingwood Buildings, 38 Collingwood Street, Newcastle upon Tyne, NE1 1JF |
| **Tynemouth** | BHP Law, 39 Percy Park Road, Tynemouth, North Shields, NE30 4LR |

---

## 🔧 Technical Details

### How It Works

1. **Scale** the original PDF to 90% (pinned top-left)
2. **Create** a white background box in the bottom right corner
3. **Apply** certification text with auto-populated date
4. **Preserve** all original content without overlap
5. **Output** a new PDF with `_certified` suffix

### Dependencies

- **Python 3.10+**
- **PyMuPDF** (fitz) - PDF manipulation
- **Click** - Command-line interface

### System Requirements

- Windows 10/11
- Python 3.10 or later
- 500 MB disk space
- 2 GB RAM minimum

---

## 📝 Certification Text Format

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

## 🧪 Testing

### Test with Sample LPA
```bash
# Download sample LPA from GOV.UK
curl -o sample_lpa.pdf "https://assets.publishing.service.gov.uk/media/5a8202e440f0b6230269a5d0/LP1F-Create-and-register-your-lasting-power-of-attorney.pdf"

# Run the stamper
python app/pdf_stamper.py sample_lpa.pdf --fee-earner "Test User" --office darlington

# Check output
ls -la sample_lpa_certified.pdf
```

---

## 🤝 Contributing

This is an internal BHP Law tool. For contributions or feature requests:

1. Contact the IT Department
2. Submit a feature request form
3. Wait for approval before making changes

---

## 📄 License

**Proprietary - BHP Law Internal Use Only**

See [LICENSE](LICENSE) file for full terms.

---

## 🆘 Support

- **Documentation:** See `README_LPA_Stamper.md` and `INSTALL.md`
- **Quick Start:** See `QUICKSTART.md`
- **IT Helpdesk:** [Insert contact details]
- **Email:** [Insert email]
- **Phone:** [Insert phone number]

---

## 📅 Version History

### v1.0.0 (April 2026)
- Initial release
- Bottom right corner stamp placement
- Support for all 4 BHP Law offices
- Auto-populated date
- Interactive wizard
- White background for readability
- Last page detection
- Overflow warnings

---

## 🔮 Future Enhancements

- [ ] Batch processing for multiple LPAs
- [ ] GUI application
- [ ] Custom stamp text templates
- [ ] Email integration
- [ ] Audit logging
- [ ] Digital signature support
- [ ] macOS/Linux support

---

**© 2026 BHP Law. All Rights Reserved.**
