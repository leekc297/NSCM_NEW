/*
 * Program ID   @ SSP0015_GET_MES_STOCK
 * Description  @ MES Stock
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021-10-20   KIMYONGHO		신규추가
 ex)
*/

create PROCEDURE [dbo].[SSP0015_GET_SCS_STOCK]
	 @p_division_id			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	-------------------------------------------------------------------------
	,@p_user_id				NVARCHAR(MAX)
	,@p_myModelChk			NVARCHAR(MAX)
	,@p_partLeaderChk		NVARCHAR(MAX)
	,@p_teamLeaderChk		NVARCHAR(MAX)
	,@p_delegateeChk		NVARCHAR(MAX)
	,@p_nonChk				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SELECT A.DIVISION_ID
		, A.CUTOFF_DATE
		, A.SCM_SITE_ID AS PLANT_ID
		, B.SITE_DESCRIPTION AS PLANT_NAME
		, A.ITEM_ID AS MODEL_ID
		, convert(varchar(10),  CONVERT(DATETIME,A.STOCK_DATE), 120)  AS PROD_DATE
		, '-' AS HOLD_YN
		, A.STOCK_QTY AS QTY
		, A.LAST_UPDATE_DATE
	FROM [DBO].[SCM_DNM_SCS_STOCK] A WITH(NOLOCK)
	INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
	ON A.DIVISION_ID = B.DIVISION_ID
		AND A.SCM_SITE_ID = B.SCM_SITE_ID
	LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK)
		ON  M.DIVISION_ID = A.DIVISION_ID
		and M.FROM_SITE = A.SCM_SITE_ID
		and M.ITEM_ID = A.ITEM_ID
		and M.VALID_YN = 'Y'
	WHERE A.DIVISION_ID = '40'
	AND  A.CUTOFF_DATE = CONVERT(CHAR(8), DATEADD(DD, -2, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112)
	AND A.CELL_PACK =  'P'
	AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR A.SCM_SITE_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site,',')) )
	AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR A.ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id,',')) )
	--체크박스 체크 여부 조회 시작(@p_nonChk = 'Y' : 체크박스 선택 안한 상태)
	AND ((@p_nonChk = 'Y' AND 1 = 1 OR M.USER_ID IN (SELECT CASE WHEN @p_myModelChk = 'Y' THEN @p_user_id ELSE 'X' END 
													UNION 
													SELECT CASE WHEN @p_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END 
													FROM SSP_MST_DELEGATE WHERE VALID_YN = 'Y' AND DELEGATEE_ID = @p_user_id GROUP BY USER_ID)
									OR M.PART_LEADER = CASE WHEN @p_partLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END	
									OR M.TEAM_LEADER = CASE WHEN @p_teamLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END))
	--체크박스 체크 여부 조회 끝
	ORDER BY A.SCM_SITE_ID,  A.ITEM_ID
END
