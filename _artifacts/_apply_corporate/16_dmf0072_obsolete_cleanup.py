"""DMF0072 미사용 메타 cleanup — 사내 Oracle 적용.

목적:
  SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0072' AND SHEET_NAME='NNMasterMapping' 23 row 삭제.
  (구 PascalCase sheet명. FE 는 SHEET_NAME='main' camelCase 만 사용.)

배경 (2026-06-20):
  사용자 요구 — UI Category Setup 에서 관리하는 데이터 중 미사용 row 삭제.

PRE/POST AUDIT 포함 — delta 명시.
멱등성: NOT EXISTS 가드 불필요 (DELETE 는 멱등 — 0 row delete 무영향).
"""
import os, pathlib, sys, time
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

SQL_FILE = pathlib.Path(__file__).resolve().parents[1] / "_deploy_packages" / "DMF0072" / "03_META" / "085_DMF0072_obsolete_sheet_columns_cleanup.sql"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

# PRE-AUDIT
print("\n[ PRE-AUDIT ] DMF0072 SHEET_COLUMNS sheet별 카운트:")
cur.execute(
    "SELECT SHEET_NAME, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
    "WHERE PROGRAM_ID='DMF0072' GROUP BY SHEET_NAME ORDER BY SHEET_NAME"
)
pre = cur.fetchall()
for sheet, cnt in pre:
    print(f"  {sheet}: {cnt} row")

# DELETE
print("\n[ DELETE ] PROGRAM_ID='DMF0072' AND SHEET_NAME='NNMasterMapping' (구 PascalCase legacy):")
t0 = time.time()
cur.execute(
    "DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
    "WHERE PROGRAM_ID='DMF0072' AND SHEET_NAME='NNMasterMapping'"
)
deleted = cur.rowcount
elapsed = time.time() - t0
print(f"  {deleted} row deleted ({elapsed:.2f}s)")
conn.commit()
print("  COMMIT done")

# POST-AUDIT
print("\n[ POST-AUDIT ] DMF0072 SHEET_COLUMNS sheet별 카운트:")
cur.execute(
    "SELECT SHEET_NAME, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
    "WHERE PROGRAM_ID='DMF0072' GROUP BY SHEET_NAME ORDER BY SHEET_NAME"
)
post = cur.fetchall()
for sheet, cnt in post:
    print(f"  {sheet}: {cnt} row")

# DELTA 보고
pre_dict = {s: c for s, c in pre}
post_dict = {s: c for s, c in post}
print("\n[ DELTA ]")
all_sheets = sorted(set(pre_dict.keys()) | set(post_dict.keys()))
for s in all_sheets:
    pre_c = pre_dict.get(s, 0)
    post_c = post_dict.get(s, 0)
    delta = post_c - pre_c
    sign = "+" if delta >= 0 else ""
    state = "DELETED" if post_c == 0 and pre_c > 0 else ("UNCHANGED" if delta == 0 else "CHANGED")
    print(f"  {s}: {pre_c} → {post_c} ({sign}{delta}) [{state}]")

conn.close()
print("\n[ done ] 미사용 SHEET_COLUMNS row 삭제 완료. 화면 새로고침 후 정상 동작 확인.")
