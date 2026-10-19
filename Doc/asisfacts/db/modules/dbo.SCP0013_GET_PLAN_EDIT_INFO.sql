
/*
 * Program ID   : SCP0013_GET_PLAN_EDIT_INFO
 * Description  : PLAN 별 편집가능 여부 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/14   PJS    			Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/21   PJS             PR 수정모드 조건 변경
 * 2018/06/01   PJS             PLAN 시작일 가져오는 조건 변경
 * 2018/06/07   PJS             MA일 경우 FP운용기간-7일 처리
 * 2018/07/16   YHW				ITEM_TYPE 조회조건 추가, 에디트 모드 조회
 * 2019/01/25   YHW				[PS02199094B] [전지 GSCM 대응 및 고도화] Split 함수 변경, WITH(NOLOCK) 추가
 * 2019/04/17   YHW				[CSR ID:3976849] Production Plan Line 조회 내부로직 개선 - Split 교체 FN_SplitString -> String_Split (100개 넘는 라인 파라미터의 경우 오류)
 * 2019/06/27	YHW				[CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경 - 소형 일 시 FP 확정구간 제외
 * 2019/07/18	YHW				오류 선조치 - Item 조회 시 공백 제거함수 사용
 * 2019/08/16	YHW				[CSR ID:4065777] Production Plan Line 개선 - 과거실적 구간 Fix/Unfix 방지(내부개선 건)
 *                              오류 선조치 - 본 테이블 조회->Plant Site 조회로 변경(Engine Planning시 쿼리 로딩지연 방지)
 * 2020/10/28   khj79           [C20201019-000175] 자동차(81) 사업부의 경우 Final Plan 제외하고 전 구간 생산계획 수정 가능
 * 2021/10/13   khj79			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 82(ESS) 'MA' 플랜 전 구간 수정 가능
 * 2022/05/11   chaan			site 서브쿼리에 EE_UC 추가
 * 2023/03/10   LWY             PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 생산계획 업무이관 연계 시스템 변경 대응 (특정구간 Locking 해제)
 * 2023/04/10   LWY				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023/05/03   LWY			    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 81 / SE : PROD_FROZEN 구간 EDIT 불가 적용
 * ex)
  EXEC [SCP0013_GET_PLAN_EDIT_INFO] 
    @p_division_id='81'
  , @p_operation_group='P'
  , @p_scm_site_id=''
  , @p_line_id='A1A09,-,A1A02,A1A02,A1A02-1,A1A02-2,A1A03,A1A03,A1A04,A1A04,A1A05,A1A05,A1A06,A1A06,A1A07,A1A07,A1A08,A1A08,A1A09,A1AP1,A1AP1,A1AP2,A1AP2,A1AV1,A2A10,A2A10,A2A11,A2A11,A2A13,A2A13,A2A14,A2A14,A2AP3,A2AV1,A2AV1,A3A01,A3A01,A3A02,A3A02,A3A03,A3A03,A3A04,A3A04,A3AV1,A4A01,A4A01,A4A01,A4A02,A4A02,A4A02,A4A03,A4A03,A4A03,A4A04,A4A04,A4A04,A4A05,A4A05,A4AV1,A4AV2,A4AV3,A5A01,A5A01,A5A02,A5A02,A5AV1,P1Q02,P1Q03,P1QP1,P1QP2,P1QP3,P2Q04,P2Q11,P2Q11,P4Q01,P4Q01,P4Q02,P4Q02,P4Q03,P4Q03,P4Q04,P4Q04,P4Q06,P4Q06,P4Q07,P4Q07,P5Q01,P5Q01,P5Q02,P5Q02,P5Q03,P5Q03,P6Q07,P6Q08,P6Q09,P6Q10,P6Q12,P7Q01,P7Q01,P7Q02,P7Q02,P7Q03,P7Q03,P7Q04,P7Q04,P7Q05,P7Q05,P7Q06'
  , @p_item_id=''
  , @p_from_yyyymmdd='20180430'
  , @p_to_yyyymmdd='20181104'
  , @p_plan_start_yyyymmdd='20180430'
  , @p_plan_type='FN'
  , @p_seq='1'

  EXEC SCP0013_GET_PLAN_EDIT_INFO @p_division_id='82', @p_operation_group='P', @p_scm_site_id='', @p_line_id='-', @p_item_id='', @p_from_yyyymmdd='20180507', @p_to_yyyymmdd='20181111', @p_plan_start_yyyymmdd='20180507', @p_plan_type='MA', @p_seq='5', @debug_mode='F'

 */

