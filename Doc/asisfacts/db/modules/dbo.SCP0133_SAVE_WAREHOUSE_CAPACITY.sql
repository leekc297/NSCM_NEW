


/*
 * Program ID   : SCP0133_SAVE_WAREHOUSE_CAPACITY
 * Description  : Warehouse Capacity 등록,수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/11/11   mrchois   		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/11/24   mrchois   		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Warehouse Capacity에 From/to date 키로 추가
 *
 */
CREATE PROCEDURE [dbo].[SCP0133_SAVE_WAREHOUSE_CAPACITY]

      @p_active_flag         NVARCHAR(MAX)
    , @p_division_id         NVARCHAR(MAX)
    , @p_opmz_plan_gr_id     NVARCHAR(MAX)
    , @p_wh_nm               NVARCHAR(MAX)
    , @p_site_id             NVARCHAR(MAX)
    , @p_stage               NVARCHAR(MAX)
    , @p_from_yyyymmdd       NVARCHAR(MAX)
    , @p_to_yyyymmdd         NVARCHAR(MAX)
    , @p_max_capa            NVARCHAR(MAX)
	, @p_value_description   NVARCHAR(MAX)
	, @p_valid_yn            NVARCHAR(MAX)
    , @p_user_id             NVARCHAR(MAX)

    , @p_pre_division_id     NVARCHAR(MAX)
    , @p_pre_opmz_plan_gr_id NVARCHAR(MAX)
    , @p_pre_wh_nm           NVARCHAR(MAX)
    , @p_pre_from_yyyymmdd   NVARCHAR(MAX)	--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24)
    , @p_pre_to_yyyymmdd     NVARCHAR(MAX)

AS

