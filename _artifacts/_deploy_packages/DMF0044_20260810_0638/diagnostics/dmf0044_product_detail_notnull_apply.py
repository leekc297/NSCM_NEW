#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_product_detail_notnull_apply.py — `PRODUCT_DETAIL` NOT NULL 위반(ORA-01400) 정정기 (2026-08-10)

## 결함 (2026-08-10 DMF0049 HTTP E2E 로 발각)
`PKG_DMF0044.P_DMF0044_SALES_REPORT_PRODUCT_CREATE` (BODY L9634~9637) 가
`DM_MOBILE_REPORT_PRODUCT.PRODUCT_DETAIL`(**NOT NULL**) 을 이렇게 만든다:

    CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'')
         WHEN A.PRODUCT_GROUP = '원통형'   THEN NVL(A.ATTRIBUTE2,'')
         ELSE ''
    END AS PRODUCT_DETAIL

MSSQL 에서 `''` 는 빈 문자열이라 NOT NULL 을 만족했지만, **Oracle 에서 `''` 는 NULL** 이다
(`NVL(x,'')` 도 x 가 NULL 이면 NULL). ⇒ ORA-01400 으로 INSERT 가 통째로 실패한다.

실측(2026-08-10, div 40 / R_S_20260128_V002_C): 원천 45,285행 중 **31,319행(69%)** 이 NULL 산출.
⇒ 아래 3 경로가 **항상 실패**한다:
  · `PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C` (BODY L1158 내부 호출) — DMF0049 **저장 전면 차단**
  · DMF0049 `unitedVersion` TRANSFER 버튼
  · DMF0044 `unitedVersion` TRANSFER 버튼

## 정정 (사용자 확정 2026-08-10 — 센티널 `'-'`)
빈 값 센티널을 `'-'` 로 명시한다. 같은 패키지의 형제 코드가 이미 쓰는 값이라 일관된다:
  · BODY L149 `nvl(A.PRODUCT_DETAIL,'-') AS PRODUCT_DETAIL`
  · BODY L677 `NVL(A.ATTRIBUTE1,'-') AS PRODUCT_DETAIL`
