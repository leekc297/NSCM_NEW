/*=============================================================================================
 * File         : 03_DMF0020_Registration.sql
 * Description  : 신규 화면 DMF0020 (Sales Future Price / Exchange Rate) 메타 등록
 *              :
 *              : 7개 영역 (Doc/_dev_rules/08_SCREEN_REGISTRATION.md §2):
 *              :   1. i18n            (SCM_ADM_MSG_M)
 *              :   2. Procedure       (SCM_ADM_PROC_M) ★ 누락 시 빈 결과
 *              :   3. Sheet Columns   (SCM_MST_SHEET_COLUMNS) — 인라인 JSON_TABLE INSERT
 *              :   4. MENU            (SCM_ADM_MNU_M)
 *              :   5. API             (SCM_ADM_API_M)
 *              :   6. MNU_BTN_MPG     (SCM_ADM_MNU_BTN_MPG_M)
 *              :   7. Group MENU      (SCM_ADM_USER_GR_MNU_MPG_M)
 *              :
 *              : ★ 자기완결형 (Self-Contained): 외부 PKG 의존성 없음.
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-19
 * 화면 정보   :
 *   MENU_ID    : DMF0020
 *   화면명     : Sales Future Price (환율/판매단가 관리)
 *   FE 경로    : /master/demand-master/sales-future-price
 *   PKG.SP     : PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO
 *                PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA
 *
 * 사전 조건   : PKG_DMF0020 컴파일 완료 (VALID 상태)
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DEFINE V_MENU_ID      = 'DMF0020'
DEFINE V_UPPR_MENU    = 'DEMAND_MASTER'
DEFINE V_MENU_LV_NO   = 3
DEFINE V_MENU_URL     = 'sales-future-price'
DEFINE V_MENU_MSG_ID  = 'MNU_DMF0020'
DEFINE V_MENU_KO      = '환율/판매단가 관리'
DEFINE V_MENU_EN      = 'Sales Future Price'
DEFINE V_MENU_CN      = '汇率/销售单价管理'
DEFINE V_SORT_ORD     = 50
DEFINE V_SHEET_NM     = 'futurePrice'
DEFINE V_PKG_NM       = 'PKG_DMF0020'
DEFINE V_USER_ID      = 'admin'
DEFINE V_API_SEARCH_MSG = 'MSG_API_DMF0020_FUTUREPRICE_SEARCH'
DEFINE V_API_SAVE_MSG   = 'MSG_API_DMF0020_FUTUREPRICE_SAVE'

-- =============================================================================================
-- BLOCK 1: i18n (SCM_ADM_MSG_M) — 메뉴명 + 컬럼 라벨
-- =============================================================================================

-- ── 1-1. 메뉴명 3개 언어 + API 메시지 ───────────────────────────────────────────────────────
DELETE FROM SCM_ADM_MSG_M WHERE MSG_ID IN ('&V_MENU_MSG_ID', '&V_API_SEARCH_MSG', '&V_API_SAVE_MSG');

INSERT ALL
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_MSG_ID', 'KO', '&V_MENU_KO', 'MNU', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_MSG_ID', 'EN', '&V_MENU_EN', 'MNU', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_MSG_ID', 'CN', '&V_MENU_CN', 'MNU', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SEARCH_MSG', 'KO', '환율/판매단가 조회',         'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SEARCH_MSG', 'EN', 'Sales Future Price Search', 'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SEARCH_MSG', 'CN', '汇率/销售单价查询',         'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SAVE_MSG', 'KO', '환율 저장',                   'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SAVE_MSG', 'EN', 'Exchange Rate Save',          'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SAVE_MSG', 'CN', '汇率保存',                    'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;

-- ── 1-2. 컬럼 라벨 (DMF0020 전용 — 기존 공용 라벨 재사용 가능하면 생략) ────────────────────
-- 이미 등록된 LBL00001(Div.), LBL00013(Period) 등은 재사용. DMF0020 전용 라벨이 필요시 추가.


-- =============================================================================================
-- BLOCK 2: Procedure 메타 (SCM_ADM_PROC_M) — ★ 핵심
-- 명명규약: P_DIVISION_ID → divisionId (camelCase, P_ 제거), O_RC1 → o_rc1, O_RESULT_CURSOR → o_result_cursor
-- =============================================================================================

-- ── 2-1. SEARCH SP: P_DMF0020_GET_FUTUREPRICE_INFO ───────────────────────────────────────
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO';

INSERT ALL
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO', 'startYyyymmdd', 'IN',  'VARCHAR', 1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO', 'endYyyymmdd',   'IN',  'VARCHAR', 2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO', 'sesUserId',     'IN',  'VARCHAR', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO', 'mnuId',         'IN',  'VARCHAR', 4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO', 'o_rc1',           'OUT', 'CURSOR',      5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO', 'o_result_cursor', 'OUT', 'PROC_RESULT', 6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;

-- ── 2-2. SAVE SP: P_DMF0000_SAVE_EXCHANGE_POPUP_DATA ──────────────────────────────────────
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA';

INSERT ALL
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'activeFlag',      'IN',  'VARCHAR',     1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'divisionId',      'IN',  'VARCHAR',     2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'yyyymmdd',        'IN',  'VARCHAR',     3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'currency',        'IN',  'VARCHAR',     4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'unitCurrency',    'IN',  'VARCHAR',     5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'exchangePrice',   'IN',  'VARCHAR',     6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'createdBy',       'IN',  'VARCHAR',     7, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'lastUpdatedBy',   'IN',  'VARCHAR',     8, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'o_result_cursor', 'OUT', 'PROC_RESULT', 9, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 3: Sheet Columns 등록 (SCM_MST_SHEET_COLUMNS) — 인라인 INSERT, PKG 의존성 없음
-- =============================================================================================

DECLARE
    v_col_json  CLOB := '[
        {"sht_nm":"futurePrice","col_nm":"YYYYMMDD",      "col_lbl":"Date",           "cell_tp":"FPText",  "col_wth":110,"sort_ord":1,"align":"C","input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"YYYYMM",        "col_lbl":"Year-Month",     "cell_tp":"FPText",  "col_wth": 90,"sort_ord":2,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"futurePrice","col_nm":"DIVISION_ID",   "col_lbl":"Div.",           "cell_tp":"FPText",  "col_wth": 80,"sort_ord":3,"align":"C","input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"CURRENCY",      "col_lbl":"Currency",       "cell_tp":"FPText",  "col_wth": 90,"sort_ord":4,"align":"C","input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"UNIT_CURRENCY", "col_lbl":"Unit Currency",  "cell_tp":"FPText",  "col_wth":110,"sort_ord":5,"align":"C","input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"EXCHANGE_PRICE","col_lbl":"Exchange Price", "cell_tp":"FPNumber","col_wth":140,"sort_ord":6,"align":"R","scale":4,"input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"EDIT_YN",       "col_lbl":"Editable",       "cell_tp":"FPText",  "col_wth": 80,"sort_ord":7,"align":"C","input_tp":"READONLY","visible":"N"}
    ]';
    v_col_count NUMBER;
BEGIN
    DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '&V_MENU_ID';

    INSERT INTO SCM_MST_SHEET_COLUMNS (
        PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
        SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH,
        CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
        DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE,
        UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DEFAULT_FLAG,
        USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID, INPUT_TP_CD,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    )
    SELECT
        '&V_MENU_ID',
        jt.SHT_NM, jt.COL_NM, jt.COL_LBL, jt.SORT_ORD,
        jt.SMALL_CLS, jt.LARGE_CLS,
        NVL(jt.FIXED, 'N'),
        NVL(jt.COL_WTH, 100),
        NVL(jt.CELL_TP, 'FPText'),
        jt.CELL_CBO,
        NVL(jt.SCALE, 0),
        NVL(jt.MAX_LEN, 200),
        NVL(jt.ALIGN, 'L'),
        NVL(jt.UPPER, 'N'),
        NVL(jt.VISIBLE, 'Y'),
        NVL(jt.DEFAULT_F, 'Y'),
        NVL(jt.USR_SEL, 'Y'),
        'Y',
        NVL(jt.DIV_ID, 'ALL'),
        NVL(jt.INPUT_TP, 'OPTIONAL'),
        '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
    FROM JSON_TABLE(v_col_json, '$[*]'
        COLUMNS (
            SHT_NM    VARCHAR2(50 CHAR)   PATH '$.sht_nm',
            COL_NM    VARCHAR2(100 CHAR)  PATH '$.col_nm',
            COL_LBL   VARCHAR2(200 CHAR)  PATH '$.col_lbl',
            SORT_ORD  NUMBER              PATH '$.sort_ord',
            SMALL_CLS VARCHAR2(100 CHAR)  PATH '$.small_cls',
            LARGE_CLS VARCHAR2(100 CHAR)  PATH '$.large_cls',
            FIXED     VARCHAR2(1 CHAR)    PATH '$.fixed',
            COL_WTH   NUMBER              PATH '$.col_wth',
            CELL_TP   VARCHAR2(50 CHAR)   PATH '$.cell_tp',
            CELL_CBO  VARCHAR2(100 CHAR)  PATH '$.cell_cbo',
            SCALE     NUMBER              PATH '$.scale',
            MAX_LEN   NUMBER              PATH '$.max_len',
            ALIGN     VARCHAR2(1 CHAR)    PATH '$.align',
            UPPER     VARCHAR2(1 CHAR)    PATH '$.upper',
            VISIBLE   VARCHAR2(1 CHAR)    PATH '$.visible',
            DEFAULT_F VARCHAR2(1 CHAR)    PATH '$.default_f',
            USR_SEL   VARCHAR2(1 CHAR)    PATH '$.usr_sel',
            DIV_ID    VARCHAR2(100 CHAR)  PATH '$.div_id',
            INPUT_TP  VARCHAR2(50 CHAR)   PATH '$.input_tp'
        )) jt;
    v_col_count := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 3] SCM_MST_SHEET_COLUMNS: '||v_col_count||' 행 등록');
END;
/


-- =============================================================================================
-- BLOCK 4: MENU 등록 (SCM_ADM_MNU_M)
-- =============================================================================================

MERGE INTO SCM_ADM_MNU_M T
USING (SELECT '&V_MENU_ID' AS MNU_ID FROM DUAL) S
   ON (T.MNU_ID = S.MNU_ID)
WHEN MATCHED THEN
    UPDATE SET T.UPPR_MNU_ID      = '&V_UPPR_MENU',
               T.MNU_LV_NO        = &V_MENU_LV_NO,
               T.MNU_MSG_ID       = '&V_MENU_MSG_ID',
               T.MNU_URL          = '&V_MENU_URL',
               T.SORT_ORD         = &V_SORT_ORD,
               T.MNU_TP_CD        = 'FN',  /* 2026-05-26 fix: NOT NULL — Function leaf menu */
               T.USE_YN           = 'Y',
               T.LAST_UPDATED_BY  = '&V_USER_ID',
               T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    /* 2026-05-26 fix: MNU_TP_CD NOT NULL — leaf 화면은 'FN' */
    INSERT (MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_MSG_ID, MNU_URL, SORT_ORD,
            MNU_TP_CD, USE_YN,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID', '&V_UPPR_MENU', &V_MENU_LV_NO, '&V_MENU_MSG_ID', '&V_MENU_URL',
            &V_SORT_ORD, 'FN', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);


