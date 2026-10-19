--------------------------------------------------------------------------------
-- DMF0044 : 대량 저장 개선 — [6/6] API 등록 메타 CLOB 전환
-- 마커     : E20260903-DMF0044CLOB
-- 대상     : SCM_MGR.SCM_ADM_PROC_M  (BE generic call-proc 의 파라미터 바인딩 타입 원천)
--------------------------------------------------------------------------------
-- ⚠ 05A(SPEC)·05B(BODY)와 **반드시 같은 배포 단위**로 적용할 것.
--    SP 는 CLOB 을 기대하는데 메타가 VARCHAR 로 남아 있으면 BE 가 jdbcType=VARCHAR 로
--    바인딩해 저장이 깨진다. 반대(메타만 먼저)도 동일하게 깨진다.
--
-- BE 코드 변경 : **불필요** (2026-09-03 원문 실측)
--   framework/base/BaseService.java L367~382 makeProcedure() 가 SCM_ADM_PROC_M 을
--   **파라미터 행 단위로 순회**하며 DATA_TP_CD 별 MyBatis 바인딩을 조립한다.
--       L374  VARCHAR   -> #{col, mode=IN, jdbcType=VARCHAR}
--       L377  CLOB      -> #{col, mode=IN, jdbcType=CLOB}     ← 이미 구현되어 있음
--   분기가 행마다 독립 적용되므로 파라미터 개수·위치 제약이 없다. 기존 CLOB 등록 36건이
--   모두 `data` 단일 파라미터인 것은 그 화면들이 JSON 단일 페이로드 방식이기 때문이지
--   코드 제약이 아니다.
--   ※ L414~ 에 값을 SQL 에 직접 문자열로 박는 구(舊) makeProcedure 가 하나 더 있으나
--     통째로 주석(/* … */) 처리된 죽은 코드다. 실행 경로는 L357 판 하나뿐이다.
--
-- 변경 범위 : IN 파라미터만 VARCHAR -> CLOB
--   PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C     : 22행 중 IN 21행
--   PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF  : 24행 중 IN 23행
--   합계 44행. OUT 행(result / PROC_RESULT)은 건드리지 않는다.
--
-- 멱등성 : DATA_TP_CD='VARCHAR' 인 IN 행만 대상. 재실행 시 0행 갱신.
--------------------------------------------------------------------------------

UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET DATA_TP_CD       = 'CLOB'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM IN ( 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C'
                  , 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF' )
   AND COL_TP_CD  = 'IN'
   AND DATA_TP_CD = 'VARCHAR';

COMMIT;

--------------------------------------------------------------------------------
-- 검증 ①  IN 행이 전부 CLOB 인가 (기대: IN_VARCHAR = 0, IN_CLOB = 21 / 23)
--------------------------------------------------------------------------------
SELECT PROC_NM
     , COUNT(*)                                                        AS TOT
     , SUM(CASE WHEN COL_TP_CD='IN' THEN 1 ELSE 0 END)                 AS IN_CNT
     , SUM(CASE WHEN COL_TP_CD='IN' AND DATA_TP_CD='CLOB'    THEN 1 ELSE 0 END) AS IN_CLOB
     , SUM(CASE WHEN COL_TP_CD='IN' AND DATA_TP_CD='VARCHAR' THEN 1 ELSE 0 END) AS IN_VARCHAR
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM IN ( 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C'
                  , 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF' )
 GROUP BY PROC_NM ORDER BY 1;

--------------------------------------------------------------------------------
-- 검증 ②  ⭐ 메타 타입 ↔ SP 실제 인자 타입 정합 (양쪽이 어긋나면 저장이 깨진다)
--          기대: 불일치 0행
--------------------------------------------------------------------------------
SELECT M.PROC_NM, M.SORT_ORD, M.COL_NM, M.DATA_TP_CD AS 메타타입, A.DATA_TYPE AS SP타입
  FROM SCM_MGR.SCM_ADM_PROC_M M
  JOIN ALL_ARGUMENTS A
    ON A.OWNER        = 'SCM_MGR'
   AND A.PACKAGE_NAME = SUBSTR(M.PROC_NM, 1, INSTR(M.PROC_NM,'.')-1)
   AND A.OBJECT_NAME  = SUBSTR(M.PROC_NM, INSTR(M.PROC_NM,'.')+1)
   AND A.POSITION     = M.SORT_ORD
   AND A.IN_OUT       = 'IN'
 WHERE M.PROC_NM IN ( 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C'
                    , 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF' )
   AND M.COL_TP_CD = 'IN'
   AND M.DATA_TP_CD <> A.DATA_TYPE
 ORDER BY M.PROC_NM, M.SORT_ORD;

--------------------------------------------------------------------------------
-- 검증 ③  SP 인자가 실제로 CLOB 인가 (05A/05B 적용 확인)
--          기대: 두 프로시저 모두 IN 전부 CLOB
--------------------------------------------------------------------------------
SELECT OBJECT_NAME, DATA_TYPE, COUNT(*) CNT
  FROM ALL_ARGUMENTS
 WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0044'
   AND OBJECT_NAME IN ('P_DMF0044_SAVE_SALES_PLAN_REPORT_C'
                      ,'P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF')
   AND IN_OUT='IN'
 GROUP BY OBJECT_NAME, DATA_TYPE ORDER BY 1,2;

--------------------------------------------------------------------------------
-- 원복 (필요 시 — 05A/05B 도 함께 원복해야 한다)
--------------------------------------------------------------------------------
-- UPDATE SCM_MGR.SCM_ADM_PROC_M
--    SET DATA_TP_CD='VARCHAR', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
--  WHERE PROC_NM IN ( 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C'
--                   , 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF' )
--    AND COL_TP_CD='IN' AND DATA_TP_CD='CLOB';
-- COMMIT;
