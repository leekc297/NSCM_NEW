
CREATE PROCEDURE [dbo].[PR_SCM_ELEC_POST_RT_RESULT]
-- ================================================================================================
-- Program ID          : PR_SCM_ENGINE_RUN_PL_E_POST 형태의 전극 후 공정 계획 작업에서 호출됨
-- Program Name        : PR_SCM_ELEC_POST_RT_RESULT
-- Param               :
-- Batch Period        : 30 Minute
-- Description         : 전극 후 공정 계획에 당일 실적 갱신
--     정보 구분       : 12-NOTCHING_RESULT
--                       22-SLITTING_RESULT
--                       32-ROLL_PRESS_RESULT
--                       42-COATING_RESULT
--     참조            : PR_SCM_ELECTRODE_POST_PLAN_A
--                       
-- Source System       : FP Electrode Post
-- Destination System  : FP Electrode Post
-- Source Table        : SCM_MES_RT_WIP_HISTORY_H
-- Destination Table   : FP_ELECTRODE_POST_PLAN_H
--
-- Create Date		   : 2019-08-27
-- Update Date         : 2019-09-03

-- Author              : kimcd
-- Version             : 1.0 2019-08-27 kimcd 최초 형성
--                       1.1 2019-09-03 kimcd 노칭 실적 취합에 group by 추가
-- ================================================================================================
@P_MASTER_ID      NVARCHAR(20) = '-', 
@P_PLAN_ID        NVARCHAR(40) = '-',
@P_INSTANCE_DATE  DATE
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_ELEC_POST_RT_RESULT'
	DECLARE @v_table_name     nvarchar(100)
	DECLARE @v_message        nvarchar(250)
	DECLARE @v_descr          nvarchar(250)
	DECLARE @n_row_count      Integer  = 0
	DECLARE @n_log_count      Integer  = 0
	DECLARE @v_log_code       nvarchar(10)
	DECLARE @sysdate          DATETIME2 = GETDATE()
	DECLARE @v_temp1          nvarchar(1000)
	DECLARE @v_temp2          nvarchar(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE   @V_MASTER_ID        nvarchar(30) = @P_MASTER_ID
	DECLARE   @V_PLAN_ID          nvarchar(30) = @P_PLAN_ID 
	DECLARE   @V_INSTANCE_DATE    DATE         = @P_INSTANCE_DATE
	DECLARE   @V_TO_DATE          DATE         = DATEADD( D, 1, @P_INSTANCE_DATE)
	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	SET @n_log_count = @n_log_count + 1
	EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', @v_descr

	BEGIN TRY				

		--LOG 생성
		SET @v_message = 'INSTANCE_DATE : ' + CONVERT(nvarchar, @V_INSTANCE_DATE, 112)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		SET @v_table_name = 'FP_ELECTRODE_POST_PLAN_H NOTCHING'
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE NOTCHING', @n_log_count, null, @v_message, null
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		---- 12- NOTCHING RESULT ---- 
		MERGE INTO  FP_ELECTRODE_POST_PLAN_H  U
		USING ( SELECT  A.EPOST_INSTANCE_ID  
					  , A.FP_PLAN_ID 
					  , A.EPOST_COMPANY_ID 
					  , A.EPOST_DIVISION_ID 
					  , A.EPOST_SITE_ID 
					  , A.EPOST_PLANT_ID 
					  , A.EPOST_FACTORY_ID 
					  , A.ITEM_ID 
					  , A.NP_ITEM_ID 
					  , '12-NOTCHING_RESULT'   AS  CATEGORY 
					  , A.PLAN_DATE            AS  PLAN_DATE 
					  , A.PLAN_IN_QTY     AS IN_QTY
					  , A.PLAN_QTY        AS OUT_QTY
					  , CASE WHEN A.ITEM_UOM = 'EA' THEN A.IN_PC_QTY / CELL_M ELSE A.IN_PC_QTY END     AS IN_PC_QTY
					  , CASE WHEN A.ITEM_UOM = 'EA' THEN A.OUT_PC_QTY / CELL_M ELSE A.OUT_PC_QTY END   AS OUT_PC_QTY
					  , CASE WHEN A.ITEM_UOM = 'EA' THEN A.IN_PC_QTY / CELL_M ELSE A.IN_PC_QTY END / LANE_NUMBER   AS IN_JR_QTY
					  , CASE WHEN A.ITEM_UOM = 'EA' THEN A.OUT_PC_QTY / CELL_M ELSE A.OUT_PC_QTY END / LANE_NUMBER AS OUT_JR_QTY
					  , A.IN_PC_QTY / REQ_QTY   AS IN_CELL_QTY
					  , A.OUT_PC_QTY / REQ_QTY  AS OUT_CELL_QTY
					  , @v_proc_name  AS INSERT_ID
					  , GETDATE() AS INSERT_TIME 
					  , @v_proc_name   AS UPDATE_ID
					  , GETDATE() AS UPDATE_TIME 
				FROM   (SELECT  X.EPOST_INSTANCE_ID, @V_PLAN_ID AS FP_PLAN_ID, X.COMPANY_ID AS EPOST_COMPANY_ID, X.DIVISION_ID AS EPOST_DIVISION_ID, X.SITE_ID AS EPOST_SITE_ID
								,X.PLANT_ID AS EPOST_PLANT_ID, X.EPOST_FACTORY_ID, BOM.CHILD_ITEM_ID AS ITEM_ID, MWH.PRODID AS NP_ITEM_ID, MWH.CALDATE AS PLAN_DATE
								,SUM(MWH.ACTUAL_QTY)      AS PLAN_IN_QTY
								,SUM(MWH.ACTUAL_GOOD_QTY) AS PLAN_QTY
								,SUM(MWH.ACTUAL_QTY) * MAX(BOM.CHILD_QTY / BOM.PARENT_QTY) AS IN_PC_QTY
								,SUM(MWH.ACTUAL_GOOD_QTY) * MAX(BOM.CHILD_QTY / BOM.PARENT_QTY) AS OUT_PC_QTY
								,[dbo].[FN_GET_REQ_QTY_MODEL]('-', SI.APPLIED_MODEL, BOM.CHILD_ITEM_ID,@V_INSTANCE_DATE) AS REQ_QTY
								,(SELECT MAX(LANE_QTY)
								  FROM   SCM_ITEM_LANE_M L WITH(NOLOCK)
								  WHERE  L.COMPANY_ID  = X.COMPANY_ID
								  AND    L.DIVISION_ID = X.DIVISION_ID
								  AND    L.SITE_ID     = X.SITE_ID
								  AND    L.PLANT_ID    = X.PLANT_ID
								  AND    L.FACTORY_ID  = X.EPOST_FACTORY_ID
								  AND    L.ITEM_ID     = BOM.CHILD_ITEM_ID
								  AND    L.ACTIVE_FLAG = 'Y' ) AS LANE_NUMBER
								,CASE WHEN MAX(SI.ITEM_UOM) = 'EA' THEN
										ISNULL(
												(
													SELECT  TOP 1 VALUE AS CELL_M
													FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													WHERE  C.MAX_VER_FLAG = 'Y'
													AND    ISNULL(C.VALUE, 0) > 0
													AND    C.CATEGORY     = 'Pancake (cell/m)'
													AND    C.COMPANY_ID   = X.COMPANY_ID
													AND    C.DIVISION_ID  = X.DIVISION_ID
													AND    C.SITE_ID      = X.SITE_ID
													AND    C.PLANT_ID     = X.PLANT_ID
													AND    C.FACTORY_ID   = X.EPOST_FACTORY_ID
													AND    C.OPERATION    = 'E2000'
													AND    C.ITEM_ID      = BOM.CHILD_ITEM_ID
													ORDER BY CASE WHEN C.VERSION_TYPE = 'TEST' THEN 2 ELSE 1 END
															,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
															,C.MODEL_ID
															,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
															,CASE WHEN C.PROD_VERSION_TYPE = 'WIDE' THEN 2
																  WHEN C.PROD_VERSION_TYPE = 'GENERAL' THEN 3
																  ELSE 4
																  END
												)
												, (
													SELECT TOP 1 VALUE AS CELL_M
													FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													WHERE  C.MAX_VER_FLAG = 'Y'
													AND    ISNULL(C.VALUE, 0) > 0
													AND    C.CATEGORY     = 'Pancake (cell/m)'
													AND    C.OPERATION    = 'E2000'
													AND    C.ITEM_ID      = BOM.CHILD_ITEM_ID
													ORDER BY CASE WHEN VERSION_TYPE = 'TEST' THEN 2 ELSE 1 END
															,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
															,C.MODEL_ID
															,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
															,CASE WHEN C.PROD_VERSION_TYPE = 'WIDE' THEN 2
																  WHEN C.PROD_VERSION_TYPE = 'GENERAL' THEN 3
																  ELSE 4
																  END
															,C.VALUE
												) 
										)
								 END  AS CELL_M
								,MAX(SI.ITEM_UOM) AS ITEM_UOM -- 2019-09-04 kimcd group by 추가에 따른 컬럼 조정
						FROM   (SELECT  MAX(F.COMPANY_ID)   AS COMPANY_ID
										,MAX(F.DIVISION_ID)  AS DIVISION_ID
										,MAX(F.SITE_ID)      AS SITE_ID
										,MAX(F.PLANT_ID)     AS PLANT_ID
										,MWH.FACTORY_ID
										,CONVERT(DATE,MWH.CALDATE) AS CALDATE
										,MWH.PRODID
										,MWH.PROCID
										,ISNULL( SUM(ISNULL(MWH.WIPQTY2_ENGINE,0))
												+ SUM(ISNULL(MWH.CNFM_DFCT_QTY2,0))
												+ SUM(ISNULL(MWH.CNFM_LOSS_QTY2,0)) 
												+ SUM(ISNULL(MWH.CNFM_PRDT_REQ_QTY2,0))
												+ SUM(ISNULL(CONVERT(NUMERIC(14,3), MWH.SCRAP_QTY),0))
											,0)											               		AS ACTUAL_QTY
										,ISNULL(SUM(MWH.WIPQTY2_ENGINE),0)                    				AS ACTUAL_GOOD_QTY
								FROM    SCM_MES_RT_WIP_HISTORY_H MWH  WITH(NOLOCK)
									INNER JOIN ( SELECT	F.FACTORY_ID
													, MAX(F.COMPANY_ID)   AS COMPANY_ID
													, MAX(F.DIVISION_ID)  AS DIVISION_ID
													, MAX(F.SITE_ID)      AS SITE_ID
													, MAX(F.PLANT_ID)     AS PLANT_ID
												FROM	SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK),
													SCM_FACTORY_M        F  WITH(NOLOCK)
												WHERE	LV.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
												AND	LV.ACTIVE_FLAG	    = 'Y'
												AND	LV.SEGMENT1		    = @V_MASTER_ID
												AND	LV.SEGMENT4		    = F.FACTORY_ID
												AND	F.ACTIVE_FLAG	    = 'Y'
												GROUP BY F.FACTORY_ID) F
									ON MWH.FACTORY_ID = F.FACTORY_ID
								WHERE  MWH.CALDATE >= @V_INSTANCE_DATE
								AND    MWH.CALDATE  < @V_TO_DATE
								GROUP  BY MWH.FACTORY_ID
										, CONVERT(DATE,MWH.CALDATE)
										, MWH.PRODID
										, MWH.PROCID ) MWH
								,SCM_BOM_M  BOM       WITH(NOLOCK)
								,SCM_ITEM_M SI        WITH(NOLOCK)
								,SCM_ITEM_CLASS_M SIC WITH(NOLOCK)
								,(SELECT	SEGMENT4 AS ASSY_FACTORY_ID, SEGMENT1 AS EPOST_INSTANCE_ID, F.COMPANY_ID, F.DIVISION_ID, F.SITE_ID, F.PLANT_ID, SEGMENT2 AS EPOST_FACTORY_ID
								FROM	SCM_SYS_LOOKUP_VALUE SLV,
										SCM_FACTORY_M F
								WHERE	1=1
								AND		SLV.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
								AND		SLV.ACTIVE_FLAG	= 'Y'
								AND		SLV.SEGMENT1	= @V_MASTER_ID
								AND		SLV.SEGMENT2	= F.FACTORY_ID
								AND		F.ACTIVE_FLAG	= 'Y' ) X
						WHERE 	1=1	
						AND 	MWH.PRODID      = BOM.PARENT_ITEM_ID
						AND     MWH.COMPANY_ID  = BOM.COMPANY_ID
						AND     MWH.DIVISION_ID = BOM.DIVISION_ID
						AND     MWH.SITE_ID     = BOM.SITE_ID
						AND     MWH.PLANT_ID    = BOM.PLANT_ID
						AND     BOM.COMPANY_ID  = SI.COMPANY_ID
						AND     BOM.DIVISION_ID = SI.DIVISION_ID
						AND     BOM.SITE_ID     = SI.SITE_ID
						AND 	BOM.CHILD_ITEM_ID = SI.ITEM_ID
						AND 	SI.ITEM_CLASS = SIC.CLASS_ID					
						AND 	SIC.LEVEL_2_NAME = 'Pancake'					
						AND 	BOM.ACTIVE_FLAG = 'Y'
						AND 	BOM.EFF_START_DATE <= @V_INSTANCE_DATE
						AND 	BOM.EFF_END_DATE    > @V_INSTANCE_DATE
						AND 	(BOM.ALT_PRIORITY = 1 OR BOM.ALT_PRIORITY IS NULL)	
						AND		MWH.FACTORY_ID	= X.ASSY_FACTORY_ID 
						AND     NOT EXISTS (SELECT 1 
											FROM 	SCM_SYS_LOOKUP_VALUE LVE WITH(NOLOCK)
											WHERE 	LVE.LOOKUP_TYPE_CODE = 'E_POST_EXCEPT_PANCAKE'
											AND 	LVE.SEGMENT1         = @V_MASTER_ID
											AND 	LVE.SEGMENT2         = BOM.CHILD_ITEM_ID
											AND 	LVE.ACTIVE_FLAG      = 'Y'
											)
						GROUP BY X.EPOST_INSTANCE_ID -- 2019-09-04 kimcd group by 추가
						       , X.COMPANY_ID
							   , X.DIVISION_ID
							   , X.SITE_ID
							   , X.PLANT_ID
							   , X.EPOST_FACTORY_ID
							   , BOM.CHILD_ITEM_ID
							   , MWH.PRODID
							   , MWH.CALDATE
							   , SI.APPLIED_MODEL
						)   A  
					)  A
		ON    (     U.INSTANCE_ID = A.EPOST_INSTANCE_ID
				AND U.FP_PLAN_ID  = A.FP_PLAN_ID
				AND U.COMPANY_ID  = A.EPOST_COMPANY_ID
				AND U.DIVISION_ID = A.EPOST_DIVISION_ID
				AND U.SITE_ID     = A.EPOST_SITE_ID
				AND U.PLANT_ID    = A.EPOST_PLANT_ID
				AND U.FACTORY_ID  = A.EPOST_FACTORY_ID
				AND U.ITEM_ID     = A.ITEM_ID
				AND U.NP_ITEM_ID  = A.NP_ITEM_ID
				AND U.CATEGORY    = A.CATEGORY
				AND U.PLAN_DATE   = A.PLAN_DATE )

		WHEN MATCHED THEN
			UPDATE SET 	U.IN_QTY        = A.IN_QTY      
					,	U.OUT_QTY       = A.OUT_QTY     
					,	U.IN_PC_QTY     = A.IN_PC_QTY   
					,	U.OUT_PC_QTY    = A.OUT_PC_QTY  
					,	U.IN_JR_QTY     = A.IN_JR_QTY   
					,	U.OUT_JR_QTY    = A.OUT_JR_QTY  
					,	U.IN_CELL_QTY   = A.IN_CELL_QTY 
					,	U.OUT_CELL_QTY  = A.OUT_CELL_QTY
					,	U.UPDATE_ID     = A.UPDATE_ID   
					,	U.UPDATE_TIME   = A.UPDATE_TIME 
		WHEN NOT MATCHED THEN
			INSERT (	INSTANCE_ID
					,	FP_PLAN_ID
					,	COMPANY_ID
					,	DIVISION_ID
					,	SITE_ID
					,	PLANT_ID
					,	FACTORY_ID
					,	ITEM_ID
					,	NP_ITEM_ID
					,	CATEGORY
					,	PLAN_DATE 
					,	IN_QTY 
					,	OUT_QTY
					,	IN_PC_QTY
					,	OUT_PC_QTY
					,	IN_JR_QTY
					,	OUT_JR_QTY
					,	IN_CELL_QTY
					,	OUT_CELL_QTY
					,	INSERT_ID 
					,	INSERT_TIME 
					,	UPDATE_ID 
					,	UPDATE_TIME )
			VALUES (	A.EPOST_INSTANCE_ID
					,	A.FP_PLAN_ID
					,	A.EPOST_COMPANY_ID
					,	A.EPOST_DIVISION_ID
					,	A.EPOST_SITE_ID
					,	A.EPOST_PLANT_ID
					,	A.EPOST_FACTORY_ID
					,	A.ITEM_ID
					,	A.NP_ITEM_ID
					,	A.CATEGORY
					,	A.PLAN_DATE 
					,	A.IN_QTY 
					,	A.OUT_QTY
					,	A.IN_PC_QTY
					,	A.OUT_PC_QTY
					,	A.IN_JR_QTY
					,	A.OUT_JR_QTY
					,	A.IN_CELL_QTY
					,	A.OUT_CELL_QTY
					,	A.INSERT_ID 
					,	A.INSERT_TIME 
					,	A.UPDATE_ID 
					,	A.UPDATE_TIME );

		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '12-NOTCHING_RESULT'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE NOTCHING END', @n_log_count, null, @v_message, @v_descr;

		SET @v_message = 'INSTANCE_DATE : ' + CONVERT(nvarchar, @V_INSTANCE_DATE, 112)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		SET @v_table_name = 'FP_ELECTRODE_POST_PLAN_H ELEC'
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE ELEC', @n_log_count, null, @v_message, null;

		---- %2- ELEC RESULT ---- 
		MERGE INTO  FP_ELECTRODE_POST_PLAN_H  U
		USING ( SELECT  A.EPOST_INSTANCE_ID  
					  , A.FP_PLAN_ID 
					  , A.EPOST_COMPANY_ID 
					  , A.EPOST_DIVISION_ID 
					  , A.EPOST_SITE_ID 
					  , A.EPOST_PLANT_ID 
					  , A.EPOST_FACTORY_ID 
					  , A.ITEM_ID 
					  , A.NP_ITEM_ID 
					  , CASE WHEN A.PROCID = 'E4000' THEN '22-SLITTING_RESULT'
					         WHEN A.PROCID = 'E3000' THEN '32-ROLL_PRESS_RESULT'
							 WHEN A.PROCID = 'E2000' THEN '42-COATING_RESULT' END  AS  CATEGORY 
					  , A.PLAN_DATE            AS  PLAN_DATE 
					  , A.PLAN_IN_QTY     AS IN_QTY
					  , A.PLAN_QTY        AS OUT_QTY
					  , CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_IN_QTY / CELL_M ELSE A.PLAN_IN_QTY END     AS IN_PC_QTY
					  , CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / CELL_M ELSE A.PLAN_QTY END   AS OUT_PC_QTY
					  , CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_IN_QTY / CELL_M ELSE A.PLAN_IN_QTY END / LANE_NUMBER   AS IN_JR_QTY
					  , CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / CELL_M ELSE A.PLAN_QTY END / LANE_NUMBER AS OUT_JR_QTY
					  , A.PLAN_IN_QTY / REQ_QTY   AS IN_CELL_QTY
					  , A.PLAN_QTY / REQ_QTY  AS OUT_CELL_QTY
					  , @v_proc_name  AS INSERT_ID
					  , GETDATE() AS INSERT_TIME 
					  , @v_proc_name   AS UPDATE_ID
					  , GETDATE() AS UPDATE_TIME 
				FROM   (SELECT   @V_MASTER_ID AS EPOST_INSTANCE_ID, @V_PLAN_ID AS FP_PLAN_ID, MWH.COMPANY_ID AS EPOST_COMPANY_ID, MWH.DIVISION_ID AS EPOST_DIVISION_ID, MWH.SITE_ID AS EPOST_SITE_ID
								,MWH.PLANT_ID AS EPOST_PLANT_ID, MWH.FACTORY_ID AS EPOST_FACTORY_ID, MWH.PRODID AS ITEM_ID, '-' AS NP_ITEM_ID, MWH.CALDATE AS PLAN_DATE
								,MWH.ACTUAL_QTY      AS PLAN_IN_QTY
								,MWH.ACTUAL_GOOD_QTY AS PLAN_QTY
								,[dbo].[FN_GET_REQ_QTY_MODEL]('-', SI.APPLIED_MODEL, SI.ITEM_ID,@V_INSTANCE_DATE) AS REQ_QTY
								,(SELECT MAX(LANE_QTY)
								  FROM   SCM_ITEM_LANE_M L WITH(NOLOCK)
								  WHERE  L.COMPANY_ID  = MWH.COMPANY_ID
								  AND    L.DIVISION_ID = MWH.DIVISION_ID
								  AND    L.SITE_ID     = MWH.SITE_ID
								  AND    L.PLANT_ID    = MWH.PLANT_ID
								  AND    L.FACTORY_ID  = MWH.FACTORY_ID
								  AND    L.ITEM_ID     = MWH.PRODID
								  AND    L.ACTIVE_FLAG = 'Y' ) AS LANE_NUMBER
								,CASE WHEN SI.ITEM_UOM = 'EA' THEN
										ISNULL(
												(
													SELECT  TOP 1 VALUE AS CELL_M
													FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													WHERE  C.MAX_VER_FLAG = 'Y'
													AND    ISNULL(C.VALUE, 0) > 0
													AND    C.CATEGORY     = 'Pancake (cell/m)'
													AND    C.COMPANY_ID   = MWH.COMPANY_ID
													AND    C.DIVISION_ID  = MWH.DIVISION_ID
													AND    C.SITE_ID      = MWH.SITE_ID
													AND    C.PLANT_ID     = MWH.PLANT_ID
													AND    C.FACTORY_ID   = MWH.FACTORY_ID
													AND    C.OPERATION    = 'E2000'
													AND    C.ITEM_ID      = MWH.PRODID
													ORDER BY CASE WHEN C.VERSION_TYPE = 'TEST' THEN 2 ELSE 1 END
															,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
															,C.MODEL_ID
															,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
															,CASE WHEN C.PROD_VERSION_TYPE = 'WIDE' THEN 2
																  WHEN C.PROD_VERSION_TYPE = 'GENERAL' THEN 3
																  ELSE 4
																  END
												)
												, (
													SELECT TOP 1 VALUE AS CELL_M
													FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													WHERE  C.MAX_VER_FLAG = 'Y'
													AND    ISNULL(C.VALUE, 0) > 0
													AND    C.CATEGORY     = 'Pancake (cell/m)'
													AND    C.OPERATION    = 'E2000'
													AND    C.ITEM_ID      = MWH.PRODID
													ORDER BY CASE WHEN VERSION_TYPE = 'TEST' THEN 2 ELSE 1 END
															,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
															,C.MODEL_ID
															,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
															,CASE WHEN C.PROD_VERSION_TYPE = 'WIDE' THEN 2
																  WHEN C.PROD_VERSION_TYPE = 'GENERAL' THEN 3
																  ELSE 4
																  END
															,C.VALUE
												) 
										)
								 END  AS CELL_M
								,SI.ITEM_UOM
								,MWH.PROCID
						FROM   (SELECT  MAX(F.COMPANY_ID)   AS COMPANY_ID
										,MAX(F.DIVISION_ID)  AS DIVISION_ID
										,MAX(F.SITE_ID)      AS SITE_ID
										,MAX(F.PLANT_ID)     AS PLANT_ID
										,MWH.FACTORY_ID
										,CONVERT(DATE,MWH.CALDATE) AS CALDATE
										,MWH.PRODID
										,MWH.PROCID
										,ISNULL( SUM(ISNULL(MWH.WIPQTY2_ENGINE,0))
												+ SUM(ISNULL(MWH.CNFM_DFCT_QTY2,0))
												+ SUM(ISNULL(MWH.CNFM_LOSS_QTY2,0)) 
												+ SUM(ISNULL(MWH.CNFM_PRDT_REQ_QTY2,0))
												+ SUM(ISNULL(CONVERT(NUMERIC(14,3), MWH.SCRAP_QTY),0))
											,0)											               		AS ACTUAL_QTY
										,ISNULL(SUM(MWH.WIPQTY2_ENGINE),0)                    				AS ACTUAL_GOOD_QTY
								FROM    SCM_MES_RT_WIP_HISTORY_H MWH  WITH(NOLOCK)
									INNER JOIN ( SELECT	F.FACTORY_ID
													, MAX(F.COMPANY_ID)   AS COMPANY_ID
													, MAX(F.DIVISION_ID)  AS DIVISION_ID
													, MAX(F.SITE_ID)      AS SITE_ID
													, MAX(F.PLANT_ID)     AS PLANT_ID
												FROM	SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK),
													SCM_FACTORY_M        F  WITH(NOLOCK)
												WHERE	LV.LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP'
												AND	LV.ACTIVE_FLAG	    = 'Y'
												AND	LV.SEGMENT1		    = @V_MASTER_ID
												AND	LV.SEGMENT2		    = F.FACTORY_ID
												AND	F.ACTIVE_FLAG	    = 'Y'
												GROUP BY F.FACTORY_ID) F
									ON MWH.FACTORY_ID = F.FACTORY_ID
								WHERE  MWH.CALDATE >= @V_INSTANCE_DATE
								AND    MWH.CALDATE  < @V_TO_DATE
								AND    MWH.PROCID IN ('E2000','E3000','E4000')
								GROUP  BY MWH.FACTORY_ID
										, CONVERT(DATE,MWH.CALDATE)
										, MWH.PRODID
										, MWH.PROCID ) MWH
								,SCM_ITEM_M SI        WITH(NOLOCK)
						WHERE 	1=1	
						AND 	MWH.PRODID      = SI.ITEM_ID
						AND     MWH.COMPANY_ID  = SI.COMPANY_ID
						AND     MWH.DIVISION_ID = SI.DIVISION_ID
						AND     MWH.SITE_ID     = SI.SITE_ID
						)   A  
					)  A
		ON    (     U.INSTANCE_ID = A.EPOST_INSTANCE_ID
				AND U.FP_PLAN_ID  = A.FP_PLAN_ID
				AND U.COMPANY_ID  = A.EPOST_COMPANY_ID
				AND U.DIVISION_ID = A.EPOST_DIVISION_ID
				AND U.SITE_ID     = A.EPOST_SITE_ID
				AND U.PLANT_ID    = A.EPOST_PLANT_ID
				AND U.FACTORY_ID  = A.EPOST_FACTORY_ID
				AND U.ITEM_ID     = A.ITEM_ID
				AND U.NP_ITEM_ID  = A.NP_ITEM_ID
				AND U.CATEGORY    = A.CATEGORY
				AND U.PLAN_DATE   = A.PLAN_DATE )

		WHEN MATCHED THEN
			UPDATE SET 	U.IN_QTY        = A.IN_QTY      
					,	U.OUT_QTY       = A.OUT_QTY     
					,	U.IN_PC_QTY     = A.IN_PC_QTY   
					,	U.OUT_PC_QTY    = A.OUT_PC_QTY  
					,	U.IN_JR_QTY     = A.IN_JR_QTY   
					,	U.OUT_JR_QTY    = A.OUT_JR_QTY  
					,	U.IN_CELL_QTY   = A.IN_CELL_QTY 
					,	U.OUT_CELL_QTY  = A.OUT_CELL_QTY
					,	U.UPDATE_ID     = A.UPDATE_ID   
					,	U.UPDATE_TIME   = A.UPDATE_TIME 
		WHEN NOT MATCHED THEN
			INSERT (	INSTANCE_ID
					,	FP_PLAN_ID
					,	COMPANY_ID
					,	DIVISION_ID
					,	SITE_ID
					,	PLANT_ID
					,	FACTORY_ID
					,	ITEM_ID
					,	NP_ITEM_ID
					,	CATEGORY
					,	PLAN_DATE 
					,	IN_QTY 
					,	OUT_QTY
					,	IN_PC_QTY
					,	OUT_PC_QTY
					,	IN_JR_QTY
					,	OUT_JR_QTY
					,	IN_CELL_QTY
					,	OUT_CELL_QTY
					,	INSERT_ID 
					,	INSERT_TIME 
					,	UPDATE_ID 
					,	UPDATE_TIME )
			VALUES (	A.EPOST_INSTANCE_ID
					,	A.FP_PLAN_ID
					,	A.EPOST_COMPANY_ID
					,	A.EPOST_DIVISION_ID
					,	A.EPOST_SITE_ID
					,	A.EPOST_PLANT_ID
					,	A.EPOST_FACTORY_ID
					,	A.ITEM_ID
					,	A.NP_ITEM_ID
					,	A.CATEGORY
					,	A.PLAN_DATE 
					,	A.IN_QTY 
					,	A.OUT_QTY
					,	A.IN_PC_QTY
					,	A.OUT_PC_QTY
					,	A.IN_JR_QTY
					,	A.OUT_JR_QTY
					,	A.IN_CELL_QTY
					,	A.OUT_CELL_QTY
					,	A.INSERT_ID 
					,	A.INSERT_TIME 
					,	A.UPDATE_ID 
					,	A.UPDATE_TIME );


		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '*2-ELECTRODE_RESULT'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'MERGE ELECTRODE END', @n_log_count, null, @v_message, @v_descr;
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
			SET @v_descr = ERROR_MESSAGE()
			SET @sysdate = GETDATE()

			SET @n_log_count = @n_log_count + 1
			EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', @n_log_count, @v_temp2, null, @v_descr
			commit;

	END CATCH

END
