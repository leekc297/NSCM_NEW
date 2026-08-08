-- =====================================================================
-- DMF0082 — DM Planner (W/S) A/S·W/S 등록 지원 (2026-08-07 사용자 지시)
--   지시 원문: "DM Planner (W/S) 일때 A/S, W/S 메저가 등록 가능해야 합니다"
--              "AS-IS SOURCE 및 분석서 기준으로 해당 메저 나오도록" / 적용 범위 = DMF0082 만
--
-- [AS-IS 실측 근거]
--   ① "A/S·W/S 메저" 실체 = **FCST_TYPE(신규행 등록 시 FCST Type 선택지)**
--      DMF0082_FcstNPrice_Mgmt.cs:8650-8668 GetFcstType() → PARAM1 = NowGroupID
--      → SP UP_FX_GETCOMMONDATALIST_DM:72  IF @PARAM1 = N'DM Planner (W/S)'
--        → LOOKUP_TYPE='SALES_TYPE_CODE2' (WS/WSF/AS/ASF 4종 한정)
--        ELSE LOOKUP_TYPE='SALES_TYPE_CODE' AND NVL(ATTRIBUTE2,'')<>'Y' (WS/WSF 배제)
--      → .cs:2492 InsertRow() → :2572 SetCellTypeCombo(DefColumns.FcstType, dtWarrType)
--   ② measure 편집 권한: AS-IS DMF0082 에 W/S 등재 0건(전 화면 6건 전부 DMF0003×MKT_FCST)
--      → 본 건은 **신규 정책**. DMF0003 W/S 패턴(MKT_FCST 단일 × 81 계열 6 division) 파리티로 등재.
--
-- [적용 대상]
--   [1] CMBO 신규 'FcstTypeByUserGroupDMF0082' — 화면 전용(공유 FCST_TYPE_NOT_ETC 는 5화면 소비 → 무변경, hook #117 §3/§5)
--   [2] SHEET_COLUMNS DMF0082/FcstNPrice FCST_TYPE 셀 콤보를 신규 SQL_ID 로 교체
--   [3] GET_ADMIN_GROUP_MEASURE 에 'DM Planner (W/S)' × DMF0082 × 81 계열 6 × MKT_FCST 등재
--
-- 원복: 본 파일 말미 [ROLLBACK] 블록 참조
-- =====================================================================

-- ---------------------------------------------------------------------
-- [1] CMBO 신규 등록 (INSERT-only 멱등) — AS-IS SP 분기 1:1 재현
--     그룹 판정 = BE 자동 주입 @sesUserId 의 보유그룹(AUTHUNION 정책 정합).
--     ⚠️ FE comboParams 미전달 구조라 @sesUserId 외 바인드 사용 금지 (hook #59 사고 계보)
-- ---------------------------------------------------------------------
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
    (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'FcstTypeByUserGroupDMF0082', 'DM',
       'DMF0082 FCST Type (W/S 그룹 한정 분기 — AS-IS UP_FX_GetCommonDataList_DM 1:1)',
q'[SELECT CODE, NAME FROM (
  SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME, DISPLAY_SEQ
  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE  LOOKUP_TYPE = 'SALES_TYPE_CODE2'
  AND    VALID_YN = 'Y'
  AND    EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                 WHERE G.USER_ID = @sesUserId AND G.USER_GR_ID = 'DM Planner (W/S)' AND G.USE_YN = 'Y')
  UNION ALL
  SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME, DISPLAY_SEQ
  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE  LOOKUP_TYPE = 'SALES_TYPE_CODE'
  AND    VALID_YN = 'Y'
  AND    SEGMENT1 <> 'ETC'
  AND    NVL(ATTRIBUTE2, ' ') <> 'Y'
  AND    NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                     WHERE G.USER_ID = @sesUserId AND G.USER_GR_ID = 'DM Planner (W/S)' AND G.USE_YN = 'Y')
) ORDER BY DISPLAY_SEQ, CODE]',
       'Y', 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'FcstTypeByUserGroupDMF0082');

