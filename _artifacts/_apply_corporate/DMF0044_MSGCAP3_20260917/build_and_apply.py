# -*- coding: utf-8 -*-
"""
DMF0044 — 자릿수 초과 오류 메시지 상세 상한 10건 → **3건**.

사용자 요청(2026-09-17): 오류 건수가 많으면 POPUP 높이가 과도해진다.
  "3건 까지만 상세하게 보여주고, 그이외의 경우에는 '이외 3건 발생' 과 같이 건수로"

대상 : SCM_MGR.PKG_DMF0044 PACKAGE BODY — FUNCTION FN_CHK_QTY_DIGITS (L87~129)
       단일 포맷 소스. 호출부 2곳(L4057 / L5046, 둘 다 FN_CHK_QTY_DIGITS(20))이 이 함수를 공유한다.
       FE(sales-reports / etc-sales-reports)는 SP 메시지를 setAlert 로 표시만 하며 자체 집계 없음.

상세 1건 = 5줄(Model/Measure/기간/부서/입력값) + 건간 빈 줄 1 →
  10건 = 약 59줄 → **3건 = 약 17줄** 로 축소.

# FRESH-GATE : 추출·적용 직전 ALL_SOURCE 재조회 + 원문 동일성 assert (hook #152)
"""
import sys, pathlib, datetime, re

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

OWNER, NAME, TYPE = "SCM_MGR", "PKG_DMF0044", "PACKAGE BODY"
OUT = pathlib.Path(__file__).parent

# (기존원문, 변경본) — 전부 정확 일치해야 진행
REPL = [
    ("      · 메시지 폭주 방지로 상세는 최대 10건까지, 나머지는 건수만 표기. */",
     "      · 메시지 폭주 방지로 상세는 최대 3건까지, 나머지는 건수만 표기. */"),
    ("                    IF V_CNT <= 10 THEN",
     "                    IF V_CNT <= 3 THEN"),
    ("               || CASE WHEN V_CNT > 10 THEN CHR(10) || CHR(10) || '... 외 ' || (V_CNT - 10) || '건' END;",
     "               || CASE WHEN V_CNT > 3 THEN CHR(10) || CHR(10) || '... 외 ' || (V_CNT - 3) || '건' END;"),
]
MARK = ("        --[E20260917-DMF0044MSGCAP3] 상세 상한 10 -> 3 (사용자 요청 2026-09-17 — "
        "오류 다건 시 POPUP 높이 과대). 나머지는 '... 외 N건' 으로 건수만.")


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
    if not m:
        raise SystemExit("접속정보 파싱 실패")
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


def main():
    apply_mode = "--apply" in sys.argv
    with conn() as db:
        cur = db.cursor()
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                    "WHERE owner=:o AND object_name=:n AND object_type=:t", o=OWNER, n=NAME, t=TYPE)
        ddl_time, status = cur.fetchone()
        cur.execute("SELECT text FROM all_source WHERE owner=:o AND name=:n AND type=:t ORDER BY line",
                    o=OWNER, n=NAME, t=TYPE)
        lines = [(r[0] or "").rstrip("\n").rstrip("\r") for r in cur.fetchall()]
        fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        print(f"[FRESH] LAST_DDL={ddl_time} STATUS={status} LINES={len(lines)} FETCHED={fetched}")

        if any("[E20260917-DMF0044MSGCAP3]" in ln for ln in lines):
            raise SystemExit("이미 적용됨 — 중단")

        for old, new in REPL:
            idxs = [i for i, ln in enumerate(lines) if ln == old]
            if len(idxs) != 1:
                raise SystemExit(f"FRESH-GATE FAIL: 앵커 {len(idxs)}건 (기대 1)\n  [{old}]")
            lines[idxs[0]] = new
            print(f"[REPL] L{idxs[0]+1}  10 -> 3")

        # 변경 근거 주석을 함수 선언 직후에 1줄 추가
        fi = next(i for i, ln in enumerate(lines) if ln.strip().startswith("FUNCTION FN_CHK_QTY_DIGITS"))
        lines.insert(fi + 1, MARK)
        print(f"[MARK] L{fi+2} 주석 삽입")

        body = "\n".join(lines) + "\n"
        if not body.startswith("PACKAGE"):
            raise SystemExit("본문이 PACKAGE 로 시작하지 않음")
        ddl = "CREATE OR REPLACE " + body
        stamp = (f"-- SOURCE-FRESH: {OWNER}.{NAME} {TYPE} LAST_DDL={ddl_time} "
                 f"FETCHED={fetched} DB=ZIOUI1\n")
        f = OUT / "01_PKG_DMF0044_BODY.sql"
        f.write_text(stamp + ddl + "/\n", encoding="utf-8")
        print(f"[BUILD] {len(lines)} lines -> {f}")

        if not apply_mode:
            print("[DRY-RUN] --apply 미지정")
            return

        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                    "WHERE owner=:o AND object_name=:n AND object_type=:t", o=OWNER, n=NAME, t=TYPE)
        if cur.fetchone()[0] != ddl_time:
            raise SystemExit("FRESH-GATE FAIL: 적용 직전 LAST_DDL 변동")
        cur.execute(ddl)
        db.commit()
        cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                    "WHERE owner=:o AND object_name=:n AND object_type=:t", o=OWNER, n=NAME, t=TYPE)
        print("[APPLY]", cur.fetchone())
        cur.execute("SELECT line, position, text FROM all_errors WHERE owner=:o AND name=:n AND type=:t",
                    o=OWNER, n=NAME, t=TYPE)
        errs = cur.fetchall()
        print(f"[ERRORS] {len(errs)}건")
        for e in errs[:10]:
            print("   ", e)


if __name__ == "__main__":
    main()
