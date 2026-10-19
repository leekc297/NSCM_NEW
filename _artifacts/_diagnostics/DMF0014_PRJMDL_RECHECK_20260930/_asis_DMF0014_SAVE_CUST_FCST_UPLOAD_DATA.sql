
/*
 * Program ID   : DMF0014_SAVE_CUST_FCST_UPLOAD_DATA
 * Description  : SAVE CUST FCST UPLOAD DATA
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 03. 28    KHSONG     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022. 10. 26	   KDW2819	  [C20221024-000507]CUST FCST Upload 오류 수정
 *
 */

CREATE PROCEDURE [dbo].[DMF0014_SAVE_CUST_FCST_UPLOAD_DATA]
	@p_active_flag				NVARCHAR(MAX),		
	@p_division_id				NVARCHAR(MAX),
	@p_scm_site_id				NVARCHAR(MAX),
	@p_customer_project_code	NVARCHAR(MAX),
	@p_customer_model			NVARCHAR(MAX),
	@p_incoterms				NVARCHAR(MAX),
	@p_fcst_type 				NVARCHAR(MAX),
	@p_dom_exp					NVARCHAR(MAX),		
	@p_measure_group     		NVARCHAR(MAX),
	@p_measure					NVARCHAR(MAX),
	@p_plant_site_id			NVARCHAR(MAX),
	@p_upload_uom				NVARCHAR(MAX),
	@p_project_code				NVARCHAR(MAX),
	@p_item_id					NVARCHAR(MAX),
	@p_yyyymmdd					NVARCHAR(MAX),
	@p_qty						NVARCHAR(MAX),
	@p_created_by				NVARCHAR(MAX)


AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;


	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	-- 멀티처리 변수선언
	DECLARE @v_active_flag				NVARCHAR(MAX);		
	DECLARE @v_division_id				NVARCHAR(MAX);
	DECLARE @v_scm_site_id				NVARCHAR(MAX);
	DECLARE @v_customer_project_code	NVARCHAR(MAX);
	DECLARE @v_customer_model			NVARCHAR(MAX);
	DECLARE @v_incoterms				NVARCHAR(MAX);
	DECLARE @v_fcst_type 				NVARCHAR(MAX);
	DECLARE @v_dom_exp					NVARCHAR(MAX);		
	DECLARE @v_measure_group			NVARCHAR(MAX);
	DECLARE @v_measure					NVARCHAR(MAX);
	DECLARE @v_PLANT_SITE_ID   		    NVARCHAR(MAX);
	DECLARE @v_upload_uom       		NVARCHAR(MAX);
	DECLARE @v_project_code				NVARCHAR(MAX);
	DECLARE @v_item_id					NVARCHAR(MAX);
	DECLARE @v_yyyymmdd					NVARCHAR(MAX);
	DECLARE @v_qty						NVARCHAR(MAX);
	DECLARE @v_created_by				NVARCHAR(MAX);

	-- 초기화
	SET @v_active_flag				= NULL;		
	SET @v_division_id				= NULL;
	SET @v_scm_site_id				= NULL;
	SET @v_customer_project_code	= NULL;
	SET @v_customer_model			= NULL;
	SET @v_incoterms				= NULL;
	SET @v_fcst_type 				= NULL;
	SET @v_dom_exp					= NULL;		
	SET @v_measure_group			= NULL;
	SET @v_measure					= NULL;
	SET @v_PLANT_SITE_ID			= NULL;
	SET @v_upload_uom				= NULL;
	SET @v_project_code				= NULL;
	SET @v_item_id					= NULL;
	SET @v_yyyymmdd					= NULL;
	SET @v_qty						= NULL;
	SET @v_created_by				= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0014_SAVE_CUST_FCST_UPLOAD_DATA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	 -- 마지막 데이터 처리를 위한 구분자 추가
	 SET @p_active_flag            = RTRIM(@p_active_flag           ) + '^';
	 SET @p_division_id            = RTRIM(@p_division_id           ) + '^';
	 SET @p_scm_site_id            = RTRIM(@p_scm_site_id           ) + '^';
	 SET @p_customer_project_code  = RTRIM(@p_customer_project_code ) + '^';
	 SET @p_customer_model         = RTRIM(@p_customer_model        ) + '^';
	 SET @p_incoterms              = RTRIM(@p_incoterms             ) + '^';
	 SET @p_fcst_type              = RTRIM(@p_fcst_type             ) + '^';
	 SET @p_dom_exp                = RTRIM(@p_dom_exp               ) + '^';
	 SET @p_measure_group          = RTRIM(@p_measure_group         ) + '^';
	 SET @p_measure                = RTRIM(@p_measure               ) + '^';
	 SET @p_plant_site_id          = RTRIM(@p_plant_site_id         ) + '^';
	 SET @p_upload_uom             = RTRIM(@p_upload_uom            ) + '^';
	 SET @p_project_code           = RTRIM(@p_project_code          ) + '^';
	 SET @p_item_id                = RTRIM(@p_item_id               ) + '^';
	 SET @p_yyyymmdd               = RTRIM(@p_yyyymmdd              ) + '^';
	 SET @p_qty                    = RTRIM(@p_qty                   ) + '^';
	 SET @p_created_by             = RTRIM(@p_created_by            ) + '^';

	-- @results TEMP TABLE
	DECLARE @results TABLE (
             v_active_flag             NVARCHAR(MAX)
			,v_division_id             NVARCHAR(MAX)
			,v_scm_site_id             NVARCHAR(MAX)
			,v_customer_project_code   NVARCHAR(MAX)
			,v_customer_model          NVARCHAR(MAX)
			,v_incoterms               NVARCHAR(MAX)
			,v_fcst_type               NVARCHAR(MAX)
			,v_dom_exp                 NVARCHAR(MAX)
			,v_measure_group           NVARCHAR(MAX)
			,v_measure                 NVARCHAR(MAX)
			,v_plant_site_id           NVARCHAR(MAX)
			,v_upload_uom              NVARCHAR(MAX)
			,v_project_code            NVARCHAR(MAX)
			,v_item_id                 NVARCHAR(MAX)
			,v_yyyymmdd                NVARCHAR(MAX)
			,v_qty                     NVARCHAR(MAX)
			,v_created_by              NVARCHAR(MAX)
                           )

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRANSACTION DMF0014_SAVE_CUST_FCST_UPLOAD;  

		BEGIN TRY
		

