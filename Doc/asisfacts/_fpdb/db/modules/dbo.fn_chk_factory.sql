CREATE FUNCTION [dbo].[fn_chk_factory]
(@userId nvarchar(50), @company nvarchar(50), @division nvarchar(50), @site nvarchar(50), @plant nvarchar(50), @factory nvarchar(50), @type nvarchar(50))
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
        FROM TH_UIS_USER_FACTORY_RELATE A, TH_UIS_ROLE_FACTORY_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.ROLE_ID = B.ROLE_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY_ID = @company
        
        return @retval
      end
      
    if @type = '2'
      begin
        SELECT @retval = (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)
        FROM TH_UIS_USER_FACTORY_RELATE A, TH_UIS_ROLE_FACTORY_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.ROLE_ID = B.ROLE_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY_ID = @company
        AND   B.DIVISION_ID = @division
        
        return @retval
      end
      
    if @type = '3'
      begin
        SELECT @retval = (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)
        FROM TH_UIS_USER_FACTORY_RELATE A, TH_UIS_ROLE_FACTORY_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.ROLE_ID = B.ROLE_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY_ID = @company
        AND   B.DIVISION_ID = @division
        AND   B.SITE_ID = @site
        
        return @retval
      end
      
    if @type = '4'
      begin
        SELECT @retval = (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)
        FROM TH_UIS_USER_FACTORY_RELATE A, TH_UIS_ROLE_FACTORY_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.ROLE_ID = B.ROLE_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY_ID = @company
        AND   B.DIVISION_ID = @division
        AND   B.SITE_ID = @site
        AND   B.PLANT_ID = @plant
        
        return @retval
      end
      
    if @type = '5'
      begin
        SELECT @retval = (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)
        FROM TH_UIS_USER_FACTORY_RELATE A, TH_UIS_ROLE_FACTORY_RELATE B
        WHERE A.USER_ID = @userId
        AND   A.ROLE_ID = B.ROLE_ID
        AND   A.USE_AT_FLAG = 'Y'
        AND   B.USE_AT_FLAG = 'Y'
        AND   B.COMPANY_ID = @company
        AND   B.DIVISION_ID = @division
        AND   B.SITE_ID = @site
        AND   B.PLANT_ID = @plant
        AND   B.FACTORY_ID = @factory
        
        return @retval
      end

    return @retval
END
