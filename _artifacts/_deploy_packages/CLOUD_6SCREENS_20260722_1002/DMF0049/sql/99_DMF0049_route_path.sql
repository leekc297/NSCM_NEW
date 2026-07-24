-- =====================================================================
-- 99_DMF0049_route_path.sql — 메뉴 Table ROUTE_PATH 등록 (클라우드 viewRegistry 2단 규약)
-- 규약: ROUTE_PATH = '<features 도메인>/<페이지 폴더명>' (메뉴 트리 3단 경로 아님)
-- ⚠ 반드시 메타 SQL 순번 '마지막' 실행 — 01/P1 안의 구(3단) 파생값을 2단 정본으로 덮음
-- 멱등: 컬럼 부재 시 ALTER ADD 자동, UPDATE 재실행 안전
-- =====================================================================
DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt
    FROM all_tab_columns
   WHERE owner = 'SCM_MGR' AND table_name = 'SCM_ADM_MNU_M' AND column_name = 'ROUTE_PATH';
  IF v_cnt = 0 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE SCM_MGR.SCM_ADM_MNU_M ADD (ROUTE_PATH VARCHAR2(4000))';
  END IF;
END;
/

UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET ROUTE_PATH = 'demand/etc-sales-reports'
 WHERE MNU_ID = 'DMF0049';

COMMIT;

-- 검증 (ROUTE_PATH = 'demand/etc-sales-reports' 1행)
SELECT MNU_ID, MNU_URL, ROUTE_PATH
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID = 'DMF0049';
