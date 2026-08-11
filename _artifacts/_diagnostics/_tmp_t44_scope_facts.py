#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""사용자 확정 사양 반영 전 사실확보 (조회 전용)
   사양: DMF0044 사용 표 = PLAN_REPORT_C / ETC 인 경우에만 ETC_REPORT_C 에도 추가 저장
         MAIN GRID 조회 = PLAN_REPORT_C
   확인 ① 현재 ETC 조회 분기 원문  ② 저장 SP 가 ETC_REPORT_C 를 다루는가  ③ AS-IS 는 어떤가
"""
import io, pathlib, re, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[①] 라이브 ETC 조회 분기 (L1471~1560) — 무엇을 어떻게 읽는가")
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN 1471 AND 1560 ORDER BY LINE""")
for ln, tx in cur.fetchall():
    print(f"  {ln:5d} | {tx.rstrip()[:160]}")

sec("[②] 저장 SP(P_DMF0044_SAVE_SALES_PLAN_REPORT_C) 가 다루는 표 전수")
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN 3753 AND 4440
                  AND REGEXP_LIKE(TEXT, '(MERGE\\s+INTO|INSERT\\s+INTO|UPDATE\\s+|DELETE\\s+FROM|FROM)\\s+\\S*(DM_PLN_SALES|ETC_REPORT)', 'i')
                ORDER BY LINE""")
rows = cur.fetchall()
for ln, tx in rows:
    print(f"  {ln:5d} | {tx.strip()[:160]}")
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN 3753 AND 4440 AND UPPER(TEXT) LIKE '%ETC_REPORT_C%'""")
print(f"\n  → 저장 SP 내 ETC_REPORT_C 언급 = {cur.fetchone()[0]} 건")

sec("[③] AS-IS 저장 SP(DMF0044_SAVE_SALES_PLAN_REPORT_C) 가 ETC_REPORT_C 를 쓰는가")
f = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL\AsIs_LGCE_SCMDEV_SP1_DDL.sql")
text = io.open(f, encoding="utf-8", errors="ignore").read()
m = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.\[DMF0044_SAVE_SALES_PLAN_REPORT_C\]', text, re.I)
start = m.start()
nxt = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.', text[start + 10:], re.I)
end = start + 10 + (nxt.start() if nxt else 0)
body = text[start:end]
base = text[:start].count("\n") + 1
hits = 0
for i, ln in enumerate(body.splitlines(), base):
    if re.search(r'(MERGE\s+INTO|INSERT\s+INTO|UPDATE|DELETE\s+FROM)\s+\S*(DM_PLN_SALES|ETC_REPORT)', ln, re.I):
        print(f"  AS-IS {i:7d} | {ln.strip()[:150]}")
        hits += 1
print(f"\n  → AS-IS 저장 SP 내 ETC_REPORT_C DML = "
      f"{len(re.findall(r'ETC_REPORT_C', body, re.I))} 회 언급 / DML 라인 {hits}")

sec("[④] ETC_REPORT_C ↔ PLAN_REPORT_C 컬럼 차이 (추가 저장 시 매핑 난이도)")
show(*fetch(cur, """
SELECT NVL(a.column_name, b.column_name) col,
       CASE WHEN a.column_name IS NULL THEN 'PLAN 에만'
            WHEN b.column_name IS NULL THEN 'ETC 에만' ELSE '양쪽' END loc,
       a.nullable etc_null, b.nullable plan_null
  FROM (SELECT column_name, nullable FROM all_tab_columns
         WHERE owner='SCM_MGR' AND table_name='DM_PLN_SALES_ETC_REPORT_C') a
  FULL OUTER JOIN (SELECT column_name, nullable FROM all_tab_columns
         WHERE owner='SCM_MGR' AND table_name='DM_PLN_SALES_PLAN_REPORT_C') b
    ON a.column_name = b.column_name
 WHERE a.column_name IS NULL OR b.column_name IS NULL
 ORDER BY loc, col"""))
cur.execute("""SELECT
   (SELECT COUNT(*) FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name='DM_PLN_SALES_ETC_REPORT_C'),
   (SELECT COUNT(*) FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name='DM_PLN_SALES_PLAN_REPORT_C')
   FROM DUAL""")
e, pl = cur.fetchone()
print(f"  컬럼 수: ETC_REPORT_C {e} / PLAN_REPORT_C {pl}")

sec("[⑤] ETC_REPORT_C PK (추가 저장 시 MERGE ON 키)")
show(*fetch(cur, """SELECT cc.position, cc.column_name FROM all_constraints c
                      JOIN all_cons_columns cc ON cc.owner=c.owner AND cc.constraint_name=c.constraint_name
                     WHERE c.owner='SCM_MGR' AND c.table_name='DM_PLN_SALES_ETC_REPORT_C'
                       AND c.constraint_type='P' ORDER BY cc.position"""))

con.close()
