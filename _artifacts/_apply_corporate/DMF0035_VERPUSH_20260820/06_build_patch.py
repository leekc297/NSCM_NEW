# -*- coding: utf-8 -*-
"""[E20260820-VERPUSH] PKG_DMF0035 BODY 패치본 생성 — 라인 정밀 삽입 (적용은 별도).

대상: INSERT INTO SCM_MGR.GT_DM35_T_LAST_SETUP_C 2문(L1526 / L1861)의 원천표 3분기.
효과: 버전 술어가 표 접근 **이후** outer JOIN 으로만 걸려 access predicate 가 DIVISION_ID 하나뿐이던 것을,
      분기 안으로 push 하여 PK 2번째 컬럼 VERSION_NO 까지 access predicate 로 승격시킨다.
등가: 기존 outer `JOIN GT_DM35_VERSION C ON A.VERSION_NO = C.VERSION_NO` 가 이미 동일 집합으로 제한하므로
      결과 집합 불변. IN 은 semi-join 이라 GTT 중복 VERSION_NO 가 있어도 행이 늘지 않는다.
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_VERPUSH_20260820"
src = open(BASE + r"\00_BACKUP_PKG_DMF0035_BODY.sql", encoding="utf-8").read().splitlines()
ORIG_N = len(src)


def chk(ln, frag):
    """전제 assert — 치환 대상 문자열이 그 라인에 실제로 있는지 먼저 확인, 없으면 중단."""
    assert frag in src[ln - 1], f"L{ln} 전제 불일치:\n  기대 {frag!r}\n  실제 {src[ln-1]!r}"


MARK = "[E20260820-VERPUSH]"
C16 = f"                --{MARK} 버전 술어를 UNION ALL 분기 안으로 push (outer JOIN GT_DM35_VERSION 과 동일 집합 — 결과 불변)"
C16b = "                --  PK(DIVISION_ID, VERSION_NO, ...) 2번째 컬럼이 access predicate 로 승격 → rowid 개별 fetch 급감"
C12 = f"            --{MARK} 동일 취지 — 아래 JOIN GT_DM35_VERSION C ON A.VERSION_NO = C.VERSION_NO 와 같은 집합"
PRED16 = "                AND F.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM35_VERSION)"
PRED12 = "            AND   A.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM35_VERSION)"

# ---- 전제 검증 (INSERT#1 = L1526 / INSERT#2 = L1861) ----
chk(1526, "INSERT INTO SCM_MGR.GT_DM35_T_LAST_SETUP_C")
chk(1547, "FROM SCM_MGR.DM_PLN_MKT_FCST_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2")
chk(1551, "FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1")
chk(1557, "JOIN SCM_MGR.GT_DM35_VERSION C")
chk(1558, "ON A.VERSION_NO = C.VERSION_NO")
chk(1578, "FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A")
chk(1583, "JOIN SCM_MGR.GT_DM35_VERSION C")
chk(1584, "ON A.VERSION_NO = C.VERSION_NO")
chk(1586, "WHERE A.DIVISION_ID = P_DIVISION_ID")
chk(1587, "AND   A.QTY <> 0")
chk(1588, "GROUP BY A.VERSION_NO")

chk(1861, "INSERT INTO SCM_MGR.GT_DM35_T_LAST_SETUP_C")
chk(1882, "FROM SCM_MGR.DM_PLN_MKT_FCST_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2")
chk(1886, "FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1")
chk(1892, "JOIN SCM_MGR.GT_DM35_VERSION C")
chk(1893, "ON A.VERSION_NO = C.VERSION_NO")
chk(1913, "FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A")
chk(1918, "JOIN SCM_MGR.GT_DM35_VERSION C")
chk(1919, "ON A.VERSION_NO = C.VERSION_NO")
chk(1921, "WHERE A.DIVISION_ID = P_DIVISION_ID")
chk(1922, "AND   A.QTY <> 0")
chk(1923, "GROUP BY A.VERSION_NO")
print("[assert] 전제 22축 전부 일치")

# ---- 삽입 (라인 번호 밀림 방지 위해 내림차순) ----
INSERTS = [
    (1922, [C12, PRED12]),                 # INSERT#2 분기3 DM_PLN_MKT_FCST_RESULT_C
    (1886, [C16, PRED16]),                 # INSERT#2 분기2 DM_PLN_CFM_MKT_DEMAND_PLAN_C
    (1882, [C16, PRED16]),                 # INSERT#2 분기1 DM_PLN_MKT_FCST_C
    (1587, [C12, PRED12]),                 # INSERT#1 분기3 DM_PLN_MKT_FCST_RESULT_C
    (1551, [C16, PRED16]),                 # INSERT#1 분기2 DM_PLN_CFM_MKT_DEMAND_PLAN_C
    (1547, [C16, C16b, PRED16]),           # INSERT#1 분기1 DM_PLN_MKT_FCST_C
]
out = list(src)
for after_ln, lines in INSERTS:          # after_ln 뒤에 삽입 (1-based)
    out[after_ln:after_ln] = lines

txt = "\n".join(out)
# ---- 산출 자기검증 ----
assert txt.count(MARK) == 6, f"마커 {txt.count(MARK)} (기대 6)"
assert txt.count("AND F.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM35_VERSION)") == 4
assert txt.count("AND   A.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM35_VERSION)") == 2
assert len(out) == ORIG_N + 13, f"{len(out)} vs {ORIG_N}+13"
# 원본 라인은 1줄도 변경되지 않았는지 (삽입 only) 검증
added = {l for _, ls in INSERTS for l in ls}
assert [l for l in out if l not in added] == src, "원본 라인 변형 발생 — 중단"
assert txt.upper().lstrip().startswith("PACKAGE BODY"), txt[:60]
open(BASE + r"\01_PATCHED_PKG_DMF0035_BODY.sql", "w", encoding="utf-8").write(txt + "\n")
print(f"[built] 01_PATCHED_PKG_DMF0035_BODY.sql ({len(out)} lines, 원본 {ORIG_N}, 삽입 13줄 / 원본 변형 0)")
