#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_tunet_apply.py — PKG_DMF0044 JPPD(조인술어 푸시) 폭주 2건 정정 (2026-08-10)

## 실측 병목 (V$SQL / V$SQL_PLAN_MONITOR / DBMS_XPLAN HINT_REPORT)

### ① Transfer — `P_DMF0044_SALES_REPORT_PRODUCT_CREATE` 의 DM_MOBILE_REPORT_PRODUCT INSERT
SQL_ID 761qq1a2shbyp (소스 L9660) — 1회 실행 **691.9초** / buffer_gets 32,097,627 / 결과 10행.

    13 VIEW                                     EST 1     ACT 5,444   STARTS 3
    18 VIEW PUSHED PREDICATE DM_MST_ITEM_SINGLE_V EST 1   ACT 2,878   STARTS 4,094  ← 구동행마다 재실행
    29  INDEX SKIP SCAN PK_SCM_ITEM_M           EST 2,217 ACT 239,092 STARTS 6,468

`DM_MST_ITEM_SINGLE_V` 를 **구동행 1건마다** 다시 산출한다. 그런데 이 뷰의 단독 산출은
전체 386,286행 **0.94초**(division 40 은 168,619행 0.35초)뿐이다. 대상 버전
`R_S_20260128_V002_C` 의 구동행은 40,140(PLAN) + 5,145(ETC) = **45,285행** → 4.5만 번 재실행.
1회 산출 후 해시조인으로 바꾸면 된다.

### ② BP CREATE — LOC 메저 INSERT (소스 L8607, SELECT 힌트 L8620)
SQL_ID fndp8c35xn8y5 — 3회 3,721.6초(회당 1,240초) / buffer_gets 1,280,917,350.

HINT_REPORT 가 원인을 직접 보고한다 (총 6 힌트 중 3 Unused):

    1 - SEL$88215DA2            U - LEADING(A B)
    1 - .../ "A"@"SEL$1"            - NO_MERGE(A)
    1 - .../ "B"@"SEL$1"        U - USE_HASH(B)
                                    - NO_MERGE(B)
                                    - NO_PUSH_PRED(B)

⚠ 별칭 충돌이 아니었다. `A`/`B` 는 `"A"@"SEL$1"` / `"B"@"SEL$1"` 로 **정상 해석**되었고
`NO_PUSH_PRED(B)` 도 **적용**되었다. 문제는 옵티마이저가 **역할을 뒤집은** 것이다 —
Object Alias 맵을 보면 plan 4(그냥 VIEW)가 `"B"@"SEL$1"`, plan 11(VIEW PUSHED PREDICATE)이
`"A"@"SEL$1"` 이다. 즉 B 가 구동이 되고 **A 가 행마다 재실행**(STARTS=37,617)됐다.
A 가 푸시 대상이 되어 버렸으니 `LEADING(A B)` 는 성립 불가 → 옵티마이저가 조용히 버렸고,
그 여파로 `USE_HASH(B)` 도 U 처리됐다.

→ 처방은 QB_NAME 이 아니라 **양측 푸시를 모두 막는 것**: `NO_PUSH_PRED(A)` 1개 추가.
   그래야 어느 쪽도 푸시 대상이 못 되고 LEADING/USE_HASH 가 성립한다.

## 불변식
둘 다 **실행계획만** 바꾼다. 조인 방식(NL↔HASH)·푸시 여부는 결과 행집합과 무관하다.
SELECT 목록 / WHERE / JOIN 조건 / GROUP BY 는 1바이트도 건드리지 않는다.

사용: python dmf0044_tunet_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_tunet_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_TUNET_20260810.sql"

# dump 시점 실측 기준. DESCNULL 은 선행 배포(대기 중)에 따라 0/1 둘 다 가능 →
# 절대값 대신 '패치 전후 불변' 으로 검증한다(아래 invariance 체크).
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
}
FLOATING_MARKS = ["DESCNULL 2026-08-10"]  # 절대값 미고정 — 전후 불변만 단언

MARK = "TUNE-T 2026-08-10"

