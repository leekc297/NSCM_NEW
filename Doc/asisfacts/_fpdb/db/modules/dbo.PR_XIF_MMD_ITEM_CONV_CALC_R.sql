
CREATE PROCEDURE [dbo].[PR_XIF_MMD_ITEM_CONV_CALC_R]

-- ================================================================================================
-- Program ID          : FP03032
-- Program Name        : PR_XIF_MMD_ITEM_CONV_CALC_R
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : DW
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_ELTR_CONV_CALC_R
-- Destination Table   : SCM_ITEM_CONV_CALC_M
--
-- Create Date		   : 2018.03.02 PIYONG 1.0
-- Update Date		   : 2018.03.14 PIYONG 1.1
--					     2018.03.15 PIYONG 1.2
--						 2018.03.16 PIYONG 1.3
--						 2018.03.19 PIYONG 1.4
--                       2018.03.20 KIMCD  1.5
--						 2018.03.23 PIYONG 1.6
--						 2018.03.30 PIYONG 1.7
--						 2018.04.11 PIYONG 1.8
--						 2018.05.29 PIYONG 1.9
--						 2018.07.05 PIYONG 2.0
--						 2018.09.18 PIYONG 2.1
--						 2018.09.18 PIYONG 3.0

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 소형 파우치형 전극환산자 추가
--						 1.2 FACTORY = 'E7' AND  [PLANT_ID] = 'G452' 일땐 FACTORY_ID E8
--						 1.3 PLANT_ID  A011  PLANNER 요청으로 제외
--						 1.4 PLANT_ID  3050  PLANNER 요청으로 제외
--						 1.5 PLANT_ID  
--						 1.6 MAX VER FLAG 설정
--						 1.7 선분산 주석 해제, 선분산 OPERATION E0500에서 E1000으로 변경
--							 CATEGORY명 LOOK UP으로 변경
--						 1.8 LOOK UP으로 MMD 데이터 적용 여부로 변경
--							 MMD_VALUE  컬럼 추가
--							 A011,3050 PLANT 제외 조건 주석 처리
--						 1.9 사용자가 변경한 데이터는 VERSION이 변경될때 까지 VALUE 유지
--						 2.0 남경 소형 전극 3,4라인( 광폭) 로직 추가
--						2.1 E8동 사용안함으로 관련로직 삭제 CASE WHEN [BUILDING] = 'E7' AND  [PLANT_ID] = 'G452' THEN 'E8' ELSE [BUILDING] END
--						 3.0 양산, 테스트버전 구분하여 MAX 버전 생성, 버전구분자(VERSION_TYPE) 컬럼 추가 
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MMD_ITEM_CONV_CALC_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	--LOCAL 변수
	DECLARE @infseqno NVARCHAR(20)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			SET @infseqno = (
							SELECT MAX(IFSEQNO)
							   FROM SY_XIF_DW_ELTR_CONV_CALC_R
							  WHERE TRANSFER_FLAG = 'N'
							)

			UPDATE SY_XIF_DW_ELTR_CONV_CALC_R
			   SET TRANSFER_FLAG = 'P'
		     WHERE IFSEQNO = @infseqno
			   AND TRANSFER_FLAG = 'N'


			--PRE_MIXER
			--2018-03-30 PIYONG 주석 해제
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT [COMPANY_ID]
						   ,MAX( DIVISION_ID ) AS [DIVISION_ID]
						   ,MAX( SITE_ID ) AS [SITE_ID]
						   ,MAX( PLANT_ID ) AS [PLANT_ID]
						   ,[FACTORY_ID]
						   ,[OPERATION_ID]
						   ,MAX( PROJECT_NAME ) AS [PROJECT_NAME]
						   ,[VERSION]
						   ,[MODEL_CODE]
						   ,MAX( CA_FLAG ) AS [CA_FLAG]
						   ,[ITEM_ID]
						   ,[ACCT_NAME]
						   ,MAX( VALUE1 ) AS [VALUE1]
						   ,MAX( MAX_VER_FLAG ) AS [MAX_VER_FLAG]
				   			--2018-04-11 PIYONG ADD
						   ,( SELECT ATTRIBUTE3
								FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
							   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
								 AND ACTIVE_FLAG = 'Y'
								 AND SEGMENT1 = [FACTORY_ID]
								 AND SEGMENT2 = OPERATION_ID
								) AS UPDATE_YN
						   ,CASE WHEN RIGHT([VERSION],'1') = 'W' THEN 'WIDE' ELSE 'GENERAL' END AS PROD_VERSION_TYPE	-- 2018-07-05 PIYONG
					  FROM (
							SELECT (SELECT TOP 1 COMPANY_ID
									  FROM SCM_FACTORY_M
									 WHERE PLANT_ID = ECC.PLANT_ID) AS [COMPANY_ID]
								   ,(SELECT TOP 1 DIVISION_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS DIVISION_ID
								   ,(SELECT TOP 1 SITE_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS SITE_ID
								   ,[PLANT_ID]
								   ,[BUILDING] AS [FACTORY_ID] --CASE WHEN [BUILDING] = 'E7' AND  [PLANT_ID] = 'G452' THEN 'E8' ELSE [BUILDING] END AS [FACTORY_ID]	--	2018.03.15 PIYONG --2018-10-19 PIYONG DEL
								   ,'E1000' AS OPERATION_ID		-- 2018-03-30 PIYONG E0500 에서 E1000으로 변경
								   ,[PROJECT_NAME]
								   ,[VERSION]
								   ,[MODEL_CODE]
								   ,'Cathode' AS [CA_FLAG]
								   ,NAME1_COL AS [ITEM_ID]
								   -- 2018-03-30 PIYONG LOOK UP 으로 변경
								    ,(SELECT ATTRIBUTE1
									   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
										AND SEGMENT1 = ECC.[ACCT_NAME]
										AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
								   ,[VALUE1]
								   ,[MAX_VER_FLAG]
							  FROM SY_XIF_DW_ELTR_CONV_CALC_R ECC
							 WHERE IFSEQNO = @infseqno
							   AND TRANSFER_FLAG = 'P'
							   AND [ACCT_CODE] IN ( 'C0100_0100')	--양극 선분산
							   AND [SL_CODE] != ''  
							   AND [SL_CODE] IS NOT NULL
							   AND [VALUE1] IS NOT NULL
						   ) Z
					 WHERE [ITEM_ID] IS NOT NULL
					  --2018-05-29 PIYONG ADD
					   AND NOT EXISTS ( SELECT 1
										   FROM SCM_ITEM_CONV_CALC_M A
										  WHERE A.[COMPANY_ID] = Z.[COMPANY_ID]
											AND A.[FACTORY_ID] = Z.[FACTORY_ID]
											AND A.[MODEL_ID] = Z.[MODEL_CODE]
											AND A.[VERSION] = Z.[VERSION]
											AND A.[OPERATION] = Z.[OPERATION_ID]
											AND A.[ITEM_ID] = Z.[ITEM_ID]
											AND A.[CATEGORY] = Z.[ACCT_NAME]
											AND A.UPDATE_ID != 'PR_XIF_MMD_ITEM_CONV_CALC_R'
									  )
					AND  Z.DIVISION_ID != '40' -- 2018-07-26 kimcd 임시 막음. 소형은 수신 제외
					AND  Z.PLANT_ID != 'G452'	 -- 2018-09-13 PIYONG 임시 막음. CNA 전극 수신 제외
					AND  Z.PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
					
					GROUP BY [COMPANY_ID]
							  ,[FACTORY_ID]
							  ,[MODEL_CODE]
							  ,[VERSION]
							  ,[OPERATION_ID]
							  ,[ITEM_ID]
							  ,[ACCT_NAME]
				  ) B
			  ON ( A.[COMPANY_ID] = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID] = B.[MODEL_CODE]
				  AND A.[VERSION] = B.[VERSION]
				  AND A.[OPERATION] = B.[OPERATION_ID]
				  AND A.[ITEM_ID] = B.[ITEM_ID]
				  AND A.[CATEGORY] = B.[ACCT_NAME]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.UPDATE_YN = 'ALL' THEN 
											  B.[VALUE1]
										    ELSE 
											  A.[VALUE]
										    END															--2018-04-11 PIYONG CHANGE
						   ,[MMD_VALUE] = B.[VALUE1]													--2018-04-11 PIYONG ADD
						   ,[MAX_VER_FLAG] = B.[MAX_VER_FLAG]
						   ,[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]									--2108-07-05 PIYONG ADD
						   ,[UPDATE_ID] = 'PR_XIF_MMD_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]			--2018-04-11 PIYONG ADD
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,[VERSION_TYPE]			--2019-02-16 PIYONG ADD
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]				--2018-04-11 PIYONG ADD
					,B.[MAX_VER_FLAG]
					,B.[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,'MASS'			--2019-02-16 PIYONG ADD
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
				)
			;

			--MIXER			
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT [COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[OPERATION_ID]
						   ,[PROJECT_NAME]
						   ,[VERSION]
						   ,[MODEL_CODE]
						   ,[CA_FLAG]
						   ,[ITEM_ID]
						   ,[ACCT_NAME]
						   ,[VALUE1]
						   ,[MAX_VER_FLAG]
				   			--2018-04-11 PIYONG ADD
						   ,( SELECT ATTRIBUTE3
								FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
							   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
								 AND ACTIVE_FLAG = 'Y'
								 AND SEGMENT1 = FACTORY_ID
								 AND SEGMENT2 = OPERATION_ID
							) AS UPDATE_YN
						   ,CASE WHEN RIGHT([VERSION],'1') = 'W' THEN 'WIDE' ELSE 'GENERAL' END AS PROD_VERSION_TYPE	-- 2018-07-05 PIYONG
					  FROM (
							SELECT (SELECT TOP 1 COMPANY_ID
									  FROM SCM_FACTORY_M
									 WHERE PLANT_ID = ECC.PLANT_ID) AS [COMPANY_ID]
								   ,(SELECT TOP 1 DIVISION_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS DIVISION_ID
								   ,(SELECT TOP 1 SITE_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS SITE_ID
								   ,[PLANT_ID]
								   ,[BUILDING] AS [FACTORY_ID] --CASE WHEN [BUILDING] = 'E7' AND  [PLANT_ID] = 'G452' THEN 'E8' ELSE [BUILDING] END AS [FACTORY_ID]	--	2018.03.15 PIYONG --2018-10-19 PIYONG DEL
								   ,'E1000' AS OPERATION_ID
								   ,[PROJECT_NAME]
								   ,[VERSION]
								   ,[MODEL_CODE]
								   ,CASE WHEN [CA_FLAG] = 'A' THEN
											'Anode'
										 WHEN [CA_FLAG] = 'C' THEN
											'Cathode'
										  END AS [CA_FLAG]
								   ,[SL_CODE] AS [ITEM_ID]
								   ,(SELECT ATTRIBUTE1
									   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
										AND SEGMENT1 = ECC.[ACCT_NAME]
										AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
								   ,[VALUE1]
								   ,[MAX_VER_FLAG]
								   ,ROW_NUMBER() OVER(PARTITION BY  PLANT_ID, BUILDING, PROJECT_NAME, VERSION, MODEL_CODE, CA_FLAG, SL_CODE, ACCT_CODE, PROC_TYPE_CODE
														  ORDER BY TYPE_CODE) AS NUM
							  FROM SY_XIF_DW_ELTR_CONV_CALC_R ECC
							 WHERE IFSEQNO = @infseqno
							   AND TRANSFER_FLAG = 'P'
--							   AND [PLANT_ID] NOT IN ( 'A011', '3050','G383')	--	 2018.03.16 PIYONG ADD , 2018.03.19 PIYONG 3050 ADD -- 2018-04-11 PIYONG DEL
							   AND [ACCT_CODE] IN ( 'A0300_0300', 'C0300_0300')	-- Kg/Batch
							   AND [SL_CODE] != ''  
							   AND [SL_CODE] IS NOT NULL
							   AND [VALUE1] IS NOT NULL
						) BB
				  WHERE NUM = 1
				  --2018-05-29 PIYONG ADD
					AND NOT EXISTS ( SELECT 1
									   FROM SCM_ITEM_CONV_CALC_M A
									  WHERE A.[COMPANY_ID] = BB.[COMPANY_ID]
										AND A.[FACTORY_ID] = BB.[FACTORY_ID]
										AND A.[MODEL_ID] = BB.[MODEL_CODE]
										AND A.[VERSION] = BB.[VERSION]
										AND A.[OPERATION] = BB.[OPERATION_ID]
										AND A.[ITEM_ID] = BB.[ITEM_ID]
										AND A.[CATEGORY] = BB.[ACCT_NAME]
										AND A.UPDATE_ID != 'PR_XIF_MMD_ITEM_CONV_CALC_R'
								  )
					AND  BB.DIVISION_ID != '40' -- 2018-07-26 kimcd 임시 막음. 소형은 수신 제외
					AND  BB.PLANT_ID != 'G452'	-- 2018-09-13 PIYONG 임시 막음. CNA 전극 수신 제외
					AND  BB.PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
				  ) B
			  ON ( A.[COMPANY_ID] = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID] = B.[MODEL_CODE]
				  AND A.[VERSION] = B.[VERSION]
				  AND A.[OPERATION] = B.[OPERATION_ID]
				  AND A.[ITEM_ID] = B.[ITEM_ID]
				  AND A.[CATEGORY] = B.[ACCT_NAME]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.UPDATE_YN = 'ALL' THEN 
													B.[VALUE1]
										    ELSE 
											  A.[VALUE]
										    END															--2018-04-11 PIYONG CHANGE
						   ,[MMD_VALUE] = B.[VALUE1]													--2018-04-11 PIYONG ADD
						   ,[MAX_VER_FLAG] = B.[MAX_VER_FLAG]
						   ,[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]									--2108-07-05 PIYONG ADD
						   ,[UPDATE_ID] = 'PR_XIF_MMD_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]			--2018-04-11 PIYONG ADD
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,[VERSION_TYPE]			--2019-02-16 PIYONG ADD
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]				--2018-04-11 PIYONG ADD
					,B.[MAX_VER_FLAG]
					,B.[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,'MASS'					--2019-02-16 PIYONG ADD
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
				)
			;

			--COATOR			
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT [COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[OPERATION_ID]
						   ,[PROJECT_NAME]
						   ,[VERSION]
						   ,[MODEL_CODE]
						   ,[CA_FLAG]
						   ,[ITEM_ID]
						   ,[ACCT_NAME]
						   ,[VALUE1]
						   ,[MAX_VER_FLAG]
				   			--2018-04-11 PIYONG ADD
						   ,( SELECT ATTRIBUTE3
								FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
							   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
								 AND ACTIVE_FLAG = 'Y'
								 AND SEGMENT1 = FACTORY_ID
								 AND SEGMENT2 = OPERATION_ID
							) AS UPDATE_YN
						  ,CASE WHEN RIGHT([VERSION],'1') = 'W' THEN 'WIDE' ELSE 'GENERAL' END AS PROD_VERSION_TYPE	-- 2018-07-05 PIYONG
					 FROM (
							SELECT (SELECT TOP 1 COMPANY_ID
									  FROM SCM_FACTORY_M
									 WHERE PLANT_ID = ECC.PLANT_ID) AS [COMPANY_ID]
								   ,(SELECT TOP 1 DIVISION_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS DIVISION_ID
								   ,(SELECT TOP 1 SITE_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS SITE_ID
								   ,[PLANT_ID]
								   ,[BUILDING] AS [FACTORY_ID] --CASE WHEN [BUILDING] = 'E7' AND [PLANT_ID] = 'G452' THEN 'E8' ELSE [BUILDING] END AS [FACTORY_ID]	--	2018.03.15 PIYONG --2018-10-19 PIYONG DEL
								   ,'E2000' AS OPERATION_ID
								   ,[PROJECT_NAME]
								   ,[VERSION]
								   ,[MODEL_CODE]
								   ,CASE WHEN [CA_FLAG] = 'A' THEN
											'Anode'
										 WHEN [CA_FLAG] = 'C' THEN
											'Cathode'
										  END AS [CA_FLAG]
								   ,[PC_CODE] AS [ITEM_ID]
								   ,(SELECT ATTRIBUTE1
									   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
										AND SEGMENT1 = ECC.[ACCT_NAME]
										AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
								   ,[VALUE1]
								   ,[MAX_VER_FLAG]
							  FROM SY_XIF_DW_ELTR_CONV_CALC_R ECC
							 WHERE IFSEQNO = @infseqno
							   AND TRANSFER_FLAG = 'P'
--							   AND [PLANT_ID] NOT IN ( 'A011', '3050','G383')	--	 2018.03.16 PIYONG ADD , 2018.03.19 PIYONG 3050 ADD -- 2018-04-11 PIYONG DEL
  							   AND TYPE_FLAG = 'ELEC'
							   AND [ACCT_CODE] IN ( 'A0400_0700', 'C0400_0700'	--Cell/Batch
													, 'C0400_0600', 'A0400_0600' --M/Batch
													, 'A0400_0500', 'C0400_0500' --Jumboroll Cell/M
													, 'A0400_1800', 'C0400_1800' --속도
													, 'A0400_2000', 'C0400_2000' --Lane 수
												  )
							   AND [PC_CODE] != ''  
							   AND [PC_CODE] IS NOT NULL
							   AND [VALUE1] IS NOT NULL
						   )BB
					 WHERE 1=1
					 --2018-05-29 PIYONG ADD
					   AND NOT EXISTS ( SELECT 1
										  FROM SCM_ITEM_CONV_CALC_M A
										 WHERE A.[COMPANY_ID] = BB.[COMPANY_ID]
										   AND A.[FACTORY_ID] = BB.[FACTORY_ID]
										   AND A.[MODEL_ID] = BB.[MODEL_CODE]
										   AND A.[VERSION] = BB.[VERSION]
										   AND A.[OPERATION] = BB.[OPERATION_ID]
										   AND A.[ITEM_ID] = BB.[ITEM_ID]
										   AND A.[CATEGORY] = BB.[ACCT_NAME]
										   AND A.UPDATE_ID != 'PR_XIF_MMD_ITEM_CONV_CALC_R'
										)
					AND  BB.DIVISION_ID != '40' -- 2018-07-26 kimcd 임시 막음. 소형은 수신 제외
					AND  BB.PLANT_ID != 'G452'	-- 2018-09-13 PIYONG 임시 막음. CNA 전극 수신 제외
					AND  BB.PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
				  ) B
			  ON ( A.[COMPANY_ID] = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID] = B.[MODEL_CODE]
				  AND A.[VERSION] = B.[VERSION]
				  AND A.[OPERATION] = B.[OPERATION_ID]
				  AND A.[ITEM_ID] = B.[ITEM_ID]
				  AND A.[CATEGORY] = B.[ACCT_NAME]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.UPDATE_YN = 'ALL' THEN 
												B.[VALUE1]
										    ELSE 
											  A.[VALUE]
										    END															--2018-04-11 PIYONG CHANGE
						   ,[MMD_VALUE] = B.[VALUE1]													--2018-04-11 PIYONG ADD
						   ,[MAX_VER_FLAG] = B.[MAX_VER_FLAG]
						   ,[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]									--2108-07-05 PIYONG ADD
						   ,[UPDATE_ID] = 'PR_XIF_MMD_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]			--2018-04-11 PIYONG ADD
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,[VERSION_TYPE]			--2019-02-16 PIYONG ADD
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]				--2018-04-11 PIYONG ADD
					,B.[MAX_VER_FLAG]
					,B.[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,'MASS'					--2019-02-16  PIYONG ADD
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
				)
			;


			-- 2018-03-14 추가
			--소형 파우치형 전극환산자  COATOR			
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT [COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[OPERATION_ID]
						   ,[PROJECT_NAME]
						   ,[VERSION]
						   ,[MODEL_CODE]
						   ,[CA_FLAG]
						   ,[ITEM_ID]
						   ,[ACCT_NAME]
						   ,[VALUE1]
						   ,[MAX_VER_FLAG]
				   			--2018-04-11 PIYONG ADD
						   ,( SELECT ATTRIBUTE3
								FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
							   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
								 AND ACTIVE_FLAG = 'Y'
								 AND SEGMENT1 = FACTORY_ID
								 AND SEGMENT2 = OPERATION_ID
							) AS UPDATE_YN
						   ,CASE WHEN RIGHT([VERSION],'1') = 'W' THEN 'WIDE' ELSE 'GENERAL' END AS PROD_VERSION_TYPE	-- 2018-07-05 PIYONG
				      FROM (
							SELECT (SELECT TOP 1 COMPANY_ID
									  FROM SCM_FACTORY_M
									 WHERE PLANT_ID = ECC.PLANT_ID) AS [COMPANY_ID]
								   ,(SELECT TOP 1 DIVISION_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS DIVISION_ID
								   ,(SELECT TOP 1 SITE_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS SITE_ID
								   ,[PLANT_ID]
								   ,[BUILDING] AS [FACTORY_ID] --CASE WHEN [BUILDING] = 'E7' AND  [PLANT_ID] = 'G452' THEN 'E8' ELSE [BUILDING] END AS [FACTORY_ID]	--	2018.03.15 PIYONG --2018-10-19 PIYONG DEL
								   ,'E2000' AS OPERATION_ID
								   ,[PROJECT_NAME]
								   ,[VERSION]
								   ,[MODEL_CODE]
								   ,CASE WHEN [CA_FLAG] = 'A' THEN
											'Anode'
										 WHEN [CA_FLAG] = 'C' THEN
											'Cathode'
										  END AS [CA_FLAG]
								   ,CASE WHEN TYPE_CODE = 'D' THEN
											CASE WHEN CharIndex( ',', [PC_CODE]) > 0 THEN
													CASE WHEN CharIndex( ',', [PC_CODE])  < CharIndex( 'CA', [PC_CODE]) THEN
															SUBSTRING([PC_CODE], CharIndex( ',', [PC_CODE])+1 , LEN([PC_CODE]) )
														 ELSE
															SUBSTRING([PC_CODE], 1, CharIndex( ',', [PC_CODE]) -1 )
														  END
												  ELSE
													[PC_CODE]
												  END
										 WHEN TYPE_CODE = 'S' THEN
											CASE WHEN CharIndex( ',', [PC_CODE]) > 0 THEN
													CASE WHEN CharIndex( ',', [PC_CODE])  < CharIndex( 'CS', [PC_CODE]) THEN
															SUBSTRING([PC_CODE], CharIndex( ',', [PC_CODE])+1 , LEN([PC_CODE]) )
														 ELSE
															SUBSTRING([PC_CODE], 1, CharIndex( ',', [PC_CODE]) -1 )
														  END
												 ELSE
													[PC_CODE]
												 END
										 ELSE
											[PC_CODE]
										 END AS [ITEM_ID]
								   ,(SELECT ATTRIBUTE1
									   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
										AND SEGMENT1 = ECC.[ACCT_NAME]
										AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
								   ,[VALUE1]
								   ,[MAX_VER_FLAG]
								   ,ROW_NUMBER() OVER(PARTITION BY PLANT_ID, BUILDING, PROJECT_NAME, VERSION, MODEL_CODE, CA_FLAG, SL_CODE, ACCT_CODE, PROC_TYPE_CODE
														  ORDER BY TYPE_CODE) AS NUM
							  FROM SY_XIF_DW_ELTR_CONV_CALC_R ECC
							 WHERE IFSEQNO = @infseqno
							   AND TRANSFER_FLAG = 'P'
--							   AND [PLANT_ID] NOT IN ( 'A011', '3050','G383')	--	 2018.03.16 PIYONG ADD , 2018.03.19 PIYONG 3050 ADD -- 2018-04-11 PIYONG DEL
  							   AND TYPE_FLAG = 'MOBILE'
							   AND [ACCT_CODE] IN ( 'A0400_1000', 'C0400_1000'	--Cell/Batch
													, 'A0400_0900', 'C0400_0900' --M/Batch
													, 'A0400_0800', 'C0400_0800' --Jumboroll Cell/M
													, 'A0400_2100', 'C0400_2100' --속도
													, 'A0400_0300', 'C0400_0300' --Lane 수
												  )
							   AND (  
									  ( TYPE_CODE = 'D'AND CharIndex( 'CA', [PC_CODE]) > 0 )  OR
									  ( TYPE_CODE = 'S'AND CharIndex( 'CS' , [PC_CODE]) > 0 )  OR
									  (TYPE_CODE IN  ('W', 'R'))
								   )
							   AND [PC_CODE] IS NOT NULL
							   AND [VALUE1] IS NOT NULL
							   AND [PC_CODE] != ''  
						   ) BB
					 WHERE NUM  = 1 
					 --2018-05-29 PIYONG ADD
					   AND NOT EXISTS ( SELECT 1
										FROM SCM_ITEM_CONV_CALC_M A
										WHERE A.[COMPANY_ID] = BB.[COMPANY_ID]
											AND A.[FACTORY_ID] = BB.[FACTORY_ID]
											AND A.[MODEL_ID] = BB.[MODEL_CODE]
											AND A.[VERSION] = BB.[VERSION]
											AND A.[OPERATION] = BB.[OPERATION_ID]
											AND A.[ITEM_ID] = BB.[ITEM_ID]
											AND A.[CATEGORY] = BB.[ACCT_NAME]
											AND A.UPDATE_ID != 'PR_XIF_MMD_ITEM_CONV_CALC_R'
									  )
					AND  BB.DIVISION_ID != '40' -- 2018-07-26 kimcd 임시 막음. 소형은 수신 제외
					AND  BB.PLANT_ID != 'G452'	-- 2018-09-13 PIYONG 임시 막음. CNA 전극 수신 제외
					AND  BB.PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
				  ) B
			  ON ( A.[COMPANY_ID] = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID] = B.[MODEL_CODE]
				  AND A.[VERSION] = B.[VERSION]
				  AND A.[OPERATION] = B.[OPERATION_ID]
				  AND A.[ITEM_ID] = B.[ITEM_ID]
				  AND A.[CATEGORY] = B.[ACCT_NAME]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.UPDATE_YN = 'ALL' THEN 
											  B.[VALUE1]
										    ELSE 
											  A.[VALUE]
										    END															--2018-04-11 PIYONG CHANGE
						   ,[MMD_VALUE] = B.[VALUE1]													--2018-04-11 PIYONG ADD
						   ,[MAX_VER_FLAG] = B.[MAX_VER_FLAG]
						   ,[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]									--2108-07-05 PIYONG ADD
						   ,[UPDATE_ID] = 'PR_XIF_MMD_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]			--2018-04-11 PIYONG ADD
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,[VERSION_TYPE]			--2019-02-16 PIYONG ADD
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]				--2018-04-11 PIYONG ADD
					,B.[MAX_VER_FLAG]
					,B.[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,'MASS'					--2019-02-16 PIYONG ADD
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
				)
			;


			--R/P			
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT [COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[OPERATION_ID]
						   ,[PROJECT_NAME]
						   ,[VERSION]
						   ,[MODEL_CODE]
						   ,[CA_FLAG]
						   ,[ITEM_ID]
						   ,[ACCT_NAME]
						   ,[VALUE1]
						   ,[MAX_VER_FLAG]
				   			--2018-04-11 PIYONG ADD
						   ,( SELECT ATTRIBUTE3
								FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
							   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
								 AND ACTIVE_FLAG = 'Y'
								 AND SEGMENT1 = FACTORY_ID
								 AND SEGMENT2 = OPERATION_ID
							) AS UPDATE_YN
						   ,CASE WHEN RIGHT([VERSION],'1') = 'W' THEN 'WIDE' ELSE 'GENERAL' END AS PROD_VERSION_TYPE	-- 2018-07-05 PIYONG
					 FROM  (
							SELECT (SELECT TOP 1 COMPANY_ID
									  FROM SCM_FACTORY_M
									 WHERE PLANT_ID = ECC.PLANT_ID) AS [COMPANY_ID]
								   ,(SELECT TOP 1 DIVISION_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS DIVISION_ID
								   ,(SELECT TOP 1 SITE_ID
									   FROM SCM_FACTORY_M
									  WHERE PLANT_ID = ECC.PLANT_ID) AS SITE_ID
								   ,[PLANT_ID]
								   ,[BUILDING] AS [FACTORY_ID] --CASE WHEN [BUILDING] = 'E7' AND  [PLANT_ID] = 'G452' THEN 'E8' ELSE [BUILDING] END AS [FACTORY_ID]	--	2018.03.15 PIYONG --2018-10-19 PIYONG DEL
								   ,'E3000' AS OPERATION_ID
								   ,[PROJECT_NAME]
								   ,[VERSION]
								   ,[MODEL_CODE]
								   ,CASE WHEN [CA_FLAG] = 'A' THEN
											'Anode'
										 WHEN [CA_FLAG] = 'C' THEN
											'Cathode'
										  END AS [CA_FLAG]
									-- 2018-03-14 변경
								   ,CASE WHEN TYPE_FLAG = 'ELEC' AND TYPE_CODE IS NULL THEN
											[PC_CODE]
										 WHEN TYPE_FLAG = 'MOBILE' AND TYPE_CODE = 'D' THEN
											CASE WHEN CharIndex( ',', [PC_CODE]) > 0 THEN
													CASE WHEN CharIndex( ',', [PC_CODE])  < CharIndex( 'CA', [PC_CODE]) THEN
																SUBSTRING([PC_CODE], CharIndex( ',', [PC_CODE]) +1, LEN([PC_CODE]) )
														 ELSE
															SUBSTRING([PC_CODE], 1, CharIndex( ',', [PC_CODE]) -1 )
														  END
												  ELSE
													[PC_CODE]
												  END
										 WHEN TYPE_FLAG = 'MOBILE' AND TYPE_CODE = 'S' THEN
											CASE WHEN CharIndex( ',', [PC_CODE]) > 0 THEN
													CASE WHEN CharIndex( ',', [PC_CODE])  < CharIndex( 'CS', [PC_CODE]) THEN
																SUBSTRING([PC_CODE], CharIndex( ',', [PC_CODE]) +1, LEN([PC_CODE]) )
														 ELSE
															SUBSTRING([PC_CODE], 1, CharIndex( ',', [PC_CODE]) -1 )
														  END
												  ELSE
													[PC_CODE]
												  END
										 ELSE
											[PC_CODE]
										 END AS [ITEM_ID]
									-- 2018-03-14 변경 끝
								   ,(SELECT ATTRIBUTE1
									   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									  WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
										AND SEGMENT1 = ECC.[ACCT_NAME]
										AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
								   ,[VALUE1]
								   ,[MAX_VER_FLAG]
								   ,ROW_NUMBER() OVER(PARTITION BY  PLANT_ID, BUILDING, PROJECT_NAME, VERSION, MODEL_CODE, CA_FLAG, SL_CODE, ACCT_CODE, PROC_TYPE_CODE
														  ORDER BY TYPE_CODE) AS NUM
							  FROM SY_XIF_DW_ELTR_CONV_CALC_R ECC
							 WHERE IFSEQNO = @infseqno
							   AND TRANSFER_FLAG = 'P'
--							   AND [PLANT_ID] NOT IN ( 'A011', '3050','G383')	--	 2018.03.16 PIYONG ADD , 2018.03.19 PIYONG 3050 ADD -- 2018-04-11 PIYONG DEL
							   AND [ACCT_CODE] IN ( 'A0500_0300', 'C0500_0300')	--	속도
							   AND [PC_CODE] != ''  
							   AND [PC_CODE] IS NOT NULL
							   AND [VALUE1] IS NOT NULL
						   ) BB
					 WHERE NUM = 1
					 --2018-05-29 PIYONG ADD
					   AND NOT EXISTS (
										SELECT 1
										  FROM SCM_ITEM_CONV_CALC_M A
									     WHERE A.[COMPANY_ID] = BB.[COMPANY_ID]
										   AND A.[FACTORY_ID] = BB.[FACTORY_ID]
										   AND A.[MODEL_ID] = BB.[MODEL_CODE]
										   AND A.[VERSION] = BB.[VERSION]
										   AND A.[OPERATION] = BB.[OPERATION_ID]
										   AND A.[ITEM_ID] = BB.[ITEM_ID]
										   AND A.[CATEGORY] = BB.[ACCT_NAME]
										   AND A.UPDATE_ID != 'PR_XIF_MMD_ITEM_CONV_CALC_R'
									  )
					AND  BB.DIVISION_ID != '40' -- 2018-07-26 kimcd 임시 막음. 소형은 수신 제외
					AND  BB.PLANT_ID != 'G452'	-- 2018-09-13 PIYONG 임시 막음. CNA 전극 수신 제외
					AND  BB.PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
				  ) B
			  ON ( A.[COMPANY_ID] = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID] = B.[MODEL_CODE]
				  AND A.[VERSION] = B.[VERSION]
				  AND A.[OPERATION] = B.[OPERATION_ID]
				  AND A.[ITEM_ID] = B.[ITEM_ID]
				  AND A.[CATEGORY] = B.[ACCT_NAME]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.UPDATE_YN = 'ALL' THEN 
											 B.[VALUE1]
										    ELSE 
											  A.[VALUE]
										    END															--2018-04-11 PIYONG CHANGE
						   ,[MMD_VALUE] = B.[VALUE1]													--2018-04-11 PIYONG ADD
						   ,[MAX_VER_FLAG] = B.[MAX_VER_FLAG]
						   ,[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]									--2108-07-05 PIYONG ADD
						   ,[UPDATE_ID] = 'PR_XIF_MMD_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]				--2018-04-11 PIYONG ADD
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]		--2108-07-05 PIYONG ADD
					,[VERSION_TYPE]			--2019-02-16 PIYONG ADD
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]					--2018-04-11 PIYONG ADD
					,B.[MAX_VER_FLAG]
					,B.[PROD_VERSION_TYPE]		--2108-07-05 PIYONG ADD
					,'MASS'						--2019-02-16 PIYONG ADD
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
				)
			;


			--Slitter		
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT [COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[OPERATION_ID]
						   ,[PROJECT_NAME]
						   ,[VERSION]
						   ,[MODEL_CODE]
						   ,[CA_FLAG]
						   ,[ITEM_ID]
						   ,[ACCT_NAME]
						   ,[VALUE1]
						   ,[MAX_VER_FLAG]
				   			--2018-04-11 PIYONG ADD
						   ,( SELECT ATTRIBUTE3
								FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
							   WHERE SV.LOOKUP_TYPE_CODE = 'FACTORY_GPLM_APPLY_TYPE'
								 AND ACTIVE_FLAG = 'Y'
								 AND SEGMENT1 = FACTORY_ID
								 AND SEGMENT2 = OPERATION_ID
							) AS UPDATE_YN
						   ,CASE WHEN RIGHT([VERSION],'1') = 'W' THEN 'WIDE' ELSE 'GENERAL' END AS PROD_VERSION_TYPE	-- 2018-07-05 PIYONG
					  FROM ( 
							SELECT (SELECT TOP 1 COMPANY_ID
									  FROM SCM_FACTORY_M
									 WHERE PLANT_ID = ECC.PLANT_ID) AS [COMPANY_ID]
									,(SELECT TOP 1 DIVISION_ID
									    FROM SCM_FACTORY_M
									   WHERE PLANT_ID = ECC.PLANT_ID) AS DIVISION_ID
									,(SELECT TOP 1 SITE_ID
										FROM SCM_FACTORY_M
									   WHERE PLANT_ID = ECC.PLANT_ID) AS SITE_ID
									,[PLANT_ID]
									,[BUILDING] AS [FACTORY_ID] --CASE WHEN [BUILDING] = 'E7' AND  [PLANT_ID] = 'G452' THEN 'E8' ELSE [BUILDING] END AS [FACTORY_ID]	--	2018.03.15 PIYONG --2018-10-19 PIYONG DEL
									,'E4000' AS OPERATION_ID
									,[PROJECT_NAME]
									,[VERSION]
									,[MODEL_CODE]
									,CASE WHEN [CA_FLAG] = 'A' THEN
											'Anode'
											WHEN [CA_FLAG] = 'C' THEN
											'Cathode'
											END AS [CA_FLAG]
									-- 2018-03-14 변경
									,CASE WHEN TYPE_FLAG = 'ELEC' AND TYPE_CODE IS NULL THEN
											[PC_CODE]
										  WHEN TYPE_FLAG = 'MOBILE' AND TYPE_CODE = 'D' THEN
											CASE WHEN CharIndex( ',', [PC_CODE]) > 0 THEN
													CASE WHEN CharIndex( ',', [PC_CODE])  < CharIndex( 'CA', [PC_CODE]) THEN
															SUBSTRING([PC_CODE], CharIndex( ',', [PC_CODE]) +1, LEN([PC_CODE]) )
														 ELSE
															SUBSTRING([PC_CODE], 1, CharIndex( ',', [PC_CODE]) -1 )
														 END
												 ELSE
													[PC_CODE]
												 END
										  WHEN TYPE_FLAG = 'MOBILE' AND TYPE_CODE = 'S' THEN
											CASE WHEN CharIndex( ',', [PC_CODE]) > 0 THEN
													CASE WHEN CharIndex( ',', [PC_CODE])  < CharIndex( 'CS', [PC_CODE]) THEN
															SUBSTRING([PC_CODE], CharIndex( ',', [PC_CODE]) +1, LEN([PC_CODE]) )
														 ELSE
															SUBSTRING([PC_CODE], 1, CharIndex( ',', [PC_CODE]) -1 )
														 END
												 ELSE
													[PC_CODE]
												 END
										 ELSE
											[PC_CODE]
										 END AS [ITEM_ID]
									-- 2018-03-14 변경 끝
									,(SELECT ATTRIBUTE1
										FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
										WHERE LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
										AND SEGMENT1 = ECC.[ACCT_NAME]
										AND ACTIVE_FLAG = 'Y') AS [ACCT_NAME]
									,[VALUE1]
									,[MAX_VER_FLAG]
								FROM SY_XIF_DW_ELTR_CONV_CALC_R ECC
								WHERE IFSEQNO = @infseqno
								AND TRANSFER_FLAG = 'P'
--							   AND [PLANT_ID] NOT IN ( 'A011', '3050','G383')		--	 2018.03.16 PIYONG ADD , 2018.03.19 PIYONG 3050 ADD -- 2018-04-11 PIYONG DEL
								AND TYPE_FLAG = 'ELEC'
								AND [ACCT_CODE] IN ( 'A0700_0700', 'C0700_0700'		-- 속도
													, 'A0700_0100', 'C0700_0100'	-- Pancake Cell/M
													, 'C0700_0200'					-- CUT
													)
								AND [PC_CODE] != ''  
								AND [PC_CODE] IS NOT NULL
								AND [VALUE1] IS NOT NULL
						   )BB
				     --2018-05-29 PIYONG ADD
					 WHERE NOT EXISTS ( SELECT 1
										  FROM SCM_ITEM_CONV_CALC_M A
										 WHERE A.[COMPANY_ID] = BB.[COMPANY_ID]
											AND A.[FACTORY_ID] = BB.[FACTORY_ID]
											AND A.[MODEL_ID] = BB.[MODEL_CODE]
											AND A.[VERSION] = BB.[VERSION]
											AND A.[OPERATION] = BB.[OPERATION_ID]
											AND A.[ITEM_ID] = BB.[ITEM_ID]
											AND A.[CATEGORY] = BB.[ACCT_NAME]
											AND A.UPDATE_ID != 'PR_XIF_MMD_ITEM_CONV_CALC_R'
									  )
					AND  BB.DIVISION_ID != '40' -- 2018-07-26 kimcd 임시 막음. 소형은 수신 제외
					AND  BB.PLANT_ID != 'G452'	-- 2018-09-13 PIYONG 임시 막음. CNA 전극 수신 제외
					AND  BB.PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
				  ) B
			  ON ( A.[COMPANY_ID] = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID] = B.[MODEL_CODE]
				  AND A.[VERSION] = B.[VERSION]
				  AND A.[OPERATION] = B.[OPERATION_ID]
				  AND A.[ITEM_ID] = B.[ITEM_ID]
				  AND A.[CATEGORY] = B.[ACCT_NAME]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE] = B.[PROJECT_NAME]
				           ,[ELECTRODE_TYPE] = B.[CA_FLAG]
						   ,[CATEGORY] = B.[ACCT_NAME]
						   ,[VALUE] = CASE WHEN B.UPDATE_YN = 'ALL' THEN 
											  B.[VALUE1]
										    ELSE 
											  A.[VALUE]
										    END															--2018-04-11 PIYONG CHANGE
						   ,[MMD_VALUE] = B.[VALUE1]													--2018-04-11 PIYONG ADD
						   ,[MAX_VER_FLAG] = B.[MAX_VER_FLAG]
						   ,[PROD_VERSION_TYPE] = B.[PROD_VERSION_TYPE]									--2108-07-05 PIYONG ADD
						   ,[UPDATE_ID] = 'PR_XIF_MMD_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]			--2018-04-11 PIYONG ADD
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,[VERSION_TYPE]			--2019-02-16 PIYONG ADD
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_CODE]
					,B.[PROJECT_NAME]
					,B.[VERSION]
					,B.[OPERATION_ID]
					,B.[ITEM_ID]
					,B.[CA_FLAG]
					,B.[ACCT_NAME]
					,B.[VALUE1]
					,B.[VALUE1]				--2018-04-11 PIYONG ADD
					,[MAX_VER_FLAG]
					,B.[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,'MASS'					--2019-02-16 PIYONG ADD
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
				)
			;

			UPDATE SY_XIF_DW_ELTR_CONV_CALC_R
			   SET TRANSFER_FLAG = 'Y'
		     WHERE IFSEQNO = @infseqno
			   AND TRANSFER_FLAG = 'P'

			-- 2018-03-20 kimcd add start
			-- lane 기준으로 곱하는 경우 추가
			-- Jumbo Roll m/batch을	(Pancake) m/batch 로 전환
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT B.COMPANY_ID
						  ,B.DIVISION_ID
						  ,B.SITE_ID
						  ,B.PLANT_ID
						  ,B.FACTORY_ID
						  ,B.OPERATION
						  ,B.PJT_CODE
						  ,B.VERSION
						  ,B.MODEL_ID
						  ,B.ELECTRODE_TYPE
						  ,B.ITEM_ID
						  ,SLV.ATTRIBUTE1  AS CATEGORY
						  ,B.VALUE * C.VALUE AS VALUE
						  ,B.MMD_VALUE * C.MMD_VALUE AS MMD_VALUE			--2018-04-11 PIYONG ADD
						  ,B.MAX_VER_FLAG
						  ,B.PROD_VERSION_TYPE								--2108-07-05 PIYONG ADD
						  ,B.[VERSION_TYPE]									--2019-02-16 PIYONG ADD							
					  FROM DBO.SCM_ITEM_CONV_CALC_M  B
						  ,DBO.SCM_ITEM_CONV_CALC_M  C
						  ,DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
					 WHERE SLV.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
					 AND   SLV.SEGMENT1    = B.CATEGORY
					 AND   SLV.ACTIVE_FLAG = 'Y'
					 AND   SLV.ATTRIBUTE3  = 'MULTIPLY'
					 AND   C.COMPANY_ID    = B.COMPANY_ID
					 AND   C.FACTORY_ID    = B.FACTORY_ID
					 AND   C.MODEL_ID      = B.MODEL_ID
					 AND   C.VERSION       = B.VERSION
					 AND   C.OPERATION     = B.OPERATION
					 AND   C.ITEM_ID       = B.ITEM_ID
					 AND   C.CATEGORY      = 'Lane Number'
--					 AND   B.PLANT_ID NOT IN ( 'A011', '3050','G383')		-- 2018-04-11 PIYONG DEL
--					 AND   B.VALUE         > 0								-- 2018-04-11 PIYONG DEL
					 AND   B.OPERATION     = 'E2000'
					 AND   B.UPDATE_TIME  >= CONVERT( DATE, GETDATE())
					 AND   B.PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
					 --2018-05-29 PIYONG ADD
					 AND   NOT EXISTS (
										SELECT 1
										  FROM SCM_ITEM_CONV_CALC_M A
										 WHERE A.[COMPANY_ID] = C.[COMPANY_ID]
										   AND A.[FACTORY_ID] = C.[FACTORY_ID]
										   AND A.[MODEL_ID] = C.MODEL_ID
										   AND A.[VERSION] = C.[VERSION]
										   AND A.[OPERATION] = C.OPERATION
										   AND A.[ITEM_ID] = C.[ITEM_ID]
										   AND A.[CATEGORY] = SLV.ATTRIBUTE1
										   AND A.UPDATE_ID != 'PR_XIF_MMD_ITEM_CONV_CALC_R'
									  )
					) B
			  ON (A.[COMPANY_ID]     = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID]   = B.[MODEL_ID]
				  AND A.[VERSION]    = B.[VERSION]
				  AND A.[OPERATION]  = B.[OPERATION]
				  AND A.[ITEM_ID]    = B.[ITEM_ID]
				  AND A.[CATEGORY]   = B.[CATEGORY]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE]        = B.[PJT_CODE]
				           ,[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
						   ,[VALUE]          = B.[VALUE]
						   ,[MMD_VALUE]		 = B.[MMD_VALUE]				--2018-04-11 PIYONG ADD
						   ,[MAX_VER_FLAG]   = B.[MAX_VER_FLAG]
		   				   ,[PROD_VERSION_TYPE] = B.PROD_VERSION_TYPE								--2108-07-05 PIYONG ADD
						   ,[UPDATE_ID]      = 'PR_XIF_MMD_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME]    = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]			--2018-04-11 PIYONG ADD
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD
					,[VERSION_TYPE]			--2019-02-16 PIYONG ADD
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_ID]
					,B.[PJT_CODE]
					,B.[VERSION]
					,B.[OPERATION]
					,B.[ITEM_ID]
					,B.[ELECTRODE_TYPE]
					,B.[CATEGORY]
					,B.[VALUE]
					,B.[MMD_VALUE]			--2018-04-11 PIYONG ADD
					,B.[MAX_VER_FLAG]
				    ,B.PROD_VERSION_TYPE	--2108-07-05 PIYONG ADD
					,B.[VERSION_TYPE]		--2019-02-16 PIYONG ADD
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
				)
			;

			-- lane 기준으로 나누는 경우 추가
			-- Jumbo Roll (cell/m)를 Pancake (cell/m) 로 전환
			MERGE INTO SCM_ITEM_CONV_CALC_M A
			USING (
					SELECT B.COMPANY_ID
						  ,B.DIVISION_ID
						  ,B.SITE_ID
						  ,B.PLANT_ID
						  ,B.FACTORY_ID
						  ,B.OPERATION
						  ,B.PJT_CODE
						  ,B.VERSION
						  ,B.MODEL_ID
						  ,B.ELECTRODE_TYPE
						  ,B.ITEM_ID
						  ,SLV.ATTRIBUTE1  AS CATEGORY
					      ,B.VALUE / CASE WHEN C.VALUE = 0 THEN 1 ELSE C.VALUE END AS VALUE							--2018-04-11 PIYONG CHANGE
						  ,B.MMD_VALUE / CASE WHEN C.MMD_VALUE = 0 THEN 1 ELSE C.MMD_VALUE END AS MMD_VALUE			--2018-04-11 PIYONG ADD
						  ,B.MAX_VER_FLAG
						  ,B.PROD_VERSION_TYPE																		--2108-07-05 PIYONG
						  ,B.[VERSION_TYPE]																			--2019-02-16 PIYONG ADD
					  FROM DBO.SCM_ITEM_CONV_CALC_M  B
						  ,DBO.SCM_ITEM_CONV_CALC_M  C
						  ,DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
					 WHERE SLV.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
					 AND   SLV.SEGMENT1    = B.CATEGORY
					 AND   SLV.ACTIVE_FLAG = 'Y'
					 AND   SLV.ATTRIBUTE3  = 'DIVIDE'
					 AND   C.COMPANY_ID    = B.COMPANY_ID
					 AND   C.FACTORY_ID    = B.FACTORY_ID
					 AND   C.MODEL_ID      = B.MODEL_ID
					 AND   C.VERSION       = B.VERSION
					 AND   C.OPERATION     = B.OPERATION
					 AND   C.ITEM_ID       = B.ITEM_ID
					 AND   C.CATEGORY      = 'Lane Number'
--					 AND   B.PLANT_ID NOT IN ( 'A011', '3050', 'G383')		-- 2018-04-11 PIYONG DEL
--					 AND   B.VALUE         > 0								-- 2018-04-11 PIYONG DEL
					 AND   B.OPERATION     = 'E2000'
					 AND   B.UPDATE_TIME  >= CONVERT( DATE, GETDATE())
					 AND   B.PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
					  --2018-05-29 PIYONG ADD
					 AND   NOT EXISTS (
										SELECT 1
										  FROM SCM_ITEM_CONV_CALC_M A
										 WHERE A.[COMPANY_ID] = C.[COMPANY_ID]
										   AND A.[FACTORY_ID] = C.[FACTORY_ID]
										   AND A.[MODEL_ID] = C.MODEL_ID
										   AND A.[VERSION] = C.[VERSION]
										   AND A.[OPERATION] = C.OPERATION
										   AND A.[ITEM_ID] = C.[ITEM_ID]
										   AND A.[CATEGORY] = SLV.ATTRIBUTE1
										   AND A.UPDATE_ID != 'PR_XIF_MMD_ITEM_CONV_CALC_R'
									  )
					) B
			  ON (A.[COMPANY_ID]     = B.[COMPANY_ID]
				  AND A.[FACTORY_ID] = B.[FACTORY_ID]
				  AND A.[MODEL_ID]   = B.[MODEL_ID]
				  AND A.[VERSION]    = B.[VERSION]
				  AND A.[OPERATION]  = B.[OPERATION]
				  AND A.[ITEM_ID]    = B.[ITEM_ID]
				  AND A.[CATEGORY]   = B.[CATEGORY]
			     )
			WHEN MATCHED THEN
				UPDATE SET [PJT_CODE]        = B.[PJT_CODE]
				           ,[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
						   ,[VALUE]          = B.[VALUE]
						   ,[MMD_VALUE]		 = B.[MMD_VALUE]				--2018-04-11 PIYONG ADD
						   ,[MAX_VER_FLAG]   = B.[MAX_VER_FLAG]
						   ,[PROD_VERSION_TYPE] = B.PROD_VERSION_TYPE		--2108-07-05 PIYONG ADD 
						   ,[UPDATE_ID]      = 'PR_XIF_MMD_ITEM_CONV_CALC_R'
						   ,[UPDATE_TIME]    = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT (
					[COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[MODEL_ID]
					,[PJT_CODE]
					,[VERSION]
					,[OPERATION]
					,[ITEM_ID]
					,[ELECTRODE_TYPE]
					,[CATEGORY]
					,[VALUE]
					,[MMD_VALUE]			--2018-04-11 PIYONG ADD
					,[MAX_VER_FLAG]
					,[PROD_VERSION_TYPE]	--2108-07-05 PIYONG ADD 
					,[VERSION_TYPE]			--2019-02-16 PIYONG ADD							
					,[CREATE_ID]
					,[CREATE_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
				) VALUES (
					B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[MODEL_ID]
					,B.[PJT_CODE]
					,B.[VERSION]
					,B.[OPERATION]
					,B.[ITEM_ID]
					,B.[ELECTRODE_TYPE]
					,B.[CATEGORY]
					,B.[VALUE]
					,B.[MMD_VALUE]			--2018-04-11 PIYONG ADD
					,B.[MAX_VER_FLAG]
					,B.PROD_VERSION_TYPE	--2108-07-05 PIYONG ADD 
					,B.[VERSION_TYPE]									--2019-02-16 PIYONG ADD							
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
					,'PR_XIF_MMD_ITEM_CONV_CALC_R'
					,GETDATE()
				)
			;

			-- 2018-03-20 kimcd add end

			------------------------------------------------------------------------------------------------------------------------------------------------------------
			--2018-03-23 PIYONG MAX VER FLAG 설정 시작
			------------------------------------------------------------------------------------------------------------------------------------------------------------

			-- 전체 N으로 변경
			UPDATE [SCM_ITEM_CONV_CALC_M]
			   SET MAX_VER_FLAG = 'N'
				WHERE  PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
						
			-- Y로 재설정
			UPDATE B
			   SET B.MAX_VER_FLAG = 'Y'
				   ,B.VERSION_TYPE = A.VERSION_TYPE		--2018-09-18 PIYONG ADD
			  FROM [dbo].[SCM_ITEM_CONV_CALC_M] B
				   ,( SELECT A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.MODEL_ID
							 , A.OPERATION
							 , A.ITEM_ID
							 , A.VERSION
							 , CASE WHEN LEFT(VERSION, 1) = 'Z' THEN
										'TEST'
									ELSE
										'MASS'
									END AS VERSION_TYPE
						FROM (
							   SELECT A.COMPANY_ID
									  , A.DIVISION_ID
									  , A.SITE_ID
									  , A.PLANT_ID
									  , A.FACTORY_ID
									  , A.MODEL_ID
									  , A.OPERATION
									  , A.ITEM_ID
									  , A.VERSION
									--, A.CH_VERSION		--	2108-09-18 PIYONG 삭제
									  , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
																	 , A.MODEL_ID, A.OPERATION, A.ITEM_ID, CASE WHEN RIGHT(VERSION, 1) = 'W' THEN 'W' ELSE '-' END
																	 ,CASE WHEN LEFT(VERSION, 1) = 'Z' THEN		'T'	ELSE	'M'	END							--	2018-09-18 PIYONG ADD
															   ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID
																	 , A.OPERATION, A.ITEM_ID, A.VERSION DESC ) AS ROW_NUM	--	2018-09-18 PIYONG ORDER BY CH_VERSION -> VERSION 변경
								 FROM (
										SELECT DISTINCT A.COMPANY_ID
											   , A.DIVISION_ID
											   , A.SITE_ID
											   , A.PLANT_ID
											   , A.FACTORY_ID
											   , A.MODEL_ID
											   , A.OPERATION
											   , A.ITEM_ID
											   , A.VERSION
											-- , CASE WHEN A.VERSION LIKE 'Z%' THEN REPLACE( A.VERSION, 'Z', '/') ELSE A.VERSION END AS CH_VERSION	--2108-09-18 PIYONG 삭제
										  FROM SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
										  WHERE A.PLANT_ID = 'HQ07' -- 2018-12-13 KIMCD PLANT_ID = 'HQ07' Plant 조건 hard coding
									  ) A
							 ) A
					   WHERE ROW_NUM = 1
				   ) A
			 WHERE A.COMPANY_ID = B.COMPANY_ID
			   AND A.DIVISION_ID = B.DIVISION_ID
			   AND A.SITE_ID = B.SITE_ID
			   AND A.PLANT_ID = B.PLANT_ID
			   AND A.FACTORY_ID = B.FACTORY_ID
			   AND A.MODEL_ID = B.MODEL_ID
			   AND A.OPERATION = B.OPERATION
			   AND A.ITEM_ID = B.ITEM_ID
			   AND A.VERSION = B.VERSION

			------------------------------------------------------------------------------------------------------------------------------------------------------------
			--2018-03-23 PIYONG MAX VER FLAG 설정 시작
			------------------------------------------------------------------------------------------------------------------------------------------------------------


		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
