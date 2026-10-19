# -*- coding: utf-8 -*-
"""[E20261012-DMF0082LATFIX] PKG_DMF0082.P_DMF0082_GET_MAIN_DATA 패치 모음 — (proc_text) -> (patched_text, 적용건수). 건수 assert 내장.

hook #129 1순위: MF_SP INSERT(L4182 부근)의 VD 인라인뷰(SCM_MST_SITE 82 VMI_STD_DIO 선집계)가 ON 절에 바인드 상수조건
`p_division_id = '82'` 를 가져서 옵티마이저가 집계 뷰를 lateral(VW_LAT_…)로 전개 → MERGE JOIN OUTER + BUFFER SORT 로
F(TEMP_FCST_N_PRICE) 행마다 재평가 (클라우드 R05 P0 · 사내 DBMS_XPLAN 동일 구조, 2026-10-12 실측).
조치 = 바인드 상수조건을 뷰 WHERE 안으로 이동. 등가: 비82 → 뷰 0행 → LEFT JOIN 미매칭 → VD.* NULL (기존 ON 거짓과 동일) / 82 → 동일.
"""

MARK = "E20261012-DMF0082LATFIX"


def _rep1(proc, old, new):
    c = proc.count(old)
    assert c == 1, f"앵커 {c}건 (1 기대): {old[:90]!r}"
    return proc.replace(old, new)


OLD_VD = (
    "        FROM   SCM_MGR.SCM_MST_SITE S\n"
    "        WHERE  S.DIVISION_ID = '82'\n"
    "        GROUP BY S.SCM_SITE_ID\n"
    "    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID\n"
    "         AND p_division_id  = '82'\n"
)
NEW_VD = (
    "        FROM   SCM_MGR.SCM_MST_SITE S\n"
    "        WHERE  S.DIVISION_ID = '82'\n"
    f"        AND    p_division_id = '82'  --[{MARK}] 구 ON 절 바인드 상수조건 → 뷰 안으로. ON 절에 두면 집계 뷰가 lateral(VW_LAT)로 전개되어 F 행마다 MERGE JOIN OUTER+BUFFER SORT 재평가(hook #129 1순위). 비82 = 뷰 0행 → LEFT JOIN NULL 동일\n"
    "        GROUP BY S.SCM_SITE_ID\n"
    "    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID\n"
)


def latfix(proc):
    """VD 인라인뷰 ON 절 바인드 조건 → 뷰 WHERE 이동 (1곳)."""
    return _rep1(proc, OLD_VD, NEW_VD), 1


# ---------------------------------------------------------------------------------------------
# 1-b [E20261012-DMF0082NOGRPBY] — MF_SP INSERT 의 GROUP BY 집계 제거 (항등 집계)
# 근거(2026-10-12 사내 실측 k0101 40/81): F(TEMP_FCST_N_PRICE) 행수 == GROUP BY 키 그룹 수 (152,390 / 184,612) · 그룹 내 >1행 0 · 속성 상이 0.
#   구조 근거: 직전 중복제거 블록(L3737~3749 DEDUPCHK/ROW_NUMBER DELETE)이 F 를 (DIVISION_ID…YYYYMMDD,MEASURE_GROUP) 키 유일로 만들고,
#   그 뒤 MF_SP INSERT 까지 F 에 INSERT/MERGE/UPDATE 없음(DELETE 만). 조인 상대 CAL(캘린더 BASIS_YYYYMMDD 유일 15,340/15,340 · WE/WE2/ME GROUP BY)·
#   PVT(GROUP BY 선집계)·VD(GROUP BY 선집계)는 모두 조인키 유일 → F 1행 = 결과 1행 → SUM/MAX 는 단일 행 항등.
#   따라서 SUM(F.QTY)→F.QTY, MAX(x)→x, NVL(MAX(x),' ')→NVL(x,' '), MAX('N')→'N', MAX(CASE…)→(CASE…), GROUP BY 제거 = 결과 동일.
#   효과: 60여 속성 컬럼 150K~440K 행 SORT GROUP BY(TEMP 108~268MB 유출) 제거.
# ---------------------------------------------------------------------------------------------
import re as _re

MARK2 = "E20261012-DMF0082NOGRPBY"


def _sub1(proc, pattern, repl, flags=0):
    new, n = _re.subn(pattern, repl, proc, flags=flags)
    assert n == 1, f"패턴 {n}건 (1 기대): {pattern[:80]!r}"
    return new


