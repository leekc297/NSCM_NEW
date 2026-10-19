/*
 * Program ID   : SCP0075_SAVE_ALLO_TARGET_SMAL
 * Description  : Allo Target 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/11/17   LWY			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - Allo Target 수정 신규
   2022/03/22   LWY			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - Process 개선
 *
 */
/*
 DECLARE
     @P_ACTIVE_FLAG         NVARCHAR(MAX) = 'M^M^M'
	,@P_DIVISION_ID			NVARCHAR(MAX) = '40^40^40'
	,@P_EXTRA_SPEC			NVARCHAR(MAX) = '18650^18650^18650'
	,@P_CUTOFF_YYYYMMDD     NVARCHAR(MAX) = '20220321^20220321^20220321'
	,@P_DEPT_ID				NVARCHAR(MAX) = '58520274^70000478^70021343'
	,@P_NICK_NAME           NVARCHAR(MAX) = 'F1L^F1L^F1L'
	,@P_ITEM_ID             NVARCHAR(MAX) = 'MCCE132502A1^MCCE132502A1^MCCE132502A1'
	,@P_QTY                 NVARCHAR(MAX) = '1^2^3'
	,@P_YYYY	 			NVARCHAR(MAX) = '2022^2022^2022'
	,@P_YYYYMM   			NVARCHAR(MAX) = '202203^202203^202203'
	,@P_YYYYQQ  			NVARCHAR(MAX) = '2022Q1^2022Q1^2022Q1'
	,@P_PROGRAM_ID			NVARCHAR(10) = 'SCP0075'
*/

CREATE PROCEDURE [dbo].[SCP0075_SAVE_ALLO_TARGET_SMALL]
     @P_ACTIVE_FLAG         NVARCHAR(MAX)
	,@P_DIVISION_ID			NVARCHAR(MAX)
	,@P_EXTRA_SPEC			NVARCHAR(MAX)	
	,@P_CUTOFF_YYYYMMDD     NVARCHAR(MAX)
	,@P_DEPT_ID				NVARCHAR(MAX)
	,@P_NICK_NAME           NVARCHAR(MAX)  -- MODEL
	,@P_ITEM_ID             NVARCHAR(MAX)
	,@P_QTY                 NVARCHAR(MAX)
	,@P_YYYY	 			NVARCHAR(MAX)
	,@P_YYYYMM   			NVARCHAR(MAX)
	,@P_YYYYQQ  			NVARCHAR(MAX)
	,@P_PROGRAM_ID			NVARCHAR(10) = 'SCP0075'
AS

