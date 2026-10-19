



/*  
 * Program ID   : PR_SCP_MST_CAPA_CUTF_1ST
 * Description  : SCP Capa 1차 Cutoff 수행 프로시저
 *				 
 *			### Source Table 
 * 				  SCP_MST_CAPA_VERSION
 *				  SCP_MST_CAPA_LINE_ASSIGN
 *				  SCP_MST_CAPA_SPEED_PLAN
 *				  SCP_MST_CAPA_LOSS_PLAN_MDL
 *				  SCP_MST_CAPA_LOSS_PLAN_LN
 *				  SCP_MST_MDL_EQP_SPED
 *				  SCP_MST_MDL_ELTR_QTY
 *				  SCM_ADM_LOOKUP_MASTER_DETAIL
 *				  SCM_MST_BUCKET
 *				  SCP_RPT_CAPA_LINE_SOP
 *				  -- 전극
 *				  SCP_MST_CAPA_ELTR_LINE_ASSIGN
 *				  SCP_MST_CAPA_ELTR_SPEED_PLAN
 *				  SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
 *				  SCP_MST_CAPA_ELTR_LOSS_PLAN_LN
 *				  SCM_MMD_EQPT_PRDT_SPEED_SN
 *				  SCM_MST_EQUIPMENT_SN
 *				  SCP_RPT_CAPA_ELTR_LINE_SOP
 *
 *			### Target Table 
 *				  SCP_MST_CAPA_VERSION
 * 				  SCP_MST_CAPA_LINE_ASSIGN_CUTF
 *				  SCP_MST_CAPA_SPEED_PLAN_CUTF
 *				  SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF
 *				  SCP_MST_CAPA_LOSS_PLAN_LN
 *				  SCP_RPT_CAPA_LOB
 *				  SCP_RPT_CAPA_LINE_SOP_B
 *				  -- 전극
 * 				  SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
 *				  SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF
 *				  SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
 *				  SCP_MST_CAPA_ELTR_LOSS_PLAN_LN   --> scp 생산계획 반영후 적용 !!!! 삭제 6/13 
 *				  SCP_RPT_CAPA_ELTR_LINE_SOP_B
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.04.17	hrkim		Initial Release PJ2024-50026 / LGES2024-002455   Capa. 관리 시스템 구축  
 * 2024.05.03	hrkim		Line Assign에서 대상이 아닌 건들은 Speed/Loss Current 목록이 생성되지 않음
 *							- 컷오프 대상 필터링시 Line Assign의 Valid_yn 및 assign priority 정보 확인 불필요 ! (5/3 이성찬 부장님) 
 * 2024.05.06	hrkim		result/base 이론 Capa(일) 
 * 2024.05.07	hrkim		base의 이론 Capa(일)은 speed plan의 base ppm 적용  (실적의 이론 Capa(일)은 최근 3개월 속도실적 평균의 PPM 계산적용) 
 * 2024.05.09	hrkim		생산 Capa(월) -> Total Capa로 변경 (해당월의 총 Capa 또는 해당년도의 총 Capa) 
 * 2024.05.10	hrkim		Loss 모델별 Cutoff 데이터에 설비대수 추가 (EQP_NBU) 
 * 2024.05.13	hrkim		Loss 모델별 Cutoff 데이터에 설비대수 제외 (2차 컷오프시 speed plan cutoff 데이터 참조하여 라인별 컷오프 데이터 생성) 
 * 2024.05.14	hrkim		설비속도단위 lookup 참조 : OPERATION_ELECTRODE_TYPE
 * 2024.05.16	hrkim		모델별 Loss plan Total Capa.(PROD_CAPA_M measure) MSR_DDN에 최대조업일수 적재
 * 2024.05.27	hrkim		소수 자릿수 처리 로직 보완 (FLOAT, NUMERIC(20,10) 
 * 2024.06.10	hrkim		실적은 Capa 계산 안함 
 * 2024.06.12	hrkim		전극 추가  
 * 2024.06.13	hrkim		전극 라인별 비조업 -> scp 생산계획 반영 프로시저에 로직 반영  
 * 2024.07.05	hrkim		전월 current 데이터 컷오프 가능하도록 수정 
 * 2024.07.10	hrkim		전극 테이블 PK 변경 : ELTR_LN_TP_CD 컬럼 PK컬럼에서 제외
 * 2024.07.26	hrkim		LOB - 팩공정은 neck공정 여부 저장 안함 (라인별 공정이 하나임) 
 * 2024.08.09	hrkim		speed plan PPM 및 Loss 이론Capa MMD기준 계산 로직 삭제
 * 2024.08.12	hrkim		speed plan PPM 및 Loss 이론Capa MMD기준 계산 로직 삭제 - 오타 수정 및 불필요한 주석처리된 소스 삭제
 * 2024.08.29	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 적용
 * 2024.09.10	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : LOB를 위한 Formation 공정 처리 로직 추가 - lookupType : CPS_FORMATION_OPERATION
 * 2024.09.12	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 적용 최대조업일수 임시테이블 데이터 타입 수정 (FLOAT) 
 * 2024.09.25	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 정보 백업 
 * 2024.09.26	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : speed plan cutoff 데이터 생성시 CPS Formation공정 제외 처리 
 * 2024.10.04	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : LOB 데이터 생성시 - 비부하 조정 제외 
 * 2024.10.05	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 라인별 current(비조업) 생성시 Formation 제외 처리
 * 2024.10.16	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : Base SOP 적용 안함 
 * 2025.01.14	hrkim		lookup CPS_BATCH_CRTN_THURSDAY(월별 CPS 배치 수행 기준 목요일) 적용 
 *							 - 매월 마지막 목요일 기준으로 전/후 일요일에 1,2차 컷오프 수행 및 해당 주차의 SCP FN 생산계획 적용 
 *							 - lookup이 등록된 경우 해당 목요일 기준으로 전/후 일요일에 1,2차 컷오프 수행 및 해당 주차의 SCP FN 생산계획 적용
 * 2025.02.05	hrkim		개선/목표율 관리 기능 삭제 - 해당 컬럼 참조 소스 삭제 (IPRV_GOL_DIVS_CD/IPRV_GOL_RT)
 * 2025.02.12	hrkim		조립 이론Capa 재계산 로직 추가 
 * 2025.03.17	hrkim		CURSOR오류 - 커서 선언문 위치 변경 
 * 
 */  

CREATE PROCEDURE [dbo].[PR_SCP_MST_CAPA_CUTF_1ST]
	 @P_IS_MANUAL	NVARCHAR(1)		= 'N'
	,@P_DIVISION_ID	NVARCHAR(50)	=  NULL
