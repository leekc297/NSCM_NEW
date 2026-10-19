/* =============================================================================
프로그램ID	: SCP0114_SAVE_CAPA_LINE_MASTER
업  무  명	: CAPA LINE MASTER 등록
프로그램명	: CAPA LINEMASTER
최초작성일	: 2024.09.30
최종작성일	: 2024.09.30
개  발  자	: jahn1502
입  력  값	: 
출  력  값	: 
*===================================================================================================      
*   Date       In Charge	Description      
*===================================================================================================      
* 2024.09.30   jahn1502		Create   

============================================================================= */

CREATE PROCEDURE [dbo].[SCP0114_SAVE_CAPA_LINE_MASTER]
	 @p_active_flag				NVARCHAR(MAX)
	,@p_spreadSeq				NVARCHAR(MAX)
	,@p_division_id				NVARCHAR(MAX)
	,@p_site_id					NVARCHAR(MAX)
	,@p_site_name				NVARCHAR(MAX)
	,@p_company_id				NVARCHAR(MAX)
	,@p_company_name			NVARCHAR(MAX)
	,@p_plant_id				NVARCHAR(MAX)
	,@p_plant_name				NVARCHAR(MAX)
	,@p_factory_id				NVARCHAR(MAX)
	,@p_factory_name			NVARCHAR(MAX)
	,@p_line_id					NVARCHAR(MAX)
	,@p_line_name				NVARCHAR(MAX)
	,@p_shop_group_id			NVARCHAR(MAX)
	,@p_valid_yn				NVARCHAR(MAX)
	,@p_created_by				NVARCHAR(150) 
	,@p_last_updated_by			NVARCHAR(150)
AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DECLARE @recv_active_flag	NVARCHAR(MAX);
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_creation_date		datetime;		-- timezone에 따른 저장위해서
	DECLARE @v_transport_mode    NVARCHAR(100) = ''; --에러반환용

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	DECLARE @v_active_flag       NVARCHAR(MAX);  
	DECLARE @v_spreadSeq	     NVARCHAR(MAX);  
	DECLARE @v_division_id       NVARCHAR(MAX);  
	DECLARE @v_site_id           NVARCHAR(MAX);   
	DECLARE @v_site_name		 NVARCHAR(MAX);   
	DECLARE @v_company_id		 NVARCHAR(MAX);   
	DECLARE @v_company_name      NVARCHAR(MAX);   
	DECLARE @v_plant_id          NVARCHAR(MAX);   
	DECLARE @v_plant_name        NVARCHAR(MAX); 
	DECLARE @v_factory_id        NVARCHAR(MAX);   
	DECLARE @v_factory_name      NVARCHAR(MAX);
	DECLARE @v_line_id           NVARCHAR(MAX);   
	DECLARE @v_line_name         NVARCHAR(MAX);
	DECLARE @v_shop_group_id     NVARCHAR(MAX);   
	DECLARE @v_valid_yn          NVARCHAR(MAX);
	DECLARE @v_created_by        NVARCHAR(MAX);
	DECLARE @v_last_updated_by   NVARCHAR(MAX);	;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name		NVARCHAR(150) = 'SCP0114_SAVE_CAPA_LINE_MATER';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code			INTEGER;
	DECLARE @v_err_message		NVARCHAR(4000)='';

	-- 중복 체크
	DECLARE @v_dup_cnt			INT;
	DECLARE @v_where			NVARCHAR(MAX);
	DECLARE @Sql				NVARCHAR(MAX);
	DECLARE @param				NVARCHAR(MAX);

	SET @v_creation_date    = [dbo].[FN_MULTY_TIME](getdate()); 

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--SELECT @Sql, @v_dup_cnt;
		--EXEC(@Sql);
		--PRINT(@Sql);

		--IF( @v_dup_cnt>1) 
		--BEGIN
		--	SET @v_err_code    = 99020 ; 
		--	SET @v_err_message = N'중복 ID 입니다. ';
		--	THROW @v_err_code, @v_err_message , 1; --예외발생									 
		--END;


		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    


		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag		= dbo.SCM_ARR_SPL_VAL( @p_active_flag       , @v_delimiter, @mst_loop_cnt );
				SET @v_spreadSeq		= dbo.SCM_ARR_SPL_VAL( @p_spreadSeq         , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id      = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_site_id			= dbo.SCM_ARR_SPL_VAL( @p_site_id			, @v_delimiter, @mst_loop_cnt );
				SET @v_site_name		= dbo.SCM_ARR_SPL_VAL( @p_site_name			, @v_delimiter, @mst_loop_cnt );
				SET @v_company_id		= dbo.SCM_ARR_SPL_VAL( @p_company_id		, @v_delimiter, @mst_loop_cnt );
				SET @v_company_name     = dbo.SCM_ARR_SPL_VAL( @p_company_name      , @v_delimiter, @mst_loop_cnt );
				SET @v_plant_id			= dbo.SCM_ARR_SPL_VAL( @p_plant_id          , @v_delimiter, @mst_loop_cnt );
				SET @v_plant_name		= dbo.SCM_ARR_SPL_VAL( @p_plant_name        , @v_delimiter, @mst_loop_cnt );
				SET @v_factory_id       = dbo.SCM_ARR_SPL_VAL( @p_factory_id        , @v_delimiter, @mst_loop_cnt );
				SET @v_factory_name     = dbo.SCM_ARR_SPL_VAL( @p_factory_name      , @v_delimiter, @mst_loop_cnt );
				SET @v_line_id			= dbo.SCM_ARR_SPL_VAL( @p_line_id           , @v_delimiter, @mst_loop_cnt );
				SET @v_line_name		= dbo.SCM_ARR_SPL_VAL( @p_line_name         , @v_delimiter, @mst_loop_cnt );
				SET @v_shop_group_id    = dbo.SCM_ARR_SPL_VAL( @p_shop_group_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_valid_yn			= dbo.SCM_ARR_SPL_VAL( @p_valid_yn          , @v_delimiter, @mst_loop_cnt );
				SET @v_created_by       = dbo.SCM_ARR_SPL_VAL( @p_created_by        , @v_delimiter, @mst_loop_cnt );
				SET @v_last_updated_by  = dbo.SCM_ARR_SPL_VAL( @p_last_updated_by   , @v_delimiter, @mst_loop_cnt );
			END;


			IF @v_active_flag = 'I'
				BEGIN
					--ID 중복 체크
					SET @v_dup_cnt = 0;
					SET @v_where = ' WHERE 1=1';
					IF @v_spreadSeq = '1'
						BEGIN
							SET @v_where = @v_where + ' AND (SITE_ID = UPPER('''+@v_site_id+''') OR SITE_NAME = UPPER('''+@v_site_name+''')) ';
						END
					ELSE IF @v_spreadSeq = '2'
						BEGIN
							SET @v_where = @v_where + ' AND (COMPANY_ID = UPPER('''+@v_company_id+''') OR COMPANY_NAME = UPPER('''+@v_company_name+''')) ';
						END
					ELSE IF @v_spreadSeq = '3'
						BEGIN
							SET @v_where = @v_where + ' AND (PLANT_ID = UPPER('''+@v_plant_id+''') OR PLANT_NAME = UPPER('''+@v_plant_name+''')) ';
						END
					ELSE IF @v_spreadSeq = '4'
						BEGIN
							SET @v_where = @v_where + ' AND (FACTORY_ID = UPPER('''+@v_factory_id+''') OR FACTORY_NAME = UPPER('''+@v_factory_name+''')) ';
						END
					ELSE IF @v_spreadSeq = '5'
						BEGIN
							SET @v_where = @v_where + ' AND (LINE_ID = UPPER('''+@v_line_id+''') OR LINE_NAME = UPPER('''+@v_line_name+''')) ';
						END
				END;
			ELSE IF @v_active_flag = 'M'
				BEGIN
					--ID 중복 체크
					SET @v_dup_cnt = 0;
					SET @v_where = ' WHERE 1=1';
					IF @v_spreadSeq = '1'
						BEGIN
							SET @v_where = @v_where + ' AND SITE_NAME = UPPER('''+@v_site_name+''') ';
						END
					ELSE IF @v_spreadSeq = '2'
						BEGIN
							SET @v_where = @v_where + ' AND COMPANY_NAME = UPPER('''+@v_company_name+''') ';
						END
					ELSE IF @v_spreadSeq = '3'
						BEGIN
							SET @v_where = @v_where + ' AND PLANT_NAME = UPPER('''+@v_plant_name+''') ';
						END
					ELSE IF @v_spreadSeq = '4'
						BEGIN
							SET @v_where = @v_where + ' AND FACTORY_NAME = UPPER('''+@v_factory_name+''') ';
						END
					ELSE IF @v_spreadSeq = '5'
						BEGIN
							SET @v_where = @v_where + ' AND LINE_NAME = UPPER('''+@v_line_name+''') ';
						END
				END;
				
			IF @v_shop_group_id = 'E'
				BEGIN
					SET @Sql = N' SELECT @count = COUNT(*) FROM SCP_MST_CAPA_ELTR_LINE ' + @v_where ;
				END
			ELSE IF (@v_shop_group_id = 'P' OR @v_shop_group_id = 'A')
				BEGIN
					SET @Sql = N' SELECT @count = COUNT(*) FROM SCP_MST_CAPA_LINE ' + @v_where ;
				END
			ELSE IF (@v_shop_group_id = '-')
				BEGIN
					SET @Sql = N' SELECT @count = COUNT(*) FROM (SELECT A.* FROM SCP_MST_CAPA_LINE A UNION SELECT B.* FROM SCP_MST_CAPA_LINE B ) C ' + @v_where ;
				END

			EXEC sp_executesql @Sql, N'@count int output', @count=@v_dup_cnt OUTPUT;

			IF( @v_dup_cnt>0) 
				BEGIN
					SET @v_err_code    = 99020 ; 
					SET @v_err_message = N'중복 데이터가 있습니다.';
					THROW @v_err_code, @v_err_message , 1; --예외발생									 
				END;
		/*
				--NAME 중복 체크
				SET @v_dup_cnt = 0;
				SET @v_where = ' WHERE 1=1';
				IF @v_spreadSeq = '1'
					BEGIN
						SET @v_where = @v_where + ' AND SITE_NAME = UPPER('''+@v_site_name+''') AND SITE_ID <> UPPER('''+@v_site_id+''') ';
					END
				ELSE IF @v_spreadSeq = '2'
					BEGIN
						SET @v_where = @v_where + ' AND COMPANY_NAME = UPPER('''+@v_company_name+''') AND COMPANY_ID <> UPPER('''+@v_company_id+''') ';
					END
				ELSE IF @v_spreadSeq = '3'
					BEGIN
						SET @v_where = @v_where + ' AND PLANT_NAME = UPPER('''+@v_plant_name+''') AND PLANT_ID <> UPPER('''+@v_plant_id+''') ';
					END
				ELSE IF @v_spreadSeq = '4'
					BEGIN
						SET @v_where = @v_where + ' AND FACTORY_NAME = UPPER('''+@v_factory_name+''') AND FACTORY_ID <> UPPER('''+@v_factory_id+''') ';
					END
				ELSE IF @v_spreadSeq = '5'
					BEGIN
						SET @v_where = @v_where + ' AND LINE_NAME = UPPER('''+@v_line_name+''') AND LINE_ID <> UPPER('''+@v_line_id+''') ';
					END

		
				IF @v_shop_group_id = 'E'
					BEGIN
						SET @Sql = N' SELECT @count = COUNT(*) FROM SCP_MST_CAPA_ELTR_LINE ' + @v_where ;
					END
				ELSE IF (@v_shop_group_id = 'P' OR @v_shop_group_id = 'A')
					BEGIN
						SET @Sql = N' SELECT @count = COUNT(*) FROM SCP_MST_CAPA_LINE ' + @v_where ;
					END

				EXEC sp_executesql @Sql, N'@count int output', @count=@v_dup_cnt OUTPUT;

				IF( @v_dup_cnt>0) 
				BEGIN
					SET @v_err_code    = 99020 ; 
					SET @v_err_message = N'중복 NAME 입니다. ';
					THROW @v_err_code, @v_err_message , 1; --예외발생									 
				END;
			*/

			--데이터 저장
			IF @mst_loop_cnt > 0
				BEGIN
					IF ( @v_active_flag = 'I' AND @v_shop_group_id = '-')
						BEGIN		
							INSERT INTO dbo.SCP_MST_CAPA_LINE
								(DIVISION_ID
								,COMPANY_ID
								,SITE_ID
								,PLANT_ID
								,FACTORY_ID
								,LINE_ID
								,OPERATION_ID
								,ELTR_LN_TP_CD
								,SITE_NAME
								,PLANT_NAME
								,FACTORY_NAME
								,LINE_NAME
								,VALID_YN
								,ATTRIBUTE1
								,ATTRIBUTE2
								,ATTRIBUTE3
								,ATTRIBUTE4
								,ATTRIBUTE5
								,ATTRIBUTE6
								,ATTRIBUTE7
								,ATTRIBUTE8
								,ATTRIBUTE9
								,ATTRIBUTE10
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE
								,COMPANY_NAME
							)
							VALUES
								(@v_division_id  
								,UPPER(@v_company_id)
								,UPPER(@v_site_id)
								,UPPER(@v_plant_id)
								,UPPER(@v_factory_id)		
								,UPPER(@v_line_id)
								,'-'		
								,'-'		
								,@v_site_name	
								,@v_plant_name	
								,@v_factory_name		
								,@v_line_name
								,@v_valid_yn
								,@v_shop_group_id
								,'Y'
								,''
								,''
								,''
								,''
								,''
								,''
								,''
								,''
								,@v_created_by		
								,GETDATE()
								,@v_last_updated_by
								,GETDATE()
								,@v_company_name
							);

							INSERT INTO dbo.SCP_MST_CAPA_ELTR_LINE
								(DIVISION_ID
								,COMPANY_ID
								,SITE_ID
								,PLANT_ID
								,FACTORY_ID
								,LINE_ID
								,OPERATION_ID
								,ELTR_LN_TP_CD
								,SITE_NAME
								,PLANT_NAME
								,FACTORY_NAME
								,LINE_NAME
								,VALID_YN
								,ATTRIBUTE1
								,ATTRIBUTE2
								,ATTRIBUTE3
								,ATTRIBUTE4
								,ATTRIBUTE5
								,ATTRIBUTE6
								,ATTRIBUTE7
								,ATTRIBUTE8
								,ATTRIBUTE9
								,ATTRIBUTE10
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE
								,COMPANY_NAME
							)
							VALUES
								(@v_division_id  
								,UPPER(@v_company_id)
								,UPPER(@v_site_id)
								,UPPER(@v_plant_id)
								,UPPER(@v_factory_id)		
								,UPPER(@v_line_id)
								,'-'		
								,'-'		
								,@v_site_name	
								,@v_plant_name	
								,@v_factory_name		
								,@v_line_name
								,@v_valid_yn
								,@v_shop_group_id
								,'Y'
								,''
								,''
								,''
								,''
								,''
								,''
								,''
								,''
								,@v_created_by		
								,GETDATE()
								,@v_last_updated_by
								,GETDATE()
								,@v_company_name
							);
						END
					ELSE IF( @v_active_flag = 'I' AND (@v_shop_group_id = 'P' or @v_shop_group_id = 'A'))
						BEGIN
								INSERT INTO dbo.SCP_MST_CAPA_LINE
									(DIVISION_ID
									,COMPANY_ID
									,SITE_ID
									,PLANT_ID
									,FACTORY_ID
									,LINE_ID
									,OPERATION_ID
									,ELTR_LN_TP_CD
									,SITE_NAME
									,PLANT_NAME
									,FACTORY_NAME
									,LINE_NAME
									,VALID_YN
									,ATTRIBUTE1
									,ATTRIBUTE2
									,ATTRIBUTE3
									,ATTRIBUTE4
									,ATTRIBUTE5
									,ATTRIBUTE6
									,ATTRIBUTE7
									,ATTRIBUTE8
									,ATTRIBUTE9
									,ATTRIBUTE10
									,CREATED_BY
									,CREATION_DATE
									,LAST_UPDATED_BY
									,LAST_UPDATE_DATE
									,COMPANY_NAME
								)
								VALUES
									(@v_division_id  
									,UPPER(@v_company_id)
									,UPPER(@v_site_id)
									,UPPER(@v_plant_id)
									,UPPER(@v_factory_id)		
									,UPPER(@v_line_id)
									,'-'		
									,'-'		
									,@v_site_name	
									,@v_plant_name	
									,@v_factory_name		
									,@v_line_name
									,@v_valid_yn
									,@v_shop_group_id
									,'Y'
									,''
									,''
									,''
									,''
									,''
									,''
									,''
									,''
									,@v_created_by		
									,GETDATE()
									,@v_last_updated_by
									,GETDATE()
									,@v_company_name
								);
						END;
					ELSE IF(@v_active_flag = 'I' AND @v_shop_group_id = 'E')
						BEGIN
								INSERT INTO dbo.SCP_MST_CAPA_ELTR_LINE
									(DIVISION_ID
									,COMPANY_ID
									,SITE_ID
									,PLANT_ID
									,FACTORY_ID
									,LINE_ID
									,OPERATION_ID
									,ELTR_LN_TP_CD
									,SITE_NAME
									,PLANT_NAME
									,FACTORY_NAME
									,LINE_NAME
									,VALID_YN
									,ATTRIBUTE1
									,ATTRIBUTE2
									,ATTRIBUTE3
									,ATTRIBUTE4
									,ATTRIBUTE5
									,ATTRIBUTE6
									,ATTRIBUTE7
									,ATTRIBUTE8
									,ATTRIBUTE9
									,ATTRIBUTE10
									,CREATED_BY
									,CREATION_DATE
									,LAST_UPDATED_BY
									,LAST_UPDATE_DATE
									,COMPANY_NAME
								)
								VALUES
									(@v_division_id  
									,UPPER(@v_company_id)
									,UPPER(@v_site_id)
									,UPPER(@v_plant_id)
									,UPPER(@v_factory_id)		
									,UPPER(@v_line_id)
									,'-'		
									,'-'		
									,@v_site_name	
									,@v_plant_name	
									,@v_factory_name		
									,@v_line_name
									,@v_valid_yn
									,@v_shop_group_id
									,'Y'
									,''
									,''
									,''
									,''
									,''
									,''
									,''
									,''
									,@v_created_by		
									,GETDATE()
									,@v_last_updated_by
									,GETDATE()
									,@v_company_name
								);
						END
					ELSE IF(@v_active_flag ='M' AND @v_spreadSeq = '1' AND @v_shop_group_id = '-')
						BEGIN
								UPDATE dbo.SCP_MST_CAPA_LINE                 
								   SET
									  SITE_NAME			= @v_site_name
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= UPPER(@v_division_id)
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND ATTRIBUTE2		= 'Y'

								UPDATE dbo.SCP_MST_CAPA_ELTR_LINE                 
								   SET
									  SITE_NAME			= @v_site_name
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= @v_division_id
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND ATTRIBUTE2		= 'Y'
						END;
					ELSE IF(@v_active_flag ='M' AND @v_spreadSeq = '2' AND @v_shop_group_id = '-')
						BEGIN
								UPDATE dbo.SCP_MST_CAPA_LINE                 
								   SET
									  COMPANY_NAME		= @v_company_name
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= UPPER(@v_division_id)
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND COMPANY_ID		= @v_company_id
								   AND ATTRIBUTE2		= 'Y'

								UPDATE dbo.SCP_MST_CAPA_ELTR_LINE                 
								   SET
									  COMPANY_NAME		= @v_company_name
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= @v_division_id
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND COMPANY_ID		= UPPER(@v_company_id)
								   AND ATTRIBUTE2		= 'Y'
						END;
					ELSE IF(@v_active_flag ='M' AND @v_spreadSeq = '3' AND @v_shop_group_id = '-')
						BEGIN
								UPDATE dbo.SCP_MST_CAPA_LINE                 
								   SET
									  PLANT_NAME		= @v_plant_name
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= @v_division_id
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND COMPANY_ID		= UPPER(@v_company_id)
								   AND PLANT_ID			= UPPER(@v_plant_id)
								   AND ATTRIBUTE2		= 'Y'
								;
								UPDATE dbo.SCP_MST_CAPA_ELTR_LINE                 
								   SET
									  PLANT_NAME		= @v_plant_name
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= @v_division_id
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND COMPANY_ID		= UPPER(@v_company_id)
								   AND PLANT_ID			= UPPER(@v_plant_id)
								   AND ATTRIBUTE2		= 'Y'
								;
						END;
					ELSE IF(@v_active_flag ='M' AND @v_spreadSeq = '4' AND (@v_shop_group_id = 'P' or @v_shop_group_id = 'A'))
						BEGIN
								UPDATE dbo.SCP_MST_CAPA_LINE                 
								   SET
									  FACTORY_NAME		= @v_factory_name
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= UPPER(@v_division_id)
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND COMPANY_ID		= UPPER(@v_company_id)
								   AND PLANT_ID			= UPPER(@v_plant_id)
								   AND FACTORY_ID		= UPPER(@v_factory_id)
								   AND ATTRIBUTE2		= 'Y'
								;
						END;
					ELSE IF(@v_active_flag ='M' AND @v_spreadSeq = '5' AND (@v_shop_group_id = 'P' or @v_shop_group_id = 'A'))
						BEGIN
								UPDATE dbo.SCP_MST_CAPA_LINE                 
								   SET
									  LINE_NAME			= @v_line_name
									 ,VALID_YN			= @v_valid_yn
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= UPPER(@v_division_id)
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND COMPANY_ID		= UPPER(@v_company_id)
								   AND PLANT_ID			= UPPER(@v_plant_id)
								   AND FACTORY_ID		= UPPER(@v_factory_id)
								   AND LINE_ID			= UPPER(@v_line_id)
								   AND ATTRIBUTE2		= 'Y'
								;
						END;
					ELSE IF(@v_active_flag ='M' AND @v_spreadSeq = '4' AND @v_shop_group_id = 'E')
						BEGIN
								UPDATE dbo.SCP_MST_CAPA_ELTR_LINE                 
								   SET
									  FACTORY_NAME		= @v_factory_name
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= @v_division_id
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND COMPANY_ID		= UPPER(@v_company_id)
								   AND PLANT_ID			= UPPER(@v_plant_id)
								   AND FACTORY_ID		= UPPER(@v_factory_id)
								   AND ATTRIBUTE2		= 'Y'
								;
						END;
					ELSE IF(@v_active_flag ='M' AND @v_spreadSeq = '5' AND @v_shop_group_id = 'E')
						BEGIN
								UPDATE dbo.SCP_MST_CAPA_ELTR_LINE                 
								   SET
									  LINE_NAME			= @v_line_name
									 ,LAST_UPDATED_BY	= @v_last_updated_by 
									 ,LAST_UPDATE_DATE	= GETDATE()
								 WHERE 1=1
								   AND DIVISION_ID		= @v_division_id
								   AND SITE_ID			= UPPER(@v_site_id)
								   AND COMPANY_ID		= UPPER(@v_company_id)
								   AND PLANT_ID			= UPPER(@v_plant_id)
								   AND FACTORY_ID		= UPPER(@v_factory_id)
								   AND LINE_ID			= UPPER(@v_line_id)
								   AND ATTRIBUTE2		= 'Y'
								;
						END;
				END;
		END;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			IF( @v_err_message IS NULL OR @v_err_message ='')
				SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
			ELSE
				SELECT 'N' AS result_code, @v_err_message AS ERR_MESSAGE ;

		END;
	END CATCH;
END;