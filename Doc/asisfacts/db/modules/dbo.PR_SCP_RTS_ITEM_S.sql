
/*
 * Program ID   : PR_SCP_RTS_ITEM_S 
 * Description  : FP ITEM 전송
 * OutTable     :
 * Execute      : EXEC PR_SCP_RTS_ITEM_S
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.08.13   YYDOK         Initial Release 폴란드2동 MSS,RTS구축 프로젝트
 * 2024.06.09   vadabi3       NERP - 특정 Company 별도 처리 개선
 * 2024.11.03   vadabi3       NERP - 개발 DB 적용
 ----------------------------------------------------------------------------------------------------
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_RTS_ITEM_S]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP';
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_RTS_ITEM_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC'; 
    DECLARE @d_event_date   DATETIME;

	-- NERP 매핑코드
    DECLARE @v_ESWA NVARCHAR(8);
	SELECT @v_ESWA = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_RTS_ITEM_S','ESWA');--G480

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;
    
    BEGIN TRY
      BEGIN
    
     --   BEGIN TRANSACTION; 

        ----------------------------------------------------------- 
        -- 1. interface data creation
        -----------------------------------------------------------        

            DECLARE @X_IF_SEQ               VARCHAR(50);  -- MQ SEQ
            DECLARE @X_IF_TYPE              NVARCHAR(1)   = 'I';
            DECLARE @X_IF_ID                NVARCHAR(50)  = 'OFP0_PRTS_FP_ITEM_RTS'; 
            DECLARE @X_IF_INS_DATE          DATETIME      = GETDATE();
            DECLARE @X_IF_FLAG              NVARCHAR(100)  = 'N';
            DECLARE @X_IF_SND_DATE          NVARCHAR(100)  = NULL;
                        
            DECLARE @X_ACCUM_DATE           NVARCHAR(8)   = CONVERT(VARCHAR,GETDATE(),112);
            DECLARE @X_GNRT_DTTM            DATETIME      = GETDATE();
            DECLARE @X_ACCUM_COUNT          NUMERIC(20,10);              
      
            BEGIN
            	
            	 -- 5일이 지난 데이타 삭제.
            	 DELETE FROM XIF_SCP_RTS_ITEM_S_SN
            	 WHERE ACCUM_DATE <= CONVERT(VARCHAR,DATEADD(D,-1,GETDATE()),112);
            
                /******************************************
                 * ITEM 송신용 대상건수 확인.
                 ******************************************/             
                  SELECT @X_ACCUM_COUNT = COUNT(1)
                    FROM [DBO].[SCM_MST_ITEM_SN] WITH(NOLOCK)
                   WHERE DIVISION_ID='81'
                     AND COMPANY_ID = @v_ESWA -- G480 CWA
                     AND ITEM_TYPE IN ('H','P','R')
                     AND SCP_OPERATION_GROUP IN ('E','A') --ELECRODE,CELL
                     AND ACTIVE_FLAG='Y'
                       ; 


                /******************************************
                 * ITEM 송신용 테이블에 기록한다.
                 ******************************************/       
                 
                 INSERT INTO XIF_SCP_RTS_ITEM_S_SN
                            ( 
                               IF_SEQ               
                              ,IF_TYPE              
                              ,IF_ID                
                              ,IF_INS_DATE          
                              ,IF_FLAG              
                              ,IF_SND_DATE          
                              ,COMPANY_ID           
                              ,DIVISION_ID          
                              ,SITE_ID              
                              ,ITEM_ID              
                              ,ITEM_NAME            
                              ,NICK_NAME            
                              ,ITEM_TYPE            
                              ,ITEM_UOM             
                              ,ITEM_CLASS           
                              ,ITEM_CLASS_NAME      
                              ,POLARITY             
                              ,ACTIVE_YN            
                              ,PCSGID 
                              ,ACCUM_DATE
                              ,GNRT_DTTM
                              ,ACCUM_COUNT              
                             )
                  SELECT  'OSCP'+CONVERT(VARCHAR,GETDATE(),112)+ DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCP_RTS_ITEM_S),10) AS IF_SEQ
                        , @X_IF_TYPE                 AS IF_TYPE
                        , @X_IF_ID                   AS IF_ID
                        , @X_IF_INS_DATE             AS IF_INS_DATE
                        , @X_IF_FLAG                 AS IF_FLAG
                        , @X_IF_SND_DATE             AS IF_SND_DATE
                        , COMPANY_ID
                        , DIVISION_ID
                        , SITE_ID
                        , ITEM_ID
                        , SPEC AS ITEM_NAME
                        , NICK_NAME
                        , ITEM_TYPE
                        , ITEM_UOM                         
                        , ITEM_CLASS
                        , ITEM_CLASS_NAME
                        , CASE WHEN LEFT(ITEM_ID,5) IN ('APCCA','ANPCA' )  THEN 'CATHODE'
                               WHEN LEFT(ITEM_ID,5) IN ('APCAN','ANPAN' )  THEN 'ANODE'
                               WHEN LEFT(ITEM_ID,5) IN ('APCCS','ANPCS' )  THEN 'CATHODE'
                               ELSE ''  
                          END AS POLARITY
                        , ACTIVE_FLAG AS ACTIVE_YN
                        , SCP_OPERATION_GROUP  AS PCSGID -- 'E','A','P'
                        , @X_ACCUM_DATE
                        , @X_GNRT_DTTM
                        , @X_ACCUM_COUNT
                    FROM [DBO].[SCM_MST_ITEM_SN] WITH(NOLOCK)
                   WHERE DIVISION_ID='81'
                     AND COMPANY_ID = @v_ESWA  -- G480 CWA
                     AND ITEM_TYPE IN ('H','P','R')
                     AND SCP_OPERATION_GROUP IN ('E','A') --ELECRODE,CELL
                     AND ACTIVE_FLAG='Y'
                       ;   
              
            END    
      
        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

     --   IF @@TRANCOUNT > 0 
     --     BEGIN
     --        COMMIT WORK;
                                       
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

        EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
   --   IF @@TRANCOUNT > 0 
   --     BEGIN
   --       ROLLBACK;
   --     END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;
    return 1  


  END;

