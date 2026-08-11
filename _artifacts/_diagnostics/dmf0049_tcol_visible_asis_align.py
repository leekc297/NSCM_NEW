#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_tcol_visible_asis_align.py — DMF0049 Department/Team 컬럼 2중 표시 정정 (2026-08-11)

## 사고 (사용자 보고)
"조회 시 Department, Team 이 **동일 이름으로 2개**의 Column 이 조회됩니다. As-is 기준으로 하나만."

## 실측 (SCM_MST_SHEET_COLUMNS, PROGRAM_ID='DMF0049' / SHEET_NAME='MDF Reports')
| COLUMN_NAME       | LABEL           | SEQ | VISIBLE |
|-------------------|-----------------|----:|---------|
| DEPARTMENT_ID     | **Department*** |  30 | Y       |
| T_DEPARTMENT_ID   | **Department*** |  32 | Y  ⛔ 라벨 중복 |
| T_DEPARTMENT_NAME | Department Name |  34 | Y       |
| DEPT_ID           | **Team**        |  50 | Y       |
| T_DEPT_ID         | **Team**        |  52 | Y  ⛔ 라벨 중복 |
| T_DEPT_NAME       | Team Name       |  54 | Y       |

라벨이 같은 쌍이 둘 다 VISIBLE='Y' 라 화면에 Department 2개 / Team 2개가 뜬다.

## AS-IS 근거 — ⚠ **정본** = `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0049_Sales_ETC_Reports/DMF0049_Sales_ETC_Reports.cs`
   (대사표 E00 확정: 폴더단위 1,727행본이 정본. `GSCM.DM.Plan.UIL/` 평면본은 구본 — 라인번호가 3~51행 밀린다)
    L393  Columns[GetColumnIndex(T_DEPARTMENT_ID)].Visible = false;   -- 조회
    L394  Columns[GetColumnIndex(T_DEPT_ID)].Visible       = false;
    L948  Columns[GetColumnIndex(T_DEPARTMENT_ID)].Visible = false;   -- InsertRow
    L949  Columns[GetColumnIndex(T_DEPT_ID)].Visible       = false;
`T_DEPARTMENT_ID` / `T_DEPT_ID` 에 `Visible = true` 는 **소스 전체에 없다**(전수 grep) ⇒ 항상 숨김.

⚠ `T_DEPARTMENT_NAME` / `T_DEPT_NAME` 은 **끄지 않는다** — AS-IS 는 이 둘을 숨기지 않고
  `LockRange(...)` 로 **읽기전용 표시**만 한다(정본 L402·L403·L966·L968). 라벨도
  'Department Name'/'Team Name' 로 달라 중복이 아니다. (INPUT_TP_CD='S' 와 정합)

⚠ 형제 화면 DMF0044 는 `T_*` 컬럼 자체가 메타에 없어 **해당 없음**(실측) — 이 화면 단독 결함.

## 조치
`VISIBLE_FLAG='Y' → 'N'` (2행). INPUT_TP_CD 는 손대지 않는다(둘 다 'IO' — 필수입력 'IM' 이 아니라
숨겨도 저장 필수값 누락이 되지 않는다. 필수는 DEPARTMENT_ID='IM' 이고 이 컬럼은 계속 보인다).

사용:
  python dmf0049_tcol_visible_asis_align.py --dump / --apply / --verify
