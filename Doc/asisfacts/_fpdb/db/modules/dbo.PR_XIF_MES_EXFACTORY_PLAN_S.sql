
CREATE PROCEDURE [dbo].[PR_XIF_MES_EXFACTORY_PLAN_S]

-- ================================================================================================
-- Program ID          : FP01553
-- Program Name        : PR_XIF_MES_EXFACTORY_PLAN_S
-- Param               :
-- Batch Period        : 15 MINUTE
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : MES
-- Source Table        : FP_WEEKLY_DEMAND_SHIPMENT_H,  FP_CELL_DELIVERY_PLAN_H
-- Destination Table   : XIF_MES_EXFACTORY_PLAN_S
--
-- Create Date		   : 2018.08.09
-- Update Date		   : 2018.11.25
--						 2019.03.04
--						 2019.10.11 PIYONG
--					   : 2020.07.15	2.0 ver CYS
--                       2021.04.27 kimcd

-- Author              : KIMCD
-- Version             : 1.0
--                       1.1 KIMCD ACCUM_COUNT 계산에 PLANT_ID 추가
--                       1.2 KIMCD P - Pack 제품도 전송되도록 수정
--                       1.3 2018-09-27 kimcd SSP 계획에서 Cell Instance에는 Cell출하 정보만
--                                                         Pack Instance에는 Pack출하 정보만 전송
--                       1.4 2018-09-28 kimcd SSP 출하 정보에서 도착일자를 출하일로 변경
--                       1.5 2018-10-19 kimcd 기존 정보 가져오는 과정에서 중복 정보 발생하여 sub-query로 전환
--						 1.6 PACK 데이터 생성 조건 변경
--                       1.7 2018-11-25 kimcd mes_source_group not null 조건 추가
--						 1.8 2019-03-04 PIYONG XIF_MES_EXFACTORY_PLAN_S ATTR_02에 마케팅 담당자 추가
--						 1.9 SSP 전송 기준을 PLANT로 변경
--						 2.0 2020-07-15 CYS   전극 추가
--                       2.1 2021-04-27 kimcd FP_CELL_MOVE_PLAN_H WA 법인 in-house moving plan 기반 1시간 단위 전송
--                       2.2 2021-06-29 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                                      동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                                      라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--                       2.3 2024-03-29 KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영 
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_EXFACTORY_PLAN_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	--변수 설정
	DECLARE @INSTANCE_ID		    NVARCHAR(50)
	DECLARE @FP_PLAN_ID			    NVARCHAR(60)
	DECLARE @SITE_ID                NVARCHAR(30)
	DECLARE @MIN_DELIVERY_DATE		DATE
	DECLARE @MAX_INSERT_TIME		DATETIME
	DECLARE @LAST_PLAN_ID			NVARCHAR(60)
	DECLARE @LOCAL_TIME				NVARCHAR(20)
	DECLARE @DIVISION_ID 			NVARCHAR(30)
	DECLARE @PLANT_ID	 			NVARCHAR(30)		-- 2019-10-10 PIYONG ADD
	DECLARE @CATEGORY               NVARCHAR(30) = 'MOVING'  -- 2021-04-27 kimcd WA 법인 1 시간 단위 전송
	DECLARE @COMPANY_ID             NVARCHAR(30) -- 2021-04-27 kimcd WA 법인 1 시간 단위 전송
	DECLARE @FROM_PLAN_DATE         DATE -- 2021-04-27 kimcd WA 법인 1 시간 단위 전송
	
	DECLARE CUR_RELEASE CURSOR FOR
		SELECT A.INSTANCE_ID
			  --,A.INSTANCE_ID + CONVERT(NVARCHAR(20), A.MAX_INSERT_TIME, 120) AS PLAN_ID	-- 2018-11-19 PIYONG DEL
			  ,A.PLAN_ID								-- 2018-11-19 PIYONG ADD
			  ,A.SITE_ID
			  ,(SELECT MIN(C.DELIVERY_DATE)
			    FROM   FP_CELL_DELIVERY_PLAN_FIX_H C
				WHERE  C.INSTANCE_ID = A.INSTANCE_ID
				--AND    C.INSERT_TIME = A.MAX_INSERT_TIME		 	-- 2018-11-19 PIYONG DEL
				AND    C.PLAN_ID = A.PLAN_ID						-- 2018-11-19 PIYONG ADD
															 ) AS MIN_DELIVERY_DATE
			   ,A.MAX_INSERT_TIME
		  FROM (
				SELECT INSTANCE_ID
						, MAX(A.PLAN_ID) AS PLAN_ID		-- 2018-11-19 PIYONG ADD
						, MAX(SITE_ID) AS SITE_ID
						, MAX(INSERT_TIME) AS MAX_INSERT_TIME
				FROM   FP_CELL_DELIVERY_PLAN_FIX_H A
				GROUP BY INSTANCE_ID
			   ) A