BEGIN

  SET NOCOUNT ON;

  DECLARE @v_working_time     DATETIME =sysdatetime();
  DECLARE @recv_active_flag   NVARCHAR(MAX);

  SET @recv_active_flag = NULL;   
  SET @recv_active_flag = @p_active_flag;

  DECLARE @v_active_flag            NVARCHAR(MAX);
  DECLARE @v_division_id            NVARCHAR(MAX);
  DECLARE @v_opmz_plan_gr_id        NVARCHAR(MAX);
  DECLARE @v_wh_nm                  NVARCHAR(MAX);
  DECLARE @v_site_id                NVARCHAR(MAX);
  DECLARE @v_stage                  NVARCHAR(MAX);
  DECLARE @v_from_yyyymmdd          NVARCHAR(MAX);
  DECLARE @v_to_yyyymmdd            NVARCHAR(MAX);
  DECLARE @v_max_capa               NVARCHAR(MAX);
  DECLARE @v_valid_yn               NVARCHAR(MAX);
  DECLARE @v_value_description      NVARCHAR(MAX);
  DECLARE @v_last_updated_by        NVARCHAR(MAX);
  
  DECLARE @v_pre_division_id        NVARCHAR(MAX);
  DECLARE @v_pre_opmz_plan_gr_id    NVARCHAR(MAX);
  DECLARE @v_pre_wh_nm              NVARCHAR(MAX);
  DECLARE @v_pre_from_yyyymmdd      NVARCHAR(MAX);	--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24)
  DECLARE @v_pre_to_yyyymmdd        NVARCHAR(MAX);

  DECLARE @v_Nmax_capa              NUMERIC(18, 0);

  DECLARE @step        NVARCHAR(MAX) = null;

  SET @v_active_flag             = NULL; 
  SET @v_division_id             = NULL;
  SET @v_opmz_plan_gr_id         = NULL;
  SET @v_site_id                 = NULL;
  SET @v_stage                   = NULL;
  SET @v_wh_nm                   = NULL;
  SET @v_from_yyyymmdd           = NULL;
  SET @v_to_yyyymmdd             = NULL;
  SET @v_max_capa                = NULL;
  SET @v_valid_yn                = NULL;
  SET @v_value_description       = NULL;
  SET @v_last_updated_by         = NULL;

  SET @v_pre_division_id         = NULL;
  SET @v_pre_opmz_plan_gr_id     = NULL;
  SET @v_pre_wh_nm               = NULL;
  SET @v_pre_from_yyyymmdd       = NULL;	--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24)
  SET @v_pre_to_yyyymmdd         = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0133_SAVE_WAREHOUSE_CAPACITY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;

	DECLARE @v_null_val   INTEGER =-99999;

	-- 예외처리 변수 설정
	DECLARE @v_err_code     INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	SET @v_last_updated_by  = @p_user_id;

	BEGIN TRY

		-- 트렌젝션 시작
		BEGIN TRAN;

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

			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN


				SET @v_active_flag          = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag          , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_division_id          = [dbo].[SCM_ARR_SPL_VAL](@p_division_id          , @v_delimiter , @mst_loop_cnt) ;
				SET @v_opmz_plan_gr_id      = [dbo].[SCM_ARR_SPL_VAL](@p_opmz_plan_gr_id      , @v_delimiter , @mst_loop_cnt) ;
				SET @v_wh_nm                = [dbo].[SCM_ARR_SPL_VAL](@p_wh_nm                , @v_delimiter , @mst_loop_cnt) ;
				SET @v_site_id              = [dbo].[SCM_ARR_SPL_VAL](@p_site_id              , @v_delimiter , @mst_loop_cnt) ;
				SET @v_stage                = [dbo].[SCM_ARR_SPL_VAL](@p_stage                , @v_delimiter , @mst_loop_cnt) ;
				SET @v_from_yyyymmdd        = [dbo].[SCM_ARR_SPL_VAL](@p_from_yyyymmdd        , @v_delimiter , @mst_loop_cnt) ;
				SET @v_to_yyyymmdd          = [dbo].[SCM_ARR_SPL_VAL](@p_to_yyyymmdd          , @v_delimiter , @mst_loop_cnt) ;
				SET @v_max_capa             = [dbo].[SCM_ARR_SPL_VAL](@p_max_capa             , @v_delimiter , @mst_loop_cnt) ;
				SET @v_valid_yn             = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn             , @v_delimiter , @mst_loop_cnt) ;
				SET @v_value_description    = [dbo].[SCM_ARR_SPL_VAL](@p_value_description    , @v_delimiter , @mst_loop_cnt) ;
				SET @v_last_updated_by      = [dbo].[SCM_ARR_SPL_VAL](@p_user_id              , @v_delimiter , @mst_loop_cnt) ;

				SET @v_pre_division_id      = [dbo].[SCM_ARR_SPL_VAL](@p_pre_division_id      , @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_opmz_plan_gr_id  = [dbo].[SCM_ARR_SPL_VAL](@p_pre_opmz_plan_gr_id  , @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_wh_nm            = [dbo].[SCM_ARR_SPL_VAL](@p_pre_wh_nm            , @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_from_yyyymmdd    = [dbo].[SCM_ARR_SPL_VAL](@p_pre_from_yyyymmdd    , @v_delimiter , @mst_loop_cnt) ;	--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24)
				SET @v_pre_to_yyyymmdd      = [dbo].[SCM_ARR_SPL_VAL](@p_pre_to_yyyymmdd      , @v_delimiter , @mst_loop_cnt) ;

			END

			-- 문자값을 숫자로 변환

			if @v_max_capa ='' 
			BEGIN
				SET @v_Nmax_capa = NULL
			END
			ELSE
			BEGIN
				-- 빈 문자열이 아닐 경우 숫자로 변환
				SET @v_Nmax_capa = CONVERT(NUMERIC(18, 0), @v_max_capa)
			END

			--삭제가 아닌 경우, 중복체크
			IF (@v_active_flag <> 'D')
			BEGIN 
				/***** 중복체크 *****/
				DECLARE @cnt INTEGER;
				SET @cnt = 0;

				----1. KEY중복 체크
				SELECT @cnt = COUNT(*)
				FROM SCP_OPMZ_WAREHOUSE_CAPACITY  WITH(NOLOCK)
				WHERE DIVISION_ID	  = @v_division_id
				AND   OPMZ_PLAN_GR_ID = @v_opmz_plan_gr_id
				AND   WH_NM			  = @v_wh_nm
				AND   FROM_YYYYMMDD	  = @v_from_yyyymmdd			--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24)
				AND   TO_YYYYMMDD	  = @v_to_yyyymmdd
				AND NOT (
						  DIVISION_ID     = @v_pre_division_id
					AND   OPMZ_PLAN_GR_ID = @v_pre_opmz_plan_gr_id
					AND   WH_NM			  = @v_pre_wh_nm
					AND   FROM_YYYYMMDD	  = @v_pre_from_yyyymmdd	--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24)
					AND   TO_YYYYMMDD	  = @v_pre_to_yyyymmdd
						)

				IF(@cnt > 0)
				BEGIN
					SET @v_err_code    = 99010 ; 
					SET @v_err_message = N' 신규 입력 데이터 중 중복된 데이터가 있습니다.';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END

				--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24) START
				--2.WH Name은 같고 From/To date가 중첩구간인 경우 체크
				SET @cnt = 0;

				SELECT @cnt = COUNT(*)
				FROM SCP_OPMZ_WAREHOUSE_CAPACITY  WITH(NOLOCK)
				WHERE DIVISION_ID	  = @v_division_id
				AND   OPMZ_PLAN_GR_ID = @v_opmz_plan_gr_id
				AND   WH_NM			  = @v_wh_nm
			    AND ( (FROM_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd)
					OR (TO_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd)
					OR (@v_from_yyyymmdd BETWEEN FROM_YYYYMMDD AND TO_YYYYMMDD)
					OR (@v_to_yyyymmdd BETWEEN FROM_YYYYMMDD AND TO_YYYYMMDD)
					)
				AND NOT (
						  DIVISION_ID     = @v_pre_division_id
					AND   OPMZ_PLAN_GR_ID = @v_pre_opmz_plan_gr_id
					AND   WH_NM			  = @v_pre_wh_nm
					AND   FROM_YYYYMMDD	  = @v_pre_from_yyyymmdd
					AND   TO_YYYYMMDD	  = @v_pre_to_yyyymmdd
						)

				IF(@cnt > 0)
				BEGIN
					SET @v_err_code    = 99010 ; 
					SET @v_err_message = N' 중첩구간이 있는 데이터가 있습니다.';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END
				--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24) END
			END
			 
			IF(@v_active_flag = 'I')
			BEGIN
                INSERT INTO SCP_OPMZ_WAREHOUSE_CAPACITY
                (
					  DIVISION_ID
					, OPMZ_PLAN_GR_ID
					, WH_NM
					, SCM_SITE_ID
					, STAGE
					, FROM_YYYYMMDD
					, TO_YYYYMMDD
					, MAX_CAPA
					, VALUE_DESCRIPTION
					, VALID_YN
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
                )
                VALUES
                (
					  @v_division_id
					, @v_opmz_plan_gr_id
					, @v_wh_nm
					, @v_site_id
					, @v_stage
					, @v_from_yyyymmdd
					, @v_to_yyyymmdd
					, @v_Nmax_capa
					, @v_value_description 
					, @v_Valid_yn
                    , @v_last_updated_by
                    , GETDATE()
                    , @v_last_updated_by
                    , GETDATE()
                )

			END
			ELSE IF( @v_active_flag ='M' )
			BEGIN
			    -- 1.개별 UPDATE
                UPDATE SCP_OPMZ_WAREHOUSE_CAPACITY
                   SET DIVISION_ID			= @v_division_id
				     , OPMZ_PLAN_GR_ID		= @v_opmz_plan_gr_id
				     , WH_NM				= @v_wh_nm
				     , SCM_SITE_ID			= @v_site_id
				     , STAGE				= @v_stage
				     , FROM_YYYYMMDD		= @v_from_yyyymmdd
				     , TO_YYYYMMDD			= @v_to_yyyymmdd
				     , MAX_CAPA				= @v_Nmax_capa
				     , VALUE_DESCRIPTION	= @v_value_description
				     , VALID_YN 			= @v_Valid_yn
				     , LAST_UPDATED_BY		= @v_last_updated_by
				     , LAST_UPDATE_DATE		= SYSDATETIME()
                 WHERE DIVISION_ID			= @v_pre_division_id
				   AND OPMZ_PLAN_GR_ID		= @v_pre_opmz_plan_gr_id
				   AND WH_NM				= @v_pre_wh_nm  
				   AND FROM_YYYYMMDD		= @v_pre_from_yyyymmdd	--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24)
				   AND TO_YYYYMMDD			= @v_pre_to_yyyymmdd
				;
				 
			END
			ELSE IF(@v_active_flag ='D')
			BEGIN
				
				DELETE SCP_OPMZ_WAREHOUSE_CAPACITY
                WHERE DIVISION_ID       = @v_pre_division_id
                AND   OPMZ_PLAN_GR_ID   = @v_pre_opmz_plan_gr_id
				AND   WH_NM				= @v_pre_wh_nm
				AND   FROM_YYYYMMDD		= @v_pre_from_yyyymmdd		--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가 (2025-11-24)
				AND   TO_YYYYMMDD		= @v_pre_to_yyyymmdd
				;

			END

		END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY
	BEGIN CATCH
		IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
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

			--IF @@TRANCOUNT > 0
			--	COMMIT WORK;

		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() ;
	END CATCH;
END






 
