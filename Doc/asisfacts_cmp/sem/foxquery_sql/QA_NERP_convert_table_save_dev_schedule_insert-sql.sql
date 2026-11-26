BEGIN
					        BEGIN TRAN

merge into znerp_dev_item_schedule A
using (
select @SEQ as SEQ
) B ON 
A.seq = B.seq
WHEN Matched then
update set 
item_id = @item_id
,work_type = @work_type
,work_group = @work_group
,param1 = @param1
,param2 = @param2
,param3 = @param3
,param4 = @param4
,param5 = @param5
,CODE_SUCCESS_YN = @CODE_SUCCESS_YN
,SUCCESS_YN = @SUCCESS_YN
,work_detail1 = @work_detail1
,work_detail2 = @work_detail2
,work_detail3 = @work_detail3
,work_detail4 = @work_detail4
,manual_yn = @manual_yn
, update_user = @user_id
,update_time = getdate()
WHEN not matched then
insert (item_id, work_type,work_group, param1, param2, param3, param4, param5, 
work_detail1, work_detail2,  work_detail3,  work_detail4, 
manual_yn,
insert_user, insert_time, update_user, update_time)
values  (@item_id, @work_type,@work_group, @param1, @param2, @param3, @param4, @param5, 
@work_detail1, @work_detail2, @work_detail3, @work_detail4, 
@manual_yn,
@USER_ID, getdate(), @USER_ID, getdate())
;

        COMMIT;       
        
        
      END;