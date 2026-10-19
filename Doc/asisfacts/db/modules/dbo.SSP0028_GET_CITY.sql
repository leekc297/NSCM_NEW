


/*
 * Program ID   : SSP0028_GET_CITY
 * Description  : Delivery Tracking LT
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/09/13   PARKTAEHAK		신규추가
*/


CREATE PROCEDURE [dbo].[SSP0028_GET_CITY]
@p_country_parameter NVARCHAR(MAX),
@p_kind NVARCHAR(2)
-------@top varchar(3) = '96'

AS
BEGIN
    SET NOCOUNT ON;

	DECLARE  @v_from_country_parameter NVARCHAR(MAX)='';
	DECLARE @mDQry1 NVARCHAR(MAX)='';

	--IN 조건으로 데이터를 가져옴
	SET @v_from_country_parameter = [dbo].FN_GET_IN_STR(@p_country_parameter);
	
    
	IF(@p_kind='F')
	 BEGIN
			--From City
		  SET @mDqry1 = @mDQry1 + ' select distinct FROM_CITY AS CODE, REPLACE(''[''+ FROM_CITY +'']''+c.CITY_NAME , '','','''') AS NAME  ' + char(10);
		  SET @mDqry1 = @mDQry1 + 'from [dbo].[SCP_MST_DISTRIBUTION_ROUTE] as r WITH(NOLOCK)' + char(10);
		  SET @mDqry1 = @mDQry1 + 'join SCM_MST_CITY as c with(nolock)' + char(10);
		  SET @mDqry1 = @mDQry1 + ' on r.FROM_COUNTRY = c.COUNTRY' + char(10);
		  SET @mDqry1 = @mDQry1 + 'and r.FROM_CITY = c.CITY' + char(10);
		  SET @mDqry1 = @mDQry1 + 'where 1 = 1' + char(10);  
		  IF ( @v_from_country_parameter   IS NOT NULL AND @v_from_country_parameter    != '') SET @mDqry1 = @mDqry1 + ' 					AND  R.FROM_COUNTRY IN ('+ @v_from_country_parameter   +')    '+char(10); 
		 SET @mDqry1 = @mDQry1 + 'order by r.From_City' + char(10);		

	 END
	 ELSE IF(@p_kind='T')
	 BEGIN
		--To City		
		 SET @mDqry1 = @mDQry1 + ' select distinct TO_CITY AS CODE, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(''[''+ TO_CITY +'']''+c.CITY_NAME, '','','''')  ,''-'',''''), ''/'', ''''), '')'',''''), ''('',''''), '''''''' ,'''') ' + char(10);	
		 SET @mDqry1 = @mDQry1 + ' from [dbo].[SCP_MST_DISTRIBUTION_ROUTE] as r WITH(NOLOCK)' + char(10);
		 SET @mDqry1 = @mDQry1 + ' join SCM_MST_CITY as c with(nolock)' + char(10);
		 SET @mDqry1 = @mDQry1 + ' on r.TO_COUNTRY = c.COUNTRY' + char(10);
		 SET @mDqry1 = @mDQry1 + ' and r.TO_CITY = c.CITY' + char(10);
		 SET @mDqry1 = @mDQry1 + ' where 1 = 1' + char(10); 
		  IF ( @v_from_country_parameter   IS NOT NULL AND @v_from_country_parameter    != '') SET @mDqry1 = @mDqry1 + ' 					AND  R.TO_COUNTRY IN ('+ @v_from_country_parameter   +')    '+char(10);  
		 SET @mDqry1 = @mDQry1 + ' order by r.TO_City' + char(10);
	 END
	 ELSE IF(@p_kind='A')
	 BEGIN
	 	--From City
		  SET @mDqry1 = @mDQry1 + ' select distinct FROM_CITY AS CODE, REPLACE(''[''+ FROM_CITY +'']''+c.CITY_NAME , '','','''') AS NAME  ' + char(10);
		  SET @mDqry1 = @mDQry1 + 'from [dbo].[SCP_MST_DISTRIBUTION_ROUTE] as r WITH(NOLOCK)' + char(10);
		  SET @mDqry1 = @mDQry1 + 'join SCM_MST_CITY as c with(nolock)' + char(10);
		  SET @mDqry1 = @mDQry1 + ' on r.FROM_COUNTRY = c.COUNTRY' + char(10);
		  SET @mDqry1 = @mDQry1 + 'and r.FROM_CITY = c.CITY' + char(10);
		  SET @mDqry1 = @mDQry1 + 'where 1 = 1' + char(10);  
		  IF ( @v_from_country_parameter   IS NOT NULL AND @v_from_country_parameter    != '') SET @mDqry1 = @mDqry1 + ' 					AND  R.FROM_COUNTRY IN ('+ @v_from_country_parameter   +')    '+char(10); 
		 SET @mDqry1 = @mDQry1 + 'order by r.From_City' + char(10);

		 --To City		
		 SET @mDqry1 = @mDQry1 + ' select distinct TO_CITY AS CODE, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(''[''+ TO_CITY +'']''+c.CITY_NAME, '','','''')  ,''-'',''''), ''/'', ''''), '')'',''''), ''('',''''), '''''''' ,'''') ' + char(10);	
		 SET @mDqry1 = @mDQry1 + ' from [dbo].[SCP_MST_DISTRIBUTION_ROUTE] as r WITH(NOLOCK)' + char(10);
		 SET @mDqry1 = @mDQry1 + ' join SCM_MST_CITY as c with(nolock)' + char(10);
		 SET @mDqry1 = @mDQry1 + ' on r.TO_COUNTRY = c.COUNTRY' + char(10);
		 SET @mDqry1 = @mDQry1 + ' and r.TO_CITY = c.CITY' + char(10);
		 SET @mDqry1 = @mDQry1 + ' where 1 = 1' + char(10); 
		  IF ( @v_from_country_parameter   IS NOT NULL AND @v_from_country_parameter    != '') SET @mDqry1 = @mDqry1 + ' 					AND  R.TO_COUNTRY IN ('+ @v_from_country_parameter   +')    '+char(10);  
		 SET @mDqry1 = @mDQry1 + ' order by r.TO_City' + char(10);		

	 END
	
	 exec(@mDqry1)
END
