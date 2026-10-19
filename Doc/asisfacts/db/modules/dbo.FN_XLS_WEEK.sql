

CREATE FUNCTION [dbo].[FN_XLS_WEEK]
      ( 
		@P_YYYYMMDD	NVARCHAR(10) 
	  )
      RETURNS NVARCHAR(10)
AS
/*
 * Program ID   : [FN_XLS_DATE]
 * Description  :  날짜에 해당하는 주차명 반환
 * 사용례		    
   SELECT DBO.FN_XLS_WEEK( '20250210')  ;
 * Program History
 *===================================================================================================
 *   Date			In Charge			Description
 *===================================================================================================
 * 2025.09.25   KSK				Initial Release 
 */
BEGIN
	RETURN (SELECT WEEK_NAME
			      FROM dbo.SCM_SYS_CALENDAR_M A WITH (NOLOCK)
				  WHERE A.BASIS_YYYYMMDD = @P_YYYYMMDD )
END
;
