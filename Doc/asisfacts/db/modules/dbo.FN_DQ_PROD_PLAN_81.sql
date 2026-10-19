

/*
 * Program ID   : FN_DQ_PROD_PLAN_81                                                              
 * Description  : DQ 용 Prod Plan-81
 * 실행 예제    : SELECT * FROM dbo.FN_DQ_PROD_PLAN_81('20231002', '40', 'A', 'PR',  'PROD_PLAN_AMEND', 'G481', 'E78','1') 
 *                계획 주차 이전 3주 실적 + 계획
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2023.11.27	KHJ			[PJ20230692] LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 자동차 사업부 DQ(81) 용 Prod Plan 정보
 */
 
CREATE FUNCTION [dbo].[FN_DQ_PROD_PLAN_81]
(	
      @p_plan_start_yyyymmdd NVARCHAR(8)
    , @p_division_id         NVARCHAR(1000)
	, @p_operation_group     NVARCHAR(30) = 'A' -- 아래에서 'A" 고정 처리함
    , @p_plan_type           NVARCHAR(30) = 'FN'
    , @p_measure             NVARCHAR(30) = 'PROD_PLAN_AMEND'
    , @p_plant_id            NVARCHAR(1000)
    , @p_cell_nickname		 NVARCHAR(1000)
    , @p_comparison_week     NVARCHAR(3)
)
RETURNS @PROD_PLAN TABLE
(
	 DIVISION_ID	  NVARCHAR(30)
    ,PLAN_START_YYYYMMDD	NVARCHAR(8)
    ,OPERATION_GROUP  NVARCHAR(10)
    ,SCM_SITE_ID      NVARCHAR(30)
    ,PLANT_NAME       NVARCHAR(30)
    ,LINE_ID          NVARCHAR(30)
    ,ITEM_ID_PROD     NVARCHAR(30)
    ,ITEM_ID          NVARCHAR(30)
    --,NICK_NAME        NVARCHAR(100)
    ,CELL_MODEL       NVARCHAR(100)
    ,MEASURE          NVARCHAR(100)
    ,YYYYPW           NVARCHAR(30)
	,QTY              NUMERIC(30,3) -- KCell 단위로 소스점 3자리까지 표시 요청
)AS

BEGIN

    DECLARE @v_plan_type NVARCHAR(30);
    DECLARE @v_measure NVARCHAR(30);
    DECLARE @v_operation_group NVARCHAR(30);
	DECLARE @v_last_plan_start_yyyymmdd NVARCHAR(8)

	SET @v_plan_type       = @p_plan_type;
	SET @v_measure         = @p_measure;
	SET @v_operation_group = 'A';-- @p_operation_group; -- 'A' 고정
 
   /*********************************************************
    -- @p_plan_start_yyyymmdd : 계획시작일자
    -- @@v_re_start_yyyymmdd : 실적 시작일자 - @p_plan_start_yyyymmdd 기준 이전 3주치
    -- @@@v_re_end_yyyymmdd  : 실적 종료일자 
    **********************************************************/
