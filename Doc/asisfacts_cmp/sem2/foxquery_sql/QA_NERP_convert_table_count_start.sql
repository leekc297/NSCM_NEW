update znerp_dev_item_schedule set go_count = getdate(), update_time = getdate(),
update_user  = @USER_ID, note3 = @REASON
    where 1=1
    and item_id = @ITEM_ID