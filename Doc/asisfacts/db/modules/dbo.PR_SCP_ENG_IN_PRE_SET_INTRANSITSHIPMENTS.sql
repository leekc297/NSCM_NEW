
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS
 * Description  : SDB의 Site별 해상재고 정보를 ODB의 해상재고에 적재되도록 한다.
                  
                  1. 운송중 재고 정보 생성 : 해상재고( I : GTS 있는 해상정보, 'S' : GTS 없는 정보, 'C' 법인간 해상재고)
				     SCM_DNM_INTRANSIT_V 사용
                  
                  2. 위 1에서 생성된 운송중재고 정보의 from_site / to_site 값 변경

                     2-1. from site 변경

                         --(전극은 처리시 제외 되므로 처리안해도됨) 전극일때 :  -1) from site가 전극('E') 사이트이고  to site가 동일site_id 아니거나 'SALES'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
                                                                                -2) from site가 전극('E') 사이트이고  to site가 동일site_id 이면서   'PLANT'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~002']
                     
                         --셀일때   :  -1) from site가 셀('A') 사이트이면서 외주celler가 아닐때  to site가 동일site_id 아니거나 'SALES'사이트이거나 외주packer 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
                                       -2) from site가 셀('A') 사이트이면서 외주celler가 아닐때  to site가 동일site_id 이면서   'PLANT'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~002']

                         --팩일때   :  -1) from site가 팩('P') 사이트이면서 외주packer가 아닐때  to site가                       'SALES'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
                     
                     2-2. to site 변경
                          --전극일때 : 전극은 처리대상이 아니므로 처리안함
                                                                                         
                          --셀일때   : -1) from site가 셀('A') 사이트이면서 외주celler 일때  to site가 셀('A') 이면서 외주아닐때   to_scm_site_id 값을 [ plant_id + '~' + incoterms'] => [ plant_id + '~003']
                                    
 * OutTable     : SCP_ENG_INTRANSITSHPMNT_I
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.16   KSW         전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018.07.17   KSW         팩분리(~***, ~003) 적용관련 수정
 * 2018.08.22   KSW         1) 외주 셀/팩 ***만 생성( 외주셀 : 001, 002, 003 생성제외, 외주팩 : 003 생성제외)
                            2) From site가  외주셀site 이고 To site가 셀(외주셀아님)site 인 경우 To Site를 -A~***에서 -A~003 으로 변경
 * 2018.10.18   KSW         1) result_type = 'C' 제외처리 (참고)주석1-1, 주석1-2
                            2) PLANT site일때 incoterms <> 'FOB' 주석처리 (참고)주석1-2
 * 2018.11.21   KSG         SO Reserve Stock : result_type = 'B' 추가
 * 2018.12.05   KSG         SO Reserve Stock : result_type = 'B' 제거 : 해상재고 대신 To Site의 재고로 처리
 * 2018.12.13   KSW         해상재고 INSERT부분수정 ( to site의 site_type ='PLANT' 일때 result_type = 'C' 만처리되게 수정) (참고)주석1-2
 * 2019.06.11   KSG         VMI향 Intransit : result_type = 'V' 추가
 * 2019.06.13   KSG         Intransit(GTS) 정보에서 To Site 가 plant인 경우도 추가 반영
 * 2019.06.19   KSG         SCM_DNM_INTRANSIT_V 사용
 * 2020.10.13   KSG         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                컬럼 정보 수정 FINAL_SOLDTO_CODE / FINAL_INCOTERMS
 * 2022.06.24   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 소형(40) P5000 공정 isuzu 모델링 추가
 * 2022.07.12   KSG         PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 : 소형(40) Incoterms 변경 적용
 * 2023.03.13   KKC         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: 신규 DIVISION 공통화 추가 
 * 2023.04.13   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 도전과제 계획
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)
    -- , @p_debug       INT OUTPUT
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_INTRANSITSHPMNT_I';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_cutoff_day        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
    DECLARE @v_demand_cutoff_day NVARCHAR(8) ; --= CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 화요일 YYYYMMDD
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME, @p_plan_name) ;
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- 추가기간 반영된 Plan End Date 	
    DECLARE @v_plan_group        NVARCHAR(100) = '-'; -- Plan Group : PJ20230691 도전과제 계획 	

	DECLARE @v_division_group   NVARCHAR(30);  --2023.03.13 추가
    DECLARE @v_division_comp    NVARCHAR(30);  --2023.03.13 추가

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	    ---------------------------------------------
        -- PJ20230691 도전과제 계획 추가용 기간 설정
		---------------------------------------------
		SELECT @v_plan_group = ISNULL(segment5, '-')
		FROM   scm_adm_lookup_master_detail a(nolock)
		WHERE  a.lookup_type = 'PLAN_TYPE'
		AND    a.segment1    = @p_plan_type
		AND    a.valid_yn    = 'Y'
       
        -----------------------------------------------------------
	    -- -- 20220712 PJ20216994 Pet, Cutoff Day 확인
        -----------------------------------------------------------
        --  Plan End Date
	    SELECT @v_pet_date      = CASE WHEN @v_plan_group = 'BIZ' 
                                       THEN CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(c.dm_add_day,0), CONVERT(DATETIME, P.attribute1)), 112)
                                       ELSE CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(c.dm_add_day,0), CONVERT(DATETIME, P.horizon_end_date)), 112)   --- (2022.03.02) Demand 추가기간 반영
                                  END 
			,  @v_add_pet_date  = CASE WHEN @v_plan_group = 'BIZ' 
                                       THEN CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day, (13*7)), CONVERT(DATETIME, P.attribute1)), 112) 
                                       ELSE CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day, (13*7)), CONVERT(DATETIME, P.horizon_end_date)), 112)   -- 추가기간이 NULL이면 디폴트 13주 설정
                                  END	

        --SELECT /** @v_pet_date      =   p.horizon_end_date  --> (2022.03.02) 이전 코드 주석처리 **/
        --       @v_pet_date      = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(c.dm_add_day,0), CONVERT(DATETIME, P.horizon_end_date)), 112)   --- (2022.03.02) Demand 추가기간 반영
	        --,  @v_add_pet_date  = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day, (13*7)), CONVERT(DATETIME, P.HORIZON_END_DATE)), 112)   -- 추가기간이 NULL이면 디폴트 13주 설정 
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        LEFT OUTER JOIN 
                (   /** (2022.01.17) 사업부별 추가계획기간 lookup으로 반영. 단위:week  **/ 
                SELECT a.SEGMENT1 as DIVISION_ID 
                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 13 THEN 13
                            ELSE a.segment2 
                       END AS ADD_WEEK

                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 13 THEN (13*7)
                            ELSE (a.segment2 * 7)
                       END AS ADD_DAY
					 --, a.segment2 as ADD_WEEK , A.segment2*7 AS ADD_DAY 
                FROM   scm_adm_lookup_master_detail a(nolock)
                WHERE  a.lookup_type = 'ADD_PLAN_PERIOD'
                and    a.valid_yn    = 'Y' 
                ) B
                ON ( 1=1
                AND  P.DIVISION_ID  =  B.DIVISION_ID )  
        LEFT OUTER JOIN 
                (   /** (2022.03.02) 사업부별 추가 Demand 반영구간을 Lookup에서 가져온다. 단위:week  **/
		        SELECT a.segment1 as division_id 
                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 10 THEN 10
                            ELSE a.segment2 
                       END AS dm_add_week

                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 10 THEN (10*7)
                            ELSE (a.segment2 * 7)
                       END AS dm_add_day 
					 --, a.segment2 as dm_add_week , a.segment2*7 as dm_add_day 
		        FROM   scm_adm_lookup_master_detail a(nolock)
		        WHERE  a.lookup_type = 'ADD_DEMAND_PERIOD'
		        and    a.valid_yn    = 'Y' 
                ) AS C 
                ON ( 1=1
                AND  p.division_id = c.division_id ) 
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id 
        ;  

        -----------------------------------------------------------
		-- 최근 3일 이내 최신 버전 Demand
	    SELECT @v_demand_cutoff_day = ISNULL(MAX(p.cutoff_yyyymmdd)
                                           , CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 화요일 YYYYMMDD
                                            )
        FROM   dbo.dm_pln_net_demand p WITH(NOLOCK)
        WHERE  p.division_id      = @p_division_id 
        AND    p.cutoff_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -3, @d_plan_name), 112) -- 최근 3일 이내
        ;
        -----------------------------------------------------------

		/*------------------------------------------------------------------
		 * Division Group 정의  (2023.03.13: Joint Venture 사업부 추가) 
			- JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
			- 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
			- 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
			- 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
		----------------------------------------------------------------------*/   
	    SELECT @v_division_group   =  di.attribute3 
			 , @v_division_comp    =  di.attribute4  -- 회사코드
		 FROM  scm_mst_division di WITH(NOLOCK)
		WHERE  di.valid_yn         =  'Y' 
		  AND  di.division_id      =  @p_division_id
		;

        DELETE /* PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS*/ 
		FROM   scp_eng_intransitshpmnt_i_sn
		WHERE  modeling_id  = @p_modeling_id
        AND    plan_id      = @p_plan_id
		AND    plan_type    = @p_plan_type 
        AND    plan_seq     = @p_seq
        ;        
        -----------------------------------------------------------
		
        -----------------------------------------------------------
        -- 1. 해상재고 정보 INSERT 
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS*/ scp_eng_intransitshpmnt_i_sn 
        (	modeling_id
          , plan_id
          , plan_type
          , plan_seq 
	      , result_date
          , result_type
          , company_id
          , division_id
          , plant_id 
	      , shipment_no
          , project_code
          , item_id
          , plant_issue_date
          , incoterms 
          , fcst_type
	      , customer_code
          , shipto_code
          , from_scm_site_id
          , org_from_scm_site_id
          , from_site_item_mapping_yn 
	      , to_scm_site_id
          , org_to_scm_site_id
          , to_site_item_mapping_yn 
	      , delivery_qty
          , uom
          , transport_mode 
	      , shipping_date
          , pol
          , pol_atd_date 
	      , pod
          , pod_eta_date
          , pod_ata_date
          , pod_etd_date
          , pod_atd_date 
	      , f_dest_port_code
          , f_dest_eta_date
          , f_dest_ata_date 
	      , eta_date 
	      , valid_yn
          , created_by
          , creation_date
          , last_updated_by
          , last_update_date
	      , attribute1
          , attribute2
          , attribute3
          , attribute4
          , attribute5 
	      , attribute6
          , attribute7
          , attribute8
          , attribute9
          , attribute10 
        )		
        SELECT @p_modeling_id  AS modeling_id
		     , @p_plan_id      AS plan_id
			 , @p_plan_type    AS plan_type
			 , @p_seq          AS plan_seq
   	         , a.result_date
             , a.result_type
             , a.company_id
             , @p_division_id  AS division_id  --20180629 수정 ( 변경전 : a.division_id )
             , a.plant_id 
	         , a.shipment_no
             , a.project_code
             , a.item_id
             , a.plant_issue_date
             , a.final_incoterms             AS incoterms   -- 20201006 PJ20202001 컬럼 변경  a.incoterms 
             , a.fcst_type 
	         , a.final_soldto_code           AS customer_code  -- 20201006 PJ20202001 컬럼 변경  a.customer_code
             , a.shipto_code
             , a.from_scm_site_id + '~***'   AS from_scm_site_id
             , a.from_scm_site_id            AS org_from_scm_site_id
             , 'Y' AS from_site_item_mapping_yn -- DNM에서 관리 안 함
	         
             -- 20201006 PJ20202001 컬럼 변경
             , a.to_scm_site_id + '~' + CASE WHEN a.site_type = 'PLANT' THEN '***' ELSE a.final_incoterms END AS to_scm_site_id
             --, a.to_scm_site_id + '~' + CASE WHEN a.site_type = 'PLANT' THEN '***' ELSE a.incoterms END AS to_scm_site_id

             , a.to_scm_site_id                   AS org_to_scm_site_id
             , 'Y' AS to_site_item_mapping_yn  -- DNM에서 관리 안 함
	         , a.delivery_qty
             , a.uom
             , a.transport_mode 
	         , a.shipping_date
             , a.pol
             , a.pol_atd_date 
	         , a.pod
             , a.pod_eta_date
             , a.pod_ata_date
             , a.pod_etd_date
             , a.pod_atd_date 
	         , a.f_dest_port_code
             , a.f_dest_eta_date
             , a.f_dest_ata_date 
			 , a.eta_date -- 도착 예정일자 
             
	         , 'Y'         AS valid_yn
             , 'scp_batch' AS created_by
             , GETDATE()   AS creation_date
             , 'scp_batch' AS last_updated_by
             , GETDATE()   AS last_update_date 
	         , a.final_incoterms AS attribute1 -- 20220712 PJ20216994 org_incoterms
             , NULL AS attribute2
             , NULL AS attribute3
             , NULL AS attribute4
             , NULL AS attribute5 
	         , NULL AS attribute6
             , NULL AS attribute7
             , NULL AS attribute8
             , NULL AS attribute9
             , NULL AS attribute10 	   
		FROM   SCM_DNM_INTRANSIT_V  a WITH (NOLOCK)
               --20180514 추가 FN_GET_ITEM_OPERATION_GROUP 함수대체하기위해서 사용함 ( 사용이유: ('E', 'A', 'P') 만 사용하기위해서 INNER JOIN 필요함)
               --INNER JOIN scm_mst_final_item_v fi WITH (NOLOCK)
               INNER JOIN (SELECT DISTINCT division_id, item_id, operation_group_id FROM scm_mst_final_item_v WITH (NOLOCK)) fi
               ON   a.division_id          = fi.division_id
               AND  a.item_id              = fi.item_id
               --AND  fi.operation_group_id  = 'E' -- 전극 모델
               AND  fi.operation_group_id <> 'E' -- 전극 모델은 제외
        WHERE  1=1
        AND    a.division_id   = @p_division_id
        AND    a.result_date   = @v_cutoff_day
        
        -----------------------------------------------------------
        --1.2 DELETE : from_site 가 전극인 정보 삭제 -- 전극 모델은 제외 : ksg 20180517
        -----------------------------------------------------------
		DELETE scp_eng_intransitshpmnt_i_sn
        WHERE  division_id = @p_division_id
        AND    modeling_id = @p_modeling_id
        AND    plan_id     = @p_plan_id
        AND    plan_type   = @p_plan_type
        AND    plan_seq    = @p_seq
        AND    division_id + '::' + org_from_scm_site_id
		   IN ( SELECT division_id + '::' + scm_site_id
                FROM   dbo.scm_mst_site WITH (NOLOCK) 
                WHERE  division_id = @p_division_id
                AND    site_type   = 'PLANT' 
              --  AND    valid_yn    = 'Y'
                AND    operation_group = 'E'
              ) 
		;
        
        -----------------------------------------------------------
        --2. UPDATE : from_site / to_site 변경
        -----------------------------------------------------------
           
            --2-1. from site 변경 
                   --전극일때 :  -1) from site가 전극('E') 사이트이고  to site가 동일site_id 아니거나 'SALES'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
                   --            -2) from site가 전극('E') 사이트이고  to site가 동일site_id 이면서   'PLANT'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~002']
                   
                   --셀일때   :  -1) from site가 셀('A') 사이트이면서 외주celler가 아닐때  to site가 동일site_id 아니거나 'SALES'사이트이거나 외주packer 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
                   --            -2) from site가 셀('A') 사이트이면서 외주celler가 아닐때  to site가 동일site_id 이면서   'PLANT'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~002']

                   --팩일때   :  -1) from site가 팩('P') 사이트이면서 외주packer가 아닐때  to site가                      'SALES'사이트 일때 from_scm_site_id 값을 [ plant_id + '~***'] => [ plant_id + '~003']
                     
            --2-2. to site 변경
                   --셀일때   : -1) from site가 셀('A') 사이트이면서 외주celler 일때  to site가 셀('A') 이면서 외주아닐때   to_scm_site_id 값을 [ plant_id + '~' + incoterms'] => [ plant_id + '~003']

        -----------------------------------------------------------
        UPDATE scp_eng_intransitshpmnt_i_sn
        SET from_scm_site_id = CASE WHEN b.operation_group  = 'E' AND ( ISNULL(b.site_id, '0') <> ISNULL(c.site_id, '0') OR c.site_type ='SALES' ) THEN a.org_from_scm_site_id + '~003'
                                    WHEN b.operation_group  = 'E' AND  ISNULL(b.site_id, '0') = ISNULL(c.site_id, '1')  THEN a.org_from_scm_site_id + '~002'
                                    
                                    WHEN b.operation_group  = 'A' AND ISNULL(b.osp_yn, 'N') = 'N' AND ( ISNULL(b.site_id, '0') <> ISNULL(c.site_id, '0') OR c.site_type ='SALES' OR c.osp_yn = 'Y' ) THEN a.org_from_scm_site_id + '~003'  -- 20180822 수정(변경전 : WHEN b.operation_group  = 'A' AND ( dbo.FN_SCM_SYS_NVL(b.site_id, '0') <> dbo.FN_SCM_SYS_NVL(c.site_id, '0') OR c.site_type ='SALES' OR c.osp_yn = 'Y' ) THEN a.org_from_scm_site_id + '~003' )
                                    WHEN b.operation_group  = 'A' AND ISNULL(b.osp_yn, 'N') = 'N' AND ISNULL(b.site_id, '0') = ISNULL(c.site_id, '1') THEN a.org_from_scm_site_id + '~002'   --20180822 수정 ( 변경전 : WHEN b.operation_group  = 'A' AND dbo.FN_SCM_SYS_NVL(b.site_id, '0') = dbo.FN_SCM_SYS_NVL(c.site_id, '1') THEN a.org_from_scm_site_id + '~002')                                 

                                    WHEN b.operation_group  = 'P' AND ISNULL(b.osp_yn, 'N') = 'N' AND c.site_type ='SALES'  THEN a.org_from_scm_site_id + '~003' --20180822 수정 ( 변경전 : WHEN b.operation_group  = 'P' AND c.site_type ='SALES'  THEN a.org_from_scm_site_id + '~003' -- 20180717 추가 )
                                    WHEN b.operation_group  = 'P' AND ISNULL(b.osp_yn, 'N') = 'N' AND ISNULL(c.OSP_YN, 'N') ='Y'  THEN a.org_from_scm_site_id + '~003' --2022.06.24 ISUZU: (사내Plant -> 외주Plant)로 가는 경우 FROM SITE를 ~003으로 수정함. 
                                    ELSE a.from_scm_site_id   
                               END
           -- 20180822 추가됨
          , to_scm_site_id =   CASE WHEN b.operation_group  = 'A' AND ISNULL(b.osp_yn, 'N') = 'Y' AND c.site_type = 'PLANT' AND c.operation_group = 'A' AND ISNULL(c.osp_yn, 'N') = 'N' THEN a.org_to_scm_site_id + '~003'
                                    ELSE a.to_scm_site_id
                               END
        FROM   scp_eng_intransitshpmnt_i_sn a
               INNER JOIN ( SELECT division_id, scm_site_id, site_id, operation_group, site_type, osp_yn   
                            FROM   dbo.scm_mst_site WITH (NOLOCK) 
                            WHERE  division_id = @p_division_id
                            AND    site_type   = 'PLANT' 
                            AND    valid_yn    = 'Y'
                            AND    operation_group IN ('E', 'A', 'P') -- 20180717 수정 ( 변경전 : AND    operation_group IN ('E', 'A') )
                          ) b --from site
               ON  a.division_id           = b.division_id 
               AND a.org_from_scm_site_id  = b.scm_site_id                
               INNER JOIN ( SELECT division_id, scm_site_id, site_id, operation_group,site_type, osp_yn    
                            FROM   dbo.scm_mst_site WITH (NOLOCK) 
                            WHERE  division_id = @p_division_id
                            AND    valid_yn    = 'Y') c -- to site
               ON  a.division_id         = c.division_id 
               AND a.org_to_scm_site_id  = c.scm_site_id 
        WHERE  a.modeling_id = @p_modeling_id 
        AND    a.plan_id     = @p_plan_id
        AND    a.plan_type   = @p_plan_type 
        AND    a.plan_seq    = @p_seq
        ;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = 'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;	

        -----------------------------------------------------------
        -- 20220712 PJ20216994 소형(40) Incoterms 변경 적용 : START
        -- 1. ETA 내에 동일 Incoterms의 Demand가 존재하면 Incoterms 유지
        -- 2. MIN 일자 Demand의 Incoterms 로 변경 처리 
        -- 3. 소형 사업부(40) 만 처리
        -----------------------------------------------------------
		--IF @p_division_id = '40'
		IF @v_division_group = '40'  --2023.03.13 division_group으로 변경
		BEGIN

			DECLARE @v_division_id         NVARCHAR(30); 
			DECLARE @v_org_to_scm_site_id  NVARCHAR(30); 
			DECLARE @v_item_id             NVARCHAR(30); 
			DECLARE @v_incoterms           NVARCHAR(30); 
			DECLARE @v_eta_date            NVARCHAR(30); 
			DECLARE @v_to_be_incoterms     NVARCHAR(30); 
		
			DECLARE CUR_INTRANSIT_INC CURSOR FOR
			SELECT i.division_id
				 , i.org_to_scm_site_id
				 , i.item_id
				 , i.incoterms
				 , i.eta_date
				 , i.to_be_incoterms

			FROM (
				SELECT a.division_id
					 , a.org_to_scm_site_id
					 , a.item_id
					 , a.attribute1 AS incoterms
					 , a.eta_date
					 , c.incoterms AS to_be_incoterms
					 , CASE WHEN ISNULL(b.incoterms, '')  <> '' THEN 'N'
							WHEN ISNULL(c.incoterms, '')   = '' THEN 'N'
        					WHEN ISNULL(a.attribute1, '') <> ISNULL(C.incoterms, '') THEN 'Y'  -- Org Incoterms(attribute1) 와 비교
        					ELSE 'N' 
        			   END AS INC_DIFF -- Incoterms 차이 확인
				FROM  (
        				SELECT DISTINCT division_id, org_to_scm_site_id, item_id, incoterms, eta_date, attribute1
        				FROM   scp_eng_intransitshpmnt_i_sn
        				WHERE  modeling_id  = @p_modeling_id
        				AND    plan_id      = @p_plan_id
        				AND    plan_type    = @p_plan_type
        				AND    plan_seq     = @p_seq
        				) a

				-- ETA 내 동일 Incoterms FCST 존재여부 확인
				LEFT JOIN (
        				SELECT aa.division_id, aa.scm_site_id, aa.item_id, aa.incoterms
							 , MIN(ISNULL(aa.attribute1, '20000101')) AS min_yyyymmdd
							 , MAX(ISNULL(aa.attribute1, '20000101')) AS max_yyyymmdd
        				FROM   dbo.dm_pln_net_demand aa WITH (NOLOCK)

        					INNER JOIN ( -- VMI 대상 site 조회
        								SELECT division_id, scm_site_id, vmi_yn 
        								FROM   scm_mst_site  WITH (NOLOCK)
        								WHERE  division_id = @p_division_id
        								AND    valid_yn    = 'Y'
        								AND    vmi_yn     <> 'Y' -- VMI 대상 site 제외
        								AND    ISNULL(operation_group, 'N') <> 'W' -- AS 대상 site 제외
        								) mse
        					ON   aa.division_id = mse.division_id
        					AND  aa.scm_site_id = mse.scm_site_id 

        				WHERE  aa.division_id     = @p_division_id
        				AND    aa.cutoff_yyyymmdd = @v_demand_cutoff_day -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
        				AND    aa.attribute1     >= @p_plan_name -- Plan 구간 내 Demand
        				AND    aa.attribute1     <= @v_pet_date  -- Plan 구간 내 Demand
        				GROUP BY aa.division_id, aa.scm_site_id, aa.item_id, aa.incoterms
        				) b
		
				ON  a.division_id        = b.division_id
				AND a.org_to_scm_site_id = b.scm_site_id
				AND a.item_id            = b.item_id
				AND a.attribute1         = b.incoterms  -- Org Incoterms(attribute1) 와 비교
				AND a.eta_date          >= b.min_yyyymmdd

				-- MIN 일자 Demand의 Incoterms 확인
				LEFT JOIN (
        				select aa.division_id, aa.scm_site_id, aa.item_id, MAX(aa.incoterms) AS incoterms
        				FROM   dbo.dm_pln_net_demand aa WITH (NOLOCK)

        					INNER JOIN ( 
								SELECT aa.division_id, aa.cutoff_yyyymmdd, aa.scm_site_id, aa.item_id, MIN(ISNULL(aa.attribute1, '20000101')) AS yyyymmdd
								FROM   dbo.dm_pln_net_demand aa WITH (NOLOCK)

									INNER JOIN ( -- VMI 대상 site 조회
												SELECT division_id, scm_site_id, vmi_yn 
												FROM   scm_mst_site  WITH (NOLOCK)
												WHERE  division_id = @p_division_id
												AND    valid_yn    = 'Y'
												AND    vmi_yn     <> 'Y' -- VMI 대상 site 제외
												AND    ISNULL(operation_group, 'N') <> 'W' -- AS 대상 site 제외
												) mse
									ON   aa.division_id = mse.division_id
									AND  aa.scm_site_id = mse.scm_site_id 

								WHERE  aa.division_id     = @p_division_id
								AND    aa.cutoff_yyyymmdd = @v_demand_cutoff_day -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
								AND    aa.attribute1     >= @p_plan_name -- Plan 구간 내 Demand
								AND    aa.attribute1     <= @v_pet_date  -- Plan 구간 내 Demand
								GROUP BY aa.division_id, aa.cutoff_yyyymmdd, aa.scm_site_id, aa.item_id
								) mse
        					ON   aa.division_id     = mse.division_id
							AND  aa.cutoff_yyyymmdd = mse.cutoff_yyyymmdd 
        					AND  aa.scm_site_id     = mse.scm_site_id 
        					AND  aa.item_id         = mse.item_id 
        					AND  ISNULL(aa.attribute1, '20000101') = mse.yyyymmdd 
        				GROUP BY aa.division_id, aa.scm_site_id, aa.item_id
        
        				) c		
				ON  a.division_id        = c.division_id
				AND a.org_to_scm_site_id = c.scm_site_id
				AND a.item_id            = c.item_id

			   ) i
			WHERE i.INC_DIFF = 'Y' 
			;

			OPEN CUR_INTRANSIT_INC;
			FETCH NEXT FROM CUR_INTRANSIT_INC INTO @v_division_id, @v_org_to_scm_site_id, @v_item_id, @v_incoterms, @v_eta_date, @v_to_be_incoterms
     
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
		
				UPDATE scp_eng_intransitshpmnt_i_sn
				SET    incoterms      = @v_to_be_incoterms
					 , to_scm_site_id = @v_org_to_scm_site_id + '~' + @v_to_be_incoterms
					 , shipment_no    = a.shipment_no + '_' + a.incoterms  -- Key 중복 방지
				FROM   scp_eng_intransitshpmnt_i_sn a
				WHERE  a.modeling_id = @p_modeling_id 
				AND    a.plan_id     = @p_plan_id
				AND    a.plan_type   = @p_plan_type 
				AND    a.plan_seq    = @p_seq
				AND    a.division_id        = @v_division_id
				AND    a.org_to_scm_site_id = @v_org_to_scm_site_id
				AND    a.item_id            = @v_item_id
				AND    a.attribute1         = @v_incoterms  -- Org Incoterms(attribute1) 와 비교
				AND    a.eta_date           = @v_eta_date

			  FETCH NEXT FROM CUR_INTRANSIT_INC INTO @v_division_id, @v_org_to_scm_site_id, @v_item_id, @v_incoterms, @v_eta_date, @v_to_be_incoterms
			END
    
			CLOSE CUR_INTRANSIT_INC;
			DEALLOCATE CUR_INTRANSIT_INC; 		
		
		END; -- IF @v_division_group = '40'
        -----------------------------------------------------------
        -- 20220712 PJ20216994 소형(40) Incoterms 변경 적용 : END
        -----------------------------------------------------------

      END;

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000)); 
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      return -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END;
