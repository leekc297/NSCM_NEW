"""PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA — Excel Form 행 원천 measure 합집합 [E20260923-XLSFORMMEASURE]

사용자 지시 (2026-09-23): "MKT_FCST & RTF 의 조합" → **합집합 적용**.
  변경 : MEASURE = 'RTF_SYS_RP'  →  MEASURE IN ('RTF_SYS_RP','MKT_FCST')
  범위 : P_DMF0082_GET_EXCEL_FORM_DATA 의 2개 분기(DM_PLN_SALES_PLAN_C / _RESULT_C) 만. 타 프로시저 무변경.

근거 (사내 실측 2026-09-23, division 81):
  RTF_SYS_RP 단독 116행 / MKT_FCST 단독 144행 / **합집합 145행**
  ⚠ MKT 단독 교체 금지 — RTF ⊆ MKT 가 아니다(RTF 전용 키 1건 소실). 합집합만 손실 0(116 ⊂ 145).
  증가분 29건 품질: Currency NULL 0 / Team NULL 1.
  RTF_SCP·RTF_PR 추가는 116 그대로(키 포함관계) → 대안 아님.

배경 : 클라우드 최신 SP_W 컷오프에 RTF·금액 계열이 통째로 빠져(RTF_SYS_RP 8 / RTF_PR·SalesAmt_* 0) 양식이 1행.
       원장 DM_PLN_SALES_PLAN 은 정상(RTF_SYS_RP 6,152) → 근본 원인은 컷오프 타이밍. 본 변경은 **임시 우회**.
       클라우드 컷오프에 MKT_FCST 10,472행 존재 → 합집합이면 즉시 채워진다.
⚠ AS-IS 파리티 이탈: AS-IS DMF0020_GET_SALES_PRICE_TEMPLATE L105/L150 은 'RTF_SYS_RP' 단일.
   데이터 정상화 후 원복 검토 대상 — 원장 REQ 기록.

usage: python apply_measure.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0082_BODY.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0082_BODY.sql"
TAG = "E20260923-XLSFORMMEASURE"
PROC_BEG = "PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA"
PROC_END = "END P_DMF0082_GET_EXCEL_FORM_DATA"
OLD = "        AND SP.MEASURE = 'RTF_SYS_RP'\n"
NEW = ("        AND SP.MEASURE IN ('RTF_SYS_RP','MKT_FCST')   /*[" + TAG + "] 사용자 지시 2026-09-23 — 합집합.\n"
       "           사내 실측: RTF 단독 116 / MKT 단독 144 / 합집합 145 (116 ⊂ 145, 손실 0).\n"
       "           ⚠ MKT 단독 교체 금지 — RTF 전용 키 1건 소실. RTF_SCP·RTF_PR 은 키 포함관계라 무의미.\n"
       "           AS-IS(DMF0020 L105/L150)는 RTF_SYS_RP 단일 — 컷오프 데이터 정상화 후 원복 검토 대상. */\n")


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
    """P_DMF0082_GET_EXCEL_FORM_DATA 구간에서만 치환 — 앵커 2회(C / RESULT_C 분기) 정확 일치 의무."""
    b = src.index(PROC_BEG)
    e = src.index(PROC_END, b)
    seg = src[b:e]
    n = seg.count(OLD)
    assert n == 2, f"앵커 {n}회 (기대 2 — C/RESULT_C 분기) — 중단"
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
        print(f"backup ok — 치환 {n}곳 (P_DMF0082_GET_EXCEL_FORM_DATA 구간 한정)")
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
