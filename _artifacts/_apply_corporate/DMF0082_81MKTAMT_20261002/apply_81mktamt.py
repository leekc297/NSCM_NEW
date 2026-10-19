# -*- coding: utf-8 -*-
"""PKG_DMF0082 조회 — 81 계획구간 MKT FCST 금액(MKT_AMT_KRW / MKT_AMT_LOC) 표시 [E20261002-DMF0082-81MKTAMT]

사용자 지시 (2026-10-02): "클라우드, DMF0082, 81 DIVISION — MKT_AMT_KRW, MKT_AMT_LOC 2개 메저의 데이터가 생성되고 조회되기를 원합니다."
  → 저장 시 DM_PLN_MKT_FCST 에 생성하는 안은 QTY NUMBER(20,10) 자릿수 한도(정수부 10자리)로 불가
    (81 금액 실측 최대 13자리 · 초과 KRW 1,823행 / LOC 188행) → "1. 조회 SP 변경" 확정.
현황 (사내 ZIOUI1 실측):
  · 81 금액은 Sales Plan 동기화(PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE — DMF0082/DMF0003 저장 직후)와
    야간 배치(PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW)가 DM_PLN_SALES_PLAN 에 MKT_FCST × 판가로 생성한다.
  · PKG_DMF0082 는 DM_PLN_SALES_PLAN 을 읽지 않는다 — 81 계획구간 메저 원천 = DM_PLN_MKT_FCST(금액 행 0건) → 메저를 선택해도 빈칸.
    (40 은 저장 SP 가 DM_PLN_CFM_MKT_DEMAND_PLAN 에 MKT_AMT 를 직접 저장 — 81 은 v_is_81 게이트로 미생성, AS-IS 도 40 전용)
조치 (삽입만 — 기존 문장 무수정):
  (1) P_DMF0082_GET_MAIN_DATA  Current : 81 수요 arm 뒤에 DM_PLN_SALES_PLAN 금액 arm
  (2) P_DMF0082_GET_MAIN_DATA  MF      : 81 수요 arm 뒤에 DM_PLN_SALES_PLAN_C 금액 arm (버전 매핑 = 기존 실적 금액 arm 의 SP_VERSION_NO)
  (3) P_DMF0082_GET_MAIN_DATA  SF      : 동일
  (4) P_DMF0082_GET_MAIN_DATA_CURRENT  : 81 arm 뒤에 DM_PLN_SALES_PLAN 금액 arm
  공통: 기간·SITE_ITEM·WS FCST_TYPE 게이트 = 같은 블록의 81 수요 arm 과 동일 / 셀생산지 81 규약 '-' 로 합산 /
        강제 포함(DM_ADMIN) 메저는 실적 Unit Price 계산 전용이라 제외(사용자가 선택한 경우만 적재) / QTY <> 0.
FRESH-GATE: 적용 직전 USER_SOURCE 재조회 == 착수 기준본.
usage: python apply_81mktamt.py backup | apply | restore
"""
import datetime, io, pathlib, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG = "E20261002-DMF0082-81MKTAMT"
NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
BAK = HERE / "00_BACKUP_PKG_DMF0082_BODY.sql"
NEW = HERE / "01_PKG_DMF0082_BODY_81MKTAMT.sql"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 900000
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    return cur.fetchone()[0]


def fetch():
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 ORDER BY LINE", [NAME, TYP])
    return [t or "" for (t,) in cur]


