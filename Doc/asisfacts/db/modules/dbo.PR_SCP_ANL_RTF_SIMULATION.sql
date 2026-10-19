/*
 * Program ID   : PR_SCP_ANL_RTF_SIMULATION
 * Description  : 출하계획(SHIP_PLAN_AMEND) 수정 시 RTF 재계산 및 Shipment Plan FG measure 갱신
 *                - 수요   : 동일 버전 MKT_FCST 기준. 수요가 있는 조합에 대해서만 measure 생성
 *                - 공급   : 재고/운송중(SCP_EGN_OTPT_INV_M, SALES 사이트 기준. EFFECTIVE_DATE가
 *                           계획시작일 이전이면 기초재고 처리) + SHIP_PLAN_AMEND(BOD L/T 반영 도착일)
 *                - RTF    : 충족 발생일 버킷에 생성. 재고 우선, 가용일 순 소진.
 *                           RTF 누적은 수요 누적을 초과할 수 없음
 *                - Demand Group : SCP_MST_ITEM_GROUP(_DETAIL) 기준(Project/Group당 2개 모델 이상).
 *                           모델별 부족분은 그룹 내 타 모델 가용분으로 대응하되
 *                           RTF는 공급한 모델 쪽에 집계됨 (개별 RTF가 개별 수요 초과 가능)
 *                - BALANCE = 오늘까지 RTF 합 - 오늘까지 MKT_FCST 합
 *                - WH_IN_BALANCE = Balance가 0보다 작으면 Balance+기말재고, 아니면 기말재고
 *                - WH_IN  : From site 별 생성 (출하계획 도착분. 재고/운송중 도착분은 From site '-')
 *                - INCOTERMS : VMI 사이트는 수요 기준, 그 외는 출하계획 기준으로 세팅
 *                - @p_gen_ship_req='Y' 인 경우 PR_SCP_ANL_SHIP_REQ_GEN 호출하여 SHIP_REQ 재생성
 *                - Demand Group 교차 이전분(공급 Item ≠ 수요 Item)은 SCP_ANL_RTF_SIM_TRANS에 기록
 *                상세 계산 규칙은 ShipPlanFG Measure 생성로직 정의 문서 참조
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.09.22   JCH            Initial Release
 * 2026.09.28   JCH            Measure 생성로직 정의 반영 (RTF 버킷 기준 변경, WH_IN From site별 생성,
 *                             WH_IN_BALANCE 산식 변경, Demand Group 대응, SHIP_REQ 연동 추가)
 * 2026.09.29   JCH            소스 정리 (서식 표준화, 컬럼 주석 보강)
 * 2026.09.29   JCH            Demand Group 교차 이전 상세(SCP_ANL_RTF_SIM_TRANS) 기록 추가
 */
