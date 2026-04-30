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

from datetime import datetime
from pathlib import Path

import click

from config import (
    OFFICES,
    OFFICE_NAMES,
    AVAILABLE_OFFICES,
    DEFAULT_SCALE,
)
from pdf_handler import open_pdf, create_output_doc, add_blank_page, copy_scaled_content, save_pdf
from stamp import get_stamp_text, render_stamp


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
                click.echo(f"Selected: {OFFICE_NAMES[selected]}")
                return selected
            else:
                click.echo("Invalid choice. Please enter a number between 1 and {}.".format(len(offices_list)))
        except ValueError:
            click.echo("Invalid input. Please enter a number.")


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

    src_doc = open_pdf(input_pdf)

    if office is None:
        office = prompt_office()

    address = OFFICES[office.lower()]

    dst_doc = create_output_doc()
    page_count = src_doc.page_count
    last_page_idx = page_count - 1

    overflow = False
    for page_num in range(page_count):
        is_last = page_num == last_page_idx
        text = get_stamp_text(fee_earner, address, date, is_last_page=is_last)

        src_page = src_doc[page_num]
        new_page = add_blank_page(dst_doc, src_page)

        copy_scaled_content(new_page, src_doc, page_num, scale)
        unused = render_stamp(new_page, text)

        if unused < 0:
            overflow = True
            click.echo(
                f"WARNING: Page {page_num + 1} stamp overflowed by {-unused:.1f} points – "
                "text may be clipped. Try a shorter name or a smaller --scale.",
                err=True,
            )

    save_pdf(dst_doc, output)
    click.echo(f"Saved certified copy to: {output.resolve()}")
    if overflow:
        click.echo("Some stamps were too long to fit. Review the output before signing.", err=True)

    src_doc.close()
    dst_doc.close()


if __name__ == "__main__":
    stamp()
