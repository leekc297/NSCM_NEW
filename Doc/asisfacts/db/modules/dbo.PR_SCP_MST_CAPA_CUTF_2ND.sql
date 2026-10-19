

/*  
 * Program ID   : PR_SCP_MST_CAPA_CUTF_2ND
 * Description  : SCP Capa 2차 Cutoff 수행 프로시저
 *				 
 *			### Source Table 
 *				SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF
 *				SCP_MST_CAPA_LOSS_PLAN_LN (비조업) 
 *				SCP_MST_CAPA_SPEED_PLAN_CUTF
 *				SCM_DNM_LOSS_LN_MMLY
 *				SCP_MST_CAPA_LINE_SOP
 *				-- 전극
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_LN
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF		-- RP/BIZP 계획 참조 
 *				SCM_DNM_ELTR_LOSS_LN_MMLY				-- 전극 라인별 Loss 실적 
 *				SCP_MST_CAPA_ELTR_LINE_SOP
 *
 *			### Target Table 
 *				-- 조립/팩
 *				SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF
 *				SCP_MST_CAPA_LOSS_PLAN_LN_CUTF
 *				SCP_MST_CAPA_LINE_SOP_B
 *				-- 전극 
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF
 *				SCP_MST_CAPA_ELTR_LINE_SOP_B
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.04.17	hrkim		Initial Release PJ2024-50026 / LGES2024-002455   Capa. 관리 시스템 구축  
 * 2024.04.29	hrkim		이전버전 기준 당월 계획 추가 
 * 2024.05.03	hrkim		라인별 합계 Base 로직 변경 
 * 2024.05.09	hrkim		생산 Capa(월) -> Total Capa로 변경 (해당월의 총 Capa 또는 해당년도의 총 Capa) 
 * 2024.05.10	hrkim		설비대수 라인별 합계 로직 변경 (Final Plan이 존재하는 데이터의 설비대수 평균 ?) 
 *							Line 에 Final Plan 이 있는 Basic Nickname 기준 Speed 개선계획 설비 대수 / Final Plan Basic Nickname 개수
 * 2024.05.13	hrkim		설비대수 라인별 합계 로직 변경 
 *							- 참조 소스 테이블 변경 (모델별 loss plan cutoff -> speed plan cutoff) 
 * 2024.05.14	hrkim		M-1월 실적의 비조업 MSR_NVL - 일수로 반영 
 * 2024.05.17	hrkim		라인 컷오프 데이터 임시테이블에 모두 넣고 한번에 등록 (RSLT + PRVS) 
 * 2024.05.20	hrkim		라인별 컷오프 부가정보 추가 작업 진행중 
 * 2024.05.21	hrkim		라인별합계 부가 정보 추가 for TEEP 공정합계 ((attribute컬럼 활용) 
 * 2024.05.22	hrkim		사업계획 추가 (YYYYMM = 'BIZP') 
 * 2024.05.27	hrkim		소수 자릿수 처리 로직 보완 (FLOAT, NUMERIC(20,10) 
 * 2024.06.05	hrkim		조립 Speed 실적 Line별 참조
 * 2024.06.10	hrkim		RP(Rolling Plan) 참조 참조 대상 변경 (M-2월 버전에서 계획한 M-1월 계획) 
 *							(실적 참조 년월과 맞춤) 
 * 2024.06.12	hrkim		전극 추가 
 * 2024.07.10	hrkim		전극 테이블 PK 변경 : ELTR_LN_TP_CD 컬럼 PK컬럼에서 제외
 * 2024.07.26	hrkim		조립팩 비조업 WT_RT 계산 오류 수정 
 * 2024.08.09	hrkim		전극 조업일 계산 로직 수정  
 *							변경전 : 최대조업일 * 조업률
 *							변경후 : 최대조업일 - SUM(비조업일)
 * 2024.08.13	hrkim		조립 라인별 설비대수 집계로직 변경 (물동 유무와 상관없이 라인별 max) 
 *							BIZP 참조 버전 조회 로직 수정 (seq 사용으로 해당 버전포함 참조) 
 *							next 버전 생성 프로시저 호출 부분 주석처리
 * 2024.08.14	hrkim		TEEP 양품가동률 합계로직 변경됨에 따라 양품가동률 attribute4값 변경적재 (이론Capa -> 조업률) 
 * 2024.08.21	hrkim		성능가동률 라인별 합계 로직 변경 
 *							분모 시간가동일수가 0 이면 성능가동률을 0 이 아닌 1로 반영 
 * 2024.08.29	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 적용
 * 2024.09.10	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : CPS Formation 공정 처리 로직 추가 - lookupType : CPS_FORMATION_OPERATION
 * 2024.09.12	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 조립 라인별 attribute8컬럼 SOP반영한 최대조업일수 추가 적재 
 * 2024.09.12	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 적용 최대조업일수 임시테이블 데이터 타입 수정 (FLOAT) 
 * 2024.09.25	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 정보 백업 
 * 2024.09.26	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : RP/BP 라인별 loss attribute 컬럼값 (for TEEP 합계계산시 참조) 해당 버전의 값 그대로 적재 
 * 2024.09.27	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 전극 라인별 BASE 조업률/일수 수정 
 * 2024.10.16	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : base sop 적용 안함 
 * 2024.10.22	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 조립 라인별 부하/가동/성능/양품/시간가동 일수 계산시 소수점 처리 수정 (임시테이블 numeric(20,10) -> float) 
 * 2024.10.23	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 조립 라인별 비조업 MSR_DDN 컬럼(WT_RT) null처리 / 전극 라인별 비조업 (MSR_DDN컬럼 MSR_NVL값과 일치시킴)
 * 2024.10.29	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : BP(사업계획)/RP(RollingPlan) 참조 기준 변경 
 *																	 - BP : 실적년월 기준 전년도에 수립한 사업계획 버전의 전월계획 (BIZ_PLAN_USE_YN = 'Y'만 참조) 		
 *																	 - RP : 전전월에 수립한 전월계획 (BIZ_PLAN_USE_YN != 'Y'만 참조 - 사업계획 버전 참조하지 않음) 		
 *																	* SOP 실적 (지표예외일자 적용된 실적의 최대조업일수 반영)  
 *
 * 2025.01.06	hrkim		CPS_BATCH_PROC_RUN lookup 참조하여 next 버전 생성 프로시저 수행
 * 2025.01.14	hrkim		lookup CPS_BATCH_CRTN_THURSDAY(월별 CPS 배치 수행 기준 목요일) 적용 
 *							 - 매월 마지막 목요일 기준으로 전/후 일요일에 1,2차 컷오프 수행 및 해당 주차의 SCP FN 생산계획 적용 
 *							 - lookup이 등록된 경우 해당 목요일 기준으로 전/후 일요일에 1,2차 컷오프 수행 및 해당 주차의 SCP FN 생산계획 적용
 * 2025.02.05	hrkim		개선/목표율 관리 기능 삭제 - 해당 컬럼 참조 소스 삭제 (IPRV_GOL_DIVS_CD/IPRV_GOL_RT)
 * 2025.03.17	hrkim		CURSOR오류 - 커서 선언문 위치 변경 
 *
 */  


CREATE PROCEDURE [dbo].[PR_SCP_MST_CAPA_CUTF_2ND]
	 @P_IS_MANUAL	NVARCHAR(1)		= 'N'
	,@P_DIVISION_ID	NVARCHAR(50)	= NULL
AS
BEGIN


-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 


	DECLARE	@V_IS_MANUAL			NVARCHAR(1)  = @P_IS_MANUAL
	DECLARE @V_DIVISION_ID			NVARCHAR(30) = @P_DIVISION_ID	;
	DECLARE @V_VER_ID				NVARCHAR(10) = NULL	;
	DECLARE @V_VER_SEQ				TINYINT		 = NULL	;
	DECLARE @V_LOSS_RSLT_YYYYMM		NVARCHAR(6)	= NULL	;
	DECLARE @V_BIZP_YYYY			NVARCHAR(4)	= NULL	;
	DECLARE @V_RP_YYYYMM			NVARCHAR(6)	= NULL	;

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_CAPA_CUTF_2ND'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	BEGIN TRY
	  BEGIN

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '['+ ISNULL(@v_division_id, 'ALL') + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		PRINT '------------------------------------------------------------------';
		PRINT '@V_IS_MANUAL			= ' + @V_IS_MANUAL;
		PRINT '@V_DIVISION_ID		= ' + ISNULL(@V_DIVISION_ID, 'ALL');
		PRINT '------------------------------------------------------------------';

		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 컷오프 실행일 정보' 
		------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#Cutoff_Date_Info') IS NOT NULL DROP TABLE #Cutoff_Date_Info;

		;WITH LAST_THU AS (
			SELECT YYYYMM
				 , MAX(YYYYMMDD) AS YYYYMM_LAST_THU
			 FROM SCM_MST_BUCKET THU WITH(NOLOCK)
			WHERE 1=1
			  AND YYYYMM BETWEEN CONVERT(NVARCHAR(6), DATEADD(MM, -1, GETDATE()), 112) -- 전월 
							 AND CONVERT(NVARCHAR(6), GETDATE()				    , 112) -- 당월 
			  AND DAYOFWEEK = 'THU'
			GROUP BY YYYYMM
		) , THU AS (
			SELECT LT.YYYYMM
				  ,ISNULL(BT.ATTRIBUTE1, LT.YYYYMM_LAST_THU)	AS YYYYMM_LAST_THU 
			 FROM LAST_THU  LT
				  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL BT WITH(NOLOCK)
						 ON BT.LOOKUP_TYPE	= 'CPS_BATCH_CRTN_THURSDAY' -- 2025.01.14 배치수행 기준 목요일
						AND BT.SEGMENT1		= LT.YYYYMM
						AND BT.VALID_YN		= 'Y'
			WHERE 1=1
		)
		SELECT TH.YYYYMM
			  ,TH.YYYYMM_LAST_THU					-- 해당월 마지막 목요일 (기준 목요일) 
			  ,MAX(BF.YYYYMMDD)	AS YMD_1ST_CUTOFF	-- 해당월 1차 컷오프 수행 일요일 (기준 목요일 이전 일요일) 
			  ,MIN(AF.YYYYMMDD)	AS YMD_2ND_CUTOFF	-- 해당월 2차 컷오프 수행 일요일 (기준 목요일 이후 일요일)
		 INTO #Cutoff_Date_Info
		 FROM THU  TH
			  INNER JOIN SCM_MST_BUCKET BF WITH(NOLOCK)
					  ON BF.YYYYMMDD < TH.YYYYMM_LAST_THU
					 AND BF.DAYOFWEEK = 'SUN'
			  INNER JOIN SCM_MST_BUCKET AF WITH(NOLOCK)
					  ON AF.YYYYMMDD > TH.YYYYMM_LAST_THU
					 AND AF.DAYOFWEEK = 'SUN'
		WHERE 1=1
		GROUP BY TH.YYYYMM
			  ,TH.YYYYMM_LAST_THU 


	  IF @V_IS_MANUAL = 'Y' -- 매뉴얼로 실행시
	     OR 
	     EXISTS (SELECT 1
	  				FROM #Cutoff_Date_Info
	  			   WHERE YMD_2ND_CUTOFF = CONVERT(NVARCHAR(8), GETDATE(), 112) ) -- 2차 컷오프 수행일 
	  BEGIN ------------------------------------------------------------------------------------- 컷오프 수행일인 경우만 실행!!! 


		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### CPS Formation 공정' -- 9/10 추가  
		-----------------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#CPS_FORMATION_OPERATION') is not null drop table #CPS_FORMATION_OPERATION;

		 SELECT SEGMENT1		AS OPERATION_ID
			   ,MAX(ATTRIBUTE1)	AS OPERATION_NAME 
		  INTO #CPS_FORMATION_OPERATION
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE = 'CPS_FORMATION_OPERATION'
		   AND VALID_YN = 'Y'
		GROUP BY SEGMENT1

	    -- TRY문 안쪽으로 커서 선언 위치 변경 2025.03.17 
		DECLARE CAPA_VER_DATA  CURSOR FOR
			SELECT DIVISION_ID
				  ,VER_ID
				  ,VER_SEQ 					
			  FROM SCP_MST_CAPA_VERSION WITH(NOLOCK)	
			 WHERE 1=1
			   AND DIVISION_ID	= ISNULL(@P_DIVISION_ID, DIVISION_ID)
			   AND VER_ID		>= CONVERT(NVARCHAR(6), DATEADD(MM, -1, GETDATE()), 112)    -----!!! 2차 cutoff를 당월에 할수 없는 경우 !!! (ex: 202408월 : 8/25 1차, 9/1 2차) -------------------------
			   AND PROG_STAT	= '1'
			   -- 6/27 AND SCP_FIN_PLAN_ID	IS NOT NULL --- scp prod plan 생산 정보가 있는 경우  
			   ;

    	OPEN CAPA_VER_DATA
        FETCH NEXT FROM CAPA_VER_DATA INTO @V_DIVISION_ID
										  ,@V_VER_ID
										  ,@V_VER_SEQ

        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN

			SET @V_LOSS_RSLT_YYYYMM = CONVERT(NVARCHAR(6), DATEADD(MM	, -1,	CONVERT(DATE, @V_VER_ID+'01' , 112)), 112) ;
 			SET @V_BIZP_YYYY		= CONVERT(NVARCHAR(4), DATEADD(YEAR	, -1,	CONVERT(DATE, @V_LOSS_RSLT_YYYYMM+'01' , 112)), 112) ;
 			SET @V_RP_YYYYMM		= CONVERT(NVARCHAR(6), DATEADD(MONTH, -2,	CONVERT(DATE, @V_VER_ID+'01', 112)), 112)  ;

			PRINT '------------------------------------------------------------------';
			PRINT '@V_DIVISION_ID			= ' + @V_DIVISION_ID;
			PRINT '@V_VER_ID				= ' + @V_VER_ID;
			PRINT '@V_VER_SEQ				= ' + CONVERT(NVARCHAR(10), @V_VER_SEQ);
			PRINT '@V_LOSS_RSLT_YYYYMM		= ' + @V_LOSS_RSLT_YYYYMM;
			PRINT '@V_BIZP_YYY				= ' + @V_BIZP_YYYY;
			PRINT '@V_RP_YYYYMM				= ' + @V_RP_YYYYMM;
			PRINT '------------------------------------------------------------------';

			SET @v_log_type = 'TXN';
			SET @v_log_message = 'START - '+@v_division_id;     
			SET @v_description = '['+ @v_division_id + '::' + @V_VER_ID + '::' + CONVERT(NVARCHAR(10), @V_VER_SEQ) + ']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
			SET @v_log_message = NULL 


