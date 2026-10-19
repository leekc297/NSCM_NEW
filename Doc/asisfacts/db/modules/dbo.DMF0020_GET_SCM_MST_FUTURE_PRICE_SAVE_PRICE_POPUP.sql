/****************************************************************************************************/
/* Program ID  : [DMF0020_GET_SCM_MST_FUTURE_PRICE]                                                 */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2021/03/04  kuniid         [C20210127-000163] GSCM Sales Price 일괄입력 기능 개선 요청 */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP]
    @p_division_id				NVARCHAR(30),
	@p_dept_id					NVARCHAR(4000),	--Department
    @p_end_customer				NVARCHAR(4000),	--Endcustomer
	@p_scm_site_id				NVARCHAR(4000),
	@p_plant_site_id			NVARCHAR(4000),
    @p_project_code				NVARCHAR(4000),
	@p_item_id					NVARCHAR(4000),
	@p_customer_project_code	NVARCHAR(4000),
	@p_customer_model			NVARCHAR(4000),
	@p_from_yyyymmdd			NVARCHAR(8),
	@p_to_yyyymmdd				NVARCHAR(8),
	@p_biztype					NVARCHAR(4000),
	@p_created_by				NVARCHAR(50),
	@p_userinfo					NVARCHAR(50),
	@p_owner					NVARCHAR(50),
	@p_over_range	            NVARCHAR(1),   -- [PJ20200138]범위 초과 Flag
	@p_invalid_exec	            NVARCHAR(1)   -- [C20200612-000174] ESS사업부 New Model Flag
AS  

