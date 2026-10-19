

/*
 * Program ID   : SCP0131_SAVE_SALES_SITE_PRIORITY
 * Description  : STOCK 조정 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 *
 */
CREATE PROCEDURE [dbo].[SCP0131_SAVE_SALES_SITE_PRIORITY]

	-- Add the parameters for the stored procedure here
  @p_active_flag         NVARCHAR(MAX),
  @p_division_id         NVARCHAR(MAX),
  @p_opmz_plan_gr_id     NVARCHAR(MAX),
  @p_scm_site_id         NVARCHAR(MAX),
  @p_item_id             NVARCHAR(MAX),
  @p_prio_rank           NVARCHAR(MAX),
  @p_from_yyyymmdd       NVARCHAR(MAX),
  @p_to_yyyymmdd         NVARCHAR(MAX),
  @p_value_description   NVARCHAR(MAX),
  @p_valid_yn            NVARCHAR(MAX),
  @p_user_id			 NVARCHAR(MAX),

  @p_pre_division_id	   NVARCHAR(MAX),
  @p_pre_opmz_plan_gr_id   NVARCHAR(MAX),
  @p_pre_scm_site_id	   NVARCHAR(MAX),
  @p_pre_item_id	       NVARCHAR(MAX),
  @p_pre_prio_rank	       NVARCHAR(MAX),
  @p_pre_from_yyyymmdd	   NVARCHAR(MAX),
  @p_pre_to_yyyymmdd	   NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		  NVARCHAR(MAX);
    DECLARE @v_division_id        NVARCHAR(MAX);
    DECLARE @v_opmz_plan_gr_id    NVARCHAR(MAX);
    DECLARE @v_scm_site_id        NVARCHAR(MAX);
    DECLARE @v_item_id            NVARCHAR(MAX);
    DECLARE @v_prio_rank		  NVARCHAR(MAX);
    DECLARE @v_from_yyyymmdd      NVARCHAR(MAX);
    DECLARE @v_to_yyyymmdd        NVARCHAR(MAX);
    DECLARE @v_value_description  NVARCHAR(MAX);
    DECLARE @v_valid_yn           NVARCHAR(MAX);
	DECLARE @v_user_id		      NVARCHAR(MAX);
	DECLARE @v_last_updated_by	  NVARCHAR(MAX);
	
	DECLARE @v_pre_division_id	   NVARCHAR(MAX);
    DECLARE @V_pre_opmz_plan_gr_id NVARCHAR(MAX);
    DECLARE @v_pre_scm_site_id	   NVARCHAR(MAX);
    DECLARE @v_pre_item_id	       NVARCHAR(MAX);
    DECLARE @v_pre_prio_rank       NVARCHAR(MAX);
    DECLARE @v_pre_from_yyyymmdd   NVARCHAR(MAX);
    DECLARE @v_pre_to_yyyymmdd	   NVARCHAR(MAX);





	SET @v_active_flag       = NULL;	
	SET @v_division_id       = NULL;	
	SET @v_opmz_plan_gr_id   = NULL;
	SET @v_scm_site_id       = NULL;
	SET @v_item_id           = NULL;
	SET @v_prio_rank         = NULL;
	SET @v_from_yyyymmdd     = NULL;
	SET @v_to_yyyymmdd       = NULL;	
	SET @v_value_description = NULL;
	SET @v_valid_yn          = NULL;
	SET @v_user_id	         = NULL;
	SET @v_last_updated_by	 = NULL;

	SET @v_pre_division_id	   = NULL;
	SET @V_pre_opmz_plan_gr_id = NULL;
	SET @v_pre_scm_site_id	   = NULL;
	SET @v_pre_item_id	       = NULL;
	SET @v_pre_prio_rank       = NULL;
	SET @v_pre_from_yyyymmdd   = NULL;
	SET @v_pre_to_yyyymmdd	   = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0131_SAVE_SALES_SITE_PRIORITY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;


	-- 예외처리 변수 설정
	DECLARE @v_err_code     INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	SET @v_last_updated_by  = @p_user_id

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

				SET @v_active_flag		 = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag,       @v_delimiter , @mst_loop_cnt) ; 
				SET @v_division_id       = [dbo].[SCM_ARR_SPL_VAL](@p_division_id,       @v_delimiter , @mst_loop_cnt) ;	
				SET @v_opmz_plan_gr_id   = [dbo].[SCM_ARR_SPL_VAL](@p_opmz_plan_gr_id,   @v_delimiter , @mst_loop_cnt) ;
				SET @v_scm_site_id       = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id,       @v_delimiter , @mst_loop_cnt) ; 
				SET @v_item_id           = [dbo].[SCM_ARR_SPL_VAL](@p_item_id,           @v_delimiter , @mst_loop_cnt) ;   
				SET @v_prio_rank         = [dbo].[SCM_ARR_SPL_VAL](@p_prio_rank,         @v_delimiter , @mst_loop_cnt) ; 
				SET @v_from_yyyymmdd     = [dbo].[SCM_ARR_SPL_VAL](@p_from_yyyymmdd	,    @v_delimiter , @mst_loop_cnt) ; 
				SET @v_to_yyyymmdd       = [dbo].[SCM_ARR_SPL_VAL](@p_to_yyyymmdd	,    @v_delimiter , @mst_loop_cnt) ; 
				SET @v_value_description = [dbo].[SCM_ARR_SPL_VAL](@p_value_description, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_valid_yn          = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn,          @v_delimiter , @mst_loop_cnt) ;

				SET @v_pre_division_id	   = [dbo].[SCM_ARR_SPL_VAL](@p_pre_division_id,     @v_delimiter , @mst_loop_cnt) ;
				SET @V_pre_opmz_plan_gr_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_opmz_plan_gr_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_scm_site_id	   = [dbo].[SCM_ARR_SPL_VAL](@p_pre_scm_site_id,     @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_item_id	       = [dbo].[SCM_ARR_SPL_VAL](@p_pre_item_id,         @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_prio_rank       = [dbo].[SCM_ARR_SPL_VAL](@p_pre_prio_rank,       @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_from_yyyymmdd   = [dbo].[SCM_ARR_SPL_VAL](@p_pre_from_yyyymmdd,   @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_to_yyyymmdd	   = [dbo].[SCM_ARR_SPL_VAL](@p_pre_to_yyyymmdd,     @v_delimiter , @mst_loop_cnt) ;

			END

			--삭제가 아닌 경우, 중복체크
			IF (@v_active_flag <> 'D')
			BEGIN 
				/***** 중복체크 *****/
				DECLARE @cnt INTEGER;
				SET @cnt = 0;

				SELECT @cnt = COUNT(*)
				FROM SCP_OPMZ_SALES_SITE_PRIORITY  WITH(NOLOCK)
				WHERE DIVISION_ID	= @v_division_id
				AND OPMZ_PLAN_GR_ID = @v_opmz_plan_gr_id
				AND SCM_SITE_ID	    = @v_scm_site_id
				AND ITEM_ID         = @v_item_id
				AND FROM_YYYYMMDD   = @v_from_yyyymmdd
				AND TO_YYYYMMDD	    = @v_to_yyyymmdd
				AND NOT (
						    DIVISION_ID     = @v_pre_division_id
						AND OPMZ_PLAN_GR_ID = @v_pre_opmz_plan_gr_id
						AND SCM_SITE_ID	    = @v_pre_scm_site_id
						AND ITEM_ID         = @v_pre_item_id
						AND FROM_YYYYMMDD   = @v_pre_from_yyyymmdd
						AND TO_YYYYMMDD	    = @v_pre_to_yyyymmdd
						)

				IF(@cnt > 0)
				BEGIN
					SET @v_err_code    = 99010 ; 
					SET @v_err_message = N' 신규 입력 데이터 중 중복된 데이터가 있습니다.';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END

				/**** 날짜 중복 체크 ****/
				SELECT @cnt = COUNT(1)
				FROM SCP_OPMZ_SALES_SITE_PRIORITY x
				WHERE DIVISION_ID	= @v_division_id
				AND OPMZ_PLAN_GR_ID = @v_opmz_plan_gr_id
				AND SCM_SITE_ID	    = @v_scm_site_id
				AND ITEM_ID         = @v_item_id
				AND NOT ( @v_to_yyyymmdd   < x.FROM_YYYYMMDD OR @v_from_yyyymmdd > x.TO_YYYYMMDD )
				AND NOT (x.FROM_YYYYMMDD = @v_pre_from_yyyymmdd AND X.TO_YYYYMMDD = @v_pre_to_yyyymmdd ) -- 기존 값

				IF(@cnt > 0)
				BEGIN
					SET @v_err_code    = 99010 ; 
					SET @v_err_message = N' 입력 데이터 중 날짜가 중복되는 데이터가 있습니다.';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END

				/***** 중복체크 *****/
			END

			IF(@v_active_flag = 'I')
			BEGIN

                INSERT INTO SCP_OPMZ_SALES_SITE_PRIORITY
                (
                       DIVISION_ID
                      ,OPMZ_PLAN_GR_ID
                      ,SCM_SITE_ID
                      ,PRIO_RANK
                      ,ITEM_ID
                      ,FROM_YYYYMMDD
                      ,TO_YYYYMMDD
                      ,VALUE_DESCRIPTION
                      ,VALID_YN
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE
                )
                VALUES
                (
                       @v_division_id
                      ,@v_opmz_plan_gr_id
                      ,@v_scm_site_id
                      ,@v_prio_rank
                      ,@v_item_id
                      ,@v_from_yyyymmdd
                      ,@v_to_yyyymmdd
                      ,@v_value_description
                      ,@v_valid_yn
                      ,@v_last_updated_by
                      ,GETDATE()
                      ,@v_last_updated_by
                      ,GETDATE()
                )

			END
			ELSE IF( @v_active_flag ='M' )
			BEGIN

                UPDATE SCP_OPMZ_SALES_SITE_PRIORITY
                SET DIVISION_ID           = @v_division_id
                   ,OPMZ_PLAN_GR_ID       = @v_opmz_plan_gr_id
                   ,SCM_SITE_ID           = @v_scm_site_id
                   ,PRIO_RANK             = @v_prio_rank
                   ,ITEM_ID               = @v_item_id
                   ,FROM_YYYYMMDD         = @v_from_yyyymmdd
                   ,TO_YYYYMMDD           = @v_to_yyyymmdd
                   ,VALUE_DESCRIPTION     = @v_value_description
                   ,VALID_YN              = @v_valid_yn
                   ,LAST_UPDATED_BY	      = @v_last_updated_by
                   ,LAST_UPDATE_DATE      = SYSDATETIME()
                WHERE DIVISION_ID           = @v_pre_division_id
                AND   OPMZ_PLAN_GR_ID       = @v_pre_opmz_plan_gr_id
                AND   SCM_SITE_ID           = @v_pre_scm_site_id
                AND   ITEM_ID               = @v_pre_item_id
                AND   FROM_YYYYMMDD         = @v_pre_from_yyyymmdd
                AND   TO_YYYYMMDD           = @v_pre_to_yyyymmdd
				;

			END
			--삭제기능 추가 (2025-07-16)
			ELSE IF(@v_active_flag ='D')
			BEGIN
				
				DELETE SCP_OPMZ_SALES_SITE_PRIORITY
                WHERE DIVISION_ID           = @v_pre_division_id
                AND   OPMZ_PLAN_GR_ID       = @v_pre_opmz_plan_gr_id
                AND   SCM_SITE_ID           = @v_pre_scm_site_id
                AND   ITEM_ID               = @v_pre_item_id
                AND   FROM_YYYYMMDD         = @v_pre_from_yyyymmdd
                AND   TO_YYYYMMDD           = @v_pre_to_yyyymmdd

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
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END






