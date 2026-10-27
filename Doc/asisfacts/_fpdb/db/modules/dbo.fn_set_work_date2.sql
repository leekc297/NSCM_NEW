CREATE FUNCTION [dbo].[fn_set_work_date2]
(@v_master_id varchar(100), @v_plan_id varchar(100), @d_start_time datetime, @d_end_time datetime)
RETURNS varchar(100)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @v_plandate				VARCHAR(20)
	DECLARE @v_basetime				VARCHAR(8)
	DECLARE @v_is_plandate_start	VARCHAR(8)

	DECLARE @d_target_time			DATETIME
	DECLARE @d_start_target			DATETIME
	DECLARE @d_end_target			DATETIME

--For Logging	
DECLARE @TMPData TABLE (Code VARCHAR(1000), Data1 VARCHAR(1000),Data2 VARCHAR(1000),Data3 VARCHAR(1000),Data4 VARCHAR(1000),Data5 VARCHAR(1000))
	

    -- ## Default 설정..!!
    SET @v_plandate = CONVERT(VARCHAR, @d_start_time, 112)
    
    select 
		@v_basetime = SUBSTRING(CONVERT(VARCHAR,plan_start_time,108),1,2) + SUBSTRING(CONVERT(VARCHAR,plan_start_time,108),4,2) + SUBSTRING(CONVERT(VARCHAR,plan_start_time,108),7,2),
		@v_is_plandate_start = 'Y'
    from   SCM_FP_PLAN_H
    where  instance_id = @v_master_id
    and    plan_id   = @v_plan_id

    
    -- ## Start / End 기준에 따라 구분 처리..!!
    if ( ISNULL(RTRIM(@v_is_plandate_start),'Y') = 'Y' )
	BEGIN
        SET @d_target_time = @d_start_time;
	END
    else
	BEGIN
        SET @d_target_time = @d_end_time;
    END     

    -- ## TargetTime 기준 PlanDate 생성..!!
	DECLARE @TEMP8DATE VARCHAR(8) = CONVERT(VARCHAR, @d_target_time, 112)
	SET @d_start_target = CAST(LEFT(@TEMP8DATE,4) + '-' + SUBSTRING(@TEMP8DATE,5,2) + '-' + RIGHT(@TEMP8DATE,2) + ' ' + LEFT(@v_basetime,2) + ':' + SUBSTRING(@v_basetime,3,2) + ':' + RIGHT(@v_basetime,2) AS DATETIME)
	SET @d_end_target	= DATEADD(day,1,@d_start_target)

	SET @v_plandate =
		case when ( @d_target_time >= @d_start_target and @d_target_time < @d_end_target ) then
			CONVERT(VARCHAR, @d_target_time, 112)
		else
			CONVERT(VARCHAR, DATEADD(day,-1,@d_target_time), 112)
		end

  RETURN @v_plandate
END
