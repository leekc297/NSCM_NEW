
/*
 * Program ID   : SCM0003_GET_LOOKUP_VALUES
 * Description  : Lookup Master 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/14   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0003_GET_LOOKUP_VALUES]
  @p_lookup_type    NVARCHAR(MAX)

AS
BEGIN
	
    SET NOCOUNT ON;
	DECLARE @v_sql_text AS NVARCHAR(MAX);

    SELECT 
		   division_id
		  ,lookup_type
		  ,lookup_code
		  ,description  
		  ,display_seq
		  ,default_value_flag
		  ,valid_yn
		  ,segment1
		  ,segment2
		  ,segment3
		  ,attribute1
		  ,attribute2
		  ,attribute3
		  ,attribute4
		  ,attribute5
		  ,created_by
		  ,creation_date
		  ,last_updated_by
		  ,last_update_date
	 FROM LGCE_SCMDEV.dbo.SCM_ADM_LOOKUP_VALUES
	 WHERE (@p_lookup_type IS NULL OR lookup_type = @p_lookup_type)
	 order by display_seq
	 ;
  
END


