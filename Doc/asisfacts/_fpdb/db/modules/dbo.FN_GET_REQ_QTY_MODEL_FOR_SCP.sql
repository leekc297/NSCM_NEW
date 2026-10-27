CREATE FUNCTION [dbo].[FN_GET_REQ_QTY_MODEL_FOR_SCP]
-- ================================================================================================
-- Program ID          : 
-- Program Name        : FN_GET_REQ_QTY_MODEL_FOR_SCP
-- Param               : 	PLANT_ID
--                          MODEL_ID
--                          CHILD_ITEM_ID
--                          PLAN_DATE
-- Batch Period        : 
-- Description         : Plant, Model, Child Item, Plan date 기준으로 모델별 하위 구성 품 소요량 산출
--
-- Source System       : FP
-- Destination System  : FP
-- Source Table        : SCM_MODEL_COMP_EFFECTIVE_DATE
-- Destination Table   : 
--
-- Create(Update) Date : 2019.10.15
-- Author              : kimcd
-- Version             : 1.0 SCM_MODEL_COMP_EFFECTIVE_DATE 기준으로 전달된 일자 기준으로 소요량 산출
--                           SCP 전극 대치 품목 제외하기 위해 분리
-- ================================================================================================
(
    @P_PLANT_ID      NVARCHAR(30) = '-'
   ,@P_MODEL_ID      NVARCHAR(50) = '-'
   ,@P_CHILD_ITEM_ID NVARCHAR(50) = '-'
   ,@P_PLAN_DATE     DATE
)
RETURNS NUMERIC(20,10)
AS

BEGIN
    DECLARE @PLANT_ID        NVARCHAR(30)
    DECLARE @MODEL_ID        NVARCHAR(50)
    DECLARE @CHILD_ITEM_ID   NVARCHAR(50)
    DECLARE @PLAN_DATE       DATE
	DECLARE @ACCUM_QTY       NUMERIC(20,10)
    
    IF @P_PLANT_ID = '-' OR @P_PLANT_ID = ''
    	SELECT @PLANT_ID = NULL
    ELSE 
    	SELECT @PLANT_ID = @P_PLANT_ID
    
    IF @P_MODEL_ID = '-' OR @P_MODEL_ID = ''
    	SELECT @MODEL_ID = NULL
    ELSE 
    	SELECT @MODEL_ID = @P_MODEL_ID

    IF @P_CHILD_ITEM_ID = '-' OR @P_CHILD_ITEM_ID = ''
    	SELECT @CHILD_ITEM_ID = NULL
    ELSE 
    	SELECT @CHILD_ITEM_ID = @P_CHILD_ITEM_ID

    IF @P_PLAN_DATE IS NULL
    	SELECT @PLAN_DATE = GETDATE()
    ELSE 
    	SELECT @PLAN_DATE = @P_PLAN_DATE

	IF @P_PLANT_ID = '-' OR @P_PLANT_ID = ''
		SELECT TOP 1 @ACCUM_QTY = ACCUM_QTY
		FROM (
					SELECT PLANT_ID, MODEL_ID, CHILD_ITEM_ID, SUM(MCT.ACCUMULATED_CHILD_QTY) AS ACCUM_QTY
					FROM  SCM_MODEL_COMP_EFFECTIVE_DATE MCT WITH(NOLOCK) 
					WHERE 1=1
					AND   MCT.MODEL_ID        = @MODEL_ID
					AND   MCT.CHILD_ITEM_ID   = @CHILD_ITEM_ID
					AND   MCT.EFF_START_DATE <= @PLAN_DATE
					AND   MCT.EFF_END_DATE    > @PLAN_DATE
					AND   MCT.ALT_PRIORITY    = 'Y' -- 2019-10-15 KIMCD 대치 제외 SCP용 함수 별도 만든 원인
					GROUP BY  PLANT_ID, MODEL_ID, CHILD_ITEM_ID
				) A
	ELSE
		SELECT @ACCUM_QTY = SUM(MCT.ACCUMULATED_CHILD_QTY)
		FROM  SCM_MODEL_COMP_EFFECTIVE_DATE MCT WITH(NOLOCK) 
		WHERE MCT.PLANT_ID        = @PLANT_ID
		AND   MCT.MODEL_ID        = @MODEL_ID
		AND   MCT.CHILD_ITEM_ID   = @CHILD_ITEM_ID
		AND   MCT.EFF_START_DATE <= @PLAN_DATE
		AND   MCT.EFF_END_DATE    > @PLAN_DATE
		AND   MCT.ALT_PRIORITY    = 'Y' -- 2019-10-15 KIMCD 대치 제외 SCP용 함수 별도 만든 원인
		
	RETURN @ACCUM_QTY

END
