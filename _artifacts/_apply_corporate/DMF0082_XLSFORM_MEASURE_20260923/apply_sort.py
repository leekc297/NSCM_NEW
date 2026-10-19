"""PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA — Excel Form 조회 정렬 신설 [E20260923-XLSFORMSORT]

사용자 지시 (2026-09-23): "DMF0082 EXCEL FORM 조회 시 SORT 가 안되어 있네요. SORT 적용되도록 해주세요."

현황 : AS-IS `DMF0020_GET_SALES_PRICE_TEMPLATE` 원문에 **ORDER BY 자체가 없다**(실측 2026-09-23, AS-IS live DB).
       TO-BE 이식본도 동일하게 없어 반환 순서가 비결정적이었다(GROUP BY/HASH 결과 순서).
       ⇒ 본 변경은 **AS-IS 파리티 이탈이 아니라 신설**(AS-IS 에 정렬 사양이 부재).

정렬 : 화면/양식 **표시 컬럼 순서**와 동일 — Div → Team → End Customer → Project Code → Model
         ORDER BY DIVISION_ID, DEPT_NAME NULLS LAST, END_CUSTOMER, PROJECT_CODE, ITEM_ID
       · Currency 는 MAX() 집계값이라 정렬 키에서 제외 (표시 순서상 Project 와 Model 사이지만 키로 부적합)
       · DEPT_NAME(Team) NULL 행(사내 실측 5건)은 **뒤로** — 명명된 팀이 먼저 보이도록
       · SELECT DISTINCT 구문이라 ORDER BY 는 select list 에 있는 컬럼만 가능 → 전부 충족(alias 사용)

범위 : P_DMF0082_GET_EXCEL_FORM_DATA 의 메인 커서(o_rc1) 1곳. 타 프로시저·타 커서 무변경.
usage: python apply_sort.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0082_BODY.PRE_SORT.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0082_BODY.SORT.sql"
TAG = "E20260923-XLSFORMSORT"
PROC_BEG = "PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA"
PROC_END = "END P_DMF0082_GET_EXCEL_FORM_DATA"

OLD = """    , A.ITEM_ID
    , A.SCM_SITE_ID
    , A.EDIT_YN
    ;
"""
NEW = """    , A.ITEM_ID
    , A.SCM_SITE_ID
    , A.EDIT_YN
    /* [""" + TAG + """] 정렬 신설 (사용자 지시 2026-09-23) — 양식 표시 컬럼 순서와 동일.
       AS-IS 원문(DMF0020_GET_SALES_PRICE_TEMPLATE)에는 ORDER BY 가 없어 순서가 비결정적이었다.
       Currency 는 MAX() 집계값이라 정렬 키 제외. Team 미지정(NULL) 행은 뒤로 보낸다. */
    ORDER BY DIVISION_ID, DEPT_NAME NULLS LAST, END_CUSTOMER, PROJECT_CODE, ITEM_ID
    ;
"""


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


def patch(src):
    b = src.index(PROC_BEG); e = src.index(PROC_END, b)
    seg = src[b:e]
    n = seg.count(OLD)
    assert n == 1, f"프로시저 구간 앵커 {n}회 (기대 1 — 메인 커서 종료부) — 중단"
    return src[:b] + seg.replace(OLD, NEW) + src[e:], n


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    if mode == "backup":
        src = fetch(cur)
        assert TAG not in src, "이미 반영"
        patched, n = patch(src)
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={cur.fetchone()[0]} FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\nSET DEFINE OFF\n"
        ASIS.parent.mkdir(parents=True, exist_ok=True); TOBE.parent.mkdir(parents=True, exist_ok=True)
        ASIS.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        TOBE.write_text(stamp + ddl(patched).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        print(f"backup ok — ORDER BY 삽입 {n}곳")
    elif mode == "apply":
        assert ddl(fetch(cur)).rstrip() == body_of(ASIS), "FRESH-GATE 실패: 백업 이후 DB 원문 변경 — 중단"
        cur.execute(body_of(TOBE))
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        print("status", cur.fetchone())
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=NAME, t=TYP)
        errs = cur.fetchall(); print("errors", len(errs))
        for e in errs[:10]: print("  ", e)
        print("applied == TOBE", ddl(fetch(cur)).rstrip() == body_of(TOBE))
    elif mode == "restore":
        cur.execute(body_of(ASIS))
        cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP); print("restored", cur.fetchone())


if __name__ == "__main__":
    main()
