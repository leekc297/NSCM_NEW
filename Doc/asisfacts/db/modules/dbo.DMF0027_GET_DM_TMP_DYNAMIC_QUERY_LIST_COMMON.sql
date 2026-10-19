/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON]    
    @p_nickname              NVARCHAR(MAX)
	

AS  
  -- EXEC DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON @p_nickname='ROLES'
BEGIN
  SET NOCOUNT ON;

  DECLARE @v_log_type     NVARCHAR(30); 
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;

      BEGIN TRY
      BEGIN
			IF(@p_nickname = 'COLTYPES')
			BEGIN
				SELECT 'System.String' AS CODE, 'String' AS NAME
				UNION ALL
				SELECT 'System.Int' AS CODE, 'Int' AS NAME
				UNION ALL
				SELECT 'System.Date' AS CODE, 'Date' AS NAME
			END

			ELSE IF(@p_nickname = 'COMBO')
			BEGIN
				SELECT 'DIVISION_ID' AS CODE, 'DIVISION_ID' AS NAME
				UNION ALL
				SELECT 'SCM_SITE_ID' AS CODE, 'SCM_SITE_ID' AS NAME				
			END
			
			ELSE IF(@p_nickname = 'AGGREGATE')
			BEGIN
				--SELECT 'GROUP' AS CODE, 'GROUP' AS NAME
				--UNION ALL				
				SELECT 'SUM' AS CODE, 'SUM' AS NAME
				UNION ALL
				SELECT 'MAX' AS CODE, 'MAX' AS NAME		
				UNION ALL
				SELECT 'MIN' AS CODE, 'MIN' AS NAME		
				UNION ALL
				SELECT 'COUNT' AS CODE, 'COUNT' AS NAME			
			END		

			ELSE IF(@p_nickname = 'OPORATOR')
			BEGIN
				SELECT '=' AS CODE, '=' AS NAME
				UNION ALL
				SELECT 'IN' AS CODE, 'IN' AS NAME		
				UNION ALL
				SELECT 'LIKE' AS CODE, 'LIKE' AS NAME		
				UNION ALL
				SELECT '>' AS CODE, '>' AS NAME		
				UNION ALL
				SELECT '<' AS CODE, '<' AS NAME			
			END		

			ELSE IF(@p_nickname = 'ROLES')
			BEGIN
					SELECT 
					   [GroupID]		AS CODE
					  ,[GrpName]		AS NAME      	
					FROM [dbo].[TB_FX_GroupInfo] WITH(NOLOCK)	
					WHERE
					[UseYN] = 'Y'		
			END	

			ELSE IF(@p_nickname = 'BIZ_TYPE')
			BEGIN
		select
			SEGMENT1 as code ,
			SEGMENT2 as name
		from SCM_ADM_LOOKUP_MASTER_DETAIL
		where LOOKUP_TYPE ='BIZ_TYPE_BPMS'
		order by DISPLAY_SEQ	
			END	

			ELSE IF(@p_nickname = 'ITEM_TYPE_CODE')
			BEGIN
				 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
				 FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					WHERE
					VALID_YN ='Y' 
					AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'	
					ORDER BY DISPLAY_SEQ	
			END

			ELSE IF(@p_nickname = 'INCOTERMS')
			BEGIN
					SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
					FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					WHERE
					VALID_YN ='Y' 
					AND LOOKUP_TYPE = 'INCOTERMS'	
					ORDER BY DISPLAY_SEQ	
			END

	  END
      END TRY
	  BEGIN CATCH
		  -- ERROR LOG
		  SET @v_log_type = 'ERROR';
		  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		  SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));;
		  SET @d_event_date = SYSDATETIME();

		  SELECT '99^ERR' AS CODE, @v_log_message + @v_description AS DES
	  END CATCH

END


--[DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2] 'SELECT * FROM [TB_FX_GroupInf'
