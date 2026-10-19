"""DMF0082 조회 — 40 수요·판가 원장 1회 읽기 [E20261014-DMF0082ONEREAD40] (사내 ZIOUI1)

사용자 승인(2026-10-14): "네..진행해주세요" (조건 미지정 조회 병목 = 같은 원장 2회 읽기 → ONEREAD 확장, 범위 = 40 수요·40 판가)

현상 (클라우드 QA G03/G04 실측 2026-10-14, Division 만 지정한 조회):
  40 은 "최근 수정일·수정자" GTT 적재가 원장을 한 번 읽고, 적재 arm 이 같은 원장을 또 읽는다.
    ① T_LAST_DATA_SETUP_FCST (DM_PLN_CFM_MKT_DEMAND_PLAN, PK 범위 스캔)  ASH 38초 · 1회 2.95s
       + 40 수요 arm (같은 원장)                                       ASH 36초 · 1회 2.79s
    ② T_LAST_DATA_SETUP_PRICE (DM_PLN_CFM_SELLING_PRICE, IDX07)          ASH 13초 · 1회 1.67s
       + 40 판가 arm (같은 원장)                                       ASH 20초 · 1회 2.12s
  81/82 판가는 09-30 [E20260930-DMF0082ONEREAD] 로 이미 1회 읽기다 — 같은 방식을 40 에 적용한다.

보완 (P_DMF0082_GET_MAIN_DATA, 40 경로만 — 81/82 경로 무변경):
  E1 40 T_LAST_DATA_SETUP_FCST 별도 적재 → 제거(NULL). 적재는 E3 의 INSERT ALL 이 같은 원장 1회 읽기로 대신한다.
     (이 GTT 는 40 수요 arm 외에 실적 arm(DM_PLN_SALES_PLAN_RESULT)도 읽으므로 GTT 자체는 그대로 채운다)
  E2 40 T_LAST_DATA_SETUP_PRICE 별도 적재 → 제거(NULL). 소비처 = 40 판가 arm 하나뿐 → E4 의 윈도 MAX 로 대체.
  E3 40 수요 arm → 다중 테이블 INSERT ALL: 원장 1회 읽기로 ①GTT 키별 1행(윈도 MAX) ②수요 행을 동시에 적재.
  E4 40 판가 arm → 81 ONEREAD 와 같은 형태: 원장 1회 읽기 + 키 8개 PARTITION 윈도 MAX(구 LD 조인과 등가).

등가 근거:
  - 키 8개(DIVISION_ID·PROJECT_CODE·SCM_SITE_ID·ITEM_ID·DOM_EXP·FCST_TYPE·INCOTERMS·MEASURE) 두 원장 모두 NOT NULL(PK) 실측
    → PARTITION BY 와 구 등호 조인의 묶음이 같다.
  - 구 GTT 적재 = 원장 × TEMP_SITE_ITEM(유효여부 무관) · p_from~p_to · 전 메저/전 FCST_TYPE · GROUP BY 키 8개 → 키별 1행.
    구 arm 의 LD = 그 1행(KEEP DENSE_RANK LAST 는 1행이라 그대로) → CREATE_DATE=MAX(CREATION_DATE), LAST_UPDATED_BY=MAX(LAST_UPDATED_BY).
  - E3 은 읽기 집합을 GTT 적재와 같게(TEMP_SITE_ITEM 유효여부 무관, B·D LEFT JOIN) 두고, 수요 행 조건(B·D 일치·VALID='Y'·
    V_FROM~V_TO·QTY<>0)은 WHEN 으로 거른다 → GTT 행 · 수요 행(행 배수 포함) 모두 구본과 같다.
  - E4 의 arm 조인(B 메저·C 유효·D FCST_TYPE)은 키 8개 안에서 균일하다(메저·FCST_TYPE·프로젝트/사이트/품목이 키) → 윈도 집합 = 구 LD 집합.
  - 힌트: 새로 넣지 않는다. 합쳐지는 기존 문장의 힌트만 옮긴다(E3 = 구 GTT 적재의 LEADING(A) USE_HASH(C) · E4 = 구 판가 arm 힌트).

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성
  python build_apply.py apply   # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0082"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261014-DMF0082ONEREAD40]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"

# ---- 원문 앵커 (최신 원문에서 각각 정확히 1회) ----------------------------------------------------------
E1_OLD_HEAD = ("    ELSE\n"
               "    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST\n")
E1_OLD_TAIL = ("    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID\n"
               "           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;\n"
               "    END IF;  --[DIV81]\n")
E2_OLD_HEAD = ("    ELSE\n"
               "    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE\n")
E2_OLD_TAIL = E1_OLD_TAIL
E3_OLD_HEAD = ("        ELSE\n"
               "        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n")
E3_OLD_TAIL = ("        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A\n")      # 이 줄부터 arm 끝(';')까지 확인
E3_OLD_END = ("        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD\n"
              "        AND    A.QTY <> 0;\n"
              "        END IF;  --[DIV81]\n")
E4_OLD_FROM = ("        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A\n")
E4_OLD_END = ("        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413)\n"
              "        END IF;  --[DIV81]\n")

COLS = ("( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS\n"
        "            , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP\n"
        "            , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO\n"
        "            , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE\n"
        "            , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN\n"
        "            , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY\n"
        "            , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC\n"
        "            , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE\n"
        "            , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE\n"
        "            , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT\n"
        "            , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)")
C_ATTRS = ["CELL_MODEL", "NICK_NAME", "DMS_SALES", "DMS_CUSTOMER", "OWNER", "DEPT_ID", "DEPT_NAME_KO",
           "FORECAST_INFO_CELL_PACK_COUNT", "ITEM_TYPE", "PROJECT_NAME", "PROJECT_OWNER", "BIZ_TYPE",
           "SOLDTO_CUSTOMER", "COUNTRY_NAME", "CITY_NAME", "PROJECT_STATUS", "ITEM_NAME", "VMI_YN",
           "CUST_GROUP", "CUST_GROUP_DTL", "APPLICATION", "ROUTE", "MDM_PROJECT_NAME", "MIN_CAPACITY",
           "FORECAST_INFO_BIZ_TYPE", "CELL_TYPE", "FORECAST_INFO_ALL", "FORECAST_INFO_SPEC",
           "FORECAST_INFOR_VERSION", "CELL_MODEL_NICK_NAME", "CELL_PER_CAR", "CELL_PER_MODULE", "MODULE_PER_CAR"]
KEY8 = "A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE"


def commented(block, why):
    """원문 문장을 지우지 않고 주석으로 남긴다(구 81 ONEREAD 와 같은 표기)."""
    lines = block.rstrip("\n").split("\n")
    return f"    NULL;  --{MARK} {why}\n" + "".join("--" + l[2:] + "\n" if l.startswith("  ") else "--" + l + "\n" for l in lines)


def e3_new():
    c_sel = "\n".join(f"                     , C.{c} AS C_{c}" for c in C_ATTRS)
    c_out = "\n".join(f"                 , C_{c}" for c in C_ATTRS[:33])
    return f"""        ELSE
        /* {MARK} 40 수요 원장 1회 읽기 — 구 L1275 T_LAST_DATA_SETUP_FCST 적재(같은 원장 PK 범위 스캔)를 이 문장이 대신한다.
           다중 테이블 INSERT ALL: 원장 × TEMP_SITE_ITEM(유효여부 무관) 을 한 번 읽어
             ① T_LAST_DATA_SETUP_FCST — 키 8개당 1행 (p_from~p_to 구간 MAX(CREATION_DATE)·MAX(LAST_UPDATED_BY)) = 구 GROUP BY 적재와 동일
                (실적 arm 이 이 GTT 를 계속 읽는다)
             ② TEMP_FCST_N_PRICE — 구 수요 arm 행 (B 메저·D FCST_TYPE 일치 · ITEM_VALID_YN='Y' · V_FROM~V_TO · QTY<>0)
           키 8개는 원장 NOT NULL(PK) 실측 → PARTITION BY = 구 등호 조인 묶음. 힌트 = 구 GTT 적재 문장의 것 그대로. */
        INSERT ALL
        WHEN X_LD_EMIT = 1 THEN
            INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
                (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
            VALUES (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, X_MEASURE_RAW, X_LD_CD, X_LD_LU)
        WHEN X_OUT = 1 THEN
            INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
            {COLS}
            VALUES (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , X_MEASURE_OUT, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, B_MEASURE_GROUP
{c_out}
                 , B_SORT_ORDER_NO, C_ENERGE, C_CELL_QUANTITY, X_AS_FROM_SITE
                 , X_LD_CD, X_LU_OUT, '', '', C_PROJECT_S_OP_REPORT
                 , '', 'Current', NULL, X_NOTATION)
        SELECT S.*
             , CASE WHEN S.X_IN_P = 1 AND S.X_RN = 1 THEN 1 ELSE 0 END AS X_LD_EMIT
             , CASE WHEN S.B_HIT = 1 AND S.D_HIT = 1 AND S.C_ITEM_VALID_YN = 'Y'
                     AND S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                     AND S.QTY <> 0 THEN 1 ELSE 0 END AS X_OUT
             , CASE WHEN UPPER(S.X_MEASURE_RAW) = 'CUSTOMER FCST' THEN CASE WHEN S.X_ROW_LU LIKE '%robot' THEN S.X_ROW_LU || '_RPA' ELSE S.X_ROW_LU || '_EXCEL' END ELSE S.X_LD_LU END AS X_LU_OUT  /*[E20260930-DMF0082CUSTEXCEL] AS-IS 동일 — 수정자 접미사*/
        FROM (
            SELECT /*+ LEADING(A) USE_HASH(C) */
                   A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                 , A.MEASURE AS X_MEASURE_RAW
                 , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS X_MEASURE_OUT  /*[E20260930-DMF0082CUSTEXCEL] AS-IS DMF0003 Block 1-C [E20241126-000426] 1:1*/
                 , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
                 , A.LAST_UPDATED_BY AS X_ROW_LU
                 , NVL(A.ATTRIBUTE10, ' ') AS X_AS_FROM_SITE
                 , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS X_NOTATION
                 , B.MEASURE_GROUP AS B_MEASURE_GROUP, B.SORT_ORDER_NO AS B_SORT_ORDER_NO
                 , CASE WHEN B.MEASURE IS NOT NULL THEN 1 ELSE 0 END AS B_HIT
                 , CASE WHEN D.FCST_TYPE IS NOT NULL THEN 1 ELSE 0 END AS D_HIT
                 , C.ITEM_VALID_YN AS C_ITEM_VALID_YN
{c_sel}
                     , C.ENERGE AS C_ENERGE, C.CELL_QUANTITY AS C_CELL_QUANTITY, C.PROJECT_S_OP_REPORT AS C_PROJECT_S_OP_REPORT
                 , CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN 1 ELSE 0 END AS X_IN_P
                 , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END)
                       OVER (PARTITION BY {KEY8}) AS X_LD_CD
                 , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END)
                       OVER (PARTITION BY {KEY8}) AS X_LD_LU
                 , ROW_NUMBER() OVER (PARTITION BY {KEY8}
                                      ORDER BY CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN 0 ELSE 1 END) AS X_RN
            FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
            INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C            -- 유효여부 무관 (구 GTT 적재와 같은 읽기 집합)
                ON  C.DIVISION_ID  = A.DIVISION_ID
                AND C.PROJECT_CODE = A.PROJECT_CODE
                AND C.SCM_SITE_ID  = A.SCM_SITE_ID
                AND C.ITEM_ID      = A.ITEM_ID
            LEFT JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B         -- 수요 행 조건은 WHEN X_OUT 에서 (구 INNER JOIN 과 같은 행 배수)
                ON  B.MEASURE = A.MEASURE
            LEFT JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
                ON  D.FCST_TYPE = A.FCST_TYPE
            WHERE  A.DIVISION_ID = p_division_id
            AND    A.YYYYMMDD BETWEEN LEAST(p_from_yyyymmdd, V_FROM_YYYYMMDD) AND GREATEST(p_to_yyyymmdd, V_TO_YYYYMMDD)
        ) S;
        END IF;  --[DIV81]
