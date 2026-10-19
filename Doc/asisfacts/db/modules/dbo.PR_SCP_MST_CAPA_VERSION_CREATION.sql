
/*  
 * Program ID   : PR_SCP_MST_CAPA_VERSION_CREATION
 * Description  : Division별 Capa 버전 일괄 생성 프로시저
 *				 
 *			### Source Table 
 *				SCP_MST_CAPA_VERSION			(Capa 버전정보) 
 *				-- 조립 Current
 *				SCP_MST_CAPA_LINE_ASSIGN		(라인할당 Current)
 *				SCP_MST_CAPA_SPEED_PLAN			(Speed계획 Current)
 *				SCP_MST_CAPA_LOSS_PLAN_MDL		(모델별Loss Plan Current)
 *				SCP_MST_CAPA_LOSS_PLAN_LN		(라인별Loss Plan Current)
 *				-- 전극 Current 
 *				SCP_MST_CAPA_ELTR_LINE_ASSIGN	(전극 라인할당 Current)
 *				SCP_MST_CAPA_ELTR_SPEED_PLAN	(전극 Speed계획 Current)
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL	(전극 모델별Loss Plan Current)
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_LN	(전극 라인별Loss Plan Current)
 *
 *			### Target Table 
 *				SCP_MST_CAPA_VERSION			(Capa 버전 *				-- 조립 Current
 *				SCP_MST_CAPA_LINE_ASSIGN		(라인할당 Current)
 *				SCP_MST_CAPA_SPEED_PLAN			(Speed계획 Current)
 *				SCP_MST_CAPA_LOSS_PLAN_MDL		(모델별Loss Plan Current)
 *				SCP_MST_CAPA_LOSS_PLAN_LN		(라인별Loss Plan Current)
 *				-- 조립 백업
 *				SCP_MST_CAPA_LINE_ASSIGN_B		(라인할당 삭제데이터 백업)
 *				SCP_MST_CAPA_SPEED_PLAN_B		(Speed계획 삭제데이터 백업)
 *				SCP_MST_CAPA_LOSS_PLAN_MDL_B	(모델별Loss Plan 삭제데이터 백업)
 *				SCP_MST_CAPA_LOSS_PLAN_LN_B		(라인별Loss Plan 삭제데이터 백업)
 *				-- 전극 Current
 *				SCP_MST_CAPA_ELTR_LINE_ASSIGN	(전극 라인할당 Current)
 *				SCP_MST_CAPA_ELTR_SPEED_PLAN	(전극 Speed계획 Current)
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL	(전극 모델별Loss Plan Current)
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_LN	(전극 라인별Loss Plan Current)
 *				-- 전극 백업
 *				SCP_MST_CAPA_ELTR_LINE_ASSIGN_B		(전극 라인할당 삭제데이터 백업)
 *				SCP_MST_CAPA_ELTR_SPEED_PLAN_B		(전극 Speed계획 삭제데이터 백업)
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_B	(전극 모델별Loss Plan 삭제데이터 백업)
 *				SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_B	(전극 라인별Loss Plan 삭제데이터 백업)정보) 

 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.04.30	hrkim		Initial Release PJ2024-50026 / LGES2024-002455   Capa. 관리 시스템 구축  
 * 2024.05.07	hrkim		버전(VER_ID) 기준 plan 시작 년월 조정 
 * 2024.05.29	hrkim		계획 시작년도 바뀔시 신규 년월/년도 데이터 생성로직 변경
 *							년->년월 : 해당 년도 데이터를 12개월 동일하게 생성 (Capa/12)
 *							신규년도 : 빈값으로 생성  
 * 2024.06.07	hrkim		전극 추가
 * 2024.06.10	hrkim		전극 Line Assign - Lane Qty 추가 
 * 2024.12.05	hrkim		LGES2024-002655 SCP 개선과제 이행 
 *							 : 계획시작년도 변경시 신규 개선/목표 입력 구간데이터(Y2->Y1) 운영계획 기준으로 개선/목표율 역계산 적용 
 * 2024.12.09	hrkim		LGES2024-002655 SCP 개선과제 이행 
 *							 1. 신규년월 월Capa 로직 변경
 *								- 변경전 : 년도Capa / 12
 *								- 변경후 : 일Capa * 해당년월일수(SOP적용) 
 *
 *							 2. 신규년도 빈 값으로 생성 (line assign 0, speed/loss 데이터 생성 안함) 
 * 2025.02.06	hrkim		개선/목표율 관리 기능 삭제 - 해당 컬럼 참조 소스 삭제 (IPRV_GOL_DIVS_CD/IPRV_GOL_RT)
 * 2025.03.18	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 * 2025.06.12   KIMCD       PJ2024A332   독립적 Planning 체계 및 Master Validation UI 구축
 */  

CREATE PROCEDURE  [dbo].[PR_SCP_MST_CAPA_VERSION_CREATION]
	 @P_DIVISION_ID		NVARCHAR(50)	=  NULL
	,@P_BASIS_YYYYMM	NVARCHAR(06)	=  NULL
AS

BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE @V_DIVISION_ID   NVARCHAR(50)	= @P_DIVISION_ID	;
	DECLARE @V_BASIS_YYYYMM  NVARCHAR(06)	= @P_BASIS_YYYYMM	;

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_CAPA_VERSION_CREATION'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	BEGIN TRY
	  BEGIN

		PRINT '------------------------------------------------------------------';
		PRINT '@V_DIVISION_ID		= ' + ISNULL(@V_DIVISION_ID, 'ALL');
		PRINT '@V_BASIS_YYYYMM		= ' + ISNULL(@V_BASIS_YYYYMM, '');
		PRINT '------------------------------------------------------------------';

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '[division_id='+ ISNULL(@v_division_id , 'ALL')+ '][BASIS_YYYYMM='+ ISNULL(@V_BASIS_YYYYMM , '')+ ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 다음 Plan 버전 정보 - #NEXT_VER_PERIOD' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#NEXT_VER_PERIOD') IS NOT NULL DROP TABLE #NEXT_VER_PERIOD; 

		;WITH BASIS_DATE AS (
			  SELECT CASE WHEN ISNULL(@V_BASIS_YYYYMM, 'Z') = 'Z' 
						  THEN GETDATE() 
						  ELSE CONVERT(DATE, @V_BASIS_YYYYMM+'01', 112) 
					  END AS BASIS_DATE 
		) , TODAY_INFO AS (
			SELECT BASIS_DATE												AS TODAY
				  ,CONVERT(NVARCHAR(6), DATEADD(MM, -1, BASIS_DATE), 112)	AS YYYYMM_PRVS
				  ,CONVERT(NVARCHAR(6), DATEADD(MM, +1, BASIS_DATE), 112)	AS YYYYMM_NEXT
				  ,CONVERT(NVARCHAR(6), BASIS_DATE, 112)					AS YYYYMM
				  ,CONVERT(NVARCHAR(6), DATEADD(MM, +1, BASIS_DATE), 112)	AS YYYYMM_START
				  ,CONVERT(NVARCHAR(6), DATEADD(MM, +2, BASIS_DATE), 112)	AS YYYYMM_NEXT_START
				  ,DATEPART(DD, BASIS_DATE)									AS DD
			 FROM BASIS_DATE
		) , NEXT_VER_INFO AS (
			SELECT CASE WHEN DD < 15	-- 현시점 기준 전월 2차 컷오프인 경우 (컷오프 대상 년월의 기준 마지막 목요일 이후 첫 일요일이 Next Month인 경우) 
						THEN YYYYMM 
						ELSE YYYYMM_NEXT 
					END AS NEXT_VER_ID  
				  ,CASE WHEN DD < 15	-- 현시점 기준 전월 2차 컷오프인 경우 (컷오프 대상 년월의 기준 마지막 목요일 이후 첫 일요일이 Next Month인 경우) 
						THEN YYYYMM_START
						ELSE YYYYMM_NEXT_START 
					END AS START_YM 
			FROM TODAY_INFO
		), NEXT_VER_PERIOD AS (
		SELECT NEXT_VER_ID
			 , START_YM																				AS START_YM
			 , START_YM																				AS FROM_YM
			 , CONVERT(NVARCHAR(4), DATEADD(YY, 2, CONVERT(DATE, START_YM+'01', 112)),112) + '12'	AS TO_YM 
			 , CONVERT(NVARCHAR(4), DATEADD(YY, 3, CONVERT(DATE, START_YM+'01', 112)),112) 			AS FROM_YY 
			 , CONVERT(NVARCHAR(4), DATEADD(YY, 5, CONVERT(DATE, START_YM+'01', 112)),112) 			AS TO_YY 
		  FROM NEXT_VER_INFO
		), LAST_VERSION_INFO AS (
			SELECT CV.DIVISION_ID
				  ,CV.VER_ID
				  ,CV.VER_SEQ
				  ,CV.VER_SEQ + 1 AS NEXT_VER_SEQ
				  ,ROW_NUMBER() OVER (PARTITION BY CV.DIVISION_ID
										  ORDER BY CV.VER_ID	DESC
												  ,CV.VER_SEQ	DESC ) AS RN 
				  ,CV.PROG_STAT 
			  FROM SCP_MST_CAPA_VERSION CV WITH(NOLOCK)
			 WHERE 1=1
			   AND CV.VER_ID     <= CASE WHEN @V_BASIS_YYYYMM IS NULL OR @V_BASIS_YYYYMM = '' THEN
			                                  CV.VER_ID
									     ELSE @V_BASIS_YYYYMM END -- 2025.06.12 kimcd 과거 월 채번 가능하도록 로직 보완
			   AND CV.DIVISION_ID = CASE WHEN ISNULL(@V_DIVISION_ID,'') = ''
										 THEN CV.DIVISION_ID
										 ELSE @V_DIVISION_ID
									END
		)
		SELECT VI.*
			  ,CASE WHEN SUBSTRING(START_YM, 5, 2) = '01' 
					THEN CONVERT(NVARCHAR(4), DATEADD(YY, -1, CONVERT(DATE, TO_YY+'0101', 112)), 112)
					ELSE ''
				END AS COPY_FROM_YY
			  ,CASE WHEN SUBSTRING(START_YM, 5, 2) = '01' 
					THEN CONVERT(NVARCHAR(4), DATEADD(YY, -1, CONVERT(DATE, FROM_YY+'0101', 112)), 112)
					ELSE ''
				END AS TO_DELETE_YY
				-----  begin 2024.12.05 LGES2024-002655 SCP 개선과제 이행 : 개선/목표율 역계산 적용 
			  ,CASE WHEN SUBSTRING(START_YM, 5, 2) = '01' 
					THEN CONVERT(NVARCHAR(6), DATEADD(YY, +1, CONVERT(DATE, START_YM+'01', 112)), 112)
					ELSE ''
				END AS IG_CAL_FROM_YM
			  ,CASE WHEN SUBSTRING(START_YM, 5, 2) = '01' 
					THEN CONVERT(NVARCHAR(6), DATEADD(YY, -1, CONVERT(DATE, TO_YM+'01', 112)), 112)
					ELSE ''
				END AS IG_CAL_TO_YM
				-----  End   2024.12.05 LGES2024-002655 SCP 개선과제 이행 : 개선/목표율 역계산 적용 
			  ,DM.DIVISION_ID
			  ,CASE WHEN CV.VER_ID = VI.NEXT_VER_ID
					THEN CV.NEXT_VER_SEQ
					ELSE 1				
				END				AS NEXT_VER_SEQ
		 INTO #NEXT_VER_PERIOD
		 FROM NEXT_VER_PERIOD VI
			  INNER JOIN SCM_MST_DIVISION  DM WITH(NOLOCK)
					  ON 1=1
			  LEFT  JOIN LAST_VERSION_INFO CV WITH(NOLOCK) 
					  ON CV.RN = 1
					 AND CV.DIVISION_ID = DM.DIVISION_ID
		WHERE 1=1
		  AND DM.ATTRIBUTE3 != 'EE' -- 전극 제외 (2025.03.18 소형 확산)
		  AND DM.VALID_YN	= 'Y'
		  AND DM.DIVISION_ID = CASE WHEN ISNULL(@V_DIVISION_ID,'') = ''
									THEN DM.DIVISION_ID
									ELSE @V_DIVISION_ID
								END
		  AND ISNULL(CV.PROG_STAT,'') NOT IN ('-', '0', '1') -- 최종 버전이 진행중인 경우 제외.


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 신규 년월 목록 (년도 to 년월) ' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#NEW_YYYYMM_LIST') IS NOT NULL DROP TABLE #NEW_YYYYMM_LIST; 

		SELECT DISTINCT 
			  YYYYMM	AS TO_YYYYMM
			, YYYY		AS COPY_FROM_YYYY
			, CONVERT(FLOAT, DATEDIFF(DD, CONVERT(DATE, YYYYMM+'01', 112)
										, DATEADD(MM, 1, CONVERT(DATE, YYYYMM+'01', 112))
										))	AS YYYYMM_DAYS		-- 20241209 추가 월일수
		 INTO #NEW_YYYYMM_LIST
		 FROM SCM_MST_BUCKET B WITH(NOLOCK)
		WHERE YYYY = (SELECT TOP 1 TO_DELETE_YY FROM #NEXT_VER_PERIOD)


	IF EXISTS (SELECT TOP 1 * FROM #NEXT_VER_PERIOD) --- 생성 대상 버전이 존재하는 경우만 실행 
	BEGIN 

		------- Begin Tran : =======================================================================================
		------- Begin Tran : =======================================================================================
		------- Begin Tran : =======================================================================================
		------- Begin Tran : =======================================================================================

	  BEGIN TRAN   --- transaction 시작  

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'Start - SCP_MST_CAPA_VERSION -- 신규버전 등록 : '+ ISNULL(@v_division_id, 'ALL DIVISION');     
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 다음 Plan 버전 생성 - 진행상태 : Pre (Init) : 실적마감전' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_VERSION ( DIVISION_ID
										 , VER_ID
										 , VER_SEQ
										 , PROG_STAT
										 , CREATED_BY
										 , CREATION_DATE
										 , LAST_UPDATED_BY
										 , LAST_UPDATE_DATE 
										 , ATTRIBUTE1	-- from yyyymm
										 , ATTRIBUTE2	-- to	yyyymm
										 , ATTRIBUTE3	-- from yyyy
										 , ATTRIBUTE4	-- to	yyyy
										 ) 
		SELECT VI.DIVISION_ID
			  ,VI.NEXT_VER_ID	AS VER_ID
			  ,VI.NEXT_VER_SEQ	AS VER_SEQ
			  ,'-'				AS PROG_STAT
			  ,@v_program_name	AS CREATED_BY
			  ,GETDATE()		AS CREATION_DATE
			  ,@v_program_name	AS LAST_UPDATED_BY
			  ,GETDATE()		AS LAST_UPDATE_DATE
			  ,VI.FROM_YM		AS ATTRIBUTE1
			  ,VI.TO_YM			AS ATTRIBUTE2
			  ,VI.FROM_YY		AS ATTRIBUTE3
			  ,VI.TO_YY			AS ATTRIBUTE4 
		 FROM #NEXT_VER_PERIOD VI 
		WHERE 1=1


		----------------------- SPEED PLAN  --- SCP_MST_CAPA_SPEED_PLAN -- 백업/추가/삭제 (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 
		----------------------- SPEED PLAN  --- SCP_MST_CAPA_SPEED_PLAN -- 백업/추가/삭제 (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'Start - SCP_MST_CAPA_SPEED_PLAN -- 백업/추가/삭제' + ISNULL(@v_division_id, 'ALL DIVISION');     
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

 		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 삭제전 백업 SCP_MST_CAPA_SPEED_PLAN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_SPEED_PLAN_B (  
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
				 ,LAST_UPDATE_DATE )
		SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_SPEED_PLAN_B AS HISTORY_SEQ 
			 ,GETDATE()	AS HISTORY_CREATION_DATE
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
			 ,SP.CREATED_BY
			 ,SP.CREATION_DATE
			 ,SP.LAST_UPDATED_BY
			 ,SP.LAST_UPDATE_DATE
		 FROM SCP_MST_CAPA_SPEED_PLAN SP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = SP.DIVISION_ID
					  AND (SP.YYYYMM = VP.TO_DELETE_YY 
					       OR 
						   SP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		  AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Insert Into  SCP_MST_CAPA_SPEED_PLAN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_SPEED_PLAN ( 
			  DIVISION_ID
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
			 ,LAST_UPDATE_DATE )
		 -- 신규 년월 데이터 
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
			   ,NY.TO_YYYYMM
			   ,SP.BASE_QTY
			   ,SP.QTY
			   ,SP.UI_UPD_YN
			   ,SP.REMARK
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
		  FROM SCP_MST_CAPA_SPEED_PLAN SP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= SP.DIVISION_ID
					  AND VP.TO_DELETE_YY	= SP.YYYYMM 
				INNER JOIN #NEW_YYYYMM_LIST NY 
					   ON NY.COPY_FROM_YYYY = SP.YYYYMM 
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' DELETE  SCP_MST_CAPA_SPEED_PLAN ' 
		-------------------------------------------------------------------------------------------------------------------
	
		DELETE SP
		 FROM SCP_MST_CAPA_SPEED_PLAN SP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = SP.DIVISION_ID
					  AND (SP.YYYYMM = VP.TO_DELETE_YY 
					       OR 
						   SP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		  AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		----------------------- LOSS PLAN (모델별) -- SCP_MST_CAPA_LOSS_PLAN_MDL -- 백업/추가/삭제   (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 
		----------------------- LOSS PLAN (모델별) -- SCP_MST_CAPA_LOSS_PLAN_MDL -- 백업/추가/삭제   (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'Start - SCP_MST_CAPA_LOSS_PLAN_MDL -- 백업/추가/삭제'  + ISNULL(@v_division_id, 'ALL DIVISION'); 
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

 		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 삭제전 백업 SCP_MST_CAPA_LOSS_PLAN_MDL ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_LOSS_PLAN_MDL_B (  
				  HISTORY_SEQ
				 ,HISTORY_CREATION_DATE
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
				 ,PFRSLT_NVL
				 ,BASE_NVL
				 -- 2025.02.06 개선/목표일 관리 기능 삭제,IPRV_GOL_DIVS_CD
				 -- 2025.02.06 개선/목표일 관리 기능 삭제,IPRV_GOL_RT
				 ,MSR_GR_CD
				 ,MSR_NVL
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
				 ,ATTRIBUTE9
				 ,ATTRIBUTE10)
		SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_LOSS_PLAN_MDL_B AS HISTORY_SEQ 
			  ,GETDATE()										AS HISTORY_CREATION_DATE
			  ,LP.DIVISION_ID
			  ,LP.PLANT_ID
			  ,LP.LINE_ID
			  ,LP.OPERATION_ID
			  ,LP.ELTR_LN_TP_CD
			  ,LP.MDL_NM
			  ,LP.COMPANY_ID
			  ,LP.SITE_ID
			  ,LP.FACTORY_ID
			  ,LP.MSR_TP_CD
			  ,LP.YYYYMM
			  ,LP.PFRSLT_NVL
			  ,LP.BASE_NVL
			  -- 2025.02.06 개선/목표일 관리 기능 삭제,LP.IPRV_GOL_DIVS_CD
			  -- 2025.02.06 개선/목표일 관리 기능 삭제,LP.IPRV_GOL_RT
			  ,LP.MSR_GR_CD
			  ,LP.MSR_NVL
			  ,LP.CREATED_BY
			  ,LP.CREATION_DATE
			  ,LP.LAST_UPDATED_BY
			  ,LP.LAST_UPDATE_DATE
			  ,LP.ATTRIBUTE1
			  ,LP.ATTRIBUTE2
			  ,LP.ATTRIBUTE3
			  ,LP.ATTRIBUTE4
			  ,LP.ATTRIBUTE5
			  ,LP.ATTRIBUTE6
			  ,LP.ATTRIBUTE7
			  ,LP.ATTRIBUTE8
			  ,LP.ATTRIBUTE9
			  ,LP.ATTRIBUTE10
		 FROM SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = LP.DIVISION_ID
					  AND (LP.YYYYMM = VP.TO_DELETE_YY 
						   OR 
						   LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 조립 SOP Master 정보 - #SCP_MST_CAPA_LINE_SOP' -- 2024.12.09 추가 
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
		   AND SP.VALID_YN		= 'Y'
		   AND SP.SOP_DT IS NOT NULL
		   AND SP.SOP_YM IS NOT NULL
		   AND SP.SOP_DDN IS NOT NULL 
		   AND SP.SOP_DDN	   != 0 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'조립 SOP 정보' -- 2024.12.09 추가 
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
		SELECT SP.DIVISION_ID
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
	 	WHERE 1=1

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Insert Into SCP_MST_CAPA_LOSS_PLAN_MDL ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_LOSS_PLAN_MDL(
			  DIVISION_ID
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
			 ,PFRSLT_NVL
			 ,BASE_NVL
			 -- 2025.02.06 개선/목표일 관리 기능 삭제,IPRV_GOL_DIVS_CD
			 -- 2025.02.06 개선/목표일 관리 기능 삭제,IPRV_GOL_RT
			 ,MSR_GR_CD
			 ,MSR_NVL
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
			 ,ATTRIBUTE9
			 ,ATTRIBUTE10	) 
		 -- 신규 년월 데이터 
		 SELECT LP.DIVISION_ID
			   ,LP.PLANT_ID
			   ,LP.LINE_ID
			   ,LP.OPERATION_ID
			   ,LP.ELTR_LN_TP_CD
			   ,LP.MDL_NM
			   ,LP.COMPANY_ID
			   ,LP.SITE_ID
			   ,LP.FACTORY_ID
			   ,LP.MSR_TP_CD
			   ,NY.TO_YYYYMM
			   ,LP.PFRSLT_NVL
			   ,LP.BASE_NVL
			   -- 2025.02.06 개선/목표일 관리 기능 삭제,LP.IPRV_GOL_DIVS_CD
			   -- 2025.02.06 개선/목표일 관리 기능 삭제,LP.IPRV_GOL_RT
			   ,LP.MSR_GR_CD
			   ,CASE WHEN LP.MSR_TP_CD = 'PROD_CAPA_M'		-- 2024.12.09 신규 년월구간 월Capa 로직 변경  
					 THEN CONVERT(FLOAT, 
									MAX(CASE WHEN LP.MSR_TP_CD = 'PROD_CAPA_D'
											 THEN LP.MSR_NVL
											  ELSE NULL
										 END) OVER (PARTITION BY LP.DIVISION_ID
																,LP.PLANT_ID
																,LP.LINE_ID
																,LP.OPERATION_ID
																,LP.ELTR_LN_TP_CD
																,LP.MDL_NM
																,LP.COMPANY_ID
																,LP.SITE_ID
																,LP.FACTORY_ID
																,NY.TO_YYYYMM))  * CASE WHEN SI.SOP_YM IS NOT NULL
																						THEN SI.SOP_DDN
																						ELSE NY.YYYYMM_DAYS
																					END 
					 ELSE LP.MSR_NVL
				END  AS MSR_NVL
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
			   ,LP.ATTRIBUTE1
			   ,LP.ATTRIBUTE2
			   ,LP.ATTRIBUTE3
			   ,LP.ATTRIBUTE4
			   ,LP.ATTRIBUTE5
			   ,LP.ATTRIBUTE6
			   ,LP.ATTRIBUTE7
			   ,LP.ATTRIBUTE8
			   ,LP.ATTRIBUTE9
			   ,LP.ATTRIBUTE10
		  FROM SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= LP.DIVISION_ID
					  AND VP.TO_DELETE_YY	= LP.YYYYMM 
			   INNER JOIN #NEW_YYYYMM_LIST NY 
					   ON NY.COPY_FROM_YYYY = LP.YYYYMM 
			   LEFT  JOIN #SOP_INFO SI		-- 2024.12.09 
					   ON SI.DIVISION_ID	= LP.DIVISION_ID
					  AND SI.PLANT_ID		= LP.PLANT_ID
					  AND SI.LINE_ID		= LP.LINE_ID
					  AND SI.OPERATION_ID	= LP.OPERATION_ID
					  AND SI.ELTR_LN_TP_CD	= LP.ELTR_LN_TP_CD
					  AND SI.COMPANY_ID		= LP.COMPANY_ID
					  AND SI.SITE_ID		= LP.SITE_ID
					  AND SI.FACTORY_ID		= LP.FACTORY_ID
					  AND SI.SOP_YM			= NY.TO_YYYYMM
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Delete  SCP_MST_CAPA_LOSS_PLAN_MDL ' 
		-------------------------------------------------------------------------------------------------------------------
		DELETE LP
		 FROM SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = LP.DIVISION_ID
					  AND (LP.YYYYMM = VP.TO_DELETE_YY 
						   OR 
						   LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 


		-- 2025.02.06 개선/목표일 관리 기능 삭제 -------------------------------------------------------------------------------------------------------------------------
		-- 2025.02.06 개선/목표일 관리 기능 삭제 print  convert(varchar(30), getdate(), 121) + N' Update SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL : 개선/목표율 역계산 적용' 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 -- 2024.12.05 LGES2024-002655 SCP 개선과제 이행 : 개선/목표율 역계산 적용
		-- 2025.02.06 개선/목표일 관리 기능 삭제 -- 'I' 개선율 관리 항목인 경우 base가 0일 경우에 대해 별도 보완 필요.....  !!!!
		-- 2025.02.06 개선/목표일 관리 기능 삭제 -------------------------------------------------------------------------------------------------------------------------
		-- 2025.02.06 개선/목표일 관리 기능 삭제 UPDATE LP
		-- 2025.02.06 개선/목표일 관리 기능 삭제    SET LP.IPRV_GOL_RT 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 		=
		-- 2025.02.06 개선/목표일 관리 기능 삭제 	   CASE WHEN LP.IPRV_GOL_DIVS_CD = 'G'
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			THEN LP.MSR_NVL				-- 목표율과 운영계획이 같음
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			WHEN LP.IPRV_GOL_DIVS_CD = 'I' AND LP.MSR_GR_CD = '-'				AND LP.BASE_NVL != 0		-- 양품가동률	  (운영계획/base - 1)
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			THEN (CONVERT(FLOAT,LP.MSR_NVL) / CONVERT(FLOAT, LP.BASE_NVL)) - CONVERT(FLOAT, 1)  
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			WHEN LP.IPRV_GOL_DIVS_CD = 'I' AND LP.MSR_GR_CD IN ('NLD', 'NOP')	AND LP.BASE_NVL != 0		-- 비부하/비가동  (1 - 운영계획/base)
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			THEN CONVERT(FLOAT, 1) - (CONVERT(FLOAT,LP.MSR_NVL) / CONVERT(FLOAT, LP.BASE_NVL))
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			ELSE LP.IPRV_GOL_RT 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 		END 
		-- 2025.02.06 개선/목표일 관리 기능 삭제      , LP.LAST_UPDATE_DATE	= GETDATE()
		-- 2025.02.06 개선/목표일 관리 기능 삭제 	 , LP.LAST_UPDATED_BY	= @v_program_name + '-IG1'
		-- 2025.02.06 개선/목표일 관리 기능 삭제   FROM SCP_MST_CAPA_LOSS_PLAN_MDL LP WITH(NOLOCK)
		-- 2025.02.06 개선/목표일 관리 기능 삭제 	   INNER JOIN #NEXT_VER_PERIOD VP
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			   ON VP.DIVISION_ID	= LP.DIVISION_ID
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			  AND VP.IG_CAL_FROM_YM	<= LP.YYYYMM 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			  AND VP.IG_CAL_TO_YM	>= LP.YYYYMM 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 WHERE 1=1
		-- 2025.02.06 개선/목표일 관리 기능 삭제   AND LP.IPRV_GOL_DIVS_CD IN ('I', 'G') 


		----------------------- LOSS PLAN (라인별) -- SCP_MST_CAPA_LOSS_PLAN_LN  -- 백업/추가/삭제 	 (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 
		----------------------- LOSS PLAN (라인별) -- SCP_MST_CAPA_LOSS_PLAN_LN  -- 백업/추가/삭제 	 (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'Start - SCP_MST_CAPA_LOSS_PLAN_LN -- 백업/추가/삭제'  + ISNULL(@v_division_id, 'ALL DIVISION');   
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

 		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 삭제전 백업 SCP_MST_CAPA_LOSS_PLAN_LN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_LOSS_PLAN_LN_B (
				  HISTORY_SEQ
				 ,HISTORY_CREATION_DATE
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
				 ,ATTRIBUTE9
				 ,ATTRIBUTE10)
		SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_LOSS_PLAN_LN_B	AS HISTORY_SEQ 
			  ,GETDATE()										AS HISTORY_CREATION_DATE
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
			  ,LP.CREATED_BY
			  ,LP.CREATION_DATE
			  ,LP.LAST_UPDATED_BY
			  ,LP.LAST_UPDATE_DATE
			  ,LP.ATTRIBUTE1
			  ,LP.ATTRIBUTE2
			  ,LP.ATTRIBUTE3
			  ,LP.ATTRIBUTE4
			  ,LP.ATTRIBUTE5
			  ,LP.ATTRIBUTE6
			  ,LP.ATTRIBUTE7
			  ,LP.ATTRIBUTE8
			  ,LP.ATTRIBUTE9
			  ,LP.ATTRIBUTE10
		 FROM SCP_MST_CAPA_LOSS_PLAN_LN LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = LP.DIVISION_ID
					  AND (LP.YYYYMM = VP.TO_DELETE_YY 
						  OR 
						  LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Insert Into SCP_MST_CAPA_LOSS_PLAN_LN ' 
		-------------------------------------------------------------------------------------------------------------------
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
			 ,ATTRIBUTE1
			 ,ATTRIBUTE2
			 ,ATTRIBUTE3
			 ,ATTRIBUTE4
			 ,ATTRIBUTE5
			 ,ATTRIBUTE6
			 ,ATTRIBUTE7
			 ,ATTRIBUTE8
			 ,ATTRIBUTE9
			 ,ATTRIBUTE10		)
		 -- 신규 년월 데이터 
		 SELECT LP.DIVISION_ID
			   ,LP.PLANT_ID
			   ,LP.LINE_ID
			   ,LP.OPERATION_ID
			   ,LP.ELTR_LN_TP_CD
			   ,LP.COMPANY_ID
			   ,LP.SITE_ID
			   ,LP.FACTORY_ID
			   ,LP.MSR_TP_CD
			   ,NY.TO_YYYYMM
			   ,LP.MSR_GR_CD
			   ,LP.MSR_NVL / 12.	AS	MSR_NVL		-- 년도 기준 비조업일수 (월평균으로 적용) 
			   ,LP.MSR_DDN / 12.	AS	MSR_DDN		-- 년도 기준 비조업일수 (월평균으로 적용) 
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
			   ,LP.ATTRIBUTE1
			   ,LP.ATTRIBUTE2
			   ,LP.ATTRIBUTE3
			   ,LP.ATTRIBUTE4
			   ,LP.ATTRIBUTE5
			   ,LP.ATTRIBUTE6
			   ,LP.ATTRIBUTE7
			   ,LP.ATTRIBUTE8
			   ,LP.ATTRIBUTE9
			   ,LP.ATTRIBUTE10
		  FROM SCP_MST_CAPA_LOSS_PLAN_LN LP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= LP.DIVISION_ID
					  AND VP.TO_DELETE_YY	= LP.YYYYMM 
				INNER JOIN #NEW_YYYYMM_LIST NY 
					   ON NY.COPY_FROM_YYYY = LP.YYYYMM 
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Delete SCP_MST_CAPA_LOSS_PLAN_LN ' 
		-------------------------------------------------------------------------------------------------------------------
		DELETE LP
		 FROM SCP_MST_CAPA_LOSS_PLAN_LN LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = LP.DIVISION_ID
					  AND (LP.YYYYMM = VP.TO_DELETE_YY 
					       OR 
						   LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 


		----------------------- Line Assign -- SCP_MST_CAPA_LINE_ASSIGN	  -- 백업/추가/삭제 	    (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 
		----------------------- Line Assign -- SCP_MST_CAPA_LINE_ASSIGN	  -- 백업/추가/삭제 	    (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'Start - SCP_MST_CAPA_LINE_ASSIGN -- 백업/추가/삭제'  + ISNULL(@v_division_id, 'ALL DIVISION');  
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

 		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 삭제전 백업 SCP_MST_CAPA_LINE_ASSIGN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_LINE_ASSIGN_B (  
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
				 ,ITEM_ID
				 ,NICK_NAME
				 ,YYYYMM
				 ,ASSIGN_PRIORITY
				 ,DUMMY_YN
				 ,VALID_YN
				 ,CREATED_BY
				 ,CREATION_DATE
				 ,LAST_UPDATED_BY
				 ,LAST_UPDATE_DATE)
		SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_LINE_ASSIGN_B	AS HISTORY_SEQ 
			  ,GETDATE()										AS HISTORY_CREATION_DATE
			  ,LP.DIVISION_ID
			  ,LP.COMPANY_ID
			  ,LP.SITE_ID
			  ,LP.PLANT_ID
			  ,LP.FACTORY_ID
			  ,LP.LINE_ID
			  ,LP.OPERATION_ID
			  ,LP.ELTR_LN_TP_CD
			  ,LP.ITEM_ID
			  ,LP.NICK_NAME
			  ,LP.YYYYMM
			  ,LP.ASSIGN_PRIORITY
			  ,LP.DUMMY_YN
			  ,LP.VALID_YN
			  ,LP.CREATED_BY
			  ,LP.CREATION_DATE
			  ,LP.LAST_UPDATED_BY
			  ,LP.LAST_UPDATE_DATE
		 FROM SCP_MST_CAPA_LINE_ASSIGN LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					  ON VP.DIVISION_ID	= LP.DIVISION_ID
					 AND (LP.YYYYMM = VP.TO_DELETE_YY 
						  OR 
						  LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 
		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Insert Into SCP_MST_CAPA_LINE_ASSIGN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_LINE_ASSIGN (
			  DIVISION_ID
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
			 ,LAST_UPDATE_DATE		)
		-- 신규 년도 데이터 
		 SELECT LP.DIVISION_ID
			   ,LP.COMPANY_ID
			   ,LP.SITE_ID
			   ,LP.PLANT_ID
			   ,LP.FACTORY_ID
			   ,LP.LINE_ID
			   ,LP.OPERATION_ID
			   ,LP.ELTR_LN_TP_CD
			   ,LP.ITEM_ID
			   ,LP.NICK_NAME
			   ,VP.TO_YY	AS YYYYMM
			   ,0			AS ASSIGN_PRIORITY	-- 2024.12.09 신규 년도구간 line assign 0으로 생성  
			   ,LP.DUMMY_YN
			   ,LP.VALID_YN
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
		  FROM SCP_MST_CAPA_LINE_ASSIGN LP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= LP.DIVISION_ID
					  AND VP.COPY_FROM_YY	= LP.YYYYMM
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 
		 UNION ALL 
		 -- 신규 년월 데이터 
		 SELECT LP.DIVISION_ID
			   ,LP.COMPANY_ID
			   ,LP.SITE_ID
			   ,LP.PLANT_ID
			   ,LP.FACTORY_ID
			   ,LP.LINE_ID
			   ,LP.OPERATION_ID
			   ,LP.ELTR_LN_TP_CD
			   ,LP.ITEM_ID
			   ,LP.NICK_NAME
			   ,NY.TO_YYYYMM
			   ,LP.ASSIGN_PRIORITY
			   ,LP.DUMMY_YN
			   ,LP.VALID_YN
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
		  FROM SCP_MST_CAPA_LINE_ASSIGN LP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= LP.DIVISION_ID
					  AND VP.TO_DELETE_YY	= LP.YYYYMM 
				INNER JOIN #NEW_YYYYMM_LIST NY 
					   ON NY.COPY_FROM_YYYY = LP.YYYYMM 
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Delete SCP_MST_CAPA_LINE_ASSIGN ' 
		-------------------------------------------------------------------------------------------------------------------
		DELETE LP
		-- SELECT *
		-- select distinct yyyymm , NEXT_VER_ID
		 FROM SCP_MST_CAPA_LINE_ASSIGN LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					  ON VP.DIVISION_ID	= LP.DIVISION_ID
					 AND (LP.YYYYMM = VP.TO_DELETE_YY 
					      OR 
						  LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 


	---### Begin 전극 ###---------------------------------------------------------------------- 
	---### Begin 전극 ###---------------------------------------------------------------------- 
	---### Begin 전극 ###---------------------------------------------------------------------- 

		----------------------- 전극 SPEED PLAN  --- SCP_MST_CAPA_ELTR_SPEED_PLAN -- 백업/추가/삭제 (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 
		----------------------- 전극 SPEED PLAN  --- SCP_MST_CAPA_ELTR_SPEED_PLAN -- 백업/추가/삭제 (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'Start - 전극 - SCP_MST_CAPA_ELTR_SPEED_PLAN -- 백업/추가/삭제' + ISNULL(@v_division_id, 'ALL DIVISION');     
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

 		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'전극 - 삭제전 백업 SCP_MST_CAPA_ELTR_SPEED_PLAN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_ELTR_SPEED_PLAN_B (  
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
				 ,LAST_UPDATE_DATE )
		SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_ELTR_SPEED_PLAN_B AS HISTORY_SEQ 
			 ,GETDATE()	AS HISTORY_CREATION_DATE
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
			 ,SP.CREATED_BY
			 ,SP.CREATION_DATE
			 ,SP.LAST_UPDATED_BY
			 ,SP.LAST_UPDATE_DATE
		 FROM SCP_MST_CAPA_ELTR_SPEED_PLAN SP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = SP.DIVISION_ID
					  AND (SP.YYYYMM = VP.TO_DELETE_YY 
					       OR 
						   SP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		  AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 -  Insert Into  SCP_MST_CAPA_ELTR_SPEED_PLAN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_ELTR_SPEED_PLAN ( 
			  DIVISION_ID
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
			 ,LAST_UPDATE_DATE )
		 -- 신규 년월 데이터 
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
			   ,NY.TO_YYYYMM
			   ,SP.BASE_QTY
			   ,SP.QTY
			   ,SP.UI_UPD_YN
			   ,SP.REMARK
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
		  FROM SCP_MST_CAPA_ELTR_SPEED_PLAN SP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= SP.DIVISION_ID
					  AND VP.TO_DELETE_YY	= SP.YYYYMM 
				INNER JOIN #NEW_YYYYMM_LIST NY 
					   ON NY.COPY_FROM_YYYY = SP.YYYYMM 
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 -  DELETE  SCP_MST_CAPA_ELTR_SPEED_PLAN ' 
		-------------------------------------------------------------------------------------------------------------------
	
		DELETE SP
		 FROM SCP_MST_CAPA_ELTR_SPEED_PLAN SP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = SP.DIVISION_ID
					  AND (SP.YYYYMM = VP.TO_DELETE_YY 
					       OR 
						   SP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		  AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		----------------------- 전극 -  LOSS PLAN (모델별) -- SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL -- 백업/추가/삭제   (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 
		----------------------- 전극 -  LOSS PLAN (모델별) -- SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL -- 백업/추가/삭제   (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'Start - 전극 - SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL -- 백업/추가/삭제'  + ISNULL(@v_division_id, 'ALL DIVISION'); 
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

 		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 -  삭제전 백업 SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_B (  
				  HISTORY_SEQ
				 ,HISTORY_CREATION_DATE
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
				 ,PFRSLT_NVL
				 ,BASE_NVL
				 -- 2025.02.06 개선/목표일 관리 기능 삭제 ,IPRV_GOL_DIVS_CD
				 -- 2025.02.06 개선/목표일 관리 기능 삭제 ,IPRV_GOL_RT
				 ,MSR_GR_CD
				 ,MSR_NVL
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
				 ,ATTRIBUTE9
				 ,ATTRIBUTE10)
		SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_B AS HISTORY_SEQ 
			  ,GETDATE()										AS HISTORY_CREATION_DATE
			  ,LP.DIVISION_ID
			  ,LP.PLANT_ID
			  ,LP.LINE_ID
			  ,LP.OPERATION_ID
			  ,LP.ELTR_LN_TP_CD
			  ,LP.MDL_NM
			  ,LP.COMPANY_ID
			  ,LP.SITE_ID
			  ,LP.FACTORY_ID
			  ,LP.MSR_TP_CD
			  ,LP.YYYYMM
			  ,LP.PFRSLT_NVL
			  ,LP.BASE_NVL
			  -- 2025.02.06 개선/목표일 관리 기능 삭제 ,LP.IPRV_GOL_DIVS_CD
			  -- 2025.02.06 개선/목표일 관리 기능 삭제 ,LP.IPRV_GOL_RT
			  ,LP.MSR_GR_CD
			  ,LP.MSR_NVL
			  ,LP.CREATED_BY
			  ,LP.CREATION_DATE
			  ,LP.LAST_UPDATED_BY
			  ,LP.LAST_UPDATE_DATE
			  ,LP.ATTRIBUTE1
			  ,LP.ATTRIBUTE2
			  ,LP.ATTRIBUTE3
			  ,LP.ATTRIBUTE4
			  ,LP.ATTRIBUTE5
			  ,LP.ATTRIBUTE6
			  ,LP.ATTRIBUTE7
			  ,LP.ATTRIBUTE8
			  ,LP.ATTRIBUTE9
			  ,LP.ATTRIBUTE10
		 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = LP.DIVISION_ID
					  AND (LP.YYYYMM = VP.TO_DELETE_YY 
						   OR 
						   LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 SOP Master 정보 - #SCP_MST_CAPA_ELTR_LINE_SOP' -- 2024.12.09
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
			  ,CONVERT(FLOAT, SP.SOP_DDN)	AS SOP_DDN 
			  ,SUBSTRING(SP.SOP_YM, 1, 4)	AS SOP_YY
			  ,CONVERT(FLOAT, DATEDIFF(DD, CONVERT(DATE, SP.SOP_DT, 112)
										 , DATEADD(YY, 1, CONVERT(DATE, SUBSTRING(SP.SOP_YM, 1, 4)+'0101', 112)))
										)	AS SOP_YY_DDN	-- 년일수
		  INTO #SCP_MST_CAPA_ELTR_LINE_SOP
		  FROM SCP_MST_CAPA_ELTR_LINE_SOP SP WITH(NOLOCK) 
		 WHERE 1=1
		   AND SP.VALID_YN		= 'Y'
		   AND SP.SOP_DT IS NOT NULL
		   AND SP.SOP_YM IS NOT NULL
		   AND SP.SOP_DDN IS NOT NULL 
		   AND SP.SOP_DDN	   != 0 

		--------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 SOP정보 - #SOP_INFO_ELTR'  -- 2024.12.09
		-- 전극 : DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
		--------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SOP_INFO_ELTR') IS NOT NULL DROP TABLE #SOP_INFO_ELTR

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
		SELECT SP.DIVISION_ID
			  ,SP.COMPANY_ID
			  ,SP.SITE_ID
			  ,SP.PLANT_ID
			  ,SP.FACTORY_ID
			  ,SP.LINE_ID
			  ,SP.OPERATION_ID
			  ,SP.SOP_DT
			  ,SP.SOP_YM
			  ,CONVERT(FLOAT, SP.SOP_DDN) AS SOP_DDN 
		  INTO #SOP_INFO_ELTR
		  FROM CAPA_LINE_SOP SP WITH(NOLOCK) 
	 	 WHERE 1=1

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 - Insert Into SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL(
			  DIVISION_ID
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
			 ,PFRSLT_NVL
			 ,BASE_NVL
			 -- 2025.02.06 개선/목표일 관리 기능 삭제 ,IPRV_GOL_DIVS_CD
			 -- 2025.02.06 개선/목표일 관리 기능 삭제 ,IPRV_GOL_RT
			 ,MSR_GR_CD
			 ,MSR_NVL
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
			 ,ATTRIBUTE9
			 ,ATTRIBUTE10	) 
		 -- 신규 년월 데이터 
		 SELECT LP.DIVISION_ID
			   ,LP.PLANT_ID
			   ,LP.LINE_ID
			   ,LP.OPERATION_ID
			   ,LP.ELTR_LN_TP_CD
			   ,LP.MDL_NM
			   ,LP.COMPANY_ID
			   ,LP.SITE_ID
			   ,LP.FACTORY_ID
			   ,LP.MSR_TP_CD
			   ,NY.TO_YYYYMM
			   ,LP.PFRSLT_NVL
			   ,LP.BASE_NVL
			   -- 2025.02.06 개선/목표일 관리 기능 삭제 ,LP.IPRV_GOL_DIVS_CD
			   -- 2025.02.06 개선/목표일 관리 기능 삭제 ,LP.IPRV_GOL_RT
			   ,LP.MSR_GR_CD
			   ,CASE WHEN LP.MSR_TP_CD = 'PROD_CAPA_M'		-- 2024.12.09 신규 년월구간 월Capa 로직 변경  
					 THEN CONVERT(FLOAT, 
									MAX(CASE WHEN LP.MSR_TP_CD = 'PROD_CAPA_D'
											 THEN LP.MSR_NVL
											  ELSE NULL
										 END) OVER (PARTITION BY LP.DIVISION_ID
																,LP.PLANT_ID
																,LP.LINE_ID
																,LP.OPERATION_ID
																,LP.MDL_NM
																,LP.COMPANY_ID
																,LP.SITE_ID
																,LP.FACTORY_ID
																,NY.TO_YYYYMM))  * CASE WHEN SI.SOP_YM IS NOT NULL
																						THEN SI.SOP_DDN
																						ELSE NY.YYYYMM_DAYS
																					END 
					 ELSE LP.MSR_NVL
				END  AS MSR_NVL
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
			   ,LP.ATTRIBUTE1
			   ,LP.ATTRIBUTE2
			   ,LP.ATTRIBUTE3
			   ,LP.ATTRIBUTE4
			   ,LP.ATTRIBUTE5
			   ,LP.ATTRIBUTE6
			   ,LP.ATTRIBUTE7
			   ,LP.ATTRIBUTE8
			   ,LP.ATTRIBUTE9
			   ,LP.ATTRIBUTE10
		  FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= LP.DIVISION_ID
					  AND VP.TO_DELETE_YY	= LP.YYYYMM 
			   INNER JOIN #NEW_YYYYMM_LIST NY 
					   ON NY.COPY_FROM_YYYY = LP.YYYYMM 
			   LEFT  JOIN #SOP_INFO_ELTR SI		-- 2024.12.09 전극 SOP 정보
					   ON SI.DIVISION_ID	= LP.DIVISION_ID
					  AND SI.PLANT_ID		= LP.PLANT_ID
					  AND SI.LINE_ID		= LP.LINE_ID
					  AND SI.OPERATION_ID	= LP.OPERATION_ID
					  AND SI.COMPANY_ID		= LP.COMPANY_ID
					  AND SI.SITE_ID		= LP.SITE_ID
					  AND SI.FACTORY_ID		= LP.FACTORY_ID
					  AND SI.SOP_YM			= NY.TO_YYYYMM
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 -  Delete  SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL ' 
		-------------------------------------------------------------------------------------------------------------------
		DELETE LP
		 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = LP.DIVISION_ID
					  AND (LP.YYYYMM = VP.TO_DELETE_YY 
						   OR 
						   LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-- 2025.02.06 개선/목표일 관리 기능 삭제 -------------------------------------------------------------------------------------------------------------------------
		-- 2025.02.06 개선/목표일 관리 기능 삭제 print  convert(varchar(30), getdate(), 121) + N' 전극 Update SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL : 개선/목표율 역계산 적용' 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 -- 2024.12.05 LGES2024-002655 SCP 개선과제 이행 : 개선/목표율 역계산 적용
		-- 2025.02.06 개선/목표일 관리 기능 삭제 -- 'I' 개선율 관리 항목인 경우 base가 0일 경우에 대해 별도 보완 필요.....  !!!!
		-- 2025.02.06 개선/목표일 관리 기능 삭제 -------------------------------------------------------------------------------------------------------------------------
		-- 2025.02.06 개선/목표일 관리 기능 삭제 UPDATE LP
		-- 2025.02.06 개선/목표일 관리 기능 삭제    SET LP.IPRV_GOL_RT 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 		=
		-- 2025.02.06 개선/목표일 관리 기능 삭제 	   CASE WHEN LP.IPRV_GOL_DIVS_CD = 'G'
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			THEN LP.MSR_NVL				-- 목표율과 운영계획이 같음
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			WHEN LP.IPRV_GOL_DIVS_CD = 'I' AND LP.MSR_GR_CD = '-'				AND LP.BASE_NVL != 0		-- 양품가동률	  (운영계획/base - 1)
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			THEN (CONVERT(FLOAT,LP.MSR_NVL) / CONVERT(FLOAT, LP.BASE_NVL)) - CONVERT(FLOAT, 1)  
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			WHEN LP.IPRV_GOL_DIVS_CD = 'I' AND LP.MSR_GR_CD IN ('NLD', 'NOP')	AND LP.BASE_NVL != 0		-- 비부하/비가동  (1 - 운영계획/base)
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			THEN CONVERT(FLOAT, 1) - (CONVERT(FLOAT,LP.MSR_NVL) / CONVERT(FLOAT, LP.BASE_NVL))
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			ELSE LP.IPRV_GOL_RT 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 		END 
		-- 2025.02.06 개선/목표일 관리 기능 삭제      , LP.LAST_UPDATE_DATE	= GETDATE()
		-- 2025.02.06 개선/목표일 관리 기능 삭제 	 , LP.LAST_UPDATED_BY	= @v_program_name + '-IG1'
		-- 2025.02.06 개선/목표일 관리 기능 삭제   FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL LP WITH(NOLOCK)
		-- 2025.02.06 개선/목표일 관리 기능 삭제 	   INNER JOIN #NEXT_VER_PERIOD VP
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			   ON VP.DIVISION_ID	= LP.DIVISION_ID
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			  AND VP.IG_CAL_FROM_YM	<= LP.YYYYMM 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 			  AND VP.IG_CAL_TO_YM	>= LP.YYYYMM 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 WHERE 1=1
		-- 2025.02.06 개선/목표일 관리 기능 삭제   AND LP.IPRV_GOL_DIVS_CD IN ('I', 'G') 
		-- 2025.02.06 개선/목표일 관리 기능 삭제 

		----------------------- 전극 -  LOSS PLAN (라인별) -- SCP_MST_CAPA_ELTR_LOSS_PLAN_LN  -- 백업/추가/삭제 	 (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 
		----------------------- 전극 -  LOSS PLAN (라인별) -- SCP_MST_CAPA_ELTR_LOSS_PLAN_LN  -- 백업/추가/삭제 	 (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'Start - 전극 - SCP_MST_CAPA_ELTR_LOSS_PLAN_LN -- 백업/추가/삭제'  + ISNULL(@v_division_id, 'ALL DIVISION');   
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

 		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 -  삭제전 백업 SCP_MST_CAPA_ELTR_LOSS_PLAN_LN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_B (
				  HISTORY_SEQ
				 ,HISTORY_CREATION_DATE
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
				 ,ATTRIBUTE9
				 ,ATTRIBUTE10)
		SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_B	AS HISTORY_SEQ 
			  ,GETDATE()										AS HISTORY_CREATION_DATE
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
			  ,LP.CREATED_BY
			  ,LP.CREATION_DATE
			  ,LP.LAST_UPDATED_BY
			  ,LP.LAST_UPDATE_DATE
			  ,LP.ATTRIBUTE1
			  ,LP.ATTRIBUTE2
			  ,LP.ATTRIBUTE3
			  ,LP.ATTRIBUTE4
			  ,LP.ATTRIBUTE5
			  ,LP.ATTRIBUTE6
			  ,LP.ATTRIBUTE7
			  ,LP.ATTRIBUTE8
			  ,LP.ATTRIBUTE9
			  ,LP.ATTRIBUTE10
		 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_LN LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = LP.DIVISION_ID
					  AND (LP.YYYYMM = VP.TO_DELETE_YY 
						  OR 
						  LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 
		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 - Insert Into SCP_MST_CAPA_ELTR_LOSS_PLAN_LN ' 
		-------------------------------------------------------------------------------------------------------------------
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
			 ,ATTRIBUTE1
			 ,ATTRIBUTE2
			 ,ATTRIBUTE3
			 ,ATTRIBUTE4
			 ,ATTRIBUTE5
			 ,ATTRIBUTE6
			 ,ATTRIBUTE7
			 ,ATTRIBUTE8
			 ,ATTRIBUTE9
			 ,ATTRIBUTE10		)
		 -- 신규 년월 데이터 
		 SELECT LP.DIVISION_ID
			   ,LP.PLANT_ID
			   ,LP.LINE_ID
			   ,LP.OPERATION_ID
			   ,LP.ELTR_LN_TP_CD
			   ,LP.COMPANY_ID
			   ,LP.SITE_ID
			   ,LP.FACTORY_ID
			   ,LP.MSR_TP_CD
			   ,NY.TO_YYYYMM
			   ,LP.MSR_GR_CD
			   ,LP.MSR_NVL / 12.	AS	MSR_NVL		-- 년도 기준 비조업일수 (월평균으로 적용) 
			   ,LP.MSR_DDN / 12.	AS	MSR_DDN		-- 년도 기준 비조업일수 (월평균으로 적용) 
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
			   ,LP.ATTRIBUTE1
			   ,LP.ATTRIBUTE2
			   ,LP.ATTRIBUTE3
			   ,LP.ATTRIBUTE4
			   ,LP.ATTRIBUTE5
			   ,LP.ATTRIBUTE6
			   ,LP.ATTRIBUTE7
			   ,LP.ATTRIBUTE8
			   ,LP.ATTRIBUTE9
			   ,LP.ATTRIBUTE10
		  FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_LN LP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= LP.DIVISION_ID
					  AND VP.TO_DELETE_YY	= LP.YYYYMM 
				INNER JOIN #NEW_YYYYMM_LIST NY 
					   ON NY.COPY_FROM_YYYY = LP.YYYYMM 
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 -  Delete SCP_MST_CAPA_ELTR_LOSS_PLAN_LN ' 
		-------------------------------------------------------------------------------------------------------------------
		DELETE LP
		 FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_LN LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID = LP.DIVISION_ID
					  AND (LP.YYYYMM = VP.TO_DELETE_YY 
					       OR 
						   LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 


		----------------------- 전극 -  Line Assign -- SCP_MST_CAPA_ELTR_LINE_ASSIGN	  -- 백업/추가/삭제 	    (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 
		----------------------- 전극 -  Line Assign -- SCP_MST_CAPA_ELTR_LINE_ASSIGN	  -- 백업/추가/삭제 	    (VER_SEQ = 1 , 해당월의 최초 한번만 수행) 

		SET @v_log_type = 'TXN';
		SET @v_log_message = N'Start - 전극 - SCP_MST_CAPA_ELTR_LINE_ASSIGN -- 백업/추가/삭제'  + ISNULL(@v_division_id, 'ALL DIVISION');  
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

 		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 - 삭제전 백업 SCP_MST_CAPA_ELTR_LINE_ASSIGN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_ELTR_LINE_ASSIGN_B (  
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
				 ,LAST_UPDATE_DATE)
		SELECT NEXT VALUE FOR SEQ1_SCP_MST_CAPA_ELTR_LINE_ASSIGN_B	AS HISTORY_SEQ 
			  ,GETDATE()										AS HISTORY_CREATION_DATE
			  ,LP.DIVISION_ID
			  ,LP.COMPANY_ID
			  ,LP.SITE_ID
			  ,LP.PLANT_ID
			  ,LP.FACTORY_ID
			  ,LP.LINE_ID
			  ,LP.OPERATION_ID
			  ,LP.ELTR_LN_TP_CD
			  ,LP.ITEM_ID
			  ,LP.NICK_NAME
			  ,LP.YYYYMM
			  ,LP.ASSIGN_PRIORITY
			  ,LP.DUMMY_YN
			  ,LP.VALID_YN
			  ,LP.LANE_QTY
			  ,LP.CREATED_BY
			  ,LP.CREATION_DATE
			  ,LP.LAST_UPDATED_BY
			  ,LP.LAST_UPDATE_DATE
		 FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					  ON VP.DIVISION_ID	= LP.DIVISION_ID
					 AND (LP.YYYYMM = VP.TO_DELETE_YY 
						  OR 
						  LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 - Insert Into SCP_MST_CAPA_ELTR_LINE_ASSIGN ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_CAPA_ELTR_LINE_ASSIGN (
			  DIVISION_ID
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
			 ,LAST_UPDATE_DATE		)
		-- 신규 년도 데이터 
		 SELECT LP.DIVISION_ID
			   ,LP.COMPANY_ID
			   ,LP.SITE_ID
			   ,LP.PLANT_ID
			   ,LP.FACTORY_ID
			   ,LP.LINE_ID
			   ,LP.OPERATION_ID
			   ,LP.ELTR_LN_TP_CD
			   ,LP.ITEM_ID
			   ,LP.NICK_NAME
			   ,VP.TO_YY	AS YYYYMM
			   ,0			AS ASSIGN_PRIORITY	-- 2024.12.09 신규 년도구간 line assign 0으로 생성  
			   ,LP.DUMMY_YN
			   ,LP.VALID_YN
			   ,LP.LANE_QTY
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
		  FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN LP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= LP.DIVISION_ID
					  AND VP.COPY_FROM_YY	= LP.YYYYMM
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 
		 UNION ALL 
		 -- 신규 년월 데이터 
		 SELECT LP.DIVISION_ID
			   ,LP.COMPANY_ID
			   ,LP.SITE_ID
			   ,LP.PLANT_ID
			   ,LP.FACTORY_ID
			   ,LP.LINE_ID
			   ,LP.OPERATION_ID
			   ,LP.ELTR_LN_TP_CD
			   ,LP.ITEM_ID
			   ,LP.NICK_NAME
			   ,NY.TO_YYYYMM
			   ,LP.ASSIGN_PRIORITY
			   ,LP.DUMMY_YN
			   ,LP.VALID_YN
			   ,LP.LANE_QTY
			   ,@v_program_name		AS	CREATED_BY
			   ,GETDATE()			AS	CREATION_DATE
			   ,@v_program_name		AS	LAST_UPDATED_BY
			   ,GETDATE()			AS	LAST_UPDATE_DATE
		  FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN LP WITH(NOLOCK)
			   INNER JOIN #NEXT_VER_PERIOD VP
					   ON VP.DIVISION_ID	= LP.DIVISION_ID
					  AND VP.TO_DELETE_YY	= LP.YYYYMM 
				INNER JOIN #NEW_YYYYMM_LIST NY 
					   ON NY.COPY_FROM_YYYY = LP.YYYYMM 
		 WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 전극 -  Delete SCP_MST_CAPA_ELTR_LINE_ASSIGN ' 
		-------------------------------------------------------------------------------------------------------------------
		DELETE LP
		 FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN LP WITH(NOLOCK)
		      INNER JOIN #NEXT_VER_PERIOD VP
					  ON VP.DIVISION_ID	= LP.DIVISION_ID
					 AND (LP.YYYYMM = VP.TO_DELETE_YY 
					      OR 
						  LP.YYYYMM < VP.START_YM) 
		WHERE 1=1
		   AND VP.NEXT_VER_SEQ = 1 -- 월 최초 한번만 수행 


	---### End 전극 ###---------------------------------------------------------------------- 
	---### End 전극 ###---------------------------------------------------------------------- 
	---### End 전극 ###---------------------------------------------------------------------- 


		COMMIT TRAN ;  --- transaction 종료  
		------- End Tran : ==========================================================================================================
		------- End Tran : ==========================================================================================================
		------- End Tran : ==========================================================================================================
		------- End Tran : ==========================================================================================================

		END ---// IF EXISTS (SELECT TOP 1 * FROM #NEXT_VER_PERIOD) -- 생성대상 버전 정보가 있는 경우만 실행


		---------------------------------------
		---- 임시테이블 정리
		-----------------------------------------
		IF OBJECT_ID('TEMPDB..#NEXT_VER_PERIOD') IS NOT NULL DROP TABLE #NEXT_VER_PERIOD; 
		IF OBJECT_ID('TEMPDB..#NEW_YYYYMM_LIST') IS NOT NULL DROP TABLE #NEW_YYYYMM_LIST; 

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
    SET @v_description = N'[division_id='+ISNULL(@v_division_id, 'ALL')+'][BASIS_YYYYMM='+ ISNULL(@V_BASIS_YYYYMM , '')+ ']['  + @v_exec_time + ']';             
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