CREATE PROCEDURE [dbo].[SCP0013_GET_PLAN_EDIT_INFO] 
	 @p_division_id		NVARCHAR(50) 
	,@p_operation_group	NVARCHAR(50) 
	,@p_scm_site_id		NVARCHAR(MAX) 
	,@p_line_id			NVARCHAR(MAX) 
	,@p_item_id			NVARCHAR(MAX) 
	,@p_from_yyyymmdd	NVARCHAR(8)
    ,@p_to_yyyymmdd		NVARCHAR(8)
	,@p_plan_start_yyyymmdd  NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_seq					NVARCHAR(50)
    ,@debug_mode			NVARCHAR(20)  ='F'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_plan_version NVARCHAR(100)

	SELECT  DISTINCT
			division_id+scm_site_id+plan_name+plan_type+convert(varchar,plan_seq) as cp_key
	      , division_id
		  , scm_site_id
		  , plan_version_id
		  , plan_name AS plan_start_yyyymmdd
		  , plan_type
		  , plan_seq
		  , osp_yn
		  , fp_plan_period
		  , offset
		  , CONVERT(VARCHAR, CONVERT(DATETIME, plan_name )+offset,112) AS edit_start_date
		  , CASE plan_type WHEN 'PR' THEN 0 WHEN 'MA' THEN 1 WHEN 'SE' THEN 3 WHEN 'FI' THEN 4 ELSE 9 END AS plan_type_order
		  , confirm_yn
		  , CASE WHEN plan_name<basis_start_date THEN 'N' ELSE 'Y' END AS date_chk
		  , CASE WHEN plan_type ='MA' AND confirm_yn='Y' AND plan_name >=basis_start_date THEN 'Y'
			     WHEN plan_type ='SE' AND plan_name>=basis_start_date  THEN 'Y'
				 WHEN plan_type ='PR' AND plan_name>=basis_start_date  THEN 'Y'   
				 ELSE 'N'
			END AS is_editable
		  --, ISNULL(new_edit_mode,'N') new_edit_mode
		  --, CASE WHEN plan_name >=basis_start_date AND ISNULL(new_edit_mode,'N')='Y' THEN 'Y' ELSE 'N' END AS new_edit_mode
		  , 'Y' AS new_edit_mode
	FROM (
		
		SELECT m.division_id
		      ,m.plan_version_id
			  ,m.plan_name
			  ,m.plan_seq
			  ,m.plan_type
			  ,m.confirm_yn
			  ,n.SCM_SITE_ID
			  ,p.osp_yn
			  ,p.fp_plan_period
			  
			  -- 2023/03/10 : 전구간 Locking 해제
			  --,CASE WHEN m.plan_type ='PR' THEN 0
					--WHEN m.division_id = '40' THEN 0
					--WHEN M.DIVISION_ID = '81' THEN 0 -- [C20201019-000175] 자동차 전구간 수정
					----WHEN m.plan_type ='MA' THEN p.offset -7
					---- 2021.10.13 : 82(ESS) MA 전구간 수정
					--WHEN M.DIVISION_ID = '82' AND M.PLAN_TYPE  = 'MA' THEN 0
					--ELSE p.offset 			  
			  -- END  as offset

			  -- 2023/05/03
			  -- 2023/03/10 : 전구간 Locking 해제
			  --, 0 as offset
			  , CASE WHEN m.division_id = '81' AND m.plan_type ='SE' THEN p.prod_frozen else 0 end as offset
			  
			  
			  --,'20180501' basis_start_date
			  ,m.basis_start_date
			  ,case when q.TYPE_SORT=q.SEARCH_TYPE_SORT and q.PLAN_STATUS=-1 then 'Y'  else 'N' end new_edit_mode
		  FROM (
				select *
				  from(
						SELECT  d.division_id
								,p.plan_name+'-'+d.plan_type+'-'+ dbo.fn_zero_lpad(CONVERT(NVARCHAR,d.plan_seq),2)  AS plan_version_id
								,p.plan_name
								,d.plan_seq
								,d.plan_type	
								,CASE WHEN ISNULL(d.CONFIRM_FLAG,'')='' THEN 'N' ELSE d.CONFIRM_FLAG END AS confirm_yn			   
							FROM scm_mst_plan_detail d WITH(NOLOCK),
								 scm_mst_plan        p WITH(NOLOCK),
								 scm_mst_modeling    m WITH(NOLOCK)
							WHERE 1=1
							and m.modeling_id = d.modeling_id
							and m.plan_cycle  = 'WEEKLY'
							and m.division_id = d.division_id
							and m.modeling_id = d.modeling_id
							and p.division_id = d.division_id
							and p.plan_cycle  = m.plan_cycle
							and p.plan_id     = d.plan_id	
							and plan_name     >= dbo.fn_get_bucket_yyyymmdd(-10) --10주전
							and d.division_id = @p_division_id
							and d.plan_type   = @p_plan_type
							and d.plan_seq    = @p_seq
							and p.plan_name   = @p_plan_start_yyyymmdd
						) a
						CROSS JOIN (
									SELECT convert(VARCHAR(8), dateadd(dd, -(dayofweek_no-1),basis_yyyymmDD),112) as basis_start_date
									 FROM (
											SELECT (CASE WHEN DAYOFWEEK_NO -1 =0 THEN 7 ELSE dayofweek_no -1 END ) dayofweek_no ,CONVERT(DATETIME, basis_yyyymmDD) as basis_yyyymmDD,DAYOFWEEK
											  FROM scm_sys_calendar_m 
											 WHERE basis_yyyymmdd =convert(VARCHAR(8), GETDATE(),112)
  										  ) f						
									) b
			) m
			INNER JOIN scm_mst_site n with(nolock) ON n.site_type='PLANT'
												   AND n.operation_group=@p_operation_group
												   AND n.valid_yn='Y'
												   --chaan AND (@p_division_id='EE' or n.division_id=@p_division_id)
												   --AND (@p_division_id='EE' or @p_division_id='EE_UC' or n.division_id=@p_division_id) --chaan												   
												   AND (@p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) or n.division_id=@p_division_id) --div_commonization

												   AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR n.scm_site_id     IN (SELECT Value FROM dbo.FN_SplitString(@p_scm_site_id,',')) )
			/*
			INNER JOIN scp_anl_production_plan n WITH(NOLOCK) ON m.division_id = n.division_id
											  AND m.plan_name     = n.plan_start_yyyymmdd
											  AND m.plan_type     = n.plan_type
											  AND m.plan_seq      = n.seq
								  			  AND n.line_id			     <> '*'
											  AND n.measure              = upper('PROD_PLAN_AMEND')
											  --AND n.yyyymmdd			 >= @p_from_yyyymmdd
											  --AND n.yyyymmdd			 <= @p_to_yyyymmdd		
											  AND n.yyyymmdd			 = @p_plan_start_yyyymmdd		
											  AND n.division_id	         = @p_division_id
											  AND n.operation_group      = @p_operation_group
											  AND n.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
											  AND n.plan_type            = @p_plan_type
											  AND n.seq				   = @p_seq	
											  AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR n.scm_site_id     IN (SELECT Value FROM dbo.FN_SplitString(@p_scm_site_id,',')) )
											  AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR n.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
											  AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR n.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
											  */
			LEFT OUTER JOIN (SELECT division_id
								   ,scm_site_id
								   ,osp_yn
								   ,fp_plan_period 
								   ,CASE WHEN osp_yn ='Y' THEN 0 ELSE fp_plan_period END AS offset

								   ,prod_frozen -- 2023/05/03

							FROM scm_mst_site
							--WHERE division_id = @p_division_id
						) p ON --n.ORIGIN_DIVISION_ID = p.division_id--n.division_id = p.division_id
						       n.division_id = p.division_id
						   AND n.scm_site_id = p.scm_site_id
			, (
				SELECT  TOP 1 
					p.plan_name
					,d.plan_seq
					,d.plan_type	
					,d.PLAN_STATUS
					, case when d.plan_type='PR' THEN 1
							when d.plan_type='MA' THEN 2
							when d.plan_type='SE' THEN 3
							when d.plan_type='FN' THEN 4
						END TYPE_SORT
					, case when @p_plan_type='PR' THEN 2
							when @p_plan_type='MA' THEN 3
							when @p_plan_type='SE' THEN 4
							when @p_plan_type='FN' THEN 5
						END SEARCH_TYPE_SORT
				FROM scm_mst_plan_detail d WITH(NOLOCK),
						scm_mst_plan        p WITH(NOLOCK)
				WHERE 1=1
				and p.division_id = d.division_id
				and p.plan_cycle  = 'WEEKLY'
				and p.plan_id     = d.plan_id	
				and d.division_id = @p_division_id
				and p.plan_name   = @p_plan_start_yyyymmdd
				ORDER BY TYPE_SORT DESC, PLAN_SEQ DESC
			) Q
      ) L
END
  
