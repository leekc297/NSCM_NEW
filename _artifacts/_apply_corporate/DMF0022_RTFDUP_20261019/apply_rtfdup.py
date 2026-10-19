"""
[E20261019-000071] PKG_DMF0022 — Sales Plan Waterfall RTF 중복: 40사업부 [PJ2024-50611] 재적재 블록 주석 처리
 - 기준본 = 착수 시 사내 ZIOUI1 ALL_SOURCE 새 조회본 (PKG_DMF0022_BODY.ASIS.sql)
 - 적용 직전 FRESH-GATE: ALL_SOURCE 재조회 == ASIS
 - usage: python apply_rtfdup.py build | apply
"""
import sys, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb

HERE = pathlib.Path(__file__).resolve().parent
ASIS = HERE / "PKG_DMF0022_BODY.ASIS.sql"
TOBE = HERE / "PKG_DMF0022_BODY.TOBE.sql"

BLOCK_HEAD = (
    "    ------------------------------------------------------------------------------------------\n"
    "    -- [PJ2024-50611] 소형 매출 프로세스 개선\n"
    "    ------------------------------------------------------------------------------------------\n"
    "    IF p_division_id = '40' THEN\n"
)
BLOCK_TAIL = (
    "            UPDATE SET A.QTY = A.QTY * B.RATIO--(B.QTY / B.SUM_QTY)-- 2025.01.23 0 나누기 오류 수정\n"
    "            ;\n"
    "        END IF;\n"
    "    END IF;\n"
)
OPEN = (
    "    --[E20261019-000071]_Sales Plan Waterfall 데이터 RTF 중복 현상 (START)\n"
    "    -- 불필요한 로직으로 주석처리한다.\n"
    "    -- (블록 내 NO_PARALLEL 힌트는 블록주석 중첩 불가(PLS-00103)로 역슬래시 표기로 바꿈)\n"
    "    /*\n"
)
CLOSE = (
    "    */\n"
    "    --[E20261019-000071]_Sales Plan Waterfall 데이터 RTF 중복 현상(END)\n"
)

def fetch_body(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022' "
                "AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return "".join(r[0] for r in cur.fetchall())

def build():
    base = ASIS.read_text(encoding="utf-8")
    assert base.count(BLOCK_HEAD) == 1, "HEAD 매칭 != 1"
    assert base.count(BLOCK_TAIL) == 1, "TAIL 매칭 != 1"
    assert "E20261019-000071" not in base, "이미 반영됨"
    s = base.index(BLOCK_HEAD)
    e = base.index(BLOCK_TAIL) + len(BLOCK_TAIL)
    blk = base[s:e]
    assert blk.count("/*+ NO_PARALLEL */") == 8 and blk.count("*/") == 8 and blk.count("/*") == 8
    blk2 = blk.replace("/*+ NO_PARALLEL */", "\\*+ NO_PARALLEL *\\")
    assert "*/" not in blk2 and "/*" not in blk2
    tobe = base[:s] + OPEN + blk2 + CLOSE + base[e:]
    TOBE.write_text(tobe, encoding="utf-8", newline="")
    print("TOBE built", len(base.splitlines()), "->", len(tobe.splitlines()), "lines")

def apply():
    u, p, d = ora.conn_info()
    tobe = TOBE.read_text(encoding="utf-8")
    with oracledb.connect(user=u, password=p, dsn=d) as c:
        cur = c.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); print("HOST", cur.fetchone()[0])
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
        now = fetch_body(cur)
        assert now == ASIS.read_text(encoding="utf-8"), "FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단"
        print("FRESH-GATE PASS")
        try:
            cur.execute("CREATE OR REPLACE " + tobe)
        except oracledb.DatabaseError as ex:
            print("DDL warn:", ex)
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022' ORDER BY SEQUENCE")
        errs = cur.fetchall(); print("ERRORS", len(errs)); [print(x) for x in errs]
        cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS "
                    "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0022'")
        for r in cur.fetchall(): print(r)
        after = fetch_body(cur)
        print("DB == TOBE :", after.rstrip() == tobe.rstrip())

if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
