



/*
 * Program ID   : [PR_SSP_ANL_SHIP_UPDATE_BOH_VAL]  
 * Description  : CONFIRM수량 변경 시 해당 날짜 이후 BOH, BALANCE UPDATE.
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL @p_division_id = '81' ,@p_plan_start_yyyymmdd = '20180326',@p_plan_type='PR',@p_seq='1',@p_user_id='scp_batch'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.05.03   LJH         Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_UPDATE_BOH_VAL]
( 
     
      @p_division_id         NVARCHAR(30)
    , @p_item_id             NVARCHAR(50)
	, @p_from_site           NVARCHAR(50)
    , @p_yyyymmdd            NVARCHAR(8)    
    , @p_user_id             NVARCHAR(150)  = 'ssp_batch'
    ---- , @p_debug       INT OUTPUT
) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_UPDATE_BOH_VAL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_ANL_SHIP_PLAN'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_PLAN INSERT LOGIC';
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

    -- 
    DECLARE @v_plan_start_yyyymmdd    NVARCHAR(8) = '';
	DECLARE @v_seq    INTEGER = 0;

	DECLARE @v_yyyymmdd_lastday NVARCHAR(8) = ''; -- BOH계산을 위한 전일 날짜 

	SET @v_yyyymmdd_lastday = CONVERT ( VARCHAR(8), CONVERT  (DATETIME, @p_yyyymmdd ) - 1 , 112) ;




    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH
          ------------------------------------------------------------------------------------------------------------- 
          -- 0. temp 테이블 생성 :
          ------------------------------------------------------------------------------------------------------------- 
          IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_UPDATE_BOH') IS NOT NULL
              DROP TABLE #tmp_SSP_ANL_SHIP_UPDATE_BOH

            CREATE TABLE #tmp_SSP_ANL_SHIP_UPDATE_BOH (
					 DIVISION_ID  	     nvarchar(030)
					,PLAN_START_YYYYMMDD nvarchar(008)
					,PLAN_TYPE	         nvarchar(050)
					,SEQ	             INT	
					,ITEM_ID	         nvarchar(050)
					,FROM_SITE	         nvarchar(030)
					,TO_SITE	         nvarchar(030)
					,MEASURE	         nvarchar(050)
					,YYYYMMDD	         nvarchar(008)
					,BOD_ID	             nvarchar(150)
					,QTY	             numeric(20,10)
					,INCOTERMS           nvarchar(010)   
					,TRANSPORT_MODE      nvarchar(050)    
					,PROJECT_CODE	     nvarchar(050)
					,FCST_TYPE	         nvarchar(020)
					,CONFIRM_ID          nvarchar(020)
            );

          ------------------------------------------------------------------------------------------------------------- 
          -- 1. 최근 PLAN 정보 확인 :
          ------------------------------------------------------------------------------------------------------------- 
 
			SELECT @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
			,      @v_seq                 = MAX(PLAN_SEQ)
			FROM   SSP_PLAN_VERSION_V
			WHERE  PLAN_TYPE    = 'SP'
			AND    DIVISION_ID  = @p_division_id 
			AND    CONFIRM_FLAG = 'Y'
			AND    PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
			                    FROM SSP_PLAN_VERSION_V T
								WHERE T.DIVISION_ID = @p_division_id 
								AND   T.plan_type  = 'SP'
								AND   T.CONFIRM_FLAG = 'Y');
			;

	      -- BOH계산을 위한 전일 날짜가 PLAN_START_DATE 보다 작으면 PLAN_START_DATE로 SET UP 
		  IF @v_yyyymmdd_lastday < @v_plan_start_yyyymmdd

			BEGIN 
			    SET @v_yyyymmdd_lastday = @v_plan_start_yyyymmdd;
			END ;

          ------------------------------------------------------------------------------------------------------------- 
          -- 2. 변경날짜 이후 BOH  산출 :
          -------------------------------------------------------------------------------------------------------------

			 WITH BOH AS (
						-- 전일 BOH
						SELECT   B.DIVISION_ID  	     
								,B.PLAN_START_YYYYMMDD 
								,B.PLAN_TYPE	         
								,B.SEQ	             
								,B.ITEM_ID	         
								,B.FROM_SITE        
								,SUM(B.QTY) AS  QTY	             
						FROM SSP_ANL_SHIP_PLAN B WITH(NOLOCK)
						WHERE 1=1 
						AND B.DIVISION_ID         = @p_division_id          -- '81'
						AND B.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd  -- '20180416'
						AND B.PLAN_TYPE           = 'SP'       
						AND B.SEQ                 = @v_seq                  -- '14'
						AND B.YYYYMMDD            = @v_yyyymmdd_lastday  -- 전일 boh  
						AND B.MEASURE             = 'BOH'
						AND B.ITEM_ID             = @p_item_id    -- 'ACEN1042I-A1'
						AND B.FROM_SITE           = @p_from_site  --'A040-A'

						GROUP BY 
							 B.DIVISION_ID      
							,B.PLAN_START_YYYYMMDD
							,B.PLAN_TYPE        
							,B.SEQ              
							,B.ITEM_ID          
							,B.FROM_SITE    
							),  
			 Z AS (
					SELECT DISTINCT  
						   DIVISION_ID  	     
					,      PLAN_START_YYYYMMDD 
					,      PLAN_TYPE	         
					,      SEQ	             
					,      ITEM_ID	         
					,      FROM_SITE  
					,      YYYYMMDD     	         
					FROM  SSP_ANL_SHIP_PLAN  WITH(NOLOCK) 
					WHERE 1=1 
					AND DIVISION_ID         = @p_division_id
					AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd   
					AND PLAN_TYPE           = 'SP'
					AND SEQ                 = @v_seq                  -- '3'
					AND MEASURE IN ('PROD_PLAN', 'SHIP_CONFIRM')
					AND YYYYMMDD           >= @v_yyyymmdd_lastday   -- 전일
					AND ITEM_ID             = @p_item_id    -- 'ACEN1042I-A1'
					AND FROM_SITE           = @p_from_site  --'A040-A'
					GROUP BY DIVISION_ID  	     
					,        PLAN_START_YYYYMMDD 
					,        PLAN_TYPE	         
					,        SEQ	             
					,        ITEM_ID	         
					,        FROM_SITE  
					,        YYYYMMDD 
				  )  


              INSERT INTO #tmp_SSP_ANL_SHIP_UPDATE_BOH
                  (
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,INCOTERMS         
					,TRANSPORT_MODE    
					,PROJECT_CODE	     
					,FCST_TYPE	
					,CONFIRM_ID        
                  )


			SELECT   Z.DIVISION_ID            
					,Z.PLAN_START_YYYYMMDD            
					,Z.PLAN_TYPE            
					,Z.SEQ            
					,Z.ITEM_ID            
					,Z.FROM_SITE    
					,'-' AS TO_SITE 
					,'BOH' AS MEASURE
					,Z.YYYYMMDD  
					,'-' AS BOD_ID
					,( SELECT  
							ISNULL( SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM'   THEN -1 * ISNULL(X.QTY,0)  
													   WHEN 'PROD_PLAN' THEN   ISNULL(X.QTY,0)  
										ELSE 0.0  
										END),0)   
					   FROM SSP_ANL_SHIP_PLAN X WITH(NOLOCK)   
					   WHERE 1=1  
						AND X.DIVISION_ID          = Z.DIVISION_ID  
						AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
						AND X.PLAN_TYPE            = Z.PLAN_TYPE  
						AND X.SEQ                  = Z.SEQ  
						AND X.ITEM_ID              = Z.ITEM_ID  
						AND X.FROM_SITE            = Z.FROM_SITE  
						AND X.MEASURE              IN ('PROD_PLAN','SHIP_CONFIRM')  
					    AND X.YYYYMMDD             >=  @v_yyyymmdd_lastday
						AND X.YYYYMMDD             < Z.YYYYMMDD ) + ISNULL(BOH.QTY,0) AS QTY  
					,'-' AS INCOTERMS         
					,'-' AS TRANSPORT_MODE    
					,'-' AS PROJECT_CODE	     
					,'-' AS FCST_TYPE
					,'-' AS CONFIRM_ID 	 

			FROM Z WITH(NOLOCK)   
			LEFT OUTER JOIN BOH WITH(NOLOCK) 
						 ON Z.DIVISION_ID         = BOH.DIVISION_ID  
						AND Z.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD  
						AND Z.PLAN_TYPE           = BOH.PLAN_TYPE  
						AND Z.SEQ                 = BOH.SEQ  
						AND Z.ITEM_ID             = BOH.ITEM_ID  
						AND Z.FROM_SITE           = BOH.FROM_SITE  
			WHERE 1=1 
			AND   Z.DIVISION_ID = @p_division_id  -- '81'
			AND   Z.ITEM_ID     = @p_item_id      -- 'ACEN1042I-A1'
			AND   Z.FROM_SITE   = @p_from_site    -- 'A040-A'
			;

          ------------------------------------------------------------------------------------------------------------- 
          -- 3. UPDATE BOH 
          -------------------------------------------------------------------------------------------------------------

			UPDATE SSP_ANL_SHIP_PLAN
			SET    QTY  = C.QTY 
			,      LAST_UPDATED_BY      = @v_batch_user
			,      LAST_UPDATE_DATE     = SYSDATETIME()
			FROM  SSP_ANL_SHIP_PLAN P WITH(NOLOCK) 
				  JOIN #tmp_SSP_ANL_SHIP_UPDATE_BOH C WITH(NOLOCK)
					 ON P.DIVISION_ID          = C.DIVISION_ID         
					AND P.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD 
					AND P.PLAN_TYPE            = C.PLAN_TYPE           
					AND P.SEQ                  = C.SEQ                 
					AND P.ITEM_ID              = C.ITEM_ID             
					AND P.FROM_SITE            = C.FROM_SITE           
					AND P.TO_SITE              = C.TO_SITE             
					AND P.YYYYMMDD             = C.YYYYMMDD            
					AND P.BOD_ID               = C.BOD_ID              
					AND P.INCOTERMS            = C.INCOTERMS           
					AND P.TRANSPORT_MODE       = C.TRANSPORT_MODE      
					AND P.PROJECT_CODE         = C.PROJECT_CODE        
					AND P.FCST_TYPE            = C.FCST_TYPE   
					AND P.MEASURE              = C.MEASURE
					AND ISNULL(P.CONFIRM_ID,'-')    =   ISNULL(C.CONFIRM_ID,'-')  
			WHERE 1=1 
			AND   P.MEASURE              = 'BOH'
			AND   P.PLAN_TYPE            = 'SP'
			AND   P.PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd 
			AND   P.SEQ                  = @v_seq
			AND   P.DIVISION_ID          = @p_division_id
			AND   P.ITEM_ID              = @p_item_id 
			AND   P.FROM_SITE            = @p_from_site 
			AND   P.YYYYMMDD            >= @v_yyyymmdd_lastday
			;


          ------------------------------------------------------------------------------------------------------------- 
          -- 4. UPDATE BALANCE 
          -------------------------------------------------------------------------------------------------------------
			WITH BAL AS (
					SELECT  P.DIVISION_ID             
					,       P.PLAN_START_YYYYMMDD 
					,       P.PLAN_TYPE           
					,       P.SEQ                 
					,       P.ITEM_ID             
					,       P.FROM_SITE   
					,       '-'             AS TO_SITE     
					,       'BALANCE'       AS MEASURE         
					,       P.YYYYMMDD       
					,       '-'             AS BOD_ID
					,       SUM(CASE WHEN P.MEASURE ='BOH' THEN P.QTY ELSE 0 END ) 
								- SUM(CASE WHEN P.MEASURE ='SHIP_CONFIRM' THEN P.QTY ELSE 0 END )  AS QTY
					,       '-'             AS INCOTERMS         
					,       '-'             AS TRANSPORT_MODE    
					,       '-'             AS PROJECT_CODE	     
					,       '-'             AS FCST_TYPE
					,       '-'             AS CONFIRM_ID 	  
					FROM  SSP_ANL_SHIP_PLAN P WITH(NOLOCK) 
					WHERE 1=1 
					AND P.MEASURE              IN ('SHIP_CONFIRM','BOH')
					AND P.DIVISION_ID         = @p_division_id 
					AND P.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd   -- '20180429'      
					AND P.PLAN_TYPE           = 'SP'                 
					AND P.SEQ                 = @v_seq                   -- '3'             -         
					AND P.ITEM_ID             = @p_item_id               -- 'ACEN1063I-B1'  
					AND P.FROM_SITE           = @p_from_site             -- 'G451-A' 
					AND P.YYYYMMDD           >= @v_yyyymmdd_lastday              -- '20180509'   
					GROUP BY 
					 P.DIVISION_ID         
					,P.PLAN_START_YYYYMMDD 
					,P.PLAN_TYPE           
					,P.SEQ                 
					,P.ITEM_ID             
					,P.FROM_SITE           
					,P.YYYYMMDD            
			)


			UPDATE SSP_ANL_SHIP_PLAN
			SET    QTY                  = BAL.QTY
			,      LAST_UPDATED_BY      = @v_batch_user
			,      LAST_UPDATE_DATE     = SYSDATETIME()
			FROM SSP_ANL_SHIP_PLAN B WITH(NOLOCK)   
				JOIN BAL WITH(NOLOCK) 
					  ON BAL.DIVISION_ID         = B.DIVISION_ID          
					AND BAL.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD  
					AND BAL.PLAN_TYPE           = B.PLAN_TYPE            
					AND BAL.SEQ                 = B.SEQ                  
					AND BAL.ITEM_ID             = B.ITEM_ID              
					AND BAL.FROM_SITE           = B.FROM_SITE            
					AND BAL.TO_SITE             = B.TO_SITE              
					AND BAL.YYYYMMDD            = B.YYYYMMDD             
					AND BAL.BOD_ID              = B.BOD_ID               
					AND BAL.INCOTERMS           = B.INCOTERMS            
					AND BAL.TRANSPORT_MODE      = B.TRANSPORT_MODE       
					AND BAL.PROJECT_CODE        = B.PROJECT_CODE         
					AND BAL.FCST_TYPE           = B.FCST_TYPE
					-- AND BAL.CONFIRM_ID          = B.CONFIRM_ID            
			WHERE 1=1 
			AND B.DIVISION_ID         = @p_division_id          --'81'            
			AND B.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd  --'20180429'         
			AND B.PLAN_TYPE           = 'SP'                 
			AND B.MEASURE             = 'BALANCE'   
			AND B.SEQ                 = @v_seq                  --'3'           
			AND B.ITEM_ID             = @p_item_id              --'ACEN1063I-B1' 
			AND B.FROM_SITE           = @p_from_site            -- 'G451-A' 
			AND B.YYYYMMDD           >= @v_yyyymmdd_lastday             -- '20180509' 

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

    END
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH
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













