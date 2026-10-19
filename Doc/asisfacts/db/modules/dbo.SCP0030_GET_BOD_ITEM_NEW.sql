

/*
 * Program ID   : SCP0030_GET_BOD_ITEM
 * Description  : BOD ITEM 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/09/07   ygkim			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/23	hwyoon			SAFETY_STOCK 추가
 * 2021/06/10   khj79			[PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 2단계 개발(From , To 를 bod에서 관리) 
 * 2021/07/14   KMJ				[PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - UI 속도 개선 
 * 2023/06/29   vadabi3			[PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - ACTIVE_FLAG = N 은 조회 대상 제외
 * 2023/06/29   vadabi3			[PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - ACTIVE_FLAG = N Material 조건 적용
 *===================================================================================================
 * ex) EXEC SCP0030_GET_BOD_ITEM @p_division_id = '40', @p_from_site = '', @p_to_site = '', @p_incoterms = '', @p_trans_mode = ''
                 ,@p_item_id = '', @p_nick_name = '', @p_valid = ''
	
 */
CREATE PROCEDURE [dbo].[SCP0030_GET_BOD_ITEM_NEW]
  @p_division_id    NVARCHAR(MAX)
 ,@p_from_site      NVARCHAR(MAX)    
 ,@p_to_site		 NVARCHAR(MAX)
 ,@p_incoterms		 NVARCHAR(MAX)
 ,@p_trans_mode	 NVARCHAR(MAX)
 ,@p_item_id		 NVARCHAR(MAX)	
 ,@p_nick_name		 NVARCHAR(MAX)	
 ,@p_valid          NVARCHAR(1)
 ,@debug_mode       NVARCHAR(1)='F'

AS  
  