def nogrpby(proc):
    """MF_SP INSERT: 집계 함수 제거 + GROUP BY 절 제거 (항등 집계 — 위 근거 주석 참조). latfix 가 먼저 적용된 원문 기준."""
    s0 = proc.index("    INSERT /*[E20260812-PERF] APPEND PARALLEL 제거")
    s1 = proc.index(", CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN;", s0)
    s1 = proc.index("\n", s1) + 1
    blk, before, after = proc[s0:s1], proc[:s0], proc[s1:]
    assert "GT_DMF0082_MF_SP" in blk[:400] and blk.count("GROUP BY F.DIVISION_ID") == 1
    n_total = 0
    blk = _sub1(blk, r"SUM\(F\.QTY\) AS QTY", f"F.QTY AS QTY  --[{MARK2}] 집계 제거(항등 — 직전 중복제거 블록이 F 를 키 유일로 보장, 조인 상대 전부 조인키 유일)"); n_total += 1
    blk, n = _re.subn(r"MAX\((F\.\w+)\)", r"\1", blk); assert n == 47, f"MAX(F.x) {n}건 (47 기대 — L4203~4220 속성 컬럼 실측)"; n_total += n
    blk = _sub1(blk, r"MAX\('N'\) AS NEW_FLAG", "'N' AS NEW_FLAG"); n_total += 1
    blk = _sub1(blk, r"MAX\(CASE WHEN p_scm_site_id IS NULL", "(CASE WHEN p_scm_site_id IS NULL"); n_total += 1
    blk = _sub1(blk, r"MAX\(VD\.VMI_STD_DIO\) AS VMI_STD_DIO", "VD.VMI_STD_DIO AS VMI_STD_DIO"); n_total += 1
    # GROUP BY 절 제거: 'VD ON ... F.SCM_SITE_ID' 줄 끝에 ';' 를 붙이고 GROUP BY 6줄을 주석 설명으로 대체
    blk = _sub1(blk,
        r"(    \) VD ON  VD\.SCM_SITE_ID = F\.SCM_SITE_ID)\n"
        r"    GROUP BY F\.DIVISION_ID, F\.PROJECT_CODE, F\.END_CUSTOMER, F\.SCM_SITE_ID, F\.ITEM_ID\n"
        r"           , F\.DOM_EXP, F\.FCST_TYPE, F\.INCOTERMS, F\.MEASURE, F\.PLANT_SITE_ID\n"
        r"           , F\.CELL_PROD_SITE_ID, CAL\.BUCKET_TYPE, CAL\.BUCKET_KEY, F\.MEASURE_GROUP\n"
        r"           , F\.SORT_ORDER_NO\n"
        r"           , PVT\.SUN, PVT\.MON, PVT\.TUE, PVT\.WED, PVT\.THU, PVT\.FRI, PVT\.SAT\n"
        r"           , CAL\.YYYYMM, CAL\.YYYYMMWW, CAL\.WEEK_END_YN, CAL\.MONTH_END_YN;\n",
        r"\1;\n"
        f"    --[{MARK2}] 구 GROUP BY(F 키 11 + CAL/PVT 파생 15 컬럼) 제거 — 직전 중복제거 블록(DEDUPCHK/ROW_NUMBER DELETE) 뒤 F 는\n"
        f"    --   (DIVISION_ID…YYYYMMDD,MEASURE_GROUP) 키 유일이고 MF_SP INSERT 까지 F 쓰기 없음, CAL(캘린더 일자 유일·WE/WE2/ME 선집계)·PVT·VD 는 조인키 유일\n"
        f"    --   → 그룹 = 1행(사내 실측 152,390/152,390 · 184,612/184,612) → SUM/MAX 항등. 60속성 150K~440K 행 SORT GROUP BY(TEMP 유출) 제거.\n"); n_total += 1
    # 잔존 집계 점검 — 외부 SELECT 의 집계만 제거 대상 (인라인뷰 WE2/ME MAX(BASIS_YYYYMMDD) · PVT MAX(CASE WHEN BC.) · VD MAX(S.VMI_YN) 과 주석의 'MAX(CASE …)' 는 유지)
    for tok in ("MAX(F.", "SUM(", "MAX('N')", "MAX(CASE WHEN p_scm_site_id", "MAX(VD.", "GROUP BY F."):
        assert tok not in blk, f"집계 잔존: {tok}"
    return before + blk + after, n_total
