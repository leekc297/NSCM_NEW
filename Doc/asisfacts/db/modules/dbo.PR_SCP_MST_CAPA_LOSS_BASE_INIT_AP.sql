





/* 
 *
 * Program ID   : PR_SCP_MST_CAPA_LOSS_BASE_INIT_AP
 * Description  : 매월 10일 실적 마감후 Loss Plan Current Data 실적/Base 데이터 초기화
 *				 - 대상 measure : 비부하/비가동/성능가동률/양품가동률
 *				 - 1. 최근 3개월 LOSS Plan 실적이 존재하는 Current 데이터에 대해서 실적/Base 값을 초기화 한다. (3개월 평균) 
 *				 - 2. 실적/Base값이 초기화된 건에 대해서 개선/목표율 입력구간(Y0 ~ Y1)에 대해서 운영계획을 재계산 적용한다.
 *					 (Line Assign Valid 이고 Priority 설정된 기간의 운영계획만 재계산 적용 )
 *				 - 3. 기준년월에 해당하는 버전 진행상태 정보를 Update한다. ('-':Init -> '0':Current(Speed/Loss계획 개시)) 
 *				 
 *			### Source Table 
 * 					SCM_DNM_LOSS_LN_MMLY
 *					SCM_DNM_LOSS_MDL_MMLY
 *					SCP_MST_CAPA_LINE_ASSIGN   
 *					SCP_MST_CAPA_LOSS_PLAN_MDL
 *					SCP_MST_CAPA_LINE_SOP
 * 				    SCM_ADM_LOOKUP_MASTER_DETAIL : CPS_FORMATION_OPERATION	
 *					scp_mst_mdl_eltr_qty			-- 2024.10.07 전극수량/Pitch참조
 *					SCP_MST_MDL_EQP_SPED			-- 2024.10.07 MMD속도 참조
 *
 *			### Target Table 
 * 					SCP_MST_CAPA_LOSS_PLAN_MDL
 *					SCP_MST_CAPA_LINE_SOP_B
 *					SCP_MST_CAPA_SPEED_PLAN			-- 2024.10.07 MMD기준 speed base 초기화 
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.04.26	hrkim		Initial Release PJ2024-50026 / LGES2024-002455   Capa. 관리 시스템 구축  
 * 2024.05.02	hrkim		Line Assign Valid_yn = 'Y'이고 Assign_Priority 설정된 데이터만 운영계획 재계산 Update함. (이성찬 부장님) 
 * 2024.05.03	hrkim		Line Assign에서 대상이 아닌 건들은 Speed/Loss Current 목록이 생성되지 않음
 *							- 운영계획 Update 대상 필터링시 Line Assign의 Valid_yn 및 assign priority 정보 확인 불필요 ! (5/3 이성찬 부장님) 
 * 2024.05.08	hrkim		Line Assign Valid_yn = Y가 아니거나 Assign priority 값이 없는 경우 0이거나 Null 운영계획구간 null처리 ??? 
 * 2024.05.09	hrkim		생산 Capa(월) -> Total Capa로 변경 (해당월의 총 Capa 또는 해당년도의 총 Capa) 
 * 2024.05.10	hrkim		라인 assign 대상이 아니경우 current 운영계획 null 처리.... ? 
 * 2024.05.14	hrkim		실적테이블 기간구분 컬럼 추가에 따른 참조 조건 변경 
 *							속도단위별 PPM계산 로직 적용
 * 2024.05.27	hrkim		소수 자릿수 처리 로직 보완
 * 2024.05.29	hrkim		Speed Plan (MMD)기준 이론 Capa 초기화 로직 추가  
 * 2024.06.05	hrkim		조립 Speed 실적 Line별 참조
 * 2024.06.07	hrkim		조립/팩과 전극 프로시저 분리
 * 2024.06.10	hrkim		속도실적 반영 변경 --> PPM은 실적 반영하지 않음 !!  
 * 2024.07.08	hrkim		Pack 및 더미의 이론Capa base 값 speed plan base 기준 변경 로직 추가  
 * 2024.07.09	hrkim		Pack 및 더미외 전체 base 이론 Capa base값 speed plan 및 MMD 기준 초기화 로직 추가 (변수 및 불필요 주석 정리) 
 * 2024.08.09	hrkim		이론Capa MMD기준 초기화 로직 삭제  
 * 2024.08.13	hrkim		실적유무와 상관 없이 성능가동률 default 100%으로 반영
 * 2024.08.29	hrkim		SOP(Start Of Production) 적용
 * 2024.09.11	hrkim		CPS Formation 공정 처리 로직 추가 - lookupType : CPS_FORMATION_OPERATION
 * 2024.09.12	hrkim		SOP 적용 최대조업일수 임시테이블 데이터 타입 수정 (FLOAT) 
 * 2024.09.25	hrkim		SOP 정보 백업 
 * 2024.10.07	hrkim		MMD기준 Speed Plan Base / Loss Plan Base 이론Capa 초기화 로직 추가  
 * 2024.10.16	hrkim		Base SOP 적용 안함    
 * 2024.10.30	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : line assign 안된 구간 데이터도 존재하면 초기화.  (line assign이 안된 구간이 loss데이터는 없어야함) 
 * 2024.11.05	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : loss capa measure만 CPS Formation 공정 초기화 대상에서 제외 처리 
 * 2025.02.06	hrkim		개선/목표율 관리 기능 삭제 - 해당 컬럼 참조 소스 삭제 (IPRV_GOL_DIVS_CD/IPRV_GOL_RT)
 * 2025.03.18	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_MST_CAPA_LOSS_BASE_INIT_AP]  --- 조립/팩
	 @P_BASE_YYYYMM	NVARCHAR(6)		= NULL
	,@P_DIVISION_ID	NVARCHAR(50)	= NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE	@V_BASE_YYYYMM		NVARCHAR(6)		= @P_BASE_YYYYMM;
	DECLARE	@V_BASE_YYYYMM_DDN	FLOAT			= NULL;
	DECLARE	@V_DIVISION_ID		NVARCHAR(50)	= @P_DIVISION_ID;

	DECLARE	@V_RSLT_YYYYMM		NVARCHAR(6)		= NULL;				-- 실적 참조 기준 년월 

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_CAPA_LOSS_BASE_INIT_AP'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	BEGIN TRY
	 BEGIN

		-- 파라미터로 받은 기준년월(Capa버전ID)이 값이 없는 경우 당월로 Setup
		IF ISNULL(@V_BASE_YYYYMM	,'') = '' 
		BEGIN
			SET @V_BASE_YYYYMM = CONVERT(NVARCHAR(6), GETDATE(), 112);
		 END

		 -- 기준년월(버전) 일수 
		 SET @V_BASE_YYYYMM_DDN = CONVERT(NUMERIC(20,10), DATEDIFF(DD, CONVERT(DATE, @V_BASE_YYYYMM+'01', 112)
																	 , DATEADD(MM, 1, CONVERT(DATE, @V_BASE_YYYYMM+'01', 112))))

		-- 실적 참조 기간 (기준년월 기준 (M-3)~(M-1)월 : 최근 3개월) 
		SET @V_RSLT_YYYYMM	= CONVERT(NVARCHAR(6), DATEADD(MM, -1, CONVERT(DATE, @V_BASE_YYYYMM+'01', 112)), 112) 

		PRINT '------------------------------------------------------------------';
		PRINT '@P_BASE_YYYYMM			= ' + ISNULL(@P_BASE_YYYYMM		,'');
		PRINT '@V_BASE_YYYYMM			= ' + ISNULL(@V_BASE_YYYYMM		,'');
		PRINT '@P_DIVISION_ID			= ' + ISNULL(@P_DIVISION_ID	 ,'ALL');
		PRINT '@V_DIVISION_ID			= ' + ISNULL(@V_DIVISION_ID	 ,'ALL');
		PRINT '@V_BASE_YYYYMM_DDN		= ' + CONVERT(NVARCHAR(50), @V_BASE_YYYYMM_DDN);
		PRINT '@V_RSLT_YYYYMM			= ' + ISNULL(@V_RSLT_YYYYMM		,'');
		PRINT '------------------------------------------------------------------';

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '[@V_BASE_YYYYMM='+ ISNULL(@V_BASE_YYYYMM,'') + '::@V_DIVISION_ID=' + ISNULL(@V_DIVISION_ID,'ALL') + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 


		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### CPS Formation 공정' -- /2024/9/11 추가  
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
		print  convert(varchar(30), getdate(), 121) + N' 라인별 Loss 실적 - 최근 3개월 실적' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCM_DNM_LOSS_LN_MMLY') IS NOT NULL DROP TABLE #SCM_DNM_LOSS_LN_MMLY

		SELECT LR.DIVISION_ID
			  ,LR.COMPANY_ID
			  ,LR.SITE_ID
			  ,LR.PLANT_ID
			  ,LR.FACTORY_ID
			  ,LR.LINE_ID
			  ,LR.OPERATION_ID
			  ,LR.ELTR_LN_TP_CD
			  ,LR.LOSS_CD
			  ,CONVERT(FLOAT, LR.LOSS_RT) AS LOSS_RT
		 INTO #SCM_DNM_LOSS_LN_MMLY  
		 FROM SCM_DNM_LOSS_LN_MMLY  LR with(nolock)
		WHERE 1=1
		  AND LR.LOSS_YM		= @V_RSLT_YYYYMM
		  AND LR.PERD_DIVS_CD	= '3'	-- 최근 3개월 실적
		  AND LR.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE LR.DIVISION_ID
								   END 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss 실적 - 최근 3개월 실적' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCM_DNM_LOSS_MDL_MMLY') IS NOT NULL DROP TABLE #SCM_DNM_LOSS_MDL_MMLY

		SELECT LR.DIVISION_ID
			  ,LR.COMPANY_ID
			  ,LR.SITE_ID
			  ,LR.PLANT_ID
			  ,LR.FACTORY_ID
			  ,LR.LINE_ID
			  ,LR.OPERATION_ID
			  ,LR.ELTR_LN_TP_CD
			  ,LR.LOSS_CD
			  ,LR.MDL_NM
			  ,CONVERT(FLOAT, LR.LOSS_RT) AS LOSS_RT
		 INTO #SCM_DNM_LOSS_MDL_MMLY 
		 FROM SCM_DNM_LOSS_MDL_MMLY  LR with(nolock)
		WHERE 1=1
		  AND LR.LOSS_YM		= @V_RSLT_YYYYMM
		  AND LR.PERD_DIVS_CD	= '3'	-- 최근 3개월 
		  AND LR.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE LR.DIVISION_ID
								   END 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 대상 -  Line Assign Priority  ' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LINE_ASSIGN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LINE_ASSIGN

		SELECT LA.NICK_NAME
			  ,LA.DIVISION_ID
			  ,LA.COMPANY_ID
			  ,LA.SITE_ID
			  ,LA.PLANT_ID
			  ,LA.FACTORY_ID
			  ,LA.LINE_ID
			  ,LA.OPERATION_ID
			  ,LA.ELTR_LN_TP_CD
			  ,LA.YYYYMM
			  ,LA.DUMMY_YN
		 INTO #SCP_MST_CAPA_LINE_ASSIGN 
		 FROM SCP_MST_CAPA_LINE_ASSIGN LA WITH(NOLOCK)
		WHERE 1=1
		  AND LA.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE LA.DIVISION_ID
								   END 
		  AND LA.VALID_YN	 = 'Y'  
		  AND ISNULL(LA.ASSIGN_PRIORITY, 0) != 0
		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 대상 -  #SCP_MST_CAPA_LOSS_PLAN_MDL_RAW' -- 2024.09.11 추가 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL_RAW') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL_RAW

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
				,CONVERT(FLOAT, LS.PFRSLT_NVL)		AS PFRSLT_NVL
				,CONVERT(FLOAT, LS.BASE_NVL)		AS BASE_NVL
				,LS.MSR_GR_CD
				,CONVERT(FLOAT, LS.MSR_NVL)			AS MSR_NVL
		 INTO #SCP_MST_CAPA_LOSS_PLAN_MDL_RAW 
		 FROM SCP_MST_CAPA_LOSS_PLAN_MDL LS WITH(NOLOCK)
		WHERE 1=1
		  AND LS.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE LS.DIVISION_ID
								   END 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 대상 -  #SCP_MST_CAPA_LOSS_PLAN_MDL' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL

		SELECT   LS.*
				,CASE WHEN LA.YYYYMM IS NULL THEN 'N' ELSE 'Y' END 	AS TARGET_YN -- Line Assign priority 값이 존재하면 Target 
		 INTO #SCP_MST_CAPA_LOSS_PLAN_MDL 
		 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_RAW LS WITH(NOLOCK) -- 2024.09.11 변경 
			  LEFT JOIN #SCP_MST_CAPA_LINE_ASSIGN LA WITH(NOLOCK)
					 ON 1=1 
					AND LA.DIVISION_ID		= LS.DIVISION_ID
					AND LA.COMPANY_ID		= LS.COMPANY_ID
					AND LA.SITE_ID			= LS.SITE_ID
					AND LA.PLANT_ID			= LS.PLANT_ID
					AND LA.FACTORY_ID		= LS.FACTORY_ID
					AND LA.LINE_ID			= LS.LINE_ID
					AND LA.OPERATION_ID		= LS.OPERATION_ID
					AND LA.ELTR_LN_TP_CD	= LS.ELTR_LN_TP_CD
					AND LA.NICK_NAME		= LS.MDL_NM
					AND LA.YYYYMM			= LS.YYYYMM
		WHERE 1=1
		  AND LS.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE LS.DIVISION_ID
								   END 


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Loss Plan Current - 실적 NUL 처리' 
		-- 2025.03.26 실적 Null 처리 
		-------------------------------------------------------------------------------------------------------------------
		UPDATE LP 
		 SET   LP.PFRSLT_NVL			= NULL
		FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
		WHERE 1=1

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan Current - 실적/Base 초기화' 
		-- 실적 값으로 Base가 초기화 
		-------------------------------------------------------------------------------------------------------------------
		 UPDATE LP SET   LP.PFRSLT_NVL			= CASE	WHEN LP.MSR_TP_CD = 'QL_RT'		THEN RM.LOSS_RT						-- 모델별 양품가동률
														WHEN LP.MSR_TP_CD = 'AV_RT'		THEN RL.LOSS_RT						-- 실적 조업률
														ELSE RL.LOSS_RT 
												   END	-- 실적 
						,LP.BASE_NVL			= CASE	WHEN LP.MSR_TP_CD = 'QL_RT'		THEN RM.LOSS_RT						-- 모델별 양품가동률
														WHEN LP.MSR_TP_CD = 'AV_RT'		THEN CONVERT(NUMERIC(20,10), 1)		-- 조업률은 defualt 100%
														WHEN LP.MSR_TP_CD = 'PF_RT'		THEN CONVERT(NUMERIC(20,10), 1)		-- 성능가동률 defualt 100% 2024.08.13 수정
														ELSE RL.LOSS_RT 
												  END	-- Base
		FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
			 LEFT JOIN #SCM_DNM_LOSS_MDL_MMLY  RM	-- 양품가동률 실적 (QL_RT) 
					ON RM.MDL_NM		= LP.MDL_NM
				   AND RM.PLANT_ID		= LP.PLANT_ID
				   AND RM.LINE_ID		= LP.LINE_ID
				   AND RM.OPERATION_ID	= LP.OPERATION_ID
				   AND RM.ELTR_LN_TP_CD = LP.ELTR_LN_TP_CD
				   AND RM.DIVISION_ID	= LP.DIVISION_ID
				   AND RM.COMPANY_ID	= LP.COMPANY_ID
				   AND RM.SITE_ID		= LP.SITE_ID
				   AND RM.FACTORY_ID	= LP.FACTORY_ID
				   AND RM.LOSS_CD		= LP.MSR_TP_CD
				   AND LP.MSR_TP_CD		= 'QL_RT'
			 LEFT JOIN #SCM_DNM_LOSS_LN_MMLY  RL	-- 비부하/비가동/성능가동률
					ON RL.PLANT_ID		= LP.PLANT_ID
				   AND RL.LINE_ID		= LP.LINE_ID
				   AND RL.OPERATION_ID	= LP.OPERATION_ID
				   AND RL.ELTR_LN_TP_CD = LP.ELTR_LN_TP_CD
				   AND RL.DIVISION_ID	= LP.DIVISION_ID
				   AND RL.COMPANY_ID	= LP.COMPANY_ID
				   AND RL.SITE_ID		= LP.SITE_ID
				   AND RL.FACTORY_ID	= LP.FACTORY_ID
				   AND RL.LOSS_CD		= LP.MSR_TP_CD
		WHERE 1=1
		  AND LP.OPERATION_ID LIKE 'A%'		-- Cell만 대상으로 함 (팩은 실적이 없음!) 
		  AND (   RM.LOSS_CD IS NOT NULL 
			   OR RL.LOSS_CD IS NOT NULL 
			   )							-- 실적이 존재하는 데이터만 초기화 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan Current - 성능가동률 default 100%으로 초기화' 
		-- 2024.08.13 실적값과 상관 없이 성능가동률(PF_RT) default 100% 반영 
		-------------------------------------------------------------------------------------------------------------------
		UPDATE LP 
		SET   LP.BASE_NVL =  CONVERT(NUMERIC(20,10), 1)
			 ,LP.MSR_NVL  =  CONVERT(NUMERIC(20,10), 1)	 -- 2024.11.05 개선/목표율 입력구간이 아닌 경우도 성능가동률 무조건 100%로 Update  추가
		FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
		WHERE 1=1 
		  AND LP.MSR_TP_CD = 'PF_RT'

		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 월별 일수 정보 -  #YYYYMM_DAYS_INFO' 
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
	
		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 모델별 ALTER KEY 정보 - #ALTER_KEY_INFO_FOR_MDL' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_MDL') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_MDL

		SELECT DISTINCT
			   LS.MDL_ALTER_KEY
			  ,LS.MDL_NM
			  ,LS.PLANT_ID
			  ,LS.LINE_ID
			  ,LS.OPERATION_ID
			  ,LS.ELTR_LN_TP_CD
			  ,LS.DIVISION_ID
			  ,LS.COMPANY_ID
			  ,LS.SITE_ID
			  ,LS.FACTORY_ID
		INTO #ALTER_KEY_INFO_FOR_MDL
		FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LS  WITH(NOLOCK)
	   WHERE 1=1

		-----------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'전극 수량/pitch  ' 
		-- 2024.10.07 추가 for MMD기준 speed plan base 초기화 
		-----------------------------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#mdl_eltr_qty') is not null drop table #mdl_eltr_qty;
		select eq.nick_nm
			  ,eq.eltr_ln_tp_cd
			  ,convert(float, eq.eltr_qty	   ) as eltr_qty	  
			  ,convert(float, eq.eltr_pch_len  ) as eltr_pch_len 
		 into #mdl_eltr_qty
		 from scp_mst_mdl_eltr_qty eq with(nolock)
		where 1=1

		-----------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'조립 MMD기준 속도 정보 ' 
		-- 2024.10.07 추가 for MMD기준 speed plan base 초기화 
		-----------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#MMD_EQP_SPED') IS NOT NULL DROP TABLE #MMD_EQP_SPED;
		SELECT ES.MDL_NM
			 , ES.DIVISION_ID
			 , ES.COMPANY_ID
			 , ES.SITE_ID
			 , ES.PLANT_ID
			 , ES.FACTORY_ID
			 , ES.LINE_ID
			 , ES.OPERATION_ID
			 , ES.ELTR_LN_TP_CD
			 , ES.EQP_SPED_UNIT_CD
			 , CONVERT(FLOAT, ES.EQP_NBU	 )	AS 	EQP_NBU	 
			 , CONVERT(FLOAT, ES.EQP_SPED	 )	AS 	EQP_SPED	 
			 , CONVERT(FLOAT, EQ.ELTR_QTY	 )	AS 	ELTR_QTY	 
			 , CONVERT(FLOAT, EQ.ELTR_PCH_LEN)	AS  ELTR_PCH_LEN
		 INTO #MMD_EQP_SPED
		 FROM SCP_MST_MDL_EQP_SPED ES WITH(NOLOCK) 
			  LEFT JOIN #mdl_eltr_qty EQ WITH(NOLOCK)
					 ON EQ.NICK_NM			= ES.MDL_NM
					AND EQ.ELTR_LN_TP_CD	= ES.ELTR_LN_TP_CD
		WHERE 1=1
		  AND ES.USE_YN		= 'Y' -- 2025/3/20 
		  AND ES.UI_UPD_YN	= 'N'

		-----------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'조립 MMD기준 PPM 계산 ' 
		-- 2024.10.07 추가 for MMD기준 speed plan base 초기화 
		-----------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#MMD_PPM') IS NOT NULL DROP TABLE #MMD_PPM;

		--- 조립 MMD기준 base qty 추가  
		SELECT ES.MDL_NM
			 , ES.DIVISION_ID
			 , ES.COMPANY_ID
			 , ES.SITE_ID
			 , ES.PLANT_ID
			 , ES.FACTORY_ID
			 , ES.LINE_ID
			 , ES.OPERATION_ID
			 , ES.ELTR_LN_TP_CD
			 , ES.EQP_SPED_UNIT_CD
			 , ES.EQP_NBU
			 , ES.EQP_SPED
			 , ES.ELTR_QTY
			 , ES.ELTR_PCH_LEN 
			 , CONVERT(NUMERIC(20,10),
			   CASE WHEN ES.EQP_SPED_UNIT_CD = 'MMS' AND (ES.ELTR_QTY=0 OR ES.ELTR_PCH_LEN=0)	THEN 0																-- (mm/s * 60.) / (전극수량 * 전극 Pitch) * 설비대수
					WHEN ES.EQP_SPED_UNIT_CD = 'MMS'											THEN CONVERT(FLOAT,(ES.EQP_SPED * 60.) 
																									/ CONVERT(FLOAT,  ES.ELTR_QTY * ES.ELTR_PCH_LEN)) * ES.EQP_NBU	-- (mm/s * 60.) / (전극수량 * 전극 Pitch) * 설비대수
					WHEN ES.EQP_SPED_UNIT_CD = 'CPM' AND ES.ELTR_QTY = 0						THEN 0																-- cpm / 전극수량 * 설비대수
					WHEN ES.EQP_SPED_UNIT_CD = 'CPM'											THEN CONVERT(FLOAT, ES.EQP_SPED / ES.ELTR_QTY) * ES.EQP_NBU			-- cpm / 전극수량 * 설비대수
					WHEN ES.EQP_SPED_UNIT_CD = 'PPM_AVG'										THEN ES.EQP_SPED * ES.EQP_NBU										-- ppm(평균) * 설비대수
					WHEN ES.EQP_SPED = 0														THEN 0																-- 60. / TactTime * 설비대수 
					ELSE																		CONVERT(FLOAT, (60. / ES.EQP_SPED)) * ES.EQP_NBU					-- 60. / TactTime * 설비대수 
				END)																			AS PPM	-- PPM 
		 INTO #MMD_PPM
		 FROM #MMD_EQP_SPED ES WITH(NOLOCK) 
		WHERE 1=1

		-----------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'MMD기준 spped plan base 정보 measure별' 
		-- 2024.10.07 추가 for MMD기준 speed plan base 초기화 
		-----------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#MMD_SPEED_PLAN_BASE') IS NOT NULL DROP TABLE #MMD_SPEED_PLAN_BASE;

		;WITH SPEED_MEASURE AS (
			SELECT 'EQP_NBU'	AS MSR_TP_CD -- 설비대수
			UNION ALL
			SELECT 'EQP_SPED'	AS MSR_TP_CD -- 설비속도
			UNION ALL
			SELECT 'PPM'		AS MSR_TP_CD -- PPM
		)
		SELECT MP.DIVISION_ID
			 , MP.COMPANY_ID
			 , MP.SITE_ID
			 , MP.PLANT_ID
			 , MP.FACTORY_ID
			 , MP.LINE_ID
			 , MP.OPERATION_ID
			 , MP.ELTR_LN_TP_CD
			 , MP.MDL_NM					AS NICK_NAME
			 , CASE WHEN SM.MSR_TP_CD NOT IN ('EQP_NBU', 'PPM')
					THEN MP.EQP_SPED_UNIT_CD
					ELSE SM.MSR_TP_CD 
			   END							AS MSR_TP_CD 
			 , CONVERT(NUMERIC(20,10), 
					CASE WHEN SM.MSR_TP_CD = 'EQP_NBU'  THEN MP.EQP_NBU		--  (base)설비대수
						 WHEN SM.MSR_TP_CD = 'PPM'		THEN MP.PPM			--  (base)PPM
						 ELSE MP.EQP_SPED									--  (base)속도
					 END)					AS BASE_QTY 
			  , CONVERT(NUMERIC(20,10), CONVERT(FLOAT, MP.PPM) * CONVERT(FLOAT, 1440))	AS THRY_CAPA_D -- (base)이론Capa
		 INTO #MMD_SPEED_PLAN_BASE
		 FROM #MMD_PPM MP WITH(NOLOCK) 
			  INNER JOIN SPEED_MEASURE SM WITH(NOLOCK)
					  ON 1=1
		WHERE 1=1

		-----------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'MMD기준 Loss Plan Base 이론 Capa 초기화' 
		-- 2024.10.07 추가 for MMD기준 speed plan base 초기화 -> Loss Plan Base 이론 Capa 초기화
		-----------------------------------------------------------------------------------------------------------------------------------------------------
		UPDATE LP 
		   SET LP.BASE_NVL = SP.THRY_CAPA_D
		FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
			 INNER JOIN #MMD_SPEED_PLAN_BASE  SP	--  base 이론 capa 
				 	 ON SP.DIVISION_ID		= LP.DIVISION_ID
				    AND SP.COMPANY_ID		= LP.COMPANY_ID
				    AND SP.SITE_ID			= LP.SITE_ID
				    AND SP.PLANT_ID			= LP.PLANT_ID
				    AND SP.FACTORY_ID		= LP.FACTORY_ID
				    AND SP.LINE_ID			= LP.LINE_ID
				    AND SP.OPERATION_ID		= LP.OPERATION_ID
				    AND SP.ELTR_LN_TP_CD	= LP.ELTR_LN_TP_CD
				    AND SP.NICK_NAME		= LP.MDL_NM
				    AND SP.MSR_TP_CD		= 'PPM'
		WHERE 1=1
		  AND LP.MSR_TP_CD	= 'THRY_CAPA_D'

		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Speed plan 운영계획 PPM 재계산 - MMS/CPM Speed plan' 
		-- 2025.02.06 speed plan 운영계획구간 PPM 재계산 반영 (속도단위 : MMS, CPM)
		------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_SPEED_PLAN_MMS_CPM') IS NOT NULL DROP TABLE #SCP_MST_CAPA_SPEED_PLAN_MMS_CPM;
		SELECT 
			SP.DIVISION_ID
		   ,SP.COMPANY_ID
		   ,SP.SITE_ID
		   ,SP.PLANT_ID
		   ,SP.FACTORY_ID
		   ,SP.LINE_ID
		   ,SP.OPERATION_ID
		   ,SP.ELTR_LN_TP_CD
		   ,SP.NICK_NAME
		   ,SP.YYYYMM
		   ,CONVERT(FLOAT,MAX(CASE WHEN SP.MSR_TP_CD = 'EQP_NBU'				THEN SP.QTY			ELSE NULL END)) AS EQP_NBU
		   ,CONVERT(FLOAT,MAX(CASE WHEN SP.MSR_TP_CD NOT IN ('EQP_NBU','PPM') 	THEN SP.QTY			ELSE NULL END)) AS SPEED
		   ,CONVERT(FLOAT,MAX(CASE WHEN SP.MSR_TP_CD = 'PPM'					THEN SP.QTY			ELSE NULL END)) AS PPM
 		   ,MAX(CASE WHEN SP.MSR_TP_CD NOT IN ('EQP_NBU','PPM') 				THEN SP.MSR_TP_CD	ELSE NULL END)	AS SPEED_UNIT
		INTO #SCP_MST_CAPA_SPEED_PLAN_MMS_CPM
		FROM SCP_MST_CAPA_SPEED_PLAN SP
		WHERE 1=1
		  AND SP.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE SP.DIVISION_ID
								   END 
		  AND SP.OPERATION_ID NOT IN (SELECT OPERATION_ID FROM #CPS_FORMATION_OPERATION) -- CPS Formation공정 제외 
		GROUP BY SP.DIVISION_ID
			   ,SP.COMPANY_ID
			   ,SP.SITE_ID
			   ,SP.PLANT_ID
			   ,SP.FACTORY_ID
			   ,SP.LINE_ID
			   ,SP.OPERATION_ID
			   ,SP.ELTR_LN_TP_CD
			   ,SP.NICK_NAME
			   ,SP.YYYYMM
		HAVING MAX(CASE WHEN SP.MSR_TP_CD NOT IN ('EQP_NBU','PPM')	THEN SP.MSR_TP_CD	ELSE NULL END) IN ('MMS', 'CPM') -- 속도 단위가 MMS/CPM인 경우만 

		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Speed plan 운영계획 PPM 재계산 - MMS/CPM Speed plan PPM 계산' 
		-- 2025.02.06 speed plan 운영계획구간 PPM 재계산 반영 (속도단위 : MMS, CPM)
		------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SPEED_PLAN_MMS_CPM_PPM') IS NOT NULL DROP TABLE #SPEED_PLAN_MMS_CPM_PPM;
		SELECT SP.*
			  ,EQ.ELTR_QTY
			  ,EQ.ELTR_PCH_LEN
			  ,CONVERT(NUMERIC(20,10)
			    , CASE 
					WHEN SP.SPEED_UNIT = 'MMS' AND (EQ.ELTR_QTY=0 OR EQ.ELTR_PCH_LEN=0)	THEN CONVERT(FLOAT, 0)	
					WHEN SP.SPEED_UNIT = 'MMS' 											THEN CONVERT(FLOAT, (SP.SPEED * CONVERT(FLOAT, 60)) / CONVERT(FLOAT, (EQ.ELTR_QTY  * EQ.ELTR_PCH_LEN))) * SP.EQP_NBU 
					WHEN SP.SPEED_UNIT = 'CPM' AND EQ.ELTR_QTY = 0						THEN CONVERT(FLOAT, 0)		
					WHEN SP.SPEED_UNIT = 'CPM'											THEN CONVERT(FLOAT,  SP.SPEED / EQ.ELTR_QTY) * SP.EQP_NBU 
				END) as PPM_calc
		 INTO #SPEED_PLAN_MMS_CPM_PPM
		 FROM #SCP_MST_CAPA_SPEED_PLAN_MMS_CPM SP
			   INNER JOIN #mdl_eltr_qty EQ
					   ON EQ.NICK_NM		= SP.NICK_NAME
					  AND EQ.ELTR_LN_TP_CD	= SP.ELTR_LN_TP_CD
		WHERE 1=1

		-----------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Speed plan 운영계획 PPM 재계산 - 운영계획 구간 Loss 이론 capa 재계산 반영' 
		-- 2025.02.06 speed plan 운영계획구간 PPM 재계산 반영 (속도단위 : MMS, CPM)
		-----------------------------------------------------------------------------------------------------------------------------------------------------
		UPDATE LP 
		   SET LP.MSR_NVL = CONVERT(FLOAT, OP.PPM_calc) * CONVERT(FLOAT, 1440) -- PPM * 1440 
		FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
			 INNER JOIN #SPEED_PLAN_MMS_CPM_PPM  OP	--  운영계획 PPM 
				 	 ON OP.DIVISION_ID		= LP.DIVISION_ID
				    AND OP.COMPANY_ID		= LP.COMPANY_ID
				    AND OP.SITE_ID			= LP.SITE_ID
				    AND OP.PLANT_ID			= LP.PLANT_ID
				    AND OP.FACTORY_ID		= LP.FACTORY_ID
				    AND OP.LINE_ID			= LP.LINE_ID
				    AND OP.OPERATION_ID		= LP.OPERATION_ID
				    AND OP.ELTR_LN_TP_CD	= LP.ELTR_LN_TP_CD
				    AND OP.NICK_NAME		= LP.MDL_NM
					AND OP.YYYYMM			= LP.YYYYMM
		WHERE 1=1
		  AND LP.MSR_TP_CD	= 'THRY_CAPA_D'

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
		   AND SP.DIVISION_ID	=  CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE SP.DIVISION_ID
								   END 
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

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 대상 Current Data with Alter Key ' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY

		SELECT MDL_ALTER_KEY
			  ,MSR_GR_CD
			  ,MSR_TP_CD
			  ,YYYYMM
			  ,CONVERT(NUMERIC(20,10), PFRSLT_NVL)	AS PFRSLT_NVL
			  ,CONVERT(NUMERIC(20,10), BASE_NVL)	AS BASE_NVL
			  ,CONVERT(NUMERIC(20,10), MSR_NVL)		AS MSR_NVL
			  ,TARGET_YN
		 INTO #LOSS_MDL_CUTOFF_WITH_ALTER_KEY 
		 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
		WHERE 1=1 
		  AND (MSR_GR_CD IN ('NLD','NOP') 
			   OR 
			   MSR_TP_CD IN ('PF_RT', 'QL_RT', 'THRY_CAPA_D', 'AV_RT')) 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - 비부하/비가동 비율 TOTAL 추가 ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY 
		SELECT LS.MDL_ALTER_KEY
			  ,'-'					AS MSR_GR_CD
			  ,LS.MSR_GR_CD			AS MSR_TP_CD
			  ,LS.YYYYMM
			  ,SUM(CONVERT(FLOAT, LS.PFRSLT_NVL))	AS PFRSLT_NVL
			  ,SUM(CONVERT(FLOAT, LS.BASE_NVL  ))	AS BASE_NVL
			  ,SUM(CONVERT(FLOAT, LS.MSR_NVL   ))	AS MSR_NVL
			  ,LS.TARGET_YN
		 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY LS WITH(NOLOCK)
		WHERE 1=1
		  AND MSR_GR_CD IN ('NLD', 'NOP') 
		GROUP BY LS.MDL_ALTER_KEY
				,LS.MSR_GR_CD
				,LS.YYYYMM
				,LS.TARGET_YN

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - 부하/가동 비율 TOTAL 추가 (LD_RT/OP_RT)' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		SELECT MDL_ALTER_KEY
			  ,'-'  AS MSR_GR_CD
			  ,CASE WHEN MSR_TP_CD = 'NLD' THEN 'LD_RT'
					WHEN MSR_TP_CD = 'NOP' THEN 'OP_RT'
					ELSE '-'
			   END  AS MSR_TP_CD
			  ,YYYYMM
			  ,CONVERT(FLOAT ,1) - CONVERT(FLOAT, ISNULL(PFRSLT_NVL, 0)) 	  AS PFRSLT_NVL
			  ,CONVERT(FLOAT ,1) - CONVERT(FLOAT, ISNULL(BASE_NVL,   0)) 	  AS BASE_NVL
			  ,CONVERT(FLOAT ,1) - CONVERT(FLOAT, ISNULL(MSR_NVL,    0)) 	  AS MSR_NVL
			  ,LS.TARGET_YN
		 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY LS WITH(NOLOCK)
		WHERE 1=1
		  AND MSR_TP_CD IN ('NLD', 'NOP') 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - 생산가동률' 
		-------------------------------------------------------------------------------------------------------------------
		--  모델별 Cutoff - PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률
		--  모델별 Cutoff - LD_RT : 부하율
		--  모델별 Cutoff - OP_RT : 시간가동률
		--  모델별 Cutoff - PF_RT : 성능가동률
		--  모델별 Cutoff - QL_RT : 양품가동률
		-------------------------------------------------------------------------------------------------------------------
		INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		SELECT MDL_ALTER_KEY 
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
			  ,TARGET_YN
		 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		WHERE 1=1
		  AND MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')
		GROUP BY MDL_ALTER_KEY	
				,YYYYMM
				,TARGET_YN

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - TEEP' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		SELECT MDL_ALTER_KEY 
			  ,'-'			AS MSR_GR_CD
			  ,'TEEP'		AS MSR_TP_CD
			  ,YYYYMM
			  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'	THEN PFRSLT_NVL ELSE 0.0 END)) 
			   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'AV_RT'		THEN PFRSLT_NVL ELSE 0.0 END)) AS PFRSLT_NVL
			  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'	THEN BASE_NVL	ELSE 0.0 END)) 
			   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'AV_RT'		THEN BASE_NVL	ELSE 0.0 END)) AS BASE_NVL
			  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'	THEN MSR_NVL	ELSE 0.0 END)) 
			   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'AV_RT'		THEN MSR_NVL	ELSE 0.0 END)) AS MSR_NVL
			  ,TARGET_YN
		 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		WHERE 1=1
		  AND MSR_TP_CD IN ('PROD_OP_RT', 'AV_RT')
		GROUP BY MDL_ALTER_KEY	
				,YYYYMM
				,TARGET_YN

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - 생산 Capa(일)' 
		-------------------------------------------------------------------------------------------------------------------
		-- 모델별 Cutoff - PROD_CAPA_D : 생산 CAPA(일) : 이론 Capa(일) * 생산가동률
		-- 모델별 Cutoff - PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률
		-- 모델별 Cutoff - THRY_CAPA_D : 이론 CAPA(일) 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY   
		SELECT MDL_ALTER_KEY 
			  ,'-'			AS MSR_GR_CD
			  ,'PROD_CAPA_D'	AS MSR_TP_CD
			  ,YYYYMM
			  ,NULL																					   AS PFRSLT_NVL
			  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'  THEN BASE_NVL	ELSE 0.0 END)) 
			   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D' THEN BASE_NVL	ELSE 0.0 END)) AS BASE_NVL
			  ,  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'  THEN MSR_NVL	ELSE 0.0 END)) 
			   * CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D' THEN MSR_NVL	ELSE 0.0 END)) AS MSR_NVL
			  ,TARGET_YN
		 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY WITH(NOLOCK)
		WHERE 1=1
		  AND MSR_TP_CD IN ('PROD_OP_RT', 'THRY_CAPA_D') 
		GROUP BY MDL_ALTER_KEY	
				,YYYYMM
				,TARGET_YN

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - 생산 Capa(월) 추가 - PROD_CAPA_M' 
		-- 생산 Capa(월) = 생산 Capa(일) * 최대조업일수
		-- YYYYMM인 년도인경우 생산 Capa(월) = (생산 Capa(일) * 최대조업일수) / 12 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		SELECT  
			   PD.MDL_ALTER_KEY
			  ,PD.MSR_GR_CD
			  ,'PROD_CAPA_M' AS MSR_TP_CD
			  ,PD.YYYYMM
			  ,NULL										  AS PFRSLT_NVL
			  ,CONVERT(FLOAT, PD.BASE_NVL	) *  @V_BASE_YYYYMM_DDN
												/* 2024.10.16 base sop 적용안함
												CASE WHEN BS.SOP_YM IS NOT NULL
													 THEN BS.SOP_DDN
													 ELSE @V_BASE_YYYYMM_DDN
												END	*/	  AS BASE_NVL
			  ,CONVERT(FLOAT, PD.MSR_NVL	) * CASE WHEN SO.SOP_YM IS NOT NULL
													 THEN SO.SOP_DDN
													 ELSE YM.YYYYMM_DDN
												 END	  AS MSR_NVL 
			  ,PD.TARGET_YN
		  FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY PD WITH(NOLOCK)
			   INNER JOIN #YYYYMM_DAYS_INFO  YM  
					   ON YM.YYYYMM = PD.YYYYMM 
				LEFT JOIN #SOP_INFO SO	-- 2024.08.29 SOP 적용 
					   ON SO.MDL_ALTER_KEY = PD.MDL_ALTER_KEY
					  AND SO.SOP_YM		   = PD.YYYYMM
				-- 2024.10.16 base 적용 안함 LEFT JOIN #SOP_INFO BS	-- 2024.08.29 SOP 적용 for Base   
				-- 2024.10.16 base 적용 안함 	   ON BS.MDL_ALTER_KEY	= PD.MDL_ALTER_KEY
				-- 2024.10.16 base 적용 안함 	  AND BS.SOP_YM			= @V_BASE_YYYYMM
		WHERE 1=1
		  AND PD.MSR_TP_CD = 'PROD_CAPA_D'

		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 최종 Update 대상 ' 
		------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#LOSS_PLAN_MDL_UPDATE_TARGET') IS NOT NULL DROP TABLE #LOSS_PLAN_MDL_UPDATE_TARGET

		SELECT AK.MDL_ALTER_KEY
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
			  ,ISNULL(MC.MSR_GR_CD, '-')				AS MSR_GR_CD
			  ,CONVERT(NUMERIC(20,10), MC.PFRSLT_NVL)	AS PFRSLT_NVL
			  ,CONVERT(NUMERIC(20,10), MC.BASE_NVL	)	AS BASE_NVL	
			  ,CONVERT(NUMERIC(20,10), MC.MSR_NVL	)	AS MSR_NVL	
			  ,MC.TARGET_YN
		 INTO #LOSS_PLAN_MDL_UPDATE_TARGET
		 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY MC 
			  INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK
					  ON AK.MDL_ALTER_KEY = MC.MDL_ALTER_KEY
			  LEFT JOIN #SCP_MST_CAPA_LOSS_PLAN_MDL LC 
					  ON LC.MDL_ALTER_KEY	= MC.MDL_ALTER_KEY
					 AND LC.YYYYMM			= MC.YYYYMM
					 AND LC.MSR_TP_CD		= MC.MSR_TP_CD
		WHERE 1=1
		  AND MC.MSR_TP_CD  NOT IN ('NLD','NOP') 

		-------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan 모델별 Cutoff Data -  CPS Formation 공정 제외' 
		-- 2024.09.11 CPS Formation 공정(Daily Production Capa) TEEP 대상에서 제외 
		-- 2024.11.05 Capa measure만 CPS Formation공정 update대상에서 제외 (위치 변경) 
		-------------------------------------------------------------------------------------------------------------------------
		DELETE LS
		 FROM #LOSS_PLAN_MDL_UPDATE_TARGET LS 
			  INNER JOIN #CPS_FORMATION_OPERATION FO
					  ON FO.OPERATION_ID = LS.OPERATION_ID
		WHERE 1=1
		  AND LS.MSR_TP_CD LIKE '%CAPA%'

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'### 조립/팩 운영계획 재계산 결과 반영 (개선/목표 입력구간) '   
		SET @v_description = '[@P_BASE_YYYYMM='+ ISNULL(@P_BASE_YYYYMM,'')  + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

	------- Begin Tran : =======================================================================================
	------- Begin Tran : =======================================================================================

	  BEGIN TRAN   --- transaction 시작  

		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 운영계획 Update (SCP_MST_CAPA_LOSS_PLAN_MDL)' 
		------------------------------------------------------------------------------------------------------------------
		UPDATE LP
		   SET LP.PFRSLT_NVL		= TG.PFRSLT_NVL
			  ,LP.BASE_NVL			= TG.BASE_NVL
			  ,LP.MSR_NVL			= TG.MSR_NVL	-- 2024.10.30 line assign 안된 구간 데이터도 존재하면 초기화. CASE WHEN TG.TARGET_YN = 'Y' THEN TG.MSR_NVL ELSE NULL END  -- Line Assign된 대상이 아닌경우 운영계획 null처리 ? 2024.05.10 
			  ,LP.LAST_UPDATED_BY	= @v_program_name
			  ,LP.LAST_UPDATE_DATE	= GETDATE()
			  ,LP.ATTRIBUTE1		= 'PFRSLT='+ISNULL(CONVERT(NVARCHAR(100), LP.PFRSLT_NVL), '')
			  ,LP.ATTRIBUTE2		= 'BASE='+ISNULL(CONVERT(NVARCHAR(100), LP.BASE_NVL), '')
			  ,LP.ATTRIBUTE3		= 'MSR='+ISNULL(CONVERT(NVARCHAR(100), LP.MSR_NVL), '')
		  FROM SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
			   INNER JOIN #LOSS_PLAN_MDL_UPDATE_TARGET TG  
					   ON TG.DIVISION_ID	= LP.DIVISION_ID
					  AND TG.PLANT_ID		= LP.PLANT_ID
					  AND TG.LINE_ID		= LP.LINE_ID
					  AND TG.OPERATION_ID	= LP.OPERATION_ID
					  AND TG.ELTR_LN_TP_CD	= LP.ELTR_LN_TP_CD
					  AND TG.MDL_NM			= LP.MDL_NM
					  AND TG.COMPANY_ID		= LP.COMPANY_ID
					  AND TG.SITE_ID		= LP.SITE_ID
					  AND TG.FACTORY_ID		= LP.FACTORY_ID
					  AND TG.MSR_TP_CD		= LP.MSR_TP_CD
					  AND TG.YYYYMM			= LP.YYYYMM
		WHERE 1=1
		  AND LP.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE LP.DIVISION_ID
								   END 

		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'MMD 기준 Speed Plan Base Update '  -- 2024.10.07
		-- 2025.02.06 운영계획 구간 update 추가
		------------------------------------------------------------------------------------------------------------------
		UPDATE SP 
		   SET SP.BASE_QTY			= CASE	WHEN MB.DIVISION_ID IS NOT NULL
											THEN MB.BASE_QTY 
											ELSE SP.BASE_QTY
									   END 
		      ,SP.QTY				= CASE	WHEN OP.DIVISION_ID IS NOT NULL AND SP.MSR_TP_CD	= 'PPM'	-- 2025.02.06 운영계획 PPM재계산 반영 (MMS,CPM)
											THEN OP.PPM_calc 
											ELSE SP.QTY
									   END 
		      ,SP.REMARK			= CASE	WHEN OP.DIVISION_ID IS NOT NULL AND SP.MSR_TP_CD	= 'PPM'	
											THEN CONCAT(OP.SPEED_UNIT, '::', CONVERT(NVARCHAR(30), OP.EQP_NBU), '::', CONVERT(NVARCHAR(30), OP.SPEED),'::', OP.ELTR_QTY, '::', OP.ELTR_PCH_LEN)
											ELSE SP.REMARK
									   END 
			  ,SP.LAST_UPDATED_BY	= @v_program_name
			  ,SP.LAST_UPDATE_DATE	= GETDATE()
		 FROM SCP_MST_CAPA_SPEED_PLAN SP WITH(NOLOCK)
			  LEFT  JOIN #MMD_SPEED_PLAN_BASE MB --  2025.02.06 JOIN변경 (INNER->LEFT)
					  ON MB.DIVISION_ID		= SP.DIVISION_ID
					 AND MB.COMPANY_ID		= SP.COMPANY_ID
					 AND MB.SITE_ID			= SP.SITE_ID
					 AND MB.PLANT_ID		= SP.PLANT_ID
					 AND MB.FACTORY_ID		= SP.FACTORY_ID
					 AND MB.LINE_ID			= SP.LINE_ID
					 AND MB.OPERATION_ID	= SP.OPERATION_ID
					 AND MB.ELTR_LN_TP_CD	= SP.ELTR_LN_TP_CD
					 AND MB.NICK_NAME		= SP.NICK_NAME
					 AND MB.MSR_TP_CD		= SP.MSR_TP_CD
			  LEFT  JOIN #SPEED_PLAN_MMS_CPM_PPM OP	--  2025.02.06 운영계획 PPM 
				 	  ON OP.DIVISION_ID		= SP.DIVISION_ID
				     AND OP.COMPANY_ID		= SP.COMPANY_ID
				     AND OP.SITE_ID			= SP.SITE_ID
				     AND OP.PLANT_ID		= SP.PLANT_ID
				     AND OP.FACTORY_ID		= SP.FACTORY_ID
				     AND OP.LINE_ID			= SP.LINE_ID
				     AND OP.OPERATION_ID	= SP.OPERATION_ID
				     AND OP.ELTR_LN_TP_CD	= SP.ELTR_LN_TP_CD
				     AND OP.NICK_NAME		= SP.NICK_NAME
					 AND OP.YYYYMM			= SP.YYYYMM
		WHERE 1=1
		  AND SP.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE SP.DIVISION_ID
								   END 
		  AND (MB.DIVISION_ID IS NOT NULL  -- base update 대상
				OR 
			   OP.DIVISION_ID IS NOT NULL) -- 운영계획 update 대상 

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
			  ,ATTRIBUTE1			)
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
		  FROM #SCP_MST_CAPA_LINE_SOP SP WITH(NOLOCK)
		 WHERE 1=1


	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================
	------- End Tran : ==========================================================================================================

		-----------------------------------------
		------ 임시테이블 정리
		-------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCM_DNM_LOSS_LN_MMLY') IS NOT NULL DROP TABLE #SCM_DNM_LOSS_LN_MMLY
		IF OBJECT_ID('TEMPDB..#SCM_DNM_LOSS_MDL_MMLY') IS NOT NULL DROP TABLE #SCM_DNM_LOSS_MDL_MMLY
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LINE_ASSIGN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LINE_ASSIGN
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL
		IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO;
		IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_MDL') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_MDL
		IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_SPEED_PLAN_MMS_CPM') IS NOT NULL DROP TABLE #SCP_MST_CAPA_SPEED_PLAN_MMS_CPM;
		IF OBJECT_ID('TEMPDB..#SPEED_PLAN_MMS_CPM_PPM') IS NOT NULL DROP TABLE #SPEED_PLAN_MMS_CPM_PPM;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LINE_SOP') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LINE_SOP
		IF OBJECT_ID('TEMPDB..#SOP_INFO') IS NOT NULL DROP TABLE #SOP_INFO
		if object_id('tempdb..#mdl_eltr_qty') is not null drop table #mdl_eltr_qty;
		IF OBJECT_ID('TEMPDB..#MMD_EQP_SPED') IS NOT NULL DROP TABLE #MMD_EQP_SPED;
		IF OBJECT_ID('TEMPDB..#MMD_PPM') IS NOT NULL DROP TABLE #MMD_PPM;
		IF OBJECT_ID('TEMPDB..#MMD_SPEED_PLAN_BASE') IS NOT NULL DROP TABLE #MMD_SPEED_PLAN_BASE;

	  END			    
	END TRY

	BEGIN CATCH                  
		if (xact_state() <> 0) ROLLBACK TRAN; 

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
	SET @v_description = N'[@V_BASE_YYYYMM='+ ISNULL(@V_BASE_YYYYMM,'')  + '::@V_DIVISION_ID=' + ISNULL(@V_DIVISION_ID,'ALL') + ']['  + @v_exec_time + ']';
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
