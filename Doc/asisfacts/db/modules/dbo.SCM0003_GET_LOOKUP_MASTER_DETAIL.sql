


/*
 * Program ID   : SCM0003_GET_LOOKUP_MASTER_DETAIL
 * Description  : Lookup Value 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/14   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2021/05/26   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - 공유잠금 해제 옵션 추가
 */

CREATE PROCEDURE [dbo].[SCM0003_GET_LOOKUP_MASTER_DETAIL]
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
		  ,segment1 segment1_key
		  ,segment2 segment2_key
		  ,segment3 segment3_key
		  ,segment4 segment4_key
		  ,segment5 segment5_key
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
	 FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	 WHERE (@p_lookup_type IS NULL OR lookup_type = @p_lookup_type)
	 order by display_seq
	 ;
  
END

