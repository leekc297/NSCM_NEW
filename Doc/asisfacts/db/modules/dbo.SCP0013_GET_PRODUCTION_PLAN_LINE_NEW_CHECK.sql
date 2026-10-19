
/*
 * Program ID   : SCP0013_GET_PRODUCTION_PLAN_LINE_NEW_CHECK
 * Description  : Production Plan Line New 입력 Validation 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/02/27	YHW				[CSR ID:3936008] Production Plan Line, 신규Line 추가 시 수정 요청
 * 2020/02/07	YHW				ESS 외주 Pakcer Line 생산 Target 적용
 * 2021/05/25   khj79           [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - TACT TIME 테이블 변경
 */
CREATE PROCEDURE [dbo].[SCP0013_GET_PRODUCTION_PLAN_LINE_NEW_CHECK]
	 @p_division_id				NVARCHAR(MAX)
	,@p_plan_date				NVARCHAR(MAX)
	,@p_plan_type				NVARCHAR(MAX)
	,@p_seq 					NVARCHAR(MAX)
	,@p_item_id 				NVARCHAR(MAX)
	,@p_line_id					NVARCHAR(MAX)
	,@p_operation_group			NVARCHAR(MAX)
	,@p_scm_site_id				NVARCHAR(MAX)
	,@p_origin_division_id		NVARCHAR(MAX)
AS

BEGIN

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0013_GET_PRODUCTION_PLAN_LINE_NEW_CHECK]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_chk_plan_line  INT=0;
	DECLARE @v_chk_tact_line  INT=0;

	DECLARE @v_msg_line  NVARCHAR(MAX)='';
	DECLARE @v_msg_tact  NVARCHAR(MAX)='';

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = ',' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	DECLARE @v_scm_site_id 			NVARCHAR(MAX);	
	DECLARE @v_line_id 				NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);

	--임시테이블 선언
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_CHECKLINE') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_CHECKLINE

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_CHECKTT') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_CHECKTT


	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		SELECT DISTINCT scm_site_id, item_id, line_id--, scm_site_id+'+'+line_id+'+'+item_id AS DATA_KEY
		INTO #TblDynamicPivot_SCP0013_CHECKLINE
		FROM scp_anl_production_plan with(nolock)
		WHERE division_id		= @p_division_id
		AND plan_start_yyyymmdd	= @p_plan_date
		AND plan_type			= @p_plan_type
		AND seq					= @p_seq
		AND operation_group		= @p_operation_group
		AND scm_site_id			IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_scm_site_id,','))
		AND item_id				IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_item_id,','))
		AND line_id				IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_line_id,','))

