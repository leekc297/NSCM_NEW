/****************************************************************************************************/
/* Program ID  : DEBUG_LOG                                                                          */
/* Description : PRINT STRING                                                                       */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2022/05/11  chaan        4KB 사이즈 print log                                                    */
/****************************************************************************************************/


CREATE PROCEDURE [dbo].[DEBUG_LOG]
  @p_str      NVARCHAR(MAX) = N'',
  @p_to_xml   NVARCHAR(MAX) = 'F'
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @p_to_xml = 'T'
    BEGIN
        SELECT CAST('<root><![CDATA[' + @p_str + ']]></root>' AS XML); --chaan
    END
    ELSE
    BEGIN
        DECLARE @POS INT;
        DECLARE @LEN INT;

        SET @POS =1;
        SET @LEN =LEN(@p_str);

        WHILE @POS <= @LEN
        BEGIN
	        PRINT SUBSTRING(@p_str, @POS, 4000);
	        SET @POS = @POS+4000;
        END;
    END
END
