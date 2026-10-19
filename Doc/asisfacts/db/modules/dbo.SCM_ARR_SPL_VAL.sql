
CREATE FUNCTION [dbo].[SCM_ARR_SPL_VAL]
(
 @sText		NVARCHAR(max),			-- 대상 문자열
 @str		NVARCHAR(1) = '|',		-- 구분기호(Default '|')
 @idx		INT                     -- 배열 인덱스
)
RETURNS NVARCHAR(MAX)
AS

BEGIN
 DECLARE @word    NVARCHAR(max);		-- 반환할 문자
 DECLARE @sTextData  NVARCHAR(max); 
 DECLARE @num    INT;
      
 SET @num = 1;
 SET @str = LTRIM(RTRIM(@str));
 SET @sTextData = LTRIM(RTRIM(@sText)) + @str; 
  
 WHILE @idx >= @num
 BEGIN
  IF CHARINDEX(@str, @sTextData) > 0
  BEGIN
   -- 문자열의 인덱스 위치의 요소를 반환
   SET @word = SUBSTRING(@sTextData, 1, CHARINDEX(@str, @sTextData) - 1);
   SET @word = LTRIM(RTRIM(@word));
 
   -- 반환된 문자는 버린후 좌우공백 제거   
   SET @sTextData = LTRIM(RTRIM(RIGHT(@sTextData, LEN(@sTextData) - (LEN(@word) + 1))))
  END ELSE BEGIN
   SET @word = NULL;
  END
  SET @num = @num + 1
 END
 RETURN(@word);
END
;
