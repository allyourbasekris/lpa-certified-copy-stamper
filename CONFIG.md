# Configuration Guide - LPA Certified Copy Stamper

## Overview

The application uses a JSON configuration file (`config.json`) to store settings that may need to be changed without modifying the code.

---

## File Location

```
config.json
```

Must be in the same directory as `pdf_stamper.py` and `config.py`.

---

## Configuration Structure

### Offices Section

Add, remove, or modify office locations:

```json
"offices": {
  "darlington": {
    "name": "Darlington",
    "address": "BHP Law, Westgate House, Faverdale, Darlington, DL3 0PZ"
  },
  "durham": {
    "name": "Durham",
    "address": "BHP Law, Aire House, Mandale Business Park, Belmont, Durham, DH1 1TH"
  }
}
```

**To add a new office:**
1. Add a new entry with a unique key (e.g., "leeds")
2. Provide a display name and full address
3. The office picker will automatically include it
4. No code changes needed!

**To remove an office:**
1. Delete the office entry from the JSON
2. The office will no longer appear in the picker
3. No code changes needed!

### Defaults Section

Adjust default behavior:

```json
"defaults": {
  "scale": 0.90,                    // Content scaling (0.80-0.95 recommended)
  "stamp_fontsize": 5,              // Font size for stamp text
  "stamp_width_ratio": 0.35,        // Stamp width as % of page width
  "stamp_height": 30,               // Stamp box height in points
  "margin_right": 10,               // Right margin in points
  "margin_bottom": 25               // Bottom margin in points
}
```

**Common adjustments:**
- **More space for stamp**: Reduce `scale` to 0.85 or 0.80
- **Larger text**: Increase `stamp_fontsize` to 6 or 7
- **Wider stamp area**: Increase `stamp_width_ratio` to 0.40
- **Taller stamp box**: Increase `stamp_height` to 40 or 50

### Stamp Text Templates

Customize the certification text:

```json
"stamp": {
  "signed_dots": "......................................",
  "text_regular": "I, {fee_earner}, Solicitor, of {address}, certify...",
  "text_last_page": "I, {fee_earner}, Solicitor, of {address}, certify... and I further certify..."
}
```

**Available placeholders:**
- `{fee_earner}` - Solicitor name
- `{address}` - Office address
- `{date}` - Certification date
- `{signed_dots}` - Dotted line for signature

**Important:** Keep the placeholders in the text templates, or the stamp will not display correctly.

---

## Examples

### Example 1: Add a New Office (Leeds)

Edit `config.json`:

```json
"offices": {
  "darlington": {
    "name": "Darlington",
    "address": "BHP Law, Westgate House, Faverdale, Darlington, DL3 0PZ"
  },
  "leeds": {
    "name": "Leeds",
    "address": "BHP Law, 123 Wellington Street, Leeds, LS1 1AB"
  }
}
```

The office picker will now show 5 offices (was 4).

### Example 2: Change Default Scale

If users report text overlapping:

```json
"defaults": {
  "scale": 0.85
}
```

All new certifications will use 85% scale by default.

### Example 3: Customize Stamp Text

To add "For and on behalf of BHP Law" to the text:

```json
"text_regular": "I, {fee_earner}, Solicitor, for and on behalf of BHP Law, of {address}, certify that this is a true and complete copy..."
```

---

## Validation

After editing `config.json`, validate the JSON syntax:

### Option 1: Online Validator
Visit [jsonlint.com](https://jsonlint.com/) and paste your config.

### Option 2: Command Line
```bash
python -m json.tool config.json > /dev/null && echo "Valid JSON" || echo "Invalid JSON"
```

### Option 3: Test the Application
```bash
python pdf_stamper.py --help
```

If the config is invalid, you'll see an error like:
```
RuntimeError: Invalid JSON in configuration file: ...
```

---

## Backup

Before making changes:

```bash
cp config.json config.json.backup
```

To restore:
```bash
cp config.json.backup config.json
```

---

## Troubleshooting

### "Configuration file not found"

**Cause:** `config.json` is missing or not in the correct directory.

**Solution:** Ensure `config.json` is in the same folder as `pdf_stamper.py`.

### "Invalid JSON in configuration file"

**Cause:** Syntax error in the JSON file (missing comma, quote, bracket, etc.).

**Solution:** Use a JSON validator to find and fix the error.

### Office not appearing in picker

**Cause:** Office not properly added to the `offices` section.

**Solution:** 
1. Check the office key is unique
2. Ensure both "name" and "address" fields are present
3. Validate the JSON syntax

### Stamp text not displaying correctly

**Cause:** Missing or incorrect placeholders in text templates.

**Solution:** Ensure all placeholders are present:
- `{fee_earner}`
- `{address}`
- `{date}`
- `{signed_dots}`

---

## Version Control

When updating the configuration:

1. **Document changes** in a changelog or commit message
2. **Test thoroughly** with sample LPAs
3. **Notify users** if defaults change (especially scale or office list)
4. **Version the config** if making major changes

Example commit message:
```
config: Add Leeds office location
- Added new office entry for Leeds
- Updated office count from 4 to 5
- No breaking changes
```

---

## Support

For configuration issues or questions:
- **IT Department**: [Contact details]
- **Documentation**: See README_LPA_Stamper.md

---

**© 2026 BHP Law - Internal Use Only**
