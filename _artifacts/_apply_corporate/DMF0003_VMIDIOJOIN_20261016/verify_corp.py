"""VMIDIOJOIN 사내 검증 — 진단 사용자(zz_diag_dmf0003)에 21 Measure 임시 설정 → 실행 → 즉시 삭제.
40: 적용 후 SP 결과 == 같은 세션 GT 로 실행한 '원래 조인 SQL'(적용 전 V$SQL 원문 dyn40.sql) 결과 (행 전체 대조) + 소요 시간
82/81: 생성된 최종 SQL 에 원래 VM 조인 문구가 그대로 있는지 (V$SQL 원문)"""
import sys,time,hashlib;sys.path.insert(0,r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora,oracledb
U='zz_diag_dmf0003'; DYN=sys.argv[1]
u,p,d=ora.conn_info();con=oracledb.connect(user=u,password=p,dsn=d);cur=con.cursor()
def h(rows): return hashlib.md5(repr(sorted(repr(r) for r in rows)).encode()).hexdigest()
OLDJ="""  ON  A.ITEM_ID     = CASE WHEN '{d}' = '40' THEN VM.KEY_JOIN ELSE A.ITEM_ID END
  AND ( '{d}' = '40'  
        OR A.SCM_SITE_ID = VM.KEY_JOIN )"""
def call(div):
    rc1=cur.var(oracledb.CURSOR);rc2=cur.var(oracledb.CURSOR);rc3=cur.var(oracledb.CURSOR);rs=cur.var(oracledb.CURSOR)
    t=time.time()
    cur.callproc('PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA',[div,'ALL','ALL','ALL','ALL','ALL','ALL','','20261001','20270331',U,U,'ALL','ALL','N','N','N','Y','','ALL',U,'DMF0003',rc1,rc2,rc3,rs])
    rows=rc1.getvalue().fetchall(); return time.time()-t, rows, rs.getvalue().fetchall()
def lastsql(marker):
    cur.execute("SELECT SQL_FULLTEXT FROM V$SQL WHERE PROGRAM_ID=(SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0003' AND OBJECT_TYPE='PACKAGE BODY') AND PROGRAM_LINE#>9500 AND DBMS_LOB.INSTR(SQL_FULLTEXT,:m)>0 ORDER BY LAST_ACTIVE_TIME DESC FETCH FIRST 1 ROW ONLY",m=marker)
    r=cur.fetchone(); return r[0].read() if r else ''
try:
    cur.execute("""INSERT INTO SCM_MST_TITLESET_USER (USER_ID,PROGRAM_ID,SHEET_NAME,USER_INQUIRY_COLUMN_TYPE_CODE,COLUMN_NAME,SORT_ORDER_NO,SUB_TOTAL_FLAG,DATA_SORT_METHOD_CODE,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
      SELECT :u,PROGRAM_ID,SHEET_NAME,'M',COLUMN_NAME,SORT_ORDER_NO,'N','',:u,SYSDATE,:u,SYSDATE FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst' AND VALID_YN='Y'""",u=U)
    con.commit()
    for run in (1,2):
        t,rows,res=call('40'); print('40 run%d %.1fs rows %d %s'%(run,t,len(rows),res))
    new_sql=lastsql("= VM.KEY_JOIN\n")
    print('40 생성 SQL 새 조인 포함:', "  ON  A.ITEM_ID     = VM.KEY_JOIN\n" in new_sql, '· 원래 CASE 조인 잔존:', 'THEN VM.KEY_JOIN ELSE' in new_sql)
    old=open(DYN,encoding='utf-8').read(); t=time.time(); cur.execute(old); orows=cur.fetchall()
    print('40 원래 조인 SQL %.1fs rows %d · 결과 전체 동일=%s'%(time.time()-t,len(orows),h(orows)==h(rows)))
    for div in ('82','81'):
        t,rows,res=call(div); s=lastsql("'%s' = '40'"%div)
        print(div,'%.1fs rows %d %s · 원래 조인 문구 그대로=%s'%(t,len(rows),res,OLDJ.format(d=div) in s))
finally:
    cur.execute("DELETE FROM SCM_MST_TITLESET_USER WHERE USER_ID=:u",u=U); print('cleanup',cur.rowcount); con.commit()
