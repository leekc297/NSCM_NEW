#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_sentinel_pivot_split_fix.py — 저장 후 '유령 행' 결함 정정 (2026-08-11)

## 사고 (사용자 보고)
"조회 시 같은 행이 하나 더 보인다" — 저장하면 div40 조회가 170행 → **171행**이 되고 재조회해도 유지된다.
DATA_SEQ=120 이 4행으로 나오고 그중 `SalesAmt_KRW` 가 **2행**(하나는 값 없는 빈 행).

## 근인 — 센티널 `'-'` 가 저장 재삽입에서 NULL 로 떨어진다
조회는 **Oracle PIVOT**(BODY L618 `PIVOT ( SUM(QTY) FOR YYYYMM IN (...) )`)이다.
PIVOT 의 암묵 GROUP BY = **SELECT 목록의 나머지 전 컬럼**이므로, 컬럼 하나만 값이 달라도 행이 갈라진다.

저장 SP 의 원장 INSERT 2곳(L1084 기존 DATA_SEQ / L1114 채번분)이 아래를 하드코딩한다:
    '' AS DOM_EXP        '' AS INCOTERMS        '' AS PLANT_SITE_ID
Oracle 에서 `''` = **NULL** 이다. 그런데 원장 실측 분포는:
    DOM_EXP / INCOTERMS / PLANT_SITE_ID = **'-' 209,671행 vs NULL 93행**
⇒ 저장된 월만 NULL 이 되고 형제 월(-)과 그룹이 갈라져 **표시 행이 2개**가 된다.
   그중 `INCOTERMS`·`PLANT_SITE_ID` 는 PIVOT SELECT 목록(L609·L611)에 있어 **직접 원인**이다.

## AS-IS 대조 (사용자 지시 — 선행 완료)
· AS-IS `.cs` 는 이 3컬럼을 **한 번도 전달하지 않는다**(정본 1,727행 전수 grep 0건).
· AS-IS MSSQL SP `dbo.DMF0049_SAVE_SALES_ETC_REPORT_C` 도 동일하게
  `'' AS DOM_EXP` / `'' AS INCOTERMS` / `'' AS PLANT_SITE_ID` 를 쓴다(원문 실측).
⇒ **로직 차이가 아니라 방언 차이**다. MSSQL `''` = 빈 문자열(그룹 일치) / Oracle `''` = NULL(그룹 분리).
   TO-BE 원장의 등가값은 센티널 `'-'` 이므로 `'-'` 로 쓴다(hook #119 §1.5 — 오늘 SOLDTO_CODE 와 같은 계보).

⚠ `PROJECT_NAME` 은 **건드리지 않는다** — 원장 209,764행 **전부 NULL** 이라 `'-'` 로 바꾸면
   오히려 기존 행과 그룹이 갈라진다(같은 INSERT 안의 `'' AS PROJECT_NAME` 은 그대로 둔다).

## 조치
① SP 3컬럼 × 2분기 = 6곳 `''` → `'-'`  ② 이미 NULL 로 훼손된 93행 복구  ③ 조회 행수 재검증

사용:
  python dmf0049_sentinel_pivot_split_fix.py --dump / --patch / --deploy / --backfill / --verify
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
BACKUP = OUT / "BACKUP_PKG_DMF0049_BODY_pre_sentinel_20260811.sql"
PATCHED = OUT / "PKG_DMF0049_BODY_SENTINEL_20260811.sql"

MARKER = "PIVOT-SENTINEL"
COLS = ("DOM_EXP", "INCOTERMS", "PLANT_SITE_ID")
EXPECT_EACH = 2  # INSERT 2분기


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
    for c in COLS:
        print("  앵커 '' AS %-14s = %d건 (기대 %d)" % (c, body.count("'' AS " + c), EXPECT_EACH))
    print("  참고 '' AS PROJECT_NAME = %d건 — **의도적으로 유지**" % body.count("'' AS PROJECT_NAME"))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if MARKER in text:
        sys.exit("[error] 이미 적용됨")
    for c in COLS:
        n = text.count("'' AS " + c)
        if n != EXPECT_EACH:
            sys.exit("[error] '' AS %s 앵커 %d건 (기대 %d) — 손대지 않음" % (c, n, EXPECT_EACH))
    for c in COLS:
        text = text.replace("'' AS " + c, "'-' AS " + c)
    # 마커는 주석 1줄로 남긴다(재적용 방지 + 이력 추적)
    text = text.replace(
        "CREATE OR REPLACE ",
        "CREATE OR REPLACE /* [%s 2026-08-11] DOM_EXP/INCOTERMS/PLANT_SITE_ID "
        "''(Oracle=NULL) → '-' 센티널. PIVOT 암묵 GROUP BY 분리로 유령 행 발생하던 것 정정. "
        "PROJECT_NAME 은 원장 전량 NULL 이라 제외 */ " % MARKER, 1)
    if text.count("'-' AS ") < len(COLS) * EXPECT_EACH:
        sys.exit("[error] 치환 결과 부족")
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s — %d곳 치환 ✅" % (PATCHED, len(COLS) * EXPECT_EACH))
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


def cmd_backfill():
    """이미 NULL 로 훼손된 행 복구 — 3컬럼이 **모두** NULL 인 행만(부분 NULL 은 사람이 판단)."""
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C
                        WHERE DOM_EXP IS NULL AND INCOTERMS IS NULL AND PLANT_SITE_ID IS NULL""")
        n_all = cur.fetchone()[0]
        cur.execute("""SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C
                        WHERE (DOM_EXP IS NULL OR INCOTERMS IS NULL OR PLANT_SITE_ID IS NULL)
                          AND NOT (DOM_EXP IS NULL AND INCOTERMS IS NULL AND PLANT_SITE_ID IS NULL)""")
        n_part = cur.fetchone()[0]
        print("  3컬럼 전부 NULL = %d행 (복구 대상) / 부분 NULL = %d행 (제외 — 수동 판단)"
              % (n_all, n_part))
        if n_part:
            print("  ⚠ 부분 NULL 이 있으므로 전량 일괄 처리하지 않는다")
        cur.execute("""
            UPDATE DM_PLN_SALES_ETC_REPORT_C
               SET DOM_EXP = '-', INCOTERMS = '-', PLANT_SITE_ID = '-',
                   LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
             WHERE DOM_EXP IS NULL AND INCOTERMS IS NULL AND PLANT_SITE_ID IS NULL
        """)
        print("  [update] %d행" % cur.rowcount)
        con.commit()
    return 0


def cmd_verify():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
                       AND NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY' AND INSTR(TEXT,:m)>0""",
                    m=MARKER)
        print("  마커 %d행 / " % cur.fetchone()[0], end="")
        cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                       AND OBJECT_NAME='PKG_DMF0049' AND OBJECT_TYPE='PACKAGE BODY'""")
        print("BODY %s" % cur.fetchone()[0])
        for c in COLS:
            cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE %s IS NULL" % c)
            print("  원장 %-14s NULL 잔여 %d행 (기대 0)" % (c, cur.fetchone()[0]))
    return 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "patch", "deploy", "backfill", "verify"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    for f in ("dump", "patch", "deploy", "backfill", "verify"):
        if getattr(a, f):
            sys.exit(globals()["cmd_" + f]())
    ap.error("--dump / --patch / --deploy / --backfill / --verify 중 하나 필요")


if __name__ == "__main__":
    main()
