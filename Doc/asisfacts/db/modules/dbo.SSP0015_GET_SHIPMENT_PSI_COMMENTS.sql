/*
 * Program ID   : SSP0015_GET_SHIPMENT_PSI_COMMENTS
 * Description  : Shipment Plan Confrim COMMENTS LOAD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/08/09   MCTHEJ		   [CSR ID:4061695] SSP 시스템 개선 요청건(Shipment Plan)
 * 2023/08/03   jilee          AS BEFORE_QTY, AS GAP 조건 변경
 *
 ex) EXEC SSP0015_GET_SHIPMENT_PSI_COMMENTS '40', '20190811', '', '', '20190809', '20191031'
 */
CREATE PROCEDURE [dbo].[SSP0015_GET_SHIPMENT_PSI_COMMENTS]
	 @p_division_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd		NVARCHAR(8)
	,@p_from_site				NVARCHAR(MAX)
	,@p_item_id					NVARCHAR(MAX)
	,@p_from_yyyymmdd			NVARCHAR(MAX)
	,@p_to_yyyymmdd				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mNoteEXEC NVARCHAR(MAX);
	DECLARE @mProductEXEC NVARCHAR(MAX);

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_from_site NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	
	--IN 조건으로 데이터를 가져옴
	SET @v_division_id = [dbo].FN_GET_IN_STR(@p_division_id);
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	
	--//Note Load
	SET @mNoteEXEC = '';
	SET @mNoteEXEC = @mNoteEXEC + ' SELECT																																			' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + ' 	T0.DIVISION_ID,		T0.FROM_SITE AS SITE,	ISNULL(dbo.fn_get_scm_site_description(T0.DIVISION_ID, T0.FROM_SITE ),''-'') as FROM_SITE_NM,	' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + ' 	dbo.fn_get_item_nickname( (CASE WHEN T0.DIVISION_ID = ''EE'' THEN T1.ORIGIN_FROM_DIVISION_ID ELSE T0.DIVISION_ID end), T0.ITEM_ID) AS nick_name, ' + CHAR(10);
    SET @mNoteEXEC = @mNoteEXEC + ' 	T0.ITEM_ID,			SUBSTRING(T0.YYYYMMDD, 1, 4) + ''-'' + SUBSTRING(T0.YYYYMMDD, 5, 2) + ''-'' + SUBSTRING(T0.YYYYMMDD, 7, 2) AS YYYYMMDD,		CEILING(ISNULL(SUM(T0.USER_ADD_QTY), 0)) AS USER_ADD_QTY, ISNULL(SUM(T1.QTY), 0) AS QTY,		 CEILING(ISNULL(sum(convert(numeric, T0.ATTRIBUTE1)), 0))  AS BEFORE_QTY,           (ISNULL(SUM(T1.QTY), 0)) - CEILING(ISNULL(sum(convert(numeric, T0.ATTRIBUTE1)), 0))  AS GAP     ,		ISNULL(T0.COMMENTS, '''') AS COMMENTS,	T0.LAST_UPDATED_BY,		T0.LAST_UPDATE_DATE				' + CHAR(10);	
	SET @mNoteEXEC = @mNoteEXEC + '	FROM SSP_ANL_SHIP_PLAN_40_WH_IN_CMT	T0 WITH(NOLOCK)																		' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + '	INNER JOIN SSP_ANL_SHIP_PLAN_40 T1 WITH(NOLOCK)																				' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + '		ON T0.DIVISION_ID = T1.DIVISION_ID		AND T0.FROM_SITE = T1.FROM_SITE										' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + '		AND T0.ITEM_ID = T1.ITEM_ID				AND T0.YYYYMMDD = T1.YYYYMMDD										' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + '		AND T1.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + ''' AND T1.MEASURE = ''WH_IN''					' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + '	WHERE 1 = 1																										' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + '	  AND T0.YYYYMMDD >= ''' + @p_from_yyyymmdd + '''																' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + '	  AND T0.YYYYMMDD <= ''' + @p_to_yyyymmdd + '''																	' + CHAR(10);
	IF ( @v_division_id IS NOT NULL AND @v_division_id    != '') SET @mNoteEXEC = @mNoteEXEC + '   AND T0.DIVISION_ID IN (' + @v_division_id + ')	' + CHAR(10);                     
	IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mNoteEXEC = @mNoteEXEC + '   AND  T0.FROM_SITE IN (' + @v_from_site + ')		' + CHAR(10);                     
	IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mNoteEXEC = @mNoteEXEC + '   AND  T0.ITEM_ID IN (' + @v_item_id + ')			' + CHAR(10);
	SET @mNoteEXEC = @mNoteEXEC + ' GROUP BY T0.DIVISION_ID, T1.ORIGIN_FROM_DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.COMMENTS, T0.LAST_UPDATED_BY, T0.LAST_UPDATE_DATE ' + CHAR(10);

	EXEC(@mNoteEXEC);                  
	--select @mNoteEXEC;
	
	SET @mProductEXEC = '';
	SET @mProductEXEC = @mProductEXEC + ' SELECT																																			' + CHAR(10);
	SET @mProductEXEC = @mProductEXEC + ' 	T0.DIVISION_ID,		T0.FROM_SITE AS SITE, ' + CHAR(10);
	SET @mProductEXEC = @mProductEXEC + ' 	T0.ITEM_ID,			SUBSTRING(T0.YYYYMMDD, 1, 4) + ''-'' + SUBSTRING(T0.YYYYMMDD, 5, 2) + ''-'' + SUBSTRING(T0.YYYYMMDD, 7, 2) AS YYYYMMDD, ISNULL(T0.ATTRIBUTE3, '''') AS PRODUCT_QTY' + CHAR(10);
	SET @mProductEXEC = @mProductEXEC + '	FROM SSP_ANL_SHIP_PLAN_40	T0 WITH(NOLOCK)																			' + CHAR(10);
	SET @mProductEXEC = @mProductEXEC + '	WHERE 1 = 1																										' + CHAR(10);
	SET @mProductEXEC = @mProductEXEC + '	  AND (T0.ATTRIBUTE3 IS NOT NULL OR T0.ATTRIBUTE3 != '''') '+ CHAR(10);
	SET @mProductEXEC = @mProductEXEC + '     AND T0.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + ''' AND T0.MEASURE = ''PROD_PLAN''					' + CHAR(10);
	SET @mProductEXEC = @mProductEXEC + '	  AND T0.YYYYMMDD >= ''' + @p_from_yyyymmdd + '''																' + CHAR(10);
	SET @mProductEXEC = @mProductEXEC + '	  AND T0.YYYYMMDD <= ''' + @p_to_yyyymmdd + '''																	' + CHAR(10);
	--null 조건 추가
	IF ( @v_division_id IS NOT NULL AND @v_division_id    != '') SET @mProductEXEC = @mProductEXEC + '   AND T0.DIVISION_ID IN (' + @v_division_id + ')	' + CHAR(10);                     
	IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mProductEXEC = @mProductEXEC + '   AND  T0.FROM_SITE IN (' + @v_from_site + ')		' + CHAR(10);                     
	IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mProductEXEC = @mProductEXEC + '   AND  T0.ITEM_ID IN (' + @v_item_id + ')			' + CHAR(10);
	SET @mProductEXEC = @mProductEXEC + ' GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.ATTRIBUTE3 ' + CHAR(10);

	EXEC(@mProductEXEC);
	--select @mProductEXEC;

END	
