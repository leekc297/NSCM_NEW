#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082 UI CATEGORY SETUP 보완 적용기.

근거: UI 메타 지식사전 v1.0 (`Doc/_rules_v2/_dictionary/`) + hook #142.
안전장치
  · 대상 5행 실존 확인 후에만 진행 (원천이 변했으면 중단)
  · 백업 테이블 선생성 (있으면 유지)
  · 각 UPDATE 의 **기대 건수** 를 검사해 하나라도 어긋나면 전체 ROLLBACK
  · 커밋 후 90_VERIFY 동등 검증 + PLANT_SITE 값 도메인 교집합 회귀 가드

실행: python apply.py            (검증만: python apply.py --dry)
"""
import os
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

TARGETS = ("PROJECT_CODE", "PLANT_SITE_ID", "DEPT_ID", "DEPT_NAME_KO", "GROUP_ID")
BAK = "BAK_DMF0082_SHEETCOL_20260821"

STEPS = [
    ("F1 PROJECT_CODE.ATTRIBUTE1 -> 'PROJECT'", 1, """
        UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
           SET ATTRIBUTE1='PROJECT', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
         WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND COLUMN_NAME='PROJECT_CODE'
           AND CELL_CONTROL_OBJECT_TYPE_CODE='FPModal' AND ATTRIBUTE1='81,82'"""),
    ("F2 PLANT_SITE_ID.COMBO -> 'FromSiteByDivision'", 1, """
        UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
           SET CELL_COMBO_DATA_TYPE='FromSiteByDivision',
               LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
         WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND COLUMN_NAME='PLANT_SITE_ID'
           AND CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox'
           AND CELL_COMBO_DATA_TYPE='PlantByDivisionCompany'"""),
    ("F3 DEPT_ID/DEPT_NAME_KO/GROUP_ID DIVISION_ID += '40'", 3, """
        UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
           SET DIVISION_ID='40,'||DIVISION_ID, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
         WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
           AND COLUMN_NAME IN ('DEPT_ID','DEPT_NAME_KO','GROUP_ID')
           AND INSTR(','||DIVISION_ID||',', ',40,')=0"""),
]


def snapshot(cur):
    cur.execute(
        """SELECT COLUMN_NAME, NVL(CELL_COMBO_DATA_TYPE,'~'), NVL(ATTRIBUTE1,'~'), DIVISION_ID
             FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
            WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
              AND COLUMN_NAME IN ('PROJECT_CODE','PLANT_SITE_ID','DEPT_ID','DEPT_NAME_KO','GROUP_ID')
            ORDER BY COLUMN_NAME""")
    return cur.fetchall()


def verify(cur):
    checks = []
    cur.execute("""SELECT NVL(MAX(ATTRIBUTE1),'(행없음)') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
                      AND COLUMN_NAME='PROJECT_CODE'""")
    checks.append(("F1 PROJECT_CODE.ATTRIBUTE1", "PROJECT", cur.fetchone()[0]))
    cur.execute("""SELECT NVL(MAX(CELL_COMBO_DATA_TYPE),'(행없음)') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
                      AND COLUMN_NAME='PLANT_SITE_ID'""")
    checks.append(("F2 PLANT_SITE_ID.COMBO", "FromSiteByDivision", cur.fetchone()[0]))
    for c in ("DEPT_ID", "DEPT_NAME_KO", "GROUP_ID"):
        cur.execute("""SELECT NVL(MAX(CASE WHEN INSTR(','||DIVISION_ID||',', ',40,')>0
                                           THEN 'Y' ELSE 'N' END),'(행없음)')
                         FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                        WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
                          AND COLUMN_NAME=:c""", c=c)
        checks.append((f"F3 {c} has 40", "Y", cur.fetchone()[0]))
    cur.execute("""SELECT COUNT(*) FROM (SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
                    GROUP BY COLUMN_NAME HAVING COUNT(*)>1)""")
    checks.append(("가드 PK 중복", "0", str(cur.fetchone()[0])))
    # 값 도메인 회귀 가드 — 정정 전 0, 정정 후 27 기대
    cur.execute("""SELECT COUNT(*) FROM (
                     SELECT SCM_SITE_ID V FROM SCM_MGR.SCM_MST_SITE
                      WHERE SITE_TYPE='PLANT' AND VALID_YN='Y'
                        AND INSTR(',81,', ','||DIVISION_ID||',')>0
                     INTERSECT
                     SELECT CODE FROM TABLE(SCM_MGR.PKG_SCM_CMBO.GET_PLANT_SITE('81')))""")
    n = cur.fetchone()[0]
    checks.append(("가드 PLANT 값도메인 교집합(div81)", ">0", f"{n}"))
    return checks


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    print("== 적용 전 실측 ==")
    before = snapshot(cur)
    for r in before:
        print("  ", r)
    if len(before) != len(TARGETS):
        sys.exit(f"[ABORT] 대상 {len(TARGETS)}행 기대 / 실제 {len(before)}행 — 원천 변동. 중단.")

    if dry:
        print("== --dry: 변경 없이 종료 ==")
        con.close()
        return 0

    cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        cur.execute(f"""CREATE TABLE SCM_MGR.{BAK} AS
                        SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                         WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
                           AND COLUMN_NAME IN ('PROJECT_CODE','PLANT_SITE_ID','DEPT_ID',
                                               'DEPT_NAME_KO','GROUP_ID')""")
        print(f"== 00 BACKUP 생성: SCM_MGR.{BAK} ==")
    else:
        print(f"== 00 BACKUP 기존 유지: SCM_MGR.{BAK} ==")
    cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{BAK}")
    print("   백업 행수:", cur.fetchone()[0])

    ok = True
    for name, exp, sql in STEPS:
        cur.execute(sql)
        got = cur.rowcount
        print(f"== {'OK ' if got == exp else 'FAIL'} {name}: 기대 {exp} / 실제 {got}")
        if got != exp:
            ok = False
    if not ok:
        con.rollback()
        sys.exit("[ROLLBACK] 기대 건수 불일치 — 변경을 되돌렸습니다.")
    con.commit()
    print("== COMMIT ==")

    print("== 90 VERIFY ==")
    bad = 0
    for item, exp, act in verify(cur):
        good = (act == exp) if exp != ">0" else (int(act) > 0)
        print(f"   {'PASS' if good else 'FAIL'}  {item:34s} 기대 {exp:20s} 실제 {act}")
        if not good:
            bad += 1
    print("== 적용 후 실측 ==")
    for r in snapshot(cur):
        print("  ", r)
    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
