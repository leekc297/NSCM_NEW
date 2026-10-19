"""PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 — [E20260827-NLSDATE] 재반영 (현재 사내 본문 유지 + 1줄 외과 치환).
배경: 08-27 사내 적용분이 2026-09-11 09:29:58 컴파일로 적용 전 본문(= DMF0014_NLSDATE_20260827/BACKUP/..._ASIS.sql 과 동일)으로 원복.
usage: python apply_nlsdate.py backup|apply|nlstest
"""
import pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora  # noqa: E402

N = "PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40"
ASIS = HERE / "00_BACKUP_ASIS" / f"{N}.ASIS.sql"
TOBE = HERE / "01_APPLY" / f"{N}.sql"
OLD = "TO_CHAR(FN_NEXT_DAY(CAST(A.SUMMARY_BUCKET_VALUE AS DATE), 'SUN') + (0), 'YYYYMMDD')"
NEW = "TO_CHAR(FN_NEXT_DAY(TO_DATE(A.SUMMARY_BUCKET_VALUE, 'YYYYMMDD') /*[E20260827-NLSDATE]*/, 'SUN') + (0), 'YYYYMMDD')"


def src(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=N)
    return "".join(r[0] for r in cur.fetchall())


def ddl(text):
    head, rest = text.split("\n", 1)
    assert re.match(r"\s*PROCEDURE\b", head, re.I), head[:80]
    name = re.sub(r"(?i)^\s*PROCEDURE\s+", "", head).strip()
    name = name if name.upper().startswith("SCM_MGR.") else "SCM_MGR." + name
    return "CREATE OR REPLACE PROCEDURE " + name + "\n" + rest


def main():
    mode = sys.argv[1]
    import oracledb
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        if mode == "backup":
            s = src(cur)
            assert "E20260827-NLSDATE" not in s, "이미 반영됨"
            assert s.count(OLD) == 1, f"대상 매칭 {s.count(OLD)}건"
            ASIS.parent.mkdir(parents=True, exist_ok=True)
            TOBE.parent.mkdir(parents=True, exist_ok=True)
            ASIS.write_text(ddl(s).rstrip() + "\n/\n", encoding="utf-8")
            TOBE.write_text(ddl(s.replace(OLD, NEW)).rstrip() + "\n/\n", encoding="utf-8")
            print("written; lines", s.count("\n"))
        elif mode == "apply":
            assert ddl(src(cur)).rstrip() + "\n/\n" == ASIS.read_text(encoding="utf-8"), "게이트 실패: 현재 본문 != 백업 — 중단"
            cur.execute(TOBE.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip())
            cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=N)
            print("status", cur.fetchall())
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY SEQUENCE", n=N)
            print("errors", cur.fetchall() or 0)
            s = src(cur)
            print("applied == TOBE:", ddl(s).rstrip() + "\n/\n" == TOBE.read_text(encoding="utf-8"), "| NLSDATE marker", s.count("E20260827-NLSDATE"))
            cur.execute("""SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID'
                           AND OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES WHERE REFERENCED_OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""", n=N)
            print("invalid dependents", cur.fetchall() or 0)
        elif mode == "nlstest":
            # 세션 NLS_DATE_FORMAT 을 다른 형식으로 두고 두 식을 비교 — 종전 CAST 식은 형식 의존
            cur.execute("ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR'")
            for label, expr in (("CAST (현재 원복본)", "CAST('20260915' AS DATE)"), ("TO_DATE (정정본)", "TO_DATE('20260915','YYYYMMDD')")):
                try:
                    cur.execute(f"SELECT TO_CHAR(FN_NEXT_DAY({expr}, 'SUN'), 'YYYYMMDD') FROM DUAL")
                    print(f"  {label}: OK {cur.fetchone()[0]}")
                except Exception as e:
                    print(f"  {label}: ERROR {str(e).splitlines()[0]}")


if __name__ == "__main__":
    main()
