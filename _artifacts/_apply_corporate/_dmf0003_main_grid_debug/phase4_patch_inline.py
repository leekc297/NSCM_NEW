"""Phase 4 — SP body 안 line 738~748 (ITEM_SINGLE_V INSERT WHERE EXISTS) 의 룰 6 적용.
   기존 028_sp_body_patched_v3.sql 을 base 로 patch + 028_sp_body_patched_v4.sql 빌드.

기존:
    WHERE T1.DIVISION_ID = P_DIVISION_ID
      AND EXISTS (
               SELECT 1 FROM (split P_ITEM_ID with '%' || token || '%') B
               WHERE T1.ITEM_ID LIKE B.TST OR T1.NICK_NAME LIKE B.TST )

룰 6 적용:
    WHERE T1.DIVISION_ID = P_DIVISION_ID
      AND ( P_ITEM_ID IS NULL OR P_ITEM_ID IN ('ALL','%','')
            OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID B
                        WHERE T1.ITEM_ID LIKE '%' || B.TOK || '%'
                           OR T1.NICK_NAME LIKE '%' || B.TOK || '%') )
"""
import pathlib, re, sys

BASE = pathlib.Path(__file__).parent
SRC = BASE / "028_sp_body_patched_v3.sql"
DST = BASE / "028_sp_body_patched_v4.sql"

text = SRC.read_text(encoding="utf-8")

# Pattern: ITEM_SINGLE_V INSERT 의 EXISTS 블록
OLD = """    WHERE  T1.DIVISION_ID = P_DIVISION_ID
      AND  EXISTS (
               SELECT 1
               FROM (
                   SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' AS TST
                   FROM DUAL
                   CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
               ) B
               WHERE T1.ITEM_ID   LIKE B.TST
                  OR T1.NICK_NAME LIKE B.TST
           )"""

NEW = """    WHERE  T1.DIVISION_ID = P_DIVISION_ID
      -- ⭐ Phase 4 (룰 6 적용): 'ALL'/'%'/'' 시 short-circuit, GT_GGET_SPLIT_ITEM_ID 사용
      AND  ( P_ITEM_ID IS NULL OR P_ITEM_ID IN ('ALL','%','')
             OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID B
                         WHERE T1.ITEM_ID   LIKE '%' || B.TOK || '%'
                            OR T1.NICK_NAME LIKE '%' || B.TOK || '%') )"""

if OLD not in text:
    sys.exit(f"FAIL: ITEM_SINGLE_V EXISTS 블록 매치 실패 (Phase 1+2+3 patched 텍스트 확인 필요)")

new_text = text.replace(OLD, NEW, 1)
DST.write_text(new_text, encoding="utf-8")

print(f"[OK] Phase 4 patched: ITEM_SINGLE_V INSERT EXISTS → 'ALL' short-circuit")
print(f"[OK] built: {DST} ({new_text.count(chr(10)):,} lines)")
