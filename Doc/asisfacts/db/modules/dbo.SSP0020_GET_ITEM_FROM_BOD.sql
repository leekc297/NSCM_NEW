
CREATE PROCEDURE [dbo].[SSP0020_GET_ITEM_FROM_BOD]  
  @p_division_id		NVARCHAR(30),
  @p_from_site_id		NVARCHAR(50),
  @p_to_site_id			NVARCHAR(30),
  @p_item_id			NVARCHAR(50),
  @p_bod_id				NVARCHAR(50),
  @p_debug              NVARCHAR(1) ='N'
AS
BEGIN
	
  SET NOCOUNT ON;
DECLARE @n nvarchar(1) = char(10)
DECLARE @v_SQL nvarchar(MAX) = ''	
SET @v_SQL = ''
SET @v_SQL += '' +char(10)
SET @v_SQL += 'SELECT V.DIVISION_ID ' + @n
SET @v_SQL += ',      V.BOD_ID ' + @n
SET @v_SQL += ',      A.ITEM_ID ' + @n
SET @v_SQL += ',      V.INCOTERMS ' + @n
SET @v_SQL += ',      V.PRIORITY ' + @n
SET @v_SQL += ',      V.TRANSPORT_MODE ' + @n
SET @v_SQL += ',      F.OPERATION_GROUP ' + @n

SET @v_SQL += 'FROM    (' + @n
SET @v_SQL += '			SELECT  DISTINCT B.DIVISION_ID , B.BOD_ID , B.FROM_SITE, B.TO_SITE , B.INCOTERMS, B.TRANSPORT_MODE, B.PRIORITY' + @n
SET @v_SQL += '			FROM (' + @n
SET @v_SQL += '					SELECT DIVISION_ID ' + @n
SET @v_SQL += '					,      BOD_ID' + @n
SET @v_SQL += '					,      FROM_SITE' + @n
SET @v_SQL += '					,      TO_SITE ' + @n
--SET @v_SQL += '					-- 20201223 INCOTERMS 변경 MODIFY KIMYONGHO' + @n
SET @v_SQL += '					,      SSP_INCOTERMS		AS INCOTERMS' + @n
SET @v_SQL += '					,      TRANSPORT_MODE ' + @n
SET @v_SQL += '					,      LT_TOTAL_ORIGIN       AS LT_TOTAL    ' + @n
SET @v_SQL += '					,      SHIP_LT_TOTAL_ORIGIN  AS SHIP_LT_TOTAL ' + @n
SET @v_SQL += '					,      PRIORITY 			' + @n
SET @v_SQL += '					FROM SCP_MST_BOD_N_V WITH(NOLOCK) ' + @n
SET @v_SQL += '					WHERE DIVISION_ID = ''' +@p_division_id +'''' + @n
SET @v_SQL += '                    AND   FROM_SITE   = ''' + @p_from_site_id + '''' + @n
SET @v_SQL += '					AND   TO_SITE   = ''' + @p_to_site_id + '''' + @n
SET @v_SQL += '					AND   BOD_VALID_YN =''Y''' + @n
SET @v_SQL += '					AND   FROM_YYYYMMDD  <= GETDATE()' + @n
SET @v_SQL += '					AND   TO_YYYYMMDD  >= GETDATE()' + @n

SET @v_SQL += '				)  B ' + @n
		
SET @v_SQL += '   )  V' + @n

SET @v_SQL += '    JOIN ( SELECT DISTINCT DIVISION_ID , ITEM_ID , BOD_ID ' + @n
SET @v_SQL += '	       FROM   SCP_MST_BOD_ITEM WITH(NOLOCK)   ' +@n -- SCP_MST_BOD_ITEM A WITH(NOLOCK) '
SET @v_SQL += '	       WHERE  DIVISION_ID = ''' + @p_division_id + '''' + @n
SET @v_SQL += '		   AND     (( '''  +@p_item_id + ''' ='''')   OR ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(''' + @p_item_id+''' , '','')))	' + @n
SET @v_SQL += '          )   A' + @n
SET @v_SQL += '	  ON A.DIVISION_ID  = V.DIVISION_ID ' + @n
SET @v_SQL += '	 AND A.BOD_ID       = V.BOD_ID' + @n

SET @v_SQL += '	LEFT JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)' + @n
SET @v_SQL += '		ON F.DIVISION_ID = V.DIVISION_ID ' + @n
SET @v_SQL += '		AND F.ITEM_ID =     A.ITEM_ID ' + @n
SET @v_SQL += '		AND F.OPERATION_GROUP =''E''' + @n

SET @v_SQL += 'WHERE V.DIVISION_ID = ''' +@p_division_id + '''' + @n
SET @v_SQL += 'AND   V.FROM_SITE   = ''' +@p_from_site_id + '''' + @n
SET @v_SQL += 'AND   V.TO_SITE     = ''' +@p_to_site_id + '''' + @n
--SET @v_SQL += 'AND   ISNULL(F.OPERATION_GROUP,'''')   = ''E''' + @n
 

SET @v_SQL += 'order by V.PRIORITY' + @n
print @v_SQL
EXEC (@v_SQL)

			
END
