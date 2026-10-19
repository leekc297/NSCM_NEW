

/*
 * Program ID   : FN_DQ_STOCK_81                                                              
 * Description  : DQ 용 Stock-81
 * 실행 예제    : SELECT * FROM dbo.FN_DQ_STOCK_81 ('20230731', '40', 'A010-A', 'E66C')
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2023.12.07	KHJ			[PJ20230692] LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : DQ (81) 용 STOCK 정보
 */
 
CREATE FUNCTION [dbo].[FN_DQ_STOCK_81]
(	
      @p_cutoff_date         NVARCHAR(8)
    , @p_division_id         NVARCHAR(1000)
	, @p_plant_site_id       NVARCHAR(1000)
	, @p_cell_nickname       NVARCHAR(1000)
)
RETURNS TABLE 
AS
RETURN 
(	
	-------------------------------------------------
	-- 1.0 재고
	-------------------------------------------------
	SELECT a.cutoff_date, a.division_id, a.scm_site_id
		 , s.operation_group
		 , ISNULL(
			CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN cf.target_cell
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN fi.cell_item_id
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.cell_item_id
				ELSE fi.cell_item_id
			END
			, fi.attribute1)		as cell_item_id
		 , a.item_id
		 , case when fi.operation_group = 'A' then fi.group_code1
				when fi.operation_group = 'P' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
				else '' 
			end				as cell_model 
		 , a.factory_id
		 , a.stock_type
		 , a.storage_id
		 , case when stock_type = 'INVENTORY' then 'ERP'
				when stock_type = 'OWMS' then 'OWMS'
				else a.operation_id
			end				as operation_id
		 , case when stock_type = 'INVENTORY' then 'ERP'
				when stock_type = 'OWMS' then 'OWMS'
				else o.operation_name
			end				as operation_name
		 , a.mes_map_sloc
		 , a.wiphold_yn
		 , case when a.stock_type = 'OWMS' and s.operation_group = 'P' and a.wip_type_code = 'INSP_PRE' then 'Pack BOH(Wait for inspection)'
				when a.stock_type = 'OWMS' and s.operation_group = 'P' and a.wip_type_code = 'INSP_HOLD' then 'Pack BOH(Hold)'
				when a.stock_type = 'OWMS' and s.operation_group = 'P' and a.wip_type_code = 'INSP_COM' then 'Pack BOH(Expected Inspection date)'
				when a.stock_type = 'OWMS' and s.operation_group = 'A' and a.wip_type_code = 'INSP_PRE' then 'Cell BOH'				-- 없음
				when a.stock_type = 'OWMS' and s.operation_group = 'A' and a.wip_type_code = 'INSP_HOLD' then 'Cell BOH(Hold)'
				when a.stock_type = 'OWMS' and s.operation_group = 'A' and a.wip_type_code = 'INSP_COM' then 'Cell BOH'
				when a.stock_type = 'OWMS' and s.operation_group = 'W' then 'Waranty BOH'

				when a.stock_type != 'OWMS' and s.operation_group = 'P' and a.wiphold_yn = 'Y' then 'Pack BOH(Hold)'
				when a.stock_type != 'OWMS' and s.operation_group = 'P' and a.wiphold_yn = 'N' then 'Pack BOH'
				when a.stock_type != 'OWMS' and s.operation_group = 'A' and a.wiphold_yn = 'Y' then 'Cell BOH(Hold)'
				when a.stock_type != 'OWMS' and s.operation_group = 'A' and a.wiphold_yn = 'N' then 'Cell BOH'

				else 'BOH'
		   end			AS measure
		 , case when DATEDIFF(DAY, a.cutoff_date, a.available_date) < 0 then DATEADD(DAY, 1, a.cutoff_date)
		   else a.available_date 
		   end				AS release_date
		 , a.scm_qty
		 , CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
				ELSE 1.0
		   END cell_conversion
		 ,(CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
				ELSE 1.0
		   END * a.scm_qty ) / 1000.0 AS kcell -- K Cell 단위
	FROM scm_dnm_stock a WITH(NOLOCK)
	
	LEFT OUTER JOIN SCM_MST_SITE     S WITH(NOLOCK) ON S.DIVISION_ID = a.DIVISION_ID AND S.scm_site_id = a.scm_site_id

	LEFT OUTER JOIN (SELECT DIVISION_ID, OPERATION_ID, MAX(OPERATION_NAME) AS OPERATION_NAME
						FROM   SCM_MST_OPERATION_SN  O WITH(NOLOCK) 
						WHERE  ACTIVE_FLAG = 'Y'
						GROUP BY DIVISION_ID, OPERATION_ID
					) O
	ON  O.DIVISION_ID  = a.DIVISION_ID 
	AND O.OPERATION_ID = a.OPERATION_ID
	
	LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, ISNULL(MAX(CELL_ITEM_ID), ITEM_ID) AS CELL_ITEM_ID, MAX(CONVERT_QTY_CELL) AS CONVERT_QTY_CELL, MAX(CELL_CF) AS CELL_CF
									, OPERATION_GROUP, GROUP_CODE1, ATTRIBUTE1
							FROM SCP_MST_FINAL_ITEM WITH(NOLOCK) 
							WHERE 1=1
							GROUP BY DIVISION_ID, ITEM_ID, OPERATION_GROUP, GROUP_CODE1, ATTRIBUTE1
					) fi
	ON  a.division_id = fi.division_id
	AND a.item_id     = fi.item_id
	
	LEFT OUTER JOIN (SELECT distinct ITEM_ID, MAX(TARGET_CELL) AS TARGET_CELL, MAX(CELL_CF) AS CELL_CF
							FROM scp_mst_item_cell_cf WITH(NOLOCK) 
							WHERE 1=1
							GROUP BY ITEM_ID
					) cf
	ON  a.item_id     = cf.item_id
	
	WHERE  1=1
	AND    a.division_id    IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ',')) -- = @p_division_id
	AND    a.cutoff_date    = @p_cutoff_date
	AND    a.scm_site_id    IN (SELECT token FROM [dbo].[String_Split](@p_plant_site_id, ',')) -- = @p_plant_site_id
	AND    case when (a.stock_type = 'OWMS' OR a.stock_type = 'VMI' OR a.stock_type = 'VMI_LT' )then a.scm_qty
				else a.qty
			END <> 0
	AND    case when fi.operation_group = 'A' then fi.group_code1
				when fi.operation_group = 'P' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
				else '' 
			END 
			IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))


	-------------------------------------------------
	-- 2.0 AGING 재고 (WIP은 AGING 재고 기준으로 처리함)
	-------------------------------------------------
	UNION ALL
	SELECT a.cutoff_date, a.division_id, a.scm_site_id
		 , a.operation_group
		 , ISNULL(
			CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN cf.target_cell
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN fi.cell_item_id
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.cell_item_id
				ELSE fi.cell_item_id
			END
			, fi.attribute1)		as cell_item_id
		 , a.item_id
		 , case when fi.operation_group = 'A' then fi.group_code1
				when fi.operation_group = 'P' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
				else '' 
			end				as cell_model 
		 , a.factory_id
		 , 'FORMATION'	as stock_type			-- FCS를 FORMATION으로 변경
		 , '-'			as storage_id
		 , a.operation_id
		 , foper.operation_name
		 , '-'			AS mes_map_sloc
		 , a.wiphold_yn 
		 , 'Form. Progress'		AS measure
		 , case when DATEDIFF(DAY, a.cutoff_date, a.available_date) < 0 then DATEADD(DAY, 1, a.cutoff_date)
		   else a.available_date 
		   end				AS release_date
		 , a.qty				-- input_qty 아님.
		 , CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
				ELSE 1.0
		   END cell_conversion
		 ,(CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
				ELSE 1.0
		   END * a.qty ) / 1000.0 AS kcell -- K Cell 단위
	FROM scm_dnm_stock_aging_v a WITH(NOLOCK)

		LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID
									   , MAX(CELL_ITEM_ID) AS CELL_ITEM_ID, MAX(CONVERT_QTY_CELL) AS CONVERT_QTY_CELL, MAX(CELL_CF) AS CELL_CF
									   , MAX(OPERATION_GROUP) AS OPERATION_GROUP
									   , GROUP_CODE1, ATTRIBUTE1
								FROM SCP_MST_FINAL_ITEM WITH(NOLOCK) 
								WHERE 1=1
								GROUP BY DIVISION_ID, ITEM_ID, GROUP_CODE1, ATTRIBUTE1
						) fi
		ON  a.division_id = fi.division_id
		AND a.item_id     = fi.item_id
	
		LEFT OUTER JOIN (SELECT distinct ITEM_ID, MAX(TARGET_CELL) AS TARGET_CELL, MAX(CELL_CF) AS CELL_CF
								FROM scp_mst_item_cell_cf WITH(NOLOCK) 
								WHERE 1=1
								GROUP BY ITEM_ID
						) cf
		ON  a.item_id     = cf.item_id
		
		LEFT OUTER JOIN (
							SELECT DISTINCT OPERATION_ID, OPERATION_NAME
							FROM [LGCE_FPDEV_TR].[DBO].[SCM_MMD_OPERATION_M] WITH(NOLOCK)
						) foper
		ON  a.operation_id = foper.operation_id
		
	WHERE  1=1
	AND    a.division_id    IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ',')) -- = @p_division_id
	AND    a.cutoff_date    = @p_cutoff_date
	AND    a.scm_site_id IN (SELECT token FROM [dbo].[String_Split](@p_plant_site_id, ',')) -- = @p_plant_site_id
	AND    a.qty   <> 0
	--and    a.wiphold_yn = 'N'
	AND    case when fi.operation_group = 'A' then fi.group_code1
			when fi.operation_group = 'P' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
			else '' 
		END 
		IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))

	-------------------------------------------------
	-- 3.1 해상재고 (PLANT로 이동)
	-------------------------------------------------
	UNION ALL
	SELECT a.result_date AS cutoff_date, a.division_id, a.to_scm_site_id AS scm_site_id
		 , fi.operation_group

		 /* 아래 4개 중 1개*/
		 --, fi.cell_item_id
		 --, fi.attribute1
		 --, cf.target_cell
		 --, psi.cell_item_id
		 , ISNULL(
			CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN cf.target_cell
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN fi.cell_item_id
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.cell_item_id
				ELSE fi.cell_item_id
			END
			, fi.attribute1)		as cell_item_id

		 , a.item_id
		 , case when fi.operation_group = 'A' then fi.group_code1
				when fi.operation_group = 'P' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
				else '' 
			end				as cell_model 
		 , '-' AS factory_id
		 , 'INTRANSIT' AS stock_type
		 , '-' AS storage_id
		 , 'INTRANSIT' AS operation_id
		 , 'INTRANSIT' AS operation_name
		 , '-'	AS mes_map_sloc
		 , 'N'  AS wiphold_yn
		 --, case when result_type = 'c' and then 'Semi Intransit'
			--	when result_type = 'i' then 'Intransit'
			--	else '-' 
		 --  end			AS measure
		 , case when s.site_type = 'PLANT' then 'Semi Intransit'
				when s.site_type = 'SALES' then 'Intransit'
				else '-' 
		   end			AS measure
		 , case when DATEDIFF(DAY, CONVERT (DATE, a.result_date), CONVERT (DATE, a.f_dest_eta_date)) < 0 then DATEADD (DAY, 1, a.result_date)
		   else CONVERT (DATE, a.f_dest_eta_date) 
		   end				AS release_date
		 , a.delivery_qty AS scm_qty
		 , CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
				ELSE 1.0
		   END cell_conversion
		 ,(CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
				ELSE 1.0
		   END * a.delivery_qty ) / 1000.0 AS kcell -- K Cell 단위
	FROM scm_dnm_intransit_c a WITH(NOLOCK)
	
		LEFT OUTER JOIN SCM_MST_SITE     S WITH(NOLOCK) ON S.DIVISION_ID = a.DIVISION_ID AND S.scm_site_id = a.to_scm_site_id

		LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID
									   , MAX(CELL_ITEM_ID) AS CELL_ITEM_ID, MAX(CONVERT_QTY_CELL) AS CONVERT_QTY_CELL, MAX(CELL_CF) AS CELL_CF
									   , MAX(OPERATION_GROUP) AS OPERATION_GROUP
									   , GROUP_CODE1, ATTRIBUTE1
								FROM SCP_MST_FINAL_ITEM WITH(NOLOCK) 
								WHERE 1=1
								GROUP BY DIVISION_ID, ITEM_ID, GROUP_CODE1, ATTRIBUTE1
						) fi
		ON  a.division_id = fi.division_id
		AND a.item_id     = fi.item_id
	
		LEFT OUTER JOIN (SELECT distinct ITEM_ID, MAX(TARGET_CELL) AS TARGET_CELL, MAX(CELL_CF) AS CELL_CF
								FROM scp_mst_item_cell_cf WITH(NOLOCK) 
								WHERE 1=1
								GROUP BY ITEM_ID
						) cf
		ON  a.item_id     = cf.item_id

	--	LEFT OUTER JOIN (select distinct cell_item_id, item_id
	--						from SCP_XLS_PSI_GLOBAL with(nolock)
	--						where  division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
	----						and    item_id = 'AAHP1006I-B2-000'
	--					) psi
	--	ON  a.item_id     = psi.item_id	

	WHERE  1=1
	AND    a.division_id    IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ',')) -- = @p_division_id
	AND    a.result_date    = @p_cutoff_date
	AND    a.to_scm_site_id IN (SELECT token FROM [dbo].[String_Split](@p_plant_site_id, ',')) -- = @p_plant_site_id
	AND    a.delivery_qty   <> 0
	AND    a.result_type in ('C', 'I')
	AND    case when fi.operation_group = 'A' then fi.group_code1
			when fi.operation_group = 'P' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
			else '' 
		END 
		IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))
	AND    s.site_type = 'PLANT'

	-------------------------------------------------
	-- 3.2 해상재고 (고객사로 이동 / 모든 고객사 대상 조회)
	-------------------------------------------------
	UNION ALL
	SELECT a.result_date AS cutoff_date, a.division_id, a.to_scm_site_id AS scm_site_id
		 , fi.operation_group

		 /* 아래 4개 중 1개*/
		 --, fi.cell_item_id
		 --, fi.attribute1
		 --, cf.target_cell
		 --, psi.cell_item_id
		 , ISNULL(
			CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN cf.target_cell
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN fi.cell_item_id
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.cell_item_id
				ELSE fi.cell_item_id
			END
			, fi.attribute1)		as cell_item_id

		 , a.item_id
		 , case when fi.operation_group = 'A' then fi.group_code1
				when fi.operation_group = 'P' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
				else '' 
			end					as cell_model 
		 , a.from_scm_site_id	AS factory_id
		 , 'INTRANSIT' AS stock_type
		 , '-' AS storage_id
		 , 'INTRANSIT' AS operation_id
		 , 'INTRANSIT' AS operation_name
		 , '-'	AS mes_map_sloc
		 , 'N'  AS wiphold_yn
		 --, case when result_type = 'c' and then 'Semi Intransit'
			--	when result_type = 'i' then 'Intransit'
			--	else '-' 
		 --  end			AS measure
		 , case when s.site_type = 'PLANT' then 'Semi Intransit'
				when s.site_type = 'SALES' then 'Intransit'
				else '-' 
		   end			AS measure
		 , case when DATEDIFF(DAY, CONVERT (DATE, a.result_date), CONVERT (DATE, a.f_dest_eta_date)) < 0 then DATEADD (DAY, 1, a.result_date)
		   else CONVERT (DATE, a.f_dest_eta_date) 
		   end				AS release_date
		 , a.delivery_qty AS scm_qty
		 , CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
				ELSE 1.0
		   END cell_conversion
		 ,(CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
				WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
				WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
				ELSE 1.0
		   END * a.delivery_qty ) / 1000.0 AS kcell -- K Cell 단위
	FROM scm_dnm_intransit_c a WITH(NOLOCK)
	
		LEFT OUTER JOIN SCM_MST_SITE     S WITH(NOLOCK) ON S.DIVISION_ID = a.DIVISION_ID AND S.scm_site_id = a.to_scm_site_id

		LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID
									   , MAX(CELL_ITEM_ID) AS CELL_ITEM_ID, MAX(CONVERT_QTY_CELL) AS CONVERT_QTY_CELL, MAX(CELL_CF) AS CELL_CF
									   , MAX(OPERATION_GROUP) AS OPERATION_GROUP
									   , GROUP_CODE1, ATTRIBUTE1
								FROM SCP_MST_FINAL_ITEM WITH(NOLOCK) 
								WHERE 1=1
								GROUP BY DIVISION_ID, ITEM_ID, GROUP_CODE1, ATTRIBUTE1
						) fi
		ON  a.division_id = fi.division_id
		AND a.item_id     = fi.item_id
	
		LEFT OUTER JOIN (SELECT distinct ITEM_ID, MAX(TARGET_CELL) AS TARGET_CELL, MAX(CELL_CF) AS CELL_CF
								FROM scp_mst_item_cell_cf WITH(NOLOCK) 
								WHERE 1=1
								GROUP BY ITEM_ID
						) cf
		ON  a.item_id     = cf.item_id

	--	LEFT OUTER JOIN (select distinct cell_item_id, item_id
	--						from SCP_XLS_PSI_GLOBAL with(nolock)
	--						where  division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
	----						and    item_id = 'AAHP1006I-B2-000'
	--					) psi
	--	ON  a.item_id     = psi.item_id	

	WHERE  1=1
	AND    a.division_id    IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ',')) -- = @p_division_id
	AND    a.result_date    = @p_cutoff_date
	AND    a.to_scm_site_id IS NOT NULL
	AND    a.from_scm_site_id IN (SELECT token FROM [dbo].[String_Split](@p_plant_site_id, ','))
	AND    a.delivery_qty   <> 0
	AND    a.result_type in ('C', 'I')
	AND    case when fi.operation_group = 'A' then fi.group_code1
			when fi.operation_group = 'P' then (select group_code1 from scp_mst_final_item b with(nolock) where b.division_id = fi.division_id and b.item_id = fi.attribute1)
			else '' 
		END 
		IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))
	AND    s.site_type = 'SALES'

)

