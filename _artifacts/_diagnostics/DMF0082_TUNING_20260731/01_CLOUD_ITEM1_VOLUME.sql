-- =============================================================================
-- 01_CLOUD_ITEM1_VOLUME.sql — [튜닝 항목1] 클라우드 축소율·집계보존 사전 확인
--   ⚠ READ-ONLY. 변경 없음. 계정: SCM_MGR
--
--   사내 적용 완료분(2026-07-31)을 클라우드에 이관하기 전에,
--   ① 클라우드에서도 같은 축소 효과가 나는지  ② 집계가 보존되는지 를 먼저 확인합니다.
--   (사내와 데이터 분포가 달라 축소율이 다를 수 있음)
-- =============================================================================
SET LINESIZE 220
SET PAGESIZE 100
SET FEEDBACK ON
SPOOL DMF0082_ITEM1_CLOUD.txt

PROMPT ############################################################
PROMPT [1] 축소율 — division 40 / 81 / 82 (한 번에)
PROMPT     접두 집합을 1회 선계산(GROUP BY) 후 JOIN — 상관 서브쿼리 없음
PROMPT ############################################################
WITH P AS (  -- division 별 site-item 12자리 접두 집합 (distinct 1회 선계산)
  SELECT DIVISION_ID, SUBSTR(ITEM_ID,1,12) K
    FROM SCM_MST_SITE_ITEM
   WHERE DIVISION_ID IN ('40','81','82')
   GROUP BY DIVISION_ID, SUBSTR(ITEM_ID,1,12))
SELECT T.DIVISION_ID                       AS DIVISION,
       COUNT(*)                            AS 현재_ORI_V,
       COUNT(P.K)                          AS 접두필터후   -- P 매칭 행만 카운트
  FROM SCM_ITEM_M_SN T
  LEFT JOIN P ON  P.DIVISION_ID = T.DIVISION_ID
              AND P.K           = SUBSTR(T.ITEM_ID,1,12)
 WHERE T.DIVISION_ID IN ('40','81','82')
   AND T.ACTIVE_FLAG = 'Y'
 GROUP BY T.DIVISION_ID
 ORDER BY T.DIVISION_ID;
-- P 는 (DIVISION_ID, K) distinct 이므로 LEFT JOIN 이 행을 불리지 않음
-- ⭐ 사내 실측: 40 = 98,346 → 20,730 (−79%) / 81 = 64,480 → 13,326 (−79%)

PROMPT ############################################################
PROMPT [2] ⭐⭐ 집계 보존 검증 — 이게 0 이어야 적용 가능
PROMPT     (필터후 집계) MINUS (필터전 집계) = 0행
PROMPT     40 / 81 / 82 를 한 문장으로 동시 판정 (분할 실행 불필요)
PROMPT ############################################################
WITH P AS (
  SELECT DIVISION_ID, SUBSTR(ITEM_ID,1,12) K
    FROM SCM_MST_SITE_ITEM
   WHERE DIVISION_ID IN ('40','81','82')
   GROUP BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)),
BEFORE_AGG AS (  -- 필터 전 집계 (현행 SP 결과와 동일)
  SELECT DIVISION_ID, SUBSTR(ITEM_ID,1,12) K,
         MAX(FORECAST_INFO_PRODUCT_GROUP)   C1, MAX(FORECAST_INFO_CELL_MODEL)      C2,
         MAX(FORECAST_INFO_CELL_PACK_COUNT) C3, MAX(FORECAST_INFO_SPEC)            C4,
         MAX(FORECAST_INFOR_VERSION)        C5, MAX(CELL_TYPE)                     C6
    FROM SCM_ITEM_M_SN
   WHERE DIVISION_ID IN ('40','81','82') AND ACTIVE_FLAG = 'Y'
   GROUP BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)),
AFTER_AGG AS (   -- 필터 후 집계 (패치본과 동일 의미 — 접두 JOIN = semi-join)
  SELECT T.DIVISION_ID, SUBSTR(T.ITEM_ID,1,12) K,
         MAX(FORECAST_INFO_PRODUCT_GROUP)   C1, MAX(FORECAST_INFO_CELL_MODEL)      C2,
         MAX(FORECAST_INFO_CELL_PACK_COUNT) C3, MAX(FORECAST_INFO_SPEC)            C4,
         MAX(FORECAST_INFOR_VERSION)        C5, MAX(CELL_TYPE)                     C6
    FROM SCM_ITEM_M_SN T
    JOIN P ON  P.DIVISION_ID = T.DIVISION_ID
           AND P.K           = SUBSTR(T.ITEM_ID,1,12)
   WHERE T.DIVISION_ID IN ('40','81','82') AND T.ACTIVE_FLAG = 'Y'
   GROUP BY T.DIVISION_ID, SUBSTR(T.ITEM_ID,1,12)),
DIFF  AS (SELECT * FROM AFTER_AGG MINUS SELECT * FROM BEFORE_AGG),
KDIFF AS (SELECT DIVISION_ID, K FROM AFTER_AGG MINUS SELECT DIVISION_ID, K FROM BEFORE_AGG)
SELECT A.DIVISION_ID                AS DIVISION,
       A.CNT                        AS 필터후_그룹수,
       NVL(D.CNT, 0)                AS 집계_불일치,
       NVL(KD.CNT, 0)               AS 키_불일치
  FROM      (SELECT DIVISION_ID, COUNT(*) CNT FROM AFTER_AGG GROUP BY DIVISION_ID) A
  LEFT JOIN (SELECT DIVISION_ID, COUNT(*) CNT FROM DIFF      GROUP BY DIVISION_ID) D
         ON D.DIVISION_ID = A.DIVISION_ID
  LEFT JOIN (SELECT DIVISION_ID, COUNT(*) CNT FROM KDIFF     GROUP BY DIVISION_ID) KD
        ON KD.DIVISION_ID = A.DIVISION_ID
 ORDER BY A.DIVISION_ID;
--
-- ⭐ 판정 (division 별 행)
--   집계_불일치 = 0  AND  키_불일치 = 0   → ✅ 적용 가능 (사내 40=0/0, 81=0/0 확인)
--   하나라도 > 0                          → ⛔ 적용 금지. 클라우드 데이터에 사내와 다른
--                                            품목 구성이 있다는 뜻이므로 회신 요망

PROMPT ############################################################
PROMPT [3] 참고 — SCM_ITEM_M_SN / SCM_MST_SITE_ITEM 규모 대조
PROMPT ############################################################
SELECT 'SCM_ITEM_M_SN'     AS T, DIVISION_ID, COUNT(*) CNT
  FROM SCM_ITEM_M_SN     WHERE DIVISION_ID IN ('40','81','82') GROUP BY DIVISION_ID
UNION ALL
SELECT 'SCM_MST_SITE_ITEM', DIVISION_ID, COUNT(*)
  FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID IN ('40','81','82') GROUP BY DIVISION_ID
 ORDER BY 1, 2;
-- 사내: SCM_MST_SITE_ITEM 40=22,525 / 81=52,526 / 82=37,423

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT 회신 요망: DMF0082_ITEM1_CLOUD.txt
PROMPT  ⭐ [2] 의 집계_불일치 / 키_불일치 가 **모두 0** 이어야 이관합니다.
PROMPT     (division 40 / 81 / 82 각각 &DIV 를 바꿔 3회 실행)
PROMPT =============================================================
