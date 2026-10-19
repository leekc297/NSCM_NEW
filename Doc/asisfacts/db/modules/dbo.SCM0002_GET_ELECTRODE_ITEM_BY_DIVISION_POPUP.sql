
/*
 * Program ID   : SCM0002_GET_ELECTRODE_ITEM_BY_DIVISION_POPUP
 * Description  : 전극 Model Popup
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/06/29   ygkim			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/12/17	hwyoon			복수 division 선택 조회
 *
 */

CREATE PROCEDURE [dbo].[SCM0002_GET_ELECTRODE_ITEM_BY_DIVISION_POPUP]
  @p_division_id   NVARCHAR(30),
  @p_item_id       NVARCHAR(100)

AS
BEGIN
	
    SET NOCOUNT ON;
	
	select A.DIVISION_ID
		  ,MIN(C.DIVISION_NAME)   AS DIVISION_NAME
		  ,A.ITEM_ID
		  ,B.ITEM_NAME
		  ,B.ITEM_TYPE
		  ,B.NICK_NAME
		  ,B.ITEM_CLASS_NAME
	from SCP_MST_FINAL_ITEM a with(nolock)
	INNER JOIN SCM_MST_ITEM_SN B with(nolock) ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
	INNER JOIN SCM_MST_DIVISION C with(nolock) ON A.DIVISION_ID = C.DIVISION_ID
	WHERE A.OPERATION_GROUP = 'E'
	  AND (@p_division_id='' OR @p_division_id IS NULL OR A.DIVISION_ID IN ( SELECT value FROM dbo.FN_SplitString (@p_division_id,',') ))
	  --AND A.DIVISION_ID = @p_division_id
	  AND    (   A.ITEM_ID   LIKE '%' + @p_item_id + '%' 
			  OR B.ITEM_NAME LIKE '%' + @p_item_id + '%'
			  OR B.NICK_NAME LIKE '%' + @p_item_id + '%'
			   )
	GROUP BY A.DIVISION_ID
		  ,A.ITEM_ID
		  ,B.ITEM_NAME
		  ,B.ITEM_TYPE
		  ,B.NICK_NAME
		  ,B.ITEM_CLASS_NAME
	ORDER BY A.DIVISION_ID
		  ,A.ITEM_ID
		  ,B.ITEM_NAME
		  ,B.ITEM_TYPE
		  ,B.NICK_NAME
		  ,B.ITEM_CLASS_NAME
	;				
  
END

