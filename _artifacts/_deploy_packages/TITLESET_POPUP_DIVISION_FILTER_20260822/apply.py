#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Column Setting 팝업 — division 필터 누락 정정 (사용자 신고 2026-08-22).

## 증상

    "DMF0082 의 Project 에 40 Division 이 없는데, 40 Division 에서 Column Setting Modal 을 띄우면
     Project 가 보입니다."

## 원인 (실측)

`SCM_MGR.DMF0002_GET_TITLESET_POPUP` 은 `P_DIVISION_ID` 를 **파라미터로 받기만 하고 WHERE 절에서
전혀 쓰지 않는다**(전문 70줄 중 DIVISION 언급이 6행 선언 1곳뿐). 그래서 `VALID_YN='Y'` 인 시트 컬럼이
division 과 무관하게 전량 내려온다.

    DMF0082 FcstNPrice PROJECT_CODE.DIVISION_ID = '82,81,81_UC,81_HM,81_ST,81_HD,81_HG'  ← 40 없음
    그런데 division 40 으로 팝업을 열어도 목록에 나온다.

메인 그리드는 같은 축을 이미 거른다 — `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` L164/L214.
즉 **그리드에는 안 나오는 컬럼이 Column Setting 목록에만 나오는** 불일치였다.

## 정정

메인 그리드 SP 의 관용구를 **그대로** 옮긴다(같은 판정식이어야 목록과 그리드가 어긋나지 않는다):

    AND (P_DIVISION_ID IS NULL OR C.DIVISION_ID IS NULL
         OR INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0)

· `P_DIVISION_ID IS NULL` — division 미지정 호출은 종전대로 전량(회귀 방지)
· `C.DIVISION_ID IS NULL` — division 축이 없는 컬럼은 항상 표시(공통 컬럼)
· Oracle 에서 `''` = NULL 이므로 FE 가 빈 문자를 넘겨도 전량 반환 — 조용한 0행 사고 없음

멱등: 이미 필터가 있으면 무변경. 실행: python apply.py  (점검만: --dry)
"""
import io
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402
import oracledb  # noqa: E402

SP = "DMF0002_GET_TITLESET_POPUP"
HERE = os.path.dirname(os.path.abspath(__file__))
NL = chr(10)

ANCHOR = "              AND C.VALID_YN = 'Y'"
FILTER = (
    "              -- ⭐ [2026-08-22] division 필터 — 메인 그리드"
    " `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` L164 와 동일 판정식." + NL +
    "              --   없으면 그리드엔 안 나오는 컬럼이 Column Setting 목록에만 뜬다"
    "(DMF0082 PROJECT_CODE / div 40 실사고)." + NL +
    "              AND (P_DIVISION_ID IS NULL OR C.DIVISION_ID IS NULL" + NL +
    "                   OR INSTR(',' || C.DIVISION_ID || ',',"
    " ',' || P_DIVISION_ID || ',') > 0)"
)


def body_of(cur):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE""", n=SP)
    return "".join(r[0] for r in cur.fetchall())


def probe(cur, label, prog, sheet, div):
    """팝업이 내려주는 컬럼 수 — division 별."""
    rc = cur.var(oracledb.CURSOR)
    cur.callproc(f"SCM_MGR.{SP}", [prog, sheet, "SEARCH", "minyonglee1", div, prog, rc])
    rows = rc.getvalue().fetchall()
    names = {r[2] for r in rows}
    print(f"     {label:34s} -> {len(rows):4d}컬럼  PROJECT_CODE 포함={('PROJECT_CODE' in names)}")
    return len(rows), ("PROJECT_CODE" in names)


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = body_of(cur)
    has = "P_DIVISION_ID IS NULL OR C.DIVISION_ID IS NULL" in before
    print(f"== 현재 상태: division 필터 {'있음' if has else '**없음**'} ==")

    bak = os.path.join(HERE, f"BACKUP_{SP}.sql")
    if not os.path.exists(bak):
        io.open(bak, "w", encoding="utf-8", newline="").write(before)
        print(f"== BACKUP 저장: {bak} ==")

    if has:
        print("== 이미 정정됨 — 무변경 종료 ==")
        con.close()
        return 0
    if before.count(ANCHOR) != 1:
        sys.exit(f"[ABORT] 기준 라인(VALID_YN)을 {before.count(ANCHOR)}곳 발견 — 본문 구조 변동. 중단.")

    print(f"{NL}== 적용 전 실측 (DMF0082 FcstNPrice) ==")
    n40_b, p40_b = probe(cur, "division 40", "DMF0082", "FcstNPrice", "40")
    n81_b, p81_b = probe(cur, "division 81", "DMF0082", "FcstNPrice", "81")

    after = before.replace(ANCHOR, ANCHOR + NL + FILTER, 1)
    if dry:
        io.open(os.path.join(HERE, f"PREVIEW_{SP}.sql"), "w",
                encoding="utf-8", newline="").write(after)
        print("== --dry: DB 미적용, PREVIEW 생성 ==")
        con.close()
        return 0

    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
    cur.execute("CREATE OR REPLACE " + after)
    con.commit()
    print("== 재컴파일 완료 ==")

    print(f"{NL}== VERIFY ==")
    bad = 0
    cur.execute("""SELECT STATUS FROM ALL_OBJECTS
                    WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'""", n=SP)
    st = (cur.fetchone() or ["(없음)"])[0]
    print(f"   {'PASS' if st == 'VALID' else 'FAIL'}  {SP} STATUS = {st}")
    bad += 0 if st == "VALID" else 1

    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", n=SP)
    ne = cur.fetchone()[0]
    print(f"   {'PASS' if ne == 0 else 'FAIL'}  ALL_ERRORS {ne}건")
    bad += 0 if ne == 0 else 1

    print(f"{NL}   -- 적용 후 실측 --")
    n40_a, p40_a = probe(cur, "division 40", "DMF0082", "FcstNPrice", "40")
    n81_a, p81_a = probe(cur, "division 81", "DMF0082", "FcstNPrice", "81")

    ok = p40_b is True and p40_a is False
    print(f"   {'PASS' if ok else 'FAIL'}  div40 PROJECT_CODE 제외  전 {p40_b} → 후 {p40_a}")
    bad += 0 if ok else 1
    ok = p81_a is True
    print(f"   {'PASS' if ok else 'FAIL'}  div81 PROJECT_CODE 유지  {p81_a} (81 은 DIVISION_ID 에 포함)")
    bad += 0 if ok else 1
    ok = n81_a == n81_b
    print(f"   {'PASS' if ok else 'WARN'}  div81 컬럼수 불변  전 {n81_b} / 후 {n81_a}")
    print(f"   [정보] div40 컬럼수  전 {n40_b} / 후 {n40_a} (감소 {n40_b - n40_a})")

    # division 미지정 호출은 종전대로 전량이어야 한다 (회귀 방지)
    rc = cur.var(oracledb.CURSOR)
    cur.callproc(f"SCM_MGR.{SP}", ["DMF0082", "FcstNPrice", "SEARCH", "minyonglee1", None,
                                   "DMF0082", rc])
    n_null = len(rc.getvalue().fetchall())
    ok = n_null >= max(n40_b, n81_b)
    print(f"   {'PASS' if ok else 'FAIL'}  division NULL 호출 전량 반환 {n_null}컬럼")
    bad += 0 if ok else 1

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
