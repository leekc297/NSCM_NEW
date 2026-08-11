#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_item_id_fpmodal_apply.py — DMF0044 ITEM_ID 팝업 셀 등재 (2026-08-11)

## 목적
AS-IS 는 InsertRow 시 `ITEM_ID` 셀에 팝업 아이콘을 붙이고(`.cs` L1027 `CellType = cellTypeImage`),
더블클릭하면 `DM0002_ItembyDivisionPopupEx` 를 연다(L1307~1334).
TO-BE 는 더블클릭 동작은 구현돼 있으나 `CELL_CONTROL_OBJECT_TYPE_CODE` 가 비어 있어
**팝업 아이콘이 렌더되지 않아** 사용자가 팝업의 존재를 알 수 없었다.

## 조치
`CELL_CONTROL_OBJECT_TYPE_CODE = 'FPModal'` (= `CELL_CONTROL_TYPE.MODAL`) 등재.

## 공용 그리드 동작 (packages/shared/.../dataGridUtils.ts — 실측)
  · L224~231 `formatEditableColumns` : `wj-cell-popup`(아이콘) 부여 조건 =
        _ctrlType===MODAL AND (inputTp∈{M,O} OR (inputTp.startsWith('I') AND CRUD_TYPE==='I'))
    ⇒ ITEM_ID 는 `INPUT_TP_CD='IO'` 이므로 **신규행에만 아이콘** — AS-IS L1027 파리티 정확 일치.
  · L271~274 `cellEditHandler`       : MODAL 컬럼은 인라인 편집 cancel — 값은 팝업으로만 입력.
    ⇒ 마스터에 없는 임의 ITEM_ID 입력이 원천 차단된다(AS-IS TextCellType 대비 더 엄격).

사용:
  python dmf0044_item_id_fpmodal_apply.py            # dry-run
  python dmf0044_item_id_fpmodal_apply.py --apply    # 백업 SQL 출력 후 UPDATE
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

PROGRAM, SHEET, COL = "DMF0044", "MDF Reports", "ITEM_ID"
# 기본 FPModal. `--to FPText` 로 텍스트 입력 전환 가능 (2026-08-11 사용자 요청).
#   ⚠ 공용 그리드가 특수 처리하는 컨트롤은 MODAL / COMBO 뿐 — 그 외(FPText 등)는 일반 텍스트 편집.
#   FPText 전환 시: 팝업 아이콘(`wj-cell-popup`)은 사라지지만, 화면의 **ITEM_ID 더블클릭 핸들러는
#   컨트롤 타입과 무관**하므로 팝업은 계속 열린다(타이핑 + 더블클릭 팝업 병행).
TARGET = "FPModal"
OUT = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate"
BACKUP = OUT / "BACKUP_DMF0044_ITEM_ID_CELL_CONTROL_20260811.sql"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--to", default=TARGET, help="목표 CELL_CONTROL (기본 FPModal / 예: FPText)")
    a = ap.parse_args()
    target = a.to

    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'(null)'), INPUT_TP_CD, VISIBLE_FLAG
                       FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
                       WHERE  PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    {"p": PROGRAM, "s": SHEET, "c": COL})
        row = cur.fetchone()
        if not row:
            sys.exit("[error] 대상 컬럼 없음")
        cur_ctrl, input_tp, vis = row
        print("[현재] %s.%s  CELL_CONTROL=%s / INPUT_TP_CD=%s / VISIBLE=%s"
              % (SHEET, COL, cur_ctrl, input_tp, vis))
        print("[목표] CELL_CONTROL=%s" % target)
        if input_tp != "IO":
            print("  ⚠ INPUT_TP_CD 가 'IO' 가 아니다 — 아이콘 표시 조건이 달라진다")
        if cur_ctrl == target:
            print("  이미 적용됨 — 변경 없음")
            return 0

        if not a.apply:
            print("\n(dry-run — --apply 로 실행)")
            return 0

        OUT.mkdir(parents=True, exist_ok=True)
        BACKUP.write_text(
            "-- 원복 SQL — DMF0044 ITEM_ID CELL_CONTROL_OBJECT_TYPE_CODE (적용 직전 값)\n"
            "UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET CELL_CONTROL_OBJECT_TYPE_CODE = %s\n"
            " WHERE PROGRAM_ID = '%s' AND SHEET_NAME = '%s' AND COLUMN_NAME = '%s';\nCOMMIT;\n"
            % ("NULL" if cur_ctrl == "(null)" else "'%s'" % cur_ctrl, PROGRAM, SHEET, COL),
            encoding="utf-8")
        print("[backup] %s" % BACKUP)

        cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                       SET    CELL_CONTROL_OBJECT_TYPE_CODE = :t,
                              LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
                       WHERE  PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    {"t": target, "p": PROGRAM, "s": SHEET, "c": COL})
        n = cur.rowcount
        con.commit()
        cur.execute("""SELECT CELL_CONTROL_OBJECT_TYPE_CODE, INPUT_TP_CD
                       FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
                       WHERE  PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    {"p": PROGRAM, "s": SHEET, "c": COL})
        after = cur.fetchone()
        print("[apply] %d행 UPDATE + COMMIT" % n)
        print("[검증] CELL_CONTROL=%s / INPUT_TP_CD=%s  ⇒ %s"
              % (after[0], after[1], "PASS" if after[0] == target else "FAIL"))
    return 0


if __name__ == "__main__":
    sys.exit(main())
