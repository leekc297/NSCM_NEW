#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_result_date_null_apply.py — `YYYYMMDD > d_Result_Date` NULL 비교 전멸 정정 (2026-08-10)

## 결함 (사용자 지시 "SP, BP 각각 … VERSION COPY … 기능 확인해주세요" 실행 중 발견)

    VERSION COPY (실적 미포함) → ORA-01400 CUTOFF_TYPE (PKG_DMF0044 L8954)

L8954 는 `V_ETC_CUTOFF_TYPE`(L8892 `SELECT MAX(CUTOFF_TYPE) … WHERE VERSION_NO=V_NEW_VERSION_NO`)를 쓰는데,
CP 경로의 `DM_PLN_SALES_PLAN_REPORT_C` 적재가 **0행**이라 NULL 이 된다.

### 근본원인 = `''` vs NULL 비교 의미 차이 (MSSQL↔Oracle) — `''`=NULL 계보 4번째 형태

L7077 `d_Result_Date := REPLACE(p_result_date, '-', '');`
- **MSSQL**: 실적 미포함이면 `''`(빈 문자열, NOT NULL). `A.YYYYMMDD > ''` → **모든 날짜에 대해 TRUE** ⇒ 전량 복사.
- **Oracle**: `''` 은 **NULL**. `A.YYYYMMDD > NULL` → **UNKNOWN** ⇒ **0행**.

⇒ 실적 미포함 COPY 는 미래구간을 **하나도 복사하지 못한다**.

## 정정 범위 — ⚠ 방향에 따라 다르다. 일괄 치환 금지

| 방향 | 의미 | NULL 일 때 AS-IS(MSSQL) | Oracle 현행 | 조치 |
|---|---|---|---|---|
| `>` · `>=` | **미래구간** 복사 | `> ''` = **항상 참** → 전량 | UNKNOWN → 0행 | ⛔ 불일치 → **`NVL(d_Result_Date,'-')`** (14곳) |
| `<` · `<=` | **과거실적구간** 복사 | `< ''` = **항상 거짓** → 0행 | UNKNOWN → 0행 | ✅ 동작 동일 → **손대지 않음** (13곳) |

`'-'`(0x2D) < `'0'`(0x30) 이므로 `YYYYMMDD > '-'` 는 모든 8자리 숫자 문자열에 대해 참 —
MSSQL `> ''` 와 **정확히 같은 의미**이며 센티널 표준(hook #119 §1.5)과도 일치한다.

과거구간 쪽 일부에는 이미 `AND d_Result_Date IS NOT NULL` 가드가 붙어 있어(L7865/7894/7919/7944/7974/8002/8035)
"NULL 이면 과거구간은 안 가져온다"가 **의도된 설계**임을 스스로 증언한다. 그래서 건드리지 않는다.

⚠ CR 경로(L7375 등)는 `d_Result_Date` 가 `DM_MST_VERSION` 에서 채워져 보통 NOT NULL 이므로 NVL 은 no-op.
다만 L7074 `EXCEPTION WHEN NO_DATA_FOUND THEN d_Result_Date := NULL` 경로에서는 동일하게 전멸하던 것이
정상(전량 복사)으로 바뀐다 — AS-IS 파리티 방향.

사용: python dmf0044_result_date_null_apply.py --dump / --patch / --deploy
"""
import argparse
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate"
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_rsltdate_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_RSLTDATE_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2,
    "M.CALC_YN = '-'": 12,
    "RPTGRP-STUB 2026-08-10": 14,
}

# 미래구간(> / >=)만 — `<`/`<=` 는 `>` 를 요구하는 이 패턴에 걸리지 않는다
FUTURE = re.compile(r"(YYYYMMDD\s*>\s*=?\s*|YYYYMMDD\s*>=\s*)d_Result_Date", re.IGNORECASE)
NEW = r"\1NVL(d_Result_Date, '-')"
EXPECT = 14
# 손대면 안 되는 과거구간 — 치환 후에도 건수가 유지되어야 한다
PAST = re.compile(r"YYYYMMDD\s*<\s*=?\s*d_Result_Date", re.IGNORECASE)
PAST_EXPECT = 13


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
    print("  미래구간(>,>=) = %d (기대 %d)" % (len(FUTURE.findall(body)), EXPECT))
    print("  과거구간(<,<=) = %d (기대 %d, 불변 대상)" % (len(PAST.findall(body)), PAST_EXPECT))
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    past_before = len(PAST.findall(text))
    n = len(FUTURE.findall(text))
    if n == 0 and "NVL(d_Result_Date, '-')" in text:
        print("  이미 적용됨 — skip(멱등)")
    elif n != EXPECT:
        sys.exit("[error] 미래구간 %d건 (기대 %d건) — 손대지 않음" % (n, EXPECT))
    else:
        text = FUTURE.sub(NEW, text)
        print("  치환 %d건 → NVL(d_Result_Date, '-')  [미래구간만]" % n)

    if len(FUTURE.findall(text)):
        sys.exit("[error] 미래구간 잔존 — 중단")
    if text.count("NVL(d_Result_Date, '-')") != EXPECT:
        sys.exit("[error] NVL 결과 %d건 (기대 %d) — 중단" % (text.count("NVL(d_Result_Date, '-')"), EXPECT))
    # ⭐ 과거구간은 단 1건도 변하면 안 된다
    if len(PAST.findall(text)) != past_before or past_before != PAST_EXPECT:
        sys.exit("[error] 과거구간 건수 변동 (%d → %d, 기대 %d) — 중단"
                 % (past_before, len(PAST.findall(text)), PAST_EXPECT))
    for m, k in GUARD_MARKS.items():
        if text.count(m) != k:
            sys.exit("[error] 선행 마커 '%s' 소실 (%d≠%d) — 중단" % (m, text.count(m), k))
    if len(text.splitlines()) != len(BACKUP.read_text(encoding="utf-8").splitlines()):
        sys.exit("[error] 행 수 변동 — 중단")
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    print("  과거구간 %d건 불변 ✅ / 선행 마커 6종 유지 ✅ / 행 수 불변 ✅" % PAST_EXPECT)
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
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, 'NVL\\(d_Result_Date, ''-''\\)', 1, 'i')),0)
                         FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
        print("  배포 후 NVL(d_Result_Date,'-') = %d (기대 %d)" % (cur.fetchone()[0], EXPECT))
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
