"""[E20261013-DMF0005MCDUP] CHECK_DUP 판정 검증 (읽기 전용 — 갱신·커밋 없음)

적용본(01_PKG_DMF0005_BODY.sql)에서 CHECK_DUP 원문을 그대로 잘라 익명 블록으로 실행하고,
다른 방식으로 계산한 정답과 테이블별로 대조한다.

  정답 = 그 테이블의 (ITEM_ID 포함) 유일 인덱스별로, 변경을 반영한 ITEM_ID 로 GROUP BY 했을 때 COUNT(*) > 1 인 묶음이 있는가.
  CHECK_DUP = 메시지를 냈는가.

시나리오: 단일 변경쌍(충돌 있음 / 없음) · 두 변경 전 Model 이 한 변경 후 Model 로 모임 · 충돌 상대가 같은 배치에서 옮겨감.
"""
import sys, os, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))


def load():
    src = open(os.path.join(HERE, "01_PKG_DMF0005_BODY.sql"), encoding="utf-8").read()
    m = re.search(r"    PROCEDURE CHECK_DUP\(.*?    END CHECK_DUP;\n", src, re.S)
    assert m, "CHECK_DUP 원문을 찾지 못함"
    tabs = [(t, f == "TRUE") for t, f in re.findall(r"CHANGE_TABLE\('(\w+)',\s*(TRUE|FALSE)", src)]
    assert len(tabs) == 38, len(tabs)
    return m.group(0), tabs


def block(check_src):
    return f"""
DECLARE
    EX_BIZ_EX   EXCEPTION;
    V_ERR_MSG   VARCHAR2(4000);
    TYPE T_STR_MAP IS TABLE OF VARCHAR2(200) INDEX BY VARCHAR2(200);
    V_MAP       T_STR_MAP;
    V_BEF_LIST  SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
    V_P         VARCHAR2(4000) := :pairs;
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG := P_MSG;
        RAISE EX_BIZ_EX;
    END;
{check_src}
BEGIN
    FOR I IN 1 .. LENGTH(V_P) / 24 LOOP
        V_BEF_LIST.EXTEND;
        V_BEF_LIST(I) := SUBSTR(V_P, (I - 1) * 24 + 1, 12);
        V_MAP(V_BEF_LIST(I)) := SUBSTR(V_P, (I - 1) * 24 + 13, 12);
    END LOOP;
    CHECK_DUP(:t, :d = 1);
    :o := NULL;
EXCEPTION
    WHEN EX_BIZ_EX THEN
        :o := V_ERR_MSG;
END;"""


def truth(cur, table, div40, pairs):
    """정답: 유일 인덱스별 '변경 반영 후 키' 중복 묶음 수 합계"""
    cur.execute("""SELECT I.INDEX_NAME, LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION)
                   FROM USER_INDEXES I JOIN USER_IND_COLUMNS C ON C.INDEX_NAME = I.INDEX_NAME
                   WHERE I.TABLE_NAME = :t AND I.UNIQUENESS = 'UNIQUE' GROUP BY I.INDEX_NAME""", t=table)
    total = 0
    for ix, cols in cur.fetchall():
        cols = cols.split(",")
        if "ITEM_ID" not in cols:
            continue
        others = [c for c in cols if c != "ITEM_ID"]
        dec = ", ".join(f"'{b}', '{a}'" for b, a in pairs)
        ni = f"DECODE(ITEM_ID, {dec}, ITEM_ID)"
        if div40:
            ni = f"CASE WHEN DIVISION_ID = '40' THEN {ni} ELSE ITEM_ID END"
        items = ", ".join(f"'{x}'" for p in pairs for x in p)
        grp = ", ".join(others + [ni])
        cur.execute(f"SELECT COUNT(*) FROM ( SELECT 1 FROM SCM_MGR.{table} WHERE ITEM_ID IN ({items}) GROUP BY {grp} HAVING COUNT(*) > 1 )")
        total += cur.fetchone()[0]
    return total


def main():
    check_src, tabs = load()
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-RR' NLS_DATE_LANGUAGE='AMERICAN'")   # 클라우드 BE 세션과 같은 날짜 형식
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone())
    scen = []
    for a in sys.argv[1:]:   # 시나리오 = 'B1>A1,B2>A2'
        scen.append([tuple(x.split(">")) for x in a.split(",")])
    blk = block(check_src)
    fail = 0
    for pairs in scen:
        pstr = "".join(b + a for b, a in pairs)
        hit_t = hit_c = 0
        first = None
        for t, div in tabs:
            o = cur.var(str, 4000)
            cur.execute(blk, pairs=pstr, t=t, d=1 if div else 0, o=o)
            msg = o.getvalue()
            tr = truth(cur, t, div, pairs)
            ok = (msg is not None) == (tr > 0)
            hit_t += (tr > 0); hit_c += (msg is not None)
            if msg and first is None:
                first = msg
            if not ok:
                fail += 1
                print("   MISMATCH", t, "truth", tr, "check", msg)
        print("PASS" if hit_t == hit_c else "FAIL", "|", " ".join(f"{b}>{a}" for b, a in pairs),
              "| 충돌 테이블: 정답", hit_t, "/ CHECK_DUP", hit_c, "/ 38")
        if first:
            print("   첫 메시지:", first.replace("\n", " ⏎ "))
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
