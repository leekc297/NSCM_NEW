"""SYS0014 메뉴 title MNU_SYS0014 × 3 lang = 3 row 등록 — 사내 Oracle 적용.

목적:
  사용자 요구 (2026-06-21): "SYS0014 UI Title 'Group User' 로 변경"
  → 사내 `SCM_ADM_MNU_M`.MNU_DESC 는 이미 'Group User' but
    `SCM_ADM_MSG_M`.MNU_SYS0014 i18n 0 row (미등록) → 화면 표시 i18n fallback 시 이상.
  → MNU_SYS0014 × KO/EN/CN 3 row 신규 등록 (MSG_TP_CD='MNU' 표준).

배경:
  - MNU_SYS0015 = 'Program' (3 lang) 표준 패턴 cross-check 완료
  - MSG_TP_CD='MNU' / USE_YN='Y' (DDL NOT NULL — feedback_ddl_grep_before_sql 정합)

대상 (3 row):
  MNU_SYS0014 KO: Group User
  MNU_SYS0014 EN: Group User
  MNU_SYS0014 CN: 组用户

멱등성: MERGE WHEN NOT MATCHED.
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

ROWS = [
    ("MNU_SYS0014", "KO", "Group User"),
    ("MNU_SYS0014", "EN", "Group User"),
    ("MNU_SYS0014", "CN", "组用户"),
]

# PRE-AUDIT — MNU_M + MSG_M 현재 상태
print("\n[ PRE-AUDIT ] SCM_ADM_MNU_M (SYS0014):")
cur.execute("SELECT MNU_ID, MNU_DESC, MNU_MSG_ID FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='SYS0014'")
for r in cur.fetchall():
    print(f"  {r}")

print("\n[ PRE-AUDIT ] SCM_ADM_MSG_M MNU_SYS0014 분포:")
cur.execute("SELECT LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID='MNU_SYS0014' ORDER BY LANG_CD")
pre = cur.fetchall()
if not pre:
    print("  (없음 — 신규 등록)")
else:
    for r in pre:
        print(f"  {r}")

# MERGE
merge_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MSG_M tgt
USING (SELECT :msg_id AS MSG_ID, :lang_cd AS LANG_CD, :msg_nm AS MSG_NM FROM DUAL) src
   ON (tgt.MSG_ID = src.MSG_ID AND tgt.LANG_CD = src.LANG_CD)
WHEN NOT MATCHED THEN
  INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.MSG_ID, src.LANG_CD, src.MSG_NM, 'MNU', 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
"""
inserted = 0
for msg_id, lang_cd, msg_nm in ROWS:
    cur.execute(merge_sql, {"msg_id": msg_id, "lang_cd": lang_cd, "msg_nm": msg_nm})
    if cur.rowcount > 0:
        inserted += 1
        print(f"  ✓ {msg_id} / {lang_cd} / {msg_nm}")
    else:
        print(f"  - {msg_id} / {lang_cd} (이미 존재 — skip)")
conn.commit()
print(f"\n  COMMIT done — inserted {inserted} / total {len(ROWS)}")

# POST-AUDIT
print("\n[ POST-AUDIT ] MNU_SYS0014 분포:")
cur.execute("SELECT LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID='MNU_SYS0014' ORDER BY LANG_CD")
post = cur.fetchall()
for r in post:
    print(f"  {r}")

mark = "✓" if len(post) == 3 else "✗"
print(f"\n[ VERIFICATION ] {mark} MNU_SYS0014 × 3 lang = 3 row 보장 → {len(post)}")

conn.close()
print(f"\n[ done ] SYS0014 메뉴 title 등록 완료 ({inserted} row).")
if len(post) != 3:
    sys.exit(1)
