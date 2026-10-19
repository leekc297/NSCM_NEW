
/*
 * Program ID   : DM0021_SAVE_DM_PLN_SALES_PLAN_ALL
 * Description  : DM0020_SalesFuturePricePopUp ('DM_PLN_SALES_PLAN' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 03. 12    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[DM0021_SAVE_DM_PLN_SALES_PLAN_ALL]

	-- Add the parameters for the stored procedure here
    @p_active_flag              NVARCHAR(MAX),    
    @p_DIVISION_ID              NVARCHAR(MAX),    
    @p_PROJECT_CODE             NVARCHAR(MAX),    
    @p_SCM_SITE_ID              NVARCHAR(MAX),   
	@p_PLANT_SITE_ID            NVARCHAR(MAX), 
    @p_ITEM_ID                  NVARCHAR(MAX),    
    @p_DOM_EXP                  NVARCHAR(MAX),    
    @p_FCST_TYPE                NVARCHAR(MAX), 
    @p_INCOTERMS                NVARCHAR(MAX), 
    @p_MEASURE                  NVARCHAR(MAX),
    @p_YYYYMMDD                 NVARCHAR(MAX),    
    @p_QTY                      NVARCHAR(MAX),    
    @p_CURRENCY                 NVARCHAR(MAX),    
    @p_CREATED_BY               NVARCHAR(MAX),    
	@p_LAST_UPDATED_BY          NVARCHAR(MAX)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- 스플릿관련 변수
    DECLARE  @n_active_flag       NVARCHAR(MAX);
    DECLARE  @v_active_flag       NVARCHAR(MAX);
    DECLARE  @v_DIVISION_ID       NVARCHAR(MAX);
    DECLARE  @v_PROJECT_CODE      NVARCHAR(MAX);
    DECLARE  @v_SCM_SITE_ID       NVARCHAR(MAX);
    DECLARE  @v_PLANT_SITE_ID     NVARCHAR(MAX);
    DECLARE  @v_ITEM_ID           NVARCHAR(MAX);
    DECLARE  @v_DOM_EXP           NVARCHAR(MAX);
    DECLARE  @v_FCST_TYPE         NVARCHAR(MAX);
    DECLARE  @v_INCOTERMS         NVARCHAR(MAX);
    DECLARE  @v_MEASURE           NVARCHAR(MAX);
    DECLARE  @v_YYYYMMDD          NVARCHAR(MAX);
    DECLARE  @v_CURRENCY          NVARCHAR(MAX);
    DECLARE  @v_QTY               NVARCHAR(MAX);
    DECLARE  @v_CREATED_BY        NVARCHAR(MAX);
    DECLARE  @v_LAST_UPDATED_BY   NVARCHAR(MAX);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0021_SAVE_DM_PLN_SALES_PLAN_ALL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_del_count    INTEGER = 0;
    DECLARE @n_insert_count    INTEGER = 0;

	-- SEQUENCE
	DECLARE @n_history_seq		INTEGER;


	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag        = RTRIM(@p_active_flag     ) + '^';
	SET @p_DIVISION_ID        = RTRIM(@p_DIVISION_ID     ) + '^';
	SET @p_PROJECT_CODE       = RTRIM(@p_PROJECT_CODE    ) + '^';
	SET @p_SCM_SITE_ID        = RTRIM(@p_SCM_SITE_ID     ) + '^';
	SET @p_PLANT_SITE_ID      = RTRIM(@p_PLANT_SITE_ID   ) + '^';
	SET @p_ITEM_ID            = RTRIM(@p_ITEM_ID         ) + '^';
	SET @p_DOM_EXP            = RTRIM(@p_DOM_EXP         ) + '^';
	SET @p_FCST_TYPE          = RTRIM(@p_FCST_TYPE       ) + '^';
	SET @p_INCOTERMS          = RTRIM(@p_INCOTERMS       ) + '^';
	SET @p_MEASURE            = RTRIM(@p_MEASURE         ) + '^';
	SET @p_YYYYMMDD           = RTRIM(@p_YYYYMMDD        ) + '^';
	SET @p_CURRENCY           = RTRIM(@p_CURRENCY        ) + '^';
	SET @p_QTY                = RTRIM(@p_QTY             ) + '^';
	SET @p_CREATED_BY         = RTRIM(@p_CREATED_BY      ) + '^';
	SET @p_LAST_UPDATED_BY    = RTRIM(@p_LAST_UPDATED_BY ) + '^';

	-- TEMP TABLE CREATE
		IF  OBJECT_ID(N'dbo.TEMP_SALES_PLAN$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE dbo.TEMP_SALES_PLAN$ 
			END;

	CREATE TABLE TEMP_SALES_PLAN$ (
						         v_active_flag        NVARCHAR(MAX)
								,v_DIVISION_ID        NVARCHAR(MAX)
								,v_PROJECT_CODE       NVARCHAR(MAX)
								,v_SCM_SITE_ID        NVARCHAR(MAX)
								,v_PLANT_SITE_ID      NVARCHAR(MAX)
								,v_ITEM_ID            NVARCHAR(MAX)
								,v_DOM_EXP            NVARCHAR(MAX)
								,v_FCST_TYPE          NVARCHAR(MAX)
								,v_INCOTERMS          NVARCHAR(MAX)
								,v_MEASURE            NVARCHAR(MAX)
								,v_YYYYMMDD           NVARCHAR(MAX)
								,v_CURRENCY           NVARCHAR(MAX)
								,v_QTY                NVARCHAR(MAX)
								,v_CREATED_BY         NVARCHAR(MAX)
								,v_LAST_UPDATED_BY    NVARCHAR(MAX)
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
		BEGIN TRANSACTION SAVE_DM_PLN_SALES_PLAN_ALL;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

	WHILE LEN(@p_DIVISION_ID) > 0
	--###############################################  TEMP_SALES_PLAN$ 테이블에 split후 insert (START)
	BEGIN

	    -------------------------------------------
		BEGIN
	        DECLARE @index_active_flag     INT
			DECLARE @index_DIVISION_ID     INT
			DECLARE @index_PROJECT_CODE    INT
			DECLARE @index_SCM_SITE_ID     INT
			DECLARE @index_PLANT_SITE_ID   INT
			DECLARE @index_ITEM_ID         INT
			DECLARE @index_DOM_EXP         INT
			DECLARE @index_FCST_TYPE       INT
			DECLARE @index_INCOTERMS       INT
			DECLARE @index_MEASURE         INT
			DECLARE @index_YYYYMMDD        INT
			DECLARE @index_CURRENCY        INT
			DECLARE @index_QTY             INT
			DECLARE @index_CREATED_BY      INT
			DECLARE @index_LAST_UPDATED_BY INT

			SET @index_active_flag      = PATINDEX('%' + '^' + '%', @p_active_flag    )
			SET @index_DIVISION_ID      = PATINDEX('%' + '^' + '%', @p_DIVISION_ID    )
			SET @index_PROJECT_CODE     = PATINDEX('%' + '^' + '%', @p_PROJECT_CODE   )
			SET @index_SCM_SITE_ID      = PATINDEX('%' + '^' + '%', @p_SCM_SITE_ID    )
			SET @index_PLANT_SITE_ID    = PATINDEX('%' + '^' + '%', @p_PLANT_SITE_ID  )
			SET @index_ITEM_ID          = PATINDEX('%' + '^' + '%', @p_ITEM_ID        )
			SET @index_DOM_EXP          = PATINDEX('%' + '^' + '%', @p_DOM_EXP        )
			SET @index_FCST_TYPE        = PATINDEX('%' + '^' + '%', @p_FCST_TYPE      )
			SET @index_INCOTERMS        = PATINDEX('%' + '^' + '%', @p_INCOTERMS      )
			SET @index_MEASURE          = PATINDEX('%' + '^' + '%', @p_MEASURE        )
			SET @index_YYYYMMDD         = PATINDEX('%' + '^' + '%', @p_YYYYMMDD       )
			SET @index_CURRENCY         = PATINDEX('%' + '^' + '%', @p_CURRENCY       )
			SET @index_QTY              = PATINDEX('%' + '^' + '%', @p_QTY            )
			SET @index_CREATED_BY       = PATINDEX('%' + '^' + '%', @p_CREATED_BY     )
			SET @index_LAST_UPDATED_BY  = PATINDEX('%' + '^' + '%', @p_LAST_UPDATED_BY)
		END
	    -------------------------------------------

		IF @index_DIVISION_ID > 0
	        -------------------------------------------
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

				SET @v_DOM_EXP  = SUBSTRING(@p_DOM_EXP , 0, @index_DOM_EXP )
				SET @p_DOM_EXP  = SUBSTRING(@p_DOM_EXP , LEN(@v_DOM_EXP  + '^') + 1, LEN(@p_DOM_EXP ))

				SET @v_FCST_TYPE  = SUBSTRING(@p_FCST_TYPE , 0, @index_FCST_TYPE )
				SET @p_FCST_TYPE  = SUBSTRING(@p_FCST_TYPE , LEN(@v_FCST_TYPE  + '^') + 1, LEN(@p_FCST_TYPE ))

				SET @v_INCOTERMS  = SUBSTRING(@p_INCOTERMS , 0, @index_INCOTERMS )
				SET @p_INCOTERMS  = SUBSTRING(@p_INCOTERMS , LEN(@v_INCOTERMS  + '^') + 1, LEN(@p_INCOTERMS ))

				SET @v_MEASURE  = SUBSTRING(@p_MEASURE , 0, @index_MEASURE )
				SET @p_MEASURE  = SUBSTRING(@p_MEASURE , LEN(@v_MEASURE  + '^') + 1, LEN(@p_MEASURE ))

				SET @v_YYYYMMDD  = SUBSTRING(@p_YYYYMMDD , 0, @index_YYYYMMDD )
				SET @p_YYYYMMDD  = SUBSTRING(@p_YYYYMMDD , LEN(@v_YYYYMMDD  + '^') + 1, LEN(@p_YYYYMMDD ))

				SET @v_CURRENCY  = SUBSTRING(@p_CURRENCY , 0, @index_CURRENCY )
				SET @p_CURRENCY  = SUBSTRING(@p_CURRENCY , LEN(@v_CURRENCY  + '^') + 1, LEN(@p_CURRENCY ))

				--------------------------  20180319 skh added
				if @p_CURRENCY is null  
				  begin
				    set @p_CURRENCY = ''
				  end
				--------------------------  20180319 skh added


				SET @v_QTY  = SUBSTRING(@p_QTY , 0, @index_QTY )
				SET @p_QTY  = SUBSTRING(@p_QTY , LEN(@v_QTY  + '^') + 1, LEN(@p_QTY ))

				SET @v_CREATED_BY  = SUBSTRING(@p_CREATED_BY , 0, @index_CREATED_BY )
				SET @p_CREATED_BY  = SUBSTRING(@p_CREATED_BY , LEN(@v_CREATED_BY  + '^') + 1, LEN(@p_CREATED_BY ))

				SET @v_LAST_UPDATED_BY  = SUBSTRING(@p_LAST_UPDATED_BY , 0, @index_LAST_UPDATED_BY )
				SET @p_LAST_UPDATED_BY  = SUBSTRING(@p_LAST_UPDATED_BY , LEN(@v_LAST_UPDATED_BY  + '^') + 1, LEN(@p_LAST_UPDATED_BY ))
 
				INSERT INTO TEMP_SALES_PLAN$ ( 
							             v_active_flag    
										,v_DIVISION_ID    
										,v_PROJECT_CODE   
										,v_SCM_SITE_ID    
										,v_PLANT_SITE_ID  
										,v_ITEM_ID        
										,v_DOM_EXP        
										,v_FCST_TYPE      
										,v_INCOTERMS      
										,v_MEASURE        
										,v_YYYYMMDD       
										,v_CURRENCY       
										,v_QTY            
										,v_CREATED_BY     
										,v_LAST_UPDATED_BY
				) VALUES ( 
							             @v_active_flag    
										,@v_DIVISION_ID    
										,@v_PROJECT_CODE   
										,@v_SCM_SITE_ID    
										,@v_PLANT_SITE_ID  
										,@v_ITEM_ID        
										,@v_DOM_EXP        
										,@v_FCST_TYPE      
										,@v_INCOTERMS      
										,@v_MEASURE        
										,@v_YYYYMMDD       
										,@v_CURRENCY       
										,@v_QTY            
										,@v_CREATED_BY     
										,@v_LAST_UPDATED_BY
				)
			END
	        -------------------------------------------
		ELSE
	        -------------------------------------------
			BEGIN
				SET @v_DIVISION_ID = @p_DIVISION_ID
				SET @p_DIVISION_ID = NULL
 
				INSERT INTO TEMP_SALES_PLAN$ ( 
							             v_active_flag    
										,v_DIVISION_ID    
										,v_PROJECT_CODE   
										,v_SCM_SITE_ID    
										,v_PLANT_SITE_ID  
										,v_ITEM_ID        
										,v_DOM_EXP        
										,v_FCST_TYPE      
										,v_INCOTERMS      
										,v_MEASURE        
										,v_YYYYMMDD       
										,v_CURRENCY       
										,v_QTY            
										,v_CREATED_BY     
										,v_LAST_UPDATED_BY
				) VALUES ( 
							             @v_active_flag    
										,@v_DIVISION_ID    
										,@v_PROJECT_CODE   
										,@v_SCM_SITE_ID    
										,@v_PLANT_SITE_ID  
										,@v_ITEM_ID        
										,@v_DOM_EXP        
										,@v_FCST_TYPE      
										,@v_INCOTERMS      
										,@v_MEASURE        
										,@v_YYYYMMDD       
										,@v_CURRENCY       
										,@v_QTY            
										,@v_CREATED_BY     
										,@v_LAST_UPDATED_BY
				)
			END
	        -------------------------------------------

	END
	
	--###############################################   TEMP_SALES_PLAN$ 테이블에 split후 insert (END)
	BEGIN

	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
	       IF (select count(1)  
		         from TEMP_SALES_PLAN$ where 
		                            ( select count(1) from dbo.scm_mst_project WITH(NOLOCK)  
									    where project_code  = v_PROJECT_CODE ) = 0 
										  and v_PROJECT_CODE <> 'N'  --20180423 SKH validation 조건에서 제외시킴
		      ) >0
		   begin
		       SET @v_log_type = 'INVALID';
			   SET @v_log_message = '['+ (SELECT v_PROJECT_CODE 
			                                FROM TEMP_SALES_PLAN$ 
											  WHERE v_PROJECT_CODE NOT IN (
																			SELECT project_code 
																			  FROM dbo.scm_mst_project WITH(NOLOCK))
										 ) +']'+ N' Invalid Project Code !';
			   SELECT @v_log_message
			   goto err_rtn
		   end
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------

	       ------------------------------------------------------------- delete START
		    BEGIN
				(select @n_del_count = COUNT(1) from TEMP_SALES_PLAN$ where v_active_flag  = 'D');
		    END

		    BEGIN
				
				DELETE 
				FROM [dbo].DM_PLN_SALES_PLAN
				WHERE (
						SELECT count(1) 
							FROM TEMP_SALES_PLAN$ 
							where 1=1
							--AND v_active_flag  = 'D' 
							and DM_PLN_SALES_PLAN.DIVISION_ID      =   v_DIVISION_ID        
							AND DM_PLN_SALES_PLAN.PROJECT_CODE     =   v_PROJECT_CODE     
							AND DM_PLN_SALES_PLAN.SCM_SITE_ID      =   v_SCM_SITE_ID  
							AND DM_PLN_SALES_PLAN.PLANT_SITE_ID    =   v_PLANT_SITE_ID
							AND DM_PLN_SALES_PLAN.ITEM_ID          =   v_ITEM_ID      
							AND DM_PLN_SALES_PLAN.DOM_EXP          =   v_DOM_EXP      
							AND DM_PLN_SALES_PLAN.FCST_TYPE        =   v_FCST_TYPE    
							AND DM_PLN_SALES_PLAN.INCOTERMS        =   v_INCOTERMS    
							--AND DM_PLN_SALES_PLAN.MEASURE          =   v_MEASURE      
							AND DM_PLN_SALES_PLAN.YYYYMMDD         =   v_YYYYMMDD      
							--AND v_MEASURE NOT IN ('SalesAmt_LOC')
							-- MKT FCST 와 RTF는 삭제하면 안됨.
							AND DM_PLN_SALES_PLAN.MEASURE NOT IN ( 'MKT_FCST', 'RTF' )
						) > 0;
		    END
	    ------------------------------------------------------------- delete END

		    BEGIN
				
		-------------------------------------------------------------  KRW insert
				INSERT  INTO  TEMP_SALES_PLAN$
				select 
					 v_active_flag
					,v_DIVISION_ID
					,v_PROJECT_CODE
					,v_SCM_SITE_ID
					,v_PLANT_SITE_ID
					,v_ITEM_ID
					,v_DOM_EXP
					,v_FCST_TYPE
					,v_INCOTERMS
					,'SalesAmt_KRW' AS v_MEASURE
					,v_YYYYMMDD
					,v_CURRENCY
					, (SELECT 
					    CASE WHEN tmp.v_CURRENCY = 'KRW' 
						  THEN tmp.v_QTY
						  ELSE
					    CASE WHEN tmp.v_CURRENCY = 'USD' 
						  THEN ISNULL(tmp.v_QTY * (SELECT EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE where DIVISION_ID = tmp.v_DIVISION_ID  
			                   AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0) 
						  ELSE
					    CASE WHEN tmp.v_CURRENCY NOT IN ('KRW','USD')
						  THEN ISNULL(tmp.v_QTY * (SELECT EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE where DIVISION_ID = tmp.v_DIVISION_ID  
			                   AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01' AND UNIT_CURRENCY = tmp.v_CURRENCY GROUP BY EXCHANGE_PRICE),0) 
						  END
						  END
						  END
					  )
					,v_CREATED_BY
					,v_LAST_UPDATED_BY
					 from  TEMP_SALES_PLAN$ tmp   
					  where tmp.v_MEASURE = 'SalesAmt_LOC' and v_active_flag  <> 'D'

		-------------------------------------------------------------  USD insert
				INSERT  INTO  TEMP_SALES_PLAN$
				select 
					 v_active_flag
					,v_DIVISION_ID
					,v_PROJECT_CODE
					,v_SCM_SITE_ID
					,v_PLANT_SITE_ID
					,v_ITEM_ID
					,v_DOM_EXP
					,v_FCST_TYPE
					,v_INCOTERMS
					,'SalesAmt_USD' AS v_MEASURE
					,v_YYYYMMDD
					,v_CURRENCY
					,v_QTY = (SELECT 
					    CASE WHEN tmp.v_CURRENCY = 'KRW' 
						  THEN ISNULL(tmp.v_QTY / (SELECT EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE where DIVISION_ID = tmp.v_DIVISION_ID  
			                   AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0) 
						  ELSE
					    CASE WHEN tmp.v_CURRENCY = 'USD' 
						  THEN tmp.v_QTY 
						  ELSE
					    CASE WHEN tmp.v_CURRENCY NOT IN ('KRW','USD')   -- KRW산출후 / USD
						  THEN ISNULL(tmp.v_QTY * (SELECT EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE where DIVISION_ID = tmp.v_DIVISION_ID  
			                   AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01' AND UNIT_CURRENCY = tmp.v_CURRENCY GROUP BY EXCHANGE_PRICE),0)
							   / (SELECT EXCHANGE_PRICE FROM dbo.DM_MST_EXCHANGE_RATE where DIVISION_ID = tmp.v_DIVISION_ID  
			                   AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE)
						  END
						  END
						  END
					  )
					,v_CREATED_BY
					,v_LAST_UPDATED_BY
					 from  TEMP_SALES_PLAN$ tmp
					  where tmp.v_MEASURE = 'SalesAmt_LOC' and v_active_flag  <> 'D'


		    END

			BEGIN
				(select @n_insert_count = COUNT(1) from TEMP_SALES_PLAN$ where v_MEASURE = 'SalesAmt_LOC')
			END

			BEGIN
			  INSERT INTO DM_PLN_SALES_PLAN
			    ( 
					 DIVISION_ID
					,PROJECT_CODE
					,SCM_SITE_ID
					,PLANT_SITE_ID
					,ITEM_ID
					,DOM_EXP
					,FCST_TYPE
					,INCOTERMS
					,MEASURE
					,YYYYMMDD
					,CURRENCY
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
				SELECT 	 v_DIVISION_ID    
						,v_PROJECT_CODE   
						,v_SCM_SITE_ID    
						,v_PLANT_SITE_ID  
						,v_ITEM_ID        
						,v_DOM_EXP        
						,v_FCST_TYPE      
						,v_INCOTERMS      
						,v_MEASURE        
						,v_YYYYMMDD       
						,v_CURRENCY       
						,v_QTY            
						,v_CREATED_BY 
						,GETDATE()    
						,v_LAST_UPDATED_BY
						,GETDATE()  ,NULL  ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
						FROM TEMP_SALES_PLAN$  where 1=1
						and v_active_flag  <> 'D'

			-------------------------------------------------------------------
			/* [2018-03-19][CURSOR를 이용해 HISTORY TABLE ADD 
				방법1 : PROCEDURE CALL
				방법2 : 바로입력 
			*/
			-------------------------------------------------------------------
				-- 커서를 이용해 DIVISION_ID 만큼 LOOP
				DECLARE DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_CUR CURSOR FAST_FORWARD FOR
																	SELECT 	 v_DIVISION_ID    
																			,v_PROJECT_CODE   
																			,v_SCM_SITE_ID    
																			,v_PLANT_SITE_ID  
																			,v_ITEM_ID        
																			,v_DOM_EXP        
																			,v_FCST_TYPE      
																			,v_INCOTERMS      
																			,v_MEASURE        
																			,v_YYYYMMDD       
																			,v_CURRENCY       
																			,v_QTY      
																			,v_CREATED_BY
																			,v_LAST_UPDATED_BY   
																	  FROM	TEMP_SALES_PLAN$  
																	 WHERE  1=1
															--		   AND	V_ACTIVE_FLAG  <> 'D'
												  
				OPEN DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_CUR
				FETCH NEXT FROM DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_CUR INTO	 @v_DIVISION_ID    
																			,@v_PROJECT_CODE   
																			,@v_SCM_SITE_ID    
																			,@v_PLANT_SITE_ID  
																			,@v_ITEM_ID        
																			,@v_DOM_EXP        
																			,@v_FCST_TYPE      
																			,@v_INCOTERMS      
																			,@v_MEASURE        
																			,@v_YYYYMMDD       
																			,@v_CURRENCY       
																			,@v_QTY     
																			,@v_CREATED_BY    
																			,@v_LAST_UPDATED_BY


				WHILE @@FETCH_STATUS = 0
				BEGIN

						SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_PLN_SALES_PLAN_H

						-- HISTORY INSERT
						INSERT INTO DM_PLN_SALES_PLAN_H
									( 
										DIVISION_ID			,HISTORY_SEQ	,PROJECT_CODE		,SCM_SITE_ID	
										,PLANT_SITE_ID		,ITEM_ID		,DOM_EXP			,FCST_TYPE		
										,INCOTERMS			,MEASURE		,YYYYMMDD			,CURRENCY				,QTY
										,CREATED_BY			,CREATION_DATE	,LAST_UPDATED_BY	,LAST_UPDATE_DATE
									)
								VALUES
									(
										 @v_DIVISION_ID		,@n_history_seq	,@v_PROJECT_CODE	,@v_SCM_SITE_ID    
										,@v_PLANT_SITE_ID   ,@v_ITEM_ID     ,@v_DOM_EXP			,@v_FCST_TYPE      
										,@v_INCOTERMS		,@v_MEASURE		,@v_YYYYMMDD		,@v_CURRENCY			,@v_QTY            
										,@v_CREATED_BY		,GETDATE()		,@v_LAST_UPDATED_BY	,GETDATE()
									);

						FETCH NEXT FROM DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_CUR INTO	 @v_DIVISION_ID    
																					,@v_PROJECT_CODE   
																					,@v_SCM_SITE_ID    
																					,@v_PLANT_SITE_ID  
																					,@v_ITEM_ID        
																					,@v_DOM_EXP        
																					,@v_FCST_TYPE      
																					,@v_INCOTERMS      
																					,@v_MEASURE        
																					,@v_YYYYMMDD       
																					,@v_CURRENCY       
																					,@v_QTY     
																					,@v_CREATED_BY    
																					,@v_LAST_UPDATED_BY
				END

				CLOSE DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_CUR
				DEALLOCATE DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_CUR
			END

		-------------------------------------------------------------  insert (END)

	END


  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
      -- ROLLBACK
	  -- 트랜잭션 (END)
	  ROLLBACK TRANSACTION SAVE_DM_PLN_SALES_PLAN_ALL;
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/


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
    SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) +  ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
	-- 트랜잭션 (END)
	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION;
			SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) +  ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
