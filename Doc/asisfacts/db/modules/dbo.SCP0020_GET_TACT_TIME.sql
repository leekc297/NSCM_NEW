
/*
 * Program ID   : SCP0020_GET_TACT_TIME
 * Description  : TACT TIME 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/03/16   byunghunjung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/17   byunghunjung    전극 제외
 * 2018/05/23   pjs			    big tact time 관련내용 추가
 * 2018/05/23   pjs			    operation_name 추가
 * 2018/05/24   byunghunjung    model_site 컬럼 추가
 * 2018/05/24   byunghunjung    operation_group_id 수정
 * 2018/05/25   byunghunjung    daily_capacity 추가
 * 2018/05/28   byunghunjung    Mkt Fcst 있는 모델만 조회되도록 수정
 * 2018/05/30   byunghunjung    Mkt Fcst 이 없어질경우 BOM연결된 하위 모델도 조회되지 않도록 수정
 * 2018/06/04   byunghunjung    daily_capacity isnull 조건 추가
 * 2018/07/09   byunghunjung    40, 82 사업부는 SAELS SITE, PROJECT CODE 가 없으므로 - 처리함
 * 2018/07/17   byunghunjung    Cell계획기준 전극미등록 모델 리스트 추가
 * 2018/07/23   ygkim		    scp_mst_tact_time 조회 조건 	AND a.valid_yn      = 'Y' 삭제
 * 2018/08/07   byunghunjung    Cell계획기준 전극미등록 모델 리스트 제거
 * 2018/08/08   byunghunjung    TCO Cell 조회결과 제외
 * 2018/09/17	hwyoon			Tact Time 조회항목 추가(item UOM, UOM Convert)
 * 2018/09/19   ygkim			daily_capacity * a.uom_convert_value 추가
 * 2018/10/04   ygkim           전극이 아닐 경우에만 MKT FCST 존재하는 모델만 조회
 * 2018/10/24   hwyoon          operation 공정조회 쿼리 수정
 * 2018/10/31	hwyoon          Big Data 수정일자 항목 추가
 * 2018/11/01	hwyoon          전극일 시 BOM수요가 있는 것들만 입력화면에 출력
 * 2018/11/07	hwyoon			vmi에 따라 MKT measure 조절
 * 2018/11/12	hwyoon			due date 추가
 * 2018/12/05	hwyoon			플랜예외 여부(except_yn) 추가
 * 2018/12/14	hwyoon			라인 활성화 여부 체크
 * 2018/12/21	hwyoon			T/T 등록필요리스트 조회 시 라인 비활성화 된 T/T 제거후 조회
 * 2019/01/28	hwyoon			[PS02199094B] [전지 GSCM 대응 및 고도화] Big Data 로직 개선 전 데이터 화면출력 X
 * 2019/04/09	hwyoon			[CSR ID:3966780] Tact Time 입력 시 Plant, Line 유효성 체크 로직 개선 - 수요아이템 체크 실시간 조회
 * 2019/12/16	hwyoon			Lane Qty, Jumbo/Min 조회항목 추가
 * 2021/03/09	PJG 			초기 쿼리문 실행 속도 개선
 * 2022/11/07   jahn1501		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 
 * EX)
     EXEC SCP0020_GET_TACT_TIME @p_division_id='81', @p_plant_site_id='', @p_line_id='', @p_operation_group_id='P', @p_item_id='', @p_valid=NULL, @debug_mode='F'
 * operation_group_id 화면에서 필수 선택으로 변경 (속도이슈)
 */

CREATE PROCEDURE [dbo].[SCP0020_GET_TACT_TIME]
   @p_division_id		 NVARCHAR(MAX)
  ,@p_plant_site_id		 NVARCHAR(MAX)
  ,@p_line_id   		 NVARCHAR(MAX)
  ,@p_operation_group_id NVARCHAR(MAX)
  ,@p_item_id            NVARCHAR(MAX)
  ,@p_valid				 NVARCHAR(1)
  ,@debug_mode			 NVARCHAR(20)  ='F'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	declare @v_division_id NVARCHAR(MAX) = null
	declare @v_item_id NVARCHAR(MAX) = null
	set @v_division_id = @p_division_id;
	set @v_item_id = @p_item_id;

