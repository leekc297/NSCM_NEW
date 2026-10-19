/*
 * Program ID   : PR_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY  
 * Description  : KPI 출하지시 준수율 DIA (DELIVERY_INSTRUCTION_ACCURACY )DW 전송(08시)
 *                매주 월요일 11:00 수행( BATCH JOB : JOB.PR_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY ) 
 * Execute      : EXEC PR_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.09.27   LJH            Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019.01.09   LJH            상품창고 출하제외 (Requested by 지준혁, 2019.01.09) , 20181022 ~ 20190106 데이터 재 생성함 
 * 2019.01.10   LJH		       FROM_SITE, TO_SITE가 Packer인 경우 대상 제외(reqeusted by 지준혁-20190110) 
 * 2019.04.05   LJH		       기준일자를 DELIVERY_POSTING_DATE --> ETD_DATE로 변경 (reqeusted by 지준혁-20190405) 
 * 2019.04.17   LJH		       기준일자를 ETD_DATE --> DELIVERY_POSTING_DATE로 원복 (reqeusted by 지준혁-20190417) 
 * 2019.10.07   LJH            출하실적 집계 변경[PJ20189106] 전지.GSCM 고도화 이행 
                                - 날짜 EXFACTORY_DATE로변경 
							    - order type 추가(ZFDC, ZKM)
                                - 제외창고 추가 799A 
 * 2020.05.06	KIMYONGHO	   [C20200403-000062] [GSCM PI] SSP 출하 실적 집계 중 사외 창고 제외 로직 추가 건 
 * 2020.09.18   kim bok ki     lookup_type = 'ERP_ORDER_TYPE' 제거
 * 2021.04.15   SSP Pjt.       lookup_type = 'ERP_ORDER_TYPE' 재적용
 * 2021.04.30   SSP Pjt.       SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY.attribute1에 ISOYYYYWW 값 적용
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
*/
CREATE PROCEDURE [dbo].[PR_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY]
--( 
--	--  @p_division_id        NVARCHAR(30)
--) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_CONFIRM INSERT LOGIC';
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


    DECLARE @v_start_yyyymmdd  NVARCHAR(8) = '';
    DECLARE @v_end_yyyymmdd    NVARCHAR(8) = '';


    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

          ------------------------------------------------------------------------------------------------------------- 
          -- 0. temp 테이블 생성 : 생성후 마지막에 한번에 입력하기 위해서
          ------------------------------------------------------------------------------------------------------------- 
          IF OBJECT_ID('tempdb..#tmp_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY') IS NOT NULL
              DROP TABLE #tmp_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY

            CREATE TABLE #tmp_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY(
				 DIVISION_ID          nvarchar(030)   
				,PLANT_ID             nvarchar(030)   
				,OPERATION_GROUP      nvarchar(030)   
				,FROM_SITE            nvarchar(030)   
				,TO_SITE              nvarchar(030)   
				,ITEM_ID              nvarchar(050)   
				,YYYYMMDD             nvarchar(008)    
				,YYYYMM               nvarchar(006)    
				,WEEK_NAME            nvarchar(010)   
				,DO_QTY               numeric(20, 10)
				,EXFACTORY_QTY        numeric(20, 10)
            );



		------------------------------------------------------------------------------------------------------------- 
		-- 0. 전주 대상 조회 ( 월요일 ~ 일요일) 
		------------------------------------------------------------------------------------------------------------- 

		SET  @v_start_yyyymmdd = CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,GETDATE())/7,-7), 112) ; -- 전주월요일(현재일기준)   
		SET  @v_end_yyyymmdd  =  CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,GETDATE())/7,-1), 112) ; -- 전주일요일(현재일기준)

     	------------------------------------------------------------------------------------------------------------- 
		-- 1. KPI_SPA_SHIPPING_PLAN_ACCURACY :  #tmp_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY  
		------------------------------------------------------------------------------------------------------------- 
		/* 대상 ORDER_TYPE : LOOKUP_TYPE = 'ERP_ORDER_TYPE' 등록 
			ZEF  :수출 무상-Shipment용
			ZEFC :수출 무상-Claim용
			ZEML :수출 무상사급 주문
			ZEMM :수출 유상사급 주문
			ZEX  :Export Order(수출주문)
			ZFD  :Deliv.Free of Charge(무상 주문-견본)
			ZFR  :수출 무상주문
			ZKB  :위탁품보충
			ZMM  :내수유상사급
			ZOR  :Standard Order(내수오더) 
			ZFDC :Free of Charge           
			ZKM  :Consign Fill-up(POD)
		*/

		INSERT INTO #tmp_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY(
					 DIVISION_ID           
					,PLANT_ID              
					,OPERATION_GROUP       
					,FROM_SITE             
					,TO_SITE               
					,ITEM_ID               
					,YYYYMMDD               
					,YYYYMM                 
					,WEEK_NAME             
					,DO_QTY           
					,EXFACTORY_QTY        
		  )
			SELECT --X.DIVISION_ID
			       D.ATTRIBUTE3
			,      X.PLANT_ID 
			,      F.OPERATION_GROUP
			,      X.FROM_SITE
			--   ERP실적에SSP 유효한 CONFIRM_ID가 있는 경우는 SSP의 TO_SITE 아니면 SOLDTO,SHIPTO,TO_SITE MAPPING LOOKUP 사용
			,      CASE WHEN C.CONFIRM_ID <> '-' THEN C.TO_SITE ELSE ISNULL(L3.SEGMENT4,X.TO_SITE) END  AS TO_SITE
			,      X.ITEM_ID 
			,      X.YYYYMMDD 
			,      SUBSTRING (X.YYYYMMDD ,1,6)  AS YYYYMM
			,      A.WEEK_NAME
			,      SUM(X.DO_QTY)       AS  DO_QTY
			,      SUM(X.EXFACTORY_QTY)       AS  EXFACTORY_QTY

			
			--SELECT X.* , C.CONFIRM_ID , C.TO_SITE  , L3.SEGMENT4 
			--,   CASE WHEN C.CONFIRM_ID <> '-' THEN C.TO_SITE ELSE ISNULL(L3.SEGMENT4,X.TO_SITE) END  AS TO_SITE
			
			FROM (
					-- DO 수량  기준일자 : DELIVERY_POSTING_DATE(납품요청일ETD) , EXFACTORY_STATUS <> D90
					-- EXFACTORY_STATUS : D10(DO생성), D20(PLANT ISSUE), D30(INTRANSIT), D40(매출처리), D90(DO삭제) 
					SELECT R.DIVISION_ID                               AS DIVISION_iD
					,      CASE WHEN FS.OSP_YN = 'N' THEN FS.PLANT_ID 
								ELSE  FS.LOGISTIC_PLANT_ID  END		   AS PLANT_ID             
					,      R.FROM_SCM_SITE_ID                          AS FROM_SITE
					,      R.TO_SCM_SITE_ID                            AS TO_SITE
					,      R.ITEM_ID                                   AS ITEM_ID
					,      R.EXFACTORY_DATE                            AS YYYYMMDD
					--,      R.ETD_DATE                                  AS YYYYMMDD
					,      R.EXFACTORY_QTY                             AS DO_QTY 
					,      0                                           AS EXFACTORY_QTY
					,      R.ORDER_TYPE_CODE                           AS ORDER_TYPE_CODE
					,      R.CONFIRM_ID                                AS CONFIRM_ID 
					,      R.SHIPTO_CODE                               AS SHIPTO_CODE 
					,      R.SOLDTO_CODE                               AS SOLDTO_CODE   
					FROM   SCM_DNM_EXFACTORY_RESULT R WITH(NOLOCK)  
					JOIN SCM_MST_SITE FS WITH(NOLOCK)
	 				  ON FS.DIVISION_ID  = R.DIVISION_ID 
					 AND FS.SCM_SITE_ID  = R.FROM_SCM_SITE_ID  
					
					WHERE  1=1 
					AND    ISNULL(R.EXFACTORY_STATUS,'D90' ) <> 'D90' -- D90: DO삭제  
					AND    R.STORAGE_ID NOT IN ('6000' ,'799A') -- 상품창고 출하제외 (Requested by 지준혁, 2019.01.09) 
					--[C20200403-000062]
					AND    R.STORAGE_ID NOT IN (SELECT SEGMENT1 
											FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
										    WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
											 AND VALID_YN = 'Y'
										   )	-- 사외 창고 제외 LOOKUP 관리

					AND    R.FROM_SCM_SITE_ID IS NOT NULL 
					AND    R.TO_SCM_SITE_ID   IS NOT NULL 

					UNION ALL 

					-- 출하 수량  기준일자 :  DELIVERY_POSTING_DATE(납품요청일ETD) , EXFACTORY_STATUS NOT IN ('D90','D10')
					SELECT R.DIVISION_ID                               AS DIVISION_iD
					,      CASE WHEN FS.OSP_YN = 'N' THEN FS.PLANT_ID 
								ELSE  FS.LOGISTIC_PLANT_ID  END		   AS PLANT_ID     
					,      R.FROM_SCM_SITE_ID                          AS FROM_SITE
					,      R.TO_SCM_SITE_ID                            AS TO_SITE
					,      R.ITEM_ID                                   AS ITEM_ID
					,      R.EXFACTORY_DATE                            AS YYYYMMDD
					--,      R.ETD_DATE                                  AS YYYYMMDD
					,      0                                           AS DO_QTY
					,      R.EXFACTORY_QTY                             AS EXFACTORY_QTY
					,      R.ORDER_TYPE_CODE                           AS ORDER_TYPE_CODE
					,      R.CONFIRM_ID                                AS CONFIRM_ID 
					,      R.SHIPTO_CODE                               AS SHIPTO_CODE 
					,      R.SOLDTO_CODE                               AS SOLDTO_CODE   
					FROM   SCM_DNM_EXFACTORY_RESULT R WITH(NOLOCK) 
					JOIN SCM_MST_SITE FS WITH(NOLOCK)
	 				  ON FS.DIVISION_ID  = R.DIVISION_ID 
					 AND FS.SCM_SITE_ID  = R.FROM_SCM_SITE_ID  	
					WHERE  1=1 
					AND    ISNULL(R.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
					AND    R.STORAGE_ID NOT IN ('6000' ,'799A')-- 상품창고 출하제외 (Requested by 지준혁, 2019.01.09)
					--[C20200403-000062]
					AND    R.STORAGE_ID NOT IN (SELECT SEGMENT1 
											FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
										    WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
											 AND VALID_YN = 'Y'
										   )	-- 사외 창고 제외 LOOKUP 관리

					AND    R.FROM_SCM_SITE_ID IS NOT NULL 
					AND    R.TO_SCM_SITE_ID   IS NOT NULL 
					) X 

			JOIN SCM_MST_DIVISION D WITH(NOLOCK)
			  ON X.DIVISION_ID	= D.DIVISION_ID

			JOIN SCM_SYS_CALENDAR_M A WITH(NOLOCK)
			  ON A.BASIS_YYYYMMDD  = X.YYYYMMDD 
			JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
			  ON F.DIVISION_ID  = X.DIVISION_iD
			 AND F.ITEM_ID      = X.ITEM_ID 

			-- 2020.09.18 김광희 책임 요청으로 주석처리
			-- 2021.04.15 김광희 책임 요청으로 주석해제
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
			 ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE 
			AND L.VALID_YN    = 'Y'
			AND L.SEGMENT1    = X.ORDER_TYPE_CODE

			LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
		      ON C.CONFIRM_ID = X.CONFIRM_ID 
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
					ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
				AND L3.SEGMENT1    = X.DIVISION_ID 
				AND L3.SEGMENT2    = X.SOLDTO_CODE
				AND L3.SEGMENT3    = X.SHIPTO_CODE
			WHERE 1=1 
			AND   X.YYYYMMDD  BETWEEN @v_start_yyyymmdd   AND  @v_end_yyyymmdd
			GROUP BY --X.DIVISION_ID
			         D.ATTRIBUTE3
			,        X.PLANT_ID 
			,        F.OPERATION_GROUP
			,        X.FROM_SITE
			,        CASE WHEN C.CONFIRM_ID <> '-' THEN C.TO_SITE ELSE ISNULL(L3.SEGMENT4,X.TO_SITE) END
			,        X.ITEM_ID 
			,        X.YYYYMMDD 
			,        A.WEEK_NAME      
			 ;

		------------------------------------------------------------------------------------------------------------- 
		-- 2. KPI_SPA_SHIPPING_PLAN_ACCURACY
		-------------------------------------------------------------------------------------------------------------
		DELETE 
		FROM SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY
		WHERE YYYYMMDD BETWEEN @v_start_yyyymmdd   AND  @v_end_yyyymmdd ;

		
		 
		INSERT INTO SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY (
				 DIVISION_ID       
				,PLANT_ID          
				,OPERATION_GROUP   
				,FROM_SITE         
				,TO_SITE           
				,ITEM_ID           
				,YYYYMMDD          
				,YYYYMM            
				,WEEK_NAME         
				,DO_QTY        
				,EXFACTORY_QTY          
				,CREATED_BY                      
				,CREATION_DATE    
				,LAST_UPDATED_BY  
				,LAST_UPDATE_DATE 
				,ATTRIBUTE1       
				,ATTRIBUTE2       
				,ATTRIBUTE3       
				,ATTRIBUTE4       
				,ATTRIBUTE5       
				,ATTRIBUTE6       
				,ATTRIBUTE7       
				,ATTRIBUTE8       
				,ATTRIBUTE9       
				,ATTRIBUTE10      
		  )
		  SELECT KPI.DIVISION_ID       
				,KPI.PLANT_ID          
				,KPI.OPERATION_GROUP   
				,KPI.FROM_SITE         
				,KPI.TO_SITE           
				,KPI.ITEM_ID           
				,KPI.YYYYMMDD          
				,KPI.YYYYMM            
				,KPI.WEEK_NAME         
				,KPI.DO_QTY        
				,KPI.EXFACTORY_QTY          
				,@v_batch_user  -- CREATED_BY                     
				,GETDATE()      -- CREATION_DATE    
				,@v_batch_user  -- LAST_UPDATED_BY
				,GETDATE()      -- LAST_UPDATE_DATE 
				,C.ISO_YYYYWW   -- ATTRIBUTE1       
				,NULL			-- ATTRIBUTE2       
				,NULL			-- ATTRIBUTE3       
				,NULL			-- ATTRIBUTE4       
				,NULL			-- ATTRIBUTE5       
				,NULL			-- ATTRIBUTE6       
				,NULL			-- ATTRIBUTE7       
				,NULL			-- ATTRIBUTE8       
				,NULL			-- ATTRIBUTE9       
				,NULL			-- ATTRIBUTE10      
		  FROM #tmp_SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY KPI WITH(NOLOCK)
		  		JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
			ON C.BASIS_YYYYMMDD  = KPI.YYYYMMDD 
		  ;
/*
        -- FROM_SITE, TO_SITE가 Packer인 경우 대상 제외(reqeusted by 지준혁-20190110) 
		-- TO_SITE가 Packer인 경우 대상 포함 (reqeusted by 지준혁-20190920)  
		DELETE FROM SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY  
		FROM SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY  DIA
		JOIN SCM_MST_SITE FS 
			ON FS.SCM_SITE_ID = DIA.FROM_SITE 
		   AND FS.DIVISION_ID = DIA.DIVISION_ID 
		WHERE  FS.OSP_YN = 'Y' 
		AND    DIA.YYYYMMDD BETWEEN @v_start_yyyymmdd   AND  @v_end_yyyymmdd
		;
*/
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
      SET @v_description = @v_program_name + N' ERROR_LINE : ' + STR(ERROR_LINE());
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
