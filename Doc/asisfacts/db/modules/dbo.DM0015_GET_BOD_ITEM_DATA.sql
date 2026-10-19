/****************************************************************************************************/
/* Program ID  : DM0004_GET_SALES_SITE_DATA                                                         */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/15  JunheeJeen   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE procedure [dbo].[DM0015_GET_BOD_ITEM_DATA]
  @p_division_id	NVARCHAR(MAX),	--Division
  @p_bod_id			NVARCHAR(MAX)	--BOD id
  
AS  
  
BEGIN
  SET NOCOUNT ON;

  DECLARE @v_sql_text          AS NVARCHAR(MAX);

  --DECLARE @v_division_id         AS NVARCHAR(MAX);
  --DECLARE @v_upper_dept_id         AS NVARCHAR(MAX);
  --DECLARE @v_dept_id         AS NVARCHAR(MAX);
  --DECLARE @v_scm_site_id         AS NVARCHAR(MAX);
   
  --SET @v_sql_text = '
 --   WITH SALES_SITE AS 
	--(
	SELECT [DIVISION_ID]
      
      ,[BOD_ID]
      ,[ITEM_ID]
      ,[LOT_SIZE]
      ,[FROZEN_PERIOD]
      ,SUBSTRING([EFF_START_DATE],1,4)+'-'+SUBSTRING([EFF_START_DATE],5,2)+'-'+SUBSTRING([EFF_START_DATE],7,2) AS EFF_START_DATE
      ,SUBSTRING([EFF_END_DATE],1,4)+'-'+SUBSTRING([EFF_END_DATE],5,2)+'-'+SUBSTRING([EFF_END_DATE],7,2) AS EFF_END_DATE
	  ,VALID_YN
      ,[LAST_UPDATED_BY]
      ,[LAST_UPDATE_DATE]
  FROM [dbo].[SCM_MST_BOD_ITEM] S   WITH(NOLOCK)
	WHERE 1 = 1	   
	AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
             ELSE S.DIVISION_ID
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
	AND CASE WHEN @p_bod_id = 'ALL' THEN 'ALL'
			 ELSE BOD_ID
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_bod_id, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
	AND VALID_YN = 'Y'

   ;
  --'
  

  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_division_id]'  , @v_division_id);
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_upper_dept_id]'  , @v_upper_dept_id);
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_dept_id]'  , @v_dept_id);
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_scm_site_id]'  , @v_scm_site_id);
    
  --EXEC SP_EXECUTESQL @v_sql_text; 
								  
END


