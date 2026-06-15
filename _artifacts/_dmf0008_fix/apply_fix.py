"""
DMF0008 SUMMARY + REPAIR SP body fix
- Fix 1: NVL(A.EXCEPTION_FLAG, NULL) → NVL(A.EXCEPTION_FLAG, 'N')
- Fix 2: NVL(A.EXCEPTION_fLAG, NULL) → NVL(A.EXCEPTION_fLAG, 'N')
- Fix 3: bare A.EXCEPTION_FLAG != 'Y' → NVL(A.EXCEPTION_FLAG, 'N') != 'Y' (only outside NVL)
- Fix 4: bare A.EXCEPTION_fLAG != 'Y' → NVL(A.EXCEPTION_fLAG, 'N') != 'Y'
- Fix 5 (SUMMARY only): OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL; → commented (cursor overwrite bug)

Reference:
- 메모리 feedback_isnull_to_nvl_null_handling.md (NVL anti-pattern)
- 메모리 feedback_sp_cursor_reassignment_overwrite.md (cursor overwrite)
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).parent
FIXES_DIR = ROOT
ORIG_SUMMARY = FIXES_DIR / "_original_summary.sql"
ORIG_REPAIR = FIXES_DIR / "_original_repair.sql"
FIXED_SUMMARY = FIXES_DIR / "_fixed_summary.sql"
FIXED_REPAIR = FIXES_DIR / "_fixed_repair.sql"

def apply_common_fixes(body: str) -> tuple[str, int]:
    """Apply NVL anti-pattern fixes. Returns (fixed_body, count)."""
    count = 0

    # Fix 1: NVL(A.EXCEPTION_FLAG, NULL) → NVL(A.EXCEPTION_FLAG, 'N')
    new_body, n = re.subn(
        r"NVL\(A\.EXCEPTION_FLAG,\s*NULL\)",
        "NVL(A.EXCEPTION_FLAG, 'N')",
        body
    )
    count += n
    body = new_body

    # Fix 2: NVL(A.EXCEPTION_fLAG, NULL) — case variant
    new_body, n = re.subn(
        r"NVL\(A\.EXCEPTION_fLAG,\s*NULL\)",
        "NVL(A.EXCEPTION_fLAG, 'N')",
        body
    )
    count += n
    body = new_body

    # Fix 3: bare A.EXCEPTION_FLAG != 'Y' (NOT inside NVL — use negative lookbehind)
    # The `, ` before A.EXCEPTION_FLAG would indicate inside NVL(..., ...)
    # Bare form is preceded by whitespace + AND, or by THEN, etc.
    new_body, n = re.subn(
        r"(?<![,\(])\bA\.EXCEPTION_FLAG\s*!=\s*'Y'",
        "NVL(A.EXCEPTION_FLAG, 'N') != 'Y'",
        body
    )
    count += n
    body = new_body

    # Fix 4: bare A.EXCEPTION_fLAG != 'Y' (case variant)
    new_body, n = re.subn(
        r"(?<![,\(])\bA\.EXCEPTION_fLAG\s*!=\s*'Y'",
        "NVL(A.EXCEPTION_fLAG, 'N') != 'Y'",
        body
    )
    count += n
    body = new_body

    return body, count

def apply_summary_fix(body: str) -> tuple[str, int]:
    """Comment out the cursor overwrite line."""
    # Fix 5: OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL; → comment
    # Keep O_RC3 DUMMY (it has no main OPEN)
    new_body, n = re.subn(
        r"^(\s*)(OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL;)",
        r"\1-- [2026-06-10 FIX] cursor overwrite removed: \2",
        body,
        flags=re.MULTILINE
    )
    return new_body, n

def main():
    summary = ORIG_SUMMARY.read_text(encoding="utf-8")
    repair = ORIG_REPAIR.read_text(encoding="utf-8")

    # Strip GET_DDL trailing space/wrap if any
    summary_fixed, n1 = apply_common_fixes(summary)
    summary_fixed, n2 = apply_summary_fix(summary_fixed)
    print(f"SUMMARY: NVL fixes={n1}, cursor-overwrite fixes={n2}")

    repair_fixed, n3 = apply_common_fixes(repair)
    print(f"REPAIR : NVL fixes={n3}")

    # GET_DDL output sometimes ends in trailing whitespace lines.
    # Need to add `/` so sqlplus knows the body ends.
    if not summary_fixed.rstrip().endswith('/'):
        summary_fixed = summary_fixed.rstrip() + "\n/\n"
    if not repair_fixed.rstrip().endswith('/'):
        repair_fixed = repair_fixed.rstrip() + "\n/\n"

    FIXED_SUMMARY.write_text(summary_fixed, encoding="utf-8")
    FIXED_REPAIR.write_text(repair_fixed, encoding="utf-8")

    print(f"\nWrote: {FIXED_SUMMARY}")
    print(f"Wrote: {FIXED_REPAIR}")

if __name__ == "__main__":
    main()