/*
		 -- 2018-11-19 PIYONG DEL
			   LEFT OUTER JOIN ( SELECT B.INSTANCE_ID, MAX(B.MAX_INSERT_TIME) AS MAX_INSERT_TIME
							     FROM   SY_XIF_MES_EXFACTORY_PLAN_S B
							     WHERE  B.PLAN_TYPE = 'PACK'
					 		     GROUP BY B.INSTANCE_ID ) B
			   ON A.INSTANCE_ID = B.INSTANCE_ID
		  WHERE (B.MAX_INSERT_TIME IS NULL OR B.MAX_INSERT_TIME < A.MAX_INSERT_TIME)
*/
		-------------------------------------------------------------------------------------------------------------------------
		--	2018-11-19 PIYONG ADD
		 WHERE NOT EXISTS (
							SELECT 1
							  FROM SY_XIF_MES_EXFACTORY_PLAN_S B
							 WHERE B.PLAN_TYPE = 'PACK'
							   AND A.INSTANCE_ID = B.INSTANCE_ID
							   AND A.INSTANCE_ID+A.PLAN_ID = B.PLAN_ID
						)
		--	2018-11-19 PIYONG ADD
		-------------------------------------------------------------------------------------------------------------------------


	DECLARE CUR_SSP CURSOR FOR
		SELECT  DISTINCT H.DIVISION_ID
			   ,H.SCP_PLAN_ID
			   ,H.PLANT_ID									-- 2019-10-11 PIYONG ADD
			   ,H.SITE_ID	-- 2020-07-15 CYS local_time 위해 추가 2.0ver
		  FROM  FP_WEEKLY_DEMAND_SHIPMENT_H H 
		  WHERE INSERT_TIME >= DATEADD(DD, -1, GETDATE()) 
		  AND   SHOP_GROUP_ID IN ('A','P','E')  -- 2020-07-15 CYS 전극 추가 2.0 ver -- 조립 공정만 전송 2018-09-10 kimcd A(Cell), P(Pack) 전송하도록 조건 수정
		  AND   NOT EXISTS (
							SELECT 1
							  FROM SY_XIF_MES_EXFACTORY_PLAN_S B
							 WHERE B.PLAN_ID  = H.SCP_PLAN_ID
							 AND   B.PLANT_ID = ( SELECT TOP 1 MES_PLANT_ID
                                                  FROM   SCM_FACTORY_M F WITH(NOLOCK)
                                                  WHERE  F.PLANT_ID      = H.PLANT_ID
                                                  AND    F.SHOP_GROUP_ID = H.SHOP_GROUP_ID )  -- 2024-03-29 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						  )

	--DECLARE CUR_MOVE_PLAN CURSOR FOR -- 2021-04-27 kimcd WA 법인 1 시간 단위 전송
	--	SELECT 'MOVING' AS CATEGORY,
	--		P.COMPANY_ID,
	--		P.DIVISION_ID,
	--		P.SITE_ID,
	--		P.PLANT_ID,
	--		CONVERT( DATE, DBO.FN_SITE_TIME( P.SITE_ID ))  AS FROM_PLAN_DATE
	--	FROM   SCM_PLANT_M P (NOLOCK)
	--	WHERE  P.PLANT_ID = 'G481'
	--	AND    SUBSTRING(CONVERT(NVARCHAR(20), GETDATE(), 120), 15,2) >= '00'
	--	AND    SUBSTRING(CONVERT(NVARCHAR(20), GETDATE(), 120), 15,2) <= '15'
	-- kimcd 1 시간 단위 전송 적용 보류


	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			OPEN CUR_RELEASE;
			
			FETCH NEXT FROM CUR_RELEASE INTO @INSTANCE_ID
											,@FP_PLAN_ID
											,@SITE_ID
											,@MIN_DELIVERY_DATE
											,@MAX_INSERT_TIME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @LOCAL_TIME = REPLACE(REPLACE(REPLACE(CONVERT( NVARCHAR, DBO.FN_SITE_TIME( @SITE_ID ), 120), '-', ''), ':', ''), ' ', '');

					SELECT TOP 1 @LAST_PLAN_ID = S.[PLAN_ID]
					FROM   SY_XIF_MES_EXFACTORY_PLAN_S S -- WITH(NOLOCK) 2018-10-19 kimcd with(nolock) 막음
					WHERE  S.[PLAN_ID]   < @INSTANCE_ID+@FP_PLAN_ID	-- 2018-11-19 PIYONG CHANGE LIKE @INSTANCE_ID + '%' -> < @INSTANCE_ID+@FP_PLAN_ID
					AND	   S.INSTANCE_ID = @INSTANCE_ID				-- 2018-11-19 PIYONG ADD
