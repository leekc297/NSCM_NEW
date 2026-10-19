
/*
 * Program ID   : PR_SCM_MST_SITE_ITEM_FROM_ELEC_TACT_TIME
 * Description  : CREATE SITE ITEM INFO. FROM ELECTRODE TACT TIME SITE
 *                기초 데이타 생성용으로 초기 setup을 위한 1회성으로 사용하기 위한 프로그램을 개발함.
 *                선행조건: SCP_MST_TACT_TIME에 TACT TIME이 생성되어 있을것.
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.22   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */
 
CREATE PROCEDURE [dbo].[PR_SCM_MST_SITE_ITEM_FROM_ELEC_TACT_TIME]
    ( @p_division_id         NVARCHAR(30)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_MST_SITE_ITEM_FROM_ELEC_TACT_TIME';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_MST_SITE_ITEM,SCM_MST_SITE_ITEM_PRIORITY'; 
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCM_MST_SITE_ITEM INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    
    
    BEGIN TRY
      BEGIN
    
      --  BEGIN TRANSACTION TXN_ELEC_SITE_ITEM; 


        ----------------------------------------------------------- 
        -- 1. SCM_MST_SITE_ITEM 기존 PROJECT CODE 데이타 삭제
        --    SCM_MST_SITE_ITEM_PRIORITY 기존 PROJECT CODE 데이타 삭제
        ----------------------------------------------------------- 
/*    -- 혹시 실행할까봐 주석 처리함
        DELETE SCM_MST_SITE_ITEM 
        WHERE 1=1
          AND DIVISION_ID    = @P_DIVISION_ID
          AND LEFT(ITEM_ID,5) IN ( 'APCCA','APCAN','APCCS')
          AND PROJECT_CODE   <> '-'
          ;

        DELETE SCM_MST_SITE_ITEM_PRIORITY 
        WHERE 1=1
          AND DIVISION_ID    = @P_DIVISION_ID
          AND LEFT(ITEM_ID,5) IN ( 'APCCA','APCAN','APCCS')
          AND PROJECT_CODE   <> '-'
          ;          
*/
        ----------------------------------------------------------- 
        -- 2. SCM_MST_SITE_ITEM_PRIORITY 데이타 생성
        --    SCM_MST_SITE_ITEM  데이타 생성
        -----------------------------------------------------------                                
          DECLARE CUR_SIP CURSOR LOCAL
          FOR   
          WITH SUB AS
          (
           SELECT DISTINCT
                  DIVISION_ID,
                  PLANT_SITE_ID,
                  '-' AS SALES_SITE_ID,
                  '-' AS PROJECT_CODE,
                  ITEM_ID,
                  DBO.FN_GET_BUCKET_YYYYMMDD(0) AS FROM_YYYYMMDD,
                  '99991231'                    AS TO_YYYYMMDD,
                  'Y'         AS VALID_YN,
                  'SCP_BATCH' AS CREATED_BY,
                  GETDATE()   AS CREATION_DATE,
                  'SCP_BATCH' AS LAST_UPDATED_BY,
                  GETDATE()   AS LAST_UPDATE_DATE
             FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
            WHERE DIVISION_ID = @p_division_id
              AND OPERATION_ID LIKE 'E2000%'
              AND LEFT(ITEM_ID,5) IN ( 'APCCA','APCAN','APCCS')              
              AND NOT EXISTS ( SELECT 'X'
                                 FROM SCM_MST_SITE_ITEM_PRIORITY A WITH(NOLOCK)
                                WHERE 1=1
                                  AND A.DIVISION_ID   = T.DIVISION_ID
                                  AND A.PLANT_SITE_ID = T.PLANT_SITE_ID
                                  AND A.ITEM_ID       = T.ITEM_ID )
          ) 
           SELECT NEXT VALUE FOR DBO.SEQ1_SCM_MST_SITE_ITEM_PRIORITY AS PRIORITY_SEQ,
                  SUB.DIVISION_ID,
                  SUB.PLANT_SITE_ID,
                  SUB.SALES_SITE_ID,
                  SUB.PROJECT_CODE,
                  SUB.ITEM_ID,
                  --ROW_NUMBER() OVER(PARTITION BY DIVISION_ID,ITEM_ID ORDER BY PLANT_SITE_ID) AS PRIORITY,
                  SUB.FROM_YYYYMMDD,
                  SUB.TO_YYYYMMDD,
                  SUB.VALID_YN,
                  SUB.CREATED_BY,
                  SUB.CREATION_DATE,
                  SUB.LAST_UPDATED_BY,
                  SUB.LAST_UPDATE_DATE
             FROM SUB
            WHERE 1=1
              AND NOT EXISTS ( SELECT 'X'
                                 FROM SCM_MST_SITE_ITEM_PRIORITY A WITH(NOLOCK)
                                WHERE 1=1
                                  AND A.DIVISION_ID     = SUB.DIVISION_ID
                                  AND A.PLANT_SITE_ID   = SUB.PLANT_SITE_ID
                                  AND A.ITEM_ID         = SUB.ITEM_ID );
                                  
                                           
           DECLARE @X_PRIORITY_SEQ       AS BIGINT
           DECLARE @X_DIVISION_ID        AS NVARCHAR(100)
           DECLARE @X_PLANT_SITE_ID      AS NVARCHAR(100)
           DECLARE @X_SALES_SITE_ID      AS NVARCHAR(100)
           DECLARE @X_PROJECT_CODE       AS NVARCHAR(100)
           DECLARE @X_ITEM_ID            AS NVARCHAR(100)
           DECLARE @X_PRIORITY           AS INT
           DECLARE @X_FROM_YYYYMMDD      AS NVARCHAR(100)
           DECLARE @X_TO_YYYYMMDD        AS NVARCHAR(100)
           DECLARE @X_VALID_YN           AS NVARCHAR(100)
           DECLARE @X_CREATED_BY         AS NVARCHAR(100)
           DECLARE @X_CREATION_DATE      AS DATETIME
           DECLARE @X_LAST_UPDATED_BY    AS NVARCHAR(100)
           DECLARE @X_LAST_UPDATE_DATE   AS DATETIME

           OPEN CUR_SIP
           FETCH NEXT FROM CUR_SIP INTO  @X_PRIORITY_SEQ   
                                        ,@X_DIVISION_ID     
                                        ,@X_PLANT_SITE_ID   
                                        ,@X_SALES_SITE_ID   
                                        ,@X_PROJECT_CODE    
                                        ,@X_ITEM_ID         
                                        ,@X_FROM_YYYYMMDD   
                                        ,@X_TO_YYYYMMDD     
                                        ,@X_VALID_YN        
                                        ,@X_CREATED_BY      
                                        ,@X_CREATION_DATE   
                                        ,@X_LAST_UPDATED_BY 
                                        ,@X_LAST_UPDATE_DATE;
           
           
           WHILE @@FETCH_STATUS = 0
           BEGIN
            
                  SELECT @X_PRIORITY = COUNT(1) + 1
                    FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
                   WHERE DIVISION_ID = @X_DIVISION_ID
                     AND ITEM_ID     = @X_ITEM_ID;
            
                  INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
                       ( 
                         PRIORITY_SEQ,
                         DIVISION_ID,
                         PLANT_SITE_ID,
                         SALES_SITE_ID,
                         PROJECT_CODE,
                         ITEM_ID,
                         PRIORITY,
                         FROM_YYYYMMDD,
                         TO_YYYYMMDD,
                         VALID_YN,
                         CREATED_BY,
                         CREATION_DATE,
                         LAST_UPDATED_BY,
                         LAST_UPDATE_DATE                  
                       )
                VALUES(  @X_PRIORITY_SEQ   
                        ,@X_DIVISION_ID     
                        ,@X_PLANT_SITE_ID   
                        ,@X_SALES_SITE_ID   
                        ,@X_PROJECT_CODE    
                        ,@X_ITEM_ID 
                        ,@X_PRIORITY        
                        ,@X_FROM_YYYYMMDD   
                        ,@X_TO_YYYYMMDD     
                        ,@X_VALID_YN        
                        ,@X_CREATED_BY      
                        ,@X_CREATION_DATE   
                        ,@X_LAST_UPDATED_BY 
                        ,@X_LAST_UPDATE_DATE);
                
           
            FETCH NEXT FROM CUR_SIP INTO @X_PRIORITY_SEQ   
                                        ,@X_DIVISION_ID     
                                        ,@X_PLANT_SITE_ID   
                                        ,@X_SALES_SITE_ID   
                                        ,@X_PROJECT_CODE    
                                        ,@X_ITEM_ID         
                                        ,@X_FROM_YYYYMMDD   
                                        ,@X_TO_YYYYMMDD     
                                        ,@X_VALID_YN        
                                        ,@X_CREATED_BY      
                                        ,@X_CREATION_DATE   
                                        ,@X_LAST_UPDATED_BY 
                                        ,@X_LAST_UPDATE_DATE;
           END
           CLOSE CUR_SIP
           DEALLOCATE CUR_SIP
                                  

                                  
                                  
           INSERT INTO SCM_MST_SITE_ITEM
                  ( 
                    DIVISION_ID,
                    PROJECT_CODE,
                    SCM_SITE_ID,
                    ITEM_ID,
                    VALID_YN,
                    BPMS_EXIST,
                    CREATED_BY,
                    CREATION_DATE,
                    LAST_UPDATED_BY,
                    LAST_UPDATE_DATE                  
                  )
           SELECT DISTINCT
                  DIVISION_ID,
                  '-' AS PROJECT_CODE,
                  PLANT_SITE_ID AS SCM_SITE_ID,
                  ITEM_ID,
                  'Y'         AS VALID_YN,
                  'N'         AS BPMS_EXIST,
                  'SCP_BATCH' AS CREATED_BY,
                  GETDATE()   AS CREATION_DATE,
                  'SCP_BATCH' AS LAST_UPDATED_BY,
                  GETDATE()   AS LAST_UPDATE_DATE
             FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
            WHERE DIVISION_ID = @p_division_id
              AND OPERATION_ID LIKE 'E2000%'
              AND NOT EXISTS ( SELECT 'X'
                                 FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
                                WHERE 1=1
                                  AND A.DIVISION_ID   = T.DIVISION_ID
                                  AND A.SCM_SITE_ID = T.PLANT_SITE_ID
                                  AND A.ITEM_ID       = T.ITEM_ID );                      
        
        PRINT N'프로시저 종료'



        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

     --   IF @@TRANCOUNT > 0 
     --     BEGIN
     --       COMMIT WORK;
     --     END;

        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    
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

      END;

    END TRY

    BEGIN CATCH
        
    --  IF @@TRANCOUNT > 0 
    --    BEGIN
    --      ROLLBACK TRANSACTION TXN_ELEC_SITE_ITEM;
    --    END;

      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
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

