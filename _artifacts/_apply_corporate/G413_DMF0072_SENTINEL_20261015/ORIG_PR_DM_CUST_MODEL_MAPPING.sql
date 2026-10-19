-- SOURCE-FRESH: SCM_MGR.PR_DM_CUST_MODEL_MAPPING PROCEDURE LAST_DDL=2026-10-15 11:14:13 FETCHED=2026-10-15 11:15 DB=ZIOUI1
-- ROLLBACK 용 원본 (GAP413 적용 전)
CREATE OR REPLACE PROCEDURE           "PR_DM_CUST_MODEL_MAPPING"
(
    P_ACCEPT_FLAG VARCHAR2  /* 업무구분(SCM) */
)
/*====================================================================================================================
 * Program ID	: [PR_DM_CUST_MODEL_MAPPING]
 * Description  : N:N Model Mapping 데이터 기초값 생성
 * 테이블		: DM_CUST_MODEL_MAPPING_M
 * Program History
 *=====================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================
 * 2024.12.09	KANG.H.J		[PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 * 2026.01.06	JSSBAE			[E20260106-000753]_EDI Calloff 데이터 IF 로직 개선
 * 2026.07.06	ZIONEX			[PJ202650304] NextSCM Migration

 PR_DM_CUST_MODEL_MAPPING('SCM');    --EDI(PR_DM_DNM_EDI_CALLOFF CALL)
=====================================================================================================================*/
AS

    V_PROGRAM_NAME     VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE         VARCHAR2(30 CHAR);
    N_LOG_COUNT        INTEGER := 0;
    V_LOG_MESSAGE      VARCHAR2(1000 CHAR);
    V_DESCRIPTION      VARCHAR2(500 CHAR);
    D_EVENT_DATE       DATE;
    N_DELETE_COUNT     INTEGER := 0;
    N_INSERT_COUNT     INTEGER := 0;
    V_CREATED_BY       VARCHAR2(150 CHAR) := V_PROGRAM_NAME;  /* [E20260106-000753]_CREATE명 변경 */
    V_DELIMITER        VARCHAR2(1 CHAR);
    V_ACCEPT_FLAG      VARCHAR2(10 CHAR);
    V_CNT              INTEGER := 0;
    V_FROM_YYYYMMDD    VARCHAR2(8 CHAR);
    V_DELETE_YYYYMMDD  VARCHAR2(8 CHAR);
    V_VALID_START_DATE VARCHAR2(8 CHAR);
    V_VALID_END_DATE   VARCHAR2(8 CHAR);
    V_IN_PARA_DATA     VARCHAR2(4000 CHAR);
