-- PKG_DMF0008 — standalone 복원 (DROP 직전 원문 = 생성 시점 DB 재조회본 · SCM_MGR 로 실행)
-- ⚠ STEP 1 백업이 아니라 현재 원문을 쓴다: STEP 2 에서 바뀐 standalone(예: DMF0043_GET_MAIN_SPREAD_TITLE → _CORE 호출)을 옛 본문으로 되돌리면 INVALID
SET DEFINE OFF
-- SOURCE-FRESH: SCM_MGR.DMF0008_GET_EDI_MST_REPAIR PROCEDURE LAST_DDL=2026-09-14 18:27:51 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0008_GET_EDI_MST_REPAIR" 
(
	  p_DIVISION_ID        VARCHAR2
	, p_FROM_YYYYMMDD	    VARCHAR2
	, p_TO_YYYYMMDD		VARCHAR2
	, p_Sender_Name		VARCHAR2
	, p_Flag				VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0008_GET_EDI_MST_REPAIR
 * Description  :
 * Program History
 *===================================================================================================
 *   Date    In Charge      Description
 *===================================================================================================
* 2023.04.05 kdmcc14		[]  ERP, EDI MASTER DATA 정비 SUMMARY
* 2023.09.20 chutoc730		[]  제외 ITEM_ID 적용(DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE)
* 2023.11.30 KJJ			[]  제외 필드 추가 : EXCEPTION_FLAG, EXCEPTION_DATE
* 2024.04.18 HMIN		    [E20240405-001867]_[공급 SCM PI팀] ERP EDI Master화면 '예외 처리' 칼럼 추가 및 조회 로직 개선
* 2024.07.03 JSSBAE			[E20240701-000472]_[공급 SCM PI팀] ERP EDI Master화면 업데이트 범위 개선
* 2024-12-31 dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 *
* 2025-01-21 dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포
* 2026-03-15 김준규          [PJ20264226] NextSCM Pilot 설계 및 개발
 DMF0008_GET_EDI_MST_REPAIR('81', '20230401', '20230931', 'BMW', '5');
 DMF0008_GET_EDI_MST_REPAIR('81', '20230401', '20230931', 'AUDI/VW');
 DMF0008_GET_EDI_MST_REPAIR('81', '20230401', '20230931', 'VOLVO');
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
            'p_DIVISION_ID' VALUE p_DIVISION_ID,
            'p_FROM_YYYYMMDD' VALUE p_FROM_YYYYMMDD,
            'p_TO_YYYYMMDD' VALUE p_TO_YYYYMMDD,
            'p_Sender_Name' VALUE p_Sender_Name,
            'p_Flag' VALUE p_Flag
          );

	/* --2024-12-31 변경

	--오늘 기준 전전월(M-2 월의 1일)부터 현재까지 데이터 조회
	--v_FROM_YYYYMMDD := '20230101'
	v_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(SYSDATE, -2), 'YYYYMMDD') || '01';
	*/
	--현재시점으로 과거 52주 구간의 가장 최신인 EDI 데이터를 가져 온다.
	--v_FROM_YYYYMMDD := TO_CHAR(SYSDATE + (-52)*7, 'YYYYMMDD'); -- 현재 요일 기준 52주 구하기
	v_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') - 52*7, 'YYYYMMDD'); -- 52주전의 월요일 구하기

	OPEN O_RC1 FOR
	SELECT TF.DIVISION_ID
	     , TF.EDI_SENDER_CODE
		 , TF.EDI_SENDER_NAME
		 , TF.CUST_UNLOADING_POINT
		 , TF.CUST_PLANT
		 , TF.CUST_ITEM_ID
		 , TF.ERP_SHIPTO
		 , TF.ERP_SOLDTO
		 , TF.ERP_ITEM_ID
		 , TF.SCM_SITE_ID
		 , TF.STATUS_CODE
		 , TF.SSPM_STATUS
		 , TF.EDI_INCOTERMS
		 , TF.PROJECT_CODE
		 , TF.END_CUSTOMER
		 , TF.GSCM_SALES_SITE_ID
		 , TF.ACTIVE_SS
		 , TF.GSCM_SSPM
		 , TF.GSCM_SSPM_INCOTERMS
		 , TF.ACTIVE_SSPM
		 , TF.PROJECT_STATUS
		 , TF.PLANT_SITE_STATUS
		 , TF."EXCEPTION"
		 , TF.EXCEPTION_DATE
		 , TF.EXCEPTION_FLAG
		 , TF.CNT
		 , TF.SALES_PLANT_SITE_STATUS
		 , TF.ERP_STATUS
		 , TF.INPUT_DATE
		 , TF.LAST_UPDATE_DATE
		 /* SUMMARY 확인용 */
		-- , TF.ERP_MASTER_DATA
		 , TF.GSCM_MASTER_DATA
		 , TF.SUCCESS
		 , TF.TTT
		 , TF.STATUS_CODE_
		 , tei.EDIT_YN
	FROM (
		SELECT A.DIVISION_ID
			, A.SENDER_CODE EDI_SENDER_CODE
			, A.SENDER_NAME EDI_SENDER_NAME
			, A.UNLOADING_POINT CUST_UNLOADING_POINT
			, A.CUSTOMER_PLANT CUST_PLANT
			, A.CUST_MATERIAL_CODE CUST_ITEM_ID
			, A.SHIPTO_CODE ERP_SHIPTO
			, A.SOLDTO_CODE ERP_SOLDTO
			, A.ITEM_ID ERP_ITEM_ID
			, A.SCM_SITE_ID
			, A.STATUS_CODE
			, A.SSPM_STATUS
			, A.EDI_INCOTERMS--, CREATE_DATE
			, A.PROJECT_CODE
			, B.END_CUSTOMER
			, A.SALES_PLANT_SITE_STATUS
			, A.ERP_STATUS
            , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
            , CASE WHEN A.STATUS_CODE = 'S'			AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS SUCCESS
		-- FROM DUAL;
			/* SUMMARY 비교용 */
			--, CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_ERP'  AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS ERP_MASTER_DATA
			-- , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_GSCM' AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
			-- , CASE WHEN A.STATUS_CODE = 'S'			AND A.ERP_STATUS IS NULL		  AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS SUCCESS
			, CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'E'		  AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS TTT
			/* -------------*/
			, CASE WHEN LENGTH(TRIM(A.SCM_SITE_ID)) > 0	THEN A.SCM_SITE_ID		ELSE '확인필요' END AS GSCM_SALES_SITE_ID
			, CASE WHEN A.SALES_SITE_STATUS = 'S'		THEN 'Y'				ELSE '확인필요' END AS ACTIVE_SS
			, CASE WHEN A.SSPM_STATUS = 'S'				THEN 'Y'				ELSE '확인필요' END AS GSCM_SSPM
			, CASE WHEN A.INCOTERMS_STATUS = 'S'		THEN A.EDI_INCOTERMS	ELSE '확인필요' END AS GSCM_SSPM_INCOTERMS
            , CASE WHEN A.SSPM_STATUS = 'S'				THEN 'Y'				ELSE '확인필요' END AS ACTIVE_SSPM
			/* , CASE WHEN NVL((SELECT VALID_YN FROM SCM_MST_PROJECT_ITEM
								WHERE DIVISION_ID = p_DIVISION_ID
								AND PROJECT_CODE  = A.PROJECT_CODE
								AND ITEM_ID = A.ITEM_ID), 'N') = 'Y' THEN '' ELSE '확인필요' END AS ACTIVE_SSPM */
            --, CASE WHEN A.PROJECT_STATUS  = 'S'			 THEN NULL ELSE '확인필요' END AS PROJECT_STATUS
			--, CASE WHEN A.SALES_PLANT_SITE_STATUS  = 'S' THEN NULL ELSE '확인필요' END AS PLANT_SITE_STATUS
            , CASE WHEN A.PROJECT_STATUS  = 'S'			 THEN A.PROJECT_CODE ELSE '확인필요' END AS PROJECT_STATUS
			, CASE WHEN A.SALES_PLANT_SITE_STATUS  = 'S' THEN A.SALES_PLANT_SITE_ID ELSE '확인필요' END AS PLANT_SITE_STATUS
			, CASE WHEN A.EXCEPTION_FLAG = 'Y'  THEN 1 ELSE 0 END		AS "EXCEPTION"
			, NVL(TO_CHAR(MAX(A.EXCEPTION_DATE), 'YYYYMMDD'), '') EXCEPTION_DATE
			, A.EXCEPTION_FLAG EXCEPTION_FLAG
			, COUNT(1) CNT
			, MAX(CREATE_DATE) INPUT_DATE
			, TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYYMMDD') LAST_UPDATE_DATE
			, SUM(CASE WHEN STATUS_CODE IN ('U','E') AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y'  THEN 1 ELSE 0 END) STATUS_CODE_
			, SUM(CASE WHEN A.EXCEPTION_FLAG = 'Y'  THEN 1 ELSE 0 END) STATUS_CODE_EXCEP
		FROM DM_DNM_EDI_CALLOFF_ITEM A
		LEFT OUTER JOIN SCM_MST_SITE B
					ON A.DIVISION_ID      = B.DIVISION_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND B.SITE_TYPE	 = 'SALES'
						AND B.VALID_YN   = 'Y'
		WHERE   A.CREATE_DATE  >= v_FROM_YYYYMMDD
		AND     A.DIVISION_ID   = p_DIVISION_ID
		AND     A.SENDER_NAME   = p_Sender_Name
        AND     A.ERP_STATUS    = 'S' -- RDD가 이상하게 들어오면 버림
		AND     LTRIM(RTRIM(A.YYYYMMDD)) NOT IN ('444444')   /* 20240422 추가 YYYYMMDD = '444444' 인 데이터가 들어오고있는데...이 데이터는 날짜형태가 부적합 하기 때문에 사용이 불가;
															따라서 정비 필요 모수에서 제외하는게 적절해 보인다로 내부의견을 전달 드립니다. */
        /* ----------------------------------------------------------------------------------------------------- */
        --AND A.SENDER_NAME   <> 'LUCID'
		--AND A.ERP_STATUS    <> 'E' -- RDD가 이상하게 들어오면 버림
		--AND A.STATUS_CODE   <> 'X' -- 어디서 업뎃했는지 모르겠는데, 지금 사용불가
	    /* ----------------------------------------------------------------------------------------------------- */
		GROUP BY A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT, A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
				, A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
				, A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS , A.EXCEPTION_FLAG
				, A.SALES_SITE_STATUS, A.INCOTERMS_STATUS
				, A.PROJECT_STATUS,A.SALES_PLANT_SITE_ID

	) TF
	INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
	   ON tei.UNIT_ID = TF.DIVISION_ID
	WHERE 1=1
	/* Flag별 조회조건
		=======================================================
		sFlag(sFlag)  설명                          columnindex
		=======================================================
	    ING_ERP       ERP Master Data  정비필요          		<-- 사용안함 현재는 Column Index 가 3이면 EDI Sender Name 컬럼. (2면 Div)
		ING_GSCM      GSCM Master Data 정비필요         4
		S             정상                              5
		EXCEPTION     예외처리                          6
		=======================================================	*/
	AND CASE WHEN NVL(p_Flag, '0') > '0' THEN (CASE WHEN NVL(p_Flag, '0') = '6'
                                                    THEN TF.EXCEPTION_FLAG
                                                    ELSE CASE WHEN TF.STATUS_CODE='S' THEN 'S' ELSE 'U' END END)
            ELSE 'ZZ' END
	  = CASE WHEN p_Flag = '4' THEN 'U'
			 WHEN p_Flag = '5' THEN 'S'
			 WHEN p_Flag = '6' THEN 'Y'
		ELSE 'ZZ' END
	AND CASE WHEN p_Flag    = '5' /*정상*/
			 THEN  --9999
				  (CASE WHEN NVL(TF.STATUS_CODE_EXCEP , 0) > 0 THEN 0 ELSE 1 END)
	         ELSE CASE WHEN p_Flag = '6'
			           THEN TF. STATUS_CODE_EXCEP
			      ELSE TF.STATUS_CODE_ END
		END > 0
	ORDER BY TF.EDI_SENDER_CODE , TF.LAST_UPDATE_DATE;

	/*
	--2024-12-31 변경
	SELECT TF.DIVISION_ID
	     , TF.EDI_SENDER_CODE
		 , TF.EDI_SENDER_NAME
		 , TF.CUST_UNLOADING_POINT
		 , TF.CUST_PLANT
		 , TF.CUST_ITEM_ID
		 , TF.ERP_SHIPTO
		 , TF.ERP_SOLDTO
		 , TF.ERP_ITEM_ID
		 , TF.SCM_SITE_ID
		 , TF.STATUS_CODE
		 , TF.SSPM_STATUS
		 , TF.EDI_INCOTERMS
		 , TF.PROJECT_CODE
		 , TF.END_CUSTOMER
		 , TF.GSCM_SALES_SITE_ID
		 , TF.ACTIVE_SS
		 , TF.GSCM_SSPM
		 , TF.GSCM_SSPM_INCOTERMS
		 , TF.ACTIVE_SSPM
		 , TF.PROJECT_STATUS
		 , TF.PLANT_SITE_STATUS
		 , TF.EXCEPTION
		 , TF.EXCEPTION_DATE
		 , TF.EXCEPTION_FLAG
		 , TF.CNT
		 , TF.SALES_PLANT_SITE_STATUS
		 , TF.ERP_STATUS
		 , TF.INPUT_DATE
		 , TF.LAST_UPDATE_DATE
		 -- SUMMARY 확인용
		 , TF.ERP_MASTER_DATA
		 , TF.GSCM_MASTER_DATA
		 , TF.SUCCESS
		 , TF.TTT
		 , TF.STATUS_CODE_
	FROM (
		SELECT A.DIVISION_ID
			, A.SENDER_CODE EDI_SENDER_CODE
			, A.SENDER_NAME EDI_SENDER_NAME
			, A.UNLOADING_POINT CUST_UNLOADING_POINT
			, A.CUSTOMER_PLANT CUST_PLANT
			, A.CUST_MATERIAL_CODE CUST_ITEM_ID
			, A.SHIPTO_CODE ERP_SHIPTO
			, A.SOLDTO_CODE ERP_SOLDTO
			, A.ITEM_ID ERP_ITEM_ID
			, A.SCM_SITE_ID
			, A.STATUS_CODE
			, A.SSPM_STATUS
			, A.EDI_INCOTERMS--, CREATE_DATE
			, A.PROJECT_CODE
			, B.END_CUSTOMER
			, A.SALES_PLANT_SITE_STATUS
			, A.ERP_STATUS
			-- SUMMARY 비교용
			, CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_ERP'  AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS ERP_MASTER_DATA
			, CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_GSCM' AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
			, CASE WHEN A.STATUS_CODE = 'S'			AND A.ERP_STATUS IS NULL		  AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS SUCCESS
			, CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'E'		  AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS TTT
			-- -------------
			, CASE WHEN A.SCM_SITE_ID IS NOT NULL			THEN A.SCM_SITE_ID		ELSE '확인필요' END AS GSCM_SALES_SITE_ID
			, CASE WHEN A.SALES_SITE_STATUS = 'S'	THEN NULL				ELSE '확인필요' END AS ACTIVE_SS
			, CASE WHEN A.SSPM_STATUS = 'S'			THEN NULL				ELSE '확인필요' END AS GSCM_SSPM
			, CASE WHEN A.EDI_INCOTERMS IS NOT NULL		THEN A.EDI_INCOTERMS	ELSE '확인필요' END AS GSCM_SSPM_INCOTERMS

			, CASE WHEN NVL((SELECT VALID_YN FROM SCM_MST_PROJECT_ITEM
								WHERE DIVISION_ID = p_DIVISION_ID
								AND PROJECT_CODE  = A.PROJECT_CODE
								AND ITEM_ID = A.ITEM_ID), 'N') = 'Y' THEN '' ELSE '확인필요' END AS ACTIVE_SSPM

			, CASE WHEN A.PROJECT_STATUS  = 'S'			 THEN NULL ELSE '확인필요' END AS PROJECT_STATUS
			, CASE WHEN A.SALES_PLANT_SITE_STATUS  = 'S' THEN NULL ELSE '확인필요' END AS PLANT_SITE_STATUS
	*/

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
END DMF0008_GET_EDI_MST_REPAIR;
/
-- SOURCE-FRESH: SCM_MGR.DMF0008_GET_EDI_MST_SUMMARY PROCEDURE LAST_DDL=2026-09-14 18:27:51 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0008_GET_EDI_MST_SUMMARY" 
(
  p_FROM_YYYYMMDD VARCHAR2,  --안쓰임
  p_TO_YYYYMMDD   VARCHAR2,  --안쓰임
  p_DIVISION_ID   VARCHAR2,  --쓰임
  p_user_id       VARCHAR2,
  p_menu_id       VARCHAR2,
  O_RC1           OUT SYS_REFCURSOR,
  O_RC3           OUT SYS_REFCURSOR,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0008_GET_EDI_MST_SUMMARY
 * Description  : ERP, EDI MASTER DATA 정비 SUMMARY
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.05  kdmcc14   ERP, EDI MASTER DATA 정비 SUMMARY
 2023.09.20  chutoc730 제외 ITEM_ID 적용 (DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE)
 2024.04.18  HMIN      [E20240405-001867] 예외 처리 칼럼 추가
 2024.07.03  JSSBAE    [E20240701-000472] 업데이트 범위 개선
 2024-12-31  dsiol     [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 2025-01-21  dsiol     2차배포
 2026-03-15  김준규    [PJ20264226] NextSCM Pilot 설계 및 개발
 2026-05-15  전병주    컴파일 오류 수정
 2026-06-05  Claude    line 132 OPEN O_RC1 FOR DUMMY 제거 (메인 cursor 덮어쓰기 사고 fix)
*/
AS
  v_FROM_YYYYMMDD VARCHAR2(4000 CHAR);
  v_TO_YYYYMMDD   VARCHAR2(4000 CHAR);
  v_in_para_data  VARCHAR2(4000);
  V_LOG_TYPE      VARCHAR2(20)        := NULL;
  N_LOG_COUNT     NUMBER              := 0;
  V_LOG_MESSAGE   VARCHAR2(4000 CHAR) := NULL;
  V_DESCRIPTION   VARCHAR2(4000 CHAR) := NULL;
  D_EVENT_DATE    DATE                := SYSDATE;
  V_PROC_INPUT    CLOB                := NULL;
  V_SQL_CODE      VARCHAR2(100)       := NULL;
  V_SQL_ERRMSG    VARCHAR2(4000 CHAR) := NULL;
  V_BACKTRACE     VARCHAR2(4000 CHAR) := NULL;
  v_program_name  VARCHAR2(150 CHAR)  := $$PLSQL_UNIT;
BEGIN
  v_in_para_data := JSON_OBJECT(
    'p_FROM_YYYYMMDD' VALUE p_FROM_YYYYMMDD,
    'p_TO_YYYYMMDD'   VALUE p_TO_YYYYMMDD,
    'p_DIVISION_ID'   VALUE p_DIVISION_ID,
    'p_user_id'       VALUE p_user_id,
    'p_menu_id'       VALUE p_menu_id
  );
  V_PROC_INPUT := v_in_para_data;

  -- 현재시점으로 과거 52주 구간의 가장 최신인 EDI 데이터를 가져 온다.
  v_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') - (52 * 7), 'YYYYMMDD');

  BEGIN
    OPEN O_RC1 FOR
      SELECT T.DIVISION_ID                  AS DIVISION_ID
           , T.SENDER_NAME                   AS EDI_SENDER_NAME
           , SUM(GSCM_MASTER_DATA)           AS GSCM_MASTER_DATA
           , SUM(SUCCESS)                    AS SUCCESS
           , SUM("EXCEPTION")                AS EXCEPTION_DATA
           , COUNT(1)                        AS CNT
           , tei.EDIT_YN                     AS EDIT_YN
        FROM (
              SELECT A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT
                   , A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
                   , A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID
                   , A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
                   , A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS
                   /* 2025.01.10 Philsu Park 수정 */
                   , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
                   , CASE WHEN A.STATUS_CODE = 'S'         AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS SUCCESS
                   , CASE WHEN A.EXCEPTION_FLAG = 'Y'      THEN 1 ELSE 0 END AS "EXCEPTION"
                FROM DM_DNM_EDI_CALLOFF_ITEM A
                LEFT OUTER JOIN SCM_MST_SITE B
                  ON  A.DIVISION_ID = B.DIVISION_ID
                  AND A.SCM_SITE_ID = B.SCM_SITE_ID
                  AND B.SITE_TYPE   = 'SALES'
                  AND B.VALID_YN    = 'Y'
               WHERE A.CREATE_DATE  >= v_FROM_YYYYMMDD
                 AND A.DIVISION_ID   = p_DIVISION_ID
                 AND A.ERP_STATUS    = 'S'  -- ERP Status 정상인 대상만 Count
                 AND LTRIM(RTRIM(A.YYYYMMDD)) NOT IN ('444444')  /* 20240422 추가 */
               GROUP BY A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT
                      , A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
                      , A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID
                      , A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
                      , A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS
                      , A.ERP_STATUS, A.EXCEPTION_FLAG
             ) T
        INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
          ON tei.UNIT_ID = T.DIVISION_ID
       GROUP BY T.DIVISION_ID, T.SENDER_NAME, tei.EDIT_YN
       ORDER BY T.SENDER_NAME;

    -- 2026-06-05 fix : OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL; (제거 — 메인 cursor 덮어쓰기)
    -- O_RC3 는 As-Is 에 없으나 OUT param 안전성 위해 DUMMY 유지
    OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL;
  END;

  OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE
         , CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG
         , 'SUCCESS' AS ERR_EVENT
      FROM DUAL;

EXCEPTION
  WHEN OTHERS THEN
    V_LOG_TYPE   := 'ERROR';
    V_SQL_CODE   := TO_CHAR(SQLCODE);
    V_SQL_ERRMSG := SQLERRM;
    V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PR_SCM_SYS_LOG_BATCH(
      $$PLSQL_UNIT,
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
    RAISE_APPLICATION_ERROR(
      -20001,
      '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE
        || ' / SQLERRM='   || SQLERRM
        || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
    );
END DMF0008_GET_EDI_MST_SUMMARY;
/
-- SOURCE-FRESH: SCM_MGR.DMF0008_GET_SALES_SITE PROCEDURE LAST_DDL=2026-09-14 18:27:51 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0008_GET_SALES_SITE" 
(
  p_division_id   VARCHAR2,
  p_soldto        VARCHAR2,
  p_shipto        VARCHAR2,
  p_scm_site_id   VARCHAR2,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0008_GET_SALES_SITE
 * Program History
 *===================================================================================================
 2023.04.05  kdmcc14  ERP, EDI MASTER DATA 정비 SALES_SITE
 2024.12.31  dsiol    [PJ2024-50647]
 2025.01.21  dsiol    2차배포
 2026.03.26  김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
 2026-05-15  전병주   컴파일 오류 수정
 2026-06-05  Claude   TRUNCATE → DELETE 변환 + UTL_CALL_STACK SUBPROGRAM(1)(2) 안전화 (ORA-06533 fix)
*/
AS
  v_program_name VARCHAR2(200)        := $$PLSQL_UNIT;
  v_cnt_1        INTEGER              := 0;
  v_in_para_data VARCHAR2(4000);
  v_step         VARCHAR2(4000 CHAR)  := NULL;
  V_LOG_TYPE     VARCHAR2(20)         := NULL;
  N_LOG_COUNT    NUMBER               := 0;
  V_LOG_MESSAGE  VARCHAR2(4000 CHAR)  := NULL;
  V_DESCRIPTION  VARCHAR2(4000 CHAR)  := NULL;
  D_EVENT_DATE   DATE                 := SYSDATE; 
  V_PROC_INPUT   CLOB                 := NULL;
  V_SQL_CODE     VARCHAR2(100)        := NULL;
  V_SQL_ERRMSG   VARCHAR2(4000 CHAR)  := NULL;
  V_BACKTRACE    VARCHAR2(4000 CHAR)  := NULL;
BEGIN
  -- 2026-06-05 fix : TRUNCATE → DELETE
  DELETE FROM GT_GSSI_DMF0008_RESULT_TABLE_1_2;
  DELETE FROM GT_GSSI_DMF0008_RESULT_TABLE_2_2;

  v_in_para_data := JSON_OBJECT(
    'p_division_id' VALUE p_division_id,
    'p_soldto'      VALUE p_soldto,
    'p_shipto'      VALUE p_shipto,
    'p_scm_site_id' VALUE p_scm_site_id
  );

  -- 2026-06-05 fix : UTL_CALL_STACK.SUBPROGRAM(1) 의 length 검사 추가 (ORA-06533 방지)
  BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT >= 2 THEN
      v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
      v_program_name := $$PLSQL_UNIT;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_program_name := $$PLSQL_UNIT;  -- 어떤 사유로든 UTL_CALL_STACK 실패 시 안전 fallback
  END;

  -- 1차 : Division + Sold to + Ship to + Sales Site 4 키 조합 조회
  BEGIN
    INSERT /*+ NO_PARALLEL */ INTO GT_GSSI_DMF0008_RESULT_TABLE_1_2
    SELECT '1' SearchType, TEMP.*
      FROM (
            SELECT S.DIVISION_ID
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'XXX' ELSE T.DEPT_ID END         AS TEAM_ID
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'XXX' ELSE T.DEPT_NAME_KO END    AS TEAM_NAME
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'acer' ELSE S.END_CUSTOMER END   AS END_CUSTOMER
                 , S.SOLDTO_CUSTOMER SOLDTO_CUSTOMER
                 , C.SOLDTO_CODE REP_SOLDTO_CODE
                 , C.SHIPTO_CODE REP_SHIPTO_CODE
                 , S.COUNTRY
                 , CO.COUNTRY_NAME
                 , S.CITY
                 , CT.CITY_NAME
                 , S.SCM_SITE_ID SSCM_SITE_ID
                 , S.COMPANY_ID
                 , S.SITE_DESCRIPTION
                 , S.ATTRIBUTE3 DISTRIBUTION_CHANNEL
                 , S.VMI_YN
                 , S.VALID_YN SITE_VALID_YN
                 , C.VALID_YN CUSTOMER_VALID_YN
                 , C.REP_YN REP_YN
                 , S.LAST_UPDATED_BY
                 , S.LAST_UPDATE_DATE
                 , S.ATTRIBUTE2 SHIP_PLAN_AUTO
                 , CASE WHEN S.DIVISION_ID <> '40' AND ((FN_GET_DEPT_LIST('[@p_created_by]', T.DEPT_ID) = 'Y') OR '[@v_group_id]' = 'ADMIN') THEN 'Y'
                        WHEN S.DIVISION_ID  = '40' AND ((FN_GET_DEPT_LIST2('[@p_created_by]', S.SCM_SITE_ID) = 'Y')
                             OR '[@v_group_id]' = 'ADMIN' OR '[@p_created_by]' = S.LAST_UPDATED_BY) THEN 'Y' ELSE 'N' END AS EDIT_FLAG
                 , (SELECT NVL(MAX(LU.VALID_YN), 'N')
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL LU
                     WHERE LU.LOOKUP_TYPE = 'SALES_MGMT_TEAM'
                       AND LU.VALID_YN    = 'Y'
                       AND ( LU.SEGMENT1 = (SELECT MAX(Dept_ID) FROM SCM_ADM_USER_M WHERE USER_ID = '[@p_created_by]')
                          OR LU.SEGMENT1 = '[@p_userinfo]' )
                       AND '[@v_group_id]' = 'ADMIN') TEAM_EDIT_FLAG
                 , S.ATTRIBUTE5
              FROM SCM_MST_SITE S
              LEFT OUTER JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y') T
                ON S.ATTRIBUTE4 = T.DEPT_ID
              LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER C ON S.DIVISION_ID = C.DIVISION_ID AND S.SCM_SITE_ID = C.SCM_SITE_ID
              LEFT OUTER JOIN SCM_MST_COUNTRY CO     ON S.COUNTRY     = CO.COUNTRY
              LEFT OUTER JOIN SCM_MST_CITY    CT     ON S.COUNTRY     = CT.COUNTRY AND S.CITY = CT.CITY
             WHERE 1 = 1
               AND S.DIVISION_ID = p_division_id
               AND S.SCM_SITE_ID = p_scm_site_id
               AND C.SOLDTO_CODE = p_soldto
               AND C.SHIPTO_CODE = p_shipto
           ) TEMP;
  END;

  -- 2차 : 1차 0 row 시 Division + Sold to + Ship to 3 키 조합 (Sales Site 제외) 조회
  IF (SQL%ROWCOUNT = 0) THEN
    INSERT /*+ NO_PARALLEL */ INTO GT_GSSI_DMF0008_RESULT_TABLE_2_2
    SELECT TEMP.*
      FROM (
            SELECT S.DIVISION_ID
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'XXX' ELSE T.DEPT_ID END         AS TEAM_ID
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'XXX' ELSE T.DEPT_NAME_KO END    AS TEAM_NAME
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'acer' ELSE S.END_CUSTOMER END   AS END_CUSTOMER
                 , S.SOLDTO_CUSTOMER SOLDTO_CUSTOMER
                 , C.SOLDTO_CODE REP_SOLDTO_CODE
                 , C.SHIPTO_CODE REP_SHIPTO_CODE
                 , S.COUNTRY
                 , CO.COUNTRY_NAME
                 , S.CITY
                 , CT.CITY_NAME
                 , S.SCM_SITE_ID SSCM_SITE_ID
                 , S.COMPANY_ID
                 , S.SITE_DESCRIPTION
                 , S.ATTRIBUTE3 DISTRIBUTION_CHANNEL
                 , S.VMI_YN
                 , S.VALID_YN SITE_VALID_YN
                 , C.VALID_YN CUSTOMER_VALID_YN
                 , C.REP_YN REP_YN
                 , S.LAST_UPDATED_BY
                 , S.LAST_UPDATE_DATE
                 , S.ATTRIBUTE2 SHIP_PLAN_AUTO
                 , CASE WHEN S.DIVISION_ID <> '40' AND ((FN_GET_DEPT_LIST('[@p_created_by]', T.DEPT_ID) = 'Y') OR '[@v_group_id]' = 'ADMIN') THEN 'Y'
                        WHEN S.DIVISION_ID  = '40' AND ((FN_GET_DEPT_LIST2('[@p_created_by]', S.SCM_SITE_ID) = 'Y')
                             OR '[@v_group_id]' = 'ADMIN' OR '[@p_created_by]' = S.LAST_UPDATED_BY) THEN 'Y' ELSE 'N' END AS EDIT_FLAG
                 , (SELECT NVL(MAX(LU.VALID_YN), 'N')
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL LU
                     WHERE LU.LOOKUP_TYPE = 'SALES_MGMT_TEAM'
                       AND LU.VALID_YN    = 'Y'
                       AND ( LU.SEGMENT1 = (SELECT MAX(Dept_ID) FROM SCM_ADM_USER_M WHERE USER_ID = '[@p_created_by]')
                          OR LU.SEGMENT1 = '[@p_userinfo]' )
                       AND '[@v_group_id]' = 'ADMIN') TEAM_EDIT_FLAG
                 , S.ATTRIBUTE5
              FROM SCM_MST_SITE S
              LEFT OUTER JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y') T
                ON S.ATTRIBUTE4 = T.DEPT_ID
              LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER C ON S.DIVISION_ID = C.DIVISION_ID AND S.SCM_SITE_ID = C.SCM_SITE_ID
              LEFT OUTER JOIN SCM_MST_COUNTRY CO     ON S.COUNTRY     = CO.COUNTRY
              LEFT OUTER JOIN SCM_MST_CITY    CT     ON S.COUNTRY     = CT.COUNTRY AND S.CITY = CT.CITY
             WHERE 1 = 1
               AND S.DIVISION_ID = p_division_id
               AND C.SOLDTO_CODE = p_soldto
               AND C.SHIPTO_CODE = p_shipto
           ) TEMP;
  END IF;

  SELECT COUNT(1) INTO v_cnt_1 FROM GT_GSSI_DMF0008_RESULT_TABLE_1_2;
  IF v_cnt_1 > 0 THEN
    OPEN O_RESULT_CURSOR FOR
    SELECT T.* FROM GT_GSSI_DMF0008_RESULT_TABLE_1_2 T;
  ELSE
    OPEN O_RESULT_CURSOR FOR
    SELECT T.* FROM GT_GSSI_DMF0008_RESULT_TABLE_2_2 T;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    V_LOG_TYPE   := 'ERROR';
    V_SQL_CODE   := TO_CHAR(SQLCODE);
    V_SQL_ERRMSG := SQLERRM;
    V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PR_SCM_SYS_LOG_BATCH(
      v_program_name,
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
    RAISE_APPLICATION_ERROR(
      -20001,
      '[' || v_program_name || '] SQLCODE=' || SQLCODE
        || ' / SQLERRM=' || SQLERRM
        || ' / PARAMS=' || v_in_para_data
    );
END DMF0008_GET_SALES_SITE;
/
-- SOURCE-FRESH: SCM_MGR.DMF0008_GET_SALES_SITE_PROJECT_MODEL PROCEDURE LAST_DDL=2026-09-14 18:27:51 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0008_GET_SALES_SITE_PROJECT_MODEL" 
(
	  p_division_id      VARCHAR2,
	  p_item_id		VARCHAR2,
	  p_scm_site_id	VARCHAR2
  , p_user_id VARCHAR2
  , p_menu_id VARCHAR2
  , O_RC1  OUT SYS_REFCURSOR
  , O_RESULT_CURSOR OUT SYS_REFCURSOR)
/*
 * Program ID   : DMF0008_GET_SALES_SITE_PROJECT_MODEL
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.05	   kdmcc14		  []  ERP, EDI MASTER DATA 정비 SAELS_SITE_PROJECT_MODEL
 2024.08.14		KJJ				[PJ2024-50461] Team Mapping
 2024.12.12		KJJ				[PJ2024-50611] DEPT_ID에 부서명이 아닌 부서코드를 바인딩하게 수정

DMF0008_GET_SALES_SITE_PROJECT_MODEL('81', 'APFMCCX48-A1', 'Ford AS_DE_QKL');
  * 2026.03.26 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
  * 
  * #T_SINGLE -> GT_GSSP_SINGLE
  * #SCM_MST_SITE_ITEM -> GT_GSSP_SCM_MST_SITE_ITEM
  * 
  * 
 */
  
 -- 2026-05-18 전병주 컴파일 오류 수정

-- ------------------------------------------------------------------------------------------------------------------------------
AS
    v_program_name VARCHAR2(200) := $$PLSQL_UNIT;

    v_group_id VARCHAR2(50 CHAR) := NULL;
    v_cnt_1  INTEGER := 0;
    v_in_para_data VARCHAR2(4000);
    v_step         VARCHAR2(4000 CHAR) := NULL;
    V_LOG_TYPE    VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_item_id' VALUE p_item_id,
            'p_scm_site_id' VALUE p_scm_site_id
          );

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

	SELECT COUNT(1)
	INTO v_cnt_1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	where LOOKUP_TYPE = 'GET_ADMIN_GROUP'
	AND VALID_YN = 'Y'
	AND SEGMENT2 = 'ALL'; -- 'ALL'인경우, DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
	--AND SEGMENT1 = p_userinfo
	IF v_cnt_1 > 0 THEN
	
			v_group_id := 'ADMIN';
	
	END IF;

--   2026.09.06 AJS : 아래 GT_GSSP 적재 블록은 읽는 곳이 없어 제외(AS-IS 원문도 동일)
--		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GSSP_SINGLE';

--		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GSSP_SCM_MST_SITE_ITEM';

	
--			INSERT /*+ NO_PARALLEL */ INTO GT_GSSP_SINGLE ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_CLASS_NAME, NICK_NAME )
--			SELECT	T1.DIVISION_ID
--				, T1.ITEM_ID
--				, MAX(T1.ITEM_NAME) ITEM_NAME
--				, case  min( case when T1.item_type = 'P' then 1
--								when T1.item_type = 'H' then 2
--								when T1.item_type = 'Q' then 3
--								else 4 end )
--												when 1 then 'P'
--												when 2 then 'H'
--												when 3 then 'Q'
--												else 'R' end	AS ITEM_TYPE
--				, MAX(T1.ITEM_CLASS_NAME) ITEM_CLASS_NAME
--				, MAX(T1.NICK_NAME) NICK_NAME
--			FROM SCM_MST_ITEM_SN T1
--			WHERE 1=1
--				AND T1.DIVISION_ID = p_division_id
--				AND T1.ITEM_ID = p_item_id
--				AND T1.ITEM_TYPE IN ( 'H', 'P' ) --AND T1.ITEM_TYPE IN ( 'H', 'P' )
--			GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

--			INSERT /*+ NO_PARALLEL */ INTO GT_GSSP_SCM_MST_SITE_ITEM (DIVISION_ID, SCM_SITE_ID,  PROJECT_CODE, CNT)
--			SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, SUM(CASE WHEN B.ITEM_TYPE IN ( 'H', 'P' ) THEN 1 ELSE 0 END )
--			FROM SCM_MST_SITE_ITEM A
--			LEFT OUTER JOIN GT_GSSP_SINGLE B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
--			WHERE A.DIVISION_ID = p_division_id
--			GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE;

--DMF0008_GET_SALES_SITE_PROJECT_MODEL('81', 'EMCV00143AB');
--SELECT * FROM GT_GSSP_SCM_MST_SITE_ITEM_2
	
			OPEN O_RC1 FOR SELECT T1.*
			             , tei.EDIT_YN
			FROM (SELECT		   SITE_PROJECT.DIVISION_ID,
						   TEAM.DEPT_ID, -- 주석제거 : [PJ2024-50611] DEPT_ID에 부서명이 아닌 부서코드를 바인딩하게 수정
						   --TEAM.DEPT_ID AS DEPT_ID2,
						   --TEAM.DEPT_NAME_KO AS DEPT_ID, --주석처리 : [PJ2024-50611] DEPT_ID에 부서명이 아닌 부서코드를 바인딩하게 수정
						   TEAM.DEPT_NAME_KO AS DEPT_ID2,
						   TEAM.DEPT_NAME_KO TEAM_NAME_KO,
						   SITE.END_CUSTOMER END_CUSTOMER,
						   SITE.END_CUSTOMER END_CUSTOMER40,
						   SITE_CUST.SOLDTO_CODE,
	     				   CUST.SOLDTO_DESCRIPTION, --화면상에서는 일단 숨김처리
						   SITE_CUST.SHIPTO_CODE,
						   CUST.SHIPTO_DESCRIPTION, --화면상에서는 일단 숨김처리
						   SITE_PROJECT.SCM_SITE_ID,
						   SITE_PROJECT.SCM_SITE_ID SCM_SITE_ID40,
						   SITE_PROJECT.PROJECT_CODE,
						   PJT.PROJECT_NAME,
						   PJT.PROJECT_STATUS,
						   PJT.PROJECT_OWNER, -- 'SYSTEM' AS PROJECT_OWNER, --PJT.PROJECT_OWNWER      현재 컬럼이 없음.
						   SITE_PROJECT.owner AS USER_ID,	--20180806
						   SITE_ITEM.SALES_PLAN_ADJUST_YN,
						   SITE_ITEM.ITEM_TYPE,
						   --G.ITEM_TYPE,
						   SITE_ITEM.ITEM_CLASS_NAME,
						   SITE_ITEM.ITEM_ID,
						   SITE_ITEM.ITEM_NAME,
						   SITE_ITEM.CELL_PER_CAR,
						   SITE_ITEM.CELL_PER_MODULE,
						   CASE WHEN TO_NUMBER(SITE_ITEM.CELL_PER_MODULE) = 0 THEN 1 ELSE TO_NUMBER(SITE_ITEM.CELL_PER_CAR) / TO_NUMBER(SITE_ITEM.CELL_PER_MODULE) END  AS MODULE_PER_CAR,
						   CUST_ITEM.CUSTOMER_MODEL,
						   SITE_ITEM.NICK_NAME,
						   SITE_ITEM.SALES_COMPANY,
						   SITE_ITEM.SALES_PLANT,
						   SITE_ITEM.BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
						   SITE_ITEM.LIABILITY_PERIOD,
						   SITE_ITEM.CURRENCY,
						   CASE WHEN SITE_ITEM.ITEM_ID IS NULL THEN NVL(SITE_PROJECT.VALID_YN,SITE_ITEM.VALID_YN) ELSE SITE_ITEM.VALID_YN END AS VALID_YN,

						   SITE_ITEM.LAST_UPDATE_DATE,
						   SITE_ITEM.LAST_UPDATED_BY
						   ,SITE_ITEM.CUST_GROUP
						   ,SITE_ITEM.CUST_GROUP_DTL
						   , FN_GET_MULTI_OWNER_NAME (SITE_ITEM.OWNER, ',', '1') OWNER  -- 20180803
						   ,SITE_ITEM.APPLICATION
						   ,SITE_ITEM.ROUTE
						   ,SITE_ITEM.EDI		-- C20200827-000257 테슬라 EDI
						   ,SITE_ITEM.EDI_LT	-- C20200827-000257 테슬라 EDI
						   ,SITE_ITEM.ATTRIBUTE1
						   ,SITE_ITEM.ATTRIBUTE2
						   ,SITE_ITEM.ATTRIBUTE4  --20180726
						   ,SITE_ITEM.ATTRIBUTE5  --[C20211112-000213]
						   ,SITE_ITEM.ATTRIBUTE9 PRODUCTION_PROCESS--[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
						   -- -----------------------------
						   ,SITE.SOLDTO_CUSTOMER
						   /*,REPORT_GROUP1
						   ,REPORT_GROUP2
						   ,REPORT_GROUP3
						   ,REPORT_GROUP4
						   ,REPORT_GROUP6
						   ,REPORT_GROUP7
						   ,REPORT_GROUP8*/
						   ,SITE_ITEM.CELL_TYPE		-- 20190919
						   , NVL(SITE_PROJECT.VMI_LT,0) VMI_LT
			FROM		   (SELECT	DISTINCT
									A.DIVISION_ID
									,SCM_SITE_ID
									,PROJECT_CODE
									,NVL(MAX(VALID_YN),'Y') VALID_YN
									,A.owner		--,'' owner
									,A.ITEM_ID	--,'' ITEM_ID
									/*,REPORT_GROUP1
									,REPORT_GROUP2
									,REPORT_GROUP3
									,REPORT_GROUP4
									,REPORT_GROUP6
									,REPORT_GROUP7
									,REPORT_GROUP8*/
									, MAX(A.SCP_VMI_LT) VMI_LT
										,A.DEPT_ID   -- 2026.09.03 AJS
							FROM	SCM_MST_SITE_ITEM A
--								   ,SCM_MST_ITEM_SN B   -- 2026.09.06 AJS
							WHERE   A.ITEM_ID = p_item_id

							  and   A.division_id <> '40'

							  AND   A.SCM_SITE_ID = p_scm_site_id
							GROUP BY A.DIVISION_ID
									,SCM_SITE_ID
									,PROJECT_CODE
									,A.ATTRIBUTE1
									,A.ATTRIBUTE2
									,A.OWNER
									,A.ITEM_ID
										,A.DEPT_ID   -- 2026.09.03 AJS
									/*,REPORT_GROUP1
									,REPORT_GROUP2
									,REPORT_GROUP3
									,REPORT_GROUP4
									,REPORT_GROUP6
									,REPORT_GROUP7
									,REPORT_GROUP8*/
							 UNION
							 SELECT	DISTINCT
									A.DIVISION_ID,
									SCM_SITE_ID,
									PROJECT_CODE,
									VALID_YN,
									a.owner,
									ITEM_ID
									/*,REPORT_GROUP1
									,REPORT_GROUP2
									,REPORT_GROUP3
									,REPORT_GROUP4
									,REPORT_GROUP6
									,REPORT_GROUP7
									,REPORT_GROUP8*/
									,A.SCP_VMI_LT
										,A.DEPT_ID   -- 2026.09.03 AJS
							FROM	SCM_MST_SITE_ITEM A

							WHERE    A.division_id = '40'

							AND   A.SCM_SITE_ID = p_scm_site_id
														) SITE_PROJECT

			LEFT JOIN SCM_MST_PROJECT PJT
			ON				SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
			AND				SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID

			LEFT JOIN SCM_MST_SITE SITE
			ON				SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID
			AND				SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
			AND             SITE.SITE_TYPE  = 'SALES'

--			LEFT JOIN (
--				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
--				FROM SCM_MST_SSO_USER_INFO B
--				INNER JOIN SCM_MST_SSO_DEPT_INFO C
--				ON B.DEPT_ID = C.DEPT_ID
--			) TEAM
--			ON              TEAM.USER_ID   IN (SELECT value FROM TABLE(fn_splitstring(SITE_PROJECT.owner, ',')))
			LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM   -- 2026.09.03 AJS
			ON              TEAM.DEPT_ID = SITE_PROJECT.DEPT_ID   -- 2026.09.03 AJS

			LEFT JOIN		(SELECT T1.DIVISION_ID,
									T1.SCM_SITE_ID,
									T1.PROJECT_CODE,
									T1.ITEM_ID,
									T1.CELL_PER_CAR,
									T1.CELL_PER_MODULE,
									T2.ITEM_NAME,
									T2.ITEM_TYPE,
									T2.ITEM_CLASS_NAME,
									T1.SALES_PLAN_ADJUST_YN,
									T2.NICK_NAME,
									T1.BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
									T1.LIABILITY_PERIOD,
									T1.CURRENCY,
									T1.VALID_YN,
									T1.LAST_UPDATE_DATE,
									T1.LAST_UPDATED_BY
									--20180601, LSH---------
									,T1.CUST_GROUP
									,T1.CUST_GROUP_DTL
									,T1.OWNER
									,T1.APPLICATION
									,T1.ROUTE
									,T1.ATTRIBUTE6 EDI	--	C20200827-000257 테슬라 EDI
									,T1.EDI_LT				--	C20200827-000257 테슬라 EDI
									,T1.ATTRIBUTE1
									,T1.ATTRIBUTE2
									,T1.ATTRIBUTE5			--	[C20211112-000213]
									--,T1.ATTRIBUTE4  --20180726  -> [CSR ID:3997942] 20190612 주석처리
									,CO.COUNTRY_NAME ATTRIBUTE4 -- [CSR ID:3997942] 20190612 추가
									,T1.ATTRIBUTE9    --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
									,(SELECT LMD.SEGMENT2  AS NAME
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD
										WHERE LOOKUP_TYPE = 'CELL_TYPE' AND T2.CELL_TYPE = LMD.SEGMENT1 ) CELL_TYPE		-- 20190919

									,T1.SALES_COMPANY
									,T1.SALES_PLANT
									-- --------------------
							  FROM	SCM_MST_SITE_ITEM		T1
							  JOIN 	DM_MST_ITEM_SINGLE_V	T2
							  ON	T1.DIVISION_ID = T2.DIVISION_ID
							  AND	T1.ITEM_ID   = T2.ITEM_ID

								INNER JOIN 	SCM_MST_SITE	T3
								ON	T1.DIVISION_ID = T3.DIVISION_ID
								AND	T1.SCM_SITE_ID   = T3.SCM_SITE_ID

								LEFT JOIN SCM_MST_COUNTRY CO
								ON T3.COUNTRY = CO.COUNTRY

								WHERE (T1.ITEM_ID = P_ITEM_ID AND T1.SCM_SITE_ID = p_scm_site_id)
							  --WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'H' END
							  --OR	 T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'P' END)
														) SITE_ITEM
			ON				SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID
			AND				SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
			AND				SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE

			----[PJ2024-50461] Team Mapping
			--AND             CASE WHEN SITE_PROJECT.DIVISION_ID = '40' THEN SITE_PROJECT.ITEM_ID ELSE  SITE_ITEM.ITEM_ID END = SITE_ITEM.ITEM_ID
			AND SITE_PROJECT.ITEM_ID = SITE_ITEM.ITEM_ID

			LEFT JOIN SCM_MST_SITE_CUSTOMER SITE_CUST
			ON				SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
			AND				SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
			AND				SITE_CUST.REP_YN      = 'Y'

			LEFT JOIN SCM_MST_CUSTOMER CUST
			ON				SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
			AND				SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
			AND				SITE_CUST.DIVISION_ID = CUST.DIVISION_ID

			--LEFT OUTER JOIN GT_GSSP_SINGLE_2 G  ON SITE_ITEM.DIVISION_ID = G.DIVISION_ID AND SITE_ITEM.ITEM_ID = G.ITEM_ID
			LEFT JOIN		(SELECT DIVISION_ID,
									 MAX(CUSTOMER_MODEL) CUSTOMER_MODEL,
									 SCM_SITE_ID,
									 PROJECT_CODE,
									 ITEM_ID
							  FROM   DM_MST_CUSTOMER_MODEL
							  WHERE  VALID_YN = 'Y'
							  GROUP BY DIVISION_ID,
									   SCM_SITE_ID,
									   PROJECT_CODE,
										ITEM_ID			) CUST_ITEM
			ON				SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
			AND				SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
			AND				SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
			AND				SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID
			WHERE  1 = 1
			AND SUBSTR(SITE_ITEM.SCM_SITE_ID, -3)  <> '-AS'
			) T1

			INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
			   ON tei.UNIT_ID = T1.DIVISION_ID
			WHERE  1 = 1
			AND T1.DIVISION_ID = p_division_id
			AND T1.ITEM_ID = p_item_id
			AND T1.SCM_SITE_ID = p_scm_site_id

			ORDER BY DIVISION_ID,
						   TEAM_NAME_KO,
						   END_CUSTOMER,
						   END_CUSTOMER40,
						   SOLDTO_CODE,
						   SHIPTO_CODE,
						   SCM_SITE_ID,
						   SCM_SITE_ID40,
						   PROJECT_CODE,
						   PROJECT_NAME,
						   PROJECT_STATUS,
						   PROJECT_OWNER, -- 'SYSTEM' AS PROJECT_OWNER, --PJT.PROJECT_OWNWER      현재 컬럼이 없음.
						   SALES_PLAN_ADJUST_YN,
						   ITEM_TYPE,
						   ITEM_CLASS_NAME,
						   ITEM_ID,
						   ITEM_NAME,
						   CUSTOMER_MODEL,
						   --[C20200513-000276] Sales_Company, Sales_Plant 컬럼 추가
						   SALES_COMPANY,
						   SALES_PLANT,
						   NICK_NAME,
						   BPMS_EXIST ,   --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
						   LIABILITY_PERIOD,
						   CURRENCY/*,
							-- 20190402
							REPORT_GROUP1
							,REPORT_GROUP2
							,REPORT_GROUP3
							,REPORT_GROUP4
							--,REPORT_GROUP5
							,REPORT_GROUP6
							,REPORT_GROUP7
							,REPORT_GROUP8*/
FETCH FIRST 1 ROWS ONLY;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_log_count) AS EVENT FROM DUAL;

    EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE   := 'ERROR';
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        PR_SCM_SYS_LOG_BATCH(
            v_program_name, 'ERROR', 0, SQLERRM, NULL, SYSDATE,
            p_in_para_data => v_in_para_data,
            p_sql_err_code => SQLCODE,
            p_sql_err_msg  => SQLERRM,
            p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
        RAISE_APPLICATION_ERROR(-20001,
            '[' || v_program_name || '] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || v_in_para_data
        );
END;
/
-- SOURCE-FRESH: SCM_MGR.DMF0008_GET_UPDATE_HISTORY PROCEDURE LAST_DDL=2026-08-25 20:17:05 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0008_GET_UPDATE_HISTORY" (
    P_USER_ID VARCHAR2,
    P_MENU_ID VARCHAR2,
    O_RC1     OUT SYS_REFCURSOR
) AS
    v_dummy SYS_REFCURSOR;
BEGIN
    SCM_MGR.DMF0000_GET_UPDATE_HISTORY(O_RC1, v_dummy);
END DMF0008_GET_UPDATE_HISTORY;
/
-- SOURCE-FRESH: SCM_MGR.DMF0008_SAVE_SALES_SITE_EDI_REPAIR PROCEDURE LAST_DDL=2026-09-14 18:27:51 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0008_SAVE_SALES_SITE_EDI_REPAIR" 
(
		p_division_id					IN  VARCHAR2,
		p_end_customer				IN  VARCHAR2,
		p_soldto_customer			IN  VARCHAR2,
		p_company_id					IN  VARCHAR2,
		p_scm_site_id					IN  VARCHAR2,
		p_soldto_code					IN  VARCHAR2,
		p_shipto_code					IN  VARCHAR2,
		p_vmi_yn							IN  VARCHAR2,
		p_valid_yn						IN  VARCHAR2,
		p_cust_valid_yn					IN  VARCHAR2,
		p_rep_yn							IN  VARCHAR2,
		p_country						IN  VARCHAR2,
		p_city								IN  VARCHAR2,
		p_ship_plan_auto				IN  VARCHAR2,
		p_dept_id						IN  VARCHAR2,
		p_created_by					IN  VARCHAR2,
		p_message_cursor				OUT SYS_REFCURSOR
)


IS

	/* SET NOCOUNT ON; */
	/* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; */
	/* SET XACT_ABORT ON; */

	v_DIVISION_ID				VARCHAR2(32767);
	v_END_CUSTOMER			VARCHAR2(32767);
	v_SOLDTO_CUSTOMER	VARCHAR2(32767);
	v_COMPANY_ID				VARCHAR2(32767);
	v_SCM_SITE_ID				VARCHAR2(32767);
	v_SOLDTO_CODE			VARCHAR2(32767);
	v_SHIPTO_CODE				VARCHAR2(32767);
	v_VMI_YN						VARCHAR2(32767);
	v_VALID_YN					VARCHAR2(32767);
	v_CUST_VALID_YN			VARCHAR2(32767);
	v_REP_YN						VARCHAR2(32767);
	v_COUNTRY					VARCHAR2(32767);
	v_CITY							VARCHAR2(32767);
	v_SHIP_PLAN_AUTO			VARCHAR2(32767);
	v_DEPT_ID						VARCHAR2(32767);
	v_CREATED_BY				VARCHAR2(32767);

	v_delimiter VARCHAR2(1 CHAR);

	max_loop_cnt		PLS_INTEGER := 0;
	mst_loop_cnt		PLS_INTEGER := 0;

	-- LOG 용 변수 설정
	v_program_name		VARCHAR2(150 CHAR) := 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR';
	v_log_type				VARCHAR2(30 CHAR); -- START/END/ERROR/...
	n_log_count			PLS_INTEGER := 0;
	v_log_message		VARCHAR2(1000 CHAR);
	v_description			VARCHAR2(500 CHAR);
	d_event_date			DATE;

	-- 결과 메시지 보관 (MSSQL SELECT N'...' 대체)
	v_result_message		VARCHAR2(4000 CHAR);

	-- 사용자 정의 예외 (INVALID 상태 처리용, goto err_rtn 대체)
	e_invalid_data EXCEPTION;

BEGIN

	v_DIVISION_ID				:= NULL;
	v_END_CUSTOMER			:= NULL;
	v_SOLDTO_CUSTOMER	:= NULL;
	v_COMPANY_ID				:= NULL;
	v_SCM_SITE_ID				:= NULL;
	v_SOLDTO_CODE			:= NULL;
	v_SHIPTO_CODE				:= NULL;
	v_VMI_YN						:= NULL;
	v_VALID_YN					:= NULL;
	v_CUST_VALID_YN			:= NULL;
	v_REP_YN						:= NULL;
	v_COUNTRY					:= NULL;
	v_CITY							:= NULL;
	v_SHIP_PLAN_AUTO			:= NULL;
	v_DEPT_ID						:= NULL;
	v_CREATED_BY				:= NULL;

	v_delimiter := '^';

	-- 시작 LOG
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := '';
	d_event_date := SYSDATE;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 시작 LOG  (END)
	v_log_message := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	-- BEGIN TRAN SAVE_SALES_SITE_EDI;
	SAVEPOINT SAVE_SALES_SITE_EDI;

	BEGIN

		-- 프로시저 LOOP 길이를 판단
		max_loop_cnt := SCM_ARR_SPL_CNT(p_division_id, v_delimiter);
		WHILE LENGTH(p_division_id) > 0 AND mst_loop_cnt < max_loop_cnt
		LOOP

			-- @mst_loop_cnt 1증가
			mst_loop_cnt := mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				v_DIVISION_ID := SCM_ARR_SPL_VAL(p_division_id, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_DIVISION_ID

				v_END_CUSTOMER := SCM_ARR_SPL_VAL(p_end_customer, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_END_CUSTOMER

				v_SOLDTO_CUSTOMER := SCM_ARR_SPL_VAL(p_soldto_customer, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SOLDTO_CUSTOMER

				v_COMPANY_ID := SCM_ARR_SPL_VAL(p_company_id, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_COMPANY_ID

				v_SCM_SITE_ID := SCM_ARR_SPL_VAL(p_scm_site_id, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SCM_SITE_ID

				v_SOLDTO_CODE := SCM_ARR_SPL_VAL(p_soldto_code, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SOLDTO_CODE

				v_SHIPTO_CODE := SCM_ARR_SPL_VAL(p_shipto_code, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SHIPTO_CODE

				v_VMI_YN := SCM_ARR_SPL_VAL(p_vmi_yn, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_VMI_YN

				v_VALID_YN := SCM_ARR_SPL_VAL(p_valid_yn, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_VALID_YN

				v_CUST_VALID_YN := SCM_ARR_SPL_VAL(p_cust_valid_yn, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_CUST_VALID_YN

				v_REP_YN := SCM_ARR_SPL_VAL(p_rep_yn, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_REP_YN

				v_COUNTRY := SCM_ARR_SPL_VAL(p_country, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_COUNTRY

				v_CITY := SCM_ARR_SPL_VAL(p_city, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_CITY

				v_SHIP_PLAN_AUTO := SCM_ARR_SPL_VAL(p_ship_plan_auto, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_SHIP_PLAN_AUTO

				v_DEPT_ID := SCM_ARR_SPL_VAL(p_dept_id, v_delimiter , mst_loop_cnt) ;
				--SELECT @v_DEPT_ID

				v_created_by := p_created_by;

			END;

			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start -----------------------------------------------
			IF v_VALID_YN = '' OR v_VALID_YN IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := '필수 입력값을 확인하세요.';
				v_description := '필수 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_DIVISION_ID = '' OR v_DIVISION_ID IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Div 입력값을 확인하세요.';
				v_description := 'Div 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_SCM_SITE_ID = '' OR v_SCM_SITE_ID IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Sales Site 입력값을 확인하세요.';
				v_description := 'Sales Site 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_SOLDTO_CODE = '' OR v_SOLDTO_CODE IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Sold-To 입력값을 확인하세요.';
				v_description := 'Sold-To 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_SHIPTO_CODE = '' OR v_SHIPTO_CODE IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Rep Ship-To 입력값을 확인하세요.';
				v_description := 'Rep Ship-To 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;

			IF v_CUST_VALID_YN = '' OR v_CUST_VALID_YN IS NULL THEN
				v_log_type := 'INVALID';
				v_result_message := 'Customer Active 입력값을 확인하세요.';
				v_description := 'Customer Active 입력값을 확인하세요.';
				RAISE e_invalid_data;
			END IF;
			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 end -----------------------------------------------

			--SCM_MST_SITE_HIST History 생성
			BEGIN
				INSERT INTO SCM_MST_SITE_H
						( HISTORY_SEQ, DIVISION_ID, SCM_SITE_ID, PLANT_ID, OPERATION_GROUP, SITE_DESCRIPTION, SITE_TYPE, CITY, COUNTRY, DEPT_ID
						, VMI_YN, VALID_YN, NEW_YN, SITE_HRCY_ID, OSP_YN, SHIP_FROZEN, PROD_FROZEN, END_CUSTOMER, SOLDTO_CUSTOMER, FP_PLAN_PERIOD
						, BUILD_AHEAD, LOGISTIC_PLANT_ID, PACKER_ITEM_ID_SUFFIX, HQ_VENDOR_CODE, COMPANY_ID, SITE_ID, CREATED_BY, CREATION_DATE
						, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
						, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, HISTORY_CREATION_DATE )
				SELECT SEQ1_SCM_MST_SITE_H.NEXTVAL, DIVISION_ID, SCM_SITE_ID, PLANT_ID, OPERATION_GROUP, SITE_DESCRIPTION, SITE_TYPE, v_CITY, v_COUNTRY, '-' AS DEPT_ID         -- v_DEPT_ID2026.09.06 AJS  
						, v_VMI_YN, v_VALID_YN, NEW_YN, SITE_HRCY_ID, OSP_YN, SHIP_FROZEN, PROD_FROZEN, v_END_CUSTOMER, v_SOLDTO_CUSTOMER, FP_PLAN_PERIOD
						, BUILD_AHEAD, LOGISTIC_PLANT_ID, PACKER_ITEM_ID_SUFFIX, HQ_VENDOR_CODE, v_COMPANY_ID, SITE_ID, v_CREATED_BY, SYSDATE
						, v_CREATED_BY, SYSDATE, ATTRIBUTE1, v_SHIP_PLAN_AUTO, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
						, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, SYSDATE
				FROM SCM_MST_SITE
				WHERE DIVISION_ID = v_DIVISION_ID
				AND SCM_SITE_ID = v_SCM_SITE_ID;
			END;

			--SCM_MST_SITE_CUSTOMER History 생성
			BEGIN
				PR_DM_MST_SITE_CUSTOMER_HIST(
							 v_DIVISION_ID
							, v_SCM_SITE_ID
							, v_SOLDTO_CODE
							, v_SHIPTO_CODE
							, v_REP_YN
							, v_CREATED_BY
							, v_CUST_VALID_YN);
			END;

			IF mst_loop_cnt > 0 THEN

				BEGIN

					--SCM_MST_SITE_CUSTOMER
					MERGE INTO SCM_MST_SITE_CUSTOMER A
					USING (
								SELECT
									v_DIVISION_ID	AS DIVISION_ID,
									v_SCM_SITE_ID	AS SITE_ID,
									v_SOLDTO_CODE AS SOLDTO_CODE,
									v_SHIPTO_CODE AS SHIPTO_CODE
								FROM DUAL
							) B
					ON(
								A.DIVISION_ID  = B.DIVISION_ID
							AND A.SCM_SITE_ID  = B.SITE_ID
							AND A.SOLDTO_CODE = B.SOLDTO_CODE
							AND A.SHIPTO_CODE = B.SHIPTO_CODE
					)
					WHEN MATCHED THEN
						UPDATE SET
								    REP_YN = NVL(v_REP_YN, 'N')
								  , VALID_YN = NVL(v_CUST_VALID_YN, 'N')
								  , LAST_UPDATED_BY = v_CREATED_BY
								  , LAST_UPDATE_DATE = SYSDATE

					WHEN NOT MATCHED THEN
						INSERT (
									 DIVISION_ID
								   , SCM_SITE_ID
								   , SOLDTO_CODE
								   , SHIPTO_CODE
								   , REP_YN
								   , VALID_YN
								   , CREATED_BY
								   , CREATION_DATE
								   , LAST_UPDATED_BY
								   , LAST_UPDATE_DATE
								   )
						VALUES (
									 v_DIVISION_ID
								   , v_SCM_SITE_ID
								   , v_SOLDTO_CODE
								   , v_SHIPTO_CODE
								   , NVL(v_REP_YN, 'N')
								   , NVL(v_CUST_VALID_YN, 'N')
								   , v_CREATED_BY
								   , SYSDATE
								   , v_CREATED_BY
								   , SYSDATE
								   );

					--SCM_MST_SITE

					--임시확인용
					/* SELECT @v_DIVISION_ID AS DIVISION_ID, @v_SCM_SITE_ID AS  SCM_SITE_ID, @v_SOLDTO_CODE AS SOLDTO_CODE, @v_SHIPTO_CODE AS SHIPTO_CODE, @v_VALID_YN AS VALID_YN */
					NULL;

					MERGE INTO SCM_MST_SITE A
					USING (
							SELECT
								v_DIVISION_ID	AS DIVISION_ID,
								v_SCM_SITE_ID	AS SITE_ID
							FROM DUAL
						) B
					ON(
								A.DIVISION_ID  = B.DIVISION_ID
							AND A.SCM_SITE_ID  = B.SITE_ID

						)
					WHEN MATCHED THEN
						UPDATE SET
									CITY = v_CITY
								  , COUNTRY = v_COUNTRY
--								  ,	DEPT_ID	= v_DEPT_ID		-- 2026.09.03 AJS 사이트 원장 부서 칸 갱신 제외
								  ,	VMI_YN = NVL(v_VMI_YN, 'N')
								  ,	VALID_YN = v_VALID_YN
								  , END_CUSTOMER = v_END_CUSTOMER
								  , SOLDTO_CUSTOMER = v_SOLDTO_CUSTOMER
								  , COMPANY_ID = v_COMPANY_ID
								  , ATTRIBUTE2 = v_SHIP_PLAN_AUTO
								  , LAST_UPDATED_BY = v_CREATED_BY
								  , LAST_UPDATE_DATE	= SYSDATE

					WHEN NOT MATCHED THEN
						INSERT (
								     DIVISION_ID
								   , SCM_SITE_ID
								   , SITE_DESCRIPTION
								   , SITE_TYPE
								   , END_CUSTOMER
								   , SOLDTO_CUSTOMER
								   , CITY
								   , COUNTRY
--								   , DEPT_ID		-- 2026.09.03 AJS 사이트 원장 부서 칸 등록 제외
								   , VMI_YN
								   , VALID_YN
								   , NEW_YN
								   , COMPANY_ID
								   , CREATED_BY
								   ,CREATION_DATE
								   ,LAST_UPDATED_BY
								   ,LAST_UPDATE_DATE
								   ,ATTRIBUTE2
								   )
						VALUES (
									 v_DIVISION_ID
								   , v_SCM_SITE_ID
								   , v_SCM_SITE_ID
								   , 'SALES'
								   , v_END_CUSTOMER
								   , v_SOLDTO_CUSTOMER
								   , v_CITY
								   , v_COUNTRY
--								   , v_DEPT_ID		-- 2026.09.03 AJS 사이트 원장 부서 칸 등록 제외 (VALUES 대응)
								   , NVL(v_VMI_YN, 'N')
								   , v_VALID_YN
								   , 'Y'
								   , v_COMPANY_ID
								   , v_CREATED_BY
								   , SYSDATE
								   , v_CREATED_BY
								   , SYSDATE
								   , v_SHIP_PLAN_AUTO
								   );

				END;

			END IF;

		END LOOP;

/*
  EXEC DMF0008_SAVE_SALES_SITE_EDI_REPAIR @p_division_id='81', @p_end_customer='BMW', @p_soldto_customer='BMW'
	, @p_company_id='G480', @p_scm_site_id='BMW_AT_GRZ', @p_soldto_code='AT000003A', @p_shipto_code='AT000003A'
	, @p_vmi_yn='N', @p_valid_yn='Y', @p_cust_valid_yn='Y', @p_rep_yn='Y'
	, @p_country='AT', @p_city='ATGRZ', @p_ship_plan_auto='Y', @p_dept_id='58665472', @p_created_by='kdmcc14'

  EXEC DMF0008_SAVE_SALES_SITE_EDI_REPAIR @p_division_id='81^81', @p_end_customer='BMW^BMW', @p_soldto_customer='BMW^BMW'
	, @p_company_id='G480^G480', @p_scm_site_id='BMW_AT_GRZ^BMW_AT_SER', @p_soldto_code='AT000003A^DE000272', @p_shipto_code='AT000003A^ATH000024'
	, @p_vmi_yn='N^N', @p_valid_yn='Y^Y', @p_cust_valid_yn='Y^Y', @p_rep_yn='Y^Y'
	, @p_country='AT^AT', @p_city='ATGRZ^ATSER', @p_ship_plan_auto='Y^Y', @p_dept_id='58665472^58665472', @p_created_by='kdmcc14'

 */

		COMMIT;

	EXCEPTION
		WHEN e_invalid_data THEN
			-- 트랜잭션 (END)
			-- err_rtn:
			IF v_log_type = 'INVALID' THEN
				ROLLBACK TO SAVEPOINT SAVE_SALES_SITE_EDI;
				v_log_type := 'END';
				v_log_message := '########## END of procedure ##########';
				d_event_date := SYSDATE;
				PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			END IF;

		WHEN OTHERS THEN

			ROLLBACK TO SAVEPOINT SAVE_SALES_SITE_EDI;

			-- ERROR LOG
			v_log_type := 'ERROR';
			v_log_message := SUBSTR(SQLERRM, 1, 1000);
			v_description := 'ERROR_LINE : ' || TO_CHAR($$PLSQL_LINE);
			d_event_date := SYSDATE;

			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

			v_result_message := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

	END;

	-- 종료 LOG
	v_log_type := 'END';
	v_log_message := '########## END of procedure ##########';
	v_description := '';
	d_event_date := SYSDATE;

	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 결과 메시지 반환 (MSSQL SELECT N'필수 입력값을 확인하세요.' / ERROR_MESSAGE 결과셋 → SYS_REFCURSOR OUT)
	OPEN p_message_cursor FOR
		SELECT v_result_message AS RESULT_MSG FROM DUAL;

END;
/
-- SOURCE-FRESH: SCM_MGR.DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR PROCEDURE LAST_DDL=2026-09-08 17:37:00 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR" 
(
    p_division_id         VARCHAR2,
    p_project_code          VARCHAR2,
    p_scm_site_id         VARCHAR2,
    p_item_id             VARCHAR2,
    p_currency            VARCHAR2,
    p_kwh               VARCHAR2, --ATTRIBUTE8
    p_cell_per_car          VARCHAR2,
    p_cell_per_module       VARCHAR2,
    p_liability_period        VARCHAR2,
    p_valid_yn            VARCHAR2,
    p_bpms_exist          VARCHAR2,
    p_sales_company       VARCHAR2,
    p_sales_plant         VARCHAR2,
    p_module_variant        VARCHAR2, --ATTRIBUTE2
    p_incoterms           VARCHAR2, --ATTRIBUTE6
    p_created_by          VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
    , O_RC3  OUT  SYS_REFCURSOR
    , O_RC4  OUT  SYS_REFCURSOR
    , O_RC5  OUT  SYS_REFCURSOR
    , O_RC6  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID  : DMF0008_SAVE_EDI_MST_REPAIR
 * Description  : EDI GSCM MASTER DATA 정비
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.05    kdmcc14      []  EDI GSCM MASTER DATA 정비
 2026.03.15    김준규      [PJ20264226] NextSCM Pilot 설계 및 개발
 */
 /*
  DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR(p_division_id='81', p_project_code='A15PA7001');
    , p_scm_site_id='PSA_FR_VSL', p_item_id='APPSAPHEV-B1-D02', p_currency='EUR'
    , p_kwh = NULL, p_cell_per_car='84', p_cell_per_module='14', p_liability_period='0'
    , p_valid_yn='Y', p_bpms_exist='Y', p_sales_company='G480', p_sales_plant='G481'
    , p_module_variant = NULL, p_incoterms='FCA', p_created_by='kdmcc14'
    
*/
-- -------------------------------------------------------------------------------------------------------------------------------
AS

    v_DIVISION_ID VARCHAR2(4000 CHAR);
    v_PROJECT_CODE VARCHAR2(4000 CHAR);
    v_SCM_SITE_ID VARCHAR2(4000 CHAR);
    v_ITEM_ID VARCHAR2(4000 CHAR);
    v_CURRENCY VARCHAR2(4000 CHAR);
    v_KWH VARCHAR2(4000 CHAR);
    v_CELL_PER_CAR VARCHAR2(4000 CHAR);
    v_CELL_PER_MODULE VARCHAR2(4000 CHAR);
    v_LIABILITY_PERIOD VARCHAR2(4000 CHAR);
    v_VALID_YN VARCHAR2(4000 CHAR);
    v_BPMS_EXIST VARCHAR2(4000 CHAR);
    v_SALES_COMPANY VARCHAR2(4000 CHAR);
    v_SALES_PLANT VARCHAR2(4000 CHAR);
    v_MODULE_VARIANT VARCHAR2(4000 CHAR);
    v_INCOTERMS VARCHAR2(4000 CHAR);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_in_para_data VARCHAR2(4000);
    v_err_msg VARCHAR2(4000);
    v_err_code NUMBER;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_project_code' VALUE p_project_code,
            'p_scm_site_id' VALUE p_scm_site_id,
            'p_item_id' VALUE p_item_id,
            'p_currency' VALUE p_currency,
            'p_kwh' VALUE p_kwh,
            'p_cell_per_car' VALUE p_cell_per_car,
            'p_cell_per_module' VALUE p_cell_per_module,
            'p_liability_period' VALUE p_liability_period,
            'p_valid_yn' VALUE p_valid_yn,
            'p_bpms_exist' VALUE p_bpms_exist,
            'p_sales_company' VALUE p_sales_company,
            'p_sales_plant' VALUE p_sales_plant,
            'p_module_variant' VALUE p_module_variant,
            'p_incoterms' VALUE p_incoterms,
            'p_created_by' VALUE p_created_by
          );

  v_DIVISION_ID := NULL;
  v_PROJECT_CODE := NULL;
  v_SCM_SITE_ID := NULL;
  v_ITEM_ID := NULL;
  v_CURRENCY := NULL;
  v_KWH := NULL;
  v_CELL_PER_CAR := NULL;
  v_CELL_PER_MODULE := NULL;
  v_LIABILITY_PERIOD := NULL;
  v_VALID_YN := NULL;
  v_BPMS_EXIST := NULL;
  v_SALES_COMPANY := NULL;
  v_SALES_PLANT := NULL;
  v_MODULE_VARIANT := NULL;
  v_INCOTERMS := NULL;
  v_CREATED_BY := NULL;

  v_delimiter := '^';

  v_log_type := 'START';
  v_log_message := '########## Start of procedure ##########';
  v_description := NULL;
  d_event_date := SYSTIMESTAMP;
  PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );

  -- 시작 LOG  (END)
  v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

  -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

    -- 프로시저 LOOP 길이를 판단
    v_max_loop_cnt := SCM_ARR_SPL_CNT(p_division_id, v_delimiter);
    WHILE LENGTH(p_division_id) > 0 AND v_mst_loop_cnt < v_max_loop_cnt LOOP

      -- v_mst_loop_cnt 1증가
      v_mst_loop_cnt := v_mst_loop_cnt + 1;

      -- 각 컬럼들에 대한 스플릿처리로직 스타트
      BEGIN

        v_DIVISION_ID := SCM_ARR_SPL_VAL(p_division_id, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_DIVISION_ID
        v_PROJECT_CODE := SCM_ARR_SPL_VAL(p_project_code, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_PROJECT_CODE
        v_SCM_SITE_ID := SCM_ARR_SPL_VAL(p_scm_site_id, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_SCM_SITE_ID
        v_ITEM_ID := SCM_ARR_SPL_VAL(p_item_id, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_ITEM_ID
        v_CURRENCY := SCM_ARR_SPL_VAL(p_currency, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_CURRENCY
        v_KWH := SCM_ARR_SPL_VAL(p_kwh, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_KWH
        v_CELL_PER_CAR := SCM_ARR_SPL_VAL(p_cell_per_car, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_CELL_PER_CAR
        v_CELL_PER_MODULE := SCM_ARR_SPL_VAL(p_cell_per_module, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_CELL_PER_MODULE
        v_LIABILITY_PERIOD := SCM_ARR_SPL_VAL(p_liability_period, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_LIABILITY_PERIOD
        v_VALID_YN := SCM_ARR_SPL_VAL(p_valid_yn, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_VALID_YN
        v_BPMS_EXIST := SCM_ARR_SPL_VAL(p_bpms_exist, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_BPMS_EXIST
        v_SALES_COMPANY := SCM_ARR_SPL_VAL(p_sales_company, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_SALES_COMPANY
        v_SALES_PLANT := SCM_ARR_SPL_VAL(p_sales_plant, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_SALES_PLANT
        v_MODULE_VARIANT := SCM_ARR_SPL_VAL(p_module_variant, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_MODULE_VARIANT
        v_INCOTERMS := SCM_ARR_SPL_VAL(p_incoterms, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_INCOTERMS
        v_created_by := p_created_by;
 
      END;

      -- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start -----------------------------------------------
      IF v_VALID_YN IS NULL OR v_VALID_YN IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC1 FOR
          SELECT '필수 입력값을 확인하세요.'
          FROM DUAL;
          v_description := '필수 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      IF v_DIVISION_ID IS NULL OR v_DIVISION_ID IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC2 FOR
          SELECT 'Div 입력값을 확인하세요.'
          FROM DUAL;
          v_description := 'Div 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      IF v_PROJECT_CODE IS NULL OR v_PROJECT_CODE IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC3 FOR
          SELECT 'Project Code 입력값을 확인하세요.'
          FROM DUAL;
          v_description := 'Project Code 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      IF v_SCM_SITE_ID IS NULL OR v_SCM_SITE_ID IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC4 FOR
          SELECT 'Sales Site 입력값을 확인하세요.'
          FROM DUAL;
          v_description := 'Sales Site 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      IF v_ITEM_ID IS NULL OR v_ITEM_ID IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC5 FOR
          SELECT 'Model 입력값을 확인하세요.'
          FROM DUAL;
          v_description := 'Model 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      -- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 end -----------------------------------------------
      --SCM_MST_SITE_ITEM_H History 생성
      BEGIN
        INSERT INTO SCM_MST_SITE_ITEM_H
            ( DIVISION_ID ,HISTORY_SEQ, PROJECT_CODE ,SCM_SITE_ID, ITEM_ID
            , CURRENCY, CELL_PER_CAR, CELL_PER_MODULE, LIABILITY_PERIOD
            , SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID, VALID_YN, BPMS_EXIST
            , CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION, ROUTE  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
            , DEPT_ID   -- 2026.09.06 AJS 신규추가
            , SALES_COMPANY, SALES_PLANT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
--            , REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4
--            , REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8
            , EDI_LT, SCP_VMI_LT, PARTIAL_PLAN_YN )
        SELECT DIVISION_ID, SEQ1_SCM_MST_SITE_ITEM_H.NEXTVAL, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
            , v_CURRENCY, v_CELL_PER_CAR, v_CELL_PER_MODULE, v_LIABILITY_PERIOD
            , SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID, v_VALID_YN, v_BPMS_EXIST
            , CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION, ROUTE  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
            , DEPT_ID   -- 2026.09.06 AJS 신규추가
            , v_SALES_COMPANY, v_SALES_PLANT, v_CREATED_BY, SYSTIMESTAMP, v_CREATED_BY, SYSTIMESTAMP
            , ATTRIBUTE1, v_MODULE_VARIANT, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            , v_INCOTERMS, ATTRIBUTE7, v_KWH, ATTRIBUTE9, ATTRIBUTE10
--            , REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4
--            , REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8
            , EDI_LT, SCP_VMI_LT, PARTIAL_PLAN_YN
        FROM SCM_MST_SITE_ITEM
        WHERE DIVISION_ID = v_DIVISION_ID
        AND PROJECT_CODE = v_PROJECT_CODE
        AND SCM_SITE_ID = v_SCM_SITE_ID
        AND ITEM_ID = v_ITEM_ID;
      END;

      IF v_mst_loop_cnt > 0 THEN

          --SCM_MST_SITE_ITEM
          MERGE INTO SCM_MST_SITE_ITEM A
          USING (
              SELECT
                v_DIVISION_ID DIVISION_ID,
                v_PROJECT_CODE PROJECT_CODE,
                v_SCM_SITE_ID SCM_SITE_ID,
                v_ITEM_ID ITEM_ID
              FROM DUAL
              ) B
          ON(
                A.DIVISION_ID  = B.DIVISION_ID
              AND A.PROJECT_CODE = B.PROJECT_CODE
              AND A.SCM_SITE_ID  = B.SCM_SITE_ID
              AND A.ITEM_ID = B.ITEM_ID

            )
          WHEN MATCHED THEN
            UPDATE SET
                  CURRENCY = v_CURRENCY
                  , CELL_PER_CAR = (CASE WHEN v_CELL_PER_CAR = 0 THEN NULL WHEN v_CELL_PER_CAR IS NULL THEN NULL ELSE v_CELL_PER_CAR END)
                  , CELL_PER_MODULE = (CASE WHEN v_CELL_PER_MODULE = 0 THEN NULL WHEN v_CELL_PER_MODULE IS NULL THEN NULL ELSE v_CELL_PER_MODULE END)
                  , LIABILITY_PERIOD = v_LIABILITY_PERIOD
                  , VALID_YN = v_VALID_YN
                  , BPMS_EXIST = v_BPMS_EXIST
                  , SALES_COMPANY = v_SALES_COMPANY
                  , SALES_PLANT = v_SALES_PLANT
                  , ATTRIBUTE2 = v_MODULE_VARIANT
                  , ATTRIBUTE6 = v_INCOTERMS
                  , ATTRIBUTE8 = v_KWH
                  , LAST_UPDATED_BY = v_CREATED_BY
                  , LAST_UPDATE_DATE  = SYSTIMESTAMP

          WHEN NOT MATCHED THEN
            INSERT (
                     DIVISION_ID
                   , PROJECT_CODE
                   , SCM_SITE_ID
                   , ITEM_ID
                   , CURRENCY
                   , CELL_PER_CAR
                   , CELL_PER_MODULE
                   , LIABILITY_PERIOD
                   , VALID_YN
                   , BPMS_EXIST
                   , SALES_COMPANY
                   , SALES_PLANT
                   , CREATED_BY
                   , CREATION_DATE
                   , LAST_UPDATED_BY
                   , LAST_UPDATE_DATE
                   , ATTRIBUTE2
                   , ATTRIBUTE6
                   , ATTRIBUTE8
                   )
            VALUES (
                   v_DIVISION_ID
                   , v_PROJECT_CODE
                   , v_SCM_SITE_ID
                   , v_ITEM_ID
                   , v_CURRENCY
                   , (CASE WHEN v_CELL_PER_CAR = 0 THEN NULL WHEN v_CELL_PER_CAR IS NULL THEN NULL ELSE v_CELL_PER_CAR END)
                   , (CASE WHEN v_CELL_PER_MODULE = 0 THEN NULL WHEN v_CELL_PER_MODULE IS NULL THEN NULL ELSE v_CELL_PER_MODULE END)
                   , v_LIABILITY_PERIOD
                   , v_VALID_YN
                   , v_BPMS_EXIST
                   , v_SALES_COMPANY
                   , v_SALES_PLANT
                   , v_CREATED_BY
                   , SYSTIMESTAMP
                   , v_CREATED_BY
                   , SYSTIMESTAMP
                   , v_MODULE_VARIANT
                   , v_INCOTERMS
                   , v_KWH
                   );

        END IF;

    END LOOP;

/*
  DMF0008_SAVE_SALES_SITE_EDI_REPAIR(p_division_id='81', p_end_customer='BMW', p_soldto_customer='BMW');
  , p_company_id='G480', p_scm_site_id='BMW_AT_GRZ', p_soldto_code='AT000003A', p_shipto_code='AT000003A'
  , p_vmi_yn='N', p_valid_yn='Y', p_cust_valid_yn='Y', p_rep_yn='Y'
  , p_country='AT', p_city='ATGRZ', p_ship_plan_auto='Y', p_dept_id='58665472', p_created_by='kdmcc14'

  DMF0008_SAVE_SALES_SITE_EDI_REPAIR(p_division_id='81^81', p_end_customer='BMW^BMW', p_soldto_customer='BMW^BMW');
  , p_company_id='G480^G480', p_scm_site_id='BMW_AT_GRZ^BMW_AT_SER', p_soldto_code='AT000003A^DE000272', p_shipto_code='AT000003A^ATH000024'
  , p_vmi_yn='N^', p_valid_yn='Y^Y', p_cust_valid_yn='Y^Y', p_rep_yn='Y^Y'
  , p_country='AT^AT', p_city='ATGRZ^ATSER', p_ship_plan_auto='Y^Y', p_dept_id='58665472^58665472', p_created_by='kdmcc14'

 */
    COMMIT;

  -- END TRY

  -- 트랜잭션 (END)
  <<err_rtn>>
  IF v_log_type = 'INVALID' THEN
            v_log_type := 'END';
      v_log_message := '########## END of procedure ##########';
      d_event_date := SYSTIMESTAMP;
      PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
  END IF;

  RETURN;

    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
  EXCEPTION
      WHEN OTHERS THEN

    -- ERROR LOG
    v_err_code := SQLCODE;
    v_err_msg := SQLERRM;
    v_log_type := 'ERROR';
    v_log_message := SUBSTR(v_err_msg, 1, 1000);
    v_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
    d_event_date := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data  => v_in_para_data,
        p_sql_err_code  => v_err_code,
        p_sql_err_msg   => v_err_msg,
        p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

    OPEN O_RC6 FOR
    SELECT '['  ||  TO_CHAR(v_err_code)  ||  ']'  ||  v_err_msg
    FROM DUAL;

    -- END CATCH

  -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
    RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || v_in_para_data
    );
END;
/
-- 권한 (SCM_MGR)
GRANT EXECUTE ON SCM_MGR.DMF0008_GET_EDI_MST_REPAIR TO SCMP_APP;
GRANT EXECUTE ON SCM_MGR.DMF0008_GET_EDI_MST_SUMMARY TO SCMP_APP;
GRANT EXECUTE ON SCM_MGR.DMF0008_GET_SALES_SITE TO SCMP_APP;
GRANT EXECUTE ON SCM_MGR.DMF0008_GET_SALES_SITE_PROJECT_MODEL TO SCMP_APP;
GRANT EXECUTE ON SCM_MGR.DMF0008_GET_UPDATE_HISTORY TO SCMP_APP;
GRANT EXECUTE ON SCM_MGR.DMF0008_SAVE_SALES_SITE_EDI_REPAIR TO SCMP_APP;
GRANT EXECUTE ON SCM_MGR.DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR TO SCMP_APP;
-- 시노님 (SCMP_APP 로 실행할 것)
-- CREATE OR REPLACE SYNONYM SCMP_APP.DMF0008_GET_EDI_MST_REPAIR FOR SCM_MGR.DMF0008_GET_EDI_MST_REPAIR;
-- CREATE OR REPLACE SYNONYM SCMP_APP.DMF0008_GET_EDI_MST_SUMMARY FOR SCM_MGR.DMF0008_GET_EDI_MST_SUMMARY;
-- CREATE OR REPLACE SYNONYM SCMP_APP.DMF0008_GET_SALES_SITE FOR SCM_MGR.DMF0008_GET_SALES_SITE;
-- CREATE OR REPLACE SYNONYM SCMP_APP.DMF0008_GET_SALES_SITE_PROJECT_MODEL FOR SCM_MGR.DMF0008_GET_SALES_SITE_PROJECT_MODEL;
-- CREATE OR REPLACE SYNONYM SCMP_APP.DMF0008_GET_UPDATE_HISTORY FOR SCM_MGR.DMF0008_GET_UPDATE_HISTORY;
-- CREATE OR REPLACE SYNONYM SCMP_APP.DMF0008_SAVE_SALES_SITE_EDI_REPAIR FOR SCM_MGR.DMF0008_SAVE_SALES_SITE_EDI_REPAIR;
-- CREATE OR REPLACE SYNONYM SCMP_APP.DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR FOR SCM_MGR.DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR;
-- PROC_M (standalone PROC_NM · 멱등 MERGE)
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_REPAIR' PROC_NM, 'divisionId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_REPAIR' PROC_NM, 'fromYyyymmdd' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 2 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_REPAIR' PROC_NM, 'toYyyymmdd' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 3 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_REPAIR' PROC_NM, 'senderName' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 4 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_REPAIR' PROC_NM, 'flag' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 5 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_REPAIR' PROC_NM, 'sesUserId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 6 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_REPAIR' PROC_NM, 'mnuId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 7 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_REPAIR' PROC_NM, 'o_rc1' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 8 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_REPAIR' PROC_NM, 'O_RESULT_CURSOR' COL_NM, 'PROC_RESULT' DATA_TP_CD, 'OUT' COL_TP_CD, 9 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_SUMMARY' PROC_NM, 'fromYyyymmdd' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_SUMMARY' PROC_NM, 'toYyyymmdd' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 2 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_SUMMARY' PROC_NM, 'divisionId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 3 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_SUMMARY' PROC_NM, 'sesUserId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 4 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_SUMMARY' PROC_NM, 'mnuId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 5 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_SUMMARY' PROC_NM, 'o_rc1' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 6 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_SUMMARY' PROC_NM, 'o_rc3' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 7 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_EDI_MST_SUMMARY' PROC_NM, 'O_RESULT_CURSOR' COL_NM, 'PROC_RESULT' DATA_TP_CD, 'OUT' COL_TP_CD, 8 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE' PROC_NM, 'divisionId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE' PROC_NM, 'soldTo' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 2 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE' PROC_NM, 'shipTo' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 3 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE' PROC_NM, 'scmSiteId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 4 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE' PROC_NM, 'O_RESULT_CURSOR' COL_NM, 'PROC_RESULT' DATA_TP_CD, 'OUT' COL_TP_CD, 5 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL' PROC_NM, 'divisionId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL' PROC_NM, 'itemId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 2 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL' PROC_NM, 'scmSiteId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 3 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL' PROC_NM, 'sesUserId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 4 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL' PROC_NM, 'mnuId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 5 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL' PROC_NM, 'o_rc1' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 6 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL' PROC_NM, 'O_RESULT_CURSOR' COL_NM, 'PROC_RESULT' DATA_TP_CD, 'OUT' COL_TP_CD, 7 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_UPDATE_HISTORY' PROC_NM, 'sesUserId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_UPDATE_HISTORY' PROC_NM, 'mnuId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 2 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_GET_UPDATE_HISTORY' PROC_NM, 'o_rc1' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 3 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'divisionId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'endCustomer' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 2 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'soldtoCustomer' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 3 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'companyId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 4 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'scmSiteId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 5 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'soldtoCode' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 6 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'shiptoCode' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 7 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'vmiYn' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 8 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'validYn' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 9 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'custValidYn' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 10 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'repYn' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 11 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'country' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 12 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'city' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 13 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'shipPlanAuto' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 14 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'deptId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 15 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'sesUserId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 16 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR' PROC_NM, 'p_message_cursor' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 17 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'divisionId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'projectCode' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 2 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'scmSiteId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 3 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'itemId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 4 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'currency' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 5 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'kwh' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 6 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'cellPerCar' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 7 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'cellPerModule' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 8 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'liabilityPeriod' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 9 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'validYn' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 10 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'bpmsExist' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 11 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'salesCompany' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 12 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'salesPlant' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 13 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'moduleVariant' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 14 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'incoterms' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 15 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'sesUserId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 16 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'o_rc1' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 17 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'o_rc2' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 18 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'o_rc3' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 19 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'o_rc4' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 20 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'o_rc5' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 21 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'o_rc6' COL_NM, 'CURSOR' DATA_TP_CD, 'OUT' COL_TP_CD, 22 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR' PROC_NM, 'O_RESULT_CURSOR' COL_NM, 'PROC_RESULT' DATA_TP_CD, 'OUT' COL_TP_CD, 23 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
COMMIT;
