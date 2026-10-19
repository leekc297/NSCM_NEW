select   *
 from znerp_dev_item_schedule with(nolock)
    where 1=1
    and work_type = 'astep'
    and param1 = 'move'
    and table_div1 = 'H'
    and item_id like '%' + @ITEM_ID + '%'
    --and (item_id like '%@ITEM_ID%' OR item_id = '')
    --and (param1 = @PARAM1 or isnull(@PARAM1,'')='')
    --and (param2 = @PARAM2 or isnull(@PARAM2,'')='')
    --and (param3 = @PARAM3 or isnull(@PARAM3,'')='')
    --and (param4 = @PARAM4 or isnull(@PARAM4,'')='')
    --and (param5 = @PARAM5 or isnull(@PARAM5,'')='')
    --and (work_detail1 = @WORK_DETAIL1 or isnull(@WORK_DETAIL1,'')='')
    order by WORK_GROUP, WORK_TYPE,Param1,TOTAL_CNT desc, ITEM_ID