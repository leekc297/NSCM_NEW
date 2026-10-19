


/*
 * Program ID   : SCP0120_GET_LOOKUP_MASTER
 * Description  : Constraint Mgmt Lookup Type 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/17   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/11   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Target 대상, Onwer 정보 추가
 *
 */

CREATE PROCEDURE [dbo].[SCP0120_GET_LOOKUP_MASTER]
  @p_lookup_type    NVARCHAR(MAX)
  , @p_admin_yn NVARCHAR(1)
  , @p_valid_yn NVARCHAR(1)

AS
BEGIN
	
    SET NOCOUNT ON;

    SELECT
		 lookup_type as lookup_type_key 
		  ,lookup_type
		  ,description
		  ,lookup_group
		  ,valid_yn
		  ,segment1
		  ,segment2
		  ,segment3
		  ,segment4
		  ,segment5
		  ,segment6
		  ,segment7
		  ,segment8
		  ,segment9
		  ,segment10
		  ,attribute1
		  ,attribute2
		  ,attribute3
		  ,attribute4
		  ,attribute5
		  ,attribute6
		  ,attribute7
		  ,attribute8
		  ,attribute9
		  ,attribute10
		  ,attribute11
		  ,attribute12
		  ,attribute13
		  ,attribute14
		  ,attribute15
		  ,created_by
		  ,creation_date
		  ,last_updated_by
		  ,last_update_date
	 FROM dbo.SCP_OPMZ_LOOKUP_MASTER
     WHERE  ( @p_lookup_type IS NULL OR lookup_type LIKE '%' + @p_lookup_type + '%' ) 
	 AND ( (@p_valid_yn	IS NULL OR  @p_valid_yn = '') OR (valid_yn = @p_valid_yn) )
	 AND segment10 NOT IN (CASE WHEN @p_admin_yn = 'Y' THEN '' ELSE 'Y' END)
	 ORDER BY lookup_type
	 ;
  
END

