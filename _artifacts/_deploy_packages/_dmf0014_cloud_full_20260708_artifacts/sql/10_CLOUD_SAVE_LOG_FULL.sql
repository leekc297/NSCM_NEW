-- ============================================================================
-- DMF0014 저장 -9994 — BE 가 실제로 실행한 호출문/바인드 전체 덤프
--   확정: DB(권한·API·PKG body·SP·PROC_M+OUT커서 PROC_RESULT) 전부 정상, SP 직접호출=OK.
--   목적: BE 가 SP 를 '어떻게' 호출했는지(SQL_TEXT/PARAMS)와 진짜 예외를 SCM_COM_SQL_LOG 에서 확인.
--   실행: 클라우드 DB, SCM_MGR 접속.  (SET LONG 넉넉히)
-- ============================================================================
SET LONG 200000
SET LINESIZE 400
SET PAGESIZE 200
COLUMN sql_text  FORMAT A200
COLUMN params    FORMAT A200
COLUMN exception FORMAT A300

-- 실패한 저장(=callProc) 최근 레코드 전체 — 실제 실행문 + 바인드 + 예외
SELECT TO_CHAR(execute_time,'HH24:MI:SS.FF3') t,
       sql_id,
       result_count,
       sql_text,
       params,
       exception
  FROM scm_com_sql_log
 WHERE sql_id = 'com.lgcns.nscm.callProc'
   AND (UPPER(sql_text) LIKE '%SAVE_CUST_FCST_UPLOAD_DATA%' OR exception IS NOT NULL)
   AND execute_time > SYSTIMESTAMP - INTERVAL '2' HOUR
 ORDER BY execute_time DESC
 FETCH FIRST 6 ROWS ONLY;

-- 확인 포인트:
--   1) sql_text 의 { call PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA(?, ?, ... ) }
--      → 물음표(바인드) 개수 = 18 인가? OUT 자리(마지막)가 커서로 잡혀 있는가?
--   2) params 에 17개 IN 값이 '^'-조인으로 정상인가? (createdByList 포함)
--   3) exception 이 'InvocationTargetException: null' 뿐인가, 그 아래 ORA/Java 원인이 더 있는가?
--   4) 같은 초에 2건씩 찍히면 = BE SystemLogAspect 예외 시 재실행(이중) 정황.
