





/*
 * Program ID   : [NERP_PR_SSP_XIF_OWMS_STOCK_EE_R]  
 * Description  : OWMS 재고 정보 I/F 수신 반영(Every 1 Hour) 
 * OutTable     : XIF_OWMS_STOCK_R_SN --> SSP_DNM_OWMS_STOCK 
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.05.13   LJH            Initial Release [PJ20199555]공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 
 * 2019.07.21   LJH            ATTRIBUTE1(생산 대 LOT)를 LOT_ID로 반영  
 * 2021.03.03   KBK            데이터 수신 체크 로직 추가                                  
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2024.03.20   KHJ			SAP PO로 변경 / NERP 데이터 변환 로직 추가 / NERP_SSP
 * 2026.03.24	강주용		[E20260326-001508] 중복수신데이터 제외 로직 추가
 */

CREATE PROCEDURE [dbo].[NERP_PR_SSP_XIF_OWMS_STOCK_EE_R]
	@ZNEIFSSP_00254S		AS DBO.ZNEIFSSP_00254S READONLY
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
--    SET ANSI_WARNINGS OFF;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_OWMS_STOCK_EE_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_OWMS_STOCK_EE'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

    DECLARE @TRANSFER_DATE			DATETIME        = GETDATE();    
    DECLARE @TRANSFER_FLAG			NVARCHAR(50)	= 'N';
	DECLARE @XIF_OWMS_STOCK_EE_R		TABLE 
	(
		[IF_SEQ] 				[nvarchar](50) NOT NULL,
		[IF_TYPE] 				[nvarchar](1) NULL,
		[IF_ID] 				[nvarchar](50) NULL,
		[IF_RCV_DATE] 			[datetime] NULL,
		[PROC_FLAG] 			[nvarchar](1) NULL,
		[PROC_DATE] 			[datetime] NULL,
		[PROC_MSG] 				[nvarchar](1000) NULL,
		[ITEM_ID] 				[nvarchar](50) NULL,
		[PALLET_ID] 			[nvarchar](50) NULL,
		[STOCK_QTY] 			[numeric](20, 10) NULL,
		[STOCK_QTY_M] 			[numeric](20, 10) NULL,
		[AVAILABLE_QTY] 		[numeric](20, 10) NULL,
		[NON_QC_QTY] 			[numeric](20, 10) NULL,
		[ALLOCATION_QTY] 		[numeric](20, 10) NULL,
		[BLOCK_QTY] 			[numeric](20, 10) NULL,
		[HOLD_DATE] 			[nvarchar](30) NULL,
		[PACKING_QTY] 			[numeric](20, 10) NULL,
		[MOVING_QTY] 			[numeric](20, 10) NULL,
		[RCVLOC_QTY] 			[numeric](20, 10) NULL,
		[EXPIRATION_QTY] 		[numeric](20, 10) NULL,
		[LONG_QTY] 				[numeric](20, 10) NULL,
		[PROD_GROUP] 			[nvarchar](20) NULL,
		[LOT_ID] 				[nvarchar](50) NULL,
		[PLANT_ID] 				[nvarchar](30) NULL,
		[GRADE] 				[nvarchar](40) NULL,
		[PACKING_STATUS] 		[nvarchar](40) NULL,
		[PACKING_STATUS_ELEC] 	[nvarchar](40) NULL,
		[STOCK_STATUS] 			[nvarchar](40) NULL,
		[STORAGE_ID] 			[nvarchar](30) NULL,
		[CUSTOMER_CODE] 		[nvarchar](50) NULL,
		[CUSTOMER_NAME] 		[nvarchar](180) NULL,
		[LOT_DATE] 				[nvarchar](14) NULL,
		[LANE] 					[nvarchar](30) NULL,
		[EXPIRATION_DATE] 		[datetime] NULL,
		[ELECTRODE_VERSION] 	[nvarchar](30) NULL,
		[SOC] 					[nvarchar](14) NULL,
		[CAPACITY_GRADE] 		[nvarchar](40) NULL,
		[CREATION_DATE] 		[datetime] NULL,
		[ATTRIBUTE1] 			[nvarchar](150) NULL,
		[ATTRIBUTE2] 			[nvarchar](150) NULL,
		[ATTRIBUTE3] 			[nvarchar](150) NULL,
		[ATTRIBUTE4] 			[nvarchar](150) NULL,
		[ATTRIBUTE5] 			[nvarchar](150) NULL,
		[ATTRIBUTE6] 			[nvarchar](150) NULL,
		[ATTRIBUTE7] 			[nvarchar](150) NULL,
		[ATTRIBUTE8] 			[nvarchar](150) NULL,
		[ATTRIBUTE9] 			[nvarchar](150) NULL,
		[ATTRIBUTE10] 			[nvarchar](150) NULL
	);

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_OWMS_STOCK_EE INSERT LOGIC';
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

	--LSP 회신을 위한 변수선언
    DECLARE @E_TYPE					NVARCHAR(50)	= N'S'; --메시지 유형: S 성공, E 오류, P 처리데이터없음
    DECLARE @E_MESSAGE				NVARCHAR(100)	= N'SUCCESS';

	DECLARE @v_count          INT  = 0 ;
	DECLARE @v_cnt            INT  = 0 ;

	IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_STOCK_EE_R') IS NOT NULL
		DROP TABLE #tmp_XIF_OWMS_STOCK_EE_R

	CREATE TABLE #tmp_XIF_OWMS_STOCK_EE_R (
		[IF_SEQ] [nvarchar](50) NOT NULL ,
		[IF_TYPE] [nvarchar](1) NULL,
		[IF_ID] [nvarchar](50) NULL,
		[IF_RCV_DATE] [datetime] NULL,
		[PROC_FLAG] [nvarchar](1) NULL,
		[PROC_DATE] [datetime] NULL,
		[PROC_MSG] [nvarchar](1000) NULL,
		[ITEM_ID] [nvarchar](50) NULL,
		[PALLET_ID] [nvarchar](50) NULL,
		[STOCK_QTY] [numeric](20, 10) NULL,
		[STOCK_QTY_M] [numeric](20, 10) NULL,
		[AVAILABLE_QTY] [numeric](20, 10) NULL,
		[NON_QC_QTY] [numeric](20, 10) NULL,
		[ALLOCATION_QTY] [numeric](20, 10) NULL,
		[BLOCK_QTY] [numeric](20, 10) NULL,
		[HOLD_DATE] [nvarchar](30) NULL,
		[PACKING_QTY] [numeric](20, 10) NULL,
		[MOVING_QTY] [numeric](20, 10) NULL,
		[RCVLOC_QTY] [numeric](20, 10) NULL,
		[EXPIRATION_QTY] [numeric](20, 10) NULL,
		[LONG_QTY] [numeric](20, 10) NULL,
		[PROD_GROUP] [nvarchar](20) NULL,
		[LOT_ID] [nvarchar](50) NULL,
		[PLANT_ID] [nvarchar](30) NULL,
		[GRADE] [nvarchar](40) NULL,
		[PACKING_STATUS] [nvarchar](40) NULL,
		[PACKING_STATUS_ELEC] [nvarchar](40) NULL,
		[STOCK_STATUS] [nvarchar](40) NULL,
		[STORAGE_ID] [nvarchar](30) NULL,
		[CUSTOMER_CODE] [nvarchar](50) NULL,
		[CUSTOMER_NAME] [nvarchar](180) NULL,
		[LOT_DATE] [nvarchar](14) NULL,
		[LANE] [nvarchar](30) NULL,
		[EXPIRATION_DATE] [datetime] NULL,
		[ELECTRODE_VERSION] [nvarchar](30) NULL,
		[SOC] [nvarchar](14) NULL,
		[CAPACITY_GRADE] [nvarchar](40) NULL,
		[CREATION_DATE] [datetime] NULL,
		[ATTRIBUTE1] [nvarchar](150) NULL,
		[ATTRIBUTE2] [nvarchar](150) NULL,
		[ATTRIBUTE3] [nvarchar](150) NULL,
		[ATTRIBUTE4] [nvarchar](150) NULL,
		[ATTRIBUTE5] [nvarchar](150) NULL,
		[ATTRIBUTE6] [nvarchar](150) NULL,
		[ATTRIBUTE7] [nvarchar](150) NULL,
		[ATTRIBUTE8] [nvarchar](150) NULL,
		[ATTRIBUTE9] [nvarchar](150) NULL,
		[ATTRIBUTE10] [nvarchar](150) NULL
	);

	BEGIN
	-- SAP PO DATA ==> XIF_OWMS_STOCK_EE_R_SN으로 INSERT 처리
		INSERT INTO @XIF_OWMS_STOCK_EE_R ( 
			  [IF_SEQ] 				
			, [IF_TYPE] 				
			, [IF_ID] 				
			, [IF_RCV_DATE] 			
			, [PROC_FLAG] 			
			, [PROC_DATE] 			
			, [PROC_MSG] 				
			, [ITEM_ID] 				
			, [PALLET_ID] 			
			, [STOCK_QTY] 			
			, [STOCK_QTY_M] 			
			, [AVAILABLE_QTY] 		
			, [NON_QC_QTY] 			
			, [ALLOCATION_QTY] 		
			, [BLOCK_QTY] 			
			, [HOLD_DATE] 			
			, [PACKING_QTY] 			
			, [MOVING_QTY] 			
			, [RCVLOC_QTY] 			
			, [EXPIRATION_QTY] 		
			, [LONG_QTY] 				
			, [PROD_GROUP] 			
			, [LOT_ID] 				
			, [PLANT_ID] 				
			, [GRADE] 				
			, [PACKING_STATUS] 		
			, [PACKING_STATUS_ELEC] 	
			, [STOCK_STATUS] 			
			, [STORAGE_ID] 			
			, [CUSTOMER_CODE] 		
			, [CUSTOMER_NAME] 		
			, [LOT_DATE] 				
			, [LANE] 					
			, [EXPIRATION_DATE] 		
			, [ELECTRODE_VERSION] 	
			, [SOC] 					
			, [CAPACITY_GRADE] 		
			, [CREATION_DATE] 		
			, [ATTRIBUTE1] 			
			, [ATTRIBUTE2] 			
			, [ATTRIBUTE3] 			
			, [ATTRIBUTE4] 			
			, [ATTRIBUTE5] 			
			, [ATTRIBUTE6] 			
			, [ATTRIBUTE7] 			
			, [ATTRIBUTE8] 			
			, [ATTRIBUTE9] 			
			, [ATTRIBUTE10] 		
			)
		SELECT  
		-- XIF_OWMS_STOCK_EE_R_SN 형식에 맞추어 수신됨
			  [IF_SEQ] 				
			, [IF_TYPE] 				
			, [IF_ID] 				
			, @TRANSFER_DATE		AS IF_RCV_DATE 			
			, @TRANSFER_FLAG		AS PROC_FLAG 			
			, @TRANSFER_DATE		AS PROC_DATE 			
			, NULL					AS PROC_MSG 				
			, [ITEM_ID] 				
			, ISNULL (PALLET_ID, '')		AS PALLET_ID 		
			, [STOCK_QTY] 			
			, [STOCK_QTY_M] 			
			, [AVAILABLE_QTY] 		
			, [NON_QC_QTY] 			
			, [ALLOCATION_QTY] 		
			, [BLOCK_QTY] 			
			, [HOLD_DATE] 			
			, [PACKING_QTY] 			
			, [MOVING_QTY] 			
			, [RCVLOC_QTY] 			
			, [EXPIRATION_QTY] 		
			, [LONG_QTY] 				
			, [PROD_GROUP] 			
			, ISNULL (LOT_ID, '')	AS LOT_ID 		
			, [PLANT_ID] 				
			, [GRADE] 				
			, [PACKING_STATUS] 		
			, [PACKING_STATUS_ELEC] 	
			, [STOCK_STATUS] 			
			, [STORAGE_ID] 			
			, [CUSTOMER_CODE] 		
			, [CUSTOMER_NAME] 		
			, [LOT_DATE] 				
			, [LANE] 					
			, [EXPIRATION_DATE] 		
			, [ELECTRODE_VERSION] 	
			, [SOC] 					
			, [CAPACITY_GRADE] 		
			, @TRANSFER_DATE		AS CREATION_DATE 		
			, [ATTRIBUTE1] 			
			, [ATTRIBUTE2] 			
			, [ATTRIBUTE3] 			
			, [ATTRIBUTE4] 			
			, [ATTRIBUTE5] 			
			, [ATTRIBUTE6] 			
			, [ATTRIBUTE7] 			
			, [ATTRIBUTE8] 			
			, [ATTRIBUTE9] 			
			, [ATTRIBUTE10] 
		FROM @ZNEIFSSP_00254S 
		-- START [E20260326-001508] 중복수신데이터 제외 로직 추가
		WHERE IF_SEQ NOT IN ( SELECT IF_SEQ
								FROM XIF_OWMS_STOCK_EE_R_SN WITH(NOLOCK)
							)
		-- END [E20260326-001508] 중복수신데이터 제외 로직 추가
		;		

		INSERT INTO XIF_OWMS_STOCK_EE_R_SN (
			  [IF_SEQ] 				
			, [IF_TYPE] 				
			, [IF_ID] 				
			, [IF_RCV_DATE] 			
			, [PROC_FLAG] 			
			, [PROC_DATE] 			
			, [PROC_MSG] 				
			, [ITEM_ID] 				
			, [PALLET_ID] 			
			, [STOCK_QTY] 			
			, [STOCK_QTY_M] 			
			, [AVAILABLE_QTY] 		
			, [NON_QC_QTY] 			
			, [ALLOCATION_QTY] 		
			, [BLOCK_QTY] 			
			, [HOLD_DATE] 			
			, [PACKING_QTY] 			
			, [MOVING_QTY] 			
			, [RCVLOC_QTY] 			
			, [EXPIRATION_QTY] 		
			, [LONG_QTY] 				
			, [PROD_GROUP] 			
			, [LOT_ID] 				
			, [PLANT_ID] 				
			, [GRADE] 				
			, [PACKING_STATUS] 		
			, [PACKING_STATUS_ELEC] 	
			, [STOCK_STATUS] 			
			, [STORAGE_ID] 			
			, [CUSTOMER_CODE] 		
			, [CUSTOMER_NAME] 		
			, [LOT_DATE] 				
			, [LANE] 					
			, [EXPIRATION_DATE] 		
			, [ELECTRODE_VERSION] 	
			, [SOC] 					
			, [CAPACITY_GRADE] 		
			, [CREATION_DATE] 		
			, [ATTRIBUTE1] 			
			, [ATTRIBUTE2] 			
			, [ATTRIBUTE3] 			
			, [ATTRIBUTE4] 			
			, [ATTRIBUTE5] 			
			, [ATTRIBUTE6] 			
			, [ATTRIBUTE7] 			
			, [ATTRIBUTE8] 			
			, [ATTRIBUTE9] 			
			, [ATTRIBUTE10] 
		)
		SELECT  [IF_SEQ] 				
			, [IF_TYPE] 				
			, [IF_ID] 				
			, [IF_RCV_DATE] 			
			, [PROC_FLAG] 			
			, [PROC_DATE] 			
			, [PROC_MSG] 				
			, [ITEM_ID] 				
			, [PALLET_ID] 			
			, [STOCK_QTY] 			
			, [STOCK_QTY_M] 			
			, [AVAILABLE_QTY] 		
			, [NON_QC_QTY] 			
			, [ALLOCATION_QTY] 		
			, [BLOCK_QTY] 			
			, [HOLD_DATE] 			
			, [PACKING_QTY] 			
			, [MOVING_QTY] 			
			, [RCVLOC_QTY] 			
			, [EXPIRATION_QTY] 		
			, [LONG_QTY] 				
			, [PROD_GROUP] 			
			, [LOT_ID] 				
			, [PLANT_ID] 				
			, [GRADE] 				
			, [PACKING_STATUS] 		
			, [PACKING_STATUS_ELEC] 	
			, [STOCK_STATUS] 			
			, [STORAGE_ID] 			
			, [CUSTOMER_CODE] 		
			, [CUSTOMER_NAME] 		
			, [LOT_DATE] 				
			, [LANE] 					
			, [EXPIRATION_DATE] 		
			, [ELECTRODE_VERSION] 	
			, [SOC] 					
			, [CAPACITY_GRADE] 		
			, [CREATION_DATE] 		
			, [ATTRIBUTE1] 			
			, [ATTRIBUTE2] 			
			, [ATTRIBUTE3] 			
			, [ATTRIBUTE4] 			
			, [ATTRIBUTE5] 			
			, [ATTRIBUTE6] 			
			, [ATTRIBUTE7] 			
			, [ATTRIBUTE8] 			
			, [ATTRIBUTE9] 			
			, [ATTRIBUTE10] 
		FROM @XIF_OWMS_STOCK_EE_R ;	

	END


    BEGIN TRY
    BEGIN
        BEGIN TRAN TX_SH

      
		DECLARE @stock_cnt INTEGER, 
			    @company_id VARCHAR(30),  
				@group_seq VARCHAR(30)

		DECLARE @idx INT     SET     @idx = 0  
