
/*
 * Program ID   : SCM0003_GET_LOOKUP_MASTER_DETAIL_NERP
 * Description  : Lookup Value 조회 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/12/14   byunghunjung   NERP )  Lookup Value 조회 - 하드코딩 대응 및 개선
 ----------------------------------------------------------------------------------------------------
 exec SCM0003_GET_LOOKUP_MASTER_DETAIL_NERP 'NERP_HARD_CODE_COMPANY', 'ESOC',null,'ASIS'
 exec SCM0003_GET_LOOKUP_MASTER_DETAIL_NERP 'NERP_HARD_CODE_COMPANY', 'ESOC',null,'NERP'
 */

CREATE PROCEDURE [dbo].[SCM0003_GET_LOOKUP_MASTER_DETAIL_NERP]
  @p_lookup_type    NVARCHAR(200)
 ,@p_param1			NVARCHAR(200)
 ,@p_param2			NVARCHAR(200)
 ,@p_use_code       NVARCHAR(8)
AS
BEGIN

    SET NOCOUNT ON;
	DECLARE @v_sql_text AS NVARCHAR(MAX);

	---------------------------------------------------------
	-- COMPANY, PLANT, STORAGE
	---------------------------------------------------------
    SELECT 
		  CASE 
		  WHEN @p_use_code = 'NERP' 
		  THEN segment4 -- TOBE
		  ELSE segment3 -- ASIS
		  END AS VALUE
	 FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	 WHERE lookup_type = @p_lookup_type
	   AND segment1 = @p_param1
	   AND (@p_param2 IS NULL OR segment2 = @p_param2)
	 order by display_seq
	 ;
  
END

