/*
 * Program ID   : PR_SCP_ANL_RTF_PEGGING_DTL
 * Description  : RTF 시뮬레이션 pegging 상세 생성 (선택 실행)
 *                저장된 ALLOCATION(공급 모델 귀속)을 원천 수요(DM_PLN_NET_DEMAND, 지정 버전) 건 단위로
 *                분해하여 SCP_ANL_RTF_SIM_PEGGING에 저장
 *                  - Demand Group 교차 대응분은 SCP_ANL_RTF_SIM_TRANS 기준으로 수요 Item에 귀속시키고
 *                    실제 출하 Item을 FROM_ITEM_ID로 기록 (수요 Item과 다를 수 있음)
 *                  - FROM_SITE_ID = 공급원 사이트 (출하계획 FROM_SITE, 재고/운송중 공급분은 '-')
 *                    공급원 분해는 공급 소진 순서(가용일, 재고 우선) 누적 대비로 산출
 *                  - 수요 매칭은 충족 내역(충족일 순)을 원천 수요(납기, 우선순위 순)에 선입선출로 차감 대응.
 *                    수요 초과 충족분은 MATCH_STATUS='RESIDUAL' 행으로 명시
 *                    (원천 수요 버전과 MKT_FCST 스냅샷의 차이를 그대로 드러냄)
 *                  - 수요수량(원수량)/미충족수량은 수요 건의 모든 분할 행에 반복 기록,
 *                    REMAIN_DEMAND_QTY = 해당 행 차감 전 잔여 수요 (pegging 순 차감 경과)
 *                상세 규칙은 RTF 요구사항 정의 문서 참조
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.09.22   JCH            Initial Release
 * 2026.09.29   JCH            Demand Group 교차 대응 반영 (FROM_ITEM_ID/FROM_SITE_ID 분해,
 *                             충족 발생일 기준 순차 대응으로 개정, @p_inv_plan_id 추가)
 * 2026.09.29   JCH            수요 버전 미지정(NULL) 시 최신 CUTOFF 버전 자동 선택
 * 2026.09.30   JCH            REMAIN_DEMAND_QTY 추가 (수요 원수량 반복 + 차감 경과 표시)
 */
