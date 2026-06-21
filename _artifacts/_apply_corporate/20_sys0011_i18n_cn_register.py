"""SYS0011 (Auth Request) i18n CN locale 등록 — 사내 Oracle 적용.

목적:
  KO/EN 14 row (7 MSG_ID × 2 lang) 등록 완료 / CN locale 누락 (plan §1.2 V04).
  CN 8 row INSERT (MERGE WHEN NOT MATCHED, 멱등성).

배경 (사용자 요구 2026-06-20, plan §1.2 V04):
  - 메모리 `feedback_i18n_ko_en_alignment` 의 "CN 미적용" 은 KO≠CN 동일성 면제 (CN 번역 자유)
  - CN 등록 자체는 의무 (룰 #22 KO=EN=CN 정합 — 3 lang row 모두 존재)

대상 (8 row):
  - MNU_SYS0011 (메뉴명)
  - MSG_API_SYS0011_MAIN_RETRIEVE
  - MSG_API_SYS0011_DIVISION_RETRIEVE
  - MSG_API_SYS0011_MYAUTH_RETRIEVE
  - MSG_API_SYS0011_MYAUTH_ADD
  - MSG_API_SYS0011_MYAUTH_REQUEST
  - MSG_API_SYS0011_MYAUTH_DELETE
  - MSG_API_SYS0011_USERINFO_RETRIEVE

CN 번역: Auth Request → 权限申请 (사용자 명시 변경 가능 — 본 plan 기본 매핑).

POST-AUDIT 검증:
  - SCM_ADM_MSG_M : LANG_CD='CN' AND (MSG_ID='MNU_SYS0011' OR MSG_ID LIKE 'MSG_API_SYS0011_%') → 8 row

멱등성: MERGE WHEN NOT MATCHED (재실행 안전).
"""
import os, sys, time
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

# CN 등록 대상 8 row (MSG_ID, MSG_NM_CN)
CN_ROWS = [
    ("MNU_SYS0011",                       "权限申请"),
    ("MSG_API_SYS0011_MAIN_RETRIEVE",     "查询权限组信息"),
    ("MSG_API_SYS0011_DIVISION_RETRIEVE", "Division 列表"),
    ("MSG_API_SYS0011_MYAUTH_RETRIEVE",   "My Auth 列表"),
    ("MSG_API_SYS0011_MYAUTH_ADD",        "添加到 My Auth 列表"),
    ("MSG_API_SYS0011_MYAUTH_REQUEST",    "权限申请"),
    ("MSG_API_SYS0011_MYAUTH_DELETE",     "从 My Auth 列表删除"),
    ("MSG_API_SYS0011_USERINFO_RETRIEVE", "查询用户信息"),
]

# 사전 점검: SCM_ADM_MSG_M 컬럼 인벤토리 (DDL grep 의무 — feedback_ddl_grep_before_sql)
print("\n[ SCHEMA ] SCM_ADM_MSG_M 컬럼 + NULLABLE 인벤토리:")
cur.execute(
    "SELECT COLUMN_NAME, DATA_TYPE, NULLABLE, DATA_DEFAULT "
    "FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_ADM_MSG_M' "
    "ORDER BY COLUMN_ID"
)
cols = cur.fetchall()
for c in cols:
    print(f"  {c[0]:20s} {c[1]:15s} NULLABLE={c[2]} DEFAULT={c[3]}")

# PRE-AUDIT — KO/EN/CN 분포
print("\n[ PRE-AUDIT ] SYS0011 i18n LANG_CD 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID='MNU_SYS0011' OR MSG_ID LIKE 'MSG_API_SYS0011\\_%' ESCAPE '\\' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
pre_dist = cur.fetchall()
for lang, cnt in pre_dist:
    print(f"  {lang}: {cnt} row")

print("\n[ PRE-AUDIT ] SYS0011 i18n 등록 row 전체 (KO/EN 참조용 — CN 작성 baseline):")
cur.execute(
    "SELECT MSG_ID, LANG_CD, SUBSTR(MSG_NM, 1, 60) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID='MNU_SYS0011' OR MSG_ID LIKE 'MSG_API_SYS0011\\_%' ESCAPE '\\' "
    "ORDER BY MSG_ID, LANG_CD"
)
for m, l, n in cur.fetchall():
    print(f"  {m:38s} / {l} / {n}")

# MERGE CN row — KO row 의 다른 컬럼 (USE_YN/EFCT_DT/MSG_TP_CD 등) 모두 복사
print("\n[ MERGE ] CN 8 row (WHEN NOT MATCHED INSERT, 멱등성):")
merge_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MSG_M tgt
USING (SELECT :msg_id AS MSG_ID, 'CN' AS LANG_CD, :msg_nm AS MSG_NM FROM DUAL) src
   ON (tgt.MSG_ID = src.MSG_ID AND tgt.LANG_CD = src.LANG_CD)
WHEN NOT MATCHED THEN
  INSERT (MSG_ID, LANG_CD, MSG_NM, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.MSG_ID, src.LANG_CD, src.MSG_NM, 'admin', SYSDATE, 'admin', SYSDATE)
"""
inserted = 0
for msg_id, msg_nm in CN_ROWS:
    cur.execute(merge_sql, {"msg_id": msg_id, "msg_nm": msg_nm})
    if cur.rowcount > 0:
        inserted += 1
        print(f"  ✓ {msg_id:38s} / CN / {msg_nm}")
    else:
        print(f"  - {msg_id:38s} / CN / (이미 존재 — skip)")
conn.commit()
print(f"  COMMIT done — {inserted} row inserted, {len(CN_ROWS) - inserted} skipped")

# POST-AUDIT
print("\n[ POST-AUDIT ] SYS0011 i18n LANG_CD 분포:")
cur.execute(
    "SELECT LANG_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID='MNU_SYS0011' OR MSG_ID LIKE 'MSG_API_SYS0011\\_%' ESCAPE '\\' "
    "GROUP BY LANG_CD ORDER BY LANG_CD"
)
post_dist = cur.fetchall()
post_dict = {l: c for l, c in post_dist}
for lang, cnt in post_dist:
    print(f"  {lang}: {cnt} row")

# 검증 — plan §3 사후
print("\n[ VERIFICATION ] plan §3 사후 검증:")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE LANG_CD='CN' AND (MSG_ID='MNU_SYS0011' OR MSG_ID LIKE 'MSG_API_SYS0011\\_%' ESCAPE '\\')"
)
got_cn = cur.fetchone()[0]
mark = "✓" if got_cn == 8 else "✗"
print(f"  {mark} V04: MSG_M CN row 8 보장 → {got_cn}")

conn.close()
print(f"\n[ done ] SYS0011 i18n CN 등록 완료 (총 {inserted} row inserted).")
if got_cn != 8:
    print("⚠ 검증 불일치 — 사용자 확인 필요")
    sys.exit(1)
