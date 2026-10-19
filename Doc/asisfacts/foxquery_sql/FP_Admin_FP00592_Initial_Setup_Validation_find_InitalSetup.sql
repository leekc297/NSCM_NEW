select top 100 
 segment1 as instance_id,
 segment2 as setup_code,
 segment3 as setup_desc,
 active_flag ,
 segment1,segment2,segment3,segment4,segment5,
 attribute1,
 attribute2,
 attribute3,
 attribute4,
 attribute5,
 attribute6,
 attribute7,
 attribute8,
 attribute9
 from scm_sys_lookup_value with(nolock)
where 1=1
and lookup_type_code = 'INITIAL_SETTING_VALIDATION'
and active_flag = @ACTIVE_FLAG
order by sort_order asc