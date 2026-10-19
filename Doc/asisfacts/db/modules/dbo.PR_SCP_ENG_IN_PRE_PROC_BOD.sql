
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_BOD
 * Description  : SDB의 BOD 정보를 ODB에 적재되도록 한다.
                   
                  -----------------------------------------------------------
                  -- 1. 활성화 공정 외 BOD  : (A~*** => A~001) 가 아닌 것
                  -----------------------------------------------------------
                     - scm_mst_bod_eng.eng_from_site(A~***) => scm_mst_bod_eng.eng_to_site(A~001) 가 아닌 것

                     - 컬럼1) bod_id :  
                                      -특성BOD 일때   : 'CHAR::' + scm_mst_bod_eng.bod_id (특성CAPA 적용때문에 수정됨, 변경전 : scm_mst_bod_item_eng.item_id + '::' + scm_mst_bod_eng.bod_id)
                                      -특성BOD 아닐때 : scm_mst_bod_item_eng.item_id + '::' + scm_mst_bod_eng.bod_id
                     - 컬럼2) transport_time : scm_mst_bod_eng.attribute10(=BOD Lead Time)
                     - 컬럼3) fixed_term :
                                           경우1) 특성BOD('-A~001' -> '-A~002') 이면서 외주site아니고, 사업부 소형(40)아닐때 : 42 셋팅
                                           경우2) 공장외부(from site와 to site의 site_id가 다를때, 또는 to site가 sales site일때, 또는  from site가 외주site, 또는 to site가 외주site일때) : ISNULL(scm_mst_bod_item_eng.frozen_period, ISNULL(from site의 scm_mst_site_eng.ship_frozen, 0)) (참고 : 모든 scm_mst_bod_item_eng.frozen_period값은 NULL값이다) --  select distinct frozen_period from scm_mst_bod_item_eng WITH (NOLOCK)
                                           경우3) 경우1)과 경우2)를 제외한 모든경우는 0 셋팅
                     - 컬럼4) bod_start_dttm : ISNULL(MIN(scm_mst_bod_item_eng.eff_start_dttm), 플랜시작일(=@p_plan_name))
                                               => eff_start_date(시작일)과 eff_end_date(종료일)이 다른 동일한 item BOD가 존재 할 수 있으므로 (GROUP BY modeling_id, plan_id, plan_seq, plan_type)그룹핑한 MIN(eff_start_date)값 사용함  
                     
                     - 참고 테이블1) scm_mst_bod_eng (plan사용할 BOD정보)
                     - 참고 테이블2) scm_mst_bod_item_eng (plan사용할 item bod 정보) : eff_start_date(시작일)과 eff_end_date(종료일)이 다른 동일한 item BOD가 존재 할 수 있으므로 (GROUP BY modeling_id, plan_id, plan_seq, plan_type)그룹핑한 MIN(eff_start_date)값 사용함

                  -----------------------------------------------------------
                  -- 2. 활성화 공정 LT 정보 Update : A~*** => A~001
                  -----------------------------------------------------------
                     - scm_mst_bod_eng.eng_from_site(A~***) => scm_mst_bod_eng.eng_to_site(A~001)) 일 경우

                     - 컬럼1) bod_id : scm_mst_bod_item_eng.item_id + '::' + scm_mst_bod_eng.bod_id
                     
                     - 컬럼2) transport_time : - from site가 외주site가 아닐때 : ISNULL(scp_mst_formation.lt_formation(=활성화 Lead Time), 21)
                                               - from site가 외주site   일때   : scm_mst_bod_eng.attribute10(=BOD Lead Time)  
                     - 컬럼3) fixed_term     : 0 셋팅
                     - 컬럼4) bod_start_dttm : 플랜시작일(=@p_plan_name)


                     - 참고 테이블1) scm_mst_bod_eng (plan사용할 BOD정보)
                     - 참고 테이블2) scm_mst_bod_item_eng (plan사용할 item bod 정보) : eff_start_date(시작일) : 플랜시작일(=@p_plan_name),  eff_end_date(종료일) :  플랜종료일(=@p_pet_date) + 13주 
                     - 참고 테이블3) scp_mst_formation (SCP용 활성화 정보)

 * OutTable     : TH_ENG_BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.15   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.31   KSG            활성화 LT 처리 수정
 * 2018.06.18   KSG            활성화 LT 처리 수정 : scp_mst_formation 정보 사용
 * 2018.06.26   KSG            특성 계획 3주 반영 : 수정 시 Fixed Plan 도 동시 반영 필요
 * 2018.08.07   KSW            외주셀(TCO 셀) 적용관련 수정 ( 1) 특성(A~001 => A~002) : OSP 는 21주 확정 적용 안 함,  2) 활성화 공정 LT 정보 Update : A~*** => A~001 : OSP는 0(BOD_ENG값) 적용 ) 
 * 2018.08.13   KSW            fixed_term 컬럼 수정 (AND @p_division_id <> '40' 추가)   참고1) [1. 활성화 공정 외 BOD  : (A~*** => A~001) 가 아닌 것]의  fixed_term 컬럼부분
 * 2018.08.17   KSW            fixed_term 컬럼 수정 (특성화공정 Fixed Term 0 적용)
 * 2018.09.10   KSW            BOD ITEM 자동생성 관련 수정 (참고)주석1)
 * 2018.09.28   KSG            특성 계획 6주 반영 : 소형은 적용 안 함 : 수정 시 Fixed Plan 도 동시 반영 필요
 * 2018.12.03   KSW            from site가 외주(scm_mst_site.osp_yn = 'Y')일때도 외부 site로 셋팅(참고)주석1
 * 2018.12.06   KSW            특성 계획 6주 반영안함 : 수정 시 Fixed Plan 도 동시 반영 필요  (참고)주석1  (참고2) SP(DAILY)는 특성계획 반영함
 * 2018.12.11   KSW            (2018.12.06 수정내용 원복) 특성 계획 6주 반영함 : 수정 시 Fixed Plan 도 동시 반영 필요  (참고)주석1
 * 2019.02.18   KSW            특성 CAPA 반영 관련수정 (참고)주석1 (이부분 수정시 1)PROC_BOD, 2)PROC_ITEM_BOD, 3)PROC_FIXED_PLAN, 4)PROC_PRODUCT_MIX, 5)PROC_PRODUCT_MIX_MAP 수정검토필요함)
 * 2021.01.28   KSG            C20210128-000112 SCP - FP 특성계획 동기화 구간 변경 : 기존 6주 → 변경 7주
 * 2021.08.17   KKC			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - Pack 전진검사 LT 추가
 * 2021.09.03   KKC			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - TE버전 FIX PLAN 반영여부 옵션화 구현
 * 2021.11.29   LHS            th_eng_bod의 transport_time < 0 이면 0 으로 변경
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2024.10.07   KKC            PJ20249346   LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화
                               1. 52주통합 적용 plant   
                                  1) from plant 기준의 신규 fp통합 ssp frozen으로 fixed term 설정
                                  2) 특성공정의 fxied term 변경 (기존:7주 하드코딩 / 변경:fp period 기준) <=40사업부 제외
                               2. 기존 plant는 기존 fixed term 로직 유지
                                   1) 단, 특성공정의 fxied term은 공통으로 변경 (기존:7주 하드코딩 / 변경:fp period 기준)
 * 
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_BOD]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_BOD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_BOD';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

	DECLARE @v_te_frozen_yn      NVARCHAR(1);  --2021.09.03 추가
    
    DECLARE @v_division_group    NVARCHAR(30); ---(2022.04.04) 변수추가.
    DECLARE @v_division_comp     NVARCHAR(30); 
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
               
        /*********************************************************************************
		Froze(TE) 여부 체크 및 None Froze 일 경우는 FIXED PLAN 모두 미생성, 2021.09.03 By KKC		
		**********************************************************************************/
		--1. frozen(TE) 여부 Check
		SELECT @v_te_frozen_yn  = ISNULL(a.segment3, 'N')   
		  FROM scm_adm_lookup_master_detail a(nolock)
		 WHERE a.lookup_type = 'SCP_FROZEN_APPLY_YN'
		   AND a.SEGMENT1 = @p_division_id
		   AND a.SEGMENT2 = @p_plan_type
		;

		--2. frozen(TE) 변수 Validation Check
		IF @v_te_frozen_yn IS NULL OR @v_te_frozen_yn != 'N'
			BEGIN
				SET @v_te_frozen_yn = 'Y';
			END
			
		SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-0 START';
        SET @v_description = N'1-0. th_eng_bod_sn DELETE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		DELETE /* PR_SCP_ENG_IN_PRE_PROC_BOD */ 
        FROM  th_eng_bod_sn
        WHERE 1=1
        AND   plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
        ;

        -----------------------------------------------------------
        -- 1. 활성화 공정 외 BOD  : (A~*** => A~001) 가 아닌 것
        -----------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-1 START';
        SET @v_description = N'2-1. Normal BOD의 th_eng_bod_sn INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_BOD */ th_eng_bod_sn
		    ( master_id
		    , plan_id
		    , bod_id
		    , from_site_id
		    , to_site_id
		    , transport_mode
		    , transport_time
		    , transport_time_uom
		    , bod_start_dttm
		    , bod_pattern_id
		    , from_offtime_set_id
		    , to_offtime_set_id
		    , fixed_term
		    , fixed_term_uom
		    , attribute_set_id
		    , attribute_checker_id
		    , is_prev_epst
		    , descr
		    )
		SELECT DISTINCT
               @p_master_id       AS master_id
             , @p_engine_plan_id  AS plan_id
             --특성CAPA관련수정시 1)PROC_BOD, 2)PROC_ITEM_BOD, 3)PROC_FIXED_PLAN, 4)PROC_PRODUCT_MIX, 5)PROC_PRODUCT_MIX_MAP 검토필요
             --20190218 수정 특성CAPA반영관련수정( 특성BOD일때(A~001 -> A~002)일때 'CHAR' + '::' + be.bod_id 로 변경) 
             , CASE WHEN be.attribute1 = 'INNER_SITE_A_002' THEN  'CHAR::' + be.bod_id --특성(A~001 -> A~002, be.attribute1 = 'INNER_SITE_A_002'일때 특성BOD임) BOD일때
                    ELSE bie.item_id + '::' + be.bod_id                     
               END  AS bod_id --20190218수정 ( 변경전 : , bie.item_id + '::' + be.bod_id AS bod_id )
		     , be.eng_from_site                                   AS from_site_id
		     , be.eng_to_site                                     AS to_site_id
		     , be.transport_mode                                  AS transport_mode
             , be.attribute10                                     AS transittime  -- BOD ENG의 Attribute10에 LT 적용
		     , 'DAY'                                              AS transport_time_uom
		     , CONVERT(DATE, ISNULL(bie.eff_start_date, @p_plan_name)) AS bod_start_dttm 
		     , '1D'                                               AS bod_pattern_id
		     , NULL                                               AS from_offtime_set_id
		     , NULL                                               AS to_offtime_set_id             
             -- 특성(A~001 => A~002) 계획 반영용 : 수정 시 Fixed Plan 도 수정 필요함 : 소형은 적용 안 함
             --     : fixed_term컬럼부분 수정시 FIXED_PLAN의 1)BOD특성, 2)SEMI처리부분도 동시반영해야 함
             -- 20210128 C20210128-000112 SCP - FP 특성계획 동기화 구간 변경 : 기존 6주 → 변경 7주
			 -- 20240617 KSG : Inner Site 기준을 PI 요청으로 company_id 기준으로 변경함
             /* 52주 통합fp 출하계획 동기화 frozen 존재시 해당 기간으로 변경 및 특성 FIXED TERM 하드 코딩 제거
              , 2024.10.07 수정
              */
             , CASE 
                    WHEN be.eng_from_site LIKE '%A~001' AND ISNULL(mse.osp_yn, 'N') = 'N'  AND @v_division_group <> '40' THEN ISNULL(mse.fp_plan_period, 0)
                    WHEN (mse.company_id <> mst.company_id) OR (mst.site_type = 'SALES') OR (mst.osp_yn = 'Y') OR (mse.osp_yn ='Y') THEN
                          CASE WHEN CONVERT(INT, mse.attribute4) > 0 THEN  
                                                                           CASE WHEN ISNULL(mse.ship_frozen, 0) < CONVERT(INT, mse.attribute4) THEN CONVERT(INT, mse.attribute4)
                                                                                ELSE ISNULL(mse.ship_frozen, 0) 
                                                                            END
                               --//기존로직 유지
                               ELSE ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0))
                           END
                    ELSE 0
               END                                                AS fixed_term                                
               /* ~ 2024.10.07 ORG
             , CASE 
                    ---2022.04.04 JV사업부 추가 변수변경: @p_division_id -> @v_division_group
                    WHEN be.eng_from_site LIKE '%A~001' AND ISNULL(mse.osp_yn, 'N') = 'N'  AND @v_division_group <> '40' THEN 7*7 
                    WHEN (mse.company_id <> mst.company_id) OR (mst.site_type = 'SALES') OR (mst.osp_yn = 'Y') OR (mse.osp_yn ='Y')  --20181203수정 from site가 외주일때도 외부site이므로 조건에 추가함(변경전 : WHEN (mse.site_id <> mst.site_id) OR (mst.site_type = 'SALES') OR (mst.osp_yn = 'Y') )
                         THEN ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0))
                    ELSE 0
               END                                                AS fixed_term  
               */
		     , 'DAY'                                              AS fixed_term_uom
		     , NULL                                               AS attribute_set_id
		     , NULL                                               AS attribute_checker_id
		     , 'N'                                                AS is_prev_epst
		     , NULL                                               AS descr 
		FROM   scm_mst_bod_eng           be  WITH (NOLOCK)             
             --20180910 수정 (시작~종료일이 다른 동일한 item BOD 존재하므로, 1건만 INSERT해야하므로  MIN(eff_start_date) 처리함) (변경전 : , scm_mst_bod_item_eng      bie WITH (NOLOCK)  )
            , ( SELECT modeling_id, plan_id, plan_seq, plan_type
                     , bod_id, item_id, MIN(frozen_period) AS frozen_period -- 현재는 frozen_period이 'NULL'값이지만 여러값이 입력될 경우를 대비해서 MIN처리함
                     , MIN(eff_start_date) AS eff_start_date
                FROM   scm_mst_bod_item_eng WITH (NOLOCK) 
                WHERE  modeling_id   = @p_modeling_id	
		        AND    plan_id       = @p_plan_id		
		        AND    plan_type     = @p_plan_type
		        AND    plan_seq      = @p_seq
                GROUP BY modeling_id, plan_id, plan_seq, plan_type
                       , bod_id, item_id 
                ) bie --(변경전 : scm_mst_bod_item_eng bie WITH (NOLOCK) )
             , scm_mst_site_eng          mse WITH (NOLOCK) --bod from  site 조인
             , scm_mst_site_eng          mst WITH (NOLOCK) --bod to    site 조인 20180309 추가 
		WHERE  1=1
		  AND  be.modeling_id   = @p_modeling_id	
		  AND  be.plan_id       = @p_plan_id		
		  AND  be.plan_type     = @p_plan_type
		  AND  be.plan_seq      = @p_seq
          -- 활성화 공정 외 BOD  : (A~*** => A~001) 가 아닌 것
		  AND (be.eng_from_site NOT LIKE '%A~***'
		    OR be.eng_to_site   NOT LIKE '%A~001'
              )
		  AND  be.modeling_id   = bie.modeling_id
		  AND  be.plan_id       = bie.plan_id
		  AND  be.plan_type     = bie.plan_type
		  AND  be.plan_seq      = bie.plan_seq
          AND  be.bod_id        = bie.bod_id
		  AND  be.modeling_id   = mse.modeling_id
		  AND  be.plan_id       = mse.plan_id
		  AND  be.plan_type     = mse.plan_type
		  AND  be.plan_seq      = mse.plan_seq
		  AND  be.eng_from_site = mse.eng_scm_site_id --bod from site 조인
          -- 추가 20180309
          AND  be.modeling_id   = mst.modeling_id
		  AND  be.plan_id       = mst.plan_id
		  AND  be.plan_type     = mst.plan_type
		  AND  be.plan_seq      = mst.plan_seq
		  AND  be.eng_to_site   = mst.eng_scm_site_id -- bod to site 조인 
		;

       -----------------------------------------------------------
        -- 2. 활성화 공정 LT 정보 Update : A~*** => A~001
        -----------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-2 START';
        SET @v_description = N'2-2. 활성화 BOD의 th_eng_bod_sn INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

         -- LT(BOD) 반영 필요 : 활성화 공정 LT
		INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_BOD */ th_eng_bod_sn
		    ( master_id
		    , plan_id
		    , bod_id
		    , from_site_id
		    , to_site_id
		    , transport_mode
		    , transport_time
		    , transport_time_uom
		    , bod_start_dttm
		    , bod_pattern_id
		    , from_offtime_set_id
		    , to_offtime_set_id
		    , fixed_term
		    , fixed_term_uom
		    , attribute_set_id
		    , attribute_checker_id
		    , is_prev_epst
		    , descr
		    )
		SELECT DISTINCT
               @p_master_id       AS master_id
             , @p_engine_plan_id  AS plan_id
             , bod.item_id + '::' + bod.bod_id                    AS bod_id
		     , bod.from_site_id                                   AS from_site_id
		     , bod.to_site_id                                     AS to_site_id
		     , bod.transport_mode                                 AS transport_mode
			 
             -- 20180405 수정 transittime => 1.FP, 2. scp 관리값(scm_mst_formation), 3. 중국법인 - 16일 / 그외 ( 폴란드 미국 한국) - 21일
		     -- 2018.05.31   KSG 사이트 구분없이 21일로 적용
			 -- 2018.06.18 : scp_mst_formation 에 Copy 된 정보 사용
             -- 2018.08.07 : OSP는 BOD_ENG값(be.attribute10, 일반적으로 0 으로셋팅되어있음) 적용
             , IIF(ISNULL(bod.osp_yn, 'N') = 'N',  ISNULL(scf.lt_formation, 21) , bod.attribute10)   AS transittime  -- 20180807 수정(변경전 : ISNULL(scf.lt_formation, 21) AS transittime )
           --  , ISNULL(lt.lt, ISNULL( scf.lt_formation, 21
           --                        --, CASE WHEN bod.site_id = 'A002' THEN 16
           --                        --       ELSE 21
           --                        --  END
								   --)
           --          )                                            AS transittime 

		     , 'DAY'                                              AS transport_time_uom
		     , bod.bod_start_dttm                                 AS bod_start_dttm 
		     , '1D'                                               AS bod_pattern_id
		     , NULL                                               AS from_offtime_set_id
		     , NULL                                               AS to_offtime_set_id 
		     , bod.fixed_term                                     AS fixed_term
		     , 'DAY'                                              AS fixed_term_uom
		     , NULL                                               AS attribute_set_id
		     , NULL                                               AS attribute_checker_id
		     , 'N'                                                AS is_prev_epst
		     , NULL                                               AS descr
		FROM (
		      SELECT DISTINCT
               be.bod_id                                          AS bod_id
             , mse.site_id                                        AS site_id -- 국가 구분용
             , bie.item_id                                        AS item_id
		     , be.eng_from_site                                   AS from_site_id
		     , be.eng_to_site                                     AS to_site_id
		     , be.transport_mode                                  AS transport_mode
             , be.attribute10                                     AS transittime  -- BOD ENG의 Attribute10에 LT 적용
		     , 'DAY'                                              AS transport_time_uom
		     , CONVERT(DATE, ISNULL(bie.eff_start_date, @p_plan_name)) AS bod_start_dttm 
             , 0  AS fixed_term --20180410 수정( 변경전 : , ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0) )  AS fixed_term )
             --, 변경전 : CASE WHEN (mse.site_id <> mst.site_id) OR (mst.site_type = 'SALES') OR (mst.osp_yn = 'Y') 
             --            THEN ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0))
             --       ELSE 0
             --  END                                                AS fixed_term
             , be.attribute10  --20180807 외주셀관련 추가
             , mse.osp_yn      --20180807 외주셀관련 추가
              FROM   scm_mst_bod_eng           be  WITH (NOLOCK)
                   , scm_mst_bod_item_eng      bie WITH (NOLOCK)
                   , scm_mst_site_eng          mse WITH (NOLOCK) --bod from  site 조인
                   , scm_mst_site_eng          mst WITH (NOLOCK) --bod to    site 조인 20180309 추가
                   
		      WHERE  1=1
		      AND    be.modeling_id   = @p_modeling_id	
		      AND    be.plan_id       = @p_plan_id		
		      AND    be.plan_type     = @p_plan_type
		      AND    be.plan_seq      = @p_seq
              -- 활성화 공정 LT 정보 Update : A~*** => A~001
		      AND    be.eng_from_site LIKE '%A~***'
		      AND    be.eng_to_site   LIKE '%A~001'

		      AND    be.modeling_id   = bie.modeling_id
		      AND    be.plan_id       = bie.plan_id
		      AND    be.plan_type     = bie.plan_type
		      AND    be.plan_seq      = bie.plan_seq
              AND    be.bod_id        = bie.bod_id

		      AND    be.modeling_id   = mse.modeling_id
		      AND    be.plan_id       = mse.plan_id
		      AND    be.plan_type     = mse.plan_type
		      AND    be.plan_seq      = mse.plan_seq
		      AND    be.eng_from_site = mse.eng_scm_site_id --bod from site 조인

              -- 추가 20180309
              AND    be.modeling_id   = mst.modeling_id
		      AND    be.plan_id       = mst.plan_id
		      AND    be.plan_type     = mst.plan_type
		      AND    be.plan_seq      = mst.plan_seq
		      AND    be.eng_to_site   = mst.eng_scm_site_id -- bod to site 조인 
		     ) bod
			 -- 2018.06.18 : scp_mst_formation 에 Copy 된 정보 사용
    --         LEFT OUTER JOIN 
			 --(SELECT b.division_id
    --               , b.scm_site_id + '~***' AS from_site_id
    --               , b.scm_site_id + '~001' AS to_site_id
    --               , b.item_id
    --               , FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
    --          FROM  (
    --                 SELECT a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id, c.scm_site_id
				--		  , SUM(ISNULL(a.standard_lt, 0))           AS standard_lt_min
				--		  , SUM(ISNULL(a.standard_lt, 0)) / 24 / 60 AS standard_lt_day
                    
    --                 FROM   scm_mst_aging_item_flow_m_sn a WITH(NOLOCK)  
                           
    --                        INNER JOIN scm_mst_site_eng c  WITH(NOLOCK)
    --                        ON   a.division_id     = c.division_id
    --                        AND  a.site_id         = c.site_id
    --                        AND  a.plant_id        = c.plant_id
    --                        AND  c.modeling_id     = @p_modeling_id	
		  --                  AND  c.plan_id         = @p_plan_id		
		  --                  AND  c.plan_type       = @p_plan_type
		  --                  AND  c.plan_seq        = @p_seq 
    --                        AND  a.division_id     = @p_division_id
    --                        AND  a.default_route   = 'Y'
    --                        --AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거

    --                        AND  c.site_type       = 'PLANT'
    --                        AND  c.operation_group = 'A'
    --                        AND  c.eng_scm_site_id = c.scm_site_id + '~***' -- ***/001/002 중 하나만 가져와야 함
                     
    --                 GROUP BY a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id, c.scm_site_id
    --                ) b
    --          GROUP BY b.division_id, b.scm_site_id, b.item_id
    --          HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
    --         ) lt
    --         ON  bod.from_site_id = lt.from_site_id
    --         AND bod.to_site_id   = lt.to_site_id
    --         AND bod.item_id      = lt.item_id

              LEFT JOIN ( SELECT division_id
                              , plant_site_id + '~***' AS eng_from_site_id
                              , plant_site_id + '~001' AS eng_to_site_id
                              , item_id
                              , lt_formation + CONVERT(INT, ISNULL(attribute1, '0')) AS lt_formation -- 2018.06.18 추가 항차 LT 적용
                         FROM   scp_mst_formation WITH (NOLOCK)
                         WHERE  division_id = @p_division_id ) scf -- SCP tact_time 정보 (SCP UI에서 관리하는 tact_time, yield 정보 테이블)
             ON   bod.item_id      = scf.item_id 
             AND  bod.from_site_id = scf.eng_from_site_id
             AND  bod.to_site_id   = scf.eng_to_site_id

		;  

        -----------------------------------------------------------
        -- 3. Pack 출하 공정의 전진검사 LT 정보 Update : P~*** => P~003
        -- 2021.08.17 By KKC
        -----------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-1 START';
        SET @v_description = N'3-1. Pack 출하창고의 BOD의 th_eng_bod_sn UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE a
		   SET a.transport_time     = b.lt_day
			 , a.transport_time_uom = 'DAY'
		  FROM th_eng_bod_sn a WITH(NOLOCK)
			 , scp_mst_operation_lt b WITH(NOLOCK)
		 WHERE a.master_id = @p_master_id
		   AND a.plan_id   = @p_engine_plan_id
		   AND a.to_site_id LIKE '%-P~003'  --Pack출하창고
		   AND b.lt_operation = 'PRE_INSP'
		   AND SUBSTRING(a.master_id, 1, 2) = b.division_id
		   AND SUBSTRING(a.bod_id, 1, CHARINDEX('::', a.bod_id)-1) = b.item_id
		   AND a.to_site_id LIKE b.scm_site_id + '%'
		   AND b.lt_day > 0
		;

		-----------------------------------------------------------
        -- 4. TE frozen = N 인 경우는 FIXED_TERM 모두 미생성, 2021.09.03
        -----------------------------------------------------------
		IF @v_te_frozen_yn = 'N'			
			BEGIN
			
				-- TXN LOG
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'PART 4-1 START';
				SET @v_description = N'4-1. [TE]th_eng_bod_sn의 Fixed Term UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				UPDATE a
				   SET a.fixed_term = 0
				  FROM th_eng_bod_sn a
				 WHERE a.master_id  = @p_master_id
				   AND a.plan_id    = @p_engine_plan_id
				;
			END

		-----------------------------------------------------------
        -- 5. Transport_time < 0 인 경우에는 0 으로 변경. 2021.11.29 
        -----------------------------------------------------------	
			BEGIN

				-- TXN LOG
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'PART 5-1 START';
				SET @v_description = N'5-1. th_eng_bod_sn의 transport_time 음수값= 0 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


				UPDATE a
				SET    a.transport_time = 0
				FROM   th_eng_bod_sn a
				WHERE  a.master_id  = @p_master_id
				AND    a.plan_id    = @p_engine_plan_id
				AND    a.transport_time < 0 
				;
			
			END

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
      RETURN -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    RETURN 1

  END;



             
