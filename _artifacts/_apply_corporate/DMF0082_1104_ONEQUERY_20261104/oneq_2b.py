# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] 2-B: 버전(MF/SF/SP) arm 포함 S2 — 원문 L493~534 (T_VERSION) · L1344~1432 (FCST_C/PRICE_C)
   · L2368~3697 (버전 arm 24) · L3939~4115 (SP 파생 + 삭제) 를 2-A S2 INSERT 에 흡수. Current arm 은 2-A 와 동일."""
import re
from oneq_blocks import (arm, s2_fcst_n_price_current, FNP_LIST, C_ATTR, C_SEL, KEY8, D81, D40, LD_JOIN, G_CUR, B_MAP)

VGATE = "(NVL(p_version_type,'~') LIKE '%SP%' OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')"
C4 = "ON  C.DIVISION_ID = A.DIVISION_ID AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID"
CUT = ("A.CUTOFF_YYYYMMDD_DATE BETWEEN TO_DATE(CASE WHEN V_CUTOFF_FROM = '00000000' THEN '19000101' ELSE V_CUTOFF_FROM END, 'YYYYMMDD')"
       " AND TO_DATE(CASE WHEN V_CUTOFF_TO = '99999999' THEN '99991231' ELSE V_CUTOFF_TO END, 'YYYYMMDD')")
K8G = "A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE"


def _ver_ctes():
    """LDC/LDC8 (L1348~1388 + 소비처 8키 KEEP) · LPC (L1392~1431). VER = 원문 L493~541 T_VERSION GTT 적재 그대로(build.py) · 참조는 oneq_split 이 GTT 로."""
    return f"""    ), LDC AS (  /* L1348~1388 FCST_C (9키 = 8키 + VERSION_NO) */
        SELECT {K8G}, A.VERSION_NO
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C {C4}
        INNER JOIN VER V ON V.VERSION_NO = A.VERSION_NO
        WHERE  {D81}
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        AND    {CUT}
        GROUP BY {K8G}, A.VERSION_NO
        UNION ALL
        SELECT {K8G}, A.VERSION_NO
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C {C4}
        INNER JOIN VER V ON V.VERSION_NO = A.VERSION_NO
        WHERE  {D40}
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        AND    {CUT}
        GROUP BY {K8G}, A.VERSION_NO
    ), LDC8 AS (  /* 소비처(L2448 등) 8키 재집계: MAX(CREATE_DATE) · LAST_UPDATED_BY KEEP LAST BY CREATE_DATE — 버전 간 합침 */
        SELECT {KEY8}
             , MAX(CREATE_DATE) AS CREATE_DATE
             , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
        FROM   LDC
        GROUP BY {KEY8}
    ), LPC AS (  /* L1392~1431 PRICE_C (8키 · 버전 미구분 = 이상⑤ 재현) */
        SELECT {K8G}
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C {C4}
        INNER JOIN VER V ON V.VERSION_NO = A.VERSION_NO
        WHERE  {D81}
        AND    A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        GROUP BY {K8G}
        UNION ALL
        SELECT {K8G}
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C {C4}
        INNER JOIN VER V ON V.VERSION_NO = A.VERSION_NO
        WHERE  {D40}
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        AND    {CUT}
        GROUP BY {K8G}"""


def _ldj(src):
    return LD_JOIN.replace("LEFT JOIN LD\n", f"LEFT JOIN {src} LD\n")


def _version_arms(t, div='ALL'):
    """t = 'MF' | 'SF' | 'SP' — 원문 L2368~2940 (MF) · L2945~3518 (SF) · L3524~3697 (SP). div 로 사업부 arm 만 (81: 1·3·5·P1·R / 82: 1·3·P1·R / 40: 2·4·P2·R)"""
    fj = f"\n        INNER JOIN VER F\n            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE '{t}%'"
    fj_sp = f"\n        INNER JOIN (SELECT * FROM VER WHERE VERSION_NO LIKE '{t}%') F\n            ON  A.VERSION_NO = F.SP_VERSION_NO"
    b_eq = "        INNER JOIN MEA B\n            ON  B.MEASURE = A.MEASURE"
    b_pp = "        INNER JOIN MEA B\n            ON  A.MEASURE = 'MKT_FCST' AND B.MEASURE = 'MKT_FCST_PP'"
    b_res = "        INNER JOIN MEA B\n            ON  B.RESULT_MEASURE = A.MEASURE"
    b_amt = "        INNER JOIN MEA B\n            ON  B.MEASURE = A.MEASURE\n            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'"
    w_dem = "        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD\n        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD\n        AND    A.QTY <> 0"
    w_pp = "        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD\n        AND    A.QTY <> 0"
    w_res = "        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT\n        AND    A.QTY <> 0"
    w_pr81 = "        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO\n        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD\n        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD"
    w_pr40 = "        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD\n        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD"
    v, cut = "F.VERSION_NO", "A.CUTOFF_YYYYMMDD"
    wd81 = D81 + " AND A.DIVISION_ID = p_division_id"
    wd40 = D40 + " AND A.DIVISION_ID = p_division_id"
    arms = []
    if t in ("MF", "SF"):
        L = "L2372~2476" if t == "MF" else "L2952~3056"
        # [E20261104-DMF0082PPMERGE] 수요(1/2, w_dem = NOW_YYYYMMDD 이후만) + MKT_FCST_PP(3/4, w_pp = NOW 조건 없음) 를 같은 원장 1회 읽기로 병합 —
        #   구 3/4 의 키 없는 MEA 교차조인(옵티마이저 1행 추정 → _C 원장 PART 인덱스 행별 NL · 원본 41pw924h8q09f/81amysyk2avt0 동일 계획) 제거.
        #   WHERE 차이는 (M.PP='Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD) 로 보존 · MEASURE 출력만 M.PP 분기(구 1/2 = A.MEASURE 그대로) · LU/LD/NOTATION 동일.
        w_dem_pp = w_pp + "\n        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)"
        meas_raw_map = "CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END"
        arms += [
            arm(f"{t}1 {L} 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회)", "SCM_MGR.DM_PLN_MKT_FCST_C", wd81, w_dem_pp, B_MAP,
                meas=meas_raw_map, ver=v, cutoff=cut, extra_from=fj, ld_join=_ldj("LDC8")),
            arm(f"{t}2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회)", "SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C", wd40, w_dem_pp, B_MAP,
                ec="A.END_CUSTOMER", cp="A.CELL_PROD_SITE_ID", meas=meas_raw_map, ver=v, cutoff=cut, extra_from=fj, ld_join=_ldj("LDC8")),
            arm(f"{t}5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계)",
                f"""( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN_C S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.VERSION_NO IN (SELECT V.SP_VERSION_NO FROM VER V WHERE V.VERSION_NO LIKE '{t}%')
                AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                       , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD )""",
                "p_division_id LIKE '81%'", "        AND    A.QTY <> 0", b_amt, afs="' '", cd="A.CREATE_DATE", lu="A.LAST_UPDATED_BY",
                notation="'POINT3'", ver=v, cutoff=cut, extra_from=fj_sp, ld_join=""),
        ]
    # 판가 (MF/SF/SP 공통 형태) — 40 의 END_CUSTOMER: MF = A.PROJECT_CODE (L2837 · 이상①) / SF·SP = A.END_CUSTOMER
    ec40 = "A.PROJECT_CODE" if t == "MF" else "A.END_CUSTOMER"
    arms += [
        arm(f"{t}P1 판가 81/82 (SCM_MST_FUTURE_PRICE_C)", "SCM_MGR.SCM_MST_FUTURE_PRICE_C", wd81, w_pr81, b_eq,
            qty="NVL(A.PRICE, 0)", afs="' '", cur="A.CURRENCY", ver=v, cutoff=cut, extra_from=fj, ld_join=_ldj("LPC")),
        arm(f"{t}P2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC={ec40}", "SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C", wd40, w_pr40, b_eq,
            ec=ec40, cp="A.CELL_PROD_SITE_ID", qty="NVL(A.PRICE, 0)", afs="' '", cur="A.CURRENCY", ver=v, cutoff=cut, extra_from=fj, ld_join=_ldj("LPC")),
        arm(f"{t}R 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE)", "SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C", "A.DIVISION_ID = p_division_id", w_res, b_res,
            cp="A.CELL_PROD_SITE_ID", cur="A.CURRENCY", ver=v, cutoff=cut, extra_from=fj_sp, ld_join=_ldj("LDC8")),
    ]
    tag = {'81': ('1', '5', 'P1', 'R'), '82': ('1', 'P1', 'R'), '40': ('2', 'P2', 'R')}.get(div)   # 3/4 는 1/2 에 병합
    if tag:
        arms = [a for a in arms if a.lstrip().split()[2][len(t):] in tag]
    return arms


def _drv2():
    """L3939~4111 SP 전용 Unit Price (RTF 집계 A ⟕ MKT_AMT_LOC B ⟕ MKT_AMT_KRW C) — 게이트 p_version_type LIKE '%SP%'"""
    k9 = ("A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID\n                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID"
          "\n                     , A.CELL_PROD_SITE_ID")
    attr_max = "\n".join(f"                     , MAX(A.{c}) AS {c}" for c in C_ATTR)

    def on9(x):
        return "\n".join(f"                    AND A.{k} = {x}.{k}" for k in
                         ["PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID", "ITEM_ID", "INCOTERMS", "DOM_EXP", "FCST_TYPE", "CELL_PROD_SITE_ID", "YYYYMMDD"])
    return f"""    ), DRV2 AS (  /* L3939~4111 SP 전용 LOC/KRW — RTF(A) ⟕ MKT_AMT_LOC(B, 버전 포함) ⟕ MKT_AMT_KRW(C, 버전 미포함 = 원문) */
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , CASE D.MEASURE
                   WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                   WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
               END AS QTY
             , D.MEASURE_GROUP
             , {C_SEL.replace('C.', 'A.')}
             , D.SORT_ORDER_NO
             , A.ENERGE, A.CELL_QUANTITY
             , NVL(CASE D.MEASURE WHEN 'LOC' THEN B.AS_FROM_SITE    WHEN 'KRW' THEN C.AS_FROM_SITE    END, ' ') AS AS_FROM_SITE
             , CASE D.MEASURE WHEN 'LOC' THEN B.CREATE_DATE     WHEN 'KRW' THEN C.CREATE_DATE     END AS CREATE_DATE
             , CASE D.MEASURE WHEN 'LOC' THEN B.LAST_UPDATED_BY WHEN 'KRW' THEN C.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , A.SENDER_CODE, A.SENDER_NAME, A.PROJECT_S_OP_REPORT
             , B.CURRENCY
             , A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   ( SELECT {k9}
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
{attr_max}
                     , MAX(A.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , MAX(A.ENERGE) AS ENERGE
                     , MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
                     , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE) AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                     , MAX(A.SENDER_CODE) AS SENDER_CODE
                     , MAX(A.SENDER_NAME) AS SENDER_NAME
                     , MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'RTF_SYS_RP'
                GROUP BY {k9}
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) A
        LEFT JOIN ( SELECT {k9}
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_LOC'
                GROUP BY {k9}
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) B
                ON (    A.DIVISION_ID       = B.DIVISION_ID
{on9('B')}
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.QTY <> 0 )
        LEFT JOIN ( SELECT {k9}
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_KRW'
                GROUP BY {k9}
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD
              ) C
                ON (    A.DIVISION_ID       = C.DIVISION_ID
{on9('C')}
                    AND A.QTY <> 0 )
        INNER JOIN MEA D
                ON  D.MEASURE IN ('LOC', 'KRW')
        WHERE  NVL(p_version_type,'~') LIKE '%SP%'
        AND    (CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
                END) IS NOT NULL"""


def s2_fcst_n_price_all(div='ALL'):
    """2-B ALL 변형(버전 포함 요청용): Current(G_CUR 게이트) + MF + SF + SP arm(사업부별) · DRV1 게이트(Current/MF/SF) · DRV2(SP) · L4114 SP 삭제 → FLT."""
    s = s2_fcst_n_price_current(div, cur_gate=True)

    def rep(a, b, what):
        nonlocal s
        assert s.count(a) == 1, f"2-B 치환 앵커 불일치: {what}"
        s = s.replace(a, b, 1)
    rep("    ), BASE AS (  /* L1446~2361 Current 8 arm */",
        _ver_ctes() + "\n    ), BASE AS (  /* L1446~2361 Current 8 arm + L2368~3697 버전 arm */", "BASE 헤더")
    varms = "\n        UNION ALL\n".join(_version_arms("MF") + _version_arms("SF") + _version_arms("SP"))
    rep("\n    ), LOC9 AS (", "\n        UNION ALL\n" + varms + "\n    ), LOC9 AS (", "LOC9 앞")
    g1 = f"({G_CUR} OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')"
    rep("        WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')\n        AND    A.YYYYMMDD >= p_from_yyyymmdd\n        AND    A.YYYYMMDD < V_TO_RESULT",
        f"        WHERE  {g1}\n        AND    A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')\n        AND    A.YYYYMMDD >= p_from_yyyymmdd\n        AND    A.YYYYMMDD < V_TO_RESULT", "DRV1 LOC/KRW 게이트")
    rep("        WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')\n        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD",
        f"        WHERE  {g1}\n        AND    A.MEASURE IN ('MKT_FCST','SCM_FCST')\n        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD", "DRV1 FCST_GAP 게이트")
    drv_sel = ", ".join(c if c != "QTY" else "CAST(QTY AS NUMBER(30,10)) AS QTY" for c in FNP_LIST)
    rep("    ), UNI AS (\n", _drv2() + "\n    ), UNI AS (\n", "DRV2 삽입")
    rep(f"        SELECT {drv_sel} FROM DRV1\n    ), FLT AS (",
        f"        SELECT {drv_sel} FROM DRV1\n        UNION ALL\n        SELECT {drv_sel} FROM DRV2\n    ), FLT AS (", "UNI 확장")
    rep("        WHERE  NOT EXISTS (SELECT 1 FROM MEA B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)\n",
        "        WHERE  (NVL(p_version_type,'~') NOT LIKE '%SP%' OR F.MEASURE IS NULL OR F.MEASURE NOT IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'RTF_SYS_RP'))\n"
        "          AND  NOT EXISTS (SELECT 1 FROM MEA B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)\n", "L4114 SP 삭제")
    return s


if __name__ == "__main__":
    for d in ('81', '82', '40'):
        s = s2_fcst_n_price_all(d)
        print(d, "2B S2 chars", len(s), "arms:", re.findall(r"/\* ── (\w+)", s))
