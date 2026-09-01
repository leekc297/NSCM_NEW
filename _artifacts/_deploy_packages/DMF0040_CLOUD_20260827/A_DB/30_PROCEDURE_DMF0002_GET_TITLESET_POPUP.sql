-- 30_PROCEDURE_DMF0002_GET_TITLESET_POPUP.sql — API_M 배선 standalone PROCEDURE (VALID, LAST_DDL 2026-08-22 12:59) — 클라우드 부재/구판이면 적용
-- 의존: ['TABLE:SCM_MST_SHEET_COLUMNS', 'TABLE:SCM_MST_TITLESET_USER']
CREATE OR REPLACE PROCEDURE         DMF0002_GET_TITLESET_POPUP (
    P_PROGRAM_ID  VARCHAR2,
    P_SHEET_NAME  VARCHAR2,
    P_COLUMN_TYPE VARCHAR2,
    P_USER_ID     VARCHAR2,
    P_DIVISION_ID VARCHAR2,
    P_MENU_ID     VARCHAR2,
    O_CURSOR      OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN O_CURSOR FOR
        WITH base AS (
            SELECT DISTINCT
                C.PROGRAM_ID,
                C.SHEET_NAME,
                C.COLUMN_NAME,
                C.COLUMN_LABEL_NAME,
                C.SMALL_CLASS_LABEL_NAME,
                C.LARGE_CLASS_LABEL_NAME,
                C.DATA_SORT_METHOD_CODE,
                C.COLUMN_WIDTH,
                C.SORT_ORDER_NO,
                COALESCE(C.DEFAULT_FLAG, 'N') AS DEFAULT_FLAG,
                COALESCE(C.USER_SELECTABLE_FLAG, 'Y') AS USER_SELECTABLE_FLAG
            FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
            WHERE C.PROGRAM_ID = P_PROGRAM_ID
              AND C.SHEET_NAME = P_SHEET_NAME
              AND C.VALID_YN = 'Y'
              -- ⭐ [2026-08-22] division 필터 — 메인 그리드 `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` L164 와 동일 판정식.
              --   없으면 그리드엔 안 나오는 컬럼이 Column Setting 목록에만 뜬다(DMF0082 PROJECT_CODE / div 40 실사고).
              AND (P_DIVISION_ID IS NULL OR C.DIVISION_ID IS NULL
                   OR INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0)
        ),
        usr AS (
            SELECT U.COLUMN_NAME, U.SORT_ORDER_NO AS USER_SORT_ORDER_NO, U.SUB_TOTAL_FLAG,
                   U.COLUMN_WIDTH AS USER_COLUMN_WIDTH, U.CELL_COLOR, U.TEXT_COLOR   -- ⭐ 2026-07-27 신규
              FROM SCM_MGR.SCM_MST_TITLESET_USER U
             WHERE U.PROGRAM_ID = P_PROGRAM_ID
               AND U.SHEET_NAME = P_SHEET_NAME
               AND U.USER_ID = P_USER_ID
               AND U.USER_INQUIRY_COLUMN_TYPE_CODE = P_COLUMN_TYPE
        ),
        has_user_rows AS (
            SELECT CASE WHEN EXISTS (SELECT 1 FROM usr) THEN 'Y' ELSE 'N' END AS FLAG FROM DUAL
        )
        SELECT
            B.PROGRAM_ID,
            B.SHEET_NAME,
            B.COLUMN_NAME,
            B.COLUMN_LABEL_NAME,
            B.DATA_SORT_METHOD_CODE,
            B.SMALL_CLASS_LABEL_NAME,
            B.LARGE_CLASS_LABEL_NAME,
            B.COLUMN_WIDTH,
            B.SORT_ORDER_NO,
            COALESCE(U.SUB_TOTAL_FLAG, 'N') AS SUB_TOTAL_FLAG,
            'ASC' AS USER_SORT_METHOD_CODE,
            COALESCE(U.USER_SORT_ORDER_NO, B.SORT_ORDER_NO) AS USER_SORT_ORDER_NO,
            CASE
                WHEN (SELECT FLAG FROM has_user_rows) = 'Y' THEN
                    CASE WHEN U.COLUMN_NAME IS NOT NULL THEN 'Y' ELSE 'N' END
                ELSE B.DEFAULT_FLAG
            END AS USER_FLAG,
            B.DEFAULT_FLAG,
            B.USER_SELECTABLE_FLAG,
            'N' AS TOTAL_USE_FLAG
            -- ⭐ 2026-07-27 신규: 사용자 저장값 우선, 미저장 시 SHEET_COLUMNS 폴백
            , COALESCE(U.USER_COLUMN_WIDTH, B.COLUMN_WIDTH) AS USER_COLUMN_WIDTH
            , U.CELL_COLOR AS CELL_COLOR
            , U.TEXT_COLOR AS TEXT_COLOR
        FROM base B
        LEFT JOIN usr U ON U.COLUMN_NAME = B.COLUMN_NAME
        ORDER BY B.SORT_ORDER_NO;
END DMF0002_GET_TITLESET_POPUP;
/
