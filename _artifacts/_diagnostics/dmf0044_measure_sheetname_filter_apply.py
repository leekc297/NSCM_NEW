#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_measure_sheetname_filter_apply.py — 조회값 2배 표시 정정 (2026-08-11)

## 결함
`P_DMF0044_GET_SALES_REPORTS_DATA` 의 메저 GTT 적재부가 **SHEET_NAME 을 안 건다**:

    INSERT INTO GT_F044_SELECT_MEASURE (...)
    SELECT U.PROGRAM_ID, U.SHEET_NAME, U.USER_ID, U.COLUMN_NAME, U.SORT_ORDER_NO
    FROM   SCM_MST_TITLESET_USER U
    WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE='M'
    AND    U.PROGRAM_ID = 'DMF0044'
    AND    U.USER_ID    = P_CREATED_BY;      -- ⛔ SHEET_NAME 조건 없음

`SCM_MST_TITLESET_USER` 에는 현행 `'MDF Reports'` 와 레거시 `'mdfReports'` 두 변형이 공존한다.
최종 쿼리가 `GT_F044_T A JOIN GT_F044_SELECT_MEASURE B ON A.MEASURE = B.MEASURE` 이므로
중복된 메저의 **모든 행이 2배**가 된다 — SORT_ORDER_NO 가 같으면 PIVOT 이 합쳐 **금액 2배**,
다르면 **행 2벌**. 원장·GT_F044_T 는 정확한데 화면만 틀리는 전형적 "집계 전 조인 fan-out".

## 정본 근거 — 같은 SP 안에 답이 이미 있다 (신규 발명 0)
  * L1215 사용자메저 **존재 확인**  : `AND U.SHEET_NAME = 'MDF Reports'`
  * L1254 기본 titleset **시드**    : `AND C.SHEET_NAME = 'MDF Reports'`
  * L1271 GTT 적재                  : (누락)  ← 이 한 줄만 빠졌다
⇒ 적재부에도 동일 조건을 넣는 것이 이 SP 자신의 규약이다.

## 빈 그리드 우려 없음
적재 직전 L1224~1257 이 "'MDF Reports' 사용자메저가 없으면 `SCM_MST_SHEET_MEASURE` 기본셋으로
시드"하므로, 적재 시점에는 **모든 사용자가 'MDF Reports' 행을 보유**한다.

## 부수 효과 (보고 대상)
레거시 시트에만 있던 추가 메저(예: dong.lee2 의 RTF/RTF_CELL/RTF_ENG)는 더 이상 표시되지 않는다.
현행 시트의 titleset UI 가 관리하지 못하는 행이라 **끌 수도 없던** 상태였으므로 정상화에 해당하며,
필요하면 titleset 화면에서 다시 선택하면 된다.

사용:
  python dmf0044_measure_sheetname_filter_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_msrsheet_20260811.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_MSRSHEET_20260811.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
    "TUNE-V": 2,
    "ETCWB": 8,          # 직전 적용분 (ETC 저장 반영)
}

_OLD = (
    "    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'\n"
    "    AND U.PROGRAM_ID   = 'DMF0044'\n"
    "    AND U.USER_ID      = P_CREATED_BY;\n"
)
_NEW = (
    "    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'\n"
    "    AND U.PROGRAM_ID   = 'DMF0044'\n"
    "    -- [MSRSHEET 2026-08-11] SHEET_NAME 누락 → 레거시 'mdfReports' 행까지 함께 적재되어\n"
    "    --   최종 JOIN(A.MEASURE = B.MEASURE)에서 해당 메저의 모든 행이 2배가 됐다.\n"
    "    --   같은 SP 의 존재확인(L1215)·시드(L1254)와 동일 조건으로 맞춘다.\n"
    "    AND U.SHEET_NAME   = 'MDF Reports'\n"
    "    AND U.USER_ID      = P_CREATED_BY;\n"
)


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
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if "MSRSHEET" in text:
        sys.exit("[error] 이미 적용됨 — 중단")
    n = text.count(_OLD)
    if n != 1:
        sys.exit("[error] 앵커 %d건 (기대 1건) — 손대지 않음" % n)
    text = text.replace(_OLD, _NEW)
    for m, c in GUARD_MARKS.items():
        if text.count(m) != c:
            sys.exit("[error] 선행 마커 '%s' 소실 — 중단" % m)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    print("  SHEET_NAME 필터 추가 ✅ / 선행 마커 %d종 유지 ✅" % len(GUARD_MARKS))
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
        for m in list(GUARD_MARKS) + ["MSRSHEET"]:
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
