#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0020 `ATTRIBUTE1` 을 사전 기준으로 정정 (사용자 지시 2026-08-22 — "Modal attr1 도 사전 기준으로").

## 배경

2026-08-22 규약 전환으로 **모달 식별자 슬롯 = `CELL_COMBO_DATA_TYPE`** 이 되었다
(`DM_MODALKEY_TO_COMBOSLOT_20260822`). `ATTRIBUTE1` 은 AS-IS `SpreadInfo` 의 `sParam1`
(콤보·모달 파라미터) 자리로 되돌아갔다.

DM 7행 중 5행은 `ATTRIBUTE1` 이 이미 division 토큰(= 파라미터)이라 정합하지만,
**DMF0020 2행만 `'ITEM'`/`'PROJECT'` 즉 모달키 값이 그대로 남아 있다**(구 규약 잔재).
사전 게이트가 이를 **D13**(모달 컬럼의 ATTRIBUTE1 에 모달키 잔존)으로 적출한다.

## 사전 기준 = 공란

AS-IS `ATTRIBUTE1` 분포(컬럼명 축 실측):

    ITEM_ID       436행 중 (공란) 430 (98%)
    PROJECT_CODE  110행 중 (공란) 101 (91%)

해당 셀의 AS-IS 실값도 공란이다:

    AS-IS DMF0020 Sales Price ITEM_ID       CTRL=(공란) CMB=(공란) ATTRIBUTE1=(공란)
    AS-IS DMF0020 Sales Price PROJECT_CODE  CTRL=(공란) CMB=(공란) ATTRIBUTE1=(공란)

⇒ 사전 표준과 셀 AS-IS 실값이 **일치**하므로 공란이 확정값이다(hook #142 §2 — 셀 AS-IS 가 상위 근거).

## 안전성

모달은 이미 `CELL_COMBO_DATA_TYPE`('ITEM'/'PROJECT')에서 열리고, FE(`SalesFuturePriceGrid:196`)는
`isModalCtrl` 이면 `cellCboDataTp` 를 1순위로 읽는다. `attribute1` 은 과도기 폴백일 뿐이라
비워도 모달 동작이 바뀌지 않는다(폴백은 앞 두 값이 모두 없을 때만 도달).

멱등: 이미 공란이면 무변경. 실행: python apply.py  (점검만: --dry)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

BAK = "BAK_DMF0020_ATTR1_20260822"
TARGETS = [("DMF0020", "Sales Price", "ITEM_ID"), ("DMF0020", "Sales Price", "PROJECT_CODE")]
NL = chr(10)


def snapshot(cur):
    out = []
    for (p, s_, c) in TARGETS:
        cur.execute("""SELECT NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'(공란)'),
                              NVL(TRIM(CELL_COMBO_DATA_TYPE),'(공란)'),
                              NVL(TRIM(ATTRIBUTE1),'(공란)')
                         FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    p=p, s=s_, c=c)
        r = cur.fetchone()
        out.append((p, c) + (tuple(r) if r else ("(행없음)", "-", "-")))
    return out


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    print("== 적용 전 (화면|컬럼|CTRL|CMB=모달키|ATTR1) ==")
    before = snapshot(cur)
    for r in before:
        print("   ", " | ".join(str(x) for x in r))
    if any(r[2] == "(행없음)" for r in before):
        sys.exit("[ABORT] 대상 행 누락 — 중단.")
    # 전제 — 모달키가 이미 CELL_COMBO_DATA_TYPE 에 있어야 비워도 안전하다
    missing = [r for r in before if r[3] in ("(공란)",)]
    if missing:
        sys.exit(f"[ABORT] 모달키가 CELL_COMBO_DATA_TYPE 에 없음 {missing} — 비우면 모달이 깨진다. 중단.")

    if dry:
        print("== --dry: 변경 없이 종료 ==")
        con.close()
        return 0

    cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        conds = " OR ".join(
            f"(PROGRAM_ID='{p}' AND SHEET_NAME='{s_}' AND COLUMN_NAME='{c}')"
            for (p, s_, c) in TARGETS)
        cur.execute(f"CREATE TABLE SCM_MGR.{BAK} AS "
                    f"SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE {conds}")
        print(f"== BACKUP 생성: SCM_MGR.{BAK} ==")
    else:
        print(f"== BACKUP 기존 유지: SCM_MGR.{BAK} ==")

    total = 0
    for (p, s_, c) in TARGETS:
        cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                          SET ATTRIBUTE1=NULL, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                          AND TRIM(ATTRIBUTE1) IS NOT NULL""", p=p, s=s_, c=c)
        total += cur.rowcount
        print(f"   {p}/{c:14s} ATTRIBUTE1 -> (NULL)  {cur.rowcount}행")
    con.commit()
    print(f"== COMMIT ({total}행) ==")

    print("== VERIFY ==")
    bad = 0
    after = snapshot(cur)
    for r in after:
        ok = r[4] == "(공란)"
        print(f"   {'PASS' if ok else 'FAIL'}  {r[0]}/{r[1]:14s} ATTR1={r[4]} (기대 공란)")
        bad += 0 if ok else 1
        ok2 = r[3] != "(공란)"
        print(f"   {'PASS' if ok2 else 'FAIL'}  {r[0]}/{r[1]:14s} 모달키 보존 CMB={r[3]}")
        bad += 0 if ok2 else 1

    # 회귀 — DM 모달 컬럼에 모달키 잔재(D13) 0
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE CELL_CONTROL_OBJECT_TYPE_CODE IN ('FPModal','FPTextModal')
                      AND TRIM(ATTRIBUTE1) IN ('ITEM','PROJECT')
                      AND PROGRAM_ID LIKE 'DMF%'""")
    left = cur.fetchone()[0]
    print(f"   {'PASS' if left == 0 else 'FAIL'}  DM ATTRIBUTE1 모달키 잔재 {left}행 (기대 0)")
    bad += 0 if left == 0 else 1

    # 회귀 — SDM/SYS 는 손대지 않았다(사용자 지정 범위 밖)
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE CELL_CONTROL_OBJECT_TYPE_CODE IN ('FPModal','FPTextModal')
                      AND TRIM(ATTRIBUTE1) IS NOT NULL
                      AND (PROGRAM_ID LIKE 'SDM%' OR PROGRAM_ID LIKE 'SYS%')""")
    print(f"   [정보] SDM/SYS 모달키 보유 {cur.fetchone()[0]}행 — 범위 밖, 미변경")

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
