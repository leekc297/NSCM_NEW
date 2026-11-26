update znerp_dev_item_schedule set code_success_yn = @CODE_SUCCESS_YN,  note2 = @REASON
    where 1=1
    and work_type = 'astep'
    and param1 = 'move'
    and item_id = @ITEM_ID