-- =====================================================================
-- 50_DMF0002_titleset_SP_body.sql
--
-- DMF0043_01 의 ColumnTitleSetModal 이 호출하는 공용 SP body
-- (메타는 48_DMF0043_01_TitleSet_Meta.sql 에 신규 등록 완료 — PROC_NM=DMF0002_GET_TITLESET_POPUP)
--
-- 배경 (2026-06-02):
--   DMF0043_01 deploy package 의 공용 의존 SP. 새 환경에 DMF0002_GET_TITLESET_POPUP 가 없으면
--   ColumnTitleSetModal 동작 안 함 → 본 SP body 동봉으로 안전한 deploy 보장.
--
-- 추출: Oracle SCM_MGR (Docker local) DBMS_METADATA.GET_DDL
-- =====================================================================

PROMPT === [1/1] DMF0002_GET_TITLESET_POPUP (공용 SP) ===

CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0002_GET_TITLESET_POPUP" (
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
        ),
        usr AS (
            SELECT U.COLUMN_NAME, U.SORT_ORDER_NO AS USER_SORT_ORDER_NO, U.SUB_TOTAL_FLAG
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
        FROM base B
        LEFT JOIN usr U ON U.COLUMN_NAME = B.COLUMN_NAME
        ORDER BY B.SORT_ORDER_NO;
END DMF0002_GET_TITLESET_POPUP;
/

PROMPT === DMF0002_GET_TITLESET_POPUP body 적재 완료 ===
