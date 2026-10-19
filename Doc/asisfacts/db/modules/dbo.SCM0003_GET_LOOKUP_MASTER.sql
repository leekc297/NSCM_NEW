


/*
 * Program ID   : SCM0003_GET_LOOKUP_MASTER
 * Description  : Lookup Master 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/14   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0003_GET_LOOKUP_MASTER]
  @p_lookup_type    NVARCHAR(MAX),
  @p_lookup_group   NVARCHAR(MAX),
  @p_valid_yn		NVARCHAR(100)

AS
BEGIN
	
    SET NOCOUNT ON;

    SELECT
		 lookup_type lookup_type_key 
		  ,lookup_type
		  ,description
		  ,lookup_group
		  ,valid_yn
		  ,segment1
		  ,segment2
		  ,segment3
		  ,segment4
		  ,segment5
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
	 FROM dbo.SCM_ADM_LOOKUP_MASTER
     WHERE  ( @p_lookup_type IS NULL OR lookup_type LIKE '%' + @p_lookup_type + '%' ) 
	 AND (@p_lookup_group IS NULL OR lookup_group = @p_lookup_group)
	 AND (@p_valid_yn IS NULL OR valid_yn = @p_valid_yn)
	 ORDER BY lookup_type
	 ;
  
END

