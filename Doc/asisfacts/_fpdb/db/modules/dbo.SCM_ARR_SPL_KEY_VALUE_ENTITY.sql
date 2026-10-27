CREATE FUNCTION [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]
(
 @sText		NVARCHAR(max),			-- 대상 문자열
 @arrlen    integer=0,               -- 대상 문자열의 배열 길이
 @str		NVARCHAR(1) = '#',		-- 구분기호(Default '|')
 @key_str	NVARCHAR(MAX) = ''      -- KEY
)
RETURNS NVARCHAR(MAX)
AS

BEGIN
 -- SCM_ARR_SPL_KEY_VAL은 KEY:VAL 형식으로 된 목록에서 주어진 KEY_STR에 해당하는 값을 가져오는 것이다.
 DECLARE @inc integer = 0
 DECLARE @tmp_column NVARCHAR(MAX) = ''
 DECLARE @word NVARCHAR(MAX) = ''
			WHILE @inc < @arrlen
			BEGIN
				SET @inc =  @inc + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @sText,'#', @inc)
				--RETURN(@tmp_column)
				SET @word = REPLACE(@tmp_column, @key_str + ':','')
				IF LEN(@tmp_column) <>  LEN(@word) BEGIN
				    SET @word = REPLACE(@word,N'&hat;','^')
                    SET @word = REPLACE(@word,N'&excl;','!')
                    SET @word = REPLACE(@word,N'&sharp;','#')
                    SET @word = REPLACE(@word,N'&colon;',':')
					RETURN(@word)
				END
			END
 RETURN(@word);
END