-- =============================================================================================
-- BLOCK 5: API 등록 (SCM_ADM_API_M)
-- =============================================================================================

DELETE FROM SCM_ADM_API_M WHERE API_ID LIKE 'DMF0020\_%' ESCAPE '\';

INSERT ALL
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0020_futurePrice_SEARCH', 'PROC', '&V_API_SEARCH_MSG',
            'DMF0020 Future Price Search', 'PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0020_futurePrice_SAVE', 'PROC', '&V_API_SAVE_MSG',
            'DMF0020 Exchange Rate Save', 'PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 6: MNU_BTN_MPG (SCM_ADM_MNU_BTN_MPG_M — 라우팅 매핑)
-- =============================================================================================

DELETE FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';

INSERT ALL
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0020', 'futurePrice', 'SEARCH', 'DMF0020_futurePrice_SEARCH', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0020', 'futurePrice', 'SAVE',   'DMF0020_futurePrice_SAVE', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 7: Group MENU 권한 (SCM_ADM_USER_GR_MNU_MPG_M)
-- =============================================================================================

DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID';

INSERT ALL
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('ADMIN',       'DMF0020', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DEMAND_USER', 'DMF0020', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


COMMIT;


-- =============================================================================================
-- BLOCK 8: 검증 SELECT (7개 영역 확인)
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT 신규 화면 [DMF0020 — Sales Future Price] 등록 검증 결과
PROMPT ============================================================

SELECT '1.MENU'         AS K, COUNT(*) AS CNT, 1 AS EXPECT_MIN, 'SCM_ADM_MNU_M' AS TBL              FROM SCM_ADM_MNU_M             WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '2.MENU_AUTH',    COUNT(*), 1, 'SCM_ADM_USER_GR_MNU_MPG_M' FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '3.UI_COLS',      COUNT(*), 7, 'SCM_MST_SHEET_COLUMNS'     FROM SCM_MST_SHEET_COLUMNS     WHERE PROGRAM_ID = 'DMF0020'
UNION ALL
SELECT '4.PROC',         COUNT(*), 9, 'SCM_ADM_PROC_M  (★ 핵심)' FROM SCM_ADM_PROC_M            WHERE PROC_NM LIKE 'PKG_DMF0020.%'
UNION ALL
SELECT '5.API',          COUNT(*), 2, 'SCM_ADM_API_M'             FROM SCM_ADM_API_M             WHERE API_ID LIKE 'DMF0020\_%' ESCAPE '\'
UNION ALL
SELECT '6.MNU_BTN_MPG',  COUNT(*), 2, 'SCM_ADM_MNU_BTN_MPG_M'     FROM SCM_ADM_MNU_BTN_MPG_M     WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '7.I18N_MNU',     COUNT(*), 3, 'SCM_ADM_MSG_M (3 langs)'   FROM SCM_ADM_MSG_M             WHERE MSG_ID = 'MNU_DMF0020'
ORDER BY 1;


-- ── 동작 검증: PR_GET_PROC_INFO_LIST 가 정상 라우팅하는지 ─────────────────────────────────
PROMPT
PROMPT === PR_GET_PROC_INFO_LIST(DMF0020, futurePrice, SEARCH) 결과 ===
DECLARE
    v_cur     SYS_REFCURSOR;
    v_proc_nm VARCHAR2(200); v_col_nm VARCHAR2(100);
    v_data_tp VARCHAR2(50);  v_col_tp VARCHAR2(50);
    v_sort_ord NUMBER;       v_cnt PLS_INTEGER := 0;
BEGIN
    SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(
        P_MNU_ID => 'DMF0020', P_SHT_NM => 'futurePrice', P_MNU_BTN_CD => 'SEARCH',
        O_CURSOR => v_cur
    );
    LOOP
        FETCH v_cur INTO v_proc_nm, v_col_nm, v_data_tp, v_col_tp, v_sort_ord;
        EXIT WHEN v_cur%NOTFOUND;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('  ['||v_cnt||'] '||v_proc_nm||' / '||v_col_nm||' / '||v_data_tp||' / '||v_col_tp||' / '||v_sort_ord);
    END LOOP;
    CLOSE v_cur;

    IF v_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  ❌ FAIL: 라우팅 행 0 — BLOCK 5/6 재확인');
    ELSIF v_cnt = 1 THEN
        DBMS_OUTPUT.PUT_LINE('  ⚠ WARN: SCM_ADM_PROC_M 누락 — BLOCK 2 재확인');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  ✅ OK: 6 행 라우팅됨 (IN 4 + OUT 2)');
    END IF;
END;
/

PROMPT
PROMPT ============================================================
PROMPT 다음 단계 (FE):
PROMPT   cd nscm-fe
PROMPT   pnpm gen:procedures   ← procedures.d.ts 갱신 (이미 수동 등록 완료)
PROMPT   pnpm sync:i18n        ← KO/EN/CN locale 동기화
PROMPT   pnpm dev              ← 로컬 실행 후 메뉴 클릭하여 검증
PROMPT ============================================================


UNDEFINE V_MENU_ID V_UPPR_MENU V_MENU_LV_NO V_MENU_URL V_MENU_MSG_ID
UNDEFINE V_MENU_KO V_MENU_EN V_MENU_CN V_SORT_ORD V_SHEET_NM V_PKG_NM V_USER_ID
