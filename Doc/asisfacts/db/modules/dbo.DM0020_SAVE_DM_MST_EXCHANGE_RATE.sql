
/*
 * Program ID   : DM0020_SAVE_DM_MST_EXCHANGE_RATE
 * Description  : DM0020_SalesFuturePricePopUp ('DM_MST_EXCHANGE_RATE' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[DM0020_SAVE_DM_MST_EXCHANGE_RATE]

	-- Add the parameters for the stored procedure here
    @p_active_flag            NVARCHAR(MAX),    
	@p_division_id              NVARCHAR(30),
    @p_YYYYMMDD               NVARCHAR(MAX),    
    @p_CURRENCY               NVARCHAR(MAX),    
    @p_UNIT_CURRENCY          NVARCHAR(MAX),    
    @p_EXCHANGE_PRICE         NVARCHAR(MAX),    
    @p_CREATED_BY             NVARCHAR(MAX),    
    @p_CREATION_DATE          DATETIME,
    @p_LAST_UPDATED_BY        NVARCHAR(MAX)    

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0020_SAVE_DM_MST_EXCHANGE_RATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

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
   	    -- (2) 	 
	    BEGIN

		   ------
           IF @p_active_flag = 'D'
		   ------
			-- (4) 	 
           /* DELETE */
		   BEGIN
           
		       DELETE 
                 FROM [dbo].DM_MST_EXCHANGE_RATE
               WHERE
						DIVISION_ID        =   @p_division_id    
                   AND    YYYYMMDD        =   @p_YYYYMMDD          
                   AND CURRENCY        =   @p_CURRENCY       
                   AND UNIT_CURRENCY   =   @p_UNIT_CURRENCY       
		   END
			-- (4) 	 
		   ------
		   ELSE
		   ------
			-- (10) 	 
           /* UPDATE OR INSERT */
		   BEGIN
					
					MERGE INTO [dbo].DM_MST_EXCHANGE_RATE A
					USING (
							SELECT 
								@p_division_id			AS DIVISION_ID,
								@p_YYYYMMDD	            as YYYYMMDD, 
								@p_CURRENCY    	        as CURRENCY, 
								@p_UNIT_CURRENCY		as UNIT_CURRENCY
						  ) B
					ON(
                                A.DIVISION_ID        =   @p_division_id    
							AND   A.YYYYMMDD        =   @p_YYYYMMDD     
                            AND A.CURRENCY        =   B.CURRENCY       
                            AND A.UNIT_CURRENCY   =   B.UNIT_CURRENCY       
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
								    DIVISION_ID	     = @p_division_id
								   ,YYYYMMDD	     = @p_YYYYMMDD
								   ,CURRENCY         = @p_CURRENCY
								   ,UNIT_CURRENCY	 = @p_UNIT_CURRENCY 
								   ,EXCHANGE_PRICE   = @p_EXCHANGE_PRICE
								   ,CREATED_BY       = @p_CREATED_BY
								   --,CREATION_DATE    = @p_CREATION_DATE
								   ,LAST_UPDATED_BY	 = @p_LAST_UPDATED_BY
								   ,LAST_UPDATE_DATE = sysdatetime()
					                
					WHEN NOT MATCHED THEN

					     INSERT 
								  ( DIVISION_ID
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
						            @p_division_id 
								   ,@p_YYYYMMDD
								   ,@p_CURRENCY
								   ,@p_UNIT_CURRENCY
								   ,@p_EXCHANGE_PRICE
								   ,@p_CREATED_BY
								   ,sysdatetime()  
								   ,@p_LAST_UPDATED_BY
								   ,sysdatetime()
								);
		   ------
		   END
		   ------
			-- (10) 	 


		   END
		   ------
		-- (2) 	 

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
