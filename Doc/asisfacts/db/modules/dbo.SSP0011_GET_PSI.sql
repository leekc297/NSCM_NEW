
/*
 * Program ID   : SSP0011_GET_PSI
 * Description  : PSI 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/12   ygkim			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/20   byunghunjung	운영 재반영
 * 2018/07/06   ygkim           @p_electrode_type 파리미터, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID 컬럼 추가

   EXEC SSP0011_GET_PSI_KYG @p_from_yyyymmdd='20180718', @p_to_yyyymmdd='20180911', @p_division_id='EE', @p_operation_group='E'
   , @p_From_Site='3050-E,A011-E,A041-E,G183-E,G383-E,G452-E', @p_item_id='', @p_program_id=NULL
   , @p_plan_start_yyyymmdd='20180718', @p_plan_type='SP', @p_seq='1', @p_user_id=NULL, @p_electrode_type=''

 */
CREATE PROCEDURE [dbo].[SSP0011_GET_PSI]
	@p_from_yyyymmdd		NVARCHAR(MAX) ,
	@p_to_yyyymmdd			NVARCHAR(MAX) ,
	@p_division_id			NVARCHAR(MAX) ,
	@p_operation_group		NVARCHAR(MAX) ,
	@p_From_Site			NVARCHAR(MAX) ,
	@p_item_id				NVARCHAR(MAX) ,
	@p_program_id			NVARCHAR(MAX) = 'SSP0011',
	@p_plan_start_yyyymmdd  NVARCHAR(8) ,
	@p_plan_type			NVARCHAR(50),
	@p_seq					NVARCHAR(50),
	@p_electrode_type		NVARCHAR(60) = '',
	@p_user_id			    NVARCHAR(MAX) ,
	@debug_mode			NVARCHAR(20)  ='F'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0011') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SSP0011;

	DECLARE @mEXEC NVARCHAR(MAX);
	
	CREATE TABLE #TblDynamicPivot_SSP0011 (
		 division_id	            NVARCHAR(60)	
    ,PLAN_START_YYYYMMDD	    NVARCHAR(10)
		,PLAN_TYPE	              NVARCHAR(100)	
    ,SEQ			                INT
		,OPERATION_GROUP	        NVARCHAR(20)	
    ,OPERATION_GROUP_DESC	    NVARCHAR(300)
		,FROM_SITE		            NVARCHAR(60)	
    ,ORIGIN_FROM_DIVISION_ID	NVARCHAR(60)
		,ORIGIN_TO_DIVISION_ID	  NVARCHAR(60)	
    ,ITEM_ID	                NVARCHAR(100)
		,ELECTRODE_TYPE	          NVARCHAR(60)	
    ,PSI_TYPE	                NVARCHAR(20)
		,PSI_NAME	                NVARCHAR(100)	
    ,PSI_VALUE	              NVARCHAR(100)
		,PSI_SEQ	                NVARCHAR(100)	
    ,INVENTORY_SEQ	          NVARCHAR(100)
		,yyyymmdd	                NVARCHAR(10)	
    ,yyyymm	                  NVARCHAR(10)
		,qty	                    BIGINT	
    ,iso_week	                INT
	)

  /********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	
  DECLARE @arr_from_site      nvarchar(max) 
        , @arr_item_id        nvarchar(max)
        , @arr_electrode_type nvarchar(max)

	SELECT  @arr_from_site      = ISNULL(@arr_from_site       + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_From_Site,',')
	SELECT  @arr_item_id        = ISNULL(@arr_item_id         + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_item_id,',')
	SELECT  @arr_electrode_type = ISNULL(@arr_electrode_type  + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_electrode_type,',')

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+' INSERT INTO #TblDynamicPivot_SSP0011	 '+CHAR(10);
	SET @mEXEC = @mEXEC+' SELECT        																																																																		'+CHAR(10);
	SET @mEXEC = @mEXEC+' 		   A.DIVISION_ID                                                                                                                              '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.PLAN_START_YYYYMMDD                                                                                                                      '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.PLAN_TYPE                                                                                                                                '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.SEQ                                                                                                                                      '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.OPERATION_GROUP                                                                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,C.SEGMENT2 AS OPERATION_GROUP_DESC                                                                                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.FROM_SITE                                                                                                                                '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,isnull(NULLIF(A.ORIGIN_FROM_DIVISION_ID, '''') , ''-'') as  ORIGIN_FROM_DIVISION_ID                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,isnull(NULLIF(A.ORIGIN_TO_DIVISION_ID,'''') , ''-'') as ORIGIN_TO_DIVISION_ID                                                              '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.ITEM_ID                                                                                                                                  '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.ELECTRODE_TYPE                                                                                                                           '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.PSI_TYPE, B.SEGMENT2 AS PSI_NAME                                                                                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,CASE WHEN A.PSI_TYPE=''I''  THEN dbo.FN_GET_LOOKUP_CODE_DESC(''PSI_INVENTORY'', A.PSI_VALUE)                                               '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		        ELSE A.PSI_VALUE                                                                                                                      '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		    END AS PSI_VALUE                                                                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,B.DISPLAY_SEQ AS PSI_SEQ                                                                                                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,E.DISPLAY_SEQ AS INVENTORY_SEQ                                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,''D_''+ A.yyyymmdd AS yyyymmdd                                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,o.basis_yyyymm AS yyyymm                                                                                                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+' 			, isnull(qty,0) AS qty                                                                                                                      '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week                                                                                            '+CHAR(10);
	SET @mEXEC = @mEXEC+'  FROM SSP_ANL_PSI_PRODUCTION (NOLOCK) A                                                                                                           '+CHAR(10);
	SET @mEXEC = @mEXEC+'  INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd                                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) B on B.LOOKUP_TYPE=''PSI_TYPE'' and  A.PSI_TYPE=B.SEGMENT1                                       '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) C on C.LOOKUP_TYPE=''OPERATION_GROUP'' and  A.OPERATION_GROUP = C.SEGMENT1                       '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) E on E.LOOKUP_TYPE=''PSI_INVENTORY'' and  A.PSI_VALUE=E.SEGMENT1                                 '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_MST_SITE (NOLOCK) D on A.DIVISION_ID=D.DIVISION_ID and A.FROM_SITE=D.SCM_SITE_ID and A.OPERATION_GROUP = D.OPERATION_GROUP         '+CHAR(10);
	SET @mEXEC = @mEXEC+'  WHERE 1=1                                                                                                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND yyyymmdd            >= '''+@p_from_yyyymmdd+'''                                                                                           '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND yyyymmdd            <= '''+@p_to_yyyymmdd+'''                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.division_id         = '''+@p_division_id   +'''                                                                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.operation_group     = '''+@p_operation_group+'''                                                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd  +'''                                                                                  '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.plan_type           = '''+@p_plan_type +'''                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.seq                 = '+@p_seq+'                                                                                                        '+CHAR(10);
  
  IF NOT(@p_From_Site IS NULL       OR  @p_From_Site      ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( from_site  IN ('+@arr_from_site+') )				      '+CHAR(10); END;
	IF NOT(@p_item_id IS NULL         OR  @p_item_id        ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( item_id      IN ('+@arr_item_id+') )					    '+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL  OR  @p_electrode_type ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( electrode_type      IN ('+@arr_electrode_type+') )'+CHAR(10); END;

--  PRINT (@mEXEC);
  EXEC (@mEXEC);

	-----------------------------------------------------------
	-- DEBUG QRY 출력
	-----------------------------------------------------------	
	IF( @debug_mode ='T')
		BEGIN				
			DECLARE @POS INT =1;
			DECLARE @LEN INT =LEN(@mEXEC);
			WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@mEXEC,@POS,4000);
					SET @POS = @POS+4000;
				END;
		END;
	-----------------------------------------------------------
	/*
	SELECT
		A.DIVISION_ID ,
		A.PLAN_START_YYYYMMDD ,
		A.PLAN_TYPE ,
		A.SEQ ,
		A.OPERATION_GROUP , 
		C.SEGMENT2 AS OPERATION_GROUP_DESC ,
		A.FROM_SITE , 
		A.ITEM_ID , 
		ISNULL(NULLIF(origin_from_division_id,''),'-') origin_from_division_id,
		ISNULL(NULLIF(origin_to_division_id,''),'-') origin_to_division_id,
		ISNULL(NULLIF(electrode_type,''),'-') electrode_type,
		--A.ELECTRODE_TYPE, 
		A.PSI_TYPE, B.SEGMENT2 AS 'PSI_NAME' ,
		CASE WHEN A.PSI_TYPE='I'
			THEN dbo.FN_GET_LOOKUP_CODE_DESC('PSI_INVENTORY', A.PSI_VALUE) 
			ELSE A.PSI_VALUE
		END AS 'PSI_VALUE' ,
		B.DISPLAY_SEQ AS PSI_SEQ,
		E.DISPLAY_SEQ AS INVENTORY_SEQ,
		'D_'+ A.yyyymmdd AS yyyymmdd ,
		o.basis_yyyymm AS yyyymm ,
	    isnull(qty,0) AS qty ,
		--RIGHT(o.basis_yyyymm,2)+o.iso_week AS iso_week
		RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week
	INTO #TblDynamicPivot_SSP0011
	FROM SSP_ANL_PSI_PRODUCTION (NOLOCK) A
	INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) B on B.LOOKUP_TYPE='PSI_TYPE' and  A.PSI_TYPE=B.SEGMENT1
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) C on C.LOOKUP_TYPE='OPERATION_GROUP' and  A.OPERATION_GROUP = C.SEGMENT1
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) E on E.LOOKUP_TYPE='PSI_INVENTORY' and  A.PSI_VALUE=E.SEGMENT1
	LEFT JOIN SCM_MST_SITE (NOLOCK) D on A.DIVISION_ID=D.DIVISION_ID and A.FROM_SITE=D.SCM_SITE_ID and A.OPERATION_GROUP = D.OPERATION_GROUP
	WHERE 1=1
		AND yyyymmdd >= @p_from_yyyymmdd
		AND yyyymmdd <= @p_to_yyyymmdd
		AND a.division_id	       = @p_division_id
		AND a.operation_group      = @p_operation_group
		AND a.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
		AND a.plan_type            = @p_plan_type
		AND a.seq				   = @p_seq
		AND ( ( @p_From_Site  IS NULL OR  @p_From_Site ='' )  OR A.FROM_SITE	IN (SELECT token FROM dbo.String_Split(@p_From_Site, ',')) )
		AND ( ( @p_item_id    IS NULL OR  @p_item_id ='')     OR A.ITEM_ID		IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')) )
		AND ( (@p_electrode_type   IS NULL OR  @p_electrode_type=''   ) OR a.electrode_type = @p_electrode_type)
	;
	*/
	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/

  /*
      SELECT 'W_'+a.basis_yyyymm + a.iso_week   AS yyyymmdd   , a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a 
			WHERE a.basis_yyyymmdd  >= @p_from_yyyymmdd AND a.basis_yyyymmdd  <= @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
			UNION ALL
			SELECT 'M_'+a.basis_yyyymm                AS yyyymmdd   ,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a 
			WHERE a.basis_yyyymmdd  >= @p_from_yyyymmdd AND a.basis_yyyymmdd  <= @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.month_name		
			UNION ALL
			SELECT 'D_'+a.basis_yyyymmdd              AS yyyymmdd , a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
			 FROM [dbo].[scm_sys_calendar_m] a 
			WHERE a.basis_yyyymmdd  >= @p_from_yyyymmdd AND a.basis_yyyymmdd  <= @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd	
 */

	begin
		DECLARE @mQry_sum NVARCHAR(MAX);
		--DECLARE @mEXEC NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성
		SET @mQry_sum = '';

		SELECT  @mQry_sum = @mQry_sum+','+ 
			CASE  WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END )  AS ' + yyyymmdd
				--  WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',4) THEN QTY END ) AS ' + yyyymmdd
				    WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''', 6) THEN QTY END ) AS ' + yyyymmdd
				    WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY END ) AS ' + yyyymmdd
			END +''+CHAR(10)
		FROM ( 
			 SELECT 'W_'+a.basis_yyyymm + a.iso_week   AS yyyymmdd   , a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a 
			WHERE a.basis_yyyymmdd  >= @p_from_yyyymmdd AND a.basis_yyyymmdd  <= @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
			UNION ALL
			SELECT 'M_'+a.basis_yyyymm                AS yyyymmdd   ,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a 
			WHERE a.basis_yyyymmdd  >= @p_from_yyyymmdd AND a.basis_yyyymmdd  <= @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.month_name		
			UNION ALL
			SELECT 'D_'+a.basis_yyyymmdd              AS yyyymmdd , a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
			 FROM [dbo].[scm_sys_calendar_m] a 
			WHERE a.basis_yyyymmdd  >= @p_from_yyyymmdd AND a.basis_yyyymmdd  <= @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd	
		) AS A
		ORDER BY sort_order_no  ;

--    PRINT @mQry_sum

 /********************************************************************************      
 * BOH temp 테이블 생성  
 ********************************************************************************/  
  IF OBJECT_ID('tempdb..#BOH') IS NOT NULL              
      DROP TABLE #BOH     
  
   SELECT SUM(ISNULL(PSI_BOH_QTY,0)) AS BOH, SITE_ID, ITEM_ID  
     INTO #BOH  
     FROM SSP_PLN_PLANT_ONHAND WITH (NOLOCK)      
    WHERE DIVISION_ID               = @p_division_id      
      AND STOCK_TYPE    NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')   --셀 특성완료이전 제외     
      AND PLAN_START_YYYYMMDD       = @p_plan_start_yyyymmdd      
      AND PLAN_TYPE                 = @p_plan_type      
      AND SEQ                       = @p_seq      
      --AND SITE_ID                   = @p_scm_site_id      
      --AND ITEM_ID                   = @p_item_id      
      AND YYYYMMDD                  = @p_plan_start_yyyymmdd     
    GROUP BY SITE_ID,ITEM_ID  
    ;  

	SET @mEXEC = '';
    SET @mEXEC		  = 'SELECT *                                                                                                                                             '+CHAR(10);
    SET @mEXEC = @mEXEC+'	FROM (SELECT                                                                                                                                      '+CHAR(10);
    SET @mEXEC = @mEXEC+'			     A.PSI_SEQ                                                                                                                                '+CHAR(10);
    SET @mEXEC = @mEXEC+'			    ,A.INVENTORY_SEQ                                                                                                                          '+CHAR(10);
    SET @mEXEC = @mEXEC+'			    ,A.DIVISION_ID                                                                                                                            '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.PLAN_START_YYYYMMDD                                                                                                                    '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.PLAN_TYPE                                                                                                                              '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.SEQ                                                                                                                                    '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.OPERATION_GROUP                                                                                                                        '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.OPERATION_GROUP_DESC                                                                                                                   '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.FROM_SITE                                                                                                                              '+CHAR(10);
--  SET @mEXEC = @mEXEC+'	        ,dbo.FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, FROM_SITE ) AS SITE_DESCRIPTION                                                             '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,(SELECT MAX(SITE_DESCRIPTION)  from SCM_MST_SITE WITH (NOLOCK) where SCM_SITE_ID = A.FROM_SITE ) AS SITE_DESCRIPTION                     '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.ITEM_ID                                                                                                                                '+CHAR(10);
--  SET @mEXEC = @mEXEC+'	        ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_ITEM_NICKNAME(A.division_id, A.item_id), '-')  AS NICK_NAME                                                '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,ISNULL((SELECT TOP 1 ISNULL(NICK_NAME,'''')  FROM DBO.SCM_MST_ITEM_SN WITH (NOLOCK)  WHERE ITEM_ID = A.ITEM_ID),''-'')  AS NICK_NAME     '+CHAR(10);
--  SET @mEXEC = @mEXEC+'         ,dbo.FN_GET_SSP_ANL_PSI_BOH_QTY(DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,FROM_SITE, ITEM_ID) AS BOH                                  '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,(select sum(isnull(x.BOH,0))    from #BOH x with (nolock)    where   x.site_id= A.FROM_SITE  and x.item_id = A.ITEM_ID ) AS BOH          '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.PSI_TYPE                                                                                                                               '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.PSI_NAME                                                                                                                               '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.origin_from_division_id                                                                                                                '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.origin_to_division_id                                                                                                                  '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,A.electrode_type                                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	        ,case when PSI_VALUE is null then ''ISSUM'' else PSI_VALUE end as ''PSI_VALUE''                                                           '+CHAR(10);
    SET @mEXEC = @mEXEC+'         ' +@mQry_sum                                                                                                                               +CHAR(10);  
    SET @mEXEC = @mEXEC+'   FROM #TblDynamicPivot_SSP0011 A WITH (NOLOCK)                                                                                                   '+CHAR(10);          
    SET @mEXEC = @mEXEC+'		GROUP BY ROLLUP( A.PSI_SEQ                                                                                                                      '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.INVENTORY_SEQ                                                                                                                '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.DIVISION_ID                                                                                                                  '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.plan_start_yyyymmdd                                                                                                          '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.PLAN_TYPE                                                                                                                    '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.SEQ                                                                                                                          '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.OPERATION_GROUP                                                                                                              '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.OPERATION_GROUP_DESC                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.FROM_SITE                                                                                                                    '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.ITEM_ID                                                                                                                      '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.origin_from_division_id                                                                                                      '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.origin_to_division_id                                                                                                        '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.ELECTRODE_TYPE                                                                                                               '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.PSI_TYPE                                                                                                                     '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.PSI_NAME                                                                                                                     '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                  ,A.PSI_VALUE                                                                                                                    '+CHAR(10);
    SET @mEXEC = @mEXEC+'	                 )                                                                                                                                '+CHAR(10);
    SET @mEXEC = @mEXEC+'	         ) A                                                                                                                                      '+CHAR(10);
    SET @mEXEC = @mEXEC+'	   WHERE A.DIVISION_ID        is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    and A.plan_start_yyyymmdd is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    and A.PLAN_TYPE           is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    and A.SEQ                 is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    AND A.OPERATION_GROUP     is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    and A.FROM_SITE           is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    and A.ITEM_ID             is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    and A.ELECTRODE_TYPE      is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    and A.psi_type            is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    and A.psi_name            is not null                                                                                                         '+CHAR(10);
    SET @mEXEC = @mEXEC+'	    AND not (PSI_TYPE=''I'' and PSI_VALUE = ''ISSUM'' )                                                                                           '+CHAR(10);
    SET @mEXEC = @mEXEC+'		ORDER BY  DIVISION_ID , OPERATION_GROUP, FROM_SITE , ITEM_ID, ELECTRODE_TYPE, PSI_SEQ, INVENTORY_SEQ ASC, case when PSI_VALUE = ''ISSUM'' then 99 else PSI_SEQ end                                        '+CHAR(10);
                                                                                                                                                                            
                                                                                                                                                                            
                     
--    PRINT (@mEXEC);
	EXEC (@mEXEC);

	END 
	
	--임시테이블 삭제
	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SSP0011') is not null 
	  DROP TABLE #TblDynamicPivot_SSP0011

END
