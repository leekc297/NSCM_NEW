-- ============================================================
-- FN_DQ_* table functions (VALID only, 3) — FN_DQ_FP_PLAN 제외 (RETURNS TABLE 잔존)
-- 실행 계정: SCM_MGR · dev/local DDL extract 2026-06-22
-- ============================================================

-- ===== FN_DQ_MKT_FCST_81 =====
CREATE OR REPLACE EDITIONABLE FUNCTION "SCM_MGR"."FN_DQ_MKT_FCST_81" 
(
    p_cutoff_date    IN VARCHAR2,
    p_division_id    IN VARCHAR2,
    p_cell_nickname  IN VARCHAR2
)
RETURN t_FN_dq_mkt_fcst_81_tab
PIPELINED
/*
 * Program ID   : FN_DQ_MKT_FCST_81
 * Description  : 자동차 DQ 용 Stock
 * 실행 예제    : SELECT * FROM TABLE(FN_DQ_MKT_FCST_81('20260126', '81', 'F10'));
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023.11.09	KSG			[PJ20230692] LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 자동차 DQ 용 Stock 정보
 * 2026.03.13   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
IS
BEGIN
    FOR r IN (
        SELECT division_id,
               version,
               project_code,
               fcst_type,
               project,
               to_site,
               incoterms,
               item_type,
               cell_item_id,
               item_id,
               cell_model,
               measure,
               yyyypw,
               SUM(qty)                                        AS qty,
               MAX(cell_conversion_factor)                     AS cell_conv,
               (SUM(qty) * MAX(cell_conversion_factor)) / 1000.0 AS kcell
        FROM (
                SELECT m.division_id,
                       m.version_no                            AS version,
                       m.project_code,

                       (SELECT l.segment2
                        FROM   scm_adm_lookup_master_detail l
                        WHERE  l.lookup_type = 'SALES_TYPE_CODE'
                        AND    l.segment1    = m.fcst_type
                       )                                       AS fcst_type,

                       p.project_name                          AS project,
                       m.scm_site_id                           AS to_site,
                       m.incoterms,

                       (SELECT l.segment2
                        FROM   scm_adm_lookup_master_detail l
                        WHERE  l.lookup_type = 'ITEM_TYPE_CODE'
                        AND    l.segment1    = i.item_type
                       )                                       AS item_type,

                       CASE WHEN fi.operation_group = 'A' THEN m.item_id
                            WHEN fi.operation_group = 'P' THEN fi.attribute1
                            ELSE ''
                       END                                     AS cell_item_id,

                       m.item_id,

                       CASE WHEN fi.operation_group = 'A' THEN fi.group_code1
                            WHEN fi.operation_group = 'P' THEN (SELECT b.group_code1
                                                                FROM   scp_mst_final_item b
                                                                WHERE  b.division_id = fi.division_id
                                                                AND    b.item_id     = fi.attribute1)
                            ELSE ''
                       END                                     AS cell_model,

                       CASE WHEN m.measure = 'MKT_FCST_RP' THEN 'MKT FCST[R+P]'
                            WHEN m.measure = 'RTF_SYS_RP'  THEN 'RTF[R+P]'
                            WHEN m.measure = 'AS_In_Req'   THEN 'AS in Request[R+P]'
                            WHEN m.measure = 'AS_In_Plan'  THEN 'AS in Plan[R+P]'
                            ELSE ''
                       END                                     AS measure,

                       buc.yyyypw                              AS yyyypw,

                       m.qty,

                       CASE WHEN NVL(fi.cell_cf, '') = '' THEN 1.0
                            ELSE TO_NUMBER(fi.cell_cf)
                       END                                     AS cell_conversion_factor,

                       CASE WHEN fi.operation_group = 'A' THEN m.qty
                            ELSE m.qty * CASE WHEN NVL(fi.cell_cf, '') = '' THEN 1.0
                                              ELSE TO_NUMBER(fi.cell_cf)
                                         END
                       END                                     AS cell,

                       CASE WHEN fi.operation_group = 'A' THEN m.qty
                            ELSE m.qty * CASE WHEN NVL(fi.cell_cf, '') = '' THEN 1.0
                                              ELSE TO_NUMBER(fi.cell_cf)
                                         END
                       END / 1000.0                            AS kcell

                FROM   dm_pln_mkt_fcst_c m

                INNER JOIN (-- 입력 일자의 주차 월요일 이후 최신 버전
                            SELECT cutoff_type, MAX(version_no) AS version_no
                            FROM   dm_pln_mkt_fcst_c
                            WHERE  1=1
                            AND    division_id       = p_division_id
                            AND    cutoff_yyyymmdd  >= TO_CHAR(FN_NEXT_DAY(TO_DATE(p_cutoff_date, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD') -- 입력 일자의 주차 월요일
                            AND    cutoff_yyyymmdd  <  TO_CHAR(FN_NEXT_DAY(TO_DATE(p_cutoff_date, 'YYYYMMDD'), 'MON') - 0, 'YYYYMMDD') -- 입력 일자의 다음 주차 월요일
                            AND    cutoff_type       = 'MF_W'
                            GROUP BY cutoff_type
                           ) cf
                ON  m.cutoff_type = cf.cutoff_type
                AND m.version_no  = cf.version_no

                LEFT JOIN scp_mst_final_item fi
                ON  m.division_id = fi.division_id
                AND m.item_id     = fi.item_id

                LEFT JOIN scm_mst_project p
                ON  m.division_id  = p.division_id
                AND m.project_code = p.project_code

                LEFT JOIN (
                            SELECT division_id, item_id, item_type
                            FROM  (
                                    SELECT division_id, item_id, item_type,
                                           ROW_NUMBER() OVER (PARTITION BY division_id, item_id ORDER BY seq) AS rnum
                                    FROM  (
                                            SELECT division_id, item_id, item_type,
                                                   CASE WHEN item_type = 'P' THEN 10
                                                        WHEN item_type = 'H' THEN 20
                                                        WHEN item_type = 'Q' THEN 30
                                                        WHEN item_type = 'R' THEN 40
                                                        ELSE 99
                                                   END AS seq
                                            FROM   scm_mst_item_sn
                                            WHERE  1=1
                                            AND    division_id = p_division_id
                                          ) a
                                  ) b
                            WHERE rnum = 1
                         ) i
                ON  m.division_id = i.division_id
                AND m.item_id     = i.item_id

                INNER JOIN scm_mst_bucket buc
                ON  m.yyyymmdd = buc.yyyymmdd

                WHERE 1=1
                AND   m.division_id = p_division_id
                AND   m.measure IN ('MKT_FCST_RP', 'RTF_SYS_RP', 'AS_In_Req', 'AS_In_Plan')
             ) res
        WHERE  1=1
        AND    cell_model LIKE '%' || p_cell_nickname || '%'
        GROUP BY division_id, version, project_code, fcst_type, project, to_site, incoterms,
                 item_type, cell_item_id, item_id, cell_model, measure, yyyypw
    )
    LOOP
        PIPE ROW (
            t_FN_dq_mkt_fcst_81_row(
                r.division_id,
                r.version,
                r.project_code,
                r.fcst_type,
                r.project,
                r.to_site,
                r.incoterms,
                r.item_type,
                r.cell_item_id,
                r.item_id,
                r.cell_model,
                r.measure,
                r.yyyypw,
                r.qty,
                r.cell_conv,
                r.kcell
            )
        );
    END LOOP;

    RETURN;
END FN_DQ_MKT_FCST_81;
/

-- ===== FN_DQ_PROD_PLAN =====
CREATE OR REPLACE EDITIONABLE FUNCTION "SCM_MGR"."FN_DQ_PROD_PLAN" 

(

      p_plan_start_yyyymmdd IN VARCHAR2

    , p_division_id         IN VARCHAR2

    , p_operation_group     IN VARCHAR2 DEFAULT 'A'  -- 아래에서 'A' 고정 처리함

    , p_plan_type           IN VARCHAR2 DEFAULT 'FN'

    , p_measure             IN VARCHAR2 DEFAULT 'PROD_PLAN_AMEND'

    , p_plant_id            IN VARCHAR2

)

RETURN FN_DQ_PROD_PLAN_TAB PIPELINED

IS

    v_plan_type         VARCHAR2(30 CHAR) := p_plan_type;

    v_measure           VARCHAR2(30 CHAR) := p_measure;

    v_operation_group   VARCHAR2(30 CHAR) := 'A';  -- p_operation_group; -- 'A' 고정



    /*********************************************************

     -- p_plan_start_yyyymmdd : 계획시작일자

     -- v_re_start_yyyymmdd : 실적 시작일자 - p_plan_start_yyyymmdd 기준 이전 3주치

     -- v_re_end_yyyymmdd   : 실적 종료일자 (계획시작일 전일)

     **********************************************************/

    v_re_start_yyyymmdd VARCHAR2(8 CHAR) := TO_CHAR(TO_DATE(p_plan_start_yyyymmdd, 'YYYYMMDD') - 7 * 3, 'YYYYMMDD');

    v_re_end_yyyymmdd   VARCHAR2(8 CHAR) := TO_CHAR(TO_DATE(p_plan_start_yyyymmdd, 'YYYYMMDD') - 1,     'YYYYMMDD');



    -- 당주(계획주차) 월요일. 입력 계획시작일이 당주 월요일이면 운영 테이블, 아니면 이력 테이블 사용

    v_curr_week_mon     VARCHAR2(8 CHAR) := TO_CHAR(FN_NEXT_DAY(SYSDATE - 7, 'MON'), 'YYYYMMDD');

