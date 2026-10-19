
/*
 * Program ID   : PR_SCP_ENG_EE_FN_SET_BOD_ENG
 * Description  : SDB의 BOD/Item BOD 정보에 대하여 현재 Plan에 사용할 현재 시점의 Snapshot 정보를 SDB에 적재되도록 한다.

                  1. bod Shapshot 정보(scm_mst_bod_eng)
                     1-1. to site가 SALES site인 데이터 생성
                          -컬럼1) 'attribute10' 컬럼 : BOD L/T 값셋팅 
                                ( 참고) BOD 생성중 1-1, 1-2 만 정상루틴에 의한 BOD이므로 L/T 값존재하지만, 1-3,1-4는 엔진에서만 쓰기위해서 임의로생성 된 BOD이므로 L/T값이 없으므로 0으로 셋팅함) 
                     
                     1-2. To Site가 PLANT site인 데이터 생성      
                          -컬럼1) 'attribute10' 컬럼 : BOD L/T 값셋팅 
                                ( 참고) BOD 생성중 1-1, 1-2 만 정상루틴에 의한 BOD이므로 L/T 값존재하지만, 1-3,1-4는 엔진에서만 쓰기위해서 임의로생성 된 BOD이므로 L/T값이 없으므로 0으로 셋팅함) 
                     
                     1-3. from site가 전극/셀 사이트일경우 'eng_from_site' 값 변경                          
                          
                          -- 전극 일때 :  -1) from_site 와 to_site 가 서로다른 site_id 값이거나 "SALES"사이트 일때 
                                              : eng_from_site컬럼의 값을 [plant_id + '~***'] -> [plant_id + '~003'] 로 변경
                                          -2) from_site 와 to_site 가 같은 site_id 값이면서 'PLANT'사이트 일때  일때
                                              : eng_from_site컬럼의 값을 [plant_id + '~***'] -> [plant_id + '~002'] 로 변경                          
                         
                          -- 20180629 셀 일때 사용안함
                          -- 셀   일때 :  -1) from_site 와 to_site 가 서로다른 site_id 값이거나 "SALES"사이트 일때
                                              : eng_from_site컬럼의 값을 [plant_id + '~***'] -> [plant_id + '~003'] 로 변경
                                          -2) from_site 와 to_site 가 같은 site_id 값이면서 'PLANT'사이트 일때  일때
                                              : eng_from_site컬럼의 값을 [plant_id + '~***'] -> [plant_id + '~002'] 로 변경

                     1-4. bod 추가  
                          
                          -- 전극 일때 : -1) eng_to_site 가 [plant_id + '~002'] 인 BOD 생성
                                         -2) eng_to_site 가 [plant_id + '~003'] 인 BOD 생성  
                          
                          -- 가상 SALES site 일때 :  -1) eng_to_site 가 [plant_id + '-A-S~EXW'] 인 BOD 생성 

                          -- 20180629 셀 일때 사용안함
                          -- 셀   일때 : -1) eng_to_site 가 [plant_id + '~001'] 인 BOD 생성
                                         -2) eng_to_site 가 [plant_id + '~002'] 인 BOD 생성
                                         -3) eng_to_site 가 [plant_id + '~003'] 인 BOD 생성 
                                         
                          -  (20181001 수정) 예외사항 :  외주 전극 (scm_mst_site.osp_yn = 'Y') => BOD 추가 생성안함 ( 외주 전극은 '~***' 만 존재함)
                  
                  2. bod item Shapshot 정보(scm_mst_bod_item_eng)
                     2-1. (20180910 사용안함, scm_mst_bod_item 테이블미사용하므로 2-1처리부분 필요없음) BOD Item Eng 정보 생성 : BOD와 다른 예외 사항 정보 
                     2-2. BOD Item Eng 정보 생성
                          2-2-1) 정상 BOD Item Eng 정보 생성 : BOD와 동일한 정보
                                 - scm_mst_site_item_eng 생성시 임의로 생성된 팩사이트 item은 BOD item eng 생성시 제외시킴   
                                 - scp_mst_bod_item 에 valid_yn = 'Y'로 존재하는 데이터에서 생성함 
                                 ( 참고) 셀item을 팩item 임의로 생성시 scm_mst_site_item_eng.attribute10 컬럼에 'A'로 세팅되어있음 ==> 처리부분 :attribute10 IS NULL OR attribute10 = '' OR attribute10 <> 'A' )
                     
                          2-2-2) 임의생성 BOD Item Eng 정보 생성 
                                 - 임의생성BOD : 위 1-4)에서 추가 생성한 BOD
                  
                  컬럼참고1)  bod_id  =>  형태1) '숫자::x::x'            ( '숫자' : scm_mst_bod의 bod_id값)
                                          형태2) 'x::eng_to_site_id::seq ( 'eng_to_site_id::일련번호' : 전극/셀 site 분리후 추가된 bod_id)     

                  주의사항) 순차적으로 데이터를 생성하게 되어있으므로 위 개발순서를 변경시키면 안됨, 

 * OutTable     : SCM_MST_BOD_ENG, SCM_MST_BOD_ITEM_ENG
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.08   정원식         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.08.24   KSW            임의 생성된 셀 site item은 BOD item eng 생성시 제외
 * 2018.09.10   KSW            BOD ITEM 자동생성 관련 수정 (참고)주석2-2)
 * 2018.10.01   KSW            외주 전극은 ***만 생성( 외주전극 : 002, 003 생성제외)
 * 2018.10.18   KSW            1) scm_mst_bod_item_eng.eff_end_date 컬럼값 변경 ( 플랜종료일-> scp_mst_bod_item.to_yyyymmdd 로 변경)  (참고)주석2-2-1 
                               2) scm_mst_bod_item_eng.eff_end_date 컬럼값 변경 ( 플랜종료일 + 13주(13*7) 로 변경)  (참고)주석2-2-2
 * 2018.11.23   KSW            scm_mst_bod_item_eng테이블에 safety_stock 컬럼 추가 (참고)주석2)-2)-1
 * 2019.03.05   KSW            [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2020.03.23   KSG            [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : BOD Item 에 VMI 전진 검사 LT 정보 추가
 * 2021.05.10   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : Before/After LT 추가
 * 2021.06.07   SEO			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ITEM BOD의 유효일자를 BOD의 유효일자로 대체
 * 2021.07.07   KKC			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - bod View 변경(scp_mst_bod_v -> scp_mst_bod_n_v)
 * 2021.07.14   KKC			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 유효한 기간의 bod만 생성 조건 추가
 * 2021.07.16   KKC			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 기간별 경로 1순위 Check로직 추가
 * 2021.08.26   KKC			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 기간별 경로 1순위 Check로직 예외Case(Case#1~Case#3) 보완
 * 2022.01.26   LHS			   PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 계획수립기간을 lookup으로 설정하여 Engine Plan 기간으로 반영
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2024.11.07   KKC            PJ20249346 LGES SCP 개선과제 이행 : 전극 BOD 정리(Cell Plant -> Cell Plant)
                                                                   item별 순환bod 생성시 삭제 로직 추가(bod id 생성순)
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_EE_FN_SET_BOD_ENG]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_plan_seq1    NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)

    , @p_pre_plan_type1 NVARCHAR(4000)
    , @p_pre_plan_seq1  NVARCHAR(4000)
    , @p_pre_engine_plan_id1 NVARCHAR(4000)
    
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
    DECLARE @p_plan_seq    NVARCHAR(4000)   = @p_plan_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ; 
    
    DECLARE @p_pre_plan_type NVARCHAR(4000) = @p_pre_plan_type1;
    DECLARE @p_pre_plan_seq  NVARCHAR(4000) = @p_pre_plan_seq1;
    DECLARE @p_pre_engine_plan_id NVARCHAR(4000) = @p_pre_engine_plan_id1; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_SET_BOD_ENG';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCM_MST_BOD_ENG, SCM_MST_BOD_ITEM_ENG';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    --DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date --20180910 추가
    DECLARE @v_add_pet_date      NVARCHAR(8) ; -- Add Plan End Date --20210826 추가

    --DECLARE @d_bucket_end_date       DATETIME ;    --20181018추가  th_eng_bucket_info.descr = 'ADD'의 최종 END_DTTM
    --DECLARE @v_bucket_pre_end_date   NVARCHAR(8) ; --20181018추가  th_eng_bucket_info.descr = 'ADD'의 최종 END_DTTM-1일

     ---(2022.04.04) 추가.
    DECLARE @v_division_group   NVARCHAR(30);    
    DECLARE @v_division_comp    NVARCHAR(30); 
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/   
    SELECT @v_division_group   =  di.attribute3 
         , @v_division_comp    =  di.ATTRIBUTE4  -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id  ; 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
/*        -- plan 최종일
        --SELECT @d_pet_date = CONVERT(DATETIME,p.horizon_end_date)
        SELECT @v_pet_date = p.horizon_end_date
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
        ;        
        --주의) th_eng_bucket_info_sn 배치처리순서가 뒤에 만들어지므로 사용할수 없음

        -- Add Plan End Date 추가, 2021.08.26 
		SET @v_add_pet_date = CONVERT(NVARCHAR(8), DATEADD(dd, 13 * 7, CONVERT(DATETIME, @v_pet_date)), 112);
*/

        --  Plan End Date (2022.01.26) 
	    SELECT @v_pet_date      = p.horizon_end_date 
			,  @v_add_pet_date  = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day,(13*7)), CONVERT(DATETIME, P.HORIZON_END_DATE)), 112) -- 추가기간이 NULL이면 디폴트 13주 설정 
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		/** 사업부별 추가계획기간 lookup으로 반영  **/ 
		LEFT OUTER JOIN 
			  (
				SELECT a.SEGMENT1 as DIVISION_ID , a.segment2 as ADD_WEEK , A.segment2*7 AS ADD_DAY 
				FROM   scm_adm_lookup_master_detail a(nolock)
				WHERE  a.lookup_type = 'ADD_PLAN_PERIOD'
				and    a.valid_yn    = 'Y' 
			  ) B
				ON ( 1=1
				AND  P.DIVISION_ID  =  B.DIVISION_ID )  
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id 
		; 

        -----------------------------------------------------------
        -- 1. BOD Eng 정보 생성
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_EE_FN_SET_BOD_ENG */
        FROM  scm_mst_bod_eng
        WHERE 1=1
        and   plan_id     = @p_plan_id
        and   modeling_id = @p_modeling_id
        and   plan_type   = @p_plan_type
        and   plan_seq    = @p_plan_seq
        ;
		
        -----------------------------------------------------------
        -- 1-1) To Site 가 SALES 인 경우
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_FN_SET_BOD_ENG */ scm_mst_bod_eng
		  ( modeling_id, plan_id, plan_type, plan_seq
		  , division_id
		  , bod_id, bod_type, from_site, eng_from_site, pol, pod
		  , hub_sloc, to_site, eng_to_site, incoterms, transport_mode, priority
		  , period_shipsch_mon, period_shipsch_tue, period_shipsch_wed, period_shipsch_thu
		  , period_shipsch_fri, period_shipsch_sat, period_shipsch_sun
		  , freight_forwarder, safety_stock, period1_lt, pol_clearance_lt
		  , period2_lt, pod_clearance_lt, period3_lt, customer_lt, valid_yn
		  , created_by, creation_date, last_updated_by, last_update_date
		  , attribute1
		  , attribute2, attribute3, attribute4, attribute5
		  , attribute6, attribute7, attribute8
		  , attribute9
		  , attribute10
		  )
		SELECT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
		     , @p_division_id
		     , b.bod_id + '::x::x' AS bod_id, b.bod_type, b.from_site, f.eng_scm_site_id, b.d_port_code AS pol, b.a_port_code AS pod
		     , b.hub_sloc, b.to_site, t.eng_scm_site_id, b.incoterms, b.transport_mode, b.priority		     
             , dbo.FN_SCM_SYS_NVL(b.days_mon, 'N') AS period_shipsch_mon, dbo.FN_SCM_SYS_NVL(b.days_tue, 'N') AS period_shipsch_tue, dbo.FN_SCM_SYS_NVL(b.days_wed, 'N') AS period_shipsch_wed, dbo.FN_SCM_SYS_NVL(b.days_thu, 'N') AS period_shipsch_thu
		     , dbo.FN_SCM_SYS_NVL(b.days_fri, 'N') AS period_shipsch_fri, dbo.FN_SCM_SYS_NVL(b.days_sat, 'N') AS period_shipsch_sat, dbo.FN_SCM_SYS_NVL(b.days_sun, 'N') AS period_shipsch_sun		     
             , NULL AS freight_forwarder
             --, b.safety_stock
             -- To Site가 VMI Site 이면 Safety Stock 적용
             , CASE WHEN t.vmi_yn = 'Y' THEN b.safety_stock
                    ELSE 0
               END  AS safety_stock
             , NULL AS period1_lt, NULL AS pol_clearance_lt
		     , NULL AS period2_lt, NULL AS pod_clearance_lt, NULL AS period3_lt, NULL AS customer_lt, b.bod_valid_yn AS valid_yn
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date		     
             --20180330 추가 공장내부/공장외부 구분	     
             --              공장내부 :  BOD의 from site 와 to site 가 같은  site_id (또는 company_id)이면서 to site가 Sales site 가 아닐때
             , 'OUTER_SITE' AS attribute1             
			 , b.before_lt  AS attribute2	--2021.05.10 추가
			 , b.after_lt   AS attribute3		--2021.05.10 추가			 
		     --, b.from_yyyymmdd as attribute4	--2021.06.07 추가
             , CASE WHEN b.from_yyyymmdd > @p_plan_name THEN  b.from_yyyymmdd  --Null 조건 추가, 2021.08.31
					ELSE @p_plan_name
			    END          AS attribute4   --2021.07.14 재수정
			 --, b.to_yyyymmdd AS attribute5 --2021.06.07 추가
             , CASE WHEN b.to_yyyymmdd >= @v_pet_date THEN  @v_add_pet_date
			        ELSE b.to_yyyymmdd
			    END          AS attribute5   --2021.08.26 재수정
		     , NULL AS attribute6, NULL AS attribute7, NULL AS attribute8
             , ISNULL(b.ship_lt_total,0) AS attribute9  --20180402 추가 항차 LT
             , ISNULL(b.lt_total, 0) AS attribute10 -- Attribute10에 LT 적용		

        FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group ) 
                SELECT b.* 
                     , di.attribute3 AS division_group
                     , di.attribute4 AS division_comp 
                FROM  scp_mst_bod_n_v   b WITH (NOLOCK)  --20210707 기간별 view로 변경(scp_mst_bod_v -> scp_mst_bod_n_v)
                    , scm_mst_division di WITH(NOLOCK)
                WHERE 1 = 1
                AND   b.division_id  = di.division_id
                AND   di.valid_yn    = 'Y'
                AND   di.attribute4  =  @v_division_comp   -- 같은 회사 검색
              ) b
        /* 20220404 변경전 
        FROM scp_mst_bod_n_v b WITH (NOLOCK)  --20210707 기간별 view로 변경(scp_mst_bod_v -> scp_mst_bod_n_v)  */ 
           ,(SELECT *
		     FROM  scm_mst_site_eng WITH (NOLOCK) 
		     WHERE plan_id     = @p_plan_id
		     AND   modeling_id = @p_modeling_id
		     AND   plan_type   = @p_plan_type
		     AND   plan_seq    = @p_plan_seq
		     AND   site_type   = 'SALES'      
		    ) t
		   ,(SELECT *
		     FROM  scm_mst_site_eng WITH (NOLOCK) 
		     WHERE plan_id     = @p_plan_id
		     AND   modeling_id = @p_modeling_id
		     AND   plan_type   = @p_plan_type
		     AND   plan_seq    = @p_plan_seq
             AND   operation_group = 'E'  --전극모델링에 맞게, 전극 From Plant로 제한, 2024.11.07 추가 
             AND   eng_scm_site_id = scm_site_id + '~***'              
		    ) f    
		WHERE 1 = 1
        AND   b.division_group  IN ( '40', '81', '82')  -- 2022.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
        /* 20220404 변경전 
        AND   b.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */ 		
        AND   b.bod_valid_yn                 = 'Y'
		AND   b.to_yyyymmdd                 >= @p_plan_name    --유효한 기간의 bod만 생성 조건 추가, 2021.07.14, By KKC
		AND   b.to_site + '~' + b.incoterms  = t.eng_scm_site_id
		AND   b.from_site                    = f.scm_site_id
		;		
		
        -----------------------------------------------------------
        -- 1-2) To Site 가 PLANT 인 경우 : PLANT -> PLANT BOD는 incoterms가 하나라고 가정함
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_FN_SET_BOD_ENG */ scm_mst_bod_eng
		  ( modeling_id, plan_id, plan_type, plan_seq
		  , division_id, bod_id, bod_type, from_site, eng_from_site, pol, pod
		  , hub_sloc, to_site, eng_to_site, incoterms, transport_mode, priority
		  , period_shipsch_mon, period_shipsch_tue, period_shipsch_wed, period_shipsch_thu
		  , period_shipsch_fri, period_shipsch_sat, period_shipsch_sun
		  , freight_forwarder, safety_stock, period1_lt, pol_clearance_lt
		  , period2_lt, pod_clearance_lt, period3_lt, customer_lt, valid_yn
		  , created_by, creation_date, last_updated_by, last_update_date
		  , attribute1, attribute2, attribute3, attribute4, attribute5
		  , attribute6, attribute7, attribute8, attribute9, attribute10
		  )
		SELECT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
		     , @p_division_id, bod_id + '::x::x' AS bod_id, bod_type, from_site, f.eng_scm_site_id, b.d_port_code AS pol, b.a_port_code AS pod
		     , b.hub_sloc, b.to_site, t.eng_scm_site_id, b.incoterms, b.transport_mode, b.priority		     
             , dbo.FN_SCM_SYS_NVL(b.days_mon, 'N') AS period_shipsch_mon, dbo.FN_SCM_SYS_NVL(b.days_tue, 'N') AS period_shipsch_tue, dbo.FN_SCM_SYS_NVL(b.days_wed, 'N') AS period_shipsch_wed, dbo.FN_SCM_SYS_NVL(b.days_thu, 'N') AS period_shipsch_thu
		     , dbo.FN_SCM_SYS_NVL(b.days_fri, 'N') AS period_shipsch_fri, dbo.FN_SCM_SYS_NVL(b.days_sat, 'N') AS period_shipsch_sat, dbo.FN_SCM_SYS_NVL(b.days_sun, 'N') AS period_shipsch_sun		     
             , NULL AS freight_forwarder, 0 AS safety_stock, NULL AS period1_lt, NULL AS pol_clearance_lt
		     , NULL AS period2_lt, NULL AS pod_clearance_lt, NULL AS period3_lt, NULL AS customer_lt, b.bod_valid_yn AS valid_yn
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date		     
             --20180330 추가 공장내부/공장외부 구분	     
             --              공장내부 :  BOD의 from site 와 to site 가 같은  site_id (또는 company_id)이면서 to site가 Sales site 가 아닐때
              --20180426 추가 to 사이트의 osp_yn = 'Y'일때는 외부사이트로 취급한다. 
			 -- 20240617 KSG : PI 요청으로 Company_id 기준으로 변경함
             --, CASE WHEN f.site_id = t.site_id AND t.site_type = 'PLANT' AND ISNULL(t.osp_yn, 'N') <> 'Y'  THEN 'INNER_SITE' 
             , CASE WHEN f.company_id = t.company_id AND t.site_type = 'PLANT' AND ISNULL(t.osp_yn, 'N') <> 'Y'  THEN 'INNER_SITE' 
                    ELSE 'OUTER_SITE'
               END AS attribute1    
			 , b.before_lt AS attribute2	--2021.05.10 추가
			 , b.after_lt AS attribute3		--2021.05.10 추가			 			 
			 --, b.from_yyyymmdd as attribute4	--2021.06.07 추가
             , CASE WHEN b.from_yyyymmdd > @p_plan_name THEN  b.from_yyyymmdd  --Null 조건 추가, 2021.08.31
					ELSE @p_plan_name
			    END          AS attribute4   --2021.07.14 재수정
			 --, b.to_yyyymmdd AS attribute5 --2021.06.07 추가
             , CASE WHEN b.to_yyyymmdd >= @v_pet_date THEN  @v_add_pet_date
			        ELSE b.to_yyyymmdd
			    END          AS attribute5   --2021.08.26 재수정
		     , NULL AS attribute6, NULL AS attribute7, NULL AS attribute8
             , b.ship_lt_total AS attribute9  --20180402 추가 항차 LT
             , b.lt_total AS attribute10 -- Attribute10에 LT 적용             
		FROM  (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group ) 
                SELECT b.* 
                     , di.attribute3 AS division_group
                     , di.attribute4 AS division_comp 
                FROM  scp_mst_bod_n_v   b WITH (NOLOCK) --20210707 기간별 view로 변경(scp_mst_bod_v -> scp_mst_bod_n_v)
                    , scm_mst_division di WITH(NOLOCK)
                WHERE 1 = 1
                AND   b.division_id = di.division_id
                AND   di.valid_yn    = 'Y'
                AND   di.attribute4  =  @v_division_comp   -- 같은 회사 내
              ) b 
        /* 20220404 변경전 
        FROM scp_mst_bod_n_v b WITH (NOLOCK)  --20210707 기간별 view로 변경(scp_mst_bod_v -> scp_mst_bod_n_v) */
           ,(SELECT *
		     FROM  scm_mst_site_eng WITH (NOLOCK) 
		     WHERE plan_id     = @p_plan_id
		     AND   modeling_id = @p_modeling_id
		     AND   plan_type   = @p_plan_type
		     AND   plan_seq    = @p_plan_seq
		     AND   site_type   = 'PLANT'
             AND   eng_scm_site_id = scm_site_id + '~***' ---      
		    ) t
		   ,(SELECT *
		     FROM  scm_mst_site_eng WITH (NOLOCK) 
		     WHERE plan_id     = @p_plan_id
		     AND   modeling_id = @p_modeling_id
		     AND   plan_type   = @p_plan_type
		     AND   plan_seq    = @p_plan_seq              
             AND   operation_group = 'E'  --전극모델링에 맞게, 전극 From Plant로 제한, 2024.11.07 추가 
             AND   eng_scm_site_id = scm_site_id + '~***' ---             
		    ) f    
		WHERE 1 = 1
        AND   b.division_group  IN ( '40', '81', '82') -- 2022.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
        /* 20220404 변경전 
        AND   b.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */
		AND   b.bod_valid_yn = 'Y'
		AND   b.to_yyyymmdd >= @p_plan_name    --유효한 기간의 bod만 생성 조건 추가, 2021.07.14, By KKC
		AND   b.to_site      = t.scm_site_id
		AND   b.from_site    = f.scm_site_id
		;	

        -----------------------------------------------------------
        --1-3) from Site 가 전극/셀 일경우 eng_from_site 컬럼 값변경
        -----------------------------------------------------------             
             -- 20180417 수정
             -- 전극 일때 :  -1) from_site 와 to_site 가 서로다른 site_id 값이거나 "SALES"사이트 일때는 eng_from_site컬럼의 값을 [plant_id + '~***'] -> [plant_id + '~003'] 로 변경
             --              -2) from_site 와 to_site 가 같은 site_id 값이면서     "PLANT"사이트 일때는 eng_from_site컬럼의 값을 [plant_id + '~***'] -> [plant_id + '~002'] 로 변경
             -- 셀   일때 :  -1) from_site 와 to_site 가 서로다른 site_id 값이거나 "SALES"사이트 이거나, 외주packer 일때  eng_from_site컬럼의 값을 [plant_id + '~***'] -> [plant_id + '~003'] 로 변경
             --              -2) from_site 와 to_site 가 같은 site_id 값이면서     "PLANT"사이트 일때는 eng_from_site컬럼의 값을 [plant_id + '~***'] -> [plant_id + '~002'] 로 변경
        -----------------------------------------------------------             
        UPDATE scm_mst_bod_eng
        --SET  eng_from_site = from_site + '~002' 
		-- 20240617 KSG : Inner Site 기준을 PI 요청으로 company_id 기준으로 변경함
        SET eng_from_site =    CASE WHEN b.operation_group  = 'E' AND ISNULL(b.osp_yn, 'N') = 'N' AND ( dbo.FN_SCM_SYS_NVL(b.company_id, '0') <> dbo.FN_SCM_SYS_NVL(c.company_id, '0') OR c.site_type ='SALES' ) THEN a.from_site + '~003'
                                    WHEN b.operation_group  = 'E' AND ISNULL(b.osp_yn, 'N') = 'N' AND  dbo.FN_SCM_SYS_NVL(b.company_id, '0') = dbo.FN_SCM_SYS_NVL(c.company_id, '1')  THEN a.from_site + '~002'
                                    ELSE a.eng_from_site  --20181001 추가                                
                               END
		/*					   
        SET eng_from_site =    CASE WHEN b.operation_group  = 'E' AND ISNULL(b.osp_yn, 'N') = 'N' AND ( dbo.FN_SCM_SYS_NVL(b.site_id, '0') <> dbo.FN_SCM_SYS_NVL(c.site_id, '0') OR c.site_type ='SALES' ) THEN a.from_site + '~003'
                                    WHEN b.operation_group  = 'E' AND ISNULL(b.osp_yn, 'N') = 'N' AND  dbo.FN_SCM_SYS_NVL(b.site_id, '0') = dbo.FN_SCM_SYS_NVL(c.site_id, '1')  THEN a.from_site + '~002'
                                    ELSE a.eng_from_site  --20181001 추가                                
                               END
							   */
        FROM  scm_mst_bod_eng a
              INNER JOIN scm_mst_site_eng b  
              ON   a.modeling_id   = b.modeling_id 
              AND  a.plan_id       = b.plan_id
              AND  a.plan_type     = b.plan_type
              AND  a.plan_seq      = b.plan_seq 
              AND  a.division_id   = b.division_id 
              AND  a.from_site     = b.scm_site_id 
              AND  a.eng_from_site = b.eng_scm_site_id
              AND  b.site_type     = 'PLANT' 
              AND  b.valid_yn      = 'Y'
              AND  b.operation_group = 'E' -- 20180629 수정 --AND  b.operation_group IN  ('E', 'A' )
              
             INNER JOIN scm_mst_site_eng c 
             ON   a.modeling_id   = c.modeling_id 
             AND  a.plan_id       = c.plan_id
             AND  a.plan_type     = c.plan_type
             AND  a.plan_seq      = c.plan_seq 
             AND  a.division_id   = c.division_id 
             AND  a.to_site       = c.scm_site_id 
             AND  a.eng_to_site   = c.eng_scm_site_id
             AND  c.valid_yn      = 'Y'       

        WHERE   a.modeling_id = @p_modeling_id 
        AND     a.plan_id     = @p_plan_id
        AND     a.plan_type   = @p_plan_type
        AND     a.plan_seq    = @p_plan_seq 
        AND     a.division_id = @p_division_id 
        ;

        -----------------------------------------------------------
        -- 1-4) 가상 BOD 추가 (전극후공정:SLiTTING, 가상SALES), 2024.11.07 주석 추가
        -----------------------------------------------------------
        --    전극 일때 : -1) eng_to_site 가 [plant_id + '~002'] 인 BOD 생성
        --                -2) eng_to_site 가 [plant_id + '~003'] 인 BOD 생성 
        
        --    가상 SALES site 일때 :  -1) eng_to_site 가 [plant_id + '-A-S~EXW'] 인 BOD 생성 
        
        -- 20180629 셀은 사용안함
        --    셀   일때 : -1) eng_to_site 가 [plant_id + '~001'] 인 BOD 생성
        --                -2) eng_to_site 가 [plant_id + '~002'] 인 BOD 생성
        --                -3) eng_to_site 가 [plant_id + '~003'] 인 BOD 생성
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_SET_BOD_ENG */ scm_mst_bod_eng
        (   modeling_id, plan_id, plan_type, plan_seq, division_id
            , bod_id, bod_type, from_site, eng_from_site, pol, pod
            , hub_sloc, to_site, eng_to_site, incoterms, transport_mode, priority
            , period_shipsch_mon, period_shipsch_tue, period_shipsch_wed, period_shipsch_thu
            , period_shipsch_fri, period_shipsch_sat, period_shipsch_sun
            , freight_forwarder, safety_stock, period1_lt, pol_clearance_lt
            , period2_lt, pod_clearance_lt, period3_lt, customer_lt, valid_yn
            , created_by, creation_date, last_updated_by, last_update_date
            , attribute1
            , attribute2, attribute3, attribute4, attribute5
            , attribute6, attribute7, attribute8, attribute9, attribute10
        )
        SELECT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq, @p_division_id
             
             , 'x::'
               +
               CASE WHEN b.operation_group = 'E' AND c.gubun = 1 THEN b.scm_site_id + '~002'
                    WHEN b.operation_group = 'E' AND c.gubun = 2 THEN b.scm_site_id + '~003'
                    -- 가상 SALES site 
                    WHEN b.operation_group = 'A' AND c.gubun = 1 THEN b.scm_site_id + '~***'
                    
               END               
               + '::' 
               + CONVERT(NVARCHAR(100), ROW_NUMBER() OVER ( ORDER BY b.scm_site_id)) 
               AS bod_id
             
             , 'PRODUCTION' AS bod_type
             , b.scm_site_id
             
             , CASE WHEN b.operation_group = 'E' ANd c.gubun = 1 THEN b.scm_site_id + '~***'
                    WHEN b.operation_group = 'E' ANd c.gubun = 2 THEN b.scm_site_id + '~002' 
                    -- 가상 SALES site 
                    WHEN b.operation_group = 'A' AND c.gubun = 1 THEN b.scm_site_id + '~***'
               END AS eng_from_site

             , 0 AS pol, 0 AS pod, 'N' AS hub_sloc
             
             , CASE WHEN b.operation_group = 'A' AND c.gubun = 1 THEN b.scm_site_id + '-S'
                    ELSE  b.scm_site_id 
               END AS to_site
             
             , CASE WHEN b.operation_group = 'E' ANd c.gubun = 1 THEN b.scm_site_id + '~002'
                    WHEN b.operation_group = 'E' ANd c.gubun = 2 THEN b.scm_site_id + '~003'
                    -- 가상 SALES site 
                    WHEN b.operation_group = 'A' AND c.gubun = 1 THEN b.scm_site_id + '-S~EXW'
               END AS eng_to_site
             
             , 'EXW' AS incoterms, 'TRK' transport_mode, 1 priority, 'Y' AS period_shipsch_mon, 'Y' AS period_shipsch_tue
             , 'Y' AS period_shipsch_wed, 'Y' AS period_shipsch_thu, 'Y' AS period_shipsch_fri, 'Y' AS period_shipsch_sat, 'Y' AS period_shipsch_sun
             , NULL AS freight_forwarder, 0 AS safety_stock, 0 AS period1_lt, 0 AS pol_clearance_lt, 0 AS period2_lt
             , 0 AS pod_clearance_lt, 0 AS period3_lt, 0 AS customer_lt, 'Y' AS valid_yn, 'scp_batch' AS created_by
             , GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date             
             --20180330 추가 공장내부/공장외부 구분	     
             --              공장내부 :  BOD의 from site 와 to site 가 같은  site_id (또는 company_id)이면서 to site가 Sales site 가 아닐때
             --              to site => 1) ~001 : INNER_SITE_001, 2) ~002 : INNER_SITE_002
             , CASE WHEN b.operation_group = 'E' ANd c.gubun = 1 THEN 'INNER_SITE_E_002'
                    WHEN b.operation_group = 'E' ANd c.gubun = 2 THEN 'INNER_SITE_E_003'
                    -- 가상 SALES site 
                    WHEN b.operation_group = 'A' AND c.gubun = 1 THEN 'OUTER_SITE_S_EXW' -- 'OUTER_SITE'
               END AS attribute1             
             , NULL AS attribute2, NULL AS attribute3
			 , @p_plan_name AS attribute4       --2021.07.14 추가
			 , @v_add_pet_date AS attribute5    --2021.08.26 수정(@v_pet_date -> @v_add_pet_date)			
			 , NULL AS attribute6, NULL AS attribute7, NULL AS attribute8, NULL AS attribute9
             , CASE WHEN b.operation_group = 'E' ANd c.gubun = 1 THEN 2 -- E~*** => E~002 전극 Coating과 Slitting 사이 LT 적용 => Proc BOD 에서 Item별 설정값 Update함
                    WHEN b.operation_group = 'E' ANd c.gubun = 2 THEN 0 -- E~002 => E~003
                    -- 가상 SALES site 
                    WHEN b.operation_group = 'A' AND c.gubun = 1 THEN 0 
               END AS attribute10 -- Attribute10에 LT 적용
        FROM   ( SELECT DISTINCT 
                        modeling_id, plan_id, plan_type, plan_seq, division_id
                     ,  scm_site_id, operation_group
                     ,  osp_yn --20181001추가
                 FROM   scm_mst_site_eng WITH (NOLOCK) 
                 WHERE  modeling_id = @p_modeling_id --'4'
                 AND    plan_id     = @p_plan_id     --'1032'
                 AND    plan_type   = @p_plan_type   --'PR'
                 AND    plan_seq    = @p_plan_seq    --1 
                 --AND    division_id = @p_division_id --'EE'     
                 AND    site_type   = 'PLANT'          
               ) b 
               
           ,   (SELECT 1 gubun UNION ALL SELECT 2 gubun UNION ALL SELECT 3 gubun) c
        WHERE  (( b.operation_group = 'E' AND c.gubun <= 2 )
                 OR 
                ( b.operation_group = 'A' AND c.gubun = 1))
        AND    ISNULL(b.osp_yn, 'N') = 'N'  --20181001 추가  외주 전극 제외처리
        ;
        -----------------------------------------------------------
        -- 2. BOD Item Eng 정보 생성
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_EE_FN_SET_BOD_ENG */
        FROM  scm_mst_bod_item_eng
        WHERE 1=1
        AND   plan_id     = @p_plan_id
        AND   modeling_id = @p_modeling_id
        AND   plan_type   = @p_plan_type
        AND   plan_seq    = @p_plan_seq
        ;
        
        -- 20180910 (사용안함, scm_mst_bod_item 테이블 사용안함) 

        -----------------------------------------------------------
        -- 2-2)-1 정상 BOD Item Eng 정보 생성 : BOD와 동일한 정보
        --      - 20180910 수정 "ITEM BOD 자동생성 관련 수정" (scp_mst_bod_item  테이블 내용 적용)
        --      - 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
		--                 Attribute2 에 VMI 전진검사 LT 추가
        -----------------------------------------------------------
		INSERT INTO  /* PR_SCP_ENG_IN_PRE_SET_BOD_ENG */ scm_mst_bod_item_eng 
			  (modeling_id, plan_id, plan_type, plan_seq
			  ,division_id, bod_id, item_id
              ,eff_start_date, eff_end_date
              ,safety_stock --20181123 추가
              , valid_yn
			  ,lot_size, frozen_period
              ,attribute1 --20180910 추가(scp_mst_bod_item.priority 값 셋팅)
              ,attribute2 --20200323 VMI 전진검사 LT
			  ,created_by, creation_date, last_updated_by, last_update_date
			  )
        SELECT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
             , a.division_id, a.bod_id, a.item_id
             , a.eff_start_date, a.eff_end_date
             , a.safety_stock --20181123 추가
             , 'Y' AS valid_yn
             , NULL AS lot_site, NULL AS frozen_period
             , a.priority             AS attribute1
             , a.lt_day               AS attribute2 --20200323 VMI 전진검사 LT : 임의생성BOD 는 0처리
             , 'scp_batch', GETDATE(), 'scp_batch', GETDATE()
        FROM  (
		       SELECT DISTINCT b.division_id, b.bod_id
                             , b.item_id --fsi.item_id
                             , b.from_yyyymmdd AS eff_start_date, b.to_yyyymmdd As eff_end_date
                             , b.priority
                             , b.safety_stock --20181123 추가
                             , ISNULL(si.lt_day, 0) AS lt_day --20200323 VMI 전진검사 LT : 임의생성BOD 는 0처리
               FROM  (SELECT aa.division_id, aa.bod_id, aa.eng_from_site, aa.eng_to_site
                           --, bb.from_yyyymmdd, bb.to_yyyymmdd
                           /* 2021.07.14 변경 :bod item의 from ~ to와 bod와 항상 동일한 값으로 기준 변경						      
                           */
						   , aa.from_yyyymmdd
						   , aa.to_yyyymmdd
                           , bb.priority, bb.item_id
                           , bb.safety_stock --20181123 추가
                           , aa.from_site, aa.to_site  --20200323 VMI 전진검사 LT
                      FROM  ( SELECT division_id, bod_id, eng_from_site, eng_to_site
                                   , from_site, to_site  --20200323 VMI 전진검사 LT
								   , attribute4  AS from_yyyymmdd  --2021.07.14 추가
								   , attribute5  AS to_yyyymmdd    --2021.07.14 추가
                              FROM   scm_mst_bod_eng WITH (NOLOCK)
                              WHERE  modeling_id = @p_modeling_id
		                      AND    plan_id     = @p_plan_id
		                      AND    plan_type   = @p_plan_type
		                      AND    plan_seq    = @p_plan_seq
                              AND    attribute1 IN ('INNER_SITE', 'OUTER_SITE') --정상 BOD  
                            ) aa 
                            INNER JOIN (SELECT division_id, bod_id, item_id, priority
                                             , IIF(from_yyyymmdd < @p_plan_name, @p_plan_name, from_yyyymmdd) AS from_yyyymmdd                                             
                                             --20181018 수정( 플랜종료일-> th_eng_bucket_info_sn.end_dttm (descr='ADD')의 최종일-1일 로 변경 )
                                             --, IIF(to_yyyymmdd   > @v_bucket_pre_end_date , @v_bucket_pre_end_date, to_yyyymmdd)   AS to_yyyymmdd -- 20181018 수정(변경전 : , IIF(to_yyyymmdd   > @v_pet_date , @v_pet_date, to_yyyymmdd)   AS to_yyyymmdd )
                                             , to_yyyymmdd     -- 20181018 수정(변경전 : , IIF(to_yyyymmdd   > @v_pet_date , @v_pet_date, to_yyyymmdd)   AS to_yyyymmdd )
                                             --, from_yyyymmdd AS from_yyyymmdd_org
                                             --, to_yymmdd     AS to_yyyymmdd_org
                                             , safety_stock --20181123 추가
                                        FROM  (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group ) 
                                                SELECT  b.* 
                                                     , di.attribute3 AS division_group
                                                     , di.attribute4 AS division_comp 
                                                FROM   scp_mst_bod_item  b WITH (NOLOCK)
                                                     , scm_mst_division di WITH(NOLOCK)
                                                WHERE  b.division_id = di.division_id
                                                AND    di.valid_yn    = 'Y'
                                                AND    di.attribute4  = @v_division_comp    -- SAME COMPANY
                                              )  b
                                        WHERE  b.valid_yn = 'Y'
                                        AND    b.division_group IN ('40', '81', '82')  -- 2022.04.04 컬럼변경  
                                        --/* 20181018 변경전 ( 플랜종료일-> th_eng_bucket_info_sn.end_dttm (descr='ADD')의 최종일-1일 로 변경 )
                                        AND    (  ( b.to_yyyymmdd > @p_plan_name AND b.to_yyyymmdd <= @v_pet_date )
                                                  OR
                                                  ( b.from_yyyymmdd >= @p_plan_name AND b.from_yyyymmdd <= @v_pet_date )
                                                  OR
                                                  ( @p_plan_name >= b.from_yyyymmdd AND @v_pet_date <= b.to_yyyymmdd  )
                                               )
                                               
                                        /* 20220404 변경전 
                                        FROM   scp_mst_bod_item  WITH (NOLOCK)
                                        WHERE  valid_yn = 'Y'
                                        --AND    division_id = @p_division_id -- 'EE' --20180910 주석처리
                                        AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                        
                                        --/* 20181018 변경전 ( 플랜종료일-> th_eng_bucket_info_sn.end_dttm (descr='ADD')의 최종일-1일 로 변경 )
                                        AND    (  ( to_yyyymmdd > @p_plan_name AND to_yyyymmdd <= @v_pet_date )
                                                  OR
                                                  ( from_yyyymmdd >= @p_plan_name AND from_yyyymmdd <= @v_pet_date )
                                                  OR
                                                  ( @p_plan_name >= from_yyyymmdd AND @v_pet_date <= to_yyyymmdd  )
                                               )
                                        --*/
                                        --20181018 수정 ( 플랜종료일-> th_eng_bucket_info_sn.end_dttm (descr='ADD')의 최종일-1일 로 변경 )
                                         --AND   (  ( to_yyyymmdd > @p_plan_name AND to_yyyymmdd <= @v_bucket_pre_end_date )
                                         --         OR
                                         --         ( from_yyyymmdd >= @p_plan_name AND from_yyyymmdd <= @v_bucket_pre_end_date )
                                         --         OR
                                         --         ( @p_plan_name >= from_yyyymmdd AND @v_bucket_pre_end_date <= to_yyyymmdd  )
                                         --      ) 
                                         */
                                       ) bb
                            ON   aa.bod_id = bb.bod_id + '::x::x' 		                          
		             ) b
                     -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
                     --            VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 ETA에 더해 줌
                     LEFT OUTER JOIN (
                                      SELECT s.division_id, s.scm_site_id, s.item_id
                                           , MAX(ISNULL(s.scp_vmi_lt, 0)) AS lt_day
                                      FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group ) 
                                              SELECT S.* , di.attribute3 AS division_group  , di.attribute4 AS division_comp  
                                              FROM   scm_mst_site_item s WITH(NOLOCK)
                                                   , scm_mst_division di WITH(NOLOCK)
                                              WHERE  di.division_id = s.division_id
                                              AND    di.valid_yn    = 'Y' 
                                              AND    di.attribute4  = @v_division_comp  -- Same Company 
                                            ) s
                                          INNER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                                          ON  s.division_id  = md.segment1
                                          AND s.scm_site_id  = md.segment2
                                          AND s.division_group  IN ( '40', '81', '82')  -- 2022.04.04 컬럼변경
                                          AND md.lookup_type = 'VMI_LT_SITE'
                                          AND s.valid_yn     = 'Y'
                                          AND md.valid_yn    = 'Y'
                                      GROUP BY s.division_id, s.scm_site_id, s.item_id
                                      /* 20220404 변경전 
                                      SELECT s.division_id, s.scm_site_id, s.item_id
                                           , MAX(ISNULL(s.scp_vmi_lt, 0)) AS lt_day
                                      FROM   scm_mst_site_item s WITH(NOLOCK)
                                             INNER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                                      ON  s.division_id  = md.segment1
                                      AND s.scm_site_id  = md.segment2
                                      AND s.division_id  IN ( '40', '81', '82')   
                                      AND md.lookup_type = 'VMI_LT_SITE'
                                      AND s.valid_yn     = 'Y'
                                      AND md.valid_yn    = 'Y'
                                      GROUP BY s.division_id, s.scm_site_id, s.item_id
                                      */ 
                                     ) si
                     ON  b.division_id = si.division_id
                     AND b.to_site     = si.scm_site_id
                     AND b.item_id     = si.item_id

                    ,(SELECT *
		              FROM  scm_mst_site_eng WITH (NOLOCK) 
		              WHERE plan_id     = @p_plan_id
		              AND   modeling_id = @p_modeling_id
		              AND   plan_type   = @p_plan_type
		              AND   plan_seq    = @p_plan_seq              
		             ) fs 
                    ,(SELECT *
		              FROM  scm_mst_site_eng WITH (NOLOCK) 
		              WHERE plan_id     = @p_plan_id
		              AND   modeling_id = @p_modeling_id
		              AND   plan_type   = @p_plan_type
		              AND   plan_seq    = @p_plan_seq              
		             ) ts 
                    ,(SELECT *
		              FROM  scm_mst_site_item_eng WITH (NOLOCK) 
		              WHERE plan_id     = @p_plan_id
		              AND   modeling_id = @p_modeling_id
		              AND   plan_type   = @p_plan_type
		              AND   plan_seq    = @p_plan_seq   
                      AND   ( attribute10 IS NULL OR attribute10 = '' OR (attribute10 <> 'A' AND attribute10 <> 'E')) --20180823 수정 ( 변경전 : AND   ( attribute10 IS NULL OR attribute10 = '' OR attribute10 <> 'A' OR attribute10 <> 'E') --scm_mst_site_item_eng 생성시 임의로 생성된 팩사이트 item은 BOD item eng 생성시 제외시킴)
		             ) fsi 
                    ,(SELECT *
		              FROM  scm_mst_site_item_eng WITH (NOLOCK) 
		              WHERE plan_id     = @p_plan_id
		              AND   modeling_id = @p_modeling_id
		              AND   plan_type   = @p_plan_type
		              AND   plan_seq    = @p_plan_seq              
		             ) tsi 
               WHERE  b.division_id   = @p_division_id
               AND    b.division_id   = fs.division_id
               AND    b.division_id   = ts.division_id
               AND    b.division_id   = fsi.division_id
               AND    b.division_id   = tsi.division_id
               AND    b.eng_from_site = fs.eng_scm_site_id
               AND    b.eng_to_site   = ts.eng_scm_site_id
               AND    b.eng_from_site = fsi.eng_scm_site_id
               AND    b.eng_to_site   = tsi.eng_scm_site_id
               AND    fsi.item_id     = tsi.item_id
               AND    b.item_id       = fsi.item_id  -- 20180910 추가
			   
              ) a
        ;

        -----------------------------------------------------------
        -- 2-2)-2) 임의생성 BOD Item Eng 정보 생성 
        --      - 임의생성BOD : 위 1-4)에서 추가 생성한 BOD
        --      - 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
		--                 Attribute2 에 VMI 전진검사 LT 추가 : 임의생성BOD 는 0처리
        -----------------------------------------------------------
		INSERT INTO  /* PR_SCP_ENG_EE_FN_SET_BOD_ENG */ scm_mst_bod_item_eng
			  ( modeling_id, plan_id, plan_type, plan_seq
			  , division_id, bod_id, item_id
              , eff_start_date, eff_end_date, valid_yn
			  , lot_size, frozen_period
              , attribute1 --20180910 추가(scp_mst_bod_item.priority 값 셋팅)
              , attribute2 --20200323 VMI 전진검사 LT
			  , created_by, creation_date, last_updated_by, last_update_date
			  )
        SELECT @p_modeling_id AS modeling_id, @p_plan_id AS plan_id, @p_plan_type AS plan_type, @p_plan_seq AS plan_seq
             , @p_division_id --, a.division_id
             , a.bod_id, a.item_id
             , @p_plan_name AS eff_start_date             
             --, @v_bucket_pre_end_date AS eff_end_date  --20181018 수정( 플랜종료일-> th_eng_bucket_info_sn.end_dttm (descr='ADD')의 최종일-1일 로 변경 ) (변경전 : , @v_pet_date AS eff_end_date )
             --, CONVERT(NVARCHAR(8), DATEADD(dd, 13 * 7, CONVERT(DATETIME, @v_pet_date)), 112) AS eff_end_date  --20181018 수정( 플랜종료일 + 13주(13*7) 로 변경 ) (변경전 : , @v_pet_date AS eff_end_date )
             , @v_add_pet_date AS eff_end_date  --2021.08.26 수정 (변수로 처리)
             , 'Y'  AS valid_yn
             , NULL AS lot_size, NULL AS frozen_period
             , NULL AS attribute1 --20180910 추가(scp_mst_bod_item.priority 값 셋팅)
             , 0    AS attribute2 --20200323 VMI 전진검사 LT : 임의생성BOD 는 0처리
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
        FROM  (
		       SELECT DISTINCT b.division_id, b.bod_id, fsi.item_id
               FROM  (SELECT *
                      FROM  scm_mst_bod_eng WITH (NOLOCK) 
		              WHERE 1 = 1
                      AND    plan_id     = @p_plan_id
		              AND   modeling_id = @p_modeling_id
		              AND   plan_type   = @p_plan_type
		              AND   plan_seq    = @p_plan_seq 
                      AND   attribute1  NOT IN ( 'INNER_SITE', 'OUTER_SITE')  --정상 BOD가 아닐때 (참고: 위 주석 '1-1' ~ '1-4' scm_mst_bod_eng.attribute1 셋팅부분 참고 )
		             ) b 
                    ,(SELECT *
		              FROM  scm_mst_site_eng WITH (NOLOCK) 
		              WHERE plan_id     = @p_plan_id
		              AND   modeling_id = @p_modeling_id
		              AND   plan_type   = @p_plan_type
		              AND   plan_seq    = @p_plan_seq              
		             ) fs 
                    ,(SELECT *
		              FROM  scm_mst_site_eng WITH (NOLOCK) 
		              WHERE plan_id     = @p_plan_id
		              AND   modeling_id = @p_modeling_id
		              AND   plan_type   = @p_plan_type
		              AND   plan_seq    = @p_plan_seq              
		             ) ts 
                    ,(SELECT *
		              FROM  scm_mst_site_item_eng WITH (NOLOCK) 
		              WHERE plan_id     = @p_plan_id
		              AND   modeling_id = @p_modeling_id
		              AND   plan_type   = @p_plan_type
		              AND   plan_seq    = @p_plan_seq   
                      AND   ( attribute10 IS NULL OR attribute10 = '' OR (attribute10 <> 'A' AND attribute10 <> 'E')) --2018.08.24 scm_mst_site_item_eng 생성시 임의로 생성된 팩/셀 site item은 BOD item eng 생성시 제외시킴
		             ) fsi 
                    ,(SELECT *
		              FROM  scm_mst_site_item_eng WITH (NOLOCK) 
		              WHERE plan_id     = @p_plan_id
		              AND   modeling_id = @p_modeling_id
		              AND   plan_type   = @p_plan_type
		              AND   plan_seq    = @p_plan_seq              
		             ) tsi 
               WHERE  b.division_id   = @p_division_id
               AND    b.division_id   = fs.division_id
               AND    b.division_id   = ts.division_id
               AND    b.division_id   = fsi.division_id
               AND    b.division_id   = tsi.division_id
               AND    b.eng_from_site = fs.eng_scm_site_id
               AND    b.eng_to_site   = ts.eng_scm_site_id
               AND    b.eng_from_site = fsi.eng_scm_site_id
               AND    b.eng_to_site   = tsi.eng_scm_site_id
               AND    fsi.item_id     = tsi.item_id
			   EXCEPT
			   SELECT DISTINCT division_id, bod_id, item_id
               FROM  scm_mst_bod_item_eng WITH (NOLOCK) 
		       WHERE plan_id     = @p_plan_id
		       AND   modeling_id = @p_modeling_id
		       AND   plan_type   = @p_plan_type
		       AND   plan_seq    = @p_plan_seq    
              ) a
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		/* 사용자 정의 컬럼 추가 사용, 2021.08.26 수정
		   attribute4 : 1순위 경로 순서
		   attribute5 : 최종 1순위 경로 표시
		   attribute6 : ORG BOD 우선순위 표시
        */
		UPDATE a
		   SET a.attribute4 = CONVERT(VARCHAR, b.seq1)
		     , a.attribute5 = CASE WHEN b.seq1  = 1 THEN '1'
			                       ELSE 'X'
							   END
		     , a.attribute6 = b.priority
		 FROM scm_mst_bod_item_eng a
		  , (
			SELECT b.bod_id
				 , a.item_id
				 , b.from_site
				 , b.to_site
				 , b.incoterms
				 , b.transport_mode
				 , a.eff_start_date
				 , a.eff_end_date
				 , b.priority
				 , ROW_NUMBER() OVER(PARTITION BY a.item_id, b.from_site, b.to_site, b.incoterms, a.eff_start_date
	 									 ORDER BY b.priority, a.eff_end_date) AS seq1
			  FROM scm_mst_bod_item_eng a WITH(NOLOCK)
				 , scm_mst_bod_eng b WITH(NOLOCK)
			 WHERE a.division_id = @p_division_id
			   AND a.plan_id     = @p_plan_id
			   AND a.plan_type   = @p_plan_type
			   AND a.plan_seq    = @p_plan_seq
			   AND b.division_id = a.division_id
			   AND b.plan_id     = a.plan_id
			   AND b.plan_type   = a.plan_type
			   AND b.plan_seq    = a.plan_seq
			   AND b.bod_id      = a.bod_id
			   /* 정상 BOD만 */
			   AND dbo.fn_scm_split(b.bod_id, 1, '::') <> 'x'
			) b
		WHERE a.division_id = @p_division_id 
		  AND a.plan_id     = @p_plan_id
		  AND a.plan_type   = @p_plan_type
		  AND a.plan_seq    = @p_plan_seq
		  AND a.bod_id  = b.bod_id
		  AND a.item_id = b.item_id
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'UPDATE BOD ITEM ENG '; 
        SET @v_description = N'BOD Item : 1순위 경로1...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

		/* attribute5 기간별 최종 1순위 경로1 update, 2021.08.26, 수정/보완
		   case#1. 동일그룹구간(eff_start_date, eff_end_date)이 아닌, 기간 중첩시, 빠른 eff_start_date 순위로 정렬시
		           작은 eff_start_date의 bod 우선순위가 높을때, 작은 eff_start_date의 bod를 제외한 해당 bod는 1순위 우선순위에서 제외
				   (데이터 정의 :  eff_start_date <  next eff_start_date
				               and eff_end_date   >= next eff_end_date
							   --and priory         <  next prioriy   (우선순위값이 작은게 우선순위가 높음)
				   ) 이런 경우는 eff start date가 빠른 bod로 엔진은 경로 설정
		*/
		WITH vw_scm_mst_bod_item_eng AS (
											SELECT *
											  FROM
												(
												SELECT b.bod_id
													, a.item_id
													, b.eng_from_site
													, b.from_site
													, b.to_site
													, b.eng_to_site
													, b.incoterms
													, b.transport_mode
													, a.eff_start_date
													, a.eff_end_date
													, a.attribute1
													, a.attribute2
													, a.attribute3
													, a.attribute4
													, a.attribute5
													, a.attribute6
													, b.attribute10
													, LEAD(a.eff_start_date) OVER(PARTITION BY  a.item_id
																							  , b.from_site
																							  , b.to_site
																							  , b.incoterms
																						ORDER BY a.eff_start_date
																							  , b.priority) next_start_date
													, LEAD(a.eff_end_date) OVER(PARTITION BY  a.item_id
																						    , b.from_site
																							, b.to_site
																							, b.incoterms
																					ORDER BY a.eff_start_date
																						   , b.priority) next_end_date
													, LEAD(a.attribute6) OVER(PARTITION BY a.item_id
																						 , b.from_site
																					     , b.to_site
																						 , b.incoterms
																				  ORDER BY a.eff_start_date
																						 , b.priority) next_priority
												 FROM scm_mst_bod_item_eng a WITH(NOLOCK)
													, scm_mst_bod_eng b WITH(NOLOCK)
												WHERE a.division_id = @p_division_id
												  AND a.plan_id       = @p_plan_id
												  AND a.plan_type     = @p_plan_type
												  AND a.plan_seq      = @p_plan_seq
												  AND b.division_id   = a.division_id
												  AND b.plan_id       = a.plan_id
												  AND b.plan_type     = a.plan_type
												  AND b.plan_seq      = a.plan_seq
												  AND b.bod_id        = a.bod_id
												  AND a.attribute5    = '1'
												) a
								  /* 동일조건의 기간이 eff_start_date 정렬기준으로 */
								  WHERE a.eff_start_date < a.next_start_date
									AND a.eff_end_date  >= a.next_end_date
									AND a.attribute6     < a.next_priority    
						        )
		UPDATE a
			SET a.attribute5 = 'X'
			FROM scm_mst_bod_item_eng a
				, (
				SELECT a.bod_id
					FROM scm_mst_bod_item_eng a WITH(NOLOCK)
					, scm_mst_bod_eng b WITH(NOLOCK)
					WHERE a.division_id  = @p_division_id
					AND a.plan_id     = @p_plan_id
					AND a.plan_type   = @p_plan_type
					AND a.plan_seq    = @p_plan_seq
					AND b.division_id = a.division_id
					AND b.plan_id     = a.plan_id
					AND b.plan_type   = a.plan_type
					AND b.plan_seq    = a.plan_seq
					AND b.bod_id      = a.bod_id
					AND a.attribute5  = '1'
					AND EXISTS (SELECT 'X'
								  FROM vw_scm_mst_bod_item_eng x WITH(NOLOCK) --1순위 엔진 경로 bod
								 WHERE x.eng_from_site = b.eng_from_site
								   AND x.eng_to_site   = b.eng_to_site
								   AND x.incoterms     = b.incoterms
								   AND x.item_id       = a.item_id
								   AND x.eff_start_date < a.eff_start_date
								   AND x.bod_id       != a.bod_id
								)	 
				) b
			WHERE a.division_id = @p_division_id 
			  AND a.plan_id     = @p_plan_id
			  AND a.plan_type   = @p_plan_type
			  AND a.plan_seq    = @p_plan_seq
			  AND a.attribute5  = '1'
			  AND a.bod_id      = b.bod_id
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'UPDATE BOD ITEM ENG '; 
        SET @v_description = N'BOD Item : 1순위 경로2...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
 		
        /* attribute5 기간별 최종 1순위 경로1 update, 2021.08.26, 수정/보완
		   case#2. 동일그룹구간(eff_start_date, eff_end_date)이 아닌, 기간 중첩시, 빠른 eff_start_date 순위로 정렬시
		           빠른 eff_start_date의 bod 우선순위가 낮을때, 작은 eff_start_date의 bod의 eff_end_date를 우선순위 높은 bod의 eff_end_date 이전일자로 변경
				   (데이터 정의 :  eff_start_date <  next eff_start_date
				               and eff_end_date   =  next eff_end_date
							   and priory         >  next prioriy   (우선순위값이 작은게 우선순위가 높음)
		*/				
		WITH vw_scm_mst_bod_item_eng AS (
										   SELECT *
											FROM
												(
												SELECT b.bod_id
													, a.item_id
													, b.eng_from_site
													, b.from_site
													, b.to_site
													, b.eng_to_site
													, b.incoterms
													, b.transport_mode
													, a.eff_start_date
													, a.eff_end_date
													, a.attribute1
													, a.attribute2
													, a.attribute3
													, a.attribute4
													, a.attribute5
													, a.attribute6
													, b.attribute10
													, LEAD(a.eff_start_date) OVER(PARTITION BY a.item_id
																								, b.from_site
																								, b.to_site
																								, b.incoterms
																						ORDER BY a.eff_start_date
																								, b.priority) next_start_date
													, LEAD(a.eff_end_date) OVER(PARTITION BY a.item_id
																							, b.from_site
																							, b.to_site
																							, b.incoterms
																					ORDER BY a.eff_start_date
																								, b.priority) next_end_date
													, LEAD(a.attribute6) OVER(PARTITION BY  a.item_id
																							, b.from_site
																							, b.to_site
																							, b.incoterms
																					ORDER BY a.eff_start_date
																							, b.priority) next_priority
													, CONVERT(VARCHAR(8), DATEADD(DAY, -1, LEAD(a.eff_start_date) OVER(PARTITION BY  a.item_id
																																	, b.from_site
																																	, b.to_site
																																	, b.incoterms
																															ORDER BY a.eff_start_date
																																	, b.priority
																															))																							   
																								, 112) update_end_date
												 FROM scm_mst_bod_item_eng a WITH(NOLOCK)
													, scm_mst_bod_eng b WITH(NOLOCK)
												WHERE a.division_id = @p_division_id
												  AND a.plan_id       = @p_plan_id
												  AND a.plan_type     = @p_plan_type
												  AND a.plan_seq      = @p_plan_seq
												  AND b.division_id   = a.division_id
												  AND b.plan_id       = a.plan_id
												  AND b.plan_type     = a.plan_type
												  AND b.plan_seq      = a.plan_seq
												  AND b.bod_id        = a.bod_id
												  AND a.attribute5  = '1'
												--AND b.from_site   = 'A010-A'
												--AND b.to_site     = 'Proterra_US_BGI'
												--AND a.item_id     = 'MCCE133512N1'
												) a
										/* 동일조건의 기간 중첩시 우선순위가 높은 경우 */
									  WHERE a.eff_start_date < a.next_start_date
										AND a.eff_end_date   = a.next_end_date
										AND a.attribute6    >= a.next_priority    
										AND a.update_end_date IS NOT NULL  
									)
		 UPDATE a
			SET a.eff_end_date = b.update_end_date
		   FROM scm_mst_bod_item_eng a
			  , vw_scm_mst_bod_item_eng b
		  WHERE a.division_id = @p_division_id 
			AND a.plan_id     = @p_plan_id
			AND a.plan_type   = @p_plan_type
			AND a.plan_seq    = @p_plan_seq
			AND a.attribute5  = '1'
			AND a.bod_id      = b.bod_id
		;
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'UPDATE BOD ITEM ENG '; 
        SET @v_description = N'BOD Item : 1순위 중첩경로1...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        /* attribute5 기간별 최종 1순위 경로1 update, 2021.08.26, 수정/보완
		   case#3. 동일그룹구간(eff_start_date, eff_end_date)이 아닌, 기간 중첩시, 빠른 eff_start_date 순위로 정렬시
		           빠른 eff_start_date의 bod 우선순위가 낮을때, 늦은 eff_start_date의 bod의 eff_start_date를 우선순위 높은 bod의 eff_end_date 이후일자로 변경
				   (데이터 정의 :  eff_start_date >  pre eff_start_date
				               and eff_start_date <  pre eff_end_date
							   and priory         >  pre prioriy   (우선순위값이 작은게 우선순위가 높음)
		*/				
		WITH vw_scm_mst_bod_item_eng AS (
										   SELECT *
											 FROM
												(
												SELECT b.bod_id
													, a.item_id
													, b.eng_from_site
													, b.from_site
													, b.to_site
													, b.eng_to_site
													, b.incoterms
													, b.transport_mode
													, a.eff_start_date
													, a.eff_end_date
													, a.attribute1
													, a.attribute2
													, a.attribute3
													, a.attribute4
													, a.attribute5
													, a.attribute6
													, b.attribute10
													, LAG(a.eff_start_date) OVER(PARTITION BY a.item_id
																								, b.from_site
																								, b.to_site
																								, b.incoterms
																						ORDER BY a.eff_start_date
																								, b.priority) pre_start_date
													, LAG(a.eff_end_date) OVER(PARTITION BY a.item_id
																							, b.from_site
																							, b.to_site
																							, b.incoterms
																					ORDER BY a.eff_start_date
																								, b.priority) pre_end_date
													, LAG(a.attribute6) OVER(PARTITION BY  a.item_id
																							, b.from_site
																							, b.to_site
																							, b.incoterms
																					ORDER BY a.eff_start_date
																							, b.priority) pre_priority
													, CONVERT(VARCHAR(8), DATEADD(DAY, 1, LAG(a.eff_end_date) OVER(PARTITION BY  a.item_id
																															   , b.from_site
																															   , b.to_site
																															   , b.incoterms
																														ORDER BY a.eff_start_date
																																, b.priority
																															))																							   
																								, 112) update_start_date
													FROM scm_mst_bod_item_eng a WITH(NOLOCK)
													, scm_mst_bod_eng b WITH(NOLOCK)
												  WHERE a.division_id   = @p_division_id
													AND a.plan_id       = @p_plan_id
													AND a.plan_type     = @p_plan_type
													AND a.plan_seq      = @p_plan_seq
													AND b.division_id   = a.division_id
													AND b.plan_id       = a.plan_id
													AND b.plan_type     = a.plan_type
													AND b.plan_seq      = a.plan_seq
													AND b.bod_id        = a.bod_id
													AND a.attribute5  = '1'
													--AND b.from_site   = 'KR012031-P'
													--AND b.to_site     = 'OMRON_JP_OOO'
													--AND a.item_id     = 'EH103064P8S2'
												) a
											/* 동일조건의 기간 중첩시 상위 우선순위가 높은 경우 */
											WHERE a.eff_start_date > a.pre_start_date
											  AND a.eff_start_date < a.pre_end_date
											  AND a.attribute6    >= a.pre_priority    
											  AND a.update_start_date IS NOT NULL
									)
		 UPDATE a
			SET a.eff_start_date = b.update_start_date
		   FROM scm_mst_bod_item_eng a
			  , vw_scm_mst_bod_item_eng b
		  WHERE a.division_id = @p_division_id 
			AND a.plan_id     = @p_plan_id
			AND a.plan_type   = @p_plan_type
			AND a.plan_seq    = @p_plan_seq
			AND a.attribute5  = '1'
			AND a.bod_id      = b.bod_id
		;
		
		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'UPDATE BOD ITEM ENG '; 
        SET @v_description = N'BOD Item : 1순위 중첩경로2...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        /* 순환BOD 삭제. 2024.11.07 추가 */
        /* 삭제 대상 ITEM별 순환 BOD 조회
           정상bod(plant간)
        */
        WITH VW_ITEM_BOD AS (
                 SELECT a.division_id
                      , a.plan_id
                      , a.plan_type
                      , a.plan_seq
                      , b.item_id
                      , a.bod_id
                      , a.bod_type
                      , a.from_site
                      , a.eng_from_site
                      , a.to_site
                      , a.eng_to_site
                      , a.transport_mode
                      , b.attribute6   AS bod_priority  --bod priority로 하면 안 되겠네...(나중에 만들어졌는데, bod 우선순위가 높다)
                      , SUBSTRING(a.bod_id, 1, CHARINDEX('::', a.bod_id)-1) AS org_bod_id
                      , CONVERT(INT, SUBSTRING(a.bod_id, 1, CHARINDEX('::', a.bod_id)-1)) AS bod_seq
                   FROM scm_mst_bod_eng a WITH (NOLOCK) 
                   JOIN scm_mst_bod_item_eng b WITH(NOLOCK)
                     ON a.division_id   = b.division_id
                    AND a.plan_id       = b.plan_id
                    AND a.plan_type     = b.plan_type
                    AND a.plan_seq      = b.plan_seq
                    AND a.bod_id        = b.bod_id
                  WHERE a.division_id   = @p_division_id	
                    AND a.plan_id       = @p_plan_id		
                    AND a.plan_type     = @p_plan_type
                    AND a.plan_seq      = @p_plan_seq
                  --AND b.item_id = 'MCCE125001A2'
                    AND a.bod_type      = 'PLANT'
                    AND a.bod_id NOT LIKE 'x::%'
                  --AND a.bod_id IN  ('13982::x::x', '15708::x::x')
                 ) 
        DELETE a
          FROM scm_mst_bod_item_eng a
          JOIN 
                (
                SELECT a.division_id
                     , a.plan_id
                     , a.plan_type
                     , a.plan_seq
                     , a.item_id
                     , a.bod_Id
                     , b.bod_id         AS del_bod_id
                     , b.eng_from_site  AS del_eng_from_site
                     , b.eng_to_site    AS del_eng_to_site
                     , a.transport_mode
                     , a.seq
                FROM
                    (
                    --1.ITEM별 Recurcive BOD 
                    SELECT a.division_id
                        , a.plan_id
                        , a.plan_type
                        , a.plan_seq
                        , a.item_id
                        , a.bod_id
                        , b.bod_id        AS bod_id2
                        , a.from_site
                        , a.eng_from_site
                        , b.eng_from_site AS eng_from_site2
                        , a.to_site
                        , a.eng_to_site
                        , b.eng_to_site   AS eng_to_site2
                        , a.transport_mode
                        , b.transport_mode AS transport_mod2
                          /* item별 bod 생성 1순위 조회 */
                        , ROW_NUMBER() OVER(PARTITION BY a.item_id
                                                ORDER BY a.bod_seq ) AS seq 
                    FROM VW_ITEM_BOD a
                    JOIN VW_ITEM_BOD b
                      ON a.item_id = b.item_id
                     AND a.eng_from_site = b.eng_to_site
                     AND a.eng_to_site   = b.eng_from_site
                     AND a.bod_id       <> b.bod_id
                    ) a
                JOIN VW_ITEM_BOD b
                  ON a.item_id = b.item_id
                 AND a.eng_from_site = b.eng_to_site
                 AND a.eng_to_site   = b.eng_from_site
               WHERE a.seq = 1  --최초생성된 from/to site bod 기준으로 정리
                ) b
            ON a.division_Id = b.division_Id 
           AND a.plan_type   = b.plan_type
           AND a.plan_id     = b.plan_id
           AND a.plan_seq    = b.plan_seq
           AND a.item_id     = b.item_id
           AND a.bod_id      = b.del_bod_id
        WHERE a.division_id  = @p_division_id
           AND a.plan_id     = @p_plan_id		
           AND a.plan_type   = @p_plan_type
           AND a.plan_seq    = @p_plan_seq
         --AND b.item_id = 'MCCE125001A2'
        ;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'DELETE BOD ITEM ENG '; 
        SET @v_description = N'BOD Item : 순환BOD...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;

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


