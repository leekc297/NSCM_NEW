#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_editflag_std_apply.py — 조회 EDIT_FLAG 을 표준(권한 뷰) 방식으로 (2026-08-10)

사용자 지시: *"특별하게 처리하지말고 조회 시 EDIT_FLAG 을 사용하는 기존 패턴을 그대로 사용해서
             BACKCOLOR 와 EDIT 가능하도록 하는 것을 적용해주세요."*

## 표준 패턴이란 (같은 패키지 안의 다른 SP 들이 이미 쓰는 방식)

    , NVL(T2.EDIT_YN,'N') AS EDIT_YN     -- 원천 = SCM_ADM_USER_MNU_EDIT_AUTH_V

예) `P_DMF0044_GET_SALES_VERSION_POPUP` L1767, `P_DMF0044_GET_MEASURE` L983.
FE 공용 `DataGrid` 는 이 값을 컬럼 `_inputEditType` 과 묶어 **색(노란색)과 편집 가능 여부를
하나의 기준으로** 판정한다(`GridUtils.isEditableCell`).

## 현행 DMF0044 메인 조회의 이탈 (실측)

`P_DMF0044_GET_SALES_REPORTS_DATA` 는 표준을 안 쓰고 자체 분기를 쓴다:

| 위치 | 현행 식 | 실측 결과 |
|---|---|---|
| L1361 (Cutoff 블록) | `CASE WHEN (V_GROUP_ID='ADMIN') AND (DATA_TYPE='2') THEN 'Y' ELSE 'N' END` | **전 행 'N'** ⛔ |
| L1492 (ETC 블록) | `CASE WHEN (V_GROUP_ID='ADMIN') THEN 'Y' ELSE 'N' END` | 전 행 'Y' |

L1361 이 항상 'N' 인 이유: Cutoff 블록의 WHERE 가 `R.CUTOFF_TYPE = P_MDF_TYPE`('REPORT_SP_W') 인데
편집 대상 행(`DATA_TYPE='2'`)은 `CUTOFF_TYPE='REPORT_SP_W_E'` 라 **조회에 아예 포함되지 않는다**
⇒ `AND (DATA_TYPE='2')` 는 **도달 불가 조건(dead)**. 그래서 ADMIN 이어도 Cutoff 는 편집 불가였다.

## 정정

두 자리 모두 **표준식**으로 바꾼다:

    NVL((SELECT MAX(T2.EDIT_YN) FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2
          WHERE T2.USER_ID = P_USER_ID AND T2.MNU_ID = P_MNU_ID
            AND T2.UNIT_TP_CD = 'D' AND T2.UNIT_ID = P_DIVISION_ID), 'N') AS EDIT_FLAG

- `MAX` = 보유 권한 합집합('Y' 우선) — hook #128 AUTHUNION 정합, 행 곱셈 없음(스칼라 서브쿼리)
- 판정 주체가 **그룹명 하드코딩(`V_GROUP_ID='ADMIN'`) → 권한 뷰**로 이동 ⇒ hook #128 §3 준수
- 도달 불가 조건 `AND (DATA_TYPE='2')` 제거

사용: python dmf0044_editflag_std_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_editflagstd_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_EDITFLAGSTD_20260810.sql"
MARK = ("EDITFLAGSTD 2026-08-10", 2)

STD = ("""NVL((SELECT MAX(T2.EDIT_YN) FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2
                     WHERE T2.USER_ID = P_USER_ID AND T2.MNU_ID = P_MNU_ID
                       AND T2.UNIT_TP_CD = 'D' AND T2.UNIT_ID = P_DIVISION_ID), 'N')"""
       """ AS EDIT_FLAG /* EDITFLAGSTD 2026-08-10 */""")

H1_OLD = "            , CASE WHEN (V_GROUP_ID = 'ADMIN') AND (DATA_TYPE = '2') THEN 'Y' ELSE 'N' END AS EDIT_FLAG\n"
H1_NEW = "            , " + STD + "\n"
H2_OLD = ", CASE WHEN (V_GROUP_ID = 'ADMIN') THEN 'Y' ELSE 'N' END AS EDIT_FLAG"
H2_NEW = ", " + STD

GUARD_KEYS = ["AUTHUNION 2026-08-09", "PIVOTSEL 2026-08-10", "PRODUCTDETAIL 2026-08-10",
              "M.CALC_YN = '-'", "RPTGRP-STUB 2026-08-10", "NVL(d_Result_Date, '-')",
              "SEQGRP 2026-08-10", "ETCDEL 2026-08-10", "NODATAGUARD 2026-08-10",
              "DESCNULL 2026-08-10", "DESCDEF 2026-08-10", "TUNE-M 2026-08-10",
              "TUNE-M2 2026-08-10", "MSRDUP 2026-08-10"]


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


def marks(t):
    return {k: t.count(k) for k in GUARD_KEYS}


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    b = live_body()
    BACKUP.write_text(b, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(b.splitlines())))
    print("  앵커① Cutoff EDIT_FLAG = %d (기대 1)" % b.count(H1_OLD))
    print("  앵커② ETC    EDIT_FLAG = %d (기대 1)" % b.count(H2_OLD))
    for k, v in marks(b).items():
        print("  선행 마커 %-26s %d" % (k, v))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    base = BACKUP.read_text(encoding="utf-8")
    m0 = marks(base)
    t = base
    if MARK[0] in t:
        print("  이미 적용됨 — skip(멱등)")
    else:
        n1 = t.count(H1_OLD)
        if n1 != 1:
            sys.exit("[error] 앵커① %d건 (기대 1) — 손대지 않음" % n1)
        t = t.replace(H1_OLD, H1_NEW)
        n2 = t.count(H2_OLD)
        if n2 != 1:
            sys.exit("[error] 앵커② %d건 (기대 1) — 손대지 않음" % n2)
        t = t.replace(H2_OLD, H2_NEW)
        print("  앵커①② 치환 완료")
    if t.count(MARK[0]) != MARK[1]:
        sys.exit("[error] 마커 %d (기대 %d) — 중단" % (t.count(MARK[0]), MARK[1]))
    for k, v in marks(t).items():
        if v != m0[k]:
            sys.exit("[error] 선행 마커 '%s' 변동 (%d→%d) — 중단" % (k, m0[k], v))
    PATCHED.write_text(t, encoding="utf-8")
    print("[patch] %s (%d행, %+d) / 선행 마커 %d종 불변 ✅"
          % (PATCHED, len(t.splitlines()), len(t.splitlines()) - len(base.splitlines()), len(m0)))
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
        e = cur.fetchone()[0]
        print("  errors =", e)
        if e:
            cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
            for r in cur.fetchall():
                print("   ⛔ L%s:%s %s" % r)
    return 1 if e else 0


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
