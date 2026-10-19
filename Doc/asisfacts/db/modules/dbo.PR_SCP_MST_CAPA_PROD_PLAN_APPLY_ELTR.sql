
/*  
 * Program ID   : PR_SCP_MST_CAPA_PROD_PLAN_APPLY_ELTR
 * Description  : 전극 SCP Prod Final Plan 적용 
 *				 
 *			### Source Table 
 *					SCP_MST_CAPA_VERSION
 *					SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
 *					SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF	-- Lane수 참조
 *					SCP_ANL_PRODUCTION_PLAN
 *					SCM_MST_BUCKET
 *					SCM_MST_PLAN
 *					SCM_MST_PLAN_DETAIL
 *					SCM_MST_DIVISION
 *					SCM_MST_SITE
 *					SCM_EQUIPMENT_M						-- 광폭 가능여부 참조 -- Wide/Standard 
 *					SCM_LINE_M							-- Line Master  2024.09.13 
 *					SCP_MST_CAPA_ELTR_LINE_SOP
 *
 *			### Target Table 
 *					SCP_MST_CAPA_VERSION
 *					SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
 *						- SCP 생산 계획 및 조업률(조업일수)
 *					SCP_MST_CAPA_ELTR_LOSS_PLAN_LN   
 *						-- 비조업
 *					SCP_MST_CAPA_ELTR_LINE_SOP_B
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.06.07	hrkim		Initial Release PJ2024-50026 / LGES2024-002455  Capa. 관리 시스템 구축 - 전극
 * 2024.06.13	hrkim		라인별 비조업 current 항목 추가 
 * 2024.07.10	hrkim		전극 테이블 PK 변경 : ELTR_LN_TP_CD 컬럼 PK컬럼에서 제외
 * 2024.08.09	hrkim		line assign된 대상에만 생산계획 반영 
 * 2024.08.12	hrkim		라인별 비조업 BASE 누락 오류 수정 (line assign 여부 확인시) 
 * 2024.08.14	hrkim		조업률 계산시 반영시 실적값은 1이 아닌 loss 라인별 실적 기준으로 적재 
 * 2024.08.29	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 적용
 * 2024.09.12	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 적용 최대조업일수 임시테이블 데이터 타입 수정 (FLOAT) 
 * 2024.09.13	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 설비정보 없이 라인만 존재할 경우 생산계획 반영되도록 수정. 
 * 2024.09.25	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : SOP 정보 백업 
 * 2024.10.23	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : current 라인별 비조업 MSR_DDN 컬럼 Null처리 (사용안함)
 * 2024.12.13	hrkim		LGES2024-002655 SCP 개선과제 이행 : 
 *							 계획시작 년도 변경되었을시 신규 년월구간에 대한 이전 버전 생산계획을 년월데이터로 변환 참조되도록 함 
 *								예) 202412월 버전 seq 1 인경우 2027년 년도 생산계획을 월 생산계획으로 변환 추가
 * 2025.01.14	hrkim		lookup CPS_BATCH_CRTN_THURSDAY(월별 CPS 배치 수행 기준 목요일) 적용 
 *							 - 매월 마지막 목요일 기준으로 전/후 일요일에 1,2차 컷오프 수행 및 해당 주차의 SCP FN 생산계획 적용 
 *							 - lookup이 등록된 경우 해당 목요일 기준으로 전/후 일요일에 1,2차 컷오프 수행 및 해당 주차의 SCP FN 생산계획 적용
 * 2025.02.05	hrkim		개선/목표율 관리 기능 삭제 - 해당 컬럼 참조 소스 삭제 (IPRV_GOL_DIVS_CD/IPRV_GOL_RT)
 * 2025.03.17	hrkim		CURSOR오류 - 커서 선언문 위치 변경 
 * 2025.03.20	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 * 2025.06.16   kimcd       PJ2024A332   독립적 Planning 체계 및 Master Validation UI 구축
 *                          소형 EA에도 표준폭으로 환산하는 로직 추가
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_MST_CAPA_PROD_PLAN_APPLY_ELTR]
	 @P_IS_MANUAL		NVARCHAR(1)		= 'N'
	,@P_EE_DIVISION_ID	NVARCHAR(50)	=  NULL
AS
BEGIN


-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE	@V_IS_MANUAL		NVARCHAR(1)		= @P_IS_MANUAL		;
	DECLARE @V_EE_DIVISION_ID	NVARCHAR(30)	= @P_EE_DIVISION_ID	;
	DECLARE @V_DIVISION_ID		NVARCHAR(30)	= NULL	;
	DECLARE @V_VER_ID			NVARCHAR(10)	= NULL				;
	DECLARE @V_VER_SEQ			TINYINT			= NULL				;
	DECLARE @V_LAST_THU			NVARCHAR(8)		= NULL				;
	DECLARE	@V_RESULT_YYYYMM	NVARCHAR(6)		= NULL				;				-- 실적 참조 년월 

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_CAPA_PROD_PLAN_APPLY_ELTR'; --Proc별 이름 설정
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
		PRINT '@V_EE_DIVISION_ID	= ' + ISNULL(@V_EE_DIVISION_ID, 'ALL');
		PRINT '------------------------------------------------------------------';

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '[DIVISION_ID='+ ISNULL(@P_EE_DIVISION_ID, 'ALL')  + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'Batch 실행일 정보 - 마지막주 목요일이 포함된 주차 (화-금)' 
		------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#Batch_Date_Info') IS NOT NULL DROP TABLE #Batch_Date_Info;

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
			  ,MAX(BF.YYYYMMDD)	AS FROM_YMD			-- 해당월 마지막 목요일 포함 주차 화요일
			  ,MIN(AF.YYYYMMDD)	AS TO_YMD			-- 해당월 마지막 목요일 포함 주차 금요일
		 INTO #Batch_Date_Info
		 FROM THU  TH 
			  INNER JOIN SCM_MST_BUCKET BF WITH(NOLOCK)
					  ON BF.YYYYMMDD < TH.YYYYMM_LAST_THU
					 AND BF.DAYOFWEEK = 'TUE'
			  INNER JOIN SCM_MST_BUCKET AF WITH(NOLOCK)
					  ON AF.YYYYMMDD > TH.YYYYMM_LAST_THU
					 AND AF.DAYOFWEEK = 'FRI'
		WHERE 1=1
		GROUP BY TH.YYYYMM
			  ,TH.YYYYMM_LAST_THU 


	  IF @V_IS_MANUAL = 'Y' 
	     OR 
	     EXISTS (SELECT 1 
	  				FROM #Batch_Date_Info
	  			   WHERE CONVERT(NVARCHAR(8), GETDATE(), 112) BETWEEN FROM_YMD AND TO_YMD )  --  마지막주 목요일이 포함된 주차 화요일부터 금요일만 수행 (FN수행시)  
	  BEGIN  ------------------------------------------------------------------------------------- SCP FN 생산계획 반영 배치 수행일인 경우만 실행!!! 

	    -- TRY문 안쪽으로 커서 선언 위치 변경 2025.03.17 
		DECLARE CAPA_VER_DATA  CURSOR FOR
			SELECT ED.DIVISION_ID	AS EE_DIVISION_ID
				  ,CV.DIVISION_ID	AS ORIGIN_DIVISION_ID
				  ,CV.VER_ID
				  ,CV.VER_SEQ 
			 FROM SCM_MST_DIVISION  ED WITH(NOLOCK)				-- 전극 Division
				  INNER JOIN SCM_MST_DIVISION OD WITH(NOLOCK)	-- Origin Division 
						  ON OD.ATTRIBUTE4 = ED.ATTRIBUTE4
						 -- 2025.03.19 소형 확산 AND OD.DIVISION_ID != '40' -- 소형제외
						 AND OD.VALID_YN = 'Y'
						 AND OD.ATTRIBUTE3 != 'EE'
				  INNER JOIN SCP_MST_CAPA_VERSION CV WITH(NOLOCK) 
						  ON CV.DIVISION_ID = OD.DIVISION_ID -- origin division_id 
			WHERE 1=1
			 AND ED.DIVISION_ID = ISNULL(@V_EE_DIVISION_ID, ED.DIVISION_ID)
			 AND ED.ATTRIBUTE3  = 'EE'
			 AND ED.VALID_YN	= 'Y'
			 AND CV.VER_ID	   >= CONVERT(NVARCHAR(6), DATEADD(MM, -1, GETDATE()), 112)		-- 목요일이 해당월의 마지막일이고, 금요일이 FN 재수행할수도 있음으로...  
			 AND CV.PROG_STAT	= '1'
			;

		OPEN CAPA_VER_DATA
        FETCH NEXT FROM CAPA_VER_DATA INTO @V_EE_DIVISION_ID
										  ,@V_DIVISION_ID		-- origin division_id 
										  ,@V_VER_ID
										  ,@V_VER_SEQ

        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN

			-- 실적 참조 년월 
			SET @V_RESULT_YYYYMM	= CONVERT(NVARCHAR(6), DATEADD(MM, -1, CONVERT(DATE, @V_VER_ID+'01', 112)), 112) 

			PRINT '------------------------------------------------------------------';
			PRINT '@V_DIVISION_ID			= ' + @V_DIVISION_ID;
			PRINT '@V_VER_ID				= ' + @V_VER_ID;
			PRINT '@V_VER_SEQ				= ' + CONVERT(NVARCHAR(10), @V_VER_SEQ);
			PRINT '@V_RESULT_YYYYMM			= ' + @V_RESULT_YYYYMM;
			PRINT '------------------------------------------------------------------';

			SET @v_log_type = 'TXN';
			SET @v_log_message = 'START - '+@v_division_id;     
			SET @v_description = '['+ @v_division_id + '::' + @V_VER_ID + '::' + CONVERT(NVARCHAR(10), @V_VER_SEQ) + ']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
			SET @v_log_message = NULL 

			-------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 모델별 Loss Plan 모델별 Cutoff Data -  #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF' 
			-------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF;

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
					,LS.MSR_TP_CD
					,LS.YYYYMM
					,CONVERT(NUMERIC(20,10), PFRSLT_NVL		)	AS PFRSLT_NVL
					,CONVERT(NUMERIC(20,10), BASE_NVL		)	AS BASE_NVL
					-- 2025.02.05 개선/목표일 관리 기능 삭제,IPRV_GOL_DIVS_CD
					-- 2025.02.05 개선/목표일 관리 기능 삭제,CONVERT(NUMERIC(20,10), IPRV_GOL_RT	)	AS IPRV_GOL_RT
					,MSR_GR_CD
					,CONVERT(NUMERIC(20,10), MSR_NVL		)	AS MSR_NVL
					,CONVERT(NUMERIC(20,10), MSR_DDN		)	AS MSR_DDN
			 INTO #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF
			 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS WITH(NOLOCK) 
			WHERE 1=1
			  AND LS.VER_ID		 = @V_VER_ID
			  AND LS.VER_SEQ	 = @V_VER_SEQ
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
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS WITH(NOLOCK)
			WHERE 1=1

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 모델별 ALTER KEY 정보 - #ALTER_KEY_INFO_FOR_MDL' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_MDL') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_MDL

			SELECT 
				   LS.MDL_ALTER_KEY
				  ,LS.LN_ALTER_KEY
				  ,LS.MDL_NM
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,MAX(LS.ELTR_LN_TP_CD)	AS ELTR_LN_TP_CD -- 7/10 PK 컬럼에서 제외 
				  ,CONVERT(FLOAT, CASE WHEN MAX(LS.ELTR_LN_TP_CD) = 'W' THEN  2  ELSE  1  END)	AS RATE	-- 2024.09.13  추가 W:2,S:1
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
			INTO #ALTER_KEY_INFO_FOR_MDL
			FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS  WITH(NOLOCK)
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
			print  convert(varchar(30), getdate(), 121) + N' 라인별 ALTER KEY 정보 - #ELTR_ALTER_KEY_INFO_LN ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_ALTER_KEY_INFO_LN') IS NOT NULL DROP TABLE #ELTR_ALTER_KEY_INFO_LN

			SELECT 
				   LS.LN_ALTER_KEY
				  ,LS.PLANT_ID
				  ,LS.LINE_ID
				  ,LS.OPERATION_ID
				  ,MAX(LS.ELTR_LN_TP_CD)	AS ELTR_LN_TP_CD -- 7/10 PK 컬럼에서 제외 
				  ,LS.DIVISION_ID
				  ,LS.COMPANY_ID
				  ,LS.SITE_ID
				  ,LS.FACTORY_ID
			INTO #ELTR_ALTER_KEY_INFO_LN 
			FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LS  WITH(NOLOCK)
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
			   AND SP.DIVISION_ID	= @V_DIVISION_ID
			   AND SP.VALID_YN		= 'Y'
			   AND SP.SOP_DT IS NOT NULL
			   AND SP.SOP_YM IS NOT NULL
			   AND SP.SOP_DDN IS NOT NULL 
			   AND SP.SOP_DDN	   != 0 

			--------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 라인별/월 일수 정보 WITH SOP - #YYYYMM_DAYS_INFO_APPLIED_SOP'  
			-- 전극 : DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
			--------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO_APPLIED_SOP') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO_APPLIED_SOP

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
				  ,CONVERT(FLOAT,		-- 2024.09.12 
				   CASE WHEN SO.SOP_YM IS NOT NULL
						THEN SO.SOP_DDN
						ELSE DI.YYYYMM_DDN
					END ) AS YYYYMM_DDN
			 INTO #YYYYMM_DAYS_INFO_APPLIED_SOP 
			 FROM #ELTR_ALTER_KEY_INFO_LN AK
				   INNER JOIN #YYYYMM_DAYS_INFO DI
						   ON  1=1
					LEFT JOIN CAPA_LINE_SOP SO WITH(NOLOCK) 
						   ON SO.DIVISION_ID	= AK.DIVISION_ID
						  AND SO.COMPANY_ID		= AK.COMPANY_ID
						  AND SO.SITE_ID		= AK.SITE_ID
						  AND SO.PLANT_ID		= AK.PLANT_ID
						  AND SO.FACTORY_ID		= AK.FACTORY_ID
						  AND SO.LINE_ID		= AK.LINE_ID
						  AND SO.OPERATION_ID	= AK.OPERATION_ID
						  AND SO.SOP_YM			= DI.YYYYMM
			 WHERE 1=1

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 데이터 -  생산 Capa (일) / 생산가동률 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY

			SELECT MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,MSR_GR_CD
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,CONVERT(NUMERIC(20,10) , PFRSLT_NVL	)		AS PFRSLT_NVL
				  ,CONVERT(NUMERIC(20,10) , BASE_NVL	)		AS BASE_NVL
				  ,CONVERT(NUMERIC(20,10) , MSR_NVL		)		AS MSR_NVL
				  ,CONVERT(NUMERIC(20,10) , NULL		)		AS MSR_DDN
			 INTO #LOSS_MDL_CUTOFF_WITH_ALTER_KEY   
			 FROM #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LP WITH(NOLOCK)
			WHERE 1=1 
			  AND MSR_TP_CD IN ('PROD_CAPA_D', 'PROD_OP_RT')

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' FP설비 Master정보 #SCM_MST_EQUIPMENT_SN' 
			-- 전극 E2000 Caoting공정 라인 : 설비 = 1 : 1 (소형 제외) 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCM_MST_EQUIPMENT_SN') IS NOT NULL DROP TABLE #SCM_MST_EQUIPMENT_SN;

			SELECT EM.COMPANY_ID
				 , EM.DIVISION_ID
				 , EM.SITE_ID
				 , EM.PLANT_ID
				 , EM.FACTORY_ID
				 , EM.EQUIPMENT_ID
				 , EM.OPERATION_ID
				 , EM.LINE_ID
				 , CASE WHEN EM.WIDE_ROLL_ENABLE_FLAG = 'Y' THEN 'W' ELSE 'S' END					AS ELTR_LN_TP_CD	-- W:Wide,	S:Standard
				 , CONVERT(FLOAT, CASE WHEN EM.WIDE_ROLL_ENABLE_FLAG = 'Y' THEN  2  ELSE  1  END)	AS RATE				-- W:2,		S:1
				 , EM.ELECTRODE_TYPE
				 , ROW_NUMBER() OVER (PARTITION BY EM.COMPANY_ID
												  ,EM.DIVISION_ID
												  ,EM.SITE_ID
												  ,EM.PLANT_ID
												  ,EM.LINE_ID
												  ,EM.OPERATION_ID
										ORDER BY   EM.UPDATE_TIME DESC) AS EM_RN 
			 INTO #SCM_MST_EQUIPMENT_SN
			 FROM SCM_MST_EQUIPMENT_SN EM WITH(NOLOCK)
			WHERE 1=1
			  AND EM.DIVISION_ID	= @V_DIVISION_ID 
			  AND EM.OPERATION_ID LIKE 'E2000%'			-- 전극 E2000공정 
			  AND EM.EQUIPMENT_TYPE = 'M'				-- Main설비
			  AND EM.ACTIVE_FLAG	= 'Y'


			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Line Assign Lane 수 정보 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#LINE_ASSIGN_LANE_QTY') IS NOT NULL DROP TABLE #LINE_ASSIGN_LANE_QTY; 

			SELECT LA.DIVISION_ID
				  ,LA.COMPANY_ID
				  ,LA.SITE_ID
				  ,LA.PLANT_ID
				  ,LA.FACTORY_ID
				  ,LA.LINE_ID
				  ,LA.OPERATION_ID
				  ,MAX(LA.ELTR_LN_TP_CD)	AS ELTR_LN_TP_CD
				  ,LA.ITEM_ID
				  ,CONVERT(FLOAT, CASE WHEN MAX(LA.LANE_QTY) = 0 THEN 1 ELSE MAX(LA.LANE_QTY) END)		AS LANE_QTY -- 2024.09.25  0이면 1로 처리 
			  INTO #LINE_ASSIGN_LANE_QTY
			  FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF LA WITH(NOLOCK)
			 WHERE 1=1
			   AND LA.VER_ID = @V_VER_ID
			   AND LA.VER_SEQ = @V_VER_SEQ 
			   AND LA.VALID_YN = 'Y'
			GROUP BY
				   LA.DIVISION_ID
				  ,LA.COMPANY_ID
				  ,LA.SITE_ID
				  ,LA.PLANT_ID
				  ,LA.FACTORY_ID
				  ,LA.LINE_ID
				  ,LA.OPERATION_ID
				  ,LA.ITEM_ID
				  
			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'버전 해당월의 마지막 목요일' 
			------------------------------------------------------------------------------------------------------------------
			SELECT @V_LAST_THU = MAX(YYYYMMDD)
			 FROM SCM_MST_BUCKET THU WITH(NOLOCK)
			WHERE 1=1
			  AND YYYYMM =  @V_VER_ID
			  AND DAYOFWEEK = 'THU'
			  
			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - SCP Final PLAN 버전 정보' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_PROD_PLAN_VERSION') IS NOT NULL DROP TABLE #SCP_PROD_PLAN_VERSION; 

			WITH SCP_FN_PLAN_INFO AS (
				SELECT 
					  P.DIVISION_ID
					 ,D.PLAN_TYPE
					 ,D.PLAN_SEQ
					 ,P.PLAN_NAME														AS PLAN_START_YYYYMMDD
					 ,SUBSTRING(P.HORIZON_END_DATE, 1, 8)								AS HORIZEN_END_DATE 
					 ,DENSE_RANK() OVER (PARTITION BY P.DIVISION_ID ORDER BY P.PLAN_NAME DESC )	AS PLAN_PRIORITY
				 FROM SCM_MST_PLAN  P WITH(NOLOCK)
					  INNER JOIN SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
							  ON D.DIVISION_ID  = P.DIVISION_ID
							 AND D.PLAN_ID      = P.PLAN_ID
							 AND D.PLAN_TYPE    = 'FN' -- FN
							 AND D.PLAN_STATUS  = '1'  -- 정상 완료
							 AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm
				WHERE 1=1
				  AND P.DIVISION_ID	= @V_EE_DIVISION_ID  -- 전극 Division
				  AND P.PLAN_CYCLE	= 'WEEKLY'
				  AND P.PLAN_NAME LIKE @V_VER_ID + '%'   --- 버전 해당월의 SCP Plan 참조 
				  AND P.PLAN_NAME   < @V_LAST_THU		 --- 마지막 목요일 이전 SCP plan 
			)
			SELECT FP.*
				  ,CASE WHEN SUBSTRING(PLAN_START_YYYYMMDD,7,2) = '01'  
						THEN SUBSTRING(PLAN_START_YYYYMMDD, 1, 6) + '01' 
						ELSE CONVERT(NVARCHAR(6), DATEADD(MM, 1, CONVERT(DATE, PLAN_START_YYYYMMDD, 112)),112) + '01'
				   END  AS PROD_FROM_YYYYMM 
				 , CASE WHEN HORIZEN_END_DATE = CONVERT(NVARCHAR(8), DATEADD(DD, -1, DATEADD(MM, 1, CONVERT(DATE, SUBSTRING(HORIZEN_END_DATE, 1, 6) + '01', 112))),112)
						THEN HORIZEN_END_DATE 
						ELSE CONVERT(NVARCHAR(8), DATEADD(DD, -1, CONVERT(DATE, SUBSTRING(HORIZEN_END_DATE, 1, 6) + '01', 112)), 112)
				   END  AS PROD_TO_YYYYMM
				 , @V_DIVISION_ID	AS ORIGIN_DIVISION_ID 
			  INTO #SCP_PROD_PLAN_VERSION  
			  FROM SCP_FN_PLAN_INFO FP
			 WHERE 1=1
			   AND FP.PLAN_PRIORITY = 1 
			;

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - SCP Final PLAN 생산계획' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL DROP TABLE #SCP_ANL_PRODUCTION_PLAN; 

			SELECT 
				   PV.PROD_FROM_YYYYMM
				  ,PV.PROD_TO_YYYYMM
				  ,SUBSTRING(PP.YYYYMMDD, 1, 6) AS PROD_YYYYMM 
				  ,PP.DIVISION_ID				AS EE_DIVISION_ID 
				  ,PP.ORIGIN_DIVISION_ID		AS DIVISION_ID
				  ,PP.SCM_SITE_ID
				  ,PP.ITEM_ID
				  ,PP.LINE_ID
				  ,PP.OPERATION_ID
				  ,PP.OPERATION_GROUP
				  ,CONVERT(FLOAT, SUM(PP.QTY))		AS QTY 
		INTO #SCP_ANL_PRODUCTION_PLAN 
			FROM #SCP_PROD_PLAN_VERSION PV 
				 INNER JOIN SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK) 
						 ON PP.PLAN_START_YYYYMMDD	= PV.PLAN_START_YYYYMMDD
						AND PP.DIVISION_ID			= PV.DIVISION_ID	-- 전극 division_id  
						AND PP.PLAN_TYPE			= PV.PLAN_TYPE
						AND PP.SEQ					= PV.PLAN_SEQ
						AND PP.ORIGIN_DIVISION_ID	= @V_DIVISION_ID	-- origin_division_id 
						AND PP.OPERATION_GROUP		= 'E'	-- 전극
			WHERE 1=1
			  AND PP.MEASURE ='PROD_PLAN_ENGINE'
			GROUP BY PV.PROD_FROM_YYYYMM
					,PV.PROD_TO_YYYYMM
					,SUBSTRING(PP.YYYYMMDD, 1, 6)
				    ,PP.DIVISION_ID				
				    ,PP.ORIGIN_DIVISION_ID		
					,PP.SCM_SITE_ID
					,PP.ITEM_ID
					,PP.LINE_ID
					,PP.OPERATION_ID
					,PP.OPERATION_GROUP

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 참조 Master 데이터 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCM_MST_SITE') IS NOT NULL DROP TABLE #SCM_MST_SITE;
			SELECT DIVISION_ID
				  ,SCM_SITE_ID
				  ,COMPANY_ID
				  ,SITE_ID
				  ,PLANT_ID
				  ,SITE_TYPE
			 INTO #SCM_MST_SITE
			 FROM SCM_MST_SITE WITH(NOLOCK)

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 참조 line Master 데이터 '  -- 2024.09.13 추가
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCM_MST_LINE_SN') IS NOT NULL DROP TABLE #SCM_MST_LINE_SN;
			SELECT DIVISION_ID
				  ,COMPANY_ID
				  ,SITE_ID
				  ,PLANT_ID
				  ,FACTORY_ID
				  ,LINE_ID
				  ,OPERATION_ID
				  ,PROD_VERSION_TYPE	-- 2025.03.20 CPS 소형 확산
			 INTO #SCM_MST_LINE_SN
			 FROM SCM_MST_LINE_SN WITH(NOLOCK)
			WHERE 1=1
			  AND DIVISION_ID = @V_DIVISION_ID
			  AND OPERATION_ID= 'E2000'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' EA 생산 계획 수량 Jumbo roll Meter 환산 기준 값 '  
			-- 2025.03.20 PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCM_MST_ITEM_CONV_CALC_SN') IS NOT NULL DROP TABLE #SCM_MST_ITEM_CONV_CALC_SN;
			SELECT  C.COMPANY_ID        
				   ,C.DIVISION_ID       
				   ,C.SITE_ID  
				   ,C.PLANT_ID
				   ,C.FACTORY_ID        
				   ,C.OPERATION         
				   ,C.PROD_VERSION_TYPE		-- GENERAL/WIDE 
				   ,C.ITEM_ID        
				   ,CONVERT(FLOAT, MAX(ISNULL(C.VALUE,1)))	AS EA2JRM_CONV_VALUE
			 INTO #SCM_MST_ITEM_CONV_CALC_SN
			 FROM SCM_MST_ITEM_CONV_CALC_SN C WITH(NOLOCK)
			WHERE 1=1
			  AND C.DIVISION_ID		  = '40'
              AND C.MAX_VER_FLAG      = 'Y'
              AND C.CATEGORY          = N'Jumbo Roll (cell/m)'
			GROUP BY C.COMPANY_ID        
				    ,C.DIVISION_ID       
				    ,C.SITE_ID           
				    ,C.PLANT_ID
				    ,C.FACTORY_ID        
				    ,C.OPERATION         
				    ,C.PROD_VERSION_TYPE 
				    ,C.ITEM_ID 

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 소형 ITEM UOM '  
			-- 2025.03.20 PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCM_MST_ITEM_SN') IS NOT NULL DROP TABLE #SCM_MST_ITEM_SN;
			SELECT I.ITEM_ID
				  ,I.COMPANY_ID
				  ,MAX(ITEM_UOM)	AS ITEM_UOM
			 INTO #SCM_MST_ITEM_SN
			 FROM SCM_MST_ITEM_SN	I WITH(NOLOCK) 
			WHERE 1=1
			  AND I.DIVISION_ID = '40' 
			GROUP BY I.ITEM_ID
				    ,I.COMPANY_ID

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - SCP Final PLAN 생산계획 2' 
			-- 자동차는 ITEM UOM 모두 'M'   --> 소형 기타는 UOM에 따른 케이스 처리 필요 !!  
			-- Pancake M → STD M : Rate (폭환산자) & Lane 수 반영
			-- Final SCP Pancake Plan / (Lane / Rate)
			-- 2024/9/13 조인 및 select 항목 참조 변경 EM(설비) -> LM(라인) 
			-- 2025.03.20 ITEM_UOM 'EA' 인경우 STD JR M = SCP 생산계획 / 'Jumbo Roll (cell/m)'
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_FINAL_PROD_PLAN') IS NOT NULL DROP TABLE #SCP_FINAL_PROD_PLAN;

			SELECT AK.MDL_ALTER_KEY
				 , AK.LN_ALTER_KEY
				 , PP.DIVISION_ID
				 , PP.ITEM_ID																AS MDL_NM
				 , LM.PLANT_ID
				 , PP.LINE_ID
				 , PP.OPERATION_ID
				 , MAX(EM.ELTR_LN_TP_CD)													AS ELTR_LN_TP_CD	-- 7/10 PK 컬럼에서 제외(값을 동일할 듯) 
				 , LM.COMPANY_ID
				 , LM.SITE_ID
				 , LM.FACTORY_ID	
				 , PP.PROD_YYYYMM															AS YYYYMM
				 , LQ.LANE_QTY
				 , MAX(EM.RATE)																AS RATE				-- 7/10 PK 컬럼에서 제외(값은 동일할 듯)
				 , CASE WHEN ISNULL(IU.ITEM_UOM, 'Z') = 'EA'
						THEN CONVERT(FLOAT, SUM(PP.QTY)) / ISNULL(CC.EA2JRM_CONV_VALUE, 1.)	-- SCP 생산계획 / 'Jumbo Roll (cell/m)' 
						     * ISNULL(MAX(EM.RATE), MAX(AK.RATE))
						-- 2025.06.16 kimcd 소형 EA에도 표준폭으로 환산하는 로직 추가. 기존 자동차의 경우 분모를 나눔.. EA에서는 나눈 결과를 곱하도록 로직 설정
						ELSE CONVERT(FLOAT, SUM(PP.QTY))	
								/ CONVERT(FLOAT, (ISNULL(LQ.LANE_QTY, CONVERT(FLOAT, 1)) / ISNULL(MAX(EM.RATE), MAX(AK.RATE))) ) 	
					END AS MSR_NVL -- 2024.09.13 변경 MAX(EM.RATE) ==> ISNULL(MAX(EM.RATE), MAX(AK.RATE))
				-- 2025.03.20 소형 적용전 , CONVERT(FLOAT, SUM(PP.QTY))	
				-- 2025.03.20 소형 적용전	/ CONVERT(FLOAT, (ISNULL(LQ.LANE_QTY, CONVERT(FLOAT, 1)) / ISNULL(MAX(EM.RATE), MAX(AK.RATE))) ) 	AS MSR_NVL -- 2024.09.13 변경 MAX(EM.RATE) ==> ISNULL(MAX(EM.RATE), MAX(AK.RATE))
			INTO #SCP_FINAL_PROD_PLAN
			FROM #SCP_ANL_PRODUCTION_PLAN PP 
				  INNER JOIN #SCM_MST_SITE MS WITH(NOLOCK) 
						  ON MS.DIVISION_ID		= PP.DIVISION_ID
						 AND MS.SCM_SITE_ID		= PP.SCM_SITE_ID 
				  INNER JOIN #SCM_MST_LINE_SN LM  -- 2024.09.13 조인 추가  
						  ON LM.COMPANY_ID		= MS.COMPANY_ID
						 AND LM.DIVISION_ID		= MS.DIVISION_ID 
						 AND LM.SITE_ID			= MS.SITE_ID 
						 AND LM.PLANT_ID		= MS.PLANT_ID 
						 AND LM.OPERATION_ID	= PP.OPERATION_ID 
						 AND LM.LINE_ID			= PP.LINE_ID 
				  LEFT  JOIN #SCM_MST_EQUIPMENT_SN EM   --- 2024.09.13 조인 변경 INNER -> LEFT  설비정보가 없는 경우  입력된 값 기준 
						  ON EM.EM_RN = 1
						 AND EM.COMPANY_ID		= MS.COMPANY_ID
						 AND EM.DIVISION_ID		= MS.DIVISION_ID
						 AND EM.SITE_ID			= MS.SITE_ID
						 AND EM.PLANT_ID		= MS.PLANT_ID
						 AND EM.LINE_ID			= PP.LINE_ID
						 AND EM.OPERATION_ID	= PP.OPERATION_ID
				  INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK WITH(NOLOCK)
						  ON AK.MDL_NM			= PP.ITEM_ID
						 AND AK.PLANT_ID		= MS.PLANT_ID
						 AND AK.LINE_ID			= PP.LINE_ID
						 AND AK.OPERATION_ID	= PP.OPERATION_ID
						 AND AK.DIVISION_ID		= LM.DIVISION_ID		-- 9/13 EM -> LM 
						 AND AK.COMPANY_ID		= LM.COMPANY_ID			-- 9/13 EM -> LM 
						 AND AK.SITE_ID			= LM.SITE_ID			-- 9/13 EM -> LM 
						 AND AK.FACTORY_ID		= LM.FACTORY_ID			-- 9/13 EM -> LM 
				  LEFT  JOIN #LINE_ASSIGN_LANE_QTY LQ WITH(NOLOCK)
						  ON LQ.DIVISION_ID		= LM.DIVISION_ID		-- 9/13 EM -> LM 
						 AND LQ.COMPANY_ID		= LM.COMPANY_ID			-- 9/13 EM -> LM 
						 AND LQ.SITE_ID			= LM.SITE_ID			-- 9/13 EM -> LM 
						 AND LQ.PLANT_ID		= LM.PLANT_ID			-- 9/13 EM -> LM 
						 AND LQ.FACTORY_ID		= LM.FACTORY_ID			-- 9/13 EM -> LM 
						 AND LQ.LINE_ID			= LM.LINE_ID			-- 9/13 EM -> LM 
						 AND LQ.OPERATION_ID	= LM.OPERATION_ID		-- 9/13 EM -> LM 
						 AND LQ.ITEM_ID			= PP.ITEM_ID
				  LEFT  JOIN #SCM_MST_ITEM_CONV_CALC_SN CC WITH(NOLOCK)	-- 2025.03.20 CPS 소형 확산 : join 참조 추가
						  ON CC.COMPANY_ID			= LM.COMPANY_ID
						 AND CC.DIVISION_ID			= LM.DIVISION_ID
						 AND CC.SITE_ID				= LM.SITE_ID
						 AND CC.PLANT_ID			= LM.PLANT_ID
						 AND CC.FACTORY_ID			= LM.FACTORY_ID
						 AND CC.OPERATION			= LM.OPERATION_ID
						 AND CC.ITEM_ID				= PP.ITEM_ID
						 AND CC.PROD_VERSION_TYPE	= LM.PROD_VERSION_TYPE
				  LEFT  JOIN #SCM_MST_ITEM_SN IU WITH(NOLOCK)			-- 2025.03.20 CPS 소형 확산 : join 참조 추가
						  ON IU.ITEM_ID				= PP.ITEM_ID
						 AND IU.COMPANY_ID			= LM.COMPANY_ID
			WHERE 1=1
			  AND PP.PROD_YYYYMM BETWEEN SUBSTRING(PP.PROD_FROM_YYYYMM	,1,6) 
									 AND SUBSTRING(PP.PROD_TO_YYYYMM	,1,6) 
			GROUP BY AK.MDL_ALTER_KEY
					,AK.LN_ALTER_KEY 
					,PP.DIVISION_ID
					,PP.ITEM_ID			
					,LM.PLANT_ID
					,PP.LINE_ID
					,PP.OPERATION_ID
					,LM.COMPANY_ID
					,LM.SITE_ID
					,LM.FACTORY_ID	
					,PP.PROD_YYYYMM	
					,LQ.LANE_QTY
					,ISNULL(IU.ITEM_UOM, 'Z')			-- 2025.03.20 CPS 소형 확산 
					,ISNULL(CC.EA2JRM_CONV_VALUE, 1.)	-- 2025.03.20 CPS 소형 확산
			;
			 
			 
			-------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 전월 CAPA계획 SCP 생산계획 (전월UI 입력데이터 유지를 위해 참조)' 
			-- SCP생산계획 대상 기간이 아닌 미래 구간은 UI에서 입력 이후 계속 유지
			-- 해당 버전 포함 SCP생산계획 반영된 최종 버전 데이터를 참조한다. 
			-- SCP FN plan 재수행 결과 반영시 UI에서 추가 입력된 내용을 반영하기 위함.
			-------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#PRVS_SCP_PROD_PLAN') IS NOT NULL DROP TABLE #PRVS_SCP_PROD_PLAN; 

			;WITH PRVS_CAPA_VERSION AS ( 
				SELECT TOP 1 
						  ISNULL(VER_ID, '')		AS PRVS_VER_ID
						, ISNULL(VER_SEQ, 0)		AS PRVS_VER_SEQ
						, ISNULL(DIVISION_ID, '')	AS DIVISION_ID 
						, PROG_STAT
				 FROM SCP_MST_CAPA_VERSION PV WITH(NOLOCK)
				WHERE 1=1
				  AND DIVISION_ID = @V_DIVISION_ID				-- origin 사업부
				  AND PROG_STAT	  IN ('1', '2')					-- SCP생산계획 반영까지 완료된 이전 최종 버전 
				  AND ATTRIBUTE5	LIKE @V_EE_DIVISION_ID+'%'	-- 전극 SCP plan 반영된 정보가 존재
				ORDER BY VER_ID DESC
				       , VER_SEQ DESC 
			)
			SELECT LP.DIVISION_ID
				  ,LP.PLANT_ID
				  ,LP.LINE_ID
				  ,LP.OPERATION_ID
				  ,LP.ELTR_LN_TP_CD
				  ,LP.MDL_NM
				  ,LP.COMPANY_ID
				  ,LP.SITE_ID
				  ,LP.FACTORY_ID
				  ,LP.YYYYMM
				  ,CONVERT(FLOAT, LP.MSR_NVL)	AS MSR_NVL
				  ,LP.VER_ID
				  ,LP.VER_SEQ
			 INTO #PRVS_SCP_PROD_PLAN 
			 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF LP WITH(NOLOCK) 
				  INNER JOIN PRVS_CAPA_VERSION PV 
						  ON PV.PRVS_VER_ID		= LP.VER_ID
						 AND PV.PRVS_VER_SEQ	= LP.VER_SEQ
						 AND PV.DIVISION_ID		= LP.DIVISION_ID
			WHERE 1=1
			  AND MSR_TP_CD = 'SCP_PROD_PLAN'

			-------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 -신규 년월 구간 월목록'
			-- 2024.12.13 계획 시작년도 변경시 for 신규년월구간 생산계획 반영을 위해 추가
			-- 신규 년월 구간 (계획 시작년월 기준 Y+2) 
			-------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#NEW_YYYYMM') IS NOT NULL DROP TABLE #NEW_YYYYMM; 

			SELECT YYYY
				  ,YYYYMM	
				  ,CONVERT(FLOAT, COUNT(*))									AS YYYYMM_DDN
				  ,CONVERT(FLOAT, SUM(COUNT(*)) OVER (PARTITION BY 'A'))	AS YYYY_DDN
			  INTO #NEW_YYYYMM
			  FROM SCM_MST_BUCKET B WITH(NOLOCK)
			WHERE 1=1
			  AND YYYY						 = CONVERT(NVARCHAR(4), DATEADD(YEAR, 3, CONVERT(DATE, @V_VER_ID+'01', 112)), 112)  -- 버전기준 Y+3 (계획 시작년도 기준  Y+2) 
			  AND SUBSTRING(@V_VER_ID, 5, 2) = '12'																				-- 계획시작년월(01월) 년도 변경시 (12월 버전은 다음해 01월부터 계획 시작) 
			  AND @V_VER_SEQ				 = 1						
			GROUP BY YYYY
				    ,YYYYMM

			-------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 신규 년월 구간 생산계획 '
			-- 2024.12.13 계획 시작년도 변경시 for 신규년월구간 생산계획 반영을 위해 추가
			-- 년도 생산계획을 년월 구간으로 변환하여 추가 
			-- 년도 생산계획 / 해당년도 일수 * 해당월 일수
			-------------------------------------------------------------------------------------------------------------------------------------------
			 INSERT INTO #PRVS_SCP_PROD_PLAN (
						DIVISION_ID
					   ,PLANT_ID
					   ,LINE_ID
					   ,OPERATION_ID
					   ,ELTR_LN_TP_CD
					   ,MDL_NM
					   ,COMPANY_ID
					   ,SITE_ID
					   ,FACTORY_ID
					   ,YYYYMM
					   ,MSR_NVL
					   ,VER_ID
					   ,VER_SEQ
					) 
			 SELECT PP.DIVISION_ID	
				   ,PP.PLANT_ID
				   ,PP.LINE_ID
				   ,PP.OPERATION_ID
				   ,PP.ELTR_LN_TP_CD
				   ,PP.MDL_NM
				   ,PP.COMPANY_ID
				   ,PP.SITE_ID
				   ,PP.FACTORY_ID
				   ,NY.YYYYMM
				   ,CONVERT(FLOAT, PP.MSR_NVL) / NY.YYYY_DDN * NY.YYYYMM_DDN AS MSR_NVL 
				   ,PP.VER_ID
				   ,PP.VER_SEQ  
			   FROM #PRVS_SCP_PROD_PLAN PP
				    INNER JOIN #NEW_YYYYMM NY
							ON NY.YYYY = PP.YYYYMM
			  WHERE 1=1

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - SCP 생산계획 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
			SELECT  
				   PD.MDL_ALTER_KEY
				  ,PD.LN_ALTER_KEY
				  ,PD.MSR_GR_CD
				  ,'SCP_PROD_PLAN'								AS MSR_TP_CD
				  ,PD.YYYYMM
				  ,0.											AS PFRSLT_NVL
				  ,0.											AS BASE_NVL
				  ,ISNULL(ISNULL(PP.MSR_NVL, PV.MSR_NVL), 0.)	AS MSR_NVL	-- scp 생산 계획이 없는 구간은 전월 UI 입력 전월 최종 값으로 
				  ,NULL											AS MSR_DDN
			 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY PD WITH(NOLOCK)
				  INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK WITH(NOLOCK)
						  ON AK.MDL_ALTER_KEY = PD.MDL_ALTER_KEY
				  LEFT  JOIN #SCP_PROD_PLAN_VERSION  CV				-- 2024.12.13 
						  ON CV.ORIGIN_DIVISION_ID	= AK.DIVISION_ID
				  LEFT  JOIN #SCP_FINAL_PROD_PLAN PP  WITH(NOLOCK)  
						  ON PP.MDL_NM				= AK.MDL_NM
						 AND PP.PLANT_ID			= AK.PLANT_ID
						 AND PP.LINE_ID				= AK.LINE_ID
						 AND PP.DIVISION_ID			= AK.DIVISION_ID
						 AND PP.COMPANY_ID			= AK.COMPANY_ID
						 AND PP.SITE_ID				= AK.SITE_ID
						 AND PP.FACTORY_ID			= AK.FACTORY_ID
						 AND PP.OPERATION_ID		= AK.OPERATION_ID
						 AND PP.YYYYMM				= PD.YYYYMM 
				  LEFT  JOIN #PRVS_SCP_PROD_PLAN PV  WITH(NOLOCK) 
						  ON 1=1 
						 AND PV.MDL_NM				= AK.MDL_NM
						 AND PV.PLANT_ID			= AK.PLANT_ID
						 AND PV.LINE_ID				= AK.LINE_ID
						 AND PV.DIVISION_ID			= AK.DIVISION_ID
						 AND PV.COMPANY_ID			= AK.COMPANY_ID
						 AND PV.SITE_ID				= AK.SITE_ID
						 AND PV.FACTORY_ID			= AK.FACTORY_ID
						 AND PV.OPERATION_ID		= AK.OPERATION_ID
						 AND PV.YYYYMM				= PD.YYYYMM 
						 AND PV.YYYYMM				> ISNULL(CV.PROD_TO_YYYYMM,'')	-- 2024.12.13 SCP생산계획 이후 구간에 대해서 이전 버전에서 입력한 생산계획 반영지
			WHERE 1=1
			  AND PD.MSR_TP_CD = 'PROD_CAPA_D'

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 조업률 실적' -- 2024.08.14 추가
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#RESULT_AV_RT') IS NOT NULL DROP TABLE #RESULT_AV_RT;

			SELECT AK.MDL_ALTER_KEY
				  ,AK.LN_ALTER_KEY
				  ,AK.MDL_NM
				  ,LR.LOSS_RT
			 INTO #RESULT_AV_RT
			 FROM SCM_DNM_ELTR_LOSS_LN_MMLY LR WITH(NOLOCK)
				  INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK
					      ON AK.DIVISION_ID		= LR.DIVISION_ID
						 AND AK.COMPANY_ID		= LR.COMPANY_ID
						 AND AK.SITE_ID			= LR.SITE_ID
						 AND AK.PLANT_ID		= LR.PLANT_ID
						 AND AK.FACTORY_ID		= LR.FACTORY_ID
						 AND AK.LINE_ID			= LR.LINE_ID
						 AND AK.OPERATION_ID	= LR.OPERATION_ID
			WHERE 1=1
			  AND LR.LOSS_YM		= @V_RESULT_YYYYMM 
			  AND LR.PERD_DIVS_CD	= '3'		-- 3개월
			  AND LR.LOSS_CD		= 'AV_RT'	-- 조업률 

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' LOSS 모델별 Cutoff 생성 - 조업일수 추가 : AV_RT' 
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
				 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY  PC
					  INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM -- 2024.08.29 SOP 적용 
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
			INSERT #LOSS_MDL_CUTOFF_WITH_ALTER_KEY (
				   MDL_ALTER_KEY
				  ,LN_ALTER_KEY
				  ,MSR_GR_CD
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,PFRSLT_NVL
				  ,BASE_NVL
				  ,MSR_NVL
				  ,MSR_DDN
				  )
			SELECT AR.MDL_ALTER_KEY
				  ,AR.LN_ALTER_KEY 
				  ,AR.MSR_GR_CD
				  ,AR.MSR_TP_CD
				  ,AR.YYYYMM
				  ,ISNULL(R.LOSS_RT,  0.)					AS PFRSLT_NVL	  -- 조업률 실적(라인별 동일) 2024.08.14 수정
				  ,1.										AS BASE_NVL		  -- 모델별 Loss의 조업률은 100?.
				  ,ISNULL(AR.MSR_NVL, 0.)					AS MSR_NVL 
				  ,ISNULL(AR.MSR_DDN, 0.)					AS MSR_DDN 
			 FROM AV_RT AR
				  LEFT JOIN #RESULT_AV_RT R -- 2024.08.14 수정 
						 ON R.MDL_ALTER_KEY = AR.MDL_ALTER_KEY
						AND R.LN_ALTER_KEY	= AR.LN_ALTER_KEY
			WHERE 1=1

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
			  AND LOOKUP_TYPE = 'SCP_CAPA_ELTR_LOSS_MEASURE'	-- 전극 loss measure  
			  AND VALID_YN	  = 'Y'

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별 Current - 비조업 생성 ' 
			-------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#ELTR_LOSS_PLAN_LN') IS NOT NULL DROP TABLE #ELTR_LOSS_PLAN_LN

			SELECT AK.LN_ALTER_KEY
				  ,CONVERT(NVARCHAR(30),	LC.LOSS_GR_CD)				AS MSR_GR_CD 
				  ,CONVERT(NVARCHAR(30),	LC.LOSS_CD	)				AS MSR_TP_CD
				  ,YM.YYYYMM
				  ,CONVERT(NUMERIC(20,10),	ISNULL(NA.MSR_NVL, 0))		AS MSR_NVL
				  -- 2024.10.23 ,CONVERT(NUMERIC(20,10),	ISNULL(NA.MSR_DDN, NULL))	AS MSR_DDN
			  INTO #ELTR_LOSS_PLAN_LN
			  FROM #LOSS_CODE_INFO LC 
				   INNER JOIN #ELTR_ALTER_KEY_INFO_LN AK
						   ON 1=1 
				   INNER JOIN #YYYYMM_DAYS_INFO YM
						   ON 1=1 
				   LEFT JOIN SCP_MST_CAPA_ELTR_LOSS_PLAN_LN NA WITH(NOLOCK) 
						   ON NA.DIVISION_ID	= AK.DIVISION_ID
						  AND NA.PLANT_ID		= AK.PLANT_ID
						  AND NA.LINE_ID		= AK.LINE_ID
						  AND NA.OPERATION_ID	= AK.OPERATION_ID
						  AND NA.COMPANY_ID		= AK.COMPANY_ID
						  AND NA.SITE_ID		= AK.SITE_ID
						  AND NA.FACTORY_ID		= AK.FACTORY_ID
						  AND NA.MSR_TP_CD		= LC.LOSS_CD
						  AND NA.YYYYMM			= YM.YYYYMM
						  AND NA.MSR_GR_CD		= 'NAV'  -- 비조업 (기등록 Current Data가 있으면 그대로 등록) 
			 WHERE 1=1
			   AND LC.LOSS_GR_CD = 'NAV'	-- 비조업
			   AND LC.LOSS_CD	!= 'WT_RT'	-- 물동없음 주문대기

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별 Current - 비조업 생성 - 조업일수 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				  ,'AV'				AS MSR_GR_CD
				  ,'AV_DDN'			AS MSR_TP_CD
				  ,LS.YYYYMM
				  ,SUM(LS.MSR_DDN)	AS MSR_NVL
				  -- 2024.10.23,SUM(LS.MSR_DDN)	AS MSR_DDN
			 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY LS
			WHERE 1=1
			  AND LS.MSR_TP_CD = 'AV_RT' 
			GROUP BY LS.LN_ALTER_KEY
					,LS.YYYYMM 
			   
			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별 Current - 비조업 생성 - WT_RT : 물동없음(주문대기) 추가' 
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN
			SELECT LS.LN_ALTER_KEY
				 ,'NAV'			AS MSR_GR_CD
				 ,'WT_RT'		AS MSR_TP_CD
				 ,LS.YYYYMM
				 ,YM.YYYYMM_DDN - CONVERT(FLOAT, ISNULL(SUM(LS.MSR_NVL), 0))	AS MSR_NVL
				 -- 2024.10.23,YM.YYYYMM_DDN - CONVERT(FLOAT, ISNULL(SUM(LS.MSR_NVL), 0))	AS MSR_DDN	
			 FROM #ELTR_LOSS_PLAN_LN LS
				  INNER JOIN #YYYYMM_DAYS_INFO_APPLIED_SOP YM -- 2024.08.29 SOP적용 
						  ON 1=1 
						 AND YM.YYYYMM			= LS.YYYYMM
						 AND YM.LN_ALTER_KEY	= LS.LN_ALTER_KEY
			WHERE 1=1
			  AND LS.MSR_GR_CD IN ('NAV', 'AV') 
			GROUP BY LS.LN_ALTER_KEY
					,LS.YYYYMM
					,YM.YYYYMM_DDN 
			  
			--------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'전극 Line Assign -  #SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF '  -- 2024.08.09 추가
			--------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF;
			SELECT  
			       LA.DIVISION_ID
				  ,LA.COMPANY_ID
				  ,LA.SITE_ID
				  ,LA.PLANT_ID
				  ,LA.FACTORY_ID
				  ,LA.LINE_ID
				  ,LA.OPERATION_ID
				  ,LA.ITEM_ID AS MDL_NM
				  ,LA.YYYYMM
			 INTO #SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
			 FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF LA WITH(NOLOCK) 
			WHERE 1=1
			  AND LA.VER_ID		 = @V_VER_ID
			  AND LA.VER_SEQ	 = @V_VER_SEQ
			  AND LA.DIVISION_ID = @V_DIVISION_ID  
			  AND LA.VALID_YN	 = 'Y'  
			  AND ISNULL(LA.ASSIGN_PRIORITY, 0) != 0

			----------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별 Current - 비조업 추가 (BASE) -- 2차 컷오프시 base포함 비조업 cutff ' 
			----------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #ELTR_LOSS_PLAN_LN(
				   LN_ALTER_KEY
				  ,MSR_GR_CD
				  ,MSR_TP_CD
				  ,YYYYMM
				  ,MSR_NVL
				  -- 2024.10.23,MSR_DDN
				)
			SELECT DISTINCT 
				   LT.LN_ALTER_KEY
				  ,LT.MSR_GR_CD
				  ,LT.MSR_TP_CD
				  ,'BASE'	AS YYYYMM
				  ,0.		AS MSR_NVL
				  -- 2024.10.23,0.		AS MSR_DDN
			 FROM #ELTR_LOSS_PLAN_LN LT
				  INNER JOIN #ELTR_ALTER_KEY_INFO_LN AK  -- 8/12 수정
						  ON AK.LN_ALTER_KEY = LT.LN_ALTER_KEY
			WHERE 1=1
			  AND LT.MSR_GR_CD  = 'NAV' -- 비조업 
			  AND EXISTS (SELECT 1 -- 8/12 수정
						   FROM  #SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF LA 
						  WHERE 1=1
							AND LA.DIVISION_ID		= AK.DIVISION_ID
							AND LA.COMPANY_ID		= AK.COMPANY_ID
							AND LA.SITE_ID			= AK.SITE_ID
							AND LA.PLANT_ID			= AK.PLANT_ID
							AND LA.FACTORY_ID		= AK.FACTORY_ID
							AND LA.LINE_ID			= AK.LINE_ID
							AND LA.OPERATION_ID		= AK.OPERATION_ID
							AND LA.DIVISION_ID		= AK.DIVISION_ID
							) 

		------- Begin Tran : =======================================================================================
		------- Begin Tran : =======================================================================================

		  BEGIN TRAN   --- transaction 시작  

			---------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 Loss 모델별 Cutoff - DELETE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF (SCP생산계획/조업일)' 
			---------------------------------------------------------------------------------------------------------------------------------------
			DELETE LS
			FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF  LS WITH(NOLOCK)
			WHERE 1=1
			  AND LS.VER_ID		 = @V_VER_ID
			  AND LS.VER_SEQ	 = @V_VER_SEQ
			  AND LS.DIVISION_ID = @V_DIVISION_ID
			  AND (LS.MSR_TP_CD   = 'SCP_PROD_PLAN'							-- SCP 생산계획
					OR
				   (LS.MSR_TP_CD   = 'AV_RT' AND  LS.MDL_NM		!= '-')		-- (모델별) 조업률/조업일수
				   )   

			---------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 Loss 모델별 Cutoff - INSERT SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF (SCP생산계획/조업일)' 
			---------------------------------------------------------------------------------------------------------------------------------------
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
				-- 2025.02.05 개선/목표일 관리 기능 삭제,IPRV_GOL_DIVS_CD
				-- 2025.02.05 개선/목표일 관리 기능 삭제,IPRV_GOL_RT
				,MSR_GR_CD
				,MSR_NVL	
				,MSR_DDN
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
			SELECT @V_VER_ID			AS VER_ID
				  ,@V_VER_SEQ  			AS V_VER_SEQ  
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
				  -- 2025.02.05 개선/목표일 관리 기능 삭제,NULL					AS IPRV_GOL_DIVS_CD
				  -- 2025.02.05 개선/목표일 관리 기능 삭제,NULL					AS IPRV_GOL_RT
				  ,'-'					AS MSR_GR_CD
				  ,MC.MSR_NVL	
				  ,MC.MSR_DDN
				  ,@v_program_name		AS CREATED_BY
				  ,getdate()			AS CREATION_DATE
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,getdate()			AS LAST_UPDATE_DATE 
			 FROM #LOSS_MDL_CUTOFF_WITH_ALTER_KEY MC 
				  INNER JOIN #ALTER_KEY_INFO_FOR_MDL AK
						  ON AK.MDL_ALTER_KEY = MC.MDL_ALTER_KEY
				  INNER JOIN #SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF LA -- 2024.08.09 line assign된 구간 데이터만 반영 
						  ON 1=1
						 AND LA.DIVISION_ID		= AK.DIVISION_ID
						 AND LA.COMPANY_ID		= AK.COMPANY_ID
						 AND LA.SITE_ID			= AK.SITE_ID
						 AND LA.PLANT_ID		= AK.PLANT_ID
						 AND LA.FACTORY_ID		= AK.FACTORY_ID
						 AND LA.LINE_ID			= AK.LINE_ID
						 AND LA.OPERATION_ID	= AK.OPERATION_ID
						 AND LA.MDL_NM			= AK.MDL_NM
						 AND LA.YYYYMM			= MC.YYYYMM
			WHERE 1=1
			  AND (MC.MSR_TP_CD   = 'SCP_PROD_PLAN'							-- SCP 생산계획
					OR
				   (MC.MSR_TP_CD   = 'AV_RT' AND  AK.MDL_NM		!= '-')		-- (모델별) 조업률/조업일수
				  )   

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별  - DELETE  SCP_MST_CAPA_ELTR_LOSS_PLAN_LN ' 
			---------------------------------------
			-- DELETE SCP_MST_CAPA_ELTR_LOSS_PLAN_LN
			-- 비조업 다시 등록 
			-----------------------------------------------------------------------------------------------------------------
			DELETE FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_LN 
			 WHERE 1=1
			   AND DIVISION_ID	= @V_DIVISION_ID

			-------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 LOSS 라인별  - INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_LN ' 
			-----------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_LN (
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
				  ,NULL					AS MSR_DDN -- 2024.10.23 null처리 LT.MSR_DDN
				  ,@v_program_name		AS CREATED_BY
				  ,GETDATE()			AS CREATION_DATE 
				  ,@v_program_name		AS LAST_UPDATED_BY
				  ,GETDATE()			AS LAST_UPDATE_DATE 
			 FROM #ELTR_LOSS_PLAN_LN LT
				  INNER JOIN #ELTR_ALTER_KEY_INFO_LN AK
						  ON AK.LN_ALTER_KEY = LT.LN_ALTER_KEY
			WHERE 1=1
			  AND MSR_GR_CD = 'NAV' -- 비조업 
			  AND ( LT.YYYYMM = 'BASE'  -- 2024/8/12 BASE 누락 오류 수정
					OR
					EXISTS (SELECT 1
						   FROM  #SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF LA -- 2024.08.09 line assign된 구간 데이터만 반영 
						  WHERE 1=1
							AND LA.DIVISION_ID		= AK.DIVISION_ID
							AND LA.COMPANY_ID		= AK.COMPANY_ID
							AND LA.SITE_ID			= AK.SITE_ID
							AND LA.PLANT_ID			= AK.PLANT_ID
							AND LA.FACTORY_ID		= AK.FACTORY_ID
							AND LA.LINE_ID			= AK.LINE_ID
							AND LA.OPERATION_ID		= AK.OPERATION_ID
							AND LA.DIVISION_ID		= AK.DIVISION_ID
							AND LA.YYYYMM			= LT.YYYYMM) 
				)


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

			-------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' SCP Prod Plan 적용 버전 정보 update ' 
			-------------------------------------------------------------------------------------------------------------------------
			UPDATE CV SET ATTRIBUTE5			= PP.DIVISION_ID + '::' + PP.PLAN_TYPE + '::' + CONVERT(NVARCHAR(20), PP.PLAN_SEQ) + '::' + PP.PLAN_START_YYYYMMDD
						 ,LAST_UPDATED_BY		= @v_program_name
	 					 ,LAST_UPDATE_DATE		= GETDATE() 
						 ,ATTRIBUTE6			= N'[PROG_STAT:1:전극SCP_PROD_PLAN]'+CONVERT(NVARCHAR(100), GETDATE(), 25) --- select *
			 FROM SCP_MST_CAPA_VERSION CV WITH(NOLOCK)
				  LEFT JOIN #SCP_PROD_PLAN_VERSION  PP
						 ON PP.ORIGIN_DIVISION_ID = CV.DIVISION_ID
			WHERE 1=1
			  AND CV.VER_ID			=  @V_VER_ID
			  AND CV.VER_SEQ		=  @V_VER_SEQ
			  AND CV.DIVISION_ID	=  @V_DIVISION_ID


		  COMMIT TRAN ;  --- transaction 종료  


		------- End Tran : ==========================================================================================================
		------- End Tran : ==========================================================================================================

			SET @v_log_type = 'TXN';
			SET @v_log_message = 'END - '+@v_division_id;     
			SET @v_description = '['+ @v_division_id + '::' + @V_VER_ID + '::' + CONVERT(NVARCHAR(10), @V_VER_SEQ) +  ']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
			SET @v_log_message = NULL 


			FETCH NEXT FROM CAPA_VER_DATA INTO @V_EE_DIVISION_ID
											  ,@V_DIVISION_ID		-- origin division_id 
											  ,@V_VER_ID
											  ,@V_VER_SEQ

        END  ----- // WHILE @@FETCH_STATUS = 0
		
        CLOSE CAPA_VER_DATA ;
        DEALLOCATE CAPA_VER_DATA;   -- 메모리 해제

	  END ----- // IF @V_IS_MANUAL = 'Y' OR 마지막주차 목요일이 포함된 주차 화요일부터 금요일 


		-----------------------------------------
		------ 임시테이블 정리
		-------------------------------------------
		IF OBJECT_ID('TEMPDB..#Batch_Date_Info') IS NOT NULL DROP TABLE #Batch_Date_Info;
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF;
		IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO;
		IF OBJECT_ID('TEMPDB..#ALTER_KEY_INFO_FOR_MDL') IS NOT NULL DROP TABLE #ALTER_KEY_INFO_FOR_MDL
		IF OBJECT_ID('TEMPDB..#ELTR_ALTER_KEY_INFO_LN') IS NOT NULL DROP TABLE #ELTR_ALTER_KEY_INFO_LN
		IF OBJECT_ID('TEMPDB..#LOSS_MDL_CUTOFF_WITH_ALTER_KEY') IS NOT NULL DROP TABLE #LOSS_MDL_CUTOFF_WITH_ALTER_KEY
		IF OBJECT_ID('TEMPDB..#SCM_MST_EQUIPMENT_SN') IS NOT NULL DROP TABLE #SCM_MST_EQUIPMENT_SN;
		IF OBJECT_ID('TEMPDB..#LINE_ASSIGN_LANE_QTY') IS NOT NULL DROP TABLE #LINE_ASSIGN_LANE_QTY; 
		IF OBJECT_ID('TEMPDB..#SCP_PROD_PLAN_VERSION') IS NOT NULL DROP TABLE #SCP_PROD_PLAN_VERSION; 
		IF OBJECT_ID('TEMPDB..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL DROP TABLE #SCP_ANL_PRODUCTION_PLAN; 
		IF OBJECT_ID('TEMPDB..#SCM_MST_ITEM_CONV_CALC_SN') IS NOT NULL DROP TABLE #SCM_MST_ITEM_CONV_CALC_SN;
		IF OBJECT_ID('TEMPDB..#SCP_FINAL_PROD_PLAN') IS NOT NULL DROP TABLE #SCP_FINAL_PROD_PLAN;
		IF OBJECT_ID('TEMPDB..#PRVS_SCP_PROD_PLAN') IS NOT NULL DROP TABLE #PRVS_SCP_PROD_PLAN; 
		IF OBJECT_ID('TEMPDB..#LOSS_CODE_INFO') IS NOT NULL DROP TABLE #LOSS_CODE_INFO
		IF OBJECT_ID('TEMPDB..#ELTR_LOSS_PLAN_LN') IS NOT NULL DROP TABLE #ELTR_LOSS_PLAN_LN
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_ELTR_LINE_SOP') IS NOT NULL DROP TABLE #SCP_MST_CAPA_ELTR_LINE_SOP
		IF OBJECT_ID('TEMPDB..#YYYYMM_DAYS_INFO_APPLIED_SOP') IS NOT NULL DROP TABLE #YYYYMM_DAYS_INFO_APPLIED_SOP
		IF OBJECT_ID('TEMPDB..#SCM_MST_SITE') IS NOT NULL DROP TABLE #SCM_MST_SITE;



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
	SET @v_description = '[DIVISION_ID=' + ISNULL(@P_EE_DIVISION_ID, 'ALL')  +'][' + @v_exec_time + ']';  ;
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