BEGIN



   /*********************************************************

    -- 1.0 : 계획

    **********************************************************/

    IF p_plan_start_yyyymmdd = v_curr_week_mon THEN

        -----------------------------------------------

        -- 당주 정보 (운영 테이블 scp_anl_production_plan)

        -----------------------------------------------

        FOR r IN (

            WITH item_id_prod_info AS (

                SELECT division_id, item_id_assy, item_id_prod, cp_priority

                FROM (

                      SELECT  m.division_id

                            , m.item_id_assy

                            , m.item_id_prod

                            , row_number() over (partition by m.division_id

                                                            , m.item_id_assy

                                                 order by f.tco_cell_yn

                                                        , m.item_id_prod) as cp_priority

                        FROM SCP_MST_CELL_PROD_ASSY_MAP m

                             INNER JOIN scp_mst_final_item_v f

                                     ON f.item_id = m.item_id_prod

                        WHERE  1=1

                        AND    m.division_id IN (SELECT COLUMN_VALUE FROM String_Split(p_division_id, ','))

                        AND    m.valid_yn    = 'Y'

                     ) a

                WHERE 1=1

                AND   cp_priority = 1

            )

            SELECT a.division_id                                  AS division_id

                 , a.operation_group                              AS operation_group

                 , s.plant_id                                     AS scm_site_id    -- a.scm_site_id

                 , CASE WHEN s.osp_yn = 'Y'        THEN CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE v.ATTRIBUTE1 END

                        WHEN s.osp_yn = 'N'        THEN CASE WHEN SN.DESCRIPTION IS NULL THEN (CASE WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE SN.DESCRIPTION END

                   END                                            AS plant_name

                 , a.line_id                                      AS line_id

                 , im.item_id_prod                                AS item_id_prod

                 , a.item_id                                      AS item_id

                 , item.NICK_NAME                                 AS nick_name

                 , a.measure                                      AS measure

                 , SUBSTR(buc.yyyypw, 3, 2) || '_W' || SUBSTR(buc.yyyypw, 5, 2)

                   || CASE WHEN SUBSTR(buc.yyyypw, 7, 1) IS NULL THEN ''

                           ELSE '_' || SUBSTR(buc.yyyypw, 7, 1)

                      END                                         AS yyyypw

                 , SUM(a.qty) / 1000.0                            AS qty            -- K Cell 단위

            FROM scp_anl_production_plan a



                INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY division_id, plan_start_yyyymmdd, plan_type ORDER BY CASE WHEN confirm_flag = 'Y' THEN 1 ELSE 9 END, plan_seq DESC ) row_num

                                 , b.*

                            FROM   SCP_PLAN_VERSION_V b

                            WHERE  division_id         IN (SELECT COLUMN_VALUE FROM String_Split(p_division_id, ','))

                            AND    plan_start_yyyymmdd  = p_plan_start_yyyymmdd

                            AND    plan_type            = v_plan_type

                           ) b

                ON  a.division_id          = b.division_id

                AND a.plan_start_yyyymmdd  = b.plan_start_yyyymmdd

                AND a.plan_type            = b.plan_type

                AND a.seq                  = b.plan_seq

                AND b.row_num              = 1

                AND a.operation_group      = v_operation_group



                INNER JOIN (SELECT division_id, plan_name, MAX(horizon_end_date) AS to_yyyymmdd

                            FROM   SCM_MST_PLAN

                            WHERE  division_id IN (SELECT COLUMN_VALUE FROM String_Split(p_division_id, ','))

                            AND    plan_name    = p_plan_start_yyyymmdd

                            GROUP BY division_id, plan_name

                           ) pl

                ON  a.division_id         = pl.division_id

                AND a.plan_start_yyyymmdd = pl.plan_name

                AND a.yyyymmdd           <= pl.to_yyyymmdd -- Plan 구간 내 정보



                INNER JOIN SCM_MST_BUCKET buc

                ON a.yyyymmdd             = buc.yyyymmdd



                INNER JOIN SCM_MST_SITE     S

                ON  S.DIVISION_ID = a.DIVISION_ID

                AND S.scm_site_id = a.scm_site_id

                AND S.PLANT_ID IN (SELECT COLUMN_VALUE FROM String_Split(p_plant_id, ','))



                LEFT OUTER JOIN SCM_MST_PLANT_SN P ON S.COMPANY_ID = P.COMPANY_ID AND S.DIVISION_ID = P.DIVISION_ID AND S.PLANT_ID = P.PLANT_ID

                LEFT OUTER JOIN SCM_MST_VENDOR   V ON V.VENDOR_CODE = S.PLANT_ID AND S.COMPANY_ID = V.COMPANY_ID

                LEFT OUTER JOIN SCM_MST_PLANT_SN SN ON S.DIVISION_ID = SN.DIVISION_ID AND S.PLANT_ID = SN.PLANT_ID



                LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME

                                    FROM SCM_MST_ITEM_SN

                                    WHERE 1=1

                                    AND NICK_NAME IS NOT NULL

                                    AND   ACTIVE_FLAG = 'Y'

                                    GROUP BY DIVISION_ID, ITEM_ID

                                ) item

                ON  a.division_id = item.division_id

                AND a.item_id     = item.item_id



                LEFT OUTER JOIN item_id_prod_info im

                ON  a.division_id = im.division_id

                AND a.item_id     = im.item_id_assy



            WHERE  1=1

            AND    a.measure              = v_measure --'PROD_PLAN_AMEND'

            AND    a.qty                 <> 0



            GROUP BY a.division_id, a.operation_group, s.plant_id-- a.scm_site_id

                 , CASE WHEN s.osp_yn = 'Y'        THEN CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE v.ATTRIBUTE1 END

                        WHEN s.osp_yn = 'N'        THEN CASE WHEN SN.DESCRIPTION IS NULL THEN (CASE WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE SN.DESCRIPTION END

                   END

                 , a.line_id

                 , im.item_id_prod, a.item_id, item.NICK_NAME

                 , a.measure, buc.yyyypw

        ) LOOP

            PIPE ROW (FN_DQ_PROD_PLAN_ROW(

                  r.division_id, r.operation_group, r.scm_site_id, r.plant_name, r.line_id

                , r.item_id_prod, r.item_id, r.nick_name, r.measure, r.yyyypw, r.qty));

        END LOOP;



    ELSE

        -----------------------------------------------

        -- 이전 주차 정보 (이력 테이블 hist_scp_anl_production_plan)

        -----------------------------------------------

        FOR r IN (

            WITH item_id_prod_info AS (

                SELECT division_id, item_id_assy, item_id_prod, cp_priority

                FROM (

                      SELECT  m.division_id

                            , m.item_id_assy

                            , m.item_id_prod

                            , row_number() over (partition by m.division_id

                                                            , m.item_id_assy

                                                 order by f.tco_cell_yn

                                                        , m.item_id_prod) as cp_priority

                        FROM SCP_MST_CELL_PROD_ASSY_MAP m

                             INNER JOIN scp_mst_final_item_v f

                                     ON f.item_id = m.item_id_prod

                        WHERE  1=1

                        AND    m.division_id IN (SELECT COLUMN_VALUE FROM String_Split(p_division_id, ','))

                        AND    m.valid_yn    = 'Y'

                     ) a

                WHERE 1=1

                AND   cp_priority = 1

            )

            SELECT a.division_id                                  AS division_id

                 , a.operation_group                              AS operation_group

                 , s.plant_id                                     AS scm_site_id    -- a.scm_site_id

                 , CASE WHEN s.osp_yn = 'Y'        THEN CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE v.ATTRIBUTE1 END

                        WHEN s.osp_yn = 'N'        THEN CASE WHEN SN.DESCRIPTION IS NULL THEN (CASE WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE SN.DESCRIPTION END

                   END                                            AS plant_name

                 , a.line_id                                      AS line_id

                 , im.item_id_prod                                AS item_id_prod

                 , a.item_id                                      AS item_id

                 , item.NICK_NAME                                 AS nick_name

                 , a.measure                                      AS measure

                 , SUBSTR(buc.yyyypw, 3, 2) || '_W' || SUBSTR(buc.yyyypw, 5, 2)

                   || CASE WHEN SUBSTR(buc.yyyypw, 7, 1) IS NULL THEN ''

                           ELSE '_' || SUBSTR(buc.yyyypw, 7, 1)

                      END                                         AS yyyypw

                 , SUM(a.qty) / 1000.0                            AS qty            -- K Cell 단위

            FROM hist_scp_anl_production_plan a



                INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY division_id, plan_start_yyyymmdd, plan_type ORDER BY CASE WHEN confirm_flag = 'Y' THEN 1 ELSE 9 END, plan_seq DESC ) row_num

                                 , b.*

                            FROM   SCP_PLAN_VERSION_V b

                            WHERE  division_id         IN (SELECT COLUMN_VALUE FROM String_Split(p_division_id, ','))

                            AND    plan_start_yyyymmdd  = p_plan_start_yyyymmdd

                            AND    plan_type            = v_plan_type

                           ) b

                ON  a.division_id          = b.division_id

                AND a.plan_start_yyyymmdd  = b.plan_start_yyyymmdd

                AND a.plan_type            = b.plan_type

                AND a.seq                  = b.plan_seq

                AND b.row_num              = 1

                AND a.operation_group      = v_operation_group



                INNER JOIN (SELECT division_id, plan_name, MAX(horizon_end_date) AS to_yyyymmdd

                            FROM   SCM_MST_PLAN

                            WHERE  division_id IN (SELECT COLUMN_VALUE FROM String_Split(p_division_id, ','))

                            AND    plan_name    = p_plan_start_yyyymmdd

                            GROUP BY division_id, plan_name

                           ) pl

                ON  a.division_id         = pl.division_id

                AND a.plan_start_yyyymmdd = pl.plan_name

                AND a.yyyymmdd           <= pl.to_yyyymmdd -- Plan 구간 내 정보



                INNER JOIN SCM_MST_BUCKET buc

                ON a.yyyymmdd             = buc.yyyymmdd



                INNER JOIN SCM_MST_SITE     S

                ON  S.DIVISION_ID = a.DIVISION_ID

                AND S.scm_site_id = a.scm_site_id

                AND S.PLANT_ID IN (SELECT COLUMN_VALUE FROM String_Split(p_plant_id, ','))



                LEFT OUTER JOIN SCM_MST_PLANT_SN P ON S.COMPANY_ID = P.COMPANY_ID AND S.DIVISION_ID = P.DIVISION_ID AND S.PLANT_ID = P.PLANT_ID

                LEFT OUTER JOIN SCM_MST_VENDOR   V ON V.VENDOR_CODE = S.PLANT_ID AND S.COMPANY_ID = V.COMPANY_ID

                LEFT OUTER JOIN SCM_MST_PLANT_SN SN ON S.DIVISION_ID = SN.DIVISION_ID AND S.PLANT_ID = SN.PLANT_ID



                LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME

                                    FROM SCM_MST_ITEM_SN

                                    WHERE 1=1

                                    AND NICK_NAME IS NOT NULL

                                    AND   ACTIVE_FLAG = 'Y'

                                    GROUP BY DIVISION_ID, ITEM_ID

                                ) item

                ON  a.division_id = item.division_id

                AND a.item_id     = item.item_id



                LEFT OUTER JOIN item_id_prod_info im

                ON  a.division_id = im.division_id

                AND a.item_id     = im.item_id_assy



            WHERE  1=1

            AND    a.measure              = v_measure --'PROD_PLAN_AMEND'

            AND    a.qty                 <> 0



            GROUP BY a.division_id, a.operation_group, s.plant_id-- a.scm_site_id

                 , CASE WHEN s.osp_yn = 'Y'        THEN CASE WHEN v.ATTRIBUTE1 IS NULL THEN (CASE WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE v.ATTRIBUTE1 END

                        WHEN s.osp_yn = 'N'        THEN CASE WHEN SN.DESCRIPTION IS NULL THEN (CASE WHEN s.operation_group = 'W' THEN s.plant_id WHEN P.PLANT_NAME IS NULL THEN V.VENDOR_NAME ELSE P.PLANT_NAME END) ELSE SN.DESCRIPTION END

                   END

                 , a.line_id

                 , im.item_id_prod, a.item_id, item.NICK_NAME

                 , a.measure, buc.yyyypw

        ) LOOP

            PIPE ROW (FN_DQ_PROD_PLAN_ROW(

                  r.division_id, r.operation_group, r.scm_site_id, r.plant_name, r.line_id

                , r.item_id_prod, r.item_id, r.nick_name, r.measure, r.yyyypw, r.qty));

        END LOOP;



    END IF; -- IF p_plan_start_yyyymmdd = 당주 월요일



   /*********************************************************

    -- 2.0 : 실적

    **********************************************************/

    FOR r IN (

        WITH item_id_prod_info AS (

            SELECT division_id, item_id_assy, item_id_prod, cp_priority

            FROM (

                  SELECT  m.division_id

                        , m.item_id_assy

                        , m.item_id_prod

                        , row_number() over (partition by m.division_id

                                                        , m.item_id_assy

                                             order by f.tco_cell_yn

                                                    , m.item_id_prod) as cp_priority

                    FROM SCP_MST_CELL_PROD_ASSY_MAP m

                         INNER JOIN scp_mst_final_item_v f

                                 ON f.item_id = m.item_id_prod

                    WHERE  1=1

                    AND    m.division_id IN (SELECT COLUMN_VALUE FROM String_Split(p_division_id, ','))

                    AND    m.valid_yn    = 'Y'

                 ) a

            WHERE 1=1

            AND   cp_priority = 1

        )

        ------------------------------------------------------------------------------------------------------------------

        -- PJ20257329 2025.08.01  Cell 완성 공정 하드 코딩 변경

        ------------------------------------------------------------------------------------------------------------------

        , scp_cell_final_operation AS (

            SELECT SEGMENT1 AS OPERATION_ID

              FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK

             WHERE 1=1

               AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'

               AND LK.SEGMENT3    = 'A'  -- 공정그룹 (Cell)

               AND LK.ATTRIBUTE1  = 'Y'  -- Final Operation

        )

        SELECT    A.DIVISION_ID                                   AS division_id

                , A.SCP_OPERATION_GROUP                           AS operation_group

                , A.PLANT_ID                                      AS scm_site_id

                , NVL(B.DESCRIPTION, B.PLANT_NAME)                AS plant_name

                , A.LINE_ID                                       AS line_id

                , im.item_id_prod                                 AS item_id_prod

                , a.item_id                                       AS item_id

                , item.NICK_NAME                                  AS nick_name

                , A.MEASURE                                       AS measure

                , SUBSTR(buc.yyyypw, 3, 2) || '_W' || SUBSTR(buc.yyyypw, 5, 2)

                  || CASE WHEN SUBSTR(buc.yyyypw, 7, 1) IS NULL THEN ''

                          ELSE '_' || SUBSTR(buc.yyyypw, 7, 1)

                     END                                          AS yyyypw

                , SUM(a.ACTUAL_GOOD_QTY) / 1000.0                 AS qty            -- K Cell 단위

        FROM (

                SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID

                        , A.OPERATION_ID, A.SCP_OPERATION_GROUP, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID

                        , A.PLAN_DATE, A.ITEM_ID, A.PRODUCTION_TYPE , A.MEASURE

                        , SUM(A.ACTUAL_GOOD_QTY) AS ACTUAL_GOOD_QTY

                FROM    (   -- 실적

                            SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID

                                    , A.LOCATION, A.OPERATION_ID, A.SCP_OPERATION_GROUP, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID

                                    , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD') AS PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID

                                    , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET, 'RESULT' AS PLAN_TYPE

                                    , A.ACTUAL_GOOD_QTY AS ACTUAL_GOOD_QTY

                                    , 'PLAN RESULT(OUT)' AS MEASURE

                            FROM    SCM_DNM_PRODUCT_RESULT_V A

                            --FROM  SCM_DNM_DAILY_PRODUCT_RESULT_SN A

                            WHERE   1=1

                            AND     A.division_id IN (SELECT COLUMN_VALUE FROM String_Split(p_division_id, ','))

                            AND     A.PLANT_ID    IN (SELECT COLUMN_VALUE FROM String_Split(p_plant_id, ','))

                            AND     A.PLAN_DATE BETWEEN TO_DATE(v_re_start_yyyymmdd, 'YYYYMMDD') AND TO_DATE(v_re_end_yyyymmdd, 'YYYYMMDD')

                            AND     A.OPERATION_ID IN (SELECT OPERATION_ID FROM scp_cell_final_operation ) -- PJ20257329 2025.08.01 Cell 완성 공정 하드 코딩 변경

                            -- PJ20257329 2025.08.01  변경전 AND  A.OPERATION_ID IN ('A3000', 'A9000') -- CELL 만

                            --AND   A.PRODUCTION_TYPE     NOT IN ('REWORK', 'PILOT') -- _SN 사용 시 조건 추가

                            AND     A.ACTUAL_GOOD_QTY > 0

                        ) A

                    WHERE 1=1

                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID

                              , A.OPERATION_ID, A.SCP_OPERATION_GROUP, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID

                              , A.PLAN_DATE, A.ITEM_ID, A.PRODUCTION_TYPE , A.MEASURE

            ) A

            LEFT OUTER JOIN SCM_MST_PLANT_SN B

            ON 1=1

            AND A.COMPANY_ID = B.COMPANY_ID

            AND A.DIVISION_ID = B.DIVISION_ID

            AND A.SITE_ID = B.SITE_ID

            AND A.PLANT_ID = B.PLANT_ID



            LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME

                                    FROM SCM_MST_ITEM_SN

                                    WHERE 1=1

                                    AND NICK_NAME IS NOT NULL

                                    AND   ACTIVE_FLAG = 'Y'

                                    GROUP BY DIVISION_ID, ITEM_ID

                            ) item

            ON  a.division_id = item.division_id

            AND a.item_id     = item.item_id



            INNER JOIN SCM_MST_BUCKET buc

            ON A.PLAN_DATE             = buc.yyyymmdd



            LEFT OUTER JOIN item_id_prod_info im

            ON  a.division_id = im.division_id

            AND a.item_id     = im.item_id_assy



        WHERE 1=1

        AND    a.ACTUAL_GOOD_QTY       <> 0



        GROUP BY A.DIVISION_ID, A.SCP_OPERATION_GROUP, A.PLANT_ID

            , NVL(B.DESCRIPTION, B.PLANT_NAME)

            , A.LINE_ID

            , im.item_id_prod, a.item_id, item.NICK_NAME

            , A.MEASURE, buc.yyyypw

    ) LOOP

        PIPE ROW (FN_DQ_PROD_PLAN_ROW(

              r.division_id, r.operation_group, r.scm_site_id, r.plant_name, r.line_id

            , r.item_id_prod, r.item_id, r.nick_name, r.measure, r.yyyypw, r.qty));

    END LOOP;



    RETURN;



