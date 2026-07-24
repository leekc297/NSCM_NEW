-- =====================================================================
-- SCM_ADM_MNU_M.ROUTE_PATH — 계층 자동 파생 채움 (2026-07-21)
--
-- 배경: 메뉴 클릭 네비게이션을 DB ROUTE_PATH 로 구동(route-paths.ts 폐기)하기 위해,
--   각 메뉴의 전체 라우트 경로를 계층(UPPR_MNU_ID)에서 자동 파생.
--   = 루트~해당메뉴 MNU_URL 을 '/' 로 join (현행 FE findMenuPath join 과 동일 → 무회귀).
--   실측 검증: DMF0082='demand/demand-plan/forecast-price' 등 현행 중첩 Router 와 일치. NULL MNU_URL 0건.
--
-- 멱등(재실행 안전 — 파생값은 계층 고정). 감사 'admin'.
-- =====================================================================

UPDATE SCM_MGR.SCM_ADM_MNU_M t
   SET t.ROUTE_PATH = (
         SELECT LTRIM(SYS_CONNECT_BY_PATH(s.MNU_URL, '/'), '/')
         FROM   SCM_MGR.SCM_ADM_MNU_M s
         WHERE  s.MNU_ID = t.MNU_ID
         START WITH s.UPPR_MNU_ID IS NULL OR TRIM(s.UPPR_MNU_ID) IS NULL
         CONNECT BY PRIOR s.MNU_ID = s.UPPR_MNU_ID
       ),
       t.LAST_UPDATED_BY = 'admin',
       t.LAST_UPDATE_DATE = SYSDATE
 WHERE EXISTS (
         SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M s
         WHERE  s.MNU_ID = t.MNU_ID
         START WITH s.UPPR_MNU_ID IS NULL OR TRIM(s.UPPR_MNU_ID) IS NULL
         CONNECT BY PRIOR s.MNU_ID = s.UPPR_MNU_ID
       );

COMMIT;

-- 검증:
-- SELECT MNU_ID, MNU_URL, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M ORDER BY ROUTE_PATH;
-- 원복: UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = NULL; COMMIT;  (컬럼 신규라 전체 NULL 로 원복)
-- =====================================================================
