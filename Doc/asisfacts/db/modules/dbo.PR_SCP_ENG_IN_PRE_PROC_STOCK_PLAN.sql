
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_STOCK_PLAN
 * Description  : ODB의 재고/해상재고 정보를 ODB에 적재되도록 한다.
 * OutTable     : th_eng_stock_plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.22   KSW         전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.14   KSG         INT : From Site 구분 추가
 * 2021.09.07   KKC         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선, 전진검사 재고상태 구분 추가
 * 2021.11.30   KKC         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선, LOT_ID에 INSP_TYPE 추가(UNIQUE)
 * 2022.07.06   LHS         PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2: 해상재고의 PJT CODE와 DEMAND의 PJT CODE가 같을 시 CONSUME할 수 있도록 Hard Pegging 설정 추가
 * 2022.09.15   LHS         PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2: INT재고 가용시간 +10초 설정로직 제거하고, STOCK_SEQ를 후순위로 정의
 * 2023.04.18   KSG         PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 도전과제 계획
 * 2023.06.26   KKC         PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 재고 로직 변경  (기존 : 음수재고 제외 -> 변경 : 음수재고까지 SUM 한 후에 0보도 큰 재고(INV 재고만) 반영
 * 2024.04.02   KKC         PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : STOCK_USE_YN값 오류 수정
 * 2024.08.23   KKC         E20240821-000905 운송중 재고 Project 할당 로직 적용 : ACEN1063I-D1 / To site : MOBIS_KR_CHU
                                                                                  양산/리콜 프로젝트가 동시에 존재하므로 운송중, to site재고는 양산(A16HC2002) 프로젝트 재고로 변경 요청
 * 2025.04.21   KJJ         E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_STOCK_PLAN]  
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_STOCK_PLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_STOCK_PLAN';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    --DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;
       
    /*~ 2022.07.06 FIXED_PLAN의 Project code 유지여부 설정 변수 정의. * division_id, plan_type별 가부(Y/N)을 lookup에서 등록한다. ~*/ 
    DECLARE @v_hp_pjt_code_yn        NVARCHAR(30) = 'N'   ; 
    -- 20230418 PJ20230691 도전과제 처리 부분 수정 : BP/BF 추가
	SELECT @v_hp_pjt_code_yn =            
           CASE WHEN  @p_plan_type IN ('PR', 'BP') THEN (CASE WHEN ISNULL(SEGMENT2 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type IN ('MA'      ) THEN (CASE WHEN ISNULL(SEGMENT3 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type IN ('SE'      ) THEN (CASE WHEN ISNULL(SEGMENT4 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type IN ('FN', 'BF') THEN (CASE WHEN ISNULL(SEGMENT5 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type IN ('TE'      ) THEN (CASE WHEN ISNULL(ATTRIBUTE1 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )   
           END  
	FROM   scm_adm_lookup_master_detail a WITH(NOLOCK) 
	WHERE  a.lookup_type = 'HP_PJT_CODE_YN'
    AND    a.segment1    =  @p_division_id
    AND    a.valid_yn    = 'Y' 
    ; 

     /*~ 2022.07.06  FIXED_PLAN에 HP옵션을 설정했을 때 추가로 STOCK에 HO옵션을 설정할 수 있음. 
        @v_hp_pjt_code_yn = N  -->  @v_hp_pjt_code_stock_yn = N   
        @v_hp_pjt_code_yn = Y  -->  LOOKUP의 'STOCK_USE_YN' 설정값 반영 
     ~*/
     DECLARE @v_hp_pjt_code_stock_yn     NVARCHAR(30) = 'N'   ; 
     SELECT  @v_hp_pjt_code_stock_yn = 
            CASE WHEN  ISNULL(a.attribute2, '-') = 'Y'  THEN 'Y' ELSE 'N' END  
     FROM   scm_adm_lookup_master_detail a WITH(NOLOCK) 
     WHERE  a.lookup_type = 'HP_PJT_CODE_YN'
     AND    a.segment1    =  @p_division_id
     AND    a.valid_yn    = 'Y' 
     AND    @v_hp_pjt_code_yn = 'Y'
     ; 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
        DELETE   /* PR_SCP_ENG_IN_PRE_PROC_STOCK_PLAN */
        FROM     th_eng_stock_plan_sn
        WHERE    master_id = @p_master_id 
        AND      plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------
        
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_STOCK_PLAN */ th_eng_stock_plan_sn
        (   master_id
          , plan_id
          , stock_seq
          , item_id
          , site_id
          , route_id
          , operation_id
          , receiving_dttm
          , qty
          , lot_id
          , work_order_id
          , demand_id
          , descr
		  , insp_type  -- 전진검사 재고 구분값, 2021.09.07 추가
          , business_type  -- 2022.07.06: Project code 값 
		  , plant_type --2025.04.21 추가
        )
        SELECT @p_master_id                                   AS master_id
             , @p_engine_plan_id                              AS plan_id
               /*~(2022.09.15) Intransit재고를 후순위로 사용하게 하기 위해 seq에 항목 추가.~*/
             , ROW_NUMBER() OVER(ORDER BY a.item_id, a.scm_site_id, a.route_id, a.operation_id, a.effstartdate , case when a.descr = 'INT' then 2 else 1 end  ) AS stock_seq
             /* 220915 수정전 코드
             , ROW_NUMBER() OVER(ORDER BY a.item_id, a.scm_site_id, a.route_id, a.operation_id, a.effstartdate) AS stock_seq
             */  
             --  , decode(b.item_type, 'R', a.item_id, TRIM(a.item_id || '^' || a.scm_site_id)) AS item_id
             , a.item_id                                      AS item_id
             , CASE WHEN b.item_type = 'R' THEN NULL
                    ELSE a.scm_site_id
               END                                            AS site_id
             , CASE WHEN b.item_type = 'R' THEN NULL
                    ELSE a.route_id
               END                                            AS route_id
             , CASE WHEN b.item_type = 'R' THEN NULL
                    ELSE a.operation_id
                    END                                       AS operation_id
             , ISNULL(a.effstartdate, convert(datetime, @p_plan_name)) AS receiving_dttm
             , a.qty                                          AS qty -- Total 재고/해상재고 : 재고/해상재고 + 해상재고/해상재고
             , a.lot_id                                       AS lot_id
             -- TH_ENG_STOCK_PLAN의 WORK_ORDER_ID와 DEMAND_ID는 NULL 처리해야함
             , NULL        AS work_order_id
             , NULL        AS demand_id
             , a.descr     AS descr     -- Lot ID 구분자
			 , a.insp_type AS insp_type -- 전진검사 구분값, 2021.09.07 추가             
              /*~ 2022.07.06 lookup의 설정여부에 따라 business_type값 정의: Y이면 project_code값을, N이면 'ALL'로 설정  ~*/ 
             , CASE WHEN @v_hp_pjt_code_stock_yn = 'Y'  AND  ISNULL(project_code_new, '-') NOT IN ( '-' , 'TBD' ) THEN project_code_new   --~'TBD' 타입은 'ALL' 처리한다.
                    ELSE 'ALL' 
               END  AS business_type 
			 , a.plant_type --2025.04.21 추가
        FROM   (
                SELECT item_id
                     , scm_site_id
                     , scm_site_id   AS route_id
                     , scm_site_id   AS operation_id                  
                     --, CONVERT(DATE, CONVERT(CHAR(8), available_date, 112)) AS effstartdate -- 동일일자인 경우 WH > INT > REP 우선 적용
                     -- BOH 적용을 위하여 Plant Start Date의 재고는 전일자로 Input하기로 함
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N'
                                 THEN DATEADD(DD, -1, CONVERT(DATE, CONVERT(CHAR(8), available_date, 112)))   
                            ELSE      CONVERT(DATE, CONVERT(CHAR(8), available_date, 112))  
                       END             AS effstartdate
                     , SUM(qty)        AS qty
                     , NULL            AS work_order_id
                     , NULL            AS demand_id
                     , 0               AS wh_in_qty -- 해상 재고/해상재고 정보 추가
                     --, 'WH::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112) AS lot_id
                     --, 'WH' AS descr
              --2025.04.21                     
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'WH::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                            ELSE      'WH_HOLD::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                       END + '::' +  ISNULL(t.wip_type_code, 'NONE') + '::' + ISNULL(t.from_scm_site_id, '')  AS lot_id
					   --//2021.11.30 수정/보완, wip_type_code별 lot_id 생성
            /*         , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'WH::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                            ELSE      'WH_HOLD::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                       END + '::' +  ISNULL(t.wip_type_code, 'NONE')  AS lot_id
            */           
					 /* OLD
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'WH::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                            ELSE      'WH_HOLD::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                       END             AS lot_id
					  */					  
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'WH'
                            ELSE      'WH_HOLD'
                       END             AS descr
                     , t.wip_type_code AS insp_type --2021.09.07 추가
                     , NULL            AS project_code_new --2022.07.06 추가
					 , t.from_scm_site_id AS plant_type --2025.04.21 추가
                FROM   scp_eng_inventory_i_sn t WITH(NOLOCK)
                WHERE  t.modeling_id = @p_modeling_id
                AND    t.plan_id     = @p_plan_id
                AND    t.plan_type   = @p_plan_type 
                AND    t.plan_seq    = @p_seq
                AND    t.stock_type <> 'FOR' 
                --AND    t.qty         > 0    --2023.06.26 변경
                GROUP 
				   BY item_id
				    , scm_site_id
					, CONVERT(CHAR(8), available_date, 112)
					, ISNULL(t.wiphold_yn, 'N')
					, t.wip_type_code --2021.09.07 추가  
					, t.from_scm_site_id --2025.04.21 추가
			    HAVING SUM(t.qty) > 0	      --2023.06.26 변경			      
				UNION ALL
                -- 활성화 재고 : FOR 로 처리
                SELECT item_id
                     , scm_site_id
                     , scm_site_id   AS route_id
                     , scm_site_id   AS operation_id                  
                     --, CONVERT(DATE, CONVERT(CHAR(8), available_date, 112)) AS effstartdate -- 동일일자인 경우 WH > INT > REP 우선 적용
                     , CASE WHEN CONVERT(CHAR(8), available_date, 112) < @p_plan_name 
                                 THEN CONVERT(DATE, CONVERT(CHAR(8), @p_plan_name, 112))   -- available_date 가 과거인 경우 Plan Name으로 처리함
                            ELSE      CONVERT(DATE, CONVERT(CHAR(8), available_date, 112))  
                       END            AS effstartdate
                     , SUM(qty)       AS qty
                     , NULL           AS work_order_id
                     , NULL           AS demand_id
                     , 0              AS wh_in_qty -- 해상 재고/해상재고 정보 추가
                     --, 'FOR::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112) AS lot_id
                     --, 'FOR' AS descr
					 
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'FOR::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                            ELSE      'FOR_HOLD::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                       END            AS lot_id
					 
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'FOR'
                            ELSE      'FOR_HOLD'
                       END            AS descr
                     , NULL           AS insp_type    --2021.09.07 추가
                     , NULL           AS project_code_new --2022.07.06 추가
					 , t.from_scm_site_id AS plant_type --2025.04.21 추가
                FROM   scp_eng_inventory_i_sn t WITH(NOLOCK)
                WHERE  t.modeling_id = @p_modeling_id
                AND    t.plan_id     = @p_plan_id
                AND    t.plan_type   = @p_plan_type 
                AND    t.plan_seq    = @p_seq
                AND    t.stock_type  = 'FOR' -- 활성화 재고
                AND    t.qty         > 0 
                GROUP BY item_id, scm_site_id, CONVERT(CHAR(8), available_date, 112), ISNULL(t.wiphold_yn, 'N')
				         , from_scm_site_id --2025.04.21 추가
                UNION ALL
                -- intransit shipment 재고 
                SELECT item_id
                     , to_scm_site_id AS scm_site_id
                     , to_scm_site_id AS route_id
                     , to_scm_site_id AS operation_id
                     /*~(2022.09.15) 가용시간에 10초 추가한 로직을 제거하고 대신 (위쪽)stock_seq에 다른 타입보다 INT가 후순위가 되도록 한다.~*/ 
                     , CASE WHEN eta_date < @p_plan_name    THEN CONVERT(DATETIME, @p_plan_name)  
                            ELSE CONVERT(DATETIME, eta_date) 
                            END  AS effstartdate
                     /* 220915 수정전 코드 
                     --, DATEADD(S, 10, CONVERT(DATETIME, eta_date)) AS effstartdate -- 동일일자인 경우 WH > INT > REP 우선 적용 : 10 초 추가
                     , CASE WHEN eta_date < @p_plan_name THEN DATEADD(S, 10, CONVERT(DATETIME, @p_plan_name)) 
                            ELSE DATEADD(S, 10, CONVERT(DATETIME, eta_date))
                       END  AS effstartdate
                     */ 
                     , SUM(delivery_qty) AS qty
                     , NULL AS work_order_id
                     , NULL AS demand_id
                     , SUM(delivery_qty) AS wh_in_qty -- 해상 재고/해상재고 정보 추가
                     , 'INT::' + to_scm_site_id + '::' + item_id + '::' + t.eta_date + '::' + ISNULL(t.org_from_scm_site_id, '') AS lot_id -- 2018.06.14  From Site 구분 추가
                     , 'INT' AS descr
					 , NULL              AS insp_type --2021.09.07 추가
                       --2022.07.06 추가 : project_code_new 
                     , CASE WHEN se.site_type = 'SALES' AND  t.project_code = ''  THEN '-'   --~소형에 '' 값이 들어와서 ALL처리 대상인 '-' 로 치환함.
                            WHEN se.site_type = 'SALES' AND  t.result_type  = 'C' THEN '-'   --~Result_type='C'는 법인간 재고 시 pjt code가 아예 없는 케이스이므로 ALL처리 대상인 '-' 로 치환함. 
                            WHEN se.site_type != 'SALES'                          THEN '-'   --~to_site_id의 type이 Sales가 아니면 ALL처리 대상인 '-' 로 치환함. 
                            ELSE t.project_code                                              --~예외처리 대상 이외는 자기코드값 사용함.
                       END  AS  project_code_new    
					 , t.org_from_scm_site_id AS plant_type --2025.04.21추가
                FROM   scp_eng_intransitshpmnt_i_sn t WITH(NOLOCK)
                LEFT OUTER JOIN  ---2022.07.06 추가 - SAELS TYPE 필터링용: Pjt cdoe는 to_site가 SALES 일때만 적용해줘야 한다.
                        SCM_MST_SITE_ENG   se WITH(NOLOCK)
                        ON  (se.MODELING_ID  = @p_modeling_id
                        AND  se.PLAN_ID      = @p_plan_id
                        AND  se.PLAN_TYPE    = @p_plan_type
                        AND  se.PLAN_SEQ     = @p_seq
                        AND  se.DIVISION_ID  = @p_division_id 
                        AND  se.eng_scm_site_id = t.to_scm_site_id  )
                WHERE  t.modeling_id   = @p_modeling_id
                AND    t.plan_id       = @p_plan_id
                AND    t.plan_type     = @p_plan_type 
                AND    t.plan_seq      = @p_seq
                --AND    t.incoterms    <> 'FOB' -- eng에서 처리한 대로 사용
                AND    t.delivery_qty  > 0 
                AND   (t.eta_date IS NOT NULL OR t.eta_date <> '')
                GROUP BY item_id, to_scm_site_id, eta_date, ISNULL(t.org_from_scm_site_id, '') , project_code -- 2018.06.14  From Site 구분 추가
                     , CASE WHEN se.site_type = 'SALES' AND  t.project_code = ''  THEN '-' 
                            WHEN se.site_type = 'SALES' AND  t.result_type  = 'C' THEN '-'  
                            WHEN se.site_type != 'SALES'                          THEN '-'  
                            ELSE t.project_code
                        END 
					, t.org_from_scm_site_id --2025.04.21 추가
   --         UNION ALL
   ---- 3. 자재재고/해상재고
   --         SELECT cd.enterprise
   --              , cd.item_id
   --              , cd.sitename AS siteid
   --              , cd.sitename AS route_id
   --              , cd.sitename AS operation_id
   --              , TRUNC(cd.effstartdate) + 20/24/60/60 AS effstartdate -- 동일일자인 경우 WH > INT > REP 우선 적용 : 20 초 추가
   --              , SUM(cba.value) AS qty
   --              , NULL AS work_order_id
   --              , NULL AS demand_id
   --              , 0 AS wh_in_qty -- 해상 재고/해상재고 정보 추가
   --              , 'REP::' + cd.sitename + '::' + cd.item + '::' + TO_CHAR(cd.effstartdate, 'YYYYMMDD') AS lot_id
   --              , 'REP' AS descr
               ) a
             , (SELECT DISTINCT t.item_type, t.item_id
                FROM   th_eng_item_sn t WITH(NOLOCK)
                WHERE  t.master_id = @p_master_id
                AND    t.plan_id   = @p_engine_plan_id
               ) b
        WHERE  a.item_id = b.item_id
        AND    b.item_type <> 'R' -- 20140423 ksg 티라 요청으로 R Type의 재고는 올리지 않음
        ;

        --CSR(E20240821-000905), 임시 적용 쿼리 추가. 2024.08.23
        IF @p_division_id = '81' 

        BEGIN
              UPDATE a
                 SET a.business_type = 'A16HC2002'
                FROM th_eng_stock_plan_sn a
               WHERE a.master_id = @p_master_id 
                 AND a.plan_id   = @p_engine_plan_id 
                 AND a.item_id   = 'ACEN1063I-D1'
                 AND a.site_id LIKE 'MOBIS_KR_CHU%'
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
