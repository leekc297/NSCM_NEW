/*
 * Program ID   : FN_WEEKOFDAY_DATE
 * Description  : 특정 일자 주기, 요일을 가져온다.
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.19   ygkim     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE FUNCTION [dbo].[FN_WEEKOFDAY_DATE] 
(
 @P_Date CHAR(6)
   ,@P_Week VARCHAR(2)
   ,@P_WeekOfDay VARCHAR(2)
)
RETURNS VARCHAR(10)
AS
BEGIN
 DECLARE @RE_DATE VARCHAR(10)
 
 IF @P_Week = -1 
	 BEGIN
		 ;WITH CTE_DATE AS  
		 (  
			 SELECT CONVERT(DATETIME,@P_Date + '01') DATE, 
			  DATEPART(DW,CONVERT(DATETIME,@P_Date + '01')) T 
			 UNION ALL  
			 SELECT DATE + 1,  
			  DATEPART(DW,DATE + 1) 
			   FROM CTE_DATE 
			  WHERE DATE + 1 < DATEADD(M,1,@P_Date + '01') 
		 ) 
		 SELECT @RE_DATE = MAX(CONVERT(VARCHAR(10),DATE,120))
			FROM CTE_DATE  
		  WHERE T = @P_WeekOfDay
	 END
 ELSE
	 BEGIN
		;WITH CTE_DATE AS  
		(  
			SELECT CONVERT(DATETIME,@P_Date + '01') DATE, 
			DATEPART(DW,CONVERT(DATETIME,@P_Date + '01')) T 
			UNION ALL  
			SELECT DATE + 1,  
			DATEPART(DW,DATE + 1) 
			FROM CTE_DATE 
			WHERE DATE + 1 < DATEADD(M,1,@P_Date + '01') 
		) 
		SELECT @RE_DATE = Date
		 FROM(
			SELECT (datepart(dd, DATE) + (7 - datepart(dw, DATE)) + datepart(dw, DATE) - 1) / 7 Week,
				CONVERT(VARCHAR(10),DATE,120) Date,
				DATEPART(DW,DATE) WeekOfDay
			FROM CTE_DATE  
			WHERE T >= 1 
		 ) A  
		 WHERE Week = @P_Week
		   AND WeekOfDay = @P_WeekOfDay
	END
 -- Return the result of the function
 RETURN @RE_DATE

END

