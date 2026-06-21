"""SYS0010 신규 LBL 4 + MSG 1 = 5 키 × 3 lang = 15 row 등록 — 사내 Oracle 적용.

목적:
  SYS0010 (Lookup) audit V02 i18n LBL 5 충돌 fix —
  Lookup 의도 텍스트와 locales 등록 텍스트 불일치 (DMF0072/SYS0011 선점).
  신규 LBL 4 (00636~00639) + MSG 1 (00624) 할당 + 사내 SCM_ADM_MSG_M 등록.

배경 (사용자 요구 2026-06-21, work_report §1.1 V02):
  - LBL00618 (코드 'Lookup Type') ↔ locales "Model/Nickname" (DMF0072 선점)
  - LBL00619 (코드 'Lookup Values') ↔ locales "Sales Site" (DMF0072 선점)
  - LBL00620 (코드 'Please select a Lookup Type first.') ↔ locales "Request" (SYS0011 선점, MSG 의미)
  - LBL00621 (코드 'System') ↔ locales "Add" (SYS0011 선점)
  - LBL00622 (코드 'Valid') ↔ locales "Delete" (SYS0011 선점)
  → 신규 LBL00636~00639 + MSG00624 할당. FE 코드 키 교체 + 3 locales + 사내 메타.

대상 (15 row):
  LBL00636 = Lookup Type / 查找类型
  LBL00637 = Lookup Values / 查找值
  LBL00638 = System / 系统
  LBL00639 = Valid / 有效
  MSG00624 = Please select a Lookup Type first. / 请先选择查找类型。

룰 cross-check:
  - 룰 #22 i18n-ko-en-alignment: KO=EN 동일 + CN 별도
  - 룰 #63 LBL 5자리
  - 메모리 feedback_i18n_ko_en_alignment

POST-AUDIT 검증:
  - LBL00636~00639 × KO/EN/CN = 12 row
  - MSG00624 × KO/EN/CN = 3 row
  합계 15 row

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
    # LBL00636 Lookup Type
    ("LBL00636", "KO", "Lookup Type"),
    ("LBL00636", "EN", "Lookup Type"),
    ("LBL00636", "CN", "查找类型"),
    # LBL00637 Lookup Values
    ("LBL00637", "KO", "Lookup Values"),
    ("LBL00637", "EN", "Lookup Values"),
    ("LBL00637", "CN", "查找值"),
    # LBL00638 System
    ("LBL00638", "KO", "System"),
    ("LBL00638", "EN", "System"),
    ("LBL00638", "CN", "系统"),
    # LBL00639 Valid
    ("LBL00639", "KO", "Valid"),
    ("LBL00639", "EN", "Valid"),
    ("LBL00639", "CN", "有效"),
    # MSG00624 select Lookup Type first
    ("MSG00624", "KO", "Please select a Lookup Type first."),
    ("MSG00624", "EN", "Please select a Lookup Type first."),
    ("MSG00624", "CN", "请先选择查找类型。"),
]

# PRE-AUDIT — 충돌 점검
print("\n[ PRE-AUDIT ] LBL00636~00639 + MSG00624 기존 등록 점검:")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'LBL00636' AND 'LBL00639' OR MSG_ID='MSG00624' "
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
print("\n[ POST-AUDIT ] LBL00636~00639 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'LBL00636' AND 'LBL00639' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
for lang, cnt in cur.fetchall():
    print(f"  LBL {lang}: {cnt} row (기대 4)")

print("\n[ POST-AUDIT ] MSG00624 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID = 'MSG00624' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
for lang, cnt in cur.fetchall():
    print(f"  MSG00624 {lang}: {cnt} row (기대 1)")

# 검증
print("\n[ VERIFICATION ]")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE (MSG_ID BETWEEN 'LBL00636' AND 'LBL00639') OR (MSG_ID = 'MSG00624')"
)
got = cur.fetchone()[0]
mark = "✓" if got == 15 else "✗"
print(f"  {mark} 5 key × 3 lang = 15 row 보장 → {got}")

conn.close()
print(f"\n[ done ] SYS0010 i18n 등록 완료 ({inserted} inserted, {skipped} skipped).")
if got != 15:
    sys.exit(1)
