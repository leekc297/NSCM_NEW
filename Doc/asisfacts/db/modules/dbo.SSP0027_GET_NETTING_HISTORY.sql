


/*
 * Program ID   : SSP0027_GET_NETTING_HISTORY
 * Description  : NETTING_HISTORY
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-03-23   KIMYONGHO      신규추가
 * 2024-10-01   KHJ            NERP_SSP

 */

CREATE PROCEDURE [dbo].[SSP0027_GET_NETTING_HISTORY]
	 @p_division_id			VARCHAR(10)
	,@p_company_id			NVARCHAR(10)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_project_code		NVARCHAR(MAX)
	,@p_requestor			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_dbl_flag			CHAR(1)
	,@p_real_flag			CHAR(1)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_program_id			NVARCHAR(MAX) = 'SSP0027'
	,@p_sheet_name			NVARCHAR(MAX) = 'NET History'
	,@debug_mode			NVARCHAR(1)='T'

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- NERP 매핑코드
    DECLARE @v_Storage_6006 NVARCHAR(20);
	SET @v_Storage_6006 = dbo.FN_GET_LOOKUP_VALUE('SSP0027_GET_NETTING_HISTORY'  ,'STORAGE_6006')


	SELECT DISTINCT
	--CASE WHEN B.PR_NO IS NULL THEN 'False' ELSE 'True' END AS PR_CHECK
	A.DM_REQ_NO
	--, C.ERP_PO_STATUS
	--, A.DIVISION_ID 
	, A.ITEM_ID
	, ISNULL(T.ITEM_NAME,'-') AS ITEM_NAME
	--, A.ITEM_SEQ
	, A.PROJECT_CODE
	, ISNULL(E.INV_QTY,0) AS INV_QTY
	, ISNULL(N.PLAN_QTY,0) AS PLAN_QTY				-- FCST INPUT QTY
	, ISNULL(N.INV_ALLO_QTY,0) AS INV_ALLO_QTY  	-- Inventory Netting QTY
	, ISNULL(E.INV_QTY - (SELECT SUM(INV_ALLO_QTY) FROM SSP_ANL_ESS_REQ_NET WHERE PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND A.ITEM_ID = ITEM_ID AND DM_REQ_NO <= A.DM_REQ_NO),0) AS EOH_QTY
	, CASE WHEN E.INV_QTY <> 0 THEN  N.PLAN_QTY - N.INV_ALLO_QTY ELSE 0 END	AS PR_QTY
	, CONVERT(VARCHAR(10), CONVERT(DATETIME, A.YYYYMMDD), 23)  AS YYYYMMDD
	, A.DM_REQUEST_DATE
	
	FROM SSP_ANL_ESS_REQ A WITH(NOLOCK)

	INNER JOIN SSP_ANL_ESS_REQ_NET N WITH (NOLOCK)
		ON A.DM_REQ_NO		= N.DM_REQ_NO
		AND A.ITEM_ID		= N.ITEM_ID

	LEFT OUTER JOIN SSP_ANL_ESS_STOCK E WITH (NOLOCK)
		ON A.DIVISION_ID = E.DIVISION_ID
		AND A.ITEM_ID	 = E.ITEM_ID
		AND E.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND E.STORAGE_ID = @v_Storage_6006			--'6006'
	
	LEFT OUTER JOIN SCM_MST_ITEM_SN T WITH(NOLOCK)		
		ON  A.ITEM_ID		= T.ITEM_ID		
	    AND A.DIVISION_ID	= T.DIVISION_ID	
	    AND T.COMPANY_ID	= @p_company_id
		AND T.ITEM_TYPE		= 'Q'


	WHERE 1=1
	 AND N.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
	  AND A.YYYYMMDD >= @p_from_yyyymmdd
	  AND A.YYYYMMDD <= @p_to_yyyymmdd
	  AND A.NET_YN = 'Y'
	  AND ((@p_item_id IS NULL OR @p_item_id ='')	OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
	  AND ((@p_project_code IS NULL OR @p_project_code ='')	OR A.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
	  AND ((@p_requestor IS NULL OR @p_requestor ='')	OR A.DM_REQUESTED_BY IN (SELECT token FROM dbo.String_Split(@p_requestor, ',')))


	ORDER BY ITEM_ID, DM_REQ_NO
	;


END

