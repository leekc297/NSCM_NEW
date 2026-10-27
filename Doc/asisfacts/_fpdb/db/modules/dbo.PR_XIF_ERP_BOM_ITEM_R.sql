
CREATE PROCEDURE [dbo].[PR_XIF_ERP_BOM_ITEM_R]

-- ================================================================================================
-- Program ID          : FP00520
-- Program Name        : PR_XIF_ERP_BOM_ITEM_R
-- Param               :
-- Batch Period        : realtime
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_BOM_ITEM_R
-- Destination Table   : SCM_BOM_M
--
-- Create(Update) Date : 2016.08.16
--						 2018.10.19 piyong 1.2
--						 2018.10.26 PIYONG 1.3
--						 2022.03.24 kimcd  1.41
--
-- Author              : 김 석
-- Version             : 1.1   kimcd erp bom send to rccp. 2017-01-03
--						 1.2	piyong erp bom send to rccp delete 
--						 1.3	PIYONG 종료일자 생성 로직 추가 
--                       1.4   kimcd BOM 유효기간이 중복되는 현상 발생하여 로직 보완
--                             1. 과거 일자에 수신된 BOM 중 D-1일 수신에서 없는 KEY DATE 정보는 삭제
--                             2. 수신된 BOM 적용 일자가 중복되는 경우 KEY DATE 정렬 순으로 갱신
--                       1.41  kimcd 가상 Divsion 사용에 따른 로직 보완
--                       1.5  FP Pjt. E20240418-001441 update_time 조건 추가
--                       1.6  [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV 셀생산 Real Plant 기준으로 ESS Virtual Plant BOM정보 생성 적용
--                       1.7  yokejacob [E20260928-000093] ERP -> FP BOM 전송 속도 개선 요청건
-- ================================================================================================
	@P_IFSEQNO NVARCHAR(50) = 'NULL'
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_BOM_ITEM_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @COMPANY           NVARCHAR(1000)
	DECLARE @DIVISION          NVARCHAR(1000)
	DECLARE @SITE_ID           NVARCHAR(1000)
	DECLARE @PLANT_ID          NVARCHAR(1000)
	DECLARE @PARENT_ITEM_ID    NVARCHAR(1000)
	DECLARE @BOM_VERSION       NVARCHAR(1000)
	DECLARE @KEYDATE           NVARCHAR(1000)
	DECLARE @PRODUCE_QTY       NUMERIC(13,3)

	DECLARE @PARENT_ITEM_UOM   NVARCHAR(1000)
	DECLARE @BOM_NO            NVARCHAR(1000)
	DECLARE @CHILD_ITEM_ID     NVARCHAR(1000)
	DECLARE @CONSUME_QTY       NUMERIC(13,3)

	DECLARE @CHILD_ITEM_UOM    NVARCHAR(1000)
	DECLARE @ECO_NUMBER        NVARCHAR(1000)
	DECLARE @EFF_START_DATE    NVARCHAR(1000)
	DECLARE @EFF_END_DATE      NVARCHAR(1000)
	DECLARE @ALTERNATE         NVARCHAR(1000)
	DECLARE @ALTERYN           NVARCHAR(1000)
	DECLARE @PRIORITY          NVARCHAR(1000)
	DECLARE @PHANTOM           NVARCHAR(1000)

	DECLARE @RES_COMPANY_ID    NVARCHAR(100)
	DECLARE @RES_DIVISION_ID   NVARCHAR(100)
	DECLARE @RES_PLANT_ID      NVARCHAR(100)
	DECLARE @KEY_DATE_NUM      NUMERIC(10,1)

	-- 중복되는 BOM 체크
	DECLARE @BOM_CNT		   INT = 0;


	DECLARE CUR_ERP_BOM CURSOR FOR
	SELECT BASE.COMPANY
			  ,BASE.DIVISION
			  ,BASE.SITE_ID   
			  ,BASE.PLANT_ID           
			  ,BASE.PARENT_ITEM_ID
			  ,BASE.BOM_VERSION
			  ,BASE.KEYDATE
			  ,BASE.PRODUCE_QTY
			  ,BASE.PARENT_ITEM_UOM
			  ,BASE.BOM_NO
			  ,BASE.CHILD_ITEM_ID
			  ,BASE.CONSUME_QTY
			  ,BASE.CHILD_ITEM_UOM
			  ,BASE.ECO_NUMBER
			  ,BASE.EFF_START_DATE
			  ,BASE.EFF_END_DATE
			  ,BASE.ALTERNATE
			  ,BASE.ALTERYN
			  ,BASE.PRIORITY
			  ,BASE.PHANTOM
		      ,BASE.RES_COMPANY_ID
              ,BASE.RES_DIVISION_ID
	          ,BASE.RES_PLANT_ID
			  ,BASE.KEY_DATE_NUM
	FROM (
		SELECT A.COMPANY
			  --,A.DIVISION
			  ,ISNULL(PD.PSEUDO_DIVISION_ID, A.DIVISION) AS DIVISION -- 2022-03-24 kimcd 가상 Division 로직 추가
			  ,A.SITE_ID   
			  ,A.PLANT_ID           
			  ,A.PARENT_ITEM_ID
			  ,A.BOM_VERSION
			  ,REPLACE(A.KEYDATE,'.','')             AS KEYDATE
			  ,CAST(A.PRODUCE_QTY AS NUMERIC(20,10)) AS PRODUCE_QTY
			  ,A.PARENT_ITEM_UOM                     AS PARENT_ITEM_UOM
			  ,A.BOM_NO                              AS BOM_NO
			  ,A.CHILD_ITEM_ID
			  ,CAST(A.CONSUME_QTY AS NUMERIC(20,10)) AS CONSUME_QTY
			  ,A.CHILD_ITEM_UOM                      AS CHILD_ITEM_UOM
			  ,A.ECO_NUMBER                          AS ECO_NUMBER
			  --,A.EFF_START_DATE
			  ,REPLACE(A.KEYDATE,'.','')             AS EFF_START_DATE
			  ,A.EFF_END_DATE                        AS EFF_END_DATE
			  ,A.ALTERNATE                           AS ALTERNATE
			  ,A.ALTERYN AS ALTERYN
			  ,A.PRIORITY AS PRIORITY
			  ,A.PHANTOM AS PHANTOM
		      ,B.ATTRIBUTE1    AS RES_COMPANY_ID
              ,B.ATTRIBUTE2    AS RES_DIVISION_ID
	          ,B.ATTRIBUTE3    AS RES_PLANT_ID
			  ,ROW_NUMBER() OVER ( PARTITION BY A.COMPANY, A.DIVISION, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID ,A.KEYDATE
			                       ORDER BY A.COMPANY, A.DIVISION, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID ,A.KEYDATE, A.BOM_VERSION, A.CHILD_ITEM_ID, A.CONSUME_QTY )  AS KEY_DATE_NUM
		  FROM [dbo].[SY_XIF_ERP_BOM_ITEM_R] A 
		  LEFT OUTER JOIN DBO.SCM_SYS_LOOKUP_VALUE B 
            ON LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
           AND B.SEGMENT1 = A.PLANT_ID
           AND B.ACTIVE_FLAG = 'Y'
		  LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
            ON PD.PLANT_ID = A.PLANT_ID
		 WHERE TRANSFER_FLAG = 'P'
		   AND A.IFSEQNO = @P_IFSEQNO
		/* blocked by kimcd 2017-03-28
		UNION ALL
		SELECT A.COMPANY
			  ,A.DIVISION
			  ,A.SITE_ID   
			  ,CASE WHEN A.PLANT_ID = 'A010' THEN
						'A011'
					WHEN A.PLANT_ID = 'A040' THEN
						'A041'
					WHEN A.PLANT_ID = 'G182' THEN
						'G183'
					WHEN A.PLANT_ID = 'G382' THEN
						'G383'
					WHEN A.PLANT_ID = 'G451' THEN
						'G452'
			   END      AS PLANT_ID           
			  ,A.PARENT_ITEM_ID
			  ,A.BOM_VERSION
			  ,REPLACE(A.KEYDATE,'.','') AS KEYDATE
			  ,MAX(CAST(A.PRODUCE_QTY AS NUMERIC(20,10))) AS PRODUCE_QTY
			  ,MAX(A.PARENT_ITEM_UOM) AS PARENT_ITEM_UOM
			  ,MAX(A.BOM_NO) AS BOM_NO
			  ,A.CHILD_ITEM_ID
			  ,SUM(CAST(A.CONSUME_QTY AS NUMERIC(20,10))) AS CONSUME_QTY
			  ,MAX(A.CHILD_ITEM_UOM) AS CHILD_ITEM_UOM
			  ,MAX(A.ECO_NUMBER) AS ECO_NUMBER
			  --,A.EFF_START_DATE
			  ,REPLACE(A.KEYDATE,'.','') AS EFF_START_DATE
			  ,MAX(A.EFF_END_DATE) AS EFF_END_DATE
			  ,MAX(A.ALTERNATE) AS ALTERNATE
			  ,MAX(A.ALTERYN) AS ALTERYN
			  ,MAX(A.PRIORITY) AS PRIORITY
			  ,MAX(A.PHANTOM) AS PHANTOM
			  ,B.ATTRIBUTE1    AS RES_COMPANY_ID
              ,B.ATTRIBUTE2    AS RES_DIVISION_ID
			  ,B.ATTRIBUTE3    AS RES_PLANT_ID
		FROM   [dbo].[SY_XIF_ERP_BOM_ITEM_R] A WITH(NOLOCK) LEFT OUTER JOIN
				LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)
				ON  LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
				AND B.SEGMENT1 = CASE WHEN A.PLANT_ID = 'G451' THEN
										  'G452'
								 END
				AND B.ACTIVE_FLAG = 'Y'
		WHERE  TRANSFER_FLAG = 'P'
		AND    IFSEQNO = @P_IFSEQNO
		AND    (A.PARENT_ITEM_ID LIKE 'ASL%'
				OR A.PARENT_ITEM_ID LIKE 'APC%'
				OR A.PARENT_ITEM_ID LIKE 'AEA%')
		AND    A.PLANT_ID IN  ( 'A010','A040','G182','G382','G451')
		AND    GETDATE() < '2017-03-30' 
		GROUP BY A.[COMPANY]
				,A.[DIVISION]
				,A.[SITE_ID]
				,A.[PLANT_ID]
				,A.[PARENT_ITEM_ID]
				,A.[CHILD_ITEM_ID]
				,A.[BOM_VERSION]
				,A.[KEYDATE]
				,B.ATTRIBUTE1
				,B.ATTRIBUTE2
				,B.ATTRIBUTE3
				,A.[IFSEQNO] */ ) BASE
		ORDER BY COMPANY, DIVISION, SITE_ID, PLANT_ID, PARENT_ITEM_ID ,KEYDATE, BOM_VERSION, CHILD_ITEM_ID, CONSUME_QTY
		;

	SET @ROWCOUNT = @@ROWCOUNT

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		
		 UPDATE [dbo].[SY_XIF_ERP_BOM_ITEM_R]
			SET TRANSFER_FLAG = 'P'
			   ,TRANSFER_DATE = GETDATE()
		  WHERE TRANSFER_FLAG = 'N'
		    AND IFSEQNO = @P_IFSEQNO;
		COMMIT TRAN

		/*	--2018-10-19 piyong delete
		BEGIN TRAN
		  -- 2017-01-03 kimcd add start bom toss to rccp
		  INSERT INTO [dbo].[SY_XIF_RCCP_BOM_S]
			 ( [IF_SEQ]
			  ,[IF_TYPE]
			  ,[IF_ID]
			  ,[IF_INS_DATE]
			  ,[IF_FLAG]
			  ,[IF_SND_DATE]
			  ,[IFSEQNO]
			  ,[COMPANY]
			  ,[DIVISION]
			  ,[SITE_ID]
			  ,[PLANT_ID]
			  ,[PARENT_ITEM_ID]
			  ,[BOM_VERSION]
			  ,[KEYDATE]
			  ,[PRODUCE_QTY]
			  ,[PARENT_ITEM_UOM]
			  ,[BOM_NO]
			  ,[CHILD_ITEM_ID]
			  ,[CONSUME_QTY]
			  ,[CHILD_ITEM_UOM]
			  ,[ECO_NUMBER]
			  ,[EFF_START_DATE]
			  ,[EFF_END_DATE]
			  ,[ALTERNATE]
			  ,[ALTERYN]
			  ,[PRIORITY]
			  ,[PHANTOM]
			  ,[CREATE_USER_ID]
			  ,[CREATE_DATE]
			  ,[MODIFY_USER_ID]
			  ,[MODIFY_DATE])
			  SELECT 
				 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_RCCP_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_RCCP_SEND_SEQ] AS NVARCHAR)
				 ,'S'
				 ,'OFP0_ORCP_FP_BOM'
				 ,GETDATE()
				 ,'N'
				 ,NULL 
				 ,[IFSEQNO]
				 ,[COMPANY]
				 ,[DIVISION]
				 ,[SITE_ID]
				 ,[PLANT_ID]
				 ,[PARENT_ITEM_ID]
				 ,[BOM_VERSION]
				 ,[KEYDATE]
				 ,[PRODUCE_QTY]
				 ,[PARENT_ITEM_UOM]
				 ,[BOM_NO]
				 ,[CHILD_ITEM_ID]
				 ,[CONSUME_QTY]
				 ,[CHILD_ITEM_UOM]
				 ,[ECO_NUMBER]
				 ,[EFF_START_DATE]
				 ,[EFF_END_DATE]
				 ,[ALTERNATE]
				 ,[ALTERYN]
				 ,[PRIORITY]
				 ,[PHANTOM]
				 ,[CREATE_USER_ID]
				 ,[CREATE_DATE]
				 ,[MODIFY_USER_ID]
				 ,[MODIFY_DATE]
			 FROM  [dbo].[SY_XIF_ERP_BOM_ITEM_R] WITH(NOLOCK)
			 WHERE TRANSFER_FLAG = 'P'
			  AND IFSEQNO = @P_IFSEQNO;
  		  -- 2017-01-03 kimcd add end
		COMMIT TRAN
		*/

		--########################## Start - [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 성능개선 ################################
		-- [E20260928-000093] ERP -> FP BOM 전송 속도 개선 요청건 성능개선
		--   기존: 커서 루프 내부에서 매 행(최대 16,000회)마다 #RP_VP_SITE_MAP 을 DROP/CREATE/INSERT 반복
		--        -> tempdb 시스템 카탈로그 경합 + 반복 컴파일/통계추정 비용 발생 (성능 저하 주요 원인)
		-- 개선: 이번 배치(@P_IFSEQNO)에 등장하는 distinct PLANT_ID 기준으로 Real/가상 Plant 매핑을 커서 Open 전에 단 1회만 생성.
		--        커서 루프 내부에서는 이 캐시 테이블을 조회만 하도록 변경(생성/삭제 로직 제거)
		IF OBJECT_ID('TEMPDB..#RP_VP_SITE_MAP') IS NOT NULL DROP TABLE #RP_VP_SITE_MAP;

		SELECT RP.COMPANY_ID	AS RP_COMPANY_ID
			  ,RP.DIVISION_ID	AS RP_DIVISION_ID
			  ,RP.SITE_ID		AS RP_SITE_ID
			  ,RP.PLANT_ID		AS RP_PLANT_ID
			  ,VP.COMPANY_ID	AS VP_COMPANY_ID
			  ,VP.DIVISION_ID	AS VP_DIVISION_ID
			  ,VP.SITE_ID		AS VP_SITE_ID
			  ,VP.PLANT_ID		AS VP_PLANT_ID
		 INTO #RP_VP_SITE_MAP
		 FROM SCM_PLANT_M RP WITH(NOLOCK)				-- Real Plant
			  INNER JOIN SCM_PLANT_M  VP WITH(NOLOCK)	-- Virtual Plant
					  ON VP.LINK_PLANT_ID	= RP.PLANT_ID
					 AND VP.PLANT_TYPE		= 'VIRTUAL'
		WHERE RP.PLANT_ID IN ( SELECT DISTINCT A.PLANT_ID		-- 이번 배치에 등장하는 PLANT_ID만 캐시 (전체 SCM_PLANT_M 대상 아님)
									 FROM [dbo].[SY_XIF_ERP_BOM_ITEM_R] A WITH(NOLOCK)
									WHERE A.TRANSFER_FLAG	= 'P'
									  AND A.IFSEQNO		= @P_IFSEQNO )
		;

		-- 루프 내 MERGE가 RB.COMPANY_ID/DIVISION_ID/SITE_ID/PLANT_ID = MP.RP_* 로 조인하므로 해당 컬럼 순서로 인덱스 생성 (Index Seek 유도)
		CREATE CLUSTERED INDEX IX01_RP_VP_SITE_MAP
			ON #RP_VP_SITE_MAP (RP_COMPANY_ID, RP_DIVISION_ID, RP_SITE_ID, RP_PLANT_ID);
		--########################## End - 성능개선 (캐시 테이블 생성) ################################

		BEGIN TRAN
		  -- SITE 정보 추가
		  OPEN CUR_ERP_BOM;
		  FETCH NEXT FROM CUR_ERP_BOM INTO @COMPANY        
										  ,@DIVISION       
										  ,@SITE_ID     
										  ,@PLANT_ID      
										  ,@PARENT_ITEM_ID 
										  ,@BOM_VERSION    
										  ,@KEYDATE        
										  ,@PRODUCE_QTY    
										  ,@PARENT_ITEM_UOM
										  ,@BOM_NO         
										  ,@CHILD_ITEM_ID  
										  ,@CONSUME_QTY    
										  ,@CHILD_ITEM_UOM 
										  ,@ECO_NUMBER     
										  ,@EFF_START_DATE 
										  ,@EFF_END_DATE   
										  ,@ALTERNATE      
										  ,@ALTERYN        
										  ,@PRIORITY       
										  ,@PHANTOM
										  ,@RES_COMPANY_ID
										  ,@RES_DIVISION_ID
										  ,@RES_PLANT_ID
										  ,@KEY_DATE_NUM
										  ;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
  	  
			  IF @RES_PLANT_ID IS NOT NULL

			      BEGIN

		  			  -- BOM Components 삭제 Case가 따로 I/F 되지 않기 때문에 초기에 다 Active Flag를 다 'N'으로 함.
		  			  UPDATE [dbo].[SCM_BOM_FOR_RES_SHARE_M]
		  				 SET ACTIVE_FLAG    = 'N'
						   , UPDATE_ID      = @v_proc_name
              			   , UPDATE_TIME    = GETDATE() 
					   WHERE COMPANY_ID     = @RES_COMPANY_ID
						 AND DIVISION_ID    = @RES_DIVISION_ID
		  				 AND SITE_ID        = @SITE_ID
						 AND PLANT_ID       = @RES_PLANT_ID
		  				 AND PARENT_ITEM_ID = @PARENT_ITEM_ID
		  				 AND KEY_DATE       = @KEYDATE
		  				 AND CHILD_ITEM_ID  = @CHILD_ITEM_ID
						 AND BOM_VERSION_ID = @BOM_VERSION
		  			  ;  
 	   
			  
		  			  -- 과거 정보의 eff end date는 KEYDATE로 update 함.
		  			  UPDATE [dbo].[SCM_BOM_FOR_RES_SHARE_M]
		  				 SET EFF_END_DATE   = CAST(@KEYDATE AS DATETIME)
						   , UPDATE_ID      = @v_proc_name
              			   , UPDATE_TIME    = GETDATE() 
					   WHERE COMPANY_ID     = @RES_COMPANY_ID
						 AND DIVISION_ID    = @RES_DIVISION_ID
		  				 AND SITE_ID        = @SITE_ID
						 AND PLANT_ID       = @RES_PLANT_ID
		  				 AND PARENT_ITEM_ID = @PARENT_ITEM_ID
		  				 AND CHILD_ITEM_ID  = @CHILD_ITEM_ID
						 AND BOM_VERSION_ID = @BOM_VERSION
		  				 AND KEY_DATE       < @KEYDATE -- 2017-02-21 조건 변경
						 AND EFF_END_DATE   > @KEYDATE -- 2017-02-21 조건 변경
		  			  ;

					  IF @KEY_DATE_NUM = 1
					      BEGIN
						      DELETE [dbo].[SCM_BOM_FOR_RES_SHARE_M]
						      WHERE  COMPANY_ID      = @RES_COMPANY_ID
						      AND    DIVISION_ID     = @RES_DIVISION_ID
						      AND    SITE_ID         = @SITE_ID
						      AND    PLANT_ID        = @RES_PLANT_ID
						      AND    PARENT_ITEM_ID  = @PARENT_ITEM_ID
						      AND    KEY_DATE        = @KEYDATE
					      END;			  

					  MERGE INTO [dbo].[SCM_BOM_FOR_RES_SHARE_M] SBM
					  USING ( SELECT @RES_COMPANY_ID   AS COMPANY_ID
              						,@RES_DIVISION_ID  AS DIVISION_ID
              						,@SITE_ID          AS SITE_ID
              						,@RES_PLANT_ID     AS PLANT_ID
              						,@PARENT_ITEM_ID   AS PARENT_ITEM_ID
              						,@CHILD_ITEM_ID    AS CHILD_ITEM_ID
              						,@BOM_VERSION      AS BOM_VERSION_ID
              						,@KEYDATE          AS KEYDATE 
              			) XXX
					  ON (         SBM.COMPANY_ID     = XXX.COMPANY_ID
              				  AND  SBM.DIVISION_ID    = XXX.DIVISION_ID
              				  AND  SBM.SITE_ID        = XXX.SITE_ID
              				  AND  SBM.PLANT_ID       = XXX.PLANT_ID
              				  AND  SBM.PARENT_ITEM_ID = XXX.PARENT_ITEM_ID
              				  AND  SBM.KEY_DATE       = XXX.KEYDATE
              				  AND  SBM.CHILD_ITEM_ID  = XXX.CHILD_ITEM_ID
              				  AND  SBM.BOM_VERSION_ID = XXX.BOM_VERSION_ID
					  )
					  WHEN MATCHED THEN
						  UPDATE SET PARENT_QTY		= CAST(@PRODUCE_QTY AS NUMERIC(20,10))
              						,PARENT_UOM     = @PARENT_ITEM_UOM    
              						,CHILD_QTY      = CHILD_QTY + CAST(@CONSUME_QTY AS NUMERIC(20,10))
              						,CHILD_UOM      = @CHILD_ITEM_UOM        
              						,ALT_ID         = @ALTERNATE     
              						,ALT_PRIORITY   = ( CASE CONVERT(int, @PRIORITY) WHEN 0 THEN NULL ELSE CONVERT(int, @PRIORITY) END )  -- CAST(REPLACE(REPLACE(@PRIORITY,NULL,''),' ' ,'') AS NUMERIC)     
              						,EFF_START_DATE = CAST(@EFF_START_DATE AS DATETIME)
              						,EFF_END_DATE   = CAST(@EFF_END_DATE AS DATETIME) 
              						,ECO_CODE       = @ECO_NUMBER
									,PHANTOM        = @PHANTOM             
              						,ACTIVE_FLAG    = 'Y'      
									,STANDARD_FLAG  = ( CASE @BOM_VERSION WHEN '1' THEN 'Y' ELSE NULL END )
              						,UPDATE_ID      = @v_proc_name
              						,UPDATE_TIME    = GETDATE()     
              		                
					  WHEN NOT MATCHED THEN
              			  INSERT ( COMPANY_ID           
              					  ,DIVISION_ID          
              					  ,SITE_ID         
              					  ,PLANT_ID     
              					  ,PARENT_ITEM_ID       
              					  ,CHILD_ITEM_ID        
              					  ,BOM_VERSION_ID       
              					  ,KEY_DATE             
              					  ,PARENT_QTY           
              					  ,PARENT_UOM           
              					  ,CHILD_QTY            
              					  ,CHILD_UOM            
              					  ,ALT_ID               
              					  ,ALT_PRIORITY         
              					  ,EFF_START_DATE       
              					  ,EFF_END_DATE         
              					  ,ECO_CODE
								  ,PHANTOM             
              					  ,ACTIVE_FLAG 
								  ,STANDARD_FLAG         
              					  ,INSERT_ID            
              					  ,INSERT_TIME          
              					  ,UPDATE_ID            
              					  ,UPDATE_TIME          
              					  )
              			  VALUES ( @RES_COMPANY_ID            
              					  ,@RES_DIVISION_ID                  
              					  ,@SITE_ID  
              					  ,@RES_PLANT_ID            
              					  ,@PARENT_ITEM_ID        
              					  ,@CHILD_ITEM_ID            
              					  ,@BOM_VERSION         
              					  ,@KEYDATE            
              					  ,CAST(@PRODUCE_QTY AS NUMERIC(20,10))
              					  ,@PARENT_ITEM_UOM             
              					  ,CAST(@CONSUME_QTY AS NUMERIC(20,10))
              					  ,@CHILD_ITEM_UOM               
              					  ,@ALTERNATE                  
              					  ,( CASE CONVERT(int, @PRIORITY) WHEN 0 THEN NULL ELSE CONVERT(int, @PRIORITY) END ) --CAST(replace(replace(@PRIORITY,null,''),' ' ,'') AS NUMERIC) 
              					  ,CAST(@EFF_START_DATE AS datetime)
              					  ,CAST(@EFF_END_DATE AS datetime)    
              					  ,@ECO_NUMBER          
								  ,@PHANTOM    
              					  ,'Y'     
								  ,( CASE @BOM_VERSION WHEN '1' THEN 'Y' ELSE NULL END )
              					  ,@v_proc_name         
              					  ,GETDATE()            
              					  ,@v_proc_name       
              					  ,GETDATE()       
              					  );

				  END


		  		-- BOM Components 삭제 Case가 따로 I/F 되지 않기 때문에 초기에 다 Active Flag를 다 'N'으로 함.
		  		UPDATE [dbo].[SCM_BOM_M]
		  		   SET ACTIVE_FLAG    = 'N'
					 , UPDATE_ID      = @v_proc_name
              		 , UPDATE_TIME    = GETDATE()       
				 WHERE COMPANY_ID     = @COMPANY
				   AND DIVISION_ID    = @DIVISION
		  		   AND SITE_ID        = @SITE_ID
				   AND PLANT_ID       = @PLANT_ID
		  		   AND PARENT_ITEM_ID = @PARENT_ITEM_ID
		  		   AND KEY_DATE       = @KEYDATE
		  		   AND CHILD_ITEM_ID  = @CHILD_ITEM_ID
				   AND BOM_VERSION_ID = @BOM_VERSION
		  		;  
 	   
			  
		  		-- 과거 정보의 eff end date는 KEYDATE로 update 함.
		  		UPDATE [dbo].[SCM_BOM_M]
		  		   SET EFF_END_DATE   = CAST(@KEYDATE AS DATETIME)
					 , UPDATE_ID      = @v_proc_name
              		 , UPDATE_TIME    = GETDATE()       
				 WHERE COMPANY_ID     = @COMPANY
				   AND DIVISION_ID    = @DIVISION
		  		   AND SITE_ID        = @SITE_ID
				   AND PLANT_ID       = @PLANT_ID
		  		   AND PARENT_ITEM_ID = @PARENT_ITEM_ID
		  		   AND CHILD_ITEM_ID  = @CHILD_ITEM_ID
				   AND BOM_VERSION_ID = @BOM_VERSION
  				   AND KEY_DATE       < @KEYDATE -- 2017-02-21 조건 변경
				   AND EFF_END_DATE   > @KEYDATE -- 2017-02-21 조건 변경
		  		;

				IF @KEY_DATE_NUM = 1
					BEGIN
						-----------------------------------------------------
						--2018-10-26 PIYONG ADD 종료일자 만들기
						UPDATE [dbo].[SCM_BOM_M]
		  				   SET EFF_END_DATE   = CAST(@KEYDATE AS DATETIME)
					         , UPDATE_ID      = @v_proc_name
              		         , UPDATE_TIME    = GETDATE()  
						 WHERE COMPANY_ID     = @COMPANY
						   AND DIVISION_ID    = @DIVISION
		  				   AND SITE_ID        = @SITE_ID
						   AND PLANT_ID       = @PLANT_ID
		  				   AND PARENT_ITEM_ID = @PARENT_ITEM_ID
						   AND KEY_DATE       < @KEYDATE
						   AND EFF_END_DATE   > @KEYDATE
						--2018-10-26 PIYONG ADD 종료일자 만들기
						-----------------------------------------------------

						DELETE [dbo].[SCM_BOM_M]
						 WHERE COMPANY_ID      = @COMPANY
						   AND DIVISION_ID     = @DIVISION
						   AND SITE_ID         = @SITE_ID
						   AND PLANT_ID        = @PLANT_ID
						   AND PARENT_ITEM_ID  = @PARENT_ITEM_ID
						   AND KEY_DATE        = @KEYDATE
					END;

				MERGE INTO [dbo].[SCM_BOM_M] SBM
				USING ( SELECT @COMPANY          AS COMPANY_ID
              				 , @DIVISION         AS DIVISION_ID
              				 , @SITE_ID          AS SITE_ID
              				 , @PLANT_ID         AS PLANT_ID
              				 , @PARENT_ITEM_ID   AS PARENT_ITEM_ID
              				 , @CHILD_ITEM_ID    AS CHILD_ITEM_ID
              				 , @BOM_VERSION      AS BOM_VERSION_ID
              				 , @KEYDATE          AS KEYDATE 
              	) XXX
				ON (         SBM.COMPANY_ID     = XXX.COMPANY_ID
              			AND  SBM.DIVISION_ID    = XXX.DIVISION_ID
              			AND  SBM.SITE_ID        = XXX.SITE_ID
              			AND  SBM.PLANT_ID       = XXX.PLANT_ID
              			AND  SBM.PARENT_ITEM_ID = XXX.PARENT_ITEM_ID
              			AND  SBM.KEY_DATE       = XXX.KEYDATE
              			AND  SBM.CHILD_ITEM_ID  = XXX.CHILD_ITEM_ID
              			AND  SBM.BOM_VERSION_ID = XXX.BOM_VERSION_ID
				)
				WHEN MATCHED THEN
					UPDATE 
					   SET PARENT_QTY		= CAST(@PRODUCE_QTY AS NUMERIC(20,10))
              			 , PARENT_UOM		= @PARENT_ITEM_UOM    
              			 , CHILD_QTY		= CHILD_QTY + CAST(@CONSUME_QTY AS NUMERIC(20,10))
              			 , CHILD_UOM		= @CHILD_ITEM_UOM        
              			 , ALT_ID			= @ALTERNATE     
              			 , ALT_PRIORITY		= ( CASE CONVERT(int, @PRIORITY) WHEN 0 THEN NULL ELSE CONVERT(int, @PRIORITY) END )  -- CAST(REPLACE(REPLACE(@PRIORITY,NULL,''),' ' ,'') AS NUMERIC)     
              			 , EFF_START_DATE	= CAST(@EFF_START_DATE AS DATETIME)
              			 , EFF_END_DATE		= CAST(@EFF_END_DATE AS DATETIME) 
              			 , ECO_CODE			= @ECO_NUMBER
						 , PHANTOM			= @PHANTOM             
              			 , ACTIVE_FLAG		= 'Y'      
						 , STANDARD_FLAG	= ( CASE @BOM_VERSION WHEN '1' THEN 'Y' ELSE NULL END )
              			 , UPDATE_ID		= @v_proc_name
              			 , UPDATE_TIME		= GETDATE()     
              		                
				WHEN NOT MATCHED THEN
              		INSERT ( COMPANY_ID           
              				,DIVISION_ID          
              				,SITE_ID         
              				,PLANT_ID     
              				,PARENT_ITEM_ID       
              				,CHILD_ITEM_ID        
              				,BOM_VERSION_ID       
              				,KEY_DATE             
              				,PARENT_QTY           
              				,PARENT_UOM           
              				,CHILD_QTY            
              				,CHILD_UOM            
              				,ALT_ID               
              				,ALT_PRIORITY         
              				,EFF_START_DATE       
              				,EFF_END_DATE         
              				,ECO_CODE
							,PHANTOM             
              				,ACTIVE_FLAG 
							,STANDARD_FLAG         
              				,INSERT_ID            
              				,INSERT_TIME          
              				,UPDATE_ID            
              				,UPDATE_TIME          
              				)
              		VALUES ( @COMPANY            
              				,@DIVISION                  
              				,@SITE_ID  
              				,@PLANT_ID            
              				,@PARENT_ITEM_ID        
              				,@CHILD_ITEM_ID            
              				,@BOM_VERSION         
              				,@KEYDATE            
              				,CAST(@PRODUCE_QTY AS NUMERIC(20,10))
              				,@PARENT_ITEM_UOM             
              				,CAST(@CONSUME_QTY AS NUMERIC(20,10))
              				,@CHILD_ITEM_UOM               
              				,@ALTERNATE                  
              				,( CASE CONVERT(int, @PRIORITY) WHEN 0 THEN NULL ELSE CONVERT(int, @PRIORITY) END ) --CAST(replace(replace(@PRIORITY,null,''),' ' ,'') AS NUMERIC) 
              				,CAST(@EFF_START_DATE AS datetime)
              				,CAST(@EFF_END_DATE AS datetime)    
              				,@ECO_NUMBER          
							,@PHANTOM    
              				,'Y'     
							,( CASE @BOM_VERSION WHEN '1' THEN 'Y' ELSE NULL END )
              				,@v_proc_name         
              				,GETDATE()            
              				,@v_proc_name       
              				,GETDATE()       
              				);

			--########################## Start - [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 ################################
			---------------------------------------------------------------------------------------------------------------
			-- // i. Real/가상 Plant매핑 정보 
			-- [E20260928-000093] ERP -> FP BOM 전송 속도 개선 요청건
			-- 성능개선: 커서 Open 전에 배치 전체 distinct PLANT_ID 기준으로 1회만 생성해둔 #RP_VP_SITE_MAP 캐시를 그대로 재사용.
			--                    (기존에 매 행마다 반복하던 DROP/CREATE/INSERT 제거)
			---------------------------------------------------------------------------------------------------------------

			---------------------------------------------------------------------------------------------------------------
			-- // ii. Real plant BOM기준으로 가상 Plant BOM update/insert
			-- PK : PARENT_ITEM_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CHILD_ITEM_ID, BOM_VERSION_ID, KEY_DATE
			---------------------------------------------------------------------------------------------------------------
			MERGE INTO [dbo].[SCM_BOM_M] SBM
			USING ( 
				SELECT DISTINCT
					   MP.VP_COMPANY_ID		AS COMPANY_ID
					 , MP.VP_DIVISION_ID	AS DIVISION_ID
					 , MP.VP_SITE_ID		AS SITE_ID
					 , MP.VP_PLANT_ID		AS PLANT_ID
					 , RB.PARENT_ITEM_ID
					 , RB.CHILD_ITEM_ID
					 , RB.BOM_VERSION_ID
					 , RB.KEY_DATE
					 , RB.BOM_VERSION_LINE
					 , RB.PARENT_QTY
					 , RB.PARENT_UOM
					 , RB.CHILD_QTY
					 , RB.CHILD_UOM
					 , RB.ALT_ID
					 , RB.ALT_PRIORITY
					 , RB.ALT_RATE
					 , RB.EFF_START_DATE
					 , RB.EFF_END_DATE
					 , RB.ECO_CODE
					 , RB.PHANTOM
					 , RB.STANDARD_FLAG
					 , RB.ACTIVE_FLAG
					 , RB.DESCRIPTION
				 FROM SCM_BOM_M RB WITH(NOLOCK)    -- Real plant Data (source) 
					  INNER JOIN #RP_VP_SITE_MAP MP WITH(NOLOCK)
							  ON MP.RP_COMPANY_ID	= RB.COMPANY_ID
							 AND MP.RP_DIVISION_ID	= RB.DIVISION_ID
							 AND MP.RP_SITE_ID		= RB.SITE_ID
							 AND MP.RP_PLANT_ID		= RB.PLANT_ID
				WHERE 1=1 
				  AND RB.PARENT_ITEM_ID	= @PARENT_ITEM_ID
				  AND RB.COMPANY_ID		= @COMPANY
				  AND RB.DIVISION_ID	= @DIVISION
				  AND RB.SITE_ID		= @SITE_ID
				  AND RB.PLANT_ID		= @PLANT_ID
				  AND RB.CHILD_ITEM_ID	= @CHILD_ITEM_ID
				  AND RB.BOM_VERSION_ID = @BOM_VERSION
				  AND RB.KEY_DATE		= @KEYDATE
            ) XXX
			ON (         SBM.COMPANY_ID     = XXX.COMPANY_ID
            		AND  SBM.DIVISION_ID    = XXX.DIVISION_ID
            		AND  SBM.SITE_ID        = XXX.SITE_ID
            		AND  SBM.PLANT_ID       = XXX.PLANT_ID
            		AND  SBM.PARENT_ITEM_ID = XXX.PARENT_ITEM_ID
            		AND  SBM.KEY_DATE       = XXX.KEY_DATE
            		AND  SBM.CHILD_ITEM_ID  = XXX.CHILD_ITEM_ID
            		AND  SBM.BOM_VERSION_ID = XXX.BOM_VERSION_ID
			)
 				WHEN MATCHED THEN
					UPDATE 
					   SET BOM_VERSION_LINE	= XXX.BOM_VERSION_LINE	
						 , PARENT_QTY		= XXX.PARENT_QTY		
						 , PARENT_UOM		= XXX.PARENT_UOM		
						 , CHILD_QTY		= XXX.CHILD_QTY		
						 , CHILD_UOM		= XXX.CHILD_UOM		
						 , ALT_ID			= XXX.ALT_ID			
						 , ALT_PRIORITY		= XXX.ALT_PRIORITY		
						 , ALT_RATE			= XXX.ALT_RATE			
						 , EFF_START_DATE	= XXX.EFF_START_DATE	
						 , EFF_END_DATE		= XXX.EFF_END_DATE		
						 , ECO_CODE			= XXX.ECO_CODE			
						 , PHANTOM			= XXX.PHANTOM			
						 , STANDARD_FLAG	= XXX.STANDARD_FLAG	
						 , ACTIVE_FLAG		= XXX.ACTIVE_FLAG		
						 , DESCRIPTION		= XXX.DESCRIPTION		
              			 , UPDATE_ID		= @v_proc_name
              			 , UPDATE_TIME		= GETDATE()     
              		                
				WHEN NOT MATCHED THEN
              	 INSERT (  COMPANY_ID
						 , DIVISION_ID
						 , SITE_ID
						 , PLANT_ID
						 , PARENT_ITEM_ID
						 , CHILD_ITEM_ID
						 , BOM_VERSION_ID
						 , KEY_DATE
						 , BOM_VERSION_LINE
						 , PARENT_QTY
						 , PARENT_UOM
						 , CHILD_QTY
						 , CHILD_UOM
						 , ALT_ID
						 , ALT_PRIORITY
						 , ALT_RATE
						 , EFF_START_DATE
						 , EFF_END_DATE
						 , ECO_CODE
						 , PHANTOM
						 , STANDARD_FLAG
						 , ACTIVE_FLAG
						 , DESCRIPTION
						 , INSERT_ID
						 , INSERT_TIME
						 , UPDATE_ID
						 , UPDATE_TIME        
              			)
              		VALUES(XXX.COMPANY_ID
						 , XXX.DIVISION_ID
						 , XXX.SITE_ID
						 , XXX.PLANT_ID
						 , XXX.PARENT_ITEM_ID
						 , XXX.CHILD_ITEM_ID
						 , XXX.BOM_VERSION_ID
						 , XXX.KEY_DATE
						 , XXX.BOM_VERSION_LINE
						 , XXX.PARENT_QTY
						 , XXX.PARENT_UOM
						 , XXX.CHILD_QTY
						 , XXX.CHILD_UOM
						 , XXX.ALT_ID
						 , XXX.ALT_PRIORITY
						 , XXX.ALT_RATE
						 , XXX.EFF_START_DATE
						 , XXX.EFF_END_DATE
						 , XXX.ECO_CODE
						 , XXX.PHANTOM
						 , XXX.STANDARD_FLAG
						 , XXX.ACTIVE_FLAG
						 , XXX.DESCRIPTION  
              			 , @v_proc_name         
              			 , GETDATE()            
              			 , @v_proc_name       
              			 , GETDATE()       
              			 );
			--########################## End - [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 ################################
						   	
				FETCH NEXT FROM CUR_ERP_BOM INTO  @COMPANY        
												 ,@DIVISION       
												 ,@SITE_ID      
												 ,@PLANT_ID  
												 ,@PARENT_ITEM_ID 
												 ,@BOM_VERSION    
												 ,@KEYDATE        
												 ,@PRODUCE_QTY    
												 ,@PARENT_ITEM_UOM
												 ,@BOM_NO         
												 ,@CHILD_ITEM_ID  
												 ,@CONSUME_QTY    
												 ,@CHILD_ITEM_UOM 
												 ,@ECO_NUMBER     
												 ,@EFF_START_DATE 
												 ,@EFF_END_DATE   
												 ,@ALTERNATE      
												 ,@ALTERYN        
												 ,@PRIORITY       
												 ,@PHANTOM
											     ,@RES_COMPANY_ID
											     ,@RES_DIVISION_ID
											     ,@RES_PLANT_ID
												 ,@KEY_DATE_NUM
												 ;
		  END;
		  CLOSE CUR_ERP_BOM;
		  DEALLOCATE CUR_ERP_BOM;      

		COMMIT TRAN

		BEGIN TRAN
		 UPDATE [dbo].[SY_XIF_ERP_BOM_ITEM_R]
			SET TRANSFER_FLAG = 'Y'
			   ,TRANSFER_DATE = GETDATE()
		  WHERE TRANSFER_FLAG = 'P'
		    AND IFSEQNO = @P_IFSEQNO  

        COMMIT TRAN

		-- 2019-06-07 kimcd add start
		-- 최근 수신된 BOM의 key date보다 늦은 일자 BOM 중 미수신된 정보는 삭제된 BOM으로 취급하여 FP BOM에서 삭제
		DELETE A
		  FROM SCM_BOM_M A
		 WHERE A.UPDATE_TIME < CONVERT(DATE, GETDATE()-1)
		   AND A.KEY_DATE    > ( SELECT MAX(B.KEY_DATE)
								   FROM SCM_BOM_M B WITH(NOLOCK)
								  WHERE B.PARENT_ITEM_ID	= A.PARENT_ITEM_ID
									AND B.COMPANY_ID		= A.COMPANY_ID
									AND B.DIVISION_ID		= A.DIVISION_ID
									AND B.SITE_ID			= A.SITE_ID
									AND B.PLANT_ID			= A.PLANT_ID
									AND B.INSERT_TIME		>= CONVERT(DATE, GETDATE()-1)
							   )

        -- BOM 형성 작업의 중복 실행등의 문제로 유효 기간이 중복되는 경우 KEY DATE 기준으로 BOM 유효 기간 조정
		UPDATE A 
		   SET A.EFF_END_DATE = (SELECT MIN(B.EFF_START_DATE)
								   FROM SCM_BOM_M B WITH(NOLOCK)
								  WHERE B.PARENT_ITEM_ID	= A.PARENT_ITEM_ID
									AND B.COMPANY_ID		= A.COMPANY_ID
									AND B.DIVISION_ID		= A.DIVISION_ID
									AND B.SITE_ID			= A.SITE_ID
									AND B.PLANT_ID			= A.PLANT_ID
									AND B.KEY_DATE			> A.KEY_DATE
								)
			 , UPDATE_ID      = @v_proc_name
             , UPDATE_TIME    = GETDATE()  
		  FROM SCM_BOM_M A
		 WHERE A.EFF_END_DATE > (SELECT MIN(B.EFF_START_DATE)
								   FROM SCM_BOM_M B WITH(NOLOCK)
								  WHERE B.PARENT_ITEM_ID	= A.PARENT_ITEM_ID
									AND B.COMPANY_ID		= A.COMPANY_ID
									AND B.DIVISION_ID		= A.DIVISION_ID
									AND B.SITE_ID			= A.SITE_ID
									AND B.PLANT_ID			= A.PLANT_ID
									AND B.KEY_DATE			> A.KEY_DATE
								)

		-- 2019-06-07 kimcd add end
		-- ================================================
		-- 로직 추가 end
		-- ================================================

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
		-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리
		IF OBJECT_ID('TEMPDB..#RP_VP_SITE_MAP') IS NOT NULL DROP TABLE #RP_VP_SITE_MAP;

	END TRY

	BEGIN CATCH 
		--[E20260928-000093] ERP -> FP BOM 전송 속도 개선 요청건
		IF CURSOR_STATUS('global','CUR_ERP_BOM') >= -1
		BEGIN
		    CLOSE CUR_ERP_BOM;
            DEALLOCATE CUR_ERP_BOM;   -- 메모리 해제
        END  

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH


END