BEGIN
		SET NOCOUNT ON; 
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	    DECLARE @VAR_p_division_id	NVARCHAR(100)	= @p_division_id ;
	    DECLARE @VAR_p_from_site    NVARCHAR(MAX)   = @p_from_site   ;
	    DECLARE @VAR_p_to_site		NVARCHAR(MAX)	= @p_to_site	 ;
	    DECLARE @VAR_p_incoterms	NVARCHAR(1000)	= @p_incoterms	 ;
	    DECLARE @VAR_p_trans_mode	NVARCHAR(1000)	= @p_trans_mode	 ;
	    DECLARE @VAR_p_item_id		NVARCHAR(MAX)	= @p_item_id	 ;
	    DECLARE @VAR_p_nick_name	NVARCHAR(100)	= @p_nick_name	 ;
	    DECLARE @VAR_p_valid        NVARCHAR(1)		= @p_valid       ;
	    DECLARE @VAR_debug_mode     NVARCHAR(1)		= @debug_mode    ;
																	 

		DECLARE @arr_division_id	NVARCHAR(100)	= '';
		DECLARE @arr_from_site		NVARCHAR(MAX)   = '';
		DECLARE @arr_to_site		NVARCHAR(MAX)	= '';
		DECLARE @arr_incoterms		NVARCHAR(1000)	= '';
		DECLARE @arr_trans_mode		NVARCHAR(1000)	= '';
		DECLARE @arr_item_id		NVARCHAR(MAX)	= '';

		SELECT @arr_division_id		= ISNULL(@arr_division_id	+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_p_division_id,',')
		SELECT @arr_from_site		= ISNULL(@arr_from_site		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_P_from_site	,',')
		SELECT @arr_to_site			= ISNULL(@arr_to_site		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_P_to_site	,',')
		SELECT @arr_incoterms		= ISNULL(@arr_incoterms		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_P_incoterms	,',')
		SELECT @arr_trans_mode		= ISNULL(@arr_trans_mode	+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_P_trans_mode	,',')
		SELECT @arr_item_id			= ISNULL(@arr_item_id		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_P_item_id	,',')

		SET @arr_division_id = RIGHT(@arr_division_id,	LEN(@arr_division_id)	-1);
		SET @arr_from_site	 = RIGHT(@arr_from_site,	LEN(@arr_from_site)		-1);
		SET @arr_to_site	 = RIGHT(@arr_to_site,		LEN(@arr_to_site)		-1);
		SET @arr_incoterms	 = RIGHT(@arr_incoterms,	LEN(@arr_incoterms)		-1);
		SET @arr_trans_mode  = RIGHT(@arr_trans_mode,	LEN(@arr_trans_mode)	-1);
		SET @arr_item_id	 = RIGHT(@arr_item_id,		LEN(@arr_item_id)		-1);


		DECLARE @mEXEC NVARCHAR(MAX) = '';

		--------------------------------------------------------------------------------------------------------------------------------------------------------
		-- 20230629 List = [company, div, item] 이 구분에 필요하지만 Item 기준으로 하나라도 N이면 active_flag = N  간주
		SET @mEXEC = @mEXEC + 'with W_LIST_NO_ACTIVE AS									' + CHAR(10);
		SET @mEXEC = @mEXEC + '(   														' + CHAR(10);
		SET @mEXEC = @mEXEC + '   		  SELECT DISTINCT A.ITEM_ID, A.ACTIVE_FLAG		' + CHAR(10);
		SET @mEXEC = @mEXEC + '   			FROM SCM_MST_ITEM_SN  A	WITH(NOLOCK)					' + CHAR(10);
		SET @mEXEC = @mEXEC + '  INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B(NOLOCK) ON A.ITEM_CLASS = B.CLASS_ID            ' + CHAR(10);
		SET @mEXEC = @mEXEC + '   		   WHERE B.USE_FLAG = ''Y''						 ' + CHAR(10);
		SET @mEXEC = @mEXEC + '	  		     AND A.ACTIVE_FLAG = ''N''					 ' + CHAR(10);
		SET @mEXEC = @mEXEC + '	             and division_id IN ('+ @arr_division_id +') ' + CHAR(10);
		SET @mEXEC = @mEXEC + ')														 ' + CHAR(10);
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		SET @mEXEC = @mEXEC + 'SELECT'																												+ CHAR(10);
		SET @mEXEC = @mEXEC + '	  SEQ'																												+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, a.DIVISION_ID'																									+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, CUSTOMER'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, FROM_SITE_CODE'																									+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, FROM_CITY'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, TO_SITE_CODE'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, TO_CITY'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, INCOTERMS'																										+ CHAR(10);
		--SET @mEXEC = @mEXEC + '	, RANK'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, SAFETY_STOCK'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, TRANSPORT_MODE'																									+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, a.ITEM_ID'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, NICK_NAME'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, FROM_YYYYMMDD'																									+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, TO_YYYYMMDD'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, PRIORITY'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, BOD_ITEM_VALID'																									+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, BOD_VALID'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, ROUTE_VALID'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, ROUTE_ID'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, DAYS_MON'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, DAYS_TUE'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, DAYS_WED'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, DAYS_THU'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, DAYS_FRI'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, DAYS_SAT'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, DAYS_SUN'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, LEAD_TIME'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, CREATED_BY'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, CREATION_DATE'																									+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, LAST_UPDATED_BY'																									+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, LAST_UPDATE_DATE'																									+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, BOD_ID'																											+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, ORG_FROM_YYYYMMDD'																								+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, ORG_TO_YYYYMMDD'																									+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, MERGE_DATE'																										+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, Y = W.ACTIVE_FLAG'																								+ CHAR(10);
		SET @mEXEC = @mEXEC + '	, a.company_id'																									    + CHAR(10);
		
		SET @mEXEC = @mEXEC + 'FROM('																												+ CHAR(10);
		SET @mEXEC = @mEXEC + '		SELECT  DISTINCT'																																						+ CHAR(10); 
		SET @mEXEC = @mEXEC + '				a.seq'																																							+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,a.division_id'																																					+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,ISNULL(NULLIF((SELECT END_CUSTOMER FROM scm_mst_site WITH(NOLOCK) WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = b.TO_SITE),''''),''-'') AS customer'		+ CHAR(10);  	
		SET @mEXEC = @mEXEC + '				,b.from_site from_site_code'																																	+ CHAR(10);
		SET @mEXEC = @mEXEC + '				, (select max(company_id) from scm_mst_site	WITH(NOLOCK) where scm_site_id = b.from_site) as company_id'																		+ CHAR(10);
		--SET @mEXEC = @mEXEC + '				,d.city from_city'																																			+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,(SELECT CITY FROM scm_mst_site D WITH(NOLOCK) WHERE D.DIVISION_ID = A.DIVISION_ID AND D.SCM_SITE_ID = B.FROM_SITE) AS from_city'								+ CHAR(10);  
		SET @mEXEC = @mEXEC + '				,b.to_site to_site_code'																																		+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,e.city to_city'																																				+ CHAR(10);
		--SET @mEXEC = @mEXEC + '				,(SELECT TOP 1 CITY FROM scm_mst_site E WITH(NOLOCK) WHERE E.SCM_SITE_ID = B.TO_SITE) AS to_city'															+ CHAR(10);  
		SET @mEXEC = @mEXEC + '				,b.incoterms'																																					+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,RANK() OVER(ORDER BY a.seq ASC) AS ''RANK'''																													+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,a.SAFETY_STOCK'																																				+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,c.transport_mode'																																				+ CHAR(10); 
		SET @mEXEC = @mEXEC + '				,a.item_id'																																						+ CHAR(10);								
		SET @mEXEC = @mEXEC + '				--,ISNULL(NULLIF(dbo.fn_get_item_nickname (a.division_id, a.item_id ),''''),''-'') AS nick_name'																+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,ISNULL(NULLIF((SELECT TOP 1 NICK_NAME FROM SCM_MST_ITEM_SN WITH(NOLOCK) WHERE ITEM_ID = A.ITEM_ID AND NICK_NAME IS NOT NULL),''''),''-'') AS NICK_NAME'		+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,convert(date, a.from_yyyymmdd, 112) from_yyyymmdd'																												+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,convert(date, a.to_yyyymmdd, 112) to_yyyymmdd'																													+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,a.priority'																																					+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,a.valid_yn AS BOD_ITEM_VALID'																																	+ CHAR(10); 
 		SET @mEXEC = @mEXEC + '				,b.valid_yn AS BOD_VALID'																																		+ CHAR(10);   
 		SET @mEXEC = @mEXEC + '				,c.valid_yn AS ROUTE_VALID'																																		+ CHAR(10); 
 		SET @mEXEC = @mEXEC + '				,c.route_id'																																					+ CHAR(10);  
 		SET @mEXEC = @mEXEC + '				,c.days_mon'																																					+ CHAR(10);  
 		SET @mEXEC = @mEXEC + '				,c.days_tue'																																					+ CHAR(10);  
 		SET @mEXEC = @mEXEC + '				,c.days_wed'																																					+ CHAR(10);  
 		SET @mEXEC = @mEXEC + '				,c.days_thu'																																					+ CHAR(10);  
 		SET @mEXEC = @mEXEC + '				,c.days_fri'																																					+ CHAR(10);  
 		SET @mEXEC = @mEXEC + '				,c.days_sat'																																					+ CHAR(10);  
 		SET @mEXEC = @mEXEC + '				,c.days_sun'																																					+ CHAR(10);  
		SET @mEXEC = @mEXEC + '				,(SELECT v.lt_total FROM scp_mst_bod_v v WITH(NOLOCK) WHERE v.division_id = b.division_id  and v.bod_id = b.bod_id ) AS lead_time'								+ CHAR(10);  
		SET @mEXEC = @mEXEC + '				,a.created_by, a.creation_date, a.last_updated_by, a.last_update_date'																							+ CHAR(10);  
		SET @mEXEC = @mEXEC + '				,b.bod_id'																																						+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,a.from_yyyymmdd org_from_yyyymmdd'																																+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,a.to_yyyymmdd org_to_yyyymmdd'																																	+ CHAR(10);
		SET @mEXEC = @mEXEC + '				,a.from_yyyymmdd + a.to_yyyymmdd AS merge_date'																													+ CHAR(10);
		
		SET @mEXEC = @mEXEC + '		FROM scp_mst_bod_item a WITH(NOLOCK)'																																	+ CHAR(10); 
		
		SET @mEXEC = @mEXEC + '		INNER JOIN scp_mst_bod b WITH(NOLOCK) ON a.bod_id = b.bod_id'																											+ CHAR(10);
