#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082 `CELL_PROD_SITE_ID.DIVISION_ID` → `'40'` (사용자 결정 2026-08-22).

## 사용자 지적

    "CELL_PROD_SITE_ID 는 DMF0082 에서 확인하면 AS-IS 에는 40 DIVISION 만 설정되어 있습니다.
     TO-BE 40, 82 설정되어 있는데 사유를 확인해주세요."
    → "제 의견은 40만으로 설정을 변경하는게 맞다고 생각합니다."

## 실측 대조

    AS-IS  DMF0082 / FcstNPrice           DIVISION_ID = '40'                    INPUT_TP_CD = 'S'
    AS-IS  DMF0082 / Sales Price Save All DIVISION_ID = '40,82,81,81_UC,...'    INPUT_TP_CD = 'S'
    TO-BE  DMF0082 / FcstNPrice           DIVISION_ID = '40,82'   ← 정정 대상    INPUT_TP_CD = 'IO'

AS-IS 의 다른 화면(DMF0021/0022/0035/0048)도 전부 `'40'` 단독이다. 즉 **`FcstNPrice` 시트의
AS-IS 정본은 `'40'`** 이고, `82` 는 형제 시트(`Sales Price Save All`)의 값이 섞인 것으로 보인다.

## `'40,82'` 가 된 경위 (기록 추적)

    Doc/_archive/work_reports/2026-08-20_request_ledger_system.md:54-56
      "REQ:1ST-39-1: 사내 SCM_MST_SHEET_COLUMNS FcstNPrice CELL_PROD_SITE_ID DIVISION_ID 에
       81 계열 8토큰 재유입 회귀(08-20 09:25) → 사용자 확인 후 '40,82' 복원(fix_39_1.py)"
    _artifacts/_deploy_packages/DMF0082_TESTFIX_20260811_2/90_VERIFY.sql:22
      "No.39 — CELL_PROD_SITE_ID 는 81 에서 제외 (기대: DIVISION_ID = '40,82')"

원 요구는 **"81 에서 제외"** 였는데 구현이 81 만 빼고 **82 를 남겨** `'40,82'` 가 고정됐다.
AS-IS 대조를 하지 않아 82 의 근거가 없는 채로 기대값에 박혔고, 이후 클라우드 패키지 3본에 전파됐다.

## 범위

사내 메타 1행. `INPUT_TP_CD` 는 **건드리지 않는다** — AS-IS 는 `'S'` 지만 TO-BE 는 신규행에서
Cell Prod Site 를 입력받아야 하고(라벨 `*` = 필수, SAVE 키 컬럼), `'S'` 로 되돌리면 Insert 가 막힌다.
별건으로 판단 필요.

멱등: 이미 `'40'` 이면 무변경. 실행: python apply.py  (점검만: --dry)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

PROG, SHEET, COL = "DMF0082", "FcstNPrice", "CELL_PROD_SITE_ID"
NEW_DIV = "40"
BAK = "BAK_DMF0082_CELLPRODSITE_20260822"
NL = chr(10)


def snap(cur):
    cur.execute("""SELECT NVL(DIVISION_ID,'(널)'), NVL(INPUT_TP_CD,'-'),
                          NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'(공란)'),
                          NVL(TRIM(CELL_COMBO_DATA_TYPE),'(공란)')
                     FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                p=PROG, s=SHEET, c=COL)
    return cur.fetchone()


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = snap(cur)
    if not before:
        sys.exit("[ABORT] 대상 행 없음 — 중단.")
    print(f"== 적용 전 == DIVISION_ID={before[0]} · INPUT={before[1]} · "
          f"CTRL={before[2]} · CMB={before[3]}")

    # 형제 시트는 손대지 않는다(AS-IS 가 다른 값)
    cur.execute("""SELECT SHEET_NAME, NVL(DIVISION_ID,'(널)') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID=:p AND COLUMN_NAME=:c AND SHEET_NAME<>:s""",
                p=PROG, c=COL, s=SHEET)
    for r in cur.fetchall():
        print(f"   [범위 밖] {PROG}/{r[0]} DIVISION_ID={r[1]} — 미변경")

    if before[0] == NEW_DIV:
        print("== 이미 정정됨 — 무변경 종료 ==")
        con.close()
        return 0
    if dry:
        print(f"== --dry: '{before[0]}' → '{NEW_DIV}' 예정. 변경 없이 종료 ==")
        con.close()
        return 0

    cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        cur.execute(f"""CREATE TABLE SCM_MGR.{BAK} AS
                        SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                         WHERE PROGRAM_ID='{PROG}' AND SHEET_NAME='{SHEET}'
                           AND COLUMN_NAME='{COL}'""")
        print(f"== BACKUP 생성: SCM_MGR.{BAK} ==")
    else:
        print(f"== BACKUP 기존 유지: SCM_MGR.{BAK} ==")

    cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                      SET DIVISION_ID=:v, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                    WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                      AND NVL(DIVISION_ID,'~') <> :v""", v=NEW_DIV, p=PROG, s=SHEET, c=COL)
    n = cur.rowcount
    con.commit()
    print(f"== COMMIT ({n}행) ==")

    print("== VERIFY ==")
    bad = 0
    after = snap(cur)
    ok = after[0] == NEW_DIV
    print(f"   {'PASS' if ok else 'FAIL'}  DIVISION_ID = {after[0]} (기대 '{NEW_DIV}')")
    bad += 0 if ok else 1
    ok = after[1] == before[1]
    print(f"   {'PASS' if ok else 'FAIL'}  INPUT_TP_CD 불변 {before[1]} → {after[1]}")
    bad += 0 if ok else 1
    ok = after[3] == before[3]
    print(f"   {'PASS' if ok else 'FAIL'}  콤보/모달 슬롯 불변 {before[3]} → {after[3]}")
    bad += 0 if ok else 1

    # 회귀 — 형제 시트 불변
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID=:p AND COLUMN_NAME=:c AND SHEET_NAME<>:s
                      AND DIVISION_ID = '40'""", p=PROG, c=COL, s=SHEET)
    print(f"   [정보] 형제 시트 중 '40' 로 바뀐 행 {cur.fetchone()[0]} (기대 0 — 원래 값 유지)")

    # 팝업 목록에서 82 로 열면 이제 빠져야 한다
    print(f"{NL}   -- Column Setting 팝업 영향 --")
    import oracledb
    for d in ("40", "82", "81"):
        rc = cur.var(oracledb.CURSOR)
        cur.callproc("SCM_MGR.DMF0002_GET_TITLESET_POPUP",
                     [PROG, SHEET, "C", "minyonglee1", d, PROG, rc])
        names = {r[2] for r in rc.getvalue().fetchall()}
        print(f"      div {d}: {COL} {'포함' if COL in names else '제외'}")

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
