
CREATE PROCEDURE [dbo].[PR_XIF_MES_EXFACTORY_PLAN_CU_S]

-- ================================================================================================
-- Program ID          : FP01553
-- Program Name        : PR_XIF_MES_EXFACTORY_PLAN_CU_S
-- Param               :
-- Batch Period        : 사용자 호출
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : MES
-- Source Table        : 
-- Destination Table   : XIF_MES_EXFACTORY_PLAN_S, FP_CELL_MOVE_PLAN_MES_SEND_H

--
-- Create Date		   : 2021.03.29
-- Update Date		   : 2021.05.13

-- Author              : KIMCD
-- Version             : 1.0 사용자 요청하여 전송할 수 있도록 작업 분리
--                       1.1 2021-05-13 kimcd MES로 계획 전송할 때 이력 정보 형성
--                       1.2 2021-06-16 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                                      동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                                      라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
-- ================================================================================================
	@P_CALL_SEQUENCE_ID NVARCHAR(30)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_EXFACTORY_PLAN_CU_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	--변수 설정
	DECLARE @CALL_SEQUENCE_ID NUMERIC(18,0) = @P_CALL_SEQUENCE_ID
	DECLARE @CATEGORY         NVARCHAR(30) = 'MOVING'
	DECLARE @COMPANY_ID       NVARCHAR(30)
	DECLARE @DIVISION_ID      NVARCHAR(30)
	DECLARE @SITE_ID          NVARCHAR(30)
	DECLARE @PLANT_ID	 	  NVARCHAR(30)
	DECLARE @FROM_PLAN_DATE   DATE
	DECLARE @USER_ID          NVARCHAR(35)
	DECLARE @FP_PLAN_ID		  NVARCHAR(60)
	DECLARE @LOCAL_TIME		  NVARCHAR(20)

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
		SELECT  @PLANT_ID       = MAX(CASE WHEN CONDITION_TYPE = 'PLANT_ID' THEN CONDITION_VALUE END)  -- : 작업 plant_id
			   ,@FROM_PLAN_DATE = MAX(CASE WHEN CONDITION_TYPE = 'FROM_PLAN_DATE' THEN FROM_DATE END)  -- : 전송 시작 일자
			   ,@USER_ID        = MAX(INSERT_ID)	
		FROM   FP_PROC_PARAMETER_H M   WITH(NOLOCK)
		WHERE  M.CALL_SEQUENCE   = @CALL_SEQUENCE_ID
		AND    M.CONDITION_TYPE IN ('PLANT_ID','FROM_PLAN_DATE')

		SELECT  @COMPANY_ID   = P.COMPANY_ID
			   ,@DIVISION_ID  = P.DIVISION_ID
			   ,@SITE_ID      = P.SITE_ID
		FROM   SCM_PLANT_M P   WITH(NOLOCK)
		WHERE  P.PLANT_ID   = @PLANT_ID

		-- 2021-05-13 kimcd 이력 형성 시작
		DELETE
		FROM   FP_CELL_MOVE_PLAN_MES_SEND_H
		WHERE  CATEGORY   = @CATEGORY
		AND	   PLANT_ID   = @PLANT_ID
		AND    PLAN_DATE >= @FROM_PLAN_DATE
		AND    ITEM_ID   IN (SELECT CONDITION_VALUE 
							 FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
							 WHERE  CALL_SEQUENCE  = @CALL_SEQUENCE_ID
							 AND    CONDITION_TYPE = 'ITEM_ID' )

		INSERT INTO FP_CELL_MOVE_PLAN_MES_SEND_H
			(  [CATEGORY]
			  ,[COMPANY_ID]
			  ,[DIVISION_ID]
			  ,[SITE_ID]
			  ,[PLANT_ID]
			  ,[ITEM_ID]
			  ,[PLAN_DATE]
			  ,[CELL_FACTORY_ID]
			  ,[PACK_FACTORY_ID]
			  ,[QTY]
			  ,[DESCRIPTION]
			  ,[INSERT_ID]
			  ,[INSERT_DTTM]
			  ,[UPDATE_ID]
			  ,[UPDATE_DTTM])
		SELECT [CATEGORY]
			  ,[COMPANY_ID]
			  ,[DIVISION_ID]
			  ,[SITE_ID]
			  ,[PLANT_ID]
			  ,[ITEM_ID]
			  ,[PLAN_DATE]
			  ,[CELL_FACTORY_ID]
			  ,[PACK_FACTORY_ID]
			  ,[QTY]
			  ,[DESCRIPTION]
			  ,[UPDATE_ID]
			  ,[UPDATE_DTTM]
			  ,@USER_ID
			  ,GETDATE()
		FROM   FP_CELL_MOVE_PLAN_H D   WITH(NOLOCK)
		WHERE  D.CATEGORY    = @CATEGORY
		AND	   D.COMPANY_ID  = @COMPANY_ID
		AND	   D.DIVISION_ID = @DIVISION_ID
		AND	   D.SITE_ID     = @SITE_ID
		AND	   D.PLANT_ID    = @PLANT_ID
		AND	   D.PLAN_DATE  >= @FROM_PLAN_DATE
		AND    D.ITEM_ID    IN (SELECT CONDITION_VALUE 
								FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
								WHERE  CALL_SEQUENCE  = @CALL_SEQUENCE_ID
								AND    CONDITION_TYPE = 'ITEM_ID' )
		-- 2021-05-13 kimcd 이력 형성 끝
 
		SET @LOCAL_TIME = REPLACE(REPLACE(REPLACE(CONVERT( NVARCHAR, DBO.FN_SITE_TIME( @SITE_ID ), 120), '-', ''), ':', ''), ' ', '');
		SET @FP_PLAN_ID = @PLANT_ID + '-' + @LOCAL_TIME

		INSERT INTO SY_XIF_MES_EXFACTORY_PLAN_CU_S (
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
				,[FROM_FACTORY_ID]
				,[TO_FACTORY_ID]
				,[SHIP_DATE]
				,[SHIP_WEEK]
				,[SHIP_QTY]
				,[CHANGE_FLAG]
				,[ACCUM_DATE]
				,[ACCUM_COUNT]
				,[CREATE_PSN_ID]
				,[CREATE_DATE]
				,[UPDATE_PSN_ID]
				,[UPDATE_DATE]
				,[ATTR_01]
				,[ATTR_02]
				,[ATTR_03]
				,[ATTR_04]
				,[ATTR_05]
				,[ATTR_06]
				,[ATTR_07]
				,[ATTR_08]
				,[ATTR_09]
				,[ATTR_10]
		)
		SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
						+ REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ]))
						+ CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)	AS IF_SEQ
				,'S'			-- [IF_TYPE]
				,'OFP0'+'_'+ D.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN_CU' -- [IF_ID]
				,GETDATE()	-- [IF_INS_DATE]
				,'N'			-- [IF_FLAG]
				,NULL			-- [IF_SND_DATE]
				,@FP_PLAN_ID
				,D.[PLANT_ID]
				,D.[SHOP_GROUP_ID]
				,D.[ITEM_ID]
				,D.[CELL_FACTORY_ID] -- [FROM_FACTORY_ID]
				,D.[PACK_FACTORY_ID] -- [TO_FACTORY_ID]
				,CONVERT(NVARCHAR(8), D.[PLAN_DATE], 112)  -- [SHIP_DATE]
				,D.[SHIP_WEEK]
				,D.[QTY]   -- [SHIP_QTY]
				,CASE WHEN D.[SHIP_QTY] IS NULL OR D.[SHIP_QTY] != D.[QTY] THEN 'Y' ELSE 'N' END -- [CHANGE_FLAG]
				,@LOCAL_TIME  -- [ACCUM_DATE]
				,COUNT(*) OVER(PARTITION BY MES_SOURCE_GROUP, D.PLANT_ID)
				,D.UPDATE_ID   -- [CREATE_PSN_ID]
				,D.UPDATE_DTTM -- [CREATE_DATE]
				,@USER_ID      -- [UPDATE_PSN_ID]
				,GETDATE()     -- [UPDATE_DATE]
				,'Etc' -- [ATTR_01] TRANSPORT_MODE 
				,'D'   -- [ATTR_02] MARKET 
				,NULL -- [ATTR_03]
				,NULL -- [ATTR_04]
				,NULL -- [ATTR_05]
				,NULL -- [ATTR_06]
				,NULL -- [ATTR_07]
				,NULL -- [ATTR_08]
				,NULL -- [ATTR_09]
				,NULL -- [ATTR_10]
		FROM  ( SELECT D.[PLANT_ID]
						,F.[MES_SOURCE_GROUP]
						,F.[SHOP_GROUP_ID]
						,D.[ITEM_ID]
						,D.[PLAN_DATE]
						,D.[SHIP_WEEK]
						,D.[CELL_FACTORY_ID]
						,D.[PACK_FACTORY_ID]
						,D.[QTY]   -- [SHIP_QTY]
						,(SELECT TOP 1 S.[SHIP_QTY]
						FROM SY_XIF_MES_EXFACTORY_PLAN_CU_S S WITH(NOLOCK)
						WHERE S.[IF_ID]                   = 'OFP0'+'_'+ F.MES_SOURCE_GROUP +'_'+'FP_EXFACTORY_PLAN_CU'
						AND S.[PLANT_ID]                  = D.[PLANT_ID]
						AND ISNULL(S.[SHOP_GROUP_ID],'-') = ISNULL(F.[SHOP_GROUP_ID],'-')
						AND S.[ITEM_ID]                   = D.[ITEM_ID]
						AND S.[FROM_FACTORY_ID]           = D.[CELL_FACTORY_ID]
						AND S.[TO_FACTORY_ID]             = D.[PACK_FACTORY_ID]
						AND S.[SHIP_DATE]                 = CONVERT(NVARCHAR(8), D.[PLAN_DATE], 112)
						ORDER BY S.[PLAN_ID] DESC	) AS [SHIP_QTY]
						,D.INSERT_ID
						,D.INSERT_DTTM
						,D.UPDATE_ID
						,D.UPDATE_DTTM
				FROM   ( SELECT D.[PLANT_ID]
								,D.[ITEM_ID]
								,D.[PLAN_DATE]
								,D.[CELL_FACTORY_ID]
								,D.[PACK_FACTORY_ID]
								,D.[QTY]
								,(SELECT TOP 1 W.WEEK
									FROM   [DBO].SCM_SYS_CALENDAR_M W WITH(NOLOCK)
									WHERE  W.DATE_ID = D.[PLAN_DATE]) AS [SHIP_WEEK]
								,D.INSERT_ID
								,D.INSERT_DTTM
								,D.UPDATE_ID
								,D.UPDATE_DTTM
							FROM   FP_CELL_MOVE_PLAN_H D   WITH(NOLOCK)
							WHERE  D.CATEGORY    = @CATEGORY
							AND	D.COMPANY_ID  = @COMPANY_ID
							AND	D.DIVISION_ID = @DIVISION_ID
							AND	D.SITE_ID     = @SITE_ID
							AND	D.PLANT_ID    = @PLANT_ID
							AND	D.PLAN_DATE  >= @FROM_PLAN_DATE
							AND    D.ITEM_ID    IN (SELECT CONDITION_VALUE 
													FROM   FP_PROC_PARAMETER_H    WITH(NOLOCK)
													WHERE  CALL_SEQUENCE  = @CALL_SEQUENCE_ID
													AND    CONDITION_TYPE = 'ITEM_ID' )
						) D
						-- 2021-06-16 kimis ESNJ 6동 GMES DB 분리에 따른 변경
            -- 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
            -- 라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
						--,( SELECT DISTINCT F.PLANT_ID, F.MES_SOURCE_GROUP, F.SHOP_GROUP_ID
						--	FROM  SCM_FACTORY_M  F   WITH(NOLOCK) 
						--	WHERE F.SHOP_GROUP_ID IN ('A','P')
						--	AND   F.MES_SOURCE_GROUP IS NOT NULL
						--	) F
						,( SELECT DISTINCT F.PLANT_ID, ISNULL(L.MES_SOURCE_GROUP, F.MES_SOURCE_GROUP) AS MES_SOURCE_GROUP, F.SHOP_GROUP_ID
							   FROM SCM_FACTORY_M  F   WITH(NOLOCK) 
							   LEFT OUTER JOIN SCM_MMD_LINE_M L 
							     ON L.COMPANY_ID  = F.COMPANY_ID
									AND L.DIVISION_ID = F.DIVISION_ID
									AND L.SITE_ID     = F.SITE_ID
									AND L.PLANT_ID    = F.PLANT_ID
									AND L.FACTORY_ID  = F.FACTORY_ID
									AND L.MES_SOURCE_GROUP IS NOT NULL
									WHERE F.SHOP_GROUP_ID IN ('A','P')
									AND   F.MES_SOURCE_GROUP IS NOT NULL
							) F

				WHERE  F.PLANT_ID       = D.PLANT_ID ) D

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
