/*
 * Program ID   : [SCP0090_GET_ALLO_TARGET_REQUEST]
 * Description  : ALLO_TARGET_REQUEST 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/02/11   LWY   Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 * 2022/07/28   LWY   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Allo_Target_Request 개선
 * 2022/09/28   LWY   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Allo_Target_Request 설계변경으로 개발
 */

CREATE PROCEDURE [dbo].[SCP0090_GET_ALLO_TARGET_REQUEST]
	 --@p_cutoff_yyyymmdd NVARCHAR(8)
	 @p_from_yyyymmdd	NVARCHAR(8)
    ,@p_to_yyyymmdd		NVARCHAR(8)
	,@p_from_model		NVARCHAR(400)
	,@p_from_team		NVARCHAR(200)
	,@p_from_month		NVARCHAR(12)
	,@p_to_model		NVARCHAR(400)
	,@p_to_team			NVARCHAR(200)
	,@p_to_month		NVARCHAR(12)
	,@p_confirmYN		NVARCHAR(2)

AS
BEGIN

	DECLARE @v_division_id NVARCHAR(30);
	SET @v_division_id = '40';
		
	SELECT	 SEQ
	        ,CUTOFF_YYYYMMDD			
			,FROM_ITEM_ID
			,DBO.FN_GET_ITEM_NICKNAME(@v_division_id, FROM_ITEM_ID) AS FROM_NICK_NAME
			,FROM_DEPT_ID
			--,FROM_DEPT_ID as FROM_DEPT_NAME
			,FROM_DEPT_NAME
			,FROM_YYYYMM
			,FROM_QTY
			,TO_ITEM_ID
			,DBO.FN_GET_ITEM_NICKNAME(@v_division_id, TO_ITEM_ID) AS TO_NICK_NAME
			,TO_DEPT_ID
			--,TO_DEPT_ID as TO_DEPT_NAME
			,TO_DEPT_NAME
			,TO_YYYYMM
			,TO_QTY
			,ATTRIBUTE1 AS TO_QTY_TOBE			
			,COMMENTS
			,CONFIRM
			,ATTRIBUTE10 AS CONFIRM_COMMENTS
			,REQUEST_USER
			,REQUEST_DATE
			,CONFIRM_USER
			,CONFIRM_DATE
	FROM dbo.SCP_ANL_ALLO_TARGET_REQUEST WITH(NOLOCK)
	WHERE 1 = 1	
	  
	  --AND (( @p_cutoff_yyyymmdd	IS NULL OR  @p_cutoff_yyyymmdd = '' ) OR CUTOFF_YYYYMMDD LIKE '%' + @p_cutoff_yyyymmdd +'%')
	  AND CUTOFF_YYYYMMDD >= @p_from_yyyymmdd
	  AND CUTOFF_YYYYMMDD <= @p_to_yyyymmdd
	  
	  AND (( @p_from_model IS NULL OR  @p_from_model = '' ) OR FROM_ITEM_ID	LIKE '%' + @p_from_model +'%')
	  AND (( @p_from_team	IS NULL OR @p_from_team = '' ) OR FROM_DEPT_ID IN (SELECT token FROM dbo.String_Split(@p_from_team, ',')))
	  AND (( @p_from_month IS NULL OR  @p_from_month = '' ) OR FROM_YYYYMM	LIKE '%' + @p_from_month +'%')

	  AND (( @p_to_model IS NULL OR  @p_to_model = '' ) OR TO_ITEM_ID	LIKE '%' + @p_to_model +'%')
	  AND (( @p_to_team	IS NULL OR @p_to_team = '' ) OR TO_DEPT_ID IN (SELECT token FROM dbo.String_Split(@p_to_team, ',')))
	  AND (( @p_to_month IS NULL OR  @p_to_month = '' ) OR TO_YYYYMM	LIKE '%' + @p_to_month +'%')

	  AND (( @p_confirmYN IS NULL OR @p_confirmYN = '' ) OR CONFIRM	= @p_confirmYN )
	
	ORDER BY CUTOFF_YYYYMMDD, FROM_ITEM_ID, FROM_DEPT_ID, FROM_YYYYMM DESC
	
	;
		


END





