"""SYS0012 (Auth Approval) dead 메타 row cleanup — 사내 Oracle 적용.

목적:
  SYS0011 cleanup (19_) 와 동일 패턴.
  SCM0009 → SYS0012 rename (2026-06-04) 후 잔존한 legacy API_SCM0009_* 참조 cleanup.

배경 (사용자 요구 2026-06-20, work_report §1.2):
  - SCM_ADM_MNU_BTN_MPG_M : MNU_ID='SYS0012' AND API_ID LIKE 'API_SCM0009_%' → 잔존 시 N row
    (FE 호출 0건 — 실제 활성 = API_SYS0012_*)

⚠️ scope 축소:
  - SCM_ADM_API_M cleanup 은 본 PR 에서 제외 (corp-wide 영향 — SYS0012 audit scope 초과).
  - 본 PR 은 SYS0012 BTN_MPG_M 의 dead reference 만 제거.
  - API_M orphan 은 REPORT 만 (별도 corp-wide audit PR 대상으로 인계).

POST-AUDIT 검증:
  - BTN_MPG_M : MNU_ID='SYS0012' AND API_ID LIKE 'API_SCM0009_%' → 0 row
  - BTN_MPG_M : MNU_ID='SYS0012' (잔존) → 실 사용 N row (SEARCH/APPROVE/REJECT)
  - API_M orphan report : 다른 화면 BTN_MPG_M 에서 참조하지 않는 'API_SCM0009_%' API_ID 개수

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
    {
        "label": "SCM_ADM_MNU_BTN_MPG_M (SYS0012 dead API ref)",
        "sql": (
            "DELETE FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M "
            "WHERE MNU_ID = 'SYS0012' AND API_ID LIKE 'API_SCM0009\\_%' ESCAPE '\\'"
        ),
        "count_sql": (
            "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M "
            "WHERE MNU_ID = 'SYS0012' AND API_ID LIKE 'API_SCM0009\\_%' ESCAPE '\\'"
        ),
    },
]

# PRE-AUDIT
print("\n[ PRE-AUDIT ] SCM_ADM_MNU_BTN_MPG_M (MNU_ID='SYS0012') 전체:")
cur.execute(
    "SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0012' ORDER BY SHT_NM, MNU_BTN_CD"
)
pre_btn = cur.fetchall()
dead_btn = 0
live_btn = 0
for sht, btn, api, use in pre_btn:
    is_dead = api and str(api).startswith('API_SCM0009_')
    marker = " ← DELETE" if is_dead else ""
    if is_dead:
        dead_btn += 1
    else:
        live_btn += 1
    print(f"  {sht} / {btn} / {api} / {use}{marker}")
print(f"  요약: dead {dead_btn} / live {live_btn} / total {len(pre_btn)}")

print("\n[ PRE-AUDIT ] SCM_ADM_API_M (API_ID LIKE 'API_SCM0009_%'):")
cur.execute(
    "SELECT API_ID, API_TP_CD, API_URL FROM SCM_MGR.SCM_ADM_API_M "
    "WHERE API_ID LIKE 'API_SCM0009\\_%' ESCAPE '\\' ORDER BY API_ID"
)
pre_api = cur.fetchall()
for api_id, tp, url in pre_api:
    print(f"  {api_id} / {tp} / {url}")
print(f"  요약: dead candidates {len(pre_api)} row")

# DELETE
print("\n[ DELETE ] target 별 개별 실행 (SYS0012 scope 만):")
total_deleted = 0
for tgt in DELETE_TARGETS:
    cur.execute(tgt["count_sql"])
    expected = cur.fetchone()[0]
    t0 = time.time()
    cur.execute(tgt["sql"])
    deleted = cur.rowcount
    elapsed = time.time() - t0
    total_deleted += deleted
    mismatch = "" if deleted == expected else f" ⚠ expected {expected}"
    print(f"  {tgt['label']}: {deleted} row deleted ({elapsed:.2f}s){mismatch}")
conn.commit()
print(f"  COMMIT done — 총 {total_deleted} row")

# POST-AUDIT
print("\n[ POST-AUDIT ] SCM_ADM_MNU_BTN_MPG_M (MNU_ID='SYS0012') 잔존:")
cur.execute(
    "SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0012' ORDER BY SHT_NM, MNU_BTN_CD"
)
post_btn = cur.fetchall()
for sht, btn, api, use in post_btn:
    print(f"  {sht} / {btn} / {api} / {use}")

# API_M orphan REPORT
print("\n[ REPORT ] SCM_ADM_API_M 'API_SCM0009_%' orphan 여부:")
cur.execute(
    "SELECT a.API_ID, "
    "  (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M b WHERE b.API_ID = a.API_ID) AS REF_CNT "
    "FROM SCM_MGR.SCM_ADM_API_M a "
    "WHERE a.API_ID LIKE 'API_SCM0009\\_%' ESCAPE '\\' "
    "ORDER BY a.API_ID"
)
orphans = 0
referenced = 0
for api_id, ref in cur.fetchall():
    if ref == 0:
        orphans += 1
        print(f"  ORPHAN  {api_id} (BTN_MPG_M 참조 0 — 안전한 삭제 후보)")
    else:
        referenced += 1
        print(f"  in-use  {api_id} (BTN_MPG_M 참조 {ref} — 다른 화면 사용 중)")
print(f"  요약: orphan {orphans} / referenced {referenced} (별도 corp-wide PR 에서 orphan 삭제)")

print("\n[ DELTA ]")
print(f"  BTN_MPG_M (SYS0012) : {len(pre_btn)} → {len(post_btn)} ({len(pre_btn)-len(post_btn):+d})")
print(f"  API_M (SCM0009_*)   : {len(pre_api)} (REPORT only — 본 PR DELETE 0)")

# 검증
print("\n[ VERIFICATION ]")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0012' AND API_ID LIKE 'API_SCM0009\\_%' ESCAPE '\\'"
)
remain = cur.fetchone()[0]
mark = "✓" if remain == 0 else "✗"
print(f"  {mark} SYS0012 BTN_MPG_M dead row 0 보장 → {remain}")

conn.close()
print(f"\n[ done ] SYS0012 dead 메타 cleanup 완료 (총 {total_deleted} row).")
if remain != 0:
    sys.exit(1)
