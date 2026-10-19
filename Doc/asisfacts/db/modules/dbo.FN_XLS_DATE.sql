

CREATE FUNCTION [dbo].[FN_XLS_DATE]
      ( 
		@P_YYYYMMDD	NVARCHAR(10), 
		@P_DAYS	INT = 0
	  )
      RETURNS NVARCHAR(10)
AS
/*
 * Program ID   : [FN_XLS_DATE]
 * Description  :  문자형 날짜의 연산값을 반환
 * 사용례		    
  SELECT DBO.[FN_XLS_DATE]( '20250210', 364)  ;
 * Program History
 *===================================================================================================
 *   Date			In Charge			Description
 *===================================================================================================
 * 2025.02.17   luckydohan         Initial Release 
 */
BEGIN
    RETURN CONVERT(VARCHAR(8), DATEADD(day, @P_DAYS, @P_YYYYMMDD), 112);
END
;
