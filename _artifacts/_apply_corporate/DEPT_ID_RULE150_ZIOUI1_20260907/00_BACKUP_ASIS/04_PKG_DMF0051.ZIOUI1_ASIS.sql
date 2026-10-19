CREATE OR REPLACE 
PACKAGE BODY           "PKG_DMF0051" IS

    PROCEDURE P_DMF0051_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_DIVISION_ID    VARCHAR2
       ,P_BUCKET         VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0051_GET_SPREAD_TITLE
        * Description  :
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 20220603     kdw2819         Initial Release PJ20216891R
        * 20221116     kdw2819         [C20221107-000343]BP Waterfall 오류 수정 요청의 건
        * 2026/03/15 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS

        I_COUNT        INTEGER := 0;
        V_PROGRAM_ID   VARCHAR2(50 CHAR) := 'DMF0051';
        V_SHEET_NAME   VARCHAR2(50 CHAR) := 'Biz Plan Waterfall';
        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN

        V_IN_PARA_DATA := JSON_OBJECT('p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                     ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_division_id' VALUE P_DIVISION_ID
                                     ,'p_bucket' VALUE P_BUCKET);

        SELECT COUNT(*)
        INTO   I_COUNT
        FROM   SCM_MST_TITLESET_USER U

        WHERE  1 = 1
        AND    U.PROGRAM_ID = V_PROGRAM_ID
        AND    U.SHEET_NAME = V_SHEET_NAME
        AND    U.USER_ID = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

        IF I_COUNT > 0 THEN
            OPEN O_RC1 FOR
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,CASE
                           WHEN P_DIVISION_ID LIKE '81%' THEN
                            (CASE
                                WHEN C.ATTRIBUTE4 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           WHEN P_DIVISION_ID = '82' THEN
                            (CASE
                                WHEN C.ATTRIBUTE5 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           ELSE
                            C.COLUMN_LABEL_NAME
                       END AS COLUMN_LABEL_NAME
                       -- [C20221107-000343]BP Waterfall 오류 수정 요청의 건
                      ,TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,P_DIVISION_ID ATTRIBUTE1
                      ,CASE
                           WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN
                            C.ATTRIBUTE1
                           ELSE
                            ''
                       END AS ATTRIBUTE2
                      ,'' AS ATTRIBUTE3
                      ,C.ATTRIBUTE4
                      ,C.ATTRIBUTE5
                      ,TEI.EDIT_YN
                FROM   SCM_MST_TITLESET_USER U, SCM_MST_SHEET_COLUMNS C
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = P_DIVISION_ID --[E20260831-W41] C.DIVISION_ID 는 콤마 목록 — 정확일치 조인은 단독값 행만 생존(0022 [E20260806-WF] 동형). 사업부 매칭은 WHERE 의 FN_SPLITSTRING 이 담당
                WHERE  1 = 1
                AND    U.PROGRAM_ID = C.PROGRAM_ID
                AND    U.SHEET_NAME = C.SHEET_NAME
                AND    U.COLUMN_NAME = C.COLUMN_NAME
                AND    U.PROGRAM_ID = V_PROGRAM_ID
                AND    U.SHEET_NAME = V_SHEET_NAME
                AND    U.USER_ID = P_CREATED_BY
                AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))
                UNION ALL
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,CASE
                           WHEN P_DIVISION_ID LIKE '81%' THEN
                            (CASE
                                WHEN C.ATTRIBUTE4 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           WHEN P_DIVISION_ID = '82' THEN
                            (CASE
                                WHEN C.ATTRIBUTE5 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           ELSE
                            C.COLUMN_LABEL_NAME
                       END AS COLUMN_LABEL_NAME
                      ,TO_CHAR(C.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,P_DIVISION_ID ATTRIBUTE1
                      ,C.ATTRIBUTE2
                      ,C.ATTRIBUTE3
                      ,C.ATTRIBUTE4
                      ,C.ATTRIBUTE5
                      ,'N' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = 'N'
                AND    RTRIM(C.DEFAULT_FLAG, ' -') IS NULL  --[E20260831-W34] AS-IS DEFAULT_FLAG='' 숨은컬럼 arm — ''=NULL(' '/'-' 흡수) 정정
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ','))) -- 20180620 division 추가

                UNION ALL

                SELECT V_PROGRAM_ID AS PROGRAM_ID
                      ,V_SHEET_NAME SHEET_NAME
                      ,T.COLUMN_NAME
                      ,T.COLUMN_LABEL_NAME
                      ,T.SORT_ORDER_NO
                      ,'' AS DATA_SORT_METHOD_CODE
                      ,T.SMALL_CLASS_LABEL_NAME
                      ,T.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,'' AS FIXED_FLAG
                      ,CAST(50 AS NUMBER) COLUMN_WIDTH
                      ,'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                      ,'' AS CELL_COMBO_DATA_TYPE
                      ,CAST('3' AS NUMBER) DATA_SCALE_NUMBER
                      ,CAST(NULL AS NUMBER) DATA_MAX_LENGTH
                      ,'R' AS HORIZONTAL_ALIGN_CODE
                      ,'Y' AS UPPERCASE_APPLY_FLAG
                      ,'Y' AS VISIBLE_FLAG
                      ,'' AS DEFAULT_FLAG
                      ,'' AS USER_SELECTABLE_FLAG
                      ,'' AS VALID_YN
                      ,'' AS DIVISION_ID
                      ,'' AS ATTRIBUTE1
                      ,'' AS ATTRIBUTE2
                      ,'' AS ATTRIBUTE3
                      ,'' AS ATTRIBUTE4
                      ,'' AS ATTRIBUTE5
                      ,'N' AS EDIT_YN
                FROM   (SELECT *
                        FROM   (
                                -- Monthly
                                SELECT 'M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                                       ,A.MONTH_NAME COLUMN_LABEL_NAME
                                       ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q'))) SMALL_CLASS_LABEL_NAME
                                       ,TO_CHAR(A.CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                       ,BASIS_YYYYMM || '01' AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                                GROUP  BY CALENDAR_YYYY, A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                -- Quarterly
                                SELECT DISTINCT 'Q_' || CALENDAR_YYYY || '_' || TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q'))) COLUMN_NAME
                                                ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q'))) COLUMN_LABEL_NAME
                                                ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q'))) SMALL_CLASS_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                                ,CASE
                                                     WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q')) = 1 THEN
                                                      CALENDAR_YYYY || '0100'
                                                     WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q')) = 2 THEN
                                                      CALENDAR_YYYY || '0400'
                                                     WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q')) = 3 THEN
                                                      CALENDAR_YYYY || '0700'
                                                     ELSE
                                                      CALENDAR_YYYY || '1000'
                                                 END AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD

                                UNION ALL
                                -- Yearly
                                SELECT DISTINCT 'Y_' || CALENDAR_YYYY AS COLUMN_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) COLUMN_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) SMALL_CLASS_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                                ,CALENDAR_YYYY || '0000' AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD) MA) T
                ORDER  BY SORT_ORDER_NO;

        ELSE
            OPEN O_RC1 FOR
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,CASE
                           WHEN P_DIVISION_ID LIKE '81%' THEN
                            (CASE
                                WHEN C.ATTRIBUTE4 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           WHEN P_DIVISION_ID = '82' THEN
                            (CASE
                                WHEN C.ATTRIBUTE5 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           ELSE
                            C.COLUMN_LABEL_NAME
                       END AS COLUMN_LABEL_NAME
                      ,TO_CHAR(C.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,P_DIVISION_ID ATTRIBUTE1
                      ,CASE
                           WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN
                            C.ATTRIBUTE1
                           ELSE
                            ''
                       END AS ATTRIBUTE2
                      ,'' AS ATTRIBUTE3
                      ,C.ATTRIBUTE4
                      ,C.ATTRIBUTE5
                      ,TEI.EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = P_DIVISION_ID --[E20260831-W41] C.DIVISION_ID 는 콤마 목록 — 정확일치 조인은 단독값 행만 생존(0022 [E20260806-WF] 동형). 사업부 매칭은 WHERE 의 FN_SPLITSTRING 이 담당
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.DEFAULT_FLAG = 'Y'
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))

                UNION ALL

                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,CASE
                           WHEN P_DIVISION_ID LIKE '81%' THEN
                            (CASE
                                WHEN C.ATTRIBUTE4 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           WHEN P_DIVISION_ID = '82' THEN
                            (CASE
                                WHEN C.ATTRIBUTE5 = 'Y' THEN
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '') || '*'
                                ELSE
                                 REPLACE(C.COLUMN_LABEL_NAME, '*', '')
                            END)
                           ELSE
                            C.COLUMN_LABEL_NAME
                       END AS COLUMN_LABEL_NAME
                      ,TO_CHAR(C.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,P_DIVISION_ID ATTRIBUTE1
                      ,CASE
                           WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN
                            C.ATTRIBUTE1
                           ELSE
                            C.ATTRIBUTE1
                       END AS ATTRIBUTE2
                      ,C.ATTRIBUTE3
                      ,C.ATTRIBUTE4
                      ,C.ATTRIBUTE5
                      ,'N' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = 'N'
                AND    RTRIM(C.DEFAULT_FLAG, ' -') IS NULL  --[E20260831-W34] AS-IS DEFAULT_FLAG='' 숨은컬럼 arm — ''=NULL(' '/'-' 흡수) 정정
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ','))) -- 20180620 division 추가

                UNION ALL

                SELECT V_PROGRAM_ID AS PROGRAM_ID
                      ,V_SHEET_NAME SHEET_NAME
                      ,T.COLUMN_NAME
                      ,T.COLUMN_LABEL_NAME
                      ,T.SORT_ORDER_NO
                      ,'' AS DATA_SORT_METHOD_CODE
                      ,T.SMALL_CLASS_LABEL_NAME
                      ,T.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,'' AS FIXED_FLAG
                      ,CAST(50 AS NUMBER) COLUMN_WIDTH
                      ,'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                      ,'' AS CELL_COMBO_DATA_TYPE
                      ,CAST('3' AS NUMBER) DATA_SCALE_NUMBER
                      ,CAST(NULL AS NUMBER) DATA_MAX_LENGTH
                      ,'R' AS HORIZONTAL_ALIGN_CODE
                      ,'Y' AS UPPERCASE_APPLY_FLAG
                      ,'Y' AS VISIBLE_FLAG
                      ,'' AS DEFAULT_FLAG
                      ,'' AS USER_SELECTABLE_FLAG
                      ,'' AS VALID_YN
                      ,'' AS DIVISION_ID
                      ,'' AS ATTRIBUTE1
                      ,'' AS ATTRIBUTE2
                      ,'' AS ATTRIBUTE3
                      ,'' AS ATTRIBUTE4
                      ,'' AS ATTRIBUTE5
                      ,'N' AS EDIT_YN
                FROM   (SELECT *
                        FROM   (
                                -- Monthly
                                SELECT 'M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                                       ,A.MONTH_NAME COLUMN_LABEL_NAME
                                       ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q'))) SMALL_CLASS_LABEL_NAME
                                       ,TO_CHAR(A.CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                       ,BASIS_YYYYMM || '01' AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                                GROUP  BY CALENDAR_YYYY, A.BASIS_YYYYMM, A.MONTH_NAME
                                UNION ALL
                                -- Quarterly
                                SELECT DISTINCT 'Q_' || CALENDAR_YYYY || '_' || TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q'))) COLUMN_NAME
                                                ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q'))) COLUMN_LABEL_NAME
                                                ,'Q' || TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q'))) SMALL_CLASS_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                                ,CASE
                                                     WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q')) = 1 THEN
                                                      CALENDAR_YYYY || '0100'
                                                     WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q')) = 2 THEN
                                                      CALENDAR_YYYY || '0400'
                                                     WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM || '01', 'YYYYMMDD'), 'Q')) = 3 THEN
                                                      CALENDAR_YYYY || '0700'
                                                     ELSE
                                                      CALENDAR_YYYY || '1000'
                                                 END
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD

                                UNION ALL
                                -- Yearly
                                SELECT DISTINCT 'Y_' || CALENDAR_YYYY AS COLUMN_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) COLUMN_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) SMALL_CLASS_LABEL_NAME
                                                ,TO_CHAR(CALENDAR_YYYY) LARGE_CLASS_LABEL_NAME
                                                ,CALENDAR_YYYY || '0000' AS SORT_ORDER_NO
                                FROM   SCM_SYS_CALENDAR_M A
                                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD) MA) T
                ORDER  BY SORT_ORDER_NO;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0051_GET_SPREAD_TITLE;


    PROCEDURE P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL
    (
        P_DIVISION_ID       IN VARCHAR2,
        P_DEPT_ID           IN VARCHAR2,
        P_END_CUSTOMER      IN VARCHAR2,
        P_SCM_SITE_ID       IN VARCHAR2,
        P_PROJECT_CODE      IN VARCHAR2,
        P_ITEM_ID           IN VARCHAR2,
        P_ITEM_TYPE         IN VARCHAR2,
        P_FROM_YYYYMMDD     IN VARCHAR2,
        P_NOW_YYYYMMDD      IN VARCHAR2,   -- AS-IS 수신만·본문 미사용 (계약 보존 — DMF0035 통합분석 §3.B)
        P_TO_YYYYMMDD       IN VARCHAR2,
        P_CREATED_BY        IN VARCHAR2,
        P_PLANT_SITE_ID     IN VARCHAR2,
        P_BIZTYPE           IN VARCHAR2,
        P_OWNER             IN VARCHAR2,
        P_VERSION_TYPE      IN VARCHAR2,
        P_CELL_YN           IN VARCHAR2,
        P_QTY_YN            IN VARCHAR2,
        P_USER_ID           IN VARCHAR2,
        P_MENU_ID           IN VARCHAR2,

        O_RC1               OUT SYS_REFCURSOR,
        O_RC2               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    /*=====================================================================================================================================================
     * [E20260806-WF] DMF0035 Demand Plan Waterfall 통합 — AS-IS DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL 6-Stage 재변환
     * Program ID   : DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL
     * Description  : Business Plan Waterfall 조회
     * Program History (AS-IS 원문 이력 보존)
     *=====================================================================================================================================================
     *   Date       In Charge      Description
     *=====================================================================================================================================================
     * 2022.06.10  rosia27      Initial Release [PJ20216891R]
     * 2022.10.31  rosia27      [C20221024-000510]DM UI 소스 정리 요청
     * 2022.11.16  kdw2819      [C20221107-000343]BP Waterfall 오류 수정 요청의 건
     * 2024/08/29  KJJ          [PJ2024-50461] Team Mapping
     * 2024.09.12  JSSBAE       [E20240920-000300]_SCM.DM 화면 조회 속도 개선
     * 2026.08.06  Claude       [E20260806-WF] MSSQL 1,296행 → Oracle PKG 멤버 재변환 (패턴 정본=PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL)
     *=====================================================================================================================================================
     * 계약: IN 19 (AS-IS 17 positional 그대로 + P_USER_ID/P_MENU_ID) / OUT 3 (O_RC1 피벗 본문+EDIT_YN, O_RC2 금일 ISO_WEEK·BASIS_DATE, O_RESULT_CURSOR 결과코드)
     * 이관 제외/변형 (전수):
     *   1) #T_PRICE — AS-IS 에서 DROP 만 존재하는 미사용 잔재 → 이관 제외
     *   2) 3번째 결과셋(실행 SQL 의 FOR XML 디버그 덤프) → 0022 선례대로 O_RESULT_CURSOR(결과코드) + DBMS_OUTPUT.PUT_LINE(v_sql_text) 로 대체
     *   3) #TEMP_SCM_MST_SSO_USER_INFO(단순 사본) → 0022 선례대로 SCM_MST_SSO_USER_INFO 직접 조회
     *   4) c_bucket FAST_FORWARD 커서 → FOR 커서 루프 (0022 선례)
     *   5) CREATE CLUSTERED INDEX(#TEMP_DM_MST_ITEM_SINGLE_V) → GTT + DBMS_STATS.GATHER_TABLE_STATS 로 대체 (0022 선례)
     *   6) String_Split → TABLE(UF_FX_STRING_SPLIT(REPLACE(p,'^',','),',')) — ',' 와 '^' 겸용 토큰화
     *   7) DEFAULT_FLAG = '' 판정 → RTRIM(DEFAULT_FLAG,' -') IS NULL (PKG_DMF0042 [E20260806-00979] 계보 — ''=NULL·'-' 센티널 흡수)
     *   8) titleset 'M' 0건 DEFAULT INSERT = 원본 유지 (PKG_DMF0022/PKG_DMF0035 변환판 모두 면역 가드 미적용 — 동일 수준)
     * GTT: 재사용 GT_DM22_V_VERSION_NO/GT_DM22_SELECT_MEASURE/GT_DM22_T_COLUMN_SETUP/GT_DM22_T/GT_DM22_DM_MST_ITEM_SINGLE_{ORI_V,A_V,B_V,V}
     *      신규 GT_DM51_RAW_DATA/GT_DM51_SCM_MST_SITE_ITEM/GT_DM51_SCM_CITY (별도 DDL: DMF0051_PKG_GET_WATERFALL_20260806_GTT_DDL.sql)
     *===================================================================================================================================================*/
    AS
        v_program_id    VARCHAR2(50  CHAR) := 'DMF0051';
        v_sheet_name    VARCHAR2(50  CHAR) := 'Biz Plan Waterfall';

        v_ColList       VARCHAR2(32767 CHAR) := '';
        v_OrderList     VARCHAR2(32767 CHAR) := '';
        i_count         PLS_INTEGER := 0;
        v_user_mea_cnt  PLS_INTEGER := 0;

        -- Dynamic SQL 변수
        v_sql_text      VARCHAR2(32767 CHAR);
        V_PV_LIST       VARCHAR2(32767 CHAR);
        V_PV_COL_LIST   VARCHAR2(32767 CHAR);
        V_SQL_SELECT    VARCHAR2(32767 CHAR);
        v_I             PLS_INTEGER;
        v_CNT           PLS_INTEGER;

        V_PROC_INPUT    CLOB;
        V_BACKTRACE     VARCHAR2(4000 CHAR);
        V_SQL_CODE      VARCHAR2(100  CHAR);
        V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
        n_log_count     PLS_INTEGER := 0;
        V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

    BEGIN
    --[E20260820-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어
    --  통계 없는 GTT 가 카디널리티 1 로 추정되어 NL 이 선택되면 대용량 표를 행 단위로 훑는다
    --  (클라우드 실측: GT_DM35_T_LAST_SETUP_C 적재문 1,302초/회, cell single block read).
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
        ELSE
            V_PROGRAM_NAME := $$PLSQL_UNIT;
        END IF;

        --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
        --  Oracle 기본값 2 복원. 트랜잭션 무관 세션 파라미터(ENABLE PARALLEL DML 계열 아님 — ORA-12841 리스크 없음).
        EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

        -- SET NOCOUNT ON / SET ANSI_NULLS ON / SET ANSI_WARNINGS ON;  (Oracle: 불필요)

        -- GTT 세션 통계 설정 (19c GLOBAL_TEMP_TABLE_STATS=SESSION 표준)
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_V_VERSION_NO',             'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_SELECT_MEASURE',           'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM51_RAW_DATA',                 'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_ORI_V', 'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_A_V',   'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_B_V',   'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_V',     'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM51_SCM_MST_SITE_ITEM',        'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM51_SCM_CITY',                 'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_T_COLUMN_SETUP',           'GLOBAL_TEMP_TABLE_STATS','SESSION');
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DM22_T',                        'GLOBAL_TEMP_TABLE_STATS','SESSION');

        --=================================================================================================================================
        -- Temp Table 존재 여부 체크 (BEGIN)  — 원본 MSSQL DROP TABLE #X → Oracle GTT.
        -- ON COMMIT PRESERVE ROWS + 커넥션 풀 세션 재사용 대비 시작 시 DELETE 초기화 (부록 C-2/C-5 — TRUNCATE 금지)
        --=================================================================================================================================
        DELETE FROM SCM_MGR.GT_DM22_V_VERSION_NO;
        DELETE FROM SCM_MGR.GT_DM22_SELECT_MEASURE;
        DELETE FROM SCM_MGR.GT_DM51_RAW_DATA;
        DELETE FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V;
        DELETE FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V;
        DELETE FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V;
        DELETE FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V;
        DELETE FROM SCM_MGR.GT_DM51_SCM_MST_SITE_ITEM;
        DELETE FROM SCM_MGR.GT_DM51_SCM_CITY;
        DELETE FROM SCM_MGR.GT_DM22_T_COLUMN_SETUP;
        DELETE FROM SCM_MGR.GT_DM22_T;

        --=================================================================================================================================
        -- 버전 토큰 사전 분해 (0022 선례 [E20250529-001488] 패턴) — '(' 앞 버전 토큰 절단 + ','/'^' 겸용 분해
        --   AS-IS: A.VERSION_NO IN (SELECT LEFT(token, CASE WHEN CHARINDEX('(',token)=0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END)
        --                             FROM dbo.String_Split(@p_version_type ,','))  (dump:369/403/456 3개소 공통)
        --=================================================================================================================================
        INSERT INTO SCM_MGR.GT_DM22_V_VERSION_NO
            (VERSION_NO, TOBE_VERSION_NO)
        SELECT TRIM(CASE WHEN INSTR(TOKEN, '(') = 0
                         THEN TOKEN
                         ELSE SUBSTR(TOKEN, 1, INSTR(TOKEN, '(') - 1)
                    END) AS VERSION_NO,
               NULL AS TOBE_VERSION_NO
          FROM (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_VERSION_TYPE, '^', ','), ',')) P)
        ;

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A001--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '=>' || TO_CHAR(SQL%ROWCOUNT));

        --=================================================================================================================================
        -- titleset 'M' 0건 시 DEFAULT INSERT (AS-IS dump:103-145 원본 유지 — PKG_DMF0022/0035 변환판과 동일 수준, 면역 가드 미적용)
        --=================================================================================================================================
        SELECT COUNT(*)
          INTO v_user_mea_cnt
          FROM SCM_MGR.SCM_MST_TITLESET_USER U
         WHERE 1 = 1
           AND U.PROGRAM_ID                    = v_program_id
           AND U.SHEET_NAME                    = v_sheet_name
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
           AND U.USER_ID                       = P_CREATED_BY;

        IF v_user_mea_cnt = 0 THEN
            INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
                ( USER_ID
                , PROGRAM_ID
                , SHEET_NAME
                , USER_INQUIRY_COLUMN_TYPE_CODE
                , COLUMN_NAME
                , SORT_ORDER_NO
                , SUB_TOTAL_FLAG
                , DATA_SORT_METHOD_CODE
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
                )
            SELECT P_CREATED_BY
                 , C.PROGRAM_ID
                 , C.SHEET_NAME
                 , 'M'
                 , C.COLUMN_NAME
                 , C.SORT_ORDER_NO
                 , 'N'
                 , ''
                 , P_CREATED_BY
                 , SYSDATE
                 , P_CREATED_BY
                 , SYSDATE
              FROM SCM_MGR.SCM_MST_SHEET_MEASURE C
             WHERE 1 = 1
               AND C.PROGRAM_ID   = v_program_id
               AND C.SHEET_NAME   = v_sheet_name
               AND C.DEFAULT_FLAG = 'Y'
               AND C.VALID_YN     = 'Y';
        END IF;

        --=================================================================================================================================
        -- #SELECT_MEASURE (AS-IS dump:147-158)
        --   * AS-IS 의 PROGRAM_ID/SHEET_NAME 컬럼은 상수(v_program_id/v_sheet_name)이며 하류 미사용 → GT_DM22_SELECT_MEASURE 재사용 위해 제외
        --=================================================================================================================================
        INSERT INTO SCM_MGR.GT_DM22_SELECT_MEASURE
            (MEASURE, SORT_ORDER_NO)
        SELECT DISTINCT
               U.COLUMN_NAME AS MEASURE
             , U.SORT_ORDER_NO
          FROM SCM_MGR.SCM_MST_TITLESET_USER U
         WHERE 1 = 1
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
           AND U.PROGRAM_ID = v_program_id
           AND U.SHEET_NAME = v_sheet_name
           AND U.USER_ID    = P_CREATED_BY;

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '=>' || TO_CHAR(SQL%ROWCOUNT));

        --=================================================================================================================================
        -- CURRENT버전 (AS-IS dump:189-328) — DM_PLN_BP_FCST(라이브) 월 적재 → 분기 → 연 3단 롤업
        --=================================================================================================================================
        IF ( UPPER(P_VERSION_TYPE) LIKE '%CURRENT%' ) THEN  --[E20260831-VERCASE] MSSQL CI 콜레이션 1:1 — 'Current' 등 대소문자 변형 흡수
            --MONTHLY
            INSERT INTO SCM_MGR.GT_DM51_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                , INCOTERMS, CELL_PROD_SITE, FCST_TYPE, CURRENCY, MEASURE, YYYYMM, CAL_YYYYQQ, CAL_YYYY, QTY
                , COLNAME, DEPT_ID, END_CUSTOMER, BIZ_TYPE, PROJECT_NAME, ITEM_USE, UNIT_ENERGY )
            SELECT 'CURRENT' AS VERSION_NO
                 , NULL AS CUTOFF_YYYYMMDD
                 , A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , PLANT_SITE_ID
                 , A.ITEM_ID
                 , A.INCOTERMS
                 , A.CELL_PROD_SITE
                 , A.FCST_TYPE
                 , A.CURRENCY
                 , A.MEASURE
                 , A.YYYYMM
                 , CAL.CALENDAR_YYYYQQ AS CAL_YYYYQQ
                 , CAL.CALENDAR_YYYY AS CAL_YYYY
                 , A.QTY
                 , 'M_' || A.YYYYMM AS COLNAME
                 , A.DEPT_ID
                 , A.END_CUSTOMER
                 , A.BIZ_TYPE
                 , A.PROJECT_NAME
                 , A.ITEM_USE
                 , A.UNIT_ENERGY
              FROM SCM_MGR.DM_PLN_BP_FCST A
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
             INNER JOIN (SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM
                           FROM SCM_MGR.SCM_SYS_CALENDAR_M
                          WHERE (BASIS_YYYYMM >= SUBSTR(P_FROM_YYYYMMDD, 1, 6) AND BASIS_YYYYMM <= SUBSTR(P_TO_YYYYMMDD, 1, 6))
                          GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) CAL
                     ON CAL.BASIS_YYYYMM = A.YYYYMM
             WHERE A.YYYYMM >= SUBSTR(P_FROM_YYYYMMDD, 1, 6) AND A.YYYYMM <= SUBSTR(P_TO_YYYYMMDD, 1, 6)
               AND A.DIVISION_ID = P_DIVISION_ID
            ;

            --QUATERLY
            INSERT INTO SCM_MGR.GT_DM51_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                , INCOTERMS, CELL_PROD_SITE, FCST_TYPE, CURRENCY, MEASURE, YYYYMM, CAL_YYYYQQ, CAL_YYYY, QTY
                , COLNAME, DEPT_ID, END_CUSTOMER, BIZ_TYPE, PROJECT_NAME, ITEM_USE, UNIT_ENERGY )
            SELECT 'CURRENT' AS VERSION_NO
                 , NULL AS CUTOFF_YYYYMMDD
                 , A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , PLANT_SITE_ID
                 , A.ITEM_ID
                 , A.INCOTERMS
                 , A.CELL_PROD_SITE
                 , A.FCST_TYPE
                 , A.CURRENCY
                 , A.MEASURE
                 , A.CAL_YYYYQQ AS YYYYMM
                 , A.CAL_YYYYQQ AS CAL_YYYYQQ
                 , A.CAL_YYYY AS CAL_YYYY
                 , CASE WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
                        THEN SUM(QTY)
                        ELSE MAX(QTY)
                   END QTY
                 , 'Q_' || REPLACE(A.CAL_YYYYQQ, 'Q', '_') AS COLNAME
                 , A.DEPT_ID
                 , MAX(A.END_CUSTOMER)
                 , MAX(A.BIZ_TYPE)
                 , MAX(A.PROJECT_NAME)
                 , A.ITEM_USE
                 , A.UNIT_ENERGY
              FROM SCM_MGR.GT_DM51_RAW_DATA A
             GROUP BY A.DIVISION_ID
                    , A.PROJECT_CODE
                    , A.SCM_SITE_ID
                    , PLANT_SITE_ID
                    , A.ITEM_ID
                    , A.INCOTERMS
                    , A.CELL_PROD_SITE
                    , A.FCST_TYPE
                    , A.CURRENCY
                    , A.MEASURE
                    , A.YYYYMM
                    , A.CAL_YYYYQQ
                    , A.CAL_YYYY
                    , A.DEPT_ID
                    , A.ITEM_USE
                    , A.UNIT_ENERGY
            ;

            --YEARLY
            INSERT INTO SCM_MGR.GT_DM51_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                , INCOTERMS, CELL_PROD_SITE, FCST_TYPE, CURRENCY, MEASURE, YYYYMM, CAL_YYYYQQ, CAL_YYYY, QTY
                , COLNAME, DEPT_ID, END_CUSTOMER, BIZ_TYPE, PROJECT_NAME, ITEM_USE, UNIT_ENERGY )
            SELECT 'CURRENT' AS VERSION_NO
                 , NULL AS CUTOFF_YYYYMMDD
                 , A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , PLANT_SITE_ID
                 , A.ITEM_ID
                 , A.INCOTERMS
                 , A.CELL_PROD_SITE
                 , A.FCST_TYPE
                 , A.CURRENCY
                 , A.MEASURE
                 , A.CAL_YYYY AS YYYYMM
                 , A.CAL_YYYY AS CAL_YYYYQQ
                 , A.CAL_YYYY
                 , CASE WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
                        THEN SUM(QTY)
                        ELSE MAX(QTY)
                   END QTY
                 , 'Y_' || A.CAL_YYYY AS COLNAME
                 , A.DEPT_ID
                 , MAX(A.END_CUSTOMER)
                 , MAX(A.BIZ_TYPE)
                 , MAX(A.PROJECT_NAME)
                 , A.ITEM_USE
                 , A.UNIT_ENERGY
              FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE COLNAME LIKE 'Q_%'
             GROUP BY A.DIVISION_ID
                    , A.PROJECT_CODE
                    , A.SCM_SITE_ID
                    , PLANT_SITE_ID
                    , A.ITEM_ID
                    , A.INCOTERMS
                    , A.CELL_PROD_SITE
                    , A.FCST_TYPE
                    , A.CURRENCY
                    , A.MEASURE
                    , A.YYYYMM
                    , A.CAL_YYYYQQ
                    , A.CAL_YYYY
                    , A.DEPT_ID
                    , A.ITEM_USE
                    , A.UNIT_ENERGY
            ;

        END IF;

        --=================================================================================================================================
        -- CUTOFF버전 (AS-IS dump:330-477) — DM_PLN_BP_FCST_C, 버전 필터 = GT_DM22_V_VERSION_NO ('(' 절단 사전분해)
        --=================================================================================================================================
        IF ( P_VERSION_TYPE LIKE '%BP_%' ) THEN   -- AS-IS 동일: '_' 는 1글자 와일드카드 (MSSQL LIKE 와 동의미 — 이스케이프 미사용 1:1)
            --MONTHLY
            INSERT INTO SCM_MGR.GT_DM51_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                , INCOTERMS, CELL_PROD_SITE, FCST_TYPE, CURRENCY, MEASURE, YYYYMM, CAL_YYYYQQ, CAL_YYYY, QTY
                , COLNAME, DEPT_ID, END_CUSTOMER, BIZ_TYPE, PROJECT_NAME, ITEM_USE, UNIT_ENERGY )
            SELECT A.VERSION_NO
                 , A.CUTOFF_YYYYMMDD
                 , A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , A.PLANT_SITE_ID
                 , A.ITEM_ID
                 , A.INCOTERMS
                 , A.CELL_PROD_SITE
                 , A.FCST_TYPE
                 , A.CURRENCY
                 , A.MEASURE
                 , A.YYYYMM
                 , CAL.CALENDAR_YYYYQQ AS CAL_YYYYQQ
                 , CAL.CALENDAR_YYYY AS CAL_YYYY
                 , A.QTY
                 , 'M_' || A.YYYYMM AS COLNAME
                 , A.DEPT_ID
                 , A.END_CUSTOMER
                 , A.BIZ_TYPE
                 , A.PROJECT_NAME
                 , A.ITEM_USE
                 , A.UNIT_ENERGY
              FROM SCM_MGR.DM_PLN_BP_FCST_C A
              JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
             INNER JOIN (SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM
                           FROM SCM_MGR.SCM_SYS_CALENDAR_M
                          WHERE (BASIS_YYYYMM >= SUBSTR(P_FROM_YYYYMMDD, 1, 6) AND BASIS_YYYYMM <= SUBSTR(P_TO_YYYYMMDD, 1, 6))
                          GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) CAL
                     ON CAL.BASIS_YYYYMM = A.YYYYMM
             WHERE A.YYYYMM >= SUBSTR(P_FROM_YYYYMMDD, 1, 6) AND A.YYYYMM <= SUBSTR(P_TO_YYYYMMDD, 1, 6)
               AND A.DIVISION_ID = P_DIVISION_ID
               AND A.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO)
            ;

            --QUATERLY
            INSERT INTO SCM_MGR.GT_DM51_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                , INCOTERMS, CELL_PROD_SITE, FCST_TYPE, CURRENCY, MEASURE, YYYYMM, CAL_YYYYQQ, CAL_YYYY, QTY
                , COLNAME, DEPT_ID, END_CUSTOMER, BIZ_TYPE, PROJECT_NAME, ITEM_USE, UNIT_ENERGY )
            SELECT VERSION_NO
                 , A.CUTOFF_YYYYMMDD
                 , A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , A.PLANT_SITE_ID
                 , A.ITEM_ID
                 , A.INCOTERMS
                 , A.CELL_PROD_SITE
                 , A.FCST_TYPE
                 , A.CURRENCY
                 , A.MEASURE
                 , A.CAL_YYYYQQ AS YYYYMM
                 , A.CAL_YYYYQQ AS CAL_YYYYQQ
                 , A.CAL_YYYY AS CAL_YYYY
                 , CASE WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
                        THEN SUM(QTY)
                        ELSE MAX(QTY)
                   END QTY
                 , 'Q_' || REPLACE(A.CAL_YYYYQQ, 'Q', '_') AS COLNAME
                 , A.DEPT_ID
                 , MAX(A.END_CUSTOMER)
                 , MAX(A.BIZ_TYPE)
                 , MAX(A.PROJECT_NAME)
                 , A.ITEM_USE
                 , A.UNIT_ENERGY
              FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE A.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO)
               AND NOT (A.VERSION_NO = 'CURRENT')
             GROUP BY VERSION_NO
                    , A.DIVISION_ID
                    , A.CUTOFF_YYYYMMDD
                    , A.PROJECT_CODE
                    , A.SCM_SITE_ID
                    , A.PLANT_SITE_ID
                    , A.ITEM_ID
                    , A.INCOTERMS
                    , A.CELL_PROD_SITE
                    , A.FCST_TYPE
                    , A.CURRENCY
                    , A.MEASURE
                    , A.YYYYMM
                    , A.CAL_YYYYQQ
                    , A.CAL_YYYY
                    , A.DEPT_ID
                    , A.ITEM_USE
                    , A.UNIT_ENERGY
            ;

            --YEARLY
            INSERT INTO SCM_MGR.GT_DM51_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                , INCOTERMS, CELL_PROD_SITE, FCST_TYPE, CURRENCY, MEASURE, YYYYMM, CAL_YYYYQQ, CAL_YYYY, QTY
                , COLNAME, DEPT_ID, END_CUSTOMER, BIZ_TYPE, PROJECT_NAME, ITEM_USE, UNIT_ENERGY )
            SELECT VERSION_NO
                 , A.CUTOFF_YYYYMMDD
                 , A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , A.PLANT_SITE_ID
                 , A.ITEM_ID
                 , A.INCOTERMS
                 , A.CELL_PROD_SITE
                 , A.FCST_TYPE
                 , A.CURRENCY
                 , A.MEASURE
                 , A.CAL_YYYY AS YYYYMM
                 , A.CAL_YYYY AS CAL_YYYYQQ
                 , A.CAL_YYYY
                 , CASE WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
                        THEN SUM(QTY)
                        ELSE MAX(QTY)
                   END QTY
                 , 'Y_' || A.CAL_YYYY AS COLNAME
                 , A.DEPT_ID
                 , MAX(A.END_CUSTOMER)
                 , MAX(A.BIZ_TYPE)
                 , MAX(A.PROJECT_NAME)
                 , A.ITEM_USE
                 , A.UNIT_ENERGY
              FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE A.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO)
               AND NOT (A.VERSION_NO = 'CURRENT')
               AND A.COLNAME LIKE 'Q_%'
             GROUP BY VERSION_NO
                    , A.DIVISION_ID
                    , A.CUTOFF_YYYYMMDD
                    , A.PROJECT_CODE
                    , A.SCM_SITE_ID
                    , PLANT_SITE_ID
                    , A.ITEM_ID
                    , A.INCOTERMS
                    , A.CELL_PROD_SITE
                    , A.FCST_TYPE
                    , A.CURRENCY
                    , A.MEASURE
                    , A.YYYYMM
                    , A.CAL_YYYYQQ
                    , A.CAL_YYYY
                    , A.DEPT_ID
                    , A.ITEM_USE
                    , A.UNIT_ENERGY
            ;
        END IF;

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : A--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '=>' || TO_CHAR(SQL%ROWCOUNT));

        --=================================================================================================================================
        --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START (AS-IS dump:505-616)
        --> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다. (0022 선례 — 명시 컬럼 리스트)
        --=================================================================================================================================
        INSERT INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V
              (COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, ITEM_NAME, NICK_NAME, ITEM_TYPE
              ,ITEM_CLASS_LEVEL_1, ITEM_CLASS_LEVEL_2, ITEM_CLASS_LEVEL_3, ITEM_CLASS_LEVEL_4
              ,ITEM_CLASS, ITEM_CLASS_NAME, MATERIAL_CLASS, MATERIAL_CLASS_NAME, ELECTRODE_TYPE, SIDE_TYPE
              ,ITEM_GROUP_ID, SETUP_GROUP_ID_1, SETUP_GROUP_ID_2, SETUP_GROUP_ID_3, FLOW_ID, ERP_EOL, SCP_EOL
              ,ITEM_UOM, SPEC, DEMAND_LOT_SIZE, ITEM_ATTRIBUTE, SETUP_ATTRIBUTE, BATCH_RATIO_ID, OUTSOURCING_FACTORY
              ,FINITE_TERM, FINITE_TERM_UOM, COATED_LENGTH, UNCOATED_LENGTH, LENGTH_UOM, SLURRY_LOSS_RATE
              ,DESCRIPTION, ACTIVE_FLAG, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME, APPLIED_MODEL, CELL_TYPE
              ,MAKE_AND_BUY, COLOR_ATTRIBUTE, FORMATION_FLOW_ID, STANDARD_COST, CURRENCY, FORM_ATTRIBUTE, ENERGE
              ,SCP_FLOW_ID, SCP_OPERATION_GROUP, SCP_OPERATION_GROUP_ID, MDM_PROJECT_NAME, MIN_CAPACITY, MOBILE_MODEL_ID
              ,FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
              ,FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, DOE, INSULATION_COATING, PACK_PRODUCT_GROUP_CODE
              ,CELL_QUANTITY, SCP_EXTRA_SPEC, SCM_PIC, REP_CUSTOMER, MAKER, EVAL_CLASS, EVAL_CLASS_INFO
              ,FP_EXTRA_SPEC, MRP_USE_FLAG, ITEM_RAW_PLANT_ID, ITEM_COPY_YN)
        SELECT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, ITEM_NAME, NICK_NAME, ITEM_TYPE
              ,ITEM_CLASS_LEVEL_1, ITEM_CLASS_LEVEL_2, ITEM_CLASS_LEVEL_3, ITEM_CLASS_LEVEL_4
              ,ITEM_CLASS, ITEM_CLASS_NAME, MATERIAL_CLASS, MATERIAL_CLASS_NAME, ELECTRODE_TYPE, SIDE_TYPE
              ,ITEM_GROUP_ID, SETUP_GROUP_ID_1, SETUP_GROUP_ID_2, SETUP_GROUP_ID_3, FLOW_ID, ERP_EOL, SCP_EOL
              ,ITEM_UOM, SPEC, DEMAND_LOT_SIZE, ITEM_ATTRIBUTE, SETUP_ATTRIBUTE, BATCH_RATIO_ID, OUTSOURCING_FACTORY
              ,FINITE_TERM, FINITE_TERM_UOM, COATED_LENGTH, UNCOATED_LENGTH, LENGTH_UOM, SLURRY_LOSS_RATE
              ,DESCRIPTION, ACTIVE_FLAG, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME, APPLIED_MODEL, CELL_TYPE
              ,MAKE_AND_BUY, COLOR_ATTRIBUTE, FORMATION_FLOW_ID, STANDARD_COST, CURRENCY, FORM_ATTRIBUTE, ENERGE
              ,SCP_FLOW_ID, SCP_OPERATION_GROUP, SCP_OPERATION_GROUP_ID, MDM_PROJECT_NAME, MIN_CAPACITY, MOBILE_MODEL_ID
              ,FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
              ,FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, DOE, INSULATION_COATING, PACK_PRODUCT_GROUP_CODE
              ,CELL_QUANTITY, SCP_EXTRA_SPEC, SCM_PIC, REP_CUSTOMER, MAKER, EVAL_CLASS, EVAL_CLASS_INFO
              ,FP_EXTRA_SPEC, MRP_USE_FLAG, ITEM_RAW_PLANT_ID, ITEM_COPY_YN
          FROM SCM_MGR.SCM_MST_ITEM_SN
         WHERE DIVISION_ID = P_DIVISION_ID
        --[E20260820-D51ITEMPFX] hook #129 ④ 선행축소 — 소비되지 않는 품목을 GTT 에 싣지 않는다.
        --  ⚠ 축소 단위는 반드시 SUBSTR(ITEM_ID,1,12) prefix.
        --     하류 _B_V 가 (DIVISION_ID, SUBSTR(ITEM_ID,1,12)) 로 MAX 집계하므로 정확 ITEM_ID 로 축소하면
        --     같은 prefix 를 공유하는 형제 품목이 빠져 MAX 그룹이 바뀐다(값 등가 파괴). prefix 단위면 그룹 원형 보존.
        --  전제(정적 확인): GT_DM51_RAW_DATA 의 INSERT 는 전부 이 문장보다 위(본문 688/727/777/834/874/928)에서 끝나고,
        --     이 아래는 DELETE(1215~1324) 뿐이라 prefix 집합은 최종 집합의 상위집합 → 축소 과소 위험 없음.
        --  등가: 소비처는 모두 정확 (DIVISION_ID, ITEM_ID) 로 조인/EXISTS 하며, RAW_DATA 의 ITEM_ID 는
        --     정의상 자기 prefix 가 집합에 있으므로 SN 에 존재하면 반드시 잔류한다(=조인 결과 불변).
        --  사내 div40 실측: 243,050행 → 6,053행 (-97.5%), 원장 prefix 899종
           AND SUBSTR(ITEM_ID, 1, 12) IN (SELECT DISTINCT SUBSTR(R.ITEM_ID, 1, 12)
                                            FROM SCM_MGR.GT_DM51_RAW_DATA R)
        ;

        --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
        INSERT INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V
              (DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
              ,MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG
              ,ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC)
        SELECT T1.DIVISION_ID
             , T1.ITEM_ID
             , MAX(T1.ITEM_NAME)                        AS ITEM_NAME
             , MAX(T1.ITEM_CLASS)                       AS ITEM_CLASS
             , MAX(T1.ITEM_CLASS_NAME)                  AS ITEM_CLASS_NAME
             , MAX(T1.NICK_NAME)                        AS NICK_NAME
             , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                              WHEN T1.ITEM_TYPE = 'H' THEN 2
                              WHEN T1.ITEM_TYPE = 'Q' THEN 3
                         ELSE 4 END )
                                        WHEN 1 THEN 'P'
                                        WHEN 2 THEN 'H'
                                        WHEN 3 THEN 'Q'
                                        ELSE 'R' END    AS ITEM_TYPE
             , MAX(T1.MATERIAL_CLASS_NAME)              AS MATERIAL_CLASS_NAME
             , MAX(T1.ITEM_UOM)                         AS ITEM_UOM
             , MAX(T1.SPEC)                             AS SPEC
             , MAX(T1.MDM_PROJECT_NAME)                 AS MDM_PROJECT_NAME
             , MAX(T1.MIN_CAPACITY)                     AS MIN_CAPACITY
             , MAX(T1.ACTIVE_FLAG)                      AS ACTIVE_FLAG
             , MAX(T1.ENERGE)                           AS ENERGE
             , MAX(T1.CELL_QUANTITY)                    AS CELL_QUANTITY
             , MAX(T1.SCP_EXTRA_SPEC)                   AS SCP_EXTRA_SPEC
          FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V T1
         WHERE 1=1
         GROUP BY T1.DIVISION_ID, T1.ITEM_ID
        ;

        --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
        INSERT INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V
              (DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
              ,FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE)
        SELECT DIVISION_ID
             , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
             , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
             , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
             , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
             , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
             , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
             , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
             , MAX(CELL_TYPE) AS CELL_TYPE
          FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_ORI_V T2
         GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
        ;

        --TEMP 테이블에 넣은 데이터를 JOIN 한다. (AS-IS dump:555-614 — 0022 와 달리 RAW_DATA 필터 없음, 1:1 유지)
        INSERT INTO SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V
              (DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
              ,MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
              ,FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
              ,FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
              ,ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.ITEM_NAME
             , A.ITEM_CLASS
             , A.ITEM_CLASS_NAME
             , A.NICK_NAME
             , A.ITEM_TYPE
             , A.MATERIAL_CLASS_NAME
             , A.ITEM_UOM
             , A.SPEC
             , A.MDM_PROJECT_NAME
             , A.MIN_CAPACITY
             , A.FORECAST_INFO_BIZ_TYPE
             , A.FORECAST_INFO_PRODUCT_GROUP
             , A.FORECAST_INFO_CELL_MODEL
             , A.FORECAST_INFO_CELL_PACK_COUNT
             , A.FORECAST_INFO_SPEC
             , A.FORECAST_INFOR_VERSION
             , A.ACTIVE_FLAG
             , A.CELL_TYPE
             , A.ENERGE
             , A.CELL_QUANTITY
             , A.SCP_EXTRA_SPEC
          FROM
          (
              SELECT T1.DIVISION_ID
                   , T1.ITEM_ID
                   , T1.ITEM_NAME                          AS ITEM_NAME
                   , T1.ITEM_CLASS                         AS ITEM_CLASS
                   , T1.ITEM_CLASS_NAME                    AS ITEM_CLASS_NAME
                   , T1.NICK_NAME                          AS NICK_NAME
                   , T1.ITEM_TYPE                          AS ITEM_TYPE
                   , T1.MATERIAL_CLASS_NAME                AS MATERIAL_CLASS_NAME
                   , T1.ITEM_UOM                           AS ITEM_UOM
                   , T1.SPEC                               AS SPEC
                   , T1.MDM_PROJECT_NAME                   AS MDM_PROJECT_NAME
                   , T1.MIN_CAPACITY                       AS MIN_CAPACITY
                   , T2.FORECAST_INFO_BIZ_TYPE             AS FORECAST_INFO_BIZ_TYPE
                   , T2.FORECAST_INFO_PRODUCT_GROUP        AS FORECAST_INFO_PRODUCT_GROUP
                   , T2.FORECAST_INFO_CELL_MODEL           AS FORECAST_INFO_CELL_MODEL
                   , T2.FORECAST_INFO_CELL_PACK_COUNT      AS FORECAST_INFO_CELL_PACK_COUNT
                   , T2.FORECAST_INFO_SPEC                 AS FORECAST_INFO_SPEC
                   , T2.FORECAST_INFOR_VERSION             AS FORECAST_INFOR_VERSION
                   , T1.ACTIVE_FLAG                        AS ACTIVE_FLAG
                   , T2.CELL_TYPE                          AS CELL_TYPE
                   , T1.ENERGE                             AS ENERGE
                   , T1.CELL_QUANTITY                      AS CELL_QUANTITY
                   , T1.SCP_EXTRA_SPEC                     AS SCP_EXTRA_SPEC
                FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_A_V T1
               INNER JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_B_V T2
                       ON T1.DIVISION_ID = T2.DIVISION_ID
                      AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
               WHERE 1=1
          ) A
        --[E20260820-D51REGROUP] 무용 GROUP BY 제거 (값 무영향 — 증명):
        --  A_V = GROUP BY (DIVISION_ID, ITEM_ID)           → (DIVISION_ID, ITEM_ID) 유일
        --  B_V = GROUP BY (DIVISION_ID, SUBSTR(ITEM_ID,1,12)) → 조인키당 최대 1행
        --  ⇒ 인라인뷰 A 는 이미 (DIVISION_ID, ITEM_ID) 유일이고 GROUP BY 목록이 그 두 컬럼을 포함하므로
        --    전 컬럼 GROUP BY 는 항등 연산(행 축약 0). 사내 실측 169,928행 IN = 169,928행 OUT.
        ;
        --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : B--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '=>' || TO_CHAR(SQL%ROWCOUNT));

        --AS-IS CREATE CLUSTERED INDEX IDX1_TEMP_DM_MST_ITEM_SINGLE_V (division_id, item_id)
        -- → Oracle GTT: 세션 통계 수집으로 대체 (0022 선례)
        DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM22_DM_MST_ITEM_SINGLE_V',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);

        --=================================================================================================================================
        -- SCM_MST_SSO_USER_INFO 임시테이블(#TEMP_SCM_MST_SSO_USER_INFO — 단순 사본) → 0022 선례대로 원 테이블 직접 조회로 대체
        -- SCM_MST_SITE_ITEM 임시테이블 생성 (AS-IS dump:634-647)
        --=================================================================================================================================
        INSERT INTO SCM_MGR.GT_DM51_SCM_MST_SITE_ITEM
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY, CUST_GROUP
            ,CUST_GROUP_DTL, APPLICATION, ROUTE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5
            ,REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5
            ,REPORT_GROUP6, OWNER, CELL_PER_CAR, CELL_PER_MODULE
            ,OWNER_NAME, OWNER_NAME_KO, DEPT_ID)
        --[E20260820-D51SCALAR] hook #129 ① SELECT 목록 행별 상관 스칼라/함수 제거 → 선계산 + LEFT JOIN
        --  FN_GET_DM_MKT_OWNER_NAME(EN/KO) 와 DEPT_ID 스칼라 서브쿼리는 모두 OWNER 만의 결정함수이므로
        --  DISTINCT OWNER 당 1회만 평가한 뒤 조인한다. 값 산식·NULL 거동(미매칭 → NULL) 원본 동일.
        --  사내 div40 실측: 대상 23,193행 / DISTINCT OWNER 88종 (함수·서브쿼리 평가 69,579회 → 264회)
        SELECT SMSI.DIVISION_ID, SMSI.SCM_SITE_ID, SMSI.PROJECT_CODE, SMSI.ITEM_ID, SMSI.CURRENCY, SMSI.CUST_GROUP
             , SMSI.CUST_GROUP_DTL, SMSI.APPLICATION, SMSI.ROUTE, SMSI.ATTRIBUTE1, SMSI.ATTRIBUTE2, SMSI.ATTRIBUTE5
             , SMSI.REPORT_GROUP1, SMSI.REPORT_GROUP2, SMSI.REPORT_GROUP3, SMSI.REPORT_GROUP4, SMSI.REPORT_GROUP5
             , SMSI.REPORT_GROUP6, SMSI.OWNER, SMSI.CELL_PER_CAR, SMSI.CELL_PER_MODULE
             , OW.OWNER_NAME                                                          AS OWNER_NAME
             , OW.OWNER_NAME_KO                                                       AS OWNER_NAME_KO
             , OW.DEPT_ID                                                             AS DEPT_ID
          FROM SCM_MGR.SCM_MST_SITE_ITEM SMSI
          LEFT JOIN ( SELECT O.OWNER                                                  AS OWNER
                           , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(O.OWNER, ',', 'EN')     AS OWNER_NAME
                           , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(O.OWNER, ',', 'KO')     AS OWNER_NAME_KO
                           , ( SELECT SU.DEPT_ID
                                 FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU
                                WHERE SU.USER_ID = (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(O.OWNER, ',')) P WHERE ROWNUM = 1)
                             ) AS DEPT_ID
                        FROM ( SELECT DISTINCT OWNER
                                 FROM SCM_MGR.SCM_MST_SITE_ITEM
                                WHERE DIVISION_ID = P_DIVISION_ID ) O
                    ) OW
                 ON OW.OWNER = SMSI.OWNER
         WHERE SMSI.DIVISION_ID = P_DIVISION_ID
        ;

        DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM51_SCM_MST_SITE_ITEM',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);

        --=================================================================================================================================
        -- CITY, COUNTRY 취득할 임시테이블 생성 (AS-IS dump:650-678 1:1)
        --=================================================================================================================================
        INSERT INTO SCM_MGR.GT_DM51_SCM_CITY
            (DIVISION_ID, SOLDTO_CUSTOMER, END_CUSTOMER, DEPT_ID, SCM_SITE_ID, VMI_YN, VALID_YN, CITY_NAME, COUNTRY_NAME)
        SELECT S.DIVISION_ID
             , S.SOLDTO_CUSTOMER
             , S.END_CUSTOMER
             , S.DEPT_ID
             , S.SCM_SITE_ID
             , S.VMI_YN
             , S.VALID_YN
             , S.CITY_NAME
             , S.COUNTRY_NAME
          FROM SCM_MGR.DM_PLN_BP_FCST A
          LEFT JOIN (SELECT X.DIVISION_ID
                          , X.SOLDTO_CUSTOMER
                          , X.END_CUSTOMER
                          , X.DEPT_ID
                          , X.SCM_SITE_ID
                          , X.VMI_YN
                          , X.VALID_YN
                          , Y.CITY_NAME
                          , Z.COUNTRY_NAME
                       FROM SCM_MGR.SCM_MST_SITE    X
                          , SCM_MGR.SCM_MST_CITY    Y
                          , SCM_MGR.SCM_MST_COUNTRY Z
                      WHERE X.CITY = Y.CITY AND X.COUNTRY = Z.COUNTRY
                    ) S
                 ON A.DIVISION_ID = S.DIVISION_ID
                AND A.SCM_SITE_ID = S.SCM_SITE_ID
         WHERE A.DIVISION_ID = P_DIVISION_ID
        ;

        DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','GT_DM51_SCM_CITY',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1', no_invalidate => FALSE);

        --=================================================================================================================================
        -- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 )
        -- (AS-IS dump:680-875 — DELETE+LEFT JOIN → DELETE WHERE NOT EXISTS, 0022 선례 형식)
        --=================================================================================================================================
        -- 필터링 시작
        IF NVL(P_PROJECT_CODE, '@#@#@#') <> '@#@#@#' THEN -- 소형은 UI 에서 PROJECT DISABLE 됨
            DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.PROJECT_CODE = B.PROJECT_CODE
                          AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_PROJECT_CODE,'^',','),',')) P WHERE B.PROJECT_CODE LIKE '%' || P.TOKEN || '%')
                               OR
                               EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_PROJECT_CODE,'^',','),',')) P WHERE B.PROJECT_NAME LIKE '%' || P.TOKEN || '%')
                              )
                   );
        END IF;

        IF NVL(P_ITEM_ID, '@#@#@#') <> '@#@#@#' THEN
            DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V B
                        WHERE A.ITEM_ID = B.ITEM_ID
                          AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_ITEM_ID,'^',','),',')) P WHERE A.ITEM_ID LIKE '%' || P.TOKEN || '%')
                               OR
                               EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_ITEM_ID,'^',','),',')) P WHERE B.NICK_NAME LIKE '%' || P.TOKEN || '%')
                              )
                   );
        END IF;

        IF NVL(P_OWNER, '@#@#@#') <> '@#@#@#' THEN
            DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.GT_DM51_SCM_MST_SITE_ITEM B
                        WHERE A.ITEM_ID      = B.ITEM_ID
                          AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                          AND A.PROJECT_CODE = B.PROJECT_CODE
                          AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_OWNER,'^',','),',')) P WHERE B.OWNER LIKE '%' || P.TOKEN || '%')
                               OR
                               EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_OWNER,'^',','),',')) P WHERE B.OWNER_NAME LIKE '%' || P.TOKEN || '%')
                               OR
                               EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_OWNER,'^',','),',')) P WHERE B.OWNER_NAME_KO LIKE '%' || P.TOKEN || '%')
                              )
                   );
        END IF;

        IF P_DEPT_ID <> 'ALL' THEN
            --[PJ2024-50461] Team Mapping------------------------------------
            DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.GT_DM51_SCM_MST_SITE_ITEM B
                        WHERE A.ITEM_ID      = B.ITEM_ID
                          AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                          AND A.PROJECT_CODE = B.PROJECT_CODE
                          AND B.DEPT_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_DEPT_ID,'^',','),',')) P)
                   );
        END IF;

        IF P_END_CUSTOMER <> 'ALL' THEN
            IF P_DIVISION_ID = '40' THEN
                DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
                 WHERE A.PROJECT_CODE NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_END_CUSTOMER,'^',','),',')) P)
                ;
            ELSE
                DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
                 WHERE NOT EXISTS (
                           SELECT 1 FROM SCM_MGR.SCM_MST_SITE B
                            WHERE A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
                              AND B.END_CUSTOMER IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_END_CUSTOMER,'^',','),',')) P)
                       );
            END IF;
        END IF;

        IF P_SCM_SITE_ID <> 'ALL' THEN
            DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE A.SCM_SITE_ID NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_SCM_SITE_ID,'^',','),',')) P)
            ;
        END IF;

        IF P_PLANT_SITE_ID <> 'ALL' THEN
            DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE A.PLANT_SITE_ID NOT IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_PLANT_SITE_ID,'^',','),',')) P)
            ;
        END IF;

        IF P_ITEM_TYPE <> 'ALL' THEN
            DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE NOT EXISTS (
                       SELECT 1 FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V B
                        WHERE A.ITEM_ID = B.ITEM_ID
                          AND B.ITEM_TYPE IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_ITEM_TYPE,'^',','),',')) P)
                   );
        END IF;

        IF P_BIZTYPE <> 'ALL' THEN
            IF P_DIVISION_ID = '40' THEN
                DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
                 WHERE NOT EXISTS (
                           SELECT 1 FROM SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V B
                            WHERE A.ITEM_ID = B.ITEM_ID
                              AND B.FORECAST_INFO_BIZ_TYPE IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_BIZTYPE,'^',','),',')) P)
                       );
            ELSE
                DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
                 WHERE NOT EXISTS (
                           SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT B
                            WHERE A.DIVISION_ID  = B.DIVISION_ID
                              AND A.PROJECT_CODE = B.PROJECT_CODE
                              AND EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(REPLACE(P_BIZTYPE,'^',','),',')) P WHERE B.BIZ_TYPE LIKE '%' || P.TOKEN || '%')
                       );
            END IF;
        END IF;

        IF P_QTY_YN = 'Y' THEN
            -- [C20221107-000343]BP Waterfall 오류 수정 요청의 건 — Business_Plan SUM(QTY)=0 차원조합 전체 제거
            DELETE FROM SCM_MGR.GT_DM51_RAW_DATA A
             WHERE EXISTS (
                       SELECT 1
                         FROM (SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                                    , INCOTERMS, CELL_PROD_SITE, FCST_TYPE, CURRENCY, MEASURE
                                    , DEPT_ID, END_CUSTOMER, BIZ_TYPE, PROJECT_NAME
                                 FROM SCM_MGR.GT_DM51_RAW_DATA
                                WHERE MEASURE = 'Business_Plan'
                                GROUP BY VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                                       , INCOTERMS, CELL_PROD_SITE, FCST_TYPE, CURRENCY, MEASURE
                                       , DEPT_ID, END_CUSTOMER, BIZ_TYPE, PROJECT_NAME
                               HAVING SUM(QTY) = 0) B
                        WHERE A.VERSION_NO     = B.VERSION_NO
                          AND A.DIVISION_ID    = B.DIVISION_ID
                          AND A.PROJECT_CODE   = B.PROJECT_CODE
                          AND A.SCM_SITE_ID    = B.SCM_SITE_ID
                          AND A.ITEM_ID        = B.ITEM_ID
                          AND A.FCST_TYPE      = B.FCST_TYPE
                          AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID
                          AND A.DEPT_ID        = B.DEPT_ID
                          AND A.END_CUSTOMER   = B.END_CUSTOMER
                          AND A.BIZ_TYPE       = B.BIZ_TYPE
                          AND A.CURRENCY       = B.CURRENCY
                          AND A.INCOTERMS      = B.INCOTERMS
                          AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
                   );
        END IF;
        -- 필터링 끝

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : C--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '=>' || TO_CHAR(SQL%ROWCOUNT));

        --=================================================================================================================================
        -- 컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
        --=================================================================================================================================

        -----   날짜컬럼 (AS-IS dump:897-937 c_bucket FAST_FORWARD 커서 → FOR 루프, 0022 선례) -----------------------------------------
        -- [C20221107-000343]BP Waterfall 오류 수정 요청의 건
        V_PV_LIST     := '';
        V_PV_COL_LIST := '';

        FOR r IN (
            SELECT COLUMN_NAME, PV_NAME, SORT_ORDER_NO
              FROM (
                       -- MONTHLY
                       SELECT '''M_' || A.BASIS_YYYYMM || '''  AS M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                            , 'M_' || A.BASIS_YYYYMM || ' ' AS PV_NAME
                            , MIN(A.BASIS_START_DATE) || '_' || TO_CHAR(1, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                        GROUP BY A.BASIS_YYYYMM
                       UNION ALL
                       -- QUATERLY
                       SELECT '''Q_' || REPLACE(A.CALENDAR_YYYYQQ, 'Q', '_') || '''  AS Q_' || REPLACE(A.CALENDAR_YYYYQQ, 'Q', '_') AS COLUMN_NAME
                            , 'Q_' || REPLACE(A.CALENDAR_YYYYQQ, 'Q', '_') || ' ' AS PV_NAME
                            , MIN(A.BASIS_START_DATE) || '_' || TO_CHAR(1, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                        GROUP BY A.CALENDAR_YYYYQQ
                       UNION ALL
                       -- YEARLY
                       SELECT '''Y_' || A.CALENDAR_YYYY || '''  AS Y_' || A.CALENDAR_YYYY AS COLUMN_NAME
                            , 'Y_' || A.CALENDAR_YYYY || ' ' AS PV_NAME
                            , MIN(A.BASIS_START_DATE) || '_' || TO_CHAR(1, 'FM00') AS SORT_ORDER_NO
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                          AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                        GROUP BY A.CALENDAR_YYYY
                   )
             ORDER BY SORT_ORDER_NO
        ) LOOP
            IF V_PV_COL_LIST IS NOT NULL AND LENGTH(V_PV_COL_LIST) > 0 THEN
                V_PV_COL_LIST := V_PV_COL_LIST || ',' || r.COLUMN_NAME || CHR(10);
                V_PV_LIST     := V_PV_LIST     || ',' || r.PV_NAME || CHR(10);
            ELSE
                V_PV_COL_LIST := r.COLUMN_NAME || CHR(10);
                V_PV_LIST     := r.PV_NAME || CHR(10);
            END IF;
        END LOOP;

        -----   일반 컬럼 (AS-IS dump:940-1016) ---------------------------------------------------------------------------------------
        SELECT COUNT(*)
          INTO i_count
          FROM SCM_MGR.SCM_MST_TITLESET_USER U
         WHERE 1 = 1
           AND U.PROGRAM_ID = v_program_id
           AND U.SHEET_NAME = v_sheet_name
           AND U.USER_ID    = P_CREATED_BY
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

        IF i_count = 0 THEN
            FOR r IN (
                -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
                SELECT C.SORT_ORDER_NO
                     , C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
                  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                 WHERE 1 = 1
                   AND C.PROGRAM_ID = v_program_id
                   AND C.SHEET_NAME = v_sheet_name
                   AND ( C.DEFAULT_FLAG = 'Y' OR
                       (     C.VISIBLE_FLAG = 'N'
                         AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL   --[E20260806-00979] 빈값 판정: 공백(' ')과 '-' 동일 취급 (데이터 무수정 방침 — 클라우드 '-' 변형 흡수)
                         AND C.VALID_YN     = 'Y'
                       )
                       )
                 ORDER BY SORT_ORDER_NO
            ) LOOP
                IF v_ColList IS NOT NULL AND LENGTH(v_ColList) > 0 THEN
                    v_ColList   := v_ColList   || ',' || r.COLUMN_NAME || ' ' || CHR(10);
                    v_OrderList := v_OrderList || ',' || r.COLUMN_NAME || ' ' || r.DATA_SORT_METHOD_CODE || CHR(10);
                ELSE
                    v_ColList   := ' ' || r.COLUMN_NAME || ' ' || CHR(10);
                    v_OrderList := ' ' || r.COLUMN_NAME || ' ' || r.DATA_SORT_METHOD_CODE || CHR(10);
                END IF;
            END LOOP;
        ELSE
            FOR r IN (
                SELECT U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
                  FROM SCM_MGR.SCM_MST_TITLESET_USER U
                 INNER JOIN SCM_MGR.SCM_MST_SHEET_COLUMNS C
                         ON U.PROGRAM_ID  = C.PROGRAM_ID
                        AND U.SHEET_NAME  = C.SHEET_NAME
                        AND U.COLUMN_NAME = C.COLUMN_NAME
                        AND U.PROGRAM_ID  = v_program_id
                        AND U.SHEET_NAME  = v_sheet_name
                        AND U.USER_ID     = P_CREATED_BY
                        AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                        -- [C20221107-000343]BP Waterfall 오류 수정 요청의 건
                        AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID, ',')) P)
                ---------
                UNION ALL
                ---------
                SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE
                  FROM (SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE   -- AS-IS TOP 100
                          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                         WHERE 1 = 1
                           AND C.PROGRAM_ID   = v_program_id
                           AND C.SHEET_NAME   = v_sheet_name
                           AND C.VISIBLE_FLAG = 'N'
                           AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL   --[E20260806-00979] 빈값 판정: 공백(' ')과 '-' 동일 취급 (데이터 무수정 방침 — 클라우드 '-' 변형 흡수)
                           AND C.VALID_YN     = 'Y')
                 WHERE ROWNUM <= 100
                 ORDER BY SORT_ORDER_NO
            ) LOOP
                IF v_ColList IS NOT NULL AND LENGTH(v_ColList) > 0 THEN
                    v_ColList   := v_ColList   || ',' || r.COLUMN_NAME || ' ' || CHR(10);
                    v_OrderList := v_OrderList || ',' || r.COLUMN_NAME || ' ' || r.DATA_SORT_METHOD_CODE || CHR(10);
                ELSE
                    v_ColList   := ' ' || r.COLUMN_NAME || ' ' || CHR(10);
                    v_OrderList := ' ' || r.COLUMN_NAME || ' ' || r.DATA_SORT_METHOD_CODE || CHR(10);
                END IF;
            END LOOP;
        END IF;

        -- AS-IS 의 마지막 콤마 제거(LEFT(@ColList, LEN-1))는 Oracle 조립 방식(선행 콤마)에서는 불필요 (0022 선례)
        v_ColList   := REPLACE(v_ColList,   'VERSION_NO', 'VERSION_SORT,VERSION_NO');
        v_OrderList := REPLACE(v_OrderList, 'VERSION_NO', 'VERSION_SORT DESC,VERSION_NO');
        v_OrderList := REPLACE(v_OrderList, 'MEASURE',    'SORT_ORDER_NO,MEASURE');
        --  컬럼생성 끝 -----------------------------------------------------------------------------------------------------------------

        --=================================================================================================================================
        -- CTE 에서 사용할 SELECT COLUMN 정리 (AS-IS dump:1021-1120 — #T_COLUMN_SETUP 사전 전수 1:1)
        --=================================================================================================================================
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'VERSION_NO', 'A.VERSION_NO', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'DIVISION_ID', 'A.DIVISION_ID', 1);

        --[PJ2024-50461] Team Mapping------------------------------------
        --INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'DEPT_ID', 'A.DEPT_ID', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'DEPT_ID', 'C.DEPT_ID', 1);
        --[PJ2024-50461] Team Mapping------------------------------------

        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'END_CUSTOMER40', 'A.PROJECT_CODE AS END_CUSTOMER40', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'END_CUSTOMER', 'A.END_CUSTOMER', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'SCM_SITE_ID40', 'A.SCM_SITE_ID AS SCM_SITE_ID40', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'SCM_SITE_ID81', 'A.SCM_SITE_ID AS SCM_SITE_ID81', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'SCM_SITE_ID82', 'A.SCM_SITE_ID AS SCM_SITE_ID82', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'PROJECT_CODE', 'A.PROJECT_CODE AS PROJECT_CODE', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'PROJECT_CODE82', 'A.PROJECT_CODE AS PROJECT_CODE82', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'BIZ_TYPE_NAME81', 'A.BIZ_TYPE AS BIZ_TYPE_NAME81', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'ITEM_ID', 'A.ITEM_ID AS ITEM_ID', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'ITEM_ID40', 'A.ITEM_ID AS ITEM_ID40', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'INCOTERMS', 'A.INCOTERMS', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'FCST_TYPE', 'A.FCST_TYPE', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'PLANT_SITE_ID', 'A.PLANT_SITE_ID', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'J', 'CELL_PROD_SITE', 'J.ATTRIBUTE1 AS CELL_PROD_SITE', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'ITEM_USE', 'A.ITEM_USE', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'UNIT_ENERGY', 'A.UNIT_ENERGY', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'MEASURE', 'A.MEASURE', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'YYYYMMDD', 'A.YYYYMMDD', 1);   -- AS-IS 잔재: #RAW_DATA 에 YYYYMMDD 컬럼 부재 (선택 시 AS-IS 도 오류 — 1:1 보존)
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'QTY', 'A.QTY', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'A', 'VERSION_SORT', 'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'B', 'PRODUCT_GROUP_NAME', 'CASE WHEN A.DIVISION_ID = ''40'' THEN '''' ELSE B.PRODUCT_GROUP_NAME END AS PRODUCT_GROUP_NAME', 1);
        --[C-7] AS-IS: B.PROJECT_NAME = '' OR IS NULL → Oracle ''=NULL 이므로 RTRIM IS NULL 로 흡수 (PKG_DMF0042 계보)
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'AB', 'PROJECT_NAME', 'CASE WHEN A.DIVISION_ID = ''40'' THEN A.PROJECT_NAME
                                                                                        WHEN RTRIM(B.PROJECT_NAME) IS NULL THEN A.PROJECT_NAME
                                                                                        ELSE B.PROJECT_NAME END PROJECT_NAME', 1);
        --[C-7] AS-IS: A.CURRENCY = '' → RTRIM(A.CURRENCY) IS NULL (PKG_DMF0042 정본 — 원본 A.CURRENCY = '' (빈문자/공백 → RTRIM IS NULL))
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'AC', 'CURRENCY', 'CASE WHEN RTRIM(A.CURRENCY) IS NULL THEN C.CURRENCY ELSE NVL(A.CURRENCY, C.CURRENCY) END AS CURRENCY ', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'DEPT_ID40', 'C.DEPT_ID AS DEPT_ID40', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP', 'C.CUST_GROUP', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP_DTL', 'C.CUST_GROUP_DTL', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'OWNER', 'CASE WHEN A.DIVISION_ID = ''40'' THEN C.OWNER_NAME ELSE SUBSTR(C.OWNER_NAME, 1, 100) END AS OWNER', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'APPLICATION', 'C.APPLICATION', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'ROUTE', 'C.ROUTE', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'DMS_SALES', 'NVL(C.ATTRIBUTE1,'''')  AS DMS_SALES', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'DMS_CUSTOMER', 'NVL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'REPORT_GROUP1', 'C.REPORT_GROUP1 AS REPORT_GROUP1', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'REPORT_GROUP2', 'C.REPORT_GROUP2 AS REPORT_GROUP2', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'REPORT_GROUP3', 'C.REPORT_GROUP3 AS REPORT_GROUP3', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'REPORT_GROUP4', 'C.REPORT_GROUP4 AS REPORT_GROUP4', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'REPORT_GROUP5', 'C.REPORT_GROUP5 AS REPORT_GROUP5', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'REPORT_GROUP6', 'C.REPORT_GROUP6 AS REPORT_GROUP6', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'C', 'FORECAST_INFO_CELL_MODEL', 'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'BIZ_TYPE_NAME40', 'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'ITEM_CLASS_NAME', 'NVL(D.ITEM_CLASS_NAME, '''') AS ITEM_CLASS_NAME', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'ITEM_NAME', 'NVL(D.ITEM_NAME, '''') AS ITEM_NAME', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'ITEM_TYPE', 'NVL(D.ITEM_TYPE, '''') AS ITEM_TYPE', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'NICK_NAME', 'NVL(D.NICK_NAME, '''') AS NICK_NAME', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_SPEC', 'D.FORECAST_INFO_SPEC', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'MDM_PROJECT_NAME', 'D.MDM_PROJECT_NAME', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'MIN_CAPACITY', 'D.MIN_CAPACITY', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'D', 'CELL_TYPE', '(SELECT LMD.SEGMENT2  AS NAME FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LMD WHERE LOOKUP_TYPE = ''CELL_TYPE'' AND D.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'E', 'CELL_PER_CAR', 'CASE WHEN A.DIVISION_ID = ''40'' THEN 0 ELSE NVL(E.CELL_PER_CAR, 0) END AS CELL_PER_CAR', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'E', 'MODULE_PER_CAR', 'CASE WHEN A.DIVISION_ID = ''40'' THEN 0
                                                                                        ELSE CASE WHEN E.CELL_PER_MODULE  <> 0 THEN E.CELL_PER_CAR / E.CELL_PER_MODULE
                                                                                                  ELSE 0 END END AS MODULE_PER_CAR', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'G', 'VMI_YN', 'G.VMI_YN', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'G', 'CITY_NAME', 'G.CITY_NAME', 1);
        INSERT INTO SCM_MGR.GT_DM22_T_COLUMN_SETUP VALUES ( 'G', 'COUNTRY_NAME', 'G.COUNTRY_NAME', 1);

        -- #T (컬럼순서) 구성 (AS-IS dump:1101-1104 — UF_FX_String_Split(@ColList) JOIN, 0022 선례 REGEXP 분해)

        --[E20260828-ALLCOLS] 사용자 지시(2026-08-28): UI CATEGORY 전체 컬럼 반환 — FE OLAP 은 DEFAULT/titleset 컬럼만 Rows 축에 두고
        --   나머지는 필드 후보(드래그)로 쓴다. 사업부 매칭 VALID 컬럼 중 사전(GT_DM22_T_COLUMN_SETUP)에 있고 목록에 없는 것만 뒤에 덧붙임.
        --   ORDER 는 기존 유지. MEASURE/VERSION_NO 계열·NOTATION 은 REPLACE 규약 보호를 위해, 감사 4컬럼은 집계 grain 보호를 위해 제외.
        DECLARE
            V_EXTRA_COLS VARCHAR2(32767 CHAR);
        BEGIN
            SELECT LISTAGG(',' || C.COLUMN_NAME, '') WITHIN GROUP (ORDER BY C.SORT_ORDER_NO)
              INTO V_EXTRA_COLS
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID = v_program_id
               AND C.SHEET_NAME = v_sheet_name
               AND C.VALID_YN   = 'Y'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID, ',')))
               AND C.COLUMN_NAME NOT LIKE '%MEASURE%'
               AND C.COLUMN_NAME NOT LIKE '%VERSION_NO%'
               AND C.COLUMN_NAME <> 'NOTATION'
               AND C.COLUMN_NAME NOT IN ('CREATION_DATE','CREATED_BY','LAST_UPDATE_DATE','LAST_UPDATED_BY') -- 감사컬럼은 집계 grain 을 쪼갬(1차 적용 761→806행 실측)
               AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DM22_T_COLUMN_SETUP D WHERE D.COLUMN_NAME = C.COLUMN_NAME)
               AND INSTR(',' || REPLACE(REPLACE(v_ColList, ' ', ''), CHR(10), '') || ',', ',' || C.COLUMN_NAME || ',') = 0;
            IF V_EXTRA_COLS IS NOT NULL THEN
                v_ColList := v_ColList || V_EXTRA_COLS;
            END IF;
        END;
        INSERT INTO SCM_MGR.GT_DM22_T (COLUMN_STRING, SEQ)
        SELECT B.COLUMN_STRING, ROW_NUMBER() OVER (ORDER BY B.SORT_KEY) AS SEQ
          FROM (
                   SELECT TRIM(REPLACE(REPLACE(REPLACE(TOKEN, '[', ''), ']', ''), CHR(10), '')) AS TOKEN
                     FROM (
                              SELECT TRIM(REGEXP_SUBSTR(v_ColList, '[^,]+', 1, LEVEL)) AS TOKEN
                                FROM DUAL
                              CONNECT BY REGEXP_SUBSTR(v_ColList, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
               ) A
          JOIN SCM_MGR.GT_DM22_T_COLUMN_SETUP B ON A.TOKEN = B.COLUMN_NAME;

        SELECT COUNT(*) INTO v_CNT FROM SCM_MGR.GT_DM22_T;
        V_SQL_SELECT := '';
        v_I := 1;

        WHILE ( v_I <= v_CNT ) LOOP
            DECLARE
                v_col_str VARCHAR2(4000 CHAR);
            BEGIN
                SELECT COLUMN_STRING INTO v_col_str FROM SCM_MGR.GT_DM22_T WHERE SEQ = v_I;
                V_SQL_SELECT := V_SQL_SELECT || CASE WHEN v_I = 1 THEN '' ELSE ',' END || v_col_str || CHR(10);
            END;
            v_I := v_I + 1;
        END LOOP;

        --=================================================================================================================================
        -- SQL실행문 (AS-IS dump:1123-1235 — #WF → CTE T_DM51_WF, 0022 선례. EditYn = 사내 표준 EDIT_AUTH_V 조인)
        --=================================================================================================================================
        --[E20260820-D51SEMI] div40 분기: INNER JOIN SCM_MGR.SCM_MST_SITE F → WHERE EXISTS 로 전환 (등가 — 증명)
        --  · F 는 GT_DM22_T_COLUMN_SETUP 의 어느 별칭에도 쓰이지 않아 SELECT 목록에 기여하지 않는다
        --  · 조인키 (DIVISION_ID, SCM_SITE_ID) = PK_SCM_MST_SITE (사내 실측 3,029/3,029 유일) → 매칭 0 또는 1행, 증식 불가
        --  ⇒ INNER JOIN 은 순수 존재필터이므로 EXISTS 와 결과 동일. 권한축(EDY) 은 원본 그대로 보존한다.
        --  사내 실측 근거: 이 조인이 NESTED LOOPS + PK 단일스캔 1,033K회 = 최종문 버퍼겟의 91% (223K/245K)
        --  ⚠ 근거를 동적 SQL 문자열 안에 넣지 않는 이유: v_sql_text 는 VARCHAR2(32767 CHAR) — 여유 보존
        IF P_DIVISION_ID = '40' THEN
            v_sql_text := 'WITH T_DM51_WF AS (' || CHR(10) || 'SELECT';

            IF P_CELL_YN = 'Y' THEN
                v_sql_text := v_sql_text || ' SCM_MGR.FN_GET_DM_SALES_PLAN_WATERFALL_QTY2('
                    || CHR(10) || ' A.MEASURE, NVL(D.ITEM_CLASS_NAME,'''')'
                    || CHR(10) || ' , NVL(A.QTY,0)'
                    || CHR(10) || ' , NVL(C.CELL_PER_CAR,0)'
                    || CHR(10) || ' , NVL(C.CELL_PER_MODULE,0)'
                    || CHR(10) || ' , ''Y'''
                    || CHR(10) || ' , NVL(D.FORECAST_INFO_CELL_PACK_COUNT, 0)'
                    || CHR(10) || ' , ''' || P_DIVISION_ID || ''', NVL(D.FORECAST_INFO_BIZ_TYPE, '''')'
                    || CHR(10) || ' ) AS QTY ';
            ELSE
                v_sql_text := v_sql_text || ' A.QTY AS QTY ';
            END IF;

            v_sql_text := v_sql_text || CHR(10) || '
                , A.COLNAME
                , I.SORT_ORDER_NO
                , EDY.EDIT_YN
                , ' || V_SQL_SELECT || '
            FROM SCM_MGR.GT_DM51_RAW_DATA A
            LEFT JOIN SCM_MGR.SCM_MST_PROJECT           B ON (A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE)
            LEFT JOIN SCM_MGR.GT_DM51_SCM_MST_SITE_ITEM C ON (A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.ITEM_ID = C.ITEM_ID)
            LEFT JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V D ON (A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID)
            LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM         E ON (A.DIVISION_ID = E.DIVISION_ID AND A.PROJECT_CODE = E.PROJECT_CODE AND A.SCM_SITE_ID = E.SCM_SITE_ID AND A.ITEM_ID = E.ITEM_ID)
            LEFT JOIN SCM_MGR.GT_DM51_SCM_CITY          G ON (A.DIVISION_ID = G.DIVISION_ID AND A.SCM_SITE_ID = G.SCM_SITE_ID
                                                              AND CASE WHEN A.DIVISION_ID = ''40'' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END = G.END_CUSTOMER
                                                              /*[PJ2024-50461] Team Mapping*/
                                                              AND C.DEPT_ID = G.DEPT_ID )
            JOIN SCM_MGR.GT_DM22_SELECT_MEASURE         I ON (A.MEASURE = I.MEASURE)
            LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL J ON A.CELL_PROD_SITE = J.SEGMENT1 AND J.LOOKUP_TYPE = ''DM_CELL_PROD_SITE''
            INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                 ON EDY.USER_ID = ''' || P_USER_ID || '''
                AND EDY.MNU_ID  = ''' || P_MENU_ID || '''
                AND EDY.UNIT_ID = A.DIVISION_ID
            WHERE EXISTS (SELECT 1
                            FROM SCM_MGR.SCM_MST_SITE F
                           WHERE F.DIVISION_ID = A.DIVISION_ID
                             AND F.SCM_SITE_ID = A.SCM_SITE_ID)
            )
            ';
        ELSE
            v_sql_text := 'WITH T_DM51_WF AS (' || CHR(10) || 'SELECT';

            IF P_CELL_YN = 'Y' THEN
                v_sql_text := v_sql_text || ' SCM_MGR.FN_GET_DM_SALES_PLAN_WATERFALL_QTY2('
                    || CHR(10) || ' A.MEASURE, NVL(D.ITEM_CLASS_NAME,'''')'
                    || CHR(10) || ' , NVL(A.QTY,0)'
                    || CHR(10) || ' , NVL(C.CELL_PER_CAR,0)'
                    || CHR(10) || ' , NVL(C.CELL_PER_MODULE,0)'
                    || CHR(10) || ' , ''Y'''
                    || CHR(10) || ' , NVL(D.FORECAST_INFO_CELL_PACK_COUNT, 0)'
                    || CHR(10) || ' , ''' || P_DIVISION_ID || ''', NVL(D.FORECAST_INFO_BIZ_TYPE, '''')'
                    || CHR(10) || ' ) AS QTY ';
            ELSE
                v_sql_text := v_sql_text || ' A.QTY AS QTY ';
            END IF;

            v_sql_text := v_sql_text || CHR(10) || '
                , A.COLNAME
                , I.SORT_ORDER_NO
                , EDY.EDIT_YN
                , ' || V_SQL_SELECT || '
            FROM SCM_MGR.GT_DM51_RAW_DATA A
            LEFT JOIN SCM_MGR.SCM_MST_SITE              F ON (A.DIVISION_ID = F.DIVISION_ID AND A.SCM_SITE_ID = F.SCM_SITE_ID)
            LEFT JOIN SCM_MGR.SCM_MST_PROJECT           B ON (A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE)
            LEFT JOIN SCM_MGR.GT_DM51_SCM_MST_SITE_ITEM C ON (A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.ITEM_ID = C.ITEM_ID)
            LEFT JOIN SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V D ON (A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID)
            LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM         E ON (A.DIVISION_ID = E.DIVISION_ID AND A.PROJECT_CODE = E.PROJECT_CODE AND A.SCM_SITE_ID = E.SCM_SITE_ID AND A.ITEM_ID = E.ITEM_ID)
            LEFT JOIN SCM_MGR.GT_DM51_SCM_CITY          G ON (A.DIVISION_ID = G.DIVISION_ID AND A.SCM_SITE_ID = G.SCM_SITE_ID
                                                              AND CASE WHEN A.DIVISION_ID = ''40'' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END = G.END_CUSTOMER
                                                              /*[PJ2024-50461] Team Mapping*/
                                                              AND C.DEPT_ID = G.DEPT_ID )
            JOIN SCM_MGR.GT_DM22_SELECT_MEASURE         I ON (A.MEASURE = I.MEASURE)
            LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL J ON A.CELL_PROD_SITE = J.SEGMENT1 AND J.LOOKUP_TYPE = ''DM_CELL_PROD_SITE''  --[E20260806-WF] DEFAULT 분기(div 필터 없음)에서 CELL_PROD_SITE 선택 시 ORA-00904 방지
            INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                 ON EDY.USER_ID = ''' || P_USER_ID || '''
                AND EDY.MNU_ID  = ''' || P_MENU_ID || '''
                AND EDY.UNIT_ID = A.DIVISION_ID
            )
            ';
        END IF;

        -- 최종 PIVOT (AS-IS dump:1214-1235 — 최종 GROUP BY: LOC/USD/KRW=MAX·그 외 SUM → PIVOT SUM)
        v_sql_text := v_sql_text || CHR(10)
            || 'SELECT ' || v_ColList || CHR(10)
            || '     , SORT_ORDER_NO' || CHR(10)
            || '     , EDIT_YN' || CHR(10)
            || '     , ' || V_PV_LIST || CHR(10)
            || 'FROM (' || CHR(10)
            || '    SELECT ' || v_ColList || CHR(10)
            || '         , SORT_ORDER_NO' || CHR(10)
            || '         , COLNAME' || CHR(10)
            || '         , EDIT_YN' || CHR(10)
            || '         , CASE WHEN MEASURE IN (''LOC'',''USD'',''KRW'') THEN MAX(QTY)' || CHR(10)
            || '                ELSE SUM(QTY)' || CHR(10)
            || '           END AS QTY' || CHR(10)
            || '    FROM T_DM51_WF' || CHR(10)
            || '    GROUP BY ' || v_ColList || ', SORT_ORDER_NO, COLNAME, EDIT_YN' || CHR(10)
            || '    ) F' || CHR(10)
            || 'PIVOT (' || CHR(10)
            || '    SUM(F.QTY) FOR COLNAME IN ( ' || V_PV_COL_LIST || ' )' || CHR(10)
            || '    )' || CHR(10)
            || 'ORDER BY ' || v_OrderList
            ;

        DBMS_OUTPUT.PUT_LINE(v_program_id || ' : K--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        OPEN O_RC1 FOR v_sql_text;

        -- 두 번째 결과셋 (AS-IS dump:1243-1245 — 금일 ISO_WEEK, BASIS_DATE)
        OPEN O_RC2 FOR
            SELECT ISO_WEEK, BASIS_DATE
              FROM SCM_MGR.SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD = TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD');

        -- 세 번째 결과셋 (AS-IS dump:1247-1249 실행 SQL FOR XML 디버그) → 0022 선례: 결과코드 커서 + DBMS_OUTPUT 덤프로 대체
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;

        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.PUT_LINE('=============================');
        DBMS_OUTPUT.PUT_LINE('V_PV_COL_LIST : ' || V_PV_COL_LIST || CHR(10) || CHR(10));
        DBMS_OUTPUT.PUT_LINE('V_PV_LIST : '     || V_PV_LIST     || CHR(10) || CHR(10));
        DBMS_OUTPUT.PUT_LINE('v_ColList : '     || v_ColList     || CHR(10) || CHR(10));
        DBMS_OUTPUT.PUT_LINE('v_OrderList : '   || v_OrderList   || CHR(10) || CHR(10));
        DBMS_OUTPUT.PUT_LINE('V_SQL_SELECT : '  || V_SQL_SELECT  || CHR(10) || CHR(10));
        DBMS_OUTPUT.PUT_LINE('=============================');
        DBMS_OUTPUT.PUT_LINE(v_sql_text);

        -- AS-IS 말미의 Temp Table DROP 블록(dump:1252-1293)은 GTT 이므로 불필요 — 시작부 DELETE 초기화로 대체 (부록 C-5)

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;

            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_PROC_INPUT := JSON_OBJECT(
                'P_DIVISION_ID'   VALUE P_DIVISION_ID,
                'P_DEPT_ID'       VALUE P_DEPT_ID,
                'P_END_CUSTOMER'  VALUE P_END_CUSTOMER,
                'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
                'P_PROJECT_CODE'  VALUE P_PROJECT_CODE,
                'P_ITEM_ID'       VALUE P_ITEM_ID,
                'P_ITEM_TYPE'     VALUE P_ITEM_TYPE,
                'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
                'P_NOW_YYYYMMDD'  VALUE P_NOW_YYYYMMDD,
                'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
                'P_CREATED_BY'    VALUE P_CREATED_BY,
                'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
                'P_BIZTYPE'       VALUE P_BIZTYPE,
                'P_OWNER'         VALUE P_OWNER,
                'P_VERSION_TYPE'  VALUE P_VERSION_TYPE,
                'P_CELL_YN'       VALUE P_CELL_YN,
                'P_QTY_YN'        VALUE P_QTY_YN,
                'P_USER_ID'       VALUE P_USER_ID,
                'P_MENU_ID'       VALUE P_MENU_ID
            );
            V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                    V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                    '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
                );
            END;

            RAISE_APPLICATION_ERROR(-20001,
                '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
                ' / SQLERRM=' || V_SQL_ERRMSG ||
                ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                ' / PARAMS=' || DBMS_LOB.SUBSTR(V_PROC_INPUT, 1000, 1)   -- RAISE_APPLICATION_ERROR 2048자 상한 방어
            );
            RAISE;

    END P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL;

END PKG_DMF0051;/
