
/*
 * Program ID   : SCP0083_GET_PLAN_VERSION_INFO
 * Description  : SCP0083 DIO Report 화면의 Version Combo매핑
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/12/01   kmj				Initial Release - [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2022/05/26   jahn1501	    SCM_SYS_CALENDAR_M 주차 추가
 * 2022/06/13   vadabi3	        SCP0083_GET_DIO_VERSION_INFO => SCP0083_GET_PLAN_VERSION_INFO

 */

CREATE PROCEDURE [dbo].[SCP0083_GET_PLAN_VERSION_INFO_01]
--chaan  	@p_division_id			NVARCHAR(5)
  @p_division_id            NVARCHAR(30)--chaan
AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

		--	SELECT TOP 10 
		--	(A.plan_start_yyyymmdd+'-FN-'+CONVERT(VARCHAR, MAX(A.plan_seq))) AS CODE, 
		--	(A.plan_start_yyyymmdd+'-FN-'+CONVERT(VARCHAR, MAX(A.plan_seq))) AS NAME,
		--	(SELECT DISTINCT 1 FROM SCP_ANL_DIO_REPORT B WITH(NOLOCK) WHERE B.DIVISION_ID=A.DIVISION_ID AND B.PLAN_START_YYYYMMDD=A.PLAN_START_YYYYMMDD AND B.PLAN_TYPE='FN' AND B.SEQ=MAX(A.PLAN_SEQ)) AS CODEDESC,
		--	(SELECT TOP 1 (PLAN_START_YYYYMMDD+'-FN-'+CONVERT(NVARCHAR, SEQ)) FROM SCP_ANL_DIO_REPORT C WITH(NOLOCK) WHERE C.DIVISION_ID=@p_division_id GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ ORDER BY PLAN_START_YYYYMMDD DESC) AS EDIT_CYCLE_VERSION
		--FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
		--WHERE A.division_id = @p_division_id
		--AND A.plan_type = 'FN'
		--AND A.confirm_flag = 'Y'
		--AND A.ui_display_yn = 'Y'
		--AND A.active_flag = 'Y'
		--GROUP BY A.division_id, A.plan_start_yyyymmdd
		--ORDER BY CODE DESC
		;

		SELECT TOP 20 
			   (A.plan_start_yyyymmdd+'-FN-'+CONVERT(VARCHAR, MAX(A.plan_seq)))		AS CODE
			 , (A.plan_start_yyyymmdd+ '(' + C.WEEK_NAME + ')'+'-FN-'+CONVERT(VARCHAR, MAX(A.plan_seq)))		AS NAME
			 , (CASE WHEN B.PLAN_START_YYYYMMDD IS NULL THEN 'Y' ELSE 'N' END)		AS CREATE_YN
			 , (SELECT TOP 1 (PLAN_START_YYYYMMDD+'-FN-'+CONVERT(NVARCHAR, SEQ)) 
				  FROM SCP_ANL_DIO_REPORT C WITH(NOLOCK) 
				 WHERE C.DIVISION_ID = A.DIVISION_ID
				 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ 
				 ORDER BY PLAN_START_YYYYMMDD DESC)								AS EDIT_CYCLE_VERSION
			, A.DIVISION_ID
		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
		  LEFT JOIN SCP_ANL_DIO_REPORT B WITH(NOLOCK)
			ON A.DIVISION_ID=B.DIVISION_ID 
		   AND A.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD 
		   AND A.PLAN_TYPE				= B.PLAN_TYPE
		   AND A.PLAN_SEQ				= B.SEQ
		  LEFT JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.plan_start_yyyymmdd = C.basis_yyyymmdd
		 WHERE A.division_id = @p_division_id
		   AND A.PLAN_TYPE		= 'FN'
		   AND A.CONFIRM_FLAG	= 'Y'
		   AND A.UI_DISPLAY_YN	= 'Y'
		   AND A.ACTIVE_FLAG	= 'Y'
		GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD , B.PLAN_START_YYYYMMDD , C.WEEK_NAME
		ORDER BY CODE DESC
		;

END
