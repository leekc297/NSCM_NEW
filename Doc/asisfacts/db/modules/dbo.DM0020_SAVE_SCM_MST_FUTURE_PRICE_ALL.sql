
/*
 * Program ID   : DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL
 * Description  : DM0020_SalesFuturePricePopUp ('SCM_MST_FUTURE_PRICE' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 12    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2017. 03. 13    JHBAEK			INPUT KEY VALUE(PROJECT_CODE, MODEL) VALIDATION CHECK
 *                                  : PROJECT_CODE, MODEL(ITEM) 값을 수기로 입력할 수 있기에 INSERT 전에 VALIDATION CHECK를 한다.
 * 2018. 05. 14    KHSONG           Sales Price 화면에서 저장시 SalesAmt 계산후 dm_pln_sales_plan 테이블 SAVE Procedure 호출하는 로직 추가
 *
 */

CREATE PROCEDURE [dbo].[DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL]

	-- Add the parameters for the stored procedure here
    @p_active_flag             NVARCHAR(MAX),    
    @p_DIVISION_ID             NVARCHAR(MAX),    
    @p_PROJECT_CODE            NVARCHAR(MAX),    
    @p_SCM_SITE_ID             NVARCHAR(MAX),    
    @p_PLANT_SITE_ID           NVARCHAR(MAX),    
    @p_ITEM_ID                 NVARCHAR(MAX),    
    @p_YYYYMMDD                NVARCHAR(MAX),    
    @p_CURRENCY                NVARCHAR(MAX), 
    @p_MEASURE                 NVARCHAR(MAX), 
    @p_DOM_EXP                 NVARCHAR(MAX), 
    @p_FCST_TYPE               NVARCHAR(MAX), 
    @p_INCOTERMS               NVARCHAR(MAX),
    @p_PRICE                   NVARCHAR(MAX),    
    @p_CREATED_BY              NVARCHAR(MAX),    
    @p_CREATION_DATE           NVARCHAR(MAX),    
    @p_LAST_UPDATED_BY         NVARCHAR(MAX)    

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- 스플릿관련 변수

    DECLARE  @v_active_flag        NVARCHAR(MAX);
    DECLARE  @v_DIVISION_ID        NVARCHAR(MAX);
    DECLARE  @v_PROJECT_CODE       NVARCHAR(MAX);
    DECLARE  @v_SCM_SITE_ID        NVARCHAR(MAX);
    DECLARE  @v_PLANT_SITE_ID      NVARCHAR(MAX);
    DECLARE  @v_ITEM_ID            NVARCHAR(MAX);
    DECLARE  @v_YYYYMMDD           NVARCHAR(MAX);
    DECLARE  @v_CURRENCY           NVARCHAR(MAX);
    DECLARE  @v_MEASURE            NVARCHAR(MAX);
    DECLARE  @v_DOM_EXP            NVARCHAR(MAX);
    DECLARE  @v_FCST_TYPE          NVARCHAR(MAX);
    DECLARE  @v_INCOTERMS          NVARCHAR(MAX);
    DECLARE  @v_PRICE              NVARCHAR(MAX);
    DECLARE  @v_CREATED_BY         NVARCHAR(MAX);
    DECLARE  @v_CREATION_DATE      NVARCHAR(MAX);
    DECLARE  @v_LAST_UPDATED_BY    NVARCHAR(MAX);

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_merge_count     INTEGER = 0;
    DECLARE @n_logo_count      INTEGER = 0;



	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag      = RTRIM(@p_active_flag     ) + '^';
	SET @p_DIVISION_ID      = RTRIM(@p_DIVISION_ID     ) + '^';
	SET @p_PROJECT_CODE     = RTRIM(@p_PROJECT_CODE    ) + '^';
	SET @p_SCM_SITE_ID      = RTRIM(@p_SCM_SITE_ID     ) + '^';
	SET @p_PLANT_SITE_ID    = RTRIM(@p_PLANT_SITE_ID   ) + '^';
	SET @p_ITEM_ID          = RTRIM(@p_ITEM_ID         ) + '^';
	SET @p_YYYYMMDD         = RTRIM(@p_YYYYMMDD        ) + '^';
	SET @p_CURRENCY         = RTRIM(@p_CURRENCY        ) + '^';
	SET @p_MEASURE          = RTRIM(@p_MEASURE         ) + '^';
	SET @p_DOM_EXP          = RTRIM(@p_DOM_EXP         ) + '^';
	SET @p_FCST_TYPE        = RTRIM(@p_FCST_TYPE       ) + '^';
	SET @p_INCOTERMS        = RTRIM(@p_INCOTERMS       ) + '^';
	SET @p_PRICE            = RTRIM(@p_PRICE           ) + '^';
	SET @p_CREATED_BY       = RTRIM(@p_CREATED_BY      ) + '^';
	--SET @p_CREATION_DATE    = RTRIM(@p_CREATION_DATE   ) + '^';
	SET @p_LAST_UPDATED_BY  = RTRIM(@p_LAST_UPDATED_BY ) + '^';

	-- @results TEMP TABLE
	DECLARE @results TABLE (
             v_active_flag        NVARCHAR(MAX)
			,v_DIVISION_ID        NVARCHAR(MAX)
			,v_PROJECT_CODE       NVARCHAR(MAX)
			,v_SCM_SITE_ID        NVARCHAR(MAX)
			,v_PLANT_SITE_ID      NVARCHAR(MAX)
			,v_ITEM_ID            NVARCHAR(MAX)
			,v_YYYYMMDD           NVARCHAR(MAX)
			,v_CURRENCY           NVARCHAR(MAX)
			,v_MEASURE            NVARCHAR(MAX)
			,v_DOM_EXP            NVARCHAR(MAX)
			,v_FCST_TYPE          NVARCHAR(MAX)
			,v_INCOTERMS          NVARCHAR(MAX)
			,v_PRICE              NVARCHAR(MAX)
			,v_CREATED_BY         NVARCHAR(MAX)
			,v_CREATION_DATE      NVARCHAR(MAX)
			,v_LAST_UPDATED_BY    NVARCHAR(MAX)
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
		BEGIN TRANSACTION SCM_MST_FUTURE_PRICE_ALL;  -- sss

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	 DECIMAL

--===================================================================================== @results 테이블에 split후 insert start
--###############################################  @results 테이블에 split후 insert (START)
WHILE LEN(@p_DIVISION_ID) > 0
BEGIN
    DECLARE @index_DIVISION_ID     INT
	DECLARE @index_active_flag     INT
	DECLARE @index_PROJECT_CODE    INT
	DECLARE @index_SCM_SITE_ID     INT
	DECLARE @index_PLANT_SITE_ID   INT
	DECLARE @index_ITEM_ID         INT
	DECLARE @index_YYYYMMDD        INT
	DECLARE @index_CURRENCY        INT
	DECLARE @index_MEASURE         INT
	DECLARE @index_DOM_EXP         INT
	DECLARE @index_FCST_TYPE       INT
	DECLARE @index_INCOTERMS       INT
	DECLARE @index_PRICE           INT
	DECLARE @index_CREATED_BY      INT
	--DECLARE @index_CREATION_DATE   INT
	DECLARE @index_LAST_UPDATED_BY INT

    SET @index_DIVISION_ID      = PATINDEX('%' + '^' + '%', @p_DIVISION_ID)
	SET @index_active_flag      = PATINDEX('%' + '^' + '%', @p_active_flag)
	SET @index_PROJECT_CODE     = PATINDEX('%' + '^' + '%', @p_PROJECT_CODE)
	SET @index_SCM_SITE_ID      = PATINDEX('%' + '^' + '%', @p_SCM_SITE_ID    )
	SET @index_PLANT_SITE_ID    = PATINDEX('%' + '^' + '%', @p_PLANT_SITE_ID  )
	SET @index_ITEM_ID          = PATINDEX('%' + '^' + '%', @p_ITEM_ID        )
	SET @index_YYYYMMDD         = PATINDEX('%' + '^' + '%', @p_YYYYMMDD       )
	SET @index_CURRENCY         = PATINDEX('%' + '^' + '%', @p_CURRENCY       )
	SET @index_MEASURE          = PATINDEX('%' + '^' + '%', @p_MEASURE        )
	SET @index_DOM_EXP          = PATINDEX('%' + '^' + '%', @p_DOM_EXP        )
	SET @index_FCST_TYPE        = PATINDEX('%' + '^' + '%', @p_FCST_TYPE      )
	SET @index_INCOTERMS        = PATINDEX('%' + '^' + '%', @p_INCOTERMS      )
	SET @index_PRICE            = PATINDEX('%' + '^' + '%', @p_PRICE          )
	SET @index_CREATED_BY       = PATINDEX('%' + '^' + '%', @p_CREATED_BY     )
	--SET @index_CREATION_DATE    = PATINDEX('%' + '^' + '%', @p_CREATION_DATE  )
	SET @index_LAST_UPDATED_BY  = PATINDEX('%' + '^' + '%', @p_LAST_UPDATED_BY)

	--확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
    IF @index_DIVISION_ID > 0
		BEGIN
			SET @v_active_flag = SUBSTRING(@p_active_flag, 0, @index_active_flag)
			SET @p_active_flag = SUBSTRING(@p_active_flag, LEN(@v_active_flag + '^') + 1, LEN(@p_active_flag))

			SET @v_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, 0, @index_DIVISION_ID)
			SET @p_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, LEN(@v_DIVISION_ID + '^') + 1, LEN(@p_DIVISION_ID))

			SET @v_PROJECT_CODE = SUBSTRING(@p_PROJECT_CODE, 0, @index_PROJECT_CODE)
			SET @p_PROJECT_CODE = SUBSTRING(@p_PROJECT_CODE, LEN(@v_PROJECT_CODE + '^') + 1, LEN(@p_PROJECT_CODE))

			SET @v_SCM_SITE_ID = SUBSTRING(@p_SCM_SITE_ID, 0, @index_SCM_SITE_ID)
			SET @p_SCM_SITE_ID = SUBSTRING(@p_SCM_SITE_ID, LEN(@v_SCM_SITE_ID + '^') + 1, LEN(@p_SCM_SITE_ID))

			SET @v_PLANT_SITE_ID = SUBSTRING(@p_PLANT_SITE_ID, 0, @index_PLANT_SITE_ID)
			SET @p_PLANT_SITE_ID = SUBSTRING(@p_PLANT_SITE_ID, LEN(@v_PLANT_SITE_ID + '^') + 1, LEN(@p_PLANT_SITE_ID))

			SET @v_ITEM_ID = SUBSTRING(@p_ITEM_ID, 0, @index_ITEM_ID)
			SET @p_ITEM_ID = SUBSTRING(@p_ITEM_ID, LEN(@v_ITEM_ID + '^') + 1, LEN(@p_ITEM_ID))

			SET @v_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, 0, @index_YYYYMMDD)
			SET @p_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, LEN(@v_YYYYMMDD + '^') + 1, LEN(@p_YYYYMMDD))

			SET @v_CURRENCY = SUBSTRING(@p_CURRENCY, 0, @index_CURRENCY)
			SET @p_CURRENCY = SUBSTRING(@p_CURRENCY, LEN(@v_CURRENCY + '^') + 1, LEN(@p_CURRENCY))

			SET @v_MEASURE = SUBSTRING(@p_MEASURE, 0, @index_MEASURE)
			SET @p_MEASURE = SUBSTRING(@p_MEASURE, LEN(@v_MEASURE + '^') + 1, LEN(@p_MEASURE))

			SET @v_DOM_EXP = SUBSTRING(@p_DOM_EXP, 0, @index_DOM_EXP)
			SET @p_DOM_EXP = SUBSTRING(@p_DOM_EXP, LEN(@v_DOM_EXP + '^') + 1, LEN(@p_DOM_EXP))

			SET @v_FCST_TYPE = SUBSTRING(@p_FCST_TYPE, 0, @index_FCST_TYPE)
			SET @p_FCST_TYPE = SUBSTRING(@p_FCST_TYPE, LEN(@v_FCST_TYPE + '^') + 1, LEN(@p_FCST_TYPE))

			SET @v_INCOTERMS = SUBSTRING(@p_INCOTERMS, 0, @index_INCOTERMS)
			SET @p_INCOTERMS = SUBSTRING(@p_INCOTERMS, LEN(@v_INCOTERMS + '^') + 1, LEN(@p_INCOTERMS))

			SET @v_PRICE = SUBSTRING(@p_PRICE, 0, @index_PRICE)
			SET @p_PRICE = SUBSTRING(@p_PRICE, LEN(@v_PRICE + '^') + 1, LEN(@p_PRICE))

			SET @v_CREATED_BY = SUBSTRING(@p_CREATED_BY, 0, @index_CREATED_BY)
			SET @p_CREATED_BY = SUBSTRING(@p_CREATED_BY, LEN(@v_CREATED_BY + '^') + 1, LEN(@p_CREATED_BY))

			--SET @v_CREATION_DATE = SUBSTRING(@p_CREATION_DATE, 0, @index_CREATION_DATE)
			--SET @p_CREATION_DATE = SUBSTRING(@p_CREATION_DATE, LEN(@v_CREATION_DATE + '^') + 1, LEN(@p_CREATION_DATE))

			SET @v_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, 0, @index_LAST_UPDATED_BY)
			SET @p_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, LEN(@v_LAST_UPDATED_BY + '^') + 1, LEN(@p_LAST_UPDATED_BY))
 
			INSERT INTO @results ( 
			                         v_active_flag    
									,v_DIVISION_ID    
									,v_PROJECT_CODE   
									,v_SCM_SITE_ID    
									,v_PLANT_SITE_ID  
									,v_ITEM_ID        
									,v_YYYYMMDD       
									,v_CURRENCY       
									,v_MEASURE        
									,v_DOM_EXP        
									,v_FCST_TYPE      
									,v_INCOTERMS      
									,v_PRICE          
									,v_CREATED_BY     
									,v_CREATION_DATE  
									,v_LAST_UPDATED_BY	
			) VALUES ( 
			                         @v_active_flag    
									,@v_DIVISION_ID    
									,@v_PROJECT_CODE   
									,@v_SCM_SITE_ID    
									,@v_PLANT_SITE_ID  
									,@v_ITEM_ID        
									,@v_YYYYMMDD       
									,@v_CURRENCY       
									,@v_MEASURE        
									,@v_DOM_EXP        
									,@v_FCST_TYPE      
									,@v_INCOTERMS      
									,@v_PRICE          
									,@v_CREATED_BY     
									,GETDATE() -- @v_CREATION_DATE  
									,@v_LAST_UPDATED_BY			
			)
		END
    ELSE
		BEGIN
			SET @v_DIVISION_ID = @p_DIVISION_ID
			SET @p_DIVISION_ID = NULL
 
			INSERT INTO @results ( 
			                         v_active_flag    
									,v_DIVISION_ID    
									,v_PROJECT_CODE   
									,v_SCM_SITE_ID    
									,v_PLANT_SITE_ID  
									,v_ITEM_ID        
									,v_YYYYMMDD       
									,v_CURRENCY       
									,v_MEASURE        
									,v_DOM_EXP        
									,v_FCST_TYPE      
									,v_INCOTERMS      
									,v_PRICE          
									,v_CREATED_BY     
									,v_CREATION_DATE  
									,v_LAST_UPDATED_BY			
			) VALUES ( 
			                         @v_active_flag    
									,@v_DIVISION_ID    
									,@v_PROJECT_CODE   
									,@v_SCM_SITE_ID    
									,@v_PLANT_SITE_ID  
									,@v_ITEM_ID        
									,@v_YYYYMMDD       
									,@v_CURRENCY       
									,@v_MEASURE        
									,@v_DOM_EXP        
									,@v_FCST_TYPE      
									,@v_INCOTERMS      
									,@v_PRICE          
									,@v_CREATED_BY     
									,GETDATE() --@v_CREATION_DATE  
									,@v_LAST_UPDATED_BY			
			)
		END
