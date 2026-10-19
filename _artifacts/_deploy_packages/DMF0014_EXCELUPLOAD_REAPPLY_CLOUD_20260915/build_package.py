"""DMF0014 Excel Upload 경로 DB 객체 — 클라우드 재반영 패키지 생성기 (사내 ZIOUI1 현재 원문 추출).
생성물: 00_PRECHECK.sql(조회전용) / 1x_*.sql(객체별 CREATE OR REPLACE) / 30_EXCEL_COLUMNS.sql(멱등) / 90_VERIFY.sql / _MANIFEST.md
"""
import datetime, hashlib, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora  # noqa: E402

MARK = re.compile(r"E20\d{6}-[A-Z0-9_]+")
OBJECTS = [  # (파일번호, 객체명, 타입, 경로 설명)
    ("10", "PKG_NSCM_UI_EXCEL", "PACKAGE", "② 임시적재 / ④ 결과조회 (공용 — 전 화면 Excel Upload)"),
    ("11", "PKG_NSCM_UI_EXCEL", "PACKAGE BODY", "② 임시적재 / ④ 결과조회 (공용 — 전 화면 Excel Upload)"),
    ("12", "PKG_DMF0014", "PACKAGE", "③ 검증 / ⑤ 저장"),
    ("13", "PKG_DMF0014", "PACKAGE BODY", "③ 검증 / ⑤ 저장"),
    ("14", "PR_DM_PLN_CUST_FCST_TO_MKT_FCST", "PROCEDURE", "⑤ 저장 후 MKT FCST 반영"),
    ("15", "PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40", "PROCEDURE", "⑤ 저장 후 MKT FCST 반영 (Div40)"),
]


def fetch(cur, name, typ):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
    return "".join(r[0] for r in cur.fetchall()).replace("\r\n", "\n")


def ddl(text, typ, name):
    head, rest = text.split("\n", 1)
    assert re.match(r"\s*" + typ.replace(" ", r"\s+") + r"\b", head, re.I), (name, head[:60])
    return f"CREATE OR REPLACE {typ} SCM_MGR.{name}\n" + re.sub(r"(?i)^\s*" + typ.replace(" ", r"\s+") + r"\s+\"?\w+\"?\s*", "", head, count=1) + "\n" + rest


