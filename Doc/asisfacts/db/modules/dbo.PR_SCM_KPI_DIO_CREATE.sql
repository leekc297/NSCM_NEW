

/*
 * Program ID   : PR_SCM_KPI_DIO_CREATE
 * Description  : KPI DIO Detail 데이타 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.10.04   Kim Jihye      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.10.26   yydok          MKT_FCST_MONTHLY query에 group by 추가(plant site id별 여러건 존재)
 * 2018.11.01   yydok          v_basis_yyyymmdd 디폴트값 당월1일로 수정
 *                             EOH 생성시 plan_start_yyyymmdd 에  basis_yyyymmdd와 동일값 셋팅
 * 2018.11.23   YYDOK          MKT_FCST_MONTHLY생성기준을 DIVISION ID, ITEM ID,월별합계로 변경.(생성구간 12개월)
 * 2019.01.02   YYDOK          엔진에 반영되는 것과 동일한 기준으로 활성화를 재고를 반영해서 DIO를 추가 요청(고원택)
 * 2019.01.08   YYDOK          1. item무관하게 cell,module,pack dio생성은 제외함.
 *                                ( PR_SCM_KPI_TOTAL_DIO_SUMMARY 로직제거 )
 *                             2. 가장최근의 Final Plan의 Pack생산계획을 Cell소요로 환산하여
 *                                'MKT_FCST_MONTHLY'로 반영로직 추가.
 * 2019.01.11   YYDOK          FCST TYPE이 'SDF', 'SMF', 'TST'인 것은 제외(김성은,20190110) 
 * 2019.01.16   YYDOK          FCST TYPE이 'ASF'인 것은 제외(김성은,20190116)  
 * 2019.04.15   YYDOK          재고조회쿼리에서 union을 union all로 변경하여 동일수량 집계누락방지
 * 2022.03.25   sclee.lee      PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.06.27   sclee.lee      PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.03.23	hrkim		   [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 */
 