/********************************************************************************
* 임시테이블만들기
********************************************************************************/
IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0020_TMP') IS NOT NULL	
	DROP TABLE #TblDynamicPivot_SCP0020_TMP

CREATE TABLE #TblDynamicPivot_SCP0020_TMP (
		 DIVISION_ID		NVARCHAR(60)	
		,ITEM_ID			NVARCHAR(100)
	);

IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0020_TMP1') IS NOT NULL	
	DROP TABLE #TblDynamicPivot_SCP0020_TMP1

CREATE TABLE #TblDynamicPivot_SCP0020_TMP1 (
		 DIVISION_ID		NVARCHAR(60)	
		,ITEM_ID			NVARCHAR(100)
	);

-- FCST ITEM 조회
/*
WITH SUB AS
(
    SELECT aa.division_id	
            , aa.item_id 	 
            , min( aa.yyyymmdd ) as min_yyyymmdd                       
    FROM   dm_pln_mkt_fcst aa WITH (NOLOCK)
            INNER JOIN ( 
                        SELECT division_id, scm_site_id, vmi_yn 
                        FROM   scm_mst_site  WITH (NOLOCK)
   WHERE  1=1
                        AND    valid_yn    = 'Y'
                        ) mse
  ON   aa.division_id = mse.division_id
			--AND  aa.division_id = @v_division_id
            AND  aa.scm_site_id = mse.scm_site_id 
    WHERE  1=1
	--AND	   aa.division_id = @v_division_id
    AND    aa.measure         = IIF(mse.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST')
    AND    aa.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
    AND    aa.yyyymmdd       <= CONVERT(CHAR(8), DATEADD(DD, 7*51, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
    AND    aa.qty            >  0
    group by aa.division_id	
            , aa.item_id 
)
INSERT INTO #TblDynamicPivot_SCP0020_TMP
SELECT DISTINCT T.DIVISION_ID, T.ITEM_ID
FROM 
    ( SELECT B.DIVISION_ID,B.CHILD_ITEM_ID,MIN(X.MIN_YYYYMMDD) AS MIN_YYYYMMDD
        FROM SUB X
            ,DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V B
        WHERE X.DIVISION_ID  = B.DIVISION_ID
        AND X.ITEM_ID      = B.MODEL_ID
		AND ( ( @v_item_id IS NULL OR  @v_item_id = '' ) OR B.CHILD_ITEM_ID    IN (SELECT token FROM dbo.String_Split(@v_item_id  ,',')) )	
        GROUP BY B.DIVISION_ID,B.CHILD_ITEM_ID   
        ) XX,
        SCP_MST_FINAL_ITEM T WITH(NOLOCK)
WHERE 1=1
AND XX.DIVISION_ID   = T.DIVISION_ID
AND XX.CHILD_ITEM_ID = T.ITEM_ID
AND XX.DIVISION_ID=@v_division_id
;
*/


-- 2021.03.09 PJG
-- 실행속도 개선

