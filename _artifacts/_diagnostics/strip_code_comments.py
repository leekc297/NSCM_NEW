#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""strip_code_comments.py — 주석 제거 전처리기 (hook #138 comment-live-code-discrimination §3)

주석 문자를 **공백으로 치환**해 라인 수·컬럼 위치를 원본과 1:1 보존한다.
→ 전처리본에서 grep 한 라인 번호가 곧 원본 라인 번호다.

지원:
  --mode sql (기본) : `--` 라인 주석, `/* … */` 블록 주석(멀티라인).
                      `'…'` 문자열(`''` 이스케이프)·`"식별자"` 보존 —
                      센티널 리터럴 `IN ('-','--')` 를 주석으로 오독하지 않는다.
                      `/*+ … */` 옵티마이저 힌트는 **기능 코드라 보존**.
  --mode cs  : `//` 라인 주석(`///` 포함), `/* … */` 블록. `"…"`(\\ 이스케이프)·`@"…"` verbatim·`'c'` 보존.

사용:
  python strip_code_comments.py dump.sql                 # stdout
  python strip_code_comments.py dump.sql -o dump.live    # 파일 출력
  python strip_code_comments.py Foo.cs --mode cs -o Foo.cs.live
라이브 판정 워크플로:
  python strip_code_comments.py _asis_DMF0082_GET_MAIN_DATA.sql -o live.sql
  grep -n "AS END_CUSTOMER" live.sql        # ← 여기 잡히는 것만 라이브
"""
import argparse
import sys


def _blank(ch: str) -> str:
    """주석 문자 → 공백 (개행은 보존해 라인 수 유지)"""
    return ch if ch == "\n" else " "


def strip_sql(text: str) -> str:
    out = []
    i, n = 0, len(text)
    NORMAL, SQUOTE, DQUOTE, LINE_C, BLOCK_C = 0, 1, 2, 3, 4
    state = NORMAL
    while i < n:
        c = text[i]
        nxt = text[i + 1] if i + 1 < n else ""
        if state == NORMAL:
            if c == "'":
                state = SQUOTE
                out.append(c)
            elif c == '"':
                state = DQUOTE
                out.append(c)
            elif c == "-" and nxt == "-":
                state = LINE_C
                out.append("  ")
                i += 1
            elif c == "/" and nxt == "*":
                # /*+ 힌트는 기능 코드 — 통째로 보존
                if i + 2 < n and text[i + 2] == "+":
                    end = text.find("*/", i + 2)
                    end = n if end < 0 else end + 2
                    out.append(text[i:end])
                    i = end - 1
                else:
                    state = BLOCK_C
                    out.append("  ")
                    i += 1
            else:
                out.append(c)
        elif state == SQUOTE:
            out.append(c)
            if c == "'":
                if nxt == "'":  # '' 이스케이프
                    out.append(nxt)
                    i += 1
                else:
                    state = NORMAL
        elif state == DQUOTE:
            out.append(c)
            if c == '"':
                state = NORMAL
        elif state == LINE_C:
            out.append(_blank(c))
            if c == "\n":
                state = NORMAL
        elif state == BLOCK_C:
            if c == "*" and nxt == "/":
                out.append("  ")
                i += 1
                state = NORMAL
            else:
                out.append(_blank(c))
        i += 1
    return "".join(out)


def strip_cs(text: str) -> str:
    out = []
    i, n = 0, len(text)
    NORMAL, DQUOTE, VERBATIM, CHAR_L, LINE_C, BLOCK_C = 0, 1, 2, 3, 4, 5
    state = NORMAL
    while i < n:
        c = text[i]
        nxt = text[i + 1] if i + 1 < n else ""
        if state == NORMAL:
            if c == "@" and nxt == '"':
                state = VERBATIM
                out.append(c + nxt)
                i += 1
            elif c == '"':
                state = DQUOTE
                out.append(c)
            elif c == "'":
                state = CHAR_L
                out.append(c)
            elif c == "/" and nxt == "/":
                state = LINE_C
                out.append("  ")
                i += 1
            elif c == "/" and nxt == "*":
                state = BLOCK_C
                out.append("  ")
                i += 1
            else:
                out.append(c)
        elif state == DQUOTE:
            out.append(c)
            if c == "\\":
                if nxt:
                    out.append(nxt)
                    i += 1
            elif c == '"':
                state = NORMAL
        elif state == VERBATIM:
            out.append(c)
            if c == '"':
                if nxt == '"':  # "" 이스케이프
                    out.append(nxt)
                    i += 1
                else:
                    state = NORMAL
        elif state == CHAR_L:
            out.append(c)
            if c == "\\":
                if nxt:
                    out.append(nxt)
                    i += 1
            elif c == "'":
                state = NORMAL
        elif state == LINE_C:
            out.append(_blank(c))
            if c == "\n":
                state = NORMAL
        elif state == BLOCK_C:
            if c == "*" and nxt == "/":
                out.append("  ")
                i += 1
                state = NORMAL
            else:
                out.append(_blank(c))
        i += 1
    return "".join(out)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("file")
    ap.add_argument("--mode", choices=["sql", "cs"], default="sql")
    ap.add_argument("-o", "--out", help="출력 파일 (미지정 = stdout)")
    a = ap.parse_args()
    text = open(a.file, encoding="utf-8", errors="replace").read()
    result = strip_sql(text) if a.mode == "sql" else strip_cs(text)
    assert result.count("\n") == text.count("\n"), "라인 수 불일치 — 버그"
    if a.out:
        open(a.out, "w", encoding="utf-8", newline="").write(result)
        print(f"[strip] {a.file} → {a.out} ({len(result.splitlines())} lines, 라인 보존)", file=sys.stderr)
    else:
        sys.stdout.write(result)


if __name__ == "__main__":
    main()