"""
import argparse
import json
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
BACKUP = OUT / "BACKUP_DMF0049_SHEET_COLUMNS_tcol_visible_20260811.json"

PROGRAM_ID = "DMF0049"
SHEET_NAME = "MDF Reports"
TARGETS = ("T_DEPARTMENT_ID", "T_DEPT_ID")

# 라벨 중복 검사용 — 정정 후 기대 상태
EXPECT_AFTER = {
    "DEPARTMENT_ID": "Y",
    "T_DEPARTMENT_ID": "N",
    "T_DEPARTMENT_NAME": "Y",
    "DEPT_ID": "Y",
    "T_DEPT_ID": "N",
    "T_DEPT_NAME": "Y",
}

_SEL = """
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VISIBLE_FLAG, INPUT_TP_CD,
       DIVISION_ID, USER_SELECTABLE_FLAG, DEFAULT_FLAG, LAST_UPDATED_BY
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = :pid AND SHEET_NAME = :sht
   AND COLUMN_NAME IN ('DEPARTMENT_ID','T_DEPARTMENT_ID','T_DEPARTMENT_NAME',
                       'DEPT_ID','T_DEPT_ID','T_DEPT_NAME')
 ORDER BY SORT_ORDER_NO
"""


def _rows(cur):
    cur.execute(_SEL, pid=PROGRAM_ID, sht=SHEET_NAME)
    cols = [c[0] for c in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]


def _show(rows):
    print("  %-18s %-17s %5s %8s %6s" % ("COLUMN_NAME", "LABEL", "SEQ", "VISIBLE", "INPUT"))
    for r in rows:
        print("  %-18s %-17s %5s %8s %6s" % (
            r["COLUMN_NAME"], r["COLUMN_LABEL_NAME"], r["SORT_ORDER_NO"],
            r["VISIBLE_FLAG"], r["INPUT_TP_CD"]))
    # 표시 중인 라벨의 중복 검출
    seen = {}
    for r in rows:
        if r["VISIBLE_FLAG"] == "Y":
            seen.setdefault(r["COLUMN_LABEL_NAME"], []).append(r["COLUMN_NAME"])
    dup = {k: v for k, v in seen.items() if len(v) > 1}
    if dup:
        for label, names in dup.items():
            print("  ⛔ 라벨 중복 '%s' → %s" % (label, ", ".join(names)))
    else:
        print("  ✅ 표시 컬럼 라벨 중복 0")
    return dup


def cmd_dump():
    import oracledb

    OUT.mkdir(parents=True, exist_ok=True)
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        rows = _rows(con.cursor())
    BACKUP.write_text(json.dumps(rows, ensure_ascii=False, indent=2, default=str),
                      encoding="utf-8")
    print("[dump] %s (%d행)" % (BACKUP, len(rows)))
    _show(rows)
    return 0


def cmd_apply():
    import oracledb

    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        print("[before]")
        before = _rows(cur)
        _show(before)

        cur.execute("""
            UPDATE SCM_MST_SHEET_COLUMNS
               SET VISIBLE_FLAG     = 'N'
                 , LAST_UPDATED_BY  = 'admin'
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE PROGRAM_ID  = :pid
               AND SHEET_NAME  = :sht
               AND COLUMN_NAME IN ('T_DEPARTMENT_ID','T_DEPT_ID')
               AND VISIBLE_FLAG = 'Y'
        """, pid=PROGRAM_ID, sht=SHEET_NAME)
        n = cur.rowcount
        print("\n[update] VISIBLE_FLAG 'Y'→'N' %d행 (기대 %d)" % (n, len(TARGETS)))
        if n != len(TARGETS):
            con.rollback()
            sys.exit("[error] 갱신 %d행 ≠ 기대 %d — 롤백" % (n, len(TARGETS)))
        con.commit()

        print("\n[after]")
        after = _rows(cur)
        dup = _show(after)
        bad = [r["COLUMN_NAME"] for r in after
               if EXPECT_AFTER.get(r["COLUMN_NAME"]) != r["VISIBLE_FLAG"]]
        print("\n  기대상태 불일치 %d건 %s" % (len(bad), bad or ""))
        return 1 if (dup or bad) else 0


def cmd_verify():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        dup = _show(_rows(con.cursor()))
    return 1 if dup else 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "apply", "verify"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    for f in ("dump", "apply", "verify"):
        if getattr(a, f):
            sys.exit(globals()["cmd_" + f]())
    ap.error("--dump / --apply / --verify 중 하나 필요")


if __name__ == "__main__":
    main()
