---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





/*************************************************************************************************
* Program ID  : DMF0003_GET_PR_HISTORY_POPUP                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : View History POPUP 을 열 때 사용. 
* Parameter   :                                                                                  
*                                                                                                
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------
* 2021-04-20   HWI1993		[과제] PR POPUP
* 2021.06.25	hwi1993		Nick Name --> Item Name
* 2021.08.30	hwi1993		[C20210813-000004] [SCM PI] GSCM 상품 자재 PR 발행 시, 서비스 플랜트 추가 요청의 건
***************************************************************************************************/

/*


*/

CREATE PROCEDURE [dbo].[DMF0003_GET_PR_HISTORY_POPUP]
	@p_POPUP_TYPE		nvarchar(30),
    @p_division_id		NVARCHAR(30),
	@p_REQUEST_NO		NVARCHAR(30),
    @p_PROJECT_CODE		NVARCHAR(50),
    @p_SCM_SITE_ID		NVARCHAR(4000),
    @p_ITEM_ID	        NVARCHAR(4000),
	@p_DOM_EXP			NVARCHAR(4000),
	@p_FCST_TYPE		NVARCHAR(4000),
	@p_INCOTERMS		NVARCHAR(4000),
	@p_PLANT_SITE_ID	NVARCHAR(4000),
	@p_YYYYMMDD			NVARCHAR(8),
	@P_PLAN_QTY			NVARCHAR(4000),
	@p_CREATED_BY		NVARCHAR(100)
AS  
  
BEGIN
    SET NOCOUNT ON;

	DECLARE @V_PUCH_MGR				NVARCHAR(150)
			, @V_PUCH_GROUP			NVARCHAR(150)
			, @V_STORAGE_PLANT_ID	NVARCHAR(60)
			, @V_ERR_MSG			NVARCHAR(1000)
			, @v_ERR_CNT			NVARCHAR(10)

	
	-- POPUP_TYPE = View_PR 일 경우 MKT FCST 의 값을 이용해서 REQUEST_NO 를 찾아준다.
	IF ( @p_POPUP_TYPE = 'View_HISTORY')
	BEGIN

		-- MKT FCST UI 에서 받은 값을 이용해서 REQUEST NO 들을 찾는다.
		SELECT DIVISION_ID, REQUEST_NO, ITEM_SEQ
		INTO #T
		FROM DM_PLN_PR_DETAIL A
		WHERE DIVISION_ID = @P_DIVISION_ID
			AND PROJECT_CODE	= @P_PROJECT_CODE
			AND SCM_SITE_ID		= @P_SCM_SITE_ID
			AND ITEM_ID			= @P_ITEM_ID
			AND DOM_EXP			= @P_DOM_EXP
			AND FCST_TYPE		= @P_FCST_TYPE
			AND INCOTERMS		= @P_INCOTERMS
			AND ISNULL(PLANT_SITE_ID,'')	= ISNULL(@P_PLANT_SITE_ID,'')
			AND YYYYMMDD		= @P_YYYYMMDD

		IF NOT EXISTS ( SELECT * FROM #T )
		BEGIN
			SELECT N'HISTORY가 존재하지 않습니다.' AS ERR_MSG
		END

		-- DETAIL
		SELECT B.REQUEST_NO, B.CREATION_DATE as REQUEST_DATE
			, dbo.SCM_ARR_SPL_VAL(B.CREATED_BY, '^', 1) AS REQUESTED_BY
			, B.PLAN_QTY as ITEM_QTY, B.PR_ITEM_DETAIL as ITEM_DETAIL
			, B.PR_HEADER, B.PROJECT_CODE, B.ITEM_ID, C.ITEM_NAME, B.YYYYMMDD
		FROM #T A
		JOIN DM_PLN_PR_DETAIL B ON A.REQUEST_NO = B.REQUEST_NO AND A.ITEM_SEQ = B.ITEM_SEQ AND A.DIVISION_ID = B.DIVISION_ID
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B.ITEM_ID = C.ITEM_ID AND B.DIVISION_ID = C.DIVISION_ID
		ORDER BY A.REQUEST_NO DESC

		
		-- HEADER
		SELECT TOP 1 B.PR_HEADER, B.PROJECT_CODE, B.ITEM_ID, C.ITEM_NAME, B.YYYYMMDD
		FROM #T A
		JOIN DM_PLN_PR_DETAIL B ON A.REQUEST_NO = B.REQUEST_NO AND A.ITEM_SEQ = B.ITEM_SEQ AND A.DIVISION_ID = B.DIVISION_ID
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B.ITEM_ID = C.ITEM_ID AND B.DIVISION_ID = C.DIVISION_ID
		ORDER BY A.REQUEST_NO DESC
			
	END
	

END









