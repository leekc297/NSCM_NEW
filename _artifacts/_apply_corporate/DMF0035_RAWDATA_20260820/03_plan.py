# -*- coding: utf-8 -*-
"""g0w0gvnn7rkb2 실행 플랜 + access/filter predicate 전량 (사내 V$SQL_PLAN — 읽기 전용).

hook #129 순위 확인 축:
 ① SELECT 목록 상관 스칼라 서브쿼리 (행별 반복 실행)  ← 최우선
 ② access predicate 가 DIVISION_ID 단독인가 (VERPUSH 계열)
 ③ SARGable 여부
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

SQLID = "g0w0gvnn7rkb2"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("=== DBMS_XPLAN.DISPLAY_CURSOR (ALL) ===")
cur.execute("SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:s, NULL, 'ADVANCED ALLSTATS LAST'))", {"s": SQLID})
for r in cur.fetchall():
    print(r[0])

print("\n=== V$SQL_PLAN raw (ID/PID/OP/OBJ/CARD/COST + PREDICATES) ===")
cur.execute("""SELECT ID, PARENT_ID, DEPTH, OPERATION, OPTIONS, OBJECT_NAME, CARDINALITY, COST,
                      BYTES, ACCESS_PREDICATES, FILTER_PREDICATES
                 FROM V$SQL_PLAN WHERE SQL_ID=:s AND CHILD_NUMBER=0 ORDER BY ID""", {"s": SQLID})
for (i, pid, dep, op, opt, obj, card, cost, byt, acc, flt) in cur.fetchall():
    ind = " " * dep
    print(f"{i:>3} p{str(pid):<4} {ind}{op} {opt or ''} [{obj or ''}] card={card} cost={cost}")
    if acc:
        print(f"      {ind}ACCESS: {acc[:400]}")
    if flt:
        print(f"      {ind}FILTER: {flt[:400]}")

print("\n=== 원천표 통계/건수 ===")
for t in ("DM_PLN_MKT_FCST_C", "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "GT_DM35_T_LAST_SETUP_C",
          "GT_DM35_EDI_SENDER", "GT_DM35_SEL_MEASURE", "GT_DM35_VERSION", "SCM_MST_SITE"):
    cur.execute("""SELECT NUM_ROWS, BLOCKS, LAST_ANALYZED, TEMPORARY FROM ALL_TABLES
                    WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t""", {"t": t})
    r = cur.fetchone()
    print(f"  {t:<32} {r}")

print("\n=== 인덱스 (원천표) ===")
cur.execute("""SELECT I.TABLE_NAME, I.INDEX_NAME, I.UNIQUENESS,
                      LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION) COLS
                 FROM ALL_INDEXES I JOIN ALL_IND_COLUMNS C
                   ON C.INDEX_OWNER=I.OWNER AND C.INDEX_NAME=I.INDEX_NAME
                WHERE I.TABLE_OWNER='SCM_MGR'
                  AND I.TABLE_NAME IN ('DM_PLN_MKT_FCST_C','DM_PLN_CFM_MKT_DEMAND_PLAN_C',
                                       'GT_DM35_T_LAST_SETUP_C','GT_DM35_EDI_SENDER')
                GROUP BY I.TABLE_NAME, I.INDEX_NAME, I.UNIQUENESS ORDER BY 1,2""")
for r in cur.fetchall():
    print(f"  {r[0]:<30} {r[1]:<34} {r[2]:<9} {r[3]}")
con.close()
