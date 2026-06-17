"""Build patched SP from extracted body:
   - strip line-number prefix "  NNN| "
   - patch line 176: VA_SHEET_NAME := 'Mkt Fcst'  →  VA_SHEET_NAME := 'main'
   - prepend CREATE OR REPLACE, append '/'
"""
import pathlib, re, sys

src = pathlib.Path(__file__).parent / "extracted_sp_body.sql"
dst = pathlib.Path(__file__).parent / "019_sp_body_patched.sql"

PREFIX_RE = re.compile(r"^\s*\d+\|\s?")

lines = src.read_text(encoding="utf-8").splitlines()
out = []
patched = 0
for i, line in enumerate(lines, start=1):
    stripped = PREFIX_RE.sub("", line)
    # ALL_SOURCE always prefixes the PROCEDURE keyword without CREATE OR REPLACE
    if i == 1:
        stripped = "CREATE OR REPLACE " + stripped
    # Patch any 'Mkt Fcst' (공백) → 'main' standardization
    if "'Mkt Fcst'" in stripped:
        new_line = stripped.replace("'Mkt Fcst'", "'main'")
        print(f"[PATCH] line {i}: {stripped.strip()[:120]}\n            → {new_line.strip()[:120]}")
        stripped = new_line
        patched += 1
    out.append(stripped)

if patched == 0:
    sys.exit("FAIL: 'Mkt Fcst' not found")
print(f"INFO: {patched} 'Mkt Fcst' → 'main' patches applied")

# Terminator for SQL*Plus / ora.py PL/SQL block
out.append("/")
dst.write_text("\n".join(out), encoding="utf-8")
print(f"built: {dst} ({len(out):,} lines, {patched} patch)")