--	DECLARE @v_re_start_yyyymmdd  nvarchar(8) = CONVERT(CHAR(8), DATEADD(D, -7*3, CONVERT(DATETIME, @p_plan_start_yyyymmdd)), 112); 
	DECLARE @v_re_start_yyyymmdd  nvarchar(8) = CONVERT(CHAR(8), DATEADD(D,  0  , CONVERT(DATETIME, substring(@p_plan_start_yyyymmdd, 1, 4) + '0101')), 112); 
	DECLARE @v_re_end_yyyymmdd    nvarchar(8) = CONVERT(CHAR(8), DATEADD(D, -1  , CONVERT(DATETIME, @p_plan_start_yyyymmdd)), 112); 

	--  비교할 것이 없으면 @p_last_plan_start_yyyymmdd에 현재 버젼을 넣고, 비교할 것이 있으면 지난주 버젼을 넣어서 비교함.
	IF @p_comparison_week = 1			
	BEGIN
		set @v_last_plan_start_yyyymmdd = @p_plan_start_yyyymmdd
	END
	IF @p_comparison_week = 2 
	BEGIN
		set @v_last_plan_start_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-7,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
	END

	
    DECLARE @ITEM_ID_PROD_INFO TABLE
    (
          DIVISION_ID					NVARCHAR(30)	NULL
        , item_id_assy					NVARCHAR(50)	NULL
        , item_id_prod					NVARCHAR(50)	NULL
        , cp_priority					INT
    );
	
	INSERT INTO @ITEM_ID_PROD_INFO
	SELECT *
	FROM ( 
		  SELECT  m.division_id
				, m.item_id_assy
				, m.item_id_prod
				, row_number() over (partition  by m.division_id
												,m.item_id_assy
									order by f.tco_cell_yn 
											,m.item_id_prod) as cp_priority
			FROM SCP_MST_CELL_PROD_ASSY_MAP m WITH(NOLOCK) 
					INNER JOIN scp_mst_final_item_v f WITH(NOLOCK) 
							ON f.item_id = m.item_id_prod
			WHERE  1=1
			AND    m.division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
			AND    m.valid_yn     = 'Y'
			) a
	WHERE 1=1
	AND   cp_priority = 1 



   /*********************************************************
    -- 1.0 : 계획
    **********************************************************/

	IF @p_plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
	BEGIN
		-----------------------------------------------
		-- 당주 정보 
		-----------------------------------------------
		INSERT INTO @PROD_PLAN
		SELECT a.division_id, a.plan_start_yyyymmdd, a.operation_group, s.plant_id		 
				, CASE WHEN s.osp_yn = 'Y' THEN CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE v.ATTRIBUTE1 END
					WHEN s.osp_yn = 'N' THEN CASE WHEN SN.DESCRIPTION IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE SN.DESCRIPTION END
				END AS plant_name
				, a.line_id
				, im.item_id_prod, a.item_id
				--, item.nick_name as NICK_NAME
				, case when fi.operation_group = 'a' then fi.group_code1
					when fi.operation_group = 'p' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
					else ''
				end as cell_model
				, a.measure
				--, buc.yyyypw
			, SUBSTRING(buc.yyyypw, 3,2) + '_W' + SUBSTRING(buc.yyyypw, 5,2) 
			+ CASE WHEN ISNULL(SUBSTRING(buc.yyyypw, 7,1), '') = '' THEN ''
					ELSE '_' + SUBSTRING(buc.yyyypw, 7,1) 
				END AS yyyypw
				, SUM(a.qty) / 1000.0 AS qty  -- K Cell 단위
		FROM scp_anl_production_plan a WITH(NOLOCK)

		INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY division_id, plan_start_yyyymmdd, plan_type ORDER BY CASE WHEN confirm_flag = 'Y' THEN 1 ELSE 9 END, plan_seq DESC ) row_num 
							, *
					FROM   SCP_PLAN_VERSION_V b WITH(NOLOCK)
					WHERE  division_id         IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
					AND    plan_start_yyyymmdd  in ( @p_plan_start_yyyymmdd, @v_last_plan_start_yyyymmdd)

					AND    plan_type            = @v_plan_type
					) b 
		ON  a.division_id          = b.division_id
		AND a.plan_start_yyyymmdd  = b.plan_start_yyyymmdd
		AND a.plan_type            = b.plan_type
		AND a.seq                  = b.plan_seq
		AND b.row_num              = 1
		AND a.operation_group      = @v_operation_group

		INNER JOIN (SELECT division_id, plan_name, MAX(horizon_end_date) AS to_yyyymmdd
					FROM   SCM_MST_PLAN WITH(NOLOCK)
					WHERE  division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
					AND    plan_name  in ( @p_plan_start_yyyymmdd, @v_last_plan_start_yyyymmdd)
					GROUP BY division_id, plan_name
					) pl
		ON  a.division_id         = pl.division_id
		AND a.plan_start_yyyymmdd = pl.plan_name
		AND a.yyyymmdd           <= pl.to_yyyymmdd -- Plan 구간 내 정보

		INNER JOIN SCM_MST_BUCKET buc WITH(NOLOCK)
		ON a.yyyymmdd             = buc.yyyymmdd
	
		INNER JOIN SCM_MST_SITE     S WITH(NOLOCK) 
		ON  S.DIVISION_ID = a.DIVISION_ID 
		AND S.scm_site_id = a.scm_site_id
		AND S.PLANT_ID IN (SELECT token FROM [dbo].[String_Split](@p_plant_id, ','))

		LEFT OUTER JOIN SCM_MST_PLANT_SN P WITH(NOLOCK) ON S.COMPANY_ID = P.COMPANY_ID AND S.DIVISION_ID = P.DIVISION_ID AND S.PLANT_ID = P.PLANT_ID
		LEFT OUTER JOIN SCM_MST_VENDOR   V WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID AND S.COMPANY_ID = V.COMPANY_ID
		LEFT OUTER JOIN SCM_MST_PLANT_SN SN WITH(NOLOCK) ON S.DIVISION_ID = SN.DIVISION_ID AND S.PLANT_ID =SN.PLANT_ID

		--INNER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
		--						FROM SCM_MST_ITEM_SN WITH(NOLOCK) 
		--						WHERE 1=1
		--						AND   NICK_NAME IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))
		--						AND   ACTIVE_FLAG = 'Y'
		--						GROUP BY DIVISION_ID, ITEM_ID
		--				) item
		--ON  a.division_id = item.division_id
		--AND a.item_id     = item.item_id

		LEFT OUTER JOIN @ITEM_ID_PROD_INFO im 
		ON  a.division_id = im.division_id
		AND a.item_id     = im.item_id_assy

		INNER JOIN scp_mst_final_item fi WITH(NOLOCK)
		ON  a.division_id = fi.division_id
		AND a.item_id     = fi.item_id

		WHERE  1=1
		AND    a.measure              = @v_measure --'PROD_PLAN_AMEND'
		AND    a.qty                 <> 0
		AND    case when fi.operation_group = 'a' then fi.group_code1
					when fi.operation_group = 'p' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
					else '' 
				END 
				IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))

		GROUP BY a.division_id, a.plan_start_yyyymmdd, a.operation_group, s.plant_id-- a.scm_site_id
				, CASE WHEN s.osp_yn = 'Y' THEN CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE v.ATTRIBUTE1 END
					WHEN s.osp_yn = 'N' THEN CASE WHEN SN.DESCRIPTION IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE SN.DESCRIPTION END
					END
				, a.line_id
				, im.item_id_prod, a.item_id--, item.NICK_NAME
				, a.measure, buc.yyyypw
				, fi.operation_group, fi.group_code1, fi.division_id, fi.attribute1
		ORDER BY SUBSTRING(buc.yyyypw, 3,2) + '_W' + SUBSTRING(buc.yyyypw, 5,2) 
						+ CASE WHEN ISNULL(SUBSTRING(buc.yyyypw, 7,1), '') = '' THEN ''
							ELSE '_' + SUBSTRING(buc.yyyypw, 7,1) 
							END 
				, im.item_id_prod, a.item_id, s.plant_id, a.line_id 

	END
	ELSE
	BEGIN
		-----------------------------------------------
		-- 이전 주차 정보
		-----------------------------------------------
		INSERT INTO @PROD_PLAN
		SELECT a.division_id, a.plan_start_yyyymmdd, a.operation_group, s.plant_id
				, CASE WHEN s.osp_yn = 'Y' THEN CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE v.ATTRIBUTE1 END
					WHEN s.osp_yn = 'N' THEN CASE WHEN SN.DESCRIPTION IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE SN.DESCRIPTION END
				END AS plant_name
				, a.line_id
				, im.item_id_prod, a.item_id