def compile_src(src):
    cur.execute("CREATE OR REPLACE " + src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:1 AND TYPE=:2 ORDER BY SEQUENCE", [NAME, TYP])
    return st, cur.fetchall()


if MODE == "restore":
    src = BAK.read_text(encoding="utf-8").split("CREATE OR REPLACE ", 1)[1].rsplit("\n/\n", 1)[0]
    print("restore:", compile_src(src))
    sys.exit(0)

ddl0 = last_ddl()
L = fetch()
src0 = "".join(L)
assert TAG not in src0, "이미 적용됨"
assert "DM_PLN_SALES_PLAN S" not in src0 and not re.search(r"SCM_MGR\.DM_PLN_SALES_PLAN\b(?!_)", src0), "전제 변경: 패키지가 이미 DM_PLN_SALES_PLAN 을 읽는다"


def proc_range(name):
    s = next(i for i, t in enumerate(L) if t.strip().startswith("PROCEDURE") and t.strip().split()[1] == name)
    e = next((i for i in range(s + 1, len(L)) if L[i].strip().startswith("END " + name)), len(L))
    return s, e


def find_one(a, b, stripped):
    hits = [i for i in range(a, b) if L[i].strip() == stripped]
    assert len(hits) == 1, (stripped, hits)
    return hits[0]


# ---------------------------------------------------------------------------------------------------------------------
# 삽입 블록
# ---------------------------------------------------------------------------------------------------------------------
MEAS = "('MKT_AMT_KRW', 'MKT_AMT_LOC')"

MAIN_COLS = """        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID  --[DIV81] 81 수요 arm 과 같은 축 ('-')
             , A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE
             , NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
"""

MAIN_JOINS = """        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND NVL(B.USER_ID, '-') <> 'DM_ADMIN'   -- 강제 포함분(실적 Unit Price 계산 전용)은 계획구간 적재 제외
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
"""

BLOCK_MAIN_CURRENT = f"""        --[{TAG}] 81 계획구간 MKT FCST 금액(MKT_AMT_KRW / MKT_AMT_LOC) — 원천 DM_PLN_SALES_PLAN (사용자 지시 2026-10-02).
        --  40 은 저장 SP 가 금액을 수요 원장(DM_PLN_CFM_MKT_DEMAND_PLAN, QTY NUMBER(25,10))에 저장하지만, 81 수요 원장
        --  DM_PLN_MKT_FCST 는 QTY NUMBER(20,10) 이라 금액(사내 실측 최대 13자리)을 담지 못한다 (ORA-01438).
        --  81 금액은 Sales Plan 동기화(PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE — DMF0082·DMF0003 저장 직후)와
        --  야간 배치가 DM_PLN_SALES_PLAN 에 MKT_FCST × 판가로 생성하므로 그 값을 읽는다.
        --  기간·SITE_ITEM·WS FCST_TYPE 게이트 = 위 81 수요 arm 동일. 셀생산지는 81 규약 '-' 로 합산.
        --  CURRENCY 는 수요 arm 과 같이 비워 두고 하단 "CURRENCY 업데이트" 가 LOC 통화로 채운다.
        IF p_division_id LIKE '81%' THEN
{MAIN_COLS}             , '' AS CURRENCY, 'Current' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM  ( SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.MEASURE IN {MEAS}
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
{MAIN_JOINS}        WHERE  A.QTY <> 0;
        END IF;  --[{TAG}]

"""


def block_main_cutoff(prefix):
    return f"""        --[{TAG}] 81 계획구간 MKT FCST 금액 {prefix} — 원천 DM_PLN_SALES_PLAN_C (Current 블록 주석 참조).
        --  버전 매핑 = 같은 블록 실적 금액 arm(DM_PLN_SALES_PLAN_RESULT_C)과 동일: 선택 {prefix} 버전과 같은 주의 SP 버전(SP_VERSION_NO).
        IF p_division_id LIKE '81%' THEN
{MAIN_COLS}             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM  ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN_C S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.VERSION_NO IN (SELECT V.SP_VERSION_NO FROM SCM_MGR.GT_DMF0082_T_VERSION V WHERE V.VERSION_NO LIKE '{prefix}%')
                AND    S.MEASURE IN {MEAS}
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                       , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
{MAIN_JOINS}        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE '{prefix}%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.QTY <> 0;
        END IF;  --[{TAG}]

"""


BLOCK_CUR = f"""        --[{TAG}] 81 계획구간 MKT FCST 금액(MKT_AMT_KRW / MKT_AMT_LOC) — 원천 DM_PLN_SALES_PLAN (사용자 지시 2026-10-02).
        --  81 수요 원장 DM_PLN_MKT_FCST 는 QTY NUMBER(20,10) 이라 금액(최대 13자리)을 담지 못해 Sales Plan 동기화·야간 배치가
        --  DM_PLN_SALES_PLAN 에 생성한 값을 읽는다 (P_DMF0082_GET_MAIN_DATA 동일 블록 주석 참조).
        --  기간·SITE_ITEM·WS FCST_TYPE 게이트·CURRENCY 표기 = 위 81 수요 arm 동일. 셀생산지 '-' 로 합산.
        IF p_division_id LIKE '81%' THEN
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 81 수요 arm 과 같은 축 ('-')
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , NULL AS CREATE_DATE
             , NULL AS LAST_UPDATED_BY
             , '-' AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM  ( SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.MEASURE IN {MEAS}
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.MEASURE
            AND NVL(B.USER_ID, '-') <> 'DM_ADMIN'   -- 강제 포함분(실적 Unit Price 계산 전용)은 계획구간 적재 제외
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  A.QTY <> 0;
        END IF;  --[{TAG}]

"""

HIST_MAIN = (f" * 2026.10.02       admin        [{TAG}] 81 계획구간 MKT FCST 금액(MKT_AMT_KRW/LOC) 표시 — 원천 DM_PLN_SALES_PLAN(_C)\n"
             f" *                               (81 수요 원장 QTY NUMBER(20,10) 자릿수 한도로 금액 저장 불가 → Sales Plan 동기화 산출값 조회 · Current/MF/SF)\n")
HIST_CUR = f" * 2026.10.02       admin        [{TAG}] 81 계획구간 MKT FCST 금액(MKT_AMT_KRW/LOC) 표시 — 원천 DM_PLN_SALES_PLAN\n"

inserts = {}   # line index → 그 줄 "앞"에 넣을 텍스트


def header_end(a, b):
    hits = [i for i in range(a, min(b, a + 120)) if re.match(r"^\s\*=+\*/\s*$", L[i])]
    assert len(hits) == 1, ("header end", a, hits)
    return hits[0]


# ---------------- P_DMF0082_GET_MAIN_DATA ----------------
a, b = proc_range("P_DMF0082_GET_MAIN_DATA")
inserts[header_end(a, b)] = HIST_MAIN
for anchor, block in (("-- 판가 (DM_PLN_CFM_SELLING_PRICE)", BLOCK_MAIN_CURRENT),
                      ("-- 판가 MF (DM_PLN_CFM_SELLING_PRICE_C)", block_main_cutoff("MF")),
                      ("-- 실적 수량 SF (DM_PLN_SALES_PLAN_RESULT_C)", block_main_cutoff("SF"))):
    k = find_one(a, b, anchor)
    assert L[k - 1].strip() == "" and L[k - 2].strip() == "END IF;  --[DIV81]", (anchor, L[k - 2])   # 81 수요 arm 분기 직후
    inserts[k] = block

# ---------------- P_DMF0082_GET_MAIN_DATA_CURRENT ----------------
a, b = proc_range("P_DMF0082_GET_MAIN_DATA_CURRENT")
inserts[header_end(a, b)] = HIST_CUR
k = find_one(a, b, "-- CURRENCY 일괄 UPDATE (MSSQL UPDATE ... FROM JOIN → MERGE. GROUP BY+MAX 로 ORA-30926 방지 — MSSQL 임의채택의 결정적 대체)")
assert set(L[k - 1].strip()) == {"-"} and L[k - 2].strip() == "" and L[k - 3].strip() == "END IF;  --[DIV81]", (L[k - 3], L[k - 1])
inserts[k - 1] = BLOCK_CUR

assert len(inserts) == 6
new = []
for i, t in enumerate(L):
    if i in inserts:
        new.append(inserts[i])
    new.append(t)
src1 = "".join(new)
assert src1.count(f"END IF;  --[{TAG}]") == 4 and src1.count(f"[{TAG}]") == 10, src1.count(f"[{TAG}]")
chk = src1
for i in inserts:
    assert chk.count(inserts[i]) == 1
    chk = chk.replace(inserts[i], "", 1)
assert chk == src0, "원문 보존 검증 실패 (삽입 외 변경 없음)"
print(f"기준본 LAST_DDL={ddl0}  삽입 6곳 (이력 2 · 금액 arm 4 = MAIN Current/MF/SF + CURRENT)  {len(L)}줄 → {src1.count(chr(10))}줄")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
if MODE == "backup" or not BAK.exists():
    assert not BAK.exists(), "백업 파일은 1회 생성 후 불변 — 이미 존재"
    BAK.write_text(stamp + "-- 적용 전 원문\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
else:
    assert BAK.read_text(encoding="utf-8").split("CREATE OR REPLACE ", 1)[1].rsplit("\n/\n", 1)[0] == src0.rstrip(), "백업 ≠ 현재 DB 원문 — 중단"
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0082 BODY 전체본\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + src1.rstrip() + "\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.PKG_DMF0082\n", encoding="utf-8")
(HERE / "_change_preview.sql").write_text("".join(f"-- L{i+1} 앞에 삽입 (다음 줄 원문: {L[i].strip()[:90]})\n{inserts[i]}" for i in sorted(inserts)), encoding="utf-8")
print("파일 생성 완료")

if MODE == "apply":
    # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
    assert last_ddl() == ddl0 and "".join(fetch()) == src0, "FRESH-GATE: 추출 이후 변경 감지 — 중단"
    st, errs = compile_src(src1)
    print(f"적용 결과 STATUS={st} 오류={len(errs)} LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for x in errs[:15]:
            print("  ERR", x)
        print("⚠ 원복:", compile_src(src0))
        sys.exit(1)
    assert "".join(fetch()).rstrip() == src1.rstrip(), "적용본 ≠ DB 원문"
    print("적용본 == DB 원문 확인")
cn.close()
