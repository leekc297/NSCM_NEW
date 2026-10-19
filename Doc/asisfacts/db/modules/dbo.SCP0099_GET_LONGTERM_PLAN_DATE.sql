
/*
 * Program ID   : [SCP0099_GET_LONGTERM_PLAN_DATE]
 * Description  : 중장기계획  날짜 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023-08-23   KJJ				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 중장기 계획 날짜 조회
								=>UP_FX_GetCommonDataList 의 'DATE_WEEKLY' 참고
								=>최근 4주 이내의 PLAN_TYPE = 'FN'인 것만 가져와야 함
 * ex)
    EXEC SCP0099_GET_LONGTERM_PLAN_DATE @p_division_id='81'
 */
CREATE PROCEDURE [dbo].[SCP0099_GET_LONGTERM_PLAN_DATE]
 (
  	 @p_division_id		NVARCHAR(MAX)  
 )
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

		SELECT A.plan_start_yyyymmdd AS code
 	  		 , CASE WHEN FP_TARGET_YN = 'Y' THEN CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')'
 	  		 		ELSE CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' END name
  		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
  		 INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
  		 LEFT JOIN 
  		 (
  		 	SELECT DIVISION_ID
		 		, PLAN_START_YYYYMMDD
		 		, FP_TARGET_YN
		 		, MRP_TARGET_YN
		 		, DM_RTF_YN	 
	  		 FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
			WHERE 1=1
	   		  AND DIVISION_ID =  @p_division_id
  		 ) C ON A.plan_start_yyyymmdd = C.PLAN_START_YYYYMMDD
		 WHERE A.division_id= @p_division_id
		AND PLAN_TYPE = 'FN'
		AND CONFIRM_DATE >= DATEADD(WEEK, -4, GETDATE()) -- 최근 4주 이내 것만
		 GROUP BY A.plan_start_yyyymmdd, B.WEEK_NAME, C.FP_TARGET_YN
		 ORDER BY A.plan_start_yyyymmdd DESC

END
