/*
 * Program ID   : PR_SSP_KPI_ASR_AUTO_SO_RATE  
 * Description  : KPI AUTO SO 생성률 ASA (AUTO_SO_APPLY )
				  출하 실적 중 SSP System을 통해서 SO Suggestion 된 SO를 적용 하여 출하가 발생한 비율
 *                매주 월요일 07:00 수행( BATCH JOB : JOB.PR_SSP_KPI_ASR_AUTO_SO_RATE ) 
 * Execute      : EXEC PR_SSP_KPI_ASA_AUTO_SO_APPLY 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.05.09   AYJ            Initial Release [CSR ID:3969613] [지표정의] GSCM Portal 관련 HI 지표 산출
 * 2019.10.07   LJH            KPI AUTO SO 생성률 집계 변경[PJ20189106] 전지.GSCM 고도화 이행 
                               - ORDER TYPE  대상 적용(LOOKUP등록) 
                               - FROM_SITE가 PACKER인 경우 제외 
                               - '6000' ,'799A' 창고 제외
                               - ORDER_NO , ORDER_CREATION_DATE 기준 
                               - 분모에 SSP_TYPE 대상 아닌것 제외 (LOOKUP등록) 
                               - SCP에서 정의된 계획 대상 아닌 ITEM 제외 
 * 2020.05.08   LJH            [C20200507-000095]Auto SO 적용율에 SO 기반 출하미 대상(외주 임가공출고) 모수 제외 
                               - 81,40 사업부 : FROM_SITE, TO_SITE가 PACKER인것 제외 
                               - 82    사업부 : TO_SITE가 PACKER인것 제외   
 * 2020.05.06	KIMYONGHO      [C20200403-000062] [GSCM PI] SSP 출하 실적 집계 중 사외 창고 제외 로직 추가 건
 * 2020.09.18   kim bok ki     lookup_type = 'ERP_ORDER_TYPE' 제거
 * 2021.04.15   SSP Pjt.       lookup_type = 'ERP_ORDER_TYPE' 재적용
 * 2021.04.30   SSP Pjt.       SSP_KPI_ASR_AUTO_SO_RATE_DW.attribute1에 ISOYYYYWW 값 적용
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용	
*/
CREATE PROCEDURE [dbo].[PR_SSP_KPI_ASR_AUTO_SO_RATE]
--( 
--	--  @p_division_id        NVARCHAR(30)
--) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
   -- SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_KPI_ASR_AUTO_SO_RATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_KPI_ASR_AUTO_SO_RATE'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_KPI_ASR_AUTO_SO_RATE INSERT LOGIC';
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
          IF OBJECT_ID('tempdb..#tmp_SSP_KPI_ASR_AUTO_SO_RATE') IS NOT NULL
              DROP TABLE #tmp_SSP_KPI_ASR_AUTO_SO_RATE

            CREATE TABLE #tmp_SSP_KPI_ASR_AUTO_SO_RATE(
				 YYYYMMDD             nvarchar(008)    
				,DIVISION_ID          nvarchar(030)   
				,FROM_SITE            nvarchar(030)   
				,ITEM_ID              nvarchar(100)  
				,TO_SITE              nvarchar(060)       
				,CONFIRM_ID           nvarchar(040)  
				,SSP_SO_NO            nvarchar(030) 
				,TOT_SO_NO            nvarchar(030) 				
            );
		
		------------------------------------------------------------------------------------------------------------- 
		-- 0. 전주 대상 조회 ( 월요일 ~ 일요일) 
		------------------------------------------------------------------------------------------------------------- 

		SET  @v_start_yyyymmdd = CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,GETDATE())/7,-7), 112) ; -- 전주월요일(현재일기준)   
		SET  @v_end_yyyymmdd  =  CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,GETDATE())/7,-1), 112) ; -- 전주일요일(현재일기준)

     	------------------------------------------------------------------------------------------------------------- 
		-- 1. SSP_KPI_ASR_AUTO_SO_RATE :  #tmp_SSP_KPI_ASR_AUTO_SO_RATE  
		------------------------------------------------------------------------------------------------------------- 
		INSERT INTO #tmp_SSP_KPI_ASR_AUTO_SO_RATE(
				 YYYYMMDD     
				,DIVISION_ID 
				,FROM_SITE   
				,ITEM_ID     
				,TO_SITE     
				,CONFIRM_ID  
				,SSP_SO_NO   
				,TOT_SO_NO   
		  )
		SELECT R.ORDER_CREATE_DATE         AS YYYYMMDD
		,      R.DIVISION_ID               AS DIVISION_ID 
		,      R.FROM_SCM_SITE_ID          AS FROM_SITE
		,      R.ITEM_ID                   AS ITEM_ID 
		--  ERP실적에SSP 유효한 CONFIRM_ID가 있는 경우는 SSP의 TO_SITE 아니면 SOLDTO,SHIPTO,TO_SITE MAPPING LOOKUP 사용 
		,      CASE WHEN C.CONFIRM_ID <> '-' THEN C.TO_SITE ELSE ISNULL(L3.SEGMENT4,R.TO_SCM_SITE_ID) END  AS TO_SITE  
		,      C.CONFIRM_ID                AS CONFIRM_ID 
        ,      CASE WHEN C.CONFIRM_ID <> '-' THEN R.ORDER_NO ELSE NULL  END  SSP_SO_NO 
		,      R.ORDER_NO                  AS TOT_SO_NO 
		FROM  SCM_DNM_EXFACTORY_RESULT R WITH(NOLOCK)

			-- 2020.09.18 김광희 책임 요청으로 주석처리
			-- 2021.04.15 김광희 책임 요청으로 주석해제
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE 
			AND L.VALID_YN    = 'Y'
			AND L.SEGMENT1    = R.ORDER_TYPE_CODE

			JOIN SCM_MST_SITE FS WITH(NOLOCK)
				ON FS.DIVISION_ID  = R.DIVISION_ID 
				AND FS.SCM_SITE_ID  = R.FROM_SCM_SITE_ID 
			--	AND ISNULL(FS.OSP_YN,'N') <> 'Y'  --  FROM_SITE가 Packer인 경우 대상 제외

			JOIN SCP_MST_FINAL_ITEM F  WITH(NOLOCK)
				ON F.ITEM_ID = R.ITEM_ID
			   AND F.DIVISION_ID = R.DIVISION_ID  

		    LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
			        ON C.CONFIRM_ID = R.CONFIRM_ID 
							 
 			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L2 WITH(NOLOCK)
					ON L2.LOOKUP_TYPE = 'ERP_SSP_TYPE' 
				AND L2.SEGMENT1    = R.SSP_TYPE 

			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
					ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
				AND L3.SEGMENT1    = R.DIVISION_ID 
				AND L3.SEGMENT2    = R.SOLDTO_CODE
				AND L3.SEGMENT3    = R.SHIPTO_CODE
		WHERE  1=1 
		AND    ISNULL(R.EXFACTORY_STATUS,'D90' ) <> 'D90' -- D90: DO삭제  
		AND    R.FROM_SCM_SITE_ID IS NOT NULL 
		AND    R.TO_SCM_SITE_ID   IS NOT NULL 
		AND    R.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
		--[C20200403-000062]
		AND   R.STORAGE_ID NOT IN (SELECT SEGMENT1 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
								WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
									AND VALID_YN = 'Y'
								)	-- 사외 창고 제외 LOOKUP 관리
		AND    R.ORDER_CREATE_DATE  BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd
		AND    ISNULL(L2.VALID_YN , 'Y') = 'Y' -- SSP_TYPE VALID_YN 이 Y인것만 (SSP_TYPE이 없는것은 포함) 
		GROUP BY R.ORDER_CREATE_DATE 
		,        R.DIVISION_ID
		,        R.FROM_SCM_SITE_ID
		,        CASE WHEN C.CONFIRM_ID <> '-' THEN C.TO_SITE ELSE ISNULL(L3.SEGMENT4,R.TO_SCM_SITE_ID) END  
		,        R.ITEM_ID 
		,        C.CONFIRM_ID
		,        R.ORDER_NO

		;

       -- [C20200507-000095]Auto SO 적용율에 SO 기반 출하미 대상(외주 임가공출고) 모수 제외
       -- 81,40 사업부 : FROM_SITE, TO_SITE가 PACKER인것 제외 
       -- 82    사업부 : TO_SITE가 PACKER인것 제외

	    -- 81,40 FROM_SITE PACKER 제외 
		DELETE FROM #tmp_SSP_KPI_ASR_AUTO_SO_RATE
		FROM #tmp_SSP_KPI_ASR_AUTO_SO_RATE T WITH(NOLOCK) 
			JOIN SCM_MST_SITE FS WITH(NOLOCK) 
			  ON FS.DIVISION_ID = T.DIVISION_ID 
			 AND FS.SCM_SITE_ID = T.FROM_SITE 
			 AND FS.OSP_YN = 'Y'
			 AND FS.DIVISION_ID <>'82'
        ;

		---- 81,82,40  TO_SITE PACKER 제외 
		--DELETE FROM #tmp_SSP_KPI_ASR_AUTO_SO_RATE
		--FROM #tmp_SSP_KPI_ASR_AUTO_SO_RATE T WITH(NOLOCK) 
		--	JOIN SCM_MST_SITE TS WITH(NOLOCK) 
		--	  ON TS.DIVISION_ID = T.DIVISION_ID 
		--	 AND TS.SCM_SITE_ID = T.TO_SITE 
		--	 AND TS.OSP_YN = 'Y'
  --      ;

		------------------------------------------------------------------------------------------------------------- 
		-- 2. SSP_KPI_ASR_AUTO_SO_RATE (GSCM_PORTAL) 
		-------------------------------------------------------------------------------------------------------------
		DELETE 
		FROM SSP_KPI_ASR_AUTO_SO_RATE
		WHERE YYYYMMDD BETWEEN @v_start_yyyymmdd  AND  @v_end_yyyymmdd ;
		 
		INSERT INTO SSP_KPI_ASR_AUTO_SO_RATE (
				    DIVISION_ID       
				   ,FROM_SITE         
				   ,YYYYMMDD          
				   ,YYYYMM            
				   ,WEEK_NAME         
				   ,SSP_SO        
				   ,TOT_SO          
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
		     SELECT --A.DIVISION_ID 
		            D.ATTRIBUTE3 AS DIVISION_ID
				   ,A.FROM_SITE         
				   ,A.YYYYMMDD          
				   ,C.BASIS_YYYYMM  -- YYYYMM            
				   ,C.WEEK_NAME 
				   ,COUNT(DISTINCT A.SSP_SO_NO)  
				   ,COUNT(DISTINCT A.TOT_SO_NO)            
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
		       FROM #tmp_SSP_KPI_ASR_AUTO_SO_RATE A WITH (NOLOCK)
			        JOIN SCM_MST_DIVISION D WITH(NOLOCK)
			     ON A.DIVISION_ID	= D.DIVISION_ID

		       JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
			     ON C.BASIS_YYYYMMDD = A.YYYYMMDD 
			   JOIN SCM_MST_SITE FS WITH(NOLOCK) 
				 ON FS.DIVISION_ID = A.DIVISION_ID 
				AND FS.SCM_SITE_ID = A.FROM_SITE   
          GROUP BY 
		         --A.DIVISION_ID  
				 D.ATTRIBUTE3
				,A.FROM_SITE         
				,A.YYYYMMDD          
				,C.BASIS_YYYYMM  -- YYYYMM            
				,C.WEEK_NAME 
				,C.ISO_YYYYWW
		  ;

		------------------------------------------------------------------------------------------------------------- 
		-- 3. SSP_KPI_ASR_AUTO_SO_RATE_DW (DW) 
		-------------------------------------------------------------------------------------------------------------
		DELETE 
		FROM SSP_KPI_ASR_AUTO_SO_RATE_DW
		WHERE YYYYMMDD BETWEEN @v_start_yyyymmdd  AND  @v_end_yyyymmdd ;


		INSERT INTO SSP_KPI_ASR_AUTO_SO_RATE_DW (
				    YYYYMMDD
				   ,YYYYMM
				   ,WEEK_NAME
				   ,DIVISION_ID
				   ,PLANT_ID
				   ,OPERATION_GROUP 
				   ,FROM_SITE
				   ,ITEM_ID
				   ,TO_SITE
				   ,CONFIRM_ID
				   ,SSP_SO_NO
				   ,TOT_SO_NO				        
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
		     SELECT A.YYYYMMDD
				   ,C.BASIS_YYYYMM  -- YYYYMM    
				   ,C.WEEK_NAME 
		           --,A.DIVISION_ID  
				   ,D.ATTRIBUTE3	AS DIVISION_ID
				   ,CASE WHEN FS.OSP_YN = 'N' THEN FS.PLANT_ID 
		   		   	     ELSE  FS.LOGISTIC_PLANT_ID  END		   AS PLANT_ID 
				   ,FS.OPERATION_GROUP 				     
				   ,A.FROM_SITE
				   ,A.ITEM_ID          
                   ,A.TO_SITE
				   ,MAX(A.CONFIRM_ID)  AS CONFIRM_ID
				   ,MAX(A.SSP_SO_NO) AS SSP_SO_NO
				   ,A.TOT_SO_NO
				   ,@v_batch_user  -- CREATED_BY                     
				   ,GETDATE()      -- CREATION_DATE    
				   ,@v_batch_user  -- LAST_UPDATED_BY
				   ,GETDATE()      -- LAST_UPDATE_DATE 
				   ,MAX(C.ISO_YYYYWW) AS ISO_YYYYWW   -- ATTRIBUTE1       
				   ,NULL			-- ATTRIBUTE2       
				   ,NULL			-- ATTRIBUTE3       
				   ,NULL			-- ATTRIBUTE4       
				   ,NULL			-- ATTRIBUTE5       
				   ,NULL			-- ATTRIBUTE6       
				   ,NULL			-- ATTRIBUTE7       
				   ,NULL			-- ATTRIBUTE8       
				   ,NULL			-- ATTRIBUTE9       
				   ,NULL			-- ATTRIBUTE10      
		       FROM #tmp_SSP_KPI_ASR_AUTO_SO_RATE A WITH (NOLOCK)
			        JOIN SCM_MST_DIVISION D WITH(NOLOCK)
			     ON A.DIVISION_ID	= D.DIVISION_ID

		       JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
			     ON C.BASIS_YYYYMMDD = A.YYYYMMDD 
		       JOIN SCM_MST_SITE FS WITH(NOLOCK)
			     ON FS.DIVISION_ID  = A.DIVISION_ID
			    AND FS.SCM_SITE_ID  = A.FROM_SITE   
		 GROUP BY A.YYYYMMDD
				,C.BASIS_YYYYMM  
				,C.WEEK_NAME 
		        --,A.DIVISION_ID
				,D.ATTRIBUTE3
				,FS.PLANT_ID 
				, FS.OSP_YN 
				, FS.LOGISTIC_PLANT_ID
				, FS.OPERATION_GROUP
				,A.FROM_SITE
				,A.ITEM_ID          
                ,A.TO_SITE
				--,A.SSP_SO_NO
				,A.TOT_SO_NO
				--,C.ISO_YYYYWW

		  ;

		-- 전극제외 (2019.10.08) Requested by 지준혁 
/*      -- 전극포함 (2020.06.17) Requested by 김광희 		
		DELETE 
		FROM SSP_KPI_ASR_AUTO_SO_RATE_DW
		WHERE YYYYMMDD BETWEEN @v_start_yyyymmdd  AND  @v_end_yyyymmdd 
		AND   OPERATION_GROUP = 'E' ;
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
