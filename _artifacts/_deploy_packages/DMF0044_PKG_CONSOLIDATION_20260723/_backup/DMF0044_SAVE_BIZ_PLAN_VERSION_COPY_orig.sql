CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_SAVE_BIZ_PLAN_VERSION_COPY" 
(
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_VERSION_DESCRIPTION   IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_ACTION_TYPE           IN  VARCHAR2,   -- D:삭제, CR: 생성, CP:복사
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SAVE_BIZ_PLAN_VERSION_COPY
 * Description  : Sales REPORT 개발 (DM_PLN_BP_FCST_C -> DM_PLN_BP_FCST_REPORT_C) VERSION COPY PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190709 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy
 * 20191022 KYH			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4
 * 20200113 HWI1993 COPY, DELETE 기능 추가
 * 20200116 hwi1993 company_id 추가
 * 20200129 hwi1993 SalesAmt_USD 메저 추가
 * 20200211 HWI1993	부서 없는 데이터 삭제
 * 20200326 P.C.I   [PREPARE] 환율 정보 copy
 * 2026.03.23   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발

 VAR RC1 REFCURSOR;
EXEC DMF0044_SAVE_BIZ_PLAN_VERSION_COPY( '40', 'SP_W_20260310_V003', 'SALES_PLAN WEEKLY CUTOFF', 'system', 'CR', :RC1);
PRINT RC1;

 */
IS
    -- Case 41: 프로그램명 (패키지 대응)
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;
    v_created_by        VARCHAR2(50 CHAR) := 'mdf_batch';
    V_ORI_VERSION       VARCHAR2(30 CHAR);

    v_rp_version        VARCHAR2(2 CHAR);
    v_version_x         VARCHAR2(50 CHAR);
    v_exists            PLS_INTEGER;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- GTT 초기화 (프로시저 시작 시, 이전에 일반 테이블 DML 없으므로 TRUNCATE 허용)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_0044_BP_FCST_01';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_0044_BP_FCST_02';

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -----------------------------------------------------------------------------------------------------
    --                                                                                 Validation (BEGIN)
    -----------------------------------------------------------------------------------------------------
    BEGIN
        SELECT 1 INTO v_exists FROM DUAL
        WHERE EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_DIVISION WHERE DIVISION_ID = P_DIVISION_ID);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'Division 값이 존재하지 않습니다.';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
    END;

    -- 기능과 버전이 안맞는 경우 ( 생성 : SP_W, BP_M 만 가능, 복사, 삭제 : REPORT_로 시작하는 버전만 가능 )
    IF P_ACTION_TYPE IN ('CP', 'D') THEN
        BEGIN
            SELECT 1 INTO v_exists FROM DUAL
            WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MDF_VERSION
                          WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := 'VERSION 값이 존재하지 않습니다.';
                D_EVENT_DATE  := SYSDATE;
                BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
        END;
    END IF;

    IF P_ACTION_TYPE = 'CR' THEN
        BEGIN
            SELECT 1 INTO v_exists FROM DUAL
            WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MST_VERSION
                          WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := 'VERSION 값이 존재하지 않습니다.';
                D_EVENT_DATE  := SYSDATE;
                BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
        END;
    END IF;

    -- 삭제인데, Send_YN 이 Y 인 경우
    IF P_ACTION_TYPE = 'D' THEN
        BEGIN
            SELECT 1 INTO v_exists FROM DUAL
            WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MDF_VERSION
                          WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND SEND_YN = 'Y');
            -- SEND_YN = 'Y' 존재 → 삭제 불가
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'VERSION 값이 존재하지 않습니다.';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; -- SEND_YN = 'Y' 없으면 정상 진행
        END;
    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                                                                 Validation (END)
    -----------------------------------------------------------------------------------------------------


    -----------------------------------------------------------------------------------------------------
    --     MDF VERSION MST INSERT (BEGIN)
    -----------------------------------------------------------------------------------------------------

    -- 신규생성이나 복사일 경우
    IF P_ACTION_TYPE = 'CR' THEN

        BEGIN
            SELECT MAX(SUBSTR(VERSION_NO, 28, 2))
            INTO   v_rp_version
            FROM   SCM_MGR.DM_MDF_VERSION
            WHERE  DIVISION_ID    = P_DIVISION_ID
            AND    ORI_VERSION_NO = P_VERSION_NO;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rp_version := NULL;
        END;

        IF v_rp_version IS NULL OR v_rp_version = '' THEN
            v_rp_version := '01';
        ELSE
            v_rp_version := LPAD(TO_CHAR(TO_NUMBER(v_rp_version) + 1), 2, '0');
            -- jcnam 임시 테스트 코드: to_number 변환 오류 시 디폴트 값 01
            -- v_rp_version := LPAD(TO_CHAR(NVL(TO_NUMBER(v_rp_version DEFAULT 0 ON CONVERSION ERROR), 0) + 1), 2, '0');
        END IF;

        -- 최종 버전 셋팅
        v_version_x := 'REPORT_' || P_VERSION_NO || '_R' || v_rp_version;

        --dbms_output.put_line('v_version_x:'||v_version_x);


        INSERT INTO SCM_MGR.DM_MDF_VERSION
        (DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, SEND_YN, YYYYMMDD,
         VER_CRE_SEQ, ORI_VERSION_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5)
        SELECT P_DIVISION_ID,
               v_version_x AS VERSION_NO,
               P_VERSION_DESCRIPTION,
               'REPORT_' || VERSION_TYPE AS VERSION_TYPE,
               'N', YYYYMMDD, VER_CRE_SEQ, VERSION_NO,
               P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE,
               NULL, NULL, NULL, NULL, NULL
        FROM   SCM_MGR.DM_MST_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        n_merge_count := SQL%ROWCOUNT;

        --dbms_output.put_line('DM_MDF_VERSION-----------------------');
        --dbms_output.put_line('n_merge_count:'||n_merge_count);


        --[PREPARE] 환율 정보 copy
        INSERT INTO SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT DIVISION_ID, v_version_x AS VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
               CREATED_BY, CREATION_DATE, P_CREATED_BY, SYSDATE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        FROM   SCM_MGR.DM_BP_EXCHANGE_RATE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        n_merge_count := n_merge_count +  SQL%ROWCOUNT;

        --dbms_output.put_line('DM_PLN_SALES_REPORT_EXCHANGE_C-----------------------');
        --dbms_output.put_line('n_merge_count:'||n_merge_count);


    ELSIF P_ACTION_TYPE = 'CP' THEN

        SELECT ORI_VERSION_NO
        INTO   V_ORI_VERSION
        FROM   SCM_MGR.DM_MDF_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = SUBSTR(P_VERSION_NO, 1, 29)
        AND    ROWNUM = 1;

        BEGIN
            SELECT MAX(SUBSTR(VERSION_NO, 28, 2))
            INTO   v_rp_version
            FROM   SCM_MGR.DM_MDF_VERSION
            WHERE  DIVISION_ID    = P_DIVISION_ID
            AND    ORI_VERSION_NO = V_ORI_VERSION;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rp_version := NULL;
        END;

        IF v_rp_version IS NULL OR v_rp_version = '' THEN
            v_rp_version := '01';
        ELSE
            v_rp_version := LPAD(TO_CHAR(TO_NUMBER(v_rp_version) + 1), 2, '0');
        END IF;

        -- 최종 버전 셋팅
        v_version_x := SUBSTR('REPORT_' || REPLACE(P_VERSION_NO, 'REPORT_', ''), 1, 25) || '_R' || v_rp_version;

        INSERT INTO SCM_MGR.DM_MDF_VERSION
        (DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, SEND_YN, YYYYMMDD,
         VER_CRE_SEQ, ORI_VERSION_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5)
        SELECT P_DIVISION_ID,
               v_version_x AS VERSION_NO,
               P_VERSION_DESCRIPTION,
               'REPORT_' || VERSION_TYPE AS VERSION_TYPE,
               'N', YYYYMMDD,
               VER_CRE_SEQ, VERSION_NO, P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE,
               NULL, NULL, NULL, NULL, NULL
        FROM   SCM_MGR.DM_MST_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = V_ORI_VERSION;

        n_merge_count := SQL%ROWCOUNT;

        --[PREPARE] 환율 정보 copy
        INSERT INTO SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT DIVISION_ID, v_version_x AS VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
               CREATED_BY, CREATION_DATE, P_CREATED_BY, SYSDATE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        FROM   SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

    ELSE  -- 삭제일 경우

        UPDATE SCM_MGR.DM_MDF_VERSION
        SET    SEND_YN = 'D'
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        DELETE FROM SCM_MGR.DM_PLN_BP_FCST_REPORT_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        --[PREPARE] 환율 정보 Delete
        DELETE FROM SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                                                     MDF VERSION MST INSERT (END)
    -----------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------


    IF P_ACTION_TYPE = 'CR' THEN

        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_0044_BP_FCST_01
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
         PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,
         FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID,
         YYYYMM, QTY, OWNER)
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD,
               A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
               A.FCST_TYPE, A.INCOTERMS, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID,
               A.YYYYMM, SUM(A.QTY) AS QTY,
               (SELECT TRIM(SUBSTR(B.OWNER, 1, NVL(NULLIF(INSTR(B.OWNER, ','), 0), LENGTH(B.OWNER) + 1) - 1))
                FROM   SCM_MGR.SCM_MST_SITE_ITEM B
                WHERE  B.DIVISION_ID  = A.DIVISION_ID
                AND    B.PROJECT_CODE = A.PROJECT_CODE
                AND    B.SCM_SITE_ID  = A.SCM_SITE_ID
                AND    B.ITEM_ID      = A.ITEM_ID
                AND    ROWNUM = 1
               ) AS OWNER  -- 멀티OWNER인경우 1명만 추출
        FROM   SCM_MGR.DM_PLN_BP_FCST_C A
        WHERE  A.VERSION_NO   = P_VERSION_NO
        AND    A.MEASURE IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'Business_Plan')
        AND    A.DIVISION_ID  = P_DIVISION_ID
        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD,
                 A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
                 A.FCST_TYPE, A.INCOTERMS, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID,
                 A.YYYYMM;

        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        INSERT INTO SCM_MGR.GT_0044_BP_FCST_02
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
         PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,
         FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID,
         YYYYMM, QTY, OWNER,
         DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME,
         CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1, COMPANY_ID)
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD,
               A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
               A.FCST_TYPE, A.INCOTERMS, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID,
               A.YYYYMM, A.QTY, A.OWNER,
               NVL((SELECT DU.UPPER_DEPT_ID
                    FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU
                    WHERE DU.VALID_YN = 'Y'
                    AND   DU.DEPT_ID = (SELECT SU.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU WHERE A.OWNER = SU.USER_ID AND ROWNUM = 1)
                    AND   ROWNUM = 1), '-') AS DEPARTMENT_ID,
               NVL((SELECT DU2.DEPT_NAME_KO
                    FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU2
                    WHERE DU2.VALID_YN = 'Y'
                    AND   DU2.DEPT_ID = (SELECT DU3.UPPER_DEPT_ID
                                         FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU3
                                         WHERE DU3.VALID_YN = 'Y'
                                         AND   DU3.DEPT_ID = (SELECT SU2.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU2 WHERE A.OWNER = SU2.USER_ID AND ROWNUM = 1)
                                         AND   ROWNUM = 1)
                    AND   ROWNUM = 1), '-') AS DEPARTMENT_NAME,
               NVL((SELECT SU3.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU3 WHERE A.OWNER = SU3.USER_ID AND ROWNUM = 1), '-') AS DEPT_ID,
               NVL((SELECT DU4.DEPT_NAME_KO
                    FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU4
                    WHERE DU4.VALID_YN = 'Y'
                    AND   DU4.DEPT_ID = (SELECT SU4.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU4 WHERE A.OWNER = SU4.USER_ID AND ROWNUM = 1)
                    AND   ROWNUM = 1), '-') AS DEPT_NAME,
               NVL(LU.ATTRIBUTE2, '-')  AS CUST_REPORT,       -- Cust. (Report)
               NVL(SI.ATTRIBUTE2, '-')     AS END_CUST_REPORT,   -- End Cust.(Report)
               NVL(LU.ATTRIBUTE3, '-')  AS PRODUCT_GROUP,     -- Product Gr.(Report)
               CASE WHEN NVL(LU.ATTRIBUTE4, '-') <> '-' THEN NVL(LU.ATTRIBUTE4, '-') ELSE NVL(LU.ATTRIBUTE5, '-') END AS ATTRIBUTE1,  -- Pouch Gr.(Report)
               --, NVL(LU.ATTRIBUTE5,'-')    AS ATTRIBUTE2       -- Cyl Gr. (Report)
               NVL(B.COMPANY_ID, '-') AS COMPANY_ID
        FROM   SCM_MGR.GT_0044_BP_FCST_01 A
        LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
            ON  A.DIVISION_ID  = SI.DIVISION_ID
            AND A.SCM_SITE_ID  = SI.SCM_SITE_ID
            AND A.PROJECT_CODE = SI.PROJECT_CODE
            AND A.ITEM_ID      = SI.ITEM_ID
            AND SI.VALID_YN    = 'Y'
        LEFT JOIN (SELECT * FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'SALES_SITE_REPORT_GROUP') LU
            ON  A.DIVISION_ID  = LU.SEGMENT1    -- PK컬럼1
            AND A.PROJECT_CODE = LU.SEGMENT2    -- PK컬럼2
            AND A.SCM_SITE_ID  = LU.SEGMENT3    -- PK컬럼3
            AND A.ITEM_ID      = LU.SEGMENT4    -- PK컬럼4
        LEFT JOIN SCM_MGR.SCM_MST_SITE B
            ON  A.DIVISION_ID  = B.DIVISION_ID
            AND A.SCM_SITE_ID  = B.SCM_SITE_ID;

        -- Dept_ID 나 Department_ID 가 없는 건들 삭제
        DELETE FROM SCM_MGR.GT_0044_BP_FCST_02 WHERE DEPARTMENT_ID = '-' OR DEPT_ID = '-';

        -- GTT를 다른 테이블과 JOIN 하므로 통계 수집
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_BP_FCST_02', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname => 'SCM_MGR', tabname => 'GT_0044_BP_FCST_02',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
        );

        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT '1' AS DATA_TYPE, A.DIVISION_ID, v_version_x AS VERSION_NO, 'REPORT_' || A.CUTOFF_TYPE AS CUTOFF_TYPE,
               A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
               A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
               A.PROJECT_CODE, '-' AS PROJECT_NAME, NVL(MAX(A.SCM_SITE_ID), '-'), A.ITEM_ID, NVL(MAX(A.DOM_EXP), '-'),
               NVL(MAX(A.FCST_TYPE), '-'), NVL(MAX(A.INCOTERMS), '-'), A.MEASURE, NVL(MAX(A.PLANT_SITE_ID), '-'),
               A.YYYYMM, A.CURRENCY, SUM(QTY) AS QTY, v_created_by,
               SYSDATE, v_created_by, SYSDATE, MAX(A.ATTRIBUTE1), NVL(A.COMPANY_ID, '-')
        FROM   SCM_MGR.GT_0044_BP_FCST_02 A
        GROUP BY A.DIVISION_ID, A.CUTOFF_TYPE,
                 A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
                 A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
                 A.PROJECT_CODE, A.ITEM_ID, A.MEASURE,
                 A.YYYYMM, A.CURRENCY, A.COMPANY_ID;

        n_merge_count := n_merge_count + SQL%ROWCOUNT;

        -- UNIT Price ( LOC ) 를 생성해준다. ( 월단위 )
        -- RTF 가 있는 품목들에 대해서 Unit Price ( LOC ) 를 만들어준다. SalesAmt_LOC / RTF = Unit Price ( LOCAL )

        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT '1' AS DATA_TYPE, A.DIVISION_ID, v_version_x AS VERSION_NO, 'REPORT_' || A.CUTOFF_TYPE AS CUTOFF_TYPE,
               A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
               A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
               A.PROJECT_CODE, '-' AS PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
               A.FCST_TYPE, NVL(A.INCOTERMS, '-') AS INCOTERMS, 'LOC' AS MEASURE, A.PLANT_SITE_ID,
               A.YYYYMM, A.CURRENCY,
               CASE WHEN B.QTY <> 0 THEN ROUND(A.QTY / B.QTY, 0) ELSE 0 END,
               v_created_by,
               SYSDATE, v_created_by, SYSDATE, A.ATTRIBUTE1, NVL(A.COMPANY_ID, '-')
        FROM   SCM_MGR.GT_0044_BP_FCST_02 A
        JOIN   SCM_MGR.GT_0044_BP_FCST_02 B
            ON  A.DIVISION_ID     = B.DIVISION_ID
            AND A.DEPARTMENT_ID   = B.DEPARTMENT_ID
            AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
            AND A.DEPT_ID         = B.DEPT_ID
            AND A.DEPT_NAME       = B.DEPT_NAME
            AND A.END_CUST_REPORT = B.END_CUST_REPORT
            AND A.CUST_REPORT     = B.CUST_REPORT
            AND A.PRODUCT_GROUP   = B.PRODUCT_GROUP
            AND A.PROJECT_CODE    = B.PROJECT_CODE
            AND A.SCM_SITE_ID    = B.SCM_SITE_ID
            AND A.ITEM_ID        = B.ITEM_ID
            AND A.YYYYMM         = B.YYYYMM
            AND A.COMPANY_ID     = B.COMPANY_ID
            AND A.CURRENCY       = B.CURRENCY
        WHERE  A.MEASURE = 'SalesAmt_LOC'
        AND    B.MEASURE = 'Business_Plan';

        n_merge_count := n_merge_count + SQL%ROWCOUNT;

        -----------------------------------------------------------------------------------------------------
        --                                                                           요청VERSION COPY (END)
        -----------------------------------------------------------------------------------------------------

        -----------------------------------------------------------------------------------------------------
        --                                 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy (START)
        -----------------------------------------------------------------------------------------------------
        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT A.DATA_TYPE, A.DIVISION_ID, v_version_x, A.CUTOFF_TYPE,
               A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'),
               NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-'), NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'),
               NVL(A.PROJECT_CODE, '-'), NVL(MAX(A.PROJECT_NAME), '-'), NVL(MAX(A.SCM_SITE_ID), '-'), A.ITEM_ID, NVL(MAX(DOM_EXP), '-'),
               NVL(MAX(A.FCST_TYPE), '-'), NVL(MAX(A.INCOTERMS), '-'), A.MEASURE, NVL(MAX(A.PLANT_SITE_ID), '-'),
               YYYYMM, CURRENCY, SUM(QTY), NVL(MAX(A.CREATED_BY), '-'),
               MAX(A.CREATION_DATE), NVL(MAX(A.LAST_UPDATED_BY), '-'), MAX(A.LAST_UPDATE_DATE), MAX(A.ATTRIBUTE1),
               NVL(NVL(A.COMPANY_ID, B.COMPANY_ID), '-')
        FROM   SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        LEFT JOIN SCM_MGR.SCM_MST_SITE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND A.SCM_SITE_ID = B.SCM_SITE_ID
        WHERE  A.DIVISION_ID = P_DIVISION_ID
        AND    A.VERSION_NO  = (SELECT MAX(VERSION_NO)
                                FROM   SCM_MGR.DM_PLN_BP_FCST_REPORT_C
                                WHERE  CUTOFF_TYPE = 'REPORT_BP_M'
                                AND    DATA_TYPE   = '2')
        AND    A.CUTOFF_TYPE = 'REPORT_BP_M'
        AND    A.DATA_TYPE   = '2'
        GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.CUTOFF_TYPE,
                 A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
                 A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
                 A.PROJECT_CODE, A.ITEM_ID, A.MEASURE,
                 A.YYYYMM, A.CURRENCY, NVL(NVL(A.COMPANY_ID, B.COMPANY_ID), '-');

        n_merge_count := n_merge_count + SQL%ROWCOUNT;


    ELSIF P_ACTION_TYPE = 'CP' THEN

        -- PK 변경전의 DATA 를 COPY 하는 경우때문에 GROUP BY  처리함
        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT A.DATA_TYPE, A.DIVISION_ID, v_version_x, A.CUTOFF_TYPE,
               A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'),
               NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-'), NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'),
               NVL(A.PROJECT_CODE, '-'), NVL(MAX(A.PROJECT_NAME), '-'), NVL(MAX(A.SCM_SITE_ID), '-'), A.ITEM_ID, NVL(MAX(DOM_EXP), '-'),
               NVL(MAX(A.FCST_TYPE), '-'), NVL(MAX(A.INCOTERMS), '-'), A.MEASURE, NVL(MAX(A.PLANT_SITE_ID), '-'),
               YYYYMM, CURRENCY, SUM(QTY), NVL(MAX(A.CREATED_BY), '-'),
               MAX(A.CREATION_DATE), NVL(MAX(A.LAST_UPDATED_BY), '-'), MAX(A.LAST_UPDATE_DATE), MAX(A.ATTRIBUTE1),
               NVL(A.COMPANY_ID, '-')
        FROM   SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        WHERE  A.DIVISION_ID = P_DIVISION_ID
        AND    A.VERSION_NO  = P_VERSION_NO
        GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.CUTOFF_TYPE,
                 A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
                 A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
                 A.PROJECT_CODE, A.ITEM_ID, A.MEASURE,
                 A.YYYYMM, A.CURRENCY, A.COMPANY_ID;

        n_merge_count := SQL%ROWCOUNT;
        -- dbms_output.put_line('-----------------------P_DIVISION_ID:'||P_DIVISION_ID||', P_VERSION_NO:'||P_VERSION_NO);
        -- dbms_output.put_line('-----------------------CP8--'||n_merge_count);


    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy (END)
    -----------------------------------------------------------------------------------------------------

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;
    -- N_LOG_COUNT := n_delete_count + n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'         VALUE P_DIVISION_ID,
            'P_VERSION_NO'          VALUE P_VERSION_NO,
            'P_VERSION_DESCRIPTION' VALUE P_VERSION_DESCRIPTION,
            'P_CREATED_BY'          VALUE P_CREATED_BY,
            'P_ACTION_TYPE'         VALUE P_ACTION_TYPE
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0044_SAVE_BIZ_PLAN_VERSION_COPY;