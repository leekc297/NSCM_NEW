CREATE   FUNCTION [dbo].[FN_NEXT_DAY]
(
  @dateval datetime
 ,@week    nvarchar(10)
)
RETURNS datetime
AS
BEGIN
  DECLARE @dayval    int
  DECLARE @resultday datetime

  IF @week = 'SUN' --OR @week = '일'
    SET @dayval = 1
  ELSE IF @week = 'MON' --OR @week = '월'
    SET @dayval = 2
  ELSE IF @week = 'TUE' --OR @week = '화'
    SET @dayval = 3
  ELSE IF @week = 'WED' --OR @week = '수'
    SET @dayval = 4
  ELSE IF @week = 'THU' --OR @week = '목'
    SET @dayval = 5
  ELSE IF @week = 'FRI' --OR @week = '금'
    SET @dayval = 6
  ELSE IF @week = 'SAT' --OR @week = '토'
    SET @dayval = 7
  ELSE
    BEGIN
      SET @dayval = 0
      RETURN NULL
  END

  SET @resultday = dateadd(dd, 7, @dateval)
  SET @resultday = dateadd(dd, -datepart(dw, @dateval), @resultday)
  SET @resultday = dateadd(dd, @dayval, @resultday)

  IF datepart(dw, @dateval) < @dayval
    SET @resultday = dateadd(dd, -7, @resultday)

  RETURN @resultday

END
