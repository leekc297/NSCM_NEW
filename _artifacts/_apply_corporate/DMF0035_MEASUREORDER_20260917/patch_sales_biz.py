# -*- coding: utf-8 -*-
"""
DMF0035 SALES/BIZ 타입 — MEASURE 순서 미반영 정정 (MKT 와 동일 결함군).

배선 실측(SCM_ADM_MNU_BTN_MPG_M × SCM_ADM_API_M):
  mktFcstWaterfall   -> PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL          (2026-09-17 정정 완료)
  salesPlanWaterfall -> PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL <- 본 패치
  bizPlanWaterfall   -> PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL   <- 본 패치(예방)

원인(공통 구조): 최종 정렬 `ORDER BY v_OrderList` 1곳이고,
  `v_OrderList := REPLACE(v_OrderList,'MEASURE','SORT_ORDER_NO,MEASURE')` 가 메저 축을
  팝업 순서(GT_*_SEL_MEASURE.SORT_ORDER_NO)로 바꾸는 설계다.
  그런데 MEASURECOL 가드는 **v_ColList 에만** MEASURE 를 보강해, 목록에 MEASURE 가 없으면
  REPLACE 가 무동작 -> ORDER BY 에 SORT_ORDER_NO 부재 -> 메저 순서 비결정.

실측 판정(PROGRAM_ID='DMF0035'):
  SALES 'Sales Plan Waterfall' MEASURE = DEFAULT_FLAG '-' / VISIBLE 'Y'
    -> 개인화 없음 분기 조건(DEFAULT='Y' OR (VISIBLE='N' AND DEFAULT 공란))에 **둘 다 불일치**
    -> 컬럼 19개에 MEASURE 미포함 = **현행 결함**
  BIZ   'Biz Plan Waterfall'   MEASURE = DEFAULT_FLAG 'Y' -> 포함 = 현행 정상(가드는 예방 목적)

정정: MEASURE 가드를 v_OrderList 까지 보강(= PKG_DMF0035 [E20260917-MEASUREORDER] 와 동형).

# FRESH-GATE : 추출·적용 직전 ALL_SOURCE 재조회 + 원문 동일성 assert (hook #152)
"""
import sys, pathlib, datetime, re

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

OWNER, TYPE = "SCM_MGR", "PACKAGE BODY"
OUT = pathlib.Path(__file__).parent
TARGETS = [("PKG_DMF0022", "02"), ("PKG_DMF0051", "03")]

GUARD_IF = "IF INSTR(',' || REPLACE(REPLACE(v_ColList, ' ', ''), CHR(10), '') || ',', ',MEASURE,') = 0 THEN"
GUARD_ADD = "v_ColList := v_ColList || ',MEASURE';"
GUARD_END = "END IF;"


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
    if not m:
        raise SystemExit("접속정보 파싱 실패")
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


def patch(cur, name):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                "WHERE owner=:o AND object_name=:n AND object_type=:t", o=OWNER, n=name, t=TYPE)
    ddl_time, status = cur.fetchone()
    cur.execute("SELECT text FROM all_source WHERE owner=:o AND name=:n AND type=:t ORDER BY line",
                o=OWNER, n=name, t=TYPE)
    lines = [(r[0] or "").rstrip("\n").rstrip("\r") for r in cur.fetchall()]
    fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    print(f"[FRESH] {name} LAST_DDL={ddl_time} STATUS={status} LINES={len(lines)}")

    if any("[E20260917-MEASUREORDER]" in ln for ln in lines):
        raise SystemExit(f"{name}: 이미 적용됨 — 중단")

    # REPLACE 규약(의존 전제) 존재 assert
    if not any("REPLACE(v_OrderList" in ln and "'MEASURE'" in ln and "SORT_ORDER_NO" in ln for ln in lines):
        raise SystemExit(f"{name}: v_OrderList MEASURE→SORT_ORDER_NO REPLACE 미발견")

    # 3행 연속 가드 블록 (들여쓰기는 패키지별로 달라 strip 비교)
    hits = [i for i in range(len(lines) - 2)
            if lines[i].strip() == GUARD_IF and lines[i + 1].strip() == GUARD_ADD
            and lines[i + 2].strip() == GUARD_END]
    if len(hits) != 1:
        raise SystemExit(f"{name}: 가드 블록 {len(hits)}건 (기대 1)")
    i = hits[0]
    ind = lines[i + 1][:len(lines[i + 1]) - len(lines[i + 1].lstrip())]   # 본문 들여쓰기 승계
    print(f"[ANCHOR] {name} 가드 L{i+1}~L{i+3} (indent={len(ind)})")

    block = [
        ind + "--[E20260917-MEASUREORDER] 정렬축도 함께 보강 — PKG_DMF0035 동일 정정(사용자 신고 2026-09-17).",
        ind + "--  종전에는 v_ColList 에만 넣어, 아래 REPLACE(v_OrderList,'MEASURE',...) 가 치환 대상을",
        ind + "--  못 찾고 무동작 → ORDER BY 에 SORT_ORDER_NO 가 빠져 MEASURE POPUP 순서가 무시됐다.",
        ind + "--  실측: SALES 'Sales Plan Waterfall' MEASURE = DEFAULT_FLAG '-' 라 개인화 없는 사용자에서",
        ind + "--        컬럼목록에 아예 들어오지 않았다(BIZ 는 DEFAULT 'Y' 라 현행 정상 — 예방 목적).",
        ind + "v_OrderList := CASE WHEN v_OrderList IS NULL OR LENGTH(TRIM(v_OrderList)) = 0",
        ind + "                    THEN 'MEASURE ASC' ELSE v_OrderList || ',MEASURE ASC' END;",
    ]
    lines[i + 2:i + 2] = block
    body = "\n".join(lines) + "\n"
    if not body.startswith("PACKAGE"):
        raise SystemExit(f"{name}: 본문이 PACKAGE 로 시작하지 않음")
    ddl = "CREATE OR REPLACE " + body
    return ddl, ddl_time, fetched, len(lines)


def main():
    apply_mode = "--apply" in sys.argv
    with conn() as db:
        cur = db.cursor()
        for name, seq in TARGETS:
            ddl, ddl_time, fetched, n = patch(cur, name)
            stamp = (f"-- SOURCE-FRESH: {OWNER}.{name} {TYPE} LAST_DDL={ddl_time} "
                     f"FETCHED={fetched} DB=ZIOUI1\n")
            f = OUT / f"{seq}_{name}_BODY.sql"
            f.write_text(stamp + ddl + "/\n", encoding="utf-8")
            print(f"[FILE] {n} lines -> {f.name}")

            if not apply_mode:
                print(f"[DRY-RUN] {name} 미적용")
                continue

            cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                        "WHERE owner=:o AND object_name=:n AND object_type=:t", o=OWNER, n=name, t=TYPE)
            if cur.fetchone()[0] != ddl_time:
                raise SystemExit(f"{name}: FRESH-GATE FAIL 적용 직전 LAST_DDL 변동")
            cur.execute(ddl)
            db.commit()
            cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                        "WHERE owner=:o AND object_name=:n AND object_type=:t", o=OWNER, n=name, t=TYPE)
            print(f"[APPLY] {name}", cur.fetchone())
            cur.execute("SELECT line, position, text FROM all_errors "
                        "WHERE owner=:o AND name=:n AND type=:t", o=OWNER, n=name, t=TYPE)
            errs = cur.fetchall()
            print(f"[ERRORS] {name} {len(errs)}건")
            for e in errs[:5]:
                print("   ", e)


if __name__ == "__main__":
    main()
