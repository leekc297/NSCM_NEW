
/******************************************************************************************************/
/* Program ID  : [DMF0039_GET_ESS_SHIPMENT_PRIORITY]                                                  */
/* Description : Procedure 작성 가이드                                                                */
/* Usage       : Procedure 작성 시 참조하세요!                                                        */
/* Parameter   :                                                                                      */
/*                                                                                                    */
/*----------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                               */
/*----------------------------------------------------------------------------------------------------*/
/* 2018/12/05  JYE		      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/12/11  JYE			  EDIT_FLAG, ITEM_TYPE 수정												  */
/* 2018/12/20  JYE			  데이터 중복 제거														  */
/* 2019/10/25  hwi1993        주간으로 변경에 따라 월요일로 날짜 조정								  */
/* 2019/11/27  hwi1993        날짜조건 변경 250라인 근처. 일단 개발에만 적용						  */ 
/* 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리											  */
/*																									  */
/******************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0039_GET_ESS_SHIPMENT_PRIORITY]
    @p_division_id		NVARCHAR(30),
	@p_dept_id			NVARCHAR(4000),
    @p_end_customer		NVARCHAR(4000),
	@p_scm_site_id		NVARCHAR(4000),
    @p_project_code		NVARCHAR(4000),
	@p_item_id			NVARCHAR(4000),
	@p_sdate			NVARCHAR(8),
	@p_edate			NVARCHAR(8),
	@p_created_by		NVARCHAR(50),
	@p_userinfo			NVARCHAR(50)
AS  
BEGIN
  SET NOCOUNT ON;

	DECLARE @Prod		NVARCHAR(max)=''
	DECLARE @ColList	NVARCHAR(max)=''
	DECLARE @GroupList	NVARCHAR(max)=''
	DECLARE @nsql2		NVARCHAR(max)=''
	
	IF OBJECT_ID (N'tempdb..#MKT_FCST', N'U') IS NOT NULL 
	DROP TABLE #MKT_FCST
	IF OBJECT_ID (N'tempdb..#PRIORITY', N'U') IS NOT NULL 
	DROP TABLE #PRIORITY
	
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	DECLARE @v_group_id		NVARCHAR(50)=''

	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 IN ('ALL','DMF0039')  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_userinfo
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	-- 1. DM_PLN_MKT_FCST 를 기준으로 디스플레이할 데이터 select
	SELECT 
		MA.DIVISION_ID
		, MA.TEAM_ID
		, MA.END_CUSTOMER
		, MA.SCM_SITE_ID
		, MA.PROJECT_CODE
		, MA.PROJECT_NAME
		, MA.ITEM_ID
		, MA.NICK_NAME
		, MA.MEASURE
		--, MA.YYYYMM
		--, MA.YYYYMMDD
		, 'W_' + CAL.BASIS_START_DATE AS YYYYMMDD
		, SUM(MA.QTY) AS QTY
		, MA.EDIT_FLAG
	INTO #MKT_FCST
	FROM ( 
		SELECT DISTINCT		-- 20181220
			MKT_FCST.DIVISION_ID
			, DEPT_INFO.DEPT_ID AS TEAM_ID
			, SITE.END_CUSTOMER
			, MKT_FCST.SCM_SITE_ID
			, MKT_FCST.PROJECT_CODE
			, PJT.PROJECT_NAME
			, MKT_FCST.ITEM_ID
			, ITEM.NICK_NAME
			, 'Shipment Request' AS MEASURE
			, CONVERT(DECIMAL, MKT_FCST.QTY) AS QTY
			--, CONVERT(VARCHAR(7), DATEADD(DD, -1*ISNULL(BOD_V.LT_TOTAL, 0), CAST(MKT_FCST.YYYYMMDD AS DATETIME)) , 121 ) AS YYYYMM
			, CONVERT(VARCHAR(8), DATEADD(DD, -1*ISNULL(BOD_V.LT_TOTAL, 0), CAST(MKT_FCST.YYYYMMDD AS DATETIME)) , 112 ) AS YYYYMMDD
			, 'N' AS EDIT_FLAG	
		FROM DM_PLN_MKT_FCST AS MKT_FCST WITH(NOLOCK)
		LEFT JOIN (
			SELECT 
				TO_SITE
				, INCOTERMS
				, PRIORITY
				, LT_TOTAL
				, ROW_NUMBER() OVER ( PARTITION BY TO_SITE, INCOTERMS ORDER BY PRIORITY ASC, LT_TOTAL ASC) AS SEQ
			FROM [DBO].[SCP_MST_BOD_V] WITH(NOLOCK)
			WHERE DIVISION_ID = @p_division_id
		) AS BOD_V
		ON MKT_FCST.SCM_SITE_ID = BOD_V.TO_SITE
			AND MKT_FCST.INCOTERMS = BOD_V.INCOTERMS
			AND BOD_V.SEQ = 1
		INNER JOIN [dbo].SCM_MST_SITE AS SITE WITH(NOLOCK)
		ON  MKT_FCST.DIVISION_ID    = SITE.DIVISION_ID
			AND MKT_FCST.SCM_SITE_ID    = SITE.SCM_SITE_ID
			AND SITE.VALID_YN       = 'Y'
		INNER JOIN SCM_MST_SITE_ITEM AS SITE_ITEM WITH(NOLOCK)
		ON MKT_FCST.DIVISION_ID = SITE_ITEM.DIVISION_ID
			AND MKT_FCST.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
			AND MKT_FCST.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
			AND MKT_FCST.ITEM_ID = SITE_ITEM.ITEM_ID
			AND SITE_ITEM.VALID_YN = 'Y'
		LEFT JOIN SCM_MST_SSO_DEPT_INFO AS DEPT_INFO WITH(NOLOCK)
		ON SITE.DEPT_ID = DEPT_INFO.DEPT_ID
		-------------------------- Project --------------------------
		LEFT JOIN 
		(
			SELECT B.DIVISION_ID
				, B.PROJECT_CODE
				, B.PROJECT_NAME
				, B.PROJECT_OWNER
				, B.PROJECT_STATUS 
				, B.BIZ_TYPE
				, '' SCM_SITE_ID
				, '' ITEM_ID
				, '' DEPT_ID
				, '' DEPT_NAME_KO
				,SU.USER_ID
				,SU.USER_NAME
				,SU.USER_NAME_EN
			FROM SCM_MST_PROJECT B WITH(NOLOCK)
				,[SCM_MST_SSO_USER_INFO] SU WITH(NOLOCK)
			WHERE B.DIVISION_ID <> '40'
				AND B.PROJECT_OWNER = SU.USER_ID
		) AS PJT
		ON  MKT_FCST.DIVISION_ID = PJT.DIVISION_ID 
			AND MKT_FCST.PROJECT_CODE = PJT.PROJECT_CODE
		INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) B1
		ON CASE WHEN @p_project_code = '' THEN @p_project_code ELSE MKT_FCST.PROJECT_CODE END like B1.tst 
			OR CASE WHEN @p_project_code = '' THEN @p_project_code ELSE PJT.PROJECT_NAME END like B1.tst 
		-------------------------- Project --------------------------
		-------------------------- Item --------------------------
		INNER JOIN (
			SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
				, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, '' AS UCODE
				, FORECAST_INFO_BIZ_TYPE
				, FORECAST_INFO_PRODUCT_GROUP
				, FORECAST_INFO_CELL_PACK_COUNT
				, FORECAST_INFO_SPEC+FORECAST_INFOR_VERSION as FORECAST_INFO_SPEC
				, CELL_TYPE
				, MDM_PROJECT_NAME
				, MIN_CAPACITY
			 FROM DM_MST_ITEM_SINGLE_V  WITH(NOLOCK)
		) AS ITEM
		ON MKT_FCST.DIVISION_ID = SITE.DIVISION_ID
			AND MKT_FCST.ITEM_ID = ITEM.ITEM_ID
			AND ITEM.ITEM_TYPE IN ( 'P','H') -- SCP. 20181211
		INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) AS B2
		ON CASE WHEN @p_item_id = '' THEN @p_item_id ELSE MKT_FCST.ITEM_ID END like B2.tst
			OR CASE WHEN @p_item_id = '' THEN @p_item_id ELSE ITEM.NICK_NAME END like B2.tst
		-------------------------- Item --------------------------
		WHERE MKT_FCST.DIVISION_ID = @p_division_id
			AND MKT_FCST.MEASURE = 'MKT_FCST'
			--AND MKT_FCST.YYYYMMDD >= @p_sdate 
			--AND MKT_FCST.YYYYMMDD < @p_edate
			AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE DEPT_INFO.DEPT_ID END 
				IN (
					SELECT * 
					FROM dbo.UF_FX_String_SplitForIN (@p_dept_id,',') AS P 
					WHERE (CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE DEPT_INFO.DEPT_ID END) = P.DATA
				)
			AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(SITE.END_CUSTOMER, '') END
				IN (
					SELECT * 
					FROM dbo.UF_FX_String_SplitForIN (@p_end_customer,',') AS P 
					WHERE (CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(SITE.END_CUSTOMER, '') END) = P.DATA
				)
			AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE MKT_FCST.SCM_SITE_ID END
				IN (
					SELECT * 
					FROM dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') AS P 
					WHERE (CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE MKT_FCST.SCM_SITE_ID END) = P.DATA
				)
	) MA
	INNER JOIN [SCM_SYS_CALENDAR_M] AS CAL WITH(NOLOCK)
		ON MA.YYYYMMDD = CAL.BASIS_YYYYMMDD
	WHERE MA.YYYYMMDD >= @p_sdate -- substring(@p_sdate,1,6) -- hwi1993.2019.11.27
	  AND MA.YYYYMMDD <= @p_edate -- substring(@p_edate,1,6) -- hwi1993.2019.11.27
	GROUP BY 
		MA.DIVISION_ID
		, MA.TEAM_ID
		, MA.END_CUSTOMER
		, MA.SCM_SITE_ID
		, MA.PROJECT_CODE
		, MA.PROJECT_NAME
		, MA.ITEM_ID
		, MA.NICK_NAME
		, MA.MEASURE
		, MA.YYYYMMDD
		, CAL.BASIS_START_DATE
		, MA.EDIT_FLAG
	ORDER BY 	
		MA.DIVISION_ID
		, MA.TEAM_ID
		, MA.END_CUSTOMER
		, MA.SCM_SITE_ID
		, MA.PROJECT_CODE
		, MA.ITEM_ID
		, MA.YYYYMMDD
		, CAL.BASIS_START_DATE




	-- 2. DM_PLN_MKT_FCST 를 기준으로 DM_MST_SHIPMENT_PRIORITY 데이터 select
	INSERT #MKT_FCST
	SELECT
		DISTINCT
		MKT_FCST.DIVISION_ID
		, MKT_FCST.TEAM_ID
		, MKT_FCST.END_CUSTOMER
		, MKT_FCST.SCM_SITE_ID
		, MKT_FCST.PROJECT_CODE
		, MKT_FCST.PROJECT_NAME
		, MKT_FCST.ITEM_ID
		, MKT_FCST.NICK_NAME
		, 'Priority' AS MEASURE
		--, CONVERT(NVARCHAR(7), CONVERT(DATETIME, PRIORITY.YYYYMM + '01', 121), 121)
		, 'W_' + CONVERT(NVARCHAR(8), CONVERT(DATETIME, PRIORITY.YYYYMMDD , 121), 112)
		--, CONVERT(VARCHAR(8), DATEADD(DD, -1*ISNULL(BOD_V.LT_TOTAL, 0), CAST(MKT_FCST.YYYYMMDD AS DATETIME)) , 112 ) AS YYYYMMDD
		, CONVERT(DECIMAL, PRIORITY.PRIORITY)

		--, CASE WHEN @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN' OR @p_userinfo = 'SCP Planner' --20200311 KHSONG C20200103-000586 주석처리

		, CASE WHEN @v_group_id = 'ADMIN'  -- 20200311 KHSONG C20200103-000586 추가
				THEN 'Y' ELSE 'N' END AS EDIT_FLAG		-- 20181211
		FROM #MKT_FCST AS MKT_FCST WITH(NOLOCK)
	INNER JOIN DM_MST_SHIPMENT_PRIORITY AS PRIORITY WITH(NOLOCK)
	ON MKT_FCST.PROJECT_CODE = PRIORITY.PROJECT_CODE
		AND MKT_FCST.SCM_SITE_ID = PRIORITY.SCM_SITE_ID
		AND MKT_FCST.END_CUSTOMER = PRIORITY.END_CUSTOMER
		AND MKT_FCST.ITEM_ID = PRIORITY.ITEM_ID
		--AND MKT_FCST.YYYYMMDD = PRIORITY.YYYYMMDD
		
		

	INSERT #MKT_FCST
	SELECT 
		MA.DIVISION_ID
		, MA.TEAM_ID
		, MA.END_CUSTOMER
		, MA.SCM_SITE_ID
		, MA.PROJECT_CODE
		, MA.PROJECT_NAME
		, MA.ITEM_ID
		, MA.NICK_NAME
		, 'Priority' AS MEASURE
		--, MIN(MA.YYYYMM) AS YYYYMM
		, MIN(MA.YYYYMMDD) AS YYYYMMDD
		, null AS QTY

		--, CASE WHEN @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN' OR @p_userinfo = 'SCP Planner' -- 20200311 KHSONG C20200103-000586 주석처리
		, CASE WHEN @v_group_id = 'ADMIN'  -- 20200311 KHSONG C20200103-000586 추가

				THEN 'Y' ELSE 'N' END AS EDIT_FLAG		-- 20181211
	FROM (
		SELECT * FROM #MKT_FCST WITH(NOLOCK) WHERE MEASURE = 'Shipment Request') AS MA
		WHERE NOT EXISTS (
			SELECT * FROM (SELECT * FROM #MKT_FCST WITH(NOLOCK) WHERE MEASURE = 'Priority') AS SUB
			WHERE MA.PROJECT_CODE = SUB.PROJECT_CODE
				AND MA.SCM_SITE_ID = SUB.SCM_SITE_ID
				AND MA.END_CUSTOMER = SUB.END_CUSTOMER
				AND MA.ITEM_ID = SUB.ITEM_ID
		)
	GROUP BY 
		MA.DIVISION_ID
		, MA.TEAM_ID
		, MA.END_CUSTOMER
		, MA.SCM_SITE_ID
		, MA.PROJECT_CODE
		, MA.PROJECT_NAME
		, MA.ITEM_ID
		, MA.NICK_NAME
		, MA.MEASURE
		, MA.EDIT_FLAG

-- select * from #MKT_FCST

	-- 20191025 월요일로 날짜 조정
	UPDATE #MKT_FCST
	SET YYYYMMDD = 'W_' + CONVERT(CHAR(8), DATEADD(DAY, CASE WHEN DATEPART(DW, RIGHT(YYYYMMDD, 8)) = 1 THEN -6 ELSE 2-DATEPART(DW, RIGHT(YYYYMMDD, 8)) END, RIGHT(YYYYMMDD, 8)), 112)


	-- 3.1 피벗을 위한 날짜 데이터
	SELECT @Prod = @Prod + '[' + A.YYYYMMDD + '],'
	FROM (SELECT DISTINCT YYYYMMDD FROM #MKT_FCST WITH(NOLOCK) WHERE LEN(YYYYMMDD) >= 6) A
	ORDER BY YYYYMMDD
	IF @Prod = '' 
	BEGIN
		SET @Prod = 'D_99999999'
	END
	ELSE
	BEGIN
		Select @Prod = LEFT(@Prod, LEN(@Prod)-1)
	END

	--select @Prod

	-- 3.2 피벗을 위한 일반 칼럼 데이터
	SELECT @ColList = @ColList + '[' + COLUMN_NAME + '],'
			   , @GroupList = @GroupList + '[' + COLUMN_NAME + ']' + DATA_SORT_METHOD_CODE + ','
	FROM 
	(
		SELECT
			COL.SORT_ORDER_NO, COL.COLUMN_NAME, COL.DATA_SORT_METHOD_CODE
		FROM [SCM_MST_SHEET_COLUMNS] COL WITH(NOLOCK)
		WHERE 1 = 1
			AND    COL.PROGRAM_ID  = 'DMF0039'
			AND    COL.SHEET_NAME  = 'ESSPriority'
			AND    COL.VALID_YN     = 'Y'  
	) tbColList	
	ORDER BY SORT_ORDER_NO
	SELECT @ColList = LEFT(@ColList, LEN(@ColList)-1)	
	SELECT @GroupList = LEFT(@GroupList, LEN(@GroupList)-1)		

	--select @ColList
	--select @GroupList
		
	SET  @NSQL2 = '
SELECT  
		 ' + @ColList + '
		,' + @Prod + '
From(
	SELECT YYYYMMDD, SUM(QTY) AS QTY, ' + @ColList + '
	FROM #MKT_FCST
	GROUP BY YYYYMMDD, ' + @ColList + '
	) T
PIVOT (MAX(QTY) FOR YYYYMMDD IN (' + @Prod + ')
) AS PVT

ORDER BY 
		 ' + @GroupList + '			
'
execute dbo.SP_executesql @NSQL2 
--print @NSQL2


-- XML 아웃
     --SELECT CONVERT(TEXT, @NSQL2)
     --FOR XML PATH('')--,ROOT('x') 

END
	



