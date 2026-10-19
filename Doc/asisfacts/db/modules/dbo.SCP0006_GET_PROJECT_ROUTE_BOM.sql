
/*
 * Program ID   : SCP0006_GET_PROJECT_ROUTE_BOM
 * Description  : Project Route BOM 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge       Description
 *===================================================================================================
 * 2017/12/28   byunghunjung            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/03/26   PJS                     Sales Site 추가
 * 2018/05/03   byunghunjung            Alternate Part 제외로직 추가
 * 2018/05/17   byunghunjung            전극 제외
 * 2018/05/24   byunghunjung            ESS 팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
 * 2018/06/21   byunghunjung            BOM을 제거모델 조회안되도록 수정
 * 2018/09/14   byunghunjung            Item Type = R 도 보이도록 수정
 * 2019/03/26   KSG                     [재료본부 전지재료 GSCM 구축 프로젝트] 재료 operation_group 표시 추가 (190415 전지재료 삭제)
 * 2021/03/30   PJG                     대체 BOM 모델링 적용
 * 2022/01/20   VADABI3                 BOM Explosion > Sort 우선 순위 적용 > P (DC_LINK) ->  P(NOT DC_LINK) -> A -> E
 * 2023/06/07   chaan			V1.1.1  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화 코드 분리
 * 2023/07/26   chaan			V1.1.2  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - CA1/CA2 정렬순서 변경(CA2우선)
 * 2024/06/05   mrchois					PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성
 *
 */
CREATE PROCEDURE [dbo].[SCP0006_GET_PROJECT_ROUTE_BOM]
    @p_division_id  NVARCHAR(200),
    @p_scm_site_id  NVARCHAR(200),
    @p_model_id     NVARCHAR(200),
    @p_project_code NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


    --DECLARE @p_division_id  NVARCHAR(200)   = '81';
    --DECLARE @p_scm_site_id  NVARCHAR(200)   = 'Ford_TR_GOK';
    --DECLARE @p_model_id     NVARCHAR(200)   = 'APFMCV36X-B1';
    --DECLARE @p_project_code NVARCHAR(200)   = 'A15FD7001';

	-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois START
	DECLARE @v_group_id			NVARCHAR(MAX)
	DECLARE @v_model_id			NVARCHAR(MAX)
	SET @v_group_id = '';
	SET @v_model_id = '';

	SELECT @v_group_id = ISNULL(GROUP_ID, '')
	FROM SCP_MST_ITEM_GROUP_DETAIL WITH(NOLOCK)
	WHERE 1=1
	  AND DIVISION_ID		= @p_division_id
	  AND PROJECT_CODE	= @p_project_code
	  AND ITEM_ID			= @p_model_id

	-- GROUP_ID 가 있는 경우 
	IF(LEN(@v_group_id) > 0)
	BEGIN
	
		SELECT @v_model_id = @v_model_id + ITEM_ID + ','
		FROM SCP_MST_ITEM_GROUP_DETAIL WITH(NOLOCK)
		WHERE  1=1
		  AND DIVISION_ID	= @p_division_id
		  AND PROJECT_CODE	= @p_project_code
		  AND GROUP_ID		= @v_group_id;

		SET @v_model_id = LEFT(@v_model_id, LEN(@v_model_id) - 1)

	END
	ELSE
	BEGIN

		SET @v_model_id = @p_model_id;

	END

	-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois END


	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_BOM') IS NOT NULL
	   DROP TABLE #TblDynamicPivot_SCP0006_BOM;

	SELECT DISTINCT
			  CASE
				-- 전극 제외 20180517
				--WHEN v.operation_group_id = 'E' THEN 'Electrode'
				WHEN v.operation_group_id = 'A' THEN 'Cell'
				WHEN v.operation_group_id = 'P' THEN 'Pack'
				-- 20190326 재료 operation_group 표시 추가 (190415 전지재료 삭제)
				--WHEN v.operation_group_id = 'PC' THEN 'Precursor'
				--WHEN v.operation_group_id = 'BU' THEN 'Burnning'
				--WHEN v.operation_group_id = 'WS' THEN 'Washing'
				--WHEN v.operation_group_id = 'SU' THEN 'Surface Treatment'
			  END AS OPERATION_GROUP
			, V.OPERATION_GROUP_ID
			, V.ELECTRODE_TYPE
			, T.CHILD_ITEM_ID AS ITEM_ID
			, DBO.FN_GET_ITEM_NICKNAME(T.DIVISION_ID, T.CHILD_ITEM_ID) AS ITEM_NAME   --I.ITEM_NAME
