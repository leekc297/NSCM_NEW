

/*
 * Program ID   : DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
 * Description  : 'DM_MST_CONTRIBUTE_VER' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190508  KHSONG  Initial Release [PJ20189106] 전지.GSCM 고도화 이행, DM 시스템
 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 
 */

CREATE PROCEDURE [dbo].[DMF0043_SAVE_DM_MST_CONTRIBUTE_VER]

	-- Add the parameters for the stored procedure here
    @p_active_flag	NVARCHAR(MAX),
    @p_ver_seq		NVARCHAR(MAX),
    @p_yyyy			NVARCHAR(MAX),
    @p_version_nm	NVARCHAR(MAX),
    @p_description	NVARCHAR(MAX),
    @p_valid_yn		NVARCHAR(MAX),
    @p_created_by	NVARCHAR(MAX)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- 스플릿관련 변수

    DECLARE  @v_active_flag		NVARCHAR(MAX);
    DECLARE  @v_ver_seq			NVARCHAR(MAX);
    DECLARE  @v_yyyy			NVARCHAR(MAX);
    DECLARE  @v_version_nm		NVARCHAR(MAX);
    DECLARE  @v_description		NVARCHAR(MAX);
    DECLARE  @v_valid_yn		NVARCHAR(MAX);
    DECLARE  @v_created_by		NVARCHAR(MAX);

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @max_ver_seq	 	NVARCHAR(MAX);
    
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_log_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_insert_count    INTEGER = 0;
    DECLARE @n_input_count     INTEGER = 0;
    DECLARE @n_logo_count      INTEGER = 0;



	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag		= RTRIM(@p_active_flag	    ) + '^';
	SET @p_ver_seq			= RTRIM(@p_ver_seq		    ) + '^';
	SET @p_yyyy				= RTRIM(@p_yyyy			    ) + '^';
	SET @p_version_nm		= RTRIM(@p_version_nm	    ) + '^';
	SET @p_description		= RTRIM(@p_description	    ) + '^';
	SET @p_valid_yn			= RTRIM(@p_valid_yn		    ) + '^';
	SET @p_created_by		= RTRIM(@p_created_by	    ) + '^';

	-- #results_MST TEMP TABLE
	CREATE TABLE #results_MST  (
								 active_flag		NVARCHAR(max)
								,ver_seq			NVARCHAR(max)
								,yyyy				NVARCHAR(max)
								,version_nm			NVARCHAR(max)
								,description		NVARCHAR(max)
								,valid_yn			NVARCHAR(max)
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
	BEGIN TRANSACTION DM_MST_CONTRIBUTE_VER_ALL;

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------

	--===================================================================================== #results_MST 테이블에 split후 insert start
	--###############################################  #results_MST 테이블에 split후 insert (START)
	WHILE LEN(@p_yyyy) > 0
	BEGIN
		DECLARE @index_active_flag		INT
		DECLARE @index_ver_seq			INT
		DECLARE @index_yyyy				INT
		DECLARE @index_version_nm		INT
		DECLARE @index_description		INT
		DECLARE @index_valid_yn			INT
		DECLARE @index_created_by		INT

		SET @index_active_flag		= PATINDEX('%' + '^' + '%', @p_active_flag	)
		SET @index_ver_seq			= PATINDEX('%' + '^' + '%', @p_ver_seq		)
		SET @index_yyyy				= PATINDEX('%' + '^' + '%', @p_yyyy			)
		SET @index_version_nm		= PATINDEX('%' + '^' + '%', @p_version_nm	)
		SET @index_description		= PATINDEX('%' + '^' + '%', @p_description	)
		SET @index_valid_yn			= PATINDEX('%' + '^' + '%', @p_valid_yn		)
		SET @index_created_by		= PATINDEX('%' + '^' + '%', @p_created_by	)

		IF @index_yyyy > 0
			BEGIN

				set @v_active_flag = substring(@p_active_flag, 0, @index_active_flag)
				set @p_active_flag = substring(@p_active_flag, len(@v_active_flag + '^') + 1, len(@p_active_flag))

	
				set @v_ver_seq = substring(@p_ver_seq, 0, @index_ver_seq)
				set @p_ver_seq = substring(@p_ver_seq, len(@v_ver_seq + '^') + 1, len(@p_ver_seq))

				set @v_yyyy = substring(@p_yyyy, 0, @index_yyyy)
				set @p_yyyy = substring(@p_yyyy, len(@v_yyyy + '^') + 1, len(@p_yyyy))

				set @v_version_nm = substring(@p_version_nm, 0, @index_version_nm)
				set @p_version_nm = substring(@p_version_nm, len(@v_version_nm + '^') + 1, len(@p_version_nm))

				set @v_description = substring(@p_description, 0, @index_description)
				set @p_description = substring(@p_description, len(@v_description + '^') + 1, len(@p_description))

				set @v_valid_yn = substring(@p_valid_yn, 0, @index_valid_yn)
				set @p_valid_yn = substring(@p_valid_yn, len(@v_valid_yn + '^') + 1, len(@p_valid_yn))

				set @v_created_by = substring(@p_created_by, 0, @index_created_by)
				set @p_created_by = substring(@p_created_by, len(@v_created_by + '^') + 1, len(@p_created_by))

 
				--공백제거
				set @v_active_flag	    				= rtrim(ltrim(@v_active_flag			))
				set @v_ver_seq		    				= rtrim(ltrim(@v_ver_seq		))
				set @v_yyyy			    				= rtrim(ltrim(@v_yyyy			))
				set @v_version_nm	    				= rtrim(ltrim(@v_version_nm		))
				set @v_description	    				= rtrim(ltrim(@v_description	))
				set @v_valid_yn		    				= rtrim(ltrim(@v_valid_yn		))
				set @v_created_by	    				= rtrim(ltrim(@v_created_by		))
				--공백제거

				INSERT INTO #results_MST ( 
										 active_flag			 
										,ver_seq	 
										,yyyy	 
										,version_nm	 
										,description	 
										,valid_yn		 
										,created_by	 
				) VALUES ( 
										 @v_active_flag			
										,@v_ver_seq	
										,@v_yyyy	
										,@v_version_nm	
										,@v_description	
										,@v_valid_yn		
										,@v_created_by	
				)

			END
		ELSE
			BEGIN
				SET @v_yyyy = @p_yyyy
				SET @p_yyyy = NULL
 
				--공백제거
				set @v_active_flag	    				= rtrim(ltrim(@v_active_flag	))
				set @v_ver_seq		    				= rtrim(ltrim(@v_ver_seq		))
				set @v_yyyy			    				= rtrim(ltrim(@v_yyyy			))
				set @v_version_nm	    				= rtrim(ltrim(@v_version_nm		))
				set @v_description	    				= rtrim(ltrim(@v_description	))
				set @v_valid_yn		    				= rtrim(ltrim(@v_valid_yn		))
				set @v_created_by	    				= rtrim(ltrim(@v_created_by		))
				--공백제거

				INSERT INTO #results_MST ( 
										 active_flag
										,ver_seq	 
										,yyyy	 
										,version_nm	 
										,description	 
										,valid_yn		 
										,created_by	 
				) VALUES ( 
										 @v_active_flag			
										,@v_ver_seq	
										,@v_yyyy	
										,@v_version_nm	
										,@v_description	
										,@v_valid_yn		
										,@v_created_by	
				)
			END
	END

	--===================================================================================== #results_MST 테이블에 split후 insert end


	-- INPUT COUNT 확인
	SET @n_input_count = ( SELECT count(yyyy) 
								FROM #results_MST)

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_MST_CONTRIBUTE_VER 테이블 DELETE (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		
		-- DELETE COUNT 확인
		SET @n_delete_count =  (SELECT COUNT(YYYY)  FROM [dbo].DM_MST_CONTRIBUTE_VER A
								WHERE (
										SELECT count(1) 
											FROM #results_MST M
											where M.active_flag		= 'D'
												and A.VER_SEQ	= M.VER_SEQ	
										) > 0)

		--  select * from #results_MST
		DELETE 
		FROM [dbo].DM_MST_CONTRIBUTE_VER
		WHERE (
				SELECT count(1) 
					FROM #results_MST M
					where M.active_flag		= 'D'
						and DM_MST_CONTRIBUTE_VER.VER_SEQ	= M.VER_SEQ	
				) > 0;
	END
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_MST_CONTRIBUTE_VER 테이블 DELETE (END)
	--------------------------------------------------------------------------------------------◇◇◇◇

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_VER 테이블 UPDATE, INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		-- INSERT COUNT 확인
		SET @n_insert_count = ( SELECT count(M.yyyy) 
									FROM #results_MST M
										where M.active_flag      <> 'D' )
					
					MERGE INTO [dbo].[DM_MST_CONTRIBUTE_VER] A
					USING (
							SELECT *
								FROM #results_MST M
									where M.active_flag      <> 'D'
						  ) B
					ON(
							    A.VER_SEQ = B.VER_SEQ
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
									 A.YYYY				= B.YYYY
									,A.VERSION_NM		= B.VERSION_NM
									,A.DESCRIPTION		= B.DESCRIPTION
									,A.VALID_YN			= B.VALID_YN
								    ,A.last_updated_by	= B.CREATED_BY
								    ,A.last_update_date	= GETDATE()
					                
					WHEN NOT MATCHED THEN

						 INSERT ( -- VER_SEQ
								   YYYY
								  ,VERSION_NM
								  ,DESCRIPTION
								  ,VALID_YN
								  ,CREATED_BY
								  ,CREATION_DATE
								  ,LAST_UPDATED_BY
								  ,LAST_UPDATE_DATE
								  ,ATTRIBUTE1
								  ,ATTRIBUTE2
								  ,ATTRIBUTE3
								  ,ATTRIBUTE4
								  ,ATTRIBUTE5
								)
						 VALUES (   B.YYYY
								   ,B.VERSION_NM
								   ,B.DESCRIPTION
								   ,B.VALID_YN
								   ,B.CREATED_BY
								   ,GETDATE()
								   ,B.CREATED_BY
								   ,GETDATE()
								   ,NULL,NULL,NULL,NULL,NULL
								);


        -- 기여율 copy
        SET @max_ver_seq = (SELECT MAX(VER_SEQ) FROM [dbo].[DM_MST_CONTRIBUTE_VER] WITH (NOLOCK));
        IF (SELECT COUNT(1)
              FROM [dbo].[DM_MST_CONTRIBUTE_RATIO_MST] WITH (NOLOCK)
             WHERE VER_SEQ = @max_ver_seq
            ) = 0
            BEGIN
                INSERT INTO [dbo].[DM_MST_CONTRIBUTE_RATIO_DTL]
                     ( VER_SEQ
                     , DEPARTMENT_ID
                     , DEPT_ID
                     , END_CUST_REPORT
                     , SOLDTO_CUST_REPORT
                     , PRODUCT_GROUP
                     , DM_BIZ_TYPE
                     , YYYYMM
                     , OS_CORP_CD
                     , CONTRIBUTION_TYPE
                     , CONTRIBUTION_RATIO
					 , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
					 , ATTRIBUTE1
					 , ATTRIBUTE2
					 , ATTRIBUTE3
					 , ATTRIBUTE4
					 , ATTRIBUTE5 )
                SELECT @max_ver_seq AS VER_SEQ
                     , DEPARTMENT_ID
                     , DEPT_ID
                     , END_CUST_REPORT
                     , SOLDTO_CUST_REPORT
                     , PRODUCT_GROUP
                     , DM_BIZ_TYPE
                     , (SELECT YYYY 
                          FROM [dbo].[DM_MST_CONTRIBUTE_VER] WITH (NOLOCK)
                         WHERE VER_SEQ = @max_ver_seq) + SUBSTRING(YYYYMM,5,2)
                     , OS_CORP_CD
                     , CONTRIBUTION_TYPE
                     , CONTRIBUTION_RATIO
                     , @p_created_by
                     , GETDATE()
                     , @p_created_by
                     , GETDATE()
				     , NULL,NULL,NULL,NULL,NULL
                  FROM [dbo].[DM_MST_CONTRIBUTE_RATIO_DTL] WITH (NOLOCK)
                 WHERE VER_SEQ = (SELECT MAX(VER_SEQ) FROM [dbo].[DM_MST_CONTRIBUTE_RATIO_MST] WITH (NOLOCK))
                ;

                INSERT INTO [dbo].[DM_MST_CONTRIBUTE_RATIO_MST]
                     ( VER_SEQ
                     , DEPARTMENT_ID
                     , DEPT_ID
                     , END_CUST_REPORT
                     , SOLDTO_CUST_REPORT
                     , PRODUCT_GROUP
                     , DM_BIZ_TYPE
					 , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
					 , ATTRIBUTE1
					 , ATTRIBUTE2
					 , ATTRIBUTE3
					 , ATTRIBUTE4
					 , ATTRIBUTE5 )
                SELECT @max_ver_seq AS VER_SEQ
                     , DEPARTMENT_ID
                     , DEPT_ID
                     , END_CUST_REPORT
                     , SOLDTO_CUST_REPORT
                     , PRODUCT_GROUP
                     , DM_BIZ_TYPE
                     , @p_created_by
                     , GETDATE()
                     , @p_created_by
                     , GETDATE()
				     , NULL,NULL,NULL,NULL,NULL
                  FROM [dbo].[DM_MST_CONTRIBUTE_RATIO_MST] WITH (NOLOCK)
                 WHERE VER_SEQ = (SELECT MAX(VER_SEQ) FROM [dbo].[DM_MST_CONTRIBUTE_RATIO_MST] WITH (NOLOCK))
                ;

            END
END
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_VER 테이블 UPDATE, INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇

  	-- 트랜잭션 (COMMIT)
        COMMIT TRANSACTION DM_MST_CONTRIBUTE_VER_ALL;  -- sss
	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION DM_MST_CONTRIBUTE_VER_ALL;  -- sss

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
    SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;

  END;