----------------------- Start 조립/팩 -------------------------------------------------------------------------------------------------------
----------------------- Start 조립/팩 -------------------------------------------------------------------------------------------------------
----------------------- Start 조립/팩 -------------------------------------------------------------------------------------------------------

			--------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 템프테이블 모델별 LOSS Cutoff 데이터 -  #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF' 
			--------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF;
			SELECT CONVERT(INTEGER, 0) AS MDL_ALTER_KEY 
				  ,CONVERT(INTEGER, 0) AS LN_ALTER_KEY 
				  ,DIVISION_ID
				  ,MDL_NM
				  ,PLANT_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,COMPANY_ID
				  ,SITE_ID
				  ,FACTORY_ID
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,CONVERT(NUMERIC(20,10), PFRSLT_NVL)		AS PFRSLT_NVL
				  ,CONVERT(NUMERIC(20,10), BASE_NVL)		AS BASE_NVL
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,CONVERT(NUMERIC(20,10), IPRV_GOL_RT)		AS IPRV_GOL_RT
				  ,MSR_GR_CD
				  ,CONVERT(NUMERIC(20,10), MSR_NVL)			AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), MSR_DDN)			AS MSR_DDN
			 INTO #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF
			 FROM SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF WITH(NOLOCK)
			WHERE 1=2 

			----------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 템프테이블 라인별 LOSS 합계 -  #LOSS_PLAN_LN_TTZM' 
			----------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#LOSS_PLAN_LN_TTZM') IS NOT NULL DROP TABLE #LOSS_PLAN_LN_TTZM;
			SELECT CONVERT(BIGINT, 1) AS LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,CONVERT(NUMERIC(20,10), MSR_NVL)			AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), MSR_DDN)			AS MSR_DDN
				  ,ATTRIBUTE1	 -- 2024.09.26 추가 for RP/BP 
				  ,ATTRIBUTE2	 -- 2024.09.26 추가 for RP/BP 
				  ,ATTRIBUTE3	 -- 2024.09.26 추가 for RP/BP 
				  ,ATTRIBUTE4	 -- 2024.09.26 추가 for RP/BP 
				  ,ATTRIBUTE5	 -- 2024.09.26 추가 for RP/BP 
				  ,ATTRIBUTE6	 -- 2024.09.26 추가 for RP/BP 
				  ,ATTRIBUTE7	 -- 2024.09.26 추가 for RP/BP 
				  ,ATTRIBUTE8	 -- 2024.09.26 추가 for RP/BP 
				  ,ATTRIBUTE10
			 INTO #LOSS_PLAN_LN_TTZM
			 FROM SCP_MST_CAPA_LOSS_PLAN_LN WITH(NOLOCK)
			WHERE 1=2

			-------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan 모델별 Cutoff Data -  #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF' 
			-------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF
			SELECT  DENSE_RANK() OVER (PARTITION BY 'A' 
										  ORDER BY LS.MDL_NM
												  ,LS.PLANT_ID
												  ,LS.FACTORY_ID	
												  ,LS.LINE_ID
												  ,LS.OPERATION_ID
												  ,LS.ELTR_LN_TP_CD
												  ,LS.DIVISION_ID
												  ,LS.COMPANY_ID
												  ,LS.SITE_ID
												) AS MDL_ALTER_KEY
					,DENSE_RANK() OVER (PARTITION BY 'A' 
										  ORDER BY LS.PLANT_ID
												  ,LS.FACTORY_ID	
												  ,LS.LINE_ID
												  ,LS.OPERATION_ID
												  ,LS.ELTR_LN_TP_CD
												  ,LS.DIVISION_ID
												  ,LS.COMPANY_ID
												  ,LS.SITE_ID
												) AS LN_ALTER_KEY
					,LS.DIVISION_ID
					,LS.MDL_NM
					,LS.PLANT_ID
					,LS.LINE_ID
					,LS.OPERATION_ID
					,LS.ELTR_LN_TP_CD
					,LS.COMPANY_ID
					,LS.SITE_ID
					,LS.FACTORY_ID
					,LS.MSR_TP_CD
					,LS.YYYYMM
				    ,LS.PFRSLT_NVL			AS PFRSLT_NVL
				    ,LS.BASE_NVL			AS BASE_NVL
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,LS.IPRV_GOL_DIVS_CD
				    -- 2025.02.05 개선/목표일 관리 기능 삭제 ,LS.IPRV_GOL_RT			AS IPRV_GOL_RT
					,LS.MSR_GR_CD
				    ,LS.MSR_NVL				AS MSR_NVL
				    ,LS.MSR_DDN				AS MSR_DDN
			FROM SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF LS WITH(NOLOCK) 
			WHERE 1=1
			  AND LS.VER_ID		 = @V_VER_ID
			  AND LS.VER_SEQ	 = @V_VER_SEQ
			  AND LS.DIVISION_ID = @V_DIVISION_ID

			-------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan 모델별 Cutoff Data -  CPS Formation 공정 제외' 
			-- 2024.09.10 CPS Formation 공정(Daily Production Capa) TEEP 대상에서 제외 
			-------------------------------------------------------------------------------------------------------------------------
			DELETE LS
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF LS 
				  INNER JOIN #CPS_FORMATION_OPERATION FO
						  ON FO.OPERATION_ID = LS.OPERATION_ID
			WHERE 1=1

			--------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Speed Plan Cutoff 데이터 - #SCP_MST_CAPA_SPEED_PLAN_CUTF' 
			--------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_SPEED_PLAN_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_SPEED_PLAN_CUTF	;

			SELECT DIVISION_ID
				  ,NICK_NAME	AS MDL_NM
				  ,PLANT_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,COMPANY_ID
				  ,SITE_ID
				  ,FACTORY_ID
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,CONVERT(FLOAT, BASE_QTY)	AS BASE_QTY
				  ,CONVERT(FLOAT, QTY)		AS QTY 
			 INTO #SCP_MST_CAPA_SPEED_PLAN_CUTF
			 FROM SCP_MST_CAPA_SPEED_PLAN_CUTF SP WITH(NOLOCK) 
			WHERE 1=1
			  AND SP.VER_ID		 = @V_VER_ID
			  AND SP.VER_SEQ	 = @V_VER_SEQ
			  AND SP.DIVISION_ID = @V_DIVISION_ID
			  AND SP.MSR_TP_CD	 = 'EQP_NBU'

			-----------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan 모델별 Cutoff Data -  #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF - 설비대수 추가'  -- 5/13  
			-----------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO  #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF
			SELECT LP.MDL_ALTER_KEY
				  ,LP.LN_ALTER_KEY
				  ,LP.DIVISION_ID
				  ,LP.MDL_NM
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,'EQP_NBU'					AS MSR_TP_CD   
				  ,LP.YYYYMM
				  ,0							AS PFRSLT_NVL
				  ,SP.BASE_QTY					AS BASE_NVL
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,''							AS IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,0							AS IPRV_GOL_RT
				  ,'-'							AS MSR_GR_CD
				  ,SP.QTY						AS MSR_NVL
				  ,NULL							AS MSR_DDN
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF LP WITH(NOLOCK)
				  INNER JOIN #SCP_MST_CAPA_SPEED_PLAN_CUTF SP WITH(NOLOCK)
						 ON SP.DIVISION_ID		= LP.DIVISION_ID
						AND SP.COMPANY_ID		= LP.COMPANY_ID
						AND SP.SITE_ID			= LP.SITE_ID
						AND SP.PLANT_ID			= LP.PLANT_ID
						AND SP.FACTORY_ID		= LP.FACTORY_ID
						AND SP.LINE_ID			= LP.LINE_ID
						AND SP.OPERATION_ID		= LP.OPERATION_ID
						AND SP.ELTR_LN_TP_CD	= LP.ELTR_LN_TP_CD
						AND SP.MDL_NM			= LP.MDL_NM 
						AND SP.YYYYMM			= LP.YYYYMM 
						AND SP.MSR_TP_CD		= 'EQP_NBU' 
			WHERE 1=1
			  AND LP.MSR_TP_CD = 'THRY_CAPA_D'

			-----------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan 모델별 Cutoff Data -  #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF - Base 추가'  --- 2024.05.03 
			-----------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF
			SELECT   LS.MDL_ALTER_KEY
					,LS.LN_ALTER_KEY
					,LS.DIVISION_ID
					,LS.MDL_NM
					,LS.PLANT_ID
					,LS.LINE_ID
					,LS.OPERATION_ID
					,LS.ELTR_LN_TP_CD
					,LS.COMPANY_ID
					,LS.SITE_ID
					,LS.FACTORY_ID
					,LS.MSR_TP_CD
					,'BASE'	AS YYYYMM 
					,MAX(LS.PFRSLT_NVL)
					,MAX(LS.BASE_NVL)
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,MAX(LS.IPRV_GOL_DIVS_CD)
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,MAX(LS.IPRV_GOL_RT)
					,MAX(LS.MSR_GR_CD)
					,MAX(LS.BASE_NVL)	AS MSR_NVL
					,NULL				AS MSR_DDN
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF LS WITH(NOLOCK) 
			GROUP BY LS.MDL_ALTER_KEY
					,LS.LN_ALTER_KEY
					,LS.DIVISION_ID
					,LS.MDL_NM
					,LS.PLANT_ID
					,LS.LINE_ID
					,LS.OPERATION_ID
					,LS.ELTR_LN_TP_CD
					,LS.COMPANY_ID
					,LS.SITE_ID
					,LS.FACTORY_ID
					,LS.MSR_TP_CD

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 월별 일수 정보 -  #YYYYMM_DAYS_INFO' 
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO;

			SELECT DISTINCT YYYYMM
						   ,CONVERT(FLOAT, 
								CASE WHEN YYYYMM = 'BASE'
									 THEN DATEDIFF(DD, CONVERT(DATE, @V_VER_ID+'01', 112)
													 , DATEADD(MM, 1, CONVERT(DATE, @V_VER_ID+'01', 112)))	-- 월일수 base (버전 당월) 
									 WHEN LEN(YYYYMM) = 4  
									 THEN DATEDIFF(DD, CONVERT(DATE, YYYYMM+'0101', 112)
													 , DATEADD(YY, 1, CONVERT(DATE, YYYYMM+'0101', 112)))   -- 년일수 
									 ELSE DATEDIFF(DD, CONVERT(DATE, YYYYMM+'01', 112)
													 , DATEADD(MM, 1, CONVERT(DATE, YYYYMM+'01', 112)))		-- 월일수
								END)  AS YYYYMM_DDN 
			 INTO #YYYYMM_DAYS_INFO
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF LS WITH(NOLOCK)
			WHERE 1=1
			UNION ALL
			SELECT 'RSLT'
			      ,CONVERT(FLOAT, DATEDIFF(DD, CONVERT(DATE, @V_LOSS_RSLT_YYYYMM+'01', 112)
													  , DATEADD(MM, 1, CONVERT(DATE, @V_LOSS_RSLT_YYYYMM+'01', 112))))	-- 실적 월 일수 (M-1월)

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 라인별 ALTER KEY 정보 - #ALTER_KEY_INFO_FOR_LN' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_LN') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_LN

			SELECT DISTINCT
				   LS.LN_ALTER_KEY
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,LS.ELTR_LN_TP_CD
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
			INTO #ALTER_KEY_INFO_FOR_LN
			FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF LS  WITH(NOLOCK)


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - SOP Master 정보 - #SCP_MST_CAPA_LINE_SOP'   
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LINE_SOP') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LINE_SOP

		SELECT SP.DIVISION_ID
			  ,SP.COMPANY_ID
			  ,SP.SITE_ID
			  ,SP.PLANT_ID
			  ,SP.FACTORY_ID
			  ,SP.LINE_ID
			  ,SP.OPERATION_ID
			  ,SP.ELTR_LN_TP_CD
			  ,SP.VALID_YN
			  ,SP.SOP_DT
			  ,SP.SOP_YM
			  ,SP.CREATION_DATE
			  ,SP.CREATED_BY
			  ,SP.LAST_UPDATE_DATE
			  ,SP.LAST_UPDATED_BY
			  ,CONVERT(FLOAT, SP.SOP_DDN)	AS SOP_DDN 
			  ,SUBSTRING(SP.SOP_YM, 1, 4)	AS SOP_YY
			  ,CONVERT(FLOAT, DATEDIFF(DD, CONVERT(DATE, SP.SOP_DT, 112)
										 , DATEADD(YY, 1, CONVERT(DATE, SUBSTRING(SP.SOP_YM, 1, 4)+'0101', 112))))	AS SOP_YY_DDN	-- 년일수
		  INTO #SCP_MST_CAPA_LINE_SOP
		  FROM SCP_MST_CAPA_LINE_SOP SP WITH(NOLOCK) 
		 WHERE 1=1
		   AND SP.DIVISION_ID	= @V_DIVISION_ID
		   AND SP.VALID_YN		= 'Y'
		   AND SP.SOP_DT IS NOT NULL
		   AND SP.SOP_YM IS NOT NULL
		   AND SP.SOP_DDN IS NOT NULL 
		   AND SP.SOP_DDN	   != 0 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 조립 라인별/월 일수 정보 WITH SOP - #YYYYMM_DAYS_INFO_APPLIED_SOP'  
			-- 조립 : DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELTR_LN_TP_CD
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO_APPLIED_SOP') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO_APPLIED_SOP

			;WITH CAPA_LINE_SOP AS (
				SELECT SP.DIVISION_ID
					  ,SP.COMPANY_ID
					  ,SP.SITE_ID
					  ,SP.PLANT_ID
					  ,SP.FACTORY_ID
					  ,SP.LINE_ID
					  ,SP.OPERATION_ID
					  ,SP.ELTR_LN_TP_CD
					  ,SP.SOP_DT
					  ,CASE WHEN YM.DV = 'Y'
							THEN SP.SOP_YY
							ELSE SP.SOP_YM
						END AS SOP_YM
					  ,CASE WHEN YM.DV = 'Y'
							THEN SP.SOP_YY_DDN
							ELSE SP.SOP_DDN
						END AS SOP_DDN
				 FROM #SCP_MST_CAPA_LINE_SOP SP
					  INNER JOIN (SELECT 'Y' AS DV 
								  UNION ALL 
								  SELECT 'M' AS DV ) AS YM 
							  ON 1=1
				WHERE 1=1
			)
			SELECT AK.LN_ALTER_KEY
				  ,DI.YYYYMM
				  ,CONVERT(FLOAT,	-- 2024.09.12 
				   CASE WHEN SO.SOP_YM IS NOT NULL AND DI.YYYYMM != 'BASE'	-- 2024.10.16 base SOP 적용 안함 
						THEN SO.SOP_DDN
						ELSE DI.YYYYMM_DDN
					END )		AS YYYYMM_DDN
			 INTO #YYYYMM_DAYS_INFO_APPLIED_SOP 
			 FROM #ALTER_KEY_INFO_FOR_LN AK
				   INNER JOIN #YYYYMM_DAYS_INFO DI
						   ON  1=1
					LEFT JOIN CAPA_LINE_SOP SO
						   ON SO.DIVISION_ID	= AK.DIVISION_ID
						  AND SO.COMPANY_ID		= AK.COMPANY_ID
						  AND SO.SITE_ID		= AK.SITE_ID
						  AND SO.PLANT_ID		= AK.PLANT_ID
						  AND SO.FACTORY_ID		= AK.FACTORY_ID
						  AND SO.LINE_ID		= AK.LINE_ID
						  AND SO.OPERATION_ID	= AK.OPERATION_ID
						  AND SO.ELTR_LN_TP_CD	= AK.ELTR_LN_TP_CD
						  AND SO.SOP_YM			= CASE	WHEN DI.YYYYMM = 'BASE'
														THEN @V_VER_ID	
														ELSE DI.YYYYMM
												   END 
			 WHERE 1=1

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 데이터 -  조업률/조업일수  ' 
			-- 1차 Cutoff 및 SCP Final Plan 생산계획 적용 후 미래구간 UI에서 입력된 생산계획정보 포함하여 조업률/조업일수 재계산
			-- 조업일수 : SCP생산계획 / 생산 Capa(일)
			-- 조업률 : 조업일수 / 최대조업일수
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY

			;WITH PROD_PLAN_THRY_CAPA AS ( 
				SELECT MDL_ALTER_KEY
					  ,LN_ALTER_KEY
					  ,YYYYMM
					  ,CONVERT(FLOAT, MAX(CASE WHEN LP.MSR_TP_CD = 'SCP_PROD_PLAN'	THEN LP.MSR_NVL ELSE 0. END)) AS SCP_PROD_PLAN
					  ,CONVERT(FLOAT, MAX(CASE WHEN LP.MSR_TP_CD = 'PROD_CAPA_D'	THEN LP.MSR_NVL ELSE 0. END)) AS PROD_CAPA_D
				 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF LP WITH(NOLOCK)
				WHERE 1=1 
				  AND MSR_TP_CD IN ('SCP_PROD_PLAN', 'PROD_CAPA_D') 
				GROUP BY MDL_ALTER_KEY
						,LN_ALTER_KEY
						,YYYYMM
			)
			SELECT PC.MDL_ALTER_KEY
				  ,PC.LN_ALTER_KEY
				  ,'-'		AS MSR_GR_CD
				  ,'AV_RT'	AS MSR_TP_CD 
				  ,PC.YYYYMM
				  -- 조업률
				  ,CONVERT(NUMERIC(20,10), 
				   CASE WHEN PC.YYYYMM = 'BASE' 
						THEN 1.		  -- Base 조업률 100% 
						ELSE CASE WHEN ISNULL(PC.PROD_CAPA_D,0) = 0 
								  THEN 0. 
								  ELSE  CONVERT(FLOAT, CONVERT(NUMERIC(20,10), PC.SCP_PROD_PLAN / PC.PROD_CAPA_D))
							  END / DI.YYYYMM_DDN 
					END)		AS MSR_NVL	 
				  -- 조업일수
				  ,CONVERT(NUMERIC(20,10), 
				   CASE WHEN PC.YYYYMM = 'BASE'
						THEN DI.YYYYMM_DDN				-- BASE는 최대 조업일수 
						ELSE CASE WHEN ISNULL(PC.PROD_CAPA_D,0) = 0 
								  THEN 0. 
								  ELSE  PC.SCP_PROD_PLAN / PC.PROD_CAPA_D 
							 END
					END)		AS MSR_DDN
			 INTO #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
			 FROM PROD_PLAN_THRY_CAPA  PC WITH(NOLOCK) 
				  INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP DI WITH(NOLOCK)	-- 2024/8/29 SOP 적용 
					      ON DI.YYYYMM			= PC.YYYYMM
						 AND DI.LN_ALTER_KEY	= PC.LN_ALTER_KEY
			WHERE 1=1

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 데이터 - PPM (for 양품가동률 일수 계산) ' 
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#PPM') IS NOT NULL DROP TABLE #PPM;
			SELECT MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,'PPM'									AS MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,CONVERT(FLOAT, CONVERT(NUMERIC(20,10), CONVERT(FLOAT, MSR_NVL) / CONVERT(FLOAT, 1440))) AS PPM
			  INTO #PPM
			  FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF 
			 WHERE 1=1
			   AND MSR_TP_CD = 'THRY_CAPA_D'

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 데이터 - 조업율/부하율/시간가동률/성능가동률/양품가동률 ' 
			------------------------------------------------------------------------------------------------------------------
			-- AV_RT	조업율
			-- LD_RT	부하율
			-- OP_RT	시간가동률
			-- PF_RT	성능가동률
			-- QL_RT	양품가동률
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#AV_LD_OP_PF_QL') IS NOT NULL DROP TABLE #AV_LD_OP_PF_QL;

			SELECT MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,CONVERT(FLOAT, MSR_DDN) AS MSR_DDN 
				  ,CASE WHEN MSR_TP_CD = 'AV_RT' THEN 1
						WHEN MSR_TP_CD = 'LD_RT' THEN 2
						WHEN MSR_TP_CD = 'OP_RT' THEN 3
						WHEN MSR_TP_CD = 'PF_RT' THEN 4
						WHEN MSR_TP_CD = 'QL_RT' THEN 5
					END MSR_SEQ 
			 INTO #AV_LD_OP_PF_QL
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF  
			WHERE 1=1
			  AND MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT') 

			-- 조업률/조업일수 추가 
			INSERT INTO #AV_LD_OP_PF_QL
			SELECT MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN	AS MSR_DDN 
				  ,1		AS MSR_SEQ 
			 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY  
			WHERE 1=1
			  AND MSR_TP_CD = 'AV_RT'

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Loss 모델별 Cutoff - 조업/부하/시간가동/성능가동/양품가동 일수' 
			------------------------------------------------------------------------------------------------------------------
			-- 일수정보 : MSR_DDN 
			-- AV_RT	조업율		: 조업일수		= 생산 Capa(월) / 생산 Capa(일)
			-- LD_RT	부하율		: 부하일수		= 조업일수 * 부하율
			-- OP_RT	시간가동률	: 시간가동일수	= 부하일수 * 시간가동률
			-- PF_RT	성능가동률	: 성능가동일수	= 시간가동일수 * 성능가동률
			-- QL_RT	양품가동률	: 양품가동일수	= 성능가동일수 * PPM 
			-- PPM = 이론 Capa(일) / 1440 
			-- 2024.10.22 소수점 처리 변경 #MSR_DDN (numeric(20,10) -> float) 
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#MSR_DDN') IS NOT NULL DROP TABLE #MSR_DDN;

			;WITH RECURSIVE_DATA AS (
				SELECT R.MDL_ALTER_KEY
					  ,R.LN_ALTER_KEY
					  ,R.MSR_TP_CD
					  ,R.YYYYMM
					  ,R.MSR_GR_CD
					  ,ISNULL(R.MSR_NVL, CONVERT(FLOAT,0))	AS MSR_NVL
					  ,ISNULL(R.MSR_DDN, CONVERT(FLOAT,0))	AS MSR_DDN
					  ,R.MSR_SEQ 
				 FROM #AV_LD_OP_PF_QL  R  
				WHERE R.MSR_SEQ = 1  -- AV_RT : 조업률/조업일수 
				UNION ALL 
				SELECT C.MDL_ALTER_KEY
					  ,C.LN_ALTER_KEY
					  ,C.MSR_TP_CD
					  ,C.YYYYMM
					  ,C.MSR_GR_CD
					  ,C.MSR_NVL
					  ,CASE WHEN C.MSR_TP_CD = 'QL_RT'
							THEN ISNULL(P.MSR_DDN, CONVERT(FLOAT, 0)) -- 성능가동일수 
							-- 2024.10.22 변경전 ELSE CONVERT(FLOAT, CONVERT(NUMERIC(20,10), P.MSR_DDN * ISNULL(C.MSR_NVL, 0.)) ) 
							ELSE CONVERT(FLOAT, P.MSR_DDN * ISNULL(C.MSR_NVL, 0.) ) 
					   END AS MSR_DDN
					  ,C.MSR_SEQ 
				 FROM RECURSIVE_DATA P 
					  INNER JOIN #AV_LD_OP_PF_QL C
							  ON C.MDL_ALTER_KEY	= P.MDL_ALTER_KEY
							 AND C.LN_ALTER_KEY		= P.LN_ALTER_KEY
							 AND C.YYYYMM			= P.YYYYMM
							 AND C.MSR_SEQ  		= P.MSR_SEQ + 1
			)
			SELECT C.MDL_ALTER_KEY
				  ,C.LN_ALTER_KEY
				  ,C.MSR_TP_CD
				  ,C.YYYYMM
				  ,C.MSR_GR_CD
				  ,CONVERT(FLOAT, C.MSR_NVL)	AS MSR_NVL	  -- 2024.10.22 numerci(20,10) to float 
				  ,CONVERT(FLOAT, 							  -- 2024.10.22 numerci(20,10) to float 
				   CASE WHEN C.MSR_TP_CD = 'QL_RT'
						THEN C.MSR_DDN * PM.PPM  -- 양품가동일수 : 성능가동일수 * PPM 
						ELSE C.MSR_DDN
				    END)								AS MSR_DDN
				  ,C.MSR_SEQ 
			 INTO #MSR_DDN
			 FROM RECURSIVE_DATA C
					  LEFT JOIN #PPM PM  
							  ON PM.MDL_ALTER_KEY	= C.MDL_ALTER_KEY
							 AND PM.LN_ALTER_KEY	= C.LN_ALTER_KEY
							 AND PM.YYYYMM			= C.YYYYMM
			WHERE 1=1

			-------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Loss 모델별 Cutoff Data - 조업/부하/시간가동/성능가동/양품가동 비율/일수 수정' 
			-------------------------------------------------------------------------------------------------------------------------------
			UPDATE LP
		        SET LP.MSR_NVL = MD.MSR_NVL
				   ,LP.MSR_DDN = MD.MSR_DDN 
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF LP WITH(NOLOCK)
				  INNER JOIN #MSR_DDN MD WITH(NOLOCK)
						  ON MD.MDL_ALTER_KEY = LP.MDL_ALTER_KEY 
						 AND MD.MSR_TP_CD	  = LP.MSR_TP_CD
						 AND MD.YYYYMM		  = LP.YYYYMM
			WHERE 1=1
			  AND LP.MSR_TP_CD IN ('AV_RT', 'LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')  
			  

		------------------- BEGIN 라인별 합계
		------------------- BEGIN 라인별 합계

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 일수 정보 ' 
			-------------------------------------------------------------------------------------------------------------------
			-- AV_RT : 조업율	
			-- LD_RT : 부하율	
			-- OP_RT : 시간가동률	
			-- PF_RT : 성능가동률	
			-- QL_RT : 양품가동률	
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#MSR_DDN_LN_SUM') IS NOT NULL DROP TABLE #MSR_DDN_LN_SUM;

			SELECT MC.LN_ALTER_KEY
				  ,MC.MSR_TP_CD
				  ,MC.YYYYMM
				  ,MC.MDL_NM
				  ,CONVERT(FLOAT, MC.MSR_DDN)			AS MSR_DDN
				  ,CONVERT(FLOAT, 
					SUM(CONVERT(FLOAT,MC.MSR_DDN)) OVER (PARTITION BY MC.LN_ALTER_KEY
												 , MC.MSR_TP_CD
												 , MC.YYYYMM))	AS MSR_DDN_LN_SUM 
			 INTO #MSR_DDN_LN_SUM 
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF  MC 
			WHERE 1=1
			  AND MSR_TP_CD IN ('AV_RT', 'LD_RT', 'OP_RT', 'PF_RT', 'QL_RT') 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 비부하/비가동 ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				)
			SELECT MC.LN_ALTER_KEY
				  ,MC.MSR_TP_CD
				  ,MC.YYYYMM
				  ,MC.MSR_GR_CD 
				  ,CASE WHEN LS.MSR_DDN_LN_SUM = 0
						THEN 0.
						ELSE CONVERT(FLOAT, SUM(CONVERT(FLOAT,MC.MSR_NVL)*LS.MSR_DDN))  / LS.MSR_DDN_LN_SUM
				   END  AS MSR_NVL
				  ,NULL	AS MSR_DDN
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF  MC 
				  INNER JOIN #MSR_DDN_LN_SUM LS 
						 ON LS.MSR_TP_CD	= CASE WHEN MC.MSR_GR_CD = 'NLD'
												   THEN 'AV_RT' -- 조업률
												   ELSE 'LD_RT'	-- 부하율
											  END 
						AND LS.LN_ALTER_KEY = MC.LN_ALTER_KEY
						AND LS.YYYYMM		= MC.YYYYMM
						AND LS.MDL_NM		= MC.MDL_NM
			WHERE 1=1
			  AND MC.MSR_GR_CD IN ('NLD', 'NOP') -- 비부하, 비가동 
			GROUP BY MC.LN_ALTER_KEY
					,MC.MSR_TP_CD
					,MC.YYYYMM
					,MC.MSR_GR_CD 
					,LS.MSR_DDN_LN_SUM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 성능가동률/양품가동률/이론Capa(일)' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				)
			SELECT MC.LN_ALTER_KEY
				  ,MC.MSR_TP_CD
				  ,MC.YYYYMM
				  ,MC.MSR_GR_CD 
				  ,CASE WHEN LS.MSR_DDN_LN_SUM = 0	AND MC.MSR_TP_CD = 'PF_RT'  -- 2024.08.21 분모(시간가동일수)가 0이면 성능가동률 1(100%)로 반영 
						THEN 1.
						WHEN LS.MSR_DDN_LN_SUM = 0				
						THEN 0.
						ELSE CONVERT(FLOAT, SUM(CONVERT(FLOAT, MC.MSR_NVL)*LS.MSR_DDN)) / LS.MSR_DDN_LN_SUM
				   END					AS MSR_NVL
				  ,SM.MSR_DDN_LN_SUM 	AS MSR_DDN
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF  MC 
				  INNER JOIN #MSR_DDN_LN_SUM LS		 
						 ON LS.MSR_TP_CD	= CASE WHEN MC.MSR_TP_CD = 'PF_RT'	THEN 'OP_RT' -- for 성능가동률 (가동시간)
												   WHEN MC.MSR_TP_CD = 'QL_RT'	THEN 'QL_RT' -- for 양품가동률
												   ELSE 'PF_RT'								 -- for 이론 Capa(일) 
											  END 
						AND LS.LN_ALTER_KEY = MC.LN_ALTER_KEY
						AND LS.YYYYMM		= MC.YYYYMM
						AND LS.MDL_NM		= MC.MDL_NM
				  LEFT JOIN #MSR_DDN_LN_SUM SM
						 ON SM.MSR_TP_CD	= MC.MSR_TP_CD
						AND SM.LN_ALTER_KEY = MC.LN_ALTER_KEY
						AND SM.YYYYMM		= MC.YYYYMM
						AND SM.MDL_NM		= MC.MDL_NM
			WHERE 1=1
			  AND MC.MSR_TP_CD IN ('PF_RT', 'QL_RT', 'THRY_CAPA_D') -- 성능가동률, 양품가동률 , 이론 Capa(일) 
			GROUP BY MC.LN_ALTER_KEY
					,MC.MSR_TP_CD
					,MC.YYYYMM
					,MC.MSR_GR_CD 
					,LS.MSR_DDN_LN_SUM
					,SM.MSR_DDN_LN_SUM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 부하율/시간가동률 추가 ' 
			-------------------------------------------------------------------------------------------------------------------
			;WITH MSR_DDN_INFO AS (
				  SELECT LN_ALTER_KEY
						,MSR_TP_CD
						,YYYYMM
						,CONVERT(FLOAT, ISNULL(SUM(MSR_DDN), 0.))  AS MSR_DDN
				   FROM #MSR_DDN_LN_SUM
				  WHERE 1=1
					AND MSR_TP_CD IN ('LD_RT', 'OP_RT')
				  GROUP BY LN_ALTER_KEY
						  ,MSR_TP_CD
						  ,YYYYMM
			)
			INSERT INTO #LOSS_PLAN_LN_TTZM (
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				)
			SELECT LP.LN_ALTER_KEY
				  ,CASE WHEN LP.MSR_GR_CD = 'NLD' 
						THEN 'LD_RT'
						ELSE 'OP_RT'
					END																				AS MSR_TP_CD 
				  ,LP.YYYYMM
				  ,'-'																				AS MSR_GR_CD
				  ,CONVERT(FLOAT, 1) - CONVERT(FLOAT, ISNULL(SUM(CONVERT(FLOAT, LP.MSR_NVL)), 0))	AS MSR_NVL
				  ,DI.MSR_DDN 			  
			FROM #LOSS_PLAN_LN_TTZM LP
				   LEFT JOIN MSR_DDN_INFO DI 
						  ON DI.LN_ALTER_KEY = LP.LN_ALTER_KEY
						 AND DI.MSR_TP_CD	 = CASE WHEN LP.MSR_GR_CD = 'NLD' 
													THEN 'LD_RT'
													ELSE 'OP_RT'
												END	
						 AND DI.YYYYMM		 = LP.YYYYMM
			WHERE 1=1
			  AND LP.MSR_GR_CD IN ('NLD', 'NOP') 
			GROUP BY 
				   LP.LN_ALTER_KEY
				  ,CASE WHEN LP.MSR_GR_CD = 'NLD' 
						THEN 'LD_RT'
						ELSE 'OP_RT'
					END		
				  ,LP.YYYYMM
				  ,DI.MSR_DDN

			-------------------------------------------------------------------------------------------------------------------
			-- 2024.08.13 설비대수 집계로직 변경 : 물동과 상관 없이 라인별 MAX
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 설비대수 (물동과 상관 없이 라인별 Max) '  
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_GR_CD
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_NVL
				  ,MSR_DDN
				)
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,LS.MSR_TP_CD 	AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,MAX(LS.MSR_NVL)	AS NSR_NVL
				  ,NULL				AS MSR_DDN
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF LS 
			WHERE 1=1
			  AND LS.MSR_TP_CD = 'EQP_NBU' 
			GROUP BY LS.LN_ALTER_KEY
					,LS.MSR_TP_CD
					,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 생산가동률 ' 
			-------------------------------------------------------------------------------------------------------------------
			--  라인별 합계 - PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률
			--  라인별 합계 - LD_RT : 부하율
			--  라인별 합계 - OP_RT : 시간가동률
			--  라인별 합계 - PF_RT : 성능가동률
			--  라인별 합계 - QL_RT : 양품가동률
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				)
			SELECT LP.LN_ALTER_KEY
				  ,'PROD_OP_RT' AS MSR_TP_CD
				  ,LP.YYYYMM
				  ,'-'			AS MSR_GR_CD 
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'LD_RT' THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'OP_RT' THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PF_RT' THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'QL_RT' THEN MSR_NVL ELSE 0.0 END)) AS MSR_NVL
			 FROM #LOSS_PLAN_LN_TTZM LP
			WHERE 1=1
			  AND MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')
			GROUP BY  
				   LP.LN_ALTER_KEY
				  ,LP.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 생산 CAPA(일)  ' 
			-------------------------------------------------------------------------------------------------------------------
			-- 라인별 합계 - PROD_CAPA_D : 생산 CAPA(일) : 이론 Capa(일) * 생산가동률
			-- 라인별 합계 - PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률
			-- 라인별 합계 - THRY_CAPA_D : 이론 CAPA(일) 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				)
			SELECT LP.LN_ALTER_KEY
				  ,'PROD_CAPA_D' AS MSR_TP_CD
				  ,LP.YYYYMM
				  ,'-'			AS MSR_GR_CD 
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'  THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D' THEN MSR_NVL ELSE 0.0 END)) AS MSR_NVL
			 FROM #LOSS_PLAN_LN_TTZM LP
			WHERE 1=1
			  AND MSR_TP_CD IN ('PROD_OP_RT', 'THRY_CAPA_D') 
			GROUP BY LP.LN_ALTER_KEY
				  ,LP.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 조업률 = 조업일수 / 월(년)최대조업일수 ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				)
			SELECT  
				   AV.LN_ALTER_KEY
				  ,AV.MSR_TP_CD
				  ,AV.YYYYMM
				  ,'-'										AS MSR_GR_CD
				  ,CASE WHEN AV.YYYYMM = 'BASE'			--  base 조업률 100% 
						THEN CONVERT(FLOAT, 1)
						-- 2024.05.17 임의로 조정하면 비조업+조업이 100%이 안됨. 계산상 안맞음.  WHEN MAX(AV.MSR_DDN_LN_SUM) > YM.YYYYMM_DDN
						-- 2024.05.17 임의로 조정하면 비조업+조업이 100%이 안됨. 계산상 안맞음.  THEN CONVERT(FLOAT, 1)			-- 최대 조업률 100% (초과시 100으로 맞춤) 
						ELSE CONVERT(FLOAT, MAX(AV.MSR_DDN_LN_SUM)) / YM.YYYYMM_DDN
					END										AS MSR_NVL
				  ,CASE WHEN AV.YYYYMM = 'BASE'
						THEN YM.YYYYMM_DDN
						ELSE CONVERT(FLOAT, MAX(AV.MSR_DDN_LN_SUM))					
					END										AS MSR_DDN
			 FROM #MSR_DDN_LN_SUM AV
				  INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM WITH(NOLOCK)	-- 2024/8/29 SOP 적용 
						  ON YM.YYYYMM			= AV.YYYYMM
						 AND YM.LN_ALTER_KEY	= AV.LN_ALTER_KEY
				  INNER JOIN #ALTER_KEY_INFO_FOR_LN AK  
						  ON AK.LN_ALTER_KEY	= AV.LN_ALTER_KEY
			WHERE 1=1
			  AND MSR_TP_CD = 'AV_RT'
			GROUP BY AV.LN_ALTER_KEY
					,AV.MSR_TP_CD
					,AV.YYYYMM
					,YM.YYYYMM_DDN

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 생산 CAPA(월) ' 
			-------------------------------------------------------------------------------------------------------------------
			-- 라인별 합계 - PROD_CAPA_M : 생산 CAPA(월) : 생산 CAPA(일) * 최대조업일수
			-- 최대조업일수 : 해당월 또는 해당년도의 Total 일수
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				)
			SELECT LP.LN_ALTER_KEY
				  ,'PROD_CAPA_M'				AS MSR_TP_CD
				  ,LP.YYYYMM
				  ,'-'							AS MSR_GR_CD 
				  ,CONVERT(FLOAT, LP.MSR_NVL) * YM.YYYYMM_DDN	AS MSR_NVL		-- 해당월/년 Total Capa (2024.05.09) 
			 FROM #LOSS_PLAN_LN_TTZM LP
				  INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM WITH(NOLOCK)	-- 2024/8/29 SOP 적용 
						  ON YM.YYYYMM			= LP.YYYYMM
						 AND YM.LN_ALTER_KEY	= LP.LN_ALTER_KEY
			WHERE 1=1
			  AND MSR_TP_CD = 'PROD_CAPA_D'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - SCP 생산계획 ' 
			-------------------------------------------------------------------------------------------------------------------
			-- 라인별 합계 - SCP 생산 계획 = 생산 CAPA(일) * 조업률 * 월(년)일수
			-- 라인별 합계 - SCP 생산 계획 = 생산 CAPA(일) * 조업일수
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				)
			SELECT LP.LN_ALTER_KEY
				  ,'SCP_PROD_PLAN' AS MSR_TP_CD
				  ,LP.YYYYMM
				  ,'-'			AS MSR_GR_CD 
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_CAPA_D'  THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'AV_RT'		 THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(YM.YYYYMM_DDN))
				   AS MSR_NVL
			 FROM #LOSS_PLAN_LN_TTZM LP
				  INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM WITH(NOLOCK)	-- 2024/8/29 SOP 적용 
						  ON YM.YYYYMM			= LP.YYYYMM
						 AND YM.LN_ALTER_KEY	= LP.LN_ALTER_KEY
			WHERE 1=1
			  AND MSR_TP_CD IN ('PROD_CAPA_D', 'AV_RT') 
			  AND LP.YYYYMM != 'BASE'
			GROUP BY LP.LN_ALTER_KEY
					,LP.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - TEEP ' 
			-------------------------------------------------------------------------------------------------------------------
			-- 라인별 합계 - TEEP : 생산가동률 * 조업률
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				)
			SELECT LP.LN_ALTER_KEY
				  ,'TEEP' AS MSR_TP_CD
				  ,LP.YYYYMM
				  ,'-'			AS MSR_GR_CD 
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'  THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'AV_RT'		THEN MSR_NVL ELSE 0.0 END)) AS MSR_NVL
			 FROM #LOSS_PLAN_LN_TTZM LP
			WHERE 1=1
			  AND MSR_TP_CD IN ('PROD_OP_RT', 'AV_RT') 
			GROUP BY LP.LN_ALTER_KEY
				  ,LP.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 비조업 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				)
			SELECT AK.LN_ALTER_KEY
				  ,LP.MSR_TP_CD
				  ,LP.YYYYMM
				  ,LP.MSR_GR_CD
				  ,LP.MSR_NVL
			 FROM SCP_MST_CAPA_LOSS_PLAN_LN LP WITH(NOLOCK) 
				  INNER JOIN #ALTER_KEY_INFO_FOR_LN AK  
						  ON AK.DIVISION_ID		= LP.DIVISION_ID		
						 AND AK.PLANT_ID		= LP.PLANT_ID		
						 AND AK.LINE_ID			= LP.LINE_ID			
						 AND AK.OPERATION_ID	= LP.OPERATION_ID	
						 AND AK.ELTR_LN_TP_CD	= LP.ELTR_LN_TP_CD	
						 AND AK.COMPANY_ID		= LP.COMPANY_ID		
						 AND AK.SITE_ID			= LP.SITE_ID			
						 AND AK.FACTORY_ID		= LP.FACTORY_ID		
			WHERE 1=1
			  AND LP.DIVISION_ID	=  @V_DIVISION_ID
			  AND LP.MSR_TP_CD	   != 'WT_RT'			-- 물동없음(주문대기) 제외
			  AND LP.MSR_GR_CD	    = 'NAV'	-- 비조업

 			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 라인별 Loss Plan Cutoff - WT_RT : 물동없음(주문대기) 추가' 
			-- 물동없음(주문대기) = 최대조업일수(월일수) - 라인별 조업일수(AV_RT) - 비조업일수합(MC_RT + SD_RT + TD_RT)
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				)
			SELECT   LP.LN_ALTER_KEY
					,'WT_RT'	AS MSR_TP_CD 
					,LP.YYYYMM
					,'NAV'		AS MSR_GR_CD 
					,   CONVERT(FLOAT, ISNULL(MAX(CASE WHEN LP.MSR_TP_CD = 'AV_RT'		THEN YM.YYYYMM_DDN					ELSE 0.  END), 0.))
					  - CONVERT(FLOAT, ISNULL(MAX(CASE WHEN LP.MSR_TP_CD = 'AV_RT'		THEN CONVERT(FLOAT, LP.MSR_DDN)		ELSE 0.  END), 0.))
					  - CONVERT(FLOAT, ISNULL(SUM(CASE WHEN LP.MSR_GR_CD = 'NAV'		THEN CONVERT(FLOAT, LP.MSR_NVL)		ELSE 0.  END), 0.))   AS MSR_NVL	-- 20240726 비조업일 SUM 적용
					,NULL		AS MSR_DDN	-- 2024.10.23 조립 비조업 MSR_DDN null 처리 (MSR_NVL값이 일수임)
			   FROM #LOSS_PLAN_LN_TTZM LP
					INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM WITH(NOLOCK)	-- 2024/8/29 SOP 적용 
						    ON YM.YYYYMM		= LP.YYYYMM
						   AND YM.LN_ALTER_KEY	= LP.LN_ALTER_KEY
			  WHERE 1=1
				AND (LP.MSR_TP_CD = 'AV_RT' OR LP.MSR_GR_CD = 'NAV') 
			GROUP BY LP.LN_ALTER_KEY
					,LP.YYYYMM

 			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - PPM 추가' 
			-- PPM = 이론 Capa(일) / 1440 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				)
			SELECT   LP.LN_ALTER_KEY
					,'PPM'													AS MSR_TP_CD 
					,LP.YYYYMM
					,'-'													AS MSR_GR_CD 
					,CONVERT(FLOAT, LP.MSR_NVL) / CONVERT(FLOAT, 1440)		AS MSR_NVL
			   FROM #LOSS_PLAN_LN_TTZM LP
			  WHERE 1=1
				AND LP.MSR_TP_CD = 'THRY_CAPA_D'	-- 이론 Capa(일) 

 			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - Tact Time(대당 평균) 추가' 
			-- Tact Time = 60 / (PPM / 설비대수) 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				)
			SELECT   LP.LN_ALTER_KEY
					,'TACT_TIME'		AS MSR_TP_CD 
					,LP.YYYYMM
					,'-'				AS MSR_GR_CD 
					,CASE WHEN ISNULl(MAX(CASE WHEN LP.MSR_TP_CD = 'PPM' THEN LP.MSR_NVL ELSE 0. END),0) = 0 
							   OR
							   ISNULl(MAX(CASE WHEN LP.MSR_TP_CD = 'EQP_NBU' THEN LP.MSR_NVL ELSE 0. END),0) = 0 
						  THEN 0.
						  ELSE CONVERT(FLOAT, 60)
									/ ( CONVERT(FLOAT, CONVERT(NUMERIC(20,10), MAX(CASE WHEN LP.MSR_TP_CD = 'PPM'		THEN LP.MSR_NVL ELSE 0. END)))
									  / CONVERT(FLOAT, CONVERT(NUMERIC(20,10), MAX(CASE WHEN LP.MSR_TP_CD = 'EQP_NBU'	THEN LP.MSR_NVL ELSE 0. END)))
									  )
					 END				AS MSR_NVL
			   FROM #LOSS_PLAN_LN_TTZM LP
			  WHERE 1=1
				AND LP.MSR_TP_CD IN ('EQP_NBU', 'PPM')
			GROUP BY LP.LN_ALTER_KEY
					,LP.YYYYMM
				
		------------------- End 라인별 합계 
		------------------- End 라인별 합계 

		------------------- STart 라인별 합계 PRVS 
		------------------- STart 라인별 합계 PRVS 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 PRVS  - 이전 버전 Capa Plan의 당월 계획 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#PRVS_CAPA_LOSS_PLAN') IS NOT NULL DROP TABLE #PRVS_CAPA_LOSS_PLAN; 

			;WITH PRVS_CAPA_VERSION AS ( 
				SELECT TOP 1 
						  ISNULL(VER_ID, '')		AS PRVS_VER_ID
						, ISNULL(VER_SEQ, 0)		AS PRVS_VER_SEQ
						, ISNULL(DIVISION_ID, '')	AS DIVISION_ID 
						, PROG_STAT 
				 FROM SCP_MST_CAPA_VERSION PV WITH(NOLOCK)
				WHERE 1=1
				  AND DIVISION_ID					= @V_DIVISION_ID
				  AND VER_ID						= @V_RP_YYYYMM		-- M-2월에 수립한 계획 
				  AND PROG_STAT						= '2'				-- 이전 2차 컷오프 완료된 최종 버전 
				  AND ISNULL(BIZ_PLAN_USE_YN,'N')	!= 'Y'				-- 사업계획이 아니면 RP로 간주함 
				ORDER BY VER_ID		DESC
				       , VER_SEQ	DESC 
			)
			SELECT LP.DIVISION_ID
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,LP.MSR_TP_CD
				  ,LP.MSR_GR_CD 
				  ,'PRVS'									AS YYYYMM
				  ,CONVERT(NUMERIC(20,10), LP.MSR_NVL	)	AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), LP.MSR_DDN	)	AS MSR_DDN
				  ,LP.ATTRIBUTE1
				  ,LP.ATTRIBUTE2	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE3	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE4	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE5	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE6	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE7	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE8	-- 2024.09.24 추가
				  ,LP.VER_ID		AS PRVS_VER_ID
				  ,LP.VER_SEQ		AS PRVS_VER_SEQ
				  ,LP.YYYYMM		AS REF_YYYYMM -- 2024.09.24 추가 
			 INTO #PRVS_CAPA_LOSS_PLAN 
			 FROM SCP_MST_CAPA_LOSS_PLAN_LN_CUTF  LP WITH(NOLOCK) 
				  INNER JOIN PRVS_CAPA_VERSION PV 
						  ON PV.PRVS_VER_ID		= LP.VER_ID
						 AND PV.PRVS_VER_SEQ	= LP.VER_SEQ
						 AND PV.DIVISION_ID		= LP.DIVISION_ID
			WHERE 1=1
			  AND LP.YYYYMM = @V_LOSS_RSLT_YYYYMM  -- 6/10 M-1월(실적과 동일 년월) 계획

		------------------- END 라인별 합계 PRVS 
		------------------- END 라인별 합계 PRVS 


		------------------- STart 라인별 합계 BIZP 사업계획
		------------------- STart 라인별 합계 BIZP 사업계획

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 BIZP  - 사업계획버전 Capa Plan의 당월 계획 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#BIZP_CAPA_LOSS_PLAN') IS NOT NULL DROP TABLE #BIZP_CAPA_LOSS_PLAN; 

			;WITH BIZP_CAPA_VERSION AS ( 
				SELECT TOP 1 
						  ISNULL(VER_ID, '')		AS BIZP_VER_ID
						, ISNULL(VER_SEQ, 0)		AS BIZP_VER_SEQ
						, ISNULL(DIVISION_ID, '')	AS DIVISION_ID 
						, PROG_STAT 
				 FROM SCP_MST_CAPA_VERSION PV WITH(NOLOCK)
				WHERE 1=1
				  AND DIVISION_ID		= @V_DIVISION_ID
				  AND VER_ID		    LIKE CONCAT(@V_BIZP_YYYY , '%')		-- 2024/10/29 전월기준 전년도에 수립한 사업계획 버전
				  AND PROG_STAT			= '2'	-- 이전 2차 컷오프 완료된 버전 
				  AND BIZ_PLAN_USE_YN	= 'Y'	-- 사업계획
				ORDER BY VER_ID		DESC
				       , VER_SEQ	DESC 
			)
			SELECT LP.DIVISION_ID
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,LP.MSR_TP_CD
				  ,LP.MSR_GR_CD 
				  ,'BIZP'			AS YYYYMM
				  ,CONVERT(NUMERIC(20,10), LP.MSR_NVL)	AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), LP.MSR_DDN)	AS MSR_DDN
				  ,LP.ATTRIBUTE1
				  ,LP.ATTRIBUTE2	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE3	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE4	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE5	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE6	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE7	-- 2024.09.24 추가
				  ,LP.ATTRIBUTE8	-- 2024.09.24 추가
				  ,LP.VER_ID		AS BIZP_VER_ID
				  ,LP.VER_SEQ		AS BIZP_VER_SEQ
				  ,LP.YYYYMM		AS REF_YYYYMM -- 2024.09.24 추가 
			 INTO #BIZP_CAPA_LOSS_PLAN
			 FROM SCP_MST_CAPA_LOSS_PLAN_LN_CUTF LP WITH(NOLOCK) 
				  INNER JOIN BIZP_CAPA_VERSION BV 
						  ON BV.BIZP_VER_ID		= LP.VER_ID
						 AND BV.BIZP_VER_SEQ	= LP.VER_SEQ
						 AND BV.DIVISION_ID		= LP.DIVISION_ID
			WHERE 1=1
			  AND LP.YYYYMM = @V_LOSS_RSLT_YYYYMM -- 실적과 동일월  6/11 --- @V_VER_ID  -- 당월 계획 (사업계획 Capa버전의 당월계획) 

		------------------- End  라인별 합계 BIZP 사업계획
		------------------- End  라인별 합계 BIZP 사업계획


		------------------- START 라인별 합계 실적 
		------------------- START 라인별 합계 실적 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 실적(M-1)  - 비부하/비가동/성능가동률/양품가동률 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#LOSS_RSLT_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_RSLT_WITH_ALTER_KEY

			SELECT AK.LN_ALTER_KEY
				  ,LR.LOSS_GR_CD	AS MSR_GR_CD
				  ,CASE WHEN LR.LOSS_CD = 'QL_RT_LN' 
						THEN 'QL_RT' 
						ELSE LR.LOSS_CD 
					END 			AS MSR_TP_CD
				  ,'RSLT'			AS YYYYMM
				  ,CONVERT(NUMERIC(20,10),
					CASE WHEN LR.LOSS_GR_CD = 'NAV' 
						THEN CONVERT(FLOAT, LR.LOSS_RT) * CONVERT(FLOAT, LR.ATTRIBUTE1)  -- 2024/10/29 지표 제외 적용 실적 최대조업일수 적용 
						ELSE LR.LOSS_RT 
					END)											AS MSR_NVL	-- 5/14 비조업 일수로 반영 필요 
				  ,MAX(CASE WHEN LR.LOSS_CD = 'AV_RT' 
							THEN CONVERT(FLOAT, LR.ATTRIBUTE1) 
							ELSE NULL
						END)  OVER (PARTITION BY AK.LN_ALTER_KEY)	AS YYYYMM_DDN	-- 2024/10/29 지표 제외 적용 실적 최대조업일수
			 INTO #LOSS_RSLT_WITH_ALTER_KEY 
			 FROM SCM_DNM_LOSS_LN_MMLY LR WITH(NOLOCK) 
				  INNER JOIN #ALTER_KEY_INFO_FOR_LN AK
						  ON AK.DIVISION_ID	  = LR.DIVISION_ID
						 AND AK.PLANT_ID	  = LR.PLANT_ID
						 AND AK.LINE_ID		  = LR.LINE_ID
						 AND AK.OPERATION_ID  = LR.OPERATION_ID
						 AND AK.ELTR_LN_TP_CD = LR.ELTR_LN_TP_CD
						 AND AK.COMPANY_ID	  = LR.COMPANY_ID
						 AND AK.SITE_ID		  = LR.SITE_ID
						 AND AK.FACTORY_ID	  = LR.FACTORY_ID
			WHERE 1=1 
			  AND LR.LOSS_YM		= @V_LOSS_RSLT_YYYYMM
			  AND LR.PERD_DIVS_CD	= '1'	-- M-1월 1개월실적 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 실적(M-1)  - SOP적용된 실적(RSLT) 최대조업일수 Update' -- 2024/10/29 
			-------------------------------------------------------------------------------------------------------------------
			UPDATE SO SET SO.YYYYMM_DDN = AV.YYYYMM_DDN   
			 FROM #YYYYMM_DAYS_INFO_APPLIED_SOP SO
				  INNER JOIN #LOSS_RSLT_WITH_ALTER_KEY AV
						  ON AV.YYYYMM			= SO.YYYYMM 
						 AND AV.LN_ALTER_KEY	= SO.LN_ALTER_KEY
						 AND AV.MSR_TP_CD		= 'AV_RT'
			WHERE 1=1

			------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 실적(M-1) - 설비대수/TactTime(대당평균)/PPM/이론Capa(일) 추가 ' 
			-- 2024/06/10 M-2월에 계획한 M-1월 계획
			-------------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_RSLT_WITH_ALTER_KEY
			SELECT AK.LN_ALTER_KEY
				  ,LP.MSR_GR_CD
				  ,LP.MSR_TP_CD
				  ,'RSLT'			AS YYYYMM
				  ,LP.MSR_NVL
				  ,NULL				AS YYYYMM_DDN 
			FROM #PRVS_CAPA_LOSS_PLAN  LP
				  INNER JOIN #ALTER_KEY_INFO_FOR_LN AK
						  ON AK.DIVISION_ID		= LP.DIVISION_ID
						 AND AK.PLANT_ID		= LP.PLANT_ID 
						 AND AK.LINE_ID			= LP.LINE_ID 
						 AND AK.OPERATION_ID	= LP.OPERATION_ID 
						 AND AK.ELTR_LN_TP_CD	= LP.ELTR_LN_TP_CD 
						 AND AK.COMPANY_ID		= LP.COMPANY_ID 
						 AND AK.SITE_ID			= LP.SITE_ID 
						 AND AK.FACTORY_ID		= LP.FACTORY_ID 
			WHERE 1=1
			  AND LP.MSR_TP_CD IN ('EQP_NBU', 'TACT_TIME', 'PPM', 'THRY_CAPA_D') 

			------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 실적(M-1) - 생산 Capa(일) 추가 ' 
			-------------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_RSLT_WITH_ALTER_KEY
			SELECT LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'PROD_CAPA_D'	AS MSR_TP_CD
				  ,'RSLT'			AS YYYYMM
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'  THEN MSR_NVL ELSE NULL END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D' THEN MSR_NVL ELSE NULL END))	AS MSR_NVL
				  ,NULL				AS YYYYMM_DDN 
			 FROM #LOSS_RSLT_WITH_ALTER_KEY
			WHERE 1=1
			  AND MSR_TP_CD IN ('PROD_OP_RT', 'THRY_CAPA_D')
			GROUP BY LN_ALTER_KEY

			------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 실적(M-1) - 생산 Capa(월) 추가 ' 
			-------------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_RSLT_WITH_ALTER_KEY
			SELECT LR.LN_ALTER_KEY
				  ,'-'						AS MSR_GR_CD
				  ,'PROD_CAPA_M'			AS MSR_TP_CD
				  ,LR.YYYYMM				AS YYYYMM
				  ,CONVERT(FLOAT, MSR_NVL) * YM.YYYYMM_DDN	AS MSR_NVL
				  ,YM.YYYYMM_DDN			
			 FROM #LOSS_RSLT_WITH_ALTER_KEY LR
				   INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM WITH(NOLOCK)	-- 2024/8/29 SOP 적용 
						  ON YM.YYYYMM		= LR.YYYYMM
						 AND YM.LN_ALTER_KEY= LR.LN_ALTER_KEY
			WHERE 1=1
			  AND MSR_TP_CD = 'PROD_CAPA_D'
			  AND LR.YYYYMM = 'RSLT'

 			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 실적(M-1) 결과 추가'   
			-------------------------------------------------------------------------------------------------------------------
			--- 2024.05.17 base포함 당월계획 + result 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,MSR_GR_CD
				  ,YYYYMM
				  ,MSR_NVL
				  ,ATTRIBUTE10 
				)
			SELECT LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,MSR_GR_CD
				  ,YYYYMM
				  ,MSR_NVL
				  ,'[RSLT_LOSS_YM='+@V_LOSS_RSLT_YYYYMM+']'	AS ATTRIBUTE10
			 FROM #LOSS_RSLT_WITH_ALTER_KEY

		------------------- END 라인별 합계 실적 
		------------------- END 라인별 합계 실적 


		------------------- START 라인별 합계 부가정보 추가  5/21 
		------------------- START 라인별 합계 부가정보 추가  5/21 
			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 라인별 합계 부가정보 - 조업율/부하율/시간가동률/성능가동률/양품가동률 ' 
			------------------------------------------------------------------------------------------------------------------
			-- AV_RT	조업율
			-- LD_RT	부하율
			-- OP_RT	시간가동률
			-- PF_RT	성능가동률
			-- QL_RT	양품가동률
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#AV_LD_OP_PF_QL_LN') IS NOT NULL DROP TABLE #AV_LD_OP_PF_QL_LN;

			SELECT LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,CONVERT(FLOAT, MSR_NVL)	AS MSR_NVL
				  ,CASE WHEN MSR_TP_CD = 'AV_RT' THEN 1
						WHEN MSR_TP_CD = 'LD_RT' THEN 2
						WHEN MSR_TP_CD = 'OP_RT' THEN 3
						WHEN MSR_TP_CD = 'PF_RT' THEN 4
						WHEN MSR_TP_CD = 'QL_RT' THEN 5
					END MSR_SEQ 
			 INTO #AV_LD_OP_PF_QL_LN
			 FROM #LOSS_PLAN_LN_TTZM  
			WHERE 1=1
			  AND MSR_TP_CD IN ('AV_RT', 'LD_RT', 'OP_RT', 'PF_RT', 'QL_RT') 

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 라인별 합계 부가정보 - 조업/부하/시간가동/성능가동/양품가동 일수' 
			------------------------------------------------------------------------------------------------------------------
			-- 일수정보 : MSR_DDN 
			-- AV_RT	조업율		: 조업일수		= 생산 Capa(월) / 생산 Capa(일)
			-- LD_RT	부하율		: 부하일수		= 조업일수 * 부하율
			-- OP_RT	시간가동률	: 시간가동일수	= 부하일수 * 시간가동률
			-- PF_RT	성능가동률	: 성능가동일수	= 시간가동일수 * 성능가동률
			-- QL_RT	양품가동률	: 양품가동일수	= 성능가동일수 * 양품가동률
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#MSR_DDN_LN') IS NOT NULL DROP TABLE #MSR_DDN_LN;

			;WITH RECURSIVE_DATA AS (
				SELECT R.LN_ALTER_KEY
					  ,R.MSR_TP_CD
					  ,R.YYYYMM
					  ,R.MSR_GR_CD
					  ,CONVERT(FLOAT, ISNULL(R.MSR_NVL, 0))									AS MSR_NVL	-- 조업률
					  ,YM.YYYYMM_DDN														AS P_DDN	-- 최대조업일수
					  ,CONVERT(FLOAT, ISNULL(R.MSR_NVL, 0) * YM.YYYYMM_DDN)					AS C_DDN		-- 조업일수
					  ,R.MSR_SEQ 
				 FROM #AV_LD_OP_PF_QL_LN  R  
					   INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM WITH(NOLOCK)	-- 2024/8/29 SOP 적용 
							  ON YM.YYYYMM		= R.YYYYMM
							 AND YM.LN_ALTER_KEY= R.LN_ALTER_KEY
				WHERE R.MSR_SEQ = 1  -- AV_RT : 조업률/조업일수 
				UNION ALL 
				SELECT C.LN_ALTER_KEY
					  ,C.MSR_TP_CD
					  ,C.YYYYMM
					  ,C.MSR_GR_CD
					  ,C.MSR_NVL
					  ,P.C_DDN																AS P_DDN	
					  ,CONVERT(FLOAT, CONVERT(NUMERIC(20,10), C.MSR_NVL * P.C_DDN))			AS C_DDN
					  ,C.MSR_SEQ 
				 FROM RECURSIVE_DATA P 
					  INNER JOIN #AV_LD_OP_PF_QL_LN C
							  ON C.LN_ALTER_KEY		= P.LN_ALTER_KEY
							 AND C.YYYYMM			= P.YYYYMM
							 AND C.MSR_SEQ  		= P.MSR_SEQ + 1
			)
			SELECT C.LN_ALTER_KEY
				  ,C.MSR_TP_CD
				  ,C.YYYYMM
				  ,C.MSR_GR_CD
				  ,CONVERT(NUMERIC(20,10), C.MSR_NVL )	AS 	MSR_NVL
				  ,CONVERT(NUMERIC(20,10), C.P_DDN	 )	AS 	P_DDN	
				  ,CONVERT(NUMERIC(20,10), C.C_DDN	 )	AS 	C_DDN	
				  ,MSR_SEQ
			 INTO #MSR_DDN_LN
			 FROM RECURSIVE_DATA C
			WHERE 1=1

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 라인별 합계 부가정보 - 설비대수/이론Capa/TEEP' 
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#EQP_NBU_THRY_CAPA_D') IS NOT NULL DROP TABLE #EQP_NBU_THRY_CAPA_D;

			SELECT LP.LN_ALTER_KEY
				  ,LP.YYYYMM
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN LP.MSR_TP_CD = 'EQP_NBU'		THEN MSR_NVL ELSE NULL END))		AS EQP_NBU
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN LP.MSR_TP_CD = 'THRY_CAPA_D'	THEN MSR_NVL ELSE NULL END))		AS THRY_CAPA_D
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN LP.MSR_TP_CD = 'TEEP'			THEN MSR_NVL ELSE NULL END))		AS TEEP
				  ,CONVERT(NUMERIC(20,10), MAX(YM.YYYYMM_DDN))																AS YYYYMM_DDN													
			 INTO #EQP_NBU_THRY_CAPA_D
			 FROM #LOSS_PLAN_LN_TTZM LP
				   INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM WITH(NOLOCK)	-- 2024/8/29 SOP 적용 
						  ON YM.YYYYMM		= LP.YYYYMM
						 AND YM.LN_ALTER_KEY= LP.LN_ALTER_KEY
			WHERE 1=1
			  AND LP.MSR_TP_CD IN ('EQP_NBU', 'THRY_CAPA_D', 'TEEP') 
			GROUP BY LP.LN_ALTER_KEY
				    ,LP.YYYYMM

			--------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 라인별 합계 부가정보 - 조업/부하/시간가동/성능가동/양품가동 일수/비율' 
			--------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#AV_LD_OP_PF_QL_LN_RT_DDN') IS NOT NULL DROP TABLE #AV_LD_OP_PF_QL_LN_RT_DDN;

			SELECT LN_ALTER_KEY
				  ,YYYYMM
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'AV_RT' THEN MSR_NVL	ELSE NULL END))	AS AV_RT
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'LD_RT' THEN MSR_NVL	ELSE NULL END))	AS LD_RT
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'OP_RT' THEN MSR_NVL	ELSE NULL END))	AS OP_RT
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'PF_RT' THEN MSR_NVL	ELSE NULL END))	AS PF_RT
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'QL_RT' THEN MSR_NVL	ELSE NULL END))	AS QL_RT
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'AV_RT' THEN P_DDN		ELSE NULL END))	AS YYYYMM_DDN
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'AV_RT' THEN C_DDN		ELSE NULL END))	AS AV_DDN
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'LD_RT' THEN C_DDN		ELSE NULL END))	AS LD_DDN
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'OP_RT' THEN C_DDN		ELSE NULL END))	AS OP_DDN
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'PF_RT' THEN C_DDN		ELSE NULL END))	AS PF_DDN
				  ,CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'QL_RT' THEN C_DDN		ELSE NULL END))	AS QL_DDN
			 INTO #AV_LD_OP_PF_QL_LN_RT_DDN
			 FROM #MSR_DDN_LN
			where 1=1
			GROUP BY LN_ALTER_KEY
				    ,YYYYMM

		------------------- END 라인별 합계 부가정보 추가    5/21 
		------------------- END 라인별 합계 부가정보 추가    5/21 