END;
/

-- ===== FN_DQ_STOCK =====
CREATE OR REPLACE EDITIONABLE FUNCTION "SCM_MGR"."FN_DQ_STOCK" 
(
      p_cutoff_date         VARCHAR2
    , p_division_id         VARCHAR2
	, p_plant_site_id       VARCHAR2
)
RETURN FN_DQ_STOCK_TAB PIPELINED
AS
BEGIN
  FOR rec IN
  (
-------------------------------------------------
-- 1.0 재고
-------------------------------------------------
SELECT a.cutoff_date, a.division_id, a.scm_site_id, item.nick_name, s.operation_group
     , a.item_id
	 , a.factory_id
	 , a.operation_id, o.operation_name
	 , a.wiphold_yn
	 , item.item_uom
	 , a.scm_qty
     , CASE WHEN NVL(CAST(cf.cell_cf AS NUMBER(30,10)), 0.0) <> 0 THEN CAST(cf.cell_cf AS NUMBER(30,10))
            WHEN NVL(CAST(fi.cell_cf AS NUMBER(30,10)), 0.0) <> 0 THEN CAST(fi.cell_cf AS NUMBER(30,10))
            WHEN NVL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
            ELSE 1.0
       END cell_conversion
     ,(CASE WHEN NVL(CAST(cf.cell_cf AS NUMBER(30,10)), 0.0) <> 0 THEN CAST(cf.cell_cf AS NUMBER(30,10))
            WHEN NVL(CAST(fi.cell_cf AS NUMBER(30,10)), 0.0) <> 0 THEN CAST(fi.cell_cf AS NUMBER(30,10))
            WHEN NVL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
            ELSE 1.0
       END * a.scm_qty ) / 1000.0 AS kcell -- K Cell 단위
FROM scm_dnm_stock a

	LEFT OUTER JOIN SCM_MST_SITE     S ON S.DIVISION_ID = a.DIVISION_ID AND S.scm_site_id = a.scm_site_id
	--LEFT OUTER JOIN SCM_MST_PLANT_SN P WITH(NOLOCK) ON S.COMPANY_ID = P.COMPANY_ID AND S.DIVISION_ID = P.DIVISION_ID AND S.PLANT_ID = P.PLANT_ID
	--LEFT OUTER JOIN SCM_MST_VENDOR   V WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID AND S.COMPANY_ID = V.COMPANY_ID

	--LEFT OUTER JOIN SCM_MST_OPERATION_SN  O WITH(NOLOCK) ON O.DIVISION_ID = a.DIVISION_ID AND O.COMPANY_ID = a.COMPANY_ID AND O.OPERATION_ID = a.OPERATION_ID
	LEFT OUTER JOIN (SELECT DIVISION_ID, OPERATION_ID, MAX(OPERATION_NAME) AS OPERATION_NAME
                     FROM   SCM_MST_OPERATION_SN  O
					 WHERE  ACTIVE_FLAG = 'Y'
					 GROUP BY DIVISION_ID, OPERATION_ID
					) O
	ON  O.DIVISION_ID  = a.DIVISION_ID
	AND O.OPERATION_ID = a.OPERATION_ID

	LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME, MAX(ITEM_UOM) AS ITEM_UOM
							FROM SCM_MST_ITEM_SN
							WHERE 1=1
							AND NICK_NAME IS NOT NULL
							AND   ACTIVE_FLAG = 'Y'
							GROUP BY DIVISION_ID, ITEM_ID
					) item
	ON  a.division_id = item.division_id
	AND a.item_id     = item.item_id

	LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(CELL_ITEM_ID) AS CELL_ITEM_ID, MAX(CONVERT_QTY_CELL) AS CONVERT_QTY_CELL, MAX(CELL_CF) AS CELL_CF
							FROM SCP_MST_FINAL_ITEM
							WHERE 1=1
							GROUP BY DIVISION_ID, ITEM_ID
					) fi
	ON  a.division_id = fi.division_id
	AND a.item_id     = fi.item_id

	LEFT OUTER JOIN (SELECT distinct ITEM_ID, MAX(TARGET_CELL) AS TARGET_CELL, MAX(CELL_CF) AS CELL_CF
							FROM scp_mst_item_cell_cf
							WHERE 1=1
							GROUP BY ITEM_ID
					) cf
	ON  a.item_id     = cf.item_id

