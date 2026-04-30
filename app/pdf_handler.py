"""
PDF I/O layer for LPA Certified Copy Stamper.

Handles opening, saving, and page creation for PDF documents,
isolating PyMuPDF calls from the stamping logic.
"""

import sys
from pathlib import Path

import click
import fitz


def open_pdf(path: Path) -> fitz.Document:
    try:
        return fitz.open(str(path))
    except Exception as e:
        click.echo(f"ERROR: Could not open PDF: {e}", err=True)
        sys.exit(1)


def create_output_doc() -> fitz.Document:
    return fitz.open()


def add_blank_page(dst_doc: fitz.Document, src_page: fitz.Page) -> fitz.Page:
    return dst_doc.new_page(width=src_page.rect.width, height=src_page.rect.height)


def copy_scaled_content(
    new_page: fitz.Page,
    src_doc: fitz.Document,
    src_page_num: int,
    scale: float,
) -> None:
    src_page = src_doc[src_page_num]
    src_page.remove_rotation()
    w = src_page.rect.width * scale
    h = src_page.rect.height * scale
    content_rect = fitz.Rect(0, 0, w, h)
    new_page.show_pdf_page(content_rect, src_doc, src_page_num, overlay=False)


def save_pdf(doc: fitz.Document, path: Path) -> None:
    try:
        doc.save(str(path), garbage=4, deflate=True)
    except Exception as e:
        click.echo(f"ERROR: Could not save PDF: {e}", err=True)
        sys.exit(1)
