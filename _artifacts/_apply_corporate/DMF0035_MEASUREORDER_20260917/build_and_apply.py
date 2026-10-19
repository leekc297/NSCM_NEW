# -*- coding: utf-8 -*-
"""
DMF0035 — MEASURE POPUP 설정 순서가 조회에 반영되지 않는 결함 정정.

증상(사용자 신고 2026-09-17): 조회 시 MEASURE POPUP 에서 설정한 메저 순서대로 나오지 않는다.

원인:
  최종 동적 SQL 의 정렬은 L3707 `' ORDER BY ' || V_ORDER_LIST` 단 1곳이다.
  L3082 `V_ORDER_LIST := REPLACE(V_ORDER_LIST,'MEASURE','SORT_ORDER_NO')` 가
  메저 축을 **팝업 순서(GT_DM35_SEL_MEASURE.SORT_ORDER_NO)** 로 바꾸는 설계인데,
  'C'(컬럼) 개인화를 가진 사용자는 L2988 `U.COLUMN_NAME NOT IN ('MEASURE')` 로 MEASURE 가
  목록에서 빠지고, UNION ALL 재주입 arm 은 VISIBLE_FLAG='N' 조건이라 MEASURE(VISIBLE='Y')를
  되살리지 못한다. 그 상태를 보정하는 L3063 MEASURECOL 가드는 **V_COL_LIST 에만** MEASURE 를
  넣고 V_ORDER_LIST 에는 넣지 않아, L3082 REPLACE 가 치환 대상을 못 찾고 무동작 →
  ORDER BY 에 SORT_ORDER_NO 가 아예 없다 → 메저 순서 비결정.

  · 개인화 없는 사용자: SHEET_COLUMNS(DEFAULT_FLAG='Y') 경로로 MEASURE 가 양쪽에 들어와 정상.
  · 실측: DMF0035 'C' 개인화 보유 6계정 전원 해당(jaehun_cho/jiwon.park/k0101/minyonglee1/qjastar/wonqthanq)

정정:
  VERSION_NO 가드(L3073~3077, [E20260916-VERCOL])와 **동형**으로 맞춘다 —
  V_COL_LIST 뿐 아니라 V_ORDER_LIST 에도 'MEASURE ASC' 를 보강한다.
  이후 L3082 REPLACE 가 이를 'SORT_ORDER_NO ASC' 로 치환한다.
  말미 추가 위치는 개인화 없는 경로와 동일하다(SHEET_COLUMNS MEASURE SORT_ORDER_NO=999 = 최후미).

# FRESH-GATE : 추출·적용 직전 ALL_SOURCE 재조회 + 원문 동일성 assert (hook #152)
"""
import sys, pathlib, datetime, re

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

OWNER, NAME, TYPE = "SCM_MGR", "PKG_DMF0035", "PACKAGE BODY"
OUT = pathlib.Path(__file__).parent

OLD = [
    "    IF INSTR(',' || REPLACE(REPLACE(V_COL_LIST, ' ', ''), CHR(10), '') || ',', ',MEASURE,') = 0 THEN",
    "        V_COL_LIST := V_COL_LIST || ',MEASURE';",
    "    END IF;",
]
NEW = [
    "    IF INSTR(',' || REPLACE(REPLACE(V_COL_LIST, ' ', ''), CHR(10), '') || ',', ',MEASURE,') = 0 THEN",
    "        V_COL_LIST := V_COL_LIST || ',MEASURE';",
    "        --[E20260917-MEASUREORDER] 정렬축도 함께 보강 (사용자 신고 2026-09-17 — MEASURE POPUP 순서 미반영).",
    "        --  아래 [E20260916-VERCOL] VERSION_NO 가드와 **동형**이다. 종전에는 V_COL_LIST 에만 넣어",
    "        --  L3082 `REPLACE(V_ORDER_LIST,'MEASURE','SORT_ORDER_NO')` 가 치환 대상을 못 찾고 무동작 →",
    "        --  ORDER BY 에 SORT_ORDER_NO 가 빠져 메저 순서가 비결정이었다('C' 개인화 사용자 한정 증상).",
    "        --  위치(말미)는 개인화 없는 경로와 동일하다 — SHEET_COLUMNS MEASURE SORT_ORDER_NO=999 = 최후미.",
    "        V_ORDER_LIST := CASE WHEN V_ORDER_LIST IS NULL OR LENGTH(TRIM(V_ORDER_LIST)) = 0",
    "                             THEN 'MEASURE ASC' ELSE V_ORDER_LIST || ',MEASURE ASC' END;",
    "    END IF;",
]


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

        if any("[E20260917-MEASUREORDER]" in ln for ln in lines):
            raise SystemExit("이미 적용됨 — 중단")

        # 3행 연속 블록을 유일하게 찾는다
        hits = [i for i in range(len(lines) - 2) if lines[i:i + 3] == OLD]
        if len(hits) != 1:
            raise SystemExit(f"FRESH-GATE FAIL: MEASURE 가드 블록 {len(hits)}건 (기대 1)")
        i = hits[0]
        print(f"[ANCHOR] MEASURE 가드 L{i+1}~L{i+3}")

        # 치환 직후 L3082 REPLACE 규약이 실제로 존재하는지도 확인 (의존 전제)
        if not any("REPLACE(V_ORDER_LIST, 'MEASURE',    'SORT_ORDER_NO')" in ln.replace("  ", " ")
                   or ("REPLACE(V_ORDER_LIST" in ln and "'MEASURE'" in ln and "SORT_ORDER_NO" in ln)
                   for ln in lines):
            raise SystemExit("FRESH-GATE FAIL: V_ORDER_LIST MEASURE→SORT_ORDER_NO REPLACE 미발견")

        lines[i:i + 3] = NEW
        print(f"[BUILD] +{len(NEW) - 3} lines")

        body = "\n".join(lines) + "\n"
        if not body.startswith("PACKAGE"):
            raise SystemExit("본문이 PACKAGE 로 시작하지 않음")
        ddl = "CREATE OR REPLACE " + body
        stamp = (f"-- SOURCE-FRESH: {OWNER}.{NAME} {TYPE} LAST_DDL={ddl_time} "
                 f"FETCHED={fetched} DB=ZIOUI1\n")
        f = OUT / "01_PKG_DMF0035_BODY.sql"
        f.write_text(stamp + ddl + "/\n", encoding="utf-8")
        print(f"[FILE] {len(lines)} lines -> {f}")

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
