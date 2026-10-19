


/*      
 * Program ID  : [PR_SCP_SHIPMENT_ALLO_TARGET_40_PLAN]      
 * Description : Ship Plan Amend수량 Allo Targe에 반영 (SHIPMENT PLAN FG) 
 *				 - 매주 금요일에 당주 월요일에 생성된 Allo Target Plan정보를 삭제하고
 *			       당주 MA plan의 Shipment Plan Amend 수량으로 Allo Target Plan정보를 재생성한다.
 * Execute     : 
 				 
				 EXEC [dbo].[PR_SCP_SHIPMENT_ALLO_TARGET_40_PLAN]
						@P_DIVISION_ID = N'40',
						@P_CUTOFF_YYYYMMDD = N'20220711'
 *
 * Program History      
 *=========================================================================================================================      
 *   Date		In Charge	Description      
 *=========================================================================================================================      
 * 2022/07/18	hrkim		Initial Release  [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2
 * 2023/01/10	hrkim		[PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 : Cell 원통형만 대상으로 함
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_SHIPMENT_ALLO_TARGET_40_PLAN] 
	@P_DIVISION_ID		        NVARCHAR(30) = '40',
	@P_CUTOFF_YYYYMMDD			NVARCHAR(8) = NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	IF ISNULL(@P_CUTOFF_YYYYMMDD, '') = ''
	   SET @P_CUTOFF_YYYYMMDD =  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_SHIPMENT_ALLO_TARGET_40_PLAN'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'PR_SCP_SHIPMENT_ALLO_TARGET_40_PLAN'; 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '##### Start of procedure #####';     
    SET @v_description = @p_division_id + ' : ' + @P_CUTOFF_YYYYMMDD  ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)
				
	BEGIN
		PRINT '----------------------------------------';
		PRINT '@P_DIVISION_ID =' + @P_DIVISION_ID;
		PRINT '@P_CUTOFF_YYYYMMDD =' + @P_CUTOFF_YYYYMMDD;
		PRINT '----------------------------------------';
	END;

	BEGIN TRY

		IF OBJECT_ID('TEMPDB..#PLAN_INFO') IS NOT NULL DROP TABLE #PLAN_INFO;
		-- PLAN 버전 정보 
		SELECT P.DIVISION_ID
			 , P.PLAN_NAME	AS PLAN_START_YYYYMMDD
			 , D.PLAN_TYPE
			 , D.PLAN_SEQ
		 INTO #PLAN_INFO
		 FROM SCM_MST_PLAN  P WITH(NOLOCK)
			  INNER JOIN SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
					  ON D.DIVISION_ID  = P.DIVISION_ID
					 AND D.PLAN_ID      = P.PLAN_ID
					 AND D.PLAN_TYPE    = 'MA' -- MA 고정 7/19 FN에서 MA로 변경 (신재욱 책임)
					 AND D.PLAN_STATUS  = '1'  -- 정상 완료
					 AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm
		WHERE 1=1
		  AND P.DIVISION_ID  = @P_DIVISION_ID		-- 변수 처리
		  AND P.PLAN_NAME    = @P_CUTOFF_YYYYMMDD	-- 변수 처리 : 당주 월요일
		  AND P.PLAN_CYCLE   = 'WEEKLY'


		IF OBJECT_ID('TEMPDB..#DEPT_INFO_40') IS NOT NULL DROP TABLE #DEPT_INFO_40;
		-- SITE ITEM 부서 정보 
		;WITH DEPT_INFO AS (
			SELECT SI.DIVISION_ID
				  ,SI.SCM_SITE_ID
				  ,SI.ITEM_ID
				  ,SI.PROJECT_CODE
				  ,UI.DEPT_ID
				  ,ROW_NUMBER() OVER (PARTITION BY SI.DIVISION_ID
												  ,SI.SCM_SITE_ID
												  ,SI.ITEM_ID
										  ORDER BY SI.CREATION_DATE DESC 
												  ,SI.PROJECT_CODE)  AS PJT_PRIORITY
			 FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK)
				  INNER JOIN SCM_MST_SSO_USER_INFO UI WITH(NOLOCK)
						  ON UI.USER_ID = (SELECT TOP 1 token FROM dbo.String_Split(SI.OWNER, ','))    
			WHERE 1=1
			  AND SI.DIVISION_ID = '40'
			  AND SI.VALID_YN = 'Y'
		)
		SELECT *
		  INTO #DEPT_INFO_40
		  FROM DEPT_INFO


		IF OBJECT_ID('TEMPDB..#ITEM_INFO') IS NOT NULL DROP TABLE #ITEM_INFO;
		-- ITEM 정보  
		SELECT MI.DIVISION_ID 
			  ,MI.ITEM_ID
			  ,MAX(MI.NICK_NAME)		AS NICK_NAME
			  ,MAX(MI.SCP_EXTRA_SPEC)	AS EXTRA_SPEC
		 INTO #ITEM_INFO
		 FROM SCM_MST_ITEM_SN MI WITH(NOLOCK)
			  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) -- 2023.01.10 Cell 원통형만 대상 
					  ON FI.DIVISION_ID = MI.DIVISION_ID
					 AND FI.ITEM_ID	    = MI.ITEM_ID
					 AND FI.OPERATION_GROUP			= 'A'	-- Cell
					 AND FI.CELL_TYPE_GROUP_CODE	= 'C'	-- 원통형
		WHERE 1=1
		 AND MI.DIVISION_ID = @P_DIVISION_ID
		GROUP BY MI.DIVISION_ID 
				,MI.ITEM_ID

 		-----------------------------------------------------------
		-- TXN LOG
		-----------------------------------------------------------
		SET @v_log_type = 'TXN';
		SET @v_log_message = N'INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG';
		SET @D_EVENT_DATE = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		IF OBJECT_ID('TEMPDB..#tmp_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG;
		-- SHIP_PLAN_AMEND 
 		SELECT SP.DIVISION_ID
			  ,SP.PLAN_START_YYYYMMDD
			  ,SP.TO_SITE
			  ,SP.ITEM_ID
			  ,SP.PROJECT_CODE
			  ,SP.YYYYMMDD
			  ,SP.QTY
		 INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG
		 FROM SCP_ANL_SHIPMENT_PLAN_FG SP 
			  INNER JOIN #PLAN_INFO PV WITH(NOLOCK)
					  ON SP.DIVISION_ID			= PV.DIVISION_ID	
					 AND SP.PLAN_START_YYYYMMDD	= PV.PLAN_START_YYYYMMDD
					 AND SP.PLAN_TYPE			= PV.PLAN_TYPE
					 AND SP.SEQ					= PV.PLAN_SEQ
					 AND SP.MEASURE				= 'SHIP_PLAN_AMEND'
		WHERE 1=1
		  AND SP.QTY != 0 

		BEGIN

 			-----------------------------------------------------------
			-- TXN LOG
			-----------------------------------------------------------
			SET @v_log_type = 'TXN';
			SET @v_log_message = N'DELETE FROM SCP_ANL_ALLO_TARGET';
			SET @D_EVENT_DATE = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-------------------------------------------------------------------------------------------------
			-- 1. DELETE (TYPE=PLAN)
			-------------------------------------------------------------------------------------------------
			BEGIN TRAN
 				WHILE (1=1)
 					BEGIN
 						DELETE TOP(1000) DBO.SCP_ANL_ALLO_TARGET
					     WHERE DIVISION_ID     = @P_DIVISION_ID
						   AND CUTOFF_YYYYMMDD = @P_CUTOFF_YYYYMMDD
						   AND TYPE            = 'PLAN'
				
 	 					IF @@ROWCOUNT = 0 BREAK;
 					END
					COMMIT;

 			-----------------------------------------------------------
			-- TXN LOG
			-----------------------------------------------------------
			SET @v_log_type = 'TXN';
			SET @v_log_message = N'BEGIN - INSERT INTO SCP_ANL_ALLO_TARGET';
			SET @D_EVENT_DATE = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-------------------------------------------------------------------------------------------------
			-- 2. INSERT (TYPE=PLAN)
			-- SCM팀 amend한 allo수량을 allo target에 반영 (Shipment plan FG 수량 : SHIP_PLAN_AMEND measure) 
			-------------------------------------------------------------------------------------------------
			;WITH SHIP_PLAN_AMEND AS (
				-- Shipment Plan Amend 정보 
				SELECT SP.DIVISION_ID
					  ,SP.PLAN_START_YYYYMMDD							AS CUTOFF_YYYYMMDD
					  ,BC.YYYY
					  ,CONCAT(BC.YYYY, 'Q', DATEPART(QQ, CONVERT(DATE, BC.YYYYMMDD, 112)))	AS YYYYQQ
					  ,BC.YYYYMM
					  ,SP.ITEM_ID
					  ,CASE WHEN SP.DIVISION_ID = '40'
							THEN ISNULL(DI.DEPT_ID, DI2.DEPT_ID)
							ELSE TS.DEPT_ID
					   END												AS DEPT_ID
					  ,SUM(QTY)											AS QTY
				 FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG SP WITH(NOLOCK)
					  INNER JOIN SCM_MST_BUCKET BC WITH(NOLOCK)
	 						  ON BC.YYYYMMDD      = SP.YYYYMMDD 
					  LEFT  JOIN SCM_MST_SITE TS WITH(NOLOCK)
							  ON TS.DIVISION_ID   = SP.DIVISION_ID
							 AND TS.SCM_SITE_ID   = SP.TO_SITE 
							 AND TS.SITE_TYPE     = 'SALES'
					  LEFT  JOIN #DEPT_INFO_40 DI WITH(NOLOCK)
	 						  ON DI.DIVISION_ID   = SP.DIVISION_ID
	 						 AND DI.SCM_SITE_ID   = SP.TO_SITE
	 						 AND DI.ITEM_ID       = SP.ITEM_ID 
							 AND DI.PROJECT_CODE  = SP.PROJECT_CODE
					  LEFT  JOIN #DEPT_INFO_40 DI2 WITH(NOLOCK)
	 						  ON DI2.DIVISION_ID  = SP.DIVISION_ID
	 						 AND DI2.SCM_SITE_ID  = SP.TO_SITE
	 						 AND DI2.ITEM_ID      = SP.ITEM_ID 
							 AND DI2.PJT_PRIORITY = 1
				WHERE 1=1
				GROUP BY SP.DIVISION_ID
						,SP.PLAN_START_YYYYMMDD
						,BC.YYYY
						,CONCAT(BC.YYYY, 'Q', DATEPART(QQ, CONVERT(DATE, BC.YYYYMMDD, 112)))
						,BC.YYYYMM
						,SP.ITEM_ID
						,CASE WHEN SP.DIVISION_ID = '40'
							  THEN ISNULL(DI.DEPT_ID, DI2.DEPT_ID)
							  ELSE TS.DEPT_ID
						 END
			)
			INSERT INTO SCP_ANL_ALLO_TARGET   
					  ( DIVISION_ID
					   ,TYPE
					   ,CUTOFF_YYYYMMDD
					   ,YYYY
					   ,YYYYQQ
					   ,YYYYMM
					   ,ITEM_ID
					   ,DEPT_ID
					   ,NICK_NAME
					   ,EXTRA_SPEC
					   ,QTY
					   ,CREATED_BY
					   ,CREATION_DATE
					   ,LAST_UPDATED_BY
					   ,LAST_UPDATE_DATE 
					   )
			SELECT SP.DIVISION_ID
				  ,'PLAN'			AS TYPE
				  ,SP.CUTOFF_YYYYMMDD
				  ,SP.YYYY
				  ,SP.YYYYQQ
				  ,SP.YYYYMM
				  ,SP.ITEM_ID
				  ,SP.DEPT_ID
				  ,II.NICK_NAME
				  ,II.EXTRA_SPEC
				  ,SUM(QTY)			AS QTY
				  ,@v_batch_user	AS CREATED_BY
				  ,GETDATE()		AS CREATION_DATE
				  ,@v_batch_user	AS LAST_UPDATED_BY
				  ,GETDATE()		AS LAST_UPDATE_DATE 
			 FROM SHIP_PLAN_AMEND SP WITH(NOLOCK)
				  INNER JOIN #ITEM_INFO II WITH(NOLOCK)
	 					  ON II.DIVISION_ID = SP.DIVISION_ID
						 AND II.ITEM_ID		= SP.ITEM_ID
			WHERE 1=1
		  GROUP BY SP.DIVISION_ID
				  ,SP.CUTOFF_YYYYMMDD
				  ,SP.YYYY
				  ,SP.YYYYQQ
				  ,SP.YYYYMM
				  ,SP.ITEM_ID
				  ,SP.DEPT_ID
				  ,II.NICK_NAME
				  ,II.EXTRA_SPEC
			;

		END			    

 		-----------------------------------------------------------
		-- TXN LOG
		-----------------------------------------------------------
		SET @v_log_type = 'TXN';
		SET @v_log_message = N'END - INSERT INTO SCP_ANL_ALLO_TARGET';
		SET @D_EVENT_DATE = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		IF OBJECT_ID('TEMPDB..#PLAN_INFO') IS NOT NULL						DROP TABLE #PLAN_INFO;
		IF OBJECT_ID('TEMPDB..#ITEM_INFO') IS NOT NULL						DROP TABLE #ITEM_INFO;
		IF OBJECT_ID('TEMPDB..#DEPT_INFO_40') IS NOT NULL					DROP TABLE #DEPT_INFO_40;
		IF OBJECT_ID('TEMPDB..#tmp_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL	DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG;

     END TRY

     BEGIN CATCH                  
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
    SET @v_description = N'['  + @v_exec_time + ']';             
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
    RETURN 1;                
                  
END