BEGIN

	/********************************************************************************      
	* 임시테이블만들기
	********************************************************************************/ 
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0075_Allo_Target') IS NOT NULL
	DROP TABLE #TblDynamic_SCP0075_Allo_Target;
	
	CREATE TABLE #TblDynamic_SCP0075_Allo_Target (
		 ACTIVE_FLAG			NVARCHAR(1)
		,DIVISION_ID			NVARCHAR(20)
		,TYPE                   NVARCHAR(20)
		,EXTRA_SPEC				NVARCHAR(100)
		,CUTOFF_YYYYMMDD		NVARCHAR(16)
		,DEPT_ID				NVARCHAR(100)
		,NICK_NAME				NVARCHAR(100)
		,ITEM_ID				NVARCHAR(100)
		--,QTY					NUMERIC(17,10)
		,QTY					NVARCHAR(MAX)
		,YYYY                   NVARCHAR(4)
		,YYYYMM                 NVARCHAR(6)
		,YYYYQQ                 NVARCHAR(6)
	);

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	DECLARE @recv_division_id		NVARCHAR(MAX);
	SET @recv_division_id = NULL;		
	SET @recv_division_id = @p_division_id;

	DECLARE @V_ACTIVE_FLAG		NVARCHAR(MAX);
	DECLARE @V_DIVISION_ID		NVARCHAR(MAX);
	DECLARE @V_TYPE		        NVARCHAR(MAX);
	DECLARE @V_EXTRA_SPEC		NVARCHAR(MAX);
	DECLARE @V_CUTOFF_YYYYMMDD	NVARCHAR(MAX);
	DECLARE @V_DEPT_ID			NVARCHAR(MAX);
	DECLARE @V_NICK_NAME		NVARCHAR(MAX);
	DECLARE @V_ITEM_ID			NVARCHAR(MAX);
	DECLARE @V_QTY				NVARCHAR(MAX);
	DECLARE @V_YYYY				NVARCHAR(MAX);
	DECLARE @V_YYYYMM			NVARCHAR(MAX);
	DECLARE @V_YYYYQQ			NVARCHAR(MAX);

	SET @V_ACTIVE_FLAG		= NULL;
	SET @V_DIVISION_ID		= NULL;
	SET @V_TYPE		        = 'PLAN';
	SET @V_EXTRA_SPEC		= NULL;
	SET @V_CUTOFF_YYYYMMDD	= NULL;
	SET @V_DEPT_ID			= NULL;
	SET @V_NICK_NAME		= NULL;
	SET @V_ITEM_ID			= NULL;
	SET @V_QTY				= NULL;
	SET @V_YYYY				= NULL;
	SET @V_YYYYMM			= NULL;
	SET @V_YYYYQQ			= NULL;

	-- Local 변수
	DECLARE @V_CREATED_BY NVARCHAR(20) = 'scm_batch';

	-- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = 'SCP0075_SAVE_ALLO_TARGET_SMALL';
	DECLARE @v_log_type     NVARCHAR(30);
	DECLARE @n_log_count    INTEGER = 0;
	DECLARE @v_log_message  NVARCHAR(1000);
	DECLARE @v_description  NVARCHAR(500);
	DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_item_id, @v_delimiter);    


		/*** 1. 신규건 MEASURE별 입력데이터 정리   *****/
		WHILE LEN(@recv_division_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @V_ACTIVE_FLAG		= [dbo].[SCM_ARR_SPL_VAL](@P_ACTIVE_FLAG,		@v_delimiter, @mst_loop_cnt);				
				SET @V_DIVISION_ID		= [dbo].[SCM_ARR_SPL_VAL](@P_DIVISION_ID,		@v_delimiter, @mst_loop_cnt);				
				SET @V_EXTRA_SPEC		= [dbo].[SCM_ARR_SPL_VAL](@P_EXTRA_SPEC,		@v_delimiter, @mst_loop_cnt);				
				SET @V_CUTOFF_YYYYMMDD	= [dbo].[SCM_ARR_SPL_VAL](@P_CUTOFF_YYYYMMDD,	@v_delimiter, @mst_loop_cnt);
				SET @V_DEPT_ID			= [dbo].[SCM_ARR_SPL_VAL](@P_DEPT_ID,			@v_delimiter, @mst_loop_cnt);
				SET @V_NICK_NAME		= [dbo].[SCM_ARR_SPL_VAL](@P_NICK_NAME,			@v_delimiter, @mst_loop_cnt);
				SET @V_ITEM_ID			= [dbo].[SCM_ARR_SPL_VAL](@P_ITEM_ID,			@v_delimiter, @mst_loop_cnt);
				SET @v_qty				= [dbo].[SCM_ARR_SPL_VAL](@P_QTY,				@v_delimiter, @mst_loop_cnt);
				SET @V_YYYY				= [dbo].[SCM_ARR_SPL_VAL](@P_YYYY,				@v_delimiter, @mst_loop_cnt);
				SET @V_YYYYMM			= [dbo].[SCM_ARR_SPL_VAL](@P_YYYYMM,			@v_delimiter, @mst_loop_cnt);
				SET @V_YYYYQQ			= [dbo].[SCM_ARR_SPL_VAL](@P_YYYYQQ,			@v_delimiter, @mst_loop_cnt);

			END
			;

			INSERT INTO #TblDynamic_SCP0075_Allo_Target
			SELECT    @V_ACTIVE_FLAG		AS ACTIVE_FLAG
					, @V_DIVISION_ID		AS DIVISION_ID
					, @V_TYPE               AS TYPE
					, @V_EXTRA_SPEC			AS EXTRA_SPEC
					, @V_CUTOFF_YYYYMMDD	AS CUTOFF_YYYYMMDD
					, (CASE WHEN @V_DEPT_ID = '' THEN NULL ELSE @V_DEPT_ID END) AS DEPT_ID
					, @V_NICK_NAME			AS NICK_NAME
					, @V_ITEM_ID			AS ITEM_ID
					, @v_qty				AS QTY
					, @V_YYYY				AS YYYY
					, @V_YYYYMM				AS YYYYMM
					, @V_YYYYQQ				AS YYYYQQ
			;

		END  -- while end
		
		

		MERGE INTO SCP_ANL_ALLO_TARGET A
		USING (
				SELECT ACTIVE_FLAG, DIVISION_ID, TYPE, EXTRA_SPEC, CUTOFF_YYYYMMDD, DEPT_ID, NICK_NAME, ITEM_ID, QTY, YYYY, YYYYMM, YYYYQQ
				FROM #TblDynamic_SCP0075_Allo_Target
              ) AS B
			
			ON A.DIVISION_ID		= B.DIVISION_ID
			AND A.CUTOFF_YYYYMMDD	= B.CUTOFF_YYYYMMDD
			AND A.YYYY			    = B.YYYY
			AND A.YYYYMM			= B.YYYYMM
			AND A.YYYYQQ			= B.YYYYQQ
			AND A.ITEM_ID			= B.ITEM_ID		
			AND ISNULL(A.DEPT_ID, '') = ISNULL(B.DEPT_ID, '') 
			AND A.NICK_NAME		    = B.NICK_NAME
			AND A.EXTRA_SPEC		= B.EXTRA_SPEC		
			AND A.TYPE = B.TYPE

		WHEN MATCHED THEN
	  
		UPDATE 
			SET A.QTY = B.QTY
			   ,LAST_UPDATED_BY  = @V_CREATED_BY
			   ,LAST_UPDATE_DATE = SYSDATETIME()
					  
		WHEN NOT MATCHED THEN
		INSERT (
				 DIVISION_ID
				,TYPE
				,CUTOFF_YYYYMMDD
				,YYYY
				,YYYYQQ
				,YYYYMM
				,YYYYMMDD
				,ITEM_ID
				,DEPT_ID
				,DEPT_NAME
				,QTY
				,NICK_NAME
				,EXTRA_SPEC
				,SCM_SITE_ID
				,SCM_SITE_NAME
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
		VALUES (
				 B.DIVISION_ID
				,B.TYPE             -- 'PLAN'
				,B.CUTOFF_YYYYMMDD
				,B.YYYY
				,B.YYYYQQ
				,B.YYYYMM
				,NULL              -- YYYYMMDD
				,B.ITEM_ID
				,B.DEPT_ID
				,NULL              -- DEPT_NAME
				,B.QTY
				,B.NICK_NAME
				,B.EXTRA_SPEC
				,NULL              -- SCM_SITE_ID
				,NULL              -- SCM_SITE_NAME
				, @V_CREATED_BY
				, SYSDATETIME()
				, @V_CREATED_BY
				, SYSDATETIME()
				)
	 ;
	  

	  -----------------------------------------------------------
	  -- Merge LOG
	  -----------------------------------------------------------
	  SET @n_log_count = @@ROWCOUNT;
	  SET @v_log_type = 'APPEND';
	  SET @v_log_message = '1. MERGE INTO SCP_ANL_ALLO_TARGET';
	  SET @v_description = 'Allo Target Merge ';
	  SET @d_event_date = SYSDATETIME();
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- LOG
		SELECT 'S' AS RESULT_CODE, '' AS MSG

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
			BEGIN
			INSERT INTO scm_sys_log_batch (program_name
											,log_type
											,log_count
											,log_message
											,description
											,event_date
											,creation_date
											,created_by
											,last_update_date
											,last_updated_by)
			VALUES (ERROR_PROCEDURE()
					,'ERROR'
					,NULL
					,ERROR_MESSAGE()
					,NULL
					,SYSDATETIME()
					,SYSDATETIME()
					,ERROR_PROCEDURE()
					,SYSDATETIME()
					,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
				COMMIT WORK;
			END;

			-- error코드, errror 메시지 반환
			IF( @v_err_message IS NULL OR @v_err_message ='')
				SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
			ELSE
				SELECT 'N' AS result_code, @v_err_message AS ERR_MESSAGE ;

			--SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
			--SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;



	IF OBJECT_ID('tempdb..#TblDynamic_SCP0075_Allo_Target') IS NOT NULL
	DROP TABLE #TblDynamic_SCP0075_Allo_Target;
 
END










