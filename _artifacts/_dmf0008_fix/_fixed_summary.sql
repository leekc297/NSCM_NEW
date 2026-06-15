
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0008_GET_EDI_MST_SUMMARY"
(
	p_FROM_YYYYMMDD	VARCHAR2, --안쓰임.
	p_TO_YYYYMMDD		VARCHAR2, --안쓰임.
	p_DIVISION_ID		VARCHAR2 --쓰임
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC3  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0008_GET_EDI_MST_SUMMARY
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.05	   kdmcc14		[]  ERP, EDI MASTER DATA 정비 SUMMARY
 2023.09.20	   chutoc730	[]  제외 ITEM_ID 적용(DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE)
 2024.04.18    HMIN		    [E20240405-001867]_[공급 SCM PI팀] ERP EDI Master화면 '예외 처리' 칼럼 추가 및 조회 로직 개선
 2024.07.03	   JSSBAE		[E20240701-000472]_[공급 SCM PI팀] ERP EDI Master화면 업데이트 범위 개선
 2024-12-31    dsiol        [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 *
 2025-01-21 dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포
 2026-03-15 김준규          [PJ20264226] NextSCM Pilot 설계 및 개발
 DMF0008_GET_EDI_MST_SUMMARY('', '', '81');
 DMF0008_GET_EDI_MST_SUMMARY('', '', '81_UC');
 */
-- 2026-05-15 전병주 컴파일 오류 수정
-- -------------------------------------------------------------------------------------------------------------------------------
AS

    v_FROM_YYYYMMDD VARCHAR2(4000 CHAR);
    v_TO_YYYYMMDD VARCHAR2(4000 CHAR);
    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE    VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_FROM_YYYYMMDD' VALUE p_FROM_YYYYMMDD,
            'p_TO_YYYYMMDD' VALUE p_TO_YYYYMMDD,
            'p_DIVISION_ID' VALUE p_DIVISION_ID
          );

	/* --2024-12-31 변경

	--오늘 기준 전전월(M-2 월의 1일)부터 현재까지 데이터 조회
	--v_FROM_YYYYMMDD := '20230101'
	v_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(SYSDATE, -2), 'YYYYMMDD') || '01';
	*/
	--현재시점으로 과거 52주 구간의 가장 최신인 EDI 데이터를 가져 온다.
	--v_FROM_YYYYMMDD := TO_CHAR(SYSDATE + (-52)*7, 'YYYYMMDD'); -- 현재 요일 기준 52주 구하기
	v_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') - (52 * 7), 'YYYYMMDD');

	BEGIN

		OPEN O_RC1 FOR
		SELECT T.DIVISION_ID        AS DIVISION_ID
		    , T.SENDER_NAME EDI_SENDER_NAME
			, SUM(GSCM_MASTER_DATA) GSCM_MASTER_DATA
			--, SUM(ERP_MASTER_DATA) ERP_MASTER_DATA
			, SUM(SUCCESS) SUCCESS
			, SUM("EXCEPTION") EXCEPTION_DATA
			, COUNT(1) CNT
			, tei.EDIT_YN
		FROM
		    (
			SELECT    A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT, A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
                    , A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS--, CREATE_DATE
                    , A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS
                    -- FROM DUAL;
                    /* 2025.01.10 Philsu Park 수정 */
                    , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
                    , CASE WHEN A.STATUS_CODE = 'S'			AND NVL(A.EXCEPTION_fLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS SUCCESS
                    --, CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_ERP'  AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS ERP_MASTER_DATA
                    -- , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_GSCM' AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
                    -- , CASE WHEN A.STATUS_CODE = 'S'			AND A.ERP_STATUS IS NULL		  AND NVL(A.EXCEPTION_fLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS SUCCESS
                    -- , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'E'		  AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS TTT
                    , CASE WHEN A.EXCEPTION_FLAG = 'Y'  THEN 1 ELSE 0 END AS "EXCEPTION"
			FROM DM_DNM_EDI_CALLOFF_ITEM    A
            LEFT OUTER JOIN SCM_MST_SITE    B
                ON  A.DIVISION_ID   = B.DIVISION_ID
                AND A.SCM_SITE_ID   = B.SCM_SITE_ID
                AND B.SITE_TYPE	    = 'SALES'
                AND B.VALID_YN      = 'Y'
			WHERE   A.CREATE_DATE  >= v_FROM_YYYYMMDD
			AND     A.DIVISION_ID   = p_DIVISION_ID
            AND     A.ERP_STATUS    = 'S'  -- ERP Status 정상인 대상만 Count.
			AND     LTRIM(RTRIM(A.YYYYMMDD)) NOT IN ('444444')   /* 20240422 추가 YYYYMMDD = '444444' 인 데이터가 들어오고있는데...이 데이터는 날짜형태가 부적합 하기 때문에 사용이 불가;
															   따라서 정비 필요 모수에서 제외하는게 적절해 보인다로 내부의견을 전달 드립니다. */
            /*----------------------------------------------------------------------*/
            --AND A.SENDER_NAME   <> 'LUCID'
			--AND A.ERP_STATUS    <> 'E' -- RDD가 이상하게 들어오면 버림
			--AND A.STATUS_CODE   <> 'X' -- 어디서 업뎃했는지 모르겠는데, 지금 사용불가
			/*----------------------------------------------------------------------*/
			GROUP BY  A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT, A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
					, A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
					, A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS , A.EXCEPTION_FLAG
		)  T
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = T.DIVISION_ID
		GROUP BY T.DIVISION_ID, T.SENDER_NAME, tei.EDIT_YN
		ORDER BY T.SENDER_NAME;

		/* --2024-12-31 변경
		OPEN O_RC2 FOR
		SELECT T.DIVISION_ID        AS DIVISION_ID
		    , T.SENDER_NAME EDI_SENDER_NAME
			, SUM(ERP_MASTER_DATA) ERP_MASTER_DATA
			, SUM(GSCM_MASTER_DATA) GSCM_MASTER_DATA
			, SUM(SUCCESS) SUCCESS
			, SUM(EXCEPTION) EXCEPTION_DATA
			, COUNT(1) CNT
		FROM
		(
			SELECT A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT, A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
				, A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS--, CREATE_DATE
				, A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS
				, CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_ERP'  AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS ERP_MASTER_DATA
				, CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_GSCM' AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS GSC
		*/

		-- [2026-06-10 FIX] cursor overwrite removed: OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL;
		OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL;

	END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE   := 'ERROR';
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                            V_LOG_TYPE,
                            N_LOG_COUNT,
                            V_LOG_MESSAGE,
                            V_DESCRIPTION,
                            D_EVENT_DATE,
                            V_PROC_INPUT,
                            V_SQL_CODE,
                            V_SQL_ERRMSG,
                            V_BACKTRACE
                            );
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || v_in_para_data
        );
END DMF0008_GET_EDI_MST_SUMMARY;
/
