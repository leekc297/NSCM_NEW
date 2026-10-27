
CREATE PROCEDURE [dbo].[PR_XIF_DW_INVENTORY_R]

-- ================================================================================================
-- Program ID          : FP00974 
-- Program Name        : PR_XIF_DW_INVENTORY_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : DW GMES
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_INVENTORY_R
-- Destination Table   : SCM_STOCK_H
--
-- Create Date		   : 2018.02.13
-- Update Date		   : 2018.02.22 1.1 PIYONG
--						 2018.03.05 1.2 PIYONG 
--						 2018.03.16 1.3 PIYONG
--						 2018.03.21 1.4 PIYONG
--						 2018.04.16 1.5 PIYONG
--						 2018.05.03 2.0 PIYONG
--						 2018.05.25 3.0 PIYONG
--						 2018.07.17 3.1 PIYONG
--						 2018.07.26 3.2 PIYONG
--						 2018.08.29 3.3 PIYONG
--						 2018.09.27 3.4 PIYONG
--						 2018.10.04	3.5 PIYONG
--						 2019.01.15 3.6 PIYONG
--						 2019.01.24 3.7 PIYONG
--						 2019.07.05 3.8 PIYONG
--						 2019.08.19 3.9 PIYONG
--                       2020.05.13 3.91 KIMCD
--						 2020.05.20 3.10 PIYONG

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 AVAILABLE_DATE 변경
--							 출하 가능일자 있으면 출하가능일자로 입력
--						 1.2 포장재고 출하가능일자 추가
--						 1.3 FP_APPLY_WIPQTY 컬럼에 QTY가 입력
--						 1,4 AVAILABLE_DATE 생성 조건 추가 OUTDTM = 'null'
--						 1.5 WIPHOLD_YN  추가
--						 2.0 SCM_STOCK_H 테이블에 SHIP_AVAILABLE_DATE, RELEASE_DUE_DATE 컬럼 추가						
--							 데이터 생성 QUERY 변경
--						 3.0 기본 데이터 생성 쿼리 변경 
--						 3.1 조건에서 IFSEQNO 제거
--						 3.2 장기재고 추가
--						 3.3 소형 재고 등급, 공정 정보 추가
--						 3.4 FP_APPLY_OPERATION_ID 정보 추가
--						 3.5 OUTDTM 생성시 N2_1_SHIP_AVAILABLE_DATE 조건 추가
--						 3.6 양품 수량 조회 조건 변경
--						 3.7 장기재고 만 있을경우 조건 추가
--						 3.8 포장(310T) 창고에서 팩(210P) 창고로 이동중  재고 추가
--						 3.9 포장(310T) 창고에서 팩(210P) 창고로 이동중  재고 일 경우 FACTORY_ID, LINE_ID의 값을 도착지 값으로 생성
--                       3.91 2020-05-13 kimcd 이동 중 정보의 fp_apply_operation_id를 fp 공정 기준으로 입력
--						 3.10 COMPANY_ID, DIVISION_ID, PLANT_ID 생성 로직 변경
-- ================================================================================================

-- ERP요청 SEQNO
@P_IFSEQNO NVARCHAR(50) = 'NULL'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_INVENTORY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
--	DECLARE @seq_cnt     NUMERIC(20,10) = 0;	-- 2019-04-15 piyong DEL


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
		  
			--UPDATE [LGCE_INF].[dbo].[XIF_ERP_INVENTORY_R] SET TRANSFER_FLAG = 'N' WHERE IFSEQNO = '2016112407011595'
			IF @P_IFSEQNO = 'NULL' OR @P_IFSEQNO IS NULL
			   SET @P_IFSEQNO = (
								 SELECT MAX(IFSEQNO)
								   FROM [dbo].[SY_XIF_DW_INVENTORY_R] WITH(NOLOCK)
								  WHERE TRANSFER_FLAG = 'N'
								)
			IF @P_IFSEQNO != 'NULL' AND @P_IFSEQNO IS NOT NULL
				BEGIN
					UPDATE [dbo].[SY_XIF_DW_INVENTORY_R]
					   SET TRANSFER_FLAG = 'P'
					 WHERE 1=1 --IFSEQNO       = @P_IFSEQNO	 --PIYONG 2018-07-17 DEL
					   AND TRANSFER_FLAG = 'N'
					;

