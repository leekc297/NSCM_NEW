
--CREATE PROCEDURE [dbo].[PR_XIF_MRP_PROD_TARGET_S]
CREATE PROCEDURE [dbo].[PR_XIF_MRP_PROD_TARGET_S]

-- ================================================================================================
-- Program ID          : FP02631
-- Program Name        : PR_XIF_MRP_PROD_TARGET_S
-- Param               :
-- Batch Period        : 15 Minute
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_R
-- Destination Table   : XIF_MRP_PROD_TARGET_S
--
-- Create(Update) Date : 2019.02.18
--						 2019.05.09
--						 2022.03.28
--
-- Author              : 김 춘 동
-- Version             : 1.0
--                       1.1 2018-12-28 kimcd production type 관련 수정.
--                                            SPECIAL은 MASS로 전송. ATTR_6에 production type name 추가 전송
--                       1.2 2019-02-18 kimcd INSTANCE TYPE, DUMMY 품목 계획 정보 추가
--                                            MRP 계획 전송 대상 추가
--                       1.3 2019-05-09 piyong Target 일자 추가 전송
--						 1.4 2019-09-02 PIYONG CELL IN,OUT 수량 추가 전송
--						 1.5 2022-03-28 kimcd 가상 Division 사용에 따른 보완
--                       1.6 2023.09.05 FP Pjt. 1. 환산자 버전 추가(attr_12)
--                                              2. 기존 릴리즈 계획 일괄 전송에서 선택 전송으로 변경 (mrp_flag = 'N' 조건)
-- ================================================================================================

