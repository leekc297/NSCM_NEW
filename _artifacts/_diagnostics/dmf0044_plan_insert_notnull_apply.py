#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_plan_insert_notnull_apply.py — ETC 신규행 저장 시 PLAN INSERT NOT NULL 위반 정정 (2026-08-11)

## 사고
ETC 에서 행 추가 후 저장 → `ORA-01400: NULL을 ("DM_PLN_SALES_PLAN_REPORT_C"."DEPARTMENT_NAME") 안에
삽입할 수 없습니다`.

## 원인 (변환 함정 — hook #119)
AS-IS `.cs` 는 InsertRow 에서 `DEPARTMENT_NAME`/`DEPT_NAME` 을 **잠그기만 하고 값을 채우지 않는다**
(L996~999 `LockRange` 만, `SetValue` 없음). 따라서 저장 payload 는 빈 문자열로 온다.
MSSQL 은 `''` 가 NOT NULL 을 **통과**하지만 Oracle 은 `''` = NULL 이라 **위반**한다.

그동안 드러나지 않은 이유 = 신규행 payload 의 `P_CUTOFF_TYPE` 이 빈값이라
`IF v_cutoff_type = 'REPORT_SP_W'` 분기가 통째로 skip 되어 **PLAN 저장이 아예 실행되지 않았다**
(성공 토스트만 뜨고 원장에 아무것도 안 써지는 조용한 무동작). FE 가 CUTOFF_TYPE 을 싣기 시작하면서
비로소 이 INSERT 가 실행되고 결함이 표면화됐다.

## 조치
PLAN MERGE `WHEN NOT MATCHED` INSERT 의 **NOT NULL × 무가드 8컬럼**에 센티널 `'-'` 적용.
대상(= PLAN_REPORT_C NULLABLE='N' ∩ payload 유래 ∩ 현재 무가드):
  DEPARTMENT_ID / DEPARTMENT_NAME / DEPT_ID / DEPT_NAME
  END_CUST_REPORT / CUST_REPORT / PRODUCT_GROUP / COMPANY_ID
(이미 가드된 것: DIVISION_ID·ITEM_ID·MEASURE·YYYYMMDD·CURRENCY = NVL(...,'-'),
 PROJECT_CODE·SCM_SITE_ID·FCST_TYPE·INCOTERMS·PLANT_SITE_ID·CELL_PROD_SITE = 리터럴 '-')

⚠ ETC 쪽(ETCWB) `CUTOFF_TYPE` 은 **의도적으로 가드하지 않는다** — '-' 로 넣으면 GET 이
`R.CUTOFF_TYPE = P_MDF_TYPE` 로 거르므로 **영원히 안 보이는 유령 행**이 된다.
FE 가 항상 조회 Report Type 을 싣도록 고쳤으므로(신규행 CUTOFF_TYPE), 빈값이면 오류로 드러나는 편이 낫다.

사용:
  python dmf0044_plan_insert_notnull_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_planins_20260811.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_PLANINS_20260811.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
    "TUNE-V": 2,
    "ETCWB": 8,
    "MSRSHEET": 1,
}

# live 원문 실측 — PLAN MERGE WHEN NOT MATCHED 의 VALUES 목록 앞부분
_OLD = """                B.VERSION_NO,
                B.CUTOFF_TYPE,
                B.CUTOFF_YYYYMMDD,
                B.DEPARTMENT_ID,
                B.DEPARTMENT_NAME,
                B.DEPT_ID,
                B.DEPT_NAME,
                B.END_CUST_REPORT,
                B.CUST_REPORT,
                B.PRODUCT_GROUP,
"""
_NEW = """                B.VERSION_NO,
                B.CUTOFF_TYPE,
                B.CUTOFF_YYYYMMDD,
                -- [PLANINS 2026-08-11] AS-IS 는 InsertRow 에서 이 이름 컬럼들을 잠그기만 하고 채우지 않아
                --   payload 가 빈 문자열로 온다. MSSQL 은 ''가 NOT NULL 통과 / Oracle 은 ''=NULL → ORA-01400.
                --   hook #119 센티널 규약으로 보정한다(AS-IS 의 '' 저장과 의미 등가).
                NVL(B.DEPARTMENT_ID, '-'),
                NVL(B.DEPARTMENT_NAME, '-'),
                NVL(B.DEPT_ID, '-'),
                NVL(B.DEPT_NAME, '-'),
                NVL(B.END_CUST_REPORT, '-'),
                NVL(B.CUST_REPORT, '-'),
                NVL(B.PRODUCT_GROUP, '-'),
"""
_OLD2 = "                B.COMPANY_ID,\n                B.QTY,\n"
_NEW2 = "                NVL(B.COMPANY_ID, '-'),\n                B.QTY,\n"


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE
                       WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                       ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    for i, h in enumerate((_OLD, _OLD2), 1):
        print("  hunk#%d 앵커 = %d건" % (i, body.count(h)))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if "PLANINS" in text:
        sys.exit("[error] 이미 적용됨")
    for i, (old, new) in enumerate(((_OLD, _NEW), (_OLD2, _NEW2)), 1):
        n = text.count(old)
        if n != 1:
            sys.exit("[error] hunk#%d 앵커 %d건 (기대 1) — 손대지 않음" % (i, n))
        text = text.replace(old, new)
    for m, c in GUARD_MARKS.items():
        if text.count(m) != c:
            sys.exit("[error] 선행 마커 '%s' 소실" % m)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    print("  NOT NULL 센티널 8컬럼 적용 ✅ / 선행 마커 %d종 유지 ✅" % len(GUARD_MARKS))
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
        for m in list(GUARD_MARKS) + ["PLANINS"]:
            cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' "
                        "AND TYPE='PACKAGE BODY' AND INSTR(TEXT, :m) > 0", {"m": m})
            print("  마커 '%s' = %d" % (m, cur.fetchone()[0]))
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
