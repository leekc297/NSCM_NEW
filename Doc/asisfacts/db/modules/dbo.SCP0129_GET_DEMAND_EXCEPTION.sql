


/*
 * Program ID   : SCP0129_GET_DEMAND_EXCEPTION
 * Description  : 수요제외(DEMAND EXCEPTION) 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 *
 */

CREATE PROCEDURE [dbo].[SCP0129_GET_DEMAND_EXCEPTION]
	  @p_division_id		NVARCHAR(MAX)
	, @p_plan_group_id	    NVARCHAR(MAX)
	, @p_scm_site_id		NVARCHAR(MAX)
	, @p_item_id			NVARCHAR(MAX)
	, @p_stage   	        NVARCHAR(MAX)
	, @p_valid_yn			NVARCHAR(MAX)

    , @p_period_from		NVARCHAR(MAX)
    , @p_period_to			NVARCHAR(MAX)

AS
BEGIN
	
  SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- 파라미터로 받을 값 변수  
  DECLARE @v_division_id		NVARCHAR(200)	= @p_division_id
  DECLARE @v_plan_group_id		NVARCHAR(200)	= @p_plan_group_id
  DECLARE @v_scm_site_id		NVARCHAR(200)	= @p_scm_site_id
  DECLARE @v_item_id		    NVARCHAR(200)	= @p_item_id
  DECLARE @v_stage           	NVARCHAR(200)	= @p_stage
  DECLARE @v_valid_yn		    NVARCHAR(200)	= @p_valid_yn

  DECLARE @v_period_from		NVARCHAR(200)	= @p_period_from
  DECLARE @v_period_to		    NVARCHAR(200)	= @p_period_to

  SELECT a.DIVISION_ID
        ,a.OPMZ_PLAN_GR_ID
        ,a.SCM_SITE_ID
        ,a.ITEM_ID
        ,a.STAGE
        , CONVERT(date, a.FROM_YYYYMMDD, 112) AS FROM_YYYYMMDD
        , CONVERT(date, a.TO_YYYYMMDD, 112) AS TO_YYYYMMDD
        ,a.ATTRIBUTE1   as  STOCK_EXCEPTION
        ,a.VALUE_DESCRIPTION
        ,a.VALID_YN
        ,a.CREATED_BY
        ,a.CREATION_DATE
        ,a.LAST_UPDATED_BY
        ,a.LAST_UPDATE_DATE
        ,a.DIVISION_ID+ '|' + a.OPMZ_PLAN_GR_ID+ '|' + a.SCM_SITE_ID+ '|' + a.ITEM_ID + '|' + a.FROM_YYYYMMDD+ '|' +  a.TO_YYYYMMDD  + '|' + a.STAGE AS PRE_KEY_VALUES
    FROM DBO.SCP_OPMZ_DEMAND_EXCEPTION a  with(nolock)
    INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
            ON a.ITEM_ID  like  b.tst 

    WHERE 1=1
    AND ( ( @v_division_id   IS NULL OR @v_division_id = '' )   OR a.DIVISION_ID     IN (SELECT token FROM dbo.String_Split(@v_division_id  ,',')) )
    AND ( ( @v_scm_site_id   IS NULL OR @v_scm_site_id = '' )   OR a.SCM_SITE_ID     IN (SELECT token FROM dbo.String_Split(@v_scm_site_id  ,',')) )
    AND ( ( @p_valid_yn      IS NULL OR @v_valid_yn   = '' )    OR a.VALID_YN        IN (SELECT token FROM dbo.String_Split(@v_valid_yn  ,',')) )
    AND ( ( @v_plan_group_id IS NULL OR @v_plan_group_id = '' ) OR a.OPMZ_PLAN_GR_ID IN (SELECT token FROM dbo.String_Split(@v_plan_group_id  ,',')) )
    AND ( ( @v_stage         IS NULL OR @v_stage = '' )         OR a.STAGE           IN (SELECT token FROM dbo.String_Split(@v_stage  ,',')) )
    AND  FROM_YYYYMMDD  <=  @v_period_to 
    AND  TO_YYYYMMDD    >= @v_period_from
  
END

