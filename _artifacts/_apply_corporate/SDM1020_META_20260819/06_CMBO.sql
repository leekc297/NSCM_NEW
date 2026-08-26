-- =====================================================================================
-- SDM1020 Project List — [06] CMBO 신설 (StackMethodByCellType 1본만)
-- 2026-08-19 · 기존 콤보 수정 절대 금지 — 기존재 실측:
--   Division / DpjtClass / EndCustomerByDivisionDept / CellTypeByDivision / BizTypeByDivision /
--   PlantByDivisionCompany / EndCustomerByDivision (조회조건) : 전부 SQL_ID 기등재 → 본 파일 미포함
-- ⛔ DpjtDevelopStatus : LOOKUP_TYPE 'SPMS_DPJT_DEVELOP_STATUS' 가 SCM_ADM_LOOKUP_MASTER 에 부재
--    (MASTER/DETAIL 0행 실측) → 등재 생략. lookup 신설 후 별도 등재 필요 — _CONTRACT.md 보고.
-- StackMethodByCellType 원천 실측:
--   SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='SPMS_CELL_STACK_METHOD'
--   SEG1=DIVISION_ID / SEG2=CELL_TYPE(현재 전 행 센티널 '-'=전 셀유형 공통) / SEG4=코드 / SEG5=명칭
--   (PKG_SDM1020 GET 커서의 SMD 서브쿼리와 동일 세그먼트 매핑)
-- 토큰 가드: 미전달 시 '' 치환 함정 → NVL(TRIM(@x),'ALL')='ALL' 전체 반환 (기존 CellTypeByDivision 패턴),
--   @cellType 전달 시 센티널 '-' 행은 항상 포함 (hook #119 §1.5 센티널=공통 행)
-- 멱등: SQL_ID 한정 DELETE 후 INSERT
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