WHERE  1=1
AND    a.division_id    IN (SELECT COLUMN_VALUE FROM TABLE(String_Split(p_division_id, ','))) -- = @p_division_id
AND    a.cutoff_date    = p_cutoff_date
AND    a.scm_site_id    IN (SELECT COLUMN_VALUE FROM TABLE(String_Split(p_plant_site_id, ','))) -- = @p_plant_site_id
AND    a.qty           <> 0
-- 전극재고/조립재공 Item 만 : 처음 3자리('APC','ABC','AFC','AHC','AMC','ANP','ASC','AZC')인 코드만 조회
AND    SUBSTR(a.item_id, 1, 3) IN ('APC','ABC','AFC','AHC','AMC','ANP','ASC','AZC')

-------------------------------------------------
-- 2.0 해상재고
-------------------------------------------------
UNION ALL
SELECT a.result_date AS cutoff_date, a.division_id, a.to_scm_site_id AS scm_site_id, item.nick_name, fi.operation_group
     , a.item_id
	 , '-' AS factory_id
	 , 'Intransit' AS operation_id, 'Intransit' AS operation_name
	 , 'N' AS wiphold_yn
	 , item.item_uom
	 , a.delivery_qty AS scm_qty
     , CASE WHEN NVL(CAST(cf.cell_cf AS NUMBER(30,10)), 0.0) <> 0 THEN CAST(cf.cell_cf AS NUMBER(30,10))
            WHEN NVL(CAST(fi.cell_cf AS NUMBER(30,10)), 0.0) <> 0 THEN CAST(fi.cell_cf AS NUMBER(30,10))
            WHEN NVL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
            ELSE 1.0
       END cell_conversion
     ,(CASE WHEN NVL(CAST(cf.cell_cf AS NUMBER(30,10)), 0.0) <> 0 THEN CAST(cf.cell_cf AS NUMBER(30,10))
            WHEN NVL(CAST(fi.cell_cf AS NUMBER(30,10)), 0.0) <> 0 THEN CAST(fi.cell_cf AS NUMBER(30,10))
            WHEN NVL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
            ELSE 1.0
       END * a.delivery_qty ) / 1000.0 AS kcell -- K Cell 단위
