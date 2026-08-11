#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_dept_detail_sentinel_apply.py — [결함 A] DEPT_CREATE ORA-00001 해소 (2026-08-10)

## 증상
Transfer 실행 시 `P_DMF0044_SALES_REPORT_DEPT_CREATE` 최종 INSERT 에서
    ORA-00001: PK_DM_MOBILE_REPORT_DEPT
      (DIVISION_ID, VERSION_NO, YYYY, SP_BP_TYPE, UPPER_DEPT_NAME, DEPT_NAME,
       CUST_INFO, PRODUCT_NAME, PRODUCT_DETAIL, MEASURE)
버전 R_S_20260810_V009_C 에서 재현. **튜닝(TUNE-V/TUNE-J) 이전 백업본에서도 동일 발생**
(OLD/NEW 각각 PK 중복키 119 / 초과행 119 — 완전 동일) ⇒ 튜닝과 무관한 **기존 결함**.

## 원인 (실측 119/119 단일 원인)
중간 인라인뷰는 원시 `PRODUCT_DETAIL` 로 GROUP BY 하는데, 바깥에서 `NVL(...,'-')` 로 감싼다.
따라서 **PRODUCT_DETAIL 이 NULL 인 그룹**과 **리터럴 '-' 인 그룹**이 서로 다른 그룹으로 집계된 뒤
PK 단계에서 같은 값이 되어 충돌한다. (다른 4개 문자열 컬럼·DISPLAY_SEQ 로 인한 분열은 0건)

AS-IS 대조 (`AsIs_LGCE_SCMDEV_SP1_DDL.sql:150220`):
    , C.ATTRIBUTE1 AS PRODUCT_DETAIL        -- ISNULL 없음
MSSQL 에선 '' 가 NULL 이 아닌 실제 값이라 ''그룹 과 '-'그룹 이 **서로 다른 PK** 였다.
Oracle 이관으로 '' → NULL 이 되었고, NOT NULL PK 를 만족시키려 바깥에서 '-' 로 감싼 순간
기존 '-' 데이터와 한 값으로 합쳐졌다. (ORA-01400 을 막은 조치가 ORA-00001 을 만든 셈)

## 조치
센티널 정규화를 **바깥이 아니라 집계 안쪽**으로 옮긴다 — GROUP BY 가 두 그룹을 하나로 합치고
QTY 도 합산한다. 프로젝트 표준(hook #119 §1.5, 센티널 '-' 통일)과 일치.

    , C.ATTRIBUTE1 AS PRODUCT_DETAIL   →   , NVL(C.ATTRIBUTE1,'-') AS PRODUCT_DETAIL

바깥 `NVL(A.PRODUCT_DETAIL,'-')` 는 무해한 항등이 되므로 방어적으로 유지한다.

## 사전 검증 (적용 전 실측, 버전 R_S_20260810_V009_C)
    PK 중복키 119 → 0
    행수      821 → 702 (−119, 두 그룹이 한 행으로 병합)
    MM01~MM12 총합 : **12개월 전부 차이 0** (Oracle NUMBER 정밀 차감 — 병합이므로 총액 불변)

⚠ 의미 변화 1건 (사용자 승인 완료): AS-IS 는 ''행 과 '-'행 을 2행으로 따로 냈으나
  TO-BE 는 1행으로 합산된다. 총액은 불변. NOT NULL PK 상 센티널은 하나여야 한다.

사용: python dmf0044_dept_detail_sentinel_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_detailsentinel_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_DETAILSENTINEL_20260810.sql"
MARK = "TUNE-S 2026-08-10"

OLD = "                             , C.ATTRIBUTE1 AS PRODUCT_DETAIL\n"
NEW = ("                             -- TUNE-S 2026-08-10: 센티널 정규화를 **집계 안쪽**으로 이동 (ORA-00001 해소).\n"
       "                             --   바깥에서만 NVL(...,'-') 하면, 원시 NULL 그룹과 리터럴 '-' 그룹이\n"
       "                             --   따로 집계된 뒤 PK 단계에서 같은 값이 되어 충돌한다\n"
       "                             --   (실측 PK 중복키 119 — 전부 이 원인. 다른 컬럼 기인 0건).\n"
       "                             --   안쪽에서 감싸면 두 그룹이 하나로 합쳐지고 QTY 도 합산된다.\n"
       "                             --   검증: 중복 119→0 / 행 821→702 / MM01~12 총합 차이 0(NUMBER 정밀).\n"
       "                             --   AS-IS(L150220)는 ISNULL 없이 C.ATTRIBUTE1 — MSSQL 은 ''≠'-' 라\n"
       "                             --   서로 다른 PK 였다. Oracle 은 ''=NULL 이라 센티널이 하나여야 한다.\n"
       "                             , NVL(C.ATTRIBUTE1, '-') AS PRODUCT_DETAIL\n")
EXPECT = 1


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
    n = body.count(OLD)
    print("  앵커 %d (기대 %d)%s" % (n, EXPECT, "" if n == EXPECT else "  ⛔"))
    print("  마커 '%s' 사전 존재 = %d (기대 0)" % (MARK, body.count(MARK)))
    # 선행 튜닝분이 살아있는지 확인 (덮어쓰기 사고 방지)
    for m, k in (("TUNE-V 2026-08-10", 2), ("TUNE-J 2026-08-10", 9)):
        got = body.count(m)
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, k, "" if got == k else "  ⛔"))
    return 0 if (n == EXPECT and body.count(MARK) == 0) else 1


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    orig = BACKUP.read_text(encoding="utf-8")
    if MARK in orig:
        sys.exit("[error] 마커 이미 존재 — 중단")
    n = orig.count(OLD)
    if n != EXPECT:
        sys.exit("[error] 앵커 %d (기대 %d) — 손대지 않음" % (n, EXPECT))
    text = orig.replace(OLD, NEW)

    # 역치환 복원 검사 — 의도 외 변경 0 증명
    if text.replace(NEW, OLD) != orig:
        sys.exit("[error] 역치환 복원 불일치 — 중단")
    print("  ✅ 역치환 복원 일치 — 의도한 1개 구간 외 변경 0")

    for s, exp, desc in (
        (MARK, 1, "TUNE-S 마커"),
        ("NVL(C.ATTRIBUTE1, '-') AS PRODUCT_DETAIL", 1, "신규 표현식"),
        ("\n                             , C.ATTRIBUTE1 AS PRODUCT_DETAIL\n", 0, "구 표현식 잔존"),
        ("TUNE-V 2026-08-10", 2, "선행 TUNE-V 유지"),
        ("TUNE-J 2026-08-10", 9, "선행 TUNE-J 유지"),
    ):
        got = text.count(s)
        if got != exp:
            sys.exit("[error] %s = %d (기대 %d) — 중단" % (desc, got, exp))
        print("  ✅ %-22s %d" % (desc, got))

    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, 원본 %d행)" % (PATCHED, len(text.splitlines()), len(orig.splitlines())))
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
            print("  %-14s %s" % r)
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % e)
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT,'TUNE\\-S 2026\\-08\\-10')),0) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
        print("  배포 후 마커 '%s' = %d (기대 %d)" % (MARK, cur.fetchone()[0], EXPECT))
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
