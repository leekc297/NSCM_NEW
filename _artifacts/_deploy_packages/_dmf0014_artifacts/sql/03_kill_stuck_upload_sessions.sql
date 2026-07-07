-- ============================================================================
-- DMF0014 Excel Upload 무반응/Lock 조치 — 멈춘(hang) 업로드 SP 세션 kill
--   증상: OK 클릭 시 무반응. BE 는 파일 수신·파싱 정상. 그러나 검증 SP
--         PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD → PR_DM_PLN_CUST_FCST_TO_MKT_FCST
--         내부의 EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DPCF_*'(DDL) 에서 동시 세션들이
--         library cache / cursor: mutex X / row cache mutex 경합으로 hang → BE 응답 없음.
--   ⚠️ 근본원인은 'TX row lock'(enq: TX)이 아니라 TRUNCATE DDL 의 라이브러리/커서/로우캐시
--      mutex 경합. 근본조치 = SP 의 TRUNCATE→DELETE (04_SP_..._DEPLOY.sql).
--   ⚠️ ALTER SYSTEM KILL SESSION 은 DBA(SYS 등) 권한 필요 (SCM_MGR 은 ORA-01031). DBA 실행.
--   ⚠️ 04 재배포(CREATE OR REPLACE)도 이 멈춘 세션들이 SP 를 물고 있으면 hang → 반드시 kill 선행.
-- ============================================================================

-- [1] 현재 멈춘 세션 식별 (SID/SERIAL# 는 매번 달라짐 — 실행 시점 재조회 필수)
SELECT s.SID, s.SERIAL#, s.STATUS, s.LAST_CALL_ET, s.EVENT, s.BLOCKING_SESSION,
       SUBSTR(q.SQL_TEXT,1,60) SQLTXT
  FROM V$SESSION s
  LEFT JOIN V$SQL q ON s.SQL_ID = q.SQL_ID
 WHERE s.EVENT LIKE 'library cache%'
    OR s.EVENT LIKE 'cursor: mutex%'
    OR s.EVENT LIKE 'row cache%'
    OR UPPER(q.SQL_TEXT) LIKE '%TRUNCATE TABLE GT_DPCF%'
    OR UPPER(q.SQL_TEXT) LIKE '%PR_DM_PLN_CUST_FCST%'
 ORDER BY s.LAST_CALL_ET DESC;

-- [2] 위 결과의 SID,SERIAL# 로 kill.
--     2026-07-08 01:3x 조회 시점 멈춘 세션 (TRUNCATE GT_DPCF_CALENDAR 정체):
--       SID 261 (SERIAL# 29223, ~2.3h, cursor: mutex X)
--       SID 393 (SERIAL# 26617, ~1.9h, row cache mutex)
--     ⚠️ 실제 kill 직전 [1] 재조회하여 SERIAL# 최신값으로 치환할 것 (ORA-00026 방지).
-- ALTER SYSTEM KILL SESSION '261,29223' IMMEDIATE;
-- ALTER SYSTEM KILL SESSION '393,26617' IMMEDIATE;

-- [3] kill 후 재확인 (0 행 = 정리 완료)
-- SELECT SID, SERIAL#, STATUS, EVENT FROM V$SESSION
--  WHERE EVENT LIKE 'library cache%' OR EVENT LIKE 'cursor: mutex%' OR EVENT LIKE 'row cache%';

-- [4] kill 완료 후 → 04_SP_PR_DM_PLN_truncate_to_delete_DEPLOY.sql 재배포(CREATE OR REPLACE)
--     → STATUS VALID + 잔존 TRUNCATE 0 확인. 이후 동시 업로드 재발 방지.
