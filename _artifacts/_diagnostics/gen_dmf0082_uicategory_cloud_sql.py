#!/usr/bin/env python3
"""DMF0082 UICATEGORY 클라우드 이관 SQL 에미터 (2026-08-07)
사내(OCGSCMD_P01) 실측을 literal 로 덤프 — 클라우드에 백업/원본 테이블 부재 전제.
산출: 03_PROC_M.sql (GET/CURRENT/SAVE 3종 DELETE→INSERT) + 04_META_SHEET_COLUMNS.sql (5키 UPDATE + 신규 17행 INSERT-only)
감사컬럼 = 'admin' (feedback_meta_audit_column_admin_only)."""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
import oracledb

PKG_DIR = pathlib.Path(sys.argv[1])
NEW_COLS = ['PROJECT_CODE','PROJECT_NAME','PROJECT_STATUS','PROJECT_OWNER','PLANT_SITE_ID','BIZ_TYPE',
            'ENERGE','CELL_QUANTITY','CELL_PER_CAR','CELL_PER_MODULE','MODULE_PER_CAR',
            'PROJECT_S_OP_REPORT','TEAM_NAME_KO','AS_YN','ATTR1','VMI_STD_DIO','NEW_FLAG']
KEY5 = ['DIVISION_ID','END_CUSTOMER','SCM_SITE_ID','ITEM_ID','CELL_PROD_SITE_ID']
PROCS = ['PKG_DMF0082.P_DMF0082_GET_MAIN_DATA','PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT',
         'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA']

def lit(v):
    if v is None:
        return 'NULL'
    if isinstance(v, (int, float)):
        s = str(v)
        return s[:-2] if s.endswith('.0') else s
    return "'" + str(v).replace("'", "''") + "'"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ---------- 03_PROC_M.sql ----------
L = ["-- ====================================================================",
     "-- DMF0082 UICATEGORY — SCM_ADM_PROC_M 재구성 (클라우드용, 사내 실측 literal 덤프 2026-08-07)",
     "--   GET/CURRENT = IN 16(+projectCode/owner/senderCode 14~16) + OUT 6(17~22)",
     "--   SAVE_MAIN_DATA = 18행 (2026-08-05 asFromSite IN17 + o_result_cursor 18 — 클라우드 미이관분 포함)",
     "--   DELETE→INSERT (PROC 3종 한정). 감사 = 'admin'. ⚠️ QA·DEV 2곳 동시 적용 의무",
     "-- ====================================================================", ""]
for proc in PROCS:
    cur.execute("SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD", {"p": proc})
    rows = cur.fetchall()
    if not rows:
        sys.exit(f"ERROR: PROC_M 0 rows for {proc}")
    L.append(f"-- {proc} ({len(rows)}행)")
    L.append(f"DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = '{proc}';")
    for r in rows:
        L.append("INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)"
                 f" VALUES ('{proc}', {lit(r[0])}, {lit(r[1])}, {lit(r[2])}, {lit(r[3])}, 'admin', SYSDATE, 'admin', SYSDATE);")
    L.append("")
L += ["COMMIT;", "",
      "-- [검증] 기대: GET 22 / CURRENT 22 / SAVE 18",
      "SELECT PROC_NM, COUNT(*) CNT FROM SCM_MGR.SCM_ADM_PROC_M",
      "WHERE PROC_NM IN ('" + "','".join(PROCS) + "')",
      "GROUP BY PROC_NM ORDER BY 1;"]
(PKG_DIR / "03_PROC_M.sql").write_text("\n".join(L) + "\n", encoding="utf-8", newline="\n")
print("03_PROC_M.sql:", sum(1 for x in L if x.startswith("INSERT")), "inserts")

