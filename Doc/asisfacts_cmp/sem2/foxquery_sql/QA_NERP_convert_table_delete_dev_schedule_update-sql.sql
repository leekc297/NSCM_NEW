BEGIN
					        BEGIN TRAN
merge into znerp_dev_item_schedule A
using (
select @SEQ as SEQ
) B ON 
A.seq = B.seq
WHEN Matched then
  delete
;


        COMMIT;       
        
        
      END;