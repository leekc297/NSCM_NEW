
/*
 * Program ID   : DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL
 * Description  : DM0020_SalesFuturePricePopUp ('DM_MST_EXCHANGE_RATE' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20180807 KHSONG Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180807 KHSONG Split 구조변경
 */

CREATE PROCEDURE [dbo].[DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL]
    @p_active_flag            NVARCHAR(MAX),    
	@p_division_id            NVARCHAR(MAX),
    @p_YYYYMMDD               NVARCHAR(MAX),    
    @p_CURRENCY               NVARCHAR(MAX),    
    @p_UNIT_CURRENCY          NVARCHAR(MAX),    
    @p_EXCHANGE_PRICE         NVARCHAR(MAX),    
    @p_CREATED_BY             NVARCHAR(MAX),    
    @p_LAST_UPDATED_BY        NVARCHAR(MAX)    


AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- 스플릿관련 변수
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

    DECLARE  @v_active_flag      NVARCHAR(MAX);
    DECLARE  @v_division_id      NVARCHAR(MAX);
    DECLARE  @v_YYYYMMDD         NVARCHAR(MAX);
    DECLARE  @v_CURRENCY         NVARCHAR(MAX);
    DECLARE  @v_UNIT_CURRENCY    NVARCHAR(MAX);
    DECLARE  @v_EXCHANGE_PRICE   NVARCHAR(MAX);
    DECLARE  @v_CREATED_BY       NVARCHAR(MAX);
    DECLARE  @v_LAST_UPDATED_BY  NVARCHAR(MAX);

	-- recv init
    SET  @v_active_flag      =  NULL;
    SET  @v_division_id      =  NULL;
    SET  @v_YYYYMMDD         =  NULL;
    SET  @v_CURRENCY         =  NULL;
    SET  @v_UNIT_CURRENCY    =  NULL;
    SET  @v_EXCHANGE_PRICE   =  NULL;
    SET  @v_CREATED_BY       =  NULL;
    SET  @v_LAST_UPDATED_BY  =  NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag      = RTRIM(@p_active_flag     ) + '^';
	SET @p_division_id      = RTRIM(@p_division_id     ) + '^';
	SET @p_YYYYMMDD         = RTRIM(@p_YYYYMMDD        ) + '^';
	SET @p_CURRENCY         = RTRIM(@p_CURRENCY        ) + '^';
	SET @p_UNIT_CURRENCY    = RTRIM(@p_UNIT_CURRENCY   ) + '^';
	SET @p_EXCHANGE_PRICE   = RTRIM(@p_EXCHANGE_PRICE  ) + '^';
	SET @p_CREATED_BY       = RTRIM(@p_CREATED_BY      ) + '^';
	SET @p_LAST_UPDATED_BY  = RTRIM(@p_LAST_UPDATED_BY ) + '^';

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0020_SAVE_DM_MST_EXCHANGE_RATE_ALL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_merge_count     INTEGER = 0;
	
	-- @results TEMP TABLE
	DECLARE @results TABLE (
             active_flag        NVARCHAR(MAX)
			,division_id        NVARCHAR(MAX)
			,YYYYMMDD           NVARCHAR(MAX)
			,CURRENCY           NVARCHAR(MAX)
			,UNIT_CURRENCY      NVARCHAR(MAX)
			,EXCHANGE_PRICE     NVARCHAR(MAX)
			,CREATED_BY         NVARCHAR(MAX)
			,LAST_UPDATED_BY    NVARCHAR(MAX)
    )

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

