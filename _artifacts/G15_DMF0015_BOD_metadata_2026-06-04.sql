-- ============================================================================
-- DMF0015 BOD (Bill of Delivery) — 메타 SQL 7-BLOCK
-- AS-IS: GSCM/06.UIL/GSCM.DM.Master.UIL/DM0015_BOD.{cs,Designer.cs}
-- PoC: Phase 6 보완 4 + 5 + 9 통합 (Lookup SQL_ID + 메타 + column 메타)
-- 룰: Doc/_rules_v2/_tobe/12_metadata_sql.md (NOT EXISTS 멱등 INSERT)
-- ============================================================================

-- ============================================================================
-- BLOCK 1: i18n (LBL + MSG)
-- ============================================================================

-- LBL 3 (KO/EN/CN — i18n FE 의 KO.json/EN.json/CN.json 등록과 cross-check 의무)
-- 신규 라벨: LBL00378 (BOD Type) / LBL00379 (From Site) / LBL00380 (To Site)
-- ⚠️ DB 에 SCM_ADM_I18N_M 가 있다면 INSERT — 본 PoC scope 에서는 FE i18n 만으로 충분 가능

INSERT INTO SCM_ADM_I18N_M (CTGY_CD, MSG_CD, LANG_CD, MSG_CTN, UPD_ID, UPD_DT)
SELECT 'LBL', 'LBL00378', 'KO', 'BOD 유형', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_I18N_M WHERE CTGY_CD='LBL' AND MSG_CD='LBL00378' AND LANG_CD='KO');

INSERT INTO SCM_ADM_I18N_M (CTGY_CD, MSG_CD, LANG_CD, MSG_CTN, UPD_ID, UPD_DT)
SELECT 'LBL', 'LBL00378', 'EN', 'BOD Type', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_I18N_M WHERE CTGY_CD='LBL' AND MSG_CD='LBL00378' AND LANG_CD='EN');

INSERT INTO SCM_ADM_I18N_M (CTGY_CD, MSG_CD, LANG_CD, MSG_CTN, UPD_ID, UPD_DT)
SELECT 'LBL', 'LBL00378', 'CN', 'BOD 类型', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_I18N_M WHERE CTGY_CD='LBL' AND MSG_CD='LBL00378' AND LANG_CD='CN');

-- (LBL00379 / LBL00380 + KO/EN/CN 반복 동일 패턴 — 본 PoC scope 에서는 생략 명시)
-- 동일 패턴으로 LBL00379 (From Site) + LBL00380 (To Site) 의 KO/EN/CN 6 row INSERT

-- MSG 5 (MSG00071/117/118/128/130 — KO/EN/CN — 15 row)
INSERT INTO SCM_ADM_I18N_M (CTGY_CD, MSG_CD, LANG_CD, MSG_CTN, UPD_ID, UPD_DT)
SELECT 'MSG', 'MSG00071', 'KO', '먼저 Main 행을 선택하세요.', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_I18N_M WHERE CTGY_CD='MSG' AND MSG_CD='MSG00071' AND LANG_CD='KO');

-- (MSG00071 + EN/CN, MSG00117/118/128/130 + KO/EN/CN — 15 row 패턴 반복)

-- ============================================================================
-- BLOCK 2: 메뉴 등록 (SCM_ADM_MNU_M)
-- ============================================================================

INSERT INTO SCM_ADM_MNU_M (MNU_ID, MNU_NM, MNU_URL, UPPR_MNU_ID, MNU_TP_CD, ORDR_NO, USE_YN, INS_ID, INS_DT)
SELECT 'DMF0015', 'BOD Master', 'bod', 'Demand_Master', 'SCREEN', 150, 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0015');

-- ⚠️ UPPR_MNU_ID = 'Demand_Master' (PascalCase 표준 — 메모리 feedback_mnu_uppr_case_standard.md)
-- ⚠️ MNU_URL = 'bod' (slug only — 메모리 reference_scm_adm_mnu_m_url_slug.md)
-- ⚠️ MNU_TP_CD = 'SCREEN'

-- ============================================================================
-- BLOCK 3: Sheet 등록 (SCM_ADM_MNU_M_SHEET)
-- ============================================================================

INSERT INTO SCM_ADM_MNU_M_SHEET (MNU_ID, SHT_NM, SHT_DSP_NM, ORDR_NO, USE_YN, INS_ID, INS_DT)
SELECT 'DMF0015', 'main', 'BOD', 1, 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M_SHEET WHERE MNU_ID='DMF0015' AND SHT_NM='main');

INSERT INTO SCM_ADM_MNU_M_SHEET (MNU_ID, SHT_NM, SHT_DSP_NM, ORDR_NO, USE_YN, INS_ID, INS_DT)
SELECT 'DMF0015', 'bodItem', 'BOD Item', 2, 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M_SHEET WHERE MNU_ID='DMF0015' AND SHT_NM='bodItem');