# ── ① Transfer: UNION 분기 SELECT 에 지역 힌트 (분기 내 B = DM_MST_ITEM_SINGLE_V) ──
#    같은 병리가 2개 하위 프로시저에 총 4곳 (들여쓰기만 다름):
#      P_DMF0044_SALES_REPORT_PRODUCT_CREATE L9709 / L9722  (공백 16)
#      P_DMF0044_SALES_REPORT_DEPT_CREATE    L9384 / L9398  (공백 8)
#    ⚠ 앵커에 선행 개행을 포함한다. 공백 16 앵커는 공백 8 앵커를 **부분문자열로 포함**하므로
#      (16 = 8+8) 개행 고정 없이 count 하면 8-공백 앵커가 4건으로 잡혀 오치환된다. (실측 확인)
def _mk(ind):
    old = "\n" + ind + "SELECT A.DIVISION_ID, A.PRODUCT_GROUP\n"
    new = (
        "\n" + ind + "-- TUNE-T 2026-08-10: DM_MST_ITEM_SINGLE_V 가 VIEW PUSHED PREDICATE 로 구동행마다\n"
        + ind + "--   재실행됐다 (V$SQL_PLAN_MONITOR STARTS=4,094 / 961, 회당 INDEX SKIP SCAN PK_SCM_ITEM_M).\n"
        + ind + "--   이 뷰 단독 산출은 386,286행 0.94초뿐 — 1회 산출 후 해시조인이 옳다.\n"
        + ind + "--   조인 방식만 바꾸므로 결과 행집합은 동일하다.\n"
        + ind + "SELECT /*+ NO_PUSH_PRED(B) USE_HASH(B) */ A.DIVISION_ID, A.PRODUCT_GROUP\n"
    )
    return old, new


OLD1A, NEW1A = _mk(" " * 16)   # PRODUCT_CREATE
OLD1B, NEW1B = _mk(" " * 8)    # DEPT_CREATE
EXPECT1A = 2
EXPECT1B = 2
EXPECT1 = EXPECT1A + EXPECT1B

# ── ② BP LOC: NO_PUSH_PRED(A) 추가로 역할 뒤집힘 차단 ──
T4 = "\t" * 4
OLD2 = T4 + "SELECT /*+ LEADING(A B) USE_HASH(B) NO_MERGE(A) NO_MERGE(B) NO_PUSH_PRED(B) */"
NEW2 = (
    T4 + "-- TUNE-T 2026-08-10: HINT_REPORT 실측 — NO_PUSH_PRED(B) 는 적용됐으나 옵티마이저가\n"
    + T4 + "--   역할을 뒤집어 B 를 구동으로, A 를 VIEW PUSHED PREDICATE 로 만들었다(STARTS=37,617).\n"
    + T4 + "--   A 가 푸시 대상이 되니 LEADING(A B)/USE_HASH(B) 가 U(Unused) 처리됨.\n"
    + T4 + "--   양측 푸시를 모두 막아야(NO_PUSH_PRED(A) 추가) 해시조인이 성립한다.\n"
    + T4 + "SELECT /*+ LEADING(A B) USE_HASH(B) NO_MERGE(A) NO_MERGE(B) NO_PUSH_PRED(A) NO_PUSH_PRED(B) */"
)
EXPECT2 = 1

