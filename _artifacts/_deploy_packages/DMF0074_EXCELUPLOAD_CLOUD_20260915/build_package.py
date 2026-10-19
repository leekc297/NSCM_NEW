"""DMF0074 Metal Link Price Excel Upload — 클라우드 이관 패키지 생성기 (사내 ZIOUI1 현재 원문 추출, 2026-09-15).
생성물: 00_PRECHECK.sql(조회전용) / 10~13 객체별 CREATE OR REPLACE / 30_EXCEL_COLUMNS_DMF0074.sql(멱등 MERGE) / 90_VERIFY.sql / _MANIFEST.md
       + BE_MERGE · FE_MERGE (로컬 현재본 복사) + C_TESTDATA (샘플 10행)
usage: python build_package.py [--selftest]   # --selftest = 00_PRECHECK 의 SELECT 를 사내에서 실행해 판정 로직 확인
"""
import datetime, hashlib, pathlib, re, shutil, sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora  # noqa: E402

MARK = re.compile(r"E20\d{6}-[A-Z0-9_]+|hook#\d+")
MARK_SQL = "E20[0-9]{6}-[A-Z0-9_]+|hook#[0-9]+"
OBJECTS = [  # (파일번호, 객체명, 타입, 역할)
    ("10", "PKG_NSCM_UI_EXCEL", "PACKAGE", "② 임시적재 / ④ 결과조회 (공용 — 전 화면 Excel Upload)"),
    ("11", "PKG_NSCM_UI_EXCEL", "PACKAGE BODY", "② 임시적재 / ④ 결과조회 (공용 — 전 화면 Excel Upload)"),
    ("12", "PKG_DMF0074", "PACKAGE", "③ 검증 P_DMF0074_EXCEL_UPLOAD / ⑤ 저장 / 조회"),
    ("13", "PKG_DMF0074", "PACKAGE BODY", "③ 검증 P_DMF0074_EXCEL_UPLOAD / ⑤ 저장 / 조회"),
]
PROGRAMS = ("DMF0074", "DMF0074_40")
COPY = [  # (패키지 내 경로, 로컬 원본)
    ("BE_MERGE/nscm-be/src/main/java/com/lgcns/nscm/framework/utils/ExcelUtils.java", "nscm-be/src/main/java/com/lgcns/nscm/framework/utils/ExcelUtils.java"),
    ("BE_MERGE/nscm-be/src/main/java/com/lgcns/nscm/general/file/FileServiceImpl.java", "nscm-be/src/main/java/com/lgcns/nscm/general/file/FileServiceImpl.java"),
    ("FE_MERGE/nscm-fe/features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx", "nscm-fe/features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx"),
    ("FE_MERGE/nscm-fe/features/demand/src/pages/metal-link-price/metal-link-price.constants.ts", "nscm-fe/features/demand/src/pages/metal-link-price/metal-link-price.constants.ts"),
    ("FE_MERGE/nscm-fe/features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx", "nscm-fe/features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx"),
    ("FE_MERGE/nscm-fe/packages/foundation/src/utils/gridAction.ts", "nscm-fe/packages/foundation/src/utils/gridAction.ts"),
    ("C_TESTDATA/DMF0074_40_Upload_Sample10_20260915.xlsx", "Doc/단위테스트/_excel_upload_cases/DMF0074_SAMPLE/DMF0074_40_Upload_Sample10_20260915.xlsx"),
    ("C_TESTDATA/DMF0074_MetalLinkPricePopup_ASIS_양식.xlsx", r"C:\TRANFILE\RECEIVE\DMF0074_MetalLinkPricePopup_ASIS.xlsx"),
]


def fetch(cur, name, typ):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
    return "".join(r[0] for r in cur.fetchall()).replace("\r\n", "\n")


def ddl(text, typ, name):
    head, rest = text.split("\n", 1)
    assert re.match(r"\s*" + typ.replace(" ", r"\s+") + r"\b", head, re.I), (name, head[:60])
    return f"CREATE OR REPLACE {typ} SCM_MGR.{name}\n" + re.sub(r"(?i)^\s*" + typ.replace(" ", r"\s+") + r"\s+\"?\w+\"?\s*", "", head, count=1) + "\n" + rest


def q(s):
    return "NULL" if s is None else "'" + str(s).replace("'", "''") + "'"