def main():
    import oracledb
    u, p, d = ora.conn_info()
    manifest = ["# MANIFEST — 사내 ZIOUI1 원문 추출", "", "| 파일 | 객체 | 타입 | 사내 LAST_DDL | 줄 | sha1(정규화) | 수정 마커 |", "|---|---|---|---|---:|---|---|"]
    pre = ["-- 00_PRECHECK.sql — 클라우드 현재 상태 점검 (조회 전용 · 변경 없음)",
           "-- 결과의 EXPECTED_MISSING 가 비어 있지 않은 객체 = 사내 보완분이 빠진 '수정 전 소스'.",
           "-- CLOUD_ONLY_MARKERS 가 있으면 클라우드에만 있는 수정이 있다는 뜻 → 해당 객체 전체교체 전 반드시 알려 주세요.",
           "SET PAGESIZE 200 LINESIZE 400 LONG 100000",
           "COLUMN OBJECT_NAME FORMAT A36", "COLUMN OBJECT_TYPE FORMAT A14", "COLUMN EXPECTED_MISSING FORMAT A120", "COLUMN CLOUD_ONLY_MARKERS FORMAT A80", ""]
    ver = ["-- 90_VERIFY.sql — 적용 후 확인", "SET PAGESIZE 200 LINESIZE 300", ""]
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
            body = ddl(src, typ, name).rstrip()
            # FRESH-GATE (hook #152): 파일 기록 직전 DB 원문·LAST_DDL 재조회 — 추출 중 변경되면 중단
            cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
            assert cur.fetchone()[0] == ldt and fetch(cur, name, typ) == src, f"FRESH-GATE 실패: {name} {typ} 추출 중 변경 — 재빌드"
            fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
            (HERE / fname).write_text(
                f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={ldt} FETCHED={fetched} DB=ZIOUI1\n"
                f"-- {name} {typ} — {desc}\n-- 원천: 사내 ZIOUI1 SCM_MGR 현재 원문 (LAST_DDL {ldt}, VALID) · 수정 마커 {len(marks)}종\n"
                "SET DEFINE OFF\nSET SQLBLANKLINES ON\n" + body + "\n/\nSHOW ERRORS " + typ + " SCM_MGR." + name + "\n",
                encoding="utf-8", newline="\n")
            sha = hashlib.sha1(re.sub(r"\s+", " ", src).strip().encode()).hexdigest()[:12]
            manifest.append(f"| `{fname}` | {name} | {typ} | {ldt} | {src.count(chr(10))} | {sha} | {', '.join(marks) or '-'} |")
            exp = ",".join(f"'{m}'" for m in marks) or "'-NONE-'"
            pre.append(f"""-- {name} {typ}
SELECT O.OBJECT_NAME, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) SRC_LINES,
       (SELECT LISTAGG(E.M, ',') WITHIN GROUP (ORDER BY E.M) FROM (SELECT COLUMN_VALUE M FROM TABLE(SYS.ODCIVARCHAR2LIST({exp}))) E
         WHERE E.M <> '-NONE-' AND NOT EXISTS (SELECT 1 FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE AND INSTR(S.TEXT, E.M) > 0)) EXPECTED_MISSING,
       (SELECT LISTAGG(X.M, ',') WITHIN GROUP (ORDER BY X.M) FROM (SELECT DISTINCT REGEXP_SUBSTR(S.TEXT, 'E20[0-9]{{6}}-[A-Z0-9_]+') M FROM USER_SOURCE S
          WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE AND REGEXP_LIKE(S.TEXT, 'E20[0-9]{{6}}-[A-Z0-9_]+')) X
         WHERE X.M NOT IN ({exp})) CLOUD_ONLY_MARKERS
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{name}' AND O.OBJECT_TYPE='{typ}';
""")
            ver.append(f"SELECT '{name}' OBJ, '{typ}' TYP, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{name}' AND OBJECT_TYPE='{typ}';")
        # EXCEL_COLUMNS 현재 사내 값 (DMF0014)
        cur.execute("""SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT, OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN
                         FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0014'""")
        rows = cur.fetchall()
        assert len(rows) == 1, rows
        pid, sht, sql_id, hdr, optn, vyn = rows[0]
        q = lambda s: "NULL" if s is None else "'" + str(s).replace("'", "''") + "'"
        (HERE / "30_EXCEL_COLUMNS_DMF0014.sql").write_text(f"""-- SCM_ADM_EXCEL_COLUMNS DMF0014 — 사내 현재 값 목표상태 (멱등 · 비파괴 · 사전값 WHERE 없음)
MERGE INTO SCM_MGR.SCM_ADM_EXCEL_COLUMNS T
USING (SELECT {q(pid)} PROGRAM_ID, {q(sht)} SHEET_NAME, {q(sql_id)} STORAGE_SQL_ID, {q(hdr)} HEADER_CONTENT, {optn} OPTION_ATTRIBUTE_COLUMN_NUMBER, {q(vyn)} VALID_YN FROM DUAL) S
ON (T.PROGRAM_ID = S.PROGRAM_ID AND T.SHEET_NAME = S.SHEET_NAME)
WHEN MATCHED THEN UPDATE SET T.STORAGE_SQL_ID = S.STORAGE_SQL_ID, T.HEADER_CONTENT = S.HEADER_CONTENT,
     T.OPTION_ATTRIBUTE_COLUMN_NUMBER = S.OPTION_ATTRIBUTE_COLUMN_NUMBER, T.VALID_YN = S.VALID_YN,
     T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT, OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
     VALUES (S.PROGRAM_ID, S.SHEET_NAME, S.STORAGE_SQL_ID, S.HEADER_CONTENT, S.OPTION_ATTRIBUTE_COLUMN_NUMBER, S.VALID_YN, 'admin', SYSDATE, 'admin', SYSDATE);
COMMIT;
""", encoding="utf-8", newline="\n")
        pre.append(f"""-- SCM_ADM_EXCEL_COLUMNS DMF0014 — 사내 값과 다르면 DIFF_* = 'DIFF'
SELECT PROGRAM_ID, SHEET_NAME,
       CASE WHEN STORAGE_SQL_ID = {q(sql_id)} THEN 'SAME' ELSE 'DIFF' END DIFF_STORAGE_SQL_ID,
       CASE WHEN HEADER_CONTENT = {q(hdr)} THEN 'SAME' ELSE 'DIFF' END DIFF_HEADER_CONTENT,
       OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID = 'DMF0014';
""")
    ver += ["SELECT NAME, TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME IN ('PKG_NSCM_UI_EXCEL','PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST','PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40') ORDER BY NAME, SEQUENCE;",
            "SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS='INVALID' ORDER BY 1;",
            "-- 앱계정 실행 경로 (없으면 화면에서 PLS-00201)",
            "SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND SYNONYM_NAME IN ('PKG_NSCM_UI_EXCEL','PKG_DMF0014');",
            "SELECT GRANTEE, TABLE_NAME, PRIVILEGE FROM USER_TAB_PRIVS WHERE GRANTEE='SCMP_APP' AND TABLE_NAME IN ('PKG_NSCM_UI_EXCEL','PKG_DMF0014');"]
    (HERE / "00_PRECHECK.sql").write_text("\n".join(pre) + "\n", encoding="utf-8", newline="\n")
    (HERE / "90_VERIFY.sql").write_text("\n".join(ver) + "\n", encoding="utf-8", newline="\n")
    (HERE / "_MANIFEST.md").write_text("\n".join(manifest) + "\n", encoding="utf-8")
    print("\n".join(manifest))


if __name__ == "__main__":
    main()
