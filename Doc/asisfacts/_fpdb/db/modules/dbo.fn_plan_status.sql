CREATE FUNCTION [dbo].[fn_plan_status](
    @instance_id as nvarchar(max), 
    @plan_id as nvarchar(max)
    )
returns int
begin
	
	 declare @retval as integer

   select @retval = count(1) 
   from   sy_fp_plan_status_h
   where  instance_id   = @instance_id
   and    plan_id       = @plan_id
   and    (inbound_flag = 'S' or engine_flag = 'S' or outbound_flag = 'S' or db_trans_flag = 'S')
      
   return @retval
   
end
