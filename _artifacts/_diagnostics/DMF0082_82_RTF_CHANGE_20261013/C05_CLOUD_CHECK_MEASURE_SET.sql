-- =====================================================================================================
-- 82 사업부 — Sales Plan 의 메저 구성이 저장 전후로 달라졌는가 (클라우드 확인용 5차)
--   읽기 전용(SELECT 만) · 전체 실행(F5) 가능 · 값 입력 없음
--   작성 2026-10-13 · 사내오라클(59.19.252.148 ZIOUI1)에서 1문장 실행 확인
--   4차(C04) 결과: 지금 Sales Plan 에는 RTF 가 773행 있는데 10-09 스냅샷에는 RTF 가 0행이었다.
--   → 지금 / 스냅샷 / 수요 원장 세 곳의 메저별 행 수 · 수량을 나란히 본다 (82 · 당주 월요일 이후)
--     NOW_* = 지금 Sales Plan · SNAP_* = 가장 최근 마감 스냅샷 · LEDGER_* = 수요 원장(DM_PLN_MKT_FCST)
-- =====================================================================================================

SELECT 'X1' AS Q, SUBSTR(M.MEASURE, 1, 16) AS MEASURE
     , SUM(M.NOW_ROWS) AS NOW_ROWS, SUM(M.NOW_QTY) AS NOW_QTY
     , SUM(M.SNAP_ROWS) AS SNAP_ROWS, SUM(M.SNAP_QTY) AS SNAP_QTY
     , SUM(M.LEDGER_ROWS) AS LEDGER_ROWS, SUM(M.LEDGER_QTY) AS LEDGER_QTY
     , MAX(M.NOW_UPD_BY) AS NOW_UPD_BY, MAX(M.NOW_LAST_AT) AS NOW_LAST_AT
FROM   ( SELECT S.MEASURE, COUNT(*) AS NOW_ROWS, SUM(S.QTY) AS NOW_QTY, 0 AS SNAP_ROWS, 0 AS SNAP_QTY, 0 AS LEDGER_ROWS, 0 AS LEDGER_QTY
              , SUBSTR(MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.LAST_UPDATE_DATE), 1, 14) AS NOW_UPD_BY
              , TO_CHAR(MAX(S.LAST_UPDATE_DATE), 'MM-DD HH24:MI:SS') AS NOW_LAST_AT
         FROM   SCM_MGR.DM_PLN_SALES_PLAN S
         WHERE  S.DIVISION_ID = '82' AND S.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD')
         GROUP BY S.MEASURE
         UNION ALL
         SELECT X.MEASURE, 0, 0, COUNT(*), SUM(X.QTY), 0, 0, NULL, NULL
         FROM   SCM_MGR.DM_PLN_SALES_PLAN_C X
         WHERE  X.DIVISION_ID = '82' AND X.CUTOFF_YYYYMMDD_DATE >= TRUNC(SYSDATE) - 10
         AND    X.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD')
         AND    X.VERSION_NO = ( SELECT MAX(V.VERSION_NO) KEEP (DENSE_RANK LAST ORDER BY V.CUTOFF_YYYYMMDD, V.VERSION_NO)
                                 FROM   SCM_MGR.DM_PLN_SALES_PLAN_C V
                                 WHERE  V.DIVISION_ID = '82' AND V.CUTOFF_YYYYMMDD_DATE >= TRUNC(SYSDATE) - 10 )
         GROUP BY X.MEASURE
         UNION ALL
         SELECT F.MEASURE, 0, 0, 0, 0, COUNT(*), SUM(F.QTY), NULL, NULL
         FROM   SCM_MGR.DM_PLN_MKT_FCST F
         WHERE  F.DIVISION_ID = '82' AND F.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD')
         AND    ( F.MEASURE LIKE 'RTF%' OR F.MEASURE IN ('MKT_FCST', 'SCM_FCST', 'CUST_FCST', 'TMM_FCST') )
         GROUP BY F.MEASURE ) M
GROUP BY M.MEASURE
ORDER BY M.MEASURE;
