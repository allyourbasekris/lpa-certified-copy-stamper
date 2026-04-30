"""
Pure stamp logic for LPA Certified Copy Stamper.

Computes stamp geometry, draws label backgrounds, and inserts text.
No direct CLI or PDF I/O — operates on fitz.Page objects passed in.
"""

import fitz

from config import (
    DEFAULT_FONT_SIZE,
    DEFAULT_STAMP_WIDTH_RATIO,
    DEFAULT_STAMP_HEIGHT,
    DEFAULT_MARGIN_RIGHT,
    DEFAULT_MARGIN_BOTTOM,
    STAMP_Y_OFFSET,
    SIGNED_DOTS,
    TEXT_REGULAR,
    TEXT_LAST_PAGE,
)


def get_stamp_text(fee_earner: str, address: str, date: str, *, is_last_page: bool = False) -> str:
    template = TEXT_LAST_PAGE if is_last_page else TEXT_REGULAR
    return template.format(
        fee_earner=fee_earner,
        address=address,
        date=date,
        signed_dots=SIGNED_DOTS,
    )


def calculate_stamp_rect(page: fitz.Page) -> fitz.Rect:
    stamp_width = page.rect.width * DEFAULT_STAMP_WIDTH_RATIO
    stamp_height = DEFAULT_STAMP_HEIGHT
    return fitz.Rect(
        page.rect.width - stamp_width - DEFAULT_MARGIN_RIGHT,
        page.rect.height - stamp_height - DEFAULT_MARGIN_BOTTOM - STAMP_Y_OFFSET,
        page.rect.width - DEFAULT_MARGIN_RIGHT,
        page.rect.height - DEFAULT_MARGIN_BOTTOM,
    )


def _draw_label(page: fitz.Page, rect: fitz.Rect) -> None:
    page.draw_rect(
        rect,
        color=(0.5, 0.5, 0.5),
        fill=(1, 1, 1),
        width=0.5,
        overlay=True,
    )


def render_stamp(page: fitz.Page, text: str) -> float:
    rect = calculate_stamp_rect(page)
    _draw_label(page, rect)
    return page.insert_textbox(
        rect,
        text,
        fontsize=DEFAULT_FONT_SIZE,
        fontname="helv",
        color=(0, 0, 0),
        align=fitz.TEXT_ALIGN_LEFT,
        overlay=True,
    )
