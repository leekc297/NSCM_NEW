"""MOBILE_REPORT_CREATE 검증 실패 시 같은 트랜잭션의 선행 DML 이 되돌려지는지 실측 (BEFORE/AFTER 공용).
선행 DML = 중복 행(DATA_SEQ 342) 1행의 ATTRIBUTE10 을 'DUPRB_TEST' 로 UPDATE (미커밋) → MOBILE 호출 → 같은 세션에서 값 확인 → 무조건 ROLLBACK."""
import sys, datetime
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
import oracledb
tag = sys.argv[1]
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
V='R_S_20261002_V001_C'
print(tag, "AT", datetime.datetime.now().isoformat(timespec='seconds'))
cur.execute("SELECT SEND_YN, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') FROM DM_MDF_VERSION WHERE DIVISION_ID='40' AND VERSION_NO=:v", v=V); print(" version before", cur.fetchone())
cur.execute("UPDATE DM_PLN_SALES_ETC_REPORT_C SET ATTRIBUTE10='DUPRB_TEST' WHERE VERSION_NO=:v AND DIVISION_ID='40' AND DATA_SEQ=342 AND MEASURE='SalesAmt_LOC'", v=V)
print(" pre-DML rows", cur.rowcount)
rc = cur.var(oracledb.CURSOR)
cur.callproc("PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE", ['40', V, 'REPORT_SP_W', 'T', 'minyonglee1', rc])
print(" MOBILE msg:", [r[0][:60] for r in rc.getvalue()])
cur.execute("SELECT NVL(ATTRIBUTE10,'<NULL>') FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID='40' AND DATA_SEQ=342 AND MEASURE='SalesAmt_LOC'", v=V)
print(" pre-DML value after MOBILE (same session):", cur.fetchone()[0], "-> 'DUPRB_TEST' = 선행 변경 살아남음 / '<NULL>' = ROLLBACK 됨")
c.rollback()
c2 = oracledb.connect(user=u,password=p,dsn=d); k=c2.cursor()
k.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE ATTRIBUTE10='DUPRB_TEST'"); print(" leftover test value (other session):", k.fetchone()[0])
k.execute("SELECT SEND_YN, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') FROM DM_MDF_VERSION WHERE DIVISION_ID='40' AND VERSION_NO=:v", v=V); print(" version after", k.fetchone())
