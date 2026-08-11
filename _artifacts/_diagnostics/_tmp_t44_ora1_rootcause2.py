#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ORA-00001 근본원인 실증 (2차) — 결과를 Python 으로 받아 **위치 기준** PK 중복을 센다.
   (최종 SELECT 는 컬럼 별칭이 없어 SQL 로 이름 참조가 불가 → 위치로 판정)

   PK = 컬럼 1~10 (DIVISION_ID, VERSION_NO, YYYY, SP_BP_TYPE, UPPER_DEPT_NAME,
                    DEPT_NAME, CUST_INFO, PRODUCT_NAME, PRODUCT_DETAIL, MEASURE)
   OLD(백업본) / NEW(라이브) 둘 다 재현해 **내 변경분인지 기존 결함인지** 가른다.
"""
import sys, pathlib, re
from collections import Counter
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
OLD_F = OUT / "BACKUP_PKG_DMF0044_BODY_pre_transfertune_20260810.sql"
DIV, VER = '40', 'R_S_20260810_V009_C'
PKN = 10

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 900000
cur = con.cursor()

def mask(s):
    out = list(s); i = 0; n = len(s)
    while i < n:
        if s[i] == "'":
            j = i + 1
            while j < n:
                if s[j] == "'":
                    if j + 1 < n and s[j+1] == "'": j += 2; continue
                    break
                j += 1
            for k in range(i, min(j+1, n)): out[k] = ' '
            i = j + 1
        elif s.startswith('--', i):
            j = s.find('\n', i); j = n if j < 0 else j
            for k in range(i, j): out[k] = ' '
            i = j
        elif s.startswith('/*', i):
            j = s.find('*/', i+2); j = n if j < 0 else j+2
            for k in range(i, j): out[k] = ' '
            i = j
        else:
            i += 1
    return "".join(out)

def extract(text, proc, target):
    M = mask(text)
    s = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+' + proc + r'\b', M)][0]
    nx = [mm.start() for mm in re.finditer(r'(?im)^\s*PROCEDURE\s+\w+', M) if mm.start() > s]
    e = nx[0] if nx else len(M)
    ins = s + M[s:e].index('INSERT INTO ' + target)
    i = M.index('(', ins); depth = 0
    while i < e:
        if M[i] == '(': depth += 1
        elif M[i] == ')':
            depth -= 1
            if depth == 0: break
        i += 1
    j = i + 1; depth = 0
    while j < e:
        if M[j] == '(': depth += 1
        elif M[j] == ')': depth -= 1
        elif M[j] == ';' and depth == 0: break
        j += 1
    return text[i+1:j].strip()

def lit(sql, spbp, oriv):
    sql = re.sub(r'\bP_DIVISION_ID\b', f"'{DIV}'", sql)
    sql = re.sub(r'\bP_VERSION_NO\b', f"'{VER}'", sql)
    sql = re.sub(r'\bv_user_id\b', "'mdf_batch'", sql)
    sql = re.sub(r'\bv_ori_version_no\b', 'NULL' if oriv is None else f"'{oriv}'", sql)
    sql = re.sub(r'\bV_SP_BP\b', f"'{spbp}'", sql)
    return sql

cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "".join(r[0] for r in cur.fetchall())
old = OLD_F.read_text(encoding='utf-8')

cur.execute("""SELECT CASE WHEN COUNT(*)>0 THEN 'BP' ELSE 'SP' END FROM DM_PLN_SALES_PLAN_REPORT_C
                WHERE DIVISION_ID=:d AND VERSION_NO=:v AND MEASURE='Business_Plan' AND ROWNUM=1""",
            {"d": DIV, "v": VER})
SPBP = cur.fetchone()[0]
cur.execute("SELECT MAX(ORI_VERSION_NO) FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
            {"d": DIV, "v": VER})
ORIV = cur.fetchone()[0]
print(f"[binds] {DIV} / {VER} / SP_BP={SPBP} / ORI={ORIV!r}\n")

results = {}
try:
    for lbl, src in (("OLD", old), ("NEW", live)):
        cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
        gtt = lit(extract(src, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.GT_DMF0044_DEPT_RPT_C'), SPBP, ORIV)
        cur.execute("""INSERT INTO SCM_MGR.GT_DMF0044_DEPT_RPT_C
            ( DIVISION_ID, PRODUCT_GROUP, MEASURE, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2,
              DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, QTY ) """ + gtt)
        gttn = cur.rowcount
        sel = lit(extract(src, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_DEPT'), SPBP, ORIV)
        cur.execute(sel)
        rows = cur.fetchall()
        c = Counter(tuple(r[:PKN]) for r in rows)
        dups = {k: v for k, v in c.items() if v > 1}
        surplus = sum(v - 1 for v in dups.values())
        verdict = "⛔ ORA-00001 발생" if dups else "✅ 정상"
        print(f"  {lbl}: GTT {gttn:,}행 / 결과 {len(rows):,}행 / PK 중복키 {len(dups)} / 초과행 {surplus}   {verdict}")
        results[lbl] = (rows, dups)

    print("\n" + "=" * 116)
    print("[중복 PK 실물 — NEW 기준 상위 10건] (PK 10컬럼 + 갈라진 SORT_NO/MM 합)")
    print("=" * 116)
    rows, dups = results["NEW"]
    idx = {}
    for r in rows:
        idx.setdefault(tuple(r[:PKN]), []).append(r)
    shown = 0
    for k, v in dups.items():
        grp = idx[k]
        print(f"\n  PK={k}")
        for g in grp:
            print(f"     SORT_NO={g[23]}  ORI_VER={g[22]!r}  MM01~03={g[10]},{g[11]},{g[12]}")
        shown += 1
        if shown >= 10: break
finally:
    con.rollback()
    cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
    con.rollback()
    print("\n[정리] ROLLBACK 완료 (GTT 세션 전용 · 원장 무변경)")
con.close()
