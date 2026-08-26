# -*- coding: utf-8 -*-
"""DMF0051 BIZ 진단 ⓿ — 원장/마스터 규모·인덱스·버전 실측 (읽기 전용)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(title, sql, binds=None):
    print(f"\n=== {title} ===")
    try:
        cur.execute(sql, binds or {})
        cols = [c[0] for c in cur.description]
        print(" | ".join(cols))
        for r in cur.fetchall():
            print(" | ".join("" if x is None else str(x) for x in r))
    except Exception as e:
        print("ERR:", e)


q("테이블 통계", """
SELECT TABLE_NAME, NUM_ROWS, BLOCKS, LAST_ANALYZED
FROM ALL_TABLES WHERE OWNER='SCM_MGR'
AND TABLE_NAME IN ('DM_PLN_BP_FCST','DM_PLN_BP_FCST_C','SCM_MST_SITE_ITEM','SCM_MST_ITEM_SN',
                   'SCM_MST_SITE','SCM_MST_PROJECT','SCM_SYS_CALENDAR_M','SCM_MST_SSO_USER_INFO')
ORDER BY TABLE_NAME""")

q("인덱스", """
SELECT I.TABLE_NAME, I.INDEX_NAME, I.UNIQUENESS, I.NUM_ROWS,
       LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION) COLS
FROM ALL_INDEXES I JOIN ALL_IND_COLUMNS C
  ON C.INDEX_OWNER=I.OWNER AND C.INDEX_NAME=I.INDEX_NAME
WHERE I.TABLE_OWNER='SCM_MGR'
AND I.TABLE_NAME IN ('DM_PLN_BP_FCST','DM_PLN_BP_FCST_C','SCM_MST_SITE_ITEM','SCM_MST_SITE')
GROUP BY I.TABLE_NAME, I.INDEX_NAME, I.UNIQUENESS, I.NUM_ROWS
ORDER BY I.TABLE_NAME, I.INDEX_NAME""")

q("DM_PLN_BP_FCST_C 버전 분포 TOP20", """
SELECT DIVISION_ID, VERSION_NO, COUNT(*) CNT, MIN(YYYYMM) MN, MAX(YYYYMM) MX
FROM SCM_MGR.DM_PLN_BP_FCST_C
GROUP BY DIVISION_ID, VERSION_NO
ORDER BY CNT DESC FETCH FIRST 20 ROWS ONLY""")

q("DM_PLN_BP_FCST(live) division 분포", """
SELECT DIVISION_ID, COUNT(*) CNT, COUNT(DISTINCT SCM_SITE_ID) SITES, MIN(YYYYMM) MN, MAX(YYYYMM) MX
FROM SCM_MGR.DM_PLN_BP_FCST GROUP BY DIVISION_ID ORDER BY CNT DESC""")

q("SCM_MST_SITE_ITEM division 분포", """
SELECT DIVISION_ID, COUNT(*) CNT FROM SCM_MGR.SCM_MST_SITE_ITEM GROUP BY DIVISION_ID ORDER BY CNT DESC""")

q("SCM_COM_SQL_LOG DMF0051 최근 호출", """
SELECT LOG_SEQ, PROGRAM_ID, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') DT
FROM SCM_MGR.SCM_COM_SQL_LOG
WHERE UPPER(SQL_ID) LIKE '%DMF0051%' OR UPPER(PROGRAM_ID) LIKE '%DMF0051%'
ORDER BY LOG_SEQ DESC FETCH FIRST 10 ROWS ONLY""")

con.close()
