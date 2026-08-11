#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_merge_keys_apply.py — DMF0044 SAVE MERGE ON 키 3개 누락 결함 적용기 (2026-08-09)

결함(2026-08-05 감사 D-①): `PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C` 의 **MERGE ON 절**에서
  AS-IS 7키 중 3키가 누락 — DOM_EXP / FORECAST_INFO_CELL_MODEL↔CELL_MODEL_INFO / ATTRIBUTE3↔CELL_MODEL.
  GT 에는 3컬럼이 실재하므로 **순수 변환 누락**이고, 영향은 **QTY 오갱신 · ORA-30926**(비결정적 MERGE).

⛔ 왜 08-05 패치본을 그대로 배포하면 안 되는가:
   `DMF0044_MERGE_ON_KEYS_FIX_20260805_PKG_BODY.sql` 은 **AUTHUNION 적용 이전**(2026-08-09) BODY 에서
   만들어졌다(마커 0건 / 9,750행 vs live 9,747행). 그대로 배포하면 **AUTHUNION 이 유실**된다.
   → 본 스크립트는 **live 를 재덤프**해 그 위에 3키 hunk 만 다시 얹는다.

사용:
  python dmf0044_merge_keys_apply.py --diff     # live vs 08-05 패치본 차이 = 적용할 hunk 확인 (읽기 전용)
  python dmf0044_merge_keys_apply.py --dump     # live BODY 백업
  python dmf0044_merge_keys_apply.py --patch    # 백업본에 hunk 적용 (치환 건수 검증)
  python dmf0044_merge_keys_apply.py --deploy   # 배포 + 컴파일 + **AUTHUNION 마커 잔존** 확인
"""
import argparse
import difflib
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
STALE = OUT / "DMF0044_MERGE_ON_KEYS_FIX_20260805_PKG_BODY.sql"
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_mergekeys_20260809.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_MERGE_ON_KEYS_20260809.sql"
AUTHUNION_MARK = "AUTHUNION 2026-08-09"


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


def cmd_diff():
    """live ↔ 08-05 패치본 차이 전량 출력 — 적용할 hunk 를 눈으로 확정한다."""
    if not STALE.is_file():
        sys.exit("[error] 08-05 패치본 없음: %s" % STALE)
    live = live_body().splitlines()
    stale = STALE.read_text(encoding="utf-8").splitlines()
    print("[diff] live %d행 ↔ 08-05 패치본 %d행" % (len(live), len(stale)))
    n_add = n_del = 0
    for grp in difflib.SequenceMatcher(None, live, stale, autojunk=False).get_opcodes():
        tag, i1, i2, j1, j2 = grp
        if tag == "equal":
            continue
        print("\n--- live L%d~%d  ↔  패치본 L%d~%d  [%s] ---" % (i1 + 1, i2, j1 + 1, j2, tag))
        for x in live[i1:i2]:
            print("  live - %s" % x.rstrip())
            n_del += 1
        for x in stale[j1:j2]:
            print("  patch+ %s" % x.rstrip())
            n_add += 1
    print("\n[요약] live 전용 %d행 / 패치본 전용 %d행" % (n_del, n_add))
    print("       ⚠ live 전용 행에 AUTHUNION 블록이 보이면 = 패치본이 그것을 잃는다는 뜻(그대로 배포 금지)")
    return 0


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    if AUTHUNION_MARK not in body:
        print("  ⚠ live 에 AUTHUNION 마커가 없다 — 사전 확인 필요")
    else:
        print("  AUTHUNION 마커 확인 ✅")
    return 0


# hunk 정의 — `--diff` 실측(2026-08-09)으로 확정. 원문과 1바이트라도 다르면 치환 0건 → 중단.
#   삽입 지점 = MERGE ON 절의 `A.COMPANY_ID` 조건 직후(live L4025 뒤). DATA_TYPE='2' 블록이 유일 식별자.
_OLD = (
    "            AND A.COMPANY_ID                           = B.COMPANY_ID     -- 20200123\n"
    "            AND NVL(NULLIF(TRIM(A.CELL_PROD_SITE), ''), '-') = '-'\n"
    "            AND A.DATA_TYPE                            = '2'"
)
_NEW = (
    "            AND A.COMPANY_ID                           = B.COMPANY_ID     -- 20200123\n"
    "            -- [20260805 MERGE-ON 파리티 복원] AS-IS ISNULL 7키 중 변환 시 누락된 3키 추가 (hook #119 센티널 규약).\n"
    "            --   누락 시: DOM_EXP/CELL_MODEL 조합만 다른 기존 행에 MATCHED → QTY 오갱신 또는 ORA-30926.\n"
    "            AND NVL(NULLIF(TRIM(A.DOM_EXP), ''), '-')                  = NVL(NULLIF(TRIM(B.DOM_EXP), ''), '-')\n"
    "            AND NVL(NULLIF(TRIM(A.FORECAST_INFO_CELL_MODEL), ''), '-') = NVL(NULLIF(TRIM(B.CELL_MODEL_INFO), ''), '-')\n"
    "            AND NVL(NULLIF(TRIM(A.ATTRIBUTE3), ''), '-')               = NVL(NULLIF(TRIM(B.CELL_MODEL), ''), '-')\n"
    "            AND NVL(NULLIF(TRIM(A.CELL_PROD_SITE), ''), '-') = '-'\n"
    "            AND A.DATA_TYPE                            = '2'"
)
HUNKS = [(_OLD, _NEW, 1)]


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    if not HUNKS:
        sys.exit("[error] HUNKS 미정의 — `--diff` 실측 후 정의할 것 (추측 금지)")
    text = BACKUP.read_text(encoding="utf-8")
    for i, (old, new, cnt) in enumerate(HUNKS, 1):
        n = text.count(old)
        if n != cnt:
            sys.exit("[error] hunk#%d 치환 대상 %d건 (기대 %d건) — 손대지 않음" % (i, n, cnt))
        text = text.replace(old, new)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    if AUTHUNION_MARK not in text:
        sys.exit("[error] 배포본에 AUTHUNION 마커 소실 — 중단")
    print("  AUTHUNION 마커 유지 ✅")
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
        # ⭐ 회귀 감시 — 오늘 적용한 AUTHUNION 이 살아 있는지 배포 직후 확인한다
        cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' "
                    "AND TYPE='PACKAGE BODY' AND INSTR(TEXT, :m) > 0", {"m": AUTHUNION_MARK})
        n_mark = cur.fetchone()[0]
        print("  AUTHUNION 마커 라인 수 = %d (기대 1)" % n_mark)
        if n_mark != 1:
            print("  ⛔ AUTHUNION 회귀 — 즉시 원복 검토")
    return 1 if errs else 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("diff", "dump", "patch", "deploy"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    if a.diff:
        sys.exit(cmd_diff())
    if a.dump:
        sys.exit(cmd_dump())
    if a.patch:
        sys.exit(cmd_patch())
    if a.deploy:
        sys.exit(cmd_deploy())
    ap.error("--diff / --dump / --patch / --deploy 중 하나 필요")


if __name__ == "__main__":
    main()
