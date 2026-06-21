"""DMF0072 dynamic property management — 사내 Oracle 적용 (admin UI Category Setup 활성화).

목적:
  080_DMF0072_dynamic_property_management.sql 의 BLOCK 1/2/3 (BTN_MPG_M + USER_GR + SHEET_COLUMNS)
  3 INSERT 를 사내 OCGSCMD_P01 에 적용. admin UI Category Setup 의 VISIBLE_FLAG 변경 즉시 반영 활성화.

배경 (2026-06-20):
  - DMF0072 화면 진입 시 BE /admin/menu/DMF0072/column 응답 빈 array 확인.
  - SCM_MST_SHEET_COLUMNS 에 DMF0072/main row 0건 → admin UI Category Setup 변경 무력.
  - FE fallback (MAIN_COLUMNS 23 row) 사용 중 — visible='Y' hardcoded.

적용 후 기대:
  - BTN_MPG_M : SEARCH/INSERT/SAVE/DELETE 4 row
  - USER_GR_MNU_BTN_MPG_M : 자매 그룹 (DMF0004/0005) SEARCH 권한자에게 4 button 권한 복사
  - SHEET_COLUMNS : 23 row INSERT (DMF0072/main)
  - 화면 새로고침 후 BE /admin/menu/DMF0072/column 응답 23 row → store 데이터 사용 → admin 변경 반영

멱등성: 모든 INSERT NOT EXISTS 가드 — 재실행 안전.
"""
import os, sys, pathlib, datetime, time
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

# SQL 파일 (DBeaver 변형 — SQL plus 토큰 없음)
SQL_FILE = pathlib.Path(__file__).resolve().parents[1] / "_deploy_packages" / "DMF0072" / "03_META" / "080_DMF0072_dynamic_property_management_DBeaver.sql"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

# 1. PRE-AUDIT
print("\n[ PRE-AUDIT ] DMF0072 메타 현재 상태:")
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0072' AND SHT_NM='main'")
btn_pre = cur.fetchone()[0]
print(f"  BTN_MPG_M (main): {btn_pre} row")

cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0072' AND SHEET_NAME='main'")
col_pre = cur.fetchone()[0]
print(f"  SHEET_COLUMNS (main): {col_pre} row")

cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0072' AND SHT_NM='main'")
gr_pre = cur.fetchone()[0]
print(f"  USER_GR_MNU_BTN_MPG_M (main): {gr_pre} row")

# 2. SQL 파일 read + 실행 (DBeaver 변형 = 단일 statement 들)
sql_text = SQL_FILE.read_text(encoding="utf-8")
print(f"\n[ SQL file ] {SQL_FILE.name} ({len(sql_text)} chars)")

# 단순 split — DBeaver 변형은 INSERT ... ; COMMIT; 형태. 주석 (--) 제거 후 ';' split.
def split_statements(sql: str):
    # 주석 제거 (간단 — 줄 단위 -- 만)
    cleaned = "\n".join(
        line for line in sql.split("\n") if not line.strip().startswith("--")
    )
    # ';' 로 split, 비어있지 않은 statement 만
    return [s.strip() for s in cleaned.split(";") if s.strip()]

statements = split_statements(sql_text)
print(f"[ parsed ] {len(statements)} statement(s)")

# 3. 실행
print("\n[ EXEC ]")
for i, stmt in enumerate(statements, 1):
    label = stmt[:60].replace("\n", " ")
    t0 = time.time()
    try:
        cur.execute(stmt)
        elapsed = time.time() - t0
        rows = cur.rowcount if cur.rowcount and cur.rowcount > -1 else 0
        print(f"  [{i}/{len(statements)}] {label}... → {rows} row affected ({elapsed:.2f}s)")
    except oracledb.DatabaseError as e:
        print(f"  [{i}/{len(statements)}] FAILED: {e}")
        print(f"     statement: {label}")
        conn.rollback()
        cur.close(); conn.close()
        sys.exit(2)
conn.commit()

# 4. POST-AUDIT
print("\n[ POST-AUDIT ] 적용 후 DMF0072 메타:")
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0072' AND SHT_NM='main'")
btn_post = cur.fetchone()[0]
print(f"  BTN_MPG_M (main): {btn_post} row (delta +{btn_post - btn_pre})")

cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0072' AND SHEET_NAME='main'")
col_post = cur.fetchone()[0]
print(f"  SHEET_COLUMNS (main): {col_post} row (delta +{col_post - col_pre})")

cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0072' AND SHT_NM='main'")
gr_post = cur.fetchone()[0]
print(f"  USER_GR_MNU_BTN_MPG_M (main): {gr_post} row (delta +{gr_post - gr_pre})")

# 5. 검증
print("\n[ VERIFY ] BTN_CD 인벤토리:")
cur.execute("SELECT MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0072' AND SHT_NM='main' ORDER BY MNU_BTN_CD")
for row in cur.fetchall():
    print(f"  {row}")

print("\n[ VERIFY ] SHEET_COLUMNS (visible 분포):")
cur.execute("SELECT VISIBLE_FLAG, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0072' AND SHEET_NAME='main' GROUP BY VISIBLE_FLAG ORDER BY 1")
for row in cur.fetchall():
    print(f"  VISIBLE_FLAG='{row[0]}': {row[1]} row")

conn.close()
print("\n[ done ] DMF0072 dynamic property 적용 완료. 화면 새로고침 후 admin UI Category Setup 동작 검증.")
