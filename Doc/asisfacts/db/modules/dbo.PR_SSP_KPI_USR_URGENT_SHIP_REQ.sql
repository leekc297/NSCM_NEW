
/*
 * Program ID   : PR_SSP_KPI_USR_URGENT_SHIP_REQ  
 * Description  : KPI 긴급출하요청(출하 3일 이내 신규 출하 생성 건수) 
 *                매일 07:00 수행( BATCH JOB : JOB.PR_SSP_KPI_USR_URGENT_SHIP_REQ ) 
 * Execute      : EXEC PR_SSP_KPI_USR_URGENT_SHIP_REQ 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.05.09   AYJ            Initial Release [CSR ID:3969613] [지표정의] GSCM Portal 관련 HI 지표 산출
 * 2021.04.30   SSP Pjt.       SSP_KPI_USR_URGENT_SHIP_REQ.attribute1에 ISOYYYYWW 값 적용
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 */
CREATE PROCEDURE [dbo].[PR_SSP_KPI_USR_URGENT_SHIP_REQ]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_KPI_USR_URGENT_SHIP_REQ';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_KPI_USR_URGENT_SHIP_REQ'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_KPI_USR_URGENT_SHIP_REQ INSERT LOGIC';
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


    DECLARE @v_yyyymmdd  NVARCHAR(8) = '';


    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

          ------------------------------------------------------------------------------------------------------------- 
          -- 0. temp 테이블 생성 : 생성후 마지막에 한번에 입력하기 위해서
          ------------------------------------------------------------------------------------------------------------- 
          IF OBJECT_ID('tempdb..#tmp_SSP_KPI_USR_URGENT_SHIP_REQ') IS NOT NULL
              DROP TABLE #tmp_SSP_KPI_USR_URGENT_SHIP_REQ

            CREATE TABLE #tmp_SSP_KPI_USR_URGENT_SHIP_REQ(
					 YYYYMMDD               nvarchar(30)   
					,DIVISION_ID            nvarchar(30)   
					,FROM_SITE              nvarchar(30)   
					,TO_SITE                nvarchar(30)   
					,ITEM_ID                nvarchar(50)   
					,CONFIRM_ID             nvarchar(20)   
					,REQUESTOR              nvarchar(150)  
					,REQUESTOR_DEPT         nvarchar(150)  
					,D_CNT                  bigint         
					,D1_CNT                 bigint         
					,D2_CNT                 bigint         
					,D_QTY                  numeric(20, 10)
					,D1_QTY                 numeric(20, 10)
					,D2_QTY                 numeric(20, 10)
				 );

		------------------------------------------------------------------------------------------------------------- 
		-- 0. 전일 대상 조회 (현재일 기준 전일) 
		------------------------------------------------------------------------------------------------------------- 

		SET  @v_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, GETDATE()), 112) ; -- 전일(현재일기준)   

     	------------------------------------------------------------------------------------------------------------- 
		-- 1. SSP_KPI_USR_URGENT_SHIP_REQ :  #tmp_SSP_KPI_USR_URGENT_SHIP_REQ
		------------------------------------------------------------------------------------------------------------- 

		INSERT INTO #tmp_SSP_KPI_USR_URGENT_SHIP_REQ(
					 YYYYMMDD               
					,DIVISION_ID            
					,FROM_SITE              
					,TO_SITE                
					,ITEM_ID                
					,CONFIRM_ID             
					,REQUESTOR              
					,REQUESTOR_DEPT         
					,D_CNT                  
					,D1_CNT                 
					,D2_CNT                 
					,D_QTY                  
					,D1_QTY                 
					,D2_QTY                     
		  )
		SELECT CONVERT(CHAR(8),A.APPROVAL_TIME, 112)	AS YYYYMMDD
		--,      A.DIVISION_ID                            AS DIVISION_ID
		,      D.ATTRIBUTE3                             AS DIVISION_ID
		,      B.FROM_SITE								AS FROM_SITE
		,      B.TO_SITE								AS TO_SITE
		,      B.ITEM_ID								AS ITEM_ID
		,      B.CONFIRM_ID								AS CONFIRM_ID
		,      A.REQUEST_USER							AS REQUEST_USER
		,      A.REQUEST_DEPT							AS REQUEST_DEPT
		,      SUM(CASE WHEN B.NEW_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD,  0, A.APPROVAL_TIME), 112) THEN 1 ELSE 0 END)  AS D_CNT
		,      SUM(CASE WHEN B.NEW_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, +1, A.APPROVAL_TIME), 112) THEN 1 ELSE 0 END)  AS D1_CNT
		,      SUM(CASE WHEN B.NEW_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, +2, A.APPROVAL_TIME), 112) THEN 1 ELSE 0 END)  AS D2_CNT

		,      SUM(CASE WHEN B.NEW_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD,  0, A.APPROVAL_TIME), 112) THEN B.NEW_QTY ELSE 0 END)  AS D_QTY
		,      SUM(CASE WHEN B.NEW_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, +1, A.APPROVAL_TIME), 112) THEN B.NEW_QTY ELSE 0 END)  AS D1_QTY
		,      SUM(CASE WHEN B.NEW_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, +2, A.APPROVAL_TIME), 112) THEN B.NEW_QTY ELSE 0 END)  AS D2_QTY

		FROM   SSP_ANL_SHIP_CONFIRM_CHG_REQ A WITH(NOLOCK) 
		,      SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE B WITH(NOLOCK) 
		,      SCM_MST_DIVISION D WITH(NOLOCK)
		WHERE  A.CHANGE_REQ_NO = B.CHANGE_REQ_NO 
		AND    A.CHANGE_REQ_STATUS = 'A'
		AND    B.NEW_YN = 'Y'
		AND    B.NEW_QTY > 0 
		AND    B.NEW_YYYYMMDD  BETWEEN  CONVERT(CHAR(8),A.APPROVAL_TIME, 112)  AND  CONVERT(CHAR(8), DATEADD(DD, +2, A.APPROVAL_TIME), 112)
		AND    CONVERT(CHAR(8),A.APPROVAL_TIME, 112) =  @v_yyyymmdd 
		AND    A.DIVISION_ID = D.DIVISION_ID
	
		GROUP BY CONVERT(CHAR(8),A.APPROVAL_TIME, 112) 
		--,      A.DIVISION_ID 
		,      D.ATTRIBUTE3
		,      B.FROM_SITE 
		,      B.TO_SITE
		,      B.ITEM_ID
		,      A.REQUEST_USER 
		,      A.REQUEST_DEPT
		,      B.CONFIRM_ID
		 ; 
		------------------------------------------------------------------------------------------------------------- 
		-- 2. SSP_KPI_ASA_AUTO_SO_APPLY
		-------------------------------------------------------------------------------------------------------------
		DELETE 
		FROM SSP_KPI_USR_URGENT_SHIP_REQ
		WHERE YYYYMMDD = @v_yyyymmdd 
		; 

		
		 
		INSERT INTO SSP_KPI_USR_URGENT_SHIP_REQ (
				 YYYYMMDD               
				,YYYYMM                 
				,WEEK_NAME              
				,DIVISION_ID            
				,FROM_SITE              
				,TO_SITE                
				,ITEM_ID                
				,CONFIRM_ID             
				,REQUESTOR              
				,REQUESTOR_DEPT         
				,D_CNT                  
				,D1_CNT                 
				,D2_CNT                 
				,D_QTY                  
				,D1_QTY                 
				,D2_QTY                 
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
				,C.BASIS_YYYYMM -- YYYYMM                 
				,C.WEEK_NAME              
				,A.DIVISION_ID            
				,A.FROM_SITE              
				,A.TO_SITE                
				,A.ITEM_ID                
				,A.CONFIRM_ID             
				,A.REQUESTOR              
				,A.REQUESTOR_DEPT         
				,A.D_CNT                  
				,A.D1_CNT                 
				,A.D2_CNT                 
				,A.D_QTY                  
				,A.D1_QTY                 
				,A.D2_QTY        
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
		  FROM #tmp_SSP_KPI_USR_URGENT_SHIP_REQ A WITH (NOLOCK)
		       JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
			     ON C.BASIS_YYYYMMDD = A.YYYYMMDD 
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
     --SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
     --                     REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


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
