-- ============================================================================
-- SDM1010 전용 고객 콤보 신설 (2026-08-13 — 저장 후 재조회 실종 실사고 정정)
--   결함: 공용 'EndCustomer' 콤보는 div 40 에서 CODE=PROJECT_CODE(SITE_ITEM) 반환 —
--   신 PKG §1/§5 의 고객 INNER JOIN 도메인 = SCM_MST_SITE (DIVISION_ID, END_CUSTOMER).
--   40 에서 콤보 값으로 저장하면 조회에서 영구 소실 (div 40·'DJI' 실측 재현).
--   공유 콤보 덮어쓰기 금지(소비자 다수) → 조인 도메인과 1:1 인 전용 콤보 신설.
-- ============================================================================
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M (SQL_ID, SQL_DTL_CTN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SpmsEndCustomer', 'SELECT DISTINCT A.END_CUSTOMER AS CODE, A.END_CUSTOMER AS NAME
FROM SCM_MST_SITE A
WHERE A.END_CUSTOMER IS NOT NULL AND A.END_CUSTOMER <> ''-''
  AND ( NVL(TRIM(@divisionId),''ALL'') = ''ALL'' OR A.DIVISION_ID = @divisionId )
ORDER BY 1', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X WHERE X.SQL_ID = 'SpmsEndCustomer');

-- TAB1 고객 셀 콤보 = 전용 콤보로 교체 (메타 주도 — FE 자동 소비)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_COMBO_DATA_TYPE = 'SpmsEndCustomer', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROGRAM_ID='SDM1010' AND SHEET_NAME='TAB1' AND COLUMN_NAME='END_CUSTOMER';
