#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_bp_dynsamp_apply.py — BP CREATE 미완(60분+) 성능 붕괴 정정 (2026-08-10)

사용자 지시: *"SP, BP 각각 CREATE … 기능 확인해주세요."* — BP CREATE 가 **끝나지 않아** 기능 확인 불가.

## 실측 (2026-08-10)

| 지표 | SP 계열 | BP 계열 |
|---|---:|---:|
| 원천 행수 | `DM_PLN_SALES_PLAN_C` 28,848 | `DM_PLN_BP_FCST_C` **1,283,852** (44배) |
| CREATE 소요 | 3.4초 | **60분+ 미완** (2회 재현) |

`V$SQL_PLAN_MONITOR` 실측 — 카디널리티 **46배 과소추정**:

    NESTED LOOPS OUTER   EST 13,635  →  ACT 633,479
    HASH JOIN RIGHT OUTER EST 374,368 → ACT 755,712

원인 3종 중첩:
1. `GT_DMF0_REPORT` / `GT_DMF0_VERSION_COPY` / `GT_DMF0_MEASURE` 전부 **NUM_ROWS NULL**(GTT, 통계 없음)
2. `optimizer_dynamic_sampling = 2` (기본) — 64블록만 샘플링해 63만 행을 1.3만으로 추정
3. `optimizer_adaptive_statistics = FALSE` — 실행 중 보정 없음

결정타는 **L8310~8323 `GT_DMF0_REPORT` 자기조인(등가조건 14컬럼)**. 오추정 탓에 HASH JOIN 대신
NESTED LOOPS 가 선택되어 63만 행을 루프한다. 메모리 `cloud_optimizer_dynamic_sampling_gtt` 와 같은 계보.

## 정정 — 힌트(파싱 시 샘플링). ⚠ `DBMS_STATS` 를 쓰지 않은 이유

`GLOBAL_TEMP_TABLE_STATS='SESSION'` 이라 `DBMS_STATS.GATHER_TABLE_STATS` 도 세션 전용이지만,
**이 SP 는 하나의 트랜잭션 안에서 원장 3표를 쓰고 마지막에 COMMIT / 오류 시 ROLLBACK** 한다.
DBMS_STATS 가 내부적으로 커밋을 유발하면 **부분 커밋 사고**로 이어질 수 있어 채택하지 않았다.
`DYNAMIC_SAMPLING(11)`(AUTO)은 딕셔너리 기록·커밋이 없어 트랜잭션에 안전하다.

적용 지점 = `INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (` **3곳**(division 40 / 81% / 82) — 셋 다
같은 `GT_DMF0_REPORT` 자기조인을 태우므로 분기별로 빠짐없이 건다.

사용: python dmf0044_bp_dynsamp_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_dynsamp_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_DYNSAMP_20260810.sql"

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
}

T4 = "\t" * 4
OLD = T4 + "INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (\n"
NEW = (
    T4 + "-- DYNSAMP 2026-08-10: GT_DMF0_REPORT 는 GTT 라 통계가 없다(NUM_ROWS NULL).\n"
    + T4 + "--   optimizer_dynamic_sampling=2 로는 L8310~8323 자기조인 카디널리티가 46배 과소추정되어\n"
    + T4 + "--   (EST 13,635 / ACT 633,479) NESTED LOOPS 로 폭주한다 → BP CREATE 60분+ 미완.\n"
    + T4 + "--   레벨 11(AUTO)로 파싱 시 충분히 샘플링. 딕셔너리 기록·커밋이 없어 트랜잭션에 안전하다.\n"
    + T4 + "INSERT /*+ DYNAMIC_SAMPLING(11) */ INTO DM_PLN_SALES_PLAN_REPORT_C (\n"
)
EXPECT = 3
NEW_MARK = ("DYNSAMP 2026-08-10", 3)
ADDED_LINES = 12  # 주석 4줄 × 3곳


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
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    base = len(text.splitlines())
    if NEW_MARK[0] in text:
        print("  이미 적용됨 — skip(멱등)")
    else:
        n = text.count(OLD)
        if n != EXPECT:
            sys.exit("[error] 앵커 %d건 (기대 %d) — 손대지 않음" % (n, EXPECT))
        text = text.replace(OLD, NEW)
        print("  힌트 적용 %d곳 (division 40 / 81%% / 82)" % n)
    if text.count(NEW_MARK[0]) != NEW_MARK[1]:
        sys.exit("[error] 마커 %d (기대 %d) — 중단" % (text.count(NEW_MARK[0]), NEW_MARK[1]))
    if text.count("INSERT /*+ DYNAMIC_SAMPLING(11) */ INTO DM_PLN_SALES_PLAN_REPORT_C (") != EXPECT:
        sys.exit("[error] 힌트 문장 수 불일치 — 중단")
    for m, k in GUARD_MARKS.items():
        if text.count(m) != k:
            sys.exit("[error] 선행 마커 '%s' 소실 (%d≠%d) — 중단" % (m, text.count(m), k))
    added = len(text.splitlines()) - base
    if added != ADDED_LINES:
        sys.exit("[error] 추가 행수 %d (기대 %d) — 중단" % (added, ADDED_LINES))
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, +%d) / 선행 마커 9종 유지 ✅" % (PATCHED, len(text.splitlines()), added))
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
        cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                        WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1""")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT,'DYNAMIC_SAMPLING\\(11\\)')),0) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
        print("  배포 후 DYNAMIC_SAMPLING(11) = %d (기대 %d)" % (cur.fetchone()[0], EXPECT))
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
