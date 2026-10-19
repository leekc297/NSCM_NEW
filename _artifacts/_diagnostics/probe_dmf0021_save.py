"""사내 — DMF0021 저장 호출 형태: 문장 샘플 · 같은 초 호출 묶음 크기 · SYS_LOG SAVE 이벤트"""
import sys, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("""SELECT LOG_SEQ, TO_CHAR(CREATE_DATE,'YYYY-MM-DD HH24:MI:SS'), ELAPSED_MS, DBMS_LOB.SUBSTR(SQL_TEXT,2100,1)
                     FROM (SELECT * FROM SCM_MGR.SCM_COM_SQL_LOG WHERE SQL_ID='com.lgcns.nscm.callProc'
                             AND DBMS_LOB.INSTR(SQL_TEXT,'P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL(')>0 ORDER BY DBMS_LOB.GETLENGTH(SQL_TEXT) DESC) WHERE ROWNUM<=2""")
    for r in cur: print(r)
    cur.execute("SELECT POSITION, ARGUMENT_NAME, DATA_TYPE FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0021' AND OBJECT_NAME='P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL' ORDER BY POSITION")
    print(cur.fetchall())
    # 같은 사용자 · 같은 분 단위로 연속 호출 묶음 (행별 호출 여부)
    cur.execute("""SELECT TO_CHAR(CREATE_DATE,'YYYY-MM-DD HH24:MI') M, CREATED_BY, COUNT(*), SUM(ELAPSED_MS)
                     FROM SCM_MGR.SCM_COM_SQL_LOG WHERE SQL_ID='com.lgcns.nscm.callProc'
                      AND DBMS_LOB.INSTR(SQL_TEXT,'P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL(')>0
                    GROUP BY TO_CHAR(CREATE_DATE,'YYYY-MM-DD HH24:MI'), CREATED_BY ORDER BY 3 DESC FETCH FIRST 8 ROWS ONLY""")
    for r in cur: print("burst", r)
    cur.execute("""SELECT MNU_ID, MNU_BTN_CD, SHT_NM, COUNT(*), MAX(EXTRACT(DAY FROM (LOG_END_DTM-LOG_ST_DTM))*86400+EXTRACT(HOUR FROM (LOG_END_DTM-LOG_ST_DTM))*3600
                         +EXTRACT(MINUTE FROM (LOG_END_DTM-LOG_ST_DTM))*60+EXTRACT(SECOND FROM (LOG_END_DTM-LOG_ST_DTM))) MAX_SEC
                     FROM SCM_MGR.SCM_COM_SYS_LOG WHERE MNU_ID IN ('DMF0021','DMF0003','DMF0082') AND (UPPER(MNU_BTN_CD) LIKE '%SAVE%' OR UPPER(SHT_NM) LIKE '%SAVE%')
                    GROUP BY MNU_ID, MNU_BTN_CD, SHT_NM ORDER BY 1,2""")
    for r in cur: print("syslog", r)
