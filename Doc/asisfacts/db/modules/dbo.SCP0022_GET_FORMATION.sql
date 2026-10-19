
/*
 * Program ID   : SCP0022_GET_Formation
 * Description  : Formation
 * Program History
 *===================================================================================================
 *   Date       In Charge		                    Description
 *===================================================================================================
 * 2018/03/26   kyh				                    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/17   byunghunjung	                    전극 제외
 * 2018/06/18	KYH				                    신규 컬럼 추가. Formation Add LT (Days)
 * 2018/08/08   byunghunjung	                    item_id 2번째 자리가 C인 모델만 검색
 * 2019/04/08	hwyoon			                    [CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2019/04/11	AYJ				                    SSP_MODIFY_YIELD 컬럼 추가
 * 2019/05/10	hwyoon			                    [CSR ID:3991073] [긴급] Formation Active 모델 모두 표시 및 SSP Model PIC 정보 컬럼 추가
 * 2019/10/30	hwyoon			                    Project Route 등록여부와 관계없이 기존 입력된 수율 전체 조회
 * 2020/04/03	hwyoon			                    [C20200403-000212] Item 다중입력 조회 오류 개선 nvarchar(50) 제거
 * 2020/04/07	hwyoon			                    [C20200407-000179] CNB H5.5A 특성 실적 시스템 미반영 관련 문의의 건 - Plant 매개변수 nvarchar(30) 제거
 * 2023/09/05   chaan		            V1.1.3      PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2             -  CA1 모델만 조회되게 수정
*/