def main():
    import oracledb
    u, p, d = ora.conn_info()
    manifest = ["# MANIFEST — 사내 ZIOUI1 원문 추출 (2026-09-15)", "", "| 파일 | 객체 | 타입 | 사내 LAST_DDL | 줄 | sha1(정규화) | 수정 마커 |", "|---|---|---|---|---:|---|---|"]
    pre = ["-- 00_PRECHECK.sql — 클라우드 현재 상태 점검 (조회 전용 · 변경 없음) · SCM_MGR 로 접속해 실행",
           "-- [A] EXPECTED_MISSING 이 비어 있지 않은 객체 = 사내 보완분이 빠진 '수정 전 소스' → 해당 1x 파일 적용 대상",
           "-- [A] CLOUD_ONLY_MARKERS 가 있으면 클라우드에만 있는 수정 → 그 객체는 전체교체 금지 (결과 공유 요청)",
           "-- [B] EXCEL_COLUMNS DIFF_* = 사내 값과 차이 → 30 파일 적용",
           "-- [C] 의존 객체 MISSING 행이 있으면 1x 적용 시 컴파일 실패 → 먼저 알려 주세요",
           "SET PAGESIZE 200 LINESIZE 400 LONG 100000",
           "COLUMN OBJECT_NAME FORMAT A30", "COLUMN OBJECT_TYPE FORMAT A14", "COLUMN EXPECTED_MISSING FORMAT A120", "COLUMN CLOUD_ONLY_MARKERS FORMAT A80", "",
           "-- [A] 객체별 보완 마커"]
    ver = ["-- 90_VERIFY.sql — 적용 후 확인 (SCM_MGR)", "SET PAGESIZE 200 LINESIZE 300", ""]
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for no, name, typ, desc in OBJECTS:
            src = fetch(cur, name, typ)
            assert src, (name, typ)
            marks = sorted(set(MARK.findall(src)))
            cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
            ldt, st = cur.fetchone()
            assert st == "VALID", (name, typ, st)
            fname = f"{no}_{name}_{typ.replace(' ', '_')}.sql"
            # FRESH-GATE (hook #152): 파일 기록 직전 DB 원문·LAST_DDL 재조회 — 추출 중 변경되면 중단
            cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
            assert cur.fetchone()[0] == ldt and fetch(cur, name, typ) == src, f"FRESH-GATE 실패: {name} {typ} 추출 중 변경 — 재빌드"
            fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
            (HERE / fname).write_text(
                f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={ldt} FETCHED={fetched} DB=ZIOUI1\n"
                f"-- {name} {typ} — {desc}\n-- 원천: 사내 ZIOUI1 SCM_MGR 현재 원문 (LAST_DDL {ldt}, VALID) · 수정 마커 {len(marks)}종\n"
                "SET DEFINE OFF\nSET SQLBLANKLINES ON\n" + ddl(src, typ, name).rstrip() + "\n/\nSHOW ERRORS " + typ + " SCM_MGR." + name + "\n",
                encoding="utf-8", newline="\n")
            sha = hashlib.sha1(re.sub(r"\s+", " ", src).strip().encode()).hexdigest()[:12]
            manifest.append(f"| `{fname}` | {name} | {typ} | {ldt} | {src.count(chr(10))} | {sha} | {', '.join(marks) or '-'} |")
            exp = ",".join(f"'{m}'" for m in marks) or "'-NONE-'"
            pre.append(f"""SELECT O.OBJECT_NAME, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) SRC_LINES,
       (SELECT LISTAGG(E.M, ',') WITHIN GROUP (ORDER BY E.M) FROM (SELECT COLUMN_VALUE M FROM TABLE(SYS.ODCIVARCHAR2LIST({exp}))) E
         WHERE E.M <> '-NONE-' AND NOT EXISTS (SELECT 1 FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE AND INSTR(S.TEXT, E.M) > 0)) EXPECTED_MISSING,
       (SELECT LISTAGG(X.M, ',') WITHIN GROUP (ORDER BY X.M) FROM (SELECT DISTINCT REGEXP_SUBSTR(S.TEXT, '{MARK_SQL}') M FROM USER_SOURCE S
          WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE AND REGEXP_LIKE(S.TEXT, '{MARK_SQL}')) X
         WHERE X.M NOT IN ({exp})) CLOUD_ONLY_MARKERS
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{name}' AND O.OBJECT_TYPE='{typ}';
""")
            ver.append(f"SELECT '{name}' OBJ, '{typ}' TYP, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{name}' AND OBJECT_TYPE='{typ}';")

        # [B] EXCEL_COLUMNS
        cur.execute(f"""SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT, OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN
                          FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID IN {PROGRAMS} ORDER BY PROGRAM_ID""")
        rows = cur.fetchall()
        assert len(rows) == 2, rows
        merges, pre_b = [], ["-- [B] SCM_ADM_EXCEL_COLUMNS — 사내 값과 다르면 DIFF_* = 'DIFF' (행이 안 나오면 = 미존재 → 30 적용)"]
        for pid, sht, sql_id, hdr, optn, vyn in rows:
            hdr = hdr.read() if hasattr(hdr, "read") else hdr
            assert "Period(Fr)_Ni" in hdr, (pid, hdr[:200])
            merges.append(f"""MERGE INTO SCM_MGR.SCM_ADM_EXCEL_COLUMNS T
USING (SELECT {q(pid)} PROGRAM_ID, {q(sht)} SHEET_NAME, {q(sql_id)} STORAGE_SQL_ID, {q(hdr)} HEADER_CONTENT, {optn} OPTION_ATTRIBUTE_COLUMN_NUMBER, {q(vyn)} VALID_YN FROM DUAL) S
ON (T.PROGRAM_ID = S.PROGRAM_ID AND T.SHEET_NAME = S.SHEET_NAME)
WHEN MATCHED THEN UPDATE SET T.STORAGE_SQL_ID = S.STORAGE_SQL_ID, T.HEADER_CONTENT = S.HEADER_CONTENT,
     T.OPTION_ATTRIBUTE_COLUMN_NUMBER = S.OPTION_ATTRIBUTE_COLUMN_NUMBER, T.VALID_YN = S.VALID_YN,
     T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT, OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
     VALUES (S.PROGRAM_ID, S.SHEET_NAME, S.STORAGE_SQL_ID, S.HEADER_CONTENT, S.OPTION_ATTRIBUTE_COLUMN_NUMBER, S.VALID_YN, 'admin', SYSDATE, 'admin', SYSDATE);""")
            pre_b.append(f"""SELECT PROGRAM_ID, SHEET_NAME,
       CASE WHEN STORAGE_SQL_ID = {q(sql_id)} THEN 'SAME' ELSE 'DIFF' END DIFF_STORAGE_SQL_ID,
       CASE WHEN DBMS_LOB.COMPARE(TO_CLOB(HEADER_CONTENT), TO_CLOB({q(hdr)})) = 0 THEN 'SAME' ELSE 'DIFF' END DIFF_HEADER_CONTENT,
       CASE WHEN INSTR(HEADER_CONTENT, 'Period(Fr)_Ni') > 0 THEN '2단' WHEN INSTR(HEADER_CONTENT, 'PeriodFr_Ni') > 0 THEN '구 1단' ELSE '?' END HEADER_FORM,
       OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID = {q(pid)} AND SHEET_NAME = {q(sht)};""")
        (HERE / "30_EXCEL_COLUMNS_DMF0074.sql").write_text(
            "-- SCM_ADM_EXCEL_COLUMNS DMF0074 / DMF0074_40 — 사내 현재 값 목표상태 (멱등 · 비파괴 · 사전값 WHERE 없음)\n"
            "-- ⚠ BE(ExcelUtils/FileServiceImpl 2단 파싱)와 동시 반영 — 구 BE 에서는 'Period(Fr)_Ni' 토큰을 못 찾아 메탈 열이 탈락한다\n"
            "SET DEFINE OFF\n" + "\n".join(merges) + "\nCOMMIT;\n", encoding="utf-8", newline="\n")
        pre += pre_b

        # [C] 의존 객체 존재 + 컬럼
        cur.execute("""SELECT DISTINCT REFERENCED_NAME, REFERENCED_TYPE FROM ALL_DEPENDENCIES
                        WHERE OWNER='SCM_MGR' AND NAME IN ('PKG_DMF0074','PKG_NSCM_UI_EXCEL') AND REFERENCED_OWNER='SCM_MGR'
                          AND REFERENCED_NAME NOT IN ('PKG_DMF0074','PKG_NSCM_UI_EXCEL') ORDER BY 2, 1""")
        deps = cur.fetchall()
        dep_list = ",\n  ".join(f"SYS.ODCIVARCHAR2LIST('{n}','{t}')" for n, t in deps)
        pre.append(f"""-- [C] 의존 객체 — MISSING 행만 출력 (0행 = 정상). 사내 기준 {len(deps)}개
SELECT D.COLUMN_VALUE REQUIRED, 'MISSING' STATE FROM TABLE(SYS.ODCIVARCHAR2LIST({", ".join(f"'{n}'" for n, _ in deps)})) D
 WHERE NOT EXISTS (SELECT 1 FROM USER_OBJECTS O WHERE O.OBJECT_NAME = D.COLUMN_VALUE);
-- [C] PKG_DMF0074 조회부(hook#150)가 쓰는 컬럼 — 0 이면 13 BODY 컴파일 실패
SELECT 'SCM_MST_SITE_ITEM.DEPT_ID' REQUIRED, COUNT(*) EXISTS_CNT FROM USER_TAB_COLUMNS WHERE TABLE_NAME='SCM_MST_SITE_ITEM' AND COLUMN_NAME='DEPT_ID';
-- [C] 검증 기준 데이터 — Key 룩업(사내 Div40 24행) / 앱계정 실행 경로
SELECT SEGMENT1 DIV, COUNT(*) METAL_KEY_VALUE_CNT FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='METAL_KEY_VALUE' AND VALID_YN='Y' GROUP BY SEGMENT1 ORDER BY 1;
SELECT OWNER, SYNONYM_NAME, TABLE_OWNER FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND SYNONYM_NAME IN ('PKG_NSCM_UI_EXCEL','PKG_DMF0074');
SELECT GRANTEE, TABLE_NAME, PRIVILEGE FROM USER_TAB_PRIVS WHERE GRANTEE='SCMP_APP' AND TABLE_NAME IN ('PKG_NSCM_UI_EXCEL','PKG_DMF0074');""")
        manifest += ["", f"의존 객체(SCM_MGR) {len(deps)}개: " + ", ".join(f"{n}({t})" for n, t in deps)]

    ver += ["SELECT NAME, TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME IN ('PKG_NSCM_UI_EXCEL','PKG_DMF0074') ORDER BY NAME, TYPE, SEQUENCE;",
            "SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS='INVALID' ORDER BY 1;",
            "SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, CASE WHEN INSTR(HEADER_CONTENT,'Period(Fr)_Ni') > 0 THEN '2단 OK' ELSE 'CHECK' END HEADER_FORM FROM SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID IN ('DMF0074','DMF0074_40');",
            "SELECT OWNER, SYNONYM_NAME FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND SYNONYM_NAME IN ('PKG_NSCM_UI_EXCEL','PKG_DMF0074');",
            "SELECT GRANTEE, TABLE_NAME, PRIVILEGE FROM USER_TAB_PRIVS WHERE GRANTEE='SCMP_APP' AND TABLE_NAME IN ('PKG_NSCM_UI_EXCEL','PKG_DMF0074');"]
    (HERE / "00_PRECHECK.sql").write_text("\n".join(pre) + "\n", encoding="utf-8", newline="\n")
    (HERE / "90_VERIFY.sql").write_text("\n".join(ver) + "\n", encoding="utf-8", newline="\n")

    manifest += ["", "## BE / FE / 테스트데이터 (로컬 현재본 복사)", "| 패키지 경로 | sha1 |", "|---|---|"]
    for dst, src in COPY:
        s = pathlib.Path(src) if pathlib.Path(src).is_absolute() else ROOT / src
        t = HERE / dst
        t.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(s, t)
        manifest.append(f"| `{dst}` | {hashlib.sha1(s.read_bytes()).hexdigest()[:12]} |")
    (HERE / "_MANIFEST.md").write_text("\n".join(manifest) + "\n", encoding="utf-8")
    print("\n".join(manifest))