BEGIN
  SET NOCOUNT ON;
  SET ANSI_WARNINGS OFF;

  --SELECT 'TEST01' AS DIVISION_ID , '1' AS SCM_SITE_ID , 'M1' AS MEASURE
  --UNION ALL
  --SELECT 'TEST02' AS DIVISION_ID , '2' AS SCM_SITE_ID , 'M2' AS MEASURE
  
    --DECLARE @v_dept_id nvarchar(max)='';
	DECLARE @v_group_id			nvarchar(50)='';
	DECLARE @p_program_id		NVARCHAR(MAX)='DMF0020'		-- 20180605 수정
	DECLARE @v_to_yyyymmdd2		NVARCHAR(8)                 -- [PJ20200138] 비교 날짜
	DECLARE @p_valid_yn			nvarchar(10) = 'Y'  --[C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공

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

	DECLARE @Prod varchar(max);
	DECLARE @nsql nvarchar(max);
	SELECT  @Prod = '';
  
	--[C20200506-000201] 속도개선 임시테이블 #tmpItem, #tmpPlanData 추가 
	IF OBJECT_ID (N'tempdb..#tmpItem', N'U') IS NOT NULL 
		DROP TABLE #tmpItem
	IF OBJECT_ID (N'tempdb..#tmpPlanData', N'U') IS NOT NULL 
		DROP TABLE #tmpPlanData
	IF OBJECT_ID (N'tempdb..#tmpData', N'U') IS NOT NULL 
		DROP TABLE #tmpData
	IF OBJECT_ID (N'tempdb..#tmpOutput', N'U') IS NOT NULL 
		DROP TABLE #tmpOutput
	-- [PJ20200138] 범위를 초과하는 대상 테이블
	IF OBJECT_ID (N'tempdb..#tmpOverRange', N'U') IS NOT NULL 
		DROP TABLE #tmpOverRange
	IF OBJECT_ID (N'tempdb..#tmpOverRangeList', N'U') IS NOT NULL 
		DROP TABLE #tmpOverRangeList
	--[C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
	IF OBJECT_ID (N'tempdb..#tmpSalesSiteModelAll', N'U') IS NOT NULL 
		DROP TABLE #tmpSalesSiteModelAll
	IF OBJECT_ID (N'tempdb..#tmpSalesSiteModel', N'U') IS NOT NULL 
		DROP TABLE #tmpSalesSiteModel
	
	
    -- [PJ20200138] 범위 초과 대상
	IF (@p_over_range = 'Y')
		BEGIN 
			SET @v_to_yyyymmdd2 = CONVERT(CHAR(8), DATEADD(DD, +7, @p_to_yyyymmdd), 112);
			
			SELECT DISTINCT AA.DIVISION_ID, AA.PROJECT_CODE, AA.SCM_SITE_ID, AA.PLANT_SITE_ID, AA.ITEM_ID, AA.CURRENCY, AA.MEASURE, AA.DOM_EXP, AA.FCST_TYPE, AA.INCOTERMS, AA.YYYYMMDD
			INTO #tmpOverRange
			FROM
				-- 기준데이터 
				(
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, YYYYMMDD
					, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS ROWNUM
				FROM SCM_MST_FUTURE_PRICE  A WITH(NOLOCK) 
				WHERE DIVISION_ID = @p_division_id
				AND   MEASURE = 'LOC'
				AND   YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				) AA
				-- 비교용 데이터 ( 다음주 )
			LEFT OUTER JOIN 
				(
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, YYYYMMDD
					, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS ROWNUM
				FROM SCM_MST_FUTURE_PRICE   A WITH(NOLOCK) 
				WHERE DIVISION_ID = @p_division_id
				AND   MEASURE = 'LOC'
				AND   YYYYMMDD BETWEEN @p_from_yyyymmdd AND @v_to_yyyymmdd2
				) BB ON AA.DIVISION_ID = BB.DIVISION_ID
					AND AA.PROJECT_CODE = BB.PROJECT_CODE
					AND AA.SCM_SITE_ID = BB.SCM_SITE_ID
					AND AA.PLANT_SITE_ID = BB.PLANT_SITE_ID
					AND AA.ITEM_ID = BB.ITEM_ID
					AND AA.CURRENCY = BB.CURRENCY
					AND AA.MEASURE = BB.MEASURE
					AND AA.DOM_EXP = BB.DOM_EXP 
					AND AA.FCST_TYPE = BB.FCST_TYPE 
					AND AA.INCOTERMS = BB.INCOTERMS
					AND AA.ROWNUM = BB.ROWNUM +1
				-- 비교용 데이터 ( 직전주차-없으면 마지막 주차 )
			LEFT JOIN 
				(
				SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE
					, A.YYYYMMDD
				FROM SCM_MST_FUTURE_PRICE  A WITH(NOLOCK) 
					JOIN (
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
						, MAX(YYYYMMDD) AS YMD
					FROM SCM_MST_FUTURE_PRICE  A WITH(NOLOCK) 
					WHERE DIVISION_ID = @p_division_id
					AND   MEASURE = 'LOC'
					AND   YYYYMMDD < @p_from_yyyymmdd
					GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
					) B ON A.DIVISION_ID = B.DIVISION_ID
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.CURRENCY = B.CURRENCY
						AND A.MEASURE = B.MEASURE
						AND A.DOM_EXP = B.DOM_EXP 
						AND A.FCST_TYPE = B.FCST_TYPE 
						AND A.INCOTERMS = B.INCOTERMS
						AND A.YYYYMMDD = B.YMD
				) CC ON AA.DIVISION_ID = CC.DIVISION_ID
					AND AA.PROJECT_CODE = CC.PROJECT_CODE
					AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
					AND AA.PLANT_SITE_ID = CC.PLANT_SITE_ID
					AND AA.ITEM_ID = CC.ITEM_ID
					AND AA.CURRENCY = CC.CURRENCY
					AND AA.MEASURE = CC.MEASURE
					AND AA.DOM_EXP = CC.DOM_EXP 
					AND AA.FCST_TYPE = CC.FCST_TYPE 
					AND AA.INCOTERMS = CC.INCOTERMS
					AND AA.ROWNUM = 1
					
			JOIN (SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS LIMIT
					FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					WHERE  VALID_YN = 'Y'
					AND    LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE' ) L
			ON     AA.DIVISION_ID = L.DIVISION_ID
			WHERE CASE WHEN AA.ROWNUM = '1'  AND (AA.PRICE * L.LIMIT) < ABS(CC.PRICE - AA.PRICE) THEN 'Y'
			           WHEN AA.ROWNUM <> '1' AND (BB.PRICE * L.LIMIT) < ABS(BB.PRICE - AA.PRICE) THEN 'Y'
					   ELSE 'N'
			      END = 'Y'

				;
				
				
			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
				,REPLACE(ISNULL([1],''),',','') +ISNULL([2],'') +ISNULL([3],'') +ISNULL([4],'')+ISNULL([5],'')+ISNULL([6],'')+ISNULL([7],'')+ISNULL([8],'')+ISNULL([9],'')+ISNULL([10],'')
				+ISNULL([11],'')+ISNULL([12],'')+ISNULL([13],'')+ISNULL([14],'')+ISNULL([15],'')+ISNULL([16],'')+ISNULL([17],'')+ISNULL([18],'')+ISNULL([19],'')+ISNULL([20],'')
				+ISNULL([21],'')+ISNULL([22],'')+ISNULL([23],'')+ISNULL([24],'')+ISNULL([25],'')+ISNULL([26],'')+ISNULL([27],'')+ISNULL([28],'')+ISNULL([29],'')+ISNULL([30],'')
				+ISNULL([31],'')+ISNULL([32],'')+ISNULL([33],'')+ISNULL([34],'')+ISNULL([35],'')+ISNULL([36],'')+ISNULL([37],'')+ISNULL([38],'')+ISNULL([39],'')+ISNULL([40],'')
				+ISNULL([41],'')+ISNULL([42],'')+ISNULL([43],'')+ISNULL([44],'')+ISNULL([45],'')+ISNULL([46],'')+ISNULL([47],'')+ISNULL([48],'')+ISNULL([49],'')+ISNULL([50],'')
				+ISNULL([51],'')+ISNULL([52],'') AS COL_LIST
			INTO #tmpOverRangeList
			FROM (
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, ',W_' + YYYYMMDD AS YYYYMMDD
					, ROW_NUMBER() OVER ( PARTITION BY 	DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD ) AS ROW_NUM
				FROM #tmpOverRange
				) A
			PIVOT (
				MAX(YYYYMMDD) FOR ROW_NUM IN ( [1],[2],[3],[4],[5],[6],[7],[8],[9],[10]
												,[11],[12],[13],[14],[15],[16],[17],[18],[19],[20]
												,[21],[22],[23],[24],[25],[26],[27],[28],[29],[30]
												,[31],[32],[33],[34],[35],[36],[37],[38],[39],[40]
												,[41],[42],[43],[44],[45],[46],[47],[48],[49],[50]
												,[51],[52] )
				) AS UNPVT




		END
  
  
	--[C20200506-000201] 속도개선 임시테이블 #tmpItem, #tmpPlanData 추가 
		
SELECT * 
INTO #tmpItem
FROM DM_MST_ITEM_SINGLE_V  WITH(NOLOCK)
WHERE DIVISION_ID = @p_division_id

SELECT    
   A.DIVISION_ID,
   A.SCM_SITE_ID,
   A.PLANT_SITE_ID,
   A.PROJECT_CODE,
   A.ITEM_ID,
   A.INCOTERMS,
   A.CURRENCY,
   A.FCST_TYPE,
   A.DOM_EXP
INTO #tmpPlanData
FROM SCM_MST_FUTURE_PRICE AS A WITH(NOLOCK)
WHERE   (A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd)		       
		AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE A.DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.data
	               )
		AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   		 ELSE A.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.data
	               )
		AND CASE WHEN @p_plant_site_id = 'ALL' THEN 'ALL'
		   		 ELSE A.PLANT_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_plant_site_id,',') as P Where 
					(CASE WHEN @p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.data
	               )
		-- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (START)
		AND EXISTS (  SELECT B.DIVISION_ID
							FROM SCM_MST_SITE B  WITH(NOLOCK) 
							WHERE A.DIVISION_ID	  = B.DIVISION_ID
							AND A.SCM_SITE_ID	  = B.SCM_SITE_ID
							AND B.VALID_YN	  = 'Y' )
		AND EXISTS (  SELECT B.DIVISION_ID
						   FROM SCM_MST_SITE_ITEM B  WITH(NOLOCK) 
						  WHERE A.DIVISION_ID	= B.DIVISION_ID
							AND A.PROJECT_CODE  = B.PROJECT_CODE
							AND A.SCM_SITE_ID	= B.SCM_SITE_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND B.VALID_YN	  = 'Y'   )
		-- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (END)

				