-- ---------------------------------------------------------------------
-- [2] SHEET_COLUMNS 셀 콤보 교체 (DMF0082/FcstNPrice FCST_TYPE 만)
-- ---------------------------------------------------------------------
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
SET    CELL_COMBO_DATA_TYPE = 'FcstTypeByUserGroupDMF0082'
     , LAST_UPDATED_BY      = 'admin'
     , LAST_UPDATE_DATE     = SYSDATE
WHERE  PROGRAM_ID  = 'DMF0082'
AND    SHEET_NAME  = 'FcstNPrice'
AND    COLUMN_NAME = 'FCST_TYPE'
AND    CELL_COMBO_DATA_TYPE = 'FCST_TYPE_NOT_ETC';

-- ---------------------------------------------------------------------
-- [3] measure 편집 권한 등재 — 'DM Planner (W/S)' × DMF0082 × 81 계열 × MKT_FCST
--     DMF0003 동일 그룹 등재 패턴(SEGMENT3 = 81/81_HD/81_HG/81_HM/81_ST/81_UC, SEGMENT4='MKT_FCST') 파리티.
--     ⚠️ TO-BE SP 는 `SEGMENT3 = p_division_id` 로 필터하므로 division 별 행이 각각 필요.
--     컬럼 매핑 = 기존 DMF0082 행(ADMIN 등) 구조 그대로 복제 + SEGMENT1/3/4 만 치환.
-- ---------------------------------------------------------------------
--   ⚠️ DDL 5층 cross-check (anti-simplification §1.4): NOT NULL = LOOKUP_TYPE/SEGMENT1~5/VALID_YN/
--      CREATION_DATE/LAST_UPDATE_DATE. **SEGMENT5 NOT NULL** — DMF0082 기존 15행 실값 전부 '-' (ORA-01400 방어).
--      DISPLAY_SEQ = measure 별 고정값 실측(MKT_FCST=6 / LOC=7 / VMI_In_Req=8 / SCM_FCST=5).
--      ATTRIBUTE1(TODAY_DAY_LIST 요일제한) = MKT_FCST 는 NULL (SCM_FCST 만 'MON').
INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GET_ADMIN_GROUP_MEASURE', 'DM Planner (W/S)', 'DMF0082', D.DIV, 'MKT_FCST', '-',
       6, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
FROM (SELECT '81' DIV FROM DUAL UNION ALL SELECT '81_HD' FROM DUAL UNION ALL SELECT '81_HG' FROM DUAL
      UNION ALL SELECT '81_HM' FROM DUAL UNION ALL SELECT '81_ST' FROM DUAL UNION ALL SELECT '81_UC' FROM DUAL) D
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
    WHERE X.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND   X.SEGMENT1 = 'DM Planner (W/S)' AND X.SEGMENT2 = 'DMF0082'
    AND   X.SEGMENT3 = D.DIV AND X.SEGMENT4 = 'MKT_FCST');

COMMIT;

-- =====================================================================
-- [검증]
-- =====================================================================
-- (1) CMBO 등록 (기대 1행)
SELECT SQL_ID, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'FcstTypeByUserGroupDMF0082';

-- (2) 셀 콤보 교체 (기대 FcstTypeByUserGroupDMF0082)
SELECT COLUMN_NAME, CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND COLUMN_NAME='FCST_TYPE';

-- (3) 공유 콤보 무변경 확인 (기대: FCST_TYPE_NOT_ETC 소비 화면 4개 — DMF0051_1/DMF0072×2/SCM0002 — DMF0082 제외)
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  CELL_COMBO_DATA_TYPE='FCST_TYPE_NOT_ETC' AND VALID_YN='Y' ORDER BY 1,2,3;

-- (4) W/S measure 권한 (기대 6행)
SELECT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, VALID_YN FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT1='DM Planner (W/S)' AND SEGMENT2='DMF0082'
ORDER BY SEGMENT3;

-- =====================================================================
-- [ROLLBACK] (필요 시)
-- UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET CELL_COMBO_DATA_TYPE='FCST_TYPE_NOT_ETC'
--  WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND COLUMN_NAME='FCST_TYPE';
-- DELETE FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE'
--  AND SEGMENT1='DM Planner (W/S)' AND SEGMENT2='DMF0082';
-- DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='FcstTypeByUserGroupDMF0082';
-- COMMIT;
-- =====================================================================