CREATE PROCEDURE [dbo].[SCP0022_GET_FORMATION]
	  @p_division_id			NVARCHAR(30)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	--DECLARE @p_division_id			NVARCHAR(30)        = N'81';
	--DECLARE @p_plant_site_id		NVARCHAR(MAX)       = N'';
	--DECLARE @p_item_id				NVARCHAR(MAX)       = N'';



	SELECT	  A.DIVISION_ID
			, A.PLANT_SITE_ID
			, A.PLANT_SITE_NAME
			, A.ITEM_ID
			, A.NICK_NAME
			, A.LT_FORMATION
			, A.ADD_LT_FORMATION
			, A.FORMATION_YIELD
			, A.CHAR_YIELD
			, A.FORMATION_TOTAL_YIELD
			, A.SSP_MODIFY_YIELD
			, A.CREATED_BY
			, A.CREATION_DATE
			, A.LAST_UPDATED_BY
			, A.LAST_UPDATE_DATE
			, A.FORMATION_ORDER
			, A.SHIPMENT_PIC_USER
	FROM	(
				-- 입력대상 (Project Route입력 아이템)
				SELECT DISTINCT
						  M.DIVISION_ID
						, M.PLANT_SITE_ID
						, dbo.FN_GET_SCM_SITE_DESCRIPTION (M.DIVISION_ID, M.PLANT_SITE_ID )				AS PLANT_SITE_NAME
						, M.ITEM_ID
						, M.NICK_NAME
						, N.LT_FORMATION
						, ISNULL(N.ATTRIBUTE1, 0)														AS ADD_LT_FORMATION
						, ROUND(N.FORMATION_YIELD * 100, 2)												AS FORMATION_YIELD
						, ROUND(N.CHAR_YIELD * 100, 2)													AS CHAR_YIELD
						, ROUND(N.FORMATION_TOTAL_YIELD * 100, 2) 										AS FORMATION_TOTAL_YIELD
						, ROUND(N.SSP_MODIFY_YIELD * 100, 2)											AS SSP_MODIFY_YIELD
						, N.CREATED_BY
						, N.CREATION_DATE
						, N.LAST_UPDATED_BY
						, N.LAST_UPDATE_DATE
						, '1' AS FORMATION_ORDER
						, CASE WHEN S.USER_NAME IS NULL THEN '' ELSE S.USER_NAME+'('+U.USER_ID+')' END	AS SHIPMENT_PIC_USER
				FROM	(
							SELECT	  A.DIVISION_ID
									, D.PLANT_SITE_ID
									, A.ITEM_ID
									, dbo.FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)				AS NICK_NAME
							FROM	SCM_MST_ITEM_SN A (NOLOCK)
									INNER JOIN SCP_MST_FINAL_ITEM I (NOLOCK) ON
											A.DIVISION_ID			= I.DIVISION_ID
										AND A.ITEM_ID				= I.ITEM_ID
										AND I.ATTRIBUTE8			= 'CA1'
									INNER JOIN SCM_MST_SITE_ITEM B (NOLOCK) ON
											A.DIVISION_ID			= B.DIVISION_ID
										AND A.ITEM_ID				= B.ITEM_ID
									INNER JOIN SCM_MST_SITE_ITEM_PRIORITY D (NOLOCK) ON
											A.DIVISION_ID			= D.DIVISION_ID
										AND A.ITEM_ID				= D.ITEM_ID
										AND B.SCM_SITE_ID			= D.PLANT_SITE_ID
										AND B.PROJECT_CODE			= D.PROJECT_CODE
									INNER JOIN SCM_MST_FINAL_ITEM_V V (NOLOCK) ON
											A.DIVISION_ID			= V.DIVISION_ID
										AND B.ITEM_ID				= V.ITEM_ID
										AND V.OPERATION_GROUP_ID	= 'A'
							WHERE	1=1
								AND D.VALID_YN = 'Y'
								--전극 제외
								AND V.OPERATION_GROUP_ID <> 'E'
								AND ((@p_division_id   IS NULL OR  @p_division_id   = '') OR a.division_id   IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')))
								AND ((@p_plant_site_id IS NULL OR  @p_plant_site_id = '') OR d.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')))
								And ((@p_item_id       IS NULL OR  @p_item_id = '')       OR a.item_id       IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')))
						) M
						LEFT JOIN SCP_MST_FORMATION N (NOLOCK) ON
								M.DIVISION_ID   = N.DIVISION_ID
							AND M.PLANT_SITE_ID = N.PLANT_SITE_ID
							AND M.ITEM_ID       = N.ITEM_ID
						LEFT JOIN SSP_MST_MODEL_USER U (NOLOCK) ON
								U.DIVISION_ID	= M.DIVISION_ID
							AND U.FROM_SITE		= M.PLANT_SITE_ID
							AND U.ITEM_ID		= M.ITEM_ID
							AND U.VALID_YN		= 'Y'
						LEFT JOIN SCM_MST_SSO_USER_INFO S (NOLOCK) ON
								S.USER_ID = U.USER_ID
				WHERE	1=1
					AND N.LT_FORMATION IS NULL
				UNION
		-- 입력대상 (Project Route입력 아이템)
				SELECT DISTINCT
						  N.DIVISION_ID
						, N.PLANT_SITE_ID
						, dbo.FN_GET_SCM_SITE_DESCRIPTION (N.DIVISION_ID, N.PLANT_SITE_ID )				AS PLANT_SITE_NAME
						, N.ITEM_ID
						, DBO.FN_GET_ITEM_NICKNAME(N.DIVISION_ID, N.ITEM_ID)							AS NICK_NAME
						, N.LT_FORMATION
						, ISNULL(N.ATTRIBUTE1, 0)														AS ADD_LT_FORMATION
						, ROUND(N.FORMATION_YIELD * 100, 2)												AS FORMATION_YIELD
						, ROUND(N.CHAR_YIELD * 100, 2)													AS CHAR_YIELD
						, ROUND(N.FORMATION_TOTAL_YIELD * 100, 2)										AS FORMATION_TOTAL_YIELD
						, ROUND(N.SSP_MODIFY_YIELD * 100, 2)											AS SSP_MODIFY_YIELD
						, N.CREATED_BY
						, N.CREATION_DATE
						, N.LAST_UPDATED_BY
						, N.LAST_UPDATE_DATE
						, '2'																			AS FORMATION_ORDER
						, CASE WHEN S.USER_NAME IS NULL THEN '' ELSE S.USER_NAME+'('+U.USER_ID+')' END	AS SHIPMENT_PIC_USER
				FROM	SCP_MST_FORMATION N (NOLOCK)  --ON M.DIVISION_ID   = N.DIVISION_ID
				--AND M.PLANT_SITE_ID = N.PLANT_SITE_ID
				--AND M.ITEM_ID       = N.ITEM_ID
						INNER JOIN SCP_MST_FINAL_ITEM I (NOLOCK) ON
								N.DIVISION_ID			= I.DIVISION_ID
							AND N.ITEM_ID				= I.ITEM_ID
							AND I.ATTRIBUTE8			= 'CA1'
						LEFT JOIN SSP_MST_MODEL_USER U (NOLOCK) ON
								U.DIVISION_ID	= N.DIVISION_ID
							AND U.FROM_SITE		= N.PLANT_SITE_ID
							AND U.ITEM_ID		= N.ITEM_ID
							AND U.VALID_YN		= 'Y'
						LEFT JOIN SCM_MST_SSO_USER_INFO S (NOLOCK) ON
								S.USER_ID = U.USER_ID
				WHERE	1=1
					AND ((@p_division_id   IS NULL OR  @p_division_id   = '') OR n.division_id   IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')))
					AND ((@p_plant_site_id IS NULL OR  @p_plant_site_id = '') OR n.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')))
					And ((@p_item_id IS NULL       OR  @p_item_id = '')       OR n.item_id       IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')))
			) A
	WHERE	1=1
	ORDER BY A.FORMATION_ORDER, A.DIVISION_ID , A.PLANT_SITE_ID, A.ITEM_ID;
END
