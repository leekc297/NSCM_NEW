"""SYS0011 신규 LBL 3 키 × 3 lang = 9 row 등록 — 사내 Oracle 적용.

목적:
  SYS0011 화면 버튼 명칭 충돌 회피 — 기존 LBL00605/606/607 이 다른 화면에서
  Column Setting / Version / Biz Type 으로 사용 중 → SYS0011 의 Request/Add/Delete
  의도 명칭과 충돌. 신규 LBL00620/621/622 할당 + 3 lang 등록.

배경 (사용자 요구 2026-06-20):
  - 사용자: "명칭이 맞지 않습니다... 중간 버턴 = ADD, DELETE / 상단 버튼 = Request"
  - 사용자: "기존에 명칭과 충돌되면 신규 ID 추가"
  - locales 점검 결과: LBL00605/606/607 이미 다른 화면 사용 (3 충돌)
  - max LBL 번호 = LBL00619 → 다음 빈 번호 LBL00620 부터 3 키 신규

대상 (9 row):
  - LBL00620 / KO: Request   / EN: Request / CN: 申请
  - LBL00621 / KO: Add       / EN: Add     / CN: 添加
  - LBL00622 / KO: Delete    / EN: Delete  / CN: 删除

룰 cross-check:
  - 룰 #22 i18n-ko-en-alignment: KO=EN 동일 ✓
  - 룰 #63 LBL00xxx 5자리 표준 ✓
  - 메모리 feedback_i18n_ko_en_alignment: KO=EN 동일 / CN 별도

POST-AUDIT 검증:
  - LBL00620~622 × KO/EN/CN = 9 row

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

# 등록 대상 9 row (MSG_ID, LANG_CD, MSG_NM)
LBL_ROWS = [
    ("LBL00620", "KO", "Request"),
    ("LBL00620", "EN", "Request"),
    ("LBL00620", "CN", "申请"),
    ("LBL00621", "KO", "Add"),
    ("LBL00621", "EN", "Add"),
    ("LBL00621", "CN", "添加"),
    ("LBL00622", "KO", "Delete"),
    ("LBL00622", "EN", "Delete"),
    ("LBL00622", "CN", "删除"),
]

# PRE-AUDIT — 충돌 확인 (LBL00620~622 가 이미 다른 의미로 사용 중인지)
print("\n[ PRE-AUDIT ] LBL00620~622 충돌 점검 (기존 등록 텍스트):")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID IN ('LBL00620','LBL00621','LBL00622') ORDER BY MSG_ID, LANG_CD"
)
pre = cur.fetchall()
if pre:
    print(f"  ⚠ 기존 등록 {len(pre)} row — 사용자 확인 필요:")
    for m, l, n in pre:
        print(f"    {m} / {l} / {n}")
else:
    print("  (없음 — 신규 등록 안전)")

# 충돌하는 LBL00605/606/607 의 기존 등록 (참고용 인용)
print("\n[ PRE-AUDIT ] LBL00605/606/607 기존 등록 (충돌 원인 — 참고):")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID IN ('LBL00605','LBL00606','LBL00607') ORDER BY MSG_ID, LANG_CD"
)
for m, l, n in cur.fetchall():
    print(f"  {m} / {l} / {n}")

# MERGE
print("\n[ MERGE ] LBL00620~622 × 3 lang = 9 row (WHEN NOT MATCHED INSERT):")
merge_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MSG_M tgt
USING (SELECT :msg_id AS MSG_ID, :lang_cd AS LANG_CD, :msg_nm AS MSG_NM FROM DUAL) src
   ON (tgt.MSG_ID = src.MSG_ID AND tgt.LANG_CD = src.LANG_CD)
WHEN NOT MATCHED THEN
  INSERT (MSG_ID, LANG_CD, MSG_NM, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.MSG_ID, src.LANG_CD, src.MSG_NM, 'admin', SYSDATE, 'admin', SYSDATE)
"""
inserted = 0
for msg_id, lang_cd, msg_nm in LBL_ROWS:
    cur.execute(merge_sql, {"msg_id": msg_id, "lang_cd": lang_cd, "msg_nm": msg_nm})
    if cur.rowcount > 0:
        inserted += 1
        print(f"  ✓ {msg_id} / {lang_cd} / {msg_nm}")
    else:
        print(f"  - {msg_id} / {lang_cd} / (이미 존재 — skip)")
conn.commit()
print(f"  COMMIT done — {inserted} row inserted, {len(LBL_ROWS) - inserted} skipped")

# POST-AUDIT
print("\n[ POST-AUDIT ] LBL00620~622 분포 + 텍스트:")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID IN ('LBL00620','LBL00621','LBL00622') ORDER BY MSG_ID, LANG_CD"
)
post = cur.fetchall()
for m, l, n in post:
    print(f"  {m} / {l} / {n}")

# 검증
print("\n[ VERIFICATION ]")
mark = "✓" if len(post) == 9 else "✗"
print(f"  {mark} LBL00620~622 × KO/EN/CN = 9 row → 실제 {len(post)} row")

conn.close()
print(f"\n[ done ] SYS0011 신규 버튼 LBL 등록 완료 ({inserted} row inserted).")
if len(post) != 9:
    print("⚠ 검증 불일치 — 사용자 확인 필요")
    sys.exit(1)
