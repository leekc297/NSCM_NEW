


/*
 * Program ID   : SCP0120_GET_LOOKUP_MASTER_DETAIL
 * Description  : Constraint Mgm Lookup Value 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/17   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/10   kimcd			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 order by 수정
 */

CREATE PROCEDURE [dbo].[SCP0120_GET_LOOKUP_MASTER_DETAIL]
  @p_lookup_type    NVARCHAR(MAX)

AS
BEGIN
	
    SET NOCOUNT ON;
	DECLARE @v_sql_text AS NVARCHAR(MAX);

    SELECT 
		  lookup_type
		  ,description  
		  ,display_seq
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
		  ,segment1 segment1_key
		  ,segment2 segment2_key
		  ,segment3 segment3_key
		  ,segment4 segment4_key
		  ,segment5 segment5_key
		  ,segment6 segment6_key
		  ,segment7 segment7_key
		  ,segment8 segment8_key
		  ,segment9 segment9_key
		  ,segment10 segment10_key
		  ,valid_yn		  
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
	 FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	 WHERE (@p_lookup_type IS NULL OR lookup_type = @p_lookup_type)
	 order by display_seq, segment1, segment2, segment3, segment4, segment5, segment6, segment7, segment8, segment9
			, attribute1, attribute2, attribute3, attribute4, attribute5, attribute6, attribute7, attribute8, attribute9
			, attribute10, attribute11, attribute12, attribute13, attribute14,attribute15
	 -- 2025/06/10   kimcd			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 order by 수정
	 ;
  
END

