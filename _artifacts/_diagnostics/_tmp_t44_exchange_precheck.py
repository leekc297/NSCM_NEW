#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Transfer 잔여 단계 사전 점검 — 아직 한 번도 도달 못 한 EXCHANGE 단계 + PRODUCT 재확인.
   실제 INSERT 를 걸어 PK/NOT NULL 제약까지 실검증한 뒤 **전부 ROLLBACK**."""
import sys, pathlib, re, time
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
cur.execute("SELECT MAX(SUBSTR(YYYYMMDD,1,4)) FROM DM_MDF_VERSION WHERE VERSION_NO=:v", {"v": VER})
YYYY = cur.fetchone()[0]
print(f"[대상] {DIV} / {VER} / P_YYYY={YYYY}\n")


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


M = mask(live)


def stmt(proc, needle):
    s = [mm.start() for mm in re.finditer(r'(?im)^PROCEDURE\s+' + proc + r'\b', M)][0]
    nx = [mm.start() for mm in re.finditer(r'(?im)^PROCEDURE\s+\w+', M) if mm.start() > s]
    e = nx[0] if nx else len(M)
    st = s + M[s:e].index(needle)
    j = st; depth = 0
    while j < e:
        if M[j] == '(': depth += 1
        elif M[j] == ')': depth -= 1
        elif M[j] == ';' and depth == 0: break
        j += 1
    return live[st:j].strip()


DECL = f"""
    P_DIVISION_ID VARCHAR2(32) := '{DIV}';
    P_VERSION_NO  VARCHAR2(50) := '{VER}';
    P_YYYY        VARCHAR2(4)  := '{YYYY}';
    v_yyyy        VARCHAR2(4)  := '{YYYY}';
    v_user_id     VARCHAR2(10) := 'mdf_batch';
    P_CREATED_BY  VARCHAR2(30) := 'mdf_batch';
"""

STEPS = [
    ("EXCHANGE  DELETE", 'P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE',
     'DELETE FROM SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE'),
    ("EXCHANGE  INSERT  ★미도달 구간", 'P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE',
     'INSERT INTO SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE'),
    ("PRODUCT   DELETE", 'P_DMF0044_SALES_REPORT_PRODUCT_CREATE',
     'DELETE FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT'),
    ("PRODUCT   INSERT", 'P_DMF0044_SALES_REPORT_PRODUCT_CREATE',
     'INSERT INTO SCM_MGR.DM_MOBILE_REPORT_PRODUCT'),
    ("MOBILE    DELETE SALES_PLAN(DT2)", 'P_DMF0044_MOBILE_REPORT_CREATE',
     'DELETE FROM DM_PLN_SALES_PLAN_REPORT_C'),
    ("MOBILE    INSERT SALES_PLAN(DT2)", 'P_DMF0044_MOBILE_REPORT_CREATE',
     'INSERT INTO DM_PLN_SALES_PLAN_REPORT_C'),
]

ok = True
try:
    for label, proc, needle in STEPS:
        s = stmt(proc, needle)
        blk = "DECLARE" + DECL + "BEGIN\n" + s + ";\n    :rc := SQL%ROWCOUNT;\nEND;"
        rc = cur.var(oracledb.NUMBER)
        t0 = time.time()
        try:
            cur.execute(blk, {"rc": rc})
            n = rc.getvalue()
            print(f"  {label:<34} {time.time()-t0:>7.2f}초  {int(n) if n is not None else 0:>9,} 행   OK")
        except Exception as e:
            ok = False
            print(f"  {label:<34} {time.time()-t0:>7.2f}초  ⛔ {str(e)[:160]}")
            break
finally:
    con.rollback()
    print("\n[정리] 전체 ROLLBACK — 커밋된 변경 0")

print("\n" + "#" * 96)
print(f"  Transfer 잔여 구간 사전 점검 : {'✅ 전 단계 통과 (실제 제약까지 검증)' if ok else '⛔ 실패 구간 있음'}")
print("#" * 96)
con.close()