--###############################################  @results 테이블에 split후 insert (START)
WHILE LEN(@p_DIVISION_ID) > 0
BEGIN
    DECLARE @index_active_flag       INT
	DECLARE @index_division_id       INT
	DECLARE @index_YYYYMMDD          INT
	DECLARE @index_CURRENCY          INT
	DECLARE @index_UNIT_CURRENCY     INT
	DECLARE @index_EXCHANGE_PRICE    INT
	DECLARE @index_CREATED_BY        INT
	DECLARE @index_LAST_UPDATED_BY   INT

    SET @index_active_flag       = PATINDEX('%' + '^' + '%', @p_active_flag     )
	SET @index_division_id       = PATINDEX('%' + '^' + '%', @p_division_id     )
	SET @index_YYYYMMDD          = PATINDEX('%' + '^' + '%', @p_YYYYMMDD        )
	SET @index_CURRENCY          = PATINDEX('%' + '^' + '%', @p_CURRENCY        )
	SET @index_UNIT_CURRENCY     = PATINDEX('%' + '^' + '%', @p_UNIT_CURRENCY   )
	SET @index_EXCHANGE_PRICE    = PATINDEX('%' + '^' + '%', @p_EXCHANGE_PRICE  )
	SET @index_CREATED_BY        = PATINDEX('%' + '^' + '%', @p_CREATED_BY      )
	SET @index_LAST_UPDATED_BY   = PATINDEX('%' + '^' + '%', @p_LAST_UPDATED_BY )

	--확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
    IF @index_DIVISION_ID > 0
		BEGIN
			SET @v_active_flag = SUBSTRING(@p_active_flag, 0, @index_active_flag)
			SET @p_active_flag = SUBSTRING(@p_active_flag, LEN(@v_active_flag + '^') + 1, LEN(@p_active_flag))

			SET @v_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, 0, @index_DIVISION_ID)
			SET @p_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, LEN(@v_DIVISION_ID + '^') + 1, LEN(@p_DIVISION_ID))

			SET @v_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, 0, @index_YYYYMMDD)
			SET @p_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, LEN(@v_YYYYMMDD + '^') + 1, LEN(@p_YYYYMMDD))

			SET @v_CURRENCY = SUBSTRING(@p_CURRENCY, 0, @index_CURRENCY)
			SET @p_CURRENCY = SUBSTRING(@p_CURRENCY, LEN(@v_CURRENCY + '^') + 1, LEN(@p_CURRENCY))

			SET @v_UNIT_CURRENCY = SUBSTRING(@p_UNIT_CURRENCY, 0, @index_UNIT_CURRENCY)
			SET @p_UNIT_CURRENCY = SUBSTRING(@p_UNIT_CURRENCY, LEN(@v_UNIT_CURRENCY + '^') + 1, LEN(@p_UNIT_CURRENCY))

			SET @v_EXCHANGE_PRICE = SUBSTRING(@p_EXCHANGE_PRICE, 0, @index_EXCHANGE_PRICE)
			SET @p_EXCHANGE_PRICE = SUBSTRING(@p_EXCHANGE_PRICE, LEN(@v_EXCHANGE_PRICE + '^') + 1, LEN(@p_EXCHANGE_PRICE))

			SET @v_CREATED_BY = SUBSTRING(@p_CREATED_BY, 0, @index_CREATED_BY)
			SET @p_CREATED_BY = SUBSTRING(@p_CREATED_BY, LEN(@v_CREATED_BY + '^') + 1, LEN(@p_CREATED_BY))

			SET @v_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, 0, @index_LAST_UPDATED_BY)
			SET @p_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, LEN(@v_LAST_UPDATED_BY + '^') + 1, LEN(@p_LAST_UPDATED_BY))
 
			INSERT INTO @results ( 
			                         active_flag    
									,division_id    
									,YYYYMMDD       
									,CURRENCY       
									,UNIT_CURRENCY  
									,EXCHANGE_PRICE 
									,CREATED_BY     
									,LAST_UPDATED_BY
			) VALUES ( 
			                         @v_active_flag    
									,@v_division_id    
									,@v_YYYYMMDD       
									,@v_CURRENCY       
									,@v_UNIT_CURRENCY  
									,@v_EXCHANGE_PRICE 
									,@v_CREATED_BY     
									,@v_LAST_UPDATED_BY
			)
		END
    ELSE
		BEGIN
			SET @v_DIVISION_ID = @p_DIVISION_ID
			SET @p_DIVISION_ID = NULL
 
			INSERT INTO @results ( 
			                         active_flag    
									,division_id    
									,YYYYMMDD       
									,CURRENCY       
									,UNIT_CURRENCY  
									,EXCHANGE_PRICE 
									,CREATED_BY     
									,LAST_UPDATED_BY
			) VALUES ( 
			                         @v_active_flag    
									,@v_division_id    
									,@v_YYYYMMDD       
									,@v_CURRENCY       
									,@v_UNIT_CURRENCY  
									,@v_EXCHANGE_PRICE 
									,@v_CREATED_BY     
									,@v_LAST_UPDATED_BY
			)
		END
			-- 20180806 KHSONG Division_id Null Validation 추가
			IF NOT EXISTS ( SELECT 1 FROM [dbo].SCM_MST_DIVISION WITH (NOLOCK) WHERE 1=1
									  AND DIVISION_ID = @v_DIVISION_ID ) 
				BEGIN 
					SET @v_log_type = 'INVALID'
					GOTO ERR_RTN
				END
