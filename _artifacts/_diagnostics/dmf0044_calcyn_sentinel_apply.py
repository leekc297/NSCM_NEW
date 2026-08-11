#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_calcyn_sentinel_apply.py — `CALC_YN = ''` 상시거짓 JOIN 정정 (2026-08-10)

## 결함 (사용자 신고 "VERSION CREATE 시 SQL ERROR" — 3번째 껍질, **근본원인**)

    ORA-01400: NULL을 "SCM_MGR"."DM_PLN_SALES_ETC_REPORT_C"."CUTOFF_TYPE" 안에 삽입할 수 없습니다
    BACKTRACE=ORA-06512: "SCM_MGR.PKG_DMF0044", 8901행

L8892 `SELECT MAX(CUTOFF_TYPE) INTO V_ETC_CUTOFF_TYPE FROM DM_PLN_SALES_PLAN_REPORT_C
WHERE VERSION_NO = V_NEW_VERSION_NO` 가 NULL 을 돌려주기 때문인데, 그 이유는
**선행 복사가 0행**이었기 때문이다. 0행의 원인이 아래다.

### 근본원인 = `''` = NULL (Oracle) — 상시 거짓 JOIN

| 위치 | 원문 | Oracle 결과 |
|---|---|---|
| L7328 (GT 적재) | `CASE WHEN … THEN 'Y' ELSE **''** END` → `CALC_YN` | `''` = **NULL** 로 저장 |
| L7372 외 **12곳** | `JOIN GT_DMF0_MEASURE M ON … AND M.CALC_YN = **''**` | `NULL = ''` → **UNKNOWN → 0행** |

⇒ `GT_DMF0_VERSION_COPY` 0행 → `DM_PLN_SALES_PLAN_REPORT_C` 0행 → `MAX()` NULL → ORA-01400.

AS-IS(MSSQL)는 `''` 가 **실제 빈 문자열**이라 `CALC_YN = ''` 가 정상 매칭됐다.
메모리 `project_dmf0049_etc_sales_reports_status` 에 "**AS-IS `CALC_YN=''` JOIN 11곳 = 상시 false
서버측 잠재결함(BE 무수정·인지만)**" 으로 기록돼 있었으나, **TO-BE 에서는 잠재가 아니라 실차단**이었다.

## 정정 (hook #119 §1.5 · #127 — 센티널 `'-'`)
- 적재 `ELSE ''` → `ELSE '-'`
- 비교 `M.CALC_YN = ''` → `M.CALC_YN = '-'`
⇒ AS-IS 의미("계산 대상 아님" 표식) 그대로 보존하면서 Oracle 에서 매칭된다.

⚠ **적재와 비교는 반드시 쌍으로** 바꾼다. 한쪽만 바꾸면 여전히 0행이다.

사용: python dmf0044_calcyn_sentinel_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_calcyn_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_CALCYN_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2,
}

# (원문, 치환문, 기대 건수) — 건수는 live 실측(2026-08-10)
LOAD_OLD = "CASE WHEN SEGMENT4 <> SEGMENT5 AND ATTRIBUTE2 IS NOT NULL THEN 'Y' ELSE '' END"
LOAD_NEW = "CASE WHEN SEGMENT4 <> SEGMENT5 AND ATTRIBUTE2 IS NOT NULL THEN 'Y' ELSE '-' END"
CMP_OLD = "M.CALC_YN = ''"
CMP_NEW = "M.CALC_YN = '-'"
HUNKS = [(LOAD_OLD, LOAD_NEW, 1), (CMP_OLD, CMP_NEW, 12)]


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
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    for i, (old, new, cnt) in enumerate(HUNKS, 1):
        n = text.count(old)
        if n == 0 and text.count(new) >= 1:
            print("  hunk#%d 이미 적용됨 — skip(멱등)" % i)
            continue
        if n != cnt:
            sys.exit("[error] hunk#%d 치환 대상 %d건 (기대 %d건) — 손대지 않음" % (i, n, cnt))
        text = text.replace(old, new)
        print("  hunk#%d 치환 %d건" % (i, n))
    # ⭐ 적재↔비교 쌍 일치 단언 — 한쪽만 남으면 여전히 0행이다
    if text.count(LOAD_OLD) or text.count(CMP_OLD):
        sys.exit("[error] `''` 형태 잔존 — 적재/비교 쌍 불일치. 중단")
    if text.count(CMP_NEW) != 12:
        sys.exit("[error] 비교 치환 결과 %d건 (기대 12) — 중단" % text.count(CMP_NEW))
    for m, n in GUARD_MARKS.items():
        if text.count(m) != n:
            sys.exit("[error] 선행 마커 '%s' 소실 — 중단" % m)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    print("  적재 1 + 비교 12 쌍 일치 ✅ / 선행 마커 4종 유지 ✅")
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
        for m, n in GUARD_MARKS.items():
            cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' "
                        "AND TYPE='PACKAGE BODY' AND INSTR(TEXT, :m) > 0", {"m": m})
            got = cur.fetchone()[0]
            print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⛔ 회귀"))
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
