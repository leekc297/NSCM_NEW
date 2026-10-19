
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_BUCKET_RES_CAPA
 * Description  : 
                  -----------------------------------------------------------
                  -- 1. Capa 비대상 및 Line Modeling 비대상 
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
                                             적극 무한 Capa 적용
                    - 컬럼6) work_time_uom : th_eng_bucket_info_sn.work_time_uom
                   
                    주의)  th_eng_bucket_info_sn (20180601 현재)는 52주 모두 일별로 입력되고 있음( 차후 16주이후 부터 WEEKLY로 변경되더라도 일별, 주별 모두 처리될수 있음 )                                                        
                           - 위 'work_time'이 없을경우 'th_eng_bucket_info_sn.work_time' 값 사용함
                           - th_eng_bucket_info_sn 조인처리시 1~16주는 Daily, 16주이후~52주 까지는 Weekly형태로 입력되어있으므로 16주이후 부터는 work_time, loss_time 값을 sum처리해야함 
                           - [scp_mst_working_time.working_time의 비율] : [scp_mst_working_time.working_time] / 1440  
                                                           
                    - 참고테이블1)  scp_mst_working_time (working time 정보)
                    - 참고테이블2)  scp_mst_loss_time    (loss time 정보)
                    - 참고테이블3)  scp_mst_loss_time_except (loss time except 정보)

 * OutTable     : TH_ENG_BUCKET_RES_CAPA
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.22   KSW            전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.05   KSG            LATE TYPE 변경 / 13주 추가기간 설정
 * 2019.03.05   KSW            [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) (참고)주석2
 * 2019.09.19   KSG            전극 무한 Capa 적용 : 고객 요청으로 적용 보류
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
 * 2020.02.28   KSG            C20200224-000257  시스템 엔진 Logic 구현 수정 요청 : 전극 무한 Capa 반영
 * 2021.04.22   KSG            C20210420-000326   소형SCP Ship REQ 생성 Logic 변경 요청 : 무한 Capa 반영 값 변경
 * 2021.05.27   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TM버전에 대해서는 FIX 데이터 미생성
 * 2021.11.17   KSG            PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : 튜닝 - Temp 테이블 적용
 * 2021.11.18   KKC            PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : Fix 구간 Working Time Update 조건 추가
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_BUCKET_RES_CAPA]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_BUCKET_RES_CAPA';
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
    --DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name     DATETIME;

	DECLARE @v_pet_date      NVARCHAR(8) ; -- Plan End Date, 2021.11.18 추가

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
	    -- PET 변수 설정 추가, 2021.11.18
		SELECT @v_pet_date = p.horizon_end_date
          FROM dbo.scm_mst_plan p WITH(NOLOCK)
         WHERE p.division_id = @p_division_id 
           AND p.plan_id     = @p_plan_id 
		;

        DELETE /* PR_SCP_ENG_EE_FN_PROC_BUCKET_RES_CAPA */
        FROM   th_eng_bucket_res_capa_sn 
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;

        -----------------------------------------------------------
        -- 20200228  C20200224-000257 전극 무한 Capa 적용 : 
        --           전극 Capa 적용 시 IN PRE 참고하여 재설정 할 것
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_BUCKET_RES_CAPA */ th_eng_bucket_res_capa_sn
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
             , '999999000'       AS work_time  -- 전극 무한 Capa 적용 -- 20210422 C20210420-000326 무한 Capa 반영 값 변경(OLD : 999999)
             , buc.work_time_uom AS work_time_uom
             , NULL              AS descr
        FROM   th_eng_resource_sn    res with(nolock)
             , th_eng_bucket_info_sn buc with(nolock)
        WHERE  res.master_id = @p_master_id
        AND    res.plan_id   = @p_engine_plan_id
        AND    res.master_id = buc.master_id
        AND    res.plan_id   = buc.plan_id
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'전극 무한 Capa...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 3. FIX 정보(scp_anl_production_plan_fix) 가 있는 Line/구간은 Working Time 을 0 으로 설정 :  CAPA 적용 공정만 처리
        --    참고 ) PR_SCP_ENG_EE_PRE_FIX_PLAN_PROD 의 FIX plan처리부분(scp_anl_production_plan_fix  테이블사용) 수정시 아래부분도 같이 수정여부확인해야 함)
        -----------------------------------------------------------
		IF OBJECT_ID('tempdb..#th_eng_bucket_res_capa') IS NOT NULL                        
              DROP TABLE #th_eng_bucket_res_capa

		IF OBJECT_ID('tempdb..#prod_fix') IS NOT NULL                        
              DROP TABLE #prod_fix

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
        WHERE  master_id = @p_master_id       --'82::WEEKLY'
        AND    plan_id   = @p_engine_plan_id  --'1027::PR::5'
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
        ON   b.division_id = @p_division_id --'82'
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

		IF OBJECT_ID('tempdb..#th_eng_bucket_res_capa') IS NOT NULL                        
              DROP TABLE #th_eng_bucket_res_capa

		IF OBJECT_ID('tempdb..#prod_fix') IS NOT NULL                        
              DROP TABLE #prod_fix

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


