"""DMF0021 [E20261111-PRICEDUP] — 81 계열·82 계획구간 Unit Price(KRW/LOC/USD) 생산지 중복 정리

원인 (2026-11-11 사내 ZIOUI1 실측):
  계획구간 PRICE(40 외 분기)는 기준 메저 RAW_DATA 의 DISTINCT (키 + CELL_PROD_SITE_ID) 마다 단가 행을 만든다.
  단가 원장 SCM_MST_FUTURE_PRICE 에 CELL_PROD_SITE_ID 컬럼이 없어(AS-IS 동일) 생산지 조인이 불가 →
  같은 키에 MKT_FCST('-')·RTF_SYS_RP(실제 생산지)가 함께 있으면 같은 단가가 N/A 행·생산지 행 2줄로 나온다.
보완 (사용자 지시 2026-11-11 최종 — TO-BE 신규 룰):
  81 계열·82 에서 같은 키(일자·생산지 제외)의 CELL_PROD_SITE_ID 값('-'·'/' 는 '-' 하나로 셈)이 2개 이상이면
  단가 대상 행을 모두 '-'(화면 FROM_SITE_ID = N/A) 로 모은다 → 생산지별 Unit Price 미생성, N/A 행에만 표시.
  값이 1개면 그대로. 단가 값·원장 조인 조건 불변. 실적구간 PRICE·40 분기 미변경.
사용: python apply_pricedup.py            (기준본·변경본 생성 + ZT 사본 대조 · 운영 PKG 무변경)
      python apply_pricedup.py --apply    (FRESH-GATE 후 운영 적용)
"""
import sys, pathlib, datetime, collections
import oracledb
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info  # noqa: E402

OWNER, NAME = "SCM_MGR", "PKG_DMF0021"
HERE = pathlib.Path(__file__).resolve().parent
MARK = "[E20261111-PRICEDUP]"
HINT = "            SELECT /*+ LEADING(A B C D) USE_HASH(B) USE_NL(C) INDEX(C IDX02_SCM_MST_FUTURE_PRICE) USE_HASH(D) */  --  2026.10.06 AJS\n"
OLD_A_HEAD = "              FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID\n"
OLD_A_TAIL = "                   ) A\n"
OLD_WHERE = ("                      WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd\n"
             "                        AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'Catch_Up' )\n")
KEYS = "A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID"

NEW_A = f"""              --{MARK} 2026-11-11 81 계열·82 Unit Price — 같은 키(일자·생산지 제외)의 CELL_PROD_SITE_ID 가 2개 이상('-'·'/' 는 하나로 셈)이면
              --  단가 대상 행을 '-'(FROM_SITE_ID N/A) 로 모아 생산지별 단가를 만들지 않는다. 1개면 그대로. (사용자 지시 · TO-BE 신규 룰)
              --  사유: 단가 원장 SCM_MST_FUTURE_PRICE 에 CELL_PROD_SITE_ID 없음(AS-IS 동일) → 같은 단가가 N/A 행·생산지 행에 2줄 표시
              FROM ( SELECT DISTINCT X.VERSION_NO, X.CUTOFF_YYYYMMDD, X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID
                          , X.PLANT_SITE_ID, X.ITEM_ID, X.TEXT, X.INCOTERMS, X.DOM_EXP
                          , X.FCST_TYPE, X.CURRENCY, X.COMPANY_ID, X.YYYYMMDD
                          , CASE WHEN ( p_division_id IN ('81','82') OR p_division_id LIKE '81\\_%' ESCAPE '\\' ) AND X.N_SITE >= 2
                                 THEN '-' ELSE X.CELL_PROD_SITE_ID END AS CELL_PROD_SITE_ID
                       FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                                   , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                                   , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
                                   , COUNT(DISTINCT CASE WHEN NVL(A.CELL_PROD_SITE_ID,'-') IN ('-','/') THEN '-' ELSE A.CELL_PROD_SITE_ID END)
                                         OVER ( PARTITION BY {KEYS} ) AS N_SITE
                                FROM GT_DMF0021_RAW_DATA A
                               WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
                                 AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'Catch_Up' )
                            ) X
                   ) A
"""


def fetch(cur, typ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=typ)
    ddl, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=typ)
    return "".join(r[0] for r in cur.fetchall()), ddl, st


def build(base):
    assert MARK not in base, "이미 반영됨"
    assert base.count(HINT) == 1, f"HINT 매칭 {base.count(HINT)}"
    i = base.index(HINT) + len(HINT)
    h = base.index(OLD_A_HEAD, i)
    assert base[i:h].count("\n") == 4, "HINT 와 FROM 사이 줄수 예상과 다름"
    t = base.index(OLD_A_TAIL, h)
    block = base[h:t + len(OLD_A_TAIL)]
    assert block.count(OLD_WHERE) == 1 and "FROM GT_DMF0021_RAW_DATA A" in block, "원 서브쿼리 형태 다름"
    return base[:h] + NEW_A + base[t + len(OLD_A_TAIL):]


