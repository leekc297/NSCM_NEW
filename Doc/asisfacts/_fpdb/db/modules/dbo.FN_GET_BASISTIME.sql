CREATE FUNCTION [dbo].[FN_GET_BASISTIME]
-- ================================================================================================
-- Program ID          : 
-- Program Name        : FN_GET_BASISTIME
-- Param               : INSTANCE_ID
--                       PLAN_ID
-- Batch Period        : 
-- Description         : INSTANCE와 PLAN_ID에 해당하느 PLAN START TIME을 구함.
--
-- Source System       : 
-- Destination System  : FP
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2016.12.06
-- Author              : HJY
-- Version             : 1.0
-- ================================================================================================
(
    @INSTANCE_ID    NVARCHAR(500) = '-'
   ,@PLAN_ID    NVARCHAR(500) = '-'
)
RETURNS DATETIME
AS

BEGIN

    DECLARE @PLAN_DATE     NVARCHAR(8)
           ,@PLAN_START_TIME DATETIME
    
    IF @PLAN_ID = '-' OR @PLAN_ID = ''
    	SELECT @PLAN_DATE = CONVERT(NVARCHAR(8),GETDATE(),112)
    ELSE 
    	SELECT @PLAN_DATE = LEFT(REPLACE(@PLAN_ID,@INSTANCE_ID+'-',''),8)
    
    IF LEN(@PLAN_DATE) <> 8
    	SELECT @PLAN_DATE = CONVERT(NVARCHAR(8),GETDATE(),112)

	SELECT @PLAN_START_TIME = CONVERT(DATETIME,@PLAN_DATE+' '+LEFT(BASIS_TIME,2)+':'+SUBSTRING(BASIS_TIME,3,2)+':'+RIGHT(BASIS_TIME,2))
	FROM (
		SELECT CASE WHEN MAX(PLANT_BASIS_TIME) IS NULL THEN MAX(BASIS_TIME) ELSE MAX(PLANT_BASIS_TIME) END AS BASIS_TIME
		FROM (
			select A.INSTANCE_ID,B.PLANT_ID,B.FACTORY_ID,C.PLANT_BASIS_TIME,D.BASIS_TIME from FP_INSTANCE_FACTORY_M A INNER JOIN SCM_FACTORY_M B ON A.FACTORY_ID=B.FACTORY_ID
			LEFT JOIN (SELECT SEGMENT1 AS PLANT_ID,SEGMENT2 AS PLANT_BASIS_TIME FROM SCM_SYS_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT') C
			ON B.PLANT_ID=C.PLANT_ID
			INNER JOIN (SELECT '-' AS CODE_ID,SEGMENT1 AS BASIS_TIME FROM SCM_SYS_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME') D
			ON 1=1
			WHERE A.INSTANCE_ID=@INSTANCE_ID
		) AA
	) AAA
		
	RETURN @PLAN_START_TIME

END
