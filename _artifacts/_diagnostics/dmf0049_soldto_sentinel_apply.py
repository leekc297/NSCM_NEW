#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_soldto_sentinel_apply.py — DMF0049 저장 시 Sold-To 센티널 NVL(x,'-') (2026-08-11)

## 요청 (사용자)
"저장 시 Sold-To NVL(x, '-') 요청"

## 실측 — 저장 경로 전수 (hook #130 §3)
`PKG_DMF0049` BODY 의 SAVE 프로시저가 원장에 쓰는 지점은 3곳이다:
  ① L1084  INSERT INTO DM_PLN_SALES_ETC_REPORT_C  (DATA_SEQ 기존분)  … A.SOLDTO_CODE  ⛔ 무가드
  ② L1114  INSERT INTO DM_PLN_SALES_ETC_REPORT_C  (DATA_SEQ 채번분)  … A.SOLDTO_CODE  ⛔ 무가드
  ③ L1142  INSERT INTO DM_PLN_SALES_ETC_REPORT_H  (이력)             … A.SOLDTO_CODE
③ 은 원천이 **원장(`FROM DM_PLN_SALES_ETC_REPORT_C A`, L1152)** 이므로 ①②를 고치면
자동으로 '-' 를 승계한다. ⇒ **손대는 곳은 ①② 2곳뿐**(불필요한 수술 금지).

## 왜 필요한가
· GTT 적재부(L813)는 `TRIM(REGEXP_SUBSTR(RTRIM(p_soldto_code)||'^', ...))` 로 '^' 분해하므로
  FE 가 해당 셀을 비우면 빈 문자열이 들어가고, Oracle 은 `''` = NULL 이다.
· 같은 SELECT 안에 이미 `NVL(A.DIVISION_ID,'-')` · `NVL(A.MEASURE,'-')` · `NVL(A.YYYYMMDD,'-')`
  선례가 있다 — 동일 센티널 규약(hook #119 §1.5)에 Sold-To 만 빠져 있었다.
· 형제 화면 DMF0044 도 ETC 기입 경로에서 `SOLDTO_CODE='-'` 로 통일했다(마커 ETCNICK, 2026-08-11).
  원장 실측도 209,696/209,702행이 '-' 로, '-' 가 확립된 관례값이다.

※ 컬럼 자체는 NULLABLE(VARCHAR2(120)) 이라 ORA-01400 은 나지 않는다. 목적은 **키 정합**이다 —
   NULL 과 '-' 가 섞이면 조회/집계 GROUP BY 와 PK 성격 비교에서 같은 행이 갈라진다.

## 조치
①② 의 `A.SOLDTO_CODE` → `NVL(A.SOLDTO_CODE, '-')`.
두 줄 모두 `, A.CUST_REPORT, A.SOLDTO_CODE` 로 끝나 앵커가 공통이다(기대 2건).

사용:
  python dmf0049_soldto_sentinel_apply.py --dump / --patch / --deploy / --verify
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate"
BACKUP = OUT / "BACKUP_PKG_DMF0049_BODY_pre_soldto_20260811.sql"
PATCHED = OUT / "PKG_DMF0049_BODY_SOLDTO_20260811.sql"

MARKER = "SOLDTO-SENTINEL"
_OLD = ", A.CUST_REPORT, A.SOLDTO_CODE\n"
_NEW = ", A.CUST_REPORT, NVL(A.SOLDTO_CODE, '-')  /* [%s 2026-08-11] 빈값→'-' 통일 */\n" % MARKER
EXPECT = 2


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049'
                       AND TYPE='PACKAGE BODY' ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d행)" % (BACKUP, len(body.splitlines())))
    print("  앵커 = %d건 (기대 %d)" % (body.count(_OLD), EXPECT))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if MARKER in text:
        sys.exit("[error] 이미 적용됨")
    n = text.count(_OLD)
    if n != EXPECT:
        sys.exit("[error] 앵커 %d건 (기대 %d) — 손대지 않음" % (n, EXPECT))
    text = text.replace(_OLD, _NEW)
    got = text.count("NVL(A.SOLDTO_CODE, '-')")
    if got != EXPECT:
        sys.exit("[error] 치환 결과 %d건 (기대 %d)" % (got, EXPECT))
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s — %d곳 치환 ✅" % (PATCHED, got))
    return 0


def cmd_deploy():
    import oracledb

    if not PATCHED.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(sql)
        cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS "
                    "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0049' ORDER BY 1")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS "
                    "WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049' ORDER BY SEQUENCE")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
    return 1 if errs else 0


def cmd_verify():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
                       AND NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY'
                       AND INSTR(TEXT, :m) > 0""", m=MARKER)
        n = cur.fetchone()[0]
        cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                       AND OBJECT_NAME='PKG_DMF0049' AND OBJECT_TYPE='PACKAGE BODY'""")
        st = cur.fetchone()[0]
        print("  마커 %d행 (기대 %d) / BODY %s" % (n, EXPECT, st))
        # 원장 센티널 분포 — NULL 이 남아 있는지
        cur.execute("""SELECT NVL2(SOLDTO_CODE,'값있음','NULL') AS K, COUNT(*)
                         FROM DM_PLN_SALES_ETC_REPORT_C GROUP BY NVL2(SOLDTO_CODE,'값있음','NULL')""")
        for k, c in cur.fetchall():
            print("  원장 %-8s %d행" % (k, c))
    return 0 if (n == EXPECT and st == "VALID") else 1


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "patch", "deploy", "verify"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    for f in ("dump", "patch", "deploy", "verify"):
        if getattr(a, f):
            sys.exit(globals()["cmd_" + f]())
    ap.error("--dump / --patch / --deploy / --verify 중 하나 필요")


if __name__ == "__main__":
    main()