FROM scm_dnm_intransit_c a

	LEFT OUTER JOIN SCM_MST_SITE     S ON S.DIVISION_ID = a.DIVISION_ID AND S.scm_site_id = a.to_scm_site_id

	LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME, MAX(ITEM_UOM) AS ITEM_UOM
							FROM SCM_MST_ITEM_SN
							WHERE 1=1
							AND NICK_NAME IS NOT NULL
							AND   ACTIVE_FLAG = 'Y'
							GROUP BY DIVISION_ID, ITEM_ID
					) item
	ON  a.division_id = item.division_id
	AND a.item_id     = item.item_id

	LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID
                                   , MAX(CELL_ITEM_ID) AS CELL_ITEM_ID, MAX(CONVERT_QTY_CELL) AS CONVERT_QTY_CELL, MAX(CELL_CF) AS CELL_CF
                                   , MAX(OPERATION_GROUP) AS OPERATION_GROUP
							FROM SCP_MST_FINAL_ITEM
							WHERE 1=1
							GROUP BY DIVISION_ID, ITEM_ID
					) fi
	ON  a.division_id = fi.division_id
	AND a.item_id     = fi.item_id

	LEFT OUTER JOIN (SELECT distinct ITEM_ID, MAX(TARGET_CELL) AS TARGET_CELL, MAX(CELL_CF) AS CELL_CF
							FROM scp_mst_item_cell_cf
							WHERE 1=1
							GROUP BY ITEM_ID
					) cf
	ON  a.item_id     = cf.item_id

WHERE  1=1
AND    a.division_id    IN (SELECT COLUMN_VALUE FROM TABLE(String_Split(p_division_id, ','))) -- = @p_division_id
AND    a.result_date    = p_cutoff_date
AND    a.to_scm_site_id IN (SELECT COLUMN_VALUE FROM TABLE(String_Split(p_plant_site_id, ','))) -- = @p_plant_site_id
AND    a.delivery_qty   <> 0
AND    a.result_type in ('C', 'I')
-- 전극재고/조립재공 Item 만 : 처음 3자리('APC','ABC','AFC','AHC','AMC','ANP','ASC','AZC')인 코드만 조회
AND    SUBSTR(a.item_id, 1, 3) IN ('APC','ABC','AFC','AHC','AMC','ANP','ASC','AZC')
  )
  LOOP
    PIPE ROW( FN_DQ_STOCK_ROW(
        rec.cutoff_date, rec.division_id, rec.scm_site_id, rec.nick_name, rec.operation_group,
        rec.item_id, rec.factory_id, rec.operation_id, rec.operation_name, rec.wiphold_yn,
        rec.item_uom, rec.scm_qty, rec.cell_conversion, rec.kcell ) );
  END LOOP;
  RETURN;
END;
/
