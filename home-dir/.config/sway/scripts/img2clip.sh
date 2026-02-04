#!/usr/bin/env bash
set -e

IMG="$1"
[[ -f "$IMG" ]] || { echo "Image not found"; exit 1; }

TMPDIR=$(mktemp -d)
LATEX="$TMPDIR/ocr.tex"
MD="$TMPDIR/ocr.md"
ASCII="$TMPDIR/ascii.txt"

# --- OCR to LaTeX using Nougat ---
python3 - <<PYTHON
import sys
from nougat_ocr import main

image_path = "$IMG"
latex_output = "$LATEX"

result = main.run_ocr(image_path)
with open(latex_output, "w") as f:
    f.write(result)
PYTHON

# --- Wrap LaTeX in Markdown ---
{
    echo '```latex'
    cat "$LATEX"
    echo '```'
} > "$MD"

# --- ASCII Art using system img2txt ---
img2txt -W 90 "$IMG" > "$ASCII"

# --- Combine everything and copy to clipboard ---
{
    echo "## OCR (LaTeX)"
    echo
    cat "$MD"
    echo
    echo "---"
    echo
    echo "## ASCII Art"
    echo
    echo '```text'
    cat "$ASCII"
    echo '```'
} | wl-copy

# Clean up
rm -rf "$TMPDIR"

