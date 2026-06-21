"""SYS0014 신규 LBL 4 + MSG 3 = 7 키 × 3 lang = 21 row 등록 — 사내 Oracle 적용.

목적:
  SYS0014 (Group User) audit — title/alert 영문/한글 하드코딩 + LBL 충돌 fix.
  신규 LBL00640~643 (Authority/Division/Group User/Customer)
    + MSG00625~627 (Group 선택 / Group&User 선택 / 변경 없음)
  사내 SCM_ADM_MSG_M 등록.

배경 (사용자 요구 2026-06-21):
  - L238 t('LBL00601', 'Authority') ↔ locales "By Year" (충돌)
  - L263 t('LBL00602', 'Division') ↔ locales "Discard" (충돌)
  - L248 title='Group User' / L297 title='Customer' (i18n 누락)
  - L121/133/174 한글 alert 하드코딩 3건 + L180 toast 한글
  → 신규 LBL 4 + MSG 3 할당. FE 키 교체 + 3 locales + 사내 메타.

대상 (21 row):
  LBL00640 Authority / 权限
  LBL00641 Division / 部门
  LBL00642 Group User / 组用户
  LBL00643 Customer / 客户
  MSG00625 Please select a Group first. / 请先选择组。
  MSG00626 Please select a Group and a User first. / 请先选择组和用户。
  MSG00627 There are no changes. / 没有更改内容。

룰 cross-check:
  - 룰 #22 i18n-ko-en-alignment: KO=EN 동일 (MSG 는 KO 한글, EN 영문)
  - 룰 #63 LBL 5자리
  - 메모리 feedback_i18n_ko_en_alignment

멱등성: MERGE WHEN NOT MATCHED (재실행 안전).
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

ALL_ROWS = [
    # LBL00640 Authority
    ("LBL00640", "KO", "Authority"),
    ("LBL00640", "EN", "Authority"),
    ("LBL00640", "CN", "权限"),
    # LBL00641 Division
    ("LBL00641", "KO", "Division"),
    ("LBL00641", "EN", "Division"),
    ("LBL00641", "CN", "部门"),
    # LBL00642 Group User
    ("LBL00642", "KO", "Group User"),
    ("LBL00642", "EN", "Group User"),
    ("LBL00642", "CN", "组用户"),
    # LBL00643 Customer
    ("LBL00643", "KO", "Customer"),
    ("LBL00643", "EN", "Customer"),
    ("LBL00643", "CN", "客户"),
    # MSG00625 Group select
    ("MSG00625", "KO", "먼저 Group 을 선택해 주십시오."),
    ("MSG00625", "EN", "Please select a Group first."),
    ("MSG00625", "CN", "请先选择组。"),
    # MSG00626 Group+User select
    ("MSG00626", "KO", "먼저 Group 과 User 를 선택해 주십시오."),
    ("MSG00626", "EN", "Please select a Group and a User first."),
    ("MSG00626", "CN", "请先选择组和用户。"),
    # MSG00627 No changes
    ("MSG00627", "KO", "변경 사항이 없습니다."),
    ("MSG00627", "EN", "There are no changes."),
    ("MSG00627", "CN", "没有更改内容。"),
]

# PRE-AUDIT
print("\n[ PRE-AUDIT ] LBL00640~00643 + MSG00625~00627 기존 등록 점검:")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'LBL00640' AND 'LBL00643' "
    "   OR MSG_ID BETWEEN 'MSG00625' AND 'MSG00627' "
    "ORDER BY MSG_ID, LANG_CD"
)
pre = cur.fetchall()
if pre:
    print(f"  ⚠ 기존 등록 {len(pre)} row — skip 처리:")
    for m, l, n in pre:
        print(f"    {m} / {l} / {n}")
else:
    print("  (없음 — 신규 등록 안전)")

# MERGE
print(f"\n[ MERGE ] {len(ALL_ROWS)} row:")
# DDL NOT NULL 컬럼 정합 (feedback_ddl_grep_before_sql):
#   MSG_TP_CD NOT NULL → MSG_ID prefix 자동 분기 (LBL/MSG/API)
#   USE_YN    NOT NULL → 'Y' default
merge_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MSG_M tgt
USING (SELECT :msg_id AS MSG_ID, :lang_cd AS LANG_CD, :msg_nm AS MSG_NM,
              :msg_tp_cd AS MSG_TP_CD FROM DUAL) src
   ON (tgt.MSG_ID = src.MSG_ID AND tgt.LANG_CD = src.LANG_CD)
WHEN NOT MATCHED THEN
  INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.MSG_ID, src.LANG_CD, src.MSG_NM, src.MSG_TP_CD, 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
"""
inserted = 0
skipped = 0
for msg_id, lang_cd, msg_nm in ALL_ROWS:
    tp_cd = msg_id[:3]  # 'LBL' / 'MSG' / 'API'
    cur.execute(merge_sql, {"msg_id": msg_id, "lang_cd": lang_cd, "msg_nm": msg_nm, "msg_tp_cd": tp_cd})
    if cur.rowcount > 0:
        inserted += 1
    else:
        skipped += 1
conn.commit()
print(f"  COMMIT done — inserted {inserted} / skipped {skipped} / total {len(ALL_ROWS)}")

# POST-AUDIT
print("\n[ POST-AUDIT ] LBL00640~00643 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'LBL00640' AND 'LBL00643' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
for lang, cnt in cur.fetchall():
    print(f"  LBL {lang}: {cnt} row (기대 4)")

print("\n[ POST-AUDIT ] MSG00625~00627 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'MSG00625' AND 'MSG00627' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
for lang, cnt in cur.fetchall():
    print(f"  MSG {lang}: {cnt} row (기대 3)")

# 검증
print("\n[ VERIFICATION ]")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE (MSG_ID BETWEEN 'LBL00640' AND 'LBL00643') "
    "   OR (MSG_ID BETWEEN 'MSG00625' AND 'MSG00627')"
)
got = cur.fetchone()[0]
mark = "✓" if got == 21 else "✗"
print(f"  {mark} 7 key × 3 lang = 21 row 보장 → {got}")

conn.close()
print(f"\n[ done ] SYS0014 i18n 등록 완료 ({inserted} inserted, {skipped} skipped).")
if got != 21:
    sys.exit(1)
