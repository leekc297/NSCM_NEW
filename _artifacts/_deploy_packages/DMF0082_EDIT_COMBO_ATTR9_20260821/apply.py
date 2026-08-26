#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""편집 콤보 ID 를 메타 `ATTRIBUTE9` 로 이관 (사용자 지정 2026-08-21).

배경
    편집 전용 콤보가 FE 화면 상수(`GRID_EDIT_COMBO`)에만 있어 **UI CATEGORY SETUP 에서 확인 불가**
    → 운영자가 화면이 실제로 무슨 콤보를 쓰는지 알 수 없었다.
    실제 사고: `PLANT_SITE_ID` 메타를 `FromSiteByDivision` 로 고쳐도 상수(`PlantByDivisionCompany`)가
    편집 시 덮어써 값 도메인이 갈린 채 남았다.

규약 (사용자 지정)
    · 편집 콤보 ID = `ATTRIBUTE9`
    · `ATTRIBUTE9` 가 비면 표시 콤보(`CELL_COMBO_DATA_TYPE`)를 편집에도 사용
    · `PLANT_SITE_ID` 는 **편집 콤보를 쓰지 않는다** → ATTRIBUTE9 공란 유지 + FE 스왑 대상에서 제외

⚠ ATTRIBUTE9 는 전 15,702행에서 **사용 이력 0** 인 빈 슬롯이다(실측). admin SYS0004 는 이미
   `Column param9` 로 노출하므로 DDL·화면 변경 없이 운영자가 관리할 수 있다.

멱등: 현재값이 기대와 다를 때만 갱신. 실행: python apply.py  (점검만: --dry)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

PROG, SHEET = "DMF0082", "FcstNPrice"
BAK = "BAK_DMF0082_EDITCOMBO_20260821"

# binding -> 편집 콤보 ID (None = 편집 콤보 없음 → 표시 콤보 사용)
PLAN = {
    # AS-IS `GetLookupValues("INCOTERMS","ALL","Y")` = ATTRIBUTE2='Y'(편집허용) 한정.
    #   표시 `Incoterms` 의 진부분집합 — AS-IS 파리티.
    "INCOTERMS": "IncotermsEdit",
    # AS-IS `UP_FX_GetCommonDataList_DM @Code='DM_CUSTOMS_HANDBOOK'` (lookup DM_CUSTOMS_HANDBOOK_40).
    "DOM_EXP": "CustomsHandbook",
    # 편집 = 표시 동일(옵션 divisionParam 만 다름) → ATTRIBUTE9 불필요.
    "END_CUSTOMER": None,
    # 사용자 지정: 편집 콤보 미사용.
    "PLANT_SITE_ID": None,
}
TARGETS = tuple(PLAN)


def snapshot(cur):
    cur.execute(f"""SELECT COLUMN_NAME, NVL(CELL_COMBO_DATA_TYPE,'~') , NVL(ATTRIBUTE9,'(공란)')
                      FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                     WHERE PROGRAM_ID='{PROG}' AND SHEET_NAME='{SHEET}'
                       AND COLUMN_NAME IN {TARGETS}
                     ORDER BY COLUMN_NAME""")
    return cur.fetchall()


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    print("== 적용 전 실측 (컬럼 | 표시콤보 | ATTRIBUTE9) ==")
    before = snapshot(cur)
    for r in before:
        print("  ", r)
    if len(before) != len(TARGETS):
        sys.exit(f"[ABORT] 대상 {len(TARGETS)}행 기대 / 실제 {len(before)}행 — 원천 변동. 중단.")

    # 등재할 콤보 ID 가 실존하는지 먼저 확인 (없는 ID 를 넣으면 편집 시 0행)
    for col, combo in PLAN.items():
        if not combo:
            continue
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:s", s=combo)
        if cur.fetchone()[0] == 0:
            sys.exit(f"[ABORT] 콤보 '{combo}' 가 SCM_ADM_CMBO_SQL_M 에 미등록 — 등재 중단.")
        print(f"   콤보 실존 확인: {combo}")

    if dry:
        print("== --dry: 변경 없이 종료 ==")
        con.close()
        return 0

    cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        cur.execute(f"""CREATE TABLE SCM_MGR.{BAK} AS
                        SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                         WHERE PROGRAM_ID='{PROG}' AND SHEET_NAME='{SHEET}'
                           AND COLUMN_NAME IN {TARGETS}""")
        print(f"== BACKUP 생성: SCM_MGR.{BAK} ==")
    else:
        print(f"== BACKUP 기존 유지: SCM_MGR.{BAK} ==")

    total = 0
    for col, combo in PLAN.items():
        if combo:
            cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                              SET ATTRIBUTE9=:v, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                            WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                              AND NVL(ATTRIBUTE9,'~') <> :v""",
                        v=combo, p=PROG, s=SHEET, c=col)
        else:
            # 편집 콤보 미사용 — 공란 보장 (이미 공란이면 0행)
            cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                              SET ATTRIBUTE9=NULL, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                            WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                              AND TRIM(ATTRIBUTE9) IS NOT NULL""",
                        p=PROG, s=SHEET, c=col)
        n = cur.rowcount
        total += n
        print(f"   {col:16s} -> {combo or '(공란=표시콤보 사용)':28s} {n}행")
    con.commit()
    print(f"== COMMIT (총 {total}행) ==")

    print("== VERIFY ==")
    bad = 0
    for col, combo in PLAN.items():
        cur.execute("""SELECT NVL(ATTRIBUTE9,'(공란)') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                        WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                    p=PROG, s=SHEET, c=col)
        act = cur.fetchone()[0]
        exp = combo or "(공란)"
        ok = act == exp
        print(f"   {'PASS' if ok else 'FAIL'}  {col:16s} 기대 {exp:28s} 실제 {act}")
        bad += 0 if ok else 1

    # 회귀 가드 — ATTRIBUTE9 는 이 화면 외에서 쓰이지 않아야 한다(슬롯 용도 고정 확인)
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE TRIM(ATTRIBUTE9) IS NOT NULL
                      AND NOT (PROGRAM_ID=:p AND SHEET_NAME=:s)""", p=PROG, s=SHEET)
    other = cur.fetchone()[0]
    print(f"   {'PASS' if other == 0 else 'WARN'}  타 화면 ATTRIBUTE9 사용   기대 0    실제 {other}")

    print("== 적용 후 실측 ==")
    for r in snapshot(cur):
        print("  ", r)
    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
