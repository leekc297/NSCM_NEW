#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_matz_apply.py — hook #129 1순위 구조 개선 (2026-08-10, 사용자 승인)

## 방향 전환 근거 (실측)

힌트로 옵티마이저와 씨름하는 방식을 접고 **선계산 후 JOIN** 으로 간다.
같은 대상 버전(R_S_20260128_V002_C)에서 **전체 문장 형태를 그대로 재현**해 4안 비교:

    배포 전 원본 (힌트 0)                     5.3초
    TUNE-T ① (NO_PUSH_PRED(B) USE_HASH(B))   5.0초
    TUNE-T ①+② (+NO_PUSH_PRED(A))            5.1초
    ★ WITH MATERIALIZE (힌트 0)               0.7초   ← 7배
    결과 4안 모두 동일: (23행, MM01+MM12 합 3076304299584.838)

즉 **힌트는 사실상 무효**였다. 바인드 변수 환경에서 카디널리티가 무너지면
(`INDEX FULL SCAN PK_SCM_ITEM_M` + NL, EST 241,175,427) 힌트로는 못 막는다.
`MATERIALIZE` 는 옵티마이저 판단과 무관하게 **1회 산출**을 보장한다.

## 변경 내용

1. `DM_MOBILE_REPORT_PRODUCT` INSERT(PRODUCT_CREATE) / `GT_DMF0044_DEPT_RPT_C` INSERT(DEPT_CREATE)
   각각에 `WITH ISV AS (SELECT /*+ MATERIALIZE */ …)` 도입 후
   `LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B` → `LEFT OUTER JOIN ISV B` (4곳)
2. **불필요해진 힌트 제거**:
   - `TUNE-T ①` 분기 힌트 4곳 (`NO_PUSH_PRED(B) USE_HASH(B)`) → 원복
   - `TUNE-T2` 바깥 힌트 1곳 (`NO_PUSH_PRED(A)`) → 원복
   - ⇒ 두 문장에서 힌트 0. 남는 것은 BP LOC 의 `TUNE-T ②` 1곳뿐(별도 문장, 아래 참조)
3. **유지**: BP LOC(L8607)의 `NO_PUSH_PRED(A) NO_PUSH_PRED(B) LEADING USE_HASH` —
   이 문장은 `GT_DMF0_MEASURE`(세션 GTT)에 의존해 **단독 재현·실측이 불가**하다.
   근거 없는 구조 변경을 하지 않는다는 원칙에 따라 현행 유지하고 미검증으로 보고한다.

행집합 불변: `MATERIALIZE` 는 동일 뷰를 1회 실체화할 뿐 조인 의미를 바꾸지 않는다.
위 4안 동일성으로 실측 증명됨.

사용: python dmf0044_matz_apply.py --dump / --patch / --deploy
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import dmf0044_tunet_apply as T1  # noqa: E402  (앵커 문자열 재사용 — 오타로 인한 불일치 원천 차단)
import dmf0044_tunet2_apply as T2  # noqa: E402
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate"
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_matz_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_MATZ_20260810.sql"

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
}
MARK = "TUNE-M 2026-08-10"

S8 = " " * 8
WITH_BLOCK = (
    S8 + "-- TUNE-M 2026-08-10: hook #129 1순위(구조 개선) — 힌트 대신 선계산 후 JOIN.\n"
    + S8 + "--   DM_MST_ITEM_SINGLE_V 를 1회만 산출해 실체화한 뒤 조인한다.\n"
    + S8 + "--   실측(대상 버전 R_S_20260128_V002_C, 전체 문장 형태 그대로 재현):\n"
    + S8 + "--     원본 5.3초 / NO_PUSH_PRED(B)+USE_HASH(B) 5.0초 / +NO_PUSH_PRED(A) 5.1초\n"
    + S8 + "--     / WITH MATERIALIZE 0.7초 — 결과 4안 모두 (23행, 합 3076304299584.838) 동일.\n"
    + S8 + "--   바인드 변수 환경에서 카디널리티가 무너지면(EST 2.4억, INDEX FULL SCAN 구동)\n"
    + S8 + "--   힌트로는 못 막는다. MATERIALIZE 는 옵티마이저 판단과 무관하게 1회 산출을 보장한다.\n"
    + S8 + "WITH ISV AS (\n"
    + S8 + "    SELECT /*+ MATERIALIZE */ DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT\n"
    + S8 + "      FROM DM_MST_ITEM_SINGLE_V )\n"
)
WITH_LINES = 10

JOIN_OLD = "LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B"
JOIN_NEW = "LEFT OUTER JOIN ISV B"
JOIN_N = 4