END

	--###############################################   @results 테이블에 split후 insert (END)
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
		   BEGIN
		   IF @v_DIVISION_ID <> '40'
			   IF (select count(1)  from @results where ( select count(1) from dbo.scm_mst_project WITH(NOLOCK) where project_code  = v_PROJECT_CODE ) = 0 ) > 0
			   begin
				   SET @v_log_type = 'INVALID';
				   SELECT '['+ @v_PROJECT_CODE +']'+ N' Invalid Project Code !';
				   SET @v_description = '['+ @v_PROJECT_CODE +']'+ N' Invalid Project Code !'
				   goto err_rtn
			   end


			   IF (select count(1)  from @results where ( select count(1) from dbo.SCM_MST_ITEM_SN WITH(NOLOCK) where ITEM_ID  = v_ITEM_ID ) = 0 ) > 0
			   begin
				   SET @v_log_type = 'INVALID';
				   SELECT '['+ @v_ITEM_ID +']'+ N' Invalid Item ID !';
				   SET @v_description = '['+ @v_ITEM_ID +']'+ N' Invalid Item ID !'
				   goto err_rtn
			   end
		   END
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------


--===================================================================================== @results 테이블에 split후 insert end

--  SELECT * FROM @results;  -- 확인용
--===================================================================================== delete start
BEGIN
		   --  select * from @results
		   DELETE 
           FROM [dbo].SCM_MST_FUTURE_PRICE
           WHERE (
                    SELECT count(1) 
					  FROM @results 
					 where v_active_flag      = 'D'
                       and DIVISION_ID        =   v_DIVISION_ID         
                       AND PROJECT_CODE       =   v_PROJECT_CODE      
                       AND SCM_SITE_ID        =   v_SCM_SITE_ID
                       AND PLANT_SITE_ID      =   v_PLANT_SITE_ID
                       AND ITEM_ID            =   v_ITEM_ID     
                       AND YYYYMMDD           =   v_YYYYMMDD      
                       AND CURRENCY           =   v_CURRENCY      
                       AND MEASURE            =   v_MEASURE      
                       AND DOM_EXP            =   v_DOM_EXP      
                       AND FCST_TYPE          =   v_FCST_TYPE      
                       AND INCOTERMS          =   v_INCOTERMS  
				  ) > 0;
