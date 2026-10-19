

/*
 * Program ID   : FN_LINE_WORKINGTIME_BY_LOSS                                                              
 * Description  : 라인 별 Working Time (Loss Time 감안)
 * 실행 예제    : SELECT * FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS('40','20190603','20200531','')
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2019.06.04	YHW				[CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경
 * 2019.10.16	YHW				전극 'EE'일 시 조회 안되는 오류 수정
 * 2020.02.06	YHW				ESS 외주 Pakcer Line 생산 Target 적용
 * 2021.03.15   KSG             PJ20209642 Digital SCM Level.3 달성을 위한 개선 : Work Time 변경
 * 2022-03-23   KSG             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2022.04.29   sclee           PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가관련 @p_division_id NVARCHAR(2) -> NVARCHAR(10)으로 변경
 * 2023.03.23	hrkim			[PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 */
 
CREATE FUNCTION [dbo].[FN_LINE_WORKINGTIME_BY_LOSS]
(	
      -- PJ20216891 (sclee)
      -- @p_division_id		NVARCHAR(2)        
      @p_division_id		NVARCHAR(30)
	, @p_from_yyyymmdd		NVARCHAR(8)
    , @p_to_yyyymmdd		NVARCHAR(8)        
    , @p_line_id            NVARCHAR(MAX)        
)
RETURNS TABLE 
AS
RETURN 
(

	WITH target_division AS (
		-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		select distinct dt.division_id
		from scm_mst_division dm with(nolock)
			 inner join scm_mst_division dt with(nolock)
					 on dt.attribute4 = dm.attribute4 
					and dt.division_id = case when dm.attribute3 = 'EE'
											  then dt.division_id
											  else dm.division_id
										  end
					and dt.attribute3 != 'EE'
					and dt.valid_yn	   = 'Y'
		where 1=1
		  and dm.division_id = @p_division_id 
		  and dm.valid_yn	 = 'Y'
	)
	SELECT a.division_id, a.plant_site_id, a.operation_id, a.line_id, a.yyyymmdd
	 -- PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환 / Loss Time Except 생성 시 비율 적용되어 있음
     --   Daily Capa 사용 시 : 형교환 Loss만 반영
     --   Tact Time 사용 시 : 전체 Loss 반영
		,(
          CASE WHEN c.loss_start_date IS NOT NULL THEN a.working_time - ROUND(ISNULL(c.setup_loss_time_min, 0), 0, 1) 
               ELSE a.working_time - ROUND( (a.working_time_rate * ISNULL(b.setup_loss_time_min, 0)), 0, 1) 
          END  --capa_work_time
		) AS WORKING_TIME

	/*
		,(
			CASE LEFT(A.OPERATION_ID,1) WHEN 'E'  THEN
														CASE WHEN c.loss_start_date IS NOT NULL THEN a.working_time - ROUND( (a.working_time_rate * (ISNULL(c.loss_time_min, 0) + ISNULL(c.setup_loss_time_min, 0))), 0, 1) 
															ELSE a.working_time - ROUND( (a.working_time_rate * (ISNULL(b.loss_time_min, 0) + ISNULL(b.setup_loss_time_min, 0))), 0, 1) 
														END  --tact_work_time
			ELSE 
														CASE WHEN c.loss_start_date IS NOT NULL THEN a.working_time - ROUND( (a.working_time_rate *  ISNULL(c.setup_loss_time_min, 0)), 0, 1) 
															ELSE a.working_time - ROUND( (a.working_time_rate *  ISNULL(b.setup_loss_time_min, 0)), 0, 1) 
														END  -- capa_work_time
			END
		) AS WORKING_TIME
	*/
	FROM  (
			SELECT *
				,  working_time / 1440.0 AS working_time_rate
			FROM  scp_mst_working_time WITH (NOLOCK)
			--WHERE division_id = @p_division_id --'40' --20180709 주석처리
			) a
			-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
			INNER JOIN target_division dt  
				    ON dt.division_id = a.division_id 
			JOIN SCM_MST_SITE S ON S.DIVISION_ID=A.DIVISION_ID 
			AND S.SCM_SITE_ID=A.PLANT_SITE_ID 
			--ESS 외주 Pakcer Line 생산 Target 적용 : 외주가 아니거나 외주이면서 Line Capa 대상인 것
			--AND S.OSP_YN='N'
			AND (S.OSP_YN='N'
			     OR (S.OSP_YN='Y' AND ISNULL(S.ATTRIBUTE1,'N')='Y' AND A.LINE_ID<>'-')
				)
			LEFT JOIN ( SELECT *
						FROM   scp_mst_loss_time WITH (NOLOCK) --loss_time_min 값은 work time이 1440(=1일)분 기준으로 입력되어 있으므로 사용할때 [ ('work time' / 1440) * 'loss_time_min') ] 비율계산된 값으로사용해야 한다.   
						--WHERE  division_id = @p_division_id --'40' -- 20180709 주석처리
					) b
			ON   a.division_id   = b.division_id
			AND  a.plant_site_id = b.plant_site_id
			AND  a.factory_id    = b.factory_id
			AND  a.operation_id  = b.operation_id
			AND  a.line_id       = b.line_id 

			LEFT JOIN ( SELECT division_id, plant_site_id, factory_id, operation_id, line_id
							, loss_start_date, loss_end_date, loss_time_min, setup_loss_time_min
						FROM   scp_mst_loss_time_except WITH (NOLOCK) --loss_time_min 값은 work time이 1440(=1일)분 기준으로 입력되어 있으므로 사용할때 [ ('work time' / 1440) * 'loss_time_min') ] 비율계산된 값으로사용해야 한다.   
						--WHERE  division_id = @p_division_id --'40' -- 20180709 주석처리
					) c
			ON   a.division_id   = c.division_id
			AND  a.plant_site_id = c.plant_site_id
			AND  a.factory_id    = c.factory_id
			AND  a.operation_id  = c.operation_id
			AND  a.line_id       = c.line_id 
			AND  a.yyyymmdd      >= c.loss_start_date
			AND  a.yyyymmdd      <= c.loss_end_date
			--where (@p_division_id='EE' OR a.division_id=@p_division_id)--a.division_id  =  @p_division_id   20191016 수정
			-- where ( @p_division_id = 'EE' 
            --     OR  a.division_id  = @p_division_id
            --     OR (@p_division_id = 'EE_UC' AND a.division_id = '81_UC') -- 20220323 PJ20216891 GM JV 추가
            --       )
			where 1=1
            
			AND  a.yyyymmdd      >= @p_from_yyyymmdd
			AND  a.yyyymmdd      <= @p_to_yyyymmdd
			AND ( ( @p_line_id IS NULL OR @p_line_id ='') OR a.line_id IN (SELECT token FROM dbo.String_Split(@p_line_id,',')) )
	UNION 
	SELECT A.DIVISION_ID
		,A.PLANT_SITE_ID
		,A.OPERATION_ID
		,A.LINE_ID
		,A.YYYYMMDD 
		,( SELECT ISNULL(SUM(ISNULL(C.DAILY_CAPA_QTY,0)),0)
			FROM  SCP_MST_OUTSOURCING_CAPA  C WITH(NOLOCK)
			WHERE C.DIVISION_ID   = A.DIVISION_ID
			AND   C.PLANT_SITE_ID = A.PLANT_SITE_ID
			AND   C.ITEM_ID       = '-' 
		) AS WORKING_TIME
	FROM  (
			SELECT w.*
				 , w.working_time / 1440.0 AS working_time_rate
			FROM   scp_mst_working_time W WITH (NOLOCK)
					-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
					INNER JOIN target_division dt  
							ON dt.division_id = w.division_id 
				 , scm_mst_site         s with (nolock)
			--WHERE (@p_division_id='EE' OR w.division_id=@p_division_id) --w.division_id = @p_division_id   20191016 수정
            --where ( @p_division_id = 'EE' 
            --    OR  w.division_id  = @p_division_id
            --    OR (@p_division_id = 'EE_UC' AND w.division_id = '81_UC') -- 20220323 PJ20216891 GM JV 추가
            --      )
			where 1=1

			AND    w.division_id = s.division_id
			AND    w.plant_site_id = s.scm_site_id
			--ESS 외주 Pakcer Line 생산 Target 적용 : 외주이면서 Line Capa 대상이 아닌 것 + 외주이면서 Line Capa 대상이나 Line명이 '-' 인것(과거데이터 조회용)
			--AND    s.osp_yn      = 'Y'
			AND    s.osp_yn      = 'Y'
			AND   (ISNULL(S.ATTRIBUTE1,'N') IN ('','N') OR W.LINE_ID='-')
			) a
	WHERE 1=1
		AND A.YYYYMMDD >= @p_from_yyyymmdd
		AND A.YYYYMMDD <= @p_to_yyyymmdd

)

