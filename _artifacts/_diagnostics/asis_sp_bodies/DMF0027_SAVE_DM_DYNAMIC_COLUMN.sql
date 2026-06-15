/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/15  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0027_SAVE_DM_DYNAMIC_COLUMN]    
    @p_active_flag              NVARCHAR(MAX),
	@p_dq_id			NVARCHAR(MAX),
	@p_column_name		NVARCHAR(MAX),
	@p_valid_yn NVARCHAR(MAX),
	@p_updatedby NVARCHAR(MAX)
/*
[DQ_ID]
,[COLUMN_NAME]
,[VALUE_YN]
,[VALUE_TYPE]
,[VALID_YN]
,[CREATED_BY]
*/
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



	IF @p_active_flag = 'I'
	BEGIN	
    INSERT INTO [dbo].[SCM_ADM_DQ_COLUMN]
           ([DQ_ID]
           ,[COLUMN_NAME]
           ,[VALUE_YN]
           ,[VALUE_TYPE]
           ,[VALID_YN]
           ,[CREATED_BY]
           ,[CREATION_DATE]
           ,[LAST_UPDATED_BY]
           ,[LAST_UPDATE_DATE])
     VALUES
           (@p_dq_id
           ,@p_column_name
           ,''
           ,''
           ,@p_valid_yn
           ,'TEST'
           ,getdate()
           ,@p_updatedby
           ,getdate()
		   )
   END

    IF @p_active_flag = 'M'

            BEGIN
UPDATE [dbo].[SCM_ADM_DQ_COLUMN]
   SET 
       [VALUE_YN] = ''
      ,[VALUE_TYPE] = ''
      ,[VALID_YN] = @p_valid_yn
      
      ,[LAST_UPDATED_BY] = @p_updatedby
      ,[LAST_UPDATE_DATE] = GETDATE()
 WHERE
      [DQ_ID] = @p_dq_id
      AND [COLUMN_NAME] = @p_column_name

			END


 IF @p_active_flag = 'D'

            BEGIN

DELETE FROM [dbo].[SCM_ADM_DQ_COLUMN]
      WHERE 
      [DQ_ID] = @p_dq_id
      AND [COLUMN_NAME] = @p_column_name


			END

	  END
      END TRY
	  BEGIN CATCH
		  -- ERROR LOG
		  SET @v_log_type = 'ERROR';
		  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		  SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));;
		  SET @d_event_date = SYSDATETIME();

		  SELECT '99' AS CODE, @v_log_message + @v_description AS DES
	  END CATCH

END

