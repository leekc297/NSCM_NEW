/****************************************************************************************************/
/* Program ID  : [DMF0006_GET_CUSTOMERMODELMAPPING]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS]    
      @p_dq_id                NVARCHAR(MAX) --,
	  --@p_dq_name              NVARCHAR(MAX),
	  --@p_role                 NVARCHAR(MAX)

	  -- EXEC DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS @p_dq_id='27'
 
AS  
  -- [] '2','',''
BEGIN
  SET NOCOUNT ON;

SELECT 
       [DQ_ID]
      ,[PARAMETER_ID]
      ,PARAMETER_TYPE
      ,OPERATION_ID 
      ,[VALID_YN]
      ,REP_YN 
      ,[CREATED_BY]
      ,[CREATION_DATE]
      ,[LAST_UPDATED_BY]
      ,[LAST_UPDATE_DATE]
	  ,ISNULL(ATTRIBUTE1,'0') AS SEQNO   
  FROM [dbo].[SCM_ADM_DQ_PARAMETER] A
  WHERE
  [DQ_ID] = @p_dq_id

  ORDER BY CAST(ISNULL(ATTRIBUTE1,'0') AS INT), [LAST_UPDATE_DATE]

  /*
WHERE
CASE WHEN @p_dq_id = '' THEN ''
		ELSE A.[DQ_ID]		
END IN (
		Select * from dbo.UF_FX_String_SplitForIN (@p_dq_id,',') as P Where 
		(CASE WHEN @p_dq_id = '' THEN '' ELSE A.[DQ_ID] END) = P.data
	    )
AND
Exists (Select * from dbo.UF_FX_String_Split (@p_dq_name,',') as P Where A.DQ_NAME LIKE P.token +'%')
*/



END


