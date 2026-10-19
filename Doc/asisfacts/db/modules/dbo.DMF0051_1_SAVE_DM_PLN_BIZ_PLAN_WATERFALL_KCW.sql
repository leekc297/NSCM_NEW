/*@i
 * Program ID   : DMF0051_1_SAVE_DM_PLN_BIZ_PLAN_WATERFALL
 * Description  : Business Plan ('DM_PLN_BIZ_PLAN_WATERFALL' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/19	CHANO0612	사업계획 프로젝트
 * 2024/02/19	kcw3408  	사업계획 개선 프로젝트(저장시 템프사용하여 저장)

  exec DMF0051_1_SAVE_DM_PLN_BIZ_PLAN_WATERFALL SUPPLY @p_active_flag=N'M',@p_project_code=N'A22AI4001',@p_yyyymm=N'202310',@p_cust_fcst_m=N'270',
 @p_measure=N'DP_INIT',@p_qtycd1=N'COMPANY',@p_qtycd2=N'SUPPLY',@p_qtycd3=N'SUPPLYISSUE',@p_seq=N'1',@p_qty=N'15000',@p_mkt_fcst_m=N'0',
 @p_desc=N'eeeee',@p_input_limit=N'',@p_created_by=N'chutoc730'
 */ 
CREATE PROCEDURE [dbo].[DMF0051_1_SAVE_DM_PLN_BIZ_PLAN_WATERFALL_KCW]

    @p_active_flag           NVARCHAR(MAX),
	@p_DIVISION_ID           NVARCHAR(MAX), -- PK
	@p_VERSION_NO            NVARCHAR(MAX), -- PK
	@p_PROJECT_CODE          NVARCHAR(MAX), -- PK
	@p_SCM_SITE_ID           NVARCHAR(MAX), -- PK
	@p_END_CUSTOMER          NVARCHAR(MAX), -- PK
	@p_PLANT_SITE_ID         NVARCHAR(MAX), -- PK
 	@p_ITEM_ID               NVARCHAR(MAX), -- PK
	@p_DOM_EXP               NVARCHAR(MAX), -- PK
	@p_FCST_TYPE             NVARCHAR(MAX), -- PK
	@p_INCOTERMS             NVARCHAR(MAX), -- PK
	@p_MEASURE               NVARCHAR(MAX), -- PK
	@p_YYYYMM                NVARCHAR(MAX), -- PK
	@p_QTY                   NVARCHAR(MAX),

	@p_DEPT_ID               NVARCHAR(MAX),
	@p_BIZ_TYPE              NVARCHAR(MAX),
	@p_CELL_PROD_SITE        NVARCHAR(MAX), -- PK	
	@p_CURRENCY              NVARCHAR(MAX),
    @p_CREATED_BY            NVARCHAR(MAX),
    @p_LAST_UPDATED_BY       NVARCHAR(MAX)



AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- 스플릿관련 변수
    DECLARE  @v_active_flag           NVARCHAR(MAX);	
	DECLARE  @v_DIVISION_ID           NVARCHAR(MAX); -- PK
	DECLARE  @v_VERSION_NO            NVARCHAR(MAX); -- PK
	DECLARE  @v_PROJECT_CODE          NVARCHAR(MAX); -- PK
	DECLARE  @v_SCM_SITE_ID           NVARCHAR(MAX); -- PK
	DECLARE  @v_END_CUSTOMER          NVARCHAR(MAX); -- PK
	DECLARE  @v_PLANT_SITE_ID         NVARCHAR(MAX); -- PK
	DECLARE  @v_ITEM_ID               NVARCHAR(MAX); -- PK
	DECLARE  @v_DOM_EXP               NVARCHAR(MAX); -- PK
	DECLARE  @v_FCST_TYPE             NVARCHAR(MAX); -- PK
	DECLARE  @v_INCOTERMS             NVARCHAR(MAX); -- PK
	DECLARE  @v_MEASURE               NVARCHAR(MAX); -- PK
	DECLARE  @v_YYYYMM                NVARCHAR(MAX); -- PK
	DECLARE  @v_QTY                   NVARCHAR(MAX);
	DECLARE  @v_DEPT_ID               NVARCHAR(MAX);
	DECLARE  @v_BIZ_TYPE              NVARCHAR(MAX);
	DECLARE  @v_CELL_PROD_SITE		  NVARCHAR(MAX);
	DECLARE  @v_CURRENCY              NVARCHAR(MAX);
	DECLARE  @v_CREATED_BY            NVARCHAR(MAX);
	DECLARE  @v_LAST_UPDATED_BY       NVARCHAR(MAX);
	
	DECLARE  @QTY				      NUMERIC(30,10); 
	
	DECLARE @_CNT					  NVARCHAR(3);
	DECLARE @C_CNT					  INT;
	DECLARE @i						  INT;
	DECLARE @CNT					  INT;
	DECLARE @DUP_CNT				  INT;
	DECLARE @R_CNT				      INT;
	DECLARE @R  				      INT;

	DECLARE @SUM_QT				  NUMERIC(30,10)
	DECLARE @SUM_QTY				  NUMERIC(30,10)

	DECLARE @R1_QTY					  NUMERIC(30,10)
	DECLARE @R2_QTY					  NUMERIC(30,10)
	DECLARE @R3_QTY					  NUMERIC(30,10)
	DECLARE @R4_QTY					  NUMERIC(30,10)
	DECLARE @R5_QTY					  NUMERIC(30,10)
	DECLARE @R_SUM					  NUMERIC(30,10)

	DECLARE @TOTAL_PRICE			  NUMERIC(30,10)
	
	DECLARE @R1_RATIO				  FLOAT
	DECLARE @R2_RATIO				  FLOAT
	DECLARE @R3_RATIO				  FLOAT
	DECLARE @R4_RATIO				  FLOAT
	DECLARE @R5_RATIO				  FLOAT

	DECLARE @V1_QTY					  NUMERIC(30,10)
	DECLARE @V2_QTY					  NUMERIC(30,10)
	DECLARE @V3_QTY					  NUMERIC(30,10)
	DECLARE @V4_QTY					  NUMERIC(30,10)
	DECLARE @V5_QTY					  NUMERIC(30,10)
	DECLARE @V_SUM					  NUMERIC(30,10)

	DECLARE @REMAIN					  NUMERIC(30,10)

	DECLARE @v_Business_Plan_Conf  	  NUMERIC(30,10)
	DECLARE @v_BizPlanPrice_Cur		  NUMERIC(30,10)
	DECLARE @v_BizPlanPrice_KRW		  NUMERIC(30,10)	 
	
	DECLARE  @v_CUTOFF_TYPE           NVARCHAR(MAX);

	DECLARE @sql_INS				  NVARCHAR(MAX);
	DECLARE @sql_CHK				  NVARCHAR(MAX);
	DECLARE @sql_BPC				  NVARCHAR(MAX);
	DECLARE @sql_BPP				  NVARCHAR(MAX);
	DECLARE @sql_BPA				  NVARCHAR(MAX);
	DECLARE @sql_BCK				  NVARCHAR(MAX);
	DECLARE @sql_BizPlanPrice_Cur     NVARCHAR(MAX);
	DECLARE @sql_PCK				  NVARCHAR(MAX);
	DECLARE @sql_TOT				  NVARCHAR(MAX);

	
    PRINT ( 'A1--#TEMP_RESULTS   ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

	IF OBJECT_ID(N'tempdb..#TEMP_RESULTS', N'U') IS NOT NULL DROP TABLE #TEMP_RESULTS	 

    CREATE TABLE #TEMP_RESULTS (
			 v_active_flag           NVARCHAR(MAX)
			,v_DIVISION_ID           NVARCHAR(MAX)
			,v_VERSION_NO            NVARCHAR(MAX)
			,v_PROJECT_CODE          NVARCHAR(MAX)
			,v_SCM_SITE_ID           NVARCHAR(MAX)
			,v_END_CUSTOMER          NVARCHAR(MAX)
			,v_PLANT_SITE_ID         NVARCHAR(MAX)
			,v_ITEM_ID               NVARCHAR(MAX)
			,v_DOM_EXP               NVARCHAR(MAX)
			,v_FCST_TYPE             NVARCHAR(MAX)
			,v_INCOTERMS             NVARCHAR(MAX)
			,v_MEASURE               NVARCHAR(MAX)
			,v_YYYYMM                NVARCHAR(MAX)
			,v_QTY                   NVARCHAR(MAX)
			,v_DEPT_ID               NVARCHAR(MAX)
			,v_BIZ_TYPE              NVARCHAR(MAX)
			,v_CELL_PROD_SITE		 NVARCHAR(MAX)
			,v_CURRENCY              NVARCHAR(MAX)
			,v_CREATED_BY            NVARCHAR(MAX)
			,v_LAST_UPDATED_BY       NVARCHAR(MAX)
			,v_CNT                   INTEGER
			)

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0051_1_SAVE_DM_PLN_BP_FCST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date DATETIME;
    DECLARE @n_del_count    INTEGER = 0;
    DECLARE @n_insert_count    INTEGER = 0;

    -- SEQUENCE
    DECLARE @n_history_seq      INTEGER;

	SET @p_SCM_SITE_ID = REPLACE(@p_SCM_SITE_ID, '^^', '^')
   PRINT CONVERT(NVARCHAR(300), @p_PROJECT_CODE)
    -- 마지막 데이터 처리를 위한 구분자 추가
    SET @p_active_flag            = RTRIM(@p_active_flag       ) + '^';
	SET @p_DIVISION_ID            = RTRIM(@p_DIVISION_ID       ) + '^'; -- PK
	SET @p_VERSION_NO             = RTRIM(@p_VERSION_NO        ) + '^'; -- PK
	SET @p_SCM_SITE_ID            = RTRIM(@p_SCM_SITE_ID       ) + '^'; -- PK
	SET @p_END_CUSTOMER           = RTRIM(@p_END_CUSTOMER      ) + '^';
	SET @p_PROJECT_CODE           = RTRIM(@p_PROJECT_CODE      ) + '^'; -- PK
	SET @p_ITEM_ID                = RTRIM(@p_ITEM_ID           ) + '^'; -- PK
	SET @p_CURRENCY               = RTRIM(@p_CURRENCY          ) + '^';
	SET @p_PLANT_SITE_ID          = RTRIM(@p_PLANT_SITE_ID     ) + '^'; -- PK
	SET @p_FCST_TYPE              = RTRIM(@p_FCST_TYPE         ) + '^'; -- PK
	SET @p_DOM_EXP                = RTRIM(@p_DOM_EXP           ) + '^'; -- PK
	SET @p_INCOTERMS              = RTRIM(@p_INCOTERMS         ) + '^'; -- PK

	SET @p_CELL_PROD_SITE         = RTRIM(@p_CELL_PROD_SITE   ) + '^'; -- PK
	SET @p_MEASURE                = RTRIM(@p_MEASURE           ) + '^'; -- PK
	SET @p_YYYYMM                 = RTRIM(@p_YYYYMM            ) + '^'; -- PK
	SET @p_QTY                    = RTRIM(@p_QTY               ) + '^';

	SET @p_DEPT_ID                = RTRIM(@p_DEPT_ID           ) + '^';
	SET @p_BIZ_TYPE               = RTRIM(@p_BIZ_TYPE          ) + '^';

    SET @p_CREATED_BY             = RTRIM(@p_CREATED_BY        ) + '^';
    SET @p_LAST_UPDATED_BY        = RTRIM(@p_LAST_UPDATED_BY   ) + '^';



    -- 시작 LOG  (START)
        SET @v_log_type = 'START';
        SET @v_log_message = '########## Start of procedure ##########';
        SET @v_description = '';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
        -- 시작 LOG  (END)

        -- 트랜잭션 (START)
        BEGIN TRANSACTION SAVE_DM_PLN_BP_FCST;

    --------------------------------------------------------------------------------------------
        BEGIN TRY
    -------------------------------------------------------------------------------------------- 

	DECLARE @ROW_COUNT INT
	SELECT @ROW_COUNT = COUNT(*) FROM STRING_SPLIT(@p_active_flag,'^')
	
		IF @p_DIVISION_ID = '^' 
		BEGIN
			SET @v_log_type = 'INVALID';

			SELECT N'입력값을 확인하세요.'

			SET @v_description = N'필수 입력값을 확인하세요.'

			GOTO err_rtn
		END  
	  

	 
    WHILE LEN(@p_DIVISION_ID) > 0
    --###############################################  #TEMP_BP_FCST_C 테이블에 split후 insert (START)
    BEGIN
        -------------------------------------------
        BEGIN
   
			DECLARE  @index_active_flag          INT
			DECLARE  @index_DIVISION_ID          INT -- PK
			DECLARE  @index_VERSION_NO           INT -- PK
			DECLARE  @index_SCM_SITE_ID          INT -- PK
			DECLARE  @index_END_CUSTOMER         INT
			DECLARE  @index_PROJECT_CODE         INT -- PK
			DECLARE  @index_ITEM_ID              INT -- PK
			DECLARE  @index_CURRENCY             INT
			DECLARE  @index_PLANT_SITE_ID        INT -- PK
			DECLARE  @index_FCST_TYPE            INT -- PK
			DECLARE  @index_DOM_EXP              INT -- PK
			DECLARE  @index_INCOTERMS            INT -- PK
			DECLARE  @index_CELL_PROD_SITE       INT
			DECLARE  @index_MEASURE              INT -- PK
			DECLARE  @index_YYYYMM               INT -- PK
			DECLARE  @index_QTY                  INT
			DECLARE  @index_DEPT_ID              INT
			DECLARE  @index_BIZ_TYPE             INT
			DECLARE  @index_CREATED_BY           INT
			DECLARE  @index_LAST_UPDATED_BY      INT
			
			SET @index_active_flag          = PATINDEX('%' + '^' + '%', @p_active_flag        )
			SET @index_DIVISION_ID          = PATINDEX('%' + '^' + '%', @p_DIVISION_ID        ) -- PK
			SET @index_VERSION_NO           = PATINDEX('%' + '^' + '%', @p_VERSION_NO         ) -- PK
			SET @index_SCM_SITE_ID          = PATINDEX('%' + '^' + '%', @p_SCM_SITE_ID        ) -- PK
			SET @index_END_CUSTOMER         = PATINDEX('%' + '^' + '%', @p_END_CUSTOMER       )
			SET @index_PROJECT_CODE         = PATINDEX('%' + '^' + '%', @p_PROJECT_CODE       ) -- PK
			SET @index_ITEM_ID              = PATINDEX('%' + '^' + '%', @p_ITEM_ID            ) -- PK
			SET @index_CURRENCY             = PATINDEX('%' + '^' + '%', @p_CURRENCY           )
			SET @index_PLANT_SITE_ID        = PATINDEX('%' + '^' + '%', @p_PLANT_SITE_ID      ) -- PK
			SET @index_FCST_TYPE            = PATINDEX('%' + '^' + '%', @p_FCST_TYPE          ) -- PK
			SET @index_DOM_EXP              = PATINDEX('%' + '^' + '%', @p_DOM_EXP            ) -- PK
			SET @index_INCOTERMS            = PATINDEX('%' + '^' + '%', @p_INCOTERMS          ) -- PK
			SET @index_CELL_PROD_SITE       = PATINDEX('%' + '^' + '%', @p_CELL_PROD_SITE     ) -- PK
			SET @index_MEASURE              = PATINDEX('%' + '^' + '%', @p_MEASURE            ) -- PK
			SET @index_YYYYMM               = PATINDEX('%' + '^' + '%', @p_YYYYMM             ) -- PK
			SET @index_QTY                  = PATINDEX('%' + '^' + '%', @p_QTY                )
			SET @index_DEPT_ID              = PATINDEX('%' + '^' + '%', @p_DEPT_ID            )
			SET @index_BIZ_TYPE             = PATINDEX('%' + '^' + '%', @p_BIZ_TYPE           )
			SET @index_CREATED_BY           = PATINDEX('%' + '^' + '%', @p_CREATED_BY         )
			SET @index_LAST_UPDATED_BY      = PATINDEX('%' + '^' + '%', @p_LAST_UPDATED_BY    )

        END 


        IF @index_DIVISION_ID > 0
            -------------------------------------------
            BEGIN 
			
                SET @v_active_flag = SUBSTRING(@p_active_flag, 0, @index_active_flag)
                SET @p_active_flag = SUBSTRING(@p_active_flag, LEN(@v_active_flag + '^') + 1, LEN(@p_active_flag))

                SET @v_DIVISION_ID        = SUBSTRING(@p_DIVISION_ID       , 0, @index_DIVISION_ID       )
				SET @p_DIVISION_ID        = SUBSTRING(@p_DIVISION_ID       , LEN(@v_DIVISION_ID        + '^') + 1, LEN(@p_DIVISION_ID       ))

				SET @v_VERSION_NO         = SUBSTRING(@p_VERSION_NO        , 0, @index_VERSION_NO       )
				SET @p_VERSION_NO         = SUBSTRING(@p_VERSION_NO        , LEN(@v_VERSION_NO        + '^') + 1, LEN(@p_VERSION_NO       )) 

				SET @v_SCM_SITE_ID        = SUBSTRING(@p_SCM_SITE_ID       , 0, @index_SCM_SITE_ID       )
				SET @p_SCM_SITE_ID        = SUBSTRING(@p_SCM_SITE_ID       , LEN(@v_SCM_SITE_ID        + '^') + 1, LEN(@p_SCM_SITE_ID       ))

				SET @v_END_CUSTOMER       = SUBSTRING(@p_END_CUSTOMER      , 0, @index_END_CUSTOMER      )
				SET @p_END_CUSTOMER       = SUBSTRING(@p_END_CUSTOMER      , LEN(@v_END_CUSTOMER       + '^') + 1, LEN(@p_END_CUSTOMER      ))

				SET @v_PROJECT_CODE       = SUBSTRING(@p_PROJECT_CODE      , 0, @index_PROJECT_CODE      )
				SET @p_PROJECT_CODE       = SUBSTRING(@p_PROJECT_CODE      , LEN(@v_PROJECT_CODE       + '^') + 1, LEN(@p_PROJECT_CODE      ))
				
				SET @v_ITEM_ID            = SUBSTRING(@p_ITEM_ID           , 0, @index_ITEM_ID           )
				SET @p_ITEM_ID            = SUBSTRING(@p_ITEM_ID           , LEN(@v_ITEM_ID            + '^') + 1, LEN(@p_ITEM_ID           ))

				SET @v_CURRENCY           = SUBSTRING(@p_CURRENCY          , 0, @index_CURRENCY          )
				SET @p_CURRENCY           = SUBSTRING(@p_CURRENCY          , LEN(@v_CURRENCY           + '^') + 1, LEN(@p_CURRENCY          ))

				SET @v_PLANT_SITE_ID      = SUBSTRING(@p_PLANT_SITE_ID     , 0, @index_PLANT_SITE_ID     ) 
				SET @p_PLANT_SITE_ID      = SUBSTRING(@p_PLANT_SITE_ID     , LEN(@v_PLANT_SITE_ID       + '^') + 1, LEN(@p_PLANT_SITE_ID    ))

				SET @v_FCST_TYPE          = SUBSTRING(@p_FCST_TYPE         , 0, @index_FCST_TYPE         ) 
				SET @p_FCST_TYPE          = SUBSTRING(@p_FCST_TYPE         , LEN(@v_FCST_TYPE           + '^') + 1, LEN(@p_FCST_TYPE        ))

				SET @v_DOM_EXP            = SUBSTRING(@p_DOM_EXP           , 0, @index_DOM_EXP           ) 
				SET @p_DOM_EXP            = SUBSTRING(@p_DOM_EXP           , LEN(@v_DOM_EXP            + '^') + 1, LEN(@p_DOM_EXP           ))

				SET @v_INCOTERMS          = SUBSTRING(@p_INCOTERMS         , 0, @index_INCOTERMS         ) 
				SET @p_INCOTERMS          = SUBSTRING(@p_INCOTERMS         , LEN(@v_INCOTERMS          + '^') + 1, LEN(@p_INCOTERMS         ))

				SET @v_CELL_PROD_SITE            = SUBSTRING(@p_CELL_PROD_SITE           , 0, @index_CELL_PROD_SITE          ) 
				SET @p_CELL_PROD_SITE            = SUBSTRING(@p_CELL_PROD_SITE           , LEN(@v_CELL_PROD_SITE            + '^') + 1, LEN(@p_CELL_PROD_SITE           ))

				SET @v_MEASURE            = SUBSTRING(@p_MEASURE           , 0, @index_MEASURE           ) 
				SET @p_MEASURE            = SUBSTRING(@p_MEASURE           , LEN(@v_MEASURE            + '^') + 1, LEN(@p_MEASURE           )) 

				SET @v_YYYYMM             = SUBSTRING(@p_YYYYMM            , 0, @index_YYYYMM            ) 
				SET @p_YYYYMM             = SUBSTRING(@p_YYYYMM            , LEN(@v_YYYYMM             + '^') + 1, LEN(@p_YYYYMM            ))

				SET @v_QTY                = SUBSTRING(@p_QTY               , 0, @index_QTY               ) 
				SET @p_QTY                = SUBSTRING(@p_QTY               , LEN(@v_QTY                + '^') + 1, LEN(@p_QTY               ))

				SET @v_DEPT_ID            = SUBSTRING(@p_DEPT_ID           , 0, @index_DEPT_ID           ) 
				SET @p_DEPT_ID            = SUBSTRING(@p_DEPT_ID           , LEN(@v_DEPT_ID            + '^') + 1, LEN(@p_DEPT_ID               ))

				SET @v_BIZ_TYPE           = SUBSTRING(@p_BIZ_TYPE          , 0, @index_BIZ_TYPE           ) 
				SET @p_BIZ_TYPE           = SUBSTRING(@p_BIZ_TYPE          , LEN(@v_BIZ_TYPE           + '^') + 1, LEN(@p_BIZ_TYPE               ))
				 
                SET @v_CREATED_BY  = SUBSTRING(@p_CREATED_BY , 0, @index_CREATED_BY )
				SET @p_CREATED_BY  = SUBSTRING(@p_CREATED_BY , LEN(@v_CREATED_BY  + '^') + 1, LEN(@p_CREATED_BY ))

                SET @v_LAST_UPDATED_BY  = SUBSTRING(@p_LAST_UPDATED_BY , 0, @index_LAST_UPDATED_BY )
                SET @p_LAST_UPDATED_BY  = SUBSTRING(@p_LAST_UPDATED_BY , LEN(@v_LAST_UPDATED_BY  + '^') + 1, LEN(@p_LAST_UPDATED_BY ))

				SET @v_CELL_PROD_SITE = REPLACE(@v_CELL_PROD_SITE, '^', '')
				IF (@v_CELL_PROD_SITE = '')
				BEGIN
					SET @v_CELL_PROD_SITE = '-'
				END
				IF (@v_DIVISION_ID = '40')
				BEGIN
					SET @v_END_CUSTOMER = '-'
				END 				 
	
               IF @index_DIVISION_ID > 1 
                  BEGIN 
					   INSERT INTO #TEMP_RESULTS (   
							 v_active_flag           
							,v_DIVISION_ID           
							,v_VERSION_NO            
							,v_PROJECT_CODE          
							,v_SCM_SITE_ID           
							,v_END_CUSTOMER          
							,v_PLANT_SITE_ID         
							,v_ITEM_ID               
							,v_DOM_EXP               
							,v_FCST_TYPE             
							,v_INCOTERMS             
							,v_MEASURE               
							,v_YYYYMM                
							,v_QTY                   
							,v_DEPT_ID               
							,v_BIZ_TYPE              
							,v_CELL_PROD_SITE		 
							,v_CURRENCY              
							,v_CREATED_BY            
							,v_LAST_UPDATED_BY   
							,v_CNT
					   ) VALUES ( 
							 @v_active_flag           	
							,@v_DIVISION_ID           
							,@v_VERSION_NO            
							,@v_PROJECT_CODE          
							,@v_SCM_SITE_ID           
							,@v_END_CUSTOMER          
							,@v_PLANT_SITE_ID         
							,@v_ITEM_ID               
							,@v_DOM_EXP               
							,@v_FCST_TYPE             
							,@v_INCOTERMS             
							,@v_MEASURE               
							,@v_YYYYMM                
							,@v_QTY                   
							,@v_DEPT_ID               
							,@v_BIZ_TYPE              
							,@v_CELL_PROD_SITE		  
							,@v_CURRENCY              
							,@v_CREATED_BY            
							,@v_LAST_UPDATED_BY          
							,0          
					   )  
                  END  

            END  
    END
	     
    PRINT ( 'A2_1--##TEMP_RESULTS  CNT ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

	/* 대상건 있으면 처리 */
    IF EXISTS (SELECT 1
    			 FROM #TEMP_RESULTS WITH (NOLOCK)  
              )
    BEGIN 
	
	
        IF OBJECT_ID(N'tempdb..#TEMP_DM_PLN_BIZPLAN_C', N'U') IS NOT NULL	DROP TABLE #TEMP_DM_PLN_BIZPLAN_C
        IF OBJECT_ID(N'tempdb..#TEMP_RESULTS_DISTINCT', N'U') IS NOT NULL	DROP TABLE #TEMP_RESULTS_DISTINCT
		/*
		  대상데이타 템프저장
		*/   
		BEGIN
		    SELECT A.* 
			     , 'S' AS CRUD_CD
		      INTO #TEMP_DM_PLN_BIZPLAN_C 
			  FROM (SELECT DISTINCT 
			               v_DIVISION_ID
			             , v_VERSION_NO 
			             , v_PLANT_SITE_ID
			             , v_ITEM_ID
			          FROM #TEMP_RESULTS  WITH(NOLOCK)
				   ) B 
				 , DM_PLN_BIZPLAN_C A WITH(NOLOCK)  
			  WHERE A.DIVISION_ID   =  B.v_DIVISION_ID
				AND A.VERSION_NO    =  B.v_VERSION_NO   
				AND A.PLANT_SITE_ID = B.v_PLANT_SITE_ID 
				AND A.ITEM_ID       = B.v_ITEM_ID   
		END
   
        PRINT ( 'A3--##TEMP_RESULTS  CNT ' + CONVERT(NVARCHAR(30), GETDATE(), 121))
		  
		/*
		  건수체크/중복제거용 파일생성
		*/
		BEGIN
			UPDATE B 
			   SET v_CNT = v_CNT + 1 
			  FROM #TEMP_RESULTS  B 
				 , #TEMP_DM_PLN_BIZPLAN_C A WITH(NOLOCK)  
			  WHERE A.DIVISION_ID =  B.v_DIVISION_ID
				AND A.VERSION_NO  =  B.v_VERSION_NO 
				AND A.PROJECT_CODE = CASE WHEN (B.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  B.v_PROJECT_CODE  END 
				AND A.END_CUSTOMER = B.v_END_CUSTOMER
				AND A.SCM_SITE_ID = B.v_SCM_SITE_ID 
				AND A.PLANT_SITE_ID = B.v_PLANT_SITE_ID 
				AND A.ITEM_ID = B.v_ITEM_ID 
				AND A.FCST_TYPE = B.v_FCST_TYPE 
				AND A.DOM_EXP = B.v_DOM_EXP 
				AND A.INCOTERMS = B.v_INCOTERMS 
				AND A.CURRENCY = B.v_CURRENCY  
				AND A.MEASURE      = B.v_MEASURE
				AND A.YYYYMM       = B.v_YYYYMM
				AND A.CELL_PROD_SITE = B.v_CELL_PROD_SITE			
			 
			SELECT	 DISTINCT 			       
					 v_DIVISION_ID           
					,v_VERSION_NO            
					,v_PROJECT_CODE          
					,v_SCM_SITE_ID           
					,v_END_CUSTOMER          
					,v_PLANT_SITE_ID         
					,v_ITEM_ID               
					,v_DOM_EXP               
					,v_FCST_TYPE             
					,v_INCOTERMS          
					,v_YYYYMM 
					,v_BIZ_TYPE              
					,v_CELL_PROD_SITE		 
					,v_CURRENCY              
					,v_CREATED_BY            
					,v_LAST_UPDATED_BY    
			  INTO #TEMP_RESULTS_DISTINCT   
			  FROM #TEMP_RESULTS WITH(NOLOCK)  
		END
			 
    --SELECT *
	--FROM #TEMP_RESULTS_DISTINCT

    PRINT ( 'A4--#TEMP_DM_PLN_BIZPLAN_C ' + CONVERT(NVARCHAR(30), GETDATE(), 121))
	
		/*
		  MEASURE:'Business_Plan_Conf','BizPlanPrice_Cur' 대상이 없으면 INSERT
		*/				
							 
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS  WITH(NOLOCK)
		 WHERE v_MEASURE IN ('Business_Plan_Conf','BizPlanPrice_Cur')
		   AND v_CNT = 0	
	   ) > 0
		BEGIN
			IF OBJECT_ID(N'tempdb..#TEMP_DM_PLN_BIZPLAN_C_I', N'U') IS NOT NULL	DROP TABLE #TEMP_DM_PLN_BIZPLAN_C_I
	
			SELECT T1.SEQ,DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID 
				 , END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY
				 , MEASURE, YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID,EXT_INT 
				 , PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK,CELL_PER_PACK,PERIOD_YYMM 
				 , SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN 
				 , CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,TRANSFER_FLAG 
			INTO #TEMP_DM_PLN_BIZPLAN_C_I
			FROM (
					SELECT 1 AS SEQ,DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID 
								,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY
								,A.MEASURE AS MEASURE, B.v_YYYYMM AS YYYYMM, CAST(B.v_QTY AS NVARCHAR(100))   AS QTY 
								,PROJECT_NAME,ISNULL(CELL_PROD_SITE, '-') AS CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID,EXT_INT 
								,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK,CELL_PER_PACK,PERIOD_YYMM 
								,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN 
								,B.v_CREATED_BY AS CREATED_BY,CONVERT(VARCHAR, GETDATE() , 120)AS CREATION_DATE,B.v_CREATED_BY AS LAST_UPDATED_BY 
								,CONVERT(VARCHAR, GETDATE(), 120) AS LAST_UPDATE_DATE,TRANSFER_FLAG
								, RANK() OVER ( PARTITION BY A.DIVISION_ID,A.VERSION_NO,A.SCM_SITE_ID,A.PLANT_SITE_ID,A.ITEM_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS, A.PROJECT_CODE
														   , A.CURRENCY, A.END_CUSTOMER,A.MEASURE,A.CELL_PROD_SITE  ORDER BY A.YYYYMM DESC,A.SEQ,A.BIZ_TYPE,A.LAST_UPDATE_DATE) AS SEQ_NO 
					FROM #TEMP_DM_PLN_BIZPLAN_C A WITH(NOLOCK) 
					JOIN #TEMP_RESULTS B WITH(NOLOCK) 
						ON A.DIVISION_ID =  B.v_DIVISION_ID
						AND A.VERSION_NO  =  B.v_VERSION_NO 
						AND A.SCM_SITE_ID = CASE WHEN (B.v_DIVISION_ID = '81') THEN  B.v_SCM_SITE_ID  ELSE  A.SCM_SITE_ID   END 
						AND A.PLANT_SITE_ID = B.v_PLANT_SITE_ID 
						AND A.ITEM_ID = B.v_ITEM_ID 
						AND A.FCST_TYPE = B.v_FCST_TYPE 
						AND A.DOM_EXP = B.v_DOM_EXP 
						AND A.INCOTERMS = B.v_INCOTERMS 
						AND A.CURRENCY = B.v_CURRENCY 
						AND A.PROJECT_CODE = CASE WHEN (B.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  B.v_PROJECT_CODE  END    
						AND A.END_CUSTOMER = B.v_END_CUSTOMER
						AND A.MEASURE      = B.v_MEASURE
						AND ISNULL(A.CELL_PROD_SITE, '-') = ISNULL(B.v_CELL_PROD_SITE, '-')
						AND A.MEASURE      IN ('Business_Plan_Conf','BizPlanPrice_Cur')
				 WHERE B.v_CNT = 0	 
				   AND B.v_MEASURE IN ('Business_Plan_Conf','BizPlanPrice_Cur')
			)  T1 
			WHERE T1.SEQ_NO = 1
	

			INSERT INTO #TEMP_DM_PLN_BIZPLAN_C (
						SEQ,DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
						,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY
						,MEASURE,YYYYMM,QTY
						,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID,EXT_INT
						,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK,CELL_PER_PACK,PERIOD_YYMM
						,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,TRANSFER_FLAG,CRUD_CD		
						)  
			SELECT       SEQ,DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID 
						,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY
						,MEASURE, YYYYMM, QTY 
						,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID,EXT_INT 
						,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK,CELL_PER_PACK,PERIOD_YYMM 
						,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN 
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,TRANSFER_FLAG
			            , 'I' AS CRUD_CD		
			 FROM #TEMP_DM_PLN_BIZPLAN_C_I WITH(NOLOCK)
		END	

			 

    PRINT ( 'A5--SalesAmt_CUR INSERT ' + CONVERT(NVARCHAR(30), GETDATE(), 121))
		/*
		  MEASURE:'SalesAmt_CUR','BizPlanPrice_KRW', 대상이 없으면 INSERT
		*/ 			
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS WITH(NOLOCK)
		 WHERE v_CNT = 0	
	   ) > 0
		BEGIN
			INSERT INTO #TEMP_DM_PLN_BIZPLAN_C (
						SEQ,DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
						,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY
						,MEASURE,YYYYMM,QTY
						,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID,EXT_INT
						,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK,CELL_PER_PACK,PERIOD_YYMM
						,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,TRANSFER_FLAG,CRUD_CD		
						)  
			SELECT DISTINCT T1.SEQ,DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID 
				 , END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY
				 , MEASURE, YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID,EXT_INT 
				 , PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK,CELL_PER_PACK,PERIOD_YYMM 
				 , SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN 
				 , CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,TRANSFER_FLAG 
			     , 'I' AS CRUD_CD		
			FROM (
					SELECT DISTINCT 1 AS SEQ,B.DIVISION_ID,B.VERSION_NO,B.CUTOFF_TYPE,B.CUTOFF_YYYYMMDD,B.DEPT_ID,B.PROJECT_CODE,B.SCM_SITE_ID,B.ITEM_ID 
								,B.END_CUSTOMER,B.BIZ_TYPE,B.PLANT_SITE_ID,B.FCST_TYPE,B.DOM_EXP,B.INCOTERMS,B.ITEM_USE,B.UNIT_ENERGY,B.CURRENCY
								,'SalesAmt_CUR' AS MEASURE
								, A.v_YYYYMM AS YYYYMM, CAST(0 AS NVARCHAR(100))  AS QTY 
								,B.PROJECT_NAME,ISNULL(B.CELL_PROD_SITE, '-') AS CELL_PROD_SITE,B.EE_CORP_ID,B.CELL_CORP_ID,B.PACK_CORP_ID,B.EXT_INT 
								,B.PRODUCT_GROUP,B.ALT_SIM_YN,B.CELL_CODE,B.CELL_PER_MODULE,B.MODULE_PER_PACK,B.CELL_PER_PACK,B.PERIOD_YYMM 
								,B.SCENARIO_TYPE,B.BASE_PRICE,B.METAL_LINK_PRICE,B.METAL_LINK_YN,B.WORK_YYYYMMDD,B.OSP_YN 
								,A.v_CREATED_BY AS CREATED_BY,CONVERT(VARCHAR, GETDATE() , 120)AS CREATION_DATE,A.v_CREATED_BY AS LAST_UPDATED_BY 
								,CONVERT(VARCHAR, GETDATE(), 120) AS LAST_UPDATE_DATE,B.TRANSFER_FLAG
								, RANK() OVER ( PARTITION BY B.DIVISION_ID,B.VERSION_NO,B.SCM_SITE_ID,B.PLANT_SITE_ID,B.ITEM_ID,B.FCST_TYPE,B.DOM_EXP,B.INCOTERMS, B.PROJECT_CODE
															, B.CURRENCY, B.END_CUSTOMER,B.MEASURE,B.CELL_PROD_SITE ORDER BY B.YYYYMM DESC,B.SEQ,B.BIZ_TYPE,B.LAST_UPDATE_DATE) AS SEQ_NO 
					FROM #TEMP_RESULTS_DISTINCT A WITH(NOLOCK) 
					JOIN #TEMP_DM_PLN_BIZPLAN_C B WITH(NOLOCK)
						ON B.DIVISION_ID =  A.v_DIVISION_ID
						AND B.VERSION_NO  =  A.v_VERSION_NO 
						AND B.SCM_SITE_ID = CASE WHEN (A.v_DIVISION_ID = '81') THEN  A.v_SCM_SITE_ID  ELSE  B.SCM_SITE_ID   END 
						AND B.PLANT_SITE_ID = A.v_PLANT_SITE_ID 
						AND B.ITEM_ID = A.v_ITEM_ID 
						AND B.FCST_TYPE = A.v_FCST_TYPE 
						AND B.DOM_EXP = A.v_DOM_EXP 
						AND B.INCOTERMS = A.v_INCOTERMS 
						AND B.CURRENCY = A.v_CURRENCY 
						AND B.PROJECT_CODE = CASE WHEN (A.v_DIVISION_ID = '40') THEN  B.PROJECT_CODE  ELSE  A.v_PROJECT_CODE  END  
						AND B.END_CUSTOMER = A.v_END_CUSTOMER 
						AND ISNULL(B.CELL_PROD_SITE, '-') = ISNULL(A.v_CELL_PROD_SITE, '-')
						AND B.MEASURE      IN ('BizPlanPrice_Cur')
					LEFT OUTER JOIN #TEMP_DM_PLN_BIZPLAN_C C WITH(NOLOCK) 
						 ON B.DIVISION_ID =  C.DIVISION_ID
						AND B.VERSION_NO  =  C.VERSION_NO 
						AND B.PROJECT_CODE = C.PROJECT_CODE
						AND B.SCM_SITE_ID = C.SCM_SITE_ID
						AND B.ITEM_ID     = C.ITEM_ID  
						AND B.FCST_TYPE   = C.FCST_TYPE 
						AND B.DOM_EXP    = C.DOM_EXP 
						AND B.INCOTERMS  = C.INCOTERMS 
						AND B.CURRENCY   = C.CURRENCY  
						AND A.v_YYYYMM      = C.YYYYMM  
						AND C.MEASURE = 'SalesAmt_CUR'
					  WHERE C.VERSION_NO IS NULL  
					UNION ALL 
					SELECT DISTINCT 1 AS SEQ,B.DIVISION_ID,B.VERSION_NO,B.CUTOFF_TYPE,B.CUTOFF_YYYYMMDD,B.DEPT_ID,B.PROJECT_CODE,B.SCM_SITE_ID,B.ITEM_ID 
								,B.END_CUSTOMER,B.BIZ_TYPE,B.PLANT_SITE_ID,B.FCST_TYPE,B.DOM_EXP,B.INCOTERMS,B.ITEM_USE,B.UNIT_ENERGY,B.CURRENCY
								,'BizPlanPrice_KRW' AS MEASURE
								, A.v_YYYYMM AS YYYYMM, CAST(0 AS NVARCHAR(100))  AS QTY 
								,B.PROJECT_NAME,ISNULL(B.CELL_PROD_SITE, '-') AS CELL_PROD_SITE,B.EE_CORP_ID,B.CELL_CORP_ID,B.PACK_CORP_ID,B.EXT_INT 
								,B.PRODUCT_GROUP,B.ALT_SIM_YN,B.CELL_CODE,B.CELL_PER_MODULE,B.MODULE_PER_PACK,B.CELL_PER_PACK,B.PERIOD_YYMM 
								,B.SCENARIO_TYPE,B.BASE_PRICE,B.METAL_LINK_PRICE,B.METAL_LINK_YN,B.WORK_YYYYMMDD,B.OSP_YN 
								,A.v_CREATED_BY AS CREATED_BY,CONVERT(VARCHAR, GETDATE() , 120)AS CREATION_DATE,A.v_CREATED_BY AS LAST_UPDATED_BY 
								,CONVERT(VARCHAR, GETDATE(), 120) AS LAST_UPDATE_DATE,B.TRANSFER_FLAG
								, RANK() OVER ( PARTITION BY B.DIVISION_ID,B.VERSION_NO,B.SCM_SITE_ID,B.PLANT_SITE_ID,B.ITEM_ID,B.FCST_TYPE,B.DOM_EXP,B.INCOTERMS, B.PROJECT_CODE
															, B.CURRENCY, B.END_CUSTOMER,B.MEASURE,B.CELL_PROD_SITE ORDER BY B.YYYYMM DESC,B.SEQ,B.BIZ_TYPE,B.LAST_UPDATE_DATE) AS SEQ_NO 
					FROM #TEMP_RESULTS_DISTINCT A WITH(NOLOCK) 
					JOIN #TEMP_DM_PLN_BIZPLAN_C B WITH(NOLOCK)
						ON B.DIVISION_ID =  A.v_DIVISION_ID
						AND B.VERSION_NO  =  A.v_VERSION_NO 
						AND B.SCM_SITE_ID = CASE WHEN (A.v_DIVISION_ID = '81') THEN  A.v_SCM_SITE_ID  ELSE  B.SCM_SITE_ID   END 
						AND B.PLANT_SITE_ID = A.v_PLANT_SITE_ID 
						AND B.ITEM_ID = A.v_ITEM_ID 
						AND B.FCST_TYPE = A.v_FCST_TYPE 
						AND B.DOM_EXP = A.v_DOM_EXP 
						AND B.INCOTERMS = A.v_INCOTERMS 
						AND B.CURRENCY = A.v_CURRENCY 
						AND B.PROJECT_CODE = CASE WHEN (A.v_DIVISION_ID = '40') THEN  B.PROJECT_CODE  ELSE  A.v_PROJECT_CODE  END
						AND B.END_CUSTOMER = A.v_END_CUSTOMER 
						AND ISNULL(B.CELL_PROD_SITE, '-') = ISNULL(A.v_CELL_PROD_SITE, '-')
						AND B.MEASURE      IN ('Business_Plan_Conf') 
					LEFT OUTER JOIN #TEMP_DM_PLN_BIZPLAN_C C WITH(NOLOCK) 
						 ON B.DIVISION_ID =  C.DIVISION_ID
						AND B.VERSION_NO  =  C.VERSION_NO 
						AND B.PROJECT_CODE = C.PROJECT_CODE
						AND B.SCM_SITE_ID = C.SCM_SITE_ID
						AND B.ITEM_ID     = C.ITEM_ID  
						AND B.FCST_TYPE   = C.FCST_TYPE 
						AND B.DOM_EXP    = C.DOM_EXP 
						AND B.INCOTERMS  = C.INCOTERMS 
						AND B.CURRENCY   = C.CURRENCY  
						AND v_YYYYMM      = C.YYYYMM  
						AND C.MEASURE = 'BizPlanPrice_KRW'
					  WHERE C.VERSION_NO IS NULL  
					UNION ALL 
					SELECT DISTINCT 1 AS SEQ,B.DIVISION_ID,B.VERSION_NO,B.CUTOFF_TYPE,B.CUTOFF_YYYYMMDD,B.DEPT_ID,B.PROJECT_CODE,B.SCM_SITE_ID,B.ITEM_ID 
								,B.END_CUSTOMER,B.BIZ_TYPE,B.PLANT_SITE_ID,B.FCST_TYPE,B.DOM_EXP,B.INCOTERMS,B.ITEM_USE,B.UNIT_ENERGY,B.CURRENCY
								,'SalesAmt_KRW' AS MEASURE
								, A.v_YYYYMM AS YYYYMM, CAST(0 AS NVARCHAR(100))  AS QTY 
								,B.PROJECT_NAME,ISNULL(B.CELL_PROD_SITE, '-') AS CELL_PROD_SITE,B.EE_CORP_ID,B.CELL_CORP_ID,B.PACK_CORP_ID,B.EXT_INT 
								,B.PRODUCT_GROUP,B.ALT_SIM_YN,B.CELL_CODE,B.CELL_PER_MODULE,B.MODULE_PER_PACK,B.CELL_PER_PACK,B.PERIOD_YYMM 
								,B.SCENARIO_TYPE,B.BASE_PRICE,B.METAL_LINK_PRICE,B.METAL_LINK_YN,B.WORK_YYYYMMDD,B.OSP_YN 
								,A.v_CREATED_BY AS CREATED_BY,CONVERT(VARCHAR, GETDATE() , 120)AS CREATION_DATE,A.v_CREATED_BY AS LAST_UPDATED_BY 
								,CONVERT(VARCHAR, GETDATE(), 120) AS LAST_UPDATE_DATE,B.TRANSFER_FLAG
								, RANK() OVER ( PARTITION BY B.DIVISION_ID,B.VERSION_NO,B.SCM_SITE_ID,B.PLANT_SITE_ID,B.ITEM_ID,B.FCST_TYPE,B.DOM_EXP,B.INCOTERMS, B.PROJECT_CODE
															, B.CURRENCY, B.END_CUSTOMER,B.MEASURE,B.CELL_PROD_SITE ORDER BY B.YYYYMM DESC,B.SEQ,B.BIZ_TYPE,B.LAST_UPDATE_DATE) AS SEQ_NO
					FROM #TEMP_RESULTS_DISTINCT A WITH(NOLOCK) 
					JOIN #TEMP_DM_PLN_BIZPLAN_C B WITH(NOLOCK)
						ON B.DIVISION_ID =  A.v_DIVISION_ID
						AND B.VERSION_NO  =  A.v_VERSION_NO 
						AND B.SCM_SITE_ID = A.v_SCM_SITE_ID 
						AND B.PLANT_SITE_ID = A.v_PLANT_SITE_ID 
						AND B.ITEM_ID = A.v_ITEM_ID 
						AND B.FCST_TYPE = A.v_FCST_TYPE 
						AND B.DOM_EXP = A.v_DOM_EXP 
						AND B.INCOTERMS = A.v_INCOTERMS 
						AND B.CURRENCY = A.v_CURRENCY 
						AND B.PROJECT_CODE = CASE WHEN (A.v_DIVISION_ID = '40') THEN  B.PROJECT_CODE  ELSE  A.v_PROJECT_CODE  END
						AND B.END_CUSTOMER = A.v_END_CUSTOMER 
						AND ISNULL(B.CELL_PROD_SITE, '-') = ISNULL(A.v_CELL_PROD_SITE, '-')
						AND B.MEASURE      IN ('Business_Plan_Conf') 
					LEFT OUTER JOIN #TEMP_DM_PLN_BIZPLAN_C C WITH(NOLOCK) 
						 ON B.DIVISION_ID =  C.DIVISION_ID
						AND B.VERSION_NO  =  C.VERSION_NO 
						AND B.PROJECT_CODE = C.PROJECT_CODE
						AND B.SCM_SITE_ID = C.SCM_SITE_ID
						AND B.ITEM_ID     = C.ITEM_ID  
						AND B.FCST_TYPE   = C.FCST_TYPE 
						AND B.DOM_EXP    = C.DOM_EXP 
						AND B.INCOTERMS  = C.INCOTERMS 
						AND B.CURRENCY   = C.CURRENCY  
						AND v_YYYYMM      = C.YYYYMM  
						AND C.MEASURE = 'SalesAmt_KRW'
					  WHERE C.VERSION_NO IS NULL  
			 )  T1
			WHERE T1.SEQ_NO = 1
		END				
	   
	   
    PRINT ( 'A6--SalesAmt_CUR UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))
		/*
		  SalesAmt_CUR 업데이트
		*/ 	
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS WITH(NOLOCK)
		 WHERE v_CNT = 0	
	   ) > 0
		BEGIN
			UPDATE Z
			   SET QTY = AA.AMT 
				 , LAST_UPDATED_BY = AA.LAST_UPDATED_BY
				 , LAST_UPDATE_DATE = CONVERT(VARCHAR, GETDATE(), 120)
			     , CRUD_CD = 'U'  
			 FROM #TEMP_DM_PLN_BIZPLAN_C Z 
				, (
					SELECT A.DIVISION_ID,A.VERSION_NO,A.PROJECT_CODE ,A.SCM_SITE_ID , A.END_CUSTOMER,A.PLANT_SITE_ID ,A.ITEM_ID       
						 , A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS ,A.CURRENCY,A.YYYYMM,A.CELL_PROD_SITE,C.v_LAST_UPDATED_BY AS LAST_UPDATED_BY
						 , A.SEQ, A.QTY BP_QTY, B.QTY PRICE, A.QTY * B.QTY AMT 
					  FROM #TEMP_RESULTS C WITH(NOLOCK) 
					JOIN #TEMP_DM_PLN_BIZPLAN_C A WITH(NOLOCK)
						ON A.DIVISION_ID =  C.v_DIVISION_ID
						AND A.VERSION_NO  =  C.v_VERSION_NO 
						AND A.SCM_SITE_ID = CASE WHEN (C.v_DIVISION_ID = '81') THEN  C.v_SCM_SITE_ID  ELSE  A.SCM_SITE_ID   END 
						AND A.PLANT_SITE_ID = C.v_PLANT_SITE_ID 
						AND A.ITEM_ID = C.v_ITEM_ID 
						AND A.FCST_TYPE = C.v_FCST_TYPE 
						AND A.DOM_EXP = C.v_DOM_EXP 
						AND A.INCOTERMS = C.v_INCOTERMS 
						AND A.CURRENCY = C.v_CURRENCY 
						AND A.PROJECT_CODE = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
						AND A.END_CUSTOMER = C.v_END_CUSTOMER 
						AND A.YYYYMM = C.v_YYYYMM 
						AND ISNULL(A.CELL_PROD_SITE, '-') = ISNULL(C.v_CELL_PROD_SITE, '-') 
					  INNER JOIN #TEMP_DM_PLN_BIZPLAN_C B  WITH(NOLOCK) 
						 ON A.DIVISION_ID    = B.DIVISION_ID   
						AND A.VERSION_NO     = B.VERSION_NO    
						AND A.PROJECT_CODE   = B.PROJECT_CODE  
						AND A.SCM_SITE_ID    = B.SCM_SITE_ID   
						AND A.END_CUSTOMER   = B.END_CUSTOMER  
						AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID 
						AND A.ITEM_ID        = B.ITEM_ID       
						AND A.DOM_EXP        = B.DOM_EXP       
						AND A.FCST_TYPE      = B.FCST_TYPE     
						AND A.INCOTERMS      = B.INCOTERMS     
						AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
						AND A.YYYYMM         = B.YYYYMM        
					  WHERE A.MEASURE = 'Business_Plan_Conf' 
						AND B.MEASURE = 'BizPlanPrice_Cur'
						AND C.v_CNT = 0	 
				  ) AA  
			  WHERE Z.DIVISION_ID    = AA.DIVISION_ID    
				AND Z.VERSION_NO     = AA.VERSION_NO    
				AND Z.PROJECT_CODE   = AA.PROJECT_CODE  
				AND Z.SCM_SITE_ID    = AA.SCM_SITE_ID   
				AND Z.END_CUSTOMER   = AA.END_CUSTOMER  
				AND Z.PLANT_SITE_ID  = AA.PLANT_SITE_ID 
				AND Z.ITEM_ID        = AA.ITEM_ID       
				AND Z.DOM_EXP        = AA.DOM_EXP       
				AND Z.FCST_TYPE      = AA.FCST_TYPE     
				AND Z.INCOTERMS      = AA.INCOTERMS    
				AND Z.CURRENCY       = AA.CURRENCY      
				AND ISNULL(Z.CELL_PROD_SITE, '-') = ISNULL(AA.CELL_PROD_SITE, '-')    
				AND Z.YYYYMM         = AA.YYYYMM      
				--AND Z.SEQ            = AA.SEQ       
				AND Z.MEASURE = 'SalesAmt_CUR'  
		END				
		
    PRINT ( 'A7--BizPlanPrice_KRW UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))
		/*
		  BizPlanPrice_KRW 업데이트
		*/ 	
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS WITH(NOLOCK)
		 WHERE v_CNT = 0	
	   ) > 0
		BEGIN
			UPDATE Z 
			   SET QTY = ISNULL(AA.STND_PRICE, 1) 
				 , LAST_UPDATED_BY = AA.LAST_UPDATED_BY
				 , LAST_UPDATE_DATE = CONVERT(VARCHAR, GETDATE(), 120)
			     , CRUD_CD = 'U'  
			 FROM  #TEMP_DM_PLN_BIZPLAN_C Z 
				, ( 
					SELECT A.DIVISION_ID,A.VERSION_NO,A.PROJECT_CODE ,A.SCM_SITE_ID , A.END_CUSTOMER,A.PLANT_SITE_ID ,A.ITEM_ID       
						 , A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS ,A.CURRENCY,A.YYYYMM,A.CELL_PROD_SITE,C.v_LAST_UPDATED_BY AS LAST_UPDATED_BY 
						 , A.QTY, A.QTY * ISNULL(B.STND_PRICE, 1) STND_PRICE
					  FROM #TEMP_RESULTS C WITH(NOLOCK) 
					JOIN #TEMP_DM_PLN_BIZPLAN_C A WITH(NOLOCK)
						ON A.DIVISION_ID =  C.v_DIVISION_ID
						AND A.VERSION_NO  =  C.v_VERSION_NO 
						AND A.SCM_SITE_ID = CASE WHEN (C.v_DIVISION_ID = '81') THEN  C.v_SCM_SITE_ID  ELSE  A.SCM_SITE_ID   END 
						AND A.PLANT_SITE_ID = C.v_PLANT_SITE_ID 
						AND A.ITEM_ID = C.v_ITEM_ID 
						AND A.FCST_TYPE = C.v_FCST_TYPE 
						AND A.DOM_EXP = C.v_DOM_EXP 
						AND A.INCOTERMS = C.v_INCOTERMS 
						AND A.CURRENCY = C.v_CURRENCY 
						AND A.PROJECT_CODE = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
						AND A.END_CUSTOMER = C.v_END_CUSTOMER 
						AND A.YYYYMM = C.v_YYYYMM 
						AND ISNULL(A.CELL_PROD_SITE, '-') = ISNULL(C.v_CELL_PROD_SITE, '-')  
					  INNER JOIN DM_MST_METAL_CURRENCY_PRICE B  WITH(NOLOCK) 
						 ON A.DIVISION_ID    = B.DIVISION_ID   
						AND A.CURRENCY       = B.METAL_CURRENCY  
						AND A.YYYYMM         = B.STND_YM 
						AND B.METAL_CURRENCY_GBN = '1'
					  WHERE A.MEASURE = 'BizPlanPrice_Cur' 
						AND C.v_CNT = 0	 
				  ) AA  
			  WHERE Z.DIVISION_ID    = AA.DIVISION_ID    
				AND Z.VERSION_NO     = AA.VERSION_NO    
				AND Z.PROJECT_CODE   = AA.PROJECT_CODE  
				AND Z.SCM_SITE_ID    = AA.SCM_SITE_ID   
				AND Z.END_CUSTOMER   = AA.END_CUSTOMER  
				AND Z.PLANT_SITE_ID  = AA.PLANT_SITE_ID 
				AND Z.ITEM_ID        = AA.ITEM_ID       
				AND Z.DOM_EXP        = AA.DOM_EXP       
				AND Z.FCST_TYPE      = AA.FCST_TYPE     
				AND Z.INCOTERMS      = AA.INCOTERMS    
				AND Z.CURRENCY       = AA.CURRENCY      
				AND ISNULL(Z.CELL_PROD_SITE, '-') = ISNULL(AA.CELL_PROD_SITE, '-')    
				AND Z.YYYYMM         = AA.YYYYMM   
				AND Z.MEASURE = 'BizPlanPrice_KRW'  
		END				 
		  
		  	
    PRINT ( 'A8--SalesAmt_KRW UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))
		/*
		  SalesAmt_KRW 업데이트
		*/ 	
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS WITH(NOLOCK)
		 WHERE v_CNT = 0	
	   ) > 0
		BEGIN
			UPDATE Z 
			   SET QTY = AA.AMT_KRT 
				 , LAST_UPDATED_BY = AA.LAST_UPDATED_BY
				 , LAST_UPDATE_DATE = CONVERT(VARCHAR, GETDATE(), 120)
			     , CRUD_CD = 'U'  
			 FROM #TEMP_DM_PLN_BIZPLAN_C Z 
				, (
					SELECT A.DIVISION_ID,A.VERSION_NO,A.PROJECT_CODE ,A.SCM_SITE_ID , A.END_CUSTOMER,A.PLANT_SITE_ID ,A.ITEM_ID       
						 , A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS ,A.CURRENCY,A.YYYYMM,A.CELL_PROD_SITE,C.v_LAST_UPDATED_BY AS LAST_UPDATED_BY
						 , A.QTY, A.QTY * B.QTY  AMT_KRT 
					  FROM #TEMP_RESULTS C WITH(NOLOCK) 
					JOIN #TEMP_DM_PLN_BIZPLAN_C A WITH(NOLOCK)
						ON A.DIVISION_ID =  C.v_DIVISION_ID
						AND A.VERSION_NO  =  C.v_VERSION_NO 
						AND A.SCM_SITE_ID = CASE WHEN (C.v_DIVISION_ID = '81') THEN  C.v_SCM_SITE_ID  ELSE  A.SCM_SITE_ID   END 
						AND A.PLANT_SITE_ID = C.v_PLANT_SITE_ID 
						AND A.ITEM_ID = C.v_ITEM_ID 
						AND A.FCST_TYPE = C.v_FCST_TYPE 
						AND A.DOM_EXP = C.v_DOM_EXP 
						AND A.INCOTERMS = C.v_INCOTERMS 
						AND A.CURRENCY = C.v_CURRENCY 
						AND A.PROJECT_CODE = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
						AND A.END_CUSTOMER = C.v_END_CUSTOMER 
						AND A.YYYYMM = C.v_YYYYMM 
						AND ISNULL(A.CELL_PROD_SITE, '-') = ISNULL(C.v_CELL_PROD_SITE, '-')		
					  INNER JOIN #TEMP_DM_PLN_BIZPLAN_C B  WITH(NOLOCK) 
						 ON A.DIVISION_ID    = B.DIVISION_ID   
						AND A.VERSION_NO     = B.VERSION_NO  
						AND A.SCM_SITE_ID    = B.SCM_SITE_ID   
						AND A.ITEM_ID        = B.ITEM_ID       
						AND A.DOM_EXP        = B.DOM_EXP       
						AND A.FCST_TYPE      = B.FCST_TYPE     
						AND A.INCOTERMS      = B.INCOTERMS    
						AND A.YYYYMM         = B.YYYYMM       
						AND A.CURRENCY       = B.CURRENCY         
					  WHERE A.MEASURE = 'BizPlanPrice_KRW'       
						AND B.MEASURE = 'Business_Plan_Conf'  
						AND C.v_CNT = 0	 
				  ) AA  
			  WHERE Z.DIVISION_ID    = AA.DIVISION_ID    
				AND Z.VERSION_NO     = AA.VERSION_NO    
				AND Z.PROJECT_CODE   = AA.PROJECT_CODE  
				AND Z.SCM_SITE_ID    = AA.SCM_SITE_ID   
				AND Z.END_CUSTOMER   = AA.END_CUSTOMER  
				AND Z.PLANT_SITE_ID  = AA.PLANT_SITE_ID 
				AND Z.ITEM_ID        = AA.ITEM_ID       
				AND Z.DOM_EXP        = AA.DOM_EXP       
				AND Z.FCST_TYPE      = AA.FCST_TYPE     
				AND Z.INCOTERMS      = AA.INCOTERMS    
				AND Z.CURRENCY       = AA.CURRENCY    
				AND Z.YYYYMM         = AA.YYYYMM   
				AND Z.MEASURE = 'SalesAmt_KRW'   
		END				 
		 
		 
		 
    PRINT ( 'A9--Business_Plan_Conf UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))
		/*
		  Business_Plan_Conf 분기로직  건수체크
		*/     	
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS WITH(NOLOCK)
		 WHERE v_MEASURE IN ('Business_Plan_Conf' )  
		   AND v_CNT > 0	
	   ) > 0
		BEGIN
		
			IF OBJECT_ID (N'tempdb..#TEMP_DM_PLN_BIZPLAN_C_BPC', N'U') IS NOT NULL 		DROP TABLE #TEMP_DM_PLN_BIZPLAN_C_BPC

			SELECT DIVISION_ID,VERSION_NO,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID 
						,FCST_TYPE,DOM_EXP,INCOTERMS,CURRENCY,MEASURE,YYYYMM,CELL_PROD_SITE,MAX(B.v_CREATED_BY) AS CREATED_BY
						,MAX(B.v_LAST_UPDATED_BY) AS LAST_UPDATED_BY,MAX(B.v_QTY) AS QTY,COUNT(*) AS C_CNT
			INTO #TEMP_DM_PLN_BIZPLAN_C_BPC
			FROM #TEMP_DM_PLN_BIZPLAN_C A WITH(NOLOCK) 
			JOIN #TEMP_RESULTS B WITH(NOLOCK) 
				ON A.DIVISION_ID =  B.v_DIVISION_ID
				AND A.VERSION_NO  =  B.v_VERSION_NO 
				AND A.PROJECT_CODE = CASE WHEN (B.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  B.v_PROJECT_CODE  END 
				AND A.END_CUSTOMER = B.v_END_CUSTOMER
				AND A.SCM_SITE_ID = B.v_SCM_SITE_ID 
				AND A.PLANT_SITE_ID = B.v_PLANT_SITE_ID 
				AND A.ITEM_ID = B.v_ITEM_ID 
				AND A.FCST_TYPE = B.v_FCST_TYPE 
				AND A.DOM_EXP = B.v_DOM_EXP 
				AND A.INCOTERMS = B.v_INCOTERMS 
				AND A.CURRENCY = B.v_CURRENCY  
				AND A.MEASURE      = B.v_MEASURE
				AND A.YYYYMM       = B.v_YYYYMM
				AND A.CELL_PROD_SITE = B.v_CELL_PROD_SITE
			  WHERE A.MEASURE IN ('Business_Plan_Conf' )  	
				AND B.v_MEASURE IN ('Business_Plan_Conf' )  				
			GROUP BY DIVISION_ID,VERSION_NO,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID 
						,FCST_TYPE,DOM_EXP,INCOTERMS,CURRENCY,MEASURE,YYYYMM,CELL_PROD_SITE
				  	
    PRINT ( 'A9_1--Business_Plan_Conf UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))
			/*
			  Business_Plan_Conf 분기로직 미적용 
			*/ 	
		IF (SELECT COUNT(1)  
			  FROM #TEMP_DM_PLN_BIZPLAN_C_BPC  WITH(NOLOCK)
			 WHERE C_CNT = 1 	
		   ) > 0	 
			BEGIN		
    PRINT ( 'A9_1_1--Business_Plan_Conf UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))		
				UPDATE Z 
				   SET QTY = CAST(AA.QTY AS NVARCHAR(100)) 
					 , LAST_UPDATED_BY = AA.LAST_UPDATED_BY
					 , LAST_UPDATE_DATE = CONVERT(VARCHAR, GETDATE(), 120)
			         , CRUD_CD = 'U'  
				 FROM  #TEMP_DM_PLN_BIZPLAN_C Z 
					,  #TEMP_DM_PLN_BIZPLAN_C_BPC AA  
				  WHERE AA.C_CNT = 1    
					AND Z.MEASURE = 'Business_Plan_Conf'  	 
					AND Z.DIVISION_ID    = AA.DIVISION_ID    
					AND Z.VERSION_NO     = AA.VERSION_NO    
					AND Z.PROJECT_CODE   = AA.PROJECT_CODE   
					AND Z.END_CUSTOMER   = AA.END_CUSTOMER  
					AND Z.SCM_SITE_ID    = AA.SCM_SITE_ID  
					AND Z.PLANT_SITE_ID  = AA.PLANT_SITE_ID 
					AND Z.ITEM_ID        = AA.ITEM_ID        
					AND Z.FCST_TYPE      = AA.FCST_TYPE        
					AND Z.DOM_EXP        = AA.DOM_EXP   
					AND Z.INCOTERMS      = AA.INCOTERMS    
					AND Z.CURRENCY       = AA.CURRENCY    
					AND Z.YYYYMM         = AA.YYYYMM      
					AND Z.MEASURE        = AA.MEASURE        
					AND Z.CELL_PROD_SITE = AA.CELL_PROD_SITE  
			  END	 
				
    PRINT ( 'A9_2--Business_Plan_Conf UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))	    	
			/*
			  Business_Plan_Conf 분기로직 적용 
			*/  
		
		IF (SELECT COUNT(1)  
			  FROM #TEMP_DM_PLN_BIZPLAN_C_BPC  WITH(NOLOCK)
			 WHERE C_CNT > 1 	
		   ) > 0	 
			BEGIN			
				IF OBJECT_ID (N'tempdb..#TMP_RTF_RATIO_BP_CONF', N'U') IS NOT NULL 		DROP TABLE #TMP_RTF_RATIO_BP_CONF
				IF OBJECT_ID (N'tempdb..#TMP_BP_CONFIRM', N'U') IS NOT NULL 			DROP TABLE #TMP_BP_CONFIRM 
				IF OBJECT_ID (N'tempdb..#TMP_REMAIN_BP', N'U') IS NOT NULL 			DROP TABLE #TMP_REMAIN_BP

				CREATE TABLE #TMP_RTF_RATIO_BP_CONF(
				  DIVISION_ID	  NVARCHAR(MAX)
				  ,VERSION_NO	  NVARCHAR(MAX)
				  ,SCM_SITE_ID    NVARCHAR(MAX)
				  ,PROJECT_CODE   NVARCHAR(MAX)
				  ,ITEM_ID	      NVARCHAR(MAX)
				  ,INCOTERMS	  NVARCHAR(MAX)
				  ,MEASURE	      NVARCHAR(MAX)
				  ,YYYYMM		  NVARCHAR(MAX)
				  ,EE_CORP_ID	  NVARCHAR(MAX)
				  ,CELL_CORP_ID   NVARCHAR(MAX)
				  ,PACK_CORP_ID   NVARCHAR(MAX)
				  ,OSP_YN	      NVARCHAR(MAX)
				  ,ATTRIBUTE1	  NVARCHAR(MAX)
				  ,ATTRIBUTE2	  NVARCHAR(MAX)
				  ,QTY		      INT
				  ,RATIO		  FLOAT
				)
       
					INSERT INTO #TMP_RTF_RATIO_BP_CONF 
					SELECT DIVISION_ID, VERSION_NO, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, MEASURE
						 , YYYYMM, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, ATTRIBUTE1, ATTRIBUTE2, ISNULL(QTY, 0)
						 , CASE WHEN SUM(QTY) * 100 / SUM(SUM(QTY)) OVER() IS NULL THEN 0 ELSE SUM(QTY) * 100 / SUM(SUM(QTY)) OVER() END  RATIO
						FROM  (SELECT DISTINCT 
									  v_DIVISION_ID
									, v_VERSION_NO
									, v_PROJECT_CODE
									, v_SCM_SITE_ID
									, v_ITEM_ID
									, v_YYYYMM
								FROM #TEMP_RESULTS  WITH(NOLOCK) 
								WHERE v_MEASURE = 'Business_Plan_Conf' 
								AND v_CNT > 1      
								) C 
						INNER JOIN #TEMP_DM_PLN_BIZPLAN_C A  WITH(NOLOCK)
							ON A.DIVISION_ID   =  C.v_DIVISION_ID
						AND A.VERSION_NO    =  C.v_VERSION_NO 
						AND A.PROJECT_CODE  = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
						AND A.SCM_SITE_ID   = CASE WHEN (C.v_DIVISION_ID = '81') THEN  C.v_SCM_SITE_ID  ELSE  A.SCM_SITE_ID   END  
						AND A.ITEM_ID       = C.v_ITEM_ID  
						AND A.YYYYMM        = C.v_YYYYMM 
						AND A.MEASURE       = 'RTF'   
					GROUP BY DIVISION_ID, VERSION_NO, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, MEASURE
							, YYYYMM, QTY, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, OSP_YN, ATTRIBUTE1, ATTRIBUTE2


	  
		PRINT ( 'A9_3--Business_Plan_Conf UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))
					SELECT ROW_NUMBER() OVER(ORDER BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID) SN, RANK() OVER (PARTITION BY AA.VERSION_NO,AA.CUTOFF_TYPE,AA.CUTOFF_YYYYMMDD,AA.PROJECT_CODE,AA.SCM_SITE_ID
						,AA.ITEM_ID 
						,AA.INCOTERMS,AA.MEASURE,AA.YYYYMM ORDER BY AA.QT DESC) SEQ
    					,AA.DIVISION_ID,AA.VERSION_NO,AA. CUTOFF_TYPE,AA. CUTOFF_YYYYMMDD
						,AA.DEPT_ID,AA.PROJECT_CODE,AA.PROJECT_NAME,AA.SCM_SITE_ID,AA.ITEM_ID,AA.END_CUSTOMER,AA.BIZ_TYPE,AA.PLANT_SITE_ID,AA.FCST_TYPE,AA.DOM_EXP,AA.INCOTERMS
						,AA.ITEM_USE,AA.UNIT_ENERGY,AA.CURRENCY,AA.MEASURE,AA.YYYYMM, AA.QTY QTY_O, AA.QT QTY, AA.RATIO, AA.RATIO1, QT
						,AA.CELL_CODE,AA. CELL_PER_PACK,AA.CELL_PER_MODULE,AA.MODULE_PER_PACK,AA.CELL_PROD_SITE,AA.PRODUCT_GROUP
						,AA.EE_CORP_ID,AA.CELL_CORP_ID,AA.PACK_CORP_ID,AA.ALT_SIM_YN,AA.PERIOD_YYMM,AA.SCENARIO_TYPE,AA.BASE_PRICE,AA.METAL_LINK_PRICE,AA.METAL_LINK_YN,AA.WORK_YYYYMMDD,AA.OSP_YN,AA.EXT_INT
						,AA.ATTRIBUTE1,AA.ATTRIBUTE2,AA.v_QTY
						,AA.CREATED_BY,AA. CREATION_DATE,AA. LAST_UPDATED_BY,AA. LAST_UPDATE_DATE
					INTO #TMP_BP_CONFIRM
					FROM
					(
					SELECT A.SEQ, A.DIVISION_ID,A.VERSION_NO,A. CUTOFF_TYPE,A. CUTOFF_YYYYMMDD
							,A.DEPT_ID,A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
							,A.ITEM_USE,A.UNIT_ENERGY,A.CURRENCY, A.MEASURE,A.YYYYMM, A.QTY, B.RATIO, CONVERT(FLOAT, (B.RATIO/100)) RATIO1, ROUND(C.v_QTY * (B.RATIO/100), 0) QT
							,A.CELL_CODE,A.CELL_PER_PACK,A.CELL_PER_MODULE,A.MODULE_PER_PACK,A.CELL_PROD_SITE,A.PRODUCT_GROUP
							,B.EE_CORP_ID,B.CELL_CORP_ID,B.PACK_CORP_ID,A.ALT_SIM_YN,A.PERIOD_YYMM,A.SCENARIO_TYPE,A.BASE_PRICE,A.METAL_LINK_PRICE,A.METAL_LINK_YN,A.WORK_YYYYMMDD,B.OSP_YN,A.EXT_INT
							,B.ATTRIBUTE1,B.ATTRIBUTE2,C.v_QTY
							,'SYSTEM' CREATED_BY,GETDATE() CREATION_DATE,'SYSTEM' LAST_UPDATED_BY,GETDATE() LAST_UPDATE_DATE
					FROM  (SELECT DISTINCT 
									v_DIVISION_ID
								, v_VERSION_NO
								, v_PROJECT_CODE
								, v_SCM_SITE_ID
								, v_ITEM_ID
								, v_YYYYMM 
								, v_MEASURE
								, v_CELL_PROD_SITE 
								, v_QTY
							FROM #TEMP_RESULTS WITH(NOLOCK)
							WHERE v_MEASURE = 'Business_Plan_Conf' 
								AND v_CNT > 1      
							) C  
					INNER JOIN #TEMP_DM_PLN_BIZPLAN_C A  WITH(NOLOCK)
						ON A.DIVISION_ID   =  C.v_DIVISION_ID
						AND A.VERSION_NO    =  C.v_VERSION_NO 
						AND A.PROJECT_CODE  = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
						AND A.SCM_SITE_ID   = C.v_SCM_SITE_ID
						AND A.ITEM_ID       = C.v_ITEM_ID  
						AND A.YYYYMM        = C.v_YYYYMM 
						AND A.MEASURE       = C.v_MEASURE
	    				AND ISNULL(A.CELL_PROD_SITE, '-') = ISNULL(C.v_CELL_PROD_SITE, '-')
					LEFT OUTER JOIN #TMP_RTF_RATIO_BP_CONF B  WITH(NOLOCK)
					ON A.DIVISION_ID       = B.DIVISION_ID
						AND A.VERSION_NO   = B.VERSION_NO
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.SCM_SITE_ID  = B.SCM_SITE_ID
						AND A.ITEM_ID      = B.ITEM_ID
						AND A.INCOTERMS    = B.INCOTERMS
						AND A.YYYYMM       = B.YYYYMM
						AND ISNULL(A.EE_CORP_ID, '')   = ISNULL(B.EE_CORP_ID, '')
						AND ISNULL(A.CELL_CORP_ID, '') = ISNULL(B.CELL_CORP_ID, '')
						AND ISNULL(A.PACK_CORP_ID, '') = ISNULL(B.PACK_CORP_ID, '') 
					WHERE 1=1 
					) AA  

			 
		PRINT ( 'A9_4--Business_Plan_Conf UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))

					SELECT 
					DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID
					,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY_O, RATIO1, QTY, REMAIN							
					INTO #TMP_REMAIN_BP FROM(
					SELECT A.DIVISION_ID,A.VERSION_NO,A.CUTOFF_TYPE,A.CUTOFF_YYYYMMDD
					,A.DEPT_ID,A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID
					,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS,A.ITEM_USE,A.UNIT_ENERGY,A.CURRENCY,A.MEASURE,A.YYYYMM,A.QTY_O, A.RATIO1, A.QTY, A.v_QTY - B.SUM_QTY AS REMAIN
						FROM #TMP_BP_CONFIRM A
						LEFT OUTER JOIN 
							(SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID
								, END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
								, ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM
								, SUM(QTY) AS SUM_QTY,SUM(QT)AS SUM_QT  
								FROM #TMP_BP_CONFIRM
							GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID
									,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
									,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM
							) B
							ON A.DIVISION_ID = B.DIVISION_ID
							AND A.PROJECT_CODE = B.PROJECT_CODE
							AND A.SCM_SITE_ID = B.SCM_SITE_ID
							AND A.ITEM_ID = B.ITEM_ID
							AND A.END_CUSTOMER = B.END_CUSTOMER
							AND A.BIZ_TYPE = B.BIZ_TYPE
							AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
							AND A.FCST_TYPE = B.FCST_TYPE
							AND A.DOM_EXP = B.DOM_EXP
							AND A.INCOTERMS = B.INCOTERMS
							AND A.ITEM_USE = B.ITEM_USE
							AND A.UNIT_ENERGY = B.UNIT_ENERGY
							AND A.CURRENCY = B.CURRENCY
							AND A.MEASURE = B.MEASURE
							AND A.YYYYMM = B.YYYYMM
						GROUP BY A.DIVISION_ID,A.VERSION_NO,A.CUTOFF_TYPE,A.CUTOFF_YYYYMMDD
					,A.DEPT_ID,A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID
					,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS,A.ITEM_USE,A.UNIT_ENERGY,A.CURRENCY,A.MEASURE,A.YYYYMM,A.QTY_O, A.RATIO1, A.QTY, A.v_QTY,B.SUM_QTY
					HAVING A.QTY_O <> SUM(A.QTY)
					) A

					UPDATE A 
						SET QTY = B.QTY + B.REMAIN
					FROM #TMP_BP_CONFIRM A
					   , #TMP_REMAIN_BP B
					WHERE A.DIVISION_ID   = B.DIVISION_ID
					AND A.PROJECT_CODE = B.PROJECT_CODE
					AND A.SCM_SITE_ID  = B.SCM_SITE_ID
					AND A.ITEM_ID      = B.ITEM_ID
					AND A.FCST_TYPE    = B.FCST_TYPE
					AND A.INCOTERMS    = B.INCOTERMS
					AND A.YYYYMM       = B.YYYYMM
					AND A.SEQ = 1

					UPDATE A
						SET QTY = B.QT
					FROM #TEMP_DM_PLN_BIZPLAN_C A
					   , #TMP_BP_CONFIRM B
					WHERE A.DIVISION_ID   = B.DIVISION_ID
					AND A.PROJECT_CODE = B.PROJECT_CODE
					AND A.SCM_SITE_ID  = B.SCM_SITE_ID
					AND A.ITEM_ID      = B.ITEM_ID
					AND A.FCST_TYPE    = B.FCST_TYPE
					AND A.INCOTERMS    = B.INCOTERMS
					AND A.YYYYMM       = B.YYYYMM
					--AND DM_PLN_BIZPLAN_C.SEQ          = B.SEQ
					AND ISNULL(A.EE_CORP_ID, '')         = ISNULL(B.EE_CORP_ID, '')
					AND ISNULL(A.CELL_CORP_ID, '')       = ISNULL(B.CELL_CORP_ID, '')
					AND ISNULL(A.PACK_CORP_ID, '')       = ISNULL(B.PACK_CORP_ID, '')
					AND A.MEASURE      = 'Business_Plan_Conf' 
		     END							   				   
        END		  
		  
    PRINT ( 'A10--BizPlanPrice_Cur UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))  	     

		/*
		  BizPlanPrice_Cur 분기로직 미적용  
		*/      	
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS WITH(NOLOCK)
		 WHERE  v_MEASURE IN ('BizPlanPrice_Cur' )  
		   AND v_CNT > 0	
	   ) > 0
		BEGIN
			UPDATE A 
			   SET QTY = CAST(C.v_QTY AS NVARCHAR(100)) 
				 , LAST_UPDATED_BY = C.v_LAST_UPDATED_BY
				 , LAST_UPDATE_DATE = CONVERT(VARCHAR, GETDATE(), 120)
			   FROM #TEMP_DM_PLN_BIZPLAN_C A 
				  , #TEMP_RESULTS C WITH(NOLOCK)  
			  WHERE 1 = 1   
				AND C.v_MEASURE       = 'BizPlanPrice_Cur'  
				AND C.v_CNT         > 0 
				AND A.DIVISION_ID   =  C.v_DIVISION_ID
				AND A.VERSION_NO    =  C.v_VERSION_NO 
				AND A.PROJECT_CODE  = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
				AND A.SCM_SITE_ID   = CASE WHEN (C.v_DIVISION_ID = '81') THEN  C.v_SCM_SITE_ID  ELSE  A.SCM_SITE_ID   END 
				AND A.PLANT_SITE_ID = C.v_PLANT_SITE_ID 
				AND A.ITEM_ID       = C.v_ITEM_ID 
				AND A.FCST_TYPE     = C.v_FCST_TYPE 
				AND A.DOM_EXP       = C.v_DOM_EXP 
				AND A.INCOTERMS     = C.v_INCOTERMS 
				AND A.CURRENCY      = C.v_CURRENCY 
				AND A.END_CUSTOMER  = C.v_END_CUSTOMER 
				AND A.YYYYMM        = C.v_YYYYMM 
				AND A.MEASURE       = C.v_MEASURE
				AND ISNULL(A.CELL_PROD_SITE, '-') = ISNULL(C.v_CELL_PROD_SITE, '-')	 
		END				 
		    
    PRINT ( 'A11--SalesAmt_CUR UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))  
 
		/*
		  SalesAmt_CUR 업데이트 
		*/   	
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS WITH(NOLOCK)
		 WHERE  v_MEASURE IN ('Business_Plan_Conf','BizPlanPrice_Cur' )  
	   ) > 0
		BEGIN
			UPDATE Z 
			   SET QTY = AA.AMT 
				 , LAST_UPDATED_BY = AA.LAST_UPDATED_BY
				 , LAST_UPDATE_DATE = CONVERT(VARCHAR, GETDATE(), 120)
			     , CRUD_CD = 'U'  
			 FROM #TEMP_DM_PLN_BIZPLAN_C Z 
				, (
					SELECT A.DIVISION_ID,A.VERSION_NO,A.PROJECT_CODE ,A.SCM_SITE_ID , A.END_CUSTOMER,A.PLANT_SITE_ID ,A.ITEM_ID       
						 , A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS ,A.CURRENCY,A.YYYYMM,A.CELL_PROD_SITE ,MAX(C.v_LAST_UPDATED_BY) AS LAST_UPDATED_BY
						 , SUM(A.QTY * B.QTY) AMT 
					  FROM  #TEMP_RESULTS_DISTINCT C WITH(NOLOCK) 
							  INNER JOIN #TEMP_DM_PLN_BIZPLAN_C A  WITH(NOLOCK)
						 ON A.DIVISION_ID   =  C.v_DIVISION_ID
						AND A.VERSION_NO    =  C.v_VERSION_NO 
						AND A.PROJECT_CODE  = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
						AND A.SCM_SITE_ID   = CASE WHEN (C.v_DIVISION_ID = '81') THEN  C.v_SCM_SITE_ID  ELSE  A.SCM_SITE_ID   END 
						AND A.PLANT_SITE_ID = C.v_PLANT_SITE_ID 
						AND A.ITEM_ID       = C.v_ITEM_ID 
						AND A.FCST_TYPE     = C.v_FCST_TYPE 
						AND A.DOM_EXP       = C.v_DOM_EXP 
						AND A.INCOTERMS     = C.v_INCOTERMS 
						AND A.CURRENCY      = C.v_CURRENCY 
						AND A.END_CUSTOMER  = C.v_END_CUSTOMER 
						AND A.YYYYMM        = C.v_YYYYMM 
						AND ISNULL(A.CELL_PROD_SITE, '-') = ISNULL(C.v_CELL_PROD_SITE, '-')
					  INNER JOIN #TEMP_DM_PLN_BIZPLAN_C B  WITH(NOLOCK) 
						 ON A.DIVISION_ID    = B.DIVISION_ID   
						AND A.VERSION_NO     = B.VERSION_NO    
						AND A.PROJECT_CODE   = B.PROJECT_CODE  
						AND A.SCM_SITE_ID    = B.SCM_SITE_ID   
						AND A.END_CUSTOMER   = B.END_CUSTOMER  
						AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID 
						AND A.ITEM_ID        = B.ITEM_ID       
						AND A.DOM_EXP        = B.DOM_EXP       
						AND A.FCST_TYPE      = B.FCST_TYPE     
						AND A.INCOTERMS      = B.INCOTERMS     
						AND ISNULL(A.CELL_PROD_SITE,'-') = ISNULL(B.CELL_PROD_SITE,'-')
						AND A.YYYYMM         = B.YYYYMM        
					  WHERE A.MEASURE = 'Business_Plan_Conf'         
						AND B.MEASURE = 'BizPlanPrice_Cur'   
					GROUP BY A.DIVISION_ID,A.VERSION_NO,A.PROJECT_CODE ,A.SCM_SITE_ID , A.END_CUSTOMER,A.PLANT_SITE_ID ,A.ITEM_ID       
						 , A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS ,A.CURRENCY,A.YYYYMM,A.CELL_PROD_SITE 
				  ) AA  
			  WHERE Z.DIVISION_ID    = AA.DIVISION_ID    
				AND Z.VERSION_NO     = AA.VERSION_NO    
				AND Z.PROJECT_CODE   = AA.PROJECT_CODE  
				AND Z.SCM_SITE_ID    = AA.SCM_SITE_ID   
				AND Z.END_CUSTOMER   = AA.END_CUSTOMER  
				AND Z.PLANT_SITE_ID  = AA.PLANT_SITE_ID 
				AND Z.ITEM_ID        = AA.ITEM_ID       
				AND Z.DOM_EXP        = AA.DOM_EXP       
				AND Z.FCST_TYPE      = AA.FCST_TYPE     
				AND Z.INCOTERMS      = AA.INCOTERMS    
				AND Z.CURRENCY       = AA.CURRENCY      
				AND ISNULL(Z.CELL_PROD_SITE, '-') = ISNULL(AA.CELL_PROD_SITE, '-')    
				AND Z.YYYYMM         = AA.YYYYMM 
				AND Z.MEASURE = 'SalesAmt_CUR'   
		END				 

		    
    PRINT ( 'A12--BizPlanPrice_KRW UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))  
		/*
		  BizPlanPrice_KRW 업데이트 
		*/     	
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS WITH(NOLOCK)
		 WHERE  v_MEASURE IN ('Business_Plan_Conf','BizPlanPrice_Cur' )   
	   ) > 0
		BEGIN
			UPDATE Z  
			   SET QTY = AA.STND_PRICE
				 , LAST_UPDATED_BY = AA.LAST_UPDATED_BY
				 , LAST_UPDATE_DATE = CONVERT(VARCHAR, GETDATE(), 120)
			     , CRUD_CD = 'U'  
			 FROM #TEMP_DM_PLN_BIZPLAN_C Z 
				, (
					SELECT A.DIVISION_ID,A.VERSION_NO,A.PROJECT_CODE ,A.SCM_SITE_ID , A.END_CUSTOMER,A.PLANT_SITE_ID ,A.ITEM_ID       
						 , A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS ,A.CURRENCY,A.YYYYMM,A.CELL_PROD_SITE ,C.v_LAST_UPDATED_BY AS LAST_UPDATED_BY
						 , A.QTY, A.QTY * ISNULL(B.STND_PRICE, 1) AS STND_PRICE 
					  FROM  #TEMP_RESULTS_DISTINCT C WITH(NOLOCK) 
							  INNER JOIN #TEMP_DM_PLN_BIZPLAN_C A  WITH(NOLOCK)
						 ON A.DIVISION_ID   =  C.v_DIVISION_ID
						AND A.VERSION_NO    =  C.v_VERSION_NO 
						AND A.PROJECT_CODE  = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
						AND A.SCM_SITE_ID   = CASE WHEN (C.v_DIVISION_ID = '81') THEN  C.v_SCM_SITE_ID  ELSE  A.SCM_SITE_ID   END 
						AND A.PLANT_SITE_ID = C.v_PLANT_SITE_ID 
						AND A.ITEM_ID       = C.v_ITEM_ID 
						AND A.FCST_TYPE     = C.v_FCST_TYPE 
						AND A.DOM_EXP       = C.v_DOM_EXP 
						AND A.INCOTERMS     = C.v_INCOTERMS 
						AND A.CURRENCY      = C.v_CURRENCY 
						AND A.END_CUSTOMER  = C.v_END_CUSTOMER 
						AND A.YYYYMM        = C.v_YYYYMM  
						AND ISNULL(A.CELL_PROD_SITE, '-') = ISNULL(C.v_CELL_PROD_SITE, '-') 
					  INNER JOIN DM_MST_METAL_CURRENCY_PRICE B  WITH(NOLOCK) 
						 ON A.DIVISION_ID    = B.DIVISION_ID   
						AND A.CURRENCY       = B.METAL_CURRENCY  
						AND A.YYYYMM         = B.STND_YM 
						AND B.METAL_CURRENCY_GBN = '1'    
					  WHERE A.MEASURE = 'BizPlanPrice_Cur'  
				  ) AA  
			  WHERE Z.DIVISION_ID    = AA.DIVISION_ID    
				AND Z.VERSION_NO     = AA.VERSION_NO    
				AND Z.PROJECT_CODE   = AA.PROJECT_CODE  
				AND Z.SCM_SITE_ID    = AA.SCM_SITE_ID   
				AND Z.END_CUSTOMER   = AA.END_CUSTOMER  
				AND Z.PLANT_SITE_ID  = AA.PLANT_SITE_ID 
				AND Z.ITEM_ID        = AA.ITEM_ID       
				AND Z.DOM_EXP        = AA.DOM_EXP       
				AND Z.FCST_TYPE      = AA.FCST_TYPE     
				AND Z.INCOTERMS      = AA.INCOTERMS    
				AND Z.CURRENCY       = AA.CURRENCY      
				AND ISNULL(Z.CELL_PROD_SITE, '-') = ISNULL(AA.CELL_PROD_SITE, '-')    
				AND Z.YYYYMM         = AA.YYYYMM 
				AND Z.MEASURE = 'BizPlanPrice_KRW'   
		END				 
		  		
    PRINT ( 'A13--SalesAmt_KRW UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))  			         
		/*
		  SalesAmt_KRW 업데이트 
		*/ 	   	
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS WITH(NOLOCK)
		 WHERE  v_MEASURE IN ('Business_Plan_Conf','BizPlanPrice_Cur','BizPlanPrice_KRW' )   
	   ) > 0	 
		BEGIN					
			UPDATE Z 
			   SET QTY = AA.AMT 
				 , LAST_UPDATED_BY = AA.LAST_UPDATED_BY
				 , LAST_UPDATE_DATE = CONVERT(VARCHAR, GETDATE(), 120)
			     , CRUD_CD = 'U'  
			 FROM #TEMP_DM_PLN_BIZPLAN_C Z 
				 , (
					SELECT A.DIVISION_ID,A.VERSION_NO,A.PROJECT_CODE ,A.SCM_SITE_ID , A.END_CUSTOMER,A.PLANT_SITE_ID ,A.ITEM_ID       
						 , A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS ,A.CURRENCY,A.YYYYMM,A.CELL_PROD_SITE ,MAX(C.v_LAST_UPDATED_BY) AS LAST_UPDATED_BY
						 , SUM(A.QTY * B.QTY) AMT
					  FROM  #TEMP_RESULTS_DISTINCT C WITH(NOLOCK) 
							  INNER JOIN #TEMP_DM_PLN_BIZPLAN_C A  WITH(NOLOCK)
						 ON A.DIVISION_ID   =  C.v_DIVISION_ID
						AND A.VERSION_NO    =  C.v_VERSION_NO 
						AND A.PROJECT_CODE  = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
						AND A.SCM_SITE_ID   = C.v_SCM_SITE_ID 
						AND A.PLANT_SITE_ID = C.v_PLANT_SITE_ID 
						AND A.ITEM_ID       = C.v_ITEM_ID 
						AND A.FCST_TYPE     = C.v_FCST_TYPE 
						AND A.DOM_EXP       = C.v_DOM_EXP 
						AND A.INCOTERMS     = C.v_INCOTERMS 
						AND A.CURRENCY      = C.v_CURRENCY 
						AND A.END_CUSTOMER  = C.v_END_CUSTOMER 
						AND A.YYYYMM        = C.v_YYYYMM  
						AND A.CELL_PROD_SITE = C.v_CELL_PROD_SITE 
					  INNER JOIN #TEMP_DM_PLN_BIZPLAN_C B  WITH(NOLOCK) 
						 ON A.DIVISION_ID    = B.DIVISION_ID   
						AND A.VERSION_NO     = B.VERSION_NO    
						AND A.PROJECT_CODE   = B.PROJECT_CODE  
						AND A.SCM_SITE_ID    = B.SCM_SITE_ID   
						AND A.END_CUSTOMER   = B.END_CUSTOMER  
						AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID 
						AND A.ITEM_ID        = B.ITEM_ID       
						AND A.DOM_EXP        = B.DOM_EXP       
						AND A.FCST_TYPE      = B.FCST_TYPE     
						AND A.INCOTERMS      = B.INCOTERMS     
						AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
						AND A.YYYYMM         = B.YYYYMM        
					  WHERE A.MEASURE = 'Business_Plan_Conf'         
						AND B.MEASURE = 'BizPlanPrice_KRW'  
					GROUP BY A.DIVISION_ID,A.VERSION_NO,A.PROJECT_CODE ,A.SCM_SITE_ID , A.END_CUSTOMER,A.PLANT_SITE_ID ,A.ITEM_ID       
						 , A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS ,A.CURRENCY,A.YYYYMM,A.CELL_PROD_SITE
				  ) AA  
			  WHERE Z.DIVISION_ID    = AA.DIVISION_ID    
				AND Z.VERSION_NO     = AA.VERSION_NO    
				AND Z.PROJECT_CODE   = AA.PROJECT_CODE  
				AND Z.SCM_SITE_ID    = AA.SCM_SITE_ID   
				AND Z.END_CUSTOMER   = AA.END_CUSTOMER  
				AND Z.PLANT_SITE_ID  = AA.PLANT_SITE_ID 
				AND Z.ITEM_ID        = AA.ITEM_ID       
				AND Z.DOM_EXP        = AA.DOM_EXP       
				AND Z.FCST_TYPE      = AA.FCST_TYPE     
				AND Z.INCOTERMS      = AA.INCOTERMS    
				AND Z.CURRENCY       = AA.CURRENCY      
				AND ISNULL(Z.CELL_PROD_SITE, '-') = ISNULL(AA.CELL_PROD_SITE, '-')    
				AND Z.YYYYMM         = AA.YYYYMM 
				AND Z.MEASURE = 'SalesAmt_KRW'   	
		END				 
		 
		 
    PRINT ( 'A14--TOTAL_PRICE UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))  					         
		/*
		  TOTAL_PRICE 업데이트 
		*/    	
	IF (SELECT COUNT(1)  
		  FROM #TEMP_RESULTS  WITH(NOLOCK)
		 WHERE v_MEASURE       = 'BizPlanPrice_Cur' 
		   AND v_CNT > 0	
	   ) > 0	 
		BEGIN						
			UPDATE A 
			   SET TOTAL_PRICE = CAST(C.v_QTY AS NVARCHAR(100))
				 , LAST_UPDATED_BY = C.v_LAST_UPDATED_BY
				 , LAST_UPDATE_DATE = CONVERT(VARCHAR, GETDATE(), 120)		
			     , CRUD_CD = 'U'   
			   FROM #TEMP_DM_PLN_BIZPLAN_C A 
				  , #TEMP_RESULTS C WITH(NOLOCK)  
			  WHERE 1 = 1   
				AND C.v_MEASURE       = 'BizPlanPrice_Cur'   
				AND A.DIVISION_ID   =  C.v_DIVISION_ID
				AND A.VERSION_NO    =  C.v_VERSION_NO 
				AND A.PROJECT_CODE  = CASE WHEN (C.v_DIVISION_ID = '40') THEN  A.PROJECT_CODE  ELSE  C.v_PROJECT_CODE  END
				AND A.SCM_SITE_ID   = CASE WHEN (C.v_DIVISION_ID = '81') THEN  C.v_SCM_SITE_ID  ELSE  A.SCM_SITE_ID   END 
				AND A.PLANT_SITE_ID = C.v_PLANT_SITE_ID 
				AND A.ITEM_ID       = C.v_ITEM_ID 
				AND A.FCST_TYPE     = C.v_FCST_TYPE 
				AND A.DOM_EXP       = C.v_DOM_EXP 
				AND A.INCOTERMS     = C.v_INCOTERMS 
				AND A.CURRENCY      = C.v_CURRENCY 
				AND A.END_CUSTOMER  = C.v_END_CUSTOMER 
				AND A.YYYYMM        = C.v_YYYYMM  
				AND ISNULL(A.CELL_PROD_SITE, '-') = ISNULL(C.v_CELL_PROD_SITE, '-')		
		END			
		  
	    PRINT ( 'A15--MERGE' + CONVERT(NVARCHAR(30), GETDATE(), 121))  
		 
	--	  SELECT *
	--	  FROM #TEMP_DM_PLN_BIZPLAN_C  WITH(NOLOCK)
	--	 WHERE  CRUD_CD IN ('I','U')  
	/*       SELECT A.*,B.*
         FROM 		  DM_PLN_BIZPLAN_C A
		INNER JOIN  #TEMP_DM_PLN_BIZPLAN_C B
			   ON (	A.DIVISION_ID	    = B.DIVISION_ID
			  AND   A.VERSION_NO        = B.VERSION_NO
			  AND   A.PROJECT_CODE      = B.PROJECT_CODE
			  AND   A.SCM_SITE_ID	    = B.SCM_SITE_ID
			  AND   A.END_CUSTOMER		= B.END_CUSTOMER
			  AND   A.PLANT_SITE_ID     = B.PLANT_SITE_ID
			  AND   A.ITEM_ID		    = B.ITEM_ID       
			  AND   A.DOM_EXP           = B.DOM_EXP
			  AND   A.FCST_TYPE         = B.FCST_TYPE
			  AND   A.INCOTERMS         = B.INCOTERMS
			  AND   A.CURRENCY          = B.CURRENCY
			  AND   A.CELL_PROD_SITE    = B.CELL_PROD_SITE
			  AND   A.YYYYMM            = B.YYYYMM
			  AND   A.MEASURE           = B.MEASURE
			  AND   A.SEQ               = B.SEQ 
			  AND   B.CRUD_CD IN ('I','U')  )
*/

	IF (SELECT COUNT(1)  
		  FROM #TEMP_DM_PLN_BIZPLAN_C  WITH(NOLOCK)
		 WHERE  CRUD_CD IN ('I','U')  
	   ) > 0	 
		BEGIN		
		
			MERGE 
			 INTO dbo.DM_PLN_BIZPLAN_C A
			USING #TEMP_DM_PLN_BIZPLAN_C B
			   ON (	A.DIVISION_ID	    = B.DIVISION_ID
			  AND   A.VERSION_NO        = B.VERSION_NO
			  AND   A.PROJECT_CODE      = B.PROJECT_CODE
			  AND   A.SCM_SITE_ID	    = B.SCM_SITE_ID
			  AND   A.END_CUSTOMER		= B.END_CUSTOMER
			  AND   A.PLANT_SITE_ID     = B.PLANT_SITE_ID
			  AND   A.ITEM_ID		    = B.ITEM_ID       
			  AND   A.DOM_EXP           = B.DOM_EXP
			  AND   A.FCST_TYPE         = B.FCST_TYPE
			  AND   A.INCOTERMS         = B.INCOTERMS
			  AND   A.CURRENCY          = B.CURRENCY
			  AND   A.CELL_PROD_SITE    = B.CELL_PROD_SITE
			  AND   A.YYYYMM            = B.YYYYMM
			  AND   A.MEASURE           = B.MEASURE
			--  AND   A.SEQ               = B.SEQ  
				  ) 
			 WHEN   MATCHED AND B.CRUD_CD IN ('U')  THEN 
				  UPDATE
					  SET 
			              A.QTY	             = B.QTY
						, A.TOTAL_PRICE      = B.TOTAL_PRICE 
						, A.LAST_UPDATED_BY	 = B.LAST_UPDATED_BY
						, A.LAST_UPDATE_DATE = B.LAST_UPDATE_DATE
			 WHEN   NOT MATCHED AND B.CRUD_CD IN ('I','U')  THEN  
				  INSERT ( SEQ,DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
						,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY
						,MEASURE,YYYYMM,QTY
						,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID,EXT_INT
						,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK,CELL_PER_PACK,PERIOD_YYMM
						,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,TRANSFER_FLAG 
						 )  
				  VALUES ( B.SEQ,B.DIVISION_ID,B.VERSION_NO,B.CUTOFF_TYPE,B.CUTOFF_YYYYMMDD,B.DEPT_ID,B.PROJECT_CODE,B.SCM_SITE_ID
				        ,B.ITEM_ID,B.END_CUSTOMER,B.BIZ_TYPE,B.PLANT_SITE_ID,B.FCST_TYPE,B.DOM_EXP,B.INCOTERMS,B.ITEM_USE
						,B.UNIT_ENERGY,B.CURRENCY,B.MEASURE, B.YYYYMM, B.QTY 
						,B.PROJECT_NAME,B.CELL_PROD_SITE,B.EE_CORP_ID,B.CELL_CORP_ID,B.PACK_CORP_ID,B.EXT_INT 
						,B.PRODUCT_GROUP,B.ALT_SIM_YN,B.CELL_CODE,B.CELL_PER_MODULE,B.MODULE_PER_PACK,B.CELL_PER_PACK,B.PERIOD_YYMM 
						,B.SCENARIO_TYPE,B.BASE_PRICE,B.METAL_LINK_PRICE,B.METAL_LINK_YN,B.WORK_YYYYMMDD,B.OSP_YN 
						,B.CREATED_BY,B.CREATION_DATE,B.LAST_UPDATED_BY,B.LAST_UPDATE_DATE,B.TRANSFER_FLAG 
						 ); 
		END				
		
    PRINT ( 'A15--TOTAL_PRICE UPDATE' + CONVERT(NVARCHAR(30), GETDATE(), 121))  	
		
    END /* 대상건 처리 끝 */
		 	
 
	END_PKUPDATE:

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
      ROLLBACK TRANSACTION SAVE_DM_PLN_BP_FCST;
      -- ERROR LOG VALUE SAVE
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
     IF @v_log_message IS NULL
 SELECT 'success'
 --DROP TABLE #TEMP_BP_FCST_C


    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) + ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
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

			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) + ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        end