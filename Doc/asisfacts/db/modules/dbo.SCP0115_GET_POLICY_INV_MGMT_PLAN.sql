
/*
 * Program ID   : SCP0115_GET_POLICY_INV_MGMT_PLAN 
 * Description  : SCP0115 Policy Inv Management Main View
 * Program History
 *===================================================================================================
 * Date         In Charge			Description
 *===================================================================================================
 * 2024/10/12   Haru			    Add new procedures to get Main view Data
 * 2024/12/31	TanVQ1				New Column REQUEST_NO
 */

CREATE PROCEDURE [dbo].[SCP0115_GET_POLICY_INV_MGMT_PLAN]
	@p_plan_date			NVARCHAR(8),
	@p_division_id			NVARCHAR(500),	
	@p_category_id			NVARCHAR(500),
	@p_item_id				NVARCHAR(500),
	@p_plant_id				NVARCHAR(500),
	@p_from_yyyymmdd		NVARCHAR(8),
	@p_to_yyyymmdd			NVARCHAR(8)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	--SELECT  'W' + CAST(DATEPART(WEEK, CONVERT(DATE, CAST(CAST(PLAN_START_YYYYMMDD AS CHAR(8)) AS DATE), 112)) AS VARCHAR) + '-' + FORMAT(CONVERT(DATE, CAST(CAST(PLN.PLAN_START_YYYYMMDD AS CHAR(8)) AS DATE), 112), 'yyyyMMdd') AS PLAN_DATE
	SELECT	PLN.REQUEST_NO AS REQUEST_NO
			,PLN.PLAN_START_YYYYMMDD		AS PLAN_DATE
       		,PLN.PLAN_TP_CD             AS PLAN_TP_CD
       		,( SELECT ATTRIBUTE1
           	   FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
           	   WHERE  LOOKUP_TYPE      = 'SCM_LGTM_PCY_INV_PLAN_TYPE'
           	   AND    SEGMENT1         = PLN.PLAN_TP_CD
           	   AND     VALID_YN = 'Y'  
       		)                       AS PLAN_TP_DESC
       		,PLN.OCCR_RSN_CD        AS OCCR_RSN_CD
       		,( SELECT ATTRIBUTE1
           	   FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
           	   WHERE  LOOKUP_TYPE      = 'SCM_LGTM_PCY_INV_OCCR_RSN_CD'
           	   AND    SEGMENT1         = PLN.PLAN_TP_CD
           	   AND    SEGMENT2         = PLN.OCCR_RSN_CD
           	   AND     VALID_YN = 'Y'  
       		)                       AS OCCR_RSN_DESC
       		,PLN.OCCR_RSN_CTN       AS OCCR_RSN_CTN
       		,PLN.EXHT_TP_CD         AS EXHT_TP_CD
       		,( SELECT ATTRIBUTE1
           	   FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
           	   WHERE  LOOKUP_TYPE      = 'SCM_LGTM_PCY_EXHT_TP_CD'
           	   AND    SEGMENT1         = PLN.PLAN_TP_CD
           	   AND    SEGMENT2         = PLN.EXHT_TP_CD
           	   AND     VALID_YN = 'Y'  
       		)                       AS EXHT_TP_DESC
       		,PLN.EXHT_TP_CTN        AS EXHT_TP_CTN
			,PLN.COMPANY_ID			AS COMPANY_ID
			,PLN.DIVISION_ID		AS DIVISION_ID
       		,PLN.PLANT_ID           AS PLANT_ID
       		,SMS.PLANT_DESC         AS PLANT_DESC
       		,PLN.ITEM_ID            AS ITEM_ID
       		,SIM.ITEM_NAME          AS ITEM_NAME
       		,STCM.CLASS_ID          AS ITEM_CLASS
       		,STCM.CLASS_NAME        AS ITEM_CLASS_NAME
       		,PLN.QTY                AS QTY 
       		,SIM.ITEM_UOM           AS UOM
       		,PLN.PLAN_YYYYMMDD      AS ETA
       		,PLN.SUPPLIER_CODE      AS SUPPLIER_CODE
       		,''                     AS SUPPLIER_NAME
       		,PLN.LAST_UPDATED_BY        AS USER_ID
       		,PLN.LAST_UPDATE_DATE   AS UPDATE_DATE
	FROM    SCP_ANL_LGTM_PCY_INV_MGMT_PLAN PLN WITH(NOLOCK)
       		LEFT OUTER JOIN (   SELECT  PLANT_ID, MAX(COMPANY_ID) AS COMPANY_ID, MAX(DIVISION_ID) AS DIVISION_ID, MAX(SM.SITE_DESCRIPTION) PLANT_DESC
                           		FROM    SCM_MST_SITE SM WITH(NOLOCK)
                           		WHERE   1=1
                           		AND     SM.SITE_TYPE   = 'PLANT'  
                           		GROUP BY PLANT_ID ) SMS  
               		ON   SMS.DIVISION_ID = PLN.DIVISION_ID
               		AND  SMS.PLANT_ID    = PLN.PLANT_ID
       		LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
           		ON  SIM.DIVISION_ID = SMS.DIVISION_ID
           		AND SIM.COMPANY_ID  = SMS.COMPANY_ID
           		AND SIM.ITEM_ID     = PLN.ITEM_ID
       		LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M STCM WITH(NOLOCK)
           		ON  STCM.CLASS_ID   = SIM.ITEM_CLASS
	WHERE	PLN.PLAN_START_YYYYMMDD = @p_plan_date
	AND		(ISNULL(@p_division_id, '') = '' OR PLN.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
	AND		(ISNULL(@p_plant_id, '') = '' OR PLN.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
	AND		(ISNULL(@p_category_id, '') = '' OR PLN.PLAN_TP_CD IN (SELECT token FROM dbo.String_Split(@p_category_id,',')) )
	AND		(ISNULL(@p_item_id, '') = '' OR PLN.ITEM_ID  IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	AND		PLN.PLAN_YYYYMMDD >= @p_from_yyyymmdd 
	AND		PLN.PLAN_YYYYMMDD <= @p_to_yyyymmdd
	ORDER BY PLN.PLAN_START_YYYYMMDD    			
       		,PLN.PLAN_TP_CD
       		,PLAN_TP_DESC
			,PLN.OCCR_RSN_CD
       		,OCCR_RSN_DESC
       		,PLN.OCCR_RSN_CTN 
       		,PLN.EXHT_TP_CD 
       		,EXHT_TP_DESC
       		,PLN.EXHT_TP_CTN  
			,PLN.COMPANY_ID
			,PLN.DIVISION_ID
       		,PLN.PLANT_ID      
       		,SMS.PLANT_DESC        
       		,PLN.ITEM_ID       
       		,SIM.ITEM_NAME     
       		,STCM.CLASS_ID        
       		,STCM.CLASS_NAME    

END