/* INF-R 적용 이전
		-- COMPANY 별 I/F 건수와 전송 대상 건수 체크 : 2021.02,04
		DECLARE CUR_OWMS_STOCK CURSOR FOR  
		 SELECT SUM(A.CHECK_CNT) AS STOCK_CNT
		      , A.COMPANY_ID
		      , A.GROUP_SEQ
		   FROM (
				SELECT CASE WHEN B.IF_CNT = 0 THEN 0
							WHEN B.IF_CNT IS NULL THEN 1
					   ELSE 
							CASE WHEN A.IF_CNT <> B.IF_CNT THEN 1
							ELSE 0 END 
					   END											AS CHECK_CNT
					 , A.COMPANY_ID
					 , A.COMPANY_ID + SUBSTRING(A.GROUP_SEQ, 1, 8)  AS GROUP_SEQ
				  FROM (
					   SELECT A.ATTRIBUTE5 AS COMPANY_ID
							, CONVERT(CHAR(8), GETDATE(), 112)		AS GROUP_SEQ
							, COUNT(*)								AS IF_CNT
						 FROM XIF_OWMS_STOCK_EE_R_SN A WITH(NOLOCK)
						WHERE 1 = 1
						  AND ISNULL(A.PROC_FLAG,'N') = 'N'
						  AND A.IF_SEQ LIKE '%' + CONVERT(CHAR(6), GETDATE(), 12) + '%'
						  AND CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
						GROUP BY A.ATTRIBUTE5
					   ) A
						 LEFT OUTER JOIN (
						                 SELECT A.COMPANY_ID, A.GROUP_SEQ, SUM(IF_CNT)	AS IF_CNT
						                   FROM (
								                SELECT A.ATTRIBUTE5 AS COMPANY_ID
								                	 , CONVERT(CHAR(8), GETDATE(), 112) AS GROUP_SEQ
								                	 , CONVERT(INT, A.ATTRIBUTE6)		AS IF_CNT
								                 FROM XIF_OWMS_STOCK_EE_R_SN  A WITH(NOLOCK)
								                 WHERE 1 = 1
								                   AND ISNULL(A.PROC_FLAG,'N') = 'N'
								                   AND A.IF_SEQ LIKE '%' + CONVERT(CHAR(6), GETDATE(), 12) + '%'
								                   AND CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
								                 GROUP BY A.ATTRIBUTE5, A.ATTRIBUTE6
								                ) A
						                    WHERE 1 = 1
						                    GROUP BY 
											      A.COMPANY_ID
							                    , A.GROUP_SEQ
						                 ) B
					ON A.COMPANY_ID = B.COMPANY_ID
				   AND A.GROUP_SEQ  = B.GROUP_SEQ
				 WHERE 1 = 1
			    ) A
		  WHERE 1 = 1
		  GROUP BY 
		        A.COMPANY_ID
			  , A.GROUP_SEQ
		;
 */

