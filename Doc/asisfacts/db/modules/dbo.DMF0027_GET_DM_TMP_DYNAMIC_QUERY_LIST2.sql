/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2019/04/16  JYE			쿼리 인젝션 방비 수정 */
/* 2019/04/25  JYE			쿼리 인젝션 방비 수정2 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2]    
    @v_sql_text              NVARCHAR(MAX)
AS  
  
BEGIN
  SET NOCOUNT ON;

  DECLARE @v_log_type     NVARCHAR(30); 
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  DECLARE @s_query  NVARCHAR(MAX);

      BEGIN TRY
      BEGIN
		  SET @s_query = dbo.FN_GET_NORMAL_STRING2(@v_sql_text)

		  EXEC SP_EXECUTESQL @s_query;

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
