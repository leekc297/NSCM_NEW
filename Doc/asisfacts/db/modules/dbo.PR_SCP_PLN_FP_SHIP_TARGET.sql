
/*
 * Program ID   : PR_SCP_PLN_FP_SHIP_TARGET 
 * Description  : FP 출하 TARGET 전송
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_FP_SHIP_TARGET
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.20   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.03.28   YYDOK         SCP_PLN_SHIP_PLAN_TARGET_V 반영
 * 2018.06.11   YYDOK         FINAL CONFIRM시 FP로 타겟전송 추가 
 * 2018.07.03   YYDOK         ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID ADD
 * 2018-07-26   YYDOK         SHIP_TO_PARTY, RECEIVE_YYYYMMDD 추가반영
 * 2018-08-20   YYDOK         SHIP_TO_CODE 추가반영
 * 2018.10.10   YYDOK         해당주차 FP TARGET INTERFACE YN (인터페이스해야할지 여부) 체크로직추가
 * 2020.10.08   KSW           프로시저 수행 마지막에 Target 전송 이상유무를 체크하는 프로시저를 호출한다.
 * 2023.02.28   KSG           PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 소형 Pre FP 전송 추가로 PR도 수행
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_FP_SHIP_TARGET]
    ( 
      @p_division_id          NVARCHAR(10)
    , @p_start_yyyymmdd       NVARCHAR(8)
    , @p_plan_type            NVARCHAR(40)
    , @p_seq                  INT
    , @p_user_id              NVARCHAR(100)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_FP_SHIP_TARGET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);       
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC'; 
    DECLARE @d_event_date   DATETIME;

        ----------------------------------------------------------- 
        -- 0. validation
        -- PLAN_TYPE='MA'/'FN', CONFIRM된 경우에 처리함.
        -- 20230228  PJ20230691R  소형 Pre FP 전송 추가로 PR도 수행 추가
        -----------------------------------------------------------
        IF @p_plan_type NOT IN ( 'PR', 'MA','FN')
           BEGIN
              RETURN;
           END

        ----------------------------------------------------------
        -- 해당주차 SCP자동으로 수행하여 인터페이스 안내리도록
        -- SCP_PLN_INTERFACE_YN에 N으로 셋팅시 수행안함.
        ----------------------------------------------------------
        DECLARE @X_FP_TARGET_YN NVARCHAR(1) = 'Y';
        DECLARE @X_MRP_TARGET_YN NVARCHAR(1) = 'Y';

        SELECT @X_FP_TARGET_YN =  ISNULL(FP_TARGET_YN,'Y'),
               @X_MRP_TARGET_YN =  ISNULL(MRP_TARGET_YN,'Y')
          FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
         WHERE DIVISION_ID         = @p_division_id 
           AND PLAN_START_YYYYMMDD = DBO.FN_GET_BUCKET_YYYYMMDD(0);

        IF @X_FP_TARGET_YN = 'N'
           BEGIN
              RETURN;
           END

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':'  + @p_division_id;
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
    
  --      BEGIN TRANSACTION; 
           
        IF @p_user_id IS NULL 
           BEGIN
              SET @p_user_id = 'SCP';
           END

        ----------------------------------------------------------- 
        -- 1. interface data creation
        -----------------------------------------------------------        

            DECLARE @X_START_YYYYMMDD          VARCHAR(8);
            DECLARE @X_CNT                     INT           = 0;
            DECLARE @X_SEND_SEQ                INT           = 1;
                                               
            --DECLARE @X_IF_TYPE                 NVARCHAR(1)   = 'I';
            DECLARE @X_IF_ID                   NVARCHAR(50)  = 'OSCP_OFP0_FP_SHIP_TARGET';
            --DECLARE @X_IF_INS_DATE             DATETIME      = GETDATE();
            --DECLARE @X_IF_FLAG                 VARCHAR(100)  = 'N';
            --DECLARE @X_IF_SND_DATE             VARCHAR(100)  = NULL;
                                               
            DECLARE @X_IF_RCV_DATE             DATETIME       = GETDATE();
            DECLARE @X_PROC_FLAG               NVARCHAR(1)     = 'N';
            DECLARE @X_PROC_DATE               DATETIME       =  NULL;
            DECLARE @X_PLAN_TYPE               NVARCHAR(40)    = @p_plan_type;
            DECLARE @X_PLAN_WEEK               NVARCHAR(12);
                                               
            DECLARE @X_SHIP_ID                 NVARCHAR(200);
            DECLARE @X_ITEM_ID                 NVARCHAR(40);
            DECLARE @X_OPERATION_GROUP         NVARCHAR(40);
            DECLARE @X_SITE_CODE               NVARCHAR(40);
            DECLARE @X_PLANT_ID                NVARCHAR(40);
            DECLARE @X_CUSTOMER_CODE           NVARCHAR(40);
            DECLARE @X_CUSTOMER_NAME           NVARCHAR(100);
            DECLARE @X_SHIP_TO_CODE            NVARCHAR(40);
            DECLARE @X_SHIP_TO_PARTY           NVARCHAR(100);
            DECLARE @X_DEST_SITE_CODE          NVARCHAR(40);
            DECLARE @X_DEST_PLANT_ID           NVARCHAR(40);
            DECLARE @X_DESTINATION_SITE_TYPE   NVARCHAR(40); 
            DECLARE @X_EXFACTORY_WEEK          NVARCHAR(8);
            DECLARE @X_EXFACTORY_YYYYMMDD      NVARCHAR(8);
            DECLARE @X_RECEIVE_YYYYMMDD        NVARCHAR(8);  
            DECLARE @X_EXFACTORY_QTY           DECIMAL(18,3);
            DECLARE @X_ORDER_TYPE              NVARCHAR(40);            
            DECLARE @X_SHIP_METHOD             NVARCHAR(40);
            DECLARE @X_PRIORITY                NVARCHAR(200);
            DECLARE @X_DIVISION                NVARCHAR(10);
            DECLARE @X_MARKET                  NVARCHAR(10);
            DECLARE @X_CREATE_USER_ID          NVARCHAR(50);
            DECLARE @X_CREATE_DATE             DATETIME;
            DECLARE @X_MODIFY_USER_ID          NVARCHAR(50);
            DECLARE @X_MODIFY_DATE             DATETIME;      
      
            IF LEN(ISNULL(@P_START_YYYYMMDD,'')) = 8 
               BEGIN            
                    SET @X_START_YYYYMMDD = @P_START_YYYYMMDD;  
               END     
            ELSE
               BEGIN
                    SET @X_START_YYYYMMDD = DBO.FN_GET_BUCKET_YYYYMMDD(0);
               END
            
            SELECT @X_CNT = COUNT(1)
              FROM DBO.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
             WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
               AND DIVISION_ID         = @P_DIVISION_ID
               --AND PLAN_TYPE           = @P_PLAN_TYPE
               AND IF_ID               = @X_IF_ID;   
      
            IF (@X_CNT > 0)
               BEGIN
                    SELECT @X_CNT = MAX(IFSEQNO)
                      FROM DBO.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
                     WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
                       AND DIVISION_ID         = @P_DIVISION_ID
                       --AND PLAN_TYPE           = @P_PLAN_TYPE
                       AND IF_ID               = @X_IF_ID;  
                       
                    SET @X_SEND_SEQ = @X_CNT +1;    
               
               END
      
            -- 전송주차 = 해당주차의 월요일 일자 YYYYMMDD + '001' 일련번호
            SET @X_PLAN_WEEK = @X_START_YYYYMMDD + '_' + DBO.FN_ZERO_LPAD( @X_SEND_SEQ,3 );
      
            BEGIN
            
                  /******************************************
                   * 출하타겟 송신용 테이블에 기록한다.
                   ******************************************/       
                   
                   INSERT INTO XIF_SCP_SALES_EXFACTORY_R_SN
                             ( IF_RCV_DATE          ,
                               PROC_FLAG            ,
                               PROC_DATE            ,
                               PLAN_TYPE            ,
                               PLAN_WEEK            ,
                               SHIP_ID              ,
                               ITEM_ID              ,
                               OPERATION_GROUP      ,
                               SITE_CODE            ,
                               PLANT_ID             ,
                               CUSTOMER_CODE        ,
                               CUSTOMER_NAME        ,
                               SHIP_TO_CODE         ,
                               SHIP_TO_PARTY        ,
                               DEST_SITE_CODE       ,
                               DEST_PLANT_ID        ,
                               DESTINATION_SITE_TYPE,
                               EXFACTORY_WEEK       ,
                               EXFACTORY_YYYYMMDD   ,
                               RECEIVE_YYYYMMDD     ,
                               EXFACTORY_QTY        ,
                               ORDER_TYPE           ,
                               SHIP_METHOD          ,
                               PRIORITY             ,
                               DIVISION             ,
                               MARKET               ,
                               CREATE_USER_ID       ,
                               CREATE_DATE          ,
                               MODIFY_USER_ID       ,
                               MODIFY_DATE          ,
                               ATTR_01              , --ORIGIN_FROM_DIVISION_ID
                               ATTR_02                --ORIGIN_TO_DIVISION_ID     
                              )
                  SELECT @X_IF_RCV_DATE
                       , @X_PROC_FLAG
                       , @X_PROC_DATE
                       , @X_PLAN_TYPE
                       , @X_PLAN_WEEK
                       , SHIP_ID
                       , ITEM_ID
                       , OPERATION_GROUP
                       , FROM_SITE               AS SITE_CODE
                       , PLANT_ID
                       , CUSTOMER_CODE
                       , CUSTOMER_NAME
                       , SHIP_TO_CODE
                       , SHIP_TO_PARTY
                       , TO_SITE                 AS DEST_SITE_CODE
                       , TO_PLANT_ID             AS DEST_PLANT_ID
                       , TO_SITE_TYPE            AS DESTINATION_SITE_TYPE
                       , SHIP_WEEK               AS EXFACTORY_WEEK
                       , SHIP_YYYYMMDD           AS EXFACTOYR_YYYYMMDD
                       , RECEIVE_YYYYMMDD   
                       , SHIP_QTY                AS EXFACTORY_QTY
                       , FCST_TYPE               AS ORDER_TYPE
                       , TRANSPORT_MODE          AS SHIP_METHOD
                       , PRIORITY
                       , DIVISION_ID             AS DIVISION
                       , DOM_EXP                 AS MARKET
                       , CREATE_USER_ID
                       , CREATE_DATE
                       , MODIFY_USER_ID
                       , MODIFY_DATE
                       , ORIGIN_FROM_DIVISION_ID
                       , ORIGIN_TO_DIVISION_ID
                    FROM SCP_PLN_SHIP_PLAN_TARGET_V
                   WHERE 1=1
                     AND DIVISION_ID              = @p_division_id     --'81'
                     AND PLAN_START_YYYYMMDD      = @p_start_yyyymmdd  --'20180312'
                     AND PLAN_TYPE                = @p_plan_type       --'MA'
                     AND SEQ                      = @p_seq
                     ;   
					 
                SET @n_log_count = @@ROWCOUNT;         
                                         
                /******************************************
                 * 인터페이스 전송이력  테이블에 기록한다.
                 ******************************************/  
      
                INSERT INTO DBO.SCP_PLN_INTERFACE_SEND_H
                           ( PLAN_START_YYYYMMDD
                           , DIVISION_ID
                           , PLAN_TYPE
                           , IF_ID
                           , IFSEQNO
                           , CREATED_BY
                           , CREATION_DATE )
                           VALUES
                           (  
                             @X_START_YYYYMMDD
                           , @P_DIVISION_ID
                           , @P_PLAN_TYPE
                           , @X_IF_ID
                           , @X_SEND_SEQ
                           , @P_USER_ID
                           , GETDATE()    
                           );
               
            END    
      
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
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ':'  + @p_division_id;
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
        
     -- IF @@TRANCOUNT > 0 
     --   BEGIN
     --     ROLLBACK;
     --   END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE()) + ':'  + @p_division_id;
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
    SET @v_description = @p_division_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;

    ----------------------------------------------------------- start
	-- 2020.10.08   KSW :: 프로시저 수행 마지막에 Target 전송 이상유무를 체크하는 프로시저를 호출한다.
	-----------------------------------------------------------
	EXEC PR_SCP_PLN_IF_CHECK_SMS_SEND @p_division_id, @p_plan_type, 'FP_SHIP' ;
	----------------------------------------------------------- end
	
    return 1  

  END;