/* [PJ20209642] : TACT TIME 테이블 변경
		SELECT DISTINCT a.item_id, a.plant_site_id, a.line_id--, a.plant_site_id+'+'+a.line_id+'+'+a.item_id AS DATA_KEY
		INTO #TblDynamicPivot_SCP0013_CHECKTT
		FROM scp_mst_tact_time a (NOLOCK) 
			JOIN scm_mst_site b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id			 
		WHERE 1=1 
			AND a.division_id   IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_origin_division_id,','))
			AND a.valid_yn		= 'Y'
		;
*/
		-- [PJ20209642] : TACT TIME 테이블 변경
		SELECT DISTINCT a.item_id, B.scm_site_id AS plant_site_id, a.line_id
		INTO #TblDynamicPivot_SCP0013_CHECKTT
		FROM (SELECT DISTINCT DIVISION_ID , PLANT_ID  , LINE_ID , ITEM_ID
		               FROM SCM_MST_TACT_TIME_SN X (NOLOCK) 
					   WHERE MONTH >= CONVERT(NVARCHAR(6), GETDATE(),112)
					   ) A
			--JOIN scm_mst_site b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id			 
			JOIN scm_mst_site b ON a.division_id = b.division_id AND a.PLANT_ID = b.PLANT_ID			 
		WHERE 1=1 
			AND a.division_id   IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_origin_division_id,','))


		--ESS 외주 Pakcer Line 생산 Target 적용 : OSP T/T 추가
		INSERT INTO #TblDynamicPivot_SCP0013_CHECKTT
		SELECT DISTINCT A.ITEM_ID, A.PLANT_SITE_ID, A.LINE_ID
		FROM SCP_MST_TACT_TIME_OSP A WITH(NOLOCK)
		WHERE 1=1
		AND A.VALID_YN='Y'
		;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_item_id, @v_delimiter);    

		WHILE LEN(@p_item_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
			BEGIN    			
				-- @mst_loop_cnt 1증가
				SET @mst_loop_cnt = @mst_loop_cnt + 1;

				-- 각 컬럼들에 대한 스플릿처리로직 스타트
				BEGIN
					SET @v_scm_site_id     = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id    , @v_delimiter , @mst_loop_cnt) ;    
					SET @v_line_id         = [dbo].[SCM_ARR_SPL_VAL](@p_line_id        , @v_delimiter , @mst_loop_cnt) ;    
					SET @v_item_id         = [dbo].[SCM_ARR_SPL_VAL](@p_item_id        , @v_delimiter , @mst_loop_cnt) ;    
				END
			
				/*
				BEGIN
					PRINT '@mst_loop_cnt     ='+CONVERT(VARCHAR,@mst_loop_cnt)     ;
					PRINT '================================================='  ;
					PRINT '@v_scm_site_id     ='''+@v_scm_site_id     +'''';
					PRINT '@v_line_id         ='''+@v_line_id         +'''';
					PRINT '@v_item_id         ='''+@v_item_id         +'''';
				END;
				*/

				-- 기존 데이타 존재여부 조회
				DECLARE @v_pk_cnt INT=0;

				--1.기존 PLAN 라인 확인
				SELECT @v_pk_cnt = COUNT(*)
				FROM #TblDynamicPivot_SCP0013_CHECKLINE A
				WHERE 1=1
					and a.scm_site_id     = @v_scm_site_id
					and a.item_id         = @v_item_id
					and a.line_id         = @v_line_id
				;
				IF @v_pk_cnt>0
					BEGIN
						IF @v_msg_line!=''
							SET @v_msg_line = @v_msg_line + ', '

						SET @v_msg_line = @v_msg_line+@v_scm_site_id+'/'+@v_line_id+'/'+@v_item_id;
						SET @v_chk_plan_line = @v_chk_plan_line + 1;
					END

				--2.Tact Time 확인
				--외주일 시 LINE 값이 '-'로 들어옴
				IF @v_line_id != '-'
					BEGIN
						SELECT @v_pk_cnt = COUNT(*)
						FROM #TblDynamicPivot_SCP0013_CHECKTT A
						WHERE 1=1
							and a.plant_site_id   = @v_scm_site_id
							and a.item_id         = @v_item_id
							and a.line_id         = @v_line_id
						;

						IF @v_pk_cnt=0
							BEGIN
								IF @v_msg_tact!=''
									SET @v_msg_tact = @v_msg_tact + ', '
								SET @v_msg_tact = @v_msg_tact+@v_scm_site_id+'/'+@v_line_id+'/'+@v_item_id;
								SET @v_chk_tact_line = @v_chk_tact_line + 1;
							END
					END
				;

				--PRINT '@v_chk_plan_line =' + CONVERT(VARCHAR, @v_chk_plan_line);
				--PRINT '@v_chk_tact_line =' + CONVERT(VARCHAR, @v_chk_tact_line);
				--PRINT '@v_msg_line =' + CONVERT(VARCHAR, @v_msg_line);
				--PRINT '@v_msg_tact =' + CONVERT(VARCHAR, @v_msg_tact);

			END -- END OF WHILE
		;

		--결과
		IF (@v_chk_plan_line>0)
			SELECT 'L' AS RESULT_CODE, @v_msg_line AS MSG
		ELSE IF(@v_chk_tact_line>0)
			SELECT 'T' AS RESULT_CODE, @v_msg_tact AS MSG
		ELSE 
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
		  SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
		  --SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;


	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_CHECKLINE') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_CHECKLINE

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_CHECKTT') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_CHECKTT

	END







