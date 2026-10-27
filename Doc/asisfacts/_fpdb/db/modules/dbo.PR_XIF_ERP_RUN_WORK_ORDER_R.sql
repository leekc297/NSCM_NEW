
CREATE PROCEDURE [dbo].[PR_XIF_ERP_RUN_WORK_ORDER_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_ERP_RUN_WORK_ORDER_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP XI
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_RUN_WORK_ORDER_R
-- Destination Table   : FP_ERP_WORK_ORDER_STATUS_H
--
-- Create Date         : 2016.08.16
-- Update Date         : 2017.04.24 PIYONG 1.3
--						 2017.05.02 PIYONG 1.4
--						 2017.05.08 PIYONG 1.5
--						 2017.05.11 PIYONG 1.6
--						 2017.05.15 PIYONG 1.7
--						 2017.05.16 PIYONG 1.8
--						 2017.11.10 PIYONG 1.9
--						 2018.10.11 PIYONG 2.0
--						 2022.03.28 KIMCD  2.1
--                       2022.07.20 KIMCD  2.2

-- Author              : 김 석
-- Version             : 1.0
--                       1.1 kimcd 2017-01-03 240000인 경우 익일로 일자 변경
--                       1.2 kimcd 2017-04-05 line 정보 누락을 보완하기 위해 isnull 문장 추가
--                       1.3 TRANSFER_FLAG = 'Y' 변경 소스 위치 이동(LINE 388 -> LINE 433)
--						 1.4 PLAN_DATE 조건 변경
--						 1.5 FP_RELEASE_FIX_PLAN_H, FP_RELEASE_FULL_PLAN_H 테이블 MIN_ACTUAL_DATE 컬럼 추가
--                       1.6 FP_RELEASE_FIX_PLAN_H, FP_RELEASE_FULL_PLAN_H 테이블 MIN_ACTUAL_DATE 입력 값 수정
--                       1.7 FP_RELEASE_FIX_PLAN_H, FP_RELEASE_FULL_PLAN_H 테이블 MIN_ACTUAL_DATE 입력 값 수정
--						 1.8 FP_RELEASE_FIX_PLAN_H 테이블에 CLOSE_FLAG 값 넣는 로직 추가, FP_RELEASE_FULL_PLAN_H 테이블에 ACTUAL_FLAG 값 넣는 로직 추가
--						 1.9 CUR_INSTANCE PLAN_GROUP_ID 조회 조건 추가
--							 CUR_INSTANCE 비활성화 함. 월 구분용으로 넣은 로직이나 현재는 의미 없는 과정임.
--						 2.0 IFSEQNO 값을 프로시저 호출 할때  ->  HEADER_CNT 건수로 변경
--                       2.1 2022-03-28 kimcd 가상 Division 사용에 따른 수정
--                       2.2 2022-07-20 kimcd 설비 정보 Option 정보로 전환
-- ================================================================================================

-- ERP요청 SEQNO
--@P_IFSEQNO NVARCHAR(50) = 'NULL'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_RUN_WORK_ORDER_R'
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
	--DECLARE @COMPANY     NVARCHAR(1000)
	DECLARE @V_DIVISION_ID NVARCHAR(10)
	DECLARE @V_FACTORY_ID  NVARCHAR(10)
	DECLARE @V_INSTANCE_ID NVARCHAR(100)
	DECLARE @P_IFSEQNO     NVARCHAR(100)
	DECLARE @V_IFSEQNO	   NVARCHAR(150)

	--CURSOR INSTANCE  대상정보
    DECLARE CUR_INSTANCE CURSOR FOR
     SELECT DIVISION_ID, FACTORY_ID, INSTANCE_ID, PLAN_ID
       FROM ( SELECT DIVISION_ID
				     , FACTORY_ID
				     , INSTANCE_ID
				     , RELEASE_PLAN_ID AS PLAN_ID
                     , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, FACTORY_ID, INSTANCE_ID ORDER BY DIVISION_ID, FACTORY_ID, INSTANCE_ID, RELEASE_TIME DESC) AS REL_CNT
                     , RELEASE_TIME
                FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
               WHERE RELEASE_FLAG = 'Y'
			   --2017-11-10 PIYONG PLAN_GROUP_ID  조회 조건 추가 시작
			   --------------------------------------------------------------------------------------------------------------------------------------------
			   UNION ALL
			   SELECT DISTINCT DIVISION_ID
				     , FACTORY_ID
				     , INSTANCE_ID
				     , RELEASE_PLAN_ID AS PLAN_ID
					 ,'' AS REL_CNT
					 ,'' AS RELEASE_TIME
			    FROM DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R PPE WITH(NOLOCK)
					 ,( SELECT RELEASE_PLAN_ID
						  FROM ( SELECT D.PLAN_GROUP_ID 
										, RELEASE_PLAN_ID 
										, ROW_NUMBER() OVER(PARTITION BY D.PLAN_GROUP_ID, D.INSTANCE_ID ORDER BY D.PLAN_GROUP_ID, D.INSTANCE_ID, D.RELEASE_TIME DESC) AS REL_CNT
								  FROM SCM_FP_PLAN_H        W WITH(NOLOCK)
									   ,SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
								 WHERE W.PLAN_ID =D.RELEASE_PLAN_ID
									AND W.PLAN_TYPE = 'RELEASE'
									AND D.RELEASE_FLAG = 'Y'
							   ) A
						 WHERE A.REL_CNT = 1
					 ) A
			   WHERE PPE.FP_PLAN_ID = A.RELEASE_PLAN_ID
			   --------------------------------------------------------------------------------------------------------------------------------------------
			   --2017-11-10 PIYONG PLAN_GROUP_ID  조회 조건 추가 끝
			) A
      WHERE REL_CNT = 1
    ;

	DECLARE CUR_IFSEQNO CURSOR FOR
		SELECT IFSEQNO
		  FROM [dbo].[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R] WITH(NOLOCK)
		 WHERE TRANSFER_FLAG = 'N'
		 GROUP BY IFSEQNO
		HAVING COUNT(1) = MAX(HEADER_CNT)

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

			IF ( SELECT COUNT(*) FROM [dbo].[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R] WITH(NOLOCK) WHERE TRANSFER_FLAG = 'N' ) > 0	
				BEGIN

					OPEN CUR_IFSEQNO;
					FETCH NEXT FROM CUR_IFSEQNO INTO @V_IFSEQNO

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
	/*		  
						IF @P_IFSEQNO = 'NULL'
						   SET @P_IFSEQNO = (SELECT MAX(IFSEQNO) FROM [dbo].[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R] WITH(NOLOCK)
											  WHERE TRANSFER_FLAG = 'N'
											)
	*/
							UPDATE [dbo].[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R]
							   SET TRANSFER_FLAG = 'P'
							 WHERE IFSEQNO       = @V_IFSEQNO
							   AND TRANSFER_FLAG = 'N'
							;

							-- CUTOFF_DATE 기준으로 삭제
							DELETE S
							  FROM [dbo].[FP_ERP_WORK_ORDER_STATUS_H] S
							 WHERE EXISTS (
											 SELECT 1
											   FROM (
														SELECT DISTINCT CAST(A.[WORK_DATE] AS DATE) AS CUTOFF_DATE
															   , A.SITE_ID
															   , A.PLANT_ID
														  FROM [dbo].[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R] A WITH(NOLOCK)
														 WHERE IFSEQNO       = @V_IFSEQNO
														   AND TRANSFER_FLAG = 'P'
													) AA
											  WHERE S.CUTOFF_DATE  = AA.CUTOFF_DATE
												AND S.SITE_ID   = AA.SITE_ID
												AND S.PLANT_ID = AA.PLANT_ID
										 )
							;

							MERGE INTO [dbo].[FP_ERP_WORK_ORDER_STATUS_H] A
							USING (
									SELECT   A.[COMPANY_ID]
											,ISNULL(PD.PSEUDO_DIVISION_ID, A.[DIVISION_ID]) AS DIVISION_ID   -- 2022-03-24 kimcd 가상 Division 로직 추가
											,A.[SITE_ID]
											,A.[PLANT_ID] 
											,ISNULL(A.[FACTORY_ID], '-') AS FACTORY_ID
											,A.[CUTOFF_DATE]
											,A.[WORK_ORDER_ID]
											,A.[DEMAND_ID]
											,A.[PRODUCTION_TYPE]
											,A.[ORDER_TYPE]
											,A.[ITEM_ID]
											,A.[TOP_ITEM_ID]
											,A.[OPERATION_ID]
											,A.[LINE_ID]
											,A.[WORK_CENTER_ID]
											,MAX(A.[PLAN_DATE])         AS PLAN_DATE
											,MAX(A.[PLAN_START_TIME])   AS PLAN_START_TIME
											,MAX(A.[PLAN_END_TIME])     AS PLAN_END_TIME
											,SUM(CAST(A.[PLAN_QTY] AS NUMERIC(14,4))) AS PLAN_QTY
											,MAX(A.[ACTUAL_START_TIME]) AS ACTUAL_START_TIME
											-- ,MAX(A.[ACTUAL_END_TIME])   AS ACTUAL_END_TIME  kimcd change 
											,MAX ( CASE WHEN A.ERP_PET LIKE '%240000'THEN
														DATEADD(DD, 1, A.[ACTUAL_END_TIME])
												   ELSE
														A.[ACTUAL_END_TIME]
												   END
												 ) AS ACTUAL_END_TIME
											,SUM(CAST(A.[ACTUAL_QTY] AS NUMERIC(14,4))) AS ACTUAL_QTY
											,NULL AS [ACTUAL_GOOD_QTY]
											,NULL AS [ACTUAL_SCRAP_QTY]
											,NULL AS [BOM_VERSION_ID]
											,MAX(A.WO_STATUS) AS WO_STATUS
											,'PR_XIF_ERP_RUN_WORK_ORDER_R' AS [INSERT_ID]
											,GETDATE() AS [INSERT_TIME]
									 FROM (
											SELECT  A.COMPANY AS COMPANY_ID
												   ,A.DIVISION AS [DIVISION_ID]
												   ,A.SITE_ID
												   ,A.PLANT_ID
												   ,A.FACTORY_ID
												   ,CAST(A.[WORK_DATE] AS DATE) AS [CUTOFF_DATE]
												   ,A.WO_NO AS [WORK_ORDER_ID]
												   ,NULL AS [DEMAND_ID]
												   ,NULL AS [PRODUCTION_TYPE]
												   ,A.ORDER_TYPE
												   ,ISNULL(A.ITEM_ID, '-') AS [ITEM_ID]
												   ,NULL AS [TOP_ITEM_ID]
												    ,ISNULL((SELECT TOP 1 B.OPERATION_ID 
															   FROM DBO.SCM_EQUIPMENT_M B -- 2022-07-20 kimcd 설비 정보 Option 정보로 전환. 라인 마스터로 변경
																    ,[DBO].[SCM_ITEM_LINE_ASSIGN_M] D
															  WHERE B.COMPANY_ID		= D.COMPANY_ID
															    AND B.DIVISION_ID		= D.DIVISION_ID
															    AND B.SITE_ID			= D.SITE_ID
															    AND B.PLANT_ID			= D.PLANT_ID
															    AND B.FACTORY_ID		= D.FACTORY_ID
									 						    AND B.OPERATION_ID		= D.OPERATION_ID
														        AND B.WORK_CENTER_ID	= A.PROD_LINE
														        AND D.[MONTH]			= SUBSTRING(A.FP_PST, 1, 6)
															    AND D.ITEM_ID			= A.ITEM_ID
															    AND B.COMPANY_ID		= A.COMPANY
															    --AND B.DIVISION_ID		= A.DIVISION  -- 2022-03-28 kimcd 조건 제거
															    AND B.SITE_ID			= A.SITE_ID
															    AND B.PLANT_ID			= A.PLANT_ID
															    AND B.FACTORY_ID		= A.FACTORY_ID
															   -- AND D.PRIORITY = 1
															    AND D.ACTIVE_FLAG		= 'Y' )
													,(ISNULL((SELECT TOP 1 B.OPERATION_ID 
															   FROM DBO.SCM_LINE_M B -- 2022-07-20 kimcd 설비 정보 Option 정보로 전환. 라인 마스터로 변경
																    ,[DBO].[SCM_ITEM_LINE_ASSIGN_M] D
															  WHERE B.COMPANY_ID		= D.COMPANY_ID
															    AND B.DIVISION_ID		= D.DIVISION_ID
															    AND B.SITE_ID			= D.SITE_ID
															    AND B.PLANT_ID			= D.PLANT_ID
															    AND B.FACTORY_ID		= D.FACTORY_ID
									 						    AND B.OPERATION_ID		= D.OPERATION_ID
														        AND B.WORK_CENTER_ID	= A.PROD_LINE
														        AND D.[MONTH]			= SUBSTRING(A.FP_PST, 1, 6)
															    AND D.ITEM_ID			= A.ITEM_ID
															    AND B.COMPANY_ID		= A.COMPANY
															    --AND B.DIVISION_ID		= A.DIVISION  -- 2022-03-28 kimcd 조건 제거
															    AND B.SITE_ID			= A.SITE_ID
															    AND B.PLANT_ID			= A.PLANT_ID
															    AND B.FACTORY_ID		= A.FACTORY_ID
															   -- AND D.PRIORITY = 1
															    AND D.ACTIVE_FLAG		= 'Y' ) ,ISNULL((SELECT TOP 1 B.OPERATION_ID 
																										   FROM DBO.SCM_LINE_M B -- 2022-07-20 kimcd 설비 정보 Option 정보로 전환. 라인 마스터로 변경
																										  WHERE B.WORK_CENTER_ID = A.PROD_LINE -- 2022-03-28 kimcd 조건 추가
																										    AND B.COMPANY_ID	= A.COMPANY
																											--AND B.DIVISION_ID	= A.DIVISION  -- 2022-03-28 kimcd 조건 제거
																											AND B.SITE_ID		= A.SITE_ID
																											AND B.PLANT_ID		= A.PLANT_ID
																											AND B.FACTORY_ID	= A.FACTORY_ID), '-'))))  AS [OPERATION_ID]  -- KIMCD ADD SECOND QUERY 2017-04-05
													,ISNULL((SELECT TOP 1 B.LINE_ID
															   FROM DBO.SCM_EQUIPMENT_M B -- 2022-07-20 kimcd 설비 정보 Option 정보로 전환. 라인 마스터로 변경
																    ,[DBO].[SCM_ITEM_LINE_ASSIGN_M] D
															  WHERE B.COMPANY_ID		= D.COMPANY_ID
															    AND B.DIVISION_ID		= D.DIVISION_ID
															    AND B.SITE_ID			= D.SITE_ID
															    AND B.PLANT_ID			= D.PLANT_ID
															    AND B.FACTORY_ID		= D.FACTORY_ID
									 						    AND B.OPERATION_ID		= D.OPERATION_ID
														        AND B.WORK_CENTER_ID	= A.PROD_LINE
														        AND D.[MONTH]			= SUBSTRING(A.FP_PST, 1, 6)
															    AND D.ITEM_ID			= A.ITEM_ID
															    AND B.COMPANY_ID		= A.COMPANY
															    --AND B.DIVISION_ID		= A.DIVISION  -- 2022-03-28 kimcd 조건 제거
															    AND B.SITE_ID			= A.SITE_ID
															    AND B.PLANT_ID			= A.PLANT_ID
															    AND B.FACTORY_ID		= A.FACTORY_ID
															   -- AND D.PRIORITY = 1
															    AND D.ACTIVE_FLAG		= 'Y'
															  ORDER BY D.PRIORITY )
													,(ISNULL((SELECT TOP 1 B.LINE_ID
															   FROM DBO.SCM_LINE_M B -- 2022-07-20 kimcd 설비 정보 Option 정보로 전환. 라인 마스터로 변경
																    ,[DBO].[SCM_ITEM_LINE_ASSIGN_M] D
															  WHERE B.COMPANY_ID		= D.COMPANY_ID
															    AND B.DIVISION_ID		= D.DIVISION_ID
															    AND B.SITE_ID			= D.SITE_ID
															    AND B.PLANT_ID			= D.PLANT_ID
															    AND B.FACTORY_ID		= D.FACTORY_ID
									 						    AND B.OPERATION_ID		= D.OPERATION_ID
														        AND B.WORK_CENTER_ID	= A.PROD_LINE
														        AND D.[MONTH]			= SUBSTRING(A.FP_PST, 1, 6)
															    AND D.ITEM_ID			= A.ITEM_ID
															    AND B.COMPANY_ID		= A.COMPANY
															    --AND B.DIVISION_ID		= A.DIVISION  -- 2022-03-28 kimcd 조건 제거
															    AND B.SITE_ID			= A.SITE_ID
															    AND B.PLANT_ID			= A.PLANT_ID
															    AND B.FACTORY_ID		= A.FACTORY_ID
															   -- AND D.PRIORITY = 1
															    AND D.ACTIVE_FLAG		= 'Y'
															  ORDER BY D.PRIORITY ) ,ISNULL((SELECT TOP 1 B.LINE_ID   -- ADD ORDER BY KIMCD 2017-04-05
																							   FROM DBO.SCM_LINE_M B -- 2022-07-20 kimcd 설비 정보 Option 정보로 전환. 라인 마스터로 변경
																							  WHERE B.WORK_CENTER_ID	= A.PROD_LINE
																							    AND B.COMPANY_ID		= A.COMPANY
																							    --AND B.DIVISION_ID		= A.DIVISION  -- 2022-03-28 kimcd 조건 제거
																							    AND B.SITE_ID			= A.SITE_ID
																							    AND B.PLANT_ID			= A.PLANT_ID
																							    AND B.FACTORY_ID		= A.FACTORY_ID), '-')))) AS  [LINE_ID] -- -- KIMCD ADD SECOND QUERY 2017-04-05

												   ,A.PROD_LINE AS [WORK_CENTER_ID]
												   , ISNULL( CASE WHEN SUBSTRING( FP_PST,  9, 6 ) < ( SELECT SUBSTRING(SEGMENT2, 1, 2) +''+SUBSTRING(SEGMENT2, 4, 2)+''+SUBSTRING(SEGMENT2, 5, 4)
																										 FROM SCM_SYS_LOOKUP_VALUE
																										WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																										  AND ACTIVE_FLAG = 'Y'
																										  AND SEGMENT1 = A.PLANT_ID
																									)																								THEN
																		DATEADD(D, -1, CONVERT(DATETIME,SUBSTRING(ERP_PST,1,4) + '-' + SUBSTRING(ERP_PST,5,2) + '-' + SUBSTRING(ERP_PST,7,2) + ' ' + SUBSTRING(ERP_PST,9,2) + ':' + SUBSTRING(ERP_PST,11,2) + ':' +SUBSTRING(ERP_PST,13,2),120))
																   ELSE  
																		CONVERT(DATETIME,SUBSTRING(ERP_PST,1,4) + '-' + SUBSTRING(ERP_PST,5,2) + '-' + SUBSTRING(ERP_PST,7,2) + ' ' + SUBSTRING(ERP_PST,9,2) + ':' + SUBSTRING(ERP_PST,11,2) + ':' +SUBSTRING(ERP_PST,13,2),120)
																   END, CAST('19000101' AS DATETIME) ) AS [PLAN_DATE]
												   ,ISNULL(CONVERT(DATETIME,SUBSTRING(A.FP_PST,1,4) + '-' + SUBSTRING(A.FP_PST,5,2) + '-' + SUBSTRING(A.FP_PST,7,2) + ' ' + SUBSTRING(REPLACE(A.FP_PST, '240000', '000000'),9,2) + ':' + SUBSTRING(A.FP_PST,11,2) + ':' +SUBSTRING(A.FP_PST,13,2),120), CAST('19000101' AS DATETIME) ) AS [PLAN_START_TIME]
												   ,ISNULL(CONVERT(DATETIME,SUBSTRING(A.FP_PET,1,4) + '-' + SUBSTRING(A.FP_PET,5,2) + '-' + SUBSTRING(A.FP_PET,7,2) + ' ' + SUBSTRING(REPLACE(A.FP_PET, '240000', '000000'),9,2) + ':' + SUBSTRING(A.FP_PET,11,2) + ':' +SUBSTRING(A.FP_PET,13,2)), CAST('19000101' AS DATETIME) ) AS [PLAN_END_TIME]
												   ,A.QTY [PLAN_QTY]
												   ,CONVERT(DATETIME,SUBSTRING(A.ERP_PST,1,4) + '-' + SUBSTRING(A.ERP_PST,5,2) + '-' + SUBSTRING(A.ERP_PST,7,2) + ' ' + SUBSTRING(A.ERP_PST,9,2) + ':' + SUBSTRING(A.ERP_PST,11,2) + ':' +SUBSTRING(A.ERP_PST,13,2)) AS [ACTUAL_START_TIME]
                                                   ,CASE WHEN A.ERP_PET LIKE '00000000%' THEN ISNULL(CONVERT(DATETIME,SUBSTRING(A.FP_PET,1,4) + '-' + SUBSTRING(A.FP_PET,5,2) + '-' + SUBSTRING(A.FP_PET,7,2) + ' ' + SUBSTRING(REPLACE(A.FP_PET, '240000', '000000'),9,2) + ':' + SUBSTRING(A.FP_PET,11,2) + ':' +SUBSTRING(A.FP_PET,13,2)), CAST('19000101' AS DATETIME) )
												    ELSE CONVERT(DATETIME,SUBSTRING(REPLACE(A.ERP_PET, '240000', '000000'),1,4) + '-' + SUBSTRING(REPLACE(A.ERP_PET, '240000', '000000'),5,2) + '-' + SUBSTRING(REPLACE(A.ERP_PET, '240000', '000000'),7,2) + ' ' + SUBSTRING(REPLACE(A.ERP_PET, '240000', '000000'),9,2) + ':' + SUBSTRING(REPLACE(A.ERP_PET, '240000', '000000'),11,2) + ':' +SUBSTRING(REPLACE(A.ERP_PET, '240000', '000000'),13,2))
													END AS [ACTUAL_END_TIME]
												   ,A.ERP_PET       --  kimcd add 2017-01-03
												   ,A.CONSUME_QTY AS  [ACTUAL_QTY]
												   ,CASE WHEN A.ERP_PST IS NULL     THEN 'OPEN'
														 WHEN A.ERP_PST IS NOT NULL THEN
														 --CASE WHEN ISNULL(QTY,0) <= ISNULL(CONSUME_QTY,0) THEN 'CLOSE'
														 --	  WHEN ISNULL(QTY,0) >  ISNULL(CONSUME_QTY,0) THEN 'RUN'
														 CASE WHEN ISNULL(CAST(QTY AS NUMERIC(20,10)),0) <= ISNULL(CAST(CONSUME_QTY AS NUMERIC(20,10)) ,0) THEN 'CLOSE'
															  WHEN ISNULL(CAST(QTY AS NUMERIC(20,10)),0) >  ISNULL(CAST(CONSUME_QTY AS NUMERIC(20,10)) ,0) THEN 'RUN'
														  END
													ELSE '-'
													 END AS WO_STATUS					   
											  FROM [dbo].[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R] A with(nolock)
													  WHERE A.IFSEQNO = @V_IFSEQNO
														AND A.[TRANSFER_FLAG] = 'P'
														-- OPEN 초 Garbage data 생성에 따른 처리
														and substring(A.FP_PST,1,8) > '20170403'  
														--AND A.FACTORY_ID IS NOT NULL
						       
											  ) A
								 			  LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
												   ON PD.PLANT_ID = A.PLANT_ID
										WHERE 1=1
										GROUP BY A.[COMPANY_ID]
												,ISNULL(PD.PSEUDO_DIVISION_ID, A.[DIVISION_ID])   -- 2022-03-24 kimcd 가상 Division 로직 추가
												,A.[SITE_ID]
												,A.[PLANT_ID] 
												,A.[FACTORY_ID] 
												,A.[CUTOFF_DATE]
												,A.[WORK_ORDER_ID]
												,A.[DEMAND_ID]
												,A.[PRODUCTION_TYPE]
												,A.[ORDER_TYPE]
												,A.[ITEM_ID]
												,A.[TOP_ITEM_ID]
												,A.[OPERATION_ID]
												,A.[LINE_ID]
												,A.[WORK_CENTER_ID]
								  ) B
							   ON (
									A.COMPANY_ID        = B.COMPANY_ID
									AND A.DIVISION_ID   = B.DIVISION_ID
									AND A.SITE_ID       = B.SITE_ID
									AND A.PLANT_ID      = B.PLANT_ID
									AND A.FACTORY_ID    = B.FACTORY_ID
									AND A.CUTOFF_DATE   = B.CUTOFF_DATE
									AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
								  )
							WHEN MATCHED THEN
								UPDATE SET
									   [DEMAND_ID]         = B.[DEMAND_ID]
									  ,[PRODUCTION_TYPE]   = B.[PRODUCTION_TYPE]
									  ,[ORDER_TYPE]        = B.[ORDER_TYPE]
									  ,[ITEM_ID]           = B.[ITEM_ID]
									  ,[TOP_ITEM_ID]       = B.[TOP_ITEM_ID]
									  ,[OPERATION_ID]      = B.[OPERATION_ID]
									  ,[LINE_ID]           = B.[LINE_ID]
									  ,[WORK_CENTER_ID]    = B.[WORK_CENTER_ID]
									  ,[PLAN_DATE]         = B.[PLAN_DATE]
									  ,[PLAN_START_TIME]   = B.[PLAN_START_TIME]
									  ,[PLAN_END_TIME]     = B.[PLAN_END_TIME]
									  ,[PLAN_QTY]          = B.[PLAN_QTY]
									  ,[ACTUAL_START_TIME] = B.[ACTUAL_START_TIME]
									  ,[ACTUAL_END_TIME]   = B.[ACTUAL_END_TIME]
									  ,[ACTUAL_QTY]        = B.[ACTUAL_QTY]
									  ,[ACTUAL_GOOD_QTY]   = B.[ACTUAL_GOOD_QTY]
									  ,[ACTUAL_SCRAP_QTY]  = B.[ACTUAL_SCRAP_QTY]
									  ,[BOM_VERSION_ID]    = B.[BOM_VERSION_ID]
									  ,[WO_STATUS]         = B.[WO_STATUS]
									  ,[INSERT_ID]         = B.[INSERT_ID]
									  ,[INSERT_TIME]       = B.[INSERT_TIME]
							WHEN NOT MATCHED THEN
								INSERT     ([COMPANY_ID]
										   ,[DIVISION_ID]
										   ,[SITE_ID]
										   ,[PLANT_ID]
										   ,[FACTORY_ID]
										   ,[CUTOFF_DATE]
										   ,[WORK_ORDER_ID]
										   ,[DEMAND_ID]
										   ,[PRODUCTION_TYPE]
										   ,[ORDER_TYPE]
										   ,[ITEM_ID]
										   ,[TOP_ITEM_ID]
										   ,[OPERATION_ID]
										   ,[LINE_ID]
										   ,[WORK_CENTER_ID]
										   ,[PLAN_DATE]
										   ,[PLAN_START_TIME]
										   ,[PLAN_END_TIME]
										   ,[PLAN_QTY]
										   ,[ACTUAL_START_TIME]
										   ,[ACTUAL_END_TIME]
										   ,[ACTUAL_QTY]
										   ,[ACTUAL_GOOD_QTY]
										   ,[ACTUAL_SCRAP_QTY]
										   ,[BOM_VERSION_ID]
										   ,[WO_STATUS]
										   ,[INSERT_ID]
										   ,[INSERT_TIME])
								VALUES     (B.[COMPANY_ID]
										   ,B.[DIVISION_ID]
										   ,B.[SITE_ID]
										   ,B.[PLANT_ID]
										   ,B.[FACTORY_ID]
										   ,B.[CUTOFF_DATE]
										   ,B.[WORK_ORDER_ID]
										   ,B.[DEMAND_ID]
										   ,B.[PRODUCTION_TYPE]
										   ,B.[ORDER_TYPE]
										   ,B.[ITEM_ID]
										   ,B.[TOP_ITEM_ID]
										   ,B.[OPERATION_ID]
										   ,B.[LINE_ID]
										   ,B.[WORK_CENTER_ID]
										   ,B.[PLAN_DATE]
										   ,B.[PLAN_START_TIME]
										   ,B.[PLAN_END_TIME]
										   ,B.[PLAN_QTY]
										   ,B.[ACTUAL_START_TIME]
										   ,B.[ACTUAL_END_TIME]
										   ,B.[ACTUAL_QTY]
										   ,B.[ACTUAL_GOOD_QTY]
										   ,B.[ACTUAL_SCRAP_QTY]
										   ,B.[BOM_VERSION_ID]
										   ,B.[WO_STATUS]
										   ,B.[INSERT_ID]
										   ,B.[INSERT_TIME])

							;

							SET @ROWCOUNT = @@ROWCOUNT

							UPDATE [dbo].[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R]
								SET TRANSFER_FLAG = 'Y'
									,TRANSFER_DATE = GETDATE()
								WHERE IFSEQNO       = @V_IFSEQNO
								AND TRANSFER_FLAG = 'P'
							;

							FETCH NEXT FROM CUR_IFSEQNO INTO @V_IFSEQNO          
						END;

					CLOSE CUR_IFSEQNO;
					DEALLOCATE CUR_IFSEQNO;
				END
