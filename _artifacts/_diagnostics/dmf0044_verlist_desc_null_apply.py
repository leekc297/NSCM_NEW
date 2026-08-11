#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_verlist_desc_null_apply.py — Description 미입력 버전이 목록에서 사라지는 결함 (2026-08-10)

사용자 신고: *"R_S_20260128_V002_C 을 선택해서 VERSION COPY 를 진행했습니다.
             복사된 버전은 어디에 있나요? VERSION 목록에 보이지 않습니다."*

## 실측 — 복사는 **정상 수행**됐다

    DM_MDF_VERSION 오늘 생성분
      R_S_20260810_V003_C  type=REPORT_SP_W  send=N  17:29:11  desc=<NULL>
      R_S_20260810_V004_C  type=REPORT_SP_W  send=N  17:48:43  desc=<NULL>

그런데 팝업 목록(`P_DMF0044_GET_SALES_VERSION_POPUP` L1782)이 이들을 **필터로 떨어뜨린다**:

    AND VERSION_DESCRIPTION LIKE '%' || P_DESCRIPTION || '%'

- Description 을 비우고 Create/Copy 하면 `VERSION_DESCRIPTION` 이 **NULL** 로 저장된다
- Oracle 에서 **`NULL LIKE '%'` 은 TRUE 가 아니라 UNKNOWN** → WHERE 절에서 탈락
- ⇒ 만든 버전이 **영구히 목록에 안 보인다**(SEND_YN 도 정상, 기간도 정상인데)

MSSQL 은 `''`(빈 문자열)이 값이라 `'' LIKE '%'` = TRUE 로 통과했다.
Oracle 은 `''` = NULL 이므로 **저장·조회 양쪽에서 같은 뿌리로 깨진다** — hook #119/#127 계보.

### 실측 대조 (division 40, 오늘 생성 REPORT_SP_W)

| 필터식 | 결과 |
|---|---|
| 현행 `VERSION_DESCRIPTION LIKE '%'` | **0 행** ⛔ |
| 정정 `NVL(VERSION_DESCRIPTION,'-') LIKE '%'` | **3 행** ✅ |

전 원장 영향 규모: `VERSION_DESCRIPTION IS NULL AND SEND_YN <> 'D'` = division 40 **3건**(전부 오늘 생성분).

## 정정

목록 SP 의 필터를 `NVL(VERSION_DESCRIPTION, '-')` 로 감싼다(hook #119 센티널).
- 검색어가 있을 때의 동작은 **불변**(설명이 NULL 인 행은 어차피 검색어에 안 걸린다)
- 검색어가 빈 값일 때만 NULL 행이 **복귀**한다 = AS-IS(MSSQL) 와 동일 동작

⚠ `REPORT%` 분기(L1776~1784)와 그 외 분기(L1808~) **양쪽 모두** 같은 패턴이 있는지 확인해 함께 고친다.

사용: python dmf0044_verlist_desc_null_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_descnull_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_DESCNULL_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1, "20260805 MERGE-ON 파리티 복원": 1, "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2, "M.CALC_YN = '-'": 12, "RPTGRP-STUB 2026-08-10": 14,
    "NVL(d_Result_Date, '-')": 14, "SEQGRP 2026-08-10": 3, "ETCDEL 2026-08-10": 1,
    "DYNSAMP 2026-08-10": 3, "DYNSAMP2 2026-08-10": 1, "DYNSAMP3 2026-08-10": 1,
    "NODATAGUARD 2026-08-10": 3,
}

OLD = "VERSION_DESCRIPTION LIKE '%' || P_DESCRIPTION || '%'"
NEW = "NVL(VERSION_DESCRIPTION, '-') LIKE '%' || P_DESCRIPTION || '%' /* DESCNULL 2026-08-10 */"
MARK = "DESCNULL 2026-08-10"


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
    print("  대상 패턴 %d곳" % body.count(OLD))
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%-24s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    base = len(text.splitlines())
    n = text.count(OLD)
    if n == 0 and MARK in text:
        print("  이미 적용됨 — skip(멱등)")
    elif n == 0:
        sys.exit("[error] 대상 0곳 — 앵커 확인 필요")
    else:
        text = text.replace(OLD, NEW)
        print("  치환 %d곳 → NVL(VERSION_DESCRIPTION, '-')" % n)
    if text.count(OLD):
        sys.exit("[error] 원본 패턴 잔존 — 중단")
    if text.count(MARK) != n:
        sys.exit("[error] 마커 %d (기대 %d) — 중단" % (text.count(MARK), n))
    for m, k in GUARD_MARKS.items():
        if text.count(m) != k:
            sys.exit("[error] 선행 마커 '%s' 소실 (%d≠%d) — 중단" % (m, text.count(m), k))
    if len(text.splitlines()) != base:
        sys.exit("[error] 행 수 변동 — 중단")
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, 행수 불변) / 선행 마커 13종 유지 ✅" % (PATCHED, len(text.splitlines())))
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
        cur.execute("""SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'""")
        errs = cur.fetchone()[0]
        print("  errors =", errs)
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, 'DESCNULL 2026-08-10')),0) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
        print("  배포 후 DESCNULL 마커 =", cur.fetchone()[0])
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