--					AND    S.MAX_INSERT_TIME < @MAX_INSERT_TIME		-- 2018-11-19 PIYONG DEL
					AND    S.[PLAN_TYPE] = 'PACK'
					ORDER  BY  S.[IF_INS_DATE] DESC

					INSERT INTO SY_XIF_MES_EXFACTORY_PLAN_S (
						   [IF_SEQ]
						  ,[IF_TYPE]
						  ,[IF_ID]
						  ,[IF_INS_DATE]
						  ,[IF_FLAG]
						  ,[IF_SND_DATE]
						  ,[PLAN_ID]
						  ,[PLANT_ID]
						  ,[SHOP_GROUP_ID]
						  ,[ITEM_ID]
						  ,[SHIP_TO_PARTY]
						  ,[SHIP_DATE]
						  ,[SHIP_WEEK]
						  ,[SHIP_QTY]
						  ,[PRODUCTION_TYPE]
						  ,[TRANSPORT_MODE]
						  ,[MARKET]
						  ,[PLAN_TYPE]
						  ,[CHANGE_FLAG]
						  ,[ACCUM_DATE]
						  ,[ACCUM_COUNT]
						  ,[CREATE_PSN_ID]
						  ,[CREATE_DATE]
						  ,[UPDATE_PSN_ID]
						  ,[UPDATE_DATE]
						  ,[ATTR_01] -- SHIP_TO_CODE - TO_SITE_CODE
						  ,[ATTR_02]
						  ,[ATTR_03]
						  ,[ATTR_04]
						  ,[ATTR_05]
						  ,[ATTR_06]
						  ,[ATTR_07]
						  ,[ATTR_08]
						  ,[ATTR_09]
						  ,[ATTR_10]
						  ,[INSTANCE_ID]
						  ,[MAX_INSERT_TIME]
					)
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
								   + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ]))
								   + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)	AS IF_SEQ
						  ,'S' -- [IF_TYPE]
						  ,'OFP0'+'_'+ D.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN' -- [IF_ID]
						  ,GETDATE()						-- [IF_INS_DATE]
						  ,'N'								-- [IF_FLAG]
						  ,NULL							-- [IF_SND_DATE]
						  ,@INSTANCE_ID+@FP_PLAN_ID	--@FP_PLAN_ID  -- [PLAN_ID]		--2018-11-19 PIYONG CHANG	 @FP_PLAN_ID -> @INSTANCE_ID+@FP_PLAN_ID
						  ,D.[MES_PLANT_ID]   -- 2024-03-29 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						  ,D.[SHOP_GROUP_ID]
						  ,D.[ITEM_ID]
						  ,D.[STORAGE_ID]     -- [SHIP_TO_PARTY]
						  ,CONVERT(NVARCHAR(8), D.[DELIVERY_DATE], 112)  -- [SHIP_DATE]
						  ,D.[SHIP_WEEK]
						  ,D.[DELIVERY_QTY]   -- [SHIP_QTY]
						  ,NULL               -- [PRODUCTION_TYPE]
						  ,D.[SOC_ID]         -- [TRANSPORT_MODE]
						  ,ISNULL(D.[MARKET],'D') -- 2018-09-10 kimcd market에 NULL 처리
						  ,'PACK'             -- [PLAN_TYPE]
						  ,CASE WHEN D.[SHIP_QTY] IS NULL OR D.[SHIP_QTY] != D.[DELIVERY_QTY] THEN 'Y' ELSE 'N' END -- [CHANGE_FLAG]  -- 2018-10-19 kimcd sub query로 전환
						  ,@LOCAL_TIME  -- [ACCUM_DATE]
						  ,COUNT(*) OVER(PARTITION BY MES_SOURCE_GROUP, D.PLANT_ID) -- [ACCUM_COUNT] 2018-08-30 KIMCD PLANT_ID를 ACCOUM_COUNT에 추가
						  ,@v_proc_name -- [CREATE_PSN_ID]
						  ,GETDATE()    -- [CREATE_DATE]
						  ,@v_proc_name -- [UPDATE_PSN_ID]
						  ,GETDATE()    -- [UPDATE_DATE]
						  ,D.[STORAGE_ID]  -- [ATTR_01] SHIP_TO_CODE - TO_SITE_CODE
						  ,NULL -- [ATTR_02]
						  ,NULL -- [ATTR_03]
						  ,NULL -- [ATTR_04]
						  ,NULL -- [ATTR_05]
						  ,NULL -- [ATTR_06]
						  ,NULL -- [ATTR_07]
						  ,NULL -- [ATTR_08]
						  ,NULL -- [ATTR_09]
						  ,NULL -- [ATTR_10]
						  ,@INSTANCE_ID
						  ,@MAX_INSERT_TIME
					FROM  ( SELECT D.[PLANT_ID]
                                  ,F.[MES_PLANT_ID]   -- 2024-03-29 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
								  ,F.[MES_SOURCE_GROUP]
								  ,F.[SHOP_GROUP_ID]
								  ,D.[ITEM_ID]
								  ,D.[STORAGE_ID]     -- [SHIP_TO_PARTY]
								  ,D.[DELIVERY_DATE]  -- [SHIP_DATE]
								  ,D.[SHIP_WEEK]
								  ,D.[DELIVERY_QTY]   -- [SHIP_QTY]
								  ,D.[SOC_ID]         -- [TRANSPORT_MODE]
								  ,D.[MARKET]
								  ,(SELECT TOP 1 S.[SHIP_QTY]
								    FROM SY_XIF_MES_EXFACTORY_PLAN_S S --WITH(NOLOCK)
									WHERE S.[IF_ID]                     = 'OFP0'+'_'+ F.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN'
									AND S.[PLAN_ID]                   = @LAST_PLAN_ID
									AND S.[PLANT_ID]                  = F.[MES_PLANT_ID]  -- 2024-03-29 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
									AND ISNULL(S.[SHOP_GROUP_ID],'-') = ISNULL(F.[SHOP_GROUP_ID],'-')
									AND S.[ITEM_ID]                   = D.[ITEM_ID]
									AND S.[SHIP_TO_PARTY]             = D.[STORAGE_ID]
									AND S.[SHIP_DATE]                 = D.[DELIVERY_DATE]
									AND S.[TRANSPORT_MODE]            = D.[SOC_ID]
									AND ISNULL(S.[MARKET],'D')        = ISNULL(D.[MARKET],'D') -- 2018-09-10 kimcd market에 NULL 처리 '-'에서 'D'로 변경
									AND S.[PLAN_TYPE]                 = 'PACK') AS [SHIP_QTY] -- 2018-10-19 kimcd sub query로 전환
							FROM   ( SELECT D.[PLANT_ID]
										   ,D.[ITEM_ID]
										   ,D.[STORAGE_ID]     -- [SHIP_TO_PARTY]
										   ,D.[DELIVERY_DATE]  -- [SHIP_DATE]
										   ,D.[DELIVERY_QTY]   -- [SHIP_QTY]
										   ,D.[SOC_ID]         -- [TRANSPORT_MODE]
										   ,D.[MARKET]
										   ,(SELECT TOP 1 W.WEEK
											 FROM   [DBO].SCM_SYS_CALENDAR_M W WITH(NOLOCK)
											 WHERE  W.DATE_ID = D.[DELIVERY_DATE]) AS [SHIP_WEEK]
									 FROM   FP_CELL_DELIVERY_PLAN_FIX_H D   WITH(NOLOCK)
									 WHERE  D.INSTANCE_ID    = @INSTANCE_ID
									 AND    D.SITE_ID        = @SITE_ID
									 AND    D.DELIVERY_DATE >= @MIN_DELIVERY_DATE
									 AND	D.PLAN_ID		 = @FP_PLAN_ID	--2018-11-19 PIYONG ADD
									) D
									-- 2021-06-29 kimis ESNJ 6동 GMES DB 분리에 따른 변경
									-- 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
									-- 라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
									--,( SELECT DISTINCT F.PLANT_ID, F.MES_SOURCE_GROUP, F.SHOP_GROUP_ID
									--   FROM  SCM_FACTORY_M  F   WITH(NOLOCK) 
									--   WHERE F.SHOP_GROUP_ID IN ('A','P')
									-- AND   F.MES_SOURCE_GROUP IS NOT NULL -- 2018-11-25 kimcd MES_SOURCE_GROUP NOT NULL 조건 추가
									-- ) F
									,( SELECT DISTINCT F.PLANT_ID, F.MES_PLANT_ID, ISNULL(L.MES_SOURCE_GROUP, F.MES_SOURCE_GROUP) AS MES_SOURCE_GROUP, F.SHOP_GROUP_ID  -- 2024-03-29 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
									     FROM SCM_FACTORY_M  F   WITH(NOLOCK) 
									     LEFT OUTER JOIN SCM_MMD_LINE_M L 
									       ON L.COMPANY_ID      = F.COMPANY_ID
											  AND L.DIVISION_ID = F.DIVISION_ID
											  AND L.SITE_ID     = F.SITE_ID
											  AND L.PLANT_ID    = F.PLANT_ID
											  AND L.FACTORY_ID  = F.FACTORY_ID
											  AND L.MES_SOURCE_GROUP IS NOT NULL
										WHERE F.SHOP_GROUP_ID IN ('A','P')
									      AND F.MES_SOURCE_GROUP IS NOT NULL -- 2018-11-25 kimcd MES_SOURCE_GROUP NOT NULL 조건 추가
                                      ) F		
							WHERE  F.PLANT_ID       = D.PLANT_ID ) D
							/* 2018-10-19 kimcd block
							LEFT OUTER JOIN SY_XIF_MES_EXFACTORY_PLAN_S S --WITH(NOLOCK)
							ON  S.[IF_ID]                     = 'OFP0'+'_'+ D.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN'
							AND S.[PLAN_ID]                   = @LAST_PLAN_ID
							AND S.[PLANT_ID]                  = D.[PLANT_ID]
							AND ISNULL(S.[SHOP_GROUP_ID],'-') = ISNULL(D.[SHOP_GROUP_ID],'-')
							AND S.[ITEM_ID]                   = D.[ITEM_ID]
							AND S.[SHIP_TO_PARTY]             = D.[STORAGE_ID]
							AND S.[SHIP_DATE]                 = D.[DELIVERY_DATE]
							AND S.[TRANSPORT_MODE]            = D.[SOC_ID]
							AND ISNULL(S.[MARKET],'D')        = ISNULL(D.[MARKET],'D') -- 2018-09-10 kimcd market에 NULL 처리 '-'에서 'D'로 변경
							AND S.[PLAN_TYPE]                 = 'PACK' */

					FETCH NEXT FROM CUR_RELEASE INTO @INSTANCE_ID
													 ,@FP_PLAN_ID
													 ,@SITE_ID
													 ,@MIN_DELIVERY_DATE
													 ,@MAX_INSERT_TIME

				END

			CLOSE CUR_RELEASE;
			DEALLOCATE CUR_RELEASE;

			OPEN CUR_SSP;
			
			FETCH NEXT FROM CUR_SSP INTO @DIVISION_ID
										,@FP_PLAN_ID
										,@PLANT_ID																			-- 2019-10-11 PIYONG ADD
										,@SITE_ID		-- 2020-07-15 CYS 2.0ver add

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					SET @LOCAL_TIME = REPLACE(REPLACE(REPLACE(CONVERT( NVARCHAR, DBO.FN_SITE_TIME( @SITE_ID ), 120), '-', ''), ':', ''), ' ', ''); -- 2020-07-15 CYS A001에서 @SITE_ID로 변경

					SELECT TOP 1 @LAST_PLAN_ID = S.[SCP_PLAN_ID]
					FROM   FP_WEEKLY_DEMAND_SHIPMENT_H S WITH(NOLOCK)
					WHERE  S.[DIVISION_ID]  = @DIVISION_ID
					AND    S.[SITE_ID]		= @SITE_ID			-- 2.0 ver 추가
					AND    S.[PLANT_ID]		= @PLANT_ID																			-- 2019-10-11 PIYONG ADD
					AND    S.[SHOP_GROUP_ID] IN ('A','P', 'E') -- 2020-07-15 CYS 전극 포함 2.0ver  -- 조립 공정만 전송 2018-09-10 kimcd A(Cell), P(Pack) 전송하도록 조건 수정
					AND    S.[SCP_PLAN_ID]  < @FP_PLAN_ID
					ORDER  BY  S.[SCP_PLAN_ID] DESC

					INSERT INTO SY_XIF_MES_EXFACTORY_PLAN_S (
						   [IF_SEQ]
						  ,[IF_TYPE]
						  ,[IF_ID]
						  ,[IF_INS_DATE]
						  ,[IF_FLAG]
						  ,[IF_SND_DATE]
						  ,[PLAN_ID]
						  ,[PLANT_ID]
						  ,[SHOP_GROUP_ID]
						  ,[ITEM_ID]
						  ,[SHIP_TO_PARTY]
						  ,[SHIP_DATE]
						  ,[SHIP_WEEK]
						  ,[SHIP_QTY]
						  ,[PRODUCTION_TYPE]
						  ,[TRANSPORT_MODE]
						  ,[MARKET]
						  ,[PLAN_TYPE]
						  ,[CHANGE_FLAG]
						  ,[ACCUM_DATE]
						  ,[ACCUM_COUNT]
						  ,[CREATE_PSN_ID]
						  ,[CREATE_DATE]
						  ,[UPDATE_PSN_ID]
						  ,[UPDATE_DATE]
						  ,[ATTR_01] -- SHIP_TO_CODE - TO_SITE_CODE
						  ,[ATTR_02] -- 마케팅 담당자
						  ,[ATTR_03] -- 2020-07-15 CVS FACTORY_ID	2.0ver
						  ,[ATTR_04] -- 2020-07-15 CVS POST_OPER	2.0ver
						  ,[ATTR_05] -- 2020-07-15 CVS REMARKS		2.0ver
						  ,[ATTR_06]
						  ,[ATTR_07]
						  ,[ATTR_08]
						  ,[ATTR_09]
						  ,[ATTR_10]
					)
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
								   + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ]))
								   + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)	AS IF_SEQ
						  ,'S' -- [IF_TYPE]
						  ,'OFP0'+'_'+ D.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN' -- [IF_ID]
						  ,GETDATE()						-- [IF_INS_DATE]
						  ,'N'								-- [IF_FLAG]
						  ,NULL							-- [IF_SND_DATE]
						  ,@FP_PLAN_ID  -- [PLAN_ID]
						  ,D.[MES_PLANT_ID]  -- 2024-03-29 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						  ,D.[SHOP_GROUP_ID]
						  ,D.[ITEM_ID]
						  ,D.[SHIP_TO_PARTY]  -- [SHIP_TO_PARTY]
						  ,D.[SHIP_DATE]      -- [SHIP_DATE]
						  ,D.[SHIP_WEEK]
						  ,D.[SHIP_QTY]       -- [SHIP_QTY]
						  ,NULL               -- [PRODUCTION_TYPE]
						  ,D.[TRANSPORT_MODE]
						  ,ISNULL(D.[MARKET],'D') -- 2018-09-10 kimcd market에 NULL 처리
						  ,'SSP'              -- [PLAN_TYPE]
						  ,CASE WHEN D.[OLD_SHIP_QTY] IS NULL OR D.[OLD_SHIP_QTY] != D.[SHIP_QTY] THEN 'Y' ELSE 'N' END -- [CHANGE_FLAG] -- 2018-10-19 kimcd sub query로 전환
						  ,@LOCAL_TIME  -- [ACCUM_DATE]
						  ,COUNT(*) OVER(PARTITION BY MES_SOURCE_GROUP, D.PLANT_ID) -- [ACCUM_COUNT] 2018-08-30 KIMCD PLANT_ID를 ACCOUM_COUNT에 추가
						  ,@v_proc_name -- [CREATE_PSN_ID]
						  ,GETDATE()    -- [CREATE_DATE]
						  ,@v_proc_name -- [UPDATE_PSN_ID]
						  ,GETDATE()    -- [UPDATE_DATE]
						  ,D.[SHIP_TO_CODE]  -- [ATTR_01] SHIP_TO_CODE - TO_SITE_CODE
						  ,D.OWNER -- [ATTR_02]
						  ,D.FACTORY_ID -- 2020-07-15 CVS [ATTR_03]	2.0ver add
						  ,D.POST_OPER  -- 2020-07-15 CVS [ATTR_04]	2.0ver add
						  ,D.REMARKS    -- 2020-07-15 CVS [ATTR_05]	2.0ver add
						  ,NULL -- [ATTR_06]
						  ,NULL -- [ATTR_07]
						  ,NULL -- [ATTR_08]
						  ,NULL -- [ATTR_09]
						  ,NULL -- [ATTR_10]
					FROM  ( SELECT D.[PLANT_ID]
                                  ,F.[MES_PLANT_ID]  -- 2024-03-29 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
								  ,F.[MES_SOURCE_GROUP]
								  ,F.[SHOP_GROUP_ID]
								  ,D.[ITEM_ID]
								  ,D.[SHIP_TO_CODE]
								  ,D.[SHIP_TO_PARTY]
								  ,D.[SHIP_DATE]
								  ,D.[SHIP_WEEK]
								  ,D.[SHIP_QTY]
								  ,D.[TRANSPORT_MODE]
								  ,D.[MARKET]
								  ,(SELECT TOP 1 S.[SHIP_QTY]
								    FROM   SY_XIF_MES_EXFACTORY_PLAN_S S --WITH(NOLOCK)
									WHERE  S.[IF_ID]                  = 'OFP0'+'_'+ F.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN'
									AND S.[PLAN_ID]                   = @LAST_PLAN_ID
									AND S.[PLANT_ID]                  = F.[MES_PLANT_ID]  -- 2024-03-29 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
									AND ISNULL(S.[SHOP_GROUP_ID],'-') = ISNULL(F.[SHOP_GROUP_ID],'-')
									AND S.[ITEM_ID]                   = D.[ITEM_ID]
									AND S.[ATTR_01]                   = D.[SHIP_TO_CODE]
									AND S.[SHIP_DATE]                 = D.[SHIP_DATE]
									AND S.[TRANSPORT_MODE]            = D.[TRANSPORT_MODE]
									AND ISNULL(S.[MARKET],'D')        = ISNULL(D.[MARKET],'D')  -- 2018-09-10 kimcd market에 NULL 처리 '-'에서 'D'로 변경
									AND S.[PLAN_TYPE]                 = 'SSP') AS [OLD_SHIP_QTY] -- 2018-10-19 kimcd sub query로 전환
								   ,SUBSTRING(D.OWNER, 1 , 100) AS OWNER															-- 2019-02-28 PIYONG
								   ,D.FACTORY_ID	-- 2020-07-15 CVS 2.0ver add
								   ,D.POST_OPER		-- 2020-07-15 CVS 2.0ver add
								   ,D.REMARKS		-- 2020-07-15 CVS 2.0ver add
							 FROM  ( SELECT D.[PLANT_ID]
										    ,D.[ITEM_ID]
										    ,ISNULL(D.[SHIP_TO_CODE],'-')  AS [SHIP_TO_CODE]
										    ,MAX(ISNULL(D.[SHIP_TO_PARTY],'-')) AS [SHIP_TO_PARTY]
										    ,CONVERT( NVARCHAR(8), D.[SHIP_DATE], 112) AS [SHIP_DATE]  -- 2018-09-28 kimcd 출하일로 변경
										    ,SUM(D.[SHIP_QTY])             AS [SHIP_QTY]
										    ,D.[TRANSPORT_MODE]
										    ,D.[MARKET]
										    ,D.[SHOP_GROUP_ID] -- 2018-09-27 kimcd Cell, Pack 구분
										    ,MAX(D.[SHIP_WEEK])       AS SHIP_WEEK -- 2018-09-28 kimcd 출하일로 변경
										    ,STUFF(( SELECT ',' + b.owner  -- 마케팅 담당자 
													   FROM ( SELECT DISTINCT B.OWNER
															    FROM LGCE_SCMDEV.DBO.SCM_MST_SITE_ITEM  B WITH(NOLOCK)  
															   WHERE B.DIVISION_ID = @DIVISION_ID
															--AND B.SCM_SITE_ID = D.TO_SITE_ID
																 AND B.ITEM_ID = D.ITEM_ID ) B FOR XML PATH('') ),1,1,'')  AS OWNER					--2019-02-28 PIYONG
											,MAX(D.FACTORY_ID) AS FACTORY_ID	-- 2020-07-15 CVS 2.0ver add
										    ,MAX(D.POST_OPER) AS POST_OPER		-- 2020-07-15 CVS 2.0ver add
										    ,MAX(D.REMARKS) AS REMARKS			-- 2020-07-15 CVS 2.0ver add
									   FROM FP_WEEKLY_DEMAND_SHIPMENT_H D   WITH(NOLOCK)
									  WHERE 1=1
										AND D.DIVISION_ID    = @DIVISION_ID
										AND D.SITE_ID		 = @SITE_ID			-- 2020-07-15 CYS 2.0 ver 추가
										AND D.PLANT_ID		 = @PLANT_ID																			-- 2019-10-11 PIYONG ADD
										AND D.SHOP_GROUP_ID  IN ('A', 'P', 'E') -- 2020-07-15 CYS 전극 추가 2.0 ver  -- 조립 공정만 전송 2018-09-10 kimcd Pack도 전송되도록 수정
										AND D.SCP_PLAN_ID    = @FP_PLAN_ID
										AND D.SHIP_DATE     >= CONVERT(DATE, SUBSTRING(@LOCAL_TIME, 1, 8), 112)  -- 2018-09-28 kimcd 출하일로 변경
									  GROUP BY D.[PLANT_ID]
											,D.[ITEM_ID]
											,ISNULL(D.[SHIP_TO_CODE],'-')
											,D.[SHIP_DATE]   -- 2018-09-28 kimcd 출하일로 변경
											,D.[TRANSPORT_MODE]
											,D.[MARKET]
											,D.[SHOP_GROUP_ID] -- 2018-09-27 kimcd Cell, Pack 구분
									) D
									-- 2021-06-29 kimis ESNJ 6동 GMES DB 분리에 따른 변경
									-- 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
									-- 라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
									--,( SELECT DISTINCT F.PLANT_ID, F.MES_SOURCE_GROUP, F.SHOP_GROUP_ID
									--   FROM  SCM_FACTORY_M  F   WITH(NOLOCK) 
									--   WHERE F.SHOP_GROUP_ID IN ('A','P','E')		-- 2020-07-15 CYS 전극 추가 2.0ver
									-- AND   F.MES_SOURCE_GROUP IS NOT NULL -- 2018-11-25 kimcd MES_SOURCE_GROUP NOT NULL 조건 추가
									-- ) F
									,( SELECT DISTINCT F.PLANT_ID, F.MES_PLANT_ID, ISNULL(L.MES_SOURCE_GROUP, F.MES_SOURCE_GROUP) AS MES_SOURCE_GROUP, F.SHOP_GROUP_ID  -- 2024-03-29 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
										 FROM SCM_FACTORY_M  F   WITH(NOLOCK) 
										 LEFT OUTER JOIN SCM_MMD_LINE_M L 
										   ON L.COMPANY_ID      = F.COMPANY_ID
											  AND L.DIVISION_ID = F.DIVISION_ID
											  AND L.SITE_ID     = F.SITE_ID
											  AND L.PLANT_ID    = F.PLANT_ID
											  AND L.FACTORY_ID  = F.FACTORY_ID
											  AND L.MES_SOURCE_GROUP IS NOT NULL
								        WHERE F.SHOP_GROUP_ID IN ('A','P','E')		-- 2020-07-15 CYS 전극 추가 2.0ver
									      AND F.MES_SOURCE_GROUP IS NOT NULL -- 2018-11-25 kimcd MES_SOURCE_GROUP NOT NULL 조건 추가
									  ) F	
							WHERE  F.PLANT_ID       = D.PLANT_ID
							AND    F.SHOP_GROUP_ID  = D.SHOP_GROUP_ID  -- 2018-09-27 kimcd Cell, Pack 구분
							                                           ) D
							/* 2018-10-19 kimcd block
							LEFT OUTER JOIN SY_XIF_MES_EXFACTORY_PLAN_S S --WITH(NOLOCK)
							ON  S.[IF_ID]                     = 'OFP0'+'_'+ D.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN'
							AND S.[PLAN_ID]                   = @LAST_PLAN_ID
							AND S.[PLANT_ID]                  = D.[PLANT_ID]
							AND ISNULL(S.[SHOP_GROUP_ID],'-') = ISNULL(D.[SHOP_GROUP_ID],'-')
							AND S.[ITEM_ID]                   = D.[ITEM_ID]
							AND S.[ATTR_01]                   = D.[SHIP_TO_CODE]
							AND S.[SHIP_DATE]                 = D.[SHIP_DATE]
							AND S.[TRANSPORT_MODE]            = D.[TRANSPORT_MODE]
							AND ISNULL(S.[MARKET],'D')        = ISNULL(D.[MARKET],'D')  -- 2018-09-10 kimcd market에 NULL 처리 '-'에서 'D'로 변경
							AND S.[PLAN_TYPE]                 = 'SSP'*/

					FETCH NEXT FROM CUR_SSP INTO @DIVISION_ID
												,@FP_PLAN_ID
												,@PLANT_ID																			-- 2019-10-11 PIYONG ADD
												,@SITE_ID			-- 2020-07-15 CYS 2.0ver add
					;
				END

			CLOSE CUR_SSP;
			DEALLOCATE CUR_SSP;

			-- kimcd 1시간 단위 전송 적용 보류
		--	-----------------------------------------  2021-04-27 kimcd 임시 1시간 마다 계획 전송. WA용 시작
		--	OPEN CUR_MOVE_PLAN;
			
		--	FETCH NEXT FROM CUR_MOVE_PLAN INTO   @CATEGORY
		--										,@COMPANY_ID
		--										,@DIVISION_ID
		--										,@SITE_ID
		--										,@PLANT_ID
		--										,@FROM_PLAN_DATE

		--	WHILE (@@FETCH_STATUS = 0)
		--		BEGIN
		--			SET @LOCAL_TIME = REPLACE(REPLACE(REPLACE(CONVERT( NVARCHAR, DBO.FN_SITE_TIME( @SITE_ID ), 120), '-', ''), ':', ''), ' ', '');
		--			SET @MAX_INSERT_TIME = DBO.FN_SITE_TIME( @SITE_ID );
		--			SELECT TOP 1 @LAST_PLAN_ID = S.[PLAN_ID]
		--			FROM   SY_XIF_MES_EXFACTORY_PLAN_S S
		--			WHERE  S.[PLAN_ID]   < 'PL_FORM_A-'+@LOCAL_TIME
		--			AND	   S.INSTANCE_ID = 'PL_FORM_A'
		--			AND    S.[PLAN_TYPE] = 'PACK'
		--			ORDER  BY  S.[IF_INS_DATE] DESC

		--			INSERT INTO SY_XIF_MES_EXFACTORY_PLAN_S (
		--				   [IF_SEQ]
		--				  ,[IF_TYPE]
		--				  ,[IF_ID]
		--				  ,[IF_INS_DATE]
		--				  ,[IF_FLAG]
		--				  ,[IF_SND_DATE]
		--				  ,[PLAN_ID]
		--				  ,[PLANT_ID]
		--				  ,[SHOP_GROUP_ID]
		--				  ,[ITEM_ID]
		--				  ,[SHIP_TO_PARTY]
		--				  ,[SHIP_DATE]
		--				  ,[SHIP_WEEK]
		--				  ,[SHIP_QTY]
		--				  ,[PRODUCTION_TYPE]
		--				  ,[TRANSPORT_MODE]
		--				  ,[MARKET]
		--				  ,[PLAN_TYPE]
		--				  ,[CHANGE_FLAG]
		--				  ,[ACCUM_DATE]
		--				  ,[ACCUM_COUNT]
		--				  ,[CREATE_PSN_ID]
		--				  ,[CREATE_DATE]
		--				  ,[UPDATE_PSN_ID]
		--				  ,[UPDATE_DATE]
		--				  ,[ATTR_01] -- SHIP_TO_CODE - TO_SITE_CODE
		--				  ,[ATTR_02]
		--				  ,[ATTR_03] -- FROM FACTORY ID
		--				  ,[ATTR_04]
		--				  ,[ATTR_05]
		--				  ,[ATTR_06]
		--				  ,[ATTR_07]
		--				  ,[ATTR_08]
		--				  ,[ATTR_09]
		--				  ,[ATTR_10]
		--				  ,[INSTANCE_ID]
		--				  ,[MAX_INSERT_TIME]
		--			)
		--SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
		--				+ REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ]))
		--				+ CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)	AS IF_SEQ
		--		,'S'			-- [IF_TYPE]
		--		,'OFP0'+'_'+ D.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN' -- [IF_ID]
		--		,GETDATE()	-- [IF_INS_DATE]
		--		,'N'			-- [IF_FLAG]
		--		,NULL			-- [IF_SND_DATE]
		--		,'PL_FORM_A-' +@LOCAL_TIME
		--		,D.[PLANT_ID]
		--		,D.[SHOP_GROUP_ID]
		--		,D.[ITEM_ID]
		--		,D.[PACK_FACTORY_ID] -- [SHIP_TO_PARTY]
		--		,CONVERT(NVARCHAR(8), D.[PLAN_DATE], 112)  -- [SHIP_DATE]
		--		,D.[SHIP_WEEK]
		--		,D.[QTY]   -- [SHIP_QTY]
		--		,NULL      -- [PRODUCTION_TYPE]
		--		,'Etc'     -- [TRANSPORT_MODE]
		--		,'D'       -- Market
		--		,'PACK'    -- [PLAN_TYPE]
		--		,CASE WHEN D.[SHIP_QTY] IS NULL OR D.[SHIP_QTY] != D.[QTY] THEN 'Y' ELSE 'N' END       -- [CHANGE_FLAG]
		--		,@LOCAL_TIME  -- [ACCUM_DATE]
		--		,COUNT(*) OVER(PARTITION BY MES_SOURCE_GROUP, D.PLANT_ID)
		--		,@v_proc_name -- [CREATE_PSN_ID]
		--		,GETDATE()    -- [CREATE_DATE]
		--		,@v_proc_name -- [UPDATE_PSN_ID]
		--		,GETDATE()    -- [UPDATE_DATE]
		--		,D.[PACK_FACTORY_ID] -- [ATTR_01] SHIP_TO_CODE - TO_SITE_CODE
		--		,NULL -- [ATTR_02]
		--		,D.[CELL_FACTORY_ID] -- [ATTR_03]
		--		,NULL -- [ATTR_04]
		--		,NULL -- [ATTR_05]
		--		,NULL -- [ATTR_06]
		--		,NULL -- [ATTR_07]
		--		,NULL -- [ATTR_08]
		--		,NULL -- [ATTR_09]
		--		,NULL -- [ATTR_10]
		--		,'PL_FORM_A'  -- [INSTANCE_ID]
		--		,@MAX_INSERT_TIME 
		--FROM  ( SELECT D.[PLANT_ID]
		--				,F.[MES_SOURCE_GROUP]
		--				,F.[SHOP_GROUP_ID]
		--				,D.[ITEM_ID]
		--				,D.[PLAN_DATE]
		--				,D.[SHIP_WEEK]
		--				,D.[CELL_FACTORY_ID]
		--				,D.[PACK_FACTORY_ID]
		--				,D.[QTY]   -- [SHIP_QTY]
		--			    ,(  SELECT TOP 1 S.[SHIP_QTY]
		--					FROM SY_XIF_MES_EXFACTORY_PLAN_S S --WITH(NOLOCK)
		--					WHERE S.[IF_ID]                   = 'OFP0'+'_'+ F.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN'
		--					AND S.[PLAN_ID]                   = @LAST_PLAN_ID
		--					AND S.[PLANT_ID]                  = D.[PLANT_ID]
		--					AND ISNULL(S.[SHOP_GROUP_ID],'-') = ISNULL(F.[SHOP_GROUP_ID],'-')
		--					AND S.[ITEM_ID]                   = D.[ITEM_ID]
		--					AND S.[SHIP_TO_PARTY]             = D.[PACK_FACTORY_ID]
		--					AND S.[SHIP_DATE]                 = CONVERT(NVARCHAR(8), D.[PLAN_DATE], 112)
		--					AND S.[TRANSPORT_MODE]            = 'Etc'
		--					AND ISNULL(S.[MARKET],'D')        = 'D'
		--					AND S.[ATTR_03]                   = D.[CELL_FACTORY_ID]
		--					AND S.[PLAN_TYPE]                 = 'PACK') AS [SHIP_QTY]
		--				,D.INSERT_ID
		--				,D.INSERT_DTTM
		--				,D.UPDATE_ID
		--				,D.UPDATE_DTTM
		--		FROM   ( SELECT D.[PLANT_ID]
		--						,D.[ITEM_ID]
		--						,D.[PLAN_DATE]
		--						,D.[CELL_FACTORY_ID]
		--						,D.[PACK_FACTORY_ID]
		--						,D.[QTY]
		--						,(SELECT TOP 1 W.WEEK
		--							FROM   [DBO].SCM_SYS_CALENDAR_M W WITH(NOLOCK)
		--							WHERE  W.DATE_ID = D.[PLAN_DATE]) AS [SHIP_WEEK]
		--						,D.INSERT_ID
		--						,D.INSERT_DTTM
		--						,D.UPDATE_ID
		--						,D.UPDATE_DTTM
		--					FROM   FP_CELL_MOVE_PLAN_H D   WITH(NOLOCK)
		--					WHERE  D.CATEGORY    = @CATEGORY
		--					AND	D.COMPANY_ID  = @COMPANY_ID
		--					AND	D.DIVISION_ID = @DIVISION_ID
		--					AND	D.SITE_ID     = @SITE_ID
		--					AND	D.PLANT_ID    = @PLANT_ID
		--					AND	D.PLAN_DATE  >= @FROM_PLAN_DATE
		--				) D
		--				,( SELECT DISTINCT F.PLANT_ID, F.MES_SOURCE_GROUP, F.SHOP_GROUP_ID
		--					FROM  SCM_FACTORY_M  F   WITH(NOLOCK) 
		--					WHERE F.SHOP_GROUP_ID IN ('A','P')
		--					AND   F.MES_SOURCE_GROUP IS NOT NULL
		--					) F
		--		WHERE  F.PLANT_ID       = D.PLANT_ID ) D


		--			FETCH NEXT FROM CUR_MOVE_PLAN INTO   @CATEGORY
		--												,@COMPANY_ID
		--												,@DIVISION_ID
		--												,@SITE_ID
		--												,@PLANT_ID
		--												,@FROM_PLAN_DATE
		--		END

		--	CLOSE CUR_MOVE_PLAN;
		--	DEALLOCATE CUR_MOVE_PLAN;
		--	-----------------------------------------  2021-04-27 kimcd 임시 1시간 마다 계획 전송. WA용 끝

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		
		-- cursor 중복 오류로 인해 추가함 2.0 ver add
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_RELEASE')
		BEGIN
			CLOSE CUR_RELEASE
			DEALLOCATE CUR_RELEASE
		END
        -- cursor 중복 오류로 인해 추가함 2.0 ver add
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_SSP')
		BEGIN
			CLOSE CUR_SSP
			DEALLOCATE CUR_SSP
		END

		ROLLBACK TRAN

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
