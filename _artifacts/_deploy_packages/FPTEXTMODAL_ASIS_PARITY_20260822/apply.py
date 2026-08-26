#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS 파리티 복원 — `FPModal` → `FPTextModal` + 모달키(ATTRIBUTE1) 정리.

## 왜 필요한가 (실측 근거)

공용 DataGrid 에서 `FPModal` 은 **세 가지를 한 덩어리로** 지배한다:
    ① beginningEdit cancel(타이핑 차단)   packages/shared/.../dataGridUtils.ts:275
    ② 돋보기 아이콘 `is-popup`             :161
    ③ 팝업 셀 스타일 `wj-cell-popup`       :227
그래서 기존 두 값으로는 AS-IS 동작을 표현할 수 없었다.
    · FPTextBox → 타이핑 O / 아이콘 X (모달이 있어도 사용자가 알 수 없다)
    · FPModal   → 아이콘 O / 타이핑 X

AS-IS 는 `TextCellType` + `BackgroundImage(ImagePopUp)` + `CellDoubleClick` 조합이라 **둘 다** 됐다
(`DMF0082_FcstNPrice_Mgmt.cs:404-407` / `:2541` / `:3772`).
⇒ 신설값 `FPTextModal` = ①은 허용, ②③은 FPModal 과 동일.

## AS-IS 실측 대조 (SCM_MST_SHEET_COLUMNS)

    DMF0003 Mkt Fcst   ITEM_ID / ITEM_ID40 / PROJECT_CODE = 'FPTextBox'   → TO-BE 가 FPModal 로 바꿈
    DMF0020 Sales Price ITEM_ID / PROJECT_CODE            = (공란=텍스트)  → TO-BE 가 FPModal 로 바꿈
    DMF0082 FcstNPrice  ITEM_ID                            = 'FPTextBox'   → TO-BE 유지(모달 배선만 누락)

⇒ TO-BE 가 `FPModal` 로 바꾼 5건은 **AS-IS 대비 타이핑 기능이 사라진 상태**다. 이를 복원한다.

## 모달키(ATTRIBUTE1) 정리

`ATTRIBUTE1` 은 이미 모달키 슬롯이고 FE 가 실소비한다
(`MktFcstGrid.tsx:265` `_modalKey: fb?._modalKey ?? col.attribute1` /
 `SalesFuturePriceGrid.tsx:196` / DMF0020 메타에 'PROJECT'·'ITEM' 정상 등재).
그런데 DMF0003 3건에는 division 목록('81,82'/'40')이 들어가 있다 — 화면이 상수로 방어 중이라
증상이 없을 뿐, 메타 위임으로 바꾸는 순간 모달이 깨진다(DMF0003 에서 실제 발생했던 사고).
⇒ 새 슬롯을 만들지 않고 **오염된 값만 정리**한다.

멱등: 현재값이 기대와 다를 때만 갱신. 실행: python apply.py  (점검만: --dry)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

BAK = "BAK_FPTEXTMODAL_PARITY_20260822"

# (PROGRAM_ID, SHEET_NAME, COLUMN_NAME) -> (신규 CTRL, 모달키 or None=변경안함)
PLAN = {
    ("DMF0003", "Mkt Fcst", "ITEM_ID"):      ("FPTextModal", "ITEM"),
    ("DMF0003", "Mkt Fcst", "ITEM_ID40"):    ("FPTextModal", "ITEM"),
    ("DMF0003", "Mkt Fcst", "PROJECT_CODE"): ("FPTextModal", "PROJECT"),
    ("DMF0020", "Sales Price", "ITEM_ID"):      ("FPTextModal", "ITEM"),
    ("DMF0020", "Sales Price", "PROJECT_CODE"): ("FPTextModal", "PROJECT"),
    # DMF0082 는 AS-IS 가 FPTextBox — 모달 배선만 누락돼 있었다. 아이콘·모달을 살리려면 신규값 필요.
    ("DMF0082", "FcstNPrice", "ITEM_ID"):    ("FPTextModal", "ITEM"),
}


def snapshot(cur):
    out = []
    for (p, s_, c) in PLAN:
        cur.execute("""SELECT NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'(공란)'), NVL(ATTRIBUTE1,'(공란)'),
                              INPUT_TP_CD
                         FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    p=p, s=s_, c=c)
        r = cur.fetchone()
        out.append((p, s_, c, r[0] if r else "(행없음)", r[1] if r else "-", r[2] if r else "-"))
    return out


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    print("== 적용 전 실측 (화면 | 시트 | 컬럼 | CTRL | ATTRIBUTE1 | INPUT) ==")
    before = snapshot(cur)
    for r in before:
        print("  ", r)
    if any(r[3] == "(행없음)" for r in before):
        sys.exit("[ABORT] 대상 행 누락 — 원천 변동. 중단.")
    if dry:
        print("== --dry: 변경 없이 종료 ==")
        con.close()
        return 0

    cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        conds = " OR ".join(
            f"(PROGRAM_ID='{p}' AND SHEET_NAME='{s_}' AND COLUMN_NAME='{c}')" for (p, s_, c) in PLAN)
        cur.execute(f"CREATE TABLE SCM_MGR.{BAK} AS "
                    f"SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE {conds}")
        print(f"== BACKUP 생성: SCM_MGR.{BAK} ==")
    else:
        print(f"== BACKUP 기존 유지: SCM_MGR.{BAK} ==")

    total = 0
    for (p, s_, c), (ctrl, mkey) in PLAN.items():
        cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                          SET CELL_CONTROL_OBJECT_TYPE_CODE=:v,
                              LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                          AND NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'~') <> :v""",
                    v=ctrl, p=p, s=s_, c=c)
        n1 = cur.rowcount
        n2 = 0
        if mkey:
            cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                              SET ATTRIBUTE1=:v, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                            WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                              AND NVL(ATTRIBUTE1,'~') <> :v""",
                        v=mkey, p=p, s=s_, c=c)
            n2 = cur.rowcount
        total += n1 + n2
        print(f"   {p}/{c:14s} CTRL->{ctrl} ({n1}행) · ATTRIBUTE1->{mkey} ({n2}행)")
    con.commit()
    print(f"== COMMIT (총 {total}행) ==")

    print("== VERIFY ==")
    bad = 0
    for (p, s_, c), (ctrl, mkey) in PLAN.items():
        cur.execute("""SELECT NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'(공란)'), NVL(ATTRIBUTE1,'(공란)')
                         FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    p=p, s=s_, c=c)
        a_ctrl, a_key = cur.fetchone()
        ok = a_ctrl == ctrl and (not mkey or a_key == mkey)
        print(f"   {'PASS' if ok else 'FAIL'}  {p}/{c:14s} {a_ctrl:12s} / {a_key}")
        bad += 0 if ok else 1

    # 회귀 가드 — FPModal 잔존분은 손대지 않았는지(의도한 6건만 바뀌어야 한다)
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE CELL_CONTROL_OBJECT_TYPE_CODE='FPTextModal'""")
    n = cur.fetchone()[0]
    print(f"   {'PASS' if n == len(PLAN) else 'WARN'}  FPTextModal 총 행수 "
          f"기대 {len(PLAN)} / 실제 {n}")

    print("== 적용 후 실측 ==")
    for r in snapshot(cur):
        print("  ", r)
    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
