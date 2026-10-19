CREATE PROCEDURE [dbo].[SCM0007_GET_RECIPIENT_SMS_ASSIGN]
  @p_categoryID		NVARCHAR(MAX)
AS
BEGIN
	
		SELECT a.category_id
			  ,a.SMS_GROUP_NAME
			  ,a.SMS_PHONE
		FROM SCM_ADM_RECIPIENT_SMS_ASSIGN A WITH(NOLOCK)
		WHERE a.category_id   = @p_categoryID
		  ORDER BY a.sms_group_name
   ;
END




