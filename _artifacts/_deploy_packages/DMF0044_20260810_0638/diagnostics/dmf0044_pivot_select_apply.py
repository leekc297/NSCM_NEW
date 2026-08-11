#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_pivot_select_apply.py — DMF0044 조회 PIVOT 셀 값이 '컬럼명 문자열' 로 반환되는 결함 적용기 (2026-08-10)

## 결함 (2026-08-10 HTTP E2E 실증)
`PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA` 가 반환하는 동적 셀 `M_yyyymm` 의 **값이 수량이 아니라
컬럼명 문자열**이다. div=40 187행 / div=82 535행 **전 행**에서 `"M_202501": "M_202501"`.

원인 = 단일 변수 `V_PROD` 를 성격이 다른 두 자리에 재사용:
  * L1619 `PIVOT (SUM(QTY) FOR YYYYMM IN (...))`  ← **리터럴 + 별칭** 필요 (`'M_202501' AS "M_202501"`)
  * L1602 바깥 SELECT 목록                        ← **식별자만** 필요 (`"M_202501"`)
바깥 SELECT 에 리터럴이 들어가면서 같은 별칭의 **상수 컬럼**이 PIVOT 산출 컬럼을 덮어썼다.
2026-07-30 "별칭 없으면 컬럼명에 따옴표가 포함된다" 정정 때 IN 절 쪽만 보고 SELECT 목록 재사용을 놓친 것.

## 정본 근거 (자매 패키지 2본 — 둘 다 2변수 분리)
  * `PKG_DMF0042` L1730~1731 `v_Prod`(식별자) / `v_Prod_in`(IN 절)  → L2733 / L2741 로 분리 사용
  * `PKG_DMF0049` L297~298   `V_PROD`(IN 절)  / `V_COLS`(식별자)     → L612  / L607  로 분리 사용
⇒ 본 패치는 **동일 절차 계열인 DMF0049 의 `V_COLS` 패턴을 그대로 이식**한다(신규 발명 0).

사용:
  python dmf0044_pivot_select_apply.py --dump     # live BODY 백업
  python dmf0044_pivot_select_apply.py --patch    # 백업본에 hunk 적용 (치환 건수 검증)
  python dmf0044_pivot_select_apply.py --deploy   # 배포 + 컴파일 + 선행 마커 2종 잔존 확인
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_pivotsel_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_PIVOT_SELECT_20260810.sql"

# ⭐ 회귀 감시 — 선행 적용분이 이 배포로 유실되면 안 된다
GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,          # 권한그룹 합집합 (2026-08-09)
    "20260805 MERGE-ON 파리티 복원": 1,  # SAVE MERGE ON 3키 복원 (2026-08-09)
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


# ── hunk 정의 — live 원문 실측(2026-08-10). 1바이트라도 다르면 치환 0건 → 중단 ────────────────
# ① 선언 — DMF0049 L298 과 동일 규약
_H1_OLD = "    V_PROD              VARCHAR2(4000 CHAR) := '';\n"
_H1_NEW = (
    "    V_PROD              VARCHAR2(4000 CHAR) := '';\n"
    "    -- [PIVOTSEL 2026-08-10] 바깥 SELECT 는 **식별자만** 써야 한다. IN 절용 V_PROD 를 그대로 쓰면\n"
    "    --   `'M_202501' AS \"M_202501\"` 상수 컬럼이 PIVOT 산출을 덮어 셀 값이 컬럼명 문자열이 된다.\n"
    "    --   자매 정본: PKG_DMF0049 L298 V_COLS / PKG_DMF0042 L1730 v_Prod.\n"
    "    V_COLS              VARCHAR2(4000 CHAR) := '';   -- 외부 SELECT 의 PIVOT 컬럼 참조\n"
)
# ② 루프 진입 전 초기화
_H2_OLD = "    V_PROD := '';\n"
_H2_NEW = "    V_PROD := '';\n    V_COLS := '';\n"
# ③ 루프 본문 — 식별자 목록 동시 축적
_H3_OLD = (
    "        V_PROD := V_PROD || '''M_' || rec.BASIS_YYYYMM || ''' AS \"M_'"
    " || rec.BASIS_YYYYMM || '\",';\n"
)
_H3_NEW = (
    "        V_PROD := V_PROD || '''M_' || rec.BASIS_YYYYMM || ''' AS \"M_'"
    " || rec.BASIS_YYYYMM || '\",';\n"
    "        V_COLS := V_COLS || '\"M_' || rec.BASIS_YYYYMM || '\",';\n"
)
# ④ 말미 콤마 제거 — V_PROD 와 동일 조건으로
_H4_OLD = (
    "    IF V_PROD IS NOT NULL AND LENGTH(V_PROD) > 0 THEN\n"
    "        V_PROD := RTRIM(V_PROD, ',');\n"
    "    END IF;\n"
)
_H4_NEW = (
    "    IF V_PROD IS NOT NULL AND LENGTH(V_PROD) > 0 THEN\n"
    "        V_PROD := RTRIM(V_PROD, ',');\n"
    "        V_COLS := RTRIM(V_COLS, ',');\n"
    "    END IF;\n"
)
# ⑤ 바깥 SELECT 목록 — 리터럴(V_PROD) → 식별자(V_COLS)
_H5_OLD = "     ,' || V_PROD || '\nFROM (\n"
_H5_NEW = "     ,' || V_COLS || '\nFROM (\n"

HUNKS = [(_H1_OLD, _H1_NEW, 1), (_H2_OLD, _H2_NEW, 1), (_H3_OLD, _H3_NEW, 1),
         (_H4_OLD, _H4_NEW, 1), (_H5_OLD, _H5_NEW, 1)]


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    for i, (old, new, cnt) in enumerate(HUNKS, 1):
        n = text.count(old)
        if n != cnt:
            sys.exit("[error] hunk#%d 치환 대상 %d건 (기대 %d건) — 손대지 않음" % (i, n, cnt))
        text = text.replace(old, new)
    # PIVOT IN 절은 반드시 V_PROD 를 유지해야 한다 (뒤바뀌면 ORA-56901)
    if "FOR YYYYMM IN (' || V_PROD || ')" not in text:
        sys.exit("[error] PIVOT IN 절이 V_PROD 를 잃었다 — 중단")
    for m, n in GUARD_MARKS.items():
        if text.count(m) != n:
            sys.exit("[error] 선행 마커 '%s' 소실 — 중단" % m)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    print("  PIVOT IN=V_PROD 유지 ✅ / 바깥 SELECT=V_COLS 전환 ✅ / 선행 마커 2종 유지 ✅")
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
