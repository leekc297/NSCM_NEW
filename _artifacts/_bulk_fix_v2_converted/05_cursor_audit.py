#!/usr/bin/env python3
"""
Stage 3e — Cursor 컬럼 / OPEN cursor name audit.

각 procedure 의 OUT 파라미터 (O_RC1/RC2/RC3) 가 모두 OPEN 되었는지 확인.
미 OPEN OUT cursor 가 있으면 caller 가 FETCH 시 INVALID_CURSOR 가능.

DMF0043 사고 (O_RC3 OPEN 인데 caller 가 O_RC1 FETCH) 의 재발 패턴 검출.
"""
import re
from pathlib import Path

ROOT = Path("To-be_v2_converted/06_Packages")
GLOB = "04_Package_PKG_*.sql"

# Procedure signature with OUT cursor parameters
SIG_RE = re.compile(
    r"PROCEDURE\s+(\w+)\s*\(([^)]*)\)",
    re.IGNORECASE | re.DOTALL,
)
OUT_PARAM_RE = re.compile(r"\b(O_RC\d|O_RESULT_CURSOR)\s+OUT\b", re.IGNORECASE)
END_RE_TMPL = r"^\s*END\s+{}\s*;"
OPEN_RE = re.compile(r"\bOPEN\s+(O_RC\d|O_RESULT_CURSOR)\b", re.IGNORECASE)


def main():
    total_proc = 0
    total_warn = 0
    print(f"{'File':50s} {'Procedure':40s} {'OUT declared':24s} {'OPEN actual':24s} {'Warning'}")
    print("-" * 160)
    for f in sorted(ROOT.glob(GLOB)):
        text = f.read_text(encoding="utf-8")
        for m in SIG_RE.finditer(text):
            proc, params = m.group(1), m.group(2)
            out_set = set(p.upper() for p in OUT_PARAM_RE.findall(params))
            if not out_set:
                continue
            # Find proc body
            end_re = re.compile(END_RE_TMPL.format(re.escape(proc)), re.IGNORECASE | re.MULTILINE)
            em = end_re.search(text, m.end())
            if not em:
                continue
            body = text[m.end():em.start()]
            open_set = set(o.upper() for o in OPEN_RE.findall(body))
            missing_open = out_set - open_set
            unexpected_open = open_set - out_set
            if missing_open or unexpected_open:
                total_proc += 1
                warn = []
                if missing_open:
                    warn.append(f"NOT_OPENED: {','.join(sorted(missing_open))}")
                    total_warn += len(missing_open)
                if unexpected_open:
                    warn.append(f"OPEN_UNDECLARED: {','.join(sorted(unexpected_open))}")
                    total_warn += len(unexpected_open)
                print(f"{f.name:50s} {proc:40s} {','.join(sorted(out_set)):24s} {','.join(sorted(open_set)):24s} {'; '.join(warn)}")
    print("-" * 160)
    print(f"Total: {total_proc} procedures with {total_warn} cursor mismatches")


if __name__ == "__main__":
    main()
