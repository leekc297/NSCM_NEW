#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082 `ATTRIBUTE2='ITEM_M'` 25행 정리 (사용자 결정 2026-08-22 — ②안).

## 배경

사용자 질문: "PROJECT MODAL 은 파생을 ATTR2 에 기재하지 않았는데, ITEM MODAL 의 파생만 기재한 이유가 있나요?"

실측 결과 **의도된 구분이 아니라 작업 시점 차이**였다:

    ITEM_M 태그 25행          2025-02-05  dsiol   (원 개발분)
    PROJECT 파생 6행           2026-08-07  admin   (81/82 UICATEGORY 확장분)

두 방향(①PROJECT 에도 태그 부여 / ②소비처가 없으니 ITEM_M 제거) 중 사용자가 **②** 를 선택.

## 소비처 0 검증 (제거 전 전수 확인)

| 축 | 결과 |
|---|---|
| `ALL_SOURCE` 의 `ITEM_M` 토큰 | 12건 전부 **무관** — `PR_SCM_LGTM_INV_ALLOCATION*` 계열의 인라인 뷰(CTE) 별칭 |
| `SCM_ADM_CMBO_SQL_M` | 미등록 |
| `SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE` | 미등록 |
| FE grep `ITEM_M` | 0건 (히트는 전부 `ITEM_MODAL_CONDITION` 등 다른 식별자) |
| AS-IS 메타 | 0건 (TO-BE 전용 값) |
| 공용 매핑 `getDataMap(dataMap, attribute2)` | **무시됨** — `parseComboFilterBindings` 가 `'ITEM_M'.split(':')` 길이 1 이라 `{}` 반환 → 일반 DataMap |
| `_comboKey: cellCboDataTp ?? attribute2` (`SalesFuturePriceGrid:196`) | DMF0082 미사용 경로이고, `ITEM_M` 은 미등록 콤보라 어차피 0행. 제거하면 `undefined` 로 더 안전해진다 |

⇒ 값을 지워도 동작 변화 없음. 되레 `_comboKey` 오인 여지가 사라진다.

## 대상

`PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND TRIM(ATTRIBUTE2)='ITEM_M'` — 25행.
전부 `INPUT_TP_CD='S'`(읽기전용) 이고 Item 마스터 파생 표시 컬럼이다.

⚠ `ATTRIBUTE2` 는 **cascade 필터 슬롯**(`ROWCOL:COMBOCOL`)이 본래 용도다. 다른 화면의
`DIVISION_ID:DIVISION_ID` 같은 정상값은 손대지 않는다 — 이 화면의 `ITEM_M` 만 대상.

멱등: 이미 정리돼 있으면 무변경. 실행: python apply.py  (점검만: --dry)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

PROG, SHEET, TAG = "DMF0082", "FcstNPrice", "ITEM_M"
BAK = "BAK_DMF0082_ATTR2_ITEM_M_20260822"
NL = chr(10)


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND TRIM(ATTRIBUTE2)=:t""",
                p=PROG, s=SHEET, t=TAG)
    n_before = cur.fetchone()[0]
    print(f"== 적용 전: {PROG}/{SHEET} 의 ATTRIBUTE2='{TAG}' {n_before}행 ==")

    # 범위 밖 보호 — 다른 화면/시트에 같은 값이 있으면 중단(설계 전제 위반)
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE TRIM(ATTRIBUTE2)=:t
                      AND NOT (PROGRAM_ID=:p AND SHEET_NAME=:s)""", t=TAG, p=PROG, s=SHEET)
    outside = cur.fetchone()[0]
    print(f"   [범위 밖] 타 화면/시트의 '{TAG}' {outside}행")
    if outside:
        sys.exit(f"[ABORT] 범위 밖에 {outside}행 존재 — 영향 범위 재확인 필요. 중단.")

    # 정상 cascade 값은 건드리지 않는지 사전 확인
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE INSTR(NVL(ATTRIBUTE2,''), ':') > 0""")
    cascade_before = cur.fetchone()[0]
    print(f"   [보호 대상] cascade 형식(':' 포함) ATTRIBUTE2 {cascade_before}행 — 불변이어야 함")

    if n_before == 0:
        print("== 이미 정리됨 — 무변경 종료 ==")
        con.close()
        return 0
    if dry:
        cur.execute("""SELECT COLUMN_NAME, NVL(COLUMN_LABEL_NAME,'-'), NVL(INPUT_TP_CD,'-')
                         FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND TRIM(ATTRIBUTE2)=:t
                        ORDER BY 1""", p=PROG, s=SHEET, t=TAG)
        print(f"{NL}   -- 대상 목록 --")
        for r in cur.fetchall():
            print("     ", " | ".join(str(x) for x in r))
        print("== --dry: 변경 없이 종료 ==")
        con.close()
        return 0

    cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        cur.execute(f"""CREATE TABLE SCM_MGR.{BAK} AS
                        SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                         WHERE PROGRAM_ID='{PROG}' AND SHEET_NAME='{SHEET}'
                           AND TRIM(ATTRIBUTE2)='{TAG}'""")
        print(f"== BACKUP 생성: SCM_MGR.{BAK} ({n_before}행) ==")
    else:
        print(f"== BACKUP 기존 유지: SCM_MGR.{BAK} ==")

    cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                      SET ATTRIBUTE2=NULL, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                    WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND TRIM(ATTRIBUTE2)=:t""",
                p=PROG, s=SHEET, t=TAG)
    n_upd = cur.rowcount
    con.commit()
    print(f"== COMMIT ({n_upd}행) ==")

    print("== VERIFY ==")
    bad = 0
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE TRIM(ATTRIBUTE2)=:t""", t=TAG)
    left = cur.fetchone()[0]
    print(f"   {'PASS' if left == 0 else 'FAIL'}  '{TAG}' 잔존 {left}행 (기대 0)")
    bad += 0 if left == 0 else 1

    ok = n_upd == n_before
    print(f"   {'PASS' if ok else 'FAIL'}  갱신 건수 {n_upd} == 대상 {n_before}")
    bad += 0 if ok else 1

    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE INSTR(NVL(ATTRIBUTE2,''), ':') > 0""")
    cascade_after = cur.fetchone()[0]
    ok = cascade_after == cascade_before
    print(f"   {'PASS' if ok else 'FAIL'}  cascade ATTRIBUTE2 불변  "
          f"전 {cascade_before} / 후 {cascade_after}")
    bad += 0 if ok else 1

    # 백업으로 원복 가능한지 (행 수 일치)
    cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{BAK}")
    nb = cur.fetchone()[0]
    ok = nb == n_before
    print(f"   {'PASS' if ok else 'FAIL'}  백업 {nb}행 == 원본 {n_before}행 (원복 가능)")
    bad += 0 if ok else 1

    # 이 화면의 다른 컬럼 메타는 손대지 않았는지
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID=:p AND SHEET_NAME=:s""", p=PROG, s=SHEET)
    print(f"   [정보] {PROG}/{SHEET} 총 {cur.fetchone()[0]}행 (컬럼 수 불변)")

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
