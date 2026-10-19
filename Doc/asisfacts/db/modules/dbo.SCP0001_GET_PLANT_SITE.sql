
/*
 * Program ID   : SCP0001_GET_PLANT_SITE
 * Description  : Plant 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/05   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/01/15   younggonkim    site_description 컬럼 scm_site_id -> site_description 으로 수정
 * 2018/04/30   ygkim			logistic_plant_id 컬럼 추가
 * 2018/07/02   ygkim			packer_item_id_suffix 컬럼 추가
 * 2018/09/14   ygkim			hq_vendor_code, hq_vendor_code_name 컬럼 추가
 * 2020/01/22	hwyoon			[C20200116-000114] ESS 외주 Packer Line 계획 수립 - PACKER_LINE_ACTIVE_YN 추가
 * 2020/03/26	hwyoon			[C20200324-000459] [긴급] Warranty Plant Ship Frozen 설정 불가
 * 2022/04/07	lwy			    PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - GSCM_VENDOR 컬럼추가
 * 2022/04/25	lwy			    PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 사내, 사외 분리적용
 * 2024/04/29	hsbang20        SSP용 frozen_type,ssp_ship_frozen  컬럼(attribute6,attribute7)생성
 * 2025/11/07   kimcd           [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                              JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9, Site Description 조회 추가
 */

CREATE PROCEDURE [dbo].[SCP0001_GET_PLANT_SITE]
  @p_division_id    NVARCHAR(MAX),
  @p_plant_id		NVARCHAR(MAX),
  @p_scm_site_id    NVARCHAR(MAX),    
  @p_osp_yn			NVARCHAR(MAX),
  @p_valid_yn		NVARCHAR(MAX),
  @p_new_yn			NVARCHAR(MAX)
AS
BEGIN
	
	SELECT *
	FROM(
			SELECT 
				 s.division_id
				,d.division_name
				,s.osp_yn
				,s.plant_id
				--[C20200324-000459] [긴급] Warranty Plant Ship Frozen 설정 불가
				,(CASE	WHEN s.operation_group = 'W' THEN s.plant_id
						WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) plant_name
				,s.operation_group
				,s.scm_site_id
				,s.site_description as site_description
				,s.hq_vendor_code
				,(CASE WHEN P2.PLANT_NAME IS NULL THEN V2.VENDOR_NAME ELSE P2.PLANT_NAME END) hq_vendor_code_name
								
				 --2022/04/07
				--, CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END)
				--  ELSE v.ATTRIBUTE1 END AS SCM_VENDOR_NAME
							
                -- 2022/04/25
				, CASE WHEN s.osp_yn = 'Y' THEN CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE v.ATTRIBUTE1 END
				       WHEN s.osp_yn = 'N' THEN CASE WHEN SN.DESCRIPTION IS NULL THEN (CASE	WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE SN.DESCRIPTION END
				  END AS SCM_VENDOR_NAME

				,s.country
				,s.CITY
				,s.ship_frozen
				,s.prod_frozen
				,s.fp_plan_period		
				,s.build_ahead
				,s.valid_yn
				,s.new_yn
				,s.created_by
				,s.creation_date
				,s.last_updated_by
				,s.last_update_date
				,s.company_id
				,s.logistic_plant_id
				,s.packer_item_id_suffix
				,s.attribute1 AS PACKER_LINE_ACTIVE_YN
				/*hsbang20, SSP용 frozen_type,ssp_ship_frozen  컬럼(attribute6,attribute7)생성*/
				,s.attribute6 AS frozen_type
				,s.attribute7 AS ssp_ship_frozen
				,S.ATTRIBUTE9 AS LINK_PLANT_SITE_CODE -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 실제 Link scm site id 추가
				,MS.SITE_DESCRIPTION  AS LINK_PLANT_SITE -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 실제 Link Site Description 추가
			FROM SCM_MST_SITE S(NOLOCK)
			JOIN SCM_MST_DIVISION D(NOLOCK) ON  s.division_id = d.division_id	
			LEFT OUTER JOIN SCM_MST_PLANT_SN P(NOLOCK) ON  S.COMPANY_ID = P.COMPANY_ID AND S.DIVISION_ID = P.DIVISION_ID AND S.PLANT_ID = P.PLANT_ID
			LEFT OUTER JOIN  SCM_MST_VENDOR V  WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID AND S.COMPANY_ID = V.COMPANY_ID
			LEFT OUTER JOIN SCM_MST_PLANT_SN P2(NOLOCK) ON  S.COMPANY_ID = P2.COMPANY_ID AND S.DIVISION_ID = P2.DIVISION_ID AND S.hq_vendor_code = P2.PLANT_ID
			LEFT OUTER JOIN  SCM_MST_VENDOR V2  WITH(NOLOCK) ON V2.VENDOR_CODE = S.hq_vendor_code AND S.COMPANY_ID = V2.COMPANY_ID

			-- 2022/04/25
			LEFT OUTER JOIN  SCM_PLANT_M_SN SN WITH(NOLOCK) ON S.DIVISION_ID = SN.DIVISION_ID AND S.PLANT_ID =SN.PLANT_ID
			LEFT OUTER JOIN  SCM_MST_SITE MS WITH(NOLOCK) ON MS.SCM_SITE_ID = S.ATTRIBUTE9 AND MS.OPERATION_GROUP = S.OPERATION_GROUP
			 -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 실제 Link scm site id 값을 ATTRIBUTE9, Site Description 조회 추가
			WHERE s.site_type = 'PLANT'
			AND (@p_division_id IS NULL OR S.DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@p_division_id,',') ) )
			AND (@p_osp_yn IS NULL OR S.OSP_YN = @p_osp_yn)
			AND (@p_valid_yn IS NULL OR S.VALID_YN = @p_valid_yn)
			AND (@p_new_yn IS NULL OR S.NEW_YN = @p_new_yn)	
	) A
	WHERE 1=1
	  AND ((@p_plant_id IS NULL OR @p_plant_id = '') OR (plant_id like '%' + @p_plant_id + '%' OR plant_name like '%' + @p_plant_id + '%'))
	  AND ((@p_scm_site_id IS NULL OR @p_scm_site_id = '') OR (scm_site_id like '%' + @p_scm_site_id + '%' OR site_description like '%' + @p_scm_site_id + '%'))
	ORDER BY A.division_name, A.plant_id, A.scm_site_id
   ;
END

