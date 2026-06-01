#!/usr/bin/env python3
"""
Stage 3b (Revised) — V_IN_PARA_DATA VARCHAR2(4000) → CLOB ONLY.

Oracle 23ai PL/SQL 은 `JSON_OBJECT(... RETURNING CLOB)` 을 거부 (PLS-00684).
대신 V_IN_PARA_DATA 자체를 CLOB 으로 선언하면 JSON_OBJECT default 반환이
CLOB 으로 implicit 변환되어 overflow 회피.

Pattern: V_IN_PARA_DATA VARCHAR2(4000) [:= NULL] → V_IN_PARA_DATA CLOB [:= NULL]
"""
import re
import sys
from pathlib import Path

ROOT = Path("To-be_v2_converted/06_Packages")
GLOB = "04_Package_PKG_*.sql"


def main():
    pat = re.compile(
        r"\bV_IN_PARA_DATA(\s+)VARCHAR2\(\s*\d+\s*\)",
        re.IGNORECASE,
    )
    total = 0
    touched = 0
    for f in sorted(ROOT.glob(GLOB)):
        text = f.read_text(encoding="utf-8")
        new, n = pat.subn(lambda m: f"V_IN_PARA_DATA{m.group(1)}CLOB", text)
        if n:
            f.write_text(new, encoding="utf-8")
            touched += 1
            total += n
            print(f"  {f.name:48s}  changed={n}")
    print(f"\n=== Total: {touched} files / {total} VARCHAR2→CLOB ===")


if __name__ == "__main__":
    main()