CREATE PROCEDURE [dbo].[PR_SCM_KPI_DIO_CREATE]
(
   @p_basis_yyyymmdd  NVARCHAR(8)
 )
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch';
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_KPI_DIO_CREATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_DETAIL'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCM_KPI_DETAIL INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    

  -- 업무용 변수
  DECLARE @v_basis_yyyymmdd  NVARCHAR(8);  -- 기준 일자
  DECLARE @rows INT;            
    
    BEGIN TRY
      BEGIN
      -- 기준일자 설정, Default 당월1일
        IF @p_basis_yyyymmdd IS NOT NULL
          BEGIN
            SET @v_basis_yyyymmdd = @p_basis_yyyymmdd;
          END
        ELSE
          BEGIN
            SET @v_basis_yyyymmdd = LEFT(CONVERT(VARCHAR,GETDATE(),112),6)+'01' -- 당월 1일
          END
          ;

    ------------------------------------------------------------------------------------
    --  Detail 생성 : MKT_FCST_MONTHLY, EOH - DIO 에 활용, 매월 1일 1회 생성
    --  전월 마지막으로 Cutoff 된 Data 의 당월 MKT_FCST 를 일자별로 적재한다.  
    ------------------------------------------------------------------------------------

    -- 매월 1일인 경우
    IF (RIGHT(@v_basis_yyyymmdd, 2) = '01')
    BEGIN
      DELETE 
        FROM scm_kpi_detail
       WHERE basis_yyyymmdd = @v_basis_yyyymmdd
         AND measure        IN ('MKT_FCST_MONTHLY', 'EOH')
      ;
                   
      ---------------------------------------
      -- Measure : MKT_FCST_MONTHLY
      ---------------------------------------
      INSERT INTO scm_kpi_detail (
                  division_id
              --   ,project_code   --COMMENTED BY YYDOK 2018.11.23
              --   ,sales_site_id  --COMMENTED BY YYDOK 2018.11.23
                 ,item_id
                 ,basis_yyyymmdd
                 ,plan_start_yyyymmdd
                 ,yyyymmdd
                 ,measure
                 ,qty
                 ,valid_yn
                 ,created_by
                 ,creation_date
                 ,last_updated_by
                 ,last_update_date)
        SELECT fc.division_id
            --  ,fc.project_code  --COMMENTED BY YYDOK 2018.11.23
            --  ,fc.scm_site_id   --COMMENTED BY YYDOK 2018.11.23
              ,fc.item_id
              ,@v_basis_yyyymmdd  AS basis_yyyymmdd      --CONVERT(CHAR(8), DATEADD(MM, 1, CONVERT(DATETIME, version_no.yyyymmdd, 112)-DAY(CONVERT(DATETIME, version_no.yyyymmdd, 112)-1)),112) basis_yyyymmdd
              ,@v_basis_yyyymmdd  AS plan_start_yyyymmdd --version_no.yyyymmdd AS plan_start_yyyymmdd   
             -- ,fc.yyyymmdd
               -- COMMENTED BY YYDOK 2018.11.23 월별집계를 하면서 월말일자로 표기처리
              , CONVERT(VARCHAR,EOMONTH(CONVERT(DATETIME,LEFT(fc.yyyymmdd,6)+'01',112)),112) AS YYYYMMDD
              ,'MKT_FCST_MONTHLY'  AS measure
              ,SUM(qty)      AS qty    -- 월별SUM
              ,'Y'           AS valid_yn
              ,@v_batch_user AS created_by
              ,GETDATE()     AS creation_date
              ,@v_batch_user AS last_updated_by
              ,GETDATE()     AS last_update_date
              FROM   dm_pln_mkt_fcst_c fc WITH(NOLOCK)
                     JOIN   (SELECT  division_id
                                    ,version_type
                                    ,LEFT(yyyymmdd, 6) AS yyyymm
                                    ,MAX(yyyymmdd)     AS yyyymmdd
                                    ,MAX(version_no)   AS version_no
                               FROM   dm_mst_version WITH(NOLOCK)
                              WHERE  version_type = 'MF_W'
                              GROUP BY division_id
                                    ,version_type
                                    ,LEFT(yyyymmdd, 6)
                             ) version_no -- 월별 제일 마지막으로 cutoff 된 version_no
                             ON     fc.division_id = version_no.division_id
                             AND    fc.version_no  = version_no.version_no
                             -- 전월 마지막으로 cutoff 된 Data 의 당월 Data 를 적재
                             AND    fc.yyyymmdd    >= CONVERT(CHAR(8), DATEADD(MM, 1, CONVERT(DATETIME, version_no.yyyymmdd, 112)-DAY(CONVERT(DATETIME, version_no.yyyymmdd, 112)-1)),112)
                             -- 이후 12개월의 데이타(1개월-> 12개월로 변경, 2018.11.23 BY YYDOK)
                             AND    fc.yyyymmdd    < CONVERT(CHAR(8), DATEADD(MM, 12, CONVERT(DATETIME, @v_basis_yyyymmdd, 112)),112) --CONVERT(CHAR(8), DATEADD(MM, 2, CONVERT(DATETIME, version_no.yyyymmdd, 112)-DAY(CONVERT(DATETIME, version_no.yyyymmdd, 112)-1)),112)                            
                             AND    fc.measure     = 'MKT_FCST'
                    JOIN   scm_mst_site_item si WITH(NOLOCK)  -- garbage 데이타가 있어, Site Item 에 Setup 된 Item 만 대상으로 함
                             ON     fc.division_id       = si.division_id
                             AND    fc.project_code      = si.project_code
                             AND    fc.scm_site_id       = si.scm_site_id
                             AND    fc.item_id           = si.item_id
                             AND    si.valid_yn          = 'Y'
                    JOIN   scm_mst_site s       WITH(NOLOCK)
                             ON     fc.division_id       = s.division_id
                             AND    fc.scm_site_id       = s.scm_site_id
                             AND    s.valid_yn           = 'Y'
             WHERE  version_no.yyyymm    = LEFT(CONVERT(CHAR(8), DATEADD(MM, -1, @v_basis_yyyymmdd), 112), 6)
               AND  FC.FCST_TYPE NOT IN ( 'SDF', 'SMF', 'TST','ASF' ) --제외할 SALES_TYPE_CODE LOOKUP
             GROUP BY fc.division_id
                   --  ,fc.project_code  --COMMENTED BY YYDOK 2018.11.23
                   --  ,fc.scm_site_id   --COMMENTED BY YYDOK 2018.11.23
                     ,fc.item_id
                     ,LEFT(fc.yyyymmdd,6) -- 월별SUM BY YYDOK 2018.11.23
             ;

      ---------------------------------------------------------------------
      -- Measure : MKT_FCST_MONTHLY (PACK_PLANT)
      --  가장최근의 Final Plan의 Pack생산계획을 Cell소요로 환산하여
      -- 'MKT_FCST_MONTHLY'로 반영로직 추가.
      ---------------------------------------------------------------------
      IF OBJECT_ID('tempdb..#TBL_SCM_KPI_DIO_PACK_REQ_CELL') IS NOT NULL                
         DROP TABLE #TBL_SCM_KPI_DIO_PACK_REQ_CELL ; 
		 
      -- PJ20216891
      -- ISUZU item
      IF OBJECT_ID('tempdb..#TBL_ISUZU') IS NOT NULL                
         DROP TABLE #TBL_ISUZU ; 
		 
      SELECT A.item_id
        INTO #TBL_ISUZU
        FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
       INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
       WHERE A.ITEM_ID = B.ITEM_ID
         AND A.IS_YN = 'Y';
         