AS
BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE	@V_IS_MANUAL		NVARCHAR(1)  = @P_IS_MANUAL
	DECLARE @V_DIVISION_ID		NVARCHAR(30) = @P_DIVISION_ID	;
	DECLARE @V_VER_ID			NVARCHAR(10) = NULL	;
	DECLARE @V_VER_SEQ			TINYINT		 = NULL	;

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_CAPA_CUTF_1ST'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	BEGIN TRY
	 BEGIN

		PRINT '------------------------------------------------------------------';
		PRINT '@V_IS_MANUAL			= ' + @V_IS_MANUAL;
		PRINT '@P_DIVISION_ID		= ' + ISNULL(@V_DIVISION_ID, 'ALL');
		PRINT '------------------------------------------------------------------';

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '[division_id:'+ ISNULL(@V_DIVISION_ID, 'ALL') + ']'+ISNULL(@V_IS_MANUAL, 'Z');
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

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
	  			   WHERE YMD_1ST_CUTOFF = CONVERT(NVARCHAR(8), GETDATE(), 112) )  -- 차 컷오프 수행일 
	  BEGIN  ------------------------------------------------------------------------------------- 컷오프 수행일인 경우만 실행!!! 


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

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - LOSS MEASURE 정보' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#LOSS_CODE_INFO') IS NOT NULL DROP TABLE #LOSS_CODE_INFO
		SELECT SEGMENT1		AS LOSS_CD
			  ,DISPLAY_SEQ	AS SORT_ORDER
			  ,ATTRIBUTE3	AS LOSS_GR_CD
			  ,ATTRIBUTE4	AS LOSS_NM
			  ,ATTRIBUTE6	AS LOSS_GR_NM
			  ,ATTRIBUTE8	AS TARGET_YN_1ST
			  ,ATTRIBUTE9	AS TARGET_YN_2ND
		 INTO #LOSS_CODE_INFO  
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE 1=1
		  AND LOOKUP_TYPE = 'SCP_CAPA_LOSS_MEASURE'
		  AND VALID_YN	  = 'Y'

	    -- TRY문 안쪽으로 커서 선언 위치 변경 2025.03.17 
		DECLARE CAPA_VER_DATA  CURSOR FOR
			SELECT DIVISION_ID
				  ,VER_ID
				  ,VER_SEQ
			  FROM SCP_MST_CAPA_VERSION WITH(NOLOCK)
			 WHERE 1=1
			   AND DIVISION_ID	= ISNULL(@P_DIVISION_ID, DIVISION_ID)
			   AND VER_ID		>= CONVERT(NVARCHAR(6), DATEADD(MM, 0, DATEADD(MM, -1, GETDATE()) ), 112) -- 전월/당월  -- 20240705 전월 current 컷오프 가능
			   AND PROG_STAT	= '0'
			   ;

    	OPEN CAPA_VER_DATA
        FETCH NEXT FROM CAPA_VER_DATA INTO @V_DIVISION_ID
										  ,@V_VER_ID
										  ,@V_VER_SEQ
    
        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN

			PRINT '------------------------------------------------------------------';
			PRINT '@V_DIVISION_ID			= ' + @V_DIVISION_ID;
			PRINT '@V_VER_ID				= ' + @V_VER_ID;
			PRINT '@V_VER_SEQ				= ' + CONVERT(NVARCHAR(10), @V_VER_SEQ);
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
			print  convert(varchar(30), getdate(), 121) + N' Line Assign Current Data -  #SCP_MST_CAPA_LINE_ASSIGN'
			--------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LINE_ASSIGN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LINE_ASSIGN;
			SELECT LA.NICK_NAME			AS MDL_NM
				  ,LA.ITEM_ID
			      ,LA.DIVISION_ID
				  ,LA.COMPANY_ID
				  ,LA.SITE_ID
				  ,LA.PLANT_ID
				  ,LA.FACTORY_ID
				  ,LA.LINE_ID
				  ,LA.OPERATION_ID
				  ,LA.ELTR_LN_TP_CD
				  ,LA.YYYYMM
				  ,LA.ASSIGN_PRIORITY
				  ,LA.DUMMY_YN
				  ,LA.VALID_YN
			 INTO #SCP_MST_CAPA_LINE_ASSIGN 
			 FROM SCP_MST_CAPA_LINE_ASSIGN LA WITH(NOLOCK)  
			WHERE 1=1
			  AND LA.DIVISION_ID = @V_DIVISION_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 템프테이블 LOB 보고서 데이터 -  #SCP_RPT_CAPA_LOB' 
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_RPT_CAPA_LOB') IS NOT NULL DROP TABLE #SCP_RPT_CAPA_LOB;
			SELECT CONVERT(INTEGER, 0) AS MDL_ALTER_KEY 
				  ,CONVERT(INTEGER, 0) AS LN_ALTER_KEY 
				  ,DIVISION_ID
				  ,YYYYMM
				  ,MDL_NM
				  ,COMPANY_ID
				  ,SITE_ID
				  ,PLANT_ID
				  ,FACTORY_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,CONVERT(NUMERIC(20,10), THRY_CAPA		   )	AS  THRY_CAPA		
				  ,CONVERT(NUMERIC(20,10), PRDN_CAPA		   )	AS  PRDN_CAPA		
				  ,CONVERT(NUMERIC(20,10), PRDN_OPRT		   )	AS  PRDN_OPRT		
				  ,CONVERT(NUMERIC(20,10), LD_RT			   )	AS  LD_RT			
				  ,CONVERT(NUMERIC(20,10), ADJ_PRDN_CAPA	   )	AS  ADJ_PRDN_CAPA	
				  ,CONVERT(NUMERIC(20,10), ADJ_PRDN_OPRT	   )	AS  ADJ_PRDN_OPRT	
				  ,CONVERT(NUMERIC(20,10), ADJ_LD_RT		   )	AS  ADJ_LD_RT		
				  ,CONVERT(NUMERIC(20,10), ADJ_ULD_RT			)	AS  ADJ_ULD_RT	
				  ,ATTRIBUTE1	-- Neck 공정 여부
				  ,ATTRIBUTE2	-- CPS Formation 공정 여부 (9/10)
			 INTO #SCP_RPT_CAPA_LOB 
			 FROM SCP_RPT_CAPA_LOB WITH(NOLOCK)
			WHERE 1=2 

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
				  ,CONVERT(NUMERIC(20,10), BASE_NVL	)		AS BASE_NVL
				  ,CONVERT(NUMERIC(20,10), BASE_NVL	)		AS BASE_NVL_OLD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,CONVERT(NUMERIC(20,10), IPRV_GOL_RT)		AS IPRV_GOL_RT
				  ,MSR_GR_CD
				  ,CONVERT(NUMERIC(20,10), MSR_NVL	)		AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), MSR_DDN	)		AS MSR_DDN
				  ,CONVERT(NVARCHAR(1)	 , 'N')				AS FORMATION_YN 
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
				  ,CONVERT(NUMERIC(20,10), MSR_NVL	)		AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), MSR_DDN	)		AS MSR_DDN
			 INTO #LOSS_PLAN_LN_TTZM
			 FROM SCP_MST_CAPA_LOSS_PLAN_LN WITH(NOLOCK)
			WHERE 1=2

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 컷오프 대상 Loss Plan Current Data -  #SCP_MST_CAPA_LOSS_PLAN_MDL' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL

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
					,DENSE_RANK() OVER (PARTITION BY 'A' 
										  ORDER BY LS.MDL_NM
												  ,LS.PLANT_ID
												  ,LS.FACTORY_ID	
												  ,LS.LINE_ID
												  ,LS.DIVISION_ID
												  ,LS.COMPANY_ID
												  ,LS.SITE_ID
												) AS LOB_ALTER_KEY
					,LS.MDL_NM
					,LS.PLANT_ID
					,LS.LINE_ID
					,LS.OPERATION_ID
					,LS.ELTR_LN_TP_CD
					,LS.DIVISION_ID
					,LS.COMPANY_ID
					,LS.SITE_ID
					,LS.FACTORY_ID
					,LS.MSR_TP_CD	-- 2024.08.09 이론 Capa loss UI 결과 그대로 반영
					,LS.YYYYMM
					,CONVERT(NUMERIC(20,10), LS.PFRSLT_NVL	)	AS	PFRSLT_NVL	
					,CONVERT(NUMERIC(20,10), LS.BASE_NVL	)	AS	BASE_NVL	
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,LS.IPRV_GOL_DIVS_CD
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,CONVERT(NUMERIC(20,10), LS.IPRV_GOL_RT	)	AS	IPRV_GOL_RT
					,LS.MSR_GR_CD
					,CONVERT(NUMERIC(20,10), LS.MSR_NVL		)	AS	MSR_NVL
					,CASE WHEN FO.OPERATION_ID IS NULL
						  THEN 'N'
						  ELSE 'Y'
					 END										AS FORMATION_YN		-- 2024.09.10 추가 
			 INTO #SCP_MST_CAPA_LOSS_PLAN_MDL 
			 FROM SCP_MST_CAPA_LOSS_PLAN_MDL LS WITH(NOLOCK)
				  LEFT  JOIN #CPS_FORMATION_OPERATION FO	-- CPS Formation 공정
						  ON FO.OPERATION_ID = LS.OPERATION_ID
				  INNER JOIN #SCP_MST_CAPA_LINE_ASSIGN LA  --line assign valid_yn = 'Y'인 것만 대상으로함
						  ON LA.MDL_NM			= LS.MDL_NM
						     AND LA.DIVISION_ID		= LS.DIVISION_ID
						     AND LA.COMPANY_ID		= LS.COMPANY_ID
						     AND LA.SITE_ID			= LS.SITE_ID
						     AND LA.PLANT_ID		= LS.PLANT_ID
						     AND LA.FACTORY_ID		= LS.FACTORY_ID
						     AND LA.LINE_ID			= LS.LINE_ID
						     AND LA.OPERATION_ID	= LS.OPERATION_ID
						     AND LA.ELTR_LN_TP_CD	= LS.ELTR_LN_TP_CD
							 AND LA.YYYYMM			= LS.YYYYMM
							 AND LA.VALID_YN		= 'Y'  				-- 2024.09.02
							 AND ISNULL(LA.ASSIGN_PRIORITY, 0) != 0		-- 2024.09.02
			WHERE 1=1
			  AND LS.DIVISION_ID = @V_DIVISION_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 월별 일수 정보 -  #YYYYMM_DAYS_INFO' 
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO;

			SELECT DISTINCT YYYYMM
						   ,CONVERT(FLOAT,
								CASE WHEN LEN(YYYYMM) = 4  
									 THEN DATEDIFF(DD, CONVERT(DATE, YYYYMM+'0101', 112)
													 , DATEADD(YY, 1, CONVERT(DATE, YYYYMM+'0101', 112)))	-- 년일수
									 ELSE DATEDIFF(DD, CONVERT(DATE, YYYYMM+'01', 112)
													 , DATEADD(MM, 1, CONVERT(DATE, YYYYMM+'01', 112)))		-- 월일수
								END)  AS YYYYMM_DDN 
			 INTO #YYYYMM_DAYS_INFO  
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LS WITH(NOLOCK)
			WHERE 1=1
			UNION ALL
			SELECT 'BASE'	AS YYYYMM
				  ,CONVERT(FLOAT, 
						DATEDIFF(DD, CONVERT(DATE, @V_VER_ID+'01', 112)
							       , DATEADD(MM, 1, CONVERT(DATE, @V_VER_ID+'01', 112)))	-- Base는 Plan진행 버전월의 일수 
								   )

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 모델별 ALTER KEY 정보 - #ALTER_KEY_INFO_FOR_MDL' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_MDL') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_MDL

			SELECT DISTINCT
				   LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.LOB_ALTER_KEY
				  ,LS.MDL_NM
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,LS.ELTR_LN_TP_CD
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
				  ,LS.FORMATION_YN -- 9/10 CPS Formation 공정 여부 
			INTO #ALTER_KEY_INFO_FOR_MDL
			FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LS  WITH(NOLOCK)

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
				  ,LS.FORMATION_YN -- 9/10 CPS Formation 공정 여부 
			INTO #ALTER_KEY_INFO_FOR_LN
			FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LS  WITH(NOLOCK)


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - SOP Master 정보 - #SCP_MST_CAPA_LINE_SOP' -- 2024.08.30   
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
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - SOP 정보' -- 2024.08.29 SOP 적용  
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SOP_INFO') IS NOT NULL DROP TABLE #SOP_INFO

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
		SELECT AK.MDL_ALTER_KEY
			  ,AK.MDL_NM
			  ,SP.DIVISION_ID
			  ,SP.COMPANY_ID
			  ,SP.SITE_ID
			  ,SP.PLANT_ID
			  ,SP.FACTORY_ID
			  ,SP.LINE_ID
			  ,SP.OPERATION_ID
			  ,SP.ELTR_LN_TP_CD
			  ,SP.SOP_DT
			  ,SP.SOP_YM
			  ,CONVERT(FLOAT, SP.SOP_DDN) AS SOP_DDN 
		  INTO #SOP_INFO
		  FROM CAPA_LINE_SOP SP WITH(NOLOCK) 
			   INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK
					   ON AK.DIVISION_ID	= SP.DIVISION_ID
					  AND AK.COMPANY_ID		= SP.COMPANY_ID
					  AND AK.SITE_ID		= SP.SITE_ID
					  AND AK.PLANT_ID		= SP.PLANT_ID
					  AND AK.FACTORY_ID		= SP.FACTORY_ID
					  AND AK.LINE_ID		= SP.LINE_ID
					  AND AK.OPERATION_ID	= SP.OPERATION_ID
					  AND AK.ELTR_LN_TP_CD	= SP.ELTR_LN_TP_CD
		 WHERE 1=1


	------------------- begin Speed Plan Cutoff 
	------------------- begin Speed Plan Cutoff 

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Speed Plan Cutoff 대상 데이터 - #SCP_MST_CAPA_SPEED_PLAN_CUTF' 
			-- 2024.08.09 MMD기준 PPM 재계산 반영 로직 (UI결과 그대로 반영함)
			-- 라인 Assign된 데이터만 대상으로 한다.
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_SPEED_PLAN_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_SPEED_PLAN_CUTF;
			SELECT 
			  SP.DIVISION_ID
			 ,SP.COMPANY_ID
			 ,SP.SITE_ID
			 ,SP.PLANT_ID
			 ,SP.FACTORY_ID
			 ,SP.LINE_ID
			 ,SP.OPERATION_ID
			 ,SP.ELTR_LN_TP_CD
			 ,SP.ITEM_ID
			 ,SP.NICK_NAME
			 ,SP.MSR_TP_CD
			 ,SP.YYYYMM
			 ,SP.BASE_QTY
			 ,SP.QTY
			 ,SP.UI_UPD_YN
			 ,SP.REMARK
			 INTO #SCP_MST_CAPA_SPEED_PLAN_CUTF
			 FROM SCP_MST_CAPA_SPEED_PLAN SP WITH(NOLOCK) 
				  INNER JOIN #SCP_MST_CAPA_LINE_ASSIGN LA  --line assign valid_yn = 'Y'인 것만 대상으로함 
						  ON LA.MDL_NM			= SP.NICK_NAME
						 AND LA.DIVISION_ID		= SP.DIVISION_ID
						 AND LA.COMPANY_ID		= SP.COMPANY_ID
						 AND LA.SITE_ID			= SP.SITE_ID
						 AND LA.PLANT_ID		= SP.PLANT_ID
						 AND LA.FACTORY_ID		= SP.FACTORY_ID
						 AND LA.LINE_ID			= SP.LINE_ID
						 AND LA.OPERATION_ID	= SP.OPERATION_ID
						 AND LA.ELTR_LN_TP_CD	= SP.ELTR_LN_TP_CD
						 AND LA.YYYYMM			= SP.YYYYMM
						 AND LA.VALID_YN		= 'Y'  			   -- 2024.09.02
						 AND ISNULL(LA.ASSIGN_PRIORITY, 0) != 0	   -- 2024.09.02
			WHERE 1=1
			  AND SP.DIVISION_ID = @V_DIVISION_ID
			  AND SP.OPERATION_ID NOT IN (SELECT OPERATION_ID FROM #CPS_FORMATION_OPERATION) -- 2024.09.26 CPS Formation공정 제외 

			-----------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'speed plan PPM 재계산 반영 (속도단위 MMS,CPM) - update Loss 이론 capa' 
			-- 2025.02.12 조립 Loss 이론Capa 재계산 반영 -- 혹시라도 UI결과가 안맞을 경우 대비.. 
			-- 이론Capa = PPM * 1440 
			-----------------------------------------------------------------------------------------------------------------------------------------------------
			UPDATE LP 
			   SET LP.BASE_NVL	= CONVERT(FLOAT, SP.BASE_QTY) * CONVERT(FLOAT, 1440)
				  ,LP.MSR_NVL	= CONVERT(FLOAT, SP.QTY) * CONVERT(FLOAT, 1440)
			FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)  --- DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, ELTR_LN_TP_CD, MDL_NM, COMPANY_ID, SITE_ID, FACTORY_ID, MSR_TP_CD, YYYYMM
				 INNER JOIN #SCP_MST_CAPA_SPEED_PLAN_CUTF  SP	
				 		 ON SP.DIVISION_ID		= LP.DIVISION_ID
						AND SP.COMPANY_ID		= LP.COMPANY_ID
						AND SP.SITE_ID			= LP.SITE_ID
						AND SP.PLANT_ID			= LP.PLANT_ID
						AND SP.FACTORY_ID		= LP.FACTORY_ID
						AND SP.LINE_ID			= LP.LINE_ID
						AND SP.OPERATION_ID		= LP.OPERATION_ID
						AND SP.ELTR_LN_TP_CD	= LP.ELTR_LN_TP_CD
						AND SP.NICK_NAME		= LP.MDL_NM
						AND SP.YYYYMM			= LP.YYYYMM
						AND SP.MSR_TP_CD		= 'PPM' 
			WHERE 1=1
			  AND LP.MSR_TP_CD	= 'THRY_CAPA_D'

	------------------- end Speed Plan Cutoff 
	------------------- end Speed Plan Cutoff 

	------------------- begin LOB
	------------------- begin LOB

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  대상 Current Loss Data 추출 ' 
			-- 2024/9/10 CPS Formation 공정 제외 처리 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ALTER_KEY_MAPPING_LOSS_DATA') IS NOT NULL DROP TABLE #ALTER_KEY_MAPPING_LOSS_DATA

			--- 부하율/가동률 추가 - 비부하, 비가동
			SELECT LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.LOB_ALTER_KEY
				  ,LS.MSR_GR_CD
				  ,LS.MSR_TP_CD
				  ,LS.YYYYMM
				  ,CONVERT(NUMERIC(20,10), LS.MSR_NVL)	AS MSR_NVL
			 INTO #ALTER_KEY_MAPPING_LOSS_DATA  --- select 
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LS WITH(NOLOCK)
			WHERE 1=1
			  AND LS.MSR_TP_CD != 'ADJ_ULD_RT'		-- 2024.10.04 추가      ---- 비부하 보정 제외 
			  AND (MSR_GR_CD IN ('NLD','NOP') 
				   OR 
				   MSR_TP_CD IN ('PF_RT', 'QL_RT', 'THRY_CAPA_D')) 
			  AND LS.FORMATION_YN = 'N' -- 9/10 CPS Formation 공정 제외  

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  비부하/비가동 TOTAL 추가 ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT #ALTER_KEY_MAPPING_LOSS_DATA
			SELECT LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.LOB_ALTER_KEY
				  ,'-'					AS MSR_GR_CD
				  ,LS.MSR_GR_CD			AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,SUM(LS.MSR_NVL)		AS MSR_NVL
			 FROM #ALTER_KEY_MAPPING_LOSS_DATA LS WITH(NOLOCK)
			WHERE 1=1
			  AND MSR_GR_CD IN ('NLD', 'NOP') 
			GROUP BY LS.MDL_ALTER_KEY
					,LS.LN_ALTER_KEY
					,LS.LOB_ALTER_KEY
					,LS.MSR_GR_CD
					,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  부하/가동 비율 TOTAL 추가 (LD_RT/OP_RT) ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT #ALTER_KEY_MAPPING_LOSS_DATA
			SELECT MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,LOB_ALTER_KEY
				  ,'-' AS MSR_GR_CD
				  ,CASE WHEN MSR_TP_CD = 'NLD' THEN 'LD_RT'
						WHEN MSR_TP_CD = 'NOP' THEN 'OP_RT'
						ELSE '-'
				   END  AS MSR_TP_CD
				  ,YYYYMM
				  ,1. - CONVERT(FLOAT, ISNULL(MSR_NVL, 0))
			 FROM #ALTER_KEY_MAPPING_LOSS_DATA LS WITH(NOLOCK)
			WHERE 1=1
			  AND MSR_TP_CD IN ('NLD', 'NOP') 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  생산가동률 추가 ' 
			-------------------------------------------------------------------------------------------------------------------
			--  PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률
			--  LD_RT : 부하율
			--  OP_RT : 시간가동률
			--  PF_RT : 성능가동률
			--  QL_RT : 양품가동률
			-------------------------------------------------------------------------------------------------------------------
			INSERT #ALTER_KEY_MAPPING_LOSS_DATA
			SELECT MDL_ALTER_KEY 
				  ,LN_ALTER_KEY
				  ,LOB_ALTER_KEY
				  ,'-'			AS MSR_GR_CD
				  ,'PROD_OP_RT'	AS MSR_TP_CD
				  ,YYYYMM
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'LD_RT' THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'OP_RT' THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PF_RT' THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'QL_RT' THEN MSR_NVL ELSE 0.0 END)) AS MSR_NVL
			 FROM #ALTER_KEY_MAPPING_LOSS_DATA
			WHERE 1=1
			  AND MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')
			GROUP BY MDL_ALTER_KEY	
					,LN_ALTER_KEY
					,LOB_ALTER_KEY
					,YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  생산 Capa(일) 추가 - Non Formation' 
			-------------------------------------------------------------------------------------------------------------------
			-- PROD_CAPA_D : 생산 CAPA(일) : 이론 Capa(일) * 생산가동률
			-- PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률
			-- THRY_CAPA_D : 이론 CAPA(일) 
			-------------------------------------------------------------------------------------------------------------------
			INSERT #ALTER_KEY_MAPPING_LOSS_DATA
			SELECT MDL_ALTER_KEY 
				  ,LN_ALTER_KEY
				  ,LOB_ALTER_KEY
				  ,'-'				AS MSR_GR_CD
				  ,'PROD_CAPA_D'	AS MSR_TP_CD
				  ,YYYYMM
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'  THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D' THEN MSR_NVL ELSE 0.0 END)) AS MSR_NVL
			 FROM #ALTER_KEY_MAPPING_LOSS_DATA WITH(NOLOCK)
			WHERE 1=1
			  AND MSR_TP_CD IN ('PROD_OP_RT', 'THRY_CAPA_D') 
			GROUP BY MDL_ALTER_KEY	
					,LN_ALTER_KEY
					,LOB_ALTER_KEY
					,YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  생산 Capa(일) 추가 - Formation ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT #ALTER_KEY_MAPPING_LOSS_DATA
			SELECT LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.LOB_ALTER_KEY
				  ,LS.MSR_GR_CD
				  ,LS.MSR_TP_CD
				  ,LS.YYYYMM
				  ,CONVERT(NUMERIC(20,10), ISNULL(LS.MSR_NVL,0))	AS MSR_NVL
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LS WITH(NOLOCK)
			WHERE 1=1
			  AND  MSR_TP_CD = 'PROD_CAPA_D' 
			  AND LS.FORMATION_YN = 'Y'		-- 9/10 CPS Formation 공정 제외  

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  조정 생산가동률(조정률)  - Formation + Non Formation' 
			-------------------------------------------------------------------------------------------------------------------
			-- 조정 생산가동률 (조정률) = 변경후 생산 Capa / 변경전 생산 Capa
			-- after 생산가동률 = before 생산가동률 * (변경후 생산 Capa / 변경전 생산 Capa)
			-- after 부하율     = before 부하율     * (변경후 생산 Capa / 변경전 생산 Capa)
			-- 조정 비부하률    = before 부하율 - after 부하율     
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ADJ_PRDN_CAPA') IS NOT NULL DROP TABLE #ADJ_PRDN_CAPA

			SELECT LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.LOB_ALTER_KEY
				  ,LS.YYYYMM
				  ,CONVERT(FLOAT,	LS.MSR_NVL)							AS PRDN_CAPA
				  ,CONVERT(FLOAT, 
					MIN(MSR_NVL) OVER (PARTITION BY  LS.LOB_ALTER_KEY
												   , LS.YYYYMM))		AS ADJ_PRDN_CAPA
				  ,CONVERT(FLOAT,
				   CASE WHEN MSR_NVL = 0 
						THEN 0.0
						ELSE  CONVERT(FLOAT, MIN(MSR_NVL) OVER (PARTITION BY LOB_ALTER_KEY
															               ,LS.YYYYMM))
							/ CONVERT(FLOAT, MSR_NVL)
				   END)													AS ADJ_RT
			 INTO #ADJ_PRDN_CAPA 
			 FROM #ALTER_KEY_MAPPING_LOSS_DATA LS WITH(NOLOCK)
			WHERE 1=1
			  AND MSR_TP_CD = 'PROD_CAPA_D'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  조정전 생산가동률/부하율/이론CAPP정보 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#BEFORE_PROD_LD_RT') IS NOT NULL DROP TABLE #BEFORE_PROD_LD_RT

			SELECT MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,LOB_ALTER_KEY
				  ,YYYYMM
				  ,CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D'	THEN MSR_NVL ELSE 0.0 END)) AS THRY_CAPA_D
				  ,CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'	THEN MSR_NVL ELSE 0.0 END)) AS PROD_OP_RT
				  ,CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'LD_RT'		THEN MSR_NVL ELSE 0.0 END)) AS LD_RT
			 INTO #BEFORE_PROD_LD_RT
			 FROM #ALTER_KEY_MAPPING_LOSS_DATA LS WITH(NOLOCK)
			WHERE 1=1
			  AND MSR_TP_CD IN ( 'PROD_OP_RT', 'LD_RT', 'THRY_CAPA_D')  -- Non Formation
			GROUP BY MDL_ALTER_KEY
					,LN_ALTER_KEY
					,LOB_ALTER_KEY
					,YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  조정 비부하율(무부하) ' 
			-------------------------------------------------------------------------------------------------------------------
			-- 조정 비부하률    = before 부하율 - after 부하율     
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ADJ_ULD_RT') IS NOT NULL DROP TABLE #ADJ_ULD_RT   

			SELECT AJ.MDL_ALTER_KEY
				  ,AJ.LN_ALTER_KEY
				  ,AJ.LOB_ALTER_KEY
				  ,AJ.YYYYMM												
				  ,CONVERT(NUMERIC(20,10), AJ.PRDN_CAPA													)					AS PRDN_CAPA
				  ,CONVERT(NUMERIC(20,10), AJ.ADJ_PRDN_CAPA												)					AS ADJ_PRDN_CAPA
				  ,CONVERT(NUMERIC(20,10), AJ.ADJ_RT													)					AS ADJ_RT
				  ,CONVERT(NUMERIC(20,10), BP.THRY_CAPA_D												)					AS THRY_CAPA		-- 이론 CAPA
				  ,CONVERT(NUMERIC(20,10), BP.PROD_OP_RT												)					AS PRDN_OPRT		-- 조정전 생산가동률
				  ,CONVERT(NUMERIC(20,10), BP.LD_RT														)					AS LD_RT			-- 조정전 부하율
				  ,CONVERT(NUMERIC(20,10), BP.PROD_OP_RT *  AJ.ADJ_RT									)					AS ADJ_PRDN_OPRT	-- 조정후 생산가동률
				  ,CONVERT(NUMERIC(20,10), BP.LD_RT *  AJ.ADJ_RT										)					AS ADJ_LD_RT		-- 조정후 부하율 (after 부하율) 
				  ,CONVERT(NUMERIC(20,10), BP.LD_RT 
											-
											CONVERT(FLOAT, CONVERT(NUMERIC(20,10), BP.LD_RT *  AJ.ADJ_RT))
																										)					AS ADJ_ULD_RT		-- 조정 비부하율  (before 부하율 - after 부하율) 
			 INTO #ADJ_ULD_RT 
			 FROM #ADJ_PRDN_CAPA AJ WITH(NOLOCK)	-- Non Formation + Formation
				  LEFT  JOIN #BEFORE_PROD_LD_RT BP WITH(NOLOCK)		-- Non Formation -- 2024.09.10 join변경 (Inner -> left) 
						  ON BP.MDL_ALTER_KEY	= AJ.MDL_ALTER_KEY
						 AND BP.LN_ALTER_KEY	= AJ.LN_ALTER_KEY
						 AND BP.LOB_ALTER_KEY	= AJ.LOB_ALTER_KEY
						 AND BP.YYYYMM			= AJ.YYYYMM
			WHERE 1=1

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  LOB 보고서 Final 등록 대상 ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_RPT_CAPA_LOB (
					 MDL_ALTER_KEY
					,LN_ALTER_KEY
					,DIVISION_ID
					,YYYYMM
					,MDL_NM
					,COMPANY_ID
					,SITE_ID
					,PLANT_ID
					,FACTORY_ID
					,LINE_ID
					,OPERATION_ID
					,ELTR_LN_TP_CD
					,THRY_CAPA
					,PRDN_CAPA
					,PRDN_OPRT
					,LD_RT
					,ADJ_PRDN_CAPA
					,ADJ_PRDN_OPRT
					,ADJ_LD_RT
					,ADJ_ULD_RT
					,ATTRIBUTE1  -- neck공정 여부
					,ATTRIBUTE2  -- CPS Formation 공정 여부
				)
			SELECT   AJ.MDL_ALTER_KEY
					,AJ.LN_ALTER_KEY
					,AK.DIVISION_ID
					,AJ.YYYYMM
					,AK.MDL_NM
					,AK.COMPANY_ID
					,AK.SITE_ID
					,AK.PLANT_ID
					,AK.FACTORY_ID
					,AK.LINE_ID
					,AK.OPERATION_ID
					,AK.ELTR_LN_TP_CD
					,ISNULL(AJ.THRY_CAPA	 ,0) AS  THRY_CAPA	 	 -- 2024.09.25 null 0처리 
					,ISNULL(AJ.PRDN_CAPA	 ,0) AS  PRDN_CAPA	 	 -- 2024.09.25 null 0처리 
					,ISNULL(AJ.PRDN_OPRT	 ,0) AS  PRDN_OPRT	 	 -- 2024.09.25 null 0처리 
					,ISNULL(AJ.LD_RT		 ,0) AS  LD_RT		 	 -- 2024.09.25 null 0처리 
					,ISNULL(AJ.ADJ_PRDN_CAPA ,0) AS  ADJ_PRDN_CAPA 	 -- 2024.09.25 null 0처리 
					,ISNULL(AJ.ADJ_PRDN_OPRT ,0) AS  ADJ_PRDN_OPRT 	 -- 2024.09.25 null 0처리 
					,ISNULL(AJ.ADJ_LD_RT	 ,0) AS  ADJ_LD_RT	 	 -- 2024.09.25 null 0처리 
					,CASE WHEN AJ.PRDN_OPRT = 0 AND AJ.ADJ_PRDN_OPRT = 0 -- 조정 전/후 생산Capa가 모두 0이면 조정 비부하율도 0이됨. (capa가 0인 neck공정) 
						  THEN 0.
						  ELSE ISNULL(AJ.ADJ_ULD_RT, 0) -- 2024.09.25 null 0처리 
					 END 
					,CASE WHEN AJ.PRDN_CAPA = AJ.ADJ_PRDN_CAPA 
						  THEN 'Y' 
						  ELSE NULL 
					  END				AS ATTRIBUTE1	-- neck공정 여부 
					,AK.FORMATION_YN	AS ATTRIBUTE2	-- 9/10 CPS Formation 공정 여부 
			 FROM #ADJ_ULD_RT AJ WITH(NOLOCK)
				  INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK WITH(NOLOCK)
						  ON AK.MDL_ALTER_KEY = AJ.MDL_ALTER_KEY 
			WHERE 1=1 

	------------------- end LOB
	------------------- end LOB


	------------------- BEGIN LOSS계획 Model별 Cutoff
	------------------- BEGIN LOSS계획 Model별 Cutoff

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 -  대상 Current Data  ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY

			SELECT MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,MSR_GR_CD
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,CONVERT(NUMERIC(20,10), CASE WHEN MSR_TP_CD = 'THRY_CAPA_D' 
												THEN NULL 
												ELSE PFRSLT_NVL 
											END)		AS PFRSLT_NVL	-- Loss plan의 실적은 Capa 계산 안함.  
				  ,CONVERT(NUMERIC(20,10), BASE_NVL	 )  AS BASE_NVL		-- 20240430 
				  ,CONVERT(NUMERIC(20,10), MSR_NVL	 )  AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10), NULL)		AS MSR_DDN
			 INTO #LOSS_MDL_CUTOFF_WITH_ALTER_KEY 
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
			WHERE 1=1 
			  AND MSR_TP_CD != 'ADJ_ULD_RT'		-- 비부하 보정 제외 
			  AND (MSR_GR_CD IN ('NLD','NOP') 
				   OR 
				   MSR_TP_CD IN ('PF_RT', 'QL_RT', 'THRY_CAPA_D') ) -- 5/13 설비대수 제외  -- 'EQP_NBU'
			  AND LP.FORMATION_YN = 'N'	-- 2024.09.10 CPS Formation 공정 제외 (아래 로직에서 별도 추가 - Daily Prouction Capa) 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 -  비부하 조정률 추가 ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_MDL_CUTOFF_WITH_ALTER_KEY 
			SELECT LO.MDL_ALTER_KEY
				  ,LO.LN_ALTER_KEY
				  ,'NLD'			AS MSR_GR_CD 
				  ,'ADJ_ULD_RT'		AS MSR_TP_CD
				  ,LO.YYYYMM
				  ,0				AS PFRSLT_NVL	-- 20240430 
				  ,0				AS BASE_NVL		-- 20240430 
				  ,LO.ADJ_ULD_RT	AS MSR_NVL
				  ,NULL				AS MSR_DDN
			 FROM #SCP_RPT_CAPA_LOB LO WITH(NOLOCK)
			 	  INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK  -- 20240925 
						  ON AK.MDL_ALTER_KEY = LO.MDL_ALTER_KEY
			WHERE 1=1
			  AND AK.FORMATION_YN = 'N'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 비부하/비가동 비율 TOTAL 추가 ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY 
			SELECT LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,'-'					AS MSR_GR_CD
				  ,LS.MSR_GR_CD			AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,SUM(CONVERT(FLOAT, LS.PFRSLT_NVL	))	AS PFRSLT_NVL
				  ,SUM(CONVERT(FLOAT, LS.BASE_NVL	))	AS BASE_NVL
				  ,SUM(CONVERT(FLOAT, LS.MSR_NVL	))	AS MSR_NVL
				  ,NULL									AS MSR_DDN
			 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY LS WITH(NOLOCK)
			WHERE 1=1
			  AND MSR_GR_CD IN ('NLD', 'NOP') 
			GROUP BY LS.MDL_ALTER_KEY
					,LS.LN_ALTER_KEY
					,LS.MSR_GR_CD
					,LS.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 부하/가동 비율 TOTAL 추가 (LD_RT/OP_RT)' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
			SELECT MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,'-'  AS MSR_GR_CD
				  ,CASE WHEN MSR_TP_CD = 'NLD' THEN 'LD_RT'
						WHEN MSR_TP_CD = 'NOP' THEN 'OP_RT'
						ELSE '-'
				   END  AS MSR_TP_CD
				  ,YYYYMM
				  ,1.0 - ISNULL(CONVERT(FLOAT,PFRSLT_NVL), 0.)	AS PFRSLT_NVL
				  ,1.0 - ISNULL(CONVERT(FLOAT,BASE_NVL	), 0.)	AS BASE_NVL
				  ,1.0 - ISNULL(CONVERT(FLOAT,MSR_NVL	), 0.)	AS MSR_NVL
				  ,NULL											AS MSR_DDN
			 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY LS WITH(NOLOCK)
			WHERE 1=1
			  AND MSR_TP_CD IN ('NLD', 'NOP') 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 생산가동률' 
			-------------------------------------------------------------------------------------------------------------------
			--  모델별 Cutoff - PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률
			--  모델별 Cutoff - LD_RT : 부하율
			--  모델별 Cutoff - OP_RT : 시간가동률
			--  모델별 Cutoff - PF_RT : 성능가동률
			--  모델별 Cutoff - QL_RT : 양품가동률
			-------------------------------------------------------------------------------------------------------------------
			INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
			SELECT MDL_ALTER_KEY 
				  ,LN_ALTER_KEY 
				  ,'-'			AS MSR_GR_CD
				  ,'PROD_OP_RT'	AS MSR_TP_CD
				  ,YYYYMM
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'LD_RT' THEN PFRSLT_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'OP_RT' THEN PFRSLT_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PF_RT' THEN PFRSLT_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'QL_RT' THEN PFRSLT_NVL ELSE 0.0 END))	AS PFRSLT_NVL
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'LD_RT' THEN BASE_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'OP_RT' THEN BASE_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PF_RT' THEN BASE_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'QL_RT' THEN BASE_NVL ELSE 0.0 END))		AS BASE_NVL
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'LD_RT' THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'OP_RT' THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PF_RT' THEN MSR_NVL ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'QL_RT' THEN MSR_NVL ELSE 0.0 END))		AS MSR_NVL
				  ,NULL				AS MSR_DDN
			 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
			WHERE 1=1
			  AND MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')
			GROUP BY MDL_ALTER_KEY	
					,LN_ALTER_KEY	
					,YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 생산 Capa(일)' 
			-------------------------------------------------------------------------------------------------------------------
			-- 모델별 Cutoff - PROD_CAPA_D : 생산 CAPA(일) : 이론 Capa(일) * 생산가동률
			-- 모델별 Cutoff - PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률
			-- 모델별 Cutoff - THRY_CAPA_D : 이론 CAPA(일) 
			-------------------------------------------------------------------------------------------------------------------
			INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY 
			SELECT MDL_ALTER_KEY 
				  ,LN_ALTER_KEY 
				  ,'-'				AS MSR_GR_CD
				  ,'PROD_CAPA_D'	AS MSR_TP_CD
				  ,YYYYMM
				  ,NULL				AS PFRSLT_NVL
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'  THEN BASE_NVL	 ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D' THEN BASE_NVL	 ELSE 0.0 END))	AS BASE_NVL
				  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'  THEN MSR_NVL	 ELSE 0.0 END)) 
				   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D' THEN MSR_NVL	 ELSE 0.0 END))	AS MSR_NVL
				  ,NULL				AS MSR_DDN
			 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY WITH(NOLOCK)
			WHERE 1=1
			  AND MSR_TP_CD IN ('PROD_OP_RT', 'THRY_CAPA_D') 
			GROUP BY MDL_ALTER_KEY	
					,LN_ALTER_KEY	
					,YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 생산 Capa(월) 추가 - PROD_CAPA_M' 
			-- 생산 Capa(월) = 생산 Capa(일) * 최대조업일수
			-- YYYYMM인 년도인경우 생산 Capa(월) = (생산 Capa(일) * 최대조업일수) / 12 
			-------------------------------------------------------------------------------------------------------------------
			INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
			SELECT  
				   PD.MDL_ALTER_KEY
				  ,PD.LN_ALTER_KEY
				  ,PD.MSR_GR_CD
				  ,'PROD_CAPA_M' AS MSR_TP_CD
				  ,PD.YYYYMM
				  ,NULL													AS PFRSLT_NVL		-- 6/10 실적은 Capa계산 안함. 
				  ,CONVERT(FLOAT, PD.BASE_NVL	) * BASE_YM.YYYYMM_DDN
													/* 2024.10.16 base SOP 적용 안함 
													CASE WHEN BS.SOP_YM IS NOT NULL
														 THEN BS.SOP_DDN
														 ELSE BASE_YM.YYYYMM_DDN
													END	
													*/
													AS BASE_NVL
				  ,CONVERT(FLOAT, PD.MSR_NVL	) * CASE WHEN SO.SOP_YM IS NOT NULL
														 THEN SO.SOP_DDN
														 ELSE YM.YYYYMM_DDN
													 END				AS MSR_NVL 
		 		  ,CASE WHEN SO.SOP_YM IS NOT NULL
						THEN SO.SOP_DDN
						ELSE YM.YYYYMM_DDN
					END													AS MSR_DDN			-- 5/16 최대조업일수 적재 
			  FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY PD WITH(NOLOCK)
				   INNER JOIN #YYYYMM_DAYS_INFO  YM
						   ON YM.YYYYMM = PD.YYYYMM 
				    LEFT JOIN #YYYYMM_DAYS_INFO  BASE_YM
						   ON BASE_YM.YYYYMM = 'BASE' 
					LEFT JOIN #SOP_INFO SO	-- 2024.08.29 SOP 적용 
						   ON SO.MDL_ALTER_KEY = PD.MDL_ALTER_KEY
						  AND SO.SOP_YM		   = PD.YYYYMM
					-- 2024.10.16 base sop 적용 안함 LEFT JOIN #SOP_INFO BS	-- 2024.08.29 SOP 적용 for Base   
					-- 2024.10.16 base sop 적용 안함 	   ON BS.MDL_ALTER_KEY	= PD.MDL_ALTER_KEY
					-- 2024.10.16 base sop 적용 안함 	  AND BS.SOP_YM			= @V_VER_ID
			WHERE 1=1
			  AND PD.MSR_TP_CD = 'PROD_CAPA_D'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 생산 Capa(일) - CPS Formation 공정 ' 
			-- 2024.09.10 CPS Foramtion 공정 추가 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_MDL_CUTOFF_WITH_ALTER_KEY 
			SELECT MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,MSR_GR_CD
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,NULL		AS PFRSLT_NVL
				  ,NULL		AS BASE_NVL	
				  ,MSR_NVL	AS MSR_NVL
				  ,NULL		AS MSR_DDN
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
			WHERE 1=1
			  AND LP.MSR_TP_CD	  = 'PROD_CAPA_D'
			  AND LP.FORMATION_YN = 'Y'				-- 2024.09.10 CPS Formation 공정

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Loss 모델별 Cutoff - 최종 등록 대상' 
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF
			SELECT AK.MDL_ALTER_KEY
				  ,AK.LN_ALTER_KEY
				  ,AK.DIVISION_ID
				  ,AK.MDL_NM
				  ,AK.PLANT_ID
				  ,AK.LINE_ID
				  ,AK.OPERATION_ID
				  ,AK.ELTR_LN_TP_CD
				  ,AK.COMPANY_ID
				  ,AK.SITE_ID
				  ,AK.FACTORY_ID
				  ,MC.MSR_TP_CD
				  ,MC.YYYYMM
				  ,MC.PFRSLT_NVL
				  ,MC.BASE_NVL
				  ,LC.BASE_NVL				AS BASE_NVL_OLD --- 20240430 	
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,LC.IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,LC.IPRV_GOL_RT
				  ,ISNULL(MC.MSR_GR_CD, '-') AS MSR_GR_CD
				  ,MC.MSR_NVL	
				  ,NULL						AS MSR_DDN 
				  ,AK.FORMATION_YN			-- 2024.09.10 CPS Formation 공정 여부
			 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY MC 
				  INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK
						  ON AK.MDL_ALTER_KEY = MC.MDL_ALTER_KEY
				  LEFT  JOIN #SCP_MST_CAPA_LOSS_PLAN_MDL LC 
						  ON LC.MDL_ALTER_KEY	= MC.MDL_ALTER_KEY
						 AND LC.YYYYMM			= MC.YYYYMM
						 AND LC.MSR_TP_CD		= MC.MSR_TP_CD
			WHERE 1=1
			  AND MC.MSR_TP_CD NOT IN ('NLD','NOP') 

	------------------- End LOSS계획 Model별 Cutoff
	------------------- End LOSS계획 Model별 Cutoff


	------------------- BEGIN 라인별 합계 SCP_MST_CAPA_LOSS_PLAN_LN 
	------------------- BEGIN 라인별 합계 SCP_MST_CAPA_LOSS_PLAN_LN 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 비조업 추가 ' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				)
			SELECT AK.LN_ALTER_KEY
				  ,LC.LOSS_CD							AS MSR_TP_CD
				  ,YM.YYYYMM
				  ,LC.LOSS_GR_CD						AS MSR_GR_CD 
				  ,ISNULL(NA.MSR_NVL, 0.)				AS MSR_NVL
				  ,ISNULL(NA.MSR_DDN, NULL)				AS MSR_DDN
			  FROM #LOSS_CODE_INFO LC 
				   INNER JOIN #ALTER_KEY_INFO_FOR_LN AK
						   ON 1=1 
						  AND AK.FORMATION_YN = 'N' -- 2024.10.05 CPS Formation공정 제외 
				   INNER JOIN #YYYYMM_DAYS_INFO YM
						   ON 1=1 
				   LEFT JOIN SCP_MST_CAPA_LOSS_PLAN_LN NA WITH(NOLOCK) 
						   ON NA.DIVISION_ID	= AK.DIVISION_ID
						  AND NA.PLANT_ID		= AK.PLANT_ID
						  AND NA.LINE_ID		= AK.LINE_ID
						  AND NA.OPERATION_ID	= AK.OPERATION_ID
						  AND NA.ELTR_LN_TP_CD	= AK.ELTR_LN_TP_CD
						  AND NA.COMPANY_ID		= AK.COMPANY_ID
						  AND NA.SITE_ID		= AK.SITE_ID
						  AND NA.FACTORY_ID		= AK.FACTORY_ID
						  AND NA.MSR_TP_CD		= LC.LOSS_CD
						  AND NA.YYYYMM			= YM.YYYYMM
						  AND NA.MSR_GR_CD = 'NAV'  -- 비조업 (기등록 Current Data가 있으면 그대로 등록) 
			 WHERE 1=1
			   AND LC.LOSS_GR_CD = 'NAV'   -- 비조업
			   AND EXISTS (SELECT TOP 1  1
							FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY LK
						   WHERE LK.LN_ALTER_KEY = AK.LN_ALTER_KEY
						     AND LK.YYYYMM		 = YM.YYYYMM ) 

			------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - 비조업 추가 (BASE)  -- 2차 컷오프시 base포함 비조업 cutff ' 
			------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #LOSS_PLAN_LN_TTZM(
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_GR_CD
				  ,MSR_NVL
				  ,MSR_DDN
				)
			SELECT DISTINCT 
				   LN_ALTER_KEY
				  ,MSR_TP_CD
				  ,'BASE'	AS YYYYMM
				  ,MSR_GR_CD
				  ,NULL		AS MSR_NVL
				  ,NULL		AS MSR_DDN
			 FROM #LOSS_PLAN_LN_TTZM
			WHERE 1=1
			  AND MSR_GR_CD  = 'NAV' -- 비조업 

	------------------- End 라인별 합계 SCP_MST_CAPA_LOSS_PLAN_LN 
	------------------- End 라인별 합계 SCP_MST_CAPA_LOSS_PLAN_LN 

