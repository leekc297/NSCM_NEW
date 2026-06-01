#!/usr/bin/env python3
"""
Stage 3b — JSON_OBJECT RETURNING CLOB + V_IN_PARA_DATA CLOB 일괄 변환.

Multi-line JSON_OBJECT 호출을 안전하게 처리하기 위해 paren-balanced parser 사용.

Patterns applied:
  1. V_IN_PARA_DATA VARCHAR2(4000)   →  V_IN_PARA_DATA CLOB
  2. JSON_OBJECT( ... )              →  JSON_OBJECT( ... RETURNING CLOB )
     (이미 RETURNING 있는 경우 skip)

Idempotent: 재실행 시 변경 0.
"""
import re
import sys
from pathlib import Path

ROOT = Path("To-be_v2_converted/06_Packages")
GLOB = "04_Package_PKG_*.sql"


def fix_var_decl(text: str) -> tuple[str, int]:
    """V_IN_PARA_DATA VARCHAR2(4000) [:= NULL]?  →  V_IN_PARA_DATA CLOB [:= NULL]?"""
    pat = re.compile(
        r"\bV_IN_PARA_DATA(\s+)VARCHAR2\(\s*\d+\s*\)",
        re.IGNORECASE,
    )

    def _repl(m):
        return f"V_IN_PARA_DATA{m.group(1)}CLOB"

    new, n = pat.subn(_repl, text)
    return new, n


def find_json_object_calls(text: str) -> list[tuple[int, int]]:
    """JSON_OBJECT( ... ) — paren-balanced. Returns list of (open_paren, close_paren) char offsets."""
    spans = []
    i = 0
    n = len(text)
    while True:
        m = re.search(r"\bJSON_OBJECT\s*\(", text[i:], re.IGNORECASE)
        if not m:
            break
        # Open paren index
        op = i + m.end() - 1
        # Walk to match
        depth = 1
        j = op + 1
        in_str = False
        str_quote = None
        while j < n and depth > 0:
            c = text[j]
            if in_str:
                if c == str_quote:
                    # Look ahead for doubled quote (escape)
                    if j + 1 < n and text[j + 1] == str_quote:
                        j += 2
                        continue
                    in_str = False
            else:
                if c in ("'", '"'):
                    in_str = True
                    str_quote = c
                elif c == "(":
                    depth += 1
                elif c == ")":
                    depth -= 1
            j += 1
        if depth == 0:
            cp = j - 1
            spans.append((op, cp))
            i = cp + 1
        else:
            # Unmatched — give up
            break
    return spans


def fix_json_object(text: str) -> tuple[str, int]:
    """Add RETURNING CLOB before closing paren of each JSON_OBJECT, unless already present."""
    spans = find_json_object_calls(text)
    if not spans:
        return text, 0
    out = []
    last = 0
    n_changed = 0
    for op, cp in spans:
        out.append(text[last:cp])
        inner = text[op + 1 : cp]
        # Check if RETURNING is already present (whitespace-tolerant)
        if re.search(r"\bRETURNING\b", inner, re.IGNORECASE):
            out.append(")")
        else:
            # Preserve trailing whitespace before ) — find last non-ws
            stripped = inner.rstrip()
            trailing = inner[len(stripped):]
            # Avoid double space if stripped ends with comma — unlikely but safe
            sep = " " if stripped and not stripped.endswith(("(", " ", "\n", "\t")) else ""
            replacement = f"{sep}RETURNING CLOB{trailing})"
            # Replace the inner part: we already wrote text[last:cp] = text up to (but not including) cp
            # The text[last:cp] above includes inner; we need to back up by len(inner) and re-write.
            out[-1] = text[last:op + 1] + stripped + sep + "RETURNING CLOB" + trailing
            out.append(")")
            n_changed += 1
        last = cp + 1
    out.append(text[last:])
    return "".join(out), n_changed


def main():
    files = sorted(ROOT.glob(GLOB))
    if not files:
        print(f"No files matched in {ROOT}/{GLOB}", file=sys.stderr)
        sys.exit(1)
    total_var = 0
    total_json = 0
    touched = 0
    for f in files:
        text = f.read_text(encoding="utf-8")
        new, n_var = fix_var_decl(text)
        new, n_json = fix_json_object(new)
        if n_var or n_json:
            f.write_text(new, encoding="utf-8")
            touched += 1
            total_var += n_var
            total_json += n_json
            print(f"  {f.name:48s}  var={n_var:>3d}  json={n_json:>3d}")
    print(f"\n=== Total: {touched} files / {total_var} VARCHAR2→CLOB / {total_json} JSON_OBJECT RETURNING CLOB ===")


if __name__ == "__main__":
    main()
