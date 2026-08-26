# -*- coding: utf-8 -*-
"""division 40 경로가 읽는 표(DM_PLN_CFM_MKT_DEMAND_PLAN_C)의 규모·인덱스 사내 실측 (읽기 전용).

배경: 병목 문장(GT_DM35_T_LAST_SETUP_C 적재)의 UNION ALL 은
  · P_DIVISION_ID='40' → DM_PLN_CFM_MKT_DEMAND_PLAN_C 분기
  · 그 외          → DM_PLN_MKT_FCST_C 분기
인데, 앞선 P4 인덱스 대조에서 **CFM_..._C 를 빠뜨렸다**(40 조회의 실제 원천인데 확인 안 함).
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

TABLES = ["DM_PLN_CFM_MKT_DEMAND_PLAN_C", "DM_PLN_MKT_FCST_C"]
GTTS = ["GT_DM35_SEL_MEASURE", "GT_DM35_VERSION", "GT_DM35_T_LAST_SETUP_C"]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("== 규모(통계 기준 — 즉시) ==")
cur.execute("""SELECT TABLE_NAME, NUM_ROWS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD') LA
               FROM ALL_TAB_STATISTICS WHERE OWNER='SCM_MGR' AND PARTITION_NAME IS NULL
               AND TABLE_NAME IN ('DM_PLN_CFM_MKT_DEMAND_PLAN_C','DM_PLN_MKT_FCST_C')""")
for r in cur.fetchall():
    print("  ", r)

print("\n== 인덱스 ==")
cur.execute("""SELECT I.TABLE_NAME, I.INDEX_NAME,
                      LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION) COLS
               FROM ALL_INDEXES I JOIN ALL_IND_COLUMNS C
                 ON C.INDEX_OWNER=I.OWNER AND C.INDEX_NAME=I.INDEX_NAME
               WHERE I.OWNER='SCM_MGR' AND I.TABLE_NAME IN ('DM_PLN_CFM_MKT_DEMAND_PLAN_C')
               GROUP BY I.TABLE_NAME, I.INDEX_NAME ORDER BY 2""")
rows = cur.fetchall()
print(f"   DM_PLN_CFM_MKT_DEMAND_PLAN_C 인덱스 {len(rows)}개")
for r in rows:
    print(f"   {r[1]:34} {r[2][:110]}")

print("\n== GTT 통계 설정 (ODS 의존 여부) ==")
for g in GTTS:
    cur.execute("""SELECT NUM_ROWS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI') LA
                   FROM ALL_TAB_STATISTICS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t
                   AND PARTITION_NAME IS NULL""", {"t": g})
    r = cur.fetchone()
    try:
        pref = cur.callfunc("DBMS_STATS.GET_PREFS", str,
                            ["GLOBAL_TEMP_TABLE_STATS", "SCM_MGR", g])
    except Exception as e:
        pref = f"(pref 조회 실패 {str(e)[:40]})"
    print(f"   {g:26} stats={r} / GLOBAL_TEMP_TABLE_STATS={pref}")
con.close()
