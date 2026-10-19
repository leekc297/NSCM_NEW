

CREATE FUNCTION [dbo].FN_XLS_PLANCODE
(
	 @P_PLAN_START_YYYYMMDD VARCHAR(10) = '20241203'
	, @P_PLAN_TYPE	VARCHAR(10) = 'PR'
	, @P_SEQ				INT = 1
 )
    RETURNS NVARCHAR(100)
AS
/*
 * Program ID   : FN_XLS_PLANCODE
 * Description  : 비교가능한 플랜정보로 반환
 * OutTable     :
 * Execute      : 
                 
	SELECT  DBO.FN_XLS_PLANCODE ( '20241202', 'PR', 1 )

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
  * 2024.12.03	KSK		 iNITIAL RELEASE
 */
BEGIN
	DECLARE @RES  NVARCHAR(100) = N'OK'
	DECLARE @AT TABLE ( VAL VARCHAR(2) , LABEL VARCHAR(2) )
	INSERT INTO @AT VALUES	('01', 'PR'), ('02', 'MA'), ('03', 'SE') , ('04', 'FN')
		 
	RETURN (SELECT  @P_PLAN_START_YYYYMMDD + '_' 
			+ VAL + '_' +  FORMAT( @P_SEQ, '000') FROM @AT WHERE LABEL = @P_PLAN_TYPE)
END


