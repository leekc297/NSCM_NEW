
/*
 * Program ID   : [SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM]
 * Description  : ALLO_TARGET_REQUEST Confirm 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/12/30   LWY   Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
    - Group User : SCM PI Admin, SCP Planner  Confirm 저장
 * 2022/07/28   LWY   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Allo_Target_Request 개선
 * 2022/09/28   LWY   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Allo_Target_Request 설계변경으로 개발
 * 2022/10/24   LWY   Initial Release PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 추가 수정
 */

 
CREATE PROCEDURE [dbo].[SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM]
	 
	-- @p_seq				NVARCHAR(MAX)
	--,@p_division			NVARCHAR(MAX)
	--,@p_cutoff_yyyymmdd	NVARCHAR(MAX)
	--,@p_to_qty_tobe		NVARCHAR(MAX)
	--,@p_confirm_user		NVARCHAR(MAX)
	--,@p_confirm_comments  NVARCHAR(MAX)
	--,@debug_mode			NVARCHAR(20) ='F'

	 @p_seq					NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_cutoff_yyyymmdd     NVARCHAR(MAX)
	,@p_to_dept_id			NVARCHAR(MAX)
	,@p_to_item_id          NVARCHAR(MAX)
	,@p_to_yyyymm   		NVARCHAR(MAX)
	,@p_to_qty_tobe         NVARCHAR(MAX)
	,@p_confirm_user		NVARCHAR(MAX)
	,@p_confirm_comments    NVARCHAR(MAX)

	,@debug_mode			NVARCHAR(20) ='F'
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DECLARE @v_seq				NVARCHAR(MAX);
	DECLARE @v_division_id		NVARCHAR(MAX);
	DECLARE @v_cutoff_yyyymmdd	NVARCHAR(MAX);
	DECLARE @v_to_dept_id		NVARCHAR(MAX);
	DECLARE @v_to_item_id		NVARCHAR(MAX);
	DECLARE @v_to_yyyymm		NVARCHAR(MAX);
	DECLARE @v_to_qty_tobe		NVARCHAR(MAX);
	DECLARE @v_confirm_user		NVARCHAR(MAX);
	DECLARE @v_confirm_comments	NVARCHAR(MAX);
	
	SET @v_seq				= NULL;
	SET @v_division_id		= NULL;
	SET @v_cutoff_yyyymmdd	= NULL;
	SET @v_to_dept_id		= NULL;
	SET @v_to_item_id		= NULL;
	SET @v_to_yyyymm		= NULL;
	SET @v_to_qty_tobe		= NULL;
	SET @v_confirm_user		= NULL;
	SET @v_confirm_comments	= NULL;

	-- SCP_ANL_ALLO_TARGET - Insert 용 변수
	DECLARE @v_type				NVARCHAR(200);
	DECLARE @v_yyyy				NVARCHAR(8);
	DECLARE @v_yyyyqq			NVARCHAR(12);
	DECLARE @v_nick_name		NVARCHAR(200);
	DECLARE @v_extra_spec		NVARCHAR(200);



	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt		INTEGER = 0;

	DECLARE @recv_division_id		NVARCHAR(MAX);
	SET @recv_division_id = NULL;		
	SET @recv_division_id = @p_division_id;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	
	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_division_id, @v_delimiter);

		WHILE LEN(@recv_division_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
		
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
		
			BEGIN
				set @v_seq				= [dbo].[scm_arr_spl_val](@p_seq,				@v_delimiter, @mst_loop_cnt);
				set @v_division_id		= [dbo].[scm_arr_spl_val](@p_division_id,		@v_delimiter, @mst_loop_cnt);
				set @v_cutoff_yyyymmdd	= [dbo].[scm_arr_spl_val](@p_cutoff_yyyymmdd,	@v_delimiter, @mst_loop_cnt);
				set @v_to_dept_id		= [dbo].[scm_arr_spl_val](@p_to_dept_id,		@v_delimiter, @mst_loop_cnt);
				set @v_to_item_id		= [dbo].[scm_arr_spl_val](@p_to_item_id,		@v_delimiter, @mst_loop_cnt);
				set @v_to_yyyymm		= [dbo].[scm_arr_spl_val](@p_to_yyyymm,			@v_delimiter, @mst_loop_cnt);
				set @v_to_qty_tobe		= [dbo].[scm_arr_spl_val](@p_to_qty_tobe,		@v_delimiter, @mst_loop_cnt);		
				set @v_confirm_user		= [dbo].[scm_arr_spl_val](@p_confirm_user,		@v_delimiter, @mst_loop_cnt);
				set @v_confirm_comments	= [dbo].[scm_arr_spl_val](@p_confirm_comments,	@v_delimiter, @mst_loop_cnt);

			END;

			-- LOOP 파라미터 출력 DEBUG용
			IF (@debug_mode ='T')
			BEGIN
				PRINT '===============================================';
				PRINT '@v_seq				= ' + ISNULL(@v_seq				,'');
				PRINT '@v_division_id	    = ' + ISNULL(@v_division_id		,'');
				PRINT '@v_cutoff_yyyymmdd	= ' + ISNULL(@v_cutoff_yyyymmdd	,'');
				PRINT '@v_to_dept_id		= ' + ISNULL(@v_to_dept_id		,'');
				PRINT '@v_to_item_id		= ' + ISNULL(@v_to_item_id		,'');				
				PRINT '@v_to_yyyymm			= ' + ISNULL(@v_to_yyyymm		,'');
				PRINT '@v_to_qty_tobe		= ' + ISNULL(@v_to_qty_tobe		,'');
				PRINT '@v_confirm_user		= ' + ISNULL(@v_confirm_user	,'');
				PRINT '@v_confirm_comments	= ' + ISNULL(@v_confirm_comments,'');
			END;

			--데이터 저장
			IF @mst_loop_cnt > 0
				BEGIN
					/*--------------------------------------------------
					-- Request Confirm
					----------------------------------------------------*/
					UPDATE SCP_ANL_ALLO_TARGET_REQUEST
					   SET CONFIRM		= 'Y'
					     --, TO_QTY		= @v_to_qty_tobe   -- AsIs qty history 로 남겨둠.
						 --, ATTRIBUTE1   = @v_to_qty_tobe
						 , ATTRIBUTE10  = @v_confirm_comments
						 , CONFIRM_USER = @v_confirm_user
						 , CONFIRM_DATE = SYSDATETIME()
					 WHERE 1 = 1
					   AND SEQ = @v_seq
					;

					/*--------------------------------------------------
					-- SCP_ANL_ALLO_TARGET QTY 반영
					----------------------------------------------------*/
					BEGIN
						
						-- 1. 
						--------------------------------------------
						/*
						UPDATE SCP_ANL_ALLO_TARGET
						SET    qty = CONVERT(NUMERIC, ISNULL(a.attribute1, '0')) + ISNULL((-1) * m.from_qty, 0)
								, last_updated_by = 'Minus Request From Qty'
						FROM   SCP_ANL_ALLO_TARGET A WITH(NOLOCK)
						JOIN SCP_ANL_ALLO_TARGET_REQUEST m with(nolock)
						ON  a.cutoff_yyyymmdd = m.cutoff_yyyymmdd
						AND a.dept_id         = m.to_dept_id
						AND a.item_id         = m.to_item_id
						AND a.yyyymm          = m.to_yyyymm
						AND m.confirm         = 'Y'	  
						WHERE  a.division_id     = @p_division
						AND    a.cutoff_yyyymmdd = @p_cutoff_yyyymmdd
						AND    a.type            = 'PLAN'
						*/

						-- Get Insert info :: yyyy, yyyyqq
						 --select  @v_yyyy = calendar_yyyy
							--	,@v_yyyyqq = calendar_yyyyqq

						 --  from scm_sys_calendar_m with(nolock)
						 -- where basis_yyyymmdd = @v_cutoff_yyyymmdd
							--and basis_yyyymm = @v_to_yyyymm
						 --;

						 select top 1 @v_yyyy = calendar_yyyy
								    , @v_yyyyqq = calendar_yyyyqq
						   from scm_sys_calendar_m with(nolock)
						  where calendar_yyyy = substring(@v_to_yyyymm,1,4)
							and basis_yyyymm = @v_to_yyyymm
						 ; 	

						 -- Get Insert info :: nick_name, extra_spec
						 select @v_nick_name = a.nick_name
							   ,@v_extra_spec = a.extra_spec
						  from (
								select   mi.division_id 
										,mi.item_id
										,max(nick_name)		 as nick_name
										,max(scp_extra_spec) as extra_spec
									from scm_mst_item_sn mi with(nolock)
								group by mi.division_id 
										,mi.item_id
								) a
						  where 1 = 1
							and a.division_id = @v_division_id
							and a.item_id = @v_to_item_id
						  ;


						MERGE INTO SCP_ANL_ALLO_TARGET A
							USING (
									SELECT
											  @v_division_id		as division_id
											, @v_cutoff_yyyymmdd	as cutoff_yyyymmdd
											, (case when @v_to_dept_id = '' then null else @v_to_dept_id end) as to_dept_id
											, @v_to_item_id			as to_item_id											
											, @v_to_yyyymm			as to_yyyymm
											, @v_to_qty_tobe		as to_qty_tobe

									) AS B
							ON 1 = 1
							AND A.division_id		= B.division_id
							AND A.cutoff_yyyymmdd	= B.cutoff_yyyymmdd
							AND A.dept_id			= B.to_dept_id
							AND A.item_id			= B.to_item_id
							AND A.yyyymm			= B.to_yyyymm
							AND A.type = 'PLAN'

							
							WHEN MATCHED THEN
									UPDATE
									   SET  A.qty = isnull(B.to_qty_tobe, 0)
										   ,last_updated_by  = @v_confirm_user
										   ,last_update_date = sysdatetime()

							WHEN NOT MATCHED THEN
								INSERT (
								         division_id
										,type
										,cutoff_yyyymmdd
										,yyyy
										,yyyyqq
										,yyyymm
										,yyyymmdd
										,item_id
										,dept_id
										,dept_name
										,qty
										,nick_name
										,extra_spec
										,scm_site_id
										,scm_site_name

										,created_by
										,creation_date
										,last_updated_by
										,last_update_date
										)
									VALUES
										(
										 B.division_id
										,'PLAN'             --type
										,B.cutoff_yyyymmdd
										,@v_yyyy
										,@v_yyyyqq
										,B.to_yyyymm
										,''                 -- yyyymmdd (allo target 에 없다)
										,B.to_item_id
										,B.to_dept_id
										,''                 -- dept_name
										,isnull(B.to_qty_tobe, 0)
										,@v_nick_name
										,@v_extra_spec
										,''                 --scm_site_id
										,''                 --scm_site_name

										, @v_confirm_user
										, SYSDATETIME()
										, @v_confirm_user
										, SYSDATETIME()
									)
									;


								PRINT 'MERGE END..  . '+CONVERT(CHAR(23), GETDATE(), 21);



	  
						
						
					END

				END
		
		END -- WHILE
				
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code ;

	END TRY

	BEGIN CATCH 

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END