/* INF-R 적용 이후 */
		-- COMPANY 별 I/F 건수와 전송 대상 건수 체크 : 2021.02,04
		DECLARE CUR_OWMS_STOCK CURSOR FOR  
		 SELECT SUM(A.CHECK_CNT) AS STOCK_CNT
		      , A.COMPANY_ID
		      , A.GROUP_SEQ
		   FROM (
				SELECT CASE WHEN B.IF_CNT = 0 THEN 0
							WHEN B.IF_CNT IS NULL THEN 1
					   ELSE 
							CASE WHEN A.IF_CNT <> B.IF_CNT THEN 1
							ELSE 0 END 
					   END											AS CHECK_CNT
					 , A.COMPANY_ID
					 , A.COMPANY_ID + SUBSTRING(A.GROUP_SEQ, 1, 8)  AS GROUP_SEQ
				  FROM (
					   SELECT ISNULL(X1.NEW_VALUE1, A.ATTRIBUTE5) AS COMPANY_ID
							, CONVERT(CHAR(8), GETDATE(), 112)		AS GROUP_SEQ
							, COUNT(*)								AS IF_CNT
						FROM XIF_OWMS_STOCK_EE_R_SN A WITH(NOLOCK)
						LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
						ON  X1.CODETYPE = 'COMPANY_ID'
						AND A.ATTRIBUTE5 = X1.OLD_VALUE1
						AND X1.ATTRIBUTE5 in ('1ST','2ND')
						WHERE 1 = 1
						  AND A.PROC_FLAG = 'N'
						  AND A.IF_SEQ LIKE '%' + CONVERT(CHAR(6), GETDATE(), 12) + '%'
						  AND CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
						GROUP BY A.ATTRIBUTE5, X1.NEW_VALUE1
					   ) A
						 LEFT OUTER JOIN (
						                 SELECT A.COMPANY_ID, A.GROUP_SEQ, SUM(IF_CNT)	AS IF_CNT
						                   FROM (
								                SELECT ISNULL(X1.NEW_VALUE1, A.ATTRIBUTE5) AS COMPANY_ID
								                	 , CONVERT(CHAR(8), GETDATE(), 112) AS GROUP_SEQ
								                	 , CONVERT(INT, A.ATTRIBUTE6)		AS IF_CNT
								                 FROM XIF_OWMS_STOCK_EE_R_SN  A WITH(NOLOCK)
													LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
													ON  X1.CODETYPE = 'COMPANY_ID'
													AND A.ATTRIBUTE5 = X1.OLD_VALUE1
													AND X1.ATTRIBUTE5 in ('1ST','2ND')
								                 WHERE 1 = 1
								                   AND A.PROC_FLAG = 'N'
								                   AND A.IF_SEQ LIKE '%' + CONVERT(CHAR(6), GETDATE(), 12) + '%'
								                   AND CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
								                 GROUP BY A.ATTRIBUTE5, A.ATTRIBUTE6, X1.NEW_VALUE1
								                ) A
						                    WHERE 1 = 1
						                    GROUP BY 
											      A.COMPANY_ID
							                    , A.GROUP_SEQ
						                 ) B
					ON A.COMPANY_ID = B.COMPANY_ID
				   AND A.GROUP_SEQ  = B.GROUP_SEQ
				 WHERE 1 = 1
			    ) A
		  WHERE 1 = 1
		  GROUP BY 
		        A.COMPANY_ID
			  , A.GROUP_SEQ
		;

		OPEN CUR_OWMS_STOCK; 

		FETCH NEXT FROM CUR_OWMS_STOCK INTO @stock_cnt, 
			                                @company_id,
										    @group_seq

		WHILE(@@FETCH_STATUS = 0) 
		BEGIN

			-- COMPANY별 수행여부 체크
			SELECT @v_count = COUNT(*)
			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			 WHERE 1 = 1
			   AND A.LOOKUP_TYPE	= 'IF_STOCK_CHECK'
			   AND A.SEGMENT1		= 'PLAN_EE'
			   AND A.SEGMENT2		= 'OWMS'
			   AND A.SEGMENT3		= 'EE'
			   AND A.SEGMENT4		= @company_id
			   AND A.SEGMENT5		= CONVERT(CHAR(8), GETDATE(), 112)
			   AND A.ATTRIBUTE1		= 'Y'
			   ;

			IF @stock_cnt = 0 AND @v_count = 0
			BEGIN

				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				   SET SEGMENT5		= CONVERT(CHAR(8), GETDATE(), 112)
					 , ATTRIBUTE1	= 'N'
				 WHERE 1 = 1
				   AND LOOKUP_TYPE	= 'IF_STOCK_CHECK'
				   AND SEGMENT1		= 'PLAN_EE'
				   AND SEGMENT2		= 'OWMS'
				   AND SEGMENT3		= 'EE'
				   AND SEGMENT4		= @company_id
				   ;

				DELETE FROM #tmp_XIF_OWMS_STOCK_EE_R

