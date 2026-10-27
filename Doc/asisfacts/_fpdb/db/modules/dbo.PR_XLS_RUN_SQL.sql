
CREATE PROCEDURE [dbo].[PR_XLS_RUN_SQL]
        @p_str        NVARCHAR(MAX)  = ''
AS
BEGIN
	SET NOCOUNT ON; 
	DECLARE @DecodedSQL				NVARCHAR(MAX);
	BEGIN TRY
		SET @DecodedSQL = REPLACE(@p_str,'##LE##','DELETE');
		SET @DecodedSQL = REPLACE(@DecodedSQL,'##SE##','INSERT');
		SET @DecodedSQL = REPLACE(@DecodedSQL,'#RO#','FROM');
		SET @DecodedSQL = REPLACE(@DecodedSQL,'#HER#','WHERE');

        IF @DecodedSQL IS NULL OR LEN(@DecodedSQL) = 0
        BEGIN
            RAISERROR('유효하지 않은 SQL문입니다.', 16, 1);
            RETURN;
        END
		EXEC sp_executesql @DecodedSQL;
	--	print @DecodedSQL;
	--	select @DecodedSQL as str;

    END TRY
	BEGIN CATCH
	    PRINT ERROR_MESSAGE();
	END CATCH
END



