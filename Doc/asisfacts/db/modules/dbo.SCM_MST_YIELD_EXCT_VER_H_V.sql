





CREATE VIEW [dbo].[SCM_MST_YIELD_EXCT_VER_H_V]
 AS
/*
 * Program ID   : SCM_MST_YIELD_EXCT_VER_H_V
 * Description  : SCP Yield Except 용 View : FP 최신 Version 정보 사용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.03.12   KSG            Initial Release PJ20209642 Digital SCM Level.3 달성을 위한 개선
 * 2022.03.29   KSG            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
 * 2023-04-03   HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */
        
WITH MASTER_VERSION AS
(
		SELECT DISTINCT division_id, operation_id, version_id
        FROM (
              SELECT v.division_id, r.operation_id, MAX(v.version_id) AS version_id
              FROM   scm_master_version_info_h_sn v WITH(NOLOCK)
				     inner join scm_mst_division d with(nolock)	 -- PJ20230691R HM JV 가상 사업부 추가 대응
							 on d.division_id = v.division_id 
							and d.attribute3 != 'EE'
							and d.valid_yn	  = 'Y'
                   , scm_mst_operation_sn r WITH(NOLOCK)
              WHERE  1=1
              -- HM JV AND    v.division_id        IN ('40', '81', '82', '81_UC') -- 전극 별도 버전 존재함   -- 20220329 PJ20216891 GM JV 가상 Division 추가
              AND    v.scp_use_flag       = 'Y'
              AND    SUBSTRING(r.operation_id, 1, 1) NOT IN ('E', 'S')
              GROUP BY v.division_id, r.operation_id

		      UNION 
              -- 전극은 하나의 version으로 존재하나 실제 Data는 사업부별로 존재함
			  -- PJ20230691R HM JV 가상 사업부 추가 대응
              SELECT d.division_id, r.operation_id, MAX(v.version_id) AS version_id
              FROM   scm_master_version_info_h_sn v WITH(NOLOCK)
				     inner join scm_mst_division dm with(nolock)  
					 		 on dm.division_id = v.division_id
							and dm.valid_yn	  = 'Y'
					 inner join scm_mst_division d with(nolock)
							 on d.attribute4 = dm.attribute4
							and d.attribute3 != 'EE'
							and d.valid_yn	  = 'Y'
                   , scm_mst_operation_sn r WITH(NOLOCK)
              WHERE  1=1
			    AND  dm.attribute3 = 'EE' 
                AND  v.scp_use_flag       = 'Y'
                AND  SUBSTRING(r.operation_id, 1, 1) IN ('E', 'S')
              GROUP BY d.division_id, r.operation_id

			  /* PJ20230691R HM JV 2023.04.03 주석처리 (EE와 JV EE 쿼리 하나로 통합) 
		      UNION 
              -- 전극은 하나의 version으로 존재하나 실제 Data는 사업부별로 존재함
              SELECT d.division_id, r.operation_id, MAX(v.version_id) AS version_id
              FROM   scm_master_version_info_h_sn v WITH(NOLOCK)
                   , scm_mst_operation_sn r WITH(NOLOCK)
                   , scm_mst_division d WITH(NOLOCK) 
              WHERE  1=1
              AND    v.division_id        = 'EE' -- 전극 별도 버전 존재함
			  AND	 d.attribute3		 != 'EE'
			  AND	 d.attribute4		  = 'LG'
              -- HM JV AND    d.division_id        IN ('40', '81', '82')
              AND    v.scp_use_flag       = 'Y'
              AND    SUBSTRING(r.operation_id, 1, 1) IN ('E', 'S')
              GROUP BY d.division_id, r.operation_id

		      UNION 
			  -- 20220329 PJ20216891 GM JV 가상 Division 추가
              -- 전극은 하나의 version으로 존재하나 실제 Data는 사업부별로 존재함
              SELECT d.division_id, r.operation_id, MAX(v.version_id) AS version_id
              FROM   scm_master_version_info_h_sn v WITH(NOLOCK)
                   , scm_mst_operation_sn r WITH(NOLOCK)
                   , scm_mst_division d WITH(NOLOCK)
              WHERE  1=1
              AND    v.division_id        = 'EE_UC' -- 전극 별도 버전 존재함
              AND    d.division_id        = '81_UC'
              AND    v.scp_use_flag       = 'Y'
              AND    SUBSTRING(r.operation_id, 1, 1) IN ('E', 'S')
              GROUP BY d.division_id, r.operation_id
			  */
             ) a
)

       SELECT tt.version_id, tt.division_id, tt.company_id, tt.site_id, tt.plant_id, tt.factory_id
            , tt.plant_id + '-' + tt.operation_group_id AS plant_site_id
            , tt.item_id, tt.operation_id, tt.line_id, tt.start_time, tt.end_time
             , MAX(ISNULL(tt.yield, 0)) AS yield

        FROM  (
                         SELECT t.version_id, t.division_id, t.company_id, t.site_id, t.plant_id, t.factory_id
                              , CASE WHEN SUBSTRING(t.operation_id, 1, 1) IN ('E', 'S')      THEN 'E'
                                     WHEN SUBSTRING(t.operation_id, 1, 1) IN ('A', 'B', 'F') THEN 'A'
                                     WHEN SUBSTRING(t.operation_id, 1, 1) IN ('P')           THEN 'P'
                                     ELSE 'A'
                                END AS operation_group_id

                              , t.item_id, t.operation_id, t.line_id
                              , CONVERT(CHAR(8), t.start_time, 112) AS start_time
                              , CONVERT(CHAR(8), t.end_time, 112)   AS end_time
                              , CONVERT(CHAR(6), t.end_time, 112)   AS month  -- FP Except 는 전부 일별로 존재함
                              , MAX(ISNULL(yield, 1)) AS yield

                         FROM   scm_yield_exct_ver_h_sn t WITH(NOLOCK)   
                                INNER JOIN MASTER_VERSION  v
                                ON     t.division_id  = v.division_id
                                AND    t.operation_id = v.operation_id
                                AND    t.version_id   = v.version_id

                         WHERE  1=1
                         AND    t.end_time      >= SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,-2,GETDATE()),112),1,6) + '01' -- 전전월
                         AND    t.yield         >  0
                         AND    t.yield         <= 1
                         AND    t.active_flag    = 'Y'
                                           
                         GROUP BY t.version_id, t.division_id, t.company_id, t.site_id, t.plant_id, t.factory_id
                                , t.item_id, t.operation_id, t.line_id
                                , CONVERT(CHAR(8), t.start_time, 112)
                                , CONVERT(CHAR(8), t.end_time, 112)
                                , CONVERT(CHAR(6), t.end_time, 112)
              ) tt
             , scm_mst_item_line_assign_sn a WITH (NOLOCK)
        WHERE  1=1
        AND    tt.division_id   = a.division_id
        AND    tt.company_id    = a.company_id
        AND    tt.site_id       = a.site_id
        AND    tt.plant_id      = a.plant_id
        AND    tt.factory_id    = a.factory_id
        AND    tt.operation_id  = a.operation_id
        AND    tt.item_id       = a.item_id
        AND    tt.line_id       = a.line_id
        AND    tt.month         = a.month
        AND    a.active_flag    = 'Y'
        AND    a.priority       NOT IN ( 0, 9 ) -- FP에서 0 / 9 는 생산 대상 아님
        GROUP BY tt.version_id, tt.division_id, tt.company_id, tt.site_id, tt.plant_id, tt.factory_id, tt.operation_group_id
               , tt.item_id, tt.operation_id, tt.line_id, tt.start_time, tt.end_time

