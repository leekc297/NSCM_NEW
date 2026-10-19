

/*
 * Program ID   : SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX
 * Description  : SHIPMENT PLAN FG FIX 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge	Description
 *===================================================================================================
 * 2018/05/24   KYH			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/02	KYH			신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)

 */
CREATE PROCEDURE [dbo].[SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX]
	 @p_active_flag			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_biz_type			NVARCHAR(MAX)
	,@p_item_id 			NVARCHAR(MAX)
	,@p_to_site 			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_bod_id				NVARCHAR(MAX)
	,@p_yyyymmdd			NVARCHAR(MAX)
	,@p_qty					NVARCHAR(MAX)
	,@p_origin_from_division_id		NVARCHAR(MAX)
	,@p_origin_to_division_id		NVARCHAR(MAX)
	,@p_electrode_type		NVARCHAR(MAX)
	,@p_fix_reason			NVARCHAR(MAX)
	,@p_user_id  			NVARCHAR(50)
	,@debug_mode            NVARCHAR(1)='F'
AS

BEGIN

	SET NOCOUNT ON;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		NVARCHAR(MAX);
	DECLARE @v_division_id		NVARCHAR(MAX);
	DECLARE @v_biz_type			NVARCHAR(MAX);
	DECLARE @v_item_id 			NVARCHAR(MAX);	
	DECLARE @v_to_site 			NVARCHAR(MAX);
	DECLARE @v_from_site		NVARCHAR(MAX);
	DECLARE @v_bod_id			NVARCHAR(MAX);
	DECLARE @v_yyyymmdd			NVARCHAR(MAX);
	DECLARE @v_qty				NVARCHAR(MAX);
	DECLARE @v_origin_from_division_id		NVARCHAR(MAX);
	DECLARE @v_origin_to_division_id		NVARCHAR(MAX);
	DECLARE @v_electrode_type				NVARCHAR(MAX);
	DECLARE @v_fix_reason		NVARCHAR(MAX);
	DECLARE @v_last_updated_by	NVARCHAR(MAX);
	DECLARE @v_fix_id 			NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_biz_type = NULL;
	SET @v_item_id = NULL;
	SET @v_to_site = NULL;
	SET @v_from_site = NULL;
	SET @v_bod_id = NULL;
	SET @v_yyyymmdd = NULL;	 
	SET @v_qty = NULL;	 
	SET @v_origin_from_division_id = NULL;	 
	SET @v_origin_to_division_id = NULL;	 
	SET @v_electrode_type = NULL;
	SET @v_fix_reason = NULL;
	SET @v_last_updated_by = @p_user_id;
	SET @v_fix_id = null;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag	= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag    , @v_delimiter , @mst_loop_cnt) ;    
				SET @v_division_id	= [dbo].[SCM_ARR_SPL_VAL](@p_division_id    , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_biz_type		= [dbo].[SCM_ARR_SPL_VAL](@p_biz_type		, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_item_id		= [dbo].[SCM_ARR_SPL_VAL](@p_item_id        , @v_delimiter , @mst_loop_cnt) ;    
				SET @v_to_site		= [dbo].[SCM_ARR_SPL_VAL](@p_to_site		, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_from_site    = [dbo].[SCM_ARR_SPL_VAL](@p_from_site		, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_bod_id		= [dbo].[SCM_ARR_SPL_VAL](@p_bod_id			, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_yyyymmdd     = [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd       , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_qty          = [dbo].[SCM_ARR_SPL_VAL](@p_qty            , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_origin_from_division_id	= [dbo].[SCM_ARR_SPL_VAL](@p_origin_from_division_id    , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_origin_to_division_id	= [dbo].[SCM_ARR_SPL_VAL](@p_origin_to_division_id      , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_electrode_type			= [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type				, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_fix_reason   = @p_fix_reason ; 	
			END
			IF(@debug_mode ='T')
			BEGIN
				PRINT '@mst_loop_cnt     ='+CONVERT(VARCHAR,@mst_loop_cnt)     ;
				PRINT '================================================='  ;
				PRINT '@v_active_flag     ='''+@v_active_flag     +'''';
				PRINT '@v_division_id     ='''+@v_division_id     +'''';
				PRINT '@v_biz_type ='''+@v_biz_type +'''';
				PRINT '@v_item_id         ='''+@v_item_id         +'''';
				PRINT '@v_to_site    ='''+@v_to_site    +'''';
				PRINT '@v_from_site    ='''+@v_from_site    +'''';
				PRINT '@v_bod_id         ='''+@v_bod_id         +'''';
				PRINT '@v_yyyymmdd        ='''+@v_yyyymmdd        +'''';
				PRINT '@v_qty             ='''+@v_qty             +'''';
				PRINT '@v_origin_from_division_id             ='''+ @v_origin_from_division_id             +'''';
				PRINT '@v_origin_to_division_id             ='''+ @v_origin_to_division_id             +'''';
				PRINT '@v_electrode_type             ='''+ @v_electrode_type             +'''';
				PRINT '@v_fix_reason      ='''+@v_fix_reason      +'''';
				PRINT '@p_user_id ='''+@p_user_id +'''';
			END;

			-- 기존 데이타 존재여부 조회
			DECLARE @v_pk_cnt INT=0;

			SELECT @v_pk_cnt = COUNT(*)
			FROM SCP_ANL_SHIPMENT_PLAN_FIX A
			WHERE 1=1
				AND A.division_id	= @v_division_id
				and a.BIZ_TYPE		= @v_biz_type
				and a.ITEM_ID		= @v_item_id
				and a.TO_SITE       = @v_to_site
				and a.FROM_SITE     = @v_from_site
				and a.BOD_ID		= @v_bod_id
				and a.yyyymmdd      = @v_yyyymmdd
				and a.ORIGIN_FROM_DIVISION_ID	= @v_origin_from_division_id
				and a.ORIGIN_TO_DIVISION_ID		= @v_origin_to_division_id
				and a.ELECTRODE_TYPE		    = @v_electrode_type
			;

			PRINT '@v_pk_cnt =' + CONVERT(VARCHAR, @v_pk_cnt);

			-- 입력, 수정 모드 결정
			IF( @v_active_flag !='D' )
			BEGIN
				IF( @v_pk_cnt >0 )
					SET @v_active_flag ='M';
				ELSE
					SET @v_active_flag ='I';
			END;

			--FIX_KEY 생성
			IF (@v_active_flag ='I')
			BEGIN
				DECLARE @V_SEQ NVARCHAR(11)='';
				SET @V_SEQ = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX;

				SET @v_fix_id = 'F' + @v_yyyymmdd + REPLICATE('0', 11 - LEN(@V_SEQ)) + CAST( @V_SEQ AS NVARCHAR )
			END;
			ELSE
			BEGIN
				SELECT @v_fix_id = FIX_ID
				FROM SCP_ANL_SHIPMENT_PLAN_FIX A
				WHERE 1=1
					AND A.division_id	= @v_division_id
					and a.BIZ_TYPE		= @v_biz_type
					and a.ITEM_ID		= @v_item_id
					and a.TO_SITE       = @v_to_site
					and a.FROM_SITE     = @v_from_site
					and a.BOD_ID		= @v_bod_id
					and a.yyyymmdd      = @v_yyyymmdd
					and a.ORIGIN_FROM_DIVISION_ID   = @v_origin_from_division_id
					and a.ORIGIN_TO_DIVISION_ID     = @v_origin_to_division_id
					and a.ELECTRODE_TYPE			= @v_electrode_type
				;
			END;

			IF ISNULL(@v_qty,'') = ''
			BEGIN
				SET @v_qty = NULL;
			END
					   
			EXEC [PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST]
				 @v_fix_id
				,@v_division_id
				,@v_biz_type
				,@v_item_id
				,@v_to_site
				,@v_from_site
				, null
				, null
				,@v_bod_id
				,@v_yyyymmdd
				,@v_qty
				, @V_origin_from_division_id
				, @V_origin_to_division_id
				, @V_electrode_type
				,@v_fix_reason
				,@v_last_updated_by
				,@d_event_date
				,@v_last_updated_by
				;			

			IF @mst_loop_cnt > 0 			
			BEGIN
				IF( @v_active_flag ='I' )
				BEGIN
					INSERT INTO DBO.SCP_ANL_SHIPMENT_PLAN_FIX (	
						FIX_ID	
						,DIVISION_ID
						,BIZ_TYPE
						,ITEM_ID
						,TO_SITE
						,FROM_SITE
						,PROJECT_CODE
						,INCOTERMS
						,BOD_ID
						,YYYYMMDD
						,QTY
						, ORIGIN_FROM_DIVISION_ID
						, ORIGIN_TO_DIVISION_ID
						, ELECTRODE_TYPE
						,FIX_REASON
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
					)
					VALUES  (
						@v_fix_id
						,@v_division_id 
						,@v_biz_type
						,@v_item_id
						,@v_to_site
						,@v_from_site
						, null
						, null
						,@v_bod_id
						,@v_yyyymmdd
						,@v_qty
						,@v_origin_from_division_id
						,@v_origin_to_division_id
						,@v_electrode_type
						,@v_fix_reason
						,@v_last_updated_by
						,@d_event_date
						,@v_last_updated_by
						,@d_event_date
					);
				END;
				ELSE IF( @v_active_flag ='M' )
				BEGIN
					UPDATE SCP_ANL_SHIPMENT_PLAN_FIX
					SET qty			    = @v_qty
						,fix_reason	    = @v_fix_reason
						,last_updated_by  = @v_last_updated_by
						,last_update_date = @d_event_date
					WHERE 1=1
						AND division_id     = @v_division_id
						and BIZ_TYPE = @v_biz_type
						and ITEM_ID     = @v_item_id
						and TO_SITE         = @v_to_site
						and FROM_SITE         = @v_from_site
						and BOD_ID    = @v_bod_id
						and yyyymmdd        = @v_yyyymmdd
						and ORIGIN_FROM_DIVISION_ID     = @v_origin_from_division_id
						and ORIGIN_TO_DIVISION_ID		= @v_origin_to_division_id
						and ELECTRODE_TYPE				= @v_electrode_type
					;
				END;					
				ELSE IF(@v_active_flag ='D' )
				BEGIN
					DELETE DBO.SCP_ANL_SHIPMENT_PLAN_FIX
					WHERE division_id     = @v_division_id
						and BIZ_TYPE = @v_biz_type
						and ITEM_ID     = @v_item_id
						and TO_SITE         = @v_to_site
						and FROM_SITE         = @v_from_site
						and BOD_ID    = @v_bod_id
						and yyyymmdd        = @v_yyyymmdd
						and ORIGIN_FROM_DIVISION_ID     = @v_origin_from_division_id
						and ORIGIN_TO_DIVISION_ID		= @v_origin_to_division_id
						and ELECTRODE_TYPE				= @v_electrode_type
					;
				END;
			END
		END -- END OF WHILE

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;
		
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
	END


