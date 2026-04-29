#!/usr/bin/env python3
"""
LPA Certified Copy Stamper CLI

Scales each page of a scanned LPA to 90% (pinned top-left) to create clear space,
then applies a solicitor certification stamp in the bottom right corner of each page.
The stamp is placed horizontally for easy reading and wet-ink signing.

The white background box ensures the stamp is readable over any scanned content,
and the positioning avoids the OPG's official stamp area at the bottom of the first page.

Usage:
    python pdf_stamper.py input.pdf --fee-earner "John Smith" --office darlington
    python pdf_stamper.py input.pdf --fee-earner "Jane Doe" --office newcastle --scale 0.92
"""

import sys
from datetime import datetime
from pathlib import Path

import click
import fitz  # PyMuPDF

# Load configuration
from config import (
    OFFICES,
    OFFICE_NAMES,
    AVAILABLE_OFFICES,
    DEFAULT_SCALE,
    DEFAULT_FONT_SIZE,
    DEFAULT_STAMP_WIDTH_RATIO,
    DEFAULT_STAMP_HEIGHT,
    DEFAULT_MARGIN_RIGHT,
    DEFAULT_MARGIN_BOTTOM,
    SIGNED_DOTS,
    TEXT_REGULAR,
    TEXT_LAST_PAGE,
)

# ---------------------------------------------------------------------------
# Text templates
# ---------------------------------------------------------------------------
def get_stamp_text(fee_earner: str, address: str, date: str, *, is_last_page: bool = False) -> str:
    """Generate the certification text for the stamp.
    
    Args:
        fee_earner: Name of the solicitor (Fee Earner)
        address: Full office address
        date: Certification date in DD/MM/YYYY format
        is_last_page: If True, includes the additional certification for the full LPA
    
    Returns:
        Formatted certification text
    """
    template = TEXT_LAST_PAGE if is_last_page else TEXT_REGULAR
    return template.format(
        fee_earner=fee_earner,
        address=address,
        date=date,
        signed_dots=SIGNED_DOTS
    )


# ---------------------------------------------------------------------------
# Stamping logic
# ---------------------------------------------------------------------------
def _draw_label(page: fitz.Page, rect: fitz.Rect) -> None:
    """Draw a white label background so the stamp is readable over scans."""
    page.draw_rect(
        rect,
        color=(0.5, 0.5, 0.5),   # gray border for visibility
        fill=(1, 1, 1),          # white fill to mask underlying content
        width=0.5,
        overlay=True,
    )


def stamp_page_bottom_right(
    new_page: fitz.Page,
    src_doc: fitz.Document,
    src_page_num: int,
    text: str,
    scale: float = None,
) -> float:
    """
    Scale the original page content to *scale* (pinned top-left) on *new_page*,
    then draw the certification stamp in the bottom right corner margin.
    
    The stamp is placed horizontally in the bottom right, making it easy to read
    and sign. The scaled content leaves clear space at the right and bottom edges
    to avoid overlapping any existing content including the OPG official stamp.
    """
    # Use default scale if not provided
    if scale is None:
        scale = DEFAULT_SCALE
    
    src_page = src_doc[src_page_num]
    # Normalise rotation so scaling is predictable
    src_page.remove_rotation()

    # Place scaled content in the top-left corner
    w = src_page.rect.width * scale
    h = src_page.rect.height * scale
    content_rect = fitz.Rect(0, 0, w, h)
    new_page.show_pdf_page(content_rect, src_doc, src_page_num, overlay=False)

    # Stamp lives in the bottom right corner, well clear of the scaled content
    # and the OPG official stamp area (which appears at the very bottom)
    stamp_width = new_page.rect.width * DEFAULT_STAMP_WIDTH_RATIO
    stamp_height = DEFAULT_STAMP_HEIGHT
    
    stamp_rect = fitz.Rect(
        new_page.rect.width - stamp_width - DEFAULT_MARGIN_RIGHT,
        new_page.rect.height - stamp_height - DEFAULT_MARGIN_BOTTOM - 10,
        new_page.rect.width - DEFAULT_MARGIN_RIGHT,
        new_page.rect.height - DEFAULT_MARGIN_BOTTOM
    )

    _draw_label(new_page, stamp_rect)
    unused = new_page.insert_textbox(
        stamp_rect,
        text,
        fontsize=DEFAULT_FONT_SIZE,
        fontname="helv",
        color=(0, 0, 0),
        align=fitz.TEXT_ALIGN_LEFT,
        overlay=True,
    )
    return unused


