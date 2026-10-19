
/*  
 * Program ID   : PR_SCP_RPT_GLOBAL_PSI_STD_DIO 
 * Description  : 자동차 Monthly Global PSI STD DIO 반영 프로시저 
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.12.09	CYS		Initial Release 
 * 2026.08.12	YMH		E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건
 ----------------------------------------------------------------------------------------------------
 */  

CREATE PROCEDURE [dbo].[PR_SCP_RPT_GLOBAL_PSI_STD_DIO]
	 @P_DIVISION_ID		        NVARCHAR(30)	= '81'
	,@P_PLAN_START_YYYYMMDD		NVARCHAR(8)		= NULL
	,@P_PLAN_TYPE				NVARCHAR(8)		= 'FN'
	,@P_BUCKET					NVARCHAR(8)		= NULL
	,@P_SERCH_LEVEL				NVARCHAR(30)	= NULL
AS

BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	-- SCP 계힉 참조를 위한 변수
	DECLARE @V_DIVISION_ID		        NVARCHAR(30)	= ISNULL(@P_DIVISION_ID, '81')
	DECLARE @V_PLAN_START_YYYYMMDD		NVARCHAR(8)		= NULL;
	DECLARE @V_BUCKET					NVARCHAR(8)		= NULL;
	DECLARE @V_SERCH_LEVEL				NVARCHAR(30)	= NULL;

	DECLARE @V_PLAN_START_DATE			DATE			= NULL;

	-- E20260708-000926 기존로직 주석처리
	-- DECLARE @V_PLAN_TYPE				NVARCHAR(100)	= 'FN';
	-- E20260708-000926 신규로직
	DECLARE @V_PLAN_TYPE				NVARCHAR(100)	= ISNULL(@P_PLAN_TYPE,'FN');
	
	DECLARE @V_PLAN_SEQ					BIGINT			= 1
	DECLARE @V_HORIZON_END_YYYYMMDD		NVARCHAR(8)		= NULL
	DECLARE @V_PLAN_START_YYYYMM		NVARCHAR(6)		= NULL	-- 계획 구간 시작월
	DECLARE @V_MASTER_ID				NVARCHAR(100)	= NULL
	DECLARE @V_ENG_PLAN_ID				NVARCHAR(100)	= NULL

	-- DM 참조를 위한 변수
	DECLARE @V_DM_CUTOFF_YYYYMMDD		NVARCHAR(8)		= NULL
	DECLARE @V_DM_VERSION_NO		    NVARCHAR(50) = '';

	-- 실적 구간 참조를 위한 변수
	DECLARE @V_RESULT_FROM_YYYYMM		NVARCHAR(6) = NULL;		-- 과거 실적구간 참조 시작월 (plan date - 52주, 해당월) 
	DECLARE @V_RESULT_FROM_YYYYMMDD		NVARCHAR(8) = NULL;		-- 과거 실적구간 참조 시작일 (plan date - 52주, 해당월 1일) 
	DECLARE @V_RESULT_FROM_DATE			DATE		= NULL;		-- 과거 실적구간 참조 시작일 (plan date - 52주, 해당월 1일) 
	DECLARE @V_RESULT_LAST_YYYYMM		NVARCHAR(6) = NULL;		-- 계획 시작일 기준 전월 

	-- Ending Inventory 참조를 위한 변수
	DECLARE @V_INV_FROM_YYYYMM		NVARCHAR(6) = NULL;	 -- 실적 참조 시작월 
	DECLARE @V_INV_TO_YYYYMM		NVARCHAR(6) = NULL;	 -- plan date 기준 전월

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_RPT_GLOBAL_PSI_STD_DIO'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	-- NERP 매핑코드	--NERP 적용여부에 따라 변경
    --DECLARE @v_B100 NVARCHAR(8);
    --DECLARE @v_C100 NVARCHAR(8);
	--SELECT @v_B100 = DBO.FN_GET_LOOKUP_VALUE('PR_SCP_RPT_GLOBAL_PSI_MD_MM','COMPANY_SALES')
	--SELECT @v_C100 = DBO.FN_GET_LOOKUP_VALUE('PR_SCP_RPT_GLOBAL_PSI_MD_MM','ESOC')


	BEGIN TRY
	  BEGIN

		---------------------------------------------------------------------------------------------------
		-- SCP PLAN 버전 정보 (PRODUCTION) 
		---------------------------------------------------------------------------------------------------
		SELECT TOP 1
			  @V_PLAN_SEQ				= D.PLAN_SEQ
			 ,@V_PLAN_START_YYYYMMDD	= P.PLAN_NAME
			 ,@V_PLAN_START_DATE		= CONVERT(DATE, P.PLAN_NAME, 112) 
			 ,@V_PLAN_START_YYYYMM		= SUBSTRING(P.PLAN_NAME, 1, 6) 
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

		---- 실적 구간 참조를 위한 변수값
		--SET @V_RESULT_FROM_YYYYMM		= CONVERT(NVARCHAR(6), DATEADD(YEAR, -1, CONVERT(DATE, SUBSTRING(@V_PLAN_START_YYYYMMDD,1,4) ,112)), 112)	-- 과거 실적구간 참조 시작월 (plan date - 전년도 1월 해당월) 
		--SET @V_RESULT_FROM_YYYYMMDD		= @V_RESULT_FROM_YYYYMM + '01'																				-- 과거 실적구간 참조 시작일 (plan date - 52주, 해당월 1일) 
		--SET @V_RESULT_FROM_DATE			= CONVERT(DATE, @V_RESULT_FROM_YYYYMMDD, 112)																-- 과거 실적구 scm_mst_site간 참조 시작일 (plan date - 52주, 해당월 1일) 
		--SET @V_RESULT_LAST_YYYYMM		= CONVERT(NVARCHAR(6), DATEADD(MONTH, -1, CONVERT(DATE, @V_PLAN_START_YYYYMMDD, 112)), 112)					-- 계획 시작일 기준 전월 

		---- Ending Inventory 참조를 위한 변수
		--SET @V_INV_FROM_YYYYMM	= @V_RESULT_FROM_YYYYMM												-- 실적 참조 시작월 
		--SET @V_INV_TO_YYYYMM	= CONVERT(NVARCHAR(6),DATEADD(MONTH, -1, @V_PLAN_START_DATE),112)	-- plan date 기준 전월

		-----------------------------------
		---- DM Cutoff YYYYMMDD 
		-----------------------------------
		--SET @V_DM_CUTOFF_YYYYMMDD = CONVERT(CHAR(8), dbo.FN_NEXT_DAY( CONVERT(DATE, @V_PLAN_START_YYYYMMDD, 112), 'TUE'), 112)

		-----------------------------------------------------------------------------------------------------
		---- 참조대상 DM 버전 정보 (FCST 및 RTF 실적)
		-----------------------------------------------------------------------------------------------------
		--SELECT TOP 1 
		--	  @V_DM_VERSION_NO = VERSION_NO 
		-- FROM DM_MST_VERSION  DV with(nolock)
		--WHERE 1=1
		--  AND DV.DIVISION_ID	= @V_DIVISION_ID
		--  AND DV.VERSION_TYPE	= 'MF_W'  
		--  AND DV.YYYYMMDD		= @V_DM_CUTOFF_YYYYMMDD
		--ORDER BY VERSION_NO desc 
		--;

		--PRINT '------------------------------------------------';
		--PRINT '@P_DIVISION_ID			= ' + @P_DIVISION_ID;
		--PRINT '@V_DIVISION_ID			= ' + @V_DIVISION_ID;
		--PRINT '@P_PLAN_START_YYYYMMDD	= ' + ISNULL(@P_PLAN_START_YYYYMMDD,'');
		--PRINT '@V_PLAN_START_DATE		= ' + CONVERT(NVARCHAR(8), @V_PLAN_START_DATE, 112);
		--PRINT '@V_PLAN_START_YYYYMMDD	= ' + @V_PLAN_START_YYYYMMDD;
		--PRINT '@V_PLAN_START_YYYYMM     = ' + @V_PLAN_START_YYYYMM;
		--PRINT '@V_HORIZON_END_YYYYMMDD	= ' + @V_HORIZON_END_YYYYMMDD;
		--PRINT '@V_PLAN_SEQ				= ' + CONVERT(NVARCHAR(10), @V_PLAN_SEQ);
		--PRINT '@V_MASTER_ID			    = ' + @V_MASTER_ID;
		--PRINT '@V_ENG_PLAN_ID			= ' + @V_ENG_PLAN_ID;
		---- for DM
		--PRINT '@V_DM_CUTOFF_YYYYMMDD	= ' + @V_DM_CUTOFF_YYYYMMDD;
		--PRINT '@V_DM_VERSION_NO			= ' + @V_DM_VERSION_NO;
		---- for Result 
		--PRINT '@V_RESULT_FROM_YYYYMMDD	= ' + @V_RESULT_FROM_YYYYMMDD;
		--PRINT '@V_RESULT_FROM_DATE		= ' + CONVERT(NVARCHAR(8), @V_RESULT_FROM_DATE, 112);
		--PRINT '@V_RESULT_FROM_YYYYMM	= ' + @V_RESULT_FROM_YYYYMM;
		--PRINT '@V_RESULT_LAST_YYYYMM	= ' + @V_RESULT_LAST_YYYYMM;
		---- Ending Inventory 참조를 위한 변수
		--PRINT '@V_INV_FROM_YYYYMM		= ' + @V_INV_FROM_YYYYMM;
		--PRINT '@V_INV_TO_YYYYMM			= ' + @V_INV_TO_YYYYMM;
		--PRINT '------------------------------------------------';

		-----------------------------------------------------------------------------------------------------
		--print  convert(varchar(30), getdate(), 121) + N' ### 기간 정보 : 데이터생성 범위 날짜 목록' 
		-----------------------------------------------------------------------------------------------------
		--IF OBJECT_ID('TEMPDB..#TMP_DATE_INFO') IS NOT NULL
		--	DROP TABLE #TMP_DATE_INFO

		--SELECT BC.YYYYMMDD
		--	  ,BC.YYYYMM
		--	  ,MIN(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYMM) AS MONTHLY_FROM_YMD
		--	  ,MAX(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYMM) AS MONTHLY_TO_YMD
		--	  ,COUNT(BC.YYYYMMDD)	OVER (PARTITION BY BC.YYYYMM) AS MM_DAYS
		--	  ,BC.YYYYWW
		--	  ,MIN(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYWW) AS WEEKLY_FROM_YMD
		--	  ,MAX(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYWW) AS WEEKLY_TO_YMD
		--	  ,COUNT(BC.YYYYMMDD)	OVER (PARTITION BY BC.YYYYWW) AS WK_DAYS
		--	  ,BC.YYYYPW
		--	  ,MIN(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYPW) AS P_WEEKLY_FROM_YMD
		--	  ,MAX(BC.YYYYMMDD)		OVER (PARTITION BY BC.YYYYPW) AS P_WEEKLY_TO_YMD
		--	  ,COUNT(BC.YYYYMMDD)	OVER (PARTITION BY BC.YYYYPW) AS PWK_DAYS
		-- INTO #TMP_DATE_INFO
		-- FROM SCM_MST_BUCKET BC WITH(NOLOCK)
		--WHERE 1=1
		--  AND BC.YYYYMMDD BETWEEN @V_RESULT_FROM_YYYYMMDD -- 실적 참조 시작일 
		--				      AND @V_HORIZON_END_YYYYMMDD -- 계획 참조 종료일


	----- Begin Tran : 월별 Global PSI 본테이블에 Delete/Insert=======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		IF @V_SERCH_LEVEL IS NULL AND @V_SERCH_LEVEL IS NULL
	  	BEGIN
	  		
		  	-----------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### MERGE FROM SCP_RPT_GLOBAL_PSI_MD_MM  ' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------
			MERGE SCP_RPT_GLOBAL_PSI_MD_MM AS PR
			USING (
						SELECT	PLAN_MONTH, DIVISION_ID, GROUP_NAME AS ITEM_ID, YYYYMM, STD_DIO AS QTY, 'STD_DIO' AS MEASURE
						FROM	[SCP_ANL_DIO_GROUP_RESULT] WITH(NOLOCK)
						WHERE 1=1
							AND GROUP_LEVEL = 'CELL_GROUP'
							AND DIVISION_ID	= @V_DIVISION_ID
							AND ATTRIBUTE1 = (
										SELECT MAX (ATTRIBUTE1)
										FROM [SCP_ANL_DIO_GROUP_RESULT]
										WHERE 1=1
										AND DIVISION_ID	= @V_DIVISION_ID
										AND	ATTRIBUTE1 <= @P_PLAN_START_YYYYMMDD
								)
						UNION ALL
						SELECT	PLAN_MONTH, DIVISION_ID, GROUP_NAME AS ITEM_ID, YYYYMM, STD_DIO_SALES AS QTY, 'STD_DIO_SALES' AS MEASURE
						FROM [SCP_ANL_DIO_GROUP_RESULT] WITH(NOLOCK)
						WHERE 1=1
							AND GROUP_LEVEL = 'CELL_GROUP'
							AND DIVISION_ID	= @V_DIVISION_ID
							AND ATTRIBUTE1 = (
										SELECT MAX (ATTRIBUTE1)
										FROM [SCP_ANL_DIO_GROUP_RESULT]
										WHERE 1=1
										AND DIVISION_ID	= @V_DIVISION_ID
										AND	ATTRIBUTE1 <= @P_PLAN_START_YYYYMMDD
								)
						UNION ALL
						SELECT	PLAN_MONTH, DIVISION_ID, GROUP_NAME AS ITEM_ID, YYYYMM, STD_DIO_PACK AS QTY, 'STD_DIO_PACK' AS MEASURE
						FROM [SCP_ANL_DIO_GROUP_RESULT] WITH(NOLOCK)
						WHERE 1=1
							AND GROUP_LEVEL = 'CELL_GROUP'
							AND DIVISION_ID	= @V_DIVISION_ID
							AND ATTRIBUTE1 = (
										SELECT MAX (ATTRIBUTE1)
										FROM [SCP_ANL_DIO_GROUP_RESULT]
										WHERE 1=1
										AND DIVISION_ID	= @V_DIVISION_ID
										AND	ATTRIBUTE1 <= @P_PLAN_START_YYYYMMDD
								)
						UNION ALL
						SELECT	PLAN_MONTH, DIVISION_ID, GROUP_NAME AS ITEM_ID, YYYYMM, STD_DIO_CELL AS QTY, 'STD_DIO_CELL' AS MEASURE
						FROM [SCP_ANL_DIO_GROUP_RESULT] WITH(NOLOCK)
						WHERE 1=1
							AND GROUP_LEVEL = 'CELL_GROUP'
							AND DIVISION_ID	= @V_DIVISION_ID
							AND ATTRIBUTE1 = (
										SELECT MAX (ATTRIBUTE1)
										FROM [SCP_ANL_DIO_GROUP_RESULT]
										WHERE 1=1
										AND DIVISION_ID	= @V_DIVISION_ID
										AND	ATTRIBUTE1 <= @P_PLAN_START_YYYYMMDD
								)
					) AS X
				ON 	1=1
				AND PR.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
				AND PR.DIVISION_ID	= @V_DIVISION_ID
				AND PR.PLAN_TYPE	= @V_PLAN_TYPE		-- E20260708-000926
				AND X.DIVISION_ID	= PR.DIVISION_ID
				AND X.YYYYMM		= PR.YYYYMM
				AND X.ITEM_ID		= PR.ITEM_ID
				AND X.MEASURE		= PR.MEASURE
			WHEN MATCHED  THEN
				UPDATE	SET	PR.QTY	= ISNULL(X.QTY,0)
				, LAST_UPDATED_BY	= 'STD_UP'
				, LAST_UPDATE_DATE	= GETDATE()
				;
			
			-----------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### MERGE FROM SCP_RPT_GLOBAL_PSI_MD_WW  ' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------
			MERGE SCP_RPT_GLOBAL_PSI_MD_WW AS PR
			USING (
						SELECT	DISTINCT A.DIVISION_ID, A.ITEM_ID, A.YYYYMM, A.QTY, A.MEASURE, B.YYYYPW
						FROM	(
									SELECT	PLAN_MONTH, DIVISION_ID, GROUP_NAME AS ITEM_ID, YYYYMM, STD_DIO AS QTY, 'STD_DIO' AS MEASURE
									FROM	[SCP_ANL_DIO_GROUP_RESULT] WITH(NOLOCK)
									WHERE 1=1
										AND GROUP_LEVEL = 'CELL_GROUP'
										AND DIVISION_ID	= @V_DIVISION_ID
										AND ATTRIBUTE1 = (
													SELECT MAX (ATTRIBUTE1)
													FROM [SCP_ANL_DIO_GROUP_RESULT]
													WHERE 1=1
													AND DIVISION_ID	= @V_DIVISION_ID
													AND	ATTRIBUTE1 <= @P_PLAN_START_YYYYMMDD
											)
									UNION ALL
									SELECT	PLAN_MONTH, DIVISION_ID, GROUP_NAME AS ITEM_ID, YYYYMM, STD_DIO_SALES AS QTY, 'STD_DIO_SALES' AS MEASURE
									FROM [SCP_ANL_DIO_GROUP_RESULT] WITH(NOLOCK)
									WHERE 1=1
										AND GROUP_LEVEL = 'CELL_GROUP'
										AND DIVISION_ID	= @V_DIVISION_ID
										AND ATTRIBUTE1 = (
													SELECT MAX (ATTRIBUTE1)
													FROM [SCP_ANL_DIO_GROUP_RESULT]
													WHERE 1=1
													AND DIVISION_ID	= @V_DIVISION_ID
													AND	ATTRIBUTE1 <= @P_PLAN_START_YYYYMMDD
											)
									UNION ALL
									SELECT	PLAN_MONTH, DIVISION_ID, GROUP_NAME AS ITEM_ID, YYYYMM, STD_DIO_PACK AS QTY, 'STD_DIO_PACK' AS MEASURE
									FROM [SCP_ANL_DIO_GROUP_RESULT] WITH(NOLOCK)
									WHERE 1=1
										AND GROUP_LEVEL = 'CELL_GROUP'
										AND DIVISION_ID	= @V_DIVISION_ID
										AND ATTRIBUTE1 = (
													SELECT MAX (ATTRIBUTE1)
													FROM [SCP_ANL_DIO_GROUP_RESULT]
													WHERE 1=1
													AND DIVISION_ID	= @V_DIVISION_ID
													AND	ATTRIBUTE1 <= @P_PLAN_START_YYYYMMDD
											)
									UNION ALL
									SELECT	PLAN_MONTH, DIVISION_ID, GROUP_NAME AS ITEM_ID, YYYYMM, STD_DIO_CELL AS QTY, 'STD_DIO_CELL' AS MEASURE
									FROM [SCP_ANL_DIO_GROUP_RESULT] WITH(NOLOCK)
									WHERE 1=1
										AND GROUP_LEVEL = 'CELL_GROUP'
										AND DIVISION_ID	= @V_DIVISION_ID
										AND ATTRIBUTE1 = (
													SELECT MAX (ATTRIBUTE1)
													FROM [SCP_ANL_DIO_GROUP_RESULT]
													WHERE 1=1
													AND DIVISION_ID	= @V_DIVISION_ID
													AND	ATTRIBUTE1 <= @P_PLAN_START_YYYYMMDD
											)
								) A
							   ,SCM_MST_BUCKET B WITH(NOLOCK)
						WHERE 1=1
						  AND A.YYYYMM = B.YYYYMM
					) AS X
				ON 	1=1
				AND PR.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
				AND PR.DIVISION_ID	= @V_DIVISION_ID
				AND PR.PLAN_TYPE	= @V_PLAN_TYPE		-- E20260708-000926
				AND X.DIVISION_ID	= PR.DIVISION_ID
				AND X.YYYYPW		= PR.YYYYPW
				AND X.ITEM_ID		= PR.ITEM_ID
				AND X.MEASURE		= PR.MEASURE
			WHEN MATCHED  THEN
				UPDATE	SET	PR.QTY	= ISNULL(X.QTY,0)
				, LAST_UPDATED_BY	= 'STD_UP'
				, LAST_UPDATE_DATE	= GETDATE()
				;
			
	  	END

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	  COMMIT TRAN ;  --- transaction 종료  
	----- End Tran : 월별 Global PSI 본테이블에 Delete/Insert==========================================================================================================

		---------------------------------------
		-- 임시테이블 정리
		---------------------------------------
		--IF OBJECT_ID('tempdb..#TMP_DATE_INFO') IS NOT NULL	
		--	DROP TABLE #TMP_DATE_INFO;
		
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
	PRINT @v_log_message   + ' : ' + @v_description ;   

END