-- ⚠️ Main sheet 의 SHT_NM = 'main' 표준 (메모리 feedback_sheet_name_main_standard.md)
-- ⚠️ Sub sheet 는 의미명 (bodItem) — 다중 sheet 의 경우 허용

-- ============================================================================
-- BLOCK 4: SP 파라미터 메타 (SCM_ADM_PROC_M)
-- ============================================================================

-- (a) P_DMF0015_GET_BOD_M — Main 조회
-- AS-IS DM.DM0015_GET_BOD_DATA 의 7 IN → TO-BE camelCase
-- p_division_id → divisionId / p_bod_type → bodType / p_from_site_id → fromSite /
-- p_to_site_id → toSite / p_group → sesGrId (BE 자동) / p_user_id → sesUserId (BE 자동) /
-- p_active_flag → activeFlag

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, COL_ORDR, DATA_TYPE, DATA_LENGTH, USE_YN, INS_ID, INS_DT)
SELECT 'P_DMF0015_GET_BOD_M', 'sesUserId', 'IN', 1, 'VARCHAR2', 20, 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM='P_DMF0015_GET_BOD_M' AND COL_NM='sesUserId' AND COL_TP_CD='IN');

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, COL_ORDR, DATA_TYPE, DATA_LENGTH, USE_YN, INS_ID, INS_DT)
SELECT 'P_DMF0015_GET_BOD_M', 'sesLangCd', 'IN', 2, 'VARCHAR2', 5, 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM='P_DMF0015_GET_BOD_M' AND COL_NM='sesLangCd' AND COL_TP_CD='IN');

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, COL_ORDR, DATA_TYPE, DATA_LENGTH, USE_YN, INS_ID, INS_DT)
SELECT 'P_DMF0015_GET_BOD_M', 'mnuId', 'IN', 3, 'VARCHAR2', 20, 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM='P_DMF0015_GET_BOD_M' AND COL_NM='mnuId' AND COL_TP_CD='IN');

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, COL_ORDR, DATA_TYPE, DATA_LENGTH, USE_YN, INS_ID, INS_DT)
SELECT 'P_DMF0015_GET_BOD_M', 'sesGrId', 'IN', 4, 'VARCHAR2', 20, 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM='P_DMF0015_GET_BOD_M' AND COL_NM='sesGrId' AND COL_TP_CD='IN');

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, COL_ORDR, DATA_TYPE, DATA_LENGTH, USE_YN, INS_ID, INS_DT)
SELECT 'P_DMF0015_GET_BOD_M', 'divisionId', 'IN', 5, 'VARCHAR2', 20, 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM='P_DMF0015_GET_BOD_M' AND COL_NM='divisionId' AND COL_TP_CD='IN');

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, COL_ORDR, DATA_TYPE, DATA_LENGTH, USE_YN, INS_ID, INS_DT)
SELECT 'P_DMF0015_GET_BOD_M', 'bodType', 'IN', 6, 'VARCHAR2', 4000, 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM='P_DMF0015_GET_BOD_M' AND COL_NM='bodType' AND COL_TP_CD='IN');

-- (fromSite, toSite, activeFlag IN + o_rc1 OUT — 동일 패턴 4 row 추가)

-- (b) P_DMF0015_GET_BOD_ITEM_M — Sub 조회 (2 IN: divisionId / bodId + 3 표준)
-- (c) P_DMF0015_SAVE_BOD_M — Main 저장 (CLOB JSON 안에 28 데이터)
--     AS-IS 28 IN ^ csv → TO-BE 1 CLOB (BE 가 JSON parse 후 처리)
-- (d) P_DMF0015_SAVE_BOD_ITEM_M — Sub 저장 (10 데이터 CLOB)

-- ============================================================================
-- BLOCK 5: API endpoint (SCM_ADM_API_M)
-- ============================================================================

INSERT INTO SCM_ADM_API_M (MNU_ID, SHT_NM, ACTION_TP, API_URL, API_TP_CD, API_MSG_ID, USE_YN, INS_ID, INS_DT)
SELECT 'DMF0015', 'main', 'RETRIEVE', 'PKG_DMF0015.P_GET_BOD_M', 'PKG_PROC', 'MSG_API_DMF0015_MAIN_RETRIEVE', 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE MNU_ID='DMF0015' AND SHT_NM='main' AND ACTION_TP='RETRIEVE');

