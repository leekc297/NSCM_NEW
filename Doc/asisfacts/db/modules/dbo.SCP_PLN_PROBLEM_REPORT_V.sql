







CREATE VIEW [dbo].[SCP_PLN_PROBLEM_REPORT_V] 
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_PLN_PROBLEM_REPORT_V
  * DESCRIPTION   : 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018.02.02   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
  * 2018.05.28   LTW         scp_eng_problem_report_o_sn.problem_qty가 0.0보다 큰값만 조회
  /*
  PLAN_ID,MODELING_ID,SEQ,PLAN_NAME,MASTER_ID,OUT_VERSION_ID
  */
  ****************************************************************************/
SELECT
        a.plan_id
       ,a.modeling_id
       ,a.seq AS seq
       ,a.plan_name AS plan_start_yyyymmdd
       ,a.plan_type
       ,a.master_id
       ,a.out_version_id
       ,a.division_id
       ,a.problem_seq
       ,a.demand_id AS eng_demand_id
       ,dbo.fn_scm_split(a.demand_id,1,'##') as demand_id
       
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
       ,a.problem_type
       ,a.problem_descr
       ,a.request_time
       ,a.response_time
       ,a.problem_qty
       ,a.node_type
       ,a.node_id
      
  FROM scp_eng_problem_report_o_sn AS a WITH(NOLOCK)
 WHERE a.problem_type <> 'WARNING'
   AND a.problem_qty   > 0.0
 ;

