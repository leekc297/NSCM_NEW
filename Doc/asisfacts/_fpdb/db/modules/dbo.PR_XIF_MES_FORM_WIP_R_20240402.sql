

create PROCEDURE [dbo].[PR_XIF_MES_FORM_WIP_R_20240402]

-- ================================================================================================
-- PROGRAM ID          : FP00970
-- PROGRAM NAME        : PR_XIF_MES_FORM_WIP_R
-- PARAM               :
-- BATCH PERIOD        : 1HOUR
-- DESCRIPTION         :
--
-- SOURCE SYSTEM       : ERP
-- DESTINATION SYSTEM  : FP SDB
-- SOURCE TABLE        : SY_XIF_MES_CHAR_AGING_STOCK_R
-- DESTINATION TABLE   : SCM_AGING_STOCK_H
--
-- CREATE DATE		   : 2021.12.03
-- UPDATE DATE		   : 2021.12.03 1.0

-- VERSION             : 1.0
--                       1.0 2021-12-03 kimcd 초기 형성
--                       1.1 6A04 활성화 MES 전환에 따른 삭제로직 조건 추가
--                       1.2 FP Pjt. E20230829-000542 / attr_01 -> production_type 적용
--                       1.3 2024.02.01 E20240122-000168 / ATTR_01 != 'X' 조건 추가 (X: 시생산 Pilot Lot)
-- ================================================================================================
-- PARAMETER
@P_SITE_ID NVARCHAR(50) = 'NULL',
@P_IF_ID NVARCHAR(50) = 'NULL'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG
	DECLARE @V_PROC_NAME NVARCHAR(100) = 'PR_XIF_MES_FORM_WIP_R'
	DECLARE @V_DESCR     NVARCHAR(250)
	DECLARE @V_COUNT     INTEGER	  = 0
	DECLARE @SYSDATE     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @V_TEMP1     NVARCHAR(1000)
	DECLARE @V_TEMP2     NVARCHAR(1000)

	-- ================================================
    -- DECLARE START
	-- ================================================
	DECLARE @IF_ID        NVARCHAR(50)
	DECLARE @ACCUM_DATE   NVARCHAR(50)
    DECLARE @SITE_ID      NVARCHAR(50)

	DECLARE CUR_IF_FORM_WIP CURSOR FOR
		SELECT IF_ID, ACCUM_DATE , ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z (NOLOCK) WHERE Z.FACTORY_ID = MAX(R.FACTORY_ID) ) SITE_ID
          FROM [SY_XIF_MES_CHAR_AGING_STOCK_R] R
         WHERE 1=1
           AND PROC_FLAG = 'N'
		   AND IF_ID  = ( CASE WHEN @P_IF_ID = 'NULL' OR @P_IF_ID IS NULL THEN IF_ID  ELSE @P_IF_ID END)
         GROUP BY IF_ID, ACCUM_DATE
        HAVING ( COUNT(1) = MAX(ACCUM_COUNT) -- 전체를 수신받지 못한 경우에는 처리하지 않음.
		         OR ( COUNT(1) = 1 AND MAX(ACCUM_COUNT) = 0 ) )
         ORDER BY IF_ID, ACCUM_DATE
		 ;

	-- ================================================
    -- DECLARE END
	-- ================================================

	SET @V_TEMP1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @V_TEMP2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- START
	EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START', NULL, @V_TEMP1, '############### START OF PROCEDURE ###############', NULL, @SYSDATE

	BEGIN TRY

		OPEN CUR_IF_FORM_WIP;
		FETCH NEXT FROM CUR_IF_FORM_WIP INTO @IF_ID        
											,@ACCUM_DATE
											,@SITE_ID	

		WHILE (@@FETCH_STATUS = 0)
			BEGIN
			BEGIN TRAN
				IF ( @P_SITE_ID != 'NULL' AND @P_SITE_ID IS NOT NULL AND @SITE_ID = @P_SITE_ID ) OR (@P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL)			
					BEGIN
						UPDATE [dbo].[SY_XIF_MES_CHAR_AGING_STOCK_R]
						SET    PROC_FLAG = 'P'
							  ,PROC_DATE = GETDATE()
						WHERE  PROC_FLAG  = 'N'
						AND    IF_ID      = @IF_ID
						AND    ACCUM_DATE = @ACCUM_DATE;

						IF OBJECT_ID('tempdb..#TEMP_INVENTORY') IS NOT NULL
							DROP TABLE #TEMP_INVENTORY

						IF OBJECT_ID('tempdb..#TEMP_FCS_INVENTORY') IS NOT NULL
							DROP TABLE #TEMP_FCS_INVENTORY

						IF OBJECT_ID('tempdb..#TEMP_OP_START_TIME') IS NOT NULL
							DROP TABLE #TEMP_OP_START_TIME

						IF OBJECT_ID('tempdb..#TEMP_FCS_FACTORY') IS NOT NULL
							DROP TABLE #TEMP_FCS_FACTORY

						SELECT DISTINCT FACTORY_ID
						INTO   #TEMP_FCS_FACTORY
						FROM   [dbo].[SY_XIF_MES_CHAR_AGING_STOCK_R]
						WHERE  IF_ID      = @IF_ID
						AND    ACCUM_DATE = @ACCUM_DATE;

						WITH AGING_ITEM_FLOW_M AS (SELECT *
													 FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
													WHERE SITE_ID    = @SITE_ID
													  AND FACTORY_ID IN ( SELECT FACTORY_ID
																		  FROM   #TEMP_FCS_FACTORY )
													)
						SELECT REMAIN_DAYS
      							,COMPANY_ID
								,DIVISION_ID
								,SITE_ID
								,PLANT_ID
								,FACTORY_ID
								,ROUTE_ID
								,LINE_ID
								,WORKDATE
      							,ITEM_ID
      							,INPUT_CELL_CNT
      							,NOW_CELL_CNT
      							,OP_ID
      							,OP_SEQ
      							,OP_START_TIME
								,DATEADD(MINUTE, REMAIN_DAYS, OP_START_TIME ) AS AVAILABLE_DATE
      							,TRAY_OP_STATUS
								,TRAY_ID
								,STOCK_TYPE
								,WIPHOLD_YN
								,UNHOLD_EXP_DATE
								,SPECIAL_YN
								,LOT_ID
								,BEFORE_DEGAS
								,REMAIN_TIME
								,DEGAS_END_DATE
								,CEILING ( COUNT(LINE_ID) OVER( PARTITION BY PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, ROUTE_ID, LOT_ID, BEFORE_DEGAS )  
											*
											ISNULL (LV.RATE, 1)
																																						) AS BASE_RATE_CNT
								,APPLY_YN				-- 2018-11-29 PIYONG ADD
								,LV.START_TIME          -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분하는 경우 시업 시간 설정
							    ,LOT_TYPE
						INTO #TEMP_INVENTORY
						FROM (
								SELECT ISNULL( X.REMAIN_TIME,0) + ISNULL( X.ROUTE_TOTAL_TIME,0) AS REMAIN_DAYS		--2018-08-13 PIYONG CHANGE
      									, A.COMPANY_ID
										, A.DIVISION_ID
										, A.SITE_ID
										, A.PLANT    AS PLANT_ID
										, A.BUILDING AS FACTORY_ID
										, A.ROUTE_ID
										, A.LINE_ID
										,CONVERT( DATETIME,  A.WORKDATE) AS WORKDATE
      									,A.ITEM_ID
      									,A.INPUT_CELL_CNT
      									,A.NOW_CELL_CNT
      									,'EA' UOM
      									,A.OP_ID
      									,A.OP_SEQ
      									,A.OP_START_TIME                 AS OP_START_TIME
      									,A.TRAY_OP_STATUS
										,A.TRAY_ID
										,A.STOCK_TYPE												-- 2018-04-18 PIYONG ADD
										,A.WIPHOLD_YN												-- 2018-04-18 PIYONG ADD
										,A.UNHOLD_EXP_DATE											-- 2018-04-18 PIYONG ADD
										,A.SPECIAL_YN												-- 2018-04-18 PIYONG ADD
										,A.LOT_ID													-- 2018-04-18 PIYONG ADD
										,CASE WHEN X.DEFAULT_FLAG	= 'B' THEN 'Y' ELSE 'N' END AS BEFORE_DEGAS								-- 2018-08-13 PIYONG ADD
										,ISNULL( X.REMAIN_TIME, 0 ) AS REMAIN_TIME											-- 2018-08-13 PIYONG ADD
										,CASE WHEN X.DEFAULT_FLAG	= 'B' THEN 
												DATEADD(MINUTE, ISNULL( X.REMAIN_TIME , 0),	A.OP_START_TIME )
												ELSE NULL END										 AS DEGAS_END_DATE							-- 2018-08-13 PIYONG ADD
										,ISNULL( (SELECT ATTRIBUTE5
													FROM SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK)
													WHERE LV.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
														AND SEGMENT1 = X.ROUTE_TYPE ), 'Y' ) AS APPLY_YN										-- 2018-11-29 PIYONG ADD
									    ,A.LOT_TYPE
								  FROM (
										SELECT    XFI.COMPANY_ID
												, XFI.SITE_ID
												, XFI.DIVISION_ID
											    , XFI.PLANT
												, XFI.BUILDING
												, XFI.WORKDATE
												, ISNULL(XFI.ROUTE_ID, SIF.ROUTE_ID) AS ROUTE_ID	--2018-04-18 PIYONG 변경
												, ISNULL(XFI.LINE_ID, SIF.LINE_ID) AS LINE_ID		--2018-04-18 PIYONG 변경
												, ISNULL(XFI.OP_ID, SIF.[OPERATION_ID]) AS OP_ID	--2018-04-18 PIYONG 변경
												, ISNULL(XFI.OP_SEQ, SIF.[OPERATION_SEQ]) AS OP_SEQ	--2018-04-18 PIYONG 변경
												, XFI.ITEM_ID
												, ISNULL(XFI.TRAY_OP_STATUS, 'S') AS TRAY_OP_STATUS	--2018-04-18 PIYONG 변경
												, XFI.OP_START_TIME
												, XFI.INPUT_CELL_CNT
												, XFI.NOW_CELL_CNT
												, XFI.TRAY_ID
												, XFI.STOCK_TYPE									-- 2018-04-18 PIYONG ADD
												, XFI.WIPHOLD_YN									-- 2018-04-18 PIYONG ADD
												, XFI.UNHOLD_EXP_DATE								-- 2018-04-18 PIYONG ADD
												, XFI.SPECIAL_YN									-- 2018-04-18 PIYONG ADD
												, XFI.LOT_ID										-- 2018-04-18 PIYONG ADD
												, XFI.LOT_TYPE
										  FROM (
  												SELECT    B.COMPANY_ID
													    , B.SITE_ID
													    , B.DIVISION_ID
														, B.PLANT_ID AS PLANT
														, B.FACTORY_ID AS BUILDING
														, WORKDATE
														, ROUTE_ID
														, LINE_ID
														, OP_ID
														, OP_SEQ
														, ITEM_ID
														, TRAY_OP_STATUS
														, OP_START_TIME
   														, STOCK_TYPE
														, WIPHOLD_YN
														, UNHOLD_EXP_DATE
														, SPECIAL_YN
														, LOT_ID
														, INPUT_CELL_CNT
														, NOW_CELL_CNT
														, TRAY_ID
														, A.LOT_TYPE
												  FROM (
														SELECT WORKDATE
																,A.FACTORY_ID AS BUILDING 
																,ROUTE_ID
																,ISNULL(LM.[LINE_ID], A.LINE_ID )  AS LINE_ID
																,OP_ID
																,OP_SEQ
																,ITEM_ID
																,TRAY_OP_STATUS
																,OP_START_TIME 
   																,STOCK_TYPE
																,WIPHOLD_YN
																,UNHOLD_EXP_DATE
																,SPECIAL_YN
																,LOT_ID
																,INPUT_CELL_CNT
																,NOW_CELL_CNT
																,TRAY_ID
																,A.LOT_TYPE
														   FROM ( 
																	SELECT   @SITE_ID         AS SITE_ID
																			,ACCUM_DATE       AS WORKDATE
																			,FACTORY_ID
																			,ROUTE_ID
																			,LINE_ID
																			,OPERATION_ID     AS OP_ID
																			,OPERATION_SEQ    AS OP_SEQ
																			,ITEM_ID
																			,TRAY_OP_STATUS
																			,OP_START_TIME
   																			,'FCS'            AS STOCK_TYPE
																			,CASE WHEN A.SPECIAL_CD IN ('1','2','3','4','5','6','7') THEN 'Y' ELSE HOLD_YN END AS WIPHOLD_YN
																			,CASE WHEN A.SPECIAL_CD IN ('1','2','3','4','5','6','7') AND A.SPECIAL_RELEASE_DATE IS NOT NULL THEN
																			     CASE WHEN SPECIAL_RELEASE_DATE < REL_DUE_DATE THEN
																				     REL_DUE_DATE
																				 ELSE SPECIAL_RELEASE_DATE END
																			 ELSE REL_DUE_DATE END AS UNHOLD_EXP_DATE
																			,CASE WHEN A.SPECIAL_CD IN ('1','2','3','4','5','6','7')  THEN A.SPECIAL_CD ELSE SPECIAL_YN END SPECIAL_YN
																			,LOT_ID
																			,IN_CELL_CNT      AS INPUT_CELL_CNT
																			,QTY              AS NOW_CELL_CNT
																			,TRAY_ID
																			,ATTR_01          AS LOT_TYPE       
																	  FROM SY_XIF_MES_CHAR_AGING_STOCK_R AS A	-- WITH(NOLOCK)
																	 WHERE PROC_FLAG  = 'P'
																	AND    IF_ID      = @IF_ID
																	AND    ACCUM_DATE = @ACCUM_DATE
																	AND ATTR_01 != 'X'  --E20240122-000168
																) A
																LEFT OUTER JOIN (	SELECT *				--2018-06-08 PIYONG LEFT OUTER JOIN 으로 변경
																					FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																					WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
																					AND ACTIVE_FLAG = 'Y'
																				) SSLV
																			 ON A.LINE_ID = SSLV.SEGMENT2
																			AND A.SITE_ID = SSLV.SEGMENT1
																			AND A.FACTORY_ID = ISNULL( SSLV.ATTRIBUTE2, SSLV.ATTRIBUTE1) -- 2021-08-10 kimcd 라인 조건 변경 - 재고용 동 우선  사용
																LEFT OUTER JOIN SCM_LINE_M LM
																			 ON SSLV.SEGMENT5   = LM.LINE_ID
																			AND SSLV.SEGMENT1   = LM.SITE_ID
																			AND LM.OPERATION_ID IN ( 'F5300','F5500','F5600','F6000')
													   ) A
													   ,SCM_FACTORY_M B
												 WHERE A.BUILDING  = B.FACTORY_ID
																			
											   ) XFI
											   LEFT OUTER JOIN (	--2018-12-06 PIYONG INNERJOIN 에서 LEFT OUTER JOIN으로 변경
																SELECT [DIVISION_ID]
																		,[PLANT_ID]
																		,[FACTORY_ID]
																		,[ITEM_ID]
																		,[ROUTE_ID]
																		,[LINE_ID]
																		,[OPERATION_ID]
																		,[OPERATION_SEQ]
																  FROM (
																		SELECT [DIVISION_ID]
																				,[PLANT_ID]
																				,[FACTORY_ID]
																				,[ITEM_ID]
																				,[ROUTE_ID]
																				,[LINE_ID]
																				,[OPERATION_ID]
																				,[OPERATION_SEQ]
																				,ROW_NUMBER() OVER(PARTITION BY [COMPANY_ID], [DIVISION_ID], [PLANT_ID], [FACTORY_ID], [ITEM_ID]	-- PLANT, 동, ITEM 별 처음 공정 조회
																									   ORDER BY [OPERATION_SEQ], [OPERATION_STEP]) AS NUM
																		  FROM (
																				SELECT *
																					FROM [DBO].[SCM_AGING_ITEM_FLOW_M] A
																						---------------------------------------------------------------
																						-- 2020-02-10 PIYONG ADD
																						  INNER JOIN (
																										SELECT SEGMENT1 , SEGMENT2
																											FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																											WHERE LOOKUP_TYPE_CODE = 'FORMATION_MAGAZINE_STOCK'
																											AND ACTIVE_FLAG = 'Y'
																									) SSLV
																									ON A.SITE_ID = SSLV.SEGMENT1
																								AND A.FACTORY_ID = SSLV.SEGMENT2
																						-- 2020-02-10 PIYONG ADD END
																						--------------------------------------------------------------------------------------------
																				 WHERE ROUTE_TYPE = 'D'
																				   AND SITE_ID = @SITE_ID
																				   AND FACTORY_ID IN  ( SELECT FACTORY_ID
																										FROM   #TEMP_FCS_FACTORY )
																			   ) A
																	   ) A
																 WHERE NUM = 1
															   ) SIF
												--2018-04-18 PIYONG ADD  끝
															ON XFI.DIVISION_ID = SIF.DIVISION_ID
														   AND XFI.PLANT = SIF.PLANT_ID
														   AND XFI.BUILDING = SIF.FACTORY_ID
														   AND XFI.ITEM_ID =SIF.ITEM_ID
      								   ) A
										--2018-08-13 PIYONG ADD
									   LEFT OUTER JOIN AGING_ITEM_FLOW_M X
													ON X.FACTORY_ID = A.BUILDING
												   AND X.ITEM_ID    = A.ITEM_ID
      											   AND X.ROUTE_ID   = A.ROUTE_ID
												   AND X.LINE_ID    = A.LINE_ID
												   AND X.OPERATION_ID = A.OP_ID
      											   AND X.OPERATION_SEQ = A.OP_SEQ
												   AND X.OPERATION_STEP = 1
										--2018-08-13 PIYONG ADD END
							) AA
							LEFT OUTER JOIN (
												SELECT SEGMENT1
														,SEGMENT2
														,SEGMENT3
														,SEGMENT4
														,SEGMENT5
														,CAST(ATTRIBUTE1 AS FLOAT) AS RATE
														,( CASE WHEN ATTRIBUTE2 = 'Y' THEN 
														       ( SELECT LEFT(ST.SEGMENT2,2) + ':' + SUBSTRING(ST.SEGMENT2, 3,2) + ':' + SUBSTRING(ST.SEGMENT2, 5,2)
															     FROM  SCM_SYS_LOOKUP_VALUE ST WITH(NOLOCK)
															     WHERE ST.LOOKUP_TYPE_CODE  = 'BASIS_START_TIME_PLANT'
															     AND   ST.SEGMENT1          = LV.SEGMENT4 )
														   END )    AS START_TIME   -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분하는 경우 시업 시간 설정
												  FROM SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK)
												 WHERE LV.LOOKUP_TYPE_CODE  = 'FORMATION_AVAILABLE_DATE_RATE'
											) LV
										  ON LV.SEGMENT1 = AA.COMPANY_ID
										 AND LV.SEGMENT2 = AA.DIVISION_ID
										 AND LV.SEGMENT3 = AA.SITE_ID
										 AND LV.SEGMENT4 = AA.PLANT_ID
										 AND LV.SEGMENT5 = AA.FACTORY_ID;


						SELECT   T.REMAIN_DAYS
      							,T.COMPANY_ID
								,T.DIVISION_ID
								,T.SITE_ID
								,T.PLANT_ID
								,T.FACTORY_ID
								,T.ROUTE_ID
								,T.LINE_ID
								,T.WORKDATE
      							,T.ITEM_ID
      							,T.INPUT_CELL_CNT
      							,T.NOW_CELL_CNT
      							,T.OP_ID
      							,T.OP_SEQ
      							,T.OP_START_TIME
								,T.AVAILABLE_DATE
      							,T.TRAY_OP_STATUS
								,T.TRAY_ID
								,T.STOCK_TYPE
								,T.WIPHOLD_YN
								,T.UNHOLD_EXP_DATE
								,T.SPECIAL_YN
								,T.LOT_ID
								,T.BEFORE_DEGAS
								,T.REMAIN_TIME
								,T.DEGAS_END_DATE
								,T.BASE_RATE_CNT
								,T.APPLY_YN
								,ROW_NUMBER() OVER ( PARTITION BY T.PLANT_ID, T.FACTORY_ID, T.LINE_ID, T.ITEM_ID, T.ROUTE_ID, T.LOT_ID, T.BEFORE_DEGAS
															ORDER BY T.PLANT_ID, T.FACTORY_ID, T.LINE_ID, T.ITEM_ID, T.ROUTE_ID, T.LOT_ID, T.BEFORE_DEGAS, T.AVAILABLE_DATE ) AS RN
								,T.START_TIME  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분하는 경우 시업 시간 설정
								,X.ATTRIBUTE1 AS PRODUCTION_TYPE
								--,'' AS PRODUCTION_TYPE
						  INTO #TEMP_FCS_INVENTORY 
						  FROM #TEMP_INVENTORY AS T
						       LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE AS X WITH(NOLOCK)
							ON LOOKUP_TYPE_CODE = 'MES_LOT_TYPE'
						   AND ACTIVE_FLAG= 'Y'
						   AND SEGMENT1 = T.LOT_TYPE 

						--------------------------------------------------------------------------------------------------------------------------------------------
						--2018-11-07 PIYONG ADD	-- LINE_ID, LOT_ID 별 OP_START_TIME 조회
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.ITEM_ID
      							,A.ROUTE_ID ,A.LOT_ID, A.AVAILABLE_DATE
						  INTO #TEMP_OP_START_TIME
						  FROM #TEMP_FCS_INVENTORY A
							   INNER JOIN (
											SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
      											   ,ITEM_ID, ROUTE_ID, LOT_ID
												   ,MAX(BASE_RATE_CNT) AS BASE_RATE_CNT
											  FROM #TEMP_FCS_INVENTORY A
											 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
      											   ,ITEM_ID, ROUTE_ID, LOT_ID
										  ) AA
									   ON A.COMPANY_ID = AA.COMPANY_ID
									  AND A.DIVISION_ID = AA.DIVISION_ID
									  AND A.SITE_ID = AA.SITE_ID
									  AND A.PLANT_ID = AA.PLANT_ID
									  AND A.FACTORY_ID = AA.FACTORY_ID
									  AND A.LINE_ID = AA.LINE_ID
      								  AND A.ITEM_ID = AA.ITEM_ID
									  AND A.ROUTE_ID = AA.ROUTE_ID
									  AND A.LOT_ID = AA.LOT_ID
									  AND A.RN = AA.BASE_RATE_CNT
									  AND A.BEFORE_DEGAS = 'N'
						--2018-11-07 PIYONG ADD  END
						--------------------------------------------------------------------------------------------------------------------------------------------



			------------------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			--------------------------------------------------------------SCM_AGING_TRAY_STOCK_H------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
					

						--2017-11-10 PIYONG  추가 FCS 출문 정보  삭제
						DELETE [DBO].[SCM_AGING_TRAY_STOCK_H]
						  FROM (
			   					SELECT DISTINCT X.DIVISION_ID, x.PLANT_ID,  X.FACTORY_ID, X.WORKDATE, STOCK_TYPE	-- 2020-05-04 PIYONG ADD STOCK_TYPE
								  FROM #TEMP_FCS_INVENTORY X 
				   				--WHERE TRANSFER_FLAG = 'P'		--2018-11-07 PIYONG DEL
								--AND IFSEQNO = @V_IFSEQNO		--PIYONG 2018-07-17 DEL
								--AND ATTRIBUTE1 = 'TRAY'		--2017-11-10 PIYONG 추가  --2018-11-07 PIYONG DEL
							   ) B
						 WHERE [SCM_AGING_TRAY_STOCK_H].DIVISION_ID = B.DIVISION_ID
						   AND [SCM_AGING_TRAY_STOCK_H].FACTORY_ID = B.FACTORY_ID
						   AND [SCM_AGING_TRAY_STOCK_H].CUTOFF_DATE =B.WORKDATE
						   AND [SCM_AGING_TRAY_STOCK_H].PLANT_ID = B.PLANT_ID
						   AND [SCM_AGING_TRAY_STOCK_H].STOCK_TYPE = B.STOCK_TYPE		-- 2020-05-04 PIYONG ADD
						   AND [SCM_AGING_TRAY_STOCK_H].SITE_ID = @SITE_ID
						   AND [SCM_AGING_TRAY_STOCK_H].insert_id = @V_PROC_NAME		-- 1.1 6A04 활성화 MES 전환에 따른 삭제로직 조건 추가
						;

						--2017-11-10 PIYONG  추가  FCS 출문 정보  입력 시작
						---------------------------------------------------
						INSERT INTO [DBO].[SCM_AGING_TRAY_STOCK_H]
						(
							[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[ROUTE_ID]
							,[LINE_ID]
							,[CUTOFF_DATE]
							,[SEQ]
							,[ITEM_ID]
							,[PRODUCTION_TYPE]
							,[FCS_INPUT_DATE]
							,[AVAILABLE_DATE]
							,[REMAIN_LEAD_TIME]
							,[HOLDING_DATE]
							,[INPUT_QTY]
							,[QTY]
							,[QTY_UOM]
							,[STOCK_STATUS]
							,[OPERATION_ID]
							,[OPERATION_SEQ]
							,[OP_START_TIME]
							,[TRAY_OP_STATUS]
							,[TRAY_ID]
							,[CREATE_TIME]
							,[STOCK_TYPE]			--2018-04-18 PIYONG ADD
							,[WIPHOLD_YN]			--2018-04-18 PIYONG ADD
							,[UNHOLD_EXP_DATE]		--2018-04-18 PIYONG ADD
							,[SPECIAL_YN]			--2018-04-18 PIYONG ADD
							,[LOT_ID]				--2018-04-18 PIYONG ADD
							,[OCV2_END_TIME]		--2018-06-20 PIYONG ADD
							,[SHIP_AVAILABLE_DATE]	--2018-06-20 PIYONG ADD
							,[BEFORE_DEGAS]			--2018-08-13 PIYONG ADD
							,[DEGAS_END_DATE]		--2018-08-13 PIYONG ADD
							,[BASE_AVAILABLE_DATE]	--2018-11-07 PIYONG ADD
							,[ORIGINAL_QTY]			--2018-11-29 PIYONG ADD
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						)
						SELECT COMPANY_ID
						     , DIVISION_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , ROUTE_ID
							 , LINE_ID
							 , WORKDATE
      						 , ROW_NUMBER() OVER ( ORDER BY WORKDATE)
      						 , ITEM_ID 
							 , MAX(PRODUCTION_TYPE) AS PRODUCTION_TYPE
							 , GETDATE() AS FCS_INPUT_DATE
							 /* 11-03 변경 */
							 , AVAILABLE_DATE
      						 , CASE WHEN REMAIN_DAYS > 0 THEN ROUND( (REMAIN_DAYS/60/24), 1) ELSE 0 END AS REMAIN_LEAD_TIME
							 , null AS HOLDING_DATE
      						 , SUM(INPUT_CELL_CNT) AS INPUT_QTY
      						 , SUM(NOW_CELL_CNT) AS QTY
      						 , MAX(UOM) AS QTY_UOM
      						 , null AS STOCK_STATUS
      						 , OP_ID
							 , OP_SEQ
							 , CONVERT(DATE, OP_START_TIME) AS OP_START_TIME
							 , TRAY_OP_STATUS
							 , TRAY_ID
							 , GETDATE()  AS CREATE_TIME
							 , STOCK_TYPE						-- 2018-04-18 PIYONG ADD
							 , WIPHOLD_YN						-- 2018-04-18 PIYONG ADD
							 , UNHOLD_EXP_DATE					-- 2018-04-18 PIYONG ADD
							 , SPECIAL_YN						-- 2018-04-18 PIYONG ADD
							 , LOT_ID							-- 2018-04-18 PIYONG ADD
							 , NULL AS OCV2_END_TIME			-- 2018-06-20 PIYONG ADD
							 , NULL AS SHIP_AVAILABLE_DATE		-- 2018-06-20 PIYONG ADD
							 , BEFORE_DEGAS						-- 2018-08-13 PIYONG ADD
							 , DEGAS_END_DATE					-- 2018-08-13 PIYONG ADD
							 , BASE_AVAILABLE_DATE				-- 2018-11-07 PIYONG ADD
							 , SUM(ORIGINAL_QTY)				-- 2018-11-29 PIYONG ADD
      						 , @V_PROC_NAME
      						 , GETDATE()
      						 , @V_PROC_NAME
      						 , GETDATE()
						  FROM (SELECT REMAIN_DAYS
      									,COMPANY_ID
										,DIVISION_ID
										,SITE_ID
										,PLANT_ID
										,FACTORY_ID
										,ROUTE_ID
										,LINE_ID
										,WORKDATE
      									,ITEM_ID
      									,CASE WHEN APPLY_YN = 'N' AND PLANT_ID IN ( 'A040' ) THEN 0 ELSE INPUT_CELL_CNT END AS INPUT_CELL_CNT	--2019-10-23 PIYONG CHEANGE CASE 문 추가
      									,CASE WHEN APPLY_YN = 'N' AND PLANT_ID IN ( 'A040' ) THEN 0 ELSE NOW_CELL_CNT END NOW_CELL_CNT		--2018-11-29 PIYONG CHEANGE CASE 문 추가
										,'EA' UOM
      									,OP_ID
      									,OP_SEQ
      									,OP_START_TIME
										,ISNULL( CASE WHEN BEFORE_DEGAS = 'N' AND (
																				--------------------------------------------------------------------
																				--2019-07-11 PIYONG CHANGE LOOK UP으로 변경
																					SELECT CAST(ATTRIBUTE1 AS FLOAT)
																					  FROM SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK)
																					 WHERE LV.LOOKUP_TYPE_CODE  = 'FORMATION_AVAILABLE_DATE_RATE'
																					   AND SEGMENT1 = A.COMPANY_ID
																					   AND SEGMENT2 = A.DIVISION_ID
																					   AND SEGMENT3 = A.SITE_ID
																					   AND SEGMENT4 = A.PLANT_ID
																					   AND SEGMENT5 = A.FACTORY_ID		--2019-07-26 PIYONG ADD
																				  ) IS NOT NULL
																				--2019-07-11 PIYONG CHANGE LOOK UP으로 변경
																				--------------------------------------------------------------------
																					
																																							THEN
													CASE WHEN (
																 SELECT CONVERT(NVARCHAR(8), AA.AVAILABLE_DATE, 112 )
																   FROM #TEMP_OP_START_TIME AA
																  WHERE A.COMPANY_ID = AA.COMPANY_ID
																	AND A.DIVISION_ID = AA.DIVISION_ID
																	AND A.SITE_ID = AA.SITE_ID
																	AND A.PLANT_ID = AA.PLANT_ID
																	AND A.FACTORY_ID = AA.FACTORY_ID
																	AND A.LINE_ID = AA.LINE_ID
																	AND A.ITEM_ID = AA.ITEM_ID
																	AND A.ROUTE_ID = AA.ROUTE_ID
																	AND A.LOT_ID = AA.LOT_ID
																	AND A.BEFORE_DEGAS = 'N'
															) <= CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112) THEN
															 CASE WHEN START_TIME IS NULL THEN
																 CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
															 ELSE
																 CASE WHEN SUBSTRING(CONVERT(NVARCHAR(20), AVAILABLE_DATE, 120), 12,8) > A.START_TIME THEN
																	 CONVERT(NVARCHAR(8), DATEADD(D,1,AVAILABLE_DATE), 112)
																 ELSE
																	 CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
																 END  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분 로직 추가
															 END
														 ELSE
															(
																SELECT   CASE WHEN START_TIME IS NULL THEN
																			 CONVERT(NVARCHAR(8), AA.AVAILABLE_DATE, 112)
																		 ELSE
																			 CASE WHEN SUBSTRING(CONVERT(NVARCHAR(20), AA.AVAILABLE_DATE, 120), 12,8) > A.START_TIME THEN
																				 CONVERT(NVARCHAR(8), DATEADD(D,1,AA.AVAILABLE_DATE), 112)
																			 ELSE
																				 CONVERT(NVARCHAR(8), AA.AVAILABLE_DATE, 112)
																			 END
																		 END  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분 로직 추가
																  FROM #TEMP_OP_START_TIME AA
																 WHERE A.COMPANY_ID = AA.COMPANY_ID
																   AND A.DIVISION_ID = AA.DIVISION_ID
																   AND A.SITE_ID = AA.SITE_ID
																   AND A.PLANT_ID = AA.PLANT_ID
																   AND A.FACTORY_ID = AA.FACTORY_ID
																   AND A.LINE_ID = AA.LINE_ID
																   AND A.ITEM_ID = AA.ITEM_ID
																   AND A.ROUTE_ID = AA.ROUTE_ID
																   AND A.LOT_ID = AA.LOT_ID
																   AND A.BEFORE_DEGAS = 'N'
															)
														END
												  ELSE
													  CASE WHEN START_TIME IS NULL THEN
														  CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
													  ELSE
														  CASE WHEN SUBSTRING(CONVERT(NVARCHAR(20), AVAILABLE_DATE, 120), 12,8) > A.START_TIME THEN
															  CONVERT(NVARCHAR(8), DATEADD(D,1,AVAILABLE_DATE), 112)
														  ELSE
															  CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
														  END
													  END  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분 로직 추가
												  END , CONVERT(NVARCHAR(8), DATEADD(YEAR, 1, GETDATE()), 112) ) AS AVAILABLE_DATE	--2019-03-07 PIYONG DATEADD 추가
      									,TRAY_OP_STATUS
										,TRAY_ID
										,STOCK_TYPE
										,WIPHOLD_YN
										,UNHOLD_EXP_DATE
										,SPECIAL_YN
										,LOT_ID
										,BEFORE_DEGAS
										,DEGAS_END_DATE
										,CASE WHEN START_TIME IS NULL THEN
										     CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
										 ELSE
										     CASE WHEN SUBSTRING(CONVERT(NVARCHAR(20), AVAILABLE_DATE, 120), 12,8) > A.START_TIME THEN
											     CONVERT(NVARCHAR(8), DATEADD(D,1,AVAILABLE_DATE), 112)
											 ELSE
											     CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
											 END
										 END AS BASE_AVAILABLE_DATE  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분 로직 추가
										,INPUT_CELL_CNT AS ORIGINAL_IN_QTY										-- 2019-10-23 PIYONG ADD
										,NOW_CELL_CNT AS ORIGINAL_QTY											--2018-11-29 PIYONG ADD
										,A.PRODUCTION_TYPE
									FROM #TEMP_FCS_INVENTORY AS A
								--2018-11-07 PIYONG ADD END
								---------------------------------------------------------------------------------------------------------------
							) A
					  GROUP BY  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
						    ,ROUTE_ID, LINE_ID, WORKDATE, ITEM_ID
						    ,AVAILABLE_DATE
      						,CASE WHEN REMAIN_DAYS > 0 THEN ROUND( (REMAIN_DAYS/60/24), 1) ELSE 0 END
							,OP_ID, OP_SEQ, CONVERT(DATE, OP_START_TIME) , TRAY_OP_STATUS
							-- 2018-04-18 PIYONG ADD
						    ,TRAY_ID, STOCK_TYPE,WIPHOLD_YN, UNHOLD_EXP_DATE, SPECIAL_YN
							,LOT_ID
							-- 2018-08-13 PIYONG ADD
							,BEFORE_DEGAS, DEGAS_END_DATE
							,BASE_AVAILABLE_DATE	--2018-11-07 PIYONG ADD
						;
				--2017-11-10 PIYONG  추가  FCS 출문 정보  입력 끝
				---------------------------------------------------

						--2020-10-17 kimcd 기존 재고 삭제하는 문장 추가
						DELETE [DBO].[SCM_AGING_STOCK_H]
						  FROM (
			   					SELECT DISTINCT X.DIVISION_ID, x.PLANT_ID,  X.FACTORY_ID, X.WORKDATE, STOCK_TYPE	-- 2020-05-04 PIYONG ADD STOCK_TYPE
								  FROM #TEMP_FCS_INVENTORY X 
							   ) B
						 WHERE [SCM_AGING_STOCK_H].DIVISION_ID = B.DIVISION_ID
						   AND [SCM_AGING_STOCK_H].FACTORY_ID = B.FACTORY_ID
						   AND [SCM_AGING_STOCK_H].CUTOFF_DATE =B.WORKDATE
						   AND [SCM_AGING_STOCK_H].PLANT_ID = B.PLANT_ID
						   AND [SCM_AGING_STOCK_H].STOCK_TYPE = B.STOCK_TYPE		-- 2020-05-04 PIYONG ADD
						   AND [SCM_AGING_STOCK_H].SITE_ID = @SITE_ID
						   AND [SCM_AGING_STOCK_H].insert_id = @V_PROC_NAME		-- 1.1 6A04 활성화 MES 전환에 따른 삭제로직 조건 추가
						;
      
						INSERT INTO [DBO].[SCM_AGING_STOCK_H]
						(
							[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[ROUTE_ID]
							,[LINE_ID]
							,[CUTOFF_DATE]
							,[SEQ]
							,[ITEM_ID]
							,[PRODUCTION_TYPE]
							,[FCS_INPUT_DATE]
							,[AVAILABLE_DATE]
							,[REMAIN_LEAD_TIME]
							,[HOLDING_DATE]
							,[INPUT_QTY]
							,[QTY]
							,[QTY_UOM]
							,[STOCK_STATUS]
							,[OPERATION_ID]
							,[OPERATION_SEQ]
							,[OP_START_TIME]
							,[TRAY_OP_STATUS]
							,[STOCK_TYPE]			--2018-04-18 PIYONG ADD
							,[WIPHOLD_YN]			--2018-04-18 PIYONG ADD
							,[UNHOLD_EXP_DATE]		--2018-04-18 PIYONG ADD
							,[SPECIAL_YN]			--2018-04-18 PIYONG ADD
							,[LOT_ID]				--2018-04-30 PIYONG ADD
							,[OCV2_END_TIME]		--2018-06-20 PIYONG ADD
							,[SHIP_AVAILABLE_DATE]	--2018-06-20 PIYONG ADD
							,[BEFORE_DEGAS]			--2018-08-13 PIYONG ADD
							,[DEGAS_END_DATE]		--2018-08-13 PIYONG ADD
							,[BASE_AVAILABLE_DATE]	--2018-11-07 PIYONG ADD
							,[ORIGINAL_QTY]			--2018-11-29 PIYONG ADD
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						)
						SELECT COMPANY_ID
						     , DIVISION_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , ROUTE_ID
							 , LINE_ID
							 , WORKDATE
      						 , ROW_NUMBER() OVER ( ORDER BY WORKDATE)
      						 , ITEM_ID
							 , MAX(PRODUCTION_TYPE) AS  PRODUCTION_TYPE
							 , NULL AS FCS_INPUT_DATE
      						--, DATEADD(DD, REMAIN_DAYS, CREATE_TIME ) AS AVAILABLE_DATE
							/* 11-03 변경 */
							 , AVAILABLE_DATE
      						 , CASE WHEN REMAIN_DAYS > 0 THEN ROUND( (REMAIN_DAYS/60/24), 1) ELSE 0 END AS REMAIN_LEAD_TIME
							 , null HOLDING_DATE
      						 , SUM(INPUT_CELL_CNT) INPUT_QTY
      						 , SUM(NOW_CELL_CNT) QTY
      						 , MAX(UOM) QTY_UOM
      						 , null STOCK_STATUS
      						 , OP_ID
							 , OP_SEQ
							 , CONVERT(DATE, OP_START_TIME) AS OP_START_TIME
							 , TRAY_OP_STATUS
							 , STOCK_TYPE			--2018-04-18 PIYONG ADD
							 , WIPHOLD_YN			--2018-04-18 PIYONG ADD
							 , UNHOLD_EXP_DATE		--2018-04-18 PIYONG ADD
							 , SPECIAL_YN			--2018-04-18 PIYONG ADD
							 , A.LOT_ID				--2018-04-30 PIYONG ADD
							 , NULL AS OCV2_END_TIME			--2018-06-20 PIYONG ADD
							 , NULL AS SHIP_AVAILABLE_DATE	--2018-06-20 PIYONG ADD
							 , A.BEFORE_DEGAS			--2018-08-13 PIYONG ADD
							 , A.DEGAS_END_DATE			--2018-08-13 PIYONG ADD
							 , A.BASE_AVAILABLE_DATE	--2018-11-07 PIYONG ADD
							 , SUM(ORIGINAL_QTY)		--2018-11-29 PIYONG ADD
      						 , @V_PROC_NAME
      						 , GETDATE()
      						 , @V_PROC_NAME
      						 , GETDATE()
						  FROM (
								SELECT A.COMPANY_ID
								     , A.DIVISION_ID
									 , A.SITE_ID
									 , A.PLANT_ID
									 , A.FACTORY_ID
									 , A.ROUTE_ID
									 , A.LINE_ID
									 , A.WORKDATE
      								 , A.ITEM_ID
									 , CASE WHEN APPLY_YN = 'N' AND PLANT_ID IN ( 'A040' ) THEN 0 ELSE INPUT_CELL_CNT END AS INPUT_CELL_CNT	--2019-10-23 PIYONG CHEANGE CASE 문 추가
									 , CASE WHEN APPLY_YN = 'N' AND A.PLANT_ID IN ( 'A040' ) THEN 0 ELSE A.NOW_CELL_CNT END NOW_CELL_CNT		--2018-11-29 PIYONG CHEANGE CASE 문 추가
      								 , 'EA' UOM
      								 , A.OP_ID
      								 , A.OP_SEQ
									 , A.REMAIN_DAYS
      								 , OP_START_TIME
									 , ISNULL( CASE WHEN BEFORE_DEGAS = 'N' AND (
									 											--------------------------------------------------------------------
									 											--2019-07-11 PIYONG CHANGE LOOK UP으로 변경
									 											SELECT CAST(ATTRIBUTE1 AS FLOAT)
									 												FROM SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK)
									 												WHERE LV.LOOKUP_TYPE_CODE  = 'FORMATION_AVAILABLE_DATE_RATE'
									 												AND SEGMENT1 = A.COMPANY_ID
									 												AND SEGMENT2 = A.DIVISION_ID
									 												AND SEGMENT3 = A.SITE_ID
									 												AND SEGMENT4 = A.PLANT_ID
									 												AND SEGMENT5 = A.FACTORY_ID		--2019-07-26 PIYONG ADD
									 											) IS NOT NULL
									 											--2019-07-11 PIYONG CHANGE LOOK UP으로 변경
									 											--------------------------------------------------------------------
									 																														THEN
									 			CASE WHEN (
									 						SELECT CONVERT(NVARCHAR(8), AA.AVAILABLE_DATE, 112 )
									 							FROM #TEMP_OP_START_TIME AA
									 							WHERE A.COMPANY_ID = AA.COMPANY_ID
									 							AND A.DIVISION_ID = AA.DIVISION_ID
									 							AND A.SITE_ID = AA.SITE_ID
									 							AND A.PLANT_ID = AA.PLANT_ID
									 							AND A.FACTORY_ID = AA.FACTORY_ID
									 							AND A.LINE_ID = AA.LINE_ID
									 							AND A.ITEM_ID = AA.ITEM_ID
									 							AND A.ROUTE_ID = AA.ROUTE_ID
									 							AND A.LOT_ID = AA.LOT_ID
									 							AND A.BEFORE_DEGAS = 'N'
									 						) <= CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112) THEN
									 			
									 						 CASE WHEN START_TIME IS NULL THEN
									 							 CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
									 						 ELSE
									 							 CASE WHEN SUBSTRING(CONVERT(NVARCHAR(20), AVAILABLE_DATE, 120), 12,8) > A.START_TIME THEN
									 								 CONVERT(NVARCHAR(8), DATEADD(D,1,AVAILABLE_DATE), 112)
									 							 ELSE
									 								 CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
									 							 END  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분 로직 추가
									 						 END
									 					ELSE
									 					(
									 						SELECT   CASE WHEN START_TIME IS NULL THEN
									 									 CONVERT(NVARCHAR(8), AA.AVAILABLE_DATE, 112)
									 								 ELSE
									 									 CASE WHEN SUBSTRING(CONVERT(NVARCHAR(20), AA.AVAILABLE_DATE, 120), 12,8) > A.START_TIME THEN
									 										 CONVERT(NVARCHAR(8), DATEADD(D,1,AA.AVAILABLE_DATE), 112)
									 									 ELSE
									 										 CONVERT(NVARCHAR(8), AA.AVAILABLE_DATE, 112)
									 									 END
									 								 END  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분 로직 추가
									 							FROM #TEMP_OP_START_TIME AA
									 							WHERE A.COMPANY_ID = AA.COMPANY_ID
									 							AND A.DIVISION_ID = AA.DIVISION_ID
									 							AND A.SITE_ID = AA.SITE_ID
									 							AND A.PLANT_ID = AA.PLANT_ID
									 							AND A.FACTORY_ID = AA.FACTORY_ID
									 							AND A.LINE_ID = AA.LINE_ID
									 							AND A.ITEM_ID = AA.ITEM_ID
									 							AND A.ROUTE_ID = AA.ROUTE_ID
									 							AND A.LOT_ID = AA.LOT_ID
									 							AND A.BEFORE_DEGAS = 'N'
									 					)
									 					END
									 			ELSE
									 				CASE WHEN START_TIME IS NULL THEN
									 					CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
									 				ELSE
									 					CASE WHEN SUBSTRING(CONVERT(NVARCHAR(20), AVAILABLE_DATE, 120), 12,8) > A.START_TIME THEN
									 						CONVERT(NVARCHAR(8), DATEADD(D,1,AVAILABLE_DATE), 112)
									 					ELSE
									 						CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
									 					END
									 				END  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분 로직 추가
									 			END , CONVERT(NVARCHAR(8), DATEADD(YEAR, 1, GETDATE()), 112) ) AS AVAILABLE_DATE	--2019-03-07 PIYONG DATEADD 추가
      								 , A.TRAY_OP_STATUS
									 , A.STOCK_TYPE
									 , A.WIPHOLD_YN
									 , A.UNHOLD_EXP_DATE
									 , A.SPECIAL_YN
									 , A.LOT_ID
									 , A.BEFORE_DEGAS
									 , A.DEGAS_END_DATE
									 , A.REMAIN_TIME
									 , CASE WHEN START_TIME IS NULL THEN
									 	  CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
									   ELSE
									 	  CASE WHEN SUBSTRING(CONVERT(NVARCHAR(20), AVAILABLE_DATE, 120), 12,8) > A.START_TIME THEN
									 		  CONVERT(NVARCHAR(8), DATEADD(D,1,AVAILABLE_DATE), 112)
									 	  ELSE
									 		  CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
									 	  END
									   END AS BASE_AVAILABLE_DATE  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분 로직 추가	--2018-11-07 PIYONG ADD
									 , INPUT_CELL_CNT AS ORIGINAL_IN_QTY									-- 2019-10-23 PIYONG ADD
									 , A.NOW_CELL_CNT AS  ORIGINAL_QTY									--2018-11-29 PIYONG ADD
									 , A.PRODUCTION_TYPE
								  FROM #TEMP_FCS_INVENTORY AS A
							   ) A
						 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ROUTE_ID, LINE_ID, WORKDATE,ITEM_ID	--, CREATE_TIME, DATEADD(DD, REMAIN_DAYS, CREATE_TIME) 
								,OP_ID,CONVERT(DATE, OP_START_TIME ), OP_SEQ, TRAY_OP_STATUS
								,AVAILABLE_DATE
      							,CASE WHEN REMAIN_DAYS > 0 THEN ROUND( (REMAIN_DAYS/60/24), 1) ELSE 0 END
								--2018-04-18 PIYONG ADD
								,STOCK_TYPE, WIPHOLD_YN, UNHOLD_EXP_DATE, SPECIAL_YN
								,LOT_ID							--2018-04-30 PIYONG ADD
				  				--2018-06-20 PIYONG ADD
				  				--2018-08-13 PIYONG ADD
								,A.BEFORE_DEGAS ,A.DEGAS_END_DATE
								,BASE_AVAILABLE_DATE	--2018-11-07 PIYONG ADD
							;
					SET @ROWCOUNT = @@ROWCOUNT

  					UPDATE [dbo].[SY_XIF_MES_CHAR_AGING_STOCK_R]
					SET    PROC_FLAG = 'Y'
						  ,PROC_DATE = GETDATE()
					WHERE  PROC_FLAG  = 'P'
					AND    IF_ID      = @IF_ID
					AND    ACCUM_DATE = @ACCUM_DATE;
				 END;
	


					FETCH NEXT FROM CUR_IF_FORM_WIP INTO @IF_ID        
														,@ACCUM_DATE
														,@SITE_ID;

					COMMIT TRAN
				END;

			CLOSE CUR_IF_FORM_WIP;
			DEALLOCATE CUR_IF_FORM_WIP;  
		-- ================================================
		-- 작업 END
		-- ================================================


		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END', @ROWCOUNT, @V_TEMP1, '############### END OF PROCEDURE ###############', NULL, @SYSDATE
		
	END TRY

	BEGIN CATCH

	   ROLLBACK TRAN

		SET @V_DESCR = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'ERROR', NULL, @V_TEMP2, NULL, @V_DESCR, @SYSDATE

	END CATCH

END
