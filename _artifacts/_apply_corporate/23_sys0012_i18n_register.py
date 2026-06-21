"""SYS0012 신규 LBL 13 + MSG 6 = 19 키 × 3 lang = 57 row 등록 — 사내 Oracle 적용.

목적:
  SYS0012 (Auth Approval) 화면의 i18n 다국어화 — 한글 하드코딩 19건 + 빈 키 1건 + AS-IS MSG00181
  → 13 LBL + 6 MSG × KO/EN/CN 3 lang 신규 등록.

배경 (사용자 요구 2026-06-20, work_report §1.2 V02/V04/V05 + §9 Reason 검증):
  - AuthApproval.tsx alert/toast 한글 하드코딩 6 (MSG)
  - AuthRejectPopup.tsx header/저장/닫기 하드코딩 + 빈 키 `t('', '_Reason')` (LBL)
  - AuthApprovalForm.tsx User ID/Period/Status/STATUS_OPTIONS 영문 하드코딩 (LBL)
  - SYS0011 LBL620~622 충돌 회피 패턴 동일 (max LBL622 → 623 부터)
  - max MSG618 → 619 부터
  - MSG00181 AS-IS legacy (SCM0002_RejectReasonPopup.GetReason — Reject Reason 입력 검증)

대상 (19 키 × 3 lang = 57 row):
  LBL00623 Approve / Reject / Reason / Save / Close / Reject Reason
       /29 User ID / Period / Status / All / Request / Approved / Rejected (13)
  MSG00619 승인할 항목 선택 / 반려할 항목 선택 / 승인대기중만 선택 / 승인 완료 / 반려 완료 (5)
  MSG00181 Reject Reason을 입력하세요 (AS-IS legacy 1)

룰 cross-check:
  - 룰 #22 i18n-ko-en-alignment: KO=EN 동일 (MSG 한글은 KO 만, EN 영문)
  - 룰 #63 LBL 5자리
  - 메모리 feedback_i18n_ko_en_alignment: KO=EN 동일 / CN 별도

POST-AUDIT 검증:
  - LBL00623~635 × KO/EN/CN = 39 row
  - MSG00619~623 × KO/EN/CN = 15 row
  - MSG00181 × KO/EN/CN = 3 row
  합계 57 row

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

# LBL 13 키 × KO/EN/CN
LBL_ROWS = [
    ("LBL00623", "KO", "Approve"),       ("LBL00623", "EN", "Approve"),       ("LBL00623", "CN", "批准"),
    ("LBL00624", "KO", "Reject"),        ("LBL00624", "EN", "Reject"),        ("LBL00624", "CN", "拒绝"),
    ("LBL00625", "KO", "Reason"),        ("LBL00625", "EN", "Reason"),        ("LBL00625", "CN", "原因"),
    ("LBL00626", "KO", "Save"),          ("LBL00626", "EN", "Save"),          ("LBL00626", "CN", "保存"),
    ("LBL00627", "KO", "Close"),         ("LBL00627", "EN", "Close"),         ("LBL00627", "CN", "关闭"),
    ("LBL00628", "KO", "Reject Reason"), ("LBL00628", "EN", "Reject Reason"), ("LBL00628", "CN", "拒绝原因"),
    ("LBL00629", "KO", "User ID"),       ("LBL00629", "EN", "User ID"),       ("LBL00629", "CN", "用户ID"),
    ("LBL00630", "KO", "Period"),        ("LBL00630", "EN", "Period"),        ("LBL00630", "CN", "期间"),
    ("LBL00631", "KO", "Status"),        ("LBL00631", "EN", "Status"),        ("LBL00631", "CN", "状态"),
    ("LBL00632", "KO", "All"),           ("LBL00632", "EN", "All"),           ("LBL00632", "CN", "全部"),
    ("LBL00633", "KO", "Request"),       ("LBL00633", "EN", "Request"),       ("LBL00633", "CN", "申请中"),
    ("LBL00634", "KO", "Approved"),      ("LBL00634", "EN", "Approved"),      ("LBL00634", "CN", "已批准"),
    ("LBL00635", "KO", "Rejected"),      ("LBL00635", "EN", "Rejected"),      ("LBL00635", "CN", "已拒绝"),
]

# MSG 6 키 × KO/EN/CN (KO 는 한글, EN 영문, CN 중문)
# MSG00181 = AS-IS SCM0002_RejectReasonPopup.GetReason() legacy key — Reject Reason 입력 검증
MSG_ROWS = [
    ("MSG00619", "KO", "승인할 항목을 선택해 주십시오."),
    ("MSG00619", "EN", "Please select items to approve."),
    ("MSG00619", "CN", "请选择要批准的项目。"),
    ("MSG00620", "KO", "반려할 항목을 선택해 주십시오."),
    ("MSG00620", "EN", "Please select items to reject."),
    ("MSG00620", "CN", "请选择要拒绝的项目。"),
    ("MSG00621", "KO", "승인대기중인 항목만 선택 해 주십시오."),
    ("MSG00621", "EN", "Only pending items can be selected."),
    ("MSG00621", "CN", "只能选择待批准的项目。"),
    ("MSG00622", "KO", "승인 완료"),
    ("MSG00622", "EN", "Approve completed."),
    ("MSG00622", "CN", "批准完成。"),
    ("MSG00623", "KO", "반려 완료"),
    ("MSG00623", "EN", "Reject completed."),
    ("MSG00623", "CN", "拒绝完成。"),
    # AS-IS legacy key (SCM0002_RejectReasonPopup.GetReason MSG00181)
    ("MSG00181", "KO", "Reject Reason을 입력하세요."),
    ("MSG00181", "EN", "Please enter the Reject Reason."),
    ("MSG00181", "CN", "请输入拒绝原因。"),
]

ALL_ROWS = LBL_ROWS + MSG_ROWS  # 54 row

# 충돌 점검 (기존 등록 있는지)
print("\n[ PRE-AUDIT ] LBL00623~635 + MSG00619~623 기존 등록 점검:")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'LBL00623' AND 'LBL00635' "
    "   OR MSG_ID BETWEEN 'MSG00619' AND 'MSG00623' "
    "ORDER BY MSG_ID, LANG_CD"
)
pre = cur.fetchall()
if pre:
    print(f"  ⚠ 기존 등록 {len(pre)} row — 충돌 가능 (skip 처리):")
    for m, l, n in pre:
        print(f"    {m} / {l} / {n}")
else:
    print("  (없음 — 신규 등록 안전)")

# MERGE
print(f"\n[ MERGE ] {len(ALL_ROWS)} row (WHEN NOT MATCHED INSERT):")
merge_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MSG_M tgt
USING (SELECT :msg_id AS MSG_ID, :lang_cd AS LANG_CD, :msg_nm AS MSG_NM FROM DUAL) src
   ON (tgt.MSG_ID = src.MSG_ID AND tgt.LANG_CD = src.LANG_CD)
WHEN NOT MATCHED THEN
  INSERT (MSG_ID, LANG_CD, MSG_NM, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.MSG_ID, src.LANG_CD, src.MSG_NM, 'admin', SYSDATE, 'admin', SYSDATE)
"""
inserted = 0
skipped = 0
for msg_id, lang_cd, msg_nm in ALL_ROWS:
    cur.execute(merge_sql, {"msg_id": msg_id, "lang_cd": lang_cd, "msg_nm": msg_nm})
    if cur.rowcount > 0:
        inserted += 1
    else:
        skipped += 1