----------------------- End 조립/팩 -----------------------------------------------------------------------------------------------------------------------
----------------------- End 조립/팩 -----------------------------------------------------------------------------------------------------------------------
----------------------- End 조립/팩 -----------------------------------------------------------------------------------------------------------------------


----------------------- Start 전극 -----------------------------------------------------------------------------------------------------------------------
----------------------- Start 전극 -----------------------------------------------------------------------------------------------------------------------
----------------------- Start 전극 -----------------------------------------------------------------------------------------------------------------------
   
			--------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'전극 Line Assign Current -  #SCP_MST_CAPA_ELTR_LINE_ASSIGN ' 
			--------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_ASSIGN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_ASSIGN;
			SELECT  
			       LA.DIVISION_ID
				  ,LA.COMPANY_ID
				  ,LA.SITE_ID
				  ,LA.PLANT_ID
				  ,LA.FACTORY_ID
				  ,LA.LINE_ID
				  ,LA.OPERATION_ID
				  ,LA.ELTR_LN_TP_CD
				  ,LA.ITEM_ID 
				  ,LA.NICK_NAME
				  ,LA.YYYYMM
				  ,LA.ASSIGN_PRIORITY
				  ,LA.DUMMY_YN 
				  ,LA.VALID_YN
				  ,LA.LANE_QTY
			 INTO #SCP_MST_CAPA_ELTR_LINE_ASSIGN
			 FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN LA WITH(NOLOCK) 
			WHERE 1=1
			  AND LA.DIVISION_ID = @V_DIVISION_ID  

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 컷오프 대상 Loss Plan Current - #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL

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
					,LS.MDL_NM
					,LS.PLANT_ID
					,LS.LINE_ID
					,LS.OPERATION_ID
					,LS.ELTR_LN_TP_CD
					,LS.DIVISION_ID
					,LS.COMPANY_ID
					,LS.SITE_ID
					,LS.FACTORY_ID
					,LS.MSR_TP_CD
					,LS.YYYYMM
					,CONVERT(NUMERIC(20,10), LS.PFRSLT_NVL	)	AS	PFRSLT_NVL	
					,CONVERT(NUMERIC(20,10), LS.BASE_NVL	)	AS	BASE_NVL	
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,LS.IPRV_GOL_DIVS_CD
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,CONVERT(NUMERIC(20,10), LS.IPRV_GOL_RT	)	AS	IPRV_GOL_RT
					,LS.MSR_GR_CD
					,CONVERT(NUMERIC(20,10), LS.MSR_NVL		)	AS	MSR_NVL
			 INTO #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL  
			 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LS WITH(NOLOCK)  
			WHERE 1=1
			  AND LS.DIVISION_ID = @V_DIVISION_ID
			  AND EXISTS (SELECT 1
						   FROM #SCP_MST_CAPA_ELTR_LINE_ASSIGN LA 
						  WHERE 1=1 
						    AND LA.ITEM_ID			= CASE  WHEN LS.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M', 'SCP_PROD_PLAN') 
															THEN LS.MDL_NM
															ELSE LA.ITEM_ID
													  END 
						   AND LA.DIVISION_ID		= LS.DIVISION_ID
						   AND LA.COMPANY_ID		= LS.COMPANY_ID
						   AND LA.SITE_ID			= LS.SITE_ID
						   AND LA.PLANT_ID			= LS.PLANT_ID
						   AND LA.FACTORY_ID		= LS.FACTORY_ID
						   AND LA.LINE_ID			= LS.LINE_ID
						   AND LA.OPERATION_ID		= LS.OPERATION_ID
						   AND LA.YYYYMM			= LS.YYYYMM
						   AND LA.VALID_YN			= 'Y'  
						   AND ISNULL(LA.ASSIGN_PRIORITY, 0) != 0
						   )

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 모델별 ALTER KEY 정보 - #ELTR_ALTER_KEY_INFO_MDL' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_ALTER_KEY_INFO_MDL') IS NOT NULL DROP TABLE #ELTR_ALTER_KEY_INFO_MDL

			SELECT 
				   LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.MDL_NM
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,MAX(LS.ELTR_LN_TP_CD)	AS  ELTR_LN_TP_CD	-- 7/10 PK 컬럼제외
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
			INTO #ELTR_ALTER_KEY_INFO_MDL
			FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LS  WITH(NOLOCK)
			WHERE 1=1
			GROUP  BY 
				   LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.MDL_NM
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 ALTER KEY 정보 - #ELTR_ALTER_KEY_INFO_LN' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_ALTER_KEY_INFO_LN') IS NOT NULL DROP TABLE #ELTR_ALTER_KEY_INFO_LN

			SELECT 
				   LS.LN_ALTER_KEY
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,MAX(LS.ELTR_LN_TP_CD)	AS  ELTR_LN_TP_CD	-- 7/10 PK 컬럼제외
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
			INTO #ELTR_ALTER_KEY_INFO_LN
			FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LS  WITH(NOLOCK)
			WHERE 1=1
			GROUP  BY 
				   LS.LN_ALTER_KEY
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 Speed Plan Current -  #SCP_MST_CAPA_ELTR_SPEED_PLAN' 
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_SPEED_PLAN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_SPEED_PLAN;

			SELECT SP.DIVISION_ID
				  ,SP.COMPANY_ID
				  ,SP.SITE_ID
				  ,SP.PLANT_ID
				  ,SP.FACTORY_ID
				  ,SP.LINE_ID
				  ,SP.OPERATION_ID
				  ,SP.ELTR_LN_TP_CD
				  ,SP.ITEM_ID
				  ,SP.NICK_NAME
				  ,SP.MSR_TP_CD 
				  ,SP.YYYYMM
				  ,SP.BASE_QTY  -- 2024.08.09 MMD기준 설계속도 반영로직 삭제 (speed plan 데이터 그대로 반영)
				  ,SP.QTY
				  ,SP.UI_UPD_YN
				  ,SP.REMARK
				  ,LA.DUMMY_YN
			 INTO #SCP_MST_CAPA_ELTR_SPEED_PLAN 
			 FROM SCP_MST_CAPA_ELTR_SPEED_PLAN SP WITH(NOLOCK) 
				  INNER JOIN #SCP_MST_CAPA_ELTR_LINE_ASSIGN LA
						  ON LA.ITEM_ID			= SP.ITEM_ID
						 AND LA.DIVISION_ID		= SP.DIVISION_ID
						 AND LA.COMPANY_ID		= SP.COMPANY_ID
						 AND LA.SITE_ID			= SP.SITE_ID
						 AND LA.PLANT_ID		= SP.PLANT_ID
						 AND LA.FACTORY_ID		= SP.FACTORY_ID
						 AND LA.LINE_ID			= SP.LINE_ID
						 AND LA.OPERATION_ID	= SP.OPERATION_ID
						 AND LA.YYYYMM			= SP.YYYYMM
						 AND LA.VALID_YN		= 'Y'  
						 AND ISNULL(LA.ASSIGN_PRIORITY, 0) != 0
			WHERE 1=1
			  AND SP.DIVISION_ID	= @V_DIVISION_ID
			  AND SP.MSR_TP_CD		= 'EQP_SPED'		-- 전극은 속도만 존재

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 컷오프 대상 Loss Plan Current - Speed 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
			SELECT   AK.MDL_ALTER_KEY
				    ,AK.LN_ALTER_KEY
					,SP.ITEM_ID		AS MDL_NM
					,SP.PLANT_ID
					,SP.LINE_ID
					,SP.OPERATION_ID
					,SP.ELTR_LN_TP_CD
					,SP.DIVISION_ID
					,SP.COMPANY_ID
					,SP.SITE_ID
					,SP.FACTORY_ID
					,SP.MSR_TP_CD
					,SP.YYYYMM
					,NULL			AS	PFRSLT_NVL	
					,SP.BASE_QTY	AS	BASE_NVL	
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,NULL			AS	IPRV_GOL_DIVS_CD
					-- 2025.02.05 개선/목표일 관리 기능 삭제 ,NULL			AS	IPRV_GOL_RT
					,'-'			AS	MSR_GR_CD
					,SP.QTY			AS	MSR_NVL
			 FROM #SCP_MST_CAPA_ELTR_SPEED_PLAN SP
				  INNER JOIN #ELTR_ALTER_KEY_INFO_MDL  AK
						  ON AK.MDL_NM			= SP.ITEM_ID
						 AND AK.PLANT_ID		= SP.PLANT_ID
						 AND AK.LINE_ID			= SP.LINE_ID
						 AND AK.OPERATION_ID	= SP.OPERATION_ID
						 AND AK.DIVISION_ID		= SP.DIVISION_ID
						 AND AK.COMPANY_ID		= SP.COMPANY_ID
						 AND AK.SITE_ID			= SP.SITE_ID
						 AND AK.FACTORY_ID		= SP.FACTORY_ID
			WHERE MSR_TP_CD = 'EQP_SPED'

