
/*
 * Program ID   : DM0020_SAVE_SCM_MST_FUTURE_PRICE
 * Description  : DM0020_SalesFuturePricePopUp ('SCM_MST_FUTURE_PRICE' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2017. 03. 13    JHBAEK			INPUT KEY VALUE(PROJECT_CODE, MODEL) VALIDATION CHECK
 *                                  : PROJECT_CODE, MODEL(ITEM) 값을 수기로 입력할 수 있기에 INSERT 전에 VALIDATION CHECK를 한다.
 *
 */

CREATE PROCEDURE [dbo].[DM0020_SAVE_SCM_MST_FUTURE_PRICE]

	-- Add the parameters for the stored procedure here
    @p_active_flag             NVARCHAR(MAX),    
    @p_DIVISION_ID             NVARCHAR(MAX),    
    @p_PROJECT_CODE            NVARCHAR(MAX),    
    @p_SCM_SITE_ID             NVARCHAR(MAX), 
	@p_plant_site_id           NVARCHAR(30),
    @p_ITEM_ID                 NVARCHAR(MAX),    
    @p_YYYYMMDD                NVARCHAR(MAX),    
    @p_CURRENCY                NVARCHAR(MAX), 
    @p_MEASURE                 NVARCHAR(MAX), 
    @p_DOM_EXP                 NVARCHAR(MAX), 
    @p_FCST_TYPE               NVARCHAR(MAX), 
    @p_INCOTERMS               NVARCHAR(MAX),
    @p_PRICE                   NVARCHAR(MAX),    
    @p_CREATED_BY              NVARCHAR(MAX),    
    @p_CREATION_DATE           datetime,   
    @p_LAST_UPDATED_BY         NVARCHAR(MAX)    

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0020_SAVE_SCM_MST_FUTURE_PRICE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## StartEDED of procedure ##########-' + @p_PROJECT_CODE + '-' + @p_ITEM_ID ;
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

	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
		   IF (select count(1) from dbo.scm_mst_project  where project_code  = @p_PROJECT_CODE ) = 0 
		   begin
		       SET @v_log_type = 'INVALID';
			   SELECT '['+ @p_PROJECT_CODE +']'+ N' Invalid Project Code !';
			   goto err_rtn
		   end

		   IF (select count(1) from dbo.SCM_MST_ITEM_SN  where ITEM_ID  = @p_ITEM_ID ) = 0 
		   begin
		       SET @v_log_type = 'INVALID';
			   SELECT '['+ @p_ITEM_ID +']'+ N' Invalid Item ID !';
			   goto err_rtn
		   end
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------

		   ------ HISTORY 생성
		   BEGIN
			  EXEC [dbo].[PR_DM_ANL_SALES_PRICE_HIST]
			  						 @p_division_id   
				  					,@p_project_code  
	                                ,@p_scm_site_id   
	                                ,@p_plant_site_id 
	                                ,@p_item_id       
	                                ,@p_yyyymmdd      
	                                ,@p_currency      
	                                ,@p_measure       
	                                ,@p_dom_exp       
	                                ,@p_fcst_type     
	                                ,@p_incoterms     
	                                ,@p_price         
	                                ,@p_created_by    
	                                ,@p_last_updated_by
		   END

		   ------
           IF @p_active_flag = 'D'
		   ------
           
			-- (4) 	 
           /* DELETE */
		   BEGIN
           
		   DELETE 
           FROM [dbo].SCM_MST_FUTURE_PRICE
           WHERE
                   DIVISION_ID        =   @p_DIVISION_ID         
               AND PROJECT_CODE       =   @p_PROJECT_CODE      
               AND SCM_SITE_ID        =   @p_SCM_SITE_ID     
			   and plant_site_id      =   @p_plant_site_id 
               AND ITEM_ID            =   @p_ITEM_ID     
               AND YYYYMMDD           =   @p_YYYYMMDD      
               AND CURRENCY           =   @p_CURRENCY      
               AND MEASURE            =   @p_MEASURE      
               AND DOM_EXP            =   @p_DOM_EXP      
               AND FCST_TYPE          =   @p_FCST_TYPE      
               AND INCOTERMS          =   @p_INCOTERMS      
		   END
			-- (4) 	 

		   ------
		   ELSE
		   ------
			-- (10) 	 
           /* UPDATE OR INSERT */
		   BEGIN
					MERGE INTO [dbo].SCM_MST_FUTURE_PRICE A
					USING (
							SELECT 
								@p_DIVISION_ID	    as DIVISION_ID, 
								@p_PROJECT_CODE    	as PROJECT_CODE, 
								@p_SCM_SITE_ID		as SCM_SITE_ID,
								@p_plant_SITE_ID	as plant_SITE_ID,
								@p_ITEM_ID		    as ITEM_ID,
								@p_YYYYMMDD	   	    as YYYYMMDD,
								@p_CURRENCY		    as CURRENCY,
								@p_MEASURE		    as MEASURE,
								@p_DOM_EXP		    as DOM_EXP,
								@p_FCST_TYPE	    as FCST_TYPE,
								@p_INCOTERMS		as INCOTERMS
						  ) B
					ON(
                                A.DIVISION_ID        =   B.DIVISION_ID          
                            AND A.PROJECT_CODE       =   B.PROJECT_CODE       
                            AND A.SCM_SITE_ID        =   B.SCM_SITE_ID       
							AND A.plant_SITE_ID      =   B.plant_SITE_ID       
                            AND A.ITEM_ID            =   B.ITEM_ID       
                            AND A.YYYYMMDD           =   B.YYYYMMDD       
                            AND A.CURRENCY           =   B.CURRENCY       
                            AND A.MEASURE            =   B.MEASURE       
                            AND A.DOM_EXP            =   B.DOM_EXP       
                            AND A.FCST_TYPE          =   B.FCST_TYPE       
                            AND A.INCOTERMS          =   B.INCOTERMS       
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
 									 DIVISION_ID         =  @p_DIVISION_ID    
									,PROJECT_CODE        =  @p_PROJECT_CODE   
									,SCM_SITE_ID         =  @p_SCM_SITE_ID    
									,plant_SITE_ID       =  @p_plant_SITE_ID    
									,ITEM_ID             =  @p_ITEM_ID        
									,YYYYMMDD            =  @p_YYYYMMDD       
									,CURRENCY            =  @p_CURRENCY       
									,MEASURE             =  @p_MEASURE       
									,DOM_EXP             =  @p_DOM_EXP
									,FCST_TYPE           =  @p_FCST_TYPE
									,INCOTERMS           =  @p_INCOTERMS      
									,PRICE               =  @p_PRICE          
									,CREATED_BY          =  @p_CREATED_BY     
									--,CREATION_DATE       =  @p_CREATION_DATE  
									,LAST_UPDATED_BY     =  @p_LAST_UPDATED_BY
									,LAST_UPDATE_DATE    =  sysdatetime()     

					WHEN NOT MATCHED THEN

					     INSERT 
								  ( DIVISION_ID     
								   ,PROJECT_CODE    
								   ,SCM_SITE_ID     
								   ,plant_SITE_ID   
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
									  @p_DIVISION_ID    
								   ,@p_PROJECT_CODE   
								   ,@p_SCM_SITE_ID    
								   ,@p_plant_SITE_ID   
								   ,@p_ITEM_ID        
								   ,@p_YYYYMMDD       
								   ,@p_CURRENCY       
								   ,@p_MEASURE      
								   ,@p_DOM_EXP      
								   ,@p_FCST_TYPE      
								   ,@p_INCOTERMS      
								   ,@p_PRICE          
								   ,@p_CREATED_BY     
								   ,sysdatetime()    
								   ,@p_LAST_UPDATED_BY
								   ,sysdatetime()     
								);
		   ------
		   END
		   ------
			-- (10) 	 

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
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

  	--------------------------------------------------------------	
  	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION;
		end
	--------------------------------------------------------------	
