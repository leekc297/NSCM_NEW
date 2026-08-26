-- =====================================================================================
-- SDM5010 Project Master — [04] CMBO 신설 (DpjtDevelopStatus 1본만)
-- 2026-08-19 · StackMethodByCellType 신설 관례(SDM1020 06_CMBO) 승계 · 감사컬럼 'admin'
-- 기존 콤보 수정 절대 금지 — 기존재 실측 (2026-08-19):
--   Division / DpjtRegCat(⛔ 미등재 — 아래 보고) / DpjtClass / EndCustomerByDivisionDept /
--   CellTypeByDivision / StackMethodByCellType / BizTypeByDivision / DmBizType /
--   PlantByDivisionCompany / EndCustomerByDivision / MyDivision : 등재분 전부 무수정.
-- ⚠ DpjtRegCat: SHEET_COLUMNS(TAB1/TAB2 DPJT_REG_CAT)가 참조하나 CMBO 미등재 실측.
--   본 화면에서 해당 컬럼은 표시 전용(INPUT_TP 'S' — 승인 SP 파라미터 부재)이라 차단 결함
--   아님. 등재는 본 트랙 범위 외 — _CONTRACT.md 발견사항으로 보고.
-- 원천: 01_LOOKUP.sql 신설 SPMS_DPJT_DEVELOP_STATUS (SEG1=코드, SEG2=명칭).
--   division 비종속(설계서 조회조건도 SCM0001_GET_LOOKUP_VALUES 단일 lookup_type 호출) — 토큰 없음.
-- 멱등: SQL_ID 한정 DELETE 후 INSERT
-- 스모크 실측(2026-08-19): 본문 SQL 직접 실행 → 3행 (DEV 개발 / PROD 양산 / DROP Drop)
-- =====================================================================================
DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'DpjtDevelopStatus';

INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('DpjtDevelopStatus', 'CM',
        'SDM Project Develop Status (SPMS_DPJT_DEVELOP_STATUS SEG1=code/SEG2=name)',
        'SELECT L.SEGMENT1 AS CODE, L.SEGMENT2 AS NAME
FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
WHERE L.LOOKUP_TYPE = ''SPMS_DPJT_DEVELOP_STATUS'' AND L.VALID_YN = ''Y''
ORDER BY L.DISPLAY_SEQ',
        'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;
