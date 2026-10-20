-- PKG_SCP0096 — 생성: tools/Harness/gen-pkg.js 2026-10-19 · 화면 SCP0096→SCP0096 Shipment_Working_Day_OSP · As-is SP 3개
-- 이식 규칙: Doc/_dev_rules(DB 변환 규칙) · To-be_v2_converted/06_Packages 선례 · ISNULL→NVL, GETDATE→SYSDATE, TOP n→FETCH FIRST n ROWS ONLY, +(문자열)→||, CONVERT→TO_CHAR/TO_DATE, 임시테이블→GTT/WITH, @@ROWCOUNT→SQL%ROWCOUNT
-- 배포 후: SCP0096_registration.sql 재실행(PROC_M 이 ALL_ARGUMENTS 로 확정) → FE pnpm gen:procedures
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCP0096
AS
    PROCEDURE P_DM0003_GET_BUCKET_TYPE_CODE (
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(60)
        P_PLANT_SITE_ID  IN  VARCHAR2,  -- As-is @p_plant_site_id nvarchar(200)
        P_FROM_YYYYMMDD  IN  VARCHAR2,  -- As-is @p_from_yyyymmdd nvarchar(16)
        P_TO_YYYYMMDD    IN  VARCHAR2,  -- As-is @p_to_yyyymmdd nvarchar(16)
        P_DEBUG_MODE     IN  VARCHAR2,  -- As-is @debug_mode nvarchar(40)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0009_GET_SHEET_CALENDAR_3SPAN (
        P_START_YYYYMMDD IN  VARCHAR2,  -- As-is @p_start_yyyymmdd nvarchar(16)
        P_END_YYYYMMDD   IN  VARCHAR2,  -- As-is @p_end_yyyymmdd nvarchar(16)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );
END PKG_SCP0096;
/

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCP0096
AS
/*
 * Program ID   : P_DM0003_GET_BUCKET_TYPE_CODE
 * Description  : SCP0096 Shipment_Working_Day_OSP — As-is DM0003_GET_BUCKET_TYPE_CODE 이식 (GET, 시트 'Shipment Working Day OSP' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017.10.24   SongDH         Initial Release [PJ20170278] — As-is dbo.DM0003_GET_BUCKET_TYPE_CODE
 * 2026.10.19   harness        Oracle 이식 (MSSQL→Oracle)
 */
PROCEDURE P_DM0003_GET_BUCKET_TYPE_CODE (
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    OPEN O_RC1 FOR
        SELECT L.SEGMENT1 AS CODE
             , L.SEGMENT2 AS NAME
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
        WHERE L.LOOKUP_TYPE = 'BUCKET_TYPE_CODE'
          AND L.VALID_YN    = 'Y'
        ORDER BY L.DISPLAY_SEQ;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_DM0003_GET_BUCKET_TYPE_CODE] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || '-');
END P_DM0003_GET_BUCKET_TYPE_CODE;

/*
 * Program ID   : P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP
 * Description  : SCP0096 Shipment_Working_Day_OSP — As-is SCP0096_GET_SHIPMENT_WORKING_DAY_OSP 이식 (GET, 시트 'Shipment Working Day OSP' / 버튼 SEARCH)
 *                동적 PIVOT: SCM_SYS_CALENDAR_M.BASIS_YYYYMMDD 각 일자별 컬럼(D_YYYYMMDD) + SHIPMENT_YN
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2023.01.31   lwy            Initial Release [PJ20216994] — As-is dbo.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP
 * 2026.10.19   harness        Oracle 이식 (MSSQL→Oracle, #TBLDYNAMICPIVOT_SCP0096 → inline subquery)
 */
