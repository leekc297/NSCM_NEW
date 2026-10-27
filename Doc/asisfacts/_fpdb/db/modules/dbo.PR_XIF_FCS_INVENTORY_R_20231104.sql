
CREATE PROCEDURE [dbo].[PR_XIF_FCS_INVENTORY_R_20231104]

-- ================================================================================================
-- PROGRAM ID          : FP00970
-- PROGRAM NAME        : PR_XIF_FCS_INVENTORY_R
-- PARAM               :
-- BATCH PERIOD        : 1HOUR
-- DESCRIPTION         :
--
-- SOURCE SYSTEM       : ERP
-- DESTINATION SYSTEM  : FP SDB
-- SOURCE TABLE        : XIF_DW_FCS_INVENTORY_R
-- DESTINATION TABLE   : SCM_AGING_STOCK_H
--
-- CREATE DATE		   : 2016.10.05
-- UPDATE DATE		   : 2017.04.11  1.1
--						 2017.11.10  1.2
--						 2018.03.08 PIYONG 1.3
--						 2018.04.18 PIYONG 1.4
--					     2018.04.19 PIYONG 1.5
--					     2018.04.19 PIYONG 1.6
--						 2018.05.10 PIYONG 1.7
--						 2018.05.11 PIYONG 1.8
--						 2018.05.11 PIYONG 1.9
--                       2018.05.17 PIYONG 1.91
--						 2018.05.25	PIYONG 1.11
--						 2018.06.08 PIYONG 1.12
--						 2018.06.20 PIYONG 2.0
--						 2018.07.12 PIYONG 2.1
--						 2018.07.17 PIYONG 2.2
--						 2018.08.13 PIYONG 2.3
--						 2018.11.15 PIYONG 2.4
--						 2018.11.07 PIYONG 3.0
--						 2018.11.29 PIYONG 3.1
--						 2018.12.06 PIYONG 3.2
--						 2019.03.07 PIYONG 3.3
--						 2019.03.07 PIYONG 3.4
--						 2019.07.11 PIYONG 3.5
--						 2019.07.26 PIYONG 3.51
--						 2019.10.23 PIYONG 3.52
--						 2020.02.10 PIYONG 3.6
--						 2020.02.24 PIYONG 3.7
--						 2020.05.04 PIYONG 4.0
--						 2020.06.11 PIYONG 4.1
--						 2020.10.17 PIYONG 4.11
--						 2021.07.12 KIMCD  4.12
--						 2021.08.10 KIMCD  4.13


-- VERSION             : 1.0
--                     : 1.1 OP_START_TIME 날짜 형식 변경
--						 1.2 조회 조건 추가  AND ATTRIBUTE1 IS NOT NULL
--						 1.3 DEFAULT_FLAG  Y,N -> S, F 로 변경
--						 1.4 #TEMP_FCS_INVENTORY 생성 조건 변경
--						 1.5 #TEMP_FCS_INV 삭제
--							@P_SITE_ID  IFSEQNO 기준으로 변경
--						 1.6 SCM_AGING_STOCK_H 테이블에 LOT_ID 추가
--						 1.7 L/T 구할때 현재 공정 포함하도록 변경
--						 1.8 LINE_ID가 XZ0(오창 ESS라인) 일 경우  PLANT, FACTORY 변경 로직 추가
--						 1.9 LINE_ID가 XZ0(오창 ESS라인) 일 경우  PLANT, FACTORY 변경 로직에서 하드 코딩 제거
--						 1.91 작업 속도 문제로 SCM_LINE_M OUTER JOIN 방식 조정
--						 1.11 PROCESSING_TIME -> STANDARD_LT 변경(STANDARD_LT 사용자관리에서 -> SYSTEM관리로 변경)
--						 1.12 SSLV(LOOK UP TABLE) INNER JOIN 에서 LEFT OUTER  변경
--						 2.0 SCM_AGING_STOCK_H, SCM_AGING_TRAY_STOCK_H 테이블에 N2.1 경우 OCV2_END_TIME, SHIP_AVAILABLE_DATE 컬럼 값 생성
--							 SHIP_AVAILABLE_DATE 값 생성 	
--						 2.1 CREATE_TIME NULL 혹은 '' 처리
--						 2.2 조건에서 IFSEQNO 제거
--						 2.3 DEGAS 전후 구분, DEGAS 종료 일자 추가
--						 2.4 SCM_AGING_ITEM_FLOW_M 조인할때 오창소형의 경우 LINE_ID가 안 맞는 경우가 있어 조건 삭제
--						 3.0 AVAILABLE_DATE 생성 기준 변경
--							 -동일 ROUTE_ID, LINE_ID, LOT_ID 별 총 수의 90%에 해당하는 AVILABLE_DATE 을 동일하게 적용
--						 3.1 ORIGINAL_QTY  추가
--							 - ROUTE_TYPE이 T,U,W 의 NOW_CELL_CNT 변경으로 인한 I/F 원본값 저장
--						 3.2 INNER JOIN 에서 OUTER JOIN으로 변경
--						 3.3 OP_SEQ값이 없을경우  AVAILABLE_DATE 값을 1년 뒤로 설정
--						 3.4 SCM_LINE_M 조회 조건 추가 및 삭제
--						 3.5 AVAILABLE_DATE 생성 로직 변경
--							 -'FORMATION_AVAILABLE_DATE_RATE' LOOKUP 사용
--						 3.51 FORMATION_AVAILABLE_DATE_RATE 동 별로 변경
--						 3.52 장현석 책임 요청으로 오창 자동차 INPUT_CELL_CNT 에 ROUTE_TYPE이 T,U,W인 데이터 0으로 치환 하여 생성
--								--NOW_CELL_CNT과 동일한 목적으로 생성(계획에서 테스트 ROUTE는 사용 안하므로 )
--						 3.6 MAGAZINE 재고 오창만 수신 받도록 LOOKUP 처리( FORMATION_MAGAZINE_STOCK )
--						 3.7 불량 등급된( NOW_CELL_CNT = 0 ) 데이터 제외 조건 추가
--						 4.0 RDB 전환 로직변경
--						 4.1 FORMATION_EXCEPTION_MAPPING 조건 추가
--                       4.11 2020-10-17 kimcd 시업 시간 기준으로 시업  시간 이전은 당일 이후는 다음날로 가용일자 설정
--                       4.12 2021-07-12 kimcd SPECIAL_CD Hold 특별관리코드, SPECIAL_RELEASE_DATE	특별관리 HOLD 보류해제일 정보 추가
--                       4.13 2021-08-10 kimcd S2,S4 동 재고 직접 형성되어 로직 보완
--                       4.14 6A04 활성화 MES 전환에 따른 삭제로직 조건 추가
-- ================================================================================================
-- PARAMETER
@P_SITE_ID NVARCHAR(50) = 'NULL'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG
	DECLARE @V_PROC_NAME NVARCHAR(100) = 'PR_XIF_FCS_INVENTORY_R'
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
	DECLARE @COMPANY          NVARCHAR(1000)
	DECLARE @DIVISION         NVARCHAR(1000)
	DECLARE @SITE_ID          NVARCHAR(1000)
	DECLARE @ITEM_ID          NVARCHAR(1000)
	DECLARE @PLANT_ID         NVARCHAR(1000)
	DECLARE @PROD_VERSION     NVARCHAR(1000)
	DECLARE @EFF_START_DATE   NVARCHAR(1000)
	DECLARE @EFF_END_DATE     NVARCHAR(1000)
	DECLARE @WORK_CENTER_ID   NVARCHAR(1000)
	DECLARE @LINE_CODE        NVARCHAR(1000)
	DECLARE @OPERATION        NVARCHAR(1000)
	DECLARE @PRIORITY         NVARCHAR(1000)
	DECLARE @VALID_YN         NVARCHAR(1000)
	DECLARE @BOM_VERSION      NVARCHAR(1000)
	DECLARE @V_IFSEQNO	      NVARCHAR(100)
	DECLARE @V_BUILDING	      NVARCHAR(30)	-- 2020-05-04 PIYONG ADD
	DECLARE @TEMP_FACTORY	  TABLE (		-- 2019-09-27 PIYONG ADD
										IFSEQNO		NVARCHAR(150)
										,FACTORY_ID NVARCHAR(30)
									)


	-- ================================================
    -- DECLARE END
	-- ================================================

	SET @V_TEMP1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @V_TEMP2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- START