GROUP BY 
   A.DIVISION_ID,
   A.SCM_SITE_ID,
   A.PLANT_SITE_ID,
   A.PROJECT_CODE,
   A.ITEM_ID,
   A.INCOTERMS,
   A.CURRENCY,
   A.FCST_TYPE,
   A.DOM_EXP


   
SELECT    
   A.DIVISION_ID,
   B.DIVISION_NAME,
   DEPRTMENT.DEPT_ID AS UPPER_DEPT_ID,
   --TEAM.DEPT_ID,			--20180625
   CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END DEPT_ID,   
   --CASE WHEN isnull(TEAM.DEPT_NAME_KO,'') = '' THEN '' ELSE RIGHT(isnull(TEAM.DEPT_NAME_KO,''), CHARINDEX('.',REVERSE(isnull(TEAM.DEPT_NAME_KO,''))) -1) END AS TEAM_INCHARGE,
   A.SCM_SITE_ID,
   A.PLANT_SITE_ID,
   C.SITE_DESCRIPTION,   
   isnull(C.END_CUSTOMER,'') AS END_CUSTOMER,
   A.PROJECT_CODE,
   PJT.PROJECT_NAME,
   PJT.BIZ_TYPE as BIZ_TYPE_NAME,
   --PJT.BIZ_TYPE_NAME,
   PJT.PROJECT_STATUS,
   PJT.PROJECT_OWNER,
   A.ITEM_ID,
   ITEM.ITEM_CLASS_NAME, 
   isnull(ITEM.ITEM_NAME,'')AS ITEM_NAME,
   A.INCOTERMS,
   --SITE_ITEM.CURRENCY,
   A.CURRENCY,
   A.FCST_TYPE,
   A.DOM_EXP,
   --MEASURE.LOOKUP_CODE AS MEASURE,
   --MEASURE.DISPLAY_SEQ,
   --CASE WHEN (RTRIM(TEAM.DEPT_ID) = RTRIM(@v_dept_id) OR @v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
   CASE WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, 
		--TEAM.DEPT_ID
		CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
		) = 'Y') OR @v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
   --,A.YYYYMMDD
   ,ITEM.NICK_NAME --20180711
   --,A.PRICE

