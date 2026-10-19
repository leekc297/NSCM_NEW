




/*  
 * Program ID   : PR_SCP_RPT_GLOBAL_PSI_MD_WW 
 * Description  : 자동차 Weekly(partial) Global PSI 집계 프로시저 
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2023.10.13	hrkim		Initial Release PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  
 * 2023.12.12	hrkim		FP Aging Stock Form. Progress 데이터 저장 활용
 * 2023.12.14	hrkim		P5200 AMDAU% 모델 생산 실적 제외
 * 2023.12.18	hrkim		P5200 AMDAU% 모델 Cell로 환산 적재 (operation_group = 'A'로 적용, Cell로 간주함)
 * 2024.01.16	hrkim		AS measure 분리 적용 및 RTF measure 코드 변경 (ALLOCATION -> RTF)
 * 2024.01.17	hrkim		Cell/Pack 재고 로직 변경 (Pack plant Cell재고 제외)
 *							-- 보류 재고 가용일과 상관 없이 BOH에 모두 포함
 *							-- Cell Product(CP) 재고 -> Cell Assy(CA) 재고에 변환 합산
 * 2024.03.11	hrkim		attribute10 -> cell_group여부 정보 추가 
 *								- Y : cell_group 컬럼의 값이 cell_group
 *								- N : cell_group 컬럼의 값이 cell_group이 아닌 rep_cell_item_id (Model Code Master정보에 Cell Group정보가 없는 경우) 
 * 2024.03.27	hrkim		E20240329-001832 GLOBAL PSI NEW 수식 수정 : 셀공장 Cell Inventory 마이너스 P(팩공장 Cell inventory) 반영 로직 변경 
 * 2024.06.09   vadabi3     NERP - 특정 Company 별도 처리 개선
 * 2024.09.30   cys     	고도화 (개선 및 재고 통제 프로세스 적용)	- Global PSI New 개선_재고통제프로세스관련.xlsx 개발 목록 참조(PI 김도형 선임) 
 * 2025.05.28   kimcd       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                          E20250522-001206 GLOBAL PSI NEW - AS FCST/RTF 누락
 ----------------------------------------------------------------------------------------------------
 */  


CREATE PROCEDURE [dbo].[PR_SCP_RPT_GLOBAL_PSI_MD_WW_0730_ORG_dev]
	 @P_DIVISION_ID		        NVARCHAR(30)	= '81'
	,@P_PLAN_START_YYYYMMDD		NVARCHAR(8)		= NULL
AS


BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	-- SCP 계힉 참조를 위한 변수
	DECLARE @V_DIVISION_ID				NVARCHAR(30)	= ISNULL(@P_DIVISION_ID, '81')
	DECLARE @V_PLAN_START_YYYYMMDD		NVARCHAR(8)		= NULL;
	DECLARE @V_PLAN_START_DATE			DATE			= NULL;
	DECLARE @V_PLAN_START_YYYYPW		NVARCHAR(8)		= NULL;
	DECLARE @V_PLAN_TYPE				NVARCHAR(100)	= 'FN';
	DECLARE @V_PLAN_SEQ					BIGINT			= 1
	DECLARE @V_HORIZON_END_YYYYMMDD		NVARCHAR(8)		= NULL
	DECLARE @V_MASTER_ID				NVARCHAR(100)	= NULL
	DECLARE @V_ENG_PLAN_ID				NVARCHAR(100)	= NULL
	DECLARE @V_HORIZON_END_YYYYPW		NVARCHAR(8)		= NULL
	
	-- DM 참조를 위한 변수
	DECLARE @V_DM_CUTOFF_YYYYMMDD		NVARCHAR(8)		= NULL
	DECLARE @V_DM_VERSION_NO		    NVARCHAR(50) = '';

	-- 실적 구간 참조를 위한 변수
	DECLARE @V_RESULT_FROM_YYYYMMDD		NVARCHAR(8) = NULL;		-- 과거 실적구간 참조 시작일 (plan date - 전년도 첫주 시작일) 
	DECLARE @V_RESULT_FROM_DATE			DATE		= NULL;		-- 과거 실적구간 참조 시작일 (plan date - 전년도 첫주 시작일) 
	DECLARE @V_RESULT_LAST_YYYYMM		NVARCHAR(6) = NULL;		-- 계획 시작일 기준 전월
	DECLARE @V_RESULT_LAST_YYYYPW		NVARCHAR(8) = NULL;		-- 계획 시작일 기준 전주
	 
	-- Ending Inventory 참조를 위한 변수
	DECLARE @V_INV_FROM_YYYYMM		NVARCHAR(6) = NULL;		-- 실적 참조 시작일 기준 전월
	DECLARE @V_INV_TO_YYYYMM		NVARCHAR(6) = NULL;		-- plan date 기준 전월

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_RPT_GLOBAL_PSI_MD_WW'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 
	
	-- NERP 매핑코드	--NERP 적용여부에 따라 변경
    DECLARE @v_COMPANY_SALES NVARCHAR(8);
    DECLARE @v_ESOC NVARCHAR(8);
	DECLARE @v_PLANT_G8 NVARCHAR(8) = 'G82'; --1차 Conv 대상 아님
	SELECT @v_COMPANY_SALES = DBO.FN_GET_LOOKUP_VALUE('PR_SCP_RPT_GLOBAL_PSI_MD_MM','COMPANY_SALES')
	SELECT @v_ESOC = DBO.FN_GET_LOOKUP_VALUE('PR_SCP_RPT_GLOBAL_PSI_MD_MM','ESOC')

	BEGIN TRY
	  BEGIN

		---------------------------------------------------------------------------------------------------
		-- SCP PLAN 버전 정보 (PRODUCTION) 
		---------------------------------------------------------------------------------------------------
		SELECT TOP 1
			  @V_PLAN_SEQ				= D.PLAN_SEQ
			 ,@V_PLAN_START_YYYYMMDD	= P.PLAN_NAME
			 ,@V_PLAN_START_YYYYPW		= B.YYYYPW
			 ,@V_PLAN_START_DATE		= CONVERT(DATE, P.PLAN_NAME, 112) 
			 ,@V_HORIZON_END_YYYYMMDD	= SUBSTRING(P.HORIZON_END_DATE, 1, 8) 
			 ,@V_MASTER_ID				= P.DIVISION_ID + '::' + P.PLAN_CYCLE 
			 ,@V_ENG_PLAN_ID			= P.PLAN_ID + '::' + D.PLAN_TYPE + '::' + CONVERT(NVARCHAR(3), D.PLAN_SEQ)
		 FROM SCM_MST_PLAN  P WITH(NOLOCK)
			  INNER JOIN SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
					  ON D.DIVISION_ID  = P.DIVISION_ID
					 AND D.PLAN_ID      = P.PLAN_ID
					 AND D.PLAN_TYPE    = @V_PLAN_TYPE -- FN
					 AND D.PLAN_STATUS  = '1'  -- 정상 완료
					 AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm
			  INNER JOIN SCM_MST_BUCKET B WITH(NOLOCK)
					  ON B.YYYYMMDD		= P.PLAN_NAME
		WHERE 1=1
		  AND P.DIVISION_ID  = @V_DIVISION_ID			
		  AND P.PLAN_NAME    = CASE WHEN ISNULL(@P_PLAN_START_YYYYMMDD,'') = ''
									THEN P.PLAN_NAME
									ELSE @P_PLAN_START_YYYYMMDD
								END 
		  AND P.PLAN_CYCLE   = 'WEEKLY'
		ORDER BY P.PLAN_NAME DESC
			   , D.PLAN_SEQ 
		;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '['+ @v_division_id + '::' + @v_PLAN_START_YYYYMMDD + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		-- 실적 구간 참조를 위한 변수값
		SET @V_RESULT_FROM_YYYYMMDD		= CONVERT(NVARCHAR(4), DATEADD(YEAR, -1, @V_PLAN_START_DATE), 112) + '0101'  -- 과거 실적구간 참조 시작일 (전년도 1/1일)																			-- 과거 실적구간 참조 시작일 (plan date - 52주, 해당월 1일) 
		SET @V_RESULT_FROM_DATE			= CONVERT(DATE, @V_RESULT_FROM_YYYYMMDD, 112)								 -- 과거 실적구간 참조 시작일 (전년도 1/1일)
		SET @V_RESULT_LAST_YYYYMM		= CONVERT(NVARCHAR(6), DATEADD(MONTH, -1, CONVERT(DATE, @V_PLAN_START_YYYYMMDD, 112)), 112)					-- 계획 시작일 기준 전월 

		-- Ending Inventory 참조를 위한 변수
		SET @V_INV_FROM_YYYYMM	= CONVERT(NVARCHAR(6),DATEADD(MONTH, -1, @V_RESULT_FROM_DATE),112)	-- 실적 참조 시작일 기준 전월 
		SET @V_INV_TO_YYYYMM	= CONVERT(NVARCHAR(6),DATEADD(MONTH, -1, @V_PLAN_START_DATE),112)	-- plan date 기준 전월
	
		---------------------------------
		-- DM Cutoff YYYYMMDD 
		---------------------------------
		SET @V_DM_CUTOFF_YYYYMMDD = CONVERT(CHAR(8), dbo.FN_NEXT_DAY( CONVERT(DATE, @V_PLAN_START_YYYYMMDD, 112), 'TUE'), 112)

		---------------------------------------------------------------------------------------------------
		-- 참조대상 DM 버전 정보 (FCST 및 RTF 실적)
		---------------------------------------------------------------------------------------------------
		SELECT TOP 1 
			  @V_DM_VERSION_NO = VERSION_NO 
		 FROM DM_MST_VERSION  DV with(nolock)
		WHERE 1=1
		  AND DV.DIVISION_ID	= @V_DIVISION_ID
		  AND DV.VERSION_TYPE	= 'MF_W'  
		  AND DV.YYYYMMDD		= @V_DM_CUTOFF_YYYYMMDD
		ORDER BY VERSION_NO desc 
		;

		PRINT '------------------------------------------------';
		--PRINT '@P_DIVISION_ID			= ' + '81';
		PRINT '@V_DIVISION_ID			= ' + @V_DIVISION_ID;
		--PRINT '@P_PLAN_START_YYYYMMDD	= ' + ISNULL('20240624','');
		PRINT '@V_PLAN_START_DATE		= ' + CONVERT(NVARCHAR(8), @V_PLAN_START_DATE, 112);
		PRINT '@V_PLAN_START_YYYYMMDD	= ' + @V_PLAN_START_YYYYMMDD;
		PRINT '@V_PLAN_START_YYYYPW		= ' + @V_PLAN_START_YYYYPW;
		PRINT '@V_HORIZON_END_YYYYMMDD	= ' + @V_HORIZON_END_YYYYMMDD;
		PRINT '@V_PLAN_SEQ				= ' + CONVERT(NVARCHAR(10), @V_PLAN_SEQ);
		PRINT '@V_MASTER_ID			    = ' + @V_MASTER_ID;
		PRINT '@V_ENG_PLAN_ID			= ' + @V_ENG_PLAN_ID;
		-- for DM
		PRINT '@V_DM_CUTOFF_YYYYMMDD	= ' + @V_DM_CUTOFF_YYYYMMDD;
		PRINT '@V_DM_VERSION_NO			= ' + @V_DM_VERSION_NO;
		-- for Result 
		PRINT '@V_RESULT_FROM_YYYYMMDD	= ' + @V_RESULT_FROM_YYYYMMDD;
		PRINT '@V_RESULT_FROM_DATE		= ' + CONVERT(NVARCHAR(8), @V_RESULT_FROM_DATE, 112);
		-- Ending Inventory 참조를 위한 변수
		PRINT '@V_INV_FROM_YYYYMM		= ' + @V_INV_FROM_YYYYMM;
		PRINT '@V_INV_TO_YYYYMM			= ' + @V_INV_TO_YYYYMM;
		PRINT '------------------------------------------------';

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 기간 정보 : 데이터생성 범위 날짜 목록' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#TMP_DATE_INFO') IS NOT NULL
			DROP TABLE #TMP_DATE_INFO

		SELECT BC.YYYYMMDD
			  ,BC.YYYYWW
			  ,MIN(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYWW) AS WK_FROM_YMD
			  ,MAX(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYWW) AS WK_TO_YMD
			  ,COUNT(BC.YYYYMMDD)	OVER (PARTITION BY BC.YYYYWW) AS WK_DAYS
			  ,BC.YYYYPW
			  ,MIN(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYPW) AS PW_FROM_YMD
			  ,MAX(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYPW) AS PW_TO_YMD
			  ,COUNT(BC.YYYYMMDD)	OVER (PARTITION BY BC.YYYYPW) AS PW_DAYS
			  ,BC.YYYYMM																		-- partial week의 해당월
			  ,BC.YYYYMM+'01'																	AS YYYYMM_FIRST_YMD	-- 해당월 01일
			  ,MAX(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYMM)								AS YYYYMM_LAST_YMD	-- 해당월 말일 
			  ,CONVERT(NVARCHAR(6), DATEADD(MONTH, -1, CONVERT(DATE, BC.YYYYMMDD, 112)),112)	AS YYYYMM_PRVS		-- 전월 
		 INTO #TMP_DATE_INFO
		 FROM SCM_MST_BUCKET BC WITH(NOLOCK)
		WHERE 1=1
		  AND BC.YYYYMMDD BETWEEN @V_RESULT_FROM_YYYYMMDD -- 실적 참조 시작일 
						      AND @V_HORIZON_END_YYYYMMDD -- 계획 참조 종료일
		
		SELECT	@V_RESULT_LAST_YYYYPW = A.YYYYPW	--계획 주차 전주
		FROM 	#TMP_DATE_INFO A
				INNER JOIN (
								SELECT CONVERT(NVARCHAR, DATEADD(DAY, -1, CONVERT(DATE, @V_PLAN_START_YYYYMMDD, 112)) ,112) AS PREV_PLAN_DATE
							) B
						ON 1=1
					   AND A.PW_FROM_YMD <= B.PREV_PLAN_DATE 
					   AND A.PW_TO_YMD 	 >= B.PREV_PLAN_DATE
		WHERE 1=1
		
		print '@V_RESULT_LAST_YYYYPW		= ' + @V_RESULT_LAST_YYYYPW
		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 기간 정보 : 주별(partial) 일수 정보' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#TMP_PW_LIST') IS NOT NULL
			DROP TABLE #TMP_PW_LIST

		;WITH PW_LIST AS (
			SELECT DISTINCT 
				   DI.YYYYPW
				  ,DI.PW_FROM_YMD
				  ,DI.PW_TO_YMD
				  ,DATEADD(DAY, 1, CONVERT(DATE, DI.PW_TO_YMD, 112)) AS PW_TO_YMD_NEXT_DAY	-- FP Aging Stock cutoff date (월말일 기준 재고 참조를 하기 위함)
				  ,DI.PW_DAYS
				  -- for weekly 재고 
				  ,DI.YYYYMM
				  ,DI.YYYYMM_PRVS
				  ,DI.YYYYMM_FIRST_YMD
				  ,DI.YYYYMM_LAST_YMD
			 FROM #TMP_DATE_INFO DI WITH(NOLOCK)
		)
		SELECT PL.*
			  ,ROW_NUMBER() OVER (ORDER BY YYYYPW) AS YYYYPW_SEQ 
		 INTO #TMP_PW_LIST
		 FROM PW_LIST PL

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### Cell Produc/Cell Assy 매핑 정보 추출' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_PROD_ASSY_MAP') IS NOT NULL
			DROP TABLE #CELL_PROD_ASSY_MAP;

		SELECT M.PLANT_ID
			  ,M.ITEM_ID_PROD
			  ,M.ITEM_ID_ASSY
			  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
											  ,M.ITEM_ID_PROD
											  ,M.PLANT_ID
									  ORDER BY M.VALID_YN DESC 
											  ,M.ITEM_ID_ASSY) ASSY_PRIORITY_1ST	-- cp 기준 assy 참조 
			  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
											  ,M.ITEM_ID_PROD
									  ORDER BY M.VALID_YN DESC 
											  ,M.ITEM_ID_ASSY) ASSY_PRIORITY_2ND	-- cp 기준 assy 참조
			  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
											  ,M.ITEM_ID_ASSY
											  ,M.PLANT_ID
									  ORDER BY M.VALID_YN DESC 
											  ,M.ITEM_ID_PROD) CP_PRIORITY_1ST		-- assy 기준 cp 참조
			  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
											  ,M.ITEM_ID_ASSY
									  ORDER BY M.VALID_YN DESC 
											  ,M.ITEM_ID_PROD) CP_PRIORITY_2ND		-- assy 기준 cp 참조 
		 INTO #CELL_PROD_ASSY_MAP
		 FROM SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
		WHERE 1=1
		  AND M.DIVISION_ID =  @V_DIVISION_ID
		  AND M.VALID_YN	= 'Y'

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121)  + N' ### 해당 사업부 #SCM_MST_SITE 추출 '  
		-----------------------------------------------------------------------------------------------------------------			 
		IF OBJECT_ID('TEMPDB..#SCM_MST_SITE') IS NOT NULL
			DROP TABLE #SCM_MST_SITE;

		SELECT SCM_SITE_ID
			  ,PLANT_ID
			  ,OPERATION_GROUP
			  ,SITE_TYPE
			  ,OSP_YN
			  ,VALID_YN
		  INTO #SCM_MST_SITE
		  FROM SCM_MST_SITE WITH(NOLOCK) 
		 WHERE 1=1
		   AND DIVISION_ID	= @V_DIVISION_ID 
		UNION ALL
		SELECT 'ESST_CA_WND' SCM_SITE_ID
				, NULL AS PLANT_ID
				, 'P' AS OPERATION_GROUP
				, 'PLANT' AS SITE_TYPE
				, 'N' AS OSP_YN
				, 'Y' AS VALID_YN
		WHERE 1= (CASE WHEN @V_DIVISION_ID = '81_ST' THEN 1 ELSE 0 END)
		;

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121)  + N' ### 해당 사업부 #SCP_MST_FINAL_ITEM 추출 '  
		-----------------------------------------------------------------------------------------------------------------			 
		IF OBJECT_ID('TEMPDB..#SCP_MST_FINAL_ITEM') IS NOT NULL
			DROP TABLE #SCP_MST_FINAL_ITEM;

		SELECT ITEM_ID
			  ,NICK_NAME
			  ,OPERATION_GROUP
			  ,ISNULL(GROUP_CODE1, 'ETC') AS GROUP_CODE1				-- cell group	---@@@
			  ,ISNULL(GROUP_CODE6,'-') AS GROUP_CODE6				-- Product Level1 ---@@@
			  ,ISNULL(GROUP_CODE7,'-') AS GROUP_CODE7				--- Product Level2 ---@@@
			  ,FINISHED_PRODUCT
			  ,ATTRIBUTE8				AS CELL_TYPE -- CP/CA Cell_type 
			  ,FLOW_ID
			  ,ATTRIBUTE1				AS CELL_MODEL_ID 
		  INTO #SCP_MST_FINAL_ITEM
		  FROM SCP_MST_FINAL_ITEM WITH(NOLOCK) 
		 WHERE 1=1
		   AND DIVISION_ID		= @V_DIVISION_ID 
		   AND OPERATION_GROUP IN ('A', 'P') -- Cell/Pack 만
		;

		
		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121)  + N' ### Formation 수율 및 LT 정보'  
		-----------------------------------------------------------------------------------------------------------------			 
		IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION') IS NOT NULL
			DROP TABLE #SCP_MST_FORMATION;
/*
		SELECT    FR.PLANT_SITE_ID
				, FR.ITEM_ID
				, FR.LT_FORMATION
				, FR.ATTRIBUTE1
				, CEILING(ISNULL(FR.LT_FORMATION + CONVERT(INT, ISNULL(FR.ATTRIBUTE1, '0')),0) /7.0) * 7 	AS LT_DAY	-- LT_week으로 환산후 다시 일수로 변환 적용  (시뮬레이터와 동일 일수(주) 반영) 
				, CEILING(ISNULL(FR.LT_FORMATION + CONVERT(INT, ISNULL(FR.ATTRIBUTE1, '0')),0) /7.0)		AS LT_WEEK
				, ISNULL(FR.FORMATION_TOTAL_YIELD, 0)	AS FORMATION_TOTAL_YIELD
				, ISNULL(FR.SSP_MODIFY_YIELD, 0)		AS SSP_MODIFY_YIELD
				, ISNULL(FR.CHAR_YIELD, 0)				AS CHAR_YIELD
		  INTO #SCP_MST_FORMATION
		  FROM SCP_MST_FORMATION FR WITH(NOLOCK) 
		 WHERE 1=1
		   AND DIVISION_ID	= @V_DIVISION_ID
		;
*/
		SELECT    A.PLANT_SITE_ID
				, A.ITEM_ID
				, A.YYYYMM
				, A.YYYYPW
				, FR.LT_FORMATION
				, FR.ATTRIBUTE1
				, CEILING(ISNULL(FR.LT_FORMATION + CONVERT(INT, ISNULL(FR.ATTRIBUTE1, '0')),0) /7.0) * 7 	AS LT_DAY	-- LT_WEEK으로 환산후 다시 일수로 변환 적용 
				, CEILING(ISNULL(FR.LT_FORMATION + CONVERT(INT, ISNULL(FR.ATTRIBUTE1, '0')),0) /7.0)		AS LT_WEEK
				, ISNULL(A.YIELD, 0)	AS FORMATION_TOTAL_YIELD	--ISNULL(FR.FORMATION_TOTAL_YIELD, 0)	AS FORMATION_TOTAL_YIELD
				, ISNULL(A.YIELD, 0)	AS SSP_MODIFY_YIELD			--ISNULL(FR.SSP_MODIFY_YIELD, 0)		AS SSP_MODIFY_YIELD
				, ISNULL(A.YIELD, 0)	AS CHAR_YIELD				--ISNULL(FR.CHAR_YIELD, 0)				AS CHAR_YIELD
		INTO #SCP_MST_FORMATION
		FROM (
				SELECT PLANT_ID+'-A' AS PLANT_SITE_ID, A.ITEM_ID, WL.YYYYMM, WL.YYYYPW,AVG(ISNULL(A.YIELD,1)) AS YIELD
				FROM   SCM_MST_YIELD_SN A WITH(NOLOCK)
						INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
								ON WL.YYYYPW >=   @V_PLAN_START_YYYYPW  -- 미래 계획 구간
								and wl.yyyymm = a.month
				WHERE 1=1
				AND		A.DIVISION_ID 	= @V_DIVISION_ID
				--AND		A.MONTH 		>= @V_PLAN_START_YYYYMM  -- 미래 계획 구간
				--AND     A.OPERATION_ID 	IN ( 'F6000' , 'P9500', 'P5200', 'P5500')
				AND     A.OPERATION_ID 	IN ( 'P9500', 'P5200', 'P5500')
				GROUP BY A.PLANT_ID, A.ITEM_ID, WL.YYYYMM, WL.YYYYPW
				UNION ALL
				SELECT A.PLANT_SITE_ID, A.ITEM_ID, WL.YYYYMM, WL.YYYYPW, MAX(ISNULL(A.SSP_MODIFY_YIELD,A.FORMATION_TOTAL_YIELD)) AS YIELD
				FROM   SCP_MST_FORMATION A WITH(NOLOCK)
						INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
								ON WL.YYYYPW >=   @V_PLAN_START_YYYYPW  -- 미래 계획 구간
				WHERE 1=1
				AND		A.DIVISION_ID 	= @V_DIVISION_ID
				GROUP BY A.PLANT_SITE_ID, A.ITEM_ID, WL.YYYYMM, WL.YYYYPW
			) A
			LEFT OUTER JOIN SCP_MST_FORMATION FR WITH(NOLOCK)
			ON 1=1
			AND A.PLANT_SITE_ID = FR.PLANT_SITE_ID
			AND A.ITEM_ID = FR.ITEM_ID
		;
	
		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : #SCP_PLN_TH_ENG_STOCK_PLAN '
		----------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_PLN_TH_ENG_STOCK_PLAN') IS NOT NULL
			DROP TABLE #SCP_PLN_TH_ENG_STOCK_PLAN;

		SELECT ES.ITEM_ID
			  ,ES.SITE_ID
			  --,ES.ROUTE_ID
			  --,ES.OPERATION_ID
			  ,ES.RECEIVING_DTTM
			  ,CONVERT(NVARCHAR(8), ES.RECEIVING_DTTM,112)  AS YYYYMMDD
			  ,ES.QTY
			  ,ES.LOT_ID
			  ,ES.DESCR
			  ,ES.INSP_TYPE
		 INTO #SCP_PLN_TH_ENG_STOCK_PLAN
		 FROM SCP_PLN_TH_ENG_STOCK_PLAN  ES WITH(NOLOCK)         
		WHERE 1=1
		  AND ES.MASTER_ID	= @V_MASTER_ID	
		  AND ES.PLAN_ID	= @V_ENG_PLAN_ID

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121)  + N' ### 해당 사업부 팩(모듈) 모델 셀 환산수량 정보 추출 '  
		-----------------------------------------------------------------------------------------------------------------			 
		IF OBJECT_ID('TEMPDB..#SCP_MST_ITEM_CELL_CF') IS NOT NULL
			DROP TABLE #SCP_MST_ITEM_CELL_CF;
	
		SELECT CF.ITEM_ID
			  ,CF.TARGET_CELL
			  ,CF.CELL_CF
		 INTO #SCP_MST_ITEM_CELL_CF
		 FROM SCP_MST_ITEM_CELL_CF CF WITH(NOLOCK) 
		WHERE 1=1
		  AND EXISTS (SELECT TOP 1 *
						FROM SCM_MST_ITEM_SN  II WITH(NOLOCK)
					   WHERE 1=1
					     AND II.ITEM_ID				= CF.ITEM_ID
						 AND II.DIVISION_ID			= @V_DIVISION_ID
						 AND II.SCP_OPERATION_GROUP = 'P'
						 )

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121)  + N' ### 대표Cell 품목 매핑 : CP Cell 정보 for Pack'  
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CP_CELL_ITEM_INFO') IS NOT NULL
			DROP TABLE #CP_CELL_ITEM_INFO;

		SELECT Y.MODEL_ID
			  ,MIN(Y.CHILD_ITEM_ID) AS CELL_ITEM_ID
		  INTO #CP_CELL_ITEM_INFO
		  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
		 WHERE Y.DIVISION_ID		 = @V_DIVISION_ID
		   AND Y.CELL_TYPE			 = 'CP'
		   AND Y.OPERATION_GROUP_ID	 = 'A'
		 GROUP BY Y.MODEL_ID


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121)  + N' ### 대표Cell 품목 매핑 : AMDAU 모듈의 상위 모델 및 셀(CP) INFO'  
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#MODULE_MODEL_INFO') IS NOT NULL
			DROP TABLE #MODULE_MODEL_INFO;
/*
		SELECT *
		 INTO #MODULE_MODEL_INFO
		 FROM (
  				SELECT B.DIVISION_ID
					  ,B.CHILD_ITEM_ID		AS MODULE_ID
					  ,B.PARENT_ITEM_ID		AS MODEL_ID
					  ,C.CELL_ITEM_ID
					  ,B.KEY_DATE 
					  ,ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
													  ,B.CHILD_ITEM_ID
											  ORDER BY B.KEY_DATE DESC ) AS RN
					  ,ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
													  ,B.CHILD_ITEM_ID
													  ,B.PARENT_ITEM_ID
											  ORDER BY B.KEY_DATE DESC ) AS RN2
					  , F.GROUP_CODE1							
					  , CASE WHEN F.GROUP_CODE1 IN ('E60A', 'E78', 'E79A', 'E129A') THEN 'Y' ELSE 'N' END PACK_MODULE_ITEM	--@@@ 5200 기준 모델 구분진행
				 FROM SCM_MST_BOM_ENG_SN  B WITH(NOLOCK)	-- SCM_MST_BOM_ENG_SN 
					  INNER JOIN #CP_CELL_ITEM_INFO C
							  ON C.MODEL_ID = B.PARENT_ITEM_ID 
					  LEFT  JOIN #SCP_MST_FINAL_ITEM F WITH(NOLOCK)
							  ON F.ITEM_ID	  = B.PARENT_ITEM_ID 
				WHERE B.DIVISION_ID = @V_DIVISION_ID
				  AND B.CHILD_ITEM_ID LIKE 'AMDAU%'
				  AND EXISTS (SELECT TOP 1 *   ---- 2024.01.26 추가 (Pack>module>cell 관계 성립 데이터만 참조)
							   FROM SCM_MST_BOM_SN SB WITH(NOLOCK)
							   WHERE 1=1
							     AND SB.DIVISION_ID		= @V_DIVISION_ID
								 AND SB.CHILD_ITEM_ID	= C.CELL_ITEM_ID	-- CP (Cell Product 
								 AND SB.CONCATENATE_ITEM LIKE CONCAT(B.PARENT_ITEM_ID ,'%', B.CHILD_ITEM_ID, '%') -- pack model_id%module_id%
								 )
			) AS AMDAU_MODEL 
		WHERE 1=1
		  AND RN = 1 
*/

		-- 누락되는 module 이 있어 SCM_MODEL_COMP_TEMP_SN 를 직접보도록 수정
		SELECT *
		 INTO #MODULE_MODEL_INFO
		 FROM (
						
						SELECT B.DIVISION_ID
										  ,B.CHILD_ITEM_ID		AS MODULE_ID
										  ,B.PARENT_ITEM_ID		AS MODEL_ID
										  ,F.CELL_MODEL_ID AS CELL_ITEM_ID	--,C.CHILD_ITEM_ID AS CELL_ITEM_ID
										  ,B.KEY_DATE 
										  ,ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
																		  ,B.CHILD_ITEM_ID
																  ORDER BY B.KEY_DATE DESC ) AS RN
										  ,ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
																		  ,B.CHILD_ITEM_ID
																		  ,B.PARENT_ITEM_ID
																  ORDER BY B.KEY_DATE DESC ) AS RN2
										  , F.GROUP_CODE1							
										  , CASE WHEN F.GROUP_CODE1 IN ('E60A', 'E78', 'E79A', 'E129A', 'E128A') THEN 'Y' ELSE 'N' END PACK_MODULE_ITEM	--@@@ 5200 기준 모델 구분진행
						 FROM SCM_MST_BOM_ENG_SN  B WITH(NOLOCK)  -- SCM_MST_BOM_ENG_SN
								INNER JOIN SCM_MODEL_COMP_TEMP_SN C WITH(NOLOCK)
										ON 1=1
									AND B.COMPANY_ID	= C.COMPANY_ID	-- CP (Cell Product 
									AND B.DIVISION_ID	= C.DIVISION_ID	-- CP (Cell Product 
									AND B.SITE_ID	= C.SITE_ID	-- CP (Cell Product 
									AND B.PLANT_ID	= C.PLANT_ID	-- CP (Cell Product
										and C.MODEL_ID = B.PARENT_ITEM_ID 
								LEFT  JOIN #SCP_MST_FINAL_ITEM F WITH(NOLOCK)
										ON F.ITEM_ID	  = B.PARENT_ITEM_ID 
						WHERE B.DIVISION_ID = @V_DIVISION_ID
							AND B.CHILD_ITEM_ID LIKE 'AMDAU%'
				  AND EXISTS (
							SELECT TOP 1 *   ---- 2024.01.26 추가 (Pack>module>cell 관계 성립 데이터만 참조)
							   FROM SCM_MST_BOM_SN SB WITH(NOLOCK)
							   WHERE 1=1
							     AND SB.DIVISION_ID		= @V_DIVISION_ID
								 AND SB.CHILD_ITEM_ID LIKE 'AMDAU%'
								 AND SB.COMPANY_ID	= C.COMPANY_ID	-- CP (Cell Product 
								 AND SB.DIVISION_ID	= C.DIVISION_ID	-- CP (Cell Product 
								 AND SB.SITE_ID	= C.SITE_ID	-- CP (Cell Product 
								 AND SB.PLANT_ID	= C.PLANT_ID	-- CP (Cell Product 
								 AND SB.CHILD_ITEM_ID	= C.CHILD_ITEM_ID	-- CP (Cell Product 
								 AND SB.CONCATENATE_ITEM LIKE CONCAT(B.PARENT_ITEM_ID ,'%', B.CHILD_ITEM_ID, '%') -- pack model_id%module_id%
								 )
			) AS AMDAU_MODEL 
		WHERE 1=1
			AND RN = 1 

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121)  + N' ### 대표Cell 품목 매핑 : 기타 모델 CP 셀 정보'  
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#ETC_CP_CELL_INFO') IS NOT NULL
			DROP TABLE #ETC_CP_CELL_INFO;

		SELECT B.PARENT_ITEM_ID
			  ,MIN(B.CHILD_ITEM_ID)	AS CELL_ITEM_ID
		 INTO #ETC_CP_CELL_INFO
		 FROM SCM_MST_BOM_SN B WITH(NOLOCK) --  SCM_MST_BOM_SN
			  INNER JOIN #SCP_MST_FINAL_ITEM F WITH(NOLOCK) 
					  ON F.ITEM_ID		= B.CHILD_ITEM_ID
					 AND F.CELL_TYPE	= 'CP'
		WHERE 1=1
		  AND B.DIVISION_ID = @V_DIVISION_ID
		GROUP BY B.PARENT_ITEM_ID
		
		
		
-- begin : 미래구간 Model Inventory (pack plant cell재고 제외) 
-- begin : 미래구간 Model Inventory (pack plant cell재고 제외) 

		-----------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : 기존 Global PSI Raw 데이터 ' 
		-----------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_ANL_PSI_GLOBAL') IS NOT NULL
			DROP TABLE #SCP_ANL_PSI_GLOBAL;

		SELECT PG.OPERATION_GROUP
			 , PG.ITEM_ID
			 , PG.TO_SITE
			 , PG.INCOTERMS
			 , PG.FROM_SITE
			 , PG.TRANSPORT_MODE_LINE
			 , PG.YYYYMMDD
			 , PG.ATTRIBUTE1
			 , PG.FROM_BOH_QTY
			 , PG.TO_BOH_QTY	
			 , PG.MEASURE
			 , PG.QTY
			 , TS.SITE_TYPE			AS TS_SITE_TYPE
			 , TS.OPERATION_GROUP	AS TS_OPERATION_GROUP
		 INTO #SCP_ANL_PSI_GLOBAL
		 FROM SCP_ANL_PSI_GLOBAL PG WITH(NOLOCK)
			  LEFT JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					 ON TS.SCM_SITE_ID = PG.TO_SITE
		WHERE PG.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		  AND PG.PLAN_TYPE				= @V_PLAN_TYPE
		  AND PG.SEQ					= @V_PLAN_SEQ
		  AND PG.DIVISION_ID			= @V_DIVISION_ID
		  AND PG.MEASURE IN (
							 'WH_IN'
							,'SHIP_PLAN'
							,'PRODUCTION'
							-- 20231122 임시로 별도 산식에서 계산 적용 (* 향후 Simulator Char. Plan 저장값이 FN에 확정계획으로 반영될 시 현재 산식기준으로 원복) ,'ACTIVATE_COMPLETED'	-- 특성(F6000) 생산계획 -- CELL_CHAR_PLAN 
							,'MODEL_INVENTORY'		-- 재고(EOH)
							)
		
		-- 81 Division 일 경우 Ship Plan 정보를 WH_IN 으로 넣어준다.
		INSERT INTO #SCP_ANL_PSI_GLOBAL
		SELECT PG.OPERATION_GROUP
			 , PG.ITEM_ID
			 , PG.TO_SITE
			 , PG.INCOTERMS
			 , PG.FROM_SITE
			 , PG.TRANSPORT_MODE_LINE
			 , CONVERT(VARCHAR,DATEADD(DAY, 24, PG.YYYYMMDD),112) AS YYYYMMDD	-- LT 24 적용
			 , PG.ATTRIBUTE1
			 , PG.FROM_BOH_QTY
			 , PG.TO_BOH_QTY	
			 , 'WH_IN' AS MEASURE
			 , PG.QTY
			 , TS.SITE_TYPE			AS TS_SITE_TYPE
			 , TS.OPERATION_GROUP	AS TS_OPERATION_GROUP
		FROM SCP_ANL_PSI_GLOBAL PG WITH(NOLOCK)
			  LEFT JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					 ON TS.SCM_SITE_ID = PG.TO_SITE
		WHERE 1=(CASE WHEN @V_DIVISION_ID = '81' THEN 1 ELSE 0 END)
		  AND PG.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		  AND PG.PLAN_TYPE				= @V_PLAN_TYPE
		  AND PG.SEQ					= @V_PLAN_SEQ
		  --AND PG.DIVISION_ID			= '81_ST'--@V_DIVISION_ID
		  AND PG.MEASURE				= 'SHIP_PLAN'
		  AND PG.ITEM_ID				LIKE 'ACEH1131I-B1%'
		  AND PG.TO_SITE				= 'ESST_CA_WND'
		  AND PG.QTY					<> 0
		  ;

		---------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : 기존 Global PSI Raw 데이터 - asis 기준 재고 삭제 (pack plant cell재고 제외) ' 
		---------------------------------------------------------------------------------------------------------------------------------------------------------
		DELETE PG
		 FROM #SCP_ANL_PSI_GLOBAL PG WITH(NOLOCK)
		WHERE PG.MEASURE	 = 'MODEL_INVENTORY'
		  AND PG.ATTRIBUTE1 != 'CELL'  --- pack plant cell재고를 제외 하고 asis 재고 데이터 삭제 

		---------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : 기존 Global PSI Raw 데이터 - asis 기준 재고 삭제 (to Sales Site WH In) ' 
		---------------------------------------------------------------------------------------------------------------------------------------------------------
		DELETE PG
		 FROM #SCP_ANL_PSI_GLOBAL PG WITH(NOLOCK)
		WHERE PG.MEASURE			IN ('WH_IN', 'SHIP_PLAN')	--@@@ intransit 계산시 AS 빠져서  ship_plan 도 제외
		  AND PG.TS_OPERATION_GROUP = 'W'
		  AND PG.TS_SITE_TYPE		= 'SALES'

		---------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : 기존 Global PSI Raw 데이터 - AMDAU% PRODUCTION 삭제 ' 
		---------------------------------------------------------------------------------------------------------------------------------------------------------
		DELETE PG
		 FROM #SCP_ANL_PSI_GLOBAL PG WITH(NOLOCK)
		WHERE PG.MEASURE	 = 'PRODUCTION'
		  AND PG.ITEM_ID LIKE 'AMDAU%'

		-----------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : 기존 Global PSI 참조 Measure ' 
		-----------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#TMP_ASIS_GLOBAL_PSI') IS NOT NULL
			DROP TABLE #TMP_ASIS_GLOBAL_PSI;

		SELECT PG.OPERATION_GROUP
			 , PG.ITEM_ID
			 , PG.TO_SITE
			 , PG.INCOTERMS
			 , PG.FROM_SITE
			 , PG.TRANSPORT_MODE_LINE
			 , DI.YYYYPW
			 , CASE WHEN PG.MEASURE = 'ACTIVATE_COMPLETED'
					THEN 'CELL_CHAR_PLAN'
					ELSE PG.MEASURE
			   END  AS MEASURE 
			 , CASE WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.ATTRIBUTE1 = 'CELL' 
					THEN 'Y' 
					ELSE 'N' 
				END AS IS_CELL_IN_PACK_PLANT 
			 , PG.FROM_BOH_QTY
			 , PG.TO_BOH_QTY	
			 , SUM(CASE WHEN PG.MEASURE = 'MODEL_INVENTORY' AND DI.PW_TO_YMD = PG.YYYYMMDD
						THEN PG.QTY	
						WHEN PG.MEASURE != 'MODEL_INVENTORY'
						THEN PG.QTY
						ELSE 0.0 END)		AS QTY			-- 재고는 월말 기준 데이터로 적재
		 INTO #TMP_ASIS_GLOBAL_PSI
		 FROM #SCP_ANL_PSI_GLOBAL PG WITH(NOLOCK)
			  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					  ON DI.YYYYMMDD = PG.YYYYMMDD 
		WHERE 1=1
		GROUP BY   PG.OPERATION_GROUP
				 , PG.ITEM_ID
				 , PG.TO_SITE
				 , PG.INCOTERMS
				 , PG.FROM_SITE
				 , PG.TRANSPORT_MODE_LINE
				 , DI.YYYYPW
				 , PG.MEASURE
				 , CASE WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.ATTRIBUTE1 = 'CELL' 
						THEN 'Y' 
						ELSE 'N' 
					END
				 , PG.FROM_BOH_QTY	
				 , PG.TO_BOH_QTY	
				 
		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 재고 - Plant 기초 재고 (보류제외)' 
		-- ASIS ANL PSI PRODUCTION 재고 계산시 적용된 BOH
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#BOH') IS NOT NULL DROP TABLE #BOH;
	
		SELECT  PO.SITE_ID  
			   ,ISNULL(CA.ITEM_ID_ASSY, PO.ITEM_ID) AS ITEM_ID 
			   ,ISNULL(SUM(PO.PSI_BOH_QTY),0)		AS BOH_QTY        
		 INTO #BOH        
		 FROM SCP_PLN_PLANT_ONHAND PO WITH(NOLOCK)                  
			  INNER JOIN #SCM_MST_SITE FS WITH(NOLOCK)
					  ON 1=1
					 AND FS.SCM_SITE_ID		= PO.SITE_ID
			  LEFT  JOIN #CELL_PROD_ASSY_MAP CA with(nolock)
					  ON CA.PLANT_ID		= fs.PLANT_ID 
					 AND CA.ITEM_ID_PROD	= PO.ITEM_ID
					 AND CA.ASSY_PRIORITY_1ST	= 1 
		 WHERE PO.DIVISION_ID			= @V_DIVISION_ID         
		   AND PO.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		   AND PO.PLAN_TYPE				= @V_PLAN_TYPE			
		   AND PO.SEQ					= @V_PLAN_SEQ			
		   AND PO.YYYYMMDD				= @V_PLAN_START_YYYYMMDD	-- plan start date 기준 plant 기초 재고 
		   AND PO.STOCK_TYPE    NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')	-- 셀 특성완료이전 제외           
		 GROUP BY PO.SITE_ID  
				 ,ISNULL(CA.ITEM_ID_ASSY, PO.ITEM_ID) 

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 재고 - 보류 재고 (WH_HOLD) '
		-- 가용일(RECEIVING_DTTM)과 상관 없이 BOH에 모두 반영
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#WH_HOLD') IS NOT NULL DROP TABLE #WH_HOLD;

		-- 보류재고   
		SELECT ISNULL(CA.ITEM_ID_ASSY, ES.ITEM_ID)						AS ITEM_ID 
			  ,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)	AS FROM_SITE
			  ,SUM(ES.QTY)												AS WH_HOLD_QTY   
		 INTO #WH_HOLD
		 FROM #SCP_PLN_TH_ENG_STOCK_PLAN  ES WITH(NOLOCK) 
			  INNER JOIN #SCM_MST_SITE FS WITH(NOLOCK)
					  ON 1=1
					 AND FS.SCM_SITE_ID  = SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)
			  LEFT  JOIN #CELL_PROD_ASSY_MAP CA with(nolock)
					  ON CA.PLANT_ID     = FS.PLANT_ID 
					 AND CA.ITEM_ID_PROD = ES.ITEM_ID
					 AND CA.ASSY_PRIORITY_1ST = 1 
		WHERE 1=1
		  AND ES.LOT_ID	LIKE 'WH_HOLD%'   -- 가용일(RECEIVING_DTTM)과 상관 없이 BOH에 모두 반영 
		GROUP BY ISNULL(CA.ITEM_ID_ASSY, ES.ITEM_ID)
				,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)

		---------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 재고 - 생산/출하 데이터 추출 '
		-- ASIS Global PSI 재고 계산시 적용된 생산 출하 정보 자동차 기준 참조
		---------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_ANL_PSI_PRODUCTION') IS NOT NULL 
			DROP TABLE #SCP_ANL_PSI_PRODUCTION;

		SELECT PS.FROM_SITE
			  ,FS.PLANT_ID
			  ,ISNULL(CA.ITEM_ID_ASSY, PS.ITEM_ID) AS ITEM_ID 
			  ,DI.YYYYPW 
			  ,PS.OPERATION_GROUP
			  ,SUM(CASE WHEN PS.PSI_TYPE = 'S' THEN PS.QTY ELSE 0 END) AS SHIP_QTY
			  ,SUM(CASE WHEN PS.OPERATION_GROUP != 'A' AND PS.PSI_TYPE ='P'											-- pack prod 
						THEN PS.QTY
						WHEN PS.OPERATION_GROUP  = 'A' AND PS.PSI_TYPE ='I' AND PS.PSI_VALUE ='ACTIVATE_COMPLETED'	-- cell prod 
						THEN PS.QTY
						ELSE 0
					END)												AS PROD_QTY
		 INTO #SCP_ANL_PSI_PRODUCTION
		 FROM SCP_ANL_PSI_PRODUCTION PS WITH(NOLOCK)
			  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					  ON DI.YYYYMMDD = PS.YYYYMMDD 
			  INNER JOIN #SCM_MST_SITE FS WITH(NOLOCK)
					  ON 1=1
					 AND FS.SCM_SITE_ID  = PS.FROM_SITE
			  LEFT  JOIN #CELL_PROD_ASSY_MAP CA WITH(nolock)
					  ON CA.PLANT_ID     = FS.PLANT_ID 
					 AND CA.ITEM_ID_PROD = PS.ITEM_ID
					 AND CA.ASSY_PRIORITY_1ST = 1 
		WHERE PS.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		  AND PS.PLAN_TYPE				= @V_PLAN_TYPE
		  AND PS.SEQ					= @V_PLAN_SEQ
		  AND PS.DIVISION_ID			= @V_DIVISION_ID
		  AND PS.PSI_VALUE			   != 'ISSUM'
		  AND (PS.PSI_TYPE = 'S' 
				OR (PS.OPERATION_GROUP != 'A' AND PS.PSI_TYPE ='P')											-- pack prod 		
				OR (PS.OPERATION_GROUP  = 'A' AND PS.PSI_TYPE ='I' AND PS.PSI_VALUE ='ACTIVATE_COMPLETED')	-- cell prod
				)
		GROUP BY 
			   PS.FROM_SITE
			  ,FS.PLANT_ID
			  ,ISNULL(CA.ITEM_ID_ASSY, PS.ITEM_ID)
			  ,DI.YYYYPW 
			  ,PS.OPERATION_GROUP


		CREATE NONCLUSTERED INDEX PSI_PRODUCTION_IDX1 ON #SCP_ANL_PSI_PRODUCTION(ITEM_ID, FROM_SITE, YYYYPW) ;

		---------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 재고 - 생산/출하 누적 수량 '
		---------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#PSI_PROD_SHIP') IS NOT NULL 
			DROP TABLE #PSI_PROD_SHIP;

		SELECT PS.ITEM_ID
			 , PS.FROM_SITE
			 , PS.OPERATION_GROUP 
			 , PS.YYYYPW
			 , SUM(SHIP_QTY)	OVER	(PARTITION BY PS.ITEM_ID
													, PS.FROM_SITE
											 ORDER BY PS.YYYYPW)	AS ACC_SHIP_QTY        
			 , SUM(PROD_QTY)	OVER	(PARTITION BY PS.ITEM_ID
													, PS.FROM_SITE
											 ORDER BY PS.YYYYPW)	AS ACC_PROD_QTY        
			 , SUM(SHIP_QTY)	OVER	(PARTITION BY PS.ITEM_ID
													, PS.FROM_SITE)	AS SUB_TOT_SHIP_QTY        
			 , SUM(PROD_QTY)	OVER	(PARTITION BY PS.ITEM_ID
													, PS.FROM_SITE)	AS SUB_TOT_PROD_QTY        
		 INTO #PSI_PROD_SHIP
		 FROM #SCP_ANL_PSI_PRODUCTION PS with(nolock)
		WHERE 1=1
		ORDER BY  PS.ITEM_ID
				 ,PS.FROM_SITE
				 ,PS.YYYYPW 

		---------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 재고 - 재고계산 '
		-- Pack plant 팩재고, Cell Plant 셀재고
		-- 재고 = 기초재고 + 보류재고 + 생산(누적) - 출하(누적)
		---------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#MODEL_INVENTORY') IS NOT NULL 
			DROP TABLE #MODEL_INVENTORY;

		SELECT PS.ITEM_ID
			  ,PS.FROM_SITE
			  ,PS.YYYYPW
			  ,PS.OPERATION_GROUP
			  ,PS.ACC_SHIP_QTY
			  ,PS.ACC_PROD_QTY
			  ,PS.SUB_TOT_SHIP_QTY
			  ,PS.SUB_TOT_PROD_QTY
			  ,ISNULL(WH.WH_HOLD_QTY, 0)							AS WH_HOLD_QTY
			  ,ISNULL(BH.BOH_QTY, 0)								AS ASIS_BOH_QTY
			  ,ISNULL(BH.BOH_QTY, 0) + ISNULL(WH.WH_HOLD_QTY, 0)	AS TOBE_BOH_QTY
			  ,ISNULL(BH.BOH_QTY, 0) 
					+ ACC_PROD_QTY	- ACC_SHIP_QTY					AS ASIS_MODEL_INVENTORY
			  ,ISNULL(BH.BOH_QTY, 0) + ISNULL(WH.WH_HOLD_QTY, 0)
					+ ACC_PROD_QTY	- ACC_SHIP_QTY					AS TOBE_MODEL_INVENTORY
		 INTO #MODEL_INVENTORY	 
		 FROM #PSI_PROD_SHIP PS WITH(NOLOCK)
			  LEFT JOIN #BOH BH WITH(NOLOCK)
					 ON BH.SITE_ID = PS.FROM_SITE
					AND BH.ITEM_ID = PS.ITEM_ID 
			  LEFT JOIN #WH_HOLD WH WITH(NOLOCK)
					 ON WH.FROM_SITE = PS.FROM_SITE
					AND WH.ITEM_ID	= PS.ITEM_ID 
		WHERE 1=1
		ORDER BY  PS.ITEM_ID
				 ,PS.FROM_SITE
				 ,PS.YYYYPW 

		---------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 재고 - 재고 measure 추가 '
		---------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT MI.OPERATION_GROUP
			  ,MI.ITEM_ID
			  ,'-'						AS TO_SITE 
			  ,'-'						AS INCOTERMS
			  ,MI.FROM_SITE
			  ,'-'						AS VARIOUS_KEY
			  ,MI.YYYYPW
			  ,'MODEL_INVENTORY'		AS MEASURE 
			  ,'N'						AS IS_CELL_IN_PACK_PLANT
			  ,MI.TOBE_BOH_QTY			AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,MI.TOBE_MODEL_INVENTORY	AS QTY
		 FROM #MODEL_INVENTORY	MI WITH(NOLOCK)
		WHERE 1=1

-- end : 미래구간 Model Inventory (pack plant cell재고 제외) 
-- end : 미래구간 Model Inventory (pack plant cell재고 제외) 
		
		
--  @@@ 위치 옮김
----- Begin :### 실적 구간 Ending Inventory Weekly 재고
----- Begin :### 실적 구간 Ending Inventory Weekly 재고
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 참조 대상 품목 정보' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_TARGET_ITEM_FOR_ENDING_INV') IS NOT NULL	
			DROP TABLE #TMP_TARGET_ITEM_FOR_ENDING_INV;

		SELECT II.ITEM_ID
			  ,ISNULL(MAX(FI.FINISHED_PRODUCT),'N')	AS FINISHED_PRODUCT 
			  ,MAX(II.SCP_FLOW_ID)					AS OPERATION_ID
			  ,MAX(II.SCP_OPERATION_GROUP)			AS OPERATION_GROUP
		 INTO #TMP_TARGET_ITEM_FOR_ENDING_INV
		 FROM SCM_MST_ITEM_SN  II WITH(NOLOCK)   -- SCM_MST_ITEM_SN
			  LEFT  JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID		= II.ITEM_ID
		WHERE 1=1
		  AND II.DIVISION_ID = @V_DIVISION_ID
		  AND II.SCP_OPERATION_GROUP IN ('A', 'P')
		  AND (
			  II.ITEM_ID LIKE 'AMDAU%'
			  OR 
			  EXISTS (SELECT TOP 1 L.SEGMENT1
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
						WHERE L.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
						  AND L.SEGMENT1	= II.SCP_FLOW_ID
						  AND L.SEGMENT1   != 'F6000'
						  AND L.VALID_YN	= 'Y'
						  AND L.SEGMENT4 LIKE '%'+@V_DIVISION_ID+'%'
						)
			  )
		GROUP BY II.ITEM_ID


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 시뮬레이터 measure sloc 매핑 정보' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_SLOC_ADD_INFO') IS NOT NULL	
			DROP TABLE #TMP_SLOC_ADD_INFO;

		SELECT DISTINCT 	
			  SEGMENT1		AS PLANT	
			 ,SEGMENT2		AS SLOC	
			 ,ATTRIBUTE12	AS SIMU_MEASURE	
		 INTO #TMP_SLOC_ADD_INFO
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)	
		WHERE LOOKUP_TYPE = 'SLOC_ADD_INFO'	
		  AND ATTRIBUTE12 <> ''	

        -- 2025.05.28   kimcd GLOBAL PSI NEW - AS 대상 SALES_TYPE_CODE 임시 정보 형성 시작
 		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### AS 대상 SALES_TYPE_CODE' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_AS_SALES_TYPE_CODE') IS NOT NULL	
			DROP TABLE #TMP_AS_SALES_TYPE_CODE;

		SELECT SEGMENT1		AS FCST_TYPE	
		 INTO  #TMP_AS_SALES_TYPE_CODE
		 FROM  SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)	
		WHERE  LOOKUP_TYPE = 'SALES_TYPE_CODE'	
		  AND  ATTRIBUTE3  = 'Y';
		-- 2025.05.28   kimcd GLOBAL PSI NEW - AS 대상 SALES_TYPE_CODE 임시 정보 형성 끝

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - Raw 데이터' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_RAW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_RAW;

		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,IV.STORAGE_LOCATION
			  ,IV.PLANT_ID
			  ,IV.SUPPLIER_CODE
			  ,IV.QUANTITY
		 INTO #TMP_ENDING_INV_MM_RAW
		 FROM SCP_ANL_MONTH_END_STOCK_R IV WITH(NOLOCK)   
		WHERE IV.DIVISION_ID =  @V_DIVISION_ID
		  AND IV.YYYYMM     >=  @V_INV_FROM_YYYYMM 
		  AND IV.YYYYMM     <=  @V_INV_TO_YYYYMM
		  AND ISNULL(IV.SPECIAL_INVENTORY,'') != 'W' --@@@ Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM_0 에 직접 입력함.

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - 1' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_0') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_0;

		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,II.OPERATION_ID
			  ,II.OPERATION_GROUP
			  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
			  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
			  ,CASE WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'P'		THEN 'PACK_EOH'
					WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'A'		THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_BOH'												THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH'		AND II.OPERATION_GROUP = 'A'		THEN 'PACK_CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_FOR_FORM_END'										THEN 'CELL_CHAR_AVAILABLE'
					--WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT'
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 
						(CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')						THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'P5000'									THEN 'SEMI_INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT  = 'Y'	THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT != 'Y'	THEN 'SEMI_INTRANSIT'
							  ELSE 'SEMI_INTRANSIT'
						  END )									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7000'	THEN
						 CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')						THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'P5000'									THEN 'SEMI_INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT  = 'Y'	THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT != 'Y'	THEN 'SEMI_INTRANSIT'
							  ELSE 'ENDING_INV_FOR_DIO'
						  END 
					WHEN SM.SIMU_MEASURE = 'VMI'													THEN 'TO_SITE_EOH'		
					WHEN SM.SIMU_MEASURE = 'AS'														THEN 'AS_INV'		
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = 'In-T'	THEN 'INTRANSIT'      -- 20250210 DJLEE 'IN-T' MAPPING
					ELSE 'ENDING_INV_FOR_DIO'
				END AS MEASURE 
			  ,SUM(IV.QUANTITY)	AS QTY
		 INTO #TMP_ENDING_INV_MM_0
		 FROM #TMP_ENDING_INV_MM_RAW IV WITH(NOLOCK)   
			  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  INNER JOIN #TMP_SLOC_ADD_INFO SM WITH(NOLOCK)
					  ON SM.PLANT		= IV.PLANT_ID
					 AND SM.SLOC		= IV.STORAGE_LOCATION
			  LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= CASE WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'	AND IV.STORAGE_LOCATION = N'미착'
												   THEN IV.SUPPLIER_CODE
												   ELSE IV.PLANT_ID
											  END 
					 AND FS.OPERATION_GROUP	= CASE WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH'  -- pack plant cell
												   THEN 'P' 
												   ELSE II.OPERATION_GROUP
											   END 
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= CASE WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'	AND IV.STORAGE_LOCATION = N'미착'
												   THEN IV.PLANT_ID
												   ELSE 'Z'
											  END 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE 1=1
		GROUP BY IV.ITEM_ID
				,IV.YYYYMM
				,II.OPERATION_ID
				,II.OPERATION_GROUP
			    ,ISNULL(FS.SCM_SITE_ID, '-')
			    ,ISNULL(TS.SCM_SITE_ID, '-')
			  ,CASE WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'P'		THEN 'PACK_EOH'
					WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'A'		THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_BOH'												THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH'		AND II.OPERATION_GROUP = 'A'		THEN 'PACK_CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_FOR_FORM_END'										THEN 'CELL_CHAR_AVAILABLE'
					--WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT'	
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 
						(CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')						THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'P5000'									THEN 'SEMI_INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT  = 'Y'	THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT != 'Y'	THEN 'SEMI_INTRANSIT'
							  ELSE 'SEMI_INTRANSIT'
						  END )	
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7000'	THEN
						 CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')						THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'P5000'									THEN 'SEMI_INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT  = 'Y'	THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT != 'Y'	THEN 'SEMI_INTRANSIT'
							  ELSE 'ENDING_INV_FOR_DIO'
						  END 
					WHEN SM.SIMU_MEASURE = 'VMI'													THEN 'TO_SITE_EOH'		
					WHEN SM.SIMU_MEASURE = 'AS'														THEN 'AS_INV'		
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = 'In-T'	THEN 'INTRANSIT'      -- 20250210 DJLEE 'IN-T' MAPPING
					ELSE 'ENDING_INV_FOR_DIO'
				END  
			;
		
		
		--@@@ Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM_0 에 직접 입력함.
		INSERT INTO #TMP_ENDING_INV_MM_0 
		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,II.OPERATION_ID
			  ,II.OPERATION_GROUP
			  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
			  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
			  ,'TO_SITE_EOH' AS MEASURE 
			  ,SUM(IV.QUANTITY)	AS QTY
		 FROM SCP_ANL_MONTH_END_STOCK_R IV WITH(NOLOCK)   
			  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= IV.PLANT_ID
					 AND FS.OPERATION_GROUP	= II.OPERATION_GROUP
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= 'Z' 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE IV.DIVISION_ID =  @V_DIVISION_ID
		  AND IV.YYYYMM     >=  @V_INV_FROM_YYYYMM 
		  AND IV.YYYYMM     <=  @V_INV_TO_YYYYMM
		  AND ISNULL(SPECIAL_INVENTORY,'') = 'W' 
		GROUP BY IV.ITEM_ID
				,IV.YYYYMM
				,II.OPERATION_ID
				,II.OPERATION_GROUP
			    ,ISNULL(FS.SCM_SITE_ID, '-')
			    ,ISNULL(TS.SCM_SITE_ID, '-')
			;
		
		-- 20250210 DJLEE SLOC & DESC 정보가 ''  건이 있음. (NERP 전환후)
		INSERT INTO #TMP_ENDING_INV_MM_0 
		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,II.OPERATION_ID
			  ,II.OPERATION_GROUP
			  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
			  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
			  ,'TO_SITE_EOH' AS MEASURE 
			  ,SUM(IV.QUANTITY)	AS QTY
		 FROM SCP_ANL_MONTH_END_STOCK_R IV WITH(NOLOCK)   
			  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= IV.PLANT_ID
					 AND FS.OPERATION_GROUP	= II.OPERATION_GROUP
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= 'Z' 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE IV.DIVISION_ID =  @V_DIVISION_ID
		  AND IV.YYYYMM     >=  @V_INV_FROM_YYYYMM 
		  AND IV.YYYYMM     <=  @V_INV_TO_YYYYMM
		  AND ISNULL(IV.STORAGE_LOCATION, '') = ''
		  AND ISNULL(IV.STORAGE_DESC, '') = ''
		GROUP BY IV.ITEM_ID
				,IV.YYYYMM
				,II.OPERATION_ID
				,II.OPERATION_GROUP
			    ,ISNULL(FS.SCM_SITE_ID, '-')
			    ,ISNULL(TS.SCM_SITE_ID, '-')
		;
		
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_RAW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_RAW;


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - 2 - 0채움' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM;

		;WITH MM_LIST AS (
			SELECT DISTINCT YYYYMM
			   FROM #TMP_PW_LIST WITH(NOLOCK)
			 WHERE 1=1
			   AND YYYYPW <= @V_PLAN_START_YYYYPW   -- 당월 포함 과거 구간만 
		)
		SELECT IM.ITEM_ID
			  ,ML.YYYYMM
			  ,IM.OPERATION_ID
			  ,IM.OPERATION_GROUP
			  ,IM.MEASURE
			  ,IM.FROM_SITE
			  ,IM.TO_SITE
			  ,SUM(CASE WHEN IM.YYYYMM = ML.YYYYMM THEN IM.QTY ELSE 0.0 END) AS QTY
		  INTO #TMP_ENDING_INV_MM  
		  FROM #TMP_ENDING_INV_MM_0 IM WITH(NOLOCK)
			   INNER JOIN MM_LIST ML
					   ON 1=1
		WHERE 1=1
		GROUP BY
			   IM.ITEM_ID
			  ,ML.YYYYMM
			  ,IM.OPERATION_ID
			  ,IM.OPERATION_GROUP
			  ,IM.MEASURE
			  ,IM.FROM_SITE
			  ,IM.TO_SITE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 주별 기초 재고 (전월재고)  ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_WW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_WW;

		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYPW_SEQ
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,EI.ITEM_ID
			  ,EI.OPERATION_GROUP
			  ,EI.FROM_SITE
			  ,EI.TO_SITE
			  ,EI.MEASURE
			  ,SUM(CASE WHEN WL.YYYYMM_PRVS = EI.YYYYMM THEN EI.QTY ELSE 0.0 END)	AS YYYYMM_PRVS_QTY 
		  INTO #TMP_ENDING_INV_MM_WW
		  FROM #TMP_PW_LIST WL WITH(NOLOCK)
				INNER JOIN #TMP_ENDING_INV_MM EI WITH(NOLOCK)
						ON 1=1
		WHERE 1=1
		  AND WL.YYYYPW < @V_PLAN_START_YYYYPW  -- 과거 실적 구간  
		GROUP BY 
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYPW_SEQ
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,EI.ITEM_ID
			  ,EI.OPERATION_GROUP
			  ,EI.FROM_SITE
			  ,EI.TO_SITE
			  ,EI.MEASURE
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 AS_IN_PLAN, AS_IN_REQ  ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ENDING_INV_MM_WW
   	    SELECT	   WL.YYYYPW
				  ,WL.PW_TO_YMD
				  ,WL.YYYYMM
				  ,WL.YYYYMM_PRVS
				  ,WL.YYYYPW_SEQ
				  ,WL.YYYYMM_FIRST_YMD
				  ,WL.YYYYMM_LAST_YMD
				  ,IV.ITEM_ID
				  ,II.OPERATION_GROUP
				  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
				  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
				  ,ML.MEASURE	AS MEASURE
				  ,SUM(IV.QTY)	AS QTY
		 FROM	(
					  SELECT IV.*, DI.YYYYPW
					  FROM	SCM_AS_SHIP_V_SN IV WITH(NOLOCK)   
							INNER JOIN #TMP_DATE_INFO DI
			  				  ON 1=1
			  				 AND IV.SHIP_YYYYMMDD = DI.YYYYMMDD
							--AND DI.YYYYMM     >=  @V_RESULT_FROM_YYYYMMDD 
		  					--AND DI.YYYYMM     <=  @V_HORIZON_END_YYYYMMDD
					  WHERE IV.DIVISION_ID 		=  @V_DIVISION_ID
					    AND IV.SHIP_YYYYMMDD 	<  @V_PLAN_START_YYYYMMDD
					    AND IV.QTY > 0
				) IV
			  INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
			          ON 1=1
					 AND IV.YYYYPW = WL.YYYYPW
			  INNER JOIN (
			  				SELECT 'AS_IN_REQ' AS MEASURE UNION ALL SELECT 'AS_IN_PLAN' AS MEASURE 
			  			 ) ML
			  		  ON 1=1
		 	  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= IV.PLANT_ID
					 AND FS.OPERATION_GROUP	= II.OPERATION_GROUP
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= 'Z' 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE	1=1
		GROUP BY   WL.YYYYPW
				  ,WL.PW_TO_YMD
				  ,WL.YYYYMM
				  ,WL.YYYYMM_PRVS
				  ,WL.YYYYPW_SEQ
				  ,WL.YYYYMM_FIRST_YMD
				  ,WL.YYYYMM_LAST_YMD
				  ,IV.ITEM_ID
				  ,II.OPERATION_GROUP
				  ,ISNULL(FS.SCM_SITE_ID, '-')
				  ,ISNULL(TS.SCM_SITE_ID, '-')
				  ,ML.MEASURE
		
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT   SO.OPERATION_GROUP
				,SO.ITEM_ID
				,SO.FROM_SITE 		AS TO_SITE
				,'-' 				AS INCOTERMS
				,'-'				AS FROM_SITE
			  	,'-'				AS TRANSPORT_MODE_LINE
				,ML.YYYYPW 			AS YYYYPW
				,SO.MEASURE			AS MEASURE
			  	,'N'				AS IS_CELL_IN_PACK_PLANT
			  	,0.0				AS FROM_BOH_QTY
			  	,0.0				AS TO_BOH_QTY
			  	,SUM(SO.YYYYMM_PRVS_QTY)		AS QTY
		FROM 	#TMP_ENDING_INV_MM_WW SO WITH(NOLOCK)
				INNER JOIN #TMP_PW_LIST ML WITH(NOLOCK)
				  		ON 1=1
				  	   AND ML.YYYYPW <= @V_PLAN_START_YYYYPW
					   AND ML.YYYYPW = SO.YYYYPW
		WHERE 1=1
		AND SO.YYYYPW	<= @V_PLAN_START_YYYYPW
		AND SO.MEASURE	IN ('AS_IN_REQ', 'AS_IN_PLAN')
		GROUP BY SO.ITEM_ID, SO.OPERATION_GROUP, SO.FROM_SITE, ML.YYYYPW, SO.MEASURE
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : FP Aging Stock' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#FP_AGING_STOCK') IS NOT NULL	
		DROP TABLE #FP_AGING_STOCK;

		SELECT WL.YYYYPW
			  ,SA.CUTOFF_DATE
			  ,PS.SCM_SITE_ID	AS FROM_SITE
			  ,SA.ITEM_ID
			  ,SUM(CASE WHEN SA.REMAIN_LEAD_TIME = 0 THEN SA.QTY ELSE 0 END)	AS FP_CHAR_AVAILABLE
			  ,SUM(CASE WHEN SA.REMAIN_LEAD_TIME > 0 THEN SA.QTY ELSE 0 END)	AS FP_FORM_PROGRESS
			  ,SUM(SA.QTY)														AS FP_AGING_TOTAL
			  ,'A'																AS DIV
		 INTO #FP_AGING_STOCK
		 FROM #TMP_PW_LIST WL WITH(NOLOCK)
			  INNER JOIN SCM_DNM_STOCK_AGING_SN SA WITH(NOLOCK) 
			  	  ON 1=1 
					 AND SA.CUTOFF_DATE = WL.PW_TO_YMD_NEXT_DAY
					 AND SA.DIVISION_ID = @V_DIVISION_ID
			  INNER JOIN #SCM_MST_SITE PS WITH(NOLOCK) 
					  ON PS.PLANT_ID		= SA.PLANT_ID
					 AND PS.SITE_TYPE		= 'PLANT'
					 AND PS.OPERATION_GROUP = 'A'	-- Cell  
		WHERE 1=1
		  AND WL.YYYYPW	<  @V_PLAN_START_YYYYPW -- 과거 실적 구간
		GROUP BY WL.YYYYPW
			  ,SA.CUTOFF_DATE
			  ,PS.SCM_SITE_ID
			  ,SA.ITEM_ID
	
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : FP Aging Stock (현재 없는 기 적재된 데이터)' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #FP_AGING_STOCK
		SELECT GP.YYYYPW
			  ,CONVERT(DATE, GP.VARIOUS_KEY, 112)	AS CUTOFF_DATE
			  ,GP.FROM_SITE
			  ,GP.ITEM_ID
			  ,CONVERT(NUMERIC(20,10), ATTRIBUTE1)	AS FP_CHAR_AAILABLE
			  ,GP.QTY								AS FP_FORM_PROGRESS
			  ,CONVERT(NUMERIC(20,10), ATTRIBUTE2)	AS FP_AGING_TOTAL
			  ,'B'									AS DIV
		 FROM SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK)
		WHERE 1=1
	      AND GP.PLAN_START_YYYYMMDD = '00000000'
		  AND GP.DIVISION_ID		 = @V_DIVISION_ID
		  AND GP.YYYYPW				 < @V_PLAN_START_YYYYPW -- 과거 실적 구간
		  AND GP.MEASURE			 = 'FORM_PROGRESS'
		  AND NOT EXISTS (SELECT *
							FROM #FP_AGING_STOCK SA
						   WHERE 1=1
						     AND SA.YYYYPW		= GP.YYYYPW
							 AND SA.FROM_SITE	= GP.FROM_SITE
							 AND SA.ITEM_ID		= GP.ITEM_ID)

				----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : MKT_FCST/RTF(DM 참조) Measure 추가' 
		-- 계획 구간 WH_IN_BLANCE 계산 후 추가함.
		-- plan 주차 해당월 WH_IN_BALANCE 계산시 적용 안함 - plan date 기준 BOH 및 계획 수량 정보로 계산함
		----------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#FCST_RTF_RESULT') IS NOT NULL
			DROP TABLE #FCST_RTF_RESULT;

		;WITH MEASURE_INFO AS (
			SELECT 'MKT_FCST'	AS MEASURE , 'RTF_SYS_RP' AS DM_MEASURE	-- MKT FCST[R+P]
			UNION ALL
			SELECT 'RTF'		AS MEASURE , 'RTF_SYS_RP' AS DM_MEASURE	-- RTF[R+P]
		)
		SELECT MK.OPERATION_GROUP
			  ,MK.ITEM_ID
			  ,MK.TO_SITE
			  ,MK.INCOTERMS	
			  ,'-'				AS FROM_SITE	-- SCP global psi는 to 사이트 기준 데이터임 
			  ,MK.TRANSPORT_MODE
			  ,MK.YYYYPW
			  ,MK.MEASURE
	          ,'N'				AS IS_CEL_INVENTORY
	          ,0.0				AS FROM_BOH_QTY
	          ,0.0				AS TO_BOH_QTY
			  ,SUM(MK.QTY)		AS QTY
		 INTO #FCST_RTF_RESULT
		 FROM ( SELECT FI.OPERATION_GROUP
			          ,FI.ITEM_ID
			          ,MK.SCM_SITE_ID	AS TO_SITE
			          ,MK.INCOTERMS	
			          ,MK.PROJECT_CODE	AS TRANSPORT_MODE
			          ,DI.YYYYPW
			          --,CASE WHEN MK.FCST_TYPE = 'WS' THEN 'AS_' ELSE '' END + MI.MEASURE AS MEASURE  -- 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경
			          ,CASE WHEN MK.FCST_TYPE IN  ( SELECT FCST_TYPE
			                                        FROM   #TMP_AS_SALES_TYPE_CODE ) THEN 'AS_' ELSE '' END + MI.MEASURE AS MEASURE
			          ,MK.QTY		AS QTY
		          FROM DM_PLN_MKT_FCST_RESULT_C MK WITH(NOLOCK)
			           INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					           ON FI.ITEM_ID		= MK.ITEM_ID 
			           INNER JOIN MEASURE_INFO     MI WITH(NOLOCK)
					           ON MI.DM_MEASURE  = MK.MEASURE
			           INNER JOIN #SCM_MST_SITE    MS WITH(NOLOCK)
					           ON MS.SCM_SITE_ID = MK.SCM_SITE_ID 
					          AND MS.SITE_TYPE   = 'SALES'
			           INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					           ON DI.YYYYMMDD = MK.YYYYMMDD 
		         WHERE 1=1
		           AND MK.DIVISION_ID = @V_DIVISION_ID
		           AND MK.VERSION_NO  = @V_DM_VERSION_NO 
		           AND MK.QTY != 0 ) MK
		GROUP BY MK.OPERATION_GROUP
				,MK.ITEM_ID
				,MK.TO_SITE
				,MK.INCOTERMS	
				,MK.TRANSPORT_MODE
				,MK.YYYYPW
			    --,CASE WHEN MK.FCST_TYPE = 'WS' THEN 'AS_' ELSE '' END + MI.MEASURE  -- 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경
			    ,MK.MEASURE
		;

		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		 SELECT *
		 FROM #FCST_RTF_RESULT	WITH(NOLOCK)
		 WHERE 1=1
		 ;

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : 생산 실적 Raw Data - 대상 Operation' 
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#PRODUCTION_OPERATION') IS NOT NULL
			DROP TABLE #PRODUCTION_OPERATION;

		SELECT *
		 INTO #PRODUCTION_OPERATION
		 FROM ( 
				SELECT L.SEGMENT1 AS OPERATION_ID
				 FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
				WHERE L.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
				  AND L.VALID_YN	= 'Y'
				  AND L.SEGMENT4 LIKE '%'+@V_DIVISION_ID+'%'
				UNION 		
				SELECT PS.PLANT_ID  -- 외주 Packer 실적 Operation
				 FROM #SCM_MST_SITE PS WITH(NOLOCK)
				WHERE PS.SITE_TYPE    = 'PLANT'
				  AND PS.OSP_YN       = 'Y'
				  AND PS.VALID_YN     = 'Y'
				UNION 
				SELECT 'F6000' -- 셀 특성 
			) A


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : 생산 실적 Raw Data' 
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#PRODUCTION_RESULT') IS NOT NULL
			DROP TABLE #PRODUCTION_RESULT;

		SELECT FS.SCM_SITE_ID			AS FROM_SITE   
			  ,B.SCP_OPERATION_GROUP	AS OPERATION_GROUP
			  ,A.PLANT_ID			
			  ,A.ITEM_ID
			  ,A.OPERATION_ID
			  ,A.LINE_ID
			  ,CONVERT(NVARCHAR(8), A.PLAN_DATE, 112)	AS PLAN_YYYYMMDD
			  ,A.ACTUAL_GOOD_QTY             
		 INTO #PRODUCTION_RESULT 
		 FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A WITH(NOLOCK)	-- SCM_DNM_DAILY_PRODUCT_RESULT_SN
			  INNER JOIN SCM_MST_ITEM_SN  B WITH(NOLOCK)		-- SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) 
					  ON B.COMPANY_ID		= A.COMPANY_ID
				     AND B.DIVISION_ID		= A.DIVISION_ID
				     AND B.SITE_ID			= A.SITE_ID
				     AND B.ITEM_ID			= A.ITEM_ID
					 AND B.SCP_OPERATION_GROUP IS NOT NULL	-- SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) 
					 AND B.SCP_OPERATION_GROUP IN ('A', 'P') -- cell/pack만 
		    LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)
					  ON FS.PLANT_ID		= A.PLANT_ID
					 AND FS.OPERATION_GROUP	= B.SCP_OPERATION_GROUP
					 AND FS.SITE_TYPE		= 'PLANT'
					 AND FS.VALID_YN		= 'Y'
		WHERE 1=1
		  AND A.DIVISION_ID		 = @V_DIVISION_ID	
		  AND A.PLAN_DATE		>= @V_RESULT_FROM_DATE 
		  AND A.PLAN_DATE		<  @V_PLAN_START_DATE
		  AND A.PRODUCTION_TYPE     NOT IN ('REWORK', 'PILOT')	-- SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) 
		  AND A.OPERATION_ID IN (SELECT OPERATION_ID FROM #PRODUCTION_OPERATION) 
		  AND NOT EXISTS (
							SELECT 1
							  FROM #MODULE_MODEL_INFO MI
							 WHERE 1=1
							   AND MI.PACK_MODULE_ITEM = 'Y'
							   AND MI.MODEL_ID = A.ITEM_ID
		  				  )
		  				  
		-- P5200 공정 실적 P5500 으로 변경 
		INSERT INTO #PRODUCTION_RESULT		  				  
		SELECT FS.SCM_SITE_ID			AS FROM_SITE   
			  ,B.SCP_OPERATION_GROUP	AS OPERATION_GROUP
			  ,A.PLANT_ID			
			  ,MI.MODEL_ID AS ITEM_ID	--A.ITEM_ID
			  ,'P5500' AS OPERATION_ID
			  ,A.LINE_ID
			  ,CONVERT(NVARCHAR(8), A.PLAN_DATE, 112)	AS PLAN_YYYYMMDD
			  ,A.ACTUAL_GOOD_QTY
		 
		 FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A WITH(NOLOCK) -- SCM_DNM_DAILY_PRODUCT_RESULT_SN
			  INNER JOIN SCM_MST_ITEM_SN  B WITH(NOLOCK)	 -- SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) 
					  ON B.COMPANY_ID		= A.COMPANY_ID
				     AND B.DIVISION_ID		= A.DIVISION_ID
				     AND B.SITE_ID			= A.SITE_ID
				     AND B.ITEM_ID			= A.ITEM_ID
					 AND B.SCP_OPERATION_GROUP IS NOT NULL	 -- SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) 
					 AND B.SCP_OPERATION_GROUP IN ('P') -- cell/pack만 
		    LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)
					  ON FS.PLANT_ID		= A.PLANT_ID
					 AND FS.OPERATION_GROUP	= B.SCP_OPERATION_GROUP
					 AND FS.SITE_TYPE		= 'PLANT'
					 AND FS.VALID_YN		= 'Y'
			INNER JOIN #MODULE_MODEL_INFO MI
					ON 1=1
					AND MI.PACK_MODULE_ITEM = 'Y'
					AND MI.MODULE_ID = A.ITEM_ID
		WHERE 1=1
		  AND A.DIVISION_ID		 = @V_DIVISION_ID	
		  AND A.PLAN_DATE		>= @V_RESULT_FROM_DATE 
		  AND A.PLAN_DATE		<  @V_PLAN_START_DATE
		  AND A.PRODUCTION_TYPE     NOT IN ('REWORK', 'PILOT')	-- SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) 
		  AND A.OPERATION_ID 	= 'P5200' 

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : 생산 실적 Measure 추가' 
		-----------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT P.OPERATION_GROUP
			  ,P.ITEM_ID
			  ,'-'			AS TO_SITE 
			  ,'-'			AS INCOTERMS
			  ,P.FROM_SITE
			  ,P.LINE_ID	AS TRANSPORT_MODE_LINE
			  ,DI.YYYYPW
			  ,'PRODUCTION'	AS MEASURE
			  ,'N'			AS IS_CELL_IN_PACK_PLANT
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,SUM(P.ACTUAL_GOOD_QTY)	AS QTY
		 FROM #PRODUCTION_RESULT P WITH(NOLOCK)
			  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					  ON DI.YYYYMMDD = P.PLAN_YYYYMMDD
		WHERE 1=1
		  AND OPERATION_ID != 'F6000' -- 셀 특성 제외 
		GROUP BY P.OPERATION_GROUP
				,P.ITEM_ID
				,P.FROM_SITE
				,P.LINE_ID
				,DI.YYYYPW


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : 생산 실적 Measure 추가 (셀 특성 F6000) ' 
		-----------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT P.OPERATION_GROUP
			  ,P.ITEM_ID
			  ,'-'						AS TO_SITE 
			  ,'-'						AS INCOTERMS
			  ,P.FROM_SITE
			  ,P.LINE_ID				AS TRANSPORT_MODE_LINE
			  ,DI.YYYYPW
			  ,'CELL_CHAR_PLAN'		AS MEASURE
			  ,'N'						AS IS_CELL_IN_PACK_PLANT
			  ,0.0						AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,SUM(P.ACTUAL_GOOD_QTY)	AS QTY
		 FROM #PRODUCTION_RESULT P WITH(NOLOCK)
			  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					  ON DI.YYYYMMDD = P.PLAN_YYYYMMDD
		WHERE 1=1
		  AND P.OPERATION_ID = 'F6000'  -- 셀 특성  
		GROUP BY P.OPERATION_GROUP
				,P.ITEM_ID
				,P.FROM_SITE
				,P.LINE_ID
				,DI.YYYYPW


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : 출하 실적 Raw Data' 
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SHIPMENT_RESULT') IS NOT NULL
			DROP TABLE #SHIPMENT_RESULT;
		
		IF OBJECT_ID('TEMPDB..#SHIPTO_CODE') IS NOT NULL
			DROP TABLE #SHIPTO_CODE;

		SELECT SHIPTO_CODE
		INTO	#SHIPTO_CODE
		FROM	(
					SELECT DISTINCT SHIPTO_CODE
					FROM XIF_ERP_SALES_RESULT_R_SN SC WITH(NOLOCK)
					WHERE 1=1
					AND		SC.DIVISION_ID = @V_DIVISION_ID --해당 DIVISION 정보 (JV 포함되어야)
					AND		SC.ATTRIBUTE1 IN ( SELECT FCST_TYPE
			                                   FROM   #TMP_AS_SALES_TYPE_CODE )  -- 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경
					AND		SC.IFSEQNO = (	--가장 최신번호(높은숫자)로 설정필요. 근 2개월 치 들어옴 (G-PSI 재고/실적 업데이트 구간 및 주기 확인필요) 
										SELECT	MAX(IFSEQNO)
										FROM	XIF_ERP_SALES_RESULT_R_SN WITH(NOLOCK)
										WHERE	1=1
										AND		DIVISION_ID = @V_DIVISION_ID --해당 DIVISION 정보 (JV 포함되어야)
										AND		ATTRIBUTE1 IN ( SELECT FCST_TYPE
			                                                    FROM   #TMP_AS_SALES_TYPE_CODE )  -- 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경
										)
					UNION ALL
					SELECT 'XXXX' SHIPTO_CODE
				) SC
		WHERE	1=1
		;

		SELECT SR.ITEM_ID
			  ,ISNULL(SR.FROM_SCM_SITE_ID, '-')	AS FROM_SITE
			  ,SR.TO_SCM_SITE_ID	AS TO_SITE
			  ,TS.SITE_TYPE			AS TO_SITE_TYPE 
			  ,TS.OPERATION_GROUP	AS TO_SITE_OPERATION_GROUP
			  ,SR.INCOTERMS			
			  ,SR.TRANSPORT_MODE
			  ,SR.EXFACTORY_DATE	AS EXFACTORY_YYYYMMDD
			  ,SR.EXFACTORY_QTY	
			  ,FI.OPERATION_GROUP
		 INTO #SHIPMENT_RESULT
		 FROM SCM_DNM_EXFACTORY_RESULT SR WITH(NOLOCK)
			  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID		= SR.ITEM_ID
			  INNER JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					  ON TS.SCM_SITE_ID = SR.TO_SCM_SITE_ID 
		WHERE 1=1
	 	  AND SR.EXFACTORY_DATE  >= @V_RESULT_FROM_YYYYMMDD 
		  AND SR.EXFACTORY_DATE  <  @V_PLAN_START_YYYYMMDD
		  AND SR.DIVISION_ID	  = @V_DIVISION_ID
		  AND SR.EXFACTORY_STATUS IN ('D20','D30','D40')
		    --AND SR.SSP_TYPE IN  --N국간거래 따른 중복값 제거 (SHIP FG 값통일)
		  AND EXISTS
							(
								SELECT DISTINCT SEGMENT1
								FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] LD
								WHERE 1=1
								AND LD.LOOKUP_TYPE = 'ERP_SSP_TYPE'
								AND LD.VALID_YN ='Y'
								--AND LD.SEGMENT1 = SR.SSP_TYPE
								AND ( LD.SEGMENT1 = SR.SSP_TYPE OR SR.SSP_TYPE IS NULL )
							)
		  
		
		--  AND SR.SHIPTO_CODE NOT IN --WS 출하 정보 제외 (매출 실적기반으로 하는수 밖에없음)
		  AND NOT EXISTS
							(
								SELECT SHIPTO_CODE FROM #SHIPTO_CODE SC
								WHERE	1=1
								AND SC.SHIPTO_CODE = SR.SHIPTO_CODE
								/*
								SELECT DISTINCT SHIPTO_CODE
								FROM XIF_ERP_SALES_RESULT_R_SN SC WITH(NOLOCK)
								WHERE 1=1
								AND		SC.DIVISION_ID = @V_DIVISION_ID --해당 DIVISION 정보 (JV 포함되어야)
								AND		SC.ATTRIBUTE1 = 'WS'
								AND		SC.IFSEQNO = (	--가장 최신번호(높은숫자)로 설정필요. 근 2개월 치 들어옴 (G-PSI 재고/실적 업데이트 구간 및 주기 확인필요) 
													SELECT	MAX(IFSEQNO)
													FROM	XIF_ERP_SALES_RESULT_R_SN WITH(NOLOCK)
													WHERE	1=1
													AND		DIVISION_ID = @V_DIVISION_ID --해당 DIVISION 정보 (JV 포함되어야)
													AND		ATTRIBUTE1 = 'WS'
													)
								AND SC.SHIPTO_CODE = SR.SHIPTO_CODE
								*/
							)
			


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : 출하 실적 Measure 추가' 
		-----------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT SR.OPERATION_GROUP 
			  ,SR.ITEM_ID
			  ,ISNULL(SR.TO_SITE,'-')			AS TO_SITE
			  ,ISNULL(SR.INCOTERMS,'-')			AS INCOTERMS
			  ,SR.FROM_SITE
			  ,ISNULL(SR.TRANSPORT_MODE,'-')	AS TRANSPORT_MODE_LINE
			  ,DI.YYYYPW
			  ,'SHIP_PLAN'			AS MEASURE
			  ,'N'					AS IS_CELL_IN_PACK_PLANT
			  ,0.0					AS FROM_BOH_QTY
			  ,0.0					AS TO_BOH_QTY
			  ,SUM(EXFACTORY_QTY)	AS QTY
		  FROM #SHIPMENT_RESULT SR WITH(NOLOCK)
				INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
						ON DI.YYYYMMDD = SR.EXFACTORY_YYYYMMDD
		 WHERE 1=1
		 GROUP BY SR.OPERATION_GROUP 
				 ,SR.ITEM_ID
				 ,ISNULL(SR.TO_SITE,'-')
				 ,ISNULL(SR.INCOTERMS,'-')
				 ,SR.FROM_SITE
				 ,ISNULL(SR.TRANSPORT_MODE,'-')	
				 ,DI.YYYYPW


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : 도착 실적 SEMI (to Plant Site WH In) - Raw데이터' 
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#WH_IN_SEMI_RESULT') IS NOT NULL
			DROP TABLE #WH_IN_SEMI_RESULT;

		SELECT D.DIVISION_ID
			  ,D.ITEM_ID
			  ,S.TO_SCM_SITE_ID		AS TO_SITE
			  ,D.INCOTERMS
			  ,S.FROM_SCM_SITE_ID	AS FROM_SITE
			  ,D.DOC_POSTING_DATE
			  ,D.QTY
		 INTO #WH_IN_SEMI_RESULT
		FROM (
					SELECT	DIVISION_ID, COMPANY_ID_PURCH
							, CASE WHEN COMPANY_ID_SALES = @v_COMPANY_SALES THEN @v_ESOC	--NERP 적용여부에 따라 위 코드 살림
								   ELSE COMPANY_ID_SALES
							  END COMPANY_ID_SALES_CONV
							, PLANT_ID, ITEM_ID, INCOTERMS, DOC_POSTING_DATE, VALID_YN, MAT_DOC_ID
							, PO_NO, PO_ITEM_SEQ, ORIGIN_ITEM_ID
							, MAX(QTY) QTY
					FROM	SCM_DNM_INTRANSIT_CO_DETAIL D WITH(NOLOCK) 
					WHERE	1=1
					  AND   D.DIVISION_ID	     = @V_DIVISION_ID
					  AND   D.DOC_TYPE			 = 'GR'				-- Good Receipt (입고 정보) 
					  AND   D.DOC_POSTING_DATE   >= @V_RESULT_FROM_YYYYMMDD 
					  AND   D.DOC_POSTING_DATE   <  @V_PLAN_START_YYYYMMDD
					GROUP BY  DIVISION_ID, COMPANY_ID_PURCH
							  , CASE WHEN COMPANY_ID_SALES = @v_COMPANY_SALES THEN @v_ESOC	--NERP 적용여부에 따라 위 코드 살림
									 ELSE COMPANY_ID_SALES
								END
							 , PLANT_ID, ITEM_ID, INCOTERMS, DOC_POSTING_DATE, VALID_YN, TRANSPORT_MODE, MAT_DOC_ID
							 , PO_NO, PO_ITEM_SEQ, ORIGIN_ITEM_ID
			  ) D
			  INNER JOIN SCM_DNM_INTRANSIT_CO_SUMMARY S WITH(NOLOCK)
					  ON S.DIVISION_ID		= D.DIVISION_ID
					 AND S.COMPANY_ID_PURCH	= D.COMPANY_ID_PURCH
					 AND S.COMPANY_ID_SALES	= D.COMPANY_ID_SALES_CONV --D.COMPANY_ID_SALES
					 AND S.PO_NO			= D.PO_NO
					 AND S.PO_ITEM_SEQ		= D.PO_ITEM_SEQ
					 AND S.ITEM_ID			= D.ITEM_ID
					 AND S.ORIGIN_ITEM_ID	= D.ORIGIN_ITEM_ID
			  INNER JOIN #SCM_MST_SITE T WITH(NOLOCK)
					  ON T.SCM_SITE_ID	= S.TO_SCM_SITE_ID
					 AND T.SITE_TYPE	= 'PLANT'
		--WHERE 1=1
		--  AND D.DIVISION_ID			= @V_DIVISION_ID  
		--  AND D.DOC_TYPE			= 'GR'		-- Good Receipt (입고 정보) 
		--  AND D.DOC_POSTING_DATE   >= @V_RESULT_FROM_YYYYMMDD 
		--  AND D.DOC_POSTING_DATE   <  @V_PLAN_START_YYYYMMDD

		INSERT INTO #WH_IN_SEMI_RESULT
		SELECT D.DIVISION_ID
			  ,D.ITEM_ID
			  ,'ESST_CA_WND'		AS TO_SITE
			  ,D.INCOTERMS
			  ,S.FROM_SCM_SITE_ID	AS FROM_SITE
			  ,D.DOC_POSTING_DATE
			  ,D.QTY
		FROM (
					SELECT	DIVISION_ID, COMPANY_ID_PURCH
							, CASE WHEN COMPANY_ID_SALES = @v_COMPANY_SALES THEN @v_ESOC	--NERP 적용여부에 따라 위 코드 살림
								   ELSE COMPANY_ID_SALES
							  END COMPANY_ID_SALES_CONV
							, PLANT_ID, ITEM_ID, INCOTERMS, DOC_POSTING_DATE, VALID_YN, MAT_DOC_ID
							, PO_NO, PO_ITEM_SEQ, ORIGIN_ITEM_ID
							, MAX(QTY) QTY
					FROM	SCM_DNM_INTRANSIT_CO_DETAIL D WITH(NOLOCK) 
					WHERE	1=(CASE WHEN @V_DIVISION_ID = '81' THEN 1 ELSE 0 END)
					  AND   D.DIVISION_ID	     = @V_DIVISION_ID
					  AND   D.DOC_TYPE			 = 'GR'				-- Good Receipt (입고 정보) 
					  AND   D.DOC_POSTING_DATE   >= @V_RESULT_FROM_YYYYMMDD 
					  AND   D.DOC_POSTING_DATE   <  @V_PLAN_START_YYYYMMDD
					  AND   D.ITEM_ID				LIKE 'ACEH1131I-B1%'
					GROUP BY  DIVISION_ID, COMPANY_ID_PURCH
							  , CASE WHEN COMPANY_ID_SALES = @v_COMPANY_SALES THEN @v_ESOC	--NERP 적용여부에 따라 위 코드 살림
									 ELSE COMPANY_ID_SALES
								END
							 , PLANT_ID, ITEM_ID, INCOTERMS, DOC_POSTING_DATE, VALID_YN, TRANSPORT_MODE, MAT_DOC_ID
							 , PO_NO, PO_ITEM_SEQ, ORIGIN_ITEM_ID
			  ) D
			  INNER JOIN SCM_DNM_INTRANSIT_CO_SUMMARY S WITH(NOLOCK)
					  ON S.DIVISION_ID		= D.DIVISION_ID
					 AND S.COMPANY_ID_PURCH	= D.COMPANY_ID_PURCH
					 AND S.COMPANY_ID_SALES	= D.COMPANY_ID_SALES_CONV --D.COMPANY_ID_SALES
					 AND S.PO_NO			= D.PO_NO
					 AND S.PO_ITEM_SEQ		= D.PO_ITEM_SEQ
					 AND S.ITEM_ID			= D.ITEM_ID
					 AND S.ORIGIN_ITEM_ID	= D.ORIGIN_ITEM_ID
					 AND S.TO_SCM_SITE_ID LIKE 'G82%'
				;

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : 도착 실적 SEMI (to Plant Site WH In) measure추가' 
		-----------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT  FI.OPERATION_GROUP
			   ,WR.ITEM_ID
			   ,WR.TO_SITE
			   ,WR.INCOTERMS
			   ,WR.FROM_SITE
			   ,'-'			AS TRANSPORT_MODE
			   ,DI.YYYYPW
			   ,'WH_IN'		AS MEASURE
			   ,'N'			AS IS_CELL_INVENTORY
			   ,0.0			AS FROM_BOH_QTY
			   ,0.0			AS TO_BOH_QTY
			   ,SUM(QTY)	AS QTY
		 FROM #WH_IN_SEMI_RESULT WR WITH(NOLOCK)
			  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
						ON DI.YYYYMMDD = WR.DOC_POSTING_DATE
			  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID		= WR.ITEM_ID
		WHERE 1=1
		GROUP BY
				FI.OPERATION_GROUP
			   ,WR.ITEM_ID
			   ,WR.TO_SITE
			   ,WR.INCOTERMS
			   ,WR.FROM_SITE
			   ,DI.YYYYPW


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : 도착 실적 FG (to Sales Site WH In) measure추가' 
		-----------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT  RR.OPERATION_GROUP
			   ,RR.ITEM_ID
			   ,RR.TO_SITE
			   ,RR.INCOTERMS
			   ,RR.FROM_SITE
			   ,'-'			AS TRANSPORT_MODE
			   ,RR.YYYYPW
			   ,'WH_IN'		AS MEASURE
			   ,'N'			AS IS_CELL_INVENTORY
			   ,0.0			AS FROM_BOH_QTY
			   ,0.0			AS TO_BOH_QTY
			   ,SUM(QTY)	AS QTY
		 FROM #FCST_RTF_RESULT	RR WITH(NOLOCK)
			  INNER JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					  ON TS.SCM_SITE_ID	= RR.TO_SITE
					 AND TS.SITE_TYPE	= 'SALES'
		WHERE 1=1
		  AND RR.MEASURE = 'RTF'
		GROUP BY
				RR.OPERATION_GROUP
			   ,RR.ITEM_ID
			   ,RR.TO_SITE
			   ,RR.INCOTERMS
			   ,RR.FROM_SITE
			   ,RR.YYYYPW							 
----- End : Ending Inventory (과거 실적 구간 재고) @@@위치 옮김
----- End : Ending Inventory (과거 실적 구간 재고) @@@위치 옮김
			  
		 
		
		


		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : (SIMUL) Form. End Eta (Prod) Raw 데이터 '
		-- CELL_PROD_FORM_END : Form. End Eta (Prod) : 생산LT를 적용한 생산 수량
		----------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_PROD_FORM_END_RAW') IS NOT NULL
			DROP TABLE #CELL_PROD_FORM_END_RAW;

		SELECT PG.OPERATION_GROUP
			  ,PG.ITEM_ID
			  ,PG.FROM_SITE
			  ,PG.YYYYMMDD		AS YYYYMMDD_ORG
			  ,PG.TRANSPORT_MODE_LINE
			  ,PG.QTY
			  ,FR.LT_DAY
			  ,CONVERT(NVARCHAR(8), DATEADD(DAY, ISNULL(FR.LT_DAY,0), CONVERT(DATE, PG.YYYYMMDD, 112)),112) AS YYYYMMDD
		 INTO #CELL_PROD_FORM_END_RAW
		 FROM #SCP_ANL_PSI_GLOBAL PG WITH(NOLOCK)
			  INNER JOIN #TMP_DATE_INFO DI
					  ON 1=1
					 AND PG.YYYYMMDD = DI.YYYYMMDD
			  LEFT  JOIN  #SCP_MST_FORMATION FR with(nolock)
					  ON FR.PLANT_SITE_ID	= PG.FROM_SITE
					 AND FR.ITEM_ID			= PG.ITEM_ID
					 AND FR.YYYYPW			= DI.YYYYPW
		WHERE 1=1
		  AND PG.MEASURE				= 'PRODUCTION'
		  AND PG.OPERATION_GROUP		= 'A'
		
		 
		-- start 기준 이전의 실적수량 포함	-- 고도화 
		INSERT INTO #CELL_PROD_FORM_END_RAW  
		SELECT	 B.SCP_OPERATION_GROUP AS OPERATION_GROUP
				,A.ITEM_ID
				,FS.SCM_SITE_ID			AS FROM_SITE   
				,CONVERT(NVARCHAR(8), A.PLAN_DATE, 112)	AS  YYYYMMDD_ORG
				,A.LINE_ID AS TRANSPORT_MODE_LINE
				,A.QTY
				,FR.LT_DAY
				,CONVERT(NVARCHAR(8), DATEADD(DAY, ISNULL(FR.LT_DAY,0), CONVERT(DATE, A.PLAN_DATE, 112)),112) AS YYYYMMDD
		FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A WITH(NOLOCK) -- SCM_DNM_DAILY_PRODUCT_RESULT_SN
				INNER JOIN #TMP_DATE_INFO DI
						ON 1=1
					   AND CONVERT(NVARCHAR,A.PLAN_DATE,112) = DI.YYYYMMDD
				INNER JOIN SCM_MST_ITEM_SN  B WITH(NOLOCK)	 -- SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) 
						ON B.COMPANY_ID		= A.COMPANY_ID
						AND B.DIVISION_ID		= A.DIVISION_ID
						AND B.SITE_ID			= A.SITE_ID
						AND B.ITEM_ID			= A.ITEM_ID
						AND B.SCP_OPERATION_GROUP IS NOT NULL	 -- SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) 
						AND B.SCP_OPERATION_GROUP IN ('A') -- CELL/PACK만 
				LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)
						ON FS.PLANT_ID		= A.PLANT_ID
						AND FS.OPERATION_GROUP	= B.SCP_OPERATION_GROUP
						AND FS.SITE_TYPE		= 'PLANT'
						AND FS.VALID_YN		= 'Y'
				LEFT  JOIN  #SCP_MST_FORMATION FR WITH(NOLOCK)
						ON FR.PLANT_SITE_ID	= FS.SCM_SITE_ID
						AND FR.ITEM_ID		= A.ITEM_ID
						AND FR.YYYYPW		= DI.YYYYPW
		WHERE 1=1
			AND A.DIVISION_ID	 = @V_DIVISION_ID	
			AND A.PLAN_DATE		>= SUBSTRING(@V_PLAN_START_YYYYMMDD,1,6) + '01' 
			AND A.PLAN_DATE		<  @V_PLAN_START_DATE
			AND A.PRODUCTION_TYPE     NOT IN ('REWORK', 'PILOT')	-- SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) 
			AND A.OPERATION_ID IN (SELECT OPERATION_ID FROM #PRODUCTION_OPERATION) 
			AND OPERATION_ID != 'F6000' -- 셀 특성 제외 

		  
		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : (SIMUL) Form. End Eta (Prod) Measure 추가 '
		-- CELL_PROD_FORM_END : Form. End Eta (Prod) : 생산LT를 적용한 생산 수량
		-- asis global psi의 production 정보는 빈날짜 0으로 채워진 정보임
		----------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_PROD_FORM_END_LINE') IS NOT NULL
			DROP TABLE #CELL_PROD_FORM_END_LINE;
		IF OBJECT_ID('TEMPDB..#CELL_PROD_FORM_END') IS NOT NULL
			DROP TABLE #CELL_PROD_FORM_END;

		SELECT PF.OPERATION_GROUP
			 , PF.ITEM_ID
			 , PF.FROM_SITE
			 , PF.TRANSPORT_MODE_LINE
			 , DI.YYYYPW
			 , SUM(PF.QTY)		AS QTY
		INTO #CELL_PROD_FORM_END_LINE
		FROM #CELL_PROD_FORM_END_RAW PF WITH(NOLOCK)
			 INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					  ON DI.YYYYMMDD = PF.YYYYMMDD 
		WHERE 1=1
		GROUP BY 
		       PF.OPERATION_GROUP
			 , PF.ITEM_ID
			 , PF.FROM_SITE
			 , PF.TRANSPORT_MODE_LINE
			 , DI.YYYYPW
				
		-- 데이터 검증시 확인을 위해 measure 추가 (UI 노출 대상아님) 
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT PF.OPERATION_GROUP
			 , PF.ITEM_ID
			 , '-'	AS TO_SITE
			 , '-'	AS INCOTERMS
			 , PF.FROM_SITE
			 , PF.TRANSPORT_MODE_LINE
			 , PF.YYYYPW
			 , 'CELL_PROD_FORM_END'	AS MEASURE
			 , 'N'	AS IS_CELL_IN_PACK_PLANT 
			 , 0.0	AS FROM_BOH_QTY
			 , 0.0	AS TO_BOH_QTY
			 , PF.QTY
		  FROM #CELL_PROD_FORM_END_LINE PF WITH(NOLOCK) 
		WHERE 1=1

		-----------------------------------------------------------
		-- #CELL_PROD_FORM_END for Cell. Available/ Form. Progress
		-----------------------------------------------------------
		SELECT PF.OPERATION_GROUP
			  ,PF.ITEM_ID
			  ,PF.FROM_SITE
			  ,PF.YYYYPW
			  ,SUM(PF.QTY)	AS QTY
		INTO #CELL_PROD_FORM_END
		FROM #CELL_PROD_FORM_END_LINE PF WITH(NOLOCK) 
		WHERE 1=1
		GROUP BY 
			   PF.OPERATION_GROUP
			  ,PF.ITEM_ID
			  ,PF.FROM_SITE
			  ,PF.YYYYPW


		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : (SIMUL) Form. End Eta (Past) Daily '
		-- CELL_FOR_FORM_END : Form. End Eta (Past) : TH_ENG_STOCK_PLAN_SN에서 보류 수량을 포함한 해당일 수량
		------------------------------------------------------------------------------------------------------------- 
		IF OBJECT_ID('TEMPDB..#FOR_FORM_END_DAILY') IS NOT NULL
			DROP TABLE #FOR_FORM_END_DAILY;

		SELECT SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~', ES.SITE_ID)-1)	AS FROM_SITE
              ,ES.ITEM_ID                                 
              ,ES.YYYYMMDD
              ,SUM(ISNULL(ES.QTY,0))									AS QTY  
		 INTO #FOR_FORM_END_DAILY
		 FROM #SCP_PLN_TH_ENG_STOCK_PLAN ES WITH(NOLOCK)                   
        WHERE 1 = 1           
          AND ES.DESCR LIKE 'FOR%'
         GROUP BY                          
			   SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~', ES.SITE_ID)-1)
              ,ES.ITEM_ID                                 
             ,ES.YYYYMMDD
 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : (SIMUL) Form. End Eta (Past) Weekly '
		-- CELL_FOR_FORM_END : Form. End Eta (Past) : TH_ENG_STOCK_PLAN_SN에서 보류 수량을 포함한 해당일 수량
		------------------------------------------------------------------------------------------------------------- 
		IF OBJECT_ID('TEMPDB..#FOR_FORM_END_WEEKLY') IS NOT NULL
			DROP TABLE #FOR_FORM_END_WEEKLY;

		SELECT FI.OPERATION_GROUP
			  ,FE.ITEM_ID
			  ,FE.FROM_SITE
			  ,DI.YYYYPW
			  ,SUM(FE.QTY)	AS QTY
		 INTO #FOR_FORM_END_WEEKLY
		 FROM #FOR_FORM_END_DAILY FE WITH(NOLOCK)
			  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID = FE.ITEM_ID
			  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					  ON DI.YYYYMMDD = FE.YYYYMMDD 
		WHERE 1=1
		GROUP BY 
			   FI.OPERATION_GROUP
			  ,FE.ITEM_ID
			  ,FE.FROM_SITE
			  ,DI.YYYYPW


		--------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : (SIMUL) Form. End Eta (Past) Weekly - 빈주차 0채움'
		-- CELL_FOR_FORM_END : Form. End Eta (Past) : TH_ENG_STOCK_PLAN_SN에서 보류 수량을 포함한 해당일 수량
		----------------------------------------------------------------------------------------------------------------------- 
		IF OBJECT_ID('TEMPDB..#CELL_FOR_FORM_END') IS NOT NULL
			DROP TABLE #CELL_FOR_FORM_END;

		SELECT FE.OPERATION_GROUP
			  ,FE.ITEM_ID
			  ,FE.FROM_SITE
			  ,WL.YYYYPW
			  ,SUM(CASE WHEN FE.YYYYPW = WL.YYYYPW THEN FE.QTY ELSE 0 END) AS QTY 
		 INTO #CELL_FOR_FORM_END
		 FROM #FOR_FORM_END_WEEKLY FE
			  INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					  ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
		WHERE 1=1
		GROUP BY 
			   FE.OPERATION_GROUP
			  ,FE.ITEM_ID
			  ,FE.FROM_SITE
			  ,WL.YYYYPW
		
		-- 데이터 검증시 확인을 위해 measure 추가 (UI 노출 대상아님) 
		-- 빈날짜 채우기 전 (0인 데이터 제외) 
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT PF.OPERATION_GROUP
			 , PF.ITEM_ID
			 , '-'	AS TO_SITE
			 , '-'	AS INCOTERMS
			 , PF.FROM_SITE
			 , '-'	AS VARIOUS_KEY
			 , PF.YYYYPW
			 , 'CELL_FOR_FORM_END'	AS MEASURE
			 , 'N'	AS IS_CELL_IN_PACK_PLANT 
			 , 0.0	AS FROM_BOH_QTY
			 , 0.0	AS TO_BOH_QTY
			 , PF.QTY
		  FROM #FOR_FORM_END_WEEKLY PF WITH(NOLOCK) 
		WHERE 1=1


		-----------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Char. Plan  measure 추가 (임시) '
		-- 2023.11.22 추가 요구사항  
		--  (Form. End Eta (Past) + Form. End Eta (Prod))*Yield 
		--  특성 가용한(Char.Available) 재고를 전부 특성 계획을 친다는 조건
		--  Char. Available : Char. Plan에서 다 빼먹었으므로, ‘0’ 될 것으로 판단 
		-- * 향후 Simulator Char. Plan 저장값이 FN에 확정계획으로 반영될 시 현재 산식기준 (asis global psi activate_completed) 으로 원복
		-----------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_CHAR_PLAN_FUTURE') IS NOT NULL
			DROP TABLE #CELL_CHAR_PLAN_FUTURE;

		;WITH CELL_CHAR_PLAN_SRC AS (
			-- CELL_FOR_FORM_END : Form. End Eta (Past) 
			SELECT FF.OPERATION_GROUP
				  ,FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYPW
				  ,FF.QTY
			 FROM #CELL_FOR_FORM_END FF
			WHERE 1=1
			UNION ALL
			-- CELL_PROD_FORM_END : From. End Eta (Prod)
			SELECT FF.OPERATION_GROUP
				  ,FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYPW
				  ,FF.QTY
			 FROM #CELL_PROD_FORM_END FF
			WHERE 1=1
		)
		SELECT CP.OPERATION_GROUP
			  ,CP.ITEM_ID
			  ,'-'						AS TO_SITE 
			  ,'-'						AS INCOTERMS
			  ,CP.FROM_SITE
			  ,'-'						AS VARIOUS_KEY
			  ,CP.YYYYPW
			  ,'CELL_CHAR_PLAN'	AS MEASURE 
			  ,'N'						AS IS_CELL_IN_PACK_PLANT
			  ,0.0						AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,SUM(QTY) 
				* CASE WHEN ISNULL(FY.SSP_MODIFY_YIELD, 0) > 0		THEN FY.SSP_MODIFY_YIELD
					   WHEN ISNULL(FY.FORMATION_TOTAL_YIELD, 0) > 0	THEN FY.FORMATION_TOTAL_YIELD
					   ELSE 1
				   END AS QTY
		 INTO #CELL_CHAR_PLAN_FUTURE
		 FROM CELL_CHAR_PLAN_SRC CP 
			  LEFT JOIN #SCP_MST_FORMATION FY WITH(NOLOCK)
					 ON FY.PLANT_SITE_ID	= CP.FROM_SITE
					AND FY.ITEM_ID			= CP.ITEM_ID
					AND FY.YYYYPW			= CP.YYYYPW
		WHERE 1=1 
		GROUP BY 
			   CP.OPERATION_GROUP
			  ,CP.ITEM_ID
			  ,CP.FROM_SITE
			  ,CP.YYYYPW
			  ,CASE WHEN ISNULL(FY.SSP_MODIFY_YIELD, 0) > 0			THEN FY.SSP_MODIFY_YIELD
					WHEN ISNULL(FY.FORMATION_TOTAL_YIELD, 0) > 0	THEN FY.FORMATION_TOTAL_YIELD
					ELSE 1
			 END


		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Char. Plan  measure 추가 (임시) - insert '
		----------------------------------------------------------------------------------------------------------
		--INSERT INTO #TMP_ASIS_GLOBAL_PSI
		--SELECT *
		-- FROM #CELL_CHAR_PLAN_FUTURE



-- begin : 미래구간 cell inventory (CELL_EOH) 
-- begin : 미래구간 cell inventory (CELL_EOH) 
		-----------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 (임시) '
		-- 아래와 같이 Char. Plan이 변경됨으로 인해 계획구간 Cell Inventory 산식(시뮬레이터)에 의해 재계산 
		-- Cell Invnentory = CELL_BOH(Cell BOH) 
		--						 - CELL_SHIP_PLAN_TOTAL(Cell Ship Plan(Sum)) 
		--						 + CELL_CHAR_PLAN(Char. Plan) 
		--						 + CELL_FORM_HOLD_AFTER(After Form. Hold Release)
		-- 2023.11.22 Char. Plan 에 대한 추가 요구사항  
		--  (Form. End Eta (Past) + Form. End Eta (Prod))*Yield 
		--  특성 가용한(Char.Available) 재고를 전부 특성 계획을 친다는 조건
		--  Char. Available : Char. Plan에서 다 빼먹었으므로, ‘0’ 될 것으로 판단 
		-- * 향후 Simulator Char. Plan 저장값이 FN에 확정계획으로 반영될 시 현재 산식기준 (asis global psi activate_completed) 으로 원복
		-----------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 - CELL_BOH '
		-----------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_BOH_FOR_FUTURE') IS NOT NULL
			DROP TABLE #CELL_BOH_FOR_FUTURE;
		/*
		SELECT ES.ITEM_ID
			  ,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)  AS FROM_SITE
			  ,SUM(ES.QTY) AS QTY 
		 INTO #CELL_BOH_FOR_FUTURE
		 FROM #SCP_PLN_TH_ENG_STOCK_PLAN  ES WITH(NOLOCK)  
			  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID = ES.ITEM_ID
					 AND FI.OPERATION_GROUP = 'A'
		WHERE 1=1
		  AND ES.LOT_ID		LIKE 'WH:%'
		  AND ES.SITE_ID	LIKE '%A~%' -- cell 사이트 
		GROUP BY ES.ITEM_ID
				,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)
		*/
		
		--@@@ BOH 기준 변경
		SELECT   SO.ITEM_ID
				,SO.FROM_SITE 		AS FROM_SITE
				,SUM(SO.YYYYMM_PRVS_QTY)		AS QTY
		INTO #CELL_BOH_FOR_FUTURE
		FROM #TMP_ENDING_INV_MM_WW SO WITH(NOLOCK)
		WHERE 1=1
		AND SO.YYYYPW 	< @V_PLAN_START_YYYYPW  -- 과거 실적 구간  
		AND SO.MEASURE	= 'CELL_EOH'
		AND SO.OPERATION_GROUP = 'A'	-- cell 사이트
		GROUP BY SO.ITEM_ID, SO.FROM_SITE
		;


		/*
		-- 2024.01.18 변경전  
		-----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 - CELL_FORM_HOLD_AFTER '
		-----------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_FORM_HOLD_AFTER') IS NOT NULL
			DROP TABLE #CELL_FORM_HOLD_AFTER;

		;WITH CELL_FORM_HOLD_AFTER AS (
			SELECT ES.ITEM_ID
				  ,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)  AS FROM_SITE
				  ,DI.YYYYPW
				  ,SUM(ES.QTY) AS QTY   
			 FROM #SCP_PLN_TH_ENG_STOCK_PLAN  ES WITH(NOLOCK) 
				  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
						  ON DI.YYYYMMDD = ES.YYYYMMDD
				  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						  ON FI.ITEM_ID			= ES.ITEM_ID
						 AND FI.OPERATION_GROUP = 'A'
			WHERE 1=1
			  AND ES.LOT_ID		LIKE 'WH_HOLD%'
			  AND ES.SITE_ID	LIKE '%A~%' -- cell 사이트 
			GROUP BY ES.ITEM_ID
					,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)
					,DI.YYYYPW
		)
		SELECT FH.FROM_SITE
			  ,FH.ITEM_ID
			  ,WL.YYYYPW
			  ,SUM(CASE WHEN FH.YYYYPW = WL.YYYYPW THEN FH.QTY ELSE 0 END) AS QTY 
		 INTO #CELL_FORM_HOLD_AFTER
		 FROM CELL_FORM_HOLD_AFTER FH WITH(NOLOCK)
			  INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					  ON WL.YYYYPW >= @V_PLAN_START_YYYYPW --  미래 구간
		WHERE 1=1
		GROUP BY FH.FROM_SITE
				,FH.ITEM_ID
				,WL.YYYYPW
		*/

		-----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 - CELL_SHIP_PLAN_TOTAL '
		-----------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_SHIP_PLAN_TOTAL') IS NOT NULL
			DROP TABLE #CELL_SHIP_PLAN_TOTAL;

			SELECT PG.OPERATION_GROUP
				  ,PG.ITEM_ID
				  ,PG.FROM_SITE
				  ,PG.YYYYPW
				  ,SUM(QTY)	AS QTY 
			 INTO #CELL_SHIP_PLAN_TOTAL
			 FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK)
			WHERE 1=1
			  AND PG.MEASURE IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN') -- 
			  AND PG.OPERATION_GROUP = 'A'					
			  AND PG.YYYYPW >= @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			GROUP BY
				   PG.OPERATION_GROUP
				  ,PG.ITEM_ID
				  ,PG.FROM_SITE
				  ,PG.YYYYPW


		-----------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산'
		-- 아래와 같이 Char. Plan이 변경됨으로 인해 계획구간 Cell Inventory 산식(시뮬레이터)에 의해 재계산 
		-- Cell Invnentory = CELL_BOH(Cell BOH) 
		--						 - CELL_SHIP_PLAN_TOTAL(Cell Ship Plan(Sum)) 
		--						 + CELL_CHAR_PLAN(Char. Plan) 
		--						 + CELL_FORM_HOLD_AFTER(After Form. Hold Release)
		-----------------------------------------------------------------------------------------------------------------------------------

		DELETE -- ASIS global psi 셀공장 삭제  
		 FROM #TMP_ASIS_GLOBAL_PSI 
		WHERE MEASURE				= 'MODEL_INVENTORY'
		  AND OPERATION_GROUP		= 'A'
		  AND IS_CELL_IN_PACK_PLANT	= 'N'

		;WITH CELL_INVENTORY_SRC AS (
			-- CELL_BOH (전구간 기초재고로 사용) 
			SELECT BH.FROM_SITE
				  ,BH.ITEM_ID
				  ,PW.YYYYPW
				  ,SUM(BH.QTY) AS BOH_QTY 
				  ,SUM(BH.QTY) AS QTY 
			 FROM #CELL_BOH_FOR_FUTURE BH WITH(NOLOCK)
				  INNER JOIN #TMP_PW_LIST PW WITH(NOLOCK)
						  ON PW.YYYYPW >=  @V_PLAN_START_YYYYPW --  미래 구간
			WHERE 1=1
			GROUP BY BH.FROM_SITE
					,BH.ITEM_ID
					,PW.YYYYPW
			UNION ALL 
			-- 2024.01.18 HOLD 재고 가용일과 상관 없이 기초재고로 모두 반영 
			SELECT BH.FROM_SITE
				  ,BH.ITEM_ID
				  ,ML.YYYYPW
				  ,SUM(BH.WH_HOLD_QTY) AS BOH_QTY 
				  ,SUM(BH.WH_HOLD_QTY) AS QTY 
			 FROM #WH_HOLD BH WITH(NOLOCK)
				  INNER JOIN #TMP_PW_LIST ML WITH(NOLOCK)
						  ON ML.YYYYPW >=  @V_PLAN_START_YYYYPW --  미래 구간
			WHERE 1=1
			  AND BH.FROM_SITE	 LIKE '%A'	-- Cell 사이트 / 셀재고 ?
			GROUP BY BH.FROM_SITE
					,BH.ITEM_ID
					,ML.YYYYPW
			/* 2024.01.18 변경전  
			-- CELL_FORM_HOLD_AFTER 
			SELECT FH.FROM_SITE
				  ,FH.ITEM_ID
				  ,FH.YYYYPW
				  ,0	 AS BOH_QTY 
				  ,SUM(FH.QTY) OVER (PARTITION BY FH.FROM_SITE
												, FH.ITEM_ID
										 ORDER BY FH.YYYYPW) AS QTY 
			 FROM #CELL_FORM_HOLD_AFTER FH WITH(NOLOCK) 
			*/
			UNION ALL 
			-- CELL_SHIP_PLAN_TOTAL 
			SELECT SP.FROM_SITE
				  ,SP.ITEM_ID
				  ,SP.YYYYPW
				  ,0	 AS BOH_QTY 
				  ,(-1) * SUM(SP.QTY) OVER (PARTITION BY SP.FROM_SITE
													   , SP.ITEM_ID
												ORDER BY SP.YYYYPW) AS QTY 
			 FROM #CELL_SHIP_PLAN_TOTAL SP
			UNION ALL 
			 -- CELL_CHAR_PLAN_FUTURE 
			SELECT CP.FROM_SITE
				  ,CP.ITEM_ID
				  ,CP.YYYYPW
				  ,0	 AS BOH_QTY 
				  ,SUM(CP.QTY) OVER (PARTITION BY CP.FROM_SITE
												, CP.ITEM_ID
										 ORDER BY CP.YYYYPW) AS QTY 
			 FROM #CELL_CHAR_PLAN_FUTURE CP
		)
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT 'A'				AS OPERATION_GROUP 
			  ,ISNULL(CA.ITEM_ID_ASSY, CI.ITEM_ID)	AS ITEM_ID 
			  ,'-'				AS TO_SITE 
			  ,'-'				AS INCOTERMS
			  ,CI.FROM_SITE
			  ,'-'				AS VARIOUS_KEY
			  ,CI.YYYYPW
			  ,'CELL_EOH'		AS MEASURE 
			  ,'N'				AS IS_CELL_IN_PACK_PLANT
			  ,SUM(CI.BOH_QTY)	AS FROM_BOH_QTY
			  ,0.0				AS TO_BOH_QTY
			  ,SUM(CI.QTY)		AS QTY 
		 FROM CELL_INVENTORY_SRC  CI 
			  LEFT JOIN #SCM_MST_SITE FS 
					 ON FS.SCM_SITE_ID			= CI.FROM_SITE
			  LEFT JOIN #CELL_PROD_ASSY_MAP CA	-- CP를 CA로 치환 적용 20240118
					 ON CA.PLANT_ID				= FS.PLANT_ID
					AND CA.ITEM_ID_PROD			= CI.ITEM_ID
					AND CA.ASSY_PRIORITY_1ST	= 1
		GROUP BY CI.FROM_SITE
			    ,ISNULL(CA.ITEM_ID_ASSY, CI.ITEM_ID)
				,CI.YYYYPW

-- end : 미래구간 cell inventory (CELL_EOH) 
-- end : 미래구간 cell inventory (CELL_EOH) 


-- Begin : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) 
-- Begin : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) 
		--------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Char. Available - Char. Plan  수율 적용 '
		--------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_CHAR_PLAN_YIELD') IS NOT NULL
			DROP TABLE #CELL_CHAR_PLAN_YIELD;

		;WITH CHAR_PLAN AS (
			SELECT PG.OPERATION_GROUP
				  ,PG.ITEM_ID
				  ,PG.FROM_SITE
				  ,PG.YYYYPW
				  ,SUM(QTY)	AS QTY 
			 -- FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK)
			 FROM #CELL_CHAR_PLAN_FUTURE PG WITH(NOLOCK)  
			WHERE 1=1
			  AND PG.MEASURE = 'CELL_CHAR_PLAN'			-- 특성(F6000) 생산계획 -- CELL_CHAR_PLAN 
			  AND PG.YYYYPW >=  @V_PLAN_START_YYYYPW	-- 미래 계획 구간
			GROUP BY 
				   PG.OPERATION_GROUP
				  ,PG.ITEM_ID
				  ,PG.FROM_SITE
				  ,PG.YYYYPW
		)
		SELECT CP.*
			  ,CASE WHEN ISNULL(FY.SSP_MODIFY_YIELD, 0) > 0			THEN FY.SSP_MODIFY_YIELD
					WHEN ISNULL(FY.FORMATION_TOTAL_YIELD, 0) > 0	THEN FY.FORMATION_TOTAL_YIELD
					ELSE 1
				END AS YIELD
			  ,CP.QTY / CASE WHEN ISNULL(FY.SSP_MODIFY_YIELD, 0) > 0		THEN FY.SSP_MODIFY_YIELD
							 WHEN ISNULL(FY.FORMATION_TOTAL_YIELD, 0) > 0	THEN FY.FORMATION_TOTAL_YIELD
							 ELSE 1
						END 	AS QTY_YIELD
		 INTO #CELL_CHAR_PLAN_YIELD
		 FROM CHAR_PLAN CP 
			  LEFT JOIN #SCP_MST_FORMATION FY WITH(NOLOCK)
					 ON FY.PLANT_SITE_ID	= CP.FROM_SITE
					AND FY.ITEM_ID			= CP.ITEM_ID
					AND FY.YYYYPW			= CP.YYYYPW
					
		WHERE 1=1


		--------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Char. Available measure 추가 '
		-- Char. Available = CELL_FOR_FORM_END + CELL_PROD_FORM_END - CELL_CHAR_PLAN / 수율
		-- CELL_FOR_FORM_END : Form. End Eta (Past)
		-- CELL_PROD_FORM_END : From. End Eta (Prod)
		-- CELL_CHAR_PLAN : Char. Plan 
		--------------------------------------------------------------------------------------------------------------------

		;WITH CHAR_AVAILABE_SRC AS (
			-- CELL_FOR_FORM_END : Form. End Eta (Past) 
			/*
			SELECT FF.OPERATION_GROUP
				  ,FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYPW
				  ,SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
												 ,FF.FROM_SITE
										 ORDER BY FF.YYYYPW)	AS QTY
			 FROM #CELL_FOR_FORM_END FF
			WHERE 1=1
			*/
			--@@@ ENDING INVENTORY BOH 사용 아래에서 계산하는게 겹쳐 직접 넣어줌
			SELECT  MI.OPERATION_GROUP				AS OPERATION_GROUP
				   ,MI.ITEM_ID
				   ,MI.FROM_SITE					AS FROM_SITE
				   ,WL.YYYYPW
				   ,CASE WHEN MI.YYYYMM_PRVS_QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
						 THEN MI.YYYYMM_PRVS_QTY -  ISNULL(FA.FP_FORM_PROGRESS, 0)
						 ELSE 0
					END								AS QTY
			FROM #TMP_ENDING_INV_MM_WW MI WITH(NOLOCK)
				   LEFT JOIN #FP_AGING_STOCK FA WITH(NOLOCK)
						  ON FA.YYYYPW		= MI.YYYYPW 
						 AND FA.FROM_SITE	= MI.FROM_SITE
						 AND FA.ITEM_ID		= MI.ITEM_ID
					INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						  ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			 WHERE 1=1
			   AND MI.MEASURE = 'CELL_CHAR_AVAILABLE'
			   AND MI.YYYYPW  = @V_RESULT_LAST_YYYYPW -- 과거 실적 구간
			UNION ALL
			-- CELL_PROD_FORM_END : From. End Eta (Prod)
			SELECT FF.OPERATION_GROUP
				  ,FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYPW
				  ,SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
												 ,FF.FROM_SITE
										 ORDER BY FF.YYYYPW)	AS QTY
										 --select * 
			 FROM #CELL_PROD_FORM_END FF
			WHERE 1=1
			UNION ALL
			-- CELL_CHAR_PLAN : Char. Plan 
			SELECT CP.OPERATION_GROUP
				  ,CP.ITEM_ID
				  ,CP.FROM_SITE
				  ,CP.YYYYPW
				  ,(-1) * SUM(CP.QTY_YIELD) OVER (PARTITION BY CP.ITEM_ID
															  ,CP.FROM_SITE
												   ORDER BY CP.YYYYPW) AS QTY 
			 FROM #CELL_CHAR_PLAN_YIELD CP WITH(NOLOCK)
			 WHERE 1=1
		)
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT CA.OPERATION_GROUP
			  ,CA.ITEM_ID
			  ,'-'						AS TO_SITE 
			  ,'-'						AS INCOTERMS
			  ,CA.FROM_SITE
			  ,'-'						AS VARIOUS_KEY
			  ,CA.YYYYPW
			  ,'CELL_CHAR_AVAILABLE'	AS MEASURE 
			  ,'N'						AS IS_CELL_IN_PACK_PLANT
			  ,0.0						AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,SUM(QTY) AS QTY
		 FROM CHAR_AVAILABE_SRC CA 
		WHERE 1=1 
		GROUP BY 
			   CA.OPERATION_GROUP
			  ,CA.ITEM_ID
			  ,CA.FROM_SITE
			  ,CA.YYYYPW

-- End : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) 
-- End : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) 



-- Begin : 미래구간 Form. Progress (CELL_FORM_PROGRESS) 
-- Begin : 미래구간 Form. Progress (CELL_FORM_PROGRESS) 
		--------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Form. Progress (CELL_FORM_PROGRESS) - 기초 재고'
		--------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#FORM_PROGRESS_FROM_BOH') IS NOT NULL
			DROP TABLE #FORM_PROGRESS_FROM_BOH;

		SELECT ITEM_ID
			 , FROM_SITE
			 , SUM(Y.QTY) AS QTY
		 INTO #FORM_PROGRESS_FROM_BOH
         FROM #FOR_FORM_END_DAILY  Y WITH (NOLOCK)
        WHERE 1=1
        GROUP BY ITEM_ID
				,FROM_SITE


		--------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Form. Progress (CELL_FORM_PROGRESS) - CELL_PROD'
		--------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_PROD') IS NOT NULL
			DROP TABLE #CELL_PROD;

		SELECT PG.ITEM_ID
			  ,PG.FROM_SITE
			  ,PG.YYYYPW
			  ,SUM(QTY)	AS QTY
		 INTO #CELL_PROD
		 FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK)
		WHERE 1=1
		  AND PG.MEASURE		 = 'PRODUCTION'
		  AND PG.OPERATION_GROUP = 'A'
		  AND PG.YYYYPW >= @V_PLAN_START_YYYYPW  -- 미래 계획 구간 --   '202346' --
		GROUP BY 
			   PG.ITEM_ID
			  ,PG.FROM_SITE
			  ,PG.YYYYPW order by 1,2,3,4


		--------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Form. Progress (CELL_FORM_PROGRESS) - measure 추가'
		-- CELL_FORM_PROGRESS = FROM_BOH_QTY - CELL_FOR_FORM_END - CELL_PROD_FORM_END + CELL_PROD
		-- FROM_BOH_QTY - eng stock 'FOR' 재고 -- plant start yyyymmdd 기준 기초 재고 
		--------------------------------------------------------------------------------------------------------------------

		;WITH CELL_FORM_PROGRESS_SRC AS (
			-- FROM_BOH_QTY
			/* 
			SELECT BH.ITEM_ID
				  ,BH.FROM_SITE
				  ,WL.YYYYPW
				  ,BH.QTY 
			 FROM #FORM_PROGRESS_FROM_BOH BH WITH(NOLOCK)
				  INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						  ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			WHERE 1=1
			*/
		/*
			--@@@ ENDING INVENTORY BOH 사용 아래에서 계산하는게 겹쳐 직접 넣어줌
			SELECT  MI.ITEM_ID
				   ,MI.FROM_SITE					AS FROM_SITE
				   ,WL.YYYYPW
				   ,CASE WHEN MI.YYYYMM_PRVS_QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					  	 THEN ISNULL(FA.FP_FORM_PROGRESS, 0)
						 ELSE MI.YYYYMM_PRVS_QTY
					END								AS QTY 
			FROM #TMP_ENDING_INV_MM_WW MI WITH(NOLOCK)
				   LEFT JOIN #FP_AGING_STOCK FA WITH(NOLOCK)
						  ON FA.YYYYPW		= MI.YYYYPW 
						 AND FA.FROM_SITE	= MI.FROM_SITE
						 AND FA.ITEM_ID		= MI.ITEM_ID
					INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						  ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			 WHERE 1=1
			   AND MI.MEASURE = 'CELL_CHAR_AVAILABLE'
			   AND MI.YYYYPW  = @V_RESULT_LAST_YYYYPW -- 과거 실적 구간
			UNION ALL 
			-- CELL_FOR_FORM_END : Form. End Eta (Past) 
			SELECT FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYPW
				  ,(-1) * SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
													    ,FF.FROM_SITE
										      ORDER BY FF.YYYYPW)	AS QTY
			 FROM #CELL_FOR_FORM_END FF
			WHERE 1=1
			UNION ALL
		*/
			-- CELL_PROD_FORM_END : From. End Eta (Prod)
			SELECT FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYPW
				  ,(-1) * SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
													    ,FF.FROM_SITE
										      ORDER BY FF.YYYYPW)	AS QTY
			 FROM #CELL_PROD_FORM_END FF
			WHERE 1=1
			 AND  FF.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			UNION ALL
			-- 
			SELECT FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYPW
				  ,SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
												 ,FF.FROM_SITE
									     ORDER BY FF.YYYYPW)	AS QTY
			 FROM #CELL_PROD FF
			 WHERE 1=1
			 AND  FF.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
		)
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT 'A'	AS OPERATION_GROUP
			  ,SR.ITEM_ID
			  ,'-'						AS TO_SITE 
			  ,'-'						AS INCOTERMS
			  ,SR.FROM_SITE
			  ,'-'						AS VARIOUS_KEY
			  ,SR.YYYYPW
			  ,'CELL_FORM_PROGRESS'		AS MEASURE 
			  ,'N'						AS IS_CELL_IN_PACK_PLANT
			  ,0.0						AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,SUM(QTY) AS QTY
		  FROM CELL_FORM_PROGRESS_SRC SR 
		GROUP BY 
			   SR.ITEM_ID
			  ,SR.FROM_SITE
			  ,SR.YYYYPW

-- END : 미래구간 Form. Progress (CELL_FORM_PROGRESS) 
-- End : 미래구간 Form. Progress (CELL_FORM_PROGRESS) 




		
		----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : (AS) AS in Plan, AS Inv measure 추가' 
		----------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT FI.OPERATION_GROUP
			  ,FI.ITEM_ID
			  ,MK.SCM_SITE_ID	AS TO_SITE
			  ,MK.INCOTERMS	
			  ,'-'				AS FROM_SITE	-- SCP global psi는 to 사이트 기준 데이터임 
			  ,MK.PROJECT_CODE
			  ,DI.YYYYPW
			  ,MK.MEASURE
			  ,'N'				AS IS_CEL_INVENTORY
			  ,0.0				AS FROM_BOH_QTY
			  ,0.0				AS TO_BOH_QTY
			  ,SUM(CASE WHEN MK.MEASURE = 'AS_INV' AND DI.PW_TO_YMD = MK.YYYYMMDD
						THEN MK.QTY
						WHEN MK.MEASURE IN ('AS_IN_REQ', 'AS_IN_PLAN') 
						THEN MK.QTY
						ELSE 0.0
				   END) AS QTY
		 FROM DM_PLN_MKT_FCST_C MK WITH(NOLOCK)
			  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID		= MK.ITEM_ID 
			  INNER JOIN #SCM_MST_SITE      MS WITH(NOLOCK)
					  ON MS.SCM_SITE_ID		= MK.SCM_SITE_ID 
					 AND MS.SITE_TYPE		= 'SALES'
					 AND MS.OPERATION_GROUP = 'W'	-- to as plant 
			  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					  ON DI.YYYYMMDD = MK.YYYYMMDD 
		WHERE 1=1
		  AND MK.DIVISION_ID = @V_DIVISION_ID
		  AND MK.VERSION_NO  = @V_DM_VERSION_NO 
		  AND MK.FCST_TYPE  IN ( SELECT FCST_TYPE
			                     FROM   #TMP_AS_SALES_TYPE_CODE )  -- 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경
		  AND MK.MEASURE	 IN ('AS_IN_REQ', 'AS_IN_PLAN', 'AS_INV') 
		GROUP BY 
			   FI.OPERATION_GROUP
			  ,FI.ITEM_ID
			  ,MK.SCM_SITE_ID	
			  ,MK.INCOTERMS	
			  ,MK.PROJECT_CODE	
			  ,DI.YYYYPW
			  ,MK.MEASURE
		
		/*
		-- AS_IN_PLAN, AS_IN_REQ 계획 구간 이전 일자 추가
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT II.OPERATION_GROUP
			  ,IV.ITEM_ID
			  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
			  ,'-' AS INCOTERMS
			  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
			  ,'-' AS PROJECT_CODE
			  ,DI.YYYYPW
			  ,ML.MEASURE AS MEASURE
			  ,'N'	AS IS_CEL_INVENTORY
			  ,0.0	AS FROM_BOH_QTY
			  ,0.0	AS TO_BOH_QTY
			  ,SUM(IV.QTY)	AS QTY
		 FROM SCM_AS_SHIP_V_SN IV WITH(NOLOCK)   
			  INNER JOIN #TMP_DATE_INFO DI
			  		  ON 1=1
			  		 AND IV.SHIP_YYYYMMDD 	= DI.YYYYMMDD
			  INNER JOIN (
			  				SELECT 'AS_IN_REQ' AS MEASURE UNION ALL SELECT 'AS_IN_PLAN' AS MEASURE 
			  			 ) ML
			  		  ON 1=1
		 	  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= IV.PLANT_ID
					 AND FS.OPERATION_GROUP	= II.OPERATION_GROUP
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= 'Z' 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE IV.DIVISION_ID =  @V_DIVISION_ID
		  AND IV.SHIP_YYYYMMDD <  @V_PLAN_START_YYYYMMDD
		  AND IV.QTY > 0
		GROUP BY II.OPERATION_GROUP
				,IV.ITEM_ID
				,ISNULL(TS.SCM_SITE_ID, '-')
				,ISNULL(FS.SCM_SITE_ID, '-')
				,DI.YYYYPW
				,ML.MEASURE		
		*/		
	----------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 : AS_INVENTORY ' 
	-- AS inventory = 전주 + AS in plan - AS RTF
	-- 고도화  
	----------------------------------------------------------------------------------------------------------
	
	DELETE #TMP_ASIS_GLOBAL_PSI
	WHERE 1=1
	AND MEASURE = 'AS_INV'
	AND YYYYPW <  @V_PLAN_START_YYYYPW
	;

	;WITH BASE_DATA AS (
			-- 실적구간 -Char. Available 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				 ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_RTF_QTY
				  ,0.0					AS MM_ACC_PLAN_QTY 
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'AS_INV'
			UNION ALL 
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,SR.MM_ACC_RTF_QTY
				  ,SR.MM_ACC_PLAN_QTY
			FROM	(
						SELECT WL.YYYYPW
						  ,WL.PW_TO_YMD
						  ,WL.YYYYMM
						  ,WL.YYYYMM_PRVS
						  ,WL.YYYYMM_FIRST_YMD
						  ,WL.YYYYMM_LAST_YMD
						  ,WI.ITEM_ID
						  ,WI.OPERATION_GROUP
						  ,WI.FROM_SITE 	
						  ,0 AS MM_BOH_QTY
						  ,0 AS MM_EOH_QTY
						  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
										THEN WI.QTY
										ELSE 0.0 
								   END) AS MM_ACC_RTF_QTY 
						  ,0 AS MM_ACC_PLAN_QTY
						 FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
							 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
									 ON MI.YYYYPW = WI.YYYYPW 
							 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
						WHERE 1=1
						  AND WI.MEASURE	= 'AS_RTF'
						  AND WI.YYYYPW		<  @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
						GROUP BY
							   WL.YYYYPW
							  ,WL.PW_TO_YMD
							  ,WL.YYYYMM
							  ,WL.YYYYMM_PRVS
							  ,WL.YYYYMM_FIRST_YMD
							  ,WL.YYYYMM_LAST_YMD
							  ,WI.ITEM_ID
							  ,WI.OPERATION_GROUP
							  ,WI.FROM_SITE 
						UNION ALL 
						SELECT WL.YYYYPW
						  ,WL.PW_TO_YMD
						  ,WL.YYYYMM
						  ,WL.YYYYMM_PRVS
						  ,WL.YYYYMM_FIRST_YMD
						  ,WL.YYYYMM_LAST_YMD
						  ,WI.ITEM_ID
						  ,WI.OPERATION_GROUP
						  ,WI.FROM_SITE 	
						  ,0 AS MM_BOH_QTY
						  ,0 AS MM_EOH_QTY
						  ,0 AS MM_ACC_RTF_QTY
						  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
										THEN WI.QTY
										ELSE 0.0 
								   END) AS MM_ACC_PLAN_QTY 
						 FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
							 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
									 ON MI.YYYYPW = WI.YYYYPW 
							 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
						WHERE 1=1
						  AND WI.MEASURE	= 'AS_IN_PLAN'
						  AND WI.YYYYPW		<  @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
						GROUP BY
							   WL.YYYYPW
							  ,WL.PW_TO_YMD
							  ,WL.YYYYMM
							  ,WL.YYYYMM_PRVS
							  ,WL.YYYYMM_FIRST_YMD
							  ,WL.YYYYMM_LAST_YMD
							  ,WI.ITEM_ID
							  ,WI.OPERATION_GROUP
							  ,WI.FROM_SITE 
					) SR
			WHERE 1=1

		)
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT	 BD.OPERATION_GROUP
				,BD.ITEM_ID
				,'-'						AS TO_SITE
				,'-'						AS INCOTERMS
				,BD.FROM_SITE
				,'-'		AS TRANSPORT_MODE_LINE
				,BD.YYYYPW
			    ,BD.MEASURE 
			    ,'N'				AS IS_CELL_IN_PACK_PLANT
				,0.0				AS FROM_BOH_QTY
				,0.0				AS TO_BOH_QTY
			    ,BD.QTY
		FROM	(
					SELECT BD.YYYYPW
						  ,BD.ITEM_ID
						  ,'AS_INV'	AS MEASURE 
						  ,BD.FROM_SITE
						  ,BD.OPERATION_GROUP
						 ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
								THEN SUM(MM_EOH_QTY)
								ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_PLAN_QTY) - SUM(MM_ACC_RTF_QTY)
							END			AS QTY
					FROM BASE_DATA BD
					WHERE 1=1
					GROUP BY
						   BD.YYYYPW
						  ,BD.PW_TO_YMD
						  ,BD.YYYYMM_LAST_YMD
						  ,BD.ITEM_ID
						  ,BD.FROM_SITE
						  ,BD.OPERATION_GROUP
				) BD
		WHERE 1=1
	
	/*
	;WITH BASE_DATA AS (
			SELECT   WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
--					,WI.FROM_SITE 
--					,WI.TO_SITE
--					,WI.INCOTERMS
--					,WI.TRANSPORT_MODE_LINE
--					,WI.IS_CELL_IN_PACK_PLANT
					,SUM(WI.PLAN_QTY) AS PLAN_QTY
					,SUM(WI.PROD_QTY) AS PROD_QTY
			FROM	(
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
--								,WI.FROM_SITE 
--								,WI.TO_SITE 
--								,WI.INCOTERMS
--								,WI.TRANSPORT_MODE_LINE
--								,WI.IS_CELL_IN_PACK_PLANT
								,CASE WHEN WL.YYYYPW = WI.YYYYPW THEN WI.QTY ELSE 0 END AS PLAN_QTY 
								, 0 AS PROD_QTY
						FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
								INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
										ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						WHERE 1=1
						  AND WI.MEASURE			= 'AS_RTF'
						  --AND WI.OPERATION_GROUP	= 'P'			 -- 팩출하
						  AND WI.YYYYPW < @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						UNION ALL
						-- 실적구간 - 팩출하
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
--								,WI.FROM_SITE 
--								,WI.TO_SITE 
--								,WI.INCOTERMS
--								,WI.TRANSPORT_MODE_LINE
--								,WI.IS_CELL_IN_PACK_PLANT
								,0 AS PLAN_QTY
								,CASE WHEN WL.YYYYPW = WI.YYYYPW THEN WI.QTY ELSE 0 END AS QTY 
						FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
								INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
										ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						WHERE 1=1
						  AND WI.MEASURE = 'AS_IN_PLAN'
						  AND WI.YYYYPW < @V_PLAN_START_YYYYPW  -- 미래 계획 구간
					) WI
			WHERE	1=1
			GROUP BY WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
--					,WI.FROM_SITE 
--					,WI.TO_SITE
--					,WI.INCOTERMS
--					,WI.TRANSPORT_MODE_LINE
--					,WI.IS_CELL_IN_PACK_PLANT
	)
	INSERT INTO #TMP_ASIS_GLOBAL_PSI
	SELECT	 DISTINCT 
			 PG.OPERATION_GROUP
			,PG.ITEM_ID
			,PG.TO_SITE 				AS TO_SITE 
			,PG.INCOTERMS				AS INCOTERMS
			,PG.FROM_SITE				AS FROM_SITE 
			,PG.TRANSPORT_MODE_LINE		AS TRANSPORT_MODE_LINE
			,PG.YYYYPW
			,'AS_INV'			AS MEASURE
			,'N'				AS IS_CELL_IN_PACK_PLANT
			,0.0				AS FROM_BOH_QTY
			,0.0				AS TO_BOH_QTY
			,SUM(PG.ACC_QTY)	OVER (PARTITION BY PG.ITEM_ID
													,PG.OPERATION_GROUP
													,PG.FROM_SITE
										ORDER BY  PG.YYYYPW )		AS QTY		
		FROM (
				SELECT   BD.YYYYPW
						,BD.OPERATION_GROUP
						,BD.ITEM_ID
						,'-' AS TO_SITE 				
						,'-' AS INCOTERMS				
						,'-' AS FROM_SITE				
						,'-' AS TRANSPORT_MODE_LINE	
						,'N' AS IS_CELL_IN_PACK_PLANT
						,ISNULL(CASE WHEN BD.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) AS  ACC_QTY
--						,CASE WHEN BD.YYYYMM = WL.YYYYMM THEN 
--									ISNULL(CASE WHEN BD.YYYYMM = @V_PLAN_START_YYYYMM THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) 
--							  ELSE 0 END ACC_QTY
					FROM BASE_DATA BD
						-- INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK)
						--		ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간
						 LEFT JOIN
						(
								SELECT	 WI.ITEM_ID
										,WI.OPERATION_GROUP
										,WI.FROM_SITE 
										,'-'			AS TO_SITE 
										,SUM(WI.YYYYMM_PRVS_QTY) AS BOH 
								FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK) 
								WHERE 1=1
								AND WI.YYYYPW	= '0000'--@V_RESULT_LAST_YYYYPW
								AND WI.MEASURE	= 'AS_INV'
								GROUP BY WI.ITEM_ID
										,WI.OPERATION_GROUP
										,WI.FROM_SITE 
							) SO
							ON 1=1
							AND BD.ITEM_ID = SO.ITEM_ID
							AND BD.OPERATION_GROUP = SO.OPERATION_GROUP
							--AND BD.FROM_SITE = SO.FROM_SITE
				WHERE 1=1
			) PG
			;

			INSERT INTO #TMP_ASIS_GLOBAL_PSI
			SELECT	 WI.OPERATION_GROUP
					,WI.ITEM_ID
					,'-'				AS TO_SITE 
					,'-'				AS INCOTERMS
					,'-'				AS FROM_SITE 
					,'-'				AS TRANSPORT_MODE_LINE
					,WL.YYYYPW
					,'AS_INV'			AS MEASURE
					,'N'				AS IS_CELL_IN_PACK_PLANT
					,0.0				AS FROM_BOH_QTY
					,0.0				AS TO_BOH_QTY
					,SUM(WI.YYYYMM_PRVS_QTY)		AS QTY 
			FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK) 
				INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						ON WL.YYYYPW <   @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			WHERE 1=1
			AND WI.YYYYPW	=  '0000'--@V_RESULT_LAST_YYYYPW
			AND WI.MEASURE	= 'AS_INV'
			AND NOT EXISTS (
								SELECT	1
								FROM	#TMP_ASIS_GLOBAL_PSI X 
								WHERE	1=1
								AND		X.MEASURE = 'AS_INV'
								AND		X.ITEM_ID = WI.ITEM_ID
								--AND		X.FROM_SITE = WI.FROM_SITE
								AND		X.OPERATION_GROUP = WI.OPERATION_GROUP
								AND     X.YYYYPW <  @V_PLAN_START_YYYYPW 
						   )
		   GROUP BY WL.YYYYPW
					,WI.ITEM_ID
					--,WI.FROM_SITE 
					,WI.OPERATION_GROUP
			;
	
	-- 월말값은 기말재고로 반영
	UPDATE	A
	SET		A.QTY = B.NEW_MM_QTY
	FROM	#TMP_ASIS_GLOBAL_PSI A
			INNER JOIN (
							SELECT  GP.*, MI.YYYYMM_PRVS_QTY AS NEW_MM_QTY
							FROM	#TMP_ASIS_GLOBAL_PSI GP
									INNER JOIN (
													SELECT	WL.YYYYPW, WL.YYYYMM
													FROM	#TMP_PW_LIST WL
													WHERE	1=1
													AND		WL.PW_TO_YMD = WL.YYYYMM_LAST_YMD
												) WL
											ON	1=1
										   AND	GP.YYYYPW = WL.YYYYPW
									LEFT JOIN #TMP_ENDING_INV_MM_WW MI WITH(NOLOCK)			-- 당월말 재고 참조   
										   ON WL.YYYYMM		= MI.YYYYMM		
										  AND GP.ITEM_ID	= MI.ITEM_ID	
										  AND GP.FROM_SITE	= MI.FROM_SITE
										  AND GP.TO_SITE	= MI.TO_SITE 
										  AND GP.MEASURE	= MI.MEASURE 
							WHERE 1=1
							AND GP.MEASURE = 'AS_INV'
							AND MI.YYYYMM_PRVS_QTY IS NOT NULL
						) B
					ON	1=1
				   AND	A.YYYYPW	=	B.YYYYPW
				   AND	A.ITEM_ID	=	B.ITEM_ID
				   AND	A.MEASURE	=	B.MEASURE
				   AND	A.FROM_SITE	=	B.FROM_SITE
				   AND	A.TO_SITE	=	B.TO_SITE
				   AND	A.OPERATION_GROUP	=	B.OPERATION_GROUP
		WHERE	1=1
		  AND	A.MEASURE = 'AS_INV'
		  AND	A.YYYYPW  <  @V_PLAN_START_YYYYPW 
	
	*/			
	
	----------------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : (AS) MKT_FCST measure 추가' 
	----------------------------------------------------------------------------------------------------------------------------
	INSERT INTO #TMP_ASIS_GLOBAL_PSI
	SELECT FI.OPERATION_GROUP
			,FI.ITEM_ID
			,MK.SCM_SITE_ID				AS TO_SITE
			,MK.INCOTERMS	
			,'-'							AS FROM_SITE	-- SCP global psi는 to 사이트 기준 데이터임 
			,MK.PROJECT_CODE
			,DI.YYYYPW
			,CONCAT('AS_', MK.MEASURE)	AS MEASURE
			,'N'							AS IS_CEL_INVENTORY
			,0.0							AS FROM_BOH_QTY
			,0.0							AS TO_BOH_QTY
			,SUM(MK.QTY)					AS QTY
		FROM DM_PLN_MKT_FCST_C MK WITH(NOLOCK)
			INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					ON FI.ITEM_ID		= MK.ITEM_ID 
			INNER JOIN #SCM_MST_SITE     MS WITH(NOLOCK)
					ON MS.SCM_SITE_ID				    = MK.SCM_SITE_ID 
					AND MS.SITE_TYPE				    = 'SALES'
					AND ISNULL(MS.OPERATION_GROUP,'') != 'W'
			INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					ON DI.YYYYMMDD = MK.YYYYMMDD 
	WHERE 1=1
		AND MK.DIVISION_ID = @V_DIVISION_ID
		AND MK.VERSION_NO  = @V_DM_VERSION_NO 
		AND MK.FCST_TYPE  IN ( SELECT FCST_TYPE
			                   FROM   #TMP_AS_SALES_TYPE_CODE )  -- 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경
		AND MK.MEASURE	 IN ('MKT_FCST', 'RTF')
	GROUP BY 
			FI.OPERATION_GROUP
			,FI.ITEM_ID
			,MK.SCM_SITE_ID	
			,MK.INCOTERMS	
			,MK.PROJECT_CODE	
			,DI.YYYYPW
			,CONCAT('AS_', MK.MEASURE)

	----------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : AS_INVENTORY 재계산' 
	-- AS inventory = 전주 + AS in plan - AS RTF
	-- 고도화  
	----------------------------------------------------------------------------------------------------------
	
	DELETE #TMP_ASIS_GLOBAL_PSI
	WHERE 1=1
	AND MEASURE = 'AS_INV'
	AND YYYYPW >=  @V_PLAN_START_YYYYPW
	
	;WITH BASE_DATA AS (
			SELECT   WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
--					,WI.FROM_SITE 
--					,WI.TO_SITE
--					,WI.INCOTERMS
--					,WI.TRANSPORT_MODE_LINE
--					,WI.IS_CELL_IN_PACK_PLANT
					,SUM(WI.PLAN_QTY) AS PLAN_QTY
					,SUM(WI.PROD_QTY) AS PROD_QTY
			FROM	(
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
--								,WI.FROM_SITE 
--								,WI.TO_SITE 
--								,WI.INCOTERMS
--								,WI.TRANSPORT_MODE_LINE
--								,WI.IS_CELL_IN_PACK_PLANT
								,CASE WHEN WL.YYYYPW = WI.YYYYPW THEN WI.QTY ELSE 0 END AS PLAN_QTY 
								, 0 AS PROD_QTY
						FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
								INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
										ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						WHERE 1=1
						  AND WI.MEASURE			= 'AS_RTF'
						  --AND WI.OPERATION_GROUP	= 'P'			 -- 팩출하
						  AND WI.YYYYPW >= @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						UNION ALL
						-- 실적구간 - 팩출하
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
--								,WI.FROM_SITE 
--								,WI.TO_SITE 
--								,WI.INCOTERMS
--								,WI.TRANSPORT_MODE_LINE
--								,WI.IS_CELL_IN_PACK_PLANT
								,0 AS PLAN_QTY
								,CASE WHEN WL.YYYYPW = WI.YYYYPW THEN WI.QTY ELSE 0 END AS QTY 
						FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
								INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
										ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						WHERE 1=1
						  AND WI.MEASURE = 'AS_IN_PLAN'
						  AND WI.YYYYPW >= @V_PLAN_START_YYYYPW  -- 미래 계획 구간
					) WI
			WHERE	1=1
			GROUP BY WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
--					,WI.FROM_SITE 
--					,WI.TO_SITE
--					,WI.INCOTERMS
--					,WI.TRANSPORT_MODE_LINE
--					,WI.IS_CELL_IN_PACK_PLANT
	)
	INSERT INTO #TMP_ASIS_GLOBAL_PSI
	SELECT	 DISTINCT 
			 PG.OPERATION_GROUP
			,PG.ITEM_ID
			,PG.TO_SITE 				AS TO_SITE 
			,PG.INCOTERMS				AS INCOTERMS
			,PG.FROM_SITE				AS FROM_SITE 
			,PG.TRANSPORT_MODE_LINE		AS TRANSPORT_MODE_LINE
			,PG.YYYYPW
			,'AS_INV'			AS MEASURE
			,'N'				AS IS_CELL_IN_PACK_PLANT
			,0.0				AS FROM_BOH_QTY
			,0.0				AS TO_BOH_QTY
			,SUM(PG.ACC_QTY)	OVER (PARTITION BY PG.ITEM_ID
													,PG.OPERATION_GROUP
													,PG.FROM_SITE
										ORDER BY  PG.YYYYPW )		AS QTY		
		FROM (
				SELECT   BD.YYYYPW
						,BD.OPERATION_GROUP
						,BD.ITEM_ID
						,'-' AS TO_SITE 				
						,'-' AS INCOTERMS				
						,'-' AS FROM_SITE				
						,'-' AS TRANSPORT_MODE_LINE	
						,'N' AS IS_CELL_IN_PACK_PLANT
						,ISNULL(CASE WHEN BD.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) AS  ACC_QTY
--						,CASE WHEN BD.YYYYMM = WL.YYYYMM THEN 
--									ISNULL(CASE WHEN BD.YYYYMM = @V_PLAN_START_YYYYMM THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) 
--							  ELSE 0 END ACC_QTY
					FROM BASE_DATA BD
						-- INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK)
						--		ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간
						 LEFT JOIN
						(
								SELECT	 WI.ITEM_ID
										,WI.OPERATION_GROUP
										,WI.FROM_SITE 
										,'-'			AS TO_SITE 
										,SUM(WI.QTY) AS BOH 
								FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
								WHERE 1=1
								AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
								AND WI.MEASURE	= 'AS_INV'
								GROUP BY WI.ITEM_ID
										,WI.OPERATION_GROUP
										,WI.FROM_SITE 
							) SO
							ON 1=1
							AND BD.ITEM_ID = SO.ITEM_ID
							AND BD.OPERATION_GROUP = SO.OPERATION_GROUP
							--AND BD.FROM_SITE = SO.FROM_SITE
				WHERE 1=1
			) PG
			;

			INSERT INTO #TMP_ASIS_GLOBAL_PSI
			SELECT	 WI.OPERATION_GROUP
					,WI.ITEM_ID
					,'-'				AS TO_SITE 
					,'-'				AS INCOTERMS
					,'-'				AS FROM_SITE 
					,'-'				AS TRANSPORT_MODE_LINE
					,WL.YYYYPW
					,'AS_INV'			AS MEASURE
					,'N'				AS IS_CELL_IN_PACK_PLANT
					,0.0				AS FROM_BOH_QTY
					,0.0				AS TO_BOH_QTY
					,SUM(WI.QTY)		AS QTY 
			FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
				INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						ON WL.YYYYPW >=   @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			WHERE 1=1
			AND WI.YYYYPW	=  @V_RESULT_LAST_YYYYPW
			AND WI.MEASURE	= 'AS_INV'
			AND NOT EXISTS (
								SELECT	1
								FROM	#TMP_ASIS_GLOBAL_PSI X 
								WHERE	1=1
								AND		X.MEASURE = 'AS_INV'
								AND		X.ITEM_ID = WI.ITEM_ID
								--AND		X.FROM_SITE = WI.FROM_SITE
								AND		X.OPERATION_GROUP = WI.OPERATION_GROUP
								AND     X.YYYYPW >=  @V_PLAN_START_YYYYPW 
						   )
		   GROUP BY WL.YYYYPW
					,WI.ITEM_ID
					--,WI.FROM_SITE 
					,WI.OPERATION_GROUP
					
		

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : SCP 출하 계획 참조 Measure (MKT_FCST/RTF) ' 
		-- SCP_ANL_SHIPMENT_PLAN_FG 최근 한달 데이터?까지만 참조 가능 (주기적으로 삭제됨),
		-----------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT SP.BIZ_TYPE		AS OPERATION_GROUP
			  ,SP.ITEM_ID
			  ,SP.TO_SITE
			  ,SP.INCOTERMS
			  ,'-'				AS FROM_SITE
			  ,SP.PROJECT_CODE	AS TRANSPORT_MODE_LINE
			  ,DI.YYYYPW
			  ,CASE WHEN SP.MEASURE = 'ALLOCATION' THEN 'RTF' ELSE SP.MEASURE END AS MEASURE
			  ,'N'				AS IS_CELL_IN_PACK_PLANT
			  ,0.0				AS FROM_BOH_QTY
			  ,0.0				AS TO_BOH_QTY
			  ,SUM(SP.QTY)		AS QTY
		 FROM SCP_ANL_SHIPMENT_PLAN_FG SP with(nolock)
			  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					  ON DI.YYYYMMDD = SP.YYYYMMDD 
			  LEFT  JOIN #SCM_MST_SITE TS
					  ON TS.SCM_SITE_ID		= SP.TO_SITE
		WHERE 1=1
		  AND SP.DIVISION_ID			= @V_DIVISION_ID
		  AND SP.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		  AND SP.PLAN_TYPE				= @V_PLAN_TYPE
		  AND SP.SEQ					= @V_PLAN_SEQ
		  AND SP.MEASURE IN ('MKT_FCST', 'ALLOCATION')	-- MKT_FCST / RTF 
		  AND ISNULL(SP.PROJECT_CODE, '-')  != '-'
		 AND ISNULL(TS.OPERATION_GROUP,'')	!= 'W'	-- AS Sales Site 제외 (AS in Req / As in Plan 제외) 
		GROUP BY SP.BIZ_TYPE	
				,SP.ITEM_ID
				,SP.TO_SITE
				,SP.INCOTERMS
				,SP.PROJECT_CODE
				,DI.YYYYPW
			    ,CASE WHEN SP.MEASURE = 'ALLOCATION' THEN 'RTF' ELSE SP.MEASURE END

		----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : TO_SITE_EOH(WH_IN_BALANCE) 계산 위한 Sales Site 입고 및 RTF' 
		-- TO_SITE_EOH = plant date 기준 기초재고 + (누적)WH In - (누적)RTF
		-- plan date 기준 기초재고를 참조하기 때문에 당월의 경우 실적이 반영안된 계획 구간의 RTF만 참조되도록 함
		-- RTF 실적구간은 계획 구간 TO_SITE_EOH 산정 후 추가함.
		----------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SALES_SITE_BOH') IS NOT NULL
			DROP TABLE #SALES_SITE_BOH;

		SELECT SO.SITE_ID
			  ,SO.ITEM_ID
			  ,SO.PSI_BOH_QTY	AS BOH_QTY
         INTO #SALES_SITE_BOH   
		 FROM SCP_PLN_SALES_ONHAND SO WITH(NOLOCK)
			  INNER JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					  ON TS.SCM_SITE_ID					 = SO.SITE_ID
					 AND TS.SITE_TYPE					 = 'SALES'
					 AND ISNULL(TS.OPERATION_GROUP,'')  != 'W' -- AS 사이트 제외
		WHERE 1 = 1 
		  AND SO.DIVISION_ID			= @V_DIVISION_ID
		  AND SO.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		  AND SO.PLAN_TYPE				= @V_PLAN_TYPE
		  AND SO.SEQ					= @V_PLAN_SEQ
		  AND SO.YYYYMMDD				= @V_PLAN_START_YYYYMMDD
			  

		----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : TO_SITE_EOH(WH_IN_BALANCE) 계산 위한 Sales Site 입고 및 RTF' 
		-- TO_SITE_EOH = plant date 기준 기초재고 + (누적)WH In - (누적)RTF
		----------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#WH_IN_RTF') IS NOT NULL
			DROP TABLE #WH_IN_RTF;

		SELECT PG.ITEM_ID
			  ,PG.OPERATION_GROUP
			  ,PG.TO_SITE
			  ,PG.INCOTERMS
			  ,PG.YYYYPW
			  ,SUM(CASE WHEN MEASURE = 'WH_IN'			THEN PG.QTY ELSE 0.0 END)	AS WH_IN
			  ,SUM(SUM(CASE WHEN MEASURE = 'WH_IN'		THEN PG.QTY ELSE 0.0 END))
					OVER (PARTITION BY PG.ITEM_ID
									  ,PG.OPERATION_GROUP
									  ,PG.TO_SITE
									  ,PG.INCOTERMS
							 ORDER BY  PG.YYYYPW )									AS WH_IN_ACC
			  ,SUM(CASE WHEN MEASURE = 'RTF'		THEN PG.QTY ELSE 0.0 END)	AS RTF
			  ,SUM(SUM(CASE WHEN MEASURE = 'RTF'	THEN PG.QTY ELSE 0.0 END))
					OVER (PARTITION BY PG.ITEM_ID
									  ,PG.OPERATION_GROUP
									  ,PG.TO_SITE
									  ,PG.INCOTERMS
							 ORDER BY  PG.YYYYPW )									AS RTF_ACC
		 INTO #WH_IN_RTF
		 FROM #TMP_ASIS_GLOBAL_PSI PG  WITH(NOLOCK) 
			  INNER JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					  ON TS.SCM_SITE_ID					 = PG.TO_SITE
					 AND TS.SITE_TYPE					 = 'SALES'
					 AND ISNULL(TS.OPERATION_GROUP,'')  != 'W' -- AS 사이트 제외
		WHERE 1=1
		  AND PG.MEASURE in ('RTF', 'WH_IN')
		GROUP BY PG.OPERATION_GROUP
				,PG.ITEM_ID
				,PG.TO_SITE
				,PG.INCOTERMS
				,PG.YYYYPW
				;
		
		-- 'ESST_CA_WND' 은 VMI Inventory 에 포함하지 않는다.
		DELETE	#WH_IN_RTF
		WHERE	1= (CASE WHEN @V_DIVISION_ID = '81' THEN 1 ELSE 0 END)
		AND		TO_SITE = 'ESST_CA_WND'
		AND		ITEM_ID LIKE  'ACEH1131I-B1%'
		;


		----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : TO_SITE_EOH (WH_IN_BALANCE) VMI Inventory Measure 추가' 
		----------------------------------------------------------------------------------------------------------------------------
		/*
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT WR.OPERATION_GROUP
			  ,WR.ITEM_ID
			  ,WR.TO_SITE
			  ,WR.INCOTERMS
			  ,'-'				AS FROM_SITE
			  ,'-'				AS TRANSPORT_MODE_LINE
			  ,WR.YYYYPW
			  ,'TO_SITE_EOH'	AS MEASURE
			  ,'N'				AS IS_CELL_IN_PACK_PLANT
			  ,0.0													AS FROM_BOH_QTY
			  ,ISNULL(SB.BOH_QTY,0.0)								AS TO_BOH_QTY
			  ,ISNULL(SB.BOH_QTY,0.0) + WR.WH_IN_ACC - WR.RTF_ACC	AS QTY
		  FROM #WH_IN_RTF WR WITH(NOLOCK)
			   LEFT JOIN #SALES_SITE_BOH SB WITH(NOLOCK)
					  ON SB.ITEM_ID = WR.ITEM_ID
					 AND SB.SITE_ID = WR.TO_SITE
		WHERE 1=1
		*/
		-- @@@ BOH 기준 변경
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT PG.OPERATION_GROUP
				,PG.ITEM_ID
				,PG.TO_SITE
				,PG.INCOTERMS
				,'-'				AS FROM_SITE
			  	,'-'				AS TRANSPORT_MODE_LINE
				,PG.YYYYPW
				,'TO_SITE_EOH'	AS MEASURE
			  	,'N'				AS IS_CELL_IN_PACK_PLANT
			  	,0.0													AS FROM_BOH_QTY
			  	,0.0													AS TO_BOH_QTY
				,SUM(PG.ACC_QTY)
									OVER (PARTITION BY PG.ITEM_ID
													  ,PG.OPERATION_GROUP
													  ,PG.TO_SITE
													  ,PG.INCOTERMS
											 ORDER BY  PG.YYYYPW )		AS QTY		
		FROM (
				SELECT PG.ITEM_ID
					  ,PG.OPERATION_GROUP
					  ,PG.TO_SITE
					  ,PG.INCOTERMS
					  ,WL.YYYYPW
					  ,SUM(CASE WHEN PG.YYYYPW = WL.YYYYPW THEN 
					  			 ISNULL(CASE WHEN PG.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(SO.QTY,0) + PG.WH_IN - PG.RTF ELSE 0 + PG.WH_IN - PG.RTF END,0) 
					  		ELSE 0 END) ACC_QTY
				 FROM  (
							SELECT PG.*
								, RANK() OVER (PARTITION BY PG.ITEM_ID  
															ORDER BY PG.YYYYPW, PG.TO_SITE DESC, INCOTERMS ) AS IDX -- '-' 정보를 뒤로 주기 위해서
							FROM #WH_IN_RTF PG  WITH(NOLOCK) 
				 			WHERE 1=1
							AND   PG.YYYYPW >= @V_PLAN_START_YYYYPW
						) PG
						INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						  		ON 1=1
						  	   AND WL.YYYYPW >= @V_PLAN_START_YYYYPW
						 LEFT OUTER JOIN
							  (
									SELECT SO.ITEM_ID, SO.OPERATION_GROUP, SUM(SO.YYYYMM_PRVS_QTY) AS QTY 
									FROM #TMP_ENDING_INV_MM_WW SO WITH(NOLOCK)
									WHERE 1=1
									AND SO.YYYYPW	= @V_RESULT_LAST_YYYYPW
									AND SO.MEASURE	= 'TO_SITE_EOH'
									GROUP BY SO.ITEM_ID, SO.OPERATION_GROUP
							   ) SO
							 ON 1=1
							   AND PG.ITEM_ID = SO.ITEM_ID
							   AND PG.OPERATION_GROUP = SO.OPERATION_GROUP
							   AND PG.IDX = 1
				WHERE 1=1
				GROUP BY PG.ITEM_ID
						  ,PG.OPERATION_GROUP
						  ,PG.TO_SITE
						  ,PG.INCOTERMS
						  ,WL.YYYYPW
			) PG
			;
			
			-- @@@ 미래계획 기준이 없을 경우 넣어준다.
			INSERT INTO #TMP_ASIS_GLOBAL_PSI
			SELECT   SO.OPERATION_GROUP
					,SO.ITEM_ID
					,SO.FROM_SITE 		AS TO_SITE
					,'-' 				AS INCOTERMS
					,'-'				AS FROM_SITE
				  	,'-'				AS TRANSPORT_MODE_LINE
					,ML.YYYYPW 			AS YYYYPW
					,'TO_SITE_EOH'		AS MEASURE
				  	,'N'				AS IS_CELL_IN_PACK_PLANT
				  	,0.0				AS FROM_BOH_QTY
				  	,0.0				AS TO_BOH_QTY
				  	,SUM(SO.YYYYMM_PRVS_QTY)		AS QTY
			FROM 	#TMP_ENDING_INV_MM_WW SO WITH(NOLOCK)
					INNER JOIN #TMP_PW_LIST ML WITH(NOLOCK)
					  		ON 1=1
					  	   AND ML.YYYYPW >= @V_PLAN_START_YYYYPW
			WHERE 1=1
			AND SO.YYYYPW	= @V_RESULT_LAST_YYYYPW
			AND SO.MEASURE	= 'TO_SITE_EOH'
			AND NOT EXISTS (
								SELECT 	1
								  FROM 	#TMP_ASIS_GLOBAL_PSI X
								 WHERE 	1=1
								   AND  X.MEASURE			= SO.MEASURE
								   AND 	X.ITEM_ID 			= SO.ITEM_ID
								   AND 	X.OPERATION_GROUP	= SO.OPERATION_GROUP
								   AND  X.YYYYPW >= @V_PLAN_START_YYYYPW
							)
			GROUP BY SO.ITEM_ID, SO.OPERATION_GROUP, SO.FROM_SITE, ML.YYYYPW
			;

			   

		
		
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available' 
		-- 전주 재고(Char. Available)  + 금주생산(Production(PKG)) -  금주 특성 생산 실적 (Char.Plan) / 활성화특성수율
		-- 전월말 재고를 기초로 하여 해당월 도착/생산 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available - 셀 생산실적'   
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CELL_PROD_FOR_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #CELL_PROD_FOR_CHAR_AVAILABLE;
		/*
		-- 실적구간 - 셀 생산실적 (from site) 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_CELL_PROD_QTY 
		 INTO #CELL_PROD_FOR_CHAR_AVAILABLE
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_PROD'
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
		*/
		-- 계산식을 위로 올려서 #TMP_ASIS_GLOBAL_PSI 로 변경함
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_CELL_PROD_QTY 
		 INTO #CELL_PROD_FOR_CHAR_AVAILABLE
		 FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'PRODUCTION'
		  AND WI.OPERATION_GROUP = 'A'
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available - 셀 특성 실적(투입기준)'   
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CELL_CHAR_FOR_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #CELL_CHAR_FOR_CHAR_AVAILABLE;
		
		/*
		-- 실적구간 - 셀 특성 실적 / 활성화특성수율  
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	/ CASE WHEN CY.CHAR_YIELD > 0 
							   THEN CY.CHAR_YIELD
							   ELSE 1
						  END   AS MM_ACC_CELL_CHAR_QTY 
		 INTO #CELL_CHAR_FOR_CHAR_AVAILABLE  
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 LEFT  JOIN #SCP_MST_FORMATION CY WITH(NOLOCK)
					 ON CY.PLANT_SITE_ID	= WI.FROM_SITE
					AND CY.ITEM_ID			= WI.ITEM_ID
					AND CY.YYYYPW			= WI.YYYYPW
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_CHAR_PLAN'			-- 셀 특성 실적 (활성화특성수율 역적용) 
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,CASE WHEN CY.CHAR_YIELD > 0 
					THEN CY.CHAR_YIELD
					ELSE 1
				END
		*/
		-- 계산식을 위로 올려서 #TMP_ASIS_GLOBAL_PSI 로 변경함
		-- 실적구간 - 셀 특성 실적 / 활성화특성수율  
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	/ CASE WHEN CY.CHAR_YIELD > 0 
							   THEN CY.CHAR_YIELD
							   ELSE 1
						  END   AS MM_ACC_CELL_CHAR_QTY 
		 INTO #CELL_CHAR_FOR_CHAR_AVAILABLE  
		 FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 LEFT  JOIN #SCP_MST_FORMATION CY WITH(NOLOCK)
					 ON CY.PLANT_SITE_ID	= WI.FROM_SITE
					AND CY.ITEM_ID			= WI.ITEM_ID
					AND CY.YYYYPW			= WI.YYYYPW
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_CHAR_PLAN'			-- 셀 특성 실적 (활성화특성수율 역적용) 
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,CASE WHEN CY.CHAR_YIELD > 0 
					THEN CY.CHAR_YIELD
					ELSE 1
				END
				
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available (Formation Progress 포함?) 추가' 
		-- 전주 재고(Char. Available)  + 금주생산(Production(PKG)) -  금주 특성 생산 실적 (Char.Plan) / 활성화특성수율
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PAST_CELL_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #PAST_CELL_CHAR_AVAILABLE;

		;WITH BASE_DATA AS (
			-- 실적구간 -Char. Available 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				 ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_CELL_PROD_QTY
				  ,0.0					AS MM_ACC_CELL_CHAR_QTY 
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'CELL_CHAR_AVAILABLE'
			UNION ALL 
			-- 실적구간 - Production(PKG)
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_CELL_PROD_QTY
				  ,0.0					AS MM_ACC_CELL_CHAR_QTY
			 FROM #CELL_PROD_FOR_CHAR_AVAILABLE SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - Cell Char
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_CELL_PROD_QTY
				  ,SR.MM_ACC_CELL_CHAR_QTY
			 FROM #CELL_CHAR_FOR_CHAR_AVAILABLE SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'CELL_CHAR_AVAILABLE'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,'-'						AS TO_SITE
			  ,'-'						AS INCOTERMS
			  ,'-'						AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'-'						AS TO_SITE_TYPE
			  ,0.0						AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_CELL_PROD_QTY) - SUM(MM_ACC_CELL_CHAR_QTY)
				END			AS QTY
		 INTO #PAST_CELL_CHAR_AVAILABLE
		 FROM BASE_DATA BD
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress 분리' 
		-- 2023.11.22 요구사항 
		-- 과거 실적의 활성화와 특성 분리
		-- 현재 로직 : 과거 실적 재고 중에 활성화 재고는 모두 Char. Available에 반영되어 있음
		-- 이것을 Remain Lead Time이 0이 아닌 것을 Ending Inventory에서 Formation Progress로 차감하여 반영
		-- 만약 해당 cutoff 일의 Formation Progress > Ending Inventory 이면 Ending Inventory이 Max 값으로 설정
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress - FP Aging Stock 반영' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PAST_FORM_PROGRESS_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #PAST_FORM_PROGRESS_CHAR_AVAILABLE;
		
		SELECT MI.YYYYPW
			  ,MI.ITEM_ID
			  ,MI.FROM_SITE					AS FROM_SITE
			  ,MI.OPERATION_GROUP			AS OPERATION_GROUP
			  ,CASE WHEN MI.QTY <  0  -- qty가 마이너스인 경우 고려 
					THEN MI.QTY
					WHEN MI.QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN MI.QTY -  ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE 0
				END								AS CHAR_AVAILABLE
			  ,CASE WHEN MI.QTY <  0  -- qty가 마이너스인 경우 고려 
					THEN 0
					WHEN MI.QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE MI.QTY
			   END								AS FORM_PROGRESS 
			  ,MI.QTY							AS ENDING_INVENTORY
			  ,ISNULL(FA.FP_FORM_PROGRESS, 0)	AS FP_FORM_PROGRESS
		  INTO #PAST_FORM_PROGRESS_CHAR_AVAILABLE
		  FROM #PAST_CELL_CHAR_AVAILABLE MI WITH(NOLOCK)
			   LEFT JOIN #FP_AGING_STOCK FA WITH(NOLOCK)
					  ON FA.YYYYPW		= MI.YYYYPW
					 AND FA.FROM_SITE	= MI.FROM_SITE
					 AND FA.ITEM_ID		= MI.ITEM_ID
		 WHERE 1=1
		   AND MI.YYYYPW  < @V_PLAN_START_YYYYPW -- 과거 실적 구간
		
		/*
		SELECT MI.YYYYPW
			  ,MI.ITEM_ID
			  ,MI.FROM_SITE					AS FROM_SITE
			  ,MI.OPERATION_GROUP			AS OPERATION_GROUP
			  ,CASE WHEN MI.YYYYMM_PRVS_QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN MI.YYYYMM_PRVS_QTY -  ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE 0
				END								AS CHAR_AVAILABLE
			  ,CASE WHEN MI.YYYYMM_PRVS_QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE MI.YYYYMM_PRVS_QTY
			   END								AS FORM_PROGRESS 
			  ,MI.YYYYMM_PRVS_QTY							AS ENDING_INVENTORY
			  ,ISNULL(FA.FP_FORM_PROGRESS, 0)	AS FP_FORM_PROGRESS
		  INTO #PAST_FORM_PROGRESS_CHAR_AVAILABLE
		  FROM #TMP_ENDING_INV_MM_WW MI WITH(NOLOCK)
			   LEFT JOIN #FP_AGING_STOCK FA WITH(NOLOCK)
					  ON FA.YYYYPW		= MI.YYYYPW 
					 AND FA.FROM_SITE	= MI.FROM_SITE
					 AND FA.ITEM_ID		= MI.ITEM_ID
		 WHERE 1=1
		   AND MI.MEASURE = 'CELL_CHAR_AVAILABLE'
		   AND MI.YYYYPW  < @V_PLAN_START_YYYYPW -- 과거 실적 구간
		*/
		   
		   
-- START : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다. 	-- 고도화 
-- START : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다.
			  
		-- 기존 정보 삭제
		DELETE #CELL_CHAR_PLAN_FUTURE
		DELETE #CELL_CHAR_PLAN_YIELD
		DELETE #TMP_ASIS_GLOBAL_PSI
		WHERE 1=1
		AND MEASURE IN ( 'CELL_CHAR_AVAILABLE','CELL_CHAR_PLAN')
		AND YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
		;
	
		SELECT	@V_HORIZON_END_YYYYPW = WL.YYYYPW
		  FROM	#TMP_PW_LIST WL WITH(NOLOCK)
		 WHERE	1=1
		   AND  WL.PW_FROM_YMD <= @V_HORIZON_END_YYYYMMDD
		   AND  WL.PW_TO_YMD   >= @V_HORIZON_END_YYYYMMDD
		;
	
		DECLARE
		        @CUR_FORM$CUR_YYYYPW        nvarchar(8),
				@CUR_FORM$PREV_YYYYPW       nvarchar(8)
		DECLARE
		        CUR_FORM CURSOR LOCAL FOR
					
	        	SELECT	WL.YYYYPW AS CUR_YYYYPW, XX.YYYYPW AS PREV_YYYYPW
				FROM	#TMP_PW_LIST WL WITH(NOLOCK)
						INNER JOIN #TMP_PW_LIST XX WITH(NOLOCK)
						ON 1=1
						AND XX.PW_FROM_YMD <= CONVERT(NVARCHAR, DATEADD(DAY, -1, CONVERT(DATE, WL.PW_FROM_YMD)), 112) 
						AND XX.PW_TO_YMD >= CONVERT(NVARCHAR, DATEADD(DAY, -1, CONVERT(DATE, WL.PW_FROM_YMD)), 112) 
				WHERE	WL.YYYYPW >= @V_PLAN_START_YYYYPW  -- 미래 계획 구간
				ORDER BY WL.YYYYPW
					
		
				OPEN CUR_FORM
				FETCH NEXT FROM CUR_FORM INTO @CUR_FORM$CUR_YYYYPW, @CUR_FORM$PREV_YYYYPW ;
		
				  WHILE (@@FETCH_STATUS = 0)
				    BEGIN
		
						BEGIN
							
							;WITH CELL_CHAR_PLAN_SRC AS (
								-- 과거 BOH 참조
								SELECT BH.OPERATION_GROUP
									  ,BH.ITEM_ID
									  ,BH.FROM_SITE
									  ,@V_PLAN_START_YYYYPW AS YYYYPW
									  ,BH.CHAR_AVAILABLE + BH.FORM_PROGRESS AS QTY 
								 FROM #PAST_FORM_PROGRESS_CHAR_AVAILABLE BH WITH(NOLOCK)
									  --INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK)
											--  ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간
								WHERE 1=1
								  AND BH.YYYYPW = @V_RESULT_LAST_YYYYPW
								  AND @V_PLAN_START_YYYYPW = @CUR_FORM$CUR_YYYYPW
								UNION ALL
								-- CELL_PROD_FORM_END : From. End Eta (Prod)
								SELECT FF.OPERATION_GROUP
									  ,FF.ITEM_ID
									  ,FF.FROM_SITE
									  ,FF.YYYYPW
									  ,FF.QTY
								 FROM #CELL_PROD_FORM_END FF
								WHERE 1=1
								AND   FF.YYYYPW = @CUR_FORM$CUR_YYYYPW
							)
							INSERT INTO #CELL_CHAR_PLAN_FUTURE
							SELECT CP.OPERATION_GROUP
								  ,CP.ITEM_ID
								  ,'-'						AS TO_SITE 
								  ,'-'						AS INCOTERMS
								  ,CP.FROM_SITE
								  ,'-'						AS VARIOUS_KEY
								  ,CP.YYYYPW
								  ,'CELL_CHAR_PLAN'	AS MEASURE 
								  ,'N'						AS IS_CELL_IN_PACK_PLANT
								  ,0.0						AS FROM_BOH_QTY
								  ,0.0						AS TO_BOH_QTY
								  ,SUM(QTY) 
									* CASE WHEN ISNULL(FY.SSP_MODIFY_YIELD, 0) > 0		THEN FY.SSP_MODIFY_YIELD
										   WHEN ISNULL(FY.FORMATION_TOTAL_YIELD, 0) > 0	THEN FY.FORMATION_TOTAL_YIELD
										   ELSE 1
									   END AS QTY
							 
							 FROM CELL_CHAR_PLAN_SRC CP 
								  LEFT JOIN #SCP_MST_FORMATION FY WITH(NOLOCK)
										 ON FY.PLANT_SITE_ID	= CP.FROM_SITE
										AND FY.ITEM_ID			= CP.ITEM_ID 
										AND FY.YYYYPW			= CP.YYYYPW
							WHERE 1=1 
							AND CP.YYYYPW = @CUR_FORM$CUR_YYYYPW
							GROUP BY 
								   CP.OPERATION_GROUP
								  ,CP.ITEM_ID
								  ,CP.FROM_SITE
								  ,CP.YYYYPW
								  ,CASE WHEN ISNULL(FY.SSP_MODIFY_YIELD, 0) > 0			THEN FY.SSP_MODIFY_YIELD
										WHEN ISNULL(FY.FORMATION_TOTAL_YIELD, 0) > 0	THEN FY.FORMATION_TOTAL_YIELD
										ELSE 1
									END
							
							
		
							;WITH CHAR_PLAN AS (
								SELECT PG.OPERATION_GROUP
									  ,PG.ITEM_ID
									  ,PG.FROM_SITE
									  ,PG.YYYYPW
									  ,SUM(QTY)	AS QTY 
								-- FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK)
								 FROM #CELL_CHAR_PLAN_FUTURE PG WITH(NOLOCK)
								WHERE 1=1
								  AND PG.MEASURE = 'CELL_CHAR_PLAN'			-- 특성(F6000) 생산계획 -- CELL_CHAR_PLAN 
								  AND PG.YYYYPW =  @CUR_FORM$CUR_YYYYPW	-- 미래 계획 구간
								GROUP BY 
									   PG.OPERATION_GROUP
									  ,PG.ITEM_ID
									  ,PG.FROM_SITE
									  ,PG.YYYYPW
							)
							INSERT INTO #CELL_CHAR_PLAN_YIELD
							SELECT CP.*
								  ,CASE WHEN ISNULL(FY.SSP_MODIFY_YIELD, 0) > 0			THEN FY.SSP_MODIFY_YIELD
										WHEN ISNULL(FY.FORMATION_TOTAL_YIELD, 0) > 0	THEN FY.FORMATION_TOTAL_YIELD
										ELSE 1
									END AS YIELD
								  ,CP.QTY / CASE WHEN ISNULL(FY.SSP_MODIFY_YIELD, 0) > 0		THEN FY.SSP_MODIFY_YIELD
												 WHEN ISNULL(FY.FORMATION_TOTAL_YIELD, 0) > 0	THEN FY.FORMATION_TOTAL_YIELD
												 ELSE 1
											END 	AS QTY_YIELD
							
							 FROM CHAR_PLAN CP 
								  LEFT JOIN #SCP_MST_FORMATION FY WITH(NOLOCK)
										 ON FY.PLANT_SITE_ID	= CP.FROM_SITE
										AND FY.ITEM_ID			= CP.ITEM_ID
										AND FY.YYYYPW			= CP.YYYYPW 
							WHERE 1=1
						
					 
							;WITH CHAR_AVAILABE_SRC AS (
								-- ENDING INVENTORY BOH 사용	-- 고도화 
								SELECT BH.OPERATION_GROUP
									  ,BH.ITEM_ID
									  ,BH.FROM_SITE
									  ,@V_PLAN_START_YYYYPW AS YYYYPW
									  ,BH.CHAR_AVAILABLE + BH.FORM_PROGRESS AS QTY 
								 FROM #PAST_FORM_PROGRESS_CHAR_AVAILABLE BH WITH(NOLOCK)
								WHERE 1=1
								  AND BH.YYYYPW = @V_RESULT_LAST_YYYYPW
								  AND @V_PLAN_START_YYYYPW = @CUR_FORM$CUR_YYYYPW
								UNION ALL
								-- CELL_PROD_FORM_END : From. End Eta (Prod)
								SELECT FF.OPERATION_GROUP
									  ,FF.ITEM_ID
									  ,FF.FROM_SITE
									  ,FF.YYYYPW
									  ,SUM(FF.QTY) 
											--OVER (PARTITION BY FF.ITEM_ID
											--						 ,FF.FROM_SITE
											--				 ORDER BY FF.YYYYMM)	AS QTY
								 FROM #CELL_PROD_FORM_END FF
								WHERE 1=1
								 AND FF.YYYYPW >= @CUR_FORM$CUR_YYYYPW
								 AND FF.YYYYPW BETWEEN @CUR_FORM$PREV_YYYYPW AND @CUR_FORM$CUR_YYYYPW
								 group by FF.OPERATION_GROUP
									  ,FF.ITEM_ID
									  ,FF.FROM_SITE
									  ,FF.YYYYPW
								UNION ALL
								-- CELL_CHAR_PLAN : Char. Plan 
								SELECT CP.OPERATION_GROUP
									  ,CP.ITEM_ID
									  ,CP.FROM_SITE
									  ,CP.YYYYPW
									  ,(-1) * SUM(CP.QTY_YIELD) 
						  											--OVER (PARTITION BY CP.ITEM_ID
																			--	  ,CP.FROM_SITE
																	  -- ORDER BY CP.YYYYMM) AS QTY 
								 FROM #CELL_CHAR_PLAN_YIELD CP WITH(NOLOCK)
								 WHERE 1=1
								  AND CP.YYYYPW >= @CUR_FORM$CUR_YYYYPW
								  AND CP.YYYYPW BETWEEN @CUR_FORM$PREV_YYYYPW AND @CUR_FORM$CUR_YYYYPW
								  group by CP.OPERATION_GROUP
									  ,CP.ITEM_ID
									  ,CP.FROM_SITE
									  ,CP.YYYYPW
							)
							INSERT INTO #TMP_ASIS_GLOBAL_PSI
							SELECT CA.OPERATION_GROUP
								  ,CA.ITEM_ID
								  ,'-'						AS TO_SITE 
								  ,'-'						AS INCOTERMS
								  ,CA.FROM_SITE
								  ,'-'						AS VARIOUS_KEY
								  ,CA.YYYYPW
								  ,'CELL_CHAR_AVAILABLE'	AS MEASURE 
								  ,'N'						AS IS_CELL_IN_PACK_PLANT
								  ,0.0						AS FROM_BOH_QTY
								  ,0.0						AS TO_BOH_QTY
								  ,SUM(QTY) AS QTY
							 FROM CHAR_AVAILABE_SRC CA 
							WHERE 1=1 
							GROUP BY 
								   CA.OPERATION_GROUP
								  ,CA.ITEM_ID
								  ,CA.FROM_SITE
								  ,CA.YYYYPW

							--print  convert(varchar(30), getdate(), 121) + '::' + @CUR_FORM$CUR_YYYYPW
		---SSSS
							IF @CUR_FORM$CUR_YYYYPW = CONVERT(NVARCHAR(8), @V_HORIZON_END_YYYYPW)
							BREAK
						END
		
						FETCH NEXT FROM CUR_FORM INTO @CUR_FORM$CUR_YYYYPW, @CUR_FORM$PREV_YYYYPW ;
					END
		
				CLOSE CUR_FORM
		
		DEALLOCATE CUR_FORM

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Char. Plan  measure 추가 (임시) - insert '
		----------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT *
		FROM #CELL_CHAR_PLAN_FUTURE
		
-- END : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다. 
-- END : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다.		

		-----------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### Cell/Pack 및 FG/SEMI Measure 분리' 
		-----------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#TMP_TOBE_GLOBAL_PSI') IS NOT NULL
			DROP TABLE #TMP_TOBE_GLOBAL_PSI;
		
		SELECT PG.YYYYPW
			  ,PG.ITEM_ID
			  ,CASE WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.IS_CELL_IN_PACK_PLANT = 'Y'	THEN 'PACK_CELL_EOH'
					WHEN PG.MEASURE = 'MODEL_INVENTORY'	AND PG.OPERATION_GROUP = 'A'	THEN 'CELL_EOH'
					WHEN PG.MEASURE = 'MODEL_INVENTORY'	AND PG.OPERATION_GROUP = 'P'	THEN 'PACK_EOH'
					WHEN PG.MEASURE = 'PRODUCTION'		AND PG.OPERATION_GROUP = 'A'	THEN 'CELL_PROD'
					WHEN PG.MEASURE = 'PRODUCTION'		AND PG.OPERATION_GROUP = 'P'	THEN 'PACK_PROD'
					WHEN PG.MEASURE = 'SHIP_PLAN'		AND TS.SITE_TYPE = 'SALES'		THEN 'SHIP_PLAN'
					WHEN PG.MEASURE = 'SHIP_PLAN'		AND TS.SITE_TYPE = 'PLANT'		THEN 'SEMI_SHIP_PLAN'
					WHEN PG.MEASURE = 'WH_IN'			AND TS.SITE_TYPE = 'SALES'		THEN 'WHIN'
					WHEN PG.MEASURE = 'WH_IN'			AND TS.SITE_TYPE = 'PLANT'		THEN 'SEMI_WHIN'
					ELSE PG.MEASURE
				END AS MEASURE
			  ,PG.FROM_SITE
			  ,CASE WHEN PG.TO_SITE = '' 
					THEN '-'
					ELSE PG.TO_SITE 
			   END AS TO_SITE 
			  ,CASE WHEN PG.INCOTERMS = '' 
					THEN '-'
					ELSE PG.INCOTERMS 
			   END AS INCOTERMS 
			  ,CASE WHEN PG.TRANSPORT_MODE_LINE = '' 
					THEN '-'
					ELSE PG.TRANSPORT_MODE_LINE 
			   END AS VARIOUS_KEY 
			  ,PG.OPERATION_GROUP
			  ,ISNULL(TS.SITE_TYPE, '-')	AS TO_SITE_TYPE
			  ,SUM(PG.FROM_BOH_QTY)			AS FROM_BOH_QTY
			  ,SUM(PG.TO_BOH_QTY)			AS TO_BOH_QTY
			  ,SUM(PG.QTY)					AS QTY
		 INTO #TMP_TOBE_GLOBAL_PSI	
		 FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK)
			  LEFT JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					 ON TS.SCM_SITE_ID = PG.TO_SITE 
		WHERE 1=1
		GROUP BY PG.YYYYPW
			  ,PG.ITEM_ID
			  ,CASE WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.IS_CELL_IN_PACK_PLANT = 'Y'	THEN 'PACK_CELL_EOH'
					WHEN PG.MEASURE = 'MODEL_INVENTORY'	AND PG.OPERATION_GROUP = 'A'		THEN 'CELL_EOH'
					WHEN PG.MEASURE = 'MODEL_INVENTORY'	AND PG.OPERATION_GROUP = 'P'		THEN 'PACK_EOH'
					WHEN PG.MEASURE = 'PRODUCTION'		AND PG.OPERATION_GROUP = 'A'		THEN 'CELL_PROD'
					WHEN PG.MEASURE = 'PRODUCTION'		AND PG.OPERATION_GROUP = 'P'		THEN 'PACK_PROD'
					WHEN PG.MEASURE = 'SHIP_PLAN'		AND TS.SITE_TYPE = 'SALES'			THEN 'SHIP_PLAN'
					WHEN PG.MEASURE = 'SHIP_PLAN'		AND TS.SITE_TYPE = 'PLANT'			THEN 'SEMI_SHIP_PLAN'
					WHEN PG.MEASURE = 'WH_IN'			AND TS.SITE_TYPE = 'SALES'			THEN 'WHIN'
					WHEN PG.MEASURE = 'WH_IN'			AND TS.SITE_TYPE = 'PLANT'			THEN 'SEMI_WHIN'
					ELSE PG.MEASURE
				END 
			  ,PG.FROM_SITE
			  ,CASE WHEN PG.TO_SITE = '' 
					THEN '-'
					ELSE PG.TO_SITE 
			   END --AS TO_SITE 
			  ,CASE WHEN PG.INCOTERMS = '' 
					THEN '-'
					ELSE PG.INCOTERMS 
			   END -- AS INCOTERMS 
			  ,CASE WHEN PG.TRANSPORT_MODE_LINE = '' 
					THEN '-'
					ELSE PG.TRANSPORT_MODE_LINE 
			   END --AS ETC 
			  ,PG.OPERATION_GROUP
			  ,ISNULL(TS.SITE_TYPE, '-')
		;

		
		-- ESST_CA_WND 향 SEMI 강제 등록(semi_whin, semi_intransit 만 조정) 저장 위치 중요
		-- 품번, to_site 제외하고 81물량 다 넣어준다
		INSERT INTO #TMP_TOBE_GLOBAL_PSI
		SELECT PG.YYYYPW 
			 , PG.ITEM_ID
			 , 'SEMI_WHIN' AS MEASURE
			 , PG.FROM_SITE
			 , PG.TO_SITE
			 , PG.INCOTERMS
			 , PG.VARIOUS_KEY
			 , PG.OPERATION_GROUP 
			 , 'PLANT_' AS TO_SITE_TYPE	-- SEMI INTRANSIT 에서 제외하기 위해서( #WHIN_FOR_SEMI_INTRANSIT 에서 to_site_type 으로 거른다.)
			 , PG.FROM_BOH_QTY
			 , PG.TO_BOH_QTY	
			 , PG.QTY
		FROM SCP_RPT_GLOBAL_PSI_MD_WW PG WITH(NOLOCK)		-- 81부터 계산되어 있어서 가져다 쓴다. 
		WHERE 1= (CASE WHEN @V_DIVISION_ID = '81_ST' THEN 1 ELSE 0 END)
		  AND PG.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		  AND PG.DIVISION_ID			= '81'
		  AND PG.MEASURE				= 'WHIN'
		  AND PG.CELL_GROUP				= 'E131B'
		  --AND PG.ITEM_ID				LIKE 'ACEH1131I-B1%'
		  --AND PG.TO_SITE				= 'ESST_CA_WND'
		  AND PG.QTY					<> 0
		  ;


-- START : 실적 Measure #TMP_TOBE_GLOBAL_PSI Measure 입력			  
-- START : 실적 Measure #TMP_TOBE_GLOBAL_PSI Measure 입력
-- 실적 메져 입력 시 #TMP_TOBE_GLOBAL_PSI 을 사용하는 메져가 있어 위치 변경 
		-----------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 실적 구간 #TMP_TOBE_GLOBAL_PSI 입력 메져 위치 이동 '	--@@@ 
		-----------------------------------------------------------------------------------------------------
		
				-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  - semi ship plan site' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#ITEM_SEMI_SHIP_SITE') IS NOT NULL	
			DROP TABLE #ITEM_SEMI_SHIP_SITE;

		SELECT SS.ITEM_ID
			  ,SS.TO_SITE			AS PACK_SITE
			  ,MAX(CASE WHEN SS.YYYYPW <   @V_PLAN_START_YYYYPW THEN SS.FROM_SITE ELSE NULL END)	AS CELL_SITE_PAST
			  ,MAX(CASE WHEN SS.YYYYPW >=  @V_PLAN_START_YYYYPW THEN SS.FROM_SITE ELSE NULL END)	AS CELL_SITE_FUTURE
		INTO #ITEM_SEMI_SHIP_SITE
		FROM #TMP_TOBE_GLOBAL_PSI SS with(nolock)
			 INNER JOIN #SCM_MST_SITE PS WITH(NOLOCK) -- pack site 
					 ON PS.SCM_SITE_ID		= SS.TO_SITE 
					AND PS.OPERATION_GROUP	= 'P'
			 INNER JOIN #SCM_MST_SITE CS WITH(NOLOCK)	-- cell site 
					 ON CS.SCM_SITE_ID		= SS.FROM_SITE 
					AND CS.OPERATION_GROUP	= 'A'
		WHERE 1=1
		  AND SS.MEASURE = 'SEMI_SHIP_PLAN'
		  AND SS.QTY != 0 
		GROUP BY SS.ITEM_ID
				,SS.TO_SITE

				
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 1 (수율)'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_1') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_1;

		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE
			  ,PR.OPERATION_GROUP
			  ,SUM(PR.ACTUAL_GOOD_QTY) 	AS PACK_PROD_QTY 
			  ,SUM(PR.ACTUAL_GOOD_QTY 
					/ CASE WHEN ISNULL(PY.YIELD,0) > 0 
						   THEN PY.YIELD
						   ELSE 1.0
					  END )	AS PACK_PROD_YIELD_QTY 
		  INTO #PACK_PRODUCTION_RESULT_1
		  FROM #PRODUCTION_RESULT PR WITH(NOLOCK)
			   INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					   ON WL.PW_FROM_YMD <= PR.PLAN_YYYYMMDD
					  AND WL.PW_TO_YMD   >= PR.PLAN_YYYYMMDD
			   LEFT JOIN SCP_MST_TACT_TIME_EXCEPT PY WITH(NOLOCK) 
					  ON PY.DIVISION_ID		= @V_DIVISION_ID
					 AND PY.PLANT_SITE_ID	= PR.FROM_SITE
					 AND PY.ITEM_ID			= PR.ITEM_ID
					 AND PY.OPERATION_ID	= PR.OPERATION_ID
					 AND PY.LINE_ID			= PR.LINE_ID 
					 AND PY.TACT_TIME_START_DATE <= PR.PLAN_YYYYMMDD
					 AND PY.TACT_TIME_END_DATE   >= PR.PLAN_YYYYMMDD
		WHERE 1=1
		  AND PR.OPERATION_GROUP = 'P' -- 팩 생산 실적 (실적구간) 
		GROUP BY 
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE
			  ,PR.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 2 (0채움)'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_2') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_2;

		-- 실적구간 - Cell 도착 (to Plant) - to 사이트 기준 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.OPERATION_GROUP
			  ,PR.FROM_SITE 	
			  ,SUM(CASE WHEN PR.YYYYMM = WL.YYYYMM AND PR.YYYYPW = WL.YYYYPW	-- 20240327 누적아닌 해당 주차
						THEN PR.PACK_PROD_QTY
						ELSE 0.0 
				   END)	AS PACK_PROD_QTY
			  ,SUM(CASE WHEN PR.YYYYMM = WL.YYYYMM AND PR.YYYYPW = WL.YYYYPW	-- 20240327 누적아닌 해당 주차
						THEN PR.PACK_PROD_YIELD_QTY
						ELSE 0.0 
				   END)	AS PACK_PROD_YIELD_QTY
		 INTO #PACK_PRODUCTION_RESULT_2
		 FROM #PACK_PRODUCTION_RESULT_1 PR WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.OPERATION_GROUP
			  ,PR.FROM_SITE 	


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 3 (대표cell * 셀환산계수)'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_3') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_3;

		SELECT CASE WHEN MI.MODEL_ID IS NOT NULL									-- AMDAU% 모듈 
					THEN MI.CELL_ITEM_ID
					WHEN PR.OPERATION_GROUP = 'P'	AND CI.CELL_ITEM_ID IS NOT NULL	-- Pack
					THEN CI.CELL_ITEM_ID
					WHEN PR.OPERATION_GROUP = 'P'	AND EC.CELL_ITEM_ID IS NOT NULL	-- Pack
					THEN EC.CELL_ITEM_ID
					ELSE NULL
			   END  AS REP_CELL_ITEM_ID		-- 대표셀 (CP:Cell Product) 모델 
			  ,CASE WHEN CF.CELL_CF		IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF.CELL_CF)
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF2.CELL_CF)
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF3.CELL_CF)
					ELSE CONVERT(NUMERIC(20,10), '1.0')
			   END  AS CELL_CF 
			  ,CASE WHEN CF.CELL_CF		IS NOT NULL		THEN 'CF'
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN 'CF2'
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN 'CF3'
					ELSE 'NULL'
			   END  AS CELL_CF_TYPE 
			   ,MI.MODULE_ID
			   ,PR.*
		 INTO #PACK_PRODUCTION_RESULT_3
		 FROM #PACK_PRODUCTION_RESULT_2 PR  WITH(NOLOCK)
			  LEFT JOIN #MODULE_MODEL_INFO MI WITH(NOLOCK)
					 ON MI.MODULE_ID		= PR.ITEM_ID
			  LEFT JOIN #CP_CELL_ITEM_INFO CI WITH(NOLOCK)
					 ON CI.MODEL_ID = CASE WHEN MI.MODEL_ID IS NOT NULL		-- AMDAU% 모듈
										   THEN MI.MODEL_ID
										   WHEN PR.OPERATION_GROUP = 'P'	-- 팩
										   THEN PR.ITEM_ID
										   ELSE ''
									  END 
			  LEFT  JOIN #ETC_CP_CELL_INFO EC WITH(NOLOCK)
					  ON EC.PARENT_ITEM_ID = PR.ITEM_ID
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF WITH(NOLOCK)
					  ON CF.ITEM_ID		= PR.ITEM_ID
					 AND CF.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF.CELL_CF) != 0.0
			 LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF2 WITH(NOLOCK)
					  ON CF2.ITEM_ID	   = LEFT(PR.ITEM_ID, LEN(PR.ITEM_ID) - 2) 
					 AND PR.ITEM_ID LIKE '%-_'
					 AND PR.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF IS NULL 
					 AND CF2.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF2.CELL_CF) != 0.0
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF3 WITH(NOLOCK)
					  ON CF3.ITEM_ID	   = LEFT(PR.ITEM_ID, LEN(PR.ITEM_ID) - 3) 
					 AND PR.ITEM_ID LIKE '%-__'
					 AND PR.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF  IS NULL 
					 AND CF2.CELL_CF IS NULL 
					 AND CF3.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF3.CELL_CF) != 0.0
		WHERE 1=1

		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 공장내 이동 물량 : SEMI SHIP_PLAN, SEMI WH_IN measure 계산 ' 
		-- 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_TOBE_GLOBAL_PSI
		SELECT	PR.YYYYPW, PR.ITEM_ID, MM.MEASURE, PR.FROM_SITE, PR.TO_SITE, PR.INCOTERMS, PR.VARIOUS_KEY, PR.OPERATION_GROUP, PR.TO_SITE_TYPE
				,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
				,SUM(TO_BOH_QTY) AS TO_BOH_QTY
				,SUM(QTY) AS QTY
		FROM	(
					SELECT	PR.YYYYPW
							,PR.REP_CELL_ITEM_ID AS ITEM_ID
							,ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE))	AS FROM_SITE -- CELL PLANT 
							, PP.PLANT_ID+'-P' AS TO_SITE
							,'-' AS INCOTERMS
							,'-' AS VARIOUS_KEY
							,'A'						AS OPERATION_GROUP 
							,'PLANT' AS TO_SITE_TYPE
							,0.0						AS FROM_BOH_QTY
							,0.0						AS TO_BOH_QTY
							,PR.PACK_PROD_YIELD_QTY * ISNULL(PR.CELL_CF,1)				AS QTY
					FROM #PACK_PRODUCTION_RESULT_3 PR WITH(NOLOCK)
						INNER JOIN #SCM_MST_SITE PP WITH(NOLOCK)	-- PACK PLANT SITE 
								ON PP.SCM_SITE_ID		= PR.FROM_SITE
						LEFT JOIN #SCM_MST_SITE CP WITH(NOLOCK)	-- CELL PLANT SITE 
								ON CP.PLANT_ID		= PP.PLANT_ID
								AND CP.OPERATION_GROUP = 'A'
								AND CP.SITE_TYPE		= 'PLANT'
						LEFT  JOIN #ITEM_SEMI_SHIP_SITE SS WITH(NOLOCK)
								ON SS.ITEM_ID			= PR.ITEM_ID 
								AND SS.PACK_SITE		= PP.SCM_SITE_ID -- PACK SITE 
							
				WHERE 1=1
					--- 20240327 불필요 조건 삭제 
					AND ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE)) IS NOT NULL
					AND PR.PACK_PROD_YIELD_QTY > 0
					AND PR.YYYYPW < @V_PLAN_START_YYYYPW  -- 과거 실적 구간
					AND PR.REP_CELL_ITEM_ID IS NOT NULL
			) PR
			INNER JOIN (
				SELECT 'SEMI_SHIP_PLAN' AS MEASURE UNION SELECT 'SEMI_WHIN' AS MEASURE
			) MM
			ON 1=1
		WHERE 1=1
		AND NOT EXISTS (
							SELECT *
							FROM #TMP_TOBE_GLOBAL_PSI X
							WHERE 1=1
							--AND X.MEASURE IN ('SEMI_WHIN', 'SEMI_SHIP_PLAN')
							AND X.MEASURE IN ('SEMI_WHIN') -- 해당기준으로만 데이타 생성
							AND X.YYYYPW < @V_PLAN_START_YYYYPW  -- 과거 실적 구간
							AND X.YYYYPW = PR.YYYYPW
							AND X.ITEM_ID = PR.ITEM_ID
							--AND X.MEASURE = MM.MEASURE
							--AND X.FROM_SITE = PR.FROM_SITE
							AND X.OPERATION_GROUP = PR.OPERATION_GROUP
							
						)
		GROUP BY PR.YYYYPW, PR.ITEM_ID, MM.MEASURE, PR.FROM_SITE, PR.TO_SITE, PR.INCOTERMS, PR.VARIOUS_KEY, PR.OPERATION_GROUP, PR.TO_SITE_TYPE

		MERGE #TMP_TOBE_GLOBAL_PSI AS PR
          USING (
						SELECT	PR.YYYYPW, PR.ITEM_ID, MM.MEASURE, PR.FROM_SITE, PR.TO_SITE, PR.INCOTERMS, PR.VARIOUS_KEY, PR.OPERATION_GROUP, PR.TO_SITE_TYPE
								,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
								,SUM(TO_BOH_QTY) AS TO_BOH_QTY
								,SUM(QTY) AS QTY
						FROM	(
									SELECT	PR.YYYYPW
											,PR.REP_CELL_ITEM_ID AS ITEM_ID
											,ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE))	AS FROM_SITE -- CELL PLANT 
											, PP.PLANT_ID+'-P' AS TO_SITE
											,'-' AS INCOTERMS
											,'-' AS VARIOUS_KEY
											,'A'						AS OPERATION_GROUP 
											,'PLANT' AS TO_SITE_TYPE
											,0.0						AS FROM_BOH_QTY
											,0.0						AS TO_BOH_QTY
											,PR.PACK_PROD_YIELD_QTY * ISNULL(PR.CELL_CF,1)				AS QTY
									FROM #PACK_PRODUCTION_RESULT_3 PR WITH(NOLOCK)
										INNER JOIN #SCM_MST_SITE PP WITH(NOLOCK)	-- PACK PLANT SITE 
												ON PP.SCM_SITE_ID		= PR.FROM_SITE
										LEFT JOIN #SCM_MST_SITE CP WITH(NOLOCK)	-- CELL PLANT SITE 
												ON CP.PLANT_ID		= PP.PLANT_ID
												AND CP.OPERATION_GROUP = 'A'
												AND CP.SITE_TYPE		= 'PLANT'
										LEFT  JOIN #ITEM_SEMI_SHIP_SITE SS WITH(NOLOCK)
												ON SS.ITEM_ID			= PR.ITEM_ID 
												AND SS.PACK_SITE		= PP.SCM_SITE_ID -- PACK SITE 
							
								WHERE 1=1
									AND ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE)) IS NOT NULL
									AND PR.PACK_PROD_YIELD_QTY > 0
									AND PR.YYYYPW = @V_PLAN_START_YYYYPW  
									AND PR.REP_CELL_ITEM_ID IS NOT NULL
							) PR
							INNER JOIN (
								SELECT 'SEMI_SHIP_PLAN' AS MEASURE UNION SELECT 'SEMI_WHIN' AS MEASURE
							) MM
							ON 1=1
						WHERE 1=1
						GROUP BY PR.YYYYPW, PR.ITEM_ID, MM.MEASURE, PR.FROM_SITE, PR.TO_SITE, PR.INCOTERMS, PR.VARIOUS_KEY, PR.OPERATION_GROUP, PR.TO_SITE_TYPE
          			) AS X
				ON 	1=1
				AND X.YYYYPW	= PR.YYYYPW
				AND X.ITEM_ID	= PR.ITEM_ID
				AND X.MEASURE	= PR.MEASURE
				AND X.OPERATION_GROUP = PR.OPERATION_GROUP
				AND X.FROM_SITE = PR.FROM_SITE
				AND X.TO_SITE	= PR.TO_SITE
				AND X.INCOTERMS = PR.INCOTERMS
				AND X.VARIOUS_KEY = PR.VARIOUS_KEY
          WHEN MATCHED  THEN
				UPDATE	SET	PR.QTY = ISNULL(PR.QTY,0) + ISNULL(X.QTY,0)
		  WHEN NOT MATCHED THEN
				INSERT (
						 YYYYPW
						,ITEM_ID
						,MEASURE
						,FROM_SITE
						,TO_SITE
						,INCOTERMS
						,VARIOUS_KEY
						,OPERATION_GROUP
						,TO_SITE_TYPE
						,FROM_BOH_QTY
						,TO_BOH_QTY
						,QTY
					   )
				VALUES (
						 X.YYYYPW
						,X.ITEM_ID
						,X.MEASURE
						,X.FROM_SITE
						,X.TO_SITE
						,X.INCOTERMS
						,X.VARIOUS_KEY
						,X.OPERATION_GROUP
						,X.TO_SITE_TYPE
						,X.FROM_BOH_QTY
						,X.TO_BOH_QTY
						,X.QTY
					  ) ;
		
					 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : TO_SITE_EOH(VMI) measure 추가' 
		-- 전주 재고(EOH)+ 금주도착(WH In) - 매출(RTF)
		-- 실적구간 고객향 도착 실적은 매출(RTF)과 동일함
		-- 당월 마지막 주를 제외하고 모두 전월 EOH와 동일함. 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT WI.YYYYPW
			  ,WI.ITEM_ID
			  ,WI.MEASURE
			  ,WI.FROM_SITE
			  ,WI.TO_SITE
			  ,'-'		AS INCOTERMS
			  ,'-'		AS VARIOUS_KEY
			  ,WI.OPERATION_GROUP
			  ,'-'		AS TO_SITE_TYPE
			  ,0.0		AS FROM_BOH_QTY
			  ,0.0		AS TO_BOH_QTY
			  ,CASE WHEN WI.PW_TO_YMD = WI.YYYYMM_LAST_YMD		-- 주 마지막일이 당월 마지막 일과 같을 경우 
					THEN MI.QTY									-- 당월말 재고
					ELSE WI.YYYYMM_PRVS_QTY						-- 전월말 재고 (기초재고)
			   END		AS QTY
		FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK)  
			  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)			-- 당월말 재고 참조   
					 ON WI.YYYYMM		= MI.YYYYMM		
					AND WI.ITEM_ID		= MI.ITEM_ID	
					AND WI.FROM_SITE	= MI.FROM_SITE
					AND WI.TO_SITE		= MI.TO_SITE 
					AND WI.MEASURE		= MI.MEASURE 
		WHERE 1=1
		  AND WI.MEASURE = 'TO_SITE_EOH'

		
		  
		

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant)' 
		-- 전주 재고(Intransit)  + 금주출하(Ship Plan) - 금주도착(WH In)
		-- 전월말 재고를 기초로 하여 당월 출하(Ship Plan)와 도착(Wh In) 누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_SEMI_INTRANSIT') IS NOT NULL	
			DROP TABLE #SHIP_FOR_SEMI_INTRANSIT;

		-- 실적구간 - 출하 (to Plant)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_SEMI_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE		= 'SEMI_SHIP_PLAN'
		  AND WI.TO_SITE_TYPE	= 'PLANT'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE

	
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) - 도착'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#WHIN_FOR_SEMI_INTRANSIT') IS NOT NULL	
			DROP TABLE #WHIN_FOR_SEMI_INTRANSIT;

		-- 실적구간 -  도착 (to Plant)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			 ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_WHIN_QTY 
		 INTO #WHIN_FOR_SEMI_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE		= 'SEMI_WHIN'
		  AND WI.TO_SITE_TYPE	= 'PLANT'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - semi Intransit 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.TO_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'SEMI_INTRANSIT'
			UNION ALL 
			-- 실적구간 - 출하(SEMI) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #SHIP_FOR_SEMI_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - 도착(SEMI) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_EXFACTORY_QTY
				  ,MM_ACC_WHIN_QTY	AS MM_ACC_WHIN_QTY
			 FROM #WHIN_FOR_SEMI_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'SEMI_INTRANSIT'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,'-'			AS INCOTERMS
			  ,'-'			AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'PLANT'		AS TO_SITE_TYPE
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_EXFACTORY_QTY) - SUM(MM_ACC_WHIN_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,BD.OPERATION_GROUP
			  
			  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales)' 
		-- 전주 재고(Intransit)  + 금주출하(Ship Plan) - 금주도착(WH In)
		-- 전월말 재고를 기초로 하여 당월 출하(Ship Plan)와 도착(Wh In) 누적 정보를 적용하여 계산 
		-- 고객향(to Sales)  도착(WH In) 실적은 매출(RTF)로 적용함.
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) - 도착'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#WHIN_FOR_INTRANSIT') IS NOT NULL	
			DROP TABLE #WHIN_FOR_INTRANSIT;

		-- 실적구간 -  도착 (to sales)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_WHIN_QTY 
		 INTO #WHIN_FOR_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE		= 'WHIN'
		  AND WI.TO_SITE_TYPE	= 'SALES'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_INTRANSIT') IS NOT NULL	
			DROP TABLE #SHIP_FOR_INTRANSIT;

		-- 실적구간 - 출하 (to sales)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE		= 'SHIP_PLAN'
		  AND WI.TO_SITE_TYPE	= 'SALES'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			 ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - Intransit 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.TO_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'INTRANSIT'
			UNION ALL 
			-- 실적구간 - 출하(FG) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #SHIP_FOR_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - 도착(FG) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_EXFACTORY_QTY
				  ,MM_ACC_WHIN_QTY	AS MM_ACC_WHIN_QTY
			 FROM #WHIN_FOR_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'INTRANSIT'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,'-'			AS INCOTERMS
			  ,'-'			AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'SALES'		AS TO_SITE_TYPE
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_EXFACTORY_QTY) - SUM(MM_ACC_WHIN_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
			  LEFT JOIN #SCM_MST_SITE TS 
					 ON TS.SCM_SITE_ID = BD.TO_SITE
		WHERE 1=1
		  AND ISNULL(TS.OPERATION_GROUP, '') != 'W' -- to AS Sales Site 제외
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,BD.OPERATION_GROUP


		----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Intransit 재고(EOH) 계산 참조를 위한 intransit 기초 재고' 
		----------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#INTRANSIT_BOH') IS NOT NULL
			DROP TABLE #INTRANSIT_BOH;

		SELECT SUBSTRING(ES.LOT_ID, DBO.FN_CHARINDEX_REV(ES.LOT_ID, '::', 0)+2,100)					AS FROM_SITE 
			  ,SUBSTRING(ES.SITE_ID, 1, DBO.FN_CHARINDEX_REV(ES.SITE_ID, '~', 0)-1)					AS TO_SITE 
			  ,SUBSTRING(ES.SITE_ID, DBO.FN_CHARINDEX_REV(ES.SITE_ID, '~', 0)+1, LEN(ES.SITE_ID))	AS INCOTERMS 
			  ,ES.ITEM_ID
			  ,SUM(ES.QTY)																			AS INT_BOH_QTY
		 INTO #INTRANSIT_BOH
		 FROM #SCP_PLN_TH_ENG_STOCK_PLAN ES WITH(NOLOCK) 
		WHERE 1=1
		  AND ES.DESCR		= 'INT'				-- intransit 해상재고 
		GROUP BY SUBSTRING(ES.LOT_ID,	DBO.FN_CHARINDEX_REV(ES.LOT_ID, '::', 0)+2,100)
				,SUBSTRING(ES.SITE_ID, 1, DBO.FN_CHARINDEX_REV(ES.SITE_ID, '~', 0)-1)
				,SUBSTRING(ES.SITE_ID, DBO.FN_CHARINDEX_REV(ES.SITE_ID, '~', 0)+1, LEN(ES.SITE_ID))
				,ES.ITEM_ID


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Intransit 재고(EOH) 계산' 
		-- Intransit(EOH) = 해당월 Intransit BOH(전월 Intransit EOH) + 출하(ship plan) - 입고(wh in)
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#INTRANSIT') IS NOT NULL
			DROP TABLE #INTRANSIT;
		
		/*
		SELECT PG.FROM_SITE
			  ,PG.TO_SITE
			  ,PG.ITEM_ID
			  ,PG.INCOTERMS
			  ,DI.YYYYPW
			  ,ISNULL(BO.INT_BOH_QTY, CONVERT(NUMERIC(20,10), 0))					AS INT_BOH_QTY	-- plan date 기준 int boh 
			  ,ISNULL(BO.INT_BOH_QTY, CONVERT(NUMERIC(20,10), 0))									
			   -SUM(SUM(CASE WHEN PG.MEASURE = 'WH_IN'	THEN QTY	ELSE 0	END))	OVER (PARTITION BY PG.FROM_SITE
																										  ,PG.TO_SITE
																										  ,PG.ITEM_ID
																										  ,PG.INCOTERMS
																								  ORDER BY DI.YYYYPW)
			   +SUM(SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN' THEN QTY		ELSE 0	END))	OVER (PARTITION BY PG.FROM_SITE
																										  ,PG.TO_SITE
																										  ,PG.ITEM_ID
																										  ,PG.INCOTERMS
																								  ORDER BY DI.YYYYPW)	AS INT_EOH_QTY -- 해당월 기준 int eoh  (기초재고 - 당월까지 WH In(누적) + 당월까지 Ship Plan(누적)) 
			  ,SUM(CASE WHEN PG.MEASURE = 'WH_IN'		THEN QTY	ELSE 0	END)	AS WH_IN
			  ,SUM(SUM(CASE WHEN PG.MEASURE = 'WH_IN'	THEN QTY	ELSE 0	END))	OVER (PARTITION BY PG.FROM_SITE
																										  ,PG.TO_SITE
																										  ,PG.ITEM_ID
																										  ,PG.INCOTERMS
																								  ORDER BY DI.YYYYPW) AS WH_IN_ACC
			  ,SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN'	  THEN PG.QTY	ELSE 0	END)	AS SHIP_PLAN	
			  ,SUM(SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN' THEN QTY		ELSE 0	END))	OVER (PARTITION BY PG.FROM_SITE
																										  ,PG.TO_SITE
																										  ,PG.ITEM_ID
																										  ,PG.INCOTERMS
																								  ORDER BY DI.YYYYPW) AS SHIP_PLAN_ACC
		 INTO #INTRANSIT
		 FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK)  
			  INNER JOIN #TMP_PW_LIST DI WITH(NOLOCK) 
					  ON PG.YYYYPW	= DI.YYYYPW
					 AND DI.YYYYPW >= @V_PLAN_START_YYYYPW	-- 계획 구간 
			  LEFT JOIN #INTRANSIT_BOH BO WITH(NOLOCK) 
					  ON BO.FROM_SITE = PG.FROM_SITE
					 AND BO.TO_SITE   = PG.TO_SITE
					 AND BO.ITEM_ID   = PG.ITEM_ID
					 AND CASE WHEN BO.INCOTERMS = '***'
							  THEN '-'
							  ELSE BO.INCOTERMS 
						  END		  = PG.INCOTERMS
		WHERE 1=1
		  AND PG.MEASURE IN ('WH_IN', 'SHIP_PLAN')
		GROUP BY PG.FROM_SITE
				,PG.TO_SITE
				,PG.ITEM_ID
			    ,PG.INCOTERMS
				,DI.YYYYPW
				,ISNULL(BO.INT_BOH_QTY, CONVERT(NUMERIC(20,10), 0))		
		*/
		
		-- @@@ BOH 정보를 Ending Inventory 로 변경
		SELECT	PG.FROM_SITE
				,PG.TO_SITE
				,PG.ITEM_ID
				,PG.INCOTERMS
				,PG.YYYYPW
				,PG.MEASURE
				,SUM(PG.ACC_QTY)
								OVER (PARTITION BY PG.ITEM_ID
												  ,PG.FROM_SITE
												  ,PG.TO_SITE
												  ,PG.INCOTERMS
												  ,PG.MEASURE
										 ORDER BY  PG.YYYYPW )		AS QTY	
		INTO 	#INTRANSIT											 
		FROM	(
					 
					SELECT	PG.FROM_SITE
							,PG.TO_SITE
							,PG.ITEM_ID
							,PG.INCOTERMS
							,DI.YYYYPW
							,PG.MEASURE
							,SUM(CASE WHEN DI.YYYYPW = PG.YYYYPW THEN 
										ISNULL(CASE WHEN PG.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(SO.QTY,0) - PG.WH_IN + PG.SHIP_PLAN ELSE 0 - PG.WH_IN + PG.SHIP_PLAN END,0) 
								   ELSE 0 END ) ACC_QTY
					FROM	(
									SELECT MAX(PG.FROM_SITE) AS FROM_SITE	--@@@ intransit 계산시에는 감안하지 않는다.
										  ,PG.TO_SITE
										  ,PG.ITEM_ID
										  , '-' AS INCOTERMS	--,PG.INCOTERMS	--@@@ intransit 계산시에는 incoterms 감안하지 않는다.
										  ,DI.YYYYPW
										  ,CASE WHEN TS.SITE_TYPE = 'SALES' 
												THEN 'INTRANSIT' 
												ELSE 'SEMI_INTRANSIT' END AS MEASURE  
										  ,SUM(CASE WHEN PG.MEASURE = 'WH_IN' THEN PG.QTY	ELSE 0	END) AS WH_IN
										  ,SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN' THEN PG.QTY	ELSE 0	END) AS SHIP_PLAN
										  , RANK() OVER (PARTITION BY PG.ITEM_ID, DI.YYYYPW , (CASE WHEN TS.SITE_TYPE = 'SALES' 
												THEN 'INTRANSIT' 
												ELSE 'SEMI_INTRANSIT' END )
																	--ORDER BY PG.FROM_SITE DESC, PG.TO_SITE DESC, PG.INCOTERMS ) AS IDX -- '-' 정보를 뒤로 주기 위해서
																ORDER BY PG.TO_SITE DESC ) AS IDX -- '-' 정보를 뒤로 주기 위해서
									 FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK)  
										  INNER JOIN #TMP_PW_LIST DI WITH(NOLOCK) 
												  ON PG.YYYYPW  = DI.YYYYPW
												 AND PG.YYYYPW >= @V_PLAN_START_YYYYPW  -- 계획 구간 
										  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK) 
												  ON TS.SCM_SITE_ID	= PG.TO_SITE
							 
									WHERE 1=1
									  AND PG.MEASURE IN ('WH_IN', 'SHIP_PLAN')
									  AND ISNULL(TS.SITE_TYPE,'') + ISNULL(TS.OPERATION_GROUP,'') != 'SALESW'
									GROUP BY --PG.FROM_SITE,--@@@ intransit 계산시에는 감안하지 않는다.
										  PG.TO_SITE
										  ,PG.ITEM_ID
										  --,PG.INCOTERMS	--@@@ intransit 계산시에는 incoterms 감안하지 않는다.
										  ,DI.YYYYPW
										  ,CASE WHEN TS.SITE_TYPE = 'SALES' 
												THEN 'INTRANSIT' 
												ELSE 'SEMI_INTRANSIT' END
							) PG
							INNER JOIN #TMP_PW_LIST DI WITH(NOLOCK) 
									ON DI.YYYYPW >= @V_PLAN_START_YYYYPW  -- 계획 구간 
							LEFT JOIN
							  (
									SELECT SO.ITEM_ID, SO.MEASURE, SUM(SO.QTY) AS QTY 
									FROM #TMP_TOBE_GLOBAL_PSI SO WITH(NOLOCK)
									WHERE 1=1
									AND SO.YYYYPW	= @V_RESULT_LAST_YYYYPW
									AND SO.MEASURE IN ('SEMI_INTRANSIT', 'INTRANSIT')
									GROUP BY SO.ITEM_ID, SO.MEASURE
								) SO
								ON 1=1
								AND PG.ITEM_ID = SO.ITEM_ID
								AND PG.MEASURE = SO.MEASURE
								AND PG.IDX = 1				-- 같은 주차에 동일 아이템이 존재할 경우 1순위에만 BOH 부여
					GROUP BY PG.FROM_SITE
							,PG.TO_SITE
							,PG.ITEM_ID
							,PG.INCOTERMS
							,DI.YYYYPW
							,PG.MEASURE
				) PG
		WHERE	1=1

		-------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Intransit 재고(EOH) - Intransit BOH만 존재하는 건 반영' 
		-- intransit boh만 존재하고 WH_IN/SHIP PLAN이 없는 경우
		-- Intransit 기초 재고만 존재하고 도착/출하 정보가 없는 전구간 BOH/EOH 동일한 값으로 추가 
		-------------------------------------------------------------------------------------------------------------------------
		/*
		INSERT INTO #INTRANSIT
		SELECT BO.FROM_SITE
			  ,BO.TO_SITE
			  ,BO.ITEM_ID
			  ,CASE WHEN BO.INCOTERMS = '***'
					THEN '-'
					ELSE BO.INCOTERMS 
			   END	AS INCOTERMS
			  ,ML.YYYYPW
			  ,BO.INT_BOH_QTY
			  ,BO.INT_BOH_QTY AS INT_EOH_QTY
			  ,0.0	AS WH_IN
			  ,0.0	AS WH_IN_ACC
			  ,0.0	AS SHIP_PLAN
			  ,0.0	AS SHIP_PLAN_ACC 
		  FROM #INTRANSIT_BOH BO WITH(NOLOCK) 
			   INNER JOIN #TMP_PW_LIST ML WITH(NOLOCK)
					   ON 1=1
					  AND ML.YYYYPW >= @V_PLAN_START_YYYYPW	-- 계획 구간
			   LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					   ON TS.SCM_SITE_ID = BO.TO_SITE
		 WHERE 1=1
		   AND ISNULL(TS.OPERATION_GROUP, '') != 'W' -- to AS Sales Site 제외 
		   AND NOT EXISTS (SELECT *
							 FROM #INTRANSIT I WITH(NOLOCK)
							WHERE I.FROM_SITE = BO.FROM_SITE
							  AND I.TO_SITE   = BO.TO_SITE
							  AND I.ITEM_ID   = BO.ITEM_ID
							  AND I.INCOTERMS = CASE WHEN BO.INCOTERMS = '***'
													 THEN '-'
													 ELSE BO.INCOTERMS 
												END
												)
		*/
		-- @@@ BOH 정보를 Ending Inventory 로 변경
		-- @@@ 미래계획 기준이 없을 경우 넣어준다.
		INSERT INTO #INTRANSIT
		SELECT   SO.FROM_SITE
				,SO.TO_SITE
				,SO.ITEM_ID
				,'-' AS INCOTERMS
				,ML.YYYYPW
				,SO.MEASURE
				,SUM(SO.QTY) AS QTY
		FROM 	#TMP_TOBE_GLOBAL_PSI SO WITH(NOLOCK)
				INNER JOIN #TMP_PW_LIST ML WITH(NOLOCK)
				  		ON 1=1
				  	   AND ML.YYYYPW >= @V_PLAN_START_YYYYPW  -- 계획 구간
		WHERE 1=1
		AND SO.YYYYPW	= @V_RESULT_LAST_YYYYPW
		AND SO.MEASURE	IN ('SEMI_INTRANSIT', 'INTRANSIT')
		AND NOT EXISTS (
							SELECT 	1
							  FROM 	#INTRANSIT X
							 WHERE 	1=1
							   AND  SO.MEASURE	IN ('SEMI_INTRANSIT', 'INTRANSIT')
							   AND 	X.ITEM_ID 	= SO.ITEM_ID
							   AND 	X.MEASURE	= SO.MEASURE
						)
		GROUP BY SO.ITEM_ID, SO.OPERATION_GROUP, SO.FROM_SITE, SO.TO_SITE, SO.MEASURE, ML.YYYYPW
		
				
		


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory ' 
		-- 전주 재고(Pack Inventory)  + 금주생산(Production-pack 해당월 누적) - 금주출하(Pack Ship 해당월 누적) 
		-- 전월말 재고를 기초로 하여 당월 생산과 당월 출하 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory - 생산'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PRODUCTION_FOR_PACK_INV') IS NOT NULL	
			DROP TABLE #PRODUCTION_FOR_PACK_INV;

		-- 실적구간 - 팩 생산
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,'-'			AS TO_SITE 
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_PROD_QTY 
		 INTO #PRODUCTION_FOR_PACK_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE   = 'PACK_PROD'
		  AND WI.YYYYPW	   <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_PACK_INV') IS NOT NULL	
			DROP TABLE #SHIP_FOR_PACK_INV;

		-- 실적구간 - 팩출하
		SELECT WL.YYYYPW
			 ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,'-'			AS TO_SITE 
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_PACK_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE			IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
		  AND WI.OPERATION_GROUP	= 'P'			 -- 팩출하
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - Pack Inventory 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.TO_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_PROD_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'PACK_EOH'
			UNION ALL 
			-- 실적구간 - 출하(FG) for  Pack Inventory
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_PROD_QTY
			 FROM #SHIP_FOR_PACK_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - 팩 생산 for Pack Inventory
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_EXFACTORY_QTY
				  ,MM_ACC_PROD_QTY
			 FROM #PRODUCTION_FOR_PACK_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			SELECT SR.YYYYPW
				  ,WL.PW_TO_YMD
				  ,WL.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,SR.QTY			AS MM_ACC_EXFACTORY_QTY
				  ,0.0				AS MM_ACC_PROD_QTY
			FROM #TMP_ASIS_GLOBAL_PSI SR WITH(NOLOCK) 
				 INNER JOIN #TMP_PW_LIST WL
				 ON 1=1
				 AND SR.YYYYPW = WL.YYYYPW
			WHERE 1=1
				AND SR.MEASURE			= 'AS_IN_PLAN'
				AND SR.OPERATION_GROUP	= 'P'			 -- Cell
				AND SR.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'PACK_EOH'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,'-'			AS TO_SITE
			  ,'-'			AS INCOTERMS
			  ,'-'			AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'-'			AS TO_SITE_TYPE
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_PROD_QTY) - SUM(MM_ACC_EXFACTORY_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장)' 
		-- 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 
		-- 전월말 재고를 기초로 하여 해당월 도착/생산 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		/*
		모듈 공장의 Cell Inventory는
		P = 전주 재고(Cell Inventory) + 금주도착(Semi WH In) - 금주생산(Production)/팩수율
		자작 공장 무시하고, 위의 P가 마이너스이면, P=0으로 표시하고, 그 마이너스(P) 수량 만큼 동일 Plant의 셀 공장 measure에서 빼기
 
		셀 공장의 Cell Inventory는
		A = 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		*/


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Cell도착 '  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SEMI_WHIN_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #SEMI_WHIN_FOR_CELL_INV;

		-- 실적구간 - Cell 도착 (to Plant) - to 사이트 기준 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.TO_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW = WL.YYYYPW	-- 20240327 해당월 주 누적이 아닌 해당 주차 
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS WHIN_QTY												-- 20240327 해당월 주 누적이 아닌 해당 주차
		 INTO #SEMI_WHIN_FOR_CELL_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					 ON TS.SCM_SITE_ID		= WI.TO_SITE
					AND TS.OPERATION_GROUP	= 'P'	-- Pack plant 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE			= 'SEMI_WHIN'
		  AND WI.OPERATION_GROUP	= 'A'	-- Cell 
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.TO_SITE 	
			  
			 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 계산 ' 
		-- 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_CELL_EOH_RESULT') IS NOT NULL	
			DROP TABLE #PACK_CELL_EOH_RESULT;

		;WITH BASE_DATA AS (
			-- 실적구간 - Pack공장 Cell 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.YYYYMM
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY			-- 전월말 기말재고
				  ,MI.QTY				AS MM_EOH_QTY			-- 당월말 기말재고
				  ,0.0					AS WHIN_QTY				-- 20240327 변경
				  ,0.0					AS PACK_PROD_QTY 		-- 20240327 변경
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)  -- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)			-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'PACK_CELL_EOH'
			UNION ALL 
			-- 실적구간 - Pack Plant Cell 도착 실적 
			SELECT SR.YYYYPW
				  ,SR.YYYYMM
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.TO_SITE			AS FROM_SITE			
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,WHIN_QTY									   -- 20240327 변경
				  ,0.0					AS PACK_PROD_QTY	   -- 20240327 변경
			 FROM #SEMI_WHIN_FOR_CELL_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - Pack 생산계획(수율역적용 -투입 기준) -> Cell 환산
			SELECT SR.YYYYPW
				  ,SR.YYYYMM
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.REP_CELL_ITEM_ID	AS ITEM_ID
				  ,SR.FROM_SITE
				  ,'A'					AS OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,0.0					AS WHIN_QTY										-- 20240327 변경
				  ,SUM(PACK_PROD_YIELD_QTY * ISNULL(CELL_CF,1.1))  AS PACK_PROD_QTY		-- 20240327 변경
			 FROM #PACK_PRODUCTION_RESULT_3 SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			  AND SR.REP_CELL_ITEM_ID IS NOT NULL
			GROUP BY 
				   SR.YYYYPW
				  ,SR.YYYYMM
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.REP_CELL_ITEM_ID
				  ,SR.FROM_SITE
		)
		, PACK_CELL_EOH_RESULT  AS (
			SELECT BD.YYYYPW
				  ,BD.YYYYMM
				  ,BD.PW_TO_YMD
				  ,BD.YYYYMM_LAST_YMD
				  ,BD.ITEM_ID
				  ,BD.FROM_SITE
				  ,'-'							AS TO_SITE
				  ,'-'							AS INCOTERMS
				  ,'-'							AS VARIOUS_KEY
				  ,BD.OPERATION_GROUP
				  ,'-'							AS TO_SITE_TYPE
				  ,0.0							AS FROM_BOH_QTY
				  ,0.0							AS TO_BOH_QTY
				  ,SUM(MM_EOH_QTY)				AS MM_EOH_QTY
				  ,SUM(MM_BOH_QTY)				AS MM_BOH_QTY
				  ,SUM(WHIN_QTY)				AS WHIN_QTY			-- 20240327 변경
				  ,SUM(PACK_PROD_QTY)			AS PACK_PROD_QTY	-- 20240327 변경
				-- 20240327 주석처리   ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
				-- 20240327 주석처리 		THEN SUM(MM_EOH_QTY)
				-- 20240327 주석처리 		ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_WHIN_QTY) - SUM(MM_ACC_PACK_PROD_QTY)
				-- 20240327 주석처리 	END			AS QTY
			 FROM BASE_DATA BD
			WHERE 1=1
			GROUP BY
				   BD.YYYYPW
				  ,BD.YYYYMM
				  ,BD.PW_TO_YMD
				  ,BD.YYYYMM_LAST_YMD
				  ,BD.ITEM_ID
				  ,BD.FROM_SITE
				  ,BD.OPERATION_GROUP
		)
		SELECT MAX(A.MM_WW_SEQ) OVER (PARTITION BY A.ITEM_ID
												  ,A.FROM_SITE
												  ,A.YYYYMM )		AS MM_WW_SEQ_MAX
			  ,A.*
		 INTO #PACK_CELL_EOH_RESULT 
		 FROM (
				SELECT  ROW_NUMBER() OVER (PARTITION BY  A.ITEM_ID 
														,A.FROM_SITE	 
														,A.YYYYMM 
												ORDER BY A.YYYYPW) AS MM_WW_SEQ 
					   ,A.*
				FROM PACK_CELL_EOH_RESULT A 
				WHERE 1=1 
			  ) A 
		WHERE 1=1 


		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 계산 결과 조정 (마이너스 수량)'
		-- 월별 마지막주는 조정 대상에서 제외 (월 기말재고와 동일)
		-- 월별 둘째주부터 전주 마이너스 수량을 0으로 보정된 기준으로 당주 재고 수량 보정
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_CELL_EOH_RESULT_ADJ') IS NOT NULL	
			DROP TABLE #PACK_CELL_EOH_RESULT_ADJ;

		/* 20240327 변경전 
		;WITH RECURSIVE_DATA AS (
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,A.QTY	AS ORG_QTY 
				  ,A.QTY	
				  ,A.MM_EOH_QTY
				  ,A.MM_BOH_QTY
				  ,A.MM_ACC_WHIN_QTY
				  ,A.MM_ACC_PACK_PROD_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.QTY < 0 
						THEN A.QTY
						ELSE 0.0	
					END AS ACC_ADJ_QTY
			 FROM #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
			WHERE 1=1
			  AND A.MM_WW_SEQ = 1
			UNION ALL
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,A.QTY	AS ORG_QTY 
				  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX
						THEN A.QTY
						ELSE A.QTY - P.ACC_ADJ_QTY 
					END AS QTY 
				  ,A.MM_EOH_QTY
				  ,A.MM_BOH_QTY
				  ,A.MM_ACC_WHIN_QTY
				  ,A.MM_ACC_PACK_PROD_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.QTY - P.ACC_ADJ_QTY  < 0 and A.MM_WW_SEQ != A.MM_WW_SEQ_MAX -- 마지막 주차 제외 
						THEN A.QTY
						ELSE P.ACC_ADJ_QTY 
					END ACC_ADJ_QTY
			  FROM RECURSIVE_DATA p 
				   INNER JOIN #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
						   ON A.MM_WW_SEQ = P.MM_WW_SEQ + 1 
						  AND A.ITEM_ID	  = P.ITEM_ID
						  AND A.FROM_SITE = P.FROM_SITE
						  AND A.YYYYMM    = P.YYYYMM 
			WHERE 1=1
		)
		SELECT *
		 INTO #PACK_CELL_EOH_RESULT_ADJ
		 FROM RECURSIVE_DATA  A
		WHERE 1=1
*/

		;WITH RECURSIVE_DATA AS (
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,A.MM_BOH_QTY		AS BOH_QTY
				  ,A.WHIN_QTY
				  ,A.PACK_PROD_QTY
				  ,CASE WHEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN 0
						ELSE A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
				   END	AS EOH_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
						ELSE 0
				   END	AS ADJ_QTY_P
			 FROM #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
			WHERE 1=1
			  AND A.MM_WW_SEQ = 1
			UNION ALL
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,P.EOH_QTY		AS BOH_QTY-- 전주 EOH -> 당주 BOH
				  ,A.WHIN_QTY
				  ,A.PACK_PROD_QTY
				  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX	 AND A.PW_TO_YMD = A.YYYYMM_LAST_YMD --  해당월 마지막 주차( 말일기준 추가)
						THEN A.MM_EOH_QTY
						WHEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN 0
						ELSE P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
				   END	AS EOH_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX	AND A.PW_TO_YMD = A.YYYYMM_LAST_YMD AND A.MM_EOH_QTY= 0 AND  P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 -- 해당월 마지막 주차
						THEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
						WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX	 -- 해당월 마지막 주차
						THEN 0
						WHEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
						ELSE 0
				   END	AS ADJ_QTY_P
			  FROM RECURSIVE_DATA p 
				   INNER JOIN #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
						   ON A.MM_WW_SEQ = P.MM_WW_SEQ + 1 
						  AND A.ITEM_ID	  = P.ITEM_ID
						  AND A.FROM_SITE = P.FROM_SITE
						  AND A.YYYYMM    = P.YYYYMM 
			WHERE 1=1
		)
		SELECT *
		 INTO #PACK_CELL_EOH_RESULT_ADJ
		 FROM RECURSIVE_DATA  A
		WHERE 1=1

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 추가 ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT PR.YYYYPW
			  ,PR.ITEM_ID
			  ,'PACK_CELL_EOH'	AS MEASURE
			  ,PR.FROM_SITE
			  ,'-'	AS TO_SITE
			  ,'-'	AS INCOTERMS
			  ,'-'	AS VARIOUS_KEY
			  ,'A'	AS OPERATION_GROUP 
			  ,'-'	AS TO_SITE_TYPE
			  ,0.0	AS FROM_BOH_QTY
			  ,0.0	AS TO_BOH_QTY
			  ,PR.EOH_QTY    -- 20240327    
			-- 20240327 변경   ,CASE WHEN PR.QTY < 0 
			-- 20240327 변경 		THEN 0.0 
			-- 20240327 변경 		ELSE PR.QTY 
			-- 20240327 변경 	END	AS QTY
		 FROM #PACK_CELL_EOH_RESULT_ADJ PR WITH(NOLOCK)
		WHERE 1=1


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)' 
		-- 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		-- 전월말 재고를 기초로 하여 해당월 생산/출하 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		/*
		모듈 공장의 Cell Inventory는
		P = 전주 재고(Cell Inventory) + 금주도착(Semi WH In) - 금주생산(Production)/팩수율
		자작 공장 무시하고, 위의 P가 마이너스이면, P=0으로 표시하고, 그 마이너스(P) 수량 만큼 동일 Plant의 셀 공장 measure에서 빼기
 
		셀 공장의 Cell Inventory는
		A = 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		*/


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장) - Char Plan' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CELL_CHAR_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #CELL_CHAR_FOR_CELL_INV;

		-- 실적구간 - 셀 특성 생산 실적 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END) AS MM_ACC_CELL_CHAR_QTY 
		 INTO #CELL_CHAR_FOR_CELL_INV  
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_CHAR_PLAN'
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장) - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #SHIP_FOR_CELL_INV;

		-- 실적구간 - Cell 출하
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,'-'			AS TO_SITE 
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_CELL_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE			IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
		  AND WI.OPERATION_GROUP	= 'A'			 -- Cell 출하
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 




		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  - P (팩공장 셀재고 마이너스 수량)' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PROD_FOR_CELL_PLANT_INV') IS NOT NULL	
			DROP TABLE #PACK_PROD_FOR_CELL_PLANT_INV;
				
		SELECT PR.YYYYPW
			  ,PR.YYYYMM
			  ,PR.PW_TO_YMD
			  ,PR.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE 
			  ,SUM(AP.ADJ_QTY_P) AS ADJ_QTY_P  --- 20240327 
			  --- 20240327 ,SUM(CASE WHEN AP.QTY < 0 THEN AP.QTY ELSE 0.0 END) AS QTY
		INTO #PACK_PROD_FOR_CELL_PLANT_INV
		FROM #PACK_CELL_EOH_RESULT_ADJ PR WITH(NOLOCK)
			 LEFT JOIN #PACK_CELL_EOH_RESULT_ADJ AP WITH(NOLOCK)
				    ON AP.YYYYMM	= PR.YYYYMM
				   AND AP.ITEM_ID	= PR.ITEM_ID
				   AND AP.FROM_SITE = PR.FROM_SITE 
				   AND AP.YYYYPW   <= PR.YYYYPW
		GROUP BY 
			   PR.YYYYPW
			  ,PR.YYYYMM
			  ,PR.PW_TO_YMD
			  ,PR.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE
		HAVING SUM(AP.ADJ_QTY_P) != 0 
		-- 20240327 HAVING SUM(CASE WHEN AP.QTY < 0 THEN AP.QTY ELSE 0.0 END) != 0 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  measure 추가' 
		-- 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) 
		--           + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		DELETE #TMP_TOBE_GLOBAL_PSI
		WHERE 1=1
		AND MEASURE = 'CELL_EOH'
		
		;WITH BASE_DATA AS (
			-- 실적구간 - 셀공장 Cell 기초 재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY			-- 전월말 기말재고
				  ,MI.QTY				AS MM_EOH_QTY			-- 당월말 기말재고
				  ,0.0					AS MM_ACC_PROD_QTY
				  ,0.0					AS MM_ACC_SHIP_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'CELL_EOH'
			UNION ALL 
			-- 실적구간 - Production(PKG)
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_CELL_CHAR_QTY	AS MM_ACC_PROD_QTY
				  ,0.0					AS MM_ACC_SHIP_QTY
			 FROM #CELL_CHAR_FOR_CELL_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - Cell Char
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0						AS MM_BOH_QTY
				  ,0.0						AS MM_EOH_QTY
				  ,0.0						AS MM_ACC_PROD_QTY
				  ,SR.MM_ACC_EXFACTORY_QTY	AS MM_ACC_SHIP_QTY
			 FROM #SHIP_FOR_CELL_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- + P (If P가 마이너스 경우만, 동일 공장에서 빼기) 
			SELECT PR.YYYYPW
				  ,PR.PW_TO_YMD
				  ,PR.YYYYMM_LAST_YMD
				  ,PR.ITEM_ID
				  ,ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE))	AS FROM_SITE -- cell plant 
				  ,'A'						AS OPERATION_GROUP 
				  ,0.0						AS MM_BOH_QTY
				  ,0.0						AS MM_EOH_QTY
				  ,PR.ADJ_QTY_P				AS MM_ACC_PROD_QTY  -- P: 음수값  20240327 변경 
				  ,0.0						AS MM_ACC_SHIP_QTY
			 FROM #PACK_PROD_FOR_CELL_PLANT_INV PR WITH(NOLOCK)
				  INNER JOIN #SCM_MST_SITE PP WITH(NOLOCK)	-- pack plant site 
						  ON PP.SCM_SITE_ID		= PR.FROM_SITE
				  LEFT JOIN #SCM_MST_SITE CP WITH(NOLOCK)	-- cell plant site 
						  ON CP.PLANT_ID		= PP.PLANT_ID
						 AND CP.OPERATION_GROUP = 'A'
						 AND CP.SITE_TYPE		= 'PLANT'
				  LEFT  JOIN #ITEM_SEMI_SHIP_SITE SS WITH(NOLOCK)
						  ON SS.ITEM_ID			= PR.ITEM_ID 
						 AND SS.PACK_SITE		= PP.SCM_SITE_ID -- pack site 
			WHERE 1=1
			   --- 20240327 불필요 조건 삭제 
			  AND ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE)) IS NOT NULL
			UNION ALL
			SELECT SR.YYYYPW
				  ,WL.PW_TO_YMD
				  ,WL.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_PROD_QTY
				  ,SR.QTY			AS MM_ACC_SHIP_QTY
			FROM #TMP_ASIS_GLOBAL_PSI SR WITH(NOLOCK) 
				 INNER JOIN #TMP_PW_LIST WL
				 ON 1=1
				 AND SR.YYYYPW = WL.YYYYPW
			WHERE 1=1
				AND SR.MEASURE			= 'AS_IN_PLAN'
				AND SR.OPERATION_GROUP	= 'A'			 -- Cell
				AND SR.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,ISNULL(ISNULL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), BD.ITEM_ID)  AS ITEM_ID -- 20240118 CP->CA 치환 적용 
			  ,'CELL_EOH'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,'-'						AS TO_SITE
			  ,'-'						AS INCOTERMS
			  ,'-'						AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'-'						AS TO_SITE_TYPE
			  ,0.0						AS FROM_BOH_QTY
			 ,0.0						AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_PROD_QTY) - SUM(MM_ACC_SHIP_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
			   LEFT JOIN #SCM_MST_SITE FS WITH(NOLOCK)
					  ON FS.SCM_SITE_ID			= BD.FROM_SITE
			   LEFT JOIN #CELL_PROD_ASSY_MAP CA1 WITH(NOLOCK)
					  ON CA1.PLANT_ID			= FS.PLANT_ID 
					 AND CA1.ITEM_ID_PROD		= BD.ITEM_ID
					 AND CA1.ASSY_PRIORITY_1ST	= 1 
			   LEFT JOIN #CELL_PROD_ASSY_MAP CA2 WITH(NOLOCK)
					  ON CA2.ITEM_ID_PROD		= BD.ITEM_ID
					 AND CA2.ASSY_PRIORITY_2ND	= 1
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,ISNULL(ISNULL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), BD.ITEM_ID)
			  ,BD.FROM_SITE
			  ,BD.OPERATION_GROUP


		

		


		
		   
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		DELETE #TMP_TOBE_GLOBAL_PSI
		WHERE 1=1
		AND MEASURE IN ( 'CELL_CHAR_AVAILABLE','CELL_FORM_PROGRESS')
		AND YYYYPW <  @V_PLAN_START_YYYYPW  -- 실적 구간
		;

		
		;WITH TARGET_MEASURE AS (
			SELECT 'CELL_FORM_PROGRESS' AS MEASURE 
			UNION ALL
			SELECT 'CELL_CHAR_AVAILABLE' AS MEASURE 
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT EI.YYYYPW
			  ,EI.ITEM_ID
			  ,TM.MEASURE
			  ,EI.FROM_SITE			AS FROM_SITE
			  ,'-'			AS TO_SITE
			  ,'-'					AS INCOTERMS
			  ,'-'					AS VARIOUS_KEY -- 생산라인 or 운송모드 or 프로젝트
			  ,EI.OPERATION_GROUP	AS OPERATION_GROUP
			  ,'-'					AS TO_SITE_TYPE 
			  ,0.0					AS FROM_BOH_QTY
			  ,0.0					AS TO_BOH_QTY
			  ,CASE WHEN TM.MEASURE = 'CELL_FORM_PROGRESS'
					THEN FORM_PROGRESS
					ELSE CHAR_AVAILABLE
				END					AS QTY
		  FROM #PAST_FORM_PROGRESS_CHAR_AVAILABLE EI WITH(NOLOCK)
				INNER JOIN TARGET_MEASURE TM 
						ON 1=1 
		 WHERE 1=1
		
--END : 실적 Measure #TMP_TOBE_GLOBAL_PSI Measure 입력 
--END : 실적 Measure #TMP_TOBE_GLOBAL_PSI Measure 입력		

		 


		
		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : intransit(FG/SEMI) 재고 Measure 추가' 
		----------------------------------------------------------------------------------------------------------
		/*
		INSERT INTO #TMP_TOBE_GLOBAL_PSI
		SELECT I.YYYYPW
			  ,I.ITEM_ID
			  ,CASE WHEN TS.SITE_TYPE = 'SALES'
					THEN 'INTRANSIT' 
					ELSE 'SEMI_INTRANSIT' 
				END					AS MEASURE 
			  ,I.FROM_SITE
			  ,I.TO_SITE
			  ,I.INCOTERMS
			  ,'-'					AS VARIOUS_KEY
			  ,FI.OPERATION_GROUP
			  ,TS.SITE_TYPE			AS TO_SITE_TYPE 
			  ,SUM(I.INT_BOH_QTY)	AS FROM_BOH_QTY  -- from site boh가 아닌 intransit boh임...
			  ,0.0					AS TO_BOH_QTY
			  ,SUM(I.INT_EOH_QTY)	AS QTY
		 FROM #INTRANSIT I WITH(NOLOCK)  -- 7925
			  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID		= I.ITEM_ID 
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK) 
					  ON TS.SCM_SITE_ID	= I.TO_SITE
		WHERE 1=1 
		  AND ISNULL(TS.SITE_TYPE,'') + ISNULL(TS.OPERATION_GROUP,'') != 'SALESW' -- to AS Sales Site 제외 
		GROUP BY  I.YYYYPW
				 ,I.ITEM_ID
				 ,I.FROM_SITE
				 ,I.TO_SITE
				 ,I.INCOTERMS
				 ,FI.OPERATION_GROUP
				 ,TS.SITE_TYPE
		*/
		
		-- @@@ BOH 정보를 Ending Inventory 로 변경하여 measure 가 분리됨
		INSERT INTO #TMP_TOBE_GLOBAL_PSI
		SELECT I.YYYYPW
				,I.ITEM_ID
				,I.MEASURE 
				,I.FROM_SITE
				,I.TO_SITE
				,I.INCOTERMS
				,'-'					AS VARIOUS_KEY
				,FI.OPERATION_GROUP
				,ISNULL(TS.SITE_TYPE,'PLANT')	AS TO_SITE_TYPE 
				,0					    AS FROM_BOH_QTY  -- from site boh가 아닌 intransit boh임...
				,0.0					AS TO_BOH_QTY
				,SUM(I.QTY)				AS QTY
		FROM 	#INTRANSIT I
		 		INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						  ON FI.ITEM_ID		= I.ITEM_ID 
				  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK) 
						  ON TS.SCM_SITE_ID	= I.TO_SITE
		WHERE 1=1 
		  AND ISNULL(TS.SITE_TYPE,'') + ISNULL(TS.OPERATION_GROUP,'') != 'SALESW' -- to AS Sales Site 제외 
		GROUP BY  I.YYYYPW
						 ,I.ITEM_ID
						 ,I.MEASURE 
						 ,I.FROM_SITE
						 ,I.TO_SITE
						 ,I.INCOTERMS
						 ,FI.OPERATION_GROUP
						 ,TS.SITE_TYPE	
						 
	----------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Cell Inventory (Pack공장) measure 계산 ' 
	-- 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율
	-- @@@ PACK_CELL_EOH
	----------------------------------------------------------------------------------------------------------
	
	DELETE #TMP_TOBE_GLOBAL_PSI
	WHERE 1=1
	AND MEASURE = 'PACK_CELL_EOH'
	AND YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간
	
	
	;WITH BASE_DATA AS (
			-- 실적구간 - 팩출하
			SELECT   WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
					,WI.FROM_SITE 
					,WI.TO_SITE
					,SUM(WI.PLAN_QTY) AS PLAN_QTY
					,SUM(WI.PROD_QTY) AS PROD_QTY
			FROM	(
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
								,'-' AS FROM_SITE	--WI.FROM_SITE 
								,'-'			AS TO_SITE 
								,(CASE WHEN WI.YYYYPW = WL.YYYYPW THEN WI.QTY ELSE 0 END) AS PLAN_QTY 
								, 0 AS PROD_QTY
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
							INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간
						WHERE 1=1
						  AND WI.MEASURE			= 'SEMI_WHIN'
						  AND WI.OPERATION_GROUP	= 'A'			 -- Cell
						UNION ALL
						/*
						-- 실적구간 - 팩생산
						SELECT	 WL.YYYYPW
								,ISNULL(MM.TARGET_CELL,WI.ITEM_ID) AS ITEM_ID --WI.ITEM_ID	--cell code 로 변경
								,'A' AS OPERATION_GROUP	--WI.OPERATION_GROUP
								,'-' AS FROM_SITE	--WI.FROM_SITE 
								,'-'			AS TO_SITE 
								,0 AS PLAN_QTY
								,(CASE WHEN WI.YYYYPW = WL.YYYYPW THEN WI.QTY ELSE 0 END) * ISNULL(MM.CELL_CF,1) AS PROD_QTY 	--,WI.QTY AS QTY 
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
							INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간
							LEFT JOIN #SCP_MST_ITEM_CELL_CF MM WITH(NOLOCK) 
								   ON MM.ITEM_ID = WI.ITEM_ID
						WHERE 1=1
						  AND WI.MEASURE			= 'PACK_PROD'
						 */
						-- 실적구간 - 팩생산/팩수율
						 SELECT	 WL.YYYYPW
						 		,ISNULL(MM.TARGET_CELL,WI.ITEM_ID) AS ITEM_ID --WI.ITEM_ID	--cell code 로 변경
								,'A' AS OPERATION_GROUP	--WI.OPERATION_GROUP
								,'-' AS FROM_SITE	--WI.FROM_SITE 
								,'-'			AS TO_SITE 
								,0 AS PLAN_QTY
								,(CASE WHEN WI.YYYYPW = WL.YYYYPW THEN WI.QTY/ISNULL(YD.CHAR_YIELD, ISNULL(YD2.STD_YIELD,1)) ELSE 0 END) * ISNULL(MM.CELL_CF,1) AS PROD_QTY 	--,WI.QTY AS QTY 
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
							INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간
							LEFT JOIN #SCP_MST_ITEM_CELL_CF MM WITH(NOLOCK) 
								   ON MM.ITEM_ID = WI.ITEM_ID
							/*
							LEFT JOIN (
										SELECT DISTINCT ITEM_ID, MONTH, LINE_ID, YIELD
										FROM SCM_MST_YIELD_SN WITH(NOLOCK)
										WHERE 1=1
										AND DIVISION_ID = @V_DIVISION_ID
										AND OPERATION_ID LIKE 'P%'
									) YD
								  ON 1=1
								 and WI.ITEM_ID = YD.ITEM_ID
								 AND WI.VARIOUS_KEY = YD.LINE_ID
								 AND WL.YYYYMM = YD.MONTH
							*/
							-- Plant 평균으로 변경
							LEFT JOIN #SCP_MST_FORMATION YD
								  ON 1=1
								 AND WI.ITEM_ID = YD.ITEM_ID
								 AND WI.FROM_SITE = REPLACE(YD.PLANT_SITE_ID,'-A','-P')
								 AND WL.YYYYPW = YD.YYYYPW
							LEFT JOIN (
										SELECT DISTINCT ITEM_ID, MONTH, MAX(YIELD) OVER ( PARTITION BY DIVISION_ID, ITEM_ID, MONTH ) AS STD_YIELD
										FROM SCM_MST_YIELD_SN WITH(NOLOCK)
										WHERE 1=1
										AND DIVISION_ID = @V_DIVISION_ID
										AND OPERATION_ID LIKE 'P%'
									) YD2
								  ON 1=1
								 and WI.ITEM_ID = YD2.ITEM_ID
								 AND WL.YYYYMM = YD2.MONTH
						WHERE 1=1
						  AND WI.MEASURE			= 'PACK_PROD'
						
					) WI
			WHERE	1=1
			GROUP BY WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
					,WI.FROM_SITE 
					,WI.TO_SITE
	)
	INSERT INTO #TMP_TOBE_GLOBAL_PSI
	SELECT	 PG.YYYYPW
			,PG.ITEM_ID	
			,'PACK_CELL_EOH'			AS MEASURE
			,PG.FROM_SITE		AS FROM_SITE
			,PG.TO_SITE
			,'-'				AS INCOTERMS
			,'-'				AS VARIOUS_KEY
			,PG.OPERATION_GROUP
			,'-'				AS TO_SITE_TYPE
			,0.0				AS FROM_BOH_QTY
			,0.0				AS TO_BOH_QTY
			,SUM(PG.ACC_QTY)	OVER (PARTITION BY PG.ITEM_ID
													,PG.OPERATION_GROUP
													,PG.FROM_SITE
										ORDER BY  PG.YYYYPW )		AS QTY		
		FROM (
				SELECT BD.YYYYPW
						,BD.ITEM_ID
						,BD.FROM_SITE
						,'-'			AS TO_SITE
						,BD.OPERATION_GROUP
						, ISNULL(CASE WHEN BD.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(SO.BOH,0) - BD.PROD_QTY + BD.PLAN_QTY ELSE 0 - BD.PROD_QTY + BD.PLAN_QTY END,0) AS ACC_QTY
					FROM BASE_DATA BD
						 LEFT JOIN
						(
							SELECT	 WI.ITEM_ID
									,WI.OPERATION_GROUP
									,SUM(WI.BOH) AS BOH 
							FROM	(
										SELECT	 WI.ITEM_ID
												,WI.OPERATION_GROUP
												--,WI.FROM_SITE 
												,'-'			AS TO_SITE 
												, WI.QTY AS BOH 
										FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK)  -- #TMP_ENDING_INV_MM_WW -> #TMP_TOBE_GLOBAL_PSI 변경
										WHERE 1=1
										AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
										AND WI.MEASURE	= 'PACK_CELL_EOH'
										UNION ALL
										-- PACK_CELL_EOH 로 변환 될 수량 추가
										SELECT	 MM.CELL_ITEM_ID AS ITEM_ID
												,'A' AS OPERATION_GROUP
												--,WI.FROM_SITE 
												,'-'			AS TO_SITE 
												, WI.QTY * ISNULL(SM.CELL_CF,1)  AS BOH 
										FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
											LEFT JOIN #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
							 					   ON MM.MODULE_ID = WI.ITEM_ID
							 					  AND MM.PACK_MODULE_ITEM = 'N'
							 				LEFT JOIN #SCP_MST_ITEM_CELL_CF SM WITH(NOLOCK) 
										   		   ON SM.ITEM_ID = WI.ITEM_ID
										WHERE 1=1
										AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
										AND WI.MEASURE	= 'PACK_EOH'
										AND WI.ITEM_ID  LIKE 'AMDAU%'
										AND NOT EXISTS (
															SELECT 1
															FROM #MODULE_MODEL_INFO MM WITH(NOLOCK) 
															WHERE 1=1
															AND MM.PACK_MODULE_ITEM = 'Y'	--PACK_EOH 로 빠지는 그룹은 제외
															AND MM.MODULE_ID = WI.ITEM_ID
														)
									) WI
							GROUP BY WI.ITEM_ID, WI.OPERATION_GROUP
						) SO
						ON 1=1
						AND BD.ITEM_ID = SO.ITEM_ID
						AND BD.OPERATION_GROUP = SO.OPERATION_GROUP
						--AND BD.FROM_SITE = SO.FROM_SITE
				WHERE 1=1
			) PG
			;
			
			INSERT INTO #TMP_TOBE_GLOBAL_PSI
			SELECT A.YYYYPW, A.ITEM_ID, A.MEASURE, A.FROM_SITE, A.TO_SITE, A.INCOTERMS, A.VARIOUS_KEY, A.OPERATION_GROUP, A.TO_SITE_TYPE
				   ,SUM(A.FROM_BOH_QTY) AS FROM_BOH_QTY, SUM(A.TO_BOH_QTY) AS TO_BOH_QTY, SUM(A.QTY) AS QTY
			FROM   (
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,'PACK_CELL_EOH'			AS MEASURE
								,'-' 				AS FROM_SITE 
								,'-'				AS TO_SITE 
								,'-'				AS INCOTERMS
								,'-'				AS VARIOUS_KEY
								,WI.OPERATION_GROUP
								,'-'				AS TO_SITE_TYPE
								,0.0				AS FROM_BOH_QTY
								,0.0				AS TO_BOH_QTY
								,WI.QTY AS QTY 
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
							INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						WHERE 1=1
						AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
						AND WI.MEASURE	= 'PACK_CELL_EOH'
						UNION ALL
						SELECT	 WL.YYYYPW
						    ,MM.CELL_ITEM_ID 	AS ITEM_ID
						    ,'PACK_CELL_EOH'	AS MEASURE
								,'-' 			    AS FROM_SITE 
								,'-'				AS TO_SITE 
								,'-'				AS INCOTERMS
								,'-'				AS VARIOUS_KEY
								,'A' 				AS OPERATION_GROUP
								,'-'				AS TO_SITE_TYPE
								,0.0				AS FROM_BOH_QTY
								,0.0				AS TO_BOH_QTY
								,WI.QTY * ISNULL(SM.CELL_CF,1) AS QTY 
						FROM 	#TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
							 	INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
								LEFT JOIN #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
				 					   ON MM.MODULE_ID = WI.ITEM_ID
				 					  AND MM.PACK_MODULE_ITEM = 'N'
				 				LEFT JOIN #SCP_MST_ITEM_CELL_CF SM WITH(NOLOCK) 
							   		   ON SM.ITEM_ID = WI.ITEM_ID
						WHERE 1=1
						AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
						AND WI.MEASURE	= 'PACK_EOH'
						AND WI.ITEM_ID  LIKE 'AMDAU%'
						AND NOT EXISTS (
											SELECT 1
											FROM #MODULE_MODEL_INFO MM WITH(NOLOCK) 
											WHERE 1=1
											AND MM.PACK_MODULE_ITEM = 'Y'	--PACK_EOH 로 빠지는 그룹은 제외
											AND MM.MODULE_ID = WI.ITEM_ID
										)
						
					) A
			 WHERE 1=1
			 AND A.ITEM_ID IS NOT NULL
			 AND NOT EXISTS (
									SELECT	1
									FROM	#TMP_TOBE_GLOBAL_PSI X 
									WHERE	1=1
									AND		X.MEASURE = 'PACK_CELL_EOH'
									AND		X.MEASURE = A.MEASURE
									AND		X.ITEM_ID = A.ITEM_ID
									AND 	X.YYYYPW >= @V_PLAN_START_YYYYPW 
									--AND		X.FROM_SITE = WI.FROM_SITE
									--AND		X.OPERATION_GROUP = A.OPERATION_GROUP
							   )
			 GROUP BY A.YYYYPW, A.ITEM_ID, A.MEASURE, A.FROM_SITE, A.TO_SITE, A.INCOTERMS, A.VARIOUS_KEY, A.OPERATION_GROUP, A.TO_SITE_TYPE		
				;	
			
			
	
	----------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Pack Inventory measure 추가' 
	-- Pack Inventory 기초재고(전월말) + 팩 생산 for Pack Inventory - 출하(FG) for  Pack Inventory
	-- @@@ PACK_EOH 
	----------------------------------------------------------------------------------------------------------
	
	DELETE #TMP_TOBE_GLOBAL_PSI
	WHERE 1=1
	AND MEASURE = 'PACK_EOH'
	AND YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간
	
	;WITH BASE_DATA AS (
			-- 실적구간 - 팩출하
			SELECT   WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
					,WI.FROM_SITE 
					,WI.TO_SITE
					,SUM(WI.PLAN_QTY) AS PLAN_QTY
					,SUM(WI.PROD_QTY) AS PROD_QTY
			FROM	(
						SELECT	 WI.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
								,WI.FROM_SITE 
								,'-'			AS TO_SITE 
								,WI.QTY AS PLAN_QTY 
								, 0 AS PROD_QTY
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
							--INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
							--		ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간
						WHERE 1=1
						  --AND WI.MEASURE			IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
						  AND WI.MEASURE			IN ('SHIP_PLAN')
						  AND WI.OPERATION_GROUP	= 'P'			 -- 팩출하
						  AND WI.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						UNION ALL
						-- 실적구간 - 팩출하
						SELECT	 WI.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
								,WI.FROM_SITE 
								,'-'			AS TO_SITE 
								,0 AS PLAN_QTY
								,WI.QTY AS QTY 
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
						--	INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						--			ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간
						WHERE 1=1
						  AND WI.MEASURE			= 'PACK_PROD'
						  AND WI.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						UNION ALL
						SELECT	 WI.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
								,'-' AS FROM_SITE	--WI.FROM_SITE 
								,'-'			AS TO_SITE 
								,0 AS PLAN_QTY 
								,(-1)*WI.QTY AS PROD_QTY 
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
--							INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK)
--									ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간
--								   AND WI.YYYYMM = WL.YYYYMM
						WHERE 1=1
						  AND WI.MEASURE			= 'AS_IN_PLAN'
						  AND WI.OPERATION_GROUP	= 'P'			 -- Cell
						  AND WI.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
					) WI
			WHERE	1=1
			GROUP BY WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
					,WI.FROM_SITE 
					,WI.TO_SITE
	)
	INSERT INTO #TMP_TOBE_GLOBAL_PSI
	SELECT	 PG.YYYYPW
			,PG.ITEM_ID	
			,'PACK_EOH'			AS MEASURE
			,PG.FROM_SITE		AS FROM_SITE
			,PG.TO_SITE
			,'-'				AS INCOTERMS
			,'-'				AS VARIOUS_KEY
			,PG.OPERATION_GROUP
			,'-'				AS TO_SITE_TYPE
			,0.0				AS FROM_BOH_QTY
			,0.0				AS TO_BOH_QTY
			,SUM(PG.ACC_QTY)	OVER (PARTITION BY PG.ITEM_ID
													,PG.OPERATION_GROUP
													,PG.FROM_SITE
										ORDER BY  PG.YYYYPW )		AS QTY		
		FROM (
					SELECT BD.YYYYPW
							,BD.ITEM_ID
							,BD.FROM_SITE
							,BD.TO_SITE
							,BD.OPERATION_GROUP
							,SUM(BD.ACC_QTY) AS ACC_QTY
					FROM	(
								/*
								SELECT WL.YYYYPW
										,BD.ITEM_ID
										,BD.FROM_SITE
										,'-'			AS TO_SITE
										,BD.OPERATION_GROUP
										,CASE WHEN BD.YYYYPW = WL.YYYYPW THEN 
													ISNULL(CASE WHEN BD.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) 
											  ELSE 0 END ACC_QTY
								FROM BASE_DATA BD
									 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
											 ON WL.YYYYPW >=   @V_PLAN_START_YYYYPW  -- 미래 계획 구간
									 LEFT JOIN
										(
											SELECT	 WI.ITEM_ID
													,WI.OPERATION_GROUP
													,WI.FROM_SITE 
													,'-'			AS TO_SITE 
													,SUM(WI.QTY) AS BOH	--,SUM(WI.YYYYMM_PRVS_QTY) AS BOH 
											--FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK) -- TMP_TOBE_GLOBAL_PSI 가 나중에 생성되어 값이 차이 나 변경
											FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK)
											WHERE 1=1
											AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
											AND WI.MEASURE	= 'PACK_EOH'
											AND NOT EXISTS ( 
										   					SELECT 1
															FROM #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
															WHERE  MM.MODULE_ID = WI.ITEM_ID
															AND MM.PACK_MODULE_ITEM = 'N'
															)
											GROUP BY WI.ITEM_ID
													,WI.OPERATION_GROUP
													,WI.FROM_SITE 
											/*UNION ALL
											-- PACK_CELL_EOH 로 변환 될 수량 차감
											
											SELECT	 WI.ITEM_ID
													,WI.OPERATION_GROUP
													,WI.FROM_SITE 
													,'-'			AS TO_SITE 
													, (-1) * WI.YYYYMM_PRVS_QTY AS BOH 
											FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK) 
												LEFT JOIN #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
								 					   ON MM.MODULE_ID = WI.ITEM_ID
								 					  AND MM.PACK_MODULE_ITEM = 'N'
								 			WHERE 1=1
											AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
											AND WI.MEASURE	= 'PACK_EOH'
											AND WI.ITEM_ID  LIKE 'AMDAU%'
											*/
													
										) SO
										ON 1=1
										AND BD.ITEM_ID = SO.ITEM_ID
										AND BD.OPERATION_GROUP = SO.OPERATION_GROUP
										AND BD.FROM_SITE = SO.FROM_SITE
										*/
								SELECT WL.YYYYPW
										,BD.ITEM_ID
										,BD.FROM_SITE
										,'-'			AS TO_SITE
										,BD.OPERATION_GROUP
										,CASE WHEN BD.YYYYPW = WL.YYYYPW THEN 
													ISNULL(CASE WHEN BD.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(BD.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) 
											  ELSE 0 END ACC_QTY
								FROM 
										(
												SELECT BD.YYYYPW
													   ,BD.ITEM_ID
													   ,BD.OPERATION_GROUP
													   ,BD.FROM_SITE 
													   ,BD.TO_SITE
													   ,SUM(BD.BOH)  AS BOH
													   ,SUM(BD.PLAN_QTY) AS PLAN_QTY
													   ,SUM(BD.PROD_QTY) AS PROD_QTY
												FROM (
															SELECT	 BD.YYYYPW
																	,BD.ITEM_ID
																	,BD.OPERATION_GROUP
																	,BD.FROM_SITE 
																	,BD.TO_SITE
																	,0 AS BOH
																	,BD.PLAN_QTY AS PLAN_QTY
																	,BD.PROD_QTY AS PROD_QTY
															FROM	BASE_DATA BD
															UNION ALL
															SELECT	 @V_PLAN_START_YYYYPW AS YYYYPW
																	,WI.ITEM_ID
																	,WI.OPERATION_GROUP
																	,WI.FROM_SITE 
																	,'-'			AS TO_SITE 
																	,WI.QTY AS BOH	--,SUM(WI.YYYYMM_PRVS_QTY) AS BOH 
																	,0 AS PLAN_QTY
																	,0 AS PROD_QTY
															--FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK) -- TMP_TOBE_GLOBAL_PSI 가 나중에 생성되어 값이 차이 나 변경
															FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK)
															WHERE 1=1
															AND WI.YYYYPW	=  @V_RESULT_LAST_YYYYPW
															AND WI.MEASURE	= 'PACK_EOH'
															AND NOT EXISTS ( 
										   									SELECT 1
																			FROM #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
																			WHERE  MM.MODULE_ID = WI.ITEM_ID
																			AND MM.PACK_MODULE_ITEM = 'N'
																			)
															AND QTY <> 0
													) BD
												GROUP BY BD.YYYYPW
															,BD.ITEM_ID
															,BD.OPERATION_GROUP
															,BD.FROM_SITE 
															,BD.TO_SITE
										) BD
										INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
											 ON WL.YYYYPW >=   @V_PLAN_START_YYYYPW  -- 미래 계획 구간
								) BD
				WHERE 1=1
				GROUP BY BD.YYYYPW
						,BD.ITEM_ID
						,BD.FROM_SITE
						,BD.TO_SITE
						,BD.OPERATION_GROUP
			) PG
			;

			
			INSERT INTO #TMP_TOBE_GLOBAL_PSI
			SELECT	 WL.YYYYPW
					,WI.ITEM_ID
					,'PACK_EOH'			AS MEASURE
					,WI.FROM_SITE 
					,'-'				AS TO_SITE 
					,'-'				AS INCOTERMS
					,'-'				AS VARIOUS_KEY
					,WI.OPERATION_GROUP
					,'-'				AS TO_SITE_TYPE
					,0.0				AS FROM_BOH_QTY
					,0.0				AS TO_BOH_QTY
					,SUM(WI.QTY) AS QTY 
			FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
				INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			WHERE 1=1
			AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
			AND WI.MEASURE	= 'PACK_EOH'
			AND NOT EXISTS (
								SELECT	1
								FROM	#TMP_TOBE_GLOBAL_PSI X 
								WHERE	1=1
								AND		X.MEASURE = 'PACK_EOH'
								AND		X.ITEM_ID = WI.ITEM_ID
								AND		X.FROM_SITE = WI.FROM_SITE
								AND		X.OPERATION_GROUP = WI.OPERATION_GROUP
								--AND     X.YYYYPW >=  @V_PLAN_START_YYYYPW
								AND     X.YYYYPW =  @V_PLAN_START_YYYYPW
						   )
		   AND NOT EXISTS ( 
		   					SELECT 1
							FROM #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
							WHERE  MM.MODULE_ID = WI.ITEM_ID
							AND MM.PACK_MODULE_ITEM = 'N'
							)
			GROUP BY WL.YYYYPW
					,WI.ITEM_ID
					,WI.FROM_SITE 
					,WI.OPERATION_GROUP
				;	
		
	
		
	----------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Cell Inventory (셀공장)  measure 추가' 
	-- 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) 
	-- CELL_EOH	-- 고도화 
	----------------------------------------------------------------------------------------------------------
	DELETE #TMP_TOBE_GLOBAL_PSI
	WHERE 1=1
	AND MEASURE = 'CELL_EOH'
	AND YYYYPW >=  @V_PLAN_START_YYYYPW
	
	;WITH BASE_DATA AS (
			-- 실적구간 - 팩출하
			SELECT   WL.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
					,WI.FROM_SITE 
					,WI.TO_SITE
					,SUM(CASE WHEN WL.YYYYPW = WI.YYYYPW THEN WI.PLAN_QTY ELSE 0 END) AS PLAN_QTY
					,SUM(CASE WHEN WL.YYYYPW = WI.YYYYPW THEN WI.PROD_QTY ELSE 0 END) AS PROD_QTY
			FROM	(
						SELECT   WI.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
								,WI.FROM_SITE
								,WI.TO_SITE
								,SUM(WI.PLAN_QTY) AS PLAN_QTY
								,SUM(WI.PROD_QTY) AS PROD_QTY
						FROM	(
									SELECT	 WL.YYYYPW
											,WI.ITEM_ID
											,WI.OPERATION_GROUP
											,WI.FROM_SITE AS FROM_SITE	--WI.FROM_SITE 
											,'-'			AS TO_SITE 
											,CASE WHEN WI.MEASURE = 'SHIP_PLAN' THEN (CASE WHEN WI.YYYYPW = WL.YYYYPW THEN WI.QTY ELSE 0 END) * ISNULL(SM.CELL_CF,1) ELSE (CASE WHEN WI.YYYYPW = WL.YYYYPW THEN WI.QTY ELSE 0 END) END AS PLAN_QTY 
											, 0 AS PROD_QTY
									FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
										INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
												ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
											   AND WI.YYYYPW = WL.YYYYPW
										LEFT JOIN #SCP_MST_ITEM_CELL_CF SM WITH(NOLOCK) 
										   		ON SM.ITEM_ID = WI.ITEM_ID
									WHERE 1=1
									  AND WI.MEASURE			IN ( 'SEMI_SHIP_PLAN', 'SHIP_PLAN' )
									  AND WI.OPERATION_GROUP	= 'A'			 -- Cell
								) WI
						GROUP BY WI.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
								,WI.FROM_SITE
								,WI.TO_SITE

						UNION ALL
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
								,WI.FROM_SITE AS FROM_SITE	--WI.FROM_SITE 
								,'-'			AS TO_SITE 
								, 0 AS PLAN_QTY 
								, (CASE WHEN WI.YYYYPW = WL.YYYYPW THEN WI.QTY ELSE 0 END) AS PROD_QTY
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
							INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
								   AND WI.YYYYPW = WL.YYYYPW
						WHERE 1=1
						  AND WI.MEASURE			= 'CELL_CHAR_PLAN'
						  AND WI.OPERATION_GROUP	= 'A'			 -- Cell
						UNION ALL
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
								,'-' AS FROM_SITE	--WI.FROM_SITE 
								,'-'			AS TO_SITE 
								, 0 AS PLAN_QTY 
								, (-1)*WI.QTY AS PROD_QTY
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
							INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
								   AND WI.YYYYPW = WL.YYYYPW
						WHERE 1=1
						  AND WI.MEASURE			= 'AS_IN_PLAN'
						  AND WI.OPERATION_GROUP	= 'A'			 -- Cell
						UNION ALL
						SELECT	 @V_PLAN_START_YYYYPW AS YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
								,WI.FROM_SITE AS FROM_SITE 
								,'-'			AS TO_SITE 
								,0 AS PLAN_QTY 
								,0 AS PROD_QTY 
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
						WHERE 1=1
						AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
						AND WI.MEASURE	= 'CELL_EOH'
					) WI
					INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
							ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			WHERE	1=1
			GROUP BY WL.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
					,WI.FROM_SITE 
					,WI.TO_SITE
	)
	INSERT INTO #TMP_TOBE_GLOBAL_PSI
	SELECT	 DISTINCT
			 PG.YYYYPW
			,PG.ITEM_ID	
			,'CELL_EOH'			AS MEASURE
			,PG.FROM_SITE		AS FROM_SITE
			,PG.TO_SITE
			,'-'				AS INCOTERMS
			,'-'				AS VARIOUS_KEY
			,PG.OPERATION_GROUP
			,'-'				AS TO_SITE_TYPE
			,0.0				AS FROM_BOH_QTY
			,0.0				AS TO_BOH_QTY
			,SUM(PG.ACC_QTY)	OVER (PARTITION BY PG.ITEM_ID
													,PG.OPERATION_GROUP
													,PG.FROM_SITE
										ORDER BY  PG.YYYYPW )		AS QTY		
		FROM (
				SELECT BD.YYYYPW
						,BD.ITEM_ID
						,BD.FROM_SITE
						,BD.TO_SITE
						,BD.OPERATION_GROUP
						,SUM(BD.ACC_QTY) AS ACC_QTY
				FROM	(
							SELECT WL.YYYYPW
									,BD.ITEM_ID
									,BD.FROM_SITE
									,'-'			AS TO_SITE
									,BD.OPERATION_GROUP
									, CASE WHEN BD.YYYYPW = WL.YYYYPW THEN 
											ISNULL(CASE WHEN BD.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0)
										   ELSE 0 END ACC_QTY
								FROM BASE_DATA BD
									 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
											ON WL.YYYYPW >=   @V_PLAN_START_YYYYPW  -- 미래 계획 구간
									 LEFT JOIN
									(
											SELECT	 WI.ITEM_ID
													,WI.OPERATION_GROUP
													,WI.FROM_SITE
													,SUM(WI.BOH) AS BOH 
											FROM	(
														SELECT	 WI.ITEM_ID
																,WI.OPERATION_GROUP
																,WI.FROM_SITE AS FROM_SITE 
																,'-'			AS TO_SITE 
																, WI.QTY AS BOH 
														FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
														WHERE 1=1
														AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
														AND WI.MEASURE	= 'CELL_EOH'
													) WI
											GROUP BY WI.ITEM_ID, WI.OPERATION_GROUP, WI.FROM_SITE
											
													
										) SO
										ON 1=1
										AND BD.ITEM_ID = SO.ITEM_ID
										AND BD.OPERATION_GROUP = SO.OPERATION_GROUP
										AND BD.FROM_SITE = SO.FROM_SITE
						) BD
				WHERE 1=1
				GROUP BY BD.YYYYPW
						,BD.ITEM_ID
						,BD.FROM_SITE
						,BD.TO_SITE
						,BD.OPERATION_GROUP
			) PG
			;


			INSERT INTO #TMP_TOBE_GLOBAL_PSI
			SELECT  A.YYYYPW, A.ITEM_ID, A.MEASURE, A.FROM_SITE, A.TO_SITE, A.INCOTERMS, A.VARIOUS_KEY, A.OPERATION_GROUP, A.TO_SITE_TYPE
				   ,SUM(A.FROM_BOH_QTY) AS FROM_BOH_QTY, SUM(A.TO_BOH_QTY) AS TO_BOH_QTY, SUM(A.QTY) AS QTY
			FROM   (
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,'CELL_EOH'			AS MEASURE
								,WI.FROM_SITE		AS FROM_SITE 
								,'-'				AS TO_SITE 
								,'-'				AS INCOTERMS
								,'-'				AS VARIOUS_KEY
								,WI.OPERATION_GROUP
								,'-'				AS TO_SITE_TYPE
								,0.0				AS FROM_BOH_QTY
								,0.0				AS TO_BOH_QTY
								,(CASE WHEN WI.YYYYPW = WL.YYYYPW THEN WI.QTY ELSE 0 END) AS QTY 
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
							INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
									ON WL.YYYYPW >= @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						WHERE 1=1
						AND WI.YYYYPW	= @V_RESULT_LAST_YYYYPW
						AND WI.MEASURE	= 'CELL_EOH'
					) A
			 WHERE 1=1
			 AND A.ITEM_ID IS NOT NULL
			 AND NOT EXISTS (
									SELECT	1
									FROM	#TMP_TOBE_GLOBAL_PSI X 
									WHERE	1=1
									AND		X.MEASURE = 'CELL_EOH'
									AND		X.MEASURE = A.MEASURE
									AND		X.ITEM_ID = A.ITEM_ID
									and 	X.YYYYPW  >= @V_PLAN_START_YYYYPW
									AND		X.FROM_SITE = A.FROM_SITE
									--AND		X.OPERATION_GROUP = A.OPERATION_GROUP
							   )
			 GROUP BY A.YYYYPW, A.ITEM_ID, A.MEASURE, A.FROM_SITE, A.TO_SITE, A.INCOTERMS, A.VARIOUS_KEY, A.OPERATION_GROUP, A.TO_SITE_TYPE		
				;	
	
			UPDATE A
			SET	QTY = A.NEW_QTY
			FROM	(	
						SELECT  A.QTY, A.QTY / ISNULL(SM.CELL_CF,1) AS NEW_QTY
						FROM	#TMP_TOBE_GLOBAL_PSI A
								LEFT JOIN #SCP_MST_ITEM_CELL_CF SM WITH(NOLOCK) 
							   	   ON SM.ITEM_ID = A.ITEM_ID
						WHERE 1=1
						AND A.MEASURE = 'CELL_EOH'
						AND A.OPERATION_GROUP = 'P'
						AND A.YYYYPW >= @V_PLAN_START_YYYYPW
					) A

/*
	----- Begin :### 실적 구간 Ending Inventory Weekly 재고
	----- Begin :### 실적 구간 Ending Inventory Weekly 재고

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 참조 대상 품목 정보' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_TARGET_ITEM_FOR_ENDING_INV') IS NOT NULL	
			DROP TABLE #TMP_TARGET_ITEM_FOR_ENDING_INV;

		SELECT II.ITEM_ID
			  ,ISNULL(MAX(FI.FINISHED_PRODUCT),'N')	AS FINISHED_PRODUCT 
			  ,MAX(II.SCP_FLOW_ID)					AS OPERATION_ID
			  ,MAX(II.SCP_OPERATION_GROUP)			AS OPERATION_GROUP
		 INTO #TMP_TARGET_ITEM_FOR_ENDING_INV
		 FROM SCM_MST_ITEM_SN  II WITH(NOLOCK)   -- SCM_MST_ITEM_SN
			  LEFT  JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID		= II.ITEM_ID
		WHERE 1=1
		  AND II.DIVISION_ID = @V_DIVISION_ID
		  AND II.SCP_OPERATION_GROUP IN ('A', 'P')
		  AND (
			  II.ITEM_ID LIKE 'AMDAU%'
			  OR 
			  EXISTS (SELECT TOP 1 L.SEGMENT1
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
						WHERE L.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
						  AND L.SEGMENT1	= II.SCP_FLOW_ID
						  AND L.SEGMENT1   != 'F6000'
						  AND L.VALID_YN	= 'Y'
						  AND L.SEGMENT4 LIKE '%'+@V_DIVISION_ID+'%'
						)
			  )
		GROUP BY II.ITEM_ID


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 시뮬레이터 measure sloc 매핑 정보' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_SLOC_ADD_INFO') IS NOT NULL	
			DROP TABLE #TMP_SLOC_ADD_INFO;

		SELECT DISTINCT 	
			  SEGMENT1		AS PLANT	
			 ,SEGMENT2		AS SLOC	
			 ,ATTRIBUTE12	AS SIMU_MEASURE	
		 INTO #TMP_SLOC_ADD_INFO
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)	
		WHERE LOOKUP_TYPE = 'SLOC_ADD_INFO'	
		  AND ATTRIBUTE12 <> ''	
	

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - Raw 데이터' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_RAW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_RAW;

		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,IV.STORAGE_LOCATION
			  ,IV.PLANT_ID
			  ,IV.SUPPLIER_CODE
			  ,IV.QUANTITY
		 INTO #TMP_ENDING_INV_MM_RAW
		 FROM SCP_ANL_MONTH_END_STOCK_R IV WITH(NOLOCK)   
		WHERE IV.DIVISION_ID =  @V_DIVISION_ID
		  AND IV.YYYYMM     >=  @V_INV_FROM_YYYYMM 
		  AND IV.YYYYMM     <=  @V_INV_TO_YYYYMM
		  AND IV.SPECIAL_INVENTORY != 'W' --@@@ Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM_0 에 직접 입력함.

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - 1' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_0') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_0;

		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,II.OPERATION_ID
			  ,II.OPERATION_GROUP
			  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
			  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
			  ,CASE WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'P'		THEN 'PACK_EOH'
					WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'A'		THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_BOH'												THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH'		AND II.OPERATION_GROUP = 'A'		THEN 'PACK_CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_FOR_FORM_END'										THEN 'CELL_CHAR_AVAILABLE'
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7000'	THEN
						 CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')						THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'P5000'									THEN 'SEMI_INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT  = 'Y'	THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT != 'Y'	THEN 'SEMI_INTRANSIT'
							  ELSE 'ENDING_INV_FOR_DIO'
						  END 
					WHEN SM.SIMU_MEASURE = 'VMI'													THEN 'TO_SITE_EOH'		
					WHEN SM.SIMU_MEASURE = 'AS'														THEN 'AS_INV'		
					ELSE 'ENDING_INV_FOR_DIO'
				END AS MEASURE 
			  ,SUM(IV.QUANTITY)	AS QTY
		 INTO #TMP_ENDING_INV_MM_0
		 FROM #TMP_ENDING_INV_MM_RAW IV WITH(NOLOCK)   
			  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  INNER JOIN #TMP_SLOC_ADD_INFO SM WITH(NOLOCK)
					  ON SM.PLANT		= IV.PLANT_ID
					 AND SM.SLOC		= IV.STORAGE_LOCATION
			  LEFT JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= CASE WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'	AND IV.STORAGE_LOCATION = N'미착'
												   THEN IV.SUPPLIER_CODE
												   ELSE IV.PLANT_ID
											  END 
					 AND FS.OPERATION_GROUP	= CASE WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH'  -- pack plant cell
												   THEN 'P' 
												   ELSE II.OPERATION_GROUP
											   END 
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= CASE WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'	AND IV.STORAGE_LOCATION = N'미착'
												   THEN IV.PLANT_ID
												   ELSE 'Z'
											  END 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE 1=1
		GROUP BY IV.ITEM_ID
				,IV.YYYYMM
				,II.OPERATION_ID
				,II.OPERATION_GROUP
			    ,ISNULL(FS.SCM_SITE_ID, '-')
			    ,ISNULL(TS.SCM_SITE_ID, '-')
			  ,CASE WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'P'		THEN 'PACK_EOH'
					WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'A'		THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_BOH'												THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH'		AND II.OPERATION_GROUP = 'A'		THEN 'PACK_CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_FOR_FORM_END'										THEN 'CELL_CHAR_AVAILABLE'
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7000'	THEN
						 CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')						THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'P5000'									THEN 'SEMI_INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT  = 'Y'	THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT != 'Y'	THEN 'SEMI_INTRANSIT'
							  ELSE 'ENDING_INV_FOR_DIO'
						  END 
					WHEN SM.SIMU_MEASURE = 'VMI'													THEN 'TO_SITE_EOH'		
					WHEN SM.SIMU_MEASURE = 'AS'														THEN 'AS_INV'		
					ELSE 'ENDING_INV_FOR_DIO'
				END  
			;
		
		
		--@@@ Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM_0 에 직접 입력함.
		INSERT INTO #TMP_ENDING_INV_MM_0 
		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,II.OPERATION_ID
			  ,II.OPERATION_GROUP
			  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
			  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
			  ,'TO_SITE_EOH' AS MEASURE 
			  ,SUM(IV.QUANTITY)	AS QTY
		 FROM SCP_ANL_MONTH_END_STOCK_R IV WITH(NOLOCK)   
			  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= IV.PLANT_ID
					 AND FS.OPERATION_GROUP	= II.OPERATION_GROUP
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= 'Z' 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE IV.DIVISION_ID =  @V_DIVISION_ID
		  AND IV.YYYYMM     >=  @V_INV_FROM_YYYYMM 
		  AND IV.YYYYMM     <=  @V_INV_TO_YYYYMM
		  AND SPECIAL_INVENTORY = 'W' 
		GROUP BY IV.ITEM_ID
				,IV.YYYYMM
				,II.OPERATION_ID
				,II.OPERATION_GROUP
			    ,ISNULL(FS.SCM_SITE_ID, '-')
			    ,ISNULL(TS.SCM_SITE_ID, '-')
			;
		
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_RAW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_RAW;


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - 2 - 0채움' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM;

		;WITH MM_LIST AS (
			SELECT DISTINCT YYYYMM
			   FROM #TMP_PW_LIST WITH(NOLOCK)
			 WHERE 1=1
			   AND YYYYPW <= @V_PLAN_START_YYYYPW   -- 당월 포함 과거 구간만 
		)
		SELECT IM.ITEM_ID
			  ,ML.YYYYMM
			  ,IM.OPERATION_ID
			  ,IM.OPERATION_GROUP
			  ,IM.MEASURE
			  ,IM.FROM_SITE
			  ,IM.TO_SITE
			  ,SUM(CASE WHEN IM.YYYYMM = ML.YYYYMM THEN IM.QTY ELSE 0.0 END) AS QTY
		  INTO #TMP_ENDING_INV_MM  
		  FROM #TMP_ENDING_INV_MM_0 IM WITH(NOLOCK)
			   INNER JOIN MM_LIST ML
					   ON 1=1
		WHERE 1=1
		GROUP BY
			   IM.ITEM_ID
			  ,ML.YYYYMM
			  ,IM.OPERATION_ID
			  ,IM.OPERATION_GROUP
			  ,IM.MEASURE
			  ,IM.FROM_SITE
			  ,IM.TO_SITE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 주별 기초 재고 (전월재고)  ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_WW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_WW;

		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYPW_SEQ
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,EI.ITEM_ID
			  ,EI.OPERATION_GROUP
			  ,EI.FROM_SITE
			  ,EI.TO_SITE
			  ,EI.MEASURE
			  ,SUM(CASE WHEN WL.YYYYMM_PRVS = EI.YYYYMM THEN EI.QTY ELSE 0.0 END)	AS YYYYMM_PRVS_QTY 
		  INTO #TMP_ENDING_INV_MM_WW
		  FROM #TMP_PW_LIST WL WITH(NOLOCK)
				INNER JOIN #TMP_ENDING_INV_MM EI WITH(NOLOCK)
						ON 1=1
		WHERE 1=1
		  AND WL.YYYYPW < @V_PLAN_START_YYYYPW  -- 과거 실적 구간  
		GROUP BY 
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYPW_SEQ
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,EI.ITEM_ID
			  ,EI.OPERATION_GROUP
			  ,EI.FROM_SITE
			  ,EI.TO_SITE
			  ,EI.MEASURE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : TO_SITE_EOH(VMI) measure 추가' 
		-- 전주 재고(EOH)+ 금주도착(WH In) - 매출(RTF)
		-- 실적구간 고객향 도착 실적은 매출(RTF)과 동일함
		-- 당월 마지막 주를 제외하고 모두 전월 EOH와 동일함. 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT WI.YYYYPW
			  ,WI.ITEM_ID
			  ,WI.MEASURE
			  ,WI.FROM_SITE
			  ,WI.TO_SITE
			  ,'-'		AS INCOTERMS
			  ,'-'		AS VARIOUS_KEY
			  ,WI.OPERATION_GROUP
			  ,'-'		AS TO_SITE_TYPE
			  ,0.0		AS FROM_BOH_QTY
			  ,0.0		AS TO_BOH_QTY
			  ,CASE WHEN WI.PW_TO_YMD = WI.YYYYMM_LAST_YMD		-- 주 마지막일이 당월 마지막 일과 같을 경우 
					THEN MI.QTY									-- 당월말 재고
					ELSE WI.YYYYMM_PRVS_QTY						-- 전월말 재고 (기초재고)
			   END		AS QTY 
		FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK)  
			  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)			-- 당월말 재고 참조   
					 ON WI.YYYYMM		= MI.YYYYMM		
					AND WI.ITEM_ID		= MI.ITEM_ID	
					AND WI.FROM_SITE	= MI.FROM_SITE
					AND WI.TO_SITE		= MI.TO_SITE 
					AND WI.MEASURE		= MI.MEASURE 
		WHERE 1=1
		  AND WI.MEASURE = 'TO_SITE_EOH'


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales)' 
		-- 전주 재고(Intransit)  + 금주출하(Ship Plan) - 금주도착(WH In)
		-- 전월말 재고를 기초로 하여 당월 출하(Ship Plan)와 도착(Wh In) 누적 정보를 적용하여 계산 
		-- 고객향(to Sales)  도착(WH In) 실적은 매출(RTF)로 적용함.
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_INTRANSIT') IS NOT NULL	
			DROP TABLE #SHIP_FOR_INTRANSIT;

		-- 실적구간 - 출하 (to sales)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE		= 'SHIP_PLAN'
		  AND WI.TO_SITE_TYPE	= 'SALES'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			 ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) - 도착'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#WHIN_FOR_INTRANSIT') IS NOT NULL	
			DROP TABLE #WHIN_FOR_INTRANSIT;

		-- 실적구간 -  도착 (to sales)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_WHIN_QTY 
		 INTO #WHIN_FOR_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE		= 'WHIN'
		  AND WI.TO_SITE_TYPE	= 'SALES'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
	

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - Intransit 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.TO_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'INTRANSIT'
			UNION ALL 
			-- 실적구간 - 출하(FG) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #SHIP_FOR_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - 도착(FG) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_EXFACTORY_QTY
				  ,MM_ACC_WHIN_QTY	AS MM_ACC_WHIN_QTY
			 FROM #WHIN_FOR_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'INTRANSIT'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,'-'			AS INCOTERMS
			  ,'-'			AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'SALES'		AS TO_SITE_TYPE
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_EXFACTORY_QTY) - SUM(MM_ACC_WHIN_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
			  LEFT JOIN #SCM_MST_SITE TS 
					 ON TS.SCM_SITE_ID = BD.TO_SITE
		WHERE 1=1
		  AND ISNULL(TS.OPERATION_GROUP, '') != 'W' -- to AS Sales Site 제외
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant)' 
		-- 전주 재고(Intransit)  + 금주출하(Ship Plan) - 금주도착(WH In)
		-- 전월말 재고를 기초로 하여 당월 출하(Ship Plan)와 도착(Wh In) 누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_SEMI_INTRANSIT') IS NOT NULL	
			DROP TABLE #SHIP_FOR_SEMI_INTRANSIT;

		-- 실적구간 - 출하 (to Plant)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_SEMI_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE		= 'SEMI_SHIP_PLAN'
		  AND WI.TO_SITE_TYPE	= 'PLANT'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE

	
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) - 도착'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#WHIN_FOR_SEMI_INTRANSIT') IS NOT NULL	
			DROP TABLE #WHIN_FOR_SEMI_INTRANSIT;

		-- 실적구간 -  도착 (to Plant)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_WHIN_QTY 
		 INTO #WHIN_FOR_SEMI_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE		= 'SEMI_WHIN'
		  AND WI.TO_SITE_TYPE	= 'PLANT'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - semi Intransit 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.TO_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'SEMI_INTRANSIT'
			UNION ALL 
			-- 실적구간 - 출하(SEMI) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #SHIP_FOR_SEMI_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - 도착(SEMI) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_EXFACTORY_QTY
				  ,MM_ACC_WHIN_QTY	AS MM_ACC_WHIN_QTY
			 FROM #WHIN_FOR_SEMI_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'SEMI_INTRANSIT'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,'-'			AS INCOTERMS
			  ,'-'			AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'PLANT'		AS TO_SITE_TYPE
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_EXFACTORY_QTY) - SUM(MM_ACC_WHIN_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory ' 
		-- 전주 재고(Pack Inventory)  + 금주생산(Production-pack 해당월 누적) - 금주출하(Pack Ship 해당월 누적) 
		-- 전월말 재고를 기초로 하여 당월 생산과 당월 출하 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory - 생산'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PRODUCTION_FOR_PACK_INV') IS NOT NULL	
			DROP TABLE #PRODUCTION_FOR_PACK_INV;

		-- 실적구간 - 팩 생산
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,'-'			AS TO_SITE 
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_PROD_QTY 
		 INTO #PRODUCTION_FOR_PACK_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE   = 'PACK_PROD'
		  AND WI.YYYYPW	   <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_PACK_INV') IS NOT NULL	
			DROP TABLE #SHIP_FOR_PACK_INV;

		-- 실적구간 - 팩출하
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,'-'			AS TO_SITE 
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_PACK_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW < @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE			IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
		  AND WI.OPERATION_GROUP	= 'P'			 -- 팩출하
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - Pack Inventory 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.TO_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_PROD_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'PACK_EOH'
			UNION ALL 
			-- 실적구간 - 출하(FG) for  Pack Inventory
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_PROD_QTY
			 FROM #SHIP_FOR_PACK_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - 팩 생산 for Pack Inventory
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_EXFACTORY_QTY
				  ,MM_ACC_PROD_QTY
			 FROM #PRODUCTION_FOR_PACK_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'PACK_EOH'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,'-'			AS TO_SITE
			  ,'-'			AS INCOTERMS
			  ,'-'			AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'-'			AS TO_SITE_TYPE
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_PROD_QTY) - SUM(MM_ACC_EXFACTORY_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장)' 
		-- 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 
		-- 전월말 재고를 기초로 하여 해당월 도착/생산 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		/*
		모듈 공장의 Cell Inventory는
		P = 전주 재고(Cell Inventory) + 금주도착(Semi WH In) - 금주생산(Production)/팩수율
		자작 공장 무시하고, 위의 P가 마이너스이면, P=0으로 표시하고, 그 마이너스(P) 수량 만큼 동일 Plant의 셀 공장 measure에서 빼기
 
		셀 공장의 Cell Inventory는
		A = 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		*/


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Cell도착 '  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SEMI_WHIN_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #SEMI_WHIN_FOR_CELL_INV;

		-- 실적구간 - Cell 도착 (to Plant) - to 사이트 기준 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			 ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.TO_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW = WL.YYYYPW	-- 20240327 해당월 주 누적이 아닌 해당 주차 
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS WHIN_QTY												-- 20240327 해당월 주 누적이 아닌 해당 주차
		 INTO #SEMI_WHIN_FOR_CELL_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					 ON TS.SCM_SITE_ID		= WI.TO_SITE
					AND TS.OPERATION_GROUP	= 'P'	-- Pack plant 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE			= 'SEMI_WHIN'
		  AND WI.OPERATION_GROUP	= 'A'	-- Cell 
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.TO_SITE 	
			  

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 1 (수율)'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_1') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_1;

		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE
			  ,PR.OPERATION_GROUP
			  ,SUM(PR.ACTUAL_GOOD_QTY) 	AS PACK_PROD_QTY 
			  ,SUM(PR.ACTUAL_GOOD_QTY 
					/ CASE WHEN ISNULL(PY.YIELD,0) > 0 
						   THEN PY.YIELD
						   ELSE 1.0
					  END )	AS PACK_PROD_YIELD_QTY 
		  INTO #PACK_PRODUCTION_RESULT_1
		  FROM #PRODUCTION_RESULT PR WITH(NOLOCK)
			   INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					   ON WL.PW_FROM_YMD <= PR.PLAN_YYYYMMDD
					  AND WL.PW_TO_YMD   >= PR.PLAN_YYYYMMDD
			   LEFT JOIN SCP_MST_TACT_TIME_EXCEPT PY WITH(NOLOCK) 
					  ON PY.DIVISION_ID		= @V_DIVISION_ID
					 AND PY.PLANT_SITE_ID	= PR.FROM_SITE
					 AND PY.ITEM_ID			= PR.ITEM_ID
					 AND PY.OPERATION_ID	= PR.OPERATION_ID
					 AND PY.LINE_ID			= PR.LINE_ID 
					 AND PY.TACT_TIME_START_DATE <= PR.PLAN_YYYYMMDD
					 AND PY.TACT_TIME_END_DATE   >= PR.PLAN_YYYYMMDD
		WHERE 1=1
		  AND PR.OPERATION_GROUP = 'P' -- 팩 생산 실적 (실적구간) 
		GROUP BY 
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE
			  ,PR.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 2 (0채움)'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_2') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_2;

		-- 실적구간 - Cell 도착 (to Plant) - to 사이트 기준 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.OPERATION_GROUP
			  ,PR.FROM_SITE 	
			  ,SUM(CASE WHEN PR.YYYYMM = WL.YYYYMM AND PR.YYYYPW = WL.YYYYPW	-- 20240327 누적아닌 해당 주차
						THEN PR.PACK_PROD_QTY
						ELSE 0.0 
				   END)	AS PACK_PROD_QTY
			  ,SUM(CASE WHEN PR.YYYYMM = WL.YYYYMM AND PR.YYYYPW = WL.YYYYPW	-- 20240327 누적아닌 해당 주차
						THEN PR.PACK_PROD_YIELD_QTY
						ELSE 0.0 
				   END)	AS PACK_PROD_YIELD_QTY
		 INTO #PACK_PRODUCTION_RESULT_2
		 FROM #PACK_PRODUCTION_RESULT_1 PR WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.OPERATION_GROUP
			  ,PR.FROM_SITE 	


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 3 (대표cell * 셀환산계수)'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_3') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_3;

		SELECT CASE WHEN MI.MODEL_ID IS NOT NULL									-- AMDAU% 모듈 
					THEN MI.CELL_ITEM_ID
					WHEN PR.OPERATION_GROUP = 'P'	AND CI.CELL_ITEM_ID IS NOT NULL	-- Pack
					THEN CI.CELL_ITEM_ID
					WHEN PR.OPERATION_GROUP = 'P'	AND EC.CELL_ITEM_ID IS NOT NULL	-- Pack
					THEN EC.CELL_ITEM_ID
					ELSE NULL
			   END  AS REP_CELL_ITEM_ID		-- 대표셀 (CP:Cell Product) 모델 
			  ,CASE WHEN CF.CELL_CF		IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF.CELL_CF)
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF2.CELL_CF)
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF3.CELL_CF)
					ELSE CONVERT(NUMERIC(20,10), '1.0')
			   END  AS CELL_CF 
			  ,CASE WHEN CF.CELL_CF		IS NOT NULL		THEN 'CF'
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN 'CF2'
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN 'CF3'
					ELSE 'NULL'
			   END  AS CELL_CF_TYPE 
			   ,MI.MODULE_ID
			   ,PR.*
		 INTO #PACK_PRODUCTION_RESULT_3
		 FROM #PACK_PRODUCTION_RESULT_2 PR  WITH(NOLOCK)
			  LEFT JOIN #MODULE_MODEL_INFO MI WITH(NOLOCK)
					 ON MI.MODULE_ID		= PR.ITEM_ID
			  LEFT JOIN #CP_CELL_ITEM_INFO CI WITH(NOLOCK)
					 ON CI.MODEL_ID = CASE WHEN MI.MODEL_ID IS NOT NULL		-- AMDAU% 모듈
										   THEN MI.MODEL_ID
										   WHEN PR.OPERATION_GROUP = 'P'	-- 팩
										   THEN PR.ITEM_ID
										   ELSE ''
									  END 
			  LEFT  JOIN #ETC_CP_CELL_INFO EC WITH(NOLOCK)
					  ON EC.PARENT_ITEM_ID = PR.ITEM_ID
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF WITH(NOLOCK)
					  ON CF.ITEM_ID		= PR.ITEM_ID
					 AND CF.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF.CELL_CF) != 0.0
			 LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF2 WITH(NOLOCK)
					  ON CF2.ITEM_ID	   = LEFT(PR.ITEM_ID, LEN(PR.ITEM_ID) - 2) 
					 AND PR.ITEM_ID LIKE '%-_'
					 AND PR.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF IS NULL 
					 AND CF2.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF2.CELL_CF) != 0.0
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF3 WITH(NOLOCK)
					  ON CF3.ITEM_ID	   = LEFT(PR.ITEM_ID, LEN(PR.ITEM_ID) - 3) 
					 AND PR.ITEM_ID LIKE '%-__'
					 AND PR.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF  IS NULL 
					 AND CF2.CELL_CF IS NULL 
					 AND CF3.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF3.CELL_CF) != 0.0
		WHERE 1=1


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 계산 ' 
		-- 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_CELL_EOH_RESULT') IS NOT NULL	
			DROP TABLE #PACK_CELL_EOH_RESULT;

		;WITH BASE_DATA AS (
			-- 실적구간 - Pack공장 Cell 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.YYYYMM
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY			-- 전월말 기말재고
				  ,MI.QTY				AS MM_EOH_QTY			-- 당월말 기말재고
				  ,0.0					AS WHIN_QTY				-- 20240327 변경
				  ,0.0					AS PACK_PROD_QTY 		-- 20240327 변경
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)  -- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)			-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'PACK_CELL_EOH'
			UNION ALL 
			-- 실적구간 - Pack Plant Cell 도착 실적 
			SELECT SR.YYYYPW
				  ,SR.YYYYMM
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.TO_SITE			AS FROM_SITE			
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,WHIN_QTY									  -- 20240327 변경
				  ,0.0					AS PACK_PROD_QTY	   -- 20240327 변경
			 FROM #SEMI_WHIN_FOR_CELL_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - Pack 생산계획(수율역적용 -투입 기준) -> Cell 환산
			SELECT SR.YYYYPW
				  ,SR.YYYYMM
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.REP_CELL_ITEM_ID	AS ITEM_ID
				  ,SR.FROM_SITE
				  ,'A'					AS OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,0.0					AS WHIN_QTY										-- 20240327 변경
				  ,SUM(PACK_PROD_YIELD_QTY * ISNULL(CELL_CF,1.1))  AS PACK_PROD_QTY		-- 20240327 변경
			 FROM #PACK_PRODUCTION_RESULT_3 SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			  AND SR.REP_CELL_ITEM_ID IS NOT NULL
			GROUP BY 
				   SR.YYYYPW
				  ,SR.YYYYMM
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.REP_CELL_ITEM_ID
				  ,SR.FROM_SITE
		)
		, PACK_CELL_EOH_RESULT  AS (
			SELECT BD.YYYYPW
				  ,BD.YYYYMM
				  ,BD.PW_TO_YMD
				  ,BD.YYYYMM_LAST_YMD
				  ,BD.ITEM_ID
				  ,BD.FROM_SITE
				  ,'-'							AS TO_SITE
				  ,'-'							AS INCOTERMS
				  ,'-'							AS VARIOUS_KEY
				  ,BD.OPERATION_GROUP
				  ,'-'							AS TO_SITE_TYPE
				  ,0.0							AS FROM_BOH_QTY
				  ,0.0							AS TO_BOH_QTY
				  ,SUM(MM_EOH_QTY)				AS MM_EOH_QTY
				  ,SUM(MM_BOH_QTY)				AS MM_BOH_QTY
				  ,SUM(WHIN_QTY)				AS WHIN_QTY			-- 20240327 변경
				  ,SUM(PACK_PROD_QTY)			AS PACK_PROD_QTY	-- 20240327 변경
				-- 20240327 주석처리   ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
				-- 20240327 주석처리 		THEN SUM(MM_EOH_QTY)
				-- 20240327 주석처리 		ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_WHIN_QTY) - SUM(MM_ACC_PACK_PROD_QTY)
				-- 20240327 주석처리 	END			AS QTY
			 FROM BASE_DATA BD
			WHERE 1=1
			GROUP BY
				   BD.YYYYPW
				  ,BD.YYYYMM
				  ,BD.PW_TO_YMD
				  ,BD.YYYYMM_LAST_YMD
				  ,BD.ITEM_ID
				  ,BD.FROM_SITE
				  ,BD.OPERATION_GROUP
		)
		SELECT MAX(A.MM_WW_SEQ) OVER (PARTITION BY A.ITEM_ID
												  ,A.FROM_SITE
												  ,A.YYYYMM )		AS MM_WW_SEQ_MAX
			  ,A.*
		 INTO #PACK_CELL_EOH_RESULT 
		 FROM (
				SELECT  ROW_NUMBER() OVER (PARTITION BY  A.ITEM_ID  
														,A.FROM_SITE	 
														,A.YYYYMM 
												ORDER BY A.YYYYPW) AS MM_WW_SEQ 
					   ,A.*
				FROM PACK_CELL_EOH_RESULT  A 
				WHERE 1=1 
			  ) A 
		WHERE 1=1 


		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 계산 결과 조정 (마이너스 수량)'
		-- 월별 마지막주는 조정 대상에서 제외 (월 기말재고와 동일)
		-- 월별 둘째주부터 전주 마이너스 수량을 0으로 보정된 기준으로 당주 재고 수량 보정
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_CELL_EOH_RESULT_ADJ') IS NOT NULL	
			DROP TABLE #PACK_CELL_EOH_RESULT_ADJ;

		/* 20240327 변경전 
		;WITH RECURSIVE_DATA AS (
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,A.QTY	AS ORG_QTY 
				  ,A.QTY	
				  ,A.MM_EOH_QTY
				  ,A.MM_BOH_QTY
				  ,A.MM_ACC_WHIN_QTY
				  ,A.MM_ACC_PACK_PROD_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.QTY < 0 
						THEN A.QTY
						ELSE 0.0	
					END AS ACC_ADJ_QTY
			 FROM #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
			WHERE 1=1
			  AND A.MM_WW_SEQ = 1
			UNION ALL
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,A.QTY	AS ORG_QTY 
				  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX
						THEN A.QTY
						ELSE A.QTY - P.ACC_ADJ_QTY 
					END AS QTY 
				  ,A.MM_EOH_QTY
				  ,A.MM_BOH_QTY
				  ,A.MM_ACC_WHIN_QTY
				  ,A.MM_ACC_PACK_PROD_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.QTY - P.ACC_ADJ_QTY  < 0 and A.MM_WW_SEQ != A.MM_WW_SEQ_MAX -- 마지막 주차 제외 
						THEN A.QTY
						ELSE P.ACC_ADJ_QTY 
					END ACC_ADJ_QTY
			  FROM RECURSIVE_DATA p 
				   INNER JOIN #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
						   ON A.MM_WW_SEQ = P.MM_WW_SEQ + 1 
						  AND A.ITEM_ID	  = P.ITEM_ID
						  AND A.FROM_SITE = P.FROM_SITE
						  AND A.YYYYMM    = P.YYYYMM 
			WHERE 1=1
		)
		SELECT *
		 INTO #PACK_CELL_EOH_RESULT_ADJ
		 FROM RECURSIVE_DATA  A
		WHERE 1=1
*/

		;WITH RECURSIVE_DATA AS (
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				 ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,A.MM_BOH_QTY		AS BOH_QTY
				  ,A.WHIN_QTY
				  ,A.PACK_PROD_QTY
				  ,CASE WHEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN 0
						ELSE A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
				   END	AS EOH_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
						ELSE 0
				  END	AS ADJ_QTY_P
			 FROM #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
			WHERE 1=1
			  AND A.MM_WW_SEQ = 1
			UNION ALL
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,P.EOH_QTY		AS BOH_QTY-- 전주 EOH -> 당주 BOH
				  ,A.WHIN_QTY
				  ,A.PACK_PROD_QTY
				  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX	 -- 해당월 마지막 주차
						THEN A.MM_EOH_QTY
						WHEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN 0
						ELSE P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
				   END	AS EOH_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX	AND A.MM_EOH_QTY= 0 AND  P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 -- 해당월 마지막 주차
						THEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
						WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX	 -- 해당월 마지막 주차
						THEN 0
						WHEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
						ELSE 0
				   END	AS ADJ_QTY_P
			  FROM RECURSIVE_DATA p 
				   INNER JOIN #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
						   ON A.MM_WW_SEQ = P.MM_WW_SEQ + 1 
						  AND A.ITEM_ID	 = P.ITEM_ID
						  AND A.FROM_SITE = P.FROM_SITE
						  AND A.YYYYMM    = P.YYYYMM 
			WHERE 1=1
		)
		SELECT *
		 INTO #PACK_CELL_EOH_RESULT_ADJ
		 FROM RECURSIVE_DATA  A
		WHERE 1=1

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 추가 ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT PR.YYYYPW
			  ,PR.ITEM_ID
			  ,'PACK_CELL_EOH'	AS MEASURE
			  ,PR.FROM_SITE
			  ,'-'	AS TO_SITE
			  ,'-'	AS INCOTERMS
			  ,'-'	AS VARIOUS_KEY
			  ,'A'	AS OPERATION_GROUP 
			  ,'-'	AS TO_SITE_TYPE
			  ,0.0	AS FROM_BOH_QTY
			  ,0.0	AS TO_BOH_QTY
			  ,PR.EOH_QTY    -- 20240327    
			-- 20240327 변경   ,CASE WHEN PR.QTY < 0 
			-- 20240327 변경 		THEN 0.0 
			-- 20240327 변경 		ELSE PR.QTY 
			-- 20240327 변경 	END	AS QTY
		 FROM #PACK_CELL_EOH_RESULT_ADJ PR WITH(NOLOCK)
		WHERE 1=1


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)' 
		-- 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		-- 전월말 재고를 기초로 하여 해당월 생산/출하 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		/*
		모듈 공장의 Cell Inventory는
		P = 전주 재고(Cell Inventory) + 금주도착(Semi WH In) - 금주생산(Production)/팩수율
		자작 공장 무시하고, 위의 P가 마이너스이면, P=0으로 표시하고, 그 마이너스(P) 수량 만큼 동일 Plant의 셀 공장 measure에서 빼기
 
		셀 공장의 Cell Inventory는
		A = 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		*/


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장) - Char Plan' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CELL_CHAR_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #CELL_CHAR_FOR_CELL_INV;

		-- 실적구간 - 셀 특성 생산 실적 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END) AS MM_ACC_CELL_CHAR_QTY 
		 INTO #CELL_CHAR_FOR_CELL_INV  
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_CHAR_PLAN'
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장) - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #SHIP_FOR_CELL_INV;

		-- 실적구간 - Cell 출하
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,'-'			AS TO_SITE 
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_CELL_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE			IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
		  AND WI.OPERATION_GROUP	= 'A'			 -- Cell 출하
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  - semi ship plan site' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#ITEM_SEMI_SHIP_SITE') IS NOT NULL	
			DROP TABLE #ITEM_SEMI_SHIP_SITE;

		SELECT SS.ITEM_ID
			  ,SS.TO_SITE			AS PACK_SITE
			  ,MAX(CASE WHEN SS.YYYYPW <   @V_PLAN_START_YYYYPW THEN SS.FROM_SITE ELSE NULL END)	AS CELL_SITE_PAST
			  ,MAX(CASE WHEN SS.YYYYPW >=  @V_PLAN_START_YYYYPW THEN SS.FROM_SITE ELSE NULL END)	AS CELL_SITE_FUTURE
		INTO #ITEM_SEMI_SHIP_SITE
		FROM #TMP_TOBE_GLOBAL_PSI SS with(nolock)
			 INNER JOIN #SCM_MST_SITE PS WITH(NOLOCK) -- pack site 
					 ON PS.SCM_SITE_ID		= SS.TO_SITE 
					AND PS.OPERATION_GROUP	= 'P'
			 INNER JOIN #SCM_MST_SITE CS WITH(NOLOCK)	-- cell site 
					 ON CS.SCM_SITE_ID		= SS.FROM_SITE 
					AND CS.OPERATION_GROUP	= 'A'
		WHERE 1=1
		  AND SS.MEASURE = 'SEMI_SHIP_PLAN'
		  AND SS.QTY != 0 
		GROUP BY SS.ITEM_ID
				,SS.TO_SITE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  - P (팩공장 셀재고 마이너스 수량)' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PROD_FOR_CELL_PLANT_INV') IS NOT NULL	
			DROP TABLE #PACK_PROD_FOR_CELL_PLANT_INV;
				
		SELECT PR.YYYYPW
			  ,PR.YYYYMM
			  ,PR.PW_TO_YMD
			  ,PR.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE 
			  ,SUM(AP.ADJ_QTY_P) AS ADJ_QTY_P  --- 20240327 
			  --- 20240327 ,SUM(CASE WHEN AP.QTY < 0 THEN AP.QTY ELSE 0.0 END) AS QTY
		INTO #PACK_PROD_FOR_CELL_PLANT_INV
		FROM #PACK_CELL_EOH_RESULT_ADJ PR WITH(NOLOCK)
			 LEFT JOIN #PACK_CELL_EOH_RESULT_ADJ AP WITH(NOLOCK)
				    ON AP.YYYYMM	= PR.YYYYMM
				   AND AP.ITEM_ID	= PR.ITEM_ID
				   AND AP.FROM_SITE = PR.FROM_SITE 
				   AND AP.YYYYPW   <= PR.YYYYPW
		GROUP BY 
			   PR.YYYYPW
			  ,PR.YYYYMM
			  ,PR.PW_TO_YMD
			  ,PR.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE
		HAVING SUM(AP.ADJ_QTY_P) != 0 
		-- 20240327 HAVING SUM(CASE WHEN AP.QTY < 0 THEN AP.QTY ELSE 0.0 END) != 0 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  measure 추가' 
		-- 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) 
		--                           + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - 셀공장 Cell 기초 재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY			-- 전월말 기말재고
				  ,MI.QTY				AS MM_EOH_QTY			-- 당월말 기말재고
				  ,0.0					AS MM_ACC_PROD_QTY
				  ,0.0					AS MM_ACC_SHIP_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'CELL_EOH'
			UNION ALL 
			-- 실적구간 - Production(PKG)
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_CELL_CHAR_QTY	AS MM_ACC_PROD_QTY
				  ,0.0					AS MM_ACC_SHIP_QTY
			 FROM #CELL_CHAR_FOR_CELL_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - Cell Char
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0						AS MM_BOH_QTY
				  ,0.0						AS MM_EOH_QTY
				  ,0.0						AS MM_ACC_PROD_QTY
				  ,SR.MM_ACC_EXFACTORY_QTY	AS MM_ACC_SHIP_QTY
			 FROM #SHIP_FOR_CELL_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- + P (If P가 마이너스 경우만, 동일 공장에서 빼기) 
			SELECT PR.YYYYPW
				  ,PR.PW_TO_YMD
				  ,PR.YYYYMM_LAST_YMD
				  ,PR.ITEM_ID
				  ,ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE))	AS FROM_SITE -- cell plant 
				  ,'A'						AS OPERATION_GROUP 
				  ,0.0						AS MM_BOH_QTY
				  ,0.0						AS MM_EOH_QTY
				  ,PR.ADJ_QTY_P				AS MM_ACC_PROD_QTY  -- P: 음수값  20240327 변경 
				  ,0.0						AS MM_ACC_SHIP_QTY
			 FROM #PACK_PROD_FOR_CELL_PLANT_INV PR WITH(NOLOCK)
				  INNER JOIN #SCM_MST_SITE PP WITH(NOLOCK)	-- pack plant site 
						  ON PP.SCM_SITE_ID		= PR.FROM_SITE
				  LEFT JOIN #SCM_MST_SITE CP WITH(NOLOCK)	-- cell plant site 
						  ON CP.PLANT_ID		= PP.PLANT_ID
						 AND CP.OPERATION_GROUP = 'A'
						 AND CP.SITE_TYPE		= 'PLANT'
				  LEFT  JOIN #ITEM_SEMI_SHIP_SITE SS WITH(NOLOCK)
						  ON SS.ITEM_ID			= PR.ITEM_ID 
						 AND SS.PACK_SITE		= PP.SCM_SITE_ID -- pack site 
			WHERE 1=1
			   --- 20240327 불필요 조건 삭제 
			  AND ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE)) IS NOT NULL
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,ISNULL(ISNULL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), BD.ITEM_ID)  AS ITEM_ID -- 20240118 CP->CA 치환 적용 
			  ,'CELL_EOH'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,'-'						AS TO_SITE
			  ,'-'						AS INCOTERMS
			  ,'-'						AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'-'						AS TO_SITE_TYPE
			  ,0.0						AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_PROD_QTY) - SUM(MM_ACC_SHIP_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
			   LEFT JOIN #SCM_MST_SITE FS WITH(NOLOCK)
					  ON FS.SCM_SITE_ID			= BD.FROM_SITE
			   LEFT JOIN #CELL_PROD_ASSY_MAP CA1 WITH(NOLOCK)
					  ON CA1.PLANT_ID			= FS.PLANT_ID 
					 AND CA1.ITEM_ID_PROD		= BD.ITEM_ID
					 AND CA1.ASSY_PRIORITY_1ST	= 1 
			   LEFT JOIN #CELL_PROD_ASSY_MAP CA2 WITH(NOLOCK)
					  ON CA2.ITEM_ID_PROD		= BD.ITEM_ID
					 AND CA2.ASSY_PRIORITY_2ND	= 1
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,ISNULL(ISNULL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), BD.ITEM_ID)
			  ,BD.FROM_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available' 
		-- 전주 재고(Char. Available)  + 금주생산(Production(PKG)) -  금주 특성 생산 실적 (Char.Plan) / 활성화특성수율
		-- 전월말 재고를 기초로 하여 해당월 도착/생산 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available - 셀 생산실적'   
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CELL_PROD_FOR_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #CELL_PROD_FOR_CHAR_AVAILABLE;

		-- 실적구간 - 셀 생산실적 (from site) 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_CELL_PROD_QTY 
		 INTO #CELL_PROD_FOR_CHAR_AVAILABLE
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_PROD'
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available - 셀 특성 실적(투입기준)'   
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CELL_CHAR_FOR_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #CELL_CHAR_FOR_CHAR_AVAILABLE;

		-- 실적구간 - 셀 특성 실적 / 활성화특성수율  
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	/ CASE WHEN CY.CHAR_YIELD > 0 
							   THEN CY.CHAR_YIELD
							   ELSE 1
						  END   AS MM_ACC_CELL_CHAR_QTY 
		 INTO #CELL_CHAR_FOR_CHAR_AVAILABLE  
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 LEFT  JOIN #SCP_MST_FORMATION CY WITH(NOLOCK)
					 ON CY.PLANT_SITE_ID	= WI.FROM_SITE
					AND CY.ITEM_ID			= WI.ITEM_ID
					AND CY.YYYYPW			= WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_CHAR_PLAN'			-- 셀 특성 실적 (활성화특성수율 역적용) 
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,CASE WHEN CY.CHAR_YIELD > 0 
					THEN CY.CHAR_YIELD
					ELSE 1
				END


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available (Formation Progress 포함?) 추가' 
		-- 전주 재고(Char. Available)  + 금주생산(Production(PKG)) -  금주 특성 생산 실적 (Char.Plan) / 활성화특성수율
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PAST_CELL_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #PAST_CELL_CHAR_AVAILABLE;

		;WITH BASE_DATA AS (
			-- 실적구간 -Char. Available 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_CELL_PROD_QTY
				  ,0.0					AS MM_ACC_CELL_CHAR_QTY 
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'CELL_CHAR_AVAILABLE'
			UNION ALL 
			-- 실적구간 - Production(PKG)
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_CELL_PROD_QTY
				  ,0.0					AS MM_ACC_CELL_CHAR_QTY
			 FROM #CELL_PROD_FOR_CHAR_AVAILABLE SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - Cell Char
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				 ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_CELL_PROD_QTY
				  ,SR.MM_ACC_CELL_CHAR_QTY
			 FROM #CELL_CHAR_FOR_CHAR_AVAILABLE SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'CELL_CHAR_AVAILABLE'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,'-'						AS TO_SITE
			  ,'-'						AS INCOTERMS
			  ,'-'						AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'-'						AS TO_SITE_TYPE
			  ,0.0						AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_CELL_PROD_QTY) - SUM(MM_ACC_CELL_CHAR_QTY)
				END			AS QTY
		 INTO #PAST_CELL_CHAR_AVAILABLE
		 FROM BASE_DATA BD
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress 분리' 
		-- 2023.11.22 요구사항 
		-- 과거 실적의 활성화와 특성 분리
		-- 현재 로직 : 과거 실적 재고 중에 활성화 재고는 모두 Char. Available에 반영되어 있음
		-- 이것을 Remain Lead Time이 0이 아닌 것을 Ending Inventory에서 Formation Progress로 차감하여 반영
		-- 만약 해당 cutoff 일의 Formation Progress > Ending Inventory 이면 Ending Inventory이 Max 값으로 설정
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : FP Aging Stock' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#FP_AGING_STOCK') IS NOT NULL	
		DROP TABLE #FP_AGING_STOCK;

		SELECT WL.YYYYPW
			  ,SA.CUTOFF_DATE
			  ,PS.SCM_SITE_ID	AS FROM_SITE
			  ,SA.ITEM_ID
			  ,SUM(CASE WHEN SA.REMAIN_LEAD_TIME = 0 THEN SA.QTY ELSE 0 END)	AS FP_CHAR_AVAILABLE
			  ,SUM(CASE WHEN SA.REMAIN_LEAD_TIME > 0 THEN SA.QTY ELSE 0 END)	AS FP_FORM_PROGRESS
			  ,SUM(SA.QTY)														AS FP_AGING_TOTAL
			  ,'A'																AS DIV
		 INTO #FP_AGING_STOCK
		 FROM #TMP_PW_LIST WL WITH(NOLOCK)
			  INNER JOIN SCM_DNM_STOCK_AGING_SN SA WITH(NOLOCK) 
			  	  ON 1=1 
					 AND SA.CUTOFF_DATE = WL.PW_TO_YMD_NEXT_DAY
					 AND SA.DIVISION_ID = @V_DIVISION_ID
			  INNER JOIN #SCM_MST_SITE PS WITH(NOLOCK) 
					  ON PS.PLANT_ID		= SA.PLANT_ID
					 AND PS.SITE_TYPE		= 'PLANT'
					 AND PS.OPERATION_GROUP = 'A'	-- Cell  
		WHERE 1=1
		  AND WL.YYYYPW	<  @V_PLAN_START_YYYYPW -- 과거 실적 구간
		GROUP BY WL.YYYYPW
			  ,SA.CUTOFF_DATE
			  ,PS.SCM_SITE_ID
			  ,SA.ITEM_ID
	
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : FP Aging Stock (현재 없는 기 적재된 데이터)' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #FP_AGING_STOCK
		SELECT GP.YYYYPW
			  ,CONVERT(DATE, GP.VARIOUS_KEY, 112)	AS CUTOFF_DATE
			  ,GP.FROM_SITE
			 ,GP.ITEM_ID
			  ,CONVERT(NUMERIC(20,10), ATTRIBUTE1)	AS FP_CHAR_AAILABLE
			  ,GP.QTY								AS FP_FORM_PROGRESS
			  ,CONVERT(NUMERIC(20,10), ATTRIBUTE2)	AS FP_AGING_TOTAL
			  ,'B'									AS DIV
		 FROM SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK)
		WHERE 1=1
	      AND GP.PLAN_START_YYYYMMDD = '00000000'
		  AND GP.DIVISION_ID		 = @V_DIVISION_ID
		  AND GP.YYYYPW				 < @V_PLAN_START_YYYYPW -- 과거 실적 구간
		  AND GP.MEASURE			 = 'FORM_PROGRESS'
		  AND NOT EXISTS (SELECT *
							FROM #FP_AGING_STOCK SA
						   WHERE 1=1
						     AND SA.YYYYPW		= GP.YYYYPW
							 AND SA.FROM_SITE	= GP.FROM_SITE
							 AND SA.ITEM_ID		= GP.ITEM_ID)


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress - FP Aging Stock 반영' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PAST_FORM_PROGRESS_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #PAST_FORM_PROGRESS_CHAR_AVAILABLE;

		SELECT MI.YYYYPW
			  ,MI.ITEM_ID
			  ,MI.FROM_SITE					AS FROM_SITE
			  ,MI.OPERATION_GROUP			AS OPERATION_GROUP
			  ,CASE WHEN MI.QTY <  0  -- qty가 마이너스인 경우 고려 
					THEN MI.QTY
					WHEN MI.QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN MI.QTY -  ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE 0
				END								AS CHAR_AVAILABLE
			  ,CASE WHEN MI.QTY <  0  -- qty가 마이너스인 경우 고려 
					THEN 0
					WHEN MI.QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE MI.QTY
			   END								AS FORM_PROGRESS 
			  ,MI.QTY							AS ENDING_INVENTORY
			  ,ISNULL(FA.FP_FORM_PROGRESS, 0)	AS FP_FORM_PROGRESS
		  INTO #PAST_FORM_PROGRESS_CHAR_AVAILABLE
		  FROM #PAST_CELL_CHAR_AVAILABLE MI WITH(NOLOCK)
			   LEFT JOIN #FP_AGING_STOCK FA WITH(NOLOCK)
					  ON FA.YYYYPW		= MI.YYYYPW
					 AND FA.FROM_SITE	= MI.FROM_SITE
					 AND FA.ITEM_ID		= MI.ITEM_ID
		 WHERE 1=1
		   AND MI.YYYYPW  < @V_PLAN_START_YYYYPW -- 과거 실적 구간


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH TARGET_MEASURE AS (
			SELECT 'CELL_FORM_PROGRESS' AS MEASURE 
			UNION ALL
			SELECT 'CELL_CHAR_AVAILABLE' AS MEASURE 
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT EI.YYYYPW
			  ,EI.ITEM_ID
			  ,TM.MEASURE
			  ,EI.FROM_SITE			AS FROM_SITE
			  ,'-'			AS TO_SITE
			  ,'-'					AS INCOTERMS
			  ,'-'					AS VARIOUS_KEY -- 생산라인 or 운송모드 or 프로젝트
			  ,EI.OPERATION_GROUP	AS OPERATION_GROUP
			  ,'-'					AS TO_SITE_TYPE 
			  ,0.0					AS FROM_BOH_QTY
			  ,0.0					AS TO_BOH_QTY
			  ,CASE WHEN TM.MEASURE = 'CELL_FORM_PROGRESS'
					THEN FORM_PROGRESS
					ELSE CHAR_AVAILABLE
				END					AS QTY
		  FROM #PAST_FORM_PROGRESS_CHAR_AVAILABLE EI WITH(NOLOCK)
				INNER JOIN TARGET_MEASURE TM 
						ON 1=1 
		 WHERE 1=1

	----- End : Ending Inventory (과거 실적 구간 재고)
*/

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121)  + N' ### 대표Cell 품목 매핑 : 대표 Cell 품목 정보 추가'  
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO') IS NOT NULL
			DROP TABLE #TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO;

		SELECT CASE WHEN MI.MODEL_ID IS NOT NULL									-- AMDAU% 모듈 
					THEN MI.CELL_ITEM_ID
					WHEN GP.OPERATION_GROUP = 'P'	AND CI.CELL_ITEM_ID IS NOT NULL	-- Pack
					THEN CI.CELL_ITEM_ID
					WHEN GP.OPERATION_GROUP = 'P'	AND EC.CELL_ITEM_ID IS NOT NULL	-- Pack
					THEN EC.CELL_ITEM_ID
					WHEN GP.OPERATION_GROUP = 'A'  AND FI.CELL_TYPE LIKE 'CA%'
					THEN ISNULL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD)
					WHEN GP.OPERATION_GROUP = 'A'  AND FI.CELL_TYPE LIKE 'CP%'
					THEN GP.ITEM_ID
					ELSE NULL
			   END  AS REP_CELL_ITEM_ID		-- 대표셀 (CP:Cell Product) 모델 
			   ,MI.MODULE_ID
			   ,GP.*
		 INTO #TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO
		 FROM #TMP_TOBE_GLOBAL_PSI GP  WITH(NOLOCK)
			  LEFT JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)  
				      ON FI.ITEM_ID			= GP.ITEM_ID
			  LEFT JOIN #MODULE_MODEL_INFO MI WITH(NOLOCK)
					 ON MI.MODULE_ID		= GP.ITEM_ID
			  LEFT JOIN #CP_CELL_ITEM_INFO CI WITH(NOLOCK)
					 ON CI.MODEL_ID = CASE WHEN MI.MODEL_ID IS NOT NULL		-- AMDAU% 모듈
										   THEN MI.MODEL_ID
										   WHEN GP.OPERATION_GROUP = 'P'	-- 팩
										   THEN GP.ITEM_ID
										   ELSE ''
									  END 
			  LEFT  JOIN #ETC_CP_CELL_INFO EC WITH(NOLOCK)
					  ON EC.PARENT_ITEM_ID = GP.ITEM_ID
			  LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)
					  ON GP.OPERATION_GROUP = 'A'
					 AND FS.SCM_SITE_ID		= GP.FROM_SITE
					 AND FS.SITE_TYPE		= 'PLANT'
			  LEFT  JOIN #CELL_PROD_ASSY_MAP C1
					  ON GP.OPERATION_GROUP = 'A'
					 AND C1.PLANT_ID		= FS.PLANT_ID
					 AND C1.ITEM_ID_ASSY	= GP.ITEM_ID
					 AND C1.CP_PRIORITY_1ST	= 1
			  LEFT  JOIN #CELL_PROD_ASSY_MAP C2
					  ON GP.OPERATION_GROUP = 'A'
					 AND C2.ITEM_ID_ASSY	= GP.ITEM_ID
					 AND C2.CP_PRIORITY_2ND	= 1
		WHERE 1=1


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 셀그룹 및 환산수량 정보 추가 ' 
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_RPT_GLOBAL_PSI_MD_WW') IS NOT NULL
			DROP TABLE #SCP_RPT_GLOBAL_PSI_MD_WW;   

		SELECT CASE WHEN ISNULL(FI.GROUP_CODE1,'')	= '' 
					THEN GP.REP_CELL_ITEM_ID 
					ELSE FI.GROUP_CODE1
				END AS CELL_GROUP
			  ,CASE WHEN ISNULL(FI.GROUP_CODE1,'')	= '' 
					THEN 'N' 
					ELSE 'Y'
				END AS CELL_GROUP_YN	-- 20240311 
			  ,CASE WHEN GP.OPERATION_GROUP = 'A'		THEN CONVERT(NUMERIC(20,10), '1.0')
			   		WHEN CF.CELL_CF		IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF.CELL_CF)
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF2.CELL_CF)
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF3.CELL_CF)
					ELSE CONVERT(NUMERIC(20,10), '1.0')
			   END  AS CELL_CF 
			  ,CASE WHEN GP.OPERATION_GROUP = 'A'		THEN 'CELL'
			   		WHEN CF.CELL_CF		IS NOT NULL		THEN 'CF'
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN 'CF2'
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN 'CF3'
					ELSE 'NULL'
			   END  AS CELL_CF_TYPE 
			  ,GP.* 
		 INTO #SCP_RPT_GLOBAL_PSI_MD_WW
		 FROM #TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO GP WITH(NOLOCK) 
			  LEFT  JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)   --- cell group 정보 참조
					  ON FI.ITEM_ID		= GP.REP_CELL_ITEM_ID 
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF WITH(NOLOCK)
					  ON CF.ITEM_ID		= GP.ITEM_ID
					 AND CF.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF.CELL_CF) != 0.0
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF2 WITH(NOLOCK)
					  ON CF2.ITEM_ID	   = LEFT(GP.ITEM_ID, LEN(GP.ITEM_ID) - 2) 
					 AND GP.ITEM_ID LIKE '%-_'
					 AND GP.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF IS NULL 
					 AND CF2.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF2.CELL_CF) != 0.0
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF3 WITH(NOLOCK)
					  ON CF3.ITEM_ID	   = LEFT(GP.ITEM_ID, LEN(GP.ITEM_ID) - 3) 
					 AND GP.ITEM_ID LIKE '%-__'
					 AND GP.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF  IS NULL 
					 AND CF2.CELL_CF IS NULL 
					 AND CF3.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF3.CELL_CF) != 0.0
		WHERE 1=1 
		  AND GP.REP_CELL_ITEM_ID IS NOT NULL  -- 대표 Cell 정보가 없는 건 제외 
			;
		
		--@@@ BOM 정보에 문제가 있는 경우 (=하위셀을 못찾을경우) 해당 모듈팩에 대한 Group code 를 찾아 Global PSI New 재고로 반영
		INSERT INTO #SCP_RPT_GLOBAL_PSI_MD_WW
		SELECT CASE WHEN ISNULL(FI.GROUP_CODE1,'')	= '' 
					THEN GP.REP_CELL_ITEM_ID 
					ELSE FI.GROUP_CODE1
				END AS CELL_GROUP
			  ,CASE WHEN ISNULL(FI.GROUP_CODE1,'')	= '' 
					THEN 'N' 
					ELSE 'Y'
				END AS CELL_GROUP_YN	-- 20240311 
			  ,CASE WHEN GP.OPERATION_GROUP = 'A'		THEN CONVERT(NUMERIC(20,10), '1.0')
			   		WHEN CF.CELL_CF		IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF.CELL_CF)
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF2.CELL_CF)
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF3.CELL_CF)
					ELSE CONVERT(NUMERIC(20,10), '1.0')
			   END  AS CELL_CF 
			  ,CASE WHEN GP.OPERATION_GROUP = 'A'		THEN 'CELL'
			   		WHEN CF.CELL_CF		IS NOT NULL		THEN 'CF'
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN 'CF2'
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN 'CF3'
					ELSE 'NULL'
			   END  AS CELL_CF_TYPE 
			  ,GP.* 
		 FROM #TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO GP WITH(NOLOCK) 
			   INNER  JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)   --- cell group 정보 참조
					  ON FI.ITEM_ID		= GP.ITEM_ID 	-- REP_CELL_ITEM_ID 대신 ITEM 기준으로
					  AND FI.GROUP_CODE1 IS NOT NULL
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF WITH(NOLOCK)
					  ON CF.ITEM_ID		= GP.ITEM_ID
					 AND CF.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF.CELL_CF) != 0.0
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF2 WITH(NOLOCK)
					  ON CF2.ITEM_ID	   = LEFT(GP.ITEM_ID, LEN(GP.ITEM_ID) - 2) 
					 AND GP.ITEM_ID LIKE '%-_'
					 AND GP.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF IS NULL 
					 AND CF2.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF2.CELL_CF) != 0.0
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF3 WITH(NOLOCK)
					  ON CF3.ITEM_ID	   = LEFT(GP.ITEM_ID, LEN(GP.ITEM_ID) - 3) 
					 AND GP.ITEM_ID LIKE '%-__'
					 AND GP.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF  IS NULL 
					 AND CF2.CELL_CF IS NULL 
					 AND CF3.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF3.CELL_CF) != 0.0
		WHERE 1=1 
		  AND GP.REP_CELL_ITEM_ID IS NULL  -- 대표 Cell 정보가 없는 건 
				;
		
		UPDATE #SCP_RPT_GLOBAL_PSI_MD_WW
		SET	REP_CELL_ITEM_ID = ITEM_ID
		WHERE 1=1
		AND REP_CELL_ITEM_ID IS NULL 
			;
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### GAP(RTF - MKT_FCST) measure' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#GAP_RTF_MKT_FCST') IS NOT NULL
			DROP TABLE #GAP_RTF_MKT_FCST;

		SELECT GP.CELL_GROUP
			  ,GP.CELL_GROUP_YN	-- 20240311 
			  ,GP.CELL_CF
			  ,GP.CELL_CF_TYPE
			  ,GP.REP_CELL_ITEM_ID
			  ,GP.MODULE_ID
			  ,GP.YYYYPW
			  ,GP.ITEM_ID
			  ,CONVERT(NVARCHAR(10), 'GAP')	AS MEASURE
			  ,GP.FROM_SITE
			  ,GP.TO_SITE
			  ,GP.INCOTERMS
			  ,GP.VARIOUS_KEY
			  ,GP.OPERATION_GROUP
			  ,GP.TO_SITE_TYPE
			  ,GP.FROM_BOH_QTY
			  ,GP.TO_BOH_QTY
			  ,SUM(CASE WHEN GP.MEASURE = 'MKT_FCST' THEN GP.QTY * (-1) ELSE GP.QTY END)	AS QTY
		 INTO #GAP_RTF_MKT_FCST
		 FROM #SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK)
		WHERE 1=1
		  AND GP.MEASURE IN ('MKT_FCST', 'RTF') 
		  AND GP.YYYYPW >= @V_PLAN_START_YYYYPW
		GROUP BY 
			   GP.CELL_GROUP
			  ,GP.CELL_GROUP_YN	-- 20240311 
			  ,GP.CELL_CF
			  ,GP.CELL_CF_TYPE
			  ,GP.REP_CELL_ITEM_ID
			  ,GP.MODULE_ID
			  ,GP.YYYYPW
			  ,GP.ITEM_ID
			  ,GP.FROM_SITE
			  ,GP.TO_SITE
			  ,GP.INCOTERMS
			  ,GP.VARIOUS_KEY
			  ,GP.OPERATION_GROUP
			  ,GP.TO_SITE_TYPE
			  ,GP.FROM_BOH_QTY
			  ,GP.TO_BOH_QTY


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### AS GAP(AS RTF - AS MKT_FCST) measure' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #GAP_RTF_MKT_FCST
		SELECT GP.CELL_GROUP
			  ,GP.CELL_GROUP_YN	-- 20240311 
			  ,GP.CELL_CF
			  ,GP.CELL_CF_TYPE
			  ,GP.REP_CELL_ITEM_ID
			  ,GP.MODULE_ID
			  ,GP.YYYYPW
			  ,GP.ITEM_ID
			  ,'AS_GAP'	AS MEASURE
			  ,GP.FROM_SITE
			  ,GP.TO_SITE
			  ,GP.INCOTERMS
			  ,GP.VARIOUS_KEY
			  ,GP.OPERATION_GROUP
			  ,GP.TO_SITE_TYPE
			  ,GP.FROM_BOH_QTY
			  ,GP.TO_BOH_QTY
			  ,SUM(CASE WHEN GP.MEASURE = 'AS_MKT_FCST' THEN GP.QTY * (-1) ELSE GP.QTY END)	AS QTY
		 FROM #SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK)
		WHERE 1=1
		  AND GP.MEASURE IN ('AS_MKT_FCST', 'AS_RTF') 
		  AND GP.YYYYPW >= @V_PLAN_START_YYYYPW
		GROUP BY 
			   GP.CELL_GROUP
			  ,GP.CELL_GROUP_YN	-- 20240311 
			  ,GP.CELL_CF
			  ,GP.CELL_CF_TYPE
			  ,GP.REP_CELL_ITEM_ID
			  ,GP.MODULE_ID
			  ,GP.YYYYPW
			  ,GP.ITEM_ID
			  ,GP.FROM_SITE
			  ,GP.TO_SITE
			  ,GP.INCOTERMS
			  ,GP.VARIOUS_KEY
			  ,GP.OPERATION_GROUP
			  ,GP.TO_SITE_TYPE
			  ,GP.FROM_BOH_QTY
			  ,GP.TO_BOH_QTY


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### (AS포함) GAP(AS RTF - AS MKT_FCST) measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #SCP_RPT_GLOBAL_PSI_MD_WW 
		SELECT *
		 FROM #GAP_RTF_MKT_FCST

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### ACC GAP(RTF - MKT_FCST) measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH GAP_MEASURE AS ( 
			SELECT GP.CELL_GROUP
				  ,GP.CELL_GROUP_YN	-- 20240311 
				  ,GP.CELL_CF
				  ,GP.REP_CELL_ITEM_ID
				  ,WL.YYYYPW
				  ,GP.ITEM_ID
				  ,GP.MEASURE
				  ,GP.TO_SITE
				  ,GP.INCOTERMS
				  ,GP.VARIOUS_KEY
				  ,GP.OPERATION_GROUP
				  ,SUM(CASE WHEN WL.YYYYPW = GP.YYYYPW THEN GP.QTY ELSE 0.0 END) AS QTY 
			 FROM #GAP_RTF_MKT_FCST GP WITH(NOLOCK)
				  INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						  ON 1=1 
						 AND WL.YYYYPW >= @V_PLAN_START_YYYYPW  -- 미래 계획 구간만 
			WHERE 1=1
			GROUP BY 
				   GP.CELL_GROUP
				  ,GP.CELL_GROUP_YN	-- 20240311 
				  ,GP.CELL_CF
				  ,GP.REP_CELL_ITEM_ID
				  ,WL.YYYYPW
				  ,GP.ITEM_ID
				  ,GP.MEASURE
				  ,GP.TO_SITE
				  ,GP.INCOTERMS
				  ,GP.VARIOUS_KEY
				  ,GP.OPERATION_GROUP
		)
		INSERT INTO #SCP_RPT_GLOBAL_PSI_MD_WW
		SELECT GP.CELL_GROUP
			  ,GP.CELL_GROUP_YN	-- 20240311 
			  ,GP.CELL_CF
			  ,'-'		AS CELL_CF_TYPE 
			  ,GP.REP_CELL_ITEM_ID
			  ,'-'		AS MODULE_ID
			  ,GP.YYYYPW
			  ,GP.ITEM_ID
			  ,CASE WHEN MEASURE = 'GAP' THEN 'GAP_ACC'	ELSE 'AS_GAP_ACC' END AS MEASURE
			  ,'-'		AS FROM_SITE
			  ,GP.TO_SITE
			  ,GP.INCOTERMS
			  ,GP.VARIOUS_KEY
			  ,GP.OPERATION_GROUP
			  ,'-'		AS TO_SITE_TYPE
			  ,0.0		AS FROM_BOH_QTY
			  ,0.0		AS TO_BOH_QTY
			  ,SUM(GP.QTY) OVER (PARTITION BY GP.ITEM_ID
											, GP.TO_SITE
											, GP.INCOTERMS
											, GP.VARIOUS_KEY
											, CASE WHEN MEASURE = 'GAP' THEN 'GAP_ACC'	ELSE 'AS_GAP_ACC' END
									 ORDER BY GP.YYYYPW)	AS ACC_QTY 
		 FROM GAP_MEASURE GP WITH(NOLOCK)
		WHERE 1=1


	------- Begin DIO 계산 ===============================================================================================================================
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 주별 일수 정보 (partial week)' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#TMP_WW_DAYS_INFO') IS NOT NULL
			DROP TABLE #TMP_WW_DAYS_INFO;

		;WITH NEXT_PW_SEQ_INFO AS (
			SELECT BC.YYYYPW
				  ,COUNT(BC.YYYYMMDD)										AS PW_DAYS
				  ,DENSE_RANK() OVER (PARTITION BY 'A' ORDER BY BC.YYYYPW)	AS YYYYPW_SEQ 
			 FROM SCM_MST_BUCKET BC WITH(NOLOCK)
			WHERE 1=1
			  AND BC.YYYYMM BETWEEN CONVERT(NVARCHAR(6), @V_RESULT_FROM_YYYYMMDD)
								AND CONVERT(NVARCHAR(6), DATEADD(WEEK, 63, CONVERT(DATE, @V_HORIZON_END_YYYYMMDD, 112)), 112)   -- 계획 참조 종료일 + 12month 
			GROUP BY BC.YYYYPW
		)
		SELECT PL.YYYYPW
			  ,PL.PW_FROM_YMD
			  ,PL.PW_TO_YMD
			  ,PL.PW_DAYS
			  ,PL.YYYYPW_SEQ
			  -----------------------------------------
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 1	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_1	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 2	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_2	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 3	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_3	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 4	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_4	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 5	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_5	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 6	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_6	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 7	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_7	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 8	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_8	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 9	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_9	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 10 THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_10 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 11	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_11	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 12	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_12	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 13	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_13	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 14	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_14	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 15	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_15	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 16	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_16	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 17	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_17	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 18	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_18	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 19	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_19	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 20 THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_20 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 21	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_21	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 22	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_22	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 23	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_23	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 24	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_24	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 25	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_25	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 26	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_26	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 27	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_27	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 28	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_28	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 29	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_29	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 30 THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_30 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 31	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_31	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 32	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_32	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 33	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_33	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 34	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_34	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 35	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_35	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 36	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_36	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 37	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_37	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 38	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_38	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 39	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_39	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 40 THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_40 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 41	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_41	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 42	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_42	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 43	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_43	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 44	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_44	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 45	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_45	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 46	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_46	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 47	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_47	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 48	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_48	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 49	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_49	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 50 THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_50 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 51	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_51	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 52	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_52	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 53	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_53	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 54	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_54	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 55	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_55	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 56	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_56	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 57	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_57	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 58	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_58	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 59	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_59	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 60 THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_60 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 61	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_61	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 62	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_62	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 63	THEN NW.YYYYPW ELSE NULL END)	AS NEXT_PW_63	
			  -----------------------------------------
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 1	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_1	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 2	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_2	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 3	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_3	
			 ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 4	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_4	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 5	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_5	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 6	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_6	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 7	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_7	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 8	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_8	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 9	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_9	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 10 THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_10 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 11	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_11	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 12	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_12	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 13	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_13	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 14	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_14	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 15	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_15	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 16	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_16	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 17	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_17	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 18	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_18	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 19	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_19	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 20 THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_20 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 21	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_21	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 22	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_22	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 23	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_23	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 24	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_24	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 25	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_25	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 26	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_26	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 27	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_27	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 28	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_28	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 29	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_29	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 30 THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_30 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 31	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_31	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 32	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_32	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 33	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_33	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 34	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_34	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 35	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_35	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 36	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_36	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 37	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_37	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 38	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_38	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 39	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_39	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 40 THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_40 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 41	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_41	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 42	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_42	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 43	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_43	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 44	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_44	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 45	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_45	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 46	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_46	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 47	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_47	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 48	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_48	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 49	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_49	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 50 THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_50 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 51	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_51	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 52	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_52	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 53	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_53	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 54	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_54	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 55	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_55	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 56	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_56	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 57	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_57	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 58	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_58	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 59	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_59	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 60 THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_60 
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 61	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_61	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 62	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_62	
			  ,MAX(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ = 63	THEN NW.PW_DAYS ELSE 0 END)	AS DAYS_NEXT_63	
			  -----------------------------------------
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  1		THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_1	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  2		THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_2	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  3		THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_3	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  4		THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_4	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  5		THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_5	
			 ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  6		THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_6	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  7		THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_7	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  8		THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_8	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  9		THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_9	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  10	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_10 
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  11	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_11	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  12	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_12	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND 13	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_13	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  14	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_14	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  15	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_15	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  16	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_16	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  17	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_17	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  18	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_18	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  19	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_19	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  20	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_20 
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  21	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_21	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  22	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_22	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  23	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_23	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  24	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_24	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  25	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_25	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  26	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_26	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  27	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_27	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  28	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_28	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  29	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_29	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  30	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_30 
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  31	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_31	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  32	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_32	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  33	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_33	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  34	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_34	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  35	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_35	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  36	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_36	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  37	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_37	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  38	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_38	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  39	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_39	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  40	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_40 
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  41	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_41	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  42	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_42	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  43	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_43	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  44	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_44	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  45	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_45	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  46	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_46	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  47	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_47	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  48	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_48	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  49	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_49	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  50	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_50 
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  51	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_51	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  52	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_52	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  53	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_53	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  54	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_54	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  55	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_55	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  56	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_56	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  57	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_57	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  58	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_58	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  59	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_59	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  60	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_60 
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  61	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_61	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  62	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_62	
			  ,SUM(CASE WHEN NW.YYYYPW_SEQ - PL.YYYYPW_SEQ BETWEEN 1 AND  63	THEN NW.PW_DAYS ELSE 0 END)	AS ACC_DAYS_63	
			  -----------------------------------------
		 INTO #TMP_WW_DAYS_INFO
		 FROM #TMP_PW_LIST PL WITH(NOLOCK)
			  LEFT JOIN NEXT_PW_SEQ_INFO NW WITH(NOLOCK)
					 ON NW.YYYYPW_SEQ BETWEEN PL.YYYYPW_SEQ + 1
									      AND PL.YYYYPW_SEQ + 64
		WHERE 1=1
		GROUP BY PL.YYYYPW
				,PL.PW_FROM_YMD
				,PL.PW_TO_YMD
				,PL.PW_DAYS
				,PL.YYYYPW_SEQ


		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 셀그룹별 재고 및 RTF 정보 ' 
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#BASE_DATA_FOR_DIO') IS NOT NULL
			DROP TABLE #BASE_DATA_FOR_DIO;

		;WITH RTF_N_INV AS (
			SELECT GP.CELL_GROUP
				  ,GP.CELL_GROUP_YN	-- 20240311 
				  ,GP.YYYYPW
				  ,'C'		AS OPERATION_GROUP
				  ,CASE WHEN GP.MEASURE IN ('RTF', 'AS_RTF') 
						THEN 'RTF'
						ELSE 'INV' 
					END						AS MEASURE 
				  ,SUM(GP.CELL_CF * GP.QTY)	AS QTY
			 FROM #SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK)
			WHERE 1=1
			  AND GP.MEASURE IN ( 
							-- 재고 Measure 
							 'TO_SITE_EOH'
							,'AS_INV'
							,'INTRANSIT'
							,'PACK_EOH'
							,'PACK_CELL_EOH'
							,'SEMI_INTRANSIT'
							,'CELL_EOH'
							,'CELL_CHAR_AVAILABLE'
							,'CELL_FORM_PROGRESS'
							-- RTF
							,'RTF'
							,'AS_RTF'
							)
			GROUP BY GP.CELL_GROUP
				    ,GP.CELL_GROUP_YN	-- 20240311 
					,GP.YYYYPW
				    ,CASE WHEN GP.MEASURE IN ('RTF', 'AS_RTF')
						  THEN 'RTF'
						  ELSE 'INV' 
					 END
		)
		SELECT RI.CELL_GROUP
			  ,RI.CELL_GROUP_YN	-- 20240311 
			  ,RI.OPERATION_GROUP
			  ,RI.MEASURE
			  ,ML.YYYYPW
			  ,ML.YYYYPW_SEQ
			  ,ML.PW_DAYS
			  ,SUM(CASE WHEN ML.YYYYPW = RI.YYYYPW
						THEN RI.QTY
						ELSE CONVERT(NUMERIC(20,10), '0') 
				   END) AS QTY 
		 INTO #BASE_DATA_FOR_DIO
		 FROM RTF_N_INV RI WITH(NOLOCK)
			  INNER JOIN #TMP_WW_DAYS_INFO ML WITH(NOLOCK)  -- 데이터가 없는 월 0으로 생성을 위해.
					  ON 1=1
	    WHERE 1=1
		GROUP BY RI.CELL_GROUP
			    ,RI.CELL_GROUP_YN	-- 20240311 
			   ,RI.OPERATION_GROUP
				,RI.MEASURE
				,ML.YYYYPW
			    ,ML.YYYYPW_SEQ
				,ML.PW_DAYS

		
		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 셀그룹별 재고 및 RTF 정보(표준레포트) '	--@@@ 
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#BASE_DATA_FOR_DIO_CELLGROUP') IS NOT NULL
			DROP TABLE #BASE_DATA_FOR_DIO_CELLGROUP;

		;WITH RTF_N_INV AS (
			SELECT GP.CELL_GROUP
				  ,GP.CELL_GROUP_YN		-- 20240311 
					  ,'C'		AS  OPERATION_GROUP
				  --,GP.OPERATION_GROUP		AS  OPERATION_GROUP
				  ,GP.YYYYPW
				  ,SUM(GP.RTF_SALES) AS RTF_SALES
				  ,SUM(GP.RTF_PACK) AS RTF_PACK
				  ,SUM(GP.RTF_CELL) AS RTF_CELL
				  ,SUM(GP.INV_SALES) AS INV_SALES
				  ,SUM(GP.INV_PACK) AS INV_PACK
				  ,SUM(GP.INV_CELL) AS INV_CELL 
			FROM (
						SELECT GP.CELL_GROUP
								  ,GP.CELL_GROUP_YN		-- 20240311 
								  ,GP.OPERATION_GROUP
								  ,GP.YYYYPW
								, CASE WHEN GP.MEASURE IN ('RTF') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_SALES
								, CASE WHEN GP.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_PACK
								, CASE WHEN GP.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_CELL
								, CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_SALES
								, CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_PACK
								, CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH','PACK_CELL_EOH','SEMI_INTRANSIT','CELL_EOH','CELL_CHAR_AVAILABLE','CELL_FORM_PROGRESS') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_CELL
						FROM #SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK)
						WHERE 1=1
							AND GP.MEASURE IN ( 
										-- 재고 MEASURE 
											'TO_SITE_EOH'
											,'AS_INV'
											,'AS_IN_PLAN'
											,'INTRANSIT'
											,'PACK_EOH'
											,'PACK_CELL_EOH'
											,'SEMI_INTRANSIT'
											,'CELL_EOH'
											,'CELL_CHAR_AVAILABLE'
											,'CELL_FORM_PROGRESS'
											-- RTF
											,'RTF'
											,'AS_RTF'
										)
					) GP
			GROUP BY GP.CELL_GROUP
					,GP.CELL_GROUP_YN		-- 20240311 
					--,GP.OPERATION_GROUP
				    ,GP.YYYYPW
		)
		SELECT RI.CELL_GROUP
			  ,RI.CELL_GROUP_YN	-- 20240311 
			  ,RI.OPERATION_GROUP
			  ,CL.MEASURE
			  ,ML.YYYYPW
			  ,ML.YYYYPW_SEQ
			  ,ML.PW_DAYS
			  ,SUM(CASE WHEN ML.YYYYPW = RI.YYYYPW
						THEN (
								CASE WHEN CL.MEASURE = 'RTF_SALES' THEN RI.RTF_SALES
									 WHEN CL.MEASURE = 'RTF_PACK' THEN RI.RTF_PACK
									 WHEN CL.MEASURE = 'RTF_CELL' THEN RI.RTF_CELL
									 WHEN CL.MEASURE = 'INV_SALES' THEN RI.INV_SALES
									 WHEN CL.MEASURE = 'INV_PACK' THEN RI.INV_PACK
									 WHEN CL.MEASURE = 'INV_CELL' THEN RI.INV_CELL
								END
							)
						ELSE CONVERT(NUMERIC(20,10), '0') 
				   END) AS QTY 
		 INTO #BASE_DATA_FOR_DIO_CELLGROUP
		 FROM RTF_N_INV RI WITH(NOLOCK)
		 	  INNER JOIN (
					SELECT 'RTF_SALES' AS MEASURE UNION
					SELECT 'RTF_PACK' AS MEASURE UNION
					SELECT 'RTF_CELL' AS MEASURE UNION
					SELECT 'INV_SALES' AS MEASURE UNION
					SELECT 'INV_PACK' AS MEASURE UNION
					SELECT 'INV_CELL' AS MEASURE 
				) CL
			  ON 1=1
			  INNER JOIN #TMP_WW_DAYS_INFO ML WITH(NOLOCK)  -- 데이터가 없는 월 0으로 생성을 위해.
					  ON 1=1
	    WHERE 1=1
		GROUP BY RI.CELL_GROUP
			    ,RI.CELL_GROUP_YN	-- 20240311 
			    ,RI.OPERATION_GROUP
				,CL.MEASURE
				,ML.YYYYPW
			    ,ML.YYYYPW_SEQ
				,ML.PW_DAYS
		
		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 셀그룹별 재고 및 RTF 정보(Detail 표준레포트)'  -- 고도화 
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#BASE_DATA_FOR_DIO_DETAILREPORT') IS NOT NULL
			DROP TABLE #BASE_DATA_FOR_DIO_DETAILREPORT;

		;WITH RTF_N_INV AS (
			SELECT GP.CELL_GROUP
				  ,GP.CELL_GROUP_YN		-- 20240311 
					  ,'C'		AS  OPERATION_GROUP
				  --,GP.OPERATION_GROUP		AS  OPERATION_GROUP
				  ,GP.PRODUCT_LEVEL1
				  ,GP.PRODUCT_LEVEL2
				  ,GP.YYYYPW
				  ,SUM(GP.RTF_SALES) AS RTF_SALES
				  ,SUM(GP.RTF_PACK) AS RTF_PACK
				  ,SUM(GP.RTF_CELL) AS RTF_CELL
				  ,SUM(GP.INV_SALES) AS INV_SALES
				  ,SUM(GP.INV_PACK) AS INV_PACK
				  ,SUM(GP.INV_CELL) AS INV_CELL 
			FROM (
						SELECT GP.CELL_GROUP
								  ,GP.CELL_GROUP_YN		-- 20240311 
								  ,GP.OPERATION_GROUP
								  , FI.GROUP_CODE6 AS PRODUCT_LEVEL1
								  , FI.GROUP_CODE7 AS PRODUCT_LEVEL2
								  ,GP.YYYYPW
								, CASE WHEN GP.MEASURE IN ('RTF') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_SALES
								, CASE WHEN GP.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_PACK
								, CASE WHEN GP.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_CELL
								, CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_SALES
								, CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_PACK
								, CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH','PACK_CELL_EOH','SEMI_INTRANSIT','CELL_EOH','CELL_CHAR_AVAILABLE','CELL_FORM_PROGRESS') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_CELL
						FROM #SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK)
							 LEFT OUTER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
							 ON 1=1
							 AND GP.ITEM_ID = FI.ITEM_ID
							 AND GP.OPERATION_GROUP = FI.OPERATION_GROUP
						WHERE 1=1
							AND GP.MEASURE IN ( 
										-- 재고 MEASURE 
											'TO_SITE_EOH'
											,'AS_INV'
											,'AS_IN_PLAN'
											,'INTRANSIT'
											,'PACK_EOH'
											,'PACK_CELL_EOH'
											,'SEMI_INTRANSIT'
											,'CELL_EOH'
											,'CELL_CHAR_AVAILABLE'
											,'CELL_FORM_PROGRESS'
											-- RTF
											,'RTF'
											,'AS_RTF'
										)
					) GP
			GROUP BY GP.CELL_GROUP
					,GP.CELL_GROUP_YN		-- 20240311 
					--,GP.OPERATION_GROUP
					,GP.PRODUCT_LEVEL1
					,GP.PRODUCT_LEVEL2
				    ,GP.YYYYPW
		)
		SELECT RI.CELL_GROUP
			  ,RI.CELL_GROUP_YN	-- 20240311 
			  ,RI.OPERATION_GROUP
			  ,ISNULL(RI.PRODUCT_LEVEL1,'-') AS PRODUCT_LEVEL1
			  ,ISNULL(RI.PRODUCT_LEVEL2,'-') AS PRODUCT_LEVEL2
			  ,CL.MEASURE
			  ,ML.YYYYPW
			  ,ML.YYYYPW_SEQ
			  ,ML.PW_DAYS
			  ,SUM(CASE WHEN ML.YYYYPW = RI.YYYYPW
						THEN (
								CASE WHEN CL.MEASURE = 'RTF_SALES' THEN RI.RTF_SALES
									 WHEN CL.MEASURE = 'RTF_PACK' THEN RI.RTF_PACK
									 WHEN CL.MEASURE = 'RTF_CELL' THEN RI.RTF_CELL
									 WHEN CL.MEASURE = 'INV_SALES' THEN RI.INV_SALES
									 WHEN CL.MEASURE = 'INV_PACK' THEN RI.INV_PACK
									 WHEN CL.MEASURE = 'INV_CELL' THEN RI.INV_CELL
								END
							)
						ELSE CONVERT(NUMERIC(20,10), '0') 
				   END) AS QTY 
		 INTO #BASE_DATA_FOR_DIO_DETAILREPORT
		 FROM RTF_N_INV RI WITH(NOLOCK)
		 	  INNER JOIN (
					SELECT 'RTF_SALES' AS MEASURE UNION
					SELECT 'RTF_PACK' AS MEASURE UNION
					SELECT 'RTF_CELL' AS MEASURE UNION
					SELECT 'INV_SALES' AS MEASURE UNION
					SELECT 'INV_PACK' AS MEASURE UNION
					SELECT 'INV_CELL' AS MEASURE 
				) CL
			  ON 1=1
			  INNER JOIN #TMP_WW_DAYS_INFO ML WITH(NOLOCK)  -- 데이터가 없는 월 0으로 생성을 위해.
					  ON 1=1
	    WHERE 1=1
		GROUP BY RI.CELL_GROUP
			    ,RI.CELL_GROUP_YN	-- 20240311 
			    ,RI.OPERATION_GROUP
			    ,ISNULL(RI.PRODUCT_LEVEL1,'-')
			    ,ISNULL(RI.PRODUCT_LEVEL2,'-')
				,CL.MEASURE
				,ML.YYYYPW
			    ,ML.YYYYPW_SEQ
				,ML.PW_DAYS
				
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 주별 RTF 누적 정보' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_RTF_FOR_DIO') IS NOT NULL	
			DROP TABLE #TMP_RTF_FOR_DIO;

		SELECT RI.YYYYPW
			  ,RI.YYYYPW_SEQ
			  ,RI.PW_DAYS
			  ,RI.CELL_GROUP
			  ,RI.CELL_GROUP_YN		-- 20240311 
			  ,RI.OPERATION_GROUP
			  ,RI.QTY																			AS RTF_QTY
			  ---- RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함. 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 1	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_1 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 2	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_2 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 3	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_3 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 4	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_4 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 5	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_5 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 6	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_6 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 7	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_7 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 8	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_8 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 9	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_9 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 10  THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_10 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 11	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_11
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 12	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_12
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 13	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_13
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 14	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_14
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 15	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_15
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 16	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_16
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 17	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_17
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 18	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_18
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 19	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_19
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 20 THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_20 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 21	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_21
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 22	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_22
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 23	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_23
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 24	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_24
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 25	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_25
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 26	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_26
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 27	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_27
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 28	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_28
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 29	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_29
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 30	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_30
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 31	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_31
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 32	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_32
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 33	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_33
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 34	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_34
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 35	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_35
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 36	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_36
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 37	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_37
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 38	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_38
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 39	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_39
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 40	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_40
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 41	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_41
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 42	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_42
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 43	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_43
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 44	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_44
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 45	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_45
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 46	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_46
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 47	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_47
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 48	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_48
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 49	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_49
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 50	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_50
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 51	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_51
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 52	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_52
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 53	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_53
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 54	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_54
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 55	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_55
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 56	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_56
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 57	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_57
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 58	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_58
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 59	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_59
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 60	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_60
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 61	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_61
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 62	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_62
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 63	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_63
			  -----------------------------------------------------------------------------------------------------------
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 1	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_1	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 2	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_2	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 3	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_3	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 4	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_4	
			 ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 5	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_5	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 6	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_6	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 7	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_7	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 8	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_8	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 9	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_9	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 10	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_10	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 11	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_11	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 12	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_12	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 13	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_13	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 14	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_14	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 15	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_15	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 16	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_16	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 17	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_17	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 18	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_18	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 19	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_19	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 20	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_20	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 21	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_21	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 22	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_22	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 23	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_23	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 24	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_24	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 25	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_25	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 26	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_26	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 27	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_27	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 28	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_28	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 29	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_29
			  
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 30	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_30	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 31	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_31	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 32	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_32	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 33	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_33	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 34	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_34	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 35	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_35	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 36	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_36	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 37	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_37	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 38	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_38	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 39	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_39
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 40	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_40	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 41	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_41	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 42	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_42	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 43	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_43	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 44	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_44	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 45	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_45	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 46	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_46	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 47	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_47	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 48	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_48	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 49	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_49
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 50	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_50	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 51	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_51	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 52	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_52	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 53	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_53	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 54	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_54	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 55	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_55	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 56	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_56	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 57	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_57	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 58	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_58	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 59	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_59
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 60	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_60	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 61	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_61	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 62	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_62	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 63	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_63	
		 INTO #TMP_RTF_FOR_DIO
		 FROM #BASE_DATA_FOR_DIO RI
			  LEFT JOIN #BASE_DATA_FOR_DIO AR
					 ON AR.MEASURE			= 'RTF'
					AND AR.CELL_GROUP		= RI.CELL_GROUP
					AND AR.OPERATION_GROUP	= RI.OPERATION_GROUP
					AND AR.YYYYPW_SEQ BETWEEN RI.YYYYPW_SEQ + 1
									      AND RI.YYYYPW_SEQ + 64
		WHERE 1=1
		  AND RI.MEASURE = 'RTF'
		GROUP BY RI.YYYYPW
			    ,RI.YYYYPW_SEQ
				,RI.PW_DAYS
			    ,RI.CELL_GROUP
			    ,RI.CELL_GROUP_YN		-- 20240311 
				,RI.OPERATION_GROUP
			    ,RI.QTY

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 주별 RTF 누적 정보(표준레포트)' --@@@
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_RTF_FOR_DIO_CELLGROUP') IS NOT NULL	
			DROP TABLE #TMP_RTF_FOR_DIO_CELLGROUP;

		SELECT RI.YYYYPW
			  ,RI.YYYYPW_SEQ
			  ,RI.PW_DAYS
			  ,RI.CELL_GROUP
			  ,RI.CELL_GROUP_YN		-- 20240311 
			  ,RI.OPERATION_GROUP
			  ,RI.MEASURE
			  ,RI.QTY																			AS RTF_QTY
			  ---- RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함. 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 1	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_1 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 2	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_2 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 3	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_3 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 4	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_4 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 5	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_5 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 6	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_6 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 7	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_7 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 8	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_8 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 9	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_9 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 10  THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_10 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 11	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_11
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 12	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_12
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 13	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_13
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 14	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_14
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 15	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_15
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 16	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_16
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 17	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_17
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 18	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_18
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 19	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_19
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 20  THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_20 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 21	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_21
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 22	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_22
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 23	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_23
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 24	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_24
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 25	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_25
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 26	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_26
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 27	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_27
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 28	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_28
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 29	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_29
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 30	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_30
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 31	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_31
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 32	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_32
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 33	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_33
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 34	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_34
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 35	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_35
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 36	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_36
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 37	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_37
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 38	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_38
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 39	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_39
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 40	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_40
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 41	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_41
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 42	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_42
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 43	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_43
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 44	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_44
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 45	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_45
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 46	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_46
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 47	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_47
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 48	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_48
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 49	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_49
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 50	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_50
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 51	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_51
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 52	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_52
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 53	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_53
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 54	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_54
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 55	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_55
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 56	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_56
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 57	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_57
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 58	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_58
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 59	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_59
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 60	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_60
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 61	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_61
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 62	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_62
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 63	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_63
			  -----------------------------------------------------------------------------------------------------------
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 1	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_1	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 2	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_2	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 3	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_3	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 4	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_4	
			 ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 5	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_5	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 6	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_6	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 7	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_7	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 8	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_8	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 9	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_9	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 10	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_10	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 11	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_11	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 12	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_12	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 13	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_13	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 14	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_14	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 15	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_15	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 16	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_16	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 17	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_17	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 18	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_18	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 19	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_19	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 20	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_20	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 21	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_21	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 22	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_22	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 23	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_23	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 24	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_24	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 25	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_25	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 26	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_26	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 27	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_27	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 28	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_28	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 29	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_29
			  
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 30	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_30	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 31	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_31	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 32	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_32	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 33	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_33	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 34	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_34	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 35	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_35	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 36	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_36	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 37	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_37	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 38	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_38	
			 ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 39	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_39
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 40	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_40	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 41	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_41	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 42	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_42	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 43	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_43	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 44	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_44	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 45	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_45	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 46	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_46	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 47	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_47	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 48	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_48	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 49	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_49
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 50	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_50	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 51	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_51	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 52	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_52	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 53	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_53	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 54	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_54	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 55	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_55	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 56	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_56	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 57	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_57	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 58	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_58	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 59	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_59
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 60	THEN AR.QTY ELSE 0 END)	AS ACC_RTF_60	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 61	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_61	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 62	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_62	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 63	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_63	
		 INTO #TMP_RTF_FOR_DIO_CELLGROUP
		 FROM #BASE_DATA_FOR_DIO_CELLGROUP RI
			  LEFT JOIN #BASE_DATA_FOR_DIO_CELLGROUP AR
					 ON AR.MEASURE			LIKE 'RTF%'
					AND AR.CELL_GROUP		= RI.CELL_GROUP
					AND AR.OPERATION_GROUP	= RI.OPERATION_GROUP
					AND AR.MEASURE			= RI.MEASURE
					AND AR.YYYYPW_SEQ BETWEEN RI.YYYYPW_SEQ + 1
									      AND RI.YYYYPW_SEQ + 64
		WHERE 1=1
		  AND RI.MEASURE LIKE 'RTF%'
		GROUP BY RI.YYYYPW
			    ,RI.YYYYPW_SEQ
				,RI.PW_DAYS
			    ,RI.CELL_GROUP
			    ,RI.CELL_GROUP_YN		-- 20240311 
				,RI.OPERATION_GROUP
				,RI.MEASURE
			    ,RI.QTY
			    
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 주별 RTF 누적 정보(Detail 표준레포트)' --@@@
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_RTF_FOR_DIO_DETAILREPORT') IS NOT NULL	
			DROP TABLE #TMP_RTF_FOR_DIO_DETAILREPORT;

		SELECT RI.YYYYPW
			  ,RI.YYYYPW_SEQ
			  ,RI.PW_DAYS
			  ,RI.CELL_GROUP
			  ,RI.CELL_GROUP_YN		-- 20240311 
			  ,RI.OPERATION_GROUP
			  ,ISNULL(RI.PRODUCT_LEVEL1,'-') AS PRODUCT_LEVEL1
			  ,ISNULL(RI.PRODUCT_LEVEL2,'-') AS PRODUCT_LEVEL2
			  ,RI.MEASURE
			  ,RI.QTY																			AS RTF_QTY
			 ---- RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함. 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 1	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_1 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 2	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_2 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 3	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_3 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 4	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_4 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 5	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_5 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 6	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_6 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 7	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_7 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 8	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_8 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 9	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_9 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 10  THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_10 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 11	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_11
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 12	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_12
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 13	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_13
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 14	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_14
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 15	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_15
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 16	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_16
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 17	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_17
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 18	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_18
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 19	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_19
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 20  THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_20 
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 21	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_21
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 22	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_22
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 23	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_23
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 24	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_24
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 25	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_25
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 26	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_26
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 27	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_27
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 28	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_28
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 29	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_29
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 30	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_30
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 31	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_31
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 32	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_32
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 33	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_33
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 34	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_34
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 35	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_35
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 36	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_36
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 37	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_37
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 38	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_38
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 39	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_39
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 40	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_40
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 41	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_41
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 42	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_42
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 43	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_43
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 44	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_44
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 45	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_45
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 46	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_46
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 47	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_47
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 48	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_48
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 49	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_49
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 50	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_50
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 51	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_51
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 52	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_52
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 53	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_53
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 54	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_54
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 55	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_55
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 56	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_56
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 57	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_57
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 58	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_58
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 59	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_59
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 60	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_60
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 61	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_61
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 62	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_62
			  ,ISNULL(MAX(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ = 63	THEN AR.QTY ELSE NULL END), 0.0) AS RTF_NEXT_63
			  -----------------------------------------------------------------------------------------------------------
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 1	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_1	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 2	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_2	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 3	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_3	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 4	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_4	
			 ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 5	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_5	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 6	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_6	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 7	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_7	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 8	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_8	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 9	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_9	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 10	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_10	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 11	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_11	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 12	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_12	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 13	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_13	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 14	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_14	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 15	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_15	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 16	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_16	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 17	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_17	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 18	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_18	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 19	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_19	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 20	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_20	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 21	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_21	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 22	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_22	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 23	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_23	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 24	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_24	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 25	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_25	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 26	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_26	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 27	THEN AR.QTY ELSE 0 END)	AS ACC_RTF_27	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 28	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_28	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 29	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_29
			  
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 30	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_30	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 31	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_31	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 32	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_32	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 33	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_33	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 34	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_34	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 35	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_35	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 36	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_36	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 37	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_37	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 38	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_38	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 39	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_39
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 40	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_40	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 41	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_41	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 42	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_42	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 43	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_43	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 44	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_44	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 45	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_45	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 46	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_46	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 47	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_47	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 48	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_48	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 49	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_49
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 50	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_50	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 51	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_51	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 52	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_52	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 53	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_53	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 54	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_54	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 55	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_55	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 56	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_56	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 57	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_57	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 58	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_58	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 59	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_59
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 60	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_60	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 61	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_61	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 62	THEN  AR.QTY ELSE 0 END)	AS ACC_RTF_62	
			  ,SUM(CASE WHEN AR.YYYYPW_SEQ - RI.YYYYPW_SEQ BETWEEN 1 AND 63	THEN AR.QTY ELSE 0 END)	AS ACC_RTF_63	
		 INTO #TMP_RTF_FOR_DIO_DETAILREPORT
		 FROM #BASE_DATA_FOR_DIO_DETAILREPORT RI
			  LEFT JOIN #BASE_DATA_FOR_DIO_DETAILREPORT AR
					 ON AR.MEASURE			LIKE 'RTF%'
					AND AR.CELL_GROUP		= RI.CELL_GROUP
					AND AR.OPERATION_GROUP	= RI.OPERATION_GROUP
					AND AR.PRODUCT_LEVEL1	 = RI.PRODUCT_LEVEL1
					AND AR.PRODUCT_LEVEL2	 = RI.PRODUCT_LEVEL2
					AND AR.MEASURE			= RI.MEASURE
					AND AR.YYYYPW_SEQ BETWEEN RI.YYYYPW_SEQ + 1
									      AND RI.YYYYPW_SEQ + 64
		WHERE 1=1
		  AND RI.MEASURE LIKE 'RTF%'
		GROUP BY RI.YYYYPW
			    ,RI.YYYYPW_SEQ
				,RI.PW_DAYS
			    ,RI.CELL_GROUP
			    ,RI.CELL_GROUP_YN		-- 20240311 
				,RI.OPERATION_GROUP
				,ISNULL(RI.PRODUCT_LEVEL1,'-')
			    ,ISNULL(RI.PRODUCT_LEVEL2,'-')
				,RI.MEASURE
			    ,RI.QTY
			    
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 셀그룹별 DIO 산출' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_INVENTORY_DIO') IS NOT NULL	
			DROP TABLE #TMP_INVENTORY_DIO;

		SELECT I.YYYYPW
			  ,I.YYYYPW_SEQ
			  ,I.PW_DAYS
			  ,I.CELL_GROUP
			  ,I.CELL_GROUP_YN		-- 20240311 
			  ,I.OPERATION_GROUP
			  ,I.QTY		AS INV_QTY
			  ,R.RTF_QTY	AS RTF_QTY
			  ,CASE WHEN I.QTY <= 0 THEN 
						 0
					WHEN R.CELL_GROUP IS NULL THEN 
						 365 
				    WHEN I.QTY - R.RTF_NEXT_1 < 0 THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), I.QTY)				    / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0)   * D.DAYS_NEXT_1  
					WHEN I.QTY - R.RTF_NEXT_1 = 0 THEN 
						 D.ACC_DAYS_1
					WHEN I.QTY - R.ACC_RTF_2 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_1)) / CASE WHEN R.RTF_NEXT_2 = 0  THEN NULL ELSE R.RTF_NEXT_2  END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
					WHEN I.QTY - R.ACC_RTF_2 = 0  THEN 
						 D.ACC_DAYS_2
					WHEN I.QTY - R.ACC_RTF_3 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_2)) / CASE WHEN R.RTF_NEXT_3 = 0  THEN NULL ELSE R.RTF_NEXT_3  END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
					WHEN I.QTY - R.ACC_RTF_3 = 0  THEN 
						 D.ACC_DAYS_3
					WHEN I.QTY - R.ACC_RTF_4 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_3)) / CASE WHEN R.RTF_NEXT_4 = 0  THEN NULL ELSE R.RTF_NEXT_4  END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
					WHEN I.QTY - R.ACC_RTF_4 = 0  THEN 
						 D.ACC_DAYS_4
					WHEN I.QTY - R.ACC_RTF_5 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_4)) / CASE WHEN R.RTF_NEXT_5 = 0  THEN NULL ELSE R.RTF_NEXT_5  END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
					WHEN I.QTY - R.ACC_RTF_5 = 0  THEN 
						 D.ACC_DAYS_5
					WHEN I.QTY - R.ACC_RTF_6 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_5)) / CASE WHEN R.RTF_NEXT_6 = 0  THEN NULL ELSE R.RTF_NEXT_6  END, 0) * D.DAYS_NEXT_6 + D.ACC_DAYS_5
					WHEN I.QTY - R.ACC_RTF_6 = 0  THEN 
						 D.ACC_DAYS_6
					WHEN I.QTY - R.ACC_RTF_7 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_6)) / CASE WHEN R.RTF_NEXT_7 = 0  THEN NULL ELSE R.RTF_NEXT_7  END, 0) * D.DAYS_NEXT_7 + D.ACC_DAYS_6
					WHEN I.QTY - R.ACC_RTF_7 = 0  THEN 
						 D.ACC_DAYS_7
					WHEN I.QTY - R.ACC_RTF_8 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_7)) / CASE WHEN R.RTF_NEXT_8 = 0  THEN NULL ELSE R.RTF_NEXT_8  END, 0) * D.DAYS_NEXT_8 + D.ACC_DAYS_7
					WHEN I.QTY - R.ACC_RTF_8 = 0  THEN 
						 D.ACC_DAYS_8
					WHEN I.QTY - R.ACC_RTF_9 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_8)) / CASE WHEN R.RTF_NEXT_9 = 0  THEN NULL ELSE R.RTF_NEXT_9  END, 0) * D.DAYS_NEXT_9 + D.ACC_DAYS_8
					WHEN I.QTY - R.ACC_RTF_9 = 0  THEN 
						 D.ACC_DAYS_9
					WHEN I.QTY - R.ACC_RTF_10 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_9)) / CASE WHEN R.RTF_NEXT_10 = 0  THEN NULL ELSE R.RTF_NEXT_10  END, 0) * D.DAYS_NEXT_10 + D.ACC_DAYS_9
					WHEN I.QTY - R.ACC_RTF_10 = 0  THEN 
						 D.ACC_DAYS_10
					WHEN I.QTY - R.ACC_RTF_11 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_10)) / CASE WHEN R.RTF_NEXT_11 = 0  THEN NULL ELSE R.RTF_NEXT_11  END, 0) * D.DAYS_NEXT_11 + D.ACC_DAYS_10
					WHEN I.QTY - R.ACC_RTF_11 = 0  THEN 
						 D.ACC_DAYS_11
					WHEN I.QTY - R.ACC_RTF_12 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_11)) / CASE WHEN R.RTF_NEXT_12 = 0  THEN NULL ELSE R.RTF_NEXT_12  END, 0) * D.DAYS_NEXT_12 + D.ACC_DAYS_11
					WHEN I.QTY - R.ACC_RTF_12 = 0  THEN 
						 D.ACC_DAYS_12
					WHEN I.QTY - R.ACC_RTF_13 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_12)) / CASE WHEN R.RTF_NEXT_13 = 0  THEN NULL ELSE R.RTF_NEXT_13  END, 0) * D.DAYS_NEXT_13 + D.ACC_DAYS_12
					WHEN I.QTY - R.ACC_RTF_13 = 0  THEN 
						 D.ACC_DAYS_13
					WHEN I.QTY - R.ACC_RTF_14 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_13)) / CASE WHEN R.RTF_NEXT_14 = 0  THEN NULL ELSE R.RTF_NEXT_14  END, 0) * D.DAYS_NEXT_14 + D.ACC_DAYS_13
					WHEN I.QTY - R.ACC_RTF_14 = 0  THEN 
						 D.ACC_DAYS_14
					WHEN I.QTY - R.ACC_RTF_15 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_14)) / CASE WHEN R.RTF_NEXT_15 = 0  THEN NULL ELSE R.RTF_NEXT_15  END, 0) * D.DAYS_NEXT_15 + D.ACC_DAYS_14
					WHEN I.QTY - R.ACC_RTF_15 = 0  THEN 
						 D.ACC_DAYS_15
					WHEN I.QTY - R.ACC_RTF_16 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_15)) / CASE WHEN R.RTF_NEXT_16 = 0  THEN NULL ELSE R.RTF_NEXT_16  END, 0) * D.DAYS_NEXT_16 + D.ACC_DAYS_15
					WHEN I.QTY - R.ACC_RTF_16 = 0  THEN 
						 D.ACC_DAYS_16
					WHEN I.QTY - R.ACC_RTF_17 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_16)) / CASE WHEN R.RTF_NEXT_17 = 0  THEN NULL ELSE R.RTF_NEXT_17  END, 0) * D.DAYS_NEXT_17 + D.ACC_DAYS_16
					WHEN I.QTY - R.ACC_RTF_17 = 0  THEN 
						 D.ACC_DAYS_17
					WHEN I.QTY - R.ACC_RTF_18 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_17)) / CASE WHEN R.RTF_NEXT_18 = 0  THEN NULL ELSE R.RTF_NEXT_18  END, 0) * D.DAYS_NEXT_18 + D.ACC_DAYS_17
					WHEN I.QTY - R.ACC_RTF_18 = 0  THEN 
						 D.ACC_DAYS_18
					WHEN I.QTY - R.ACC_RTF_19 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_18)) / CASE WHEN R.RTF_NEXT_19 = 0  THEN NULL ELSE R.RTF_NEXT_19  END, 0) * D.DAYS_NEXT_19 + D.ACC_DAYS_18
					WHEN I.QTY - R.ACC_RTF_19 = 0  THEN 
						 D.ACC_DAYS_19
					WHEN I.QTY - R.ACC_RTF_20 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_19)) / CASE WHEN R.RTF_NEXT_20 = 0  THEN NULL ELSE R.RTF_NEXT_20  END, 0) * D.DAYS_NEXT_20 + D.ACC_DAYS_19
					WHEN I.QTY - R.ACC_RTF_20 = 0  THEN 
						 D.ACC_DAYS_20
					WHEN I.QTY - R.ACC_RTF_21 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_20)) / CASE WHEN R.RTF_NEXT_21 = 0  THEN NULL ELSE R.RTF_NEXT_21  END, 0) * D.DAYS_NEXT_21 + D.ACC_DAYS_20
					WHEN I.QTY - R.ACC_RTF_21 = 0  THEN 
						 D.ACC_DAYS_21
					WHEN I.QTY - R.ACC_RTF_22 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_21)) / CASE WHEN R.RTF_NEXT_22 = 0  THEN NULL ELSE R.RTF_NEXT_22 END, 0) * D.DAYS_NEXT_22 + D.ACC_DAYS_21
					WHEN I.QTY - R.ACC_RTF_22 = 0  THEN 
						 D.ACC_DAYS_22
					WHEN I.QTY - R.ACC_RTF_23 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_22)) / CASE WHEN R.RTF_NEXT_23 = 0  THEN NULL ELSE R.RTF_NEXT_23  END, 0) * D.DAYS_NEXT_23 + D.ACC_DAYS_22
					WHEN I.QTY - R.ACC_RTF_23 = 0  THEN 
						 D.ACC_DAYS_23
					WHEN I.QTY - R.ACC_RTF_24 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_23)) / CASE WHEN R.RTF_NEXT_24 = 0  THEN NULL ELSE R.RTF_NEXT_24  END, 0) * D.DAYS_NEXT_24 + D.ACC_DAYS_23
					WHEN I.QTY - R.ACC_RTF_24 = 0  THEN 
						 D.ACC_DAYS_24
					WHEN I.QTY - R.ACC_RTF_25 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_24)) / CASE WHEN R.RTF_NEXT_25 = 0  THEN NULL ELSE R.RTF_NEXT_25  END, 0) * D.DAYS_NEXT_25 + D.ACC_DAYS_24
					WHEN I.QTY - R.ACC_RTF_25 = 0  THEN 
						 D.ACC_DAYS_25
					WHEN I.QTY - R.ACC_RTF_26 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_25)) / CASE WHEN R.RTF_NEXT_26 = 0  THEN NULL ELSE R.RTF_NEXT_26  END, 0) * D.DAYS_NEXT_26 + D.ACC_DAYS_25
					WHEN I.QTY - R.ACC_RTF_26 = 0  THEN 
						 D.ACC_DAYS_26
					WHEN I.QTY - R.ACC_RTF_27 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_26)) / CASE WHEN R.RTF_NEXT_27 = 0  THEN NULL ELSE R.RTF_NEXT_27  END, 0) * D.DAYS_NEXT_27 + D.ACC_DAYS_26
					WHEN I.QTY - R.ACC_RTF_27 = 0  THEN 
						 D.ACC_DAYS_27
					WHEN I.QTY - R.ACC_RTF_28 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_27)) / CASE WHEN R.RTF_NEXT_28 = 0  THEN NULL ELSE R.RTF_NEXT_28  END, 0) * D.DAYS_NEXT_28 + D.ACC_DAYS_27
					WHEN I.QTY - R.ACC_RTF_28 = 0  THEN 
						 D.ACC_DAYS_28
					WHEN I.QTY - R.ACC_RTF_29 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_28)) / CASE WHEN R.RTF_NEXT_29 = 0  THEN NULL ELSE R.RTF_NEXT_29  END, 0) * D.DAYS_NEXT_29 + D.ACC_DAYS_28
					WHEN I.QTY - R.ACC_RTF_29 = 0  THEN 
						 D.ACC_DAYS_29
					WHEN I.QTY - R.ACC_RTF_30 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_29)) / CASE WHEN R.RTF_NEXT_30 = 0  THEN NULL ELSE R.RTF_NEXT_30  END, 0) * D.DAYS_NEXT_30 + D.ACC_DAYS_29
					WHEN I.QTY - R.ACC_RTF_30 = 0  THEN 
						 D.ACC_DAYS_30
					WHEN I.QTY - R.ACC_RTF_31 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_30)) / CASE WHEN R.RTF_NEXT_31 = 0  THEN NULL ELSE R.RTF_NEXT_31  END, 0) * D.DAYS_NEXT_31 + D.ACC_DAYS_30
					WHEN I.QTY - R.ACC_RTF_31 = 0  THEN 
						 D.ACC_DAYS_31
					WHEN I.QTY - R.ACC_RTF_32 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_31)) / CASE WHEN R.RTF_NEXT_32 = 0  THEN NULL ELSE R.RTF_NEXT_32  END, 0) * D.DAYS_NEXT_32 + D.ACC_DAYS_31
					WHEN I.QTY - R.ACC_RTF_32 = 0  THEN 
						 D.ACC_DAYS_32
					WHEN I.QTY - R.ACC_RTF_33 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_32)) / CASE WHEN R.RTF_NEXT_33 = 0  THEN NULL ELSE R.RTF_NEXT_33  END, 0) * D.DAYS_NEXT_33 + D.ACC_DAYS_32
					WHEN I.QTY - R.ACC_RTF_33 = 0  THEN 
						 D.ACC_DAYS_33
					WHEN I.QTY - R.ACC_RTF_34 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_33)) / CASE WHEN R.RTF_NEXT_34 = 0  THEN NULL ELSE R.RTF_NEXT_34  END, 0) * D.DAYS_NEXT_34 + D.ACC_DAYS_33
					WHEN I.QTY - R.ACC_RTF_34 = 0  THEN 
						 D.ACC_DAYS_34
					WHEN I.QTY - R.ACC_RTF_35 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_34)) / CASE WHEN R.RTF_NEXT_35 = 0  THEN NULL ELSE R.RTF_NEXT_35  END, 0) * D.DAYS_NEXT_35 + D.ACC_DAYS_34
					WHEN I.QTY - R.ACC_RTF_35 = 0  THEN 
						 D.ACC_DAYS_35
					WHEN I.QTY - R.ACC_RTF_36 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_35)) / CASE WHEN R.RTF_NEXT_36 = 0  THEN NULL ELSE R.RTF_NEXT_36  END, 0) * D.DAYS_NEXT_36 + D.ACC_DAYS_35
					WHEN I.QTY - R.ACC_RTF_36 = 0  THEN 
						 D.ACC_DAYS_36
					WHEN I.QTY - R.ACC_RTF_37 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_36)) / CASE WHEN R.RTF_NEXT_37 = 0  THEN NULL ELSE R.RTF_NEXT_37  END, 0) * D.DAYS_NEXT_37 + D.ACC_DAYS_36
					WHEN I.QTY - R.ACC_RTF_37 = 0  THEN 
						 D.ACC_DAYS_37
					WHEN I.QTY - R.ACC_RTF_38 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_37)) / CASE WHEN R.RTF_NEXT_38 = 0  THEN NULL ELSE R.RTF_NEXT_38  END, 0) * D.DAYS_NEXT_38 + D.ACC_DAYS_37
					WHEN I.QTY - R.ACC_RTF_38 = 0  THEN 
						 D.ACC_DAYS_38
					WHEN I.QTY - R.ACC_RTF_39 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_38)) / CASE WHEN R.RTF_NEXT_39 = 0  THEN NULL ELSE R.RTF_NEXT_39  END, 0) * D.DAYS_NEXT_39 + D.ACC_DAYS_38
					WHEN I.QTY - R.ACC_RTF_39 = 0  THEN 
						 D.ACC_DAYS_39
					WHEN I.QTY - R.ACC_RTF_40 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_39)) / CASE WHEN R.RTF_NEXT_40 = 0  THEN NULL ELSE R.RTF_NEXT_40  END, 0) * D.DAYS_NEXT_40 + D.ACC_DAYS_39
					WHEN I.QTY - R.ACC_RTF_40 = 0  THEN 
						 D.ACC_DAYS_40
					WHEN I.QTY - R.ACC_RTF_41 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_40)) / CASE WHEN R.RTF_NEXT_41 = 0  THEN NULL ELSE R.RTF_NEXT_41  END, 0) * D.DAYS_NEXT_41 + D.ACC_DAYS_40
					WHEN I.QTY - R.ACC_RTF_41 = 0  THEN 
						 D.ACC_DAYS_41
					WHEN I.QTY - R.ACC_RTF_42 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_41)) / CASE WHEN R.RTF_NEXT_42 = 0  THEN NULL ELSE R.RTF_NEXT_42  END, 0) * D.DAYS_NEXT_42 + D.ACC_DAYS_41
					WHEN I.QTY - R.ACC_RTF_42 = 0  THEN 
						 D.ACC_DAYS_42
					WHEN I.QTY - R.ACC_RTF_43 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_42)) / CASE WHEN R.RTF_NEXT_43 = 0  THEN NULL ELSE R.RTF_NEXT_43  END, 0) * D.DAYS_NEXT_43 + D.ACC_DAYS_42
					WHEN I.QTY - R.ACC_RTF_43 = 0  THEN 
						 D.ACC_DAYS_43
					WHEN I.QTY - R.ACC_RTF_44 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_43)) / CASE WHEN R.RTF_NEXT_44 = 0  THEN NULL ELSE R.RTF_NEXT_44  END, 0) * D.DAYS_NEXT_44 + D.ACC_DAYS_43
					WHEN I.QTY - R.ACC_RTF_44 = 0  THEN 
						 D.ACC_DAYS_44
					WHEN I.QTY - R.ACC_RTF_45 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_44)) / CASE WHEN R.RTF_NEXT_45 = 0  THEN NULL ELSE R.RTF_NEXT_45  END, 0) * D.DAYS_NEXT_45 + D.ACC_DAYS_44
					WHEN I.QTY - R.ACC_RTF_45 = 0  THEN 
						 D.ACC_DAYS_45
					WHEN I.QTY - R.ACC_RTF_46 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_45)) / CASE WHEN R.RTF_NEXT_46 = 0  THEN NULL ELSE R.RTF_NEXT_46  END, 0) * D.DAYS_NEXT_46 + D.ACC_DAYS_45
					WHEN I.QTY - R.ACC_RTF_46 = 0  THEN 
						 D.ACC_DAYS_46
					WHEN I.QTY - R.ACC_RTF_47 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_46)) / CASE WHEN R.RTF_NEXT_47 = 0  THEN NULL ELSE R.RTF_NEXT_47  END, 0) * D.DAYS_NEXT_47 + D.ACC_DAYS_46
					WHEN I.QTY - R.ACC_RTF_47 = 0  THEN 
						 D.ACC_DAYS_47
					WHEN I.QTY - R.ACC_RTF_48 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_47)) / CASE WHEN R.RTF_NEXT_48 = 0  THEN NULL ELSE R.RTF_NEXT_48  END, 0) * D.DAYS_NEXT_48 + D.ACC_DAYS_47
					WHEN I.QTY - R.ACC_RTF_48 = 0  THEN 
						 D.ACC_DAYS_48
					WHEN I.QTY - R.ACC_RTF_49 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_48)) / CASE WHEN R.RTF_NEXT_49 = 0  THEN NULL ELSE R.RTF_NEXT_49  END, 0) * D.DAYS_NEXT_49 + D.ACC_DAYS_48
					WHEN I.QTY - R.ACC_RTF_49 = 0  THEN 
						 D.ACC_DAYS_49
					WHEN I.QTY - R.ACC_RTF_50 < 0 THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_49)) / CASE WHEN R.RTF_NEXT_50 = 0  THEN NULL ELSE R.RTF_NEXT_50  END, 0) * D.DAYS_NEXT_50 + D.ACC_DAYS_49
					WHEN I.QTY - R.ACC_RTF_50 = 0  THEN 
						 D.ACC_DAYS_50
					WHEN I.QTY - R.ACC_RTF_51 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_50)) / CASE WHEN R.RTF_NEXT_51 = 0  THEN NULL ELSE R.RTF_NEXT_51  END, 0) * D.DAYS_NEXT_51 + D.ACC_DAYS_50
					WHEN I.QTY - R.ACC_RTF_51 = 0  THEN 
						 D.ACC_DAYS_51
					WHEN I.QTY - R.ACC_RTF_52 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_51)) / CASE WHEN R.RTF_NEXT_52 = 0  THEN NULL ELSE R.RTF_NEXT_52  END, 0) * D.DAYS_NEXT_52 + D.ACC_DAYS_51
					WHEN I.QTY - R.ACC_RTF_52 = 0  THEN 
						 D.ACC_DAYS_52
					WHEN I.QTY - R.ACC_RTF_53 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_52)) / CASE WHEN R.RTF_NEXT_53 = 0  THEN NULL ELSE R.RTF_NEXT_53  END, 0) * D.DAYS_NEXT_53 + D.ACC_DAYS_52
					WHEN I.QTY - R.ACC_RTF_53 = 0  THEN 
						 D.ACC_DAYS_53
					WHEN I.QTY - R.ACC_RTF_54 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_53)) / CASE WHEN R.RTF_NEXT_54 = 0  THEN NULL ELSE R.RTF_NEXT_54  END, 0) * D.DAYS_NEXT_54 + D.ACC_DAYS_53
					WHEN I.QTY - R.ACC_RTF_54 = 0  THEN 
						 D.ACC_DAYS_54
					WHEN I.QTY - R.ACC_RTF_55 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_54)) / CASE WHEN R.RTF_NEXT_55 = 0  THEN NULL ELSE R.RTF_NEXT_55  END, 0) * D.DAYS_NEXT_55 + D.ACC_DAYS_54
					WHEN I.QTY - R.ACC_RTF_55 = 0  THEN 
						 D.ACC_DAYS_55
					WHEN I.QTY - R.ACC_RTF_56 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_55)) / CASE WHEN R.RTF_NEXT_56 = 0  THEN NULL ELSE R.RTF_NEXT_56  END, 0) * D.DAYS_NEXT_56 + D.ACC_DAYS_55
					WHEN I.QTY - R.ACC_RTF_56 = 0  THEN 
						 D.ACC_DAYS_56
					WHEN I.QTY - R.ACC_RTF_57 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_56)) / CASE WHEN R.RTF_NEXT_57 = 0  THEN NULL ELSE R.RTF_NEXT_57  END, 0) * D.DAYS_NEXT_57 + D.ACC_DAYS_56
					WHEN I.QTY - R.ACC_RTF_57 = 0  THEN 
						 D.ACC_DAYS_57
					WHEN I.QTY - R.ACC_RTF_58 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_57)) / CASE WHEN R.RTF_NEXT_58 = 0  THEN NULL ELSE R.RTF_NEXT_58  END, 0) * D.DAYS_NEXT_58 + D.ACC_DAYS_57
					WHEN I.QTY - R.ACC_RTF_58 = 0  THEN 
						 D.ACC_DAYS_58
					WHEN I.QTY - R.ACC_RTF_59 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_58)) / CASE WHEN R.RTF_NEXT_59 = 0  THEN NULL ELSE R.RTF_NEXT_59  END, 0) * D.DAYS_NEXT_59 + D.ACC_DAYS_58
					WHEN I.QTY - R.ACC_RTF_59 = 0  THEN 
						 D.ACC_DAYS_59
					WHEN I.QTY - R.ACC_RTF_60 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_59)) / CASE WHEN R.RTF_NEXT_60 = 0  THEN NULL ELSE R.RTF_NEXT_60  END, 0) * D.DAYS_NEXT_60 + D.ACC_DAYS_59
					WHEN I.QTY - R.ACC_RTF_60 = 0  THEN 
						 D.ACC_DAYS_60
					WHEN I.QTY - R.ACC_RTF_61 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_60)) / CASE WHEN R.RTF_NEXT_61 = 0  THEN NULL ELSE R.RTF_NEXT_61  END, 0) * D.DAYS_NEXT_61 + D.ACC_DAYS_60
					WHEN I.QTY - R.ACC_RTF_61 = 0  THEN 
						 D.ACC_DAYS_61
					WHEN I.QTY - R.ACC_RTF_62 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_61)) / CASE WHEN R.RTF_NEXT_62 = 0  THEN NULL ELSE R.RTF_NEXT_62  END, 0) * D.DAYS_NEXT_62 + D.ACC_DAYS_61
					WHEN I.QTY - R.ACC_RTF_62 = 0  THEN 
						 D.ACC_DAYS_62
					WHEN I.QTY - R.ACC_RTF_63 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_62)) / CASE WHEN R.RTF_NEXT_63 = 0  THEN NULL ELSE R.RTF_NEXT_63  END, 0) * D.DAYS_NEXT_63 + D.ACC_DAYS_62
					WHEN I.QTY - R.ACC_RTF_63 = 0  THEN 
						 D.ACC_DAYS_63

					ELSE 365
				END					AS DIO 
		  INTO #TMP_INVENTORY_DIO
		  FROM #BASE_DATA_FOR_DIO  I -- 재고 
			   INNER JOIN #TMP_WW_DAYS_INFO D
					  ON D.YYYYPW			= I.YYYYPW
			   LEFT JOIN #TMP_RTF_FOR_DIO R
					  ON R.YYYYPW			= I.YYYYPW
					 AND R.CELL_GROUP		= I.CELL_GROUP
					 AND R.OPERATION_GROUP	= I.OPERATION_GROUP
		WHERE 1=1
		  AND I.MEASURE = 'INV' -- 재고
	
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 셀그룹별 DIO 산출(표준 레포트)'	--@@@ 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_INVENTORY_DIO_CELLGROUP') IS NOT NULL	
			DROP TABLE #TMP_INVENTORY_DIO_CELLGROUP;

		SELECT I.YYYYPW
			  ,I.YYYYPW_SEQ
			  ,I.PW_DAYS
			  ,I.CELL_GROUP
			  ,I.CELL_GROUP_YN		-- 20240311 
			  ,I.OPERATION_GROUP
			  ,CL.MEASURE
			  ,I.QTY		AS INV_QTY
			  ,R.RTF_QTY	AS RTF_QTY
			  ,CASE WHEN I.QTY <= 0 THEN 
						 0
					WHEN R.CELL_GROUP IS NULL THEN 
						 365 
				    WHEN I.QTY - R.RTF_NEXT_1 < 0 THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), I.QTY)				    / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0)   * D.DAYS_NEXT_1 
					WHEN I.QTY - R.RTF_NEXT_1 = 0 THEN 
						 D.ACC_DAYS_1
					WHEN I.QTY - R.ACC_RTF_2 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_1)) / CASE WHEN R.RTF_NEXT_2 = 0  THEN NULL ELSE R.RTF_NEXT_2  END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
					WHEN I.QTY - R.ACC_RTF_2 = 0  THEN 
						 D.ACC_DAYS_2
					WHEN I.QTY - R.ACC_RTF_3 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_2)) / CASE WHEN R.RTF_NEXT_3 = 0  THEN NULL ELSE R.RTF_NEXT_3  END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
					WHEN I.QTY - R.ACC_RTF_3 = 0  THEN 
						 D.ACC_DAYS_3
					WHEN I.QTY - R.ACC_RTF_4 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_3)) / CASE WHEN R.RTF_NEXT_4 = 0  THEN NULL ELSE R.RTF_NEXT_4  END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
					WHEN I.QTY - R.ACC_RTF_4 = 0  THEN 
						 D.ACC_DAYS_4
					WHEN I.QTY - R.ACC_RTF_5 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_4)) / CASE WHEN R.RTF_NEXT_5 = 0  THEN NULL ELSE R.RTF_NEXT_5  END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
					WHEN I.QTY - R.ACC_RTF_5 = 0  THEN 
						 D.ACC_DAYS_5
					WHEN I.QTY - R.ACC_RTF_6 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_5)) / CASE WHEN R.RTF_NEXT_6 = 0  THEN NULL ELSE R.RTF_NEXT_6  END, 0) * D.DAYS_NEXT_6 + D.ACC_DAYS_5
					WHEN I.QTY - R.ACC_RTF_6 = 0  THEN 
						 D.ACC_DAYS_6
					WHEN I.QTY - R.ACC_RTF_7 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_6)) / CASE WHEN R.RTF_NEXT_7 = 0  THEN NULL ELSE R.RTF_NEXT_7 END, 0) * D.DAYS_NEXT_7 + D.ACC_DAYS_6
					WHEN I.QTY - R.ACC_RTF_7 = 0  THEN 
						 D.ACC_DAYS_7
					WHEN I.QTY - R.ACC_RTF_8 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_7)) / CASE WHEN R.RTF_NEXT_8 = 0  THEN NULL ELSE R.RTF_NEXT_8  END, 0) * D.DAYS_NEXT_8 + D.ACC_DAYS_7
					WHEN I.QTY - R.ACC_RTF_8 = 0  THEN 
						 D.ACC_DAYS_8
					WHEN I.QTY - R.ACC_RTF_9 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_8)) / CASE WHEN R.RTF_NEXT_9 = 0  THEN NULL ELSE R.RTF_NEXT_9  END, 0) * D.DAYS_NEXT_9 + D.ACC_DAYS_8
					WHEN I.QTY - R.ACC_RTF_9 = 0  THEN 
						 D.ACC_DAYS_9
					WHEN I.QTY - R.ACC_RTF_10 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_9)) / CASE WHEN R.RTF_NEXT_10 = 0  THEN NULL ELSE R.RTF_NEXT_10  END, 0) * D.DAYS_NEXT_10 + D.ACC_DAYS_9
					WHEN I.QTY - R.ACC_RTF_10 = 0  THEN 
						 D.ACC_DAYS_10
					WHEN I.QTY - R.ACC_RTF_11 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_10)) / CASE WHEN R.RTF_NEXT_11 = 0  THEN NULL ELSE R.RTF_NEXT_11  END, 0) * D.DAYS_NEXT_11 + D.ACC_DAYS_10
					WHEN I.QTY - R.ACC_RTF_11 = 0  THEN 
						 D.ACC_DAYS_11
					WHEN I.QTY - R.ACC_RTF_12 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_11)) / CASE WHEN R.RTF_NEXT_12 = 0  THEN NULL ELSE R.RTF_NEXT_12  END, 0) * D.DAYS_NEXT_12 + D.ACC_DAYS_11
					WHEN I.QTY - R.ACC_RTF_12 = 0  THEN 
						 D.ACC_DAYS_12
					WHEN I.QTY - R.ACC_RTF_13 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_12)) / CASE WHEN R.RTF_NEXT_13 = 0  THEN NULL ELSE R.RTF_NEXT_13  END, 0) * D.DAYS_NEXT_13 + D.ACC_DAYS_12
					WHEN I.QTY - R.ACC_RTF_13 = 0  THEN 
						 D.ACC_DAYS_13
					WHEN I.QTY - R.ACC_RTF_14 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_13)) / CASE WHEN R.RTF_NEXT_14 = 0  THEN NULL ELSE R.RTF_NEXT_14  END, 0) * D.DAYS_NEXT_14 + D.ACC_DAYS_13
					WHEN I.QTY - R.ACC_RTF_14 = 0  THEN 
						 D.ACC_DAYS_14
					WHEN I.QTY - R.ACC_RTF_15 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_14)) / CASE WHEN R.RTF_NEXT_15 = 0  THEN NULL ELSE R.RTF_NEXT_15  END, 0) * D.DAYS_NEXT_15 + D.ACC_DAYS_14
					WHEN I.QTY - R.ACC_RTF_15 = 0  THEN 
						 D.ACC_DAYS_15
					WHEN I.QTY - R.ACC_RTF_16 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_15)) / CASE WHEN R.RTF_NEXT_16 = 0  THEN NULL ELSE R.RTF_NEXT_16  END, 0) * D.DAYS_NEXT_16 + D.ACC_DAYS_15
					WHEN I.QTY - R.ACC_RTF_16 = 0  THEN 
						 D.ACC_DAYS_16
					WHEN I.QTY - R.ACC_RTF_17 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_16)) / CASE WHEN R.RTF_NEXT_17 = 0  THEN NULL ELSE R.RTF_NEXT_17  END, 0) * D.DAYS_NEXT_17 + D.ACC_DAYS_16
					WHEN I.QTY - R.ACC_RTF_17 = 0  THEN 
						 D.ACC_DAYS_17
					WHEN I.QTY - R.ACC_RTF_18 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_17)) / CASE WHEN R.RTF_NEXT_18 = 0  THEN NULL ELSE R.RTF_NEXT_18  END, 0) * D.DAYS_NEXT_18 + D.ACC_DAYS_17
					WHEN I.QTY - R.ACC_RTF_18 = 0  THEN 
						 D.ACC_DAYS_18
					WHEN I.QTY - R.ACC_RTF_19 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_18)) / CASE WHEN R.RTF_NEXT_19 = 0  THEN NULL ELSE R.RTF_NEXT_19  END, 0) * D.DAYS_NEXT_19 + D.ACC_DAYS_18
					WHEN I.QTY - R.ACC_RTF_19 = 0  THEN 
						 D.ACC_DAYS_19
					WHEN I.QTY - R.ACC_RTF_20 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_19)) / CASE WHEN R.RTF_NEXT_20 = 0  THEN NULL ELSE R.RTF_NEXT_20  END, 0) * D.DAYS_NEXT_20 + D.ACC_DAYS_19
					WHEN I.QTY - R.ACC_RTF_20 = 0  THEN 
						 D.ACC_DAYS_20
					WHEN I.QTY - R.ACC_RTF_21 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_20)) / CASE WHEN R.RTF_NEXT_21 = 0  THEN NULL ELSE R.RTF_NEXT_21  END, 0) * D.DAYS_NEXT_21 + D.ACC_DAYS_20
					WHEN I.QTY - R.ACC_RTF_21 = 0  THEN 
						 D.ACC_DAYS_21
					WHEN I.QTY - R.ACC_RTF_22 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_21)) / CASE WHEN R.RTF_NEXT_22 = 0  THEN NULL ELSE R.RTF_NEXT_22  END, 0) * D.DAYS_NEXT_22 + D.ACC_DAYS_21
					WHEN I.QTY - R.ACC_RTF_22 = 0  THEN 
						 D.ACC_DAYS_22
					WHEN I.QTY - R.ACC_RTF_23 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_22)) / CASE WHEN R.RTF_NEXT_23 = 0  THEN NULL ELSE R.RTF_NEXT_23  END, 0) * D.DAYS_NEXT_23 + D.ACC_DAYS_22
					WHEN I.QTY - R.ACC_RTF_23 = 0  THEN 
						 D.ACC_DAYS_23
					WHEN I.QTY - R.ACC_RTF_24 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_23)) / CASE WHEN R.RTF_NEXT_24 = 0  THEN NULL ELSE R.RTF_NEXT_24  END, 0) * D.DAYS_NEXT_24 + D.ACC_DAYS_23
					WHEN I.QTY - R.ACC_RTF_24 = 0  THEN 
						 D.ACC_DAYS_24
					WHEN I.QTY - R.ACC_RTF_25 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_24)) / CASE WHEN R.RTF_NEXT_25 = 0  THEN NULL ELSE R.RTF_NEXT_25  END, 0) * D.DAYS_NEXT_25 + D.ACC_DAYS_24
					WHEN I.QTY - R.ACC_RTF_25 = 0  THEN 
						 D.ACC_DAYS_25
					WHEN I.QTY - R.ACC_RTF_26 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_25)) / CASE WHEN R.RTF_NEXT_26 = 0  THEN NULL ELSE R.RTF_NEXT_26  END, 0) * D.DAYS_NEXT_26 + D.ACC_DAYS_25
					WHEN I.QTY - R.ACC_RTF_26 = 0  THEN 
						 D.ACC_DAYS_26
					WHEN I.QTY - R.ACC_RTF_27 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_26)) / CASE WHEN R.RTF_NEXT_27 = 0  THEN NULL ELSE R.RTF_NEXT_27  END, 0) * D.DAYS_NEXT_27 + D.ACC_DAYS_26
					WHEN I.QTY - R.ACC_RTF_27 = 0  THEN 
						 D.ACC_DAYS_27
					WHEN I.QTY - R.ACC_RTF_28 < 0 THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_27)) / CASE WHEN R.RTF_NEXT_28 = 0  THEN NULL ELSE R.RTF_NEXT_28  END, 0) * D.DAYS_NEXT_28 + D.ACC_DAYS_27
					WHEN I.QTY - R.ACC_RTF_28 = 0  THEN 
						 D.ACC_DAYS_28
					WHEN I.QTY - R.ACC_RTF_29 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_28)) / CASE WHEN R.RTF_NEXT_29 = 0  THEN NULL ELSE R.RTF_NEXT_29  END, 0) * D.DAYS_NEXT_29 + D.ACC_DAYS_28
					WHEN I.QTY - R.ACC_RTF_29 = 0  THEN 
						 D.ACC_DAYS_29
					WHEN I.QTY - R.ACC_RTF_30 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_29)) / CASE WHEN R.RTF_NEXT_30 = 0  THEN NULL ELSE R.RTF_NEXT_30  END, 0) * D.DAYS_NEXT_30 + D.ACC_DAYS_29
					WHEN I.QTY - R.ACC_RTF_30 = 0  THEN 
						 D.ACC_DAYS_30
					WHEN I.QTY - R.ACC_RTF_31 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_30)) / CASE WHEN R.RTF_NEXT_31 = 0  THEN NULL ELSE R.RTF_NEXT_31  END, 0) * D.DAYS_NEXT_31 + D.ACC_DAYS_30
					WHEN I.QTY - R.ACC_RTF_31 = 0  THEN 
						 D.ACC_DAYS_31
					WHEN I.QTY - R.ACC_RTF_32 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_31)) / CASE WHEN R.RTF_NEXT_32 = 0  THEN NULL ELSE R.RTF_NEXT_32  END, 0) * D.DAYS_NEXT_32 + D.ACC_DAYS_31
					WHEN I.QTY - R.ACC_RTF_32 = 0  THEN 
						 D.ACC_DAYS_32
					WHEN I.QTY - R.ACC_RTF_33 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_32)) / CASE WHEN R.RTF_NEXT_33 = 0  THEN NULL ELSE R.RTF_NEXT_33  END, 0) * D.DAYS_NEXT_33 + D.ACC_DAYS_32
					WHEN I.QTY - R.ACC_RTF_33 = 0  THEN 
						 D.ACC_DAYS_33
					WHEN I.QTY - R.ACC_RTF_34 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_33)) / CASE WHEN R.RTF_NEXT_34 = 0  THEN NULL ELSE R.RTF_NEXT_34  END, 0) * D.DAYS_NEXT_34 + D.ACC_DAYS_33
					WHEN I.QTY - R.ACC_RTF_34 = 0  THEN 
						 D.ACC_DAYS_34
					WHEN I.QTY - R.ACC_RTF_35 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_34)) / CASE WHEN R.RTF_NEXT_35 = 0  THEN NULL ELSE R.RTF_NEXT_35  END, 0) * D.DAYS_NEXT_35 + D.ACC_DAYS_34
					WHEN I.QTY - R.ACC_RTF_35 = 0  THEN 
						 D.ACC_DAYS_35
					WHEN I.QTY - R.ACC_RTF_36 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_35)) / CASE WHEN R.RTF_NEXT_36 = 0  THEN NULL ELSE R.RTF_NEXT_36  END, 0) * D.DAYS_NEXT_36 + D.ACC_DAYS_35
					WHEN I.QTY - R.ACC_RTF_36 = 0  THEN 
						 D.ACC_DAYS_36
					WHEN I.QTY - R.ACC_RTF_37 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_36)) / CASE WHEN R.RTF_NEXT_37 = 0  THEN NULL ELSE R.RTF_NEXT_37  END, 0) * D.DAYS_NEXT_37 + D.ACC_DAYS_36
					WHEN I.QTY - R.ACC_RTF_37 = 0 THEN 
						 D.ACC_DAYS_37
					WHEN I.QTY - R.ACC_RTF_38 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_37)) / CASE WHEN R.RTF_NEXT_38 = 0  THEN NULL ELSE R.RTF_NEXT_38  END, 0) * D.DAYS_NEXT_38 + D.ACC_DAYS_37
					WHEN I.QTY - R.ACC_RTF_38 = 0  THEN 
						 D.ACC_DAYS_38
					WHEN I.QTY - R.ACC_RTF_39 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_38)) / CASE WHEN R.RTF_NEXT_39 = 0  THEN NULL ELSE R.RTF_NEXT_39  END, 0) * D.DAYS_NEXT_39 + D.ACC_DAYS_38
					WHEN I.QTY - R.ACC_RTF_39 = 0  THEN 
						 D.ACC_DAYS_39
					WHEN I.QTY - R.ACC_RTF_40 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_39)) / CASE WHEN R.RTF_NEXT_40 = 0  THEN NULL ELSE R.RTF_NEXT_40  END, 0) * D.DAYS_NEXT_40 + D.ACC_DAYS_39
					WHEN I.QTY - R.ACC_RTF_40 = 0  THEN 
						 D.ACC_DAYS_40
					WHEN I.QTY - R.ACC_RTF_41 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_40)) / CASE WHEN R.RTF_NEXT_41 = 0  THEN NULL ELSE R.RTF_NEXT_41  END, 0) * D.DAYS_NEXT_41 + D.ACC_DAYS_40
					WHEN I.QTY - R.ACC_RTF_41 = 0  THEN 
						 D.ACC_DAYS_41
					WHEN I.QTY - R.ACC_RTF_42 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_41)) / CASE WHEN R.RTF_NEXT_42 = 0  THEN NULL ELSE R.RTF_NEXT_42  END, 0) * D.DAYS_NEXT_42 + D.ACC_DAYS_41
					WHEN I.QTY - R.ACC_RTF_42 = 0  THEN 
						 D.ACC_DAYS_42
					WHEN I.QTY - R.ACC_RTF_43 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_42)) / CASE WHEN R.RTF_NEXT_43 = 0  THEN NULL ELSE R.RTF_NEXT_43  END, 0) * D.DAYS_NEXT_43 + D.ACC_DAYS_42
					WHEN I.QTY - R.ACC_RTF_43 = 0  THEN 
						 D.ACC_DAYS_43
					WHEN I.QTY - R.ACC_RTF_44 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_43)) / CASE WHEN R.RTF_NEXT_44 = 0  THEN NULL ELSE R.RTF_NEXT_44  END, 0) * D.DAYS_NEXT_44 + D.ACC_DAYS_43
					WHEN I.QTY - R.ACC_RTF_44 = 0  THEN 
						 D.ACC_DAYS_44
					WHEN I.QTY - R.ACC_RTF_45 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_44)) / CASE WHEN R.RTF_NEXT_45 = 0  THEN NULL ELSE R.RTF_NEXT_45  END, 0) * D.DAYS_NEXT_45 + D.ACC_DAYS_44
					WHEN I.QTY - R.ACC_RTF_45 = 0  THEN 
						 D.ACC_DAYS_45
					WHEN I.QTY - R.ACC_RTF_46 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_45)) / CASE WHEN R.RTF_NEXT_46 = 0  THEN NULL ELSE R.RTF_NEXT_46  END, 0) * D.DAYS_NEXT_46 + D.ACC_DAYS_45
					WHEN I.QTY - R.ACC_RTF_46 = 0  THEN 
						 D.ACC_DAYS_46
					WHEN I.QTY - R.ACC_RTF_47 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_46)) / CASE WHEN R.RTF_NEXT_47 = 0  THEN NULL ELSE R.RTF_NEXT_47  END, 0) * D.DAYS_NEXT_47 + D.ACC_DAYS_46
					WHEN I.QTY - R.ACC_RTF_47 = 0  THEN 
						 D.ACC_DAYS_47
					WHEN I.QTY - R.ACC_RTF_48 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_47)) / CASE WHEN R.RTF_NEXT_48 = 0  THEN NULL ELSE R.RTF_NEXT_48  END, 0) * D.DAYS_NEXT_48 + D.ACC_DAYS_47
					WHEN I.QTY - R.ACC_RTF_48 = 0  THEN 
						 D.ACC_DAYS_48
					WHEN I.QTY - R.ACC_RTF_49 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_48)) / CASE WHEN R.RTF_NEXT_49 = 0  THEN NULL ELSE R.RTF_NEXT_49  END, 0) * D.DAYS_NEXT_49 + D.ACC_DAYS_48
					WHEN I.QTY - R.ACC_RTF_49 = 0  THEN 
						 D.ACC_DAYS_49
					WHEN I.QTY - R.ACC_RTF_50 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_49)) / CASE WHEN R.RTF_NEXT_50 = 0  THEN NULL ELSE R.RTF_NEXT_50  END, 0) * D.DAYS_NEXT_50 + D.ACC_DAYS_49
					WHEN I.QTY - R.ACC_RTF_50 = 0  THEN 
						 D.ACC_DAYS_50
					WHEN I.QTY - R.ACC_RTF_51 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_50)) / CASE WHEN R.RTF_NEXT_51 = 0 THEN NULL ELSE R.RTF_NEXT_51  END, 0) * D.DAYS_NEXT_51 + D.ACC_DAYS_50
					WHEN I.QTY - R.ACC_RTF_51 = 0  THEN 
						 D.ACC_DAYS_51
					WHEN I.QTY - R.ACC_RTF_52 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_51)) / CASE WHEN R.RTF_NEXT_52 = 0  THEN NULL ELSE R.RTF_NEXT_52  END, 0) * D.DAYS_NEXT_52 + D.ACC_DAYS_51
					WHEN I.QTY - R.ACC_RTF_52 = 0  THEN 
						 D.ACC_DAYS_52
					WHEN I.QTY - R.ACC_RTF_53 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_52)) / CASE WHEN R.RTF_NEXT_53 = 0  THEN NULL ELSE R.RTF_NEXT_53  END, 0) * D.DAYS_NEXT_53 + D.ACC_DAYS_52
					WHEN I.QTY - R.ACC_RTF_53 = 0  THEN 
						 D.ACC_DAYS_53
					WHEN I.QTY - R.ACC_RTF_54 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_53)) / CASE WHEN R.RTF_NEXT_54 = 0  THEN NULL ELSE R.RTF_NEXT_54  END, 0) * D.DAYS_NEXT_54 + D.ACC_DAYS_53
					WHEN I.QTY - R.ACC_RTF_54 = 0  THEN 
						 D.ACC_DAYS_54
					WHEN I.QTY - R.ACC_RTF_55 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_54)) / CASE WHEN R.RTF_NEXT_55 = 0  THEN NULL ELSE R.RTF_NEXT_55  END, 0) * D.DAYS_NEXT_55 + D.ACC_DAYS_54
					WHEN I.QTY - R.ACC_RTF_55 = 0  THEN 
						 D.ACC_DAYS_55
					WHEN I.QTY - R.ACC_RTF_56 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_55)) / CASE WHEN R.RTF_NEXT_56 = 0  THEN NULL ELSE R.RTF_NEXT_56  END, 0) * D.DAYS_NEXT_56 + D.ACC_DAYS_55
					WHEN I.QTY - R.ACC_RTF_56 = 0  THEN 
						 D.ACC_DAYS_56
					WHEN I.QTY - R.ACC_RTF_57 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_56)) / CASE WHEN R.RTF_NEXT_57 = 0  THEN NULL ELSE R.RTF_NEXT_57  END, 0) * D.DAYS_NEXT_57 + D.ACC_DAYS_56
					WHEN I.QTY - R.ACC_RTF_57 = 0  THEN 
						 D.ACC_DAYS_57
					WHEN I.QTY - R.ACC_RTF_58 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_57)) / CASE WHEN R.RTF_NEXT_58 = 0  THEN NULL ELSE R.RTF_NEXT_58  END, 0) * D.DAYS_NEXT_58 + D.ACC_DAYS_57
					WHEN I.QTY - R.ACC_RTF_58 = 0  THEN 
						 D.ACC_DAYS_58
					WHEN I.QTY - R.ACC_RTF_59 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_58)) / CASE WHEN R.RTF_NEXT_59 = 0  THEN NULL ELSE R.RTF_NEXT_59  END, 0) * D.DAYS_NEXT_59 + D.ACC_DAYS_58
					WHEN I.QTY - R.ACC_RTF_59 = 0  THEN 
						 D.ACC_DAYS_59
					WHEN I.QTY - R.ACC_RTF_60 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_59)) / CASE WHEN R.RTF_NEXT_60 = 0  THEN NULL ELSE R.RTF_NEXT_60  END, 0) * D.DAYS_NEXT_60 + D.ACC_DAYS_59
					WHEN I.QTY - R.ACC_RTF_60 = 0  THEN 
						 D.ACC_DAYS_60
					WHEN I.QTY - R.ACC_RTF_61 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_60)) / CASE WHEN R.RTF_NEXT_61 = 0  THEN NULL ELSE R.RTF_NEXT_61  END, 0) * D.DAYS_NEXT_61 + D.ACC_DAYS_60
					WHEN I.QTY - R.ACC_RTF_61 = 0  THEN 
						 D.ACC_DAYS_61
					WHEN I.QTY - R.ACC_RTF_62 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_61)) / CASE WHEN R.RTF_NEXT_62 = 0  THEN NULL ELSE R.RTF_NEXT_62  END, 0) * D.DAYS_NEXT_62 + D.ACC_DAYS_61
					WHEN I.QTY - R.ACC_RTF_62 = 0  THEN 
						 D.ACC_DAYS_62
					WHEN I.QTY - R.ACC_RTF_63 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_62)) / CASE WHEN R.RTF_NEXT_63 = 0  THEN NULL ELSE R.RTF_NEXT_63  END, 0) * D.DAYS_NEXT_63 + D.ACC_DAYS_62
					WHEN I.QTY - R.ACC_RTF_63 = 0  THEN 
						 D.ACC_DAYS_63

					ELSE 365
				END					AS DIO 
		  INTO #TMP_INVENTORY_DIO_CELLGROUP
		   FROM (
					SELECT *,  REPLACE(I.MEASURE,'INV_','') AS MEASURE_GROUP
					FROM #BASE_DATA_FOR_DIO_CELLGROUP  I -- 재고 
					WHERE 1=1
					AND I.MEASURE LIKE 'INV%' -- 재고
					--AND ISNULL(I.QTY,0) > 0 
				) I
		  	   INNER JOIN (
							SELECT 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP UNION
							SELECT 'DIO_PACK' AS MEASURE, 'PACK' AS MEASURE_GROUP UNION
							SELECT 'DIO_CELL' AS MEASURE, 'CELL' AS MEASURE_GROUP 
					      ) CL
				      ON 1=1
				      --AND CL.MEASURE_GROUP = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE)) 
					  AND CL.MEASURE_GROUP = I.MEASURE_GROUP
			  INNER JOIN #TMP_WW_DAYS_INFO D
					  ON D.YYYYPW			= I.YYYYPW
				INNER  JOIN (	-- LEFT OUTER JOIN 에서 INNER JOIN 으로 변경 - 수량이 빠지는 부분이 없어 속도 개선위해 변경함 빠지는 부분이 있으면 추가 로직으로 보충해야 함.
									SELECT R.*, REPLACE(R.MEASURE, 'RTF_','') AS  MEASURE_GROUP
									FROM #TMP_RTF_FOR_DIO_CELLGROUP R	
				) R
					  ON R.YYYYPW			= I.YYYYPW
					 AND R.CELL_GROUP		= I.CELL_GROUP
					 AND R.OPERATION_GROUP	= I.OPERATION_GROUP
					 --AND SUBSTRING(R.MEASURE, CHARINDEX('_', R.MEASURE) + 1, LEN(R.MEASURE)) = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE))
					 AND R.MEASURE_GROUP = I.MEASURE_GROUP
		WHERE 1=1
		  AND I.MEASURE LIKE 'INV%' -- 재고
		  ;
		 


		-- PACK_DIO = PACK_DIO - SALES_DIO
		UPDATE 	A
		SET 	A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
		FROM 	#TMP_INVENTORY_DIO_CELLGROUP A
				INNER JOIN (
								SELECT A.YYYYPW, A.CELL_GROUP, A.MEASURE
										, CASE WHEN A.MEASURE = 'DIO_PACK' THEN A.DIO - B.DIO
											   ELSE A.DIO END DIO_RESULT
								FROM #TMP_INVENTORY_DIO_CELLGROUP A
									 LEFT JOIN #TMP_INVENTORY_DIO_CELLGROUP B
									 ON 1=1
									 AND A.YYYYPW = B.YYYYPW
									 AND A.CELL_GROUP = B.CELL_GROUP
									 AND B.MEASURE = 'DIO_SALES'
								WHERE 1=1
								AND A.MEASURE = 'DIO_PACK'
							) B
				ON 1=1
				AND A.YYYYPW = B.YYYYPW
				AND A.CELL_GROUP = B.CELL_GROUP
				AND A.MEASURE = B.MEASURE
				AND A.MEASURE = 'DIO_PACK'
		WHERE 	1=1	;
		
		-- CELL_DIO = CELL_DIO - PACK_DIO - SALES_DIO
		UPDATE 	A
		SET 	A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
		FROM 	#TMP_INVENTORY_DIO_CELLGROUP A
				INNER JOIN (
								SELECT A.YYYYPW, A.CELL_GROUP, A.MEASURE
										, CASE WHEN A.MEASURE = 'DIO_CELL' THEN A.DIO - C.DIO - B.DIO
											   ELSE A.DIO END DIO_RESULT
								FROM #TMP_INVENTORY_DIO_CELLGROUP A
									 LEFT JOIN #TMP_INVENTORY_DIO_CELLGROUP B
									 ON 1=1
									 AND A.YYYYPW = B.YYYYPW
									 AND A.CELL_GROUP = B.CELL_GROUP
									 AND B.MEASURE = 'DIO_PACK'
									 LEFT JOIN #TMP_INVENTORY_DIO_CELLGROUP C
									 ON 1=1
									 AND A.YYYYPW = C.YYYYPW
									 AND A.CELL_GROUP = C.CELL_GROUP
									 AND C.MEASURE = 'DIO_SALES'
								WHERE 1=1
								AND A.MEASURE = 'DIO_CELL'
							) B
				ON 1=1
				AND A.YYYYPW = B.YYYYPW
				AND A.CELL_GROUP = B.CELL_GROUP
				AND A.MEASURE = B.MEASURE
				AND A.MEASURE = 'DIO_CELL'
		WHERE 	1=1	;
	
	-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DIO 계산 : 셀그룹별 DIO 산출(Detail 표준레포트)'	--@@@ 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_INVENTORY_DIO_DETAILREPORT') IS NOT NULL	
			DROP TABLE #TMP_INVENTORY_DIO_DETAILREPORT;

		SELECT I.YYYYPW
			  ,D.YYYYPW_SEQ
			  ,D.PW_DAYS
			  ,I.CELL_GROUP
			  ,I.CELL_GROUP_YN		-- 20240311 
			  ,I.OPERATION_GROUP
			  ,ISNULL(I.PRODUCT_LEVEL1,'-') AS PRODUCT_LEVEL1
			  ,ISNULL(I.PRODUCT_LEVEL2,'-') AS PRODUCT_LEVEL2
			  ,CL.MEASURE
			  ,I.QTY		AS INV_QTY
			  ,R.RTF_QTY	AS RTF_QTY
			  ,CASE WHEN I.QTY <= 0 THEN 
						 0
					WHEN R.CELL_GROUP IS NULL THEN 
						 365 
				    WHEN I.QTY - R.RTF_NEXT_1 < 0 THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), I.QTY)				    / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0)   * D.DAYS_NEXT_1  
					WHEN I.QTY - R.RTF_NEXT_1 = 0 THEN 
						 D.ACC_DAYS_1
					WHEN I.QTY - R.ACC_RTF_2 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_1)) / CASE WHEN R.RTF_NEXT_2 = 0  THEN NULL ELSE R.RTF_NEXT_2  END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
					WHEN I.QTY - R.ACC_RTF_2 = 0  THEN 
						 D.ACC_DAYS_2
					WHEN I.QTY - R.ACC_RTF_3 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_2)) / CASE WHEN R.RTF_NEXT_3 = 0  THEN NULL ELSE R.RTF_NEXT_3  END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
					WHEN I.QTY - R.ACC_RTF_3 = 0  THEN 
						 D.ACC_DAYS_3
					WHEN I.QTY - R.ACC_RTF_4 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_3)) / CASE WHEN R.RTF_NEXT_4 = 0  THEN NULL ELSE R.RTF_NEXT_4  END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
					WHEN I.QTY - R.ACC_RTF_4 = 0  THEN 
						 D.ACC_DAYS_4
					WHEN I.QTY - R.ACC_RTF_5 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_4)) / CASE WHEN R.RTF_NEXT_5 = 0  THEN NULL ELSE R.RTF_NEXT_5  END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
					WHEN I.QTY - R.ACC_RTF_5 = 0  THEN 
						 D.ACC_DAYS_5
					WHEN I.QTY - R.ACC_RTF_6 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_5)) / CASE WHEN R.RTF_NEXT_6 = 0  THEN NULL ELSE R.RTF_NEXT_6  END, 0) * D.DAYS_NEXT_6 + D.ACC_DAYS_5
					WHEN I.QTY - R.ACC_RTF_6 = 0  THEN 
						 D.ACC_DAYS_6
					WHEN I.QTY - R.ACC_RTF_7 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_6)) / CASE WHEN R.RTF_NEXT_7 = 0  THEN NULL ELSE R.RTF_NEXT_7  END, 0) * D.DAYS_NEXT_7 + D.ACC_DAYS_6
					WHEN I.QTY - R.ACC_RTF_7 = 0  THEN 
						 D.ACC_DAYS_7
					WHEN I.QTY - R.ACC_RTF_8 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_7)) / CASE WHEN R.RTF_NEXT_8 = 0  THEN NULL ELSE R.RTF_NEXT_8  END, 0) * D.DAYS_NEXT_8 + D.ACC_DAYS_7
					WHEN I.QTY - R.ACC_RTF_8 = 0  THEN 
						 D.ACC_DAYS_8
					WHEN I.QTY - R.ACC_RTF_9 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_8)) / CASE WHEN R.RTF_NEXT_9 = 0  THEN NULL ELSE R.RTF_NEXT_9  END, 0) * D.DAYS_NEXT_9 + D.ACC_DAYS_8
					WHEN I.QTY - R.ACC_RTF_9 = 0  THEN 
						 D.ACC_DAYS_9
					WHEN I.QTY - R.ACC_RTF_10 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_9)) / CASE WHEN R.RTF_NEXT_10 = 0  THEN NULL ELSE R.RTF_NEXT_10  END, 0) * D.DAYS_NEXT_10 + D.ACC_DAYS_9
					WHEN I.QTY - R.ACC_RTF_10 = 0  THEN 
						 D.ACC_DAYS_10
					WHEN I.QTY - R.ACC_RTF_11 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_10)) / CASE WHEN R.RTF_NEXT_11 = 0  THEN NULL ELSE R.RTF_NEXT_11  END, 0) * D.DAYS_NEXT_11 + D.ACC_DAYS_10
					WHEN I.QTY - R.ACC_RTF_11 = 0  THEN 
						 D.ACC_DAYS_11
					WHEN I.QTY - R.ACC_RTF_12 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_11)) / CASE WHEN R.RTF_NEXT_12 = 0  THEN NULL ELSE R.RTF_NEXT_12  END, 0) * D.DAYS_NEXT_12 + D.ACC_DAYS_11
					WHEN I.QTY - R.ACC_RTF_12 = 0  THEN 
						 D.ACC_DAYS_12
					ELSE 365
				END					AS DIO 
				, 'LV2' AS  ATTRIBUTE9

		  INTO #TMP_INVENTORY_DIO_DETAILREPORT
			FROM (
					SELECT *,  REPLACE(I.MEASURE,'INV_','') AS MEASURE_GROUP
					FROM #BASE_DATA_FOR_DIO_DETAILREPORT  I -- 재고 
					WHERE 1=1
					AND I.MEASURE LIKE 'INV%' -- 재고
					AND ISNULL(I.QTY,0) > 0 
				) I
				INNER JOIN (
					SELECT 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP UNION
					SELECT 'DIO_PACK' AS MEASURE, 'PACK' AS MEASURE_GROUP UNION
					SELECT 'DIO_CELL' AS MEASURE, 'CELL' AS MEASURE_GROUP 
				) CL
				ON 1=1
				AND CL.MEASURE_GROUP = I.MEASURE_GROUP
				INNER JOIN #TMP_WW_DAYS_INFO D
					ON D.YYYYPW			= I.YYYYPW
				INNER  JOIN (	-- LEFT OUTER JOIN 에서 INNER JOIN 으로 변경 - 수량이 빠지는 부분이 없어 속도 개선위해 변경함 빠지는 부분이 있으면 추가 로직으로 보충해야 함.
										SELECT R.*, REPLACE(R.MEASURE, 'RTF_','') AS  MEASURE_GROUP
										FROM #TMP_RTF_FOR_DIO_DETAILREPORT R	
					) R
						ON R.YYYYPW			= I.YYYYPW
						AND R.CELL_GROUP		= I.CELL_GROUP
						AND R.PRODUCT_LEVEL1	= I.PRODUCT_LEVEL1
						AND R.PRODUCT_LEVEL2	= I.PRODUCT_LEVEL2
						AND R.OPERATION_GROUP	= I.OPERATION_GROUP
						AND R.MEASURE_GROUP = I.MEASURE_GROUP
						;
		  /*
		  FROM #BASE_DATA_FOR_DIO_DETAILREPORT  I -- 재고 
			   INNER JOIN (
					select 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP UNION
					select 'DIO_PACK' AS MEASURE, 'PACK' AS MEASURE_GROUP UNION
					select 'DIO_CELL' AS MEASURE, 'CELL' AS MEASURE_GROUP 
				) CL
			  ON 1=1
			  AND CL.MEASURE_GROUP = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE)) 
			   INNER JOIN #TMP_WW_DAYS_INFO D
					  ON D.YYYYPW			= I.YYYYPW
			   LEFT JOIN #TMP_RTF_FOR_DIO_DETAILREPORT R
					  ON R.YYYYPW			= I.YYYYPW
					 AND R.CELL_GROUP		= I.CELL_GROUP
					 AND R.PRODUCT_LEVEL1	= I.PRODUCT_LEVEL1
					 AND R.PRODUCT_LEVEL2	= I.PRODUCT_LEVEL2
					 AND R.OPERATION_GROUP	= I.OPERATION_GROUP
					 AND SUBSTRING(R.MEASURE, CHARINDEX('_', R.MEASURE) + 1, LEN(R.MEASURE)) = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE)) 
		WHERE 1=1
		  AND I.MEASURE LIKE 'INV%' -- 재고
		  AND ISNULL(I.QTY,0) > 0 
		  */

		  ;
		
		-- PACK_DIO = PACK_DIO - SALES_DIO
		UPDATE 	A
		SET 	A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
		FROM 	#TMP_INVENTORY_DIO_DETAILREPORT A
				INNER JOIN (
								SELECT A.YYYYPW, A.CELL_GROUP, A.MEASURE, A.PRODUCT_LEVEL1, A.PRODUCT_LEVEL2
										, CASE WHEN A.MEASURE = 'DIO_PACK' THEN A.DIO - B.DIO
											   ELSE A.DIO END DIO_RESULT
								FROM #TMP_INVENTORY_DIO_DETAILREPORT A
									 LEFT JOIN #TMP_INVENTORY_DIO_DETAILREPORT B
									  ON 1=1
									 AND A.YYYYPW = B.YYYYPW
									 AND A.CELL_GROUP = B.CELL_GROUP
									 AND A.PRODUCT_LEVEL1	= B.PRODUCT_LEVEL1
					 				 AND A.PRODUCT_LEVEL2	= B.PRODUCT_LEVEL2
									 AND B.MEASURE = 'DIO_SALES'
								WHERE 1=1
								  AND A.MEASURE = 'DIO_PACK'
							) B
				 ON 1=1
				AND A.YYYYPW = B.YYYYPW
				AND A.CELL_GROUP = B.CELL_GROUP
				AND A.PRODUCT_LEVEL1 = B.PRODUCT_LEVEL1
				AND A.PRODUCT_LEVEL2 = B.PRODUCT_LEVEL2
				AND A.MEASURE = B.MEASURE
				AND A.MEASURE = 'DIO_PACK'
		WHERE 	1=1	;
		
		-- PRODUCT_LEVEL1 기준 DIO 산출
		INSERT INTO #TMP_INVENTORY_DIO_DETAILREPORT
		SELECT D.YYYYPW
			  ,D.YYYYPW_SEQ
			  ,D.PW_DAYS
			  ,I.CELL_GROUP
			  ,I.CELL_GROUP_YN		-- 20240311 
			  ,'C' AS OPERATION_GROUP	--I.OPERATION_GROUP operatoin 구분없이
			  ,ISNULL(I.PRODUCT_LEVEL1,'-') AS PRODUCT_LEVEL1
			  ,'DIO' AS PRODUCT_LEVEL2 
			  ,CL.MEASURE
			  ,I.QTY		AS INV_QTY
			  ,R.RTF_QTY	AS RTF_QTY
			  ,CASE WHEN I.QTY <= 0 THEN 
						 0
					WHEN R.CELL_GROUP IS NULL THEN 
						 365 
				    WHEN I.QTY - R.RTF_NEXT_1 < 0 THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), I.QTY)				    / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0)   * D.DAYS_NEXT_1  
					WHEN I.QTY - R.RTF_NEXT_1 = 0 THEN 
						 D.ACC_DAYS_1
					WHEN I.QTY - R.ACC_RTF_2 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_1)) / CASE WHEN R.RTF_NEXT_2 = 0  THEN NULL ELSE R.RTF_NEXT_2  END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
					WHEN I.QTY - R.ACC_RTF_2 = 0  THEN 
						 D.ACC_DAYS_2
					WHEN I.QTY - R.ACC_RTF_3 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_2)) / CASE WHEN R.RTF_NEXT_3 = 0  THEN NULL ELSE R.RTF_NEXT_3  END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
					WHEN I.QTY - R.ACC_RTF_3 = 0  THEN 
						 D.ACC_DAYS_3
					WHEN I.QTY - R.ACC_RTF_4 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_3)) / CASE WHEN R.RTF_NEXT_4 = 0  THEN NULL ELSE R.RTF_NEXT_4  END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
					WHEN I.QTY - R.ACC_RTF_4 = 0  THEN 
						 D.ACC_DAYS_4
					WHEN I.QTY - R.ACC_RTF_5 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_4)) / CASE WHEN R.RTF_NEXT_5 = 0  THEN NULL ELSE R.RTF_NEXT_5  END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
					WHEN I.QTY - R.ACC_RTF_5 = 0  THEN 
						 D.ACC_DAYS_5
					WHEN I.QTY - R.ACC_RTF_6 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_5)) / CASE WHEN R.RTF_NEXT_6 = 0  THEN NULL ELSE R.RTF_NEXT_6  END, 0) * D.DAYS_NEXT_6 + D.ACC_DAYS_5
					WHEN I.QTY - R.ACC_RTF_6 = 0  THEN 
						 D.ACC_DAYS_6
					WHEN I.QTY - R.ACC_RTF_7 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_6)) / CASE WHEN R.RTF_NEXT_7 = 0  THEN NULL ELSE R.RTF_NEXT_7  END, 0) * D.DAYS_NEXT_7 + D.ACC_DAYS_6
					WHEN I.QTY - R.ACC_RTF_7 = 0  THEN 
						 D.ACC_DAYS_7
					WHEN I.QTY - R.ACC_RTF_8 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_7)) / CASE WHEN R.RTF_NEXT_8 = 0  THEN NULL ELSE R.RTF_NEXT_8  END, 0) * D.DAYS_NEXT_8 + D.ACC_DAYS_7
					WHEN I.QTY - R.ACC_RTF_8 = 0  THEN 
						 D.ACC_DAYS_8
					WHEN I.QTY - R.ACC_RTF_9 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_8)) / CASE WHEN R.RTF_NEXT_9 = 0  THEN NULL ELSE R.RTF_NEXT_9  END, 0) * D.DAYS_NEXT_9 + D.ACC_DAYS_8
					WHEN I.QTY - R.ACC_RTF_9 = 0  THEN 
						 D.ACC_DAYS_9
					WHEN I.QTY - R.ACC_RTF_10 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_9)) / CASE WHEN R.RTF_NEXT_10 = 0  THEN NULL ELSE R.RTF_NEXT_10  END, 0) * D.DAYS_NEXT_10 + D.ACC_DAYS_9
					WHEN I.QTY - R.ACC_RTF_10 = 0  THEN 
						 D.ACC_DAYS_10
					WHEN I.QTY - R.ACC_RTF_11 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_10)) / CASE WHEN R.RTF_NEXT_11 = 0  THEN NULL ELSE R.RTF_NEXT_11  END, 0) * D.DAYS_NEXT_11 + D.ACC_DAYS_10
					WHEN I.QTY - R.ACC_RTF_11 = 0  THEN 
						 D.ACC_DAYS_11
					WHEN I.QTY - R.ACC_RTF_12 < 0  THEN 
						 ISNULL(CONVERT(NUMERIC(20,10), (I.QTY - R.ACC_RTF_11)) / CASE WHEN R.RTF_NEXT_12 = 0  THEN NULL ELSE R.RTF_NEXT_12  END, 0) * D.DAYS_NEXT_12 + D.ACC_DAYS_11
					WHEN I.QTY - R.ACC_RTF_12 = 0  THEN 
						 D.ACC_DAYS_12
					ELSE 365
				END					AS DIO 
				, 'LV1' AS  ATTRIBUTE9
		 
		  FROM (
					SELECT YYYYPW, YYYYPW_SEQ, PW_DAYS, CELL_GROUP, CELL_GROUP_YN	--, OPERATION_GROUP
							, PRODUCT_LEVEL1, MEASURE, REPLACE(MEASURE,'INV_','') AS MEASURE_GROUP
						  ,SUM(QTY) AS QTY
					FROM	#BASE_DATA_FOR_DIO_DETAILREPORT
					WHERE 1=1
					AND 	MEASURE LIKE 'INV%' -- 재고
		  			AND 	ISNULL(QTY,0) > 0
					GROUP BY YYYYPW, YYYYPW_SEQ, PW_DAYS, CELL_GROUP, CELL_GROUP_YN	--, OPERATION_GROUP
							, PRODUCT_LEVEL1, MEASURE, REPLACE(MEASURE,'INV_','')
				)I -- 재고 
			   INNER JOIN (
					select 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP UNION
					select 'DIO_PACK' AS MEASURE, 'PACK' AS MEASURE_GROUP	UNION
					select 'DIO_CELL' AS MEASURE, 'CELL' AS MEASURE_GROUP 
				) CL
			  ON 1=1
			 -- AND CL.MEASURE_GROUP = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE)) 
			  AND CL.MEASURE_GROUP = I.MEASURE_GROUP 
			   INNER JOIN #TMP_WW_DAYS_INFO D
					  ON D.YYYYPW			= I.YYYYPW
			   --LEFT JOIN (
			   INNER JOIN ( -- LEFT OUTER JOIN 에서 INNER JOIN 으로 변경 - 수량이 빠지는 부분이 없어 속도 개선위해 변경함 빠지는 부분이 있으면 추가 로직으로 보충해야 함.
							 SELECT YYYYPW, YYYYPW_SEQ, PW_DAYS, CELL_GROUP, CELL_GROUP_YN	--, OPERATION_GROUP
							 		, PRODUCT_LEVEL1, MEASURE, REPLACE(MEASURE,'RTF_','') AS MEASURE_GROUP
								   , SUM(RTF_QTY) AS RTF_QTY
								   , SUM(RTF_NEXT_1 ) AS RTF_NEXT_1, SUM(RTF_NEXT_2 ) AS RTF_NEXT_2 , SUM(RTF_NEXT_3 ) AS RTF_NEXT_3 , SUM(RTF_NEXT_4 ) AS RTF_NEXT_4 , SUM(RTF_NEXT_5 ) AS RTF_NEXT_5 , SUM(RTF_NEXT_6 ) AS RTF_NEXT_6 
								   , SUM(RTF_NEXT_7 ) AS RTF_NEXT_7 , SUM(RTF_NEXT_8 ) AS RTF_NEXT_8 , SUM(RTF_NEXT_9 ) AS RTF_NEXT_9 , SUM(RTF_NEXT_10) AS RTF_NEXT_10, SUM(RTF_NEXT_11) AS RTF_NEXT_11, SUM(RTF_NEXT_12) AS RTF_NEXT_12
								   , SUM(RTF_NEXT_13 ) AS RTF_NEXT_13 , SUM(RTF_NEXT_14 ) AS RTF_NEXT_14 , SUM(RTF_NEXT_15 ) AS RTF_NEXT_15 , SUM(RTF_NEXT_16) AS RTF_NEXT_16, SUM(RTF_NEXT_17) AS RTF_NEXT_17, SUM(RTF_NEXT_18) AS RTF_NEXT_18
								   , SUM(RTF_NEXT_19 ) AS RTF_NEXT_19 , SUM(RTF_NEXT_20 ) AS RTF_NEXT_20 , SUM(RTF_NEXT_21 ) AS RTF_NEXT_21 , SUM(RTF_NEXT_22) AS RTF_NEXT_22, SUM(RTF_NEXT_23) AS RTF_NEXT_23, SUM(RTF_NEXT_24) AS RTF_NEXT_24
								   , SUM(RTF_NEXT_25 ) AS RTF_NEXT_25 , SUM(RTF_NEXT_26 ) AS RTF_NEXT_26 , SUM(RTF_NEXT_27 ) AS RTF_NEXT_27 , SUM(RTF_NEXT_28) AS RTF_NEXT_28, SUM(RTF_NEXT_29) AS RTF_NEXT_29, SUM(RTF_NEXT_30) AS RTF_NEXT_30
								   , SUM(RTF_NEXT_31 ) AS RTF_NEXT_31 , SUM(RTF_NEXT_32 ) AS RTF_NEXT_32 , SUM(RTF_NEXT_33 ) AS RTF_NEXT_33 , SUM(RTF_NEXT_34) AS RTF_NEXT_34, SUM(RTF_NEXT_35) AS RTF_NEXT_35, SUM(RTF_NEXT_36) AS RTF_NEXT_36
								   , SUM(RTF_NEXT_37 ) AS RTF_NEXT_37 , SUM(RTF_NEXT_38 ) AS RTF_NEXT_38 , SUM(RTF_NEXT_39 ) AS RTF_NEXT_39 , SUM(RTF_NEXT_40) AS RTF_NEXT_40, SUM(RTF_NEXT_41) AS RTF_NEXT_41, SUM(RTF_NEXT_42) AS RTF_NEXT_42
								   , SUM(RTF_NEXT_43 ) AS RTF_NEXT_43 , SUM(RTF_NEXT_44 ) AS RTF_NEXT_44 , SUM(RTF_NEXT_45 ) AS RTF_NEXT_45 , SUM(RTF_NEXT_46) AS RTF_NEXT_46, SUM(RTF_NEXT_47) AS RTF_NEXT_47, SUM(RTF_NEXT_48) AS RTF_NEXT_48
								   , SUM(RTF_NEXT_49 ) AS RTF_NEXT_49 , SUM(RTF_NEXT_50 ) AS RTF_NEXT_50 , SUM(RTF_NEXT_51 ) AS RTF_NEXT_51 , SUM(RTF_NEXT_52) AS RTF_NEXT_52, SUM(RTF_NEXT_53) AS RTF_NEXT_53, SUM(RTF_NEXT_54) AS RTF_NEXT_54
								   , SUM(RTF_NEXT_55 ) AS RTF_NEXT_55 , SUM(RTF_NEXT_56 ) AS RTF_NEXT_56 , SUM(RTF_NEXT_57 ) AS RTF_NEXT_57 , SUM(RTF_NEXT_58) AS RTF_NEXT_58, SUM(RTF_NEXT_59) AS RTF_NEXT_59, SUM(RTF_NEXT_60) AS RTF_NEXT_60
								   , SUM(RTF_NEXT_61 ) AS RTF_NEXT_61 , SUM(RTF_NEXT_62 ) AS RTF_NEXT_62 , SUM(RTF_NEXT_63 ) AS RTF_NEXT_63
								   , SUM(ACC_RTF_1 ) AS ACC_RTF_1, SUM(ACC_RTF_2 ) AS ACC_RTF_2 , SUM(ACC_RTF_3 ) AS ACC_RTF_3 , SUM(ACC_RTF_4 ) AS ACC_RTF_4 , SUM(ACC_RTF_5 ) AS ACC_RTF_5 , SUM(ACC_RTF_6 ) AS ACC_RTF_6 
									, SUM(ACC_RTF_7 ) AS ACC_RTF_7 , SUM(ACC_RTF_8 ) AS ACC_RTF_8 , SUM(ACC_RTF_9 ) AS ACC_RTF_9 , SUM(ACC_RTF_10) AS ACC_RTF_10, SUM(ACC_RTF_11) AS ACC_RTF_11, SUM(ACC_RTF_12) AS ACC_RTF_12
									, SUM(ACC_RTF_13 ) AS ACC_RTF_13 , SUM(ACC_RTF_14 ) AS ACC_RTF_14 , SUM(ACC_RTF_15 ) AS ACC_RTF_15 , SUM(ACC_RTF_16) AS ACC_RTF_16, SUM(ACC_RTF_17) AS ACC_RTF_17, SUM(ACC_RTF_18) AS ACC_RTF_18
									, SUM(ACC_RTF_19 ) AS ACC_RTF_19 , SUM(ACC_RTF_20 ) AS ACC_RTF_20 , SUM(ACC_RTF_21 ) AS ACC_RTF_21 , SUM(ACC_RTF_22) AS ACC_RTF_22, SUM(ACC_RTF_23) AS ACC_RTF_23, SUM(ACC_RTF_24) AS ACC_RTF_24
									, SUM(ACC_RTF_25 ) AS ACC_RTF_25 , SUM(ACC_RTF_26 ) AS ACC_RTF_26 , SUM(ACC_RTF_27 ) AS ACC_RTF_27 , SUM(ACC_RTF_28) AS ACC_RTF_28, SUM(ACC_RTF_29) AS ACC_RTF_29, SUM(ACC_RTF_30) AS ACC_RTF_30
									, SUM(ACC_RTF_31 ) AS ACC_RTF_31 , SUM(ACC_RTF_32 ) AS ACC_RTF_32 , SUM(ACC_RTF_33 ) AS ACC_RTF_33 , SUM(ACC_RTF_34) AS ACC_RTF_34, SUM(ACC_RTF_35) AS ACC_RTF_35, SUM(ACC_RTF_36) AS ACC_RTF_36
									, SUM(ACC_RTF_37 ) AS ACC_RTF_37 , SUM(ACC_RTF_38 ) AS ACC_RTF_38 , SUM(ACC_RTF_39 ) AS ACC_RTF_39 , SUM(ACC_RTF_40) AS ACC_RTF_40, SUM(ACC_RTF_41) AS ACC_RTF_41, SUM(ACC_RTF_42) AS ACC_RTF_42
									, SUM(ACC_RTF_43 ) AS ACC_RTF_43 , SUM(ACC_RTF_44 ) AS ACC_RTF_44 , SUM(ACC_RTF_45 ) AS ACC_RTF_45 , SUM(ACC_RTF_46) AS ACC_RTF_46, SUM(ACC_RTF_47) AS ACC_RTF_47, SUM(ACC_RTF_48) AS ACC_RTF_48
									, SUM(ACC_RTF_49 ) AS ACC_RTF_49 , SUM(ACC_RTF_50 ) AS ACC_RTF_50 , SUM(ACC_RTF_51 ) AS ACC_RTF_51 , SUM(ACC_RTF_52) AS ACC_RTF_52, SUM(ACC_RTF_53) AS ACC_RTF_53, SUM(ACC_RTF_54) AS ACC_RTF_54
									, SUM(ACC_RTF_55 ) AS ACC_RTF_55 , SUM(ACC_RTF_56 ) AS ACC_RTF_56 , SUM(ACC_RTF_57 ) AS ACC_RTF_57 , SUM(ACC_RTF_58) AS ACC_RTF_58, SUM(ACC_RTF_59) AS ACC_RTF_59, SUM(ACC_RTF_60) AS ACC_RTF_60
									, SUM(ACC_RTF_61 ) AS ACC_RTF_61 , SUM(ACC_RTF_62 ) AS ACC_RTF_62 , SUM(ACC_RTF_63 ) AS ACC_RTF_63 
							  FROM #TMP_RTF_FOR_DIO_DETAILREPORT
							  GROUP BY YYYYPW, YYYYPW_SEQ, PW_DAYS, CELL_GROUP, CELL_GROUP_YN	--, OPERATION_GROUP
							  		, PRODUCT_LEVEL1, MEASURE, REPLACE(MEASURE,'RTF_','')
						) R
					  ON R.YYYYPW			= I.YYYYPW
					 AND R.CELL_GROUP		= I.CELL_GROUP
					 AND R.PRODUCT_LEVEL1	= I.PRODUCT_LEVEL1
					 --AND R.OPERATION_GROUP	= I.OPERATION_GROUP
					 AND R.MEASURE_GROUP = I.MEASURE_GROUP
					 --AND SUBSTRING(R.MEASURE, CHARINDEX('_', R.MEASURE) + 1, LEN(R.MEASURE)) = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE)) 
		WHERE 1=1
		  AND I.MEASURE LIKE 'INV%' -- 재고
		  AND ISNULL(I.QTY,0) > 0
		  ;


		-- PACK_DIO = PACK_DIO - SALES_DIO
		UPDATE 	A
		SET 	A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
		FROM 	#TMP_INVENTORY_DIO_DETAILREPORT A
				INNER JOIN (
								SELECT A.YYYYPW, A.CELL_GROUP, A.MEASURE, A.PRODUCT_LEVEL1
										, CASE WHEN A.MEASURE = 'DIO_PACK' THEN A.DIO - B.DIO
											   ELSE A.DIO END DIO_RESULT
								FROM #TMP_INVENTORY_DIO_DETAILREPORT A
									 LEFT JOIN #TMP_INVENTORY_DIO_DETAILREPORT B
									 ON 1=1
									 AND A.YYYYPW = B.YYYYPW
									 AND A.CELL_GROUP = B.CELL_GROUP
									 AND A.PRODUCT_LEVEL1	= B.PRODUCT_LEVEL1
									 AND B.MEASURE = 'DIO_SALES'
									 AND B.PRODUCT_LEVEL2 = 'DIO'
								WHERE 1=1
								AND A.MEASURE = 'DIO_PACK'
								AND A.PRODUCT_LEVEL2 = 'DIO'
							) B
				ON 1=1
				AND A.YYYYPW = B.YYYYPW
				AND A.CELL_GROUP = B.CELL_GROUP
				AND A.PRODUCT_LEVEL1	= B.PRODUCT_LEVEL1
				AND A.MEASURE = B.MEASURE
				AND A.MEASURE = 'DIO_PACK'
				AND A.PRODUCT_LEVEL2 = 'DIO'
		WHERE 	1=1	;
		

		-- CELL_DIO = CELL_DIO - PACK_DIO - SALES_DIO (LV2)
		UPDATE 	A
		SET 	A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
		FROM 	#TMP_INVENTORY_DIO_DETAILREPORT A
				INNER JOIN (
								SELECT A.YYYYPW, A.CELL_GROUP, A.MEASURE, A.PRODUCT_LEVEL1
										, CASE WHEN A.MEASURE = 'DIO_CELL' THEN A.DIO - C.DIO - B.DIO
											   ELSE A.DIO END DIO_RESULT
								FROM #TMP_INVENTORY_DIO_DETAILREPORT A
									 LEFT JOIN #TMP_INVENTORY_DIO_DETAILREPORT B
									 ON 1=1
									 AND A.YYYYPW = B.YYYYPW
									 AND A.CELL_GROUP = B.CELL_GROUP
									 AND A.PRODUCT_LEVEL1	= B.PRODUCT_LEVEL1
									 AND B.MEASURE = 'DIO_PACK'
									 AND B.PRODUCT_LEVEL2 = 'DIO'
									 LEFT JOIN #TMP_INVENTORY_DIO_DETAILREPORT C
									 ON 1=1
									 AND A.YYYYPW = C.YYYYPW
									 AND A.CELL_GROUP = C.CELL_GROUP
									 AND A.PRODUCT_LEVEL1	= C.PRODUCT_LEVEL1
									 AND C.MEASURE = 'DIO_SALES'
									 AND C.PRODUCT_LEVEL2 = 'DIO'
								WHERE 1=1
								AND A.MEASURE = 'DIO_CELL'
								AND A.PRODUCT_LEVEL2 != 'DIO'
							) B
				ON 1=1
				AND A.YYYYPW = B.YYYYPW
				AND A.CELL_GROUP = B.CELL_GROUP
				AND A.MEASURE = B.MEASURE
				AND A.PRODUCT_LEVEL1	= B.PRODUCT_LEVEL1
				AND A.MEASURE = 'DIO_CELL'
				AND A.PRODUCT_LEVEL2 != 'DIO'
		WHERE 	1=1	;
	
		-- CELL_DIO = CELL_DIO - PACK_DIO - SALES_DIO (LV1)
		UPDATE 	A
		SET 	A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
		FROM 	#TMP_INVENTORY_DIO_DETAILREPORT A
				INNER JOIN (
								SELECT A.YYYYPW, A.CELL_GROUP, A.MEASURE, A.PRODUCT_LEVEL1
										, CASE WHEN A.MEASURE = 'DIO_CELL' THEN A.DIO - C.DIO - B.DIO
											   ELSE A.DIO END DIO_RESULT
								FROM #TMP_INVENTORY_DIO_DETAILREPORT A
									 LEFT JOIN #TMP_INVENTORY_DIO_DETAILREPORT B
									 ON 1=1
									 AND A.YYYYPW = B.YYYYPW
									 AND A.CELL_GROUP = B.CELL_GROUP
									 AND A.PRODUCT_LEVEL1	= B.PRODUCT_LEVEL1
									 AND B.MEASURE = 'DIO_PACK'
									 AND B.PRODUCT_LEVEL2 = 'DIO'
									 LEFT JOIN #TMP_INVENTORY_DIO_DETAILREPORT C
									 ON 1=1
									 AND A.YYYYPW = C.YYYYPW
									 AND A.CELL_GROUP = C.CELL_GROUP
									 AND A.PRODUCT_LEVEL1	= C.PRODUCT_LEVEL1
									 AND C.MEASURE = 'DIO_SALES'
									 AND C.PRODUCT_LEVEL2 = 'DIO'
								WHERE 1=1
								AND A.MEASURE = 'DIO_CELL'
								AND A.PRODUCT_LEVEL2 = 'DIO'
							) B
				ON 1=1
				AND A.YYYYPW = B.YYYYPW
				AND A.CELL_GROUP = B.CELL_GROUP
				AND A.MEASURE = B.MEASURE
				AND A.PRODUCT_LEVEL1	= B.PRODUCT_LEVEL1
				AND A.MEASURE = 'DIO_CELL'
				AND A.PRODUCT_LEVEL2 = 'DIO'
		WHERE 	1=1	;
	
	------- End DIO 계산 ===============================================================================================================================


	----- Begin Tran : 월별 Global PSI 본테이블에 Delete/Insert===============================================================================================================================
	  BEGIN TRAN   --- transaction 시작  

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DELETE FROM SCP_RPT_GLOBAL_PSI_MD_WW  ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		DELETE TGT
		  FROM SCP_RPT_GLOBAL_PSI_MD_WW TGT WITH(NOLOCK) 
		 WHERE TGT.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
		   AND TGT.DIVISION_ID			= @V_DIVISION_ID
		;

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW  ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (
			 PLAN_START_YYYYMMDD
			,DIVISION_ID
			,YYYYPW
			,ITEM_ID
			,MEASURE
			,FROM_SITE
			,TO_SITE
			,INCOTERMS
			,VARIOUS_KEY
			,OPERATION_GROUP
			,REP_CELL_ITEM_ID
			,CELL_GROUP
			,QTY
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,CELL_CF
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE10 
		)
		SELECT  @V_PLAN_START_YYYYMMDD	AS	PLAN_START_YYYYMMDD
			   ,@V_DIVISION_ID			AS	DIVISION_ID 
			   ,GP.YYYYPW
			   ,CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' THEN MM.MODEL_ID	--@@@ P5200
					 WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'N' THEN GP.REP_CELL_ITEM_ID
					 ELSE GP.ITEM_ID
				END  AS ITEM_ID		-- 2024.01.26 AMDAU% 모듈 코드 셀로 치환 적재
			   ,CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'Y' THEN 'PACK_EOH'		--@@@ P5200
					 WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'N' THEN 'PACK_CELL_EOH'
					 ELSE GP.MEASURE
				END  AS MEASURE 
			   ,GP.FROM_SITE
			   ,GP.TO_SITE
			   ,GP.INCOTERMS
			   ,GP.VARIOUS_KEY
			   ,CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'N'
					 THEN 'A'
					 ELSE GP.OPERATION_GROUP
				END  AS OPERATION_GROUP
			   ,MAX(GP.REP_CELL_ITEM_ID)  AS REP_CELL_ITEM_ID -- 2025.05.28 kimcd primary key 오류 처리
			   ,MAX(GP.CELL_GROUP)        AS CELL_GROUP       -- 2025.05.28 kimcd primary key 오류 처리
			    --Pack Item 으로 변경되더라도 Cell 환산해 준다.
			  /*
			   ,SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.QTY
						 ELSE GP.QTY
					END)  AS QTY
			   ,SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.FROM_BOH_QTY
						 ELSE GP.FROM_BOH_QTY
					END)  AS FROM_BOH_QTY
			   ,SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.TO_BOH_QTY
						 ELSE GP.TO_BOH_QTY
					END)  AS TO_BOH_QTY
			*/
			 ,SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.QTY	--@@@ P5200
						 WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.QTY
						 ELSE GP.QTY
					END)  AS QTY
			   ,SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.FROM_BOH_QTY	--@@@ P5200
						 WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.FROM_BOH_QTY
						 ELSE GP.FROM_BOH_QTY
					END)  AS FROM_BOH_QTY
			   ,SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.TO_BOH_QTY	--@@@ P5200
						 WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.TO_BOH_QTY
						 ELSE GP.TO_BOH_QTY
					END)  AS TO_BOH_QTY
				
			   ,MAX(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.CELL_CF
					     WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN 1
					     ELSE GP.CELL_CF
				    END) AS CELL_CF  -- 2025.05.28 kimcd primary key 오류 처리
			   ,@v_batch_user	AS	CREATED_BY
			   , GETDATE()		AS	CREATION_DATE
			   ,@v_batch_user	AS	LAST_UPDATED_BY
			   , GETDATE()		AS	LAST_UPDATE_DATE
			   ,MAX(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN CONVERT(NVARCHAR(150), GP.QTY)		ELSE NULL END)  AS ATTRIBUTE1
			   ,MAX(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN CONVERT(NVARCHAR(150), GP.CELL_CF)	ELSE NULL END)  AS ATTRIBUTE2
			   ,MAX( CASE WHEN FI.FLOW_ID IN ('A9000','A3000') THEN ISNULL(FI.CELL_MODEL_ID, GP.ITEM_ID) ELSE ISNULL(MM.MODEL_ID, GP.ITEM_ID) END )	AS ATTRIBUTE3			
			   ,MAX(GP.CELL_GROUP_YN)																			AS ATTRIBUTE10 -- 20240311 
		 FROM #SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK) 
			  LEFT JOIN #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
					 ON MM.MODULE_ID = GP.ITEM_ID
			  LEFT JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)  -- AA~ Assy item 의 Group Code Mapping 이 안되어 추가
					 ON FI.ITEM_ID = GP.ITEM_ID
		WHERE 1=1
		  AND MEASURE != 'ENDING_INV_FOR_DIO'
		GROUP BY GP.YYYYPW
			   ,CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' THEN MM.MODEL_ID	--@@@ P5200
					 WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'N' THEN GP.REP_CELL_ITEM_ID
					 ELSE GP.ITEM_ID
				END  
			   ,CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'Y' THEN 'PACK_EOH'	--@@@ P5200
					 WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'N' THEN 'PACK_CELL_EOH'
					 ELSE GP.MEASURE
				END  
			   ,GP.FROM_SITE
			   ,GP.TO_SITE
			   ,GP.INCOTERMS
			   ,GP.VARIOUS_KEY
			   ,CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'N'
					 THEN 'A'
					 ELSE GP.OPERATION_GROUP
				END
			   --,GP.REP_CELL_ITEM_ID -- 2025.05.28 kimcd primary key 오류 처리
			   --,GP.CELL_GROUP       -- 2025.05.28 kimcd primary key 오류 처리
			   --,CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.CELL_CF
				--	 WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN 1
				--	 ELSE GP.CELL_CF
				--END   -- 2025.05.28 kimcd primary key 오류 처리
		
		INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (
			 PLAN_START_YYYYMMDD
			,DIVISION_ID
			,YYYYPW
			,ITEM_ID
			,MEASURE
			,FROM_SITE
			,TO_SITE
			,INCOTERMS
			,VARIOUS_KEY
			,OPERATION_GROUP
			,REP_CELL_ITEM_ID
			,CELL_GROUP
			,QTY
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,CELL_CF
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE10 
		)
		SELECT	MM.PLAN_START_YYYYMMDD, MM.DIVISION_ID, MM.YYYYPW
				, MM.CELL_GROUP		AS ITEM_ID
				, 'TOT_INV' 		AS MEASURE
				,'-'				AS FROM_SITE
				,'-'				AS TO_SITE
				,'-'				AS INCOTERMS
				,'-'				AS VARIOUS_KEY
				,'-'				AS OPERATION_GROUP
			    ,'-'				AS REP_CELL_ITEM_ID
				, MM.CELL_GROUP
				, SUM(CASE WHEN MM.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH','AS_INV') THEN MM.QTY * MM.CELL_CF ELSE MM.QTY END) 			AS QTY
				,0					AS FROM_BOH_QTY
				,0					AS TO_BOH_QTY
				,1.0				AS CELL_CF
				,@v_batch_user		AS	CREATED_BY
			    , GETDATE()			AS	CREATION_DATE
			    ,@v_batch_user		AS	LAST_UPDATED_BY
			    , GETDATE()			AS	LAST_UPDATE_DATE
			    ,'Y'				AS ATTRIBUTE10 
		 FROM	SCP_RPT_GLOBAL_PSI_MD_WW MM WITH(NOLOCK)
		WHERE	1=1
		  AND   MM.PLAN_START_YYYYMMDD 	= @V_PLAN_START_YYYYMMDD
		  AND 	MM.DIVISION_ID			= @V_DIVISION_ID
		  AND	MM.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH', 'PACK_CELL_EOH', 'SEMI_INTRANSIT', 'CELL_EOH', 'CELL_CHAR_AVAILABLE', 'CELL_FORM_PROGRESS', 'AS_INV')
		GROUP BY MM.PLAN_START_YYYYMMDD, MM.DIVISION_ID, MM.YYYYPW, MM.CELL_GROUP
		;
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (DIO) ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (
			 PLAN_START_YYYYMMDD
			,DIVISION_ID
			,YYYYPW
			,ITEM_ID
			,MEASURE
			,FROM_SITE
			,TO_SITE
			,INCOTERMS
			,VARIOUS_KEY
			,OPERATION_GROUP
			,REP_CELL_ITEM_ID
			,CELL_GROUP
			,QTY
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,CELL_CF
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE10 
		)
		SELECT  @V_PLAN_START_YYYYMMDD	AS	PLAN_START_YYYYMMDD
			   ,@V_DIVISION_ID			AS	DIVISION_ID
			   ,DO.YYYYPW
			   ,DO.CELL_GROUP	AS ITEM_ID
			   ,'DIO'			AS MEASURE
			   ,'-'				AS FROM_SITE
			   ,'-'				AS TO_SITE
			 ,'-'				AS INCOTERMS
			   ,'-'				AS VARIOUS_KEY
			   ,DO.OPERATION_GROUP
			   ,'-'				AS REP_CELL_ITEM_ID
			   ,DO.CELL_GROUP	
			   ,CASE WHEN DO.DIO > 365 
				     THEN 365 
					 ELSE DO.DIO 
				END 			AS QTY
			   ,0.0				AS FROM_BOH_QTY
			   ,0.0				AS TO_BOH_QTY
			   ,1.0				AS CELL_CF
			   ,@v_batch_user	AS	CREATED_BY
			   , GETDATE()		AS	CREATION_DATE
			   ,@v_batch_user	AS	LAST_UPDATED_BY
			   , GETDATE()		AS	LAST_UPDATE_DATE
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.INV_QTY,0.0))	AS ATTRIBUTE1  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.RTF_QTY,0.0))	AS ATTRIBUTE2  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.PW_DAYS,0.0))	AS ATTRIBUTE3
			   ,CELL_GROUP_YN									AS ATTRIBUTE10 
		 FROM #TMP_INVENTORY_DIO DO WITH(NOLOCK) 
		WHERE 1=1
		
		-- Standard DIO 추가(임시)
		INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (
			 PLAN_START_YYYYMMDD
			,DIVISION_ID
			,YYYYPW
			,ITEM_ID
			,MEASURE
			,FROM_SITE
			,TO_SITE
			,INCOTERMS
			,VARIOUS_KEY
			,OPERATION_GROUP
			,REP_CELL_ITEM_ID
			,CELL_GROUP
			,QTY
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,CELL_CF
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE10
		)
		SELECT  @V_PLAN_START_YYYYMMDD	AS	PLAN_START_YYYYMMDD
			   ,@V_DIVISION_ID			AS	DIVISION_ID 
			   ,DO.YYYYPW
			   ,DO.CELL_GROUP	AS ITEM_ID
			   ,'STD_DIO'			AS MEASURE
			   ,'-'				AS FROM_SITE
			   ,'-'				AS TO_SITE
			   ,'-'				AS INCOTERMS
			   ,'-'				AS VARIOUS_KEY
			   ,DO.OPERATION_GROUP
			   ,'-'				AS REP_CELL_ITEM_ID
			   ,DO.CELL_GROUP	
			   ,CASE WHEN DO.DIO > 365 
				     THEN 365 
					 ELSE DO.DIO 
				END 			AS QTY
			   ,0.0				AS FROM_BOH_QTY
			   ,0.0				AS TO_BOH_QTY
			   ,1.0				AS CELL_CF
			   ,@v_batch_user	AS	CREATED_BY
			   , GETDATE()		AS	CREATION_DATE
			   ,@v_batch_user	AS	LAST_UPDATED_BY
			   , GETDATE()		AS	LAST_UPDATE_DATE
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.INV_QTY,0.0))	AS ATTRIBUTE1  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.RTF_QTY,0.0))	AS ATTRIBUTE2  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.PW_DAYS,0.0))	AS ATTRIBUTE3
			   ,DO.CELL_GROUP_YN								AS ATTRIBUTE10 
		 FROM #TMP_INVENTORY_DIO DO WITH(NOLOCK) 
		WHERE 1=1
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (DIO)(표준레포트) '	--@@@ 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (
			 PLAN_START_YYYYMMDD
			,DIVISION_ID
			,YYYYPW
			,ITEM_ID
			,MEASURE
			,FROM_SITE
			,TO_SITE
			,INCOTERMS
			,VARIOUS_KEY
			,OPERATION_GROUP
			,REP_CELL_ITEM_ID
			,CELL_GROUP
			,QTY
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,CELL_CF
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE10 
		)
		SELECT  @V_PLAN_START_YYYYMMDD	AS	PLAN_START_YYYYMMDD
			   ,@V_DIVISION_ID			AS	DIVISION_ID
			   ,DO.YYYYPW
			   ,DO.CELL_GROUP	AS ITEM_ID
			   ,DO.MEASURE		AS MEASURE
			   ,'-'				AS FROM_SITE
			   ,'-'				AS TO_SITE
			   ,'-'				AS INCOTERMS
			   ,'-'				AS VARIOUS_KEY
			   ,DO.OPERATION_GROUP
			   ,'-'				AS REP_CELL_ITEM_ID
			   ,DO.CELL_GROUP	
			   ,CASE WHEN ISNULL(DO.DIO,0) > 365 
				     THEN 365 
					 ELSE ISNULL(DO.DIO,0) 
				END 			AS QTY
			   ,0.0				AS FROM_BOH_QTY
			   ,0.0				AS TO_BOH_QTY
			   ,1.0				AS CELL_CF
			   ,@v_batch_user	AS	CREATED_BY
			   , GETDATE()		AS	CREATION_DATE
			   ,@v_batch_user	AS	LAST_UPDATED_BY
			   , GETDATE()		AS	LAST_UPDATE_DATE
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.INV_QTY,0.0))	AS ATTRIBUTE1  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.RTF_QTY,0.0))	AS ATTRIBUTE2  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.PW_DAYS,0.0))	AS ATTRIBUTE3
			   ,CELL_GROUP_YN									AS ATTRIBUTE10 
		 FROM #TMP_INVENTORY_DIO_CELLGROUP DO WITH(NOLOCK) 
		WHERE 1=1
		
		-- Standard DIO 추가(임시)
		INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (
			 PLAN_START_YYYYMMDD
			,DIVISION_ID
			,YYYYPW
			,ITEM_ID
			,MEASURE
			,FROM_SITE
			,TO_SITE
			,INCOTERMS
			,VARIOUS_KEY
			,OPERATION_GROUP
			,REP_CELL_ITEM_ID
			,CELL_GROUP
			,QTY
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,CELL_CF
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE10
		)
		SELECT  @V_PLAN_START_YYYYMMDD	AS	PLAN_START_YYYYMMDD
			   ,@V_DIVISION_ID			AS	DIVISION_ID 
			   ,DO.YYYYPW
			   ,DO.CELL_GROUP	AS ITEM_ID
			   ,'STD_'+DO.MEASURE		AS MEASURE
			   ,'-'				AS FROM_SITE
			   ,'-'				AS TO_SITE
			   ,'-'				AS INCOTERMS
			   ,'-'				AS VARIOUS_KEY
			   ,DO.OPERATION_GROUP
			   ,'-'				AS REP_CELL_ITEM_ID
			   ,DO.CELL_GROUP	
			   ,CASE WHEN ISNULL(DO.DIO,0) > 365 
				     THEN 365 
					 ELSE ISNULL(DO.DIO,0) 
				END 			AS QTY
			   ,0.0				AS FROM_BOH_QTY
			   ,0.0				AS TO_BOH_QTY
			   ,1.0				AS CELL_CF
			   ,@v_batch_user	AS	CREATED_BY
			   , GETDATE()		AS	CREATION_DATE
			   ,@v_batch_user	AS	LAST_UPDATED_BY
			   , GETDATE()		AS	LAST_UPDATE_DATE
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.INV_QTY,0.0))	AS ATTRIBUTE1  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.RTF_QTY,0.0))	AS ATTRIBUTE2  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.PW_DAYS,0.0))	AS ATTRIBUTE3
			   ,DO.CELL_GROUP_YN								AS ATTRIBUTE10 
		 FROM #TMP_INVENTORY_DIO_CELLGROUP DO WITH(NOLOCK) 
		WHERE 1=1
		
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW (DIO) (Detail 표준레포트) '	--@@@ 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		
		DELETE TGT
		 FROM SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW TGT WITH(NOLOCK) 
		WHERE TGT.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		  AND TGT.DIVISION_ID			= @V_DIVISION_ID
		;
	
		INSERT INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW (
			 PLAN_START_YYYYMMDD
			,DIVISION_ID
			,YYYYPW
			,ITEM_ID
			,MEASURE
			,FROM_SITE
			,TO_SITE
			,INCOTERMS
			,VARIOUS_KEY
			,OPERATION_GROUP
			,REP_CELL_ITEM_ID
			,CELL_GROUP
			,PRODUCT_LEVEL1
			,PRODUCT_LEVEL2
			,PRODUCT_LEVEL3
			,QTY
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,CELL_CF
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE10
			,ATTRIBUTE9
		)
		SELECT  @V_PLAN_START_YYYYMMDD	AS	PLAN_START_YYYYMMDD
			   ,@V_DIVISION_ID			AS	DIVISION_ID 
			   ,DO.YYYYPW
			   ,DO.CELL_GROUP	AS ITEM_ID
			   ,DO.MEASURE		AS MEASURE
			   ,'-'				AS FROM_SITE
			   ,'-'				AS TO_SITE
			   ,'-'				AS INCOTERMS
			   ,'-'				AS VARIOUS_KEY
			   ,CASE WHEN ATTRIBUTE9 = 'LV1' THEN  ( CASE WHEN REPLACE(DO.MEASURE,'DIO_','') = 'SALES' THEN 'Sales' +' DIO' 
			   											  WHEN REPLACE(DO.MEASURE,'DIO_','') = 'PACK' THEN 'Pack' +' DIO'
			   											  WHEN REPLACE(DO.MEASURE,'DIO_','') = 'CELL' THEN 'Cell' +' DIO' END )
			   		 ELSE DO.OPERATION_GROUP END OPERATION_GROUP
			   ,'-'				AS REP_CELL_ITEM_ID
			   ,DO.CELL_GROUP	
			   ,DO.PRODUCT_LEVEL1
			   ,DO.PRODUCT_LEVEL2
			   ,'-'
			   ,CASE WHEN ISNULL(DO.DIO,0) > 365 
				     THEN 365 
					 ELSE ISNULL(DO.DIO,0) 
				END 			AS QTY
			   ,0.0				AS FROM_BOH_QTY
			   ,0.0				AS TO_BOH_QTY
			   ,1.0				AS CELL_CF
			   ,@v_batch_user	AS	CREATED_BY
			   , GETDATE()		AS	CREATION_DATE
			   ,@v_batch_user	AS	LAST_UPDATED_BY
			   , GETDATE()		AS	LAST_UPDATE_DATE
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.INV_QTY,0.0))	AS ATTRIBUTE1  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.RTF_QTY,0.0))	AS ATTRIBUTE2  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.PW_DAYS,0.0))	AS ATTRIBUTE3
			   ,DO.CELL_GROUP_YN								AS ATTRIBUTE10 
			   ,ATTRIBUTE9
		 FROM #TMP_INVENTORY_DIO_DETAILREPORT DO WITH(NOLOCK) 
		WHERE 1=1
		AND DO.PRODUCT_LEVEL1 <> '-'
		 -- AND DO.PRODUCT_LEVEL2 != 'DIO'
			;
		
		-- Standard DIO 추가(임시)
		INSERT INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW (
			 PLAN_START_YYYYMMDD
			,DIVISION_ID
			,YYYYPW
			,ITEM_ID
			,MEASURE
			,FROM_SITE
			,TO_SITE
			,INCOTERMS
			,VARIOUS_KEY
			,OPERATION_GROUP
			,REP_CELL_ITEM_ID
			,CELL_GROUP
			,PRODUCT_LEVEL1
			,PRODUCT_LEVEL2
			,PRODUCT_LEVEL3
			,QTY
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,CELL_CF
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE10
			,ATTRIBUTE9
		)
		SELECT  @V_PLAN_START_YYYYMMDD	AS	PLAN_START_YYYYMMDD
			   ,@V_DIVISION_ID			AS	DIVISION_ID 
			   ,DO.YYYYPW
			   ,DO.CELL_GROUP	AS ITEM_ID
			   ,'STD_'+DO.MEASURE		AS MEASURE
			   ,'-'				AS FROM_SITE
			   ,'-'				AS TO_SITE
			   ,'-'				AS INCOTERMS
			   ,'-'				AS VARIOUS_KEY
			   ,CASE WHEN ATTRIBUTE9 = 'LV1' THEN  ( CASE WHEN REPLACE(DO.MEASURE,'DIO_','') = 'SALES' THEN 'Sales' +' DIO' 
			   											  WHEN REPLACE(DO.MEASURE,'DIO_','') = 'PACK' THEN 'Pack' +' DIO'
			   											  WHEN REPLACE(DO.MEASURE,'DIO_','') = 'CELL' THEN 'Cell' +' DIO' END )
			   		 ELSE DO.OPERATION_GROUP END OPERATION_GROUP
			   ,'-'				AS REP_CELL_ITEM_ID
			   ,DO.CELL_GROUP	
			   ,DO.PRODUCT_LEVEL1
			   ,DO.PRODUCT_LEVEL2
			   ,'-'
			   ,CASE WHEN ISNULL(DO.DIO,0) > 365 
				     THEN 365 
					 ELSE ISNULL(DO.DIO,0) 
				END 			AS QTY
			   ,0.0				AS FROM_BOH_QTY
			   ,0.0				AS TO_BOH_QTY
			   ,1.0				AS CELL_CF
			   ,@v_batch_user	AS	CREATED_BY
			   , GETDATE()		AS	CREATION_DATE
			   ,@v_batch_user	AS	LAST_UPDATED_BY
			   , GETDATE()		AS	LAST_UPDATE_DATE
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.INV_QTY,0.0))	AS ATTRIBUTE1  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.RTF_QTY,0.0))	AS ATTRIBUTE2  
			   ,CONVERT(NVARCHAR(300), ISNULL(DO.PW_DAYS,0.0))	AS ATTRIBUTE3
			   ,DO.CELL_GROUP_YN								AS ATTRIBUTE10 
			   ,ATTRIBUTE9
		 FROM #TMP_INVENTORY_DIO_DETAILREPORT DO WITH(NOLOCK) 
		WHERE 1=1
		AND DO.PRODUCT_LEVEL1 <> '-'
		;
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_MM (FP Aging Stock : Form Progress ) ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (
			 PLAN_START_YYYYMMDD
			,DIVISION_ID
			,YYYYPW
			,ITEM_ID
			,MEASURE
			,FROM_SITE
			,TO_SITE
			,INCOTERMS
			,VARIOUS_KEY
			,OPERATION_GROUP
			,REP_CELL_ITEM_ID
			,CELL_GROUP
			,QTY
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,CELL_CF
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
		)
		SELECT '00000000'									AS PLAN_START_YYYYMMDD
			  ,@V_DIVISION_ID								AS DIVISION_ID
			  ,SA.YYYYPW	
			  ,SA.ITEM_ID
			  ,'FORM_PROGRESS'								AS MEASURE
			  ,SA.FROM_SITE
			  ,'-'											AS TO_SITE
			  ,'-'											AS INCOTERMS
			  ,CONVERT(NVARCHAR(8), SA.CUTOFF_DATE, 112)    AS VARIOUS_KEY
			  ,'-'											AS OPERATION_GROUP
			  ,'-'											AS REP_CELL_ITEM_ID
			  ,'-'											AS CELL_GROUP
			  ,SA.FP_FORM_PROGRESS							AS QTY
			  ,0											AS FROM_BOH_QTY
			  ,0											AS TO_BOH_QTY
			  ,0											AS CELL_CF
			  ,'scm_batch'									AS CREATED_BY
			  ,GETDATE()									AS CREATION_DATE
			  ,'scm_batch'									AS LAST_UPDATED_BY
			  ,GETDATE()									AS LAST_UPDATE_DATE
			  ,CONVERT(NVARCHAR(50), SA.FP_CHAR_AVAILABLE)	AS ATTRIBUTE1
			  ,CONVERT(NVARCHAR(50), SA.FP_AGING_TOTAL)		AS ATTRIBUTE2
		 FROM #FP_AGING_STOCK SA WITH(NOLOCK)
		WHERE 1=1
		  AND DIV = 'A'
		  AND NOT EXISTS (SELECT TOP 10 * 
						   FROM SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK)
						  WHERE 1=1
						    AND GP.PLAN_START_YYYYMMDD = '00000000'
							AND GP.DIVISION_ID		   = @V_DIVISION_ID
							AND GP.YYYYPW			   = SA.YYYYPW
							AND GP.FROM_SITE		   = SA.FROM_SITE
							AND GP.ITEM_ID			   = SA.ITEM_ID
							AND GP.MEASURE			   = 'FORM_PROGRESS'
							)
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### SORT ORDER 조정 ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------							
		
		UPDATE	SCP_RPT_GLOBAL_PSI_MD_WW
		SET		ATTRIBUTE8 = NULL
		WHERE	1=1
		 AND	PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
		  AND 	DIVISION_ID			= @V_DIVISION_ID


		UPDATE	SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW
		SET		ATTRIBUTE8 = NULL
		WHERE	1=1
		  AND   PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
		  AND 	DIVISION_ID			= @V_DIVISION_ID


		-- ORDER BY 추가
		UPDATE	A
		SET		A.ATTRIBUTE8 = B.RNK
		FROM	SCP_RPT_GLOBAL_PSI_MD_WW A
				INNER JOIN(
							SELECT DENSE_RANK() OVER(	PARTITION BY PLAN_START_YYYYMMDD, DIVISION_ID
														ORDER BY SUM_QTY DESC, CELL_GROUP 
													) AS RNK,
								   PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP
							FROM	(
										SELECT  PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP, SUM(QTY) AS SUM_QTY
										FROM SCP_RPT_GLOBAL_PSI_MD_WW MM WITH(NOLOCK)
										WHERE	1=1
										  AND   MM.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
										  AND 	MM.DIVISION_ID			= @V_DIVISION_ID
										  AND 	MM.MEASURE 				= 'TOT_INV'
										  AND	MM.YYYYPW 				= @V_RESULT_LAST_YYYYPW
										GROUP BY PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP
										UNION ALL
										SELECT  DISTINCT PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP, 0 AS SUM_QTY
										FROM	SCP_RPT_GLOBAL_PSI_MD_WW MM WITH(NOLOCK)
										WHERE	1=1
										  AND   MM.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
										  AND 	MM.DIVISION_ID			= @V_DIVISION_ID
										  AND 	MM.MEASURE 				= 'TOT_INV'
										  AND 	NOT EXISTS (
																SELECT DISTINCT DIVISION_ID, CELL_GROUP
																FROM SCP_RPT_GLOBAL_PSI_MD_WW XX WITH(NOLOCK)
																WHERE	1=1
																AND XX.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
																AND XX.DIVISION_ID			= @V_DIVISION_ID
																AND XX.MEASURE 				= 'TOT_INV'
																AND	XX.YYYYPW 				= @V_RESULT_LAST_YYYYPW
																AND XX.DIVISION_ID 			= MM.DIVISION_ID
																AND XX.CELL_GROUP 			= MM.CELL_GROUP
															)
									) B
						) B
				 ON 1=1
				AND  A.PLAN_START_YYYYMMDD 	= B.PLAN_START_YYYYMMDD
				AND  A.DIVISION_ID 			= B.DIVISION_ID
				AND  A.CELL_GROUP 			= B.CELL_GROUP
		WHERE 1=1
		;
		
		-- ORDER BY 추가
		UPDATE	A
		SET		A.ATTRIBUTE8 = B.RNK
		FROM	SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW A
				INNER JOIN(
							SELECT DENSE_RANK() OVER(	PARTITION BY PLAN_START_YYYYMMDD, DIVISION_ID
														ORDER BY SUM_QTY DESC, CELL_GROUP 
													) AS RNK,
								   PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP
							FROM	(
										SELECT  PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP, SUM(QTY) AS SUM_QTY
										FROM SCP_RPT_GLOBAL_PSI_MD_WW MM WITH(NOLOCK)
										WHERE	1=1
										  AND   MM.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
										  AND 	MM.DIVISION_ID			= @V_DIVISION_ID
										  AND 	MM.MEASURE 				= 'TOT_INV'
										  AND	MM.YYYYPW 				= @V_RESULT_LAST_YYYYPW
										GROUP BY PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP
										UNION ALL
										SELECT  DISTINCT PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP, 0 AS SUM_QTY
										FROM	SCP_RPT_GLOBAL_PSI_MD_WW MM WITH(NOLOCK)
										WHERE	1=1
										  AND   MM.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
										  AND 	MM.DIVISION_ID			= @V_DIVISION_ID
										  AND 	MM.MEASURE 				= 'TOT_INV'
										  AND 	NOT EXISTS (
																SELECT DISTINCT DIVISION_ID, CELL_GROUP
																FROM SCP_RPT_GLOBAL_PSI_MD_WW XX WITH(NOLOCK)
																WHERE	1=1
																AND XX.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
																AND XX.DIVISION_ID			= @V_DIVISION_ID
																AND XX.MEASURE 				= 'TOT_INV'
																AND	XX.YYYYPW 				= @V_RESULT_LAST_YYYYPW
																AND XX.DIVISION_ID 			= MM.DIVISION_ID
																AND XX.CELL_GROUP 			= MM.CELL_GROUP
															)
									) B
						) B
				 ON 1=1
				AND  A.PLAN_START_YYYYMMDD 	= B.PLAN_START_YYYYMMDD
				AND  A.DIVISION_ID 			= B.DIVISION_ID
				AND  A.CELL_GROUP 			= B.CELL_GROUP
		WHERE 1=1
		;
		

		DECLARE @V_INV_SEQ		INT			= 0;
		
		SELECT  @V_INV_SEQ = MAX(CONVERT(INT, ATTRIBUTE8))
		FROM SCP_RPT_GLOBAL_PSI_MD_WW MM WITH(NOLOCK)
		WHERE	1=1
		  AND   MM.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
		  AND 	MM.DIVISION_ID			= @V_DIVISION_ID
		  AND 	MM.MEASURE 				= 'TOT_INV'
		
		
		-- ORDER BY 추가
		UPDATE	A
		SET		A.ATTRIBUTE8 = ISNULL(CONVERT(INT, B.RNK) + ISNULL(@V_INV_SEQ,0),99)
		FROM	SCP_RPT_GLOBAL_PSI_MD_WW A
				INNER JOIN(
							SELECT DENSE_RANK() OVER(	PARTITION BY PLAN_START_YYYYMMDD, DIVISION_ID
														ORDER BY SUM_QTY DESC, CELL_GROUP 
													) AS RNK,
								   PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP
							FROM	(
										SELECT  PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP, SUM(QTY) AS SUM_QTY
										FROM SCP_RPT_GLOBAL_PSI_MD_WW MM WITH(NOLOCK)
										WHERE	1=1
										  AND   MM.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
										  AND 	MM.DIVISION_ID			= @V_DIVISION_ID
										  AND 	MM.MEASURE 				= 'TOT_INV'
										  --AND	MM.YYYYPW 				= @V_RESULT_LAST_YYYYPW
										  AND   MM.ATTRIBUTE8 IS NULL
										GROUP BY PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP
									) B
						) B
				 ON 1=1
				AND  A.PLAN_START_YYYYMMDD 	= B.PLAN_START_YYYYMMDD
				AND  A.DIVISION_ID 			= B.DIVISION_ID
				AND  A.CELL_GROUP 			= B.CELL_GROUP
				AND  A.ATTRIBUTE8 IS NULL
		WHERE 1=1
		;
		
		-- ORDER BY 추가
		UPDATE	A
		SET		A.ATTRIBUTE8 = ISNULL(CONVERT(INT, B.RNK) + ISNULL(@V_INV_SEQ,0),99)
		FROM	SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW A
				INNER JOIN(
							SELECT DENSE_RANK() OVER(	PARTITION BY PLAN_START_YYYYMMDD, DIVISION_ID
														ORDER BY SUM_QTY DESC, CELL_GROUP 
													) AS RNK,
								   PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP
							FROM	(
										SELECT  PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP, SUM(QTY) AS SUM_QTY
										FROM SCP_RPT_GLOBAL_PSI_MD_WW MM WITH(NOLOCK)
										WHERE	1=1
										  AND   MM.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
										  AND 	MM.DIVISION_ID			= @V_DIVISION_ID
										  AND 	MM.MEASURE 				= 'TOT_INV'
										  --AND	MM.YYYYPW 				= @V_RESULT_LAST_YYYYPW
										  AND   MM.ATTRIBUTE8 IS NULL
										GROUP BY PLAN_START_YYYYMMDD, DIVISION_ID, CELL_GROUP
									) B
						) B
				 ON 1=1
				AND  A.PLAN_START_YYYYMMDD 	= B.PLAN_START_YYYYMMDD
				AND  A.DIVISION_ID 			= B.DIVISION_ID
				AND  A.CELL_GROUP 			= B.CELL_GROUP
				AND  A.ATTRIBUTE8 IS NULL
		WHERE 1=1
		;
	
	  COMMIT TRAN ;  --- transaction 종료   
	----- End Tran : 월별 Global PSI 본테이블에 Delete/Insert===============================================================================================================================

		------------------------------------------------------------------
		-- 임시 테이블 정리
		------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_INVENTORY_DIO') IS NOT NULL	
			DROP TABLE #TMP_INVENTORY_DIO;
		IF OBJECT_ID('tempdb..#TMP_RTF_FOR_DIO') IS NOT NULL	
			DROP TABLE #TMP_RTF_FOR_DIO;
		IF OBJECT_ID('TEMPDB..#BASE_DATA_FOR_DIO') IS NOT NULL
			DROP TABLE #BASE_DATA_FOR_DIO;
		IF OBJECT_ID('TEMPDB..#GAP_RTF_MKT_FCST') IS NOT NULL
			DROP TABLE #GAP_RTF_MKT_FCST;
		IF OBJECT_ID('TEMPDB..#SCP_RPT_GLOBAL_PSI_MD_WW') IS NOT NULL
			DROP TABLE #SCP_RPT_GLOBAL_PSI_MD_WW;   
		IF OBJECT_ID('TEMPDB..#TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO') IS NOT NULL
			DROP TABLE #TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO;
		IF OBJECT_ID('tempdb..#PAST_FORM_PROGRESS_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #PAST_FORM_PROGRESS_CHAR_AVAILABLE;
		IF OBJECT_ID('tempdb..#FP_AGING_STOCK') IS NOT NULL	
			DROP TABLE #FP_AGING_STOCK;
		IF OBJECT_ID('tempdb..#PAST_CELL_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #PAST_CELL_CHAR_AVAILABLE;
		IF OBJECT_ID('tempdb..#CELL_CHAR_FOR_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #CELL_CHAR_FOR_CHAR_AVAILABLE;
		IF OBJECT_ID('tempdb..#CELL_PROD_FOR_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #CELL_PROD_FOR_CHAR_AVAILABLE;
		IF OBJECT_ID('tempdb..#PACK_PROD_FOR_CELL_PLANT_INV') IS NOT NULL	
			DROP TABLE #PACK_PROD_FOR_CELL_PLANT_INV;
		IF OBJECT_ID('tempdb..#ITEM_SEMI_SHIP_SITE') IS NOT NULL	
			DROP TABLE #ITEM_SEMI_SHIP_SITE;
		IF OBJECT_ID('tempdb..#SHIP_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #SHIP_FOR_CELL_INV;
		IF OBJECT_ID('tempdb..#CELL_CHAR_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #CELL_CHAR_FOR_CELL_INV;
		IF OBJECT_ID('tempdb..#PACK_CELL_EOH_RESULT_ADJ') IS NOT NULL	
			DROP TABLE #PACK_CELL_EOH_RESULT_ADJ;
		IF OBJECT_ID('tempdb..#PACK_CELL_EOH_RESULT') IS NOT NULL	
			DROP TABLE #PACK_CELL_EOH_RESULT;
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_3') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_3;
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_2') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_2;
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_1') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_1;
		IF OBJECT_ID('tempdb..#SEMI_WHIN_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #SEMI_WHIN_FOR_CELL_INV;
		IF OBJECT_ID('tempdb..#SHIP_FOR_PACK_INV') IS NOT NULL	
			DROP TABLE #SHIP_FOR_PACK_INV;
		IF OBJECT_ID('tempdb..#PRODUCTION_FOR_PACK_INV') IS NOT NULL	
			DROP TABLE #PRODUCTION_FOR_PACK_INV;
		IF OBJECT_ID('tempdb..#SHIP_FOR_SEMI_INTRANSIT') IS NOT NULL	
			DROP TABLE #SHIP_FOR_SEMI_INTRANSIT;
		IF OBJECT_ID('tempdb..#WHIN_FOR_INTRANSIT') IS NOT NULL	
			DROP TABLE #WHIN_FOR_INTRANSIT;
		IF OBJECT_ID('tempdb..#SHIP_FOR_INTRANSIT') IS NOT NULL	
			DROP TABLE #SHIP_FOR_INTRANSIT;
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_WW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_WW;
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM;
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_0') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_0;
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_RAW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_RAW;
		IF OBJECT_ID('tempdb..#TMP_SLOC_ADD_INFO') IS NOT NULL	
			DROP TABLE #TMP_SLOC_ADD_INFO;
		IF OBJECT_ID('tempdb..#TMP_TARGET_ITEM_FOR_ENDING_INV') IS NOT NULL	
			DROP TABLE #TMP_TARGET_ITEM_FOR_ENDING_INV;
		IF OBJECT_ID('TEMPDB..#TMP_TOBE_GLOBAL_PSI') IS NOT NULL
			DROP TABLE #TMP_TOBE_GLOBAL_PSI;
		IF OBJECT_ID('TEMPDB..#WH_IN_SEMI_RESULT') IS NOT NULL
			DROP TABLE #WH_IN_SEMI_RESULT;
		IF OBJECT_ID('TEMPDB..#SHIPMENT_RESULT') IS NOT NULL
			DROP TABLE #SHIPMENT_RESULT;
		IF OBJECT_ID('TEMPDB..#PRODUCTION_RESULT') IS NOT NULL
			DROP TABLE #PRODUCTION_RESULT;
		IF OBJECT_ID('TEMPDB..#PRODUCTION_OPERATION') IS NOT NULL
			DROP TABLE #PRODUCTION_OPERATION;
		IF OBJECT_ID('TEMPDB..#INTRANSIT') IS NOT NULL
			DROP TABLE #INTRANSIT;
		IF OBJECT_ID('TEMPDB..#INTRANSIT_BOH') IS NOT NULL
			DROP TABLE #INTRANSIT_BOH;
		IF OBJECT_ID('TEMPDB..#FCST_RTF_RESULT') IS NOT NULL
			DROP TABLE #FCST_RTF_RESULT;
		IF OBJECT_ID('TEMPDB..#WH_IN_RTF') IS NOT NULL
			DROP TABLE #WH_IN_RTF;
		IF OBJECT_ID('TEMPDB..#SALES_SITE_BOH') IS NOT NULL
			DROP TABLE #SALES_SITE_BOH;
		IF OBJECT_ID('TEMPDB..#CELL_PROD') IS NOT NULL
			DROP TABLE #CELL_PROD;
		IF OBJECT_ID('TEMPDB..#FORM_PROGRESS_FROM_BOH') IS NOT NULL
			DROP TABLE #FORM_PROGRESS_FROM_BOH;
		IF OBJECT_ID('TEMPDB..#CELL_CHAR_PLAN_YIELD') IS NOT NULL
			DROP TABLE #CELL_CHAR_PLAN_YIELD;
		IF OBJECT_ID('TEMPDB..#CELL_SHIP_PLAN_TOTAL') IS NOT NULL
			DROP TABLE #CELL_SHIP_PLAN_TOTAL;
		IF OBJECT_ID('TEMPDB..#CELL_FORM_HOLD_AFTER') IS NOT NULL
			DROP TABLE #CELL_FORM_HOLD_AFTER;
		IF OBJECT_ID('TEMPDB..#CELL_BOH_FOR_FUTURE') IS NOT NULL
			DROP TABLE #CELL_BOH_FOR_FUTURE;
		IF OBJECT_ID('TEMPDB..#CELL_CHAR_PLAN_FUTURE') IS NOT NULL
			DROP TABLE #CELL_CHAR_PLAN_FUTURE;
		IF OBJECT_ID('TEMPDB..#CELL_FOR_FORM_END') IS NOT NULL
			DROP TABLE #CELL_FOR_FORM_END;
		IF OBJECT_ID('TEMPDB..#FOR_FORM_END_WEEKLY') IS NOT NULL
			DROP TABLE #FOR_FORM_END_WEEKLY;
		IF OBJECT_ID('TEMPDB..#FOR_FORM_END_DAILY') IS NOT NULL
			DROP TABLE #FOR_FORM_END_DAILY;
		IF OBJECT_ID('TEMPDB..#CELL_PROD_FORM_END_LINE') IS NOT NULL
			DROP TABLE #CELL_PROD_FORM_END_LINE;
		IF OBJECT_ID('TEMPDB..#CELL_PROD_FORM_END') IS NOT NULL
			DROP TABLE #CELL_PROD_FORM_END;
		IF OBJECT_ID('TEMPDB..#CELL_PROD_FORM_END_RAW') IS NOT NULL
			DROP TABLE #CELL_PROD_FORM_END_RAW;
		IF OBJECT_ID('TEMPDB..#TMP_ASIS_GLOBAL_PSI') IS NOT NULL
			DROP TABLE #TMP_ASIS_GLOBAL_PSI;
		IF OBJECT_ID('TEMPDB..#SCP_ANL_PSI_GLOBAL') IS NOT NULL
			DROP TABLE #SCP_ANL_PSI_GLOBAL;
		IF OBJECT_ID('TEMPDB..#ETC_CP_CELL_INFO') IS NOT NULL
			DROP TABLE #ETC_CP_CELL_INFO;
		IF OBJECT_ID('TEMPDB..#MODULE_MODEL_INFO') IS NOT NULL
			DROP TABLE #MODULE_MODEL_INFO;
		IF OBJECT_ID('TEMPDB..#CP_CELL_ITEM_INFO') IS NOT NULL
			DROP TABLE #CP_CELL_ITEM_INFO;
		IF OBJECT_ID('TEMPDB..#SCP_MST_ITEM_CELL_CF') IS NOT NULL
			DROP TABLE #SCP_MST_ITEM_CELL_CF;
		IF OBJECT_ID('TEMPDB..#CELL_PROD_ASSY_MAP') IS NOT NULL
			DROP TABLE #CELL_PROD_ASSY_MAP;
		IF OBJECT_ID('TEMPDB..#SCP_PLN_TH_ENG_STOCK_PLAN') IS NOT NULL
			DROP TABLE #SCP_PLN_TH_ENG_STOCK_PLAN;
		IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION') IS NOT NULL
			DROP TABLE #SCP_MST_FORMATION;
		IF OBJECT_ID('TEMPDB..#SCP_MST_FINAL_ITEM') IS NOT NULL
			DROP TABLE #SCP_MST_FINAL_ITEM;
		IF OBJECT_ID('TEMPDB..#SCM_MST_SITE') IS NOT NULL
			DROP TABLE #SCM_MST_SITE;
		IF OBJECT_ID('TEMPDB..#TMP_PW_LIST') IS NOT NULL
			DROP TABLE #TMP_PW_LIST
		IF OBJECT_ID('TEMPDB..#TMP_DATE_INFO') IS NOT NULL
			DROP TABLE #TMP_DATE_INFO
		IF OBJECT_ID('TEMPDB..#BASE_DATA_FOR_DIO_CELLGROUP') IS NOT NULL
			DROP TABLE #BASE_DATA_FOR_DIO_CELLGROUP;
		IF OBJECT_ID('tempdb..#TMP_RTF_FOR_DIO_CELLGROUP') IS NOT NULL	
			DROP TABLE #TMP_RTF_FOR_DIO_CELLGROUP;
		IF OBJECT_ID('tempdb..#TMP_INVENTORY_DIO_CELLGROUP') IS NOT NULL	
			DROP TABLE #TMP_INVENTORY_DIO_CELLGROUP;
		IF OBJECT_ID('TEMPDB..#BASE_DATA_FOR_DIO_DETAILREPORT') IS NOT NULL
			DROP TABLE #BASE_DATA_FOR_DIO_DETAILREPORT;
		IF OBJECT_ID('tempdb..#TMP_RTF_FOR_DIO_DETAILREPORT') IS NOT NULL	
			DROP TABLE #TMP_RTF_FOR_DIO_DETAILREPORT;
		IF OBJECT_ID('tempdb..#TMP_INVENTORY_DIO_DETAILREPORT') IS NOT NULL	
			DROP TABLE #TMP_INVENTORY_DIO_DETAILREPORT;
		IF OBJECT_ID('tempdb..#TMP_WW_DAYS_INFO') IS NOT NULL	
			DROP TABLE #TMP_WW_DAYS_INFO;
		IF OBJECT_ID('TEMPDB..#SHIPTO_CODE') IS NOT NULL
			DROP TABLE #SHIPTO_CODE;
        -- 2025.05.28   kimcd GLOBAL PSI NEW - AS 대상 SALES_TYPE_CODE 임시 정보 삭제
		IF OBJECT_ID('tempdb..#TMP_AS_SALES_TYPE_CODE') IS NOT NULL	
			DROP TABLE #TMP_AS_SALES_TYPE_CODE;

					
	  END			    
	END TRY

	BEGIN CATCH                  
		if (xact_state() <> 0) ROLLBACK TRAN; 

		---- ERROR LOG                  
		SET @v_log_type = N'ERROR';                  
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		SET @d_event_date = SYSDATETIME();                  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                  
		                          ,@p_log_type      = @v_log_type                  
		                          ,@p_log_count     = @n_log_count                   
		                          ,@p_log_message   = @v_log_message                   
		                          ,@p_description   = @v_description                   
		                          ,@p_event_date    = @d_event_date                   
		                          ,@p_user_id       = @v_batch_user                  
		                          ;                  
		PRINT @v_log_message      + ' : ' + @v_description ;  
		RETURN -1;    
		
    END CATCH;   

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))           
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'##### END of procedure #####';                  
    SET @v_description = N'['+ @v_division_id + '::'+@v_plan_start_yyyymmdd+'::'+ISNULL(@v_eng_plan_id,'')+']['  + @v_exec_time + ']';  ;            
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                    ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
            ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
	PRINT @v_log_message  + ' : ' + @v_description ;          

END


