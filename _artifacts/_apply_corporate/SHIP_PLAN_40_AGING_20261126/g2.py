# GTT 세션 통계 수집이 트랜잭션을 커밋하는지 확인(사내). 다른 GTT 에 미커밋 행 → 수집 → 트랜잭션 ID, ROLLBACK 뒤 행 수
import sys, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 120000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
c.execute("INSERT INTO GT_SSP_ANL_SHIP_PLAN_40 (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY) "
          "SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY FROM SSP_ANL_SHIP_PLAN_40 WHERE DIVISION_ID='40' AND PLAN_START_YYYYMMDD='20261121' AND ATTRIBUTE10='HQ00'")
print('적재', c.rowcount)
c.execute("SELECT DBMS_TRANSACTION.LOCAL_TRANSACTION_ID FROM DUAL"); print('txn 전', c.fetchone()[0])
t = time.time()
c.execute("BEGIN DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SSP_ANL_SHIP_PLAN_40'); END;")
print('수집 %.2fs' % (time.time() - t))
c.execute("SELECT DBMS_TRANSACTION.LOCAL_TRANSACTION_ID FROM DUAL"); print('txn 후', c.fetchone()[0])
c.execute("SELECT NUM_ROWS, SCOPE FROM USER_TAB_STATISTICS WHERE TABLE_NAME='GT_SSP_ANL_SHIP_PLAN_40'"); print('통계', c.fetchall())
c.execute("SELECT NUM_ROWS, SCOPE FROM ALL_TAB_STATISTICS WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_SSP_ANL_SHIP_PLAN_40'"); print('통계(ALL)', c.fetchall())
cx.rollback()
c.execute("SELECT COUNT(*) FROM GT_SSP_ANL_SHIP_PLAN_40"); print('ROLLBACK 뒤 GT 행', c.fetchone()[0])
