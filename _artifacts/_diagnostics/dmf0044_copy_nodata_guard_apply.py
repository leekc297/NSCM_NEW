#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_copy_nodata_guard_apply.py — 빈 버전 COPY 시 raw ORA-01403 → 안내 메시지 (2026-08-10)

사용자 신고: *"VERSION MODAL 에서 VERSION COPY 실행 시 SQL ERROR 발생"*

## 실측 (SCM_COM_SYS_LOG 17:19:47)

    ORA-20001: [PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY]
      SQLCODE=100 / SQLERRM=ORA-01403: 데이터를 찾을 수 없습니다.
      BACKTRACE=... PKG_DMF0044, 7734행
    PARAMS: p_version_no="REPORT_SP_W_20260310_V003_R01", p_action_type="CP"

## 근본원인 — 무방비 `SELECT ... INTO`

L7734~7740:

    SELECT A.VERSION_NO, MIN(A.YYYYMMDD) INTO v_cp_VERSION_NO, v_cp_MIN_YYYYMMDD
      FROM DM_PLN_SALES_PLAN_REPORT_C A
     WHERE A.VERSION_NO = p_version_no AND A.Cutoff_type = v_cp_CUTOFF_TYPE AND A.Data_type = '1'
     GROUP BY A.VERSION_NO;

원본 버전이 **0행**이면 `NO_DATA_FOUND` 가 나고 아무도 잡지 않아 SP 전체가 죽는다.
division 40 의 `REPORT_SP_W` 버전 **176본 중 데이터 보유는 3본뿐**이라 사용자가 밟기 쉬운 경로다.

동일 계보로 바로 위 L7728~7732 도 무방비다:

    SELECT VERSION_TYPE, YYYYMMDD INTO v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD
      FROM DM_MDF_VERSION WHERE VERSION_NO = p_version_no;

- 헤더가 없으면 `NO_DATA_FOUND`
- ⚠ **`DIVISION_ID` 필터가 없어** 같은 VERSION_NO 가 타 division 에도 있으면 `TOO_MANY_ROWS`
  (원문 보존 원칙상 WHERE 절은 건드리지 않고 예외만 잡아 안내한다 — 별건으로 보고)

## 정정

두 `SELECT INTO` 를 `BEGIN ... EXCEPTION` 으로 감싸 SP 표준 검증 예외(`e_validation`)로 전환하고,
핸들러(L9230 CASE)에 안내 문구 2건을 추가한다. 기존 `DIVISION_INVALID` / `VERSION_NO_INVALID` 와 동일 방식.

사용: python dmf0044_copy_nodata_guard_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_nodataguard_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_NODATAGUARD_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1, "20260805 MERGE-ON 파리티 복원": 1, "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2, "M.CALC_YN = '-'": 12, "RPTGRP-STUB 2026-08-10": 14,
    "NVL(d_Result_Date, '-')": 14, "SEQGRP 2026-08-10": 3, "ETCDEL 2026-08-10": 1,
    "DYNSAMP 2026-08-10": 3, "DYNSAMP2 2026-08-10": 1, "DYNSAMP3 2026-08-10": 1,
}

T4 = "\t" * 4

# ── hunk 1: 헤더 조회 (L7728~7732) ────────────────────────────────────
H1_OLD = (T4 + "SELECT VERSION_TYPE,\n"
          "    YYYYMMDD\n"
          "  INTO v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD\n"
          + T4 + "FROM DM_MDF_VERSION\n"
          + T4 + "WHERE VERSION_NO = p_version_no;\n")
H1_NEW = (T4 + "-- NODATAGUARD 2026-08-10: 무방비 SELECT INTO → 표준 검증 예외로 전환.\n"
          + T4 + "--   원본 버전 헤더가 없으면 ORA-01403 이 그대로 사용자에게 노출되던 결함.\n"
          + T4 + "--   ⚠ 원문에 DIVISION_ID 필터가 없어 동명 버전이 타 division 에 있으면 TOO_MANY_ROWS —\n"
          + T4 + "--      WHERE 절은 원문 보존하고 예외만 안내로 바꾼다(별건 보고).\n"
          + T4 + "BEGIN\n"
          + T4 + "SELECT VERSION_TYPE,\n"
          "    YYYYMMDD\n"
          "  INTO v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD\n"
          + T4 + "FROM DM_MDF_VERSION\n"
          + T4 + "WHERE VERSION_NO = p_version_no;\n"
          + T4 + "EXCEPTION\n"
          + T4 + "\tWHEN NO_DATA_FOUND THEN v_log_type := 'VERSION_NO_INVALID'; RAISE e_validation;\n"
          + T4 + "\tWHEN TOO_MANY_ROWS THEN v_log_type := 'VERSION_NO_AMBIGUOUS'; RAISE e_validation;\n"
          + T4 + "END;\n")

