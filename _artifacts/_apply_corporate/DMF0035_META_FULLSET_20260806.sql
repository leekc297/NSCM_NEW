-- ============================================================================================
-- DMF0035 Demand Plan Waterfall — 사내 Oracle 메타 전세트 (멱등 MERGE / 존재가드)
-- 작성: 2026-08-06 | 대상: SCM_MGR@OCGSCMD_P01 | 감사컬럼 = 'admin' 고정
-- 정본: Doc/화면분석서/DMF0035_DemandPlanWaterfall_ASIS_통합분석_v1.0.md §4.3·§5
-- FE 계약: nscm-fe/features/report/src/pages/demand-plan-waterfall/demand-plan-waterfall.constants.ts (SHEETS 7)
--          nscm-fe/configs/types/procedures.d.ts DMF0035 블록
-- 실측 근거(2026-08-06 본 세션):
--   * DDL 5층: SCM_ADM_MNU_M / SCM_ADM_API_M / SCM_ADM_PROC_M(PK PROC_NM,COL_NM,COL_TP_CD)
--     / SCM_ADM_MNU_BTN_MPG_M(PK MNU_ID,SHT_NM,MNU_BTN_CD) / SCM_ADM_USER_GR_MNU_BTN_MPG_M
--     / SCM_ADM_CMBO_SQL_M(PK SQL_ID,MDU_DIVS_CD) / SCM_ADM_MSG_M(PK MSG_ID,LANG_CD) — user_tab_columns 실측
--   * PKG 시그니처: user_arguments 실측 — P_DMF0035_GET_MKT_FCST_WATERFALL 21 IN+4 OUT /
--     P_DMF0035_GET_SPREAD_TITLE 5 IN+2 OUT / P_DMF0022_GET_SPREAD_TITLE 7 IN+2 OUT /
--     P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL 19 IN+3 OUT / P_DMF0051_GET_SPREAD_TITLE 7 IN+2 OUT
--   * 배선 체인: PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST = BTN_MPG(MNU,SHT,BTN)→API_M.API_URL→PROC_M.PROC_NM
--   * mnuId = GeneralController 가 URL path 로 주입 (FE payload 의 menuId 키와 무관 — DMF0022 검증 선례)
--   * COL_NM 규약 = DMF0022 GET 기존 25행 실측 (sesUserId/userId/mnuId/bizType camel)
--   * 템플릿 그룹: USER_GR_MNU_BTN_MPG_M MNU_ID='DMF0022' 실측 5그룹 (ADMIN/DM ADMIN/DM Planner/DM Viewer/SCP Planner)
--   * 기존재로 SKIP: SHEET_COLUMNS(DMF0035 71/DMF0022 65/DMF0051 61) · SHEET_MEASURE(49/31/9) ·
--     GR_MNU_MPG_M DMF0035 5그룹 · CMBO BucketType2(DM)·BucketType·SenderCode·ItemType·SALES_PLAN_AMOUNT_* ·
--     MSG00137/00108/00164/00097/00013/00109 · PROC_M(DMF0073 9행·PKG_DMF0022 GET 25행)
--   * MNU00179 = 'Version Popup' 점유 → 메뉴명 신규 채번 MNU00691 (MSG_M MNU max=MNU00690 실측·충돌 0 확인)
--   * LBL00774~776 = 'Mail Setup'/'Category *'/'Main *' 점유(비어있지 않음) → 무수정 (보고 항목)
-- ============================================================================================