--,CONVERT(NUMERIC(7,4), ROUND(T.CHILD_QTY,4)) AS NET_REQ_QTY
--,T.CHILD_UOM AS UOM
			, (
					SELECT	SITE_DESCRIPTION
					FROM	(
								SELECT	  B.SITE_DESCRIPTION
										, ROW_NUMBER() OVER (ORDER BY FROM_YYYYMMDD) AS ROWNUMBER
								FROM	SCM_MST_SITE_ITEM_PRIORITY A
										JOIN SCM_MST_SITE B ON 
												A.DIVISION_ID	= B.DIVISION_ID 
											AND A.PLANT_SITE_ID = B.SCM_SITE_ID
								WHERE	A.DIVISION_ID	= T.DIVISION_ID
									AND A.SALES_SITE_ID = S.SCM_SITE_ID /* 20180326 SALES SITE 추가부분 */
									AND A.ITEM_ID		= T.CHILD_ITEM_ID
									--AND A.PROJECT_CODE = @p_project_code
									AND A.PROJECT_CODE	= S.PROJECT_CODE
									AND A.TO_YYYYMMDD	>=  CONVERT(VARCHAR, GETDATE(),112)
									AND A.VALID_YN		= 'Y'
									AND A.PRIORITY		= '1'
							) A
					WHERE	ROWNUMBER = 1
			  ) AS PRIMARY_PLANT
			--,T.CONCATENATE_ITEM
			, T.DIVISION_ID
			, S.SCM_SITE_ID /* 20180326 SALES SITE 추가부분 */
			, S.PROJECT_CODE
			-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois START
			, T.MODEL_ID	--화면 정렬 순서를 위해 추가
			-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois END
			, M.DISPLAY_SEQ
			, T.ALT_PRIORITY
			, V.DC_YN
			, V.RACK_YN
            , V.CELL_TYPE -- 활성화코드 분리->Cell Assy Type
            , CASE
                WHEN V.CELL_TYPE = '' OR V.CELL_TYPE IS NULL THEN 0
                WHEN V.CELL_TYPE = 'CP'  THEN 1
                WHEN V.CELL_TYPE = 'CA2' THEN 2
                WHEN V.CELL_TYPE = 'CA1' THEN 3
                ELSE 4
              END AS CEL_TYPE_DISPLAY_SEQ
	-- 2021.03.25 대체 BOM 모델링
	INTO	#TblDynamicPivot_SCP0006_BOM
	FROM	SCM_MST_BOM_SN_V T (NOLOCK)
