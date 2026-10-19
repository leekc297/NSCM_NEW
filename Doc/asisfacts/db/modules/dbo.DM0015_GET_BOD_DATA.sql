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
CREATE procedure [dbo].[DM0015_GET_BOD_DATA]
  @p_division_id	NVARCHAR(MAX) = NULL,	--Division
  @p_bod_type		NVARCHAR(MAX),	--BOD Type
  @p_from_site_id	NVARCHAR(MAX),	--From Site
  @p_to_site_id     NVARCHAR(MAX),	--To Site
  @p_group			NVARCHAR(MAX),
  @p_user_id		NVARCHAR(MAX),
  
  @p_active_flag    NVARCHAR(MAX)
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
	SELECT S.[DIVISION_ID]
      ,[BOD_ID]
      ,[BOD_TYPE]
      ,[TO_SITE]
      ,[HUB_SLOC]
	  ,[END_CUSTOMER]
      ,[FROM_SITE]
      ,[INCOTERMS]
      ,[PRIORITY]
      ,[TRANSPORT_MODE]
      ,[PERIOD_SHIPSCH_MON]
      ,[PERIOD_SHIPSCH_TUE]
      ,[PERIOD_SHIPSCH_WED]
      ,[PERIOD_SHIPSCH_THU]
      ,[PERIOD_SHIPSCH_FRI]
      ,[PERIOD_SHIPSCH_SAT]
      ,[PERIOD_SHIPSCH_SUN]
      ,[POL]
      ,[POD]    
      ,[freight_forwarder]
      ,[SAFETY_STOCK]
      ,[PERIOD1_LT]
      ,[POL_CLEARANCE_LT]
      ,[PERIOD2_LT]
      ,[POD_CLEARANCE_LT]
      ,[PERIOD3_LT]
      ,[CUSTOMER_LT]
	  ,PERIOD1_LT+[POL_CLEARANCE_LT]+PERIOD2_LT+[POD_CLEARANCE_LT]+[PERIOD3_LT] AS LT_TOTAL
      ,S.[VALID_YN]
      ,S.[LAST_UPDATED_BY]
      ,S.[LAST_UPDATE_DATE]
  FROM [dbo].[SCM_MST_BOD] S  WITH(NOLOCK)
  LEFT JOIN SCM_MST_SITE T2   WITH(NOLOCK)
  ON S.TO_SITE = T2.SCM_SITE_ID
  AND S.DIVISION_ID = T2.DIVISION_ID
	WHERE 1 = 1	   
	AND S.DIVISION_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @p_group AND UserID = @p_user_id AND AuthType = 'D')
	AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
             ELSE S.DIVISION_ID
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
	AND CASE WHEN @p_bod_type = 'ALL' THEN 'ALL'
			 ELSE BOD_TYPE
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_bod_type, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
	AND CASE WHEN @p_from_site_id = 'ALL' THEN 'ALL'
			 ELSE FROM_SITE
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_from_site_id, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
	AND CASE WHEN @p_to_site_id = 'ALL' THEN 'ALL'
			 ELSE TO_SITE
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_to_site_id, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           ) 
	/*AND CASE WHEN @p_hub_sloc = 'ALL' THEN 'ALL'
			 ELSE TO_SITE
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_hub_sloc, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           ) 
			   */

    AND CASE WHEN @p_active_flag = 'ALL' THEN 'ALL'
	         ELSE S.VALID_YN
		END = @p_active_flag
   ;
  --'
  

  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_division_id]'  , @v_division_id);
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_upper_dept_id]'  , @v_upper_dept_id);
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_dept_id]'  , @v_dept_id);
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_scm_site_id]'  , @v_scm_site_id);
    
  --EXEC SP_EXECUTESQL @v_sql_text; 
								  
END


