




CREATE VIEW [dbo].[SCM_MST_TACT_TIME_VER_H_V]
 AS
/*
 * Program ID   : SCM_MST_TACT_TIME_VER_H_V
 * Description  : SCP Tact Time 용 View : FP 최신 Version 정보 사용
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
              -- PJ20230691R HM JV 대응 AND    v.division_id        IN ('40', '81', '82', '81_UC') -- 전극 별도 버전 존재함   -- 20220329 PJ20216891 GM JV 가상 Division 추가
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
							and dm.valid_yn	   = 'Y'
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

			  /*  PJ20230691R HM JV 2023.04.03 주석처리 (EE와 JV EE 쿼리 하나로 통합) 
              -- 전극은 하나의 version으로 존재하나 실제 Data는 사업부별로 존재함
              SELECT d.division_id, r.operation_id, MAX(v.version_id) AS version_id
              FROM   scm_master_version_info_h_sn v WITH(NOLOCK)
                   , scm_mst_operation_sn r WITH(NOLOCK)
                   , scm_mst_division d WITH(NOLOCK)
              WHERE  1=1
              AND    v.division_id        = 'EE' -- 전극 별도 버전 존재함
              AND    d.division_id        IN ('40', '81', '82')
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

SELECT b.version_id, b.division_id, b.company_id, b.site_id, b.plant_id, b.factory_id
     , b.plant_site_id, b.item_id, b.operation_id, b.line_id, b.month
     , b.tact_time
     , b.daily_capa
     , b.lane_qty
FROM  (

    SELECT t.version_id, t.division_id, t.company_id, t.site_id, t.plant_id, t.factory_id
         , t.plant_id + '-' + t.operation_group_id AS plant_site_id
         , t.item_id, t.operation_id, t.line_id, t.month
    	  -- SCP에서 사용할 Tact Time : daily_capa 기준으로 처리
         , (CASE -- 셀, 팩일때 
                 WHEN t.operation_group_id <> 'E' THEN
                      IIF( SUM(ISNULL(t.daily_capa,0)) = 0, 0, ROUND((60 * 60 * 24)/MAX(ISNULL(t.daily_capa,0)),3) )  
                 -- 전극일때                                                             
                 WHEN MAX(ISNULL(a.lane_qty, 0)) = 0 THEN IIF( SUM(ISNULL(t.daily_capa,0)) = 0, 0, ROUND((60 * 60 * 24)/MAX(ISNULL(t.daily_capa,0)),3) ) 
                 ELSE IIF( SUM(ISNULL(t.daily_capa,0)) = 0, 0, ROUND((60 * 60 * 24)/MAX(ISNULL(t.daily_capa,0)),3) ) 
                     / MAX(ISNULL(a.lane_qty, 1))
    
                 -- 전극 Tact Time 사용인 경우
                 --WHEN MAX(ISNULL(a.lane_qty, 0)) = 0 THEN MAX(ISNULL(t.tact_time, 0))
                 --ELSE MAX(ISNULL(t.tact_time, 0)) / MAX(ISNULL(a.lane_qty, 1))
    
            END )    AS tact_time

          , MAX(ISNULL(a.lane_qty, 1) ) AS lane_qty
		  
         , (CASE -- 셀, 팩일때 
                 WHEN t.operation_group_id <> 'E' THEN
                      IIF( SUM(ISNULL(t.daily_capa,0)) = 0, 0, MAX(ISNULL(t.daily_capa,0)) )  
                 -- 전극일때                                                             
                 WHEN MAX(ISNULL(a.lane_qty, 0)) = 0 THEN IIF( SUM(ISNULL(t.daily_capa,0)) = 0, 0, MAX(ISNULL(t.daily_capa,0)) )
                 ELSE IIF( SUM(ISNULL(t.daily_capa,0)) = 0, 0, MAX(ISNULL(t.daily_capa,0)) )
                     * MAX(ISNULL(a.lane_qty, 1))
    
            END )    AS daily_capa

    FROM  (SELECT t.*
                , CASE WHEN SUBSTRING(t.operation_id, 1, 1) IN ('E', 'S')      THEN 'E'
                       WHEN SUBSTRING(t.operation_id, 1, 1) IN ('A', 'B', 'F') THEN 'A'
                       WHEN SUBSTRING(t.operation_id, 1, 1) IN ('P')           THEN 'P'
                       ELSE 'A'
                  END AS operation_group_id

           FROM   scm_tact_time_ver_h_sn t WITH(NOLOCK)
    
                  INNER JOIN MASTER_VERSION v
                  ON     t.division_id  = v.division_id
                  AND    t.operation_id = v.operation_id
                  AND    t.version_id   = v.version_id
           WHERE  t.month > SUBSTRING(CONVERT(VARCHAR,DATEADD(MM,-2,GETDATE()),112),1,6) -- 전전월
          ) t
         , scm_mst_item_line_assign_sn  a WITH (NOLOCK)
    
    WHERE  1=1	
    AND    t.division_id   = a.division_id
    AND    t.company_id    = a.company_id
    AND    t.site_id       = a.site_id
    AND    t.plant_id      = a.plant_id
    AND    t.factory_id    = a.factory_id
    AND    t.operation_id  = a.operation_id
    AND    t.item_id       = a.item_id
    AND    t.line_id       = a.line_id
    AND    t.month         = a.month
    AND    a.active_flag   = 'Y'
    AND    a.priority      NOT IN ( 0, 9 ) -- FP에서 0 / 9 는 생산 대상 아님
                                               
    GROUP BY t.version_id, t.division_id, t.company_id, t.site_id, t.plant_id, t.factory_id, t.operation_group_id
           , t.item_id, t.operation_id, t.line_id, t.month
      
	  ) b
WHERE  1=1
AND    b.tact_time > 0

