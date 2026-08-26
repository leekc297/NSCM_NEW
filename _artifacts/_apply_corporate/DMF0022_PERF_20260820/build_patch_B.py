# -*- coding: utf-8 -*-
"""Stage B — [E20260820-D22VERPUSH] ② 비-SARGable 해소(access 술어 승격) 4건 + 하한 선계산 1건.

입력: 01_PATCHED_A_PKG_DMF0022_BODY.sql (Stage A 적용본)
P3a 단가표 DM_PLN_CFM_SELLING_PRICE (CURRENT·div40)  : C 에 access 술어 부재 → division + YYYYMMDD 하한
P3b 단가표 SCM_MST_FUTURE_PRICE     (CURRENT·div≠40) : 동일 (IX_YYYYMMDD_SCM_MST_FUTURE_PRICE 기존재)
P4a DM_PLN_SALES_PLAN_C  (TEMP40_KEY 조인)          : division + version push → IX_..._C_N3 선두 승격
P4b DM_PLN_SALES_PLAN_C  (RTF_ENERGY 조인)          : 동일
원본 라인의 IN 목록·주석·CASE 골격은 손대지 않고 **행 추가만** 한다.
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_PERF_20260820"
src = open(BASE + r"\01_PATCHED_A_PKG_DMF0022_BODY.sql", encoding="utf-8").read().splitlines()


def uniq(frag, occ=1):
    """정확히 occ 회 출현해야 하며, 그 라인 인덱스(0-based) 목록을 돌려준다."""
    idx = [i for i, l in enumerate(src) if l == frag]
    assert len(idx) == occ, f"전제 불일치: {frag!r} → {len(idx)}건 (기대 {occ})"
    return idx


I_DECL = uniq("    v_exists            PLS_INTEGER;")[0]
I_TRUNC = uniq("    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T';")[0]
I_P3A = uniq("               AND C.YYYYMMDD          <= P_TO_YYYYMMDD")[0]
I_P3B = uniq("               AND C.YYYYMMDD        <= P_TO_YYYYMMDD")[0]
I_P4A = uniq("                 AND  B.YYYYMMDD        >= p_now_yyyymmdd")[0]
I_P4B = uniq("                 AND B.YYYYMMDD         >= p_now_yyyymmdd")[0]
# 문맥 assert — 각 대상이 의도한 표에 붙어 있는지 확인
assert "DM_PLN_CFM_SELLING_PRICE C" in src[I_P3A - 11], src[I_P3A - 11]
assert "SCM_MST_FUTURE_PRICE C" in src[I_P3B - 10], src[I_P3B - 10]
assert "DM_PLN_SALES_PLAN_C B" in src[I_P4A - 12], src[I_P4A - 12]
assert "DM_PLN_SALES_PLAN_C B" in src[I_P4B - 15], src[I_P4B - 15]
print("전제 assert OK — decl %d / trunc %d / P3a %d / P3b %d / P4a %d / P4b %d"
      % (I_DECL + 1, I_TRUNC + 1, I_P3A + 1, I_P3B + 1, I_P4A + 1, I_P4B + 1))

DECL = """    v_exists            PLS_INTEGER;
    --[E20260820-D22VERPUSH] 단가표 access 술어용 YYYYMMDD 하한 (1회 선계산 — 상관 서브쿼리 아님)
    v_price_from_yyyymmdd VARCHAR2(8 CHAR);"""

CALC = """    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T';

    --[E20260820-D22VERPUSH] hook #129 ② — 단가 조인은 A.BASIS_START_DATE = C.YYYYMMDD 이고
    --  A 의 BASIS_START_DATE 는 SCM_SYS_CALENDAR_M(BASIS_YYYYMMDD BETWEEN P_NOW AND P_TO) 에서만 나온다.
    --  따라서 C.YYYYMMDD 의 하한은 그 구간의 MIN(BASIS_START_DATE) 로 **확정**된다(등가 · 결과 불변).
    SELECT MIN(BASIS_START_DATE)
      INTO v_price_from_yyyymmdd
      FROM SCM_MGR.SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD >= P_NOW_YYYYMMDD
       AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD;"""

P3A = """               AND C.YYYYMMDD          <= P_TO_YYYYMMDD
               --[E20260820-D22VERPUSH] hook #129 ② — 종전 C 는 access 술어가 없어 TABLE ACCESS FULL
               --  DM_PLN_CFM_SELLING_PRICE(1,069,693행/31,517블록, E-Rows 915K, 실측 disk 31,261).
               --  GT_DM22_RAW_DATA 는 전 적재문이 DIVISION_ID = P_DIVISION_ID 로 제한되어 단일값이므로
               --  A.DIVISION_ID = C.DIVISION_ID 와 결합해 C.DIVISION_ID = P_DIVISION_ID 는 등가 술어다.
               AND C.DIVISION_ID        = P_DIVISION_ID
               AND C.YYYYMMDD          >= NVL(v_price_from_yyyymmdd, '00000000')"""

P3B = """               AND C.YYYYMMDD        <= P_TO_YYYYMMDD
               --[E20260820-D22VERPUSH] hook #129 ② — 동일 결함. SCM_MST_FUTURE_PRICE(1,380,745행/30,720블록,
               --  E-Rows 858K, 실측 disk 30,497)에는 IX_YYYYMMDD_SCM_MST_FUTURE_PRICE(YYYYMMDD,DIVISION_ID)
               --  가 **이미 존재**하고 술어만 없었다(DMF0035 계보 동일).
               AND C.DIVISION_ID      = P_DIVISION_ID
               AND C.YYYYMMDD        >= NVL(v_price_from_yyyymmdd, '00000000')"""

P4A = """                 AND  B.YYYYMMDD        >= p_now_yyyymmdd
                 --[E20260820-D22VERPUSH] hook #129 ②/④ — B 에 access 술어가 없어 계획이
                 --  HASH JOIN + TABLE ACCESS FULL DM_PLN_SALES_PLAN_C(3,710,755행/88,637블록) 로 뒤집힌다
                 --  (실측 disk 91,969 / 0.86s). A(GT_DM22_RAW_DATA_TEMP40_KEY)는 DIVISION_ID = p_division_id
                 --  로 제한되어 있고, A.VERSION_NO = B.VERSION_NO 이며 _C 에는 'CURRENT' 행이 0건(실측)이므로
                 --  아래 두 술어는 등가이며 IX_DM_PLN_SALES_PLAN_C_N3(VERSION_NO,DIVISION_ID,YYYYMMDD,...) 선두를 연다.
                 AND  B.DIVISION_ID     = p_division_id
                 AND  B.VERSION_NO IN (SELECT V.VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO V)"""

P4B = """                 AND B.YYYYMMDD         >= p_now_yyyymmdd
                 --[E20260820-D22VERPUSH] hook #129 ②/④ — 동일 결함(GT_DM22_RTF_ENERGY 조인 경로).
                 --  A(GT_DM22_RTF_ENERGY)는 적재 시 A.DIVISION_ID = p_division_id 로 제한된다.
                 AND B.DIVISION_ID      = p_division_id
                 AND B.VERSION_NO IN (SELECT V.VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO V)"""

# 뒤에서 앞으로 치환해야 인덱스가 밀리지 않는다
plan = sorted([(I_DECL, DECL), (I_TRUNC, CALC), (I_P3A, P3A), (I_P3B, P3B),
               (I_P4A, P4A), (I_P4B, P4B)], reverse=True)
out = list(src)
for i, new in plan:
    out[i:i + 1] = new.splitlines()

txt = "\n".join(out)
assert txt.count("E20260820-D22VERPUSH") == 6, txt.count("E20260820-D22VERPUSH")
assert txt.count("E20260820-D22PREREDUCE") == 2
assert txt.count("E20260820-DS2") == 1
assert txt.count("v_measure_sheet") == 6
assert txt.count("v_price_from_yyyymmdd") == 4      # 선언 1 + INTO 1 + 사용 2
open(BASE + r"\02_PATCHED_B_PKG_DMF0022_BODY.sql", "w", encoding="utf-8").write(txt + "\n")
print(f"[built] 02_PATCHED_B_PKG_DMF0022_BODY.sql — {len(out)} lines (A본 {len(src)})")
print("  markers: VERPUSH", txt.count("E20260820-D22VERPUSH"),
      "/ PREREDUCE", txt.count("E20260820-D22PREREDUCE"),
      "/ DS2", txt.count("E20260820-DS2"),
      "/ v_measure_sheet", txt.count("v_measure_sheet"))