----------------------- End 전극 -----------------------------------------------------------------------------------------------------------------------
----------------------- End 전극 -----------------------------------------------------------------------------------------------------------------------
----------------------- End 전극 -----------------------------------------------------------------------------------------------------------------------

		------- Begin Tran : =======================================================================================
		------- Begin Tran : =======================================================================================

		  BEGIN TRAN   --- transaction 시작  

		  ---- Start 조립/팩 
		  ---- Start 조립/팩 

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' (Line Assing Cutoff) DELETE SCP_MST_CAPA_LINE_ASSIGN_CUTF ' 
			------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_LINE_ASSIGN_CUTF 
			WHERE 1=1
			  AND VER_ID		= @V_VER_ID
			  AND VER_SEQ		= @V_VER_SEQ
			  AND DIVISION_ID	= @V_DIVISION_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' (Line Assing Cutoff) DELETE SCP_MST_CAPA_LINE_ASSIGN_CUTF ' 
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_LINE_ASSIGN_CUTF (
				 VER_ID
				,VER_SEQ
				,DIVISION_ID
				,COMPANY_ID
				,SITE_ID
				,PLANT_ID
				,FACTORY_ID
				,LINE_ID
				,OPERATION_ID
				,ELTR_LN_TP_CD
				,ITEM_ID
				,NICK_NAME
				,YYYYMM
				,ASSIGN_PRIORITY
				,DUMMY_YN
				,VALID_YN
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
			SELECT @V_VER_ID	AS VER_ID
				  ,@V_VER_SEQ
				  ,DIVISION_ID
				  ,COMPANY_ID
				  ,SITE_ID
				  ,PLANT_ID
				  ,FACTORY_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,ITEM_ID
				  ,MDL_NM				AS NICK_NAME
				  ,YYYYMM
				  ,ASSIGN_PRIORITY
				  ,DUMMY_YN
				  ,VALID_YN
				  ,@v_program_name		AS CREATED_BY
				  ,GETDATE()			AS CREATION_DATE 
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,GETDATE()			AS LAST_UPDATE_DATE 
			 FROM #SCP_MST_CAPA_LINE_ASSIGN WITH(NOLOCK)	--- 데이터 검증을 위해서 line assign은 N인것도 cutoff 데이터에 포함!! 
			WHERE 1=1

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' DELETE SCP_MST_CAPA_SPEED_PLAN_CUTF ' 
			------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_SPEED_PLAN_CUTF  
			WHERE 1=1
			  AND VER_ID		= @V_VER_ID
			  AND VER_SEQ		= @V_VER_SEQ
			  AND DIVISION_ID	= @V_DIVISION_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' INSERT INTO SCP_MST_CAPA_SPEED_PLAN_CUTF ' 
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_SPEED_PLAN_CUTF (
				   VER_ID
				  ,VER_SEQ
				  ,DIVISION_ID
				  ,COMPANY_ID
				  ,SITE_ID
				  ,PLANT_ID
				  ,FACTORY_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,ITEM_ID
				  ,NICK_NAME
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,BASE_QTY
				  ,QTY
				  ,UI_UPD_YN
				  ,REMARK
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE 
			)
			SELECT @V_VER_ID	AS	VER_ID
				  ,@V_VER_SEQ	AS	VER_SEQ
				  ,SP.DIVISION_ID
				  ,SP.COMPANY_ID
				  ,SP.SITE_ID
				  ,SP.PLANT_ID
				  ,SP.FACTORY_ID
				  ,SP.LINE_ID
				  ,SP.OPERATION_ID
				  ,SP.ELTR_LN_TP_CD
				  ,SP.ITEM_ID
				  ,SP.NICK_NAME
				  ,SP.MSR_TP_CD
				  ,SP.YYYYMM
				  ,SP.BASE_QTY
				  ,SP.QTY
				  ,SP.UI_UPD_YN
				  ,SP.REMARK
				  ,@v_program_name		AS CREATED_BY
				  ,GETDATE()			AS CREATION_DATE 
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,GETDATE()			AS LAST_UPDATE_DATE 
			 FROM #SCP_MST_CAPA_SPEED_PLAN_CUTF SP /* 2024.08.09 MMD기준 PPM재계산 반영로직 삭제 - UI 결과 그대로 반영 */
			WHERE 1=1

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  DELETE SCP_RPT_CAPA_LOB ' 
			-------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_RPT_CAPA_LOB   
			 WHERE 1=1
			   AND VER_ID		= @V_VER_ID
			   AND VER_SEQ		= @V_VER_SEQ
			   AND DIVISION_ID	= @V_DIVISION_ID

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 생성 -  INSERT SCP_RPT_CAPA_LOB ' 
			---------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_RPT_CAPA_LOB (
				 VER_ID
				,VER_SEQ
				,DIVISION_ID
				,YYYYMM
				,MDL_NM
				,COMPANY_ID
				,SITE_ID
				,PLANT_ID
				,FACTORY_ID
				,LINE_ID
				,OPERATION_ID
				,ELTR_LN_TP_CD
				,THRY_CAPA
				,PRDN_CAPA
				,PRDN_OPRT
				,LD_RT
				,ADJ_PRDN_CAPA
				,ADJ_PRDN_OPRT
				,ADJ_LD_RT
				,ADJ_ULD_RT
				,CREATED_BY
				,CREATION_DATE 
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1
				,ATTRIBUTE2
			)
			SELECT   @V_VER_ID
					,@V_VER_SEQ
					,AJ.DIVISION_ID
					,AJ.YYYYMM
					,AJ.MDL_NM
					,AJ.COMPANY_ID
					,AJ.SITE_ID
					,AJ.PLANT_ID
					,AJ.FACTORY_ID
					,AJ.LINE_ID
					,AJ.OPERATION_ID
					,AJ.ELTR_LN_TP_CD
					,AJ.THRY_CAPA
					,AJ.PRDN_CAPA
					,AJ.PRDN_OPRT
					,AJ.LD_RT
					,AJ.ADJ_PRDN_CAPA
					,AJ.ADJ_PRDN_OPRT
					,AJ.ADJ_LD_RT
					,AJ.ADJ_ULD_RT
				    ,@v_program_name		AS CREATED_BY
				    ,GETDATE()				AS CREATION_DATE 
				    ,@v_program_name		AS LAST_UPDATED_BY
				    ,GETDATE()				AS LAST_UPDATE_DATE 
					,CASE WHEN AJ.OPERATION_ID LIKE 'P%' -- 20240726 : 팩은 neck공정 여부 불필요 (라인별 공정 하나)
						  THEN NULL	
						  ELSE AJ.ATTRIBUTE1
					  END					AS ATTRIBUTE1 -- neck공정 여부 
					,ATTRIBUTE2
			 FROM #SCP_RPT_CAPA_LOB AJ WITH(NOLOCK)  -- sp_help SCP_RPT_CAPA_LOB
			WHERE 1=1

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Loss 모델별 Cutoff - DELETE SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF' 
			------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF  
			 WHERE 1=1
			   AND VER_ID		= @V_VER_ID
			   AND VER_SEQ		= @V_VER_SEQ
			   AND DIVISION_ID	= @V_DIVISION_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Loss 모델별 Cutoff - INSERT SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF' 
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF (
				 VER_ID
				,VER_SEQ
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
				,PFRSLT_NVL
				,BASE_NVL
				-- 2025.02.05 개선/목표일 관리 기능 삭제 ,IPRV_GOL_DIVS_CD
				-- 2025.02.05 개선/목표일 관리 기능 삭제 ,IPRV_GOL_RT
				,MSR_GR_CD
				,MSR_NVL	
				,MSR_DDN
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
			SELECT @V_VER_ID
				  ,@V_VER_SEQ  		  
				  ,MC.DIVISION_ID
				  ,MC.MDL_NM
				  ,MC.PLANT_ID
				  ,MC.LINE_ID
				  ,MC.OPERATION_ID
				  ,MC.ELTR_LN_TP_CD
				  ,MC.COMPANY_ID
				  ,MC.SITE_ID
				  ,MC.FACTORY_ID
				  ,MC.MSR_TP_CD
				  ,MC.YYYYMM
				  ,MC.PFRSLT_NVL
				  ,MC.BASE_NVL
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,MC.IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,MC.IPRV_GOL_RT
				  ,MC.MSR_GR_CD
				  ,MC.MSR_NVL	
				  ,MC.MSR_DDN	-- 일수
				  ,@v_program_name		AS CREATED_BY
				  ,GETDATE()			AS CREATION_DATE 
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,GETDATE()			AS LAST_UPDATE_DATE 
			 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF MC    

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - DELETE  SCP_MST_CAPA_LOSS_PLAN_LN ' 
			---------------------------------------
			-- DELETE SCP_MST_CAPA_LOSS_PLAN_LN
			-- 비조업 다시 등록 
			-----------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_LOSS_PLAN_LN 
			 WHERE 1=1
			   AND DIVISION_ID	= @V_DIVISION_ID

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN ' 
			-----------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN (
				   DIVISION_ID
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
				)
			SELECT AK.DIVISION_ID
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
				  ,GETDATE()			AS CREATION_DATE 
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,GETDATE()			AS LAST_UPDATE_DATE 
			 FROM #LOSS_PLAN_LN_TTZM LT
				  INNER JOIN #ALTER_KEY_INFO_FOR_LN AK
						  ON AK.LN_ALTER_KEY = LT.LN_ALTER_KEY
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

		  ---- End 조립/팩 
		  ---- End 조립/팩 

		  ---- Start 전극  
		  ---- Start 전극 

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' (전극 Line Assign Cutoff) DELETE SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF ' 
			------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF	--- 전극 Line Assign     
			WHERE 1=1
			  AND VER_ID		= @V_VER_ID
			  AND VER_SEQ		= @V_VER_SEQ
			  AND DIVISION_ID	= @V_DIVISION_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' (전극 Line Assign Cutoff) DELETE SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF ' 
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF ( --- 전극 Line Assign 
				 VER_ID
				,VER_SEQ
				,DIVISION_ID
				,COMPANY_ID
				,SITE_ID
				,PLANT_ID
				,FACTORY_ID
				,LINE_ID
				,OPERATION_ID
				,ELTR_LN_TP_CD
				,ITEM_ID
				,NICK_NAME
				,YYYYMM
				,ASSIGN_PRIORITY
				,DUMMY_YN
				,VALID_YN
				,LANE_QTY
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
			SELECT @V_VER_ID	AS VER_ID
				  ,@V_VER_SEQ
				  ,DIVISION_ID
				  ,COMPANY_ID
				  ,SITE_ID
				  ,PLANT_ID
				  ,FACTORY_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,ITEM_ID
				  ,NICK_NAME
				  ,YYYYMM
				  ,ASSIGN_PRIORITY
				  ,DUMMY_YN
				  ,VALID_YN
				  ,LANE_QTY
				  ,@v_program_name		AS CREATED_BY
				  ,GETDATE()			AS CREATION_DATE 
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,GETDATE()			AS LAST_UPDATE_DATE 
			 FROM #SCP_MST_CAPA_ELTR_LINE_ASSIGN WITH(NOLOCK)  --- 전극 Line Assign Current 
			WHERE 1=1
		  
			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 속도 계획 DELETE SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF ' 
			------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF	-- 전극 Speed plan Cutoff
			WHERE 1=1
			  AND VER_ID		= @V_VER_ID
			  AND VER_SEQ		= @V_VER_SEQ
			  AND DIVISION_ID	= @V_DIVISION_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 속도 계획 INSERT INTO SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF ' 
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF (	-- 전극 Speed plan Cutoff
				   VER_ID
				  ,VER_SEQ
				  ,DIVISION_ID
				  ,COMPANY_ID
				  ,SITE_ID
				  ,PLANT_ID
				  ,FACTORY_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,ELTR_LN_TP_CD
				  ,ITEM_ID
				  ,NICK_NAME
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,BASE_QTY
				  ,QTY
				  ,UI_UPD_YN
				  ,REMARK
				  ,CREATED_BY
				  ,CREATION_DATE
				  ,LAST_UPDATED_BY
				  ,LAST_UPDATE_DATE 
			)
			SELECT @V_VER_ID	AS	VER_ID
				  ,@V_VER_SEQ	AS	VER_SEQ
				  ,SP.DIVISION_ID
				  ,SP.COMPANY_ID
				  ,SP.SITE_ID
				  ,SP.PLANT_ID
				  ,SP.FACTORY_ID
				  ,SP.LINE_ID
				  ,SP.OPERATION_ID
				  ,SP.ELTR_LN_TP_CD
				  ,SP.ITEM_ID
				  ,SP.NICK_NAME
				  ,SP.MSR_TP_CD
				  ,SP.YYYYMM
				  ,SP.BASE_QTY
				  ,SP.QTY
				  ,SP.UI_UPD_YN 
				  ,NULL					AS REMARK
				  ,@v_program_name		AS CREATED_BY
				  ,GETDATE()			AS CREATION_DATE 
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,GETDATE()			AS LAST_UPDATE_DATE 
			 FROM #SCP_MST_CAPA_ELTR_SPEED_PLAN SP
			WHERE 1=1

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 Loss 모델별 Cutoff - DELETE SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF' 
			------------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF  
			 WHERE 1=1
			   AND VER_ID		= @V_VER_ID
			   AND VER_SEQ		= @V_VER_SEQ
			   AND DIVISION_ID	= @V_DIVISION_ID

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 Loss 모델별 Cutoff - INSERT SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF' 
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF (
				 VER_ID
				,VER_SEQ
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
				,PFRSLT_NVL
				,BASE_NVL
				-- 2025.02.05 개선/목표일 관리 기능 삭제 ,IPRV_GOL_DIVS_CD
				-- 2025.02.05 개선/목표일 관리 기능 삭제 ,IPRV_GOL_RT
				,MSR_GR_CD
				,MSR_NVL	
				,MSR_DDN
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
			SELECT @V_VER_ID
				  ,@V_VER_SEQ  		  
				  ,MC.DIVISION_ID
				  ,MC.MDL_NM
				  ,MC.PLANT_ID
				  ,MC.LINE_ID
				  ,MC.OPERATION_ID
				  ,MC.ELTR_LN_TP_CD
				  ,MC.COMPANY_ID
				  ,MC.SITE_ID
				  ,MC.FACTORY_ID
				  ,MC.MSR_TP_CD
				  ,MC.YYYYMM
				  ,MC.PFRSLT_NVL
				  ,MC.BASE_NVL
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,MC.IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제 ,MC.IPRV_GOL_RT
				  ,MC.MSR_GR_CD
				  ,MC.MSR_NVL	
				  ,NULL					AS MSR_DDN
				  ,@v_program_name		AS CREATED_BY
				  ,GETDATE()			AS CREATION_DATE 
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,GETDATE()			AS LAST_UPDATE_DATE 
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL MC    

		  ---- End 전극  
		  ---- End 전극  

		  ------------------- Start 버전 상태 처리  

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 라인별 합계 - INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN ' 
			-------------------------------------------------------------------------------------------------------------------

			UPDATE CV SET PROG_STAT			= '1'
	 					 ,LAST_UPDATED_BY	= @v_program_name
	 					 ,LAST_UPDATE_DATE	= GETDATE() 
						 ,ATTRIBUTE8		= '[PROG_STAT:''0'' to ''1'']'+CONVERT(NVARCHAR(100), GETDATE(), 25)
			 FROM SCP_MST_CAPA_VERSION CV WITH(NOLOCK) 
			WHERE 1=1
			  AND CV.VER_ID			= @V_VER_ID
			  AND CV.VER_SEQ		= @V_VER_SEQ
			  AND CV.DIVISION_ID	= @V_DIVISION_ID
			  AND CV.PROG_STAT		= '0'

		  ------------------- end 버전 상태 처리  


		  COMMIT TRAN ;  --- transaction 종료  
		------- End Tran : ==========================================================================================================
		------- End Tran : ==========================================================================================================

			SET @v_log_type = 'TXN';
			SET @v_log_message = 'END - '+@v_division_id;     
			SET @v_description = '['+ @v_division_id + '::' + @V_VER_ID + '::' + CONVERT(NVARCHAR(10), @V_VER_SEQ) +  ']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
			SET @v_log_message = NULL 


        FETCH NEXT FROM CAPA_VER_DATA INTO @V_DIVISION_ID
										  ,@V_VER_ID
										  ,@V_VER_SEQ

        END  ----- // WHILE @@FETCH_STATUS = 0
		
        CLOSE CAPA_VER_DATA ;
        DEALLOCATE CAPA_VER_DATA;   -- 메모리 해제 - 2025.03.17 위치 변경 

	  END ----- // IF @V_IS_MANUAL = 'Y' OR 1차 컷오프 수행일 


		-----------------------------------------
		------ 임시테이블 정리
		-------------------------------------------
		---- 조립/팩
		IF OBJECT_ID('TEMPDB..#Cutoff_Date_Info') IS NOT NULL DROP TABLE #Cutoff_Date_Info;
		if object_id('tempdb..#CPS_FORMATION_OPERATION') is not null drop table #CPS_FORMATION_OPERATION;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LINE_ASSIGN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LINE_ASSIGN;
		IF OBJECT_ID('TEMPDB..#SCP_RPT_CAPA_LOB') IS NOT NULL DROP TABLE #SCP_RPT_CAPA_LOB;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF;
		IF OBJECT_ID('TEMPDB..#LOSS_PLAN_LN_TTZM') IS NOT NULL DROP TABLE #LOSS_PLAN_LN_TTZM;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL
		IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO;
		IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_MDL') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_MDL
		IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_LN') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_LN
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_SPEED_PLAN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_SPEED_PLAN;
		IF OBJECT_ID('TEMPDB..#SPEED_PLAN_WITH_MASTER') IS NOT NULL DROP TABLE #SPEED_PLAN_WITH_MASTER;
		IF OBJECT_ID('TEMPDB..#SPEED_PLAN_PPM_CUTOFF') IS NOT NULL DROP TABLE #SPEED_PLAN_PPM_CUTOFF;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_SPEED_PLAN_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_SPEED_PLAN_CUTF;
		IF OBJECT_ID('TEMPDB..#ALTER_KEY_MAPPING_LOSS_DATA') IS NOT NULL DROP TABLE #ALTER_KEY_MAPPING_LOSS_DATA
		IF OBJECT_ID('TEMPDB..#ADJ_PRDN_CAPA') IS NOT NULL DROP TABLE #ADJ_PRDN_CAPA
		IF OBJECT_ID('TEMPDB..#BEFORE_PROD_LD_RT') IS NOT NULL DROP TABLE #BEFORE_PROD_LD_RT
		IF OBJECT_ID('TEMPDB..#ADJ_ULD_RT') IS NOT NULL DROP TABLE #ADJ_ULD_RT   
		IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		IF OBJECT_ID('TEMPDB..#LOSS_CODE_INFO') IS NOT NULL DROP TABLE #LOSS_CODE_INFO
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LINE_SOP') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LINE_SOP
		IF OBJECT_ID('TEMPDB..#SOP_INFO') IS NOT NULL DROP TABLE #SOP_INFO
		---- 전극
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_ASSIGN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_ASSIGN;
		IF OBJECT_ID('TEMPDB..#ELTR_ALTER_KEY_INFO_MDL') IS NOT NULL DROP TABLE #ELTR_ALTER_KEY_INFO_MDL
		IF OBJECT_ID('TEMPDB..#ELTR_ALTER_KEY_INFO_LN') IS NOT NULL DROP TABLE #ELTR_ALTER_KEY_INFO_LN
		IF OBJECT_ID('TEMPDB..#SCM_MMD_EQPT_PRDT_SPEED_SN') IS NOT NULL DROP TABLE #SCM_MMD_EQPT_PRDT_SPEED_SN;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_SPEED_PLAN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_SPEED_PLAN;
		IF OBJECT_ID('TEMPDB..#ELTR_LOSS_PLAN_LN') IS NOT NULL DROP TABLE #ELTR_LOSS_PLAN_LN


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
    SET @v_description = N'[division_id:'+ ISNULL(@V_DIVISION_ID, 'ALL') + ']'+ISNULL(@V_IS_MANUAL, 'Z') + '['  + @v_exec_time + ']';  ;            
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
