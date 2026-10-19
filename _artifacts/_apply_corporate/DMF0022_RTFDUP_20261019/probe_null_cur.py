"""CURRENCY 공란 원천 행 출처 조사 (사내) — SALES_PLAN(_C) 의 SCUD_CN_FOC / MCCM348014A3"""
import sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb

u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    for t in ("DM_PLN_SALES_PLAN", "DM_PLN_SALES_PLAN_C"):
        cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t ORDER BY COLUMN_ID", t=t)
        cols = [r[0] for r in cur]
        print(t, cols)
    q = """SELECT * FROM SCM_MGR.DM_PLN_SALES_PLAN_C
            WHERE VERSION_NO='SP_W_20260825_V002' AND DIVISION_ID='40' AND ITEM_ID='MCCM348014A3' AND SCM_SITE_ID='SCUD_CN_FOC'
              AND (CURRENCY IS NULL OR TRIM(CURRENCY) IN ('-','/'))"""
    cur.execute(q)
    names = [x[0] for x in cur.description]
    for r in cur:
        print({n: v for n, v in zip(names, r) if v is not None})
    # 같은 키 CNY 행의 마지막 날짜 · 감사컬럼 비교
    cur.execute("""SELECT MEASURE, MAX(YYYYMMDD), COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_C
                    WHERE VERSION_NO='SP_W_20260825_V002' AND DIVISION_ID='40' AND ITEM_ID='MCCM348014A3' AND SCM_SITE_ID='SCUD_CN_FOC'
                      AND INCOTERMS='DAP' AND CURRENCY='CNY' GROUP BY MEASURE ORDER BY 1""")
    print(cur.fetchall())
    # 사업부 40 전체에서 공란 통화 행의 기간 분포 (CURRENT)
    cur.execute("""SELECT SUBSTR(YYYYMMDD,1,6) YM, MEASURE, COUNT(*) CNT FROM SCM_MGR.DM_PLN_SALES_PLAN
                    WHERE DIVISION_ID='40' AND (CURRENCY IS NULL OR TRIM(CURRENCY) IN ('-','/'))
                    GROUP BY SUBSTR(YYYYMMDD,1,6), MEASURE ORDER BY 1,2""")
    for r in cur: print("CUR-NULL", r)
