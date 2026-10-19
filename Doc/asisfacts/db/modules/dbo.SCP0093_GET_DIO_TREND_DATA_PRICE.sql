





/*
 * Program ID   : SCP0093_GET_DIO_TREND_DATA_PRICE
 * Description  : SCP0093 DIO TREND Report 화면의 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/03/24   vadabi3/hrkim	최초생성
 ----------------------------------------------------------------------------------------------------
 		SELECT UNIT_PRICE,  *
		FROM SCP_RPT_DIO_TREND_MM WITH(NOLOCK)
		WHERE 1=1
		AND AGGR_DV = 'CG'
		AND CATEGORY_DV = 'C'
		AND PLAN_START_YYYYMMDD = '20230313' -- PLAN DATE
		AND MEASURE = 'INV'   -- 재고
		AND YYYYMM = '202301' --- 해당 년월
		AND CELL_GROUP = '' -- 해당 셀그룹	

exec SCP0093_GET_DIO_TREND_DATA_PRICE
  @p_division_id             = ''
, @p_plan_start_yyyymmdd	 = '20230320'
, @p_yyyymmdd				 = '202301'
, @p_from_yyyymm			 = ''
, @p_to_yyyymm		         = ''
, @p_cell_group				 = 'E78'
, @p_item_id				 = ''
, @P_AGGR_DV				 = ''
, @P_CATEGORY				 = ''
, @p_user_id				 = ''
, @debug_mode				 = ''


 */
CREATE PROCEDURE [dbo].[SCP0093_GET_DIO_TREND_DATA_PRICE]
  @p_plan_start_yyyymmdd	NVARCHAR(8)		-- Plan Date
, @p_yyyymm				    NVARCHAR(8)		-- Plan Date
, @p_from_yyyymm			NVARCHAR(6)		-- Monthly bucket 조회 기간
, @p_to_yyyymm		        NVARCHAR(6)		-- Monthly bucket 조회 기간
, @p_division_id            NVARCHAR(30)	-- division
, @p_cell_group				NVARCHAR(30)	-- 모델 
, @p_item_id				NVARCHAR(150)	-- 모델 
, @P_AGGR_DV				NVARCHAR(10)	-- 집계구분 [MD : 모델(Item), CG: 셀그룹(Level4)]
, @P_CATEGORY				NVARCHAR(50)    -- Category 조건  = [Pack, Cell, Cell Convert]
, @p_user_id				NVARCHAR(30)    -- MEASURE 개인별 선택
, @debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	DECLARE @SEARCH_COUNT int = 0;
	DECLARE @SEARCH_yyyymmdd nvarchar(max);

	IF EXISTS (
				SELECT 1
				FROM SCP_RPT_DIO_TREND_MM A WITH(NOLOCK)
				WHERE 1=1
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND ( ISNULL(@p_yyyymm, '')			= '' OR A.YYYYMM		IN (SELECT token FROM dbo.String_Split(@p_yyyymm,',')) )
				AND ( ISNULL(@p_cell_group, '')		= '' OR A.CELL_GROUP	IN (SELECT token FROM dbo.String_Split(@p_cell_group,',')) )
				AND ( ISNULL(@p_division_id, '')	= '' OR A.division_id	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
				AND MEASURE = 'INV'   -- 재고
				AND A.AGGR_DV = 'CG'
				AND A.CATEGORY_DV = 'C'
	          )
		BEGIN
				SELECT  CELL_GROUP, UNIT_PRICE, UNIT_PRICE_LAST
				FROM SCP_RPT_DIO_TREND_MM A WITH(NOLOCK)
				WHERE 1=1
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND ( ISNULL(@p_yyyymm, '')			= '' OR A.YYYYMM		IN (SELECT token FROM dbo.String_Split(@p_yyyymm,',')) )
				AND ( ISNULL(@p_cell_group, '')		= '' OR A.CELL_GROUP	IN (SELECT token FROM dbo.String_Split(@p_cell_group,',')) )
				AND ( ISNULL(@p_division_id, '')	= '' OR A.division_id	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
				AND MEASURE = 'INV'   -- 재고
				AND A.AGGR_DV = 'CG'
				AND A.CATEGORY_DV = 'C'
				ORDER BY CELL_GROUP
		END

	ELSE 
		BEGIN
				SELECT @SEARCH_yyyymmdd = A.yyyymm
				FROM SCP_RPT_DIO_TREND_MM A WITH(NOLOCK)
				WHERE 1=1
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND ( ISNULL(@p_cell_group, '')		= '' OR A.CELL_GROUP	IN (SELECT token FROM dbo.String_Split(@p_cell_group,',')) )
				AND ( ISNULL(@p_division_id, '')	= '' OR A.division_id	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
				AND MEASURE = 'INV'   -- 재고
				AND A.AGGR_DV = 'CG'
				AND A.CATEGORY_DV = 'C'



				SELECT   CELL_GROUP, UNIT_PRICE, UNIT_PRICE_LAST
				FROM SCP_RPT_DIO_TREND_MM A WITH(NOLOCK)
				WHERE 1=1
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND ( ISNULL(@p_cell_group, '')		= '' OR A.CELL_GROUP	IN (SELECT token FROM dbo.String_Split(@p_cell_group,',')) )
				AND ( ISNULL(@p_division_id, '')	= '' OR A.division_id	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
				AND MEASURE = 'INV'   -- 재고
				AND A.AGGR_DV = 'CG'
				AND A.CATEGORY_DV = 'C'
				ORDER BY CELL_GROUP
		END






END
