#!/usr/bin/env python3
"""
Stage 3c — LISTAGG ON OVERFLOW TRUNCATE WITH COUNT 추가.

Oracle 12.2+ 기능. 정상 동작은 변경 없이 4000자 초과 시 ORA-01489 대신 truncate.

Pattern:
  LISTAGG(... [, ...]) WITHIN GROUP (ORDER BY ...)
  → LISTAGG(...) WITHIN GROUP (ORDER BY ...) ON OVERFLOW TRUNCATE WITH COUNT

이미 ON OVERFLOW 가 있는 경우 skip.

WITHIN GROUP (...) 의 paren 을 balance 하여 정확히 끝을 찾는다.
"""
import re
import sys
from pathlib import Path

ROOT = Path("To-be_v2_converted/06_Packages")
GLOB = "04_Package_PKG_*.sql"


def fix_listagg(text: str) -> tuple[str, int]:
    """Insert ON OVERFLOW TRUNCATE WITH COUNT INSIDE LISTAGG(...) before its closing ).

    Correct Oracle syntax:
      LISTAGG(measure, delim ON OVERFLOW TRUNCATE WITH COUNT) WITHIN GROUP (ORDER BY ...)
    NOT:
      LISTAGG(measure, delim) WITHIN GROUP (...) ON OVERFLOW ...   ← ORA-00923
    """
    out = []
    i = 0
    n = len(text)
    n_changed = 0
    while True:
        m = re.search(r"\bLISTAGG\s*\(", text[i:], re.IGNORECASE)
        if not m:
            out.append(text[i:])
            break
        out.append(text[i:i + m.start()])
        op = i + m.end() - 1  # position of '('
        j = op + 1
        depth = 1
        in_str = False
        sq = None
        while j < n and depth > 0:
            c = text[j]
            if in_str:
                if c == sq:
                    if j + 1 < n and text[j + 1] == sq:
                        j += 2
                        continue
                    in_str = False
            else:
                if c in ("'", '"'):
                    in_str = True
                    sq = c
                elif c == "(":
                    depth += 1
                elif c == ")":
                    depth -= 1
            j += 1
        if depth != 0:
            out.append(text[i + m.start():])
            break
        cp = j - 1  # position of LISTAGG's closing ')'
        inner = text[op + 1:cp]
        # Already has ON OVERFLOW?
        if re.search(r"\bON\s+OVERFLOW\b", inner, re.IGNORECASE):
            out.append(text[i + m.start():cp + 1])
        else:
            stripped = inner.rstrip()
            trailing = inner[len(stripped):]
            sep = " " if stripped and not stripped.endswith((" ", "\n", "\t", ",", "(")) else ""
            out.append(text[i + m.start():op + 1] + stripped + sep + "ON OVERFLOW TRUNCATE WITH COUNT" + trailing + ")")
            n_changed += 1
        i = cp + 1
    return "".join(out), n_changed


def main():
    total = 0
    touched = 0
    for f in sorted(ROOT.glob(GLOB)):
        text = f.read_text(encoding="utf-8")
        new, n = fix_listagg(text)
        if n:
            f.write_text(new, encoding="utf-8")
            touched += 1
            total += n
            print(f"  {f.name:48s}  added={n}")
    print(f"\n=== Total: {touched} files / {total} LISTAGG ON OVERFLOW added ===")


if __name__ == "__main__":
    main()
