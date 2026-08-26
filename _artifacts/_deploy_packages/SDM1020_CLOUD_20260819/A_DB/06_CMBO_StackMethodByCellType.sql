-- =====================================================================================
-- SDM1020 — [06] CMBO 신설 1본: StackMethodByCellType
-- 원천: 사내 Oracle SCM_ADM_CMBO_SQL_M.SQL_DTL_CTN 신선 덤프 2026-08-19 (338자 —
--   `_apply_corporate/SDM1020_META_20260819/06_CMBO.sql` 와 대조 드리프트 0 실측).
-- 기존 콤보 수정 절대 금지(hook #59 §5-G) — Division/DpjtClass/EndCustomerByDivisionDept/
--   CellTypeByDivision/BizTypeByDivision/PlantByDivisionCompany/EndCustomerByDivision 은
--   기존재 전제(00_CLOUD_PRECHECK [P6]) — 본 파일 미포함.
-- ⛔ DpjtDevelopStatus 콤보: lookup 'SPMS_DPJT_DEVELOP_STATUS' MASTER/DETAIL 0행(사내 실측)이라
--   사내·클라우드 공히 미등재(빈 콤보) — lookup 신설 후 후속 등재 (README 미결 아님·전 환경 동일 상태).
-- 토큰 가드: NVL(TRIM(@x),'ALL')='ALL' 전체 반환 / @cellType 전달 시 SEG2 센티널 '-' 행 항상 포함.
-- 멱등: SQL_ID 한정 DELETE 후 INSERT.
-- =====================================================================================
DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'StackMethodByCellType';

INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('StackMethodByCellType', 'CM',
        'SDM Stack Method by Cell Type (SPMS_CELL_STACK_METHOD SEG1=div/SEG2=cellType -=all/SEG4,5)',
        'SELECT L.SEGMENT4 AS CODE, L.SEGMENT5 AS NAME
FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
WHERE L.LOOKUP_TYPE = ''SPMS_CELL_STACK_METHOD'' AND L.VALID_YN = ''Y''
  AND ( NVL(TRIM(@divisionId),''ALL'') = ''ALL'' OR L.SEGMENT1 = @divisionId )
  AND ( NVL(TRIM(@cellType),''ALL'') = ''ALL'' OR L.SEGMENT2 = ''-'' OR L.SEGMENT2 = @cellType )
ORDER BY L.DISPLAY_SEQ',
        'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;