/* INF-R 적용 이전 
				INSERT INTO #tmp_XIF_OWMS_STOCK_EE_R
						   ([IF_SEQ]
						   ,[IF_TYPE]
						   ,[IF_ID]
						   ,[IF_RCV_DATE]
						   ,[PROC_FLAG]
						   ,[PROC_DATE]
						   ,[PROC_MSG]
						   ,[ITEM_ID]
						   ,[PALLET_ID]
						   ,[STOCK_QTY]
						   ,[STOCK_QTY_M]
						   ,[AVAILABLE_QTY]
						   ,[NON_QC_QTY]
						   ,[ALLOCATION_QTY]
						   ,[BLOCK_QTY]
						   ,[HOLD_DATE]
						   ,[PACKING_QTY]
						   ,[MOVING_QTY]
						   ,[RCVLOC_QTY]
						   ,[EXPIRATION_QTY]
						   ,[LONG_QTY]
						   ,[PROD_GROUP]
						   ,[LOT_ID]
						   ,[PLANT_ID]
						   ,[GRADE]
						   ,[PACKING_STATUS]
						   ,[PACKING_STATUS_ELEC]
						   ,[STOCK_STATUS]
						   ,[STORAGE_ID]
						   ,[CUSTOMER_CODE]
						   ,[CUSTOMER_NAME]
						   ,[LOT_DATE]
						   ,[LANE]
						   ,[EXPIRATION_DATE]
						   ,[ELECTRODE_VERSION]
						   ,[SOC]
						   ,[CAPACITY_GRADE]
						   ,[CREATION_DATE]
						   ,[ATTRIBUTE1]
						   ,[ATTRIBUTE2]
						   ,[ATTRIBUTE3]
						   ,[ATTRIBUTE4]
						   ,[ATTRIBUTE5]
						   ,[ATTRIBUTE6]
						   ,[ATTRIBUTE7]
						   ,[ATTRIBUTE8]
						   ,[ATTRIBUTE9]
						   ,[ATTRIBUTE10])
					 SELECT [IF_SEQ]
						   ,[IF_TYPE]
						   ,[IF_ID]
						   ,[IF_RCV_DATE]
						   ,[PROC_FLAG]
						   ,[PROC_DATE]
						   ,[PROC_MSG]
						   ,[ITEM_ID]
						   ,[PALLET_ID]
						   ,[STOCK_QTY]
						   ,[STOCK_QTY_M]
						   ,[AVAILABLE_QTY]
						   ,[NON_QC_QTY]
						   ,[ALLOCATION_QTY]
						   ,[BLOCK_QTY]
						   ,[HOLD_DATE]
						   ,[PACKING_QTY]
						   ,[MOVING_QTY]
						   ,[RCVLOC_QTY]
						   ,[EXPIRATION_QTY]
						   ,[LONG_QTY]
						   ,[dbo].[FN_GET_SSP_JV_DIVISION_ID](PROD_GROUP, PLANT_ID) AS PROD_GROUP
						   ,[LOT_ID]
						   ,[PLANT_ID]
						   ,[GRADE]
						   ,[PACKING_STATUS]
						   ,[PACKING_STATUS_ELEC]
						   ,[STOCK_STATUS]
						   ,[STORAGE_ID]
						   ,[CUSTOMER_CODE]
						   ,[CUSTOMER_NAME]
						   ,[LOT_DATE]
						   ,[LANE]
						   ,[EXPIRATION_DATE]
						   ,[ELECTRODE_VERSION]
						   ,[SOC]
						   ,[CAPACITY_GRADE]
						   ,[CREATION_DATE]
						   ,[ATTRIBUTE1]
						   ,[ATTRIBUTE2]
						   ,[ATTRIBUTE3]
						   ,[ATTRIBUTE4]
						   ,[ATTRIBUTE5]
						   ,[ATTRIBUTE6]
						   ,[ATTRIBUTE7]
						   ,[ATTRIBUTE8]
						   ,[ATTRIBUTE9]
						   ,[ATTRIBUTE10]
					   FROM [dbo].[XIF_OWMS_STOCK_EE_R_SN] A WITH(NOLOCK)
				      WHERE ISNULL(A.PROC_FLAG,'N')	= 'N' 
				        AND A.ATTRIBUTE5				= @company_id
						--AND ATTRIBUTE6 <> '0'
				      ORDER BY 
					        A.IF_SEQ

*/


