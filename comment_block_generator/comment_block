#!/usr/bin/env python3
import argparse


########################
## this is the result ##
########################
def comment_block(text):
    width = len(text) + 6  # six for the four # and two " " on either side of the text
    border = "#" * width
    middle = f"## {text} ##"
    print(border)
    print(middle)
    print(border)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate a comment block")
    parser.add_argument("text", help="Text to wrap in a comment block")
    args = parser.parse_args()
    comment_block(args.text)
