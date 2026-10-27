CREATE FUNCTION [dbo].[FN_GET_SCM_ETA]
-- ================================================================================================
-- Program ID          : 
-- Program Name        : FN_GET_SCM_BOD
-- Param               : P_FROM_PLANT_ID
--                       P_TO_PLANT_ID
--                       P_SHIP_DATE
--                       P_TRANSPORT_TYPE
-- Batch Period        : 화면에서 직접 호출
-- Description         : P_SHIP_DATE 기준으로 ETA 정보 산출
--
-- Source System       : 
-- Destination System  : FP
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2019.06.27
-- Author              : kimcd
-- Version             : 1.0 SCM BOD 기반으로 PLANT ID별 BOD 산출
-- ================================================================================================
(
    @P_FROM_PLANT_ID    NVARCHAR(30) = '-'
   ,@P_TO_PLANT_ID      NVARCHAR(30) = '-'
   ,@P_SHIP_DATE        NVARCHAR(10) = '20190627'
   ,@P_TRANSPORT_TYPE   NVARCHAR(10) = '-'
)
RETURNS DATETIME
AS

BEGIN
    DECLARE @FROM_PLANT_ID    NVARCHAR(30)
    DECLARE @TO_PLANT_ID      NVARCHAR(30)
    DECLARE @SHIP_DATE        NVARCHAR(10)
    DECLARE @TRANSPORT_TYPE   NVARCHAR(10)
    DECLARE @ETA_DATE         DATETIME
    
    IF @P_FROM_PLANT_ID = '-' OR @P_FROM_PLANT_ID = ''
    	SELECT @FROM_PLANT_ID = NULL
    ELSE 
    	SELECT @FROM_PLANT_ID = @P_FROM_PLANT_ID
    
    IF @P_TO_PLANT_ID = '-' OR @P_TO_PLANT_ID = ''
    	SELECT @TO_PLANT_ID = NULL
    ELSE 
    	SELECT @TO_PLANT_ID = @P_TO_PLANT_ID

    IF @P_SHIP_DATE = '-' OR @P_SHIP_DATE = ''
    	SELECT @SHIP_DATE = CONVERT(NVARCHAR(8), GETDATE(), 112)
    ELSE 
    	SELECT @SHIP_DATE = @P_SHIP_DATE

    IF @P_TRANSPORT_TYPE = '-' OR @P_TRANSPORT_TYPE = ''
    	SELECT @TRANSPORT_TYPE = NULL
    ELSE 
    	SELECT @TRANSPORT_TYPE = @P_TRANSPORT_TYPE

	SELECT TOP 1 @ETA_DATE = DATEADD(DD,A.LT_TOTAL, CONVERT(DATE,@SHIP_DATE,112))
	FROM   [dbo].[IF_FP_SCM_BOD_V] A
	WHERE  A.FROM_PLANT_ID = @FROM_PLANT_ID
	AND    A.TO_PLANT_ID = @TO_PLANT_ID
	ORDER  BY CASE WHEN A.[TRANSPORT_MODE] = @TRANSPORT_TYPE THEN 1 ELSE 2 END
	         ,A.[PRIORITY]

	IF @ETA_DATE IS NULL 
		SELECT @ETA_DATE = 	CONVERT(DATE,@SHIP_DATE,112)

	RETURN @ETA_DATE

END