INTO #tmpData
FROM #tmpPlanData AS A WITH(NOLOCK)
	INNER JOIN SCM_MST_DIVISION AS B WITH(NOLOCK) 
		ON A.DIVISION_ID = B.DIVISION_ID
		AND B.VALID_YN = 'Y'

	INNER JOIN SCM_MST_SITE AS C  WITH(NOLOCK)
		ON	A.DIVISION_ID = C.DIVISION_ID
		AND A.SCM_SITE_ID = C.SCM_SITE_ID
		AND C.SITE_TYPE = 'SALES'
		AND C.VALID_YN = 'Y'

	LEFT JOIN SCM_MST_SITE AS D WITH(NOLOCK)
		ON	A.DIVISION_ID = D.DIVISION_ID
		AND A.SCM_SITE_ID = D.SCM_SITE_ID
		AND C.SITE_TYPE = 'PLANT'
		AND D.VALID_YN = 'Y'

	LEFT JOIN SCM_MST_SSO_DEPT_INFO AS TEAM WITH(NOLOCK) 		       
		ON C.DEPT_ID = TEAM.DEPT_ID
		AND TEAM.VALID_YN = 'Y'

	LEFT JOIN SCM_MST_SSO_DEPT_INFO AS DEPRTMENT WITH(NOLOCK)			       
		ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
		AND DEPRTMENT.VALID_YN = 'Y'

	INNER JOIN #tmpItem AS ITEM 
		ON	A.DIVISION_ID = ITEM.DIVISION_ID
		AND A.ITEM_ID  = ITEM.ITEM_ID
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
		UNION
		SELECT SI.DIVISION_ID
			,SI.PROJECT_CODE PROJECT_CODE
			,'' PROJECT_NAME
			,SI.OWNER PROJECT_OWNER
			,'' PROJECT_STATUS
			,'' BIZ_TYPE
			,SI.SCM_SITE_ID 
			,SI.ITEM_ID
			,SU.DEPT_ID
			,TM.DEPT_NAME_KO
			,SU.USER_ID
			,SU.USER_NAME
			,SU.USER_NAME_EN
	-- 20180810 ------------------------------------------
			FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK)

				LEFT JOIN [SCM_MST_SSO_USER_INFO] SU WITH(NOLOCK)
					ON SU.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](SI.OWNER, ','))

				LEFT JOIN [SCM_MST_SSO_DEPT_INFO] TM WITH(NOLOCK)
					ON SU.DEPT_ID = TM.DEPT_ID

		WHERE SI.DIVISION_ID = '40'	
		-- 20180810 ------------------------------------------

	) AS PJT 
		ON	A.DIVISION_ID = PJT.DIVISION_ID
		AND A.PROJECT_CODE = PJT.PROJECT_CODE
		AND CASE WHEN @p_division_id = '40' THEN PJT.SCM_SITE_ID ELSE A.SCM_SITE_ID END =  A.SCM_SITE_ID    -- modified by ytchoi 180802
		AND CASE WHEN @p_division_id = '40' THEN PJT.ITEM_ID ELSE A.ITEM_ID END = A.ITEM_ID

	LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM WITH(NOLOCK) WHERE VALID_YN = 'Y') AS SITE_ITEM
		ON SITE_ITEM.DIVISION_ID = A.DIVISION_ID
		AND SITE_ITEM.PROJECT_CODE = A.PROJECT_CODE
		AND SITE_ITEM.SCM_SITE_ID = A.SCM_SITE_ID
		AND SITE_ITEM.ITEM_ID = A.ITEM_ID

	LEFT JOIN [SCM_MST_SSO_USER_INFO] AS USER_INFO	--20180724
		ON SITE_ITEM.OWNER = USER_INFO.USER_ID		
		-------------------------- Project --------------2018/07/30  Son Young Suk---------------------
			INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) b1
			ON      CASE WHEN @p_project_code = '' THEN @p_project_code			
					ELSE PJT.PROJECT_CODE  END like  b1.tst 
			OR      CASE WHEN @p_project_code = '' THEN @p_project_code			
					ELSE PJT.PROJECT_NAME  END like  b1.tst 
		-----------------------------------------------------------------------------------------------
	------------  20180806  -------------------------------------------------------------------			
	INNER JOIN (
					SELECT DISTINCT X.OWNER
						FROM SCM_MST_SITE_ITEM AS X  WITH(NOLOCK) 
						LEFT JOIN SCM_MST_SSO_USER_INFO AS UI  WITH(NOLOCK) 
						ON X.PROJECT_CODE = UI.USER_ID
						INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_owner,',') ) c
							ON    (
									CASE WHEN @p_owner = '' THEN @p_owner			
									ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](x.OWNER, ',', '1') END like  c.tst 
									OR
									CASE WHEN @p_owner = '' THEN @p_owner			
									ELSE X.OWNER END like  c.tst 
									OR
									CASE WHEN @p_owner = '' THEN @p_owner			
									ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](X.OWNER, ',', '2') END like  c.tst 
									)
					where X.DIVISION_ID = @p_division_id
						AND @p_owner <> ''
						UNION all
						select '11'
						where @p_owner = ''
			) X
	ON  ISNULL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN @p_owner = '' THEN  ISNULL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END	
	-----------------------------------------------------------------------------------------------
	/*CROSS JOIN
	(
	SELECT  COLUMN_NAME AS LOOKUP_CODE, 
			COLUMN_LABEL_NAME AS [DESCRIPTION], 
			SORT_ORDER_NO AS DISPLAY_SEQ
	FROM     SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		WHERE  (PROGRAM_ID = @p_program_id AND SHEET_NAME = 'Sales Price')
				AND COLUMN_NAME <> 'LOC'

	UNION

	SELECT  COLUMN_NAME AS LOOKUP_CODE, 
			COLUMN_LABEL_NAME AS [DESCRIPTION], 
			SORT_ORDER_NO AS DISPLAY_SEQ
	FROM     SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		WHERE  (PROGRAM_ID = @p_program_id AND SHEET_NAME = 'Sales Price')
				AND COLUMN_NAME = 'LOC'
	) AS MEASURE*/

WHERE   1=1
		AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   		 --ELSE TEAM.DEPT_ID			
				 ELSE CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
					(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE 
						--TEAM.DEPT_ID 
						CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
					END) = P.data
	               )
		AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE isnull(
					CASE WHEN @p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END
				 ,'')			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
					(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(
						CASE WHEN @p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END
					,'') END) = P.data
	               )
		AND CASE WHEN @p_biztype = 'ALL' THEN 'ALL'  --20180822
		   		 ELSE --PJT.BIZ_TYPE			
					CASE WHEN @p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_biztype,',') as P Where 
					(CASE WHEN @p_biztype = 'ALL' THEN 'ALL' ELSE 
					--PJT.BIZ_TYPE 
					CASE WHEN @p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
					END) = P.data
	               )
GROUP BY 
		A.DIVISION_ID,
		B.DIVISION_NAME,
		DEPRTMENT.DEPT_ID,
		TEAM.DEPT_ID, 
		PJT.DEPT_ID,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		C.SITE_DESCRIPTION,		
		isnull(C.END_CUSTOMER,''),
		A.PROJECT_CODE,
		PJT.PROJECT_NAME,
		PJT.BIZ_TYPE,
		PJT.PROJECT_STATUS,
		PJT.PROJECT_OWNER,
		A.ITEM_ID,
		ITEM.ITEM_CLASS_NAME, 
		isnull(ITEM.ITEM_NAME,''),
		A.INCOTERMS,
		A.FCST_TYPE,
		A.DOM_EXP,
		A.CURRENCY,		
		--MEASURE.LOOKUP_CODE,
		--MEASURE.DISPLAY_SEQ,
		--CASE WHEN RTRIM(TEAM.DEPT_ID) = RTRIM(@v_dept_id) THEN 'Y' ELSE 'N' END  --20200312 KHSONG @v_dept_id 값이 셋팅되는 곳이 없어서 필요없는 조건으로 주석처리 
		--A.YYYYMMDD,
		ITEM.NICK_NAME
	
	
CREATE INDEX IDX_PRICE_KEYS ON #tmpData(DIVISION_ID ASC, PROJECT_CODE ASC, SCM_SITE_ID ASC, PLANT_SITE_ID ASC, ITEM_ID ASC, CURRENCY ASC, DOM_EXP ASC, FCST_TYPE ASC, INCOTERMS ASC );