--				, item.NICK_NAME
				, case when fi.operation_group = 'a' then fi.group_code1
					when fi.operation_group = 'p' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
					else ''
				end as cell_model
				, a.measure
				--, buc.yyyypw
			, SUBSTRING(buc.yyyypw, 3,2) + '_W' + SUBSTRING(buc.yyyypw, 5,2) 
			+ CASE WHEN ISNULL(SUBSTRING(buc.yyyypw, 7,1), '') = '' THEN ''
					ELSE '_' + SUBSTRING(buc.yyyypw, 7,1) 
				END AS yyyypw
				, SUM(a.qty) / 1000.0 AS qty  -- K Cell 단위
		FROM hist_scp_anl_production_plan a WITH(NOLOCK)

			INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY division_id, plan_start_yyyymmdd, plan_type ORDER BY CASE WHEN confirm_flag = 'Y' THEN 1 ELSE 9 END, plan_seq DESC ) row_num 
								, *
						FROM   SCP_PLAN_VERSION_V b WITH(NOLOCK)
						WHERE  division_id         IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
--						AND    plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
						AND    plan_start_yyyymmdd  in (@p_plan_start_yyyymmdd, @v_last_plan_start_yyyymmdd)
						AND    plan_type            = @v_plan_type
						) b 
			ON  a.division_id          = b.division_id
			AND a.plan_start_yyyymmdd  = b.plan_start_yyyymmdd
			AND a.plan_type            = b.plan_type
			AND a.seq                  = b.plan_seq
			AND b.row_num              = 1
			AND a.operation_group      = @v_operation_group

			INNER JOIN (SELECT division_id, plan_name, MAX(horizon_end_date) AS to_yyyymmdd
						FROM   SCM_MST_PLAN WITH(NOLOCK)
						WHERE  division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
						AND    plan_name    in (@p_plan_start_yyyymmdd, @v_last_plan_start_yyyymmdd)
						GROUP BY division_id, plan_name
						) pl
			ON  a.division_id         = pl.division_id
			AND a.plan_start_yyyymmdd = pl.plan_name
			AND a.yyyymmdd           <= pl.to_yyyymmdd -- Plan 구간 내 정보

			INNER JOIN SCM_MST_BUCKET buc WITH(NOLOCK)
			ON a.yyyymmdd             = buc.yyyymmdd
	
			INNER JOIN SCM_MST_SITE     S WITH(NOLOCK) 
			ON  S.DIVISION_ID = a.DIVISION_ID 
			AND S.scm_site_id = a.scm_site_id
			AND S.PLANT_ID IN (SELECT token FROM [dbo].[String_Split](@p_plant_id, ','))

			LEFT OUTER JOIN SCM_MST_PLANT_SN P WITH(NOLOCK) ON S.COMPANY_ID = P.COMPANY_ID AND S.DIVISION_ID = P.DIVISION_ID AND S.PLANT_ID = P.PLANT_ID
			LEFT OUTER JOIN SCM_MST_VENDOR   V WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID AND S.COMPANY_ID = V.COMPANY_ID
			LEFT OUTER JOIN SCM_MST_PLANT_SN SN WITH(NOLOCK) ON S.DIVISION_ID = SN.DIVISION_ID AND S.PLANT_ID =SN.PLANT_ID

			--INNER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
			--						FROM SCM_MST_ITEM_SN WITH(NOLOCK) 
			--						WHERE 1=1
			--						AND NICK_NAME IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))
			--						AND   ACTIVE_FLAG = 'Y'
			--						GROUP BY DIVISION_ID, ITEM_ID
			--				) item
			--ON  a.division_id = item.division_id
			--AND a.item_id     = item.item_id

			LEFT OUTER JOIN SCP_MST_FINAL_ITEM fi WITH(NOLOCK)
			ON  a.division_id = fi.division_id
			AND a.item_id     = fi.item_id

			LEFT OUTER JOIN @ITEM_ID_PROD_INFO im 
			ON  a.division_id = im.division_id
			AND a.item_id     = im.item_id_assy

		WHERE  1=1
		AND    a.measure              = @v_measure --'PROD_PLAN_AMEND'
		AND    a.qty                 <> 0
		AND    case when fi.operation_group = 'a' then fi.group_code1
					when fi.operation_group = 'p' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
					else '' 
				END 
				IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))

		GROUP BY a.division_id, a.plan_start_yyyymmdd, a.operation_group, s.plant_id
				, CASE WHEN s.osp_yn = 'Y' THEN CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE v.ATTRIBUTE1 END
					WHEN s.osp_yn = 'N' THEN CASE WHEN SN.DESCRIPTION IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE SN.DESCRIPTION END
				END
				, a.line_id
				, im.item_id_prod, a.item_id--, item.NICK_NAME
				, a.measure, buc.yyyypw
				, fi.operation_group, fi.group_code1, fi.division_id, fi.attribute1
		ORDER BY buc.yyyypw, im.item_id_prod, a.item_id, s.plant_id, a.line_id 

	END --     IF @p_plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)

   /*********************************************************
    -- 2.0 : 실적
    **********************************************************/

	INSERT INTO @PROD_PLAN		
	SELECT    A.DIVISION_ID
			, @p_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
			, A.SCP_OPERATION_GROUP, A.PLANT_ID
			, ISNULL(B.DESCRIPTION, B.PLANT_NAME) PLANT_NAME
			, A.LINE_ID
			, ISNULL(im.item_id_prod, a.item_id) AS item_id_prod
			, a.item_id
