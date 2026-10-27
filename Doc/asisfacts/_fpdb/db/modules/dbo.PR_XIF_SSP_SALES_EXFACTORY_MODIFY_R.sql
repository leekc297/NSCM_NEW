
CREATE PROCEDURE [dbo].[PR_XIF_SSP_SALES_EXFACTORY_MODIFY_R]

-- ================================================================================================
-- Program ID          : FP01557
-- Program Name        : PR_XIF_SSP_SALES_EXFACTORY_MODIFY_R
-- Param               :
-- Batch Period        : 10 MINUTE
-- Description         :
--
-- Source System       : SCP
-- Destination System  : FP SDB
-- Source Table        : SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
-- Destination Table   : FP_WEEKLY_DEMAND_SHIPMENT_H
--
-- Create Date		   : 2018.10.04
-- Update Date		   : 2019.07.11
--					   : 2019.10.10
--					   : 2020.07.14	1.4 CYS


-- Author              : PIYONG
-- Version             : 1.0 SSP UI에서 수정한 정보를 FP 출하 계획 정보에 반영
--                       1.1 2019-04-30 kimcd 최종 Plan별 작업 시간 산출하는 로직에서 division 조건 누락되어 추가
--                       1.2 2019-07-11 kimcd 변경 시간 조건을 detail에서 header로 변경
--						 1.3 DIVISION 별 실행에서  PLANT별 실행으로 변경
--						 1.4 2020-07-14 CYS 전극 추가					
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SSP_SALES_EXFACTORY_MODIFY_R'
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
	DECLARE @SHOP_GROUP_ID			NVARCHAR(50)
	DECLARE @DIVISION				NVARCHAR(50)
	DECLARE @START_TIME				DATETIME
	DECLARE @SCP_PLAN_ID			NVARCHAR(30)
	DECLARE @CHANGE_REQ_NO			NVARCHAR(20)
	DECLARE @CONFIRM_ID				NVARCHAR(20)
	DECLARE @NEW_YN					NVARCHAR(1)
	DECLARE @DIVISION_ID			NVARCHAR(30)
	DECLARE @ITEM_ID				NVARCHAR(50)
	DECLARE @FROM_SITE				NVARCHAR(30)
	DECLARE @FROM_SITE_PLANT_ID		NVARCHAR(30)
	DECLARE @TO_SITE				NVARCHAR(30)
	DECLARE @TO_SITE_SOLDTO_CODE	NVARCHAR(30)
	DECLARE @YYYYMMDD				NVARCHAR(8)
	DECLARE @QTY					NUMERIC(20,10)
	DECLARE @BIZ_TYPE				NVARCHAR(30)
	DECLARE @FCST_TYPE				NVARCHAR(30)
	DECLARE @FP_PRODUCTION			NVARCHAR(30)
	DECLARE @ETA_DATE				NVARCHAR(8)
	DECLARE @TRANSPORT_MODE			NVARCHAR(50)
	DECLARE @NEW_YYYYMMDD			NVARCHAR(8)
	DECLARE @NEW_QTY				NUMERIC(20,10)
	DECLARE @NEW_ETA_DATE			NVARCHAR(8)
	DECLARE @NEW_TRANSPORT_MODE		NVARCHAR(50)
	DECLARE @LAST_UPDATE_DATE		DATETIME
	DECLARE @TO_SITE_PLANT_ID       NVARCHAR(30)
	DECLARE @TO_SITE_SHIPTO_CODE    NVARCHAR(30)
	DECLARE @SHIP_TO_PARTY          NVARCHAR(100)
	DECLARE @FP_PLAN_ID				NVARCHAR(30)
	DECLARE @FP_APPLY_YN			NVARCHAR(1)
	DECLARE @FROM_TARGET_ID			NVARCHAR(100)
	DECLARE @TO_TARGET_ID			NVARCHAR(100)
	DECLARE @SCP_TARGET_ID          NVARCHAR(100)
	DECLARE @SHIP_QTY				NUMERIC(20,10)
	DECLARE @MARKET					NVARCHAR(20)
	DECLARE @CHANGE_FLAG			NVARCHAR(1)
	DECLARE @PLANT_ID				NVARCHAR(50)		--2019-10-10 PIYONG ADD
	DECLARE @FACTORY_ID				NVARCHAR(30)		--2020-07-14 CYS v1.4 add
	DECLARE @POST_OPER				NVARCHAR(50)		--2020-07-14 CYS v1.4 add
	DECLARE @REMARKS				NVARCHAR(500)		--2020-07-14 CYS v1.4 add




	DECLARE CUR_DV CURSOR FOR
		SELECT DIVISION_ID
			   ,SHOP_GROUP_ID
			   ,SCP_PLAN_ID
			   ,START_TIME
			   ,PLANT_ID
		  FROM (
				SELECT A.DIVISION_ID
					   ,A.SHOP_GROUP_ID
					   ,A.SCP_PLAN_ID
/*
					   ,(SELECT TOP 1 D.INPUT_START_DATE
						   FROM [LGCE_SCMPROD].[DBO].SCM_MST_PLAN_DETAIL D WITH(NOLOCK),
								[LGCE_SCMDEV].[DBO].SCM_MST_PLAN        P WITH(NOLOCK),
								[LGCE_SCMDEV].[DBO].SCM_MST_MODELING    M WITH(NOLOCK)
						  WHERE 1=1
							AND M.MODELING_ID   = D.MODELING_ID
							AND M.PLAN_CYCLE    = 'DAILY'
							AND M.DIVISION_ID   = D.DIVISION_ID
							AND M.MODELING_ID   = D.MODELING_ID
							AND P.DIVISION_ID   = D.DIVISION_ID
							AND P.PLAN_CYCLE    = M.PLAN_CYCLE
							AND P.PLAN_ID       = D.PLAN_ID
							AND D.PLAN_STATUS   = '1'
							AND D.UI_DISPLAY_YN = 'Y'
							AND D.CONFIRM_FLAG  ='Y'
							AND P.PLAN_NAME     = SUBSTRING(A.SCP_PLAN_ID,1,8)
							AND D.PLAN_SEQ      = CONVERT(NUMERIC(10), SUBSTRING(A.SCP_PLAN_ID,10,3))
							AND P.DIVISION_ID   = A.DIVISION_ID -- 2019-04-30 kimcd 조건 추가
							AND D.PLAN_TYPE     ='SP' ) AS START_TIME
*/
					   ,( SELECT MIN( IF_RCV_DATE )
							FROM [SY_XIF_SSP_SALES_EXFACTORY_R] with(nolock)
						   WHERE PLAN_ID = A.SCP_PLAN_ID
							 AND PLANT_ID = A.PLANT_ID
							 AND OPERATION_GROUP = A.[SHOP_GROUP_ID]
							 --AND DIVISION  = A.[DIVISION_ID] ) AS START_TIME		
							 AND DIVISION  = A.[CHG_DIVISION_ID] ) AS START_TIME	-- 2020-07-14 CYS 전극 치환된 division 1.4 ver change
					   ,PLANT_ID													-- 2019-10-10 PIYONG ADD
				  FROM (
						SELECT CASE WHEN SHOP_GROUP_ID = 'E' THEN 'EE' ELSE [DIVISION_ID] END AS CHG_DIVISION_ID	-- 전극 division 은 EE 로 변경하여 준다. 1.4 ver Change
							   ,DIVISION_ID				-- Cursor 에서 사용하기 위해서 추가  1.4 ver Change
							   ,[SHOP_GROUP_ID]
							   ,MAX([SCP_PLAN_ID]) AS SCP_PLAN_ID
							   ,MAX([INSERT_TIME]) AS INSERRT_TIME
							   ,[PLANT_ID]											-- 2019-10-10 PIYONG ADD
						  FROM [FP_WEEKLY_DEMAND_SHIPMENT_H] WITH(NOLOCK)
						 WHERE SHOP_GROUP_ID IN ('A','P','E')			-- 2020-07-14 CYS 전극 E 추가. 1.4 ver Change
						 GROUP BY [DIVISION_ID]
							   ,[SHOP_GROUP_ID]
							   ,[PLANT_ID]											-- 2019-10-10 PIYONG ADD
					   ) A
			    ) AA
		  WHERE START_TIME IS NOT NULL
		;

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
			OPEN CUR_DV
			FETCH NEXT FROM CUR_DV INTO @DIVISION
									    , @SHOP_GROUP_ID
										, @SCP_PLAN_ID
										, @START_TIME
										, @PLANT_ID
			WHILE @@FETCH_STATUS = 0
			BEGIN
			    SET @CHANGE_FLAG = 'N'

				DECLARE CUR_SHIP_CONFIRM CURSOR FOR
					SELECT D.CHANGE_REQ_NO
						   ,D.CONFIRM_ID
						   ,D.NEW_YN

						   ,H.DIVISION_ID			--
						   ,D.ITEM_ID				--
						   ,D.FROM_SITE
						   --,D.FROM_SITE_PLANT_ID	--	
						   ,@PLANT_ID	AS FROM_SITE_PLANT_ID				-- 2020-07-14 CYS 전극 일 경우 FROM_SITE_PLANT_ID 가 조립 PLANT 가 들어와서 CURSOR 조건을 붙여서 사용
						   ,ISNULL( (SELECT TOP 1 SITE_ID FROM  SCM_SITE_M S WITH(NOLOCK) WHERE S.COMPANY_ID = D.TO_SITE_SOLDTO_CODE), D.TO_SITE) AS TO_SITE --
						   ,D.TO_SITE_SOLDTO_CODE
						   ,D.YYYYMMDD				--
						   ,D.QTY
						   ,D.BIZ_TYPE				-- SHOP GROUP
						   ,D.FCST_TYPE				-- 양산, 테스트
						   ,(SELECT ATTRIBUTE2
							   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
							  WHERE W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
								AND W.ACTIVE_FLAG = 'Y'
								AND W.SEGMENT2 = D.FROM_SITE_PLANT_ID
								AND W.SEGMENT1 = D.FCST_TYPE ) AS FP_PRODUCTION -- FP PRODUCTION TYPE
						   ,D.ETA_DATE				-- 도착 예정일
						   ,D.TRANSPORT_MODE		-- 운송 수단 
						   ,D.NEW_YYYYMMDD
						   ,D.NEW_QTY
						   ,D.NEW_ETA_DATE
						   ,D.NEW_TRANSPORT_MODE
						   ,D.LAST_UPDATE_DATE
						   ,H.DIVISION_ID+'^'+D.ITEM_ID+'^'+D.FROM_SITE+'^'+D.TO_SITE+'^'+D.YYYYMMDD+'^'+D.TRANSPORT_MODE+'^'+D.FCST_TYPE AS FROM_TARGET_ID
						   ,H.DIVISION_ID+'^'+D.ITEM_ID+'^'+D.FROM_SITE+'^'+D.TO_SITE+'^'+D.NEW_YYYYMMDD+'^'+D.NEW_TRANSPORT_MODE+'^'+D.FCST_TYPE AS TO_TARGET_ID
						   ,D.TO_SITE_PLANT_ID
						   ,D.TO_SITE_SHIPTO_CODE
						   ,(SELECT TOP 1 C.SHIPTO_DESCRIPTION
							 FROM   [LGCE_SCMPROD].[DBO].SCM_MST_CUSTOMER C WITH(NOLOCK)
							 WHERE  C.DIVISION_ID = H.DIVISION_ID
							 AND    C.SOLDTO_CODE = D.TO_SITE_SOLDTO_CODE
							 AND    C.SHIPTO_CODE = D.TO_SITE_SHIPTO_CODE ) AS SHIP_TO_PARTY
						   ,D.FP_PLAN_ID
						   ,D.FP_APPLY_YN
						   ,ISNULL(C.FACTORY_ID , M.FACTORY_ID ) AS FACTORY_ID  -- 2020-07-14 CYS 추가 컬럼
						   ,LP.SEGMENT4                          AS POST_OPER   -- 2020-07-14 CYS 추가 컬럼
						   ,C.REMARKS                                           -- 2020-07-14 CYS 추가 컬럼
					 FROM	[LGCE_SCMPROD].[dbo].[SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE] D
							-- 2020-07-14 CYS 전극 부가 정보용 OUTER JOIN 추가 시작
							LEFT OUTER JOIN [LGCE_SCMPROD].[dbo].[SSP_ANL_SHIP_CONFIRM] C WITH(NOLOCK) 
								ON	C.CONFIRM_ID = D.CONFIRM_ID
								AND	C.DIVISION_ID = @DIVISION
								AND	C.BIZ_TYPE	  = 'E'	-- 전극으로 고정함 @SHOP_GROUP_ID 
								AND	C.FROM_SITE	  = @PLANT_ID+'-'+@SHOP_GROUP_ID	-- 전극 일 경우 FROM_SITE_PLANT_ID 가 조립 PLANT 가 들어와서 CURSOR 조건을 붙여서 사용
							LEFT OUTER JOIN [LGCE_SCMPROD].[dbo].[SSP_MST_SHIP_MASTER_EE]  M WITH(NOLOCK) 
								ON M.DIVISION_ID  = C.DIVISION_ID 
								AND M.SCM_SITE_ID = C.FROM_SITE 
								AND M.ITEM_ID     = C.ITEM_ID 
							LEFT OUTER JOIN [LGCE_SCMPROD].[dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] LP WITH(NOLOCK) 
								ON LP.LOOKUP_TYPE = 'ELECTRODE_POST_OPER_CODE' 
								AND LP.SEGMENT1   = M.DIVISION_ID 
								AND LP.SEGMENT2   = M.ELECTRODE_POST_OPER_CODE
							-- 2020-07-14 CYS 전극 부가 정보용 OUTER JOIN 추가 끝
							,[LGCE_SCMPROD].[dbo].[SSP_ANL_SHIP_CONFIRM_CHG_REQ] H
					 WHERE D.CHANGE_REQ_NO = H.CHANGE_REQ_NO
					   AND H.CHANGE_REQ_STATUS = 'A'
					   AND D.VALID_YN = 'Y'
					   -- AND D.LAST_UPDATE_DATE >= @START_TIME -- SSP (엔진 시작 시간) 2019-07-11 kimcd 변경 시간 조건을 detail에서 header로 변경
					   AND H.LAST_UPDATE_DATE >= @START_TIME -- SSP (엔진 시작 시간)  
					   AND H.DIVISION_ID = @DIVISION
					   AND D.BIZ_TYPE = @SHOP_GROUP_ID
					   --AND D.FROM_SITE_PLANT_ID = @PLANT_ID		  -- 2020-07-14 CYS 조건 막음. 2019-10-10 PIYONG ADD
					   AND D.FROM_SITE = @PLANT_ID+'-'+@SHOP_GROUP_ID -- 2020-07-14 CYS 전극 일 경우 FROM_SITE_PLANT_ID 가 조립 PLANT 가 들어와서 CURSOR 조건을 붙여서 사용 1.4 VER 
					ORDER BY H.LAST_UPDATE_DATE -- 2019-07-11 kimcd 변경 시간 조건을 detail에서 header로 변경
				
				OPEN CUR_SHIP_CONFIRM
				FETCH NEXT FROM CUR_SHIP_CONFIRM INTO @CHANGE_REQ_NO
													,@CONFIRM_ID
													,@NEW_YN
													,@DIVISION_ID
													,@ITEM_ID
													,@FROM_SITE
													,@FROM_SITE_PLANT_ID
													,@TO_SITE
													,@TO_SITE_SOLDTO_CODE
													,@YYYYMMDD
													,@QTY
													,@BIZ_TYPE
													,@FCST_TYPE
													,@FP_PRODUCTION
													,@ETA_DATE
													,@TRANSPORT_MODE
													,@NEW_YYYYMMDD
													,@NEW_QTY
													,@NEW_ETA_DATE
													,@NEW_TRANSPORT_MODE
													,@LAST_UPDATE_DATE
													,@FROM_TARGET_ID
													,@TO_TARGET_ID
													,@TO_SITE_PLANT_ID
													,@TO_SITE_SHIPTO_CODE
													,@SHIP_TO_PARTY
													,@FP_PLAN_ID
													,@FP_APPLY_YN
													,@FACTORY_ID  -- 2020-07-14 CYS 추가 컬럼
													,@POST_OPER   -- 2020-07-14 CYS 추가 컬럼
													,@REMARKS     -- 2020-07-14 CYS 추가 컬럼

				WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
					BEGIN						

						IF  (@SCP_PLAN_ID != ISNULL(@FP_PLAN_ID, '-1')) OR ( @SCP_PLAN_ID = @FP_PLAN_ID AND ISNULL(@FP_APPLY_YN, 'N') != 'Y')	--FP에 적용하지 않은 데이터만 

							BEGIN

								SET @CHANGE_FLAG = 'Y'

								IF ISNULL(@QTY, 0 ) > 0				-- 차감
									BEGIN
										DECLARE CUR_WEEK_SHIP CURSOR FOR
											SELECT S.SCP_TARGET_ID
												  ,S.SHIP_QTY
												  ,S.MARKET
											FROM  [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_H] S
											WHERE [DIVISION_ID]     = @DIVISION_ID
											AND   [PLANT_ID]	    = @FROM_SITE_PLANT_ID
											AND   [SHOP_GROUP_ID]   = @BIZ_TYPE
											AND   [SCP_PLAN_ID]     = @SCP_PLAN_ID
											AND   [ITEM_ID]         = @ITEM_ID
											AND   [TO_SITE_ID]      = @TO_SITE
											AND   [SHIP_DATE]       = CONVERT(DATE,@YYYYMMDD,112)
											AND   [TRANSPORT_MODE]  = @TRANSPORT_MODE
											-- AND   [PRODUCTION_TYPE] = @FP_PRODUCTION
											ORDER BY CASE WHEN [PRODUCTION_TYPE] = @FP_PRODUCTION THEN 1 ELSE 2 END
													,[MARKET]
													,[PRODUCTION_TYPE]

										OPEN CUR_WEEK_SHIP
										FETCH NEXT FROM CUR_WEEK_SHIP INTO   @SCP_TARGET_ID
																			,@SHIP_QTY
																			,@MARKET
										WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
											BEGIN			
												IF @SHIP_QTY > @QTY
													BEGIN
														UPDATE [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_H]
														   SET SHIP_QTY = @SHIP_QTY - @QTY
															   ,UPDATE_ID = 'PR_XIF_SSP_SALES_EXFACTORY_MODIFY_R'
															   ,UPDATE_TIME =  GETDATE()
														WHERE [DIVISION_ID]     = @DIVISION_ID
														AND   [PLANT_ID]	    = @FROM_SITE_PLANT_ID
														AND   [SHOP_GROUP_ID]   = @BIZ_TYPE
														AND   [SCP_PLAN_ID]     = @SCP_PLAN_ID
														AND   [ITEM_ID]         = @ITEM_ID
														AND   [TO_SITE_ID]      = @TO_SITE
														AND   [SHIP_DATE]       = CONVERT(DATE,@YYYYMMDD,112)
														AND   [TRANSPORT_MODE]  = @TRANSPORT_MODE
														--AND   [PRODUCTION_TYPE] = @FP_PRODUCTION
														AND   [SCP_TARGET_ID]   = @SCP_TARGET_ID
														SET @QTY = 0;
												    END;
												ELSE
													BEGIN
														SET @QTY = @QTY - @SHIP_QTY;
														UPDATE [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_H]
														   SET SHIP_QTY = 0
															   ,UPDATE_ID = 'PR_XIF_SSP_SALES_EXFACTORY_MODIFY_R'
															   ,UPDATE_TIME =  GETDATE()
														WHERE [DIVISION_ID]     = @DIVISION_ID
														AND   [PLANT_ID]	    = @FROM_SITE_PLANT_ID
														AND   [SHOP_GROUP_ID]   = @BIZ_TYPE
														AND   [SCP_PLAN_ID]     = @SCP_PLAN_ID
														AND   [ITEM_ID]         = @ITEM_ID
														AND   [TO_SITE_ID]      = @TO_SITE
														AND   [SHIP_DATE]       = CONVERT(DATE,@YYYYMMDD,112)
														AND   [TRANSPORT_MODE]  = @TRANSPORT_MODE
														--AND   [PRODUCTION_TYPE] = @FP_PRODUCTION
														AND   [SCP_TARGET_ID]   = @SCP_TARGET_ID
													END;

												FETCH NEXT FROM CUR_WEEK_SHIP INTO   @SCP_TARGET_ID
																					,@SHIP_QTY
																					,@MARKET
											END  -- WHILE @@FETCH_STATUS = 0  CUR_WEEK_SHIP
				
										CLOSE CUR_WEEK_SHIP;
										DEALLOCATE CUR_WEEK_SHIP;   -- 메모리 해제
									END;

								SET @MARKET = CASE WHEN ( SELECT TOP 1 P.SITE_ID
															FROM [DBO].[SCM_PLANT_M] P WITH(NOLOCK)
														   WHERE P.PLANT_ID = @FROM_SITE_PLANT_ID ) in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_SSP_SALES_EXFACTORY_MODIFY_R' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')  THEN
													ISNULL( ( SELECT TOP 1 M.DEFAULT_MARKET
																FROM SCM_MODEL_MARKET_M M WITH(NOLOCK)
																	 ,SCM_PLANT_M P  WITH(NOLOCK)
															   WHERE P.PLANT_ID = @FROM_SITE_PLANT_ID
																 AND M.COMPANY_ID = P.COMPANY_ID
																 AND M.DIVISION_ID = P.DIVISION_ID
																 AND M.SITE_ID = P.SITE_ID
																 AND M.ITEM_ID = @ITEM_ID
																 AND M.PRODUCTION_TYPE = @FP_PRODUCTION
																 AND ISNULL(M.ACTIVE_FLAG,'N') = 'Y'
															), 'E' ) 
												   ELSE
													'E'
												   END


								IF ISNULL(@NEW_QTY, 0 ) > 0
									BEGIN

										MERGE INTO [FP_WEEKLY_DEMAND_SHIPMENT_H] A	-- 누적
										USING (
												SELECT A.COMPANY_ID,
													   A.DIVISION_ID,
													   A.SITE_ID,
													   A.PLANT_ID,
													   @SHOP_GROUP_ID AS SHOP_GROUP_ID,
													   @SCP_PLAN_ID AS SCP_PLAN_ID,
													   @TO_TARGET_ID+'^'+@MARKET AS SCP_TARGET_ID,
													   '-' AS FP_TARGET_ID,
													   @ITEM_ID AS ITEM_ID,
													   @TO_SITE AS TO_SITE_ID,
													   ISNULL(@TO_SITE_PLANT_ID, @FROM_SITE_PLANT_ID) AS TO_PLANT_ID,
													   @TO_SITE_SOLDTO_CODE AS CUSTOMER_ID,
													   CONVERT(DATE, @NEW_YYYYMMDD, 112) AS SHIP_DATE,
													   ( SELECT TOP 1 [ISO_YYYYWW]
														   FROM [DBO].[TH_UIS_CAL] WITH(NOLOCK)
														  WHERE [YYYYMMDD] = @NEW_YYYYMMDD ) AS SHIP_WEEK,
													   @NEW_QTY AS SHIP_QTY,
													   @FP_PRODUCTION AS PRODUCTION_TYPE,
													   @NEW_TRANSPORT_MODE AS TRANSPORT_MODE,
													   NULL AS BIZ_TYPE,
													   NULL AS CONFIRM_TYPE,
													   @MARKET AS MARKET,
													   @NEW_ETA_DATE AS RECEIVE_YYYYMMDD,
													   @SHIP_TO_PARTY AS SHIP_TO_PARTY,
													   @TO_SITE_SHIPTO_CODE AS SHIP_TO_CODE,
													   @FACTORY_ID AS FACTORY_ID, -- 2020-07-14 CYS 추가 컬럼
													   @POST_OPER AS POST_OPER,   -- 2020-07-14 CYS 추가 컬럼
													   @REMARKS AS REMARKS,       -- 2020-07-14 CYS 추가 컬럼
													   'PR_XIF_SSP_SALES_EXFACTORY_MODIFY_R' AS INSERT_ID,
													   GETDATE() AS INSERT_TIME,
													   'PR_XIF_SSP_SALES_EXFACTORY_MODIFY_R' AS UPDATE_ID,
													   GETDATE() AS UPDATE_TIME
												 FROM SCM_PLANT_M A
												WHERE PLANT_ID = @FROM_SITE_PLANT_ID
											  ) B
										   ON ( A.COMPANY_ID = B.COMPANY_ID
												AND A.[DIVISION_ID] = B.DIVISION_ID
												AND A.SITE_ID = B.SITE_ID
												AND A.[PLANT_ID] = B.PLANT_ID
												AND A.[SHOP_GROUP_ID] = B.SHOP_GROUP_ID
												AND A.[SCP_PLAN_ID]	= B.SCP_PLAN_ID
												AND A.[SCP_TARGET_ID] = B.SCP_TARGET_ID
											  )
										 WHEN MATCHED THEN
												UPDATE 
												   SET SHIP_QTY = ISNULL(A.SHIP_QTY,0) + B.SHIP_QTY
													   ,UPDATE_ID = B.UPDATE_ID
													   ,UPDATE_TIME = B.UPDATE_TIME
										 WHEN NOT MATCHED THEN
											INSERT (
													COMPANY_ID
													,DIVISION_ID
													,SITE_ID
													,PLANT_ID
													,SHOP_GROUP_ID
													,SCP_PLAN_ID
													,SCP_TARGET_ID
													,FP_TARGET_ID
													,ITEM_ID
													,TO_SITE_ID
													,TO_PLANT_ID
													,CUSTOMER_ID
													,SHIP_DATE
													,SHIP_WEEK
													,SHIP_QTY
													,PRODUCTION_TYPE
													,TRANSPORT_MODE
													,BIZ_TYPE
													,CONFIRM_TYPE
													,MARKET
													,SHIP_TO_PARTY
													,RECEIVE_YYYYMMDD
													,SHIP_TO_CODE
													,FACTORY_ID -- 2020-07-14 CYS 추가 컬럼
													,POST_OPER  -- 2020-07-14 CYS 추가 컬럼
													,REMARKS    -- 2020-07-14 CYS 추가 컬럼
													,INSERT_ID
													,INSERT_TIME
													,UPDATE_ID
													,UPDATE_TIME
												) VALUES (
													B.COMPANY_ID
													,B.DIVISION_ID
													,B.SITE_ID
													,B.PLANT_ID
													,B.SHOP_GROUP_ID
													,B.SCP_PLAN_ID
													,B.SCP_TARGET_ID
													,B.FP_TARGET_ID
													,B.ITEM_ID
													,B.TO_SITE_ID
													,B.TO_PLANT_ID
													,B.CUSTOMER_ID
													,B.SHIP_DATE
													,B.SHIP_WEEK
													,B.SHIP_QTY
													,B.PRODUCTION_TYPE
													,B.TRANSPORT_MODE
													,B.BIZ_TYPE
													,B.CONFIRM_TYPE
													,B.MARKET
													,B.SHIP_TO_PARTY
													,B.RECEIVE_YYYYMMDD
													,B.SHIP_TO_CODE
													,B.FACTORY_ID -- 2020-07-14 CYS 추가 컬럼
													,B.POST_OPER  -- 2020-07-14 CYS 추가 컬럼
													,B.REMARKS    -- 2020-07-14 CYS 추가 컬럼
													,B.INSERT_ID
													,B.INSERT_TIME
													,B.UPDATE_ID
													,B.UPDATE_TIME
												);

									SET @ROWCOUNT = @@ROWCOUNT

								END
							END


						-- SCP 상태값 변경
						UPDATE [LGCE_SCMPROD].[dbo].[SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE]
						SET    FP_PLAN_ID = @SCP_PLAN_ID
							  ,FP_APPLY_YN = 'Y'
						WHERE  CHANGE_REQ_NO = @CHANGE_REQ_NO
						AND    CONFIRM_ID    = @CONFIRM_ID
						AND    NEW_YN        = @NEW_YN
						;

						FETCH NEXT FROM CUR_SHIP_CONFIRM INTO @CHANGE_REQ_NO
															,@CONFIRM_ID
															,@NEW_YN
															,@DIVISION_ID
															,@ITEM_ID
															,@FROM_SITE
															,@FROM_SITE_PLANT_ID
															,@TO_SITE
															,@TO_SITE_SOLDTO_CODE
															,@YYYYMMDD
															,@QTY
															,@BIZ_TYPE
															,@FCST_TYPE
															,@FP_PRODUCTION
															,@ETA_DATE
															,@TRANSPORT_MODE
															,@NEW_YYYYMMDD
															,@NEW_QTY
															,@NEW_ETA_DATE
															,@NEW_TRANSPORT_MODE
															,@LAST_UPDATE_DATE
															,@FROM_TARGET_ID
															,@TO_TARGET_ID
															,@TO_SITE_PLANT_ID
															,@TO_SITE_SHIPTO_CODE
															,@SHIP_TO_PARTY
															,@FP_PLAN_ID
															,@FP_APPLY_YN
															,@FACTORY_ID -- 2020-07-14 CYS 추가 컬럼
															,@POST_OPER  -- 2020-07-14 CYS 추가 컬럼
															,@REMARKS    -- 2020-07-14 CYS 추가 컬럼

					END  -- WHILE @@FETCH_STATUS = 0  CUR_SHIP_CONFIRM
				
				CLOSE CUR_SHIP_CONFIRM;
				DEALLOCATE CUR_SHIP_CONFIRM;   -- 메모리 해제


				--데이터 변경이 발생하면  MES전송 테이블에서 삭제 추가 로직
				IF ( @CHANGE_FLAG = 'Y')
					BEGIN
						DELETE SY_XIF_MES_EXFACTORY_PLAN_S
						 WHERE PLAN_ID  = @SCP_PLAN_ID
						 AND   PLAN_TYPE = 'SSP'
						 AND   PLANT_ID = @PLANT_ID				-- 2019-10-10 PIYONG CHANGE
/*						
						 AND   PLANT_ID IN (SELECT P.PLANT_ID 
											FROM   SCM_PLANT_M P WITH(NOLOCK)
						                    WHERE  P.DIVISION_ID = @DIVISION)
*/
					END


				FETCH NEXT FROM CUR_DV INTO @DIVISION
											, @SHOP_GROUP_ID
											, @SCP_PLAN_ID
											, @START_TIME
											, @PLANT_ID

			END

			CLOSE CUR_DV;
			DEALLOCATE CUR_DV;   -- 메모리 해


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN
		
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		
		-- cursor 중복 오류로 인해 추가함 1.4 ver add
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_DV')
		BEGIN
			CLOSE CUR_DV
			DEALLOCATE CUR_DV
		END
        -- cursor 중복 오류로 인해 추가함 1.4 ver add
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_SHIP_CONFIRM')
		BEGIN
			CLOSE CUR_SHIP_CONFIRM
			DEALLOCATE CUR_SHIP_CONFIRM
		END

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
