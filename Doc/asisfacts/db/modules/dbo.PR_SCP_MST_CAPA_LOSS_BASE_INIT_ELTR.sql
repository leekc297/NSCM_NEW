



/* 
 *
 * Program ID   : PR_SCP_MST_CAPA_LOSS_BASE_INIT_ELTR
 * Description  : 매월 10일 실적 마감후 Loss Plan Current Data 실적/Base 데이터 초기화
 *				 - 대상 measure : 비부하/비가동/성능가동률/양품가동률
 *				 - 1. 최근 3개월 LOSS Plan 실적이 존재하는 Current 데이터에 대해서 실적/Base 값을 초기화 한다. (3개월 평균) 
 *				 - 2. 실적/Base값이 초기화된 건에 대해서 개선/목표율 입력구간(Y0 ~ Y1)에 대해서 운영계획을 재계산 적용한다.
 *					 (Line Assign Valid 이고 Priority 설정된 기간의 운영계획만 재계산 적용 )
 *				 - 3. 기준년월에 해당하는 버전 진행상태 정보를 Update한다. ('-':Init -> '0':Current(Speed/Loss계획 개시)) 
 *				 
 *			### Source Table 
 * 					SCM_DNM_ELTR_LOSS_LN_MMLY
 *					SCP_MST_CAPA_ELTR_LINE_ASSIGN   
 *					SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
 *					SCP_MST_CAPA_ELTR_SPEED_PLAN	-- for 이론Capa (7/16)
 *					SCP_MST_CAPA_ELTR_LINE_SOP
 *					SCM_MMD_EQPT_PRDT_SPEED_SN		-- 2024.10.07 
 *					SCM_MST_EQUIPMENT_SN			-- 2024.10.07 추가 
 *
 *			### Target Table 
 * 					SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
 *					SCP_MST_CAPA_ELTR_LINE_SOP_B
 *					SCP_MST_CAPA_ELTR_SPEED_PLAN			-- 2024.10.07 추가 
 *
 * Program History  
 *=========================================================================================================  
 *   Date      In Charge	Description  
 *=========================================================================================================  
 * 2024.06.07	hrkim		Initial Release PJ2024-50026 / LGES2024-002455 Capa. 관리 시스템 구축 / 전극개발
 * 2024.06.11	hrkim		Loss plan시 실적은 Capa 보여주지 않음. (Null로 초기화 - 이론Capa 및 생산 Capa) 
 * 2024.06.19	hrkim		Line Assign 정보 조인시 품목ID 조인 조건 변경  
 * 2024.06.25	hrkim		Line Agging 참조 오류 ( 모델별 / 라인별 measure  별도 참조) 
 * 2024.07.10	hrkim		전극 테이블 PK 변경 : ELTR_LN_TP_CD 컬럼 PK컬럼에서 제외
 * 2024.07.16	hrkim		운영계획 이론 Capa 초기화 로직 추가 (speed plan 속도 적용)
 * 2024.08.09	hrkim		MMD기준 이론Capa base 초기화 로직 삭제  
 * 2024.08.12	hrkim		불필요한 주석처리된 소스 삭제
 * 2024.08.13	hrkim		실적유무와 상관 없이 성능가동률 default 100%으로 반영
 * 2024.08.29	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 적용
 * 2024.09.12	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 적용 최대조업일수 임시테이블 데이터 타입 수정 (FLOAT) 
 * 2024.09.25	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 정보 백업 
 * 2024.10.07	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : MMD기준 Speed Plan Base / Loss Plan Base 이론Capa 초기화 로직 추가  
 * 2024.10.16	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : base SOP 적용 안함 
 * 2024.10.30	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : line assign 안된 구간 데이터도 존재하면 초기화.  (line assign이 안된 구간이 loss데이터는 없어야함)    
 * 2024.11.05	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 성능가동률 운영계획 무조건 100%으로 하기 위해 보완  (개선/목표 입력구간이 아닌 데이터) 
 * 2025.02.06	hrkim		개선/목표율 관리 기능 삭제 - 해당 컬럼 참조 소스 삭제 (IPRV_GOL_DIVS_CD/IPRV_GOL_RT)
 * 2025.03.18	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_MST_CAPA_LOSS_BASE_INIT_ELTR]  --- 전극
	 @P_BASE_YYYYMM	NVARCHAR(6)		= NULL
	,@P_DIVISION_ID	NVARCHAR(50)	= NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE	@V_BASE_YYYYMM		NVARCHAR(6)		= @P_BASE_YYYYMM;
	DECLARE	@V_BASE_YYYYMM_DDN	FLOAT			= NULL;
	DECLARE	@V_DIVISION_ID		NVARCHAR(50)	= @P_DIVISION_ID;

	DECLARE	@V_RSLT_YYYYMM		NVARCHAR(6)		= NULL;				-- 실적 참조 기준년월  (M-1) 

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_CAPA_LOSS_BASE_INIT_ELTR'; --Proc별 이름 설정
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
		PRINT '@V_RSLT_YYYYMM				= ' + ISNULL(@V_RSLT_YYYYMM		,'');
		PRINT '------------------------------------------------------------------';

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '[@V_BASE_YYYYMM='+ ISNULL(@V_BASE_YYYYMM,'') + '::@V_DIVISION_ID=' + ISNULL(@V_DIVISION_ID,'ALL') + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'전극 Capa 재계산 대상 -  Line Assign Priority 모델별 ' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_ASSIGN_MDL') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_ASSIGN_MDL

		SELECT LA.ITEM_ID
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
		 INTO #SCP_MST_CAPA_ELTR_LINE_ASSIGN_MDL
		 FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN LA WITH(NOLOCK)
		WHERE 1=1
		  AND LA.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE LA.DIVISION_ID
								   END 
		  AND LA.VALID_YN	 = 'Y'  
		  AND ISNULL(LA.ASSIGN_PRIORITY, 0) != 0

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'전극 Capa 재계산 대상 -  Line Assign Priority 라인별 ' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_ASSIGN_LN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_ASSIGN_LN

		SELECT LA.DIVISION_ID
			  ,LA.COMPANY_ID
			  ,LA.SITE_ID
			  ,LA.PLANT_ID
			  ,LA.FACTORY_ID
			  ,LA.LINE_ID
			  ,LA.OPERATION_ID
			  ,MAX(LA.ELTR_LN_TP_CD)				AS ELTR_LN_TP_CD	-- 7/10 PK 컬럼에서 제외 
			  ,LA.YYYYMM
			  ,MAX(LA.DUMMY_YN)						AS DUMMY_YN
		 INTO #SCP_MST_CAPA_ELTR_LINE_ASSIGN_LN
		 FROM #SCP_MST_CAPA_ELTR_LINE_ASSIGN_MDL LA WITH(NOLOCK)
		WHERE 1=1
		GROUP BY LA.DIVISION_ID
			  ,LA.COMPANY_ID
			  ,LA.SITE_ID
			  ,LA.PLANT_ID
			  ,LA.FACTORY_ID
			  ,LA.LINE_ID
			  ,LA.OPERATION_ID
			  ,LA.YYYYMM

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'전극 Capa 재계산 대상 -  #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL' 
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
				,CONVERT(FLOAT, LS.PFRSLT_NVL)		AS PFRSLT_NVL
				,CONVERT(FLOAT, LS.BASE_NVL)		AS BASE_NVL
				,LS.MSR_GR_CD
				,CONVERT(FLOAT, LS.MSR_NVL)			AS MSR_NVL
				,CASE WHEN LN.YYYYMM IS NULL 
					  THEN 'N'
					  ELSE 'Y'
				 END  AS TARGET_YN -- Line Assign priority 값이 존재하면 Target 
		 INTO #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL 
		 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LS WITH(NOLOCK) 
			  LEFT JOIN #SCP_MST_CAPA_ELTR_LINE_ASSIGN_MDL LM WITH(NOLOCK)
					 ON 1=1 
					AND LM.DIVISION_ID		= LS.DIVISION_ID
					AND LM.COMPANY_ID		= LS.COMPANY_ID
					AND LM.SITE_ID			= LS.SITE_ID
					AND LM.PLANT_ID			= LS.PLANT_ID
					AND LM.FACTORY_ID		= LS.FACTORY_ID
					AND LM.LINE_ID			= LS.LINE_ID
					AND LM.OPERATION_ID		= LS.OPERATION_ID
					AND LM.ITEM_ID			= LS.MDL_NM
					AND LM.YYYYMM			= LS.YYYYMM
			  LEFT JOIN #SCP_MST_CAPA_ELTR_LINE_ASSIGN_LN LN WITH(NOLOCK)
					 ON 1=1 
					AND LN.DIVISION_ID		= LS.DIVISION_ID
					AND LN.COMPANY_ID		= LS.COMPANY_ID
					AND LN.SITE_ID			= LS.SITE_ID
					AND LN.PLANT_ID			= LS.PLANT_ID
					AND LN.FACTORY_ID		= LS.FACTORY_ID
					AND LN.LINE_ID			= LS.LINE_ID
					AND LN.OPERATION_ID		= LS.OPERATION_ID
					AND LN.YYYYMM			= LS.YYYYMM
		WHERE 1=1
		  AND LS.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE LS.DIVISION_ID
								   END 

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
		 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LS WITH(NOLOCK)
		WHERE 1=1

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 라인별 Loss 실적 - 최근 3개월 실적' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCM_DNM_ELTR_LOSS_LN_MMLY') IS NOT NULL DROP TABLE #SCM_DNM_ELTR_LOSS_LN_MMLY

		SELECT LR.DIVISION_ID
			  ,LR.COMPANY_ID
			  ,LR.SITE_ID
			  ,LR.PLANT_ID
			  ,LR.FACTORY_ID
			  ,LR.LINE_ID
			  ,LR.OPERATION_ID
			  ,LR.ELTR_LN_TP_CD
			  ,LR.LOSS_CD
			  ,LR.LOSS_GR_CD 
			  ,CONVERT(FLOAT, LR.LOSS_RT) AS LOSS_RT
		 INTO #SCM_DNM_ELTR_LOSS_LN_MMLY  
		 FROM SCM_DNM_ELTR_LOSS_LN_MMLY  LR with(nolock)
		WHERE 1=1
		  AND LR.LOSS_YM		= @V_RSLT_YYYYMM
		  AND LR.PERD_DIVS_CD	= '3'	-- 최근 3개월 실적
		  AND LR.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE LR.DIVISION_ID
								   END 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Loss Plan Current - 실적 NUL 처리' 
		-- 2025.03.26 실적 Null 처리 
		-------------------------------------------------------------------------------------------------------------------
		UPDATE LP 
		 SET   LP.PFRSLT_NVL			= NULL
		FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
		WHERE 1=1

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Loss Plan Current - 실적/Base 초기화' 
		-- 실적 값으로 Base가 초기화 
		-------------------------------------------------------------------------------------------------------------------
		 UPDATE LP SET   LP.PFRSLT_NVL			= RL.LOSS_RT	-- 실적 
						,LP.BASE_NVL			= CASE	WHEN LP.MSR_TP_CD = 'AV_RT'		THEN CONVERT(NUMERIC(20,10), 1) -- Base 조업률은 defualt 100%
														WHEN LP.MSR_TP_CD = 'PF_RT'		THEN CONVERT(NUMERIC(20,10), 1) -- Base 성능가동률 defualt 100% 2024.08.13 수정
														ELSE RL.LOSS_RT 
												  END			-- Base
		FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
			 LEFT JOIN #SCM_DNM_ELTR_LOSS_LN_MMLY  RL	-- 비부하/비가동/성능가동률/양품가동률
					ON RL.PLANT_ID		= LP.PLANT_ID
				   AND RL.LINE_ID		= LP.LINE_ID
				   AND RL.OPERATION_ID	= LP.OPERATION_ID
				   AND RL.DIVISION_ID	= LP.DIVISION_ID
				   AND RL.COMPANY_ID	= LP.COMPANY_ID
				   AND RL.SITE_ID		= LP.SITE_ID
				   AND RL.FACTORY_ID	= LP.FACTORY_ID
				   AND RL.LOSS_CD		= LP.MSR_TP_CD
		WHERE 1=1
		  AND RL.LOSS_CD IS NOT NULL -- 실적이 존재하는 데이터만 초기화 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Loss Plan Current - 성능가동률 default 100%으로 초기화' 
		-- 2024.08.13 실적값과 상관 없이 성능가동률(PF_RT) default 100% 반영 
		-------------------------------------------------------------------------------------------------------------------
		UPDATE LP 
		SET   LP.BASE_NVL =  CONVERT(NUMERIC(20,10), 1) 
			 ,LP.MSR_NVL  =  CONVERT(NUMERIC(20,10), 1)	 -- 2024.11.05 개선/목표율 입력구간이 아닌 경우도 성능가동률 무조건 100%로 Update  추가
		FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
		WHERE 1=1 
		  AND LP.MSR_TP_CD = 'PF_RT'

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 모델별 Speed Plan Current - 이론 Capa'   -- 2024.07.16
		-- 이론Capa = 속도 * 1440 * 폭환산자(W:2, S:1) 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#ELTR_SPEED_PLAN_THRY_CAPA') IS NOT NULL DROP TABLE #ELTR_SPEED_PLAN_THRY_CAPA;

		SELECT SP.DIVISION_ID
			  ,SP.COMPANY_ID
			  ,SP.SITE_ID
			  ,SP.PLANT_ID
			  ,SP.FACTORY_ID
			  ,SP.LINE_ID
			  ,SP.OPERATION_ID
			  ,SP.ITEM_ID		AS MDL_NM
			  ,SP.YYYYMM
			  ,SP.ELTR_LN_TP_CD
			  ,CONVERT(NUMERIC(20,10), CONVERT(FLOAT, SP.QTY) 
									 * CONVERT(FLOAT, 1440) 
									 * CONVERT(FLOAT, CASE WHEN SP.ELTR_LN_TP_CD = 'W' THEN 2 ELSE 1 END)) AS THRY_CAPA_D
			  ,CONVERT(NUMERIC(20,10), CONVERT(FLOAT, SP.BASE_QTY) 
									 * CONVERT(FLOAT, 1440) 
									 * CONVERT(FLOAT, CASE WHEN SP.ELTR_LN_TP_CD = 'W' THEN 2 ELSE 1 END)) AS THRY_CAPA_D_BASE
		 INTO #ELTR_SPEED_PLAN_THRY_CAPA
		 FROM SCP_MST_CAPA_ELTR_SPEED_PLAN SP WITH(NOLOCK)
		WHERE 1=1
		  AND SP.MSR_TP_CD = 'EQP_SPED'  -- 설비 속도 

		-------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan Current - 이론Capa 운영계획 초기화'  -- 2024.07.16
		-------------------------------------------------------------------------------------------------------------------------
		UPDATE LP 
		   SET MSR_NVL = SP.THRY_CAPA_D
		FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
			 INNER JOIN #ELTR_SPEED_PLAN_THRY_CAPA  SP	-- 이론 Capa(일) 
					ON SP.DIVISION_ID	= LP.DIVISION_ID
				   AND SP.COMPANY_ID	= LP.COMPANY_ID
				   AND SP.SITE_ID		= LP.SITE_ID
				   AND SP.PLANT_ID		= LP.PLANT_ID
				   AND SP.FACTORY_ID	= LP.FACTORY_ID
				   AND SP.LINE_ID		= LP.LINE_ID
				   AND SP.OPERATION_ID	= LP.OPERATION_ID
				   AND SP.MDL_NM		= LP.MDL_NM
				   AND SP.YYYYMM		= LP.YYYYMM
		WHERE 1=1
		  AND LP.MSR_TP_CD = 'THRY_CAPA_D'

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 모델별 MMD 설비속도 - Base 설비 속도' 
		-- 2024.10.07 MMD기준 속도 정보
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#LINE_MMD_ITEM_EQP_SPED') IS NOT NULL DROP TABLE #LINE_MMD_ITEM_EQP_SPED;

		SELECT EM.DIVISION_ID
			  ,EM.SITE_ID
			  ,EM.COMPANY_ID
			  ,EM.PLANT_ID
			  ,EM.FACTORY_ID
			  ,EM.LINE_ID
			  ,EM.OPERATION_ID
			  ,ES.BOM_ITEM_ID
			  ,ES.EQP_ID
			  ,CASE WHEN EM.WIDE_ROLL_ENABLE_FLAG = 'Y'
					THEN 'W'		-- Wide
					ELSE 'S'		-- Standard 
				END							AS ELTR_LN_TP_CD 
			  ,CONVERT(FLOAT, ES.EQP_SPED)	AS EQP_SPED
			  ,ROW_NUMBER() OVER (PARTITION BY EM.DIVISION_ID
											  ,EM.SITE_ID
											  ,EM.COMPANY_ID
											  ,EM.PLANT_ID
											  ,EM.FACTORY_ID
											  ,EM.LINE_ID
											  ,EM.OPERATION_ID
											  ,ES.BOM_ITEM_ID
									  ORDER BY ES.UPDATE_TIME DESC
											  ,EM.UPDATE_TIME DESC) AS RN  -- 라인별 설비가 여러대인 경우 최신 속도정보 등록 기준 하나만 선택 
		 INTO #LINE_MMD_ITEM_EQP_SPED
		 FROM SCM_MST_EQUIPMENT_SN EM WITH(NOLOCK)
			  INNER JOIN SCM_MMD_EQPT_PRDT_SPEED_SN ES WITH(NOLOCK)
					  ON ES.EQP_ID = EM.EQUIPMENT_ID
					 AND ISNULL(ES.EQP_SPED,0) != 0		-- 속도 값이 없는 건 제외
		WHERE 1=1
		  AND EM.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE EM.DIVISION_ID
								   END 
		  -- 2025.03.18 소형 확산 AND EM.DIVISION_ID   != '40'		-- 소형제외
		  AND EM.OPERATION_ID LIKE 'E2000%'	-- 전극 Coating 공정 (현재는 E2000 공정 하나만 대상)  
		  AND EM.EQUIPMENT_TYPE = 'M'		-- Main 설비
		  AND EM.ACTIVE_FLAG	= 'Y'
		;
		
		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan Current - 이론Capa Base 초기화' 
		-- 2024.10.07 MMD기준 Base 이론 Capa 초기화
		-------------------------------------------------------------------------------------------------------------------
		 UPDATE LP SET   LP.BASE_NVL	= ES.EQP_SPED * CONVERT(FLOAT, 1440) * CASE	WHEN LP.ELTR_LN_TP_CD = 'W' 
																					THEN CONVERT(FLOAT, 2)
																					ELSE CONVERT(FLOAT, 1) 
																				END 
		FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
			 INNER JOIN #LINE_MMD_ITEM_EQP_SPED  ES	-- 이론 Capa(일) -- Base 
				 	 ON ES.DIVISION_ID	= LP.DIVISION_ID
				    AND ES.COMPANY_ID	= LP.COMPANY_ID
				    AND ES.SITE_ID		= LP.SITE_ID
				    AND ES.PLANT_ID		= LP.PLANT_ID
				    AND ES.FACTORY_ID	= LP.FACTORY_ID
				    AND ES.LINE_ID		= LP.LINE_ID
				    AND ES.OPERATION_ID	= LP.OPERATION_ID
				    AND ES.BOM_ITEM_ID	= LP.MDL_NM
				    AND ES.RN			= 1 
		WHERE 1=1
		  AND LP.MSR_TP_CD = 'THRY_CAPA_D'

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 모델별 ALTER KEY 정보 - #ALTER_KEY_INFO_FOR_MDL' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_MDL') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_MDL

		SELECT 
			   LS.MDL_ALTER_KEY
			  ,LS.LN_ALTER_KEY
			  ,LS.MDL_NM
			  ,LS.PLANT_ID
			  ,LS.LINE_ID
			  ,LS.OPERATION_ID
			  ,MAX(LS.ELTR_LN_TP_CD)	AS ELTR_LN_TP_CD	-- 7/10 PK 컬럼에서 제외 
			  ,LS.DIVISION_ID
			  ,LS.COMPANY_ID
			  ,LS.SITE_ID
			  ,LS.FACTORY_ID
		INTO #ALTER_KEY_INFO_FOR_MDL
		FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LS  WITH(NOLOCK)
	   WHERE 1=1
	   GROUP BY 
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
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - SOP Master 정보 - #SCP_MST_CAPA_ELTR_LINE_SOP' 
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
		   AND SP.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
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
		-- 전극 : DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID 
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
		SELECT AK.MDL_ALTER_KEY
			  ,AK.MDL_NM
			  ,SP.DIVISION_ID
			  ,SP.COMPANY_ID
			  ,SP.SITE_ID
			  ,SP.PLANT_ID
			  ,SP.FACTORY_ID
			  ,SP.LINE_ID
			  ,SP.OPERATION_ID
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
		 WHERE 1=1

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 대상 Current Data with Alter Key ' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY

		SELECT MDL_ALTER_KEY
			  ,LN_ALTER_KEY
			  ,MSR_GR_CD
			  ,MSR_TP_CD
			  ,YYYYMM
			  ,CONVERT(NUMERIC(20,10), PFRSLT_NVL)	AS PFRSLT_NVL
			  ,CONVERT(NUMERIC(20,10), BASE_NVL)	AS BASE_NVL
			  ,CONVERT(NUMERIC(20,10), MSR_NVL)		AS MSR_NVL
			  ,TARGET_YN
		 INTO #LOSS_MDL_CUTOFF_WITH_ALTER_KEY 
		 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
		WHERE 1=1 
		  AND (MSR_GR_CD IN ('NLD','NOP') 
			   OR 
			   MSR_TP_CD IN ('PF_RT', 'QL_RT', 'THRY_CAPA_D', 'AV_RT')) 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - 비부하/비가동 비율 TOTAL 추가 ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY 
		SELECT LS.MDL_ALTER_KEY
			  ,LS.LN_ALTER_KEY
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
				,LS.LN_ALTER_KEY
				,LS.MSR_GR_CD
				,LS.YYYYMM
				,LS.TARGET_YN

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - 부하/가동 비율 TOTAL 추가 (LD_RT/OP_RT)' 
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
			  ,TARGET_YN
		 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		WHERE 1=1
		  AND MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')
		GROUP BY MDL_ALTER_KEY	
			    ,LN_ALTER_KEY
				,YYYYMM
				,TARGET_YN

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - TEEP' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		SELECT MDL_ALTER_KEY 
			  ,LN_ALTER_KEY
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
			    ,LN_ALTER_KEY
				,YYYYMM
				,TARGET_YN


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - 생산 Capa(일)' 
		-------------------------------------------------------------------------------------------------------------------
		-- PROD_CAPA_D : 생산 CAPA(일) : 이론 Capa(일) * 생산가동률
		-- PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률
		-- THRY_CAPA_D : 이론 CAPA(일) 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY   
		SELECT TC.MDL_ALTER_KEY 
			  ,TC.LN_ALTER_KEY
			  ,'-'				AS MSR_GR_CD
			  ,'PROD_CAPA_D'	AS MSR_TP_CD
			  ,TC.YYYYMM
			  ,NULL																	AS PFRSLT_NVL
			  ,CONVERT(FLOAT, TC.BASE_NVL)		* CONVERT(FLOAT, PR.BASE_NVL	)	AS BASE_NVL
			  ,CONVERT(FLOAT, TC.MSR_NVL)		* CONVERT(FLOAT, PR.MSR_NVL		)	AS PFRSLT_NVL
			  ,TC.TARGET_YN
		 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY TC WITH(NOLOCK)
			  LEFT JOIN #LOSS_MDL_CUTOFF_WITH_ALTER_KEY PR WITH(NOLOCK)
					 ON PR.MSR_TP_CD	= 'PROD_OP_RT'	-- 라인별 생산가동률 Measure 
					AND PR.LN_ALTER_KEY = TC.LN_ALTER_KEY
					AND PR.YYYYMM		= TC.YYYYMM
		WHERE 1=1
		  AND TC.MSR_TP_CD = 'THRY_CAPA_D' -- 모델(Item_id)별 이론Capa 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'  Capa 재계산 - 생산 Capa(월) 추가 - PROD_CAPA_M' 
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
			  ,NULL										  AS PFRSLT_NVL
			  ,CONVERT(FLOAT, PD.BASE_NVL	) * @V_BASE_YYYYMM_DDN
												/* 2024.10.16 base sop 적용 안함 
												CASE WHEN BS.SOP_YM IS NOT NULL
													 THEN BS.SOP_DDN
													 ELSE @V_BASE_YYYYMM_DDN
												END	*/
												AS BASE_NVL
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
				-- 2024.10.16 bse sop 적용 안함  LEFT JOIN #SOP_INFO BS	-- 2024.08.29 SOP 적용 for Base   
				-- 2024.10.16 bse sop 적용 안함  	   ON BS.MDL_ALTER_KEY	= PD.MDL_ALTER_KEY
				-- 2024.10.16 bse sop 적용 안함  	  AND BS.SOP_YM			= @V_BASE_YYYYMM
		WHERE 1=1
		  AND PD.MSR_TP_CD = 'PROD_CAPA_D'


		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 최종 Update 대상 ' 
		------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#LOSS_PLAN_MDL_UPDATE_TARGET') IS NOT NULL DROP TABLE #LOSS_PLAN_MDL_UPDATE_TARGET

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
			  ,ISNULL(MC.MSR_GR_CD, '-')				AS MSR_GR_CD
			  ,CONVERT(NUMERIC(20,10), MC.PFRSLT_NVL)	AS PFRSLT_NVL
			  ,CONVERT(NUMERIC(20,10), MC.BASE_NVL	)	AS BASE_NVL	
			  ,CONVERT(NUMERIC(20,10), MC.MSR_NVL	)	AS MSR_NVL	
			  ,MC.TARGET_YN
		 INTO #LOSS_PLAN_MDL_UPDATE_TARGET
		 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY MC 
			  INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK
					  ON AK.MDL_ALTER_KEY = MC.MDL_ALTER_KEY
			  LEFT JOIN #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LC 
					  ON LC.MDL_ALTER_KEY	= MC.MDL_ALTER_KEY
					 AND LC.YYYYMM			= MC.YYYYMM
					 AND LC.MSR_TP_CD		= MC.MSR_TP_CD
		WHERE 1=1
		  AND MC.MSR_TP_CD  NOT IN ('NLD','NOP') 


		SET @v_log_type = 'TXN';
		SET @v_log_message = N'### 전극 운영계획 재계산 결과 반영 (개선/목표 입력구간) '   
		SET @v_description = '[@P_BASE_YYYYMM='+ ISNULL(@P_BASE_YYYYMM,'') + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 


	------- Begin Tran : =======================================================================================
	------- Begin Tran : =======================================================================================

	  BEGIN TRAN   --- transaction 시작  

		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Capa 재계산 - 운영계획 Update (SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL)' 
		------------------------------------------------------------------------------------------------------------------
		UPDATE LP
		   SET LP.PFRSLT_NVL		= TG.PFRSLT_NVL
			  ,LP.BASE_NVL			= TG.BASE_NVL
			  ,LP.MSR_NVL			= TG.MSR_NVL	-- 2024.10.30  line assign 안된 구간 데이터는 없어야함. 있다면 변경 필요. CASE WHEN TG.TARGET_YN = 'Y' THEN TG.MSR_NVL ELSE NULL END  -- Line Assign된 대상이 아닌경우 운영계획 null처리 ? 2024.05.10 
			  ,LP.LAST_UPDATED_BY	= @v_program_name
			  ,LP.LAST_UPDATE_DATE	= GETDATE()
			  ,LP.ATTRIBUTE1		= 'PFRSLT='+ISNULL(CONVERT(NVARCHAR(100), LP.PFRSLT_NVL), '')
			  ,LP.ATTRIBUTE2		= 'BASE='+ISNULL(CONVERT(NVARCHAR(100), LP.BASE_NVL), '')
			  ,LP.ATTRIBUTE3		= 'MSR='+ISNULL(CONVERT(NVARCHAR(100), LP.MSR_NVL), '')
		  FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
			   INNER JOIN #LOSS_PLAN_MDL_UPDATE_TARGET TG  
					   ON TG.DIVISION_ID	= LP.DIVISION_ID
					  AND TG.PLANT_ID		= LP.PLANT_ID
					  AND TG.LINE_ID		= LP.LINE_ID
					  AND TG.OPERATION_ID	= LP.OPERATION_ID
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
		print  convert(varchar(30), getdate(), 121) + N' 전극 update Speed Plan base' 
		-- 2024.10.07 MMD기준 속도로 speed plan base 초기화 
		------------------------------------------------------------------------------------------------------------------
		UPDATE SP 
		   SET SP.BASE_QTY			= MS.EQP_SPED 
			  ,SP.LAST_UPDATED_BY	= @v_program_name
			  ,SP.LAST_UPDATE_DATE	= GETDATE()
		 FROM SCP_MST_CAPA_ELTR_SPEED_PLAN SP WITH(NOLOCK)
			  INNER JOIN #LINE_MMD_ITEM_EQP_SPED MS
					  ON SP.DIVISION_ID		= MS.DIVISION_ID
					 AND SP.COMPANY_ID		= MS.COMPANY_ID
					 AND SP.SITE_ID			= MS.SITE_ID
					 AND SP.PLANT_ID		= MS.PLANT_ID
					 AND SP.FACTORY_ID		= MS.FACTORY_ID
					 AND SP.LINE_ID			= MS.LINE_ID
					 AND SP.OPERATION_ID	= MS.OPERATION_ID
					 AND SP.ITEM_ID			= MS.BOM_ITEM_ID
		WHERE 1=1
		  AND SP.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
										THEN @V_DIVISION_ID
										ELSE SP.DIVISION_ID
								   END 
		  AND SP.MSR_TP_CD			= 'EQP_SPED'
		  AND ISNULL(SP.BASE_QTY,0)!= ISNULL(MS.EQP_SPED,0) 

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
			  ,ATTRIBUTE1				  )
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
		  FROM #SCP_MST_CAPA_ELTR_LINE_SOP SP WITH(NOLOCK)
		 WHERE 1=1

	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================
	------- End Tran : ==========================================================================================================


		-----------------------------------------
		------ 임시테이블 정리
		---------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_ASSIGN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_ASSIGN
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL
		IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO;
		IF OBJECT_ID('TEMPDB..#SCM_DNM_ELTR_LOSS_LN_MMLY') IS NOT NULL DROP TABLE #SCM_DNM_ELTR_LOSS_LN_MMLY
		IF OBJECT_ID('TEMPDB..#SCM_DNM_ELTR_EQP_SPED_MMLY') IS NOT NULL DROP TABLE #SCM_DNM_ELTR_EQP_SPED_MMLY
		IF OBJECT_ID('TEMPDB..#LINE_MMD_ITEM_EQP_SPED') IS NOT NULL DROP TABLE #LINE_MMD_ITEM_EQP_SPED;
		IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_MDL') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_MDL
		IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		IF OBJECT_ID('TEMPDB..#LOSS_PLAN_MDL_UPDATE_TARGET') IS NOT NULL DROP TABLE #LOSS_PLAN_MDL_UPDATE_TARGET
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_SOP') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_SOP
		IF OBJECT_ID('TEMPDB..#SOP_INFO') IS NOT NULL DROP TABLE #SOP_INFO

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
