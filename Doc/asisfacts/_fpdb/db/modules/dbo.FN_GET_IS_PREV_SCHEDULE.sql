
--CREATE FUNCTION [dbo].[FN_GET_IS_PREV_SCHEDULE]
CREATE FUNCTION [dbo].[FN_GET_IS_PREV_SCHEDULE]
-- ================================================================================================
-- Program ID          : 
-- Program Name        : FN_GET_IS_PREV_SCHEDULE
-- Param               : DIVISION_ID
--                       FP_PRODUCTION_TYPE
-- Batch Period        : 
-- Description         : DIVISION별 Demand type 별로 하위 공정 계획 수립 여부를 반환. 
--                       LOOKUP DIVISION_DEMAND_TYPE 에서 Initial = 'T'이고  SCP_TARGET_FLAG = 'N'이면 하위공정 계획 수립하지 않는 대상으로 'N' 반환, 그 외 'Y' 반환. 
--                       조회결과 없으면 Null 반환. 
-- Source System       : 
-- Destination System  : FP
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2023.08.31
-- Author              : KHM
-- Version             : 1.0
-- ================================================================================================
(
    @DIVISION_ID			NVARCHAR(30),
    @FP_PRODUCTION_TYPE		NVARCHAR(30)
)
RETURNS NVARCHAR(1)
AS

BEGIN

    DECLARE @IS_PREV_SCHEDULE  NVARCHAR(1)

    IF @DIVISION_ID = '-' OR @DIVISION_ID = '' OR @FP_PRODUCTION_TYPE = '-' OR @FP_PRODUCTION_TYPE = '' 
    	SELECT @IS_PREV_SCHEDULE = NULL 
    ELSE 
    
		select  @IS_PREV_SCHEDULE = max(	case when SEGMENT5 = 'T'   -- INITIAL
											and ATTRIBUTE3 = 'N'  -- SCP_TARGET_FLAG 
											then 'N' else 'Y' end )
		from SCM_SYS_LOOKUP_VALUE with (nolock) 
		where lookup_type_code = 'DIVISION_DEMAND_TYPE' 
		and segment1 = @DIVISION_ID		     -- DIVISION_ID
		and ATTRIBUTE2 = @FP_PRODUCTION_TYPE -- FP PRODUCTION TYPE

	RETURN @IS_PREV_SCHEDULE

END
