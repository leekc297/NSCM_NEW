#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_measure_dup_apply.py — GET_MEASURE 권한뷰 INNER JOIN 행 곱셈 정정 (2026-08-10)

사용자 신고: *"INSERT 시 하나의 메저에 8개 ROW 가 추가된채 KRW, LOC 2개가 생성되어 16개 ROW"*

## 실측 근본원인

`PKG_DMF0044.P_DMF0044_GET_MEASURE` L979~1000:

    FROM SCM_MST_SHEET_MEASURE T1
      INNER JOIN (SELECT * FROM SCM_ADM_USER_MNU_EDIT_AUTH_V WHERE USER_ID=… ) T2
        ON T2.UNIT_ID IN ( T1.DIVISION_ID 콤마 분해 )

| 항목 | 실측 |
|---|---:|
| 원천 `SCM_MST_SHEET_MEASURE` | **2행** (SalesAmt_KRW / SalesAmt_LOC) |
| 각 행 `DIVISION_ID` | `40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG` (8개) |
| 사용자 편집권한 행(minyonglee1) | **8행** |
| 조인 결과 | **2 × 8 = 16행** ⛔ |

`T2` 는 **`EDIT_YN` 한 컬럼**을 얻으려고 붙인 조인인데 행을 곱한다.
**권한을 많이 가진 사용자일수록 더 많이 복제**되는 잠복 결함(권한 1개면 증상 없음).

## 정정 — 의미 보존

`INNER JOIN` 을 **① EXISTS(노출 필터) + ② MAX 스칼라(EDIT_YN)** 로 분리한다.
- EXISTS = "권한 있는 division 이 하나라도 있으면 노출" (기존 INNER JOIN 필터와 동일)
- MAX(EDIT_YN) = **보유 권한 합집합**('Y' 우선) — hook #128 AUTHUNION 정책과 정합

실측 검증: 현행 16행 → 정정안 **2행** (SalesAmt_KRW EDIT_YN=Y / SalesAmt_LOC EDIT_YN=Y).

⚠ 같은 패턴(`SCM_ADM_USER_MNU_EDIT_AUTH_V` INNER JOIN)이 **27개 객체**에 있다.
   전부가 결함은 아니며(division 1개·권한 1행이면 무증상) 본 패치는 **DMF0044 만** 고친다.
   나머지는 목록만 남기고 해당 화면 작업 시점에 판정한다(#127 §1.1 회귀 관리 단위 유지).

사용: python dmf0044_measure_dup_apply.py --dump / --patch / --deploy
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

OUT = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate"
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_msrdup_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_MSRDUP_20260810.sql"

MARK = ("MSRDUP 2026-08-10", 1)

OLD = """    SELECT
            COLUMN_NAME  AS CODE
            , COLUMN_LABEL_NAME  AS NAME
            , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM SCM_MST_SHEET_MEASURE T1
        INNER JOIN (SELECT * -- EDIT_YN
         FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
         WHERE USER_ID = P_USER_ID
         AND MNU_ID = P_MNU_ID
         AND UNIT_TP_CD = 'D') T2
         ON T2.UNIT_ID in (
             SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
             FROM   DUAL
             CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
         )
"""

NEW = """    -- MSRDUP 2026-08-10: 권한뷰 INNER JOIN 이 행을 곱해 measure 2행 → 16행이 되던 결함.
    --   (measure DIVISION_ID 콤마목록 8개 × 사용자 보유 권한 8행 = 8배 복제. 권한 많을수록 심함)
    --   EDIT_YN 한 컬럼을 얻으려던 조인을 EXISTS(노출 필터) + MAX 스칼라(EDIT_YN)로 분리한다.
    --   MAX 는 보유 권한 합집합('Y' 우선) — AUTHUNION 정책과 정합.
    SELECT
            COLUMN_NAME  AS CODE
            , COLUMN_LABEL_NAME  AS NAME
            , NVL((SELECT MAX(T2.EDIT_YN)
                     FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2
                    WHERE T2.USER_ID = P_USER_ID
                      AND T2.MNU_ID = P_MNU_ID
                      AND T2.UNIT_TP_CD = 'D'
                      AND T2.UNIT_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )), 'N') AS EDIT_YN
    FROM SCM_MST_SHEET_MEASURE T1
"""

EXTRA_OLD = """    WHERE  1 = 1
    AND    PROGRAM_ID  = 'DMF0044'
    AND    SHEET_NAME  = 'MDF Reports'
    AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC')
    ORDER BY SORT_ORDER_NO;
"""
EXTRA_NEW = """    WHERE  1 = 1
    AND    PROGRAM_ID  = 'DMF0044'
    AND    SHEET_NAME  = 'MDF Reports'
    AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC')
    AND    EXISTS (SELECT 1 FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2
                    WHERE T2.USER_ID = P_USER_ID
                      AND T2.MNU_ID = P_MNU_ID
                      AND T2.UNIT_TP_CD = 'D'
                      AND T2.UNIT_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      ))
    ORDER BY SORT_ORDER_NO;
"""


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


def guard_marks(body):
    """dump 시점 live 값을 기준으로 삼는다(다른 주체가 같은 패키지를 고칠 수 있음)."""
    keys = ["AUTHUNION 2026-08-09", "PIVOTSEL 2026-08-10", "PRODUCTDETAIL 2026-08-10",
            "M.CALC_YN = '-'", "RPTGRP-STUB 2026-08-10", "NVL(d_Result_Date, '-')",
            "SEQGRP 2026-08-10", "ETCDEL 2026-08-10", "NODATAGUARD 2026-08-10",
            "DESCNULL 2026-08-10", "DESCDEF 2026-08-10", "TUNE-M 2026-08-10",
            "TUNE-M2 2026-08-10"]
    return {k: body.count(k) for k in keys}


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    print("  앵커① SELECT/INNER JOIN = %d (기대 1)" % body.count(OLD))
    print("  앵커② WHERE/ORDER BY    = %d (기대 1)" % body.count(EXTRA_OLD))
    for k, v in guard_marks(body).items():
        print("  선행 마커 %-26s %d" % (k, v))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    base_txt = BACKUP.read_text(encoding="utf-8")
    marks0 = guard_marks(base_txt)
    text = base_txt
    if MARK[0] in text:
        print("  이미 적용됨 — skip(멱등)")
    else:
        for i, (old, new) in enumerate(((OLD, NEW), (EXTRA_OLD, EXTRA_NEW)), 1):
            n = text.count(old)
            if n != 1:
                sys.exit("[error] 앵커%d %d건 (기대 1) — 손대지 않음" % (i, n))
            text = text.replace(old, new)
            print("  앵커%d 치환" % i)
    if text.count(MARK[0]) != MARK[1]:
        sys.exit("[error] 마커 %d (기대 %d) — 중단" % (text.count(MARK[0]), MARK[1]))
    for k, v in guard_marks(text).items():
        if v != marks0[k]:
            sys.exit("[error] 선행 마커 '%s' 변동 (%d→%d) — 중단" % (k, marks0[k], v))
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, %+d) / 선행 마커 13종 불변 ✅"
          % (PATCHED, len(text.splitlines()),
             len(text.splitlines()) - len(base_txt.splitlines())))
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
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'")
        errs = cur.fetchone()[0]
        print("  errors =", errs)
        if errs:
            cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
            for e in cur.fetchall():
                print("   ⛔ L%s:%s %s" % e)
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
