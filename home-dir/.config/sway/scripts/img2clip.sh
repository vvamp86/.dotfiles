#!/usr/bin/env bash
set -e

IMG="$1"
[[ -f "$IMG" ]] || { echo "Image not found"; exit 1; }

TMPDIR=$(mktemp -d)
MD="$TMPDIR/ocr.md"
ASCII="$TMPDIR/ascii.txt"

# --- OCR to Markdown + LaTeX ---
pix2text "$IMG" --output "$MD"

# --- ASCII Art ---
img2txt -W 90 "$IMG" > "$ASCII"

# --- Combine + Clipboard ---
{
  echo "## OCR (Markdown + LaTeX)"
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

echo "✅ Image converted → Markdown + LaTeX + ASCII → clipboard"

rm -rf "$TMPDIR"
