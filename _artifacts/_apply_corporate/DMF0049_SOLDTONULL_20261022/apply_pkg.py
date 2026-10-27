"""DMF0049 저장 SOLDTO_CODE 빈값 '/' 치환 제거 — 사내 ZIOUI1 적용기 [E20261022-SOLDTONULL]

P_DMF0049_SAVE_SALES_ETC_REPORT_C 의 INSERT 2곳(UPDATE 대상·INSERT 대상)이
  NVL(NULLIF(RTRIM(A.SOLDTO_CODE),''), '/')   → 빈 Sold-To 를 '/' 로 저장 → 기존 NULL 행과 정렬 위치가 달라짐
AS-IS DMF0049_SAVE_SALES_ETC_REPORT_C 는 값을 그대로(RTRIM/LTRIM) 저장 → Oracle 에서는 NULL.
  → NULLIF(RTRIM(A.SOLDTO_CODE),'') 로 변경. SOLDTO_CODE 는 PK 아님·NULL 허용. 원래 줄은 '--' 주석 보존.

절차: 착수 원문 재조회(ALL_SOURCE+LAST_DDL) → 00_BACKUP 저장 → 외과 치환(대상 2건 assert)
      → FRESH-GATE(적용 직전 재조회 == 착수본) → CREATE OR REPLACE → VALID·오류 0·적용본==DB 원문 확인
  python apply_pkg.py          # 미리보기(파일만 생성)
  python apply_pkg.py --apply  # 사내 적용
"""
import os, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OBJ = "PKG_DMF0049"
MARK = "[E20261022-SOLDTONULL]"
OLD = "NVL(NULLIF(RTRIM(A.SOLDTO_CODE),''), '/')"
NEW = "NULLIF(RTRIM(A.SOLDTO_CODE),'')"
TAIL = "    -- 2026.10.22 " + MARK + " AS-IS 동일 빈 Sold-To = NULL 저장('/' 치환 제거 — 기존 NULL 행과 정렬 일치)\n"


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
    ddl, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=OBJ)
    return "".join(r[0] for r in cur), ddl, st


def patch(src):
    assert src.count(MARK) == 0, "이미 적용됨(마커 있음)"
    assert src.count(OLD) == 2, f"대상 {src.count(OLD)}건 (2 기대) — 원문이 바뀌었음"
    out, pos = [], 0
    for _ in range(2):
        i = src.index(OLD, pos)
        ls = src.rindex("\n", 0, i) + 1
        le = src.index("\n", i) + 1
        line = src[ls:le]
        new_line = line[:i - ls] + NEW + TAIL
        out.append(src[pos:ls] + "--" + line + new_line)
        pos = le
    return "".join(out) + src[pos:]


def main():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL")
    host, db = cur.fetchone()
    base, ddl0, st0 = fetch(cur)
    now = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    print("DB", d, host, db, "| LAST_DDL", ddl0, st0, "| lines", base.count("\n"))
    bk = os.path.join(HERE, f"00_BACKUP_{OBJ}_BODY_{now}.sql")
    open(bk, "w", encoding="utf-8", newline="\n").write(
        f"-- BACKUP {OBJ} PACKAGE BODY LAST_DDL={ddl0} FETCHED={now} HOST={host}\nCREATE OR REPLACE {base.rstrip()}\n/\n")
    tobe = patch(base)
    open(os.path.join(HERE, f"10_TOBE_{OBJ}_BODY_{now}.sql"), "w", encoding="utf-8", newline="\n").write(
        f"CREATE OR REPLACE {tobe.rstrip()}\n/\n")
    print("patched: 대상 2줄 → 주석 보존 + 신규 줄 (마커", tobe.count(MARK), ")")
    if "--apply" not in sys.argv:
        print("미리보기만 — 적용하려면 --apply")
        return
    # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
    cur_src, ddl1, _ = fetch(cur)
    assert cur_src == base and ddl1 == ddl0, "FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합"
    try:
        cur.execute("CREATE OR REPLACE " + tobe)
    except oracledb.DatabaseError as e:
        print("compile exception:", e)
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
    st, ddl2 = cur.fetchone()
    cur.execute("SELECT COUNT(*) FROM USER_ERRORS WHERE NAME=:n AND TYPE='PACKAGE BODY'", n=OBJ)
    errs = cur.fetchone()[0]
    if st != "VALID" or errs:
        cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE", n=OBJ)
        for r in cur.fetchall()[:10]:
            print("  ERR", r)
        cur.execute("CREATE OR REPLACE " + base)   # 원문 복원
        raise SystemExit(f"컴파일 실패({st}, 오류 {errs}) → 원문 복원")
    after, _, _ = fetch(cur)
    assert after.replace("\r\n", "\n").rstrip() == tobe.replace("\r\n", "\n").rstrip(), "적용본 != DB 원문"
    cur.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE STATUS<>'VALID' AND OBJECT_NAME IN ('PKG_DMF0049','PKG_DMF0044')")
    print(f"APPLIED {OBJ} BODY {st} errs=0 LAST_DDL {ddl0} → {ddl2} · 관련 INVALID {cur.fetchone()[0]}")


if __name__ == "__main__":
    main()