CREATE PROCEDURE dbo.PR_SCP_ANL_RTF_PEGGING_DTL
(
  @p_division_id          NVARCHAR(30)
, @p_plan_start_yyyymmdd  NVARCHAR(8)
, @p_plan_type            NVARCHAR(50)
, @p_seq                  BIGINT
, @p_demand_version_no    NVARCHAR(100) = NULL   -- 원천 수요 버전 (NULL이면 최신 CUTOFF 버전 자동 선택)
, @p_inv_plan_id          NVARCHAR(100)          -- 재고/운송중 PLAN_ID (공급원 분해 기준)
, @p_project_code         NVARCHAR(50)  = NULL
, @p_user_id              NVARCHAR(150) = 'rtf_sim'
)
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

    DECLARE @v_program_name NVARCHAR(150)  = 'PR_SCP_ANL_RTF_PEGGING_DTL';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INT            = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_deleted      BIGINT         = 0;
    DECLARE @n_batch        INT;

    /* 수요 버전 미지정 시 최신 CUTOFF 버전 자동 선택 (동일 CUTOFF 복수 버전은 최근 적재분 우선) */
    IF @p_demand_version_no IS NULL
        SELECT TOP (1) @p_demand_version_no = VERSION_NO
          FROM DM_PLN_NET_DEMAND WITH (NOLOCK)
         WHERE DIVISION_ID = @p_division_id
         GROUP BY VERSION_NO
         ORDER BY MAX(CUTOFF_YYYYMMDD) DESC, MAX(CREATION_DATE) DESC, VERSION_NO DESC;

    SET @v_log_type    = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = CONCAT('[',@p_division_id,'/',@p_plan_start_yyyymmdd,'/',@p_plan_type,'/',@p_seq,
                                '/dmd=',@p_demand_version_no,'/proj=',COALESCE(@p_project_code,'ALL'),']');
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
        /*-------------------------------------------------------------
          1. 저장 ALLOCATION (분해 대상. 공급 모델 귀속)
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#pg_alloc') IS NOT NULL DROP TABLE #pg_alloc;
        SELECT PROJECT_CODE
             , ITEM_ID
             , TO_SITE
             , YYYYMMDD AS bkt                                                          -- 충족 발생일 버킷
             , SUM(QTY) AS alloc_qty
          INTO #pg_alloc
          FROM SCP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)
         WHERE PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
           AND PLAN_TYPE           = @p_plan_type
           AND SEQ                 = @p_seq
           AND DIVISION_ID         = @p_division_id
           AND MEASURE             = 'ALLOCATION'
           AND QTY                 > 0
           AND (@p_project_code IS NULL OR PROJECT_CODE = @p_project_code)
         GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE, YYYYMMDD;

        /*-------------------------------------------------------------
          2. Demand Group 교차 이전 상세 (시뮬레이션 기록분)
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#pg_tr') IS NOT NULL DROP TABLE #pg_tr;
        SELECT PROJECT_CODE
             , TO_SITE
             , YYYYMMDD AS bkt
             , SUPPLY_ITEM_ID
             , DEMAND_ITEM_ID
             , SUM(QTY) AS qty
          INTO #pg_tr
          FROM SCP_ANL_RTF_SIM_TRANS WITH (NOLOCK)
         WHERE PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
           AND PLAN_TYPE           = @p_plan_type
           AND SEQ                 = @p_seq
           AND DIVISION_ID         = @p_division_id
           AND (@p_project_code IS NULL OR PROJECT_CODE = @p_project_code)
         GROUP BY PROJECT_CODE, TO_SITE, YYYYMMDD, SUPPLY_ITEM_ID, DEMAND_ITEM_ID;

        /*-------------------------------------------------------------
          3. 원천 수요 (버전 지정. 납기·우선순위 순 구간화 준비)
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#pg_src') IS NOT NULL DROP TABLE #pg_src;
        SELECT d.PROJECT_CODE
             , d.ITEM_ID
             , d.SCM_SITE_ID AS TO_SITE
             , d.YYYYMMDD    AS due_d                                                   -- 납기일자
             , d.DEMAND_PRIORITY
             , d.DEMAND_TYPE
             , d.FCST_TYPE
             , d.INCOTERMS
             , COALESCE(TRY_CONVERT(BIGINT, d.DEMAND_PRIORITY), 999999999) AS pri_num   -- 우선순위 숫자화 (비숫자는 최후순위)
             , SUM(d.QTY) AS qty
          INTO #pg_src
          FROM DM_PLN_NET_DEMAND d WITH (NOLOCK)
         WHERE d.VERSION_NO  = @p_demand_version_no
           AND d.DIVISION_ID = @p_division_id
           AND d.QTY         > 0
           AND (@p_project_code IS NULL OR d.PROJECT_CODE = @p_project_code)
         GROUP BY d.PROJECT_CODE, d.ITEM_ID, d.SCM_SITE_ID, d.YYYYMMDD,
                  d.DEMAND_PRIORITY, d.DEMAND_TYPE, d.FCST_TYPE, d.INCOTERMS;

        /*-------------------------------------------------------------
          4. 충족 내역 구성 (수요 Item 관점, 실제 출하 Item 구분)
             자기 충족분 = 저장 ALLOCATION - 타 모델 제공분 / 수신분 = 이전 상세
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#pg_ful') IS NOT NULL DROP TABLE #pg_ful;
        SELECT u.PROJECT_CODE
             , u.ITEM_ID                                                                -- 수요 Item
             , u.TO_SITE
             , u.bkt
             , u.from_item                                                              -- 실제 출하 Item
             , u.qty
          INTO #pg_ful
          FROM (
                SELECT a.PROJECT_CODE
                     , a.ITEM_ID
                     , a.TO_SITE
                     , a.bkt
                     , a.ITEM_ID AS from_item
                     , a.alloc_qty - COALESCE(o.out_qty,0) AS qty                       -- 자기 수요 충족분
                  FROM #pg_alloc a
                  LEFT OUTER JOIN (SELECT PROJECT_CODE, TO_SITE, bkt, SUPPLY_ITEM_ID
                                        , SUM(qty) AS out_qty                           -- 타 모델 제공분 합계
                                     FROM #pg_tr
                                    GROUP BY PROJECT_CODE, TO_SITE, bkt, SUPPLY_ITEM_ID
                                  ) o ON (o.PROJECT_CODE=a.PROJECT_CODE AND o.TO_SITE=a.TO_SITE
                                          AND o.bkt=a.bkt AND o.SUPPLY_ITEM_ID=a.ITEM_ID)
                 UNION ALL
                SELECT t.PROJECT_CODE
                     , t.DEMAND_ITEM_ID                                                 -- 수신 모델의 수요로 귀속
                     , t.TO_SITE
                     , t.bkt
                     , t.SUPPLY_ITEM_ID
                     , t.qty
                  FROM #pg_tr t
               ) u
         WHERE u.qty > 0.000001;

        /*-------------------------------------------------------------
          5. 공급원(FROM_SITE) 분해
             출하 Item별 소진 수량(=저장 ALLOCATION, 버킷 순)을 공급 내역
             (재고/운송중 '-' 우선, 출하계획 FROM_SITE, 가용일 순)과 누적 대비
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#pg_sup') IS NOT NULL DROP TABLE #pg_sup;
        SELECT s.PROJECT_CODE
             , s.ITEM_ID
             , s.TO_SITE
             , s.avail_d
             , s.src_prio
             , s.from_site
             , SUM(s.qty) AS qty
          INTO #pg_sup
          FROM (
                SELECT COALESCE(NULLIF(i.PROJECT_CODE,''),
                       NULLIF(dbo.fn_scm_split(dbo.fn_scm_split(i.ORDER_ID,4,'::'),3,'@'),''),  -- 프로젝트 미지정 시 ORDER_ID에서 추출
                       '-') AS PROJECT_CODE
                     , i.ITEM_ID
                     , i.SCM_SITE_ID AS TO_SITE
                     , CASE WHEN i.EFFECTIVE_DATE <= @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd
                       ELSE i.EFFECTIVE_DATE END AS avail_d                             -- 가용일 (계획시작일 이전 재고는 계획시작일로)
                     , 1 AS src_prio                                                    -- 공급 우선순위 1:재고
                     , '-' AS from_site
                     , i.QTY AS qty
                  FROM SCP_EGN_OTPT_INV_M i WITH (NOLOCK)
                INNER JOIN (SELECT DISTINCT SCM_SITE_ID FROM SCM_MST_SITE WITH (NOLOCK)
                            WHERE SITE_TYPE='SALES' AND VALID_YN='Y') m ON i.SCM_SITE_ID=m.SCM_SITE_ID
                 WHERE i.PLAN_ID=@p_inv_plan_id AND i.INVENTORY_TYPE IN ('WH','INT')
                 UNION ALL
                SELECT f.PROJECT_CODE
                     , f.ITEM_ID
                     , f.TO_SITE
                     , CONVERT(NVARCHAR(8), DATEADD(DAY, COALESCE(b.lt,0), CONVERT(DATE,f.YYYYMMDD)),112)  -- 도착일 (출하일 + 운송 L/T)
                     , 2                                                                -- 공급 우선순위 2:출하계획
                     , f.FROM_SITE
                     , f.QTY
                  FROM SCP_ANL_SHIPMENT_PLAN_FG f WITH (NOLOCK)
                  LEFT OUTER JOIN (SELECT division_id
                                        , bod_id
                                        , MAX(add_after_lt_total) AS lt
                                     FROM scp_mst_bod_n_v WITH (NOLOCK)
                                    WHERE bod_valid_yn='Y'
                                    GROUP BY division_id, bod_id
                                  ) b ON (b.division_id=f.DIVISION_ID AND b.bod_id=f.BOD_ID)
                 WHERE f.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                   AND f.PLAN_TYPE           = @p_plan_type
                   AND f.SEQ                 = @p_seq
                   AND f.DIVISION_ID         = @p_division_id
                   AND f.MEASURE             = 'SHIP_PLAN_AMEND'
                   AND f.QTY                 > 0
               ) s
        INNER JOIN (SELECT DISTINCT PROJECT_CODE, from_item, TO_SITE FROM #pg_ful) u
            ON (u.PROJECT_CODE=s.PROJECT_CODE AND u.from_item=s.ITEM_ID AND u.TO_SITE=s.TO_SITE)
         GROUP BY s.PROJECT_CODE, s.ITEM_ID, s.TO_SITE, s.avail_d, s.src_prio, s.from_site;

        /* 소진 내역(버킷 순)과 공급 내역(가용일·우선순위 순)을 선입선출로 대응 → 버킷별 공급원 구성 */
        IF OBJECT_ID('tempdb..#pg_csrc') IS NOT NULL DROP TABLE #pg_csrc;
        WITH cc AS (SELECT PROJECT_CODE, ITEM_ID, TO_SITE, bkt, alloc_qty
                         , SUM(alloc_qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE ORDER BY bkt ROWS UNBOUNDED PRECEDING)           AS t  -- 소진 누적 구간 끝
                         , SUM(alloc_qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE ORDER BY bkt ROWS UNBOUNDED PRECEDING)-alloc_qty AS f  -- 소진 누적 구간 시작
                      FROM #pg_alloc),
        sc AS (SELECT PROJECT_CODE, ITEM_ID, TO_SITE, from_site
                    , SUM(qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE ORDER BY avail_d, src_prio, from_site ROWS UNBOUNDED PRECEDING)     AS t  -- 공급 누적 구간 끝
                    , SUM(qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE ORDER BY avail_d, src_prio, from_site ROWS UNBOUNDED PRECEDING)-qty AS f  -- 공급 누적 구간 시작
                 FROM #pg_sup)
        SELECT x.PROJECT_CODE
             , x.ITEM_ID                                                                -- 출하 Item
             , x.TO_SITE
             , x.bkt
             , x.from_site
             , x.qty
             , x.s_pos                                                                  -- 버킷 내 공급원 순서 (공급 소진 위치)
          INTO #pg_csrc
          FROM (
                SELECT c.PROJECT_CODE, c.ITEM_ID, c.TO_SITE, c.bkt, s.from_site, s.f AS s_pos
                     , CASE WHEN c.t<s.t THEN c.t ELSE s.t END - CASE WHEN c.f>s.f THEN c.f ELSE s.f END AS qty  -- 공급원별 소진수량 (누적구간 겹침)
                  FROM cc c
                INNER JOIN sc s ON (s.PROJECT_CODE=c.PROJECT_CODE AND s.ITEM_ID=c.ITEM_ID AND s.TO_SITE=c.TO_SITE
                                    AND s.f<c.t AND s.t>c.f)
                 UNION ALL
                SELECT c.PROJECT_CODE, c.ITEM_ID, c.TO_SITE, c.bkt, '-', 999999999999
                     , c.t - CASE WHEN st.tot IS NULL OR st.tot < c.f THEN c.f ELSE st.tot END          -- 공급량을 초과한 소진분 (예외 보정)
                  FROM cc c
                  LEFT OUTER JOIN (SELECT PROJECT_CODE, ITEM_ID, TO_SITE, SUM(qty) AS tot
                                     FROM #pg_sup GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE
                                  ) st ON (st.PROJECT_CODE=c.PROJECT_CODE AND st.ITEM_ID=c.ITEM_ID AND st.TO_SITE=c.TO_SITE)
                 WHERE c.t > COALESCE(st.tot, 0)
               ) x
         WHERE x.qty > 0.000001;

        /*-------------------------------------------------------------
          6. 충족 내역과 공급원 결합 — (출하 Item, 버킷) 안에서
             수요처 구성(자기 수요 대응분 우선, 수요 Item 순)과 공급원 구성을 순서 대응
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#pg_ful2') IS NOT NULL DROP TABLE #pg_ful2;
        WITH fc AS (SELECT PROJECT_CODE, ITEM_ID, TO_SITE, bkt, from_item, qty
                         , CASE WHEN ITEM_ID = from_item THEN 0 ELSE 1 END AS own0     -- 자기 수요 대응분 우선
                         , SUM(qty) OVER (PARTITION BY PROJECT_CODE,from_item,TO_SITE,bkt
                                          ORDER BY CASE WHEN ITEM_ID=from_item THEN 0 ELSE 1 END, ITEM_ID ROWS UNBOUNDED PRECEDING)     AS t
                         , SUM(qty) OVER (PARTITION BY PROJECT_CODE,from_item,TO_SITE,bkt
                                          ORDER BY CASE WHEN ITEM_ID=from_item THEN 0 ELSE 1 END, ITEM_ID ROWS UNBOUNDED PRECEDING)-qty AS f
                      FROM #pg_ful),
        kc AS (SELECT PROJECT_CODE, ITEM_ID, TO_SITE, bkt, from_site, s_pos
                    , SUM(qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE,bkt ORDER BY s_pos, from_site ROWS UNBOUNDED PRECEDING)     AS t
                    , SUM(qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE,bkt ORDER BY s_pos, from_site ROWS UNBOUNDED PRECEDING)-qty AS f
                 FROM #pg_csrc)
        SELECT f.PROJECT_CODE
             , f.ITEM_ID                                                                -- 수요 Item
             , f.TO_SITE
             , f.bkt
             , f.from_item
             , k.from_site
             , f.own0
             , k.s_pos
             , CASE WHEN f.t<k.t THEN f.t ELSE k.t END - CASE WHEN f.f>k.f THEN f.f ELSE k.f END AS qty  -- 수요처×공급원 교차수량 (누적구간 겹침)
          INTO #pg_ful2
          FROM fc f
        INNER JOIN kc k ON (k.PROJECT_CODE=f.PROJECT_CODE AND k.ITEM_ID=f.from_item AND k.TO_SITE=f.TO_SITE
                            AND k.bkt=f.bkt AND k.f<f.t AND k.t>f.f)
         WHERE CASE WHEN f.t<k.t THEN f.t ELSE k.t END - CASE WHEN f.f>k.f THEN f.f ELSE k.f END > 0.000001;

        /*-------------------------------------------------------------
          7. 원천 수요 매칭 — 충족 내역(버킷 순)을 수요(납기·우선순위 순)에 선입선출로 대응
        -------------------------------------------------------------*/
        IF OBJECT_ID('tempdb..#pg_dcum') IS NOT NULL DROP TABLE #pg_dcum;
        SELECT PROJECT_CODE, ITEM_ID, TO_SITE, due_d, DEMAND_PRIORITY, DEMAND_TYPE, FCST_TYPE, INCOTERMS, pri_num, qty
             , ROW_NUMBER() OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE
                                  ORDER BY due_d, pri_num, qty DESC, DEMAND_PRIORITY)          AS dseq   -- 수요 건 순번 (납기, 우선순위 순)
             , SUM(qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE
                              ORDER BY due_d, pri_num, qty DESC, DEMAND_PRIORITY ROWS UNBOUNDED PRECEDING)     AS t
             , SUM(qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE
                              ORDER BY due_d, pri_num, qty DESC, DEMAND_PRIORITY ROWS UNBOUNDED PRECEDING)-qty AS f
          INTO #pg_dcum
          FROM #pg_src;

        IF OBJECT_ID('tempdb..#pg_fcum') IS NOT NULL DROP TABLE #pg_fcum;
        SELECT PROJECT_CODE, ITEM_ID, TO_SITE, bkt, from_item, from_site, qty
             , SUM(qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE
                              ORDER BY bkt, own0, from_item, s_pos, from_site ROWS UNBOUNDED PRECEDING)     AS t
             , SUM(qty) OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE
                              ORDER BY bkt, own0, from_item, s_pos, from_site ROWS UNBOUNDED PRECEDING)-qty AS f
          INTO #pg_fcum
          FROM #pg_ful2;

        /* 수요 건 × 충족 조각 매칭 + 미충족/잔여 산출 */
        IF OBJECT_ID('tempdb..#pg_dtl') IS NOT NULL DROP TABLE #pg_dtl;
        SELECT * INTO #pg_dtl FROM (
            /* MATCHED : 수요 건별 충족 조각 (충족 없는 수요 건도 1행 생성) */
            SELECT d.PROJECT_CODE
                 , d.ITEM_ID
                 , d.TO_SITE
                 , d.due_d AS due_yyyymmdd
                 , d.dseq
                 , CONCAT(d.TO_SITE,'::',d.ITEM_ID,'::','-@',COALESCE(d.INCOTERMS,'-'),'@',d.PROJECT_CODE,
                          '::',d.due_d,'::-::',COALESCE(d.FCST_TYPE,'-')) AS demand_id  -- 수요 식별자 재구성
                 , d.DEMAND_PRIORITY
                 , d.DEMAND_TYPE
                 , d.FCST_TYPE
                 , d.INCOTERMS
                 , COALESCE(m.from_item, '-') AS from_item                              -- 실제 출하 Item ('-'=충족 없음)
                 , COALESCE(m.from_site, '-') AS from_site
                 , d.qty AS demand_qty                                                  -- 수요 건 원수량 (분할 행에 반복)
                 , d.qty - COALESCE(m.cum_prior, 0) AS remain_demand_qty                -- 잔여 수요 (해당 행 차감 전)
                 , COALESCE(m.rtf_qty, 0) AS rtf_qty
                 , d.qty - COALESCE(mt.rtf_sum, 0) AS unfulfilled_qty                   -- 최종 미충족수량 (분할 행에 반복)
                 , CAST('MATCHED' AS NVARCHAR(10)) AS match_status
                 , COALESCE(m.rn, 1) AS split_rn
              FROM #pg_dcum d
              LEFT OUTER JOIN (SELECT d2.PROJECT_CODE, d2.ITEM_ID, d2.TO_SITE, d2.dseq
                                    , f.from_item, f.from_site, f.bkt
                                    , CASE WHEN d2.t<f.t THEN d2.t ELSE f.t END
                                    - CASE WHEN d2.f>f.f THEN d2.f ELSE f.f END AS rtf_qty            -- 충족수량 (누적구간 겹침)
                                    , ROW_NUMBER() OVER (PARTITION BY d2.PROJECT_CODE,d2.ITEM_ID,d2.TO_SITE,d2.dseq
                                                         ORDER BY f.bkt, f.from_item, f.from_site) AS rn
                                    , SUM(CASE WHEN d2.t<f.t THEN d2.t ELSE f.t END
                                        - CASE WHEN d2.f>f.f THEN d2.f ELSE f.f END)
                                      OVER (PARTITION BY d2.PROJECT_CODE,d2.ITEM_ID,d2.TO_SITE,d2.dseq
                                            ORDER BY f.bkt, f.from_item, f.from_site ROWS UNBOUNDED PRECEDING)
                                    - (CASE WHEN d2.t<f.t THEN d2.t ELSE f.t END
                                        - CASE WHEN d2.f>f.f THEN d2.f ELSE f.f END) AS cum_prior     -- 선행 분할 충족 누적 (잔여 수요 산출용)
                                 FROM #pg_dcum d2
                               INNER JOIN #pg_fcum f ON (f.PROJECT_CODE=d2.PROJECT_CODE AND f.ITEM_ID=d2.ITEM_ID
                                                         AND f.TO_SITE=d2.TO_SITE AND f.f<d2.t AND f.t>d2.f)
                              ) m ON (m.PROJECT_CODE=d.PROJECT_CODE AND m.ITEM_ID=d.ITEM_ID
                                      AND m.TO_SITE=d.TO_SITE AND m.dseq=d.dseq)
              LEFT OUTER JOIN (SELECT d3.PROJECT_CODE, d3.ITEM_ID, d3.TO_SITE, d3.dseq
                                    , SUM(CASE WHEN d3.t<f.t THEN d3.t ELSE f.t END
                                        - CASE WHEN d3.f>f.f THEN d3.f ELSE f.f END) AS rtf_sum       -- 수요 건 충족 합계
                                 FROM #pg_dcum d3
                               INNER JOIN #pg_fcum f ON (f.PROJECT_CODE=d3.PROJECT_CODE AND f.ITEM_ID=d3.ITEM_ID
                                                         AND f.TO_SITE=d3.TO_SITE AND f.f<d3.t AND f.t>d3.f)
                                GROUP BY d3.PROJECT_CODE, d3.ITEM_ID, d3.TO_SITE, d3.dseq
                              ) mt ON (mt.PROJECT_CODE=d.PROJECT_CODE AND mt.ITEM_ID=d.ITEM_ID
                                       AND mt.TO_SITE=d.TO_SITE AND mt.dseq=d.dseq)
             UNION ALL
            /* RESIDUAL : 원천 수요 합계를 초과한 충족분 (수요 버전 차이 명시) */
            SELECT f.PROJECT_CODE
                 , f.ITEM_ID
                 , f.TO_SITE
                 , f.bkt
                 , 0
                 , 'RESIDUAL'
                 , NULL, NULL, NULL, NULL
                 , f.from_item
                 , f.from_site
                 , 0
                 , 0                                                                    -- 잔여 수요 (대응 수요 없음)
                 , f.t - CASE WHEN COALESCE(dt.tot,0) > f.f THEN dt.tot ELSE f.f END    -- 초과 충족수량
                 , 0 - (f.t - CASE WHEN COALESCE(dt.tot,0) > f.f THEN dt.tot ELSE f.f END)
                 , 'RESIDUAL'
                 , 0
              FROM #pg_fcum f
              LEFT OUTER JOIN (SELECT PROJECT_CODE, ITEM_ID, TO_SITE, SUM(qty) AS tot
                                 FROM #pg_src GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE
                              ) dt ON (dt.PROJECT_CODE=f.PROJECT_CODE AND dt.ITEM_ID=f.ITEM_ID AND dt.TO_SITE=f.TO_SITE)
             WHERE f.t > COALESCE(dt.tot, 0) + 0.000001
        ) u;

        /*-------------------------------------------------------------
          8. 반영: 범위 삭제(분할) 후 저장
        -------------------------------------------------------------*/
        BEGIN TRANSACTION;
            SET @n_batch = 1;
            WHILE @n_batch > 0
            BEGIN
                DELETE TOP (4000) t FROM SCP_ANL_RTF_SIM_PEGGING t
                 WHERE t.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                   AND t.PLAN_TYPE           = @p_plan_type
                   AND t.SEQ                 = @p_seq
                   AND t.DIVISION_ID         = @p_division_id
                   AND (@p_project_code IS NULL OR t.PROJECT_CODE = @p_project_code);
                SET @n_batch = @@ROWCOUNT; SET @n_deleted = @n_deleted + @n_batch;
            END

            INSERT INTO SCP_ANL_RTF_SIM_PEGGING
                  ( DIVISION_ID,     PLAN_START_YYYYMMDD, PLAN_TYPE,       SEQ
                  , PROJECT_CODE,    ITEM_ID,             TO_SITE,         DUE_YYYYMMDD,  PEGGING_SEQ
                  , DEMAND_ID,       DEMAND_PRIORITY,     DEMAND_TYPE,     FCST_TYPE,     INCOTERMS
                  , DEMAND_VERSION_NO, FROM_ITEM_ID,      FROM_SITE_ID
                  , DEMAND_QTY,      REMAIN_DEMAND_QTY,   RTF_QTY,         UNFULFILLED_QTY, MATCH_STATUS
                  , CREATED_BY,      CREATION_DATE,       LAST_UPDATED_BY, LAST_UPDATE_DATE )
            SELECT @p_division_id
                 , @p_plan_start_yyyymmdd
                 , @p_plan_type
                 , @p_seq
                 , PROJECT_CODE
                 , ITEM_ID
                 , TO_SITE
                 , due_yyyymmdd
                 , CASE WHEN match_status='RESIDUAL' THEN 9000 ELSE 0 END
                 + ROW_NUMBER() OVER (PARTITION BY PROJECT_CODE, ITEM_ID, TO_SITE, due_yyyymmdd, match_status
                                      ORDER BY dseq, split_rn, from_item, from_site)    -- 납기 버킷 내 순번 (RESIDUAL은 9000번대)
                 , demand_id
                 , DEMAND_PRIORITY
                 , DEMAND_TYPE
                 , FCST_TYPE
                 , INCOTERMS
                 , @p_demand_version_no
                 , from_item
                 , from_site
                 , demand_qty
                 , remain_demand_qty
                 , rtf_qty
                 , unfulfilled_qty
                 , match_status
                 , @p_user_id
                 , SYSDATETIME()
                 , @p_user_id
                 , SYSDATETIME()
              FROM #pg_dtl;
        COMMIT TRANSACTION;

        /*-------------------------------------------------------------
          9. 결과 검증
        -------------------------------------------------------------*/
        SELECT 'P1_decompose_conservation' AS chk_name,   -- Σ상세 RTF = Σ저장 ALLOCATION
               CASE WHEN ABS((SELECT COALESCE(SUM(rtf_qty),0) FROM #pg_dtl)
                          - (SELECT COALESCE(SUM(alloc_qty),0) FROM #pg_alloc)) < 0.01
                    THEN 'PASS' ELSE 'FAIL' END AS result
         UNION ALL
        SELECT 'P2_from_item_conservation',               -- 출하 Item별 Σ상세 RTF = 해당 Item 저장 ALLOCATION
               CASE WHEN NOT EXISTS (
                    SELECT 1
                      FROM (SELECT PROJECT_CODE, from_item, TO_SITE, SUM(rtf_qty) AS q
                              FROM #pg_dtl WHERE from_item <> '-'
                             GROUP BY PROJECT_CODE, from_item, TO_SITE) p
                      FULL OUTER JOIN (SELECT PROJECT_CODE, ITEM_ID, TO_SITE, SUM(alloc_qty) AS q
                              FROM #pg_alloc GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE) a
                        ON (a.PROJECT_CODE=p.PROJECT_CODE AND a.ITEM_ID=p.from_item AND a.TO_SITE=p.TO_SITE)
                     WHERE ABS(COALESCE(p.q,0) - COALESCE(a.q,0)) > 0.01)
                    THEN 'PASS' ELSE 'FAIL' END
         UNION ALL
        SELECT 'P3_no_negative_rtf',
               CASE WHEN NOT EXISTS (SELECT 1 FROM #pg_dtl WHERE rtf_qty < -0.000001) THEN 'PASS' ELSE 'FAIL' END
         UNION ALL
        SELECT 'P4_demand_conservation',                  -- Σ수요수량(분할 첫 행 기준) = Σ원천 수요
               CASE WHEN ABS((SELECT COALESCE(SUM(demand_qty),0) FROM #pg_dtl WHERE match_status='MATCHED' AND split_rn=1)
                          - (SELECT COALESCE(SUM(qty),0) FROM #pg_src)) < 0.01
                    THEN 'PASS' ELSE 'FAIL' END
         UNION ALL
        SELECT 'P8_remain_ge_rtf',                        -- 잔여 수요 >= 해당 행 충족수량
               CASE WHEN NOT EXISTS (SELECT 1 FROM #pg_dtl
                    WHERE match_status='MATCHED' AND rtf_qty > remain_demand_qty + 0.01)
                    THEN 'PASS' ELSE 'FAIL' END
         UNION ALL
        SELECT 'P5_cross_item', CONCAT('rows=', (SELECT COUNT(*) FROM #pg_dtl WHERE from_item<>'-' AND from_item<>ITEM_ID),
                                       ' / qty=', (SELECT COALESCE(SUM(rtf_qty),0) FROM #pg_dtl WHERE from_item<>'-' AND from_item<>ITEM_ID))
         UNION ALL
        SELECT 'P6_residual', CONCAT('rows=', (SELECT COUNT(*) FROM #pg_dtl WHERE match_status='RESIDUAL'),
                                     ' / qty=', (SELECT COALESCE(SUM(rtf_qty),0) FROM #pg_dtl WHERE match_status='RESIDUAL'))
         UNION ALL
        SELECT 'P7_written_rows', CONCAT('deleted=', @n_deleted, ' / inserted=', (SELECT COUNT(*) FROM #pg_dtl));

        SET @v_log_type    = 'END';
        SET @v_log_message = CONCAT('deleted=',@n_deleted,', inserted=',(SELECT COUNT(*) FROM #pg_dtl));
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @v_log_type    = 'ERROR';
        SET @v_log_message = CONCAT('ERROR ',ERROR_NUMBER(),' line ',ERROR_LINE(),': ',ERROR_MESSAGE());
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        THROW;
    END CATCH
END