PROCEDURE P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(60)
        P_PLANT_SITE_ID  IN  VARCHAR2,  -- As-is @p_plant_site_id nvarchar(200)
        P_FROM_YYYYMMDD  IN  VARCHAR2,  -- As-is @p_from_yyyymmdd nvarchar(16)
        P_TO_YYYYMMDD    IN  VARCHAR2,  -- As-is @p_to_yyyymmdd nvarchar(16)
        P_DEBUG_MODE     IN  VARCHAR2,  -- As-is @debug_mode nvarchar(40)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL           CLOB;
    V_PIVOT_COLS    CLOB := '';
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사(As-is 에서 NOT NULL 로 쓰이는 파라미터만 남길 것)
    IF P_DIVISION_ID IS NULL THEN RAISE_INVALID('DIVISION_ID IS NULL'); END IF;

    -- ─────────────────────────────────────────────────────────────────
    -- 1) PIVOT 컬럼 조립 (SCM_SYS_CALENDAR_M.BASIS_YYYYMMDD BETWEEN FROM~TO)
    --    As-is: SELECT TOP 10000 'D_'+BASIS_YYYYMMDD, BASIS_YYYYMMDD+CONVERT(CHAR(2),31) AS SORT_ORDER_NO
    -- ─────────────────────────────────────────────────────────────────
    FOR REC IN (
        SELECT 'D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
             , A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
        FROM SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
        GROUP BY A.BASIS_YYYYMMDD
        ORDER BY SORT_ORDER_NO
        FETCH FIRST 10000 ROWS ONLY
    ) LOOP
        V_PIVOT_COLS := V_PIVOT_COLS
            || ',MAX(CASE WHEN YYYYMMDD = ''' || REC.YYYYMMDD || ''' THEN SHIPMENT_YN END) AS ' || REC.YYYYMMDD
            || CHR(10);
    END LOOP;

    -- ─────────────────────────────────────────────────────────────────
    -- 2) 동적 SELECT 조립 (As-is: #TBLDYNAMICPIVOT_SCP0096 → 인라인 서브쿼리)
    -- ─────────────────────────────────────────────────────────────────
    V_SQL := '
SELECT A.* FROM (
    SELECT  DIVISION_ID
          , PLANT_SITE_ID
          , (SELECT MAX(D.SITE_DESCRIPTION) FROM SCM_MGR.SCM_MST_SITE D WHERE D.SCM_SITE_ID = PLANT_SITE_ID GROUP BY D.SCM_SITE_ID) AS PLANT_SITE_NAME
          , WORKING_TIME_DEFAULT
          , LAST_INPUT_DATE
          , MEASURE
' || V_PIVOT_COLS || '
    FROM (
        SELECT  A.DIVISION_ID
              , A.PLANT_SITE_ID
              , C.WORKING_TIME_DEFAULT AS WORKING_TIME_DEFAULT
              , ( SELECT MAX(YYYYMMDD)
                    FROM SCM_MGR.SCP_MST_SHIPMENT_WORKING_DAY_OSP T
                   WHERE T.DIVISION_ID   = A.DIVISION_ID
                     AND T.PLANT_SITE_ID = A.PLANT_SITE_ID
                     AND T.SHIPMENT_YN IS NOT NULL ) AS LAST_INPUT_DATE
              , A.MEASURE
              , ''D_'' || A.YYYYMMDD AS YYYYMMDD
              , A.YYYYMM AS YYYYMM
              , A.ISO_WEEK
              , B.SHIPMENT_YN AS SHIPMENT_YN
        FROM (
            SELECT DISTINCT
                   S.DIVISION_ID
                 , S.SCM_SITE_ID AS PLANT_SITE_ID
                 , ''SHIPMENT WORKING DAY'' AS MEASURE
                 , P.BASIS_YYYYMMDD AS YYYYMMDD
                 , P.BASIS_YYYYMM   AS YYYYMM
                 , SUBSTR(P.BASIS_YYYYMM, -2) || P.ISO_WEEK AS ISO_WEEK
                 , ''VENDOR'' AS OPERATION
                 , S.OSP_YN
            FROM SCM_MGR.SCM_MST_SITE S
            CROSS JOIN SCM_MGR.SCM_SYS_CALENDAR_M P
            WHERE P.BASIS_YYYYMMDD >= ''' || P_FROM_YYYYMMDD || '''
              AND P.BASIS_YYYYMMDD <= ''' || P_TO_YYYYMMDD   || '''
              AND S.SITE_TYPE   = ''PLANT''
              AND S.VALID_YN    = ''Y''
              AND S.OSP_YN      = ''Y''
              AND S.DIVISION_ID = ''' || P_DIVISION_ID || '''
              AND NVL(S.ATTRIBUTE1, ''N'') <> ''Y''   -- LINE 등록 외주사 제외
              AND ( ''' || NVL(P_PLANT_SITE_ID, '') || ''' IS NULL
                    OR ''' || NVL(P_PLANT_SITE_ID, '') || ''' = ''''
                    OR S.SCM_SITE_ID IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(''' || NVL(P_PLANT_SITE_ID, '') || ''', '','') )) )

            UNION

            SELECT S.DIVISION_ID
                 , S.SCM_SITE_ID AS PLANT_SITE_ID
                 , ''SHIPMENT WORKING DAY'' AS MEASURE
                 , P.BASIS_YYYYMMDD AS YYYYMMDD
                 , P.BASIS_YYYYMM   AS YYYYMM
                 , SUBSTR(P.BASIS_YYYYMM, -2) || P.ISO_WEEK AS ISO_WEEK
                 , O.OPERATION_ID AS OPERATION
                 , S.OSP_YN
            FROM SCM_MGR.SCM_MST_SITE S
            JOIN SCM_MGR.SCM_MST_LINE_OSP O
              ON S.DIVISION_ID = O.DIVISION_ID
             AND S.SCM_SITE_ID = O.SCM_SITE_ID
            CROSS JOIN SCM_MGR.SCM_SYS_CALENDAR_M P
            WHERE P.BASIS_YYYYMMDD >= ''' || P_FROM_YYYYMMDD || '''
              AND P.BASIS_YYYYMMDD <= ''' || P_TO_YYYYMMDD   || '''
              AND S.SITE_TYPE   = ''PLANT''
              AND S.VALID_YN    = ''Y''
              AND S.OSP_YN      = ''Y''
              AND S.DIVISION_ID = ''' || P_DIVISION_ID || '''
              AND NVL(S.ATTRIBUTE1, ''N'') = ''Y''
              AND ( ''' || NVL(P_PLANT_SITE_ID, '') || ''' IS NULL
                    OR ''' || NVL(P_PLANT_SITE_ID, '') || ''' = ''''
                    OR S.SCM_SITE_ID IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(''' || NVL(P_PLANT_SITE_ID, '') || ''', '','') )) )
        ) A
        LEFT OUTER JOIN SCM_MGR.SCP_MST_SHIPMENT_WORKING_DAY_OSP B
          ON A.DIVISION_ID   = B.DIVISION_ID
         AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
         AND A.YYYYMMDD      = B.YYYYMMDD
        LEFT OUTER JOIN SCM_MGR.SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT C
          ON A.DIVISION_ID   = C.DIVISION_ID
         AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
        LEFT OUTER JOIN SCM_MGR.SCM_SYS_CALENDAR_M O
          ON B.YYYYMMDD = O.BASIS_YYYYMMDD
    ) BASE
    GROUP BY DIVISION_ID, PLANT_SITE_ID, WORKING_TIME_DEFAULT, LAST_INPUT_DATE, MEASURE
) A
ORDER BY LAST_INPUT_DATE, DIVISION_ID, PLANT_SITE_ID, MEASURE
';

    IF P_DEBUG_MODE = 'T' THEN
        DBMS_OUTPUT.PUT_LINE(V_SQL);
    END IF;

    OPEN O_RC1 FOR V_SQL;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_DIVISION_ID='||P_DIVISION_ID||','||'P_PLANT_SITE_ID='||P_PLANT_SITE_ID||','||'P_FROM_YYYYMMDD='||P_FROM_YYYYMMDD||','||'P_TO_YYYYMMDD='||P_TO_YYYYMMDD);
END P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP;

/*
 * Program ID   : P_SCP0009_GET_SHEET_CALENDAR_3SPAN
 * Description  : SCP0096 Shipment_Working_Day_OSP — As-is SCP0009_GET_SHEET_CALENDAR_3SPAN 이식 (GET, 시트 'Shipment Working Day OSP' / 버튼 SEARCH)
 *                SCP 그리드 캘린더 (일/주/월 3-span) 컬럼 메타 생성
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2018.11.20   KYH            Initial Release — As-is dbo.SCP0009_GET_SHEET_CALENDAR_3SPAN
 * 2026.10.19   harness        Oracle 이식 (MSSQL→Oracle)
 */
PROCEDURE P_SCP0009_GET_SHEET_CALENDAR_3SPAN (
        P_START_YYYYMMDD IN  VARCHAR2,  -- As-is @p_start_yyyymmdd nvarchar(16)
        P_END_YYYYMMDD   IN  VARCHAR2,  -- As-is @p_end_yyyymmdd nvarchar(16)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사(As-is 에서 NOT NULL 로 쓰이는 파라미터만 남길 것)
    IF P_START_YYYYMMDD IS NULL THEN RAISE_INVALID('START_YYYYMMDD IS NULL'); END IF;

    OPEN O_RC1 FOR
        SELECT 'D_' || A.BASIS_YYYYMMDD      AS COLUMN_NAME
             , A.CALENDAR_DAY                AS COLUMN_LABEL_NAME
             , A.WEEK_NAME                   AS SMALL_CLASS_LABEL_NAME
             , A.MONTH_NAME                  AS LARGE_CLASS_LABEL_NAME
             , A.DAYOFWEEK                   AS DAY_CODE
             , A.BASIS_YYYYMMDD || '31'      AS SORT_ORDER_NO
        FROM SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COLUMN_NAME
             , A.WEEK_NAME                   AS COLUMN_LABEL_NAME
             , A.WEEK_NAME                   AS SMALL_CLASS_LABEL_NAME
             , A.MONTH_NAME                  AS LARGE_CLASS_LABEL_NAME
             , ''                            AS DAY_CODE
             , A.BASIS_START_DATE || '21'    AS SORT_ORDER_NO
        FROM SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
        GROUP BY A.BASIS_YYYYMM
               , A.ISO_WEEK
               , A.WEEK_NAME
               , A.MONTH_NAME
               , A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM        AS COLUMN_NAME
             , A.MONTH_NAME                  AS COLUMN_LABEL_NAME
             , A.MONTH_NAME                  AS SMALL_CLASS_LABEL_NAME
             , A.MONTH_NAME                  AS LARGE_CLASS_LABEL_NAME
             , ''                            AS DAY_CODE
             , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
        FROM SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
          AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
        GROUP BY A.BASIS_YYYYMM
               , A.MONTH_NAME
        ORDER BY SORT_ORDER_NO;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0009_GET_SHEET_CALENDAR_3SPAN] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_START_YYYYMMDD='||P_START_YYYYMMDD||','||'P_END_YYYYMMDD='||P_END_YYYYMMDD);
END P_SCP0009_GET_SHEET_CALENDAR_3SPAN;

END PKG_SCP0096;
/
-- 컴파일 확인: SELECT NAME, TYPE, LINE, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0096' ORDER BY TYPE, SEQUENCE;
