/****************************************************************************************************/
/* Program ID  : [DMF0006_GET_CUSTOMERMODELMAPPING]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST]    
      @p_dq_id                NVARCHAR(MAX),
	  @p_dq_name              NVARCHAR(MAX),
	  @p_role                 NVARCHAR(MAX)
 
AS  
  -- [DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST] '','','DM/SCP'
  -- EXEC DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST @p_dq_id='33', @p_dq_name='', @p_role=''
BEGIN
  SET NOCOUNT ON;

With tmpDQ AS
(
SELECT 
       A.[DQ_ID]
      ,A.[DIVISION_ID]
      ,A.[DQ_NAME]
      ,A.DESCRIPTION 
      ,A.DQ_TEXT 
      ,A.[VALID_YN]
      ,A.[ADMIN_ONLY_YN]
      ,A.[CREATED_BY]
      ,A.[CREATION_DATE]
      ,A.[LAST_UPDATED_BY]
      ,A.[LAST_UPDATE_DATE]

	  ,'ALL,' + ISNULL(STUFF((
		SELECT ',' + B.GROUP_ID
		FROM (SELECT * FROM dbo.SCM_ADM_DQ_USER_GROUP WHERE VALID_YN ='Y') B  
		LEFT JOIN (SELECT * FROM [dbo].[TB_FX_GroupInfo] WHERE [UseYN] ='Y') C
		ON B.GROUP_ID = C.[GroupID]
		WHERE
		B.DQ_ID = A.DQ_ID 		
		FOR XML PATH('')
		),1,1,''),'') AS GROUP_ID

		,ISNULL(STUFF((
		SELECT ',' + C.GrpName
		FROM (SELECT * FROM dbo.SCM_ADM_DQ_USER_GROUP WHERE VALID_YN ='Y') B  
		LEFT JOIN (SELECT * FROM [dbo].[TB_FX_GroupInfo] WHERE [UseYN] ='Y') C
		ON B.GROUP_ID = C.[GroupID]
		WHERE
		B.DQ_ID = A.DQ_ID 		
		FOR XML PATH('')
		),1,1,''),'ALL') AS GROUP_NAME
FROM [dbo].[SCM_ADM_DQ_LIST] A
WHERE 1=1			
		AND Exists (Select * from dbo.UF_FX_String_Split (@p_dq_id,',') as P Where A.DQ_ID LIKE N'' + P.token +'%')
		AND Exists (Select * from dbo.UF_FX_String_Split (@p_dq_name,',') as P Where A.DQ_NAME LIKE N'' + P.token +'%')
)

SELECT 
[DQ_ID]
,[DIVISION_ID]
,[DQ_NAME]
,DESCRIPTION 
,DQ_TEXT 
,[VALID_YN]
,[ADMIN_ONLY_YN]
,[CREATED_BY]
,[CREATION_DATE]
,[LAST_UPDATED_BY]
,[LAST_UPDATE_DATE]
,GROUP_ID
,GROUP_NAME
FROM tmpDQ
WHERE 1=1
	AND Exists (Select * from dbo.UF_FX_String_Split (@p_role,',') as P Where GROUP_ID LIKE  N'%' + P.token +'%')
 

END