def selftest(fake=False):
    """사내에서 00_PRECHECK 의 SELECT 를 실행. fake=True 면 기대 마커에 가짜 값을 끼워 EXPECTED_MISSING 검출 확인."""
    import oracledb
    u, p, d = ora.conn_info()
    text = (HERE / "00_PRECHECK.sql").read_text(encoding="utf-8")
    if fake:
        text = text.replace("SYS.ODCIVARCHAR2LIST('E20", "SYS.ODCIVARCHAR2LIST('E20991231-FAKEPROBE','E20", 1)
    stmts = [s.strip() for s in re.split(r";\s*\n", text) if re.search(r"(?im)^\s*SELECT\b", s)]
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
        for s in stmts:
            sql = "\n".join(l for l in s.splitlines() if not l.strip().startswith(("--", "SET ", "COLUMN ")))
            cur.execute(sql.replace("USER_SOURCE", "ALL_SOURCE").replace("USER_OBJECTS", "ALL_OBJECTS").replace("USER_TAB_COLUMNS", "ALL_TAB_COLUMNS")
                        .replace("FROM ALL_SOURCE S WHERE", "FROM ALL_SOURCE S WHERE S.OWNER='SCM_MGR' AND")
                        .replace("FROM ALL_OBJECTS O WHERE", "FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR' AND")
                        .replace("FROM ALL_TAB_COLUMNS WHERE", "FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND")
                        .replace("FROM USER_TAB_PRIVS WHERE", "FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA='SCM_MGR' AND"))
            print([c[0] for c in cur.description]); [print("   ", r) for r in cur.fetchall()]


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        selftest(fake="--fake" in sys.argv)
    else:
        main()
