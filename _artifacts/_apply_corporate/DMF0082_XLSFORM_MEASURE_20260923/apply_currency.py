"""PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA — CURRENCY 폴백 사문 정정 [E20260923-XLSFORMCURRENCY]

사용자 지시 (2026-09-23): "CURRENCY 가 비어 있는건 제외대상이라 문제를 해결해야 할 것 같습니다."

결함 : MSSQL `ISNULL(x,'')=''` 오역 (hook #119 oracle-null-sentinel-and-notnull-default)
         CASE WHEN NVL(SP.CURRENCY, '') = '' THEN SI.CURRENCY ELSE SP.CURRENCY END
       Oracle 은 빈문자=NULL 이라 `NVL(NULL,'')` = NULL 이고 `NULL = ''` 는 참이 아니다(UNKNOWN)
       → **항상 ELSE** 로 빠져 SCM_MST_SITE_ITEM 폴백이 한 번도 동작하지 않는다.
       진리값 실측: NVL(NULL,'')=''  → 'SP값(NULL) 그대로' / NVL(NULL,'-')='-' → 'SI로 폴백됨'

정정 : 센티널 '-' 로 비교 (hook #119 §센티널 통일). 표시·대입은 그대로.
         CASE WHEN NVL(SP.CURRENCY, '-') = '-' THEN SI.CURRENCY ELSE SP.CURRENCY END

영향 (사내 실측 2026-09-23, division 81, 합집합 기준):
       대상 14,611행 중 SP.CURRENCY NULL = 590행, 그 **590행 전부 SI.CURRENCY 폴백 가능** → 정정 후 잔존 빈칸 **0**
       양식 출력 Currency 빈칸: 21행 → 0행 (예상)
       Currency 는 업로드 6키(Div/Team/End Customer/Project Code/Currency/Model) 중 하나 —
       빈칸이면 그 행이 업로드에서 제외되거나 단가 저장이 어긋난다.

범위 : P_DMF0082_GET_EXCEL_FORM_DATA 의 2개 분기만. 패키지 전체 출현도 2곳(실측) = 타 프로시저 영향 없음.
usage: python apply_currency.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0082_BODY.PRE_CURRENCY.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0082_BODY.CURRENCY.sql"
TAG = "E20260923-XLSFORMCURRENCY"
PROC_BEG = "PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA"
PROC_END = "END P_DMF0082_GET_EXCEL_FORM_DATA"
OLD = "CASE WHEN NVL(SP.CURRENCY, '') = '' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY--CURRENCY가 없을 경우 SSPM의 값을 가져옴"
NEW = ("CASE WHEN NVL(SP.CURRENCY, '-') = '-' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY"
       "  /*[" + TAG + "] 센티널 '-' 정정 (hook #119). 구 `NVL(x,'')=''` 는 Oracle 에서 항상 거짓이라"
       " SSPM(SITE_ITEM) 폴백이 사문이었다 — 사내 실측 590행 폴백 실패, 양식 Currency 빈칸 21행."
       " Currency 는 업로드 6키 중 하나라 빈칸이면 그 행이 제외된다. */")


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
    assert n == 2, f"프로시저 구간 앵커 {n}회 (기대 2) — 중단"
    assert src.count(OLD) == 2, f"패키지 전체 앵커 {src.count(OLD)}회 (기대 2 — 전부 이 프로시저 안) — 중단"
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
        print(f"backup ok — 치환 {n}곳")
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