/*					--2019-05-24 PIYONG DEL
					-- CUTOFF_DATE 기준으로 삭제
					DELETE FROM [dbo].[SCM_STOCK_H]
					 WHERE CUTOFF_DATE = CONVERT(nvarchar(10), GETDATE() , 120)
					   AND COMPANY_ID IN ( SELECT DISTINCT COMPANY
											 FROM [dbo].[SY_XIF_DW_INVENTORY_R] A WITH(NOLOCK)
											WHERE 1=1 --IFSEQNO       = @P_IFSEQNO	 --PIYONG 2018-07-17 DEL
											  AND TRANSFER_FLAG = 'P'
										 )
					   AND STOCK_TYPE = 'DW'

					-- 2019-04-15 piyong DEL
					SET @seq_cnt  = ( 
									  SELECT ISNULL(MAX(SEQ), 0) +1
										FROM [SCM_STOCK_H]
									   WHERE CUTOFF_DATE =  CONVERT(nvarchar(10), GETDATE() , 120)
										 AND SITE_ID = (
														SELECT TOP 1 C.SITE_ID
														  FROM [dbo].[SCM_PLANT_M] C
														 WHERE C.PLANT_ID = (
																			 SELECT TOP 1 [PLANT_ID]
																			   FROM [dbo].[SY_XIF_DW_INVENTORY_R]
																			  WHERE TRANSFER_FLAG = 'P'
																			)
														)
									    AND STOCK_TYPE = 'DW'
									)
*/

					INSERT INTO [dbo].[SCM_STOCK_H]
					(
						[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[LINE_ID]
						,[STORAGE_ID]
						,[CUTOFF_DATE]
						,[SEQ]
						,[STOCK_TYPE]
						,[ITEM_ID]
						,[PRODUCTION_TYPE]
						,[AVAILABLE_DATE]
						,[REMAIN_LEAD_TIME]
						,[HOLDING_DATE]
						,[QTY]
						,[QTY2]
						,[QTY_UOM]
						,[STOCK_STATUS]
						,[OPERATION_ID]
						,[OUTSOURCING_FLAG]
						,[OUTSOURCING_FACTORY]
						,[FP_APPLY_ITEM_ID]
						,[FP_APPLY_WIPQTY]		--	2018.03.16 PIYONG ADD
						,[WIPHOLD_YN]			--	2018-04-16 PIYONG ADD
						,[SHIP_AVAILABLE_DATE]	--	2018-05-03 PIYONG ADD
						,[RELEASE_DUE_DATE]		--	2018-05-03 PIYONG ADD
						,[LONG_TERM_QTY]		--  2018-07-26 PIYONG ADD
						,[CAPA_GRD_CODE]			--  2018-08-29 PIYONG ADD
						,[VLTG_GRD_CODE]			--  2018-08-29 PIYONG ADD
						,[RSST_GRD_CODE]			--  2018-08-29 PIYONG ADD
						,[FP_APPLY_OPERATION_ID]	--  2018-09-27 PIYONG ADD
						,[PACK_MOVE_QTY]			--  2019-07-05 PIYONG ADD
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
						   , LINE_ID									--  2018-08-29 PIYONG ADD
						   , STORAGE_ID
   						   , CONVERT(nvarchar(10), GETDATE() , 120) AS [CUTOFF_DATE]
						   , SEQ
						   , 'DW' AS [STOCK_TYPE]
						   , [ITEM_ID]
						   , NULL  AS [PRODUCTION_TYPE]
							-- 2018-05-03 PIYONG 변경 
						   , CASE WHEN UNHOLD_EXP_DATE IS NULL THEN EX_DATE		-- RELEASE예정일 값이 없을경우 가용일 입력		-- 2018-10-04 PIYONG OUTDTM->EX_DATE
								  WHEN EX_DATE >= UNHOLD_EXP_DATE THEN EX_DATE	-- 예정일이 RELEASE예정일 이후 일 경우  가용일 입력-- 2018-10-04 PIYONG OUTDTM->EX_DATE
								  ELSE UNHOLD_EXP_DATE							--기본으로 RELEASE예정일 입력
								   END							    AS AVAILABLE_DATE
						   , 0 AS [REMAIN_LEAD_TIME]
						   , GETDATE() AS [HOLDING_DATE]
						   , QTY + LONG_TERM_QTY AS QTY				 	--  2018-07-26 PIYONG CHANGE  LONG_TERM_QTY +
						   , QTY + LONG_TERM_QTY AS QTY2				--  2018-07-26 PIYONG CHANGE  LONG_TERM_QTY +
						   , QTY_UOM
						   , NULL AS [STOCK_STATUS]
						   , ISNULL(PROCID, '-') AS [OPERATION_ID]		--  2018-08-29 PIYONG CHANGE '-' -> ISNULL(PROCID, '-')
						   , '-' AS [OUTSOURCING_FLAG]
						   , OUTSOURCING_FACTORY
						   , [ITEM_ID] AS [FP_APPLY_ITEM_ID]
						   , QTY + LONG_TERM_QTY AS [FP_APPLY_WIPQTY]	--  2018-07-26 PIYONG CHANGE  LONG_TERM_QTY +
						   , HOLD_YN AS [WIPHOLD_YN]
						   , OUTDTM AS SHIP_AVAILABLE_DATE				--	2018-05-03 PIYONG ADD
   						   , UNHOLD_EXP_DATE AS RELEASE_DUE_DATE		--	2018-05-03 PIYONG ADD
						   , LONG_TERM_QTY								--  2018-07-26 PIYONG ADD	장기재고
						   , CAPA_GRD_CODE								--  2018-08-29 PIYONG ADD
						   , VLTG_GRD_CODE								--  2018-08-29 PIYONG ADD
						   , RSST_GRD_CODE								--  2018-08-29 PIYONG ADD
						   , CASE WHEN PACK_MOVE_QTY > 0 THEN
						         ISNULL((SELECT TOP 1  CASE WHEN SLV.SEGMENT4 IN ('PRE',  'STATUS') THEN PROCID ELSE ISNULL( SLV.SEGMENT4, PROCID) END
								         FROM   SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
										 WHERE  SLV.LOOKUP_TYPE_CODE = 'WIP_OPERATION_STOCK_MAP'
										 AND    SLV.ACTIVE_FLAG = 'Y'
										 AND    SLV.SEGMENT1 = PROCID
										 AND    SLV.SEGMENT3 IN ( 'IN', 'INOUT'))
								       , PROCID )
						     ELSE
						         PROCID
							 END AS [FP_APPLY_OPERATION_ID]			    --  2020-05-13 kimcd 이동중 수량이 존재하는 경우 해당 공정의 FP apply operation_id로 전환  2018-09-27 PIYONG ADD
						   , PACK_MOVE_QTY								--  2019-07-05 PIYONG ADD	310T 창고 -> 210P 창고로 이동중 재고
   						   ,'PR_XIF_DW_INVENTORY_R'
						   , GETDATE()
						   , 'PR_XIF_DW_INVENTORY_R'
						   , GETDATE()
					  FROM (
							SELECT A.COMPANY_ID
								   ,A.DIVISION_ID
								   ,(SELECT TOP 1 C.SITE_ID
									   FROM [dbo].[SCM_PLANT_M] C
									  WHERE C.PLANT_ID = A.PLANT_ID) AS SITE_ID
								   ,A.PLANT_ID
								   ,CASE WHEN A.FACTORY_ID IS NULL THEN '-'
										 ELSE A.FACTORY_ID
										 END						 AS FACTORY_ID
								   ,A.LINE_ID															--  2018-08-29 PIYONG ADD
								   ,CASE WHEN A.STORAGE_ID = '' THEN '-'
										 ELSE A.STORAGE_ID END		 AS STORAGE_ID
								   ,A.SEQ
								   ,A.[ITEM_ID] 
								   ,CASE WHEN OUTDTM = '' OR OUTDTM IS NULL OR OUTDTM = 'null' THEN		--	2018-03-21 PIYONG ADD OUTDTM = 'null'
											CONVERT( DATETIME, CONVERT(NVARCHAR(8),GETDATE(), 112) + CASE WHEN A.[EX_TIME] = '' THEN
																											(
																												SELECT TOP 1 CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																												  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
																												 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																												   AND V.ACTIVE_FLAG = 'Y'
																												   AND V.SEGMENT1 = A.PLANT_ID
																											) 
																										  ELSE
																											' ' + SUBSTRING(A.[EX_TIME],1,2) + ':' + SUBSTRING(A.[EX_TIME],3,2) + ':' +SUBSTRING(A.[EX_TIME],5,2)
																										  END
													)
										--2018-02-22 PIYONG ADD
										 ELSE
											CONVERT( DATETIME, REPLACE(OUTDTM,'/','') + (
																							SELECT TOP 1 CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																							  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
																							 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																							   AND V.ACTIVE_FLAG = 'Y'
																							   AND V.SEGMENT1 = A.PLANT_ID
																						)
													)
										--2018-02-22 PIYONG ADD END
										 END AS OUTDTM
									-----------------------------------------------
									--2018-05-25 PIYONG 변경
								   ,CASE WHEN HOLD_YN = 'Y' THEN
											CAST(A.HOLD_QTY AS NUMERIC(20,10))
										 ELSE
											CAST(A.QTY AS NUMERIC(20,10))
										 END  AS QTY
									--2018-05-25 PIYONG 변경 끝
									-----------------------------------------------
								   ,A.QTY_UOM
								   ,A.OUTSOURCING_FACTORY
								   ,A.HOLD_YN --	2018-04-16 PIYONG ADD
									--	2018-05-03 PIYONG ADD 시작
								   ,CASE WHEN A.UNHOLD_EXP_DATE = '' OR A.UNHOLD_EXP_DATE = 'null--' THEN  NULL
										 WHEN LEN(A.UNHOLD_EXP_DATE) = 10 THEN	-- DW에  QMS에서 HOLD예정일경우 시간정보가 없어 시업 시간 기준으로 생성
												CONVERT(DATETIME, A.UNHOLD_EXP_DATE + (
																						SELECT TOP 1 CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																						  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
																						 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																						   AND V.ACTIVE_FLAG = 'Y'
																						   AND V.SEGMENT1 = A.PLANT_ID
																					  ) 
														)
										 ELSE A.UNHOLD_EXP_DATE 
										  END					  AS UNHOLD_EXP_DATE
									--	2018-05-03 PIYONG ADD 끝
								   ,LONG_TERM_QTY								--  2018-07-26 PIYONG ADD
								   ,A.PROCID									--  2018-08-29 PIYONG ADD
								   ,A.CAPA_GRD_CODE								--  2018-08-29 PIYONG ADD
								   ,A.VLTG_GRD_CODE								--  2018-08-29 PIYONG ADD
								   ,A.RSST_GRD_CODE								--  2018-08-29 PIYONG ADD
								   ,A.EX_DATE									--  2018-10-04 PIYONG ADD
								   ,A.PACK_MOVE_QTY								--  2019-07-05 PIYONG ADD
							  FROM (
									SELECT A.COMPANY_ID
										   ,A.DIVISION_ID
										   ,A.[PLANT_ID]
										   ,A.FACTORY_ID
										   ,A.LINE_ID							--  2018-08-29 PIYONG ADD
										   ,ISNULL(A.STORAGE_ID, '-') AS STORAGE_ID
										   ,ROW_NUMBER() OVER( ORDER BY A.[EX_DATE], A.COMPANY_ID, A.DIVISION_ID, A.[PLANT_ID], A.[ITEM_ID], ISNULL(A.STORAGE_ID, '-') DESC ) AS SEQ
										   ,A.[ITEM_ID]
										   ,A.[EX_DATE]
										   ,A.[EX_TIME]
										   ,SUM(CAST(ISNULL(A.[GOOD_QTY],0) AS FLOAT)) AS QTY
										   ,SUM(CAST(ISNULL(A.[DEFECT_QTY],0) AS FLOAT)) AS DEFECT_QTY
										   ,SUM(CAST(ISNULL(A.[HOLD_QTY],0) AS FLOAT)) AS HOLD_QTY
										   ,OUTDTM
										   ,A.QTY_UOM
										   ,A.OUTSOURCING_FACTORY
										   ,A.HOLD_YN					--	2018-04-16 PIYONG ADD	--	2018-05-03 PIYONG  MAX값으로 변경	--2018-05-25 PIYONG MAX DEL
										   ,MAX(A.UNHOLD_EXP_DATE ) AS UNHOLD_EXP_DATE									--	2018-05-03 PIYONG ADD
										   ,SUM(CAST(ISNULL(A.[LONG_TERM_QTY],0) AS FLOAT)) AS LONG_TERM_QTY				--  2018-07-26 PIYONG ADD
										   ,A.PROCID																	--  2018-08-29 PIYONG ADD
										   ,CASE WHEN A.CAPA_GRD_CODE = 'null' THEN NULL ELSE A.CAPA_GRD_CODE END AS CAPA_GRD_CODE	--  2018-08-29 PIYONG ADD
										   ,CASE WHEN A.VLTG_GRD_CODE = 'null' THEN NULL ELSE A.VLTG_GRD_CODE END AS VLTG_GRD_CODE	--  2018-08-29 PIYONG ADD
										   ,CASE WHEN A.RSST_GRD_CODE = 'null' THEN NULL ELSE A.RSST_GRD_CODE END AS RSST_GRD_CODE	--  2018-08-29 PIYONG ADD
										   ,SUM(ISNULL( CAST( A.[PACK_MOVE_QTY] AS NUMERIC), 0) ) AS [PACK_MOVE_QTY]				--  2019-07-05 PIYONG ADD
									  FROM (
											--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
											-- 2018-05-25 piyong  로직 변경
											SELECT (SELECT TOP 1 COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS COMPANY_ID			--  2020-05-20 PIYONG CHANGE
													,(SELECT TOP 1 DIVISION_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS DIVISION_ID		--  2020-05-20 PIYONG CHANGE
													,(SELECT TOP 1 PLANT_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS PLANT_ID			--  2020-05-20 PIYONG CHANGE
												   ,A.BUILDING   AS FACTORY_ID
												   ,A.LINE_ID							--  2018-08-29 PIYONG ADD
												   ,A.[SLOC]     AS STORAGE_ID
												   ,A.[ITEM_ID]
												   ,A.[EX_DATE]
												   ,A.[EX_TIME]
												   ,CAST(ISNULL(A.[GOOD_QTY],0) AS NUMERIC(20,10))		AS [GOOD_QTY]
												   ,CAST(ISNULL(A.[DEFECT_QTY],0) AS NUMERIC(20,10))	AS DEFECT_QTY
												   ,0		AS HOLD_QTY
												   ,A.[UOM] AS QTY_UOM
												   ,A.VENDOR_CODE AS OUTSOURCING_FACTORY
												--2018-03-05 PIYONG CHANGE
												   ,CASE WHEN A.TYPE = 'DW' AND N2_1_SHIP_AVAILABLE_DATE IS NULL THEN		-- 2018-10-04 PIYONG CHANGE  N2_1_SHIP_AVAILABLE_DATE ADD
															SHIP_SCHD_DATE
														 WHEN A.TYPE = 'DW' AND N2_1_SHIP_AVAILABLE_DATE IS NOT NULL THEN	-- 2018-10-04 PIYONG ADD
															REPLACE(N2_1_SHIP_AVAILABLE_DATE, '-', '')
														 WHEN A.TYPE = 'OWMS' THEN
		  												--2018-02-22 PIYONG ADD
															(SELECT (CASE WHEN ISNULL(MAX(FO.OCV2_DATE),' ') = ' ' THEN ' ' ELSE CONVERT(VARCHAR,DATEADD(DD,MAX(FST.SHIPPING_TERM_DATE)+1,MAX(FO.OCV2_DATE)),111) END) 
																FROM SCM_FCS_OCV2_H (NOLOCK) FO
																	, SCM_FCS_SHIPPING_TERM_M	(NOLOCK) FST 
																WHERE FO.LOT_ID = A.LOT_ID AND FO.PALLET_ID = A.PALLET_ID AND FST.ITEM_ID = A.ITEM_ID AND FST.OWNR = A.OWNRKY ) 
														--2018-02-22 PIYONG ADD END
														END									AS OUTDTM
												--2018-03-05 PIYONG CHANGE END
													,'N' AS HOLD_YN
													,''  AS UNHOLD_EXP_DATE
													,CASE WHEN HOLD_QTY > 0 THEN 0 ELSE LONG_TERM_QTY END AS LONG_TERM_QTY						--  2018-07-26 PIYONG ADD
													,PROCID								--  2018-08-29 PIYONG ADD
													,[CAPA_GRD_CODE]					--  2018-08-29 PIYONG ADD
													,[VLTG_GRD_CODE]					--  2018-08-29 PIYONG ADD
													,[RSST_GRD_CODE]					--  2018-08-29 PIYONG ADD
													,0		AS [PACK_MOVE_QTY]			--	2019-07-05 PIYONG ADD
											   FROM [dbo].[SY_XIF_DW_INVENTORY_R] A WITH(NOLOCK)
  											  WHERE 1=1 --IFSEQNO       = @P_IFSEQNO	 --PIYONG 2018-07-17 DEL
												AND [TRANSFER_FLAG] = 'P'
												AND CAST(ISNULL(A.[GOOD_QTY],0) AS NUMERIC(20,10)) > 0	--PIYONG 2019-01-15 PIYONG CHANGE  A.[HOLD_QTY]-> A.[GOOD_QTY]
												AND ( (A.TYPE = 'OWMS' AND A.COMPANY NOT IN ('WA00', 'HQ00') ) OR (A.TYPE != 'OWMS') )

											---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
											--2018-05-25 PIYONG ADD	CSR ID:3722373
											  UNION ALL
											 SELECT (SELECT TOP 1 COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS COMPANY_ID		--  2020-05-20 PIYONG CHANGE
													,(SELECT TOP 1 DIVISION_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS DIVISION_ID		--  2020-05-20 PIYONG CHANGE
													,(SELECT TOP 1 PLANT_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS PLANT_ID			--  2020-05-20 PIYONG CHANGE
												   ,A.BUILDING   AS FACTORY_ID
												   ,A.LINE_ID							--  2018-08-29 PIYONG ADD
												   ,A.[SLOC]     AS STORAGE_ID
												   ,A.[ITEM_ID]
												   ,A.[EX_DATE]
												   ,A.[EX_TIME]
												   ,0		AS [GOOD_QTY]
												   ,0		AS DEFECT_QTY
												   ,CAST(ISNULL(A.[HOLD_QTY],0) AS NUMERIC(20,10))	AS HOLD_QTY
												   ,A.[UOM] AS QTY_UOM
												   ,A.VENDOR_CODE AS OUTSOURCING_FACTORY
												   ,CASE WHEN A.TYPE = 'DW' AND N2_1_SHIP_AVAILABLE_DATE IS NULL THEN		-- 2018-10-04 PIYONG CHANGE  N2_1_SHIP_AVAILABLE_DATE ADD
															SHIP_SCHD_DATE
														 WHEN A.TYPE = 'DW' AND N2_1_SHIP_AVAILABLE_DATE IS NOT NULL THEN	-- 2018-10-04 PIYONG ADD
															REPLACE(N2_1_SHIP_AVAILABLE_DATE, '-', '')
														 WHEN A.TYPE = 'OWMS' THEN
															(SELECT (CASE WHEN ISNULL(MAX(FO.OCV2_DATE),' ') = ' ' THEN ' ' ELSE CONVERT(VARCHAR,DATEADD(DD,MAX(FST.SHIPPING_TERM_DATE)+1,MAX(FO.OCV2_DATE)),111) END) 
																FROM SCM_FCS_OCV2_H (NOLOCK) FO
																	, SCM_FCS_SHIPPING_TERM_M	(NOLOCK) FST 
																WHERE FO.LOT_ID = A.LOT_ID AND FO.PALLET_ID = A.PALLET_ID AND FST.ITEM_ID = A.ITEM_ID AND FST.OWNR = A.OWNRKY ) 
														END									AS OUTDTM
													,'Y' AS HOLD_YN
													, A.UNHOLD_EXP_DATE
													,LONG_TERM_QTY						--  2018-07-26 PIYONG ADD
													,PROCID								--  2018-08-29 PIYONG ADD
													,[CAPA_GRD_CODE]					--  2018-08-29 PIYONG ADD
													,[VLTG_GRD_CODE]					--  2018-08-29 PIYONG ADD
													,[RSST_GRD_CODE]					--  2018-08-29 PIYONG ADD
													,0		AS [PACK_MOVE_QTY]			--	2019-07-05 PIYONG ADD
											   FROM [dbo].[SY_XIF_DW_INVENTORY_R] A WITH(NOLOCK)
  											  WHERE 1=1 --IFSEQNO       = @P_IFSEQNO	 --PIYONG 2018-07-17 DEL
												AND [TRANSFER_FLAG] = 'P'
												AND CAST(ISNULL(A.[HOLD_QTY],0) AS NUMERIC(20,10)) > 0
											--2018-05-25 PIYONG ADD	끝
											---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
											--2019-01-24 PIYONG ADD	
											---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
											UNION ALL
											SELECT (SELECT TOP 1 COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS COMPANY_ID			--  2020-05-20 PIYONG CHANGE
													,(SELECT TOP 1 DIVISION_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS DIVISION_ID		--  2020-05-20 PIYONG CHANGE
													,(SELECT TOP 1 PLANT_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS PLANT_ID			--  2020-05-20 PIYONG CHANGE
												   ,A.BUILDING   AS FACTORY_ID
												   ,A.LINE_ID
												   ,A.[SLOC]     AS STORAGE_ID
												   ,A.[ITEM_ID]
												   ,A.[EX_DATE]
												   ,A.[EX_TIME]
												   ,0		AS [GOOD_QTY]
												   ,0		AS DEFECT_QTY
												   ,0		AS HOLD_QTY
												   ,A.[UOM] AS QTY_UOM
												   ,A.VENDOR_CODE AS OUTSOURCING_FACTORY
												   ,CASE WHEN A.TYPE = 'DW' AND N2_1_SHIP_AVAILABLE_DATE IS NULL THEN
															SHIP_SCHD_DATE
														 WHEN A.TYPE = 'DW' AND N2_1_SHIP_AVAILABLE_DATE IS NOT NULL THEN
															REPLACE(N2_1_SHIP_AVAILABLE_DATE, '-', '')
														 WHEN A.TYPE = 'OWMS' THEN
															(SELECT (CASE WHEN ISNULL(MAX(FO.OCV2_DATE),' ') = ' ' THEN ' ' ELSE CONVERT(VARCHAR,DATEADD(DD,MAX(FST.SHIPPING_TERM_DATE)+1,MAX(FO.OCV2_DATE)),111) END) 
																FROM SCM_FCS_OCV2_H (NOLOCK) FO
																	, SCM_FCS_SHIPPING_TERM_M	(NOLOCK) FST 
																WHERE FO.LOT_ID = A.LOT_ID AND FO.PALLET_ID = A.PALLET_ID AND FST.ITEM_ID = A.ITEM_ID AND FST.OWNR = A.OWNRKY ) 
														END									AS OUTDTM
													,'N' AS HOLD_YN
													, A.UNHOLD_EXP_DATE
													,LONG_TERM_QTY
													,PROCID
													,[CAPA_GRD_CODE]
													,[VLTG_GRD_CODE]
													,[RSST_GRD_CODE]
													,0		AS [PACK_MOVE_QTY]					-- 2019-07-05 PIYONG ADD
											   FROM [dbo].[SY_XIF_DW_INVENTORY_R] A WITH(NOLOCK)
  											  WHERE 1=1 --IFSEQNO       = @P_IFSEQNO
												AND [TRANSFER_FLAG] = 'P'
												AND CAST(ISNULL(A.[HOLD_QTY],0) AS NUMERIC(20,10)) = 0
												AND CAST(ISNULL(A.[GOOD_QTY],0) AS NUMERIC(20,10)) = 0
												AND LONG_TERM_QTY > 0
												--2019-01-24 PIYONG ADD	끝
											---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


											---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
											--2019-07-05 PIYONG ADD	
											---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
											UNION ALL
											SELECT (SELECT TOP 1 COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS COMPANY_ID			--  2020-05-20 PIYONG CHANGE
													,(SELECT TOP 1 DIVISION_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS DIVISION_ID		--  2020-05-20 PIYONG CHANGE
													,(SELECT TOP 1 PLANT_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = A.BUILDING) AS PLANT_ID			--  2020-05-20 PIYONG CHANGE
												   ,B.FACTORY_ID					-- 2019-08-20 PIYONG CHANGE A.BUILDING -> B.FACTORY_ID
												   ,B.LINE_ID						-- 2019-08-20 PIYONG CHANGE A.LINE_ID -> B.LINE_ID
												   ,A.[TO_SLOC_ID]	AS STORAGE_ID
												   ,A.[ITEM_ID]
												   ,A.[EX_DATE]
												   ,A.[EX_TIME]
												   ,0		AS [GOOD_QTY]
												   ,0		AS DEFECT_QTY
												   ,0		AS HOLD_QTY
												   ,NULL	AS QTY_UOM
												   ,NULL	AS OUTSOURCING_FACTORY
												   ,CONVERT(NVARCHAR(8), GETDATE(), 112) AS OUTDTM
												   ,'N'		AS HOLD_YN
												   ,A.UNHOLD_EXP_DATE
												   ,0		AS LONG_TERM_QTY
												   ,B.OPERATION_ID AS PROCID
												   ,[CAPA_GRD_CODE]
												   ,[VLTG_GRD_CODE]
												   ,[RSST_GRD_CODE]
												   ,[PACK_MOVE_QTY]
											  FROM ( SELECT *
													   FROM [dbo].[SY_XIF_DW_INVENTORY_R] A WITH(NOLOCK)
  													  WHERE 1=1 --IFSEQNO       = @P_IFSEQNO
														AND [TRANSFER_FLAG] = 'P'
													    AND CAST(ISNULL(A.[PACK_MOVE_QTY],0) AS NUMERIC(20,10)) > 0
												   ) A
											----------------------------------------------------------------------------
											-- 2019-08-20 PIYONG ADD
												   , (
														SELECT [COMPANY_ID]
															   ,[DIVISION_ID]
															   ,[SITE_ID]
															   ,[PLANT_ID]
															   ,[FACTORY_ID]
															   ,MIN([OPERATION_ID] ) AS [OPERATION_ID]
															   ,MIN([LINE_ID] ) AS [LINE_ID]
															   ,[DOMESTIC_SLOC_ID]
															   ,[EXPORT_SLOC_ID]
														  FROM [SCM_LINE_M]  WITH(NOLOCK)
														 GROUP BY [COMPANY_ID]
															   ,[DIVISION_ID]
															   ,[SITE_ID]
															   ,[PLANT_ID]
															   ,[FACTORY_ID]
															   ,[DOMESTIC_SLOC_ID]
															   ,[EXPORT_SLOC_ID]
												   ) B
											 WHERE A.[COMPANY] = B.[COMPANY_ID]
											   AND A.DIVISION = B.DIVISION_ID
											   AND A.PLANT_ID = B.PLANT_ID
											   AND A.TO_AREA_ID = B.FACTORY_ID
											   AND A.TO_SLOC_ID IN ( B.DOMESTIC_SLOC_ID, B.EXPORT_SLOC_ID)
											-- 2019-08-20 PIYONG ADD END
											----------------------------------------------------------------------------
											--2019-07-05 PIYONG ADD	끝
											---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

										   ) A
									 GROUP BY A.COMPANY_ID
										   ,A.DIVISION_ID
										   ,A.[PLANT_ID]
										   ,A.FACTORY_ID
										   ,ISNULL(A.STORAGE_ID, '-')
										   ,A.[ITEM_ID]      
										   ,A.QTY_UOM
										   ,A.[EX_DATE]
										   ,A.[EX_TIME]
										   ,A.OUTSOURCING_FACTORY
										   ,A.OUTDTM			-- 2018-02-22 PIYONG ADD
										   ,A.HOLD_YN			-- 2018-04-16 PIYONG ADD		--	2018-05-03 PIYONG 삭제 --2018-05-25 PIYONG ADD
										   ,A.PROCID				--  2018-08-29 PIYONG ADD
										   ,A.LINE_ID				--  2018-08-29 PIYONG ADD
										   ,A.CAPA_GRD_CODE			--  2018-08-29 PIYONG ADD
										   ,A.VLTG_GRD_CODE			--  2018-08-29 PIYONG ADD
										   ,A.RSST_GRD_CODE			--  2018-08-29 PIYONG ADD
							
								   ) A
						   ) AA
					;
		   	  
					SET @ROWCOUNT = @@ROWCOUNT

					UPDATE [dbo].[SY_XIF_DW_INVENTORY_R]
					   SET TRANSFER_FLAG = 'Y'
						  ,TRANSFER_DATE = GETDATE()
					 WHERE 1=1 --IFSEQNO       = @P_IFSEQNO	 --PIYONG 2018-07-17 DEL
					   AND TRANSFER_FLAG = 'P'
					;
				END;

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
