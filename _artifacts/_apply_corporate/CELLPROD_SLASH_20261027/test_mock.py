"""모의 행 재현 (같은 세션 UPDATE/INSERT → 조회 → ROLLBACK · 커밋 없음)
  81 BMW_US_SPA / APBMW48CL-B1-2L0 실적 원장 CELL_PROD_SITE_ID '-' → '/' + Column Set 에 CELL_PROD_SITE_ID 추가 → MKT_FCST 줄 수"""
import sys, collections
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_LASTUPD_20261027"); import test_before_after as T
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE '%E20261027-CELLPRODDASH%'")
print("BODY 마커", cur.fetchone()[0])
ITEM, SITE, USR = "APBMW48CL-B1-2L0", "BMW_US_SPA", "minyonglee1"
for mock in (False, True):
    for addcp in (False, True):
        n_upd = 0
        if mock:
            cur.execute("UPDATE SCM_MGR.DM_PLN_SALES_PLAN_RESULT SET CELL_PROD_SITE_ID = '/' WHERE SCM_SITE_ID=:s AND ITEM_ID=:i AND CELL_PROD_SITE_ID='-'", s=SITE, i=ITEM)
            n_upd = cur.rowcount
        if addcp:
            cur.execute("""INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                           SELECT :u,'DMF0082','FcstNPrice','C','CELL_PROD_SITE_ID',255,'N','admin',SYSDATE,'admin',SYSDATE FROM DUAL
                           WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE USER_ID=:u AND PROGRAM_ID='DMF0082' AND USER_INQUIRY_COLUMN_TYPE_CODE='C' AND COLUMN_NAME='CELL_PROD_SITE_ID')""", u=USR)
        cols, rows, rc = T.call(cur, T.PROCS[0], "81", "20260101", "20261231", USR, "ALL", SITE)
        con.rollback()
        ii, mi = cols.index("ITEM_ID"), cols.index("MEASURE")
        ci = cols.index("CELL_PROD_SITE_ID") if "CELL_PROD_SITE_ID" in cols else None
        hit = [r for r in rows if r[ii] == ITEM]
        by_meas = collections.Counter(r[mi] for r in hit)
        print(f"모의'/' {str(mock):5s} {n_upd:3d}행 | Column Set CELL_PROD {str(addcp):5s} | 결과 {len(rows)}줄 · 품목 {len(hit)}줄 · 메저별 {dict(by_meas)} · CP값 {sorted({str(r[ci]) for r in hit}) if ci is not None else None} · rc {rc}")
cur.execute("SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT WHERE SCM_SITE_ID=:s AND ITEM_ID=:i AND CELL_PROD_SITE_ID='/'", s=SITE, i=ITEM)
print("ROLLBACK 확인 — 원장 '/' 잔존:", cur.fetchone()[0])