--	EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START', NULL, @V_TEMP1, '############### START OF PROCEDURE ###############', NULL, @SYSDATE

	BEGIN TRY				

		BEGIN TRAN
			-- ================================================
			-- 작업 START
			-- ================================================
			 UPDATE [dbo].[XIF_DW_FCS_INVENTORY_R]
				SET TRANSFER_FLAG = 'P'
				   ,TRANSFER_DATE = GETDATE()
			  WHERE TRANSFER_FLAG = 'N'
			--	AND IFSEQNO       = @V_IFSEQNO	 --PIYONG 2018-07-17 DEL
			;


			IF ( ( SELECT COUNt(1) FROM [dbo].[XIF_DW_FCS_INVENTORY_R] WITH (NOLOCK) WHERE TRANSFER_FLAG = 'P' ) > 0 ) 
			begin
			
				DECLARE CUR CURSOR FOR	-- 2020-05-04 PIYONG ADD
				--------------------------------------------------------------------------------------------------
				--2019-09-27 PIYONG ADD
					SELECT DISTINCT IFSEQNO, BUILDING
					  FROM [dbo].[XIF_DW_FCS_INVENTORY_R]
					 WHERE TRANSFER_FLAG = 'P'
					UNION ALL
					SELECT DISTINCT R.IFSEQNO, L.BUILDING
					  FROM (
							SELECT DISTINCT IFSEQNO, LINE_ID
								FROM [dbo].[XIF_DW_FCS_INVENTORY_R]
								WHERE TRANSFER_FLAG = 'P'
						   ) R
						   ,(
							SELECT SEGMENT2 AS LINE_ID, ATTRIBUTE3 AS BUILDING			-- 2020-06-11 PIYONG CHANGE ATTRIBUTE2 -> ATTRIBUTE3
							  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
							 WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
							   AND ACTIVE_FLAG = 'Y'
							   AND ATTRIBUTE3 IS NOT NULL								-- 2020-06-11 PIYONG ADD
						   ) L
					 WHERE R.LINE_ID = L.LINE_ID
				--2019-09-27 PIYONG ADD
				--------------------------------------------------------------------------------------------------


				OPEN CUR;
				FETCH NEXT FROM CUR INTO @V_IFSEQNO
										 , @V_BUILDING

				WHILE (@@FETCH_STATUS = 0)
					BEGIN

						IF OBJECT_ID('tempdb..#TEMP_INVENTORY') IS NOT NULL		-- 2020-05-04 PIYONG ADD
							DROP TABLE #TEMP_INVENTORY

						IF OBJECT_ID('tempdb..#TEMP_FCS_INVENTORY') IS NOT NULL
							DROP TABLE #TEMP_FCS_INVENTORY

						IF OBJECT_ID('tempdb..#TEMP_OP_START_TIME') IS NOT NULL
							DROP TABLE #TEMP_OP_START_TIME


									--2018-04-19 PIYONG ADD
						SET @P_SITE_ID = (
											SELECT TOP 1 SITE_ID
											  FROM SCM_FACTORY_M
											 WHERE ACTIVE_FLAG= 'Y'
											   AND PLANT_ID IN (
																SELECT DISTINCT PLANT
																  FROM [dbo].[XIF_DW_FCS_INVENTORY_R]	-- WITH(NOLOCK)
																 WHERE TRANSFER_FLAG = 'P'
																   AND IFSEQNO = @V_IFSEQNO					--PIYONG 2018-07-17 DEL	-- 2020-05-04 PIYONG ADD
															--	WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'		-- 2020-05-04 PIYONG DEL
															  )
										) ;


						WITH AGING_ITEM_FLOW_M AS (
							SELECT *
							 FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
							WHERE SITE_ID = @P_SITE_ID
							  AND FACTORY_ID = @V_BUILDING
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
								,CREATE_TIME
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
								,OCV2_END_TIME
								,SHIP_AVAILABLE_DATE
								,BEFORE_DEGAS
								,REMAIN_TIME
								,DEGAS_END_DATE
								,CEILING ( COUNT(LINE_ID) OVER( PARTITION BY PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, ROUTE_ID, LOT_ID, BEFORE_DEGAS )  
											*
											-----------------------------------------------------------------------------------------------------------
											--2019-07-11 PIYONG CHANGE LOOK UP으로 변경
											ISNULL (LV.RATE, 1)
											--2019-07-11 PIYONG CHANGE LOOK UP으로 변경
											-----------------------------------------------------------------------------------------------------------

																																						) AS BASE_RATE_CNT
								,APPLY_YN				-- 2018-11-29 PIYONG ADD
								,LV.START_TIME          -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분하는 경우 시업 시간 설정
						INTO #TEMP_INVENTORY
						FROM (
								SELECT ISNULL( X.REMAIN_TIME,0) + ISNULL( X.ROUTE_TOTAL_TIME,0) AS REMAIN_DAYS		--2018-08-13 PIYONG CHANGE
      									,F.COMPANY_ID
										, F.DIVISION_ID
										, F.SITE_ID
										, F.PLANT_ID
										, F.FACTORY_ID
										, A.ROUTE_ID
										, A.LINE_ID
										,CONVERT( DATETIME,  A.WORKDATE) AS WORKDATE
      									,A.ITEM_ID
										,CASE WHEN A.CREATE_TIME != '' AND A.CREATE_TIME IS NOT NULL THEN	-- 2018-07-12 PIYONG ADD
												CONVERT(DATETIME,SUBSTRING(A.CREATE_TIME,1,8) + ' ' + SUBSTRING(A.CREATE_TIME,9,2) + ':' + SUBSTRING(A.CREATE_TIME,11,2) + ':' +SUBSTRING(A.CREATE_TIME,13,2))
												ELSE
												NULL
												END AS CREATE_TIME
      									,A.INPUT_CELL_CNT
      									,A.NOW_CELL_CNT
      									,'EA' UOM
      									,A.OP_ID
      									,A.OP_SEQ
      									,CASE WHEN STOCK_TYPE = 'FCS' THEN
												CAST ( 
														SUBSTRING(A.OP_START_TIME, 1, 4)+'-'+
														SUBSTRING(A.OP_START_TIME, 5, 2)+'-'+
														SUBSTRING(A.OP_START_TIME, 7, 2)+' '+
														SUBSTRING(A.OP_START_TIME, 9, 2)+':'+
														SUBSTRING(A.OP_START_TIME, 11, 2)+':'+
														SUBSTRING(A.OP_START_TIME, 13, 2) AS DATETIME)
											ELSE
												CONVERT(DATETIME,SUBSTRING( A.OP_START_TIME,1,8))
											END AS OP_START_TIME
      									,A.TRAY_OP_STATUS
										,A.TRAY_ID
										,A.STOCK_TYPE												-- 2018-04-18 PIYONG ADD
										,A.WIPHOLD_YN												-- 2018-04-18 PIYONG ADD
										,A.UNHOLD_EXP_DATE											-- 2018-04-18 PIYONG ADD
										,A.SPECIAL_YN												-- 2018-04-18 PIYONG ADD
										,A.LOT_ID													-- 2018-04-18 PIYONG ADD
										,A.OCV2_END_TIME											--2018-06-20 PIYONG ADD
										,A.SHIP_AVAILABLE_DATE										--2018-06-20 PIYONG ADD
										,CASE WHEN X.DEFAULT_FLAG	= 'B' THEN 'Y' ELSE 'N' END AS BEFORE_DEGAS								-- 2018-08-13 PIYONG ADD
										,ISNULL( X.REMAIN_TIME, 0 ) AS REMAIN_TIME											-- 2018-08-13 PIYONG ADD
										,CASE WHEN X.DEFAULT_FLAG	= 'B' THEN 
												DATEADD(MINUTE, ISNULL( X.REMAIN_TIME , 0),	SUBSTRING( A.OP_START_TIME,1,8) )
												ELSE NULL END										 AS DEGAS_END_DATE							-- 2018-08-13 PIYONG ADD
										,ISNULL( (SELECT ATTRIBUTE5
													FROM SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK)
													WHERE LV.LOOKUP_TYPE_CODE  = 'FORMATION_ROUTE_TYPE_MAPPING'
														AND SEGMENT1 = X.ROUTE_TYPE ), 'Y' ) AS APPLY_YN										-- 2018-11-29 PIYONG ADD
								  FROM (
										SELECT XFI.DIVISION_ID
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
												, XFI.CREATE_TIME
												, XFI.STOCK_TYPE									-- 2018-04-18 PIYONG ADD
												, XFI.WIPHOLD_YN									-- 2018-04-18 PIYONG ADD
												, XFI.UNHOLD_EXP_DATE								-- 2018-04-18 PIYONG ADD
												, XFI.SPECIAL_YN									-- 2018-04-18 PIYONG ADD
												, XFI.LOT_ID										-- 2018-04-18 PIYONG ADD
												, XFI.OCV2_END_TIME									-- 2018-06-20 PIYONG ADD
												, XFI.SHIP_AVAILABLE_DATE							-- 2018-06-20 PIYONG ADD
												,IFSEQNO											-- 2019-09-27 PIYONG ADD
										  FROM (
  												SELECT B.DIVISION_ID
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
														, A.CREATE_TIME
														, A.OCV2_END_TIME							--2018-06-20 PIYONG ADD
														, A.SHIP_AVAILABLE_DATE						--2018-06-20 PIYONG ADD
														,IFSEQNO									--2019-09-27 PIYONG ADD
												  FROM (
														SELECT WORKDATE
																,ISNULL(LM.FACTORY_ID, A.[BUILDING]) AS BUILDING 
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
																,A.CREATE_TIME
																,CASE WHEN A.OCV2_END_TIME != '' AND A.OCV2_END_TIME IS NOT NULL THEN
																			CAST ( 
																							SUBSTRING(A.OCV2_END_TIME, 1, 4)+'-'+
																							SUBSTRING(A.OCV2_END_TIME, 5, 2)+'-'+
																							SUBSTRING(A.OCV2_END_TIME, 7, 2)+' '+
																							SUBSTRING(A.OCV2_END_TIME, 9, 2)+':'+
																							SUBSTRING(A.OCV2_END_TIME, 11, 2)+':'+
																							SUBSTRING(A.OCV2_END_TIME, 13, 2) AS DATETIME)
															 
																		ELSE
																			NULL
																		END OCV2_END_TIME											--2018-06-20 PIYONG ADD
																,CASE WHEN OCV2_END_TIME != '' AND OCV2_END_TIME IS NOT NULL THEN
																			DATEADD( DD, (
																							SELECT CAST(ATTRIBUTE1 AS INT)
																							FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
																							WHERE LOOKUP_TYPE_CODE  = 'FORMATION_SHIP_EOH_EXCEPT'
																							AND SEGMENT2 = 'AGING'
																							AND SEGMENT4 = A.ITEM_ID
																						)
																						, CAST ( 
																									SUBSTRING(OCV2_END_TIME, 1, 4)+'-'+
																									SUBSTRING(OCV2_END_TIME, 5, 2)+'-'+
																									SUBSTRING(OCV2_END_TIME, 7, 2)+' '+
																									SUBSTRING(OCV2_END_TIME, 9, 2)+':'+
																									SUBSTRING(OCV2_END_TIME, 11, 2)+':'+
																									SUBSTRING(OCV2_END_TIME, 13, 2) AS DATETIME
																								)
																					) 
																		WHEN OCV2_END_TIME = '' AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_FCS_SHIPPING_TERM_M) THEN
																			DATEADD( DD,(
																							SELECT ROUND(OCV2_TOTAL_TIME /60/24,0)
      																						FROM AGING_ITEM_FLOW_M X
																							WHERE X.FACTORY_ID = A.BUILDING
																								AND X.ITEM_ID    = A.ITEM_ID
      																							AND X.ROUTE_ID = A.ROUTE_ID
																								AND X.LINE_ID    = ISNULL(LM.[LINE_ID], A.LINE_ID )
      																							AND X.OPERATION_SEQ = A.OP_SEQ
																						), CAST ( 
																									SUBSTRING(A.OP_START_TIME, 1, 4)+'-'+
																									SUBSTRING(A.OP_START_TIME, 5, 2)+'-'+
																									SUBSTRING(A.OP_START_TIME, 7, 2)+' '+
																									SUBSTRING(A.OP_START_TIME, 9, 2)+':'+
																									SUBSTRING(A.OP_START_TIME, 11, 2)+':'+
																									SUBSTRING(A.OP_START_TIME, 13, 2) AS DATETIME
																								)
																					) 
																		END AS SHIP_AVAILABLE_DATE							--2018-06-20 PIYONG ADD
																,IFSEQNO											-- 2019-09-27 PIYONG ADD
														   FROM ( 
																	SELECT DISTINCT (SELECT TOP 1 SITE_ID FROM SCM_PLANT_M WHERE PLANT_ID = PLANT) AS SITE_ID
																			,WORKDATE
																			,BUILDING
																			,ROUTE_ID
																			,LINE_ID
																			,OP_ID
																			,OP_SEQ
																			,RTRIM(LTRIM(ITEM_ID)) AS ITEM_ID
																			,TRAY_OP_STATUS
																			,OP_START_TIME
   																			,STOCK_TYPE
																			,CASE WHEN A.ATTRIBUTE3 IN ('1','2','3','4','5','6','7') THEN 'Y' ELSE WIPHOLD_YN END AS WIPHOLD_YN -- 2021-07-12 kimcd SPECIAL_CD Hold 특별관리코드 추가
																			,CASE WHEN A.ATTRIBUTE3 IN ('1','2','3','4','5','6','7') AND A.ATTRIBUTE4 IS NOT NULL THEN
																			     CASE WHEN CAST(STUFF(STUFF(STUFF(A.ATTRIBUTE4, 9, 0, ' '), 12, 0, ':'), 15,0,':') AS DATE) < UNHOLD_EXP_DATE THEN  -- 2021-07-12 kimcd SPECIAL_RELEASE_DATE	특별관리 HOLD 보류해제일 정보 추가
																				     UNHOLD_EXP_DATE
																				 ELSE CAST(STUFF(STUFF(STUFF(A.ATTRIBUTE4, 9, 0, ' '), 12, 0, ':'), 15,0,':') AS DATE) END
																			 ELSE UNHOLD_EXP_DATE END AS UNHOLD_EXP_DATE
																			,CASE WHEN A.ATTRIBUTE3 IN ('1','2','3','4','5','6','7')  THEN A.ATTRIBUTE3 ELSE SPECIAL_YN END SPECIAL_YN  -- 2021-07-12 kimcd SPECIAL_CD Hold 특별관리코드 추가
																			,LOT_ID
																			,INPUT_CELL_CNT
																			,NOW_CELL_CNT
																			,TRAY_ID
																			,CREATE_TIME
																			,OCV2_END_TIME											--2018-06-20 PIYONG ADD
																			,IFSEQNO											-- 2019-09-27 PIYONG ADD
																	  FROM XIF_DW_FCS_INVENTORY_R A	-- WITH(NOLOCK)
																	 WHERE IFSEQNO       = @V_IFSEQNO	--PIYONG 2018-07-17 DEL	-- 2020-05-04 PIYONG ADD
																	   AND TRANSFER_FLAG = 'P'
																	   AND NOW_CELL_CNT > 0				-- PIYONG 2020-02-24 ADD
																) A
																LEFT OUTER JOIN (	SELECT *				--2018-06-08 PIYONG LEFT OUTER JOIN 으로 변경
																					FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																					WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
																					AND ACTIVE_FLAG = 'Y'
																				) SSLV
																			 ON A.LINE_ID  = SSLV.SEGMENT2
																			AND A.SITE_ID = SSLV.SEGMENT1
																			AND A.BUILDING = ISNULL( SSLV.ATTRIBUTE2, SSLV.ATTRIBUTE1) -- 2021-08-10 kimcd 라인 조건 변경 - 재고용 동 우선  사용
																LEFT OUTER JOIN SCM_LINE_M LM		--2018-05-17 PIYONG  DISTINCT 제거 DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
																			 ON SSLV.SEGMENT5   = LM.LINE_ID
																			AND SSLV.SEGMENT1   = LM.SITE_ID
																			AND LM.OPERATION_ID IN ( 'F5300','F5500','F5600','F6000')	--2019-05-14 PIYONG ADD 'F5300','F5500','F5600' 
																	--	  AND LM.ACTIVE_FLAG  = 'Y'  -- 2018-05-17 kimcd  직접 outer join으로 변경		--2019-05-14 PIYONG DEL
													   ) A
													   ,SCM_FACTORY_M B
												 WHERE A.BUILDING  = B.FACTORY_ID
												   AND B.FACTORY_ID = @V_BUILDING		--SELECT FACTORY_ID FROM @TEMP_FACTORY WHERE IFSEQNO = A.IFSEQNO		--2019-09-27 PIYONG ADD --2020-05-04 PIYONG CHANGE
																			
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
																				   AND SITE_ID = @P_SITE_ID
																				   AND FACTORY_ID = @V_BUILDING	--IN ( SELECT FACTORY_ID FROM @TEMP_FACTORY )	--2019-09-27 PIYONG ADD	-- 2020-05-04 PIYONG CHANGE
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
      											   AND X.ROUTE_ID = A.ROUTE_ID
												--	AND X.LINE_ID    = A.LINE_ID	--2018-11-15 PIYONG DEL
												   AND X.OPERATION_ID = A.OP_ID
      											   AND X.OPERATION_SEQ = A.OP_SEQ
												   AND X.OPERATION_STEP = 1		-- 2019-10-11 PIYONG ADD -- 재고 정보에 STEP를 받아오기전 임시 추가
										--2018-08-13 PIYONG ADD END
									   ,DBO.SCM_FACTORY_M F 
								 WHERE A.BUILDING = F.FACTORY_ID
								   AND F.SITE_ID = CASE WHEN @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL THEN F.SITE_ID ELSE @P_SITE_ID END
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
										 AND LV.SEGMENT5 = AA.FACTORY_ID


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
								,CREATE_TIME
      							,INPUT_CELL_CNT
      							,NOW_CELL_CNT
      							,OP_ID
      							,OP_SEQ
      							,OP_START_TIME
								,AVAILABLE_DATE
      							,TRAY_OP_STATUS
								,TRAY_ID
								,STOCK_TYPE
								,WIPHOLD_YN
								,UNHOLD_EXP_DATE
								,SPECIAL_YN
								,LOT_ID
								,OCV2_END_TIME
								,SHIP_AVAILABLE_DATE
								,BEFORE_DEGAS
								,REMAIN_TIME
								,DEGAS_END_DATE
								,BASE_RATE_CNT
								,APPLY_YN
								,ROW_NUMBER() OVER ( PARTITION BY PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, ROUTE_ID, LOT_ID, BEFORE_DEGAS
															ORDER BY PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, ROUTE_ID, LOT_ID, BEFORE_DEGAS, AVAILABLE_DATE ) AS RN
								,START_TIME  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분하는 경우 시업 시간 설정
						  INTO #TEMP_FCS_INVENTORY
						  FROM #TEMP_INVENTORY

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
						   AND [SCM_AGING_TRAY_STOCK_H].SITE_ID = CASE WHEN @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL THEN [SCM_AGING_TRAY_STOCK_H].SITE_ID ELSE @P_SITE_ID END
						   AND [DBO].[SCM_AGING_TRAY_STOCK_H].insert_id = @V_PROC_NAME  -- 4.14 6A04 활성화 MES 전환에 따른 삭제로직 조건 추가
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
						SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ROUTE_ID, LINE_ID, WORKDATE
      							,ROW_NUMBER() OVER ( ORDER BY CREATE_TIME)
      							,ITEM_ID ,'' AS PRODUCTION_TYPE, CREATE_TIME AS FCS_INPUT_DATE
      							--, DATEADD(DD, REMAIN_DAYS, CREATE_TIME ) AS AVAILABLE_DATE
								/* 11-03 변경 */
								,AVAILABLE_DATE
      							,CASE WHEN REMAIN_DAYS > 0 THEN ROUND( (REMAIN_DAYS/60/24), 1) ELSE 0 END AS REMAIN_LEAD_TIME
								, null AS HOLDING_DATE
      							,SUM(INPUT_CELL_CNT) AS INPUT_QTY
      							,SUM(NOW_CELL_CNT) AS QTY
      							,MAX(UOM) AS QTY_UOM
      							,null AS STOCK_STATUS
      							,OP_ID
								,OP_SEQ
								,CONVERT(NVARCHAR(8), OP_START_TIME, 112 ) AS OP_START_TIME
								,TRAY_OP_STATUS
								,TRAY_ID
								,CREATE_TIME
								,STOCK_TYPE			--2018-04-18 PIYONG ADD
								,WIPHOLD_YN			--2018-04-18 PIYONG ADD
								,UNHOLD_EXP_DATE	--2018-04-18 PIYONG ADD
								,SPECIAL_YN			--2018-04-18 PIYONG ADD
								,LOT_ID				--2018-04-18 PIYONG ADD
								,OCV2_END_TIME			--2018-06-20 PIYONG ADD
								,SHIP_AVAILABLE_DATE	--2018-06-20 PIYONG ADD
								,BEFORE_DEGAS			-- 2018-08-13 PIYONG ADD
								,DEGAS_END_DATE			-- 2018-08-13 PIYONG ADD
								,BASE_AVAILABLE_DATE	--2018-11-07 PIYONG ADD
								,SUM(ORIGINAL_QTY)		--2018-11-29 PIYONG ADD
      							,@V_PROC_NAME
      							,GETDATE()
      							,@V_PROC_NAME
      							,GETDATE()
						  FROM (
								/*	2018-11-07 PIYONG DEL
									SELECT /*ISNULL(( SELECT ROUND(SUM(STANDARD_LT--2018-05-25 PIYONG DEL
																				--CASE WHEN DEFAULT_FLAG = 'S' AND PROCESSING_TIME > 5760 THEN
																				--			5760
																				--	  WHEN DEFAULT_FLAG = 'F' AND PROCESSING_TIME > 14400 THEN
																				--			14400
																				--	  WHEN PROCESSING_TIME >= 900000 THEN
																				--			0
																				--	  ELSE
																				--		   PROCESSING_TIME
																				--	END
																					)/60/24,0)
      												FROM [DBO].[SCM_AGING_ITEM_FLOW_M] X
													WHERE X.FACTORY_ID = A.BUILDING
													AND X.ITEM_ID    = A.ITEM_ID  --A.ITEM_ID
      												AND X.ROUTE_ID = A.ROUTE_ID
													AND X.LINE_ID    = A.LINE_ID
      												AND X.OPERATION_SEQ >= A.OP_SEQ		-- 2018-05-10 PIYONG ADD  현재 공정 포함
												),0) + ISNULL((
																SELECT ROUND(MAX(X.ROUTE_TOTAL_TIME)/60/24,0)
      																FROM [DBO].[SCM_AGING_ITEM_FLOW_M] X
																	WHERE X.FACTORY_ID = A.BUILDING
																	AND X.ITEM_ID    = A.ITEM_ID
      																AND X.ROUTE_ID = A.ROUTE_ID
																	AND X.LINE_ID    = A.LINE_ID
      														
      															),0) REMAIN_DAYS
											*/
											ISNULL( ROUND(X.REMAIN_TIME /60/24,0),0) + ISNULL( ROUND(X.ROUTE_TOTAL_TIME/60/24,0),0) AS REMAIN_DAYS		--2018-08-13 PIYONG CHANGE
      										,F.COMPANY_ID, F.DIVISION_ID, F.SITE_ID, F.PLANT_ID, F.FACTORY_ID, A.ROUTE_ID, A.LINE_ID
											,CONVERT( DATETIME,  A.WORKDATE) AS WORKDATE
      										,A.ITEM_ID
											,CASE WHEN A.CREATE_TIME != '' AND A.CREATE_TIME IS NOT NULL THEN	-- 2018-07-12 PIYONG ADD
													CONVERT(DATETIME,SUBSTRING(A.CREATE_TIME,1,8) + ' ' + SUBSTRING(A.CREATE_TIME,9,2) + ':' + SUBSTRING(A.CREATE_TIME,11,2) + ':' +SUBSTRING(A.CREATE_TIME,13,2))
													ELSE
													NULL
													END AS CREATE_TIME
      										,A.INPUT_CELL_CNT
      										,A.NOW_CELL_CNT
      										,'EA' UOM
      										,A.OP_ID
      										,A.OP_SEQ
      										,CONVERT(DATETIME,SUBSTRING( A.OP_START_TIME,1,8)) AS OP_START_TIME
      										,A.TRAY_OP_STATUS
											,A.TRAY_ID
											,A.STOCK_TYPE												-- 2018-04-18 PIYONG ADD
											,A.WIPHOLD_YN												-- 2018-04-18 PIYONG ADD
											,A.UNHOLD_EXP_DATE											-- 2018-04-18 PIYONG ADD
											,A.SPECIAL_YN												-- 2018-04-18 PIYONG ADD
											,A.LOT_ID													-- 2018-04-18 PIYONG ADD
											,A.OCV2_END_TIME											--2018-06-20 PIYONG ADD
											,A.SHIP_AVAILABLE_DATE										--2018-06-20 PIYONG ADD
											,CASE WHEN X.DEFAULT_FLAG	= 'B' THEN 'Y' ELSE 'N' END AS BEFORE_DEGAS											-- 2018-08-13 PIYONG ADD
											,CASE WHEN X.DEFAULT_FLAG	= 'B' THEN 
													DATEADD(DD, ISNULL( ROUND( X.REMAIN_TIME / 60/ 24 ,0), 0),	SUBSTRING( A.OP_START_TIME,1,8) )
													ELSE NULL END										 AS DEGAS_END_DATE										-- 2018-08-13 PIYONG ADD
										--INTO #TEMP_FCS_INV
										FROM (
												SELECT XFI.DIVISION_ID
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
													, XFI.CREATE_TIME
													, XFI.STOCK_TYPE									-- 2018-04-18 PIYONG ADD
													, XFI.WIPHOLD_YN									-- 2018-04-18 PIYONG ADD
													, XFI.UNHOLD_EXP_DATE								-- 2018-04-18 PIYONG ADD
													, XFI.SPECIAL_YN									-- 2018-04-18 PIYONG ADD
													, XFI.LOT_ID										-- 2018-04-18 PIYONG ADD
													, XFI.OCV2_END_TIME									-- 2018-06-20 PIYONG ADD
													, XFI.SHIP_AVAILABLE_DATE							-- 2018-06-20 PIYONG ADD
												FROM (
  														-- 2018-05-14 PIYONG UPDATE
  														-- 2018-05-11 PIYONG ADD
														SELECT B.DIVISION_ID
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
																, A.CREATE_TIME
																, A.OCV2_END_TIME											--2018-06-20 PIYONG ADD
																, A.SHIP_AVAILABLE_DATE										--2018-06-20 PIYONG ADD
															FROM (
																SELECT WORKDATE
																		,ISNULL(LM.FACTORY_ID, A.[BUILDING]) AS BUILDING 
																		, ROUTE_ID
																		,ISNULL(LM.[LINE_ID], A.LINE_ID ) AS LINE_ID
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
																		, A.CREATE_TIME
																		, CASE WHEN A.OCV2_END_TIME != '' AND A.OCV2_END_TIME IS NOT NULL THEN
																				CAST ( 
																								SUBSTRING(A.OCV2_END_TIME, 1, 4)+'-'+
																								SUBSTRING(A.OCV2_END_TIME, 5, 2)+'-'+
																								SUBSTRING(A.OCV2_END_TIME, 7, 2)+' '+
																								SUBSTRING(A.OCV2_END_TIME, 9, 2)+':'+
																								SUBSTRING(A.OCV2_END_TIME, 11, 2)+':'+
																								SUBSTRING(A.OCV2_END_TIME, 13, 2) AS DATETIME)
															 
																				ELSE
																				NULL
																				END OCV2_END_TIME											--2018-06-20 PIYONG ADD
																		, CASE WHEN OCV2_END_TIME != '' AND OCV2_END_TIME IS NOT NULL THEN
																				DATEADD(DD, (
																								SELECT CAST(ATTRIBUTE1 AS INT)
																								FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
																								WHERE LOOKUP_TYPE_CODE  = 'FORMATION_SHIP_EOH_EXCEPT'
																								AND SEGMENT2 = 'AGING'
																								AND SEGMENT4 = A.ITEM_ID
																							)
																							, CAST ( 
																										SUBSTRING(OCV2_END_TIME, 1, 4)+'-'+
																										SUBSTRING(OCV2_END_TIME, 5, 2)+'-'+
																										SUBSTRING(OCV2_END_TIME, 7, 2)+' '+
																										SUBSTRING(OCV2_END_TIME, 9, 2)+':'+
																										SUBSTRING(OCV2_END_TIME, 11, 2)+':'+
																										SUBSTRING(OCV2_END_TIME, 13, 2) AS DATETIME)
																										) 
																				WHEN OCV2_END_TIME = '' AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_FCS_SHIPPING_TERM_M) THEN
																				DATEADD(DD,(
																							SELECT ROUND(OCV2_TOTAL_TIME /60/24,0)
      																							FROM [DBO].[SCM_AGING_ITEM_FLOW_M] X
																								WHERE X.FACTORY_ID = A.BUILDING
																								AND X.ITEM_ID    = A.ITEM_ID
      																							AND X.ROUTE_ID = A.ROUTE_ID
																								AND X.LINE_ID    = ISNULL(LM.[LINE_ID], A.LINE_ID )
      																							AND X.OPERATION_SEQ = A.OP_SEQ
																							), CAST ( 
																										SUBSTRING(A.OP_START_TIME, 1, 4)+'-'+
																										SUBSTRING(A.OP_START_TIME, 5, 2)+'-'+
																										SUBSTRING(A.OP_START_TIME, 7, 2)+' '+
																										SUBSTRING(A.OP_START_TIME, 9, 2)+':'+
																										SUBSTRING(A.OP_START_TIME, 11, 2)+':'+
																										SUBSTRING(A.OP_START_TIME, 13, 2) AS DATETIME)
																									) 
																				END AS SHIP_AVAILABLE_DATE							--2018-06-20 PIYONG ADD
																	FROM ( SELECT (SELECT TOP 1 SITE_ID FROM SCM_PLANT_M WHERE PLANT_ID = PLANT) AS SITE_ID
																				, WORKDATE
																				, BUILDING
																				, ROUTE_ID
																				, LINE_ID
																				, OP_ID
																				, OP_SEQ
																				, RTRIM(LTRIM(ITEM_ID)) AS ITEM_ID
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
																				, CREATE_TIME
																				, OCV2_END_TIME											--2018-06-20 PIYONG ADD
																			FROM XIF_DW_FCS_INVENTORY_R A WITH(NOLOCK)
																			WHERE 1=1 --IFSEQNO       = @V_IFSEQNO	 --PIYONG 2018-07-17 DEL
																			AND TRANSFER_FLAG = 'P'			 
																		)A
																	LEFT OUTER JOIN (SELECT *				 --2018-06-08 PIYONG LEFT OUTER JOIN 으로 변경
																					FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																					WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
																						AND ACTIVE_FLAG = 'Y') SSLV
																				ON A.LINE_ID  = SSLV.SEGMENT2
																				AND A.SITE_ID = SSLV.SEGMENT1
																	LEFT OUTER JOIN SCM_LINE_M LM		--2018-05-17 PIYONG  DISTINCT 제거 DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
																				ON SSLV.SEGMENT5   = LM.LINE_ID
																				AND SSLV.SEGMENT1   = LM.SITE_ID
																				AND LM.OPERATION_ID = 'F6000'
																				AND LM.ACTIVE_FLAG  = 'Y'  -- 2018-05-17 kimcd  직접 outer join으로 변경
																) A
																,SCM_FACTORY_M B
														WHERE A.BUILDING  = B.FACTORY_ID
														-- 2018-05-11 PIYONG ADD  끝
														-- 2018-05-14 PIYONG UPDATE 끝
													) XFI
													--2018-04-18 PIYONG ADD 시작
													,(
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
																	FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
																	WHERE ROUTE_TYPE = 'D'
																	AND SITE_ID = @P_SITE_ID
																) A
															WHERE NUM = 1
													) SIF
													--2018-04-18 PIYONG ADD  끝
												WHERE XFI.DIVISION_ID = SIF.DIVISION_ID
												AND XFI.PLANT = SIF.PLANT_ID
												AND XFI.BUILDING = SIF.FACTORY_ID
												AND XFI.ITEM_ID =SIF.ITEM_ID
      											) A
							/*										,(
												SELECT MAX(SR.IFSEQNO) AS IFSEQNO, SR.WORKDATE, SR.BUILDING
													FROM [dbo].[XIF_DW_FCS_INVENTORY_R] SR
												WHERE TRANSFER_FLAG = 'P'
													AND IFSEQNO = @V_IFSEQNO
		  											AND ATTRIBUTE1 = 'TRAY'		--2017-11-10 PIYONG 추가
												--WHERE WORKDATE = '20161031'
												GROUP BY SR.WORKDATE, SR.BUILDING
											) SR2
							*/
											--2018-08-13 PIYONG ADD
											LEFT OUTER JOIN [SCM_AGING_ITEM_FLOW_M] X
													ON X.FACTORY_ID = A.BUILDING
													AND X.ITEM_ID    = A.ITEM_ID
      												AND X.ROUTE_ID = A.ROUTE_ID
													AND X.LINE_ID    = A.LINE_ID
													AND X.OPERATION_ID = A.OP_ID
      												AND X.OPERATION_SEQ = A.OP_SEQ
											--2018-08-13 PIYONG DEL

      										,DBO.SCM_FACTORY_M F 
										WHERE A.BUILDING = F.FACTORY_ID
							--									AND A.IFSEQNO = SR2.IFSEQNO
							--									AND A.WORKDATE = SR2.WORKDATE
							--									AND A.BUILDING = SR2.BUILDING
										AND F.SITE_ID = CASE WHEN @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL THEN F.SITE_ID else @P_SITE_ID END
									*/
								---------------------------------------------------------------------------------------------------------------
								--2018-11-07 PIYONG ADD
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
										,CREATE_TIME
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
										,OCV2_END_TIME
										,SHIP_AVAILABLE_DATE
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
									FROM #TEMP_FCS_INVENTORY A
								--2018-11-07 PIYONG ADD END
								---------------------------------------------------------------------------------------------------------------
							) A
					  GROUP BY  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
						    ,ROUTE_ID, LINE_ID, WORKDATE, ITEM_ID, CREATE_TIME
						    ,AVAILABLE_DATE
      						,CASE WHEN REMAIN_DAYS > 0 THEN ROUND( (REMAIN_DAYS/60/24), 1) ELSE 0 END
							,OP_ID, OP_SEQ, CONVERT(NVARCHAR(8), OP_START_TIME, 112 ) , TRAY_OP_STATUS
							-- 2018-04-18 PIYONG ADD
						    ,TRAY_ID, STOCK_TYPE,WIPHOLD_YN, UNHOLD_EXP_DATE, SPECIAL_YN
							,LOT_ID
							--2018-06-20 PIYONG ADD
							,OCV2_END_TIME, SHIP_AVAILABLE_DATE
							-- 2018-08-13 PIYONG ADD
							,BEFORE_DEGAS, DEGAS_END_DATE
							,BASE_AVAILABLE_DATE	--2018-11-07 PIYONG ADD
						;
				--2017-11-10 PIYONG  추가  FCS 출문 정보  입력 끝
				---------------------------------------------------

			/*			
						IF OBJECT_ID('tempdb..#TEMP_FCS_INV') IS NOT NULL
							DROP TABLE #TEMP_FCS_INV


      					SELECT FACTORY_ID, ITEM_ID, ROUTE_ID, LINE_ID, ROUTE_TYPE,OPERATION_ID, OPERATION_SEQ, PROCESSING_TIME , ROUTE_TOTAL_TIME
						  INTO #TEMP_FCS_INV
      					  FROM (
      							SELECT FACTORY_ID, ITEM_ID, ROUTE_ID, LINE_ID, OPERATION_ID, OPERATION_SEQ, PROCESSING_TIME, ROUTE_TYPE, ROUTE_TOTAL_TIME
      									,ROW_NUMBER() OVER ( PARTITION BY ITEM_ID, ROUTE_ID, LINE_ID   ORDER BY OPERATION_SEQ DESC ) LAST_OP
      								FROM [DBO].[SCM_AGING_ITEM_FLOW_M] 
      						   ) W
      					 WHERE ( ( LAST_OP = 1 AND  PROCESSING_TIME < 900000)
      						OR LAST_OP <> 1 )
						;

						--	2018.03.08 PIYONG	DEFAULT_FLAG  Y,N -> S, F
						--  2018.04.19 PIYONG	삭제     
						SELECT FACTORY_ID, ITEM_ID, ROUTE_ID, LINE_ID, OPERATION_ID, OPERATION_SEQ, ROUTE_TYPE, ROUTE_TOTAL_TIME
							   , CASE WHEN DEFAULT_FLAG = 'S' AND PROCESSING_TIME > 5760 THEN
											5760
									  WHEN DEFAULT_FLAG = 'F' AND PROCESSING_TIME > 14400 THEN
											14400
									  WHEN PROCESSING_TIME >= 900000 THEN
											0
									  ELSE
										PROCESSING_TIME
								  END PROCESSING_TIME
						  INTO #TEMP_FCS_INV
						 FROM [DBO].[SCM_AGING_ITEM_FLOW_M]
						;
			*/      

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
						   AND [SCM_AGING_STOCK_H].SITE_ID = CASE WHEN @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL THEN [SCM_AGING_STOCK_H].SITE_ID ELSE @P_SITE_ID END
						   AND [SCM_AGING_STOCK_H].insert_id = @V_PROC_NAME			-- 4.14 6A04 활성화 MES 전환에 따른 삭제로직 조건 추가
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
						SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ROUTE_ID, LINE_ID, WORKDATE
      							,ROW_NUMBER() OVER ( ORDER BY WORKDATE)
      							,ITEM_ID,'' PRODUCTION_TYPE,  NULL AS FCS_INPUT_DATE
      						--, DATEADD(DD, REMAIN_DAYS, CREATE_TIME ) AS AVAILABLE_DATE
							/* 11-03 변경 */
								,AVAILABLE_DATE
      							,CASE WHEN REMAIN_DAYS > 0 THEN ROUND( (REMAIN_DAYS/60/24), 1) ELSE 0 END AS REMAIN_LEAD_TIME
								,null HOLDING_DATE
      							,SUM(INPUT_CELL_CNT) INPUT_QTY
      							,SUM(NOW_CELL_CNT) QTY
      							,MAX(UOM) QTY_UOM
      							,null STOCK_STATUS
      							,OP_ID
								,OP_SEQ
								,CONVERT(NVARCHAR(8), OP_START_TIME, 112 ) AS OP_START_TIME
								,TRAY_OP_STATUS
								,STOCK_TYPE			--2018-04-18 PIYONG ADD
								,WIPHOLD_YN			--2018-04-18 PIYONG ADD
								,UNHOLD_EXP_DATE		--2018-04-18 PIYONG ADD
								,SPECIAL_YN			--2018-04-18 PIYONG ADD
								,A.LOT_ID				--2018-04-30 PIYONG ADD
								,A.OCV2_END_TIME			--2018-06-20 PIYONG ADD
								,A.SHIP_AVAILABLE_DATE	--2018-06-20 PIYONG ADD
								,A.BEFORE_DEGAS			--2018-08-13 PIYONG ADD
								,A.DEGAS_END_DATE			--2018-08-13 PIYONG ADD
								,A.BASE_AVAILABLE_DATE	--2018-11-07 PIYONG ADD
								,SUM(ORIGINAL_QTY)		--2018-11-29 PIYONG ADD
      							,@V_PROC_NAME
      							,GETDATE()
      							,@V_PROC_NAME
      							,GETDATE()
						  FROM (
			/*
								-------------------------------------------------------------------------------------------------------------------------------------------------------------------
								--2018-11-07 PIYONG DELL

								SELECT /*ISNULL(( SELECT ROUND(SUM( STANDARD_LT --2018-05-25 PIYONG DEL
																				--CASE WHEN DEFAULT_FLAG = 'S' AND PROCESSING_TIME > 5760 THEN
																					-- 5760
																					--WHEN DEFAULT_FLAG = 'F' AND PROCESSING_TIME > 14400 THEN
																					-- 14400
																					--WHEN PROCESSING_TIME >= 900000 THEN
																					--	0
																					--ELSE
																					--	PROCESSING_TIME
																					-- END
																		)/60/24,0)
      												FROM [DBO].[SCM_AGING_ITEM_FLOW_M] X
													WHERE X.FACTORY_ID = A.BUILDING
													AND X.ITEM_ID    = A.ITEM_ID  --A.ITEM_ID
      												AND X.ROUTE_ID = A.ROUTE_ID
													AND X.LINE_ID    = A.LINE_ID
      												AND X.OPERATION_SEQ >= A.OP_SEQ		-- 2018-05-10 PIYONG ADD  현재 공정 포함
													),0) + ISNULL(( SELECT ROUND(MAX(X.ROUTE_TOTAL_TIME)/60/24,0)
      																	FROM [DBO].[SCM_AGING_ITEM_FLOW_M] X
																	WHERE X.FACTORY_ID = A.BUILDING
																		AND X.ITEM_ID    = A.ITEM_ID --A.ITEM_ID
      																	AND X.ROUTE_ID = A.ROUTE_ID
																		AND X.LINE_ID    = A.LINE_ID
      												),0) REMAIN_DAYS
										*/
										ISNULL( ROUND(X.REMAIN_TIME /60/24,0),0) + ISNULL( ROUND(X.ROUTE_TOTAL_TIME/60/24,0),0) AS REMAIN_DAYS		--2018-08-13 PIYONG CHANGE
      									,F.COMPANY_ID, F.DIVISION_ID, F.SITE_ID, F.PLANT_ID, F.FACTORY_ID, A.ROUTE_ID, A.LINE_ID
										,CONVERT( DATETIME,  A.WORKDATE) AS WORKDATE
      									,A.ITEM_ID
      									,A.INPUT_CELL_CNT
      									,A.NOW_CELL_CNT
      									,'EA' UOM
      									,A.OP_ID
      									,A.OP_SEQ
      									,CONVERT(DATETIME,SUBSTRING( A.OP_START_TIME,1,8)) AS OP_START_TIME
      									,A.TRAY_OP_STATUS
										,A.STOCK_TYPE			--2018-04-18 PIYONG ADD
										,A.WIPHOLD_YN			--2018-04-18 PIYONG ADD
										,A.UNHOLD_EXP_DATE		--2018-04-18 PIYONG ADD
										,A.SPECIAL_YN			--2018-04-18 PIYONG ADD
										,A.LOT_ID				--2018-04-30 PIYONG ADD
										,CASE WHEN A.OCV2_END_TIME != '' AND A.OCV2_END_TIME IS NOT NULL THEN
													CAST ( 
																	SUBSTRING(A.OCV2_END_TIME, 1, 4)+'-'+
																	SUBSTRING(A.OCV2_END_TIME, 5, 2)+'-'+
																	SUBSTRING(A.OCV2_END_TIME, 7, 2)+' '+
																	SUBSTRING(A.OCV2_END_TIME, 9, 2)+':'+
																	SUBSTRING(A.OCV2_END_TIME, 11, 2)+':'+
																	SUBSTRING(A.OCV2_END_TIME, 13, 2) AS DATETIME)
															 
												ELSE
													NULL
												END OCV2_END_TIME		--2018-06-20 PIYONG ADD
										,CASE WHEN A.OCV2_END_TIME != '' AND A.OCV2_END_TIME IS NOT NULL THEN
												DATEADD(DD, (
																SELECT CAST(ATTRIBUTE1 AS INT)
																FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
																WHERE LOOKUP_TYPE_CODE  = 'FORMATION_SHIP_EOH_EXCEPT'
																AND SEGMENT2 = 'AGING'
																AND SEGMENT4 = A.ITEM_ID )
															, CAST ( 
																	SUBSTRING(A.OCV2_END_TIME, 1, 4)+'-'+
																	SUBSTRING(A.OCV2_END_TIME, 5, 2)+'-'+
																	SUBSTRING(A.OCV2_END_TIME, 7, 2)+' '+
																	SUBSTRING(A.OCV2_END_TIME, 9, 2)+':'+
																	SUBSTRING(A.OCV2_END_TIME, 11, 2)+':'+
																	SUBSTRING(A.OCV2_END_TIME, 13, 2) AS DATETIME)
																	) 
												WHEN A.OCV2_END_TIME = '' AND A.ITEM_ID IN (SELECT ITEM_ID FROM SCM_FCS_SHIPPING_TERM_M) THEN
												DATEADD(DD, ROUND(X.OCV2_TOTAL_TIME /60/24,0)
														/*	--2018-08-13 PIYONG DEL
																SELECT ROUND(OCV2_TOTAL_TIME /60/24,0)
      															FROM [DBO].[SCM_AGING_ITEM_FLOW_M] X
																WHERE X.FACTORY_ID = A.BUILDING
																AND X.ITEM_ID    = A.ITEM_ID
      															AND X.ROUTE_ID = A.ROUTE_ID
																AND X.LINE_ID    = A.LINE_ID
      															AND X.OPERATION_SEQ = A.OP_SEQ )
														*/
															, CAST ( 
																	SUBSTRING(A.OP_START_TIME, 1, 4)+'-'+
																	SUBSTRING(A.OP_START_TIME, 5, 2)+'-'+
																	SUBSTRING(A.OP_START_TIME, 7, 2)+' '+
																	SUBSTRING(A.OP_START_TIME, 9, 2)+':'+
																	SUBSTRING(A.OP_START_TIME, 11, 2)+':'+
																	SUBSTRING(A.OP_START_TIME, 13, 2) AS DATETIME)
																	) 
												END AS SHIP_AVAILABLE_DATE	--2018-06-20 PIYONG ADD
										,CASE WHEN X.DEFAULT_FLAG	= 'B' THEN 'Y' ELSE 'N' END AS BEFORE_DEGAS											-- 2018-08-13 PIYONG ADD
										,CASE WHEN X.DEFAULT_FLAG	= 'B' THEN 
												DATEADD(DD, ISNULL( ROUND( X.REMAIN_TIME / 60/ 24 ,0), 0),	SUBSTRING( A.OP_START_TIME,1,8) )
												ELSE NULL END										 AS DEGAS_END_DATE										-- 2018-08-13 PIYONG ADD
									--INTO #TEMP_FCS_INV
								  FROM #TEMP_FCS_INVENTORY A WITH(NOLOCK)
					--2018-11-07 PIYONG DEL END
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
			*/
			/*						   , (SELECT MAX(SR.IFSEQNO) AS IFSEQNO, SR.WORKDATE, SR.BUILDING
											FROM [dbo].[XIF_DW_FCS_INVENTORY_R] SR
										   WHERE TRANSFER_FLAG = 'P'
											 AND IFSEQNO = @V_IFSEQNO
											--WHERE WORKDATE = '20161031'
											GROUP BY SR.WORKDATE, SR.BUILDING  ) SR2								*/
			/*
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
					--2018-11-07 PIYONG DEL
										--2018-08-13 PIYONG ADD
									   LEFT OUTER JOIN [SCM_AGING_ITEM_FLOW_M] X
													ON X.FACTORY_ID = A.FACTORY_ID
												   AND X.ITEM_ID    = A.ITEM_ID
      											   AND X.ROUTE_ID = A.ROUTE_ID
												   AND X.LINE_ID    = A.LINE_ID
												   AND X.OPERATION_ID = A.OP_ID
      											   AND X.OPERATION_SEQ = A.OP_SEQ
										--2018-08-13 PIYONG ADD END
      								   ,DBO.SCM_FACTORY_M F 
								 WHERE A.FACTORY_ID = F.FACTORY_ID
								   AND F.SITE_ID = CASE WHEN @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL THEN F.SITE_ID ELSE @P_SITE_ID END
								   AND A.IFSEQNO = SR2.IFSEQNO
								   AND A.WORKDATE = SR2.WORKDATE
								   AND A.BUILDING = SR2.BUILDING
								   AND A.IFSEQNO = @V_IFSEQNO
								   AND A.ATTRIBUTE1 IS NULL		--2017-11-10 PIYONG 추가	
					--2018-11-07 PIYONG DEL END
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
			*/
										--2018-11-07 PIYONG ADD
								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ROUTE_ID, A.LINE_ID
										,A.WORKDATE
      									,A.ITEM_ID
										,CASE WHEN APPLY_YN = 'N' AND PLANT_ID IN ( 'A040' ) THEN 0 ELSE INPUT_CELL_CNT END AS INPUT_CELL_CNT	--2019-10-23 PIYONG CHEANGE CASE 문 추가
										,CASE WHEN APPLY_YN = 'N' AND A.PLANT_ID IN ( 'A040' ) THEN 0 ELSE A.NOW_CELL_CNT END NOW_CELL_CNT		--2018-11-29 PIYONG CHEANGE CASE 문 추가
      									,'EA' UOM
      									,A.OP_ID
      									,A.OP_SEQ
										,A.REMAIN_DAYS
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
      									,A.TRAY_OP_STATUS
										,A.STOCK_TYPE
										,A.WIPHOLD_YN
										,A.UNHOLD_EXP_DATE
										,A.SPECIAL_YN
										,A.LOT_ID
										,A.OCV2_END_TIME
										,A.SHIP_AVAILABLE_DATE
										,A.BEFORE_DEGAS
										,A.DEGAS_END_DATE
										,A.REMAIN_TIME
										,CASE WHEN START_TIME IS NULL THEN
											 CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
										 ELSE
											 CASE WHEN SUBSTRING(CONVERT(NVARCHAR(20), AVAILABLE_DATE, 120), 12,8) > A.START_TIME THEN
												 CONVERT(NVARCHAR(8), DATEADD(D,1,AVAILABLE_DATE), 112)
											 ELSE
												 CONVERT(NVARCHAR(8), AVAILABLE_DATE, 112)
											 END
										 END AS BASE_AVAILABLE_DATE  -- 2020-10-17 kimcd 시업 시간 기준으로 일자 구분 로직 추가	--2018-11-07 PIYONG ADD
										,INPUT_CELL_CNT AS ORIGINAL_IN_QTY									-- 2019-10-23 PIYONG ADD
										,A.NOW_CELL_CNT AS  ORIGINAL_QTY									--2018-11-29 PIYONG ADD
								  FROM #TEMP_FCS_INVENTORY A
							   ) A
						 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ROUTE_ID, LINE_ID, WORKDATE,ITEM_ID	--, CREATE_TIME, DATEADD(DD, REMAIN_DAYS, CREATE_TIME) 
								,OP_ID,CONVERT(NVARCHAR(8), OP_START_TIME, 112 ), OP_SEQ, TRAY_OP_STATUS
								,AVAILABLE_DATE
      							,CASE WHEN REMAIN_DAYS > 0 THEN ROUND( (REMAIN_DAYS/60/24), 1) ELSE 0 END
								--2018-04-18 PIYONG ADD
								,STOCK_TYPE, WIPHOLD_YN, UNHOLD_EXP_DATE, SPECIAL_YN
								,LOT_ID							--2018-04-30 PIYONG ADD
				  				--2018-06-20 PIYONG ADD
								,A.OCV2_END_TIME, A.SHIP_AVAILABLE_DATE
				  				--2018-08-13 PIYONG ADD
								,A.BEFORE_DEGAS ,A.DEGAS_END_DATE
								,BASE_AVAILABLE_DATE	--2018-11-07 PIYONG ADD
							;

						FETCH NEXT FROM CUR INTO @V_IFSEQNO
												 , @V_BUILDING
						;

					END;

					CLOSE CUR;
					DEALLOCATE CUR;  

					SET @ROWCOUNT = @@ROWCOUNT

			 END;
	
			 UPDATE [dbo].[XIF_DW_FCS_INVENTORY_R]
				SET TRANSFER_FLAG = 'Y'
				   ,TRANSFER_DATE = GETDATE()
			  WHERE TRANSFER_FLAG = 'P'
		--		AND IFSEQNO = @V_IFSEQNO	--PIYONG 2018-07-17 DEL
			  ;


		-- ================================================
		-- 작업 END
		-- ================================================
		COMMIT TRAN

		--EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END', @ROWCOUNT, @V_TEMP1, '############### END OF PROCEDURE ###############', NULL, @SYSDATE
		
	END TRY

	BEGIN CATCH

	   ROLLBACK TRAN

		SET @V_DESCR = ERROR_MESSAGE()
	--	EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'ERROR', NULL, @V_TEMP2, NULL, @V_DESCR, @SYSDATE

	END CATCH

END