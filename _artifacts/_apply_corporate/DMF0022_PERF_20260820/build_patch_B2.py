# -*- coding: utf-8 -*-
"""Stage B' — [E20260820-D22VERPUSH] 채택분만 (P4a/P4b). P3a/P3b 는 실측 악화로 철회.

철회 근거(사내 실측 2026-08-20/21):
  P3a DM_PLN_CFM_SELLING_PRICE 에 division+기간 하한을 추가하자 옵티마이저가
      PK_DM_PLN_CFM_SELLING_PRICE(DIVISION_ID,PROJECT_CODE,END_CUSTOMER,...) NL 로 전환.
      조인이 PK 3번째 컬럼 END_CUSTOMER 를 공급하지 않아 range 가 끊기고
      0.331s / 32,070 buffer → 3.749s / 1,178,150 buffer 로 악화(SQL_ID ftz4kvgxttgk9).
  P3b SCM_MST_FUTURE_PRICE 도 동일 계열로 C2/C6 악화 → 함께 철회.
  ⇒ 구조 변경만으로는 여기까지. 잔여는 ③ 인덱스 신설 제안으로 이관(적용 안 함).
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_PERF_20260820"
src = open(BASE + r"\01_PATCHED_A_PKG_DMF0022_BODY.sql", encoding="utf-8").read().splitlines()


def uniq(frag):
    idx = [i for i, l in enumerate(src) if l == frag]
    assert len(idx) == 1, f"전제 불일치: {frag!r} → {len(idx)}건"
    return idx[0]


I_P4A = uniq("                 AND  B.YYYYMMDD        >= p_now_yyyymmdd")
I_P4B = uniq("                 AND B.YYYYMMDD         >= p_now_yyyymmdd")
assert "DM_PLN_SALES_PLAN_C B" in src[I_P4A - 12], src[I_P4A - 12]
assert "DM_PLN_SALES_PLAN_C B" in src[I_P4B - 15], src[I_P4B - 15]
print("전제 assert OK — P4a L%d / P4b L%d" % (I_P4A + 1, I_P4B + 1))

P4A = """                 AND  B.YYYYMMDD        >= p_now_yyyymmdd
                 --[E20260820-D22VERPUSH] hook #129 ②/④ — B 에 access 술어가 없어 계획이
                 --  HASH JOIN + TABLE ACCESS FULL DM_PLN_SALES_PLAN_C(3,710,755행/88,637블록) 로 뒤집힌다
                 --  (사내 실측 disk 91,969 / 0.861s, SQL_ID 0jg5q91v6uvm9). A(GT_DM22_RAW_DATA_TEMP40_KEY)는
                 --  DIVISION_ID = p_division_id 로 제한되고, A.VERSION_NO = B.VERSION_NO 이며 _C 에는
                 --  VERSION_NO='CURRENT' 행이 0건(실측)이므로 아래 두 술어는 결과 등가이며
                 --  IX_DM_PLN_SALES_PLAN_C_N3(VERSION_NO,DIVISION_ID,YYYYMMDD,MEASURE,CUTOFF_YYYYMMDD) 선두를 연다.
                 AND  B.DIVISION_ID     = p_division_id
                 AND  B.VERSION_NO IN (SELECT V.VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO V)"""

P4B = """                 AND B.YYYYMMDD         >= p_now_yyyymmdd
                 --[E20260820-D22VERPUSH] hook #129 ②/④ — 동일 결함(GT_DM22_RTF_ENERGY 조인 경로).
                 --  A(GT_DM22_RTF_ENERGY)는 적재 시 WHERE A.DIVISION_ID = p_division_id 로 제한된다.
                 AND B.DIVISION_ID      = p_division_id
                 AND B.VERSION_NO IN (SELECT V.VERSION_NO FROM SCM_MGR.GT_DM22_V_VERSION_NO V)"""

out = list(src)
for i, new in sorted([(I_P4A, P4A), (I_P4B, P4B)], reverse=True):
    out[i:i + 1] = new.splitlines()

txt = "\n".join(out)
assert txt.count("E20260820-D22VERPUSH") == 2
assert txt.count("E20260820-D22PREREDUCE") == 2
assert txt.count("E20260820-DS2") == 1
assert txt.count("v_measure_sheet") == 6
assert "v_price_from_yyyymmdd" not in txt, "P3 잔재"
assert "C.DIVISION_ID        = P_DIVISION_ID" not in txt and "C.DIVISION_ID      = P_DIVISION_ID" not in txt
open(BASE + r"\02_PATCHED_B2_PKG_DMF0022_BODY.sql", "w", encoding="utf-8").write(txt + "\n")
print(f"[built] 02_PATCHED_B2_PKG_DMF0022_BODY.sql — {len(out)} lines (A본 {len(src)})")
print("  markers: VERPUSH", txt.count("E20260820-D22VERPUSH"),
      "/ PREREDUCE", txt.count("E20260820-D22PREREDUCE"),
      "/ DS2", txt.count("E20260820-DS2"), "/ v_measure_sheet", txt.count("v_measure_sheet"))
