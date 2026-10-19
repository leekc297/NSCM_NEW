
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
 * Program ID   : DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
 * Description  : 'DM_MST_CONTRIBUTE_RATIO' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190730  KHSONG  Initial Release [PJ20189106] 전지.GSCM 고도화 이행, DM 시스템
 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 
 */

CREATE PROCEDURE [dbo].[DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO]

	-- Add the parameters for the stored procedure here
     @p_active_flag				NVARCHAR(MAX)
    ,@p_ver_seq					NVARCHAR(MAX)
    ,@p_department_id			NVARCHAR(MAX)
    ,@p_dept_id					NVARCHAR(MAX)
    ,@p_end_cust_report			NVARCHAR(MAX)
    ,@p_soldto_cust_report		NVARCHAR(MAX)
    ,@p_product_group			NVARCHAR(MAX)
    ,@p_dm_biz_type				NVARCHAR(MAX)
    ,@p_yyyymm					NVARCHAR(MAX)
    ,@p_os_corp_cd				NVARCHAR(MAX)
    ,@p_contribution_type		NVARCHAR(MAX)
    ,@p_contribution_ratio		NVARCHAR(MAX)
    ,@p_created_by				NVARCHAR(MAX)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- 스플릿관련 변수

    DECLARE  @v_active_flag					NVARCHAR(MAX);
    DECLARE  @v_ver_seq						NVARCHAR(MAX);
    DECLARE  @v_department_id				NVARCHAR(MAX);
    DECLARE  @v_dept_id						NVARCHAR(MAX);
    DECLARE  @v_end_cust_report				NVARCHAR(MAX);
    DECLARE  @v_soldto_cust_report			NVARCHAR(MAX);
    DECLARE  @v_product_group				NVARCHAR(MAX);
    DECLARE  @v_dm_biz_type					NVARCHAR(MAX);
    DECLARE  @v_yyyymm						NVARCHAR(MAX);
    DECLARE  @v_os_corp_cd					NVARCHAR(MAX);
    DECLARE  @v_contribution_type			NVARCHAR(MAX);
    DECLARE  @v_contribution_ratio			NVARCHAR(MAX);
    DECLARE  @v_created_by					NVARCHAR(MAX);

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @max_ver_seq	 	NVARCHAR(MAX);
    
	-- LOG 용 변수 설정
    DECLARE @v_program_name		NVARCHAR(150) = 'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_log_description  NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
    DECLARE @n_delete_count		INTEGER = 0;
    DECLARE @n_insert_count		INTEGER = 0;
    DECLARE @n_input_count		INTEGER = 0;
    DECLARE @n_logo_count		INTEGER = 0;



	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag					= RTRIM(@p_active_flag				    ) + '^';
	SET @p_ver_seq						= RTRIM(@p_ver_seq					    ) + '^';
	SET @p_department_id				= RTRIM(@p_department_id			    ) + '^';
	SET @p_dept_id						= RTRIM(@p_dept_id					    ) + '^';
	SET @p_end_cust_report				= RTRIM(@p_end_cust_report			    ) + '^';
	SET @p_soldto_cust_report			= RTRIM(@p_soldto_cust_report			) + '^';
	SET @p_product_group				= RTRIM(@p_product_group			    ) + '^';
	SET @p_dm_biz_type					= RTRIM(@p_dm_biz_type				    ) + '^';
	SET @p_yyyymm						= RTRIM(@p_yyyymm					    ) + '^';
	SET @p_os_corp_cd					= RTRIM(@p_os_corp_cd				    ) + '^';
	SET @p_contribution_type			= RTRIM(@p_contribution_type		    ) + '^';
	SET @p_contribution_ratio			= RTRIM(@p_contribution_ratio		    ) + '^';
	SET @p_created_by					= RTRIM(@p_created_by				    ) + '^';

	-- #results_MST TEMP TABLE
	CREATE TABLE #results_MST  (
								 active_flag		NVARCHAR(max)
								,ver_seq			NVARCHAR(max)
								,department_id		NVARCHAR(max)
								,dept_id			NVARCHAR(max)
								,end_cust_report	NVARCHAR(max)
								,soldto_cust_report	NVARCHAR(max)
								,product_group		NVARCHAR(max)
								,dm_biz_type		NVARCHAR(max)
								,yyyymm				NVARCHAR(max)
								,os_corp_cd			NVARCHAR(max)
								,contribution_type	NVARCHAR(max)
								,contribution_ratio	NVARCHAR(max)
								,created_by			NVARCHAR(max)
							    )

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_log_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION SAVE_DM_MST_CONTRIBUTE_RATIO;

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------

	--===================================================================================== #results_MST 테이블에 split후 insert start
	--###############################################  #results_MST 테이블에 split후 insert (START)
	WHILE LEN(@p_ver_seq) > 0
	BEGIN
		DECLARE @index_active_flag				INT
		DECLARE @index_ver_seq					INT
		DECLARE @index_department_id			INT
		DECLARE @index_dept_id					INT
		DECLARE @index_end_cust_report			INT
		DECLARE @index_soldto_cust_report		INT
		DECLARE @index_product_group			INT
		DECLARE @index_dm_biz_type				INT
		DECLARE @index_yyyymm					INT
		DECLARE @index_os_corp_cd				INT
		DECLARE @index_contribution_type		INT
		DECLARE @index_contribution_ratio		INT
		DECLARE @index_created_by				INT

		SET @index_active_flag					= PATINDEX('%' + '^' + '%', @p_active_flag				)
		SET @index_ver_seq						= PATINDEX('%' + '^' + '%', @p_ver_seq					)
		SET @index_department_id				= PATINDEX('%' + '^' + '%', @p_department_id			)
		SET @index_dept_id						= PATINDEX('%' + '^' + '%', @p_dept_id					)
		SET @index_end_cust_report				= PATINDEX('%' + '^' + '%', @p_end_cust_report			)
		SET @index_soldto_cust_report			= PATINDEX('%' + '^' + '%', @p_soldto_cust_report		)
		SET @index_product_group				= PATINDEX('%' + '^' + '%', @p_product_group			)
		SET @index_dm_biz_type					= PATINDEX('%' + '^' + '%', @p_dm_biz_type				)
		SET @index_yyyymm						= PATINDEX('%' + '^' + '%', @p_yyyymm					)
		SET @index_os_corp_cd					= PATINDEX('%' + '^' + '%', @p_os_corp_cd				)
		SET @index_contribution_type			= PATINDEX('%' + '^' + '%', @p_contribution_type		)
		SET @index_contribution_ratio			= PATINDEX('%' + '^' + '%', @p_contribution_ratio		)
		SET @index_created_by					= PATINDEX('%' + '^' + '%', @p_created_by				)

		IF @p_ver_seq is not null
			BEGIN

				set @v_active_flag			 = substring(@p_active_flag			, 0, @index_active_flag			)
				set @v_ver_seq				 = substring(@p_ver_seq				, 0, @index_ver_seq				)
				set @v_department_id		 = substring(@p_department_id		, 0, @index_department_id		)
				set @v_dept_id				 = substring(@p_dept_id				, 0, @index_dept_id				)
				set @v_end_cust_report		 = substring(@p_end_cust_report		, 0, @index_end_cust_report		)
				set @v_soldto_cust_report	 = substring(@p_soldto_cust_report	, 0, @index_soldto_cust_report	)
				set @v_product_group		 = substring(@p_product_group		, 0, @index_product_group		)
				set @v_dm_biz_type			 = substring(@p_dm_biz_type			, 0, @index_dm_biz_type			)
				set @v_yyyymm				 = substring(@p_yyyymm				, 0, @index_yyyymm				)
				set @v_os_corp_cd			 = substring(@p_os_corp_cd			, 0, @index_os_corp_cd			)
				set @v_contribution_type	 = substring(@p_contribution_type	, 0, @index_contribution_type	)
				set @v_contribution_ratio	 = substring(@p_contribution_ratio	, 0, @index_contribution_ratio	)
				set @v_created_by			 = substring(@p_created_by			, 0, @index_created_by			)

				set @p_active_flag			 = substring(@p_active_flag			, len(@v_active_flag			+ '^') + 1, len(@p_active_flag			))
				set @p_ver_seq				 = substring(@p_ver_seq				, len(@v_ver_seq				+ '^') + 1, len(@p_ver_seq				))
				set @p_department_id		 = substring(@p_department_id		, len(@v_department_id			+ '^') + 1, len(@p_department_id		))
				set @p_dept_id				 = substring(@p_dept_id				, len(@v_dept_id				+ '^') + 1, len(@p_dept_id				))
				set @p_end_cust_report		 = substring(@p_end_cust_report		, len(@v_end_cust_report		+ '^') + 1, len(@p_end_cust_report		))
				set @p_soldto_cust_report	 = substring(@p_soldto_cust_report	, len(@v_soldto_cust_report		+ '^') + 1, len(@p_soldto_cust_report	))
				set @p_product_group		 = substring(@p_product_group		, len(@v_product_group			+ '^') + 1, len(@p_product_group		))
				set @p_dm_biz_type			 = substring(@p_dm_biz_type			, len(@v_dm_biz_type			+ '^') + 1, len(@p_dm_biz_type			))
				set @p_yyyymm				 = substring(@p_yyyymm				, len(@v_yyyymm					+ '^') + 1, len(@p_yyyymm				))
				set @p_os_corp_cd			 = substring(@p_os_corp_cd			, len(@v_os_corp_cd				+ '^') + 1, len(@p_os_corp_cd			))
				set @p_contribution_type	 = substring(@p_contribution_type	, len(@v_contribution_type		+ '^') + 1, len(@p_contribution_type	))
				set @p_contribution_ratio	 = substring(@p_contribution_ratio	, len(@v_contribution_ratio		+ '^') + 1, len(@p_contribution_ratio	))
				set @p_created_by			 = substring(@p_created_by			, len(@v_created_by				+ '^') + 1, len(@p_created_by			))
 
				--공백제거
				set @v_active_flag			   				= rtrim(ltrim(@v_active_flag					))
				set @v_ver_seq				   				= rtrim(ltrim(@v_ver_seq						))
				set @v_department_id		   				= rtrim(ltrim(@v_department_id					))
				set @v_dept_id				   				= rtrim(ltrim(@v_dept_id						))
				set @v_end_cust_report		   				= rtrim(ltrim(@v_end_cust_report				))
				set @v_soldto_cust_report		   			= rtrim(ltrim(@v_soldto_cust_report				))
				set @v_product_group		   				= rtrim(ltrim(@v_product_group					))
				set @v_dm_biz_type			   				= rtrim(ltrim(@v_dm_biz_type					))
				set @v_yyyymm				   				= rtrim(ltrim(@v_yyyymm							))
				set @v_os_corp_cd			   				= rtrim(ltrim(@v_os_corp_cd						))
				set @v_contribution_type	   				= rtrim(ltrim(@v_contribution_type				))
				set @v_contribution_ratio	   				= rtrim(ltrim(@v_contribution_ratio				))
				set @v_created_by			   				= rtrim(ltrim(@v_created_by						))
				--공백제거

				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
				IF LEN(@v_yyyymm) > 4

					-- 월모드인 경우
					BEGIN
							INSERT INTO #results_MST ( 
													 active_flag				 
													,ver_seq				
													,department_id		
													,dept_id				
													,end_cust_report		
													,soldto_cust_report		
													,product_group		
													,dm_biz_type			
													,yyyymm				
													,os_corp_cd			
													,contribution_type	
													,contribution_ratio	
													,created_by			
							) VALUES ( 
													 @v_active_flag		
													,@v_ver_seq			
													,@v_department_id		
													,@v_dept_id			
													,@v_end_cust_report	
													,@v_soldto_cust_report		
													,@v_product_group		
													,@v_dm_biz_type		
													,@v_yyyymm				
													,@v_os_corp_cd			
													,@v_contribution_type	
													,@v_contribution_ratio	
													,@v_created_by			
							)
					END
				ELSE
					-- 년모드인 경우 (12개월을 INSERT함)
					BEGIN
							INSERT INTO #results_MST ( 
													 active_flag				 
													,ver_seq				
													,department_id		
													,dept_id				
													,end_cust_report		
													,soldto_cust_report		
													,product_group		
													,dm_biz_type			
													,yyyymm				
													,os_corp_cd			
													,contribution_type	
													,contribution_ratio	
													,created_by			
							) 
							select  
									 @v_active_flag		
									,@v_ver_seq			
									,@v_department_id		
									,@v_dept_id			
									,@v_end_cust_report	
									,@v_soldto_cust_report		
									,@v_product_group		
									,@v_dm_biz_type		
									,basis_yyyymm 
									,@v_os_corp_cd			
									,@v_contribution_type	
									,@v_contribution_ratio	
									,@v_created_by			
							from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where SUBSTRING(basis_yyyymm,1,4) = @v_yyyymm GROUP BY basis_yyyymm
					END
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)

			END
		ELSE
			BEGIN
				SET @v_ver_seq = @p_ver_seq
				SET @p_ver_seq = NULL
 
				--공백제거
				set @v_active_flag			   				= rtrim(ltrim(@v_active_flag					))
				set @v_ver_seq				   				= rtrim(ltrim(@v_ver_seq						))
				set @v_department_id		   				= rtrim(ltrim(@v_department_id					))
				set @v_dept_id				   				= rtrim(ltrim(@v_dept_id						))
				set @v_end_cust_report		   				= rtrim(ltrim(@v_end_cust_report				))
				set @v_soldto_cust_report		   			= rtrim(ltrim(@v_soldto_cust_report				))
				set @v_product_group		   				= rtrim(ltrim(@v_product_group					))
				set @v_dm_biz_type			   				= rtrim(ltrim(@v_dm_biz_type					))
				set @v_yyyymm				   				= rtrim(ltrim(@v_yyyymm							))
				set @v_os_corp_cd			   				= rtrim(ltrim(@v_os_corp_cd						))
				set @v_contribution_type	   				= rtrim(ltrim(@v_contribution_type				))
				set @v_contribution_ratio	   				= rtrim(ltrim(@v_contribution_ratio				))
				set @v_created_by			   				= rtrim(ltrim(@v_created_by						))
				--공백제거

				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
				IF LEN(@v_yyyymm) > 4

					-- 월모드인 경우
					BEGIN
							INSERT INTO #results_MST ( 
													 active_flag				 
													,ver_seq				
													,department_id		
													,dept_id				
													,end_cust_report		
													,soldto_cust_report		
													,product_group		
													,dm_biz_type			
													,yyyymm				
													,os_corp_cd			
													,contribution_type	
													,contribution_ratio	
													,created_by			
							) VALUES ( 
													 @v_active_flag		
													,@v_ver_seq			
													,@v_department_id		
													,@v_dept_id			
													,@v_end_cust_report	
													,@v_soldto_cust_report		
													,@v_product_group		
													,@v_dm_biz_type		
													,@v_yyyymm				
													,@v_os_corp_cd			
													,@v_contribution_type	
													,@v_contribution_ratio	
													,@v_created_by			
							)
					END
				ELSE
					-- 년모드인 경우 (12개월을 INSERT함)
					BEGIN
							INSERT INTO #results_MST ( 
													 active_flag				 
													,ver_seq				
													,department_id		
													,dept_id				
													,end_cust_report		
													,soldto_cust_report		
													,product_group		
													,dm_biz_type			
													,yyyymm				
													,os_corp_cd			
													,contribution_type	
													,contribution_ratio	
													,created_by			
							) 
							select  
									 @v_active_flag		
									,@v_ver_seq			
									,@v_department_id		
									,@v_dept_id			
									,@v_end_cust_report	
									,@v_soldto_cust_report		
									,@v_product_group		
									,@v_dm_biz_type		
									,basis_yyyymm 
									,@v_os_corp_cd			
									,@v_contribution_type	
									,@v_contribution_ratio	
									,@v_created_by			
							from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where SUBSTRING(basis_yyyymm,1,4) = @v_yyyymm GROUP BY basis_yyyymm
					END
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)
			END
	END

	--===================================================================================== #results_MST 테이블에 split후 insert end
