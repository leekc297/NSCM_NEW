#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""A 배포 후 검증 — 라이브 PKG 문장 그대로 실행해 PK 중복 0 확인 (전체 ROLLBACK)
   B-1 은 아직 미적용 상태이므로 LGE/KT&G·동남아 2배 계상은 남아 있어야 정상(대조군)."""
import sys, pathlib, re
from collections import Counter
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

DIV, VER = '40', 'R_S_20260810_V009_C'
u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 900000
cur = con.cursor()

cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "".join(r[0] for r in cur.fetchall())
print(f"[라이브] TUNE-V={live.count('TUNE-V 2026-08-10')} TUNE-J={live.count('TUNE-J 2026-08-10')} "
      f"TUNE-S={live.count('TUNE-S 2026-08-10')}")

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
    s = [mm.start() for mm in re.finditer(r'(?im)^PROCEDURE\s+' + proc + r'\b', M)][0]
    nx = [mm.start() for mm in re.finditer(r'(?im)^PROCEDURE\s+\w+', M) if mm.start() > s]
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

def lit(sql, oriv):
    sql = re.sub(r'\bP_DIVISION_ID\b', f"'{DIV}'", sql)
    sql = re.sub(r'\bP_VERSION_NO\b', f"'{VER}'", sql)
    sql = re.sub(r'\bv_user_id\b', "'mdf_batch'", sql)
    sql = re.sub(r'\bv_ori_version_no\b', 'NULL' if oriv is None else f"'{oriv}'", sql)
    sql = re.sub(r'\bV_SP_BP\b', "'SP'", sql)
    return sql

cur.execute("SELECT MAX(ORI_VERSION_NO) FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
            {"d": DIV, "v": VER})
ORIV = cur.fetchone()[0]

try:
    cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
    gtt = lit(extract(live, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.GT_DMF0044_DEPT_RPT_C'), ORIV)
    cur.execute("""INSERT INTO SCM_MGR.GT_DMF0044_DEPT_RPT_C
        ( DIVISION_ID, PRODUCT_GROUP, MEASURE, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2,
          DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, QTY ) """ + gtt)
    print(f"[GTT] {cur.rowcount:,} 행")

    sel = lit(extract(live, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_DEPT'), ORIV)
    cur.execute(sel)
    rows = cur.fetchall()
    c = Counter(tuple(r[:10]) for r in rows)
    dups = {k: v for k, v in c.items() if v > 1}
    print(f"\n[A 검증] 결과 {len(rows):,}행 / PK 중복키 {len(dups)} / 초과행 {sum(v-1 for v in dups.values())}"
          f"   {'✅ ORA-00001 해소' if not dups else '⛔ 잔존'}")

    print("\n[실제 INSERT 시도 — PK 제약 실검증 후 ROLLBACK]")
    cur.execute("DELETE FROM SCM_MGR.DM_MOBILE_REPORT_DEPT WHERE DIVISION_ID=:d AND VERSION_NO=:v",
                {"d": DIV, "v": VER})
    ins = extract(live, 'P_DMF0044_SALES_REPORT_DEPT_CREATE', 'SCM_MGR.DM_MOBILE_REPORT_DEPT')
    hdr = live[live.index('INSERT INTO SCM_MGR.DM_MOBILE_REPORT_DEPT'):]
    hdr = hdr[:hdr.index(')') + 1]
    cur.execute(hdr + "\n" + lit(ins, ORIV))
    print(f"  INSERT 성공 {cur.rowcount:,} 행  ✅ (PK 위반 없음)")

    print("\n[B-1 대조군 — 아직 미적용이므로 2배가 남아 있어야 정상]")
    show(*fetch(cur, """
    SELECT CUST_INFO, COUNT(*) rows_, SUM(MM01+MM02+MM03+MM04+MM05+MM06+MM07+MM08+MM09+MM10+MM11+MM12) tot
      FROM SCM_MGR.DM_MOBILE_REPORT_DEPT
     WHERE DIVISION_ID=:d AND VERSION_NO=:v AND CUST_INFO IN ('LGE/KT&'||'G','동남아')
     GROUP BY CUST_INFO ORDER BY CUST_INFO""", {"d": DIV, "v": VER}))
finally:
    con.rollback()
    cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
    con.rollback()
    print("\n[정리] ROLLBACK 완료 — 커밋된 변경 0")
con.close()