--		SET @mEXEC = @mEXEC + '		INNER HASH JOIN scp_mst_bod b WITH(NOLOCK) ON a.bod_id = b.bod_id'																											+ CHAR(10);

		SET @mEXEC = @mEXEC + '		LEFT OUTER JOIN scp_mst_distribution_route c WITH(NOLOCK) ON b.route_id = c.route_id'																					+ CHAR(10); 
		--SET @mEXEC = @mEXEC + '		LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, CITY FROM scm_mst_site WITH(NOLOCK)) d ON a.division_id = d.division_id and b.from_site = d.scm_site_id'			+ CHAR(10); 
		SET @mEXEC = @mEXEC + '		LEFT OUTER JOIN (SELECT DISTINCT SCM_SITE_ID, CITY FROM scm_mst_site WITH(NOLOCK)) e ON b.to_site = e.scm_site_id'														+ CHAR(10); 
		SET @mEXEC = @mEXEC + ') a'																																											+ CHAR(10);

		SET @mEXEC = @mEXEC + 'LEFT OUTER JOIN  W_LIST_NO_ACTIVE W ON w.item_id = a.item_id '																												+ CHAR(10);
		SET @mEXEC = @mEXEC + 'WHERE 1=1'																																									+ CHAR(10);
		SET @mEXEC = @mEXEC + 'and W.ACTIVE_FLAG IS NULL '																																						+ CHAR(10);

		IF NOT(@VAR_p_division_id	IS NULL		OR  @VAR_p_division_id  ='') 
			BEGIN SET @mEXEC = @mEXEC+'AND ( A.DIVISION_ID		IN ('+ @arr_division_id +') )					'+CHAR(10); END;
			
		IF NOT(@VAR_p_from_site		IS NULL     OR  @VAR_p_from_site	='') 
			BEGIN SET @mEXEC = @mEXEC+'AND ( A.FROM_SITE_CODE	IN ('+ @arr_from_site	+') )					'+CHAR(10); END;

		IF NOT(@VAR_p_to_site		IS NULL		OR  @VAR_p_to_site		='') 
			BEGIN SET @mEXEC = @mEXEC+'AND ( A.TO_SITE_CODE		IN ('+ @arr_to_site		+') )					'+CHAR(10); END;
			
		IF NOT(@VAR_p_incoterms		IS NULL     OR  @VAR_p_incoterms    ='') 
			BEGIN SET @mEXEC = @mEXEC+'AND ( A.INCOTERMS		IN ('+ @arr_incoterms	+') )					'+CHAR(10); END;
		
		IF NOT(@VAR_p_trans_mode	IS NULL     OR  @VAR_p_trans_mode   ='') 
			BEGIN SET @mEXEC = @mEXEC+'AND ( A.TRANSPORT_MODE	IN ('+ @arr_trans_mode	+') )					'+CHAR(10); END;
			
		IF NOT(@VAR_p_item_id		IS NULL		OR  @VAR_p_item_id	   ='') 
			BEGIN SET @mEXEC = @mEXEC+'AND ( A.ITEM_ID			IN ('+ @arr_item_id		+') )					'+CHAR(10); END;

		IF NOT(@VAR_p_valid			IS NULL		OR  @VAR_p_valid	   ='') 
			BEGIN SET @mEXEC = @mEXEC+'AND ( A.BOD_ITEM_VALID	= '''+ @VAR_p_valid     +''')					'+CHAR(10); END;

		IF NOT(@VAR_p_nick_name		IS NULL		OR  @VAR_p_nick_name	   ='') 
			BEGIN SET @mEXEC = @mEXEC+'AND ( A.NICK_NAME LIKE  ''%'	 + @VAR_p_nick_name +'%'')					'+CHAR(10); END;

		SET @mEXEC = @mEXEC + 'ORDER BY DIVISION_ID,A.ITEM_ID, FROM_SITE_CODE, TO_SITE_CODE,TRANSPORT_MODE		'+CHAR(10);

		EXEC (@mEXEC);

		-----------------------------------------------------------
		-- DEBUG QRY 출력
		-----------------------------------------------------------	
		IF( @VAR_debug_mode ='T')
		BEGIN				
			DECLARE @POS INT =1;
			DECLARE @LEN INT =LEN(@mEXEC);
			WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@mEXEC,@POS,4000);
				SET @POS = @POS+4000;
			END;
		END;
END