def prompt_office() -> str:
    """Display an interactive office picker and return the selected office key."""
    click.echo()
    click.echo("=" * 60)
    click.echo("  Select Office Location")
    click.echo("=" * 60)
    click.echo()
    
    offices_list = AVAILABLE_OFFICES
    for i, office_key in enumerate(offices_list, 1):
        display_name = OFFICE_NAMES[office_key]
        address = OFFICES[office_key]
        click.echo(f"  {i}. {display_name}")
        click.echo(f"     {address}")
        click.echo()
    
    while True:
        choice = click.prompt("Enter choice (1-{})".format(len(offices_list)), type=str)
        try:
            idx = int(choice) - 1
            if 0 <= idx < len(offices_list):
                selected = offices_list[idx]
                click.echo()
                click.echo(f"✓ Selected: {OFFICE_NAMES[selected]}")
                return selected
            else:
                click.echo("Invalid choice. Please enter a number between 1 and {}.".format(len(offices_list)))
        except ValueError:
            click.echo("Invalid input. Please enter a number.")



# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
@click.command()
@click.argument(
    "input_pdf",
    type=click.Path(exists=True, dir_okay=False, path_type=Path),
)
@click.option(
    "--output", "-o",
    type=click.Path(dir_okay=False, path_type=Path),
    help="Output PDF path. Defaults to <input>_certified.pdf",
)
@click.option(
    "--fee-earner", "-fe",
    required=True,
    prompt="Solicitor (Fee Earner) name",
    help="Name of the solicitor who will sign the certification stamp",
)
@click.option(
    "--office",
    type=click.Choice(AVAILABLE_OFFICES, case_sensitive=False),
    default=None,
    help="Office location (prompts if not provided). Choices: " + ", ".join(AVAILABLE_OFFICES),
)
@click.option(
    "--date", "-d",
    default=lambda: datetime.now().strftime("%d/%m/%Y"),
    show_default="today",
    help="Certification date in DD/MM/YYYY format",
)
@click.option(
    "--scale", "-s",
    type=float,
    default=DEFAULT_SCALE,
    show_default=True,
    help=(
        "Scale the original page content by this factor (pinned top-left). "
        "The freed space at the bottom right is used for the certification stamp. "
        "Lower values create more space but reduce content size."
    ),
)

def stamp(input_pdf: Path, output: Path | None, fee_earner: str, office: str | None, date: str, scale: float) -> None:
    """Apply a solicitor certification stamp to every page of an LPA PDF."""
    if output is None:
        output = input_pdf.with_stem(f"{input_pdf.stem}_certified")

    try:
        src_doc = fitz.open(str(input_pdf))
    except Exception as e:
        click.echo(f"ERROR: Could not open PDF: {e}", err=True)
        sys.exit(1)

    # If office not provided, prompt the user
    if office is None:
        office = prompt_office()
    
    address = OFFICES[office.lower()]

    dst_doc = fitz.open()
    page_count = src_doc.page_count
    last_page_idx = page_count - 1

    overflow = False
    for page_num in range(page_count):
        is_last = page_num == last_page_idx
        text = get_stamp_text(fee_earner, address, date, is_last_page=is_last)

        # Create a new blank page with the same dimensions as the original
        src_page = src_doc[page_num]
        new_page = dst_doc.new_page(width=src_page.rect.width, height=src_page.rect.height)

        unused = stamp_page_bottom_right(new_page, src_doc, page_num, text, scale=scale)

        if unused < 0:
            overflow = True
            click.echo(
                f"WARNING: Page {page_num + 1} stamp overflowed by {-unused:.1f} points – "
                "text may be clipped. Try a shorter name or a smaller --scale.",
                err=True,
            )

    try:
        dst_doc.save(str(output), garbage=4, deflate=True)
        click.echo(f"✅ Saved certified copy to: {output.resolve()}")
        if overflow:
            click.echo("⚠️  Some stamps were too long to fit. Review the output before signing.", err=True)
    except Exception as e:
        click.echo(f"ERROR: Could not save PDF: {e}", err=True)
        sys.exit(1)
    finally:
        src_doc.close()
        dst_doc.close()


if __name__ == "__main__":
    stamp()
