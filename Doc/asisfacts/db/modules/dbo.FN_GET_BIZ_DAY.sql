
CREATE FUNCTION [dbo].[FN_GET_BIZ_DAY](
	@P_CUR_DATE NCHAR(8)
	, @P_DAY_CNT INT
	)
      RETURNS NVARCHAR(8)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCM PRJ.
  * FUNCTION NAME : FN_GET_BIZ_DAY
  * DESCRIPTION   : @P_CUR_DATE 에 영업일로 @P_DAY_CNT 만큼의 일자를 더한 날짜를 리턴함.
  *
  * INPUT         : @P_CUR_DATE : 현재일자
					@P_DAY_CNT : 더해줄 일자
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-03-25   HWI1993		INITIAL
  ****************************************************************************/
BEGIN
  
  DECLARE @RTN_YYYYMMDD NVARCHAR(8)
		, @CNT			INT	-- @ADD_DAY 에 포함된 영업일 갯수
		, @ADD_DAY		INT -- 더해야할 총일자수

		SELECT @CNT = 0, @ADD_DAY = 0

		WHILE ( @CNT < @P_DAY_CNT )
		BEGIN

			SET @ADD_DAY += 1;

			IF (DATEPART(WEEKDAY, DATEADD(DAY, @ADD_DAY, @P_CUR_DATE)) NOT IN ( 7, 1 ))
				SET @CNT += 1;
		END

		RETURN CONVERT(NCHAR(8), DATEADD(DAY, @ADD_DAY, @P_CUR_DATE), 112)

END
;