conn.commit()
print(f"  COMMIT done — inserted {inserted} / skipped {skipped} / total {len(ALL_ROWS)}")

# POST-AUDIT
print("\n[ POST-AUDIT ] LBL00623~635 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'LBL00623' AND 'LBL00635' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
for lang, cnt in cur.fetchall():
    print(f"  LBL {lang}: {cnt} row (기대 13)")

print("\n[ POST-AUDIT ] MSG00619~623 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'MSG00619' AND 'MSG00623' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
for lang, cnt in cur.fetchall():
    print(f"  MSG {lang}: {cnt} row (기대 5)")

print("\n[ POST-AUDIT ] MSG00181 (AS-IS legacy) 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID = 'MSG00181' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
for lang, cnt in cur.fetchall():
    print(f"  MSG00181 {lang}: {cnt} row (기대 1)")

# 검증
print("\n[ VERIFICATION ]")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE (MSG_ID BETWEEN 'LBL00623' AND 'LBL00635') "
    "   OR (MSG_ID BETWEEN 'MSG00619' AND 'MSG00623') "
    "   OR (MSG_ID = 'MSG00181')"
)
got = cur.fetchone()[0]
mark = "✓" if got == 57 else "✗"
print(f"  {mark} 19 key × 3 lang = 57 row 보장 → {got}")

conn.close()
print(f"\n[ done ] SYS0012 i18n 등록 완료 ({inserted} inserted, {skipped} skipped).")
if got != 57:
    sys.exit(1)
