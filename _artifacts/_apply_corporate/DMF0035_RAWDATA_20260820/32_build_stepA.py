# -*- coding: utf-8 -*-
"""STEP A — [E20260820-RAWSCALAR] L1610-1723 상관 스칼라 10개 → 선계산 LEFT JOIN 3본 치환 (패치본 생성만).

설계 원칙
  · **전사 금지**: MEASURE IN 목록은 원본 라인에서 정규식으로 그대로 추출해 재사용한다
    (anti-simplification §1.4 — 손으로 옮겨 적으면 집합이 달라질 위험).
  · 치환은 서브쿼리 라인만. 그 외 라인(IN 목록·주석·CASE 골격)은 **바이트 동일** 유지.
  · 선계산 뷰 3본은 전부 조인키로 GROUP BY → 키당 최대 1행 → 행 증식 0.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
src = open(BASE + r"\00_BACKUP_PKG_DMF0035_BODY.sql", encoding="utf-8").read().split("\n")
if src and src[-1] == "":
    src.pop()
print(f"[원본] {len(src)} lines")


def L(n):                      # 1-based 조회
    return src[n - 1]


def chk(n, frag):
    assert frag in L(n), f"L{n} 전제 불일치:\n  기대 포함: {frag!r}\n  실제      : {L(n)!r}"


# ---------- 전제 assert (대상 문자열 실재 확인 — 없으면 중단) ----------
chk(1610, "INSERT INTO SCM_MGR.GT_DM35_RAW_DATA")
chk(1632, ", 'P', 3")
chk(1637, "(SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS")
chk(1642, "AND    LS.MEASURE IN (")
chk(1644, "WHEN A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST') THEN")
chk(1645, "(SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS")
chk(1648, "AND    LS.MEASURE IN (")
chk(1649, "WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN")
chk(1650, "(SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS")
chk(1653, "AND    LS.MEASURE IN (")
chk(1654, "ELSE (SELECT LS.CREATE_DATE FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS")
chk(1656, "AND LS.MEASURE = A.MEASURE)")
chk(1657, "END)")
chk(1668, "(SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID) || '_EDI'")
chk(1670, "WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN")
chk(1671, "(SELECT MAX(LS.LAST_UPDATED_BY) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS")
chk(1675, "AND    LS.CREATE_DATE = (SELECT MAX(LS2.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS2")
chk(1678, "AND    LS2.MEASURE IN (")
chk(1679, "ELSE (SELECT LS.LAST_UPDATED_BY FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS")
chk(1681, "AND LS.MEASURE = A.MEASURE)")
chk(1682, "END)")
chk(1688, "(SELECT MAX(ES.SENDER_CODE) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)")
chk(1696, "(SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)")
chk(1705, "FROM (")
chk(1713, ") A")
chk(1714, "JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE")
chk(1716, "JOIN SCM_MGR.GT_DM35_VERSION E")
chk(1718, "AND (E.VERSION_NO LIKE '%MF%' OR E.VERSION_NO LIKE '%SF%')")
chk(1719, "WHERE A.YYYYMMDD >= P_FROM_YYYYMMDD")
print("[assert] 전제 24축 통과")


# ---------- MEASURE 집합을 원본에서 그대로 추출 (전사 금지) ----------
def measure_set(n):
    """`MEASURE IN (` 직후의 **괄호 균형** 구간만 추출 (중첩 서브쿼리의 여분 ')' 오취득 방지)."""
    s = L(n)
    m = re.search(r"MEASURE IN \(", s)
    assert m, f"L{n} MEASURE IN 목록 추출 실패: {s!r}"
    i, depth, in_q = m.end() - 1, 0, False
    while i < len(s):
        c = s[i]
        if in_q:
            if c == "'":
                in_q = False
        elif c == "'":
            in_q = True
        elif c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                return s[m.end():i]
        i += 1
    raise AssertionError(f"L{n} 괄호 불균형: {s!r}")


S1, S2, S3 = measure_set(1642), measure_set(1648), measure_set(1653)
assert measure_set(1678) == S3, "L1678(LS2) 집합이 L1653(S3) 과 다름 — 설계 전제 붕괴"
for nm, s in (("S1", S1), ("S2", S2), ("S3", S3)):
    print(f"  {nm}: {s[:120]}{'...' if len(s) > 120 else ''}")

# 원본 상관키 (8컬럼) — L1638~1639 에서 확인된 그대로
KEY = ["DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE", "INCOTERMS", "VERSION_NO"]
for c in KEY:
    assert f"LS.{c} = A.{c}" in (L(1638) + L(1639)), f"상관키 {c} 원본 미확인"
print(f"[assert] 상관키 8컬럼 원본 확인: {','.join(KEY)}")

MARK = "E20260820-RAWSCALAR"

# ---------- 치환 (라인 정밀) ----------
HEAD = [
    f"             --[{MARK}] 행별 상관 스칼라 서브쿼리 10개 → 선계산 LEFT JOIN 3본 치환 (hook #129 ① 최우선)",
    "             --  근거(사내 플랜 g0w0gvnn7rkb2 실측): Id 2~20 이 전부 TABLE ACCESS FULL + filter only",
    "             --    (access predicate 없음). 상관키가 8~9컬럼이라 스칼라 서브쿼리 캐시가 사실상 무효 →",
    "             --    외부행마다 GT_DM35_T_LAST_SETUP_C 7회 + GT_DM35_EDI_SENDER 3회 전면스캔.",
    "             --  치환 대상 뷰는 FROM 절 하단 LEFT JOIN 참조: LS_K(상관키별) / LS_M(상관키+MEASURE) / ES_S(SCM_SITE_ID).",
    "             --  값 동등성: 세 뷰 모두 **조인키로 GROUP BY** 되어 키당 최대 1행 → 행 증식 0.",
    "             --            NULL 키는 원본 상관 등호(= NULL)와 동일하게 미매칭 → NULL 반환.",
]

REPL = {
    (1637, 1642): ["                     LS_K.CREATE_DATE_S1"],
    (1645, 1648): ["                     LS_K.CREATE_DATE_S2"],
    (1650, 1653): ["                     LS_K.CREATE_DATE_S3"],
    (1654, 1656): ["                ELSE LS_M.CREATE_DATE"],
    (1668, 1668): ["                                ES_S.SENDER_NAME || '_EDI'"],
    (1671, 1678): ["                     LS_K.LAST_UPDATED_BY_S3"],
    (1679, 1681): ["                ELSE LS_M.LAST_UPDATED_BY"],
    (1688, 1688): ["                                ES_S.SENDER_CODE"],
    (1696, 1696): ["                                ES_S.SENDER_NAME"],
}

JOINS = [
    f"        --[{MARK}] 상관 스칼라 대체 선계산 3본. 각 뷰가 조인키로 GROUP BY 되어 키당 1행 = 행 증식 없음.",
    "        LEFT JOIN (SELECT " + ", ".join(KEY),
    f"                        , MAX(CASE WHEN MEASURE IN ({S1}) THEN CREATE_DATE END) AS CREATE_DATE_S1",
    f"                        , MAX(CASE WHEN MEASURE IN ({S2}) THEN CREATE_DATE END) AS CREATE_DATE_S2",
    f"                        , MAX(CASE WHEN MEASURE IN ({S3}) THEN CREATE_DATE END) AS CREATE_DATE_S3",
    "                        --  원본: MAX(LAST_UPDATED_BY) WHERE CREATE_DATE = (SELECT MAX(CREATE_DATE) … 동일키·동일 MEASURE 집합)",
    "                        --  → 정렬키를 RTF 계열만 남긴 CREATE_DATE 로 두고 KEEP (DENSE_RANK LAST … NULLS FIRST).",
    "                        --    · RTF 계열이 없으면 정렬키 전부 NULL → 집계 CASE 도 NULL → 원본과 동일하게 NULL",
    "                        --    · RTF 계열은 있으나 CREATE_DATE 가 전부 NULL 이면 원본 등호(= NULL)가 미성립 → NULL.",
    "                        --      집계 CASE 의 CREATE_DATE IS NOT NULL 조건이 같은 NULL 을 만든다",
    "                        --    · 그 외에는 NULLS FIRST 로 최대 CREATE_DATE 그룹이 마지막 → 원본 등호 대상과 동일 집합",
    f"                        , MAX(CASE WHEN MEASURE IN ({S3}) AND CREATE_DATE IS NOT NULL THEN LAST_UPDATED_BY END)",
    f"                              KEEP (DENSE_RANK LAST ORDER BY CASE WHEN MEASURE IN ({S3}) THEN CREATE_DATE END NULLS FIRST) AS LAST_UPDATED_BY_S3",
    "                     FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C",
    "                    GROUP BY " + ", ".join(KEY) + ") LS_K",
    "               ON  " + "\n               AND ".join(f"LS_K.{c} = A.{c}" for c in KEY),
    "        LEFT JOIN (SELECT " + ", ".join(KEY) + ", MEASURE",
    "                        --  원본 ELSE 분기는 비집계 스칼라(키+MEASURE 유일 전제, 중복이면 원본은 ORA-01427).",
    "                        --  MAX() 로 감싸 행 증식을 원천 차단 — 유일할 때 값은 원본과 동일.",
    "                        , MAX(CREATE_DATE) AS CREATE_DATE, MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY",
    "                     FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C",
    "                    GROUP BY " + ", ".join(KEY) + ", MEASURE) LS_M",
    "               ON  " + "\n               AND ".join(f"LS_M.{c} = A.{c}" for c in KEY),
    "               AND LS_M.MEASURE = A.MEASURE",
    "        LEFT JOIN (SELECT SCM_SITE_ID, MAX(SENDER_CODE) AS SENDER_CODE, MAX(SENDER_NAME) AS SENDER_NAME",
    "                     FROM SCM_MGR.GT_DM35_EDI_SENDER GROUP BY SCM_SITE_ID) ES_S",
    "               ON  ES_S.SCM_SITE_ID = A.SCM_SITE_ID",
]
JOINS = "\n".join(JOINS).split("\n")

out, n = [], 1
while n <= len(src):
    if n == 1633:
        out.extend(HEAD)
    hit = next(((a, b) for (a, b) in REPL if a == n), None)
    if hit:
        out.extend(REPL[hit])
        n = hit[1] + 1
        continue
    out.append(L(n))
    if n == 1718:
        out.extend(JOINS)
    n += 1

txt = "\n".join(out)

# ---------- 사후 assert ----------
assert txt.count(MARK) == 2, f"마커 {txt.count(MARK)}개 (기대 2)"
for old in ("SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C",
            "SELECT LS.CREATE_DATE FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C",
            "SELECT MAX(LS.LAST_UPDATED_BY) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C",
            "SELECT LS.LAST_UPDATED_BY FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C",
            "SELECT MAX(LS2.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C"):
    # 대상 문장 구간(L1610~) 안에서 제거됐는지 — 다른 문장의 동일 패턴은 건드리지 않았으므로 전체 카운트는 감소만 확인
    pass
before_cnt = "\n".join(src).count("SCM_MGR.GT_DM35_T_LAST_SETUP_C LS")
after_cnt = txt.count("SCM_MGR.GT_DM35_T_LAST_SETUP_C LS")
print(f"[제거] 'GT_DM35_T_LAST_SETUP_C LS' 상관 스칼라 참조 {before_cnt} → {after_cnt} (이 문장분 -7)")
assert before_cnt - after_cnt == 7, f"제거 수 {before_cnt-after_cnt} (기대 7)"
b_es = "\n".join(src).count("FROM SCM_MGR.GT_DM35_EDI_SENDER ES")
a_es = txt.count("FROM SCM_MGR.GT_DM35_EDI_SENDER ES")
print(f"[제거] 'GT_DM35_EDI_SENDER ES' 상관 스칼라 참조 {b_es} → {a_es} (이 문장분 -3)")
assert b_es - a_es == 3, f"제거 수 {b_es-a_es} (기대 3)"
for tok in ("LS_K.CREATE_DATE_S1", "LS_K.CREATE_DATE_S2", "LS_K.CREATE_DATE_S3",
            "LS_M.CREATE_DATE", "LS_K.LAST_UPDATED_BY_S3", "LS_M.LAST_UPDATED_BY"):
    assert txt.count(tok) == 1, f"{tok} {txt.count(tok)}회 (기대 1)"
assert txt.count("ES_S.SENDER_NAME") == 2, f"ES_S.SENDER_NAME {txt.count('ES_S.SENDER_NAME')}회 (기대 2: L1668 '_EDI' + L1696)"
assert txt.count("ES_S.SENDER_CODE") == 1, f"ES_S.SENDER_CODE {txt.count('ES_S.SENDER_CODE')}회 (기대 1: L1688)"
assert txt.count(") ES_S") == 1 and txt.count(") LS_K") == 1 and txt.count(") LS_M") == 1, "선계산 뷰 별칭 수 불일치"
# 기존 마커 보존
for mk, k in (("E20260820-DS2", 1), ("E20260820-WFITEMPERF", 2), ("E20260820-VERPUSH", 6)):
    c = txt.count(mk)
    assert c == k, f"{mk} {c}개 (기대 {k}) — 기존 패치 훼손"
print("[assert] 사후 12축 통과 / 기존 마커 DS2 1·WFITEMPERF 2·VERPUSH 6 보존")

open(BASE + r"\01_PATCHED_STEPA_BODY.sql", "w", encoding="utf-8").write(txt + "\n")
print(f"[built] 01_PATCHED_STEPA_BODY.sql — {len(out)} lines (원본 {len(src)}, +{len(out)-len(src)})")
