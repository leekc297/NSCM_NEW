#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_input_tp_cd_apply.py — DMF0049 'MDF Reports' UI Category Setup 입력형 정합 (2026-08-11)

## 배경 (사용자 지시)
"DMF0049 INSERT 시 정적 COLUMN 에 대해서도 입력 가능하도록 편집모드가 되어야 한다.
 UI CATEGORY SETUP 데이터를 DMF0044 를 참조해서 보완하고 적용."
실측: DMF0049 `MDF Reports` 42컬럼 **전부 `'S'`(Only Search)** → 신규행이 전량 잠금이었다.
(AS-IS 메타도 42컬럼 전부 'S' — 편집은 `.cs` LockRange 가 결정한다. DMF0044 와 동일 구조)

## 값 도출 근거 — AS-IS `DMF0049_Sales_ETC_Reports.cs` InsertRow L930~1041 (추정 금지)
* **삽입 행 수** = `iMeasureCnt` (40=3 / 81계열=2 / 82=1, L934~939) — FE `measureCntOf` 로 이미 구현됨.
* **공통 잠금**(전 division, L965~978): T_DEPARTMENT_NAME / T_DEPT_NAME / CUTOFF_YYYYMMDD /
  NICK_NAME / SCM_SITE_ID / BIZ_TYPE_NAME / DMS_CUSTOMER
  · CUTOFF_YYYYMMDD·BIZ_TYPE_NAME·DMS_CUSTOMER 는 이 시트 메타에 **컬럼이 없다** → 대상 외(no-op 가드와 동일)
  · SCM_SITE_ID 는 VISIBLE_FLAG='N' → 어차피 S
* **MEASURE**(L1027~1031): 전 division 잠금 + `dtMeasure.Rows[i]` 로 **강제 세팅** → 사용자 선택 불가
* **division 분기**(L983~1024)는 **메타의 `DIVISION_ID` 스코프가 이미 대부분 흡수**한다:
  · CELL_MODEL_INFO = AS-IS 81/82 잠금인데 메타 행 스코프가 **40 전용** ⇒ 충돌 없음(40 은 미잠금)
  · PROJECT_CODE/SCM_SITE_ID/END_CUSTOMER = 81/82 에서 unlock 이지만 전부 **VISIBLE_FLAG='N'** ⇒ S
  · 81 분기의 `LockRange(FCST_TYPE → MEASURE)` 는 **역순 범위**다
    (AS-IS 컬럼 순서 실측: MEASURE SORT=200 < FCST_TYPE SORT=310) ⇒ 실효 없음으로 판정, 81 컬럼 개방
* **IM**(필수) = DEPARTMENT_ID — 저장 시 공백이면 MSG00429 차단
  (`utils/etc-sales-reports.save.ts:126~129`, AS-IS L748 MSG00002 재매핑). DMF0044 와 동일 판정.

## 잔여 편차 1건 (보고 대상 — 적용은 함)
`ITEM_ID` 는 AS-IS 가 **82 에서만 잠금**(L1014~1015)인데 메타 행 스코프가 `ALL` 이라 분기를 담지 못한다.
⇒ `IO` 로 두면 **82 에서 AS-IS 보다 넓게 열린다**. 40/81 사용성(모델 입력)이 주 용도이므로 IO 채택.
   정확 파리티가 필요하면 `DIVISION_ID` 스코프 분리 등재(40,81계열 = IO / 82 = S)가 가능하다
   — 이 테이블은 PK 가 없고, 이미 40 전용 12행 / 81계열 7행 / 82 전용 4행이 공존한다.

사용:
  python dmf0049_input_tp_cd_apply.py            # dry-run
  python dmf0049_input_tp_cd_apply.py --backup   # 원복 SQL 생성
  python dmf0049_input_tp_cd_apply.py --apply    # UPDATE (백업 선행 필수)
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

