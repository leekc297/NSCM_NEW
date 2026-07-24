# -*- coding: utf-8 -*-
"""PKG_DMF0005 GET PRODUCTION perf patch — anchor exact-match, assert 1 occurrence each.
원본: _backup/PKG_DMF0005_body_original.sql -> 산출: 01_PKG_DMF0005_body_tuned.sql
변경 5점 (마커 [PERF-DMF0005 20260722]):
  P1 GTT 사전적재 블록 (FN_SPLITSTRING 인라인 제거 대체)
  P2 F_ITEM/F_PROJECT/F_OWNER CTE -> OWNER_NM CTE (DISTINCT OWNER 367건만 함수 호출)
  P3 BASE 행별 FN_GET_MULTI_OWNER_NAME -> ONM.OWNER_NAME
  P4 BASE LEFT JOIN OWNER_NM 추가
  P5 BF 필터 7종 -> (없음/'ALL' skip OR EXISTS GT_GGET_SPLIT_*)
"""
import io, os, sys

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(BASE_DIR, "_backup", "PKG_DMF0005_body_original.sql")
DST = os.path.join(BASE_DIR, "01_PKG_DMF0005_body_tuned.sql")

with io.open(SRC, "r", encoding="utf-8") as f:
    body = f.read()

def patch(old, new, label):
    global body
    n = body.count(old)
    assert n == 1, f"[{label}] anchor count={n} (expected 1)"
    body = body.replace(old, new)
    print("patched:", label)

# ---------------- P1: GTT pre-load block (after admin-group SELECT, before OPEN O_RC1) ----------------
P1_OLD = """                         AND    UNIT_ID = P_DIVISION_ID )
     ;

    OPEN O_RC1 FOR
    WITH
      ITEM_AGG AS ("""
P1_NEW = """                         AND    UNIT_ID = P_DIVISION_ID )
     ;

    -- [PERF-DMF0005 20260722] P1: 멀티선택 필터 GTT 사전적재 (FN_SPLITSTRING 인라인 제거)
    --  값이 있을 때만 적재. 없음/'ALL' 이면 미적재 -> 쿼리 FILTER 가 GTT 접근 자체를 생략(runtime skip)
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_TEAM_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_CUSTOMER;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_SCM_SITE_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_VALID_YN;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_OWNER;

    IF P_DEPT_ID IS NOT NULL AND P_DEPT_ID <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_TEAM_ID (TOK)
        SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DEPT_ID, ',')) WHERE VALUE IS NOT NULL;
    END IF;

    IF P_END_CUSTOMER IS NOT NULL AND P_END_CUSTOMER <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_CUSTOMER (TOK)
        SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_END_CUSTOMER, ',')) WHERE VALUE IS NOT NULL;
    END IF;

    IF P_SCM_SITE_ID IS NOT NULL AND P_SCM_SITE_ID <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_SCM_SITE_ID (TOK)
        SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_SCM_SITE_ID, ',')) WHERE VALUE IS NOT NULL;
    END IF;

    IF P_VALID_YN IS NOT NULL AND P_VALID_YN <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_VALID_YN (TOK)
        SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_VALID_YN, ',')) WHERE VALUE IS NOT NULL;
    END IF;

    IF NVL(NULLIF(TRIM(P_ITEM_ID), ''), 'ALL') <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK)
        SELECT TRIM(VALUE) FROM TABLE(FN_SPLITSTRING(P_ITEM_ID, ',')) WHERE TRIM(VALUE) IS NOT NULL;
    END IF;

    IF NVL(NULLIF(TRIM(P_PROJECT_CODE), ''), 'ALL') <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE (TOK)
        SELECT TRIM(VALUE) FROM TABLE(FN_SPLITSTRING(P_PROJECT_CODE, ',')) WHERE TRIM(VALUE) IS NOT NULL;
    END IF;

    IF NVL(NULLIF(TRIM(P_OWNER), ''), 'ALL') <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_OWNER (TOK)
        SELECT TRIM(VALUE) FROM TABLE(FN_SPLITSTRING(P_OWNER, ',')) WHERE TRIM(VALUE) IS NOT NULL;
    END IF;

    OPEN O_RC1 FOR
    WITH
      ITEM_AGG AS ("""
patch(P1_OLD, P1_NEW, "P1 GTT preload")

