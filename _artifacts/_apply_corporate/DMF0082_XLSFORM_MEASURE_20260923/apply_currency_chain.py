"""PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA — CURRENCY 폴백 체인 확장 [E20260923-XLSFORMCURCHAIN]

사용자 지시 (2026-09-23):
  "AS-IS 에는 CURRENCY 가 존재하지 않는 ROW 가 없습니다. DMF0082 EXCEL FORM 조회 시
   CURRENCY 가 존재하지 않는 ROW가 없도록 CURRENCY 를 찾아서 넣어주세요."

AS-IS 실측 (live MSSQL, 2026-09-23):
  AS-IS `DMF0020_GET_SALES_PRICE_TEMPLATE` L74/L119 = `CASE WHEN ISNULL(SP.CURRENCY,'')='' THEN SI.CURRENCY ELSE SP.CURRENCY END`
  → **2단(판매계획 → SSPM/SITE_ITEM)** 이 전부. MSSQL 에서는 정상 동작하므로 AS-IS 는 빈칸이 안 난다.
  선행 조치 [E20260923-XLSFORMCURRENCY] 로 TO-BE 도 이 2단을 복원했다(빈칸 21→0).
  본 조치는 그 위에 **데이터 변동에도 빈칸 0 을 보장**하는 확장 체인을 얹는다.

폴백 체인 (COALESCE 좌→우 단락평가 — 앞 단계가 채우면 뒤 서브쿼리는 실행되지 않는다):
  L1 SP.CURRENCY                     판매계획 실적 통화 (사내 실측 14,021/14,611 커버)
  L2 SI.CURRENCY                     SSPM SITE_ITEM 4키 — **AS-IS 동일 단계** (나머지 590 전부 커버)
  L3 SCM_MST_FUTURE_PRICE            같은 키의 기존 단가 통화 (이 화면의 저장 원장, 키 194 중 187 커버)
  L4 SCM_MST_SITE_ITEM 3키           프로젝트 무시(div,site,item) — 4키 행만 결측인 경우 (191/194)
  L5 MP.CURRENCY                     프로젝트 기본통화 — **194/194 전수 커버** (이미 조인된 MP, 비용 0)
  · 전 단계 `NULLIF(TRIM(x),'')` — 공백만 든 값도 결측으로 본다

성능 : L1·L2 가 현 데이터 100% 를 채우므로 L3~L5 서브쿼리는 실행되지 않는다(COALESCE 단락평가).
       인덱스 실측 — FUTURE_PRICE `PK(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,…)` / SITE_ITEM `IDX04(DIVISION_ID,SCM_SITE_ID,ITEM_ID)`.

범위 : P_DMF0082_GET_EXCEL_FORM_DATA 의 2개 분기만(패키지 전체 출현도 2곳 실측).
usage: python apply_currency_chain.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0082_BODY.PRE_CURCHAIN.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0082_BODY.CURCHAIN.sql"
TAG = "E20260923-XLSFORMCURCHAIN"
PROC_BEG = "PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA"
PROC_END = "END P_DMF0082_GET_EXCEL_FORM_DATA"

OLD = ("        , CASE WHEN NVL(SP.CURRENCY, '-') = '-' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY"
       "  /*[E20260923-XLSFORMCURRENCY] 센티널 '-' 정정 (hook #119). 구 `NVL(x,'')=''` 는 Oracle 에서 항상 거짓이라"
       " SSPM(SITE_ITEM) 폴백이 사문이었다 — 사내 실측 590행 폴백 실패, 양식 Currency 빈칸 21행."
       " Currency 는 업로드 6키 중 하나라 빈칸이면 그 행이 제외된다. */\n")

NEW = """        /* [""" + TAG + """] CURRENCY 폴백 체인 (사용자 지시 2026-09-23 — "CURRENCY 가 존재하지 않는 ROW 가 없도록").
           AS-IS(DMF0020 L74/L119)는 L1→L2 2단뿐이고 MSSQL 에서는 그것으로 빈칸이 안 난다.
           TO-BE 는 [E20260923-XLSFORMCURRENCY] 로 2단을 복원한 위에, 데이터 변동에도 빈칸 0 을 보장하도록 L3~L5 를 덧댄다.
           COALESCE 는 좌→우 단락평가라 앞 단계가 채우면 뒤 서브쿼리는 실행되지 않는다(현 데이터는 L2 에서 100% 종료). */
        , COALESCE( NULLIF(TRIM(SP.CURRENCY), '')                                    /* L1 판매계획 실적 통화 */
                  , NULLIF(TRIM(SI.CURRENCY), '')                                    /* L2 SSPM SITE_ITEM 4키 — AS-IS 동일 단계 */
                  , (SELECT MAX(FP.CURRENCY) FROM SCM_MST_FUTURE_PRICE FP            /* L3 같은 키의 기존 단가 통화(저장 원장) */
                      WHERE FP.DIVISION_ID  = SP.DIVISION_ID
                        AND FP.PROJECT_CODE = SP.PROJECT_CODE
                        AND FP.SCM_SITE_ID  = SP.SCM_SITE_ID
                        AND FP.ITEM_ID      = SP.ITEM_ID)
                  , (SELECT MAX(S2.CURRENCY) FROM SCM_MST_SITE_ITEM S2                /* L4 SITE_ITEM 3키(프로젝트 무시) */
                      WHERE S2.DIVISION_ID = SP.DIVISION_ID
                        AND S2.SCM_SITE_ID = SP.SCM_SITE_ID
                        AND S2.ITEM_ID     = SP.ITEM_ID
                        AND S2.VALID_YN    = 'Y')
                  , NULLIF(TRIM(MP.CURRENCY), '')                                     /* L5 프로젝트 기본통화 — 키 194/194 전수 커버 */
                  ) AS CURRENCY
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
    assert n == 2, f"프로시저 구간 앵커 {n}회 (기대 2) — 중단"
    assert src.count(OLD) == 2, f"패키지 전체 앵커 {src.count(OLD)}회 (기대 2) — 중단"
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
        print(f"backup ok — 체인 치환 {n}곳")
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
