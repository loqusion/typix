"""
Checks if emoji characters in a PDF file are rendered with an appropriate font face.

This script is dumb, and only checks if the font face name for text with an
emoji matches one of a set of patterns given on the command line. This
assumption is naive, and may not hold if the font names change, or if a font
name not supporting emoji happens to match any of the patterns.
"""

import re
import sys
from collections.abc import Iterator
from dataclasses import dataclass
from typing import Final

import emoji
import pdfplumber


@dataclass
class TextElement:
    text: str
    font: str


class InvalidEmojiFontException(Exception):
    def __init__(self, text_element: TextElement, font_patterns: list[re.Pattern]):
        self.text_element = text_element
        self.font_patterns = font_patterns
        self.message = (
            f'Detected invalid font for text containing emoji character: "{text_element.text}"\n'
            f'Font: "{text_element.font}"\n'
            f"Font did not match any of the following patterns: {', '.join((f"'{pat.pattern}'" for pat in font_patterns))}"
        )
        super().__init__(self.message)


class PDFChecker:
    pdf_path: str

    def __init__(self, pdf_path: str):
        self.pdf_path = pdf_path

    def check_emojis(self, font_patterns: list[re.Pattern]):
        text_elements = self._extract_text_elements()

        for text_element in text_elements:
            if emoji.emoji_count(text_element.text) == 0:
                continue

            if not any(pat.search(text_element.font) for pat in font_patterns):
                raise InvalidEmojiFontException(text_element, font_patterns)

    def _extract_text_elements(self) -> Iterator[TextElement]:
        with pdfplumber.open(self.pdf_path) as pdf:
            for page in pdf.pages:
                words = page.extract_words(
                    keep_blank_chars=True,
                    use_text_flow=True,
                    extra_attrs=["fontname"],
                )

                for word in words:
                    yield TextElement(
                        text=word["text"],
                        font=word["fontname"],
                    )


class InvalidArgumentException(Exception):
    USAGE: Final = f"usage: {sys.argv[0]} <pdf_path> <pattern> [<pattern>...]"

    def __init__(self, message: str):
        self.message = message + "\n" + InvalidArgumentException.USAGE
        super().__init__(self.message)


def main():
    pdf_path = sys.argv[1]
    checker = PDFChecker(pdf_path)

    font_patterns = list(map(lambda pat: re.compile(pat, re.IGNORECASE), sys.argv[2:]))
    if len(font_patterns) == 0:
        raise InvalidArgumentException(
            "expected one or more patterns given as arguments"
        )

    checker.check_emojis(font_patterns)


if __name__ == "__main__":
    try:
        main()
    except InvalidEmojiFontException as err:
        print(f"test failed: {err}", file=sys.stderr)
        sys.exit(1)
    except InvalidArgumentException as err:
        print(f"error: {err}", file=sys.stderr)
        sys.exit(2)
    except Exception:
        raise
