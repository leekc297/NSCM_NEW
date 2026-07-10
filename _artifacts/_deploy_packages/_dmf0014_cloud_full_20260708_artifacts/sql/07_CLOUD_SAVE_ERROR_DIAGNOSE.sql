-- ============================================================================
-- DMF0014 클라우드 저장 -9994 2차 진단
--   전제: 06 결과 = 권한/시노님/API_M/BTN_MPG/PROC_M 전부 정상, PKG VALID.
--   => -9994 는 SP 본문 실행 중 던지는 SQL 오류. 두 갈래를 확인한다.
--      (A) 클라우드 body 가 아직 '수정 전(old)' 인가?  (B) 실제 ORA-xxxxx 무엇인가?
--   실행: 클라우드 DB, SCM_MGR 접속.
-- ============================================================================

-- ── (A) 수정본 여부 판별 — 사내 정상본의 고유 fix 마커 카운트 ────────────────
--   기대값(=사내 정상본)과 다르면(특히 0 이면) 클라우드는 OLD → 02/03 재배포 필요.
SELECT 'PKG_DMF0014.DEDUP_FIX_0708'  marker, COUNT(*) cnt, 2 expected
  FROM user_source WHERE name='PKG_DMF0014' AND type='PACKAGE BODY' AND text LIKE '%DEDUP FIX 07-08%'
UNION ALL
SELECT 'PKG_DMF0014.NORMALIZE_0708', COUNT(*), 1
  FROM user_source WHERE name='PKG_DMF0014' AND type='PACKAGE BODY' AND text LIKE '%NORMALIZE 07-08%'
UNION ALL
SELECT 'PKG_DMF0014.BUCKET_FIX_0706', COUNT(*), 4
  FROM user_source WHERE name='PKG_DMF0014' AND type='PACKAGE BODY' AND text LIKE '%BUCKET FIX 07-06%'
UNION ALL
SELECT 'PR_DM_PLN.FETCH_STATUS_FIX', COUNT(*), 2
  FROM user_source WHERE name='PR_DM_PLN_CUST_FCST_TO_MKT_FCST' AND type='PROCEDURE'
   AND text LIKE '%CUR_CAR_RESULT%NOTFOUND%';
-- 판정: cnt < expected (특히 0) → 클라우드 body 는 OLD.
--   조치 → @02_PKG_DMF0014_BODY.sql  및  @03_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql  재배포 후 재컴파일.


-- ── (B) 실제 오류 문자열 추출 — 저장 직후 실행 (에러 발생 직후가 정확) ────────
--   -9994 는 BE 래핑 코드. 진짜 원인 ORA-xxxxx 는 SP/BE 가 SCM_COM_SQL_LOG 에 남긴다.
SELECT TO_CHAR(execute_time,'HH24:MI:SS') t, sql_id,
       SUBSTR(exception, 1, 400) real_error
  FROM scm_com_sql_log
 WHERE exception IS NOT NULL
   AND (UPPER(sql_text) LIKE '%SAVE_CUST_FCST_UPLOAD_DATA%'
        OR sql_id LIKE '%callProc%')
   AND execute_time > SYSTIMESTAMP - INTERVAL '30' MINUTE
 ORDER BY execute_time DESC
 FETCH FIRST 5 ROWS ONLY;
-- real_error 의 ORA-01403(NO_DATA_FOUND)/ORA-01422(too many rows)/ORA-00904 등을 보고 원인 확정.


-- ── (C) 저장 SP 직접 1회 호출 (실오류 즉시 확인) — 실제 존재 키 1건으로 대체 ──
--   아래 값은 예시. 화면 조회에 나오는 실제 1행 식별자로 바꿔 실행하면 진짜 오류가 즉시 raise 됨.
/*
DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  SCM_MGR.PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA(
    'M','81','HLGP_KR_CHU','AE EV','AE EV','FCA','WSF','E','CUST_FCST','Customer FCST',
    'MI00-P','CELL','A15HC2006','ACEN1042I-A1','20260720','100','<클라우드로그인ID>', v_rc);
  DBMS_OUTPUT.PUT_LINE('OK');
END;
/
*/
