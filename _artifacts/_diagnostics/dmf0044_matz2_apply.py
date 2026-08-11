#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_matz2_apply.py — ISV CTE 사전필터 (2026-08-10)

## 근거

TUNE-M 으로 `MATERIALIZE` 는 확실히 먹었다 (플랜 `TEMP TABLE TRANSFORMATION` /
`LOAD AS SELECT SYS_TEMP_…`, 조인부 COST 1,020,217,535 → 12,385).
그런데 **CTE 적재 자체**가 새 병목이 됐다:

    2 LOAD AS SELECT (CURSOR DURATION MEMORY) SYS_TEMP_…
    3  HASH GROUP BY                        EST   207,305  COST 1,995,358,860
    4   NESTED LOOPS                        EST 448,901,475
    5    INDEX FAST FULL SCAN PK_SCM_ITEM_M EST   443,488
    6    VIEW PUSHED PREDICATE              ← 뷰 내부 상관 서브쿼리를 행마다

즉 `DM_MST_ITEM_SINGLE_V` 를 **전 division(386,286행)** 산출한다.
그런데 조인 조건이 `A.DIVISION_ID = B.DIVISION_ID` 이고 A 는 항상
`WHERE A.DIVISION_ID = P_DIVISION_ID` 로 걸려 있으므로 **다른 division 행은 조인될 수 없다**.
⇒ CTE 에 `WHERE DIVISION_ID = P_DIVISION_ID` 를 거는 것은 **결과 불변**이다.

실측 (읽기 전용):
    ISV 실제 투영 · 필터 없음      386,286행  0.7초
    ISV 실제 투영 · DIVISION 필터  168,619행  0.3초
    대상 버전 중 DIVISION_ID<>'40' 행수 = 0 (PLAN/ETC 양쪽) ⇒ 사전필터 무해 확인

⚠ 정정: 앞서 근거로 삼은 "뷰 단독 0.94초" 는 `SELECT COUNT(*)` 였다.
   COUNT(*) 는 비싼 T2(상관 서브쿼리) 컬럼을 **컬럼 프루닝으로 제거**하므로 척도가 아니었다.
   위 수치는 실제 사용 컬럼을 투영해 다시 잰 값이다.

사용: python dmf0044_matz2_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_matz2_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_MATZ2_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2,
    "M.CALC_YN = '-'": 12,
    "RPTGRP-STUB 2026-08-10": 14,
    "SEQGRP 2026-08-10": 3,
    "ETCDEL 2026-08-10": 1,
    "DYNSAMP 2026-08-10": 3,
    "NODATAGUARD 2026-08-10": 3,
    "DESCNULL 2026-08-10": 1,
    "TUNE-M 2026-08-10": 2,
    "TUNE-T 2026-08-10": 1,
}
MARK = "TUNE-M2 2026-08-10"

S8 = " " * 8
OLD = S8 + "      FROM DM_MST_ITEM_SINGLE_V )\n"
NEW = (S8 + "      FROM DM_MST_ITEM_SINGLE_V\n"
       + S8 + "     -- TUNE-M2 2026-08-10: 사전필터. 조인이 A.DIVISION_ID = B.DIVISION_ID 이고\n"
       + S8 + "     --   A 는 항상 DIVISION_ID = P_DIVISION_ID 로 걸리므로 타 division 행은\n"
       + S8 + "     --   조인될 수 없다 ⇒ 결과 불변. 386,286행 0.7초 → 168,619행 0.3초.\n"
       + S8 + "     WHERE DIVISION_ID = P_DIVISION_ID )\n")
EXPECT = 2
ADDED_LINES = 4 * EXPECT  # 8


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                        AND TYPE='PACKAGE BODY' ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    print("  앵커 %d (기대 %d)" % (body.count(OLD), EXPECT))
    bad = 0
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        bad += 0 if got == n else 1
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    print("  → 선행 마커 불일치 %d건" % bad)
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    base = len(text.splitlines())
    before = {m: text.count(m) for m in GUARD_MARKS}
    if MARK in text:
        sys.exit("[error] 마커 '%s' 이미 존재 — 중단" % MARK)
    n = text.count(OLD)
    if n != EXPECT:
        sys.exit("[error] 앵커 %d건 (기대 %d) — 손대지 않음" % (n, EXPECT))
    text = text.replace(OLD, NEW)
    print("  ISV CTE 사전필터 적용 %d곳" % n)
    if text.count(MARK) != EXPECT:
        sys.exit("[error] 마커 %d (기대 %d) — 중단" % (text.count(MARK), EXPECT))
    if text.count("WHERE DIVISION_ID = P_DIVISION_ID )") != EXPECT:
        sys.exit("[error] 필터 문장 수 불일치 — 중단")
    if text.count("SELECT /*+ MATERIALIZE */") != 2:
        sys.exit("[error] MATERIALIZE 힌트 %d (기대 2) — 중단" % text.count("SELECT /*+ MATERIALIZE */"))
    for m, k in GUARD_MARKS.items():
        if text.count(m) != k or text.count(m) != before[m]:
            sys.exit("[error] 선행 마커 '%s' 변동 (%d→%d) — 중단" % (m, before[m], text.count(m)))
    added = len(text.splitlines()) - base
    if added != ADDED_LINES:
        sys.exit("[error] 추가 행수 %d (기대 %d) — 중단" % (added, ADDED_LINES))
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, +%d) / 선행 마커 %d종 전량 유지 ✅"
          % (PATCHED, len(text.splitlines()), added, len(GUARD_MARKS)))
    return 0


def cmd_deploy():
    import oracledb

    if not PATCHED.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
        cur.execute(sql)
        cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                        WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1""")
        for r in cur.fetchall():
            print("  %-14s %s" % r)
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % e)
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT,'TUNE\\-M2 2026\\-08\\-10')),0) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
        print("  배포 후 마커 '%s' = %d (기대 %d)" % (MARK, cur.fetchone()[0], EXPECT))
    return 1 if errs else 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "patch", "deploy"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    if a.dump:
        sys.exit(cmd_dump())
    if a.patch:
        sys.exit(cmd_patch())
    if a.deploy:
        sys.exit(cmd_deploy())
    ap.error("--dump / --patch / --deploy 중 하나 필요")


if __name__ == "__main__":
    main()
