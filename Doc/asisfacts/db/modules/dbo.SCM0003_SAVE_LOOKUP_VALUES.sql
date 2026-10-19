/*
 * Program ID   : SCM0003_SAVE_LOOKUP_VALUES
 * Description  : Lookup Values 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/14   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[SCM0003_SAVE_LOOKUP_VALUES]

-- Add the parameters for the stored procedure here
@p_active_flag			NVARCHAR(MAX),
@p_lookup_type			NVARCHAR(MAX), 
@p_division_id			NVARCHAR(MAX), 
@p_lookup_code			NVARCHAR(MAX), 
@p_l_description		NVARCHAR(MAX),
@p_display_seq			NVARCHAR(MAX), 
@p_default_value_flag	NVARCHAR(MAX), 
@p_valid_yn				NVARCHAR(MAX),
@p_created_by			NVARCHAR(MAX),
@p_creation_date		NVARCHAR(MAX),
@p_last_updated_by      NVARCHAR(MAX), 
@p_segment1				NVARCHAR(MAX), 
@p_segment2				NVARCHAR(MAX), 
@p_segment3				NVARCHAR(MAX), 
@p_attribute1			NVARCHAR(MAX), 
@p_attribute2			NVARCHAR(MAX), 
@p_attribute3			NVARCHAR(MAX), 
@p_attribute4			NVARCHAR(MAX), 
@p_attribute5			NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX); 
    DECLARE @v_lookup_type			NVARCHAR(MAX); 
	DECLARE @v_division_id			NVARCHAR(MAX); 
	DECLARE @v_lookup_code			NVARCHAR(MAX);
	DECLARE @v_l_description		NVARCHAR(MAX);
	DECLARE @v_display_seq			NVARCHAR(MAX);
	DECLARE @v_default_value_flag	NVARCHAR(MAX); 
	DECLARE @v_valid_yn				NVARCHAR(MAX);
    DECLARE @v_created_by			NVARCHAR(MAX);
    DECLARE @v_creation_date		NVARCHAR(MAX);
    DECLARE @v_last_updated_by      NVARCHAR(MAX); 
    DECLARE @v_segment1				NVARCHAR(MAX); 
    DECLARE @v_segment2				NVARCHAR(MAX); 
    DECLARE @v_segment3				NVARCHAR(MAX);
	DECLARE @v_attribute1			NVARCHAR(MAX); 
    DECLARE @v_attribute2			NVARCHAR(MAX); 
    DECLARE @v_attribute3			NVARCHAR(MAX); 
    DECLARE @v_attribute4			NVARCHAR(MAX); 
    DECLARE @v_attribute5			NVARCHAR(MAX); 

	SET @v_active_flag			= NULL; 
	SET @v_lookup_type			= NULL; 
	SET @v_division_id			= NULL; 
    SET @v_lookup_code			= NULL;
    SET @v_l_description		= NULL;
    SET @v_display_seq			= NULL;
    SET @v_default_value_flag   = NULL;
    SET @v_valid_yn				= NULL;
    SET @v_created_by			= NULL;
    SET @v_creation_date		= NULL;
    SET @v_last_updated_by      = NULL; 
    SET @v_segment1			= NULL; 
    SET @v_segment2			= NULL; 
    SET @v_segment3			= NULL; 
	SET @v_attribute1       = NULL; 
    SET @v_attribute2		= NULL; 
    SET @v_attribute3		= NULL; 
    SET @v_attribute4		= NULL; 
    SET @v_attribute5		= NULL; 

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0003_SAVE_LOOKUP_VALUES';
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
		SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
			   SET @v_active_flag			= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
			   SET @v_lookup_type			= [dbo].[SCM_ARR_SPL_VAL](@p_lookup_type, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_division_id			= [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
	 		   SET @v_lookup_code			= [dbo].[SCM_ARR_SPL_VAL](@p_lookup_code, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_l_description			= [dbo].[SCM_ARR_SPL_VAL](@p_l_description, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_display_seq			= [dbo].[SCM_ARR_SPL_VAL](@p_display_seq, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_default_value_flag	= [dbo].[SCM_ARR_SPL_VAL](@p_default_value_flag, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_valid_yn				= [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_created_by			= [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_creation_date			= [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_last_updated_by		= [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter , @mst_loop_cnt) ;  
			   SET @v_segment1			= [dbo].[SCM_ARR_SPL_VAL](@p_segment1, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_segment2			= [dbo].[SCM_ARR_SPL_VAL](@p_segment2, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_segment3			= [dbo].[SCM_ARR_SPL_VAL](@p_segment3, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_attribute1		= [dbo].[SCM_ARR_SPL_VAL](@p_attribute1, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_attribute2		= [dbo].[SCM_ARR_SPL_VAL](@p_attribute2, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_attribute3		= [dbo].[SCM_ARR_SPL_VAL](@p_attribute3, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_attribute4		= [dbo].[SCM_ARR_SPL_VAL](@p_attribute4, @v_delimiter , @mst_loop_cnt) ; 
			   SET @v_attribute5		= [dbo].[SCM_ARR_SPL_VAL](@p_attribute5, @v_delimiter , @mst_loop_cnt) ; 
			END

		   --HISTORY INSERT

			EXEC [PR_SCM_ADM_LOOKUP_VALUES_HIST]
											 @v_lookup_type
											,@v_division_id
											,@v_lookup_code
											,@v_l_description
											,@v_display_seq
											,@v_default_value_flag
											,@v_valid_yn
											,@v_created_by
											,@v_creation_date
											,@v_last_updated_by
											,@v_segment1
											,@v_segment2
											,@v_segment3
											,@v_attribute1
											,@v_attribute2
											,@v_attribute3
											,@v_attribute4
											,@v_attribute5

						
															
			 ;

			IF @mst_loop_cnt > 0 
			
			BEGIN
			MERGE INTO [SCM_ADM_LOOKUP_VALUES] A
			USING (
					SELECT 
					 @v_lookup_type as lookup_type
					,@v_lookup_code as lookup_code
					,@v_segment1 as segment1
				    ,@v_segment2 as segment2
				    ,@v_segment3 as segment3
						
				  ) B
			ON(
					A.lookup_type = B.lookup_type	
				AND A.lookup_code = B.lookup_code
				AND	A.segment1 = b.segment1
				AND	A.segment2 = b.segment2
				AND	A.segment3 = b.segment3
				)
			WHEN MATCHED THEN
				UPDATE SET 
					 division_id		=   @v_division_id
					,description		=	@v_l_description
					,display_seq		=	@v_display_seq
					,default_value_flag	=	@v_default_value_flag
					,valid_yn     		=	@v_valid_yn     
					,created_by			=	@v_created_by
					,creation_date		=	@v_creation_date
					,last_updated_by	=	@v_last_updated_by
					,last_update_date	=   sysdatetime()
					,segment1			=	@v_segment1
					,segment2			=	@v_segment2
					,segment3			=	@v_segment3
					,attribute1			=	@v_attribute1
					,attribute2			=	@v_attribute2
					,attribute3			=	@v_attribute3
					,attribute4			=	@v_attribute4
					,attribute5			=	@v_attribute5
			WHEN NOT MATCHED THEN
		
			  INSERT 
			   (
			    division_id		,lookup_type	,lookup_code		,description       
			   ,valid_yn		,display_seq	,default_value_flag       
			   ,created_by      ,creation_date  ,last_updated_by	,last_update_date     
			   ,segment1        ,segment2		,segment3      
			   ,attribute1      ,attribute2     ,attribute3			,attribute4    ,attribute5      
			   
			  )
			  VALUES
			  (
			    @v_division_id	   ,@v_lookup_type	  ,@v_lookup_code		 ,@v_l_description       
			   ,@v_valid_yn		   ,@v_display_seq	  ,@v_default_value_flag       
			   ,@v_created_by      ,sysdatetime()     ,@v_last_updated_by	 ,sysdatetime()    
			   ,@v_segment1        ,@v_segment2		  ,@v_segment3         
			   ,@v_attribute1      ,@v_attribute2     ,@v_attribute3		 ,@v_attribute4       ,@v_attribute5      
			   )
		   ;
	
			END
			ELSE -- 단일 row
			 
			BEGIN   

			SET @v_active_flag = @p_active_flag        
			SET @p_active_flag = NULL       
			SET	@v_lookup_type	=	@p_lookup_type
			SET	@p_lookup_type	=	NULL
			SET	@v_division_id	=	@p_division_id
			SET	@p_division_id	=	NULL
			SET	@v_lookup_code	=	@p_lookup_code
			SET	@p_lookup_code	=	NULL
			SET	@v_l_description	=	@p_l_description
			SET	@p_l_description	=	NULL
			SET	@v_display_seq	=	@p_display_seq
			SET	@p_display_seq	=	NULL
			SET	@v_default_value_flag	=	@p_default_value_flag
			SET	@p_default_value_flag	=	NULL
			SET	@v_valid_yn	=	@p_valid_yn
			SET	@p_valid_yn	=	NULL
			SET	@v_created_by	=	@p_created_by
			SET	@p_created_by	=	NULL
			SET	@v_creation_date	=	@p_creation_date
			SET	@p_creation_date	=	NULL
			SET	@v_last_updated_by	=	@p_last_updated_by
			SET	@p_last_updated_by	=	NULL
			SET	@v_segment1		=	@p_segment1
			SET	@p_segment1		=	NULL
			SET	@v_segment2		=	@p_segment2
			SET	@p_segment2		=	NULL
			SET	@v_segment3		=	@p_segment3
			SET	@p_segment3		=	NULL
			SET	@v_attribute1	=	@p_attribute1
			SET	@p_attribute1	=	NULL
			SET	@v_attribute2	=	@p_attribute2
			SET	@p_attribute2	=	NULL
			SET	@v_attribute3	=	@p_attribute3
			SET	@p_attribute3	=	NULL
			SET	@v_attribute4	=	@p_attribute4
			SET	@p_attribute4	=	NULL
			SET	@v_attribute5	=	@p_attribute5
			SET	@p_attribute5	=	NULL

			
			MERGE INTO [SCM_ADM_LOOKUP_VALUES] A
			USING (
					SELECT 
					 @v_lookup_type as lookup_type
					,@v_lookup_code as lookup_code
						
				  ) B
			ON(
					A.lookup_type = B.lookup_type	
				AND A.lookup_code = B.lookup_code
				)
			WHEN MATCHED THEN
					UPDATE SET 
					 division_id		=   @v_division_id
					,description		=	@v_l_description
					,display_seq		=	@v_display_seq
					,default_value_flag	=	@v_default_value_flag
					,valid_yn     		=	@v_valid_yn     
					,created_by			=	@v_created_by
					,creation_date		=	@v_creation_date
					,last_updated_by	=	@v_last_updated_by
					,last_update_date	=   sysdatetime()
					,segment1			=	@v_segment1
					,segment2			=	@v_segment2
					,segment3			=	@v_segment3
					,attribute1			=	@v_attribute1
					,attribute2			=	@v_attribute2
					,attribute3			=	@v_attribute3
					,attribute4			=	@v_attribute4
					,attribute5			=	@v_attribute5
			WHEN NOT MATCHED THEN
		
			  INSERT 
			   (
			    division_id		,lookup_type	,lookup_code		,description       
			   ,valid_yn		,display_seq	,default_value_flag       
			   ,created_by      ,creation_date  ,last_updated_by	,last_update_date           
			   ,segment1        ,segment2		,segment3      
			   ,attribute1      ,attribute2     ,attribute3			,attribute4    ,attribute5    
			  )
			  VALUES
			  (
			    @v_division_id	   ,@v_lookup_type	  ,@v_lookup_code		 ,@v_l_description       
			   ,@v_valid_yn		   ,@v_display_seq	  ,@v_default_value_flag       
			   ,@v_created_by      ,sysdatetime()     ,@v_last_updated_by	 ,sysdatetime()    
			   ,@v_segment1        ,@v_segment2		  ,@v_segment3         
			   ,@v_attribute1      ,@v_attribute2     ,@v_attribute3		 ,@v_attribute4       ,@v_attribute5  
			   )
		   
		   ;
				END	
			END

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
		END CATCH;
	END