# ---------------- P2: F_ITEM/F_PROJECT/F_OWNER CTE -> OWNER_NM CTE ----------------
P2_OLD = """      F_ITEM AS (
          SELECT TRIM(VALUE) AS TOKEN
          FROM TABLE(FN_SPLITSTRING(P_ITEM_ID, ','))
          WHERE TRIM(VALUE) IS NOT NULL
      ),
      F_PROJECT AS (
          SELECT TRIM(VALUE) AS TOKEN
          FROM TABLE(FN_SPLITSTRING(P_PROJECT_CODE, ','))
          WHERE TRIM(VALUE) IS NOT NULL
      ),
      F_OWNER AS (
          SELECT TRIM(VALUE) AS TOKEN
          FROM TABLE(FN_SPLITSTRING(P_OWNER, ','))
          WHERE TRIM(VALUE) IS NOT NULL
      ),
"""
P2_NEW = """      /* [PERF-DMF0005 20260722] P2: F_ITEM/F_PROJECT/F_OWNER CTE 제거 (GT_GGET_SPLIT_* 사전적재로 대체)
         + OWNER_NAME 은 행별(52,526회) 함수 호출 대신 DISTINCT OWNER(수백건)만 1회씩 호출 */
      OWNER_NM AS (
          SELECT O.OWNER
               , FN_GET_MULTI_OWNER_NAME(O.OWNER, ',', '1') AS OWNER_NAME
          FROM ( SELECT DISTINCT SI0.OWNER
                 FROM SCM_MST_SITE_ITEM SI0
                 WHERE SI0.DIVISION_ID = P_DIVISION_ID
                   AND SI0.OWNER IS NOT NULL ) O
      ),
"""
patch(P2_OLD, P2_NEW, "P2 OWNER_NM cte")

# ---------------- P3: per-row function -> joined column ----------------
P3_OLD = "            , FN_GET_MULTI_OWNER_NAME(SI.OWNER, ',', '1') AS OWNER_NAME"
P3_NEW = "            , ONM.OWNER_NAME AS OWNER_NAME -- [PERF-DMF0005 20260722] P3: 행별 함수 -> OWNER_NM 조인"
patch(P3_OLD, P3_NEW, "P3 owner name column")

# ---------------- P4: LEFT JOIN OWNER_NM in BASE ----------------
P4_OLD = """         AND CM.ITEM_ID = SI.ITEM_ID
        WHERE SI.DIVISION_ID = P_DIVISION_ID"""
P4_NEW = """         AND CM.ITEM_ID = SI.ITEM_ID
        LEFT JOIN OWNER_NM ONM -- [PERF-DMF0005 20260722] P4
          ON ONM.OWNER = SI.OWNER
        WHERE SI.DIVISION_ID = P_DIVISION_ID"""
patch(P4_OLD, P4_NEW, "P4 left join owner_nm")

# ---------------- P5: BF filters -> GTT (skip join when empty/'ALL') ----------------
P5_OLD = """        WHERE (P_DEPT_ID = 'ALL'      OR B.DEPT_ID        IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DEPT_ID, ','))))
          AND (P_END_CUSTOMER = 'ALL' OR B.END_CUSTOMER   IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_END_CUSTOMER, ',')))


          )
          AND (P_SCM_SITE_ID = 'ALL'  OR B.SCM_SITE_ID    IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_SCM_SITE_ID, ','))))
          AND (P_VALID_YN = 'ALL'     OR B.VALID_YN       IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_VALID_YN, ','))))

          AND (
                NVL(NULLIF(TRIM(P_ITEM_ID), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM F_ITEM X
                      WHERE TRIM(X.TOKEN) IS NOT NULL
                        AND (
                             NVL(B.ITEM_ID, '')   LIKE '%' || TRIM(X.TOKEN) || '%'
                          OR NVL(B.NICK_NAME, '') LIKE '%' || TRIM(X.TOKEN) || '%'
                        )
                )
          )
          AND (
                NVL(NULLIF(TRIM(P_PROJECT_CODE), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM F_PROJECT X
                      WHERE TRIM(X.TOKEN) IS NOT NULL
                        AND (
                             NVL(B.PROJECT_CODE, '') LIKE '%' || TRIM(X.TOKEN) || '%'
                          OR NVL(B.PROJECT_NAME, '') LIKE '%' || TRIM(X.TOKEN) || '%'
                        )
                )
          )
          AND (
                NVL(NULLIF(TRIM(P_OWNER), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM F_OWNER X
                      WHERE TRIM(X.TOKEN) IS NOT NULL
                        AND (
                             NVL(B.OWNER, '')      LIKE '%' || TRIM(X.TOKEN) || '%'
                          OR NVL(B.OWNER_NAME, '') LIKE '%' || TRIM(X.TOKEN) || '%'
                        )
                )
          )"""