INSERT INTO SCM_ADM_API_M (MNU_ID, SHT_NM, ACTION_TP, API_URL, API_TP_CD, API_MSG_ID, USE_YN, INS_ID, INS_DT)
SELECT 'DMF0015', 'main', 'SAVE', 'PKG_DMF0015.P_SAVE_BOD_M', 'PKG_PROC', 'MSG_API_DMF0015_MAIN_SAVE', 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE MNU_ID='DMF0015' AND SHT_NM='main' AND ACTION_TP='SAVE');

INSERT INTO SCM_ADM_API_M (MNU_ID, SHT_NM, ACTION_TP, API_URL, API_TP_CD, API_MSG_ID, USE_YN, INS_ID, INS_DT)
SELECT 'DMF0015', 'bodItem', 'RETRIEVE', 'PKG_DMF0015.P_GET_BOD_ITEM_M', 'PKG_PROC', 'MSG_API_DMF0015_BODITEM_RETRIEVE', 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE MNU_ID='DMF0015' AND SHT_NM='bodItem' AND ACTION_TP='RETRIEVE');

INSERT INTO SCM_ADM_API_M (MNU_ID, SHT_NM, ACTION_TP, API_URL, API_TP_CD, API_MSG_ID, USE_YN, INS_ID, INS_DT)
SELECT 'DMF0015', 'bodItem', 'SAVE', 'PKG_DMF0015.P_SAVE_BOD_ITEM_M', 'PKG_PROC', 'MSG_API_DMF0015_BODITEM_SAVE', 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE MNU_ID='DMF0015' AND SHT_NM='bodItem' AND ACTION_TP='SAVE');

-- ⚠️ API_TP_CD NOT NULL ('PKG_PROC')
-- ⚠️ API_MSG_ID NOT NULL (BLOCK 1 에 i18n 동반 등록)

-- ============================================================================
-- BLOCK 6: Grid Column Meta (SCM_ADM_MNU_M_SHEET_COLUMNS) — 보완 9
-- ============================================================================

-- Main sheet (29 column)
-- (1) BOD_ID — read-only (audit), CRUD_TYPE.INSERT 시 BE 자동 채움
INSERT INTO SCM_ADM_MNU_M_SHEET_COLUMNS (
    MNU_ID, SHT_NM, COL_NM, COL_HEAD, COL_WIDTH, COL_ALIGN,
    INPUT_TP_CD, CTRL_TP_CD, MODAL_KEY, IS_REQUIRED, IS_DISPLAY, ORDR_NO, USE_YN
)
SELECT 'DMF0015', 'main', 'BOD_ID', 'BOD', 120, 'center',
    'D', 'TEXT', NULL, 'N', 'Y', 1, 'Y' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M_SHEET_COLUMNS WHERE MNU_ID='DMF0015' AND SHT_NM='main' AND COL_NM='BOD_ID');

-- (2) DIVISION_ID — combo (MyDivision dataMap 등록 필요)
INSERT INTO SCM_ADM_MNU_M_SHEET_COLUMNS (
    MNU_ID, SHT_NM, COL_NM, COL_HEAD, COL_WIDTH, COL_ALIGN,
    INPUT_TP_CD, CTRL_TP_CD, MODAL_KEY, IS_REQUIRED, IS_DISPLAY, ORDR_NO, USE_YN
)
SELECT 'DMF0015', 'main', 'DIVISION_ID', 'Division', 80, 'center',
    'M', 'COMBO', NULL, 'Y', 'Y', 2, 'Y' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M_SHEET_COLUMNS WHERE MNU_ID='DMF0015' AND SHT_NM='main' AND COL_NM='DIVISION_ID');

-- (3~29) 동일 패턴 — BOD_TYPE/END_CUSTOMER/TO_SITE/HUB_SLOC/INCOTERMS/FROM_SITE/PRIORITY/
-- TRANSPORT_MODE/PER_MON~SUN(7)/POL/POD/FREIGHT_FORWARDER/SAFETY_STOCK/
-- PERIOD1_LT/POL_CLEARANCE_LT/PERIOD2_LT/POD_CLEARANCE_LT/PERIOD3_LT/LT_TOTAL(D)/
-- CUSTOMER_LT/VALID_YN/LAST_UPDATE_DATE(D)/LAST_UPDATED_BY(D)

-- BodItem sheet (10 column) — BOD_ID/DIVISION_ID/ITEM_ID(FPModal _modalKey='ITEM')/LOT_SIZE/
-- FROZEN_PERIOD/EFF_START_DATE/EFF_END_DATE/VALID_YN/LAST_UPDATE_DATE(D)/LAST_UPDATED_BY(D)

