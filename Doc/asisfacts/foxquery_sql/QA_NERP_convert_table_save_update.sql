update znerp_dev_item_schedule set 
        success_cnt = @CNT,
        success_yn = case when expect_cnt=@CNT then 'Y' else 'N' end
        where SEQ = @SEQ