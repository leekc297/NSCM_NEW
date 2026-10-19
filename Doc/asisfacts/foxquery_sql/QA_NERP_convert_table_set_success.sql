update znerp_dev_item_schedule set success_yn = @SUCCESS_YN,  note2 = @REASON
    where 1=1
    and work_type = 'astep'
    and param1 = 'move'
    and item_id = @ITEM_ID