BEGIN
					        BEGIN TRAN

merge into dbo.SCM_ADM_NOTICE_CONTENT_MASTER A
using
(
	select @NOTICE_ID  AS NOTICE_ID
) B
on A.NOTICE_ID = B.NOTICE_ID
WHEN Matched then
  delete
;
        COMMIT;       
   END