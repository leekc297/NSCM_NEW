#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_reportgroup_stub_apply.py — 드롭 컬럼 스텁 `NVL(NULL,NULL)` → 센티널 `'-'` (2026-08-10)

## 결함 (사용자 신고 "VERSION CREATE 시 SQL ERROR" — **4번째 껍질, 최종 차단점**)

    ORA-01400: NULL을 "SCM_MGR"."DM_PLN_SALES_ETC_REPORT_C"."CUTOFF_TYPE" 안에 삽입할 수 없습니다 (L8901)

### 실측 인과 사슬 (전 구간 read-only 계측 완료)

| 단계 | 위치 | 실측 |
|---|---|---|
| 원천 | `DM_PLN_SALES_PLAN_C` 40/SP_W_20260730_V002 | 28,848행 |
| GT_DMF0_VERSION_COPY | L7354 (CALC_YN 정정 후) | **14,452행** ✅ |
| GT_DMF0_REPORT | L8209 (SITE_ITEM·SSO_USER·SSO_DEPT·SITE JOIN) | **14,381행** ✅ |
| **DM_PLN_SALES_PLAN_REPORT_C** | L8252 (GT_DMF0_REPORT **자기조인** L8310~8323) | **0행** ⛔ |
| `MAX(CUTOFF_TYPE)` | L8892 | **NULL** |
| ETC INSERT | L8901 | **ORA-01400** |

### 근본원인 = 드롭 컬럼 스텁이 NULL 인데 그 컬럼으로 자기조인한다

Oracle 이관 시 `SCM_MST_SITE_ITEM.REPORT_GROUP` 이 존재하지 않아
`NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL)` 스텁으로 치환돼 있다 (**14곳/6줄**).
이 스텁이 `GT_DMF0_REPORT` 의 `CUST_REPORT`(L8219) · `PRODUCT_GROUP`(L8221) 을 **전 행 NULL** 로 만든다.

그런데 L8310~8323 자기조인이 바로 그 컬럼들을 등가비교한다:

    JOIN GT_DMF0_REPORT B ON ...
        AND A.CUST_REPORT   = B.CUST_REPORT      -- NULL = NULL → UNKNOWN
        AND A.PRODUCT_GROUP = B.PRODUCT_GROUP    -- NULL = NULL → UNKNOWN

⇒ **전 행 탈락**. AS-IS(MSSQL)는 `REPORT_GROUP` 이 실제 값을 갖던 컬럼이라 조인이 성립했다.

## 정정 (hook #119 §1.5 센티널 · #127 · `feedback_corporate_schema_dropped_col_save_default`)

스텁 표현식 14곳 전량을 **`'-'`** 로 치환한다. 전 행이 동일 센티널을 가지므로 자기조인이 성립한다.

⚠ **알려진 이관 격차 — 사용자 보고 대상**: 원천 컬럼이 TO-BE 스키마에 없으므로
`CUST_REPORT` / `PRODUCT_GROUP` / `PRODUCT_DETAILS` / (GT)`ATTRIBUTE1` 은 **전 행 `'-'`** 가 된다.
이는 본 수정이 만든 손실이 아니라 **원래부터 값이 없던 것**이며, 지금까지는 그 사실이
"전 행 조용히 소멸"로 나타나던 것을 **명시적 센티널**로 바꾼 것이다.

사용: python dmf0044_reportgroup_stub_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_rptgrp_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_RPTGRP_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2,
    "M.CALC_YN = '-'": 12,
}

STUB_OLD = "NVL(NULL/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→NULL*/, NULL)"
STUB_NEW = "'-'/*SITE_ITEM.REPORT_GROUP 미존재(Oracle마이그레이션)→센티널 RPTGRP-STUB 2026-08-10*/"
EXPECT = 14


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' ORDER BY LINE"""
        )
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음: PKG_DMF0044")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    print("  스텁 %d건 (기대 %d)" % (body.count(STUB_OLD), EXPECT))
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    n = text.count(STUB_OLD)
    if n == 0 and text.count("RPTGRP-STUB") >= 1:
        print("  이미 적용됨 — skip(멱등)")
    elif n != EXPECT:
        sys.exit("[error] 스텁 %d건 (기대 %d건) — 손대지 않음" % (n, EXPECT))
    else:
        text = text.replace(STUB_OLD, STUB_NEW)
        print("  치환 %d건 → 센티널 '-'" % n)
    if text.count(STUB_OLD):
        sys.exit("[error] 스텁 잔존 — 중단")
    if text.count("RPTGRP-STUB") != EXPECT:
        sys.exit("[error] 마커 %d건 (기대 %d) — 중단" % (text.count("RPTGRP-STUB"), EXPECT))
    for m, k in GUARD_MARKS.items():
        if text.count(m) != k:
            sys.exit("[error] 선행 마커 '%s' 소실 (%d≠%d) — 중단" % (m, text.count(m), k))
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    print("  행 수 불변 %s / 선행 마커 5종 유지 ✅"
          % ("✅" if len(text.splitlines()) == len(BACKUP.read_text(encoding='utf-8').splitlines()) else "⚠"))
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
                    "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS "
                    "WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
        for m, k in list(GUARD_MARKS.items()) + [("RPTGRP-STUB", EXPECT)]:
            cur.execute("SELECT NVL(SUM(REGEXP_COUNT(TEXT, :m)),0) FROM ALL_SOURCE "
                        "WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'",
                        {"m": m.replace("(", r"\(").replace(")", r"\)").replace(".", r"\.")})
            got = cur.fetchone()[0]
            print("  마커 '%s' = %d (기대 %d)%s" % (m, got, k, "" if got == k else "  ⛔ 회귀"))
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