----------------------- End 조립/팩 -------------------------------------------------------------------------------------------------------
----------------------- End 조립/팩 -------------------------------------------------------------------------------------------------------
----------------------- End 조립/팩 -------------------------------------------------------------------------------------------------------



----------------------- Start 전극 -------------------------------------------------------------------------------------------------------
----------------------- Start 전극 -------------------------------------------------------------------------------------------------------
----------------------- Start 전극 -------------------------------------------------------------------------------------------------------

			----------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 템프테이블 라인별 LOSS  -  #ELTR_LOSS_PLAN_LN' 
			----------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_LOSS_PLAN_LN') IS NOT NULL DROP TABLE #ELTR_LOSS_PLAN_LN;

			SELECT CONVERT(BIGINT, 1) AS LN_ALTER_KEY
				  ,MSR_GR_CD
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,CONVERT(NUMERIC(20,10), MSR_NVL)			AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), MSR_DDN)			AS MSR_DDN
				  ,CONVERT(NUMERIC(20,10), ATTRIBUTE1)		AS ATTRIBUTE1 
				  ,ATTRIBUTE10
			 INTO #ELTR_LOSS_PLAN_LN
			 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_LN WITH(NOLOCK)
			WHERE 1=2  --- 빈테이블 

			--------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 템프테이블 모델별 LOSS Cutoff 데이터 -  #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF' 
			--------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF;

			SELECT CONVERT(INTEGER, 0) AS MDL_ALTER_KEY 
				  ,CONVERT(INTEGER, 0) AS LN_ALTER_KEY 
				  ,DIVISION_ID
				  ,MDL_NM
				  ,PLANT_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,COMPANY_ID
				  ,SITE_ID
				  ,FACTORY_ID
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,CONVERT(NUMERIC(20,10), PFRSLT_NVL)		AS PFRSLT_NVL
				  ,CONVERT(NUMERIC(20,10), BASE_NVL)		AS BASE_NVL
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,CONVERT(NUMERIC(20,10), IPRV_GOL_RT)		AS IPRV_GOL_RT
				  ,MSR_GR_CD
				  ,CONVERT(NUMERIC(20,10), MSR_NVL)			AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), MSR_DDN)			AS MSR_DDN
			 INTO #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
			 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF WITH(NOLOCK)
			WHERE 1=2 

			-------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 모델별 Loss Plan Cutoff  -  #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF' 
			-------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
			SELECT  DENSE_RANK() OVER (PARTITION BY 'A' 
										  ORDER BY LS.MDL_NM
												  ,LS.PLANT_ID
												  ,LS.FACTORY_ID	
												  ,LS.LINE_ID
												  ,LS.OPERATION_ID
												  ,LS.DIVISION_ID
												  ,LS.COMPANY_ID
												  ,LS.SITE_ID
												) AS MDL_ALTER_KEY
					,DENSE_RANK() OVER (PARTITION BY 'A' 
										  ORDER BY LS.PLANT_ID
												  ,LS.FACTORY_ID	
												  ,LS.LINE_ID
												  ,LS.OPERATION_ID
												  ,LS.DIVISION_ID
												  ,LS.COMPANY_ID
												  ,LS.SITE_ID
												) AS LN_ALTER_KEY
					,LS.DIVISION_ID
					,LS.MDL_NM
					,LS.PLANT_ID
					,LS.LINE_ID
					,LS.OPERATION_ID
					,LS.ELTR_LN_TP_CD
					,LS.COMPANY_ID
					,LS.SITE_ID
					,LS.FACTORY_ID
					,CASE WHEN LS.MSR_TP_CD = 'AV_RT' AND LS.MDL_NM != '-'   -- 2024.08.29 for 모델별 조업률(일) 재계산 반영  
						  THEN 'AV_RT_OLD'
						  ELSE LS.MSR_TP_CD
					 END					AS MSR_TP_CD
					,LS.YYYYMM
				    ,LS.PFRSLT_NVL			AS PFRSLT_NVL
				    ,LS.BASE_NVL			AS BASE_NVL
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,LS.IPRV_GOL_DIVS_CD
				    -- 2025.02.05 개선/목표일 관리 기능 삭제 ,LS.IPRV_GOL_RT			AS IPRV_GOL_RT
					,LS.MSR_GR_CD
				    ,LS.MSR_NVL				AS MSR_NVL
				    ,LS.MSR_DDN				AS MSR_DDN 
			FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS WITH(NOLOCK) 
			WHERE 1=1
			  AND LS.VER_ID		 = @V_VER_ID
			  AND LS.VER_SEQ	 = @V_VER_SEQ
			  AND LS.DIVISION_ID = @V_DIVISION_ID
			  AND LS.MSR_TP_CD NOT IN ('PROD_TM')	-- 생산시간 제외 


			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 ALTER KEY 정보 - #ELTR_ALTER_KEY_INFO_LN' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_ALTER_KEY_INFO_LN') IS NOT NULL DROP TABLE #ELTR_ALTER_KEY_INFO_LN

			SELECT 
				   LS.LN_ALTER_KEY
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,MAX(LS.ELTR_LN_TP_CD)	AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외 
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
			INTO #ELTR_ALTER_KEY_INFO_LN 
			FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS  WITH(NOLOCK)
			GROUP BY 
				   LS.LN_ALTER_KEY
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 월별 일수 정보 -  #ELTR_YYYYMM_DAYS_INFO' 
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_YYYYMM_DAYS_INFO') IS NOT NULL DROP TABLE #ELTR_YYYYMM_DAYS_INFO;

			SELECT DISTINCT YYYYMM
						   ,CONVERT(FLOAT, 
								CASE WHEN LEN(YYYYMM) = 4  
									 THEN DATEDIFF(DD, CONVERT(DATE, YYYYMM+'0101', 112)
													 , DATEADD(YY, 1, CONVERT(DATE, YYYYMM+'0101', 112)))   -- 년일수 
									 ELSE DATEDIFF(DD, CONVERT(DATE, YYYYMM+'01', 112)
													 , DATEADD(MM, 1, CONVERT(DATE, YYYYMM+'01', 112)))		-- 월일수
								END)  AS YYYYMM_DDN 
			 INTO #ELTR_YYYYMM_DAYS_INFO
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS WITH(NOLOCK)
			WHERE 1=1
			  AND YYYYMM NOT IN ('BASE', 'RSLT', 'PRVS', 'BIZP') 
			UNION ALL
			SELECT 'BASE'
			      ,CONVERT(FLOAT, DATEDIFF(DD, CONVERT(DATE, @V_VER_ID+'01', 112)
													  , DATEADD(MM, 1, CONVERT(DATE, @V_VER_ID+'01', 112))))		     -- 월일수 base (버전 당월) 
			UNION ALL
			SELECT 'RSLT'
			      ,CONVERT(FLOAT, DATEDIFF(DD, CONVERT(DATE, @V_LOSS_RSLT_YYYYMM+'01', 112)
													  , DATEADD(MM, 1, CONVERT(DATE, @V_LOSS_RSLT_YYYYMM+'01', 112))))	-- 실적 월 일수 (M-1월)

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - SOP Master 정보 - #SCP_MST_CAPA_ELTR_LINE_SOP' -- 2024.08.30   
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_SOP') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_SOP

			SELECT SP.DIVISION_ID
				  ,SP.COMPANY_ID
				  ,SP.SITE_ID
				  ,SP.PLANT_ID
				  ,SP.FACTORY_ID
				  ,SP.LINE_ID
				  ,SP.OPERATION_ID
				  ,SP.ELTR_LN_TP_CD
				  ,SP.VALID_YN
				  ,SP.SOP_DT
				  ,SP.SOP_YM
				  ,SP.CREATION_DATE
				  ,SP.CREATED_BY
				  ,SP.LAST_UPDATE_DATE
				  ,SP.LAST_UPDATED_BY
				  ,CONVERT(FLOAT, SP.SOP_DDN)	AS SOP_DDN 
				  ,SUBSTRING(SP.SOP_YM, 1, 4)	AS SOP_YY
				  ,CONVERT(FLOAT, DATEDIFF(DD, CONVERT(DATE, SP.SOP_DT, 112)
											 , DATEADD(YY, 1, CONVERT(DATE, SUBSTRING(SP.SOP_YM, 1, 4)+'0101', 112)))
											)	AS SOP_YY_DDN	-- 년일수
			  INTO #SCP_MST_CAPA_ELTR_LINE_SOP
			  FROM SCP_MST_CAPA_ELTR_LINE_SOP SP WITH(NOLOCK) 
			 WHERE 1=1
			   AND SP.DIVISION_ID	= @V_DIVISION_ID
			   AND SP.VALID_YN		= 'Y'
			   AND SP.SOP_DT IS NOT NULL
			   AND SP.SOP_YM IS NOT NULL
			   AND SP.SOP_DDN IS NOT NULL 
			   AND SP.SOP_DDN	   != 0 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 전극 라인별/월 일수 정보 WITH SOP - #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP'  
			-- 조립 : DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELTR_LN_TP_CD
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP') IS NOT NULL DROP TABLE #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP

			;WITH CAPA_LINE_SOP AS (
				SELECT SP.DIVISION_ID
					  ,SP.COMPANY_ID
					  ,SP.SITE_ID
					  ,SP.PLANT_ID
					  ,SP.FACTORY_ID
					  ,SP.LINE_ID
					  ,SP.OPERATION_ID
					  ,SP.SOP_DT
					  ,CASE WHEN YM.DV = 'Y'
							THEN SP.SOP_YY
							ELSE SP.SOP_YM
						END AS SOP_YM
					  ,CASE WHEN YM.DV = 'Y'
							THEN SP.SOP_YY_DDN
							ELSE SP.SOP_DDN
						END AS SOP_DDN
				 FROM #SCP_MST_CAPA_ELTR_LINE_SOP SP
					  INNER JOIN (SELECT 'Y' AS DV 
								  UNION ALL 
								  SELECT 'M' AS DV ) AS YM 
							  ON 1=1
				WHERE 1=1
			)
			SELECT AK.LN_ALTER_KEY
				  ,DI.YYYYMM
				  ,CONVERT(FLOAT,	-- 2024.09.12 
				   CASE WHEN SO.SOP_YM IS NOT NULL AND DI.YYYYMM != 'BASE' -- 2024.10.16 base sop 적용 안함 
						THEN SO.SOP_DDN
						ELSE DI.YYYYMM_DDN
					END )	AS YYYYMM_DDN
			 INTO #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP
			 FROM #ELTR_ALTER_KEY_INFO_LN AK
				   INNER JOIN #ELTR_YYYYMM_DAYS_INFO DI
						   ON  1=1
					LEFT JOIN CAPA_LINE_SOP SO WITH(NOLOCK) 
						   ON SO.DIVISION_ID	= AK.DIVISION_ID
						  AND SO.COMPANY_ID		= AK.COMPANY_ID
						  AND SO.SITE_ID		= AK.SITE_ID
						  AND SO.PLANT_ID		= AK.PLANT_ID
						  AND SO.FACTORY_ID		= AK.FACTORY_ID
						  AND SO.LINE_ID		= AK.LINE_ID
						  AND SO.OPERATION_ID	= AK.OPERATION_ID
						  AND SO.SOP_YM			= CASE	WHEN DI.YYYYMM = 'BASE'
														THEN  @V_VER_ID
														ELSE DI.YYYYMM
												   END 
			 WHERE 1=1

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 조업률(일) 재계산 : AV_RT'  -- 2024.08.29 추가 
			-- 조업일수 : SCP 생산 계획 / 생산 Capa(일) 
			------------------------------------------------------------------------------------------------------------------
			;WITH AV_RT AS ( 
				SELECT  
					   PC.MDL_ALTER_KEY
					  ,PC.LN_ALTER_KEY
					  ,PC.MSR_GR_CD
					  ,'AV_RT'	AS MSR_TP_CD
					  ,PC.YYYYMM
					  -- 조업률
					  ,CONVERT(FLOAT, 
					   CASE WHEN MAX(CASE WHEN MSR_TP_CD = 'PROD_CAPA_D' THEN MSR_NVL ELSE NULL END)  = 0 
							THEN 0
							ELSE   CONVERT(FLOAT, CONVERT(NUMERIC(20,10), 
								      CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'SCP_PROD_PLAN'	THEN MSR_NVL ELSE NULL END))
									/ CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_CAPA_D'	THEN MSR_NVL ELSE NULL END))
									))
					   END / YM.YYYYMM_DDN
					   )	AS MSR_NVL	
					   -- 조업일수
					  ,CONVERT(FLOAT,
					   CASE WHEN MAX(CASE WHEN MSR_TP_CD = 'PROD_CAPA_D' THEN MSR_NVL ELSE NULL END)  = 0 
							THEN 0
							ELSE   CONVERT(NUMERIC(20, 10), 
								      CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'SCP_PROD_PLAN'	THEN MSR_NVL ELSE NULL END))
									/ CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_CAPA_D'	THEN MSR_NVL ELSE NULL END))
									)
					   END
					   )	AS MSR_DDN	
				 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF  PC
					  INNER JOIN #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP YM -- 2024.08.29 SOP 적용 
							  ON YM.YYYYMM		= PC.YYYYMM 
							 AND YM.LN_ALTER_KEY= PC.LN_ALTER_KEY
				WHERE 1=1
				  AND PC.MSR_TP_CD IN ('SCP_PROD_PLAN', 'PROD_CAPA_D') 
				GROUP BY PC.MDL_ALTER_KEY
						,PC.LN_ALTER_KEY
						,PC.MSR_GR_CD
						,PC.YYYYMM
						,CONVERT(FLOAT, YM.YYYYMM_DDN)
			)
			INSERT #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF 
			SELECT AR.MDL_ALTER_KEY
				  ,AR.LN_ALTER_KEY 
				  ,R.DIVISION_ID
				  ,R.MDL_NM
				  ,R.PLANT_ID
				  ,R.LINE_ID
				  ,R.OPERATION_ID
				  ,R.ELTR_LN_TP_CD
				  ,R.COMPANY_ID
				  ,R.SITE_ID
				  ,R.FACTORY_ID
				  ,AR.MSR_TP_CD
				  ,AR.YYYYMM
				  ,ISNULL(R.PFRSLT_NVL,  0.)				AS PFRSLT_NVL	  -- 조업률 실적
				  ,1.										AS BASE_NVL		  -- 모델별 Loss의 조업률은 100?.
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,NULL										AS IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,NULL										AS IPRV_GOL_RT
				  ,AR.MSR_GR_CD
				  ,ISNULL(AR.MSR_NVL, 0.)					AS MSR_NVL 
				  ,ISNULL(AR.MSR_DDN, 0.)					AS MSR_DDN 
			 FROM AV_RT AR
				  INNER JOIN #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF R -- 2024.08.14 수정 
						 ON R.MDL_ALTER_KEY = AR.MDL_ALTER_KEY
						AND R.LN_ALTER_KEY	= AR.LN_ALTER_KEY
						AND R.YYYYMM		= AR.YYYYMM
						AND R.MSR_TP_CD		= 'AV_RT_OLD'
			WHERE 1=1

			-----------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 모델별 Loss Plan 모델별 Cutoff Data -  #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF - Base 추가'
			-----------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
			SELECT   LS.MDL_ALTER_KEY
					,LS.LN_ALTER_KEY
					,LS.DIVISION_ID
					,LS.MDL_NM
					,LS.PLANT_ID
					,LS.LINE_ID
					,LS.OPERATION_ID
					,MAX(LS.ELTR_LN_TP_CD)		AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외
					,LS.COMPANY_ID
					,LS.SITE_ID
					,LS.FACTORY_ID
					,LS.MSR_TP_CD
					,'BASE'	AS YYYYMM 
					,MAX(LS.PFRSLT_NVL)
					,MAX(LS.BASE_NVL)
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,MAX(LS.IPRV_GOL_DIVS_CD)
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,MAX(LS.IPRV_GOL_RT)
					,MAX(LS.MSR_GR_CD)
					,MAX(LS.BASE_NVL)	AS MSR_NVL
					,NULL				AS MSR_DDN
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS WITH(NOLOCK) 
			GROUP BY LS.MDL_ALTER_KEY
					,LS.LN_ALTER_KEY
					,LS.DIVISION_ID
					,LS.MDL_NM
					,LS.PLANT_ID
					,LS.LINE_ID
					,LS.OPERATION_ID
					,LS.COMPANY_ID
					,LS.SITE_ID
					,LS.FACTORY_ID
					,LS.MSR_TP_CD

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 모델별 Loss - 속도 계산을 위한 SCP생산계획 추가' 
			-- SCP_PROD_PLAN_C : speed 계획속도 정보가 없는 경우 0으로 반영 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
			SELECT LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.DIVISION_ID
				  ,LS.MDL_NM
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,MAX(LS.ELTR_LN_TP_CD)		AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
				  ,'SCP_PROD_PLAN_C'	AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,NULL					AS PFRSLT_NVL
				  ,NULL					AS BASE_NVL
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,NULL					AS IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,NULL					AS IPRV_GOL_RT
				  ,'-'					AS MSR_GR_CD
				  ,CASE WHEN ISNULL(MAX(CASE WHEN MSR_TP_CD = 'EQP_SPED'	   THEN MSR_NVL ELSE NULL END), 0) = 0  
					    THEN 0.
						ELSE  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'SCP_PROD_PLAN' THEN MSR_NVL ELSE NULL END)) 
					END			AS MSR_NVL
				  ,NULL			AS MSR_DDN
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS 
			WHERE 1=1
			  AND LS.MSR_TP_CD IN ('SCP_PROD_PLAN', 'EQP_SPED') 
			GROUP BY 
				   LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.DIVISION_ID
				  ,LS.MDL_NM
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
				  ,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 모델별 Loss - 생산시간 추가' 
			-- 생산시간(PROD_TM) : SCP생산계획 C / speed 계획 속도 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
			SELECT LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.DIVISION_ID
				  ,LS.MDL_NM
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,MAX(LS.ELTR_LN_TP_CD)	AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
				  ,'PROD_TM'	AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,NULL			AS PFRSLT_NVL
				  ,NULL			AS BASE_NVL
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,NULL			AS IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,NULL			AS IPRV_GOL_RT
				  ,'-'			AS MSR_GR_CD
				  ,CASE WHEN ISNULL(MAX(CASE WHEN MSR_TP_CD = 'EQP_SPED'	   THEN MSR_NVL ELSE NULL END), 0) = 0 
					    THEN 0.
						ELSE   CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'SCP_PROD_PLAN_C' THEN MSR_NVL ELSE NULL END))
							 / CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'EQP_SPED'		THEN MSR_NVL ELSE NULL END))
					END			AS MSR_NVL
				  ,NULL			AS MSR_DDN
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS 
			WHERE 1=1
			  AND LS.MSR_TP_CD IN ('SCP_PROD_PLAN_C', 'EQP_SPED')  -- EQP_SPED 정보가 없는 경우 SCP 생산계획 0으로 반영  
			GROUP BY 
				   LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.DIVISION_ID
				  ,LS.MDL_NM
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
				  ,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 비조업' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT AK.LN_ALTER_KEY
				  ,LS.MSR_GR_CD
				  ,LS.MSR_TP_CD
				  ,LS.YYYYMM
				  ,ISNULL(LS.MSR_NVL,0)	AS MSR_NVL
				  ,ISNULL(LS.MSR_NVL,0)	AS MSR_DDN			-- 2024.10.23 UI에서 입력된 MSR_NVL 값으로 MSR_DDN값 일치시킴 
				  ,YM.YYYYMM_DDN		AS ATTRIBUTE1		-- 최대조업일수 
				  ,NULL					AS ATTRIBUTE10
			 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_LN LS WITH(NOLOCK)	-- 라인별 Loss Current 
				  INNER JOIN #ELTR_ALTER_KEY_INFO_LN AK 
						  ON  1=1 
						 AND  AK.PLANT_ID		= LS.PLANT_ID
						 AND  AK.LINE_ID		= LS.LINE_ID
						 AND  AK.OPERATION_ID	= LS.OPERATION_ID
						 AND  AK.DIVISION_ID	= LS.DIVISION_ID
						 AND  AK.COMPANY_ID		= LS.COMPANY_ID
						 AND  AK.SITE_ID		= LS.SITE_ID
						 AND  AK.FACTORY_ID		= LS.FACTORY_ID
				  INNER JOIN #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP YM	-- 2024/8/29 SOP적용
						  ON YM.YYYYMM			= LS.YYYYMM 
						 AND YM.LN_ALTER_KEY	= AK.LN_ALTER_KEY 
			WHERE 1=1
			  AND LS.MSR_GR_CD = 'NAV'		-- 비조업 	
			  AND LS.MSR_TP_CD != 'WT_RT'	-- 2024.08.29 물동없음 제외 (재계산 반영) 


			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 비조업 - WT_RT 물동없음 추가' -- 2024.08.29 
			-------------------------------------------------------------------------------------------------------------------
			;WITH AV_DDN AS (
				-- non base 
				SELECT LS.LN_ALTER_KEY
					  ,LS.YYYYMM
					  ,SUM(MSR_DDN)	AS AV_DDN -- 조업일수 
				 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS
				WHERE 1=1
				  AND MSR_TP_CD = 'AV_RT'
				  AND MDL_NM	!= '-'
				  AND YYYYMM	!= 'BASE' -- 2024.09.27 
				GROUP BY LS.LN_ALTER_KEY
						,LS.YYYYMM
				-- 2024.09.27 base  추가 
				UNION ALL  
				SELECT LN_ALTER_KEY
					  ,YYYYMM
					  ,YYYYMM_DDN AS AV_DDN 
				  FROM #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP WITH(NOLOCK) 
				WHERE 1=1
				  AND YYYYMM = 'BASE'
			), NAV_SUM AS (
				SELECT LS.LN_ALTER_KEY
					  ,LS.YYYYMM
					  ,SUM(MSR_NVL)	AS NAV_DDN 
				 FROM #ELTR_LOSS_PLAN_LN LS
				WHERE 1=1
				  AND LS.MSR_GR_CD = 'NAV' -- 비조업 
				GROUP BY LS.LN_ALTER_KEY
						,LS.YYYYMM
			)
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT NA.LN_ALTER_KEY
				  ,'NAV'														AS MSR_GR_CD
				  ,'WT_RT'														AS MSR_TP_CD
				  ,NA.YYYYMM
				  ,YM.YYYYMM_DDN - ISNULL(NA.NAV_DDN,0.) - ISNULL(AV.AV_DDN,0.)	AS MSR_NVL
				  ,YM.YYYYMM_DDN - ISNULL(NA.NAV_DDN,0.) - ISNULL(AV.AV_DDN,0.)	AS MSR_DDN
				  ,YM.YYYYMM_DDN												AS ATTRIBUTE1		-- 최대조업일수 
				  ,NULL															AS ATTRIBUTE10
			  FROM NAV_SUM NA 
				   INNER JOIN #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP YM	-- 2024/8/29 SOP적용
						  ON YM.YYYYMM			= NA.YYYYMM 
						 AND YM.LN_ALTER_KEY	= NA.LN_ALTER_KEY 
				   LEFT JOIN AV_DDN AV
						   ON AV.LN_ALTER_KEY = NA.LN_ALTER_KEY
						  AND AV.YYYYMM		  = NA.YYYYMM
			WHERE 1=1


			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 조업률 추가' 
			-- 조업률 = 1 - (비조업일 / 최대조업일) 
			-- 2024.08.09 전극 조업일 계산 로직 수정  
			-- 2024.08.09 변경전 조업일수 = 최대조업일 * 조업률
			-- 2024.08.09 변경후 조업일수 = 최대조업일 - SUM(비조업일)
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'AV_RT'			AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(MSR_NVL)) / YM.YYYYMM_DDN	AS MSR_NVL	-- 조업률
				  ,YM.YYYYMM_DDN - CONVERT(FLOAT, SUM(MSR_NVL))						AS MSR_DDN	-- 조업일수 = 최대조업일수 - 비조업일합계
				  ,YM.YYYYMM_DDN	AS ATTRIBUTE1		-- 최대조업일수 
				  ,NULL				AS ATTRIBUTE10
			 FROM #ELTR_LOSS_PLAN_LN LS
				  INNER JOIN #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP YM	-- 2024/8/29 SOP적용
						  ON YM.YYYYMM			= LS.YYYYMM 
						 AND YM.LN_ALTER_KEY	= LS.LN_ALTER_KEY 
			WHERE 1=1
			  AND LS.MSR_GR_CD = 'NAV'
			GROUP BY LS.LN_ALTER_KEY
					,LS.YYYYMM
					,YM.YYYYMM_DDN 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 비부하 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,LS.MSR_GR_CD
				  ,LS.MSR_TP_CD
				  ,LS.YYYYMM
				  ,ISNULL(LS.MSR_NVL, 0)												AS MSR_NVL		-- 비부하율
				  ,CONVERT(FLOAT, ISNULL(LS.MSR_NVL, 0)) * CONVERT(FLOAT, AV.MSR_DDN)	AS MSR_DDN		-- 비부하일수 = 비부하율 * 조업일수
				  ,AV.MSR_DDN															AS ATTRIBUTE1	-- 조업일수 
				  ,NULL																	AS ATTRIBUTE10
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS 
				  INNER JOIN #ELTR_LOSS_PLAN_LN AV
						  ON AV.LN_ALTER_KEY = LS.LN_ALTER_KEY
						 AND AV.MSR_TP_CD	 = 'AV_RT'		-- 조업률/조업일수
						 AND AV.YYYYMM		 = LS.YYYYMM 
			WHERE 1=1
			  AND LS.MSR_GR_CD	= 'NLD'	-- 비부하
			  AND LS.MDL_NM		= '-'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 부하율 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'		AS MSR_GR_CD
				  ,'LD_RT'	AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(LS.MSR_NVL)) 	AS MSR_NVL		-- 부하율
				  ,CONVERT(FLOAT, CONVERT(NUMERIC(20,10), 
				   CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(LS.MSR_NVL)) ))
				   * AV.MSR_DDN											AS MSR_DDN		-- 부하일수 = 부하율 * 조업일수
				  ,AV.MSR_DDN											AS ATTRIBUTE1	-- 조업일수 
				  ,NULL													AS ATTRIBUTE10
			 FROM #ELTR_LOSS_PLAN_LN LS
				  INNER JOIN #ELTR_LOSS_PLAN_LN AV
						  ON AV.LN_ALTER_KEY = LS.LN_ALTER_KEY
						 AND AV.MSR_TP_CD	 = 'AV_RT'		-- 조업률/조업일수
						 AND AV.YYYYMM		 = LS.YYYYMM 
			WHERE 1=1
			  AND LS.MSR_GR_CD = 'NLD'	-- 비부하
			GROUP BY LS.LN_ALTER_KEY
					,LS.YYYYMM
					,AV.MSR_DDN 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 비가동 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,LS.MSR_GR_CD
				  ,LS.MSR_TP_CD
				  ,LS.YYYYMM
				  ,ISNULL(LS.MSR_NVL, 0)												AS MSR_NVL		-- 비가동률
				  ,CONVERT(FLOAT, ISNULL(LS.MSR_NVL, 0)) * CONVERT(FLOAT, LD.MSR_DDN)	AS MSR_DDN		-- 비가동일수 = 비가동률 * 부하일수
				  ,LD.MSR_DDN															AS ATTRIBUTE1	-- 부하일수 
				  ,NULL																	AS ATTRIBUTE10
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS	
				  INNER JOIN #ELTR_LOSS_PLAN_LN LD
						  ON LD.LN_ALTER_KEY = LS.LN_ALTER_KEY
						 AND LD.MSR_TP_CD	 = 'LD_RT'		-- 부하률/부하일수
						 AND LD.YYYYMM		 = LS.YYYYMM 
			WHERE 1=1
			  AND LS.MSR_GR_CD	= 'NOP'	-- 비가동
			  AND LS.MDL_NM		= '-'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 시간가동률 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'		AS MSR_GR_CD
				  ,'OP_RT'	AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(LS.MSR_NVL)) 	AS MSR_NVL			-- 시간가동률
				  ,CONVERT(FLOAT, CONVERT(NUMERIC(20,10), 
				   CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(LS.MSR_NVL)) ))
				   * LD.MSR_DDN											AS MSR_DDN		-- 시간가동일수 = 시간가동률 * 부하일수
				  ,LD.MSR_DDN											AS ATTRIBUTE1	-- 부하일수 
				  ,NULL													AS ATTRIBUTE10
			 FROM #ELTR_LOSS_PLAN_LN LS
				  INNER JOIN #ELTR_LOSS_PLAN_LN LD
						  ON LD.LN_ALTER_KEY = LS.LN_ALTER_KEY
						 AND LD.MSR_TP_CD	 = 'LD_RT'		-- 부하률/부하일수
						 AND LD.YYYYMM		 = LS.YYYYMM 
			WHERE 1=1
			  AND LS.MSR_GR_CD	= 'NOP'	-- 비가동
			GROUP BY LS.LN_ALTER_KEY
					,LS.YYYYMM
					,LD.MSR_DDN 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 성능가동률 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,LS.MSR_GR_CD
				  ,LS.MSR_TP_CD
				  ,LS.YYYYMM
				  ,LS.MSR_NVL												AS MSR_NVL		-- 성능가동률
				  ,CONVERT(FLOAT, LS.MSR_NVL) * CONVERT(FLOAT, OP.MSR_DDN)	AS MSR_DDN		-- 성능가동일수 = 성능가동률 * 시간가동일수
				  ,OP.MSR_DDN												AS ATTRIBUTE1	-- 시간가동일수
				  ,NULL		 												AS ATTRIBUTE10
				  --- select * 
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS   
				  INNER JOIN #ELTR_LOSS_PLAN_LN OP
						  ON OP.LN_ALTER_KEY = LS.LN_ALTER_KEY
						 AND OP.MSR_TP_CD	 = 'OP_RT'		-- 시간가동률/시간가동일수
						 AND OP.YYYYMM		 = LS.YYYYMM 
			WHERE 1=1
			  AND LS.MSR_TP_CD	= 'PF_RT'	-- 성능가동률
			  AND LS.MDL_NM		= '-'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 양품가동률 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,LS.MSR_GR_CD
				  ,LS.MSR_TP_CD
				  ,LS.YYYYMM
				  ,LS.MSR_NVL												AS MSR_NVL		-- 양품가동률
				  ,CONVERT(FLOAT, LS.MSR_NVL) * CONVERT(FLOAT, PF.MSR_DDN)	AS MSR_DDN		-- 양품가동일수 = 양품가동률 * 성능가동일수
				  ,PF.MSR_DDN												AS ATTRIBUTE1	-- 성능가동일수 
				  ,NULL														AS ATTRIBUTE10
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS 
				  INNER JOIN #ELTR_LOSS_PLAN_LN PF
						  ON PF.LN_ALTER_KEY = LS.LN_ALTER_KEY
						 AND PF.MSR_TP_CD	 = 'PF_RT'		-- 성능가동률/성능가동일수
						 AND PF.YYYYMM		 = LS.YYYYMM 
			WHERE 1=1
			  AND LS.MSR_TP_CD	= 'QL_RT'	-- 양품가동률
			  AND LS.MDL_NM		= '-'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 생산가동률 추가' 
			-- 생산가동률 = 부하율 * 시간가동률 * 성능가동률 * 양품가동률 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'PROD_OP_RT'		AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,  CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'LD_RT' THEN MSR_NVL ELSE NULL END))
				   * CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'OP_RT' THEN MSR_NVL ELSE NULL END))
				   * CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'PF_RT' THEN MSR_NVL ELSE NULL END))
				   * CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'QL_RT' THEN MSR_NVL ELSE NULL END))	AS MSR_NVL
				  ,NULL																					AS MSR_DDN
				  ,NULL																					AS ATTRIBUTE1 
				  ,NULL																					AS ATTRIBUTE10 
			 FROM #ELTR_LOSS_PLAN_LN LS 
			WHERE 1=1
			  AND LS.MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT') 
			GROUP BY LS.LN_ALTER_KEY
					,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - TEEP 추가' 
			-- TEEP = 조업률 * 부하율 * 시간가동률 * 성능가동률 * 양품가동률 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'TEEP'			AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,  CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'AV_RT' THEN MSR_NVL ELSE NULL END))
				   * CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'LD_RT' THEN MSR_NVL ELSE NULL END))
				   * CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'OP_RT' THEN MSR_NVL ELSE NULL END))
				   * CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'PF_RT' THEN MSR_NVL ELSE NULL END))
				   * CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'QL_RT' THEN MSR_NVL ELSE NULL END))	AS MSR_NVL
				  ,NULL																					AS MSR_DDN
				  ,NULL																					AS ATTRIBUTE1
				  ,NULL																					AS ATTRIBUTE10 
			 FROM #ELTR_LOSS_PLAN_LN LS 
			WHERE 1=1
			  AND MSR_TP_CD IN ('AV_RT', 'LD_RT', 'OP_RT', 'PF_RT', 'QL_RT') 
			GROUP BY LS.LN_ALTER_KEY
					,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 생산계획 및 생산시간 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,LS.MSR_GR_CD
				  ,LS.MSR_TP_CD
				  ,LS.YYYYMM
				  ,SUM(LS.MSR_NVL)	AS MSR_NVL
				  ,NULL				AS MSR_DDN
				  ,NULL				AS ATTRIBUTE1
				  ,NULL				AS ATTRIBUTE10
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS 
			WHERE 1=1
			  AND LS.MSR_TP_CD	IN ('SCP_PROD_PLAN', 'SCP_PROD_PLAN_C', 'PROD_TM') 	-- SCP생산계획/생산시간 
			GROUP BY LS.LN_ALTER_KEY
				    ,LS.MSR_GR_CD
				    ,LS.MSR_TP_CD
				    ,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 속도 추가' 
			-- 속도 (EQP_SPED) : 생산계획 / 생산시간 
			-- 생산계획 : 모델별 Speed 속도가 없는 경우 0으로 반영된 생산계획 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'PPM'			AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,CASE WHEN MAX(CASE WHEN LS.MSR_TP_CD = 'PROD_TM' THEN LS.MSR_NVL ELSE NULL END) = 0
						THEN 0
						ELSE CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'SCP_PROD_PLAN_C'	THEN LS.MSR_NVL ELSE NULL END))
						   / CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'PROD_TM'			THEN LS.MSR_NVL ELSE NULL END))
					END				AS MSR_NVL
				  ,MAX(CASE WHEN LS.MSR_TP_CD = 'SCP_PROD_PLAN_C'	THEN LS.MSR_NVL ELSE NULL END)				AS MSR_DDN		-- SCP 생산계획 
				  ,MAX(CASE WHEN LS.MSR_TP_CD = 'PROD_TM'			THEN LS.MSR_NVL ELSE NULL END)				AS ATTRIBUTE1	-- 시간 (SCP생산계획 / speed계획 속도)  
				  ,NULL																							AS ATTRIBUTE10
			 FROM #ELTR_LOSS_PLAN_LN LS 
			WHERE 1=1
			  AND LS.MSR_TP_CD	IN ('SCP_PROD_PLAN_C', 'PROD_TM') 	-- SCP생산계획 C /생산시간   -- EQP_SPED 정보가 없는 경우 SCP 생산계획 0으로 반영된 생산계획  
			GROUP BY LS.LN_ALTER_KEY
				    ,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 설비대수 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'EQP_NBU'		AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,1.0				AS MSR_NVL
				  ,NULL				AS MSR_DDN
				  ,NULL				AS ATTRIBUTE1
				  ,NULL				AS ATTRIBUTE10
			 FROM #ELTR_LOSS_PLAN_LN LS 
			WHERE 1=1
			  AND LS.MSR_TP_CD	= 'PPM'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 표준폭환산자 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'SW_CNV_RT'		AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,CASE WHEN AK.ELTR_LN_TP_CD = 'W'	
						THEN 2.0
						ELSE 1.0 
					END				AS MSR_NVL			-- 표준폭환산자 (S:1, W:2) 
				  ,CASE WHEN AK.ELTR_LN_TP_CD = 'W'	
						THEN 1.0
						ELSE 2.0 
					END				AS MSR_DDN			-- 배수(S:2, W:1) 
				  ,LS.MSR_NVL		AS ATTRIBUTE1		-- 시간(PROD_TM = 생산계획C / speed계획 속도)  
				  ,NULL				AS ATTRIBUTE10
			 FROM #ELTR_LOSS_PLAN_LN LS 
				  INNER JOIN #ELTR_ALTER_KEY_INFO_LN AK
						  ON AK.LN_ALTER_KEY = LS.LN_ALTER_KEY
			WHERE 1=1
			  AND LS.MSR_TP_CD	= 'PROD_TM'		-- 시간 (SCP생산계획C / speed계획 속도)

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 이론 Capa (일) 추가' 
			-- 이론 Capa (일) : 설비대수 * 속도 * 표준폭환산자 * 1440 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'THRY_CAPA_D'	AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'EQP_NBU'	THEN LS.MSR_NVL ELSE NULL END))	 --	설비대수
				  *CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'PPM'		THEN LS.MSR_NVL ELSE NULL END))	 --	속도
				  *CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'SW_CNV_RT'	THEN LS.MSR_NVL ELSE NULL END))	 --	표준폭환산자
				  *CONVERT(FLOAT, 1440)		AS MSR_NVL
				  ,NULL				AS MSR_DDN
				  ,NULL				AS ATTRIBUTE1
				  ,NULL				AS ATTRIBUTE10
			 FROM #ELTR_LOSS_PLAN_LN LS 
			WHERE 1=1
			  AND LS.MSR_TP_CD	IN ('EQP_NBU', 'PPM', 'SW_CNV_RT') 
			GROUP BY LS.LN_ALTER_KEY
				    ,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 생산 Capa (일) 추가' 
			-- 생산 Capa (일) : 이론 Capa (일) * 생산가동률
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'PROD_CAPA_D'	AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'THRY_CAPA_D'	THEN LS.MSR_NVL ELSE NULL END))	 --	이론 Capa (일)
				  *CONVERT(FLOAT, MAX(CASE WHEN LS.MSR_TP_CD = 'PROD_OP_RT'		THEN LS.MSR_NVL ELSE NULL END))	 --	생산가동률
									AS MSR_NVL
				  ,NULL				AS MSR_DDN
				  ,NULL				AS ATTRIBUTE1
				  ,NULL				AS ATTRIBUTE10
			 FROM #ELTR_LOSS_PLAN_LN LS 
			WHERE 1=1
			  AND LS.MSR_TP_CD	IN ('THRY_CAPA_D', 'PROD_OP_RT')
			GROUP BY LS.LN_ALTER_KEY
				    ,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss - 생산 Capa (월) 추가' 
			-- 생산 Capa (월) : 생산 Capa (일) * 월(년)일수
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'PROD_CAPA_M'	AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,CONVERT(FLOAT, LS.MSR_NVL) * YM.YYYYMM_DDN
									AS MSR_NVL
				  ,NULL				AS MSR_DDN
				  ,NULL				AS ATTRIBUTE1
				  ,NULL				AS ATTRIBUTE10
			 FROM #ELTR_LOSS_PLAN_LN LS 
				  INNER JOIN #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP YM	-- 2024/8/29 SOP적용
						  ON YM.YYYYMM			= LS.YYYYMM 
						 AND YM.LN_ALTER_KEY	= LS.LN_ALTER_KEY 
			WHERE 1=1
			  AND LS.MSR_TP_CD	= 'PROD_CAPA_D'

		---- start 전극 실적 (M-1)
		---- start 전극 실적 (M-1)
		---- start 전극 실적 (M-1)


			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별 실적(M-1) -  #ELTR_LOSS_RSLT_WITH_ALTER_KEY' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_LOSS_RSLT_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #ELTR_LOSS_RSLT_WITH_ALTER_KEY

			SELECT AK.LN_ALTER_KEY
				  ,LR.LOSS_GR_CD	AS MSR_GR_CD
				  ,LR.LOSS_CD		AS MSR_TP_CD
				  ,'RSLT'			AS YYYYMM
				  ,CONVERT(NUMERIC(20,10),
					CASE WHEN LR.LOSS_GR_CD = 'NAV' 
						THEN CONVERT(FLOAT, LR.LOSS_RT) * CONVERT(FLOAT, LR.ATTRIBUTE1)  -- 2024/10/29 지표 제외 적용 실적 최대조업일수 적용 
						ELSE LR.LOSS_RT 
					END)											AS MSR_NVL			-- 5/14 비조업 일수로 반영 필요 
				  ,CONVERT(NUMERIC(20,10),
					CASE WHEN LR.LOSS_GR_CD = 'NAV'  
						 THEN CONVERT(FLOAT, LR.LOSS_RT) * CONVERT(FLOAT, LR.ATTRIBUTE1)  -- 2024/10/29 지표 제외 적용 실적 최대조업일수 적용 
						 ELSE CONVERT(FLOAT, LR.LOSS_TM_SSN) / CONVERT(FLOAT, 86400)
					 END)											AS MSR_DDN
				  ,MAX(CASE WHEN LR.LOSS_CD = 'AV_RT' 
							THEN CONVERT(FLOAT, LR.ATTRIBUTE1) 
							ELSE NULL
						END)  OVER (PARTITION BY AK.LN_ALTER_KEY)	AS YYYYMM_DDN		-- 2024/10/29 지표 제외 적용 실적 최대조업일수
			 INTO #ELTR_LOSS_RSLT_WITH_ALTER_KEY 
			 FROM SCM_DNM_ELTR_LOSS_LN_MMLY LR WITH(NOLOCK) 
				  INNER JOIN #ELTR_ALTER_KEY_INFO_LN AK
						  ON AK.DIVISION_ID	  = LR.DIVISION_ID
						 AND AK.PLANT_ID	  = LR.PLANT_ID
						 AND AK.LINE_ID		  = LR.LINE_ID
						 AND AK.OPERATION_ID  = LR.OPERATION_ID
						 AND AK.COMPANY_ID	  = LR.COMPANY_ID
						 AND AK.SITE_ID		  = LR.SITE_ID
						 AND AK.FACTORY_ID	  = LR.FACTORY_ID
			WHERE 1=1 
			  AND LR.LOSS_YM		= @V_LOSS_RSLT_YYYYMM
			  AND LR.PERD_DIVS_CD	= '1'	-- M-1월 1개월실적 
			  AND LR.LOSS_CD NOT IN ('PF', 'PROD_AVG_SPED', 'MMD_SPED')

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별 실적(M-1)  - SOP적용된 실적(RSLT) 최대조업일수 Update' -- 2024/10/29 
			-------------------------------------------------------------------------------------------------------------------
			UPDATE SO SET SO.YYYYMM_DDN = AV.YYYYMM_DDN   
			 FROM #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP SO 
				  INNER JOIN #ELTR_LOSS_RSLT_WITH_ALTER_KEY AV
						  ON AV.YYYYMM			= SO.YYYYMM 
						 AND AV.LN_ALTER_KEY	= SO.LN_ALTER_KEY
						 AND AV.MSR_TP_CD		= 'AV_RT'
			WHERE 1=1

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별 실적(M-1) - 실적 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LR.LN_ALTER_KEY
				  ,LR.MSR_GR_CD
				  ,LR.MSR_TP_CD
				  ,'RSLT'			AS YYYYMM 
				  ,LR.MSR_NVL
				  ,CASE WHEN LR.MSR_TP_CD = 'PF_RT'		THEN CONVERT(FLOAT, LR.MSR_NVL) * CONVERT(FLOAT, OP.MSR_DDN)											-- 성능가동일수  : 성능가동률 * 시간가동일수 
						WHEN LR.MSR_TP_CD = 'QL_RT'		THEN CONVERT(FLOAT, LR.MSR_NVL) 
															* CONVERT(FLOAT, CONVERT(NUMERIC(20,10), (CONVERT(FLOAT, PF.MSR_NVL) * CONVERT(FLOAT, OP.MSR_DDN))))	-- 양품가동일수  : 양품가동률 * 성능가동일수 (성능가동률 * 시간가동일수)    
						ELSE LR.MSR_DDN
					END				AS MSR_DDN
				  ,CASE WHEN LR.MSR_TP_CD = 'AV_RT' OR LR.MSR_GR_CD = 'NAV'	THEN YM.YYYYMM_DDN	-- 조업/비조업		: 최대조업일수
						WHEN LR.MSR_TP_CD = 'LD_RT' OR LR.MSR_GR_CD = 'NLD'	THEN AV.MSR_DDN		-- 부하/비부하		: 조업일수
						WHEN LR.MSR_TP_CD = 'OP_RT' OR LR.MSR_GR_CD = 'NOP'	THEN LD.MSR_DDN		-- 시간가동/비가동	: 부하일수
						WHEN LR.MSR_TP_CD = 'PF_RT'							THEN OP.MSR_DDN		-- 성능가동률		: 시간가동일수
						WHEN LR.MSR_TP_CD = 'QL_RT'							THEN PF.MSR_DDN		-- 양품가동률		: 성능가동일수
						ELSE NULL
					END				AS ATTRIBUTE1
				  ,NULL				AS ATTRIBUTE10
			 FROM #ELTR_LOSS_RSLT_WITH_ALTER_KEY LR
				  LEFT JOIN #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP YM	-- 2024/8/29 SOP적용
						  ON YM.YYYYMM		= 'RSLT' -- 실적년월 일수 
						 AND YM.LN_ALTER_KEY= LR.LN_ALTER_KEY 
				  LEFT JOIN #ELTR_LOSS_RSLT_WITH_ALTER_KEY AV
						 ON AV.LN_ALTER_KEY = LR.LN_ALTER_KEY
						AND AV.MSR_TP_CD	= 'AV_RT' -- 조업률/조업일수
				  LEFT JOIN #ELTR_LOSS_RSLT_WITH_ALTER_KEY LD
						 ON LD.LN_ALTER_KEY = LR.LN_ALTER_KEY
						AND LD.MSR_TP_CD	= 'LD_RT' -- 부하율/부하일수
				  LEFT JOIN #ELTR_LOSS_RSLT_WITH_ALTER_KEY OP
						 ON OP.LN_ALTER_KEY = LR.LN_ALTER_KEY
						AND OP.MSR_TP_CD	= 'OP_RT' -- 시간가동률/시간가동일수
				  LEFT JOIN #ELTR_LOSS_RSLT_WITH_ALTER_KEY PF
						 ON PF.LN_ALTER_KEY = LR.LN_ALTER_KEY
						AND PF.MSR_TP_CD	= 'PF_RT' -- 성능가동률/성능가동일수
			WHERE 1=1

		---- end 전극 실적 (M-1)
		---- end 전극 실적 (M-1)
		---- end 전극 실적 (M-1)


		------------------- STart 전극 라인별 PRVS 
		------------------- STart 전극 라인별 PRVS 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별 PRVS  - 이전 버전 Capa Plan의 당월 계획 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_PRVS_CAPA_LOSS_PLAN') IS NOT NULL DROP TABLE #ELTR_PRVS_CAPA_LOSS_PLAN; 

			;WITH PRVS_CAPA_VERSION AS ( 
				SELECT TOP 1 
						  ISNULL(VER_ID, '')		AS PRVS_VER_ID
						, ISNULL(VER_SEQ, 0)		AS PRVS_VER_SEQ
						, ISNULL(DIVISION_ID, '')	AS DIVISION_ID 
						, PROG_STAT 
				 FROM SCP_MST_CAPA_VERSION PV WITH(NOLOCK)
				WHERE 1=1
				  AND DIVISION_ID					= @V_DIVISION_ID
				  AND VER_ID						= @V_RP_YYYYMM		-- M-2월에 수립한 계획 
				  AND PROG_STAT						= '2'				-- 이전 2차 컷오프 완료된 최종 버전 
				  AND ISNULL(BIZ_PLAN_USE_YN,'N')	!= 'Y'				-- 사업계획이 아니면 RP로 간주함 
				ORDER BY VER_ID		DESC
				       , VER_SEQ	DESC 
			)
			SELECT LP.DIVISION_ID
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,LP.MSR_TP_CD
				  ,LP.MSR_GR_CD 
				  ,'PRVS'									AS YYYYMM
				  ,CONVERT(NUMERIC(20,10), LP.MSR_NVL	)	AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), LP.MSR_DDN	)	AS MSR_DDN
				  ,LP.ATTRIBUTE1
				  ,LP.ATTRIBUTE2
				  ,LP.ATTRIBUTE3
				  ,LP.VER_ID		AS PRVS_VER_ID
				  ,LP.VER_SEQ		AS PRVS_VER_SEQ
				  ,LP.YYYYMM		AS REF_YYYYMM -- 2024.09.24 추가 
			 INTO #ELTR_PRVS_CAPA_LOSS_PLAN
			 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF  LP WITH(NOLOCK)	-- 전극 라인별 loss plan 
				  INNER JOIN PRVS_CAPA_VERSION PV 
						  ON PV.PRVS_VER_ID		= LP.VER_ID
						 AND PV.PRVS_VER_SEQ	= LP.VER_SEQ
						 AND PV.DIVISION_ID		= LP.DIVISION_ID
			WHERE 1=1
			  AND LP.YYYYMM = @V_LOSS_RSLT_YYYYMM  -- 6/10 M-1월(실적과 동일 년월) 계획


		------------------- End 전극 라인별 PRVS 
		------------------- End 전극 라인별 PRVS 


		------------------- STart 전극 라인별 BIZP 사업계획
		------------------- STart 전극 라인별 BIZP 사업계획

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별 BIZP  - 사업계획버전 Capa Plan의 당월 계획 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_BIZP_CAPA_LOSS_PLAN') IS NOT NULL DROP TABLE #ELTR_BIZP_CAPA_LOSS_PLAN; 

			;WITH BIZP_CAPA_VERSION AS ( 
				SELECT TOP 1 
						  ISNULL(VER_ID, '')		AS BIZP_VER_ID
						, ISNULL(VER_SEQ, 0)		AS BIZP_VER_SEQ
						, ISNULL(DIVISION_ID, '')	AS DIVISION_ID 
						, PROG_STAT 
				 FROM SCP_MST_CAPA_VERSION PV WITH(NOLOCK)
				WHERE 1=1
				  AND DIVISION_ID		= @V_DIVISION_ID
				  AND VER_ID		    LIKE CONCAT(@V_BIZP_YYYY , '%')		-- 2024/10/29 전월기준 전년도에 수립한 사업계획 버전
				  AND PROG_STAT			= '2'	-- 이전 2차 컷오프 완료된 버전 
				  AND BIZ_PLAN_USE_YN	= 'Y'	-- 사업계획
				ORDER BY VER_ID		DESC
				       , VER_SEQ	DESC 
			)
			SELECT LP.DIVISION_ID
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,LP.MSR_TP_CD
				  ,LP.MSR_GR_CD 
				  ,'BIZP'			AS YYYYMM
				  ,CONVERT(NUMERIC(20,10), LP.MSR_NVL	)	AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), LP.MSR_DDN	)	AS MSR_DDN
				  ,LP.ATTRIBUTE1
				  ,LP.ATTRIBUTE2
				  ,LP.ATTRIBUTE3
				  ,LP.VER_ID		AS BIZP_VER_ID
				  ,LP.VER_SEQ		AS BIZP_VER_SEQ
				  ,LP.YYYYMM		AS REF_YYYYMM -- 2024.09.24 추가 
			 INTO #ELTR_BIZP_CAPA_LOSS_PLAN
			 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF LP WITH(NOLOCK) 
				  INNER JOIN BIZP_CAPA_VERSION BV 
						  ON BV.BIZP_VER_ID		= LP.VER_ID
						 AND BV.BIZP_VER_SEQ	= LP.VER_SEQ
						 AND BV.DIVISION_ID		= LP.DIVISION_ID
			WHERE 1=1
			  AND LP.YYYYMM = @V_LOSS_RSLT_YYYYMM -- 실적과 동일월  6/11 --- @V_VER_ID  -- 당월 계획 (사업계획 Capa버전의 당월계획) 

		------------------- End 전극 라인별 BIZP 사업계획
		------------------- End 전극 라인별 BIZP 사업계획



