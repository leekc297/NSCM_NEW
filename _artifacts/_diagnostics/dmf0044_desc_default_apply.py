#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_desc_default_apply.py — CREATE / COPY 시 Description 미입력분 초기값 '-' (2026-08-10)

사용자 지시: *"CREATE OR COPY 시 DESC 가 없으면 기존 DESC 값이나 초기값으로 DESC 생성해서 넣어주세요"*
             *"DESC 값 초기값으로 null 일때는 '-' 넣어주세요"*
             *"desc 는 null 이면 초기값 '-' 입니다. 사용자가 입력하지 않은 것 넣지마세요"*

⇒ **사용자가 입력한 값은 그대로**, 미입력(NULL/공백)일 때만 **`'-'`**. 임의 문구 생성 금지.

## 왜 필요한가 (2026-08-10 실사고)

Description 을 비우고 Create/Copy 하면 `VERSION_DESCRIPTION` 이 **NULL** 로 저장되는데,
목록 SP 필터가 `VERSION_DESCRIPTION LIKE '%'||P_DESCRIPTION||'%'` 이고
Oracle 에서 **`NULL LIKE '%'` 은 UNKNOWN** 이라 그 버전이 **목록에서 영구히 사라진다**.
(사용자 신고: "복사된 버전은 어디에 있나요? VERSION 목록에 보이지 않습니다.")

조회측은 `DESCNULL 2026-08-10` 패치로 `NVL(VERSION_DESCRIPTION,'-')` 처리했고,
본 패치는 **저장측에서 NULL 자체가 안 생기게** 한다(hook #119 §1.5 센티널 표준 — 양쪽 다 막는다).

## 대상 (DM_MDF_VERSION INSERT 2곳)

| 액션 | 위치 | 원문 |
|---|---|---|
| CREATE | L7251 | `SELECT p_division_id, V_NEW_VERSION_NO, p_version_description` |
| COPY | L7299 | `SELECT p_division_id, V_NEW_VERSION_NO, p_version_description, VERSION_TYPE, 'N', YYYYMMDD` |

⚠ Oracle 에서 `''` 는 NULL 이므로 `NVL` 하나로 "미입력" 두 경우(NULL·빈문자)가 모두 잡힌다.
   공백만 입력한 경우까지 막으려면 TRIM 이 필요해 `NVL(TRIM(p_version_description), '-')` 로 한다.

사용: python dmf0044_desc_default_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_descdef_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_DESCDEF_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1, "20260805 MERGE-ON 파리티 복원": 1, "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2, "M.CALC_YN = '-'": 12, "RPTGRP-STUB 2026-08-10": 14,
    "NVL(d_Result_Date, '-')": 14, "SEQGRP 2026-08-10": 3, "ETCDEL 2026-08-10": 1,
    "DYNSAMP 2026-08-10": 3, "DYNSAMP2 2026-08-10": 1, "DYNSAMP3 2026-08-10": 1,
    "NODATAGUARD 2026-08-10": 3, "DESCNULL 2026-08-10": 1,
}

T3 = "\t" * 3
DESC_NEW = "NVL(TRIM(p_version_description), '-') /* DESCDEF 2026-08-10 */"

H1_OLD = T3 + "SELECT p_division_id, V_NEW_VERSION_NO, p_version_description\n"
H1_NEW = T3 + "SELECT p_division_id, V_NEW_VERSION_NO, " + DESC_NEW + "\n"

H2_OLD = T3 + "SELECT p_division_id, V_NEW_VERSION_NO, p_version_description, VERSION_TYPE, 'N', YYYYMMDD\n"
H2_NEW = (T3 + "SELECT p_division_id, V_NEW_VERSION_NO, " + DESC_NEW
          + ", VERSION_TYPE, 'N', YYYYMMDD\n")

HUNKS = [("CREATE INSERT", H1_OLD, H1_NEW), ("COPY INSERT", H2_OLD, H2_NEW)]
MARK = ("DESCDEF 2026-08-10", 2)


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
    for name, old, _new in HUNKS:
        got = body.count(old)
        print("  hunk '%s' 앵커 %d (기대 1)%s" % (name, got, "" if got == 1 else "  ⚠"))
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%-24s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    base = len(text.splitlines())
    if MARK[0] in text:
        print("  이미 적용됨 — skip(멱등)")
    else:
        for name, old, new in HUNKS:
            got = text.count(old)
            if got != 1:
                sys.exit("[error] hunk '%s' 앵커 %d건 (기대 1) — 손대지 않음" % (name, got))
            text = text.replace(old, new)
            print("  hunk '%s' 적용" % name)
    if text.count(MARK[0]) != MARK[1]:
        sys.exit("[error] 마커 %d (기대 %d) — 중단" % (text.count(MARK[0]), MARK[1]))
    for m, k in GUARD_MARKS.items():
        if text.count(m) != k:
            sys.exit("[error] 선행 마커 '%s' 소실 (%d≠%d) — 중단" % (m, text.count(m), k))
    if len(text.splitlines()) != base:
        sys.exit("[error] 행 수 변동 — 중단")
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, 행수 불변) / 선행 마커 14종 유지 ✅" % (PATCHED, len(text.splitlines())))
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
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, 'DESCDEF 2026-08-10')),0) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
        print("  배포 후 DESCDEF 마커 =", cur.fetchone()[0])
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
