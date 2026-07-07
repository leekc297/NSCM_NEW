"""SYS0011 모듈 타이틀 LBL 3 키 × 3 lang = 12 row 등록 — 사내 Oracle 적용.

목적:
  SYS0011(Auth Request) 모듈 타이틀이 잘못된 LBL 코드로 표시되던 문제 교정.
  - 기존 LBL00601/602/604 는 다른 화면에서 By Year / Discard / Contribution Version 사용 중
    → SYS0011 의도(Authority / Division / My Authority List)와 충돌(화면에 엉뚱한 라벨 표시).
  - User Info 는 기존 정상 코드 LBL00658 재사용(권위 원천 SCM_ADM_MSG_M 최대 코드, 변경 없음).
  - 신규 코드는 DB 최대(658) + FE locales stray(659~670) 모두 회피 → LBL00671 부터 배정.

배경 (사용자 요구 2026-06-28):
  - 사용자: "명칭은 LBL 기준 동일 명칭 있으면 재사용, 없으면 신규 코드 생성해서 추가"
  - 사용자: "LBL 코드가 꼬인거 같아요.. LBL00658 이 마지막이니 이후 코드 신규 추출해서 적용"
  - 조사: 사내 SCM_ADM_MSG_M 최대 LBL = LBL00658 / FE locales 는 659~670 stray 점유(DB 미등록)

대상 (12 row):
  - LBL00671 / KO: Authority         / EN: Authority         / CN: 权限
  - LBL00672 / KO: Division          / EN: Division          / CN: 部门
  - LBL00673 / KO: My Authority List / EN: My Authority List / CN: 我的权限列表
  - LBL00674 / KO: No                / EN: No                / CN: 序号  (Division/My Authority List No 컬럼 헤더)

룰 cross-check:
  - 룰 #22 i18n-ko-en-alignment: KO=EN 동일 ✓ / CN 별도
  - 룰 #63 LBL00xxx 5자리 표준 ✓
  - User Info = LBL00658 재사용(신규 아님)

멱등성: MERGE WHEN NOT MATCHED (재실행 안전).
실행: NSCM_ORA_USER/PASS/DSN 환경변수 설정 후 python 22_sys0011_module_lbl_register.py
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

LBL_ROWS = [
    ("LBL00671", "KO", "Authority"),
    ("LBL00671", "EN", "Authority"),
    ("LBL00671", "CN", "权限"),
    ("LBL00672", "KO", "Division"),
    ("LBL00672", "EN", "Division"),
    ("LBL00672", "CN", "部门"),
    ("LBL00673", "KO", "My Authority List"),
    ("LBL00673", "EN", "My Authority List"),
    ("LBL00673", "CN", "我的权限列表"),
    ("LBL00674", "KO", "No"),
    ("LBL00674", "EN", "No"),
    ("LBL00674", "CN", "序号"),
]

# PRE-AUDIT — 신규 코드 충돌 점검 + DB 최대 LBL 확인
print("\n[ PRE-AUDIT ] LBL00671~674 기존 등록 점검(충돌 시 사용자 확인):")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID IN ('LBL00671','LBL00672','LBL00673','LBL00674') ORDER BY MSG_ID, LANG_CD"
)
pre = cur.fetchall()
print("  (없음 — 신규 등록 안전)" if not pre else "  ⚠ 기존 등록 존재:")
for m, l, n in pre:
    print(f"    {m} / {l} / {n}")

cur.execute("SELECT MAX(MSG_ID) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID LIKE 'LBL%'")
print(f"  현재 DB 최대 LBL = {cur.fetchone()[0]} (신규는 그 이후 비충돌 코드)")

# MERGE
print("\n[ MERGE ] LBL00671~674 × 3 lang = 12 row (WHEN NOT MATCHED INSERT):")
merge_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MSG_M tgt
USING (SELECT :msg_id AS MSG_ID, :lang_cd AS LANG_CD, :msg_nm AS MSG_NM FROM DUAL) src
   ON (tgt.MSG_ID = src.MSG_ID AND tgt.LANG_CD = src.LANG_CD)
WHEN NOT MATCHED THEN
  INSERT (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.MSG_ID, src.LANG_CD, 'LBL', src.MSG_NM, 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
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
print(f"  COMMIT done — {inserted} inserted, {len(LBL_ROWS) - inserted} skipped")

# POST-AUDIT
print("\n[ POST-AUDIT ] LBL00671~674 분포:")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID IN ('LBL00671','LBL00672','LBL00673','LBL00674') ORDER BY MSG_ID, LANG_CD"
)
post = cur.fetchall()
for m, l, n in post:
    print(f"  {m} / {l} / {n}")

mark = "✓" if len(post) == 12 else "✗"
print(f"\n[ VERIFICATION ] {mark} LBL00671~674 × KO/EN/CN = 12 row → 실제 {len(post)} row")

conn.close()
print(f"\n[ done ] SYS0011 모듈 LBL 등록 완료 ({inserted} row inserted).")
if len(post) != 12:
    sys.exit(1)
