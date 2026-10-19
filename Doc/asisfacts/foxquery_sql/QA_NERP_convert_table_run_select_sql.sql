DECLARE @count_sql nvarchar(4000) = '';
      SELECT @count_sql = WORK_DETAIL2 from znerp_dev_item_schedule with(nolock) where seq = @seq;
      exec sp_executesql @count_sql