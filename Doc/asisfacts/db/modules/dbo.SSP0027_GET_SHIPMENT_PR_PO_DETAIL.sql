

/*
 * Program ID   : SSP0027_GET_SHIPMENT_PR_PO_DETAIL
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-03-23   KIMYONGHO      신규추가
 * 2023-03-10   jilee          PR_REQ_QTY != 0 아니면 PR_CHECK,PR_NO,PR_CONFIRM_DATE 조회 수정

 */

CREATE PROCEDURE [dbo].[SSP0027_GET_SHIPMENT_PR_PO_DETAIL]
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
	,@p_sheet_name			NVARCHAR(MAX) = 'PR PO Detail'
	,@debug_mode			NVARCHAR(1)='T'

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
	CASE WHEN  ((B.ATTRIBUTE1 = 'Complete') OR (A.HOLD_FLAG = 'Y')) AND B.PR_REQ_QTY != 0 THEN 'True' ELSE 'False' END AS PR_CHECK
	, A.DM_REQ_NO
	, ISNULL(C.ERP_PO_STATUS,'-') AS ERP_PO_STATUS
	, A.DIVISION_ID 
	, A.PROJECT_CODE
	, A.ITEM_SEQ
	, A.ITEM_ID
	, ISNULL(T.ITEM_NAME,'-') AS ITEM_NAME
	, CONVERT(VARCHAR(10), CONVERT(DATETIME, A.YYYYMMDD), 23) AS DM_REQUEST_DATE		-- DM REQUEST DATE
	, A.PLAN_QTY		-- FCST INPUT QTY
	, DPD.PR_ITEM_DETAIL
	, A.INV_ALLO_QTY	-- Inventory Netting QTY
	, E.INV_ALLO_QTY	AS AUTO_NET_QTY
	-- ITEM NAME
	, CASE WHEN  ((B.ATTRIBUTE1 = 'Complete') OR (A.HOLD_FLAG = 'Y')) AND B.PR_REQ_QTY != 0 THEN ISNULL(B.PR_NO,'-') ELSE NULL END AS PR_NO
	--, CONVERT(VARCHAR(10), CONVERT(DATETIME, B.PR_CONFIRM_DATE), 23) AS PR_CONFIRM_DATE
	, CASE WHEN  (B.ATTRIBUTE1 = 'Complete') AND B.PR_REQ_QTY != 0 THEN B.LAST_UPDATE_DATE ELSE NULL END AS PR_CONFIRM_DATE
	, B.PR_REQ_QTY
	, A.UOM
	, A.PLANT_SITE_ID
	, A.SCM_SITE_ID
	, A.SLOC_ID
	, A.SLOC_PLANT_ID
	, A.PUCH_GROUP
	, A.DM_REQUESTED_BY
	--, CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + A.DM_REQUESTED_BY + ')' DM_REQUESTED_BY    
	--, A.DM_REQUESTED_BY  + '(' + A.LAST_UPDATED_BY + ')' DM_REQUESTED_BY    
	, A.PUCH_MGR
	, C.VENDOR_CODE
	, C.VENDOR_NAME
	, C.PO_NO
	, CASE WHEN C.PO_END_FLAG  = 'X' THEN 'Y' ELSE 'N' END AS PO_END_FLAG
	, CONVERT(VARCHAR(10), CONVERT(DATETIME, C.YYYYMMDD), 23) AS PO_RTF_DATE		-- PO_RTF_DATE DATE
	, CONVERT(VARCHAR(10), CONVERT(DATETIME, C.PO_CREATED_DATE), 23) AS PO_CREATED_DATE		-- PO_CREATED_DATE
	, C.PO_CREATED_DATE	AS PO_CREATED_DATE
	, C.PO_ITEM_SEQ
	, C.PO_ITEM_ID
	-- PO ITEM NAME
	, C.PO_QTY
	, C.UOM
	, D.PO_ITEM_IN_QTY
	--, G.OWNER
	, DBO.FN_GET_SSP_MKT_OWNER_NAME (G.OWNER, '', @p_language) AS MKT_OWNER
	--, ISNULL(G.DEPT_NAME_KO,'-') AS TEAM
	, (SELECT ISNULL(DEPT_NAME_KO,'-')
		FROM   SCM_MST_SSO_DEPT_INFO  AA WITH(NOLOCK)
		LEFT OUTER JOIN TB_FX_User BB WITH(NOLOCK)
		ON AA.DEPT_ID = BB.DEPT_ID
		WHERE BB.UserID = A.ATTRIBUTE1
		) AS TEAM
	, C.ATTRIBUTE1 -- PO 단가
	, C.ATTRIBUTE2 -- 통화
	FROM SSP_ANL_ESS_REQ A WITH(NOLOCK)

	JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)		
		ON A.ITEM_ID		= T.ITEM_ID		
	    AND A.DIVISION_ID	= T.DIVISION_ID	
	    AND T.COMPANY_ID	= @p_company_id
		AND T.ITEM_TYPE		IN ('Q','R')
	   
	LEFT OUTER JOIN SSP_ANL_ESS_PR B WITH(NOLOCK)
		ON A.DM_REQ_NO		= B.DM_REQ_NO
		AND A.ITEM_SEQ		= B.PR_ITEM_SEQ
		AND A.ITEM_ID		= B.PR_ITEM_ID
	LEFT OUTER JOIN SSP_ANL_ESS_PO C WITH(NOLOCK)
		ON B.PR_NO			= C.PR_NO
		--AND B.PR_ITEM_SEQ	= C.PO_ITEM_SEQ
		AND B.PR_ITEM_ID	= C.PO_ITEM_ID	
	LEFT OUTER JOIN (
		SELECT PR_NO, PO_NO, PO_ITEM_SEQ, PO_ITEM_ID, SUM(PO_ITEM_IN_QTY) AS PO_ITEM_IN_QTY
		FROM SSP_ANL_ESS_PO_IN WITH(NOLOCK) 
		GROUP BY PR_NO, PO_NO, PO_ITEM_SEQ, PO_ITEM_ID
	) D
		ON C.PO_NO			= D.PO_NO
		and c.PR_NO			= D.PR_NO
		--AND C.PO_ITEM_SEQ	= D.PO_ITEM_SEQ
		AND C.PO_ITEM_ID	= D.PO_ITEM_ID

	LEFT OUTER JOIN SSP_ANL_ESS_REQ_NET E WITH(NOLOCK)
		ON E.DM_REQ_NO				= A.DM_REQ_NO
		AND E.ITEM_ID				= A.ITEM_ID
		AND E.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd

	LEFT OUTER JOIN DM_PLN_PR_DETAIL DPD WITH(NOLOCK)
		ON A.DM_REQ_NO		= DPD.REQUEST_NO
		AND A.ITEM_ID		= DPD.ITEM_ID
		AND A.SCM_SITE_ID	= DPD.SCM_SITE_ID
		AND A.PROJECT_CODE	= DPD.PROJECT_CODE
		AND A.YYYYMMDD		= DPD.YYYYMMDD

	LEFT OUTER JOIN TB_FX_User U ON A.DM_REQUESTED_BY = U.UserID AND U.UseYN = 'Y'    
										
	LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_NAME_KO, OWNER										 
	 	  	FROM(																						                         
	 	  		SELECT aa.DIVISION_ID, aa.PROJECT_CODE, aa.SCM_SITE_ID, aa.ITEM_ID,ac.DEPT_NAME_KO, OWNER								
	 	  				,ROW_NUMBER() over(partition by aa.DIVISION_ID, aa.SCM_SITE_ID, aa.project_code, aa.ITEM_ID order by aa.PROJECT_CODE) num
	 	  		FROM scm_mst_site_item aa WITH(NOLOCK)																				         
	 	  		LEFT OUTER JOIN SCM_MST_SITE  BB WITH(NOLOCK) 																	
	 	  			ON BB.SCM_SITE_ID = aa.SCM_SITE_ID																			
	 	  		LEFT OUTER JOIN SCM_MST_SSO_USER_INFO  ab WITH(NOLOCK) 															
	 	  			ON  ab.USER_ID = aa.OWNER																				     
	 	  		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  ac WITH(NOLOCK) 															
	 	  			ON  bb.DEPT_ID = ac.DEPT_ID																				     
	 	  	) a WHERE num = 1) g on g.DIVISION_ID =  a.DIVISION_ID and g.SCM_SITE_ID = a.SCM_SITE_ID and g.ITEM_ID = a.ITEM_ID	and g.project_Code = a.project_Code

	WHERE A.YYYYMMDD >= @p_from_yyyymmdd
	  AND A.YYYYMMDD <= @p_to_yyyymmdd
	  AND ((@p_item_id IS NULL OR @p_item_id ='')	OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
	  AND ((@p_project_code IS NULL OR @p_project_code ='')	OR A.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
	  AND ((@p_requestor IS NULL OR @p_requestor ='')	OR A.DM_REQUESTED_BY IN (SELECT token FROM dbo.String_Split(@p_requestor, ',')))
	ORDER BY DM_REQ_NO, PROJECT_CODE, ITEM_ID, ITEM_SEQ
	;



	--SELECT * FROM SSP_ANL_ESS_PR


END

