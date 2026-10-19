/*
 * Program ID   : PR_SSP_XIF_FP_AMEND_SHIPAVAL
 * Description  : G480 폴란드 법인 FP Ship Avaliable I/F 수신 반영 (Every 2 min)  
 * OutTable     : XIF_FP_AMEND_SHIPAVAL_R --> SSP_DNM_FP_AMEND_SHIPAVAL
 * Execute      : 
 * Program History
 *===================================================================================================
 * Date         In Charge      Description
 *===================================================================================================
 * 20240129     jilee          Create.  
 *
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_FP_AMEND_SHIPAVAL]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_FP_AMEND_SHIPAVAL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_FP_AMEND_SHIPAVAL'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_FP_AMEND_SHIPAVAL INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

	DECLARE @v_count          INT  = 0 ;
	declare @v_sum_date     nvarchar(8) = convert(nvarchar, getdate(), 112);

	DECLARE @INX					INT	= 0;
    DECLARE @MAX_NUM				INT	= 0;

	DECLARE @XIF_FP_AMEND_SHIPAVAL_R TABLE (
	    TID						INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[IF_SEQ] [nvarchar](50) NOT NULL,
		[IF_TYPE] [nvarchar](1) NOT NULL,
		[IF_ID] [nvarchar](50) NOT NULL,
		[IF_RCV_DATE] [datetime] NOT NULL,
		[PROC_FLAG] [nvarchar](1) NOT NULL,
		[PROC_DATE] [datetime] NULL,
		[PROC_MSG] [nvarchar](1000) NULL,
		[INSTANCE_ID] [nvarchar](20) NOT NULL,
		[PLAN_ID] [nvarchar](200) NOT NULL,
		[AMEND_PLAN_ID] [nvarchar](40) NOT NULL,
		[COMPANY_ID] [nvarchar](40) NULL,
		[DIVISION_ID] [nvarchar](40) NULL,
		[SITE_ID] [nvarchar](40) NULL,
		[FROM_SITE_ID] [nvarchar](40) NULL,
		[CATEGORY_ID] [nvarchar](100) NOT NULL,
		[MODEL_ID] [nvarchar](40) NULL,
		[CELL_GROUP] [nvarchar](40) NULL,
		[ITEM_ID] [nvarchar](40) NOT NULL,
		[PLAN_DATE] [nvarchar](8) NOT NULL,
		[OUT_QTY] [numeric](18, 3) NULL,
		[ATTR_01] [nvarchar](50) NULL,
		[ATTR_02] [nvarchar](50) NULL,
		[ATTR_03] [nvarchar](50) NULL,
		[ATTR_04] [nvarchar](50) NULL,
		[ATTR_05] [nvarchar](50) NULL,
		[ATTR_06] [nvarchar](50) NULL,
		[ATTR_07] [nvarchar](50) NULL,
		[ATTR_08] [nvarchar](50) NULL,
		[ATTR_09] [nvarchar](50) NULL,
		[ATTR_10] [nvarchar](50) NULL
	) 

    BEGIN TRY

        BEGIN TRAN TX_SH
		
		BEGIN
			
			BEGIN

				DELETE FROM @XIF_FP_AMEND_SHIPAVAL_R

				INSERT INTO @XIF_FP_AMEND_SHIPAVAL_R
				SELECT X.*
				  FROM dbo.XIF_FP_AMEND_SHIPAVAL_R_SN AS X WITH(NOLOCK)                  
				 WHERE 1 = 1
				   AND X.PROC_FLAG		= 'N' 
				   AND CONVERT(NVARCHAR(8), IF_RCV_DATE, 112) = @v_sum_date 				   
				 ORDER BY 
				       X.IF_SEQ				

				SELECT @INX			= 1
					  ,@MAX_NUM		= COUNT(*)
				FROM @XIF_FP_AMEND_SHIPAVAL_R
				WHILE @INX <= @MAX_NUM
				BEGIN

					MERGE INTO SSP_DNM_FP_AMEND_SHIPAVAL M
					USING
					(				    
						SELECT 
							   X.COMPANY_ID						AS COMPANY_ID       
							  ,X.DIVISION_ID					AS DIVISION_ID         
							  ,X.SITE_ID                        AS SITE_ID
							  ,X.FROM_SITE_ID					AS FROM_SITE_ID            
							  ,X.CATEGORY_ID					AS CATEGORY_ID
							  ,X.MODEL_ID                       AS MODEL_ID 
							  ,X.CELL_GROUP                     AS CELL_GROUP
							  ,X.ITEM_ID                        AS ITEM_ID
							  ,X.PLAN_DATE                      AS PLAN_DATE
							  ,X.OUT_QTY                        AS OUT_QTY						  
							  ,@v_batch_user					AS CREATED_BY          
							  ,getdate()						AS CREATION_DATE       
							  ,@v_batch_user					AS LAST_UPDATED_BY     
							  ,getdate()						AS LAST_UPDATE_DATE						  
						 FROM @XIF_FP_AMEND_SHIPAVAL_R AS X							   
						 WHERE 1 = 1 
						 AND X.TID = @INX
					       
					) F					
						ON F.COMPANY_ID    = M.COMPANY_ID      
					   AND F.DIVISION_ID   = M.DIVISION_ID       				    				      
					   AND F.FROM_SITE_ID  = M.FROM_SITE_ID      
					   AND F.PLAN_DATE     = M.PLAN_DATE    
					   AND F.MODEL_ID      = M.MODEL_ID				   
					WHEN MATCHED THEN
					UPDATE
					   SET 
						   M.OUT_QTY    			=  F.OUT_QTY					  
						  ,M.LAST_UPDATED_BY        =  F.LAST_UPDATED_BY      
						  ,M.LAST_UPDATE_DATE       =  F.LAST_UPDATE_DATE
					WHEN NOT MATCHED THEN 
					INSERT (					         
						   COMPANY_ID  
						  ,DIVISION_ID
						  ,SITE_ID        
						  ,FROM_SITE_ID         
						  ,CATEGORY_ID
						  ,MODEL_ID   
						  ,CELL_GROUP
						  ,ITEM_ID
						  ,PLAN_DATE
						  ,OUT_QTY            
						  ,CREATION_DATE
						  ,CREATED_BY          
						  ,LAST_UPDATE_DATE
						  ,LAST_UPDATED_BY					 
						  ) 
				   VALUES (
						   F.COMPANY_ID  
						  ,F.DIVISION_ID
						  ,F.SITE_ID        
						  ,F.FROM_SITE_ID     
						  ,F.CATEGORY_ID
						  ,F.MODEL_ID   
						  ,F.CELL_GROUP
						  ,F.ITEM_ID
						  ,F.PLAN_DATE
						  ,F.OUT_QTY          
						  ,F.CREATION_DATE
						  ,F.CREATED_BY       
						  ,F.LAST_UPDATE_DATE
						  ,F.LAST_UPDATED_BY			
						  )
						  ;
					SET @INX = @INX + 1
					------------------------------------------------------------------------
				END --@INX <= @MAX_NUM				

				-- 인터페이스 테이블 처리 완료 UPDATE
				UPDATE X 
				   SET PROC_FLAG            = 'Y'
				     , PROC_DATE            = GETDATE()   
				     , PROC_MSG             = 'S'
				  FROM dbo.XIF_FP_AMEND_SHIPAVAL_R_SN AS X WITH(NOLOCK) 
				       INNER JOIN @XIF_FP_AMEND_SHIPAVAL_R AS Y
				    ON X.IF_SEQ				= Y.IF_SEQ
				;

			END 

		END; 

		-- IF data  삭제 (14일 이전 데이터 삭제) 
		DELETE FROM XIF_FP_AMEND_SHIPAVAL_R_SN 
		WHERE IF_RCV_DATE < GETDATE() - 14
		;
		
		-- data  삭제 (1개월  이전 데이터 삭제) 
		DELETE FROM dbo.SSP_DNM_FP_AMEND_SHIPAVAL
		 WHERE PLAN_DATE < CONVERT(VARCHAR, DATEADD(M, -1, GETDATE()) ,112)
		;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
        BEGIN
			COMMIT TRAN TX_SH;
        END;       


        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      


    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
        BEGIN
			ROLLBACK TRAN TX_SH

			--IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_MES_STOCK')
			--BEGIN
			--	CLOSE CUR_MES_STOCK ;
			--	DEALLOCATE CUR_MES_STOCK ;
			--END


        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
--      PRINT @@ERROR
		return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@v_program_name+'][' + @v_exec_time + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    return 1  

END; 