# 순 증감: T2 원복 -4, TUNE-T 분기 원복 -4×4=-16, WITH 삽입 +10×2=+20  → 0
ADDED_LINES = 0


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
    print("  앵커 TUNE-T①A(PRODUCT 분기) %d (기대 2)" % body.count(T1.NEW1A))
    print("  앵커 TUNE-T①B(DEPT 분기)    %d (기대 2)" % body.count(T1.NEW1B))
    print("  앵커 TUNE-T2(바깥)          %d (기대 1)" % body.count(T2.NEW))
    print("  앵커 JOIN 뷰                %d (기대 %d)" % (body.count(JOIN_OLD), JOIN_N))
    print("  BP LOC TUNE-T② 유지         %d (기대 1)"
          % body.count("NO_MERGE(B) NO_PUSH_PRED(A) NO_PUSH_PRED(B) */"))
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

    for label, anchor, n in (("TUNE-T①A", T1.NEW1A, 2), ("TUNE-T①B", T1.NEW1B, 2),
                             ("TUNE-T2", T2.NEW, 1), ("JOIN 뷰", JOIN_OLD, JOIN_N)):
        got = text.count(anchor)
        if got != n:
            sys.exit("[error] 앵커 %s %d건 (기대 %d) — 손대지 않음" % (label, got, n))

    # 1) 힌트 원복
    text = text.replace(T1.NEW1A, T1.OLD1A)
    text = text.replace(T1.NEW1B, T1.OLD1B)
    text = text.replace(T2.NEW, T2.OLD)
    print("  힌트 원복: TUNE-T① 4곳 / TUNE-T2 1곳")

    # 2) WITH 삽입 — PRODUCT_CREATE 최상위 SELECT (T2.OLD 가 그 지점, 유일)
    if text.count(T2.OLD) != 1:
        sys.exit("[error] PRODUCT 최상위 앵커 %d건 — 중단" % text.count(T2.OLD))
    text = text.replace(T2.OLD, "\n" + WITH_BLOCK + T2.OLD.lstrip("\n"), 1)

    # 3) WITH 삽입 — DEPT_CREATE 첫 분기 SELECT (8-공백 2건 중 첫 번째)
    if text.count(T1.OLD1B) != 2:
        sys.exit("[error] DEPT 분기 앵커 %d건 (기대 2) — 중단" % text.count(T1.OLD1B))
    text = text.replace(T1.OLD1B, "\n" + WITH_BLOCK + T1.OLD1B.lstrip("\n"), 1)
    print("  WITH ISV 삽입 2곳 (PRODUCT_CREATE / DEPT_CREATE)")

    # 4) 조인 대상 교체
    text = text.replace(JOIN_OLD, JOIN_NEW)
    print("  JOIN 대상 교체 %d곳 (DM_MST_ITEM_SINGLE_V → ISV)" % JOIN_N)

    # 사후 단언
    if text.count(MARK) != 2:
        sys.exit("[error] 마커 %d (기대 2) — 중단" % text.count(MARK))
    if text.count("SELECT /*+ MATERIALIZE */") != 2:
        sys.exit("[error] MATERIALIZE %d (기대 2) — 중단" % text.count("SELECT /*+ MATERIALIZE */"))
    if text.count(JOIN_OLD) != 0:
        sys.exit("[error] 구 조인 잔존 %d — 중단" % text.count(JOIN_OLD))
    if text.count(JOIN_NEW) != JOIN_N:
        sys.exit("[error] 신 조인 %d (기대 %d) — 중단" % (text.count(JOIN_NEW), JOIN_N))
    if text.count("NO_PUSH_PRED(B) USE_HASH(B)") != 0:
        sys.exit("[error] TUNE-T① 힌트 잔존 — 중단")
    if text.count("SELECT /*+ NO_PUSH_PRED(A) */") != 0:
        sys.exit("[error] TUNE-T2 힌트 잔존 — 중단")
    if text.count("NO_MERGE(B) NO_PUSH_PRED(A) NO_PUSH_PRED(B) */") != 1:
        sys.exit("[error] BP LOC TUNE-T② 가 유지되지 않음 — 중단")
    if text.count("TUNE-T 2026-08-10") != 1:
        sys.exit("[error] 잔존 TUNE-T 마커 %d (기대 1=BP LOC) — 중단" % text.count("TUNE-T 2026-08-10"))
    for m, k in GUARD_MARKS.items():
        if text.count(m) != k or text.count(m) != before[m]:
            sys.exit("[error] 선행 마커 '%s' 변동 (%d→%d) — 중단" % (m, before[m], text.count(m)))
    added = len(text.splitlines()) - base
    if added != ADDED_LINES:
        sys.exit("[error] 추가 행수 %d (기대 %d) — 중단" % (added, ADDED_LINES))

    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, %+d) / 선행 마커 %d종 전량 유지 ✅"
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
                         FROM V$SESSION WHERE TYPE='USER' AND STATUS='ACTIVE' AND PROGRAM LIKE 'JDBC%'""")
        act = cur.fetchall()
        print("  배포 전 JDBC ACTIVE = %d" % len(act))
        for r in act:
            print("   ", r)
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
        for m, exp in ((r"TUNE\-M 2026\-08\-10", 2), (r"MATERIALIZE", 2), (r"TUNE\-T 2026\-08\-10", 1)):
            cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, :m)),0) FROM ALL_SOURCE
                            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""",
                        {"m": m})
            print("  배포 후 '%s' = %d (기대 %d)" % (m, cur.fetchone()[0], exp))
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