END

	--###############################################   @results 테이블에 split후 insert (END)

--===================================================================================== delete start
BEGIN
		   --  select * from @results
		   DELETE 
           FROM [dbo].DM_MST_EXCHANGE_RATE
           WHERE exists(
                    SELECT DIVISION_ID
					  FROM @results 
					 where active_flag      = 'D'
                       and DM_MST_EXCHANGE_RATE.DIVISION_ID        =   DIVISION_ID         
                       AND DM_MST_EXCHANGE_RATE.YYYYMMDD           =   YYYYMMDD          
                       AND DM_MST_EXCHANGE_RATE.CURRENCY           =   CURRENCY     
                       AND DM_MST_EXCHANGE_RATE.UNIT_CURRENCY      =   UNIT_CURRENCY
				  );
END
--===================================================================================== delete end

--===================================================================================== update, insert start
BEGIN
					MERGE INTO [dbo].DM_MST_EXCHANGE_RATE A
					USING (
							SELECT 
								     division_id   
								    ,YYYYMMDD      
								    ,CURRENCY      
								    ,UNIT_CURRENCY 
								    ,max(EXCHANGE_PRICE)  as EXCHANGE_PRICE
									,max(CREATED_BY)      as CREATED_BY
									,max(LAST_UPDATED_BY) as LAST_UPDATED_BY
                             FROM  @results  WHERE active_flag <> 'D'   -- DELETE값이 아닌경우만
                          group by   division_id     
								    ,YYYYMMDD       
								    ,CURRENCY       	
								    ,UNIT_CURRENCY   
						  ) B
					ON(
                                A.division_id        =   B.division_id      
                            AND A.YYYYMMDD           =   B.YYYYMMDD       
                            AND A.CURRENCY           =   B.CURRENCY      
                            AND A.UNIT_CURRENCY      =   B.UNIT_CURRENCY 
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
 									 division_id         =  b.division_id   
									,YYYYMMDD            =  b.YYYYMMDD      
									,CURRENCY            =  b.CURRENCY      
									,UNIT_CURRENCY       =  b.UNIT_CURRENCY 
									,EXCHANGE_PRICE      =  b.EXCHANGE_PRICE
									,CREATED_BY          =  b.CREATED_BY     
									,CREATION_DATE       =  sysdatetime()	--,CREATION_DATE       =  @v_CREATION_DATE  
									,LAST_UPDATED_BY     =  b.LAST_UPDATED_BY
									,LAST_UPDATE_DATE    =  sysdatetime()     

					WHEN NOT MATCHED THEN

					     INSERT 
								  ( division_id   
								   ,YYYYMMDD      
								   ,CURRENCY      
								   ,UNIT_CURRENCY 
								   ,EXCHANGE_PRICE
								   ,CREATED_BY      
								   ,CREATION_DATE   
								   ,LAST_UPDATED_BY 
								   ,LAST_UPDATE_DATE
								)
						 VALUES (   
									b.division_id   
								   ,b.YYYYMMDD      
								   ,b.CURRENCY      
								   ,b.UNIT_CURRENCY 
								   ,b.EXCHANGE_PRICE
								   ,b.CREATED_BY     
								   ,sysdatetime()    
								   ,b.LAST_UPDATED_BY
								   ,sysdatetime()     
								);


END
--===================================================================================== update, insert end


     -- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	ERR_RTN:
	IF @v_log_type = 'INVALID'
		BEGIN
			ROLLBACK TRANSACTION;
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SELECT N'Division 값이 존재하지 않습니다.'
		END

  END;
