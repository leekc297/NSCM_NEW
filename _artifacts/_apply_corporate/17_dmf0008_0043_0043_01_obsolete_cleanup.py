"""DMF0008/DMF0043/DMF0043_01 미사용 SHEET_COLUMNS row cleanup — 사내 Oracle 적용.

목적:
  DMF0072 cleanup (16_dmf0072_obsolete_cleanup.py) 와 동일 패턴.
  FE SHEETS enum + fetchStaticColumns 사용처 cross-check 후 obsolete PascalCase legacy 삭제.

배경 (사용자 요구 2026-06-20):
  3 화면 (DMF0043, DMF0043_01, DMF0008) 의 UI Category Setup 미사용 데이터 cleanup.

삭제 대상 (FE 매칭 0, 모두 PascalCase legacy):
  - DMF0043 / ContributeMain        : 8 row
  - DMF0043 / ContributeRate        : 5 row
  - DMF0043 / ContributeSalesList   : 9 row
  - DMF0043_01 / VersionPopup       : 5 row
  합계: 27 row

유지 (FE 사용 확인 — anti-simplification cross-check):
  - DMF0008 모든 sheet: summary/repair/salesSite/sspm (FE SHEETS enum 1:1)
  - DMF0043 / main, ratePopup, versionPopup (camelCase — FE/BTN_MPG_M 매칭)
  - DMF0043_01 / ContributeSalesList (store fetchStaticColumns L110 명시 인용)

PRE/POST AUDIT + delta 명시. 멱등성: DELETE 자체 멱등.
"""
import os, pathlib, sys, time
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

# 삭제 대상 (PROGRAM_ID, SHEET_NAME) 명시 — anti-simplification: 추측 X, 명시적 list.
DELETE_TARGETS = [
    ("DMF0043",    "ContributeMain"),
    ("DMF0043",    "ContributeRate"),
    ("DMF0043",    "ContributeSalesList"),
    ("DMF0043_01", "VersionPopup"),
]

# PRE-AUDIT — 3 화면 전체 sheet 인벤토리
print("\n[ PRE-AUDIT ] DMF0008/DMF0043/DMF0043_01 SHEET_COLUMNS 인벤토리:")
cur.execute(
    "SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) AS COL_CNT "
    "FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
    "WHERE PROGRAM_ID IN ('DMF0008','DMF0043','DMF0043_01') "
    "GROUP BY PROGRAM_ID, SHEET_NAME ORDER BY PROGRAM_ID, SHEET_NAME"
)
pre = cur.fetchall()
for prog, sheet, cnt in pre:
    is_target = (prog, sheet) in DELETE_TARGETS
    marker = " ← DELETE" if is_target else ""
    print(f"  {prog} / {sheet}: {cnt} row{marker}")

# DELETE — target 별 개별 실행 (실패 시 어느 target 인지 명확)
print("\n[ DELETE ] target 별 개별 실행:")
total_deleted = 0
for prog, sheet in DELETE_TARGETS:
    t0 = time.time()
    cur.execute(
        "DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
        "WHERE PROGRAM_ID = :prog AND SHEET_NAME = :sheet",
        {"prog": prog, "sheet": sheet},
    )
    deleted = cur.rowcount
    elapsed = time.time() - t0
    total_deleted += deleted
    print(f"  {prog} / {sheet}: {deleted} row deleted ({elapsed:.2f}s)")
conn.commit()
print(f"  COMMIT done — 총 {total_deleted} row")

# POST-AUDIT
print("\n[ POST-AUDIT ] DMF0008/DMF0043/DMF0043_01 SHEET_COLUMNS 인벤토리:")
cur.execute(
    "SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) AS COL_CNT "
    "FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
    "WHERE PROGRAM_ID IN ('DMF0008','DMF0043','DMF0043_01') "
    "GROUP BY PROGRAM_ID, SHEET_NAME ORDER BY PROGRAM_ID, SHEET_NAME"
)
post = cur.fetchall()
for prog, sheet, cnt in post:
    print(f"  {prog} / {sheet}: {cnt} row")

# DELTA 보고
pre_dict = {(p, s): c for p, s, c in pre}
post_dict = {(p, s): c for p, s, c in post}
print("\n[ DELTA ]")
all_keys = sorted(set(pre_dict.keys()) | set(post_dict.keys()))
for key in all_keys:
    pre_c = pre_dict.get(key, 0)
    post_c = post_dict.get(key, 0)
    delta = post_c - pre_c
    sign = "+" if delta >= 0 else ""
    if pre_c > 0 and post_c == 0:
        state = "DELETED"
    elif delta == 0:
        state = "UNCHANGED"
    else:
        state = "CHANGED"
    print(f"  {key[0]} / {key[1]}: {pre_c} → {post_c} ({sign}{delta}) [{state}]")

conn.close()
print(f"\n[ done ] 3 화면 미사용 SHEET_COLUMNS row 삭제 완료 (총 {total_deleted} row).")
