"""저장 SP 직접 호출 시험 — 세트 174 복사 payload ('^' bulk, 36 IN)."""
import sys, datetime
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
V, DIV, SEQ, USER = 'R_S_20261002_V001_C', '40', 174, 'minyonglee1'
print("E2E AT", datetime.datetime.now().isoformat(timespec='seconds'))
cur.execute("""SELECT DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS,
       CURRENCY, COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, ITEM_USE, SOLDTO_COUNTRY,
       SHIPTO_COUNTRY, END_CUSTOMER, CELL_MODEL_INFO, ATTRIBUTE3, MEASURE, YYYYMMDD, QTY
  FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d AND DATA_SEQ=:s AND MEASURE <> 'LOC' ORDER BY MEASURE, YYYYMMDD""", v=V, d=DIV, s=SEQ)
cols=[x[0] for x in cur.description]; rows=[dict(zip(cols,r)) for r in cur.fetchall()]
def s(x): return '' if x is None else str(x)
def call(label, cust=None):
    R = rows
    def j(f): return '^'.join(f(r) for r in R)
    args = [j(lambda r:'I'), j(lambda r:''), j(lambda r:DIV), j(lambda r:V), j(lambda r:''),
            j(lambda r:s(r['DEPARTMENT_ID'])), j(lambda r:''), j(lambda r:''), j(lambda r:s(r['DEPT_ID'])),
            j(lambda r:cust if cust else s(r['CUST_REPORT'])), j(lambda r:s(r['END_CUST_REPORT'])), j(lambda r:s(r['SOLDTO_CODE'])),
            j(lambda r:s(r['SOLDTO_CUST_REPORT'])), j(lambda r:s(r['PRODUCT_GROUP'])), j(lambda r:s(r['ITEM_ID'])), j(lambda r:s(r['PRODUCT_DETAILS'])),
            j(lambda r:s(r['CURRENCY'])), j(lambda r:s(r['COMPANY_ID'])), j(lambda r:s(r['BIZ_TYPE'])), j(lambda r:s(r['APPLICATION_GR'])),
            j(lambda r:s(r['APPLICATION'])), j(lambda r:s(r['COUNTRY_CODE'])), j(lambda r:s(r['PROJECT_CODE'])), j(lambda r:s(r['SCM_SITE_ID'])),
            j(lambda r:s(r['FCST_TYPE'])), j(lambda r:s(r['ITEM_USE'])), j(lambda r:s(r['SOLDTO_COUNTRY'])), j(lambda r:s(r['SHIPTO_COUNTRY'])),
            j(lambda r:s(r['END_CUSTOMER'])), j(lambda r:''), j(lambda r:s(r['CELL_MODEL_INFO'])), j(lambda r:s(r['ATTRIBUTE3'])),
            j(lambda r:s(r['MEASURE'])), j(lambda r:s(r['YYYYMMDD'])[:6]), j(lambda r:s(r['QTY'])), USER]
    rc = cur.var(oracledb.CURSOR)
    cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d", v=V, d=DIV); before = cur.fetchone()[0]
    cur.callproc("PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C", args + [rc])
    msg = [r[0] for r in rc.getvalue()]
    cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d", v=V, d=DIV); after = cur.fetchone()[0]
    print(f"== {label}: payload {len(R)}행 · 원장 {before} → {after}")
    print("   MSG:", (msg[0] if msg else None).replace('\n', ' / ')[:600])
call("T1 세트 174 와 같은 키로 신규 저장")
call("T2 Cust.(Report)=ZZ_DUPTEST 로 신규 저장", cust='ZZ_DUPTEST')
# 시험 행 정리 (T2 로 들어간 행 · 이력)
cur.execute("DELETE FROM DM_PLN_SALES_ETC_REPORT_H WHERE VERSION_NO=:v AND DIVISION_ID=:d AND CUST_REPORT='ZZ_DUPTEST'", v=V, d=DIV); h=cur.rowcount
cur.execute("DELETE FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d AND CUST_REPORT='ZZ_DUPTEST'", v=V, d=DIV); m=cur.rowcount
c.commit()
cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d", v=V, d=DIV)
print(f"== 정리: 원장 {m}행 · 이력 {h}행 삭제 → 원장 {cur.fetchone()[0]}행")
cur.execute("SELECT TO_CHAR(EVENT_DATE,'HH24:MI:SS'), LOG_TYPE, SUBSTR(DESCRIPTION,1,40) FROM SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME='DMF0049_SAVE_SALES_ETC_REPORT_C' AND EVENT_DATE >= SYSDATE - 5/1440 ORDER BY EVENT_DATE")
for r in cur: print('   LOG', r)