--INSERT INTO #TblDynamicPivot_SCP0020_TMP
--SELECT distinct aa.division_id, T.ITEM_ID 
--FROM   dm_pln_mkt_fcst aa WITH (NOLOCK)
--JOIN scm_mst_site mse with(nolock) on mse.VALID_YN='Y' 
--								   and aa.measure         = IIF(mse.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST') 
--								   AND aa.scm_site_id = mse.scm_site_id 
--								   AND aa.division_id = mse.division_id
--JOIN DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK) ON aa.DIVISION_ID = b.division_id and aa.ITEM_ID=b.MODEL_ID
--JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK) ON b.DIVISION_ID=t.DIVISION_ID and b.CHILD_ITEM_ID=t.ITEM_ID
--WHERE 1=1
--AND    aa.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
--AND    aa.yyyymmdd       <= CONVERT(CHAR(8), DATEADD(DD, 7*51, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
--AND    aa.qty            >  0
--and	   aa.DIVISION_ID = @v_division_id
--AND ( ( @v_item_id IS NULL OR  @v_item_id = '' ) OR B.CHILD_ITEM_ID    IN (SELECT token FROM dbo.String_Split(@v_item_id  ,',')) )	
--group by aa.division_id	, T.ITEM_ID  
;

INSERT INTO #TblDynamicPivot_SCP0020_TMP1
SELECT distinct aa.division_id , B.child_item_id --, T.ITEM_ID 
FROM   dm_pln_mkt_fcst aa WITH (NOLOCK)
JOIN scm_mst_site mse with(nolock) on mse.VALID_YN='Y' 
								   --2022/11/07
								   --and aa.measure         = IIF(mse.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST')
								   and aa.measure         = CASE WHEN ISNULL(mse.OPERATION_GROUP, '') = 'W' THEN 'AS_In_Req' WHEN mse.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(aa.attribute10, '') = '' THEN 'MKT_FCST' END 
								   AND aa.scm_site_id = mse.scm_site_id 
								   AND aa.division_id = mse.division_id
JOIN DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK) ON aa.DIVISION_ID = b.division_id and aa.ITEM_ID=b.MODEL_ID
--JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK) ON aa.DIVISION_ID=t.DIVISION_ID and b.CHILD_ITEM_ID=t.ITEM_ID
WHERE 1=1
AND    aa.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
AND    aa.yyyymmdd       <= CONVERT(CHAR(8), DATEADD(DD, 7*51, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
AND    aa.qty            >  0
and	   aa.DIVISION_ID = @v_division_id
AND ( ( @v_item_id IS NULL OR  @v_item_id = '' ) OR B.CHILD_ITEM_ID    IN (SELECT token FROM dbo.String_Split(@v_item_id  ,',')) )	
--group by aa.division_id	, B.child_item_id --, T.ITEM_ID  
;

INSERT INTO #TblDynamicPivot_SCP0020_TMP
SELECT distinct aa.division_id , aa.ITEM_ID --, T.ITEM_ID 
FROM   #TblDynamicPivot_SCP0020_TMP1 aa WITH (NOLOCK)
JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK) ON aa.DIVISION_ID=t.DIVISION_ID and aa.ITEM_ID=t.ITEM_ID
WHERE 1=1
AND ( ( @v_item_id IS NULL OR  @v_item_id = '' ) OR aa.ITEM_ID    IN (SELECT token FROM dbo.String_Split(@v_item_id  ,',')) )	
;

IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0020_TMP1') IS NOT NULL	
	DROP TABLE #TblDynamicPivot_SCP0020_TMP1
;


SELECT 
	   m.division_id
      ,m.plant_site_id
      ,dbo.FN_GET_SCM_SITE_DESCRIPTION (m.division_id, m.plant_site_id ) AS plant_site_name
      ,m.operation_group_id
      ,m.operation_id
	  ,m.operation_id as operation_name
	  ,m.model_site
      ,m.item_id
      ,isnull(m.nick_name,'-') as nick_name
      ,m.line_id
	  ,m.input_status
      ,m.priority
	  ,m.valid_yn
      ,m.yield AS yield
	  ,m.daily_capacity
	  ,m.item_uom
	  ,m.uom_convert_value
	  ,m.tact_time
	  ,n.tact_time AS big_tact_time
	  ,n.actual_output
	  ,n.actual_capacity
	  ,n.from_actual_capacity
	  ,n.to_actual_capacity
	  ,n.effective_data_count	  	
	  ,n.last_update_date big_last_update_date
	  ,m.BOM_MIN_DUE_DATE
      ,m.created_by
      ,m.creation_date
      ,m.last_updated_by
      ,m.last_update_date
      ,(CASE WHEN m.line_id IS NULL THEN '1' ELSE '2' END) AS line_order 
	  ,m.except_yn
	  ,(CASE WHEN m.operation_group_id='E' THEN m.LANE_QTY ELSE NULL END) AS LANE_QTY
	  ,(CASE WHEN m.operation_group_id='E' AND m.tact_time IS NOT NULL AND m.LANE_QTY IS NOT NULL AND m.LANE_QTY<>'' THEN m.tact_time*m.LANE_QTY*60 ELSE NULL END) AS JUMBO_MIN
FROM(
			-- Tact Time Master 조회
			SELECT distinct 
				   a.division_id
				  ,a.plant_site_id
				  ,dbo.fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id -- item_sn 테이블에 미등록된 site 경우 값을 가져올 수 없어 function을 통해 가져옴
				  ,a.operation_id
				  ,i.site_id AS model_site
				  ,a.item_id
				  ,i.nick_name
				  ,a.line_id
				  ,a.priority
				  ,a.tact_time
				  ,ROUND(a.yield*100,2) AS yield
				  , ((1440 - isnull( d.loss_time_min,0) - isnull( d.setup_loss_time_min,0) ) *60 / a.tact_time ) * isnull(a.uom_convert_value,1) AS daily_capacity
				  ,a.item_uom
				  ,a.uom_convert_value
				  ,a.valid_yn
				  ,NULL AS BOM_MIN_DUE_DATE
				  ,a.created_by
				  ,a.creation_date
				  ,a.last_updated_by
				  ,a.last_update_date
				  , 'M' as input_status
				  , isnull((select top 1 'Y'
							from SCP_MST_TACT_TIME_EXCEPT x 
							INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
										FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
										WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
										AND    b.valid_yn    = 'Y'
										AND    b.segment3    = 'Y' -- Capa 세부 공정 여부						
									) c ON a.operation_id = c.segment4
							where x.division_id=a.division_id 
							and x.plant_site_id=a.plant_site_id 
							and x.operation_id=a.operation_id
							and x.item_id=a.item_id
							and x.line_id=a.line_id
							--and x.use_yn='Y'
							),'N') as except_yn
					,ISNULL((SELECT COUNT(LS.ACTIVE_FLAG) FROM SCM_MST_LINE_SN LS 
												  WHERE LS.COMPANY_ID=B.COMPANY_ID AND LS.DIVISION_ID=A.DIVISION_ID AND LS.SITE_ID=B.SITE_ID AND LS.PLANT_ID=B.PLANT_ID 
												    AND LS.OPERATION_ID=A.OPERATION_ID AND LS.LINE_ID=A.LINE_ID AND LS.ACTIVE_FLAG='Y'), 0) ACTIVE_CNT
					,a.attribute1 as LANE_QTY
			 FROM scp_mst_tact_time a (NOLOCK) 
			 LEFT OUTER JOIN scm_mst_item_sn i (NOLOCK) ON a.division_id = i.division_id 
														AND a.item_id = i.item_id 
														AND i.site_id = ( select site_id from scm_mst_plant_sn s (NOLOCK) where s.division_id = a.division_id and s.plant_id = dbo.fn_scm_split(a.plant_site_id,1,'-') )
			 JOIN scm_mst_site b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id			 
			 LEFT OUTER JOIN scp_mst_loss_time d ON a.division_id = d.division_id and a.plant_site_id = d.plant_site_id and a.operation_id = d.operation_id and a.line_id = d.line_id
			WHERE 1=1 
			  AND b.osp_yn        = 'N' -- 외주 packer 제외
			  AND a.operation_id <> 'P5000' -- P5000 공정 제외
			  AND a.division_id   =  @p_division_id
			  AND ( ( @p_plant_site_id IS NULL OR  @p_plant_site_id = '' ) OR a.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )			
			  AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')) )		

			UNION ALL
			-- Project Route 화면에 등록된 모델중 Tact Time Master에 없는 모델 조회
			-- scp_mst_tact_time 에 등록되면 리스트에서 제외
			SELECT DISTINCT
				   a.division_id
				  ,a.plant_site_id
				  ,dbo.fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id -- item_sn 테이블에 미등록된 site 경우 값을 가져올 수 없어 function을 통해 가져옴
				  ,(SELECT TOP 1 substring(X.scp_flow_id,1,5) FROM scm_mst_item_sn X WITH (NOLOCK) WHERE X.division_id = A.division_id AND X.item_id=A.item_id) AS operation_id
				  --,substring(i.scp_flow_id,1,5) AS operation_id
				  --,i.scp_flow_id AS operation_id
				  ,i.site_id AS model_site
				  ,a.item_id
				  ,i.nick_name
				  ,null AS line_id
				  ,null AS priority
				  ,null AS tact_time
				  ,null AS yield
				  ,null AS daily_capacity
				  ,null AS item_uom
				  ,null AS uom_convert_value
				  ,'Y' AS valid_yn
				  ,CONVERT(CHAR(10), C.MIN_DUE_DATE, 23) AS BOM_MIN_DUE_DATE
				  ,null AS created_by
				  ,null AS creation_date
				  ,null AS last_updated_by
				  ,null AS last_update_date
				  , 'I' as input_status
				  ,null AS except_yn
				  ,1 AS ACTIVE_CNT
				  ,null as LANE_QTY
			FROM scm_mst_site_item_priority a (NOLOCK)
			LEFT OUTER JOIN scm_mst_item_sn i (NOLOCK) ON a.division_id = i.division_id 
														AND a.item_id = i.item_id 
														AND i.site_id = ( select site_id from scm_mst_plant_sn s (NOLOCK) where s.division_id = a.division_id and s.plant_id = dbo.fn_scm_split(a.plant_site_id,1,'-') )
			JOIN SCM_MST_SITE b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id
			LEFT JOIN scp_mst_final_item C (NOLOCK) ON a.division_id = C.division_id and a.item_id = C.item_id and C.fcst_yn = upper('Y')
			WHERE 1=1 
			  AND a.valid_yn    = 'Y'
			  AND b.osp_yn      = 'N' -- 외주 packer 제외
			  AND NOT EXISTS ( select 'X' from scp_mst_tact_time n (NOLOCK) 
								JOIN SCM_MST_LINE_SN LS ON LS.COMPANY_ID=B.COMPANY_ID AND LS.DIVISION_ID=N.DIVISION_ID AND LS.SITE_ID=B.SITE_ID AND LS.PLANT_ID=B.PLANT_ID
																		AND LS.OPERATION_ID=N.OPERATION_ID AND LS.LINE_ID=N.LINE_ID AND LS.ACTIVE_FLAG='Y'
								where n.division_id = a.division_id 
								and n.plant_site_id = a.plant_site_id 
								and n.item_id = a.item_id )
			  -- MKT FCST 존재하는 모델만 조회(전극이 아닐 경우에만) -> 전극도 포함
			  AND EXISTS ( SELECT 'X'
								   FROM #TblDynamicPivot_SCP0020_TMP F WITH(NOLOCK)
								  WHERE F.DIVISION_ID=A.DIVISION_ID
								    AND F.ITEM_ID=A.ITEM_ID
							   )
			  AND a.division_id = @p_division_id
			  AND ( ( @p_plant_site_id IS NULL OR  @p_plant_site_id = '' ) OR a.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )			
			  AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')) )	
			 )m
 LEFT OUTER JOIN scp_mst_tact_time_big n (NOLOCK) ON m.division_id  = n.division_id
												AND m.plant_site_id = n.plant_site_id
												AND m.item_id       = n.item_id
												and m.operation_id  = n.operation_id
												and m.line_id       = n.line_id
												and CONVERT(CHAR(8), n.last_update_date, 112)>='20181101' -- Big Data 로직 개선전 제외
WHERE 1=1
AND m.division_id = @p_division_id
AND m.operation_group_id = @p_operation_group_id
AND ( ( @p_valid   IS NULL OR  @p_valid   = '' ) OR m.valid_yn   IN (SELECT token FROM dbo.String_Split(@p_valid  ,',')) )
AND ( ( @p_line_id IS NULL OR  @p_line_id = '' ) OR m.line_id    IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
AND substring(m.item_id,2,1) = CASE WHEN m.operation_group_id = 'A' Then 'C' ELSE substring(m.item_id,2,1)  END  --TCO Cell조회불가
AND m.ACTIVE_CNT>0
ORDER BY line_order, m.division_id, m.plant_site_id, m.operation_id, m.line_id,m.model_site, m.item_id
;

/********************************************************************************
* 임시테이블만들기
********************************************************************************/
IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0020_TMP') IS NOT NULL	
	DROP TABLE #TblDynamicPivot_SCP0020_TMP
;

END