-- ITEM_ID 의 FPModal cell (G12 — ItemByDivisionModal 호출)
INSERT INTO SCM_ADM_MNU_M_SHEET_COLUMNS (
    MNU_ID, SHT_NM, COL_NM, COL_HEAD, COL_WIDTH, COL_ALIGN,
    INPUT_TP_CD, CTRL_TP_CD, MODAL_KEY, IS_REQUIRED, IS_DISPLAY, ORDR_NO, USE_YN
)
SELECT 'DMF0015', 'bodItem', 'ITEM_ID', 'Item ID', 120, 'center',
    'IO', 'FPModal', 'ITEM', 'Y', 'Y', 3, 'Y' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M_SHEET_COLUMNS WHERE MNU_ID='DMF0015' AND SHT_NM='bodItem' AND COL_NM='ITEM_ID');

-- 총 29 + 10 = 39 row column 메타 등록 (skeleton — 본 PoC 에서는 9 row 만 표시, 나머지 30 row 동일 패턴 INSERT)

-- ============================================================================
-- BLOCK 7: 권한 (USER_GR_MNU_MPG_M + USER_GR_MNU_BTN_MPG_M)
-- ============================================================================

-- 메뉴 권한 (5 권한 컬럼)
INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_ID, GR_ID, MNU_ID, FIND_AUTH_YN, INSERT_AUTH_YN, EDIT_AUTH_YN, SAVE_AUTH_YN, DELETE_AUTH_YN, USE_YN, INS_ID, INS_DT)
SELECT 'minyonglee1', 'ADMIN', 'DMF0015', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_ID='minyonglee1' AND GR_ID='ADMIN' AND MNU_ID='DMF0015');

-- 버튼 권한 (5 버튼)
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_ID, GR_ID, MNU_ID, BTN_ID, AUTH_YN, USE_YN, INS_ID, INS_DT)
SELECT 'minyonglee1', 'ADMIN', 'DMF0015', 'FIND', 'Y', 'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_ID='minyonglee1' AND GR_ID='ADMIN' AND MNU_ID='DMF0015' AND BTN_ID='FIND');

-- (INSERT/EDIT/SAVE/DELETE — 동일 패턴 4 row 추가)

-- ============================================================================
-- BLOCK 8 (보완 4): Lookup combo SQL (SCM_ADM_CMBO_SQL_M)
-- ============================================================================

-- BodType — DMF0015 신규 lookup (AS-IS Data.Type.BodType 변환)
INSERT INTO SCM_ADM_CMBO_SQL_M (SQL_ID, SQL_CTN, USE_YN, INS_ID, INS_DT)
SELECT 'BodType',
    'SELECT CODE_VAL AS CODE, CODE_NM AS NAME FROM SCM_ADM_CODE_M WHERE GROUP_ID = ''BOD_TYPE'' AND USE_YN = ''Y'' ORDER BY ORDR_NO',
    'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='BodType');

-- FromSiteByDivision
INSERT INTO SCM_ADM_CMBO_SQL_M (SQL_ID, SQL_CTN, USE_YN, INS_ID, INS_DT)
SELECT 'FromSiteByDivision',
    'SELECT s.SITE_ID AS CODE, s.SITE_NM AS NAME, s.DIVISION_ID FROM SCM_MST_SITE s WHERE s.DIVISION_ID = TO_CHAR(@divisionId) AND s.SITE_TYPE = ''FROM'' AND s.USE_YN = ''Y'' ORDER BY s.SITE_ID',
    'Y', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='FromSiteByDivision');

-- ⚠️ @varName 은 TO_CHAR(@varName) wrap 의무 (메모리 feedback_oracle_cmbo_quote_pitfall.md)

-- ToSiteByDivision (FromSiteByDivision 와 유사 — SITE_TYPE='TO')
-- TransportMode (Data.Type.TransportMode)
-- PortBySite (Data.Type.PortBySite)
-- 동일 패턴 4 row 추가 — skeleton 표시

-- ============================================================================
-- 검증 (별도 Verify SQL 에서 cross-check)
-- ============================================================================
-- - BLOCK 1 i18n: 24 row (LBL 3*3 + MSG 5*3)
-- - BLOCK 2 메뉴: 1 row
-- - BLOCK 3 sheet: 2 row
-- - BLOCK 4 PROC_M: 4 SP × ~10 param = 약 40 row (skeleton — 본 파일에는 6 표시)
-- - BLOCK 5 API_M: 4 row
-- - BLOCK 6 SHEET_COLUMNS: 29 + 10 = 39 row (skeleton — 본 파일에는 3 표시)
-- - BLOCK 7 권한: 1 메뉴 + 5 버튼 = 6 row
-- - BLOCK 8 CMBO_SQL_M: 6 row (보완 4 — BodType, FromSiteByDivision, ToSiteByDivision, TransportMode, PortBySite, Incoterms 등)

-- ============================================================================
-- 변경 이력
-- ============================================================================
-- 2026-06-04 — Phase 6 PoC 보완 4 + 5 + 9 통합 (메타 SQL 7-BLOCK skeleton)
COMMIT;
