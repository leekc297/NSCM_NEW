




/*
 * Program ID   : PR_SCP_XLS_EXCEL_BODY_QUERY
 * Description  : SCP 시뮬레이터의 저장직전의 공통체크로직
 * OutTable     :
 * Execute      : 
                 
  EXEC PR_SCP_XLS_BEFORE_SAVE  'EE_UC', '20241118', 'FN', 6
 

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
  * 2024.12.03	KSK		 iNITIAL RELEASE
 */

CREATE PROCEDURE [dbo].[PR_SCP_XLS_BEFORE_SAVE]
(
	  @P_DIVISION_ID VARCHAR(10) = '81'
	, @P_PLAN_START_YYYYMMDD VARCHAR(10) = '20241203'
	, @P_PLAN_TYPE	VARCHAR(10) = 'PR'
	, @P_SEQ				INT = 1
 )
AS
BEGIN
	SET NOCOUNT OFF
	DECLARE @RES  NVARCHAR(100) = N'OK'
			, @PLAN_INFO		VARCHAR(30) 
	SET @PLAN_INFO =DBO.FN_XLS_PLANCODE(@P_PLAN_START_YYYYMMDD, @P_PLAN_TYPE, @P_SEQ)
	
	--PRINT @PLAN_INFO

	IF @RES= 'OK' 
		SELECT  @RES = 'A new Plan is being processed'		
		WHERE EXISTS (SELECT  1 
								FROM  SCM_SYS_LOG_BATCH WITH (NOLOCK) 
								WHERE PROGRAM_NAME = 'PR_SCP_XLS_CREATE_DATA'								
								AND ATTRIBUTE1 = @P_DIVISION_ID
								AND ATTRIBUTE2 >  @PLAN_INFO )

	SELECT @RES AS RESULT
END
