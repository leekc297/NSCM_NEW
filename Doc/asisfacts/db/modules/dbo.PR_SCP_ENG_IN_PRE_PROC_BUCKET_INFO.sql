
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_BUCKET_INFO
 * Description  : 
                  -------------------------------------------------
                  -1) 플랜시작일 ~ 플랜종료일(scm_mst_division.daily_plan_period, 현재 52주)
                  -------------------------------------------------
                      - 조회기간 : 플랜시작일(=@p_plan_name) ~ 플랜종료일(52주, @v_pet_date)

                      - 컬럼1) start_dttm     : scm_mst_bucket.yyyymmdd
                      - 컬럼2) end_dttm       : scm_mst_bucket.yyyymmdd + 1일
                      - 컬럼3) bucket_type    : 'DAY' 셋팅
                      - 컬럼4) work_time      : 24 * 60 (단위 : 분)
                      - 컬럼5) work_time_uom  : 'MINUTE'
                      - 컬럼6) descr          : 'PLAN' 셋팅  (플랜시작일~플랜종료일까지 'PLAN' 셋팅함) 
                  
                  -------------------------------------------------
                  -(사용안됨, 아래 (참고) 참조) 2) 특정주이후(=scm_mst_division.daily_plan_period*7) ~ 플랜종료일(=52주) 
                  
                  --   (참고1) 플랜시작일~ 플랜종료일 기간중 특정기간은 bucket_type : DAY, 특정기간은 bucket_type : WEEK 로 사용시 현재로직을 사용하면됨
                  --   (참고2) 현재 위 1)의 daily_plan_period가 52주로 플랜종료일과 같으므로 2)은 생성데이터 없음( 단, scm_mst_division.daily_plan_period 값이 플랜종료일보다 작을경우 데이터조회됨)                  
                  -------------------------------------------------
                       - 조회기간 : 특정주 ~ 플랜종료일(52주, @v_pet_date)
                       

                      - 컬럼1) start_dttm     : MIN(scm_mst_bucket.yyyymmdd) GROUP BY SCM_MST_BUCKET.yyyypw
                      - 컬럼2) end_dttm       : MAX(scm_mst_bucket.yyyymmdd) + 1일  GROUP BY SCM_MST_BUCKET.yyyypw
                      - 컬럼3) bucket_type    : 'WEEK' 셋팅
                      - 컬럼4) work_time      : 24 * 60 * COUNT(SCM_MST_BUCKET.yyyymmdd) (단위 : 분) => COUNT(SCM_MST_BUCKET.yyyymmdd) : GROUP BY SCM_MST_BUCKET.yyyypw 된 일수
                      - 컬럼5) work_time_uom  : 'PLAN'
                      - 컬럼6) descr          : 'PLAN' 셋팅  (플랜시작일~플랜종료일까지 'PLAN' 셋팅함)


                  -------------------------------------------------
                  -3) 플랜종료일 + 13주
                  -------------------------------------------------
                      - 조회기간 : 플랜종료일(=@v_pet_date) ~ +13주
                      - 무한 CAPA

                      - 컬럼1) start_dttm     : MIN(scm_mst_bucket.yyyymmdd)  GROUP BY SCM_MST_BUCKET.yyyyww
                      - 컬럼2) end_dttm       : MAX(scm_mst_bucket.yyyymmdd) + 1일  GROUP BY SCM_MST_BUCKET.yyyyww
                      - 컬럼3) bucket_type    : 'WEEK' 셋팅
                      - 컬럼4) work_time      : '999999000' (단위 : 분)
                      - 컬럼5) work_time_uom  : 'MINUTE'
                      - 컬럼6) descr          : 'ADD' 셋팅  (플랜종료일이후 'ADD' 셋팅)

 * OutTable     : TH_ENG_BUCKET_INFO
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.29   정원식		   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.05   KSG            LATE TYPE 변경 / 13주 추가기간 설정
 * 2018.08.07   KSG            특정 주차 이내 구간 DAILY, 이후 구간 WEEKLY 적용
 * 2018.08.09   KSW            DAILY BUCKET 구간 주(week) 수 값을 변수로 설정
 * 2021.04.22   KSG            C20210420-000326   소형SCP Ship REQ 생성 Logic 변경 요청 : 무한 Capa 반영 값 변경
 * 2022.01.17   LHS			   PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 계획수립기간을 lookup으로 설정하여 Engine Plan 기간으로 반영
 * 2023.10.24   KKC            PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 유한Capa 구간 변경 (기존 52주 : 변경 : 52주 + ADD_DEMAND_PERIOD)  
                               1차로 소형만 적용 협의. 
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_BUCKET_INFO]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_BUCKET_INFO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_BUCKET_INFO';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- 추가기간 반영된 Plan End Date

    DECLARE @n_daily_plan_period INTEGER;   -- 2018.08.09 추가( DAILY BUCKET 구간 사용기간 주(week) 수 ); 
    
    DECLARE @v_add_dm_pet      NVARCHAR(8) ; -- 추가 DM 기간 반영된 Plan End Date, 2023.10.24 추가 

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
    
        /* DM ADD 구간으로 유한CAPA 생성, 2023.10.24 */
        SELECT @v_pet_date     = p.horizon_end_date 
	        ,  @v_add_dm_pet   = CASE WHEN @p_division_id = '40' THEN 
                                            CONVERT(NVARCHAR(8), DATEADD(DAY, ISNULL(b.add_dm_day, 0), CONVERT(DATETIME, p.horizon_end_date)), 112)
                                      ELSE
                                            CONVERT(NVARCHAR(8), DATEADD(DAY, 0, CONVERT(DATETIME, p.horizon_end_date)), 112) 
                                 END
            ,  @v_add_pet_date = CONVERT(NVARCHAR(8), DATEADD(DAY, ISNULL(c.add_plan_day,(13*7)), CONVERT(DATETIME, p.horizon_end_date)), 112) -- 추가기간이 NULL이면 디폴트 13주 설정 
         FROM dbo.scm_mst_plan p WITH(NOLOCK)
         LEFT OUTER JOIN 
		      (
		      SELECT a.segment1 AS division_id , a.segment2 AS add_dm_week , a.segment2*7 AS add_dm_day 
		          FROM scm_adm_lookup_master_detail a WITH (NOLOCK)
		          WHERE a.lookup_type = 'ADD_DEMAND_PERIOD'
		          AND a.valid_yn    = 'Y' 
                  AND a.segment1    = @p_division_id
		      ) b
           ON 1=1
         LEFT OUTER JOIN 
              (   
              /** (2022.03.02) 사업부별 추가 Demand 반영구간을 Lookup에서 가져온다. 단위:week  **/
		      SELECT a.segment1 AS division_id , a.segment2 AS add_plan_week , a.segment2*7 AS add_plan_day 
		          FROM scm_adm_lookup_master_detail a WITH (NOLOCK)
		          WHERE a.lookup_type = 'ADD_PLAN_PERIOD'
		          AND a.valid_yn    = 'Y' 
                  AND a.segment1    = @p_division_id
              ) c
           ON 1=1 
        WHERE p.division_id = @p_division_id 
          AND p.plan_id     = @p_plan_id 
        ;

        /* ORG ~
        --  Plan End Date 
	    SELECT @v_pet_date      = p.horizon_end_date 
			,  @v_add_pet_date  = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day,(13*7)), CONVERT(DATETIME, P.HORIZON_END_DATE)), 112) -- 추가기간이 NULL이면 디폴트 13주 설정 
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		/** (2022.01.17) 사업부별 추가계획기간 lookup으로 반영  **/ 
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

        */

        --20180809 추가 bucket주기 DAILY BUCKET 구간 주(week) 수
        SELECT @n_daily_plan_period = daily_plan_period
        FROM   scm_mst_division WITH (NOLOCK)
        WHERE  division_id = @p_division_id        
        ;

        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_IN_PRE_PROC_BUCKET_INFO */ 
        FROM  th_eng_bucket_info_sn
        WHERE 1=1
        AND   master_id = @p_master_id
        AND   plan_id   = @p_engine_plan_id
        ;

        /* DEMAND ADD PLAN 구간 유한 CAPA로 생성(소형만), 2023.10.24 */
        INSERT INTO th_eng_bucket_info_sn
              (MASTER_ID
              ,PLAN_ID
              ,BUCKET_SEQ
              ,START_DTTM
              ,END_DTTM
              ,BUCKET_TYPE
              ,WORK_TIME
              ,WORK_TIME_UOM
              ,DESCR
              )
        SELECT @p_master_id                                  AS master_id
              ,@p_engine_plan_id                             AS plan_id
              ,row_number() OVER (ORDER BY a.start_dttm ASC) AS bucket_seq
              ,a.start_dttm                                  AS start_dttm
              ,a.end_dttm                                    AS end_dttm
              ,a.bucket_type                                 AS bucket_type
              ,a.work_time                                   AS work_time
              ,a.work_time_uom                               AS work_time_uom
              ,a.descr                                       AS descr
        FROM  (--1) Daily Bucket (Normal 정규 구간)
               SELECT CONVERT(DATE, b.YYYYMMDD)                   AS start_dttm
                     ,DATEADD(DD, 1, CONVERT(DATE, b.YYYYMMDD))   AS end_dttm
                     ,'DAY'                                       AS bucket_type
                     ,24 * 60                                     AS work_time
                     ,'MINUTE'                                    AS work_time_uom
                     ,'PLAN'                                      AS descr
               FROM  SCM_MST_BUCKET b with(nolock)
              WHERE  yyyymmdd >= @p_plan_name
                AND  yyyymmdd <= @v_pet_date
			    AND  yyyymmdd <= @v_add_pet_date
              --AND  yyyymmdd <  CONVERT(CHAR(8), DATEADD(DD, @n_daily_plan_period * 7, CONVERT(DATE, @p_plan_name)), 112) --20180809 수정 DAILY BUCKET 구간 주(week) 수를 변수로 변경 ( 변경전 :  AND    yyyymmdd <  CONVERT(CHAR(8), DATEADD(DD, 16*7, CONVERT(DATE, @p_plan_name)), 112) -- 2018.08.07 16주 구간 Daily Bucket  )               
               UNION
               --2) Daily Bucket (DEMAND ADD 구간), 2023.10.24 수정 
               SELECT CONVERT(DATE, b.YYYYMMDD)                   AS start_dttm
                     ,DATEADD(DD, 1, CONVERT(DATE, b.YYYYMMDD))   AS end_dttm
                     ,'DAY'                                       AS bucket_type
                     ,24 * 60                                     AS work_time
                     ,'MINUTE'                                    AS work_time_uom
                     ,'ADD_PLAN'                                  AS descr
               FROM  SCM_MST_BUCKET b with(nolock)
              WHERE  yyyymmdd >  @v_pet_date
                AND  yyyymmdd <= @v_add_dm_pet		   
			    AND  yyyymmdd <= @v_add_pet_date
               UNION
               --3) @v_add_dm_pet 이후 13주 구간 Weekly Bucket 추가 : 무한 Capa, , 2023.10.24 수정
               SELECT CONVERT(DATE, MIN(b.YYYYMMDD))                   AS start_dttm
                     ,DATEADD(DD, 1, CONVERT(DATE, MAX(b.YYYYMMDD)))   AS end_dttm
                     ,'WEEK'                                           AS bucket_type
                     ,'999999000'                                      AS work_time  -- 20210422 C20210420-000326 무한 Capa 반영 값 변경(OLD : 999999)
                     ,'MINUTE'                                         AS work_time_uom
                     ,'ADD'                                            AS descr
                FROM  SCM_MST_BUCKET b with(nolock)
               WHERE  yyyymmdd >  @v_add_dm_pet    
                 AND  yyyymmdd <= @v_add_pet_date
               GROUP 
                  BY yyyyww
              ) a    
        ;

        /* ORG 
        INSERT INTO th_eng_bucket_info_sn
              (MASTER_ID
              ,PLAN_ID
              ,BUCKET_SEQ
              ,START_DTTM
              ,END_DTTM
              ,BUCKET_TYPE
              ,WORK_TIME
              ,WORK_TIME_UOM
              ,DESCR
              )
        SELECT @p_master_id                                  AS master_id
              ,@p_engine_plan_id                             AS plan_id
              ,row_number() OVER (ORDER BY a.start_dttm ASC) AS bucket_seq
              ,a.start_dttm                                  AS start_dttm
              ,a.end_dttm                                    AS end_dttm
              ,a.bucket_type                                 AS bucket_type
              ,a.work_time                                   AS work_time
              ,a.work_time_uom                               AS work_time_uom
              ,a.descr                                       AS descr
        FROM  (--1) Daily Bucket 
               SELECT CONVERT(DATE, b.YYYYMMDD)                   AS start_dttm
                     ,DATEADD(DD, 1, CONVERT(DATE, b.YYYYMMDD))   AS end_dttm
                     ,'DAY'                                       AS bucket_type
                     ,24 * 60                                     AS work_time
                     ,'MINUTE'                                    AS work_time_uom
                     ,'PLAN'                                      AS descr
               FROM   SCM_MST_BUCKET b with(nolock)
               WHERE  yyyymmdd >= @p_plan_name
               AND    yyyymmdd <  CONVERT(CHAR(8), DATEADD(DD, @n_daily_plan_period * 7, CONVERT(DATE, @p_plan_name)), 112) --20180809 수정 DAILY BUCKET 구간 주(week) 수를 변수로 변경 ( 변경전 :  AND    yyyymmdd <  CONVERT(CHAR(8), DATEADD(DD, 16*7, CONVERT(DATE, @p_plan_name)), 112) -- 2018.08.07 16주 구간 Daily Bucket  )
               AND    yyyymmdd <= @v_pet_date -- @n_daily_plan_period 가 Plan 주차보다 클 경우 pet 까지만 처리

               UNION
               --2) 2018.08.07 특정주 이후, @v_pet_date 이내 구간 Weekly Bucket 
               SELECT CONVERT(DATE, MIN(b.YYYYMMDD))                   AS start_dttm
                     ,DATEADD(DD, 1, CONVERT(DATE, MAX(b.YYYYMMDD)))   AS end_dttm
                     ,'WEEK'                                           AS bucket_type
                     ,24 * 60 * COUNT(b.yyyymmdd)                      AS work_time -- Work Calendar 생성 후 7일은 작업 시간으로 처리 필요함
                     ,'MINUTE'                                         AS work_time_uom
                     ,'PLAN'                                           AS descr
               FROM   SCM_MST_BUCKET b with(nolock)
               WHERE  yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, @n_daily_plan_period * 7, CONVERT(DATE, @p_plan_name)), 112) --20180809 수정  DAILY BUCKET 구간 주(week) 수를 변수로 변경 ( 변경전 : WHERE  yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, 16*7, CONVERT(DATE, @p_plan_name)), 112) -- 16주 이후 구간 Weekly Bucket )
               AND    yyyymmdd <= @v_pet_date			   
               GROUP BY yyyypw

               UNION
               --3) 2018.07.05 @v_pet_date 이후 13주 구간 Weekly Bucket 추가 : 무한 Capa
               SELECT CONVERT(DATE, MIN(b.YYYYMMDD))                   AS start_dttm
                     ,DATEADD(DD, 1, CONVERT(DATE, MAX(b.YYYYMMDD)))   AS end_dttm
                     ,'WEEK'                                           AS bucket_type
                     ,'999999000'                                      AS work_time  -- 20210422 C20210420-000326 무한 Capa 반영 값 변경(OLD : 999999)
                     ,'MINUTE'                                         AS work_time_uom
                     ,'ADD'                                            AS descr
               FROM   SCM_MST_BUCKET b with(nolock)
               WHERE  yyyymmdd >  @v_pet_date
			   AND    yyyymmdd <= @v_add_pet_date  --- (2022.01.17) 수정
               /*    (22.01.17 변경전 코드 )
			   AND    yyyymmdd <= CONVERT(CHAR(8), DATEADD(DD, 13*7, CONVERT(DATE, @v_pet_date)), 112) 
			   */ 
               GROUP BY yyyyww
              ) a    
        ORDER BY a.start_dttm
        ;
        */
				
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