--select department_id		
--		,dept_id				
--		,end_cust_report		
--		,soldto_cust_report		
--		,product_group		
--		,dm_biz_type
--		, Contribution_Type
--		, SUM(CAST (Contribution_Ratio AS NUMERIC(5,2)))
--from #results_MST
--GROUP BY department_id		
--		,dept_id				
--		,end_cust_report		
--		,soldto_cust_report		
--		,product_group		
--		,dm_biz_type
--		, Contribution_Type

--raiserror( 'sdf', 16, 1)

	-- INPUT COUNT 확인
	SET @n_input_count = ( SELECT count(ver_seq) 
								FROM #results_MST)

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		-- INSERT COUNT 확인
		SET @n_insert_count = ( SELECT count(M.ver_seq) 
									FROM #results_MST M
										where 1=1 )
					
		-- MST INSERT전 DELETE수행 (BEGIN)
		DELETE 
		FROM [dbo].DM_MST_CONTRIBUTE_RATIO_MST
		WHERE (
				SELECT count(1) 
					FROM #results_MST M
					where 1=1
						and DM_MST_CONTRIBUTE_RATIO_MST.ver_seq				= M.ver_seq			
						and DM_MST_CONTRIBUTE_RATIO_MST.department_id		= M.department_id		
						and DM_MST_CONTRIBUTE_RATIO_MST.dept_id				= M.dept_id			
						and DM_MST_CONTRIBUTE_RATIO_MST.end_cust_report		= M.end_cust_report	
						and DM_MST_CONTRIBUTE_RATIO_MST.soldto_cust_report	= M.soldto_cust_report		
						and DM_MST_CONTRIBUTE_RATIO_MST.product_group		= M.product_group		
						and DM_MST_CONTRIBUTE_RATIO_MST.dm_biz_type			= M.dm_biz_type		
				) > 0;
		-- MST INSERT전 DELETE수행 (END)

		-- MST INSERT수행 (BEGIN)
		INSERT INTO [dbo].DM_MST_CONTRIBUTE_RATIO_MST
			(VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
		SELECT VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE,MAX(CREATED_BY),GETDATE(),MAX(CREATED_BY) AS LAST_UPDATED_BY,GETDATE()
			FROM #results_MST
				WHERE 1=1
		GROUP BY VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE
		-- MST INSERT수행 (END)

	END
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		-- DTL INSERT전 DELETE수행 (BEGIN)
		DELETE 
		FROM [dbo].DM_MST_CONTRIBUTE_RATIO_DTL
		WHERE (
				SELECT count(1) 
					FROM #results_MST M
					where 1=1
						and DM_MST_CONTRIBUTE_RATIO_DTL.ver_seq				= M.ver_seq			
						and DM_MST_CONTRIBUTE_RATIO_DTL.department_id		= M.department_id		
						and DM_MST_CONTRIBUTE_RATIO_DTL.dept_id				= M.dept_id			
						and DM_MST_CONTRIBUTE_RATIO_DTL.end_cust_report		= M.end_cust_report	
						and DM_MST_CONTRIBUTE_RATIO_DTL.soldto_cust_report	= M.soldto_cust_report		
						and DM_MST_CONTRIBUTE_RATIO_DTL.product_group		= M.product_group		
						and DM_MST_CONTRIBUTE_RATIO_DTL.dm_biz_type			= M.dm_biz_type		
				) > 0;
		-- DTL INSERT전 DELETE수행 (END)

		-- DTL INSERT수행 (BEGIN)
		INSERT INTO [dbo].DM_MST_CONTRIBUTE_RATIO_DTL
			(VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE
			,YYYYMM,OS_CORP_CD,CONTRIBUTION_TYPE,CONTRIBUTION_RATIO
			,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
		SELECT VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE
			,YYYYMM,OS_CORP_CD,CONTRIBUTION_TYPE,CONTRIBUTION_RATIO
			,CREATED_BY,GETDATE(),CREATED_BY AS LAST_UPDATED_BY,GETDATE()
			FROM #results_MST
				WHERE 1=1
		-- DTL INSERT수행 (END)

	END

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇

  	-- 트랜잭션 (COMMIT)
        COMMIT TRANSACTION SAVE_DM_MST_CONTRIBUTE_RATIO;
	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION SAVE_DM_MST_CONTRIBUTE_RATIO;

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_log_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
		
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_log_description = 'input_count: ' + (Convert(NVARCHAR(10), @n_input_count)) + ' / ' + 'delete_count: ' + (Convert(NVARCHAR(10), @n_delete_count)) + ' / ' + 'merge_count: ' + (Convert(NVARCHAR(10), @n_insert_count));
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;

  END;