--===================================================================================== @results 테이블에 split후 insert start
	--###############################################  @results 테이블에 split후 insert (START)
	WHILE LEN(@p_DIVISION_ID) > 0
	BEGIN

	 DECLARE @index_active_flag              INT
	 DECLARE @index_division_id              INT
	 DECLARE @index_scm_site_id              INT
	 DECLARE @index_customer_project_code    INT
	 DECLARE @index_customer_model           INT
	 DECLARE @index_incoterms                INT
	 DECLARE @index_fcst_type                INT
	 DECLARE @index_dom_exp                  INT
	 DECLARE @index_measure_group            INT
	 DECLARE @index_measure                  INT
	 DECLARE @index_plant_site_id            INT
	 DECLARE @index_upload_uom               INT
	 DECLARE @index_project_code             INT
	 DECLARE @index_item_id                  INT
	 DECLARE @index_yyyymmdd                 INT
	 DECLARE @index_qty                      INT
	 DECLARE @index_created_by               INT

	 SET @index_active_flag           = PATINDEX('%' + '^' + '%', @p_active_flag           )
	 SET @index_division_id           = PATINDEX('%' + '^' + '%', @p_division_id           )
	 SET @index_scm_site_id           = PATINDEX('%' + '^' + '%', @p_scm_site_id           )
	 SET @index_customer_project_code = PATINDEX('%' + '^' + '%', @p_customer_project_code )
	 SET @index_customer_model        = PATINDEX('%' + '^' + '%', @p_customer_model        )
	 SET @index_incoterms             = PATINDEX('%' + '^' + '%', @p_incoterms             )
	 SET @index_fcst_type             = PATINDEX('%' + '^' + '%', @p_fcst_type             )
	 SET @index_dom_exp               = PATINDEX('%' + '^' + '%', @p_dom_exp               )
	 SET @index_measure_group         = PATINDEX('%' + '^' + '%', @p_measure_group         )
	 SET @index_measure               = PATINDEX('%' + '^' + '%', @p_measure               )
	 SET @index_plant_site_id         = PATINDEX('%' + '^' + '%', @p_plant_site_id         )
	 SET @index_upload_uom            = PATINDEX('%' + '^' + '%', @p_upload_uom            )
	 SET @index_project_code          = PATINDEX('%' + '^' + '%', @p_project_code          )
	 SET @index_item_id               = PATINDEX('%' + '^' + '%', @p_item_id               )
	 SET @index_yyyymmdd              = PATINDEX('%' + '^' + '%', @p_yyyymmdd              )
	 SET @index_qty                   = PATINDEX('%' + '^' + '%', @p_qty                   )
	 SET @index_created_by            = PATINDEX('%' + '^' + '%', @p_created_by            )

	 --확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
		IF @index_DIVISION_ID > 0
			  BEGIN
			   SET @v_active_flag           = SUBSTRING(@p_active_flag          , 0, @index_active_flag            )
			   SET @v_division_id           = SUBSTRING(@p_division_id          , 0, @index_division_id            )
			   SET @v_scm_site_id           = SUBSTRING(@p_scm_site_id          , 0, @index_scm_site_id            )
			   SET @v_customer_project_code = SUBSTRING(@p_customer_project_code, 0, @index_customer_project_code  )
			   SET @v_customer_model        = SUBSTRING(@p_customer_model       , 0, @index_customer_model         )
			   SET @v_incoterms             = SUBSTRING(@p_incoterms            , 0, @index_incoterms              )
			   SET @v_fcst_type             = SUBSTRING(@p_fcst_type            , 0, @index_fcst_type              )
			   SET @v_dom_exp               = SUBSTRING(@p_dom_exp              , 0, @index_dom_exp                )
			   SET @v_measure_group         = SUBSTRING(@p_measure_group        , 0, @index_measure_group          )
			   SET @v_measure               = SUBSTRING(@p_measure              , 0, @index_measure                )
			   SET @v_plant_site_id         = SUBSTRING(@p_plant_site_id        , 0, @index_plant_site_id          )
			   SET @v_upload_uom            = SUBSTRING(@p_upload_uom           , 0, @index_upload_uom             )
			   SET @v_project_code          = SUBSTRING(@p_project_code         , 0, @index_project_code           )
			   SET @v_item_id               = SUBSTRING(@p_item_id              , 0, @index_item_id                )
			   SET @v_yyyymmdd              = SUBSTRING(@p_yyyymmdd             , 0, @index_yyyymmdd               )
			   SET @v_qty                   = SUBSTRING(@p_qty                  , 0, @index_qty                    )
			   SET @v_created_by            = SUBSTRING(@p_created_by           , 0, @index_created_by             )

			   SET @p_active_flag            = SUBSTRING(@p_active_flag           , LEN(@v_active_flag            + '^') + 1, LEN(@p_active_flag           ))
			   SET @p_division_id            = SUBSTRING(@p_division_id           , LEN(@v_division_id            + '^') + 1, LEN(@p_division_id           ))
			   SET @p_scm_site_id            = SUBSTRING(@p_scm_site_id           , LEN(@v_scm_site_id            + '^') + 1, LEN(@p_scm_site_id           ))
			   SET @p_customer_project_code  = SUBSTRING(@p_customer_project_code , LEN(@v_customer_project_code  + '^') + 1, LEN(@p_customer_project_code ))
			   SET @p_customer_model         = SUBSTRING(@p_customer_model        , LEN(@v_customer_model         + '^') + 1, LEN(@p_customer_model        ))
			   SET @p_incoterms              = SUBSTRING(@p_incoterms             , LEN(@v_incoterms              + '^') + 1, LEN(@p_incoterms             ))
			   SET @p_fcst_type              = SUBSTRING(@p_fcst_type             , LEN(@v_fcst_type              + '^') + 1, LEN(@p_fcst_type             ))
			   SET @p_dom_exp                = SUBSTRING(@p_dom_exp               , LEN(@v_dom_exp                + '^') + 1, LEN(@p_dom_exp               ))
			   SET @p_measure_group          = SUBSTRING(@p_measure_group         , LEN(@v_measure_group          + '^') + 1, LEN(@p_measure_group         ))
			   SET @p_measure                = SUBSTRING(@p_measure               , LEN(@v_measure                + '^') + 1, LEN(@p_measure               ))
			   SET @p_plant_site_id          = SUBSTRING(@p_plant_site_id         , LEN(@v_plant_site_id          + '^') + 1, LEN(@p_plant_site_id         ))
			   SET @p_upload_uom             = SUBSTRING(@p_upload_uom            , LEN(@v_upload_uom             + '^') + 1, LEN(@p_upload_uom            ))
			   SET @p_project_code           = SUBSTRING(@p_project_code          , LEN(@v_project_code           + '^') + 1, LEN(@p_project_code          ))
			   SET @p_item_id                = SUBSTRING(@p_item_id               , LEN(@v_item_id                + '^') + 1, LEN(@p_item_id               ))
			   SET @p_yyyymmdd               = SUBSTRING(@p_yyyymmdd              , LEN(@v_yyyymmdd               + '^') + 1, LEN(@p_yyyymmdd              ))
			   SET @p_qty                    = SUBSTRING(@p_qty                   , LEN(@v_qty                    + '^') + 1, LEN(@p_qty                   ))
			   SET @p_created_by             = SUBSTRING(@p_created_by            , LEN(@v_created_by             + '^') + 1, LEN(@p_created_by            ))


 
			   INSERT INTO @results ( 
					  v_active_flag          
					 ,v_division_id          
					 ,v_scm_site_id          
					 ,v_customer_project_code
					 ,v_customer_model       
					 ,v_incoterms            
					 ,v_fcst_type            
					 ,v_dom_exp              
					 ,v_measure_group        
					 ,v_measure              
					 ,v_plant_site_id        
					 ,v_upload_uom           
					 ,v_project_code         
					 ,v_item_id              
					 ,v_yyyymmdd             
					 ,v_qty                  
					 ,v_created_by           
			   ) VALUES ( 
					  @v_active_flag          
					 ,@v_division_id          
					 ,@v_scm_site_id          
					 ,@v_customer_project_code
					 ,@v_customer_model       
					 ,@v_incoterms            
					 ,@v_fcst_type            
					 ,@v_dom_exp              
					 ,@v_measure_group        
					 ,@v_measure              
					 ,@v_plant_site_id        
					 ,@v_upload_uom           
					 ,@v_project_code         
					 ,@v_item_id              
					 ,@v_yyyymmdd             
					 ,@v_qty                  
					 ,@v_created_by           
			   )
			  END
		ELSE
			  BEGIN
			   SET @v_DIVISION_ID = @p_DIVISION_ID
			   SET @p_DIVISION_ID = NULL
 
			   INSERT INTO @results ( 
					  v_active_flag          
					 ,v_division_id          
					 ,v_scm_site_id          
					 ,v_customer_project_code
					 ,v_customer_model       
					 ,v_incoterms            
					 ,v_fcst_type            
					 ,v_dom_exp              
					 ,v_measure_group        
					 ,v_measure              
					 ,v_plant_site_id        
					 ,v_upload_uom           
					 ,v_project_code         
					 ,v_item_id              
					 ,v_yyyymmdd             
					 ,v_qty                  
					 ,v_created_by           
			   ) VALUES ( 
					  @v_active_flag          
					 ,@v_division_id          
					 ,@v_scm_site_id          
					 ,@v_customer_project_code
					 ,@v_customer_model       
					 ,@v_incoterms            
					 ,@v_fcst_type            
					 ,@v_dom_exp              
					 ,@v_measure_group        
					 ,@v_measure              
					 ,@v_plant_site_id        
					 ,@v_upload_uom           
					 ,@v_project_code         
					 ,@v_item_id              
					 ,@v_yyyymmdd             
					 ,@v_qty                  
					 ,@v_created_by           
			   )
	  END
	-- if end

	END
		--###############################################   @results 테이블에 split후 insert (END)

			   -- Customer Project,Customer Model  잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
			   --IF (select count(1)  from @results where ( select count(1) from dbo.DM_MST_CUSTOMER_MODEL  
			   --    where DIVISION_ID  = v_DIVISION_ID AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) = 0
				  -- AND
				  -- (select count(1)  from @results where ( select count(1) from dbo.SCM_MST_SITE_ITEM  
			   --    where DIVISION_ID  = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) > 0
			   --begin
				  -- SET @v_log_type = 'INVALID';
				  -- SELECT '['+ @v_customer_project_code +']'+ N' Invalid Customer Project !';
				  -- goto err_rtn
			   --end

			   --IF (select count(1)  from @results where ( select count(1) from dbo.DM_MST_CUSTOMER_MODEL  
			   --    where DIVISION_ID  = v_DIVISION_ID AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE AND CUSTOMER_MODEL = v_CUSTOMER_MODEL AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) = 0
				  -- AND
				  -- (select count(1)  from @results where ( select count(1) from dbo.SCM_MST_SITE_ITEM  
			   --    where DIVISION_ID  = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE AND ITEM_ID = v_CUSTOMER_MODEL AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) > 0
			   --begin
				  -- SET @v_log_type = 'INVALID';
				  -- SELECT '['+ @v_customer_project_code +']'+ N' Invalid Customer Model !';
				  -- goto err_rtn
			   --end

			   -- Customer Project,Customer Model  잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------

--SELECT * FROM @results
	--===================================================================================== insert 전 delete start
	BEGIN
			   -- 확인  select * from @results
			   DELETE 
			   FROM dbo.DM_PLN_CUSTOMER_PSI
			   WHERE (
						SELECT count(1) 
						  FROM @results 
						 where 1=1
						   and DIVISION_ID            =   v_DIVISION_ID            
						   AND CUSTOMER_PROJECT_CODE  =   v_CUSTOMER_PROJECT_CODE
						   AND CUSTOMER_MODEL         =   v_CUSTOMER_MODEL       
						   AND SCM_SITE_ID            =   v_SCM_SITE_ID          
						   AND DOM_EXP                =   v_DOM_EXP              
						   AND FCST_TYPE              =   v_FCST_TYPE            
						   AND MEASURE_GROUP          =   v_MEASURE_GROUP        
						   AND MEASURE                =   v_MEASURE              
						   AND YYYYMMDD               =   v_YYYYMMDD             
						   AND INCOTERMS              =   v_INCOTERMS            
						   AND PLANT_SITE_ID          =   v_PLANT_SITE_ID        
					  ) > 0;
	END

	--===================================================================================== insert 전 delete end

	--===================================================================================== insert start
	BEGIN
		  
			   INSERT INTO dbo.DM_PLN_CUSTOMER_PSI
			   SELECT 
					   v_DIVISION_ID          
					  ,v_CUSTOMER_PROJECT_CODE
					  ,v_CUSTOMER_MODEL       
					  ,v_SCM_SITE_ID          
					  ,v_DOM_EXP              
					  ,v_FCST_TYPE            
					  ,v_MEASURE_GROUP        
					  ,v_MEASURE              
					  ,v_YYYYMMDD             
					  ,v_INCOTERMS            
					  ,v_PLANT_SITE_ID        
					  ,v_PROJECT_CODE         
					  ,v_ITEM_ID              
					  ,v_QTY                  
					  ,v_UPLOAD_UOM           
					  ,v_CREATED_BY           
					  ,getdate()
					  ,v_CREATED_BY
					  ,getdate()
					  ,'UI' --BATCH_RESULT           
					  ,null --MST_UPLOAD_UOM         
					  ,null --MST_UPLOAD_BUCKET_TYPE 
					  ,null --MST_SUMMARY_BUCKET_TYPE
					  ,null --MST_CONVERT_QTY        
					  ,null --PLAN_WEEK              
					  ,null --SPLIT_RESULT           
					  ,null,null,null,null,null,null,null,null,null,null
			  FROM @results 

	END;

	--===================================================================================== insert end

	       -- 시작과 종료일자 사이에 정보를 일괄 update 함. added by ytchoi 180314
			with update_target as(
			select 
				  division_id, 
				  scm_site_id,
				  customer_project_code,
				  customer_model,
				  incoterms,
				  fcst_type,
				  dom_exp,
				  measure_group,
				  measure,
				  PLANT_SITE_ID,
				  min(yyyymmdd) min_yyyymmdd,
				  max(yyyymmdd)	max_yyyymmdd	
			  from dbo.DM_PLN_CUSTOMER_PSI A
			 where batch_result = 'UI'
			group by division_id, 
				  scm_site_id,
				  customer_project_code,
				  customer_model,
				  incoterms,
				  fcst_type,
				  dom_exp,
				  measure_group,
				  measure,
				  PLANT_SITE_ID
				  )	
			update  [dbo].[DM_PLN_CUSTOMER_PSI]
			   set batch_result = 'UI'
			 where (
					 select count(1)
					   from update_target a
					  where a.division_id            = [dbo].[DM_PLN_CUSTOMER_PSI].division_id          
						and a.scm_site_id            = [dbo].[DM_PLN_CUSTOMER_PSI].scm_site_id          
						and a.customer_project_code  = [dbo].[DM_PLN_CUSTOMER_PSI].customer_project_code
						and a.customer_model         = [dbo].[DM_PLN_CUSTOMER_PSI].customer_model       
						and a.incoterms              = [dbo].[DM_PLN_CUSTOMER_PSI].incoterms            
						and a.fcst_type              = [dbo].[DM_PLN_CUSTOMER_PSI].fcst_type            
						and a.dom_exp                = [dbo].[DM_PLN_CUSTOMER_PSI].dom_exp              
						and a.measure_group          = [dbo].[DM_PLN_CUSTOMER_PSI].measure_group        
						and a.measure                = [dbo].[DM_PLN_CUSTOMER_PSI].measure              
						and a.PLANT_SITE_ID          = [dbo].[DM_PLN_CUSTOMER_PSI].PLANT_SITE_ID    
						and [dbo].[DM_PLN_CUSTOMER_PSI].yyyymmdd between a.min_yyyymmdd and a.max_yyyymmdd
				   ) > 0
			;

	--===================================================================================== HISTORY INSERT start
	BEGIN
		  
			   INSERT INTO dbo.DM_PLN_CUSTOMER_PSI_H
			   SELECT 
					 v_division_id 
					,NEXT VALUE FOR SEQ1_DM_PLN_CUSTOMER_PSI_H
					,v_CUSTOMER_PROJECT_CODE		
					,v_CUSTOMER_MODEL				
					,v_SCM_SITE_ID					
					,v_DOM_EXP						
					,v_FCST_TYPE					
					,v_MEASURE_GROUP				
					,v_MEASURE						
					,v_YYYYMMDD					
					,v_INCOTERMS					
					,v_PLANT_SITE_ID				
					,v_PROJECT_CODE				
					,v_ITEM_ID						
					,CONVERT(NUMERIC(20, 10), v_QTY)
					,v_UPLOAD_UOM					
					,v_CREATED_BY      
					,getdate()
					,v_CREATED_BY 
					,getdate()
					,'UI',null,null,null,null,null,null
					,null,null,null,null,null,null,null,null,null,null
					FROM @results 

	END

	--===================================================================================== HISTORY INSERT end

		BEGIN
	        EXEC [dbo].[PR_DM_PLN_CUST_FCST_TO_MKT_FCST];
        END;

		COMMIT WORK;

		END TRY
		
	BEGIN CATCH
      -- ERROR LOG
      ROLLBACK TRANSACTION DMF0014_SAVE_CUST_FCST_UPLOAD;  
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  
    END CATCH;
		
	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;						

	-- 트랜잭션 (END)
	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION DMF0014_SAVE_CUST_FCST_UPLOAD;
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end


