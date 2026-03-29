#!/usr/bin/env python3
import argparse
import re


# returns a lowercase string with symbols, leading, and trailing spaces removed
def normalise_text(text: str) -> str:
    text = text.casefold()
    text = text.strip()
    text = re.sub(r"[^a-z0-9\s]", "", text)
    return text


########################
## this is the result ##
########################
def comment_block(text: str):
    text = normalise_text(text)
    width = len(text) + 6  # six for the four # and two " " on either side of the text
    border = "#" * width
    middle = f"## {text} ##"
    print("\n".join([border, middle, border]))


if __name__ == "__main__":  # pragma: no cover
    parser = argparse.ArgumentParser(description="Generate a comment block")
    parser.add_argument("text", help="Text to wrap in a comment block")
    args = parser.parse_args()
    comment_block(args.text)
