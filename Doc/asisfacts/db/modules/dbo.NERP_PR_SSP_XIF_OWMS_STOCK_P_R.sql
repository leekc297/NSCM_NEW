







/*
 * Program ID   : [NERP_PR_SSP_XIF_OWMS_STOCK_P_R]  
 * Description  : OWMS 재고 정보 I/F 수신 반영(Every 1 Hour) 
 * OutTable     : XIF_OWMS_STOCK_R_SN --> SSP_DNM_OWMS_STOCK 
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.12.05   LJH			   Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019.04.08   LJH			   [PJ20189106] 전지.GSCM 고도화 이행 AVAILABLE_QTY 로직 적용
							   AVAILABLE_QTY = STOCK_QTY - BLOCK_QTY - LONG_QTY , 단 BLOCK_QTY , LONG_QTY 둘다 있으면, 큰수를 적용  
 * 2020.06.08   KIMYONGHO	   [C20200601-000370] oWMS - SSP 재고 I/F 주기 수정 요청  (CUTTOFF_DATE 컬럼 추가)
 * 2020.07.29   KIMYONGHO	   [C20200603-000259] [SCM PI] OWMS → SSP로 I/F 되는 OWMS 재고 정보에 OQC Reqno와 Volvo Accu 창고의 시험의뢰일 필드 추가 요청 건
 * 2021.02.04   KIMBK		   COMPANY 별 재고 수신정보 체크 추가
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2024.03.20   KHJ			   SAP PO로 변경 / NERP 데이터 변환 로직 추가 / NERP_SSP
 * 2025.01.10   SSP Pjt.       WA00법인(25000건이상) 처리 지연으로 인터페이스 처리 로직만 적용
 */

