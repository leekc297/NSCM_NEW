/*=============================================================================================
 * File         : 04_Package_PKG_DMF0014.sql
 * Description  : Package — PKG_DMF0014
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - $$PLSQL_UNIT 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0014 IS
    /*
    * Program ID   : PKG_DMF0014
    * Description  : PKG_DMF0014
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0014_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD
    (
        P_MODE          INTEGER
       ,P_CREATED_BY    VARCHAR2
       ,P_PROGRAM_ID    IN VARCHAR2
       ,P_SHEET_NAME    IN VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
    (
        P_MODE          INTEGER
       ,P_CREATED_BY    VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0014_GET_CUST_FCST_UPLOAD_DATA
    (
        P_DIVISION_ID    VARCHAR2
       ,P_DEPT_ID        VARCHAR2
       ,P_END_CUSTOMER   VARCHAR2
       ,P_SCM_SITE_ID    VARCHAR2
       ,P_PLANT_SITE_ID  VARCHAR2
       ,P_PROJECT_CODE   VARCHAR2
       ,P_ITEM_ID        VARCHAR2
       ,P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_DOM_EXP        VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       , --, p_debug OUT VARCHAR2
        P_USERINFO       VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA
    (
        P_ACTIVE_FLAG           VARCHAR2
       ,P_DIVISION_ID           VARCHAR2
       ,P_SCM_SITE_ID           VARCHAR2
       ,P_CUSTOMER_PROJECT_CODE VARCHAR2
       ,P_CUSTOMER_MODEL        VARCHAR2
       ,P_INCOTERMS             VARCHAR2
       ,P_FCST_TYPE             VARCHAR2
       ,P_DOM_EXP               VARCHAR2
       ,P_MEASURE_GROUP         VARCHAR2
       ,P_MEASURE               VARCHAR2
       ,P_PLANT_SITE_ID         VARCHAR2
       ,P_UPLOAD_UOM            VARCHAR2
       ,P_PROJECT_CODE          VARCHAR2
       ,P_ITEM_ID               VARCHAR2
       ,P_YYYYMMDD              VARCHAR2
       ,P_QTY                   VARCHAR2
       ,P_CREATED_BY            VARCHAR2
       ,O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

END PKG_DMF0014;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0014 IS

    PROCEDURE P_DMF0014_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0014_GET_SPREAD_TITLE
        * Description  :
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2017/12/22  SongDH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        * 2022/10/26  KDW2819        [C20221024-000507]CUST FCST Upload 오류 수정
        * 2026/03/15  김준규        [PJ20264226] NextSCM Pilot 설계 및 개발
        *
        */
     AS
    
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
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    BEGIN
    
        V_IN_PARA_DATA := JSON_OBJECT('p_start_yyyymmdd' VALUE P_START_YYYYMMDD, 'p_end_yyyymmdd' VALUE P_END_YYYYMMDD, 'p_bucket_type' VALUE P_BUCKET_TYPE);
    
        IF P_BUCKET_TYPE = 'DAILY' THEN
            OPEN O_RC1 FOR
                SELECT 'D_' || BASIS_YYYYMMDD AS COLUMN_NAME, BASIS_YYYYMMDD COLUMN_LABEL, A.DAYOFWEEK SMALL_LABEL_NAME, 'Y' AS EDIT_YN
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD; --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
        ELSIF P_BUCKET_TYPE = 'WEEKLY' THEN
            OPEN O_RC1 FOR
                SELECT 'D_' || MIN(A.BASIS_START_DATE) COLUMN_NAME, MIN(A.BASIS_START_DATE) COLUMN_LABEL, A.WEEK_NAME SMALL_LABEL_NAME, 'Y' AS EDIT_YN
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                GROUP  BY A.ISO_YYYYWW, A.WEEK_NAME
                ORDER  BY COLUMN_LABEL;
        ELSIF P_BUCKET_TYPE = 'MONTHLY' THEN
            OPEN O_RC1 FOR
                SELECT 'D_' || MIN(A.BASIS_YYYYMM) || '01' AS COLUMN_NAME
                      ,MIN(A.BASIS_YYYYMM) || '01' AS COLUMN_LABEL
                      ,A.MONTH_NAME SMALL_LABEL_NAME
                      ,'Y' AS EDIT_YN
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                GROUP  BY A.MONTH_NAME;
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
    END P_DMF0014_GET_SPREAD_TITLE;

    PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD
    (
        P_MODE          INTEGER
       ,P_CREATED_BY    VARCHAR2
       ,P_PROGRAM_ID    IN VARCHAR2
       ,P_SHEET_NAME    IN VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0014_CUST_FCST_EXCEL_UPLOAD
        * Description  : DMF0014_CUST_FCST_EXCEL_UPLOAD
        * Program History
        *===========================================================================================================
        *   Date       In Charge      Description
        *===========================================================================================================
        * 2018. 01. 02   SongDH     Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        * 2022. 10. 26   KDW2819    [C20221024-000507]CUST FCST Upload 오류 수정
        * 2023. 01. 25   kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
        * 2023. 02. 28   chano0612 [E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생 -- EXCEL UPLOAD
        * 2024. 02. 15   kcw3408   [E20240208-001344]고객 수요 분석 시스템_Cust.FCST upload 문의의 건(데이타 없는데 Ctrl + End 키로는 인식되어 Length가 0인 컬럼을 Check 추가)
         * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
        --DMF0014_CUST_FCST_EXCEL_UPLOAD('1', 'hwayoung.lim');
     AS
    
        V_IN_PARA_DATA   VARCHAR2(4000);
        V_PROGRAM_ID     VARCHAR2(40 CHAR) := P_PROGRAM_ID; --'DMF0014';
        V_SHEET_NAME     VARCHAR2(40 CHAR) := P_SHEET_NAME; --'FCST Upload';
        V_SQL_TEXT       VARCHAR2(4000 CHAR);
        V_CREATION_DATE  VARCHAR2(40 CHAR);
        V_COUNT          INTEGER;
        V_START_YYYYMMDD VARCHAR2(8 CHAR);
        V_END_YYYYMMDD   VARCHAR2(8 CHAR);
        V_DIVISION       VARCHAR2(10 CHAR);
        $$PLSQL_UNIT   VARCHAR2(200) := $$PLSQL_UNIT;
        V_LOG_TYPE       VARCHAR2(30 CHAR);
        N_LOG_COUNT      INTEGER := 0;
        V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
        V_DESCRIPTION    VARCHAR2(500 CHAR);
        D_EVENT_DATE     DATE;
        V_PROC_INPUT     CLOB := NULL;
        V_SQL_CODE       VARCHAR2(100) := NULL;
        V_SQL_ERRMSG     VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE      VARCHAR2(4000 CHAR) := NULL;
        V_STEP           VARCHAR2(4000 CHAR) := NULL;
        v_err_cnt        NUMBER;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        V_IN_PARA_DATA := JSON_OBJECT('p_mode' VALUE P_MODE
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_program_id' VALUE P_PROGRAM_ID
                                     ,'p_sheet_name' VALUE P_SHEET_NAME);
    
        -- LOG 용 변수 설정
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    
        SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
        INTO   V_CREATION_DATE
        FROM   SCM_ADM_EXCEL_UPLOAD T
        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
        AND    T.SHEET_NAME = V_SHEET_NAME
        AND    T.CREATED_BY = P_CREATED_BY;
        --  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
        IF V_CREATION_DATE IS NULL THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'Data Not Found [' || TO_CHAR(V_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') || ']';
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END IF;
    
        --DBMS_OUTPUT.put_line('V_CREATION_DATE:'||V_CREATION_DATE||',');
        --DMF0014_CUST_FCST_EXCEL_UPLOAD('1', 'hwayoung.lim');
        IF P_MODE = 0 THEN
        BEGIN
            SELECT ATTRIBUTE1
            INTO   V_DIVISION
            FROM   SCM_ADM_EXCEL_UPLOAD
            WHERE  PROGRAM_ID = V_PROGRAM_ID
            AND    SHEET_NAME = V_SHEET_NAME
            AND    CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    UPPER(ATTRIBUTE1) <> 'DIVISION*'
                  --AND    UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            FETCH  FIRST 1 ROWS ONLY;
        END;
        ELSE
        BEGIN
            SELECT ATTRIBUTE1
            INTO   V_DIVISION
            FROM   SCM_ADM_EXCEL_UPLOAD
            WHERE  PROGRAM_ID = V_PROGRAM_ID
            AND    SHEET_NAME = V_SHEET_NAME
            AND    CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    UPPER(ATTRIBUTE1) <> 'DIVISION*'
                  --AND    UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    UPLOAD_STATUS_CODE IN ( 'SUCCESS')
            FETCH  FIRST 1 ROWS ONLY;
        END;
        END IF;
    
        -- p_mode = 0 이면 Validation
        IF NVL(P_MODE, 0) = 0 THEN
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD T
                SET    UPLOAD_STATUS_CODE = 'UPLOAD', MESSAGE_TEXT = NULL
                WHERE  T.PROGRAM_ID = V_PROGRAM_ID
                AND    T.SHEET_NAME = V_SHEET_NAME
                AND    T.CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    NVL(T.UPLOAD_STATUS_CODE, 'X') != 'UPLOAD';
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
                V_LOG_TYPE    := '10';
                V_LOG_MESSAGE := '########## RESET Status = UPLOAD ##########';
                V_DESCRIPTION := P_MODE;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'SKIP'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    (ATTRIBUTE1 IS NULL OR LENGTH(ATTRIBUTE1) = 0 OR UPPER(ATTRIBUTE1) = 'TOTAL');
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
                V_LOG_TYPE    := '20';
                V_LOG_MESSAGE := '########## SKIP EMPTY LINE ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'V_TITLE'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPPER(ATTRIBUTE1) = 'DIVISION*';
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('V_TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
                V_LOG_TYPE    := '30';
                V_LOG_MESSAGE := '########## TITLE Header Line ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Duplication Key.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    EXISTS (SELECT 1
                        FROM   (SELECT X.ATTRIBUTE1  AS COL1
                                      ,X.ATTRIBUTE2  COL2
                                      ,X.ATTRIBUTE3  COL3
                                      ,X.ATTRIBUTE4  COL4
                                      ,X.ATTRIBUTE5  COL5
                                      ,X.ATTRIBUTE6  COL6
                                      ,X.ATTRIBUTE7  COL7
                                      ,X.ATTRIBUTE8  COL8
                                      ,X.ATTRIBUTE9  COL9
                                      ,X.ATTRIBUTE10 COL10
                                --, X.ATTRIBUTE11 COL11
                                --, X.ATTRIBUTE12 COL12
                                FROM   SCM_ADM_EXCEL_UPLOAD X
                                WHERE  X.PROGRAM_ID = V_PROGRAM_ID
                                AND    X.SHEET_NAME = V_SHEET_NAME
                                AND    X.CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                                GROUP  BY X.ATTRIBUTE1
                                         ,X.ATTRIBUTE2
                                         ,X.ATTRIBUTE3
                                         ,X.ATTRIBUTE4
                                         ,X.ATTRIBUTE5
                                         ,X.ATTRIBUTE6
                                         ,X.ATTRIBUTE7
                                         ,X.ATTRIBUTE8
                                         ,X.ATTRIBUTE9
                                         ,X.ATTRIBUTE10
                                --, X.ATTRIBUTE11
                                --, X.ATTRIBUTE12
                                HAVING COUNT(*) > 1) T
                        WHERE  1 = 1
                        AND    T.COL1 = ATTRIBUTE1
                        AND    T.COL2 = ATTRIBUTE2
                        AND    T.COL3 = ATTRIBUTE3
                        AND    T.COL4 = ATTRIBUTE4
                        AND    T.COL5 = ATTRIBUTE5
                        AND    T.COL6 = ATTRIBUTE6
                        AND    T.COL7 = ATTRIBUTE7
                        AND    T.COL8 = ATTRIBUTE8
                        AND    T.COL9 = ATTRIBUTE9
                        AND    T.COL10 = ATTRIBUTE10
                        --AND T.COL11 = ATTRIBUTE11
                        --AND T.COL12 = ATTRIBUTE12
                        );
                        
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '40';
                    V_LOG_MESSAGE := '########## ERROR Key Duplication ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
        
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
                V_LOG_TYPE    := '40';
                V_LOG_MESSAGE := '########## ERROR Key Duplication ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Division.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                        UNION
                        SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1);

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '50';
                    V_LOG_MESSAGE := '########## ERROR Key Duplication ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        

            END;
        
            BEGIN
                -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    ATTRIBUTE1 =
                       (SELECT D.DIVISION_ID
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1);
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD AEU
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Measure Upload Bucket.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D, SCM_MST_DIVISION D2
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
                        AND    (D2.DIVISION_ID = AEU.ATTRIBUTE1 OR D2.DIVISION_NAME = AEU.ATTRIBUTE1)
                        AND    D.SCM_SITE_ID = AEU.ATTRIBUTE2
                        AND    D.MEASURE = AEU.ATTRIBUTE10
                        AND    D.UPLOAD_BUCKET_TYPE IN (SELECT CASE (TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14, 'YYYYMMDD'))
                                                                   WHEN 1 THEN
                                                                    'DAILY'
                                                                   WHEN 7 THEN
                                                                    'WEEKLY'
                                                                   ELSE
                                                                    'MONTHLY'
                                                               END
                                                        FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                        WHERE  Z.PROGRAM_ID = V_PROGRAM_ID
                                                        AND    Z.SHEET_NAME = V_SHEET_NAME
                                                        AND    Z.CREATED_BY = P_CREATED_BY
                                                        AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                                        AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE'));

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '60';
                    V_LOG_MESSAGE := '########## ERROR Invalid Measure Upload Bucket. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Measure Upload UOM.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D, SCM_MST_DIVISION D2
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    D.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    D.UPLOAD_UOM = UPPER(SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11));

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '70';
                    V_LOG_MESSAGE := '########## ERROR Invalid Measure Upload UOM. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        

            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
                V_LOG_TYPE    := '70';
                V_LOG_MESSAGE := '########## Invalid Measure Upload UOM. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Scm Site.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S, SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
                        AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    S.VALID_YN = 'Y');

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '80';
                    V_LOG_MESSAGE := '########## ERROR Invalid Scm Site. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        

            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
                V_LOG_TYPE    := '80';
                V_LOG_MESSAGE := '########## Invalid Scm Site. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Plant Site.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    (ATTRIBUTE1 = '81' OR ATTRIBUTE1 = 'Automotive Battery') -- ess는 제외
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S, SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
                        AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    S.VALID_YN = 'Y');

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '90';
                    V_LOG_MESSAGE := '########## ERROR Invalid Plant Site. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
                V_LOG_TYPE    := '90';
                V_LOG_MESSAGE := '########## Invalid Plant Site. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Customer Project.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.VALID_YN              = 'Y');
            END;
            
            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Customer Project ', SQL%ROWCOUNT, 6, TRUE);
            v_log_type := '7';
            v_log_message := '########## Invalid Customer Project ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            IF V_DIVISION != '40' THEN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Customer Model.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM, SCM_MST_DIVISION D2
                        WHERE  CM.DIVISION_ID = D2.DIVISION_ID
                        AND    CM.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                        AND    CM.CUSTOMER_MODEL = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    CM.VALID_YN = 'Y'
                        UNION
                        SELECT 1
                        FROM   SCM_MST_SITE_ITEM SI, SCM_MST_DIVISION D3
                        WHERE  SI.DIVISION_ID = D3.DIVISION_ID
                        AND    SI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    SI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                        AND    SI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                        AND    (D3.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D3.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    SI.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '100';
                    V_LOG_MESSAGE := '########## ERROR Invalid Customer Model. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
            END IF;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
                V_LOG_TYPE    := '100';
                V_LOG_MESSAGE := '########## Invalid Customer Model ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Incoterms.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
                        AND    L.LOOKUP_TYPE = 'INCOTERMS'
                        AND    L.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '110';
                    V_LOG_MESSAGE := '########## ERROR Invalid Incoterms. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '110';
                V_LOG_MESSAGE := '########## Invalid Incoterms. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Sales Type.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
                        AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    L.VALID_YN = 'Y'
                        UNION
                        SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DESCRIPTION = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7);
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '120';
                    V_LOG_MESSAGE := '########## ERROR Invalid Sales Type. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
            END;
        
            BEGIN
                -- validation이 끝났으니 code로 update
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    ATTRIBUTE7 =
                       (SELECT D.SEGMENT1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    D.SEGMENT2 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7)
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
                        AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    L.VALID_YN = 'Y');
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '120';
                V_LOG_MESSAGE := '########## Invalid Sales Type. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Customs Handbook'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8
                            AND    L.LOOKUP_TYPE = 'DOM/EXP'
                            AND    L.VALID_YN    = 'Y');
            END;
            
            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
            v_log_type := '12';
            v_log_message := '########## Invalid DOM/EXP. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Measure Group.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE9
                        AND    L.LOOKUP_TYPE = 'MEASURE_GROUP_CODE'
                        AND    L.SEGMENT1 = 'CUST_FCST'
                        AND    L.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '130';
                    V_LOG_MESSAGE := '########## ERROR Invalid Measure Group. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
            END;
        
            --20230125 kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '130';
                V_LOG_MESSAGE := '########## Invalid Invalid Measure Group. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            --문자열 체크
        
            UPDATE SCM_ADM_EXCEL_UPLOAD A
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                  ,MESSAGE_TEXT = 'This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. (e.g. a, b, c, 130.2, 50.4 ...).'
            WHERE  A.PROGRAM_ID = V_PROGRAM_ID
            AND    A.SHEET_NAME = V_SHEET_NAME
            AND    A.CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
            AND    EXISTS (
                     SELECT 1
                     FROM  (SELECT UPLOAD_ID
                                  ,SUM(CASE WHEN REGEXP_LIKE(VALUE, '^-?[0-9]*\.?[0-9]+$') THEN 0 ELSE 1 END) PRICE
                            FROM  (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                         , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                         , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                         , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                         , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                         , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                         , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                         , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                         , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                         , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                         , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                         , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                         , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                         , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                         , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                                   FROM   SCM_ADM_EXCEL_UPLOAD
                                   WHERE  PROGRAM_ID = V_PROGRAM_ID
                                   AND    SHEET_NAME = V_SHEET_NAME
                                   AND    CREATED_BY = P_CREATED_BY
                                   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                   AND    UPLOAD_STATUS_CODE = 'UPLOAD')
                            UNPIVOT (VALUE FOR COLUMN_NAME IN (ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                         , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                         , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                         , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                         , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                         , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                         , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                         , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                         , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                         , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                         , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                         , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                         , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                         , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                         , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200))
                            WHERE  LTRIM(RTRIM(VALUE)) IS NOT NULL
                            AND    VALUE != '0'
                            AND    VALUE IS NOT NULL
                            GROUP BY UPLOAD_ID) B
                     WHERE  B.UPLOAD_ID = A.UPLOAD_ID
                     AND    B.PRICE > 0
                   );
        
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '140';
                    V_LOG_MESSAGE := '########## ERROR This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        

            --소수점 체크
            BEGIN

            UPDATE SCM_ADM_EXCEL_UPLOAD A
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                  ,MESSAGE_TEXT = 'This file contains invalid quantity data such as ''Alphabet'', ''Decimal'', etc. (e.g. a, b, c, 130.2, 50.4 ...).'
            WHERE  A.PROGRAM_ID = V_PROGRAM_ID
            AND    A.SHEET_NAME = V_SHEET_NAME
            AND    A.CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
            AND    EXISTS (
                     SELECT 1
                     FROM  (SELECT UPLOAD_ID
                                  ,SUM(CASE WHEN ROUND(TO_NUMBER(VALUE), 10) - FLOOR(ROUND(TO_NUMBER(VALUE), 10)) <> 0 THEN 1 ELSE 0 END) PRICE
                            FROM  (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15
                                         , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                         , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                         , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                         , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                         , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                         , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                         , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                         , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                         , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                         , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                         , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                         , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                         , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                         , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                         , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                                   FROM   SCM_ADM_EXCEL_UPLOAD
                                   WHERE  PROGRAM_ID = V_PROGRAM_ID
                                   AND    SHEET_NAME = V_SHEET_NAME
                                   AND    CREATED_BY = P_CREATED_BY
                                   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                   AND    UPLOAD_STATUS_CODE = 'UPLOAD')
                            UNPIVOT (VALUE FOR COLUMN_NAME IN (ATTRIBUTE14, ATTRIBUTE15
                                         , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                         , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                         , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                         , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                         , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                         , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                         , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                         , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                         , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                         , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                         , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                         , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                         , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                         , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                         , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200))
                            WHERE  LTRIM(RTRIM(VALUE)) IS NOT NULL
                            AND    VALUE != '0'
                            AND    VALUE IS NOT NULL
                            GROUP BY UPLOAD_ID) B
                     WHERE  B.UPLOAD_ID = A.UPLOAD_ID
                     AND    B.PRICE > 0
                   );

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '150';
                    V_LOG_MESSAGE := '########## ERROR This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
            END;
            
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '150';
                V_LOG_MESSAGE := '########## This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Upload UOM.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = UPPER(SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11)
                        AND    L.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE'
                        AND    L.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '160';
                    V_LOG_MESSAGE := '########## ERROR Invalid Upload UOM. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '160';
                V_LOG_MESSAGE := '########## Invalid Upload UOM. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            -- Upload UOM by Model
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Upload UOM Costomer FCST.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST CF, SCM_MST_DIVISION D2
                        WHERE  CF.DIVISION_ID = D2.DIVISION_ID
                        AND    CF.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    CF.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    CF.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '170';
                    V_LOG_MESSAGE := '########## ERROR Invalid Upload UOM Costomer FCST. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                    RETURN;  -- 프로시저 즉시 종료
                END IF;        
            
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '170';
                V_LOG_MESSAGE := '########## Invalid Upload UOM Costpmer FCST. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Project.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                            AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                            AND    CM.VALID_YN              = 'Y');
            END;
            
            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
            v_log_type := '16';
            v_log_message := '########## Invalid Project. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Model.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                            AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                            AND    CM.ITEM_ID               = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13
                            AND    CM.VALID_YN              = 'Y');
            END;
            
            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Model ', SQL%ROWCOUNT, 10, TRUE);
            v_log_type := '17';
            v_log_message := '########## Invalid Model. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'SUCCESS'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD';
            END;
        
            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '180';
                V_LOG_MESSAGE := '########## SUCCESS ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
        
        END IF;
    
        BEGIN
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '190';
            V_LOG_MESSAGE := '########## INSERT INTO DATA START ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------
        END;
    
        --// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
        --//======================================================================================
        SELECT COUNT(1)
        INTO   V_COUNT
        FROM   SCM_ADM_EXCEL_UPLOAD T
        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
        AND    T.SHEET_NAME = V_SHEET_NAME
        AND    T.CREATED_BY = P_CREATED_BY
        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
        AND    T.UPLOAD_STATUS_CODE = 'ERROR';
    
        DBMS_OUTPUT.PUT_LINE(V_COUNT); --20240604 SM
    
        -- Update Mode and No Errors
        IF P_MODE > 0 AND V_COUNT = 0 THEN
            BEGIN
                V_START_YYYYMMDD := NULL;
                V_END_YYYYMMDD   := NULL;
            END;
        
            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '200';
                V_LOG_MESSAGE := '########## DELETE FROM DATE START ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
        
            DBMS_OUTPUT.PUT_LINE('TTTTTTT1'); --20240604 SM
        
            BEGIN
                SELECT D.MIN_YYYYMMDD, D.MAX_YYYYMMDD
                INTO   V_START_YYYYMMDD, V_END_YYYYMMDD
                FROM   (SELECT MIN(YYYYMMDD) MIN_YYYYMMDD, MAX(YYYYMMDD) MAX_YYYYMMDD
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'V_TITLE') T UNPIVOT(YYYYMMDD FOR COLUMN_NAME IN( --ATTRIBUTE12, ATTRIBUTE13,   20240605 SM임시조치
                                                                                                             ATTRIBUTE14
                                                                                                            ,ATTRIBUTE15
                                                                                                            ,ATTRIBUTE16
                                                                                                            ,ATTRIBUTE17
                                                                                                            ,ATTRIBUTE18
                                                                                                            ,ATTRIBUTE19
                                                                                                            ,ATTRIBUTE20
                                                                                                            ,ATTRIBUTE21
                                                                                                            ,ATTRIBUTE22
                                                                                                            ,ATTRIBUTE23
                                                                                                            ,ATTRIBUTE24
                                                                                                            ,ATTRIBUTE25
                                                                                                            ,ATTRIBUTE26
                                                                                                            ,ATTRIBUTE27
                                                                                                            ,ATTRIBUTE28
                                                                                                            ,ATTRIBUTE29
                                                                                                            ,ATTRIBUTE30
                                                                                                            ,ATTRIBUTE31
                                                                                                            ,ATTRIBUTE32
                                                                                                            ,ATTRIBUTE33
                                                                                                            ,ATTRIBUTE34
                                                                                                            ,ATTRIBUTE35
                                                                                                            ,ATTRIBUTE36
                                                                                                            ,ATTRIBUTE37
                                                                                                            ,ATTRIBUTE38
                                                                                                            ,ATTRIBUTE39
                                                                                                            ,ATTRIBUTE40
                                                                                                            ,ATTRIBUTE41
                                                                                                            ,ATTRIBUTE42
                                                                                                            ,ATTRIBUTE43
                                                                                                            ,ATTRIBUTE44
                                                                                                            ,ATTRIBUTE45
                                                                                                            ,ATTRIBUTE46
                                                                                                            ,ATTRIBUTE47
                                                                                                            ,ATTRIBUTE48
                                                                                                            ,ATTRIBUTE49
                                                                                                            ,ATTRIBUTE50
                                                                                                            ,ATTRIBUTE51
                                                                                                            ,ATTRIBUTE52
                                                                                                            ,ATTRIBUTE53
                                                                                                            ,ATTRIBUTE54
                                                                                                            ,ATTRIBUTE55
                                                                                                            ,ATTRIBUTE56
                                                                                                            ,ATTRIBUTE57
                                                                                                            ,ATTRIBUTE58
                                                                                                            ,ATTRIBUTE59
                                                                                                            ,ATTRIBUTE60
                                                                                                            ,ATTRIBUTE61
                                                                                                            ,ATTRIBUTE62
                                                                                                            ,ATTRIBUTE63
                                                                                                            ,ATTRIBUTE64
                                                                                                            ,ATTRIBUTE65
                                                                                                            ,ATTRIBUTE66
                                                                                                            ,ATTRIBUTE67
                                                                                                            ,ATTRIBUTE68
                                                                                                            ,ATTRIBUTE69
                                                                                                            ,ATTRIBUTE70
                                                                                                            ,ATTRIBUTE71
                                                                                                            ,ATTRIBUTE72
                                                                                                            ,ATTRIBUTE73
                                                                                                            ,ATTRIBUTE74
                                                                                                            ,ATTRIBUTE75
                                                                                                            ,ATTRIBUTE76
                                                                                                            ,ATTRIBUTE77
                                                                                                            ,ATTRIBUTE78
                                                                                                            ,ATTRIBUTE79
                                                                                                            ,ATTRIBUTE80
                                                                                                            ,ATTRIBUTE81
                                                                                                            ,ATTRIBUTE82
                                                                                                            ,ATTRIBUTE83
                                                                                                            ,ATTRIBUTE84
                                                                                                            ,ATTRIBUTE85
                                                                                                            ,ATTRIBUTE86
                                                                                                            ,ATTRIBUTE87
                                                                                                            ,ATTRIBUTE88
                                                                                                            ,ATTRIBUTE89
                                                                                                            ,ATTRIBUTE90
                                                                                                            ,ATTRIBUTE91
                                                                                                            ,ATTRIBUTE92
                                                                                                            ,ATTRIBUTE93
                                                                                                            ,ATTRIBUTE94
                                                                                                            ,ATTRIBUTE95
                                                                                                            ,ATTRIBUTE96
                                                                                                            ,ATTRIBUTE97
                                                                                                            ,ATTRIBUTE98
                                                                                                            ,ATTRIBUTE99
                                                                                                            ,ATTRIBUTE100
                                                                                                            ,ATTRIBUTE101
                                                                                                            ,ATTRIBUTE102
                                                                                                            ,ATTRIBUTE103
                                                                                                            ,ATTRIBUTE104
                                                                                                            ,ATTRIBUTE105
                                                                                                            ,ATTRIBUTE106
                                                                                                            ,ATTRIBUTE107
                                                                                                            ,ATTRIBUTE108
                                                                                                            ,ATTRIBUTE109
                                                                                                            ,ATTRIBUTE110
                                                                                                            ,ATTRIBUTE111
                                                                                                            ,ATTRIBUTE112
                                                                                                            ,ATTRIBUTE113
                                                                                                            ,ATTRIBUTE114
                                                                                                            ,ATTRIBUTE115
                                                                                                            ,ATTRIBUTE116
                                                                                                            ,ATTRIBUTE117
                                                                                                            ,ATTRIBUTE118
                                                                                                            ,ATTRIBUTE119
                                                                                                            ,ATTRIBUTE120
                                                                                                            ,ATTRIBUTE121
                                                                                                            ,ATTRIBUTE122
                                                                                                            ,ATTRIBUTE123
                                                                                                            ,ATTRIBUTE124
                                                                                                            ,ATTRIBUTE125
                                                                                                            ,ATTRIBUTE126
                                                                                                            ,ATTRIBUTE127
                                                                                                            ,ATTRIBUTE128
                                                                                                            ,ATTRIBUTE129
                                                                                                            ,ATTRIBUTE130
                                                                                                            ,ATTRIBUTE131
                                                                                                            ,ATTRIBUTE132
                                                                                                            ,ATTRIBUTE133
                                                                                                            ,ATTRIBUTE134
                                                                                                            ,ATTRIBUTE135
                                                                                                            ,ATTRIBUTE136
                                                                                                            ,ATTRIBUTE137
                                                                                                            ,ATTRIBUTE138
                                                                                                            ,ATTRIBUTE139
                                                                                                            ,ATTRIBUTE140
                                                                                                            ,ATTRIBUTE141
                                                                                                            ,ATTRIBUTE142
                                                                                                            ,ATTRIBUTE143
                                                                                                            ,ATTRIBUTE144
                                                                                                            ,ATTRIBUTE145
                                                                                                            ,ATTRIBUTE146
                                                                                                            ,ATTRIBUTE147
                                                                                                            ,ATTRIBUTE148
                                                                                                            ,ATTRIBUTE149
                                                                                                            ,ATTRIBUTE150
                                                                                                            ,ATTRIBUTE151
                                                                                                            ,ATTRIBUTE152
                                                                                                            ,ATTRIBUTE153
                                                                                                            ,ATTRIBUTE154
                                                                                                            ,ATTRIBUTE155
                                                                                                            ,ATTRIBUTE156
                                                                                                            ,ATTRIBUTE157
                                                                                                            ,ATTRIBUTE158
                                                                                                            ,ATTRIBUTE159
                                                                                                            ,ATTRIBUTE160
                                                                                                            ,ATTRIBUTE161
                                                                                                            ,ATTRIBUTE162
                                                                                                            ,ATTRIBUTE163
                                                                                                            ,ATTRIBUTE164
                                                                                                            ,ATTRIBUTE165
                                                                                                            ,ATTRIBUTE166
                                                                                                            ,ATTRIBUTE167
                                                                                                            ,ATTRIBUTE168
                                                                                                            ,ATTRIBUTE169
                                                                                                            ,ATTRIBUTE170
                                                                                                            ,ATTRIBUTE171
                                                                                                            ,ATTRIBUTE172
                                                                                                            ,ATTRIBUTE173
                                                                                                            ,ATTRIBUTE174
                                                                                                            ,ATTRIBUTE175
                                                                                                            ,ATTRIBUTE176
                                                                                                            ,ATTRIBUTE177
                                                                                                            ,ATTRIBUTE178
                                                                                                            ,ATTRIBUTE179
                                                                                                            ,ATTRIBUTE180
                                                                                                            ,ATTRIBUTE181
                                                                                                            ,ATTRIBUTE182
                                                                                                            ,ATTRIBUTE183
                                                                                                            ,ATTRIBUTE184
                                                                                                            ,ATTRIBUTE185
                                                                                                            ,ATTRIBUTE186
                                                                                                            ,ATTRIBUTE187
                                                                                                            ,ATTRIBUTE188
                                                                                                            ,ATTRIBUTE189
                                                                                                            ,ATTRIBUTE190
                                                                                                            ,ATTRIBUTE191
                                                                                                            ,ATTRIBUTE192
                                                                                                            ,ATTRIBUTE193
                                                                                                            ,ATTRIBUTE194
                                                                                                            ,ATTRIBUTE195
                                                                                                            ,ATTRIBUTE196
                                                                                                            ,ATTRIBUTE197
                                                                                                            ,ATTRIBUTE198
                                                                                                            ,ATTRIBUTE199
                                                                                                            ,ATTRIBUTE200)) X
                        WHERE  X.YYYYMMDD IS NOT NULL) D;
            END;
        
            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '210';
                V_LOG_MESSAGE := '########## DELETE FROM DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
        
            -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
            BEGIN
            
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '220';
                V_LOG_MESSAGE := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
                DELETE FROM DM_PLN_CUSTOMER_PSI
                WHERE  1 = 1
                AND    MEASURE_GROUP = 'CUST_FCST'
                      -- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
                AND    (SELECT COUNT(1)
                        FROM   SCM_ADM_EXCEL_UPLOAD T
                        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
                        AND    T.SHEET_NAME = V_SHEET_NAME
                        AND    T.CREATED_BY = P_CREATED_BY
                        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                        AND    T.UPLOAD_STATUS_CODE = 'SUCCESS'
                        AND    DM_PLN_CUSTOMER_PSI.DIVISION_ID = T.ATTRIBUTE1
                        AND    DM_PLN_CUSTOMER_PSI.SCM_SITE_ID = T.ATTRIBUTE2
                        AND    DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID = T.ATTRIBUTE3
                        AND    DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE = T.ATTRIBUTE4
                        AND    DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL = T.ATTRIBUTE5
                        AND    DM_PLN_CUSTOMER_PSI.INCOTERMS = T.ATTRIBUTE6
                        AND    DM_PLN_CUSTOMER_PSI.FCST_TYPE = T.ATTRIBUTE7
                        AND    DM_PLN_CUSTOMER_PSI.DOM_EXP = T.ATTRIBUTE8
                        AND    DM_PLN_CUSTOMER_PSI.MEASURE = T.ATTRIBUTE10) > 0
                AND    YYYYMMDD BETWEEN V_START_YYYYMMDD AND V_END_YYYYMMDD;
            
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '230';
                V_LOG_MESSAGE := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
            DBMS_OUTPUT.PUT_LINE('230');
        
            -- 엑셀로 업로드된 MEASURE를 MASTER의 MEASURE로 변경
            UPDATE SCM_ADM_EXCEL_UPLOAD AA
            SET    ATTRIBUTE10 =
                   (SELECT BB.MEASURE
                    FROM   (SELECT DISTINCT A.DIVISION_ID, B.DIVISION_NAME, A.SCM_SITE_ID, A.VALID_YN, A.MEASURE, A.UPLOAD_UOM, A.UPLOAD_BUCKET_TYPE
                            FROM   DM_MST_CUSTOMER_FCST A
                            INNER  JOIN SCM_MST_DIVISION B
                            ON     A.VALID_YN = 'Y'
                            AND    A.DIVISION_ID = B.DIVISION_ID) BB
                    WHERE  (BB.DIVISION_ID = AA.ATTRIBUTE1 OR BB.DIVISION_NAME = AA.ATTRIBUTE1)
                    AND    BB.SCM_SITE_ID = AA.ATTRIBUTE2
                    AND    BB.MEASURE = AA.ATTRIBUTE10
                    AND    BB.UPLOAD_UOM = UPPER(AA.ATTRIBUTE11)
                    AND    BB.UPLOAD_BUCKET_TYPE IN (
                                                     
                                                     SELECT CASE (TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14, 'YYYYMMDD'))
                                                                 WHEN 1 THEN
                                                                  'DAILY'
                                                                 WHEN 7 THEN
                                                                  'WEEKLY'
                                                                 ELSE
                                                                  'MONTHLY'
                                                             END
                                                     FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                     WHERE  Z.PROGRAM_ID = V_PROGRAM_ID
                                                     AND    Z.SHEET_NAME = V_SHEET_NAME
                                                     AND    Z.CREATED_BY = P_CREATED_BY
                                                     AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                                     AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE')
                    AND    ROWNUM = 1)
            WHERE  AA.PROGRAM_ID = V_PROGRAM_ID
            AND    AA.SHEET_NAME = V_SHEET_NAME
            AND    AA.CREATED_BY = P_CREATED_BY
            AND    AA.UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    TO_CHAR(AA.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE;
        
            INSERT INTO DM_PLN_CUSTOMER_PSI
                (DIVISION_ID
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,CUSTOMER_PROJECT_CODE
                ,CUSTOMER_MODEL
                ,INCOTERMS
                ,FCST_TYPE
                ,DOM_EXP
                ,MEASURE_GROUP
                ,MEASURE
                ,UPLOAD_UOM
                ,PROJECT_CODE
                ,ITEM_ID
                ,YYYYMMDD
                ,QTY
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                ,BATCH_RESULT)
                SELECT V.ATTRIBUTE1
                      ,V.ATTRIBUTE2
                      ,V.ATTRIBUTE3
                      ,V.ATTRIBUTE4
                      ,V.ATTRIBUTE5
                      ,V.ATTRIBUTE6
                      ,V.ATTRIBUTE7
                      ,V.ATTRIBUTE8
                      ,V.ATTRIBUTE9
                      ,V.ATTRIBUTE10
                      ,UPPER(V.ATTRIBUTE11)
                      ,V.ATTRIBUTE12
                      ,V.ATTRIBUTE13
                      ,C.YYYYMMDD
                      ,TO_NUMBER(V.VALUE)
                      ,P_CREATED_BY
                      ,SYSDATE--TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
                      ,P_CREATED_BY
                      ,SYSDATE--TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
                      ,'UI'
                FROM   (SELECT ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10
                              ,ATTRIBUTE11
                              ,ATTRIBUTE12
                              ,ATTRIBUTE13
                              ,COLUMN_NAME
                              ,YYYYMMDD
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                      -- modified by ytchoi 180305
                                      -- AND    CREATION_DATE = v_creation_date
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'V_TITLE') T UNPIVOT(YYYYMMDD FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                            ,ATTRIBUTE15
                                                                                                            ,ATTRIBUTE16
                                                                                                            ,ATTRIBUTE17
                                                                                                            ,ATTRIBUTE18
                                                                                                            ,ATTRIBUTE19
                                                                                                            ,ATTRIBUTE20
                                                                                                            ,ATTRIBUTE21
                                                                                                            ,ATTRIBUTE22
                                                                                                            ,ATTRIBUTE23
                                                                                                            ,ATTRIBUTE24
                                                                                                            ,ATTRIBUTE25
                                                                                                            ,ATTRIBUTE26
                                                                                                            ,ATTRIBUTE27
                                                                                                            ,ATTRIBUTE28
                                                                                                            ,ATTRIBUTE29
                                                                                                            ,ATTRIBUTE30
                                                                                                            ,ATTRIBUTE31
                                                                                                            ,ATTRIBUTE32
                                                                                                            ,ATTRIBUTE33
                                                                                                            ,ATTRIBUTE34
                                                                                                            ,ATTRIBUTE35
                                                                                                            ,ATTRIBUTE36
                                                                                                            ,ATTRIBUTE37
                                                                                                            ,ATTRIBUTE38
                                                                                                            ,ATTRIBUTE39
                                                                                                            ,ATTRIBUTE40
                                                                                                            ,ATTRIBUTE41
                                                                                                            ,ATTRIBUTE42
                                                                                                            ,ATTRIBUTE43
                                                                                                            ,ATTRIBUTE44
                                                                                                            ,ATTRIBUTE45
                                                                                                            ,ATTRIBUTE46
                                                                                                            ,ATTRIBUTE47
                                                                                                            ,ATTRIBUTE48
                                                                                                            ,ATTRIBUTE49
                                                                                                            ,ATTRIBUTE50
                                                                                                            ,ATTRIBUTE51
                                                                                                            ,ATTRIBUTE52
                                                                                                            ,ATTRIBUTE53
                                                                                                            ,ATTRIBUTE54
                                                                                                            ,ATTRIBUTE55
                                                                                                            ,ATTRIBUTE56
                                                                                                            ,ATTRIBUTE57
                                                                                                            ,ATTRIBUTE58
                                                                                                            ,ATTRIBUTE59
                                                                                                            ,ATTRIBUTE60
                                                                                                            ,ATTRIBUTE61
                                                                                                            ,ATTRIBUTE62
                                                                                                            ,ATTRIBUTE63
                                                                                                            ,ATTRIBUTE64
                                                                                                            ,ATTRIBUTE65
                                                                                                            ,ATTRIBUTE66
                                                                                                            ,ATTRIBUTE67
                                                                                                            ,ATTRIBUTE68
                                                                                                            ,ATTRIBUTE69
                                                                                                            ,ATTRIBUTE70
                                                                                                            ,ATTRIBUTE71
                                                                                                            ,ATTRIBUTE72
                                                                                                            ,ATTRIBUTE73
                                                                                                            ,ATTRIBUTE74
                                                                                                            ,ATTRIBUTE75
                                                                                                            ,ATTRIBUTE76
                                                                                                            ,ATTRIBUTE77
                                                                                                            ,ATTRIBUTE78
                                                                                                            ,ATTRIBUTE79
                                                                                                            ,ATTRIBUTE80
                                                                                                            ,ATTRIBUTE81
                                                                                                            ,ATTRIBUTE82
                                                                                                            ,ATTRIBUTE83
                                                                                                            ,ATTRIBUTE84
                                                                                                            ,ATTRIBUTE85
                                                                                                            ,ATTRIBUTE86
                                                                                                            ,ATTRIBUTE87
                                                                                                            ,ATTRIBUTE88
                                                                                                            ,ATTRIBUTE89
                                                                                                            ,ATTRIBUTE90
                                                                                                            ,ATTRIBUTE91
                                                                                                            ,ATTRIBUTE92
                                                                                                            ,ATTRIBUTE93
                                                                                                            ,ATTRIBUTE94
                                                                                                            ,ATTRIBUTE95
                                                                                                            ,ATTRIBUTE96
                                                                                                            ,ATTRIBUTE97
                                                                                                            ,ATTRIBUTE98
                                                                                                            ,ATTRIBUTE99
                                                                                                            ,ATTRIBUTE100
                                                                                                            ,ATTRIBUTE101
                                                                                                            ,ATTRIBUTE102
                                                                                                            ,ATTRIBUTE103
                                                                                                            ,ATTRIBUTE104
                                                                                                            ,ATTRIBUTE105
                                                                                                            ,ATTRIBUTE106
                                                                                                            ,ATTRIBUTE107
                                                                                                            ,ATTRIBUTE108
                                                                                                            ,ATTRIBUTE109
                                                                                                            ,ATTRIBUTE110
                                                                                                            ,ATTRIBUTE111
                                                                                                            ,ATTRIBUTE112
                                                                                                            ,ATTRIBUTE113
                                                                                                            ,ATTRIBUTE114
                                                                                                            ,ATTRIBUTE115
                                                                                                            ,ATTRIBUTE116
                                                                                                            ,ATTRIBUTE117
                                                                                                            ,ATTRIBUTE118
                                                                                                            ,ATTRIBUTE119
                                                                                                            ,ATTRIBUTE120
                                                                                                            ,ATTRIBUTE121
                                                                                                            ,ATTRIBUTE122
                                                                                                            ,ATTRIBUTE123
                                                                                                            ,ATTRIBUTE124
                                                                                                            ,ATTRIBUTE125
                                                                                                            ,ATTRIBUTE126
                                                                                                            ,ATTRIBUTE127
                                                                                                            ,ATTRIBUTE128
                                                                                                            ,ATTRIBUTE129
                                                                                                            ,ATTRIBUTE130
                                                                                                            ,ATTRIBUTE131
                                                                                                            ,ATTRIBUTE132
                                                                                                            ,ATTRIBUTE133
                                                                                                            ,ATTRIBUTE134
                                                                                                            ,ATTRIBUTE135
                                                                                                            ,ATTRIBUTE136
                                                                                                            ,ATTRIBUTE137
                                                                                                            ,ATTRIBUTE138
                                                                                                            ,ATTRIBUTE139
                                                                                                            ,ATTRIBUTE140
                                                                                                            ,ATTRIBUTE141
                                                                                                            ,ATTRIBUTE142
                                                                                                            ,ATTRIBUTE143
                                                                                                            ,ATTRIBUTE144
                                                                                                            ,ATTRIBUTE145
                                                                                                            ,ATTRIBUTE146
                                                                                                            ,ATTRIBUTE147
                                                                                                            ,ATTRIBUTE148
                                                                                                            ,ATTRIBUTE149
                                                                                                            ,ATTRIBUTE150
                                                                                                            ,ATTRIBUTE151
                                                                                                            ,ATTRIBUTE152
                                                                                                            ,ATTRIBUTE153
                                                                                                            ,ATTRIBUTE154
                                                                                                            ,ATTRIBUTE155
                                                                                                            ,ATTRIBUTE156
                                                                                                            ,ATTRIBUTE157
                                                                                                            ,ATTRIBUTE158
                                                                                                            ,ATTRIBUTE159
                                                                                                            ,ATTRIBUTE160
                                                                                                            ,ATTRIBUTE161
                                                                                                            ,ATTRIBUTE162
                                                                                                            ,ATTRIBUTE163
                                                                                                            ,ATTRIBUTE164
                                                                                                            ,ATTRIBUTE165
                                                                                                            ,ATTRIBUTE166
                                                                                                            ,ATTRIBUTE167
                                                                                                            ,ATTRIBUTE168
                                                                                                            ,ATTRIBUTE169
                                                                                                            ,ATTRIBUTE170
                                                                                                            ,ATTRIBUTE171
                                                                                                            ,ATTRIBUTE172
                                                                                                            ,ATTRIBUTE173
                                                                                                            ,ATTRIBUTE174
                                                                                                            ,ATTRIBUTE175
                                                                                                            ,ATTRIBUTE176
                                                                                                            ,ATTRIBUTE177
                                                                                                            ,ATTRIBUTE178
                                                                                                            ,ATTRIBUTE179
                                                                                                            ,ATTRIBUTE180
                                                                                                            ,ATTRIBUTE181
                                                                                                            ,ATTRIBUTE182
                                                                                                            ,ATTRIBUTE183
                                                                                                            ,ATTRIBUTE184
                                                                                                            ,ATTRIBUTE185
                                                                                                            ,ATTRIBUTE186
                                                                                                            ,ATTRIBUTE187
                                                                                                            ,ATTRIBUTE188
                                                                                                            ,ATTRIBUTE189
                                                                                                            ,ATTRIBUTE190
                                                                                                            ,ATTRIBUTE191
                                                                                                            ,ATTRIBUTE192
                                                                                                            ,ATTRIBUTE193
                                                                                                            ,ATTRIBUTE194
                                                                                                            ,ATTRIBUTE195
                                                                                                            ,ATTRIBUTE196
                                                                                                            ,ATTRIBUTE197
                                                                                                            ,ATTRIBUTE198
                                                                                                            ,ATTRIBUTE199
                                                                                                            ,ATTRIBUTE200)) X) C
                      ,(SELECT ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10
                              ,ATTRIBUTE11
                              ,ATTRIBUTE12
                              ,ATTRIBUTE13
                              ,COLUMN_NAME
                              ,VALUE
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'SUCCESS') T UNPIVOT(VALUE FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                         ,ATTRIBUTE15
                                                                                                         ,ATTRIBUTE16
                                                                                                         ,ATTRIBUTE17
                                                                                                         ,ATTRIBUTE18
                                                                                                         ,ATTRIBUTE19
                                                                                                         ,ATTRIBUTE20
                                                                                                         ,ATTRIBUTE21
                                                                                                         ,ATTRIBUTE22
                                                                                                         ,ATTRIBUTE23
                                                                                                         ,ATTRIBUTE24
                                                                                                         ,ATTRIBUTE25
                                                                                                         ,ATTRIBUTE26
                                                                                                         ,ATTRIBUTE27
                                                                                                         ,ATTRIBUTE28
                                                                                                         ,ATTRIBUTE29
                                                                                                         ,ATTRIBUTE30
                                                                                                         ,ATTRIBUTE31
                                                                                                         ,ATTRIBUTE32
                                                                                                         ,ATTRIBUTE33
                                                                                                         ,ATTRIBUTE34
                                                                                                         ,ATTRIBUTE35
                                                                                                         ,ATTRIBUTE36
                                                                                                         ,ATTRIBUTE37
                                                                                                         ,ATTRIBUTE38
                                                                                                         ,ATTRIBUTE39
                                                                                                         ,ATTRIBUTE40
                                                                                                         ,ATTRIBUTE41
                                                                                                         ,ATTRIBUTE42
                                                                                                         ,ATTRIBUTE43
                                                                                                         ,ATTRIBUTE44
                                                                                                         ,ATTRIBUTE45
                                                                                                         ,ATTRIBUTE46
                                                                                                         ,ATTRIBUTE47
                                                                                                         ,ATTRIBUTE48
                                                                                                         ,ATTRIBUTE49
                                                                                                         ,ATTRIBUTE50
                                                                                                         ,ATTRIBUTE51
                                                                                                         ,ATTRIBUTE52
                                                                                                         ,ATTRIBUTE53
                                                                                                         ,ATTRIBUTE54
                                                                                                         ,ATTRIBUTE55
                                                                                                         ,ATTRIBUTE56
                                                                                                         ,ATTRIBUTE57
                                                                                                         ,ATTRIBUTE58
                                                                                                         ,ATTRIBUTE59
                                                                                                         ,ATTRIBUTE60
                                                                                                         ,ATTRIBUTE61
                                                                                                         ,ATTRIBUTE62
                                                                                                         ,ATTRIBUTE63
                                                                                                         ,ATTRIBUTE64
                                                                                                         ,ATTRIBUTE65
                                                                                                         ,ATTRIBUTE66
                                                                                                         ,ATTRIBUTE67
                                                                                                         ,ATTRIBUTE68
                                                                                                         ,ATTRIBUTE69
                                                                                                         ,ATTRIBUTE70
                                                                                                         ,ATTRIBUTE71
                                                                                                         ,ATTRIBUTE72
                                                                                                         ,ATTRIBUTE73
                                                                                                         ,ATTRIBUTE74
                                                                                                         ,ATTRIBUTE75
                                                                                                         ,ATTRIBUTE76
                                                                                                         ,ATTRIBUTE77
                                                                                                         ,ATTRIBUTE78
                                                                                                         ,ATTRIBUTE79
                                                                                                         ,ATTRIBUTE80
                                                                                                         ,ATTRIBUTE81
                                                                                                         ,ATTRIBUTE82
                                                                                                         ,ATTRIBUTE83
                                                                                                         ,ATTRIBUTE84
                                                                                                         ,ATTRIBUTE85
                                                                                                         ,ATTRIBUTE86
                                                                                                         ,ATTRIBUTE87
                                                                                                         ,ATTRIBUTE88
                                                                                                         ,ATTRIBUTE89
                                                                                                         ,ATTRIBUTE90
                                                                                                         ,ATTRIBUTE91
                                                                                                         ,ATTRIBUTE92
                                                                                                         ,ATTRIBUTE93
                                                                                                         ,ATTRIBUTE94
                                                                                                         ,ATTRIBUTE95
                                                                                                         ,ATTRIBUTE96
                                                                                                         ,ATTRIBUTE97
                                                                                                         ,ATTRIBUTE98
                                                                                                         ,ATTRIBUTE99
                                                                                                         ,ATTRIBUTE100
                                                                                                         ,ATTRIBUTE101
                                                                                                         ,ATTRIBUTE102
                                                                                                         ,ATTRIBUTE103
                                                                                                         ,ATTRIBUTE104
                                                                                                         ,ATTRIBUTE105
                                                                                                         ,ATTRIBUTE106
                                                                                                         ,ATTRIBUTE107
                                                                                                         ,ATTRIBUTE108
                                                                                                         ,ATTRIBUTE109
                                                                                                         ,ATTRIBUTE110
                                                                                                         ,ATTRIBUTE111
                                                                                                         ,ATTRIBUTE112
                                                                                                         ,ATTRIBUTE113
                                                                                                         ,ATTRIBUTE114
                                                                                                         ,ATTRIBUTE115
                                                                                                         ,ATTRIBUTE116
                                                                                                         ,ATTRIBUTE117
                                                                                                         ,ATTRIBUTE118
                                                                                                         ,ATTRIBUTE119
                                                                                                         ,ATTRIBUTE120
                                                                                                         ,ATTRIBUTE121
                                                                                                         ,ATTRIBUTE122
                                                                                                         ,ATTRIBUTE123
                                                                                                         ,ATTRIBUTE124
                                                                                                         ,ATTRIBUTE125
                                                                                                         ,ATTRIBUTE126
                                                                                                         ,ATTRIBUTE127
                                                                                                         ,ATTRIBUTE128
                                                                                                         ,ATTRIBUTE129
                                                                                                         ,ATTRIBUTE130
                                                                                                         ,ATTRIBUTE131
                                                                                                         ,ATTRIBUTE132
                                                                                                         ,ATTRIBUTE133
                                                                                                         ,ATTRIBUTE134
                                                                                                         ,ATTRIBUTE135
                                                                                                         ,ATTRIBUTE136
                                                                                                         ,ATTRIBUTE137
                                                                                                         ,ATTRIBUTE138
                                                                                                         ,ATTRIBUTE139
                                                                                                         ,ATTRIBUTE140
                                                                                                         ,ATTRIBUTE141
                                                                                                         ,ATTRIBUTE142
                                                                                                         ,ATTRIBUTE143
                                                                                                         ,ATTRIBUTE144
                                                                                                         ,ATTRIBUTE145
                                                                                                         ,ATTRIBUTE146
                                                                                                         ,ATTRIBUTE147
                                                                                                         ,ATTRIBUTE148
                                                                                                         ,ATTRIBUTE149
                                                                                                         ,ATTRIBUTE150
                                                                                                         ,ATTRIBUTE151
                                                                                                         ,ATTRIBUTE152
                                                                                                         ,ATTRIBUTE153
                                                                                                         ,ATTRIBUTE154
                                                                                                         ,ATTRIBUTE155
                                                                                                         ,ATTRIBUTE156
                                                                                                         ,ATTRIBUTE157
                                                                                                         ,ATTRIBUTE158
                                                                                                         ,ATTRIBUTE159
                                                                                                         ,ATTRIBUTE160
                                                                                                         ,ATTRIBUTE161
                                                                                                         ,ATTRIBUTE162
                                                                                                         ,ATTRIBUTE163
                                                                                                         ,ATTRIBUTE164
                                                                                                         ,ATTRIBUTE165
                                                                                                         ,ATTRIBUTE166
                                                                                                         ,ATTRIBUTE167
                                                                                                         ,ATTRIBUTE168
                                                                                                         ,ATTRIBUTE169
                                                                                                         ,ATTRIBUTE170
                                                                                                         ,ATTRIBUTE171
                                                                                                         ,ATTRIBUTE172
                                                                                                         ,ATTRIBUTE173
                                                                                                         ,ATTRIBUTE174
                                                                                                         ,ATTRIBUTE175
                                                                                                         ,ATTRIBUTE176
                                                                                                         ,ATTRIBUTE177
                                                                                                         ,ATTRIBUTE178
                                                                                                         ,ATTRIBUTE179
                                                                                                         ,ATTRIBUTE180
                                                                                                         ,ATTRIBUTE181
                                                                                                         ,ATTRIBUTE182
                                                                                                         ,ATTRIBUTE183
                                                                                                         ,ATTRIBUTE184
                                                                                                         ,ATTRIBUTE185
                                                                                                         ,ATTRIBUTE186
                                                                                                         ,ATTRIBUTE187
                                                                                                         ,ATTRIBUTE188
                                                                                                         ,ATTRIBUTE189
                                                                                                         ,ATTRIBUTE190
                                                                                                         ,ATTRIBUTE191
                                                                                                         ,ATTRIBUTE192
                                                                                                         ,ATTRIBUTE193
                                                                                                         ,ATTRIBUTE194
                                                                                                         ,ATTRIBUTE195
                                                                                                         ,ATTRIBUTE196
                                                                                                         ,ATTRIBUTE197
                                                                                                         ,ATTRIBUTE198
                                                                                                         ,ATTRIBUTE199
                                                                                                         ,ATTRIBUTE200)) X) V
                WHERE  1 = 1
                AND    C.COLUMN_NAME = V.COLUMN_NAME
                AND    C.YYYYMMDD IS NOT NULL
                AND    V.VALUE IS NOT NULL;
        
            DBMS_OUTPUT.PUT_LINE('240');
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '240';
            V_LOG_MESSAGE := '########## INSERT INTO DM_PLN_CUSTOMER_PSI DATE END ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------
            IF (V_DIVISION = '40') THEN
                PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40('40');
            ELSE
                DBMS_OUTPUT.PUT_LINE('20240605-');
                IF to_char(SYSDATE,'yyyymmdd') >= '20260412' THEN -- poc 테스트 위함.
                PR_DM_PLN_CUST_FCST_TO_MKT_FCST;
                END IF;
            END IF;
        
            COMMIT;
            -- END TRY
        
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## INSERT INTO DATA END ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------
        
        END IF;    
        COMMIT;
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,'ERROR'
                                ,0
                                ,SQLERRM
                                ,NULL
                                ,SYSDATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0014_CUST_FCST_EXCEL_UPLOAD;

    PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
    (
        P_MODE          INTEGER
       ,P_CREATED_BY    VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
        * Description  : DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
        * Program History
        *===========================================================================================================
        *   Date       In Charge      Description
        *===========================================================================================================
        * 2018. 01. 02   SongDH     Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        * 2022. 10. 26     KDW2819    [C20221024-000507]CUST FCST Upload 오류 수정
        * 2023. 01. 25   kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
        * 2023. 02. 28   chano0612 [E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생 -- EXCEL UPLOAD
        * 2024. 02. 15   kcw3408   [E20240208-001344]고객 수요 분석 시스템_Cust.FCST upload 문의의 건(데이타 없는데 Ctrl + End 키로는 인식되어 Length가 0인 컬럼을 Check 추가)
         * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
        --DMF0014_CUST_FCST_EXCEL_UPLOAD_SM('1', 'hwayoung.lim');
     AS
    
        V_IN_PARA_DATA   VARCHAR2(4000);
        V_STEP           VARCHAR2(4000 CHAR) := NULL;
        V_PROGRAM_ID     VARCHAR2(40 CHAR) := 'DMF0014';
        V_SHEET_NAME     VARCHAR2(40 CHAR) := 'FCST Upload';
        V_SQL_TEXT       VARCHAR2(4000 CHAR);
        V_CREATION_DATE  VARCHAR2(40 CHAR);
        V_COUNT          INTEGER;
        V_START_YYYYMMDD VARCHAR2(8 CHAR);
        V_END_YYYYMMDD   VARCHAR2(8 CHAR);
        V_DIVISION       VARCHAR2(10 CHAR);
        $$PLSQL_UNIT   VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE       VARCHAR2(30 CHAR);
        N_LOG_COUNT      INTEGER := 0;
        V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
        V_DESCRIPTION    VARCHAR2(500 CHAR);
        D_EVENT_DATE     DATE;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        V_IN_PARA_DATA := JSON_OBJECT('p_mode' VALUE P_MODE, 'p_created_by' VALUE P_CREATED_BY);
    
        -- LOG 용 변수 설정
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    
        SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
        INTO   V_CREATION_DATE
        FROM   SCM_ADM_EXCEL_UPLOAD T
        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
        AND    T.SHEET_NAME = V_SHEET_NAME
        AND    T.CREATED_BY = P_CREATED_BY;
        --  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
        IF V_CREATION_DATE IS NULL THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'Data Not Found [' || TO_CHAR(V_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') || ']';
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END IF;
    
        --DMF0014_CUST_FCST_EXCEL_UPLOAD_SM('1', 'hwayoung.lim');
        BEGIN
            SELECT ATTRIBUTE1
            INTO   V_DIVISION
            FROM   SCM_ADM_EXCEL_UPLOAD
            WHERE  PROGRAM_ID = V_PROGRAM_ID
            AND    SHEET_NAME = V_SHEET_NAME
            AND    CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    UPPER(ATTRIBUTE1) <> 'DIVISION*'
                  --AND    UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            FETCH  FIRST 1 ROWS ONLY;
        END;
    
        -- p_mode = 0 이면 Validation
        IF NVL(P_MODE, 0) = 0 THEN
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD T
                SET    UPLOAD_STATUS_CODE = 'UPLOAD', MESSAGE_TEXT = NULL
                WHERE  T.PROGRAM_ID = V_PROGRAM_ID
                AND    T.SHEET_NAME = V_SHEET_NAME
                AND    T.CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    NVL(T.UPLOAD_STATUS_CODE, 'X') != 'UPLOAD';
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
                V_LOG_TYPE    := '1';
                V_LOG_MESSAGE := '########## RESET Status = UPLOAD ##########';
                V_DESCRIPTION := P_MODE;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'SKIP'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    (ATTRIBUTE1 IS NULL OR LENGTH(ATTRIBUTE1) = 0 OR UPPER(ATTRIBUTE1) = 'TOTAL');
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
                V_LOG_TYPE    := '2';
                V_LOG_MESSAGE := '########## SKIP EMPTY LINE ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'V_TITLE'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPPER(ATTRIBUTE1) = 'DIVISION*';
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('V_TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
                V_LOG_TYPE    := '3';
                V_LOG_MESSAGE := '########## TITLE Header Line ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Duplication Key.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    EXISTS (SELECT 1
                        FROM   (SELECT X.ATTRIBUTE1  AS COL1
                                      ,X.ATTRIBUTE2  COL2
                                      ,X.ATTRIBUTE3  COL3
                                      ,X.ATTRIBUTE4  COL4
                                      ,X.ATTRIBUTE5  COL5
                                      ,X.ATTRIBUTE6  COL6
                                      ,X.ATTRIBUTE7  COL7
                                      ,X.ATTRIBUTE8  COL8
                                      ,X.ATTRIBUTE9  COL9
                                      ,X.ATTRIBUTE10 COL10
                                --, X.ATTRIBUTE11 COL11
                                --, X.ATTRIBUTE12 COL12
                                FROM   SCM_ADM_EXCEL_UPLOAD X
                                WHERE  X.PROGRAM_ID = V_PROGRAM_ID
                                AND    X.SHEET_NAME = V_SHEET_NAME
                                AND    X.CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                                GROUP  BY X.ATTRIBUTE1
                                         ,X.ATTRIBUTE2
                                         ,X.ATTRIBUTE3
                                         ,X.ATTRIBUTE4
                                         ,X.ATTRIBUTE5
                                         ,X.ATTRIBUTE6
                                         ,X.ATTRIBUTE7
                                         ,X.ATTRIBUTE8
                                         ,X.ATTRIBUTE9
                                         ,X.ATTRIBUTE10
                                --, X.ATTRIBUTE11
                                --, X.ATTRIBUTE12
                                HAVING COUNT(*) > 1) T
                        WHERE  1 = 1
                        AND    T.COL1 = ATTRIBUTE1
                        AND    T.COL2 = ATTRIBUTE2
                        AND    T.COL3 = ATTRIBUTE3
                        AND    T.COL4 = ATTRIBUTE4
                        AND    T.COL5 = ATTRIBUTE5
                        AND    T.COL6 = ATTRIBUTE6
                        AND    T.COL7 = ATTRIBUTE7
                        AND    T.COL8 = ATTRIBUTE8
                        AND    T.COL9 = ATTRIBUTE9
                        AND    T.COL10 = ATTRIBUTE10
                        --AND T.COL11 = ATTRIBUTE11
                        --AND T.COL12 = ATTRIBUTE12
                        );
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
                V_LOG_TYPE    := '4';
                V_LOG_MESSAGE := '########## ERROR Key Duplication ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Division.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                        UNION
                        SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1);
            END;
        
            BEGIN
                -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    ATTRIBUTE1 =
                       (SELECT D.DIVISION_ID
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1);
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Measure Upload Bucket.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D, SCM_MST_DIVISION D2
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    D.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    D.UPLOAD_BUCKET_TYPE IN (SELECT CASE (TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14, 'YYYYMMDD'))
                                                                   WHEN 1 THEN
                                                                    'DAILY'
                                                                   WHEN 7 THEN
                                                                    'WEEKLY'
                                                                   ELSE
                                                                    'MONTHLY'
                                                               END
                                                        FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                        WHERE  Z.PROGRAM_ID = V_PROGRAM_ID
                                                        AND    Z.SHEET_NAME = V_SHEET_NAME
                                                        AND    Z.CREATED_BY = P_CREATED_BY
                                                        AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                                        AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE'));
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Measure Upload UOM.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D, SCM_MST_DIVISION D2
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    D.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    D.UPLOAD_UOM = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11);
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
                V_LOG_TYPE    := '5';
                V_LOG_MESSAGE := '########## Invalid Division ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Scm Site.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S, SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
                        AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    S.VALID_YN = 'Y');
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
                V_LOG_TYPE    := '6';
                V_LOG_MESSAGE := '########## Invalid Scm Site. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Plant Site.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    (ATTRIBUTE1 = '81' OR ATTRIBUTE1 = 'Automotive Battery') -- ess는 제외
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S, SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
                        AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    S.VALID_YN = 'Y');
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
                V_LOG_TYPE    := '6';
                V_LOG_MESSAGE := '########## Invalid Plant Site. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Customer Project.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.VALID_YN              = 'Y');
            END;
            
            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Customer Project ', SQL%ROWCOUNT, 6, TRUE);
            v_log_type := '7';
            v_log_message := '########## Invalid Customer Project ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            IF V_DIVISION != '40' THEN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Customer Model.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM, SCM_MST_DIVISION D2
                        WHERE  CM.DIVISION_ID = D2.DIVISION_ID
                        AND    CM.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                        AND    CM.CUSTOMER_MODEL = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    CM.VALID_YN = 'Y'
                        UNION
                        SELECT 1
                        FROM   SCM_MST_SITE_ITEM SI, SCM_MST_DIVISION D3
                        WHERE  SI.DIVISION_ID = D3.DIVISION_ID
                        AND    SI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    SI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                        AND    SI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                        AND    (D3.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D3.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    SI.VALID_YN = 'Y');
            END IF;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
                V_LOG_TYPE    := '8';
                V_LOG_MESSAGE := '########## Invalid Customer Model ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Incoterms.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
                        AND    L.LOOKUP_TYPE = 'INCOTERMS'
                        AND    L.VALID_YN = 'Y');
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '10';
                V_LOG_MESSAGE := '########## Invalid Incoterms. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Sales Type.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
                        AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    L.VALID_YN = 'Y'
                        UNION
                        SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DESCRIPTION = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7);
            END;
        
            BEGIN
                -- validation이 끝났으니 code로 update
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    ATTRIBUTE7 =
                       (SELECT D.SEGMENT1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    D.SEGMENT2 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7)
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
                        AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    L.VALID_YN = 'Y');
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '11';
                V_LOG_MESSAGE := '########## Invalid Sales Type. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Customs Handbook'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8
                            AND    L.LOOKUP_TYPE = 'DOM/EXP'
                            AND    L.VALID_YN    = 'Y');
            END;
            
            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
            v_log_type := '12';
            v_log_message := '########## Invalid DOM/EXP. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Measure Group.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE9
                        AND    L.LOOKUP_TYPE = 'MEASURE_GROUP_CODE'
                        AND    L.SEGMENT1 = 'CUST_FCST'
                        AND    L.VALID_YN = 'Y');
            END;
        
            --20230125 kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '12';
                V_LOG_MESSAGE := '########## Invalid Alphabet, NUMBER. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            --문자열 체크
            BEGIN
            
                MERGE INTO SCM_ADM_EXCEL_UPLOAD A
                USING (SELECT *
                       FROM   (SELECT UPLOAD_ID
                                     ,SUM(CASE
                                              WHEN REGEXP_LIKE(VALUE, '^\s*[+-]?\d*\.?\d+\s*$') THEN
                                               0
                                              ELSE
                                               1
                                          END) PRICE
                               FROM   (SELECT UPLOAD_ID
                                             ,ATTRIBUTE14
                                             ,ATTRIBUTE15
                                             ,ATTRIBUTE16
                                             ,ATTRIBUTE17
                                             ,ATTRIBUTE18
                                             ,ATTRIBUTE19
                                             ,ATTRIBUTE20
                                             ,ATTRIBUTE21
                                             ,ATTRIBUTE22
                                             ,ATTRIBUTE23
                                             ,ATTRIBUTE24
                                             ,ATTRIBUTE25
                                             ,ATTRIBUTE26
                                             ,ATTRIBUTE27
                                             ,ATTRIBUTE28
                                             ,ATTRIBUTE29
                                             ,ATTRIBUTE30
                                             ,ATTRIBUTE31
                                             ,ATTRIBUTE32
                                             ,ATTRIBUTE33
                                             ,ATTRIBUTE34
                                             ,ATTRIBUTE35
                                             ,ATTRIBUTE36
                                             ,ATTRIBUTE37
                                             ,ATTRIBUTE38
                                             ,ATTRIBUTE39
                                             ,ATTRIBUTE40
                                             ,ATTRIBUTE41
                                             ,ATTRIBUTE42
                                             ,ATTRIBUTE43
                                             ,ATTRIBUTE44
                                             ,ATTRIBUTE45
                                             ,ATTRIBUTE46
                                             ,ATTRIBUTE47
                                             ,ATTRIBUTE48
                                             ,ATTRIBUTE49
                                             ,ATTRIBUTE50
                                             ,ATTRIBUTE51
                                             ,ATTRIBUTE52
                                             ,ATTRIBUTE53
                                             ,ATTRIBUTE54
                                             ,ATTRIBUTE55
                                             ,ATTRIBUTE56
                                             ,ATTRIBUTE57
                                             ,ATTRIBUTE58
                                             ,ATTRIBUTE59
                                             ,ATTRIBUTE60
                                             ,ATTRIBUTE61
                                             ,ATTRIBUTE62
                                             ,ATTRIBUTE63
                                             ,ATTRIBUTE64
                                             ,ATTRIBUTE65
                                             ,ATTRIBUTE66
                                             ,ATTRIBUTE67
                                             ,ATTRIBUTE68
                                             ,ATTRIBUTE69
                                             ,ATTRIBUTE70
                                             ,ATTRIBUTE71
                                             ,ATTRIBUTE72
                                             ,ATTRIBUTE73
                                             ,ATTRIBUTE74
                                             ,ATTRIBUTE75
                                             ,ATTRIBUTE76
                                             ,ATTRIBUTE77
                                             ,ATTRIBUTE78
                                             ,ATTRIBUTE79
                                             ,ATTRIBUTE80
                                             ,ATTRIBUTE81
                                             ,ATTRIBUTE82
                                             ,ATTRIBUTE83
                                             ,ATTRIBUTE84
                                             ,ATTRIBUTE85
                                             ,ATTRIBUTE86
                                             ,ATTRIBUTE87
                                             ,ATTRIBUTE88
                                             ,ATTRIBUTE89
                                             ,ATTRIBUTE90
                                             ,ATTRIBUTE91
                                             ,ATTRIBUTE92
                                             ,ATTRIBUTE93
                                             ,ATTRIBUTE94
                                             ,ATTRIBUTE95
                                             ,ATTRIBUTE96
                                             ,ATTRIBUTE97
                                             ,ATTRIBUTE98
                                             ,ATTRIBUTE99
                                             ,ATTRIBUTE100
                                             ,ATTRIBUTE101
                                             ,ATTRIBUTE102
                                             ,ATTRIBUTE103
                                             ,ATTRIBUTE104
                                             ,ATTRIBUTE105
                                             ,ATTRIBUTE106
                                             ,ATTRIBUTE107
                                             ,ATTRIBUTE108
                                             ,ATTRIBUTE109
                                             ,ATTRIBUTE110
                                             ,ATTRIBUTE111
                                             ,ATTRIBUTE112
                                             ,ATTRIBUTE113
                                             ,ATTRIBUTE114
                                             ,ATTRIBUTE115
                                             ,ATTRIBUTE116
                                             ,ATTRIBUTE117
                                             ,ATTRIBUTE118
                                             ,ATTRIBUTE119
                                             ,ATTRIBUTE120
                                             ,ATTRIBUTE121
                                             ,ATTRIBUTE122
                                             ,ATTRIBUTE123
                                             ,ATTRIBUTE124
                                             ,ATTRIBUTE125
                                             ,ATTRIBUTE126
                                             ,ATTRIBUTE127
                                             ,ATTRIBUTE128
                                             ,ATTRIBUTE129
                                             ,ATTRIBUTE130
                                             ,ATTRIBUTE131
                                             ,ATTRIBUTE132
                                             ,ATTRIBUTE133
                                             ,ATTRIBUTE134
                                             ,ATTRIBUTE135
                                             ,ATTRIBUTE136
                                             ,ATTRIBUTE137
                                             ,ATTRIBUTE138
                                             ,ATTRIBUTE139
                                             ,ATTRIBUTE140
                                             ,ATTRIBUTE141
                                             ,ATTRIBUTE142
                                             ,ATTRIBUTE143
                                             ,ATTRIBUTE144
                                             ,ATTRIBUTE145
                                             ,ATTRIBUTE146
                                             ,ATTRIBUTE147
                                             ,ATTRIBUTE148
                                             ,ATTRIBUTE149
                                             ,ATTRIBUTE150
                                             ,ATTRIBUTE151
                                             ,ATTRIBUTE152
                                             ,ATTRIBUTE153
                                             ,ATTRIBUTE154
                                             ,ATTRIBUTE155
                                             ,ATTRIBUTE156
                                             ,ATTRIBUTE157
                                             ,ATTRIBUTE158
                                             ,ATTRIBUTE159
                                             ,ATTRIBUTE160
                                             ,ATTRIBUTE161
                                             ,ATTRIBUTE162
                                             ,ATTRIBUTE163
                                             ,ATTRIBUTE164
                                             ,ATTRIBUTE165
                                             ,ATTRIBUTE166
                                             ,ATTRIBUTE167
                                             ,ATTRIBUTE168
                                             ,ATTRIBUTE169
                                             ,ATTRIBUTE170
                                             ,ATTRIBUTE171
                                             ,ATTRIBUTE172
                                             ,ATTRIBUTE173
                                             ,ATTRIBUTE174
                                             ,ATTRIBUTE175
                                             ,ATTRIBUTE176
                                             ,ATTRIBUTE177
                                             ,ATTRIBUTE178
                                             ,ATTRIBUTE179
                                             ,ATTRIBUTE180
                                             ,ATTRIBUTE181
                                             ,ATTRIBUTE182
                                             ,ATTRIBUTE183
                                             ,ATTRIBUTE184
                                             ,ATTRIBUTE185
                                             ,ATTRIBUTE186
                                             ,ATTRIBUTE187
                                             ,ATTRIBUTE188
                                             ,ATTRIBUTE189
                                             ,ATTRIBUTE190
                                             ,ATTRIBUTE191
                                             ,ATTRIBUTE192
                                             ,ATTRIBUTE193
                                             ,ATTRIBUTE194
                                             ,ATTRIBUTE195
                                             ,ATTRIBUTE196
                                             ,ATTRIBUTE197
                                             ,ATTRIBUTE198
                                             ,ATTRIBUTE199
                                             ,ATTRIBUTE200
                                       FROM   SCM_ADM_EXCEL_UPLOAD
                                       WHERE  1 = 1
                                       AND    PROGRAM_ID = V_PROGRAM_ID
                                       AND    SHEET_NAME = V_SHEET_NAME
                                       AND    CREATED_BY = P_CREATED_BY
                                       AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                       AND    UPLOAD_STATUS_CODE = 'UPLOAD') T UNPIVOT(VALUE FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                               ,ATTRIBUTE15
                                                                                                               ,ATTRIBUTE16
                                                                                                               ,ATTRIBUTE17
                                                                                                               ,ATTRIBUTE18
                                                                                                               ,ATTRIBUTE19
                                                                                                               ,ATTRIBUTE20
                                                                                                               ,ATTRIBUTE21
                                                                                                               ,ATTRIBUTE22
                                                                                                               ,ATTRIBUTE23
                                                                                                               ,ATTRIBUTE24
                                                                                                               ,ATTRIBUTE25
                                                                                                               ,ATTRIBUTE26
                                                                                                               ,ATTRIBUTE27
                                                                                                               ,ATTRIBUTE28
                                                                                                               ,ATTRIBUTE29
                                                                                                               ,ATTRIBUTE30
                                                                                                               ,ATTRIBUTE31
                                                                                                               ,ATTRIBUTE32
                                                                                                               ,ATTRIBUTE33
                                                                                                               ,ATTRIBUTE34
                                                                                                               ,ATTRIBUTE35
                                                                                                               ,ATTRIBUTE36
                                                                                                               ,ATTRIBUTE37
                                                                                                               ,ATTRIBUTE38
                                                                                                               ,ATTRIBUTE39
                                                                                                               ,ATTRIBUTE40
                                                                                                               ,ATTRIBUTE41
                                                                                                               ,ATTRIBUTE42
                                                                                                               ,ATTRIBUTE43
                                                                                                               ,ATTRIBUTE44
                                                                                                               ,ATTRIBUTE45
                                                                                                               ,ATTRIBUTE46
                                                                                                               ,ATTRIBUTE47
                                                                                                               ,ATTRIBUTE48
                                                                                                               ,ATTRIBUTE49
                                                                                                               ,ATTRIBUTE50
                                                                                                               ,ATTRIBUTE51
                                                                                                               ,ATTRIBUTE52
                                                                                                               ,ATTRIBUTE53
                                                                                                               ,ATTRIBUTE54
                                                                                                               ,ATTRIBUTE55
                                                                                                               ,ATTRIBUTE56
                                                                                                               ,ATTRIBUTE57
                                                                                                               ,ATTRIBUTE58
                                                                                                               ,ATTRIBUTE59
                                                                                                               ,ATTRIBUTE60
                                                                                                               ,ATTRIBUTE61
                                                                                                               ,ATTRIBUTE62
                                                                                                               ,ATTRIBUTE63
                                                                                                               ,ATTRIBUTE64
                                                                                                               ,ATTRIBUTE65
                                                                                                               ,ATTRIBUTE66
                                                                                                               ,ATTRIBUTE67
                                                                                                               ,ATTRIBUTE68
                                                                                                               ,ATTRIBUTE69
                                                                                                               ,ATTRIBUTE70
                                                                                                               ,ATTRIBUTE71
                                                                                                               ,ATTRIBUTE72
                                                                                                               ,ATTRIBUTE73
                                                                                                               ,ATTRIBUTE74
                                                                                                               ,ATTRIBUTE75
                                                                                                               ,ATTRIBUTE76
                                                                                                               ,ATTRIBUTE77
                                                                                                               ,ATTRIBUTE78
                                                                                                               ,ATTRIBUTE79
                                                                                                               ,ATTRIBUTE80
                                                                                                               ,ATTRIBUTE81
                                                                                                               ,ATTRIBUTE82
                                                                                                               ,ATTRIBUTE83
                                                                                                               ,ATTRIBUTE84
                                                                                                               ,ATTRIBUTE85
                                                                                                               ,ATTRIBUTE86
                                                                                                               ,ATTRIBUTE87
                                                                                                               ,ATTRIBUTE88
                                                                                                               ,ATTRIBUTE89
                                                                                                               ,ATTRIBUTE90
                                                                                                               ,ATTRIBUTE91
                                                                                                               ,ATTRIBUTE92
                                                                                                               ,ATTRIBUTE93
                                                                                                               ,ATTRIBUTE94
                                                                                                               ,ATTRIBUTE95
                                                                                                               ,ATTRIBUTE96
                                                                                                               ,ATTRIBUTE97
                                                                                                               ,ATTRIBUTE98
                                                                                                               ,ATTRIBUTE99
                                                                                                               ,ATTRIBUTE100
                                                                                                               ,ATTRIBUTE101
                                                                                                               ,ATTRIBUTE102
                                                                                                               ,ATTRIBUTE103
                                                                                                               ,ATTRIBUTE104
                                                                                                               ,ATTRIBUTE105
                                                                                                               ,ATTRIBUTE106
                                                                                                               ,ATTRIBUTE107
                                                                                                               ,ATTRIBUTE108
                                                                                                               ,ATTRIBUTE109
                                                                                                               ,ATTRIBUTE110
                                                                                                               ,ATTRIBUTE111
                                                                                                               ,ATTRIBUTE112
                                                                                                               ,ATTRIBUTE113
                                                                                                               ,ATTRIBUTE114
                                                                                                               ,ATTRIBUTE115
                                                                                                               ,ATTRIBUTE116
                                                                                                               ,ATTRIBUTE117
                                                                                                               ,ATTRIBUTE118
                                                                                                               ,ATTRIBUTE119
                                                                                                               ,ATTRIBUTE120
                                                                                                               ,ATTRIBUTE121
                                                                                                               ,ATTRIBUTE122
                                                                                                               ,ATTRIBUTE123
                                                                                                               ,ATTRIBUTE124
                                                                                                               ,ATTRIBUTE125
                                                                                                               ,ATTRIBUTE126
                                                                                                               ,ATTRIBUTE127
                                                                                                               ,ATTRIBUTE128
                                                                                                               ,ATTRIBUTE129
                                                                                                               ,ATTRIBUTE130
                                                                                                               ,ATTRIBUTE131
                                                                                                               ,ATTRIBUTE132
                                                                                                               ,ATTRIBUTE133
                                                                                                               ,ATTRIBUTE134
                                                                                                               ,ATTRIBUTE135
                                                                                                               ,ATTRIBUTE136
                                                                                                               ,ATTRIBUTE137
                                                                                                               ,ATTRIBUTE138
                                                                                                               ,ATTRIBUTE139
                                                                                                               ,ATTRIBUTE140
                                                                                                               ,ATTRIBUTE141
                                                                                                               ,ATTRIBUTE142
                                                                                                               ,ATTRIBUTE143
                                                                                                               ,ATTRIBUTE144
                                                                                                               ,ATTRIBUTE145
                                                                                                               ,ATTRIBUTE146
                                                                                                               ,ATTRIBUTE147
                                                                                                               ,ATTRIBUTE148
                                                                                                               ,ATTRIBUTE149
                                                                                                               ,ATTRIBUTE150
                                                                                                               ,ATTRIBUTE151
                                                                                                               ,ATTRIBUTE152
                                                                                                               ,ATTRIBUTE153
                                                                                                               ,ATTRIBUTE154
                                                                                                               ,ATTRIBUTE155
                                                                                                               ,ATTRIBUTE156
                                                                                                               ,ATTRIBUTE157
                                                                                                               ,ATTRIBUTE158
                                                                                                               ,ATTRIBUTE159
                                                                                                               ,ATTRIBUTE160
                                                                                                               ,ATTRIBUTE161
                                                                                                               ,ATTRIBUTE162
                                                                                                               ,ATTRIBUTE163
                                                                                                               ,ATTRIBUTE164
                                                                                                               ,ATTRIBUTE165
                                                                                                               ,ATTRIBUTE166
                                                                                                               ,ATTRIBUTE167
                                                                                                               ,ATTRIBUTE168
                                                                                                               ,ATTRIBUTE169
                                                                                                               ,ATTRIBUTE170
                                                                                                               ,ATTRIBUTE171
                                                                                                               ,ATTRIBUTE172
                                                                                                               ,ATTRIBUTE173
                                                                                                               ,ATTRIBUTE174
                                                                                                               ,ATTRIBUTE175
                                                                                                               ,ATTRIBUTE176
                                                                                                               ,ATTRIBUTE177
                                                                                                               ,ATTRIBUTE178
                                                                                                               ,ATTRIBUTE179
                                                                                                               ,ATTRIBUTE180
                                                                                                               ,ATTRIBUTE181
                                                                                                               ,ATTRIBUTE182
                                                                                                               ,ATTRIBUTE183
                                                                                                               ,ATTRIBUTE184
                                                                                                               ,ATTRIBUTE185
                                                                                                               ,ATTRIBUTE186
                                                                                                               ,ATTRIBUTE187
                                                                                                               ,ATTRIBUTE188
                                                                                                               ,ATTRIBUTE189
                                                                                                               ,ATTRIBUTE190
                                                                                                               ,ATTRIBUTE191
                                                                                                               ,ATTRIBUTE192
                                                                                                               ,ATTRIBUTE193
                                                                                                               ,ATTRIBUTE194
                                                                                                               ,ATTRIBUTE195
                                                                                                               ,ATTRIBUTE196
                                                                                                               ,ATTRIBUTE197
                                                                                                               ,ATTRIBUTE198
                                                                                                               ,ATTRIBUTE199
                                                                                                               ,ATTRIBUTE200)) X
                               WHERE  1 = 1
                               AND    LTRIM(RTRIM(VALUE)) IS NOT NULL
                               AND    VALUE != '0'
                               AND    VALUE IS NOT NULL
                               GROUP  BY UPLOAD_ID) B) SRC_UPD
                ON (A.UPLOAD_ID = SRC_UPD.UPLOAD_ID AND SRC_UPD.PRICE > 0)
                WHEN MATCHED THEN
                    UPDATE
                    SET    UPLOAD_STATUS_CODE = 'ERROR'
                          ,MESSAGE_TEXT       = 'This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. (e.g. a, b, c, 130.2, 50.4 …).';
            
            END;
            --소수점 체크
            BEGIN
            
                MERGE INTO SCM_ADM_EXCEL_UPLOAD A
                USING (SELECT *
                       FROM   (SELECT UPLOAD_ID
                                     ,SUM(CASE
                                              WHEN ROUND(TO_NUMBER(VALUE), 10) - FLOOR(ROUND(TO_NUMBER(VALUE), 10)) <> 0 THEN
                                               1
                                              ELSE
                                               0
                                          END) PRICE
                               FROM   (SELECT UPLOAD_ID
                                             ,ATTRIBUTE14
                                             ,ATTRIBUTE15
                                             ,ATTRIBUTE16
                                             ,ATTRIBUTE17
                                             ,ATTRIBUTE18
                                             ,ATTRIBUTE19
                                             ,ATTRIBUTE20
                                             ,ATTRIBUTE21
                                             ,ATTRIBUTE22
                                             ,ATTRIBUTE23
                                             ,ATTRIBUTE24
                                             ,ATTRIBUTE25
                                             ,ATTRIBUTE26
                                             ,ATTRIBUTE27
                                             ,ATTRIBUTE28
                                             ,ATTRIBUTE29
                                             ,ATTRIBUTE30
                                             ,ATTRIBUTE31
                                             ,ATTRIBUTE32
                                             ,ATTRIBUTE33
                                             ,ATTRIBUTE34
                                             ,ATTRIBUTE35
                                             ,ATTRIBUTE36
                                             ,ATTRIBUTE37
                                             ,ATTRIBUTE38
                                             ,ATTRIBUTE39
                                             ,ATTRIBUTE40
                                             ,ATTRIBUTE41
                                             ,ATTRIBUTE42
                                             ,ATTRIBUTE43
                                             ,ATTRIBUTE44
                                             ,ATTRIBUTE45
                                             ,ATTRIBUTE46
                                             ,ATTRIBUTE47
                                             ,ATTRIBUTE48
                                             ,ATTRIBUTE49
                                             ,ATTRIBUTE50
                                             ,ATTRIBUTE51
                                             ,ATTRIBUTE52
                                             ,ATTRIBUTE53
                                             ,ATTRIBUTE54
                                             ,ATTRIBUTE55
                                             ,ATTRIBUTE56
                                             ,ATTRIBUTE57
                                             ,ATTRIBUTE58
                                             ,ATTRIBUTE59
                                             ,ATTRIBUTE60
                                             ,ATTRIBUTE61
                                             ,ATTRIBUTE62
                                             ,ATTRIBUTE63
                                             ,ATTRIBUTE64
                                             ,ATTRIBUTE65
                                             ,ATTRIBUTE66
                                             ,ATTRIBUTE67
                                             ,ATTRIBUTE68
                                             ,ATTRIBUTE69
                                             ,ATTRIBUTE70
                                             ,ATTRIBUTE71
                                             ,ATTRIBUTE72
                                             ,ATTRIBUTE73
                                             ,ATTRIBUTE74
                                             ,ATTRIBUTE75
                                             ,ATTRIBUTE76
                                             ,ATTRIBUTE77
                                             ,ATTRIBUTE78
                                             ,ATTRIBUTE79
                                             ,ATTRIBUTE80
                                             ,ATTRIBUTE81
                                             ,ATTRIBUTE82
                                             ,ATTRIBUTE83
                                             ,ATTRIBUTE84
                                             ,ATTRIBUTE85
                                             ,ATTRIBUTE86
                                             ,ATTRIBUTE87
                                             ,ATTRIBUTE88
                                             ,ATTRIBUTE89
                                             ,ATTRIBUTE90
                                             ,ATTRIBUTE91
                                             ,ATTRIBUTE92
                                             ,ATTRIBUTE93
                                             ,ATTRIBUTE94
                                             ,ATTRIBUTE95
                                             ,ATTRIBUTE96
                                             ,ATTRIBUTE97
                                             ,ATTRIBUTE98
                                             ,ATTRIBUTE99
                                             ,ATTRIBUTE100
                                             ,ATTRIBUTE101
                                             ,ATTRIBUTE102
                                             ,ATTRIBUTE103
                                             ,ATTRIBUTE104
                                             ,ATTRIBUTE105
                                             ,ATTRIBUTE106
                                             ,ATTRIBUTE107
                                             ,ATTRIBUTE108
                                             ,ATTRIBUTE109
                                             ,ATTRIBUTE110
                                             ,ATTRIBUTE111
                                             ,ATTRIBUTE112
                                             ,ATTRIBUTE113
                                             ,ATTRIBUTE114
                                             ,ATTRIBUTE115
                                             ,ATTRIBUTE116
                                             ,ATTRIBUTE117
                                             ,ATTRIBUTE118
                                             ,ATTRIBUTE119
                                             ,ATTRIBUTE120
                                             ,ATTRIBUTE121
                                             ,ATTRIBUTE122
                                             ,ATTRIBUTE123
                                             ,ATTRIBUTE124
                                             ,ATTRIBUTE125
                                             ,ATTRIBUTE126
                                             ,ATTRIBUTE127
                                             ,ATTRIBUTE128
                                             ,ATTRIBUTE129
                                             ,ATTRIBUTE130
                                             ,ATTRIBUTE131
                                             ,ATTRIBUTE132
                                             ,ATTRIBUTE133
                                             ,ATTRIBUTE134
                                             ,ATTRIBUTE135
                                             ,ATTRIBUTE136
                                             ,ATTRIBUTE137
                                             ,ATTRIBUTE138
                                             ,ATTRIBUTE139
                                             ,ATTRIBUTE140
                                             ,ATTRIBUTE141
                                             ,ATTRIBUTE142
                                             ,ATTRIBUTE143
                                             ,ATTRIBUTE144
                                             ,ATTRIBUTE145
                                             ,ATTRIBUTE146
                                             ,ATTRIBUTE147
                                             ,ATTRIBUTE148
                                             ,ATTRIBUTE149
                                             ,ATTRIBUTE150
                                             ,ATTRIBUTE151
                                             ,ATTRIBUTE152
                                             ,ATTRIBUTE153
                                             ,ATTRIBUTE154
                                             ,ATTRIBUTE155
                                             ,ATTRIBUTE156
                                             ,ATTRIBUTE157
                                             ,ATTRIBUTE158
                                             ,ATTRIBUTE159
                                             ,ATTRIBUTE160
                                             ,ATTRIBUTE161
                                             ,ATTRIBUTE162
                                             ,ATTRIBUTE163
                                             ,ATTRIBUTE164
                                             ,ATTRIBUTE165
                                             ,ATTRIBUTE166
                                             ,ATTRIBUTE167
                                             ,ATTRIBUTE168
                                             ,ATTRIBUTE169
                                             ,ATTRIBUTE170
                                             ,ATTRIBUTE171
                                             ,ATTRIBUTE172
                                             ,ATTRIBUTE173
                                             ,ATTRIBUTE174
                                             ,ATTRIBUTE175
                                             ,ATTRIBUTE176
                                             ,ATTRIBUTE177
                                             ,ATTRIBUTE178
                                             ,ATTRIBUTE179
                                             ,ATTRIBUTE180
                                             ,ATTRIBUTE181
                                             ,ATTRIBUTE182
                                             ,ATTRIBUTE183
                                             ,ATTRIBUTE184
                                             ,ATTRIBUTE185
                                             ,ATTRIBUTE186
                                             ,ATTRIBUTE187
                                             ,ATTRIBUTE188
                                             ,ATTRIBUTE189
                                             ,ATTRIBUTE190
                                             ,ATTRIBUTE191
                                             ,ATTRIBUTE192
                                             ,ATTRIBUTE193
                                             ,ATTRIBUTE194
                                             ,ATTRIBUTE195
                                             ,ATTRIBUTE196
                                             ,ATTRIBUTE197
                                             ,ATTRIBUTE198
                                             ,ATTRIBUTE199
                                             ,ATTRIBUTE200
                                       FROM   SCM_ADM_EXCEL_UPLOAD
                                       WHERE  1 = 1
                                       AND    PROGRAM_ID = V_PROGRAM_ID
                                       AND    SHEET_NAME = V_SHEET_NAME
                                       AND    CREATED_BY = P_CREATED_BY
                                       AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                       AND    UPLOAD_STATUS_CODE = 'UPLOAD') T UNPIVOT(VALUE FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                               ,ATTRIBUTE15
                                                                                                               ,ATTRIBUTE16
                                                                                                               ,ATTRIBUTE17
                                                                                                               ,ATTRIBUTE18
                                                                                                               ,ATTRIBUTE19
                                                                                                               ,ATTRIBUTE20
                                                                                                               ,ATTRIBUTE21
                                                                                                               ,ATTRIBUTE22
                                                                                                               ,ATTRIBUTE23
                                                                                                               ,ATTRIBUTE24
                                                                                                               ,ATTRIBUTE25
                                                                                                               ,ATTRIBUTE26
                                                                                                               ,ATTRIBUTE27
                                                                                                               ,ATTRIBUTE28
                                                                                                               ,ATTRIBUTE29
                                                                                                               ,ATTRIBUTE30
                                                                                                               ,ATTRIBUTE31
                                                                                                               ,ATTRIBUTE32
                                                                                                               ,ATTRIBUTE33
                                                                                                               ,ATTRIBUTE34
                                                                                                               ,ATTRIBUTE35
                                                                                                               ,ATTRIBUTE36
                                                                                                               ,ATTRIBUTE37
                                                                                                               ,ATTRIBUTE38
                                                                                                               ,ATTRIBUTE39
                                                                                                               ,ATTRIBUTE40
                                                                                                               ,ATTRIBUTE41
                                                                                                               ,ATTRIBUTE42
                                                                                                               ,ATTRIBUTE43
                                                                                                               ,ATTRIBUTE44
                                                                                                               ,ATTRIBUTE45
                                                                                                               ,ATTRIBUTE46
                                                                                                               ,ATTRIBUTE47
                                                                                                               ,ATTRIBUTE48
                                                                                                               ,ATTRIBUTE49
                                                                                                               ,ATTRIBUTE50
                                                                                                               ,ATTRIBUTE51
                                                                                                               ,ATTRIBUTE52
                                                                                                               ,ATTRIBUTE53
                                                                                                               ,ATTRIBUTE54
                                                                                                               ,ATTRIBUTE55
                                                                                                               ,ATTRIBUTE56
                                                                                                               ,ATTRIBUTE57
                                                                                                               ,ATTRIBUTE58
                                                                                                               ,ATTRIBUTE59
                                                                                                               ,ATTRIBUTE60
                                                                                                               ,ATTRIBUTE61
                                                                                                               ,ATTRIBUTE62
                                                                                                               ,ATTRIBUTE63
                                                                                                               ,ATTRIBUTE64
                                                                                                               ,ATTRIBUTE65
                                                                                                               ,ATTRIBUTE66
                                                                                                               ,ATTRIBUTE67
                                                                                                               ,ATTRIBUTE68
                                                                                                               ,ATTRIBUTE69
                                                                                                               ,ATTRIBUTE70
                                                                                                               ,ATTRIBUTE71
                                                                                                               ,ATTRIBUTE72
                                                                                                               ,ATTRIBUTE73
                                                                                                               ,ATTRIBUTE74
                                                                                                               ,ATTRIBUTE75
                                                                                                               ,ATTRIBUTE76
                                                                                                               ,ATTRIBUTE77
                                                                                                               ,ATTRIBUTE78
                                                                                                               ,ATTRIBUTE79
                                                                                                               ,ATTRIBUTE80
                                                                                                               ,ATTRIBUTE81
                                                                                                               ,ATTRIBUTE82
                                                                                                               ,ATTRIBUTE83
                                                                                                               ,ATTRIBUTE84
                                                                                                               ,ATTRIBUTE85
                                                                                                               ,ATTRIBUTE86
                                                                                                               ,ATTRIBUTE87
                                                                                                               ,ATTRIBUTE88
                                                                                                               ,ATTRIBUTE89
                                                                                                               ,ATTRIBUTE90
                                                                                                               ,ATTRIBUTE91
                                                                                                               ,ATTRIBUTE92
                                                                                                               ,ATTRIBUTE93
                                                                                                               ,ATTRIBUTE94
                                                                                                               ,ATTRIBUTE95
                                                                                                               ,ATTRIBUTE96
                                                                                                               ,ATTRIBUTE97
                                                                                                               ,ATTRIBUTE98
                                                                                                               ,ATTRIBUTE99
                                                                                                               ,ATTRIBUTE100
                                                                                                               ,ATTRIBUTE101
                                                                                                               ,ATTRIBUTE102
                                                                                                               ,ATTRIBUTE103
                                                                                                               ,ATTRIBUTE104
                                                                                                               ,ATTRIBUTE105
                                                                                                               ,ATTRIBUTE106
                                                                                                               ,ATTRIBUTE107
                                                                                                               ,ATTRIBUTE108
                                                                                                               ,ATTRIBUTE109
                                                                                                               ,ATTRIBUTE110
                                                                                                               ,ATTRIBUTE111
                                                                                                               ,ATTRIBUTE112
                                                                                                               ,ATTRIBUTE113
                                                                                                               ,ATTRIBUTE114
                                                                                                               ,ATTRIBUTE115
                                                                                                               ,ATTRIBUTE116
                                                                                                               ,ATTRIBUTE117
                                                                                                               ,ATTRIBUTE118
                                                                                                               ,ATTRIBUTE119
                                                                                                               ,ATTRIBUTE120
                                                                                                               ,ATTRIBUTE121
                                                                                                               ,ATTRIBUTE122
                                                                                                               ,ATTRIBUTE123
                                                                                                               ,ATTRIBUTE124
                                                                                                               ,ATTRIBUTE125
                                                                                                               ,ATTRIBUTE126
                                                                                                               ,ATTRIBUTE127
                                                                                                               ,ATTRIBUTE128
                                                                                                               ,ATTRIBUTE129
                                                                                                               ,ATTRIBUTE130
                                                                                                               ,ATTRIBUTE131
                                                                                                               ,ATTRIBUTE132
                                                                                                               ,ATTRIBUTE133
                                                                                                               ,ATTRIBUTE134
                                                                                                               ,ATTRIBUTE135
                                                                                                               ,ATTRIBUTE136
                                                                                                               ,ATTRIBUTE137
                                                                                                               ,ATTRIBUTE138
                                                                                                               ,ATTRIBUTE139
                                                                                                               ,ATTRIBUTE140
                                                                                                               ,ATTRIBUTE141
                                                                                                               ,ATTRIBUTE142
                                                                                                               ,ATTRIBUTE143
                                                                                                               ,ATTRIBUTE144
                                                                                                               ,ATTRIBUTE145
                                                                                                               ,ATTRIBUTE146
                                                                                                               ,ATTRIBUTE147
                                                                                                               ,ATTRIBUTE148
                                                                                                               ,ATTRIBUTE149
                                                                                                               ,ATTRIBUTE150
                                                                                                               ,ATTRIBUTE151
                                                                                                               ,ATTRIBUTE152
                                                                                                               ,ATTRIBUTE153
                                                                                                               ,ATTRIBUTE154
                                                                                                               ,ATTRIBUTE155
                                                                                                               ,ATTRIBUTE156
                                                                                                               ,ATTRIBUTE157
                                                                                                               ,ATTRIBUTE158
                                                                                                               ,ATTRIBUTE159
                                                                                                               ,ATTRIBUTE160
                                                                                                               ,ATTRIBUTE161
                                                                                                               ,ATTRIBUTE162
                                                                                                               ,ATTRIBUTE163
                                                                                                               ,ATTRIBUTE164
                                                                                                               ,ATTRIBUTE165
                                                                                                               ,ATTRIBUTE166
                                                                                                               ,ATTRIBUTE167
                                                                                                               ,ATTRIBUTE168
                                                                                                               ,ATTRIBUTE169
                                                                                                               ,ATTRIBUTE170
                                                                                                               ,ATTRIBUTE171
                                                                                                               ,ATTRIBUTE172
                                                                                                               ,ATTRIBUTE173
                                                                                                               ,ATTRIBUTE174
                                                                                                               ,ATTRIBUTE175
                                                                                                               ,ATTRIBUTE176
                                                                                                               ,ATTRIBUTE177
                                                                                                               ,ATTRIBUTE178
                                                                                                               ,ATTRIBUTE179
                                                                                                               ,ATTRIBUTE180
                                                                                                               ,ATTRIBUTE181
                                                                                                               ,ATTRIBUTE182
                                                                                                               ,ATTRIBUTE183
                                                                                                               ,ATTRIBUTE184
                                                                                                               ,ATTRIBUTE185
                                                                                                               ,ATTRIBUTE186
                                                                                                               ,ATTRIBUTE187
                                                                                                               ,ATTRIBUTE188
                                                                                                               ,ATTRIBUTE189
                                                                                                               ,ATTRIBUTE190
                                                                                                               ,ATTRIBUTE191
                                                                                                               ,ATTRIBUTE192
                                                                                                               ,ATTRIBUTE193
                                                                                                               ,ATTRIBUTE194
                                                                                                               ,ATTRIBUTE195
                                                                                                               ,ATTRIBUTE196
                                                                                                               ,ATTRIBUTE197
                                                                                                               ,ATTRIBUTE198
                                                                                                               ,ATTRIBUTE199
                                                                                                               ,ATTRIBUTE200)) X
                               WHERE  1 = 1
                               AND    LTRIM(RTRIM(VALUE)) IS NOT NULL
                               AND    VALUE != '0'
                               AND    VALUE IS NOT NULL
                               GROUP  BY UPLOAD_ID) B) SRC_UPD
                ON (A.UPLOAD_ID = SRC_UPD.UPLOAD_ID AND SRC_UPD.PRICE > 0)
                WHEN MATCHED THEN
                    UPDATE
                    SET    UPLOAD_STATUS_CODE = 'ERROR'
                          ,MESSAGE_TEXT       = 'This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. (e.g. a, b, c, 130.2, 50.4 …).';
            
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '13';
                V_LOG_MESSAGE := '########## Invalid Measure Group. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Upload UOM.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11
                        AND    L.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE'
                        AND    L.VALID_YN = 'Y');
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '14';
                V_LOG_MESSAGE := '########## Invalid Upload UOM. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            -- Upload UOM by Model
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Upload UOM Costpmer FCST.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST CF, SCM_MST_DIVISION D2
                        WHERE  CF.DIVISION_ID = D2.DIVISION_ID
                        AND    CF.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    CF.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    CF.VALID_YN = 'Y');
            
            END;
        
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '15';
                V_LOG_MESSAGE := '########## Invalid Upload UOM Costpmer FCST. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
        
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Project.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                            AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                            AND    CM.VALID_YN              = 'Y');
            END;
            
            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
            v_log_type := '16';
            v_log_message := '########## Invalid Project. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Model.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                            AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                            AND    CM.ITEM_ID               = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13
                            AND    CM.VALID_YN              = 'Y');
            END;
            
            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Model ', SQL%ROWCOUNT, 10, TRUE);
            v_log_type := '17';
            v_log_message := '########## Invalid Model. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'SUCCESS'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD';
            END;
        
            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '16';
                V_LOG_MESSAGE := '########## SUCCESS ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
        
        END IF;
    
        BEGIN
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '17';
            V_LOG_MESSAGE := '########## INSERT INTO DATA START ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------
        END;
    
        --// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
        --//======================================================================================
        SELECT COUNT(1)
        INTO   V_COUNT
        FROM   SCM_ADM_EXCEL_UPLOAD T
        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
        AND    T.SHEET_NAME = V_SHEET_NAME
        AND    T.CREATED_BY = P_CREATED_BY
        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
        AND    T.UPLOAD_STATUS_CODE = 'ERROR';
    
        DBMS_OUTPUT.PUT_LINE('■■■■■ Start1 v_count: ' || TO_CHAR(V_COUNT)); --20240604 SM
    
        -- Update Mode and No Errors
        IF P_MODE > 0 AND V_COUNT = 0 THEN
            BEGIN
                V_START_YYYYMMDD := NULL;
                V_END_YYYYMMDD   := NULL;
            END;
        
            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '18';
                V_LOG_MESSAGE := '########## DELETE FROM DATE START ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
        
            BEGIN
                SELECT D.MIN_YYYYMMDD, D.MAX_YYYYMMDD
                INTO   V_START_YYYYMMDD, V_END_YYYYMMDD
                FROM   (SELECT MIN(YYYYMMDD) MIN_YYYYMMDD, MAX(YYYYMMDD) MAX_YYYYMMDD
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'V_TITLE') T UNPIVOT(YYYYMMDD FOR COLUMN_NAME IN( --ATTRIBUTE12, ATTRIBUTE13,   --20240605 sm (일자셋팅이 14부터 시작이라 14부터로 처리되도록 수정)
                                                                                                             ATTRIBUTE14
                                                                                                            ,ATTRIBUTE15
                                                                                                            ,ATTRIBUTE16
                                                                                                            ,ATTRIBUTE17
                                                                                                            ,ATTRIBUTE18
                                                                                                            ,ATTRIBUTE19
                                                                                                            ,ATTRIBUTE20
                                                                                                            ,ATTRIBUTE21
                                                                                                            ,ATTRIBUTE22
                                                                                                            ,ATTRIBUTE23
                                                                                                            ,ATTRIBUTE24
                                                                                                            ,ATTRIBUTE25
                                                                                                            ,ATTRIBUTE26
                                                                                                            ,ATTRIBUTE27
                                                                                                            ,ATTRIBUTE28
                                                                                                            ,ATTRIBUTE29
                                                                                                            ,ATTRIBUTE30
                                                                                                            ,ATTRIBUTE31
                                                                                                            ,ATTRIBUTE32
                                                                                                            ,ATTRIBUTE33
                                                                                                            ,ATTRIBUTE34
                                                                                                            ,ATTRIBUTE35
                                                                                                            ,ATTRIBUTE36
                                                                                                            ,ATTRIBUTE37
                                                                                                            ,ATTRIBUTE38
                                                                                                            ,ATTRIBUTE39
                                                                                                            ,ATTRIBUTE40
                                                                                                            ,ATTRIBUTE41
                                                                                                            ,ATTRIBUTE42
                                                                                                            ,ATTRIBUTE43
                                                                                                            ,ATTRIBUTE44
                                                                                                            ,ATTRIBUTE45
                                                                                                            ,ATTRIBUTE46
                                                                                                            ,ATTRIBUTE47
                                                                                                            ,ATTRIBUTE48
                                                                                                            ,ATTRIBUTE49
                                                                                                            ,ATTRIBUTE50
                                                                                                            ,ATTRIBUTE51
                                                                                                            ,ATTRIBUTE52
                                                                                                            ,ATTRIBUTE53
                                                                                                            ,ATTRIBUTE54
                                                                                                            ,ATTRIBUTE55
                                                                                                            ,ATTRIBUTE56
                                                                                                            ,ATTRIBUTE57
                                                                                                            ,ATTRIBUTE58
                                                                                                            ,ATTRIBUTE59
                                                                                                            ,ATTRIBUTE60
                                                                                                            ,ATTRIBUTE61
                                                                                                            ,ATTRIBUTE62
                                                                                                            ,ATTRIBUTE63
                                                                                                            ,ATTRIBUTE64
                                                                                                            ,ATTRIBUTE65
                                                                                                            ,ATTRIBUTE66
                                                                                                            ,ATTRIBUTE67
                                                                                                            ,ATTRIBUTE68
                                                                                                            ,ATTRIBUTE69
                                                                                                            ,ATTRIBUTE70
                                                                                                            ,ATTRIBUTE71
                                                                                                            ,ATTRIBUTE72
                                                                                                            ,ATTRIBUTE73
                                                                                                            ,ATTRIBUTE74
                                                                                                            ,ATTRIBUTE75
                                                                                                            ,ATTRIBUTE76
                                                                                                            ,ATTRIBUTE77
                                                                                                            ,ATTRIBUTE78
                                                                                                            ,ATTRIBUTE79
                                                                                                            ,ATTRIBUTE80
                                                                                                            ,ATTRIBUTE81
                                                                                                            ,ATTRIBUTE82
                                                                                                            ,ATTRIBUTE83
                                                                                                            ,ATTRIBUTE84
                                                                                                            ,ATTRIBUTE85
                                                                                                            ,ATTRIBUTE86
                                                                                                            ,ATTRIBUTE87
                                                                                                            ,ATTRIBUTE88
                                                                                                            ,ATTRIBUTE89
                                                                                                            ,ATTRIBUTE90
                                                                                                            ,ATTRIBUTE91
                                                                                                            ,ATTRIBUTE92
                                                                                                            ,ATTRIBUTE93
                                                                                                            ,ATTRIBUTE94
                                                                                                            ,ATTRIBUTE95
                                                                                                            ,ATTRIBUTE96
                                                                                                            ,ATTRIBUTE97
                                                                                                            ,ATTRIBUTE98
                                                                                                            ,ATTRIBUTE99
                                                                                                            ,ATTRIBUTE100
                                                                                                            ,ATTRIBUTE101
                                                                                                            ,ATTRIBUTE102
                                                                                                            ,ATTRIBUTE103
                                                                                                            ,ATTRIBUTE104
                                                                                                            ,ATTRIBUTE105
                                                                                                            ,ATTRIBUTE106
                                                                                                            ,ATTRIBUTE107
                                                                                                            ,ATTRIBUTE108
                                                                                                            ,ATTRIBUTE109
                                                                                                            ,ATTRIBUTE110
                                                                                                            ,ATTRIBUTE111
                                                                                                            ,ATTRIBUTE112
                                                                                                            ,ATTRIBUTE113
                                                                                                            ,ATTRIBUTE114
                                                                                                            ,ATTRIBUTE115
                                                                                                            ,ATTRIBUTE116
                                                                                                            ,ATTRIBUTE117
                                                                                                            ,ATTRIBUTE118
                                                                                                            ,ATTRIBUTE119
                                                                                                            ,ATTRIBUTE120
                                                                                                            ,ATTRIBUTE121
                                                                                                            ,ATTRIBUTE122
                                                                                                            ,ATTRIBUTE123
                                                                                                            ,ATTRIBUTE124
                                                                                                            ,ATTRIBUTE125
                                                                                                            ,ATTRIBUTE126
                                                                                                            ,ATTRIBUTE127
                                                                                                            ,ATTRIBUTE128
                                                                                                            ,ATTRIBUTE129
                                                                                                            ,ATTRIBUTE130
                                                                                                            ,ATTRIBUTE131
                                                                                                            ,ATTRIBUTE132
                                                                                                            ,ATTRIBUTE133
                                                                                                            ,ATTRIBUTE134
                                                                                                            ,ATTRIBUTE135
                                                                                                            ,ATTRIBUTE136
                                                                                                            ,ATTRIBUTE137
                                                                                                            ,ATTRIBUTE138
                                                                                                            ,ATTRIBUTE139
                                                                                                            ,ATTRIBUTE140
                                                                                                            ,ATTRIBUTE141
                                                                                                            ,ATTRIBUTE142
                                                                                                            ,ATTRIBUTE143
                                                                                                            ,ATTRIBUTE144
                                                                                                            ,ATTRIBUTE145
                                                                                                            ,ATTRIBUTE146
                                                                                                            ,ATTRIBUTE147
                                                                                                            ,ATTRIBUTE148
                                                                                                            ,ATTRIBUTE149
                                                                                                            ,ATTRIBUTE150
                                                                                                            ,ATTRIBUTE151
                                                                                                            ,ATTRIBUTE152
                                                                                                            ,ATTRIBUTE153
                                                                                                            ,ATTRIBUTE154
                                                                                                            ,ATTRIBUTE155
                                                                                                            ,ATTRIBUTE156
                                                                                                            ,ATTRIBUTE157
                                                                                                            ,ATTRIBUTE158
                                                                                                            ,ATTRIBUTE159
                                                                                                            ,ATTRIBUTE160
                                                                                                            ,ATTRIBUTE161
                                                                                                            ,ATTRIBUTE162
                                                                                                            ,ATTRIBUTE163
                                                                                                            ,ATTRIBUTE164
                                                                                                            ,ATTRIBUTE165
                                                                                                            ,ATTRIBUTE166
                                                                                                            ,ATTRIBUTE167
                                                                                                            ,ATTRIBUTE168
                                                                                                            ,ATTRIBUTE169
                                                                                                            ,ATTRIBUTE170
                                                                                                            ,ATTRIBUTE171
                                                                                                            ,ATTRIBUTE172
                                                                                                            ,ATTRIBUTE173
                                                                                                            ,ATTRIBUTE174
                                                                                                            ,ATTRIBUTE175
                                                                                                            ,ATTRIBUTE176
                                                                                                            ,ATTRIBUTE177
                                                                                                            ,ATTRIBUTE178
                                                                                                            ,ATTRIBUTE179
                                                                                                            ,ATTRIBUTE180
                                                                                                            ,ATTRIBUTE181
                                                                                                            ,ATTRIBUTE182
                                                                                                            ,ATTRIBUTE183
                                                                                                            ,ATTRIBUTE184
                                                                                                            ,ATTRIBUTE185
                                                                                                            ,ATTRIBUTE186
                                                                                                            ,ATTRIBUTE187
                                                                                                            ,ATTRIBUTE188
                                                                                                            ,ATTRIBUTE189
                                                                                                            ,ATTRIBUTE190
                                                                                                            ,ATTRIBUTE191
                                                                                                            ,ATTRIBUTE192
                                                                                                            ,ATTRIBUTE193
                                                                                                            ,ATTRIBUTE194
                                                                                                            ,ATTRIBUTE195
                                                                                                            ,ATTRIBUTE196
                                                                                                            ,ATTRIBUTE197
                                                                                                            ,ATTRIBUTE198
                                                                                                            ,ATTRIBUTE199
                                                                                                            ,ATTRIBUTE200)) X
                        WHERE  X.YYYYMMDD IS NOT NULL) D;
            END;
        
            BEGIN
            
                DBMS_OUTPUT.PUT_LINE('■■■■■v_start_yyyymmdd: ' || V_START_YYYYMMDD);
                DBMS_OUTPUT.PUT_LINE('■■■■■v_end_yyyymmdd:   ' || V_END_YYYYMMDD);
            
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '19-1';
                V_LOG_MESSAGE := '########## DELETE FROM DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
        
            -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
            BEGIN
            
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '20-1';
                V_LOG_MESSAGE := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
                DELETE FROM DM_PLN_CUSTOMER_PSI
                WHERE  1 = 1
                AND    MEASURE_GROUP = 'CUST_FCST'
                      -- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
                AND    (SELECT COUNT(1)
                        FROM   SCM_ADM_EXCEL_UPLOAD T
                        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
                        AND    T.SHEET_NAME = V_SHEET_NAME
                        AND    T.CREATED_BY = P_CREATED_BY
                        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                        AND    T.UPLOAD_STATUS_CODE = 'SUCCESS'
                        AND    DM_PLN_CUSTOMER_PSI.DIVISION_ID = T.ATTRIBUTE1
                        AND    DM_PLN_CUSTOMER_PSI.SCM_SITE_ID = T.ATTRIBUTE2
                        AND    DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID = T.ATTRIBUTE3
                        AND    DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE = T.ATTRIBUTE4
                        AND    DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL = T.ATTRIBUTE5
                        AND    DM_PLN_CUSTOMER_PSI.INCOTERMS = T.ATTRIBUTE6
                        AND    DM_PLN_CUSTOMER_PSI.FCST_TYPE = T.ATTRIBUTE7
                        AND    DM_PLN_CUSTOMER_PSI.DOM_EXP = T.ATTRIBUTE8
                        AND    DM_PLN_CUSTOMER_PSI.MEASURE = T.ATTRIBUTE10) > 0
                AND    YYYYMMDD BETWEEN V_START_YYYYMMDD AND V_END_YYYYMMDD;
            
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '20';
                V_LOG_MESSAGE := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
            DBMS_OUTPUT.PUT_LINE('20');
        
            -- 엑셀로 업로드된 MEASURE를 MASTER의 MEASURE로 변경
            UPDATE SCM_ADM_EXCEL_UPLOAD AA
            SET    ATTRIBUTE10 =
                   (SELECT BB.MEASURE
                    FROM   (SELECT DISTINCT A.DIVISION_ID, B.DIVISION_NAME, A.SCM_SITE_ID, A.VALID_YN, A.MEASURE, A.UPLOAD_UOM, A.UPLOAD_BUCKET_TYPE
                            FROM   DM_MST_CUSTOMER_FCST A
                            INNER  JOIN SCM_MST_DIVISION B
                            ON     A.VALID_YN = 'Y'
                            AND    A.DIVISION_ID = B.DIVISION_ID) BB
                    WHERE  (BB.DIVISION_ID = AA.ATTRIBUTE1 OR BB.DIVISION_NAME = AA.ATTRIBUTE1)
                    AND    BB.SCM_SITE_ID = AA.ATTRIBUTE2
                    AND    BB.MEASURE = AA.ATTRIBUTE10
                    AND    BB.UPLOAD_UOM = AA.ATTRIBUTE11
                    AND    BB.UPLOAD_BUCKET_TYPE IN (SELECT CASE (TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14, 'YYYYMMDD'))
                                                                WHEN 1 THEN
                                                                 'DAILY'
                                                                WHEN 7 THEN
                                                                 'WEEKLY'
                                                                ELSE
                                                                 'MONTHLY'
                                                            END
                                                     FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                     WHERE  Z.PROGRAM_ID = V_PROGRAM_ID
                                                     AND    Z.SHEET_NAME = V_SHEET_NAME
                                                     AND    Z.CREATED_BY = P_CREATED_BY
                                                     AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                                     AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE')
                    FETCH  FIRST 1 ROWS ONLY)
            WHERE  AA.PROGRAM_ID = V_PROGRAM_ID
            AND    AA.SHEET_NAME = V_SHEET_NAME
            AND    AA.CREATED_BY = P_CREATED_BY
            AND    AA.UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    TO_CHAR(AA.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    EXISTS (SELECT 1
                    FROM   (SELECT DISTINCT A.DIVISION_ID, B.DIVISION_NAME, A.SCM_SITE_ID, A.MEASURE, A.UPLOAD_UOM, A.UPLOAD_BUCKET_TYPE
                            FROM   DM_MST_CUSTOMER_FCST A
                            INNER  JOIN SCM_MST_DIVISION B
                            ON     A.VALID_YN = 'Y'
                            AND    A.DIVISION_ID = B.DIVISION_ID) BB
                    WHERE  (BB.DIVISION_ID = AA.ATTRIBUTE1 OR BB.DIVISION_NAME = AA.ATTRIBUTE1)
                    AND    BB.SCM_SITE_ID = AA.ATTRIBUTE2
                    AND    BB.MEASURE = AA.ATTRIBUTE10
                    AND    BB.UPLOAD_UOM = AA.ATTRIBUTE11);
        
            DBMS_OUTPUT.PUT_LINE('20240605-21');
        
            INSERT INTO DM_PLN_CUSTOMER_PSI
                (DIVISION_ID
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,CUSTOMER_PROJECT_CODE
                ,CUSTOMER_MODEL
                ,INCOTERMS
                ,FCST_TYPE
                ,DOM_EXP
                ,MEASURE_GROUP
                ,MEASURE
                ,UPLOAD_UOM
                ,PROJECT_CODE
                ,ITEM_ID
                ,YYYYMMDD
                ,QTY
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                ,BATCH_RESULT)
                SELECT V.ATTRIBUTE1
                      ,V.ATTRIBUTE2
                      ,V.ATTRIBUTE3
                      ,V.ATTRIBUTE4
                      ,V.ATTRIBUTE5
                      ,V.ATTRIBUTE6
                      ,V.ATTRIBUTE7
                      ,V.ATTRIBUTE8
                      ,V.ATTRIBUTE9
                      ,V.ATTRIBUTE10
                      ,V.ATTRIBUTE11
                      ,V.ATTRIBUTE12
                      ,V.ATTRIBUTE13
                      ,C.YYYYMMDD
                      ,TO_NUMBER(V.VALUE)
                      ,P_CREATED_BY
                      ,TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
                      ,P_CREATED_BY
                      ,TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
                      ,'UI'
                FROM   (SELECT ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10
                              ,ATTRIBUTE11
                              ,ATTRIBUTE12
                              ,ATTRIBUTE13
                              ,COLUMN_NAME
                              ,YYYYMMDD
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                      -- modified by ytchoi 180305
                                      -- AND    CREATION_DATE = v_creation_date
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'V_TITLE') T UNPIVOT(YYYYMMDD FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                            ,ATTRIBUTE15
                                                                                                            ,ATTRIBUTE16
                                                                                                            ,ATTRIBUTE17
                                                                                                            ,ATTRIBUTE18
                                                                                                            ,ATTRIBUTE19
                                                                                                            ,ATTRIBUTE20
                                                                                                            ,ATTRIBUTE21
                                                                                                            ,ATTRIBUTE22
                                                                                                            ,ATTRIBUTE23
                                                                                                            ,ATTRIBUTE24
                                                                                                            ,ATTRIBUTE25
                                                                                                            ,ATTRIBUTE26
                                                                                                            ,ATTRIBUTE27
                                                                                                            ,ATTRIBUTE28
                                                                                                            ,ATTRIBUTE29
                                                                                                            ,ATTRIBUTE30
                                                                                                            ,ATTRIBUTE31
                                                                                                            ,ATTRIBUTE32
                                                                                                            ,ATTRIBUTE33
                                                                                                            ,ATTRIBUTE34
                                                                                                            ,ATTRIBUTE35
                                                                                                            ,ATTRIBUTE36
                                                                                                            ,ATTRIBUTE37
                                                                                                            ,ATTRIBUTE38
                                                                                                            ,ATTRIBUTE39
                                                                                                            ,ATTRIBUTE40
                                                                                                            ,ATTRIBUTE41
                                                                                                            ,ATTRIBUTE42
                                                                                                            ,ATTRIBUTE43
                                                                                                            ,ATTRIBUTE44
                                                                                                            ,ATTRIBUTE45
                                                                                                            ,ATTRIBUTE46
                                                                                                            ,ATTRIBUTE47
                                                                                                            ,ATTRIBUTE48
                                                                                                            ,ATTRIBUTE49
                                                                                                            ,ATTRIBUTE50
                                                                                                            ,ATTRIBUTE51
                                                                                                            ,ATTRIBUTE52
                                                                                                            ,ATTRIBUTE53
                                                                                                            ,ATTRIBUTE54
                                                                                                            ,ATTRIBUTE55
                                                                                                            ,ATTRIBUTE56
                                                                                                            ,ATTRIBUTE57
                                                                                                            ,ATTRIBUTE58
                                                                                                            ,ATTRIBUTE59
                                                                                                            ,ATTRIBUTE60
                                                                                                            ,ATTRIBUTE61
                                                                                                            ,ATTRIBUTE62
                                                                                                            ,ATTRIBUTE63
                                                                                                            ,ATTRIBUTE64
                                                                                                            ,ATTRIBUTE65
                                                                                                            ,ATTRIBUTE66
                                                                                                            ,ATTRIBUTE67
                                                                                                            ,ATTRIBUTE68
                                                                                                            ,ATTRIBUTE69
                                                                                                            ,ATTRIBUTE70
                                                                                                            ,ATTRIBUTE71
                                                                                                            ,ATTRIBUTE72
                                                                                                            ,ATTRIBUTE73
                                                                                                            ,ATTRIBUTE74
                                                                                                            ,ATTRIBUTE75
                                                                                                            ,ATTRIBUTE76
                                                                                                            ,ATTRIBUTE77
                                                                                                            ,ATTRIBUTE78
                                                                                                            ,ATTRIBUTE79
                                                                                                            ,ATTRIBUTE80
                                                                                                            ,ATTRIBUTE81
                                                                                                            ,ATTRIBUTE82
                                                                                                            ,ATTRIBUTE83
                                                                                                            ,ATTRIBUTE84
                                                                                                            ,ATTRIBUTE85
                                                                                                            ,ATTRIBUTE86
                                                                                                            ,ATTRIBUTE87
                                                                                                            ,ATTRIBUTE88
                                                                                                            ,ATTRIBUTE89
                                                                                                            ,ATTRIBUTE90
                                                                                                            ,ATTRIBUTE91
                                                                                                            ,ATTRIBUTE92
                                                                                                            ,ATTRIBUTE93
                                                                                                            ,ATTRIBUTE94
                                                                                                            ,ATTRIBUTE95
                                                                                                            ,ATTRIBUTE96
                                                                                                            ,ATTRIBUTE97
                                                                                                            ,ATTRIBUTE98
                                                                                                            ,ATTRIBUTE99
                                                                                                            ,ATTRIBUTE100
                                                                                                            ,ATTRIBUTE101
                                                                                                            ,ATTRIBUTE102
                                                                                                            ,ATTRIBUTE103
                                                                                                            ,ATTRIBUTE104
                                                                                                            ,ATTRIBUTE105
                                                                                                            ,ATTRIBUTE106
                                                                                                            ,ATTRIBUTE107
                                                                                                            ,ATTRIBUTE108
                                                                                                            ,ATTRIBUTE109
                                                                                                            ,ATTRIBUTE110
                                                                                                            ,ATTRIBUTE111
                                                                                                            ,ATTRIBUTE112
                                                                                                            ,ATTRIBUTE113
                                                                                                            ,ATTRIBUTE114
                                                                                                            ,ATTRIBUTE115
                                                                                                            ,ATTRIBUTE116
                                                                                                            ,ATTRIBUTE117
                                                                                                            ,ATTRIBUTE118
                                                                                                            ,ATTRIBUTE119
                                                                                                            ,ATTRIBUTE120
                                                                                                            ,ATTRIBUTE121
                                                                                                            ,ATTRIBUTE122
                                                                                                            ,ATTRIBUTE123
                                                                                                            ,ATTRIBUTE124
                                                                                                            ,ATTRIBUTE125
                                                                                                            ,ATTRIBUTE126
                                                                                                            ,ATTRIBUTE127
                                                                                                            ,ATTRIBUTE128
                                                                                                            ,ATTRIBUTE129
                                                                                                            ,ATTRIBUTE130
                                                                                                            ,ATTRIBUTE131
                                                                                                            ,ATTRIBUTE132
                                                                                                            ,ATTRIBUTE133
                                                                                                            ,ATTRIBUTE134
                                                                                                            ,ATTRIBUTE135
                                                                                                            ,ATTRIBUTE136
                                                                                                            ,ATTRIBUTE137
                                                                                                            ,ATTRIBUTE138
                                                                                                            ,ATTRIBUTE139
                                                                                                            ,ATTRIBUTE140
                                                                                                            ,ATTRIBUTE141
                                                                                                            ,ATTRIBUTE142
                                                                                                            ,ATTRIBUTE143
                                                                                                            ,ATTRIBUTE144
                                                                                                            ,ATTRIBUTE145
                                                                                                            ,ATTRIBUTE146
                                                                                                            ,ATTRIBUTE147
                                                                                                            ,ATTRIBUTE148
                                                                                                            ,ATTRIBUTE149
                                                                                                            ,ATTRIBUTE150
                                                                                                            ,ATTRIBUTE151
                                                                                                            ,ATTRIBUTE152
                                                                                                            ,ATTRIBUTE153
                                                                                                            ,ATTRIBUTE154
                                                                                                            ,ATTRIBUTE155
                                                                                                            ,ATTRIBUTE156
                                                                                                            ,ATTRIBUTE157
                                                                                                            ,ATTRIBUTE158
                                                                                                            ,ATTRIBUTE159
                                                                                                            ,ATTRIBUTE160
                                                                                                            ,ATTRIBUTE161
                                                                                                            ,ATTRIBUTE162
                                                                                                            ,ATTRIBUTE163
                                                                                                            ,ATTRIBUTE164
                                                                                                            ,ATTRIBUTE165
                                                                                                            ,ATTRIBUTE166
                                                                                                            ,ATTRIBUTE167
                                                                                                            ,ATTRIBUTE168
                                                                                                            ,ATTRIBUTE169
                                                                                                            ,ATTRIBUTE170
                                                                                                            ,ATTRIBUTE171
                                                                                                            ,ATTRIBUTE172
                                                                                                            ,ATTRIBUTE173
                                                                                                            ,ATTRIBUTE174
                                                                                                            ,ATTRIBUTE175
                                                                                                            ,ATTRIBUTE176
                                                                                                            ,ATTRIBUTE177
                                                                                                            ,ATTRIBUTE178
                                                                                                            ,ATTRIBUTE179
                                                                                                            ,ATTRIBUTE180
                                                                                                            ,ATTRIBUTE181
                                                                                                            ,ATTRIBUTE182
                                                                                                            ,ATTRIBUTE183
                                                                                                            ,ATTRIBUTE184
                                                                                                            ,ATTRIBUTE185
                                                                                                            ,ATTRIBUTE186
                                                                                                            ,ATTRIBUTE187
                                                                                                            ,ATTRIBUTE188
                                                                                                            ,ATTRIBUTE189
                                                                                                            ,ATTRIBUTE190
                                                                                                            ,ATTRIBUTE191
                                                                                                            ,ATTRIBUTE192
                                                                                                            ,ATTRIBUTE193
                                                                                                            ,ATTRIBUTE194
                                                                                                            ,ATTRIBUTE195
                                                                                                            ,ATTRIBUTE196
                                                                                                            ,ATTRIBUTE197
                                                                                                            ,ATTRIBUTE198
                                                                                                            ,ATTRIBUTE199
                                                                                                            ,ATTRIBUTE200)) X) C
                      ,(SELECT ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10
                              ,ATTRIBUTE11
                              ,ATTRIBUTE12
                              ,ATTRIBUTE13
                              ,COLUMN_NAME
                              ,VALUE
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'SUCCESS') T UNPIVOT(VALUE FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                         ,ATTRIBUTE15
                                                                                                         ,ATTRIBUTE16
                                                                                                         ,ATTRIBUTE17
                                                                                                         ,ATTRIBUTE18
                                                                                                         ,ATTRIBUTE19
                                                                                                         ,ATTRIBUTE20
                                                                                                         ,ATTRIBUTE21
                                                                                                         ,ATTRIBUTE22
                                                                                                         ,ATTRIBUTE23
                                                                                                         ,ATTRIBUTE24
                                                                                                         ,ATTRIBUTE25
                                                                                                         ,ATTRIBUTE26
                                                                                                         ,ATTRIBUTE27
                                                                                                         ,ATTRIBUTE28
                                                                                                         ,ATTRIBUTE29
                                                                                                         ,ATTRIBUTE30
                                                                                                         ,ATTRIBUTE31
                                                                                                         ,ATTRIBUTE32
                                                                                                         ,ATTRIBUTE33
                                                                                                         ,ATTRIBUTE34
                                                                                                         ,ATTRIBUTE35
                                                                                                         ,ATTRIBUTE36
                                                                                                         ,ATTRIBUTE37
                                                                                                         ,ATTRIBUTE38
                                                                                                         ,ATTRIBUTE39
                                                                                                         ,ATTRIBUTE40
                                                                                                         ,ATTRIBUTE41
                                                                                                         ,ATTRIBUTE42
                                                                                                         ,ATTRIBUTE43
                                                                                                         ,ATTRIBUTE44
                                                                                                         ,ATTRIBUTE45
                                                                                                         ,ATTRIBUTE46
                                                                                                         ,ATTRIBUTE47
                                                                                                         ,ATTRIBUTE48
                                                                                                         ,ATTRIBUTE49
                                                                                                         ,ATTRIBUTE50
                                                                                                         ,ATTRIBUTE51
                                                                                                         ,ATTRIBUTE52
                                                                                                         ,ATTRIBUTE53
                                                                                                         ,ATTRIBUTE54
                                                                                                         ,ATTRIBUTE55
                                                                                                         ,ATTRIBUTE56
                                                                                                         ,ATTRIBUTE57
                                                                                                         ,ATTRIBUTE58
                                                                                                         ,ATTRIBUTE59
                                                                                                         ,ATTRIBUTE60
                                                                                                         ,ATTRIBUTE61
                                                                                                         ,ATTRIBUTE62
                                                                                                         ,ATTRIBUTE63
                                                                                                         ,ATTRIBUTE64
                                                                                                         ,ATTRIBUTE65
                                                                                                         ,ATTRIBUTE66
                                                                                                         ,ATTRIBUTE67
                                                                                                         ,ATTRIBUTE68
                                                                                                         ,ATTRIBUTE69
                                                                                                         ,ATTRIBUTE70
                                                                                                         ,ATTRIBUTE71
                                                                                                         ,ATTRIBUTE72
                                                                                                         ,ATTRIBUTE73
                                                                                                         ,ATTRIBUTE74
                                                                                                         ,ATTRIBUTE75
                                                                                                         ,ATTRIBUTE76
                                                                                                         ,ATTRIBUTE77
                                                                                                         ,ATTRIBUTE78
                                                                                                         ,ATTRIBUTE79
                                                                                                         ,ATTRIBUTE80
                                                                                                         ,ATTRIBUTE81
                                                                                                         ,ATTRIBUTE82
                                                                                                         ,ATTRIBUTE83
                                                                                                         ,ATTRIBUTE84
                                                                                                         ,ATTRIBUTE85
                                                                                                         ,ATTRIBUTE86
                                                                                                         ,ATTRIBUTE87
                                                                                                         ,ATTRIBUTE88
                                                                                                         ,ATTRIBUTE89
                                                                                                         ,ATTRIBUTE90
                                                                                                         ,ATTRIBUTE91
                                                                                                         ,ATTRIBUTE92
                                                                                                         ,ATTRIBUTE93
                                                                                                         ,ATTRIBUTE94
                                                                                                         ,ATTRIBUTE95
                                                                                                         ,ATTRIBUTE96
                                                                                                         ,ATTRIBUTE97
                                                                                                         ,ATTRIBUTE98
                                                                                                         ,ATTRIBUTE99
                                                                                                         ,ATTRIBUTE100
                                                                                                         ,ATTRIBUTE101
                                                                                                         ,ATTRIBUTE102
                                                                                                         ,ATTRIBUTE103
                                                                                                         ,ATTRIBUTE104
                                                                                                         ,ATTRIBUTE105
                                                                                                         ,ATTRIBUTE106
                                                                                                         ,ATTRIBUTE107
                                                                                                         ,ATTRIBUTE108
                                                                                                         ,ATTRIBUTE109
                                                                                                         ,ATTRIBUTE110
                                                                                                         ,ATTRIBUTE111
                                                                                                         ,ATTRIBUTE112
                                                                                                         ,ATTRIBUTE113
                                                                                                         ,ATTRIBUTE114
                                                                                                         ,ATTRIBUTE115
                                                                                                         ,ATTRIBUTE116
                                                                                                         ,ATTRIBUTE117
                                                                                                         ,ATTRIBUTE118
                                                                                                         ,ATTRIBUTE119
                                                                                                         ,ATTRIBUTE120
                                                                                                         ,ATTRIBUTE121
                                                                                                         ,ATTRIBUTE122
                                                                                                         ,ATTRIBUTE123
                                                                                                         ,ATTRIBUTE124
                                                                                                         ,ATTRIBUTE125
                                                                                                         ,ATTRIBUTE126
                                                                                                         ,ATTRIBUTE127
                                                                                                         ,ATTRIBUTE128
                                                                                                         ,ATTRIBUTE129
                                                                                                         ,ATTRIBUTE130
                                                                                                         ,ATTRIBUTE131
                                                                                                         ,ATTRIBUTE132
                                                                                                         ,ATTRIBUTE133
                                                                                                         ,ATTRIBUTE134
                                                                                                         ,ATTRIBUTE135
                                                                                                         ,ATTRIBUTE136
                                                                                                         ,ATTRIBUTE137
                                                                                                         ,ATTRIBUTE138
                                                                                                         ,ATTRIBUTE139
                                                                                                         ,ATTRIBUTE140
                                                                                                         ,ATTRIBUTE141
                                                                                                         ,ATTRIBUTE142
                                                                                                         ,ATTRIBUTE143
                                                                                                         ,ATTRIBUTE144
                                                                                                         ,ATTRIBUTE145
                                                                                                         ,ATTRIBUTE146
                                                                                                         ,ATTRIBUTE147
                                                                                                         ,ATTRIBUTE148
                                                                                                         ,ATTRIBUTE149
                                                                                                         ,ATTRIBUTE150
                                                                                                         ,ATTRIBUTE151
                                                                                                         ,ATTRIBUTE152
                                                                                                         ,ATTRIBUTE153
                                                                                                         ,ATTRIBUTE154
                                                                                                         ,ATTRIBUTE155
                                                                                                         ,ATTRIBUTE156
                                                                                                         ,ATTRIBUTE157
                                                                                                         ,ATTRIBUTE158
                                                                                                         ,ATTRIBUTE159
                                                                                                         ,ATTRIBUTE160
                                                                                                         ,ATTRIBUTE161
                                                                                                         ,ATTRIBUTE162
                                                                                                         ,ATTRIBUTE163
                                                                                                         ,ATTRIBUTE164
                                                                                                         ,ATTRIBUTE165
                                                                                                         ,ATTRIBUTE166
                                                                                                         ,ATTRIBUTE167
                                                                                                         ,ATTRIBUTE168
                                                                                                         ,ATTRIBUTE169
                                                                                                         ,ATTRIBUTE170
                                                                                                         ,ATTRIBUTE171
                                                                                                         ,ATTRIBUTE172
                                                                                                         ,ATTRIBUTE173
                                                                                                         ,ATTRIBUTE174
                                                                                                         ,ATTRIBUTE175
                                                                                                         ,ATTRIBUTE176
                                                                                                         ,ATTRIBUTE177
                                                                                                         ,ATTRIBUTE178
                                                                                                         ,ATTRIBUTE179
                                                                                                         ,ATTRIBUTE180
                                                                                                         ,ATTRIBUTE181
                                                                                                         ,ATTRIBUTE182
                                                                                                         ,ATTRIBUTE183
                                                                                                         ,ATTRIBUTE184
                                                                                                         ,ATTRIBUTE185
                                                                                                         ,ATTRIBUTE186
                                                                                                         ,ATTRIBUTE187
                                                                                                         ,ATTRIBUTE188
                                                                                                         ,ATTRIBUTE189
                                                                                                         ,ATTRIBUTE190
                                                                                                         ,ATTRIBUTE191
                                                                                                         ,ATTRIBUTE192
                                                                                                         ,ATTRIBUTE193
                                                                                                         ,ATTRIBUTE194
                                                                                                         ,ATTRIBUTE195
                                                                                                         ,ATTRIBUTE196
                                                                                                         ,ATTRIBUTE197
                                                                                                         ,ATTRIBUTE198
                                                                                                         ,ATTRIBUTE199
                                                                                                         ,ATTRIBUTE200)) X) V
                WHERE  1 = 1
                AND    C.COLUMN_NAME = V.COLUMN_NAME
                AND    C.YYYYMMDD IS NOT NULL
                AND    V.VALUE IS NOT NULL;
        
            DBMS_OUTPUT.PUT_LINE('21');
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '21';
            V_LOG_MESSAGE := '########## INSERT INTO DM_PLN_CUSTOMER_PSI DATE END ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------
        
            IF V_DIVISION = '40' THEN
                PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40('40');
                --2026-03-30 김준규 아래는 dm 에서 하지 않는 것으로 정리함.
                /*ELSE
                DBMS_OUTPUT.PUT_LINE('20240605-PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM');
                                PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM;*/
            END IF;
        
            COMMIT;
            --COMMIT ;
            -- END TRY
        END IF;
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## INSERT INTO DATA END ##########';
        V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        -- -------------------------------------------------------------------------
    
        COMMIT;
    
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,'ERROR'
                                ,0
                                ,SQLERRM
                                ,NULL
                                ,SYSDATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM;

    PROCEDURE P_DMF0014_GET_CUST_FCST_UPLOAD_DATA
    (
        P_DIVISION_ID    VARCHAR2
       ,P_DEPT_ID        VARCHAR2
       ,P_END_CUSTOMER   VARCHAR2
       ,P_SCM_SITE_ID    VARCHAR2
       ,P_PLANT_SITE_ID  VARCHAR2
       ,P_PROJECT_CODE   VARCHAR2
       ,P_ITEM_ID        VARCHAR2
       ,P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_DOM_EXP        VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       , --, p_debug OUT VARCHAR2
        P_USERINFO       VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    /*
         DMF0014_GET_CUST_FCST_UPLOAD_DATA(p_division_id='81', p_dept_id='ALL', p_end_customer='ALL', p_scm_site_id='ALL', p_plant_site_id='ALL', p_project_code = NULL);
         , p_item_id = NULL, p_start_yyyymmdd='20230904', p_end_yyyymmdd='20240310', p_bucket_type='WEEKLY', p_dom_exp='ALL', p_created_by='chano0612', p_userinfo='ADMIN'
        */
     AS
    
        $$PLSQL_UNIT   VARCHAR2(200) := $$PLSQL_UNIT;
        V_SQL_TEXT       VARCHAR2(32767 CHAR);
        V_ITERATION      VARCHAR2(4000 CHAR);
        V_COLUMN_TEXT    VARCHAR2(200 CHAR);
        V_COLUMN_NAME    VARCHAR2(50 CHAR);
        V_YYYYMMDD       VARCHAR2(8 CHAR);
        V_START_YYYYMMDD VARCHAR2(8 CHAR);
        V_GROUP_ID       VARCHAR2(50 CHAR) := NULL;
        V_CNT_1          INTEGER := 0;
        V_IN_PARA_DATA   VARCHAR2(4000);
        V_STEP           VARCHAR2(4000 CHAR) := NULL;
        V_LOG_TYPE       VARCHAR2(20) := NULL;
        N_LOG_COUNT      NUMBER := 0;
        V_LOG_MESSAGE    VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION    VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE     DATE := SYSDATE;
        V_PROC_INPUT     CLOB := NULL;
        V_SQL_CODE       VARCHAR2(100) := NULL;
        V_SQL_ERRMSG     VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE      VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                     ,'p_dept_id' VALUE P_DEPT_ID
                                     ,'p_end_customer' VALUE P_END_CUSTOMER
                                     ,'p_scm_site_id' VALUE P_SCM_SITE_ID
                                     ,'p_plant_site_id' VALUE P_PLANT_SITE_ID
                                     ,'p_project_code' VALUE P_PROJECT_CODE
                                     ,'p_item_id' VALUE P_ITEM_ID
                                     ,'p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                     ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                     ,'p_bucket_type' VALUE P_BUCKET_TYPE
                                     ,'p_dom_exp' VALUE P_DOM_EXP
                                     ,'p_created_by' VALUE P_CREATED_BY);
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        --  v_group_id := 'ADMIN'
        -- ------------------------------------------------------------------------------
        --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
        -- ------------------------------------------------------------------------------
        SELECT COUNT(1)
        INTO   V_CNT_1
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
        AND    VALID_YN = 'Y'
        AND    SEGMENT2 = 'ALL' -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
        AND    SEGMENT1 = P_USERINFO;
        IF V_CNT_1 > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
        -- ------------------------------------------------------------------------------
        --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
        -- ------------------------------------------------------------------------------
        SELECT A.BASIS_START_DATE INTO V_START_YYYYMMDD FROM SCM_SYS_CALENDAR_M A WHERE A.BASIS_YYYYMMDD = P_START_YYYYMMDD;
    
        V_ITERATION := NULL;
    
        IF P_BUCKET_TYPE = 'DAILY' THEN
            -- c_cust_fcst CURSOR FAST_FORWARD FOR
            FOR REC IN (SELECT 'D_' || BASIS_YYYYMMDD AS COLUMN_NAME, BASIS_YYYYMMDD YYYYMMDD
                        FROM   SCM_SYS_CALENDAR_M A
                        WHERE  A.BASIS_YYYYMMDD >= V_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                        AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                        ORDER  BY COLUMN_NAME) LOOP
            
                V_COLUMN_NAME := REC.COLUMN_NAME;
                V_YYYYMMDD    := REC.YYYYMMDD;
                V_COLUMN_TEXT := ', SUM(CASE WHEN CP.YYYYMMDD = ''v_yyyymmdd'' THEN CP.QTY ELSE NULL END) AS v_column_name ';
            
                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_yyyymmdd', V_YYYYMMDD);
                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_column_name', V_COLUMN_NAME);
            
                V_ITERATION := V_ITERATION || V_COLUMN_TEXT;
            
            END LOOP;
        
        ELSIF P_BUCKET_TYPE = 'WEEKLY' THEN
            -- c_cust_fcst CURSOR FAST_FORWARD FOR
            FOR REC IN (SELECT 'D_' || MIN(A.BASIS_START_DATE) COLUMN_NAME, A.ISO_YYYYWW --A.BASIS_YYYYMM + MIN(SUBSTR('00' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_START_DATE, 'IW')), 'YYYY-MM-DD'), -2)) YYYYMMDD
                        FROM   SCM_SYS_CALENDAR_M A
                        WHERE  A.BASIS_YYYYMMDD >= V_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                        AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                        GROUP  BY A.ISO_YYYYWW, A.WEEK_NAME
                        ORDER  BY COLUMN_NAME) LOOP
            
                V_COLUMN_NAME := REC.COLUMN_NAME;
                V_YYYYMMDD    := REC.ISO_YYYYWW;
            
                V_COLUMN_TEXT := ', SUM(CASE WHEN SUBSTR(CP.YYYYMMDD, 1, 4) || LPAD(TO_CHAR(TO_DATE(CP.YYYYMMDD, ''YYYYMMDD''), ''IW''), 2, ''0'') = ''v_yyyymmdd'' THEN CP.QTY ELSE NULL END) AS v_column_name ';
            
                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_yyyymmdd', V_YYYYMMDD);
                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_column_name', V_COLUMN_NAME);
            
                V_ITERATION := V_ITERATION || V_COLUMN_TEXT;
            
            END LOOP;
        
        ELSIF P_BUCKET_TYPE = 'MONTHLY' THEN
            -- c_cust_fcst CURSOR FAST_FORWARD FOR
            FOR REC IN (SELECT 'D_' || MIN(A.BASIS_YYYYMM) || '01' AS COLUMN_NAME, MIN(A.BASIS_YYYYMM) YYYYMMDD
                        FROM   SCM_SYS_CALENDAR_M A
                        WHERE  A.BASIS_YYYYMMDD >= V_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                        AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                        GROUP  BY A.MONTH_NAME
                        ORDER  BY COLUMN_NAME) LOOP
            
                V_COLUMN_NAME := REC.COLUMN_NAME;
                V_YYYYMMDD    := REC.YYYYMMDD;
                V_COLUMN_TEXT := ', SUM(CASE WHEN SUBSTR(CP.YYYYMMDD, 1, 6) = ''v_yyyymmdd'' THEN CP.QTY ELSE NULL END) AS v_column_name ';
            
                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_yyyymmdd', V_YYYYMMDD);
                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_column_name', V_COLUMN_NAME);
            
                V_ITERATION := V_ITERATION || V_COLUMN_TEXT;
            
            END LOOP;
        END IF;
    
        V_SQL_TEXT := ';
        SELECT CP.DIVISION_ID
             , CP.SCM_SITE_ID
             , CP.PLANT_SITE_ID
             , CP.CUSTOMER_PROJECT_CODE
             , CP.CUSTOMER_MODEL
             , CP.INCOTERMS
             , CP.FCST_TYPE
             , CP.DOM_EXP
             , CP.MEASURE_GROUP
             , CP.MEASURE
             , CP.UPLOAD_UOM
             , CP.PROJECT_CODE
             , CP.ITEM_ID
        --[PJ2024-50461] Team Mapping------------------------------------
             --, CASE WHEN ((FN_GET_DEPT_LIST(''p_created_by'', S.DEPT_ID) = ''Y'') OR ''v_group_id'' =''ADMIN'')
                --THEN ''Y'' ELSE '''' END AS EDIT_FLAG
             --, CASE WHEN ((FN_GET_DEPT_LIST(''p_created_by'', TEAM.DEPT_ID) = ''Y'') OR ''v_group_id'' =''ADMIN'')
             --   THEN ''Y'' ELSE '''' END AS EDIT_FLAG
             -- 2026-04-01 김준규 SCM_MST_SITE_ITEM 의 DEPT_ID를 사용 시작
             , CASE WHEN ((FN_GET_DEPT_LIST(''p_created_by'', ITM.DEPT_ID) = ''Y'') OR ''v_group_id'' =''ADMIN'')
                THEN ''Y'' ELSE '''' END AS EDIT_FLAG
             -- 2026-04-01 김준규 SCM_MST_SITE_ITEM 의 DEPT_ID를 사용 종료
        --[PJ2024-50461] Team Mapping------------------------------------
             v_iteration
             ,MAX(TEI.EDIT_YN) EDIT_YN
        FROM   DM_PLN_CUSTOMER_PSI CP
        INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''' || P_USER_ID || ''', ''' || P_MENU_ID || ''')) TEI
        ON     TEI.UNIT_ID = CP.DIVISION_ID
           --, SCM_MST_SITE        S
        --[PJ2024-50611] 명시적으로 INNER JOIN 처리 START
        INNER JOIN  SCM_MST_SITE        S
            ON CP.DIVISION_ID   = S.DIVISION_ID
            AND    CP.SCM_SITE_ID   = S.SCM_SITE_ID
        --[PJ2024-50611] 명시적으로 INNER JOIN 처리 END
--[PJ2024-50461] Team Mapping------------------------------------
            LEFT OUTER JOIN SCM_MST_SITE_ITEM ITM
                ON S.DIVISION_ID = ITM.DIVISION_ID
                AND S.SCM_SITE_ID = ITM.SCM_SITE_ID
                AND CP.PROJECT_CODE = ITM.PROJECT_CODE--[PJ2024-50611] 조인 추가
                AND CP.ITEM_ID = ITM.ITEM_ID--[PJ2024-50611] 조인 추가
         -- 2026-04-01 김준규 팀 변경 필요 없게 됨 시작
         --LEFT JOIN (
         --    SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
         --    FROM SCM_MST_SSO_USER_INFO B
         --    INNER JOIN SCM_MST_SSO_DEPT_INFO C
         --    ON B.DEPT_ID = C.DEPT_ID
         --) TEAM
         --ON
         --TEAM.USER_ID   IN (SELECT value FROM TABLE(fn_splitstring(ITM.owner, '','')))            
         -- 2026-04-01 김준규 팀 변경 필요 없게 됨 종료
--[PJ2024-50461] Team Mapping------------------------------------
        WHERE  1 = 1
        AND    CP.DIVISION_ID   = S.DIVISION_ID
        AND    CP.SCM_SITE_ID   = S.SCM_SITE_ID
        AND    CP.MEASURE_GROUP = ''CUST_FCST''
        p_division_id
        p_dept_id
        p_scm_site_id
        p_plant_site_id
        p_project_code
        p_item_id
        p_dom_exp
        p_end_customer
        AND    CP.YYYYMMDD BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd''
        AND    CP.MEASURE IN (SELECT DISTINCT MEASURE
                              FROM   DM_MST_CUSTOMER_FCST X
                              WHERE  1 = 1
                              AND    X.DIVISION_ID = CP.DIVISION_ID
                              AND    X.SCM_SITE_ID = CP.SCM_SITE_ID -- 해당 SITE에 연결된 Measure만 구함.
                              AND    X.UPLOAD_BUCKET_TYPE = ''p_bucket_type''
                              AND    X.VALID_YN = ''Y''
                            )
        GROUP BY CP.DIVISION_ID
        --[PJ2024-50461] Team Mapping------------------------------------
               --, S.DEPT_ID
               --, TEAM.DEPT_ID
               , ITM.DEPT_ID
        --[PJ2024-50461] Team Mapping------------------------------------
               , CP.SCM_SITE_ID
               , CP.PLANT_SITE_ID
               , CP.CUSTOMER_PROJECT_CODE
               , CP.CUSTOMER_MODEL
               , CP.INCOTERMS
               , CP.FCST_TYPE
               , CP.DOM_EXP
               , CP.MEASURE_GROUP
               , CP.MEASURE
               , CP.UPLOAD_UOM
               , CP.PROJECT_CODE
               , CP.ITEM_ID
        ORDER BY CP.DIVISION_ID
               , CP.SCM_SITE_ID
               , CP.PLANT_SITE_ID
               , CP.CUSTOMER_PROJECT_CODE
               , CP.CUSTOMER_MODEL
       ';
    
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'v_iteration', V_ITERATION);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_division_id', FN_SCM_GET_WHERE_SQL('CP.DIVISION_ID', 'IN', P_DIVISION_ID));
        --[PJ2024-50461] Team Mapping------------------------------------
        --V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_id', FN_SCM_GET_WHERE_SQL('TEAM.DEPT_ID', 'IN', P_DEPT_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_id', FN_SCM_GET_WHERE_SQL('ITM.DEPT_ID', 'IN', P_DEPT_ID));
        --[PJ2024-50461] Team Mapping------------------------------------
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_end_customer', FN_SCM_GET_WHERE_SQL('S.END_CUSTOMER', 'IN', P_END_CUSTOMER));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_scm_site_id', FN_SCM_GET_WHERE_SQL('CP.SCM_SITE_ID', 'IN', P_SCM_SITE_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_plant_site_id', FN_SCM_GET_WHERE_SQL('CP.PLANT_SITE_ID', 'IN', P_PLANT_SITE_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_project_code', FN_SCM_GET_WHERE_SQL('CP.PROJECT_CODE', 'IN', P_PROJECT_CODE));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_item_id', FN_SCM_GET_WHERE_SQL('CP.ITEM_ID', 'IN', P_ITEM_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dom_exp', FN_SCM_GET_WHERE_SQL('CP.DOM_EXP', 'IN', P_DOM_EXP));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_start_yyyymmdd', V_START_YYYYMMDD);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_end_yyyymmdd', P_END_YYYYMMDD);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_bucket_type', P_BUCKET_TYPE);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_created_by', P_CREATED_BY);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'v_group_id', V_GROUP_ID);
    
        --p_debug := v_sql_text;
        --RETURN p_debug;
        --SELECT v_sql_text;
    
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ORA$PTT_RESULT';
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        DECLARE
            V_SQL    VARCHAR2(32767);
            V_DDL    VARCHAR2(32767);
            V_CURSOR INTEGER;
            V_RESULT INTEGER;
        BEGIN
            V_SQL := REPLACE(V_SQL_TEXT, ';', '');
        
            V_DDL := 'CREATE PRIVATE TEMPORARY TABLE ORA$PTT_RESULT 
                      ON COMMIT PRESERVE DEFINITION 
                      AS SELECT * FROM (' || V_SQL || ') WHERE 1=2';
        
            --2026-04-01 김준규 디버깅 할 때만 사용할 것 
            --DBMS_OUTPUT.PUT_LINE(V_DDL);
        
            V_CURSOR := DBMS_SQL.OPEN_CURSOR;
            DBMS_SQL.PARSE(V_CURSOR, V_DDL, DBMS_SQL.NATIVE);
            V_RESULT := DBMS_SQL.EXECUTE(V_CURSOR);
            DBMS_SQL.CLOSE_CURSOR(V_CURSOR);
        
            EXECUTE IMMEDIATE 'INSERT INTO ORA$PTT_RESULT SELECT * FROM (' || V_SQL || ')';
        END;
    
        OPEN O_RC1 FOR 'SELECT * FROM ORA$PTT_RESULT';
    
        --p_plan_week, p_division_code, p_customer_id, p_fcst_sit_id, p_measure, p_edi_fcst_yn, p_valid_yn;
        --xml확인할경우
        --SELECT TO_CLOB(v_sql_text)
        --FROM DUAL;
        COMMIT;
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
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
    END P_DMF0014_GET_CUST_FCST_UPLOAD_DATA;

    PROCEDURE P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA
    (
        P_ACTIVE_FLAG           VARCHAR2
       ,P_DIVISION_ID           VARCHAR2
       ,P_SCM_SITE_ID           VARCHAR2
       ,P_CUSTOMER_PROJECT_CODE VARCHAR2
       ,P_CUSTOMER_MODEL        VARCHAR2
       ,P_INCOTERMS             VARCHAR2
       ,P_FCST_TYPE             VARCHAR2
       ,P_DOM_EXP               VARCHAR2
       ,P_MEASURE_GROUP         VARCHAR2
       ,P_MEASURE               VARCHAR2
       ,P_PLANT_SITE_ID         VARCHAR2
       ,P_UPLOAD_UOM            VARCHAR2
       ,P_PROJECT_CODE          VARCHAR2
       ,P_ITEM_ID               VARCHAR2
       ,P_YYYYMMDD              VARCHAR2
       ,P_QTY                   VARCHAR2
       ,P_CREATED_BY            VARCHAR2
       ,O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0014_SAVE_CUST_FCST_UPLOAD_DATA
        * Description  : SAVE CUST FCST UPLOAD DATA
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2018. 03. 28    KHSONG     Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        * 2022. 10. 26      KDW2819      [C20221024-000507]CUST FCST Upload 오류 수정
        * 2026.03.24      김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        V_IN_PARA_DATA                VARCHAR2(4000);
        V_RECV_ACTIVE_FLAG            VARCHAR2(4000 CHAR);
        V_ACTIVE_FLAG                 VARCHAR2(4000 CHAR);
        V_DIVISION_ID                 VARCHAR2(4000 CHAR);
        V_SCM_SITE_ID                 VARCHAR2(4000 CHAR);
        V_CUSTOMER_PROJECT_CODE       VARCHAR2(4000 CHAR);
        V_CUSTOMER_MODEL              VARCHAR2(4000 CHAR);
        V_INCOTERMS                   VARCHAR2(4000 CHAR);
        V_FCST_TYPE                   VARCHAR2(4000 CHAR);
        V_DOM_EXP                     VARCHAR2(4000 CHAR);
        V_MEASURE_GROUP               VARCHAR2(4000 CHAR);
        V_MEASURE                     VARCHAR2(4000 CHAR);
        V_PLANT_SITE_ID               VARCHAR2(4000 CHAR);
        V_UPLOAD_UOM                  VARCHAR2(4000 CHAR);
        V_PROJECT_CODE                VARCHAR2(4000 CHAR);
        V_ITEM_ID                     VARCHAR2(4000 CHAR);
        V_YYYYMMDD                    VARCHAR2(4000 CHAR);
        V_QTY                         VARCHAR2(4000 CHAR);
        V_CREATED_BY                  VARCHAR2(4000 CHAR);
        V_DELIMITER                   VARCHAR2(1 CHAR);
        V_MAX_LOOP_CNT                INTEGER := 0;
        V_MST_LOOP_CNT                INTEGER := 0;
        $$PLSQL_UNIT                VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE                    VARCHAR2(30 CHAR);
        N_LOG_COUNT                   INTEGER := 0;
        V_LOG_MESSAGE                 VARCHAR2(1000 CHAR);
        V_DESCRIPTION                 VARCHAR2(500 CHAR);
        D_EVENT_DATE                  DATE;
        V_INDEX_ACTIVE_FLAG           INTEGER;
        V_INDEX_DIVISION_ID           INTEGER;
        V_INDEX_SCM_SITE_ID           INTEGER;
        V_INDEX_CUSTOMER_PROJECT_CODE INTEGER;
        V_INDEX_CUSTOMER_MODEL        INTEGER;
        V_INDEX_INCOTERMS             INTEGER;
        V_INDEX_FCST_TYPE             INTEGER;
        V_INDEX_DOM_EXP               INTEGER;
        V_INDEX_MEASURE_GROUP         INTEGER;
        V_INDEX_MEASURE               INTEGER;
        V_INDEX_PLANT_SITE_ID         INTEGER;
        V_INDEX_UPLOAD_UOM            INTEGER;
        V_INDEX_PROJECT_CODE          INTEGER;
        V_INDEX_ITEM_ID               INTEGER;
        V_INDEX_YYYYMMDD              INTEGER;
        V_INDEX_QTY                   INTEGER;
        V_INDEX_CREATED_BY            INTEGER;
        V_P_ACTIVE_FLAG               VARCHAR2(4000 CHAR);
        V_P_DIVISION_ID               VARCHAR2(4000 CHAR);
        V_P_SCM_SITE_ID               VARCHAR2(4000 CHAR);
        V_P_CUSTOMER_PROJECT_CODE     VARCHAR2(4000 CHAR);
        V_P_CUSTOMER_MODEL            VARCHAR2(4000 CHAR);
        V_P_INCOTERMS                 VARCHAR2(4000 CHAR);
        V_P_FCST_TYPE                 VARCHAR2(4000 CHAR);
        V_P_DOM_EXP                   VARCHAR2(4000 CHAR);
        V_P_MEASURE_GROUP             VARCHAR2(4000 CHAR);
        V_P_MEASURE                   VARCHAR2(4000 CHAR);
        V_P_PLANT_SITE_ID             VARCHAR2(4000 CHAR);
        V_P_UPLOAD_UOM                VARCHAR2(4000 CHAR);
        V_P_PROJECT_CODE              VARCHAR2(4000 CHAR);
        V_P_ITEM_ID                   VARCHAR2(4000 CHAR);
        V_P_YYYYMMDD                  VARCHAR2(4000 CHAR);
        V_P_QTY                       VARCHAR2(4000 CHAR);
        V_P_CREATED_BY                VARCHAR2(4000 CHAR);
    BEGIN
    
        NULL;
    
        V_RECV_ACTIVE_FLAG := NULL;
        V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;
    
        -- 멀티처리 변수선언
        V_ACTIVE_FLAG           := NULL;
        V_DIVISION_ID           := NULL;
        V_SCM_SITE_ID           := NULL;
        V_CUSTOMER_PROJECT_CODE := NULL;
        V_CUSTOMER_MODEL        := NULL;
        V_INCOTERMS             := NULL;
        V_FCST_TYPE             := NULL;
        V_DOM_EXP               := NULL;
        V_MEASURE_GROUP         := NULL;
        V_MEASURE               := NULL;
        V_PLANT_SITE_ID         := NULL;
        V_UPLOAD_UOM            := NULL;
        V_PROJECT_CODE          := NULL;
        V_ITEM_ID               := NULL;
        V_YYYYMMDD              := NULL;
        V_QTY                   := NULL;
        V_CREATED_BY            := NULL;
    
        V_DELIMITER := '^';
    
        V_P_ACTIVE_FLAG           := RTRIM(P_ACTIVE_FLAG) || '^';
        V_P_DIVISION_ID           := RTRIM(P_DIVISION_ID) || '^';
        V_P_SCM_SITE_ID           := RTRIM(P_SCM_SITE_ID) || '^';
        V_P_CUSTOMER_PROJECT_CODE := RTRIM(P_CUSTOMER_PROJECT_CODE) || '^';
        V_P_CUSTOMER_MODEL        := RTRIM(P_CUSTOMER_MODEL) || '^';
        V_P_INCOTERMS             := RTRIM(P_INCOTERMS) || '^';
        V_P_FCST_TYPE             := RTRIM(P_FCST_TYPE) || '^';
        V_P_DOM_EXP               := RTRIM(P_DOM_EXP) || '^';
        V_P_MEASURE_GROUP         := RTRIM(P_MEASURE_GROUP) || '^';
        V_P_MEASURE               := RTRIM(P_MEASURE) || '^';
        V_P_PLANT_SITE_ID         := RTRIM(P_PLANT_SITE_ID) || '^';
        V_P_UPLOAD_UOM            := RTRIM(P_UPLOAD_UOM) || '^';
        V_P_PROJECT_CODE          := RTRIM(P_PROJECT_CODE) || '^';
        V_P_ITEM_ID               := RTRIM(P_ITEM_ID) || '^';
        V_P_YYYYMMDD              := RTRIM(P_YYYYMMDD) || '^';
        V_P_QTY                   := RTRIM(P_QTY) || '^';
        V_P_CREATED_BY            := RTRIM(P_CREATED_BY) || '^';
    
        -- GT_SCFU_RESULTS TEMP TABLE
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SCFU_RESULTS';
    
        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
    
        --===================================================================================== GT_SCFU_RESULTS 테이블에 split후 INSERT INTO start
        --###############################################  GT_SCFU_RESULTS 테이블에 split후 insert (START)
        WHILE LENGTH(V_P_DIVISION_ID) > 0 LOOP
        
            V_INDEX_ACTIVE_FLAG           := INSTR(V_P_ACTIVE_FLAG, '^');
            V_INDEX_DIVISION_ID           := INSTR(V_P_DIVISION_ID, '^');
            V_INDEX_SCM_SITE_ID           := INSTR(V_P_SCM_SITE_ID, '^');
            V_INDEX_CUSTOMER_PROJECT_CODE := INSTR(V_P_CUSTOMER_PROJECT_CODE, '^');
            V_INDEX_CUSTOMER_MODEL        := INSTR(V_P_CUSTOMER_MODEL, '^');
            V_INDEX_INCOTERMS             := INSTR(V_P_INCOTERMS, '^');
            V_INDEX_FCST_TYPE             := INSTR(V_P_FCST_TYPE, '^');
            V_INDEX_DOM_EXP               := INSTR(V_P_DOM_EXP, '^');
            V_INDEX_MEASURE_GROUP         := INSTR(V_P_MEASURE_GROUP, '^');
            V_INDEX_MEASURE               := INSTR(V_P_MEASURE, '^');
            V_INDEX_PLANT_SITE_ID         := INSTR(V_P_PLANT_SITE_ID, '^');
            V_INDEX_UPLOAD_UOM            := INSTR(V_P_UPLOAD_UOM, '^');
            V_INDEX_PROJECT_CODE          := INSTR(V_P_PROJECT_CODE, '^');
            V_INDEX_ITEM_ID               := INSTR(V_P_ITEM_ID, '^');
            V_INDEX_YYYYMMDD              := INSTR(V_P_YYYYMMDD, '^');
            V_INDEX_QTY                   := INSTR(V_P_QTY, '^');
            V_INDEX_CREATED_BY            := INSTR(V_P_CREATED_BY, '^');
        
            --확인  select v_index_DIVISION_ID as 'v_index_DIVISION_ID';
            IF V_INDEX_DIVISION_ID > 0 THEN
                V_ACTIVE_FLAG           := SUBSTR(V_P_ACTIVE_FLAG, 1, V_INDEX_ACTIVE_FLAG - 1);
                V_DIVISION_ID           := SUBSTR(V_P_DIVISION_ID, 1, V_INDEX_DIVISION_ID - 1);
                V_SCM_SITE_ID           := SUBSTR(V_P_SCM_SITE_ID, 1, V_INDEX_SCM_SITE_ID - 1);
                V_CUSTOMER_PROJECT_CODE := SUBSTR(V_P_CUSTOMER_PROJECT_CODE, 1, V_INDEX_CUSTOMER_PROJECT_CODE - 1);
                V_CUSTOMER_MODEL        := SUBSTR(V_P_CUSTOMER_MODEL, 1, V_INDEX_CUSTOMER_MODEL - 1);
                V_INCOTERMS             := SUBSTR(V_P_INCOTERMS, 1, V_INDEX_INCOTERMS - 1);
                V_FCST_TYPE             := SUBSTR(V_P_FCST_TYPE, 1, V_INDEX_FCST_TYPE - 1);
                V_DOM_EXP               := SUBSTR(V_P_DOM_EXP, 1, V_INDEX_DOM_EXP - 1);
                V_MEASURE_GROUP         := SUBSTR(V_P_MEASURE_GROUP, 1, V_INDEX_MEASURE_GROUP - 1);
                V_MEASURE               := SUBSTR(V_P_MEASURE, 1, V_INDEX_MEASURE - 1);
                V_PLANT_SITE_ID         := SUBSTR(V_P_PLANT_SITE_ID, 1, V_INDEX_PLANT_SITE_ID - 1);
                V_UPLOAD_UOM            := SUBSTR(V_P_UPLOAD_UOM, 1, V_INDEX_UPLOAD_UOM - 1);
                V_PROJECT_CODE          := SUBSTR(V_P_PROJECT_CODE, 1, V_INDEX_PROJECT_CODE - 1);
                V_ITEM_ID               := SUBSTR(V_P_ITEM_ID, 1, V_INDEX_ITEM_ID - 1);
                V_YYYYMMDD              := SUBSTR(V_P_YYYYMMDD, 1, V_INDEX_YYYYMMDD - 1);
                V_QTY                   := SUBSTR(V_P_QTY, 1, V_INDEX_QTY - 1);
                V_CREATED_BY            := SUBSTR(V_P_CREATED_BY, 1, V_INDEX_CREATED_BY - 1);
            
                V_P_ACTIVE_FLAG           := SUBSTR(V_P_ACTIVE_FLAG, V_INDEX_ACTIVE_FLAG + 1);
                V_P_DIVISION_ID           := SUBSTR(V_P_DIVISION_ID, V_INDEX_DIVISION_ID + 1);
                V_P_SCM_SITE_ID           := SUBSTR(V_P_SCM_SITE_ID, V_INDEX_SCM_SITE_ID + 1);
                V_P_CUSTOMER_PROJECT_CODE := SUBSTR(V_P_CUSTOMER_PROJECT_CODE, V_INDEX_CUSTOMER_PROJECT_CODE + 1);
                V_P_CUSTOMER_MODEL        := SUBSTR(V_P_CUSTOMER_MODEL, V_INDEX_CUSTOMER_MODEL + 1);
                V_P_INCOTERMS             := SUBSTR(V_P_INCOTERMS, V_INDEX_INCOTERMS + 1);
                V_P_FCST_TYPE             := SUBSTR(V_P_FCST_TYPE, V_INDEX_FCST_TYPE + 1);
                V_P_DOM_EXP               := SUBSTR(V_P_DOM_EXP, V_INDEX_DOM_EXP + 1);
                V_P_MEASURE_GROUP         := SUBSTR(V_P_MEASURE_GROUP, V_INDEX_MEASURE_GROUP + 1);
                V_P_MEASURE               := SUBSTR(V_P_MEASURE, V_INDEX_MEASURE + 1);
                V_P_PLANT_SITE_ID         := SUBSTR(V_P_PLANT_SITE_ID, V_INDEX_PLANT_SITE_ID + 1);
                V_P_UPLOAD_UOM            := SUBSTR(V_P_UPLOAD_UOM, V_INDEX_UPLOAD_UOM + 1);
                V_P_PROJECT_CODE          := SUBSTR(V_P_PROJECT_CODE, V_INDEX_PROJECT_CODE + 1);
                V_P_ITEM_ID               := SUBSTR(V_P_ITEM_ID, V_INDEX_ITEM_ID + 1);
                V_P_YYYYMMDD              := SUBSTR(V_P_YYYYMMDD, V_INDEX_YYYYMMDD + 1);
                V_P_QTY                   := SUBSTR(V_P_QTY, V_INDEX_QTY + 1);
                V_P_CREATED_BY            := SUBSTR(V_P_CREATED_BY, V_INDEX_CREATED_BY + 1);
            
                INSERT /*+ NO_PARALLEL */
                INTO GT_SCFU_RESULTS
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_SCM_SITE_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_INCOTERMS
                    ,V_FCST_TYPE
                    ,V_DOM_EXP
                    ,V_MEASURE_GROUP
                    ,V_MEASURE
                    ,V_PLANT_SITE_ID
                    ,V_UPLOAD_UOM
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_YYYYMMDD
                    ,V_QTY
                    ,V_CREATED_BY)
                VALUES
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_SCM_SITE_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_INCOTERMS
                    ,V_FCST_TYPE
                    ,V_DOM_EXP
                    ,V_MEASURE_GROUP
                    ,V_MEASURE
                    ,V_PLANT_SITE_ID
                    ,V_UPLOAD_UOM
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_YYYYMMDD
                    ,V_QTY
                    ,V_CREATED_BY);
            ELSE
                V_DIVISION_ID   := V_P_DIVISION_ID;
                V_P_DIVISION_ID := NULL;
            
                INSERT /*+ NO_PARALLEL */
                INTO GT_SCFU_RESULTS
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_SCM_SITE_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_INCOTERMS
                    ,V_FCST_TYPE
                    ,V_DOM_EXP
                    ,V_MEASURE_GROUP
                    ,V_MEASURE
                    ,V_PLANT_SITE_ID
                    ,V_UPLOAD_UOM
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_YYYYMMDD
                    ,V_QTY
                    ,V_CREATED_BY)
                VALUES
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_SCM_SITE_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_INCOTERMS
                    ,V_FCST_TYPE
                    ,V_DOM_EXP
                    ,V_MEASURE_GROUP
                    ,V_MEASURE
                    ,V_PLANT_SITE_ID
                    ,V_UPLOAD_UOM
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_YYYYMMDD
                    ,V_QTY
                    ,V_CREATED_BY);
            END IF;
            -- if end
        END LOOP;
        --###############################################   GT_SCFU_RESULTS 테이블에 split후 insert (END)
        -- Customer Project,Customer Model  잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
        --IF (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from DM_MST_CUSTOMER_MODEL
        --    where DIVISION_ID  = v_DIVISION_ID AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) = 0
        -- AND
        -- (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from SCM_MST_SITE_ITEM
        --    where DIVISION_ID  = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) > 0
        --begin
        -- v_log_type := 'INVALID';
        -- SELECT '['|| v_customer_project_code ||']'|| ' Invalid Customer Project !';
        -- goto err_rtn
        --end
        --IF (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from DM_MST_CUSTOMER_MODEL
        --    where DIVISION_ID  = v_DIVISION_ID AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE AND CUSTOMER_MODEL = v_CUSTOMER_MODEL AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) = 0
        -- AND
        -- (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from SCM_MST_SITE_ITEM
        --    where DIVISION_ID  = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE AND ITEM_ID = v_CUSTOMER_MODEL AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) > 0
        --begin
        -- v_log_type := 'INVALID';
        -- SELECT '['|| v_customer_project_code ||']'|| ' Invalid Customer Model !';
        -- goto err_rtn
        --end
        -- Customer Project,Customer Model  잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------
        --SELECT * FROM GT_SCFU_RESULTS
        --===================================================================================== INSERT INTO 전 DELETE FROM start
        BEGIN
            -- 확인  select * from GT_SCFU_RESULTS
            DELETE FROM DM_PLN_CUSTOMER_PSI
            WHERE  (SELECT COUNT(1)
                    FROM   GT_SCFU_RESULTS
                    WHERE  1 = 1
                    AND    DIVISION_ID = DM_PLN_CUSTOMER_PSI.DIVISION_ID
                    AND    CUSTOMER_PROJECT_CODE = DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE
                    AND    CUSTOMER_MODEL = DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL
                    AND    SCM_SITE_ID = DM_PLN_CUSTOMER_PSI.SCM_SITE_ID
                    AND    DOM_EXP = DM_PLN_CUSTOMER_PSI.DOM_EXP
                    AND    FCST_TYPE = DM_PLN_CUSTOMER_PSI.FCST_TYPE
                    AND    MEASURE_GROUP = DM_PLN_CUSTOMER_PSI.MEASURE_GROUP
                    AND    MEASURE = DM_PLN_CUSTOMER_PSI.MEASURE
                    AND    YYYYMMDD = DM_PLN_CUSTOMER_PSI.YYYYMMDD
                    AND    INCOTERMS = DM_PLN_CUSTOMER_PSI.INCOTERMS
                    AND    PLANT_SITE_ID = DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID) > 0;
        END;
    
        --===================================================================================== INSERT INTO 전 DELETE FROM end
        --===================================================================================== INSERT INTO start
        BEGIN
        
            INSERT INTO DM_PLN_CUSTOMER_PSI
                SELECT V_DIVISION_ID
                      ,V_CUSTOMER_PROJECT_CODE
                      ,V_CUSTOMER_MODEL
                      ,V_SCM_SITE_ID
                      ,V_DOM_EXP
                      ,V_FCST_TYPE
                      ,V_MEASURE_GROUP
                      ,V_MEASURE
                      ,V_YYYYMMDD
                      ,V_INCOTERMS
                      ,V_PLANT_SITE_ID
                      ,V_PROJECT_CODE
                      ,V_ITEM_ID
                      ,V_QTY
                      ,V_UPLOAD_UOM
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,'UI' --BATCH_RESULT
                      ,NULL --MST_UPLOAD_UOM
                      ,NULL --MST_UPLOAD_BUCKET_TYPE
                      ,NULL --MST_SUMMARY_BUCKET_TYPE
                      ,NULL --MST_CONVERT_QTY
                      ,NULL --PLAN_WEEK
                      ,NULL --SPLIT_RESULT
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                FROM   GT_SCFU_RESULTS;
        
        END;
    
        --===================================================================================== INSERT INTO end
        -- 시작과 종료일자 사이에 정보를 일괄 update 함. added by ytchoi 180314
        UPDATE DM_PLN_CUSTOMER_PSI
        SET    BATCH_RESULT = 'UI'
        WHERE  (SELECT COUNT(1)
                FROM   (SELECT DIVISION_ID
                              ,SCM_SITE_ID
                              ,CUSTOMER_PROJECT_CODE
                              ,CUSTOMER_MODEL
                              ,INCOTERMS
                              ,FCST_TYPE
                              ,DOM_EXP
                              ,MEASURE_GROUP
                              ,MEASURE
                              ,PLANT_SITE_ID
                              ,MIN(YYYYMMDD) MIN_YYYYMMDD
                              ,MAX(YYYYMMDD) MAX_YYYYMMDD
                        FROM   DM_PLN_CUSTOMER_PSI
                        WHERE  BATCH_RESULT = 'UI'
                        GROUP  BY DIVISION_ID
                                 ,SCM_SITE_ID
                                 ,CUSTOMER_PROJECT_CODE
                                 ,CUSTOMER_MODEL
                                 ,INCOTERMS
                                 ,FCST_TYPE
                                 ,DOM_EXP
                                 ,MEASURE_GROUP
                                 ,MEASURE
                                 ,PLANT_SITE_ID) A
                WHERE  A.DIVISION_ID = DM_PLN_CUSTOMER_PSI.DIVISION_ID
                AND    A.SCM_SITE_ID = DM_PLN_CUSTOMER_PSI.SCM_SITE_ID
                AND    A.CUSTOMER_PROJECT_CODE = DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE
                AND    A.CUSTOMER_MODEL = DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL
                AND    A.INCOTERMS = DM_PLN_CUSTOMER_PSI.INCOTERMS
                AND    A.FCST_TYPE = DM_PLN_CUSTOMER_PSI.FCST_TYPE
                AND    A.DOM_EXP = DM_PLN_CUSTOMER_PSI.DOM_EXP
                AND    A.MEASURE_GROUP = DM_PLN_CUSTOMER_PSI.MEASURE_GROUP
                AND    A.MEASURE = DM_PLN_CUSTOMER_PSI.MEASURE
                AND    A.PLANT_SITE_ID = DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID
                AND    DM_PLN_CUSTOMER_PSI.YYYYMMDD BETWEEN A.MIN_YYYYMMDD AND A.MAX_YYYYMMDD) > 0;
    
        --===================================================================================== HISTORY INSERT INTO start
        BEGIN
        
            INSERT INTO DM_PLN_CUSTOMER_PSI_H
                SELECT V_DIVISION_ID
                      ,SEQ1_DM_PLN_CUSTOMER_PSI_H.NEXTVAL
                      ,V_CUSTOMER_PROJECT_CODE
                      ,V_CUSTOMER_MODEL
                      ,V_SCM_SITE_ID
                      ,V_DOM_EXP
                      ,V_FCST_TYPE
                      ,V_MEASURE_GROUP
                      ,V_MEASURE
                      ,V_YYYYMMDD
                      ,V_INCOTERMS
                      ,V_PLANT_SITE_ID
                      ,V_PROJECT_CODE
                      ,V_ITEM_ID
                      ,TO_NUMBER(V_QTY)
                      ,V_UPLOAD_UOM
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,'UI'
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                FROM   GT_SCFU_RESULTS;
        
        END;
    
        --===================================================================================== HISTORY INSERT INTO end
        BEGIN
            PR_DM_PLN_CUST_FCST_TO_MKT_FCST;
        END;
    
        COMMIT;
    
        -- END TRY
    
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    
    EXCEPTION
        WHEN OTHERS THEN
            -- ERROR LOG
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
            D_EVENT_DATE  := SYSTIMESTAMP;
            NULL;
        
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        
            -- END CATCH
        
            -- 종료 LOG
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := NULL;
            D_EVENT_DATE  := SYSTIMESTAMP;
        
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA;

END PKG_DMF0014;
/