/*		--2017-11-10 PIYONG DELETE 월 구분용으로 넣은 로직이나 현재는 의미 없는 과정임.
		OPEN CUR_INSTANCE;
        FETCH NEXT FROM CUR_INSTANCE INTO  @V_DIVISION_ID
										   ,@V_FACTORY_ID
										   ,@V_INSTANCE_ID
										   ,@V_PLAN_ID


			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					UPDATE DBO.FP_RELEASE_FIX_PLAN_H SET
						ACTUAL_FLAG = 'Y'
						,MIN_ACTUAL_DATE =  CASE WHEN MIN_ACTUAL_DATE IS NULL THEN DATEADD( D, -1, CONVERT(DATE, WORK_DATE, 112))	-- CHANGE PIYONG 2017-05-16
												 ELSE MIN_ACTUAL_DATE
												 END
					  FROM DBO.FP_RELEASE_FIX_PLAN_H P
					 INNER JOIN DBO.[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R] W
					    ON P.WORK_ORDER_ID = W.WO_NO
					   AND IFSEQNO       = @P_IFSEQNO
					   AND CAST(W.CONSUME_QTY AS  FLOAT) > 0
					   AND P.RELEASE_PLAN_ID = @V_PLAN_ID
					   AND P.DIVISION_ID = @V_DIVISION_ID
					   AND P.FACTORY_ID = @V_FACTORY_ID
--					   AND P.MIN_ACTUAL_DATE IS NULL																		        -- DELETE PIYONG 2017-05-16

					-- ADD PIYONG 2017-05-16
					UPDATE DBO.FP_RELEASE_FULL_PLAN_H SET
						ACTUAL_FLAG = 'Y'
						,MIN_ACTUAL_DATE =  CASE WHEN MIN_ACTUAL_DATE IS NULL THEN DATEADD( D, -1, CONVERT(DATE, WORK_DATE, 112))
												 ELSE MIN_ACTUAL_DATE
												 END
					  FROM DBO.FP_RELEASE_FULL_PLAN_H P
					 INNER JOIN DBO.[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R] W
					    ON P.WORK_ORDER_ID = W.WO_NO
					   AND IFSEQNO       = @P_IFSEQNO
					   AND CAST(W.CONSUME_QTY AS  FLOAT) > 0
					   AND P.RELEASE_PLAN_ID = @V_PLAN_ID
					   AND P.DIVISION_ID = @V_DIVISION_ID
					   AND P.FACTORY_ID = @V_FACTORY_ID

					-- ADD PIYONG 2017-05-16
					UPDATE DBO.FP_RELEASE_FIX_PLAN_H SET
						CLOSE_FLAG =  'Y'
						,MIN_ACTUAL_DATE = CASE WHEN F.MIN_ACTUAL_DATE IS NULL THEN DATEADD( D, -1, CONVERT(DATE, WORK_DATE, 112))
												ELSE MIN_ACTUAL_DATE
												 END
					  FROM DBO.FP_RELEASE_FIX_PLAN_H F
					 INNER JOIN DBO.[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R] W
						ON F.WORK_ORDER_ID = W.WO_NO
					   AND IFSEQNO       = @P_IFSEQNO
   					   AND W.ORDER_STATUS = '50'
					   AND F.RELEASE_PLAN_ID = @V_PLAN_ID
					   AND F.DIVISION_ID = @V_DIVISION_ID
					   AND F.FACTORY_ID = @V_FACTORY_ID


    
					UPDATE DBO.FP_RELEASE_FULL_PLAN_H SET
						CLOSE_FLAG = 'Y'
						,MIN_ACTUAL_DATE = CASE WHEN F.MIN_ACTUAL_DATE IS NULL THEN DATEADD( D, -1, CONVERT(DATE, WORK_DATE, 112)) 	-- CHANGE PIYONG 2017-05-16
												ELSE MIN_ACTUAL_DATE
												 END
					  FROM DBO.FP_RELEASE_FULL_PLAN_H F
					 INNER JOIN DBO.[SY_XIF_ERP_RUN_WORK_ORDER_HEADER_R] W
						ON F.WORK_ORDER_ID = W.WO_NO
					   AND IFSEQNO       = @P_IFSEQNO
					   AND W.ORDER_STATUS = '50'
					   AND F.RELEASE_PLAN_ID = @V_PLAN_ID
					   AND F.DIVISION_ID = @V_DIVISION_ID
					   AND F.FACTORY_ID = @V_FACTORY_ID
--					   AND P.MIN_ACTUAL_DATE IS NULL																				-- DELETE PIYONG 2017-05-16

					 FETCH NEXT FROM CUR_INSTANCE INTO @V_DIVISION_ID          
								                       ,@V_FACTORY_ID
								                       ,@V_INSTANCE_ID
													   ,@V_PLAN_ID
				END;
        CLOSE CUR_INSTANCE;
        DEALLOCATE CUR_INSTANCE;
*/



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
		SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, @v_descr, @v_descr, @sysdate

	END CATCH

END


