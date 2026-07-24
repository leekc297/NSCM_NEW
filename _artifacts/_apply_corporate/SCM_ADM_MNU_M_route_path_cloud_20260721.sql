-- =====================================================================
-- [클라우드용] SCM_ADM_MNU_M.ROUTE_PATH — 컬럼 추가 + 계층 자동 파생 채움 (2026-07-21)
--
-- 배경: 메뉴 클릭 네비게이션 표준을 DB ROUTE_PATH 로 전환(route-paths.ts 폐기).
--   FE(useMDIStore)는 menu.routePath 우선, 부재 시 계층 MNU_URL join fallback —
--   파생값 = 루트~해당메뉴 MNU_URL '/' join 이므로 두 경로 결과 동일(무회귀).
--   ⚠ 전제: 각 메뉴 MNU_URL 이 FE Router slug 와 일치해야 함(3-SET).
--     사내 실측 정정분: DMF0003='mkt_forecast' / DMF0021='sales-plan' / DMF0082='forecast-price'.
--
-- 멱등: ① ALTER 는 ORA-01430(이미 존재) 무시 ② UPDATE 파생값은 계층 고정 → 재실행 안전.
-- 감사: 'admin' (hook #98).
-- =====================================================================

-- ① 컬럼 추가 (이미 있으면 skip)
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SCM_MGR.SCM_ADM_MNU_M ADD (ROUTE_PATH VARCHAR2(4000))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

-- ② 계층 자동 파생 채움 (전 메뉴)
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

-- ③ 검증 (기대: ROUTE_PATH NULL 0건 / DMF 화면 3건 경로 일치)
-- SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M WHERE ROUTE_PATH IS NULL;
-- SELECT MNU_ID, MNU_URL, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M
--  WHERE MNU_ID IN ('DMF0003','DMF0021','DMF0082');
--   기대: demand/demand-plan/mkt_forecast · demand/demand-plan/sales-plan · demand/demand-plan/forecast-price

-- 원복: UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = NULL; COMMIT;
--       (컬럼 자체 제거 시: ALTER TABLE SCM_MGR.SCM_ADM_MNU_M DROP COLUMN ROUTE_PATH;)
-- =====================================================================
