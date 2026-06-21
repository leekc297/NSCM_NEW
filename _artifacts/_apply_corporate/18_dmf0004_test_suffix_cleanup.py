"""DMF0004 명확한 TEST suffix obsolete SHEET_COLUMNS cleanup.

목적:
  명확한 테스트/디버그 데이터 (SHEET_NAME LIKE '%_TEST') 삭제.
  DMF0004 / salesSite_TEST : 2 row

배경:
  사용자 요구 (2026-06-20) — TO-BE 마이그레이션 9 화면 SHEET_COLUMNS 일괄 점검 결과:
  - DMF0004 / salesSite_TEST 2 row : 'TEST' suffix = 명확한 테스트/디버그 데이터, FE 매칭 0.
  - division 분기 변형 (_40/_81/_82) 은 BE 의도된 분기 가능성 → 보수적 보존 (별도 점검).

판정 기준 (anti-simplification):
  - 명확히 obsolete (TEST suffix) → 즉시 cleanup
  - 의심 (division variant) → 별도 사용자 확인 후 진행

멱등성: DELETE 자체 멱등.
"""
import os, sys, time
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

DELETE_TARGETS = [
    ("DMF0004", "salesSite_TEST"),  # 명확한 테스트 suffix
]

# PRE-AUDIT
print("\n[ PRE-AUDIT ] 삭제 대상 인벤토리:")
for prog, sheet in DELETE_TARGETS:
    cur.execute(
        "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
        "WHERE PROGRAM_ID = :p AND SHEET_NAME = :s",
        {"p": prog, "s": sheet},
    )
    cnt = cur.fetchone()[0]
    print(f"  {prog} / {sheet}: {cnt} row")

# DELETE
print("\n[ DELETE ]")
total_deleted = 0
for prog, sheet in DELETE_TARGETS:
    t0 = time.time()
    cur.execute(
        "DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
        "WHERE PROGRAM_ID = :p AND SHEET_NAME = :s",
        {"p": prog, "s": sheet},
    )
    deleted = cur.rowcount
    elapsed = time.time() - t0
    total_deleted += deleted
    print(f"  {prog} / {sheet}: {deleted} row deleted ({elapsed:.2f}s)")
conn.commit()
print(f"  COMMIT done — 총 {total_deleted} row")

# POST-AUDIT
print("\n[ POST-AUDIT ] DMF0004 SHEET_NAME 인벤토리:")
cur.execute(
    "SELECT SHEET_NAME, COUNT(*) AS C FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
    "WHERE PROGRAM_ID = 'DMF0004' GROUP BY SHEET_NAME ORDER BY SHEET_NAME"
)
for sheet, cnt in cur.fetchall():
    print(f"  {sheet}: {cnt} row")

conn.close()
print(f"\n[ done ] TEST suffix cleanup 완료 (총 {total_deleted} row).")
