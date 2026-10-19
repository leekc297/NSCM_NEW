
/*
 * Program ID   : DMF0039_SAVE_MST_SHIPMENT_PRIORITY
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20181203     KHSONG         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20190918     KHSONG         [CSR ID:4077124] ESS Shipment Priority 화면 변경요청
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 
 * 
 * 
 * 
*/

CREATE PROCEDURE [dbo].[DMF0039_SAVE_MST_SHIPMENT_PRIORITY]

	-- Add the parameters for the stored procedure here
    @p_DIVISION_ID             NVARCHAR(MAX),    
    @p_PROJECT_CODE            NVARCHAR(MAX),    
    @p_SCM_SITE_ID             NVARCHAR(MAX),-- 20190918 KHSONG [CSR ID:4077124]
    @p_END_CUSTOMER            NVARCHAR(MAX),-- 20190918 KHSONG [CSR ID:4077124]
    @p_ITEM_ID                 NVARCHAR(MAX),    
    @p_YYYYMMDD	               NVARCHAR(MAX),    
    @p_MEASURE                 NVARCHAR(MAX), 
    @p_PRIORITY                NVARCHAR(MAX),    
    @p_CREATED_BY			   NVARCHAR(MAX)    

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- 스플릿관련 변수

    DECLARE  @v_DIVISION_ID        NVARCHAR(MAX);
    DECLARE  @v_PROJECT_CODE       NVARCHAR(MAX);
    DECLARE  @v_SCM_SITE_ID        NVARCHAR(MAX);-- 20190918 KHSONG [CSR ID:4077124]
    DECLARE  @v_END_CUSTOMER       NVARCHAR(MAX);-- 20190918 KHSONG [CSR ID:4077124]
    DECLARE  @v_ITEM_ID            NVARCHAR(MAX);
    DECLARE  @v_YYYYMMDD           NVARCHAR(MAX);
    DECLARE  @v_MEASURE            NVARCHAR(MAX);
    DECLARE  @v_PRIORITY           NVARCHAR(MAX);
    DECLARE  @v_CREATED_BY		   NVARCHAR(MAX);

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name		NVARCHAR(150) = 'DMF0039_SAVE_MST_SHIPMENT_PRIORITY';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
    DECLARE @n_merge_count		INTEGER = 0;



	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_DIVISION_ID      = RTRIM(@p_DIVISION_ID     ) + '^';
	SET @p_PROJECT_CODE     = RTRIM(@p_PROJECT_CODE    ) + '^';
	SET @p_SCM_SITE_ID      = RTRIM(@p_SCM_SITE_ID     ) + '^';
	SET @p_END_CUSTOMER     = RTRIM(@p_END_CUSTOMER    ) + '^';
	SET @p_ITEM_ID          = RTRIM(@p_ITEM_ID         ) + '^';
	SET @p_YYYYMMDD         = RTRIM(@p_YYYYMMDD		   ) + '^';
	SET @p_MEASURE          = RTRIM(@p_MEASURE         ) + '^';
	SET @p_PRIORITY         = RTRIM(@p_PRIORITY        ) + '^';
	SET @p_CREATED_BY		= RTRIM(@p_CREATED_BY	   ) + '^';

	-- #results_MST TEMP TABLE
	CREATE TABLE #results_MST  (
			 v_DIVISION_ID        NVARCHAR(30) NOT NULL
			,v_PROJECT_CODE       NVARCHAR(50) NOT NULL
			,v_SCM_SITE_ID        NVARCHAR(50) NOT NULL
			,v_END_CUSTOMER       NVARCHAR(50) NOT NULL
			,v_ITEM_ID            NVARCHAR(50) NOT NULL
			,v_YYYYMMDD			  NVARCHAR(08) NOT NULL
			,v_MEASURE            NVARCHAR(50) NOT NULL
			,v_PRIORITY           INT NOT NULL
			,v_CREATED_BY	      NVARCHAR(150) NOT NULL
    )
	
	CREATE CLUSTERED INDEX [IDX_RESULTS_N1] ON [#results_MST]
	(
		 v_DIVISION_ID     ASC
		,v_PROJECT_CODE    ASC
		,v_SCM_SITE_ID     ASC
		,v_END_CUSTOMER    ASC
		,v_ITEM_ID         ASC
		,v_YYYYMMDD        ASC
		,v_MEASURE         ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure @@@##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION MST_SAVE_SHIPMENT_PRIORITY;  -- sss

		--------------------------------------------------------------------------------------------	
		BEGIN TRY
		--------------------------------------------------------------------------------------------

		--------------------------------------------------------------------------------------------
		--                                              #results_MST 테이블에 split후 insert (BEGIN)
		--------------------------------------------------------------------------------------------
		WHILE LEN(@p_DIVISION_ID) > 0
		BEGIN
			DECLARE @index_DIVISION_ID     INT
			DECLARE @index_PROJECT_CODE    INT
			DECLARE @index_SCM_SITE_ID     INT
			DECLARE @index_END_CUSTOMER    INT
			DECLARE @index_ITEM_ID         INT
			DECLARE @index_YYYYMMDD        INT
			DECLARE @index_MEASURE         INT
			DECLARE @index_PRIORITY        INT
			DECLARE @index_CREATED_BY	   INT

			SET @index_DIVISION_ID      = PATINDEX('%' + '^' + '%', @p_DIVISION_ID    )
			SET @index_PROJECT_CODE     = PATINDEX('%' + '^' + '%', @p_PROJECT_CODE   )
			SET @index_SCM_SITE_ID      = PATINDEX('%' + '^' + '%', @p_SCM_SITE_ID    )
			SET @index_END_CUSTOMER     = PATINDEX('%' + '^' + '%', @p_END_CUSTOMER   )
			SET @index_ITEM_ID          = PATINDEX('%' + '^' + '%', @p_ITEM_ID        )
			SET @index_YYYYMMDD         = PATINDEX('%' + '^' + '%', @p_YYYYMMDD         )
			SET @index_MEASURE          = PATINDEX('%' + '^' + '%', @p_MEASURE        )
			SET @index_PRIORITY         = PATINDEX('%' + '^' + '%', @p_PRIORITY       )
			SET @index_CREATED_BY	    = PATINDEX('%' + '^' + '%', @p_CREATED_BY     )

			--확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
			IF @index_DIVISION_ID > 0
				BEGIN
					SET @v_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, 0, @index_DIVISION_ID)
					SET @p_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, LEN(@v_DIVISION_ID + '^') + 1, LEN(@p_DIVISION_ID))

					SET @v_PROJECT_CODE = SUBSTRING(@p_PROJECT_CODE , 0, @index_PROJECT_CODE)
					SET @p_PROJECT_CODE = SUBSTRING(@p_PROJECT_CODE , LEN(@v_PROJECT_CODE + '^') + 1, LEN(@p_PROJECT_CODE ))

					SET @v_SCM_SITE_ID = SUBSTRING(@p_SCM_SITE_ID , 0, @index_SCM_SITE_ID)
					SET @p_SCM_SITE_ID = SUBSTRING(@p_SCM_SITE_ID , LEN(@v_SCM_SITE_ID + '^') + 1, LEN(@p_SCM_SITE_ID ))

					SET @v_END_CUSTOMER = SUBSTRING(@p_END_CUSTOMER , 0, @index_END_CUSTOMER)
					SET @p_END_CUSTOMER = SUBSTRING(@p_END_CUSTOMER , LEN(@v_END_CUSTOMER + '^') + 1, LEN(@p_END_CUSTOMER ))

					SET @v_ITEM_ID = SUBSTRING(@p_ITEM_ID, 0, @index_ITEM_ID)
					SET @p_ITEM_ID = SUBSTRING(@p_ITEM_ID, LEN(@v_ITEM_ID + '^') + 1, LEN(@p_ITEM_ID))

					SET @v_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, 0, @index_YYYYMMDD)
					SET @p_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, LEN(@v_YYYYMMDD + '^') + 1, LEN(@p_YYYYMMDD))

					SET @v_MEASURE = SUBSTRING(@p_MEASURE, 0, @index_MEASURE)
					SET @p_MEASURE = SUBSTRING(@p_MEASURE, LEN(@v_MEASURE + '^') + 1, LEN(@p_MEASURE))

					SET @v_PRIORITY = SUBSTRING(@p_PRIORITY, 0, @index_PRIORITY)
					SET @p_PRIORITY = SUBSTRING(@p_PRIORITY, LEN(@v_PRIORITY + '^') + 1, LEN(@p_PRIORITY))

					SET @v_CREATED_BY = SUBSTRING(@p_CREATED_BY, 0, @index_CREATED_BY)
					SET @p_CREATED_BY = SUBSTRING(@p_CREATED_BY, LEN(@v_CREATED_BY + '^') + 1, LEN(@p_CREATED_BY))
 
					--공백제거로직(BEGIN)
					SET @v_DIVISION_ID    	= rtrim(ltrim(@v_DIVISION_ID))
					SET @v_PROJECT_CODE   	= rtrim(ltrim(@v_PROJECT_CODE))
					SET @v_SCM_SITE_ID   	= rtrim(ltrim(@v_SCM_SITE_ID))
					SET @v_END_CUSTOMER   	= rtrim(ltrim(@v_END_CUSTOMER))
					SET @v_ITEM_ID        	= rtrim(ltrim(@v_ITEM_ID))
					SET @v_YYYYMMDD       	= rtrim(ltrim(@v_YYYYMMDD))
					SET @v_MEASURE        	= rtrim(ltrim(@v_MEASURE))
					SET @v_PRIORITY      	= rtrim(ltrim(@v_PRIORITY))
					SET @v_CREATED_BY	    = rtrim(ltrim(@v_CREATED_BY))
					--공백제거로직(END)

					-- 1~99까지의 숫자값이 아닌경우 에러
					IF (CONVERT(INT, @v_PRIORITY) < 1 OR CONVERT(INT, @v_PRIORITY) > 99)
						AND @v_PRIORITY <> ''  -- 공백은 삭제로 사용
						BEGIN
							SET @v_log_type = 'INVALID';
							SET @v_description = '- Model : '+ @v_ITEM_ID + '  ' +char(10) + '- Input Priority : ' + @v_PRIORITY +char(10) + N'Priority 값은 1 ~ 99 까지만 입력가능합니다!'
							SELECT @v_description
							GOTO ERR_RTN;
						END

					INSERT INTO #results_MST ( 
											 v_DIVISION_ID
											,v_PROJECT_CODE   
											,v_SCM_SITE_ID        
											,v_END_CUSTOMER       
											,v_ITEM_ID        
											,v_YYYYMMDD       
											,v_MEASURE
											,v_PRIORITY
											,v_CREATED_BY	
					) VALUES ( 
											 @v_DIVISION_ID    
											,@v_PROJECT_CODE   
											,@v_SCM_SITE_ID  
											,@v_END_CUSTOMER 
											,@v_ITEM_ID        
											,@v_YYYYMMDD       
											,@v_MEASURE        
											,@v_PRIORITY
											,@v_CREATED_BY			
					)
				END
			ELSE
				BEGIN
					SET @v_DIVISION_ID = @p_DIVISION_ID
					SET @p_DIVISION_ID = NULL
 
					--공백제거로직(BEGIN)
					SET @v_DIVISION_ID    	= rtrim(ltrim(@v_DIVISION_ID))
					SET @v_PROJECT_CODE   	= rtrim(ltrim(@v_PROJECT_CODE))
					SET @v_SCM_SITE_ID   	= rtrim(ltrim(@v_SCM_SITE_ID))
					SET @v_END_CUSTOMER   	= rtrim(ltrim(@v_END_CUSTOMER))
					SET @v_ITEM_ID        	= rtrim(ltrim(@v_ITEM_ID))
					SET @v_YYYYMMDD       	= rtrim(ltrim(@v_YYYYMMDD))
					SET @v_MEASURE        	= rtrim(ltrim(@v_MEASURE))
					SET @v_PRIORITY      	= rtrim(ltrim(@v_PRIORITY))
					SET @v_CREATED_BY		= rtrim(ltrim(@v_CREATED_BY))
					--공백제거로직(END)

					-- 1~99까지의 숫자값이 아닌경우 에러
					IF (CONVERT(INT, @v_PRIORITY) < 1 OR CONVERT(INT, @v_PRIORITY) > 99)
						AND @v_PRIORITY <> ''  -- 공백은 삭제로 사용
						BEGIN
							SET @v_log_type = 'INVALID';
							SET @v_description = 'Model : '+ @v_ITEM_ID + '  ' +char(10) + 'Priority : ' + @v_PRIORITY +char(10) + N' Priority 값은 1 ~ 99 까지만 입력가능합니다!'
							SELECT @v_description
							GOTO ERR_RTN;
						END


					INSERT INTO #results_MST ( 
											 v_DIVISION_ID
											,v_PROJECT_CODE   
											,v_SCM_SITE_ID   
											,v_END_CUSTOMER   
											,v_ITEM_ID        
											,v_YYYYMMDD       
											,v_MEASURE
											,v_PRIORITY
											,v_CREATED_BY	
					) VALUES ( 
											 @v_DIVISION_ID    
											,@v_PROJECT_CODE   
											,@v_SCM_SITE_ID   
											,@v_END_CUSTOMER  
											,@v_ITEM_ID        
											,@v_YYYYMMDD       
											,@v_MEASURE        
											,@v_PRIORITY
											,@v_CREATED_BY			
					)
				END
		END
		--------------------------------------------------------------------------------------------
		--                                              #results_MST 테이블에 split후 insert (END)
		--------------------------------------------------------------------------------------------

		--------------------------------------------------------------------------------------------
		--                                           DM_MST_SHIPMENT_PRIORITY 테이블에 Merge (BEGIN)
		--------------------------------------------------------------------------------------------
		BEGIN
						-- count
						set @n_merge_count = isnull((select count(*) from #results_MST),0)
				
						-- merge 수행
						MERGE INTO [dbo].DM_MST_SHIPMENT_PRIORITY A
						USING (
								SELECT 
									 v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID -- 20190918 KHSONG [CSR ID:4077124]
									,v_END_CUSTOMER -- 20190918 KHSONG [CSR ID:4077124]
									,v_ITEM_ID
									,v_MEASURE
									,v_YYYYMMDD
									,v_PRIORITY
									,v_CREATED_BY
								FROM  #results_MST  WHERE 1=1
								) B
						ON(
									A.DIVISION_ID		=  B.v_DIVISION_ID   
								AND A.PROJECT_CODE		=  B.v_PROJECT_CODE  
								AND A.SCM_SITE_ID		=  B.v_SCM_SITE_ID -- 20190918 KHSONG [CSR ID:4077124]
								AND A.END_CUSTOMER		=  B.v_END_CUSTOMER -- 20190918 KHSONG [CSR ID:4077124]
								AND A.ITEM_ID			=  B.v_ITEM_ID
								AND A.MEASURE			=  B.v_MEASURE
								AND A.YYYYMMDD			=  B.v_YYYYMMDD
							)
						WHEN MATCHED THEN
								UPDATE SET 
 										 PRIORITY			= B.v_PRIORITY			
										,LAST_UPDATED_BY	= B.v_CREATED_BY
										,LAST_UPDATE_DATE	= GETDATE()
						WHEN NOT MATCHED THEN

								INSERT (
										 DIVISION_ID
										,PROJECT_CODE
										,SCM_SITE_ID  -- 20190918 KHSONG [CSR ID:4077124]
										,END_CUSTOMER
										,ITEM_ID
										,MEASURE
										,YYYYMMDD
										,PRIORITY
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
									)
								VALUES (   
										 b.v_DIVISION_ID
										,b.v_PROJECT_CODE
										,b.v_SCM_SITE_ID  -- 20190918 KHSONG [CSR ID:4077124]
										,b.v_END_CUSTOMER  -- 20190918 KHSONG [CSR ID:4077124]
										,b.v_ITEM_ID
										,b.v_MEASURE
										,b.v_YYYYMMDD
										,b.v_PRIORITY
										,b.v_CREATED_BY
										,GETDATE()
										,b.v_CREATED_BY
										,GETDATE()
									)
										;

		END
		--------------------------------------------------------------------------------------------
		--                                           DM_MST_SHIPMENT_PRIORITY 테이블에 Merge (END)
		--------------------------------------------------------------------------------------------

		--------------------------------------------------------------------------------------------
		--                                                           HISTORY 테이블에 INSERT (START)
		--------------------------------------------------------------------------------------------
		BEGIN
									INSERT INTO  DM_MST_SHIPMENT_PRIORITY_H
											   ( HISTORY_SEQ
												,DIVISION_ID 
												,PROJECT_CODE
												,SCM_SITE_ID  -- 20190918 KHSONG [CSR ID:4077124]
												,END_CUSTOMER  -- 20190918 KHSONG [CSR ID:4077124]
												,ITEM_ID
												,MEASURE
												,YYYYMMDD
												,PRIORITY
												,CREATED_BY
												,CREATION_DATE
												,LAST_UPDATED_BY
												,LAST_UPDATE_DATE
											  )
										SELECT 
												 NEXT VALUE FOR SEQ1_DM_MST_SHIPMENT_PRIORITY_H
												,v_DIVISION_ID	    
												,v_PROJECT_CODE   
												,v_SCM_SITE_ID   -- 20190918 KHSONG [CSR ID:4077124]
												,v_END_CUSTOMER   -- 20190918 KHSONG [CSR ID:4077124]
												,v_ITEM_ID		    
												,v_MEASURE		    
												,v_YYYYMMDD	   	    
												,v_PRIORITY            
												,v_CREATED_BY  
												,GETDATE()  
												,v_CREATED_BY
												,GETDATE()
										 FROM  #results_MST
		END
		--------------------------------------------------------------------------------------------
		--                                                           HISTORY 테이블에 INSERT (END)
		--------------------------------------------------------------------------------------------

		-- UI에서 공백으로 전달된 '0'값 삭제처리
		DELETE  FROM DM_MST_SHIPMENT_PRIORITY WHERE PRIORITY = 0

  	-- 트랜잭션 (COMMIT)
        COMMIT TRANSACTION MST_SAVE_SHIPMENT_PRIORITY;  -- sss
	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION MST_SAVE_SHIPMENT_PRIORITY;  -- sss

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_description = 'merge_count: '+ Convert(NVARCHAR(10), @n_merge_count) ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

  	--------------------------------------------------------------	
  	ERR_RTN:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION MST_SAVE_SHIPMENT_PRIORITY;
			SET @v_log_message = '########## END of procedure @@@##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
	--------------------------------------------------------------	

