/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0027_GET_DM_DYNAMIC_QUERYS]    
    @v_sql_text              NVARCHAR(MAX)
	

AS  
  
BEGIN
  SET NOCOUNT ON;

  DECLARE @v_log_type     NVARCHAR(30); 
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;

      BEGIN TRY
      BEGIN
		
		  EXEC SP_EXECUTESQL @v_sql_text;

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

 --[DMF0027_GET_DM_DYNAMIC_QUERYS] 'SELECT * FROM [SCM_ADM_DQ_LIST]'
 --[DMF0027_GET_DM_DYNAMIC_QUERYS]  ' EXEC [DMF0027_GET_DM_DYNAMIC_QUERYS] ''SELECT * FROM [SCM_ADM_DQ_LIST]'''
