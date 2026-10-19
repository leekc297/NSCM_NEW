PROCEDURE           "PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE" 
/*=====================================================================================================================================================
 * Program ID   : PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE
 * Description  : MKT FCST 화면에서 저장 시 호출하는 프로시져로, Sales Plan AMT Create ( Local/KRW )
 * Program History
 *=====================================================================================================================================================
 *	  Date		In Charge		Description
 *=====================================================================================================================================================
 * 2017.02.05	DWOK/KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.08.08					SALES_PLAN_CUTOFF  주석처리
 * 2018.08.16					DMF0003_SAVE_MKT_FCST 저장시 호출되는 프로시져
 * 2020.02.13	HWI1993 		자동차사업부 SALES AMT 메저를 RTF_SCP 기준으로 생성
 * 2020.03.09	KHSONG 			TMM_FCST ADD
 * 2020.05.07	KHSONG 			C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.08.06	hwi1993			[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
 * 2020.09.09	P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020.12.08	P.C.I			[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2024.12.10	KJJ				[PJ2024-50611] Catch Up 메저 삭제 금지
 * 2025.01.21	JSSBAE			[E20250122-000837]_Sales Plan 화면 MKT FCST AMT. 개선요청
 * 2025.02.11	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 SCM_FCST MEASURE 추가
 * 2025.06.10	KANG.H.J		[PJ2025-50017] [PJ2025-50188] 임시테이블 DROP 처리
 * 2025.09.03	JSSBAE			[E20250826-000546]_Sales Plan 계획구간 일부 매출 데이터 누락
 * 2025.09.15	JSSBAE			[E20250915-000105]_GSCM 시스템 DP 입력 오류
 * 2025.10.16	PARK.CHOYI		속도개선
 * 2025.10.31	JSSBAE			[E20251021-000634]_FCST&PRICE MGMT SALES PLAN 데이터 동기화 속도개선
 * 2026.07.06	ZIONEX			[PJ202650304] NextSCM Migration
 * 2026.09.30	admin			[E20260930-DMF0082-81SP] 81 사업부 분기 추가 (DMF0082 81 저장 실시간 동기화 — 40 분기·공통부 무수정)
 *===================================================================================================================================================*/
AS
	/*================================================================================================================================================= */
	/* 스플릿관련 변수 (START) */
	/*================================================================================================================================================= */
	V_RECV_DIVISION_ID	VARCHAR2(4000 CHAR);
	V_DELIMITER			VARCHAR2(1 CHAR);
	N_MAX_LOOP_CNT		PLS_INTEGER := 0;
	N_MST_LOOP_CNT		PLS_INTEGER := 0;
	V_DIVISION_ID		VARCHAR2(4000 CHAR);
	V_CREATED_BY		VARCHAR2(4000 CHAR);
	/*================================================================================================================================================= */
	/* 스플릿관련 변수 (END) */
	/*================================================================================================================================================= */
	/* [E20250915-000105]_당주 월요일 변수를 받아 처리한다. */
	V_THIS_WEEK_MON		VARCHAR2(8 CHAR);
	/*================================================================================================================================================= */
	/* LOG 용 변수 설정 */
	/*================================================================================================================================================= */
	V_PROGRAM_NAME		VARCHAR2(150 CHAR) := 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE';
	V_LOG_TYPE			VARCHAR2(30 CHAR);		/* START/END/ERROR/... */
	N_LOG_COUNT			PLS_INTEGER := 0;
	V_LOG_MESSAGE		VARCHAR2(1000 CHAR);
	V_DESCRIPTION		VARCHAR2(500 CHAR);
	D_EVENT_DATE		DATE;
	V_INT_COUNT			PLS_INTEGER;			/* 원본 @v_int_count (본문 중간 DECLARE -> 선언부로 이동) */

	V_PROC_INPUT		VARCHAR2(4000 CHAR);
	V_SQL_CODE			VARCHAR2(100 CHAR);
	V_SQL_ERRMSG		VARCHAR2(1000 CHAR);
	V_BACKTRACE			VARCHAR2(4000 CHAR);