CREATE PROCEDURE dbo.PR_SCP_ANL_RTF_SIMULATION
(
  @p_division_id          NVARCHAR(30)
, @p_plan_start_yyyymmdd  NVARCHAR(8)
, @p_plan_type            NVARCHAR(50)
, @p_seq                  BIGINT
, @p_inv_plan_id          NVARCHAR(100)
, @p_project_code         NVARCHAR(50)  = NULL
, @p_horizon_days         INT           = 630
, @p_gen_ship_req         NVARCHAR(1)   = 'N'
, @p_user_id              NVARCHAR(150) = 'rtf_sim'
)
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)  = 'PR_SCP_ANL_RTF_SIMULATION';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INT            = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_deleted      BIGINT         = 0;
    DECLARE @n_del_tr       BIGINT         = 0;
    DECLARE @n_batch        INT;

    -- 시작 LOG
    SET @v_log_type    = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = CONCAT('[',@p_division_id,'/',@p_plan_start_yyyymmdd,'/',@p_plan_type,'/',@p_seq,
                              '/inv=',@p_inv_plan_id,'/proj=',COALESCE(@p_project_code,'ALL'),
                              '/shipreq=',@p_gen_ship_req,']');
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type,     @n_log_count,
                              @v_log_message,  @v_description,  @d_event_date;

    BEGIN TRY
        /*-------------------------------------------------------------
          1. 수요 조회 (MKT_FCST)
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#dmd') IS NOT NULL DROP TABLE #dmd;
        SELECT f.PROJECT_CODE
             , f.ITEM_ID
             , f.TO_SITE
             , f.YYYYMMDD          AS due_d                                             -- 납기일자
             , MAX(f.INCOTERMS)    AS mkt_inc                                           -- 수요 기준 INCOTERMS (대표값)
             , MAX(f.BIZ_TYPE)     AS mkt_biz                                           -- 수요 기준 BIZ_TYPE (대표값)
             , SUM(f.QTY)          AS qty                                               -- 수요수량
          INTO #dmd
          FROM SCP_ANL_SHIPMENT_PLAN_FG f WITH (NOLOCK)
         WHERE f.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
           AND f.PLAN_TYPE           = @p_plan_type 
           AND f.SEQ                 = @p_seq
           AND f.DIVISION_ID         = @p_division_id 
           AND f.MEASURE             = 'MKT_FCST' 
           AND f.QTY                 > 0
           AND (@p_project_code IS NULL OR f.PROJECT_CODE = @p_project_code)
         GROUP BY f.PROJECT_CODE, f.ITEM_ID, f.TO_SITE, f.YYYYMMDD;

        /*-------------------------------------------------------------
          2. Demand Group 대상 조회 (Project/Group당 모델 2개 이상인 경우만)
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#grp') IS NOT NULL DROP TABLE #grp;
        SELECT a.PROJECT_CODE
             , a.ITEM_ID
             , a.GROUP_ID
          INTO #grp
          FROM (SELECT d.PROJECT_CODE
                     , d.ITEM_ID
                     , d.GROUP_ID
                     , COUNT(*) OVER (PARTITION BY d.PROJECT_CODE, d.GROUP_ID) AS cnt           -- 그룹 내 모델 수
                  FROM SCP_MST_ITEM_GROUP_DETAIL d WITH (NOLOCK)
                 WHERE d.DIVISION_ID = @p_division_id 
                   AND d.VALID_YN    = 'Y'
                   AND EXISTS (SELECT 'x' FROM SCP_MST_ITEM_GROUP g WITH (NOLOCK)
                                WHERE g.DIVISION_ID=d.DIVISION_ID AND g.GROUP_ID=d.GROUP_ID AND g.VALID_YN='Y')
               ) a
         WHERE a.cnt > 1;

        /*-------------------------------------------------------------
          3. 공급 수집 — 재고/운송중 + 출하계획 도착분 (수요 조합 및 같은 그룹의 모델 포함)
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#universe') IS NOT NULL DROP TABLE #universe;
        SELECT DISTINCT 
               u.PROJECT_CODE
             , u.ITEM_ID
             , u.TO_SITE
          INTO #universe
          FROM (
                SELECT PROJECT_CODE
                     , ITEM_ID
                     , TO_SITE
                  FROM #dmd
                 UNION
                SELECT g2.PROJECT_CODE
                     , g2.ITEM_ID
                     , d.TO_SITE
                  FROM #dmd d
                INNER JOIN #grp g1 ON g1.PROJECT_CODE=d.PROJECT_CODE AND g1.ITEM_ID=d.ITEM_ID
                INNER JOIN #grp g2 ON g2.PROJECT_CODE=g1.PROJECT_CODE AND g2.GROUP_ID=g1.GROUP_ID 
               ) u;

        IF OBJECT_ID('tempdb..#sup') IS NOT NULL DROP TABLE #sup;
        SELECT s.PROJECT_CODE
             , s.ITEM_ID
             , s.TO_SITE
             , s.avail_d
             , s.qty
             , s.src_prio
             , s.from_site
             , s.is_boh
             , s.amend_inc
          INTO #sup
          FROM (
                SELECT COALESCE(NULLIF(i.PROJECT_CODE,''),
                       NULLIF(dbo.fn_scm_split(dbo.fn_scm_split(i.ORDER_ID,4,'::'),3,'@'),''),  -- 프로젝트 미지정 시 ORDER_ID에서 추출
                       '-') AS PROJECT_CODE
                     , i.ITEM_ID
                     , i.SCM_SITE_ID AS TO_SITE
                     , CASE WHEN i.EFFECTIVE_DATE<=@p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd
                       ELSE i.EFFECTIVE_DATE END AS avail_d                                 -- 가용일 (계획시작일 이전 재고는 계획시작일로)
                     , i.QTY AS qty
                     , 1 AS src_prio                                                        -- 공급 우선순위 1:재고
                     , '-' AS from_site
                     , CASE WHEN i.EFFECTIVE_DATE <= @p_plan_start_yyyymmdd THEN 1 ELSE 0 END AS is_boh  -- 기초재고 여부
                     , CAST(NULL AS NVARCHAR(20)) AS amend_inc                              -- 출하계획 INCOTERMS (재고 행은 해당 없음)
                  FROM SCP_EGN_OTPT_INV_M i WITH (NOLOCK)
                INNER JOIN (SELECT DISTINCT SCM_SITE_ID FROM SCM_MST_SITE WITH (NOLOCK)
                            WHERE SITE_TYPE='SALES' AND VALID_YN='Y') m ON i.SCM_SITE_ID=m.SCM_SITE_ID
                 WHERE i.PLAN_ID=@p_inv_plan_id AND i.INVENTORY_TYPE IN ('WH','INT')
                 UNION ALL
                SELECT f.PROJECT_CODE
                     , f.ITEM_ID
                     , f.TO_SITE
                     , CONVERT(NVARCHAR(8), DATEADD(DAY, COALESCE(b.lt,0), CONVERT(DATE,f.YYYYMMDD)),112)  -- 도착일 (출하일 + 운송 L/T)
                     , f.QTY
                     , 2                                                                    -- 공급 우선순위 2:출하계획
                     , f.FROM_SITE
                     , 0                                                                    -- 기초재고 아님
                     , f.INCOTERMS                                                          -- 출하계획 INCOTERMS
                  FROM SCP_ANL_SHIPMENT_PLAN_FG f WITH (NOLOCK)
                LEFT OUTER JOIN (SELECT division_id
                                      , bod_id
                                      , MAX(add_after_lt_total) AS lt
                                   FROM scp_mst_bod_n_v WITH (NOLOCK) 
                                  WHERE bod_valid_yn='Y'
                                  GROUP BY division_id, bod_id
                                ) b ON b.division_id=f.DIVISION_ID AND b.bod_id=f.BOD_ID
                 WHERE f.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
                   AND f.PLAN_TYPE           = @p_plan_type 
                   AND f.SEQ                 = @p_seq
                   AND f.DIVISION_ID         = @p_division_id 
                   AND f.MEASURE             = 'SHIP_PLAN_AMEND' 
                   AND f.QTY > 0
               ) s
        INNER JOIN #universe u ON u.PROJECT_CODE=s.PROJECT_CODE AND u.ITEM_ID=s.ITEM_ID AND u.TO_SITE=s.TO_SITE;

        /*-------------------------------------------------------------
          4. 일반 모델 RTF 계산 (버킷 = 충족 발생일)
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#rtf') IS NOT NULL DROP TABLE #rtf;
        CREATE TABLE #rtf (PROJECT_CODE NVARCHAR(50), ITEM_ID NVARCHAR(50), TO_SITE NVARCHAR(30),
                           bkt NVARCHAR(8), qty NUMERIC(20,6));
        WITH ng AS (SELECT u.* FROM #universe u
                     WHERE NOT EXISTS (SELECT 1 FROM #grp g WHERE g.PROJECT_CODE=u.PROJECT_CODE AND g.ITEM_ID=u.ITEM_ID)),
        dc AS (SELECT d.*
                    , SUM(d.qty) OVER (PARTITION BY d.PROJECT_CODE,d.ITEM_ID,d.TO_SITE ORDER BY d.due_d ROWS UNBOUNDED PRECEDING)       AS t -- 수요 누적수량 구간 끝
                    , SUM(d.qty) OVER (PARTITION BY d.PROJECT_CODE,d.ITEM_ID,d.TO_SITE ORDER BY d.due_d ROWS UNBOUNDED PRECEDING)-d.qty AS f -- 수요 누적수량 구간 시작
                 FROM #dmd d INNER JOIN ng ON ng.PROJECT_CODE=d.PROJECT_CODE AND ng.ITEM_ID=d.ITEM_ID AND ng.TO_SITE=d.TO_SITE
              ),
        sc AS (SELECT s.*
                    , SUM(s.qty) OVER (PARTITION BY s.PROJECT_CODE,s.ITEM_ID,s.TO_SITE ORDER BY s.avail_d, s.src_prio, s.from_site ROWS UNBOUNDED PRECEDING) AS t  -- 공급 누적수량 구간 끝
                    , SUM(s.qty) OVER (PARTITION BY s.PROJECT_CODE,s.ITEM_ID,s.TO_SITE ORDER BY s.avail_d, s.src_prio, s.from_site ROWS UNBOUNDED PRECEDING)-s.qty AS f  -- 공급 누적수량 구간 시작
                 FROM #sup s INNER JOIN ng ON ng.PROJECT_CODE=s.PROJECT_CODE AND ng.ITEM_ID=s.ITEM_ID AND ng.TO_SITE=s.TO_SITE
              )
        INSERT #rtf
        SELECT d.PROJECT_CODE
             , d.ITEM_ID
             , d.TO_SITE
             , CASE WHEN d.due_d > s.avail_d THEN d.due_d ELSE s.avail_d END            -- RTF 버킷 = 충족 발생일 (납기/가용일 중 늦은 날)
             , SUM(CASE WHEN d.t<s.t THEN d.t ELSE s.t END - CASE WHEN d.f>s.f THEN d.f ELSE s.f END)  -- 배분수량 (수요/공급 누적구간 겹침)
          FROM dc d 
        INNER JOIN sc s ON (s.PROJECT_CODE=d.PROJECT_CODE AND s.ITEM_ID=d.ITEM_ID AND 
                            s.TO_SITE=d.TO_SITE           AND s.f<d.t AND s.t>d.f )
         GROUP BY d.PROJECT_CODE, d.ITEM_ID, d.TO_SITE
                , CASE WHEN d.due_d > s.avail_d THEN d.due_d ELSE s.avail_d END;

        /*-------------------------------------------------------------
          5. Demand Group 모델 RTF 계산 — 일자별 처리
             (자기 모델 가용 우선, 부족분은 그룹 내 타 모델 가용으로 대응. RTF는 공급 모델에 집계)
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#g_st') IS NOT NULL DROP TABLE #g_st;
        SELECT u.PROJECT_CODE
             , g.GROUP_ID
             , u.TO_SITE
             , u.ITEM_ID
             , CAST(0 AS NUMERIC(20,6)) AS eoh                                          -- 기말재고
             , CAST(0 AS NUMERIC(20,6)) AS unmet                                        -- 미충족 이월수량
             , CAST(0 AS NUMERIC(20,6)) AS cum_rtf                                      -- RTF 누적
          INTO #g_st
          FROM #universe u 
        INNER JOIN #grp g ON (g.PROJECT_CODE = u.PROJECT_CODE AND g.ITEM_ID = u.ITEM_ID);

        IF OBJECT_ID('tempdb..#g_days') IS NOT NULL DROP TABLE #g_days;
        SELECT d
             , ROW_NUMBER() OVER (ORDER BY d) AS rn                                     -- 일자 처리 순번
          INTO #g_days
          FROM (
                SELECT DISTINCT d.due_d AS d FROM #dmd d 
                INNER JOIN #g_st s ON (s.PROJECT_CODE=d.PROJECT_CODE AND s.ITEM_ID=d.ITEM_ID AND s.TO_SITE=d.TO_SITE)
                 UNION
                SELECT DISTINCT p.avail_d    FROM #sup p 
                INNER JOIN #g_st s ON (s.PROJECT_CODE=p.PROJECT_CODE AND s.ITEM_ID=p.ITEM_ID AND s.TO_SITE=p.TO_SITE)
               ) x;

        /* 그룹 교차 이전 상세 누적용 (공급 Item ≠ 수요 Item 인 대응분만) */
        IF OBJECT_ID('tempdb..#g_tr') IS NOT NULL DROP TABLE #g_tr;
        CREATE TABLE #g_tr (PROJECT_CODE NVARCHAR(50), GROUP_ID NVARCHAR(30), TO_SITE NVARCHAR(30),
                            YYYYMMDD NVARCHAR(8), SUPPLY_ITEM_ID NVARCHAR(50), DEMAND_ITEM_ID NVARCHAR(50),
                            qty NUMERIC(20,6));

        ----순차 가용 Pegging
        DECLARE @i INT = 1, @imax INT = (SELECT COALESCE(MAX(rn),0) FROM #g_days);
        DECLARE @day NVARCHAR(8);
        WHILE @i <= @imax
        BEGIN
            SET @day = (SELECT d FROM #g_days WHERE rn=@i);

            IF OBJECT_ID('tempdb..#gt') IS NOT NULL DROP TABLE #gt;
            SELECT st.PROJECT_CODE
                 , st.GROUP_ID
                 , st.TO_SITE
                 , st.ITEM_ID
                 , st.eoh + 
                   COALESCE((SELECT SUM(p.qty) FROM #sup p WHERE p.PROJECT_CODE=st.PROJECT_CODE AND p.ITEM_ID=st.ITEM_ID
                                                             AND p.TO_SITE=st.TO_SITE AND p.avail_d=@day),0) AS avail -- 당일 가용 = 전일 기말재고 + 당일 도착분
                 , st.unmet + 
                   COALESCE((SELECT SUM(d.qty) FROM #dmd d WHERE d.PROJECT_CODE=st.PROJECT_CODE AND d.ITEM_ID=st.ITEM_ID
                                                             AND d.TO_SITE=st.TO_SITE AND d.due_d=@day),0)   AS need  -- 당일 소요 = 당일 수요 + 이월 미충족
              INTO #gt 
              FROM #g_st st;

            IF OBJECT_ID('tempdb..#gt2') IS NOT NULL DROP TABLE #gt2;
            SELECT *
                 , CASE WHEN need<avail THEN need ELSE avail END AS own_rtf -- 자기 모델 가용으로 충족한 수량
              INTO #gt2 
              FROM #gt;

            IF OBJECT_ID('tempdb..#gt3') IS NOT NULL DROP TABLE #gt3;
            SELECT g.*
                 , sh.short_tot
                 , CASE WHEN cum_sur <= sh.short_tot THEN surplus
                   WHEN cum_sur - surplus >= sh.short_tot THEN 0
                   ELSE sh.short_tot - (cum_sur - surplus) END AS donated   -- 그룹 내 타 모델에 제공한 수량
              INTO #gt3
              FROM (SELECT *
                         , avail-own_rtf AS surplus                                             -- 자기 충족 후 잉여
                         , SUM(avail-own_rtf) OVER (PARTITION BY PROJECT_CODE,GROUP_ID,TO_SITE ORDER BY ITEM_ID ROWS UNBOUNDED PRECEDING) AS cum_sur -- 잉여 누적 (그룹 내)
                      FROM #gt2
                   ) g
            INNER JOIN (SELECT PROJECT_CODE
                             , GROUP_ID
                             , TO_SITE
                             , SUM(need-own_rtf) AS short_tot                                       -- 그룹 부족수량 합계
                          FROM #gt2 
                         GROUP BY PROJECT_CODE,GROUP_ID,TO_SITE
                       ) sh ON (sh.PROJECT_CODE=g.PROJECT_CODE AND sh.GROUP_ID=g.GROUP_ID AND sh.TO_SITE=g.TO_SITE);

            IF OBJECT_ID('tempdb..#gt4') IS NOT NULL DROP TABLE #gt4;
            SELECT g.*
                 , CASE WHEN cum_sh        <= dt.don_tot THEN sh_q
                        WHEN cum_sh - sh_q >= dt.don_tot THEN 0
                        ELSE dt.don_tot - (cum_sh - sh_q) 
                    END AS received                    -- 그룹 내 타 모델로부터 받은 수량
              INTO #gt4
              FROM (SELECT *
                         , need-own_rtf AS sh_q                                                 -- 자기 부족수량
                         , SUM(need-own_rtf) OVER (PARTITION BY PROJECT_CODE,GROUP_ID,TO_SITE ORDER BY ITEM_ID ROWS UNBOUNDED PRECEDING) AS cum_sh -- 부족수량 누적 (그룹 내)
                      FROM #gt3
                   ) g
            INNER JOIN (SELECT PROJECT_CODE
                             , GROUP_ID
                             , TO_SITE
                             , SUM(donated) AS don_tot                                              -- 그룹 제공수량 합계
                        FROM #gt3 GROUP BY PROJECT_CODE,GROUP_ID,TO_SITE
                       ) dt ON (dt.PROJECT_CODE=g.PROJECT_CODE AND dt.GROUP_ID=g.GROUP_ID AND dt.TO_SITE=g.TO_SITE);

            INSERT #rtf
            SELECT t.PROJECT_CODE
                 , t.ITEM_ID
                 , t.TO_SITE
                 , @day
                 , t.own_rtf + t.donated                                                -- RTF = 자기 충족 + 타 모델 제공분 (공급 모델 기준 집계)
              FROM #gt4 t
             WHERE t.own_rtf + t.donated > 0;

            /* 교차 이전 상세: 제공/수신 수량을 ITEM_ID 순 누적 구간 겹침으로 공급-수요 Item 쌍 분해 */
            INSERT #g_tr
            SELECT dn.PROJECT_CODE
                 , dn.GROUP_ID
                 , dn.TO_SITE
                 , @day
                 , dn.ITEM_ID                                                           -- 공급 Item
                 , rc.ITEM_ID                                                           -- 수요 Item
                 , CASE WHEN dn.t<rc.t THEN dn.t ELSE rc.t END
                 - CASE WHEN dn.f>rc.f THEN dn.f ELSE rc.f END                          -- 이전수량 (제공/수신 누적구간 겹침)
              FROM (SELECT PROJECT_CODE, GROUP_ID, TO_SITE, ITEM_ID
                         , SUM(donated) OVER (PARTITION BY PROJECT_CODE,GROUP_ID,TO_SITE ORDER BY ITEM_ID ROWS UNBOUNDED PRECEDING)         AS t  -- 제공 누적 구간 끝
                         , SUM(donated) OVER (PARTITION BY PROJECT_CODE,GROUP_ID,TO_SITE ORDER BY ITEM_ID ROWS UNBOUNDED PRECEDING)-donated AS f  -- 제공 누적 구간 시작
                      FROM #gt4
                     WHERE donated > 0
                   ) dn
            INNER JOIN (SELECT PROJECT_CODE, GROUP_ID, TO_SITE, ITEM_ID
                             , SUM(received) OVER (PARTITION BY PROJECT_CODE,GROUP_ID,TO_SITE ORDER BY ITEM_ID ROWS UNBOUNDED PRECEDING)          AS t  -- 수신 누적 구간 끝
                             , SUM(received) OVER (PARTITION BY PROJECT_CODE,GROUP_ID,TO_SITE ORDER BY ITEM_ID ROWS UNBOUNDED PRECEDING)-received AS f  -- 수신 누적 구간 시작
                          FROM #gt4
                         WHERE received > 0
                       ) rc ON (rc.PROJECT_CODE=dn.PROJECT_CODE AND rc.GROUP_ID=dn.GROUP_ID AND rc.TO_SITE=dn.TO_SITE
                                AND rc.f<dn.t AND rc.t>dn.f);

            UPDATE st 
               SET st.cum_rtf = st.cum_rtf + t.own_rtf + t.donated
                 , st.unmet   = t.need - t.own_rtf - t.received
                 , st.eoh     = t.avail - t.own_rtf - t.donated
              FROM #g_st st INNER JOIN #gt4 t ON (t.PROJECT_CODE=st.PROJECT_CODE AND t.ITEM_ID=st.ITEM_ID AND t.TO_SITE=st.TO_SITE);

            SET @i = @i + 1;
        END

        /*-------------------------------------------------------------
          6. Measure 산출 — 대상 조합 × 전체 기간 (0값 버킷 포함)
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#mcombo') IS NOT NULL DROP TABLE #mcombo;
        SELECT DISTINCT PROJECT_CODE
             , ITEM_ID
             , TO_SITE
          INTO #mcombo
          FROM (SELECT PROJECT_CODE
                     , ITEM_ID
                     , TO_SITE
                  FROM #dmd
                 UNION 
                SELECT PROJECT_CODE
                     , ITEM_ID
                     , TO_SITE
                  FROM #rtf
               ) x;

        IF OBJECT_ID('tempdb..#out') IS NOT NULL DROP TABLE #out;
        WITH cal AS (SELECT CONVERT(DATE,@p_plan_start_yyyymmdd) AS d
                          , 1 AS n                                                                   -- 일자 카운터 (재귀)
                      UNION ALL 
                     SELECT DATEADD(DAY,1,d)
                          , n+1
                       FROM cal WHERE n < @p_horizon_days
                    ),
        spine AS (SELECT c.PROJECT_CODE
                       , c.ITEM_ID
                       , c.TO_SITE
                       , CONVERT(NVARCHAR(8), k.d, 112) AS bkt                                    -- 일자 버킷
                    FROM #mcombo c CROSS JOIN cal k
                 ),
        fx AS (SELECT PROJECT_CODE
                    , ITEM_ID
                    , TO_SITE
                    , due_d
                    , SUM(qty) AS q
                 FROM #dmd
                GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE, due_d
              ),
        rx AS (SELECT PROJECT_CODE
                    , ITEM_ID
                    , TO_SITE
                    , bkt
                    , SUM(qty) AS q
                 FROM #rtf
                GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE, bkt
              ),
        wx AS (SELECT PROJECT_CODE
                    , ITEM_ID
                    , TO_SITE
                    , avail_d
                    , SUM(qty) AS q
                 FROM #sup
                WHERE is_boh=0
                GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE, avail_d
              ),
        bx AS (SELECT PROJECT_CODE
                    , ITEM_ID
                    , TO_SITE
                    , SUM(qty) AS q
                 FROM #sup
                WHERE is_boh=1
                GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE
               )
        SELECT s.PROJECT_CODE
             , s.ITEM_ID
             , s.TO_SITE
             , s.bkt
             , COALESCE(r.q,0) AS rtf                                                   -- RTF
             , SUM(COALESCE(r.q,0)-COALESCE(f.q,0)) OVER (PARTITION BY s.PROJECT_CODE,s.ITEM_ID,s.TO_SITE ORDER BY s.bkt ROWS UNBOUNDED PRECEDING) AS bal                          -- Balance = RTF 누적 - 수요 누적
             , COALESCE(b.q,0)
               + SUM(COALESCE(w.q,0)) OVER (PARTITION BY s.PROJECT_CODE,s.ITEM_ID,s.TO_SITE ORDER BY s.bkt ROWS UNBOUNDED PRECEDING)
               - SUM(COALESCE(r.q,0)) OVER (PARTITION BY s.PROJECT_CODE,s.ITEM_ID,s.TO_SITE
               ORDER BY s.bkt ROWS UNBOUNDED PRECEDING) AS eoh                          -- 기말재고 = 기초재고 + 도착 누적 - RTF 누적
          INTO #out
          FROM spine s
        LEFT OUTER JOIN fx f ON f.PROJECT_CODE=s.PROJECT_CODE AND f.ITEM_ID=s.ITEM_ID AND f.TO_SITE=s.TO_SITE AND f.due_d=s.bkt
        LEFT OUTER JOIN rx r ON r.PROJECT_CODE=s.PROJECT_CODE AND r.ITEM_ID=s.ITEM_ID AND r.TO_SITE=s.TO_SITE AND r.bkt=s.bkt
        LEFT OUTER JOIN wx w ON w.PROJECT_CODE=s.PROJECT_CODE AND w.ITEM_ID=s.ITEM_ID AND w.TO_SITE=s.TO_SITE AND w.avail_d=s.bkt
        LEFT OUTER JOIN bx b ON b.PROJECT_CODE=s.PROJECT_CODE AND b.ITEM_ID=s.ITEM_ID AND b.TO_SITE=s.TO_SITE
        OPTION (MAXRECURSION 2000);

        /* WH_IN : From site 별 생성. 출하계획 도착분은 해당 From site, 재고/운송중 도착분은 '-'. 0값 버킷 포함 */
        IF OBJECT_ID('tempdb..#whin') IS NOT NULL DROP TABLE #whin;
        ;WITH src AS (SELECT PROJECT_CODE
                           , ITEM_ID
                           , TO_SITE
                           , from_site
                           , avail_d
                           , SUM(qty) AS q
                        FROM #sup 
                       WHERE is_boh=0 
                       GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE, from_site, avail_d
                     ),
        fsu AS (SELECT DISTINCT 
                       c.PROJECT_CODE
                     , c.ITEM_ID
                     , c.TO_SITE
                     , s.from_site
                  FROM #mcombo c 
                INNER JOIN src s ON s.PROJECT_CODE=c.PROJECT_CODE AND s.ITEM_ID=c.ITEM_ID AND s.TO_SITE=c.TO_SITE
               ),
        cal AS (SELECT CONVERT(DATE,@p_plan_start_yyyymmdd) AS d
                     , 1 AS n                                                                   -- 일자 카운터 (재귀)
                 UNION ALL 
                SELECT DATEADD(DAY,1,d)
                     , n+1
                  FROM cal WHERE n < @p_horizon_days
               )
        SELECT f.PROJECT_CODE
             , f.ITEM_ID
             , f.TO_SITE
             , f.from_site
             , CONVERT(NVARCHAR(8), k.d, 112) AS bkt
             , COALESCE(s.q,0)                AS qty                                    -- 도착수량 (없으면 0)
          INTO #whin
          FROM fsu f 
        CROSS JOIN cal k
        LEFT OUTER JOIN src s ON s.PROJECT_CODE=f.PROJECT_CODE AND s.ITEM_ID=f.ITEM_ID AND s.TO_SITE=f.TO_SITE
                             AND s.from_site=f.from_site AND s.avail_d=CONVERT(NVARCHAR(8), k.d, 112)
        OPTION (MAXRECURSION 2000);

        /* BIZ_TYPE / INCOTERMS 세팅 (VMI 사이트는 수요 기준, 그 외 출하계획 기준) */
        IF OBJECT_ID('tempdb..#attr') IS NOT NULL DROP TABLE #attr;
        SELECT c.PROJECT_CODE
             , c.ITEM_ID
             , c.TO_SITE
             , COALESCE(NULLIF(a.amend_biz,''), NULLIF(d.mkt_biz,''), '-') AS biz_type  -- BIZ_TYPE (출하계획 -> 수요 순)
             , CASE WHEN v.vmi='Y' THEN COALESCE(NULLIF(d.mkt_inc,''), NULLIF(a.amend_inc,''), '-')
               ELSE COALESCE(NULLIF(a.amend_inc,''), NULLIF(d.mkt_inc,''), '-') END AS incoterms  -- INCOTERMS (VMI 사이트는 수요 기준)
          INTO #attr
          FROM #mcombo c
        LEFT OUTER JOIN (SELECT PROJECT_CODE
                              , ITEM_ID
                              , TO_SITE
                              , MAX(mkt_inc) AS mkt_inc
                              , MAX(mkt_biz) AS mkt_biz
                           FROM #dmd 
                          GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE
                        ) d ON d.PROJECT_CODE=c.PROJECT_CODE AND d.ITEM_ID=c.ITEM_ID AND d.TO_SITE=c.TO_SITE
        LEFT OUTER JOIN (SELECT f.PROJECT_CODE
                              , f.ITEM_ID
                              , f.TO_SITE
                              , MAX(f.INCOTERMS) AS amend_inc
                              , MAX(f.BIZ_TYPE) AS amend_biz
                           FROM SCP_ANL_SHIPMENT_PLAN_FG f WITH (NOLOCK)
                          WHERE f.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
                            AND f.PLAN_TYPE           = @p_plan_type
                            AND f.SEQ                 = @p_seq 
                            AND f.DIVISION_ID         = @p_division_id 
                            AND f.MEASURE             = 'SHIP_PLAN_AMEND'
                          GROUP BY f.PROJECT_CODE, f.ITEM_ID, f.TO_SITE
                        ) a ON a.PROJECT_CODE=c.PROJECT_CODE AND a.ITEM_ID=c.ITEM_ID AND a.TO_SITE=c.TO_SITE
        OUTER APPLY (SELECT MAX(m.VMI_YN) AS vmi FROM SCM_MST_SITE m WITH (NOLOCK)
                      WHERE m.SCM_SITE_ID=c.TO_SITE AND m.VALID_YN='Y'
                    ) v;

        /*-------------------------------------------------------------
          7. 기존 measure 삭제 후 재생성 (락 방지를 위해 분할 삭제)
        -------------------------------------------------------------*/
        BEGIN TRANSACTION;
            SET @n_batch=1;
            WHILE @n_batch>0
            BEGIN
                DELETE TOP (4000) t FROM SCP_ANL_SHIPMENT_PLAN_FG t
                 WHERE t.PLAN_START_YYYYMMDD=@p_plan_start_yyyymmdd AND t.PLAN_TYPE=@p_plan_type
                   AND t.SEQ=@p_seq AND t.DIVISION_ID=@p_division_id
                   AND t.MEASURE IN ('ALLOCATION','BALANCE','WH_IN','WH_IN_BALANCE')
                   AND (@p_project_code IS NULL OR t.PROJECT_CODE=@p_project_code);
                -------------------------------------------------------------------
                SET @n_batch=@@ROWCOUNT; SET @n_deleted=@n_deleted+@n_batch;
            END

            /* ALLOCATION / BALANCE / WH_IN_BALANCE : To site 기준 (From site 구분 없음) */
            INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG
                  ( DIVISION_ID,   PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ,       BIZ_TYPE
                  , PROJECT_CODE,  ITEM_ID,             TO_SITE,   INCOTERMS, FROM_SITE, BOD_ID
                  , MEASURE,       YYYYMMDD,            QTY
                  , CREATED_BY,    CREATION_DATE,       LAST_UPDATED_BY,      LAST_UPDATE_DATE )
            SELECT @p_division_id
                 , @p_plan_start_yyyymmdd
                 , @p_plan_type
                 , @p_seq
                 , t.biz_type
                 , o.PROJECT_CODE
                 , o.ITEM_ID
                 , o.TO_SITE
                 , t.incoterms
                 , '-'
                 , '-'
                 , m.mname
                 , o.bkt
                 , CASE m.mname WHEN 'ALLOCATION' THEN o.rtf
                                WHEN 'BALANCE'    THEN o.bal
                                ELSE CASE WHEN o.bal<0 THEN o.bal ELSE 0 END + o.eoh    -- WH_IN_BALANCE = Balance(음수) + 기말재고
                   END
                 , @p_user_id
                 , SYSDATETIME()
                 , @p_user_id
                 , SYSDATETIME()
              FROM #out o
            INNER JOIN #attr t ON t.PROJECT_CODE=o.PROJECT_CODE AND t.ITEM_ID=o.ITEM_ID AND t.TO_SITE=o.TO_SITE
            CROSS JOIN (SELECT 'ALLOCATION' mname UNION ALL SELECT 'BALANCE' UNION ALL SELECT 'WH_IN_BALANCE') m;

            /* WH_IN (From site별) */
            INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG
                  ( DIVISION_ID,   PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ,       BIZ_TYPE
                  , PROJECT_CODE,  ITEM_ID,             TO_SITE,   INCOTERMS, FROM_SITE, BOD_ID
                  , MEASURE,       YYYYMMDD,            QTY
                  , CREATED_BY,    CREATION_DATE,       LAST_UPDATED_BY,      LAST_UPDATE_DATE )
            SELECT @p_division_id
                 , @p_plan_start_yyyymmdd
                 , @p_plan_type
                 , @p_seq
                 , t.biz_type
                 , w.PROJECT_CODE
                 , w.ITEM_ID
                 , w.TO_SITE
                 , t.incoterms
                 , w.from_site
                 , '-'
                 , 'WH_IN'
                 , w.bkt
                 , w.qty
                 , @p_user_id
                 , SYSDATETIME()
                 , @p_user_id
                 , SYSDATETIME()
              FROM #whin w
            INNER JOIN #attr t ON t.PROJECT_CODE=w.PROJECT_CODE AND t.ITEM_ID=w.ITEM_ID AND t.TO_SITE=w.TO_SITE;

            /* Demand Group 교차 이전 상세 재생성 */
            SET @n_batch=1;
            WHILE @n_batch>0
            BEGIN
                DELETE TOP (4000) t FROM SCP_ANL_RTF_SIM_TRANS t
                 WHERE t.PLAN_START_YYYYMMDD=@p_plan_start_yyyymmdd AND t.PLAN_TYPE=@p_plan_type
                   AND t.SEQ=@p_seq AND t.DIVISION_ID=@p_division_id
                   AND (@p_project_code IS NULL OR t.PROJECT_CODE=@p_project_code);
                SET @n_batch=@@ROWCOUNT; SET @n_del_tr=@n_del_tr+@n_batch;
            END

            INSERT INTO SCP_ANL_RTF_SIM_TRANS
                  ( DIVISION_ID,   PLAN_START_YYYYMMDD, PLAN_TYPE,      SEQ
                  , PROJECT_CODE,  GROUP_ID,            TO_SITE,        YYYYMMDD
                  , SUPPLY_ITEM_ID, DEMAND_ITEM_ID,     QTY
                  , CREATED_BY,    CREATION_DATE,       LAST_UPDATED_BY, LAST_UPDATE_DATE )
            SELECT @p_division_id
                 , @p_plan_start_yyyymmdd
                 , @p_plan_type
                 , @p_seq
                 , g.PROJECT_CODE
                 , g.GROUP_ID
                 , g.TO_SITE
                 , g.YYYYMMDD
                 , g.SUPPLY_ITEM_ID
                 , g.DEMAND_ITEM_ID
                 , SUM(g.qty)                                                           -- 이전수량
                 , @p_user_id
                 , SYSDATETIME()
                 , @p_user_id
                 , SYSDATETIME()
              FROM #g_tr g
             WHERE g.qty > 0
             GROUP BY g.PROJECT_CODE, g.GROUP_ID, g.TO_SITE, g.YYYYMMDD, g.SUPPLY_ITEM_ID, g.DEMAND_ITEM_ID;
        COMMIT TRANSACTION;

        /*-------------------------------------------------------------
          8. SHIP_REQ 재생성 (옵션)
        -------------------------------------------------------------*/
        IF @p_gen_ship_req = 'Y'
            EXEC PR_SCP_ANL_SHIP_REQ_GEN
                 @p_division_id=@p_division_id, @p_plan_start_yyyymmdd=@p_plan_start_yyyymmdd
               , @p_plan_type=@p_plan_type, @p_seq=@p_seq, @p_inv_plan_id=@p_inv_plan_id
               , @p_project_code=@p_project_code, @p_user_id=@p_user_id;

        /*-------------------------------------------------------------
          9. 결과 검증
        -------------------------------------------------------------*/
        SELECT 'V1_rtf_le_demand_per_scope' AS chk_name,   -- RTF 합계는 수요 합계를 넘을 수 없음
               CASE WHEN (SELECT COALESCE(SUM(qty),0) FROM #rtf)
                       <= (SELECT COALESCE(SUM(qty),0) FROM #dmd) + 0.01 THEN 'PASS' ELSE 'FAIL' END AS result
        UNION ALL
        SELECT 'V2_rtf_le_supply',
               CASE WHEN (SELECT COALESCE(SUM(qty),0) FROM #rtf)
                       <= (SELECT COALESCE(SUM(qty),0) FROM #sup) + 0.01 THEN 'PASS' ELSE 'FAIL' END
        UNION ALL
        SELECT 'V3_no_negative_rtf',
               CASE WHEN NOT EXISTS (SELECT 1 FROM #rtf WHERE qty<0) THEN 'PASS' ELSE 'FAIL' END
        UNION ALL
        SELECT 'V4_group_cap',   -- Demand Group 단위로도 RTF 합계가 수요 합계를 넘을 수 없음
               CASE WHEN NOT EXISTS (
                    SELECT 1
                    FROM (SELECT g.PROJECT_CODE
                         , g.GROUP_ID
                         , r.TO_SITE
                         , SUM(r.qty) AS rq
                    FROM #rtf r INNER JOIN #grp g ON g.PROJECT_CODE=r.PROJECT_CODE AND g.ITEM_ID=r.ITEM_ID
                          GROUP BY g.PROJECT_CODE, g.GROUP_ID, r.TO_SITE) a
                    INNER JOIN (SELECT g.PROJECT_CODE
                         , g.GROUP_ID
                         , d.TO_SITE
                         , SUM(d.qty) AS dq
                    FROM #dmd d INNER JOIN #grp g ON g.PROJECT_CODE=d.PROJECT_CODE AND g.ITEM_ID=d.ITEM_ID
                          GROUP BY g.PROJECT_CODE, g.GROUP_ID, d.TO_SITE) b
                      ON a.PROJECT_CODE=b.PROJECT_CODE AND a.GROUP_ID=b.GROUP_ID AND a.TO_SITE=b.TO_SITE
                    WHERE a.rq > b.dq + 0.01)
                    THEN 'PASS' ELSE 'FAIL' END
        UNION ALL
        SELECT 'V5_written', CONCAT('deleted=',@n_deleted,
               ' / measure3=',(SELECT COUNT(*)*3 FROM #out),
               ' / whin=',(SELECT COUNT(*) FROM #whin))
        UNION ALL
        SELECT 'V6_trans',   -- 교차 이전 상세 (건수/수량. 제공 합계와 일치해야 함)
               CONCAT('deleted=',@n_del_tr,
               ' / rows=',(SELECT COUNT(*) FROM #g_tr WHERE qty>0),
               ' / qty=',(SELECT COALESCE(SUM(qty),0) FROM #g_tr WHERE qty>0));

        SET @v_log_type    = 'END';
        SET @v_log_message = CONCAT('deleted=',@n_deleted,', combos=',(SELECT COUNT(*) FROM #mcombo));
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type,     @n_log_count,
                              @v_log_message,  @v_description,  @d_event_date;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
        SET @v_log_type    = 'ERROR';
        SET @v_log_message = CONCAT('ERROR ',ERROR_NUMBER(),' line ',ERROR_LINE(),': ',ERROR_MESSAGE());
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type,     @n_log_count,
                              @v_log_message,  @v_description,  @d_event_date;
        THROW;
    END CATCH
END