BEGIN

    V_IN_PARA_DATA := JSON_OBJECT('P_ACCEPT_FLAG' VALUE P_ACCEPT_FLAG RETURNING VARCHAR2(4000 CHAR));

    /*====================================================================================================================
      시작 LOG (START)
      ====================================================================================================================*/
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := 'PR_DM_CUST_MODEL_MAPPING: ' || P_ACCEPT_FLAG;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY);
    /*====================================================================================================================
      시작 LOG (END)
      ====================================================================================================================*/

    /*====================================================================================================================
      변수 설정 (START)
      ----------------------------------------------------------------------------------------------------
      오윤종 PI 요청으로 셋팅함
      ====================================================================================================================*/
    V_FROM_YYYYMMDD    := '20240101';
    V_DELETE_YYYYMMDD  := TO_CHAR(ADD_MONTHS(SYSDATE, -12), 'YYYYMMDD');  /* 미사용됨. */
    V_VALID_START_DATE := TO_CHAR(SYSDATE, 'YYYY') || '0101';
    V_VALID_END_DATE   := '20991231';
    V_ACCEPT_FLAG      := P_ACCEPT_FLAG;
    /*====================================================================================================================
      변수 설정 (END)
      ====================================================================================================================*/
    DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ': A1--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / @p_accept_flag: ' || P_ACCEPT_FLAG);

    IF V_ACCEPT_FLAG = 'SCM' THEN
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ': A2--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / @p_accept_flag: ' || P_ACCEPT_FLAG);
        /* [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 START */
        /* [E20260106-000753]_DM_CUST_MODEL_MAPPING_M 해당 키값으로 데이터 조회를 하지 않아, 두개 이상의 데이터가 조회되어 오류 발생 (START)
           원소스 주석 처리 후 DM_CUST_MODEL_MAPPING_M 테이블 키값기준으로 조회하여 진행하도록 수정

           USING (	SELECT DISTINCT A.DIVISION_ID
           					  , A.SENDER_CODE
           					  , A.SENDER_NAME
           					  , ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),'') AS UNLOADING_POINT
           					  , ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'') AS CUSTOMER_PLANT
           					  , ISNULL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)),'') AS CUSTOMER_ITEM_ID
           					  , A.SHIPTO_CODE
           					  , A.SOLDTO_CODE
           					  , A.ITEM_ID
           					  , ISNULL(B.MAPPING_ITEM_ID, A.ITEM_ID) AS MAPPING_ITEM_ID
           					  , A.SCM_SITE_ID
           					  , A.EDI_INCOTERMS AS INCOTERMS
           					  , A.PROJECT_CODE
           					  , ISNULL(C.END_CUSTOMER, '')	AS END_CUSTOMER
           					  , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END AS FCST_TYPE
           					  , 'E' AS DOM_EXP
           					  , @v_VALID_START_DATE AS VALID_START_DATE
           					  , @v_VALID_END_DATE AS VALID_END_DATE
           					  , A.COMPANY_ID AS COMPANY_ID
           					  , 'SCM' AS DATA_TYPE_CODE
           		FROM DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK)
           		LEFT OUTER JOIN DM_CUST_MODEL_MAPPING_M B WITH(NOLOCK)
           					 ON A.DIVISION_ID		= B.DIVISION_ID
           					AND B.DATA_TYPE_CODE	= 'SCM'
           					AND A.COMPANY_ID		= B.COMPANY_ID
           					AND A.SOLDTO_CODE		= B.SOLDTO_CODE
           					AND A.SHIPTO_CODE		= B.SHIPTO_CODE
           					AND ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)), '')		= ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)), '')
           					AND ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), '')		= ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), '')
           					AND ISNULL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)), '')	= ISNULL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), '')
           					AND A.SCM_SITE_ID		= B.SCM_SITE_ID
           					AND A.PROJECT_CODE		= B.PROJECT_CODE
           					AND B.FCST_TYPE			= CASE WHEN A.ERP_FCST_TYPE	= 'S' THEN 'SMC' ELSE 'MPS' END
           					AND A.EDI_INCOTERMS		= B.INCOTERMS
           					AND B.DOM_EXP			= 'E'
           					AND A.ITEM_ID			= B.ITEM_ID
           		LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
           					 ON A.DIVISION_ID	= C.DIVISION_ID
           					AND A.SCM_SITE_ID	= C.SCM_SITE_ID
           					AND C.SITE_TYPE		= 'SALES'
           					AND C.VALID_YN		= 'Y'
           		WHERE A.CREATE_DATE >= @v_from_yyyymmdd
           		AND A.STATUS_CODE	= 'S'
           		--AND A.SENDER_NAME	<> 'LUCID'
           		AND A.COMPANY_ID IN (SELECT SEGMENT1 AS COMPANY FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_EDI_COMPANY_DIVISION_MAPPING' AND SEGMENT3='N' AND VALID_YN = 'Y')	-- NERP로부터 기준정보를 받지 않는 법인
           		GROUP BY A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),''), ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'')
           			   , ISNULL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)),''), A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, B.MAPPING_ITEM_ID, A.SCM_SITE_ID, A.EDI_INCOTERMS
           			   , A.PROJECT_CODE, C.END_CUSTOMER,A.ERP_FCST_TYPE,A.COMPANY_ID

           DM_CUST_MODEL_MAPPING_M 테이블 키값기준으로 조회 + END_CUSTOMER 추가 */
        MERGE INTO DM_CUST_MODEL_MAPPING_M T1
        USING (SELECT T.DATA_TYPE_CODE
                    , T.DIVISION_ID
                    , T.COMPANY_ID
                    , T.SOLDTO_CODE
                    , T.SHIPTO_CODE
                    , T.UNLOADING_POINT
                    , T.CUSTOMER_PLANT
                    , T.CUSTOMER_ITEM_ID
                    , T.SCM_SITE_ID
                    , T.PROJECT_CODE
                    , T.FCST_TYPE
                    , T.INCOTERMS
                    , T.DOM_EXP
                    , T.ITEM_ID
                    , T.MAPPING_ITEM_ID
--                    , NVL(C.END_CUSTOMER, '-') AS END_CUSTOMER    --  2026.10.11 AJS
                    , NVL(C.END_CUSTOMER, '/') AS END_CUSTOMER    --  2026.10.11 AJS
                 FROM (SELECT DISTINCT 'SCM' AS DATA_TYPE_CODE
                            , A.DIVISION_ID
                            , A.COMPANY_ID
                            , A.SOLDTO_CODE
                            , A.SHIPTO_CODE
                            , NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), ' ') AS UNLOADING_POINT
                            , NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), ' ') AS CUSTOMER_PLANT
                            , NVL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)), ' ') AS CUSTOMER_ITEM_ID
                            , A.SCM_SITE_ID
                            , A.PROJECT_CODE
                            , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END AS FCST_TYPE
                            , A.EDI_INCOTERMS AS INCOTERMS
                            , 'E' AS DOM_EXP
                            , A.ITEM_ID
                            , NVL(B.MAPPING_ITEM_ID, A.ITEM_ID) AS MAPPING_ITEM_ID
                         FROM DM_DNM_EDI_CALLOFF_ITEM A
                            , DM_CUST_MODEL_MAPPING_M  B
                        WHERE A.DIVISION_ID = B.DIVISION_ID(+)
                          AND A.COMPANY_ID = B.COMPANY_ID(+)
                          AND A.SOLDTO_CODE = B.SOLDTO_CODE(+)
                          AND A.SHIPTO_CODE = B.SHIPTO_CODE(+)
                          AND NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), ' ') = NVL(RTRIM(LTRIM(B.UNLOADING_POINT(+))), ' ')
                          AND NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), ' ') = NVL(RTRIM(LTRIM(B.CUSTOMER_PLANT(+))), ' ')
                          AND NVL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)), ' ') = NVL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID(+))), ' ')
                          AND A.SCM_SITE_ID = B.SCM_SITE_ID(+)
                          AND A.PROJECT_CODE = B.PROJECT_CODE(+)
                          AND A.EDI_INCOTERMS = B.INCOTERMS(+)
                          AND A.ITEM_ID = B.ITEM_ID(+)
                          AND B.FCST_TYPE(+) = CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END
                          AND B.DATA_TYPE_CODE(+) = 'SCM'
                          AND B.DOM_EXP(+) = 'E'
                          AND A.COMPANY_ID IN (SELECT SEGMENT1 AS COMPANY
                                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                WHERE LOOKUP_TYPE = 'DM_EDI_COMPANY_DIVISION_MAPPING'
                                                  AND SEGMENT3 = 'N'
                                                  AND VALID_YN = 'Y')  /* NERP로부터 기준정보를 받지 않는 법인 */
                          AND A.STATUS_CODE = 'S'
                          AND A.CREATE_DATE >= V_FROM_YYYYMMDD
                      ) T
                    , SCM_MST_SITE C
                WHERE T.DIVISION_ID = C.DIVISION_ID(+)
                  AND T.SCM_SITE_ID = C.SCM_SITE_ID(+)
                  AND C.SITE_TYPE(+) = 'SALES'
                  AND C.VALID_YN(+) = 'Y'
              ) T2
        ON (    T1.DIVISION_ID = T2.DIVISION_ID
            AND T1.DATA_TYPE_CODE = T2.DATA_TYPE_CODE
            AND T1.COMPANY_ID = T2.COMPANY_ID
            AND T1.SOLDTO_CODE = T2.SOLDTO_CODE
            AND T1.SHIPTO_CODE = T2.SHIPTO_CODE
            AND NVL(RTRIM(LTRIM(T1.UNLOADING_POINT)), ' ') = NVL(RTRIM(LTRIM(T2.UNLOADING_POINT)), ' ')
            AND NVL(RTRIM(LTRIM(T1.CUSTOMER_PLANT)), ' ') = NVL(RTRIM(LTRIM(T2.CUSTOMER_PLANT)), ' ')
            AND NVL(RTRIM(LTRIM(T1.CUSTOMER_ITEM_ID)), ' ') = NVL(RTRIM(LTRIM(T2.CUSTOMER_ITEM_ID)), ' ')
            AND T1.SCM_SITE_ID = T2.SCM_SITE_ID
            AND T1.PROJECT_CODE = T2.PROJECT_CODE
            AND T1.FCST_TYPE = T2.FCST_TYPE
            AND T1.INCOTERMS = T2.INCOTERMS
            AND T1.DOM_EXP = T2.DOM_EXP
            AND T1.ITEM_ID = T2.ITEM_ID
            AND T1.MAPPING_ITEM_ID = T2.MAPPING_ITEM_ID )
        WHEN MATCHED THEN
            UPDATE
               SET T1.END_CUSTOMER     = T2.END_CUSTOMER
                 , T1.LAST_UPDATED_BY  = V_CREATED_BY  /* [E20260106-000753]_UPDATED_BY는 프로시져 명으로 작성 (구: 'BATCH SYSTEM' 주석) */
                 , T1.LAST_UPDATE_DATE = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT
                ( DIVISION_ID
                , DATA_TYPE_CODE
                , END_CUSTOMER
                , SCM_SITE_ID
                , PROJECT_CODE
                , FCST_TYPE
                , INCOTERMS
                , DOM_EXP
                , ITEM_ID
                , MAPPING_ITEM_ID
                , ACTIVE_YN
                , UNLOADING_POINT
                , CUSTOMER_PLANT
                , SOLDTO_CODE
                , SHIPTO_CODE
                , CUSTOMER_ITEM_ID
                , VALID_START_DATE
                , VALID_END_DATE
                , COMPANY_ID
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE )
            VALUES
                ( T2.DIVISION_ID
                , T2.DATA_TYPE_CODE
                , T2.END_CUSTOMER
                , T2.SCM_SITE_ID
                , T2.PROJECT_CODE
                , T2.FCST_TYPE
                , T2.INCOTERMS
                , T2.DOM_EXP
                , T2.ITEM_ID
                , T2.MAPPING_ITEM_ID
                , 'Y'
                , T2.UNLOADING_POINT
                , T2.CUSTOMER_PLANT
                , T2.SOLDTO_CODE
                , T2.SHIPTO_CODE
                , T2.CUSTOMER_ITEM_ID
                , V_VALID_START_DATE  /* [E20260106-000753]_고정값으로 변경 (구: T2.VALID_START_DATE 주석) */
                , V_VALID_END_DATE    /* [E20260106-000753]_고정값으로 변경 (구: T2.VALID_END_DATE 주석) */
                , T2.COMPANY_ID
                , V_CREATED_BY        /* [E20260106-000753]_UPDATED_BY는 프로시져 명으로 작성 (구: 'BATCH SYSTEM') */
                , SYSDATE
                , V_CREATED_BY        /* [E20260106-000753]_UPDATED_BY는 프로시져 명으로 작성 (구: 'BATCH SYSTEM') */
                , SYSDATE )
            WHERE ( T2.DIVISION_ID IN (SELECT DIVISION_ID
                                         FROM SCM_MST_DIVISION DIV
                                        WHERE VALID_YN = 'Y') );
        /* [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 END */
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ': A3--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / @p_accept_flag: ' || P_ACCEPT_FLAG);
    END IF;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ': A4--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / @p_accept_flag: ' || P_ACCEPT_FLAG);
    /*====================================================================================================================
      종료 LOG (START)
      ====================================================================================================================*/
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    /*====================================================================================================================
      종료 LOG (END)
      ====================================================================================================================*/

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        /*====================================================================================================================
          ERROR LOG (START)
          ====================================================================================================================*/
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
          , P_IN_PARA_DATA  => V_IN_PARA_DATA
          , P_SQL_ERR_CODE  => SQLCODE
          , P_SQL_ERR_MSG   => SQLERRM
          , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        /*====================================================================================================================
          ERROR LOG (END)
          ====================================================================================================================*/
        RAISE_APPLICATION_ERROR(-20001, '[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