END
--===================================================================================== delete end


--===================================================================================== update, insert start
BEGIN
					MERGE INTO [dbo].SCM_MST_FUTURE_PRICE A
					USING (
							SELECT 
								    v_DIVISION_ID	    as DIVISION_ID, 
								    v_PROJECT_CODE    	as PROJECT_CODE, 
								    v_SCM_SITE_ID		as SCM_SITE_ID,
								    v_PLANT_SITE_ID	    as PLANT_SITE_ID,
								    v_ITEM_ID		    as ITEM_ID,
								    v_YYYYMMDD	   	    as YYYYMMDD,
								    v_CURRENCY		    as CURRENCY,
								    v_MEASURE		    as MEASURE,
								    v_DOM_EXP		    as DOM_EXP,
								    v_FCST_TYPE		    as FCST_TYPE,
								    v_INCOTERMS		    as INCOTERMS,
									v_PRICE             AS PRICE ,
									max(v_CREATED_BY)     as CREATED_BY,
									max(v_CREATION_DATE)  as CREATION_DATE,
									max(v_LAST_UPDATED_BY) as LAST_UPDATED_BY
                             FROM  @results  WHERE v_active_flag <> 'D'   -- DELETE값이 아닌경우만
                          group by   v_DIVISION_ID	  
								    ,v_PROJECT_CODE    
								    ,v_SCM_SITE_ID		
								    ,v_PLANT_SITE_ID	  
								    ,v_ITEM_ID		  
								    ,v_YYYYMMDD	   	  
								    ,v_CURRENCY		  
								    ,v_MEASURE		  
								    ,v_DOM_EXP		  
								    ,v_FCST_TYPE		  
								    ,v_INCOTERMS		  
									,v_PRICE           
						  ) B
					ON(
                                A.DIVISION_ID        =   B.DIVISION_ID          
                            AND A.PROJECT_CODE       =   B.PROJECT_CODE       
                            AND A.SCM_SITE_ID        =   B.SCM_SITE_ID     
                            AND A.PLANT_SITE_ID      =   B.PLANT_SITE_ID     
                            AND A.ITEM_ID            =   B.ITEM_ID       
                            AND A.YYYYMMDD           =   B.YYYYMMDD       
							-- Modifieyd by ytchoi Key 기준으로 currency를 update 해야 함.
                          --  AND A.CURRENCY           =   B.CURRENCY       
                            AND A.MEASURE            =   B.MEASURE       
                            AND A.DOM_EXP            =   B.DOM_EXP       
                            AND A.FCST_TYPE          =   B.FCST_TYPE       
                            AND A.INCOTERMS          =   B.INCOTERMS       
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
 									 DIVISION_ID         =  b.DIVISION_ID    
									,PROJECT_CODE        =  b.PROJECT_CODE   
									,SCM_SITE_ID         =  b.SCM_SITE_ID   
									,PLANT_SITE_ID       =  b.PLANT_SITE_ID
									,ITEM_ID             =  b.ITEM_ID        
									,YYYYMMDD            =  b.YYYYMMDD       
									,CURRENCY            =  b.CURRENCY       
									,MEASURE             =  b.MEASURE       
									,DOM_EXP             =  b.DOM_EXP       
									,FCST_TYPE           =  b.FCST_TYPE       
									,INCOTERMS           =  b.INCOTERMS      
									,PRICE               =  cast(b.PRICE as numeric(20,10))
									,CREATED_BY          =  b.CREATED_BY     
									,CREATION_DATE       =  sysdatetime()	--,CREATION_DATE       =  @v_CREATION_DATE  
									,LAST_UPDATED_BY     =  b.LAST_UPDATED_BY
									,LAST_UPDATE_DATE    =  sysdatetime()     

					WHEN NOT MATCHED THEN

					     INSERT 
								  ( DIVISION_ID     
								   ,PROJECT_CODE    
								   ,SCM_SITE_ID    
								   ,PLANT_SITE_ID 
								   ,ITEM_ID         
								   ,YYYYMMDD        
								   ,CURRENCY        
								   ,MEASURE        
								   ,DOM_EXP        
								   ,FCST_TYPE        
								   ,INCOTERMS       
								   ,PRICE           
								   ,CREATED_BY      
								   ,CREATION_DATE   
								   ,LAST_UPDATED_BY 
								   ,LAST_UPDATE_DATE
								)
						 VALUES (   
									b.DIVISION_ID    
								   ,b.PROJECT_CODE   
								   ,b.SCM_SITE_ID    
								   ,b.PLANT_SITE_ID
								   ,b.ITEM_ID        
								   ,b.YYYYMMDD       
								   ,b.CURRENCY       
								   ,b.MEASURE      
								   ,b.DOM_EXP      
								   ,b.FCST_TYPE      
								   ,b.INCOTERMS      
								   ,cast(b.PRICE as numeric(20,10))
								   ,b.CREATED_BY     
								   ,sysdatetime()    
								   ,b.LAST_UPDATED_BY
								   ,sysdatetime()     
								);


							---- HISTORY 생성
							-- [2018-03-20][수정][기존소스]
						   ---- HISTORY 생성
						   --BEGIN
							  --EXEC [dbo].[PR_DM_ANL_SALES_PRICE_HIST]
			  				--						 @v_division_id   
				  			--						,@v_project_code  
									--				,@v_scm_site_id   
									--				,@v_plant_site_id 
									--				,@v_item_id       
									--				,@v_yyyymmdd      
									--				,@v_currency      
									--				,@v_measure       
									--				,@v_dom_exp       
									--				,@v_fcst_type     
									--				,@v_incoterms     
									--				,@v_price         
									--				,@v_created_by    
									--				,@v_last_updated_by
						   --END

						   -- [2018-03-20][수정][수정소스]
							INSERT INTO  SCM_MST_FUTURE_PRICE_H
										( DIVISION_ID 
										,HISTORY_SEQ
										,PROJECT_CODE
										,SCM_SITE_ID
										,PLANT_SITE_ID
										,ITEM_ID
										,YYYYMMDD
										,CURRENCY
										,MEASURE
										,DOM_EXP
										,FCST_TYPE
										,INCOTERMS
										,PRICE
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
									  )
								SELECT 
										v_DIVISION_ID	    
										,NEXT VALUE FOR SEQ1_SCM_MST_FUTURE_PRICE_H
										,v_PROJECT_CODE    
										,v_SCM_SITE_ID		
										,v_PLANT_SITE_ID	
										,v_ITEM_ID		    
										,v_YYYYMMDD	   	    
										,v_CURRENCY		    
										,v_MEASURE		    
										,v_DOM_EXP		    
										,v_FCST_TYPE		
										,v_INCOTERMS		
										,v_PRICE            
										,v_CREATED_BY  
										,GETDATE()  
										,v_LAST_UPDATED_BY
										,GETDATE()
								 FROM  @results  WHERE v_active_flag <> 'D'   -- DELETE값이 아닌경우만

						--------------------------------------------------------------------------------------  20180510 SKH ADD START
						IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL 
							DROP TABLE #results

                         SELECT      v_DIVISION_ID	  
								    ,v_PROJECT_CODE    
								    ,v_SCM_SITE_ID		
								    ,v_ITEM_ID		  
								    ,v_DOM_EXP		  
								    ,v_FCST_TYPE		  
								    ,v_INCOTERMS		  
								    ,v_MEASURE		  
								    ,v_PLANT_SITE_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_PRICE
									,v_CREATED_BY
						 INTO #results FROM  @results  WHERE v_active_flag <> 'D'   -- DELETE값이 아닌경우만

						-- Procedure 호출 
						EXEC dbo.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE  
						--------------------------------------------------------------------------------------  20180510 SKH ADD END

END
--===================================================================================== update, insert end

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;  -- sss
	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION SCM_MST_FUTURE_PRICE_ALL;  -- sss

		-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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
    SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

  	--------------------------------------------------------------	
  	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
	--------------------------------------------------------------	
