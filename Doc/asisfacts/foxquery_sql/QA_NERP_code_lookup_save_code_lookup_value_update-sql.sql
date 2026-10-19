BEGIN
					        BEGIN TRAN

merge into LGCE_SCMDEV.dbo.SCM_CODE_LOOKUP_VALUE A
using
(
	select @lookup_type_code AS LOOKUP_TYPE_CODE, @SEGMENT1 as SEGMENT1,@SEGMENT2 as SEGMENT2,@SEGMENT3 as SEGMENT3,@SEGMENT4 as SEGMENT4,@SEGMENT5 as SEGMENT5
) B
on
A.lookup_type_code = B.lookup_type_code
and A.segment1 = b.segment1
and A.segment2 = b.segment2
and A.segment3 = b.segment3
and A.segment4 = b.segment4
and A.segment5 = b.segment5

When matched then
Update Set 
segment1 = @SEGMENT1
,segment2 = @SEGMENT2
,segment3 = @SEGMENT3
,segment4 = @SEGMENT4
,segment5 = @SEGMENT5
,attribute1 = @attribute1
,attribute2 = @attribute2
,attribute3 = @attribute3
,sort_order =isnull(@sort_order,'0')
,active_flag = isnull(@active_flag,'Y')
,value_description = @value_description
, modify_user_id = @user_id
,modify_date = getdate()
when not matched then
insert (
lookup_type_code
,segment1
,segment2 
,segment3
,segment4
,segment5
,attribute1
,attribute2
,attribute3
,sort_order 
,active_flag 
,value_description 
,create_user_id 
,create_date 
,modify_user_id 
,modify_date )
values
(
@lookup_type_code
,@segment1
,@segment2 
,@segment3
,@segment4
,@segment5
,@attribute1
,@attribute2
,@attribute3
,isnull(@sort_order,'0')
,isnull(@active_flag,'Y')
,@value_description 
,@user_id 
,getdate() 
,@user_id 
,getdate()
);
   

        COMMIT;       
        
        
      END;