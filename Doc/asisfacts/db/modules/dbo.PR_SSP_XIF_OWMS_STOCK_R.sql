

/*
 * Program ID   : [PR_SSP_XIF_OWMS_STOCK_R]  
 * Description  : OWMS 재고 정보 I/F 수신 반영(Every 5 Min) 
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
 * 2024.02.16   SSP            ATTRIBUTE6 = '0'인건 PROC_FLAG 'Z' 업데이트(임시)
 * 2024.05.21   SSP            G820법인 입고 및 출고 동시 문제로 재고 0 인 상태, 인터페이스 임의 업데이트
 * 2024.06.12   SSP            SSP_ANL_OWMS_STOCK_C2 테이블 3달 이전 데이터 삭제
 * 2024.08.07   SSP            중복 컬럼 SUM 처리
 * 2025.06.28   SSP            G820 -> ST00 위한 하드코딩 처리
 * 20260804		강주용		   [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_OWMS_STOCK_R]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_OWMS_STOCK_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_OWMS_STOCK'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

	-- DECLARE @v_master_if_seq  NVARCHAR(MAX) = '';
	DECLARE @v_count          INT  = 0 ;
	DECLARE @v_cnt            INT  = 0 ;
	DECLARE @v_specify_cnt    INT  = 0 ;

		-- G820 하드코딩 전환
	DECLARE @v_ST00 nvarchar(100) =    dbo.FN_GET_LOOKUP_VALUE('PR_SSP_XIF_OWMS_STOCK_R'  ,'ST_COMPANY' )
    DECLARE @v_ST01 nvarchar(100)  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_XIF_OWMS_STOCK_R'  ,'ST_PLANT_ST01' )

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
		[MASTER_IF_SEQ] [nvarchar](50) NOT NULL,
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

    BEGIN TRY
    BEGIN
        BEGIN TRAN TX_SH

		--*   Custom Code 
		--*===================================================================================================                
		
		SET @v_specify_cnt = 0;

		SELECT @v_specify_cnt = count(*)
		FROM XIF_OWMS_STOCK_R_SN with(nolock)
		WHERE 1=1  AND ITEM_ID IS NULL AND ATTRIBUTE5 =@v_ST00

		IF @v_specify_cnt > 0
			BEGIN
			-- 240521 G820법인 입고 및 출고 동시 문제로 재고 0 인 상태, 인터페이스 임의 업데이트		
				UPDATE XIF_OWMS_STOCK_R_SN
				SET ITEM_ID	= 'AMSTLV590-B1',PALLET_ID = 'R9WMS240206002',
				    STOCK_QTY = 0,AVAILABLE_QTY = 0,NON_QC_QTY = 0,ALLOCATION_QTY = 0,BLOCK_QTY = 0,
				    PACKING_QTY = 0,MOVING_QTY = 0,RCVLOC_QTY = 0,EXPIRATION_QTY = 0,LONG_QTY = 0,					   
				    PROD_GROUP = '81',LOT_ID = '',PLANT_ID = @v_ST01,GRADE = '',PACKING_STATUS = 'PA',
				    STOCK_STATUS = '10',STORAGE_ID = '500R',LOT_DATE = CONVERT(CHAR(8), GETDATE()+1, 112),
				    SOC = '',CAPACITY_GRADE = '',CREATION_DATE = GETDATE()  
				WHERE 1 = 1
					AND ITEM_ID IS NULL
					AND ATTRIBUTE5 = @v_ST00				   		   
					;		
			END

		SET @v_specify_cnt = 0;

		SELECT @v_specify_cnt = count(*)
		FROM XIF_OWMS_STOCK_R_SN with(nolock)
		WHERE 1=1  AND ITEM_ID IS NULL AND ATTRIBUTE5 = 'G870'			

		IF @v_specify_cnt > 0
			BEGIN
			-- 240521 G820법인 입고 및 출고 동시 문제로 재고 0 인 상태, 인터페이스 임의 업데이트		
				UPDATE XIF_OWMS_STOCK_R_SN
				SET ITEM_ID	= 'AMHODNBEV-A1-040',PALLET_ID = 'PPHQ01YB19MD001',
				    STOCK_QTY = 0,AVAILABLE_QTY = 0,NON_QC_QTY = 0,ALLOCATION_QTY = 0,BLOCK_QTY = 0,
				    PACKING_QTY = 0,MOVING_QTY = 0,RCVLOC_QTY = 0,EXPIRATION_QTY = 0,LONG_QTY = 0,					   
				    PROD_GROUP = '81',LOT_ID = '',PLANT_ID = 'G871',GRADE = '',PACKING_STATUS = 'PA',
				    STOCK_STATUS = '00',STORAGE_ID = '5000',LOT_DATE = CONVERT(CHAR(8), GETDATE()+1, 112),
				    SOC = '',CAPACITY_GRADE = '',CREATION_DATE = GETDATE()  
				WHERE 1 = 1
					AND ITEM_ID IS NULL
					AND ATTRIBUTE5 = 'G870'				   		   
					;		
			END

		-- 240525 OWMS측 ITEM_ID 없는 불필요 값 삭제 
		--DELETE FROM XIF_OWMS_STOCK_R_SN WHERE 1=1
		--AND ITEM_ID IS NULL

		--*===================================================================================================

		DECLARE @stock_cnt INTEGER, 
			    @company_id VARCHAR(30),  
				@group_seq VARCHAR(30)

		DECLARE @idx INT     SET     @idx = 0  
 

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
						       A.ATTRIBUTE5
							 , A.MASTER_IF_SEQ
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
											          A.ATTRIBUTE5
								               	    , A.ATTRIBUTE6
								               	    , A.MASTER_IF_SEQ
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
				   FROM XIF_OWMS_STOCK_R_SN WITH(NOLOCK) 
				  WHERE ISNULL(PROC_FLAG,'N')	= 'N' 
				    AND ATTRIBUTE5				= @company_id
				  GROUP BY 
				        MASTER_IF_SEQ
				;

				OPEN CUR_OWMS_R; 

				FETCH NEXT FROM CUR_OWMS_R INTO @master_if_seq

				WHILE(@@FETCH_STATUS = 0) 
				BEGIN

				    DELETE FROM #tmp_XIF_OWMS_STOCK_R

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
						 SELECT MAX([IF_SEQ])         AS IF_SEQ
							   ,[MASTER_IF_SEQ]
							   ,[IF_TYPE]
							   ,[IF_ID]
							   ,MAX([IF_RCV_DATE])    AS IF_RCV_DATE
							   ,[PROC_FLAG]
							   ,[PROC_DATE]
							   ,[PROC_MSG]
							   ,TRIM([ITEM_ID]) AS ITEM_ID
							   ,[PALLET_ID]
							   ,SUM([STOCK_QTY])      AS STOCK_QTY
							   ,SUM([AVAILABLE_QTY])  AS AVAILABLE_QTY
							   ,SUM([NON_QC_QTY])	  AS NON_QC_QTY
							   ,SUM([ALLOCATION_QTY]) AS ALLOCATION_QTY
							   ,SUM([BLOCK_QTY])	  AS BLOCK_QTY
							   ,SUM([PACKING_QTY])	  AS PACKING_QTY
							   ,SUM([MOVING_QTY])	  AS MOVING_QTY
							   ,SUM([RCVLOC_QTY])	  AS RCVLOC_QTY
							   ,SUM([EXPIRATION_QTY]) AS EXPIRATION_QTY
							   ,SUM([LONG_QTY])		  AS LONG_QTY
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
							   ,MAX([CREATION_DATE]) AS CREATION_DATE
							   ,[ATTRIBUTE1]
							   ,[ATTRIBUTE2]
							   ,[ATTRIBUTE3]
							   ,[ATTRIBUTE4]
							   ,[ATTRIBUTE5]
							   ,[ATTRIBUTE6]
							   ,[ATTRIBUTE7]
							   ,[ATTRIBUTE8]
							   ,MAX([ATTRIBUTE9]) AS ATTRIBUTE9 -- 2025 / 09/24 
							   ,[ATTRIBUTE10]
						   FROM [dbo].[XIF_OWMS_STOCK_R_SN] WITH(NOLOCK)
					      WHERE 1 = 1
						    AND ISNULL(PROC_FLAG,'N')	= 'N'
					        AND MASTER_IF_SEQ			= @master_if_seq
							AND ATTRIBUTE5				= @company_id
							--AND STOCK_QTY > 0
							GROUP BY 
							    --[IF_SEQ]
							    [MASTER_IF_SEQ]
							   ,[IF_TYPE]
							   ,[IF_ID]
							    --,[IF_RCV_DATE]
							   ,[PROC_FLAG]
							   ,[PROC_DATE]
							   ,[PROC_MSG]
							   ,[ITEM_ID]
							   ,[PALLET_ID]
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
							    --,[CREATION_DATE]
							   ,[ATTRIBUTE1]
							   ,[ATTRIBUTE2]
							   ,[ATTRIBUTE3]
							   ,[ATTRIBUTE4]
							   ,[ATTRIBUTE5]
							   ,[ATTRIBUTE6]
							   ,[ATTRIBUTE7]
							   ,[ATTRIBUTE8]
							   --,[ATTRIBUTE9] -- 2025/09/24
							   ,[ATTRIBUTE10]

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
							    ,STOCK_QTY -  CASE WHEN PLANT_ID = 'G182' THEN BLOCK_QTY																
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
								-- START [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용
							    -- 원본,PLANT_ID																		AS PLANT_ID
								,ISNULL(V.VP_PLANT_ID, PLANT_ID)												AS PLANT_ID
								-- END [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용
							    ,ISNULL(GRADE, '-') 															AS GRADE
							    ,ISNULL(PACKING_STATUS, '-')													AS PACKING_STATUS
							    ,ISNULL(STOCK_STATUS,'-') 														AS STOCK_STATUS
							    ,ISNULL(STORAGE_ID,'-') 														AS STORAGE_ID
							    ,ISNULL(CUSTOMER_CODE,'-') 														AS CUSTOMER_CODE
							    ,CUSTOMER_NAME																	AS CUSTOMER_NAME
							    ,ISNULL(LOT_DATE,'-')															AS LOT_DATE
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
							-- START [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용 - 82 DIVISION 에 가상플랜트 대상 처리용
						    FROM #tmp_XIF_OWMS_STOCK_R X WITH(NOLOCK) 
							LEFT OUTER JOIN (
											SELECT V.VP_COMPANY_ID, V.VP_DIVISION_ID, V.VP_SITE_ID, V.VP_PLANT_ID, V.VP_SCM_SITE_ID, V.RP_COMPANY_ID, V.RP_DIVISION_ID, V.RP_SITE_ID, V.RP_PLANT_ID, V.RP_SCM_SITE_ID, C.OPERATION_GROUP
											FROM FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP() AS V 
											JOIN SCM_MST_SITE AS C WITH(NOLOCK)
											ON C.DIVISION_ID = V.VP_DIVISION_ID
											AND C.SCM_SITE_ID = V.VP_SCM_SITE_ID
											AND C.SITE_TYPE	= 'PLANT'
											AND C.VALID_YN	= 'Y'
											AND C.COMPANY_ID = V.VP_COMPANY_ID
										) AS V 
							ON V.RP_PLANT_ID	 = PLANT_ID 
							AND V.VP_DIVISION_ID = CASE WHEN DBO.FN_GET_ITEM_OPERATION_GROUP(PROD_GROUP,ITEM_ID) = 'E' THEN 'EE' 
												 ELSE PROD_GROUP 
												 END
							AND V.VP_COMPANY_ID  = @company_id
						   AND V.OPERATION_GROUP = CASE WHEN  STORAGE_ID IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('PR_SSP_PLN_SHIP_PLAN_CUTOFF','AS_STORAGE')) THEN 'W'
																			 ELSE  DBO.FN_GET_ITEM_OPERATION_GROUP(PROD_GROUP, ITEM_ID) END 
							-- END [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용
						   WHERE 1 = 1
						     AND MASTER_IF_SEQ	= @master_if_seq
						     AND ATTRIBUTE5		= @company_id
						     AND ATTRIBUTE6 <> '0'

							 -- START [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용
							UNION ALL
							SELECT X.ATTRIBUTE8																		AS CUTOFF_DATE		--[C20200601-000370] 컬럼추가	
									,V.DIVISION_ID																	AS DIVISION_ID  --EE는 사용되지 않음
									,ITEM_ID 																		AS ITEM_ID
									,ISNULL(PALLET_ID,'-')															AS PALLET_ID
									,STOCK_QTY																		AS STOCK_QTY
									,STOCK_QTY -  CASE WHEN X.PLANT_ID = 'G182' THEN BLOCK_QTY																
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
									,V.PLANT_ID																		AS PLANT_ID
									,ISNULL(GRADE, '-') 															AS GRADE
									,ISNULL(PACKING_STATUS, '-')													AS PACKING_STATUS
									,ISNULL(STOCK_STATUS,'-') 														AS STOCK_STATUS
									,ISNULL(STORAGE_ID,'-') 														AS STORAGE_ID
									,ISNULL(CUSTOMER_CODE,'-') 														AS CUSTOMER_CODE
									,CUSTOMER_NAME																	AS CUSTOMER_NAME
									,ISNULL(LOT_DATE,'-')															AS LOT_DATE
									,ISNULL(SOC, '-') 																AS SOC
									,ISNULL(CAPACITY_GRADE, '-') 													AS CAPACITY_GRADE
									,PROD_GROUP    																	AS ORIGIN_FROM_DIVISION_ID
									,'OWMS I/F'    															   		AS CREATED_BY
									,X.CREATION_DATE 															   		AS CREATION_DATE
									,'OWMS I/F'    															   		AS LAST_UPDATED_BY
									,IF_RCV_DATE    																AS LAST_UPDATE_DATE
									/* [C20200603-000259] 과거 MASTER_IF_SEQ 와 신규 MASTER_IF_SEQ 다르면 삭제 하는 로직이 있었으나 필요없음으로 제외 처리 하고 
							    			OQC Reqno (ATTRIBUTE1)와 Volvo Accu (ATTRIBUTE2) 로 대체
					 		    
									*/
									,X.ATTRIBUTE1	 															   		AS ATTRIBUTE1   
									,X.ATTRIBUTE2																		AS ATTRIBUTE2
									,X.ATTRIBUTE3																		AS ATTRIBUTE3
									,X.ATTRIBUTE4																		AS ATTRIBUTE4
									,X.ATTRIBUTE5																		AS ATTRIBUTE5
									,X.ATTRIBUTE6																		AS ATTRIBUTE6
									,X.ATTRIBUTE7																		AS ATTRIBUTE7
									,X.ATTRIBUTE8																		AS ATTRIBUTE8
									,X.ATTRIBUTE9																		AS ATTRIBUTE9
									,X.ATTRIBUTE10																	AS ATTRIBUTE10
								FROM #tmp_XIF_OWMS_STOCK_R X WITH(NOLOCK) 
								JOIN SCM_MST_SITE					AS C WITH(NOLOCK) 
								ON X.PLANT_ID				= C.PLANT_ID 
								AND X.PROD_GROUP			= C.DIVISION_ID
								AND C.COMPANY_ID  = @company_id
								AND C.SITE_TYPE				= 'PLANT'
								AND C.OPERATION_GROUP = CASE WHEN  X.STORAGE_ID IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('PR_SSP_PLN_SHIP_PLAN_CUTOFF','AS_STORAGE')) THEN 'W'
																					ELSE  DBO.FN_GET_ITEM_OPERATION_GROUP(X.PROD_GROUP, X.ITEM_ID) END 
								INNER JOIN SCM_MST_SITE AS V WITH(NOLOCK)
								ON C.SCM_SITE_ID = V.ATTRIBUTE9
								AND V.SITE_TYPE	= 'PLANT'
								AND V.VALID_YN	= 'Y'
						
								WHERE 1 = 1
								AND MASTER_IF_SEQ	= @master_if_seq
								AND X.ATTRIBUTE5	= @company_id
								AND X.ATTRIBUTE6 <> '0'

						-- END   [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용
						  ) B
					   ON A.CUTOFF_DATE					= B.CUTOFF_DATE
					  AND A.DIVISION_ID					= B.DIVISION_ID
					  AND A.ITEM_ID						= B.ITEM_ID
					  AND A.PLANT_ID					= B.PLANT_ID
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
						 , B.LOT_DATE
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

		/*- SSP_ANL_OWMS_STOCK_C2 테이블 3달 이전 데이터 삭제*/
		--DELETE 
		--  FROM SSP_ANL_OWMS_STOCK_C2 
		-- WHERE CONVERT(char(8), CREATION_DATE, 112) < CONVERT(VARCHAR, DATEADD(M, -3, GETDATE()) ,112) -- 3달 이전 데이터 삭제

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
--      PRINT @@ERROR
		IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_STOCK_R') IS NOT NULL
			DROP TABLE #tmp_XIF_OWMS_STOCK_R  

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
	IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_STOCK_R') IS NOT NULL
		DROP TABLE #tmp_XIF_OWMS_STOCK_R  
		
    return 1  

  END;
