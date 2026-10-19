








/*
 * Program ID   : [NERP_PR_SSP_XIF_OWMS_SHIP_RESULT_R]  
 * Description  : OWMS 출하실적정보 수신 I/F 수신 반영(Every 10 min) 
 * OutTable     : XIF_OWMS_SHIP_RESULT_R_SN --> SSP_DNM_SHIP_RESULT_OWMS 
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.08.21   ayj            OWMS 출하실적정보 수신 I/F 수신 반영
 * 2020.01.13   KIMYONGHO	   OWMS 출하실적정보 수신 반영 로직 변경 (CURSOR 제외)
 * 2020.06.16   LJH	           [PJ20199555]공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 
                               전극 추가 
 * 2021.02.22   kbk            owms i/f 정보의 division을 ssp 사용 division 으로 변경적용하는 로직 추가
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2024.03.20   KHJ			   SAP PO로 변경 / NERP 데이터 변환 로직 추가 / NERP_SSP
 * 2026.05.15	강주용		   [E20260423-001533] PLANT SITE LINK 적용하여 VP Site로 변경
 */

CREATE PROCEDURE [dbo].[NERP_PR_SSP_XIF_OWMS_SHIP_RESULT_R]
	@ZNEIFSSP_00241S		AS DBO.ZNEIFSSP_00241S       READONLY
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_OWMS_SHIP_RESULT_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_SHIP_RESULT_OWMS'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

    DECLARE @TRANSFER_DATE			DATETIME        = GETDATE();    
    DECLARE @TRANSFER_FLAG			NVARCHAR(50)	= 'N';
	DECLARE @XIF_OWMS_SHIP_RESULT_R		TABLE 
	(
		[IF_SEQ] 			[nvarchar](50) NOT NULL,
		[IF_TYPE] 			[nvarchar](1) NOT NULL,
		[IF_ID] 			[nvarchar](50) NOT NULL,
		[IF_RCV_DATE] 		[datetime] NOT NULL,
		[PROC_FLAG] 		[nvarchar](1) NOT NULL,
		[PROC_DATE] 		[datetime] NULL,
		[PROC_MSG] 			[nvarchar](1000) NULL,
		[DIVISION_ID] 		[nvarchar](30) NULL,
		[PLANT_ID] 			[nvarchar](40) NULL,
		[ITEM_ID] 			[nvarchar](20) NULL,
		[CUSTOMER_CODE] 	[nvarchar](40) NULL,
		[PLANT_ISSUE_DATE] 	[nvarchar](8) NULL,
		[DELIVERY_NO] 		[nvarchar](40) NULL,
		[PALLET_ID] 		[nvarchar](50) NULL,
		[LOT_ID] 			[nvarchar](50) NULL,
		[GRADE] 			[nvarchar](40) NULL,
		[STORAGE_ID] 		[nvarchar](40) NULL,
		[LOT_QTY] 			[numeric](20, 3) NULL,
		[SHIP_TYPE] 		[nvarchar](180) NULL,
		[SHIP_STATUS] 		[nvarchar](180) NULL,
		[CAPACITY_GRADE] 	[nvarchar](40) NULL,
		[CREATION_DATE] 	[datetime] NULL,
		[CREATED_BY] 		[nvarchar](150) NULL,
		[LAST_UPDATE_DATE] 	[datetime] NULL,
		[LAST_UPDATED_BY] 	[nvarchar](150) NULL,
		[ATTRIBUTE1] 		[nvarchar](150) NULL,
		[ATTRIBUTE2] 		[nvarchar](150) NULL,
		[ATTRIBUTE3] 		[nvarchar](150) NULL,
		[ATTRIBUTE4] 		[nvarchar](150) NULL,
		[ATTRIBUTE5] 		[nvarchar](150) NULL,
		[ATTRIBUTE6] 		[nvarchar](150) NULL,
		[ATTRIBUTE7] 		[nvarchar](150) NULL,
		[ATTRIBUTE8] 		[nvarchar](150) NULL,
		[ATTRIBUTE9] 		[nvarchar](150) NULL,
		[ATTRIBUTE10] 		[nvarchar](150) NULL
	);


  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_SHIP_RESULT_OWMS INSERT LOGIC';
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

	-- LSP 회신을 위한 변수 선언
    DECLARE @E_TYPE					NVARCHAR(50)	= N'S'; --메시지 유형: S 성공, E 오류
    DECLARE @E_MESSAGE				NVARCHAR(100)	= N'SUCCESS';

	IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_SHIP_RESULT_R') IS NOT NULL
		DROP TABLE #tmp_XIF_OWMS_SHIP_RESULT_R

	CREATE TABLE #tmp_XIF_OWMS_SHIP_RESULT_R (
		[IF_SEQ] [nvarchar](50) NOT NULL,
		[IF_TYPE] [nvarchar](1) NOT NULL,
		[IF_ID] [nvarchar](50) NOT NULL,
		[IF_RCV_DATE] [datetime] NOT NULL,
		[PROC_FLAG] [nvarchar](1) NOT NULL,
		[PROC_DATE] [datetime] NULL,
		[PROC_MSG] [nvarchar](1000) NULL,
		[DIVISION_ID] [nvarchar](30) NULL,
		[PLANT_ID] [nvarchar](40) NULL,
		[ITEM_ID] [nvarchar](20) NULL,
		[CUSTOMER_CODE] [nvarchar](40) NULL,
		[PLANT_ISSUE_DATE] [nvarchar](8) NULL,
		[DELIVERY_NO] [nvarchar](40) NULL,
		[PALLET_ID] [nvarchar](50) NULL,
		[LOT_ID] [nvarchar](50) NULL,
		[GRADE] [nvarchar](40) NULL,
		[STORAGE_ID] [nvarchar](40) NULL,
		[LOT_QTY] [numeric](20, 3) NULL,
		[SHIP_TYPE] [nvarchar](180) NULL,
		[SHIP_STATUS] [nvarchar](180) NULL,
		[CAPACITY_GRADE] [nvarchar](40) NULL,
		[CREATION_DATE] [datetime] NULL,
		[CREATED_BY] [nvarchar](150) NULL,
		[LAST_UPDATE_DATE] [datetime] NULL,
		[LAST_UPDATED_BY] [nvarchar](150) NULL,
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
	-- SAP PO DATA ==> XIF_OWMS_SHIP_RESULT_R_SN으로 INSERT 처리
		INSERT INTO @XIF_OWMS_SHIP_RESULT_R (
			  [IF_SEQ] 			
			, [IF_TYPE] 			
			, [IF_ID] 			
			, [IF_RCV_DATE] 		
			, [PROC_FLAG] 		
			, [PROC_DATE] 		
			, [PROC_MSG] 			
			, [DIVISION_ID] 		
			, [PLANT_ID] 			
			, [ITEM_ID] 			
			, [CUSTOMER_CODE] 	
			, [PLANT_ISSUE_DATE] 	
			, [DELIVERY_NO] 		
			, [PALLET_ID] 		
			, [LOT_ID] 			
			, [GRADE] 			
			, [STORAGE_ID] 		
			, [LOT_QTY] 			
			, [SHIP_TYPE] 		
			, [SHIP_STATUS] 		
			, [CAPACITY_GRADE] 	
			, [CREATION_DATE] 	
			, [CREATED_BY] 		
			, [LAST_UPDATE_DATE] 	
			, [LAST_UPDATED_BY] 	
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
			-- SAP PO 수신예상 목록
			--  IF_SEQ, IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, IF_SND_DATE
			--, DIVISION_ID, PLANT_ID, MATERIAL_ID, CUSTOMER_CODE, PLANT_ISSUE_DATE, DELIVERY_NO, PALLET_ID, LOT_ID, GRADE, STORAGE_ID
			--, LOT_QTY, SHIP_TYPE, SHIP_STATUS, CAPACITY_GRADE, CREATE_DATE, CREATE_PSN, UPDATE_DATE, UPDATE_PSN
			--, ATTR_01, ATTR_02, ATTR_03, ATTR_04, ATTR_05, ATTR_06, ATTR_07, ATTR_08, ATTR_09, ATTR_10
			  [IF_SEQ] 			
			, [IF_TYPE] 			
			, [IF_ID] 			
			, @TRANSFER_DATE		AS IF_RCV_DATE 		
			, @TRANSFER_FLAG		AS PROC_FLAG 		
			, @TRANSFER_DATE		AS PROC_DATE		
			, NULL					AS PROC_MSG 			
			, [DIVISION_ID] 		
			, [PLANT_ID] 			
			, [ITEM_ID] 			
			, [CUSTOMER_CODE] 	
			, [PLANT_ISSUE_DATE] 	
			, [DELIVERY_NO] 		
			, [PALLET_ID] 		
			, [LOT_ID] 			
			, ISNULL(GRADE, '')		AS GRADE  		
			, [STORAGE_ID] 		
			, [LOT_QTY] 			
			, [SHIP_TYPE] 		
			, [SHIP_STATUS] 		
			, ISNULL(CAPACITY_GRADE, '')		AS CAPACITY_GRADE
			, @TRANSFER_DATE					AS CREATION_DATE 	
			, 'NEIF00241_interface'				AS CREATED_BY 		
			, @TRANSFER_DATE					AS LAST_UPDATE_DATE 	
			, 'NEIF00241_interface'				AS LAST_UPDATED_BY 	
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
		FROM @ZNEIFSSP_00241S ;		

		INSERT INTO XIF_OWMS_SHIP_RESULT_R_SN (	  
			  [IF_SEQ] 			
			, [IF_TYPE] 			
			, [IF_ID] 			
			, [IF_RCV_DATE] 		
			, [PROC_FLAG] 		
			, [PROC_DATE] 		
			, [PROC_MSG] 			
			, [DIVISION_ID] 		
			, [PLANT_ID] 			
			, [ITEM_ID] 			
			, [CUSTOMER_CODE] 	
			, [PLANT_ISSUE_DATE] 	
			, [DELIVERY_NO] 		
			, [PALLET_ID] 		
			, [LOT_ID] 			
			, [GRADE] 			
			, [STORAGE_ID] 		
			, [LOT_QTY] 			
			, [SHIP_TYPE] 		
			, [SHIP_STATUS] 		
			, [CAPACITY_GRADE] 	
			, [CREATION_DATE] 	
			, [CREATED_BY] 		
			, [LAST_UPDATE_DATE] 	
			, [LAST_UPDATED_BY] 	
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
			, [DIVISION_ID] 		
			, [PLANT_ID] 			
			, [ITEM_ID] 			
			, [CUSTOMER_CODE] 	
			, [PLANT_ISSUE_DATE] 	
			, [DELIVERY_NO] 		
			, [PALLET_ID] 		
			, [LOT_ID] 			
			, [GRADE] 			
			, [STORAGE_ID] 		
			, [LOT_QTY] 			
			, [SHIP_TYPE] 		
			, [SHIP_STATUS] 		
			, [CAPACITY_GRADE] 	
			, [CREATION_DATE] 	
			, [CREATED_BY] 		
			, [LAST_UPDATE_DATE] 	
			, [LAST_UPDATED_BY] 	
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
		FROM @XIF_OWMS_SHIP_RESULT_R ;


	END

    BEGIN TRY
    BEGIN
		BEGIN TRAN TX_SH

/* INF-R 적용 이전
			INSERT INTO #tmp_XIF_OWMS_SHIP_RESULT_R
					   ([IF_SEQ]
					   ,[IF_TYPE]
					   ,[IF_ID]
					   ,[IF_RCV_DATE]
					   ,[PROC_FLAG]
					   ,[PROC_DATE]
					   ,[PROC_MSG]
					   ,[DIVISION_ID]
					   ,[PLANT_ID]
					   ,[ITEM_ID]
					   ,[CUSTOMER_CODE]
					   ,[PLANT_ISSUE_DATE]
					   ,[DELIVERY_NO]
					   ,[PALLET_ID]
					   ,[LOT_ID]
					   ,[GRADE]
					   ,[STORAGE_ID]
					   ,[LOT_QTY]
					   ,[SHIP_TYPE]
					   ,[SHIP_STATUS]
					   ,[CAPACITY_GRADE]
					   ,[CREATION_DATE]
					   ,[CREATED_BY]
					   ,[LAST_UPDATE_DATE]
					   ,[LAST_UPDATED_BY]
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
				 SELECT
						[IF_SEQ]
					   ,[IF_TYPE]
					   ,[IF_ID]
					   ,[IF_RCV_DATE]
					   ,[PROC_FLAG]
					   ,[PROC_DATE]
					   ,[PROC_MSG]
					   ,[dbo].[FN_GET_SSP_JV_DIVISION_ID](DIVISION_ID, PLANT_ID) AS DIVISION_ID
					   ,[PLANT_ID]
					   ,[ITEM_ID]
					   ,[CUSTOMER_CODE]
					   ,[PLANT_ISSUE_DATE]
					   ,[DELIVERY_NO]
					   ,[PALLET_ID]
					   ,[LOT_ID]
					   ,[GRADE]
					   ,[STORAGE_ID]
					   ,CASE WHEN LOT_QTY < 0 THEN 0 ELSE LOT_QTY END AS LOT_QTY   --C20220401-000487
					   ,[SHIP_TYPE]
					   ,[SHIP_STATUS]
					   ,[CAPACITY_GRADE]
					   ,[CREATION_DATE]
					   ,[CREATED_BY]
					   ,[LAST_UPDATE_DATE]
					   ,[LAST_UPDATED_BY]
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
				   FROM XIF_OWMS_SHIP_RESULT_R_SN WITH(NOLOCK)
				  WHERE ISNULL(PROC_FLAG,'N') = 'N'
				  ;
*/
/* INF-R 적용 이후*/ 
			INSERT INTO #tmp_XIF_OWMS_SHIP_RESULT_R
					   ([IF_SEQ]
					   ,[IF_TYPE]
					   ,[IF_ID]
					   ,[IF_RCV_DATE]
					   ,[PROC_FLAG]
					   ,[PROC_DATE]
					   ,[PROC_MSG]
					   ,[DIVISION_ID]
					   ,[PLANT_ID]
					   ,[ITEM_ID]
					   ,[CUSTOMER_CODE]
					   ,[PLANT_ISSUE_DATE]
					   ,[DELIVERY_NO]
					   ,[PALLET_ID]
					   ,[LOT_ID]
					   ,[GRADE]
					   ,[STORAGE_ID]
					   ,[LOT_QTY]
					   ,[SHIP_TYPE]
					   ,[SHIP_STATUS]
					   ,[CAPACITY_GRADE]
					   ,[CREATION_DATE]
					   ,[CREATED_BY]
					   ,[LAST_UPDATE_DATE]
					   ,[LAST_UPDATED_BY]
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
					SELECT
						[IF_SEQ]
					   ,[IF_TYPE]
					   ,[IF_ID]
					   ,[IF_RCV_DATE]
					   ,[PROC_FLAG]
					   ,[PROC_DATE]
					   ,[PROC_MSG]
					   ,[dbo].[FN_GET_SSP_JV_DIVISION_ID](DIVISION_ID, PLANT_ID) AS DIVISION_ID
					   ,ISNULL(X1.NEW_VALUE1, A.PLANT_ID) AS PLANT_ID
					   ,[ITEM_ID]
					   ,[CUSTOMER_CODE]
					   ,[PLANT_ISSUE_DATE]
					   ,[DELIVERY_NO]
					   ,[PALLET_ID]
					   ,[LOT_ID]
					   ,[GRADE]
					   ,ISNULL(X1.NEW_VALUE2, A.STORAGE_ID) AS STORAGE_ID
					   ,CASE WHEN LOT_QTY < 0 THEN 0 ELSE LOT_QTY END AS LOT_QTY   --C20220401-000487
					   ,[SHIP_TYPE]
					   ,[SHIP_STATUS]
					   ,ISNULL(X2.NEW_VALUE1, A.CAPACITY_GRADE) AS CAPACITY_GRADE
					   ,[CREATION_DATE]
					   ,[CREATED_BY]
					   ,[LAST_UPDATE_DATE]
					   ,[LAST_UPDATED_BY]
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
					FROM XIF_OWMS_SHIP_RESULT_R_SN A WITH(NOLOCK)
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
					WHERE ISNULL(A.PROC_FLAG,'N') = 'N'
				  ;


		MERGE INTO SSP_DNM_SHIP_RESULT_OWMS C
		USING (
			  SELECT SN.DIVISION_ID  AS DIVISION_ID
			  	    ,SN.FROM_SITE AS FROM_SITE
			  	    ,SN.ITEM_ID      AS ITEM_ID
			  	    ,ISNULL((
			  	    		SELECT TOP 1 S.SCM_SITE_ID
			  	    		  FROM SCM_MST_SITE_CUSTOMER S
			  	    		 WHERE S.DIVISION_ID = SN.DIVISION_ID
			  	    		   AND S.REP_YN = 'Y'
			  	    		   AND S.VALID_YN = 'Y'
			  	    		   AND S.SHIPTO_CODE = MAX(SN.CUSTOMER_CODE)		
			  	    	    ),'-') AS TO_SITE
			  	    ,MAX(SN.CUSTOMER_CODE ) AS CUSTOMER_CODE
			  	    ,MAX(SN.PLANT_ISSUE_DATE) AS PLANT_ISSUE_DATE 
			  	    ,MAX(SN.DELIVERY_NO) AS DELIVERY_NO
			  	    ,SN.PALLET_ID AS PALLET_ID
			  	    ,SN.LOT_ID   AS LOT_ID
			  	    ,SN.GRADE AS GRADE
			  	    ,MAX(SN.STORAGE_ID) AS STORAGE_ID
			  	    ,SUM(SN.LOT_QTY) AS  LOT_QTY
			  	    ,MAX(SN.SHIP_TYPE) AS SHIP_TYPE
			  	    ,MAX(SN.SHIP_STATUS) AS SHIP_STATUS
			  	    ,SN.CAPACITY_GRADE AS CAPACITY_GRADE
			  	    ,MAX(SN.CREATION_DATE) AS CREATION_DATE   -- CREATION_DATE OWMS_CREATE DATE
			  	    ,MAX(SN.IF_RCV_DATE) AS IF_RCV_DATE  -- LAST_UPDATE_DATE , 인터페이스 수신 시간  
			  	    ,MAX(SN.IF_ID) AS IF_ID  
			  	    ,MAX(SN.IF_SEQ) AS IF_SEQ -- ATTRIBUTE1
					,MAX(SN.ATTRIBUTE1) AS ATTRIBUTE1
			  	    ,MAX(SN.ATTRIBUTE2) AS ATTRIBUTE2
			  	    ,MAX(SN.ATTRIBUTE3) AS ATTRIBUTE3
			  	    ,MAX(SN.ATTRIBUTE4) AS ATTRIBUTE4
			  	    ,MAX(SN.ATTRIBUTE5) AS ATTRIBUTE5
			  	    ,MAX(SN.ATTRIBUTE6) AS ATTRIBUTE6
			  	    ,MAX(SN.ATTRIBUTE7) AS ATTRIBUTE7
			  	    ,MAX(SN.ATTRIBUTE8) AS ATTRIBUTE8
			  	    ,MAX(SN.ATTRIBUTE9) AS ATTRIBUTE9
			  	    ,MAX(SN.ATTRIBUTE10) AS ATTRIBUTE10
			    FROM (
			              -- 전극의 경우 조립 PLANT에서 출하실적 발생(남경(CNA) 없는 사업부에서 출하실적발생 EX) 82, G451 
			  	     SELECT DISTINCT
			  			    B.DIVISION_ID
                          , X.PLANT_ID 
			  			  , L.SEGMENT3        AS FROM_SITE
			  			  , X.ITEM_ID
			  			  , X.CUSTOMER_CODE
			  			  , X.PLANT_ISSUE_DATE
			  			  , X.DELIVERY_NO
			  			  , X.PALLET_ID
			  			  , X.LOT_ID
			  			  , X.GRADE
			  			  , X.STORAGE_ID
			  			  , X.LOT_QTY
			  			  , X.SHIP_TYPE
			  			  , X.SHIP_STATUS
			  			  , X.CAPACITY_GRADE
			  			  , X.CREATION_DATE
			  			  , X.CREATED_BY
			  			  , X.LAST_UPDATE_DATE
			  			  , X.LAST_UPDATED_BY
			  			  , X.IF_RCV_DATE
			  			  , X.IF_SEQ
			  			  , X.IF_ID
			  			  , X.ATTRIBUTE1
			  			  , X.ATTRIBUTE2
			  			  , X.ATTRIBUTE3
			  			  , X.ATTRIBUTE4
			  			  , X.ATTRIBUTE5
			  			  , X.ATTRIBUTE6
			  			  , X.ATTRIBUTE7
			  			  , X.ATTRIBUTE8
			  			  , X.ATTRIBUTE9
			  			  , X.ATTRIBUTE10
			  		   FROM #tmp_XIF_OWMS_SHIP_RESULT_R AS X WITH(NOLOCK) 
			  			    JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS L WITH(NOLOCK) -- 해당 LOOKUP에 등록된 경우만 실적 적용 
			  		     ON L.LOOKUP_TYPE	= 'ELECTRODE_OWMS_PLANT_MAPPING' 
			  	        AND L.SEGMENT1		= X.DIVISION_ID  -- SEGMENT1: OWMS_DIVISION
			  	        AND L.SEGMENT2		= X.PLANT_ID     -- SEGMENT2: OWMS_PLANT
			  		  	    JOIN SCM_MST_SITE    B WITH(NOLOCK)
			  		     ON L.SEGMENT3		= B.SCM_SITE_ID
			  	      WHERE 1 = 1
			  		    AND X.ATTRIBUTE6 <> '0'
			  		    AND [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID) = 'E' -- 전극 
			  
			  	      UNION ALL 
			  
			  	     SELECT DISTINCT  
						  -- START [E20260423-001533] PLANT SITE LINK 적용하여 VP Site로 변경
						  /* 원본
			  			    B.DIVISION_ID
			  			  , X.PLANT_ID
			  			  , [dbo].[FN_GET_SCM_SITE_ID_PLANT](X.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID)) AS FROM_SITE      
						  */
						    ISNULL(V.DIVISION_ID, B.DIVISION_ID) AS DIVISION_ID,
			  			    ISNULL(V.PLANT_ID, X.PLANT_ID) AS PLANT_ID
			  			  , ISNULL(V.SCM_SITE_ID, [dbo].[FN_GET_SCM_SITE_ID_PLANT](X.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID))) AS FROM_SITE      
						  -- END [E20260423-001533] PLANT SITE LINK 적용하여 VP Site로 변경
			  			  , X.ITEM_ID
			  			  , X.CUSTOMER_CODE
			  			  , X.PLANT_ISSUE_DATE
			  			  , X.DELIVERY_NO
			  			  , X.PALLET_ID
			  			  , X.LOT_ID
			  			  , X.GRADE
			  			  , X.STORAGE_ID
			  			  , X.LOT_QTY
			  			  , X.SHIP_TYPE
			  			  , X.SHIP_STATUS
			  			  , X.CAPACITY_GRADE
			  			  , X.CREATION_DATE
			  			  , X.CREATED_BY
			  			  , X.LAST_UPDATE_DATE
			  			  , X.LAST_UPDATED_BY
			  			  , X.IF_RCV_DATE
			  			  , X.IF_SEQ
			  			  , X.IF_ID
			  			  , X.ATTRIBUTE1
			  			  , X.ATTRIBUTE2
			  			  , X.ATTRIBUTE3
			  			  , X.ATTRIBUTE4
			  			  , X.ATTRIBUTE5
			  			  , X.ATTRIBUTE6
			  			  , X.ATTRIBUTE7
			  			  , X.ATTRIBUTE8
			  			  , X.ATTRIBUTE9
			  			  , X.ATTRIBUTE10
			  		   FROM #tmp_XIF_OWMS_SHIP_RESULT_R AS X WITH(NOLOCK)
			  			    JOIN SCM_MST_SITE AS B WITH(NOLOCK)
			  		     ON [dbo].[FN_GET_SCM_SITE_ID_PLANT](X.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID)) = B.SCM_SITE_ID
						 -- START [E20260423-001533] PLANT SITE LINK 적용하여 VP Site로 변경
						    LEFT OUTER JOIN SCM_MST_SITE AS V WITH(NOLOCK)
						 ON B.SCM_SITE_ID = V.ATTRIBUTE9
						AND X.DIVISION_ID = V.DIVISION_ID
						-- END [E20260423-001533] PLANT SITE LINK 적용하여 VP Site로 변경
			  	      WHERE 1 = 1
			  	        AND X.ATTRIBUTE6 <> '0'
			  	        AND [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID) <> 'E'  -- 전극 아닌경우 
			  	        AND ([dbo].[FN_GET_SCM_SITE_ID_PLANT](X.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](X.DIVISION_ID, X.ITEM_ID))) IS  NOT  NULL
			         ) SN 
			   WHERE 1 = 1
			   GROUP BY   
			  	     SN.DIVISION_ID
			  	   , SN.FROM_SITE
			  	   , SN.ITEM_ID
			       , SN.PALLET_ID
			  	   , SN.LOT_ID
			  	   , SN.GRADE
			  	   , SN.CAPACITY_GRADE
		      ) N
		 ON	C.DIVISION_ID		= N.DIVISION_ID 
		AND C.FROM_SITE			= N.FROM_SITE
		AND C.ITEM_ID			= N.ITEM_ID 
		AND C.PALLET_ID			= N.PALLET_ID
		AND C.LOT_ID			= N.LOT_ID
		AND C.GRADE				= N.GRADE
		AND C.CAPACITY_GRADE	= N.CAPACITY_GRADE

		WHEN MATCHED THEN
			UPDATE
		       SET 
			       --C.DIVISION_ID		= N.DIVISION_ID
		        -- , C.FROM_SITE			= N.FROM_SITE
		        -- , C.ITEM_ID			= N.ITEM_ID
		           C.TO_SITE			= N.TO_SITE
		         , C.CUSTOMER_CODE		= N.CUSTOMER_CODE
		         , C.PLANT_ISSUE_DATE	= N.PLANT_ISSUE_DATE
		         , C.DELIVERY_NO		= N.DELIVERY_NO
		         , C.STORAGE_ID			= N.STORAGE_ID
		         , C.LOT_QTY			= N.LOT_QTY
		         , C.SHIP_TYPE			= N.SHIP_TYPE
		         , C.SHIP_STATUS		= N.SHIP_STATUS
		         , C.CREATION_DATE		= N.CREATION_DATE
		         , C.LAST_UPDATE_DATE	= N.IF_RCV_DATE
		         , C.ATTRIBUTE1			= N.IF_SEQ
				 --, C.ATTRIBUTE2         = 'Entry Date: ' + N.ATTRIBUTE1 
		WHEN NOT MATCHED THEN
			INSERT ( 
			       DIVISION_ID
				 , FROM_SITE
				 , ITEM_ID
				 , TO_SITE
				 , CUSTOMER_CODE
				 , PLANT_ISSUE_DATE
				 , DELIVERY_NO
				 , PALLET_ID
				 , LOT_ID
				 , GRADE
				 , STORAGE_ID
				 , LOT_QTY
				 , SHIP_TYPE
				 , SHIP_STATUS
				 , CAPACITY_GRADE
				 , CREATION_DATE
				 , CREATED_BY
				 , LAST_UPDATE_DATE
				 , LAST_UPDATED_BY
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
				   N.DIVISION_ID
				 , N.FROM_SITE
				 , N.ITEM_ID
				 , N.TO_SITE
				 , N.CUSTOMER_CODE
				 , N.PLANT_ISSUE_DATE
				 , N.DELIVERY_NO
				 , N.PALLET_ID
				 , N.LOT_ID
				 , N.GRADE
				 , N.STORAGE_ID
				 , N.LOT_QTY
				 , N.SHIP_TYPE
				 , N.SHIP_STATUS
				 , N.CAPACITY_GRADE
				 , N.CREATION_DATE   -- CREATION_DATE OWMS_CREATE DATE
				 , N.IF_ID    --CREATED_BY
				 , N.IF_RCV_DATE   -- LAST_UPDATE_DATE , 인터페이스 수신 시간  
				 , N.IF_ID  --LAST_UPDATED_BY
				 , N.IF_SEQ -- ATTRIBUTE1
				 , N.ATTRIBUTE2
				 , N.ATTRIBUTE3
				 , N.ATTRIBUTE4
				 , N.ATTRIBUTE5
				 , N.ATTRIBUTE6
				 , N.ATTRIBUTE7
				 , N.ATTRIBUTE8
				 , N.ATTRIBUTE9
				 , N.ATTRIBUTE10
		 );

		-- 인터페이스 테이블 처리 완료 UPDATE
		UPDATE S 
		   SET S.PROC_FLAG             = 'Y'
		     , S.PROC_DATE             = GETDATE()   
		     , S.PROC_MSG              = 'S'
		FROM XIF_OWMS_SHIP_RESULT_R_SN AS S WITH(NOLOCK)
		     JOIN #tmp_XIF_OWMS_SHIP_RESULT_R AS T
		  ON S.IF_SEQ = T.IF_SEQ
		; 

		-- IF data  삭제 (30일 이전 데이터 삭제) 
		DELETE  
		  FROM XIF_OWMS_SHIP_RESULT_R_SN 
		 WHERE IF_RCV_DATE < GETDATE() - 30
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
		--EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
		--						,@p_log_type      =@v_log_type
		--						,@p_log_count     =@n_log_count 
		--						,@p_log_message   =@v_log_message 
		--						,@p_description   =@v_description 
		--						,@p_event_date    =@d_event_date 
		--						,@p_user_id       =@v_batch_user
		--						;
		IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_SHIP_RESULT_R') IS NOT NULL
			DROP TABLE #tmp_XIF_OWMS_SHIP_RESULT_R

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

	IF OBJECT_ID('tempdb..#tmp_XIF_OWMS_SHIP_RESULT_R') IS NOT NULL
		DROP TABLE #tmp_XIF_OWMS_SHIP_RESULT_R
				
    --return 1  
	SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE 

  END;