BEGIN
	/*================================================================================================================================================= */

	/*   원본 MSSQL 은 프로시저 시작 시 #temp 를 DROP + CREATE 로 재생성. Oracle 은 세션 GTT(ON COMMIT PRESERVE ROWS) 를 */


	/*================================================================================================================================================= */
	DELETE FROM GT_PRMF_T2_MKT_FCST;
	DELETE FROM GT_PRMF_T2_PRICE;
	DELETE FROM GT_PRMF_RESULTS_KEY;
	DELETE FROM GT_PRMF_SALES_PLAN_TEMP;
	DELETE FROM GT_PRMF_SALES_PLAN_TEMP_KEY;

	/*================================================================================================================================================= */
	/* 스플릿관련 변수 (START) */
	/*================================================================================================================================================= */
	V_RECV_DIVISION_ID	:= NULL;
	V_DELIMITER			:= '^';		/* 데이터 구분자 */
	/* 원본 : SET @v_created_by = ISNULL((SELECT MAX(v_created_by) FROM #results GROUP BY v_division_id),'SYSTEM') */
	BEGIN
		SELECT NVL(MAX(V_CREATED_BY), 'SYSTEM') INTO V_CREATED_BY
		  FROM GT_PRDM_RESULTS
		 GROUP BY V_DIVISION_ID;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			V_CREATED_BY := 'SYSTEM';
	END;
	/*------------------------------------------------------------------------------------------------------------------------------------------------- */
	/* [E20250915-000105]_당주 월요일 변수를 받아 처리한다. */
	/*------------------------------------------------------------------------------------------------------------------------------------------------- */
	V_THIS_WEEK_MON := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
	/*------------------------------------------------------------------------------------------------------------------------------------------------- */
	/* [PJ2025-50017] 소형 매출계획 동기화 개선 */
	/*------------------------------------------------------------------------------------------------------------------------------------------------- */
	SELECT MAX(V_DIVISION_ID) INTO V_DIVISION_ID FROM GT_PRDM_RESULTS;
	/*================================================================================================================================================= */
	/* 스플릿관련 변수 (END) */
	/*================================================================================================================================================= */

	/*================================================================================================================================================= */
	/* 시작 LOG  (START) */
	/*================================================================================================================================================= */
	V_LOG_TYPE		:= 'START';
	V_LOG_MESSAGE	:= '########## Start of procedure ##########';
	V_DESCRIPTION	:= '';
	D_EVENT_DATE	:= SYSDATE;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
	V_LOG_MESSAGE	:= NULL;		/*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	/*================================================================================================================================================= */
	/* 시작 LOG  (END) */
	/*================================================================================================================================================= */

	DBMS_OUTPUT.PUT_LINE('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE : A00A--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	/* [PJ2025-50017] 40 사업부는 DM_PLN_CFM_MKT_DEMAND_PLAN, DM_PLN_CFM_SELLING_PRICE 기반 데이터 생성 */
	/* [PJ2025-50017] 40 외 사업부는 DM_PLN_MKT_FCST, SCM_MST_FUTURE_PRICE 기반 데이터 생성. (단 CELL_PROD_SITE_ID는 '-'로 처리) START */
	IF (V_DIVISION_ID = '40') THEN

		SELECT COUNT(*) INTO N_LOG_COUNT
		  FROM GT_PRDM_RESULTS;

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_#RESULTS 데이터 로그생성 (START) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		V_LOG_TYPE		:= 'ING';	/*[C20200909-000203] LOG 표준화 적용 */
		V_LOG_MESSAGE	:= 'step-01-INSERT #RESULTS';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_#RESULTS 데이터 로그생성 (END) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_#RESULTS_KEY 데이터 생성 (START) */
		/* #RESULTS 에 들어오는 데이터는 MKT_FCST, SCM_FCST, LOC 메져이므로 MEASURE를 제외한 Sales Plan 테이블을 동기화 하기 위한 MIN, MAX YYYYMMDD 기준의 데이터만 필요 함 */
		/* AS-IS : 데이터를 가져올때 YYYYMMDD에 대한 기준이 없음, Measure 조건도 없음, 그러다보니 Join 중복데이터가 발생 함 */
		/* TO-BE : Measure, YYYYMMDD 를 제외한 Key 값 기준으로 #RESULTS_KEY 임시테이블 생성( MIN, MAX YYYYMMDD ) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		INSERT INTO GT_PRMF_RESULTS_KEY
		( V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
		, V_MIN_YYYYMMDD, V_MAX_YYYYMMDD )
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID
			 , D_MIN.BASIS_START_DATE
			 , D_MAX.BASIS_END_DATE
		  FROM ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
					  , MIN(V_YYYYMMDD) AS MIN_DATE
					  , MAX(V_YYYYMMDD) AS MAX_DATE
				   FROM GT_PRDM_RESULTS
				  GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID ) A
		  JOIN SCM_SYS_CALENDAR_M D_MIN ON D_MIN.BASIS_YYYYMMDD = A.MIN_DATE
		  JOIN SCM_SYS_CALENDAR_M D_MAX ON D_MAX.BASIS_YYYYMMDD = A.MAX_DATE;
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_#RESULTS_KEY 데이터 생성 (END) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_#RESULTS_KEY 데이터 로그생성 (START) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		V_LOG_TYPE		:= 'ING';	/*[C20200909-000203] LOG 표준화 적용 */
		V_LOG_MESSAGE	:= 'step-01-01-INSERT #RESULTS_KEY';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_#RESULTS_KEY 데이터 로그생성 (END) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */

		DBMS_OUTPUT.PUT_LINE('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE : A00C--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* DM_PLN_CFM_MKT_DEMAND_PLAN과 받아온 MKT FCST 정보를 JOIN하여 TEMP TABLE 생성 (START) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		INSERT INTO GT_PRMF_T2_MKT_FCST
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
		, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, BASIS_START_DATE )	/* [E20250915-000105]_당주 월요일 변수를 신규 생성 */
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, C.MEASURE, A.V_PLANT_SITE_ID, C.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
			 , C.YYYYMMDD, C.QTY, V_CREATED_BY, SYSDATE
			 , D.BASIS_START_DATE	/* [E20250915-000105]_당주 월요일 변수를 신규 생성 */
		  FROM GT_PRMF_RESULTS_KEY A	/*#results A --[E20251021-000634]_#RESULTS_KEY 테이블로 변경 */
		  JOIN DM_PLN_CFM_MKT_DEMAND_PLAN C
			ON A.V_DIVISION_ID		= C.DIVISION_ID
		   AND A.V_PROJECT_CODE		= C.PROJECT_CODE
		   AND A.V_SCM_SITE_ID		= C.SCM_SITE_ID
		   AND A.V_ITEM_ID			= C.ITEM_ID
		   AND A.V_DOM_EXP			= C.DOM_EXP
		   AND A.V_FCST_TYPE		= C.FCST_TYPE
		   AND A.V_INCOTERMS		= C.INCOTERMS
		   AND A.V_PLANT_SITE_ID	= CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
		   /*AND A.V_CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID	-- [PJ2025-50017] 중요(results에 V_CELL_PROD_SITE_ID 없음) */
		   /*AND C.QTY > 0 */
		  JOIN SCM_SYS_CALENDAR_M D
			ON D.BASIS_YYYYMMDD = C.YYYYMMDD
		 WHERE C.MEASURE IN ('MKT_FCST', 'SCM_FCST', 'RTF_SYS_RP')	/*[E20251021-000634]_필수 Measure 조건 추가 */
		   AND C.YYYYMMDD BETWEEN A.V_MIN_YYYYMMDD AND A.V_MAX_YYYYMMDD	/*[E20251021-000634]_MIN, MAX YYYYMMDD 조건 추가 */
		   AND D.BASIS_YYYYMMDD BETWEEN A.V_MIN_YYYYMMDD AND A.V_MAX_YYYYMMDD	/*[E20251021-000634]_MIN, MAX YYYYMMDD 조건 추가 */
		   AND C.QTY <> 0;	/*[E20251021-000634]_ 0 제외 */

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_#T2_MKT_FCST 데이터 로그생성 (START) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		V_LOG_MESSAGE	:= 'step-01-02-INSERT #T2_MKT_FCST  ';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_#T2_MKT_FCST 데이터 로그생성 (END) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* DM_PLN_CFM_MKT_DEMAND_PLAN과 받아온 정보를 JOIN하여 TEMP TABLE 생성 (END) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		DBMS_OUTPUT.PUT_LINE('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE : A00D--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* DM_PLN_CFM_SELLING_PRICE과 받아온 정보를 JOIN하여 TEMP TABLE 생성 (START) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */


		INSERT INTO GT_PRMF_T2_PRICE	/*#TEMP_PRICE -- [E20251021-000634]_#T2_MKT_FCST (최종) 테이블로 변경 */
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
		, CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE )
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID
			 , CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE
		  FROM ( SELECT A.V_DIVISION_ID AS DIVISION_ID, A.V_PROJECT_CODE AS PROJECT_CODE, A.V_SCM_SITE_ID AS SCM_SITE_ID, A.V_ITEM_ID AS ITEM_ID, A.V_DOM_EXP AS DOM_EXP, A.V_FCST_TYPE AS FCST_TYPE, A.V_INCOTERMS AS INCOTERMS, A.V_PLANT_SITE_ID AS PLANT_SITE_ID, C.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
					  , C.CURRENCY, C.MEASURE, C.YYYYMMDD, C.PRICE, V_CREATED_BY AS CREATED_BY, SYSDATE AS CREATION_DATE
					  , ROW_NUMBER() OVER (
							PARTITION BY A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP
								   , A.V_FCST_TYPE, A.V_INCOTERMS, NVL(TRIM(A.V_PLANT_SITE_ID), '-'), NVL(TRIM(C.CELL_PROD_SITE_ID), '-')
								   , C.MEASURE, C.YYYYMMDD
							ORDER BY C.PRICE DESC ) AS RN
			   FROM GT_PRMF_RESULTS_KEY A	/*#results A -- [E20251021-000634]_#RESULTS_KEY 테이블로 변경 */
			   JOIN DM_PLN_CFM_SELLING_PRICE C
				 ON A.V_DIVISION_ID		= C.DIVISION_ID
				AND A.V_PROJECT_CODE	= C.PROJECT_CODE
				AND A.V_SCM_SITE_ID		= C.SCM_SITE_ID
				AND A.V_ITEM_ID			= C.ITEM_ID
				AND A.V_DOM_EXP			= C.DOM_EXP
				AND A.V_FCST_TYPE		= C.FCST_TYPE
				AND A.V_INCOTERMS		= C.INCOTERMS
				AND A.V_PLANT_SITE_ID	= CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
				/*AND A.V_CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID		-- [PJ2025-50017] 중요(results에 V_CELL_PROD_SITE_ID 없음) */
			  WHERE C.PRICE > 0
				AND C.YYYYMMDD BETWEEN A.V_MIN_YYYYMMDD AND A.V_MAX_YYYYMMDD )	/* [E20251021-000634]_MIN, MAX YYYYMMDD 조건 추가 */
		 WHERE RN = 1;
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* DM_PLN_CFM_SELLING_PRICE과 받아온 정보를 JOIN하여 TEMP TABLE 생성 (END) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_T2_PRICE 데이터 로그생성 (START) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		V_LOG_MESSAGE	:= 'step-01-03-INSERT #T2_PRICE  ';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20251021-000634]_#T2_MKT_FCST 데이터 로그생성 (END) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		DBMS_OUTPUT.PUT_LINE('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE : A00E--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	/*[E20260930-DMF0082-81SP] 81 사업부 — DMF0082 81 저장 실시간 Sales Plan 동기화 (AS-IS [PJ2025-50017] 예고분 "40 외 사업부는
	   DM_PLN_MKT_FCST, SCM_MST_FUTURE_PRICE 기반 데이터 생성 (CELL_PROD_SITE_ID '-')" 구현 — AS-IS 코드는 40 분기만 존재).
	   원천 = 배치 PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW 비-40 분기와 동일 (81 Sales Plan 을 지금 만드는 경로와 값 일치):
	     MKT_FCST·SCM_FCST = DM_PLN_MKT_FCST (CELL_PROD '-') · RTF_SYS_RP = DM_PLN_CFM_MKT_DEMAND_PLAN (CELL_PROD 실값 — 81 Sales Plan
	     RTF/SalesAmt 는 셀생산지를 가진다, 사내 실측 5,648행 = CFM 동수) · 판가 = SCM_MST_FUTURE_PRICE (셀생산지 컬럼 없음).
	   배치는 RTF 금액 조인에서 CELL_PROD 를 빼므로(LOCAL_KRW L411~442), 판가 행을 T2 에 실재하는 셀생산지별로 복제해
	   아래 공통부(CELL_PROD 포함 조인)와 등가로 만든다. 81 PLANT 는 키 일치(40 블록 CASE '81' 의도와 동일).
	   40 분기·공통부 무수정. */
	ELSIF (SUBSTR(V_DIVISION_ID, 1, 2) = '81') THEN

		SELECT COUNT(*) INTO N_LOG_COUNT
		  FROM GT_PRDM_RESULTS;

		INSERT INTO GT_PRMF_RESULTS_KEY
		( V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
		, V_MIN_YYYYMMDD, V_MAX_YYYYMMDD )
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID
			 , D_MIN.BASIS_START_DATE
			 , D_MAX.BASIS_END_DATE
		  FROM ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
					  , MIN(V_YYYYMMDD) AS MIN_DATE
					  , MAX(V_YYYYMMDD) AS MAX_DATE
				   FROM GT_PRDM_RESULTS
				  GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID ) A
		  JOIN SCM_SYS_CALENDAR_M D_MIN ON D_MIN.BASIS_YYYYMMDD = A.MIN_DATE
		  JOIN SCM_SYS_CALENDAR_M D_MAX ON D_MAX.BASIS_YYYYMMDD = A.MAX_DATE;

		INSERT INTO GT_PRMF_T2_MKT_FCST
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
		, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, BASIS_START_DATE )
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, C.MEASURE, A.V_PLANT_SITE_ID, '-'
			 , C.YYYYMMDD, C.QTY, V_CREATED_BY, SYSDATE
			 , D.BASIS_START_DATE
		  FROM GT_PRMF_RESULTS_KEY A
		  JOIN DM_PLN_MKT_FCST C
			ON A.V_DIVISION_ID		= C.DIVISION_ID
		   AND A.V_PROJECT_CODE		= C.PROJECT_CODE
		   AND A.V_SCM_SITE_ID		= C.SCM_SITE_ID
		   AND A.V_ITEM_ID			= C.ITEM_ID
		   AND A.V_DOM_EXP			= C.DOM_EXP
		   AND A.V_FCST_TYPE		= C.FCST_TYPE
		   AND A.V_INCOTERMS		= C.INCOTERMS
		   AND A.V_PLANT_SITE_ID	= C.PLANT_SITE_ID
		  JOIN SCM_SYS_CALENDAR_M D
			ON D.BASIS_YYYYMMDD = C.YYYYMMDD
		 WHERE C.MEASURE IN ('MKT_FCST', 'SCM_FCST')
		   AND C.YYYYMMDD BETWEEN A.V_MIN_YYYYMMDD AND A.V_MAX_YYYYMMDD
		   AND C.QTY <> 0
		UNION ALL
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, C.MEASURE, A.V_PLANT_SITE_ID, NVL(NULLIF(RTRIM(C.CELL_PROD_SITE_ID),''), '/')
			 , C.YYYYMMDD, C.QTY, V_CREATED_BY, SYSDATE
			 , D.BASIS_START_DATE
		  FROM GT_PRMF_RESULTS_KEY A
		  JOIN DM_PLN_CFM_MKT_DEMAND_PLAN C
			ON A.V_DIVISION_ID		= C.DIVISION_ID
		   AND A.V_PROJECT_CODE		= C.PROJECT_CODE
		   AND A.V_SCM_SITE_ID		= C.SCM_SITE_ID
		   AND A.V_ITEM_ID			= C.ITEM_ID
		   AND A.V_DOM_EXP			= C.DOM_EXP
		   AND A.V_FCST_TYPE		= C.FCST_TYPE
		   AND A.V_INCOTERMS		= C.INCOTERMS
		   AND A.V_PLANT_SITE_ID	= C.PLANT_SITE_ID
		  JOIN SCM_SYS_CALENDAR_M D
			ON D.BASIS_YYYYMMDD = C.YYYYMMDD
		 WHERE C.MEASURE = 'RTF_SYS_RP'
		   AND C.YYYYMMDD BETWEEN A.V_MIN_YYYYMMDD AND A.V_MAX_YYYYMMDD
		   AND C.QTY <> 0;

		N_LOG_COUNT := SQL%ROWCOUNT;
		V_LOG_TYPE		:= 'ING';
		V_LOG_MESSAGE	:= 'step-01-02-INSERT #T2_MKT_FCST (81)';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

		INSERT INTO GT_PRMF_T2_PRICE
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID
		, CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE )
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID
			 , CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE
		  FROM ( SELECT A.V_DIVISION_ID AS DIVISION_ID, A.V_PROJECT_CODE AS PROJECT_CODE, A.V_SCM_SITE_ID AS SCM_SITE_ID, A.V_ITEM_ID AS ITEM_ID, A.V_DOM_EXP AS DOM_EXP, A.V_FCST_TYPE AS FCST_TYPE, A.V_INCOTERMS AS INCOTERMS, A.V_PLANT_SITE_ID AS PLANT_SITE_ID, CP.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
					  , C.CURRENCY, C.MEASURE, C.YYYYMMDD, C.PRICE, V_CREATED_BY AS CREATED_BY, SYSDATE AS CREATION_DATE
					  , ROW_NUMBER() OVER (
							PARTITION BY A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP
								   , A.V_FCST_TYPE, A.V_INCOTERMS, NVL(TRIM(A.V_PLANT_SITE_ID), '-'), NVL(TRIM(CP.CELL_PROD_SITE_ID), '-')
								   , C.MEASURE, C.YYYYMMDD
							ORDER BY C.PRICE DESC ) AS RN
				   FROM GT_PRMF_RESULTS_KEY A
				   JOIN SCM_MST_FUTURE_PRICE C
					 ON A.V_DIVISION_ID		= C.DIVISION_ID
					AND A.V_PROJECT_CODE	= C.PROJECT_CODE
					AND A.V_SCM_SITE_ID		= C.SCM_SITE_ID
					AND A.V_ITEM_ID			= C.ITEM_ID
					AND A.V_DOM_EXP			= C.DOM_EXP
					AND A.V_FCST_TYPE		= C.FCST_TYPE
					AND A.V_INCOTERMS		= C.INCOTERMS
					AND A.V_PLANT_SITE_ID	= C.PLANT_SITE_ID
				   JOIN ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID
							FROM GT_PRMF_T2_MKT_FCST ) CP	/* 셀생산지별 판가 복제 — 배치 RTF 금액 조인의 CELL_PROD 무시와 등가 */
					 ON CP.DIVISION_ID		= A.V_DIVISION_ID
					AND CP.PROJECT_CODE		= A.V_PROJECT_CODE
					AND CP.SCM_SITE_ID		= A.V_SCM_SITE_ID
					AND CP.ITEM_ID			= A.V_ITEM_ID
					AND CP.DOM_EXP			= A.V_DOM_EXP
					AND CP.FCST_TYPE		= A.V_FCST_TYPE
					AND CP.INCOTERMS		= A.V_INCOTERMS
					AND CP.PLANT_SITE_ID	= A.V_PLANT_SITE_ID
				  WHERE C.PRICE > 0
					AND C.MEASURE IN ('KRW', 'LOC', 'USD')
					AND C.YYYYMMDD BETWEEN A.V_MIN_YYYYMMDD AND A.V_MAX_YYYYMMDD )
		 WHERE RN = 1;

		N_LOG_COUNT := SQL%ROWCOUNT;
		V_LOG_MESSAGE	:= 'step-01-03-INSERT #T2_PRICE (81)';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
	END IF;

	/*------------------------------------------------------------------------------------------------------------------------------------------------- */

	/*------------------------------------------------------------------------------------------------------------------------------------------------- */
	BEGIN
		/* 확인용 */
		/*SELECT '#results' */
		/*SELECT * FROM #results */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* MULTI & SINGLE ROW (START) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A001--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		/*================================================================================================================================================= */
		/* DM_PLN_SALES_PLAN용 TEMP TABLE 생성 */
		/*   원본 : SELECT ... INTO #SALES_PLAN_TEMP FROM DM_PLN_SALES_PLAN WHERE DIVISION_ID='x' (0행, 구조 확보 목적) */
		/*          -> Oracle 은 GT_PRMF_SALES_PLAN_TEMP 를 사전 정의(구조 = DM_PLN_SALES_PLAN 서브셋)하므로 별도 구조확보 불필요. */
		/*================================================================================================================================================= */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/*================================================================================================================================================= */
		/* Temp 테이블에 저장  (START) */
		/*================================================================================================================================================= */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* MKT FCST 값을 UPDATE 함. */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		INSERT INTO GT_PRMF_SALES_PLAN_TEMP
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
		, YYYYMMDD, CURRENCY, QTY
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
		, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
			 , W.YYYYMMDD, SI.CURRENCY, W.QTY
			 , NVL(W.CREATED_BY, 'SYSTEM')
			 , W.CREATION_DATE	/*,w.LAST_UPDATED_BY --[2018-03-15][수정]--,w.LAST_UPDATE_DATE--[2018-03-15][수정] */
			 , V_CREATED_BY		/*[2018-03-15][수정][입력받은 매개변수로 처리] */
			 , SYSDATE			/*[2018-03-15][수정] */
			 , NULL, NULL, NULL, NULL, NULL
			 , NULL, NULL, NULL, NULL, NULL
		  FROM ( SELECT * FROM GT_PRMF_T2_MKT_FCST WHERE MEASURE IN ('MKT_FCST','CUST_FCST' ,'TMM_FCST', 'SCM_FCST', 'RTF_SYS_RP') ) W	/*[E20251021-000634]_ 'CUST_FCST' ,'TMM_FCST' 삭제, 'RTF_SYS_RP' 추가 */
		  /*LEFT OUTER JOIN #T2_PRICE SI WITH(NOLOCK) -- [E20250915-000105]_테이블 변경 GROUP BY한 데이터를 기준으로 가져옴 */
		  LEFT OUTER JOIN ( SELECT * FROM GT_PRMF_T2_PRICE WHERE MEASURE IN ('LOC') ) SI	/* #TEMP_DISTINCT_PRICE SI WITH(NOLOCK) --[E20251021-000634]_중복데이터가 제거되었으므로 #T2_PRICE 로 변경. LOC Measure 조건 추가 */
				 ON ( 1 = 1
				AND W.DIVISION_ID		= SI.DIVISION_ID
				AND W.PROJECT_CODE		= SI.PROJECT_CODE
				AND W.SCM_SITE_ID		= SI.SCM_SITE_ID
				AND W.ITEM_ID			= SI.ITEM_ID
				AND W.DOM_EXP			= SI.DOM_EXP
				AND W.FCST_TYPE			= SI.FCST_TYPE
				AND W.INCOTERMS			= SI.INCOTERMS
				AND W.PLANT_SITE_ID		= SI.PLANT_SITE_ID
				AND W.CELL_PROD_SITE_ID	= SI.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
				/*AND W.YYYYMMDD		= SI.YYYYMMDD */
				AND W.BASIS_START_DATE	= SI.YYYYMMDD	/*[E20251021-000634]_MIN, MAX 가 적용된 YYYYMMDD 조건 추가 */
				 );

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-01-LOG  (START) -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		V_LOG_TYPE		:= 'ING';
		V_LOG_MESSAGE	:= 'step-02- INSERT #SALES_PLAN_TEMP MKT_FCST, SCM_FCST, RTF_SYS_RP  저장';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		V_LOG_MESSAGE	:= NULL;
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-01-LOG (END)  -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* KRW 값을 계산 */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		INSERT INTO GT_PRMF_SALES_PLAN_TEMP
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
		, YYYYMMDD, CURRENCY, QTY
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
		, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'SalesAmt_KRW' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
			 , W.YYYYMMDD, FP.CURRENCY	/*,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric) */
			 , ROUND(W.QTY * NVL(FP.PRICE, 0), 5)	/* 원본 CAST(STR(W.QTY*ISNULL(FP.PRICE,0),20,5) AS NUMERIC(30,10)) : STR(x,20,5)=소수5자리 반올림 -> ROUND(x,5) */
			 /*,w.CREATED_BY --[2018-03-15][수정] --,w.CREATION_DATE --[2018-03-15][수정] --,w.LAST_UPDATED_BY --[2018-03-15][수정] --,w.LAST_UPDATE_DATE--[2018-03-15][수정] */
			 , V_CREATED_BY		/*[2018-03-15][수정] */
			 , SYSDATE			/*[2018-03-15][수정] */
			 , 'SYSTEM'			/*[2018-03-15][수정] */
			 , SYSDATE			/*[2018-03-15][수정] */
			 , NULL, NULL, NULL, NULL, NULL
			 , NULL, NULL, NULL, NULL, NULL
		  FROM ( SELECT * FROM GT_PRMF_T2_MKT_FCST WHERE MEASURE = 'RTF_SYS_RP' ) W
		  INNER JOIN ( SELECT * FROM GT_PRMF_T2_PRICE WHERE MEASURE = 'KRW' ) FP
				 ON (	FP.DIVISION_ID		= W.DIVISION_ID
				AND	FP.PROJECT_CODE			= W.PROJECT_CODE
				AND	FP.SCM_SITE_ID			= W.SCM_SITE_ID
				AND	FP.ITEM_ID				= W.ITEM_ID
				AND	FP.DOM_EXP				= W.DOM_EXP
				AND	FP.FCST_TYPE			= W.FCST_TYPE
				AND	FP.INCOTERMS			= W.INCOTERMS
				AND	FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
				AND	FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
				AND	FP.YYYYMMDD				= W.BASIS_START_DATE
				)
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		 WHERE ( SELECT COUNT(1)
				   FROM SCM_MST_SITE_ITEM A
					  , DM_PLN_SALES_PLAN B
				  WHERE A.SALES_PLAN_ADJUST_YN = 'N'
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF' )
					AND B.YYYYMMDD		>= V_THIS_WEEK_MON
					AND A.DIVISION_ID	= W.DIVISION_ID
					AND A.PROJECT_CODE	= W.PROJECT_CODE
					AND A.SCM_SITE_ID	= W.SCM_SITE_ID
					AND A.ITEM_ID		= W.ITEM_ID ) = 0;

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-01-LOG  (START) -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		V_LOG_TYPE		:= 'ING';
		V_LOG_MESSAGE	:= 'step-02-01 - Insert #SALES_PLAN_TEMP SalesAmt_KRW 저장';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		V_LOG_MESSAGE	:= NULL;
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-01-LOG (END)  -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* LOC 값을 계산 */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		INSERT INTO GT_PRMF_SALES_PLAN_TEMP
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
		, YYYYMMDD, CURRENCY, QTY
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
		, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'SalesAmt_LOC' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
			 , W.YYYYMMDD, FP.CURRENCY	/*,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric) */
			 , ROUND(W.QTY * NVL(FP.PRICE, 0), 5)	/* 원본 CAST(STR(...,20,5) AS NUMERIC(30,10)) -> ROUND(x,5) */
			 /*,w.CREATED_BY --[2018-03-15][수정] --,w.CREATION_DATE --[2018-03-15][수정] --,w.LAST_UPDATED_BY --[2018-03-15][수정]	--,w.LAST_UPDATE_DATE --[2018-03-15][수정] */
			 , V_CREATED_BY		/*[2018-03-15][수정] */
			 , SYSDATE			/*[2018-03-15][수정] */
			 , 'SYSTEM'			/*[2018-03-15][수정] */
			 , SYSDATE			/*[2018-03-15][수정] */
			 , NULL, NULL, NULL, NULL, NULL
			 , NULL, NULL, NULL, NULL, NULL
		  FROM ( SELECT * FROM GT_PRMF_T2_MKT_FCST WHERE MEASURE = 'RTF_SYS_RP' ) W
		  INNER JOIN ( SELECT * FROM GT_PRMF_T2_PRICE WHERE MEASURE = 'LOC' ) FP
				 ON ( FP.DIVISION_ID		= W.DIVISION_ID
				AND	FP.PROJECT_CODE			= W.PROJECT_CODE
				AND	FP.SCM_SITE_ID			= W.SCM_SITE_ID
				AND	FP.ITEM_ID				= W.ITEM_ID
				AND	FP.DOM_EXP				= W.DOM_EXP
				AND	FP.FCST_TYPE			= W.FCST_TYPE
				AND	FP.INCOTERMS			= W.INCOTERMS
				AND	FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
				AND	FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
				AND	FP.YYYYMMDD				= W.BASIS_START_DATE
				)
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		 WHERE ( SELECT COUNT(1)
				   FROM SCM_MST_SITE_ITEM A
					  , DM_PLN_SALES_PLAN B
				  WHERE A.SALES_PLAN_ADJUST_YN = 'N'
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF' )
					AND B.YYYYMMDD		>= V_THIS_WEEK_MON
					AND A.DIVISION_ID	= W.DIVISION_ID
					AND A.PROJECT_CODE	= W.PROJECT_CODE
					AND A.SCM_SITE_ID	= W.SCM_SITE_ID
					AND A.ITEM_ID		= W.ITEM_ID ) = 0;

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-02-LOG  (START) -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		V_LOG_TYPE		:= 'ING';
		V_LOG_MESSAGE	:= 'step-02-02 - Insert #SALES_PLAN_TEMP SalesAmt_LOC 저장';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		V_LOG_MESSAGE	:= NULL;
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-02-LOG (END)  -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A005--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		INSERT INTO GT_PRMF_SALES_PLAN_TEMP
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
		, YYYYMMDD, CURRENCY, QTY
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
		, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'SalesAmt_USD' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
			 , W.YYYYMMDD, FP.CURRENCY	/*,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric) */
			 , ROUND(W.QTY * NVL(FP.PRICE, 0), 5)	/* 원본 CAST(STR(...,20,5) AS NUMERIC(30,10)) -> ROUND(x,5) */
			 /*,w.CREATED_BY --[2018-03-15][수정] --,w.CREATION_DATE --[2018-03-15][수정] --,w.LAST_UPDATED_BY --[2018-03-15][수정]	--,w.LAST_UPDATE_DATE --[2018-03-15][수정] */
			 , V_CREATED_BY		/*[2018-03-15][수정] */
			 , SYSDATE			/*[2018-03-15][수정] */
			 , 'SYSTEM'			/*[2018-03-15][수정] */
			 , SYSDATE			/*[2018-03-15][수정] */
			 , NULL, NULL, NULL, NULL, NULL
			 , NULL, NULL, NULL, NULL, NULL
		  FROM ( SELECT * FROM GT_PRMF_T2_MKT_FCST WHERE MEASURE = 'RTF_SYS_RP' ) W
		  INNER JOIN ( SELECT * FROM GT_PRMF_T2_PRICE WHERE MEASURE = 'USD' ) FP
				 ON ( FP.DIVISION_ID		= W.DIVISION_ID
				AND	FP.PROJECT_CODE			= W.PROJECT_CODE
				AND	FP.SCM_SITE_ID			= W.SCM_SITE_ID
				AND	FP.ITEM_ID				= W.ITEM_ID
				AND	FP.DOM_EXP				= W.DOM_EXP
				AND	FP.FCST_TYPE			= W.FCST_TYPE
				AND	FP.INCOTERMS			= W.INCOTERMS
				AND	FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
				AND	FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
				AND	FP.YYYYMMDD				= W.BASIS_START_DATE
				)
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		 WHERE ( SELECT COUNT(1)
				   FROM SCM_MST_SITE_ITEM A
					  , DM_PLN_SALES_PLAN B
				  WHERE A.SALES_PLAN_ADJUST_YN = 'N'
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF' )
					AND B.YYYYMMDD		>= V_THIS_WEEK_MON
					AND A.DIVISION_ID	= W.DIVISION_ID
					AND A.PROJECT_CODE	= W.PROJECT_CODE
					AND A.SCM_SITE_ID	= W.SCM_SITE_ID
					AND A.ITEM_ID		= W.ITEM_ID ) = 0;

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-03-LOG  (START) -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		V_LOG_TYPE		:= 'ING';
		V_LOG_MESSAGE	:= 'step-02-03 - Insert #SALES_PLAN_TEMP SalesAmt_USD 저장';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		V_LOG_MESSAGE	:= NULL;
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-03-LOG (END)  -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A006--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		INSERT INTO GT_PRMF_SALES_PLAN_TEMP
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
		, YYYYMMDD, CURRENCY, QTY
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
		, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
			 , 'MKT_AMT_LOC' AS MEASURE
			 , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
			 , W.YYYYMMDD, FP.CURRENCY
			 , ROUND(W.QTY * NVL(FP.PRICE, 0), 5) AS QTY	/* 원본 CAST(STR(...,20,5) AS NUMERIC(30,10)) -> ROUND(x,5) */
			 , V_CREATED_BY, SYSDATE, 'SYSTEM', SYSDATE
			 , NULL, NULL, NULL, NULL, NULL
			 , NULL, NULL, NULL, NULL, NULL
		  FROM ( SELECT * FROM GT_PRMF_T2_MKT_FCST WHERE MEASURE = 'MKT_FCST' ) W
		  INNER JOIN ( SELECT * FROM GT_PRMF_T2_PRICE WHERE MEASURE = 'LOC' ) FP
				 ON ( FP.DIVISION_ID		= W.DIVISION_ID
				AND	FP.PROJECT_CODE			= W.PROJECT_CODE
				AND	FP.SCM_SITE_ID			= W.SCM_SITE_ID
				AND	FP.ITEM_ID				= W.ITEM_ID
				AND	FP.DOM_EXP				= W.DOM_EXP
				AND	FP.FCST_TYPE			= W.FCST_TYPE
				AND	FP.INCOTERMS			= W.INCOTERMS
				AND	FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
				AND	FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
				AND	FP.YYYYMMDD				= W.BASIS_START_DATE
				);

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-04-LOG  (START) -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		V_LOG_TYPE		:= 'ING';
		V_LOG_MESSAGE	:= 'step-02-04 - Insert #SALES_PLAN_TEMP MKT_AMT_LOC 저장';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		V_LOG_MESSAGE	:= NULL;
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-04-LOG (END)  -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A007--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		INSERT INTO GT_PRMF_SALES_PLAN_TEMP
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
		, YYYYMMDD, CURRENCY, QTY
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
		, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
			 , 'MKT_AMT_KRW' AS MEASURE
			 , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID
			 , W.YYYYMMDD, FP.CURRENCY
			 , ROUND(W.QTY * NVL(FP.PRICE, 0), 5) AS QTY	/* 원본 CAST(STR(...,20,5) AS NUMERIC(30,10)) -> ROUND(x,5) */
			 , V_CREATED_BY, SYSDATE, 'SYSTEM', SYSDATE
			 , NULL, NULL, NULL, NULL, NULL
			 , NULL, NULL, NULL, NULL, NULL
		  FROM ( SELECT * FROM GT_PRMF_T2_MKT_FCST WHERE MEASURE = 'MKT_FCST' ) W
		  INNER JOIN ( SELECT * FROM GT_PRMF_T2_PRICE WHERE MEASURE = 'KRW' ) FP
				 ON ( FP.DIVISION_ID		= W.DIVISION_ID
				AND	FP.PROJECT_CODE			= W.PROJECT_CODE
				AND	FP.SCM_SITE_ID			= W.SCM_SITE_ID
				AND	FP.ITEM_ID				= W.ITEM_ID
				AND	FP.DOM_EXP				= W.DOM_EXP
				AND	FP.FCST_TYPE			= W.FCST_TYPE
				AND	FP.INCOTERMS			= W.INCOTERMS
				AND	FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
				AND	FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID
				AND	FP.YYYYMMDD				= W.BASIS_START_DATE
				);

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-05-LOG  (START) -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		V_LOG_TYPE		:= 'ING';
		V_LOG_MESSAGE	:= 'step-02-05 - Insert #SALES_PLAN_TEMP MKT_AMT_KRW 저장';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		V_LOG_MESSAGE	:= NULL;
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-05-LOG (END)  -- [E20250915-000105]_로그추가 */
		/*================================================================================================================================================= */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A008--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* [E20250915-000105]_나눠서 저장하도록 수정 (END) */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		SELECT COUNT(1) INTO V_INT_COUNT FROM GT_PRMF_SALES_PLAN_TEMP;
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-06-LOG  (START) */
		/*================================================================================================================================================= */
		V_LOG_TYPE		:= 'ING';
		V_LOG_MESSAGE	:= 'step-02-06 - INSERT #SALES_PLAN_TEMP END';
		N_LOG_COUNT		:= V_INT_COUNT;
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		V_LOG_MESSAGE	:= NULL;
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-02-06-LOG (END) */
		/*================================================================================================================================================= */
		/*================================================================================================================================================= */
		/* 테이블의 중복제거 (START) */
		/*================================================================================================================================================= */
		BEGIN
			/*------------------------------------------------------------------------------------------------------------------------------------------------- */
			/*[E20251021-000634]_#SALES_PLAN_TEMP_KEY 테이블, 데이터 생성 (START) */
			/*------------------------------------------------------------------------------------------------------------------------------------------------- */
			INSERT INTO GT_PRMF_SALES_PLAN_TEMP_KEY
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
			, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
			, V_MIN_YYYYMMDD, V_MAX_YYYYMMDD )
			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
				 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
				 , MIN(YYYYMMDD) AS V_MIN_YYYYMMDD
				 , MAX(YYYYMMDD) AS V_MAX_YYYYMMDD	/* YYYYMMDD 를 제외한 Key 값 기준의 MIN, MAX YYYYMMDD 테이블 생성 */
			  FROM GT_PRMF_SALES_PLAN_TEMP
			 GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
					, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID;

			DELETE FROM DM_PLN_SALES_PLAN A
			 WHERE EXISTS ( SELECT 1
							  FROM GT_PRMF_SALES_PLAN_TEMP_KEY C	/* #SALES_PLAN_TEMP B WITH(NOLOCK) -- [E20251021-000634]_YYYYMMDD 는 MIN, MAX YYYYMMDD 적용 */
							 WHERE A.DIVISION_ID		= C.DIVISION_ID
							   AND A.PROJECT_CODE		= C.PROJECT_CODE
							   AND A.SCM_SITE_ID		= C.SCM_SITE_ID
							   AND A.ITEM_ID			= C.ITEM_ID
							   AND A.DOM_EXP			= C.DOM_EXP
							   AND A.FCST_TYPE			= C.FCST_TYPE
							   AND A.INCOTERMS			= C.INCOTERMS
							   AND A.MEASURE			= C.MEASURE
							   AND A.PLANT_SITE_ID		= C.PLANT_SITE_ID
							   AND A.CELL_PROD_SITE_ID	= C.CELL_PROD_SITE_ID
							   AND A.YYYYMMDD BETWEEN C.V_MIN_YYYYMMDD AND C.V_MAX_YYYYMMDD );	/* [E20251021-000634]_누락되는 YYYYMMDD가 존재할 수 있으므로 MIN, MAX YYYYMMDD 기간의 데이터를 모두 삭제 */
			/*------------------------------------------------------------------------------------------------------------------------------------------------- */
			/*[E20251021-000634]_#SALES_PLAN_TEMP_KEY 테이블, 데이터 생성 (END) */
			/*------------------------------------------------------------------------------------------------------------------------------------------------- */
			N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */

			/*================================================================================================================================================= */
			/* 저장진행중 STEP-03-LOG  (START) */
			/*================================================================================================================================================= */
			V_LOG_TYPE		:= 'ING';
			V_LOG_MESSAGE	:= 'step-03- DELETE DM_PLN_SALES_PLAN';
			V_DESCRIPTION	:= '';
			D_EVENT_DATE	:= SYSDATE;
			PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
			V_LOG_MESSAGE	:= NULL;
			/*================================================================================================================================================= */
			/* 저장진행중 STEP-03-LOG (END) */
			/*================================================================================================================================================= */
		END;
		/*================================================================================================================================================= */
		/* 테이블의 중복제거 (END) */
		/*================================================================================================================================================= */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		/*================================================================================================================================================= */
		/* TEMP TABLE -> SALES PLAN TABLE에 데이터 적재  (START) */
		/*================================================================================================================================================= */
		INSERT INTO DM_PLN_SALES_PLAN
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
		, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
		, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	/* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
			 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
			 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		  FROM ( SELECT T.*
					  , ROW_NUMBER() OVER (
							PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
								   , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
							ORDER BY CREATION_DATE DESC NULLS LAST ) AS RN
				   FROM GT_PRMF_SALES_PLAN_TEMP T )
		 WHERE RN = 1;

		N_LOG_COUNT := SQL%ROWCOUNT;	/* [E20250915-000105]_ROW_COUNT 확인 */
		/*================================================================================================================================================= */
		/* TEMP TABLE -> SALES PLAN TABLE에 데이터 적재  (END) */
		/*================================================================================================================================================= */
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-04-LOG  (START) */
		/*================================================================================================================================================= */
		V_LOG_TYPE		:= 'ING';
		V_LOG_MESSAGE	:= 'step-04- Insert dm_pln_sales_plan ';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
		V_LOG_MESSAGE	:= NULL;
		/*================================================================================================================================================= */
		/* 저장진행중 STEP-04-LOG  (END) */
		/*================================================================================================================================================= */
		DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */
		/* MULTI & SINGLE ROW END */
		/*------------------------------------------------------------------------------------------------------------------------------------------------- */

	/*------------------------------------------------------------------------------------------------------------------------------------------------- */
	/* 트랜잭션 (END) / 예외 처리 */

	/*   원본은 명시 COMMIT 없음(호출자 DMF0003_SAVE_MKT_FCST 트랜잭션에 합류) -> 본 프로시저 성공 COMMIT 없음. 오류 시 ROLLBACK(원본 XACT_ABORT ON 등가). */
	/*------------------------------------------------------------------------------------------------------------------------------------------------- */
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			V_LOG_TYPE		:= 'ERROR';
			V_LOG_MESSAGE	:= 'EXCEPTION';
			V_DESCRIPTION	:= '';
			D_EVENT_DATE	:= SYSDATE;
			V_SQL_CODE		:= TO_CHAR(SQLCODE);
			V_SQL_ERRMSG	:= SQLERRM;
			V_PROC_INPUT	:= 'NO_PARAM';
			V_BACKTRACE		:= DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			DBMS_OUTPUT.PUT_LINE('[' || V_SQL_CODE || ']' || V_SQL_ERRMSG);	/*-- 에러메시지 DISPLAY --*/
			PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
							   , V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
			RAISE_APPLICATION_ERROR(-20001
  , '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
				' / SQLERRM=' || V_SQL_ERRMSG ||
				' / BACKTRACE=' || V_BACKTRACE);
	END;

	/*================================================================================================================================================= */
	/* 종료 LOG  (START) */
	/*   원본 : IF @v_log_message IS NULL (정상 종료 시에만 END 로그). 오류 시엔 위 RAISE 로 이미 프로시저를 벗어남. */
	/*================================================================================================================================================= */
	IF V_LOG_MESSAGE IS NULL THEN
		V_LOG_TYPE		:= 'END';
		V_LOG_MESSAGE	:= '########## END of procedure ##########';
		V_DESCRIPTION	:= '';
		D_EVENT_DATE	:= SYSDATE;
		PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
	END IF;
	/*================================================================================================================================================= */
	/* 종료 LOG  (END) */
	/*================================================================================================================================================= */


END;