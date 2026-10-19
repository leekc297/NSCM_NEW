/****************************************************************************************************/
/* Program ID  : [DMF0002_GET_WEEK_TO_DAY_DATA]                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/11/15  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0002_GET_WEEK_TO_DAY_DATA]
  @p_division_id  NVARCHAR(30),
  @p_site_id      NVARCHAR(30)
AS  
  
BEGIN
  SET NOCOUNT ON;

  --DECLARE @v_sql_text       AS NVARCHAR(MAX);  
  
  --SET @v_sql_text = '
    SELECT A.DIVISION_ID
         , B.END_CUSTOMER
      	 , A.SCM_SITE_ID
   --      , SUM(CASE WHEN A.YYYYMMDD = 'MON' THEN A.BUCKET_PER ELSE '' END) AS D_MON
		 --, SUM(CASE WHEN A.YYYYMMDD = 'TUE' THEN A.BUCKET_PER ELSE '' END) AS D_TUE
		 --, SUM(CASE WHEN A.YYYYMMDD = 'WED' THEN A.BUCKET_PER ELSE '' END) AS D_WED
		 --, SUM(CASE WHEN A.YYYYMMDD = 'THU' THEN A.BUCKET_PER ELSE '' END) AS D_THU	
		 --, SUM(CASE WHEN A.YYYYMMDD = 'FRI' THEN A.BUCKET_PER ELSE '' END) AS D_FRI
		 --, SUM(CASE WHEN A.YYYYMMDD = 'SAT' THEN A.BUCKET_PER ELSE '' END) AS D_SAT
		 --, SUM(CASE WHEN A.YYYYMMDD = 'SUN' THEN A.BUCKET_PER ELSE '' END) AS D_SUN
    FROM   [dbo].[DM_MST_BUCKET_CONVERSION] A WITH(NOLOCK)
         , [dbo].[SCM_MST_SITE]             B WITH(NOLOCK)
    WHERE  A.SCM_SITE_ID = B.SCM_SITE_ID
    AND    A.CONVERSION_TYPE = 'WTOD'
    AND    CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
                ELSE A.DIVISION_ID
	       END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                    FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                    CROSS APPLY x.nodes('/t') t(c)
	               )
    AND    CASE WHEN @p_site_id = 'ALL' THEN 'ALL'
                ELSE A.SCM_SITE_ID
	       END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                    FROM   (SELECT x = CAST('<t>' + REPLACE(@p_site_id, ',', '</t><t>') + '</t>' AS xml)) b
                    CROSS APPLY x.nodes('/t') t(c)
	               )     
	GROUP BY A.DIVISION_ID
           , B.END_CUSTOMER
           , A.SCM_SITE_ID
	;
 
  
								  
END