----------------------- End 전극 -------------------------------------------------------------------------------------------------------
----------------------- End 전극 -------------------------------------------------------------------------------------------------------
----------------------- End 전극 -------------------------------------------------------------------------------------------------------



		------- Begin Tran : =======================================================================================
		------- Begin Tran : =======================================================================================

		  BEGIN TRAN   --- transaction 시작  

		  ------ Start 조립/팩
		  ------ Start 조립/팩
		  ------ Start 조립/팩

			------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 데이터 수정 - 조업/부하/시간가동/성능가동/양품가동률 및 일수 ' 
			------------------------------------------------------------------------------------------------------------------------------
			UPDATE TG
			   SET TG.MSR_DDN			= SC.MSR_DDN
				  ,TG.MSR_NVL			= CASE WHEN TG.MSR_TP_CD = 'AV_RT' 
											   THEN SC.MSR_NVL 
											   ELSE TG.MSR_NVL	 -- 조업율만 재계산 값으로 변경 (부하/시간가동/성능가동/양품가동률은 1차 컷오프 이후 변함 없음 ) 
										   END  
				  ,TG.LAST_UPDATED_BY	= @v_program_name
				  ,TG.LAST_UPDATE_DATE	= GETDATE()
				  ,TG.ATTRIBUTE10		= N'변경전[MSR_NVL='+CONVERT(NVARCHAR(100),ISNULL(TG.MSR_NVL,'0')) + '][MSR_DDN='++CONVERT(NVARCHAR(100),ISNULL(TG.MSR_DDN,'0'))+']'
			 FROM SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF    TG WITH(NOLOCK)   
				  INNER JOIN #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF SC WITH(NOLOCK) 
						  ON SC.DIVISION_ID		=  TG.DIVISION_ID		
						 AND SC.PLANT_ID		=  TG.PLANT_ID		
						 AND SC.LINE_ID			=  TG.LINE_ID			
						 AND SC.OPERATION_ID	=  TG.OPERATION_ID	
						 AND SC.ELTR_LN_TP_CD	=  TG.ELTR_LN_TP_CD	
						 AND SC.MDL_NM			=  TG.MDL_NM			
						 AND SC.COMPANY_ID		=  TG.COMPANY_ID		
						 AND SC.FACTORY_ID		=  TG.FACTORY_ID		
						 AND SC.MSR_TP_CD		=  TG.MSR_TP_CD		
						 AND SC.YYYYMM			=  TG.YYYYMM			
			WHERE 1=1
			  AND TG.VER_ID			= @V_VER_ID
			  AND TG.VER_SEQ		= @V_VER_SEQ
			  AND TG.DIVISION_ID	= @V_DIVISION_ID
			  AND TG.MSR_TP_CD IN ('AV_RT', 'LD_RT', 'OP_RT', 'PF_RT', 'QL_RT') -- 조업/부하/시간가동/성능가동/양품가동률 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - DELETE  SCP_MST_CAPA_LOSS_PLAN_LN_CUTF ' 
			-------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_LOSS_PLAN_LN_CUTF   
			 WHERE 1=1
			   AND VER_ID		= @V_VER_ID
			   AND VER_SEQ		= @V_VER_SEQ
			   AND DIVISION_ID	= @V_DIVISION_ID

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN_CUTF ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN_CUTF (
				   VER_ID
				  ,VER_SEQ
				  ,DIVISION_ID
				  ,PLANT_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,COMPANY_ID
				  ,SITE_ID
				  ,FACTORY_ID
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE
				  ,ATTRIBUTE1	-- (조업)최대조업일수/(부하)조업일수/(시간가동)부하일수/(성능가동)시간가동일수/(양품가동)성능가동일수
				  ,ATTRIBUTE2	-- (조업)조업일수/(부하)부하일수/(시간가동)시간가동일수/(성능가동)성능가동일수/(양품가동)양품가동일수
				  ,ATTRIBUTE3	-- 설비대수
				  ,ATTRIBUTE4	-- 이론 Capa
				  ,ATTRIBUTE5	-- 부하율
				  ,ATTRIBUTE6	-- 시간가동률
				  ,ATTRIBUTE7	-- 성능가동률
				  ,ATTRIBUTE8	-- 2024.09.12 SOP적용 최대 조업일수
				  ,ATTRIBUTE10
				)
			SELECT @V_VER_ID
				  ,@V_VER_SEQ  --- select ''
				  ,AK.DIVISION_ID
				  ,AK.PLANT_ID
				  ,AK.LINE_ID
				  ,AK.OPERATION_ID
				  ,AK.ELTR_LN_TP_CD
				  ,AK.COMPANY_ID
				  ,AK.SITE_ID
				  ,AK.FACTORY_ID
				  ,LT.MSR_TP_CD
				  ,LT.YYYYMM
				  ,LT.MSR_GR_CD
				  ,LT.MSR_NVL
				  ,LT.MSR_DDN
				  ,@v_program_name		AS CREATED_BY
				  ,getdate()			AS CREATION_DATE
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,getdate()			AS LAST_UPDATE_DATE 
				  ,CASE WHEN LT.MSR_TP_CD IN ('AV_RT', 'LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')  
						THEN CONVERT(NVARCHAR(50), DN.P_DDN)	-- (조업)최대조업일수/(부하)조업일수/(시간가동)부하일수/(성능가동)시간가동일수/(양품가동)성능가동일수
						WHEN LT.MSR_GR_CD = 'NLD'				-- 비부하
						THEN CONVERT(NVARCHAR(50), RD.AV_DDN)	-- 조업일수
						WHEN LT.MSR_GR_CD = 'NOP'				-- 비가동
						THEN CONVERT(NVARCHAR(50), RD.LD_DDN)	-- 부하일수
						WHEN LT.MSR_TP_CD = 'PPM'			
						THEN CONVERT(NVARCHAR(50), RD.QL_DDN)	-- 양품가동일수
						ELSE NULL 
					END AS ATTRIBUTE1  
				  ,CASE WHEN LT.MSR_TP_CD IN ('AV_RT', 'LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')  
						THEN CONVERT(NVARCHAR(50), DN.C_DDN)		-- (조업)조업일수/(부하)부하일수/(시간가동)시간가동일수/(성능가동)성능가동일수/(양품가동)양품가동일수
						WHEN LT.MSR_TP_CD = 'PPM'			
						THEN CONVERT(NVARCHAR(50), ET.YYYYMM_DDN)	-- 월(년)최대조업일수
						ELSE NULL 
					END AS ATTRIBUTE2  
				  ,CONVERT(NVARCHAR(50), ISNULL(ET.EQP_NBU ,0.))	AS ATTRIBUTE3	-- 설비대수
				  ,CASE WHEN LT.MSR_TP_CD = 'PF_RT'
						THEN CONVERT(NVARCHAR(50), ISNULL(ET.THRY_CAPA_D, 0.))	-- 성능가동률 : 이론Capa
						WHEN LT.MSR_TP_CD = 'QL_RT'
						THEN CONVERT(NVARCHAR(50), ISNULL(RD.AV_RT, 0.))		-- 8/14 양품가동률 변경(이론Capa->조업률)
						WHEN LT.MSR_TP_CD = 'PPM'			
						THEN CONVERT(NVARCHAR(50), ET.TEEP)						-- PPM : TEEP
						ELSE NULL
					END AS ATTRIBUTE4
				  ,CASE WHEN LT.MSR_TP_CD IN ('PF_RT', 'QL_RT')
						THEN CONVERT(NVARCHAR(50), ISNULL(RD.LD_RT, 0.))
						ELSE NULL
					END AS ATTRIBUTE5	-- 부하율
				  ,CASE WHEN LT.MSR_TP_CD IN ('PF_RT', 'QL_RT')
						THEN CONVERT(NVARCHAR(50), ISNULL(RD.OP_RT, 0.))
						ELSE NULL
					END AS ATTRIBUTE6	-- 시간가동률
				  ,CASE WHEN LT.MSR_TP_CD IN ('QL_RT')
						THEN CONVERT(NVARCHAR(50), ISNULL(RD.PF_RT, 0.))
						ELSE NULL
					END AS ATTRIBUTE7	-- 성능가동률
				  ,CONVERT(NUMERIC(20,10), YM.YYYYMM_DDN) 	AS ATTRIBUTE8	-- 2024.09.12 SOP적용 최대 조업일수
				  ,LT.ATTRIBUTE10
			 FROM #LOSS_PLAN_LN_TTZM LT
				  INNER JOIN #ALTER_KEY_INFO_FOR_LN AK
						  ON AK.LN_ALTER_KEY = LT.LN_ALTER_KEY
				  LEFT  JOIN #EQP_NBU_THRY_CAPA_D   ET		-- 5/20 추가 
						  ON ET.LN_ALTER_KEY	= LT.LN_ALTER_KEY
						 AND ET.YYYYMM			= LT.YYYYMM
				  LEFT  JOIN #AV_LD_OP_PF_QL_LN_RT_DDN   RD  -- 5/20 추가  
						  ON RD.LN_ALTER_KEY	= LT.LN_ALTER_KEY
						 AND RD.YYYYMM			= LT.YYYYMM
				  LEFT  JOIN #MSR_DDN_LN   DN		-- 5/20 추가  
						  ON DN.LN_ALTER_KEY	= LT.LN_ALTER_KEY
						 AND DN.YYYYMM			= LT.YYYYMM
						 AND DN.MSR_TP_CD		= LT.MSR_TP_CD
				  INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM  -- 2024.09.12 추가 SOP 적용한 최대조업일수 참조
						  ON YM.YYYYMM			= LT.YYYYMM 
						 AND YM.LN_ALTER_KEY	= LT.LN_ALTER_KEY 
			WHERE 1=1

			------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 조립.팩 LOSS 라인 - INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN_CUTF - RP Rolling Plan (PRVS) '  -- 2024.09.26 추가/변경
			------------------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN_CUTF (
				   VER_ID
				  ,VER_SEQ
				  ,DIVISION_ID
				  ,PLANT_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,COMPANY_ID
				  ,SITE_ID
				  ,FACTORY_ID
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE
				  ,ATTRIBUTE1
				  ,ATTRIBUTE2
				  ,ATTRIBUTE3
				  ,ATTRIBUTE4
				  ,ATTRIBUTE5
				  ,ATTRIBUTE6
				  ,ATTRIBUTE7
				  ,ATTRIBUTE8
				  ,ATTRIBUTE10
				  )
			SELECT @V_VER_ID
				  ,@V_VER_SEQ  
				  ,LP.DIVISION_ID
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,LP.MSR_TP_CD
				  ,LP.YYYYMM
				  ,LP.MSR_GR_CD
				  ,LP.MSR_NVL
				  ,LP.MSR_DDN
				  ,@v_program_name							AS CREATED_BY
				  ,getdate()								AS CREATION_DATE
				  ,@v_program_name							AS LAST_UPDATED_BY
				  ,getdate()								AS LAST_UPDATE_DATE 
				  ,LP.ATTRIBUTE1
				  ,LP.ATTRIBUTE2
				  ,LP.ATTRIBUTE3
				  ,LP.ATTRIBUTE4
				  ,LP.ATTRIBUTE5
				  ,LP.ATTRIBUTE6
				  ,LP.ATTRIBUTE7
				  ,LP.ATTRIBUTE8
				  ,'[PRVS_VER_ID='+LP.PRVS_VER_ID+'][PRVS_VER_SEQ='+CONVERT(NVARCHAR(10), LP.PRVS_VER_SEQ)+'][REF_YYYYMM='+LP.REF_YYYYMM	AS ATTRIBUTE10
			FROM #PRVS_CAPA_LOSS_PLAN  LP
			WHERE 1=1

			-----------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 조립.팩 LOSS 라인 - INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN_CUTF - 사업계획 (BIZP) ' -- 2024.09.26 추가/변경
			-----------------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN_CUTF (
				   VER_ID
				  ,VER_SEQ
				  ,DIVISION_ID
				  ,PLANT_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,COMPANY_ID
				  ,SITE_ID
				  ,FACTORY_ID
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE
				  ,ATTRIBUTE1
				  ,ATTRIBUTE2
				  ,ATTRIBUTE3
				  ,ATTRIBUTE4
				  ,ATTRIBUTE5
				  ,ATTRIBUTE6
				  ,ATTRIBUTE7
				  ,ATTRIBUTE8
				  ,ATTRIBUTE10
				  )
			SELECT @V_VER_ID
				  ,@V_VER_SEQ  
				  ,LP.DIVISION_ID
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,LP.MSR_TP_CD
				  ,LP.YYYYMM
				  ,LP.MSR_GR_CD
				  ,LP.MSR_NVL
				  ,LP.MSR_DDN
				  ,@v_program_name							AS CREATED_BY
				  ,getdate()								AS CREATION_DATE
				  ,@v_program_name							AS LAST_UPDATED_BY
				  ,getdate()								AS LAST_UPDATE_DATE 
				  ,LP.ATTRIBUTE1
				  ,LP.ATTRIBUTE2
				  ,LP.ATTRIBUTE3
				  ,LP.ATTRIBUTE4
				  ,LP.ATTRIBUTE5
				  ,LP.ATTRIBUTE6
				  ,LP.ATTRIBUTE7
				  ,LP.ATTRIBUTE8
				  ,'[BIZP_VER_ID='+LP.BIZP_VER_ID+'][BIZP_VER_SEQ='+CONVERT(NVARCHAR(10), LP.BIZP_VER_SEQ)+'][REF_YYYYMM='+LP.REF_YYYYMM	AS ATTRIBUTE10
			FROM #BIZP_CAPA_LOSS_PLAN  LP
			WHERE 1=1
			
			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 조립팩 SOP 정보 백업'  -- 2024.09.25
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_LINE_SOP_B	(
				   HISTORY_SEQ
				  ,HISTORY_CREATION_DATE
				  ,DIVISION_ID
				  ,COMPANY_ID
				  ,SITE_ID
				  ,PLANT_ID
				  ,FACTORY_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,VALID_YN
				  ,SOP_DT
				  ,SOP_YM
				  ,SOP_DDN 
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE
				  ,ATTRIBUTE1
				  ,ATTRIBUTE2
				  ,ATTRIBUTE3			)
			SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_LINE_SOP_B	AS HISTORY_SEQ
				  ,GETDATE()									AS HISTORY_CREATION_DATE
				  ,SP.DIVISION_ID
				  ,SP.COMPANY_ID
				  ,SP.SITE_ID
				  ,SP.PLANT_ID
				  ,SP.FACTORY_ID
				  ,SP.LINE_ID
				  ,SP.OPERATION_ID
				  ,SP.ELTR_LN_TP_CD
				  ,SP.VALID_YN
				  ,SP.SOP_DT
				  ,SP.SOP_YM
				  ,SP.SOP_DDN 
				  ,SP.CREATED_BY
				  ,SP.CREATION_DATE
				  ,SP.LAST_UPDATED_BY
				  ,SP.LAST_UPDATE_DATE
				  ,@v_program_name					AS ATTRIBUTE1
				  ,@V_VER_ID						AS ATTRIBUTE2
				  ,CONVERT(NVARCHAR(5), @V_VER_SEQ)	AS ATTRIBUTE3
			  FROM #SCP_MST_CAPA_LINE_SOP SP WITH(NOLOCK)
			 WHERE 1=1

		  ------ End 조립/팩
		  ------ End 조립/팩
		  ------ End 조립/팩


		  ------ Start 전극 
		  ------ Start 전극 
		  ------ Start 전극 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) +  N' 전극 LOSS 모델별 Cutoff 데이터 삭제 - 생산시간(PROD_TM) ' 
			-------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF   
			 WHERE 1=1
			   AND VER_ID		= @V_VER_ID
			   AND VER_SEQ		= @V_VER_SEQ
			   AND DIVISION_ID	= @V_DIVISION_ID
			   AND MSR_TP_CD	= 'PROD_TM'

			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 모델별 Cutoff 데이터 추가 - 생산시간(PROD_TM) ' 
			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF(
					 VER_ID
					,VER_SEQ
					,DIVISION_ID
					,PLANT_ID
					,LINE_ID
					,OPERATION_ID
					,ELTR_LN_TP_CD
					,MDL_NM
					,COMPANY_ID
					,SITE_ID
					,FACTORY_ID
					,MSR_TP_CD
					,YYYYMM
					,MSR_GR_CD
					,MSR_NVL
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
			)   
			SELECT @V_VER_ID
				  ,@V_VER_SEQ 
				  ,LS.DIVISION_ID
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,LS.ELTR_LN_TP_CD
				  ,LS.MDL_NM
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
				  ,LS.MSR_TP_CD
				  ,LS.YYYYMM
				  ,LS.MSR_GR_CD
				  ,LS.MSR_NVL
				  ,@v_program_name		AS CREATED_BY
				  ,getdate()			AS CREATION_DATE
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,getdate()			AS LAST_UPDATE_DATE 
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS
			WHERE 1=1
			  AND LS.MSR_TP_CD = 'PROD_TM'
			  AND LS.YYYYMM   != 'BASE'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인 - DELETE  SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF ' 
			-------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF   
			 WHERE 1=1
			   AND VER_ID		= @V_VER_ID
			   AND VER_SEQ		= @V_VER_SEQ 
			   AND DIVISION_ID	= @V_DIVISION_ID

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인 - INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF (
				   VER_ID
				  ,VER_SEQ
				  ,DIVISION_ID
				  ,PLANT_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,COMPANY_ID
				  ,SITE_ID
				  ,FACTORY_ID
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE
				  ,ATTRIBUTE1
				  ,ATTRIBUTE2
				  ,ATTRIBUTE3
				  )
			SELECT @V_VER_ID
				  ,@V_VER_SEQ  
				  ,AK.DIVISION_ID
				  ,AK.PLANT_ID
				  ,AK.LINE_ID
				  ,AK.OPERATION_ID
				  ,AK.ELTR_LN_TP_CD
				  ,AK.COMPANY_ID
				  ,AK.SITE_ID
				  ,AK.FACTORY_ID
				  ,LT.MSR_TP_CD
				  ,LT.YYYYMM
				  ,LT.MSR_GR_CD
				  ,LT.MSR_NVL
				  ,LT.MSR_DDN
				  ,@v_program_name							AS CREATED_BY
				  ,getdate()								AS CREATION_DATE
				  ,@v_program_name							AS LAST_UPDATED_BY
				  ,getdate()								AS LAST_UPDATE_DATE 
				  ,ATTRIBUTE1		
				  ,CONVERT(NUMERIC(20,10), YM.YYYYMM_DDN) 	AS ATTRIBUTE2	-- 최대조업일수
				  ,1.0										AS ATTRIBUTE2	-- 설비대수 
			 FROM #ELTR_LOSS_PLAN_LN  LT
				  INNER JOIN #ELTR_ALTER_KEY_INFO_LN AK
						  ON AK.LN_ALTER_KEY = LT.LN_ALTER_KEY
				  INNER JOIN #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP YM
						  ON YM.YYYYMM			= LT.YYYYMM 
						 AND YM.LN_ALTER_KEY	= LT.LN_ALTER_KEY 
			WHERE 1=1 

			---------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인 - INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF - RP Rolling Plan (PRVS) ' 
			---------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF (
				   VER_ID
				  ,VER_SEQ
				  ,DIVISION_ID
				  ,PLANT_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,COMPANY_ID
				  ,SITE_ID
				  ,FACTORY_ID
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE
				  ,ATTRIBUTE1
				  ,ATTRIBUTE2
				  ,ATTRIBUTE3
				  ,ATTRIBUTE10
				  )
			SELECT @V_VER_ID
				  ,@V_VER_SEQ  
				  ,LP.DIVISION_ID
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,LP.MSR_TP_CD
				  ,LP.YYYYMM
				  ,LP.MSR_GR_CD
				  ,LP.MSR_NVL
				  ,LP.MSR_DDN
				  ,@v_program_name							AS CREATED_BY
				  ,getdate()								AS CREATION_DATE
				  ,@v_program_name							AS LAST_UPDATED_BY
				  ,getdate()								AS LAST_UPDATE_DATE 
				  ,LP.ATTRIBUTE1
				  ,LP.ATTRIBUTE2
				  ,LP.ATTRIBUTE3
				  ,'[PRVS_VER_ID='+LP.PRVS_VER_ID+'][PRVS_VER_SEQ='+CONVERT(NVARCHAR(10), LP.PRVS_VER_SEQ)+'][REF_YYYYMM='+LP.REF_YYYYMM	AS ATTRIBUTE10
			FROM #ELTR_PRVS_CAPA_LOSS_PLAN  LP
			WHERE 1=1

			---------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인 - INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF - 사업계획 (BIZP) ' 
			---------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF (
				   VER_ID
				  ,VER_SEQ
				  ,DIVISION_ID
				  ,PLANT_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,COMPANY_ID
				  ,SITE_ID
				  ,FACTORY_ID
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE
				  ,ATTRIBUTE1
				  ,ATTRIBUTE2
				  ,ATTRIBUTE3
				  ,ATTRIBUTE10
				  )
			SELECT @V_VER_ID
				  ,@V_VER_SEQ  
				  ,LP.DIVISION_ID
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,LP.MSR_TP_CD
				  ,LP.YYYYMM
				  ,LP.MSR_GR_CD
				  ,LP.MSR_NVL
				  ,LP.MSR_DDN
				  ,@v_program_name							AS CREATED_BY
				  ,getdate()								AS CREATION_DATE
				  ,@v_program_name							AS LAST_UPDATED_BY
				  ,getdate()								AS LAST_UPDATE_DATE 
				  ,LP.ATTRIBUTE1
				  ,LP.ATTRIBUTE2
				  ,LP.ATTRIBUTE3
				  ,'[BIZP_VER_ID='+LP.BIZP_VER_ID+'][BIZP_VER_SEQ='+CONVERT(NVARCHAR(10), LP.BIZP_VER_SEQ)+'][REF_YYYYMM='+LP.REF_YYYYMM	AS ATTRIBUTE10
			FROM #ELTR_BIZP_CAPA_LOSS_PLAN  LP
			WHERE 1=1

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 SOP 정보 백업'  -- 2024.09.25
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_ELTR_LINE_SOP_B	(
				   HISTORY_SEQ
				  ,HISTORY_CREATION_DATE
				  ,DIVISION_ID
				  ,COMPANY_ID
				  ,SITE_ID
				  ,PLANT_ID
				  ,FACTORY_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,VALID_YN
				  ,SOP_DT
				  ,SOP_YM
				  ,SOP_DDN 
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE
				  ,ATTRIBUTE1
				  ,ATTRIBUTE2
				  ,ATTRIBUTE3			)
			SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_ELTR_LINE_SOP_B	AS HISTORY_SEQ
				  ,GETDATE()										AS HISTORY_CREATION_DATE
				  ,SP.DIVISION_ID
				  ,SP.COMPANY_ID
				  ,SP.SITE_ID
				  ,SP.PLANT_ID
				  ,SP.FACTORY_ID
				  ,SP.LINE_ID
				  ,SP.OPERATION_ID
				  ,SP.ELTR_LN_TP_CD
				  ,SP.VALID_YN
				  ,SP.SOP_DT
				  ,SP.SOP_YM
				  ,SP.SOP_DDN 
				  ,SP.CREATED_BY
				  ,SP.CREATION_DATE
				  ,SP.LAST_UPDATED_BY
				  ,SP.LAST_UPDATE_DATE
				  ,@v_program_name					AS ATTRIBUTE1
				  ,@V_VER_ID						AS ATTRIBUTE2
				  ,CONVERT(NVARCHAR(5), @V_VER_SEQ)	AS ATTRIBUTE3
			  FROM #SCP_MST_CAPA_ELTR_LINE_SOP SP WITH(NOLOCK)
			 WHERE 1=1

		  ------ End 전극 
		  ------ End 전극 
		  ------ End 전극 

		------------------------- Start 버전 상태 처리  
		------------------------- Start 버전 상태 처리 
		
			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN ' 
			-------------------------------------------------------------------------------------------------------------------
			UPDATE CV SET PROG_STAT = '2'	-- 2차 컷오프 완료 
	 					 ,LAST_UPDATED_BY			= @v_program_name
	 					 ,LAST_UPDATE_DATE			= GETDATE() 
						 ,ATTRIBUTE10		= '[PROG_STAT:''1'' to ''2'']'+CONVERT(NVARCHAR(100), GETDATE(), 25)
			 FROM SCP_MST_CAPA_VERSION CV WITH(NOLOCK)
			WHERE 1=1
			  AND CV.DIVISION_ID	= @V_DIVISION_ID
			  AND CV.VER_ID			= @V_VER_ID
			  AND CV.VER_SEQ		= @V_VER_SEQ
			  AND CV.PROG_STAT		= '1'	-- 1차 컷오프 완료

		--------------------------- end 버전 상태 처리  
		--------------------------- end 버전 상태 처리  



		  COMMIT TRAN ;  --- transaction 종료  

		------- End Tran : ==========================================================================================================
		------- End Tran : ==========================================================================================================

 			SET @v_log_type = 'TXN';
			SET @v_log_message = 'END - '+@v_division_id;     
			SET @v_description = '['+ @v_division_id + '::' + @V_VER_ID + '::' + CONVERT(NVARCHAR(10), @V_VER_SEQ) +  ']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
			SET @v_log_message = NULL 


		   FETCH NEXT FROM CAPA_VER_DATA INTO  @V_DIVISION_ID
											  ,@V_VER_ID
											  ,@V_VER_SEQ

        END  ----- // WHILE @@FETCH_STATUS = 0
		
        CLOSE CAPA_VER_DATA ;
        DEALLOCATE CAPA_VER_DATA;   -- 메모리 해제 - 2025.03.17 위치 변경 

		-- 2025.01.06 CPS_BATCH_PROC_RUN lookup 참조하여 next 버전 생성 프로시저 수행
		IF EXISTS (SELECT 1
					 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
					WHERE LK.LOOKUP_TYPE	= 'CPS_BATCH_PROC_RUN'
					  AND LK.SEGMENT1		= 'PR_SCP_MST_CAPA_CUTF_2ND'			-- 상위 프로시저 : 2차 컷오프
					  AND LK.SEGMENT2		= 'PR_SCP_MST_CAPA_VERSION_CREATION'	-- 하위 프로시저 : CPS 버전 생성 
					  AND LK.VALID_YN		= 'Y'
					  AND LK.ATTRIBUTE1		= 'Y'										-- 수행여부 
					) 
		BEGIN
			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 다음 Plan 버전 생성 ################################### ' 
			-------------------------------------------------------------------------------------------------------------------
			EXEC PR_SCP_MST_CAPA_VERSION_CREATION	-- 다음 버전 생성 
		END;
		

	  END ------------------------------------ // IF @V_IS_MANUAL = 'Y' OR 2차 컷오프 수행일 

		---------------------------------------
		---- 임시테이블 정리
		-----------------------------------------
		-- 조립/팩 
		IF OBJECT_ID('TEMPDB..#Cutoff_Date_Info') IS NOT NULL DROP TABLE #Cutoff_Date_Info;
		if object_id('tempdb..#CPS_FORMATION_OPERATION') is not null drop table #CPS_FORMATION_OPERATION;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF;
		IF OBJECT_ID('TEMPDB..#LOSS_PLAN_LN_TTZM') IS NOT NULL DROP TABLE #LOSS_PLAN_LN_TTZM;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_SPEED_PLAN_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_SPEED_PLAN_CUTF	;
		IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO;
		IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_LN') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_LN
		IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		IF OBJECT_ID('TEMPDB..#PPM') IS NOT NULL DROP TABLE #PPM;
		IF OBJECT_ID('TEMPDB..#AV_LD_OP_PF_QL') IS NOT NULL DROP TABLE #AV_LD_OP_PF_QL;
		IF OBJECT_ID('TEMPDB..#MSR_DDN') IS NOT NULL DROP TABLE #MSR_DDN;
		IF OBJECT_ID('TEMPDB..#MSR_DDN_LN_SUM') IS NOT NULL DROP TABLE #MSR_DDN_LN_SUM;
		IF OBJECT_ID('TEMPDB..#LOSS_RSLT_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_RSLT_WITH_ALTER_KEY
		IF OBJECT_ID('TEMPDB..#EQP_SPED_RESULT') IS NOT NULL DROP TABLE #EQP_SPED_RESULT;
		IF OBJECT_ID('TEMPDB..#PRVS_CAPA_LOSS_PLAN') IS NOT NULL DROP TABLE #PRVS_CAPA_LOSS_PLAN; 
		IF OBJECT_ID('TEMPDB..#BIZP_CAPA_LOSS_PLAN') IS NOT NULL DROP TABLE #BIZP_CAPA_LOSS_PLAN; 
		IF OBJECT_ID('TEMPDB..#AV_LD_OP_PF_QL_LN') IS NOT NULL DROP TABLE #AV_LD_OP_PF_QL_LN;
		IF OBJECT_ID('TEMPDB..#MSR_DDN_LN') IS NOT NULL DROP TABLE #MSR_DDN_LN;
		IF OBJECT_ID('TEMPDB..#EQP_NBU_THRY_CAPA_D') IS NOT NULL DROP TABLE #EQP_NBU_THRY_CAPA_D;
		IF OBJECT_ID('TEMPDB..#AV_LD_OP_PF_QL_LN_RT_DDN') IS NOT NULL DROP TABLE #AV_LD_OP_PF_QL_LN_RT_DDN;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LINE_SOP') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LINE_SOP
		IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO_APPLIED_SOP') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO_APPLIED_SOP
		---- 전극  
		IF OBJECT_ID('TEMPDB..#ELTR_LOSS_PLAN_LN') IS NOT NULL DROP TABLE #ELTR_LOSS_PLAN_LN;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF;
		IF OBJECT_ID('TEMPDB..#ELTR_ALTER_KEY_INFO_LN') IS NOT NULL DROP TABLE #ELTR_ALTER_KEY_INFO_LN
		IF OBJECT_ID('TEMPDB..#ELTR_YYYYMM_DAYS_INFO') IS NOT NULL DROP TABLE #ELTR_YYYYMM_DAYS_INFO;
		IF OBJECT_ID('TEMPDB..#ELTR_LOSS_RSLT_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #ELTR_LOSS_RSLT_WITH_ALTER_KEY
		IF OBJECT_ID('TEMPDB..#ELTR_PRVS_CAPA_LOSS_PLAN') IS NOT NULL DROP TABLE #ELTR_PRVS_CAPA_LOSS_PLAN; 
		IF OBJECT_ID('TEMPDB..#ELTR_BIZP_CAPA_LOSS_PLAN') IS NOT NULL DROP TABLE #ELTR_BIZP_CAPA_LOSS_PLAN; 
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_SOP') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_SOP
		IF OBJECT_ID('TEMPDB..#ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP') IS NOT NULL DROP TABLE #ELTR_YYYYMM_DAYS_INFO_APPLIED_SOP


	 END			    
	END TRY

	BEGIN CATCH                  
		if (xact_state() <> 0) ROLLBACK TRAN; 
		IF CURSOR_STATUS('GLOBAL','CAPA_VER_DATA') >= 0		CLOSE CAPA_VER_DATA;		-- 2025.03.17
		IF CURSOR_STATUS('GLOBAL','CAPA_VER_DATA') != -3	DEALLOCATE CAPA_VER_DATA;	-- 2025.03.17

		-- ERROR LOG                  
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
    SET @v_description = N'['  + @v_exec_time + ']';  ;            
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
	PRINT @v_log_message      + ' : ' + @v_description ;          
	RETURN 1;    

END
