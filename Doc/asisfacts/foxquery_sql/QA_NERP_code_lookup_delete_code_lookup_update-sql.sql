BEGIN
					        BEGIN TRAN

merge into LGCE_SCMDEV.dbo.SCM_CODE_LOOKUP_VALUE A
using
(
	select @lookup_type_code  AS LOOKUP_TYPE_CODE
) B
on A.lookup_type_code = B.lookup_type_code
WHEN Matched then
  delete
;

        COMMIT;       
        
        
      END;