#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_cellctrl_asis_diff.py — DMF0044 셀 컨트롤(콤보/팝업) 메타 AS-IS↔TO-BE 전수 대사 (2026-08-11)

목적: ETC INSERT ROW 에서 정적 컬럼의 편집기(COMBO/POPUP)가 AS-IS 대로 동작하는지 판정.
대상 필드 = `CELL_CONTROL_OBJECT_TYPE_CODE`(셀 컨트롤) / `CELL_COMBO_DATA_TYPE`(콤보 원천)
          / `INPUT_TP_CD`(입력형) / `ATTRIBUTE1~5`(프레임워크 콤보 파라미터 계약) / EDIT 관련 플래그.

⚠ UI Category Setup 메타는 임의 생성 금지 — 본 스크립트는 **읽기 전용 대사만** 한다.
   보완이 필요하면 AS-IS 실값을 그대로 옮기는 SQL 을 별도 산출하고 사용자 승인 후 적용한다.

사용:
  python dmf0044_cellctrl_asis_diff.py                 # 요약 + 차이 전량
  python dmf0044_cellctrl_asis_diff.py --md out.md     # 대사표 md 저장
"""
import argparse
import os
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

PROGRAM, SHEET = "DMF0044", "MDF Reports"

FIELDS = ["COLUMN_NAME", "COLUMN_LABEL_NAME", "SORT_ORDER_NO", "VISIBLE_FLAG", "INPUT_TP_CD",
          "CELL_CONTROL_OBJECT_TYPE_CODE", "CELL_COMBO_DATA_TYPE",
          "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5",
          "USER_SELECTABLE_FLAG", "DEFAULT_FLAG", "VALID_YN"]
# 셀 편집기 판정에 직결되는 필드 (차이 시 ⛔)
CRITICAL = {"INPUT_TP_CD", "CELL_CONTROL_OBJECT_TYPE_CODE", "CELL_COMBO_DATA_TYPE",
            "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5"}


def norm(v):
    if v is None:
        return ""
    s = str(v).strip()
    return s


def asis_rows():
    import pyodbc

    env = {}
    p = pathlib.Path(__file__).resolve().parents[2] / ".env.asis"
    for ln in open(p, encoding="utf-8-sig"):
        ln = ln.strip()
        if ln and not ln.startswith("#") and "=" in ln:
            k, v = ln.split("=", 1)
            env[k.strip()] = v.strip()
    cs = (f"DRIVER={{{env.get('ASIS_DB_DRIVER','ODBC Driver 17 for SQL Server')}}};"
          f"SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};DATABASE={env['ASIS_DB_NAME']};"
          f"UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes;Encrypt=no")
    with pyodbc.connect(cs, timeout=20) as cn:
        cur = cn.cursor()
        cur.execute(f"SELECT {','.join(FIELDS)} FROM SCM_MST_SHEET_COLUMNS "
                    "WHERE PROGRAM_ID=? AND SHEET_NAME=? ORDER BY SORT_ORDER_NO", PROGRAM, SHEET)
        return {norm(r[0]): {FIELDS[i]: norm(v) for i, v in enumerate(r)} for r in cur.fetchall()}


def tobe_rows():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(f"SELECT {','.join(FIELDS)} FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
                    "WHERE PROGRAM_ID=:p AND SHEET_NAME=:s ORDER BY SORT_ORDER_NO",
                    {"p": PROGRAM, "s": SHEET})
        return {norm(r[0]): {FIELDS[i]: norm(v) for i, v in enumerate(r)} for r in cur.fetchall()}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--md")
    a = ap.parse_args()

    A, T = asis_rows(), tobe_rows()
    print("[AS-IS] %d 컬럼 / [TO-BE] %d 컬럼" % (len(A), len(T)))

    only_a = [c for c in A if c not in T]
    only_t = [c for c in T if c not in A]
    if only_a:
        print("⛔ TO-BE 누락 컬럼 %d: %s" % (len(only_a), only_a))
    if only_t:
        print("⚠ TO-BE 에만 있는 컬럼 %d: %s" % (len(only_t), only_t))

    # 셀 편집기 보유 컬럼 (AS-IS 기준)
    a_editor = {c: r for c, r in A.items()
                if r["CELL_COMBO_DATA_TYPE"] or r["CELL_CONTROL_OBJECT_TYPE_CODE"]}
    print("\n[AS-IS] 셀 편집기 지정 컬럼 %d개" % len(a_editor))

    diffs = []
    for col in A:
        if col not in T:
            continue
        for f in FIELDS:
            if f == "COLUMN_NAME":
                continue
            if A[col][f] != T[col][f]:
                diffs.append((col, f, A[col][f], T[col][f]))

    crit = [d for d in diffs if d[1] in CRITICAL]
    print("\n[차이] 전체 %d건 / ⛔ 셀편집기 직결 %d건" % (len(diffs), len(crit)))

    if crit:
        print("\n=== ⛔ 셀 편집기 직결 차이 ===")
        w = max(len(d[0]) for d in crit)
        for col, f, av, tv in crit:
            print("  %-*s %-30s AS-IS[%s]  ≠  TO-BE[%s]" % (w, col, f, av, tv))

    other = [d for d in diffs if d[1] not in CRITICAL]
    if other:
        print("\n=== 그 외 차이 (%d) ===" % len(other))
        for col, f, av, tv in other:
            print("  %-24s %-24s AS-IS[%s] ≠ TO-BE[%s]" % (col, f, av, tv))

    print("\n=== AS-IS 셀 편집기 인벤토리 (컬럼 / INPUT_TP_CD / CELL_CTRL / COMBO_TYPE / ATTR1~5) ===")
    for col, r in a_editor.items():
        attrs = "|".join(r["ATTRIBUTE%d" % i] for i in range(1, 6))
        mark = "" if col in T and all(A[col][f] == T[col][f] for f in CRITICAL) else "  ⛔차이"
        print("  %-26s %-12s %-14s %-26s %s%s"
              % (col, r["INPUT_TP_CD"], r["CELL_CONTROL_OBJECT_TYPE_CODE"],
                 r["CELL_COMBO_DATA_TYPE"], attrs, mark))

    if a.md:
        lines = ["# DMF0044 셀 컨트롤 AS-IS↔TO-BE 대사표 (%s / %s)" % (PROGRAM, SHEET), "",
                 "| 컬럼 | 축 | AS-IS | TO-BE | 판정 |", "|---|---|---|---|---|"]
        for col in A:
            if col not in T:
                lines.append("| %s | (행) | 존재 | **없음** | ⛔ 누락 |" % col)
                continue
            for f in CRITICAL:
                av, tv = A[col][f], T[col][f]
                if av or tv:
                    lines.append("| %s | %s | `%s` | `%s` | %s |"
                                 % (col, f, av or "-", tv or "-", "OK" if av == tv else "⛔"))
        pathlib.Path(a.md).write_text("\n".join(lines), encoding="utf-8")
        print("\n[md] %s" % a.md)
    return 0


if __name__ == "__main__":
    sys.exit(main())
