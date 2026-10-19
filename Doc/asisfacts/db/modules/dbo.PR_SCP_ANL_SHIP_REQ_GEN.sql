/*
 * Program ID   : PR_SCP_ANL_SHIP_REQ_GEN
 * Description  : SHIP_REQ measure 재생성 (RTF 계산과는 별도 로직)
 *                1. MKT_FCST에서 가용재고(기초재고 + 운송중 도착예정)를 차감. 차감은 재고
 *                   가용일과 관계없이 납기가 빠른 수요부터 순서대로 처리
 *                2. From site는 해당 모델의 1순위 경로 사용
 *                   (SCP_MST_BOD_ITEM 우선순위 최소 → BOD → 수요 INCOTERMS 일치 경로 우선)
 *                3. 버킷 = 납기 - 운송 L/T. 계획시작일 이전으로 밀리는 수량은 첫 버킷에 합산
 *                4. Demand Group 무관하게 개별 모델 기준으로 생성
 *                ※ 경로 우선순위 동일 시 From site 순. 유효기간 판정은 계획시작일 기준
 *                @p_project_code 미입력 시 전체 demand 대상, 입력 시 해당 Project만 재생성
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.09.28   JCH            Initial Release
 */
CREATE   PROCEDURE dbo.PR_SCP_ANL_SHIP_REQ_GEN
(
      @p_division_id          NVARCHAR(30)
    , @p_plan_start_yyyymmdd  NVARCHAR(8)
    , @p_plan_type            NVARCHAR(50)
    , @p_seq                  BIGINT
    , @p_inv_plan_id          NVARCHAR(100)
    , @p_project_code         NVARCHAR(50)  = NULL   -- NULL = 전체 demand 재생성
    , @p_user_id              NVARCHAR(150) = 'rtf_sim'
)
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)  = 'PR_SCP_ANL_SHIP_REQ_GEN';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INT            = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_deleted      BIGINT         = 0;
    DECLARE @n_batch        INT;

    -- 시작 LOG
    SET @v_log_type    = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = CONCAT('[',@p_division_id,'/',@p_plan_start_yyyymmdd,'/',@p_plan_type,'/',@p_seq,
                              '/inv=',@p_inv_plan_id,'/proj=',COALESCE(@p_project_code,'ALL'),']');
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type,     @n_log_count,
                              @v_log_message,  @v_description,  @d_event_date;

    BEGIN TRY
        /* 1. 수요 (MKT_FCST) — 조합/납기 기준 + 대표 INCOTERMS/BIZ_TYPE */
        IF OBJECT_ID('tempdb..#sr_dmd') IS NOT NULL DROP TABLE #sr_dmd;
        SELECT f.PROJECT_CODE
             , f.ITEM_ID
             , f.TO_SITE
             , f.YYYYMMDD          AS due_d                                             -- 납기일자
             , MAX(f.INCOTERMS)    AS incoterms                                         -- 수요 기준 INCOTERMS (대표값)
             , MAX(f.BIZ_TYPE)     AS biz_type                                          -- 수요 기준 BIZ_TYPE (대표값)
             , SUM(f.QTY)          AS qty                                               -- 수요수량
        INTO #sr_dmd
        FROM SCP_ANL_SHIPMENT_PLAN_FG f WITH (NOLOCK)
        WHERE f.PLAN_START_YYYYMMDD=@p_plan_start_yyyymmdd AND f.PLAN_TYPE=@p_plan_type AND f.SEQ=@p_seq
          AND f.DIVISION_ID=@p_division_id AND f.MEASURE='MKT_FCST' AND f.QTY>0
          AND (@p_project_code IS NULL OR f.PROJECT_CODE=@p_project_code)
        GROUP BY f.PROJECT_CODE, f.ITEM_ID, f.TO_SITE, f.YYYYMMDD;

        /* 2. 가용재고 집계 (판매법인 사이트의 기초재고 + 운송중 도착예정 전량) */
        IF OBJECT_ID('tempdb..#sr_avail') IS NOT NULL DROP TABLE #sr_avail;
        SELECT COALESCE(NULLIF(i.PROJECT_CODE,''),
               NULLIF(dbo.fn_scm_split(dbo.fn_scm_split(i.ORDER_ID,4,'::'),3,'@'),''),
               '-') AS PROJECT_CODE
             , i.ITEM_ID
             , i.SCM_SITE_ID AS TO_SITE
             , SUM(i.QTY) AS avail_qty                                                  -- 가용재고 합계 (기초재고 + 도착예정)
        INTO #sr_avail
        FROM SCP_EGN_OTPT_INV_M i WITH (NOLOCK)
        INNER JOIN (SELECT DISTINCT SCM_SITE_ID FROM SCM_MST_SITE WITH (NOLOCK)
                    WHERE SITE_TYPE='SALES' AND VALID_YN='Y') s ON i.SCM_SITE_ID=s.SCM_SITE_ID
        WHERE i.PLAN_ID=@p_inv_plan_id AND i.INVENTORY_TYPE IN ('WH','INT')
        GROUP BY COALESCE(NULLIF(i.PROJECT_CODE,''),
                          NULLIF(dbo.fn_scm_split(dbo.fn_scm_split(i.ORDER_ID,4,'::'),3,'@'),''),
                          '-'), i.ITEM_ID, i.SCM_SITE_ID;

        /* 3. netting — 조합별 가용 총량을 납기 FIFO 누적 차감 */
        IF OBJECT_ID('tempdb..#sr_net') IS NOT NULL DROP TABLE #sr_net;
        SELECT d.*
             , COALESCE(a.avail_qty,0) AS avail_qty
             , CASE WHEN d.cum         <= COALESCE(a.avail_qty,0) THEN 0
                    WHEN d.cum - d.qty >= COALESCE(a.avail_qty,0) THEN d.qty
               ELSE d.cum - COALESCE(a.avail_qty,0) END AS req_qty                      -- 출하 필요수량 (가용재고 차감 후 잔여)
        INTO #sr_net
        FROM (SELECT *
             , SUM(qty) OVER (PARTITION BY PROJECT_CODE, ITEM_ID, TO_SITE
               ORDER BY due_d ROWS UNBOUNDED PRECEDING) AS cum                          -- 수요 누적 (납기 순)
        FROM #sr_dmd) d
        LEFT OUTER JOIN #sr_avail a ON a.PROJECT_CODE=d.PROJECT_CODE AND a.ITEM_ID=d.ITEM_ID AND a.TO_SITE=d.TO_SITE;

        /* 4. 품목 1순위 경로 (BOD_ITEM 1순위 → bod_n_v, INCOTERMS 일치 우선) */
        IF OBJECT_ID('tempdb..#sr_route') IS NOT NULL DROP TABLE #sr_route;
        SELECT ITEM_ID
             , TO_SITE
             , incoterms
             , FROM_SITE
             , TRANSPORT_MODE
             , lt
        INTO #sr_route
        FROM (
                SELECT c.ITEM_ID
                     , c.TO_SITE
                     , c.incoterms
                     , b.from_site         AS FROM_SITE
                     , b.transport_mode    AS TRANSPORT_MODE
                     , COALESCE(b.add_after_lt_total,0) AS lt                               -- 운송 L/T (일)
                     , ROW_NUMBER() OVER (PARTITION BY c.ITEM_ID, c.TO_SITE, c.incoterms
                                              ORDER BY bi.PRIORITY, CASE WHEN b.incoterms=c.incoterms THEN 0 ELSE 1 END,
                                                       b.priority, b.from_site) AS rn  -- 1순위 경로 선정 순번
                  FROM (SELECT DISTINCT ITEM_ID
                             , TO_SITE
                             , incoterms
                          FROM #sr_dmd
                       ) c
                INNER JOIN SCP_MST_BOD_ITEM bi WITH (NOLOCK)
                    ON bi.DIVISION_ID = @p_division_id 
                       AND bi.ITEM_ID = c.ITEM_ID AND bi.VALID_YN = 'Y'
                       AND bi.FROM_YYYYMMDD <= @p_plan_start_yyyymmdd 
                       AND bi.TO_YYYYMMDD   >= @p_plan_start_yyyymmdd
                INNER JOIN scp_mst_bod_n_v b WITH (NOLOCK)
                    ON b.division_id = @p_division_id 
                       AND b.BOD_ID = bi.BOD_ID AND b.to_site = c.TO_SITE
                       AND b.bod_valid_yn = 'Y'
                       AND b.from_yyyymmdd <= @p_plan_start_yyyymmdd 
                       AND b.to_yyyymmdd   >= @p_plan_start_yyyymmdd
             ) r 
       WHERE rn=1;

        /* 5. 역shift + 과거 낙착 첫 버킷 → 결과 */
        IF OBJECT_ID('tempdb..#sr_req') IS NOT NULL DROP TABLE #sr_req;
        SELECT n.PROJECT_CODE
             , n.ITEM_ID
             , n.TO_SITE
             , n.biz_type
             , n.incoterms
             , COALESCE(r.FROM_SITE,'-') AS FROM_SITE
             , COALESCE(r.TRANSPORT_MODE,'-') AS TRANSPORT_MODE
             , CASE WHEN CONVERT(NVARCHAR(8), DATEADD(DAY, -COALESCE(r.lt,0), CONVERT(DATE,n.due_d)),112) < @p_plan_start_yyyymmdd
                         THEN @p_plan_start_yyyymmdd
                    ELSE CONVERT(NVARCHAR(8), DATEADD(DAY, -COALESCE(r.lt,0), CONVERT(DATE,n.due_d)),112) END AS bkt  -- 출하 버킷 (납기 - L/T, 계획시작일 이전은 첫 버킷)
             , SUM(n.req_qty) AS qty                                                    -- 출하 필요수량 합계
          INTO #sr_req
          FROM #sr_net n
        LEFT OUTER JOIN #sr_route r ON r.ITEM_ID=n.ITEM_ID AND r.TO_SITE=n.TO_SITE AND r.incoterms=n.incoterms
         WHERE n.req_qty > 0
         GROUP BY n.PROJECT_CODE, n.ITEM_ID, n.TO_SITE, n.biz_type, n.incoterms
                  , COALESCE(r.FROM_SITE,'-'), COALESCE(r.TRANSPORT_MODE,'-')
                  , CASE WHEN CONVERT(NVARCHAR(8), DATEADD(DAY, -COALESCE(r.lt,0), CONVERT(DATE,n.due_d)),112) < @p_plan_start_yyyymmdd
                              THEN @p_plan_start_yyyymmdd
                         ELSE CONVERT(NVARCHAR(8), DATEADD(DAY, -COALESCE(r.lt,0), CONVERT(DATE,n.due_d)),112) END;

        /* 6. 반영 */
        BEGIN TRANSACTION;
            SET @n_batch=1;
            WHILE @n_batch>0
            BEGIN
                DELETE TOP (4000) t FROM SCP_ANL_SHIPMENT_PLAN_FG t
                WHERE t.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
                  AND t.PLAN_TYPE = @p_plan_type
                  AND t.SEQ = @p_seq 
                  AND t.DIVISION_ID = @p_division_id 
                  AND t.MEASURE = 'SHIP_REQ'
                  AND (@p_project_code IS NULL OR t.PROJECT_CODE = @p_project_code);
        
                SET @n_batch=@@ROWCOUNT; SET @n_deleted=@n_deleted+@n_batch;
            END
            INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG
                  ( DIVISION_ID,   PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ,       BIZ_TYPE
                  , PROJECT_CODE,  ITEM_ID,             TO_SITE,   INCOTERMS, FROM_SITE, BOD_ID
                  , MEASURE,       YYYYMMDD,            QTY
                  , CREATED_BY,    CREATION_DATE,       LAST_UPDATED_BY,      LAST_UPDATE_DATE )
            SELECT @p_division_id
                 , @p_plan_start_yyyymmdd
                 , @p_plan_type
                 , @p_seq
                 , COALESCE(r.biz_type,'-')
                 , r.PROJECT_CODE
                 , r.ITEM_ID
                 , r.TO_SITE
                 , COALESCE(r.incoterms,'-')
                 , r.FROM_SITE
                 , '-'
                 , 'SHIP_REQ'
                 , r.bkt
                 , r.qty
                 , @p_user_id
                 , SYSDATETIME()
                 , @p_user_id
                 , SYSDATETIME()
              FROM #sr_req r;
        COMMIT TRANSACTION;

        /* 7. 검증 결과셋 */
        SELECT 'R1_netting_conservation' AS chk_name,
               CASE WHEN NOT EXISTS (
                    SELECT 1 FROM (SELECT PROJECT_CODE
                         , ITEM_ID
                         , TO_SITE
                         , SUM(qty) AS fcst                                             -- 수요 합계
                         , MAX(avail_qty) AS av                                         -- 가용재고 합계
                         , SUM(req_qty) AS req
                    FROM #sr_net GROUP BY PROJECT_CODE, ITEM_ID, TO_SITE) x
                    WHERE ABS(x.req - CASE WHEN x.fcst-x.av>0 THEN x.fcst-x.av ELSE 0 END) > 0.01)
                    THEN 'PASS' ELSE 'FAIL' END AS result
        UNION ALL
        SELECT 'R2_no_negative', CASE WHEN NOT EXISTS (SELECT 1 FROM #sr_req WHERE qty<0) THEN 'PASS' ELSE 'FAIL' END
        UNION ALL
        SELECT 'R3_no_route_combos', CONCAT('rows=', (SELECT COUNT(*) FROM #sr_req WHERE FROM_SITE='-'))
        UNION ALL
        SELECT 'R4_written', CONCAT('deleted=',@n_deleted,' / inserted=',(SELECT COUNT(*) FROM #sr_req));

        SET @v_log_type    = 'END';
        SET @v_log_message = CONCAT('deleted=',@n_deleted,', inserted=',(SELECT COUNT(*) FROM #sr_req));
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
