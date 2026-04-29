"""
Configuration loader for LPA Certified Copy Stamper.

Loads settings from config.json and provides easy access to office information
and application settings.
"""

import json
from pathlib import Path
from typing import Dict, Any

# Load configuration from config.json
CONFIG_FILE = Path(__file__).parent / "config.json"

def load_config() -> Dict[str, Any]:
    """Load configuration from config.json file."""
    try:
        with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        raise RuntimeError(f"Configuration file not found: {CONFIG_FILE}")
    except json.JSONDecodeError as e:
        raise RuntimeError(f"Invalid JSON in configuration file: {e}")

# Load configuration on module import
_config = load_config()

# Extract offices for easy access
OFFICES: Dict[str, str] = {
    key: office["address"] 
    for key, office in _config["offices"].items()
}

# Office display names
OFFICE_NAMES: Dict[str, str] = {
    key: office["name"] 
    for key, office in _config["offices"].items()
}

# Office data (full information)
OFFICE_DATA: Dict[str, Dict[str, str]] = _config["offices"]

# Application settings
APP_NAME: str = _config.get("app_name", "LPA Certified Copy Stamper")
VERSION: str = _config.get("version", "1.0.0")

# Default settings
DEFAULTS: Dict[str, Any] = _config.get("defaults", {})
DEFAULT_SCALE: float = DEFAULTS.get("scale", 0.90)
DEFAULT_FONT_SIZE: float = DEFAULTS.get("stamp_fontsize", 5)
DEFAULT_STAMP_WIDTH_RATIO: float = DEFAULTS.get("stamp_width_ratio", 0.35)
DEFAULT_STAMP_HEIGHT: float = DEFAULTS.get("stamp_height", 30)
DEFAULT_MARGIN_RIGHT: float = DEFAULTS.get("margin_right", 10)
DEFAULT_MARGIN_BOTTOM: float = DEFAULTS.get("margin_bottom", 25)

# Stamp text templates
STAMP_CONFIG: Dict[str, str] = _config.get("stamp", {})
SIGNED_DOTS: str = STAMP_CONFIG.get("signed_dots", "......................................")
TEXT_REGULAR: str = STAMP_CONFIG.get("text_regular", "")
TEXT_LAST_PAGE: str = STAMP_CONFIG.get("text_last_page", "")

# List of available office keys
AVAILABLE_OFFICES: list = list(OFFICES.keys())
