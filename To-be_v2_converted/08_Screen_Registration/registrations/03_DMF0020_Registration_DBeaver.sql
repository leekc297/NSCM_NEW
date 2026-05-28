/*=============================================================================================
 * File         : 03_DMF0020_Registration_DBeaver.sql
 * Description  : 신규 화면 DMF0020 (Sales Future Price) 메타 등록 — DBeaver 호환 [PART 1: 등록]
 *              :
 *              : ★ DBeaver 파서 제약으로 PART 단위 3개 파일로 분리:
 *              :   • 03_DMF0020_Registration_DBeaver.sql           — 본 파일 (등록 PL/SQL 블록)
 *              :   • 03_DMF0020_Registration_DBeaver_Verify.sql    — 검증 SELECT
 *              :   • 03_DMF0020_Registration_DBeaver_Diagnose.sql  — 라우팅 진단 PL/SQL 블록
 *              :
 *              : 7개 영역 등록 (Doc/_dev_rules/08_SCREEN_REGISTRATION.md §2):
 *              :   1. i18n            (SCM_ADM_MSG_M)
 *              :   2. Procedure       (SCM_ADM_PROC_M) ★ 누락 시 빈 결과
 *              :   3. Sheet Columns   (SCM_MST_SHEET_COLUMNS) — 인라인 JSON_TABLE INSERT
 *              :   4. MENU            (SCM_ADM_MNU_M)
 *              :   5. API             (SCM_ADM_API_M)
 *              :   6. MNU_BTN_MPG     (SCM_ADM_MNU_BTN_MPG_M)
 *              :   7. Group MENU      (SCM_ADM_USER_GR_MNU_MPG_M)
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-19
 *
 * 실행 방법   :
 *   1. 본 파일 열기 → 전체 선택 (Ctrl+A) → Ctrl+Enter (또는 Alt+X)
 *   2. DBMS_OUTPUT 결과 확인 (Window → DBMS Output 뷰)
 *   3. 03_DMF0020_Registration_DBeaver_Verify.sql 실행 (CNT 검증)
 *   4. 03_DMF0020_Registration_DBeaver_Diagnose.sql 실행 (라우팅 동작 확인)
 *
 * 사전 조건   :
 *   • PKG_DMF0020 컴파일 VALID
 *   • DBeaver: Window → Preferences → Database → Editors → Oracle → ✅ Enable DBMS_OUTPUT
 *
 * ★ 자기완결형 (Self-Contained): 외부 PKG 의존성 없음.
 *   본 파일만으로 7개 영역 메타 등록이 모두 완료됩니다.
 *   BLOCK 3 도 인라인 JSON_TABLE INSERT 로 작성 (PKG.P_REGISTER_SCREEN 호출 없음).
 *
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

DECLARE
    -- ─── 환경 상수 ────────────────────────────────────────────────────────────────────────
    V_MENU_ID       CONSTANT VARCHAR2(20)  := 'DMF0020';
    V_UPPR_MENU     CONSTANT VARCHAR2(50)  := 'DEMAND_MASTER';
    V_MENU_LV_NO    CONSTANT NUMBER        := 3;
    V_MENU_URL      CONSTANT VARCHAR2(200) := 'sales-future-price';
    V_MENU_MSG_ID   CONSTANT VARCHAR2(50)  := 'MNU_DMF0020';
    V_MENU_KO       CONSTANT VARCHAR2(200) := '환율/판매단가 관리';
    V_MENU_EN       CONSTANT VARCHAR2(200) := 'Sales Future Price';
    V_MENU_CN       CONSTANT VARCHAR2(200) := '汇率/销售单价管理';
    V_SORT_ORD      CONSTANT NUMBER        := 50;
    V_SHEET_NM      CONSTANT VARCHAR2(50)  := 'futurePrice';
    V_PKG_NM        CONSTANT VARCHAR2(50)  := 'PKG_DMF0020';
    V_USER_ID       CONSTANT VARCHAR2(50)  := 'admin';

    -- ─── 파생 상수 ────────────────────────────────────────────────────────────────────────
    V_PROC_GET      CONSTANT VARCHAR2(100) := V_PKG_NM || '.P_DMF0020_GET_FUTUREPRICE_INFO';
    V_PROC_SAVE     CONSTANT VARCHAR2(100) := V_PKG_NM || '.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA';
    V_API_SEARCH      CONSTANT VARCHAR2(100) := V_MENU_ID || '_' || V_SHEET_NM || '_SEARCH';
    V_API_SAVE        CONSTANT VARCHAR2(100) := V_MENU_ID || '_' || V_SHEET_NM || '_SAVE';
    V_API_SEARCH_MSG  CONSTANT VARCHAR2(50)  := 'MSG_API_' || V_MENU_ID || '_FUTUREPRICE_SEARCH';
    V_API_SAVE_MSG    CONSTANT VARCHAR2(50)  := 'MSG_API_' || V_MENU_ID || '_FUTUREPRICE_SAVE';

    v_col_json  CLOB;
    v_col_count NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('DMF0020 (Sales Future Price) 메타 등록 시작');
    DBMS_OUTPUT.PUT_LINE('============================================================');

    -- =========================================================================================
    -- BLOCK 1: i18n (SCM_ADM_MSG_M) — 메뉴 라벨 + API 메시지
    -- =========================================================================================
    DELETE FROM SCM_ADM_MSG_M WHERE MSG_ID IN (V_MENU_MSG_ID, V_API_SEARCH_MSG, V_API_SAVE_MSG);

    INSERT ALL
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_MSG_ID, 'KO', V_MENU_KO, 'MNU', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_MSG_ID, 'EN', V_MENU_EN, 'MNU', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_MSG_ID, 'CN', V_MENU_CN, 'MNU', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SEARCH_MSG, 'KO', '환율/판매단가 조회',         'API', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SEARCH_MSG, 'EN', 'Sales Future Price Search', 'API', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SEARCH_MSG, 'CN', '汇率/销售单价查询',         'API', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SAVE_MSG, 'KO', '환율 저장',                   'API', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SAVE_MSG, 'EN', 'Exchange Rate Save',          'API', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SAVE_MSG, 'CN', '汇率保存',                    'API', 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
    SELECT 1 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 1] i18n: '||SQL%ROWCOUNT||' 행 등록 (MNU 3 + API 6)');

    -- =========================================================================================
    -- BLOCK 2: Procedure 메타 (SCM_ADM_PROC_M)
    -- =========================================================================================
    -- 2-1. SEARCH SP
    DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = V_PROC_GET;

    INSERT ALL
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'startYyyymmdd',   'IN',  'VARCHAR',     1, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'endYyyymmdd',     'IN',  'VARCHAR',     2, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'userId',          'IN',  'VARCHAR',     3, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'menuId',          'IN',  'VARCHAR',     4, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'o_rc1',           'OUT', 'CURSOR',      5, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_GET, 'o_result_cursor', 'OUT', 'PROC_RESULT', 6, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
    SELECT 1 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 2-1] PROC SEARCH: '||SQL%ROWCOUNT||' 행 등록');

    -- 2-2. SAVE SP
    DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = V_PROC_SAVE;

    INSERT ALL
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_SAVE, 'activeFlag',      'IN',  'VARCHAR',     1, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_SAVE, 'divisionId',      'IN',  'VARCHAR',     2, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_SAVE, 'yyyymmdd',        'IN',  'VARCHAR',     3, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_SAVE, 'currency',        'IN',  'VARCHAR',     4, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_SAVE, 'unitCurrency',    'IN',  'VARCHAR',     5, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_SAVE, 'exchangePrice',   'IN',  'VARCHAR',     6, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_SAVE, 'createdBy',       'IN',  'VARCHAR',     7, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_SAVE, 'lastUpdatedBy',   'IN',  'VARCHAR',     8, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_PROC_SAVE, 'o_result_cursor', 'OUT', 'PROC_RESULT', 9, V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
    SELECT 1 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 2-2] PROC SAVE: '||SQL%ROWCOUNT||' 행 등록');

    -- =========================================================================================
    -- BLOCK 3: Sheet Columns 등록 (SCM_MST_SHEET_COLUMNS) — 인라인 INSERT, PKG 의존성 없음
    -- =========================================================================================
    v_col_json := '[
        {"sht_nm":"futurePrice","col_nm":"YYYYMMDD",      "col_lbl":"Date",           "cell_tp":"FPText",  "col_wth":110,"sort_ord":1,"align":"C","input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"YYYYMM",        "col_lbl":"Year-Month",     "cell_tp":"FPText",  "col_wth": 90,"sort_ord":2,"align":"C","input_tp":"READONLY"},
        {"sht_nm":"futurePrice","col_nm":"DIVISION_ID",   "col_lbl":"Div.",           "cell_tp":"FPText",  "col_wth": 80,"sort_ord":3,"align":"C","input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"CURRENCY",      "col_lbl":"Currency",       "cell_tp":"FPText",  "col_wth": 90,"sort_ord":4,"align":"C","input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"UNIT_CURRENCY", "col_lbl":"Unit Currency",  "cell_tp":"FPText",  "col_wth":110,"sort_ord":5,"align":"C","input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"EXCHANGE_PRICE","col_lbl":"Exchange Price", "cell_tp":"FPNumber","col_wth":140,"sort_ord":6,"align":"R","scale":4,"input_tp":"MANDATORY"},
        {"sht_nm":"futurePrice","col_nm":"EDIT_YN",       "col_lbl":"Editable",       "cell_tp":"FPText",  "col_wth": 80,"sort_ord":7,"align":"C","input_tp":"READONLY","visible":"N"}
    ]';

    DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = V_MENU_ID;

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
        V_MENU_ID,
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
        V_USER_ID, SYSDATE, V_USER_ID, SYSDATE
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

    -- =========================================================================================
    -- BLOCK 4: MENU 등록 (SCM_ADM_MNU_M)
    -- =========================================================================================
    MERGE INTO SCM_ADM_MNU_M T
    USING (SELECT V_MENU_ID AS MNU_ID FROM DUAL) S
       ON (T.MNU_ID = S.MNU_ID)
    WHEN MATCHED THEN
        UPDATE SET T.UPPR_MNU_ID      = V_UPPR_MENU,
                   T.MNU_LV_NO        = V_MENU_LV_NO,
                   T.MNU_MSG_ID       = V_MENU_MSG_ID,
                   T.MNU_URL          = V_MENU_URL,
                   T.SORT_ORD         = V_SORT_ORD,
                   T.USE_YN           = 'Y',
                   T.LAST_UPDATED_BY  = V_USER_ID,
                   T.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_MSG_ID, MNU_URL, SORT_ORD, USE_YN,
                CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_ID, V_UPPR_MENU, V_MENU_LV_NO, V_MENU_MSG_ID, V_MENU_URL,
                V_SORT_ORD, 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE);
    DBMS_OUTPUT.PUT_LINE('[BLOCK 4] SCM_ADM_MNU_M MERGE: '||SQL%ROWCOUNT||' 행');

    -- =========================================================================================
    -- BLOCK 5: API 등록 (SCM_ADM_API_M)
    -- =========================================================================================
    DELETE FROM SCM_ADM_API_M WHERE API_ID LIKE V_MENU_ID || '\_%' ESCAPE '\';

    INSERT ALL
      INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SEARCH, 'PROC', V_API_SEARCH_MSG,
                V_MENU_ID || ' Future Price Search', V_PROC_GET, 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_API_SAVE, 'PROC', V_API_SAVE_MSG,
                V_MENU_ID || ' Exchange Rate Save', V_PROC_SAVE, 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
    SELECT 1 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 5] SCM_ADM_API_M: '||SQL%ROWCOUNT||' 행 등록');

    -- =========================================================================================
    -- BLOCK 6: MNU_BTN_MPG
    -- =========================================================================================
    DELETE FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = V_MENU_ID;

    INSERT ALL
      INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_ID, V_SHEET_NM, 'SEARCH', V_API_SEARCH, 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (V_MENU_ID, V_SHEET_NM, 'SAVE',   V_API_SAVE, 'Y',
                V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
    SELECT 1 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 6] SCM_ADM_MNU_BTN_MPG_M: '||SQL%ROWCOUNT||' 행 등록');

    -- =========================================================================================
    -- BLOCK 7: Group MENU 권한
    -- =========================================================================================
    DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = V_MENU_ID;

    INSERT ALL
      INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES ('ADMIN',       V_MENU_ID, 'Y', V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
      INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES ('DEMAND_USER', V_MENU_ID, 'Y', V_USER_ID, SYSDATE, V_USER_ID, SYSDATE)
    SELECT 1 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 7] SCM_ADM_USER_GR_MNU_MPG_M: '||SQL%ROWCOUNT||' 행 등록');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('✅ DMF0020 등록 완료 (7개 영역) — COMMIT 됨');
    DBMS_OUTPUT.PUT_LINE('다음: 03_DMF0020_Registration_DBeaver_Verify.sql 실행');
    DBMS_OUTPUT.PUT_LINE('============================================================');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('❌ 등록 실패 — ROLLBACK');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: '||SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQLERRM: '||SQLERRM);
        DBMS_OUTPUT.PUT_LINE('BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        RAISE;
END;
