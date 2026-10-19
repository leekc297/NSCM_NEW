"""PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA — 임시 measure 합집합 **해제** [E20260923-XLSFORMMEASUREOFF]

사용자 지시 (2026-09-23):
  "DMF0082 EXCEL FORM 조회 시 RTF_SYS_RP 만 사용하던 AS-IS 의 데이터가 모자라 MKT_FCST 을 추가하였던
   임시 조치를 해제해주세요"

해제 : MEASURE IN ('RTF_SYS_RP','MKT_FCST')  →  MEASURE = 'RTF_SYS_RP'   (AS-IS 파리티 복귀)
       AS-IS `DMF0020_GET_SALES_PRICE_TEMPLATE` L105/L150 = `AND SP.MEASURE = 'RTF_SYS_RP'` 단일(실측).

해제 근거 (진단 확정 2026-09-23):
  건수 부족의 원인은 measure 가 아니라 **컷오프 스냅샷 결함**이었다.
    · 원장 DM_PLN_SALES_PLAN 은 정상 — RTF_SYS_RP 6,152행 (RTF_PR 도 6,152)
    · 컷오프 SP_W_20260923_V001(13:12) 은 RTF_PR 0 / SalesAmt_* 각 0 / RTF_SYS_RP 8 — **RTF·금액 계열 5종 통째 누락**
    · 원장 6,152행 전부 LAST_UPDATE_DATE = 13:12 이고 컷오프 생성도 13:12 → 컷오프가 금액배치 전/중에 원장을 읽음
  ⇒ measure 확장은 증상 완화였고, 근본은 컷오프 재수행/배치 순서 정상화.

⚠ **유지되는 변경 3종** (이번 해제 대상 아님):
    [E20260923-XLSFORMCURRENCY]  CURRENCY 폴백 센티널 정정 (AS-IS 2단 복원)
    [E20260923-XLSFORMSORT]      조회 정렬 신설
    [E20260923-XLSFORMCURCHAIN]  CURRENCY 폴백 체인 L1~L5 (빈칸 0 보증)
  → 누적 백업본 restore 로는 이 3종까지 함께 날아가므로, **현재 원문에 역패치**한다.

재적용이 필요하면 `apply_measure.py` 참조 (앵커가 바뀌었으므로 OLD 문자열 갱신 필요).
usage: python revert_measure.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0082_BODY.PRE_MEASUREOFF.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0082_BODY.MEASUREOFF.sql"
TAG = "E20260923-XLSFORMMEASUREOFF"
PROC_BEG = "PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA"
PROC_END = "END P_DMF0082_GET_EXCEL_FORM_DATA"

OLD = """        AND SP.MEASURE IN ('RTF_SYS_RP','MKT_FCST')   /*[E20260923-XLSFORMMEASURE] 사용자 지시 2026-09-23 — 합집합.
           사내 실측: RTF 단독 116 / MKT 단독 144 / 합집합 145 (116 ⊂ 145, 손실 0).
           ⚠ MKT 단독 교체 금지 — RTF 전용 키 1건 소실. RTF_SCP·RTF_PR 은 키 포함관계라 무의미.
           AS-IS(DMF0020 L105/L150)는 RTF_SYS_RP 단일 — 컷오프 데이터 정상화 후 원복 검토 대상. */
"""

NEW = """        AND SP.MEASURE = 'RTF_SYS_RP'   /*[""" + TAG + """] 임시 합집합(MKT_FCST 추가) 해제 — AS-IS 파리티 복귀 (사용자 지시 2026-09-23).
           AS-IS DMF0020_GET_SALES_PRICE_TEMPLATE L105/L150 과 동일한 단일 measure.
           건수 부족의 원인은 measure 가 아니라 컷오프 스냅샷 결함이었다 — 원장 RTF_SYS_RP 6,152행 정상인데
           컷오프 SP_W_20260923_V001(13:12)은 RTF_PR 0 / SalesAmt_* 0 / RTF_SYS_RP 8 로 RTF·금액 계열 5종이 통째 누락
           (원장 6,152행 전부 13:12 갱신 = 컷오프가 금액배치 전/중에 읽음). 근본 해소 = 컷오프 재수행. */
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
    out = src[:b] + seg.replace(OLD, NEW) + src[e:]
    # 유지 대상 3종이 살아있는지 확인
    for keep in ("E20260923-XLSFORMCURRENCY", "E20260923-XLSFORMSORT", "E20260923-XLSFORMCURCHAIN"):
        assert keep in out, f"유지 대상 마커 소실: {keep}"
    assert "E20260923-XLSFORMMEASURE]" not in out, "구 합집합 마커 잔존"
    return out, n


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    if mode == "backup":
        src = fetch(cur)
        assert TAG not in src, "이미 해제됨"
        patched, n = patch(src)
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={cur.fetchone()[0]} FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\nSET DEFINE OFF\n"
        ASIS.parent.mkdir(parents=True, exist_ok=True); TOBE.parent.mkdir(parents=True, exist_ok=True)
        ASIS.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        TOBE.write_text(stamp + ddl(patched).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        print(f"backup ok — 해제 치환 {n}곳 (유지 마커 3종 확인 · 구 합집합 마커 잔존 0)")
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
        cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP); print("restored(합집합 재적용)", cur.fetchone())


if __name__ == "__main__":
    main()