-- ─────────────────────────────────────────────────────────────
-- BLOCK 005 : MSG_M — 메뉴명 MNU00691 'Demand Plan Waterfall' (KO/EN/CN)
-- DDL: SCM_ADM_MSG_M — NOT NULL: MSG_ID/LANG_CD/MSG_TP_CD/USE_YN/CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_MSG_M M
USING (
    SELECT 'MNU00691' AS MSG_ID, 'KO' AS LANG_CD FROM DUAL
    UNION ALL SELECT 'MNU00691', 'EN' FROM DUAL
    UNION ALL SELECT 'MNU00691', 'CN' FROM DUAL
) S
ON (M.MSG_ID = S.MSG_ID AND M.LANG_CD = S.LANG_CD)
WHEN NOT MATCHED THEN INSERT
    (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    (S.MSG_ID, S.LANG_CD, 'Demand Plan Waterfall',
     'DMF0035 Demand Plan Waterfall menu name (AS-IS DMF0035/DMF0022/DMF0051 integrated waterfall report)',
     'MNU', 'Y', 'admin', SYSDATE, 'admin', SYSDATE)
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 010 : MNU_M — DMF0035 UPDATE (기존 행 실측: USE_YN='N', MNU_URL='dmf0035',
--             MNU_MSG_ID='MNU00043'(MKT FCST Waterfall), ROUTE_PATH='report/waterfall/dmf0035')
-- 유지: UPPR_MNU_ID='Waterfall'(Report 트리 Lv3) / SORT_ORD=12 / MNU_LV_NO=3 / MNU_TP_CD='SCREEN' / UNIT_TP_CD='D'
-- slug 규약 = DMF0022 실측('sales-plan-waterfall' + 'report/waterfall/sales-plan-waterfall') 동형
-- 차이 가드로 재실행 시 no-op (멱등)
-- ─────────────────────────────────────────────────────────────
UPDATE SCM_ADM_MNU_M
   SET MNU_MSG_ID       = 'MNU00691'
     , MNU_DESC         = 'Demand Plan Waterfall (integrated AS-IS DMF0035 MKT FCST / DMF0022 Sales Plan / DMF0051 Biz Plan waterfall, read-only report)'
     , MNU_URL          = 'demand-plan-waterfall'
     , ROUTE_PATH       = 'report/waterfall/demand-plan-waterfall'
     , USE_YN           = 'Y'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0035'
   AND NOT (    MNU_MSG_ID = 'MNU00691'
            AND MNU_URL    = 'demand-plan-waterfall'
            AND ROUTE_PATH = 'report/waterfall/demand-plan-waterfall'
            AND USE_YN     = 'Y'
            AND MNU_DESC   = 'Demand Plan Waterfall (integrated AS-IS DMF0035 MKT FCST / DMF0022 Sales Plan / DMF0051 Biz Plan waterfall, read-only report)')
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 020 : API_M — 7 시트 GET(call-proc) 경로 (DMF0082 형식: {MNU}_{sheet}_SEARCH / PROC_SELECT)
-- DDL: NOT NULL API_ID/API_TP_CD/API_MSG_ID/API_URL/USE_YN + 감사 4 (API_MSG_ID 는 자유문자열 — MSG_M FK 아님, DMF0082 실측)
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_API_M M
USING (
    SELECT 'DMF0035_mktFcstWaterfall_SEARCH'    AS API_ID, 'PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL'          AS API_URL, 'DMF0035 MKT FCST Waterfall 메인 조회 (GUBUN=MKT_FCST)'        AS API_MSG_DESC FROM DUAL
    UNION ALL SELECT 'DMF0035_salesPlanWaterfall_SEARCH',   'PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL', 'DMF0035 Sales Plan Waterfall 메인 조회 (GUBUN=SALES_PLAN — PKG_DMF0022 재사용)' FROM DUAL
    UNION ALL SELECT 'DMF0035_bizPlanWaterfall_SEARCH',     'PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL',   'DMF0035 Biz Plan Waterfall 메인 조회 (GUBUN=BIZ_PLAN — PKG_DMF0051 재사용)' FROM DUAL
    UNION ALL SELECT 'DMF0035_mktFcstSpreadTitle_SEARCH',   'PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE',                'DMF0035 MKT FCST 동적 시간축 컬럼 조회' FROM DUAL
    UNION ALL SELECT 'DMF0035_salesPlanSpreadTitle_SEARCH', 'PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE',                'DMF0035 Sales Plan 동적 시간축 컬럼 조회 (PKG_DMF0022 재사용)' FROM DUAL
    UNION ALL SELECT 'DMF0035_bizPlanSpreadTitle_SEARCH',   'PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE',                'DMF0035 Biz Plan 동적 시간축 컬럼 조회 (PKG_DMF0051 재사용)' FROM DUAL
    UNION ALL SELECT 'DMF0035_version_SEARCH',              'DMF0073_GET_VERSION_SALESPRICE',                        'DMF0035 Version 팝업 조회 (DMF0073 9-arg 공유 계약 — DMF0082 선례)' FROM DUAL
) S
ON (M.API_ID = S.API_ID)
WHEN NOT MATCHED THEN INSERT
    (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    (S.API_ID, 'PROC_SELECT', 'MSG_API_' || S.API_ID, S.API_MSG_DESC, S.API_URL, 'Y',
     'admin', SYSDATE, 'admin', SYSDATE)
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 030-1 : PROC_M — PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL (user_arguments 21 IN + 4 OUT 실측 1:1)
-- COL_NM = FE procedures.d.ts DMF0035.mktFcstWaterfall request 키 (mnuId 만 BE path 주입 규약 — DMF0022 실측)
-- result 행 = DATA_TP_CD 'PROC_RESULT' + COL_TP_CD 'OUT' 표준 (메모리 feedback_proc_m_col_tp_cd_standard)
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_PROC_M M
USING (
    SELECT 'divisionId'   AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN' AS COL_TP_CD,  1 AS SORT_ORD FROM DUAL
    UNION ALL SELECT 'deptId',          'VARCHAR', 'IN',  2 FROM DUAL
    UNION ALL SELECT 'endCustomer',     'VARCHAR', 'IN',  3 FROM DUAL
    UNION ALL SELECT 'scmSiteId',       'VARCHAR', 'IN',  4 FROM DUAL
    UNION ALL SELECT 'projectCode',     'VARCHAR', 'IN',  5 FROM DUAL
    UNION ALL SELECT 'itemId',          'VARCHAR', 'IN',  6 FROM DUAL
    UNION ALL SELECT 'itemType',        'VARCHAR', 'IN',  7 FROM DUAL
    UNION ALL SELECT 'fromYyyymmdd',    'VARCHAR', 'IN',  8 FROM DUAL
    UNION ALL SELECT 'toYyyymmdd',      'VARCHAR', 'IN',  9 FROM DUAL
    UNION ALL SELECT 'sesUserId',       'VARCHAR', 'IN', 10 FROM DUAL
    UNION ALL SELECT 'plantSiteId',     'VARCHAR', 'IN', 11 FROM DUAL
    UNION ALL SELECT 'bizType',         'VARCHAR', 'IN', 12 FROM DUAL
    UNION ALL SELECT 'owner',           'VARCHAR', 'IN', 13 FROM DUAL
    UNION ALL SELECT 'versionNo',       'VARCHAR', 'IN', 14 FROM DUAL
    UNION ALL SELECT 'bucket',          'VARCHAR', 'IN', 15 FROM DUAL
    UNION ALL SELECT 'userDeptId',      'VARCHAR', 'IN', 16 FROM DUAL
    UNION ALL SELECT 'groupId',         'VARCHAR', 'IN', 17 FROM DUAL
    UNION ALL SELECT 'cellYn',          'VARCHAR', 'IN', 18 FROM DUAL
    UNION ALL SELECT 'senderCode',      'VARCHAR', 'IN', 19 FROM DUAL
    UNION ALL SELECT 'userId',          'VARCHAR', 'IN', 20 FROM DUAL
    UNION ALL SELECT 'mnuId',           'VARCHAR', 'IN', 21 FROM DUAL
    UNION ALL SELECT 'o_rc1',           'CURSOR',      'OUT', 22 FROM DUAL
    UNION ALL SELECT 'o_rc2',           'CURSOR',      'OUT', 23 FROM DUAL
    UNION ALL SELECT 'o_rc3',           'CURSOR',      'OUT', 24 FROM DUAL
    UNION ALL SELECT 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 25 FROM DUAL
) S
ON (M.PROC_NM = 'PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL' AND M.COL_NM = S.COL_NM AND M.COL_TP_CD = S.COL_TP_CD)
WHEN NOT MATCHED THEN INSERT
    (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL', S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD,
     'admin', SYSDATE, 'admin', SYSDATE)
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 030-2 : PROC_M — PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE (5 IN + 2 OUT 실측)
-- P_START/P_END ← FE 키 fromYyyymmdd/toYyyymmdd (FE 계약 정본 — BE 는 COL_NM 으로 payload 바인딩 실측)
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_PROC_M M
USING (
    SELECT 'fromYyyymmdd' AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN' AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL
    UNION ALL SELECT 'toYyyymmdd',      'VARCHAR', 'IN', 2 FROM DUAL
    UNION ALL SELECT 'sesUserId',       'VARCHAR', 'IN', 3 FROM DUAL
    UNION ALL SELECT 'divisionId',      'VARCHAR', 'IN', 4 FROM DUAL
    UNION ALL SELECT 'bucket',          'VARCHAR', 'IN', 5 FROM DUAL
    UNION ALL SELECT 'o_rc1',           'CURSOR',      'OUT', 6 FROM DUAL
    UNION ALL SELECT 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 7 FROM DUAL
) S
ON (M.PROC_NM = 'PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE' AND M.COL_NM = S.COL_NM AND M.COL_TP_CD = S.COL_TP_CD)
WHEN NOT MATCHED THEN INSERT
    (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE', S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD,
     'admin', SYSDATE, 'admin', SYSDATE)
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 030-3 : PROC_M — PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE (7 IN + 2 OUT 실측 — 기존 PROC_M 부재분 신규)
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_PROC_M M
USING (
    SELECT 'fromYyyymmdd' AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN' AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL
    UNION ALL SELECT 'toYyyymmdd',      'VARCHAR', 'IN', 2 FROM DUAL
    UNION ALL SELECT 'sesUserId',       'VARCHAR', 'IN', 3 FROM DUAL
    UNION ALL SELECT 'divisionId',      'VARCHAR', 'IN', 4 FROM DUAL
    UNION ALL SELECT 'bucket',          'VARCHAR', 'IN', 5 FROM DUAL
    UNION ALL SELECT 'userId',          'VARCHAR', 'IN', 6 FROM DUAL
    UNION ALL SELECT 'mnuId',           'VARCHAR', 'IN', 7 FROM DUAL
    UNION ALL SELECT 'o_rc1',           'CURSOR',      'OUT', 8 FROM DUAL
    UNION ALL SELECT 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 9 FROM DUAL
) S
ON (M.PROC_NM = 'PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE' AND M.COL_NM = S.COL_NM AND M.COL_TP_CD = S.COL_TP_CD)
WHEN NOT MATCHED THEN INSERT
    (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE', S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD,
     'admin', SYSDATE, 'admin', SYSDATE)
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 030-4 : PROC_M — PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL (19 IN + 3 OUT 실측)
-- FE 키: procedures.d.ts DMF0035.bizPlanWaterfall (qtyYn 포함, p_bucket/userDeptId/groupId 는 SP 미수신 — AS-IS §3.B)
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_PROC_M M
USING (
    SELECT 'divisionId' AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN' AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL
    UNION ALL SELECT 'deptId',          'VARCHAR', 'IN',  2 FROM DUAL
    UNION ALL SELECT 'endCustomer',     'VARCHAR', 'IN',  3 FROM DUAL
    UNION ALL SELECT 'scmSiteId',       'VARCHAR', 'IN',  4 FROM DUAL
    UNION ALL SELECT 'projectCode',     'VARCHAR', 'IN',  5 FROM DUAL
    UNION ALL SELECT 'itemId',          'VARCHAR', 'IN',  6 FROM DUAL
    UNION ALL SELECT 'itemType',        'VARCHAR', 'IN',  7 FROM DUAL
    UNION ALL SELECT 'fromYyyymmdd',    'VARCHAR', 'IN',  8 FROM DUAL
    UNION ALL SELECT 'nowYyyymmdd',     'VARCHAR', 'IN',  9 FROM DUAL
    UNION ALL SELECT 'toYyyymmdd',      'VARCHAR', 'IN', 10 FROM DUAL
    UNION ALL SELECT 'sesUserId',       'VARCHAR', 'IN', 11 FROM DUAL
    UNION ALL SELECT 'plantSiteId',     'VARCHAR', 'IN', 12 FROM DUAL
    UNION ALL SELECT 'bizType',         'VARCHAR', 'IN', 13 FROM DUAL
    UNION ALL SELECT 'owner',           'VARCHAR', 'IN', 14 FROM DUAL
    UNION ALL SELECT 'versionType',     'VARCHAR', 'IN', 15 FROM DUAL
    UNION ALL SELECT 'cellYn',          'VARCHAR', 'IN', 16 FROM DUAL
    UNION ALL SELECT 'qtyYn',           'VARCHAR', 'IN', 17 FROM DUAL
    UNION ALL SELECT 'userId',          'VARCHAR', 'IN', 18 FROM DUAL
    UNION ALL SELECT 'mnuId',           'VARCHAR', 'IN', 19 FROM DUAL
    UNION ALL SELECT 'o_rc1',           'CURSOR',      'OUT', 20 FROM DUAL
    UNION ALL SELECT 'o_rc2',           'CURSOR',      'OUT', 21 FROM DUAL
    UNION ALL SELECT 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 22 FROM DUAL
) S
ON (M.PROC_NM = 'PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL' AND M.COL_NM = S.COL_NM AND M.COL_TP_CD = S.COL_TP_CD)
WHEN NOT MATCHED THEN INSERT
    (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL', S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD,
     'admin', SYSDATE, 'admin', SYSDATE)
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 030-5 : PROC_M — PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE (7 IN + 2 OUT 실측)
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_PROC_M M
USING (
    SELECT 'fromYyyymmdd' AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN' AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL
    UNION ALL SELECT 'toYyyymmdd',      'VARCHAR', 'IN', 2 FROM DUAL
    UNION ALL SELECT 'sesUserId',       'VARCHAR', 'IN', 3 FROM DUAL
    UNION ALL SELECT 'divisionId',      'VARCHAR', 'IN', 4 FROM DUAL
    UNION ALL SELECT 'bucket',          'VARCHAR', 'IN', 5 FROM DUAL
    UNION ALL SELECT 'userId',          'VARCHAR', 'IN', 6 FROM DUAL
    UNION ALL SELECT 'mnuId',           'VARCHAR', 'IN', 7 FROM DUAL
    UNION ALL SELECT 'o_rc1',           'CURSOR',      'OUT', 8 FROM DUAL
    UNION ALL SELECT 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 9 FROM DUAL
) S
ON (M.PROC_NM = 'PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE' AND M.COL_NM = S.COL_NM AND M.COL_TP_CD = S.COL_TP_CD)
WHEN NOT MATCHED THEN INSERT
    (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE', S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD,
     'admin', SYSDATE, 'admin', SYSDATE)
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 040 : MNU_BTN_MPG_M — FE SHEETS enum 7시트 × SEARCH (hook #68 안티패턴 13 — 보조 시트 누락 금지)
-- version 시트 = DMF0073 공유 PROC_M(기존 9행) 재사용 (DMF0082_version_SEARCH 선례)
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_MNU_BTN_MPG_M M
USING (
    SELECT 'mktFcstWaterfall' AS SHT_NM, 'DMF0035_mktFcstWaterfall_SEARCH' AS API_ID FROM DUAL
    UNION ALL SELECT 'salesPlanWaterfall',   'DMF0035_salesPlanWaterfall_SEARCH'   FROM DUAL
    UNION ALL SELECT 'bizPlanWaterfall',     'DMF0035_bizPlanWaterfall_SEARCH'     FROM DUAL
    UNION ALL SELECT 'mktFcstSpreadTitle',   'DMF0035_mktFcstSpreadTitle_SEARCH'   FROM DUAL
    UNION ALL SELECT 'salesPlanSpreadTitle', 'DMF0035_salesPlanSpreadTitle_SEARCH' FROM DUAL
    UNION ALL SELECT 'bizPlanSpreadTitle',   'DMF0035_bizPlanSpreadTitle_SEARCH'   FROM DUAL
    UNION ALL SELECT 'version',              'DMF0035_version_SEARCH'              FROM DUAL
) S
ON (M.MNU_ID = 'DMF0035' AND M.SHT_NM = S.SHT_NM AND M.MNU_BTN_CD = 'SEARCH')
WHEN NOT MATCHED THEN INSERT
    (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('DMF0035', S.SHT_NM, 'SEARCH', S.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE)
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 050 : USER_GR_MNU_BTN_MPG_M — DMF0022 실측 그룹 전부(5) × DMF0035 BTN 7행 = 35행 미러
-- (원본 DMF0022 그룹 수 5 실측 — 0건 아님, hook #68 안티패턴 14 게이트 통과)
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M T
USING (
    SELECT G.USER_GR_ID, B.MNU_ID, B.SHT_NM, B.MNU_BTN_CD
      FROM (SELECT DISTINCT USER_GR_ID
              FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
             WHERE MNU_ID = 'DMF0022') G
     CROSS JOIN (SELECT MNU_ID, SHT_NM, MNU_BTN_CD
                   FROM SCM_ADM_MNU_BTN_MPG_M
                  WHERE MNU_ID = 'DMF0035') B
) S
ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID AND T.SHT_NM = S.SHT_NM AND T.MNU_BTN_CD = S.MNU_BTN_CD)
WHEN NOT MATCHED THEN INSERT
    (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    (S.USER_GR_ID, S.MNU_ID, S.SHT_NM, S.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE)
/

-- ─────────────────────────────────────────────────────────────
-- BLOCK 060 : CMBO_SQL_M — 'QtyType' 신설 (MDU_DIVS_CD='DM' — ItemType/BucketType2 동형)
-- AS-IS 정본: DMF0003_GET_QTY_TYPE_CODE = LOOKUP 'MKT_FCST_UNIT_QTY' (AS-IS 실측 4행:
--   SEGMENT1='MKTFCSTUnitQty' 상수 / SEGMENT2='QTY/1','QTY/1,000','QTY/1,000,000','QTY/100,000,000')
-- 사내 SCM_ADM_LOOKUP_MASTER_DETAIL 에 동일 4행 기이관 실측 완료.
-- AS-IS CODE(SEGMENT1)가 상수라 콤보 value 로 사용 불가 → CODE = SEGMENT2 의 '/' 뒤 숫자(콤마 제거) 파생
--   = '1'/'1000'/'1000000'/'100000000' (FE DIVISOR 계약), NAME = AS-IS 표시문구 원형 유지. (보고 명기 항목)
-- 'BucketType2' 는 기존재(DM — DMF0042 등록분) → 무수정 SKIP. 'BucketType'/'SenderCode'/'ItemType'/
-- 'SALES_PLAN_AMOUNT_*' 공유 CMBO 무수정.
-- ─────────────────────────────────────────────────────────────
MERGE INTO SCM_ADM_CMBO_SQL_M M
USING (SELECT 'QtyType' AS SQL_ID, 'DM' AS MDU_DIVS_CD FROM DUAL) S
ON (M.SQL_ID = S.SQL_ID AND M.MDU_DIVS_CD = S.MDU_DIVS_CD)
WHEN NOT MATCHED THEN INSERT
    (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('QtyType', 'DM', 'QTY 환산 배수 (AS-IS DMF0003_GET_QTY_TYPE_CODE = LOOKUP MKT_FCST_UNIT_QTY)',
     'SELECT REPLACE(SUBSTR(SEGMENT2, INSTR(SEGMENT2, ''/'') + 1), '','', '''') AS CODE
     , SEGMENT2 AS NAME
FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = ''MKT_FCST_UNIT_QTY''
AND    VALID_YN = ''Y''
ORDER BY DISPLAY_SEQ',
     'Y', 'admin', SYSDATE, 'admin', SYSDATE)
/

-- ============================================================================================
-- (참고) 본 세트에서 의도적으로 미포함 — 기존재 실측:
--   * SCM_MST_SHEET_COLUMNS: DMF0035/'Mkt Fcst Waterfall' 71행, DMF0022/'salesPlanWaterfall' 65행,
--     DMF0051/'Biz Plan Waterfall' 61행 (PKG body 실측 참조 키와 일치 — 신규 INSERT 금지)
--   * SCM_MST_SHEET_MEASURE: DMF0035 49 / DMF0022 31 / DMF0051 9
--   * SCM_ADM_USER_GR_MNU_MPG_M: DMF0035 5그룹 (ADMIN/DM ADMIN/DM Planner/DM Viewer/SCP Planner) 기존재
--   * MSG00137/00108/00164/00097/00013/00109 + MNU00020 기존재 — 무수정
--   * LBL00774~776 은 타 화면(Mail Setup) 점유 — 무수정 (FE WaterfallVersionModal 재채번 필요, 보고 항목)
-- ============================================================================================
