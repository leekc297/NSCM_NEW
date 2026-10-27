
CREATE PROCEDURE [dbo].[PR_XIF_QMS_PROD_TARGET_S]


-- ================================================================================================
-- Program ID          : FP02632
-- Program Name        : PR_XIF_QMS_PROD_TARGET_S
-- Param               :
-- Batch Period        : 0 Minute
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_R
-- Destination Table   : XIF_QMS_PROD_TARGET_S
--
-- Create(Update) Date : 2019.10.21
-- Update Date         : 2022.11.17  leeseongmin  1.2
--
-- Author              : PIYONG
-- Version             : 1.0  2019-10-21 최초 형성
--                       1.1  2022-03-28 kimcd 가상 Division 사용에 따른 로직 보완
--                       1.2  2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
-- ================================================================================================

-- PARAM PLAN_ID
--@P_FP_PLAN_ID NVARCHAR(50) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_QMS_PROD_TARGET_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER	  = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @if_id_code             NVARCHAR(50)  = 'OFP0_GQMS_QMS_PROD_TARGET'
	DECLARE @send_date              NVARCHAR(50)

	DECLARE @INSTANCE_ID			NVARCHAR(30)
	DECLARE @RELEASE_PLAN_ID		NVARCHAR(30)
	DECLARE @PLAN_GROUP_ID			NVARCHAR(30)
	DECLARE @FACTORY_ID				NVARCHAR(30)
	DECLARE @INSTANCE_TYPE			NVARCHAR(30)

	DECLARE CUR_PLAN CURSOR FOR
		SELECT A.INSTANCE_ID
			   ,A.RELEASE_PLAN_ID
			   ,A.PLAN_GROUP_ID
			   ,A.FACTORY_ID
			   ,(
					SELECT TOP 1 IFM.INSTANCE_TYPE
					  FROM FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
					 WHERE IFM.INSTANCE_ID = A.INSTANCE_ID			) AS INSTANCE_TYPE
		  FROM (
				SELECT A.INSTANCE_ID
					   ,A.RELEASE_PLAN_ID
					   ,A.PLAN_GROUP_ID
					   ,'-'      AS FACTORY_ID   -- 2019-02-18 kimcd 컬럼 추가
				FROM   DBO.SCM_FP_PLAN_GROUP_DETAIL_H A
				WHERE  MES_TRANSFER_FLAG = 'Y'
				AND    PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112) 
				UNION ALL
				SELECT A.INSTANCE_ID
					   ,A.RELEASE_PLAN_ID
					   ,'-' AS PLAN_GROUP_ID
					   ,A.FACTORY_ID             -- 2019-02-18 kimcd 컬럼 추가
				FROM   DBO.SCM_FP_PLAN_DETAIL_H A
				WHERE  MES_TRANSFER_FLAG = 'Y'
				AND    INSTANCE_ID != 'KR_CELL_M_P' -- 2019-02-18 kimcd 조건 추가 오창 소형 조립 PILOT 제외 (양산과 구분할 방법 없음..)
				AND    PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112)
			   ) A
			  , DBO.SCM_FP_PLAN_H P
		WHERE A.INSTANCE_ID != 'KR_CELL_M_P'
		  AND A.INSTANCE_ID = P.INSTANCE_ID
		  AND A.RELEASE_PLAN_ID = P.PLAN_ID
		  AND NOT EXISTS (
							SELECT 1 
							  FROM [dbo].[SY_XIF_QMS_PROD_TARGET_S] B WITH(NOLOCK)
							 WHERE B.[PLAN_ID] = A.RELEASE_PLAN_ID
							   AND B.INSTANCE_ID = A.INSTANCE_ID
						 );


	-- ================================================
    -- Declare end
	-- ================================================

	SET @send_date = 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CUR_PLAN
			FETCH NEXT FROM CUR_PLAN INTO @INSTANCE_ID
											,@RELEASE_PLAN_ID
											,@PLAN_GROUP_ID
											,@FACTORY_ID
											,@INSTANCE_TYPE


			WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
				BEGIN
					--I/F KEY  INSTANCE_ID, LINE_ID
					--QMS에서 데이터 생성시 ITEM_ID=DUMMY는 생성 예외
					INSERT INTO [DBO].[SY_XIF_QMS_PROD_TARGET_S]
					(
						[IF_SEQ]
						,[IF_TYPE]
						,[IF_ID]
						,[IF_INS_DATE]
						,[IF_FLAG]
						,[IF_SND_DATE]
						,[DIVISION_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[PLAN_GROUP_ID]
						,[OPERATION_ID]
						,[LINE_ID]
						,[PRODUCTION_TYPE]
						,[TOP_ITEM_ID]
						,[ITEM_ID]
						,[NICK_NAME]
						,[MARKET]
						,[INSTANCE_ID]
						,[PLAN_ID]
						,[INSTANCE_TYPE]
						,[PLAN_DATE]
						,[PLAN_QTY]
						,[PLAN_IN_QTY]
						,[CELL_IN_QTY]
						,[CELL_OUT_QTY]
						,[ACCUM_COUNT]
						,[ATTR_01]    -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,[ATTR_02]    -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,[ATTR_03]    -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,[ATTR_04]    -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,[ATTR_05]
						,[ATTR_06]
						,[ATTR_07]
						,[ATTR_08]
						,[ATTR_09]
						,[ATTR_10]
					)
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_QMS_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_QMS_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
						   ,'I'            AS IF_TYPE
							,@if_id_code   AS IF_ID
							,GETDATE()     AS IF_INS_DATE
							,'N'           AS IF_FLAG
							,NULL          AS IF_SND_DATE
				--	SELECT  ''
							,ISNULL(PD.ORIGINAL_DIVISION_ID, A.DIVISION_ID) -- 2022-03-28 kimcd 가상 Division 사용 로직 보완. 외부로는 정상적인 Division으로 전송
						    ,A.PLANT_ID
   						    ,A.FACTORY_ID				   
						    ,@PLAN_GROUP_ID AS PLAN_GROUP_ID
						    ,A.OPERATION_ID
						    ,A.LINE_ID
   						    ,PRODUCTION_TYPE
						    ,A.TOP_ITEM_ID
   						    ,A.ITEM_ID
   						    ,( SELECT TOP 1 B.NICK_NAME
								 FROM SCM_ITEM_M B WITH(NOLOCK)
							    WHERE A.COMPANY_ID  = B.COMPANY_ID
								  AND A.DIVISION_ID = B.DIVISION_ID
								  AND A.SITE_ID     = B.SITE_ID
								  AND A.ITEM_ID     = B.ITEM_ID ) AS NICK_NAME
						   ,A.MARKET
   						   ,A.INSTANCE_ID
   						   ,A.FP_PLAN_ID
   						   ,@INSTANCE_TYPE AS INSTANCE_TYPE
						   ,PLAN_DATE
						   ,PLAN_QTY
						   ,PLAN_IN_QTY
   						   ,CELL_IN_QTY
						   ,CELL_OUT_QTY
						   ,COUNT(*) OVER (PARTITION BY FP_PLAN_ID) -- fp plan id별 전송 record count
						   ,WORK_REQUEST_MODEL_ID    -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						   ,[VERSION]			     -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						   ,PROD_SEQ			     -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						   ,PLM_EC_NO			     -- 2022-11-23 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						   ,NULL			-- ATTR_05
						   ,NULL			-- ATTR_06
						   ,NULL			-- ATTR_07
						   ,NULL			-- ATTR_08
						   ,NULL			-- ATTR_09
  						   ,NULL			-- ATTR_10
					  FROM (
							SELECT A.COMPANY_ID
								   ,A.DIVISION_ID
								   ,A.SITE_ID
								   ,A.PLANT_ID
   								   ,A.FACTORY_ID				   
								   ,A.OPERATION_ID
								   ,A.LINE_ID
   								   ,CASE WHEN A.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE A.PRODUCTION_TYPE END AS PRODUCTION_TYPE
								   ,A.TOP_ITEM_ID
   								   ,A.ITEM_ID
								   ,A.MARKET
   								   ,A.INSTANCE_ID
   								   ,A.FP_PLAN_ID
								   ,CONVERT( NVARCHAR(8), A.PLAN_DATE, 112) AS PLAN_DATE
								   ,SUM(A.PLAN_QTY ) AS PLAN_QTY
								   ,SUM(A.PLAN_IN_QTY ) AS PLAN_IN_QTY
   								   ,SUM(CELL_IN_QTY ) AS CELL_IN_QTY
								   ,SUM(CELL_OUT_QTY ) AS CELL_OUT_QTY
								   ,A.WORK_REQUEST_MODEL_ID  -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								   ,A.[VERSION]              -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								   ,A.PROD_SEQ               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								   ,A.PLM_EC_NO              -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							  FROM FP_DAILY_PRODUCTION_PLAN_R A
							 WHERE FP_PLAN_ID   = @RELEASE_PLAN_ID	--'PL_E_POST-20191007-99'
							   AND INSTANCE_ID	= @INSTANCE_ID
							 GROUP BY A.COMPANY_ID
								   ,A.DIVISION_ID
								   ,A.SITE_ID
								   ,A.PLANT_ID
   								   ,A.FACTORY_ID				   
								   ,A.OPERATION_ID
								   ,A.LINE_ID
   								   ,CASE WHEN A.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE A.PRODUCTION_TYPE END
								   ,A.TOP_ITEM_ID
   								   ,A.ITEM_ID
								   ,A.MARKET
   								   ,A.INSTANCE_ID
   								   ,A.FP_PLAN_ID
								   ,CONVERT( NVARCHAR(8), A.PLAN_DATE, 112)
								   ,A.WORK_REQUEST_MODEL_ID  -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								   ,A.[VERSION]              -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								   ,A.PROD_SEQ               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								   ,A.PLM_EC_NO              -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							--- DUMMY 품목 추가 LINE 기준으로 이전 계획 삭제 용도
							UNION ALL
							SELECT L.COMPANY_ID
								  ,L.DIVISION_ID
								  ,L.SITE_ID
								  ,L.PLANT_ID
								  ,L.FACTORY_ID
								  ,L.OPERATION_ID
								  ,L.LINE_ID
								  ,L.PRODUCTION_TYPE
								  ,L.TOP_ITEM_ID
								  ,L.ITEM_ID
								  ,L.MARKET
								  ,L.INSTANCE_ID
								  ,L.FP_PLAN_ID
								  ,CONVERT( NVARCHAR(8), L.PLAN_DATE, 112) AS PLAN_DATE
								  ,L.PLAN_QTY
								  ,L.PLAN_IN_QTY
								  ,L.CELL_IN_QTY
								  ,L.CELL_OUT_QTY
								  ,NULL   -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								  ,NULL   -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								  ,NULL   -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								  ,NULL   -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							 FROM (
									SELECT @RELEASE_PLAN_ID   AS  FP_PLAN_ID
										   ,@INSTANCE_ID AS INSTANCE_ID
										   ,L.COMPANY_ID
										   ,L.DIVISION_ID
										   ,L.SITE_ID
										   ,L.PLANT_ID
										   ,L.FACTORY_ID
										   ,'DUMMY'              AS TOP_ITEM_ID
										   ,'DUMMY'              AS ITEM_ID
										   ,MAX(L.OPERATION_ID)  AS OPERATION_ID
										   ,'MASS'               AS PRODUCTION_TYPE
										   ,'D'                  AS MARKET
										   ,L.LINE_ID
										   ,DATEADD( D, 1, GETDATE()) AS PLAN_DATE
										   ,0                   AS PLAN_QTY
										   ,0                   AS PLAN_IN_QTY
										   ,0					AS CELL_IN_QTY
										   ,0					AS CELL_OUT_QTY
									  FROM SCM_LINE_M   L WITH(NOLOCK)
										   ,SCM_OPERATION_M O WITH(NOLOCK)
										   ,FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
									 WHERE L.COMPANY_ID    = O.COMPANY_ID
									   AND L.DIVISION_ID   = O.DIVISION_ID
									   AND L.SITE_ID       = O.SITE_ID
									   AND L.OPERATION_ID  = O.OPERATION_ID
									   AND L.FACTORY_ID    = IFM.FACTORY_ID
									   AND O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
									   AND IFM.INSTANCE_ID = @INSTANCE_ID
									   AND L.ACTIVE_FLAG   = 'Y'
									   AND CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
									   AND CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
									   AND NOT EXISTS ( SELECT 1
														FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
														AND    SLV.ACTIVE_FLAG       = 'Y'
														AND    SLV.SEGMENT2          = @INSTANCE_ID
														AND    SLV.SEGMENT3          = L.LINE_ID )
									   AND NOT EXISTS (SELECT 1
														FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
														AND    SLV.ACTIVE_FLAG       = 'Y'
														AND    SLV.SEGMENT1          = @INSTANCE_ID)
									 GROUP BY L.COMPANY_ID
										  ,L.DIVISION_ID
										  ,L.SITE_ID
										  ,L.PLANT_ID
										  ,L.FACTORY_ID
										  ,L.LINE_ID
									UNION ALL
									SELECT @RELEASE_PLAN_ID   AS  FP_PLAN_ID
										   ,@INSTANCE_ID AS INSTANCE_ID
										   ,L.COMPANY_ID
										   ,L.DIVISION_ID
										   ,L.SITE_ID
										   ,L.PLANT_ID
										   ,L.FACTORY_ID
										   ,'DUMMY'              AS TOP_ITEM_ID
										   ,'DUMMY'              AS ITEM_ID
										   ,MAX(L.OPERATION_ID)  AS OPERATION_ID
										   ,'MASS'               AS PRODUCTION_TYPE
										   ,'D'                  AS MARKET
										   ,L.LINE_ID
										   ,DATEADD( D, 1, GETDATE()) AS PLAN_DATE
										   ,0					AS PLAN_QTY
										   ,0					AS PLAN_IN_QTY
										   ,0					AS CELL_IN_QTY
										   ,0					AS CELL_OUT_QTY
									  FROM SCM_LINE_M   L WITH(NOLOCK)
										   ,SCM_OPERATION_M O WITH(NOLOCK)
										   ,FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
									 WHERE L.COMPANY_ID    = O.COMPANY_ID
									   AND L.DIVISION_ID   = O.DIVISION_ID
									   AND L.SITE_ID       = O.SITE_ID
									   AND L.OPERATION_ID  = O.OPERATION_ID
									   AND L.FACTORY_ID    = IFM.FACTORY_ID
									   AND O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
									   AND IFM.INSTANCE_ID = @INSTANCE_ID
									   AND L.ACTIVE_FLAG   = 'Y'
									   AND CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
									   AND CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
									   AND L.LINE_ID IN (
														   SELECT SLV.SEGMENT3
															 FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															WHERE SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															  AND SLV.ACTIVE_FLAG       = 'Y'
															  AND SLV.SEGMENT1          = @INSTANCE_ID
														 )
									 GROUP BY L.COMPANY_ID
										   ,L.DIVISION_ID
										   ,L.SITE_ID
										   ,L.PLANT_ID
										   ,L.FACTORY_ID
										   ,L.LINE_ID
								   ) L
							 WHERE NOT EXISTS (
											   SELECT 1 
											     FROM FP_DAILY_PRODUCTION_PLAN_R PP WITH(NOLOCK)
											    WHERE PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
											      AND PP.INSTANCE_ID = @INSTANCE_ID
											      AND PP.LINE_ID     = L.LINE_ID
											  )	
							--DUMMY 품목 추가
						   ) A
							LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-28 kimcd 가상 Division 로직 추가
								ON PD.PLANT_ID = A.PLANT_ID


					FETCH NEXT FROM CUR_PLAN INTO @INSTANCE_ID
													,@RELEASE_PLAN_ID
													,@PLAN_GROUP_ID
													,@FACTORY_ID
													,@INSTANCE_TYPE

				END;  -- WHILE @@FETCH_STATUS = 0

			CLOSE CUR_PLAN;
			DEALLOCATE CUR_PLAN;
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
