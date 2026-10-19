





/*
 * Program ID   : SCP0036_GET_JIG_ITEM
 * Description  : Jig Item 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/10/19   yhw				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/01	yhw				Operation ID 적용
 */
CREATE PROCEDURE [dbo].[SCP0036_GET_JIG_ITEM]
  @p_division_id	NVARCHAR(MAX),
  @p_item_id		NVARCHAR(MAX),
  @p_jig_name		NVARCHAR(MAX),
  @p_valid_yn		NVARCHAR(MAX)
AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	SELECT CONVERT(NVARCHAR(MAX), A.JIG_ITEM_SEQ) AS JIG_ITEM_SEQ
		   , CONVERT(NVARCHAR(MAX), A.JIG_SEQ) AS JIG_SEQ
		   , B.DIVISION_ID
		   , B.SCM_SITE_ID
		   , C.SCM_SITE_ID + ' ' + C.SITE_DESCRIPTION AS SITE_DESCRIPTION
		   , B.OPERATION_ID
		   , C.OPERATION_GROUP
		   , B.JIG_NAME
		   , A.ITEM_ID
		   , (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-'  WHEN X.NICK_NAME = ''    THEN '-'  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID) AS NICK_NAME
		   , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(A.FROM_YYYYMMDD),121) AS FROM_YYYYMMDD 
		   , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(A.TO_YYYYMMDD)  ,121) AS TO_YYYYMMDD 
		   , A.VALID_YN
		   , A.VALID_YN AS S_VALUE_YN
		   , A.CREATED_BY
		   , A.CREATION_DATE
		   , A.LAST_UPDATED_BY
		   , A.LAST_UPDATE_DATE
	FROM SCP_MST_JIG_ITEM A WITH(NOLOCK)
	JOIN SCP_MST_JIG B WITH(NOLOCK) ON A.JIG_SEQ=B.JIG_SEQ
	JOIN SCM_MST_SITE C WITH(NOLOCK) ON C.DIVISION_ID=B.DIVISION_ID AND C.SCM_SITE_ID = B.SCM_SITE_ID
	WHERE 1=1
	  AND ( ( @p_division_id		IS NULL OR  @p_division_id = ''	) OR	 B.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
	  AND ( @p_item_id IS NULL OR A.ITEM_ID LIKE @p_item_id + '%' OR 
			(SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-'  WHEN X.NICK_NAME = ''    THEN '-'  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID) LIKE @p_item_id + '%') 
	  AND ( @p_jig_name IS NULL OR B.JIG_NAME LIKE '%' + @p_jig_name + '%' ) 
	  AND ( ( @p_valid_yn	IS NULL OR  @p_valid_yn = ''		) OR A.VALID_YN = @p_valid_yn)
	  ORDER BY B.DIVISION_ID, B.JIG_NAME, A.ITEM_ID
	;

	--validation용 전체조회
	SELECT  CONVERT(NVARCHAR(MAX), JIG_ITEM_SEQ) AS JIG_ITEM_SEQ
			, CONVERT(NVARCHAR(MAX), JIG_SEQ) AS JIG_SEQ
			, ITEM_ID
			, CONVERT(NVARCHAR(10),dbo.fn_char_to_date(FROM_YYYYMMDD),121) AS FROM_YYYYMMDD 
		    , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(TO_YYYYMMDD)  ,121) AS TO_YYYYMMDD 
			, VALID_YN
			, '-' ACTION_FLAG_DIV
	FROM SCP_MST_JIG_ITEM
	;

END



