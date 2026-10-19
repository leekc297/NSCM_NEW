



/* 
 *
 * Program ID   : PR_SCP_MST_CAPA_LOSS_BASE_INIT
 * Description  : 매월 10일 실적 마감후 Loss Plan Current Data 실적/Base 데이터 초기화
 *				 - 대상 measure : 비부하/비가동/성능가동률/양품가동률
 *				 - 1. 최근 3개월 LOSS Plan 실적이 존재하는 Current 데이터에 대해서 실적/Base 값을 초기화 한다. (3개월 평균) 
 *				 - 2. 실적/Base값이 초기화된 건에 대해서 개선/목표율 입력구간(Y0 ~ Y1)에 대해서 운영계획을 재계산 적용한다.
 *					 (Line Assign Valid 이고 Priority 설정된 기간의 운영계획만 재계산 적용 )
 *				 - 3. 기준년월에 해당하는 버전 진행상태 정보를 Update한다. ('-':Init -> '0':Current(Speed/Loss계획 개시)) 
 *				 
 *			### Source Table 
 * 					SCP_MST_CAPA_VERSION
 *
 *			### Target Table 
 *					SCP_MST_CAPA_VERSION
 *
 *			### sub procedures  
 *				- PR_SCM_DNM_INPT_PRDN_DDLY				: DW 투입생산실적 Daily 적재 (IF->SCP)
 *				- PR_SCP_MST_CAPA_LOSS_BASE_INIT_AP		: 조립팩 (loss Result Base 초기화) 
 *				- PR_SCP_MST_CAPA_LOSS_BASE_INIT_ELTR	: 전극 (loss Result Base 초기화) 
 *				- PR_SCM_DNM_LOSS_MMLY					: LOSS 실적
 *				- PR_SCM_DNM_ELTR_LOSS_MMLY				: LOSS 실적 전극 
 *				- PR_SCM_DNM_EQP_SPED_MMLY				: 속도 실적 
 *				- PR_SCM_DNM_ELTR_EQP_SPED_MMLY			: 속도 실적 전극 
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.06.10	hrkim		조립/전극 프로시저 분리 호출
 * 2024.06.21	hrkim		속도/LOSS 실적 적재 프로시저 호출 로직 추가 
 * 2024.07.01	hrkim		호출 서브프로시저 추가 PR_SCM_DNM_INPT_PRDN_DDLY 
 * 2025.01.06	hrkim		CPS_BATCH_PROC_RUN lookup 참조하여 loss result/base 초기화 프로시저 수행
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_MST_CAPA_LOSS_BASE_INIT]
	 @P_IS_MANUAL	NVARCHAR(1)		= 'N'			
	,@P_BASE_YYYYMM	NVARCHAR(6)		= NULL
	,@P_DIVISION_ID	NVARCHAR(50)	= NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE	@V_IS_MANUAL		NVARCHAR(1)		= @P_IS_MANUAL;
	DECLARE	@V_BASE_YYYYMM		NVARCHAR(6)		= @P_BASE_YYYYMM;
	DECLARE	@V_DIVISION_ID		NVARCHAR(50)	= @P_DIVISION_ID;

	DECLARE	@V_RSLT_YYYYMM		NVARCHAR(6)		= NULL;				-- 실적 기준 년월 (M-1)

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''					--'[00:00]';    

	-- 서브 프로시저 실행 return 변수 
	DECLARE @v_ret_ap		int = 0;
	DECLARE @v_ret_eltr		int = 0;

	DECLARE @v_ret_loss_3	int = 0;
	DECLARE @v_ret_loss_1	int = 0;
	DECLARE @v_ret_sped_3	int = 0;
	DECLARE @v_ret_sped_1	int = 0;

	DECLARE @v_ret_loss_3_eltr	int = 0;
	DECLARE @v_ret_loss_1_eltr	int = 0;
	DECLARE @v_ret_sped_3_eltr	int = 0;
	DECLARE @v_ret_sped_1_eltr	int = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_CAPA_LOSS_BASE_INIT'; --Proc별 이름 설정
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

		-- 실적 참조 기간 (기준년월 기준 (M-3)~(M-1)월 : 최근 3개월) 
		SET @V_RSLT_YYYYMM	= CONVERT(NVARCHAR(6), DATEADD(MM, -1, CONVERT(DATE, @V_BASE_YYYYMM+'01', 112)), 112) 

		PRINT '------------------------------------------------------------------';
		PRINT '@P_IS_MANUAL				= ' + ISNULL(@P_IS_MANUAL		,'');
		PRINT '@V_IS_MANUAL				= ' + ISNULL(@V_IS_MANUAL		,'');
		PRINT '@P_BASE_YYYYMM			= ' + ISNULL(@P_BASE_YYYYMM		,'');
		PRINT '@V_BASE_YYYYMM			= ' + ISNULL(@V_BASE_YYYYMM		,'');
		PRINT '@P_DIVISION_ID			= ' + ISNULL(@P_DIVISION_ID	 ,'ALL');
		PRINT '@V_DIVISION_ID			= ' + ISNULL(@V_DIVISION_ID	 ,'ALL');
		PRINT '@V_RSLT_YYYYMM			= ' + ISNULL(@V_RSLT_YYYYMM		,'');
		PRINT '------------------------------------------------------------------';

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '[@V_BASE_YYYYMM='+ ISNULL(@V_BASE_YYYYMM,'') + '::@V_IS_MANUAL=' + ISNULL(@V_IS_MANUAL,'N') + '::@V_DIVISION_ID=' + ISNULL(@V_DIVISION_ID,'ALL') + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		-- 2024/7/1 추가 
		IF (DATEPART(DD, GETDATE())  BETWEEN 1 AND 10 OR @V_IS_MANUAL = 'Y') -- 매월1일부터 10일사이 행
		BEGIN
			EXEC PR_SCM_DNM_INPT_PRDN_DDLY
		END 

		
		IF (DATEPART(DD, GETDATE())  = 10 OR @V_IS_MANUAL = 'Y') -- 매월10일 이거나 매뉴얼 실행시 and speed/loss current 개시 대상 버전이 존재하는 경우만 실행
		BEGIN 


				---------------------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' Loss 실적 적재 ' 
				---------------------------------------------------------------------------------------------------------------------
				-- 조립
				EXEC @v_ret_loss_3 = PR_SCM_DNM_LOSS_MMLY @V_RSLT_YYYYMM, 3;
				EXEC @v_ret_loss_1 = PR_SCM_DNM_LOSS_MMLY @V_RSLT_YYYYMM, 1;
				print '@v_ret_loss_3 = ' + convert(nvarchar(10), @v_ret_loss_3);
				print '@v_ret_loss_1 = ' + convert(nvarchar(10), @v_ret_loss_1);

				-- 전극 
				EXEC @v_ret_loss_3_eltr = PR_SCM_DNM_ELTR_LOSS_MMLY @V_RSLT_YYYYMM, 3;
				EXEC @v_ret_loss_1_eltr = PR_SCM_DNM_ELTR_LOSS_MMLY @V_RSLT_YYYYMM, 1;
				print '@v_ret_loss_3_eltr = ' + convert(nvarchar(10), @v_ret_loss_3_eltr);
				print '@v_ret_loss_1_eltr = ' + convert(nvarchar(10), @v_ret_loss_1_eltr);

				---------------------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' Speed 실적 적재 ' 
				---------------------------------------------------------------------------------------------------------------------
				-- 조립
				EXEC @v_ret_sped_3 = PR_SCM_DNM_EQP_SPED_MMLY @V_RSLT_YYYYMM, 3;
				EXEC @v_ret_sped_1 = PR_SCM_DNM_EQP_SPED_MMLY @V_RSLT_YYYYMM, 1;
				print '@v_ret_sped_3 = ' + convert(nvarchar(10), @v_ret_sped_3);
				print '@v_ret_sped_1 = ' + convert(nvarchar(10), @v_ret_sped_1);

				-- 전극 
				EXEC @v_ret_sped_3_eltr = PR_SCM_DNM_ELTR_EQP_SPED_MMLY @V_RSLT_YYYYMM, 3;
				EXEC @v_ret_sped_1_eltr = PR_SCM_DNM_ELTR_EQP_SPED_MMLY @V_RSLT_YYYYMM, 1;
				print '@v_ret_sped_3_eltr = ' + convert(nvarchar(10), @v_ret_sped_3_eltr);
				print '@v_ret_sped_1_eltr = ' + convert(nvarchar(10), @v_ret_sped_1_eltr);

				---------------------------------------------------------------------------------------
				-- 2025.01.06  Begin loss plan Result/base 초기화
				---------------------------------------------------------------------------------------
				IF EXISTS (SELECT 1 
							FROM SCP_MST_CAPA_VERSION CV WITH(NOLOCK) 
						   WHERE 1=1
							 AND CV.VER_ID			= @V_BASE_YYYYMM 
							 AND CV.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
															THEN @V_DIVISION_ID
															ELSE CV.DIVISION_ID
													   END 
							 AND CV.PROG_STAT		= '-' )	-- 버전 상태 'Pre'
				   AND 
				   EXISTS (SELECT 1
							 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
							WHERE LK.LOOKUP_TYPE	= 'CPS_BATCH_PROC_RUN'
							  AND LK.SEGMENT1		= 'PR_SCP_MST_CAPA_LOSS_BASE_INIT'			-- 상위 프로시저
							  AND LK.SEGMENT2		= 'PR_SCP_MST_CAPA_LOSS_BASE_INIT_AP/ELTR'	-- 하위 프로시저 
							  AND LK.VALID_YN		= 'Y'
							  AND LK.ATTRIBUTE1		= 'Y'										-- 수행여부 
							  )
					BEGIN

						BEGIN TRAN   --- transaction 시작  

						---------------------------------------------------------------------------------------------------------------------
						print  convert(varchar(30), getdate(), 121) + N' Loss Current 초기화 프로시저 호출' 
						-- 3개월 기준실절 정상 적재시에만 호출 
						---------------------------------------------------------------------------------------------------------------------

						IF @v_ret_loss_3 = 1 AND @v_ret_sped_3 = 1
						BEGIN
							--- 조립/팩 초기화 프로시저 호출 
							EXEC @v_ret_ap = PR_SCP_MST_CAPA_LOSS_BASE_INIT_AP	@V_BASE_YYYYMM, @V_DIVISION_ID;
							print '@v_ret_ap = ' + convert(nvarchar(10), @v_ret_ap);
						END 


						IF @v_ret_loss_3_eltr = 1 AND @v_ret_loss_3_eltr = 1
						BEGIN
							--- 전극 초기화 프로시저 호출  
							EXEC @v_ret_eltr = PR_SCP_MST_CAPA_LOSS_BASE_INIT_ELTR @V_BASE_YYYYMM, @V_DIVISION_ID;
							print '@v_ret_eltr = ' + convert(nvarchar(10), @v_ret_eltr);
						END 

						---------------------------------------------------------------------------------------------------------------------
						print  convert(varchar(30), getdate(), 121) + N' CAPA 버전 상태정보 Update (to 0) For Current(speed/loss계획 개시)' 
						---- 매월 10일에 실적 집계 이후 Loss Current의 Result/Base update 및 운영계획 재계산 
						---- 버전 상태 변경 처리 
						---------------------------------------------------------------------------------------------------------------------
						IF @v_ret_ap = 1 AND @v_ret_eltr = 1 -- 조립/전극 모두 정상 수행시만 상태 update  
						BEGIN
							UPDATE CV SET PROG_STAT = '0'
										 ,LAST_UPDATED_BY	= @v_program_name
										 ,LAST_UPDATE_DATE	= GETDATE() 
										 ,ATTRIBUTE7		= '[PROG_STAT:''-'' to ''0'']'+CONVERT(NVARCHAR(100), GETDATE(), 25)
							  FROM SCP_MST_CAPA_VERSION CV  WITH(NOLOCK) 
							 WHERE 1=1
							   AND VER_ID			= @V_BASE_YYYYMM 
							   AND CV.DIVISION_ID	= CASE	WHEN ISNULL(@V_DIVISION_ID, '') != ''
															THEN @V_DIVISION_ID
															ELSE CV.DIVISION_ID
													   END 
							   AND PROG_STAT		= '-';
						END
				
						if (xact_state() = 1) COMMIT TRAN ;  --- transaction 종료  


					END;  --// exists (CV.PROG_STAT		= '-') 

				---------------------------------------------------------------------------------------
				-- 2025.01.06  End loss plan Result/base 초기화
				---------------------------------------------------------------------------------------


		END ---- IF (DATEPART(DD, GETDATE())  = 10 OR @V_IS_MANUAL = 'Y') -- 매월10일 이거나 매뉴얼 실행시 and speed/loss current 개시 대상 버전이 존재하는 경우만 실행 


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
	SET @v_description = N'[@V_BASE_YYYYMM='+ ISNULL(@V_BASE_YYYYMM,'') + '::@V_IS_MANUAL=' + ISNULL(@V_IS_MANUAL,'N') + '::@V_DIVISION_ID=' + ISNULL(@V_DIVISION_ID,'ALL') + ']['  + @v_exec_time + '][ret_ap='+convert(nvarchar(30),isnull(@v_ret_ap, 0))+ '][ret_eltr:'+convert(nvarchar(30),isnull(@v_ret_eltr, 0))+ ']';
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
