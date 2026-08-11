#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_input_tp_cd_apply.py — DMF0044 'MDF Reports' UI Category Setup 입력형 정합 (2026-08-11)

## 배경 (사용자 지적 2026-08-11)
DMF0044 UI Category Setup 의 `INPUT_TP_CD` 가 **46컬럼 전부 'S'(Only Search)** 인데 화면에서는 신규행
입력이 된다. 원인 = FE 가 메타를 안 보고 `sales-reports.editLock.ts` 의 하드코딩 목록
(`INSERT_LOCKED_COLUMNS` 12개를 잠그고 나머지 전체 개방)으로 판정하기 때문.
⇒ 운영자가 admin 화면에서 정한 값이 무효화되는 구조. 메타를 정본으로 되돌린다.

## 공용 표준 (이미 구현되어 있음 — 신규 발명 0)
`packages/foundation/src/utils/gridUtils.ts` `GridUtils.isEditableCell`:
    IM / IO → editFlag !== 'N' && CRUD_TYPE === 'I'   (신규행에서만 편집)
    M  / O  → editFlag !== 'N'                         (전 행 편집)
    S       → false
`LOOKUP_TYPE='INPUT_TP_CD'` 도메인: S=Only Search / O=Optional / M=Mandatory
                                   / IM=Insert Mandatory / IO=Insert Optional

## 값 도출 근거 (AS-IS 신정본 DMF0044_Sales_Reports.cs 1,483행 — 추정 금지)
* **S 유지 13**
  - 숨김(VISIBLE_FLAG='N') 7 : Column Description / DATA_TYPE / DIVISION_ID / EDIT_FLAG
                               / VERSION_NO / SCM_SITE_ID / PROJECT_CODE
  - AS-IS InsertRow 잠금 6   : DEPARTMENT_NAME / DEPT_NAME / NICK_NAME / APPLICATION
                               / BIZ_TYPE_NAME40 / MEASURE   (L996~1023 `LockRange`)
    · MEASURE 는 L1021~1025 에서 2행 세트 값으로 **강제 세팅** — 사용자 선택 불가
    · NICK_NAME 은 ITEM_ID 팝업이 채운다(L1324) — 직접 입력 불가
    · AS-IS 잠금 목록 중 CUTOFF_YYYYMMDD/BIZ_TYPE_NAME/DMS_SALES/DMS_CUSTOMER 는
      이 시트에 컬럼이 없어 `GetColumnIndex(...) != -1` 가드로 no-op (대상 외)
* **IM 1** : DEPARTMENT_ID — AS-IS SaveData L570~575 가 공란 시 MSG00429 로 저장 차단(유일한 필수 검증)
* **IO 32**: 그 외 표시 컬럼 — AS-IS InsertRow 가 잠그지 않으므로 신규행에서 입력 가능,
             기존행 정적 컬럼은 EditButton 키영역 LockRange 로 전량 잠금 ⇒ O/M 이 아니라 IO

## ⚠ 사용자 판단 대기 (본 스크립트는 건드리지 않음)
`COMPANY_ID`(라벨 `Company Id*`) / `CELL_PROD_SITE`(`Cell Prod Site*`) 는 라벨에 필수 표식 `*` 이
있으나 **AS-IS 저장 검증에는 없다**. IM 으로 올리면 공용 `useSaveWithValidation` 이 공란 저장을
차단해 AS-IS 보다 엄격해진다(특히 CELL_PROD_SITE 는 ETC 조회가 `'' AS CELL_PROD_SITE` 로 항상 공란).
⇒ 본 적용에서는 **IO 유지**. 필수로 올릴지는 운영 결정.

사용:
  python dmf0044_input_tp_cd_apply.py            # dry-run (변경 예정 목록만)
  python dmf0044_input_tp_cd_apply.py --backup   # 현재값 원복 SQL 생성
  python dmf0044_input_tp_cd_apply.py --apply    # 실제 UPDATE (백업 선행 필수)
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

PROGRAM, SHEET = "DMF0044", "MDF Reports"
OUT = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate"
BACKUP = OUT / "BACKUP_DMF0044_SHEET_COLUMNS_INPUT_TP_CD_20260811.sql"

# ── AS-IS 근거 목록 ────────────────────────────────────────────────────────────────────────
HIDDEN_S = {"Column Description", "DATA_TYPE", "DIVISION_ID", "EDIT_FLAG",
            "VERSION_NO", "SCM_SITE_ID", "PROJECT_CODE"}
# AS-IS InsertRow LockRange (이 시트에 실재하는 것만)
INSERT_LOCKED_S = {"DEPARTMENT_NAME", "DEPT_NAME", "NICK_NAME",
                   "APPLICATION", "BIZ_TYPE_NAME40", "MEASURE"}
MANDATORY_INSERT = {"DEPARTMENT_ID"}   # MSG00429 (AS-IS 유일 필수 검증)


def target_for(col: str) -> str:
    if col in HIDDEN_S or col in INSERT_LOCKED_S:
        return "S"
    if col in MANDATORY_INSERT:
        return "IM"
    return "IO"


def fetch(cur):
    cur.execute("""SELECT COLUMN_NAME, SORT_ORDER_NO, VISIBLE_FLAG, INPUT_TP_CD,
                          NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'-')
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

        plan = [(c, cur_v, target_for(c), vis, ctrl) for c, _seq, vis, cur_v, ctrl in rows]
        changes = [x for x in plan if x[1] != x[2]]

        print("[대상] %s / %s — %d 컬럼" % (PROGRAM, SHEET, len(plan)))
        by_t = {}
        for _c, _cv, t, _v, _ctrl in plan:
            by_t[t] = by_t.get(t, 0) + 1
        print("[목표 분포] " + " / ".join("%s=%d" % (k, v) for k, v in sorted(by_t.items())))
        print("[변경 예정] %d건\n" % len(changes))
        for c, cv, t, vis, ctrl in changes:
            print("  %-22s %-3s → %-3s   (VIS=%s, CTRL=%s)" % (c, cv, t, vis, ctrl))

        if a.backup:
            OUT.mkdir(parents=True, exist_ok=True)
            lines = ["-- 원복 SQL — DMF0044 'MDF Reports' INPUT_TP_CD (2026-08-11 적용 직전 값)",
                     "-- 실행: 이 파일 전체 + COMMIT", ""]
            for c, cv, _t, _v, _ctrl in plan:
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
            for c, cv, t, _v, _ctrl in changes:
                cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                               SET    INPUT_TP_CD = :t, LAST_UPDATED_BY = 'admin',
                                      LAST_UPDATE_DATE = SYSDATE
                               WHERE  PROGRAM_ID = :p AND SHEET_NAME = :s AND COLUMN_NAME = :c""",
                            {"t": t, "p": PROGRAM, "s": SHEET, "c": c})
                n += cur.rowcount
            con.commit()
            print("\n[apply] %d행 UPDATE + COMMIT" % n)
            after = fetch(cur)
            dist = {}
            for c, _seq, _vis, v, _ctrl in after:
                dist[v] = dist.get(v, 0) + 1
            print("[검증] 적용 후 분포 = " + " / ".join("%s=%d" % (k, v) for k, v in sorted(dist.items())))
            bad = [c for c, _s, _vi, v, _ct in after if v != target_for(c)]
            print("[검증] 목표 불일치 %d건 %s" % (len(bad), bad or ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