CREATE TABLE #tmpOutput (DIVISION_ID	NVARCHAR(30)
						,DIVISION_NAME	NVARCHAR(150)
						,UPPER_DEPT_ID  NVARCHAR(50)
						,DEPT_ID        NVARCHAR(50)
						,SCM_SITE_ID	NVARCHAR(30)
						,PLANT_SITE_ID	NVARCHAR(30)
						,SITE_DESCRIPTION	NVARCHAR(150)
						,END_CUSTOMER	NVARCHAR(150)
						,END_CUSTOMER40	NVARCHAR(150)
						,PROJECT_CODE	NVARCHAR(50)
						,PROJECT_NAME	NVARCHAR(200)
						,BIZ_TYPE_NAME	NVARCHAR(50)
						,PROJECT_STATUS	NVARCHAR(150)
						,ITEM_ID	NVARCHAR(50)
						,ITEM_CLASS_NAME	NVARCHAR(300)
						,ITEM_NAME	NVARCHAR(150)
						,INCOTERMS	NVARCHAR(10)
						,CURRENCY	NVARCHAR(10)
						,FCST_TYPE	NVARCHAR(20)
						,DOM_EXP	NVARCHAR(3)
						,MEASURE	NVARCHAR(50)
						,DISPLAY_SEQ INT
						,AUTHORITY_YN VARCHAR(50)
						,YYYYMMDD	NVARCHAR(10)
						,PRICE	    NUMERIC(20,10) 
						,NICK_NAME VARCHAR(50) 
						,COL_LIST  NVARCHAR(3000) 
						);
						
	-- 1. 실데이타와 조인
	
    -- [PJ20200138] 범위 초과 대상
	IF (@p_over_range = 'Y')
		BEGIN 
		    INSERT #tmpOutput
			SELECT 
					A.DIVISION_ID,
					A.DIVISION_NAME,
					A.UPPER_DEPT_ID,
					A.DEPT_ID	,
					A.SCM_SITE_ID,
					A.PLANT_SITE_ID,
					A.SITE_DESCRIPTION,
					A.END_CUSTOMER,
					A.PROJECT_CODE AS END_CUSTOMER40,
					A.PROJECT_CODE,
					A.PROJECT_NAME,
					A.BIZ_TYPE_NAME,
					A.PROJECT_STATUS,
					A.ITEM_ID,
					A.ITEM_CLASS_NAME,
					A.ITEM_NAME,
					A.INCOTERMS,
					A.CURRENCY,
					A.FCST_TYPE,
					A.DOM_EXP,
					B.MEASURE,
					MEASURE.DISPLAY_SEQ,
					A.AUTHORITY_YN,
					'W_' + B.YYYYMMDD AS YYYYMMDD,
					ISNULL(B.PRICE,0) AS PRICE
					, A.NICK_NAME
					, C.COL_LIST
			FROM #tmpData A
				JOIN SCM_MST_FUTURE_PRICE B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID 
					   AND A.PROJECT_CODE = B.PROJECT_CODE
					   AND A.SCM_SITE_ID = B.SCM_SITE_ID 
					   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID 
					   AND A.ITEM_ID = B.ITEM_ID 
					   AND A.CURRENCY = B.CURRENCY
					   --AND A.MEASURE = B.MEASURE
					   AND A.DOM_EXP = B.DOM_EXP
					   AND A.FCST_TYPE = B.FCST_TYPE
					   AND A.INCOTERMS = B.INCOTERMS
					   --AND A.YYYYMMDD = B.YYYYMMDD
				JOIN   #tmpOverRangeList C WITH(NOLOCK)
					ON A.DIVISION_ID = C.DIVISION_ID 
					   AND A.PROJECT_CODE = C.PROJECT_CODE
					   AND A.SCM_SITE_ID = C.SCM_SITE_ID 
					   AND A.PLANT_SITE_ID = C.PLANT_SITE_ID 
					   AND A.ITEM_ID = C.ITEM_ID 
					   AND A.CURRENCY = C.CURRENCY
					   --AND A.MEASURE = C.MEASURE
					   AND A.DOM_EXP = C.DOM_EXP
					   AND A.FCST_TYPE = C.FCST_TYPE
					   AND A.INCOTERMS = C.INCOTERMS
					   --AND A.YYYYMMDD = C.YYYYMMDD
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
				INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b2
					ON      CASE WHEN @p_item_id = '' THEN @p_item_id			
							ELSE A.ITEM_ID  END like  b2.tst 
					OR      CASE WHEN @p_item_id = '' THEN @p_item_id			
							ELSE A.NICK_NAME  END like  b2.tst 
				-----------------------------------------------------------------------------------------------	
				JOIN (  SELECT  COLUMN_NAME AS LOOKUP_CODE, 
								COLUMN_LABEL_NAME AS [DESCRIPTION], 
								SORT_ORDER_NO AS DISPLAY_SEQ
						FROM    SCM_MST_SHEET_MEASURE WITH(NOLOCK)
						WHERE  (PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price') ) AS MEASURE
					ON B.MEASURE = MEASURE.LOOKUP_CODE		
			WHERE B.YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd --[PJ20200138] 속도개선	
		END 
	ELSE
		BEGIN 
		    INSERT #tmpOutput
			SELECT 
					A.DIVISION_ID,
					A.DIVISION_NAME,
					A.UPPER_DEPT_ID,
					A.DEPT_ID	,
					A.SCM_SITE_ID,
					A.PLANT_SITE_ID,
					A.SITE_DESCRIPTION,
					A.END_CUSTOMER,
					A.PROJECT_CODE AS END_CUSTOMER40,
					A.PROJECT_CODE,
					A.PROJECT_NAME,
					A.BIZ_TYPE_NAME,
					A.PROJECT_STATUS,
					A.ITEM_ID,
					A.ITEM_CLASS_NAME,
					A.ITEM_NAME,
					A.INCOTERMS,
					A.CURRENCY,
					A.FCST_TYPE,
					A.DOM_EXP,
					B.MEASURE,
					MEASURE.DISPLAY_SEQ,
					A.AUTHORITY_YN,
					'W_' + B.YYYYMMDD AS YYYYMMDD,
					ISNULL(B.PRICE,0) AS PRICE
					, A.NICK_NAME
					, '' AS COL_LIST
			FROM #tmpData A
				JOIN SCM_MST_FUTURE_PRICE B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID 
					   AND A.PROJECT_CODE = B.PROJECT_CODE
					   AND A.SCM_SITE_ID = B.SCM_SITE_ID 
					   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID 
					   AND A.ITEM_ID = B.ITEM_ID 
					   AND A.CURRENCY = B.CURRENCY
					   --AND A.MEASURE = B.MEASURE
					   AND A.DOM_EXP = B.DOM_EXP
					   AND A.FCST_TYPE = B.FCST_TYPE
					   AND A.INCOTERMS = B.INCOTERMS
					   --AND A.YYYYMMDD = B.YYYYMMDD
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
				INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b2
					ON      CASE WHEN @p_item_id = '' THEN @p_item_id			
							ELSE A.ITEM_ID  END like  b2.tst 
					OR      CASE WHEN @p_item_id = '' THEN @p_item_id			
							ELSE A.NICK_NAME  END like  b2.tst 
				-----------------------------------------------------------------------------------------------	
				JOIN (  SELECT  COLUMN_NAME AS LOOKUP_CODE, 
								COLUMN_LABEL_NAME AS [DESCRIPTION], 
								SORT_ORDER_NO AS DISPLAY_SEQ
						FROM    SCM_MST_SHEET_MEASURE WITH(NOLOCK)
						WHERE  (PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price') ) AS MEASURE
					ON B.MEASURE = MEASURE.LOOKUP_CODE
			WHERE B.YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd --[PJ20200138] 속도개선
		END 
		;

	-----------------------------------------------------------------------------------------------

------ 월 데이터 평균 값 산정
----INSERT #tmpOutput
----SELECT 
----		A.DIVISION_ID,
----		A.DIVISION_NAME,
----		A.UPPER_DEPT_ID,
----		A.DEPT_ID	,
----		A.SCM_SITE_ID,
----		A.PLANT_SITE_ID,
----		A.SITE_DESCRIPTION,
----		A.END_CUSTOMER,
----		A.PROJECT_CODE AS END_CUSTOMER40,
----		A.PROJECT_CODE,
----		A.PROJECT_NAME,
----		A.BIZ_TYPE_NAME,
----		A.PROJECT_STATUS,
----		A.ITEM_ID,
----		A.ITEM_CLASS_NAME,
----		A.ITEM_NAME,
----		A.INCOTERMS,
----		A.CURRENCY,
----		A.FCST_TYPE,
----		A.DOM_EXP,
----		A.MEASURE,
----		A.DISPLAY_SEQ,
----		A.AUTHORITY_YN,
----		'M_' + SUBSTRING(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6) + '01' AS YYYYMMDD,
----		--MIN(ISNULL(PRICE, 0)) AS PRICE
----		SUM(ISNULL(PRICE, 0)) / COUNT(YYYYMMDD) AS PRICE
----		, A.NICK_NAME
----		, A.COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
----FROM #tmpOutput  AS A
----group by A.DIVISION_ID,
----		A.DIVISION_ID,
----		A.DIVISION_NAME,
----		A.UPPER_DEPT_ID,
----		A.DEPT_ID	,
----		A.SCM_SITE_ID,
----		A.PLANT_SITE_ID,
----		A.SITE_DESCRIPTION,
----		A.END_CUSTOMER,
----		A.END_CUSTOMER40,
----		A.PROJECT_CODE,
----		A.PROJECT_NAME,
----		A.BIZ_TYPE_NAME,
----		A.PROJECT_STATUS,
----		A.ITEM_ID,
----		A.ITEM_CLASS_NAME,
----		A.ITEM_NAME,
----		A.INCOTERMS,
----		A.CURRENCY,
----		A.FCST_TYPE,
----		A.DOM_EXP,
----		A.MEASURE,
----		A.DISPLAY_SEQ,
----		A.AUTHORITY_YN,
----		A.NICK_NAME,
----		A.COL_LIST, --[PJ20200138] 범위를 초과하는 YYYYMMDD List
----		SUBSTRING(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6)

/* tmpPlanData 에 대한 처리들  */
		SELECT @Prod = @Prod + '[' + A.YYYYMMDD + '],'
		FROM (SELECT DISTINCT YYYYMMDD FROM #tmpOutput) A

		IF @Prod = '' 
			BEGIN
				SET @Prod = 'D_99999999'
			END
		ELSE
			BEGIN
				Select @Prod = LEFT(@Prod, LEN(@Prod)-1)
			END


		--Start [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
		IF @p_division_id = '82' and @p_invalid_exec = 'N'
			BEGIN
			
				SELECT	 SITE_PROJECT.DIVISION_ID,
								TEAM.DEPT_ID, 
								SITE.END_CUSTOMER,
								SITE.END_CUSTOMER AS END_CUSTOMER40,
								SITE_PROJECT.SCM_SITE_ID,
								SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40,
								SITE_PROJECT.PROJECT_CODE,
								PJT.PROJECT_NAME,
								PJT.PROJECT_STATUS,
								SITE_ITEM.SALES_PLAN_ADJUST_YN,
								SITE_ITEM.ITEM_CLASS_NAME,
								SITE_ITEM.ITEM_ID,
								SITE_ITEM.ITEM_NAME,
								SITE_ITEM.NICK_NAME,
								SITE_ITEM.CURRENCY
								
				into #tmpSalesSiteModelAll  
				FROM		   (SELECT	DISTINCT
										A.DIVISION_ID,
										SCM_SITE_ID,
										PROJECT_CODE,
										ISNULL(MAX(VALID_YN),'Y') AS VALID_YN
								FROM	SCM_MST_SITE_ITEM A WITH(NOLOCK)
										,SCM_MST_ITEM_SN B WITH(NOLOCK)
								WHERE   A.ITEM_ID = B.ITEM_ID 
								GROUP BY A.DIVISION_ID,
											SCM_SITE_ID,
											PROJECT_CODE	
															)					AS SITE_PROJECT
				LEFT JOIN		SCM_MST_PROJECT									AS PJT  WITH(NOLOCK)
				ON				SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
				AND				SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID
				LEFT JOIN		SCM_MST_SITE									AS SITE  WITH(NOLOCK)
				ON				SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID  
				AND				SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
				LEFT JOIN		SCM_MST_SSO_DEPT_INFO							AS TEAM		  WITH(NOLOCK)	       
				ON				SITE.DEPT_ID = TEAM.DEPT_ID

				LEFT JOIN		(SELECT T1.DIVISION_ID,
										T1.SCM_SITE_ID,
										T1.PROJECT_CODE,
										T1.ITEM_ID,
										T2.ITEM_NAME,
										T2.ITEM_TYPE,
										T2.ITEM_CLASS_NAME,
										T1.SALES_PLAN_ADJUST_YN,
										T2.NICK_NAME,
										T1.CURRENCY,
										T1.VALID_YN,
										T1.OWNER,
										T1.PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
										-----------------------			
									FROM	SCM_MST_SITE_ITEM		T1  WITH(NOLOCK)
									JOIN 	DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
									ON	T1.DIVISION_ID = T2.DIVISION_ID
									AND	T1.ITEM_ID   = T2.ITEM_ID

									WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'H' END 
									OR	 T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'P' END)
															)					AS SITE_ITEM							
							
				ON				SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID
				AND				SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
				AND				SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE

				LEFT JOIN		SCM_MST_SITE_CUSTOMER							AS SITE_CUST  WITH(NOLOCK)
				ON				SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
				AND				SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
				AND				SITE_CUST.REP_YN      = 'Y'

				LEFT JOIN		SCM_MST_CUSTOMER								AS CUST  WITH(NOLOCK)
				ON				SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
				AND				SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
				AND				SITE_CUST.DIVISION_ID = CUST.DIVISION_ID
   
				LEFT JOIN		(SELECT DIVISION_ID,
											MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL,
											SCM_SITE_ID,
											PROJECT_CODE,
											ITEM_ID
									FROM   DM_MST_CUSTOMER_MODEL  WITH(NOLOCK)
									WHERE  VALID_YN = 'Y'
									GROUP BY DIVISION_ID, 
											SCM_SITE_ID,
											PROJECT_CODE,
											ITEM_ID			)					AS CUST_ITEM
				ON				SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
				AND				SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
				AND				SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
				AND				SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID
	
				LEFT JOIN SCM_MST_SSO_USER_INFO SU	 WITH(NOLOCK) 	
				ON SITE_ITEM.owner = SU.USER_ID 
			
					INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
					ON      CASE WHEN @p_item_id = '' THEN @p_item_id			
							ELSE SITE_ITEM.ITEM_ID  END like  b.tst 
					OR      CASE WHEN @p_item_id = '' THEN @p_item_id			
							ELSE SITE_ITEM.NICK_NAME  END like  b.tst 
					INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) b1
					ON      CASE WHEN @p_project_code = '' THEN @p_project_code			
							ELSE PJT.PROJECT_CODE  END like  b1.tst 
					OR      CASE WHEN @p_project_code = '' THEN @p_project_code			
							ELSE PJT.PROJECT_NAME  END like  b1.tst 	
				INNER JOIN (
								SELECT DISTINCT X.OWNER
									FROM SCM_MST_SITE_ITEM AS X  WITH(NOLOCK) 
									LEFT JOIN SCM_MST_SSO_USER_INFO AS UI  WITH(NOLOCK) 
									ON X.PROJECT_CODE = UI.USER_ID
									INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_owner,',') ) c
										ON    (
												CASE WHEN @p_owner = '' THEN @p_owner			
												ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](x.OWNER, ',', '1') END like  c.tst 
												OR
												CASE WHEN @p_owner = '' THEN @p_owner			
												ELSE X.OWNER END like  c.tst 
												OR
												CASE WHEN @p_owner = '' THEN @p_owner			
												ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](X.OWNER, ',', '2') END like  c.tst 
												)
								where X.DIVISION_ID = @p_division_id
									AND @p_owner <> ''
									UNION all
									select '11'
									where @p_owner = ''
						) X
				ON  ISNULL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN @p_owner = '' THEN  ISNULL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END	
				WHERE  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
				AND    CASE WHEN @p_division_id = 'ALL' THEN @p_division_id			
							ELSE SITE_PROJECT.DIVISION_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_division_id,',') )
				AND    CASE WHEN @p_dept_id = 'ALL' THEN @p_dept_id			
							ELSE TEAM.DEPT_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_dept_id,',') )
				AND    CASE WHEN @p_end_customer = 'ALL' THEN @p_end_customer			
							ELSE SITE.END_CUSTOMER
 						END  IN ( SELECT token FROM dbo.String_Split(@p_end_customer,',') )
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE SITE_PROJECT.SCM_SITE_ID  -- 20181220 KHSONG modify SITE_ITEM.SCM_SITE_ID -> SITE_PROJECT.SCM_SITE_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND   SITE.SITE_TYPE <> 'PLANT'


				select DIVISION_ID,DEPT_ID, END_CUSTOMER, END_CUSTOMER40, SCM_SITE_ID, SCM_SITE_ID40, PROJECT_CODE, PROJECT_NAME
				, PROJECT_STATUS,SALES_PLAN_ADJUST_YN, ITEM_CLASS_NAME, ITEM_ID, ITEM_NAME, NICK_NAME, CURRENCY, B.MEASURE, B.DISPLAY_SEQ
				into #tmpSalesSiteModel
				from   #tmpSalesSiteModelAll a
				cross join (SELECT  COLUMN_NAME AS MEASURE, 
									COLUMN_LABEL_NAME AS DESCRIPTION, 
									SORT_ORDER_NO AS DISPLAY_SEQ
							FROM    SCM_MST_SHEET_MEASURE WITH(NOLOCK)
							WHERE   PROGRAM_ID = 'DMF0020'	
							AND     SHEET_NAME = 'Sales Price' )  b


				
			SELECT  @nsql = '
			SELECT  
					DIVISION_ID,
					DIVISION_NAME,
					UPPER_DEPT_ID,
					DEPT_ID	,
					SCM_SITE_ID,
					PLANT_SITE_ID,
					SITE_DESCRIPTION,
					END_CUSTOMER,
					END_CUSTOMER40,
					PROJECT_CODE,
					PROJECT_NAME,
					BIZ_TYPE_NAME,
					PROJECT_STATUS,
					ITEM_ID,
					ITEM_CLASS_NAME,
					ITEM_NAME,
					INCOTERMS,
					CURRENCY,
					FCST_TYPE,
					DOM_EXP,
					AUTHORITY_YN,		
					DISPLAY_SEQ,
					NICK_NAME,
					COL_LIST, --[PJ20200138] 범위를 초과하는 YYYYMMDD List
					NEW_FLAG,
					MEASURE,				
					' + @Prod + '
			From(
				SELECT a.DIVISION_ID,
					b.DIVISION_NAME,
					b.UPPER_DEPT_ID,
					a.DEPT_ID	,
					a.SCM_SITE_ID,
					b.PLANT_SITE_ID,
					b.SITE_DESCRIPTION,
					a.END_CUSTOMER,
					b.END_CUSTOMER40,
					a.PROJECT_CODE,
					a.PROJECT_NAME,
					b.BIZ_TYPE_NAME,
					a.PROJECT_STATUS,
					a.ITEM_ID,
					a.ITEM_CLASS_NAME,
					a.ITEM_NAME,
					b.INCOTERMS,
					(CASE WHEN division_name is null THEN a.CURRENCY
						  ELSE b.CURRENCY
					 END) AS CURRENCY, --[C20200702-000136] ESS사업부 조회 구간 Currency 변경
					b.FCST_TYPE,
					b.DOM_EXP,
					(CASE WHEN division_name is null 
					           THEN (CASE WHEN (([dbo].[FN_GET_DEPT_LIST]( '''+ @p_created_by + ''', a.DEPT_ID ) = ''Y'')  OR '''+ @v_group_id +''' =''ADMIN'') THEN ''Y''
							              ELSE ''N'' 
									 END )
						  ELSE b.AUTHORITY_YN
					 END) AS AUTHORITY_YN,
					a.DISPLAY_SEQ,
					a.NICK_NAME,
					b.COL_LIST,
					(CASE WHEN division_name is null THEN ''Y'' ELSE ''N'' END) AS NEW_FLAG,
					a.MEASURE,
					b.PRICE,
					b.YYYYMMDD
				FROM #tmpSalesSiteModel A
					LEFT JOIN #tmpOutput B ON(		a.division_id =  b.division_id
												and a.dept_id = b.dept_id
												and a.scm_site_id = b.scm_site_id
												and a.item_id = b.item_id
												and a.project_code = b.project_code
												and a.measure = b.measure	
											)
				WHERE A.MEASURE = ''LOC''
				) T
			PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' + @prod + ')
			) AS PVT
			ORDER BY 		

					DIVISION_ID,
					division_name,
					DEPT_ID,
					END_CUSTOMER,
					SCM_SITE_ID,
					PROJECT_CODE,
					PROJECT_STATUS,
					BIZ_TYPE_NAME,
					ITEM_ID,
					ITEM_CLASS_NAME,
					ITEM_NAME,
					INCOTERMS,
					FCST_TYPE,
					DOM_EXP,
					CURRENCY,
					PLANT_SITE_ID,
					DISPLAY_SEQ, 
					MEASURE,
					COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
			' 
		END
		--End [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
	ELSE
		BEGIN

			SELECT  @nsql = '
			SELECT  
					DIVISION_ID,
					DIVISION_NAME,
					UPPER_DEPT_ID,
					DEPT_ID	,
					SCM_SITE_ID,
					PLANT_SITE_ID,
					SITE_DESCRIPTION,
					END_CUSTOMER,
					END_CUSTOMER40,
					PROJECT_CODE,
					PROJECT_NAME,
					BIZ_TYPE_NAME,
					PROJECT_STATUS,
					ITEM_ID,
					ITEM_CLASS_NAME,
					ITEM_NAME,
					INCOTERMS,
					CURRENCY,
					FCST_TYPE,
					DOM_EXP,
					AUTHORITY_YN,		
					DISPLAY_SEQ,
					NICK_NAME,
					COL_LIST, --[PJ20200138] 범위를 초과하는 YYYYMMDD List
					''N'' AS NEW_FLAG,
					MEASURE,				
					' + @Prod + '
			From(
				SELECT 
					*
				FROM #tmpOutput
				WHERE MEASURE = ''LOC''
				) T
			PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' + @prod + ')
			) AS PVT
			ORDER BY 		

					DIVISION_ID,
					DEPT_ID,
					END_CUSTOMER,
					SCM_SITE_ID,
					PROJECT_CODE,
					PROJECT_STATUS,
					BIZ_TYPE_NAME,
					ITEM_ID,
					ITEM_CLASS_NAME,
					ITEM_NAME,
					INCOTERMS,
					FCST_TYPE,
					DOM_EXP,
					CURRENCY,
					PLANT_SITE_ID,
					DISPLAY_SEQ, 
					MEASURE,
					COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
			' 
		
		END

--PRINT @NSQL 
execute dbo. SP_executesql @NSQL 


--SELECT CONVERT(TEXT, @NSQL)
--FOR XML PATH('')--,ROOT('x')  

		

END

