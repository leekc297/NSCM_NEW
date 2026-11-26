BEGIN
        BEGIN TRAN
          merge into SCM_ADM_NOTICE_CONTENT_MASTER m
using (select @notice_id as notice_id) e
on m.notice_id = e.notice_id

when matched then
    update set 
	language_code = isnull(@language_code,'EN')
	, notice_title = @notice_title
	, notice_content = @notice_content
	, notice_image = @notice_image
	, notice_image_id = @notice_id
	,last_updated_by = @user_id
	,last_update_date = getdate()
	when not matched then
	insert 
	(notice_id,notice_title, notice_content,notice_image,notice_image_id, language_code,
	created_by, last_updated_by, creation_date, last_update_date)
	values
	(@notice_id,@notice_title, @notice_content,@notice_image,@notice_id, isnull(@language_code,'EN'),
	@user_id, @user_id, getdate(),getdate())
          ;
        
        COMMIT;
      END;