CREATE PROCEDURE [dbo].[NERP_PR_SSP_XIF_OWMS_STOCK_P_R]
--	@ZNEIFSSP_00247S		AS DBO.ZNEIFSSP_00247S READONLY
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_OWMS_STOCK_P_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_OWMS_STOCK'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

    DECLARE @TRANSFER_DATE			DATETIME        = GETDATE();    
    DECLARE @TRANSFER_FLAG			NVARCHAR(50)	= 'N';
	DECLARE @XIF_OWMS_STOCK_R		TABLE 
	(
		[IF_SEQ] 				[nvarchar](50) NOT NULL,
		[MASTER_IF_SEQ] 		[nvarchar](50) NOT NULL,
		[IF_TYPE] 				[nvarchar](1) NOT NULL,
		[IF_ID] 				[nvarchar](50) NOT NULL,
		[IF_RCV_DATE] 			[datetime] NOT NULL,
		[PROC_FLAG] 			[nvarchar](1) NOT NULL,
		[PROC_DATE] 			[datetime] NULL,
		[PROC_MSG] 				[nvarchar](1000) NULL,
		[ITEM_ID] 				[nvarchar](50) NULL,
		[PALLET_ID] 			[varchar](50) NULL,
		[STOCK_QTY] 			[numeric](20, 10) NULL,
		[AVAILABLE_QTY] 		[numeric](20, 10) NULL,
		[NON_QC_QTY] 			[numeric](20, 10) NULL,
		[ALLOCATION_QTY] 		[numeric](20, 10) NULL,
		[BLOCK_QTY] 			[numeric](20, 10) NULL,
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
		[STOCK_STATUS] 			[nvarchar](40) NULL,
		[STORAGE_ID] 			[nvarchar](30) NULL,
		[CUSTOMER_CODE] 		[nvarchar](50) NULL,
		[CUSTOMER_NAME] 		[nvarchar](180) NULL,
		[LOT_DATE] 				[nvarchar](14) NULL,
		[SOC] 					[nvarchar](14) NULL,
		[CAPACITY_GRADE] 		[nvarchar](40) NULL,
		[CREATION_DATE] 		[datetime] NULL,
		[ATTRIBUTE1] 			[varchar](150) NULL,
		[ATTRIBUTE2] 			[varchar](150) NULL,
		[ATTRIBUTE3] 			[varchar](150) NULL,
		[ATTRIBUTE4] 			[varchar](150) NULL,
		[ATTRIBUTE5] 			[varchar](150) NULL,
		[ATTRIBUTE6] 			[varchar](150) NULL,
		[ATTRIBUTE7] 			[varchar](150) NULL,
		[ATTRIBUTE8] 			[varchar](150) NULL,
		[ATTRIBUTE9] 			[varchar](150) NULL,
		[ATTRIBUTE10] 			[varchar](150) NULL
	);

    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

    DECLARE @v_G182 NVARCHAR(20);
	SET @v_G182 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_XIF_OWMS_STOCK_R'  ,'G182');

	-- DECLARE @v_master_if_seq  NVARCHAR(MAX) = '';
	DECLARE @v_count          INT  = 0 ;
	DECLARE @v_cnt            INT  = 0 ;

	-- LSP 전달을 위한 변수선언
    DECLARE @E_TYPE					NVARCHAR(50)	= N'S'; --메시지 유형: S 성공, E 오류
    DECLARE @E_MESSAGE				NVARCHAR(100)	= N'SUCCESS';

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_OWMS_STOCK INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;

	IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_STOCK_R') IS NOT NULL
		DROP TABLE #tmp_XIF_OWMS_STOCK_R

	CREATE TABLE #tmp_XIF_OWMS_STOCK_R (
		[IF_SEQ] [nvarchar](50) NOT NULL,
		[MASTER_IF_SEQ] [nvarchar](50) NOT NULL INDEX vix01_tmp_XIF_OWMS_STOCK_R(MASTER_IF_SEQ, ATTRIBUTE5),
		[IF_TYPE] [nvarchar](1) NOT NULL,
		[IF_ID] [nvarchar](50) NOT NULL,
		[IF_RCV_DATE] [datetime] NOT NULL,
		[PROC_FLAG] [nvarchar](1) NOT NULL,
		[PROC_DATE] [datetime] NULL,
		[PROC_MSG] [nvarchar](1000) NULL,
		[ITEM_ID] [nvarchar](50) NULL,
		[PALLET_ID] [varchar](50) NULL,
		[STOCK_QTY] [numeric](20, 10) NULL,
		[AVAILABLE_QTY] [numeric](20, 10) NULL,
		[NON_QC_QTY] [numeric](20, 10) NULL,
		[ALLOCATION_QTY] [numeric](20, 10) NULL,
		[BLOCK_QTY] [numeric](20, 10) NULL,
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
		[STOCK_STATUS] [nvarchar](40) NULL,
		[STORAGE_ID] [nvarchar](30) NULL,
		[CUSTOMER_CODE] [nvarchar](50) NULL,
		[CUSTOMER_NAME] [nvarchar](180) NULL,
		[LOT_DATE] [nvarchar](14) NULL,
		[SOC] [nvarchar](14) NULL,
		[CAPACITY_GRADE] [nvarchar](40) NULL,
		[CREATION_DATE] [datetime] NULL,
		[ATTRIBUTE1] [varchar](150) NULL,
		[ATTRIBUTE2] [varchar](150) NULL,
		[ATTRIBUTE3] [varchar](150) NULL,
		[ATTRIBUTE4] [varchar](150) NULL,
		[ATTRIBUTE5] [varchar](150) NULL,
		[ATTRIBUTE6] [varchar](150) NULL,
		[ATTRIBUTE7] [varchar](150) NULL,
		[ATTRIBUTE8] [varchar](150) NULL,
		[ATTRIBUTE9] [varchar](150) NULL,
		[ATTRIBUTE10] [varchar](150) NULL
	);

	--BEGIN
	---- SAP PO DATA ==> XIF_OWMS_STOCK_R_SN으로 INSERT 처리
	--	INSERT INTO @XIF_OWMS_STOCK_R ( 
	--			  [IF_SEQ] 				
	--			, [MASTER_IF_SEQ] 		
	--			, [IF_TYPE] 				
	--			, [IF_ID] 				
	--			, [IF_RCV_DATE] 			
	--			, [PROC_FLAG] 			
	--			, [PROC_DATE] 			
	--			, [PROC_MSG] 				
	--			, [ITEM_ID] 				
	--			, [PALLET_ID] 			
	--			, [STOCK_QTY] 			
	--			, [AVAILABLE_QTY] 		
	--			, [NON_QC_QTY] 			
	--			, [ALLOCATION_QTY] 		
	--			, [BLOCK_QTY] 			
	--			, [PACKING_QTY] 			
	--			, [MOVING_QTY] 			
	--			, [RCVLOC_QTY] 			
	--			, [EXPIRATION_QTY] 		
	--			, [LONG_QTY] 				
	--			, [PROD_GROUP] 			
	--			, [LOT_ID] 				
	--			, [PLANT_ID] 				
	--			, [GRADE] 				
	--			, [PACKING_STATUS] 		
	--			, [STOCK_STATUS] 			
	--			, [STORAGE_ID] 			
	--			, [CUSTOMER_CODE] 		
	--			, [CUSTOMER_NAME] 		
	--			, [LOT_DATE] 				
	--			, [SOC] 					
	--			, [CAPACITY_GRADE] 		
	--			, [CREATION_DATE] 		
	--			, [ATTRIBUTE1] 			
	--			, [ATTRIBUTE2] 			
	--			, [ATTRIBUTE3] 			
	--			, [ATTRIBUTE4] 			
	--			, [ATTRIBUTE5] 			
	--			, [ATTRIBUTE6] 			
	--			, [ATTRIBUTE7] 			
	--			, [ATTRIBUTE8] 			
	--			, [ATTRIBUTE9] 			
	--			, [ATTRIBUTE10] 		
	--		)
	--	SELECT  
	--	-- XIF_OWMS_STOCK_R_SN 형식에 맞추어 수신됨
	--			  [IF_SEQ] 				
	--			, [MASTER_IF_SEQ] 		
	--			, [IF_TYPE] 				
	--			, [IF_ID] 		
	--			, @TRANSFER_DATE		AS IF_RCV_DATE 			
	--			, @TRANSFER_FLAG		AS PROC_FLAG 			
	--			, @TRANSFER_DATE		AS PROC_DATE 			
	--			, NULL					AS PROC_MSG 
	--			, [ITEM_ID] 				
	--			, [PALLET_ID] 			
	--			, [STOCK_QTY] 			
	--			, [AVAILABLE_QTY] 		
	--			, [NON_QC_QTY] 			
	--			, [ALLOCATION_QTY] 		
	--			, [BLOCK_QTY] 			
	--			, [PACKING_QTY] 			
	--			, [MOVING_QTY] 			
	--			, [RCVLOC_QTY] 			
	--			, [EXPIRATION_QTY] 		
	--			, [LONG_QTY] 				
	--			, [PROD_GROUP] 			
	--			, [LOT_ID] 				
	--			, [PLANT_ID] 				
	--			, [GRADE] 				
	--			, [PACKING_STATUS] 		
	--			, [STOCK_STATUS] 			
	--			, [STORAGE_ID] 			
	--			, [CUSTOMER_CODE] 		
	--			, [CUSTOMER_NAME] 		
	--			, [LOT_DATE] 				
	--			, [SOC] 					
	--			, [CAPACITY_GRADE] 		
	--			, @TRANSFER_DATE		AS CREATION_DATE 		
	--			, [ATTRIBUTE1] 			
	--			, [ATTRIBUTE2] 			
	--			, [ATTRIBUTE3] 			
	--			, [ATTRIBUTE4] 			
	--			, [ATTRIBUTE5] 			
	--			, [ATTRIBUTE6] 			
	--			, [ATTRIBUTE7] 			
	--			, [ATTRIBUTE8] 			
	--			, [ATTRIBUTE9] 			
	--			, [ATTRIBUTE10] 
	--	FROM @ZNEIFSSP_00247S ;	

	--	INSERT INTO XIF_OWMS_STOCK_R_SN (
	--			  [IF_SEQ] 				
	--			, [MASTER_IF_SEQ] 		
	--			, [IF_TYPE] 				
	--			, [IF_ID] 				
	--			, [IF_RCV_DATE] 			
	--			, [PROC_FLAG] 			
	--			, [PROC_DATE] 			
	--			, [PROC_MSG] 				
	--			, [ITEM_ID] 				
	--			, [PALLET_ID] 			
	--			, [STOCK_QTY] 			
	--			, [AVAILABLE_QTY] 		
	--			, [NON_QC_QTY] 			
	--			, [ALLOCATION_QTY] 		
	--			, [BLOCK_QTY] 			
	--			, [PACKING_QTY] 			
	--			, [MOVING_QTY] 			
	--			, [RCVLOC_QTY] 			
	--			, [EXPIRATION_QTY] 		
	--			, [LONG_QTY] 				
	--			, [PROD_GROUP] 			
	--			, [LOT_ID] 				
	--			, [PLANT_ID] 				
	--			, [GRADE] 				
	--			, [PACKING_STATUS] 		
	--			, [STOCK_STATUS] 			
	--			, [STORAGE_ID] 			
	--			, [CUSTOMER_CODE] 		
	--			, [CUSTOMER_NAME] 		
	--			, [LOT_DATE] 				
	--			, [SOC] 					
	--			, [CAPACITY_GRADE] 		
	--			, [CREATION_DATE] 		
	--			, [ATTRIBUTE1] 			
	--			, [ATTRIBUTE2] 			
	--			, [ATTRIBUTE3] 			
	--			, [ATTRIBUTE4] 			
	--			, [ATTRIBUTE5] 			
	--			, [ATTRIBUTE6] 			
	--			, [ATTRIBUTE7] 			
	--			, [ATTRIBUTE8] 			
	--			, [ATTRIBUTE9] 			
	--			, [ATTRIBUTE10]
	--	)
	--	SELECT    [IF_SEQ] 				
	--			, [MASTER_IF_SEQ] 		
	--			, [IF_TYPE] 				
	--			, [IF_ID] 				
	--			, [IF_RCV_DATE] 			
	--			, [PROC_FLAG] 			
	--			, [PROC_DATE] 			
	--			, [PROC_MSG] 				
	--			, [ITEM_ID] 				
	--			, [PALLET_ID] 			
	--			, [STOCK_QTY] 			
	--			, [AVAILABLE_QTY] 		
	--			, [NON_QC_QTY] 			
	--			, [ALLOCATION_QTY] 		
	--			, [BLOCK_QTY] 			
	--			, [PACKING_QTY] 			
	--			, [MOVING_QTY] 			
	--			, [RCVLOC_QTY] 			
	--			, [EXPIRATION_QTY] 		
	--			, [LONG_QTY] 				
	--			, [PROD_GROUP] 			
	--			, [LOT_ID] 				
	--			, [PLANT_ID] 				
	--			, [GRADE] 				
	--			, [PACKING_STATUS] 		
	--			, [STOCK_STATUS] 			
	--			, [STORAGE_ID] 			
	--			, [CUSTOMER_CODE] 		
	--			, [CUSTOMER_NAME] 		
	--			, [LOT_DATE] 				
	--			, [SOC] 					
	--			, [CAPACITY_GRADE] 		
	--			, [CREATION_DATE] 		
	--			, [ATTRIBUTE1] 			
	--			, [ATTRIBUTE2] 			
	--			, [ATTRIBUTE3] 			
	--			, [ATTRIBUTE4] 			
	--			, [ATTRIBUTE5] 			
	--			, [ATTRIBUTE6] 			
	--			, [ATTRIBUTE7] 			
	--			, [ATTRIBUTE8] 			
	--			, [ATTRIBUTE9] 			
	--			, [ATTRIBUTE10]
	--	FROM @XIF_OWMS_STOCK_R ;	

	--END

    BEGIN TRY
    BEGIN
        BEGIN TRAN TX_SH

		DECLARE @stock_cnt INTEGER, 
			    @company_id VARCHAR(30),  
				@group_seq VARCHAR(30)

		DECLARE @idx INT     SET     @idx = 0  
 
