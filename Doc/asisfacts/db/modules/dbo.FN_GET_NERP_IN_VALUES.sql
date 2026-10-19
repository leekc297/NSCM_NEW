


-- =============================================
-- Program:      FN_GET_NERP_IN_VALUES
-- Author:       김준규
-- Create date:  2025-06-05
-- Description:  NERP) 컨버전시 콤마로 되어 있는 값을 Dynamice SQL 에서 IN 절에 사용하기 위함
-- How to Execute: SELECT dbo.FN_GET_NERP_IN_VALUES('AAA,BBB')
-- ==========================================================================================
-- 2025-06-05       김준규       NERP) 컨버전시 콤마로 되어 있는 값을 Dynamice SQL 에서 IN 절에 사용하기 위함
---------------------------------------------------------------------------------------------

CREATE   FUNCTION [dbo].[FN_GET_NERP_IN_VALUES]
(
       @P_INPUTVALUES NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @FormattedString NVARCHAR(MAX);

    SELECT @FormattedString = STRING_AGG('''' + REPLACE(TRIM(token), '''', '''''') + '''', ',')
    FROM STRING_SPLIT(@P_INPUTVALUES, ',');

    RETURN ISNULL(@FormattedString, '');

END



