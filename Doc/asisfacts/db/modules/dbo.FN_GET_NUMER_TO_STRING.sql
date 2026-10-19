
 CREATE FUNCTION [dbo].[FN_GET_NUMER_TO_STRING](
 @Input NUMERIC(38,8)
 , @iDigitCnt INT
 )
 RETURNS VARCHAR(50)
 AS
 

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_NUMER_TO_STRING
  * DESCRIPTION   : 메일보낼때 숫자표시용
  * INPUT         : 변환할 숫자, 소수점자리수
  * OUTPUT        : 콤마찍힌 스트링숫자
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-06-03   HWI1993 메일보낼때 숫자표시용 ( 인풋이 NUMERIC 형이어야 함. )
  ****************************************************************************/

 BEGIN
 DECLARE @strInput varchar(39)
 , @RetValue varchar(50)
 , @iDotIndex INT
 , @strInt varchar(30), @strDec varchar(8)
 , @Sign varchar(1)

 SET @Sign = ''
 IF ( @Input < 0 )
 BEGIN
 SET @Sign = '-'
 SET @Input = @Input * -1
 END





 SELECT @Input = ISNULL(@Input, 0), @iDigitCnt = ISNULL(@iDigitCnt,0)

 SET @strInput = CAST(@Input AS varchar(39))
 SET @iDotIndex = patindex('%.%', @strInput)

 SELECT @strInt = LEFT(@strInput, @idotIndex -1 ) -- 정수부
, @strDec = SUBSTRING(@strInput, @iDotIndex+1, LEN(@strInput) - @iDotIndex) -- 소수부

DECLARE @i INT
 SET @i = 0
 SET @RetValue = LEFT(@strInt, LEN(@StrInt)%3)

 WHILE ( @i < LEN(@strInt)/3)
 BEGIN

 SET @RetValue = @RetValue + CASE WHEN @RetValue <> '' THEN ',' ELSE '' END 
 + SUBSTRING(@strInt, LEN(@StrInt)%3+1 + @i *3, 3 )

 SET @i = @i + 1
 END

 SET @RetValue = @RetValue + 
 CASE WHEN @iDigitCnt > 0 THEN '.' + LEFT(REPLACE(CAST(ROUND(@Input - CAST(FLOOR(@input) AS NUMERIC(38,8)), @iDigitCnt , @iDigitCnt+1) AS VARCHAR(10)), '0.', ''), @iDigitCnt)
 ELSE '' END

 RETURN @Sign+@RetValue
 END



 --SELECT DBO.TEST_DM_fnSetComma(NULL, 0)


 
