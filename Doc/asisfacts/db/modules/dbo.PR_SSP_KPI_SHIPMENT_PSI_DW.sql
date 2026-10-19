/*
 * Program ID   : PR_SSP_KPI_SHIPMENT_PSI_DW  
 * Description  : 
 * Execute      : EXEC PR_SSP_KPI_SHIPMENT_PSI_DW , 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.02.25   LJH            [C20200225-000205] 
                               주단위 생성(매주 월요일) 08:00 수행 ( JOB.PR_SSP_KPI_SHIPMENT_PSI_DW )  
							   해당주에 Max(월) 계획을 기준월 
							   차주계획에 없는 날짜는 이전 생성된 계획을 적용 
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용							   
 */

CREATE PROCEDURE [dbo].[PR_SSP_KPI_SHIPMENT_PSI_DW]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_KPI_SHIPMENT_PSI';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SSP_KPI_SHIPMENT_PSI'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N'SSP_KPI_SHIPMENT_PSI INSERT LOGIC';
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


    DECLARE @v_sum_yyyymmdd  NVARCHAR(8) =  CONVERT(char(8),  GETDATE(), 112); -- 집계일자 매주 월요일 

	
	DECLARE @v_yyyymm              NVARCHAR(6) = ''; 
    DECLARE @v_start_yyyymmdd      NVARCHAR(8) = ''; 
    DECLARE @v_last_start_yyyymmdd NVARCHAR(8) = ''; 

    DECLARE @v_last_yyyymm         NVARCHAR(6) = ''
    DECLARE @v_end_yyyymmdd        NVARCHAR(8) = ''; 

    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

			------------------------------------------------------------------------------------------------------------- 
			-- 0. temp 테이블 생성 : 생성후 마지막에 한번에 입력하기 위해서
			------------------------------------------------------------------------------------------------------------- 
			IF OBJECT_ID('tempdb..#tmp_SSP_KPI_SHIPMENT_PSI') IS NOT NULL
				DROP TABLE #tmp_SSP_KPI_SHIPMENT_PSI

            CREATE TABLE #tmp_SSP_KPI_SHIPMENT_PSI (
				 SUM_YYYYMMDD        NVARCHAR(008)   
				,YYYYMM              NVARCHAR(006)  
				,START_YYYYMMDD      NVARCHAR(008) 
				,COMPANY_ID          NVARCHAR(030) 
				,PLANT_ID            NVARCHAR(030)   
				,DIVISION_ID         NVARCHAR(030)   
				,OPERATION_GROUP     NVARCHAR(030)   
				,FROM_SITE           NVARCHAR(030)   
				,TO_SITE             NVARCHAR(030)  
				,SHIPTO_CODE         NVARCHAR(030)  
				,ITEM_ID             NVARCHAR(050)   
				,YYYYMMDD            NVARCHAR(008)    
				,PLAN_QTY            NUMERIC(20, 10)
				,PLAN_QTY_TO_CELL    NUMERIC(20, 10)
				,PROJECT_CODE        NVARCHAR(050)
				,FCST_TYPE           NVARCHAR(020)
				,INCOTERMS           NVARCHAR(010)
				,TRANSPORT_MODE      NVARCHAR(050)
				,END_CUSTOMER        NVARCHAR(050)
				,CONFIRM_ID          NVARCHAR(030)  
				,SUM_YYYYMMDD_B      NVARCHAR(030)    

            );


     	------------------------------------------------------------------------------------------------------------- 
		-- 1. KPI_SPA_SHIPPING_PLAN_ACCURACY :  #tmp_SSP_KPI_SHIPMENT_PSI  
		------------------------------------------------------------------------------------------------------------- 

		-- 집계대상 월 
		SELECT @v_yyyymm = MAX(BASIS_YYYYMM) 
		  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) 
		 WHERE ISO_YYYYWW = ( SELECT ISO_YYYYWW
							    FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
							   WHERE BASIS_YYYYMMDD = @v_sum_yyyymmdd 
							) 
        ; 
		
 
		-- 이전 집계 대상월
        SELECT @v_last_yyyymm         = ISNULL(MAX(YYYYMM)         , @v_yyyymm)
		,      @v_last_start_yyyymmdd = ISNULL(MAX(START_YYYYMMDD) , @v_sum_yyyymmdd ) 
		  FROM SSP_KPI_SHIPMENT_PSI WITH(NOLOCK) 
		 WHERE SUM_YYYYMMDD = ( SELECT MAX(SUM_YYYYMMDD) 
				                  FROM SSP_KPI_SHIPMENT_PSI WITH(NOLOCK) 
								 WHERE SUM_YYYYMMDD < @v_sum_yyyymmdd 
							  )


        IF @v_last_yyyymm = @v_yyyymm  
		  BEGIN 
		       SET @v_start_yyyymmdd = @v_last_start_yyyymmdd ;
		  END
		ELSE

		  BEGIN
		       SET @v_start_yyyymmdd = @v_sum_yyyymmdd;
		  END 


		INSERT INTO #tmp_SSP_KPI_SHIPMENT_PSI(
				    SUM_YYYYMMDD             
				   ,YYYYMM          
				   ,START_YYYYMMDD            
				   ,COMPANY_ID           
				   ,PLANT_ID             
				   ,DIVISION_ID          
				   ,OPERATION_GROUP      
				   ,FROM_SITE            
				   ,TO_SITE              
				   ,SHIPTO_CODE          
				   ,ITEM_ID              
				   ,YYYYMMDD             
				   ,PLAN_QTY             
				   ,PLAN_QTY_TO_CELL 
				   ,PROJECT_CODE       
				   ,FCST_TYPE           
				   ,INCOTERMS          
				   ,TRANSPORT_MODE
				   ,END_CUSTOMER    		  
				   ,CONFIRM_ID
				   ,SUM_YYYYMMDD_B         
		           )
			 SELECT @v_sum_yyyymmdd		AS SUM_YYYYMMDD
				   ,@v_yyyymm			AS WEEK_YYYYMM
				   ,@v_start_yyyymmdd	AS WEEK_NAME
				   ,FS.COMPANY_ID		AS COMPANY_ID
				   ,FS.PLANT_ID			AS PLANT_ID
				   --,P.DIVISION_ID      AS DIVISION_ID
				   ,D.ATTRIBUTE3		AS DIVISION_ID
				   ,FS.OPERATION_GROUP	AS OPERATION_GROUP
				   --,[DBO].[FN_GET_ITEM_OPERATION_GROUP](P.DIVISION_ID , P.ITEM_ID) AS OPERATION_GROUP
				   ,P.FROM_SITE
				   ,P.TO_SITE
				   ,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.TO_SITE, 'SHIPTO_CODE')   AS SHIPTO_CODE
				   ,P.ITEM_ID
				   ,P.YYYYMMDD
				   ,P.QTY AS PLAN_QTY
				   ,ISNULL(B.ACCUMULATED_CHILD_QTY,1) * P.QTY AS PLAN_QTY_TO_CELL
				   ,P.PROJECT_CODE       
				   ,P.FCST_TYPE           
				   ,P.INCOTERMS          
				   ,P.TRANSPORT_MODE 
				   ,TS.END_CUSTOMER                 AS END_CUSTOMER  
				   ,P.CONFIRM_ID 
				   ,@v_sum_yyyymmdd AS SUM_YYYYMMDD_B
			   FROM SSP_ANL_SHIP_PLAN_C P WITH(NOLOCK) 
			        JOIN SCM_MST_DIVISION D WITH(NOLOCK)
			     ON P.DIVISION_ID	= D.DIVISION_ID

			   	    JOIN SCM_MST_SITE TS WITH(NOLOCK) 
			     ON TS.DIVISION_ID	= P.DIVISION_ID 
			    AND TS.SCM_SITE_ID	= P.TO_SITE 
			    AND TS.SITE_TYPE	= 'SALES'
			   	    JOIN SCM_MST_SITE FS WITH(NOLOCK) 
			     ON FS.DIVISION_ID	= P.DIVISION_ID 
			    AND FS.SCM_SITE_ID	= P.FROM_SITE 
			    AND FS.SITE_TYPE	= 'PLANT'
			    AND FS.OSP_YN		= 'N'
			   	    LEFT OUTER JOIN  SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK) 
			     ON B.DIVISION_ID	= P.DIVISION_ID 
			    AND B.MODEL_ID		= P.ITEM_ID
			    AND B.OPERATION_GROUP_ID = 'A'
			    AND B.PLANT_ID		= FS.PLANT_ID 
			    AND B.TCO_CELL_YN	= 'N' 
			  WHERE P.PLAN_START_YYYYMMDD =  CONVERT(VARCHAR, DATEADD(D, -2, CONVERT(DATETIME, @v_sum_yyyymmdd ,112)) ,112) 
				AND P.MEASURE  = 'SHIP_PLAN'
				AND P.YYYYMMDD >= @v_sum_yyyymmdd  
				AND P.QTY > 0 
				AND D.ATTRIBUTE3 IN ('81','82')
				
			  UNION ALL 
			 --소형 
			 SELECT
				    @v_sum_yyyymmdd    AS SUM_YYYYMMDD
				   ,@v_yyyymm     AS YYYYMM
				   ,@v_start_yyyymmdd       AS START_YYYYMMDD
				   ,FS.COMPANY_ID      AS COMPANY_ID
				   ,FS.PLANT_ID        AS PLANT_ID
				   --,P.DIVISION_ID      AS DIVISION_ID
				   ,D.ATTRIBUTE3      AS DIVISION_ID
				   ,FS.OPERATION_GROUP AS OPERATION_GROUP
				   --,[DBO].[FN_GET_ITEM_OPERATION_GROUP](P.DIVISION_ID , P.ITEM_ID) AS OPERATION_GROUP
				   ,P.FROM_SITE
				   ,P.TO_SITE
				   ,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.TO_SITE, 'SHIPTO_CODE')   AS SHIPTO_CODE
				   ,P.ITEM_ID
				   ,P.YYYYMMDD
				   ,P.QTY AS PLAN_QTY
				   ,ISNULL(B.ACCUMULATED_CHILD_QTY,1) * P.QTY AS PLAN_QTY_TO_CELL
				   ,'-'               AS PROJECT_CODE       
				   ,P.FCST_TYPE           
				   ,P.INCOTERMS          
				   ,P.TRANSPORT_MODE  
				   ,P.PROJECT_CODE    AS END_CUSTOMER
				   ,P.CONFIRM_ID 
				   ,@v_sum_yyyymmdd AS SUM_YYYYMMDD_B
			   FROM SSP_ANL_SHIP_PLAN_40 P WITH(NOLOCK) 
			        JOIN SCM_MST_DIVISION D WITH(NOLOCK)
			     ON P.DIVISION_ID	= D.DIVISION_ID

					JOIN SCM_MST_SITE TS WITH(NOLOCK) 
				 ON TS.DIVISION_ID = P.DIVISION_ID 
				AND TS.SCM_SITE_ID = P.TO_SITE 
				AND TS.SITE_TYPE   = 'SALES'
					JOIN SCM_MST_SITE FS WITH(NOLOCK) 
				 ON FS.DIVISION_ID = P.DIVISION_ID 
				AND FS.SCM_SITE_ID = P.FROM_SITE 
				AND FS.SITE_TYPE   = 'PLANT'
				AND FS.OSP_YN      = 'N'
					LEFT OUTER JOIN  SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK) 
				 ON B.DIVISION_ID = P.DIVISION_ID 
				AND B.MODEL_ID    = P.ITEM_ID
				AND B.OPERATION_GROUP_ID = 'A'
				AND B.PLANT_ID = FS.PLANT_ID 
				AND B.TCO_CELL_YN = 'N'  
			  WHERE P.PLAN_START_YYYYMMDD =  CONVERT(VARCHAR, DATEADD(D, -2, CONVERT(DATETIME, @v_sum_yyyymmdd ,112)) ,112) 
				AND P.MEASURE  = 'SHIP_CONFIRM'
				AND P.QTY > 0 
				AND P.PLAN_TYPE  = 'SP'
				AND P.SEQ = 1
				AND D.ATTRIBUTE3 = '40'
				AND P.YYYYMMDD >= @v_sum_yyyymmdd  

			  UNION ALL 

			 SELECT @v_sum_yyyymmdd			AS SUM_YYYYMMDD
				   ,@v_yyyymm				AS YYYYMM
				   ,@v_start_yyyymmdd		AS START_YYYYMMDD       
				   ,COMPANY_ID           
				   ,PLANT_ID             
				   ,DIVISION_ID          
				   ,OPERATION_GROUP      
				   ,FROM_SITE            
				   ,TO_SITE              
				   ,SHIPTO_CODE          
				   ,ITEM_ID              
				   ,YYYYMMDD             
				   ,PLAN_QTY             
				   ,PLAN_QTY_TO_CELL 
				   ,PROJECT_CODE       
				   ,FCST_TYPE           
				   ,INCOTERMS          
				   ,TRANSPORT_MODE  
				   ,END_CUSTOMER
				   ,ATTRIBUTE1 
				   ,SUM_YYYYMMDD			AS SUM_YYYYMMDD_B
			   FROM SSP_KPI_SHIPMENT_PSI WITH(NOLOCK) 
			  WHERE SUM_YYYYMMDD = ( SELECT MAX(SUM_YYYYMMDD) 
				                       FROM SSP_KPI_SHIPMENT_PSI WITH(NOLOCK) 
									  WHERE SUM_YYYYMMDD < @v_sum_yyyymmdd
								   ) 
                AND YYYYMMDD >=  @v_start_yyyymmdd
				AND YYYYMMDD <=   CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_sum_yyyymmdd ,112)) ,112) 
			 ;

            -- Sales Price 추출
			IF OBJECT_ID('tempdb..#tmp_SCM_MST_FUTURE_PRICE') IS NOT NULL
				DROP TABLE #tmp_SCM_MST_FUTURE_PRICE

			SELECT DIVISION_ID
			,      PROJECT_CODE
			,      SCM_SITE_ID     AS TO_SITE 
			,      PLANT_SITE_ID   AS FROM_SITE 
			,      ITEM_ID
			,      WEEK 
			,      FCST_TYPE
			,      INCOTERMS
			,      MAX(PRICE)      AS PRICE 
			  INTO #tmp_SCM_MST_FUTURE_PRICE
			  FROM (
					SELECT --P.DIVISION_ID
					       D.ATTRIBUTE3 AS DIVISION_ID
					,      MAX(P.PROJECT_CODE) PROJECT_CODE
					,      P.SCM_SITE_ID
					,      P.PLANT_SITE_ID
					,      P.ITEM_ID
					,      CONVERT(VARCHAR,DATEPART(WEEK,P.YYYYMMDD)) WEEK 
					,      P.FCST_TYPE
					,      P.INCOTERMS
					,      MAX(P.PRICE) PRICE 
					  FROM SCM_MST_FUTURE_PRICE		AS P WITH(NOLOCK)
					       JOIN SCM_MST_DIVISION	AS D WITH(NOLOCK)
						ON P.DIVISION_ID = D.DIVISION_ID

					WHERE 1 = 1
					AND   D.ATTRIBUTE3 IN ('40','81','82')
					AND   P.MEASURE		= 'KRW'
					AND   P.YYYYMMDD	>= CONVERT(char(8),  GETDATE()-30, 112)
					GROUP BY D.ATTRIBUTE3
					,        P.SCM_SITE_ID
					,		 P.PLANT_SITE_ID
					,		 P.ITEM_ID
					,		 CONVERT(VARCHAR,DATEPART(WEEK,P.YYYYMMDD))
					,		 P.FCST_TYPE
					,        P.INCOTERMS
			      ) PRI
			GROUP BY DIVISION_ID
			,        PROJECT_CODE
			,        SCM_SITE_ID
			,        PLANT_SITE_ID
			,        ITEM_ID
			,        WEEK 
			,        FCST_TYPE
			,        INCOTERMS 
			;


			DELETE 
			FROM SSP_KPI_SHIPMENT_PSI
			WHERE SUM_YYYYMMDD = @v_sum_yyyymmdd
			;


			INSERT INTO SSP_KPI_SHIPMENT_PSI(
					 SUM_YYYYMMDD           
					,YYYYMM          
					,START_YYYYMMDD            
					,COMPANY_ID           
					,PLANT_ID             
					,DIVISION_ID          
					,OPERATION_GROUP      
					,FROM_SITE            
					,TO_SITE              
					,SHIPTO_CODE          
					,ITEM_ID              
					,YYYYMMDD             
					,PLAN_QTY             
					,PLAN_QTY_TO_CELL
					,SALES_AMT
					,PROJECT_CODE       
					,FCST_TYPE           
					,INCOTERMS          
					,TRANSPORT_MODE  
					,END_CUSTOMER
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE  
					,ATTRIBUTE1     
					,ATTRIBUTE2   				  
			  )
			  SELECT P.SUM_YYYYMMDD           
					,P.YYYYMM          
					,P.START_YYYYMMDD            
					,P.COMPANY_ID           
					,P.PLANT_ID             
					,P.DIVISION_ID 
					,P.OPERATION_GROUP      
					,P.FROM_SITE            
					,P.TO_SITE              
					,P.SHIPTO_CODE          
					,P.ITEM_ID              
					,P.YYYYMMDD             
					,P.PLAN_QTY             
					,P.PLAN_QTY_TO_CELL
					,P.PLAN_QTY * S.PRICE         AS SALES_AMT   
					,ISNULL(P.PROJECT_CODE ,'-')  AS PROJECT_CODE  --소형의 경우 PROJECT_CODE가 없음
					,P.FCST_TYPE           
					,P.INCOTERMS          
					,P.TRANSPORT_MODE  
					,ISNULL(P.END_CUSTOMER,'-')   AS END_CUSTOMER 
					,@v_batch_user AS CREATED_BY
					,GETDATE()     AS CREATION_DATE
					,@v_batch_user AS LAST_UPDATED_BY
					,GETDATE()     AS LAST_UPDATE_DATE	
					,P.CONFIRM_ID	
					,P.SUM_YYYYMMDD_B		 
			    FROM #tmp_SSP_KPI_SHIPMENT_PSI P WITH(NOLOCK) 
			       LEFT OUTER JOIN #tmp_SCM_MST_FUTURE_PRICE S WITH(NOLOCK) 
				     ON P.DIVISION_ID  = S.DIVISION_ID
					AND P.PROJECT_CODE = CASE WHEN P.DIVISION_ID IN ('81','82') THEN S.PROJECT_CODE ELSE P.PROJECT_CODE END
					AND P.TO_SITE      = S.TO_SITE
					AND P.FROM_SITE    = CASE WHEN P.DIVISION_ID = '81' THEN  S.FROM_SITE ELSE P.FROM_SITE END
					AND P.ITEM_ID      = S.ITEM_ID
					AND CONVERT(VARCHAR,DATEPART(WEEK,P.YYYYMMDD)) = S.WEEK
					AND P.FCST_TYPE    = S.FCST_TYPE
					AND P.INCOTERMS    = S.INCOTERMS 
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
        SET @d_event_date =  SYSDATETIME();

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