--FROM SCM_MST_MODEL_BOM T (NOLOCK)
--FROM SCM_MST_BOM_SN T (NOLOCK)
			INNER JOIN SCM_MST_ITEM_SN I ON 
					T.COMPANY_ID	= I.COMPANY_ID 
				AND T.DIVISION_ID	= I.DIVISION_ID	
				AND T.SITE_ID		= I.SITE_ID 
				AND T.CHILD_ITEM_ID = I.ITEM_ID
			INNER JOIN SCM_MST_SITE_ITEM S ON 
					T.DIVISION_ID	= S.DIVISION_ID 
				AND T.MODEL_ID		= S.ITEM_ID
			INNER MERGE JOIN SCM_MST_FINAL_ITEM_V V ON 
					T.DIVISION_ID	= V.DIVISION_ID  
				AND T.CHILD_ITEM_ID = V.ITEM_ID
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M ON 
					M.SEGMENT1		= V.OPERATION_GROUP_ID
	WHERE	1=1
		AND M.LOOKUP_TYPE	= 'OPERATION_GROUP'
		-- 2021.03.25 대체 BOM 모델링
		--AND T.ALT_PRIORITY ='Y'
		AND S.PROJECT_CODE	= @p_project_code
		AND S.SCM_SITE_ID	= @p_scm_site_id /* 20180326 sales site추가 */
		AND T.DIVISION_ID	= @p_division_id
		-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois START
		--AND T.MODEL_ID		= @p_model_id
		AND (( @v_model_id  IS NULL OR  @v_model_id ='' ) OR T.MODEL_ID     IN (SELECT token FROM dbo.String_Split(@v_model_id,',')) )
		-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois END
		AND V.OPERATION_GROUP_ID <> 'E'
		AND EXISTS	(
						SELECT	*
						FROM	[dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
						WHERE	DIVISION_ID = @p_division_id --'82'
							AND PARENT_ITEM_ID= t.child_item_id --'ECE0161M1-01'
							--BOM을 제거모델 조회안되도록 수정
							AND EFF_END_DATE >= GETDATE()
							AND KEY_DATE =  ( 
												SELECT	MAX(KEY_DATE)
												FROM	[dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
												WHERE	PARENT_ITEM_ID	= T.CHILD_ITEM_ID --'ECE0315N1-01'
													AND DIVISION_ID		= @p_division_id 
											)
					)
	--ORDER BY M.DISPLAY_SEQ, CHILD_ITEM_ID

	SELECT	  OPERATION_GROUP
			, OPERATION_GROUP_ID
			, ELECTRODE_TYPE
			, ITEM_ID
			, ITEM_NAME
			, PRIMARY_PLANT
			, DIVISION_ID
			, SCM_SITE_ID
			, PROJECT_CODE
			-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois START
			, MODEL_ID
			-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois END
			, DISPLAY_SEQ
			, MAX(ALT_PRIORITY) AS ALT_PRIORITY 
			, A.DC_YN
			, A.RACK_YN
            , A.CELL_TYPE
            , A.CEL_TYPE_DISPLAY_SEQ
	FROM	#TblDynamicPivot_SCP0006_BOM A
	GROUP BY  A.OPERATION_GROUP
			, A.OPERATION_GROUP_ID
			, A.ELECTRODE_TYPE
			, A.ITEM_ID
			, A.ITEM_NAME
			, A.PRIMARY_PLANT
			, A.DIVISION_ID
			, A.SCM_SITE_ID
			, A.PROJECT_CODE
			-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois START
			, A.MODEL_ID
			-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois END
			, A.DISPLAY_SEQ
			, A.DC_YN
			, A.RACK_YN
            , A.CELL_TYPE
			, A.CEL_TYPE_DISPLAY_SEQ
/*
Sort 정책
1, rack_yn DESC
2, DC_YN DESC -- Y,N 순으로 정렬
3, .operation_group DESC -- (P,A,E 순으로 정렬) -> 단 display_seq 가 더 최적 Sort
4, A.display_seq
5, item_id
*/
	ORDER BY  A.RACK_YN DESC
			, A.DC_YN DESC
			-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois START
			, (CASE WHEN ISNULL(PRIMARY_PLANT,'') = '' THEN 1 ELSE 0 END)
			, A.MODEL_ID
			-- GROUP Model Mapping 정보에 의한 Model 전부 가져오기 2024.06.05 mrchois END
			, A.DISPLAY_SEQ
            , A.CEL_TYPE_DISPLAY_SEQ
			, A.ITEM_ID


-- 2021.04.08
-----------------------------------------------------------------------------------------------------------------------------------------------
--SELECT DISTINCT
--		 (CASE
--		  -- 전극 제외 20180517
--		  --WHEN v.operation_group_id = 'E' THEN 'Electrode'
--		  WHEN v.operation_group_id = 'A' THEN 'Cell'
--		  WHEN v.operation_group_id = 'P' THEN 'Pack'
--		  -- 20190326 재료 operation_group 표시 추가 (190415 전지재료 삭제)
--		  --WHEN v.operation_group_id = 'PC' THEN 'Precursor'
--		  --WHEN v.operation_group_id = 'BU' THEN 'Burnning'
--		  --WHEN v.operation_group_id = 'WS' THEN 'Washing'
--		  --WHEN v.operation_group_id = 'SU' THEN 'Surface Treatment'
--		  END ) AS operation_group
--        ,v.operation_group_id
--		,v.electrode_type
--		,t.child_item_id AS item_id
--		,dbo.FN_GET_ITEM_NICKNAME(t.division_id, t.child_item_id) as item_name   --i.item_name
--		--,convert(numeric(7,4), round(t.child_qty,4)) AS net_req_qty
--		--,t.child_uom AS uom
--		,(SELECT site_description
--		  FROM (
--				  SELECT b.site_description
--						,ROW_NUMBER() OVER (ORDER BY from_yyyymmdd) AS rownumber
--				  FROM scm_mst_site_item_priority a
--				  JOIN scm_mst_site b ON a.division_id = b.division_id and a.PLANT_SITE_ID = b.scm_site_id
--				  WHERE a.division_id = t.division_id
--				    AND A.SALES_SITE_ID = S.SCM_SITE_ID /* 20180326 sales site 추가부분 */
--				    AND a.item_id = t.child_item_id
--				    --AND a.project_code = @p_project_code
--					AND a.project_code = s.project_code
--				    AND a.to_yyyymmdd >=  convert(varchar, getdate(),112)
--				    AND a.valid_yn ='Y'
--					AND a.priority ='1'
--	 		  ) a
--		  WHERE rownumber =1
--		  ) AS primary_plant
--		--,t.concatenate_item
--		,t.division_id
--		,s.SCM_SITE_ID /* 20180326 sales site 추가부분 */
--		,s.project_code
--		,m.display_seq
--		,t.alt_priority
--    -- 2021.03.25 대체 BOM 모델링
--	FROM SCM_MST_BOM_SN_V t (NOLOCK)
--	--FROM scm_mst_bom_sn t (NOLOCK)
--	JOIN scm_mst_item_sn i ON t.company_id = i.company_id and t.division_id = i.division_id	and t.site_id = i.site_id and t.child_item_id = i.item_id
--	JOIN scm_mst_site_item s ON t.division_id = s.division_id and t.model_id = s.item_id
--	JOIN scm_mst_final_item_v v ON t.division_id = v.division_id  and t.child_item_id = v.item_id
--	JOIN scm_adm_lookup_master_detail m ON m.segment1 = v.operation_group_id
--	WHERE 1=1
--	AND m.lookup_type ='OPERATION_GROUP'
--	-- 2021.03.25 대체 BOM 모델링
--	--AND t.alt_priority ='Y'
--	AND s.project_code	= @p_project_code
--	AND s.SCM_SITE_ID	= @p_scm_site_id /* 20180326 sales site추가 */
--	AND t.division_id	= @p_division_id
--	AND t.model_id		= @p_model_id
--	AND v.OPERATION_GROUP_ID <> 'E'
--	AND EXISTS (SELECT *
--                FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
--               WHERE DIVISION_ID = @p_division_id --'82'
--                 AND PARENT_ITEM_ID= t.child_item_id --'ECE0161M1-01'
--				--BOM을 제거모델 조회안되도록 수정
--				 AND EFF_END_DATE >= GETDATE()
--                 AND KEY_DATE = ( SELECT MAX(KEY_DATE)
--                                    FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
--                                   WHERE PARENT_ITEM_ID= t.child_item_id --'ECE0315N1-01'
--                                     AND DIVISION_ID = @p_division_id )
--                )

--     ORDER BY m.display_seq, child_item_id
-----------------------------------------------------------------------------------------------------------------------------------------------

	--AND dbo.FN_GET_ITEM_OPERATION_GROUP(t.division_id, t.model_id) <> 'E'
	  -- 전극 제외 20180517
	--UNION

	--SELECT DISTINCT
	--	  'Electrode' AS operation_group
	--	, 'E' AS operation_group_id
	--	, '' AS electrode_type
	--	, @p_model_id AS item_id
	--	, dbo.FN_GET_ITEM_NICKNAME(t.division_id, t.child_item_id) as item_name   --i.item_name
	--	,(SELECT site_description
	--	  FROM (
	--			  SELECT b.site_description
	--					,ROW_NUMBER() OVER (ORDER BY from_yyyymmdd) AS rownumber
	--			  FROM scm_mst_site_item_priority a
	--			  JOIN scm_mst_site b ON a.division_id = b.division_id and a.PLANT_SITE_ID = b.scm_site_id
	--			  WHERE a.division_id = t.division_id
	--			    AND A.SALES_SITE_ID = S.SCM_SITE_ID /* 20180326 sales site 추가부분 */
	--			    AND a.item_id = t.child_item_id
	--			    --AND a.project_code = @p_project_code
	--				AND a.project_code = s.project_code
	--			    AND a.to_yyyymmdd >=  convert(varchar, getdate(),112)
	--			    AND a.valid_yn ='Y'
	--			    AND a.priority ='1'
	-- 		  ) a
	--	  WHERE rownumber =1
	--	  ) AS primary_plant
	--	--,t.concatenate_item
	--	,t.division_id
	--	,s.SCM_SITE_ID /* 20180326 sales site 추가부분 */
	--	,s.project_code
	--	,'3' as display_seq
	--FROM scm_mst_bom_sn t
	--JOIN scm_mst_item_sn i ON t.company_id = i.company_id and t.division_id = i.division_id	and t.site_id = i.site_id and t.child_item_id = i.item_id
	--JOIN scm_mst_site_item s ON t.division_id = s.division_id and t.model_id = s.item_id
	--WHERE 1=1
	--AND s.project_code	= @p_project_code
	--AND s.SCM_SITE_ID	= @p_scm_site_id /* 20180326 sales site추가 */
	--AND t.division_id	= @p_division_id
	--AND i.ITEM_ID       = @p_model_id
	--AND dbo.FN_GET_ITEM_OPERATION_GROUP(t.division_id, i.ITEM_ID) = 'E'
	--AND	t.alt_priority ='Y'


	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_BOM') IS NOT NULL
	   DROP TABLE #TblDynamicPivot_SCP0006_BOM;

END

