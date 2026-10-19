






  

CREATE VIEW [dbo].[SCP_PLN_NET_DEMAND_V]  
AS  
/****************************************************************************  
  * PROJECT       : LG CHEM SCP PRJ.  
  * VIEW NAME     : SCP_PLN_NET_DEMAND_V  
  * DESCRIPTION   :   
  *  
  * PROGRAM HISTORY  
  *--------------------------------------------------------------  
  *  DATE      IN CHARGE           DESCRIPTION  
  *--------------------------------------------------------------  
  * 2018.02.21   YYDOK    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
  * 2025.03.31   kimcd    PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
  *                       E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발  
  * 2025.10.02   kimcd    NERP OPEN 3차 대응. 임시 VIEW 수정 - CELL 생산지 코드 신규 코드로 수정
  ****************************************************************************/  
  
SELECT  
   a.master_id  
  ,a.plan_id AS eng_plan_id
  ,a.plan_id AS out_version_id  
  ,dbo.fn_scm_split(a.plan_id,1,'::') AS plan_id  
  --,(  
  --  CASE dbo.fn_scm_split(a.master_id,1,'::') WHEN '40' THEN '1' WHEN '81' THEN '2' WHEN '82' THEN '3' END  
  --  ) AS modeling_id  
  ,dbo.fn_scm_split(a.plan_id,3,'::') AS seq  
  ,dbo.fn_get_plan_name(dbo.fn_scm_split(a.master_id,1,'::'),dbo.fn_scm_split(a.plan_id,1,'::'),dbo.fn_scm_split(a.master_id,2,'::')) AS plan_start_yyyymmdd  
  ,dbo.fn_scm_split(a.plan_id,2,'::') AS plan_type  
  ,dbo.fn_scm_split(a.master_id,1,'::') AS division_id  
  ,a.demand_id AS eng_demand_id  
  ,a.sales_model_id  
  ,convert(VARCHAR,a.shipping_date,112) AS shipping_date  
  ,convert(VARCHAR,a.due_date,112)      AS due_date  
  ,a.qty  
  ,a.split_qty  
  ,dbo.fn_scm_split(a.demand_id,1,'::') AS item_id    
  ,dbo.fn_scm_split(a.demand_id,2,'::') AS project_code  
  ,dbo.fn_scm_split(a.demand_id,3,'::') AS eng_site_id    
  ,dbo.fn_scm_split(dbo.fn_scm_split(a.demand_id,3,'::'),1,'~') AS sales_site_id  
  ,dbo.fn_scm_split(dbo.fn_scm_split(a.demand_id,3,'::'),2,'~') AS incoterms    
  ,dbo.fn_scm_split(a.demand_id,4,'::') AS dom_exp  
  ,dbo.fn_scm_split(a.demand_id,5,'::') AS fcst_type  
  ,dbo.fn_scm_split(a.demand_id,6,'::') AS demand_type   
  ,dbo.fn_scm_split(a.demand_id,7,'::') AS yyyymmdd               
  ,(CASE dbo.fn_scm_split(dbo.fn_scm_split(dbo.fn_scm_split(a.demand_id,8,'::'),1,'^'),1,'##')
          WHEN 'NOPLANT' THEN '-'
          ELSE dbo.fn_scm_split(dbo.fn_scm_split(dbo.fn_scm_split(a.demand_id,8,'::'),1,'^'),1,'##')
      END )
    AS plant_site_id
  , priority   
  -- 2025.10.02 kimcd    NERP OPEN 3차 대응. 임시 VIEW 수정 - CELL 생산지 코드 신규 코드로 수정
  -- 다음 주 SCP 계획 미수립으로 CELL 생산 SITE 넣기. 10월 12일 기존 VIEW로 원복할 것
  , ISNULL( (SELECT TOP 1 CM.NEW_VALUE1 
             FROM   DBO.NERP_CONV_MASTER   CM WITH(NOLOCK)
             WHERE  1=1
             AND    CM.ATTRIBUTE5 = '3RD'
             AND    CM.CODETYPE   = 'SCP_SITE_ID'
             AND    CM.OLD_VALUE1 = a.plant_type),  ISNULL(a.plant_type,'-') ) AS cell_plant_site_id  -- 2025.03.31   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 E20250310-000135
FROM th_eng_net_demand_sn AS a WITH(NOLOCK)  
WHERE ISNUMERIC(dbo.fn_scm_split(a.plan_id,3,'::')) = 1 --숫자
;  
