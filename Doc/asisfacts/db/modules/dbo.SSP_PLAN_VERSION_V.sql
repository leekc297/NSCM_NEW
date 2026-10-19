












CREATE VIEW [dbo].[SSP_PLAN_VERSION_V]  AS
/**
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SSP_PLAN_VERSION_V
  * DESCRIPTION   : SCP 엔진수행 버전조회용 뷰 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-04-27   YYDOK        INITIAL
  * 2019-11-18   JUHLEE        SSP division 81,82 엔진미수행으로 추가 로직  
  * 2024-10-01   KHJ           NERP_SSP
  */

with sub as
(
select d.DIVISION_ID,
       p.plan_name+'-'+d.plan_type+'-'+ dbo.fn_zero_lpad(convert(nvarchar,d.plan_seq),2)  as plan_version_id,
       p.plan_name,
       d.plan_seq,
       d.plan_type,
       d.CONFIRM_FLAG,
       D.CONFIRM_USER, 
       D.CONFIRM_DATE,
       P.PLAN_ID,
       M.MODELING_ID,
       M.PLAN_CYCLE,
       P.PLAN_ID+'::'+d.plan_TYPE+'::'+CONVERT(VARCHAR,d.plan_seq) AS ENG_PLAN_ID,
       D.UI_DISPLAY_YN,
       D.ACTIVE_FLAG,
       D.PLAN_STATUS 
  from scm_mst_plan_detail d with(nolock),
       scm_mst_plan        p with(nolock),
       scm_mst_modeling    m with(nolock)
 where 1=1
   and m.MODELING_ID   = d.MODELING_ID
   and m.PLAN_CYCLE    = 'DAILY'
   and m.DIVISION_ID   = d.DIVISION_ID
   and m.MODELING_ID   = d.MODELING_ID
   and p.DIVISION_ID   = d.DIVISION_ID
   and p.PLAN_CYCLE    = m.PLAN_CYCLE
   and p.PLAN_ID       = d.PLAN_ID
   and d.PLAN_STATUS   = '1'
   and d.UI_DISPLAY_YN = 'Y'
   and d.CONFIRM_FLAG  ='Y'

   UNION ALL 
select M.DIVISION_ID             AS DIVISION_ID 
,      A.PLAN_START_YYYYMMDD+'-SP-'+ dbo.fn_zero_lpad(convert(nvarchar,1),2)  as plan_version_id
,      A.PLAN_START_YYYYMMDD     AS plan_name
,      1                         AS plan_seq
,      'SP'                      AS plan_type
,      A.CONFIRM_CREATE_YN       AS CONFIRM_FLAG
,      A.CREATED_BY              AS CONFIRM_USER 
,      A.CONFIRM_CREATE_DATE     AS CONFIRM_DATE
,      'XX'                        AS PLAN_ID
,      'XX'                        AS MODELING_ID
,      'DAILY'					 AS PLAN_CYCLE
,      'XX'                        AS ENG_PLAN_ID
,      'Y'                       AS UI_DISPLAY_YN
,      'Y'                       AS ACTIVE_FLAG
,      '1'                       AS PLAN_STATUS 
from   SSP_MST_SHIP_PLAN_SCHEDULE A WITH(NOLOCK) 
		LEFT OUTER JOIN SCM_MST_DIVISION M WITH(NOLOCK) 
		ON M.DIVISION_ID <> '40'
WHERE  A.CONFIRM_CREATE_YN ='Y'
AND    A.PLAN_START_YYYYMMDD  = ( SELECT MAX(B.PLAN_START_YYYYMMDD ) 
								  FROM SSP_MST_SHIP_PLAN_SCHEDULE B WITH(NOLOCK) 
								  WHERE    B.CONFIRM_CREATE_YN ='Y'
								) 
--AND    A.COMPANY_ID  = 'C100'
AND    A.COMPANY_ID  = dbo.FN_GET_LOOKUP_VALUE('SSP_PLAN_VERSION_V'  ,'ESOC' )	--C100
 )
   select DIVISION_ID,
          plan_version_id  as plan_version_id,
          plan_name        as plan_start_yyyymmdd,
          plan_type,
          plan_seq,
          CONFIRM_FLAG,
          CONFIRM_USER,
          CONFIRM_DATE,
          PLAN_ID,
          MODELING_ID,
          PLAN_CYCLE,
          ENG_PLAN_ID,
          UI_DISPLAY_YN,
          ACTIVE_FLAG,
          PLAN_STATUS
     from sub
    where 1=1
      and plan_name >= [dbo].[FN_GET_BUCKET_YYYYMMDD](-5) --2주전
;






