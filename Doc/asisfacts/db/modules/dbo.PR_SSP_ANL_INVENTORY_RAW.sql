/*
 * Program ID   : PR_SSP_ANL_INVENTORY_RAW
 * Description  : Batch Job JOB.SCMPROD_PLAN_SUPPLY_40_Creation에서 호출함.(PR_SSP_ANL_SHIP_PLAN_40 완료 후 수행) 
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_SHIPMENT_PLAN @v_division_id = '81' ,@v_plan_start_yyyymmdd = '20180326',@v_plan_type='PR',@v_seq='1',@p_user_id='scp_batch'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.04.09   juhlee         Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 *                             소형 INVENTORY_RAW 화면용 DATA생성 
 *                             AGING 재고: 현재일 기준 가장 최근 CUTOFF일자 EX) 한국은 전날CUTOFF, 남경: 전전날 CUTOFF 
 *                             OWMS 재고 : 전날 CUTOFF재고 @p_plan_start_yyyymmdd - 1 
 */
CREATE PROCEDURE [dbo].[PR_SSP_ANL_INVENTORY_RAW]
( 
      @p_division_id         NVARCHAR(30)
) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
--    SET ANSI_WARNINGS OFF;


    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    --SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_INVENTORY_RAW';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SSP_ANL_INVENTORY_RAW'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_ANL_INVENTORY_RAW INSERT LOGIC';
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

    DECLARE @v_plan_start_yyyymmdd    NVARCHAR(8) = '';

	DECLARE @v_division_id    NVARCHAR(30) = '';
	SET     @v_division_id =  @p_division_id ;

 	DECLARE @v_plan_type  NVARCHAR(30) = ''; 
	DECLARE @v_seq        INTEGER = 1;


    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH
        ------------------------------------------------------------------------------------------------------------- 
        -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서
        ------------------------------------------------------------------------------------------------------------- 
          IF OBJECT_ID('tempdb..#tmp_SSP_ANL_INVENTORY_RAW') IS NOT NULL
              DROP TABLE #tmp_SSP_ANL_INVENTORY_RAW

            CREATE TABLE #tmp_SSP_ANL_INVENTORY_RAW(
				 DIVISION_ID              nvarchar(030)   
				,PLAN_START_YYYYMMDD      nvarchar(008)    
				,PLAN_TYPE                nvarchar(050)   
				,SEQ                      bigint         
				,PLANT_ID                 nvarchar(030)   
				,SCM_SITE_ID              nvarchar(030)   
				,INV_TYPE                 nvarchar(030)   
				,ITEM_ID                  nvarchar(050)   
				,FACTORY_ID               nvarchar(030)   
				,STORAGE_ID               nvarchar(030)   
				,LOT_ID                   nvarchar(050)   
				,PROD_DATE                nvarchar(008)    
				,PALLET_ID                nvarchar(030)   
				,SOC                      nvarchar(014)   
				,CAPACITY_GRADE           nvarchar(040)   
				,GRADE                    nvarchar(040)   
				,STOCK_STATUS             nvarchar(040)   
				,ROUTE_ID                 nvarchar(030)   
				,OPERATION_ID             nvarchar(030)   
				,LINE_ID                  nvarchar(030)   
				,OP_START_TIME            nvarchar(008)    
				,REMAIN_LEAD_TIME         numeric(20, 10)
				,EXP_FORMATION_END_DATE   nvarchar(008)    
				,HOLD_YN                  nvarchar(001)    
				,SPECIAL_YN               nvarchar(001)    
				,STOCK_QTY                numeric(20, 10)
				,HOLD_QTY                 numeric(20, 10)
				,AVAILABLE_QTY            numeric(20, 10)
				,LONG_QTY                 numeric(20, 10)
				,EXPIRATION_QTY           numeric(20, 10)
				,CUSTOMER_CODE            nvarchar(050)   
				,CUSTOMER_NAME            nvarchar(0180)  
             );


           -- 현재 VESION PLAN 정보 
			SELECT @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
			,      @v_seq                 = MAX(PLAN_SEQ)
			,      @v_plan_type           = MAX(PLAN_TYPE)
			FROM   SSP_PLAN_VERSION_V
			WHERE  PLAN_TYPE    = 'SP'
			AND    DIVISION_ID  = @v_division_id 
			AND    CONFIRM_FLAG = 'Y'
			AND    PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
											FROM SSP_PLAN_VERSION_V T
											WHERE T.DIVISION_ID  = @v_division_id 
											AND   T.PLAN_TYPE    = 'SP'
											AND   T.CONFIRM_FLAG = 'Y');


        ------------------------------------------------------------------------------------------------------------- 
        --1. #tmp_SSP_ANL_INVENTORY_RAW 생성 
		--   AGING재고 + OWMS재고 (생성시점 최신 정보) 
        ------------------------------------------------------------------------------------------------------------- 
             INSERT INTO #tmp_SSP_ANL_INVENTORY_RAW
                  (
					 DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,PLANT_ID
					,SCM_SITE_ID
					,INV_TYPE
					,ITEM_ID
					,FACTORY_ID
					,STORAGE_ID
					,LOT_ID
					,PROD_DATE
					,PALLET_ID
					,SOC
					,CAPACITY_GRADE
					,GRADE
					,STOCK_STATUS
					,ROUTE_ID
					,OPERATION_ID
					,LINE_ID
					,OP_START_TIME
					,REMAIN_LEAD_TIME
					,EXP_FORMATION_END_DATE
					,HOLD_YN
					,SPECIAL_YN
					,STOCK_QTY
					,HOLD_QTY
					,AVAILABLE_QTY
					,LONG_QTY
				    ,EXPIRATION_QTY  
					,CUSTOMER_CODE
					,CUSTOMER_NAME				     
				  )
				SELECT 
				 X.DIVISION_ID
				,@v_plan_start_yyyymmdd  PLAN_START_YYYYMMDD
				,@v_plan_type            PLAN_TYPE
				,@v_seq                  SEQ
				,X.PLANT_ID
				,X.SCM_SITE_ID             
				,X.INV_TYPE
				,X.ITEM_ID
				,X.FACTORY_ID
				,X.STORAGE_ID
				,X.LOT_ID
				,LY.SEGMENT2+LM.SEGMENT2 + SUBSTRING(X.LOT_ID,6,2) -- PROD_DATE
				,X.PALLET_ID
				,X.SOC
				,X.CAPACITY_GRADE
				,X.GRADE
				,X.STOCK_STATUS
				,X.ROUTE_ID
				,X.OPERATION_ID
				,X.LINE_ID
				,X.OP_START_TIME
				,X.REMAIN_LEAD_TIME
				,X.EXP_FORMATION_END_DATE
				,X.HOLD_YN
				,X.SPECIAL_YN
				,X.STOCK_QTY
				,X.HOLD_QTY
				 -- AVAILABLE_QTY :  F(Formation) : STOCK_QTY - HOLD_QTY , O(Outbound W/M) : AVAILABLE_QTY = STOCK_QTY - BLOCK_QTY - LONG_QTY , 단 BLOCK_QTY , LONG_QTY 둘다 있으면, 큰수를 적용
				,CASE WHEN X.INV_TYPE = 'F' THEN X.STOCK_QTY - X.HOLD_QTY ELSE X.AVAILABLE_QTY END  AVAILABLE_QTY
				,X.LONG_QTY
				,X.EXPIRATION_QTY
				,X.CUSTOMER_CODE
				,X.CUSTOMER_NAME
				FROM ( 
						-- Formation
						SELECT 
						 A.DIVISION_ID						AS DIVISION_ID
						,A.PLANT_ID							AS PLANT_ID
						,A.SCM_SITE_ID						AS SCM_SITE_ID
						,'F'						        AS INV_TYPE   -- Formation
						,A.ITEM_ID							AS ITEM_ID
						,A.FACTORY_ID						AS FACTORY_ID
						,NULL								AS STORAGE_ID
						,A.LOT_ID							AS LOT_ID
						,NULL								AS PALLET_ID
						,NULL								AS SOC
						,NULL								AS CAPACITY_GRADE
						,NULL								AS GRADE
						,NULL								AS STOCK_STATUS
						,A.ROUTE_ID							AS ROUTE_ID
						,A.OPERATION_ID						AS OPERATION_ID
						,A.LINE_ID							AS LINE_ID
						,CONVERT(VARCHAR(8),A.OP_START_TIME, 112)		AS OP_START_TIME
						,A.REMAIN_LEAD_TIME                 AS REMAIN_LEAD_TIME
						,CONVERT(VARCHAR(8), A.AVAILABLE_DATE, 112)		AS EXP_FORMATION_END_DATE
						,A.WIPHOLD_YN						AS HOLD_YN
						,A.SPECIAL_YN						AS SPECIAL_YN
						,SUM(A.QTY)							AS STOCK_QTY
						,SUM(CASE WHEN (A.WIPHOLD_YN ='Y' OR A.SPECIAL_YN = 'Y' )THEN A.QTY ELSE 0 END)		AS HOLD_QTY
						,NULL								AS AVAILABLE_QTY
						,NULL								AS LONG_QTY
						,NULL								AS EXPIRATION_QTY
						,NULL								AS CUSTOMER_CODE
						,NULL								AS CUSTOMER_NAME
						FROM SCM_DNM_STOCK_AGING_V A WITH(NOLOCK) 
						,     ( -- 가장최근 CUTOFF 기준 
								SELECT C.DIVISION_ID, C.SITE_ID ,  MAX(C.CUTOFF_DATE) AS CUTOFF_DATE
								FROM   SCM_DNM_STOCK_AGING_V C WITH(NOLOCK) 
								--WHERE  C.CUTOFF_DATE >  CONVERT(DATETIME, CONVERT(NVARCHAR, GETDATE()-1, 112)) -- GETDATE() - 5
								WHERE  C.CUTOFF_DATE >  GETDATE() - 5
								AND    C.DIVISION_ID  = @v_division_id
								GROUP BY C.DIVISION_ID, C.SITE_ID 
							  ) B
						WHERE  1=1 
						AND    A.DIVISION_ID = B.DIVISION_ID
						AND    A.SITE_ID     = B.SITE_ID
						AND    A.CUTOFF_DATE = B.CUTOFF_DATE
						AND    A.DIVISION_ID = @v_division_id
						AND    A.SCM_SITE_ID IS NOT NULL 
						--AND    A.CUTOFF_DATE >  CONVERT(DATETIME, CONVERT(NVARCHAR, GETDATE()-1, 112)) -- GETDATE() - 5						
						AND    A.CUTOFF_DATE >  GETDATE() - 5						
						GROUP BY A.DIVISION_ID
						,A.PLANT_ID							
						,A.SCM_SITE_ID						
						,A.ITEM_ID						
						,A.FACTORY_ID					
						,A.LOT_ID
						,A.ROUTE_ID							
						,A.OPERATION_ID					
						,A.LINE_ID						
						,CONVERT(VARCHAR(8),A.OP_START_TIME, 112)	
						,A.REMAIN_LEAD_TIME               
						,CONVERT(VARCHAR(8), A.AVAILABLE_DATE, 112)	
						,A.WIPHOLD_YN						
						,A.SPECIAL_YN	


						UNION ALL 

						-- Outbound W/H
						SELECT 
						 W.DIVISION_ID						AS DIVISION_ID
						,SUBSTRING(W.FROM_SITE,1,4)		    AS PLANT_ID
						,W.FROM_SITE						AS SCM_SITE_ID
						,'O'						        AS INV_TYPE   -- Outbound W/H'	
						,W.ITEM_ID							AS ITEM_ID
						,NULL       						AS FACTORY_ID
						,W.STORAGE_ID						AS STORAGE_ID
						,W.LOT_ID							AS LOT_ID
						--,LY.SEGMENT2+LM.SEGMENT2 + SUBSTRING(W.LOT_ID,6,2)  AS PROD_DATE
						,W.PALLET_ID						AS PALLET_ID
						,W.SOC								AS SOC
						,W.CAPACITY_GRADE					AS CAPACITY_GRADE
						,W.GRADE							AS GRADE
						,W.STOCK_STATUS						AS STOCK_STATUS
						,NULL								AS ROUTE_ID
						,NULL								AS OPERATION_ID
						,NULL								AS LINE_ID
						,NULL								AS OP_START_TIME
						,NULL								AS REMAIN_LEAD_TIME
						,NULL								AS EXP_FORMATION_END_DATE
						,NULL								AS HOLD_YN
						,NULL								AS SPECIAL_YN
						,SUM(W.STOCK_QTY)					AS STOCK_QTY
						,SUM(W.BLOCK_QTY)					AS HOLD_QTY
						,SUM(W.AVAILABLE_QTY)               AS AVAILABLE_QTY -- STOCK_QTY - BLOCK_QTY - LONG_QTY , 단 BLOCK_QTY , LONG_QTY 둘다 있으면, 큰수를 적용
						,SUM(W.LONG_QTY)  					AS LONG_QTY   
						,SUM(W.EXPIRATION_QTY)  			AS EXPIRATION_QTY
						,CASE WHEN W.CUSTOMER_CODE = '-' THEN NULL ELSE W.CUSTOMER_CODE END					AS CUSTOMER_CODE
						,W.CUSTOMER_NAME					AS CUSTOMER_NAME
						FROM   SSP_ANL_OWMS_STOCK_C W WITH(NOLOCK)
						WHERE  1=1 
						AND    W.DIVISION_ID         = @v_division_id
						AND    W.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND    W.PLAN_TYPE           = @v_plan_type  
						AND    W.SEQ                 = @v_seq 
						GROUP BY 
						 W.DIVISION_ID						
						,SUBSTRING(W.FROM_SITE,1,4)		    
						,W.FROM_SITE						
						,W.ITEM_ID							
						,W.STORAGE_ID						
						,W.LOT_ID							
						,W.PALLET_ID						
						,W.SOC								
						,W.CAPACITY_GRADE					
						,W.GRADE							
						,W.STOCK_STATUS	
						,W.CUSTOMER_CODE
						,W.CUSTOMER_NAME
				) X
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LY WITH(NOLOCK) 
						ON  LY.LOOKUP_TYPE = 'LOT_ID_YEAR' 
						AND LY.VALID_YN    = 'Y' 
						AND LY.SEGMENT1    = SUBSTRING(X.LOT_ID,4,1)
						AND LY.SEGMENT2 BETWEEN CONVERT(VARCHAR(4),DATEADD(YY,-11,GETDATE()),112) AND  CONVERT(VARCHAR(4),DATEADD(YY,8,GETDATE()),112)
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK) 
						ON  LM.LOOKUP_TYPE = 'LOT_ID_MONTH' 
						AND LM.VALID_YN    = 'Y' 
						AND LM.SEGMENT1    = SUBSTRING(X.LOT_ID,5,1)	
				WHERE LY.SEGMENT2+LM.SEGMENT2 + SUBSTRING(X.LOT_ID,6,2) IS NOT NULL 
             ;

 		------------------------------------------------------------------------------------------------------------- 
		--2. SSP_ANL_INVENTORY_RAW 생성
		-------------------------------------------------------------------------------------------------------------
            DELETE FROM SSP_ANL_INVENTORY_RAW  
            WHERE DIVISION_ID         = @v_division_id 
              AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
              AND PLAN_TYPE           = @v_plan_type 
             ;

           INSERT INTO /* PR_SSP_ANL_INVENTORY_RAW */ dbo.SSP_ANL_INVENTORY_RAW
                  (
					 DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,PLANT_ID
					,SCM_SITE_ID
					,INV_TYPE
					,ITEM_ID
					,FACTORY_ID
					,STORAGE_ID
					,LOT_ID
					,PROD_DATE
					,PALLET_ID
					,SOC
					,CAPACITY_GRADE
					,GRADE
					,STOCK_STATUS
					,ROUTE_ID
					,OPERATION_ID
					,LINE_ID
					,OP_START_TIME
					,REMAIN_LEAD_TIME
					,EXP_FORMATION_END_DATE
					,HOLD_YN
					,SPECIAL_YN
					,STOCK_QTY
					,HOLD_QTY
					,AVAILABLE_QTY
					,LONG_QTY
					,EXPIRATION_QTY
					,CUSTOMER_CODE
					,CUSTOMER_NAME
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
                  )
				SELECT 	 
					 R.DIVISION_ID
					,R.PLAN_START_YYYYMMDD
					,R.PLAN_TYPE
					,R.SEQ
					,R.PLANT_ID
					,R.SCM_SITE_ID
					,R.INV_TYPE
					,R.ITEM_ID
					,R.FACTORY_ID
					,R.STORAGE_ID
					,R.LOT_ID
					,C.BASIS_YYYYMMDD   -- PROD_DATE
					,R.PALLET_ID
					,R.SOC
					,R.CAPACITY_GRADE
					,R.GRADE
					,R.STOCK_STATUS
					,R.ROUTE_ID
					,R.OPERATION_ID
					,R.LINE_ID
					,R.OP_START_TIME
					,R.REMAIN_LEAD_TIME
					,R.EXP_FORMATION_END_DATE
					,R.HOLD_YN
					,R.SPECIAL_YN
					,R.STOCK_QTY
					,R.HOLD_QTY
					,R.AVAILABLE_QTY
					,R.LONG_QTY
					,R.EXPIRATION_QTY
					,R.CUSTOMER_CODE
					,R.CUSTOMER_NAME
					,@v_batch_user AS CREATED_BY
					,GETDATE()     AS CREATION_DATE
					,@v_batch_user AS LAST_UPDATED_BY
					,GETDATE()     AS LAST_UPDATED_BY
					FROM #tmp_SSP_ANL_INVENTORY_RAW R WITH (NOLOCK)
					 JOIN SCM_SYS_CALENDAR_M    C WITH(NOLOCK)    -- LOT_ID 규칙에 안맞으면 비정상적인 날짜이므로 비정상적날짜는 제외
					   ON R.PROD_DATE = C.BASIS_YYYYMMDD 

              ;
			  

            -- 과거 데이터 삭제 로직 
            DELETE FROM SSP_ANL_INVENTORY_RAW  
            WHERE DIVISION_ID         = @v_division_id 
              AND PLAN_START_YYYYMMDD < CONVERT(VARCHAR(8),DATEADD(D,-30,GETDATE()),112) --30일 이전 데이터 삭제 
              AND PLAN_TYPE           = @v_plan_type 
			  AND SEQ = 1
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
    SET @v_description = N'['++'][' + @v_exec_time + ']';  
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