ADDED_LINES = 4 * EXPECT1 + 4 * EXPECT2  # 4곳×4 + 1곳×4 = 20
EXPECT_MARK = EXPECT1 + EXPECT2          # 5


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
    print("  앵커①A(PRODUCT) %d (기대 %d) / 앵커①B(DEPT) %d (기대 %d) / 앵커②(BP LOC) %d (기대 %d)"
          % (body.count(OLD1A), EXPECT1A, body.count(OLD1B), EXPECT1B,
             body.count(OLD2), EXPECT2))
    bad = 0
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        flag = "" if got == n else "  ⚠"
        bad += 0 if got == n else 1
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, flag))
    for m in FLOATING_MARKS:
        print("  변동 마커 '%s' = %d (전후 불변만 단언)" % (m, body.count(m)))
    print("  → 선행 마커 불일치 %d건" % bad)
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    base_lines = len(text.splitlines())
    before = {m: text.count(m) for m in list(GUARD_MARKS) + FLOATING_MARKS}

    if MARK in text:
        sys.exit("[error] 마커 '%s' 이미 존재 — 이중 적용 위험, 중단" % MARK)

    n1a, n1b, n2 = text.count(OLD1A), text.count(OLD1B), text.count(OLD2)
    if n1a != EXPECT1A:
        sys.exit("[error] 앵커①A %d건 (기대 %d) — 손대지 않음" % (n1a, EXPECT1A))
    if n1b != EXPECT1B:
        sys.exit("[error] 앵커①B %d건 (기대 %d) — 손대지 않음" % (n1b, EXPECT1B))
    if n2 != EXPECT2:
        sys.exit("[error] 앵커② %d건 (기대 %d) — 손대지 않음" % (n2, EXPECT2))
    text = text.replace(OLD1A, NEW1A)
    print("  ①A PRODUCT_CREATE 분기 힌트 %d곳" % n1a)
    text = text.replace(OLD1B, NEW1B)
    print("  ①B DEPT_CREATE 분기 힌트 %d곳" % n1b)
    text = text.replace(OLD2, NEW2)
    print("  ②  BP LOC NO_PUSH_PRED(A) 추가 %d곳" % n2)

    # 사후 단언
    if text.count(MARK) != EXPECT_MARK:
        sys.exit("[error] 마커 %d (기대 %d) — 중단" % (text.count(MARK), EXPECT_MARK))
    if text.count("SELECT /*+ NO_PUSH_PRED(B) USE_HASH(B) */ A.DIVISION_ID, A.PRODUCT_GROUP") != EXPECT1:
        sys.exit("[error] ① 힌트 문장 수 불일치 — 중단")
    if text.count("NO_MERGE(B) NO_PUSH_PRED(A) NO_PUSH_PRED(B) */") != EXPECT2:
        sys.exit("[error] ② 힌트 문장 수 불일치 — 중단")
    if text.count(OLD1A) or text.count(OLD1B) or text.count(OLD2):
        sys.exit("[error] 앵커 잔존 — 중단")
    for m, k in GUARD_MARKS.items():
        if text.count(m) != k:
            sys.exit("[error] 선행 마커 '%s' 소실 (%d≠%d) — 중단" % (m, text.count(m), k))
    for m in list(GUARD_MARKS) + FLOATING_MARKS:
        if text.count(m) != before[m]:
            sys.exit("[error] 마커 '%s' 전후 변동 (%d→%d) — 중단" % (m, before[m], text.count(m)))
    added = len(text.splitlines()) - base_lines
    if added != ADDED_LINES:
        sys.exit("[error] 추가 행수 %d (기대 %d) — 중단" % (added, ADDED_LINES))

    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, +%d) / 선행 마커 %d종 전량 유지 ✅"
          % (PATCHED, len(text.splitlines()), added, len(GUARD_MARKS) + len(FLOATING_MARKS)))
    return 0


def cmd_deploy():
    import oracledb

    if not PATCHED.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        # 배포 전 활성 세션 확인 — library cache pin 대기 회피
        cur.execute("""SELECT COUNT(*) FROM V$SESSION
                        WHERE PROGRAM LIKE 'JDBC%' AND STATUS='ACTIVE'
                          AND EVENT NOT LIKE 'SQL*Net%'""")
        act = cur.fetchone()[0]
        print("  배포 전 JDBC ACTIVE = %d" % act)
        if act:
            print("  ⚠ 활성 세션 존재 — library cache pin 대기 가능 (KILL 금지, DDL_LOCK_TIMEOUT 로 대기)")
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 300")
        cur.execute(sql)
        cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                        WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1""")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT,'TUNE-T 2026-08-10')),0) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
        print("  배포 후 마커 '%s' = %d (기대 %d)" % (MARK, cur.fetchone()[0], EXPECT_MARK))
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