PROGRAM, SHEET = "DMF0049", "MDF Reports"
OUT = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate"
BACKUP = OUT / "BACKUP_DMF0049_SHEET_COLUMNS_INPUT_TP_CD_20260811.sql"

# AS-IS 공통 잠금 중 이 시트에 실재하고 표시되는 컬럼 + MEASURE(강제 세팅)
ASIS_LOCKED_S = {"T_DEPARTMENT_NAME", "T_DEPT_NAME", "NICK_NAME", "MEASURE"}
MANDATORY_INSERT = {"DEPARTMENT_ID"}   # MSG00429 (save.ts:126~129)


def target_for(col, visible):
    if visible != "Y":
        return "S"                      # 비표시 = 편집 대상 아님
    if col in ASIS_LOCKED_S:
        return "S"
    if col in MANDATORY_INSERT:
        return "IM"
    return "IO"


def fetch(cur):
    cur.execute("""SELECT COLUMN_NAME, VISIBLE_FLAG, INPUT_TP_CD, SORT_ORDER_NO
                   FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
                   WHERE  PROGRAM_ID=:p AND SHEET_NAME=:s
                   ORDER BY SORT_ORDER_NO, COLUMN_NAME""", {"p": PROGRAM, "s": SHEET})
    return cur.fetchall()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--backup", action="store_true")
    ap.add_argument("--apply", action="store_true")
    a = ap.parse_args()

    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        rows = fetch(cur)
        if not rows:
            sys.exit("[error] 대상 메타 0행")

        plan = [(c, cur_v, target_for(c, vis), vis) for c, vis, cur_v, _seq in rows]
        changes = [x for x in plan if x[1] != x[2]]
        dist = {}
        for _c, _cv, t, _v in plan:
            dist[t] = dist.get(t, 0) + 1

        print("[대상] %s / %s — %d 컬럼" % (PROGRAM, SHEET, len(plan)))
        print("[목표 분포] " + " / ".join("%s=%d" % (k, v) for k, v in sorted(dist.items())))
        print("[변경 예정] %d건\n" % len(changes))
        for c, cv, t, vis in changes:
            print("  %-20s %-3s → %-3s  (VIS=%s)" % (c, cv, t, vis))

        if a.backup:
            OUT.mkdir(parents=True, exist_ok=True)
            lines = ["-- 원복 SQL — DMF0049 'MDF Reports' INPUT_TP_CD (2026-08-11 적용 직전 값)", ""]
            for c, cv, _t, _v in plan:
                lines.append("UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET INPUT_TP_CD = '%s' "
                             "WHERE PROGRAM_ID = '%s' AND SHEET_NAME = '%s' AND COLUMN_NAME = '%s';"
                             % (cv, PROGRAM, SHEET, c.replace("'", "''")))
            lines.append("COMMIT;")
            BACKUP.write_text("\n".join(lines), encoding="utf-8")
            print("\n[backup] %s (%d행)" % (BACKUP, len(plan)))

        if a.apply:
            if not BACKUP.is_file():
                sys.exit("\n[error] 백업 부재 — --backup 선행 필수")
            n = 0
            for c, _cv, t, _v in changes:
                cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                               SET    INPUT_TP_CD = :t, LAST_UPDATED_BY = 'admin',
                                      LAST_UPDATE_DATE = SYSDATE
                               WHERE  PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                            {"t": t, "p": PROGRAM, "s": SHEET, "c": c})
                n += cur.rowcount
            con.commit()
            print("\n[apply] %d행 UPDATE + COMMIT" % n)
            after = fetch(cur)
            dist2 = {}
            for c, vis, v, _s in after:
                dist2[v] = dist2.get(v, 0) + 1
            print("[검증] 적용 후 분포 = " + " / ".join("%s=%d" % (k, v) for k, v in sorted(dist2.items())))
            bad = [c for c, vis, v, _s in after if v != target_for(c, vis)]
            print("[검증] 목표 불일치 %d건 %s" % (len(bad), bad or ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
