#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""모달 식별자 슬롯 이전 — `ATTRIBUTE1` → `CELL_COMBO_DATA_TYPE` (DM 한정, 사용자 결정 2026-08-22).

## 결정 내용 (사용자)

    "어떤 모달을 열지는 Cell Combo Data Type 에 넣어서 관리"
    "ATTR1 의 경우에는 기존에 등록되어 있던 값으로 대체"
    "실제 AS-IS 에는 ATTR1 을 사용하고 있지 않습니다"
    "SDM, SYS 는 수정하지 않고 DM 만 진행"
    "FPComboBox 일 때는 Combo, FPModal/FPTextModal 일 때는 Modal 호출용으로 cellCboDataTp 를 사용"

⇒ `CELL_COMBO_DATA_TYPE` 은 **컨트롤 타입에 따라 의미가 갈리는 슬롯**이 된다.
      FPComboBox              → 콤보 SQL_ID
      FPModal / FPTextModal   → 모달키

## 근거

AS-IS 메타에는 모달 개념이 아예 없다 — `CELL_CONTROL_OBJECT_TYPE_CODE='FPModal'` **0건**(전수 실측).
`ATTRIBUTE1~5` 는 AS-IS `SpreadInfo` 의 `sParam1~5`(콤보·모달에 넘기는 파라미터) 자리이고,
실제로 DMF0003/DMF0082 의 AS-IS 값은 division 토큰이다. 모달키를 거기 넣은 것은 TO-BE 관례였다.

## 대상 (DM 7행 — SDM/SYS 는 손대지 않는다)

    화면      시트           컬럼            CMB(모달키)   ATTRIBUTE1 복원값   복원 근거
    DMF0003  Mkt Fcst      ITEM_ID         ITEM         '81,82'            AS-IS 실값
    DMF0003  Mkt Fcst      ITEM_ID40       ITEM         '40'               AS-IS 실값
    DMF0003  Mkt Fcst      PROJECT_CODE    PROJECT      '81,82'            AS-IS 실값
    DMF0020  Sales Price   ITEM_ID         ITEM         'ITEM'             기존 등록값 유지
    DMF0020  Sales Price   PROJECT_CODE    PROJECT      'PROJECT'          기존 등록값 유지
    DMF0082  FcstNPrice    ITEM_ID         ITEM         '40,81,82'         TO-BE 기존값(81/82 확장)
    DMF0082  FcstNPrice    PROJECT_CODE    PROJECT      '81,82'            TO-BE 기존값(AS-IS 행 없음)

⚠ **`ATTRIBUTE1` 은 비우지 않는다** — 사용자 추가 지시 2026-08-22: "기존에 attr1 을 사용하던 것은
  그대로 유지해주세요". 이 작업이 옮기는 것은 **모달 식별자의 소비 슬롯**뿐이고, `ATTRIBUTE1` 에 이미
  들어 있던 값은 화면별 기존 등록값 그대로 되돌린다(DMF0003/DMF0082 는 division 토큰, DMF0020 은
  'ITEM'/'PROJECT'). DMF0020 은 두 슬롯에 같은 값이 남지만, FE 가 모달키를
  `CELL_COMBO_DATA_TYPE` 에서만 읽으므로 `ATTRIBUTE1` 은 파라미터 슬롯으로 유휴 상태가 된다.
⚠ DMF0082 ITEM_ID 의 AS-IS 는 '40' 이지만 TO-BE 는 40/81/82 를 모두 다루므로 기존 등록값을 유지한다.

## 잃는 값 없음

