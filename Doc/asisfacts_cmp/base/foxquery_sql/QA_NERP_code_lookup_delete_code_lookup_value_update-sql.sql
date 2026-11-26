BEGIN
					        BEGIN TRAN

merge into LGCE_SCMDEV.dbo.SCM_CODE_LOOKUP_VALUE A
using
(
	select @lookup_type_code AS LOOKUP_TYPE_CODE, @SEGMENT1 as SEGMENT1,@SEGMENT2 as SEGMENT2,@SEGMENT3 as SEGMENT3
) B
on
A.lookup_type_code = B.lookup_type_code
and A.segment1 = b.segment1
and A.segment2 = b.segment2
and A.segment3 = b.segment3
WHEN Matched then
  delete
;

        COMMIT;       
        
        
      END;