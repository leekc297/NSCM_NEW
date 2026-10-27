CREATE FUNCTION [dbo].[fn_chk_shop]
(@userId nvarchar(50), @company nvarchar(50), @division nvarchar(50), @site nvarchar(50), @factory nvarchar(50), @shop nvarchar(50), @type nvarchar(50))
RETURNS int
WITH EXEC AS CALLER
AS
BEGIN
declare @retval integer

    if @userId IS NULL or @userId = ''
      begin
        set @retval = 0
        return @retval
      end;

    if @type = '1'
      begin
        SELECT @retval = (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)
        FROM TH_UIS_USER_SHOP_GROUP_RELATE A, TH_UIS_SHOP_GROUP_SHOP_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.SHOP_GROUP_ID = B.SHOP_GROUP_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY = @company
        
        return @retval
      end
      
    if @type = '2'
      begin
        SELECT @retval = (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)
        FROM TH_UIS_USER_SHOP_GROUP_RELATE A, TH_UIS_SHOP_GROUP_SHOP_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.SHOP_GROUP_ID = B.SHOP_GROUP_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY = @company
        AND   B.DIVISION = @division
        
        return @retval
      end
      
    if @type = '3'
      begin
        SELECT @retval = (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)
        FROM TH_UIS_USER_SHOP_GROUP_RELATE A, TH_UIS_SHOP_GROUP_SHOP_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.SHOP_GROUP_ID = B.SHOP_GROUP_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY = @company
        AND   B.DIVISION = @division
        AND   B.SITE = @site
        
        return @retval
      end
      
    if @type = '4'
      begin
        SELECT @retval = (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)
        FROM TH_UIS_USER_SHOP_GROUP_RELATE A, TH_UIS_SHOP_GROUP_SHOP_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.SHOP_GROUP_ID = B.SHOP_GROUP_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY = @company
        AND   B.DIVISION = @division
        AND   B.SITE = @site
        AND   B.FACTORY = @factory
        
        return @retval
      end
      
    if @type = '5'
      begin
        SELECT @retval = (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)
        FROM TH_UIS_USER_SHOP_GROUP_RELATE A, TH_UIS_SHOP_GROUP_SHOP_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.SHOP_GROUP_ID = B.SHOP_GROUP_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY = @company
        AND   B.DIVISION = @division
        AND   B.SITE = @site
        AND   B.FACTORY = @factory
        AND   B.SHOP = @shop
        
        return @retval
      end

    return @retval
END
