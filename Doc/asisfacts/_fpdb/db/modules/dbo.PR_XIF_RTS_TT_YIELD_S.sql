
CREATE PROCEDURE [dbo].[PR_XIF_RTS_TT_YIELD_S]
-- ================================================================================================
-- Program ID          : FP02493
-- Program Name        : XIF_RTS_TT_YIELD_S
-- Param               :
-- Batch Period        : 10 Minutes
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : RTS
-- Source Table        : SCM_TACT_TIME_M OR SCM_YIELD_M
-- Destination Table   : XIF_RTS_TT_YIELD_S
--
-- Create Date		   : 2019.09.16
-- Update Date		   : 2019.09.24 kimcd 1.1

-- Author              : kimcd
-- Version             : 2019-09-16 1.0 kimcd 최초 개발
--                       2019-09-24 1.1 kimcd E2000,A5000, A7000 공정 전송
--                                            RTS SOURCE GROUP에 값이 있는 경우만 전송 - SCM_FACTORY_M.RTS_SOURCE_GROUP 이관 필요
--                                            비활성화된 정보도 disable하여 전송
--                                            당월, 차월만 전송 ATTR_01
-- ================================================================================================
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_RTS_TT_YIELD_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME    = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	
	-- ================================================
    -- Declare start
	-- ================================================

	DECLARE CUR_TACT_YIELD CURSOR FOR -- 2019-09-24 kimcd 전체 재구성
		SELECT TT.COMPANY_ID
			 , TT.DIVISION_ID
			 , TT.SITE_ID
			 , TT.PLANT_ID
			 , TT.ITEM_ID
			 , TT.FACTORY_ID
			 , TT.OPERATION_ID
			 , E.MES_LINE_ID
			 , TT.LINE_ID AS FP_LINE_ID
			 , TT.MONTH
			 , E.EQUIPMENT_ID
			 , CASE WHEN TT.DAILY_CAPA > 0 THEN
						(24*60*60)/TT.DAILY_CAPA
					WHEN TT.TACT_TIME > 0 THEN
						TT.TACT_TIME
			   ELSE 0 END * COUNT (*) OVER (PARTITION BY TT.FACTORY_ID, TT.LINE_ID, TT.OPERATION_ID, TT.ITEM_ID, TT.ELECTRODE_TYPE, TT.MONTH) AS TACT_TIME
			 , 'SEC' AS TACT_TIME_UOM
			 , ISNULL((SELECT CASE WHEN Y.YIELD > 1 OR Y.YIELD = 0 THEN 1 ELSE Y.YIELD END
					   FROM   SCM_YIELD_M Y WITH(NOLOCK)
					   WHERE  Y.COMPANY_ID   = TT.COMPANY_ID
					   AND    Y.DIVISION_ID  = TT.DIVISION_ID
					   AND    Y.SITE_ID      = TT.SITE_ID
					   AND    Y.PLANT_ID     = TT.PLANT_ID
					   AND    Y.FACTORY_ID   = TT.FACTORY_ID
					   AND    Y.LINE_ID      = TT.LINE_ID
					   AND    Y.OPERATION_ID = TT.OPERATION_ID
					   AND    Y.ITEM_ID      = TT.ITEM_ID
					   AND    Y.MONTH        = TT.MONTH ),1) AS YIELD
			 , CASE WHEN (ISNULL(TT.TACT_TIME,0) = 0 AND ISNULL(TT.DAILY_CAPA,0) = 0 ) OR TT.PRIORITY IN  ('0','9') THEN 'N' ELSE 'Y' END AS ACTIVE_YN
			 , TT.RTS_SOURCE_GROUP
		FROM   ( SELECT TT.COMPANY_ID
					   ,TT.DIVISION_ID
					   ,TT.SITE_ID
					   ,TT.PLANT_ID
					   ,TT.FACTORY_ID
					   ,TT.LINE_ID
					   ,TT.OPERATION_ID
					   ,TT.ITEM_ID
					   ,TT.ELECTRODE_TYPE
					   ,TT.TACT_TIME
					   ,TT.DAILY_CAPA
					   ,TT.MONTH
					   ,ILA.LANE_QTY
					   ,TT.UPDATE_TIME
					   ,ILA.PRIORITY
					   ,F.RTS_SOURCE_GROUP
				 FROM   SCM_TACT_TIME_M   TT WITH(NOLOCK),
						SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK),
						( SELECT F.FACTORY_ID
						        ,F.RTS_SOURCE_GROUP
								,DBO.[FN_SITE_TIME] (F.SITE_ID) AS LOCAL_TIME
						  FROM   SCM_FACTORY_M F WITH(NOLOCK)
						  WHERE  F.RTS_SOURCE_GROUP IS NOT NULL ) F
				 WHERE  TT.COMPANY_ID   = ILA.COMPANY_ID
				 AND    TT.DIVISION_ID  = ILA.DIVISION_ID
				 AND    TT.SITE_ID      = ILA.SITE_ID
				 AND    TT.PLANT_ID     = ILA.PLANT_ID
				 AND    TT.FACTORY_ID   = ILA.FACTORY_ID
				 AND    TT.LINE_ID      = ILA.LINE_ID
				 AND    TT.OPERATION_ID = ILA.OPERATION_ID
				 AND    TT.ITEM_ID      = ILA.ITEM_ID
				 AND    TT.MONTH        = ILA.MONTH
				 AND    TT.ELECTRODE_TYPE = ILA.ELECTRODE_TYPE
				 AND    TT.FACTORY_ID   = F.FACTORY_ID
				 AND    ILA.FACTORY_ID  = F.FACTORY_ID
				 AND    TT.MONTH        IN (CONVERT(NVARCHAR(6), F.LOCAL_TIME, 112), CONVERT(NVARCHAR(6), DATEADD(M,1, F.LOCAL_TIME), 112))
				 AND    ILA.MONTH       IN (CONVERT(NVARCHAR(6), F.LOCAL_TIME, 112), CONVERT(NVARCHAR(6), DATEADD(M,1, F.LOCAL_TIME), 112))
				 AND    TT.OPERATION_ID IN (SELECT SLV.SEGMENT1
											FROM   SCM_SYS_LOOKUP_VALUE SLV(NOLOCK)
											WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_OPERATION'
											AND    SLV.ATTRIBUTE9       = 'Y')
				 AND    ILA.OPERATION_ID IN (SELECT SLV.SEGMENT1
											 FROM   SCM_SYS_LOOKUP_VALUE SLV(NOLOCK)
											 WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_OPERATION'
											 AND    SLV.ATTRIBUTE9       = 'Y')
				 AND    ( TT.UPDATE_TIME >= DATEADD(HOUR, -1, GETDATE()) OR ILA.UPDATE_TIME >= DATEADD(HOUR, -1, GETDATE()))
			     UNION
				 SELECT TT.COMPANY_ID
					   ,TT.DIVISION_ID
					   ,TT.SITE_ID
					   ,TT.PLANT_ID
					   ,TT.FACTORY_ID
					   ,TT.LINE_ID
					   ,TT.OPERATION_ID
					   ,TT.ITEM_ID
					   ,TT.ELECTRODE_TYPE
					   ,TT.TACT_TIME
					   ,TT.DAILY_CAPA
					   ,TT.MONTH
					   ,ILA.LANE_QTY
					   ,TT.UPDATE_TIME
					   ,ILA.PRIORITY
					   ,A.RTS_SOURCE_GROUP
				 FROM   SCM_TACT_TIME_M   TT WITH(NOLOCK),
						SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK),
						( SELECT Y.COMPANY_ID
								,Y.DIVISION_ID
								,Y.SITE_ID
								,Y.PLANT_ID
								,Y.FACTORY_ID
								,Y.LINE_ID
								,Y.OPERATION_ID
								,Y.ITEM_ID
								,Y.MONTH
								,F.RTS_SOURCE_GROUP
						  FROM   SCM_YIELD_M Y WITH(NOLOCK),
								( SELECT F.FACTORY_ID
										,F.RTS_SOURCE_GROUP
										,DBO.[FN_SITE_TIME] (F.SITE_ID) AS LOCAL_TIME
								  FROM   SCM_FACTORY_M F WITH(NOLOCK)
								  WHERE  F.RTS_SOURCE_GROUP IS NOT NULL ) F
						  WHERE  Y.FACTORY_ID = F.FACTORY_ID
						  AND    Y.OPERATION_ID IN (SELECT SLV.SEGMENT1
													FROM   SCM_SYS_LOOKUP_VALUE SLV(NOLOCK)
													WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_OPERATION'
													AND    SLV.ATTRIBUTE9       = 'Y')
						  AND    Y.MONTH        IN (CONVERT(NVARCHAR(6), F.LOCAL_TIME, 112), CONVERT(NVARCHAR(6), DATEADD(M,1, F.LOCAL_TIME), 112))
						  AND    Y.UPDATE_TIME >= DATEADD(HOUR, -1, GETDATE())) A
				 WHERE  TT.COMPANY_ID   = ILA.COMPANY_ID
				 AND    TT.DIVISION_ID  = ILA.DIVISION_ID
				 AND    TT.SITE_ID      = ILA.SITE_ID
				 AND    TT.PLANT_ID     = ILA.PLANT_ID
				 AND    TT.FACTORY_ID   = ILA.FACTORY_ID
				 AND    TT.LINE_ID      = ILA.LINE_ID
				 AND    TT.OPERATION_ID = ILA.OPERATION_ID
				 AND    TT.ITEM_ID      = ILA.ITEM_ID
				 AND    TT.MONTH        = ILA.MONTH
				 AND    TT.ELECTRODE_TYPE = ILA.ELECTRODE_TYPE
				 AND    TT.COMPANY_ID   = A.COMPANY_ID
				 AND    TT.DIVISION_ID  = A.DIVISION_ID
				 AND    TT.SITE_ID      = A.SITE_ID
				 AND 	TT.PLANT_ID     = A.PLANT_ID
				 AND    TT.FACTORY_ID   = A.FACTORY_ID
				 AND	TT.LINE_ID      = A.LINE_ID
				 AND	TT.OPERATION_ID = A.OPERATION_ID
				 AND	TT.ITEM_ID      = A.ITEM_ID
				 AND    TT.MONTH        = A.MONTH ) TT,
			   SCM_ITEM_M      I WITH(NOLOCK),
			   SCM_EQUIPMENT_M E WITH(NOLOCK)
		WHERE  TT.COMPANY_ID     = I.COMPANY_ID
		AND    TT.DIVISION_ID    = I.DIVISION_ID
		AND    TT.SITE_ID        = I.SITE_ID
		AND    TT.ITEM_ID        = I.ITEM_ID
		AND    I.ACTIVE_FLAG     = 'Y'
		AND    TT.COMPANY_ID     = E.COMPANY_ID
		AND    TT.DIVISION_ID    = E.DIVISION_ID
		AND    TT.SITE_ID        = E.SITE_ID
		AND    TT.PLANT_ID       = E.PLANT_ID
		AND    TT.FACTORY_ID     = E.FACTORY_ID
		AND    TT.LINE_ID        = E.LINE_ID
		AND    TT.OPERATION_ID   = E.OPERATION_ID
		AND    TT.ELECTRODE_TYPE = E.ELECTRODE_TYPE
		AND    E.EQUIPMENT_TYPE  = 'M'
		AND    E.ACTIVE_FLAG     = 'Y'
		UNION ALL
		SELECT TT.COMPANY_ID
			 , TT.DIVISION_ID
			 , TT.SITE_ID
			 , TT.PLANT_ID
			 , TT.ITEM_ID
			 , TT.FACTORY_ID
			 , TT.OPERATION_ID
			 , E.MES_LINE_ID
			 , TT.LINE_ID AS FP_LINE_ID
			 , TT.MONTH
			 , E.EQUIPMENT_ID
			 , 0 AS TACT_TIME		
			 , 'SEC' AS TACT_TIME_UOM
			 , 1 AS YIELD
			 , 'N' AS ACTIVE_YN
			 , TT.RTS_SOURCE_GROUP
		FROM   ( SELECT ILA.COMPANY_ID
					   ,ILA.DIVISION_ID
					   ,ILA.SITE_ID
					   ,ILA.PLANT_ID
					   ,ILA.FACTORY_ID
					   ,ILA.LINE_ID
					   ,ILA.OPERATION_ID
					   ,ILA.ITEM_ID
					   ,ILA.ELECTRODE_TYPE
					   ,ILA.MONTH
					   ,ILA.LANE_QTY
					   ,ILA.UPDATE_TIME
					   ,ILA.PRIORITY
					   ,F.RTS_SOURCE_GROUP
				 FROM   HIS_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK),
						( SELECT F.FACTORY_ID
						        ,F.RTS_SOURCE_GROUP
								,DBO.[FN_SITE_TIME] (F.SITE_ID) AS LOCAL_TIME
						  FROM   SCM_FACTORY_M F WITH(NOLOCK)
						  WHERE  F.RTS_SOURCE_GROUP IS NOT NULL ) F
				 WHERE  ILA.FACTORY_ID  = F.FACTORY_ID
				 AND    ILA.MONTH       IN (CONVERT(NVARCHAR(6), F.LOCAL_TIME, 112), CONVERT(NVARCHAR(6), DATEADD(M,1, F.LOCAL_TIME), 112))
				 AND    ILA.OPERATION_ID IN (SELECT SLV.SEGMENT1
											 FROM   SCM_SYS_LOOKUP_VALUE SLV(NOLOCK)
											 WHERE  SLV.LOOKUP_TYPE_CODE = 'FP_OPERATION'
											 AND    SLV.ATTRIBUTE9       = 'Y')
				 AND    ILA.JOB_TIME >= DATEADD(HOUR, -1, GETDATE())
				 AND    ILA.JOB_TYPE    = 'DELETE'
				 AND    NOT EXISTS ( SELECT 1
									 FROM   SCM_ITEM_LINE_ASSIGN_M TT WITH(NOLOCK)
									 WHERE  TT.COMPANY_ID   = ILA.COMPANY_ID
									 AND    TT.DIVISION_ID  = ILA.DIVISION_ID
									 AND    TT.SITE_ID      = ILA.SITE_ID
									 AND    TT.PLANT_ID     = ILA.PLANT_ID
									 AND    TT.FACTORY_ID   = ILA.FACTORY_ID
									 AND    TT.LINE_ID      = ILA.LINE_ID
									 AND    TT.OPERATION_ID = ILA.OPERATION_ID
									 AND    TT.ITEM_ID      = ILA.ITEM_ID
									 AND    TT.MONTH        = ILA.MONTH
									 AND    TT.ELECTRODE_TYPE = ILA.ELECTRODE_TYPE ) 
											) TT,
			   SCM_ITEM_M      I WITH(NOLOCK),
			   SCM_EQUIPMENT_M E WITH(NOLOCK)
		WHERE  TT.COMPANY_ID     = I.COMPANY_ID
		AND    TT.DIVISION_ID    = I.DIVISION_ID
		AND    TT.SITE_ID        = I.SITE_ID
		AND    TT.ITEM_ID        = I.ITEM_ID
		AND    I.ACTIVE_FLAG     = 'Y'
		AND    TT.COMPANY_ID     = E.COMPANY_ID
		AND    TT.DIVISION_ID    = E.DIVISION_ID
		AND    TT.SITE_ID        = E.SITE_ID
		AND    TT.PLANT_ID       = E.PLANT_ID
		AND    TT.FACTORY_ID     = E.FACTORY_ID
		AND    TT.LINE_ID        = E.LINE_ID
		AND    TT.OPERATION_ID   = E.OPERATION_ID
		AND    TT.ELECTRODE_TYPE = E.ELECTRODE_TYPE
		AND    E.EQUIPMENT_TYPE  = 'M'
		AND    E.ACTIVE_FLAG     = 'Y';

	SET @ROWCOUNT = @@ROWCOUNT

	DECLARE @COMPANY_ID     NVARCHAR(30);
	DECLARE @DIVISION_ID	NVARCHAR(30);
	DECLARE @SITE_ID 		NVARCHAR(30);
	DECLARE @PLANT_ID		NVARCHAR(30);
	DECLARE @ITEM_ID		NVARCHAR(50);
	DECLARE @FACTORY_ID		NVARCHAR(30);
	DECLARE @OPERATION_ID	NVARCHAR(30);
	DECLARE @MES_LINE_ID	NVARCHAR(50);
	DECLARE @FP_LINE_ID	    NVARCHAR(50);
	DECLARE @MONTH   	    NVARCHAR(50);    -- 2019-09-24 kimcd add
	DECLARE @EQUIPMENT_ID	NVARCHAR(30);
	DECLARE @TACT_TIME		NUMERIC(20,10);
	DECLARE @TACT_TIME_UOM	NVARCHAR(10);
	DECLARE @YIELD	        NUMERIC(20,10);
	DECLARE @ACTIVE_YN      NVARCHAR(1);
	DECLARE @RTS_SOURCE_GROUP NVARCHAR(30);  -- 2019-09-24 kimcd add


	
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

		SET @v_temp1 = 'STEP DELETE [dbo].[SY_XIF_RTS_TT_YIELD_S]'
		DELETE FROM [DBO].[SY_XIF_RTS_TT_YIELD_S]
		WHERE  IF_INS_DATE <= DATEADD(D, -10, GETDATE());

		SET @v_temp1 = 'STEP OPEN CURSOR'
		OPEN CUR_TACT_YIELD

        FETCH NEXT FROM CUR_TACT_YIELD INTO @COMPANY_ID
	                                      , @DIVISION_ID
	                                      , @SITE_ID
	                                      , @PLANT_ID
	                                      , @ITEM_ID
	                                      , @FACTORY_ID
	                                      , @OPERATION_ID
	                                      , @MES_LINE_ID
	                                      , @FP_LINE_ID
										  , @MONTH          -- 2019-09-24 kimcd add
	                                      , @EQUIPMENT_ID
	                                      , @TACT_TIME
	                                      , @TACT_TIME_UOM
	                                      , @YIELD
	                                      , @ACTIVE_YN
										  , @RTS_SOURCE_GROUP; -- 2019-09-24 kimcd add

        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
			BEGIN
				INSERT INTO [DBO].[SY_XIF_RTS_TT_YIELD_S]
						([IF_SEQ]
						,[IF_TYPE]
						,[IF_ID]
						,[IF_INS_DATE]
						,[IF_FLAG]
						,[IF_SND_DATE]
						,[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[ITEM_ID]
						,[FACTORY_ID]
						,[OPERATION_ID]
						,[LINE_ID]
						,[FP_LINE_ID]
						,[EQUIPMENT_ID]
						,[TACT_TIME]
						,[TACT_TIME_UOM]
						,[YIELD]
						,[ACTIVE_YN]
						,[ATTR_01]) -- 2019-09-24 kimcd MONTH add
				 VALUES ( 
						'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_RTS_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_RTS_SEND_SEQ] AS NVARCHAR)
						,'S'
						,'OFP0_' + @RTS_SOURCE_GROUP + '_FP_TT_YIELD_RTS'	--2019-09-19 PIYONG CHANGE
						,GETDATE()
						,'N'
						,GETDATE()
	                    , @COMPANY_ID
	                    , @DIVISION_ID
	                    , @SITE_ID
	                    , @PLANT_ID
	                    , @ITEM_ID
	                    , @FACTORY_ID
	                    , @OPERATION_ID
	                    , @MES_LINE_ID
	                    , @FP_LINE_ID
	                    , @EQUIPMENT_ID
	                    , @TACT_TIME
	                    , @TACT_TIME_UOM
	                    , @YIELD
	                    , @ACTIVE_YN
						, @MONTH); -- 2019-09-24 kimcd [ATTR_01] add

			FETCH NEXT FROM CUR_TACT_YIELD INTO @COMPANY_ID
											  , @DIVISION_ID
											  , @SITE_ID
											  , @PLANT_ID
											  , @ITEM_ID
											  , @FACTORY_ID
											  , @OPERATION_ID
											  , @MES_LINE_ID
											  , @FP_LINE_ID
											  , @MONTH            -- 2019-09-24 kimcd add
											  , @EQUIPMENT_ID
											  , @TACT_TIME
											  , @TACT_TIME_UOM
											  , @YIELD
											  , @ACTIVE_YN
											  , @RTS_SOURCE_GROUP -- 2019-09-24 kimcd add
											  ;

		END;  -- WHILE @@FETCH_STATUS = 0
        CLOSE CUR_TACT_YIELD;
        DEALLOCATE CUR_TACT_YIELD;   -- 메모리 해제

		SET @v_temp1 = 'STEP END PROCEDURE'
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp1, NULL, @v_descr, @sysdate

	END CATCH

END;