덮어쓰는 `CELL_COMBO_DATA_TYPE` 기존값(ItemByDivision/ProjectByDivision)은 **AS-IS 에 없던 TO-BE 추가분**
이고, 모달 컨트롤에서는 공용 DataGrid 가 콤보로 소비하지 않아 **inert** 였다(사전 D12 가 "지정됐으나
소비되지 않음" 으로 적출하던 행). AS-IS CMB 는 7행 모두 공란이다.

멱등: 기대값과 다를 때만 갱신. 실행: python apply.py  (점검만: --dry)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

BAK = "BAK_DM_MODALKEY_SLOT_20260822"

# (PROGRAM_ID, SHEET_NAME, COLUMN_NAME) -> (모달키, ATTRIBUTE1 복원값 | None=NULL)
PLAN = {
    ("DMF0003", "Mkt Fcst", "ITEM_ID"):         ("ITEM",    "81,82"),
    ("DMF0003", "Mkt Fcst", "ITEM_ID40"):       ("ITEM",    "40"),
    ("DMF0003", "Mkt Fcst", "PROJECT_CODE"):    ("PROJECT", "81,82"),
    ("DMF0020", "Sales Price", "ITEM_ID"):      ("ITEM",    "ITEM"),
    ("DMF0020", "Sales Price", "PROJECT_CODE"): ("PROJECT", "PROJECT"),
    ("DMF0082", "FcstNPrice", "ITEM_ID"):       ("ITEM",    "40,81,82"),
    ("DMF0082", "FcstNPrice", "PROJECT_CODE"):  ("PROJECT", "81,82"),
}
MODAL_CTRLS = ("FPModal", "FPTextModal")
SDM_SYS_SQL = """SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                  WHERE CELL_CONTROL_OBJECT_TYPE_CODE IN ('FPModal','FPTextModal')
                    AND TRIM(ATTRIBUTE1) IS NOT NULL
                    AND (PROGRAM_ID LIKE 'SDM%' OR PROGRAM_ID LIKE 'SYS%')"""


def snapshot(cur):
    out = []
    for (p, s_, c) in PLAN:
        cur.execute("""SELECT NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'(공란)'),
                              NVL(TRIM(CELL_COMBO_DATA_TYPE),'(공란)'),
                              NVL(TRIM(ATTRIBUTE1),'(공란)')
                         FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    p=p, s=s_, c=c)
        r = cur.fetchone()
        out.append((p, s_, c) + (tuple(r) if r else ("(행없음)", "-", "-")))
    return out


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    print("== 적용 전 실측 (화면|시트|컬럼|CTRL|CMB|ATTR1) ==")
    before = snapshot(cur)
    for r in before:
        print("   ", " | ".join(str(x) for x in r))
    if any(r[3] == "(행없음)" for r in before):
        sys.exit("[ABORT] 대상 행 누락 — 원천 변동. 중단.")
    bad_ctrl = [r for r in before if r[3] not in MODAL_CTRLS]
    if bad_ctrl:
        sys.exit(f"[ABORT] 모달 컨트롤이 아닌 행 {bad_ctrl} — 슬롯 의미가 갈리므로 중단.")

    cur.execute(SDM_SYS_SQL)
    sdm_sys_before = cur.fetchone()[0]
    print(f"   [범위 밖] SDM/SYS 모달키 보유 {sdm_sys_before}행 — 미변경 대상")

    if dry:
        print("== --dry: 변경 없이 종료 ==")
        con.close()
        return 0

    cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        conds = " OR ".join(
            f"(PROGRAM_ID='{p}' AND SHEET_NAME='{s_}' AND COLUMN_NAME='{c}')"
            for (p, s_, c) in PLAN)
        cur.execute(f"CREATE TABLE SCM_MGR.{BAK} AS "
                    f"SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE {conds}")
        print(f"== BACKUP 생성: SCM_MGR.{BAK} ==")
    else:
        print(f"== BACKUP 기존 유지: SCM_MGR.{BAK} ==")

    total = 0
    for (p, s_, c), (mkey, a1) in PLAN.items():
        cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                          SET CELL_COMBO_DATA_TYPE=:v,
                              LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                          AND NVL(TRIM(CELL_COMBO_DATA_TYPE),'~') <> :v""",
                    v=mkey, p=p, s=s_, c=c)
        n1 = cur.rowcount
        if a1 is None:
            cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                              SET ATTRIBUTE1=NULL, LAST_UPDATED_BY='admin',
                                  LAST_UPDATE_DATE=SYSDATE
                            WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                              AND TRIM(ATTRIBUTE1) IS NOT NULL""", p=p, s=s_, c=c)
        else:
            cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                              SET ATTRIBUTE1=:v, LAST_UPDATED_BY='admin',
                                  LAST_UPDATE_DATE=SYSDATE
                            WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                              AND NVL(TRIM(ATTRIBUTE1),'~') <> :v""", v=a1, p=p, s=s_, c=c)
        n2 = cur.rowcount
        total += n1 + n2
        print(f"   {p}/{c:14s} CMB->{mkey:8s}({n1}행) · ATTR1->{a1 or '(NULL)':10s}({n2}행)")
    con.commit()
    print(f"== COMMIT (총 {total}행) ==")

    print("== VERIFY ==")
    bad = 0
    for (p, s_, c), (mkey, a1) in PLAN.items():
        cur.execute("""SELECT NVL(TRIM(CELL_COMBO_DATA_TYPE),'(공란)'),
                              NVL(TRIM(ATTRIBUTE1),'(공란)')
                         FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    p=p, s=s_, c=c)
        a_cmb, a_a1 = cur.fetchone()
        exp_a1 = a1 or "(공란)"
        ok = a_cmb == mkey and a_a1 == exp_a1
        print(f"   {'PASS' if ok else 'FAIL'}  {p}/{c:14s} CMB={a_cmb:10s} ATTR1={a_a1:10s} "
              f"(기대 {mkey} / {exp_a1})")
        bad += 0 if ok else 1

    cur.execute(SDM_SYS_SQL)
    after = cur.fetchone()[0]
    ok = after == sdm_sys_before
    print(f"   {'PASS' if ok else 'FAIL'}  SDM/SYS 무변경  전 {sdm_sys_before} / 후 {after}")
    bad += 0 if ok else 1

    # 회귀 — 대상 7행 밖의 DM 모달 컬럼은 손대지 않았는지 (CMB 가 모달키로 바뀐 행 = 정확히 7)
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE CELL_CONTROL_OBJECT_TYPE_CODE IN ('FPModal','FPTextModal')
                      AND TRIM(CELL_COMBO_DATA_TYPE) IN ('ITEM','PROJECT')
                      AND PROGRAM_ID LIKE 'DMF%'""")
    n = cur.fetchone()[0]
    print(f"   {'PASS' if n == len(PLAN) else 'FAIL'}  DM 모달키 슬롯 보유 {n}행 (기대 {len(PLAN)})")
    bad += 0 if n == len(PLAN) else 1

    print("== 적용 후 실측 ==")
    for r in snapshot(cur):
        print("   ", " | ".join(str(x) for x in r))
    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
