#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082 `VERSION_NO.VISIBLE_FLAG` → `'Y'` (사용자 결정 2026-08-22).

## 왜 AS-IS 와 달라지는가 — **의도적 차이. 되돌리지 말 것.**

AS-IS 메타는 `VISIBLE_FLAG='N'` 인데 **AS-IS 화면에는 Measure 앞에 보인다.** 사용자 신고로 확인.

원인은 AS-IS **프레임워크 오버로드**다. DMF0082 는 `SpreadInfo.CreateSheetHeaderColumn`
(`SpreadInfo.cs:1324`, 호출 `DMF0082_FcstNPrice_Mgmt.cs:421`)을 쓰는데,
**이 오버로드는 `VISIBLE_FLAG` 를 단 한 번도 읽지 않는다**(구간 내 출현 0회 — `isVisible` 을
`VALID_YN` 으로만 판정). 다른 오버로드 5곳(`:1871 :2208 :2556 :2908 :14472`)만 검사한다.

⇒ AS-IS 는 **메타를 무시하고** 표시한 것이고, 메타값 `'N'` 은 화면 사실과 어긋난다.
TO-BE 는 `PR_GET_SHEET_COLUMN_LIST` + FE 매핑이 `VISIBLE_FLAG` 를 정상 적용하므로 그대로 두면
**AS-IS 에 보이던 컬럼이 TO-BE 에서 사라진다.**

⇒ AS-IS **화면 파리티**를 위해 TO-BE 메타를 `'Y'` 로 올린다 (런타임 사실을 메타로 표현).

**선례 동일** — 같은 시트 `MEASURE` 도 AS-IS `'N'` → TO-BE **`'Y'`** 로 이미 처리돼 있다
(정렬 450, 폭 95). `VERSION_NO` 는 그 기준을 그대로 따른다.

    AS-IS  VERSION_NO  VIS='N' SORT=390          ← 화면엔 보임(프레임워크가 플래그 무시)
    TO-BE  VERSION_NO  VIS='N' → **'Y'** SORT=390 폭 125 DIV='40,82,81,…'

정렬 390 < MEASURE 450 이라 **Measure 앞**에 놓인다 — AS-IS 화면 배치와 동일.

## 범위

`VISIBLE_FLAG` 만 바꾼다. `SORT_ORDER_NO`/`COLUMN_WIDTH`/`DIVISION_ID` 는 AS-IS 와 이미 동일하므로 불변.
`MEASURE_GROUP`(AS-IS·TO-BE 둘 다 `'N'`, 폭 0)은 **손대지 않는다** — 그룹핑 키이지 표시 컬럼이 아니다.

⚠ 이 값은 **AS-IS 메타(`'N'`)와 의도적으로 다르다.** 뒤에 AS-IS 대조만 보고 `'N'` 으로 되돌리면
   화면에서 Version 이 사라진다(hook #142 §4.3 계보 — 근거 없는 되돌림 금지).

멱등: 이미 `'Y'` 면 무변경. 실행: python apply.py  (점검만: --dry)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402
import oracledb  # noqa: E402

PROG, SHEET, COL, NEW = "DMF0082", "FcstNPrice", "VERSION_NO", "Y"
BAK = "BAK_DMF0082_VERSIONNO_VISIBLE_20260822"
NL = chr(10)


def snap(cur):
    cur.execute("""SELECT NVL(VISIBLE_FLAG,'(널)'), SORT_ORDER_NO, COLUMN_WIDTH,
                          NVL(DIVISION_ID,'(널)'), NVL(VALID_YN,'-')
                     FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c""",
                p=PROG, s=SHEET, c=COL)
    return cur.fetchone()


def grid_cols(cur, div):
    """메인 그리드가 실제로 받는 컬럼 — PR_GET_SHEET_COLUMN_LIST."""
    rc = cur.var(oracledb.CURSOR)
    cur.callproc("SCM_MGR.PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST",
                 ["minyonglee1", PROG, SHEET, div, rc])
    c = rc.getvalue()
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = snap(cur)
    if not before:
        sys.exit("[ABORT] 대상 행 없음 — 중단.")
    print(f"== 적용 전 == VISIBLE={before[0]} · SORT={before[1]} · 폭={before[2]} · "
          f"DIV={before[3]} · VALID={before[4]}")
    if before[4] != "Y":
        sys.exit("[ABORT] VALID_YN 이 'Y' 가 아님 — 표시 대상이 아니다. 중단.")

    # 선례 확인 — 같은 시트 MEASURE 가 이미 'Y' 인가
    cur.execute("""SELECT NVL(VISIBLE_FLAG,'-') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME='MEASURE'""",
                p=PROG, s=SHEET)
    m = cur.fetchone()
    print(f"   [선례] 같은 시트 MEASURE VISIBLE_FLAG = {m[0] if m else '(행없음)'} (기대 Y)")

    try:
        b40 = [r for r in grid_cols(cur, "40")
               if str(r.get("COLUMN_NAME")) == COL]
        print(f"   [적용 전] 그리드 컬럼 목록(div40)에 {COL} "
              f"{'포함' if b40 else '제외'}")
    except Exception as ex:                                   # noqa: BLE001
        b40 = None
        print(f"   [적용 전] 그리드 컬럼 조회 생략: {str(ex)[:60]}")

    if before[0] == NEW:
        print("== 이미 'Y' — 무변경 종료 ==")
        con.close()
        return 0
    if dry:
        print(f"== --dry: '{before[0]}' → '{NEW}' 예정. 변경 없이 종료 ==")
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
                      SET VISIBLE_FLAG=:v, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                    WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND COLUMN_NAME=:c
                      AND NVL(VISIBLE_FLAG,'~') <> :v""", v=NEW, p=PROG, s=SHEET, c=COL)
    n = cur.rowcount
    con.commit()
    print(f"== COMMIT ({n}행) ==")

    print("== VERIFY ==")
    bad = 0
    after = snap(cur)
    for label, idx, exp in (("VISIBLE_FLAG", 0, NEW), ("SORT_ORDER_NO", 1, before[1]),
                            ("COLUMN_WIDTH", 2, before[2]), ("DIVISION_ID", 3, before[3])):
        ok = after[idx] == exp
        print(f"   {'PASS' if ok else 'FAIL'}  {label:14s} {after[idx]} (기대 {exp})")
        bad += 0 if ok else 1

    for div in ("40", "81"):
        rows = grid_cols(cur, div)
        hit = [r for r in rows if str(r.get("COLUMN_NAME")) == COL]
        ok = bool(hit)
        print(f"   {'PASS' if ok else 'FAIL'}  그리드 컬럼(div {div})에 {COL} "
              f"{'포함' if ok else '제외'} · 전체 {len(rows)}컬럼")
        bad += 0 if ok else 1

    # 회귀 — 같은 시트 다른 컬럼의 VISIBLE_FLAG 는 불변
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND NVL(VISIBLE_FLAG,'-')='N'""",
                p=PROG, s=SHEET)
    print(f"   [정보] 같은 시트 VISIBLE_FLAG='N' 잔여 {cur.fetchone()[0]}컬럼 "
          f"(MEASURE_GROUP 등 — 미변경)")

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