-- PARAM PLAN_ID
@P_FP_PLAN_ID NVARCHAR(50) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MRP_PROD_TARGET_S'
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
	DECLARE @if_id_code             NVARCHAR(50)  = 'OFP0_OMRP_MRP_PROD_TARGET'
	DECLARE @send_if_seq            NVARCHAR(50)
	DECLARE @send_date              NVARCHAR(50)
	DECLARE @if_seq_next            BIGINT

	DECLARE CUR_PLAN_ID CURSOR FOR
		SELECT A.INSTANCE_ID
				,A.RELEASE_PLAN_ID
				,A.PLAN_GROUP_ID
				,A.FACTORY_ID   -- 2019-02-18 kimcd 컬럼 추가
				,(SELECT TOP 1 IFM.INSTANCE_TYPE
					FROM FP_INSTANCE_FACTORY_M AS IFM WITH(NOLOCK)
				   WHERE IFM.INSTANCE_ID = A.INSTANCE_ID) AS INSTANCE_TYPE	-- 2019-02-18 kimcd 컬럼 추가
				,CASE WHEN P.SCP_PLAN_ID IS NOT NULL THEN SUBSTRING(P.SCP_PLAN_ID,1 ,8 ) ELSE CONVERT(NVARCHAR(8), GETDATE(), 112) END AS TARGET_DATE-- 2019-05-09 PIYONG ADD
		 FROM (	SELECT A.INSTANCE_ID
						,A.RELEASE_PLAN_ID
						,A.PLAN_GROUP_ID
						,'-'      AS FACTORY_ID   -- 2019-02-18 kimcd 컬럼 추가
				FROM   DBO.SCM_FP_PLAN_GROUP_DETAIL_H AS A with(nolock)
				WHERE  MES_TRANSFER_FLAG = 'Y'
				AND    PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112) 
				UNION ALL
				SELECT A.INSTANCE_ID
						,A.RELEASE_PLAN_ID
						,'-' AS PLAN_GROUP_ID
						,A.FACTORY_ID             -- 2019-02-18 kimcd 컬럼 추가
				FROM   DBO.SCM_FP_PLAN_DETAIL_H AS A with(nolock)
				WHERE  MES_TRANSFER_FLAG = 'Y'
				AND    INSTANCE_ID != 'KR_CELL_M_P' -- 2019-02-18 kimcd 조건 추가 오창 소형 조립 PILOT 제외 (양산과 구분할 방법 없음..)
				AND    PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112)
			  ) A
			  , DBO.SCM_FP_PLAN_H AS P with(nolock)
		WHERE A.INSTANCE_ID != 'KR_CELL_M_P'
		  AND A.INSTANCE_ID = P.INSTANCE_ID
		  AND A.RELEASE_PLAN_ID = P.PLAN_ID
		  AND    P.MRP_FLAG     = 'N'
		  AND NOT EXISTS (
							SELECT 1 
							FROM   [dbo].[SY_XIF_MRP_PROD_TARGET_S] B WITH(NOLOCK)
							WHERE  B.ATTR_01 = A.RELEASE_PLAN_ID
							AND    B.ATTR_02 = A.INSTANCE_ID
						 );


	DECLARE CUR_MRP_PLAN_ID CURSOR FOR  -- 2019-02-18 kimcd MRP 전송 대상 Plan 조회
		SELECT A.INSTANCE_ID
			  ,A.PLAN_ID
			  ,(SELECT TOP 1 IFM.INSTANCE_TYPE
			    FROM   FP_INSTANCE_FACTORY_M AS IFM WITH(NOLOCK)
				WHERE  IFM.INSTANCE_ID = A.INSTANCE_ID) AS INSTANCE_TYPE
			  ,(SELECT TOP 1 ATTRIBUTE1
			    FROM   DBO.SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
				WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
				AND    SLV.SEGMENT1         = A.INSTANCE_ID) AS  CONFIRM_AREA
			  ,CASE WHEN A.SCP_PLAN_ID IS NOT NULL THEN SUBSTRING(A.SCP_PLAN_ID,1 ,8 ) ELSE CONVERT(NVARCHAR(8), GETDATE(), 112) END AS TARGET_DATE				-- 2019-05-09 PIYONG ADD
		FROM   DBO.SCM_FP_PLAN_H AS A with(nolock)
		WHERE  1 = 1 
		  AND INSTANCE_ID != 'KR_CELL_M_P' -- 2019-02-18 kimcd 조건 추가 오창 소형 조립 PILOT 제외 (양산과 구분할 방법 없음..)
		  AND    PLAN_TYPE   != 'RELEASE'
		  AND    PLAN_START_TIME >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112)
		  AND    MRP_FLAG     = 'N'
		AND    NOT EXISTS (SELECT 1 
						   FROM    [dbo].[SY_XIF_MRP_PROD_TARGET_S] B WITH(NOLOCK)
						   WHERE   B.ATTR_01 = A.PLAN_ID
						   AND     B.ATTR_02 = A.INSTANCE_ID);


	DECLARE @INSTANCE_ID       NVARCHAR(30)      
	DECLARE @RELEASE_PLAN_ID   NVARCHAR(30)
	DECLARE @PLAN_GROUP_ID     NVARCHAR(30)
	DECLARE @FACTORY_ID        NVARCHAR(30) -- 2019-02-18 kimcd 컬럼 추가
	DECLARE @INSTANCE_TYPE     NVARCHAR(30) -- 2019-02-18 kimcd 컬럼 추가
	DECLARE @CONFIRM_AREA      NVARCHAR(150) -- 2019-02-18 kimcd 컬럼 추가
	DECLARE @TARGET_DATE	   NVARCHAR(8)	-- 2019-05-09 PIYONG ADD


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
		SET @v_temp1 = 'DELETE [dbo].[SY_XIF_MRP_PROD_TARGET_S]'
		DELETE FROM [dbo].[SY_XIF_MRP_PROD_TARGET_S]
		WHERE  ATTR_01 = ISNULL(@P_FP_PLAN_ID,'0');


		OPEN CUR_PLAN_ID
		FETCH NEXT FROM CUR_PLAN_ID INTO @INSTANCE_ID
										,@RELEASE_PLAN_ID
										,@PLAN_GROUP_ID
										,@FACTORY_ID    -- 2019-02-18 kimcd 컬럼 추가
										,@INSTANCE_TYPE -- 2019-02-18 kimcd 컬럼 추가
										,@TARGET_DATE	-- 2019-05-09 PIYONG ADD

		WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			INSERT INTO [DBO].[SY_XIF_MRP_PROD_TARGET_S]
						([IF_SEQ]
						,[IF_TYPE]
						,[IF_ID]
						,[IF_INS_DATE]
						,[IF_FLAG]
						,[IF_SND_DATE]
						,[DIVISION_ID]
						,[PLANT_ID]
						,[OPERATION_ID]
						,[LINE_ID]
						,[PRODUCTION_TYPE]
						,[ITEM_ID]
						,[PLAN_DATE]
						,[TOP_ITEM_ID]
						,[MARKET]
						,[NICK_NAME]
						,[PLAN_QTY]
						,[PLAN_IN_QTY]
						,[ATTR_01]   -- fp_plan_id
						,[ATTR_02]   -- instance_id
						,[ATTR_03]   -- FACTORY_ID
						,[ATTR_04]   -- PLAN_GOUP_ID
						,[ATTR_05]   -- fp plan id별 전송 record count
						,[ATTR_06]   -- 2018-12-28 kimcd production type name 추가 전송
						,[ATTR_07]   -- INSTANCE_TYPE -- 2019-02-18 kimcd 컬럼 추가
						,[ATTR_08]   -- 자재 검토용 plan 구분자 N -- 2019-02-18 kimcd 컬럼 추가
						,[ATTR_09]	 -- TARGET DATE
						,[ATTR_10]	 -- CELL IN QTY
						,[ATTR_11]	 -- CELL OUT QTY
						,[ATTR_12]   -- VERSION
						,[ATTR_13]
						,[ATTR_14]
						,[ATTR_15]
						,[ATTR_16]
						,[ATTR_17]
						,[ATTR_18]
						,[ATTR_19]
						,[ATTR_20]
			)
			SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MRP_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MRP_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
				   ,'I'            AS IF_TYPE
					,@if_id_code   AS IF_ID
					,GETDATE()     AS IF_INS_DATE
					,'N'           AS IF_FLAG
					,NULL          AS IF_SND_DATE
				   ,ISNULL(PD.ORIGINAL_DIVISION_ID, A.DIVISION_ID)  -- 2022-03-28 kimcd 가상 Division 로직 추가
				   ,A.PLANT_ID
				   ,A.OPERATION_ID
				   ,A.LINE_ID
				   ,A.PRODUCTION_TYPE
				   ,A.ITEM_ID
				   ,CONVERT( NVARCHAR(10), A.PLAN_DATE, 112)
				   ,A.TOP_ITEM_ID
				   ,A.MARKET
				   ,( SELECT TOP 1 B.NICK_NAME
				      FROM   SCM_ITEM_M B WITH(NOLOCK)
					  WHERE A.COMPANY_ID  = B.COMPANY_ID
					  AND   A.DIVISION_ID = B.DIVISION_ID
					  AND   A.SITE_ID     = B.SITE_ID
					  AND   A.ITEM_ID     = B.ITEM_ID ) AS NICK_NAME  -- 2019-02-18 kimcd nick name 로직 in-line view로 수정
				   ,A.PLAN_QTY
				   ,A.PLAN_IN_QTY
				   ,A.FP_PLAN_ID   -- ATTR_01 -- fp_plan_id
				   ,A.INSTANCE_ID  -- ATTR_02 -- instance_id
				   ,A.FACTORY_ID   -- ATTR_03 -- FACTORY_ID
				   ,@PLAN_GROUP_ID -- ATTR_04 -- PLAN_GOUP_ID
				   ,COUNT(*) OVER (PARTITION BY FP_PLAN_ID) -- ATTR_05  fp plan id별 전송 record count
				   ,(SELECT TOP 1 SLV.ATTRIBUTE4
				     FROM   DBO.SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
					 WHERE  SLV.LOOKUP_TYPE_CODE = 'DEMAND_TYPE'
					 AND    SLV.SEGMENT1         = A.PRODUCTION_TYPE 
					 AND    SLV.ACTIVE_FLAG      = 'Y' )   -- ATTR_06 2018-12-28 kimcd 수요 유형 이름 전송
				   ,@INSTANCE_TYPE -- ATTR_07 INSTANCE_TYPE -- 2019-02-18 kimcd 컬럼 추가
				   ,'N'            -- ATTR_08 자재 검토용 plan 구분자 N -- 2019-02-18 kimcd 컬럼 추가
				   ,@TARGET_DATE   -- ATTR_09	-- 2019-05-09 PIYONG ADD
				   ,CELL_IN_QTY		-- ATTR_10
				   ,CELL_OUT_QTY	-- ATTR_11
				   ,VERSION			-- ATTR_12
				   ,NULL			-- ATTR_13
				   ,NULL			-- ATTR_14
				   ,NULL			-- ATTR_15
				   ,NULL			-- ATTR_16
				   ,NULL			-- ATTR_17
				   ,NULL			-- ATTR_18
				   ,NULL			-- ATTR_19
				   ,NULL			-- ATTR_20
			  FROM (
					SELECT PP.FP_PLAN_ID
					      ,PP.INSTANCE_ID
					      ,PP.COMPANY_ID
						  ,PP.DIVISION_ID
						  ,PP.SITE_ID
						  ,PP.PLANT_ID
						  ,PP.FACTORY_ID
						  ,PP.TOP_ITEM_ID
						  ,PP.ITEM_ID
						  ,PP.OPERATION_ID
						  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END AS PRODUCTION_TYPE  -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
						  ,ISNULL(PP.MARKET,'D') AS MARKET
						  ,PP.LINE_ID
						  ,PP.PLAN_DATE
						  ,SUM(PLAN_QTY)    AS PLAN_QTY
						  ,SUM(PLAN_IN_QTY) AS PLAN_IN_QTY
  						  ,SUM(CELL_IN_QTY) AS CELL_IN_QTY
						  ,SUM(CELL_OUT_QTY) AS CELL_OUT_QTY
						  ,MAX(PP.VERSION) AS VERSION
					  FROM FP_DAILY_PRODUCTION_PLAN_R AS PP WITH(NOLOCK)
                     WHERE PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
					   AND PP.INSTANCE_ID = @INSTANCE_ID
					   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  --  2019-02-18 kimcd 오창 Pilot 예외 처리
					 GROUP BY  PP.FP_PLAN_ID
							  ,PP.INSTANCE_ID
							  ,PP.COMPANY_ID
							  ,PP.DIVISION_ID
							  ,PP.SITE_ID
							  ,PP.PLANT_ID
							  ,PP.FACTORY_ID
							  ,PP.TOP_ITEM_ID
							  ,PP.ITEM_ID
							  ,PP.OPERATION_ID
							  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
							  ,ISNULL(PP.MARKET,'D')
							  ,PP.LINE_ID
							  ,PP.PLAN_DATE
					 -- 2019-02-18 kimcd DUMMY 품목 추가 시작
					 UNION ALL
					 SELECT L.FP_PLAN_ID
					      ,L.INSTANCE_ID
					      ,L.COMPANY_ID
						  ,L.DIVISION_ID
						  ,L.SITE_ID
						  ,L.PLANT_ID
						  ,L.FACTORY_ID
						  ,L.TOP_ITEM_ID
						  ,L.ITEM_ID
						  ,L.OPERATION_ID
						  ,L.PRODUCTION_TYPE
						  ,L.MARKET
						  ,L.LINE_ID
						  ,L.PLAN_DATE
						  ,L.PLAN_QTY
						  ,L.PLAN_IN_QTY
						  ,L.CELL_IN_QTY
						  ,L.CELL_OUT_QTY
						  ,'-' AS VERSION
					 FROM  ( SELECT @RELEASE_PLAN_ID   AS  FP_PLAN_ID
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
								  ,1                    AS PLAN_QTY
								  ,1                    AS PLAN_IN_QTY
								  ,0					AS CELL_IN_QTY
								  ,0					AS CELL_OUT_QTY
							 FROM  SCM_LINE_M AS L WITH(NOLOCK)
							      ,SCM_OPERATION_M AS O WITH(NOLOCK)
								  ,FP_INSTANCE_FACTORY_M AS IFM WITH(NOLOCK)
							 WHERE L.COMPANY_ID    = O.COMPANY_ID
							 AND   L.DIVISION_ID   = O.DIVISION_ID
							 AND   L.SITE_ID       = O.SITE_ID
							 AND   L.OPERATION_ID  = O.OPERATION_ID
							 AND   L.FACTORY_ID    = IFM.FACTORY_ID
							 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
							 AND   IFM.INSTANCE_ID = @INSTANCE_ID
							 AND   L.ACTIVE_FLAG   = 'Y'
							 AND   CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
							 AND   CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
							 AND   NOT EXISTS ( SELECT 1
												FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
												WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
												AND    SLV.ACTIVE_FLAG       = 'Y'
												AND    SLV.SEGMENT2          = @INSTANCE_ID
												AND    SLV.SEGMENT3          = L.LINE_ID )
							 AND    NOT EXISTS (SELECT 1
												FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
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
								  ,1                    AS PLAN_QTY
								  ,1                    AS PLAN_IN_QTY
								  ,0					AS CELL_IN_QTY
								  ,0					AS CELL_OUT_QTY
							 FROM  SCM_LINE_M AS L WITH(NOLOCK)
							      ,SCM_OPERATION_M AS O WITH(NOLOCK)
								  ,FP_INSTANCE_FACTORY_M AS IFM WITH(NOLOCK)
							 WHERE L.COMPANY_ID    = O.COMPANY_ID
							 AND   L.DIVISION_ID   = O.DIVISION_ID
							 AND   L.SITE_ID       = O.SITE_ID
							 AND   L.OPERATION_ID  = O.OPERATION_ID
							 AND   L.FACTORY_ID    = IFM.FACTORY_ID
							 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
							 AND   IFM.INSTANCE_ID = @INSTANCE_ID
							 AND   L.ACTIVE_FLAG   = 'Y'
							 AND   CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
							 AND   CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
							 AND   L.LINE_ID IN ( SELECT SLV.SEGMENT3
												FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
												WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
												AND    SLV.ACTIVE_FLAG       = 'Y'
												AND    SLV.SEGMENT1          = @INSTANCE_ID )
							 GROUP BY L.COMPANY_ID
								  ,L.DIVISION_ID
								  ,L.SITE_ID
								  ,L.PLANT_ID
								  ,L.FACTORY_ID
								  ,L.LINE_ID ) L
					 WHERE  NOT EXISTS (SELECT 1 
					                   FROM FP_DAILY_PRODUCTION_PLAN_R AS PP WITH(NOLOCK)
									   WHERE PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
									   AND   PP.INSTANCE_ID = @INSTANCE_ID
									   AND   PP.LINE_ID     = L.LINE_ID)		
				   -- 	2019-02-18 kimcd DUMMY 품목 추가 끝
				   ) A
					LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK)  -- 2022-03-28 kimcd 가상 Division 로직 추가
						ON PD.PLANT_ID = A.PLANT_ID
			/* 2019-02-18 kimcd 품목 nick name을 in-line view로 수정
				   , SCM_ITEM_M B WITH(NOLOCK)
			  WHERE A.COMPANY_ID  = B.COMPANY_ID
			  AND   A.DIVISION_ID = B.DIVISION_ID
			  AND   A.SITE_ID     = B.SITE_ID
			  AND   A.ITEM_ID     = B.ITEM_ID
			  */
			  ;

			SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT

			UPDATE DBO.SCM_FP_PLAN_H
			SET    MRP_FLAG = 'Y'
				   ,UPDATE_ID = 'PR_XIF_MRP_PROD_TARGET_S'
				   ,UPDATE_TIME = GETDATE()
			WHERE  INSTANCE_ID = @INSTANCE_ID
			AND    PLAN_ID     = @RELEASE_PLAN_ID


			FETCH NEXT FROM CUR_PLAN_ID INTO @INSTANCE_ID
											,@RELEASE_PLAN_ID
											,@PLAN_GROUP_ID
											,@FACTORY_ID    -- 2019-02-18 kimcd 컬럼 추가
											,@INSTANCE_TYPE -- 2019-02-18 kimcd 컬럼 추가
											,@TARGET_DATE	-- 2019-05-09 PIYONG ADD

		END;  -- WHILE @@FETCH_STATUS = 0

        CLOSE CUR_PLAN_ID;
        DEALLOCATE CUR_PLAN_ID;   -- 메모리 해제