/*INF-R 적용 이전 
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
					    END AS CHECK_CNT
					  , A.COMPANY_ID
					  , A.COMPANY_ID + SUBSTRING(A.GROUP_SEQ, 5, 6)  AS GROUP_SEQ
				   FROM (
						SELECT A.ATTRIBUTE5		AS COMPANY_ID
							 , A.MASTER_IF_SEQ  AS GROUP_SEQ
							 , COUNT(*)			AS IF_CNT
						 FROM   XIF_OWMS_STOCK_R_SN  A WITH(NOLOCK)
						 WHERE  1 = 1
						   AND ISNULL(A.PROC_FLAG,'N') = 'N'
						   AND A.MASTER_IF_SEQ LIKE '%'+ CONVERT(CHAR(6), GETDATE(), 12) + '%'
						   AND CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
						 GROUP BY 
						       A.ATTRIBUTE5, A.MASTER_IF_SEQ
						) A
						LEFT OUTER JOIN (
						                SELECT A.COMPANY_ID
										     , A.GROUP_SEQ
											 , SUM(IF_CNT) AS IF_CNT
						                  FROM (
								               SELECT A.ATTRIBUTE5		AS COMPANY_ID
								               	    , A.MASTER_IF_SEQ	AS GROUP_SEQ
								               	    , CONVERT(INT, A.ATTRIBUTE6)  AS IF_CNT
								                 FROM XIF_OWMS_STOCK_R_SN  A WITH(NOLOCK)
								                WHERE 1 = 1
								                  AND ISNULL(A.PROC_FLAG,'N') = 'N'
								                  AND A.MASTER_IF_SEQ LIKE '%' + CONVERT(CHAR(6), GETDATE(), 12) + '%'
								                  AND CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
								                GROUP BY 
											          A.ATTRIBUTE5, A.ATTRIBUTE6, A.MASTER_IF_SEQ
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


/*INF-R 적용 이후 */
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
					    END AS CHECK_CNT
					  , A.COMPANY_ID
					  , A.COMPANY_ID + SUBSTRING(A.GROUP_SEQ, 5, 6)  AS GROUP_SEQ
				   FROM (
						SELECT ISNULL(X1.NEW_VALUE1, A.ATTRIBUTE5) AS COMPANY_ID
							 , A.MASTER_IF_SEQ  AS GROUP_SEQ
							 , COUNT(*)			AS IF_CNT
						 FROM   XIF_OWMS_STOCK_R_SN  A WITH(NOLOCK)
							LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
							ON  X1.CODETYPE = 'COMPANY_ID'
							AND A.ATTRIBUTE5 = X1.OLD_VALUE1
							AND X1.ATTRIBUTE5 = '1ST'
						 WHERE  1 = 1
						   AND A.PROC_FLAG = 'N'
						   AND A.MASTER_IF_SEQ LIKE '%'+ CONVERT(CHAR(6), GETDATE(), 12) + '%'
						   AND CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
						 GROUP BY 
						       A.ATTRIBUTE5, A.MASTER_IF_SEQ, X1.NEW_VALUE1
						) A
						LEFT OUTER JOIN (
						                SELECT A.COMPANY_ID
										     , A.GROUP_SEQ
											 , SUM(IF_CNT) AS IF_CNT
						                  FROM (
								               SELECT ISNULL(X1.NEW_VALUE1, A.ATTRIBUTE5) AS COMPANY_ID
								               	    , A.MASTER_IF_SEQ	AS GROUP_SEQ
								               	    , CONVERT(INT, A.ATTRIBUTE6)  AS IF_CNT
								                 FROM XIF_OWMS_STOCK_R_SN  A WITH(NOLOCK)
													LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
													ON  X1.CODETYPE = 'COMPANY_ID'
													AND A.ATTRIBUTE5 = X1.OLD_VALUE1
													AND X1.ATTRIBUTE5 = '1ST'
								                WHERE 1 = 1
								                  AND A.PROC_FLAG = 'N'
								                  AND A.MASTER_IF_SEQ LIKE '%' + CONVERT(CHAR(6), GETDATE(), 12) + '%'
								                  AND CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
								                GROUP BY 
											          A.ATTRIBUTE5, A.ATTRIBUTE6, A.MASTER_IF_SEQ, X1.NEW_VALUE1
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
			   AND A.SEGMENT1		= 'PLAN_AUTO'
			   AND A.SEGMENT2		= 'OWMS'
			   AND A.SEGMENT3		= '81_82'
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
				   AND SEGMENT1		= 'PLAN_AUTO'
				   AND SEGMENT2		= 'OWMS'
				   AND SEGMENT3		= '81_82'
				   AND SEGMENT4		= @company_id
				   ;

				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				   SET SEGMENT5		= CONVERT(CHAR(8), GETDATE(), 112)
					 , ATTRIBUTE1	= 'N'
				 WHERE 1 = 1
				   AND LOOKUP_TYPE	= 'IF_STOCK_CHECK'
				   AND SEGMENT1		= 'PLAN_40'
				   AND SEGMENT2		= 'OWMS'
				   AND SEGMENT3		= '40'
				   AND SEGMENT4		= @company_id
				   ;

				--CURSOR 선언 
				DECLARE @master_if_seq VARCHAR(MAX)
 

				DECLARE CUR_OWMS_R CURSOR FOR  
				 SELECT MASTER_IF_SEQ
				   FROM XIF_OWMS_STOCK_R_SN A WITH(NOLOCK) 
					LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
					ON  X1.CODETYPE = 'COMPANY_ID'
					AND A.ATTRIBUTE5 = X1.OLD_VALUE1 
					AND X1.ATTRIBUTE5 = '1ST'
				  WHERE A.PROC_FLAG	= 'N' 
				    AND ISNULL(X1.NEW_VALUE1, A.ATTRIBUTE5) = @company_id
				  GROUP BY A.MASTER_IF_SEQ
				;

				OPEN CUR_OWMS_R; 

				FETCH NEXT FROM CUR_OWMS_R INTO @master_if_seq

				WHILE(@@FETCH_STATUS = 0) 
				BEGIN

				    DELETE FROM #tmp_XIF_OWMS_STOCK_R
/*INF-R 적용 이전
					INSERT INTO #tmp_XIF_OWMS_STOCK_R
							   ([IF_SEQ]
							   ,[MASTER_IF_SEQ]
							   ,[IF_TYPE]
							   ,[IF_ID]
							   ,[IF_RCV_DATE]
							   ,[PROC_FLAG]
							   ,[PROC_DATE]
							   ,[PROC_MSG]
							   ,[ITEM_ID]
							   ,[PALLET_ID]
							   ,[STOCK_QTY]
							   ,[AVAILABLE_QTY]
							   ,[NON_QC_QTY]
							   ,[ALLOCATION_QTY]
							   ,[BLOCK_QTY]
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
							   ,[STOCK_STATUS]
							   ,[STORAGE_ID]
							   ,[CUSTOMER_CODE]
							   ,[CUSTOMER_NAME]
							   ,[LOT_DATE]
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
							   ,[MASTER_IF_SEQ]
							   ,[IF_TYPE]
							   ,[IF_ID]
							   ,[IF_RCV_DATE]
							   ,[PROC_FLAG]
							   ,[PROC_DATE]
							   ,[PROC_MSG]
							   ,[ITEM_ID]
							   ,[PALLET_ID]
							   ,[STOCK_QTY]
							   ,[AVAILABLE_QTY]
							   ,[NON_QC_QTY]
							   ,[ALLOCATION_QTY]
							   ,[BLOCK_QTY]
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
							   ,[STOCK_STATUS]
							   ,[STORAGE_ID]
							   ,[CUSTOMER_CODE]
							   ,[CUSTOMER_NAME]
							   ,[LOT_DATE]
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
						   FROM [dbo].[XIF_OWMS_STOCK_R_SN] A WITH(NOLOCK)
					      WHERE 1 = 1
						    AND ISNULL(PROC_FLAG,'N')	= 'N'
					        AND MASTER_IF_SEQ			= @master_if_seq
							AND ATTRIBUTE5				= @company_id
*/


/*INF-R 적용 이후 */
					INSERT INTO #tmp_XIF_OWMS_STOCK_R
							   ([IF_SEQ]
							   ,[MASTER_IF_SEQ]
							   ,[IF_TYPE]
							   ,[IF_ID]
							   ,[IF_RCV_DATE]
							   ,[PROC_FLAG]
							   ,[PROC_DATE]
							   ,[PROC_MSG]
							   ,[ITEM_ID]
							   ,[PALLET_ID]
							   ,[STOCK_QTY]
							   ,[AVAILABLE_QTY]
							   ,[NON_QC_QTY]
							   ,[ALLOCATION_QTY]
							   ,[BLOCK_QTY]
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
							   ,[STOCK_STATUS]
							   ,[STORAGE_ID]
							   ,[CUSTOMER_CODE]
							   ,[CUSTOMER_NAME]
							   ,[LOT_DATE]
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
							   ,[MASTER_IF_SEQ]
							   ,[IF_TYPE]
							   ,[IF_ID]
							   ,[IF_RCV_DATE]
							   ,[PROC_FLAG]
							   ,[PROC_DATE]
							   ,[PROC_MSG]
							   ,[ITEM_ID]
							   ,[PALLET_ID]
							   ,[STOCK_QTY]
							   ,[AVAILABLE_QTY]
							   ,[NON_QC_QTY]
							   ,[ALLOCATION_QTY]
							   ,[BLOCK_QTY]
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
							   ,[STOCK_STATUS]
							   ,ISNULL(X1.NEW_VALUE2, A.STORAGE_ID) AS STORAGE_ID
							   ,[CUSTOMER_CODE]
							   ,[CUSTOMER_NAME]
							   ,[LOT_DATE]
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
						   FROM [dbo].[XIF_OWMS_STOCK_R_SN] A WITH(NOLOCK)
							LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
							ON  X1.CODETYPE = 'STORAGE_ID'
							AND A.PLANT_ID = X1.OLD_VALUE1 
							AND A.STORAGE_ID = X1.OLD_VALUE2 
							AND X1.ATTRIBUTE5 = '1ST'
							LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
							ON  X2.CODETYPE = 'PLANT_ID'
							AND A.CAPACITY_GRADE = X2.OLD_VALUE1 
							AND X2.ATTRIBUTE5 = '1ST'
							LEFT OUTER JOIN  NERP_CONV_MASTER X3 WITH(NOLOCK)
							ON  X3.CODETYPE = 'COMPANY_ID'
							AND A.ATTRIBUTE5 = X3.OLD_VALUE1 
							AND X3.ATTRIBUTE5 = '1ST'
					      WHERE 1 = 1
						    AND PROC_FLAG	= 'N'
					        AND MASTER_IF_SEQ			= @master_if_seq
							AND A.ATTRIBUTE5				= @company_id

					-- 법인 별 일 1회만 전송하기로했으나 이전과같이 여러번 올 경우 가정하고
					-- master_if_seq 만 변경되고 동일한 데이터 들어올 경우 
					-- 수량,  master_if_seq  UPDATE 처리
					MERGE INTO SSP_DNM_OWMS_STOCK A
					USING (
						  SELECT ATTRIBUTE8																		AS CUTOFF_DATE		--[C20200601-000370] 컬럼추가	
							    ,CASE WHEN DBO.FN_GET_ITEM_OPERATION_GROUP(PROD_GROUP,ITEM_ID) = 'E' THEN 'EE' 
							     ELSE PROD_GROUP 
							     END																			AS DIVISION_ID  --EE는 사용되지 않음
							    ,ITEM_ID 																		AS ITEM_ID
							    ,ISNULL(PALLET_ID,'-')															AS PALLET_ID
							    ,STOCK_QTY																		AS STOCK_QTY
							    -- STOCK_QTY - BLOCK_QTY - LONG_QTY , 단 BLOCK_QTY , LONG_QTY 둘다 있으면, 큰수를 적용, 남경의 경우 BLOCK_QTY만 제외 			     
							    -- G182의 경우는 STOCK_QTY - BLOCK_QTY 적용 (20190520 Requested by 지준혁) 												
--							    ,STOCK_QTY -  CASE WHEN PLANT_ID = 'G182' THEN BLOCK_QTY																
							    ,STOCK_QTY -  CASE WHEN PLANT_ID = @v_G182 THEN BLOCK_QTY																
							    			  ELSE																							
							    				  CASE WHEN  BLOCK_QTY > LONG_QTY THEN  BLOCK_QTY													
							    					   WHEN  BLOCK_QTY < LONG_QTY THEN  LONG_QTY												
							    					   WHEN  BLOCK_QTY = LONG_QTY THEN  BLOCK_QTY												
							    				  END    																					
							    			  END																AS AVAILABLE_QTY -- STOCK_QTY - BLOCK_QTY - LONG_QTY , 단 BLOCK_QTY , LONG_QTY 둘다 있으면, 큰수를 적용		     							
							    ,AVAILABLE_QTY																	AS AVAILABLE_QTY_ORIGIN																			   	
							    ,NON_QC_QTY																		AS NON_QC_QTY
							    ,ALLOCATION_QTY																	AS ALLOCATION_QTY
							    ,BLOCK_QTY																		AS BLOCK_QTY
							    ,PACKING_QTY																	AS PACKING_QTY
							    ,MOVING_QTY																		AS MOVING_QTY
							    ,RCVLOC_QTY																		AS RCVLOC_QTY
							    ,EXPIRATION_QTY																	AS EXPIRATION_QTY
							    ,LONG_QTY																		AS LONG_QTY
							    ,PROD_GROUP																		AS PROD_GROUP
							    ,ISNULL(LOT_ID,'-')																AS LOT_ID
							    ,PLANT_ID																		AS PLANT_ID
							    ,ISNULL(GRADE, '-') 															AS GRADE
							    ,ISNULL(PACKING_STATUS, '-')													AS PACKING_STATUS
							    ,ISNULL(STOCK_STATUS,'-') 														AS STOCK_STATUS
							    ,ISNULL(STORAGE_ID,'-') 														AS STORAGE_ID
							    ,ISNULL(CUSTOMER_CODE,'-') 														AS CUSTOMER_CODE
							    ,CUSTOMER_NAME																	AS CUSTOMER_NAME
							    ,LOT_DATE																		AS LOT_DATE
							    ,ISNULL(SOC, '-') 																AS SOC
							    ,ISNULL(CAPACITY_GRADE, '-') 													AS CAPACITY_GRADE
							    ,PROD_GROUP    																	AS ORIGIN_FROM_DIVISION_ID
							    ,'OWMS I/F'    															   		AS CREATED_BY
							    ,CREATION_DATE 															   		AS CREATION_DATE
							    ,'OWMS I/F'    															   		AS LAST_UPDATED_BY
							    ,IF_RCV_DATE    																AS LAST_UPDATE_DATE
							    /* [C20200603-000259] 과거 MASTER_IF_SEQ 와 신규 MASTER_IF_SEQ 다르면 삭제 하는 로직이 있었으나 필요없음으로 제외 처리 하고 
							    	 OQC Reqno (ATTRIBUTE1)와 Volvo Accu (ATTRIBUTE2) 로 대체
					 		    
							    */
							    ,ATTRIBUTE1	 															   		AS ATTRIBUTE1   
							    ,ATTRIBUTE2																		AS ATTRIBUTE2
							    ,ATTRIBUTE3																		AS ATTRIBUTE3
							    ,ATTRIBUTE4																		AS ATTRIBUTE4
							    ,ATTRIBUTE5																		AS ATTRIBUTE5
							    ,ATTRIBUTE6																		AS ATTRIBUTE6
							    ,ATTRIBUTE7																		AS ATTRIBUTE7
							    ,ATTRIBUTE8																		AS ATTRIBUTE8
							    ,ATTRIBUTE9																		AS ATTRIBUTE9
							    ,ATTRIBUTE10																	AS ATTRIBUTE10
						    FROM #tmp_XIF_OWMS_STOCK_R WITH(NOLOCK) 
						   WHERE 1 = 1
						     AND MASTER_IF_SEQ	= @master_if_seq
						     AND ATTRIBUTE5		= @company_id
						     AND ATTRIBUTE6 <> '0'
						  ) B
					   ON A.CUTOFF_DATE					= B.CUTOFF_DATE
					  AND A.DIVISION_ID					= B.DIVISION_ID
					  AND A.ITEM_ID						= B.ITEM_ID
					  AND A.PALLET_ID					= B.PALLET_ID
					  AND A.PROD_GROUP					= B.PROD_GROUP
					  AND A.LOT_ID						= B.LOT_ID
					  AND A.PLANT_ID					= B.PLANT_ID
					  AND A.GRADE						= B.GRADE
					  AND A.PACKING_STATUS				= B.PACKING_STATUS
					  AND A.STOCK_STATUS				= B.STOCK_STATUS
					  AND A.STORAGE_ID					= B.STORAGE_ID
					  AND A.CUSTOMER_CODE				= B.CUSTOMER_CODE
					  AND A.LOT_DATE					= B.LOT_DATE
					  AND A.SOC							= B.SOC
					  AND A.CAPACITY_GRADE				= B.CAPACITY_GRADE
					WHEN MATCHED THEN
					UPDATE 
					   SET STOCK_QTY				= B.STOCK_QTY		
						 , AVAILABLE_QTY			= B.AVAILABLE_QTY	
						 , AVAILABLE_QTY_ORIGIN		= B.AVAILABLE_QTY_ORIGIN
						 , NON_QC_QTY				= B.NON_QC_QTY		
						 , ALLOCATION_QTY			= B.ALLOCATION_QTY
						 , BLOCK_QTY				= B.BLOCK_QTY
						 , PACKING_QTY				= B.PACKING_QTY
						 , MOVING_QTY				= B.MOVING_QTY
						 , RCVLOC_QTY				= B.RCVLOC_QTY
						 , EXPIRATION_QTY			= B.EXPIRATION_QTY
						 , LONG_QTY					= B.LONG_QTY
						 , LAST_UPDATE_DATE			= GETDATE()
						 , ATTRIBUTE1	            = B.ATTRIBUTE1	
						 , ATTRIBUTE2				= B.ATTRIBUTE2	
						 , ATTRIBUTE3				= B.ATTRIBUTE3	
						 , ATTRIBUTE4				= B.ATTRIBUTE4	
						 , ATTRIBUTE5				= B.ATTRIBUTE5	
						 , ATTRIBUTE6				= B.ATTRIBUTE6	
						 , ATTRIBUTE7				= B.ATTRIBUTE7	
						 , ATTRIBUTE8				= B.ATTRIBUTE8	
						 , ATTRIBUTE9				= B.ATTRIBUTE9	
						 , ATTRIBUTE10				= B.ATTRIBUTE10
					WHEN NOT MATCHED THEN
					INSERT (	
						   CUTOFF_DATE		--[C20200601-000370] 컬럼추가
						 , DIVISION_ID
						 , ITEM_ID
						 , PALLET_ID
						 , STOCK_QTY
						 , AVAILABLE_QTY           -- STOCK_QTY 
						 , AVAILABLE_QTY_ORIGIN
						 , NON_QC_QTY
						 , ALLOCATION_QTY
						 , BLOCK_QTY
						 , PACKING_QTY
						 , MOVING_QTY
						 , RCVLOC_QTY
						 , EXPIRATION_QTY
						 , LONG_QTY
						 , PROD_GROUP
						 , LOT_ID
						 , PLANT_ID
						 , GRADE
						 , PACKING_STATUS
						 , STOCK_STATUS
						 , STORAGE_ID
						 , CUSTOMER_CODE
						 , CUSTOMER_NAME
						 , LOT_DATE
						 , SOC
						 , CAPACITY_GRADE
						 , ORIGIN_FROM_DIVISION_ID
						 , CREATED_BY
						 , CREATION_DATE
						 , LAST_UPDATED_BY
						 , LAST_UPDATE_DATE
						 , ATTRIBUTE1
						 , ATTRIBUTE2
						 , ATTRIBUTE3
						 , ATTRIBUTE4
						 , ATTRIBUTE5
						 , ATTRIBUTE6
						 , ATTRIBUTE7
						 , ATTRIBUTE8
						 , ATTRIBUTE9
						 , ATTRIBUTE10
						   )
					VALUES (
						   B.CUTOFF_DATE
						 , B.DIVISION_ID
						 , B.ITEM_ID
						 , B.PALLET_ID
						 , B.STOCK_QTY
						 , B.AVAILABLE_QTY
						 , B.AVAILABLE_QTY_ORIGIN
						 , B.NON_QC_QTY
						 , B.ALLOCATION_QTY
						 , B.BLOCK_QTY
						 , B.PACKING_QTY
						 , B.MOVING_QTY
						 , B.RCVLOC_QTY
						 , B.EXPIRATION_QTY
						 , B.LONG_QTY
						 , B.PROD_GROUP
						 , B.LOT_ID
						 , B.PLANT_ID
						 , B.GRADE
						 , B.PACKING_STATUS
						 , B.STOCK_STATUS
						 , B.STORAGE_ID
						 , B.CUSTOMER_CODE
						 , B.CUSTOMER_NAME
						 , ISNULL(B.LOT_DATE, '')
						 , B.SOC
						 , B.CAPACITY_GRADE
						 , B.ORIGIN_FROM_DIVISION_ID
						 , B.CREATED_BY
						 , B.CREATION_DATE
						 , B.LAST_UPDATED_BY
						 , B.LAST_UPDATE_DATE
						 , B.ATTRIBUTE1
						 , B.ATTRIBUTE2
						 , B.ATTRIBUTE3
						 , B.ATTRIBUTE4
						 , B.ATTRIBUTE5
						 , B.ATTRIBUTE6
						 , B.ATTRIBUTE7
						 , B.ATTRIBUTE8
						 , B.ATTRIBUTE9
						 , B.ATTRIBUTE10
						   );

					-- 인터페이스 테이블 처리 완료 UPDATE
					UPDATE S
					   SET S.PROC_FLAG             = 'Y'
					     , S.PROC_DATE             = GETDATE()   
					     , S.PROC_MSG              = 'S'
					  FROM XIF_OWMS_STOCK_R_SN	AS S WITH(NOLOCK)
					       JOIN #tmp_XIF_OWMS_STOCK_R	AS T
						ON S.IF_SEQ = T.IF_SEQ
					;  

					FETCH NEXT FROM CUR_OWMS_R INTO @master_if_seq  ; 

				END;

				CLOSE CUR_OWMS_R; 
				DEALLOCATE CUR_OWMS_R;

				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				   SET SEGMENT5					= CONVERT(CHAR(8), GETDATE(), 112)
					 , ATTRIBUTE1				= 'Y'
					 , LAST_UPDATED_BY			= @v_batch_user
					 , LAST_UPDATE_DATE			= GETDATE()
				 WHERE 1 = 1
				   AND LOOKUP_TYPE				= 'IF_STOCK_CHECK'
				   AND SEGMENT1					= 'PLAN_AUTO'
				   AND SEGMENT2					= 'OWMS'
				   AND SEGMENT3					= '81_82'
				   AND SEGMENT4					= @company_id
				   AND ATTRIBUTE1				= 'N'
				   ;

				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				   SET SEGMENT5					= CONVERT(CHAR(8), GETDATE(), 112)
					 , ATTRIBUTE1				= 'Y'
					 , LAST_UPDATED_BY			= @v_batch_user
					 , LAST_UPDATE_DATE			= GETDATE()
				 WHERE 1 = 1
				   AND LOOKUP_TYPE				= 'IF_STOCK_CHECK'
				   AND SEGMENT1					= 'PLAN_40'
				   AND SEGMENT2					= 'OWMS'
				   AND SEGMENT3					= '40'
				   AND SEGMENT4					= @company_id
				   AND ATTRIBUTE1				= 'N'
				   ;

			END 

			FETCH NEXT FROM CUR_OWMS_STOCK INTO @stock_cnt, 
											    @company_id,
											    @group_seq

		END ;

		CLOSE CUR_OWMS_STOCK; 
		DEALLOCATE CUR_OWMS_STOCK;

		-- IF data  삭제 (3일 이전 데이터 삭제) 
		DELETE 
		  FROM XIF_OWMS_STOCK_R_SN 
		 WHERE IF_RCV_DATE < GETDATE() - 2
		;


		/*-[C20200601-000370] : SSP_DNM_OWMS_STOCK 테이블 30일 이전 데이터 삭제*/
		DELETE 
		  FROM SSP_DNM_OWMS_STOCK 
		 WHERE CONVERT(char(8), CREATION_DATE, 112) < CONVERT(VARCHAR(8),DATEADD(D,-30,GETDATE()),112) --30일 이전 데이터 삭제  
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

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_OWMS_R')
			BEGIN
				CLOSE CUR_OWMS_R ;
				DEALLOCATE CUR_OWMS_R ;
			END

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
		IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_STOCK_R') IS NOT NULL
			DROP TABLE #tmp_XIF_OWMS_STOCK_R  

		SET @E_TYPE = 'E';
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
	IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_STOCK_R') IS NOT NULL
		DROP TABLE #tmp_XIF_OWMS_STOCK_R  
		
--    return 1  
     SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE;

  END;