P5_NEW = """        /* [PERF-DMF0005 20260722] P5: 인라인 FN_SPLITSTRING -> GT_GGET_SPLIT_* 사전적재 EXISTS.
           없음(NULL)/'ALL' 이면 OR 단락으로 GTT 미접근 (PKG_DMF0003 선례 동일 패턴) */
        WHERE (P_DEPT_ID IS NULL OR P_DEPT_ID = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_TEAM_ID X WHERE B.DEPT_ID = X.TOK))
          AND (P_END_CUSTOMER IS NULL OR P_END_CUSTOMER = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_CUSTOMER X WHERE B.END_CUSTOMER = X.TOK))
          AND (P_SCM_SITE_ID IS NULL OR P_SCM_SITE_ID = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_SCM_SITE_ID X WHERE B.SCM_SITE_ID = X.TOK))
          AND (P_VALID_YN IS NULL OR P_VALID_YN = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_VALID_YN X WHERE B.VALID_YN = X.TOK))
          AND (
                NVL(NULLIF(TRIM(P_ITEM_ID), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID X
                      WHERE NVL(B.ITEM_ID, '')   LIKE '%' || X.TOK || '%'
                         OR NVL(B.NICK_NAME, '') LIKE '%' || X.TOK || '%'
                )
          )
          AND (
                NVL(NULLIF(TRIM(P_PROJECT_CODE), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE X
                      WHERE NVL(B.PROJECT_CODE, '') LIKE '%' || X.TOK || '%'
                         OR NVL(B.PROJECT_NAME, '') LIKE '%' || X.TOK || '%'
                )
          )
          AND (
                NVL(NULLIF(TRIM(P_OWNER), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM SCM_MGR.GT_GGET_SPLIT_OWNER X
                      WHERE NVL(B.OWNER, '')      LIKE '%' || X.TOK || '%'
                         OR NVL(B.OWNER_NAME, '') LIKE '%' || X.TOK || '%'
                )
          )"""
patch(P5_OLD, P5_NEW, "P5 BF filters")

# ---------------- P6: DM_MST_ITEM_SINGLE_V 조인 제거 (ITEM_AGG 등가 대체) ----------------
# 근거: BASE 가 ISV 에서 쓰는 5컬럼(ITEM_TYPE/ITEM_CLASS_NAME/ITEM_NAME/NICK_NAME/ACTIVE_FLAG)은
#       ITEM_AGG(동일 SCM_MST_ITEM_SN, 동일 GROUP BY DIVISION_ID+ITEM_ID, 동일 집계식)와 등가.
#       ISV 내부 prefix self-join(230M 추정) = FORECAST_INFO_* 용도로 BASE 미사용 + INNER JOIN 무손실.
P6A_OLD = """              , MAX(T.ENERGE) AS ENERGE_WH
              , MAX(T.CELL_TYPE) AS CELL_TYPE_CD
          FROM SCM_MST_ITEM_SN T"""
P6A_NEW = """              , MAX(T.ENERGE) AS ENERGE_WH
              , MAX(T.CELL_TYPE) AS CELL_TYPE_CD
              , MAX(T.ACTIVE_FLAG) AS MDM_ACTIVE_FLAG -- [PERF-DMF0005 20260722] P6a: ISV.ACTIVE_FLAG 등가
          FROM SCM_MST_ITEM_SN T"""
patch(P6A_OLD, P6A_NEW, "P6a ITEM_AGG active_flag")

patch("            , ISV.ITEM_TYPE\n", "            , IA.ITEM_TYPE -- [PERF-DMF0005 20260722] P6b\n", "P6b item_type")
patch("            , ISV.ITEM_CLASS_NAME\n", "            , IA.ITEM_CLASS_NAME -- [PERF-DMF0005 20260722] P6b\n", "P6b item_class_name")
patch("            , ISV.ITEM_NAME\n", "            , IA.ITEM_NAME -- [PERF-DMF0005 20260722] P6b\n", "P6b item_name")
patch("            , ISV.NICK_NAME\n", "            , IA.NICK_NAME -- [PERF-DMF0005 20260722] P6b\n", "P6b nick_name")
patch("            , ISV.ACTIVE_FLAG AS MDM_ACTIVE\n", "            , IA.MDM_ACTIVE_FLAG AS MDM_ACTIVE -- [PERF-DMF0005 20260722] P6b\n", "P6b mdm_active")

P6C_OLD = """        LEFT JOIN DM_MST_ITEM_SINGLE_V ISV
          ON ISV.DIVISION_ID = SI.DIVISION_ID
         AND ISV.ITEM_ID = SI.ITEM_ID
        LEFT JOIN SCM_MST_PROJECT PRJ"""
P6C_NEW = """        /* [PERF-DMF0005 20260722] P6c: DM_MST_ITEM_SINGLE_V 조인 제거 — ITEM_AGG(IA) 등가 대체 */
        LEFT JOIN SCM_MST_PROJECT PRJ"""
patch(P6C_OLD, P6C_NEW, "P6c drop ISV join")

with io.open(DST, "w", encoding="utf-8", newline="") as f:
    f.write(body)
print("written:", DST, "lines:", body.count("\n"))
print("marker count:", body.count("[PERF-DMF0005 20260722]"))
