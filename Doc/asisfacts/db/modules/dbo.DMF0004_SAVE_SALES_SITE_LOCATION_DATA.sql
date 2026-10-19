
/*============================================================================================================================
 * Program ID  : [DMF0004_SAVE_SALES_SITE_LOCATION_DATA]												
 * Description : SCM_MST_SITE HISTORYT INSERT														
 * Usage       : Procedure 작성 시 참조하세요!                                                       
 * Parameter   :                                                                                    
 *                                                                                                  
 *============================================================================================================================
 *	  Date		In Charge		Description                                                             
 *============================================================================================================================
 * 2017/12/07	DWOK/DWPARK		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트   
 * 2018/10/19	KHSONG			중복값 VALIDATION 추가                                                   
 * 2020/03/03	P.C.I			[C20200224-000354] SLOC 입력 시 SLOC Master에 존재하는지 확인             
 * 2022/10/24	rosia27			[C20221024-000510]DM UI 소스 정리 요청				
 * 2026/01/08	JSSBAE			[E20260107-001541]_Sales Site - Sales Location 로직 개선					
============================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0004_SAVE_SALES_SITE_LOCATION_DATA]
	  @p_active_flag					NVARCHAR(MAX)
	, @p_location_seq					NVARCHAR(MAX)
	, @p_division_id					NVARCHAR(MAX)
	, @p_location_code					NVARCHAR(MAX)
	, @p_location_description			NVARCHAR(MAX)
	, @p_scm_site_id					NVARCHAR(MAX)
	, @p_plant_id						NVARCHAR(MAX)
	, @p_storage_id						NVARCHAR(MAX)
	, @p_valid_yn						NVARCHAR(MAX)
	, @p_created_by						NVARCHAR(MAX)
AS

BEGIN
	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag			NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;
	-- 자식 프로시저 성공/에러 셋팅
	--DECLARE	@v_OK_description			NVARCHAR(1200);	

	DECLARE @v_active_flag				NVARCHAR(MAX);
	DECLARE @v_division_id				NVARCHAR(MAX);
	DECLARE @v_location_code			NVARCHAR(MAX);
	DECLARE @v_location_description		NVARCHAR(MAX);
	DECLARE @v_scm_site_id				NVARCHAR(MAX);
	DECLARE @v_plant_id					NVARCHAR(MAX);
	DECLARE @v_storage_id				NVARCHAR(MAX);
	DECLARE @v_valid_yn					NVARCHAR(MAX);
	DECLARE @v_location_seq				NVARCHAR(MAX);
	DECLARE @v_created_by				NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_location_code = NULL;
	SET @v_location_description = NULL;	 
	SET @v_scm_site_id = NULL;
	SET @v_plant_id = NULL;
	SET @v_storage_id = NULL;	 
	SET @v_valid_yn = NULL;
	SET @v_location_seq = NULL;
	SET @v_created_by = NULL;

	DECLARE @v_delimiter				NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt				INTEGER = 0; 
	DECLARE @mst_loop_cnt				INTEGER = 0;
	DECLARE @n_location_seq				INTEGER = 0;

	--====================================================================================================================
	-- LOG 용 변수 설정 (START)
	--====================================================================================================================
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0004_SAVE_SALES_SITE_LOCATION_DATA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	--====================================================================================================================
	-- LOG 용 변수 설정 (END)
	--====================================================================================================================
	
	--====================================================================================================================
	-- 시작 LOG (START)
	--====================================================================================================================
	SET @v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########';
	SET @v_description	= '';
	SET @d_event_date	= SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--====================================================================================================================
	-- 시작 LOG (END)
	--====================================================================================================================

	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN SALES_SITE_LOCATION_DATA;	
	BEGIN TRY
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		--SELECT    @max_loop_cnt;

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- location_seq 채번
			SET @n_location_seq = NEXT VALUE FOR SEQ1_SCM_MST_LOCATION		-- -- SEQ1_SCM_MST_LOCATION 으로 만들겠습니다.
			--SELECT @n_location_seq

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_active_flag
					  
				SET @v_location_seq = [dbo].[SCM_ARR_SPL_VAL](@p_location_seq, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_location_seq

				IF @v_location_seq = ''
				BEGIN
					SET @v_location_seq =@n_location_seq;
				END;

				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_division_id

				SET @v_location_code = [dbo].[SCM_ARR_SPL_VAL](@p_location_code, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_location_code

				SET @v_location_description = [dbo].[SCM_ARR_SPL_VAL](@p_location_description, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_location_description
			
				SET @v_scm_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_scm_site_id

				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_plant_id

				SET @v_storage_id = [dbo].[SCM_ARR_SPL_VAL](@p_storage_id, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_storage_id

				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_valid_yn

				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_created_by						
			END
			/*
			-------------------------------------------------------------------------------------------------------------------------------------
			-- [E20260107-001541]_GERP -> NERP로 변환되면서, 구코드는 저장되지 않도록 VALIDATION 추가 (START)
			-- 1. STORAGE_ID 구코드 여부 확인
			IF ( SELECT COUNT(STORAGE_ID) FROM SCM_MST_SLOC WITH(NOLOCK) 
				  WHERE DIVISION_ID = @v_division_id
				    AND PLANT_ID	= @v_PLANT_ID 
					AND STORAGE_ID	= @v_location_code
					AND VALID_YN	= 'N' ) > 0							
			BEGIN
				SELECT N'STORAGE ID : ' + @v_location_code + N' 은(는) 구코드 STORAGE입니다.' + char(10) + N'구코드는 저장이 불가능합니다. ';
				SET @v_log_type		= 'INVALID';
				SET @v_description	= N'STORAGE id : ' + @v_location_code + N' 은(는) 구코드 STORAGE입니다.' + char(10) + N'구코드는 저장이 불가능합니다. ';
				GOTO ERR_RTN;	
			END

			-- 2. PLANT_ID 구코드 여부 확인
			IF ( SELECT COUNT(PLANT_ID) FROM SCM_MST_SLOC WITH(NOLOCK) 
				  WHERE DIVISION_ID = @v_division_id
				    AND PLANT_ID	= @v_PLANT_ID 
					AND VALID_YN	= 'N' ) > 0											
			BEGIN
				SELECT N'PLANT ID : ' + @v_PLANT_ID + N' 은(는) 구코드 PLANT ID입니다.' + char(10) + N'구코드는 저장이 불가능합니다. ';
				SET @v_log_type		= 'INVALID';
				SET @v_description	= N'PLANT ID : ' + @v_PLANT_ID + N' 은(는) 구코드 PLANT ID입니다. ' + char(10) + N'구코드는 저장이 불가능합니다. ';
				GOTO ERR_RTN;	
			END
			-- [E20260107-001541]_GERP -> NERP로 변환되면서, 구코드는 저장되지 않도록 VALIDATION 추가 (END)
			-------------------------------------------------------------------------------------------------------------------------------------
			*/
			-- [C20200224-000354] SLOC 입력 시 SLOC Master에 존재하는지 확인
			IF NOT EXISTS ( SELECT TOP 1 ISNULL(A.STORAGE_ID,'')
							  FROM SCM_MST_SLOC A WITH(NOLOCK)
							 WHERE 1=1
							  AND A.VALID_YN	= 'Y'
							  AND A.DIVISION_ID	= @v_division_id
							  AND A.PLANT_ID	= @v_PLANT_ID
							  AND A.STORAGE_ID	= @v_location_code )							
			BEGIN
				SELECT N'storage id : ' + @v_location_code + N' 은(는) 존재하지 않는 Storage 입니다.';
				SET @v_log_type		= 'INVALID';
				SET @v_description	= N'storage id : ' + @v_location_code + N' 은(는) 존재하지 않는 Storage 입니다.';
				GOTO ERR_RTN;	
			END

			-- 20181019 KHSONG 중복값 VALIDATION 추가
			DECLARE @s_scm_site_id  NVARCHAR(100);
			SET @s_scm_site_id = ''

			SET @s_scm_site_id = ( SELECT TOP 1 ISNULL(A.SCM_SITE_ID,'')
									 FROM SCM_MST_LOCATION A WITH(NOLOCK)
									INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
											ON A.DIVISION_ID = B.DIVISION_ID
										   AND B.SCM_SITE_ID = @v_scm_site_id
										   AND B.SITE_TYPE   = 'SALES'
										   AND A.VALID_YN    = 'Y'
									WHERE 1=1
									  AND A.DIVISION_ID		= @v_division_id
									  AND A.PLANT_ID		= @v_PLANT_ID
									  AND A.STORAGE_ID		= @v_storage_id
									  AND A.SCM_SITE_ID	   <> @v_scm_site_id )

			IF @s_scm_site_id <> ''
			BEGIN
				SELECT N'storage id : ' + @v_storage_id + N' 은(는)' + N'  Sales Site : ' + @s_scm_site_id + N' 에서' +char(10) + N'이미 사용중입니다.';
				SET @v_log_type		= 'INVALID';
				SET @v_description	= N'storage id : ' + @v_storage_id + N' 은(는)' + N'  Sales Site : ' + @s_scm_site_id + N' 에서' +char(10) + N'이미 사용중입니다.';
				GOTO ERR_RTN;	
			END
			-- 20181019 KHSONG 중복값 VALIDATION 추가

			EXEC [dbo].[PR_DM_MST_SITE_SLOC_MAPPING_HIST]	--@return_value = [dbo].[PR_DM_MST_SITE_SLOC_MAPPING_HIST]
			  @v_location_seq
			, @v_division_id
			, @v_location_code
			, @v_location_description
			, @v_scm_site_id
			, @v_plant_id
			, '***'		--@p_factory_id
			, '***'		--@p_operation_id
			, @v_storage_id
			, NULL		--@p_electrode_type,
			, @v_valid_yn		--@p_valid_yn,
			, @v_created_by
					
			--SELECT @v_OK_description;
			--@v_OK_description OUTPUT
				
			IF @mst_loop_cnt > 0 
			BEGIN       		
				-- SEQ1_SCM_MST_LOCATION 으로 만들겠습니다.
				MERGE INTO [dbo].[SCM_MST_LOCATION] A
				USING (	SELECT @v_location_seq	AS LOCATION_SEQ
							 , @v_division_id	AS DIVISION_ID
							 , @v_location_code	AS LOCATION_CODE ) B
				   ON (		A.LOCATION_SEQ	= B.LOCATION_SEQ
						AND A.DIVISION_ID	= B.DIVISION_ID
						AND A.LOCATION_CODE = B.LOCATION_CODE )
				WHEN MATCHED THEN
					UPDATE SET --location_seq			= @n_location_seq
							    DIVISION_ID				= @v_division_id
							  , LOCATION_CODE			= @v_location_code 
							  , LOCATION_DESCRIPTION	= @v_location_description
							  , SCM_SITE_ID				= @v_scm_site_id
							  , PLANT_ID				= @v_plant_id
							  , FACTORY_ID				= '***'
							  , OPERATION_ID			= '***'
							  , STORAGE_ID				= @v_storage_id
							  , VALID_YN				= @v_valid_yn
							  , LAST_UPDATED_BY			= @v_created_by
							  , LAST_UPDATE_DATE		= sysdatetime()
				WHEN NOT MATCHED THEN			        
					INSERT (  LOCATION_SEQ
							, DIVISION_ID, LOCATION_CODE, LOCATION_DESCRIPTION, SCM_SITE_ID	
							, PLANT_ID, FACTORY_ID, OPERATION_ID, STORAGE_ID, VALID_YN
							, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
					VALUES (  @v_location_seq		--@n_location_seq+8000
							, @v_division_id, @v_location_code, @v_location_description, @v_scm_site_id
							, @v_plant_id, '***', '***', @v_storage_id, @v_valid_yn
							, @v_created_by, sysdatetime(), @v_created_by, sysdatetime());

			END
			ELSE    --단일 ROW 일때			 
			BEGIN        
				SET @v_active_flag			= @p_active_flag        
				SET @p_active_flag			= NULL       
				SET @v_location_seq			= @p_location_seq     
				SET @p_location_seq			= NULL  
				SET @v_division_id			= @p_division_id        
				SET @p_division_id			= NULL    
				SET @v_location_code		= @p_location_code     
				SET @p_location_code		= NULL  
				SET @v_location_description	= @p_location_description        
				SET @p_location_description	= NULL    
				SET @v_scm_site_id			= @p_scm_site_id       
				SET @p_scm_site_id			= NULL  
				SET @v_storage_id			= @p_storage_id        
				SET @p_storage_id			= NULL  
				SET @v_valid_yn				= @p_valid_yn       
				SET @p_valid_yn				= NULL  
				SET @v_created_by			= @p_created_by
				SET @p_created_by			= NULL

				-- location_seq 채번
				SET @n_location_seq = NEXT VALUE FOR SEQ1_SCM_MST_LOCATION		-- -- SEQ1_SCM_MST_LOCATION 으로 만들겠습니다.
				--SELECT @n_location_seq

				IF @p_location_seq = ''
				BEGIN
					SET @v_location_seq = @n_location_seq;
				END;

				--HISTORY INSERT

				EXEC [dbo].[PR_DM_MST_SITE_SLOC_MAPPING_HIST]	--@return_value = [dbo].[PR_DM_MST_SITE_SLOC_MAPPING_HIST]
					 @v_location_seq
				   , @v_division_id
				   , @v_location_code
				   , @v_location_description
				   , @v_scm_site_id
				   , @v_plant_id
				   , '***'		--@p_factory_id
				   , '***'		--@p_operation_id
				   , @v_storage_id
				   , NULL		--@p_electrode_type,
				   , @v_valid_yn		--@p_valid_yn,
				   , @v_created_by
					
					--SELECT @v_OK_description;
					--@v_OK_description OUTPUT
										

				MERGE INTO [dbo].[SCM_MST_LOCATION] A
				USING (	SELECT @v_location_seq		AS LOCATION_SEQ
							 , @v_division_id		AS DIVISION_ID
							 , @v_location_code		AS LOCATION_CODE ) B
				   ON (		A.LOCATION_SEQ	= B.LOCATION_SEQ
						AND A.DIVISION_ID	= B.DIVISION_ID
						AND A.LOCATION_CODE = B.LOCATION_CODE )
				WHEN MATCHED THEN
					UPDATE SET --location_seq			= @n_location_seq+8000
							   LOCATION_SEQ				= @v_location_seq
							 , DIVISION_ID				= @v_division_id
							 , LOCATION_CODE			= @v_location_code 
							 , LOCATION_DESCRIPTION		= @v_location_description
							 , SCM_SITE_ID				= @v_scm_site_id
							 , PLANT_ID					= @v_plant_id
							 , FACTORY_ID				= '***'
							 , OPERATION_ID				= '***'
							 , STORAGE_ID				= @v_storage_id
							 , VALID_YN					= @v_valid_yn
							 , LAST_UPDATED_BY			= @v_created_by
							 , LAST_UPDATE_DATE			= sysdatetime()
				WHEN NOT MATCHED THEN
					INSERT ( LOCATION_SEQ
							, DIVISION_ID, LOCATION_CODE, LOCATION_DESCRIPTION, SCM_SITE_ID	
							, PLANT_ID, FACTORY_ID, OPERATION_ID, STORAGE_ID, VALID_YN		
							, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
					VALUES ( @v_location_seq	-- @n_location_seq+8000
						   , @v_division_id, @v_location_code, @v_location_description, @v_scm_site_id
						   , @v_plant_id, '***', '***', @v_storage_id, @v_valid_yn
						   , @v_created_by, sysdatetime(), @v_created_by, sysdatetime());

			END

		END

		COMMIT ;	

	END TRY

   	BEGIN CATCH
		ROLLBACK TRAN SALES_SITE_LOCATION_DATA;		      -- ROLLBACK

		  -- ERROR LOG
		  SET @v_log_type = 'ERROR';
		  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		  SET @d_event_date = SYSDATETIME();

		  --IF @v_OK_description <> 'OK'
		  --SET @v_log_message = CAST(@v_OK_description AS NVARCHAR(1000));

		  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

    END CATCH;

	--select 'success'

	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	-- INVALID 인경우 ROLLBACK 처리
	ERR_RTN:
	IF  @v_log_type = 'INVALID'
	BEGIN
		ROLLBACK TRAN SALES_SITE_LOCATION_DATA;	
		-- 종료 LOG
		SET @v_log_message = '########## END of procedure ##########';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END;

  END;