# ---------- 04_META_SHEET_COLUMNS.sql ----------
cur.execute("SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME='SCM_MST_SHEET_COLUMNS' ORDER BY COLUMN_ID")
all_cols = [r[0] for r in cur.fetchall()]
M = ["-- ====================================================================",
     "-- DMF0082 UICATEGORY — SCM_MST_SHEET_COLUMNS (클라우드용, 사내 실측 literal 덤프 2026-08-07)",
     "--   [1] 필수 키 5컬럼 DIVISION_ID 토큰 확장 (40 단독 → 40+81계열+82) — 멱등 UPDATE",
     "--   [2] DMF0003 파리티 신규 17컬럼 — INSERT-only (NOT EXISTS 멱등, 감사 'admin')",
     "--   ⚠️ 적용 순서: 00_GTT_ALTER → 01/02 PKG → 03_PROC_M → 본 파일 (메타 = 마지막 DB 스위치)",
     "--   ⚠️ QA·DEV 2곳 동시 적용 의무",
     "-- ====================================================================", "",
     "-- [1] 필수 키 5컬럼 토큰 확장",
     "UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS",
     "SET    DIVISION_ID      = '40,81,81_UC,81_HM,81_ST,81_HD,81_HG,82'",
     "     , LAST_UPDATED_BY  = 'admin'",
     "     , LAST_UPDATE_DATE = SYSDATE",
     "WHERE  PROGRAM_ID  = 'DMF0082'",
     "AND    SHEET_NAME  = 'FcstNPrice'",
     "AND    COLUMN_NAME IN ('" + "','".join(KEY5) + "')",
     "AND    DIVISION_ID <> '40,81,81_UC,81_HM,81_ST,81_HD,81_HG,82';", "",
     "-- [2] 신규 17컬럼 (사내 실측 행 literal — DMF0003 원본 변환 복제분)",
     "--     ⭐ MERGE INTO 정본 (hook #98 §9, 2026-08-07 사용자 확정) — DELETE 절대 금지.",
     "--       MATCHED=비PK 전속성 동기(CREATED_* 보존) / NOT MATCHED=INSERT (NOT NULL 전수)"]
audit = {'CREATED_BY': "'admin'", 'CREATION_DATE': 'SYSDATE', 'LAST_UPDATED_BY': "'admin'", 'LAST_UPDATE_DATE': 'SYSDATE'}
PK = ('PROGRAM_ID', 'SHEET_NAME', 'COLUMN_NAME')
CREATE_KEEP = ('CREATED_BY', 'CREATION_DATE')
cur.execute("SELECT " + ", ".join(all_cols) + " FROM SCM_MST_SHEET_COLUMNS"
            " WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'"
            " AND COLUMN_NAME IN ('" + "','".join(NEW_COLS) + "') ORDER BY SORT_ORDER_NO")
rows = cur.fetchall()
if len(rows) != 17:
    sys.exit(f"ERROR: 신규 컬럼 {len(rows)}행 (기대 17)")
for r in rows:
    valmap = {}
    for c, v in zip(all_cols, r):
        valmap[c] = audit.get(c, lit(v))
    name = valmap['COLUMN_NAME']
    upd = [f"T.{c} = {valmap[c]}" for c in all_cols if c not in PK and c not in CREATE_KEEP]
    M.append("MERGE INTO SCM_MGR.SCM_MST_SHEET_COLUMNS T")
    M.append(f"USING (SELECT 'DMF0082' PROGRAM_ID, 'FcstNPrice' SHEET_NAME, {name} COLUMN_NAME FROM DUAL) S")
    M.append("ON (T.PROGRAM_ID = S.PROGRAM_ID AND T.SHEET_NAME = S.SHEET_NAME AND T.COLUMN_NAME = S.COLUMN_NAME)")
    M.append("WHEN MATCHED THEN UPDATE SET")
    M.append("     " + "\n   , ".join(upd))
    M.append(f"WHEN NOT MATCHED THEN INSERT ({', '.join(all_cols)})")
    M.append(f"VALUES ({', '.join(valmap[c] for c in all_cols)});")
    M.append("")
M += ["COMMIT;", "",
      "-- [검증] 기대: TOTAL 61 / D40 49 / D81 42 / D82 41",
      "SELECT COUNT(*) TOTAL,",
      "       SUM(CASE WHEN ','||DIVISION_ID||',' LIKE '%,40,%' THEN 1 ELSE 0 END) D40,",
      "       SUM(CASE WHEN ','||DIVISION_ID||',' LIKE '%,81,%' THEN 1 ELSE 0 END) D81,",
      "       SUM(CASE WHEN ','||DIVISION_ID||',' LIKE '%,82,%' THEN 1 ELSE 0 END) D82",
      "FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS",
      "WHERE  PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice';"]
(PKG_DIR / "04_META_SHEET_COLUMNS.sql").write_text("\n".join(M) + "\n", encoding="utf-8", newline="\n")
print("04_META_SHEET_COLUMNS.sql:", len(rows), "rows (17 expected)")
con.close()
