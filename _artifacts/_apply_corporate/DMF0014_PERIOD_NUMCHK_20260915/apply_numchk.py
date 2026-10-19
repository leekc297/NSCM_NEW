"""PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD — PERIOD(수량) 숫자 아닌 값 → 검증 메시지 [E20260915-DMF0014NUMCHK]

증상: 기간 칸에 'abc'·'1,000'·'12a' 등 → 업로드 검증 대신 ORA-01722(SQL ERROR)로 전체 중단 (사내 재현 2026-09-15 20:59)
원인: 문자 검증(Invalid Quantity) 뒤 소수점 검증이 모든 값을 TO_NUMBER 변환. [E20260911-DMF0014MULTI] 로 문자 검증 후 즉시 반환이
      없어져 문자값이 소수점 검증까지 흘러가 변환 오류.
보완: 소수점 검증 CASE 에 문자 검증과 같은 숫자 패턴 가드 — 숫자 아닌 값은 문자 검증이 이미 ERROR 로 표시하므로 여기서는 0
usage: python apply_numchk.py backup | apply | test
"""
import datetime, glob, os, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0014", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0014_BODY.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0014_BODY.sql"
SPLIT = "PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM"
OLD = ",SUM(CASE WHEN ROUND(TO_NUMBER(VALUE), 10) - FLOOR(ROUND(TO_NUMBER(VALUE), 10)) <> 0 THEN 1 ELSE 0 END) PRICE"
NEW = (",SUM(CASE WHEN NOT REGEXP_LIKE(VALUE, '^-?[0-9]*\\.?[0-9]+$') THEN 0   /*[E20260915-DMF0014NUMCHK] 숫자 아닌 값은 문자 검증이 ERROR 표시 — 여기서 TO_NUMBER 하면 ORA-01722*/\n"
       "                                             WHEN ROUND(TO_NUMBER(VALUE), 10) - FLOOR(ROUND(TO_NUMBER(VALUE), 10)) <> 0 THEN 1 ELSE 0 END) PRICE")


def fetch(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=NAME, t=TYP)
    return "".join(r[0] for r in cur.fetchall())


def ddl(text):
    head, rest = text.split("\n", 1)
    head = re.sub(r'(?i)^\s*PACKAGE\s+BODY\s+"?\w+"?', f'CREATE OR REPLACE PACKAGE BODY SCM_MGR."{NAME}"', head, count=1)
    return head + "\n" + rest


def body_of(f):
    t = f.read_text(encoding="utf-8")
    return re.sub(r"\n/\s*$", "", t[t.index("CREATE OR REPLACE"):].rstrip())


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    if mode == "backup":
        src = fetch(cur)
        assert "E20260915-DMF0014NUMCHK" not in src, "이미 반영"
        i = src.index(SPLIT)
        assert src[:i].count(OLD) == 1, src[:i].count(OLD)
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={cur.fetchone()[0]} FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\nSET DEFINE OFF\n"
        ASIS.parent.mkdir(parents=True, exist_ok=True); TOBE.parent.mkdir(parents=True, exist_ok=True)
        ASIS.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        TOBE.write_text(stamp + ddl(src[:i].replace(OLD, NEW) + src[i:]).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        print("backup ok")
    elif mode == "apply":
        # FRESH-GATE: 적용 직전 DB 원문 == 백업
        assert ddl(fetch(cur)).rstrip() == body_of(ASIS), "FRESH-GATE 실패: 백업 이후 DB 원문 변경 — 중단"
        cur.execute(body_of(TOBE))
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        print("status", cur.fetchone())
        cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t", n=NAME, t=TYP); print("errors", cur.fetchone()[0])
        print("applied == TOBE", ddl(fetch(cur)).rstrip() == body_of(TOBE))
    elif mode == "test":
        import openpyxl, requests
        src = sorted(glob.glob(r"C:\Projects\NSCM\Doc\단위테스트\_excel_upload_cases\DMF0014_SAMPLE\DMF0014_Upload_Sample10_*.xlsx"))[-1]
        s = requests.Session(); s.post("http://localhost:8080/user/login", json={"userId": "minyonglee1"}, timeout=30)
        def up(path):
            with open(path, "rb") as fh:
                return s.post("http://localhost:8080/DMF0014/FCST Upload/UPLOAD/excel-upload", files={"file": (os.path.basename(path), fh)}, timeout=600).json()
        wb = openpyxl.load_workbook(src); ws = wb.active
        vals = ["abc", "1,000", "12a", "1.2.3", "-", "１００", "1e3", "12.5", " ", "10%"]
        for k, v in enumerate(vals):
            ws.cell(row=2 + k, column=14, value=v).number_format = "@"
        out = HERE / "TEST_period_nonnumeric.xlsx"; wb.save(out)
        j = up(out); r = j.get("result") or {}
        print("비숫자 파일:", j.get("code"), (j.get("message") or "")[:120], r.get("O_CUR_CNT"))
        err = {x.get("EXCEL_ROW"): x.get("MESSAGE_TEXT") for x in r.get("O_CUR_LIST") or []}
        for k, v in enumerate(vals):
            print(f"  row {2 + k} {v!r:8} → {err.get(2 + k, 'SUCCESS')}")
        j = up(src); print("정상 샘플 회귀:", j.get("code"), (j.get("result") or {}).get("O_CUR_CNT"))


if __name__ == "__main__":
    main()
