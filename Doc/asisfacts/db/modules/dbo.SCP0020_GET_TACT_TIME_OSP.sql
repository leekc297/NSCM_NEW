

/*
 * Program ID   : SCP0020_GET_TACT_TIME_OSP
 * Description  : TACT TIME OSP 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/02/03   hwyoon			Initial Release [] 전지 GSCM(SCP) SM 운영 - [C20200116-000114] ESS 외주 Packer Line 계획 수립
 * 2020/10/28   khj79           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2021/10/05	khj79	       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - W/S AS UI 변경
 * 2022/11/07   jahn1501		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 2026/03/23   YMH				E20260310-000552 Tact Time(OSP) 기준정보 설정 로직 변경	
 * 2026/08/03	YMH				E20260728-000548 Tact Time(OSP) 등록대상으로 생성하기 위해서있는 제약 확인 및 기능 보완 요청드립니다.
 * 2026/09/10	ymh				E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다.
 */

CREATE PROCEDURE [dbo].[SCP0020_GET_TACT_TIME_OSP]
   @p_division_id		 NVARCHAR(MAX)
  ,@p_plant_site_id		 NVARCHAR(MAX)
  ,@p_line_id   		 NVARCHAR(MAX)
  ,@p_operation_group_id NVARCHAR(MAX)
  ,@p_item_id            NVARCHAR(MAX)
  ,@debug_mode			 NVARCHAR(20)  ='F'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	declare @v_division_id NVARCHAR(MAX) = null
	declare @v_item_id NVARCHAR(MAX) = null
	set @v_division_id = @p_division_id;
	set @v_item_id = @p_item_id;

    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_end_monday        NVARCHAR(8) = NULL;
    --DECLARE @v_end_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, 7*51, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 월요일 YYYYMMDD
	
    SELECT @v_end_monday = MAX(horizon_end_date)
	FROM   dbo.scm_mst_plan p WITH(NOLOCK)
	WHERE  p.plan_cycle  = 'WEEKLY'
	AND    p.plan_name   = @v_cur_monday
	GROUP BY plan_name
	                                           
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
			-- E20260728-000548 프로직트 코드 추가.
			,PROJECT_CODE		NVARCHAR(50)
		);


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
	--;



	-- 속도 이슈로 수정 함 : SCM_MST_MODEL_FINAL_ITEM_BOM_V 를 조회 후 조인으로 변경 함
	--수정 전
	--INSERT INTO #TblDynamicPivot_SCP0020_TMP1
	--SELECT distinct aa.division_id , B.child_item_id --, T.ITEM_ID 
	--FROM   dm_pln_mkt_fcst aa WITH (NOLOCK)
	--JOIN scm_mst_site mse with(nolock) on mse.VALID_YN='Y' 
	--									--2021/10/05 : W/S AS
	--								   --and aa.measure         = IIF(mse.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST') 
	--								   and aa.measure     = IIF(ISNULL(mse.OPERATION_GROUP, '') = 'W', 'AS_In_Req', IIF(mse.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST'))
	--								   AND aa.scm_site_id = mse.scm_site_id 
	--								   AND aa.division_id = mse.division_id
	--JOIN DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK) ON aa.DIVISION_ID = b.division_id and aa.ITEM_ID=b.MODEL_ID
	----JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK) ON aa.DIVISION_ID=t.DIVISION_ID and b.CHILD_ITEM_ID=t.ITEM_ID
	--WHERE 1=1
	--AND    aa.yyyymmdd       >= @v_cur_monday --CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
	--AND    aa.yyyymmdd       <= @v_end_monday --CONVERT(CHAR(8), DATEADD(DD, 7*51, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
	--AND    aa.qty            >  0
	--and	   aa.DIVISION_ID = @v_division_id
	--AND ( ( @v_item_id IS NULL OR  @v_item_id = '' ) OR B.CHILD_ITEM_ID    IN (SELECT token FROM dbo.String_Split(@v_item_id  ,',')) )	
	----group by aa.division_id	, B.child_item_id --, T.ITEM_ID  
	--;

	

	INSERT INTO #TblDynamicPivot_SCP0020_TMP1
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 신규로직 시작
	SELECT 
		DIVISION_ID, CHILD_ITEM_ID , PROJECT_CODE
	FROM
	(
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 신규로직 끝
	SELECT DISTINCT A.DIVISION_ID 
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 기존로직 주석처리 시작
	-- , B.CHILD_ITEM_ID 
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 기존로직 주석처리 끝
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 신규로직 시작
	, CASE 
		WHEN B.CHILD_ITEM_ID IS NOT NULL THEN B.CHILD_ITEM_ID
		WHEN EXISTS 
			(
				SELECT
					  LMD.SEGMENT2	AS DIVISION_ID
					, LMD.SEGMENT3	AS ITEM_ID 
					, LMD.SEGMENT5	AS PROJECT_CODE
				FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL AS LMD WITH(NOLOCK)
				WHERE LMD.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP' 
				AND LMD.VALID_YN = 'Y'
				AND LMD.SEGMENT3	= A.ITEM_ID
				AND LMD.SEGMENT5	= A.PROJECT_CODE
			) THEN A.ITEM_ID
		ELSE NULL END AS CHILD_ITEM_ID
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 신규로직 끝
	-- E20260728-000548 프로직트 코드 추가.
	, A.PROJECT_CODE
	FROM (
			SELECT distinct  aa.division_id , aa.ITEM_ID 
			-- E20260728-000548 프로직트 코드 추가.
			, AA.PROJECT_CODE
			FROM DM_PLN_MKT_FCST AA WITH (NOLOCK)

			JOIN SCM_MST_SITE mse with(nolock) 
			   on mse.VALID_YN='Y'
			  --2022/11/07			   
			  --and aa.measure     = IIF(ISNULL(mse.OPERATION_GROUP, '') = 'W', 'AS_In_Req', IIF(mse.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST'))
			  and aa.measure     = CASE WHEN ISNULL(mse.OPERATION_GROUP, '') = 'W' THEN 'AS_In_Req' WHEN mse.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(AA.attribute10, '') = '' THEN 'MKT_FCST' END
			  AND aa.scm_site_id = mse.scm_site_id 
			  AND aa.division_id = mse.division_id
			WHERE 1=1
			  AND aa.yyyymmdd       >= @v_cur_monday
			  AND aa.yyyymmdd       <= @v_end_monday
			  AND aa.qty            >  0
			  and aa.DIVISION_ID =  @v_division_id
		) a
	-- E20260310-000552 Tact Time(OSP) 기준정보 설정 로직 변경으로 인해 주석처리
	-- JOIN DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK) ON a.DIVISION_ID = b.division_id and a.ITEM_ID=b.MODEL_ID

	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 기존로직 주석처리 시작
	/*
	-- E20260310-000552 Tact Time(OSP) 기준정보 설정 로직 변경신규로직 추가 시작
	JOIN
	*/
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 기존로직 주석처리 끝
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 신규로직 시작 
	LEFT OUTER JOIN
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 신규로직 끝
	(
		SELECT b.division_id,
			b.model_id,
			b.child_item_id
		FROM ( SELECT x.* 
				--FROM dbo.scm_mst_bom_sn x WITH(NOLOCK)	
				FROM dbo.scm_mst_bom_sn_V x WITH(NOLOCK)	--2021-03-09	SCP 대치 BOM 적용
					INNER JOIN dbo.scm_mst_item_sn i WITH(NOLOCK)
					ON  x.child_division_id = i.division_id
					AND x.child_item_id     = i.item_id
					AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
					AND x.child_site_id     = i.site_id
					AND i.active_flag       = 'Y'           
				WHERE 1=1
			) b
			, scm_mst_final_item_v v WITH(NOLOCK)
			, scm_mst_item_sn mi WITH(NOLOCK)   -- 20210219 C20210219-000229  Company 별로 유효한 Model만 적용
		WHERE 1=1
		AND b.division_id   = v.division_id
		AND b.child_item_id = v.item_id

		-- 20210219 C20210219-000229  Company 별로 유효한 Model만 적용
		AND b.division_id   = mi.division_id
		AND b.model_id      = mi.item_id
		AND b.company_id    = mi.company_id  -- A002 빈강 추가 따른 조건 추가
		AND b.site_id       = mi.site_id
		AND mI.active_flag  = 'Y'
		GROUP BY b.division_id, b.model_id, b.child_item_id
	) AS B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID=B.MODEL_ID
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 신규로직 시작
	) AS LIST
	WHERE CHILD_ITEM_ID IS NOT NULL
	-- E20260907-000168 TactTime(OSP)에 등록대상으로 보이지 않는 사유 확인부탁드립니다. 신규로직 끝
	;
	-- E20260310-000552 Tact Time(OSP) 기준정보 설정 로직 변경신규로직 추가 끝



	-- E20260728-000548 Tact Time(OSP) 등록대상으로 생성하기 위해서있는 제약 확인 및 기능 보완 요청드립니다.
	-- 등록된 코드중 DEMAND GROUP MASTER 룩업과 PROJECT_CODE , ITEM_ID 앞 12자리가 같은 데이터를 추가 매핑한다.
	-- E20260728-000548 로직 시작
	INSERT INTO #TblDynamicPivot_SCP0020_TMP1
	SELECT
		  SEGMENT2	AS DIVISION_ID
		, SEGMENT3	AS ITEM_ID 
		, SEGMENT5	AS PROJECT_CODE
	FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL AS A WITH(NOLOCK)
	WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP' AND VALID_YN = 'Y'
	AND EXISTS
	(
		select * from #TblDynamicPivot_SCP0020_TMP1 AS B with(nolock)	
		WHERE A.SEGMENT2		= B.DIVISION_ID
		AND LEFT(A.SEGMENT3,12) = LEFT(B.ITEM_ID,12)
		AND A.SEGMENT5			= B.PROJECT_CODE
		AND A.SEGMENT3			<> B.ITEM_ID
	)
	;
	-- E20260728-000548 로직 끝

	
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


	SELECT A.DIVISION_ID
			, A.SITE_DESCRIPTION
			, A.ITEM_ID
			, A.NICK_NAME
			, A.LINE_ID
			, A.PRIORITY
			, A.YIELD
			, A.DAILY_CAPACITY
			, A.TACT_TIME
			, A.CREATED_BY
			, A.CREATION_DATE
			, A.LAST_UPDATED_BY
			, A.LAST_UPDATE_DATE
			, A.OPERATION_ID
			, A.PLANT_SITE_ID
			, A.INPUT_STATUS
			, A.operation_group_id
			, (CASE WHEN A.line_id IS NULL THEN '1' ELSE '2' END) AS line_order 
			, A.except_yn
			, A.OSP_YN
	FROM 
	(
		-- Tact Time OSP Master 조회
		SELECT A.DIVISION_ID
				, S.SITE_DESCRIPTION
				, A.ITEM_ID
				, (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-'  WHEN X.NICK_NAME = ''    THEN '-'  ELSE X.NICK_NAME END) 
				   FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID) AS NICK_NAME
				, A.LINE_ID
				, A.PRIORITY
				, ROUND(A.YIELD*100,2) AS YIELD
				, A.DAILY_CAPACITY
				, A.TACT_TIME
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
				, A.OPERATION_ID
				, A.PLANT_SITE_ID
				, 'M' AS INPUT_STATUS
				,dbo.fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id
				,isnull((select top 1 'Y'
							from SCP_MST_TACT_TIME_EXCEPT_OSP x 
							where x.division_id=a.division_id 
							and x.plant_site_id=a.plant_site_id 
							and x.operation_id=a.operation_id
							and x.item_id=a.item_id
							and x.line_id=a.line_id
							),'N') as except_yn
				, S.OSP_YN
		FROM SCP_MST_TACT_TIME_OSP A WITH(NOLOCK)
		JOIN SCM_MST_SITE S WITH(NOLOCK) ON S.DIVISION_ID=A.DIVISION_ID AND S.SCM_SITE_ID=A.PLANT_SITE_ID
		WHERE 1=1 
		AND a.division_id   =  @p_division_id
		AND ( ( @p_plant_site_id IS NULL OR  @p_plant_site_id = '' ) OR a.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )			
		AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')) )		
		UNION ALL
		-- Project Route 화면에 등록된 모델중 Tact Time Master에 없는 모델 조회
		SELECT DISTINCT
			a.division_id
			, b.SITE_DESCRIPTION
			, a.ITEM_ID
			, (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-'  WHEN X.NICK_NAME = ''    THEN '-'  ELSE X.NICK_NAME END) 
				   FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID) AS NICK_NAME
			, NULL as LINE_ID
			, NULL AS PRIORITY
			, NULL AS YIELD
			, NULL AS DAILY_CAPACITY
			, NULL AS TACT_TIME
			, NULL AS CREATED_BY
			, NULL AS CREATION_DATE
			, NULL AS LAST_UPDATED_BY
			, NULL AS LAST_UPDATE_DATE
			-- PJ20202001 : RACK 구분 추가
			, CASE WHEN ISNULL(C.ATTRIBUTE3,'N') = 'Y' THEN B.PLANT_ID + '_R1'
			       ELSE B.PLANT_ID
			  END           AS OPERATION_ID
			, A.PLANT_SITE_ID
			, 'I' AS INPUT_STATUS
			,dbo.fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id
			, 'N' AS except_yn
			, B.OSP_YN
		FROM scm_mst_site_item_priority a (NOLOCK)
		LEFT OUTER JOIN scm_mst_item_sn i (NOLOCK) ON a.division_id = i.division_id 
												AND a.item_id = i.item_id 
												AND i.site_id = ( select site_id from scm_mst_plant_sn s (NOLOCK) where s.division_id = a.division_id and s.plant_id = dbo.fn_scm_split(a.plant_site_id,1,'-') )
		JOIN SCM_MST_SITE b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id
		LEFT JOIN scp_mst_final_item C (NOLOCK) ON a.division_id = C.division_id and a.item_id = C.item_id --and C.fcst_yn = upper('Y')
		WHERE 1=1 
		AND a.valid_yn    = 'Y'
		AND b.osp_yn      = 'Y' -- 외주 packer
		and isnull(b.ATTRIBUTE1,'N') ='Y' --라인 대상
		AND NOT EXISTS ( select 'X' from SCP_MST_TACT_TIME_OSP n (NOLOCK) 
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
	) A
	WHERE 1=1
	AND A.operation_group_id = @p_operation_group_id
	AND ( ( @p_line_id IS NULL OR  @p_line_id = '' ) OR A.line_id    IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
	ORDER BY line_order, A.division_id, A.plant_site_id, A.line_id, A.item_id


	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0020_TMP') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0020_TMP

END

