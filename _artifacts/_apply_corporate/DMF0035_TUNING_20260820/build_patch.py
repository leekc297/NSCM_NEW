# -*- coding: utf-8 -*-
"""E20260820-WFITEMPERF — PKG_DMF0035 BODY 패치본 생성 (라인 정밀 치환, 적용은 별도)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_TUNING_20260820"
src = open(BASE + r"\PKG_DMF0035_BODY_LIVE.sql", encoding="utf-8").read().splitlines()

# 전제 assert (1-based 라인)
def chk(ln, frag):
    assert frag in src[ln - 1], f"L{ln} 전제 불일치: {src[ln-1][:90]!r}"

chk(3095, "SELECT DIVISION_ID")
chk(3096, ", FLOW_ID")
chk(3097, ", ITEM_ID")
chk(3100, "THEN GROUP_CODE1")
chk(3101, "THEN LEVEL2_CODE")
chk(3103, "= 'EC' THEN 'ESS'")
chk(3118, "END AS BASIC_NICKNAME_CELL40")
chk(3122, "FROM SCM_MGR.SCP_MST_FINAL_ITEM A")
chk(3123, "WHERE 1=1")

# bare 컬럼 → A. 접두 (신규 조인과의 ORA-00918 방지 — 서브쿼리 컬럼 캡처 계보)
src[3094] = src[3094].replace("SELECT DIVISION_ID", "SELECT A.DIVISION_ID")
src[3095] = src[3095].replace(", FLOW_ID", ", A.FLOW_ID")
src[3096] = src[3096].replace(", ITEM_ID", ", A.ITEM_ID")
src[3099] = src[3099].replace("THEN GROUP_CODE1", "THEN A.GROUP_CODE1")
src[3100] = src[3100].replace("THEN LEVEL2_CODE", "THEN A.LEVEL2_CODE")

NEW_CASE = """                 --[E20260820-WFITEMPERF] 행별 상관 스칼라 2분기(GT_DM35_ITEM_SINGLE_ORI 전면스캔 x 외부행)
                 --  → 선계산 LEFT JOIN 치환 (hook #129 ①). 실측: MKT GET 141.1s / buffer_gets 1.68억 → 조인 1회.
                 --  ROWNUM=1(비결정 임의 1행) → MAX(DOE)(결정적) 치환 — (DIVISION,ITEM)별 DOE 다값이면 최대값 채택.
                 , CASE WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'EC' THEN 'ESS'
                        WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'AM' THEN 'M50L'
                   ELSE CASE WHEN A.OPERATION_GROUP = 'P' THEN NK_P.NICK_NAME
                             ELSE NK_I.NICK_NAME
                        END
                   END AS BASIC_NICKNAME_CELL40"""

NEW_JOIN = """            --[E20260820-WFITEMPERF] DOE 선계산(GTT 1회 집계) + NICK_NAME 1:1 조인(PK_SCP_MST_FINAL_ITEM)
            LEFT JOIN (SELECT DIVISION_ID, ITEM_ID, MAX(DOE) AS DOE
                         FROM SCM_MGR.GT_DM35_ITEM_SINGLE_ORI
                        WHERE DOE IS NOT NULL
                        GROUP BY DIVISION_ID, ITEM_ID) DOE_P
                   ON DOE_P.DIVISION_ID = A.DIVISION_ID AND DOE_P.ITEM_ID = A.ATTRIBUTE1
            LEFT JOIN (SELECT DIVISION_ID, ITEM_ID, MAX(DOE) AS DOE
                         FROM SCM_MGR.GT_DM35_ITEM_SINGLE_ORI
                        WHERE DOE IS NOT NULL
                        GROUP BY DIVISION_ID, ITEM_ID) DOE_I
                   ON DOE_I.DIVISION_ID = A.DIVISION_ID AND DOE_I.ITEM_ID = A.ITEM_ID
            LEFT JOIN SCM_MGR.SCP_MST_FINAL_ITEM NK_P
                   ON NK_P.DIVISION_ID = A.DIVISION_ID AND NK_P.ITEM_ID = DOE_P.DOE
            LEFT JOIN SCM_MGR.SCP_MST_FINAL_ITEM NK_I
                   ON NK_I.DIVISION_ID = A.DIVISION_ID AND NK_I.ITEM_ID = DOE_I.DOE"""

# 3103~3118 (0-based 3102..3117) CASE 블록 치환 + 3122 뒤 JOIN 삽입
out = src[:3102] + NEW_CASE.splitlines() + src[3118:3122] + NEW_JOIN.splitlines() + src[3122:]

txt = "\n".join(out)
assert txt.count("E20260820-WFITEMPERF") == 2
assert "GT_DM35_ITEM_SINGLE_ORI B WHERE" not in txt, "구 스칼라 잔존"
assert txt.count("NK_P.NICK_NAME") == 1 and txt.count("NK_I.NICK_NAME") == 1
open(BASE + r"\PKG_DMF0035_BODY_PATCHED.sql", "w", encoding="utf-8").write(txt + "\n")
print(f"[built] PKG_DMF0035_BODY_PATCHED.sql ({len(out)} lines, 원본 {len(src)})")
