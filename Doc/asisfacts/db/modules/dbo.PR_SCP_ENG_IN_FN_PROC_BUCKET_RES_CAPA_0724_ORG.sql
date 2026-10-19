

/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_BUCKET_RES_CAPA
 * Description  : 
                  -----------------------------------------------------------
                  -- 1. Capa 비대상 / Line Modeling 비대상 
                  -----------------------------------------------------------
                    - th_eng_resource_sn.resource_id(공정::eng_scm_site_id::line_id)별로 bucket 정보 INSERT
                    - CAPA 비대상          : th_eng_resource_sn.descr = 'NO_CAPA'
                    - Line Modeling 비대상 : th_eng_resource_sn.descr = 'CAPA'
                    
                    - 컬럼1) resource_id   : th_eng_resource_sn.resource_id
                    - 컬럼2) start_dttm    : th_eng_bucket_info_sn.start_dttm
                    - 컬럼3) end_dttm      : th_eng_bucket_info_sn.end_dttm
                    - 컬럼4) bucket_type   : th_eng_bucket_info_sn.bucket_type
                    - 컬럼5) work_time     : th_eng_bucket_info_sn.work_time
                    - 컬럼6) work_time_uom : th_eng_bucket_info_sn.work_time_uom

                    - 참고테이블1) th_eng_resource_sn (엔진용 resource 정보)
                    - 참고테이블2) th_eng_bucket_info_sn (엔진용 bucket 정보)  

                  -----------------------------------------------------------
                  -- 2. Line Modeling 대상 및 OSP 대상
                  -----------------------------------------------------------
                    - th_eng_resource_sn.resource_id(공정::eng_scm_site_id::line_id)별로 bucket 정보 INSERT
                    - Line Modeling 대상 : th_eng_resource_sn.descr = 'LINE_CAPA'
                    - OSP 대상           : th_eng_resource_sn.descr = 'OSP' / 'OSP_L'
                    
                    - 컬럼1) resource_id   : th_eng_resource_sn.resource_id
                    - 컬럼2) start_dttm    : th_eng_bucket_info_sn.start_dttm
                    - 컬럼3) end_dttm      : th_eng_bucket_info_sn.end_dttm
                    - 컬럼4) bucket_type   : th_eng_bucket_info_sn.bucket_type                    
                    - 컬럼5) work_time     : 소숫점이하 버림처리함
                                             PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환 / Loss Time Except 생성 시 비율 적용되어 있음
                                            --   Daily Capa 사용 시 : 형교환 Loss만 반영
                                            --   Tact Time 사용 시 : 전체 Loss 반영
                                             -1) 전극이 아닐때(=셀, 팩일때)  
                                                 경우1) scp_mst_loss_time_except 테이블 해당기간에 정보존재시
                                                        scp_mst_work_time.working_time -  ROUND( (scp_mst_work_time.working_time/ 1440.0) * ISNULL(scp_mst_loss_time_except.setup_loss_time_min, 0)), 0, 1)
                                    
                                                 경우2) scp_mst_loss_time_except 테이블 해당기간에 정보 미존재시
                                                        scp_mst_work_time.working_time - ROUND( ((scp_mst_work_time.working_time/ 1440.0) *  ISNULL(scp_mst_loss_time.setup_loss_time_min, 0)), 0, 1) 
                                              
                                                 ( 단, th_eng_bucket_info_sn.descr = 'ADD' (플랜종료일 ~ 추가13주 기간) 일때는 MAX(th_eng_bucket_info_sn.work_time) GROUP BY res.resource_id, res.scm_site_id, buc.start_dttm, buc.end_dttm, buc.bucket_type, buc.work_time_uom, buc.descr  사용함 (현재 descr = 'ADD' 일때 work_time = 999999999 로 일괄셋팅되어있음, MAX(th_eng_bucket_info_sn.work_time)값은 999999999 이다)
												 			
                    - 컬럼6) work_time_uom : th_eng_bucket_info_sn.work_time_uom
                   
                    주의)  th_eng_bucket_info_sn (20180601 현재)는 52주 모두 일별로 입력되고 있음( 차후 16주이후 부터 WEEKLY로 변경되더라도 일별, 주별 모두 처리될수 있음 )                                                        
                           - 위 'work_time'이 없을경우 'th_eng_bucket_info_sn.work_time' 값 사용함
                           - th_eng_bucket_info_sn 조인처리시 1~16주는 Daily, 16주이후~52주 까지는 Weekly형태로 입력되어있으므로 16주이후 부터는 work_time, loss_time 값을 sum처리해야함 
                           - [scp_mst_working_time.working_time의 비율] : [scp_mst_working_time.working_time] / 1440  
                                                           
                    - 참고테이블1)  scp_mst_working_time (working time 정보)
                    - 참고테이블2)  scp_mst_loss_time    (loss time 정보)
                    - 참고테이블3)  scp_mst_loss_time_except (loss time except 정보)
                 
                 -----------------------------------------------------------
                  -- 3. FIX 정보(scp_anl_production_plan_fix) 가 있는 Line/구간은 Working Time 을 0 으로 설정  
                  -----------------------------------------------------------
                     
                 -----------------------------------------------------------
                 -- (현재주석처리됨)4. JIG 대상 
                 -----------------------------------------------------------   
                       - th_eng_resource_sn.resource_id(공정::eng_scm_site_id::line_id) 별로 bucket 정보 INSERT
                       - th_eng_resource_sn.descr = 'JIG' 인건만 조회대상임 

                       - 컬럼1) start_dttm    : MIN(th_eng_bucket_info_sn.start_dttm)  GROUP BY th_eng_resource_sn.master_id, th_eng_resource_sn.plan_id, th_eng_resource_sn.resource_id
                       - 컬럼2) end_dttm      : MAX(th_eng_bucket_info_sn.end_dttm)    GROUP BY th_eng_resource_sn.master_id, th_eng_resource_sn.plan_id, th_eng_resource_sn.resource_id
                       - 컬럼3) work_time     : 1440 셋팅
                       - 컬럼4) work_time_uom : 'MINUTE'
                       - 컬럼5) bucket_type   : 'DAY' 셋팅
                       - 컬럼6) descr         : 'JIG' 셋팅
					   
                       - 참고 테이블1) th_eng_resource_sn (엔진용 resource 정보) : th_eng_resource_sn.descr = 'JIG' 인건만 조회
                       - 참고 테이블2) th_eng_bucket_info_sn (엔진용 bucket 정보) 

 * OutTable     : TH_ENG_BUCKET_RES_CAPA
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.22   KSW            전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.05   KSG            LATE TYPE 변경 / 13주 추가기간 설정
 * 2018.10.31   KSW            JIG 추가  (참고)주석4
 * 2019.01.31   KSW            (속도개선) th_eng_bucket_info_sn.bucket_type('DAY', 'WEEK')별 분리구현 (참고)주석2
 * 2019.06.04   KSW            FIX 정보(scp_anl_production_plan_fix) 가 있는 Line/구간은 Working Time 을 0 으로 설정 (참고)주석3
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
 * 2021.03.12   KSG            PJ20209642 Digital SCM Level.3 달성을 위한 개선 : Work Time 변경
 * 2021.05.27   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TM버전에 대해서는 FIX 데이터 미생성
 * 2021.11.17   KSG            PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : 튜닝 - Temp 테이블 적용
 * 2021.11.18   KKC            PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : Fix 구간 Working Time Update 조건 추가
 * 2023.04.17   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 도전과제 계획
 * 2023.07.07   SHS			   PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리  dummy 설비 BucketResCapa 설정
 * 2023.08.21   LHS            PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 소형 - CAPA 분리 (조립 & LINE_CAPA)
 * 2023.10.10   KKC            PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 소형 - CAPA 분리 수정/보완
 * 2023.10.24   KKC            PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  : 유한Capa 구간 변경 (기존 52주 : 변경 : 52주 + ADD_DEMAND_PERIOD)  
                               1차로 소형만 적용 협의. 
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_BUCKET_RES_CAPA_0724_ORG]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
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
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ; 
    
    DECLARE @p_pre_plan_type NVARCHAR(4000) = @p_pre_plan_type1;
    DECLARE @p_pre_plan_seq  NVARCHAR(4000) = @p_pre_plan_seq1;
    DECLARE @p_pre_engine_plan_id NVARCHAR(4000) = @p_pre_engine_plan_id1; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_BUCKET_RES_CAPA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_BUCKET_RES_CAPA';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

	DECLARE @v_pet_date      NVARCHAR(8) ; -- Plan End Date, 2021.11.18 추가
    DECLARE @v_plan_group    NVARCHAR(100) = '-'; -- Plan Group : PJ20230691 도전과제 계획 

    --//2023.10.10 추가
    DECLARE @p_prev_plan_yyyymmdd NVARCHAR(8) = CONVERT(VARCHAR(8), DATEADD(DD, -1, CONVERT(DATETIME, @p_plan_name)), 112);

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	  
        -- PJ20230691 도전과제 계획 
		SELECT @v_plan_group = ISNULL(segment5, '-')
		FROM   scm_adm_lookup_master_detail a(nolock)
		WHERE  a.lookup_type = 'PLAN_TYPE'
		AND    a.segment1    = @p_plan_type
		AND    a.valid_yn    = 'Y'

	    --PET 변수 설정 추가 , 2021.11.18
        -- 20230417 PJ20230691 도전과제 처리 부분 수정
	    SELECT @v_pet_date      = CASE WHEN @v_plan_group = 'BIZ' THEN p.attribute1
                                       ELSE p.horizon_end_date 
                                  END
		--SELECT @v_pet_date = p.horizon_end_date
          FROM dbo.scm_mst_plan p WITH(NOLOCK)
         WHERE p.division_id = @p_division_id 
           AND p.plan_id     = @p_plan_id 
        ;

        DELETE /* PR_SCP_ENG_IN_FN_PROC_BUCKET_RES_CAPA */
        FROM   th_eng_bucket_res_capa_sn 
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------
        -----------------------------------------------------------
        -- 1. Capa 비대상 / Line Modeling 비대상 
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_BUCKET_RES_CAPA */ th_eng_bucket_res_capa_sn
        ( MASTER_ID
        , PLAN_ID
        , RESOURCE_ID
        , START_DTTM
        , END_DTTM
        , BUCKET_TYPE
        , WORK_TIME
        , WORK_TIME_UOM
        , DESCR
        )
        SELECT res.master_id     AS master_id
             , res.plan_id       AS plan_id
             , res.resource_id   AS resource_id
             , buc.start_dttm    AS start_dttm
             , buc.end_dttm      AS end_dttm
             , buc.bucket_type   AS bucket_type
             , buc.work_time     AS work_time
             , buc.work_time_uom AS work_time_uom
             , NULL              AS descr
        FROM   th_eng_resource_sn    res with(nolock)
             , th_eng_bucket_info_sn buc with(nolock)
        WHERE  res.master_id = @p_master_id
        AND    res.plan_id   = @p_engine_plan_id
        AND    res.master_id = buc.master_id
        AND    res.plan_id   = buc.plan_id
        AND    res.descr    IN ('NO_CAPA', 'CAPA') -- Capa 비대상 / 라인 모델링 비대상
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'Capa 비대상 / Line Modeling 비대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 2. Line Modeling 대상 
        -----------------------------------------------------------
		 IF OBJECT_ID('tempdb..#th_eng_resource') IS NOT NULL                        
              DROP TABLE #th_eng_resource

		 IF OBJECT_ID('tempdb..#working_time') IS NOT NULL                        
              DROP TABLE #working_time

        -- (2023.08.21) 사이트 속성정보 추가 및 capa분리 대상 표시
		 SELECT master_id, A.plan_id, resource_id                         
             ,  dbo.FN_SCM_SPLIT(resource_id, 1, '::')                       AS operation_id
             ,  REPLACE(dbo.FN_SCM_SPLIT(resource_id, 2, '::'), '~***', '')  AS scm_site_id
             ,  dbo.FN_SCM_SPLIT(resource_id, 3, '::')                       AS line_id
             ,  descr 
             ,  s.operation_group
             ,  s.plant_id  
             ,  CASE WHEN @p_division_id    = '40'                                         --소형 사업부만
                     AND  s.operation_group = 'A'  AND s.plant_id IS NOT NULL              --조립사이트 & master에 plant id 존재하는 것만 
                     AND  dbo.FN_SCM_SPLIT(resource_id, 1, '::')  IN ( 'A3000', 'A9000' )  --cell Package 공정만  
                     AND  a.descr = 'LINE_CAPA'                                            --설비는 line-capa 대상                            
                     THEN 'Y' ELSE 'N'  END  AS  scp_working_time_yn                       --필드명(capa_cal_target -> scp_working_time_yn), 2023.10.10 수정
         INTO   #th_eng_resource
         FROM   th_eng_resource_sn  A  WITH(NOLOCK)
                LEFT JOIN ( /* (2023.08.21) 사이트 속성 */
                        SELECT  DISTINCT  a.modeling_id, a.plan_id, a.plan_type, a.plan_seq, a.division_id, a.operation_group , a.scm_site_id , a.plant_id  , a.osp_yn 
                        FROM    scm_mst_site_eng A  WITH(NOLOCK) 
                        WHERE   a.modeling_id   = @p_modeling_id
                        AND     a.plan_id       = @p_plan_id
                        AND     a.plan_type     = @p_plan_type
                        AND     a.plan_seq      = @p_seq
                        AND     a.division_id   = @p_division_id
                        ) S
                ON  S.SCM_SITE_ID  = REPLACE(dbo.FN_SCM_SPLIT(resource_id, 2, '::'), '~***', '')       
         WHERE  A.master_id = @p_master_id       
         AND    A.plan_id   = @p_engine_plan_id  
         AND    A.descr    IN ('LINE_CAPA', 'OSP', 'OSP_L') -- 2020.02.03 [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가 : 'OSP_L'
		 ;

		 
         SELECT a.yyyymmdd
              , a.line_id
              , a.operation_id
              , a.plant_site_id

              , CASE WHEN c.loss_start_date IS NOT NULL THEN a.working_time - ROUND( ISNULL(c.setup_loss_time_min, 0), 0, 1) 
                     ELSE a.working_time - ROUND( (a.working_time_rate *  ISNULL(b.setup_loss_time_min, 0)), 0, 1) 
                END  AS capa_work_time                                
				-- Daily Capa 용 / Tact Time 용 : Daily Capa 로 관리 대상에서는 Loss 중 형교환 Loss 만 반영해야 함
				-- 20180404 수정 
				-- PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환 / Loss Time Except 생성 시 비율 적용되어 있음
				/*, CASE WHEN c.loss_start_date IS NOT NULL THEN a.working_time - ROUND( ISNULL(c.loss_time_min, 0) + ISNULL(c.setup_loss_time_min, 0), 0, 1) 
						ELSE a.working_time - ROUND( (a.working_time_rate * (ISNULL(b.loss_time_min, 0) + ISNULL(b.setup_loss_time_min, 0))), 0, 1) 
					END  AS tact_work_time
				, CASE WHEN c.loss_start_date IS NOT NULL THEN a.working_time - ROUND( ISNULL(c.setup_loss_time_min, 0), 0, 1) 
						ELSE a.working_time - ROUND( (a.working_time_rate *  ISNULL(b.setup_loss_time_min, 0)), 0, 1) 
					END  AS capa_work_time
				*/
         INTO #working_time
         FROM  (
                SELECT *
                     , working_time / 1440.0 AS working_time_rate
                FROM  scp_mst_working_time WITH (NOLOCK)
                WHERE division_id = @p_division_id
                 /* 대상 기간 조건 추가,  2023.10.10 */
                 AND yyyymmdd   >= @p_plan_name
                 AND yyyymmdd   <= @v_pet_date                           
               ) a
               LEFT JOIN ( SELECT *
                           FROM   scp_mst_loss_time WITH (NOLOCK) --loss_time_min 값은 work time이 1440(=1일)분 기준으로 입력되어 있으므로 사용할때 [ ('work time' / 1440) * 'loss_time_min') ] 비율계산된 값으로사용해야 한다.   
                           WHERE  division_id = @p_division_id 
                         ) b
               ON   a.division_id   = b.division_id
               AND  a.plant_site_id = b.plant_site_id
               AND  a.factory_id    = b.factory_id
               AND  a.operation_id  = b.operation_id
               AND  a.line_id       = b.line_id 

               LEFT JOIN ( SELECT division_id, plant_site_id, factory_id, operation_id, line_id
                                , loss_start_date, loss_end_date, loss_time_min, setup_loss_time_min
                             FROM scp_mst_loss_time_except WITH (NOLOCK) --loss_time_min 값은 work time이 1440(=1일)분 기준으로 입력되어 있으므로 사용할때 [ ('work time' / 1440) * 'loss_time_min') ] 비율계산된 값으로사용해야 한다.   
                            WHERE division_id = @p_division_id  
                              /* 대상 기간 조건 추가,  2023.10.10 */
                              AND loss_start_date >= @p_plan_name
                              AND loss_end_date   <= @v_pet_date            
                         ) c
               ON   a.division_id   = c.division_id
               AND  a.plant_site_id = c.plant_site_id
               AND  a.factory_id    = c.factory_id
               AND  a.operation_id  = c.operation_id
               AND  a.line_id       = c.line_id 
               AND  a.yyyymmdd      >= c.loss_start_date
               AND  a.yyyymmdd      <= c.loss_end_date
		--OPTION (LOOP join, HASH join)  /* JOIN 옵션 주석처리, 2023.10.10 */
		;

