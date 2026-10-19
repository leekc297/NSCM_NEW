"""PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD — 동적(기간) 구간 검증 정책 개정 [E20260923-DMF0014BLANK]

사용자 지시 (2026-09-23, 3회에 걸쳐 확정) :
  1) "동적 COLUMN 구간에 숫자가 아니면 숫자 오류, 그리고 전체 동적 COLUMN 영역에 값이 없으면 숫자 오류가 아닙니다."
  2) "동적 구간에 값이 없는것은 오류가 아닙니다."
  3) "값이 없을 때는 Please Input QTY 대상이 아닙니다. 숫자가 아닌 문자인 경우에 이 메세지가 나오면 됩니다."

  ⇒ 확정 정책
       · 빈칸(값 없음)        → **오류 아님** (메시지 없음)
       · 숫자가 아닌 문자     → **'Please Input QTY [YYYYMMDD: 값]'**
       · 소수점(정수만 허용)  → 'Invalid Decimal [YYYYMMDD: 값]'  (E20230119-000186 정수 정책 — 지시 밖, 유지)

  ⚠ 직전 회차([E20260923-DMF0014VALMSG], 같은 날 오전)의 정책을 **사용자가 뒤집은** 것이다.
     그때는 "동적 구간에 값이 없으면 'Please Insert QYT'" 였다. 이번 지시가 최신이며 그 분기를 폐기한다.
     문구 'Please Input QTY' 는 **빈값용 → 비숫자용으로 이동**한다(사용자 3번 문장).
     이에 따라 구 'Invalid Numeric [...]' 문구는 폐기된다(같은 조건을 이 문구가 대신한다).

변경 3곳 (전부 P_DMF0014_CUST_FCST_EXCEL_UPLOAD 내부, 실코드 기준) :
  ① 빈값 분기 제거
       구: CASE WHEN TRIM(V.VALUE) IS NULL
                THEN CASE WHEN EXISTS (DM_MST_CUSTOMER_FCST … VALID_YN='Y' …)
                          THEN 'Please Input QTY [' || TRIM(H.HDR) || ']' END
       신: CASE WHEN TRIM(V.VALUE) IS NULL THEN NULL      -- 빈칸은 검사 대상 아님
     · 부수효과: 행당 기간칸 수만큼 돌던 DM_MST_CUSTOMER_FCST/SCM_MST_DIVISION 상관 EXISTS 가 사라져
       검증 비용이 줄어든다(결과 불변 — 이 분기는 이제 메시지를 만들지 않는다).
  ② 비숫자 분기 문구  'Invalid Numeric ['  →  'Please Input QTY ['
  ③ 로그 문구        '… Invalid Numeric / Invalid Decimal / Please Input QTY …'
                     →  '… Please Input QTY / Invalid Decimal …'

안전성 :
  MERGE USING 은 `WHERE P.MSG IS NOT NULL` 로 메시지 없는 셀을 걸러낸 뒤 UPLOAD_ID 로 GROUP BY 한다(실측).
  따라서 빈칸만 있는 행은 X 집합에 아예 나타나지 않아 **ERROR 로 마킹되지 않는다**(= 사용자 요구 충족).
  타 검증(Division/Sales Site/Measure/Bucket 등)은 이 블록 밖이라 무영향.

범위 : 위 3곳. 타 프로시저(P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM 등)에는 해당 블록이 없다(실측).
usage: python apply_blank.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0014", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0014_BODY.PRE_BLANK.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0014_BODY.BLANK.sql"
TAG = "E20260923-DMF0014BLANK"
PROC_BEG = "PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD"
PROC_END = "END P_DMF0014_CUST_FCST_EXCEL_UPLOAD"

BLANK_BEG = "CASE WHEN TRIM(V.VALUE) IS NULL"
NUMERIC_WHEN = "WHEN NOT REGEXP_LIKE(TRIM(V.VALUE)"
OLD_NUM_MSG = "THEN 'Invalid Numeric [' || TRIM(H.HDR) || ': ' || V.VALUE || ']'"
NEW_NUM_MSG = "THEN 'Please Input QTY [' || TRIM(H.HDR) || ': ' || V.VALUE || ']'"
OLD_LOG = "'########## ERROR Period cells: Invalid Numeric / Invalid Decimal / Please Input QTY ##########'"
NEW_LOG = "'########## ERROR Period cells: Please Input QTY / Invalid Decimal ##########'"

NEW_BLANK = (
    "CASE WHEN TRIM(V.VALUE) IS NULL THEN NULL   /*[" + TAG + "] 빈칸 = 오류 아님 (사용자 지시 2026-09-23).\n"
    "                                                        직전 회차의 'Please Input QTY [기간]' 빈값 검증을 폐기했다.\n"
    "                                                        그 문구는 아래 비숫자 분기로 이동한다. */\n"
    "                                                 "
)

# 주석 블록(정책 서술) 동기화 — 실코드와 어긋나면 다음 사람이 옛 정책을 따른다
OLD_CMT = ("                   ① 숫자 아닌 값          → 'Invalid Numeric [YYYYMMDD: 값]'\n"
           "                   ② 소수점(정수만 허용)    → 'Invalid Decimal [YYYYMMDD: 값]'   (E20230119-000186 정수 정책 유지)\n"
           "                   ③ 빈값                  → 'Please Input QTY [YYYYMMDD]'      (사용자 지정 문구)\n"
           "                      - 회색(입력불가) 주차 = Customer Fcst Master VALID_YN='Y' 밖 → GRAYZERO 정책상 0 적재이므로 빈값 검사 제외\n"
           "                      - 판정식은 적재부 GRAYZERO CASE 와 동일 술어 (기준이 갈라지면 화면 색과 어긋난다)\n")
# ⚠ 이 주석은 이미 /* … */ 블록 **안**이다 — 안에 또 /* … */ 를 쓰면 Oracle 은 중첩을 지원하지 않아
#   안쪽 */ 가 바깥 주석을 조기 종료시키고 뒤 문장이 코드로 해석된다(PLS-00103 실사고 2026-09-24).
#   따라서 블록 주석 안에서는 [TAG] 대괄호 표기만 쓴다.
NEW_CMT = ("                   ① 숫자 아닌 값          → 'Please Input QTY [YYYYMMDD: 값]'   [" + TAG + "] 문구 이동\n"
           "                   ② 소수점(정수만 허용)    → 'Invalid Decimal [YYYYMMDD: 값]'   (E20230119-000186 정수 정책 유지)\n"
           "                   ③ 빈값                  → **검사하지 않는다** (오류 아님 — 사용자 지시 2026-09-23)\n"
           "                      - 구 정책(빈값 → 'Please Input QTY [기간]')은 폐기. 그에 딸린\n"
           "                        DM_MST_CUSTOMER_FCST VALID_YN='Y' 상관 EXISTS 도 함께 제거했다.\n")


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

    # ① 빈값 분기 — 'CASE WHEN TRIM(V.VALUE) IS NULL' ~ 'WHEN NOT REGEXP_LIKE(TRIM(V.VALUE)' 직전
    s1 = seg.index(BLANK_BEG)
    e1 = seg.index(NUMERIC_WHEN, s1)
    old_blank = seg[s1:e1]
    assert old_blank.count("DM_MST_CUSTOMER_FCST") == 1, "빈값 분기 구간 이상(EXISTS 1개 기대)"
    assert old_blank.count("'Please Input QTY ['") == 1, "빈값 분기에 Please Input QTY 1곳 기대"
    assert seg.count(BLANK_BEG) == 1, f"빈값 분기 앵커 {seg.count(BLANK_BEG)}회 (기대 1)"
    seg2 = seg[:s1] + NEW_BLANK + seg[e1:]

    # ② 비숫자 문구
    assert seg2.count(OLD_NUM_MSG) == 1, f"비숫자 문구 앵커 {seg2.count(OLD_NUM_MSG)}회 (기대 1)"
    seg2 = seg2.replace(OLD_NUM_MSG, NEW_NUM_MSG)

    # ③ 로그 문구
    assert seg2.count(OLD_LOG) == 1, f"로그 문구 앵커 {seg2.count(OLD_LOG)}회 (기대 1)"
    seg2 = seg2.replace(OLD_LOG, NEW_LOG)

    # ④ 정책 주석
    assert seg2.count(OLD_CMT) == 1, f"주석 앵커 {seg2.count(OLD_CMT)}회 (기대 1)"
    seg2 = seg2.replace(OLD_CMT, NEW_CMT)

    out = src[:b] + seg2 + src[e:]

    # 결과 가드
    assert "'Invalid Numeric ['" not in out, "구 비숫자 문구 잔존"
    assert out.count("'Please Input QTY ['") == 1, \
        f"Please Input QTY 실코드 {out.count(chr(39)+'Please Input QTY ['+chr(39))}곳 (기대 1 — 비숫자 분기)"
    assert out.count("'Invalid Decimal ['") == 1, "Invalid Decimal 이 변경됨"
    # 빈값용 상관 EXISTS 1개만 사라졌는지 — 같은 조인이 적재부(GRAYZERO)에도 있으므로 0 이 아니라 '-1' 로 본다
    nb = out.index(PROC_BEG); ne = out.index(PROC_END, nb)
    before = seg.count("DM_MST_CUSTOMER_FCST M, SCM_MST_DIVISION MD")
    after = out[nb:ne].count("DM_MST_CUSTOMER_FCST M, SCM_MST_DIVISION MD")
    assert after == before - 1, f"빈값 EXISTS 제거 수 이상 (before={before} after={after})"
    return out, 4


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    if mode == "backup":
        src = fetch(cur)
        assert TAG not in src, "이미 반영"
        patched, n = patch(src)
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        stamp = (f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={cur.fetchone()[0]} "
                 f"FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\n"
                 f"-- [{TAG}] 동적 구간: 빈칸=오류아님 / 비숫자='Please Input QTY [기간: 값]'\n"
                 "SET DEFINE OFF\nSET SQLBLANKLINES ON\n")
        ASIS.parent.mkdir(parents=True, exist_ok=True); TOBE.parent.mkdir(parents=True, exist_ok=True)
        ASIS.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        TOBE.write_text(stamp + ddl(patched).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        print(f"backup ok — 치환 {n}곳 (빈값분기/비숫자문구/로그/주석) · 구 'Invalid Numeric [' 잔존 0")
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