WITH XXX AS
(
   SELECT P.DIVISION_ID,
          P.ITEM_ID,
          CONVERT(VARCHAR,EOMONTH(P.START_TIME),112) AS YYYYMMDD,
          ROUND(SUM(P.OPERATION_QTY),0) AS QTY
     FROM SCP_PLN_PRODUCTION_PLAN P WITH(NOLOCK),
         (
             SELECT X.DIVISION_ID,
                    X.PLAN_NAME,
                    X.PLAN_TYPE,
                    X.PLAN_SEQ
             FROM (
                     SELECT D.DIVISION_ID,
                            P.PLAN_NAME,
                            D.PLAN_TYPE,
                            D.PLAN_SEQ,
                            (ROW_NUMBER() OVER ( PARTITION BY D.DIVISION_ID ORDER BY P.PLAN_NAME DESC )) AS SEQ_NO
                       FROM SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
                           ,SCM_MST_PLAN P WITH(NOLOCK)
						    INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
									ON DM.DIVISION_ID = P.DIVISION_ID
								   AND DM.ATTRIBUTE3 != 'EE' -- 전극 제외
								   AND DM.VALID_YN    = 'Y'
                      WHERE 1=1
					  
                        -- PJ20216891
                        -- AND P.DIVISION_ID <> 'EE'
                        -- AND P.DIVISION_ID NOT IN ('EE', 'EE_UC')
                        AND P.PLAN_CYCLE  = 'WEEKLY'
                        AND P.PLAN_NAME   <= @v_basis_yyyymmdd --'20190101'
                        AND P.DIVISION_ID = D.DIVISION_ID
                        AND P.PLAN_ID     = D.PLAN_ID
                        AND D.PLAN_TYPE   = 'FN'
                        AND D.CONFIRM_FLAG ='Y'
                   ) X
              WHERE X.SEQ_NO = 1
          ) SUB 
    WHERE 1=1
      AND P.DIVISION_ID         = SUB.DIVISION_ID
      AND P.PLAN_START_YYYYMMDD = SUB.PLAN_NAME
      AND P.PLAN_TYPE           = SUB.PLAN_TYPE
      AND P.SEQ                 = SUB.PLAN_SEQ
      AND (LEFT(P.operation_id,5) IN ( 'P5500','P9500' )
           OR
           P.operation_id         IN (--외주PACKER의 업체코드
                                       SELECT plant_id  AS operation_id
                                         FROM SCM_MST_SITE S WITH(NOLOCK)      
                                        WHERE 1=1
                                          AND S.division_id = P.division_id 
                                          AND site_type   = 'PLANT'
                                          AND osp_yn      = 'Y' 
                                          AND valid_yn    = 'Y' 
                                     )
									 
           OR
           -- PJ20216891
           -- ISUZU item
           (
            P.operation_id        = 'P5000'
            AND
            EXISTS (
                    SELECT 1 FROM #TBL_ISUZU WHERE ITEM_ID = P.ITEM_ID
                   )
           )
          )
      AND p.START_TIME >= CONVERT(DATETIME,@v_basis_yyyymmdd,112)
      GROUP BY P.DIVISION_ID,
                P.ITEM_ID,
                CONVERT(VARCHAR,EOMONTH(P.START_TIME),112)
) 
   SELECT DIVISION_ID, MODEL_ID, YYYYMMDD, QTY, CELL_ITEM, BOM_QTY
     INTO #TBL_SCM_KPI_DIO_PACK_REQ_CELL
     FROM 
   (SELECT XXX.DIVISION_ID, XXX.ITEM_ID AS MODEL_ID, XXX.YYYYMMDD, XXX.QTY
      --   ,F.ATTRIBUTE1
          ,[dbo].[FN_SCM_SPLIT]( F.ATTRIBUTE1,1 ,',') AS CELL_ITEM
          , ( 
              SELECT TOP 1 V.ACCUMULATED_CHILD_QTY
                FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V
               WHERE 1=1
                 AND V.DIVISION_ID = XXX.DIVISION_ID
                 AND V.MODEL_ID    = XXX.ITEM_ID
                 AND V.CHILD_ITEM_ID = [dbo].[FN_SCM_SPLIT]( F.ATTRIBUTE1,1 ,',')
             ) AS BOM_QTY
          FROM XXX,
          SCP_MST_FINAL_ITEM F WITH(NOLOCK)
    WHERE 1=1
      AND XXX.DIVISION_ID = F.DIVISION_ID
      AND XXX.ITEM_ID     = F.ITEM_ID
      AND F.ATTRIBUTE1 IS NOT NULL
      AND F.ATTRIBUTE1 NOT LIKE '%,%'
   UNION ALL
   SELECT XXX.DIVISION_ID, XXX.ITEM_ID AS MODEL_ID, XXX.YYYYMMDD, XXX.QTY
      --   ,F.ATTRIBUTE1
          ,[dbo].[FN_SCM_SPLIT]( F.ATTRIBUTE1,2 ,',') AS CELL_ITEM
          , ( 
              SELECT TOP 1 V.ACCUMULATED_CHILD_QTY
                FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V
               WHERE 1=1
                 AND V.DIVISION_ID = XXX.DIVISION_ID
                 AND V.MODEL_ID    = XXX.ITEM_ID
                 AND V.CHILD_ITEM_ID = [dbo].[FN_SCM_SPLIT]( F.ATTRIBUTE1,2 ,',')
             ) AS BOM_QTY
          FROM XXX,
          SCP_MST_FINAL_ITEM F WITH(NOLOCK)
    WHERE 1=1
      AND XXX.DIVISION_ID = F.DIVISION_ID
      AND XXX.ITEM_ID     = F.ITEM_ID
      AND F.ATTRIBUTE1 IS NOT NULL
      AND F.ATTRIBUTE1  LIKE '%,%'
      AND F.ATTRIBUTE1  NOT LIKE '%,%,'
   UNION ALL
   SELECT XXX.DIVISION_ID, XXX.ITEM_ID AS MODEL_ID, XXX.YYYYMMDD, XXX.QTY
      --   ,F.ATTRIBUTE1
          ,[dbo].[FN_SCM_SPLIT]( F.ATTRIBUTE1,3 ,',') AS CELL_ITEM
          , ( 
              SELECT TOP 1 V.ACCUMULATED_CHILD_QTY
                FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V
               WHERE 1=1
                 AND V.DIVISION_ID = XXX.DIVISION_ID
                 AND V.MODEL_ID    = XXX.ITEM_ID
                 AND V.CHILD_ITEM_ID = [dbo].[FN_SCM_SPLIT]( F.ATTRIBUTE1,2 ,',')
             ) AS BOM_QTY
          FROM XXX,
          SCP_MST_FINAL_ITEM F WITH(NOLOCK)
    WHERE 1=1
      AND XXX.DIVISION_ID = F.DIVISION_ID
      AND XXX.ITEM_ID     = F.ITEM_ID
      AND F.ATTRIBUTE1 IS NOT NULL
      AND F.ATTRIBUTE1  LIKE '%,%,'
   ) FFF
  ;


      INSERT INTO scm_kpi_detail (
                                   division_id
                               --   ,project_code   --COMMENTED BY YYDOK 2018.11.23
                                  ,sales_site_id 
                                  ,item_id
                                  ,basis_yyyymmdd
                                  ,plan_start_yyyymmdd
                                  ,yyyymmdd
                                  ,measure
                                  ,qty
                                  ,valid_yn
                                  ,created_by
                                  ,creation_date
                                  ,last_updated_by
                                  ,last_update_date)         
                SELECT DIVISION_ID
                      ,'PACK_PLANT' --SALES_SITE_ID
                      ,CELL_ITEM          AS ITEM_ID
                      ,@v_basis_yyyymmdd  AS basis_yyyymmdd
                      ,@v_basis_yyyymmdd  AS plan_start_yyyymmdd
                      ,YYYYMMDD 
                      ,'MKT_FCST_MONTHLY'   AS measure
                      ,SUM( QTY * BOM_QTY ) AS QTY
                      ,'Y'           AS valid_yn
                      ,@v_batch_user AS created_by
                      ,GETDATE()     AS creation_date
                      ,@v_batch_user AS last_updated_by
                      ,GETDATE()     AS last_update_date
                  FROM #TBL_SCM_KPI_DIO_PACK_REQ_CELL
                GROUP BY DIVISION_ID,
                         YYYYMMDD, 
                         CELL_ITEM
                     ;        

      ---------------------------------------
      -- Measure : EOH
      ---------------------------------------      
 
 /* --COMMENTED BY YYDOK 2019.01.02
 
      INSERT INTO scm_kpi_detail 
                ( division_id
                 ,item_id
                 ,basis_yyyymmdd
                 ,plan_start_yyyymmdd          
                 ,measure
                 ,qty
                 ,valid_yn
                 ,created_by
                 ,creation_date
                 ,last_updated_by
                 ,last_update_date)
      SELECT stock.division_id
            ,stock.item_id
            ,@v_basis_yyyymmdd  -- stock.cutoff_date
            ,@v_basis_yyyymmdd  -- stock.cutoff_date
            ,'EOH' AS measure
             ,SUM(stock.stock_qty) AS qty
            ,'Y'           AS valid_yn
            ,@v_batch_user AS created_by
            ,GETDATE()     AS creation_date
            ,@v_batch_user AS last_updated_by
            ,GETDATE()     AS last_update_date
        FROM  (SELECT sv.division_id
                     ,item_id
                     ,sv.scm_qty stock_qty
                     ,CONVERT(CHAR(8), DATEADD(dd, 1, sv.cutoff_date), 112) cutoff_date -- 월말 재고를 월초 재고로 반영하기 위해 +1일
                 FROM scm_dnm_stock_v sv WITH(NOLOCK)
                WHERE sv.scm_site_id IS NOT NULL
                  AND    sv.scm_qty > 0
                UNION 
               SELECT ic.division_id
                     ,ic.item_id
                     ,ic.delivery_qty stock_qty
                     ,CONVERT(CHAR(8), DATEADD(dd, 1, ic.result_date), 112) cutoff_date -- 월말 재고를 월초 재고로 반영하기 위해 +1일
                 FROM   scm_dnm_intransit_c ic WITH(NOLOCK)
                WHERE  ic.result_type IN ('I', 'S') -- I : GTS 사용 법인 운송중 재고, S : GTS 미사용 법인 운송중 재고
                  AND    ic.to_scm_site_id IS NOT NULL
                  AND    ic.delivery_qty > 0
               ) stock
              JOIN   scp_mst_final_item fi WITH(NOLOCK)
                     ON  stock.division_id = fi.division_id
                     AND stock.item_id     = fi.item_id
       WHERE RIGHT(stock.cutoff_date, 2) = '01'
         AND stock.cutoff_date = @v_basis_yyyymmdd
       GROUP BY stock.division_id
                ,stock.item_id  
                ,stock.cutoff_date
      ;
*/

      INSERT INTO scm_kpi_detail 
                ( division_id
                 ,item_id
                 ,basis_yyyymmdd
                 ,plan_start_yyyymmdd          
                 ,measure
                 ,qty
                 ,valid_yn
                 ,created_by
                 ,creation_date
                 ,last_updated_by
                 ,last_update_date)
      SELECT stock.division_id
            ,stock.item_id
            ,@v_basis_yyyymmdd  -- stock.cutoff_date
            ,@v_basis_yyyymmdd  -- stock.cutoff_date
            ,'EOH' AS measure
             ,SUM(stock.stock_qty) AS qty
            ,'Y'           AS valid_yn
            ,@v_batch_user AS created_by
            ,GETDATE()     AS creation_date
            ,@v_batch_user AS last_updated_by
            ,GETDATE()     AS last_update_date
        FROM  (
               SELECT sv.division_id
                     ,item_id
                     ,sv.scm_qty stock_qty
                     ,CONVERT(CHAR(8), DATEADD(dd, 1, sv.cutoff_date), 112) cutoff_date -- 월말 재고를 월초 재고로 반영하기 위해 +1일
                 -- FROM scm_dnm_stock_v sv WITH(NOLOCK)
                 FROM scm_dnm_stock sv WITH(NOLOCK)
                WHERE sv.scm_site_id IS NOT NULL
                  AND    sv.scm_qty > 0

                UNION ALL
				-- 해상재고 : 엔진 반영
                SELECT ic.division_id
                      ,ic.item_id
                      ,ic.delivery_qty stock_qty
                      ,CONVERT(CHAR(8), DATEADD(dd, 1, ic.result_date), 112) cutoff_date -- 월말 재고를 월초 재고로 반영하기 위해 +1일
				  FROM SCM_DNM_INTRANSIT_V ic WITH(NOLOCK)           
                 WHERE ic.to_scm_site_id IS NOT NULL
                   AND ic.delivery_qty > 0
              /*
               SELECT ic.division_id
                     ,ic.item_id
                     ,ic.delivery_qty stock_qty
                     ,CONVERT(CHAR(8), DATEADD(dd, 1, ic.result_date), 112) cutoff_date -- 월말 재고를 월초 재고로 반영하기 위해 +1일
                 FROM   scm_dnm_intransit_c ic WITH(NOLOCK)
                 INNER JOIN ( SELECT division_id, scm_site_id 
                                FROM dbo.scm_mst_site WITH (NOLOCK) 
                               WHERE 1=1 
                                 AND site_type   = 'SALES' 
                                 AND valid_yn    = 'Y') b
                        ON  ic.division_id            = b.division_id
                       AND  ic.to_scm_site_id         = b.scm_site_id
                WHERE  ic.result_type IN ('I', 'S') -- I : GTS 사용 법인 운송중 재고, S : GTS 미사용 법인 운송중 재고
                  AND    ic.to_scm_site_id IS NOT NULL
                  AND    ic.delivery_qty > 0
                  AND    ic.incoterms              <> 'FOB' -- FOB는 해상재고 없음
               union ALL
               SELECT ic.division_id
                     ,ic.item_id
                     ,ic.delivery_qty stock_qty
                     ,CONVERT(CHAR(8), DATEADD(dd, 1, ic.result_date), 112) cutoff_date -- 월말 재고를 월초 재고로 반영하기 위해 +1일
                 FROM   scm_dnm_intransit_c ic WITH(NOLOCK)
                 INNER JOIN ( SELECT division_id, scm_site_id 
                                FROM dbo.scm_mst_site WITH (NOLOCK) 
                               WHERE 1=1
                                 AND site_type   = 'PLANT' 
                                 AND valid_yn    = 'Y') b
                         ON  ic.division_id             = b.division_id
                        AND  ic.to_scm_site_id          = b.scm_site_id
                WHERE  ic.result_type ='C' -- C : 법인간 해상재고
                  AND  ic.to_scm_site_id IS NOT NULL
                  AND  ic.delivery_qty > 0
              */

               union ALL
               SELECT ic.division_id
                     ,ic.item_id
                     ,ic.delivery_qty stock_qty
                     ,CONVERT(CHAR(8), DATEADD(dd, 1, ic.result_date), 112) cutoff_date -- 월말 재고를 월초 재고로 반영하기 위해 +1일
                 FROM   scm_dnm_intransit_c ic WITH(NOLOCK)

                 INNER JOIN ( SELECT division_id, scm_site_id 
                            FROM   dbo.scm_mst_site WITH (NOLOCK) 
                            WHERE  1=1
                            AND    site_type   = 'SALES' 
                            AND    valid_yn    = 'Y') b
                         ON  ic.division_id             = b.division_id
                        AND  ic.to_scm_site_id          = b.scm_site_id                 
                WHERE  ic.result_type ='B' -- B : BNP창고재고
                  AND    ic.to_scm_site_id IS NOT NULL
                  AND    ic.delivery_qty > 0
                  
              UNION ALL
               SELECT sv.division_id
                     ,item_id
                     ,sv.qty stock_qty
                     ,CONVERT(CHAR(8), DATEADD(dd, 1, sv.cutoff_date), 112) cutoff_date -- 월말 재고를 월초 재고로 반영하기 위해 +1일
                 FROM scm_dnm_stock_aging_v sv WITH(NOLOCK)
                WHERE sv.scm_site_id IS NOT NULL
                  AND sv.qty > 0                          
               ) stock
              JOIN   scp_mst_final_item fi WITH(NOLOCK)
                     ON  stock.division_id = fi.division_id
                     AND stock.item_id     = fi.item_id
       WHERE RIGHT(stock.cutoff_date, 2) = '01'
         AND stock.cutoff_date = @v_basis_yyyymmdd
       GROUP BY stock.division_id
                ,stock.item_id  
                ,stock.cutoff_date
      ;      
      
    /************************************
     *  item type update
     ************************************/
    update scm_kpi_detail
       set item_type = 
                       ( SELECT 
                               case  min( 
                                          case when T1.item_type = 'P' then 1
                                               when T1.item_type = 'H' then 2
                                               when T1.item_type = 'Q' then 3
                                               else 4 
                                          end
                                         )  
                               when 1 then 'P' 
                               when 2 then 'H'
                               when 3 then 'Q'
                               else 'R' 
                               end
                          FROM dbo.SCM_MST_ITEM_SN T1 WITH(NOLOCK)
                         WHERE t1.division_id  = scm_kpi_DETAIL.division_id
                           and t1.item_id      = scm_kpi_DETAIL.item_id              
                                   )       
     where basis_yyyymmdd = @v_basis_yyyymmdd
       AND MEASURE        IN ('MKT_FCST_MONTHLY', 'EOH')
        ;      

    END;  
    

        -----------------------------------------------------------
        -- KPI_TYPE: DIO --(SCP)
        -----------------------------------------------------------
        EXEC @ROWS = PR_SCM_KPI_DIO_SUMMARY           @p_basis_yyyymmdd = @v_basis_yyyymmdd
        IF (@rows < 0 )  GOTO _RETURN_ERR_CODE                   
        -----------------------------------------------------------
        -- KPI_TYPE: TOTAL_DIO --(SCP)
        -- commented by yydok 2019.1.8 item무관하게 cell,module,pack dio생성은 제외함.
        -----------------------------------------------------------
   --     EXEC @ROWS = PR_SCM_KPI_TOTAL_DIO_SUMMARY     @p_basis_yyyymmdd = @v_basis_yyyymmdd        
   --     IF (@rows < 0 )  GOTO _RETURN_ERR_CODE 
        
