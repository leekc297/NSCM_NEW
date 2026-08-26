# -*- coding: utf-8 -*-
"""L1610 문장의 IF 분기 위치 / 기존 마커 / 원천표 실측 (읽기 전용)."""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = [(ln, t.rstrip("\n")) for ln, t in cur.fetchall()]

print("=== 기존 E20260820 마커 ===")
for ln, t in src:
    if "E20260820" in t:
        print(f"  L{ln}: {t.strip()[:120]}")

print("\n=== L1400~L1615 IF/ELSIF/END IF 골격 ===")
for ln, t in src:
    if 1380 <= ln <= 1615:
        s = t.strip()
        if re.match(r"(IF|ELSIF|ELSE|END IF|INSERT INTO)\b", s, re.I):
            print(f"  L{ln}: {s[:150]}")

print("\n=== 원천표 통계/실측 ===")
for t in ("DM_PLN_MKT_FCST_C", "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "GT_DM35_T_LAST_SETUP_C",
          "GT_DM35_EDI_SENDER", "GT_DM35_SEL_MEASURE", "GT_DM35_VERSION", "SCM_MST_SITE",
          "GT_DM35_RAW_DATA"):
    cur.execute("""SELECT NUM_ROWS, BLOCKS, TEMPORARY, LAST_ANALYZED FROM ALL_TABLES
                    WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t""", {"t": t})
    print(f"  {t:<32} {cur.fetchone()}")

print("\n=== GT_DM35_T_LAST_SETUP_C / EDI_SENDER 컬럼 (NULL 허용 확인) ===")
for t in ("GT_DM35_T_LAST_SETUP_C", "GT_DM35_EDI_SENDER"):
    cur.execute("""SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE FROM ALL_TAB_COLUMNS
                    WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t ORDER BY COLUMN_ID""", {"t": t})
    print(f"  [{t}]")
    for r in cur.fetchall():
        print(f"    {r[0]:<24} {r[1]}({r[2]}) NULL={r[3]}")

print("\n=== 사내 V$SQL — PKG_DMF0035 GT_DM35_RAW_DATA 적재문 성적 상위 ===")
cur.execute("""SELECT SQL_ID, EXECUTIONS, ROUND(ELAPSED_TIME/1e6,1) EL_S,
                      ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),2) S_EXEC,
                      BUFFER_GETS, DISK_READS, ROWS_PROCESSED, SUBSTR(SQL_TEXT,1,60) T
                 FROM V$SQL
                WHERE SQL_TEXT LIKE 'INSERT INTO SCM_MGR.GT_DM35_RAW_DATA%'
                ORDER BY ELAPSED_TIME DESC FETCH FIRST 15 ROWS ONLY""")
for r in cur.fetchall():
    print("  ", r)
con.close()
