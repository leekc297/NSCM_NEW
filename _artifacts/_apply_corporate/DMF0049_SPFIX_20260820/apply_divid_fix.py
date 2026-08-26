# -*- coding: utf-8 -*-
"""[E20260820-DIVIDSCALAR] PKG_DMF0049 SAVE — 벌크 파라미터를 스칼라 비교에 쓰던 3곳 정정.

결함: `p_division_id` 는 '^' 벌크 원문("40^40^40…")이라 2행 이상 payload 에서
  · L1030 `WHERE DIVISION_ID = p_division_id`  → GT_DMF0049_TEMP_ITEM_SINGLE 항상 0행
      ⇒ 이후 UPDATE 가 NICK_NAME / FORECAST_INFO_SPEC / FORECAST_INFO_CELL_PACK_COUNT 를
        **저장할 때마다 NULL 로 덮어씀**(nullable 이라 조용히 진행)
  · L1058 / L1063 `CASE WHEN p_division_id = '40'` → 40 "기타부서" fallback 이 영구 무효
정정: 같은 SP 가 L932 에서 GTT 대표행으로 이미 확보한 **파싱값 `v_division_id`** 로 교체.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0049_SPFIX_20260820"
src = open(BASE + r"\PKG_DMF0049_BODY_LIVE.sql", encoding="utf-8").read().splitlines()

# 대상 라인 (1-based) — 전제 assert 로 오선택 차단
TARGETS = {
    1030: "WHERE DIVISION_ID = p_division_id;",
    1058: "CASE WHEN p_division_id = '40'",
    1063: "CASE WHEN p_division_id = '40'",
}
for ln, frag in TARGETS.items():
    assert frag in src[ln - 1], f"L{ln} 전제 불일치: {src[ln-1][:120]!r}"

src[1029] = src[1029].replace(
    "WHERE DIVISION_ID = p_division_id;",
    "WHERE DIVISION_ID = v_division_id;  --[E20260820-DIVIDSCALAR] p_division_id 는 '^' 벌크 원문 "
    "→ 2행 이상 payload 에서 항상 0행(부가정보 NULL 덮어쓰기). 파싱 대표값 사용",
)
for i in (1057, 1062):
    src[i] = src[i].replace(
        "CASE WHEN p_division_id = '40'",
        "CASE WHEN v_division_id = '40'  /*[E20260820-DIVIDSCALAR]*/",
    )

body = "\n".join(src)
assert body.count("E20260820-DIVIDSCALAR") == 3
assert not re.search(r"WHERE DIVISION_ID = p_division_id;", body)
assert "p_division_id = '40'" not in body
open(BASE + r"\PKG_DMF0049_BODY_PATCHED.sql", "w", encoding="utf-8").write(body + "\n")
print("[built] PKG_DMF0049_BODY_PATCHED.sql")

stmt = body.strip()
# ALL_SOURCE 덤프는 `PACKAGE BODY "..." IS` 로 시작한다(CREATE OR REPLACE 없음)
if not re.search(r"CREATE OR REPLACE\s+(EDITIONABLE\s+)?PACKAGE BODY", stmt[:500].upper()):
    assert stmt.upper().startswith("PACKAGE BODY"), stmt[:120]
    stmt = "CREATE OR REPLACE " + stmt

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 30")
cur.execute(stmt)
print("[apply] CREATE OR REPLACE PACKAGE BODY PKG_DMF0049")

# 룰 #136 — 대상 객체 실측
cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0049'")
sts = cur.fetchall()
print("[status]", sts)
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049'")
errs = cur.fetchone()[0]
print(f"[errors] {errs}건")
if errs:
    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
                   AND NAME='PKG_DMF0049' ORDER BY SEQUENCE FETCH FIRST 8 ROWS ONLY""")
    for r in cur.fetchall():
        print("  ⛔", r)
    sys.exit(1)
assert all(s == "VALID" for _, s in sts), "INVALID"
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049'
               AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260820-DIVIDSCALAR%'""")
print(f"[verify] 마커 라인 {cur.fetchone()[0]} (기대 3)")
con.close()
print("[OK] 적용 완료")
