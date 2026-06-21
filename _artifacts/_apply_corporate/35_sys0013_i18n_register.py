"""SYS0013 (Dynamic Query) 신규 LBL 7 + MSG 3 = 10 키 × 3 lang = 30 row 등록 — 사내 Oracle 적용.

목적:
  SYS0013 audit V01-V06 i18n fix — 한글 alert/toast 3건 + TabItem 영문 4건 + customButtons 'Execute' 1건 + Form 라벨 2건.
  신규 LBL00645~651 (7) + MSG00628~630 (3) × KO/EN/CN.
  MSG00002 재사용 (저장 완료 — SYS0015 등록 완료).

배경 (사용자 요구 2026-06-21):
  V01: DynamicQuery.tsx L119 'Query 를 선택하세요' → MSG00630 신규
  V02a: DynamicQuery.tsx L125 '저장 완료' → MSG00002 재사용
  V02b: DynamicQuery.tsx L138 '실행 완료' → MSG00629 신규
  V01b: DynamicQuery.tsx L132 '실행할 Query 를 선택하세요' → MSG00628 신규
  V03: DynamicQuery.tsx L188-197 TabItem labels (Result/Columns/Parameters/History) → LBL00645~648 신규
  V04: DynamicQuery.tsx L156 customButtons 'Execute' → LBL00649 신규
  V06a: DynamicQueryForm.tsx L25 searchButtonLabel 'Search' → LBL00112 재사용
  V06b: DynamicQueryForm.tsx L32 'Query Name' → LBL00650 신규
  V06c: DynamicQueryForm.tsx L46 'Category' → LBL00651 신규

룰 cross-check:
  - 룰 #22 i18n KO=EN=CN (MSG 는 lang 별 / LBL 은 KO=EN 동일)
  - 룰 #63 LBL 5자리
  - 메모리 feedback_ddl_grep_before_sql: MSG_TP_CD/USE_YN NOT NULL (SYS0014 사고 후 정합)

POST-AUDIT 검증: 30 row.
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
    # LBL00645 Result
    ("LBL00645", "KO", "Result"),
    ("LBL00645", "EN", "Result"),
    ("LBL00645", "CN", "结果"),
    # LBL00646 Columns
    ("LBL00646", "KO", "Columns"),
    ("LBL00646", "EN", "Columns"),
    ("LBL00646", "CN", "列"),
    # LBL00647 Parameters
    ("LBL00647", "KO", "Parameters"),
    ("LBL00647", "EN", "Parameters"),
    ("LBL00647", "CN", "参数"),
    # LBL00648 History
    ("LBL00648", "KO", "History"),
    ("LBL00648", "EN", "History"),
    ("LBL00648", "CN", "历史"),
    # LBL00649 Execute
    ("LBL00649", "KO", "Execute"),
    ("LBL00649", "EN", "Execute"),
    ("LBL00649", "CN", "执行"),
    # LBL00650 Query Name
    ("LBL00650", "KO", "Query Name"),
    ("LBL00650", "EN", "Query Name"),
    ("LBL00650", "CN", "查询名称"),
    # LBL00651 Category
    ("LBL00651", "KO", "Category"),
    ("LBL00651", "EN", "Category"),
    ("LBL00651", "CN", "类别"),
    # MSG00628 select Query to execute
    ("MSG00628", "KO", "실행할 Query 를 선택하세요."),
    ("MSG00628", "EN", "Please select a Query to execute."),
    ("MSG00628", "CN", "请选择要执行的查询。"),
    # MSG00629 execute completed
    ("MSG00629", "KO", "실행 완료"),
    ("MSG00629", "EN", "Execute completed."),
    ("MSG00629", "CN", "执行完成。"),
    # MSG00630 select Query
    ("MSG00630", "KO", "Query 를 선택하세요."),
    ("MSG00630", "EN", "Please select a Query."),
    ("MSG00630", "CN", "请选择查询。"),
]

# PRE-AUDIT
print("\n[ PRE-AUDIT ] LBL00645~651 + MSG00628~630 기존 등록 점검:")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'LBL00645' AND 'LBL00651' "
    "   OR MSG_ID BETWEEN 'MSG00628' AND 'MSG00630' "
    "ORDER BY MSG_ID, LANG_CD"
)
pre = cur.fetchall()
if pre:
    print(f"  ⚠ 기존 등록 {len(pre)} row — skip 처리:")
    for m, l, n in pre:
        print(f"    {m} / {l} / {n}")
else:
    print("  (없음 — 신규 등록 안전)")

# MERGE — DDL NOT NULL 정합 (MSG_TP_CD prefix 자동, USE_YN='Y')
merge_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MSG_M tgt
USING (SELECT :msg_id AS MSG_ID, :lang_cd AS LANG_CD, :msg_nm AS MSG_NM, :tp_cd AS MSG_TP_CD FROM DUAL) src
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
    tp_cd = msg_id[:3]  # LBL or MSG
    cur.execute(merge_sql, {"msg_id": msg_id, "lang_cd": lang_cd, "msg_nm": msg_nm, "tp_cd": tp_cd})
    if cur.rowcount > 0:
        inserted += 1
    else:
        skipped += 1
conn.commit()
print(f"\n[ MERGE ] inserted {inserted} / skipped {skipped} / total {len(ALL_ROWS)}")

# POST-AUDIT
print("\n[ POST-AUDIT ] LBL00645~651 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'LBL00645' AND 'LBL00651' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
for lang, cnt in cur.fetchall():
    print(f"  LBL {lang}: {cnt} row (기대 7)")

print("\n[ POST-AUDIT ] MSG00628~630 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID BETWEEN 'MSG00628' AND 'MSG00630' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
for lang, cnt in cur.fetchall():
    print(f"  MSG {lang}: {cnt} row (기대 3)")

# 검증
print("\n[ VERIFICATION ]")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE (MSG_ID BETWEEN 'LBL00645' AND 'LBL00651') "
    "   OR (MSG_ID BETWEEN 'MSG00628' AND 'MSG00630')"
)
got = cur.fetchone()[0]
mark = "✓" if got == 30 else "✗"
print(f"  {mark} 10 key × 3 lang = 30 row 보장 → {got}")

conn.close()
print(f"\n[ done ] SYS0013 i18n 등록 완료 ({inserted} inserted, {skipped} skipped).")
if got != 30:
    sys.exit(1)
