-- =============================================
-- Author:		KSK
-- Create date: 2024-09-04
-- Description:	대용량 프린트
-- =============================================
CREATE PROCEDURE [dbo].[UP_XLS_PRINT]
	@TEXT NVARCHAR(MAX)
	, @SIZE INTEGER = 300
AS
BEGIN


	SET NOCOUNT ON;
	DECLARE @POS int, @CHK INT, @SIZE2 INT, @MSG AS NVARCHAR(100)
    DECLARE @LEN NVARCHAR(max)
	SET @POS =1;
	SET @LEN =LEN(@TEXT);
	WHILE @POS <= @LEN
		BEGIN				
			SET @CHK =  CHARINDEX(',', @TEXT, @POS)
			IF @CHK = 0 SET @CHK =  CHARINDEX(' ', @TEXT,  @POS)
			SET @MSG = 'fOUND AT ' + STR(@CHK)
			--print @MSG

			IF @CHK> 0 
			BEGIN
				
				SET @SIZE2 = @CHK - @POS + 1
				PRINT SUBSTRING(@TEXT,@POS, @SIZE2);
				SET @POS = @POS+ @SIZE2;
			END
			ELSE
			BEGIN
				PRINT SUBSTRING(@TEXT,@POS, @SIZE);
				SET @POS = @POS+ @SIZE;
			END
		END;
END