--			, item.NICK_NAME
				, case when fi.operation_group = 'a' then fi.group_code1
					when fi.operation_group = 'p' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
					else ''
				end as cell_model
			, A.MEASURE
			--, buc.yyyypw
			, SUBSTRING(buc.yyyypw, 3,2) + '_W' + SUBSTRING(buc.yyyypw, 5,2) 
			+ CASE WHEN ISNULL(SUBSTRING(buc.yyyypw, 7,1), '') = '' THEN ''
					ELSE '_' + SUBSTRING(buc.yyyypw, 7,1) 
				END AS yyyypw
			, SUM(a.ACTUAL_GOOD_QTY) / 1000.0 AS qty  -- K Cell 단위
	FROM (
			SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
					, A.OPERATION_ID, A.SCP_OPERATION_GROUP, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
					, A.PLAN_DATE, A.ITEM_ID, A.PRODUCTION_TYPE , A.MEASURE
					, SUM(A.ACTUAL_GOOD_QTY) AS ACTUAL_GOOD_QTY
			FROM	(   -- 실적
						SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
								, A.LOCATION, A.OPERATION_ID, A.SCP_OPERATION_GROUP, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
								, CONVERT(CHAR(8), A.PLAN_DATE, 112) AS PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID
								, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET, 'RESULT' AS PLAN_TYPE
								, A.ACTUAL_GOOD_QTY AS ACTUAL_GOOD_QTY
								,'PLAN RESULT(OUT)' AS MEASURE
						FROM	SCM_DNM_PRODUCT_RESULT_V A WITH(NOLOCK)
						--FROM	SCM_DNM_DAILY_PRODUCT_RESULT_SN A WITH(NOLOCK)
						WHERE	1=1
						AND     A.division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
						AND     A.PLANT_ID IN (SELECT token FROM [dbo].[String_Split](@p_plant_id, ','))
						AND     A.PLAN_DATE BETWEEN CONVERT(datetime, @v_re_start_yyyymmdd) AND CONVERT(datetime, @v_re_end_yyyymmdd )
						
						AND		A.OPERATION_ID IN ('A3000', 'A9000') -- CELL 만  
						--AND     A.PRODUCTION_TYPE     NOT IN ('REWORK', 'PILOT') -- _SN 사용 시 조건 추가
						AND		A.ACTUAL_GOOD_QTY > 0
					) A
				WHERE 1=1
				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
							, A.OPERATION_ID, A.SCP_OPERATION_GROUP, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
							, A.PLAN_DATE, A.ITEM_ID, A.PRODUCTION_TYPE , A.MEASURE
		) A
		LEFT OUTER JOIN SCM_MST_PLANT_SN B WITH(NOLOCK)
		ON 1=1
		AND A.COMPANY_ID = B.COMPANY_ID
		AND A.DIVISION_ID = B.DIVISION_ID
		AND A.SITE_ID = B.SITE_ID
		AND A.PLANT_ID = B.PLANT_ID

		--INNER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
		--						FROM SCM_MST_ITEM_SN WITH(NOLOCK) 
		--						WHERE 1=1
		--						AND NICK_NAME IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))
		--						AND   ACTIVE_FLAG = 'Y'
		--						GROUP BY DIVISION_ID, ITEM_ID
		--				) item
		--ON  a.division_id = item.division_id
		--AND a.item_id     = item.item_id
	
		INNER JOIN SCM_MST_BUCKET buc WITH(NOLOCK)
		ON A.PLAN_DATE             = buc.yyyymmdd

		LEFT OUTER JOIN SCP_MST_FINAL_ITEM fi WITH(NOLOCK)
		ON  a.division_id = fi.division_id
		AND a.item_id     = fi.item_id

		LEFT OUTER JOIN @ITEM_ID_PROD_INFO im 
		ON  a.division_id = im.division_id
		AND a.item_id     = im.item_id_assy

	WHERE 1=1
	AND    a.ACTUAL_GOOD_QTY       <> 0
	AND    case when fi.operation_group = 'a' then fi.group_code1
				when fi.operation_group = 'p' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
				else '' 
				END 
				IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))
	GROUP BY A.DIVISION_ID, A.SCP_OPERATION_GROUP, A.PLANT_ID
		, ISNULL(B.DESCRIPTION, B.PLANT_NAME)
		, A.LINE_ID
		, im.item_id_prod, a.item_id--, item.NICK_NAME
		, A.MEASURE, buc.yyyypw
		, fi.operation_group, fi.group_code1, fi.division_id, fi.attribute1
	ORDER BY buc.yyyypw, im.item_id_prod, a.item_id


RETURN;

END