# ── hunk 2: 원본 데이터 조회 (L7734~7740) — 실제 신고 지점 ────────────
H2_OLD = (T4 + "SELECT A.VERSION_NO, MIN(A.YYYYMMDD)\n"
          + T4 + "  INTO v_cp_VERSION_NO, v_cp_MIN_YYYYMMDD\n"
          + T4 + "FROM DM_PLN_SALES_PLAN_REPORT_C A\n"
          + T4 + "WHERE\tA.VERSION_NO = p_version_no\n"
          + T4 + "\tand A.Cutoff_type = v_cp_CUTOFF_TYPE\n"
          + T4 + "\tand A.Data_type = '1'\n"
          + T4 + "GROUP BY A.VERSION_NO;\n")
H2_NEW = (T4 + "-- NODATAGUARD 2026-08-10: 원본 버전에 복사할 행이 없으면 ORA-01403 이 그대로 터지던 결함.\n"
          + T4 + "--   (division 40 REPORT_SP_W 176본 중 데이터 보유 3본 — 사용자가 밟기 쉬운 경로)\n"
          + T4 + "BEGIN\n"
          + T4 + "SELECT A.VERSION_NO, MIN(A.YYYYMMDD)\n"
          + T4 + "  INTO v_cp_VERSION_NO, v_cp_MIN_YYYYMMDD\n"
          + T4 + "FROM DM_PLN_SALES_PLAN_REPORT_C A\n"
          + T4 + "WHERE\tA.VERSION_NO = p_version_no\n"
          + T4 + "\tand A.Cutoff_type = v_cp_CUTOFF_TYPE\n"
          + T4 + "\tand A.Data_type = '1'\n"
          + T4 + "GROUP BY A.VERSION_NO;\n"
          + T4 + "EXCEPTION\n"
          + T4 + "\tWHEN NO_DATA_FOUND THEN v_log_type := 'SOURCE_VERSION_EMPTY'; RAISE e_validation;\n"
          + T4 + "END;\n")

# ── hunk 3: 안내 문구 등재 ────────────────────────────────────────────
H3_OLD = "            WHEN 'INVALID_ETC_VERSION' THEN '룩업에 설정된 ETC 버전이 잘못되었습니다.'\n"
H3_NEW = ("            WHEN 'INVALID_ETC_VERSION' THEN '룩업에 설정된 ETC 버전이 잘못되었습니다.'\n"
          "            -- NODATAGUARD 2026-08-10\n"
          "            WHEN 'SOURCE_VERSION_EMPTY' THEN '원본 버전에 복사할 데이터가 없습니다. 데이터가 있는 버전을 선택하세요.'\n"
          "            WHEN 'VERSION_NO_AMBIGUOUS' THEN 'VERSION 값이 여러 Division 에 중복 존재합니다.'\n")

HUNKS = [("헤더 SELECT INTO 가드", H1_OLD, H1_NEW),
         ("원본데이터 SELECT INTO 가드", H2_OLD, H2_NEW),
         ("안내 문구 등재", H3_OLD, H3_NEW)]
NEW_MARK = ("NODATAGUARD 2026-08-10", 3)
ADDED = 18


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
    if NEW_MARK[0] in text:
        print("  이미 적용됨 — skip(멱등)")
    else:
        for name, old, new in HUNKS:
            got = text.count(old)
            if got != 1:
                sys.exit("[error] hunk '%s' 앵커 %d건 (기대 1) — 손대지 않음" % (name, got))
            text = text.replace(old, new)
            print("  hunk '%s' 적용" % name)
    if text.count(NEW_MARK[0]) != NEW_MARK[1]:
        sys.exit("[error] 마커 %d (기대 %d) — 중단" % (text.count(NEW_MARK[0]), NEW_MARK[1]))
    for m, k in GUARD_MARKS.items():
        if text.count(m) != k:
            sys.exit("[error] 선행 마커 '%s' 소실 (%d≠%d) — 중단" % (m, text.count(m), k))
    added = len(text.splitlines()) - base
    if added != ADDED:
        sys.exit("[error] 추가 행수 %d (기대 %d) — 중단" % (added, ADDED))
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, +%d) / 선행 마커 12종 유지 ✅" % (PATCHED, len(text.splitlines()), added))
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
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, 'NODATAGUARD 2026-08-10')),0) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
        print("  배포 후 NODATAGUARD = %d (기대 %d)" % (cur.fetchone()[0], NEW_MARK[1]))
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
