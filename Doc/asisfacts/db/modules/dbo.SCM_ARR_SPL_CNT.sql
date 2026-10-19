
CREATE FUNCTION [dbo].[SCM_ARR_SPL_CNT]
(
    @String NVARCHAR(max),			-- 분리할 문자열
    @SplitChar NVARCHAR(1)			-- 구분할 문자
) 
RETURNS VARCHAR(max)
AS 

BEGIN   

	DECLARE	@Temp		NVARCHAR(MAX);
	DECLARE	@Length		INT;
	DECLARE	@CurrentIndex	INT;
	DECLARE	@NextIndex	INT;
	DECLARE	@maxloopCnt	INT;

	SET @Length = LEN(@String);
	SET @CurrentIndex = 1;
	SET @NextIndex = 1;
	SET @maxloopCnt = 0;

	WHILE @NextIndex > 0
	BEGIN
		SET @NextIndex = CHARINDEX(@SplitChar, @String, @CurrentIndex)

		IF @NextIndex = 0 
		BEGIN
		SET @Temp = SUBSTRING(@String, @CurrentIndex, (@Length - @CurrentIndex + 1))
		END
		ELSE
		BEGIN
		SET @Temp = SUBSTRING(@String, @CurrentIndex, (@NextIndex - @CurrentIndex))
		SET @CurrentIndex = @NextIndex + 1
		END	
		
		SET @maxloopCnt = @maxloopCnt + 1; 
		
	END

	--SELECT @maxloopCnt;
	RETURN @maxloopCnt; 
END
;

