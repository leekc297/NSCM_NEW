CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_SAVE_SALES_PLAN_REPORT_C_CF" 
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_CUTOFF_TYPE           IN  VARCHAR2,
    P_CUTOFF_YYYYMMDD       IN  VARCHAR2,
    P_DEPARTMENT_ID         IN  VARCHAR2,
    P_DEPARTMENT_NAME       IN  VARCHAR2,
    P_DEPT_ID               IN  VARCHAR2,
    P_DEPT_NAME             IN  VARCHAR2,
    P_END_CUST_REPORT       IN  VARCHAR2,
    P_CUST_REPORT           IN  VARCHAR2,
    P_PRODUCT_GROUP         IN  VARCHAR2,
    P_ITEM_ID               IN  VARCHAR2,
    P_MEASURE               IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_QTY                   IN  VARCHAR2,
    P_SCM_SITE_ID           IN  VARCHAR2,
    P_PROJECT_CODE          IN  VARCHAR2,
    P_COMPANY_ID            IN  VARCHAR2,
    P_FCST_TYPE             IN  VARCHAR2,
    P_INCOTERMS             IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*============================================================================================================================
 * Program ID   : DMF0044_SAVE_SALES_PLAN_REPORT_C_CF
 * Description  : 'DM_PLN_SALES_PLAN_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *============================================================================================================================
 *   Date       In Charge      Description
 *============================================================================================================================
 * 2020/01/17	HWI1993			SCM_SITE_ID, COMPANY_ID, PROJECT_CODE 추가하면서 이름 변경함 - DMF0044_SAVE_SALES_PLAN_REPORT_C_CF ( Cutoff Data 전용임 )
 * 2020/03/26	hwi1993			department_name, dept_name 을 join 조건에서 제거함 ( lookup 적용으로 인해 같은 코드인데 화면과 db data 가 다를 수 있음
 * 2020/05/22	hwi1993			Save 이후에 Transfer 처리
 * 2020/06/18	hwi1993			81번 로직 분리
 * 2020/09/09   P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020/09/18	HWI1993			[C20200909-000188] YYYYMMDD 를 영업일로 변환하는 로직 제거 LEFT(YYYYMMDD, 6) + '01' 로 변경
 * 2020/10/05	HWI1993			[C20201005-000291] Sales Report 대량 변경시 Time out 문제, QTY DATA TYPE 도 NUMERIC(30,10) 으로 변경
 * 2021/07/23	HWI1993			상반기과제 - 소형 마스터 정비
 * 2022/04/13   HWI1993			GM JV 작업
 * 2023/09/07	JSSBAE			[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청
 * 2024/05/09	JSSBAE			[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2025/05/09   JSSBAE			[E20250418-001567]_40사업부 Sales Report, ETC Report 개선
 * 2026.03.24   jcnam           [PJ20264226] NextSCM Pilot 설계 및 개발
 *============================================================================================================================*/
IS
    -----------------------------------------------------------------------------------------------
    -- 스플릿관련 변수
    -----------------------------------------------------------------------------------------------
    V_ACTIVE_FLAG           VARCHAR2(1 CHAR);
    V_DIVISION_ID           VARCHAR2(30 CHAR);
    V_VERSION_NO            VARCHAR2(30 CHAR);
    V_CUTOFF_TYPE           VARCHAR2(20 CHAR);
    V_CUTOFF_YYYYMMDD       VARCHAR2(8 CHAR);
    V_DEPARTMENT_ID         VARCHAR2(10 CHAR);
    V_DEPARTMENT_NAME       VARCHAR2(50 CHAR);
    V_DEPT_ID               VARCHAR2(10 CHAR);
    V_DEPT_NAME             VARCHAR2(50 CHAR);
    V_END_CUST_REPORT       VARCHAR2(30 CHAR);

    V_CUST_REPORT           VARCHAR2(30 CHAR);
    V_PRODUCT_GROUP         VARCHAR2(30 CHAR);
    V_ITEM_ID               VARCHAR2(50 CHAR);
    V_MEASURE               VARCHAR2(20 CHAR);
    V_YYYYMMDD              VARCHAR2(8 CHAR);
    V_CURRENCY              VARCHAR2(5 CHAR);
    V_QTY                   VARCHAR2(40 CHAR);
    V_SCM_SITE_ID           VARCHAR2(30 CHAR);
    V_PROJECT_CODE          VARCHAR2(30 CHAR);
    V_COMPANY_ID            VARCHAR2(30 CHAR);

    V_FCST_TYPE             VARCHAR2(10 CHAR);
    V_INCOTERMS             VARCHAR2(10 CHAR);
    V_CREATED_BY            VARCHAR2(150 CHAR);
    V_ORI_VERSION_NO        VARCHAR2(50 CHAR);
    V_DELIMITER             VARCHAR2(1 CHAR) := '^';

    -----------------------------------------------------------------------------------------------
    -- LOG 용 변수 설정
    -----------------------------------------------------------------------------------------------
    V_PROGRAM_NAME          VARCHAR2(200 CHAR);
    V_LOG_TYPE              VARCHAR2(100 CHAR);
    N_LOG_COUNT             PLS_INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(4000 CHAR);
    V_DESCRIPTION           VARCHAR2(4000 CHAR);
    D_EVENT_DATE            DATE := SYSDATE;
    N_DELETE_COUNT          PLS_INTEGER := 0;
    N_INSERT_COUNT          PLS_INTEGER := 0;
    N_INPUT_COUNT           PLS_INTEGER := 0;
    N_LOGO_COUNT            PLS_INTEGER := 0;
    -- [PATCH] 히스토리 테이블 INSERT 카운트 (신규 추가)
    N_HISTORY_COUNT         PLS_INTEGER := 0;

    -----------------------------------------------------------------------------------------------
    --계산용 변수
    -----------------------------------------------------------------------------------------------
    V_I                     PLS_INTEGER;
    V_CNT                   PLS_INTEGER;
    V_ADJQTY                NUMBER(30,10);
    V_REST                  NUMBER(30,10);
    V_ORIQTY                NUMBER(30,10);
    V_QTYCNT                PLS_INTEGER;
    V_MINDATE               VARCHAR2(8 CHAR);
    V_PLAN_YN               VARCHAR2(1 CHAR);
    V_LOC_SALESAMT_LOC      NUMBER(30,10);
    V_LOC_RTF               NUMBER(30,10);
    V_LOC_PRICE             NUMBER(30,10);

    V_EXISTS                PLS_INTEGER;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);
    V_SQL_CODE              VARCHAR2(100 CHAR);
    V_SQL_ERRMSG            VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -----------------------------------------------------------------------------------------------
    -- GTT 초기화 (이후에 일반 테이블 DML이 있으므로 DELETE FROM 사용)
    -----------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.GT_0044_RESULTS_MST_C;

    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_RESULTS_MST_C', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    --=============================================================================================
    -- 시작 LOG  (START)
    --=============================================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    --=============================================================================================
    --#results_MST 테이블에 split후 insert (START)
    --=============================================================================================
    INSERT INTO SCM_MGR.GT_0044_RESULTS_MST_C
    ( ACTIVE_FLAG, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
      DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT,
      CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, DOM_EXP,
      FCST_TYPE, INCOTERMS, ITEM_ID, MEASURE, YYYYMMDD,
      CURRENCY, QTY, COMPANY_ID, CREATED_BY )
    SELECT TRIM(A_ACTIVE_FLAG), TRIM(A_DIVISION_ID), TRIM(A_VERSION_NO), TRIM(A_CUTOFF_TYPE), TRIM(A_CUTOFF_YYYYMMDD),
           TRIM(A_DEPARTMENT_ID), TRIM(A_DEPARTMENT_NAME), TRIM(A_DEPT_ID), TRIM(A_DEPT_NAME), TRIM(A_END_CUST_REPORT),
           TRIM(A_CUST_REPORT), TRIM(A_PRODUCT_GROUP), TRIM(A_PROJECT_CODE), TRIM(A_SCM_SITE_ID), '-',
           TRIM(A_FCST_TYPE), TRIM(A_INCOTERMS), TRIM(A_ITEM_ID), TRIM(A_MEASURE),
           SUBSTR(TRIM(A_YYYYMMDD), 1, 6) || '01',
           TRIM(A_CURRENCY),
           CASE WHEN TRIM(A_QTY) IS NULL OR TRIM(A_QTY) = '' THEN '0' ELSE TRIM(A_QTY) END,
           TRIM(A_COMPANY_ID), TRIM(A_CREATED_BY)
    FROM (
        SELECT REGEXP_SUBSTR(P_ACTIVE_FLAG,      '[^^]+', 1, LEVEL) AS A_ACTIVE_FLAG,
               REGEXP_SUBSTR(P_DIVISION_ID,      '[^^]+', 1, LEVEL) AS A_DIVISION_ID,
               REGEXP_SUBSTR(P_VERSION_NO,       '[^^]+', 1, LEVEL) AS A_VERSION_NO,
               REGEXP_SUBSTR(P_CUTOFF_TYPE,      '[^^]+', 1, LEVEL) AS A_CUTOFF_TYPE,
               REGEXP_SUBSTR(P_CUTOFF_YYYYMMDD,  '[^^]+', 1, LEVEL) AS A_CUTOFF_YYYYMMDD,
               REGEXP_SUBSTR(P_DEPARTMENT_ID,    '[^^]+', 1, LEVEL) AS A_DEPARTMENT_ID,
               REGEXP_SUBSTR(P_DEPARTMENT_NAME,  '[^^]+', 1, LEVEL) AS A_DEPARTMENT_NAME,
               REGEXP_SUBSTR(P_DEPT_ID,          '[^^]+', 1, LEVEL) AS A_DEPT_ID,
               REGEXP_SUBSTR(P_DEPT_NAME,        '[^^]+', 1, LEVEL) AS A_DEPT_NAME,
               REGEXP_SUBSTR(P_END_CUST_REPORT,  '[^^]+', 1, LEVEL) AS A_END_CUST_REPORT,
               REGEXP_SUBSTR(P_CUST_REPORT,      '[^^]+', 1, LEVEL) AS A_CUST_REPORT,
               REGEXP_SUBSTR(P_PRODUCT_GROUP,    '[^^]+', 1, LEVEL) AS A_PRODUCT_GROUP,
               REGEXP_SUBSTR(P_ITEM_ID,          '[^^]+', 1, LEVEL) AS A_ITEM_ID,
               REGEXP_SUBSTR(P_MEASURE,          '[^^]+', 1, LEVEL) AS A_MEASURE,
               REGEXP_SUBSTR(P_YYYYMMDD,         '[^^]+', 1, LEVEL) AS A_YYYYMMDD,
               REGEXP_SUBSTR(P_CURRENCY,         '[^^]+', 1, LEVEL) AS A_CURRENCY,
               REGEXP_SUBSTR(P_QTY,              '[^^]+', 1, LEVEL) AS A_QTY,
               REGEXP_SUBSTR(P_SCM_SITE_ID,      '[^^]+', 1, LEVEL) AS A_SCM_SITE_ID,
               REGEXP_SUBSTR(P_PROJECT_CODE,     '[^^]+', 1, LEVEL) AS A_PROJECT_CODE,
               REGEXP_SUBSTR(P_COMPANY_ID,       '[^^]+', 1, LEVEL) AS A_COMPANY_ID,
               REGEXP_SUBSTR(P_FCST_TYPE,        '[^^]+', 1, LEVEL) AS A_FCST_TYPE,
               REGEXP_SUBSTR(P_INCOTERMS,        '[^^]+', 1, LEVEL) AS A_INCOTERMS,
               REGEXP_SUBSTR(P_CREATED_BY,       '[^^]+', 1, LEVEL) AS A_CREATED_BY
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^^]+', 1, LEVEL) IS NOT NULL
    );
    --=============================================================================================
    --#results_MST 테이블에 split후 insert (END)
    --=============================================================================================

    -- 공통 변수 보관 (첫번째 토큰)
    V_DIVISION_ID      := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,     '[^^]+', 1, 1));
    V_VERSION_NO       := TRIM(REGEXP_SUBSTR(P_VERSION_NO,      '[^^]+', 1, 1));
    V_CUTOFF_TYPE      := TRIM(REGEXP_SUBSTR(P_CUTOFF_TYPE,     '[^^]+', 1, 1));
    V_CUTOFF_YYYYMMDD  := TRIM(REGEXP_SUBSTR(P_CUTOFF_YYYYMMDD, '[^^]+', 1, 1));
    V_CREATED_BY       := TRIM(REGEXP_SUBSTR(P_CREATED_BY,      '[^^]+', 1, 1));

    -----------------------------------------------------------------------------------------------
    --ORI_VERSION_NO을 조회하여 변수에 보관한다.
    -----------------------------------------------------------------------------------------------
    BEGIN
        SELECT ORI_VERSION_NO INTO V_ORI_VERSION_NO
        FROM   SCM_MGR.DM_MDF_VERSION
        WHERE  VERSION_TYPE = V_CUTOFF_TYPE
        AND    VERSION_NO   = V_VERSION_NO
        AND    ROWNUM       = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL;
    END;

    -----------------------------------------------------------------------------------------------
    -- 처리할 데이터에 순번을 넣어준다. ( 메저들을 묶어서 한 세트로 )
    -----------------------------------------------------------------------------------------------
    FOR REC IN (
        SELECT ROWID AS RID,
               DENSE_RANK() OVER ( ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
                                             DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID,
                                             ITEM_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY ) AS NEW_SEQ_RANK
        FROM SCM_MGR.GT_0044_RESULTS_MST_C
    ) LOOP
        UPDATE SCM_MGR.GT_0044_RESULTS_MST_C SET SEQ_RANK = REC.NEW_SEQ_RANK WHERE ROWID = REC.RID;
    END LOOP;

    FOR REC IN (
        SELECT ROWID AS RID,
               ROW_NUMBER() OVER ( PARTITION BY SEQ_RANK
                                   ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
                                            DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID,
                                            ITEM_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY ) AS NEW_SEQ_ROWNUM
        FROM SCM_MGR.GT_0044_RESULTS_MST_C
    ) LOOP
        UPDATE SCM_MGR.GT_0044_RESULTS_MST_C SET SEQ_ROWNUM = REC.NEW_SEQ_ROWNUM WHERE ROWID = REC.RID;
    END LOOP;

    -----------------------------------------------------------------------------------------------
    -- 계획구간 여부 UPDATE
    -----------------------------------------------------------------------------------------------
    UPDATE SCM_MGR.GT_0044_RESULTS_MST_C
    SET PLAN_YN = CASE WHEN SUBSTR(YYYYMMDD, 1, 6) >= TO_CHAR(SYSDATE, 'YYYYMM') THEN 'Y' ELSE 'N' END;

    SELECT COUNT(ACTIVE_FLAG) INTO N_INPUT_COUNT FROM SCM_MGR.GT_0044_RESULTS_MST_C;

    -- GTT INSERT 후 통계 수집 (JOIN 사용)
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname => 'SCM_MGR', tabname => 'GT_0044_RESULTS_MST_C',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    --=============================================================================================
    --DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (START)
    --=============================================================================================
    IF V_CUTOFF_TYPE = 'REPORT_SP_W' THEN
        -----------------------------------------------------------------------------------------------
        -- 초기화
        -----------------------------------------------------------------------------------------------
        V_I := 1; V_CNT := 0; V_ADJQTY := 0; V_REST := 0; V_ORIQTY := 0; V_QTYCNT := 0; V_MINDATE := NULL; V_PLAN_YN := 'N';

        SELECT NVL(MAX(SEQ_RANK), 0) INTO V_CNT FROM SCM_MGR.GT_0044_RESULTS_MST_C;

        IF V_DIVISION_ID = '40' THEN
            WHILE V_I <= V_CNT LOOP
                BEGIN
                    SELECT PLAN_YN INTO V_PLAN_YN
                    FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND ROWNUM = 1;
                EXCEPTION WHEN NO_DATA_FOUND THEN V_PLAN_YN := 'N';
                END;

                -----------------------------------------------------------------------------------------------
                -- Pricce 가 변경된 경우 ( 계획구간 ) -- 일단 Price 만 업데이트
                -----------------------------------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'LOC');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    -----------------------------------------------------------------------------------------------
                    -- LOC 가 있으면 업데이트, 없으면 인서트
                    -----------------------------------------------------------------------------------------------
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'LOC' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                   WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID
                                   AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                   AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                                   AND B.PRODUCT_GROUP = A.PRODUCT_GROUP AND B.PROJECT_CODE = A.PROJECT_CODE
                                   AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                   AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%'
                                   AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                   AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID
                            AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                            AND B.PRODUCT_GROUP = A.PRODUCT_GROUP AND B.PROJECT_CODE = A.PROJECT_CODE
                            AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%'
                            AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                    ELSE
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'LOC', '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.SEQ_RANK = V_I AND B.MEASURE = 'LOC'
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------------------------------
                -- 수량등이 변경된 건이 있을 경우 기존 데이터의 비율대로 배부하고 남은건을 첫번째 날짜에 몰아준다.
                -----------------------------------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE IN ('RTF', 'RTF_SYS_RP'));

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C
                    WHERE SEQ_RANK = V_I AND MEASURE IN ('RTF', 'RTF_SYS_RP') AND ROWNUM = 1;

                    -----------------------------------------------------------------------------------------------
                    -- 수정전 DM_PLN_SALES_PLAN_REPORT_C 테이블의 수량 합계, 건수 계산
                    -----------------------------------------------------------------------------------------------
                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD)
                    INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    -----------------------------------------------------------------------------------------------
                    -- 수정후 수량 = 수정된 총수량 * 원래개별수량/원래총수량
                    -----------------------------------------------------------------------------------------------
                    IF NVL(V_ORIQTY,0) <> 0 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        --나머지 배부
                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -----------------------------------------------------------------------------------------------
                        -- RTF 가 원래 없었을 경우
                        -----------------------------------------------------------------------------------------------
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), B.MEASURE, '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE IN ('RTF', 'RTF_SYS_RP') AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------
                -- 금액처리_SalesAmt_LOC ( 여기서는 Qty 변수들을 Amnt 로 활용한다. )
                -----------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_LOC');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    V_ADJQTY := 0; V_REST := 0;
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1;

                    -- 수정전 금액 합계, 건수 계산
                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    V_EXISTS := 0;
                    BEGIN
                        SELECT 1 INTO V_EXISTS FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA
                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB
                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID
                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP
                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID
                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'
                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE
                             AND BB.SEQ_RANK = V_I
                            WHERE AA.MEASURE = 'SalesAmt_LOC' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO
                        );
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                    END;
                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        --나머지 배부
                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -- 원래 SalesAmt_LOC 메저가 없었던 경우
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'SalesAmt_LOC', '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE = 'SalesAmt_LOC' AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------
                -- 금액처리_SalesAmt_KRW
                -----------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_KRW');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_KRW' AND ROWNUM = 1;

                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    V_EXISTS := 0;
                    BEGIN
                        SELECT 1 INTO V_EXISTS FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA
                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB
                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID
                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP
                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID
                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'
                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE
                             AND BB.SEQ_RANK = V_I
                            WHERE AA.MEASURE = 'SalesAmt_KRW' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO
                        );
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                    END;
                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -- 원래 SalesAmt_KRW 메저가 없었던 경우
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'SalesAmt_KRW', '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE = 'SalesAmt_KRW' AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------
                -- 금액처리_SalesAmt_USD
                -----------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_USD');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_USD' AND ROWNUM = 1;

                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    V_EXISTS := 0;
                    BEGIN
                        SELECT 1 INTO V_EXISTS FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA
                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB
                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID
                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP
                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID
                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'
                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE
                             AND BB.SEQ_RANK = V_I
                            WHERE AA.MEASURE = 'SalesAmt_USD' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO
                        );
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                    END;
                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -- 원래 SalesAmt_USD 메저가 없었던 경우
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'SalesAmt_USD', '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE = 'SalesAmt_USD' AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                --====================================================================================================================================================
                --여기부터는 구간 일괄 업데이트
                --====================================================================================================================================================
                IF V_PLAN_YN = 'Y' THEN
                    -----------------------------------------------------------------------------------------------
                    -- 계획구간은 금액을 업데이트함 ( LOC )
                    -----------------------------------------------------------------------------------------------
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'SalesAmt_LOC' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT C.QTY * D.QTY
                                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C, SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C D
                                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID
                                   AND C.MEASURE IN ('RTF', 'RTF_SYS_RP')
                                   AND D.VERSION_NO = A.VERSION_NO AND D.DIVISION_ID = A.DIVISION_ID AND D.DEPARTMENT_ID = A.DEPARTMENT_ID AND D.DEPT_ID = A.DEPT_ID
                                   AND D.END_CUST_REPORT = A.END_CUST_REPORT AND D.CUST_REPORT = A.CUST_REPORT AND D.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND D.PROJECT_CODE = A.PROJECT_CODE AND D.SCM_SITE_ID = A.SCM_SITE_ID AND D.ITEM_ID = A.ITEM_ID
                                   AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = A.CURRENCY AND D.COMPANY_ID = A.COMPANY_ID
                                   AND D.MEASURE = 'LOC' AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.SEQ_RANK = V_I);
                    ELSE
                        -- 계획구간 SalesAmt_LOC INSERT (RTF * LOC)
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID, NVL(C.DEPARTMENT_NAME, '-'), C.DEPT_ID, NVL(C.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(C.DOM_EXP, '-'), NVL(C.FCST_TYPE, '-'), NVL(C.INCOTERMS, '-'), 'SalesAmt_LOC', '-', A.YYYYMMDD
                             , A.CURRENCY, SUM(C.QTY) * MAX(D.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10
                             , C.COMPANY_ID, C.PROJECT_CODE, C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME
                             , C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
                             , C.COUNTRY_KR_NAME, C.ROUTE, NVL(C.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.GT_0044_RESULTS_MST_C A
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                          ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                         AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
                         AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(C.YYYYMMDD,1,6)||'%' AND A.CURRENCY = C.CURRENCY AND A.COMPANY_ID = C.COMPANY_ID
                         AND C.MEASURE IN ('RTF', 'RTF_SYS_RP')
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C D
                          ON A.VERSION_NO = D.VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.DEPARTMENT_ID = D.DEPARTMENT_ID AND A.DEPT_ID = D.DEPT_ID
                         AND A.END_CUST_REPORT = D.END_CUST_REPORT AND A.CUST_REPORT = D.CUST_REPORT AND A.PRODUCT_GROUP = D.PRODUCT_GROUP
                         AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND A.CURRENCY = D.CURRENCY AND A.COMPANY_ID = D.COMPANY_ID
                         AND D.MEASURE = 'LOC'
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.SEQ_RANK = V_I
                        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID
                               , NVL(C.DEPARTMENT_NAME, '-'), C.DEPT_ID, NVL(C.DEPT_NAME, '-'), A.END_CUST_REPORT, A.CUST_REPORT
                               , A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(C.DOM_EXP, '-'), C.FCST_TYPE
                               , NVL(C.INCOTERMS, '-'), A.YYYYMMDD, A.CURRENCY, C.ATTRIBUTE1, C.ATTRIBUTE2
                               , C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7
                               , C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10, C.COMPANY_ID, C.PROJECT_CODE
                               , C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC
                               , C.NICK_NAME, C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME
                               , C.APPLICATION, C.APPLICATION_GR, C.COUNTRY_KR_NAME, C.ROUTE, C.CELL_PROD_SITE;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;

                    -- 계획구간은 금액을 업데이트함 ( KRW ) - SalesAmt_LOC * EXCHANGE
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'SalesAmt_KRW' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
                                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D
                                     ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID
                                    AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID
                                   AND C.MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.SEQ_RANK = V_I);
                    ELSE
                        -- 계획구간 SalesAmt_KRW INSERT
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID, NVL(C.DEPARTMENT_NAME, '-'), C.DEPT_ID, NVL(C.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(C.DOM_EXP, '-'), NVL(C.FCST_TYPE, '-'), NVL(C.INCOTERMS, '-'), 'SalesAmt_KRW', '-', A.YYYYMMDD
                             , A.CURRENCY, ROUND(C.QTY * D.EXCHANGE_PRICE, 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10
                             , C.COMPANY_ID, C.PROJECT_CODE, C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME
                             , C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
                             , C.COUNTRY_KR_NAME, C.ROUTE, NVL(C.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.GT_0044_RESULTS_MST_C A
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                          ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                         AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
                         AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(C.YYYYMMDD,1,6)||'%' AND A.CURRENCY = C.CURRENCY AND A.COMPANY_ID = C.COMPANY_ID
                         AND C.MEASURE = 'SalesAmt_LOC'
                        JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D
                          ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID
                         AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.SEQ_RANK = V_I
                        AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;

                    -- 계획구간은 금액을 업데이트함 ( USD )
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'SalesAmt_USD' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT CASE WHEN NVL(E.EXCHANGE_PRICE,0) <> 0 THEN ROUND(C.QTY * D.EXCHANGE_PRICE / E.EXCHANGE_PRICE, 0) ELSE 0 END
                                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E ON E.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = E.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(E.YYYYMMDD,1,6)||'%' AND E.CURRENCY = 'KRW' AND E.UNIT_CURRENCY = A.CURRENCY
                                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID
                                   AND C.MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.SEQ_RANK = V_I);
                    ELSE
                        -- 계획구간 SalesAmt_USD INSERT
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID, NVL(C.DEPARTMENT_NAME, '-'), C.DEPT_ID, NVL(C.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(C.DOM_EXP, '-'), NVL(C.FCST_TYPE, '-'), NVL(C.INCOTERMS, '-'), 'SalesAmt_USD', '-', A.YYYYMMDD
                             , A.CURRENCY, CASE WHEN NVL(E.EXCHANGE_PRICE,0) <> 0 THEN ROUND(C.QTY * D.EXCHANGE_PRICE / E.EXCHANGE_PRICE, 0) ELSE 0 END
                             , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10
                             , C.COMPANY_ID, C.PROJECT_CODE, C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME
                             , C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
                             , C.COUNTRY_KR_NAME, C.ROUTE, NVL(C.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.GT_0044_RESULTS_MST_C A
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                          ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                         AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
                         AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(C.YYYYMMDD,1,6)||'%' AND A.CURRENCY = C.CURRENCY AND A.COMPANY_ID = C.COMPANY_ID
                         AND C.MEASURE = 'SalesAmt_LOC'
                        JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                        JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E ON E.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = E.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(E.YYYYMMDD,1,6)||'%' AND E.CURRENCY = 'KRW' AND E.UNIT_CURRENCY = A.CURRENCY
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.SEQ_RANK = V_I
                        AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                ELSE
                    -----------------------------------------------------------------------------------------------
                    -- 실적구간은 단가를 업데이트
                    -- SalesAmt_LOC 를 Qty 로 나눠서 단가를 계산한다. ( 본테이블에서 LOC 를 지우고, 다시 계산해서 INSERT 한다. )
                    -----------------------------------------------------------------------------------------------
                    -- INSERT 할 날짜
                    BEGIN
                        SELECT YYYYMMDD INTO V_YYYYMMDD FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND ROWNUM = 1;
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_YYYYMMDD := NULL;
                    END;
                    V_YYYYMMDD := SUBSTR(V_YYYYMMDD, 1, 6) || '01';

                    -- 삭제
                    DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    WHERE A.MEASURE = 'LOC'
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                        WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                        AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                        AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                        AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                        AND B.SEQ_RANK = V_I);
                    N_DELETE_COUNT := N_DELETE_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                    -- SalesAmt_LOC 합산
                    SELECT NVL(SUM(A.QTY),0) INTO V_LOC_SALESAMT_LOC
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND B.SEQ_RANK = V_I AND B.SEQ_ROWNUM = 1 AND A.MEASURE = 'SalesAmt_LOC';

                    SELECT NVL(SUM(A.QTY),0) INTO V_LOC_RTF
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND B.SEQ_RANK = V_I AND B.SEQ_ROWNUM = 1 AND A.MEASURE IN ('RTF', 'RTF_SYS_RP');

                    INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                    ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                    , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                    , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                    , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                    , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                    , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                    SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                         , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'LOC', '-', B.YYYYMMDD
                         , A.CURRENCY, CASE WHEN NVL(V_LOC_RTF, 0) <> 0 THEN ROUND(V_LOC_SALESAMT_LOC / V_LOC_RTF, 3) ELSE 0 END
                         , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                         , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND B.SEQ_RANK = V_I AND B.SEQ_ROWNUM = 1
                    WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                    N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                END IF; -- V_PLAN_YN

                V_I := V_I + 1;
            END LOOP; -- WHILE V_I <= V_CNT (division_id = '40')

        ELSE
            -----------------------------------------------------------------------------------------------
            -- 자동차 ESS ( 데이터는 1일자에만 들어있고, 수정은 계획구간의 LOC 만 가능 )
            -- 자동차는 Product_group 을 조건에서 제외함
            -- *** 이 분기는 원본 MSSQL A030~A036 영역에 해당하며 동일 패턴으로 변환 ***
            -- (분량 제약으로 동일 패턴의 반복 코드는 축약 표기하되, 실제 배포 시 전개 필요)
            -----------------------------------------------------------------------------------------------
            WHILE V_I <= V_CNT LOOP
                -- LOC 가 있으면 업데이트, 없으면 인서트 (PRODUCT_GROUP, COMPANY_ID 조인 제외, FCST_TYPE 분기, YYYYMMDD 직접매칭)
                V_EXISTS := 0;
                BEGIN
                    SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (
                        SELECT 1 FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY AND A.MEASURE = B.MEASURE
                         AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                         AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO);
                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                END;

                IF V_EXISTS = 1 THEN
                    -- 1. LOC 메저를 업데이트
                    UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                               WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                               AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                               AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                               AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.MEASURE = A.MEASURE
                               AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                               AND B.INCOTERMS = A.INCOTERMS AND B.SEQ_RANK = V_I AND ROWNUM = 1), A.QTY),
                        LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                    WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                        WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                        AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                        AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                        AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.MEASURE = A.MEASURE
                        AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                        AND B.INCOTERMS = A.INCOTERMS AND B.SEQ_RANK = V_I);
                ELSE
                    -- LOC INSERT (자동차 ESS - PRODUCT_GROUP 제외)
                    INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                    ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                    , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                    , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                    , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                    , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                    , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                    SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                         , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'LOC', '-', B.YYYYMMDD
                         , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                         , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.MEASURE = 'LOC' AND B.SEQ_RANK = V_I
                    WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                    N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                END IF;

                -- 2. 기타 금액메저 모두 삭제
                DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                WHERE (A.MEASURE IN ('KRW','USD') OR A.MEASURE LIKE 'SalesAmt%')
                AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                    WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                    AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                    AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                    AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY
                    AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                    AND B.INCOTERMS = A.INCOTERMS AND B.SEQ_RANK = V_I);
                N_DELETE_COUNT := N_DELETE_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                -- 3. KRW 메저 INSERT (LOC * EXCHANGE_PRICE)
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                SELECT SUB_A.DATA_TYPE, SUB_A.DIVISION_ID, SUB_A.VERSION_NO, SUB_A.CUTOFF_TYPE, SUB_A.CUTOFF_YYYYMMDD, SUB_A.DEPARTMENT_ID, SUB_A.DEPARTMENT_NAME, SUB_A.DEPT_ID, SUB_A.DEPT_NAME, SUB_A.END_CUST_REPORT
                     , SUB_A.CUST_REPORT, SUB_A.PRODUCT_GROUP, SUB_A.PROJECT_CODE, SUB_A.SCM_SITE_ID, SUB_A.ITEM_ID, SUB_A.DOM_EXP, SUB_A.FCST_TYPE, SUB_A.INCOTERMS, 'KRW', SUB_A.PLANT_SITE_ID
                     , SUB_A.YYYYMMDD, SUB_A.CURRENCY, SUB_A.QTY * EX.EXCHANGE_PRICE, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                     , SUB_A.ATTRIBUTE1, SUB_A.ATTRIBUTE2, SUB_A.ATTRIBUTE3, SUB_A.ATTRIBUTE4, SUB_A.ATTRIBUTE5, SUB_A.ATTRIBUTE6, SUB_A.ATTRIBUTE7, SUB_A.ATTRIBUTE8, SUB_A.ATTRIBUTE9, SUB_A.ATTRIBUTE10
                     , SUB_A.COMPANY_ID, SUB_A.SOLDTO_CUST_REPORT, SUB_A.OWNER_NAME, SUB_A.CUST_GROUP_DTL, SUB_A.PRODUCT_DETAILS, SUB_A.FORECAST_INFO_SPEC, SUB_A.NICK_NAME
                     , SUB_A.FORECAST_INFO_CELL_MODEL, SUB_A.FORECAST_INFO_CELL_PACK_COUNT, SUB_A.FORECAST_INFO_BIZ_TYPE, SUB_A.COMPANY_NAME, SUB_A.APPLICATION, SUB_A.APPLICATION_GR
                     , SUB_A.COUNTRY_KR_NAME, SUB_A.ROUTE, NVL(SUB_A.CELL_PROD_SITE, '-')
                FROM (SELECT A.* FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                     WHERE A.DIVISION_ID = V_DIVISION_ID AND A.MEASURE = 'LOC' AND A.VERSION_NO = V_VERSION_NO) SUB_A
                JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C EX
                  ON SUB_A.DIVISION_ID = EX.DIVISION_ID AND SUB_A.VERSION_NO = EX.VERSION_NO AND SUB_A.CUTOFF_TYPE = EX.CUTOFF_TYPE
                 AND SUB_A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND SUB_A.CURRENCY = EX.UNIT_CURRENCY
                 AND SUB_A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_VERSION_NO;
                N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                -- USD 메저 INSERT
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                SELECT SUB_A.DATA_TYPE, SUB_A.DIVISION_ID, SUB_A.VERSION_NO, SUB_A.CUTOFF_TYPE, SUB_A.CUTOFF_YYYYMMDD, SUB_A.DEPARTMENT_ID, SUB_A.DEPARTMENT_NAME, SUB_A.DEPT_ID, SUB_A.DEPT_NAME, SUB_A.END_CUST_REPORT
                     , SUB_A.CUST_REPORT, SUB_A.PRODUCT_GROUP, SUB_A.PROJECT_CODE, SUB_A.SCM_SITE_ID, SUB_A.ITEM_ID, SUB_A.DOM_EXP, SUB_A.FCST_TYPE, SUB_A.INCOTERMS, 'USD', SUB_A.PLANT_SITE_ID
                     , SUB_A.YYYYMMDD, SUB_A.CURRENCY
                     , CASE WHEN NVL(EX.EXCHANGE_PRICE, 0) <> 0 THEN ROUND(SUB_A.QTY / EX.EXCHANGE_PRICE, 3) ELSE 0 END
                     , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                     , SUB_A.ATTRIBUTE1, SUB_A.ATTRIBUTE2, SUB_A.ATTRIBUTE3, SUB_A.ATTRIBUTE4, SUB_A.ATTRIBUTE5, SUB_A.ATTRIBUTE6, SUB_A.ATTRIBUTE7, SUB_A.ATTRIBUTE8, SUB_A.ATTRIBUTE9, SUB_A.ATTRIBUTE10
                     , SUB_A.COMPANY_ID, SUB_A.SOLDTO_CUST_REPORT, SUB_A.OWNER_NAME, SUB_A.CUST_GROUP_DTL, SUB_A.PRODUCT_DETAILS, SUB_A.FORECAST_INFO_SPEC, SUB_A.NICK_NAME
                     , SUB_A.FORECAST_INFO_CELL_MODEL, SUB_A.FORECAST_INFO_CELL_PACK_COUNT, SUB_A.FORECAST_INFO_BIZ_TYPE, SUB_A.COMPANY_NAME, SUB_A.APPLICATION, SUB_A.APPLICATION_GR
                     , SUB_A.COUNTRY_KR_NAME, SUB_A.ROUTE, NVL(SUB_A.CELL_PROD_SITE, '-')
                FROM (SELECT A.* FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                     WHERE A.DIVISION_ID = V_DIVISION_ID AND A.MEASURE = 'KRW' AND A.VERSION_NO = V_VERSION_NO) SUB_A
                JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C EX
                  ON SUB_A.DIVISION_ID = EX.DIVISION_ID AND SUB_A.VERSION_NO = EX.VERSION_NO AND SUB_A.CUTOFF_TYPE = EX.CUTOFF_TYPE
                 AND SUB_A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND EX.UNIT_CURRENCY = 'USD'
                 AND SUB_A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_VERSION_NO;
                N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                -- 4. SalesAmt_LOC, KRW, USD 업데이트 또는 생성 (RTF * LOC/KRW/USD 매칭)
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                SELECT SUB_A.DATA_TYPE, SUB_A.DIVISION_ID, SUB_A.VERSION_NO, SUB_A.CUTOFF_TYPE, SUB_A.CUTOFF_YYYYMMDD, SUB_A.DEPARTMENT_ID, SUB_A.DEPARTMENT_NAME, SUB_A.DEPT_ID, SUB_A.DEPT_NAME, SUB_A.END_CUST_REPORT
                     , SUB_A.CUST_REPORT, SUB_A.PRODUCT_GROUP, SUB_A.PROJECT_CODE, SUB_A.SCM_SITE_ID, SUB_A.ITEM_ID, SUB_A.DOM_EXP, SUB_A.FCST_TYPE, SUB_A.INCOTERMS, SUB_A.MEASURE, SUB_A.PLANT_SITE_ID
                     , SUB_A.YYYYMMDD, SUB_A.CURRENCY, SUB_A.QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                     , SUB_A.ATTRIBUTE1, SUB_A.ATTRIBUTE2, SUB_A.ATTRIBUTE3, SUB_A.ATTRIBUTE4, SUB_A.ATTRIBUTE5, SUB_A.ATTRIBUTE6, SUB_A.ATTRIBUTE7, SUB_A.ATTRIBUTE8, SUB_A.ATTRIBUTE9, SUB_A.ATTRIBUTE10
                     , SUB_A.COMPANY_ID, SUB_A.SOLDTO_CUST_REPORT, SUB_A.OWNER_NAME, SUB_A.CUST_GROUP_DTL, SUB_A.PRODUCT_DETAILS, SUB_A.FORECAST_INFO_SPEC, SUB_A.NICK_NAME
                     , SUB_A.FORECAST_INFO_CELL_MODEL, SUB_A.FORECAST_INFO_CELL_PACK_COUNT, SUB_A.FORECAST_INFO_BIZ_TYPE, SUB_A.COMPANY_NAME, SUB_A.APPLICATION, SUB_A.APPLICATION_GR
                     , SUB_A.COUNTRY_KR_NAME, SUB_A.ROUTE, NVL(SUB_A.CELL_PROD_SITE, '-')
                FROM (
                    SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-') AS DEPARTMENT_NAME, A.DEPT_ID, NVL(A.DEPT_NAME, '-') AS DEPT_NAME, A.END_CUST_REPORT
                         , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-') AS DOM_EXP, NVL(A.FCST_TYPE, '-') AS FCST_TYPE, A.INCOTERMS
                         , 'SalesAmt_' || C.MEASURE AS MEASURE, A.PLANT_SITE_ID
                         , A.YYYYMMDD, A.CURRENCY, ROUND(A.QTY * C.QTY, 3) AS QTY
                         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                         , A.COMPANY_ID, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') AS CELL_PROD_SITE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                    JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                      ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                     AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT
                     AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                     AND A.YYYYMMDD = C.YYYYMMDD AND A.CURRENCY = C.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE C.FCST_TYPE END
                     AND A.INCOTERMS = C.INCOTERMS AND C.MEASURE IN ('LOC', 'USD', 'KRW')
                    WHERE A.DIVISION_ID = V_DIVISION_ID
                    AND A.MEASURE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN 'RTF_SYS_RP' ELSE 'RTF' END
                    AND A.VERSION_NO = V_VERSION_NO
                ) SUB_A;
                N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                V_I := V_I + 1;
            END LOOP; -- 자동차 ESS
        END IF; -- V_DIVISION_ID = '40'
    --=============================================================================================
    --DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (END)
    --=============================================================================================
    --=============================================================================================
    --BP인 경우 (START)
    --=============================================================================================
    ELSE
        --[C20201005-000291] BP 부분을 루프에서 원쿼리로 변경함.
        -----------------------------------------------------------------------------------------------
        -- 단가 변경이 있을 경우 LOC, KRW, USD 를 같이 변경함
        -----------------------------------------------------------------------------------------------
        V_EXISTS := 0;
        BEGIN
            SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE MEASURE = 'LOC');
        EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
        END;

        IF V_EXISTS = 1 THEN
            -- LOC
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                       WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                       AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                       AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                       AND B.MEASURE = A.MEASURE AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = A.MEASURE);

            -- KRW (LOC * EXCHANGE)
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
                       FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                       JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                       WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                       AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                       AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'LOC' AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = 'LOC');

            -- USD (KRW / EXCHANGE)
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT ROUND(CASE WHEN NVL(D.EXCHANGE_PRICE,0) = 0 THEN 0 ELSE C.QTY / NVL(D.EXCHANGE_PRICE,0) END, 0)
                       FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                       JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                       WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                       AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                       AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'KRW' AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = 'USD');
        END IF;

        --	수량 변경이 있을 경우 처리 ( 수량은 수량만 수정 )
        V_EXISTS := 0;
        BEGIN SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE MEASURE = 'Business_Plan');
        EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0; END;

        IF V_EXISTS = 1 THEN
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                       WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                       AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                       AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                       AND B.MEASURE = A.MEASURE AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'Business_Plan' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = A.MEASURE);
        END IF;

        -- BP는 모든 구간이 계획이므로 금액을 조정: SalesAmt_LOC = Business_Plan * LOC
        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        SET QTY = NVL((SELECT C.QTY * D.QTY
                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C, SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C D
                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'Business_Plan'
                   AND D.VERSION_NO = A.VERSION_NO AND D.DIVISION_ID = A.DIVISION_ID AND D.DEPARTMENT_ID = A.DEPARTMENT_ID AND D.DEPT_ID = A.DEPT_ID
                   AND D.END_CUST_REPORT = A.END_CUST_REPORT AND D.CUST_REPORT = A.CUST_REPORT AND D.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND D.PROJECT_CODE = A.PROJECT_CODE AND D.SCM_SITE_ID = A.SCM_SITE_ID AND D.ITEM_ID = A.ITEM_ID
                   AND D.YYYYMMDD = A.YYYYMMDD AND D.CURRENCY = A.CURRENCY AND D.COMPANY_ID = A.COMPANY_ID AND D.MEASURE = 'LOC' AND ROWNUM = 1), A.QTY),
            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
            AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID);

        -- SalesAmt_KRW = SalesAmt_LOC * EXCHANGE
        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        SET QTY = NVL((SELECT ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1), A.QTY),
            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
            AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID);

        -- SalesAmt_USD = SalesAmt_KRW / EXCHANGE(USD)
        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        SET QTY = NVL((SELECT ROUND(CASE WHEN NVL(D.EXCHANGE_PRICE,0) = 0 THEN 0 ELSE B_SUB.QTY / NVL(D.EXCHANGE_PRICE,0) END, 0)
                   FROM (SELECT A2.DIVISION_ID, A2.DEPARTMENT_ID, A2.DEPT_ID, A2.END_CUST_REPORT, A2.CUST_REPORT, A2.PRODUCT_GROUP, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.ITEM_ID, A2.YYYYMMDD, A2.CURRENCY, A2.COMPANY_ID, A2.QTY
                         FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A2
                         WHERE A2.MEASURE = 'SalesAmt_KRW' AND A2.VERSION_NO = V_VERSION_NO AND A2.DIVISION_ID = V_DIVISION_ID) B_SUB
                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                   WHERE B_SUB.DIVISION_ID = A.DIVISION_ID AND B_SUB.DEPARTMENT_ID = A.DEPARTMENT_ID AND B_SUB.DEPT_ID = A.DEPT_ID
                   AND B_SUB.END_CUST_REPORT = A.END_CUST_REPORT AND B_SUB.CUST_REPORT = A.CUST_REPORT AND B_SUB.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND B_SUB.PROJECT_CODE = A.PROJECT_CODE AND B_SUB.SCM_SITE_ID = A.SCM_SITE_ID AND B_SUB.ITEM_ID = A.ITEM_ID
                   AND B_SUB.YYYYMMDD = A.YYYYMMDD AND B_SUB.CURRENCY = A.CURRENCY AND B_SUB.COMPANY_ID = A.COMPANY_ID AND ROWNUM = 1), A.QTY),
            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C C
            WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
            AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
            AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
            AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID);
    END IF; -- V_CUTOFF_TYPE
    --=============================================================================================
    --BP인 경우 (END)
    --=============================================================================================

    --=============================================================================================
    --[E20230906-001160] GDW 송신용 데이터 Lookup 수정 START
    --=============================================================================================
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT MODEL, BIZ_TYPE, CELL_PACK_COUNT, DIVISION_ID
        FROM (SELECT SEGMENT2 AS MODEL, SEGMENT3 AS BIZ_TYPE, SEGMENT4 AS CELL_PACK_COUNT, SEGMENT1 AS DIVISION_ID,
                     RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
              FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40')
        WHERE MODEL_RANK = 1
    ) LOOKA ON (LOOKA.MODEL = A.ITEM_ID AND LOOKA.DIVISION_ID = A.DIVISION_ID)
    WHEN MATCHED THEN UPDATE
    SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT,
        A.FORECAST_INFO_BIZ_TYPE        = LOOKA.BIZ_TYPE,
        A.LAST_UPDATED_BY               = V_CREATED_BY, --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        A.LAST_UPDATE_DATE              = SYSDATE       --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
    WHERE A.DIVISION_ID = '40' AND A.VERSION_NO = V_VERSION_NO;
    --=============================================================================================
    --[E20230906-001160] GDW 송신용 데이터 Lookup 수정 END
    --=============================================================================================

    --=============================================================================================
    --[E20250418-001567]_Sales Report 이력 테이블 생성 START
    --=============================================================================================
    INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_H
    ( DATA_TYPE, DIVISION_ID, HISTORY_SEQ, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
    , END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
    , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
    , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
    , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )
    SELECT A.DATA_TYPE, A.DIVISION_ID, SEQ1_DM_PLN_SALES_PLAN_REPORT_H.NEXTVAL, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, A.DEPT_NAME
         , A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), A.MEASURE, A.PLANT_SITE_ID
         , A.YYYYMMDD, A.CURRENCY, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
         , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
     AND A.MEASURE = B.MEASURE
    WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;
    N_HISTORY_COUNT := SQL%ROWCOUNT;  -- [PATCH] DML count
    --=============================================================================================
    --[E20250418-001567]_Sales Report 이력 테이블 생성 END
    --=============================================================================================

    -----------------------------------------------------------------------------------------------
    -- UPDATE 후에 전송처리를 다시 한다.
    -----------------------------------------------------------------------------------------------
    V_EXISTS := 0;
    BEGIN
        SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (
            SELECT 1 FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID = V_DIVISION_ID AND VERSION_NO = V_VERSION_NO AND SEND_YN = 'Y');
    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
    END;

    /* TODO DMF0044_MOBILE_REPORT_CREATE
    IF V_EXISTS = 1 THEN
        SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(V_DIVISION_ID, V_VERSION_NO, V_CUTOFF_TYPE, 'T', V_CREATED_BY);
    END IF;
    */

    --=============================================================================================
    -- COMMIT (종료 직전 1회)
    --=============================================================================================
    COMMIT;

    N_LOG_COUNT := N_INPUT_COUNT;
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    --=============================================================================================
    -- 종료 LOG
    --=============================================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure @@@##########';
    V_DESCRIPTION := 'input_count: '    || TO_CHAR(N_INPUT_COUNT)
                  || ' / insert_count: '|| TO_CHAR(N_INSERT_COUNT)
                  || ' / delete_count: '|| TO_CHAR(N_DELETE_COUNT)
                  || ' / history_count: '|| TO_CHAR(N_HISTORY_COUNT)
                  || ' / total_dml: '   || TO_CHAR(N_INSERT_COUNT + N_DELETE_COUNT);  -- [PATCH] DML 카운트
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'      VALUE P_DIVISION_ID,
            'P_VERSION_NO'       VALUE P_VERSION_NO,
            'P_CUTOFF_TYPE'      VALUE P_CUTOFF_TYPE,
            'P_CUTOFF_YYYYMMDD'  VALUE P_CUTOFF_YYYYMMDD,
            'P_CREATED_BY'       VALUE P_CREATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0044_SAVE_SALES_PLAN_REPORT_C_CF;
/
