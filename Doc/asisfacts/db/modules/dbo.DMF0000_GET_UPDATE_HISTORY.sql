
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/***************************************************************************************************
 Program ID  : DMF0000_GET_UPDATE_HISTORY                                           
 Description : Procedure 작성 가이드                                                              
 Usage       : Procedure 작성 시 참조하세요!                                                      
 Parameter   :                                                                                    
                                                                                                  
--------------------------------------------------------------------------------------------------
 Date        In Charge    Description                                                             
--------------------------------------------------------------------------------------------------    
 2023/11/30	kjj			PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - EDI STATUS UPDATE HISTORY 조회
**************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0000_GET_UPDATE_HISTORY]

AS
BEGIN
	
	SELECT 
	(
		SELECT CONVERT(VARCHAR(19), MAX(LAST_UPDATE_DATE), 120) SDATE FROM SCM_SYS_LOG_BATCH WITH(NOLOCK) 
		WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
		AND LOG_TYPE = 'START'
	) SDATE,
	(
		SELECT CONVERT(VARCHAR(19), MAX(LAST_UPDATE_DATE), 120) SDATE FROM SCM_SYS_LOG_BATCH WITH(NOLOCK) 
		WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
		AND LOG_TYPE = 'END'
	) EDATE,
	(
		SELECT TOP 1 LAST_UPDATED_BY FROM SCM_SYS_LOG_BATCH WITH(NOLOCK) 
		WHERE LAST_UPDATE_DATE =
		(
			SELECT MAX(LAST_UPDATE_DATE) SDATE FROM SCM_SYS_LOG_BATCH WITH(NOLOCK) 
			WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
			AND LOG_TYPE = 'START'
		)
	) UPDATED_BY
/*
속도개선 고려

WITH LAST_UPDATE AS
(
			SELECT MAX(LAST_UPDATE_DATE) SDATE FROM SCM_SYS_LOG_BATCH WITH(NOLOCK) 
			WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
			AND LOG_TYPE = 'END'
)
SELECT 
(
	SELECT CONVERT(VARCHAR(19), MAX(LAST_UPDATE_DATE), 120) SDATE FROM SCM_SYS_LOG_BATCH WITH(NOLOCK) 
	WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
	AND LOG_TYPE = 'START'
	AND LAST_UPDATE_DATE < (
		SELECT * FROM LAST_UPDATE
	)
) SDATE,
(
	SELECT CONVERT(VARCHAR(19), SDATE, 120) FROM LAST_UPDATE
) EDATE,
(
	SELECT LAST_UPDATED_BY FROM SCM_SYS_LOG_BATCH WITH(NOLOCK) 
	WHERE LAST_UPDATE_DATE =
	(
		SELECT * FROM LAST_UPDATE
	)
) UPDATED_BY
*/
		 
END



