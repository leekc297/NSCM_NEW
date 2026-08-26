#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0003 Mkt Fcst.PLANT_SITE_ID 콤보 정정 — AS-IS 기준 복원.

무엇을
    CELL_COMBO_DATA_TYPE : 'PlantByDivisionCompany' -> 'FromSiteByDivision'

왜 (사용자 확정 2026-08-21: "DMF0003 도 표준이 아니다. AS-IS 사전정보 기준이면 FromSiteByDivision")
    · AS-IS DMF0003 'Mkt Fcst'.PLANT_SITE_ID = FromSiteByDivision (사이트 코드) — 실측
    · TO-BE 가 PlantByDivisionCompany(플랜트 코드)로 바꿔 값 도메인이 갈렸다.
        그리드 셀  PlantByDivisionCompany = SCM_MST_PLANT_SN.PLANT_ID  → 'HQ04'   (div81 12건)
        조회조건    PlantSitebyEndCustomer = SCM_AXIS_V.SITE_ID        → 'HQ07-A' (div81 28건)
        교집합 **0건** ⇒ 그리드에서 고른 값이 조회조건으로 검색되지 않고,
                        GET 이 사이트 코드를 주면 셀 콤보에 없어 CODE raw 노출.
    · 이 행은 INPUT_TP_CD='IM' (신규행 필수 입력) 이라 사용자가 실제로 도달한다.
    · 같은 결함을 DMF0082 에서 먼저 정정했고(2026-08-21), DMF0003 이 그 원본이다.

범위 밖 (정상이므로 건드리지 않음)
    · DMF0005 'SALES_PLANT' 7행 — **AS-IS 도 PlantByDivisionCompany** 다. 플랜트 코드가 맞는 축.

안전장치: 대상 실존 확인 → 백업 → 기대 건수(1) 불일치 시 ROLLBACK → 커밋 후 검증.
실행: python apply.py        (검증만: python apply.py --dry)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

BAK = "BAK_DMF0003_PLANTSITE_20260821"
WHERE = ("PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst' AND COLUMN_NAME='PLANT_SITE_ID'")


def snapshot(cur):
    cur.execute(f"""SELECT COLUMN_NAME, NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'~'),
                           NVL(CELL_COMBO_DATA_TYPE,'~'), INPUT_TP_CD, DIVISION_ID
                      FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE {WHERE}""")
    return cur.fetchall()


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    print("== 적용 전 실측 ==")
    before = snapshot(cur)
    for r in before:
        print("  ", r)
    if len(before) != 1:
        sys.exit(f"[ABORT] 대상 1행 기대 / 실제 {len(before)}행 — 원천 변동. 중단.")
    if dry:
        print("== --dry: 변경 없이 종료 ==")
        con.close()
        return 0

    cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        cur.execute(f"CREATE TABLE SCM_MGR.{BAK} AS "
                    f"SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE {WHERE}")
        print(f"== BACKUP 생성: SCM_MGR.{BAK} ==")
    else:
        print(f"== BACKUP 기존 유지: SCM_MGR.{BAK} ==")
    cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{BAK}")
    print("   백업 행수:", cur.fetchone()[0])

    cur.execute(f"""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                       SET CELL_COMBO_DATA_TYPE='FromSiteByDivision',
                           LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                     WHERE {WHERE}
                       AND CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox'
                       AND CELL_COMBO_DATA_TYPE='PlantByDivisionCompany'""")
    got = cur.rowcount
    print(f"== {'OK ' if got == 1 else 'FAIL'} PLANT_SITE_ID.COMBO -> FromSiteByDivision: "
          f"기대 1 / 실제 {got}")
    if got != 1:
        con.rollback()
        sys.exit("[ROLLBACK] 기대 건수 불일치 — 변경을 되돌렸습니다.")
    con.commit()
    print("== COMMIT ==")

    print("== VERIFY ==")
    bad = 0
    cur.execute(f"SELECT NVL(MAX(CELL_COMBO_DATA_TYPE),'(행없음)') "
                f"FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE {WHERE}")
    act = cur.fetchone()[0]
    ok = act == "FromSiteByDivision"
    print(f"   {'PASS' if ok else 'FAIL'}  PLANT_SITE_ID.COMBO            "
          f"기대 FromSiteByDivision  실제 {act}")
    bad += 0 if ok else 1

    # 회귀 가드 — 그리드 셀 ↔ 조회조건 값 도메인 교집합 (정정 전 0 / 정정 후 27 기대)
    cur.execute("""SELECT COUNT(*) FROM (
                     SELECT SCM_SITE_ID V FROM SCM_MGR.SCM_MST_SITE
                      WHERE SITE_TYPE='PLANT' AND VALID_YN='Y'
                        AND INSTR(',81,', ','||DIVISION_ID||',')>0
                     INTERSECT
                     SELECT CODE FROM TABLE(SCM_MGR.PKG_SCM_CMBO.GET_PLANT_SITE('81')))""")
    n = cur.fetchone()[0]
    print(f"   {'PASS' if n > 0 else 'FAIL'}  가드 값도메인 교집합(div81)        기대 >0   실제 {n}")
    bad += 0 if n > 0 else 1

    # 회귀 가드 — DMF0005 SALES_PLANT 는 손대지 않았는지 (AS-IS 정상값 유지)
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID='DMF0005' AND COLUMN_NAME='SALES_PLANT'
                      AND CELL_COMBO_DATA_TYPE='PlantByDivisionCompany'""")
    n5 = cur.fetchone()[0]
    print(f"   {'PASS' if n5 == 7 else 'FAIL'}  가드 DMF0005 SALES_PLANT 불변     기대 7    실제 {n5}")
    bad += 0 if n5 == 7 else 1

    print("== 적용 후 실측 ==")
    for r in snapshot(cur):
        print("  ", r)
    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
