"""Excel Upload 후 CUST_FCST(P+P) 메저 미생성 수정 [E20260929-DMF0014CFSEQ]

사용자 요청 (2026-09-29) :
  "Customer FCST 데이터 Excel Upload 후 CUST_FCST 메저 데이터 생성을 언제 하는지 확인" → 원인 보고 → "네..수정해주세요."

AS-IS (DDL 덤프 SP2:64717 / 35456) :
  CREATE TABLE #TEMP_CUST_FCST_DIVISION (DIVISION_ID NVARCHAR(30), SEQ INT IDENTITY(0,1))
  INSERT INTO #TEMP_CUST_FCST_DIVISION (DIVISION_ID) SELECT DISTINCT DIVISION_ID ...
  → SEQ 0,1,2… 자동 채번 → WHILE @I <= MAX(SEQ) 로 division 마다 EXEC PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST

TO-BE 결함 :
  GT_DPCF_CUST_FCST_DIVISION.SEQ = 일반 NUMBER (IDENTITY 이관 누락) → INSERT (DIVISION_ID) 만 하면 SEQ NULL
  → MAX(SEQ)=NULL → WHILE 0 <= NULL 거짓 → MAKE_CUST_FCST 미호출 (실측: 'CUST_FCST' 최종 생성 09-14, 09-28 업로드 미반영)

수정 (정상 선례 = PR_DM_DNM_EDI_CALLOFF_MKT_FCST L573~578) :
  ① INSERT (DIVISION_ID, SEQ) SELECT DIVISION_ID, ROW_NUMBER() OVER (ORDER BY DIVISION_ID) - 1 FROM (SELECT DISTINCT …)
  ② SELECT NVL(MAX(T.SEQ), -1) INTO V_CNT   — 대상 0건이면 루프 0회(종전 NULL 과 동일 결과, 의도 명시)

대상 : PKG_DMF0014 PACKAGE BODY (P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST — DMF0014 업로드/저장 경로)
       PR_DM_PLN_CUST_FCST_TO_MKT_FCST PROCEDURE (standalone — 현 호출자 0, 동일 결함 동일 수정)
사전 점검 : PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST('81') 직접 실행 25.8s 성공 → ROLLBACK 원복 확인 (2026-09-29 13:09)
usage: python apply_seq.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

TAG = "E20260929-DMF0014CFSEQ"
TARGETS = [("PKG_DMF0014", "PACKAGE BODY", "PROCEDURE P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST", "END P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST;"),
           ("PR_DM_PLN_CUST_FCST_TO_MKT_FCST", "PROCEDURE", None, None)]

OLD_INS = ("        INSERT\n"
           "        INTO GT_DPCF_CUST_FCST_DIVISION\n"
           "            (DIVISION_ID)\n"
           "            SELECT DISTINCT DIVISION_ID\n"
           "              FROM GT_DPCF_DM_PLN_CUSTOMER_PSI_2;\n")
NEW_INS = ("        /* [" + TAG + "] AS-IS #TEMP_CUST_FCST_DIVISION.SEQ = INT IDENTITY(0,1) — GTT 는 IDENTITY 가 없어 SEQ 가 NULL 로 남아\n"
           "           아래 WHILE 루프가 0회(MAKE_CUST_FCST 미호출)였다. 0-base 채번을 직접 넣는다(PR_DM_DNM_EDI_CALLOFF_MKT_FCST 선례). */\n"
           "        INSERT\n"
           "        INTO GT_DPCF_CUST_FCST_DIVISION\n"
           "            (DIVISION_ID, SEQ)\n"
           "            SELECT D.DIVISION_ID\n"
           "                 , ROW_NUMBER() OVER (ORDER BY D.DIVISION_ID) - 1 AS SEQ\n"
           "              FROM (SELECT DISTINCT DIVISION_ID\n"
           "                      FROM GT_DPCF_DM_PLN_CUSTOMER_PSI_2) D;\n")
OLD_MAX = "        SELECT MAX(T.SEQ)\n          INTO V_CNT\n          FROM GT_DPCF_CUST_FCST_DIVISION T;\n"
NEW_MAX = ("        SELECT NVL(MAX(T.SEQ), -1)   /*[" + TAG + "] 대상 0건 = 루프 0회 명시*/\n"
           "          INTO V_CNT\n          FROM GT_DPCF_CUST_FCST_DIVISION T;\n")


def paths(name):
    return HERE / "00_BACKUP_ASIS" / f"{name}.PRE_CFSEQ.sql", HERE / "01_APPLY" / f"{name}.CFSEQ.sql"


def fetch(cur, name, typ):
    # FRESH-GATE: 항상 DB 에서 새로 읽은 원문 기준
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
    return "".join(r[0] for r in cur.fetchall())


def ddl(text, name, typ):
    head, rest = text.split("\n", 1)
    kw = "PACKAGE\\s+BODY" if typ == "PACKAGE BODY" else "PROCEDURE"
    head = re.sub(rf'(?i)^\s*{kw}\s+"?\w+"?', f'CREATE OR REPLACE {typ} SCM_MGR."{name}"', head, count=1)
    return head + "\n" + rest


def body_of(f):
    t = f.read_text(encoding="utf-8")
    return re.sub(r"\n/\s*$", "", t[t.index("CREATE OR REPLACE"):].rstrip())


def patch(src, beg, end):
    b = src.index(beg) if beg else 0
    e = src.index(end, b) if end else len(src)
    seg = src[b:e]
    for nm, old in (("INS", OLD_INS), ("MAX", OLD_MAX)):
        assert seg.count(old) == 1, f"{nm} 앵커 {seg.count(old)}회 (기대 1)"
    seg = seg.replace(OLD_INS, NEW_INS).replace(OLD_MAX, NEW_MAX)
    out = src[:b] + seg + src[e:]
    c0 = NEW_INS.index("/*")
    assert "/*" not in NEW_INS[c0 + 2:NEW_INS.index("*/")], "중첩 블록 주석"
    return out


def status(cur, name, typ):
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
    return cur.fetchone()


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0].upper() == "ZIOUI1", "대상 DB 가 ZIOUI1 아님"
    for name, typ, beg, end in TARGETS:
        asis, tobe = paths(name)
        if mode == "backup":
            src = fetch(cur, name, typ)
            assert TAG not in src, f"{name} 이미 반영"
            patched = patch(src, beg, end)
            stamp = (f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={status(cur, name, typ)[1]} "
                     f"FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\n"
                     f"-- [{TAG}] GT_DPCF_CUST_FCST_DIVISION.SEQ 0-base 채번 → MAKE_CUST_FCST 루프 복구\n"
                     "SET DEFINE OFF\nSET SQLBLANKLINES ON\n")
            asis.parent.mkdir(parents=True, exist_ok=True); tobe.parent.mkdir(parents=True, exist_ok=True)
            asis.write_text(stamp + ddl(src, name, typ).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
            tobe.write_text(stamp + ddl(patched, name, typ).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
            print(name, "backup ok — 2곳 치환")
        elif mode == "apply":
            # FRESH-GATE: 적용 직전 DB 원문 == 백업본
            assert ddl(fetch(cur, name, typ), name, typ).rstrip() == body_of(asis), f"FRESH-GATE 실패: {name} 백업 이후 변경 — 중단"
            cur.execute(body_of(tobe))
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=name, t=typ)
            errs = cur.fetchall()
            print(name, status(cur, name, typ), "errors", len(errs), "applied==TOBE",
                  ddl(fetch(cur, name, typ), name, typ).rstrip() == body_of(tobe))
            for x in errs[:10]: print("  ", x)
        elif mode == "restore":
            cur.execute(body_of(asis)); print(name, "restored", status(cur, name, typ))


if __name__ == "__main__":
    main()
