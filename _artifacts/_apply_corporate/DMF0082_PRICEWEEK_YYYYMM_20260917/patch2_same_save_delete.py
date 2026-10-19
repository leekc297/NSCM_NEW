# -*- coding: utf-8 -*-
"""
DMF0082 #18 삭제 가드 — 보완 2차: **같은 저장에서 단가필요 메저도 함께 삭제되면 단가 삭제 허용**.

증상(실측 로그 14:13:37/14:29:40/14:30:41/14:38:51, minyonglee1):
  한 번의 저장에 MKT_FCST(qty 0) + LOC(price 0) 이 같은 일자(20260928)로 함께 들어오면
  'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 해당 주차에 존재하므로 Sales Price 삭제가 불가합니다.'
  2단계(메저 먼저 삭제·저장 → 단가 삭제)로 하면 정상. 사용자 확인 2026-09-17.

원인:
  #18 은 원장(DM_PLN_CFM_MKT_DEMAND_PLAN / DM_PLN_MKT_FCST)만 본다. 같은 저장이 지우는 중인
  FCST 행은 검증 시점에 아직 원장에 남아 있어 '존재'로 판정된다.
  (등록 가드 #10 은 반대로 "UI 입력값이든 DB 값이든" 합집합으로 보게 이미 처리되어 있다 — 비대칭.)

정정:
  F(원장) 행이 이번 저장에서 0 으로 지워지는 행이면 판정에서 제외한다.
  키: 40 분기 = 조인키 8종 + CELL_PROD_SITE_ID / 81 분기 = 조인키 8종 (각 분기 자신의 키 구성과 동일)

# FRESH-GATE : 추출·적용 직전 ALL_SOURCE 재조회 + 앵커 동일성 assert (hook #152)
"""
import sys, pathlib, datetime, re

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

OWNER, NAME, TYPE = "SCM_MGR", "PKG_DMF0082", "PACKAGE BODY"
OUT = pathlib.Path(__file__).parent
FETCH_LINE = "                FETCH FIRST 1 ROWS ONLY;"
MSG40 = "MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 해당 주차에 존재하므로"
MSG81 = "MKT FCST or RTF or AS_In_Req 정보가 해당 주차에 존재하므로"

HEAD = [
    "                  --[E20260917-SAMESAVEDEL] 같은 저장에서 그 FCST 도 0 으로 지워지는 중이면 '존재'로 보지 않는다.",
    "                  --  사용자 확인 2026-09-17: 2단계(메저 삭제·저장 → 단가 삭제)는 되고 1회 저장만 막혔다.",
    "                  --  원장은 검증 시점에 아직 옛 값이라, 이번 저장분(GT_PRDM1_T_MAIN)의 0 행을 차감한다.",
    "                  --  등록 가드 #10 이 '입력값 + DB값' 합집합을 보는 것과 축을 맞춘 것이다.",
    "                  AND NOT EXISTS (",
    "                        SELECT 1",
    "                          FROM SCM_MGR.GT_PRDM1_T_MAIN Z",
    "                         WHERE Z.DIVISION_ID       = F.DIVISION_ID",
    "                           AND Z.PROJECT_CODE      = F.PROJECT_CODE",
    "                           AND Z.SCM_SITE_ID       = F.SCM_SITE_ID",
    "                           AND Z.PLANT_SITE_ID     = F.PLANT_SITE_ID",
    "                           AND Z.ITEM_ID           = F.ITEM_ID",
    "                           AND Z.DOM_EXP           = F.DOM_EXP",
    "                           AND Z.FCST_TYPE         = F.FCST_TYPE",
    "                           AND Z.INCOTERMS         = F.INCOTERMS",
    "                           AND Z.MEASURE           = F.MEASURE",
    "                           AND Z.YYYYMMDD          = F.YYYYMMDD",
]
CELL = "                           AND Z.CELL_PROD_SITE_ID = F.CELL_PROD_SITE_ID"
TAIL = [
    "                           AND NVL(Z.QTY_PRICE, 0) = 0)",
]


def block(with_cell):
    return HEAD + ([CELL] if with_cell else []) + TAIL


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

        if any("[E20260917-SAMESAVEDEL]" in ln for ln in lines):
            raise SystemExit("이미 적용됨 — 중단")

        # 메시지 라인에서 위로 올라가 FETCH 앵커를 찾는다 (고정 행번호 의존 배제)
        inserts = []
        for msg, with_cell in ((MSG40, True), (MSG81, False)):
            idx = next((i for i, ln in enumerate(lines) if msg in ln), None)
            if idx is None:
                raise SystemExit(f"앵커 메시지 미발견: {msg[:30]}")
            j = next((k for k in range(idx, -1, -1) if lines[k] == FETCH_LINE), None)
            if j is None:
                raise SystemExit("FETCH 앵커 미발견")
            inserts.append((j, block(with_cell)))
            print(f"[ANCHOR] msg L{idx+1} → insert before L{j+1} (cell_prod={with_cell})")

        for j, blk in sorted(inserts, reverse=True):   # 뒤에서부터 삽입 = 인덱스 보존
            lines[j:j] = blk

        body = "\n".join(lines) + "\n"
        if not body.startswith("PACKAGE"):
            raise SystemExit("본문이 PACKAGE 로 시작하지 않음")
        ddl = "CREATE OR REPLACE " + body
        stamp = (f"-- SOURCE-FRESH: {OWNER}.{NAME} {TYPE} LAST_DDL={ddl_time} "
                 f"FETCHED={fetched} DB=ZIOUI1\n")
        f = OUT / "02_PKG_DMF0082_BODY_SAMESAVEDEL.sql"
        f.write_text(stamp + ddl + "/\n", encoding="utf-8")
        print(f"[BUILD] {len(lines)} lines → {f}")

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
