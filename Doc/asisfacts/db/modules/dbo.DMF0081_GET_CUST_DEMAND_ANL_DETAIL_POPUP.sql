 
/*
 * Program ID  : [DMF0081_GET_CUST_DEMAND_ANL_DETAIL]
 * Author:		<Author,,Name>
 * Create date: <Create Date,,>
 * Description  : 고객수요증감 팝업 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2024.11.05		dsiol		   1개의 ROW씩 INSERT 한다. (여러번 실행 되는 프로시저)
 /* 2024-12-10  dsiol    [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 */  
 */
CREATE PROCEDURE [dbo].[DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP]
	@p_division_id	NVARCHAR(30),
	@p_end_customer NVARCHAR(50),
    @p_project_code NVARCHAR(50),
	@p_measure		NVARCHAR(50),
	@p_yyyymm       NVARCHAR(6),
	@p_created_by	NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;	

	SELECT
	 DTL.DIVISION_ID  -- Visible False
	,DTL.END_CUSTOMER -- Visible False
	,DTL.PROJECT_CODE -- Visible False
	,DTL.MEASURE      -- Visible False
	,DTL.PLAN_YYYYMM  -- Visible False
	,0 AS EDI_QTY
	,DTL.QTY AS CHANGE_QTY
	,(SELECT DISTINCT ATTRIBUTE1
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	  WHERE LK.LOOKUP_TYPE = 'DM_DEMAND_GAP_ANL_CD' AND LK.VALID_YN = 'Y' AND LK.SEGMENT1 = DTL.REQ_RSN_CD) AS REQ_RSN_CD
	,(SELECT DISTINCT ATTRIBUTE2
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	  WHERE LK.LOOKUP_TYPE = 'DM_DEMAND_GAP_ANL_CD' AND LK.VALID_YN = 'Y' AND LK.SEGMENT2 = DTL.DIF_ANLS_TP_CD) AS DIF_ANLS_TP_CD
	,(SELECT DISTINCT ATTRIBUTE3
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	  WHERE LK.LOOKUP_TYPE = 'DM_DEMAND_GAP_ANL_CD' AND LK.VALID_YN = 'Y' AND LK.SEGMENT3 = DTL.ANLS_DIF_RSN_CD) AS ANLS_DIF_RSN_CD
	,DTL.REQ_RSN_DTL_CTN
	,0 AS RESULT
	,0 AS MKT_DP
	,0 AS GAP
	FROM DM_CUST_DEMAND_ANL_DETAIL AS DTL WITH(NOLOCK)
	WHERE DTL.DIVISION_ID  = @p_division_id 
	AND   DTL.END_CUSTOMER = @p_end_customer 
	AND   DTL.PROJECT_CODE = @p_project_code
	AND   DTL.MEASURE      = @p_measure
	AND   DTL.PLAN_YYYYMM  = @p_yyyymm
	ORDER BY DTL.CREATION_DATE
	--ORDER BY DTL.REQ_RSN_CD,DTL.DIF_ANLS_TP_CD,DTL.ANLS_DIF_RSN_CD

END