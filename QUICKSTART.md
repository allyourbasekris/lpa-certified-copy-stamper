# Quick Start Guide - LPA Certified Copy Stamper

**Get started in 60 seconds!**

---

## 🚀 How to Certify an LPA

### Step 1: Open the Tool
**Double-click** `stamp_lpa_easy.bat`

![Step 1](https://via.placeholder.com/600x200?text=Double-click+stamp_lpa_easy.bat)

---

### Step 2: Select Your PDF
**Drag and drop** your scanned LPA PDF into the window, or type the file path.

![Step 2](https://via.placeholder.com/600x200?text=Drag+%26+Drop+your+LPA+PDF)

---

### Step 3: Choose Your Office
Select your office from the list:
- **1** = Darlington
- **2** = Durham
- **3** = Newcastle
- **4** = Tynemouth

Press **Enter** (default is Darlington).

![Step 3](https://via.placeholder.com/600x200?text=Select+your+office+1-5)

---

### Step 4: Enter Fee Earner Name
Type the solicitor's name who will sign the certificates.

**Example:** `John Smith`

![Step 4](https://via.placeholder.com/600x200?text=Enter+Fee+Earner+name)

---

### Step 5: Confirm
Review the settings and press **Y** to proceed.

![Step 5](https://via.placeholder.com/600x200?text=Confirm+settings)

---

### Step 6: Done! ✅
The tool will process your LPA (5-10 seconds).

**Choose Y** to open the certified PDF and review it.

![Step 6](https://via.placeholder.com/600x200?text=Success!+Open+PDF?)

---

## 📋 What Happens Next?

1. **Review** the certified PDF
   - Check that stamps appear on all pages (bottom right corner)
   - Verify the Fee Earner name and office address are correct

2. **Print** the document
   - Use A4 paper
   - Print all pages

3. **Sign** each page
   - Fee Earner signs in wet ink after "Signed"
   - Use black or blue pen
   - Add date if not pre-populated

4. **Send** to client
   - Post or email the certified copy

---

## ⚡ Quick Commands (Advanced Users)

### Basic Usage
```batch
stamp_lpa.bat my_lpa.pdf --office darlington
```

### All Options at Once
```batch
stamp_lpa.bat my_lpa.pdf --fee-earner "Jane Doe" --office newcastle -o certified.pdf
```

### Custom Date
```batch
stamp_lpa.bat my_lpa.pdf --office darlington --date "29/04/2026"
```

---

## ❓ Common Questions

### Q: Where is the output file saved?
**A:** In the same folder as your input PDF, with `_certified` added to the filename.
```
Input:  client_lpa.pdf
Output: client_lpa_certified.pdf
```

### Q: Can I change the date?
**A:** Yes! Use `--date "DD/MM/YYYY"` or the date will default to today.

### Q: The stamp overlaps existing content
**A:** Use a smaller scale: `--scale 0.85`

### Q: Can I batch process multiple LPAs?
**A:** Not yet. Process one at a time for now.

### Q: Do I need to install anything?
**A:** Only once! Run `setup.bat` on first use (see INSTALL.md).

---

## 🆘 Need Help?

- **Full Documentation:** See `README_LPA_Stamper.md`
- **Installation Guide:** See `INSTALL.md`
- **IT Support:** Contact [Your IT Helpdesk]

---

## 📞 Quick Reference Card

| Task | Action |
|------|--------|
| **Start tool** | Double-click `stamp_lpa_easy.bat` |
| **Select PDF** | Drag & drop or type path |
| **Choose office** | Press 1-5 |
| **Enter name** | Type Fee Earner name |
| **Confirm** | Press Y |
| **Open result** | Press Y when prompted |
| **Cancel** | Press N at any step |

---

**💡 Tip:** Keep this guide handy for the first few uses!

---

**© 2026 BHP Law - Internal Use Only**
