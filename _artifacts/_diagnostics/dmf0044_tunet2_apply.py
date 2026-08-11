#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_tunet2_apply.py — TUNE-T 보정 (2026-08-10)

## 왜 보정이 필요한가 (실측)

TUNE-T ① 로 `DM_MST_ITEM_SINGLE_V` 의 `VIEW PUSHED PREDICATE` 는 사라졌다(플랜 확인).
그런데 `DM_MOBILE_REPORT_PRODUCT` INSERT 는 여전히 느렸다 — 배포 후 SQL_ID 6dgspsw017ksa
가 1회 실행 **942초+** 미완.

플랜 실측(6dgspsw017ksa)이 원인을 지목한다:

    16 UNION ALL PUSHED PREDICATE          EST 2,183          ← 3개년 생성기 Y 가 union 뷰를 밀어넣음
    17  HASH JOIN OUTER                    EST 1,922
    21   VIEW DM_MST_ITEM_SINGLE_V         EST 153,814  COST 1,020,217,535
    23    JOIN FILTER USE :BF0000          EST 241,175,427    ← 블룸필터가 뷰 내부로 침투
    24     NESTED LOOPS                    EST 241,175,427
    26      INDEX FULL SCAN PK_SCM_ITEM_M  EST 221,744        ← 전체 인덱스 풀스캔 구동
    27      VIEW PUSHED PREDICATE          (뷰 내부 상관 서브쿼리, 행마다)

즉 **바깥 union 뷰 푸시**(16번)가 카디널리티를 1,922 로 뭉개고, 그 탓에 옵티마이저가
뷰 내부를 블룸필터+NL(2.4억 추정)로 몰았다. ①(안쪽)만 막고 ②(바깥)를 안 막아서 생긴
전형적인 **한쪽만 차단** 실패 — LOC 메저 문장에서 겪은 것과 같은 계보다.

격리 A/B/C 실측(같은 버전 R_S_20260128_V002_C, 결과 3안 모두 동일 (40140, 34677, 186345)):

    A 원본 무힌트                2.8초
    B TUNE-T ①                   0.9초
    C WITH MATERIALIZE           0.5초

→ 조인 자체는 어느 방식이든 빠르다. 문제는 **바깥 푸시로 인한 추정 붕괴** 뿐이다.
   따라서 바깥 union 뷰에도 `NO_PUSH_PRED` 를 건다.

사용: python dmf0044_tunet2_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_tunet2_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_TUNET2_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2,
    "M.CALC_YN = '-'": 12,
    "RPTGRP-STUB 2026-08-10": 14,
    "NVL(d_Result_Date, '-')": 14,
    "SEQGRP 2026-08-10": 3,
    "ETCDEL 2026-08-10": 1,
    "DYNSAMP 2026-08-10": 3,
    "DYNSAMP2 2026-08-10": 1,
    "DYNSAMP3 2026-08-10": 1,
    "NODATAGUARD 2026-08-10": 3,
    "DESCNULL 2026-08-10": 1,
    "TUNE-T 2026-08-10": 5,
}
MARK = "TUNE-T2 2026-08-10"

# 바깥 SELECT (DM_MOBILE_REPORT_PRODUCT INSERT 의 최상위) — 다음 줄까지 포함해 유일화
S8 = " " * 8
OLD = ("\n" + S8 + "SELECT A.DIVISION_ID\n"
       + " " * 13 + ", P_VERSION_NO AS VERSION_NO\n")
NEW = ("\n" + S8 + "-- TUNE-T2 2026-08-10: 바깥 union 뷰까지 푸시를 막는다. ①(안쪽)만 막았더니\n"
       + S8 + "--   UNION ALL PUSHED PREDICATE 가 EST 를 1,922 로 뭉개고, 그 오추정 탓에\n"
       + S8 + "--   DM_MST_ITEM_SINGLE_V 내부가 블룸필터+NL(EST 2.4억, INDEX FULL SCAN 구동)로\n"
       + S8 + "--   몰렸다(SQL_ID 6dgspsw017ksa 942초+ 미완). 양쪽을 모두 막아야 한다.\n"
       + S8 + "SELECT /*+ NO_PUSH_PRED(A) */ A.DIVISION_ID\n"
       + " " * 13 + ", P_VERSION_NO AS VERSION_NO\n")
EXPECT = 1
ADDED_LINES = 4


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
    print("  바깥 union 뷰 NO_PUSH_PRED(A) 적용 %d곳" % n)
    if text.count(MARK) != EXPECT:
        sys.exit("[error] 마커 %d (기대 %d) — 중단" % (text.count(MARK), EXPECT))
    if text.count("SELECT /*+ NO_PUSH_PRED(A) */ A.DIVISION_ID") != EXPECT:
        sys.exit("[error] 힌트 문장 수 불일치 — 중단")
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
        cur.execute("""SELECT SID, SUBSTR(PROGRAM,1,24), SUBSTR(EVENT,1,30), SECONDS_IN_WAIT, SQL_ID
                         FROM V$SESSION WHERE TYPE='USER' AND STATUS='ACTIVE'
                          AND PROGRAM LIKE 'JDBC%'""")
        act = cur.fetchall()
        print("  배포 전 JDBC ACTIVE = %d" % len(act))
        for r in act:
            print("   ", r)
        if act:
            print("  ⚠ 실행 중 세션 있음 — DDL_LOCK_TIMEOUT 로 대기 (KILL 금지)")
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 300")
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
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT,'TUNE\\-T2 2026\\-08\\-10')),0) FROM ALL_SOURCE
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
