-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SCP0020 — 원복(사내 적용 전 원문)
CREATE OR REPLACE PACKAGE BODY PKG_SCP0020 IS

  -- ============================================================================
  -- GET TACT TIME (Plant) — AS-IS SCP0020_GET_TACT_TIME.
  --   FCST item(#TMP) = MKT_FCST 존재 모델 -> CTE FCST 로 인라인. 전극(E)은 FCST 무관 포함.
  -- * 2026.10.07   AJS          조회 속도 개선 : FCST 판정 앞 필요조건 사전 확인, 라인 활성 확인 구동 순서 힌트, 사이트명 함수 결과 재사용
  -- * 2026.10.07   AJS          조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
  -- * 2026.10.08   AJS          조회조건 Model/Nickname : 후보 품목 비교를 MEMBER OF 에서 IN (TABLE()) 로 변경(결과 동일·속도)
  -- ============================================================================
  PROCEDURE P_SCP0020_GET_TACT_TIME(
    P_DIVISION_ID IN VARCHAR2, P_PLANT_SITE_ID IN VARCHAR2, P_LINE_ID IN VARCHAR2,
    P_OPERATION_GROUP_ID IN VARCHAR2, P_ITEM_ID IN VARCHAR2, P_VALID IN VARCHAR2,
    P_USER_ID IN VARCHAR2, P_MENU_ID IN VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
    V_FROM VARCHAR2(8) := TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');
    V_TO   VARCHAR2(8) := TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') + 7*51, 'YYYYMMDD');
    V_ITEM_TAB T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
  BEGIN
    /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력 토큰(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
       조회 문장 안에서 분리 함수를 행마다 부르면 느려지므로 문장 밖에서 한 번 판정 · 대상 품목 = 조회 결과가 나오는 두 원장의 품목 */
    IF P_ITEM_ID IS NOT NULL AND P_ITEM_ID <> 'ALL' THEN
      SELECT DISTINCT IA.ITEM_ID
        BULK COLLECT INTO V_ITEM_TAB
        FROM (SELECT ITEM_ID
                FROM SCP_MST_TACT_TIME
               WHERE DIVISION_ID = P_DIVISION_ID
              UNION
              SELECT ITEM_ID
                FROM SCM_MST_SITE_ITEM_PRIORITY
               WHERE DIVISION_ID = P_DIVISION_ID) IA
           , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
       WHERE SA.COLUMN_VALUE IS NOT NULL
         AND (   UPPER(IA.ITEM_ID) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'
              OR EXISTS (SELECT 1
                           FROM SCM_MST_ITEM_SN XA
                          WHERE XA.ITEM_ID     = IA.ITEM_ID
                            AND XA.DIVISION_ID = P_DIVISION_ID
                            AND UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'));
    END IF;
    /* 2026.10.07 AJS Model/Nickname 검색 (END) */
    OPEN O_RC1 FOR
      WITH FCST_TMP1 AS (
        SELECT DISTINCT aa.division_id, B.child_item_id AS item_id
        FROM dm_pln_mkt_fcst aa
        JOIN scm_mst_site mse
          ON mse.valid_yn = 'Y'
         AND aa.measure = CASE WHEN mse.operation_group = 'W' THEN 'AS_In_Req'
                               WHEN mse.vmi_yn = 'Y' THEN 'VMI_In_Req'
                               -- 2026.09.18 ATTRIBUTE10 이관 공백(' ') = AS-IS '' (START)
--                             WHEN aa.attribute10 IS NULL THEN 'MKT_FCST' END
                               WHEN TRIM(aa.attribute10) IS NULL THEN 'MKT_FCST' END
                               -- 2026.09.18 ATTRIBUTE10 이관 공백(' ') = AS-IS '' (END)
         AND aa.scm_site_id = mse.scm_site_id
         AND aa.division_id = mse.division_id
        JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V B
          ON aa.division_id = B.division_id AND aa.item_id = B.model_id
        WHERE aa.yyyymmdd >= V_FROM
          AND aa.yyyymmdd <= V_TO
          AND aa.qty > 0
          AND aa.division_id = P_DIVISION_ID
--        AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || P_ITEM_ID || ',', ',' || B.child_item_id || ',') > 0)
--        AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || UPPER(P_ITEM_ID) || ',', ',' || B.child_item_id || ',') > 0)   --  2026.10.07 AJS
          /* AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR B.child_item_id MEMBER OF V_ITEM_TAB)   --  2026.10.07 AJS */
          AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR B.child_item_id IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
      ),
      FCST AS (
        SELECT DISTINCT aa.division_id, aa.item_id
        FROM FCST_TMP1 aa
        JOIN SCP_MST_FINAL_ITEM T ON aa.division_id = T.division_id AND aa.item_id = T.item_id
--      WHERE (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || P_ITEM_ID || ',', ',' || aa.item_id || ',') > 0)
--      WHERE (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || UPPER(P_ITEM_ID) || ',', ',' || aa.item_id || ',') > 0)   --  2026.10.07 AJS
        /* WHERE (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR aa.item_id MEMBER OF V_ITEM_TAB)   --  2026.10.07 AJS */
        WHERE (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR aa.item_id IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
      )
      SELECT m.division_id, m.plant_site_id,
--             FN_GET_SCM_SITE_DESCRIPTION(m.division_id, m.plant_site_id) AS plant_site_name,
             (SELECT FN_GET_SCM_SITE_DESCRIPTION(m.division_id, m.plant_site_id) FROM DUAL) AS plant_site_name,    --  2026.10.07 AJS
             m.operation_group_id, m.operation_id, m.operation_id AS operation_name, m.model_site,
             m.item_id, NVL(m.nick_name, '-') AS nick_name, m.line_id, m.input_status, m.priority,
             m.valid_yn, m.yield AS yield, m.daily_capacity, m.item_uom, m.uom_convert_value, m.tact_time,
             n.tact_time AS big_tact_time, n.actual_output, n.actual_capacity, n.from_actual_capacity,
             n.to_actual_capacity, n.effective_data_count, n.last_update_date AS big_last_update_date,
             m.BOM_MIN_DUE_DATE, m.created_by, m.creation_date, m.last_updated_by, m.last_update_date,
             (CASE WHEN m.line_id IS NULL THEN '1' ELSE '2' END) AS line_order, m.except_yn,
             (CASE WHEN m.operation_group_id = 'E' THEN m.LANE_QTY ELSE NULL END) AS LANE_QTY,
             (CASE WHEN m.operation_group_id = 'E' AND m.tact_time IS NOT NULL AND m.LANE_QTY IS NOT NULL
                   THEN m.tact_time * TO_NUMBER(m.LANE_QTY) * 60 ELSE NULL END) AS JUMBO_MIN
      FROM (
            -- Tact Time Master 조회
            SELECT DISTINCT
                   a.division_id, a.plant_site_id,
                   fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id,
                   a.operation_id, i.site_id AS model_site, a.item_id, i.nick_name, a.line_id, a.priority,
                   a.tact_time, ROUND(a.yield * 100, 2) AS yield,
                   -- 2026.09.18 AS-IS 소수 자릿수(나눗셈 18자리 · 곱셈 7자리 반올림) (START)
--                 ((1440 - NVL(d.loss_time_min, 0) - NVL(d.setup_loss_time_min, 0)) * 60 / a.tact_time)
--                   * NVL(a.uom_convert_value, 1) AS daily_capacity,
                   ROUND(ROUND((1440 - NVL(d.loss_time_min, 0) - NVL(d.setup_loss_time_min, 0)) * 60 / a.tact_time, 18)
                     * NVL(a.uom_convert_value, 1), 7) AS daily_capacity,
                   -- 2026.09.18 AS-IS 소수 자릿수 (END)
                   a.item_uom, a.uom_convert_value, a.valid_yn, NULL AS BOM_MIN_DUE_DATE,
                   a.created_by, a.creation_date, a.last_updated_by, a.last_update_date, 'M' AS input_status,
                   NVL((SELECT 'Y' FROM SCP_MST_TACT_TIME_EXCEPT x
                         INNER JOIN (SELECT DISTINCT b.segment4, b.segment1
                                       FROM scm_adm_lookup_master_detail b
                                      WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                        AND b.valid_yn = 'Y' AND b.segment3 = 'Y') c
                                 ON a.operation_id = c.segment4
                        WHERE x.division_id = a.division_id AND x.plant_site_id = a.plant_site_id
                          AND x.operation_id = a.operation_id AND x.item_id = a.item_id
                          AND x.line_id = a.line_id AND ROWNUM = 1), 'N') AS except_yn,
                   NVL((SELECT COUNT(LS.ACTIVE_FLAG) FROM SCM_MST_LINE_SN LS
                         WHERE LS.COMPANY_ID = B.COMPANY_ID AND LS.DIVISION_ID = A.DIVISION_ID
                           AND LS.SITE_ID = B.SITE_ID AND LS.PLANT_ID = B.PLANT_ID
                           AND LS.OPERATION_ID = A.OPERATION_ID AND LS.LINE_ID = A.LINE_ID
                           AND LS.ACTIVE_FLAG = 'Y'), 0) AS ACTIVE_CNT,
                   a.attribute1 AS LANE_QTY
            FROM scp_mst_tact_time a
            LEFT OUTER JOIN scm_mst_item_sn i
              ON a.division_id = i.division_id AND a.item_id = i.item_id
             AND i.site_id = (SELECT site_id FROM scm_mst_plant_sn s
                               WHERE s.division_id = a.division_id
                                 AND s.plant_id = fn_scm_split(a.plant_site_id, 1, '-'))
            JOIN scm_mst_site b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id
            LEFT OUTER JOIN scp_mst_loss_time d
              ON a.division_id = d.division_id AND a.plant_site_id = d.plant_site_id
             AND a.operation_id = d.operation_id AND a.line_id = d.line_id
            WHERE 1 = 1
              AND b.osp_yn = 'N'
              AND a.operation_id <> 'P5000'
              AND a.division_id = P_DIVISION_ID
              AND (P_PLANT_SITE_ID = 'ALL' OR P_PLANT_SITE_ID IS NULL OR INSTR(',' || P_PLANT_SITE_ID || ',', ',' || a.plant_site_id || ',') > 0)
--            AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || P_ITEM_ID || ',', ',' || a.item_id || ',') > 0)
--            AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || UPPER(P_ITEM_ID) || ',', ',' || a.item_id || ',') > 0)   --  2026.10.07 AJS
              /* AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR a.item_id MEMBER OF V_ITEM_TAB)   --  2026.10.07 AJS */
              AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR a.item_id IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */

            UNION ALL
            -- Project Route 등록 모델 중 Tact Time Master 에 없는 모델
            SELECT DISTINCT
                   a.division_id, a.plant_site_id,
                   fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id,
                   (SELECT SUBSTR(X.scp_flow_id, 1, 5) FROM scm_mst_item_sn X
                     WHERE X.division_id = A.division_id AND X.item_id = A.item_id AND ROWNUM = 1) AS operation_id,
                   i.site_id AS model_site, a.item_id, i.nick_name, NULL AS line_id, NULL AS priority,
                   NULL AS tact_time, NULL AS yield, NULL AS daily_capacity, NULL AS item_uom,
                   NULL AS uom_convert_value, 'Y' AS valid_yn,
                   TO_CHAR(C.MIN_DUE_DATE, 'YYYY-MM-DD') AS BOM_MIN_DUE_DATE,
                   NULL AS created_by, NULL AS creation_date, NULL AS last_updated_by, NULL AS last_update_date,
                   'I' AS input_status, NULL AS except_yn, 1 AS ACTIVE_CNT, NULL AS LANE_QTY
            FROM scm_mst_site_item_priority a
            LEFT OUTER JOIN scm_mst_item_sn i
              ON a.division_id = i.division_id AND a.item_id = i.item_id
             AND i.site_id = (SELECT site_id FROM scm_mst_plant_sn s
                               WHERE s.division_id = a.division_id
                                 AND s.plant_id = fn_scm_split(a.plant_site_id, 1, '-'))
            JOIN SCM_MST_SITE b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id
            LEFT JOIN scp_mst_final_item C
              ON a.division_id = C.division_id AND a.item_id = C.item_id AND C.fcst_yn = UPPER('Y')
            WHERE 1 = 1
              AND a.valid_yn = 'Y'
              AND b.osp_yn = 'N'
