"""DMF0082 환율 모달 — P_DMF0082_POPUP_GET_FUTUREPRICE_INFO O_RC1 에 LAST_UPDATE_DATE / LAST_UPDATED_BY 추가.
usage: python apply_sp.py backup|apply|test
  backup : 현재 PKG_DMF0082 BODY → 00_BACKUP_ASIS/ , 치환본 → 01_APPLY/ (DB 무변경)
  apply  : 게이트(현재 BODY == 백업) 통과 시 배포 → STATUS / ERRORS 확인
  test   : 배포 후 SP 호출 → 컬럼 목록 + 샘플 행 출력 (조회 전용)
"""
import pathlib, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora  # noqa: E402

ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0082_BODY.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0082_BODY.sql"

OLD = """    OPEN O_RC1 FOR
        SELECT YYYYMMDD,
               SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM,
               t1.DIVISION_ID,
               CURRENCY,
               UNIT_CURRENCY,
               EXCHANGE_PRICE,
               NVL(T2.EDIT_YN,'N') AS EDIT_YN
          FROM SCM_MGR.DM_MST_EXCHANGE_RATE t1"""

NEW = """    OPEN O_RC1 FOR
        SELECT YYYYMMDD,
               SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM,
               t1.DIVISION_ID,
               CURRENCY,
               UNIT_CURRENCY,
               EXCHANGE_PRICE,
               NVL(T2.EDIT_YN,'N') AS EDIT_YN,
               --[E20260915-EXLASTUPD] 환율 모달 그리드 Last Update Date / Last Update By 표시 (사용자 지시 2026-09-15).
               --  문자열(YYYY-MM-DD HH24:MI:SS)로 반환 — FE 가 월 피벗 시 행별 최신값 판정(사전식 비교)에 그대로 사용.
               TO_CHAR(t1.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LAST_UPDATE_DATE,
               t1.LAST_UPDATED_BY
          FROM SCM_MGR.DM_MST_EXCHANGE_RATE t1"""


def current_body(cur):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
                   AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    return "".join(r[0] for r in cur.fetchall())


def ddl(body):
    head, rest = body.split("\n", 1)
    assert head.strip().upper().startswith("PACKAGE BODY"), head[:80]
    name_part = head.strip()[len("PACKAGE BODY"):].strip()
    if not name_part.upper().startswith("SCM_MGR."):
        name_part = "SCM_MGR." + name_part
    return "CREATE OR REPLACE PACKAGE BODY " + name_part + "\n" + rest


def main():
    mode = sys.argv[1]
    import oracledb
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        if mode == "backup":
            body = current_body(cur)
            assert body.count(OLD) == 1, f"치환 대상 일치 {body.count(OLD)}건 (1건이어야 함)"
            ASIS.parent.mkdir(parents=True, exist_ok=True)
            TOBE.parent.mkdir(parents=True, exist_ok=True)
            ASIS.write_text(ddl(body) + "\n/\n", encoding="utf-8")
            TOBE.write_text(ddl(body.replace(OLD, NEW)) + "\n/\n", encoding="utf-8")
            print("backup lines", body.count("\n"))
        elif mode == "apply":
            assert ddl(current_body(cur)) + "\n/\n" == ASIS.read_text(encoding="utf-8"), "게이트 실패: 현재 BODY != 백업본 — 중단"
            tobe = TOBE.read_text(encoding="utf-8")
            cur.execute(tobe.rstrip().rstrip("/").rstrip())
            cur.execute("""SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                           FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082'""")
            print(cur.fetchall())
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' ORDER BY SEQUENCE")
            print("errors:", cur.fetchall() or 0)
            print("applied == TOBE:", ddl(current_body(cur)) + "\n/\n" == tobe)
        elif mode == "test":
            rc1, rc2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
            cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_POPUP_GET_FUTUREPRICE_INFO",
                         ["20260101", "20261231", "minyonglee1", "DMF0082", rc1, rc2])
            c1 = rc1.getvalue()
            print("columns:", [c[0] for c in c1.description])
            rows = c1.fetchall()
            print("rows:", len(rows))
            for r in [x for x in rows if x[3] == "KRW"][:4]:
                print(" ", r)


if __name__ == "__main__":
    main()
