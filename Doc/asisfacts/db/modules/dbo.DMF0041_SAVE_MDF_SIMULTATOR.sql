
/*
 *------------------------------------------------------------------------------------------------------------------------------------
 * Program ID   : DMF0041_SAVE_MDF_SIMULTATOR
 * Description  : 매출 계획 값을 가지고 MDF 값을 Simulator를 하기 위한 화면(Demand > Demand Plan > MDF Simulator) 의 값 저장 Procedure 
 * Program History
 *====================================================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================================================
 * 20190221  KHSONG  Initial Release [PJ20189106] 전지GSCM 고도화 이행
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 
 * 
 * 
 *------------------------------------------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[DMF0041_SAVE_MDF_SIMULTATOR]

	-- Add the parameters for the stored procedure here
     @p_active_flag			NVARCHAR(MAX)
    ,@p_MDF_VERSION_NO		NVARCHAR(MAX)
    ,@p_DIVISION_ID			NVARCHAR(MAX)
    ,@p_DEPARTMENT_ID		NVARCHAR(MAX)
    ,@p_DMS_CUSTOMER		NVARCHAR(MAX)
    ,@p_DMS_SALES			NVARCHAR(MAX)
    ,@p_APPLICATION			NVARCHAR(MAX)
    ,@p_BIZ_TYPE			NVARCHAR(MAX)
    ,@p_ITEM_TYPE			NVARCHAR(MAX)
    ,@p_MEASURE				NVARCHAR(MAX)
    ,@p_UNIT_CURRENCY		NVARCHAR(MAX)
    ,@p_YYYYMM				NVARCHAR(MAX)
    ,@p_QTY					NVARCHAR(MAX)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- 스플릿관련 변수

    DECLARE  @v_active_flag		NVARCHAR(MAX);
    DECLARE  @v_MDF_VERSION_NO	NVARCHAR(MAX);
    DECLARE  @v_DIVISION_ID		NVARCHAR(MAX);
    DECLARE  @v_DEPARTMENT_ID	NVARCHAR(MAX);
    DECLARE  @v_DMS_CUSTOMER	NVARCHAR(MAX);
    DECLARE  @v_DMS_SALES		NVARCHAR(MAX);
    DECLARE  @v_APPLICATION		NVARCHAR(MAX);
    DECLARE  @v_BIZ_TYPE		NVARCHAR(MAX);
    DECLARE  @v_ITEM_TYPE		NVARCHAR(MAX);
    DECLARE  @v_MEASURE			NVARCHAR(MAX);
    DECLARE  @v_UNIT_CURRENCY	NVARCHAR(MAX);
    DECLARE  @v_YYYYMM			NVARCHAR(MAX);
    DECLARE  @v_QTY				NVARCHAR(MAX);

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name		NVARCHAR(150) = 'DMF0041_SAVE_MDF_SIMULTATOR';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
    DECLARE @n_delete_count		INTEGER = 0;
    DECLARE @n_insert_count     INTEGER = 0;
    DECLARE @n_logo_count		INTEGER = 0;



	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag		= RTRIM(@p_active_flag		) + '^';
	SET @p_MDF_VERSION_NO	= RTRIM(@p_MDF_VERSION_NO	) + '^';
	SET @p_DIVISION_ID		= RTRIM(@p_DIVISION_ID		) + '^';
	SET @p_DEPARTMENT_ID	= RTRIM(@p_DEPARTMENT_ID	) + '^';
	SET @p_DMS_CUSTOMER		= RTRIM(@p_DMS_CUSTOMER		) + '^';
	SET @p_DMS_SALES		= RTRIM(@p_DMS_SALES		) + '^';
	SET @p_APPLICATION		= RTRIM(@p_APPLICATION		) + '^';
	SET @p_BIZ_TYPE			= RTRIM(@p_BIZ_TYPE			) + '^';
	SET @p_ITEM_TYPE		= RTRIM(@p_ITEM_TYPE		) + '^';
	SET @p_MEASURE			= RTRIM(@p_MEASURE			) + '^';
	SET @p_UNIT_CURRENCY	= RTRIM(@p_UNIT_CURRENCY	) + '^';
	SET @p_YYYYMM			= RTRIM(@p_YYYYMM			) + '^';
	SET @p_QTY				= RTRIM(@p_QTY				) + '^';

	-- #results_MST TEMP TABLE
	CREATE TABLE #results_MST  (
             active_flag		NVARCHAR(01)   NOT NULL
			,MDF_VERSION_NO		NVARCHAR(30)   NOT NULL
			,DIVISION_ID		NVARCHAR(30)   NOT NULL
			,DEPARTMENT_ID		NVARCHAR(50)   NOT NULL
			,DMS_CUSTOMER		NVARCHAR(200)  NOT NULL
			,DMS_SALES			NVARCHAR(200)  NOT NULL
			,APPLICATION		NVARCHAR(100)  NOT NULL
			,BIZ_TYPE			NVARCHAR(30)   NOT NULL
			,ITEM_TYPE			NVARCHAR(20)   NOT NULL
			,MEASURE			NVARCHAR(50)   NOT NULL
			,UNIT_CURRENCY		NVARCHAR(10)   NOT NULL
			,YYYYMM				NVARCHAR(06)   NOT NULL
			,QTY				NUMERIC(20,10) NOT NULL
    )
	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION DMF0041_SAVE_MDF_SIMULTATOR;

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                     #results_MST 테이블에 split후 insert (BEGIN)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		WHILE LEN(@p_DIVISION_ID) > 0
		BEGIN
			DECLARE @index_active_flag	    INT
			DECLARE @index_MDF_VERSION_NO   INT
			DECLARE @index_DIVISION_ID	    INT
			DECLARE @index_DEPARTMENT_ID    INT
			DECLARE @index_DMS_CUSTOMER	    INT
			DECLARE @index_DMS_SALES	    INT
			DECLARE @index_APPLICATION	    INT
			DECLARE @index_BIZ_TYPE		    INT
			DECLARE @index_ITEM_TYPE	    INT
			DECLARE @index_MEASURE		    INT
			DECLARE @index_UNIT_CURRENCY    INT
			DECLARE @index_YYYYMM		    INT
			DECLARE @index_QTY			    INT

			SET @index_active_flag	    = PATINDEX('%' + '^' + '%', @p_active_flag	   )
			SET @index_MDF_VERSION_NO   = PATINDEX('%' + '^' + '%', @p_MDF_VERSION_NO  )
			SET @index_DIVISION_ID	    = PATINDEX('%' + '^' + '%', @p_DIVISION_ID	   )
			SET @index_DEPARTMENT_ID    = PATINDEX('%' + '^' + '%', @p_DEPARTMENT_ID   )
			SET @index_DMS_CUSTOMER	    = PATINDEX('%' + '^' + '%', @p_DMS_CUSTOMER	   )
			SET @index_DMS_SALES	    = PATINDEX('%' + '^' + '%', @p_DMS_SALES	   )
			SET @index_APPLICATION	    = PATINDEX('%' + '^' + '%', @p_APPLICATION	   )
			SET @index_BIZ_TYPE		    = PATINDEX('%' + '^' + '%', @p_BIZ_TYPE		   )
			SET @index_ITEM_TYPE	    = PATINDEX('%' + '^' + '%', @p_ITEM_TYPE	   )
			SET @index_MEASURE		    = PATINDEX('%' + '^' + '%', @p_MEASURE		   )
			SET @index_UNIT_CURRENCY    = PATINDEX('%' + '^' + '%', @p_UNIT_CURRENCY   )
			SET @index_YYYYMM		    = PATINDEX('%' + '^' + '%', @p_YYYYMM		   )
			SET @index_QTY			    = PATINDEX('%' + '^' + '%', @p_QTY			   )

			IF @index_DIVISION_ID > 0
				BEGIN
					SET @v_active_flag	  = SUBSTRING(@p_active_flag     , 0, @index_active_flag    ) 
					SET @v_MDF_VERSION_NO = SUBSTRING(@p_MDF_VERSION_NO	 , 0, @index_MDF_VERSION_NO	)
					SET @v_DIVISION_ID	  = SUBSTRING(@p_DIVISION_ID	 , 0, @index_DIVISION_ID	)
					SET @v_DEPARTMENT_ID  = SUBSTRING(@p_DEPARTMENT_ID 	 , 0, @index_DEPARTMENT_ID 	)
					SET @v_DMS_CUSTOMER	  = SUBSTRING(@p_DMS_CUSTOMER	 , 0, @index_DMS_CUSTOMER	)
					SET @v_DMS_SALES	  = SUBSTRING(@p_DMS_SALES	   	 , 0, @index_DMS_SALES	   	)
					SET @v_APPLICATION	  = SUBSTRING(@p_APPLICATION	 , 0, @index_APPLICATION	)
					SET @v_BIZ_TYPE		  = SUBSTRING(@p_BIZ_TYPE		 , 0, @index_BIZ_TYPE		)
					SET @v_ITEM_TYPE	  = SUBSTRING(@p_ITEM_TYPE	   	 , 0, @index_ITEM_TYPE	   	)
					SET @v_MEASURE		  = SUBSTRING(@p_MEASURE		 , 0, @index_MEASURE		)
					SET @v_UNIT_CURRENCY  = SUBSTRING(@p_UNIT_CURRENCY 	 , 0, @index_UNIT_CURRENCY 	)
					SET @v_YYYYMM		  = SUBSTRING(@p_YYYYMM		   	 , 0, @index_YYYYMM		   	)
					SET @v_QTY			  = SUBSTRING(@p_QTY			 , 0, @index_QTY			)

					SET @p_active_flag	  = SUBSTRING(@p_active_flag	, LEN(@v_active_flag	 + '^') + 1, LEN(@p_active_flag		))
					SET @p_MDF_VERSION_NO = SUBSTRING(@p_MDF_VERSION_NO	, LEN(@v_MDF_VERSION_NO	 + '^') + 1, LEN(@p_MDF_VERSION_NO	))
					SET @p_DIVISION_ID	  = SUBSTRING(@p_DIVISION_ID	, LEN(@v_DIVISION_ID	 + '^') + 1, LEN(@p_DIVISION_ID		))
					SET @p_DEPARTMENT_ID  = SUBSTRING(@p_DEPARTMENT_ID	, LEN(@v_DEPARTMENT_ID	 + '^') + 1, LEN(@p_DEPARTMENT_ID	))
					SET @p_DMS_CUSTOMER	  = SUBSTRING(@p_DMS_CUSTOMER	, LEN(@v_DMS_CUSTOMER	 + '^') + 1, LEN(@p_DMS_CUSTOMER	))
					SET @p_DMS_SALES	  = SUBSTRING(@p_DMS_SALES		, LEN(@v_DMS_SALES		 + '^') + 1, LEN(@p_DMS_SALES		))
					SET @p_APPLICATION	  = SUBSTRING(@p_APPLICATION	, LEN(@v_APPLICATION	 + '^') + 1, LEN(@p_APPLICATION		))
					SET @p_BIZ_TYPE		  = SUBSTRING(@p_BIZ_TYPE		, LEN(@v_BIZ_TYPE		 + '^') + 1, LEN(@p_BIZ_TYPE		))
					SET @p_ITEM_TYPE	  = SUBSTRING(@p_ITEM_TYPE		, LEN(@v_ITEM_TYPE		 + '^') + 1, LEN(@p_ITEM_TYPE		))
					SET @p_MEASURE		  = SUBSTRING(@p_MEASURE		, LEN(@v_MEASURE		 + '^') + 1, LEN(@p_MEASURE			))
					SET @p_UNIT_CURRENCY  = SUBSTRING(@p_UNIT_CURRENCY	, LEN(@v_UNIT_CURRENCY	 + '^') + 1, LEN(@p_UNIT_CURRENCY	))
					SET @p_YYYYMM		  = SUBSTRING(@p_YYYYMM			, LEN(@v_YYYYMM			 + '^') + 1, LEN(@p_YYYYMM			))
					SET @p_QTY			  = SUBSTRING(@p_QTY			, LEN(@v_QTY			 + '^') + 1, LEN(@p_QTY				))
 
					-- 공백제거(START)
					SET @v_active_flag	     	= rtrim(ltrim(@v_active_flag    ))
					SET @v_MDF_VERSION_NO    	= rtrim(ltrim(@v_MDF_VERSION_NO ))
					SET @v_DIVISION_ID	     	= rtrim(ltrim(@v_DIVISION_ID	))
					SET @v_DEPARTMENT_ID     	= rtrim(ltrim(@v_DEPARTMENT_ID	))
					SET @v_DMS_CUSTOMER	     	= rtrim(ltrim(@v_DMS_CUSTOMER	))
					SET @v_DMS_SALES	     	= rtrim(ltrim(@v_DMS_SALES		))
					SET @v_APPLICATION	     	= rtrim(ltrim(@v_APPLICATION	))
					SET @v_BIZ_TYPE		     	= rtrim(ltrim(@v_BIZ_TYPE		))
					SET @v_ITEM_TYPE	     	= rtrim(ltrim(@v_ITEM_TYPE		))
					SET @v_MEASURE		     	= rtrim(ltrim(@v_MEASURE		))
					SET @v_UNIT_CURRENCY     	= rtrim(ltrim(@v_UNIT_CURRENCY  ))
					SET @v_YYYYMM		     	= rtrim(ltrim(@v_YYYYMM			))
					SET @v_QTY			     	= rtrim(ltrim(@v_QTY			))
					-- 공백제거(END)

					---- 임시확인
					--select '@v_active_flag   '   , @v_active_flag   
					--select '@v_MDF_VERSION_NO' 	 , @v_MDF_VERSION_NO
					--select '@v_DIVISION_ID	 '	 , @v_DIVISION_ID	 
					--select '@v_DEPARTMENT_ID'	 , @v_DEPARTMENT_ID
					--select '@v_DMS_CUSTOMER	 '	 , @v_DMS_CUSTOMER	 
					--select '@v_DMS_SALES	'	 , @v_DMS_SALES	
					--select '@v_APPLICATION	 '	 , @v_APPLICATION	 
					--select '@v_BIZ_TYPE		 '	 , @v_BIZ_TYPE		 
					--select '@v_ITEM_TYPE	'	 , @v_ITEM_TYPE	
					--select '@v_MEASURE		 '	 , @v_MEASURE		 
					--select '@v_UNIT_CURRENCY ' 	 , @v_UNIT_CURRENCY 
					--select '@v_YYYYMM		'	 , @v_YYYYMM		
					--select '@v_QTY			 '	 , @v_QTY			 

					INSERT INTO #results_MST ( 
											 active_flag	 
											,MDF_VERSION_NO
											,DIVISION_ID	 
											,DEPARTMENT_ID 
											,DMS_CUSTOMER	 
											,DMS_SALES	 
											,APPLICATION	 
											,BIZ_TYPE		 
											,ITEM_TYPE	 
											,MEASURE		 
											,UNIT_CURRENCY 
											,YYYYMM		 
											,QTY			 
					) VALUES ( 
											 @v_active_flag	
											,@v_MDF_VERSION_NO
											,@v_DIVISION_ID	
											,@v_DEPARTMENT_ID 
											,@v_DMS_CUSTOMER	
											,@v_DMS_SALES	 
											,@v_APPLICATION	
											,@v_BIZ_TYPE		
											,@v_ITEM_TYPE	 
											,@v_MEASURE		
											,@v_UNIT_CURRENCY 
											,@v_YYYYMM		 
											,@v_QTY			
					)
				END
			ELSE
				BEGIN
					SET @v_DIVISION_ID = @p_DIVISION_ID
					SET @p_DIVISION_ID = NULL
 
					-- 공백제거(START)
					SET @v_active_flag	     	= rtrim(ltrim(@v_active_flag    ))
					SET @v_MDF_VERSION_NO    	= rtrim(ltrim(@v_MDF_VERSION_NO ))
					SET @v_DIVISION_ID	     	= rtrim(ltrim(@v_DIVISION_ID	))
					SET @v_DEPARTMENT_ID     	= rtrim(ltrim(@v_DEPARTMENT_ID	))
					SET @v_DMS_CUSTOMER	     	= rtrim(ltrim(@v_DMS_CUSTOMER	))
					SET @v_DMS_SALES	     	= rtrim(ltrim(@v_DMS_SALES		))
					SET @v_APPLICATION	     	= rtrim(ltrim(@v_APPLICATION	))
					SET @v_BIZ_TYPE		     	= rtrim(ltrim(@v_BIZ_TYPE		))
					SET @v_ITEM_TYPE	     	= rtrim(ltrim(@v_ITEM_TYPE		))
					SET @v_MEASURE		     	= rtrim(ltrim(@v_MEASURE		))
					SET @v_UNIT_CURRENCY     	= rtrim(ltrim(@v_UNIT_CURRENCY  ))
					SET @v_YYYYMM		     	= rtrim(ltrim(@v_YYYYMM			))
					SET @v_QTY			     	= rtrim(ltrim(@v_QTY			))
					-- 공백제거(END)

					INSERT INTO #results_MST ( 
											 active_flag	 
											,MDF_VERSION_NO
											,DIVISION_ID	 
											,DEPARTMENT_ID 
											,DMS_CUSTOMER	 
											,DMS_SALES	 
											,APPLICATION	 
											,BIZ_TYPE		 
											,ITEM_TYPE	 
											,MEASURE		 
											,UNIT_CURRENCY 
											,YYYYMM		 
											,QTY			 
					) VALUES ( 
											 @v_active_flag	
											,@v_MDF_VERSION_NO
											,@v_DIVISION_ID	
											,@v_DEPARTMENT_ID 
											,@v_DMS_CUSTOMER	
											,@v_DMS_SALES	 
											,@v_APPLICATION	
											,@v_BIZ_TYPE		
											,@v_ITEM_TYPE	 
											,@v_MEASURE		
											,@v_UNIT_CURRENCY 
											,@v_YYYYMM		 
											,@v_QTY			
					)
				END
		END

	END
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                     #results_MST 테이블에 split후 insert (END)
	--------------------------------------------------------------------------------------------◇◇◇◇

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_PLN_MDF_SIMULATOR_DATA 테이블 DELETE (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		
		-- DELETE COUNT 확인
		SET @n_delete_count =  (SELECT COUNT(DIVISION_ID)  FROM [dbo].DM_PLN_MDF_SIMULATOR_DATA A
								WHERE (
										SELECT count(1) 
											FROM #results_MST M
											where M.active_flag		= 'D'
												and A.MDF_VERSION_NO	= M.MDF_VERSION_NO	
												and A.DIVISION_ID		= M.DIVISION_ID		    
												and A.DEPARTMENT_ID		= M.DEPARTMENT_ID     
												and A.DMS_CUSTOMER		= M.DMS_CUSTOMER	    
												and A.DMS_SALES			= M.DMS_SALES	     
												and A.APPLICATION	    = M.APPLICATION	    
												and A.BIZ_TYPE			= M.BIZ_TYPE		    
												and A.ITEM_TYPE			= M.ITEM_TYPE	     
												and A.MEASURE		    = M.MEASURE		    
												and A.UNIT_CURRENCY		= M.UNIT_CURRENCY     
												--and A.YYYYMM		    = M.YYYYMM		     
										) > 0)

		--  select * from #results_MST
		DELETE 
		FROM [dbo].DM_PLN_MDF_SIMULATOR_DATA
		WHERE (
				SELECT count(1) 
					FROM #results_MST M
					where M.active_flag		= 'D'
						and DM_PLN_MDF_SIMULATOR_DATA.MDF_VERSION_NO	= M.MDF_VERSION_NO	
						and DM_PLN_MDF_SIMULATOR_DATA.DIVISION_ID		= M.DIVISION_ID		    
						and DM_PLN_MDF_SIMULATOR_DATA.DEPARTMENT_ID		= M.DEPARTMENT_ID     
						and DM_PLN_MDF_SIMULATOR_DATA.DMS_CUSTOMER		= M.DMS_CUSTOMER	    
						and DM_PLN_MDF_SIMULATOR_DATA.DMS_SALES			= M.DMS_SALES	     
						and DM_PLN_MDF_SIMULATOR_DATA.APPLICATION	    = M.APPLICATION	    
						and DM_PLN_MDF_SIMULATOR_DATA.BIZ_TYPE			= M.BIZ_TYPE		    
						and DM_PLN_MDF_SIMULATOR_DATA.ITEM_TYPE			= M.ITEM_TYPE	     
						and DM_PLN_MDF_SIMULATOR_DATA.MEASURE		    = M.MEASURE		    
						and DM_PLN_MDF_SIMULATOR_DATA.UNIT_CURRENCY		= M.UNIT_CURRENCY     
						--and DM_PLN_MDF_SIMULATOR_DATA.YYYYMM		    = M.YYYYMM		     
				) > 0;
	END
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_PLN_MDF_SIMULATOR_DATA 테이블 DELETE (END)
	--------------------------------------------------------------------------------------------◇◇◇◇


	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_PLN_MDF_SIMULATOR_DATA 테이블 UPDATE, INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇


	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_PLN_MDF_SIMULATOR_DATA 테이블 UPDATE, INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		-- INSERT COUNT 확인
		SET @n_insert_count = ( SELECT count(M.DIVISION_ID) 
									FROM #results_MST M
										where M.active_flag      <> 'D' )
					
		-- INSERT전 동일대상 delete 수행
		DELETE 
		FROM [dbo].DM_PLN_MDF_SIMULATOR_DATA
		WHERE (
				SELECT count(1) 
					FROM #results_MST M
					where M.active_flag      <> 'D'
						and DM_PLN_MDF_SIMULATOR_DATA.MDF_VERSION_NO	= M.MDF_VERSION_NO	
						and DM_PLN_MDF_SIMULATOR_DATA.DIVISION_ID		= M.DIVISION_ID		    
						and DM_PLN_MDF_SIMULATOR_DATA.DEPARTMENT_ID		= M.DEPARTMENT_ID     
						and DM_PLN_MDF_SIMULATOR_DATA.DMS_CUSTOMER		= M.DMS_CUSTOMER	    
						and DM_PLN_MDF_SIMULATOR_DATA.DMS_SALES			= M.DMS_SALES	     
						and DM_PLN_MDF_SIMULATOR_DATA.APPLICATION	    = M.APPLICATION	    
						and DM_PLN_MDF_SIMULATOR_DATA.BIZ_TYPE			= M.BIZ_TYPE		    
						and DM_PLN_MDF_SIMULATOR_DATA.ITEM_TYPE			= M.ITEM_TYPE	     
						and DM_PLN_MDF_SIMULATOR_DATA.MEASURE		    = M.MEASURE		    
						and DM_PLN_MDF_SIMULATOR_DATA.UNIT_CURRENCY		= M.UNIT_CURRENCY     
						and DM_PLN_MDF_SIMULATOR_DATA.YYYYMM		    = M.YYYYMM		     
				) > 0;

		-- INSERT 수행
		INSERT INTO [dbo].DM_PLN_MDF_SIMULATOR_DATA
				(	 MDF_VERSION_NO
					,DIVISION_ID
					,DEPARTMENT_ID
					,DMS_CUSTOMER
					,DMS_SALES
					,APPLICATION
					,BIZ_TYPE
					,ITEM_TYPE
					,MEASURE
					,UNIT_CURRENCY
					,YYYYMM
					,QTY
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				)
		SELECT		 MDF_VERSION_NO
					,DIVISION_ID
					,DEPARTMENT_ID
					,DMS_CUSTOMER
					,DMS_SALES
					,APPLICATION
					,BIZ_TYPE
					,ITEM_TYPE
					,MEASURE
					,UNIT_CURRENCY
					,YYYYMM
					,QTY
					,'MDF_SIMULATOR' AS CREATED_BY
					,GETDATE()   
					,'MDF_SIMULATOR' AS LAST_UPDATED_BY
					,GETDATE()   
			FROM #results_MST M
				where M.active_flag    <> 'D'

END
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_PLN_MDF_SIMULATOR_DATA 테이블 UPDATE, INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                        DM_PLN_MDF_SIMULATOR_DATA_H 테이블 HISTORY INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
							INSERT INTO  DM_PLN_MDF_SIMULATOR_DATA_H
									   ( 
										 HISTORY_SEQ
										,ACTIVE_FLAG
										,MDF_VERSION_NO
										,DIVISION_ID
										,DEPARTMENT_ID
										,DMS_CUSTOMER
										,DMS_SALES
										,APPLICATION
										,BIZ_TYPE
										,ITEM_TYPE
										,MEASURE
										,UNIT_CURRENCY
										,YYYYMM
										,QTY
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
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
									  )
								SELECT		 NEXT VALUE FOR SEQ1_DM_PLN_MDF_SIMULATOR_DATA_H
											,active_flag
											,MDF_VERSION_NO
											,DIVISION_ID
											,DEPARTMENT_ID
											,DMS_CUSTOMER
											,DMS_SALES
											,APPLICATION
											,BIZ_TYPE
											,ITEM_TYPE
											,MEASURE
											,UNIT_CURRENCY
											,YYYYMM
											,QTY
											,'MDF_SIMULATOR' AS CREATED_BY
											,GETDATE()   
											,'MDF_SIMULATOR' AS LAST_UPDATED_BY
											,GETDATE()
											,null,null,null,null,null,null,null,null,null,null
								 FROM  #results_MST
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                        DM_PLN_MDF_SIMULATOR_DATA_H 테이블 HISTORY INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇

  	-- 트랜잭션 (COMMIT)
        COMMIT TRANSACTION DMF0041_SAVE_MDF_SIMULTATOR;
	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION DMF0041_SAVE_MDF_SIMULTATOR;

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
   --  IF @v_log_message IS NULL
	  --SELECT 'success'	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / insert_count: ' + Convert(NVARCHAR(10), @n_insert_count) ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

  	--------------------------------------------------------------	
  	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION DMF0041_SAVE_MDF_SIMULTATOR;
			SET @v_log_message = '########## END of procedure @@@##########';
			SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / insert_count: ' + Convert(NVARCHAR(10), @n_insert_count) ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
	--------------------------------------------------------------	