/*

		-- 2019-02-18 kimcd MRP Plan 추가 시작
		OPEN CUR_MRP_PLAN_ID
		FETCH NEXT FROM CUR_MRP_PLAN_ID INTO @INSTANCE_ID
											,@RELEASE_PLAN_ID
											,@INSTANCE_TYPE
											,@CONFIRM_AREA
											,@TARGET_DATE	-- 2019-05-09 PIYONG ADD

		WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			INSERT INTO [DBO].[SY_XIF_MRP_PROD_TARGET_S]
						([IF_SEQ]
						,[IF_TYPE]
						,[IF_ID]
						,[IF_INS_DATE]
						,[IF_FLAG]
						,[IF_SND_DATE]
						,[DIVISION_ID]
						,[PLANT_ID]
						,[OPERATION_ID]
						,[LINE_ID]
						,[PRODUCTION_TYPE]
						,[ITEM_ID]
						,[PLAN_DATE]
						,[TOP_ITEM_ID]
						,[MARKET]
						,[NICK_NAME]
						,[PLAN_QTY]
						,[PLAN_IN_QTY]
						,[ATTR_01]   -- fp_plan_id
						,[ATTR_02]   -- instance_id
						,[ATTR_03]   -- FACTORY_ID
						,[ATTR_04]   -- PLAN_GOUP_ID
						,[ATTR_05]   -- fp plan id별 전송 record count
						,[ATTR_06]   -- 2018-12-28 kimcd production type name 추가 전송
						,[ATTR_07]   -- INSTANCE_TYPE -- 2019-02-18 kimcd 컬럼 추가
						,[ATTR_08]   -- 자재 검토용 plan 구분자 N -- 2019-02-18 kimcd 컬럼 추가
						,[ATTR_09]   -- TARGET DATE
						,[ATTR_10]	 -- 2019-09-02 PIYONG ADD CELL_IN_QTY
						,[ATTR_11]	 -- 2019-09-02 PIYONG ADD CELL_OUT_QTY
						,[ATTR_12]   -- VERSION
						,[ATTR_13]
						,[ATTR_14]
						,[ATTR_15]
						,[ATTR_16]
						,[ATTR_17]
						,[ATTR_18]
						,[ATTR_19]
						,[ATTR_20]
			)
			SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MRP_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MRP_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
				   ,'I'            AS IF_TYPE
					,@if_id_code   AS IF_ID
					,GETDATE()     AS IF_INS_DATE
					,'N'           AS IF_FLAG
					,NULL          AS IF_SND_DATE
				   ,ISNULL(PD.ORIGINAL_DIVISION_ID, A.DIVISION_ID)  -- 2022-03-28 kimcd 가상 Division 로직 추가
				   ,A.PLANT_ID
				   ,A.OPERATION_ID
				   ,A.LINE_ID
				   ,A.PRODUCTION_TYPE
				   ,A.ITEM_ID
				   ,CONVERT( NVARCHAR(10), A.PLAN_DATE, 112)
				   ,A.TOP_ITEM_ID
				   ,A.MARKET
				   ,( SELECT TOP 1 B.NICK_NAME
				      FROM   SCM_ITEM_M AS B WITH(NOLOCK)
					  WHERE A.COMPANY_ID  = B.COMPANY_ID
					  AND   A.DIVISION_ID = B.DIVISION_ID
					  AND   A.SITE_ID     = B.SITE_ID
					  AND   A.ITEM_ID     = B.ITEM_ID ) AS NICK_NAME  -- 2019-02-18 kimcd nick name 로직 in-line view로 수정
				   ,A.PLAN_QTY
				   ,A.PLAN_IN_QTY
				   ,A.FP_PLAN_ID   -- ATTR_01 -- fp_plan_id
				   ,A.INSTANCE_ID  -- ATTR_02 -- instance_id
				   ,A.FACTORY_ID   -- ATTR_03 -- FACTORY_ID
				   ,A.PLAN_GROUP_ID -- ATTR_04 -- PLAN_GOUP_ID
				   ,COUNT(*) OVER (PARTITION BY FP_PLAN_ID) -- ATTR_05  fp plan id별 전송 record count
				   ,(SELECT TOP 1 SLV.ATTRIBUTE4
				     FROM   DBO.SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
					 WHERE  SLV.LOOKUP_TYPE_CODE = 'DEMAND_TYPE'
					 AND    SLV.SEGMENT1         = A.PRODUCTION_TYPE 
					 AND    SLV.ACTIVE_FLAG      = 'Y' )   -- ATTR_06 2018-12-28 kimcd 수요 유형 이름 전송
				   ,@INSTANCE_TYPE -- ATTR_07 INSTANCE_TYPE -- 2019-02-18 kimcd 컬럼 추가
				   ,'Y'            -- ATTR_08 자재 검토용 plan 구분자 N -- 2019-02-18 kimcd 컬럼 추가
				   ,@TARGET_DATE   -- ATTR_09	-- 2019-05-09 PIYONG ADD
				   ,CELL_IN_QTY		-- ATTR_10
				   ,CELL_OUT_QTY	-- ATTR_11
				   ,VERSION			-- ATTR_12
				   ,NULL			-- ATTR_13
				   ,NULL			-- ATTR_14
				   ,NULL			-- ATTR_15
				   ,NULL			-- ATTR_16
				   ,NULL			-- ATTR_17
				   ,NULL			-- ATTR_18
				   ,NULL			-- ATTR_19
				   ,NULL			-- ATTR_20
			  FROM (
					SELECT PP.FP_PLAN_ID
					      ,PP.INSTANCE_ID
					      ,PP.COMPANY_ID
						  ,PP.DIVISION_ID
						  ,PP.SITE_ID
						  ,PP.PLANT_ID
						  ,PP.FACTORY_ID
						  ,PP.TOP_ITEM_ID
						  ,PP.ITEM_ID
						  ,PP.OPERATION_ID
						  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END AS PRODUCTION_TYPE  -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
						  ,ISNULL(PP.MARKET,'D') AS MARKET
						  ,PP.LINE_ID
						  ,PP.PLAN_DATE
						  ,SUM(OUT_QTY)    AS PLAN_QTY
						  ,SUM(IN_QTY)     AS PLAN_IN_QTY
						  ,CASE WHEN @CONFIRM_AREA   = 'BUILDING' THEN '-'
						   ELSE
							  (	SELECT TOP 1 L.MODEL_TYPE
								FROM   SCM_LINE_M AS L WITH(NOLOCK)
								WHERE  L.COMPANY_ID   = PP.COMPANY_ID
								AND    L.DIVISION_ID  = PP.DIVISION_ID
								AND    L.SITE_ID      = PP.SITE_ID
								AND    L.PLANT_ID     = PP.PLANT_ID
								AND    L.FACTORY_ID   = PP.FACTORY_ID
								AND    L.LINE_ID      = PP.LINE_ID
								AND    L.OPERATION_ID = PP.OPERATION_ID )
						   END   AS PLAN_GROUP_ID
						   ,SUM(CELL_IN_QTY) AS CELL_IN_QTY
						   ,SUM(CELL_OUT_QTY) AS CELL_OUT_QTY
						   ,'-'  AS VERSION
					  FROM FP_AMEND_PLAN_CELL_R AS PP WITH(NOLOCK)
                     WHERE PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
					   AND PP.INSTANCE_ID = @INSTANCE_ID
					   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  --  2019-02-18 kimcd 오창 Pilot 예외 처리
					 GROUP BY  PP.FP_PLAN_ID
							  ,PP.INSTANCE_ID
							  ,PP.COMPANY_ID
							  ,PP.DIVISION_ID
							  ,PP.SITE_ID
							  ,PP.PLANT_ID
							  ,PP.FACTORY_ID
							  ,PP.TOP_ITEM_ID
							  ,PP.ITEM_ID
							  ,PP.OPERATION_ID
							  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
							  ,ISNULL(PP.MARKET,'D')
							  ,PP.LINE_ID
							  ,PP.PLAN_DATE
					UNION ALL
					SELECT PP.FP_PLAN_ID
					      ,PP.INSTANCE_ID
					      ,PP.COMPANY_ID
						  ,PP.DIVISION_ID
						  ,PP.SITE_ID
						  ,PP.PLANT_ID
						  ,PP.FACTORY_ID
						  ,PP.TOP_ITEM_ID
						  ,PP.ITEM_ID
						  ,PP.OPERATION_ID
						  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END AS PRODUCTION_TYPE  -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
						  ,ISNULL(PP.MARKET,'D') AS MARKET
						  ,PP.LINE_ID
						  ,PP.PLAN_DATE
						  ,SUM(OUT_QTY)    AS PLAN_QTY
						  ,SUM(IN_QTY)     AS PLAN_IN_QTY
						  ,CASE WHEN @CONFIRM_AREA   = 'BUILDING' THEN '-'
						   ELSE
							  (	SELECT TOP 1 L.MODEL_TYPE
								FROM   SCM_LINE_M AS L WITH(NOLOCK)
								WHERE  L.COMPANY_ID   = PP.COMPANY_ID
								AND    L.DIVISION_ID  = PP.DIVISION_ID
								AND    L.SITE_ID      = PP.SITE_ID
								AND    L.PLANT_ID     = PP.PLANT_ID
								AND    L.FACTORY_ID   = PP.FACTORY_ID
								AND    L.LINE_ID      = PP.LINE_ID
								AND    L.OPERATION_ID = PP.OPERATION_ID )
						   END   AS PLAN_GROUP_ID
						   ,SUM(CELL_IN_QTY) AS CELL_IN_QTY
						   ,SUM(CELL_OUT_QTY) AS CELL_OUT_QTY
						   ,'-'  AS VERSION
					  FROM FP_AMEND_PLAN_PACK_R AS PP WITH(NOLOCK)
                     WHERE PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
					   AND PP.INSTANCE_ID = @INSTANCE_ID
					   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  --  2019-02-18 kimcd 오창 Pilot 예외 처리
					 GROUP BY  PP.FP_PLAN_ID
							  ,PP.INSTANCE_ID
							  ,PP.COMPANY_ID
							  ,PP.DIVISION_ID
							  ,PP.SITE_ID
							  ,PP.PLANT_ID
							  ,PP.FACTORY_ID
							  ,PP.TOP_ITEM_ID
							  ,PP.ITEM_ID
							  ,PP.OPERATION_ID
							  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
							  ,ISNULL(PP.MARKET,'D')
							  ,PP.LINE_ID
							  ,PP.PLAN_DATE
					UNION ALL
					SELECT PP.FP_PLAN_ID
					      ,PP.INSTANCE_ID
					      ,PP.COMPANY_ID
						  ,PP.DIVISION_ID
						  ,PP.SITE_ID
						  ,PP.PLANT_ID
						  ,PP.FACTORY_ID
						  ,PP.TOP_ITEM_ID
						  ,PP.ITEM_ID
						  ,PP.OPERATION_ID
						  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END AS PRODUCTION_TYPE  -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
						  ,ISNULL(PP.MARKET,'D') AS MARKET
						  ,PP.LINE_ID
						  ,PP.PLAN_DATE
						  ,SUM(ADJUST_OUT_QTY)    AS PLAN_QTY
						  ,SUM(ADJUST_IN_QTY)     AS PLAN_IN_QTY
						  ,CASE WHEN @CONFIRM_AREA   = 'BUILDING' THEN '-'
						   ELSE
							  (	SELECT TOP 1 L.MODEL_TYPE
								FROM   SCM_LINE_M AS L WITH(NOLOCK)
								WHERE  L.COMPANY_ID   = PP.COMPANY_ID
								AND    L.DIVISION_ID  = PP.DIVISION_ID
								AND    L.SITE_ID      = PP.SITE_ID
								AND    L.PLANT_ID     = PP.PLANT_ID
								AND    L.FACTORY_ID   = PP.FACTORY_ID
								AND    L.LINE_ID      = PP.LINE_ID
								AND    L.OPERATION_ID = PP.OPERATION_ID )
						   END   AS PLAN_GROUP_ID
						   ,SUM(PLAN_IN_QTY_CELL) AS CELL_IN_QTY
						   ,SUM(PLAN_OUT_QTY_CELL) AS CELL_OUT_QTY
						   ,MAX(PP.VERSION) AS VERSION
					  FROM FP_AMEND_DAILY_PLAN_R AS PP WITH(NOLOCK)
                     WHERE PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
					   AND PP.INSTANCE_ID = @INSTANCE_ID
					   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  --  2019-02-18 kimcd 오창 Pilot 예외 처리
					 GROUP BY  PP.FP_PLAN_ID
							  ,PP.INSTANCE_ID
							  ,PP.COMPANY_ID
							  ,PP.DIVISION_ID
							  ,PP.SITE_ID
							  ,PP.PLANT_ID
							  ,PP.FACTORY_ID
							  ,PP.TOP_ITEM_ID
							  ,PP.ITEM_ID
							  ,PP.OPERATION_ID
							  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
							  ,ISNULL(PP.MARKET,'D')
							  ,PP.LINE_ID
							  ,PP.PLAN_DATE
					UNION ALL
					SELECT PP.FP_PLAN_ID
					      ,PP.INSTANCE_ID
					      ,PP.COMPANY_ID
						  ,PP.DIVISION_ID
						  ,PP.SITE_ID
						  ,PP.PLANT_ID
						  ,PP.FACTORY_ID
						  ,PP.TOP_ITEM_ID
						  ,PP.ITEM_ID
						  ,PP.OPERATION_ID
						  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END AS PRODUCTION_TYPE  -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
						  ,ISNULL(PP.MARKET,'D') AS MARKET
						  ,PP.LINE_ID
						  ,PP.PLAN_DATE
						  ,SUM(OUT_QTY)    AS PLAN_QTY
						  ,SUM(IN_QTY)     AS PLAN_IN_QTY
						  ,CASE WHEN @CONFIRM_AREA   = 'BUILDING' THEN '-'
						   ELSE
							  (	SELECT TOP 1 L.MODEL_TYPE
								FROM   SCM_LINE_M AS L WITH(NOLOCK)
								WHERE  L.COMPANY_ID   = PP.COMPANY_ID
								AND    L.DIVISION_ID  = PP.DIVISION_ID
								AND    L.SITE_ID      = PP.SITE_ID
								AND    L.PLANT_ID     = PP.PLANT_ID
								AND    L.FACTORY_ID   = PP.FACTORY_ID
								AND    L.LINE_ID      = PP.LINE_ID
								AND    L.OPERATION_ID = PP.OPERATION_ID )
						   END   AS PLAN_GROUP_ID
						   ,NULL AS CELL_IN_QTY
						   ,NULL AS CELL_OUT_QTY
						   ,'-'  AS VERSION
					  FROM FP_AMEND_PLAN_FORM_R AS PP WITH(NOLOCK)
                     WHERE PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
					   AND PP.INSTANCE_ID = @INSTANCE_ID
					   AND PP.FACTORY_ID != '-'
					   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  --  2019-02-18 kimcd 오창 Pilot 예외 처리
					 GROUP BY  PP.FP_PLAN_ID
							  ,PP.INSTANCE_ID
							  ,PP.COMPANY_ID
							  ,PP.DIVISION_ID
							  ,PP.SITE_ID
							  ,PP.PLANT_ID
							  ,PP.FACTORY_ID
							  ,PP.TOP_ITEM_ID
							  ,PP.ITEM_ID
							  ,PP.OPERATION_ID
							  ,CASE WHEN PP.PRODUCTION_TYPE = 'SPECIAL' THEN 'MASS' ELSE PP.PRODUCTION_TYPE END -- 2018-12-28 kimcd SPECIAL 양산 유형은 MASS로 전환
							  ,ISNULL(PP.MARKET,'D')
							  ,PP.LINE_ID
							  ,PP.PLAN_DATE
					 -- 2019-02-18 kimcd DUMMY 품목 추가 시작
					 UNION ALL
					 SELECT L.FP_PLAN_ID
					      ,L.INSTANCE_ID
					      ,L.COMPANY_ID
						  ,L.DIVISION_ID
						  ,L.SITE_ID
						  ,L.PLANT_ID
						  ,L.FACTORY_ID
						  ,L.TOP_ITEM_ID
						  ,L.ITEM_ID
						  ,L.OPERATION_ID
						  ,L.PRODUCTION_TYPE
						  ,L.MARKET
						  ,L.LINE_ID
						  ,L.PLAN_DATE
						  ,L.PLAN_QTY
						  ,L.PLAN_IN_QTY
						  ,L.PLAN_GROUP_ID
						  ,L.CELL_IN_QTY
						  ,L.CELL_OUT_QTY
						  ,'-'  AS VERSION
					 FROM  ( SELECT @RELEASE_PLAN_ID   AS  FP_PLAN_ID
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
								  ,1                    AS PLAN_QTY
								  ,1                    AS PLAN_IN_QTY
								  ,'-'                  AS PLAN_GROUP_ID
								  ,0					AS CELL_IN_QTY
								  ,0					AS CELL_OUT_QTY
							 FROM  SCM_LINE_M AS L WITH(NOLOCK)
							      ,SCM_OPERATION_M AS O WITH(NOLOCK)
								  ,FP_INSTANCE_FACTORY_M AS IFM WITH(NOLOCK)
							 WHERE L.COMPANY_ID    = O.COMPANY_ID
							 AND   L.DIVISION_ID   = O.DIVISION_ID
							 AND   L.SITE_ID       = O.SITE_ID
							 AND   L.OPERATION_ID  = O.OPERATION_ID
							 AND   L.FACTORY_ID    = IFM.FACTORY_ID
							 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
							 AND   IFM.INSTANCE_ID = @INSTANCE_ID
							 AND   L.ACTIVE_FLAG   = 'Y'
							 AND   @CONFIRM_AREA   = 'BUILDING'
							 AND   NOT EXISTS ( SELECT 1
												FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
												WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
												AND    SLV.ACTIVE_FLAG       = 'Y'
												AND    SLV.SEGMENT2          = @INSTANCE_ID
												AND    SLV.SEGMENT3          = L.LINE_ID )
							 AND    NOT EXISTS (SELECT 1
												FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
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
								  ,1                    AS PLAN_QTY
								  ,1                    AS PLAN_IN_QTY
								  ,MAX(L.MODEL_TYPE)    AS PLAN_GROUP_ID
								  ,0					AS CELL_IN_QTY
								  ,0					AS CELL_OUT_QTY
							 FROM  SCM_LINE_M AS L WITH(NOLOCK)
							      ,SCM_OPERATION_M AS O WITH(NOLOCK)
								  ,FP_INSTANCE_FACTORY_M AS IFM WITH(NOLOCK)
							 WHERE L.COMPANY_ID    = O.COMPANY_ID
							 AND   L.DIVISION_ID   = O.DIVISION_ID
							 AND   L.SITE_ID       = O.SITE_ID
							 AND   L.OPERATION_ID  = O.OPERATION_ID
							 AND   L.FACTORY_ID    = IFM.FACTORY_ID
							 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
							 AND   IFM.INSTANCE_ID = @INSTANCE_ID
							 AND   L.ACTIVE_FLAG   = 'Y'
							 AND   @CONFIRM_AREA  != 'BUILDING'
							 AND   L.MODEL_TYPE IN  (SELECT SLV.SEGMENT2
													 FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
													 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													 AND    SLV.ACTIVE_FLAG       = 'Y'
													 AND    SLV.SEGMENT1          = @INSTANCE_ID)
							 AND   NOT EXISTS ( SELECT 1
												FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
												WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
												AND    SLV.ACTIVE_FLAG       = 'Y'
												AND    SLV.SEGMENT2          = @INSTANCE_ID
												AND    SLV.SEGMENT3          = L.LINE_ID )
							 AND    NOT EXISTS (SELECT 1
												FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
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
								  ,1                    AS PLAN_QTY
								  ,1                    AS PLAN_IN_QTY
								  ,'-'                  AS PLAN_GROUP_ID
								  ,0					AS CELL_IN_QTY
								  ,0					AS CELL_OUT_QTY
							 FROM  SCM_LINE_M AS L WITH(NOLOCK)
							      ,SCM_OPERATION_M AS O WITH(NOLOCK)
								  ,FP_INSTANCE_FACTORY_M AS IFM WITH(NOLOCK)
							 WHERE L.COMPANY_ID    = O.COMPANY_ID
							 AND   L.DIVISION_ID   = O.DIVISION_ID
							 AND   L.SITE_ID       = O.SITE_ID
							 AND   L.OPERATION_ID  = O.OPERATION_ID
							 AND   L.FACTORY_ID    = IFM.FACTORY_ID
							 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
							 AND   IFM.INSTANCE_ID = @INSTANCE_ID
							 AND   L.ACTIVE_FLAG   = 'Y'
							 AND   @CONFIRM_AREA   = 'BUILDING'
							 AND   L.LINE_ID IN ( SELECT SLV.SEGMENT3
												FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
												WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
												AND    SLV.ACTIVE_FLAG       = 'Y'
												AND    SLV.SEGMENT1          = @INSTANCE_ID )
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
								  ,1                    AS PLAN_QTY
								  ,1                    AS PLAN_IN_QTY
								  ,MAX(L.MODEL_TYPE)    AS PLAN_GROUP_ID
								  ,0					AS CELL_IN_QTY
								  ,0					AS CELL_OUT_QTY
							 FROM  SCM_LINE_M AS L WITH(NOLOCK)
							      ,SCM_OPERATION_M AS O WITH(NOLOCK)
								  ,FP_INSTANCE_FACTORY_M AS IFM WITH(NOLOCK)
							 WHERE L.COMPANY_ID    = O.COMPANY_ID
							 AND   L.DIVISION_ID   = O.DIVISION_ID
							 AND   L.SITE_ID       = O.SITE_ID
							 AND   L.OPERATION_ID  = O.OPERATION_ID
							 AND   L.FACTORY_ID    = IFM.FACTORY_ID
							 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
							 AND   IFM.INSTANCE_ID = @INSTANCE_ID
							 AND   L.ACTIVE_FLAG   = 'Y'
							 AND   @CONFIRM_AREA  != 'BUILDING'
							 AND   L.MODEL_TYPE IN  (SELECT SLV.SEGMENT2
													 FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
													 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
													 AND    SLV.ACTIVE_FLAG       = 'Y'
													 AND    SLV.SEGMENT1          = @INSTANCE_ID)
							 AND   L.LINE_ID IN ( SELECT SLV.SEGMENT3
												FROM   SCM_SYS_LOOKUP_VALUE AS SLV WITH(NOLOCK)
												WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
												AND    SLV.ACTIVE_FLAG       = 'Y'
												AND    SLV.SEGMENT1          = @INSTANCE_ID )
							 GROUP BY L.COMPANY_ID
								  ,L.DIVISION_ID
								  ,L.SITE_ID
								  ,L.PLANT_ID
								  ,L.FACTORY_ID
								  ,L.LINE_ID ) L
					 WHERE  NOT EXISTS (SELECT 1 
										FROM   FP_AMEND_PLAN_CELL_R AS PP WITH(NOLOCK)
					  				    WHERE  PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
									    AND    PP.INSTANCE_ID = @INSTANCE_ID
									    AND    PP.LINE_ID     = L.LINE_ID
										UNION ALL
										SELECT 1
										FROM   FP_AMEND_PLAN_PACK_R AS PP WITH(NOLOCK)
										WHERE  PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
										AND    PP.INSTANCE_ID = @INSTANCE_ID
					   					AND    PP.LINE_ID     = L.LINE_ID
					  					UNION ALL
										SELECT 1
										FROM   FP_AMEND_DAILY_PLAN_R AS PP WITH(NOLOCK)
										WHERE  PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
										AND    PP.INSTANCE_ID = @INSTANCE_ID
					   					AND    PP.LINE_ID     = L.LINE_ID
										UNION ALL
										SELECT 1
									    FROM   FP_AMEND_PLAN_FORM_R AS PP WITH(NOLOCK)
										WHERE  PP.FP_PLAN_ID  = @RELEASE_PLAN_ID
										AND    PP.INSTANCE_ID = @INSTANCE_ID
										AND    PP.FACTORY_ID != '-'
					   					AND    PP.LINE_ID     = L.LINE_ID
									   )
				   ) A
					LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK)  -- 2022-03-28 kimcd 가상 Division 로직 추가
						ON PD.PLANT_ID = A.PLANT_ID
			  ;

			SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT

			UPDATE DBO.SCM_FP_PLAN_H
			SET    MRP_FLAG = 'Y'
				   ,UPDATE_ID = 'PR_XIF_MRP_PROD_TARGET_S'
				   ,UPDATE_TIME = GETDATE()
			WHERE  INSTANCE_ID = @INSTANCE_ID
			AND    PLAN_ID     = @RELEASE_PLAN_ID

			FETCH NEXT FROM CUR_MRP_PLAN_ID INTO @INSTANCE_ID
												,@RELEASE_PLAN_ID
												,@INSTANCE_TYPE
												,@CONFIRM_AREA
										        ,@TARGET_DATE			--2019-05-09 PIYONG ADD

		END;  -- WHILE @@FETCH_STATUS = 0

        CLOSE CUR_MRP_PLAN_ID;
        DEALLOCATE CUR_MRP_PLAN_ID;   -- 메모리 해제
		-- 2019-02-18 kimcd MRP Plan 추가 끝

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
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
