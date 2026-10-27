--CREATE FUNCTION [dbo].[FN_GET_NAME]
CREATE FUNCTION [dbo].[FN_GET_NAME]
-- ================================================================================================
-- Program ID          : 
-- Program Name        : FN_GET_NAME
-- Param               : LANG_TXT
--                       COL_TXT
-- Batch Period        : 
-- Description         : MMD의 이름 정보가 국가별 언어 코드를 포함하여 한 컬럼에 저장되어 IF됨. 이중
--                       영문명을 찾기 위해 사용
--
-- Source System       : 
-- Destination System  : FP SDB
-- Source Table        : XIF_MMD_BAS_ITEM_DATA_R
-- Destination Table   : SCM_OPERATION_M
--                       SCM_LINE_M
--                       SCM_EQUIPMENT_M
--                       SCM_OPERATION_FLOW_M
--                       SCM_CO_PRODUCT_M
--                       SCM_ITEM_M
--                       XIF_MMD_BAS_ITEM_DATA_S
--
-- Create(Update) Date : 2016.09.21
-- Author              : kim choon dong
-- Version             : 1.0
-- ================================================================================================
(
    @LANG_TXT    NVARCHAR(500)
   ,@COL_TXT    NVARCHAR(500)
)
RETURNS NVARCHAR(150)
AS

BEGIN

    DECLARE @SQLTXT         NVARCHAR(500)
           ,@LANGID_ST_PT   DECIMAL (18,0) 
           ,@COL_TOT_LEN    INT
           ,@REMAIN_LEN     INT
           ,@REMAIN_COL_TXT NVARCHAR(500)
           ,@LAST_PT        INT

    SET @LANGID_ST_PT  = CHARINDEX(ISNULL(@LANG_TXT, ''), @COL_TXT )
    
    IF @LANGID_ST_PT = 0 
        RETURN NULL
    ELSE               
        SET @COL_TOT_LEN  = LEN( @COL_TXT )
        SET @REMAIN_LEN  = @COL_TOT_LEN - @LANGID_ST_PT + 1
        SET @REMAIN_COL_TXT = SUBSTRING( @COL_TXT, @LANGID_ST_PT, @REMAIN_LEN  )
        SET @LAST_PT  = CHARINDEX('|', @REMAIN_COL_TXT )
        
        if @LAST_PT = 0
           SET @LAST_PT = @REMAIN_LEN + 1
        
        if @LAST_PT <= 7
           SET @LAST_PT = 7
               
        SET @SQLTXT = SUBSTRING( @REMAIN_COL_TXT, 7, @LAST_PT - 7)

        IF @SQLTXT = '' 
			SET @SQLTXT = NULL
		
		RETURN @SQLTXT

END