/* INF-R 적용 이후 */
				INSERT INTO #tmp_XIF_OWMS_STOCK_EE_R
						   ([IF_SEQ]
						   ,[IF_TYPE]
						   ,[IF_ID]
						   ,[IF_RCV_DATE]
						   ,[PROC_FLAG]
						   ,[PROC_DATE]
						   ,[PROC_MSG]
						   ,[ITEM_ID]
						   ,[PALLET_ID]
						   ,[STOCK_QTY]
						   ,[STOCK_QTY_M]
						   ,[AVAILABLE_QTY]
						   ,[NON_QC_QTY]
						   ,[ALLOCATION_QTY]
						   ,[BLOCK_QTY]
						   ,[HOLD_DATE]
						   ,[PACKING_QTY]
						   ,[MOVING_QTY]
						   ,[RCVLOC_QTY]
						   ,[EXPIRATION_QTY]
						   ,[LONG_QTY]
						   ,[PROD_GROUP]
						   ,[LOT_ID]
						   ,[PLANT_ID]
						   ,[GRADE]
						   ,[PACKING_STATUS]
						   ,[PACKING_STATUS_ELEC]
						   ,[STOCK_STATUS]
						   ,[STORAGE_ID]
						   ,[CUSTOMER_CODE]
						   ,[CUSTOMER_NAME]
						   ,[LOT_DATE]
						   ,[LANE]
						   ,[EXPIRATION_DATE]
						   ,[ELECTRODE_VERSION]
						   ,[SOC]
						   ,[CAPACITY_GRADE]
						   ,[CREATION_DATE]
						   ,[ATTRIBUTE1]
						   ,[ATTRIBUTE2]
						   ,[ATTRIBUTE3]
						   ,[ATTRIBUTE4]
						   ,[ATTRIBUTE5]
						   ,[ATTRIBUTE6]
						   ,[ATTRIBUTE7]
						   ,[ATTRIBUTE8]
						   ,[ATTRIBUTE9]
						   ,[ATTRIBUTE10])
					 SELECT [IF_SEQ]
						   ,[IF_TYPE]
						   ,[IF_ID]
						   ,[IF_RCV_DATE]
						   ,[PROC_FLAG]
						   ,[PROC_DATE]
						   ,[PROC_MSG]
						   ,[ITEM_ID]
						   ,[PALLET_ID]
						   ,[STOCK_QTY]
						   ,[STOCK_QTY_M]
						   ,[AVAILABLE_QTY]
						   ,[NON_QC_QTY]
						   ,[ALLOCATION_QTY]
						   ,[BLOCK_QTY]
						   ,[HOLD_DATE]
						   ,[PACKING_QTY]
						   ,[MOVING_QTY]
						   ,[RCVLOC_QTY]
						   ,[EXPIRATION_QTY]
						   ,[LONG_QTY]
						   ,[dbo].[FN_GET_SSP_JV_DIVISION_ID](PROD_GROUP, PLANT_ID) AS PROD_GROUP
						   ,[LOT_ID]
						   ,ISNULL(X1.NEW_VALUE1, A.PLANT_ID) AS PLANT_ID
						   ,[GRADE]
						   ,[PACKING_STATUS]
						   ,[PACKING_STATUS_ELEC]
						   ,[STOCK_STATUS]
						   ,ISNULL(X1.NEW_VALUE2, A.STORAGE_ID) AS STORAGE_ID
						   ,[CUSTOMER_CODE]
						   ,[CUSTOMER_NAME]
						   ,[LOT_DATE]
						   ,[LANE]
						   ,[EXPIRATION_DATE]
						   ,[ELECTRODE_VERSION]
						   ,[SOC]
						   ,ISNULL(X2.NEW_VALUE1, A.CAPACITY_GRADE) AS CAPACITY_GRADE
						   ,[CREATION_DATE]
						   ,A.[ATTRIBUTE1]
						   ,A.[ATTRIBUTE2]
						   ,A.[ATTRIBUTE3]
						   ,A.[ATTRIBUTE4]
						   ,ISNULL(X3.NEW_VALUE1, A.ATTRIBUTE5) AS ATTRIBUTE5
						   ,A.[ATTRIBUTE6]
						   ,A.[ATTRIBUTE7]
						   ,A.[ATTRIBUTE8]
						   ,A.[ATTRIBUTE9]
						   ,A.[ATTRIBUTE10]
					   FROM [dbo].[XIF_OWMS_STOCK_EE_R_SN] A WITH(NOLOCK)
						LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
						ON  X1.CODETYPE = 'STORAGE_ID'
						AND A.PLANT_ID = X1.OLD_VALUE1 
						AND A.STORAGE_ID = X1.OLD_VALUE2 
						AND X1.ATTRIBUTE5 in ('1ST','2ND')
						LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
						ON  X2.CODETYPE = 'PLANT_ID'
						AND A.CAPACITY_GRADE = X2.OLD_VALUE1 
						AND X2.ATTRIBUTE5 in ('1ST','2ND')
						LEFT OUTER JOIN  NERP_CONV_MASTER X3 WITH(NOLOCK)
						ON  X3.CODETYPE = 'COMPANY_ID'
						AND A.ATTRIBUTE5 = X3.OLD_VALUE1 
						AND X3.ATTRIBUTE5 in ('1ST','2ND')
				      WHERE A.PROC_FLAG   	= 'N' 
				        AND A.ATTRIBUTE5				= @company_id
						--AND ATTRIBUTE6 <> '0'
				      ORDER BY 
					        A.IF_SEQ


				MERGE INTO SSP_DNM_OWMS_STOCK_EE AS M
				USING (
					  SELECT S.DIVISION_ID					AS DIVISION_ID        
					        ,S.COMPANY_ID					AS COMPANY_ID         
					        ,S.SCM_SITE_ID					AS FROM_SITE          
					        ,CONVERT(CHAR(8), CONVERT(DATETIME, X.ATTRIBUTE8) + 1, 112)           AS YYYYMMDD           
					        ,X.ITEM_ID						AS ITEM_ID            
					        ,X.PALLET_ID					AS PALLET_ID          
					        ,SUM(X.STOCK_QTY)				AS STOCK_QTY           -- STOCK_QTY 는 PALLET_ID기준의 수량임      
					        ,SUM(X.STOCK_QTY_M)				AS STOCK_QTY_M        
					        ,SUM(X.AVAILABLE_QTY)			AS AVAILABLE_QTY      
					        ,SUM(X.NON_QC_QTY)				AS NON_QC_QTY         
					        ,SUM(X.ALLOCATION_QTY)			AS ALLOCATION_QTY     
					        ,SUM(X.BLOCK_QTY)				AS BLOCK_QTY          
					        ,MAX(X.HOLD_DATE)				AS HOLD_DATE          
					        ,SUM(X.PACKING_QTY)				AS PACKING_QTY        
					        ,SUM(X.MOVING_QTY)				AS MOVING_QTY         
					        ,SUM(X.RCVLOC_QTY)				AS RCVLOC_QTY         
					        ,SUM(X.EXPIRATION_QTY)			AS EXPIRATION_QTY     
					        ,SUM(X.LONG_QTY)				AS LONG_QTY           
					        ,MAX(X.PROD_GROUP)				AS PROD_GROUP  
			--			,ISNULL(X.LOT_ID,'')      AS LOT_ID         --ATTRIBUTE1(생산 대 LOT)를 LOT_ID로 반영 
					        ,ISNULL(X.ATTRIBUTE1,'')		AS LOT_ID 			           
					        ,MAX(X.PLANT_ID)				AS PLANT_ID           
					        ,MAX(X.GRADE)					AS GRADE              
					        ,MAX(X.PACKING_STATUS)			AS PACKING_STATUS     
					        ,MAX(X.PACKING_STATUS_ELEC)		AS PACKING_STATUS_ELEC
					        ,MAX(X.STOCK_STATUS)			AS STOCK_STATUS       
					        ,MAX(X.STORAGE_ID)				AS STORAGE_ID         
					        ,MAX(X.CUSTOMER_CODE)			AS CUSTOMER_CODE      
					        ,MAX(X.CUSTOMER_NAME)			AS CUSTOMER_NAME      
					        ,MAX(X.LOT_DATE)				AS LOT_DATE           
					        ,MAX(X.LANE)					AS LANE               
					        ,MAX(X.EXPIRATION_DATE)			AS EXPIRATION_DATE    
					        ,MAX(X.ELECTRODE_VERSION)		AS ELECTRODE_VERSION  
					        ,MAX(X.SOC)						AS SOC                
					        ,MAX(X.CAPACITY_GRADE)			AS CAPACITY_GRADE     
					        ,MAX(X.IF_ID)					AS CREATED_BY         
					        ,MAX(X.CREATION_DATE)			AS CREATION_DATE      
					        ,MAX(X.IF_ID)					AS LAST_UPDATED_BY    
					        ,GETDATE()						AS LAST_UPDATE_DATE   
					        ,MAX(X.ATTRIBUTE1)				AS ATTRIBUTE1   -- 생산 대 LOT (9자리)       
					        ,MAX(X.ATTRIBUTE2)				AS ATTRIBUTE2         
					        ,MAX(X.ATTRIBUTE3)				AS ATTRIBUTE3         
					        ,MAX(X.ATTRIBUTE4)				AS ATTRIBUTE4         
					        ,MAX(X.ATTRIBUTE5)				AS ATTRIBUTE5         
					        ,MAX(X.ATTRIBUTE6)				AS ATTRIBUTE6         
					        ,MAX(X.ATTRIBUTE7)				AS ATTRIBUTE7         
					        ,MAX(X.ATTRIBUTE8)				AS ATTRIBUTE8         
					        ,MAX(X.ATTRIBUTE9)				AS ATTRIBUTE9         
					        ,MAX(X.ATTRIBUTE10)				AS ATTRIBUTE10		
					    FROM #tmp_XIF_OWMS_STOCK_EE_R	AS X WITH(NOLOCK) 
						     JOIN SCM_ADM_LOOKUP_MASTER_DETAIL	AS L WITH(NOLOCK) 
						  ON L.LOOKUP_TYPE	= 'ELECTRODE_OWMS_PLANT_MAPPING' 
						 AND L.SEGMENT1		= X.PROD_GROUP   -- OWMS DIVISION 
						 AND L.SEGMENT2		= X.PLANT_ID     -- OWMS PLANT_ID 
						     JOIN SCM_MST_SITE S WITH(NOLOCK) 
						  ON S.SITE_TYPE	= 'PLANT'
						 AND S.SCM_SITE_ID	= L.SEGMENT3     --전극 SCM_SITE_ID  
     				   WHERE 1 = 1
					     AND X.ATTRIBUTE6	<> '0'
					   GROUP BY
					         S.DIVISION_ID
							,S.COMPANY_ID
							,S.SCM_SITE_ID
							,X.ATTRIBUTE8
							,X.ITEM_ID
							,X.PALLET_ID
							,ISNULL(X.ATTRIBUTE1,'')
					  ) F
				   ON F.DIVISION_ID		= M.DIVISION_ID       
				  AND F.COMPANY_ID		= M.COMPANY_ID       
				  AND F.FROM_SITE		= M.FROM_SITE      
				  AND F.YYYYMMDD		= M.YYYYMMDD         
				  AND F.ITEM_ID			= M.ITEM_ID    
				  AND F.PALLET_ID		= M.PALLET_ID     
				  AND F.LOT_ID			= M.LOT_ID 

				WHEN MATCHED THEN
				UPDATE
				   SET M.STOCK_QTY            = F.STOCK_QTY           
					  ,M.STOCK_QTY_M          = F.STOCK_QTY_M         
					  ,M.AVAILABLE_QTY        = F.AVAILABLE_QTY       
					  ,M.NON_QC_QTY           = F.NON_QC_QTY          
					  ,M.ALLOCATION_QTY       = F.ALLOCATION_QTY      
					  ,M.BLOCK_QTY            = F.BLOCK_QTY           
					  ,M.HOLD_DATE            = F.HOLD_DATE           
					  ,M.PACKING_QTY          = F.PACKING_QTY         
					  ,M.MOVING_QTY           = F.MOVING_QTY          
					  ,M.RCVLOC_QTY           = F.RCVLOC_QTY          
					  ,M.EXPIRATION_QTY       = F.EXPIRATION_QTY      
					  ,M.LONG_QTY             = F.LONG_QTY            
					  ,M.PROD_GROUP           = F.PROD_GROUP          
					  ,M.LOT_ID               = F.LOT_ID              
					  ,M.PLANT_ID             = F.PLANT_ID            
					  ,M.GRADE                = F.GRADE               
					  ,M.PACKING_STATUS       = F.PACKING_STATUS      
					  ,M.PACKING_STATUS_ELEC  = F.PACKING_STATUS_ELEC 
					  ,M.STOCK_STATUS         = F.STOCK_STATUS        
					  ,M.STORAGE_ID           = F.STORAGE_ID          
					  ,M.CUSTOMER_CODE        = F.CUSTOMER_CODE       
					  ,M.CUSTOMER_NAME        = F.CUSTOMER_NAME       
					  ,M.LOT_DATE             = F.LOT_DATE            
					  ,M.LANE                 = F.LANE                
					  ,M.EXPIRATION_DATE      = F.EXPIRATION_DATE     
					  ,M.ELECTRODE_VERSION    = F.ELECTRODE_VERSION   
					  ,M.SOC                  = F.SOC                 
					  ,M.CAPACITY_GRADE       = F.CAPACITY_GRADE      
					  ,M.CREATED_BY           = F.CREATED_BY          
					  ,M.CREATION_DATE        = F.CREATION_DATE       
					  ,M.LAST_UPDATED_BY      = F.LAST_UPDATED_BY     
					  ,M.LAST_UPDATE_DATE     = F.LAST_UPDATE_DATE    
					  ,M.ATTRIBUTE1           = F.ATTRIBUTE1          
					  ,M.ATTRIBUTE2           = F.ATTRIBUTE2          
					  ,M.ATTRIBUTE3           = F.ATTRIBUTE3          
					  ,M.ATTRIBUTE4           = F.ATTRIBUTE4          
					  ,M.ATTRIBUTE5           = F.ATTRIBUTE5          
					  ,M.ATTRIBUTE6           = F.ATTRIBUTE6          
					  ,M.ATTRIBUTE7           = F.ATTRIBUTE7          
					  ,M.ATTRIBUTE8           = F.ATTRIBUTE8          
					  ,M.ATTRIBUTE9           = F.ATTRIBUTE9          
					  ,M.ATTRIBUTE10          = F.ATTRIBUTE10        			
				WHEN NOT MATCHED THEN 
				INSERT (
					   DIVISION_ID
					  ,COMPANY_ID
					  ,FROM_SITE
					  ,YYYYMMDD
					  ,ITEM_ID
					  ,PALLET_ID
					  ,STOCK_QTY
					  ,STOCK_QTY_M
					  ,AVAILABLE_QTY
					  ,NON_QC_QTY
					  ,ALLOCATION_QTY
					  ,BLOCK_QTY
					  ,HOLD_DATE
					  ,PACKING_QTY
					  ,MOVING_QTY
					  ,RCVLOC_QTY
					  ,EXPIRATION_QTY
					  ,LONG_QTY
					  ,PROD_GROUP
					  ,LOT_ID
					  ,PLANT_ID
					  ,GRADE
					  ,PACKING_STATUS
					  ,PACKING_STATUS_ELEC
					  ,STOCK_STATUS
					  ,STORAGE_ID
					  ,CUSTOMER_CODE
					  ,CUSTOMER_NAME
					  ,LOT_DATE
					  ,LANE
					  ,EXPIRATION_DATE
					  ,ELECTRODE_VERSION
					  ,SOC
					  ,CAPACITY_GRADE
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
				VALUES (
					   F.DIVISION_ID
					  ,F.COMPANY_ID
					  ,F.FROM_SITE
					  ,F.YYYYMMDD
					  ,F.ITEM_ID
					  ,F.PALLET_ID
					  ,F.STOCK_QTY
					  ,F.STOCK_QTY_M
					  ,F.AVAILABLE_QTY
					  ,F.NON_QC_QTY
					  ,F.ALLOCATION_QTY
					  ,F.BLOCK_QTY
					  ,F.HOLD_DATE
					  ,F.PACKING_QTY
					  ,F.MOVING_QTY
					  ,F.RCVLOC_QTY
					  ,F.EXPIRATION_QTY
					  ,F.LONG_QTY
					  ,F.PROD_GROUP
					  ,F.LOT_ID
					  ,F.PLANT_ID
					  ,F.GRADE
					  ,F.PACKING_STATUS
					  ,F.PACKING_STATUS_ELEC
					  ,F.STOCK_STATUS
					  ,F.STORAGE_ID
					  ,F.CUSTOMER_CODE
					  ,F.CUSTOMER_NAME
					  ,F.LOT_DATE
					  ,F.LANE
					  ,F.EXPIRATION_DATE
					  ,F.ELECTRODE_VERSION
					  ,F.SOC
					  ,F.CAPACITY_GRADE
					  ,F.CREATED_BY
					  ,F.CREATION_DATE
					  ,F.LAST_UPDATED_BY
					  ,F.LAST_UPDATE_DATE
					  ,F.ATTRIBUTE1
					  ,F.ATTRIBUTE2
					  ,F.ATTRIBUTE3
					  ,F.ATTRIBUTE4
					  ,F.ATTRIBUTE5
					  ,F.ATTRIBUTE6
					  ,F.ATTRIBUTE7
					  ,F.ATTRIBUTE8
					  ,F.ATTRIBUTE9
					  ,F.ATTRIBUTE10
				      )
				;

				UPDATE S
				   SET S.PROC_FLAG             = 'Y'
					 , S.PROC_DATE             = GETDATE()   
					 , S.PROC_MSG              = 'S'
				  FROM XIF_OWMS_STOCK_EE_R_SN	AS S WITH(NOLOCK)
					   JOIN #tmp_XIF_OWMS_STOCK_EE_R	AS T
					ON S.IF_SEQ = T.IF_SEQ
				;  

				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				   SET SEGMENT5				= CONVERT(CHAR(8), GETDATE(), 112)
					 , ATTRIBUTE1			= 'Y'
					 , LAST_UPDATED_BY		= @v_batch_user
					 , LAST_UPDATE_DATE		= GETDATE()
				 WHERE 1 = 1
				   AND LOOKUP_TYPE			= 'IF_STOCK_CHECK'
				   AND SEGMENT1				= 'PLAN_EE'
				   AND SEGMENT2				= 'OWMS'
				   AND SEGMENT3				= 'EE'
				   AND SEGMENT4				= @company_id
				   AND ATTRIBUTE1			= 'N'
				   ;

			END;

			FETCH NEXT FROM CUR_OWMS_STOCK INTO @stock_cnt, 
											    @company_id,
											    @group_seq
		END; 

		CLOSE CUR_OWMS_STOCK; 
		DEALLOCATE CUR_OWMS_STOCK;

		-- IF data  삭제 (30일 이전 데이터 삭제) 
		DELETE 
		  FROM XIF_OWMS_STOCK_EE_R_SN 
		 WHERE IF_RCV_DATE < GETDATE() - 30
		;

		-- data  삭제 (3개월  이전 데이터 삭제) 
		DELETE 
		  FROM SSP_DNM_OWMS_STOCK_EE
		 WHERE YYYYMMDD < CONVERT(VARCHAR, DATEADD(M, -3, GETDATE()) ,112)
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

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_OWMS_STOCK')
			BEGIN
				CLOSE CUR_OWMS_STOCK ;
				DEALLOCATE CUR_OWMS_STOCK ;
			END
        END;
      
		-- ERROR LOG
		SET @v_log_type = N'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		--EXEC PR_SCP_SYS_LOG_BATCH @p_program_name  =@v_program_name
		--						 ,@p_log_type      =@v_log_type
		--						 ,@p_log_count     =@n_log_count 
		--						 ,@p_log_message   =@v_log_message 
		--						 ,@p_description   =@v_description 
		--						 ,@p_event_date    =@d_event_date 
		--						 ,@p_user_id       =@v_batch_user
		--						 ;
		IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_STOCK_EE_R') IS NOT NULL
			DROP TABLE #tmp_XIF_OWMS_STOCK_EE_R


		--SET @E_TYPE = 'E';
		SET @E_MESSAGE = ERROR_MESSAGE();
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

	IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_STOCK_EE_R') IS NOT NULL
		DROP TABLE #tmp_XIF_OWMS_STOCK_EE_R
   
--    return 1  
     SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE;
  END;