(hook #119 §1.5 PK 센티널 정규화 표준과도 동일 계열)

사용:
  python dmf0044_product_detail_notnull_apply.py --dump    # live BODY 백업
  python dmf0044_product_detail_notnull_apply.py --patch   # 치환 3건 검증 (≠3 이면 중단)
  python dmf0044_product_detail_notnull_apply.py --deploy  # 배포 + 컴파일 + 선행 마커 3종 잔존 확인
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_productdetail_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_PRODUCT_DETAIL_NOTNULL_20260810.sql"

# ⭐ 회귀 감시 — 선행 적용분이 이 배포로 유실되면 안 된다
GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
}


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
        print("  선행 마커 '%s' = %d건 (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    return 0


# ── hunk — live 원문 실측(2026-08-10). 1바이트라도 다르면 치환 0건 → 중단 ───────────────────
_OLD = (
    "             , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'')\n"
    "                    WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'')\n"
    "                    ELSE ''\n"
    "               END           AS PRODUCT_DETAIL\n"
)
_NEW = (
    "             -- [PRODUCTDETAIL 2026-08-10] Oracle 은 '' = NULL 이라 NOT NULL 컬럼\n"
    "             --   DM_MOBILE_REPORT_PRODUCT.PRODUCT_DETAIL 이 ORA-01400 으로 항상 실패했다\n"
    "             --   (MSSQL 원문은 '' 가 빈 문자열이라 통과). 빈 값 센티널 '-' 명시 —\n"
    "             --   같은 BODY L149·L677 이 이미 쓰는 값(hook #119 §1.5 계열, 사용자 확정).\n"
    "             , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'-')\n"
    "                    WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'-')\n"
    "                    ELSE '-'\n"
    "               END           AS PRODUCT_DETAIL\n"
)

# ⚠ 2026-08-10 2차 — 같은 CASE 가 **GROUP BY 절에도 복제**돼 있다(L9702~9705).
#   SELECT 목록만 고치면 두 식이 달라져 ORA-00979("GROUP BY 절에 나타나거나 집계 함수에서 사용되어야")
#   가 난다. 실제로 1차 적용 후 ORA-01400 이 걷히자 이 오류가 드러났다. 반드시 **쌍으로** 고친다.
_OLD_GB = (
    "             , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'')\n"
    "                    WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'')\n"
    "                    ELSE ''\n"
    "               END\n"
)
_NEW_GB = (
    "             , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'-')\n"
    "                    WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'-')\n"
    "                    ELSE '-'\n"
    "               END\n"
)


# ⚠ 2026-08-10 3차 — **형제 프로시저에도 같은 결함**이 있다.
#   `P_DMF0044_SALES_REPORT_DEPT_CREATE`(BODY L9405~) 가 쓰는 `DM_MOBILE_REPORT_DEPT` 는
#   NOT NULL 컬럼이 5개(UPPER_DEPT_NAME / DEPT_NAME / CUST_INFO / PRODUCT_NAME / PRODUCT_DETAIL)인데
#   공급식이 전부 NULL 가능하다(L9462·L9464 는 `NVL(...,'')`, L9465·L9467·L9468 은 NVL 자체가 없음).
#   ⇒ PRODUCT_CREATE 를 고치자 이 쪽 ORA-01400 이 드러났다(양파 껍질).
#   ⭐ 정정 위치는 **INSERT SELECT 경계**로 한정한다 — 안쪽 소스를 고치면 L9423 의
#     `A.DEPARTMENT_NAME IS NULL` 정렬 분기가 함께 바뀌어 **정렬 순서가 달라진다**.
#     이 SELECT 에는 GROUP BY 가 없어 ORA-00979 위험도 없다.
_OLD_DEPT = (
    "             , A.DEPARTMENT_NAME\n"
    "             , A.DEPT_NAME\n"
    "             , A.CUST_INFO\n"
    "             , A.PRODUCT_NAME\n"
    "             , A.PRODUCT_DETAIL\n"
)
_NEW_DEPT = (
    "             -- [PRODUCTDETAIL 2026-08-10] DM_MOBILE_REPORT_DEPT 의 NOT NULL 5컬럼 —\n"
    "             --   공급식이 NULL 가능(안쪽 L9462·L9464 NVL(...,'') = Oracle 에선 NULL,\n"
    "             --   L9465·L9467·L9468 은 NVL 자체 없음) → ORA-01400. 센티널 '-' 를 경계에서 명시.\n"
    "             --   ⚠ 안쪽이 아니라 여기서 감싼다 — L9423 `IS NULL` 정렬 분기를 보존하기 위함.\n"
    "             , NVL(A.DEPARTMENT_NAME, '-')\n"
    "             , NVL(A.DEPT_NAME, '-')\n"
    "             , NVL(A.CUST_INFO, '-')\n"
    "             , NVL(A.PRODUCT_NAME, '-')\n"
    "             , NVL(A.PRODUCT_DETAIL, '-')\n"
)

# (원문, 치환문, 기대 건수) — 이미 적용된 항목은 `--patch` 가 skip 으로 처리한다(멱등).
HUNKS = [(_OLD, _NEW, 1), (_OLD_GB, _NEW_GB, 1), (_OLD_DEPT, _NEW_DEPT, 1)]


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
    # ⭐ SELECT 목록과 GROUP BY 의 CASE 식이 **문자열까지 동일**해야 한다(ORA-00979 방지)
    if text.count("THEN NVL(A.ATTRIBUTE1,'-')") != 2 or text.count("ELSE '-'") < 2:
        sys.exit("[error] SELECT/GROUP BY CASE 식 쌍 불일치 — 중단")
    if "NVL(A.ATTRIBUTE1,'')" in text or "NVL(A.ATTRIBUTE2,'')" in text:
        sys.exit("[error] 빈 문자열 분기 잔존 — 중단")
    for m, n in GUARD_MARKS.items():
        if text.count(m) != n:
            sys.exit("[error] 선행 마커 '%s' 소실 — 중단" % m)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    print("  빈 문자열 분기 제거 ✅ / 선행 마커 3종 유지 ✅")
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