"""


def e4_new_from(old_select_part):
    """구 판가 arm 의 SELECT 목록을 C01~C60 별칭으로 감싸고, LD 를 윈도 MAX 로 바꾼다(81 ONEREAD 형태)."""
    return old_select_part


def transform(body):
    if MARK in body:
        sys.exit(f"ABORT: BODY 에 {MARK} 이미 존재 — 재적용 불필요")
    if "\r" in body:
        sys.exit("ABORT: BODY 원문에 CR 포함")
    p_main = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA\n")
    p_cur = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")
    seg = body[p_main:p_cur]

    def one(tok, name, s=seg):
        n = s.count(tok)
        if n != 1:
            sys.exit(f"ABORT: {name} 앵커 {n}건 (기대 1) — 원문이 바뀌었음")
        return s.index(tok)

    # E1 — 40 T_LAST_DATA_SETUP_FCST 적재
    i1 = one(E1_OLD_HEAD, "E1 head")
    j1 = seg.index(E1_OLD_TAIL, i1)
    e1_old = seg[i1 + len("    ELSE\n"): j1 + len(E1_OLD_TAIL) - len("    END IF;  --[DIV81]\n")]
    assert "FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A" in e1_old and e1_old.count(";") == 1, "E1 범위 이상"
    # E2 — 40 T_LAST_DATA_SETUP_PRICE 적재
    i2 = one(E2_OLD_HEAD, "E2 head")
    j2 = seg.index(E2_OLD_TAIL, i2)
    e2_old = seg[i2 + len("    ELSE\n"): j2 + len(E2_OLD_TAIL) - len("    END IF;  --[DIV81]\n")]
    assert "FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A" in e2_old and e2_old.count(";") == 1, "E2 범위 이상"
    # E3 — 40 수요 arm (Current 블록 첫 ELSE INSERT … DM_PLN_CFM_MKT_DEMAND_PLAN … QTY<>0)
    k3 = one(E3_OLD_TAIL, "E3 FROM")
    i3 = seg.rindex(E3_OLD_HEAD, 0, k3)
    j3 = seg.index(E3_OLD_END, k3)          # FROM 줄 뒤 첫 끝 (같은 문구가 MF/SF 블록에도 있어 전체 유일하지 않음 — 구간 안 ';' 0 으로 단언)
    assert i3 < k3 < j3 and seg[i3:j3].count(";") == 0, "E3 범위 이상"
    e3_old = seg[i3: j3 + len(E3_OLD_END)]
    for t in ("GT_DMF0082_T_LAST_DATA_SETUP_FCST", "INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D", "AND C.ITEM_VALID_YN = 'Y'",
              "INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B"):
        assert e3_old.count(t) == 1, f"E3 원문 구성요소 불일치: {t}"
    # E4 — 40 판가 arm
    k4 = one(E4_OLD_FROM, "E4 FROM")
    i4 = seg.rindex("        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n", 0, k4)
    j4 = seg.index(E4_OLD_END, k4)          # FROM 줄 뒤 첫 끝 (구간 안 ';' 0 으로 단언)
    assert i4 < k4 < j4 and seg[i4:j4].count(";") == 0, "E4 범위 이상"
    e4_old = seg[i4: j4 + len(E4_OLD_END)]
    for t in ("GT_DMF0082_T_LAST_DATA_SETUP_PRICE", "             , LD.CREATE_DATE\n", "             , LD.LAST_UPDATED_BY\n",
              "        LEFT JOIN ( -- [FIX 2026-07-13]", "            ) LD\n"):
        assert e4_old.count(t) == 1, f"E4 원문 구성요소 불일치: {t}"
    # 순서 단언: E1 < E2 < (Current 블록) E3 < E4
    assert i1 < i2 < i3 < i4, "편집 위치 순서 이상"

    # E4 새 문장 — 구 문장을 그대로 두고 LD 조인만 걷어 낸 뒤 윈도 MAX 로 대체
    sel_start = e4_old.index("        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */")
    from_pos = e4_old.index(E4_OLD_FROM)
    head = e4_old[:sel_start]                       # INSERT … (컬럼 목록)
    sel = e4_old[sel_start:from_pos]                # SELECT 목록 (힌트·주석 포함)
    rest = e4_old[from_pos:]                        # FROM … END IF
    ld_s = rest.index("        LEFT JOIN ( -- [FIX 2026-07-13]")
    ld_e = rest.index("                AND LD.MEASURE      = A.MEASURE\n") + len("                AND LD.MEASURE      = A.MEASURE\n")
    rest_noLD = rest[:ld_s] + rest[ld_e:]
    sel = sel.replace("             , LD.CREATE_DATE\n",
                      f"             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY {KEY8}) AS X_LD_CD   --{MARK} 구 LD 조인 = 윈도 MAX\n")
    sel = sel.replace("             , LD.LAST_UPDATED_BY\n",
                      f"             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY {KEY8}) AS X_LD_LU\n")
    # 출력 범위(V_TO_RESULT~V_TO_YYYYMMDD)는 바깥에서 — 안쪽 읽기 범위는 LD 구간(p_from~p_to)과의 합집합
    rest_noLD = rest_noLD.replace(E4_OLD_END,
        "        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)\n"
        "        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413) — 구 조건 그대로\n"
        "        END IF;  --[DIV81]\n")
    # SELECT 목록 끝에 출력 범위 판정용 일자 추가 → 바깥 SELECT 는 X_ONEREAD_YMD 를 뺀 60개
    notation = "             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION\n"
    assert sel.count(notation) == 1, "E4 NOTATION 줄 불일치"
    sel = sel.replace(notation, notation.rstrip("\n") + "\n             , A.YYYYMMDD AS X_ONEREAD_YMD\n")
    # 바깥 SELECT: 안쪽 SELECT 목록의 표현식에 C01~C60 별칭을 붙여 그대로 고른다
    items = split_select_items(sel)
    assert len(items) == 61, f"E4 SELECT 항목 수 {len(items)} (기대 60 + 일자 1)"
    aliased = []
    for n, it in enumerate(items[:-1], 1):
        aliased.append(strip_alias(it) + f" AS C{n:02d}")
    aliased.append(items[-1])
    inner_select = sel[:sel.index("A.DIVISION_ID")] + "\n             , ".join(aliased) + "\n"
    outer_cols = ", ".join(f"C{n:02d}" for n in range(1, 61))
    e4_new = (head
              + f"        /*{MARK} 40 판가 원장 1회 읽기 — 구 T_LAST_DATA_SETUP_PRICE 적재(같은 원장 IDX07 범위 스캔) 제거분의\n"
              + "           최신 수정일자·수정자를 키 8개 PARTITION 윈도 MAX 로 여기서 계산 (81 [E20260930-DMF0082ONEREAD] 와 같은 형태 · 구 LD 조인과 등가).\n"
              + "           출력 범위는 바깥 WHERE (구 조건 그대로) · 힌트 = 구 문장 그대로 */\n"
              + f"        SELECT {outer_cols}\n"
              + "        FROM (\n"
              + inner_select
              + rest_noLD)

    new_seg = seg
    new_seg = new_seg.replace(e4_old, e4_new, 1)
    new_seg = new_seg.replace(e3_old, e3_new(), 1)
    new_seg = new_seg.replace(e2_old, commented(e2_old, "40 T_LAST_DATA_SETUP_PRICE 적재 제거 — 소비처(40 판가 arm)가 원장 1회 읽기 윈도 MAX 로 대체"), 1)
    new_seg = new_seg.replace(e1_old, commented(e1_old, "40 T_LAST_DATA_SETUP_FCST 별도 적재 제거 — Current 40 수요 arm 의 INSERT ALL 이 같은 원장 1회 읽기로 적재(실적 arm 이 계속 읽음)"), 1)
    return body[:p_main] + new_seg + body[p_cur:]


def split_select_items(sel):
    """SELECT 목록을 최상위 쉼표로 나눈다(괄호 깊이·문자열·주석 고려)."""
    s = sel[sel.index("*/") + 2:] if sel.lstrip().startswith("SELECT /*+") else sel
    # 힌트 뒤 줄 주석(-- …) 제거 후 시작
    out, buf, depth, i, q = [], [], 0, 0, False
    while i < len(s):
        ch = s[i]
        if not q and s.startswith("--", i):
            j = s.find("\n", i); i = j if j >= 0 else len(s); continue
        if not q and s.startswith("/*", i):
            j = s.find("*/", i); i = j + 2; continue
        if ch == "'":
            q = not q
        if not q:
            if ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
            elif ch == "," and depth == 0:
                out.append("".join(buf).strip()); buf = []; i += 1; continue
        buf.append(ch); i += 1
    out.append("".join(buf).strip())
    return [o for o in out if o]


def strip_alias(item):
    import re
    m = re.match(r"^(.*?)\s+AS\s+[A-Z_0-9]+$", item, re.S | re.I)
    return m.group(1).strip() if m else item.strip()


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=TYP)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)   # 기준본 = 지금 ALL_SOURCE 에서 새로 조회한 원문
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI'), SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        fetched, host = cur.fetchone()
    new = transform(s["src"])
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, F_BAK), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(s["src"]) + "/\n")
    open(os.path.join(HERE, F_NEW), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched, "host": host}, open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, "HOST", host, "LAST_DDL", s["last_ddl"], "lines", s["src"].count("\n"), "->", new.count("\n"),
          "marker", new.count(MARK))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        host = cur.fetchone()[0]
        if host != st["host"]:
            sys.exit(f"ABORT: 접속 DB 가 build 시점과 다름 (build {st['host']} → now {host})")
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본 (다르면 중단·재빌드)
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS", "HOST", host)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        inv_before = cur.fetchone()[0]
        tobe = strip(open(os.path.join(HERE, F_NEW), encoding="utf-8").read())
        cur.execute(tobe)
        after = read_source(cur)
        print("APPLIED", F_NEW, "DB==TOBE", after["src"].rstrip() == tobe[len("CREATE OR REPLACE "):].rstrip(),
              "marker", after["src"].count(MARK))
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)
        if errs:
            bak = strip(open(os.path.join(HERE, F_BAK), encoding="utf-8").read())
            cur.execute(bak)
            print("⚠ 컴파일 오류 → 백업본으로 원복함")
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        print("SCM_MGR INVALID objects", inv_before, "->", cur.fetchone()[0])


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