---------------------------------------------------------------------------------------------
        ---(2023.08.21) 소형 사업부는 별도 관리하는 CAPA테이블도 참조하여 [th_eng_bucket_res_capa_sn] 생성
        -- 2023.10.10 재수정
        ---------------------------------------------------------------------------------------------
        IF @p_division_id  =  '40'             
            
            BEGIN
                /* *******************************************************************
                   (2023.08.21) 소형 조립LINE_CAPA 별도관리 반영
                 * 신규 Table : scp_mst_capa_work 
                 1. 소형 capa 정보를 measure별로 temp table로 생성. 
                    - pst전일부터 pet까지 날짜만 가져옴.
                 2. 일자별 계산된 work_time을 temp [#tmp_mst_capa_work]로 생성하여 engine table 생성 시 참조.
                ******************************************************************* */ 
                
                /* 임시 테이블 재정의 및 재사용 데이터 정리, 2023.10.10 */
                IF OBJECT_ID('tempdb..#tmp_mst_capa_work') IS NOT NULL                        
                DROP TABLE  #tmp_mst_capa_work;

                CREATE TABLE #tmp_mst_capa_work
                (
                    division_id           NVARCHAR(50)  NOT NULL
                  , plant_id	          NVARCHAR(50)  NOT NULL
                  , plant_site_id         NVARCHAR(50)  NOT NULL
                  , factory_id	          NVARCHAR(50)  NOT NULL
                  , operation_id	      NVARCHAR(50)  NOT NULL
                  , line_id	              NVARCHAR(50)  NOT NULL
                  , measure	              NVARCHAR(100) NOT NULL
                  , yyyymmdd	          NVARCHAR(8)   NOT NULL
                  , value	              NUMERIC(20,10)
                  , org_prod_ready_rate	  NUMERIC(20,10)
                  , prod_ready_rate	      NUMERIC(20,10)
                  , work_time             NUMERIC(20,10)
                  , prev_no_work_yn       NVARCHAR(1)
                )
                ; 

                /* 1. 비조업 및 생산준비율 셋팅 */
                INSERT INTO  #tmp_mst_capa_work 
                    (
                       division_id      
                     , plant_id	       
                     , plant_site_id
                     , factory_id	   
                     , operation_id	  
                     , line_id	      
                     , measure	        
                     , yyyymmdd	        
                     , value	          
                     , org_prod_ready_rate
                     , prod_ready_rate
                     , work_time        
                     , prev_no_work_yn
                    )
                SELECT a.division_id
                     , a.plant_id
                     , a.plant_id + '-' + SUBSTRING(a.operation_id,1,1) AS plant_site_id
                     , a.factory_id
                     , a.operation_id
                     , a.line_id
                     , a.measure
                     , a.yyyymmdd
                     , a.value
                     , a.prod_ready_rate
                     , ISNULL(a.prod_ready_rate,100)
                      , CASE WHEN a.value = 0  THEN  1440  
                            ELSE  0  
                        END  AS  work_time                         --비조업은 work time = 0, 그외는 1440
                    /*
                     , LAG(a.value, 1) OVER(PARTITION BY a.division_id
                                                       , a.plant_id
                                                       , a.factory_id
                                                       , a.operation_id
                                                       , a.line_id
                                                       , a.measure
                                                ORDER BY a.yyyymmdd
                                            ) AS prev_no_work_value  --전일 비조업 값
                       */
                     , CASE WHEN LAG(a.value, 1) OVER(PARTITION BY a.division_id
                                                                 , a.plant_id
                                                                 , a.factory_id
                                                                 , a.operation_id
                                                                 , a.line_id
                                                                 , a.measure
                                                          ORDER BY a.yyyymmdd
                                                    )  = 1 THEN 'Y'
                            ELSE 'N'
                        END                   AS prev_no_work_yn   --전일 비조업 여부
                  FROM scp_mst_capa_work a WITH(NOLOCK)
                 WHERE a.MEASURE = 'NO_WORK'
                   AND a.yyyymmdd   >= @p_prev_plan_yyyymmdd 
                   AND a.yyyymmdd   <= @v_pet_date
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+'tmp_mst_capa_work'; 
                SET @v_description = N'(1)소형 NO_WORK 데이터 생성...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                -- 1.1. 생산준비율 Update (전일 비조업 / 당일 조업일 경우만 생산준비율 반영)
                UPDATE a
                   SET a.prod_ready_rate = b.new_prod_ready_rate
                     , a.work_time       = a.work_time * (b.new_prod_ready_rate/100)  
                  FROM #tmp_mst_capa_work a
                  JOIN (
                      SELECT *
                           , ISNULL(MIN(b.prod_ready_rate) OVER(PARTITION BY b.division_id
                                                                           , b.plant_id
                                                                           , b.factory_id
                                                                           , b.operation_id
                                                                           , b.line_id
                                                                           , b.measure                                                           
                                                                ), 100) AS new_prod_ready_rate
                        FROM #tmp_mst_capa_work b
                       WHERE b.measure = 'NO_WORK'
                      ) b
                   ON a.division_id  = b.division_id
                  AND a.plant_id     = b.plant_id 
                  AND a.factory_id   = b.factory_id
                  AND a.operation_id = b.operation_id
                  AND a.line_id      = b.line_id
                  AND a.measure      = b.measure
                  AND a.yyyymmdd     = b.yyyymmdd
                WHERE a.measure = 'NO_WORK'
                  AND a.work_time > 0            --가용시간이 0보다 큰경우 
                  AND a.value   = 0              --조업인 경우
                  AND a.prev_no_work_yn = 'Y'    --전일 비조업인 경우
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'UPDATE '+'tmp_mst_capa_work'; 
                SET @v_description = N'(1-1)소형 NO_WORK2 (생산준비율) 적용......' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                /* 2. RAMP_UP 데이터 생성 */
                INSERT INTO  #tmp_mst_capa_work 
                    (
                          division_id      
                        , plant_id	    
                        , plant_site_id
                        , factory_id	   
                        , operation_id	  
                        , line_id	        
                        , measure	        
                        , yyyymmdd	        
                        , value	          
                    )
                  SELECT  a.division_id
                        , a.plant_id
                        , a.plant_id + '-' + SUBSTRING(a.operation_id,1,1) AS plant_site_id
                        , a.factory_id
                        , a.operation_id
                        , a.line_id
                        , a.measure
                        , a.yyyymmdd
                        , a.value
                    FROM scp_mst_capa_work a WITH(NOLOCK)
                   WHERE a.MEASURE   = 'RAMP_UP'
                     AND a.yyyymmdd >= @p_plan_name 
                     AND a.yyyymmdd <= @v_pet_date
                     /* 필수 데이터만 생성 */
                     AND a.value >= 0 
                     AND a.value  < 1
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+'tmp_mst_capa_work'; 
                SET @v_description = N'(2)소형 RAMP_UP 데이터 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                /* 3. LOAD_RATE 데이터 생성 */
                INSERT INTO  #tmp_mst_capa_work 
                    (
                          division_id      
                        , plant_id	    
                        , plant_site_id
                        , factory_id	   
                        , operation_id	  
                        , line_id	        
                        , measure	        
                        , yyyymmdd	        
                        , value	          
                    )
                  SELECT  a.division_id
                        , a.plant_id
                        , a.plant_id + '-' + SUBSTRING(a.operation_id,1,1) AS plant_site_id
                        , a.factory_id
                        , a.operation_id
                        , a.line_id
                        , a.measure
                        , a.yyyymmdd
                        , a.value
                    FROM scp_mst_capa_work a WITH(NOLOCK)
                   WHERE a.MEASURE   = 'LOAD_RATE'
                     AND a.yyyymmdd   >= @p_plan_name 
                     AND a.yyyymmdd   <= @v_pet_date
                     /* 필수 데이터만 생성 */
                     AND a.value >= 0
                     AND a.value < 100
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+'tmp_mst_capa_work'; 
                SET @v_description = N'(3)소형 LOAD_RATE 데이터 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                ---/ th_eng_bucket_res_capa_sn 생성 /---               
               ;WITH VW_SCP_CAPA AS (
                                       SELECT plant_id
                                            , operation_id
                                            , line_id
                                            , plant_site_id
                                            , yyyymmdd
                                            , ISNULL(MAX(work_time), 1440) AS work_time
                                              /* NO_WORK 데이터가 없는 경우 가용으로 처리 */
                                            , ISNULL(MAX([NO_WORK]), 0)    AS no_work
                                            , ISNULL(MAX([LOAD_RATE]),100) AS load_rate
                                            , ISNULL(MAX([RAMP_UP]),1)     AS ramp_up
                                        FROM 
                                        (
                                           SELECT plant_id
                                                , operation_id
                                                , plant_site_id
                                                , line_id
                                                , yyyymmdd
                                                , measure
                                                , value
                                                , work_time
                                            FROM #tmp_mst_capa_work a
                                            ) AS row_data
                                        PIVOT
                                        (
                                        MIN(VALUE) FOR MEASURE IN ([NO_WORK], [LOAD_RATE], [RAMP_UP])     
                                        ) AS pvt_data
                                    GROUP BY plant_id
                                           , operation_id
                                           , plant_site_id
                                           , line_id
                                           , yyyymmdd                        
                                   )
              INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA */ th_eng_bucket_res_capa_sn
                    ( MASTER_ID
                    , PLAN_ID
                    , RESOURCE_ID
                    , START_DTTM
                    , END_DTTM
                    , BUCKET_TYPE
                    , WORK_TIME
                    , WORK_TIME_UOM
                    , DESCR
                    )
               SELECT @p_master_id      AS master_id  
                    , @p_engine_plan_id AS plan_id  
                    , a.resource_id     AS resource_id
                    , a.start_dttm      AS start_dttm
                    , a.end_dttm        AS end_dttm
                    , a.bucket_type     AS bucket_type
                    , CASE WHEN a.bucket_descr = 'ADD' THEN -- 2018.07.05 pet_date 이후 추가 구간은 Bucket 의 work_time 사용
                                a.bucket_work_time
			               ELSE 
                                CASE WHEN b.no_work = 1      THEN 0
                                     WHEN b.yyyymmdd IS NULL THEN a.bucket_work_time
                                     ELSE 
                                        /* 생산준비율을 선행해서 계산한 WORKING TIME * 설비로딩율 * Ramp-UP 
                                           NO_WORK 일자가 없으면, Default Working Time 등록/ 변경하고 싶으면, NULL값일때, 0으로 변경 필요. 
                                        */
                                        ISNULL(b.work_time, a.bucket_work_time) * (ISNULL(b.load_rate, 100)/100) * ISNULL(b.ramp_up, 1)
                                END
                       END AS work_time                   
                    , a.bucket_work_time_uom AS work_time_uom -- ksg : Work Calendar 생성 후별도 처리 필요함
                    , NULL                   AS descr
                    /*
                    , b.work_time            AS org_work_time  
                    , b.no_work              
                    , b.load_rate
                    , b.ramp_up
                    */
                 FROM
                    (
                     SELECT  
                            res.resource_id   AS resource_id
                          , res.operation_id  AS operation_id
                          , res.scm_site_id   AS scm_site_id
                          , res.line_id       AS line_id
                          , buc.start_dttm    AS start_dttm
                          , buc.end_dttm      AS end_dttm
                          , buc.bucket_type   AS bucket_type             
                          , buc.work_time_uom AS work_time_uom -- ksg : Work Calendar 생성 후별도 처리 필요함
                          , buc.work_time     AS bucket_work_time
                          , buc.descr         AS bucket_descr
                          , buc.work_time_uom AS bucket_work_time_uom
                      FROM #th_eng_resource res 
                     INNER JOIN th_eng_bucket_info_sn buc WITH(NOLOCK)
                        ON res.master_id = buc.master_id
                       AND res.plan_id   = buc.plan_id			
                     WHERE res.scp_working_time_yn = 'Y'   ---소형SCP CAPA 적용 대상 라인
                    ) a
                    LEFT OUTER JOIN 
                        VW_SCP_CAPA b
                     ON a.scm_site_id   = b.plant_site_id
                    AND a.operation_id  = b.operation_id
                    AND a.line_Id       = b.line_id
                    AND CONVERT(VARCHAR, a.start_dttm, 112) = b.yyyymmdd
                /*
                ORDER 
                    BY a.resource_id
                    , a.line_id
                    , a.start_dttm
                */
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+@v_table_id; 
                SET @v_description = N'(4)소형 SCP 분리 Line Modeling 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;       

                
                /* (2023.08.21) 조립 & LINE_CAPA가 아닌 설비의 경우: 기존 로직유지 */ 
                INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA */ th_eng_bucket_res_capa_sn
                     ( MASTER_ID
                     , PLAN_ID
                     , RESOURCE_ID
                     , START_DTTM
                     , END_DTTM
                     , BUCKET_TYPE
                     , WORK_TIME
                     , WORK_TIME_UOM
                     , DESCR
                    )
                SELECT @p_master_id      AS master_id  
                     , @p_engine_plan_id AS plan_id  
                     , res.resource_id   AS resource_id
                     , buc.start_dttm    AS start_dttm
                     , buc.end_dttm      AS end_dttm
                     , buc.bucket_type   AS bucket_type
             
                     -- 전극은 FP에서 Tact Time으로 관리, 나머지는 Capa 로 관리하므로 Tact Time으로 전환 : OP RES GRAUP MAP / OP RES GRAUP MAP CAL / BUCKET RES CAPA 에 동일 로직
			         -- PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환 / Loss Time Except 생성 시 비율 적용되어 있음
                     --   Daily Capa 사용 시 : 형교환 Loss만 반영
                     --   Tact Time 사용 시 : 전체 Loss 반영
                     , CASE WHEN buc.descr IN ('ADD', 'ADD_PLAN') THEN -- ADD PLAN 구간부터 Bucket의 work_time 사용, 2023.10.24
                                 MAX(buc.work_time)
			                -- PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환
                            ELSE SUM(ISNULL(wt.capa_work_time, 0))
                       END AS work_time                   
                     , buc.work_time_uom AS work_time_uom -- ksg : Work Calendar 생성 후별도 처리 필요함
                     , NULL              AS descr
                FROM  #th_eng_resource res 
               INNER JOIN th_eng_bucket_info_sn buc WITH(NOLOCK)
                  ON  res.master_id = buc.master_id
                 AND  res.plan_id   = buc.plan_id			  
                LEFT OUTER JOIN #working_time as wt                   
                  ON  res.scm_site_id  = wt.plant_site_id
                 AND  res.operation_id = wt.operation_id
                 AND  res.line_id      = wt.line_id                 
                 AND  buc.start_dttm   <= wt.yyyymmdd
                 AND  buc.end_dttm     >  wt.yyyymmdd
               WHERE ISNULL(res.scp_working_time_yn,'N') = 'N'    ---(2023.08.21) ADD.
                /* 중복 데이터 방지 추가 , 2023.10.10 */
                 AND res.resource_id NOT IN (SELECT x.resource_Id
                                                FROM th_eng_bucket_res_capa_sn x WITH(NOLOCK)
                                               WHERE x.master_id = @p_master_id
                                                 AND x.plan_id   = @p_engine_plan_id
                                             )
                GROUP 
                   BY  res.resource_id, res.scm_site_id
                     , buc.start_dttm, buc.end_dttm, buc.bucket_type, buc.work_time_uom, buc.descr
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+@v_table_id; 
                SET @v_description = N'(5)소형 일반 Line Modeling 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;       


                /* 쿼리 정리 및 튜닝, 2023.10.10
                --- (1) #tmp_mst_capa_work_NOWORK  생성 ---
                IF OBJECT_ID('tempdb..#tmp_mst_capa_work_NOWORK') IS NOT NULL                        
                    DROP TABLE  #tmp_mst_capa_work_NOWORK

                CREATE TABLE #tmp_mst_capa_work_NOWORK
                (
                      division_id       NVARCHAR(50) NOT NULL
                    , plant_id	        NVARCHAR(50) NOT NULL
                    , factory_id	    NVARCHAR(50) NOT NULL
                    , operation_id	    NVARCHAR(50) NOT NULL
                    , line_id	        NVARCHAR(50) NOT NULL
                    , measure	        NVARCHAR(100) NOT NULL
                    , yyyymmdd	        NVARCHAR(8) NOT NULL
                    , value	            NUMERIC(20,10)
                    , prod_ready_rate	NUMERIC(20,10)
                    , prv_date	        NVARCHAR(8) NULL
                    , prv_value	        NUMERIC(20,10)
                    , prod_ready	    NVARCHAR(8) NULL
                    , work_time         NUMERIC(20,10)
                )
                ; 

                INSERT INTO  #tmp_mst_capa_work_NOWORK 
                (
                      division_id      
                    , plant_id	       
                    , factory_id	   
                    , operation_id	  
                    , line_id	        
                    , measure	        
                    , yyyymmdd	        
                    , value	          
                    , prod_ready_rate	    --(1-2)에서 update (월별 동일값 적용)
                    , prv_date	            --PST전일 날짜.
                    , prv_value	            --(1-1)에서 UPDATE, PST전일자의 조업여부.
                    --, prod_ready          --(1-3)에서 UPDATE, (생산준비율 반영일자에 Y 표시) 
                    , work_time             --(1-1)에서 최종값 UPDATE
                )
                SELECT  
                      division_id	
                    , plant_id	
                    , factory_id	
                    , operation_id	
                    , line_id	
                    , measure	
                    , yyyymmdd	
                    , value	            -- NO_WORK일때 0:조업 , 1:비조업 
                    , NULL                                             AS prod_ready_rate     
                    , CONVERT (VARCHAR(8), DATEADD(dd, -1, yyyymmdd) ,112)  
                                                                       AS prv_date
                    , 1       AS prv_value   -- Default값으로 1(비조업) 설정, 아래에서 update
                    , CASE WHEN cw.value = 0  THEN  1440  ELSE  0 END  AS  work_time
                 FROM scp_mst_capa_work cw  WITH(NOLOCK) 
                WHERE cw.division_id = @p_division_id
                  AND cw.measure     = 'NO_WORK' 
                  AND cw.yyyymmdd   >= @p_plan_name 
                  AND cw.yyyymmdd   <= @v_pet_date
                ;   

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+'tmp_mst_capa_work_NOWORK'; 
                SET @v_description = N'(1)소형 조업여부...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
            

                -- (1-1) 생산준비율 값 update ---
                /* 생산준비율(prod_ready_rate) 정의
                   measure  : 'NO_WORK' 
                   line별 계획구간내 등록된 생산준비율값 중에서 min 값을 계획에 반영 (23.09.14)
                */
                UPDATE A 
                   SET a.prod_ready_rate =  p.prod_ready_rate  
                 FROM  #tmp_mst_capa_work_NOWORK   A
                       INNER JOIN (  /* --- 0914수정 라인별 생산준비율 조회: UI에서 pst이후 매달 01일자에 값을 update한다.  --- */
                                SELECT  division_id , plant_id , factory_id , operation_id , line_id 
                                    ,   MIN(prod_ready_rate)  AS prod_ready_rate
                                FROM    scp_mst_capa_work cw  WITH(NOLOCK) 
                                WHERE   cw.division_id = @p_division_id 
                                AND     cw.measure     = 'NO_WORK' 
                                AND     cw.yyyymmdd   >= @p_plan_name 
                                AND     cw.yyyymmdd   <= @v_pet_date
                                AND     cw.yyyymmdd   like '%01' 
                                AND     ISNULL(cw.prod_ready_rate,0) > 0 
                                GROUP BY division_id , plant_id , factory_id , operation_id , line_id 
                        ) P
                        ON  1=1
                        AND p.division_id   = a.division_id
                        AND p.plant_id      = a.plant_id
                        AND p.factory_id    = a.factory_id 
                        AND p.operation_id  = a.operation_id
                        AND p.line_id       = a.line_id
                where   1=1 
                ; 

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'UPDATE '+'#tmp_mst_capa_work_NOWORK'; 
                SET @v_description = N'(1-1)Line별 생산준비율 값 적용...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



                -- (1-2) 전일의 조업여부 Update --
                UPDATE  A      
                SET     a.prv_value = cw.value  
                FROM    #tmp_mst_capa_work_NOWORK   A  
                        INNER JOIN scp_mst_capa_work   cw  with(nolock) 
                        ON  1=1
                        AND cw.division_id  = @p_division_id     
                        AND cw.division_id  = a.division_id  
                        AND cw.plant_id     = a.plant_id 
                        AND cw.factory_id   = a.factory_id
                        AND cw.operation_id = a.operation_id
                        AND cw.line_id      = a.line_id  
                        AND cw.yyyymmdd     = a.prv_date  
                        AND cw.measure      = a.measure
                 WHERE  1=1            
                ; 

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'UPDATE '+'#tmp_mst_capa_work_NOWORK'; 
                SET @v_description = N'(1-2)전일 조업여부...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                        
            
 
                -- (1-3) 전일 비조업인 경우만 생산준비율 반영 ---
                UPDATE  A  
                SET     a.work_time =  a.work_time * (CASE WHEN  prod_ready_rate IS NULL THEN 1 ELSE prod_ready_rate/100 END)
                    ,   a.prod_ready = 'Y'
                FROM    #tmp_mst_capa_work_NOWORK   A   
                WHERE   1=1
                AND    (A.VALUE = 0  AND  PRV_VALUE =  1 )
                AND     A.PROD_READY_RATE IS NOT NULL  
                ; 
                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'UPDATE '+'#tmp_mst_capa_work_NOWORK'; 
                SET @v_description = N'(1-3)전일 비조업-생산준비율 반영...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


                --- (2)  #tmp_mst_capa_work_LOADRATE  생성 --- 
                IF OBJECT_ID('tempdb..#tmp_mst_capa_work_LOADRATE') IS NOT NULL                        
                    DROP TABLE  #tmp_mst_capa_work_LOADRATE  

                SELECT  
                        division_id	
                    ,   plant_id	
                    ,   factory_id	
                    ,   operation_id	
                    ,   line_id	
                    ,   measure	
                    ,   yyyymmdd	
                    ,   value	    -- %단위 값           
                    ,   (value/100)  AS LOAD_RATE  --계산식에 사용할 값
                INTO    #tmp_mst_capa_work_LOADRATE 
                FROM    scp_mst_capa_work   cw  with(nolock) 
                WHERE   cw.division_id = @p_division_id
                AND     cw.measure     = 'LOAD_RATE' 
                AND     cw.yyyymmdd   >= @p_plan_name 
                AND     cw.yyyymmdd   <= @v_pet_date
                ; 
                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+'#tmp_mst_capa_work_LOADRATE'; 
                SET @v_description = N'(2)소형LOAD_RATE...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


                --- (3) #tmp_mst_capa_work_RAMPUP  생성 --- 
                IF OBJECT_ID('tempdb..#tmp_mst_capa_work_RAMPUP') IS NOT NULL                        
                    DROP TABLE  #tmp_mst_capa_work_RAMPUP 

                SELECT  
                        division_id	
                    ,   plant_id	
                    ,   factory_id	
                    ,   operation_id	
                    ,   line_id	
                    ,   measure	
                    ,   yyyymmdd	
                    ,   value	     -- 0~1 사이 값.    
                    ,   value	     AS  RAMP_UP  -- 단위환산 없음.      
                INTO    #tmp_mst_capa_work_RAMPUP 
                FROM    scp_mst_capa_work   cw  with(nolock) 
                WHERE   cw.division_id = @p_division_id
                AND     cw.measure     = 'RAMP_UP'
                AND     cw.yyyymmdd   >= @p_plan_name 
                AND     cw.yyyymmdd   <= @v_pet_date
                ; 
                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+'#tmp_mst_capa_work_RAMPUP'; 
                SET @v_description = N'(3)소형RAMP_UP...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


                --- (4) 계산식에 의한 소형 work_time 값 계산 --- 
                IF OBJECT_ID('tempdb..#tmp_mst_capa_work') IS NOT NULL                        
                    DROP TABLE  #tmp_mst_capa_work

                SELECT  n.division_id
                    ,   n.plant_id 
                    ,   n.operation_id
                    ,   n.line_id 
                    ,   n.yyyymmdd 
                    ,   CASE WHEN  n.prod_ready='Y' THEN  ISNULL(prod_ready_rate,100)/100  ELSE  NULL  END  AS prod_ready_value
                    ,   n.work_time 
                    ,   l.load_rate  
                    ,   r.ramp_up   
                    ,   CASE WHEN ROUND(n.work_time * l.load_rate * r.ramp_up,0 ) > 1440 THEN 1440 
                             ELSE ROUND(n.work_time * l.load_rate * r.ramp_up,0 )               --소수점은 반올림 처리
                             END  AS work_time_cal
                INTO    #tmp_mst_capa_work
                FROM    #tmp_mst_capa_work_NOWORK AS  N

                        LEFT JOIN  #tmp_mst_capa_work_LOADRATE AS L
                        ON  1=1 
                        AND l.division_id  = n.division_id 
                        AND l.plant_id     = n.plant_id
                        AND l.factory_id   = n.factory_id
                        AND l.operation_id = n.operation_id
                        AND l.line_id      = n.line_id 
                        AND l.yyyymmdd     = n.yyyymmdd 

                        LEFT JOIN  #tmp_mst_capa_work_RAMPUP AS R 
                        ON  1=1 
                        AND r.division_id  = n.division_id 
                        AND r.plant_id     = n.plant_id
                        AND r.factory_id   = n.factory_id
                        AND r.operation_id = n.operation_id
                        AND r.line_id      = n.line_id 
                        AND r.yyyymmdd     = n.yyyymmdd
                WHERE   1=1
                ; 
                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+'#tmp_mst_capa_work_RAMPUP'; 
                SET @v_description = N'(4)소형work_time계산...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


                ---/ th_eng_bucket_res_capa_sn 생성 /---
                 INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA */ th_eng_bucket_res_capa_sn
                ( MASTER_ID
                , PLAN_ID
                , RESOURCE_ID
                , START_DTTM
                , END_DTTM
                , BUCKET_TYPE
                , WORK_TIME
                , WORK_TIME_UOM
                , DESCR
                )
                /* (2023.08.21) 조립 & LINE_CAPA가 아닌 설비의 경우: 기존 로직유지 */ 
                SELECT @p_master_id      AS master_id  
                     , @p_engine_plan_id AS plan_id  
                     , res.resource_id   AS resource_id
                     , buc.start_dttm    AS start_dttm
                     , buc.end_dttm      AS end_dttm
                     , buc.bucket_type   AS bucket_type
             
                     -- 전극은 FP에서 Tact Time으로 관리, 나머지는 Capa 로 관리하므로 Tact Time으로 전환 : OP RES GRAUP MAP / OP RES GRAUP MAP CAL / BUCKET RES CAPA 에 동일 로직
			         -- PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환 / Loss Time Except 생성 시 비율 적용되어 있음
                     --   Daily Capa 사용 시 : 형교환 Loss만 반영
                     --   Tact Time 사용 시 : 전체 Loss 반영
                     , CASE WHEN buc.descr = 'ADD' THEN -- 2018.07.05 pet_date 이후 추가 구간은 Bucket 의 work_time 사용
                                 MAX(buc.work_time)

			                -- PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환
                            ELSE SUM(ISNULL(wt.capa_work_time, 0))

                       END AS work_time      
             
                     , buc.work_time_uom AS work_time_uom -- ksg : Work Calendar 생성 후별도 처리 필요함
                     , NULL              AS descr
                FROM   #th_eng_resource res 

                       INNER JOIN th_eng_bucket_info_sn buc WITH(NOLOCK)
                       ON   res.master_id = buc.master_id
                       AND  res.plan_id   = buc.plan_id			
  
                       LEFT HASH JOIN #working_time as wt                   
                       ON   res.scm_site_id  = wt.plant_site_id
                       AND  res.operation_id = wt.operation_id
                       AND  res.line_id      = wt.line_id                 
                       AND  buc.start_dttm   <= wt.yyyymmdd
                       AND  buc.end_dttm     >  wt.yyyymmdd
                WHERE   ISNULL(res.scp_working_time_yn,'N') != 'Y'    ---(2023.08.21) ADD.
                GROUP BY  res.resource_id, res.scm_site_id
                        , buc.start_dttm, buc.end_dttm, buc.bucket_type, buc.work_time_uom, buc.descr

                UNION ALL 

                /* (2023.08.21) 조립&LINE_CAPA인 설비의 경우: 로직추가 */
                SELECT @p_master_id      AS master_id  
                     , @p_engine_plan_id AS plan_id    
                     , res.resource_id   AS resource_id
                     , buc.start_dttm    AS start_dttm
                     , buc.end_dttm      AS end_dttm
                     , buc.bucket_type   AS bucket_type
             
                     , CASE WHEN buc.descr = 'ADD' THEN  -- 2018.07.05 pet_date 이후 추가 구간은 Bucket 의 work_time 사용
                                 MAX(buc.work_time)
                            ELSE SUM(ISNULL(cw.work_time_cal, 0))
                       END AS work_time      
             
                     , buc.work_time_uom AS work_time_uom -- ksg : Work Calendar 생성 후별도 처리 필요함
                     , NULL              AS descr
                FROM   #th_eng_resource  as res 

                        INNER JOIN th_eng_bucket_info_sn buc WITH(NOLOCK)
                        ON   res.master_id = buc.master_id
                        AND  res.plan_id   = buc.plan_id			
  
                        LEFT JOIN  #tmp_mst_capa_work  cw 
                        ON   1=1 
                        AND  cw.plant_id     =  res.plant_id
                        and  cw.operation_id =  res.operation_id
                        and  cw.line_id      =  res.line_id
                        and  buc.start_dttm <=  cw.yyyymmdd 
                        AND  cw.yyyymmdd     <  buc.end_dttm
        
                WHERE   res.scp_working_time_yn = 'Y' 
                GROUP BY  res.resource_id, res.scm_site_id
                        , buc.start_dttm, buc.end_dttm, buc.bucket_type, buc.work_time_uom, buc.descr
                ;
                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+@v_table_id; 
                SET @v_description = N'Line Modeling 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;        
                */

            END   --- 소형 사업부일 경우 끝.

        ---------------------------------------------------------------------------------------------
        ---(2023.08.21) 소형 사업부가 아닐 경우 기존 로직으로 [th_eng_bucket_res_capa_sn] 생성. 
        ---------------------------------------------------------------------------------------------
        ELSE
            
            BEGIN      
            
                INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA */ th_eng_bucket_res_capa_sn
                ( MASTER_ID
                , PLAN_ID
                , RESOURCE_ID
                , START_DTTM
                , END_DTTM
                , BUCKET_TYPE
                , WORK_TIME
                , WORK_TIME_UOM
                , DESCR
                )
                SELECT    @p_master_id      AS master_id  
                        , @p_engine_plan_id AS plan_id     
                        , res.resource_id   AS resource_id
                        , buc.start_dttm    AS start_dttm
                        , buc.end_dttm      AS end_dttm
                        , buc.bucket_type   AS bucket_type             
                        -- 전극은 FP에서 Tact Time으로 관리, 나머지는 Capa 로 관리하므로 Tact Time으로 전환 : OP RES GRAUP MAP / OP RES GRAUP MAP CAL / BUCKET RES CAPA 에 동일 로직
			            -- PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환 / Loss Time Except 생성 시 비율 적용되어 있음
                        --   Daily Capa 사용 시 : 형교환 Loss만 반영
                        --   Tact Time 사용 시 : 전체 Loss 반영
                        , CASE WHEN buc.descr IN ('ADD', 'ADD_PLAN') THEN -- ADD PLAN 추가 구간부터 Bucket 의 work_time 사용, 2023.10.24
                                    MAX(buc.work_time)
 			                   -- PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환
                               ELSE SUM(ISNULL(wt.capa_work_time, 0))
                           END AS work_time                   
                        , buc.work_time_uom AS work_time_uom -- ksg : Work Calendar 생성 후별도 처리 필요함
                        , NULL              AS descr
                FROM   #th_eng_resource res 
               INNER JOIN th_eng_bucket_info_sn buc WITH(NOLOCK)
                  ON res.master_id = buc.master_id
                 AND res.plan_id   = buc.plan_id			  
                LEFT HASH JOIN #working_time as wt                   
                  ON res.scm_site_id  = wt.plant_site_id
                 AND res.operation_id = wt.operation_id
                 AND res.line_id      = wt.line_id                 
                 AND buc.start_dttm   <= wt.yyyymmdd
                 AND buc.end_dttm     >  wt.yyyymmdd
                GROUP 
                  BY  res.resource_id, res.scm_site_id
                    , buc.start_dttm, buc.end_dttm, buc.bucket_type, buc.work_time_uom, buc.descr
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERT INTO '+@v_table_id; 
                SET @v_description = N'Line Modeling 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;		
          
            END  

        -----------------------------------------------------------
		-- 20190604
        -- 3. FIX 정보(scp_anl_production_plan_fix) 가 있는 Line/구간은 Working Time 을 0 으로 설정 : CAPA 적용 공정만 처리
        --    참고 ) PR_SCP_ENG_IN_FN_PROC_FIX_PLAN_PROD 의 FIX plan처리부분(scp_anl_production_plan_fix  테이블사용) 수정시 아래부분도 같이 수정여부확인해야 함)
        -----------------------------------------------------------
		IF OBJECT_ID('tempdb..#th_eng_bucket_res_capa') IS NOT NULL                        
              DROP TABLE #th_eng_bucket_res_capa;

		IF OBJECT_ID('tempdb..#prod_fix') IS NOT NULL                        
              DROP TABLE #prod_fix;

        SELECT master_id
             , plan_id
             , resource_id
             , start_dttm
             , end_dttm  
             , dbo.fn_scm_split(resource_id, 1, '::') AS operation_id
             , dbo.fn_scm_split(dbo.fn_scm_split(resource_id, 2, '::'), 1, '~') AS scm_site_id 
             , dbo.fn_scm_split(resource_id, 3, '::') AS line_id 
        INTO   #th_eng_bucket_res_capa
        FROM   th_eng_bucket_res_capa_sn  WITH (NOLOCK)
        WHERE  master_id = @p_master_id     
        AND    plan_id   = @p_engine_plan_id 
		;

        SELECT DISTINCT a.master_id, a.plan_id, a.resource_id, a.start_dttm 
        INTO   #prod_fix
        FROM   #th_eng_bucket_res_capa a
        INNER JOIN ( SELECT division_id
                          , scm_site_id
                          , line_id
                          , operation_id
                          , CONVERT(DATETIME, yyyymmdd) AS yyyymmdd  
                     FROM   scp_anl_production_plan_fix  WITH (NOLOCK)
                     WHERE  division_id  = @p_division_id
                     AND    yyyymmdd    >= @p_plan_name
					 AND    yyyymmdd    <= @v_pet_date    --2021.11.18 추가 
                     /* TM버전은 FP FIX 이후 데이터 미생성, 2021.05.27, By KKC */
                     AND   1= CASE WHEN @p_plan_type = 'TM' THEN 0
                                   ELSE 1
                              END
                     GROUP BY division_id, scm_site_id, line_id, operation_id, yyyymmdd
                   ) b 
        ON   b.division_id = @p_division_id  
        AND  a.scm_site_id  = b.scm_site_id 
        AND  a.line_id      = b.line_id 
        AND  a.operation_id = b.operation_id
        AND  a.start_dttm  <= b.yyyymmdd
        AND  a.end_dttm    >  b.yyyymmdd
		;

        UPDATE th_eng_bucket_res_capa_sn
        SET    work_time = 0
        FROM   th_eng_bucket_res_capa_sn  x WITH (NOLOCK)
             INNER JOIN #prod_fix y             
             ON  x.master_id   = y.master_id
             AND x.plan_id     = y.plan_id
             AND x.resource_id = y.resource_id
             AND x.start_dttm  = y.start_dttm
			 -- CAPA 적용 공정만 처리
             INNER JOIN (
			             SELECT  r.*
                         FROM   th_eng_resource_sn r WITH(NOLOCK)
                         WHERE  r.master_id = @p_master_id
                         AND    r.plan_id   = @p_engine_plan_id
                         AND    r.descr     <> 'NO_CAPA'
			            ) r
             ON  x.master_id   = r.master_id
             AND x.plan_id     = r.plan_id
             AND x.resource_id = r.resource_id
        WHERE x.master_id = @p_master_id
        AND   x.plan_id   = @p_engine_plan_id         
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'FIX 정보...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-----------------------------------------------------------
        -- 3. 2023.07.07 SHS dummy 설비 BucketResCapa 설정 
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA */ th_eng_bucket_res_capa_sn
              ( 
                MASTER_ID
              , PLAN_ID
              , RESOURCE_ID
              , START_DTTM
              , END_DTTM
              , BUCKET_TYPE
              , WORK_TIME
              , WORK_TIME_UOM
              , DESCR
              )
	    SELECT res.master_id      AS master_id
			  , res.plan_id       AS plan_id
			  , res.resource_id   AS resource_id
			  , buc.start_dttm    AS start_dttm
			  , buc.end_dttm      AS end_dttm
			  , buc.bucket_type   AS bucket_type
			  , buc.work_time     AS work_time
			  , buc.work_time_uom AS work_time_uom
			  , NULL              AS descr
		   FROM th_eng_resource_sn    res WITH(NOLOCK)
			  , th_eng_bucket_info_sn buc WITH(NOLOCK)
		  WHERE res.master_id = @p_master_id
		    AND res.plan_id   = @p_engine_plan_id
		    AND res.master_id = buc.master_id
		    AND res.plan_id   = buc.plan_id
		    AND res.descr     = 'DUMMY' 
		;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'DUMMY...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------
        -- TempTable 삭제
        ---------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_resource') IS NOT NULL                        
            DROP TABLE #th_eng_resource;

        IF OBJECT_ID('tempdb..#working_time') IS NOT NULL                        
            DROP TABLE #working_time;

		 IF OBJECT_ID('tempdb..#tmp_mst_capa_work ') IS NOT NULL                        
            DROP TABLE  #tmp_mst_capa_work;     -- 2023.10.10  재정의 

         /* 임시 테이블 정리, 2023.10.10
        IF OBJECT_ID('tempdb..#tmp_mst_capa_work_NOWORK ') IS NOT NULL                        
            DROP TABLE  #tmp_mst_capa_work_NOWORK     -- 2023.08.21  ADD 

        IF OBJECT_ID('tempdb..#tmp_mst_capa_work_LOADRATE ') IS NOT NULL                        
            DROP TABLE  #tmp_mst_capa_work_LOADRATE   -- 2023.08.21  ADD 

        IF OBJECT_ID('tempdb..#tmp_mst_capa_work_RAMPUP ') IS NOT NULL                        
            DROP TABLE  #tmp_mst_capa_work_RAMPUP     -- 2023.08.21  ADD 

        IF OBJECT_ID('tempdb..#tmp_mst_capa_work') IS NOT NULL                        
            DROP TABLE #tmp_mst_capa_work             -- 2023.08.21  ADD 
        */

		IF OBJECT_ID('tempdb..#th_eng_bucket_res_capa') IS NOT NULL                        
              DROP TABLE #th_eng_bucket_res_capa;

		IF OBJECT_ID('tempdb..#prod_fix') IS NOT NULL                        
              DROP TABLE #prod_fix;

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