--              AND NOT EXISTS (SELECT 'X' FROM scp_mst_tact_time n
              AND NOT EXISTS (SELECT /*+ LEADING(N LS) USE_NL(LS) */ 'X' FROM scp_mst_tact_time n    --  2026.10.07 AJS
                               JOIN SCM_MST_LINE_SN LS
                                 ON LS.COMPANY_ID = B.COMPANY_ID AND LS.DIVISION_ID = N.DIVISION_ID
                                AND LS.SITE_ID = B.SITE_ID AND LS.PLANT_ID = B.PLANT_ID
                                AND LS.OPERATION_ID = N.OPERATION_ID AND LS.LINE_ID = N.LINE_ID
                                AND LS.ACTIVE_FLAG = 'Y'
                              WHERE n.division_id = a.division_id AND n.plant_site_id = a.plant_site_id
                                AND n.item_id = a.item_id)
-- 2026.10.07 AJS 속도 개선 - FCST 판정(공용 BOM 뷰 · MKT FCST 품목별 전개) 앞에 BOM 원장 · MKT FCST 인덱스로 필요조건을 먼저 확인 (START)
--              AND EXISTS (SELECT 'X' FROM FCST F WHERE F.DIVISION_ID = A.DIVISION_ID AND F.ITEM_ID = A.ITEM_ID)
              AND CASE WHEN EXISTS (SELECT 1
                                      FROM SCM_MST_BOM_SN_V XM
                                         , DM_PLN_MKT_FCST XF
                                     WHERE XF.DIVISION_ID   = XM.DIVISION_ID
                                       AND XF.ITEM_ID       = XM.MODEL_ID
                                       AND XM.DIVISION_ID   = A.DIVISION_ID
                                       AND XM.CHILD_ITEM_ID = A.ITEM_ID
                                       AND XM.ALT_PRIORITY  = 'Y'
                                       AND XF.QTY           > 0
                                       AND XF.YYYYMMDD     >= V_FROM
                                       AND XF.YYYYMMDD     <= V_TO)     /* 사전 확인 : 이 품목을 하위로 둔 모델에 기간 내 MKT FCST 가 있는가 (아래 FCST 판정의 필요조건) */
                       THEN CASE WHEN EXISTS (SELECT 'X' FROM FCST F WHERE F.DIVISION_ID = A.DIVISION_ID AND F.ITEM_ID = A.ITEM_ID) THEN 1
                            END
                  END = 1
-- 2026.10.07 AJS 속도 개선 (END)
              AND a.division_id = P_DIVISION_ID
              AND (P_PLANT_SITE_ID = 'ALL' OR P_PLANT_SITE_ID IS NULL OR INSTR(',' || P_PLANT_SITE_ID || ',', ',' || a.plant_site_id || ',') > 0)
--            AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || P_ITEM_ID || ',', ',' || a.item_id || ',') > 0)
--            AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || UPPER(P_ITEM_ID) || ',', ',' || a.item_id || ',') > 0)   --  2026.10.07 AJS
              /* AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR a.item_id MEMBER OF V_ITEM_TAB)   --  2026.10.07 AJS */
              AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR a.item_id IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
           ) m
      LEFT OUTER JOIN scp_mst_tact_time_big n
             ON m.division_id = n.division_id AND m.plant_site_id = n.plant_site_id
            AND m.item_id = n.item_id AND m.operation_id = n.operation_id AND m.line_id = n.line_id
            AND TO_CHAR(n.last_update_date, 'YYYYMMDD') >= '20181101'
      WHERE 1 = 1
        AND m.division_id = P_DIVISION_ID
        AND m.operation_group_id = P_OPERATION_GROUP_ID
        AND (P_VALID = 'ALL' OR P_VALID IS NULL OR INSTR(',' || P_VALID || ',', ',' || m.valid_yn || ',') > 0)
        AND (P_LINE_ID = 'ALL' OR P_LINE_ID IS NULL OR INSTR(',' || P_LINE_ID || ',', ',' || m.line_id || ',') > 0)
        AND SUBSTR(m.item_id, 2, 1) = CASE WHEN m.operation_group_id = 'A' THEN 'C' ELSE SUBSTR(m.item_id, 2, 1) END
        AND m.ACTIVE_CNT > 0
      ORDER BY line_order, m.division_id, m.plant_site_id, m.operation_id, m.line_id, m.model_site, m.item_id;

    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
  END P_SCP0020_GET_TACT_TIME;

  -- ============================================================================
  -- GET TACT TIME OSP (Packer) — AS-IS SCP0020_GET_TACT_TIME_OSP.
  --   @v_end_monday = scm_mst_plan WEEKLY horizon. FCST(#TMP) = BOM_SN_V + OPMZ demand-group 매핑.
  -- * 2026.10.07   AJS          조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
  -- * 2026.10.08   AJS          조회조건 Model/Nickname : 후보 품목 비교를 MEMBER OF 에서 IN (TABLE()) 로 변경(결과 동일·속도)
  -- ============================================================================
  PROCEDURE P_SCP0020_GET_TACT_TIME_OSP(
    P_DIVISION_ID IN VARCHAR2, P_PLANT_SITE_ID IN VARCHAR2, P_LINE_ID IN VARCHAR2,
    P_OPERATION_GROUP_ID IN VARCHAR2, P_ITEM_ID IN VARCHAR2,
    P_USER_ID IN VARCHAR2, P_MENU_ID IN VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
    V_CUR_MONDAY VARCHAR2(8) := TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');
    V_END_MONDAY VARCHAR2(8);
    V_ITEM_TAB T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
  BEGIN
    /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력 토큰(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
       조회 문장 안에서 분리 함수를 행마다 부르면 느려지므로 문장 밖에서 한 번 판정 · 대상 품목 = 조회 결과가 나오는 두 원장의 품목 */
    IF P_ITEM_ID IS NOT NULL AND P_ITEM_ID <> 'ALL' THEN
      SELECT DISTINCT IA.ITEM_ID
        BULK COLLECT INTO V_ITEM_TAB
        FROM (SELECT ITEM_ID
                FROM SCP_MST_TACT_TIME_OSP
               WHERE DIVISION_ID = P_DIVISION_ID
              UNION
              SELECT ITEM_ID
                FROM SCM_MST_SITE_ITEM_PRIORITY
               WHERE DIVISION_ID = P_DIVISION_ID) IA
           , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
       WHERE SA.COLUMN_VALUE IS NOT NULL
         AND (   UPPER(IA.ITEM_ID) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'
              OR EXISTS (SELECT 1
                           FROM SCM_MST_ITEM_SN XA
                          WHERE XA.ITEM_ID     = IA.ITEM_ID
                            AND UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'));
    END IF;
    /* 2026.10.07 AJS Model/Nickname 검색 (END) */
    BEGIN
      SELECT MAX(horizon_end_date) INTO V_END_MONDAY
      FROM scm_mst_plan p
      WHERE p.plan_cycle = 'WEEKLY' AND p.plan_name = V_CUR_MONDAY;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_END_MONDAY := NULL;
    END;

    OPEN O_RC1 FOR
      WITH TMP1_BASE AS (
--      -- BOM_SN_V 기반 대상 (E20260310-000552 신규로직)
--      SELECT A.DIVISION_ID, B.CHILD_ITEM_ID AS ITEM_ID, A.PROJECT_CODE
--      FROM (
--            SELECT DISTINCT aa.division_id, aa.item_id, aa.project_code
--            FROM DM_PLN_MKT_FCST aa
--            JOIN SCM_MST_SITE mse
--              ON mse.valid_yn = 'Y'
--             AND aa.measure = CASE WHEN mse.operation_group = 'W' THEN 'AS_In_Req'
--                                   WHEN mse.vmi_yn = 'Y' THEN 'VMI_In_Req'
--                                   WHEN aa.attribute10 IS NULL THEN 'MKT_FCST' END
--             AND aa.scm_site_id = mse.scm_site_id AND aa.division_id = mse.division_id
--            WHERE aa.yyyymmdd >= V_CUR_MONDAY AND aa.yyyymmdd <= V_END_MONDAY
--              AND aa.qty > 0 AND aa.division_id = P_DIVISION_ID
--           ) a
--      JOIN (
--            SELECT b.division_id, b.model_id, b.child_item_id
--            FROM (SELECT x.*
--                    FROM scm_mst_bom_sn_V x
--                    INNER JOIN scm_mst_item_sn i
--                      ON x.child_division_id = i.division_id AND x.child_item_id = i.item_id
--                     AND x.child_company_id = i.company_id AND x.child_site_id = i.site_id
--                     AND i.active_flag = 'Y') b,
--                 scm_mst_final_item_v v, scm_mst_item_sn mi
--            WHERE b.division_id = v.division_id AND b.child_item_id = v.item_id
--              AND b.division_id = mi.division_id AND b.model_id = mi.item_id
--              AND b.company_id = mi.company_id AND b.site_id = mi.site_id AND mi.active_flag = 'Y'
--            GROUP BY b.division_id, b.model_id, b.child_item_id
--           ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.MODEL_ID
        -- 2026.09.18 운영 E20260907-000168 반영 — 모델이 수요그룹 룩업(SEGMENT3·SEGMENT5)에 있으면 모델 자체를 대상에 포함, ATTRIBUTE10 이관 공백 (START)
        SELECT IA.DIVISION_ID, IA.CHILD_ITEM_ID AS ITEM_ID, IA.PROJECT_CODE
          FROM (
                SELECT DISTINCT
                       A.DIVISION_ID
                     , CASE WHEN B.CHILD_ITEM_ID IS NOT NULL THEN B.CHILD_ITEM_ID
                            WHEN EXISTS (SELECT 1
                                           FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LMD
                                          WHERE LMD.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                            AND LMD.VALID_YN    = 'Y'
                                            AND LMD.SEGMENT3    = A.ITEM_ID
                                            AND LMD.SEGMENT5    = A.PROJECT_CODE) THEN A.ITEM_ID
                            ELSE NULL END AS CHILD_ITEM_ID
                     , A.PROJECT_CODE
                  FROM (
                        SELECT DISTINCT aa.division_id, aa.item_id, aa.project_code
                        FROM DM_PLN_MKT_FCST aa
                        JOIN SCM_MST_SITE mse
                          ON mse.valid_yn = 'Y'
                         AND aa.measure = CASE WHEN mse.operation_group = 'W' THEN 'AS_In_Req'
                                               WHEN mse.vmi_yn = 'Y' THEN 'VMI_In_Req'
                                               WHEN TRIM(aa.attribute10) IS NULL THEN 'MKT_FCST' END
                         AND aa.scm_site_id = mse.scm_site_id AND aa.division_id = mse.division_id
                        WHERE aa.yyyymmdd >= V_CUR_MONDAY AND aa.yyyymmdd <= V_END_MONDAY
                          AND aa.qty > 0 AND aa.division_id = P_DIVISION_ID
                       ) A
                     , (
                        SELECT b.division_id, b.model_id, b.child_item_id
                        FROM (SELECT x.*
                                FROM scm_mst_bom_sn_V x
                                INNER JOIN scm_mst_item_sn i
                                  ON x.child_division_id = i.division_id AND x.child_item_id = i.item_id
                                 AND x.child_company_id = i.company_id AND x.child_site_id = i.site_id
                                 AND i.active_flag = 'Y') b,
                             scm_mst_final_item_v v, scm_mst_item_sn mi
                        WHERE b.division_id = v.division_id AND b.child_item_id = v.item_id
                          AND b.division_id = mi.division_id AND b.model_id = mi.item_id
                          AND b.company_id = mi.company_id AND b.site_id = mi.site_id AND mi.active_flag = 'Y'
                        GROUP BY b.division_id, b.model_id, b.child_item_id
                       ) B
                 WHERE A.DIVISION_ID = B.DIVISION_ID(+)
                   AND A.ITEM_ID     = B.MODEL_ID(+)
               ) IA
         WHERE IA.CHILD_ITEM_ID IS NOT NULL
        -- 2026.09.18 운영 E20260907-000168 반영 (END)
      ),
      TMP1 AS (
        SELECT DIVISION_ID, ITEM_ID, PROJECT_CODE FROM TMP1_BASE
        UNION ALL
        -- E20260728-000548 DEMAND GROUP MASTER 룩업 + PROJECT_CODE + ITEM 앞12자리 동일 추가매핑
        -- 주의: SCP_OPMZ_LOOKUP_MASTER_DETAIL '' -> '-' 센티널 이관. SEGMENT2/3/5 는 실값 매칭이라 영향 없음.
        SELECT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS ITEM_ID, A.SEGMENT5 AS PROJECT_CODE
        FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
        WHERE A.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP' AND A.VALID_YN = 'Y'
          AND EXISTS (SELECT 1 FROM TMP1_BASE B
                       WHERE A.SEGMENT2 = B.DIVISION_ID
                         AND SUBSTR(A.SEGMENT3, 1, 12) = SUBSTR(B.ITEM_ID, 1, 12)
                         AND A.SEGMENT5 = B.PROJECT_CODE AND A.SEGMENT3 <> B.ITEM_ID)
      ),
      FCST AS (
        SELECT DISTINCT aa.division_id, aa.item_id
        FROM TMP1 aa
        JOIN SCP_MST_FINAL_ITEM T ON aa.division_id = T.division_id AND aa.item_id = T.item_id
--      WHERE (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || P_ITEM_ID || ',', ',' || aa.item_id || ',') > 0)
--      WHERE (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || UPPER(P_ITEM_ID) || ',', ',' || aa.item_id || ',') > 0)   --  2026.10.07 AJS
        /* WHERE (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR aa.item_id MEMBER OF V_ITEM_TAB)   --  2026.10.07 AJS */
        WHERE (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR aa.item_id IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
      )
      SELECT A.DIVISION_ID, A.SITE_DESCRIPTION, A.ITEM_ID, A.NICK_NAME, A.LINE_ID, A.PRIORITY, A.YIELD,
             A.DAILY_CAPACITY, A.TACT_TIME, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY,
             A.LAST_UPDATE_DATE, A.OPERATION_ID, A.PLANT_SITE_ID, A.INPUT_STATUS, A.operation_group_id,
             (CASE WHEN A.line_id IS NULL THEN '1' ELSE '2' END) AS line_order, A.except_yn, A.OSP_YN
      FROM (
            -- Tact Time OSP Master 조회
            SELECT A.DIVISION_ID, S.SITE_DESCRIPTION, A.ITEM_ID,
                   (SELECT NVL(MAX(X.NICK_NAME), '-') FROM SCM_MST_ITEM_SN X WHERE X.ITEM_ID = A.ITEM_ID) AS NICK_NAME,
                   A.LINE_ID, A.PRIORITY, ROUND(A.YIELD * 100, 2) AS YIELD, A.DAILY_CAPACITY, A.TACT_TIME,
                   A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.OPERATION_ID,
                   A.PLANT_SITE_ID, 'M' AS INPUT_STATUS,
                   fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id,
                   NVL((SELECT 'Y' FROM SCP_MST_TACT_TIME_EXCEPT_OSP x
                         WHERE x.division_id = a.division_id AND x.plant_site_id = a.plant_site_id
                           AND x.operation_id = a.operation_id AND x.item_id = a.item_id
                           AND x.line_id = a.line_id AND ROWNUM = 1), 'N') AS except_yn,
                   S.OSP_YN
            FROM SCP_MST_TACT_TIME_OSP A
            JOIN SCM_MST_SITE S ON S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.PLANT_SITE_ID
            WHERE 1 = 1 AND a.division_id = P_DIVISION_ID
              AND (P_PLANT_SITE_ID = 'ALL' OR P_PLANT_SITE_ID IS NULL OR INSTR(',' || P_PLANT_SITE_ID || ',', ',' || a.plant_site_id || ',') > 0)
--            AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || P_ITEM_ID || ',', ',' || a.item_id || ',') > 0)
--            AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || UPPER(P_ITEM_ID) || ',', ',' || a.item_id || ',') > 0)   --  2026.10.07 AJS
              /* AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR a.item_id MEMBER OF V_ITEM_TAB)   --  2026.10.07 AJS */
              AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR a.item_id IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
            UNION ALL
            -- Project Route 등록 모델 중 Master 에 없는 모델
            SELECT DISTINCT a.division_id, b.SITE_DESCRIPTION, a.ITEM_ID,
                   (SELECT NVL(MAX(X.NICK_NAME), '-') FROM SCM_MST_ITEM_SN X WHERE X.ITEM_ID = A.ITEM_ID) AS NICK_NAME,
                   NULL AS LINE_ID, NULL AS PRIORITY, NULL AS YIELD, NULL AS DAILY_CAPACITY, NULL AS TACT_TIME,
                   NULL AS CREATED_BY, NULL AS CREATION_DATE, NULL AS LAST_UPDATED_BY, NULL AS LAST_UPDATE_DATE,
                   CASE WHEN NVL(C.ATTRIBUTE3, 'N') = 'Y' THEN B.PLANT_ID || '_R1' ELSE B.PLANT_ID END AS OPERATION_ID,
                   A.PLANT_SITE_ID, 'I' AS INPUT_STATUS,
                   fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id,
                   'N' AS except_yn, B.OSP_YN
            FROM scm_mst_site_item_priority a
            LEFT OUTER JOIN scm_mst_item_sn i
              ON a.division_id = i.division_id AND a.item_id = i.item_id
             AND i.site_id = (SELECT site_id FROM scm_mst_plant_sn s
                               WHERE s.division_id = a.division_id
                                 AND s.plant_id = fn_scm_split(a.plant_site_id, 1, '-'))
            JOIN SCM_MST_SITE b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id
            LEFT JOIN scp_mst_final_item C ON a.division_id = C.division_id AND a.item_id = C.item_id
            WHERE 1 = 1 AND a.valid_yn = 'Y' AND b.osp_yn = 'Y' AND NVL(b.ATTRIBUTE1, 'N') = 'Y'
              AND NOT EXISTS (SELECT 'X' FROM SCP_MST_TACT_TIME_OSP n
                               WHERE n.division_id = a.division_id AND n.plant_site_id = a.plant_site_id
                                 AND n.item_id = a.item_id)
              AND EXISTS (SELECT 'X' FROM FCST F WHERE F.DIVISION_ID = A.DIVISION_ID AND F.ITEM_ID = A.ITEM_ID)
              AND a.division_id = P_DIVISION_ID
              AND (P_PLANT_SITE_ID = 'ALL' OR P_PLANT_SITE_ID IS NULL OR INSTR(',' || P_PLANT_SITE_ID || ',', ',' || a.plant_site_id || ',') > 0)
--            AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || P_ITEM_ID || ',', ',' || a.item_id || ',') > 0)
--            AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR INSTR(',' || UPPER(P_ITEM_ID) || ',', ',' || a.item_id || ',') > 0)   --  2026.10.07 AJS
              /* AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR a.item_id MEMBER OF V_ITEM_TAB)   --  2026.10.07 AJS */
              AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL OR a.item_id IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
           ) A
      WHERE 1 = 1
        AND A.operation_group_id = P_OPERATION_GROUP_ID
        AND (P_LINE_ID = 'ALL' OR P_LINE_ID IS NULL OR INSTR(',' || P_LINE_ID || ',', ',' || A.line_id || ',') > 0)
      ORDER BY line_order, A.division_id, A.plant_site_id, A.line_id, A.item_id;

    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
  END P_SCP0020_GET_TACT_TIME_OSP;

  -- ============================================================================
  -- GET TACT TIME EXCEPT (Plant 부모) — AS-IS SCP0020_GET_TACT_TIME_EXCEPT.
  -- ============================================================================
  PROCEDURE P_SCP0020_GET_TACT_TIME_EXCEPT(
    P_DIVISION_ID IN VARCHAR2, P_PLANT_SITE_ID IN VARCHAR2, P_OPERATION_ID IN VARCHAR2,
    P_ITEM_ID IN VARCHAR2, P_LINE_ID IN VARCHAR2,
    P_USER_ID IN VARCHAR2, P_MENU_ID IN VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN O_RC1 FOR
      SELECT a.division_id, a.plant_site_id,
             FN_GET_SCM_SITE_DESCRIPTION(a.division_id, a.plant_site_id) AS plant_site_name,
             a.operation_id, c.segment1 AS operation_name, a.item_id,
             FN_GET_ITEM_NICKNAME(a.division_id, a.item_id) AS nick_name, a.line_id,
--           TO_DATE(d.tact_time_start_date, 'YYYYMMDD') AS tact_time_start_date,
             d.tact_time_start_date AS tact_time_start_date,  -- 2026.09.18 화면 기간 칸 = YYYYMMDD 문자
--           TO_DATE(d.tact_time_end_date, 'YYYYMMDD') AS tact_time_end_date,
             d.tact_time_end_date AS tact_time_end_date,  -- 2026.09.18 화면 기간 칸 = YYYYMMDD 문자
             d.tact_time, ROUND(d.yield * 100, 2) AS yield, d.except_comment, d.use_yn,
             d.created_by, d.creation_date, d.last_updated_by, d.last_update_date,
             d.division_id AS org_division_id, d.plant_site_id AS org_plant_site_id,
             d.item_id AS org_item_id, d.operation_id AS org_operation_id, d.line_id AS org_line_id,
             d.tact_time_start_date AS org_tact_time_start_date, d.tact_time_end_date AS org_tact_time_end_date
      FROM SCP_MST_TACT_TIME a
      INNER JOIN (SELECT DISTINCT b.segment4, b.segment1
                    FROM scm_adm_lookup_master_detail b
                   WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE' AND b.valid_yn = 'Y' AND b.segment3 = 'Y') c
              ON a.operation_id = c.segment4
      INNER JOIN SCP_MST_TACT_TIME_EXCEPT d
              ON a.division_id = d.division_id AND a.plant_site_id = d.plant_site_id
             AND a.operation_id = d.operation_id AND a.item_id = d.item_id AND a.line_id = d.line_id
      WHERE 1 = 1
        AND a.division_id = P_DIVISION_ID AND a.plant_site_id = P_PLANT_SITE_ID
        AND a.operation_id = P_OPERATION_ID AND a.item_id = P_ITEM_ID AND a.line_id = P_LINE_ID
      ORDER BY a.division_id, a.plant_site_id, a.operation_id, a.item_id, a.line_id,
               d.tact_time_start_date, d.tact_time_end_date;

    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
  END P_SCP0020_GET_TACT_TIME_EXCEPT;

  -- ============================================================================
  -- GET TACT TIME EXCEPT OSP (Packer 부모) — AS-IS SCP0020_GET_TACT_TIME_EXCEPT_OSP.
  -- ============================================================================
  PROCEDURE P_SCP0020_GET_TACT_TIME_EXCEPT_OSP(
    P_DIVISION_ID IN VARCHAR2, P_PLANT_SITE_ID IN VARCHAR2, P_OPERATION_ID IN VARCHAR2,
    P_ITEM_ID IN VARCHAR2, P_LINE_ID IN VARCHAR2,
    P_USER_ID IN VARCHAR2, P_MENU_ID IN VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN O_RC1 FOR
      SELECT a.division_id, a.plant_site_id,
             FN_GET_SCM_SITE_DESCRIPTION(a.division_id, a.plant_site_id) AS plant_site_name,
             a.operation_id, a.operation_id AS operation_name, a.item_id,
             (SELECT NVL(MAX(X.NICK_NAME), '-') FROM SCM_MST_ITEM_SN X WHERE X.ITEM_ID = A.ITEM_ID) AS NICK_NAME,
             a.line_id,
--           TO_DATE(d.tact_time_start_date, 'YYYYMMDD') AS tact_time_start_date,
             d.tact_time_start_date AS tact_time_start_date,  -- 2026.09.18 화면 기간 칸 = YYYYMMDD 문자
--           TO_DATE(d.tact_time_end_date, 'YYYYMMDD') AS tact_time_end_date,
             d.tact_time_end_date AS tact_time_end_date,  -- 2026.09.18 화면 기간 칸 = YYYYMMDD 문자
             d.tact_time, ROUND(d.yield * 100, 2) AS yield, d.DAILY_CAPACITY, d.except_comment, d.use_yn,
             d.created_by, d.creation_date, d.last_updated_by, d.last_update_date,
             d.division_id AS org_division_id, d.plant_site_id AS org_plant_site_id,
             d.item_id AS org_item_id, d.operation_id AS org_operation_id, d.line_id AS org_line_id,
             d.tact_time_start_date AS org_tact_time_start_date, d.tact_time_end_date AS org_tact_time_end_date
      FROM SCP_MST_TACT_TIME_OSP a
      INNER JOIN SCP_MST_TACT_TIME_EXCEPT_OSP d
              ON a.division_id = d.division_id AND a.plant_site_id = d.plant_site_id
             AND a.operation_id = d.operation_id AND a.item_id = d.item_id AND a.line_id = d.line_id
      WHERE 1 = 1
        AND a.division_id = P_DIVISION_ID AND a.plant_site_id = P_PLANT_SITE_ID
        AND a.operation_id = P_OPERATION_ID AND a.item_id = P_ITEM_ID AND a.line_id = P_LINE_ID
      ORDER BY a.division_id, a.plant_site_id, a.operation_id, a.item_id, a.line_id,
               d.tact_time_start_date, d.tact_time_end_date;

    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
  END P_SCP0020_GET_TACT_TIME_EXCEPT_OSP;

  -- ============================================================================
  -- GET ITEM SEARCH (Model 검색 팝업) — AS-IS SCM0002_GET_ITEM_BY_DIVISION_POPUP 이식.
  --   div/site 는 다중값(INSTR), project/item 은 LIKE. 'ALL'/NULL = 필터 해제.
  -- ============================================================================
  PROCEDURE P_SCP0020_GET_ITEM_SEARCH(
    P_DIVISION_ID IN VARCHAR2, P_PROJECT_CODE IN VARCHAR2, P_SCM_SITE_ID IN VARCHAR2, P_ITEM_ID IN VARCHAR2,
    P_USER_ID IN VARCHAR2, P_MENU_ID IN VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN O_RC1 FOR
      SELECT DISTINCT D.DIVISION_ID, D.DIVISION_NAME,
             NVL(P.PROJECT_CODE, '-') AS PROJECT_CODE, NVL(P.PROJECT_NAME, '-') AS PROJECT_NAME,
             S.SCM_SITE_ID, S.SITE_DESCRIPTION, I.ITEM_ID, T.ITEM_NAME, T.ITEM_TYPE, T.NICK_NAME, T.ITEM_CLASS_NAME
      FROM SCM_MST_SITE_ITEM I
      JOIN SCM_MST_DIVISION D ON I.DIVISION_ID = D.DIVISION_ID
      JOIN SCM_MST_SITE S ON I.DIVISION_ID = S.DIVISION_ID AND I.SCM_SITE_ID = S.SCM_SITE_ID
      JOIN SCM_MST_ITEM_SN T ON I.DIVISION_ID = T.DIVISION_ID AND I.ITEM_ID = T.ITEM_ID
      LEFT OUTER JOIN SCM_MST_PROJECT P ON I.DIVISION_ID = P.DIVISION_ID AND I.PROJECT_CODE = P.PROJECT_CODE
      WHERE 1 = 1
        AND (P_DIVISION_ID = 'ALL' OR P_DIVISION_ID IS NULL OR INSTR(',' || P_DIVISION_ID || ',', ',' || I.DIVISION_ID || ',') > 0)
        AND (P_SCM_SITE_ID = 'ALL' OR P_SCM_SITE_ID IS NULL OR INSTR(',' || P_SCM_SITE_ID || ',', ',' || I.SCM_SITE_ID || ',') > 0)
        AND (P_PROJECT_CODE = 'ALL' OR P_PROJECT_CODE IS NULL OR I.PROJECT_CODE LIKE '%' || P_PROJECT_CODE || '%')
        AND (P_ITEM_ID = 'ALL' OR P_ITEM_ID IS NULL
             OR I.ITEM_ID LIKE '%' || P_ITEM_ID || '%' OR T.ITEM_NAME LIKE '%' || P_ITEM_ID || '%' OR T.NICK_NAME LIKE '%' || P_ITEM_ID || '%')
      ORDER BY D.DIVISION_ID, S.SCM_SITE_ID, S.SITE_DESCRIPTION, I.ITEM_ID, T.ITEM_NAME;

    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
  END P_SCP0020_GET_ITEM_SEARCH;

  -- ============================================================================
  -- SAVE TACT TIME (Plant) — AS-IS SCP0020_SAVE_TACT_TIME. 행별 이력→dup(I)→CRUD.
  --   CRUD_TYPE=AS-IS active_flag, INPUT_STATUS=데이터컬럼. yield 저장은 /100.
  -- ============================================================================
  PROCEDURE P_SCP0020_SAVE_TACT_TIME(P_DATA IN CLOB, P_USER_ID IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
    EX_BIZ_EX EXCEPTION; V_ERR_MSG VARCHAR2(4000); V_ROW_CNT NUMBER := 0; V_DUP NUMBER; V_NOW DATE := SYSDATE;
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
  BEGIN
    FOR R IN (
      SELECT TRIM(JT.CRUD_TYPE) CRUD_TYPE, TRIM(JT.INPUT_STATUS) INPUT_STATUS,
             TRIM(JT.DIVISION_ID) DIVISION_ID, TRIM(JT.PLANT_SITE_ID) PLANT_SITE_ID, TRIM(JT.ITEM_ID) ITEM_ID,
             TRIM(JT.OPERATION_ID) OPERATION_ID, TRIM(JT.LINE_ID) LINE_ID,
             JT.PRIORITY, JT.TACT_TIME, JT.YIELD, JT.VALID_YN, JT.ITEM_UOM, JT.UOM_CONVERT_VALUE, JT.LANE_QTY
      FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(
        CRUD_TYPE VARCHAR2(10) PATH '$."CRUD_TYPE"' NULL ON EMPTY NULL ON ERROR,
        INPUT_STATUS VARCHAR2(10) PATH '$."INPUT_STATUS"' NULL ON EMPTY NULL ON ERROR,
        DIVISION_ID VARCHAR2(60) PATH '$."DIVISION_ID"' NULL ON EMPTY NULL ON ERROR,
        PLANT_SITE_ID VARCHAR2(60) PATH '$."PLANT_SITE_ID"' NULL ON EMPTY NULL ON ERROR,
        ITEM_ID VARCHAR2(100) PATH '$."ITEM_ID"' NULL ON EMPTY NULL ON ERROR,
        OPERATION_ID VARCHAR2(60) PATH '$."OPERATION_ID"' NULL ON EMPTY NULL ON ERROR,
        LINE_ID VARCHAR2(100) PATH '$."LINE_ID"' NULL ON EMPTY NULL ON ERROR,
        PRIORITY VARCHAR2(50) PATH '$."PRIORITY"' NULL ON EMPTY NULL ON ERROR,
        TACT_TIME VARCHAR2(50) PATH '$."TACT_TIME"' NULL ON EMPTY NULL ON ERROR,
        YIELD VARCHAR2(50) PATH '$."YIELD"' NULL ON EMPTY NULL ON ERROR,
        VALID_YN VARCHAR2(10) PATH '$."VALID_YN"' NULL ON EMPTY NULL ON ERROR,
        ITEM_UOM VARCHAR2(50) PATH '$."ITEM_UOM"' NULL ON EMPTY NULL ON ERROR,
        UOM_CONVERT_VALUE VARCHAR2(50) PATH '$."UOM_CONVERT_VALUE"' NULL ON EMPTY NULL ON ERROR,
        LANE_QTY VARCHAR2(50) PATH '$."LANE_QTY"' NULL ON EMPTY NULL ON ERROR)) JT
    ) LOOP
      -- 이력 (항상). yield 는 /100 저장.
      INSERT INTO SCP_MST_TACT_TIME_H (HISTORY_SEQ, DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID,
        PRIORITY, TACT_TIME, YIELD, ITEM_UOM, UOM_CONVERT_VALUE, VALID_YN, CREATED_BY, CREATION_DATE,
        LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE, ATTRIBUTE1)
      VALUES (SEQ1_SCP_MST_TACT_TIME_H.NEXTVAL, R.DIVISION_ID, R.PLANT_SITE_ID, R.ITEM_ID, R.OPERATION_ID, R.LINE_ID,
        TO_NUMBER(R.PRIORITY), TO_NUMBER(R.TACT_TIME),
        CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END, R.ITEM_UOM,
        CASE WHEN R.UOM_CONVERT_VALUE IS NULL THEN NULL ELSE TO_NUMBER(R.UOM_CONVERT_VALUE) END, R.VALID_YN,
        P_USER_ID, V_NOW, P_USER_ID, V_NOW, SYSDATE, R.LANE_QTY);

      IF R.CRUD_TYPE = 'I' OR R.INPUT_STATUS = 'I' THEN
        SELECT COUNT(*) INTO V_DUP FROM SCP_MST_TACT_TIME
         WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
           AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
        IF V_DUP > 0 THEN RAISE_INVALID('이미 존재하는 데이타 입니다.'); END IF;
      END IF;

      IF R.INPUT_STATUS = 'M' AND R.CRUD_TYPE = 'M' THEN
        UPDATE SCP_MST_TACT_TIME
           SET PRIORITY = TO_NUMBER(R.PRIORITY), TACT_TIME = TO_NUMBER(R.TACT_TIME),
               YIELD = CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END,
               VALID_YN = R.VALID_YN, LAST_UPDATED_BY = P_USER_ID, LAST_UPDATE_DATE = V_NOW, ATTRIBUTE1 = R.LANE_QTY
         WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
           AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
      ELSIF R.CRUD_TYPE = 'I' OR R.INPUT_STATUS = 'I' THEN
        INSERT INTO SCP_MST_TACT_TIME (DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRIORITY,
          TACT_TIME, YIELD, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1)
        VALUES (R.DIVISION_ID, R.PLANT_SITE_ID, R.ITEM_ID, R.OPERATION_ID, R.LINE_ID, TO_NUMBER(R.PRIORITY),
          TO_NUMBER(R.TACT_TIME), CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END,
          R.VALID_YN, P_USER_ID, V_NOW, P_USER_ID, V_NOW, R.LANE_QTY);
      ELSIF R.CRUD_TYPE = 'D' AND R.INPUT_STATUS = 'M' THEN
        INSERT INTO SCP_MST_TACT_TIME_EXCEPT_H (HISTORY_SEQ, DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID,
          LINE_ID, TACT_TIME_START_DATE, TACT_TIME_END_DATE, TACT_TIME, YIELD, EXCEPT_COMMENT, USE_YN, CREATED_BY,
          CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE, ATTRIBUTE1)
        SELECT SEQ1_SCP_MST_TACT_TIME_EXCEPT_H.NEXTVAL, DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID,
          TACT_TIME_START_DATE, TACT_TIME_END_DATE, TACT_TIME, YIELD, EXCEPT_COMMENT, USE_YN, P_USER_ID, V_NOW,
          P_USER_ID, SYSDATE, SYSDATE, R.CRUD_TYPE
        FROM SCP_MST_TACT_TIME_EXCEPT
         WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
           AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
        DELETE FROM SCP_MST_TACT_TIME_EXCEPT
         WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
           AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
        DELETE FROM SCP_MST_TACT_TIME
         WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
           AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
      END IF;
      V_ROW_CNT := V_ROW_CNT + 1;
    END LOOP;
    COMMIT;
    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
  EXCEPTION
    WHEN EX_BIZ_EX THEN ROLLBACK; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
    WHEN OTHERS THEN ROLLBACK; V_ERR_MSG := SQLERRM; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
  END P_SCP0020_SAVE_TACT_TIME;

---- ============================================================================
---- SAVE TACT TIME OSP (Packer) — AS-IS SCP0020_SAVE_TACT_TIME_OSP. DAILY_CAPACITY 포함.
---- ============================================================================
--PROCEDURE P_SCP0020_SAVE_TACT_TIME_OSP(P_DATA IN CLOB, P_USER_ID IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
--  EX_BIZ_EX EXCEPTION; V_ERR_MSG VARCHAR2(4000); V_ROW_CNT NUMBER := 0; V_DUP NUMBER; V_NOW DATE := SYSDATE;
--  PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
--BEGIN
--  FOR R IN (
--    SELECT TRIM(JT.CRUD_TYPE) CRUD_TYPE, TRIM(JT.INPUT_STATUS) INPUT_STATUS,
--           TRIM(JT.DIVISION_ID) DIVISION_ID, TRIM(JT.PLANT_SITE_ID) PLANT_SITE_ID, TRIM(JT.ITEM_ID) ITEM_ID,
--           TRIM(JT.OPERATION_ID) OPERATION_ID, TRIM(JT.LINE_ID) LINE_ID,
--           JT.PRIORITY, JT.TACT_TIME, JT.YIELD, JT.DAILY_CAPACITY, JT.VALID_YN
--    FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(
--      CRUD_TYPE VARCHAR2(10) PATH '$."CRUD_TYPE"' NULL ON EMPTY NULL ON ERROR,
--      INPUT_STATUS VARCHAR2(10) PATH '$."INPUT_STATUS"' NULL ON EMPTY NULL ON ERROR,
--      DIVISION_ID VARCHAR2(60) PATH '$."DIVISION_ID"' NULL ON EMPTY NULL ON ERROR,
--      PLANT_SITE_ID VARCHAR2(60) PATH '$."PLANT_SITE_ID"' NULL ON EMPTY NULL ON ERROR,
--      ITEM_ID VARCHAR2(100) PATH '$."ITEM_ID"' NULL ON EMPTY NULL ON ERROR,
--      OPERATION_ID VARCHAR2(60) PATH '$."OPERATION_ID"' NULL ON EMPTY NULL ON ERROR,
--      LINE_ID VARCHAR2(100) PATH '$."LINE_ID"' NULL ON EMPTY NULL ON ERROR,
--      PRIORITY VARCHAR2(50) PATH '$."PRIORITY"' NULL ON EMPTY NULL ON ERROR,
--      TACT_TIME VARCHAR2(50) PATH '$."TACT_TIME"' NULL ON EMPTY NULL ON ERROR,
--      YIELD VARCHAR2(50) PATH '$."YIELD"' NULL ON EMPTY NULL ON ERROR,
--      DAILY_CAPACITY VARCHAR2(50) PATH '$."DAILY_CAPACITY"' NULL ON EMPTY NULL ON ERROR,
--      VALID_YN VARCHAR2(10) PATH '$."VALID_YN"' NULL ON EMPTY NULL ON ERROR)) JT
--  ) LOOP
--    INSERT INTO SCP_MST_TACT_TIME_OSP_H (HISTORY_SEQ, DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID,
--      PRIORITY, TACT_TIME, YIELD, DAILY_CAPACITY, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY,
--      LAST_UPDATE_DATE, HISTORY_CREATION_DATE, ATTRIBUTE1)
--    VALUES (SEQ1_SCP_MST_TACT_TIME_OSP_H.NEXTVAL, R.DIVISION_ID, R.PLANT_SITE_ID, R.ITEM_ID, R.OPERATION_ID, R.LINE_ID,
--      TO_NUMBER(R.PRIORITY), TO_NUMBER(R.TACT_TIME),
--      CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END,
--      CASE WHEN R.DAILY_CAPACITY IS NULL THEN NULL ELSE TO_NUMBER(R.DAILY_CAPACITY) END, R.VALID_YN,
--      P_USER_ID, V_NOW, P_USER_ID, V_NOW, SYSDATE, R.CRUD_TYPE);
--
--    IF R.CRUD_TYPE = 'I' OR R.INPUT_STATUS = 'I' THEN
--      SELECT COUNT(*) INTO V_DUP FROM SCP_MST_TACT_TIME_OSP
--       WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
--         AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
--      IF V_DUP > 0 THEN RAISE_INVALID('이미 존재하는 데이타 입니다.'); END IF;
--    END IF;
--
--    IF R.INPUT_STATUS = 'M' AND R.CRUD_TYPE = 'M' THEN
--      UPDATE SCP_MST_TACT_TIME_OSP
--         SET PRIORITY = TO_NUMBER(R.PRIORITY), TACT_TIME = TO_NUMBER(R.TACT_TIME),
--             YIELD = CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END,
--             DAILY_CAPACITY = CASE WHEN R.DAILY_CAPACITY IS NULL THEN NULL ELSE TO_NUMBER(R.DAILY_CAPACITY) END,
--             LAST_UPDATED_BY = P_USER_ID, LAST_UPDATE_DATE = V_NOW
--       WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
--         AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
--    ELSIF R.CRUD_TYPE = 'I' OR R.INPUT_STATUS = 'I' THEN
--      INSERT INTO SCP_MST_TACT_TIME_OSP (DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID, PRIORITY,
--        TACT_TIME, YIELD, DAILY_CAPACITY, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
--      VALUES (R.DIVISION_ID, R.PLANT_SITE_ID, R.ITEM_ID, R.OPERATION_ID, R.LINE_ID, TO_NUMBER(R.PRIORITY),
--        TO_NUMBER(R.TACT_TIME), CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END,
--        CASE WHEN R.DAILY_CAPACITY IS NULL THEN NULL ELSE TO_NUMBER(R.DAILY_CAPACITY) END,
--        R.VALID_YN, P_USER_ID, V_NOW, P_USER_ID, V_NOW);
--    ELSIF R.CRUD_TYPE = 'D' AND R.INPUT_STATUS = 'M' THEN
--      INSERT INTO SCP_MST_TACT_TIME_EXCEPT_OSP_H (HISTORY_SEQ, DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID,
--        LINE_ID, TACT_TIME_START_DATE, TACT_TIME_END_DATE, TACT_TIME, YIELD, DAILY_CAPACITY, EXCEPT_COMMENT, USE_YN,
--        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE, ATTRIBUTE1)
--      SELECT SEQ1_SCP_MST_TACT_TIME_EXCEPT_OSP_H.NEXTVAL, DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID,
--        TACT_TIME_START_DATE, TACT_TIME_END_DATE, TACT_TIME, YIELD, DAILY_CAPACITY, EXCEPT_COMMENT, USE_YN,
--        P_USER_ID, V_NOW, P_USER_ID, V_NOW, SYSDATE, R.CRUD_TYPE
--      FROM SCP_MST_TACT_TIME_EXCEPT_OSP
--       WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
--         AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
--      DELETE FROM SCP_MST_TACT_TIME_EXCEPT_OSP
--       WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
--         AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
--      DELETE FROM SCP_MST_TACT_TIME_OSP
--       WHERE DIVISION_ID = R.DIVISION_ID AND PLANT_SITE_ID = R.PLANT_SITE_ID AND ITEM_ID = R.ITEM_ID
--         AND OPERATION_ID = R.OPERATION_ID AND LINE_ID = R.LINE_ID;
--    END IF;
--    V_ROW_CNT := V_ROW_CNT + 1;
--  END LOOP;
--  COMMIT;
--  OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
--EXCEPTION
--  WHEN EX_BIZ_EX THEN ROLLBACK; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
--  WHEN OTHERS THEN ROLLBACK; V_ERR_MSG := SQLERRM; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
--END P_SCP0020_SAVE_TACT_TIME_OSP;
  -- 2026.09.18 저장 순서·판정을 AS-IS 와 같게 다시 작성 (START)
  --   AS-IS 화면 전송값 : 수정(M)이면서 입력상태 I 인 행 = I, 사용여부 = Y
  --   AS-IS 처리 순서 : 중복 판정(기존 - 삭제 + 신규) → 삭제 행 예외 이력·예외 삭제 → 전 행 이력 → 삭제 → 신규 → 수정
  PROCEDURE P_SCP0020_SAVE_TACT_TIME_OSP(P_DATA IN CLOB, P_USER_ID IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
    EX_BIZ_EX EXCEPTION; V_ERR_MSG VARCHAR2(4000); V_ROW_CNT NUMBER := 0; V_NOW DATE := SYSDATE;
    V_EXIST NUMBER; V_HAS_D NUMBER; V_ICNT NUMBER;
    TYPE T_ROW IS RECORD (
      CRUD_TYPE      VARCHAR2(10),
      DIVISION_ID    VARCHAR2(60),
      PLANT_SITE_ID  VARCHAR2(60),
      ITEM_ID        VARCHAR2(100),
      OPERATION_ID   VARCHAR2(60),
      LINE_ID        VARCHAR2(100),
      PRIORITY       NUMBER,
      TACT_TIME      NUMBER,
      YIELD          NUMBER,
      DAILY_CAPACITY NUMBER,
      VALID_YN       VARCHAR2(10));
    TYPE T_ROWS IS TABLE OF T_ROW;
    V_ROWS T_ROWS;
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
    FUNCTION SAME_KEY(I IN PLS_INTEGER, J IN PLS_INTEGER) RETURN BOOLEAN IS
    BEGIN
      RETURN V_ROWS(I).DIVISION_ID   = V_ROWS(J).DIVISION_ID
         AND V_ROWS(I).PLANT_SITE_ID = V_ROWS(J).PLANT_SITE_ID
         AND V_ROWS(I).ITEM_ID       = V_ROWS(J).ITEM_ID
         AND V_ROWS(I).OPERATION_ID  = V_ROWS(J).OPERATION_ID
         AND V_ROWS(I).LINE_ID       = V_ROWS(J).LINE_ID;
    END;
  BEGIN
    SELECT CASE WHEN TRIM(JT.CRUD_TYPE) = 'M' AND TRIM(JT.INPUT_STATUS) = 'I' THEN 'I'
                ELSE TRIM(JT.CRUD_TYPE) END                                        /* 등록 필요 행 수정 = 신규 */
         , TRIM(JT.DIVISION_ID)
         , TRIM(JT.PLANT_SITE_ID)
         , TRIM(JT.ITEM_ID)
         , TRIM(JT.OPERATION_ID)
         , TRIM(JT.LINE_ID)
         , TO_NUMBER(JT.PRIORITY)
         , TO_NUMBER(JT.TACT_TIME)
         , CASE WHEN JT.YIELD IS NULL THEN NULL ELSE TO_NUMBER(JT.YIELD) / 100 END
         , TO_NUMBER(JT.DAILY_CAPACITY)
         , NVL(TRIM(JT.VALID_YN), 'Y')                                              /* AS-IS 화면 고정값 Y */
      BULK COLLECT INTO V_ROWS
      FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(
             CRUD_TYPE      VARCHAR2(10)  PATH '$."CRUD_TYPE"'      NULL ON EMPTY NULL ON ERROR,
             INPUT_STATUS   VARCHAR2(10)  PATH '$."INPUT_STATUS"'   NULL ON EMPTY NULL ON ERROR,
             DIVISION_ID    VARCHAR2(60)  PATH '$."DIVISION_ID"'    NULL ON EMPTY NULL ON ERROR,
             PLANT_SITE_ID  VARCHAR2(60)  PATH '$."PLANT_SITE_ID"'  NULL ON EMPTY NULL ON ERROR,
             ITEM_ID        VARCHAR2(100) PATH '$."ITEM_ID"'        NULL ON EMPTY NULL ON ERROR,
             OPERATION_ID   VARCHAR2(60)  PATH '$."OPERATION_ID"'   NULL ON EMPTY NULL ON ERROR,
             LINE_ID        VARCHAR2(100) PATH '$."LINE_ID"'        NULL ON EMPTY NULL ON ERROR,
             PRIORITY       VARCHAR2(50)  PATH '$."PRIORITY"'       NULL ON EMPTY NULL ON ERROR,
             TACT_TIME      VARCHAR2(50)  PATH '$."TACT_TIME"'      NULL ON EMPTY NULL ON ERROR,
             YIELD          VARCHAR2(50)  PATH '$."YIELD"'          NULL ON EMPTY NULL ON ERROR,
             DAILY_CAPACITY VARCHAR2(50)  PATH '$."DAILY_CAPACITY"' NULL ON EMPTY NULL ON ERROR,
             VALID_YN       VARCHAR2(10)  PATH '$."VALID_YN"'       NULL ON EMPTY NULL ON ERROR)) JT;

    /* 중복 판정 : 기존 행(같은 저장의 삭제 행 제외) + 신규 행 */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE = 'I' THEN
        SELECT COUNT(*)
          INTO V_EXIST
          FROM SCP_MST_TACT_TIME_OSP
         WHERE DIVISION_ID   = V_ROWS(I).DIVISION_ID
           AND PLANT_SITE_ID = V_ROWS(I).PLANT_SITE_ID
           AND ITEM_ID       = V_ROWS(I).ITEM_ID
           AND OPERATION_ID  = V_ROWS(I).OPERATION_ID
           AND LINE_ID       = V_ROWS(I).LINE_ID;
        V_HAS_D := 0; V_ICNT := 0;
        FOR J IN 1 .. V_ROWS.COUNT LOOP
          IF SAME_KEY(I, J) THEN
            IF V_ROWS(J).CRUD_TYPE = 'D' THEN V_HAS_D := 1; END IF;
            IF V_ROWS(J).CRUD_TYPE = 'I' THEN V_ICNT := V_ICNT + 1; END IF;
          END IF;
        END LOOP;
        IF (CASE WHEN V_EXIST > 0 AND V_HAS_D = 0 THEN 1 ELSE 0 END) + V_ICNT > 1 THEN
          RAISE_INVALID('이미 존재하는 데이타 입니다.');
        END IF;
      END IF;
    END LOOP;

    /* 삭제 행 : 예외 이력 → 예외 삭제 */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE = 'D' THEN
        INSERT INTO SCP_MST_TACT_TIME_EXCEPT_OSP_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , TACT_TIME_START_DATE
             , TACT_TIME_END_DATE
             , TACT_TIME
             , YIELD
             , DAILY_CAPACITY
             , EXCEPT_COMMENT
             , USE_YN
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             , ATTRIBUTE1 )
        SELECT SEQ1_SCP_MST_TACT_TIME_EXCEPT_OSP_H.NEXTVAL
             , DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , TACT_TIME_START_DATE
             , TACT_TIME_END_DATE
             , TACT_TIME
             , YIELD
             , DAILY_CAPACITY
             , EXCEPT_COMMENT
             , USE_YN
             , P_USER_ID
             , V_NOW
             , P_USER_ID
             , V_NOW
             , V_NOW
             , V_ROWS(I).CRUD_TYPE
          FROM SCP_MST_TACT_TIME_EXCEPT_OSP
         WHERE DIVISION_ID   = V_ROWS(I).DIVISION_ID
           AND PLANT_SITE_ID = V_ROWS(I).PLANT_SITE_ID
           AND ITEM_ID       = V_ROWS(I).ITEM_ID
           AND OPERATION_ID  = V_ROWS(I).OPERATION_ID
           AND LINE_ID       = V_ROWS(I).LINE_ID;
        DELETE FROM SCP_MST_TACT_TIME_EXCEPT_OSP
         WHERE DIVISION_ID   = V_ROWS(I).DIVISION_ID
           AND PLANT_SITE_ID = V_ROWS(I).PLANT_SITE_ID
           AND ITEM_ID       = V_ROWS(I).ITEM_ID
           AND OPERATION_ID  = V_ROWS(I).OPERATION_ID
           AND LINE_ID       = V_ROWS(I).LINE_ID;
      END IF;
    END LOOP;

    /* 전 행 이력 */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      INSERT INTO SCP_MST_TACT_TIME_OSP_H
           ( HISTORY_SEQ
           , DIVISION_ID
           , PLANT_SITE_ID
           , ITEM_ID
           , OPERATION_ID
           , LINE_ID
           , PRIORITY
           , TACT_TIME
           , YIELD
           , DAILY_CAPACITY
           , VALID_YN
           , CREATED_BY
           , CREATION_DATE
           , LAST_UPDATED_BY
           , LAST_UPDATE_DATE
           , HISTORY_CREATION_DATE
           , ATTRIBUTE1 )
      VALUES
           ( SEQ1_SCP_MST_TACT_TIME_OSP_H.NEXTVAL
           , V_ROWS(I).DIVISION_ID
           , V_ROWS(I).PLANT_SITE_ID
           , V_ROWS(I).ITEM_ID
           , V_ROWS(I).OPERATION_ID
           , V_ROWS(I).LINE_ID
           , V_ROWS(I).PRIORITY
           , V_ROWS(I).TACT_TIME
           , V_ROWS(I).YIELD
           , V_ROWS(I).DAILY_CAPACITY
           , V_ROWS(I).VALID_YN
           , P_USER_ID
           , V_NOW
           , P_USER_ID
           , V_NOW
           , V_NOW
           , V_ROWS(I).CRUD_TYPE );
    END LOOP;

    /* 삭제 */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE = 'D' THEN
        DELETE FROM SCP_MST_TACT_TIME_OSP
         WHERE DIVISION_ID   = V_ROWS(I).DIVISION_ID
           AND PLANT_SITE_ID = V_ROWS(I).PLANT_SITE_ID
           AND ITEM_ID       = V_ROWS(I).ITEM_ID
           AND OPERATION_ID  = V_ROWS(I).OPERATION_ID
           AND LINE_ID       = V_ROWS(I).LINE_ID;
      END IF;
    END LOOP;

    /* 신규 */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE = 'I' THEN
        INSERT INTO SCP_MST_TACT_TIME_OSP
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , PRIORITY
             , TACT_TIME
             , YIELD
             , DAILY_CAPACITY
             , VALID_YN
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        VALUES
             ( V_ROWS(I).DIVISION_ID
             , V_ROWS(I).PLANT_SITE_ID
             , V_ROWS(I).ITEM_ID
             , V_ROWS(I).OPERATION_ID
             , V_ROWS(I).LINE_ID
             , V_ROWS(I).PRIORITY
             , V_ROWS(I).TACT_TIME
             , V_ROWS(I).YIELD
             , V_ROWS(I).DAILY_CAPACITY
             , V_ROWS(I).VALID_YN
             , P_USER_ID
             , V_NOW
             , P_USER_ID
             , V_NOW );
      END IF;
    END LOOP;

    /* 수정 */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE = 'M' THEN
        UPDATE SCP_MST_TACT_TIME_OSP
           SET PRIORITY         = V_ROWS(I).PRIORITY
             , TACT_TIME        = V_ROWS(I).TACT_TIME
             , YIELD            = V_ROWS(I).YIELD
             , DAILY_CAPACITY   = V_ROWS(I).DAILY_CAPACITY
             , LAST_UPDATED_BY  = P_USER_ID
             , LAST_UPDATE_DATE = V_NOW
         WHERE DIVISION_ID   = V_ROWS(I).DIVISION_ID
           AND PLANT_SITE_ID = V_ROWS(I).PLANT_SITE_ID
           AND ITEM_ID       = V_ROWS(I).ITEM_ID
           AND OPERATION_ID  = V_ROWS(I).OPERATION_ID
           AND LINE_ID       = V_ROWS(I).LINE_ID;
      END IF;
    END LOOP;

    V_ROW_CNT := V_ROWS.COUNT;
    COMMIT;
    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
  EXCEPTION
    WHEN EX_BIZ_EX THEN ROLLBACK; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
    WHEN OTHERS THEN ROLLBACK; V_ERR_MSG := SQLERRM; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
  END P_SCP0020_SAVE_TACT_TIME_OSP;
  -- 2026.09.18 저장 순서·판정을 AS-IS 와 같게 다시 작성 (END)

---- ============================================================================
---- SAVE TACT TIME EXCEPT (Plant 부모) — AS-IS SCP0020_SAVE_TACT_TIME_EXCEPT.
----   기간행(start/end date PK). D=org키 삭제, I/M=org키 UPDATE→없으면 INSERT. 이력=제출값.
---- ============================================================================
--PROCEDURE P_SCP0020_SAVE_TACT_TIME_EXCEPT(P_DATA IN CLOB, P_USER_ID IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
--  EX_BIZ_EX EXCEPTION; V_ERR_MSG VARCHAR2(4000); V_ROW_CNT NUMBER := 0; V_NOW DATE := SYSDATE;
--  PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
--BEGIN
--  FOR R IN (
--    SELECT TRIM(JT.CRUD_TYPE) CRUD_TYPE, TRIM(JT.DIVISION_ID) DIVISION_ID, TRIM(JT.PLANT_SITE_ID) PLANT_SITE_ID,
--           TRIM(JT.ITEM_ID) ITEM_ID, TRIM(JT.OPERATION_ID) OPERATION_ID, TRIM(JT.LINE_ID) LINE_ID,
--           TRIM(JT.TACT_TIME_START_DATE) TACT_TIME_START_DATE, TRIM(JT.TACT_TIME_END_DATE) TACT_TIME_END_DATE,
--           JT.TACT_TIME, JT.YIELD, JT.EXCEPT_COMMENT, JT.USE_YN,
--           TRIM(JT.ORG_DIVISION_ID) ORG_DIVISION_ID, TRIM(JT.ORG_PLANT_SITE_ID) ORG_PLANT_SITE_ID,
--           TRIM(JT.ORG_ITEM_ID) ORG_ITEM_ID, TRIM(JT.ORG_OPERATION_ID) ORG_OPERATION_ID, TRIM(JT.ORG_LINE_ID) ORG_LINE_ID,
--           TRIM(JT.ORG_TACT_TIME_START_DATE) ORG_TACT_TIME_START_DATE, TRIM(JT.ORG_TACT_TIME_END_DATE) ORG_TACT_TIME_END_DATE
--    FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(
--      CRUD_TYPE VARCHAR2(10) PATH '$."CRUD_TYPE"' NULL ON EMPTY NULL ON ERROR,
--      DIVISION_ID VARCHAR2(60) PATH '$."DIVISION_ID"' NULL ON EMPTY NULL ON ERROR,
--      PLANT_SITE_ID VARCHAR2(60) PATH '$."PLANT_SITE_ID"' NULL ON EMPTY NULL ON ERROR,
--      ITEM_ID VARCHAR2(100) PATH '$."ITEM_ID"' NULL ON EMPTY NULL ON ERROR,
--      OPERATION_ID VARCHAR2(60) PATH '$."OPERATION_ID"' NULL ON EMPTY NULL ON ERROR,
--      LINE_ID VARCHAR2(100) PATH '$."LINE_ID"' NULL ON EMPTY NULL ON ERROR,
--      TACT_TIME_START_DATE VARCHAR2(8) PATH '$."TACT_TIME_START_DATE"' NULL ON EMPTY NULL ON ERROR,
--      TACT_TIME_END_DATE VARCHAR2(8) PATH '$."TACT_TIME_END_DATE"' NULL ON EMPTY NULL ON ERROR,
--      TACT_TIME VARCHAR2(50) PATH '$."TACT_TIME"' NULL ON EMPTY NULL ON ERROR,
--      YIELD VARCHAR2(50) PATH '$."YIELD"' NULL ON EMPTY NULL ON ERROR,
--      EXCEPT_COMMENT VARCHAR2(400) PATH '$."EXCEPT_COMMENT"' NULL ON EMPTY NULL ON ERROR,
--      USE_YN VARCHAR2(10) PATH '$."USE_YN"' NULL ON EMPTY NULL ON ERROR,
--      ORG_DIVISION_ID VARCHAR2(60) PATH '$."ORG_DIVISION_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_PLANT_SITE_ID VARCHAR2(60) PATH '$."ORG_PLANT_SITE_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_ITEM_ID VARCHAR2(100) PATH '$."ORG_ITEM_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_OPERATION_ID VARCHAR2(60) PATH '$."ORG_OPERATION_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_LINE_ID VARCHAR2(100) PATH '$."ORG_LINE_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_TACT_TIME_START_DATE VARCHAR2(8) PATH '$."ORG_TACT_TIME_START_DATE"' NULL ON EMPTY NULL ON ERROR,
--      ORG_TACT_TIME_END_DATE VARCHAR2(8) PATH '$."ORG_TACT_TIME_END_DATE"' NULL ON EMPTY NULL ON ERROR)) JT
--  ) LOOP
--    -- 이력 (제출값)
--    INSERT INTO SCP_MST_TACT_TIME_EXCEPT_H (HISTORY_SEQ, DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID,
--      TACT_TIME_START_DATE, TACT_TIME_END_DATE, TACT_TIME, YIELD, EXCEPT_COMMENT, USE_YN, CREATED_BY, CREATION_DATE,
--      LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE)
--    VALUES (SEQ1_SCP_MST_TACT_TIME_EXCEPT_H.NEXTVAL, R.DIVISION_ID, R.PLANT_SITE_ID, R.ITEM_ID, R.OPERATION_ID, R.LINE_ID,
--      R.TACT_TIME_START_DATE, R.TACT_TIME_END_DATE, TO_NUMBER(R.TACT_TIME),
--      CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD) END, R.EXCEPT_COMMENT, R.USE_YN,
--      P_USER_ID, V_NOW, P_USER_ID, SYSDATE, SYSDATE);
--
--    IF R.CRUD_TYPE = 'D' THEN
--      DELETE FROM SCP_MST_TACT_TIME_EXCEPT
--       WHERE DIVISION_ID = R.ORG_DIVISION_ID AND PLANT_SITE_ID = R.ORG_PLANT_SITE_ID AND ITEM_ID = R.ORG_ITEM_ID
--         AND OPERATION_ID = R.ORG_OPERATION_ID AND LINE_ID = R.ORG_LINE_ID
--         AND TACT_TIME_START_DATE = R.ORG_TACT_TIME_START_DATE AND TACT_TIME_END_DATE = R.ORG_TACT_TIME_END_DATE;
--    ELSIF R.CRUD_TYPE IN ('I', 'M') THEN
--      UPDATE SCP_MST_TACT_TIME_EXCEPT
--         SET TACT_TIME_START_DATE = R.TACT_TIME_START_DATE, TACT_TIME_END_DATE = R.TACT_TIME_END_DATE,
--             TACT_TIME = TO_NUMBER(R.TACT_TIME),
--             YIELD = CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END,
--             EXCEPT_COMMENT = R.EXCEPT_COMMENT, USE_YN = R.USE_YN,
--             LAST_UPDATED_BY = P_USER_ID, LAST_UPDATE_DATE = V_NOW
--       WHERE DIVISION_ID = R.ORG_DIVISION_ID AND PLANT_SITE_ID = R.ORG_PLANT_SITE_ID AND ITEM_ID = R.ORG_ITEM_ID
--         AND OPERATION_ID = R.ORG_OPERATION_ID AND LINE_ID = R.ORG_LINE_ID
--         AND TACT_TIME_START_DATE = R.ORG_TACT_TIME_START_DATE AND TACT_TIME_END_DATE = R.ORG_TACT_TIME_END_DATE;
--      IF SQL%ROWCOUNT = 0 THEN
--        INSERT INTO SCP_MST_TACT_TIME_EXCEPT (DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID,
--          TACT_TIME_START_DATE, TACT_TIME_END_DATE, TACT_TIME, YIELD, EXCEPT_COMMENT, USE_YN, CREATED_BY,
--          CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
--        VALUES (R.DIVISION_ID, R.PLANT_SITE_ID, R.ITEM_ID, R.OPERATION_ID, R.LINE_ID, R.TACT_TIME_START_DATE,
--          R.TACT_TIME_END_DATE, TO_NUMBER(R.TACT_TIME),
--          CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END, R.EXCEPT_COMMENT, R.USE_YN,
--          P_USER_ID, V_NOW, P_USER_ID, V_NOW);
--      END IF;
--    END IF;
--    V_ROW_CNT := V_ROW_CNT + 1;
--  END LOOP;
--  COMMIT;
--  OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
--EXCEPTION
--  WHEN EX_BIZ_EX THEN ROLLBACK; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
--  WHEN OTHERS THEN ROLLBACK; V_ERR_MSG := SQLERRM; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
--END P_SCP0020_SAVE_TACT_TIME_EXCEPT;
  -- 2026.09.18 저장 순서를 AS-IS 와 같게 다시 작성 (START)
  --   AS-IS 처리 순서 : 삭제(원래 키) → 수정(원래 키) → 신규(새 키가 없을 때만) → 전 행 이력(전송값)
  PROCEDURE P_SCP0020_SAVE_TACT_TIME_EXCEPT(P_DATA IN CLOB, P_USER_ID IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
    V_ERR_MSG VARCHAR2(4000); V_ROW_CNT NUMBER := 0; V_NOW DATE := SYSDATE;
    TYPE T_ROW IS RECORD (
      CRUD_TYPE                VARCHAR2(10),
      DIVISION_ID              VARCHAR2(60),
      PLANT_SITE_ID            VARCHAR2(60),
      ITEM_ID                  VARCHAR2(100),
      OPERATION_ID             VARCHAR2(60),
      LINE_ID                  VARCHAR2(100),
      TACT_TIME_START_DATE     VARCHAR2(8),
      TACT_TIME_END_DATE       VARCHAR2(8),
      TACT_TIME                VARCHAR2(50),
      YIELD                    VARCHAR2(50),
      EXCEPT_COMMENT           VARCHAR2(400),
      USE_YN                   VARCHAR2(10),
      ORG_DIVISION_ID          VARCHAR2(60),
      ORG_PLANT_SITE_ID        VARCHAR2(60),
      ORG_ITEM_ID              VARCHAR2(100),
      ORG_OPERATION_ID         VARCHAR2(60),
      ORG_LINE_ID              VARCHAR2(100),
      ORG_TACT_TIME_START_DATE VARCHAR2(8),
      ORG_TACT_TIME_END_DATE   VARCHAR2(8));
    TYPE T_ROWS IS TABLE OF T_ROW;
    V_ROWS T_ROWS;
  BEGIN
    SELECT TRIM(JT.CRUD_TYPE)
         , TRIM(JT.DIVISION_ID)
         , TRIM(JT.PLANT_SITE_ID)
         , TRIM(JT.ITEM_ID)
         , TRIM(JT.OPERATION_ID)
         , TRIM(JT.LINE_ID)
         , TRIM(JT.TACT_TIME_START_DATE)
         , TRIM(JT.TACT_TIME_END_DATE)
         , JT.TACT_TIME
         , JT.YIELD
         , JT.EXCEPT_COMMENT
         , JT.USE_YN
         , TRIM(JT.ORG_DIVISION_ID)
         , TRIM(JT.ORG_PLANT_SITE_ID)
         , TRIM(JT.ORG_ITEM_ID)
         , TRIM(JT.ORG_OPERATION_ID)
         , TRIM(JT.ORG_LINE_ID)
         , TRIM(JT.ORG_TACT_TIME_START_DATE)
         , TRIM(JT.ORG_TACT_TIME_END_DATE)
      BULK COLLECT INTO V_ROWS
      FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(
             CRUD_TYPE                VARCHAR2(10)  PATH '$."CRUD_TYPE"'                NULL ON EMPTY NULL ON ERROR,
             DIVISION_ID              VARCHAR2(60)  PATH '$."DIVISION_ID"'              NULL ON EMPTY NULL ON ERROR,
             PLANT_SITE_ID            VARCHAR2(60)  PATH '$."PLANT_SITE_ID"'            NULL ON EMPTY NULL ON ERROR,
             ITEM_ID                  VARCHAR2(100) PATH '$."ITEM_ID"'                  NULL ON EMPTY NULL ON ERROR,
             OPERATION_ID             VARCHAR2(60)  PATH '$."OPERATION_ID"'             NULL ON EMPTY NULL ON ERROR,
             LINE_ID                  VARCHAR2(100) PATH '$."LINE_ID"'                  NULL ON EMPTY NULL ON ERROR,
             TACT_TIME_START_DATE     VARCHAR2(8)   PATH '$."TACT_TIME_START_DATE"'     NULL ON EMPTY NULL ON ERROR,
             TACT_TIME_END_DATE       VARCHAR2(8)   PATH '$."TACT_TIME_END_DATE"'       NULL ON EMPTY NULL ON ERROR,
             TACT_TIME                VARCHAR2(50)  PATH '$."TACT_TIME"'                NULL ON EMPTY NULL ON ERROR,
             YIELD                    VARCHAR2(50)  PATH '$."YIELD"'                    NULL ON EMPTY NULL ON ERROR,
             EXCEPT_COMMENT           VARCHAR2(400) PATH '$."EXCEPT_COMMENT"'           NULL ON EMPTY NULL ON ERROR,
             USE_YN                   VARCHAR2(10)  PATH '$."USE_YN"'                   NULL ON EMPTY NULL ON ERROR,
             ORG_DIVISION_ID          VARCHAR2(60)  PATH '$."ORG_DIVISION_ID"'          NULL ON EMPTY NULL ON ERROR,
             ORG_PLANT_SITE_ID        VARCHAR2(60)  PATH '$."ORG_PLANT_SITE_ID"'        NULL ON EMPTY NULL ON ERROR,
             ORG_ITEM_ID              VARCHAR2(100) PATH '$."ORG_ITEM_ID"'              NULL ON EMPTY NULL ON ERROR,
             ORG_OPERATION_ID         VARCHAR2(60)  PATH '$."ORG_OPERATION_ID"'         NULL ON EMPTY NULL ON ERROR,
             ORG_LINE_ID              VARCHAR2(100) PATH '$."ORG_LINE_ID"'              NULL ON EMPTY NULL ON ERROR,
             ORG_TACT_TIME_START_DATE VARCHAR2(8)   PATH '$."ORG_TACT_TIME_START_DATE"' NULL ON EMPTY NULL ON ERROR,
             ORG_TACT_TIME_END_DATE   VARCHAR2(8)   PATH '$."ORG_TACT_TIME_END_DATE"'   NULL ON EMPTY NULL ON ERROR)) JT;

    /* 삭제 (원래 키) */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE = 'D' THEN
        DELETE FROM SCP_MST_TACT_TIME_EXCEPT
         WHERE DIVISION_ID          = V_ROWS(I).ORG_DIVISION_ID
           AND PLANT_SITE_ID        = V_ROWS(I).ORG_PLANT_SITE_ID
           AND ITEM_ID              = V_ROWS(I).ORG_ITEM_ID
           AND OPERATION_ID         = V_ROWS(I).ORG_OPERATION_ID
           AND LINE_ID              = V_ROWS(I).ORG_LINE_ID
           AND TACT_TIME_START_DATE = V_ROWS(I).ORG_TACT_TIME_START_DATE
           AND TACT_TIME_END_DATE   = V_ROWS(I).ORG_TACT_TIME_END_DATE;
      END IF;
    END LOOP;

    /* 수정 (원래 키) */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE IN ('I', 'M') THEN
        UPDATE SCP_MST_TACT_TIME_EXCEPT
           SET TACT_TIME_START_DATE = V_ROWS(I).TACT_TIME_START_DATE
             , TACT_TIME_END_DATE   = V_ROWS(I).TACT_TIME_END_DATE
             , TACT_TIME            = TO_NUMBER(V_ROWS(I).TACT_TIME)
             , YIELD                = TO_NUMBER(V_ROWS(I).YIELD) / 100
             , EXCEPT_COMMENT       = V_ROWS(I).EXCEPT_COMMENT
             , USE_YN               = V_ROWS(I).USE_YN
             , LAST_UPDATED_BY      = P_USER_ID
             , LAST_UPDATE_DATE     = V_NOW
         WHERE DIVISION_ID          = V_ROWS(I).ORG_DIVISION_ID
           AND PLANT_SITE_ID        = V_ROWS(I).ORG_PLANT_SITE_ID
           AND ITEM_ID              = V_ROWS(I).ORG_ITEM_ID
           AND OPERATION_ID         = V_ROWS(I).ORG_OPERATION_ID
           AND LINE_ID              = V_ROWS(I).ORG_LINE_ID
           AND TACT_TIME_START_DATE = V_ROWS(I).ORG_TACT_TIME_START_DATE
           AND TACT_TIME_END_DATE   = V_ROWS(I).ORG_TACT_TIME_END_DATE;
      END IF;
    END LOOP;

    /* 신규 (새 키가 없을 때만) */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE IN ('I', 'M') THEN
        INSERT INTO SCP_MST_TACT_TIME_EXCEPT
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , TACT_TIME_START_DATE
             , TACT_TIME_END_DATE
             , TACT_TIME
             , YIELD
             , EXCEPT_COMMENT
             , USE_YN
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT V_ROWS(I).DIVISION_ID
             , V_ROWS(I).PLANT_SITE_ID
             , V_ROWS(I).ITEM_ID
             , V_ROWS(I).OPERATION_ID
             , V_ROWS(I).LINE_ID
             , V_ROWS(I).TACT_TIME_START_DATE
             , V_ROWS(I).TACT_TIME_END_DATE
             , TO_NUMBER(V_ROWS(I).TACT_TIME)
             , TO_NUMBER(V_ROWS(I).YIELD) / 100
             , V_ROWS(I).EXCEPT_COMMENT
             , V_ROWS(I).USE_YN
             , P_USER_ID
             , V_NOW
             , P_USER_ID
             , V_NOW
          FROM DUAL
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_MST_TACT_TIME_EXCEPT A
                            WHERE A.DIVISION_ID          = V_ROWS(I).DIVISION_ID
                              AND A.PLANT_SITE_ID        = V_ROWS(I).PLANT_SITE_ID
                              AND A.ITEM_ID              = V_ROWS(I).ITEM_ID
                              AND A.OPERATION_ID         = V_ROWS(I).OPERATION_ID
                              AND A.LINE_ID              = V_ROWS(I).LINE_ID
                              AND A.TACT_TIME_START_DATE = V_ROWS(I).TACT_TIME_START_DATE
                              AND A.TACT_TIME_END_DATE   = V_ROWS(I).TACT_TIME_END_DATE);
      END IF;
    END LOOP;

    /* 전 행 이력 (전송값) */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      INSERT INTO SCP_MST_TACT_TIME_EXCEPT_H
           ( HISTORY_SEQ
           , DIVISION_ID
           , PLANT_SITE_ID
           , ITEM_ID
           , OPERATION_ID
           , LINE_ID
           , TACT_TIME_START_DATE
           , TACT_TIME_END_DATE
           , TACT_TIME
           , YIELD
           , EXCEPT_COMMENT
           , USE_YN
           , CREATED_BY
           , CREATION_DATE
           , LAST_UPDATED_BY
           , LAST_UPDATE_DATE
           , HISTORY_CREATION_DATE )
      VALUES
           ( SEQ1_SCP_MST_TACT_TIME_EXCEPT_H.NEXTVAL
           , V_ROWS(I).DIVISION_ID
           , V_ROWS(I).PLANT_SITE_ID
           , V_ROWS(I).ITEM_ID
           , V_ROWS(I).OPERATION_ID
           , V_ROWS(I).LINE_ID
           , V_ROWS(I).TACT_TIME_START_DATE
           , V_ROWS(I).TACT_TIME_END_DATE
           , TO_NUMBER(V_ROWS(I).TACT_TIME)
           , TO_NUMBER(V_ROWS(I).YIELD)
           , V_ROWS(I).EXCEPT_COMMENT
           , V_ROWS(I).USE_YN
           , P_USER_ID
           , V_NOW
           , P_USER_ID
           , SYSDATE
           , SYSDATE );
    END LOOP;

    V_ROW_CNT := V_ROWS.COUNT;
    COMMIT;
    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
  EXCEPTION
    WHEN OTHERS THEN ROLLBACK; V_ERR_MSG := SQLERRM; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
  END P_SCP0020_SAVE_TACT_TIME_EXCEPT;
  -- 2026.09.18 저장 순서를 AS-IS 와 같게 다시 작성 (END)

---- ============================================================================
---- SAVE TACT TIME EXCEPT OSP (Packer 부모) — AS-IS SCP0020_SAVE_TACT_TIME_EXCEPT_OSP. DAILY_CAPACITY 포함.
---- ============================================================================
--PROCEDURE P_SCP0020_SAVE_TACT_TIME_EXCEPT_OSP(P_DATA IN CLOB, P_USER_ID IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
--  EX_BIZ_EX EXCEPTION; V_ERR_MSG VARCHAR2(4000); V_ROW_CNT NUMBER := 0; V_NOW DATE := SYSDATE;
--  PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
--BEGIN
--  FOR R IN (
--    SELECT TRIM(JT.CRUD_TYPE) CRUD_TYPE, TRIM(JT.DIVISION_ID) DIVISION_ID, TRIM(JT.PLANT_SITE_ID) PLANT_SITE_ID,
--           TRIM(JT.ITEM_ID) ITEM_ID, TRIM(JT.OPERATION_ID) OPERATION_ID, TRIM(JT.LINE_ID) LINE_ID,
--           TRIM(JT.TACT_TIME_START_DATE) TACT_TIME_START_DATE, TRIM(JT.TACT_TIME_END_DATE) TACT_TIME_END_DATE,
--           JT.TACT_TIME, JT.YIELD, JT.DAILY_CAPACITY, JT.EXCEPT_COMMENT, JT.USE_YN,
--           TRIM(JT.ORG_DIVISION_ID) ORG_DIVISION_ID, TRIM(JT.ORG_PLANT_SITE_ID) ORG_PLANT_SITE_ID,
--           TRIM(JT.ORG_ITEM_ID) ORG_ITEM_ID, TRIM(JT.ORG_OPERATION_ID) ORG_OPERATION_ID, TRIM(JT.ORG_LINE_ID) ORG_LINE_ID,
--           TRIM(JT.ORG_TACT_TIME_START_DATE) ORG_TACT_TIME_START_DATE, TRIM(JT.ORG_TACT_TIME_END_DATE) ORG_TACT_TIME_END_DATE
--    FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(
--      CRUD_TYPE VARCHAR2(10) PATH '$."CRUD_TYPE"' NULL ON EMPTY NULL ON ERROR,
--      DIVISION_ID VARCHAR2(60) PATH '$."DIVISION_ID"' NULL ON EMPTY NULL ON ERROR,
--      PLANT_SITE_ID VARCHAR2(60) PATH '$."PLANT_SITE_ID"' NULL ON EMPTY NULL ON ERROR,
--      ITEM_ID VARCHAR2(100) PATH '$."ITEM_ID"' NULL ON EMPTY NULL ON ERROR,
--      OPERATION_ID VARCHAR2(60) PATH '$."OPERATION_ID"' NULL ON EMPTY NULL ON ERROR,
--      LINE_ID VARCHAR2(100) PATH '$."LINE_ID"' NULL ON EMPTY NULL ON ERROR,
--      TACT_TIME_START_DATE VARCHAR2(8) PATH '$."TACT_TIME_START_DATE"' NULL ON EMPTY NULL ON ERROR,
--      TACT_TIME_END_DATE VARCHAR2(8) PATH '$."TACT_TIME_END_DATE"' NULL ON EMPTY NULL ON ERROR,
--      TACT_TIME VARCHAR2(50) PATH '$."TACT_TIME"' NULL ON EMPTY NULL ON ERROR,
--      YIELD VARCHAR2(50) PATH '$."YIELD"' NULL ON EMPTY NULL ON ERROR,
--      DAILY_CAPACITY VARCHAR2(50) PATH '$."DAILY_CAPACITY"' NULL ON EMPTY NULL ON ERROR,
--      EXCEPT_COMMENT VARCHAR2(400) PATH '$."EXCEPT_COMMENT"' NULL ON EMPTY NULL ON ERROR,
--      USE_YN VARCHAR2(10) PATH '$."USE_YN"' NULL ON EMPTY NULL ON ERROR,
--      ORG_DIVISION_ID VARCHAR2(60) PATH '$."ORG_DIVISION_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_PLANT_SITE_ID VARCHAR2(60) PATH '$."ORG_PLANT_SITE_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_ITEM_ID VARCHAR2(100) PATH '$."ORG_ITEM_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_OPERATION_ID VARCHAR2(60) PATH '$."ORG_OPERATION_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_LINE_ID VARCHAR2(100) PATH '$."ORG_LINE_ID"' NULL ON EMPTY NULL ON ERROR,
--      ORG_TACT_TIME_START_DATE VARCHAR2(8) PATH '$."ORG_TACT_TIME_START_DATE"' NULL ON EMPTY NULL ON ERROR,
--      ORG_TACT_TIME_END_DATE VARCHAR2(8) PATH '$."ORG_TACT_TIME_END_DATE"' NULL ON EMPTY NULL ON ERROR)) JT
--  ) LOOP
--    INSERT INTO SCP_MST_TACT_TIME_EXCEPT_OSP_H (HISTORY_SEQ, DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID,
--      TACT_TIME_START_DATE, TACT_TIME_END_DATE, TACT_TIME, YIELD, DAILY_CAPACITY, EXCEPT_COMMENT, USE_YN, CREATED_BY,
--      CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE)
--    VALUES (SEQ1_SCP_MST_TACT_TIME_EXCEPT_OSP_H.NEXTVAL, R.DIVISION_ID, R.PLANT_SITE_ID, R.ITEM_ID, R.OPERATION_ID, R.LINE_ID,
--      R.TACT_TIME_START_DATE, R.TACT_TIME_END_DATE, TO_NUMBER(R.TACT_TIME),
--      CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD) END,
--      CASE WHEN R.DAILY_CAPACITY IS NULL THEN NULL ELSE TO_NUMBER(R.DAILY_CAPACITY) END, R.EXCEPT_COMMENT, R.USE_YN,
--      P_USER_ID, V_NOW, P_USER_ID, SYSDATE, SYSDATE);
--
--    IF R.CRUD_TYPE = 'D' THEN
--      DELETE FROM SCP_MST_TACT_TIME_EXCEPT_OSP
--       WHERE DIVISION_ID = R.ORG_DIVISION_ID AND PLANT_SITE_ID = R.ORG_PLANT_SITE_ID AND ITEM_ID = R.ORG_ITEM_ID
--         AND OPERATION_ID = R.ORG_OPERATION_ID AND LINE_ID = R.ORG_LINE_ID
--         AND TACT_TIME_START_DATE = R.ORG_TACT_TIME_START_DATE AND TACT_TIME_END_DATE = R.ORG_TACT_TIME_END_DATE;
--    ELSIF R.CRUD_TYPE IN ('I', 'M') THEN
--      UPDATE SCP_MST_TACT_TIME_EXCEPT_OSP
--         SET TACT_TIME_START_DATE = R.TACT_TIME_START_DATE, TACT_TIME_END_DATE = R.TACT_TIME_END_DATE,
--             TACT_TIME = TO_NUMBER(R.TACT_TIME),
--             YIELD = CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END,
--             DAILY_CAPACITY = CASE WHEN R.DAILY_CAPACITY IS NULL THEN NULL ELSE TO_NUMBER(R.DAILY_CAPACITY) END,
--             EXCEPT_COMMENT = R.EXCEPT_COMMENT, USE_YN = R.USE_YN,
--             LAST_UPDATED_BY = P_USER_ID, LAST_UPDATE_DATE = V_NOW
--       WHERE DIVISION_ID = R.ORG_DIVISION_ID AND PLANT_SITE_ID = R.ORG_PLANT_SITE_ID AND ITEM_ID = R.ORG_ITEM_ID
--         AND OPERATION_ID = R.ORG_OPERATION_ID AND LINE_ID = R.ORG_LINE_ID
--         AND TACT_TIME_START_DATE = R.ORG_TACT_TIME_START_DATE AND TACT_TIME_END_DATE = R.ORG_TACT_TIME_END_DATE;
--      IF SQL%ROWCOUNT = 0 THEN
--        INSERT INTO SCP_MST_TACT_TIME_EXCEPT_OSP (DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID,
--          TACT_TIME_START_DATE, TACT_TIME_END_DATE, TACT_TIME, YIELD, DAILY_CAPACITY, EXCEPT_COMMENT, USE_YN,
--          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
--        VALUES (R.DIVISION_ID, R.PLANT_SITE_ID, R.ITEM_ID, R.OPERATION_ID, R.LINE_ID, R.TACT_TIME_START_DATE,
--          R.TACT_TIME_END_DATE, TO_NUMBER(R.TACT_TIME),
--          CASE WHEN R.YIELD IS NULL THEN NULL ELSE TO_NUMBER(R.YIELD)/100 END,
--          CASE WHEN R.DAILY_CAPACITY IS NULL THEN NULL ELSE TO_NUMBER(R.DAILY_CAPACITY) END, R.EXCEPT_COMMENT, R.USE_YN,
--          P_USER_ID, V_NOW, P_USER_ID, V_NOW);
--      END IF;
--    END IF;
--    V_ROW_CNT := V_ROW_CNT + 1;
--  END LOOP;
--  COMMIT;
--  OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
--EXCEPTION
--  WHEN EX_BIZ_EX THEN ROLLBACK; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
--  WHEN OTHERS THEN ROLLBACK; V_ERR_MSG := SQLERRM; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
--END P_SCP0020_SAVE_TACT_TIME_EXCEPT_OSP;
  -- 2026.09.18 저장 순서를 AS-IS 와 같게 다시 작성 · 이력 ATTRIBUTE1 = 처리구분 (START)
  --   AS-IS 처리 순서 : 삭제(원래 키) → 수정(원래 키) → 신규(새 키가 없을 때만) → 전 행 이력(전송값)
  PROCEDURE P_SCP0020_SAVE_TACT_TIME_EXCEPT_OSP(P_DATA IN CLOB, P_USER_ID IN VARCHAR2, O_RESULT_CURSOR OUT SYS_REFCURSOR) IS
    V_ERR_MSG VARCHAR2(4000); V_ROW_CNT NUMBER := 0; V_NOW DATE := SYSDATE;
    TYPE T_ROW IS RECORD (
      CRUD_TYPE                VARCHAR2(10),
      DIVISION_ID              VARCHAR2(60),
      PLANT_SITE_ID            VARCHAR2(60),
      ITEM_ID                  VARCHAR2(100),
      OPERATION_ID             VARCHAR2(60),
      LINE_ID                  VARCHAR2(100),
      TACT_TIME_START_DATE     VARCHAR2(8),
      TACT_TIME_END_DATE       VARCHAR2(8),
      TACT_TIME                VARCHAR2(50),
      YIELD                    VARCHAR2(50),
      DAILY_CAPACITY           VARCHAR2(50),
      EXCEPT_COMMENT           VARCHAR2(400),
      USE_YN                   VARCHAR2(10),
      ORG_DIVISION_ID          VARCHAR2(60),
      ORG_PLANT_SITE_ID        VARCHAR2(60),
      ORG_ITEM_ID              VARCHAR2(100),
      ORG_OPERATION_ID         VARCHAR2(60),
      ORG_LINE_ID              VARCHAR2(100),
      ORG_TACT_TIME_START_DATE VARCHAR2(8),
      ORG_TACT_TIME_END_DATE   VARCHAR2(8));
    TYPE T_ROWS IS TABLE OF T_ROW;
    V_ROWS T_ROWS;
  BEGIN
    SELECT TRIM(JT.CRUD_TYPE)
         , TRIM(JT.DIVISION_ID)
         , TRIM(JT.PLANT_SITE_ID)
         , TRIM(JT.ITEM_ID)
         , TRIM(JT.OPERATION_ID)
         , TRIM(JT.LINE_ID)
         , TRIM(JT.TACT_TIME_START_DATE)
         , TRIM(JT.TACT_TIME_END_DATE)
         , JT.TACT_TIME
         , JT.YIELD
         , JT.DAILY_CAPACITY
         , JT.EXCEPT_COMMENT
         , JT.USE_YN
         , TRIM(JT.ORG_DIVISION_ID)
         , TRIM(JT.ORG_PLANT_SITE_ID)
         , TRIM(JT.ORG_ITEM_ID)
         , TRIM(JT.ORG_OPERATION_ID)
         , TRIM(JT.ORG_LINE_ID)
         , TRIM(JT.ORG_TACT_TIME_START_DATE)
         , TRIM(JT.ORG_TACT_TIME_END_DATE)
      BULK COLLECT INTO V_ROWS
      FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(
             CRUD_TYPE                VARCHAR2(10)  PATH '$."CRUD_TYPE"'                NULL ON EMPTY NULL ON ERROR,
             DIVISION_ID              VARCHAR2(60)  PATH '$."DIVISION_ID"'              NULL ON EMPTY NULL ON ERROR,
             PLANT_SITE_ID            VARCHAR2(60)  PATH '$."PLANT_SITE_ID"'            NULL ON EMPTY NULL ON ERROR,
             ITEM_ID                  VARCHAR2(100) PATH '$."ITEM_ID"'                  NULL ON EMPTY NULL ON ERROR,
             OPERATION_ID             VARCHAR2(60)  PATH '$."OPERATION_ID"'             NULL ON EMPTY NULL ON ERROR,
             LINE_ID                  VARCHAR2(100) PATH '$."LINE_ID"'                  NULL ON EMPTY NULL ON ERROR,
             TACT_TIME_START_DATE     VARCHAR2(8)   PATH '$."TACT_TIME_START_DATE"'     NULL ON EMPTY NULL ON ERROR,
             TACT_TIME_END_DATE       VARCHAR2(8)   PATH '$."TACT_TIME_END_DATE"'       NULL ON EMPTY NULL ON ERROR,
             TACT_TIME                VARCHAR2(50)  PATH '$."TACT_TIME"'                NULL ON EMPTY NULL ON ERROR,
             YIELD                    VARCHAR2(50)  PATH '$."YIELD"'                    NULL ON EMPTY NULL ON ERROR,
             DAILY_CAPACITY           VARCHAR2(50)  PATH '$."DAILY_CAPACITY"'           NULL ON EMPTY NULL ON ERROR,
             EXCEPT_COMMENT           VARCHAR2(400) PATH '$."EXCEPT_COMMENT"'           NULL ON EMPTY NULL ON ERROR,
             USE_YN                   VARCHAR2(10)  PATH '$."USE_YN"'                   NULL ON EMPTY NULL ON ERROR,
             ORG_DIVISION_ID          VARCHAR2(60)  PATH '$."ORG_DIVISION_ID"'          NULL ON EMPTY NULL ON ERROR,
             ORG_PLANT_SITE_ID        VARCHAR2(60)  PATH '$."ORG_PLANT_SITE_ID"'        NULL ON EMPTY NULL ON ERROR,
             ORG_ITEM_ID              VARCHAR2(100) PATH '$."ORG_ITEM_ID"'              NULL ON EMPTY NULL ON ERROR,
             ORG_OPERATION_ID         VARCHAR2(60)  PATH '$."ORG_OPERATION_ID"'         NULL ON EMPTY NULL ON ERROR,
             ORG_LINE_ID              VARCHAR2(100) PATH '$."ORG_LINE_ID"'              NULL ON EMPTY NULL ON ERROR,
             ORG_TACT_TIME_START_DATE VARCHAR2(8)   PATH '$."ORG_TACT_TIME_START_DATE"' NULL ON EMPTY NULL ON ERROR,
             ORG_TACT_TIME_END_DATE   VARCHAR2(8)   PATH '$."ORG_TACT_TIME_END_DATE"'   NULL ON EMPTY NULL ON ERROR)) JT;

    /* 삭제 (원래 키) */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE = 'D' THEN
        DELETE FROM SCP_MST_TACT_TIME_EXCEPT_OSP
         WHERE DIVISION_ID          = V_ROWS(I).ORG_DIVISION_ID
           AND PLANT_SITE_ID        = V_ROWS(I).ORG_PLANT_SITE_ID
           AND ITEM_ID              = V_ROWS(I).ORG_ITEM_ID
           AND OPERATION_ID         = V_ROWS(I).ORG_OPERATION_ID
           AND LINE_ID              = V_ROWS(I).ORG_LINE_ID
           AND TACT_TIME_START_DATE = V_ROWS(I).ORG_TACT_TIME_START_DATE
           AND TACT_TIME_END_DATE   = V_ROWS(I).ORG_TACT_TIME_END_DATE;
      END IF;
    END LOOP;

    /* 수정 (원래 키) */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE IN ('I', 'M') THEN
        UPDATE SCP_MST_TACT_TIME_EXCEPT_OSP
           SET TACT_TIME_START_DATE = V_ROWS(I).TACT_TIME_START_DATE
             , TACT_TIME_END_DATE   = V_ROWS(I).TACT_TIME_END_DATE
             , TACT_TIME            = TO_NUMBER(V_ROWS(I).TACT_TIME)
             , YIELD                = TO_NUMBER(V_ROWS(I).YIELD) / 100
             , DAILY_CAPACITY       = TO_NUMBER(V_ROWS(I).DAILY_CAPACITY)
             , EXCEPT_COMMENT       = V_ROWS(I).EXCEPT_COMMENT
             , USE_YN               = V_ROWS(I).USE_YN
             , LAST_UPDATED_BY      = P_USER_ID
             , LAST_UPDATE_DATE     = V_NOW
         WHERE DIVISION_ID          = V_ROWS(I).ORG_DIVISION_ID
           AND PLANT_SITE_ID        = V_ROWS(I).ORG_PLANT_SITE_ID
           AND ITEM_ID              = V_ROWS(I).ORG_ITEM_ID
           AND OPERATION_ID         = V_ROWS(I).ORG_OPERATION_ID
           AND LINE_ID              = V_ROWS(I).ORG_LINE_ID
           AND TACT_TIME_START_DATE = V_ROWS(I).ORG_TACT_TIME_START_DATE
           AND TACT_TIME_END_DATE   = V_ROWS(I).ORG_TACT_TIME_END_DATE;
      END IF;
    END LOOP;

    /* 신규 (새 키가 없을 때만) */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      IF V_ROWS(I).CRUD_TYPE IN ('I', 'M') THEN
        INSERT INTO SCP_MST_TACT_TIME_EXCEPT_OSP
             ( DIVISION_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , TACT_TIME_START_DATE
             , TACT_TIME_END_DATE
             , TACT_TIME
             , YIELD
             , DAILY_CAPACITY
             , EXCEPT_COMMENT
             , USE_YN
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT V_ROWS(I).DIVISION_ID
             , V_ROWS(I).PLANT_SITE_ID
             , V_ROWS(I).ITEM_ID
             , V_ROWS(I).OPERATION_ID
             , V_ROWS(I).LINE_ID
             , V_ROWS(I).TACT_TIME_START_DATE
             , V_ROWS(I).TACT_TIME_END_DATE
             , TO_NUMBER(V_ROWS(I).TACT_TIME)
             , TO_NUMBER(V_ROWS(I).YIELD) / 100
             , TO_NUMBER(V_ROWS(I).DAILY_CAPACITY)
             , V_ROWS(I).EXCEPT_COMMENT
             , V_ROWS(I).USE_YN
             , P_USER_ID
             , V_NOW
             , P_USER_ID
             , V_NOW
          FROM DUAL
         WHERE NOT EXISTS (SELECT 1
                             FROM SCP_MST_TACT_TIME_EXCEPT_OSP A
                            WHERE A.DIVISION_ID          = V_ROWS(I).DIVISION_ID
                              AND A.PLANT_SITE_ID        = V_ROWS(I).PLANT_SITE_ID
                              AND A.ITEM_ID              = V_ROWS(I).ITEM_ID
                              AND A.OPERATION_ID         = V_ROWS(I).OPERATION_ID
                              AND A.LINE_ID              = V_ROWS(I).LINE_ID
                              AND A.TACT_TIME_START_DATE = V_ROWS(I).TACT_TIME_START_DATE
                              AND A.TACT_TIME_END_DATE   = V_ROWS(I).TACT_TIME_END_DATE);
      END IF;
    END LOOP;

    /* 전 행 이력 (전송값) */
    FOR I IN 1 .. V_ROWS.COUNT LOOP
      INSERT INTO SCP_MST_TACT_TIME_EXCEPT_OSP_H
           ( HISTORY_SEQ
           , DIVISION_ID
           , PLANT_SITE_ID
           , ITEM_ID
           , OPERATION_ID
           , LINE_ID
           , TACT_TIME_START_DATE
           , TACT_TIME_END_DATE
           , TACT_TIME
           , YIELD
           , DAILY_CAPACITY
           , EXCEPT_COMMENT
           , USE_YN
           , CREATED_BY
           , CREATION_DATE
           , LAST_UPDATED_BY
           , LAST_UPDATE_DATE
           , HISTORY_CREATION_DATE
           , ATTRIBUTE1 )
      VALUES
           ( SEQ1_SCP_MST_TACT_TIME_EXCEPT_OSP_H.NEXTVAL
           , V_ROWS(I).DIVISION_ID
           , V_ROWS(I).PLANT_SITE_ID
           , V_ROWS(I).ITEM_ID
           , V_ROWS(I).OPERATION_ID
           , V_ROWS(I).LINE_ID
           , V_ROWS(I).TACT_TIME_START_DATE
           , V_ROWS(I).TACT_TIME_END_DATE
           , TO_NUMBER(V_ROWS(I).TACT_TIME)
           , TO_NUMBER(V_ROWS(I).YIELD)
           , TO_NUMBER(V_ROWS(I).DAILY_CAPACITY)
           , V_ROWS(I).EXCEPT_COMMENT
           , V_ROWS(I).USE_YN
           , P_USER_ID
           , V_NOW
           , P_USER_ID
           , SYSDATE
           , SYSDATE
           , V_ROWS(I).CRUD_TYPE );
    END LOOP;

    V_ROW_CNT := V_ROWS.COUNT;
    COMMIT;
    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
  EXCEPTION
    WHEN OTHERS THEN ROLLBACK; V_ERR_MSG := SQLERRM; OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
  END P_SCP0020_SAVE_TACT_TIME_EXCEPT_OSP;
  -- 2026.09.18 저장 순서를 AS-IS 와 같게 다시 작성 (END)

END PKG_SCP0020;
/
SHOW ERRORS PACKAGE BODY PKG_SCP0020