def ddl_of(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def renamed(src, new):
    first, rest = src.split("\n", 1)
    assert '"PKG_DMF0021"' in first
    first = first.replace('"PKG_DMF0021"', new)
    k = rest.rfind("END PKG_DMF0021;")
    assert k > 0, "END PKG_DMF0021; 없음"
    rest = rest[:k] + f"END {new};" + rest[k + len("END PKG_DMF0021;"):]
    return ddl_of(first + "\n" + rest)


def run(cur, pkg, div, user, group, now, frm, to):
    rc, c2, c3 = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
    cur.execute(f"BEGIN SCM_MGR.{pkg}.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX(:1,'ALL','ALL','ALL','','','ALL',:2,:3,:4,:5,'ALL','ALL','','N',:6,'Weekly','',:7,:8,:9); END;",
                [div, frm, now, to, user, group, rc, c2, c3])
    r = rc.getvalue()
    cols = [d[0] for d in r.description]
    rows = [tuple("" if v is None else str(v) for v in x) for x in r.fetchall()]
    return cols, rows


CASES = [("40", "minyonglee1", "ADMIN"), ("81", "minyonglee1", "ADMIN"), ("81", "jaehun_cho", "jaehun_cho"),
         ("82", "minyonglee1", "ADMIN"), ("81_HD", "minyonglee1", "ADMIN")]
PM = {"KRW", "LOC", "USD"}


def verify(cur, now, frm, to):
    out_lines = []
    for order in (("ZT_DMF0021_O", "ZT_DMF0021_N"), ("ZT_DMF0021_N", "ZT_DMF0021_O")):
        for div, user, grp in CASES:
            out = {p: run(cur, p, div, user, grp, now, frm, to) for p in order}
            (co, ro), (cn, rn) = out["ZT_DMF0021_O"], out["ZT_DMF0021_N"]
            assert co == cn, "컬럼 다름"
            mi = co.index("MEASURE") if "MEASURE" in co else None
            fi = co.index("FROM_SITE_ID") if "FROM_SITE_ID" in co else None
            o, n = collections.Counter(ro), collections.Counter(rn)
            gone, new = o - n, n - o
            non_price = [r for r in list(gone.elements()) + list(new.elements()) if mi is None or r[mi] not in PM]
            site = lambda rows: collections.Counter((r[mi], r[fi] if fi is not None else '?') for r in rows if mi is not None and r[mi] in PM)
            out_lines.append(f"[{order[0][-1]}먼저] div={div} user={user} 행 O={len(ro)} N={len(rn)} 사라짐={sum(gone.values())} 생김={sum(new.values())} "
                             f"단가외변화={len(non_price)} MEASURE열={'Y' if mi is not None else 'N'} FROM_SITE열={'Y' if fi is not None else 'N'}")
            out_lines.append(f"    단가행 O={dict(site(ro))}")
            out_lines.append(f"    단가행 N={dict(site(rn))}")
    return out_lines


def main():
    apply = "--apply" in sys.argv
    u, p, d = conn_info()
    stamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
        body, ddl, st = fetch(cur, "PACKAGE BODY")
        spec, _, _ = fetch(cur, "PACKAGE")
        print(f"기준본 BODY LAST_DDL={ddl} STATUS={st} FETCHED={stamp}")
        tobe = build(body)
        asis_f = HERE / "PKG_DMF0021_BODY.ASIS.sql"
        if not asis_f.exists():
            asis_f.write_text(f"-- SOURCE-FRESH: {OWNER}.{NAME} PACKAGE BODY LAST_DDL={ddl} FETCHED={stamp} DB=ZIOUI1 (원복용 백업)\n" + ddl_of(body) + "/\n", encoding="utf-8")
        (HERE / "PKG_DMF0021_BODY.TOBE.sql").write_text(f"-- SOURCE-FRESH: {OWNER}.{NAME} PACKAGE BODY LAST_DDL={ddl} FETCHED={stamp} DB=ZIOUI1\n" + ddl_of(tobe) + "/\n", encoding="utf-8")
        print("변경 줄수 +", tobe.count("\n") - body.count("\n"))
        if not apply:
            cur.execute("SELECT TO_CHAR(TRUNC(SYSDATE,'IW'),'YYYYMMDD'), TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'IW'),-2),'YYYYMMDD'), TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'IW'),12),'YYYYMMDD') FROM DUAL")
            now, frm, to = cur.fetchone()
            try:
                for nm, b in (("ZT_DMF0021_O", body), ("ZT_DMF0021_N", tobe)):
                    for s in (renamed(spec, nm), renamed(b, nm)):
                        try:
                            cur.execute(s)
                        except oracledb.DatabaseError as e:
                            print("ZT 컴파일 경고", nm, e)
                    cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n ORDER BY 1", n=nm)
                    print(nm, cur.fetchall())
                    cur.execute("SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", n=nm)
                    for e in cur.fetchall():
                        print("  ERR", e)
                print(f"기간 from={frm} now={now} to={to}")
                for ln in verify(cur, now, frm, to):
                    print(ln)
                con.rollback()
            finally:
                for nm in ("ZT_DMF0021_O", "ZT_DMF0021_N"):
                    try:
                        cur.execute(f"DROP PACKAGE SCM_MGR.{nm}")
                    except oracledb.DatabaseError as e:
                        print("DROP", nm, e)
                cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME LIKE 'ZT\\_DMF0021\\_%' ESCAPE '\\'")
                print("ZT 잔존", cur.fetchone()[0])
            return
        now_b, ddl2, _ = fetch(cur, "PACKAGE BODY")
        saved = asis_f.read_text(encoding="utf-8").split("\n", 1)[1]
        assert ddl_of(now_b) + "/\n" == saved and ddl2 == ddl, "FRESH-GATE 실패 — 중단"
        cur.execute(ddl_of(tobe))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n ORDER BY SEQUENCE", o=OWNER, n=NAME)
        errs = cur.fetchall()
        after, ddl3, st3 = fetch(cur, "PACKAGE BODY")
        print(f"적용 후 LAST_DDL={ddl3} STATUS={st3} ALL_ERRORS={len(errs)} 적용본==DB원문 {after == tobe}")
        for e in errs:
            print("  ERR", e)


if __name__ == "__main__":
    main()
