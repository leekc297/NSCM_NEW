#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""build_dmf0082_cloud_20260814.py — DMF0082 클라우드 이관 패키지 생성기.

기준선 = `_deploy_packages/DMF0082_CLOUD_20260812` (사내 2026-08-12 스냅샷).
본 패키지 = 그 이후 사내 변경분(08-13 Excel Form/Upload 적재 + 08-14 통합테스트 6건 보완).

설계 원칙은 `build_cloud_packages_20260811.py` 를 그대로 승계(헬퍼 재사용):
  ① live 실측만  ② DELETE 절 없는 MERGE  ③ CLOB 청크  ④ 감사컬럼 'admin'  ⑤ 자급(GTT/TYPE DDL)

사용: python build_dmf0082_cloud_20260814.py --build
"""
import argparse, datetime, pathlib, shutil, sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

import oracledb
import build_cloud_packages_20260811 as G
from ora import conn_info

ROOT = pathlib.Path(__file__).resolve().parents[2]
PKGROOT = ROOT / "_artifacts" / "_deploy_packages"
FE = ROOT / "nscm-fe"
PAGE = FE / "features/demand/src/pages/forecast-price"
BASELINE = PKGROOT / "DMF0082_CLOUD_20260812"

MENU = "DMF0082"
PKG = "PKG_DMF0082"
SHEETS = ("FcstNPrice", "Sales Price Save All")
# DMF0082 소비 콤보 ∩ 기준선 이후 변경 (서베이 실측 2026-08-14)
CMBOS = [
    "FcstTypeByUserGroupDMF0082",
    "FcstTypeEditDMF0082",
    "EndCustomerByDivisionDMF0082",
    "TeambyDivision",
]
# 기준선 이후 신설/변경 PROC (실측)
PROCS = ["PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA"]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--build", action="store_true")
    ap.parse_args()

    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    G.TS = cur.fetchone()[0]

    folder = PKGROOT / "DMF0082_CLOUD_20260814"
    adb = folder / "A_DB"
    adb.mkdir(parents=True, exist_ok=True)
    made = []

    # ── 01 PKG SPEC / 02 BODY ──────────────────────────────────────────────
    spec = G.pkg_ddl(cur, PKG, "PACKAGE")
    body = G.pkg_ddl(cur, PKG, "PACKAGE BODY")
    (adb / "02_PKG_DMF0082_SPEC.sql").write_text(
        "SET DEFINE OFF\n" + spec + "\n/\n", encoding="utf-8")
    (adb / "03_PKG_DMF0082_BODY.sql").write_text(
        "SET DEFINE OFF\n" + body + "\n/\n", encoding="utf-8")
    made += ["02_PKG_DMF0082_SPEC.sql", "03_PKG_DMF0082_BODY.sql"]

    # ── 01 GTT DDL (BODY 참조 실측 — 자급) ─────────────────────────────────
    gtt_names, gtt_lines = G.gtt_ddl(cur, body)
    G.write(adb / "01_GTT_DDL.sql", "DMF0082 — BODY 참조 GTT 자급 DDL (%d개)" % len(gtt_names), gtt_lines)
    made.insert(0, "01_GTT_DDL.sql")

    # ── 04 LOOKUP GET_ADMIN_GROUP_MEASURE (DMF0082 전 행) ──────────────────
    cols, rows = G.rows_of(cur, """
        SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
               DISPLAY_SEQ, VALID_YN, DESCRIPTION,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2=:m
         ORDER BY SEGMENT3, SEGMENT4, SEGMENT1""", m=MENU)
    G.write(adb / "04_LOOKUP_GET_ADMIN_GROUP_MEASURE.sql",
            "DMF0082 measure 편집권한 룩업 %d행 — PK 6컬럼(LOOKUP_TYPE+SEGMENT1~5) MERGE" % len(rows),
            G.merge_sql("SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL",
                        ["LOOKUP_TYPE", "SEGMENT1", "SEGMENT2", "SEGMENT3", "SEGMENT4", "SEGMENT5"],
                        rows, cols))
    made.append("04_LOOKUP_GET_ADMIN_GROUP_MEASURE.sql (%d행)" % len(rows))

    # ── 05 CMBO ────────────────────────────────────────────────────────────
    ph = ", ".join(":c%d" % i for i in range(len(CMBOS)))
    cols, rows = G.rows_of(cur, f"""
        SELECT SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
               CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
          FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ({ph}) ORDER BY SQL_ID""",
        **{f"c{i}": v for i, v in enumerate(CMBOS)})
    G.write(adb / "05_CMBO_SYNC.sql",
            "DMF0082 소비 콤보 %d종 (기준선 이후 변경분) — 본문 CLOB 청크" % len(rows),
            G.merge_sql("SCM_MGR.SCM_ADM_CMBO_SQL_M", ["SQL_ID"], rows, cols,
                        clob_cols=("SQL_DTL_CTN",)))
    made.append("05_CMBO_SYNC.sql (%d종)" % len(rows))

    # ── 06 SHEET_COLUMNS / SHEET_MEASURE ───────────────────────────────────
    sph = ", ".join(":s%d" % i for i in range(len(SHEETS)))
    cols, rows = G.rows_of(cur, f"""
        SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
               DATA_SORT_METHOD_CODE, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME,
               FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
               DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG,
               VISIBLE_FLAG, DIVISION_ID, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, INPUT_TP_CD,
               CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
         WHERE PROGRAM_ID=:m AND SHEET_NAME IN ({sph}) ORDER BY SHEET_NAME, SORT_ORDER_NO""",
        m=MENU, **{f"s{i}": v for i, v in enumerate(SHEETS)})
    ncol = len(rows)
    lines = G.merge_sql("SCM_MGR.SCM_MST_SHEET_COLUMNS",
                        ["PROGRAM_ID", "SHEET_NAME", "COLUMN_NAME", "DIVISION_ID"], rows, cols)

    cols2, rows2 = G.rows_of(cur, """
        SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
               SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, DEFAULT_FLAG,
               USER_SELECTABLE_FLAG, DIVISION_ID, VALID_YN, INPUT_TP_CD,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3,
               CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
          FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID=:m ORDER BY SORT_ORDER_NO""", m=MENU)
    lines += ["", "-- ── SHEET_MEASURE ──"]
    lines += G.merge_sql("SCM_MGR.SCM_MST_SHEET_MEASURE",
                         ["PROGRAM_ID", "SHEET_NAME", "COLUMN_NAME", "DIVISION_ID"], rows2, cols2)
    G.write(adb / "06_SHEET_META_SYNC.sql",
            "DMF0082 UI Category — COLUMNS %d행 + MEASURE %d행 (MERGE, DELETE 없음)" % (ncol, len(rows2)),
            lines)
    made.append("06_SHEET_META_SYNC.sql (COL %d / MSR %d)" % (ncol, len(rows2)))

    # ── 07 PROC_M / API_M ──────────────────────────────────────────────────
    pph = ", ".join(":p%d" % i for i in range(len(PROCS)))
    cols, rows = G.rows_of(cur, f"""
        SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
               CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
          FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM IN ({pph}) ORDER BY PROC_NM, SORT_ORD""",
        **{f"p{i}": v for i, v in enumerate(PROCS)})
    lines = G.merge_sql("SCM_MGR.SCM_ADM_PROC_M", ["PROC_NM", "COL_NM"], rows, cols)
    nproc = len(rows)

    cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' "
                "AND TABLE_NAME='SCM_ADM_API_M' ORDER BY COLUMN_ID")
    api_cols = [r[0] for r in cur.fetchall()]
    cols, rows = G.rows_of(cur, "SELECT %s FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE :m ORDER BY API_ID"
                           % ", ".join(api_cols), m="%" + MENU + "%")
    lines += ["", "-- ── API_M (DMF0082 전 행) ──"]
    lines += G.merge_sql("SCM_MGR.SCM_ADM_API_M", ["API_ID"], rows, cols)
    G.write(adb / "07_PROCM_API_SYNC.sql",
            "DMF0082 PROC_M %d행(Excel Form 신설분) + API_M %d행" % (nproc, len(rows)), lines)
    made.append("07_PROCM_API_SYNC.sql (PROC %d / API %d)" % (nproc, len(rows)))

    # ── 08 MSG (DMF0082 사용분 — 기준선 이후) ──────────────────────────────
    cols, rows = G.rows_of(cur, """
        SELECT MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
               CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
          FROM SCM_MGR.SCM_ADM_MSG_M
         WHERE MSG_ID IN ('MSG00703','MSG00705') ORDER BY MSG_ID, LANG_CD""")
    G.write(adb / "08_MSG_SYNC.sql", "DMF0082 사용 MSG %d행 (3언어)" % len(rows),
            G.merge_sql("SCM_MGR.SCM_ADM_MSG_M", ["MSG_ID", "LANG_CD"], rows, cols))
    made.append("08_MSG_SYNC.sql (%d행)" % len(rows))

    # ── B_FE : 기준선 패키지 대비 실제 변경 파일만 ─────────────────────────
    bfe = folder / "B_FE" / "forecast-price"
    base_fe = BASELINE / "B_FE" / "forecast-price"
    changed, added = [], []
    for src in PAGE.rglob("*"):
        if src.is_dir() or "__asis-mapping__" in src.name:
            continue
        rel = src.relative_to(PAGE)
        old = base_fe / rel
        if not old.exists():
            added.append(str(rel))
        elif old.read_bytes() != src.read_bytes():
            changed.append(str(rel))
        else:
            continue
        dst = bfe / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
    removed = [str(o.relative_to(base_fe)) for o in base_fe.rglob("*")
               if o.is_file() and not (PAGE / o.relative_to(base_fe)).exists()]

    con.close()

    (folder / "_FILELIST.md").write_text(
        "# DMF0082_CLOUD_20260814 — 파일 인벤토리 (생성 %s)\n\n## A_DB\n%s\n\n"
        "## B_FE (기준선 08-12 패키지 대비 실 변경분만)\n"
        "- 변경 %d파일: %s\n- 신규 %d파일: %s\n- 기준선에 있으나 현행 삭제됨 %d파일: %s\n"
        % (G.TS, "\n".join("- " + m for m in made),
           len(changed), ", ".join(changed) or "-",
           len(added), ", ".join(added) or "-",
           len(removed), ", ".join(removed) or "-"),
        encoding="utf-8")

    print(f"[built] {folder}")
    for m in made:
        print("   A_DB/" + m)
    print(f"   B_FE 변경 {len(changed)} / 신규 {len(added)} / 삭제 {len(removed)}")
    print(f"   변경={changed}\n   신규={added}\n   삭제={removed}")


if __name__ == "__main__":
    main()
