








CREATE VIEW [dbo].[SCP_PLAN_VERSION_V]  AS
/***************************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_PLAN_VERSION_V
  * DESCRIPTION   : SCP 엔진수행 버전조회용 뷰 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-02-09   YYDOK			INITIAL
  * 2018-04-03   YYDOK			CONFIRM_FLAG,UI_DISPLAN_YN ADD
  * 2018-04-03   YYDOK			PLAN_STATUS ADD (-2: STOP REQUEST)
  * 2018-10-30	 HWYOON			PLAN TYPE 정렬순서 수정(TE 추가)
  * 2021-04-07   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - CAPA SIMULATION VERSION_ID 정보를 위한 ATTRIBUTE1 컬럼 추가
*****************************************************************************************/
WITH SUB AS
(
 SELECT d.division_id,
        p.plan_name + '-' + d.plan_type + '-' + DBO.FN_ZERO_LPAD(CONVERT(NVARCHAR,d.plan_seq),2) AS plan_version_id,
        p.plan_name,
        d.plan_seq,
        d.plan_type,
        d.confirm_flag,
        d.confirm_user, 
        d.confirm_date,
        p.plan_id,
        m.modeling_id,
        m.plan_cycle,
        d.plan_id + '::' + d.plan_TYPE + '::' + CONVERT(VARCHAR,d.plan_seq) AS eng_plan_id,
        d.ui_display_yn,
        d.active_flag,
        d.plan_status,
		d.attribute1   AS version_id -- 2021-04-07 : CAPA SIMULATION VERSION_ID 정보를 위한 컬럼 추가
 FROM   SCM_MST_PLAN_DETAIL d WITH(NOLOCK),
        SCM_MST_PLAN        p WITH(NOLOCK),
        SCM_MST_MODELING    m WITH(NOLOCK)
 WHERE  1=1
 AND    m.modeling_id   = d.modeling_id
 AND    m.plan_cycle    = 'WEEKLY'
 AND    m.division_id   = d.division_id
 AND    m.modeling_id   = d.modeling_id
 AND    p.division_id   = d.division_id
 AND    p.plan_cycle    = m.plan_cycle
 AND    p.plan_id       = d.plan_id
 AND    d.plan_status   = '1'
 AND    d.ui_display_yn = 'Y'
)
 SELECT s.division_id,
        s.plan_version_id  AS plan_version_id,
        s.plan_name        AS plan_start_yyyymmdd,
        s.plan_type,
        s.plan_seq,
        s.confirm_flag,
        s.confirm_user,
        s.confirm_date,
        s.plan_id,
        s.modeling_id,
        s.plan_cycle,
        s.eng_plan_id,
        s.ui_display_yn,
        s.active_flag,
        s.plan_status,
		s.version_id,
        CASE(s.plan_type) 
            WHEN 'PR' THEN 1 
            WHEN 'MA' THEN 2 
            WHEN 'SE' THEN 3 
            WHEN 'FN' THEN 4 
            ELSE 0         
        END AS plan_type_order
 FROM   SUB s
 WHERE  1=1
 AND    s.plan_name >= [dbo].[FN_GET_BUCKET_YYYYMMDD](-24) --24주전 : 20200619 허준성책임 요청으로 임시로 늘림
;