/* --TOTAL DIO 점검

SELECT BASIS_YYYYMMDD,
       DIVISION_ID,
       ITEM_ID AS OPERATION_GROUP_NAME,
       KPI_RATE
  FROM SCM_KPI_SUMMARY WITH(NOLOCK)
WHERE 1=1
   AND BASIS_YYYYMMDD >='20180901'  --조회구간 201808~201810
   AND BASIS_YYYYMMDD <='20181101'
   AND KPI_TYPE       ='TOTAL_DIO'
ORDER BY DIVISION_ID, 
         CASE ITEM_ID WHEN 'ALL' THEN 1
                      WHEN 'PACK' THEN 2
                      WHEN 'MODULE' THEN 3
                      WHEN 'CELL' THEN 4
                      ELSE 5
         END
*/
/* --ITEM DIO 점검
SELECT DIO.BASIS_YYYYMMDD, 
       DIO.DIVISION_ID,
       DIO.ITEM_ID,
       SUM(EOH.QTY)   AS EOH_QTY,
       SUM(SALES.QTY) AS SALES_QTY,
       MIN(DIO.DIO)   AS DIO
FROM
     (
         SELECT BASIS_YYYYMMDD,
                DIVISION_ID,
                ITEM_ID,
                KPI_RATE AS DIO
           FROM SCM_KPI_SUMMARY S WITH(NOLOCK)
          WHERE 1=1 --S.BASIS_YYYYMMDD >='20180901'
            --AND S.BASIS_YYYYMMDD <='20181101'
            AND S.KPI_TYPE       ='DIO'
            AND S.ITEM_TYPE IN ('P','H')
     ) DIO
     LEFT OUTER JOIN
     (
         SELECT DIVISION_ID,
                PLAN_START_YYYYMMDD,
                ITEM_ID,
                QTY
           FROM SCM_KPI_DETAIL  WITH(NOLOCK)
          WHERE MEASURE       ='EOH'
     ) EOH
     ON  1=1
     AND DIO.DIVISION_ID    = EOH.DIVISION_ID
     AND DIO.ITEM_ID        = EOH.ITEM_ID
     AND DIO.BASIS_YYYYMMDD = EOH.PLAN_START_YYYYMMDD
     LEFT OUTER JOIN
     (
         SELECT DIVISION_ID,
                PLAN_START_YYYYMMDD,
                ITEM_ID,
                QTY
           FROM SCM_KPI_DETAIL  WITH(NOLOCK)
          WHERE MEASURE       ='MKT_FCST_MONTHLY'
     ) SALES
     ON 1=1
     AND DIO.DIVISION_ID    = SALES.DIVISION_ID
     AND DIO.ITEM_ID        = SALES.ITEM_ID
     AND DIO.BASIS_YYYYMMDD = SALES.PLAN_START_YYYYMMDD
WHERE 1=1
  AND DIO.BASIS_YYYYMMDD >='20180901'
  AND DIO.BASIS_YYYYMMDD <='20181101'
  --AND DIO.ITEM_ID ='MCCE121501A3'
GROUP BY DIO.BASIS_YYYYMMDD, 
         DIO.DIVISION_ID,
         DIO.ITEM_ID
ORDER BY 1,2,3
*/                            
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

      END;

      -- 임시테이블 제거
      IF OBJECT_ID('tempdb..#TBL_SCM_KPI_DIO_PACK_REQ_CELL') IS NOT NULL                
         DROP TABLE #TBL_SCM_KPI_DIO_PACK_REQ_CELL ; 
		 
      IF OBJECT_ID('tempdb..#TBL_ISUZU') IS NOT NULL                
         DROP TABLE #TBL_ISUZU ; 
		 
    END TRY

    BEGIN CATCH
        
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1 

    _RETURN_ERR_CODE:          
        BEGIN          
             RETURN -1          
        END;  
  END;
