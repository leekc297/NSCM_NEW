/*=============================================================================================
 * File         : 02_NEW_SCREEN_FULL_REGISTRATION_TEMPLATE.sql
 * Description  : 신규 화면 7개 영역 일괄 등록 템플릿
 *              :
 *              : 7개 영역 (Doc/_dev_rules/08_SCREEN_REGISTRATION.md §2 참조):
 *              :   1. i18n            (SCM_ADM_MSG_M)             — SYS0001
 *              :   2. MENU            (SCM_ADM_MNU_M)             — SYS0003
 *              :   3. UI Category     (SCM_MST_SHEET_COLUMNS)     — SYS0004
 *              :   4. Procedure       (SCM_ADM_PROC_M)            — SYS0005  ★ 누락 시 빈 결과
 *              :   5. API             (SCM_ADM_API_M)             — SYS0006
 *              :   6. MNU_BTN_MPG     (SCM_ADM_MNU_BTN_MPG_M)     — 라우팅 매핑
 *              :   7. Group MENU      (SCM_ADM_USER_GR_MNU_MPG_M) — SYS0008
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-19
 * Source Rule  : Doc/_dev_rules/08_SCREEN_REGISTRATION.md
 *
 * 실행 환경   : Oracle 19c, SQL*Plus or SQL Developer
 * 실행 계정   : SCM_MGR (또는 동등 권한)
 *
 * 사용법      :
 *   1) 상단 DEFINE 변수를 본인 화면 ID 로 치환
 *   2) BLOCK 1~7 각각의 데이터(번역문/파라미터/컬럼 등) 작성
 *   3) 전체 실행 → BLOCK 8 (검증) 으로 7개 row 카운트 확인
 *   4) FE 측에서 `pnpm gen:procedures` + `pnpm sync:i18n` 실행
 *
 * 사전 조건   : Step 1 (PKG_DMF{NNNN} 작성·컴파일) 이 완료된 상태
 *
 * ★ 자기완결형 (Self-Contained): 외부 PKG (PKG_NSCM_SCREEN_REGISTRATION 등) 의존성 없음.
 *   모든 BLOCK 이 인라인 DML 만 사용. 사용 화면 PKG 만 사전 배포되면 동작.
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================================
-- DEFINE 변수 — 본인 화면 값으로 치환
-- =============================================================================================
DEFINE V_MENU_ID      = 'DMF0099'                                    -- 화면 ID
DEFINE V_UPPR_MENU    = 'DMF'                                        -- 상위 메뉴 ID
DEFINE V_MENU_LV_NO   = 3                                            -- 1=대분류 2=중분류 3=화면
DEFINE V_MENU_URL     = 'dmf0099-sales-monitor'                      -- FE 라우팅 slug (leaf segment only, NO directory prefix — 부모 메뉴 경로는 FE 가 조립)
DEFINE V_MENU_MSG_ID  = 'MNU_DMF0099'                                -- = 'MNU_' + V_MENU_ID
DEFINE V_MENU_KO      = '판매 모니터링'                                -- 한국어 메뉴명
DEFINE V_MENU_EN      = 'Sales Monitor'                              -- 영어 메뉴명
DEFINE V_MENU_CN      = '销售监控'                                    -- 중국어 메뉴명
DEFINE V_SORT_ORD     = 99                                           -- 메뉴 정렬 순서
DEFINE V_SHEET_NM     = 'main'                                       -- 시트명 (보통 'main')
DEFINE V_PKG_NM       = 'PKG_DMF0099'                                -- Oracle 패키지명
DEFINE V_USER_ID      = 'admin'                                      -- 등록자 ID

-- =============================================================================================
-- BLOCK 1: i18n (SCM_ADM_MSG_M) — SYS0001 영역
-- ---------------------------------------------------------------------------------------------
-- 메뉴명 1개 + 화면이 사용하는 LBL/MSG 코드를 KO/EN/CN 3 언어로 등록
-- ★ FN_GET_MSG_SEQ('LBL') / FN_GET_MSG_SEQ('MSG') 로 신규 일련번호 채번 가능
-- =============================================================================================

-- ── 1-1. 메뉴명 (필수) ──────────────────────────────────────────────────────────────────────
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
SELECT * FROM DUAL;

-- ── 1-2. 라벨 (LBL) ─ 화면 컬럼/버튼 라벨 N개 ── 신규 라벨이 필요한 경우만 등록 ────────────────
-- 예시: 신규 라벨 1개 (Sales Monitor 화면 전용) 등록
-- INSERT ALL
--   INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
--     VALUES ('LBL09001', 'KO', '판매수량', 'LBL', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
--   INTO SCM_ADM_MSG_M (...) VALUES ('LBL09001', 'EN', 'Sales Qty',     'LBL', 'Y', ...)
--   INTO SCM_ADM_MSG_M (...) VALUES ('LBL09001', 'CN', '销售数量',       'LBL', 'Y', ...)
-- SELECT * FROM DUAL;

-- ── 1-3. 시스템 메시지 (MSG) ─ Alert/Toast 용 ─ 화면 전용 메시지가 있는 경우만 등록 ──────────
-- INSERT ALL
--   INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, ...) VALUES ('MSG09001', 'KO', '저장하시겠습니까?', 'MSG', 'Y', ...)
--   INTO SCM_ADM_MSG_M (...) VALUES ('MSG09001', 'EN', 'Are you sure to save?', 'MSG', 'Y', ...)
--   INTO SCM_ADM_MSG_M (...) VALUES ('MSG09001', 'CN', '是否保存?', 'MSG', 'Y', ...)
-- SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 2: Procedure 메타 (SCM_ADM_PROC_M) — SYS0005 영역  ★★★ 가장 중요
-- ---------------------------------------------------------------------------------------------
-- SP 의 IN/OUT 파라미터를 1개당 1행씩 등록.
-- 이 BLOCK 누락 시 BE 의 동적 호출이 NULL 파라미터로 SP 를 호출하여 빈 결과 반환됨 (DMF0007 사례).
--
-- 명명 규약 (08_SCREEN_REGISTRATION.md §6):
--   - IN  : P_DIVISION_ID → COL_NM = 'divisionId'  (camelCase, P_ 제거)
--   - OUT : O_RC1         → COL_NM = 'o_rc1'        (snake, lowercase)
--   - OUT : O_RESULT_CURSOR → COL_NM = 'o_result_cursor', DATA_TP_CD = 'PROC_RESULT'
-- =============================================================================================

-- ── 2-0. SP 시그니처 자동 추출 (작성 보조용) ─ 등록 전 ALL_ARGUMENTS 로 확인 ──────────────────
-- SELECT NVL2(PACKAGE_NAME, PACKAGE_NAME||'.'||OBJECT_NAME, OBJECT_NAME) AS PROC_NM,
--        ARGUMENT_NAME AS DB_COL_NM, POSITION, IN_OUT,
--        DECODE(ARGUMENT_NAME, 'O_RESULT_CURSOR', 'PROC_RESULT',
--               PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(DATA_TYPE)) AS DATA_TP_CD
--   FROM ALL_ARGUMENTS
--  WHERE PACKAGE_NAME = '&V_PKG_NM' AND OWNER = 'SCM_MGR'
--  ORDER BY OBJECT_NAME, POSITION;

-- ── 2-1. SEARCH SP 의 IN/OUT 파라미터 ──────────────────────────────────────────────────────
-- 기존 등록 제거 후 재등록 (안전)
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = '&V_PKG_NM' || '.P_&V_MENU_ID._GET_MAIN_DATA';

INSERT ALL
  -- IN 파라미터 (P_ 접두사 제거 + camelCase)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PKG_NM..P_&V_MENU_ID._GET_MAIN_DATA', 'divisionId', 'IN', 'VARCHAR', 1,
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (...) VALUES ('&V_PKG_NM..P_&V_MENU_ID._GET_MAIN_DATA', 'userId',  'IN',  'VARCHAR', 2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (...) VALUES ('&V_PKG_NM..P_&V_MENU_ID._GET_MAIN_DATA', 'menuId',  'IN',  'VARCHAR', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  -- OUT 커서
  INTO SCM_ADM_PROC_M (...) VALUES ('&V_PKG_NM..P_&V_MENU_ID._GET_MAIN_DATA', 'o_rc1',           'OUT', 'CURSOR',      4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (...) VALUES ('&V_PKG_NM..P_&V_MENU_ID._GET_MAIN_DATA', 'o_result_cursor', 'OUT', 'PROC_RESULT', 5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;

-- ── 2-2. SAVE SP 의 IN/OUT 파라미터 ──────────────────────────────────────────────────────
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = '&V_PKG_NM' || '.P_&V_MENU_ID._SAVE_MAIN_DATA';

INSERT ALL
  -- JSON 배열을 IN 으로 받을 때는 DATA_TP_CD = 'JVARCHAR' 사용
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PKG_NM..P_&V_MENU_ID._SAVE_MAIN_DATA', 'data',   'IN',  'JVARCHAR',    1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (...) VALUES ('&V_PKG_NM..P_&V_MENU_ID._SAVE_MAIN_DATA', 'userId',          'IN',  'VARCHAR',     2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (...) VALUES ('&V_PKG_NM..P_&V_MENU_ID._SAVE_MAIN_DATA', 'o_result_cursor', 'OUT', 'PROC_RESULT', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 3: Sheet Columns 등록 (SCM_MST_SHEET_COLUMNS) — 인라인 JSON_TABLE INSERT
-- ---------------------------------------------------------------------------------------------
-- ★ 자기완결형: 외부 PKG 의존성 없음.
-- v_col_json 의 각 항목 = 그리드 1 컬럼. 화면별로 컬럼 수만큼 행 추가.
-- =============================================================================================

DECLARE
    v_col_json  CLOB := '[
        {"sht_nm":"&V_SHEET_NM","col_nm":"DIVISION_ID","col_lbl":"LBL00001","cell_tp":"FPText",  "col_wth":120,"sort_ord":1,"input_tp":"MANDATORY","align":"L"},
        {"sht_nm":"&V_SHEET_NM","col_nm":"YYYYMM",     "col_lbl":"LBL00100","cell_tp":"FPText",  "col_wth": 80,"sort_ord":2,                    "align":"C"},
        {"sht_nm":"&V_SHEET_NM","col_nm":"QTY",        "col_lbl":"LBL00200","cell_tp":"FPNumber","col_wth":100,"sort_ord":3,"scale":4,           "align":"R"}
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
-- ---------------------------------------------------------------------------------------------
-- 실제 운영 테이블 SCM_ADM_MNU_M 에
-- 직접 등록. 향후 PKG 가 정정되면 이 BLOCK 은 제거 가능.
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
               T.USE_YN           = 'Y',
               T.LAST_UPDATED_BY  = '&V_USER_ID',
               T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_MSG_ID, MNU_URL, SORT_ORD, USE_YN,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID', '&V_UPPR_MENU', &V_MENU_LV_NO, '&V_MENU_MSG_ID', '&V_MENU_URL',
            &V_SORT_ORD, 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);


-- =============================================================================================
-- BLOCK 5: API 등록 (SCM_ADM_API_M)
-- ---------------------------------------------------------------------------------------------
-- 컬럼: API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN
-- =============================================================================================

DELETE FROM SCM_ADM_API_M WHERE API_ID LIKE '&V_MENU_ID' || '\_%' ESCAPE '\';

INSERT ALL
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID._&V_SHEET_NM._SEARCH', 'PROC', NULL,
            '&V_MENU_ID Search', '&V_PKG_NM..P_&V_MENU_ID._GET_MAIN_DATA', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID._&V_SHEET_NM._SAVE', 'PROC', NULL,
            '&V_MENU_ID Save', '&V_PKG_NM..P_&V_MENU_ID._SAVE_MAIN_DATA', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 6: MNU_BTN_MPG INSERT (SCM_ADM_MNU_BTN_MPG_M — 라우팅 매핑)
-- ---------------------------------------------------------------------------------------------
-- PR_GET_PROC_INFO_LIST 가 사용하는 핵심 매핑. 본 BLOCK 누락 시 BE 에서 SP 라우팅 실패.
-- API_ID 는 BLOCK 5 에서 등록한 ID 와 정확히 일치해야 함.
-- =============================================================================================

DELETE FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';

INSERT ALL
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID', '&V_SHEET_NM', 'SEARCH', '&V_MENU_ID._&V_SHEET_NM._SEARCH', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID', '&V_SHEET_NM', 'SAVE',   '&V_MENU_ID._&V_SHEET_NM._SAVE', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 7: Group MENU 권한 (SCM_ADM_USER_GR_MNU_MPG_M) — SYS0008 영역
-- ---------------------------------------------------------------------------------------------
-- 그룹 × 메뉴 권한. 화면 접근 가능한 그룹 N개를 추가.
-- =============================================================================================

DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID';

INSERT ALL
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('ADMIN',       '&V_MENU_ID', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DEMAND_USER', '&V_MENU_ID', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;

-- 버튼별 권한 분리가 필요하면 SCM_ADM_USER_GR_MNU_BTN_MPG_M 에 별도 INSERT
-- INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, MNU_BTN_CD, USE_YN, ...)
-- VALUES ('DEMAND_USER', '&V_MENU_ID', 'SAVE', 'N', ...);   -- 일반 사용자에게 저장 권한 없음


COMMIT;


-- =============================================================================================
-- BLOCK 8: 검증 SELECT — PR 머지 게이트 (08_SCREEN_REGISTRATION.md §9)
-- ---------------------------------------------------------------------------------------------
-- 7개 영역 모두 등록 확인. CNT 가 EXPECT_MIN 보다 작으면 빨간불.
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT 신규 화면 [&V_MENU_ID] 등록 검증 결과
PROMPT ============================================================

SELECT '1.MENU'         AS K, COUNT(*) AS CNT, 1 AS EXPECT_MIN, 'SCM_ADM_MNU_M' AS TBL              FROM SCM_ADM_MNU_M             WHERE MNU_ID = '&V_MENU_ID'
UNION ALL
SELECT '2.MENU_AUTH'      , COUNT(*)     , 1                 , 'SCM_ADM_USER_GR_MNU_MPG_M'          FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL
SELECT '3.UI_COLS'        , COUNT(*)     , 1                 , 'SCM_MST_SHEET_COLUMNS'              FROM SCM_MST_SHEET_COLUMNS     WHERE PROGRAM_ID = '&V_MENU_ID'
UNION ALL
SELECT '4.PROC'           , COUNT(*)     , 3                 , 'SCM_ADM_PROC_M  (★ 핵심)'            FROM SCM_ADM_PROC_M            WHERE PROC_NM LIKE '&V_PKG_NM' || '.%'
UNION ALL
SELECT '5.API'            , COUNT(*)     , 1                 , 'SCM_ADM_API_M'                      FROM SCM_ADM_API_M             WHERE API_ID LIKE '&V_MENU_ID' || '\_%' ESCAPE '\'
UNION ALL
SELECT '6.MNU_BTN_MPG'    , COUNT(*)     , 1                 , 'SCM_ADM_MNU_BTN_MPG_M'              FROM SCM_ADM_MNU_BTN_MPG_M     WHERE MNU_ID = '&V_MENU_ID'
UNION ALL
SELECT '7.I18N_MNU'       , COUNT(*)     , 3                 , 'SCM_ADM_MSG_M (MNU 3 langs)'        FROM SCM_ADM_MSG_M             WHERE MSG_ID = '&V_MENU_MSG_ID'
ORDER BY 1;

PROMPT
PROMPT 동작 검증:
PROMPT   1) PR_GET_PROC_INFO_LIST 가 정상 라우팅되는지 호출
PROMPT
DECLARE
    v_cur SYS_REFCURSOR;
    v_proc_nm   VARCHAR2(200);
    v_col_nm    VARCHAR2(100);
    v_data_tp   VARCHAR2(50);
    v_col_tp    VARCHAR2(50);
    v_sort_ord  NUMBER;
    v_cnt       NUMBER := 0;
BEGIN
    SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(
        P_MNU_ID     => '&V_MENU_ID',
        P_SHT_NM     => '&V_SHEET_NM',
        P_MNU_BTN_CD => 'SEARCH',
        O_CURSOR     => v_cur
    );
    LOOP
        FETCH v_cur INTO v_proc_nm, v_col_nm, v_data_tp, v_col_tp, v_sort_ord;
        EXIT WHEN v_cur%NOTFOUND;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE(
            '   ['||v_cnt||'] '||v_proc_nm||' / '||v_col_nm||' / '||v_data_tp||' / '||v_col_tp||' / '||v_sort_ord
        );
    END LOOP;
    CLOSE v_cur;

    IF v_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('   ❌ FAIL: 라우팅 행 없음 — BLOCK 5 (API), BLOCK 6 (MNU_BTN_MPG) 등록 확인 필요');
    ELSIF v_cnt = 1 THEN
        DBMS_OUTPUT.PUT_LINE('   ⚠ WARN: 라우팅은 됐으나 SCM_ADM_PROC_M 등록 없음 — BLOCK 2 확인 필요 (DMF0007 사례)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('   ✅ OK: '||v_cnt||' 개 파라미터 라우팅됨');
    END IF;
END;
/

PROMPT
PROMPT ============================================================
PROMPT 다음 단계:
PROMPT   FE 측에서 다음 명령 실행
PROMPT     cd nscm-fe
PROMPT     pnpm gen:procedures   ← procedures.d.ts 자동 생성
PROMPT     pnpm sync:i18n        ← KO/EN/CN locale 동기화
PROMPT     pnpm dev              ← 로컬 실행 후 브라우저 검증
PROMPT ============================================================


-- =============================================================================================
-- (참고) BLOCK 9: 롤백 SQL — 등록 실패 시 수동 복구
-- ---------------------------------------------------------------------------------------------
-- 아래 블록은 주석 처리 — 필요 시 주석 해제 후 실행
-- =============================================================================================

-- DELETE FROM SCM_ADM_MSG_M              WHERE MSG_ID = '&V_MENU_MSG_ID';
-- DELETE FROM SCM_ADM_PROC_M             WHERE PROC_NM LIKE '&V_PKG_NM' || '.%';
-- DELETE FROM SCM_MST_SHEET_COLUMNS      WHERE PROGRAM_ID = '&V_MENU_ID';
-- DELETE FROM SCM_ADM_MNU_BTN_MPG_M      WHERE MNU_ID = '&V_MENU_ID';
-- DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M  WHERE MNU_ID = '&V_MENU_ID';
-- DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';
-- DELETE FROM SCM_ADM_API_M              WHERE API_ID LIKE '&V_MENU_ID' || '\_%' ESCAPE '\';
-- DELETE FROM SCM_ADM_MNU_M              WHERE MNU_ID = '&V_MENU_ID';
-- DELETE FROM SCM_ADM_MSG_M              WHERE MSG_ID = '&V_MENU_MSG_ID';
-- COMMIT;


UNDEFINE V_MENU_ID V_UPPR_MENU V_MENU_LV_NO V_MENU_URL V_MENU_MSG_ID
UNDEFINE V_MENU_KO V_MENU_EN V_MENU_CN V_SORT_ORD V_SHEET_NM V_PKG_NM V_USER_ID

-- ============================================================================
-- END OF FILE
-- ============================================================================
