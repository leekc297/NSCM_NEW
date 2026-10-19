
/*
 * PROGRAM ID   : SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode) DETAIL
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-07-29   KIMYONGHO		신규추가
 *
 */
 
create PROCEDURE [dbo].[SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL]
	  @p_division_id			VARCHAR(10)
	, @p_company_id			NVARCHAR(10)
	, @p_from_site				NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_model_id				NVARCHAR(MAX)
	, @p_nick_name				NVARCHAR(MAX)
	, @p_requestor				NVARCHAR(MAX)
	, @p_plan_start_yyyymmdd		NVARCHAR(8)
	, @p_from_yyyymmdd			NVARCHAR(8)
	, @p_to_yyyymmdd			NVARCHAR(8)
	, @p_dbl_flag				CHAR(1)
	, @p_real_flag				CHAR(1)
	, @p_language				NVARCHAR(MAX) = 'KO'
	, @p_program_id			NVARCHAR(MAX) = 'SSP0023'
	, @p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan Detail Excel'
	, @p_non_chk				CHAR(1)
	, @p_my_model_chk			CHAR(1)
	, @p_delegatee_chk			CHAR(1)
	, @p_part_leader_chk		CHAR(1)
	, @p_team_leader_chk		CHAR(1)
	, @p_user_id				NVARCHAR(MAX)
	, @debug_mode				NVARCHAR(1)='T'
AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry NVARCHAR(MAX)='';

	DECLARE  @v_division_id NVARCHAR(MAX) = '';
	DECLARE  @v_from_site NVARCHAR(MAX)   = '';
	DECLARE  @v_item_id NVARCHAR(MAX)     = '';
	DECLARE  @v_model_id NVARCHAR(MAX)     = '';
	DECLARE  @v_nick_name NVARCHAR(MAX)     = '';
	DECLARE  @v_requestor NVARCHAR(MAX)   = '';

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id   = [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_model_id  = [dbo].FN_GET_IN_STR(@p_model_id);
	SET @v_nick_name = [dbo].FN_GET_IN_STR(@p_nick_name);
	SET @v_requestor = @p_requestor;


	SELECT A.COMPANY_ID        AS COMPANY_ID
      , A.DIVISION_ID		  AS DIVISION_ID
      , A.SCM_SITE_ID		  AS FROM_SITE
      , A.ITEM_ID			  AS ITEM_ID
	 , A.YYYYMMDD			  AS YYYYMMDD
	 , ISNULL(B.QTY, 0)		  AS QTY
	 , NULL				  AS Comment
	FROM   (
			SELECT B.COMPANY_ID
				 , B.DIVISION_ID
				 , B.PLANT_ID
				 , B.SCM_SITE_ID
				 , B.MODEL_ID
				 , B.ITEM_ID
				 , A.YYYYMMDD
			FROM   SSP_MST_SHIP_CALENDAR   A WITH(NOLOCK)
				   JOIN SSP_ANL_SHIP_PLAN_EE B WITH(NOLOCK)
				   ON   B.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				 AND  B.COMPANY_ID  = @p_company_id
				   AND  B.DIVISION_ID = @p_division_id
				   AND  B.SCM_SITE_ID    LIKE '%'
				   AND  B.MODEL_ID       LIKE '%'
				    AND ((@P_ITEM_ID   IS NULL OR @P_ITEM_ID ='' )	    OR B.ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_ITEM_ID, ','))) 
				   AND  B.MEASURE     = 'P_SHIP_PLAN_SIMU_ETD'
				   AND  B.COMPANY_ID  = A.COMPANY_ID
				   AND  B.DIVISION_ID = A.DIVISION_ID
			WHERE  1 = 1
			AND    A.DIVISION_ID = @p_division_id
			AND    A.COMPANY_ID  = @p_company_id
			AND    A.YYYYMMDD   >= @p_from_yyyymmdd
			AND    A.YYYYMMDD   < = @p_to_yyyymmdd
			GROUP BY B.COMPANY_ID
				 , B.DIVISION_ID
				 , B.PLANT_ID
				 , B.SCM_SITE_ID
				 , B.MODEL_ID
				 , B.ITEM_ID
				 , A.YYYYMMDD
		   ) A
		   LEFT OUTER JOIN SSP_ANL_SHIP_PLAN_EE B WITH(NOLOCK)
		   ON   B.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		   AND  B.COMPANY_ID  = @p_company_id
		   AND  B.DIVISION_ID = @p_division_id

		   AND  B.SCM_SITE_ID        LIKE '%'
		   AND  B.MODEL_ID       LIKE '%'
		   AND ((@P_ITEM_ID   IS NULL OR @P_ITEM_ID ='' )	    OR B.ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_ITEM_ID, ','))) 
		   AND  B.MEASURE     = 'P_SHIP_PLAN_SIMU_ETD'
		   AND  B.QTY > 0
		   AND  A.COMPANY_ID  = B.COMPANY_ID
		   AND  A.DIVISION_ID = B.DIVISION_ID
		   AND  A.PLANT_ID    = B.PLANT_ID
		   AND  A.SCM_SITE_ID        = B.SCM_SITE_ID
		   AND  A.MODEL_ID         = B.MODEL_ID
		   AND  A.ITEM_ID          = B.ITEM_ID
		   AND  A.YYYYMMDD         = B.YYYYMMDD
	WHERE  1 = 1
	ORDER BY A.ITEM_ID, A.YYYYMMDD 
	;


END
