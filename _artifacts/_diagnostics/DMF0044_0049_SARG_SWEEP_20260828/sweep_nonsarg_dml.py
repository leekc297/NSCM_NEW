#!/usr/bin/env python3
"""PKG_DMF0044 / PKG_DMF0049 전 프로시저 — 비-SARGable DML 전수 스윕 (2026-08-28).

REQ:CHAT-20260828-03/-04. LOCDELSARG 계열 판정:
  대형 영구 테이블(비 GTT) 대상 DELETE/UPDATE 에서 WHERE 최상위(깊이 0)에
  VERSION_NO / DIVISION_ID 등 인덱스 선두 컬럼 직접 술어가 없으면 FULL SCAN 후보.
주석은 분석 근거가 아니므로 라인 보존 전처리로 제거(hook #138).
"""
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

PKGS = ["PKG_DMF0044", "PKG_DMF0049"]
# PK/인덱스 선두 후보 — 이 중 하나라도 depth-0 직접 술어면 SARGable 로 본다
LEAD_COLS = ("VERSION_NO", "DIVISION_ID")


def strip_comments(lines):
    """-- 및 /* */ 제거, 라인 수 보존. 문자열 리터럴 내 '--' 는 단순 무시(스윕 목적상 허용)."""
    out = []
    in_block = False
    for line in lines:
        res = []
        i = 0
        while i < len(line):
            if in_block:
                j = line.find("*/", i)
                if j < 0:
                    i = len(line)
                else:
                    in_block = False
                    i = j + 2
                continue
            if line.startswith("/*", i):
                in_block = True
                i += 2
                continue
            if line.startswith("--", i):
                break
            res.append(line[i])
            i += 1
        out.append("".join(res))
    return out


def proc_of(lines):
    """line index -> 현재 PROCEDURE 이름 매핑."""
    mapping = {}
    cur = "(decl)"
    pat = re.compile(r"^\s*PROCEDURE\s+(\w+)", re.IGNORECASE)
    for idx, line in enumerate(lines):
        m = pat.match(line)
        if m:
            cur = m.group(1)
        mapping[idx] = cur
    return mapping


def statements(text):
    """';' 로 끝나는 statement 단위 분해 — (시작 offset, 본문). 단순 분해(선언부 무해)."""
    parts = []
    start = 0
    depth = 0
    for i, ch in enumerate(text):
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth = max(0, depth - 1)
        elif ch == ";" and depth == 0:
            parts.append((start, text[start : i + 1]))
            start = i + 1
    return parts


def top_level_where(stmt, kw="WHERE"):
    """첫 depth-0 WHERE 이후 텍스트에서 depth-0 구간만 추출 (괄호 안=서브쿼리 제외)."""
    up = stmt.upper()
    depth = 0
    widx = -1
    i = 0
    while i < len(up):
        ch = up[i]
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        elif depth == 0 and up.startswith("WHERE", i) and not up[i - 1 : i].isalnum():
            widx = i
            break
        i += 1
    if widx < 0:
        return ""
    rest = stmt[widx:]
    out = []
    depth = 0
    for ch in rest:
        if ch == "(":
            depth += 1
            continue
        if ch == ")":
            depth -= 1
            continue
        if depth == 0:
            out.append(ch)
    return "".join(out)


def main() -> None:
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for pkg in PKGS:
            cur.execute(
                """SELECT text FROM all_source
                    WHERE owner='SCM_MGR' AND name=:n AND type='PACKAGE BODY'
                    ORDER BY line""",
                n=pkg,
            )
            raw = [r[0].rstrip("\n") for r in cur.fetchall()]
            lines = strip_comments(raw)
            procs = proc_of(lines)
            text = "\n".join(lines)
            # offset -> line index
            offsets = []
            pos = 0
            for idx, line in enumerate(lines):
                offsets.append((pos, idx))
                pos += len(line) + 1

            def line_of(off):
                lo, hi = 0, len(offsets) - 1
                while lo < hi:
                    mid = (lo + hi + 1) // 2
                    if offsets[mid][0] <= off:
                        lo = mid
                    else:
                        hi = mid - 1
                return offsets[lo][1]

            print(f"===== {pkg} =====")
            dml_pat = re.compile(
                r"^\s*(DELETE\s+FROM|UPDATE)\s+(SCM_MGR\.)?(\w+)", re.IGNORECASE
            )
            for off, stmt in statements(text):
                m = dml_pat.match(stmt.strip())
                if not m:
                    continue
                verb = "DELETE" if m.group(1).upper().startswith("DELETE") else "UPDATE"
                table = m.group(3).upper()
                if table.startswith("GT_"):  # GTT 는 소량 세션 테이블 — 제외
                    continue
                tw = top_level_where(stmt).upper()
                sarg = any(c in tw for c in LEAD_COLS)
                ln = line_of(off + (len(stmt) - len(stmt.lstrip()))) + 1
                flag = "OK  " if sarg else "FLAG"
                head = " ".join(stmt.split())[:150]
                print(f"[{flag}] {procs.get(ln - 1, '?'):45s} L{ln:5d} {verb:6s} {table:35s} {head}")
            print()


if __name__ == "__main__":
    main()
