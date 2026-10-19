/***************************************************************************************************
* Program ID  : DM0004_GET_SALES_SITE_DATA                                                     
* Description : Procedure 작성 가이드                                                           
* Usage       : Procedure 작성 시 참조하세요!                                                   
* Parameter   :                                                                                
*                                                                                              
*----------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                         
*----------------------------------------------------------------------------------------------
* 2017/11/30  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
* 2018/05/30  JYE			복수 팀 권한 관련  수정  
* 2018/09/07  Son young suk		COMPANY_ID select 추가                                      
* 2019/01/31  zytchoi 		재료부분 Order by 조건 추가                                          
* 2020/03/06  hwi1993 		[CSR:C20200303-000235 ]출하요청 데이터를 자동으로 생성할 지 여부 필드 추가 ( ATTRIBUTE2 )			
** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
** 2020/04/22  P.C.I 		[PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선-유통경로 추가 
** 2020/10/08  P.C.I 		[C20200915-000323] Sales Site 에대한 team 변경 권한 추가             
* 2020/11/11	hwi1993		SI mkt fcst 입력시 vmi req 자동 산출. site 별로 vmi 재고일수 추가 ( attribute5)
** 2020/12/24  P.C.I 		[C20201222-000383] 'SCM PI Admin' 에 Team변경 권한 추가 
* 2021.11.18 kdw2819		[과제]	자동차 사업부 JV Planner 의 조회 권한 추가
* 2022.03.31	rosia27		[과제PJ20216891R]GM_JV
****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0004_GET_SALES_SITE_DATA]
  @p_division_id		NVARCHAR(50),	--Division
  @p_dept_id			NVARCHAR(4000),	--Team
  @p_end_customer		NVARCHAR(4000),	--  EndCustomer
  @p_scm_site_id		NVARCHAR(4000),	--FCST Type
  @p_active_flag		NVARCHAR(50),   --, @p_debug         NVARCHAR(MAX) OUTPUT
  @p_created_by			NVARCHAR(50),
  @p_userinfo			NVARCHAR(50),
  @p_soldto_customer	NVARCHAR(4000),
  @p_user_dept_id		NVARCHAR(50)	-- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
  
AS  
  
BEGIN
  SET NOCOUNT ON;
	DECLARE @v_sql_text          AS NVARCHAR(MAX);
  	DECLARE @v_group_id nvarchar(max)='';

	--IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN'

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_userinfo
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------
   
  SET @v_sql_text = '
	SELECT S.DIVISION_ID		  
		 /*
		 , S.DEPT_ID       AS TEAM_ID
		 , T.DEPT_NAME_KO  AS TEAM_NAME	  
		 , S.END_CUSTOMER
		 */
		 , CASE WHEN S.DIVISION_ID = ''40'' THEN ''XXX'' ELSE S.DEPT_ID END   AS TEAM_ID
		 , CASE WHEN S.DIVISION_ID = ''40'' THEN ''XXX'' ELSE T.DEPT_NAME_KO END  AS TEAM_NAME	  
		 , CASE WHEN S.DIVISION_ID = ''40'' THEN ''acer'' ELSE S.END_CUSTOMER END AS END_CUSTOMER
		 , S.SOLDTO_CUSTOMER 
		 , C.SOLDTO_CODE   AS REP_SOLDTO_CODE
		 , C.SHIPTO_CODE   AS REP_SHIPTO_CODE
		 , S.COUNTRY
		 , CO.COUNTRY_NAME
		 , S.CITY
		 , CT.CITY_NAME
		 , S.SCM_SITE_ID
		 , S.COMPANY_ID -- 20180907 ADD son young suk
		 , S.SITE_DESCRIPTION
		 , S.ATTRIBUTE3   AS DISTRIBUTION_CHANNEL -- [PJ20200138] 유통경로 추가
		 , S.VMI_YN
		 , S.VALID_YN
		 , S.LAST_UPDATED_BY
		 , S.LAST_UPDATE_DATE
		 , S.ATTRIBUTE2 AS SHIP_PLAN_AUTO
		 , CASE WHEN S.DIVISION_ID <> ''40'' AND (([dbo].[FN_GET_DEPT_LIST](''[@p_created_by]'', S.DEPT_ID) = ''Y'') OR ''[@v_group_id]'' =''ADMIN'')  THEN ''Y''
	            WHEN S.DIVISION_ID = ''40'' AND(([dbo].[FN_GET_DEPT_LIST2](''[@p_created_by]'', S.SCM_SITE_ID) = ''Y'') 
						OR ''[@v_group_id]'' =''ADMIN'' OR ''[@p_created_by]'' = S.LAST_UPDATED_BY) THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
		 --[C20200915-000323] Sales Site 에대한 team 변경 권한 추가
		 , (SELECT ISNULL(MAX(LU.VALID_YN) ,''N'')
			FROM   SCM_ADM_LOOKUP_MASTER_DETAIL AS LU WITH(NOLOCK)
			WHERE  LU.LOOKUP_TYPE = ''SALES_MGMT_TEAM''
			AND    LU.VALID_YN = ''Y''
			AND  ( LU.SEGMENT1 = (SELECT MAX(Dept_ID)
								  FROM   [dbo].[TB_FX_User] WITH(NOLOCK)
								  WHERE UserID = ''[@p_created_by]'')
			    OR LU.SEGMENT1 = ''[@p_userinfo]'' )	--[C20201222-000383] SCM PI Admin 에 Team변경 권한 추가 
			AND    ''[@v_group_id]'' =''ADMIN'') AS TEAM_EDIT_FLAG
		, S.ATTRIBUTE5
	FROM  [dbo].[SCM_MST_SITE]  S   WITH(NOLOCK) 
	LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = ''Y'') AS T
	   ON S.DEPT_ID = T.DEPT_ID
	LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER AS C  WITH(NOLOCK)
	   ON (    S.DIVISION_ID = C.DIVISION_ID
	       AND S.SCM_SITE_ID = C.SCM_SITE_ID
	       AND C.REP_YN = ''Y'' 
		   -- modified by ytchoi 180601
		   AND C.VALID_YN = ''Y''
		  )
	LEFT JOIN SCM_MST_COUNTRY AS CO  WITH(NOLOCK)
	   ON S.COUNTRY = CO.COUNTRY
	LEFT JOIN SCM_MST_CITY AS CT  WITH(NOLOCK)
	   ON (    S.COUNTRY = CT.COUNTRY
	       AND S.CITY    = CT.CITY )	
	WHERE S.SITE_TYPE = ''SALES''
	-- AND   S.END_CUSTOMER IS NOT NULL
	[@v_division_id]
	[@v_dept_id]
	[@v_end_customer]
	[@v_scm_site_id]
	[@v_soldto_customer]
	[@v_active_flag]
	/*
	ORDER BY S.DIVISION_ID, S.DEPT_ID, S.END_CUSTOMER, S.SITE_DESCRIPTION, S.SCM_SITE_ID
	*/
	';
	IF @p_division_id = '40'
		SET @v_sql_text = @v_sql_text + 'ORDER BY S.DIVISION_ID, S.SITE_DESCRIPTION, S.SCM_SITE_ID';
	ELSE
		SET @v_sql_text = @v_sql_text + 'ORDER BY S.DIVISION_ID, S.DEPT_ID, S.END_CUSTOMER, S.SITE_DESCRIPTION, S.SCM_SITE_ID';


	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_division_id]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('S.DIVISION_ID' , 'EQ', @p_division_id ));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_dept_id]'      , [dbo].[FN_SCM_GET_WHERE_SQL]('S.DEPT_ID'     , 'EQ', @p_dept_id     ));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_customer]' , [dbo].[FN_SCM_GET_WHERE_SQL]('S.END_CUSTOMER', 'EQ', @p_end_customer));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_scm_site_id]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('S.SCM_SITE_ID' , 'EQ', @p_scm_site_id ));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_soldto_customer]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('S.SOLDTO_CUSTOMER'    , 'EQ', @p_soldto_customer ));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_active_flag]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('S.VALID_YN'    , 'EQ', @p_active_flag ));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@p_created_by]'   , @p_created_by   );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_group_id]'      , @v_group_id      );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@p_userinfo]'      , @p_userinfo      ); --[C20201222-000383] SCM PI Admin 에 Team변경 권한 추가 

 
  --SET @p_debug = @v_sql_text;
  --RETURN @p_debug;
  --SELECT @v_sql_text
  EXEC SP_EXECUTESQL @v_sql_text; 
								  
END
