CREATE PROCEDURE [dbo].[PR_SCM_OF_PSI_AMEND_UI_CALCULATION]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_confirm_flag nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_PSI_AMEND_UI_CALCULATION                                        **/
/** 프로그램 명   : PSI_AMEND_UI 수량변경분 재계산                                            **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2017.11.10    KSJEON         최초 작성                                                    **/
/** **/
/***********************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id        nvarchar(30)    = @p_instance_id
  DECLARE @v_plan_id          nvarchar(30)    = @p_plan_id
  DECLARE @v_instance_id      nvarchar(30)    = @p_instance_id

  -- LOG 용 변수 설정
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_PSI_AMEND_UI_CALCULATION'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code         nvarchar(10)
  
  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)
  
  -- 사용자 변수 설정

  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN
    
      BEGIN
        
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE PSI_CAL_STATUS'
        
         --SELECT ATTRIBUTE5
         UPDATE SCM_SYS_LOOKUP_VALUE
         SET    ATTRIBUTE5 = 'Y'
         WHERE  1=1
         AND  LOOKUP_TYPE_CODE = 'INSTANCE_ID'
         AND  SEGMENT1 = @V_INSTANCE_ID
         
                 --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END  
      
      BEGIN
      
        SET @v_table_name = 'PR_SCM_OF_PSI_AMEND_UI_CAL'

        --LOG 생성
        SET @v_message   = 'PROCEDURE Start'
      SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
		
        SET @v_message   = USER
      	SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'USER', @n_log_count, null, @v_message, null
        
        IF CHARINDEX('DEV', USER) = 0   -- 운영
          BEGIN

            EXEC(@v_instance_id+'_SY_PR_SCM_OF_PSI_AMEND_UI_UTIL '''+@v_instance_id+''','''+@v_plan_id+'''')

            EXEC(@v_instance_id+'_SY_PR_SCM_OF_PSI_AMEND_UI_CAL  '''+@v_instance_id+''','''+@v_plan_id+'''')

          END
        ELSE                            -- 개발
          BEGIN

            IF CHARINDEX('E_PRE', @v_master_id) > 0 OR CHARINDEX('E_PMIX', @v_master_id) > 0
              BEGIN
              
                EXEC LGCE_FPDEV.DBO.PR_SCM_OF_PSI_AMEND_UI_UTIL @v_instance_id, @v_plan_id
                
                EXEC LGCE_FPDEV.DBO.PR_SCM_OF_PSI_AMEND_UI_CAL  @v_instance_id, @v_plan_id
                
              END
            ELSE
              BEGIN
              
                EXEC KR_CELL_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_UTIL  @v_instance_id, @v_plan_id
          
                EXEC KR_CELL_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_CAL   @v_instance_id, @v_plan_id
            
              END

          END

        
        SET @v_message   = 'PROCEDURE End'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
              
      END

      -------------------------
      /*
        20180427 PACK Worker 추가.
      */
      IF CHARINDEX('PACK', @v_master_id) > 0
      BEGIN
      
        DELETE FROM FP_DAILY_PRODUCTION_PLAN_WORKER_R
        WHERE  INSTANCE_ID  = @v_master_id
        AND    FP_PLAN_ID   = @v_plan_id
        
        INSERT INTO FP_DAILY_PRODUCTION_PLAN_WORKER_R
    				    (	
                  INSTANCE_ID,
            			FP_PLAN_ID,
            			COMPANY_ID,
            			DIVISION_ID,
            			SITE_ID,
            			PLANT_ID,
            			FACTORY_ID,
            			TOP_ITEM_ID,
            			ITEM_ID,
            			OPERATION_ID,
            			LINE_ID,
            			PLAN_DATE,
            			PLAN_QTY,
            			PLAN_IN_QTY,
            			WORKER_QTY ,
            			WORKER_PRIORITY,
               		INSERT_ID, 
               		INSERT_DTTM
      				  )
        SELECT  A.INSTANCE_ID,
        			  A.FP_PLAN_ID,
        			  A.COMPANY_ID,
        			  A.DIVISION_ID,
        			  A.SITE_ID,
        			  A.PLANT_ID,
        			  A.FACTORY_ID,
        			  A.TOP_ITEM_ID,
        			  A.ITEM_ID,
        			  A.OPERATION_ID,
        			  A.LINE_ID,
        			  A.PLAN_DATE,
        			  A.PLAN_QTY,
        			  A.PLAN_IN_QTY,
        			  B.WORKER_QTY AS WORKER_QTY,
           		  RANK() OVER(PARTITION BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.PLAN_DATE
                						ORDER BY B.worker_qty,A.ITEM_ID) AS WORKER_PRIORITY,
           		  @v_proc_name AS INSERT_ID, 
           		  GETDATE() AS  INSERT_DTTM
        FROM   (  SELECT A.INSTANCE_ID, A.FP_PLAN_ID, 
        		       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,
        		       A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.PLAN_DATE,
        		       SUM(A.PLAN_IN_QTY) AS PLAN_IN_QTY, SUM(A.PLAN_QTY) AS PLAN_QTY
              		FROM   FP_DAILY_PRODUCTION_PLAN_R A
              		WHERE  1=1
              		AND    A.INSTANCE_ID = @v_master_id
              		AND    A.FP_PLAN_ID  = @v_plan_id
              		--AND    A.OPERATION_ID IN ('P5500','P9500')
                  AND    A.OPERATION_ID IN (SELECT SEGMENT4 
        								  FROM SCM_SYS_LOOKUP_VALUE 
        								  WHERE 1=1 
        								  AND LOOKUP_TYPE_CODE = 'PACK_WORKER_OPERATION' 
      								  AND SEGMENT5 = 'Y')	
              		GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, 
              		         A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,
              		         A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.PLAN_DATE
                ) A
                LEFT OUTER JOIN SCM_PACK_WORKER_M B
                		ON A.COMPANY_ID = B.COMPANY_ID
                		AND A.DIVISION_ID = B.DIVISION_ID
                		AND A.SITE_ID = B.SITE_ID
                		AND A.PLANT_ID = B.PLANT_ID
                		AND A.FACTORY_ID = B.FACTORY_ID
                		AND A.ITEM_ID = B.ITEM_ID
                		AND A.OPERATION_ID = B.OPERATION_ID
                		AND A.LINE_ID = B.LINE_ID 
      
        SET @v_message = @@ROWCOUNT
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'SY_FP_DAILY_PRODUCTION_PLAN_WORKER_R', 'INSERT', @n_log_count, null, @v_message, null 
        
        INSERT INTO FP_DAILY_PRODUCTION_PLAN_WORKER_R
                (	
                  INSTANCE_ID,
            			FP_PLAN_ID,
            			COMPANY_ID,
            			DIVISION_ID,
            			SITE_ID,
            			PLANT_ID,
            			FACTORY_ID,
            			TOP_ITEM_ID,
            			ITEM_ID,
            			OPERATION_ID,
            			LINE_ID,
            			PLAN_DATE,
            			PLAN_QTY,
            			PLAN_IN_QTY,
            			WORKER_QTY ,
            			WORKER_PRIORITY,
               		INSERT_ID, 
               		INSERT_DTTM
  				      )       		
        SELECT	INSTANCE_ID, 
        				FP_PLAN_ID, 
        				COMPANY_ID, 
        				DIVISION_ID, 
        				SITE_ID, 
        				PLANT_ID, 
        				'TOTAL' AS FACTORY_ID, 
        				'-' AS TOP_ITEM_ID, 
        				'-' AS ITEM_ID, 
        				'-' AS OPERATION_ID,
        				'-' AS LINE_ID, PLAN_DATE,
        				SUM(PLAN_IN_QTY) AS PLAN_IN_QTY, 
        				SUM(PLAN_QTY) AS PLAN_QTY,
      	   			SUM(CASE WHEN WORKER_PRIORITY = 1 THEN ISNULL(WORKER_QTY,0) ELSE 0 END) AS WORKER_QTY1,
      	   			1 AS WORKER_PRIORITY, 
      	   			@v_proc_name AS INSERT_ID, 
      	   			GETDATE() AS INSERT_DTTM
        FROM	  FP_DAILY_PRODUCTION_PLAN_WORKER_R 		   	
        WHERE 	1=1
        AND INSTANCE_ID  = @v_master_id
        AND 	FP_PLAN_ID  = @v_plan_id
        GROUP BY INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_DATE
        
        SET @v_message = @@ROWCOUNT
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'SY_FP_DAILY_PRODUCTION_PLAN_WORKER_R(TOTAL)', 'INSERT', @n_log_count, null, @v_message, null 

      END
      
      --20180605 SONG CELL / PACK PRIORITY CALCULATION 추가 
      EXECUTE PR_SCM_AMEND_PLAN_PRIORITY @v_master_id , @v_plan_id
            
      BEGIN
        
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE PSI_CAL_STATUS'
        
         --SELECT ATTRIBUTE5
         UPDATE SCM_SYS_LOOKUP_VALUE
         SET    ATTRIBUTE5 = 'N'
         WHERE  1=1
         AND  LOOKUP_TYPE_CODE = 'INSTANCE_ID'
         AND  SEGMENT1 = @V_INSTANCE_ID
         
                 --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END 

    END
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

      BEGIN
        
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE PSI_CAL_STATUS'
        
         --SELECT ATTRIBUTE5
         UPDATE SCM_SYS_LOOKUP_VALUE
         SET    ATTRIBUTE5 = 'N'
         WHERE  1=1
         AND  LOOKUP_TYPE_CODE = 'INSTANCE_ID'
         AND  SEGMENT1 = @V_INSTANCE_ID
         
           --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END 
    
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
