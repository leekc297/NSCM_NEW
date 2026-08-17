#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 — AS_FROM_SITE 센티널 분열 재현 (hook #129 §9.1 R3).

증상(사용자 캡처 2026-08-15): 수정 저장 후 **동일 정적항목·동일 메저가 AS_FROM_SITE 만 다른 2행**으로 분리.
  화면상 1행은 `AS FROM SITE = '-'`, 다른 행은 공백.

§9.5 — 재현 파라미터는 **SP 입력 로그가 정본**. FE 코드 추정 금지.
"""
import io, json, re, sys, pathlib
from collections import Counter
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ── ① 실제 조회 파라미터 (SP 입력 로그) ────────────────────────────────────
cur.execute("""SELECT TO_CHAR(CREATION_DATE,'MM-DD HH24:MI:SS'), IN_PARA_DATA
               FROM SCM_SYS_LOG_BATCH
               WHERE PROGRAM_NAME LIKE '%DMF0003%GET_MKT_FCST%'
               AND IN_PARA_DATA IS NOT NULL
               ORDER BY CREATION_DATE DESC FETCH FIRST 3 ROWS ONLY""")
logs = cur.fetchall()
print("=== 최근 조회 입력 파라미터 ===")
for t, v in logs:
    s = v.read() if hasattr(v, 'read') else v
    print(f"   [{t}] {str(s)[:400]}")
if not logs:
    print("   ⛔ 로그 없음 — 화면에서 조회 1회 필요")

# ── ② SP 인자 시그니처 ────────────────────────────────────────────────────
cur.execute("""SELECT POSITION, ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS
               WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0003'
               AND OBJECT_NAME='P_DMF0003_GET_MKT_FCST_DATA' ORDER BY POSITION""")
args = cur.fetchall()
print(f"\n=== P_DMF0003_GET_MKT_FCST_DATA 인자 {len(args)}개 ===")
for r in args:
    print(f"   {r[0]:>2} {str(r[1]):<26}{r[2]:<12}{r[3]}")

# ── ③ AS_FROM_SITE 원천 = ATTRIBUTE10 의 원장 분포 ────────────────────────
print("\n=== 원장 ATTRIBUTE10 (= AS_FROM_SITE) 센티널 분포 ===")
for t in ['DM_PLN_MKT_FCST', 'DM_PLN_MKT_FCST_C',
          'DM_PLN_CFM_MKT_DEMAND_PLAN', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C']:
    try:
        cur.execute(f"""SELECT SUM(CASE WHEN ATTRIBUTE10 IS NULL THEN 1 ELSE 0 END),
                               SUM(CASE WHEN ATTRIBUTE10='-' THEN 1 ELSE 0 END),
                               SUM(CASE WHEN ATTRIBUTE10='--' THEN 1 ELSE 0 END),
                               SUM(CASE WHEN ATTRIBUTE10 IS NOT NULL
                                        AND TRIM(REPLACE(ATTRIBUTE10,CHR(0),'')) IS NULL THEN 1 ELSE 0 END),
                               COUNT(DISTINCT ATTRIBUTE10), COUNT(*)
                        FROM {t}""")
        nul, d1, d2, blank, dis, tot = [x or 0 for x in cur.fetchone()]
        flag = "⚠ 분열" if sum(1 for x in (nul, d1, d2, blank) if x) >= 2 else "  "
        print(f"   {flag} {t:<30} NULL={nul:>9,} '-'={d1:>9,} '--'={d2:>7,} 공백={blank:>7,} "
              f"distinct={dis:<5} / {tot:,}")
    except Exception as ex:
        print(f"   {t}: {str(ex)[:60]}")

# ── ④ 저장 SP 가 ATTRIBUTE10 에 무엇을 넣는가 ─────────────────────────────
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0003'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())
procs = [(m.start(), m.group(1)) for m in re.finditer(r"PROCEDURE\s+(\w+)", body)]
def owner(n):
    c = [x for x in procs if x[0] <= n]
    return c[-1][1] if c else '?'
print("\n=== 저장 경로의 ATTRIBUTE10 대입 (상위 12) ===")
seen = 0
for m in re.finditer(r"[^\n]*ATTRIBUTE10[^\n]*", body):
    o = owner(m.start())
    if 'SAVE' not in o.upper():
        continue
    ln = body[:m.start()].count("\n") + 1
    print(f"   L{ln:<7} [{o[:30]:<30}] {' '.join(m.group(0).split())[:74]}")
    seen += 1
    if seen >= 12:
        break
if seen == 0:
    print("   (저장 프로시저에 ATTRIBUTE10 직접 대입 없음 — 컬럼 목록 일괄 INSERT 가능성)")
con.close()
