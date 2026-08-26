# -*- coding: utf-8 -*-
"""SQL_ID g0w0gvnn7rkb2 원문 덤프 + BODY 내 INSERT INTO GT_DM35_RAW_DATA 16곳 중 특정 (읽기 전용).

SQL_ID = SQL 텍스트 해시 → 사내에도 동일 SQL_ID 존재. 사내 V$SQL 에서 SQL_FULLTEXT 를 그대로 덤프하고
BODY 원문의 각 INSERT 문장과 정규화 비교해 라인 번호를 확정한다(추정 금지).
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
SQLID = "g0w0gvnn7rkb2"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("""SELECT SQL_ID, CHILD_NUMBER, PLAN_HASH_VALUE, EXECUTIONS, ELAPSED_TIME, BUFFER_GETS,
                      ROWS_PROCESSED, DISK_READS, LAST_ACTIVE_TIME, SQL_FULLTEXT
                 FROM V$SQL WHERE SQL_ID=:s ORDER BY CHILD_NUMBER""", {"s": SQLID})
rows = cur.fetchall()
if not rows:
    print("[STOP] 사내 V$SQL 에 SQL_ID 없음 — 재현 필요")
    sys.exit(2)

print(f"{'CH':>3} {'PLAN_HASH':>11} {'EXEC':>5} {'ELAPSED_s':>10} {'s/exec':>8} {'BUFGETS':>12} {'ROWS':>8} {'DISK':>8}  LAST")
full = None
for r in rows:
    _, ch, ph, ex, el, bg, rp, dr, lat, ft = r
    print(f"{ch:>3} {ph:>11} {ex:>5} {el/1e6:>10.1f} {el/1e6/max(ex,1):>8.2f} {bg:>12} {rp:>8} {dr:>8}  {lat}")
    if full is None:
        full = ft.read() if hasattr(ft, "read") else str(ft)

open(BASE + r"\10_SQLID_g0w0gvnn7rkb2_FULLTEXT.sql", "w", encoding="utf-8").write(full)
print(f"\n[saved] 10_SQLID_g0w0gvnn7rkb2_FULLTEXT.sql ({len(full)} chars, {len(full.splitlines())} lines)")

# ---- BODY 원문에서 INSERT INTO SCM_MGR.GT_DM35_RAW_DATA 문장 전부 추출 + 대조 ----
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = [(ln, t.rstrip("\n")) for ln, t in cur.fetchall()]
con.close()

# 프로시저 경계
procs = [(ln, re.match(r"\s*(?:PROCEDURE|FUNCTION)\s+(\w+)", t, re.I).group(1))
         for ln, t in src if re.match(r"\s*(?:PROCEDURE|FUNCTION)\s+(\w+)", t, re.I)]


def owner_proc(line):
    cand = [n for l, n in procs if l <= line]
    return cand[-1] if cand else "?"


def norm(s):
    """SQL*Plus/PLSQL 차이 무시 정규화: 주석 제거 + 공백 압축 + 대문자."""
    s = re.sub(r"/\*.*?\*/", " ", s, flags=re.S)
    s = re.sub(r"--[^\n]*", " ", s)
    return re.sub(r"\s+", " ", s).strip().upper()


nfull = norm(full)
starts = [ln for ln, t in src if re.search(r"INSERT\s+INTO\s+SCM_MGR\.GT_DM35_RAW_DATA\b", t, re.I)]
print(f"\nBODY 내 INSERT INTO SCM_MGR.GT_DM35_RAW_DATA: {len(starts)}곳 → {starts}")

# 각 INSERT 문장을 ';' 종결까지 잘라 정규화 비교
text_by_line = {ln: t for ln, t in src}
maxln = src[-1][0]
hits = []
for s in starts:
    buf = []
    ln = s
    while ln <= maxln:
        t = text_by_line.get(ln, "")
        buf.append(t)
        # 주석 제거 후 ';' 존재 여부
        stripped = re.sub(r"--[^\n]*", "", t)
        if ";" in stripped:
            break
        ln += 1
    stmt = "\n".join(buf)
    nst = norm(stmt)
    nst_nosemi = nst.rstrip().rstrip(";").strip()
    exact = (nst_nosemi == nfull.rstrip().rstrip(";").strip())
    hits.append((s, ln, owner_proc(s), len(buf), exact, nst_nosemi))
    print(f"  L{s:>5}-{ln:<5} [{owner_proc(s):<38}] {len(buf):>3}줄  EXACT={exact}")

matched = [h for h in hits if h[4]]
print(f"\n[MATCH] 완전일치 {len(matched)}곳: {[h[0] for h in matched]}")
if not matched:
    # 근사 대조 — 앞 400자 프리픽스 일치도
    print("\n[근사대조] 정규화 접두 400자 일치 여부")
    pre = nfull[:400]
    for s, e, pr, n, ex, nst in hits:
        common = 0
        for a, b in zip(nst, pre):
            if a != b:
                break
            common += 1
        print(f"  L{s:>5} 공통접두 {common:>4}자  [{pr}]")
    print("\nFULLTEXT 접두 400자:")
    print(pre)
