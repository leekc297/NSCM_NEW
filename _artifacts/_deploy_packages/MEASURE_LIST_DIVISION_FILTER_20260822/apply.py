#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Measure 선택 목록 — division 필터 누락 정정 (사용자 신고 2026-08-22).

## 증상

    "DMF0082 DM ADMIN 권한 — TO-BE 에 너무 많은 메저가 보입니다.
     CUST_FCST 는 AS-IS 에 없는데 TO-BE 에 존재하고, VISIBLE 에서 제외하려 이동해도 되지 않습니다."

## 원인 (실측)

`SCM_MGR.PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_MEASURE_LIST` 는 `P_DIVISION_ID` 를 받지만
**시트명 조합(`SHEET_NAME || '_' || P_DIVISION_ID`)에만 쓰고 `M.DIVISION_ID` 로 거르지 않는다.**
WHERE 절은 `VALID_YN='Y' AND PROGRAM_ID AND SHEET_NAME` 뿐이다.

실측 — div 40 과 div 81 이 **완전히 동일한 22행**을 반환한다:

    div 40 : 22행  ← SCM_FCST(40전용) O, CUST_FCST(81전용) **O**  ← 오류
    div 81 : 22행  ← SCM_FCST(40전용) **O** ← 오류, CUST_FCST(81전용) O

AS-IS DMF0082 `SHEET_MEASURE` 는 **14행 전부 `DIVISION_ID='40'`** 이고,
TO-BE 22행 중 40 을 포함하는 것도 정확히 **14행** — 즉 메타는 옳고 **SP 가 안 거른 것**이다.

    TO-BE 40 포함 14: MKT_FCST_PP·MKT_FCST·RTF_SYS_RP·BALANCE·SCM_FCST·FCST_GAP·
                      VMI_In_Plan·VMI_In_Req·VMI_Inv·MKT_AMT_KRW·MKT_AMT_LOC·KRW·USD·LOC
    81/82 전용 8    : TMM_FCST·RTF_SCP·IN_TRANSIT·CUST_FCST·VMI_DIO·AS_In_Req·AS_In_Plan·AS_Inv

`CUST_FCST` 는 `DEFAULT_FLAG='Y'` 라 40 화면에서도 **표시측(Visible)** 에 실려 나온다.
`USER_SELECTABLE_FLAG='Y'` 이므로 모달의 이동 가드(personalizable) 대상은 아니고,
**애초에 목록에 없어야 할 행**이다 — division 필터가 붙으면 40 에서 사라진다.

같은 계열 선행 정정: `DMF0002_GET_TITLESET_POPUP`(Column Setting 팝업, 2026-08-22).

## 정정

메인 그리드 컬럼 SP 와 **동일 판정식**을 3곳에 넣는다 (목록·그리드가 어긋나지 않으려면 같은 식이어야 한다):

    AND (P_DIVISION_ID IS NULL OR M.DIVISION_ID IS NULL
         OR INSTR(',' || M.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0)

    ① L294 부근  개인화 초기 세팅 INSERT (DEFAULT_FLAG='Y' 시드)  ← 없으면 타 division 메저가 개인화로 굳는다
    ② L332 부근  개인화 조회
    ③ L372 부근  비개인화 조회

`M.DIVISION_ID IS NULL` 은 division 축이 없는 메저를 항상 표시(공통 메저 보호).

⚠ **공용 패키지**다 — 이 프로시저는 measure 팝업을 쓰는 전 화면이 호출한다.
   순수 축소이므로 division 이 맞는 화면은 결과가 불변이고, 안 맞던 행만 사라진다.

멱등: 이미 필터가 있으면 무변경. 실행: python apply.py  (점검만: --dry)
"""
import io
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402
import oracledb  # noqa: E402

PKG = "PKG_NSCM_UI_COM_MENU"
PROC = "PR_GET_SHEET_MEASURE_LIST"
HERE = os.path.dirname(os.path.abspath(__file__))
NL = chr(10)
MARK = "P_DIVISION_ID IS NULL OR M.DIVISION_ID IS NULL"

FILTER_TPL = (
    "{ind}-- ⭐ [2026-08-22] division 필터 — 메인 그리드"
    " `PR_GET_SHEET_COLUMN_LIST` L164 와 동일 판정식." + NL +
    "{ind}--   없으면 타 division 메저가 목록에 섞인다"
    "(DMF0082 div40 에 CUST_FCST(81전용) 노출 실사고)." + NL +
    "{ind}AND (P_DIVISION_ID IS NULL OR M.DIVISION_ID IS NULL" + NL +
    "{ind}     OR INSTR(',' || M.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0)"
)

# (앵커 정규식, 설명) — 프로시저 구간 안에서만 치환
# ⚠ 앵커는 `AND M.SHEET_NAME = V_SHEET_NAME` **하나만** 쓴다 — 이 줄이 세 statement
#   (개인화 초기 세팅 INSERT / 개인화 조회 / 비개인화 조회) 모두에 있고 **WHERE 절 중간**이다.
#   `AND M.DEFAULT_FLAG = 'Y';` 를 앵커로 쓰면 **문장 종결자 `;` 뒤**에 술어가 붙어 컴파일이 깨진다
#   — --dry PREVIEW 검증에서 실제로 적출했다(DB 적용 전 차단).
ANCHORS = [
    (r"(?m)^([ \t]*)AND\s+M\.SHEET_NAME\s*=\s*V_SHEET_NAME\s*$", "WHERE 절 3곳"),
]


def body_of(cur):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY'
                    ORDER BY LINE""", n=PKG)
    return "".join(r[0] for r in cur.fetchall())


def proc_span(body):
    starts = [(m.start(), m.group(1))
              for m in re.finditer(r"(?im)^\s*PROCEDURE\s+([A-Z0-9_]+)", body)]
    for i, (pos, nm) in enumerate(starts):
        if nm.upper() == PROC:
            return pos, (starts[i + 1][0] if i + 1 < len(starts) else len(body))
    sys.exit(f"[ABORT] {PROC} 미발견 — 중단.")


def probe(cur, div):
    rc = cur.var(oracledb.CURSOR)
    cur.callproc(f"SCM_MGR.{PKG}.{PROC}", ["minyonglee1", "DMF0082", "FcstNPrice", div, rc])
    c = rc.getvalue()
    cols = [d[0] for d in c.description]
    rows = [dict(zip(cols, r)) for r in c.fetchall()]
    names = {str(r.get("COLUMN_NAME")) for r in rows}
    vis = [r for r in rows if str(r.get("DISPLAY_FLAG")) == "Y"]
    print(f"     div {div:3s} → {len(rows):3d}행 (표시 {len(vis)}) · "
          f"CUST_FCST={'O' if 'CUST_FCST' in names else 'X'} · "
          f"SCM_FCST={'O' if 'SCM_FCST' in names else 'X'}")
    return len(rows), ("CUST_FCST" in names), ("SCM_FCST" in names)


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = body_of(cur)
    s, e = proc_span(before)
    seg = before[s:e]
    if MARK in seg:
        print("== 이미 정정됨 — 무변경 종료 ==")
        con.close()
        return 0

    bak = os.path.join(HERE, f"BACKUP_{PKG}_BODY.sql")
    if not os.path.exists(bak):
        io.open(bak, "w", encoding="utf-8", newline="").write(before)
        print(f"== BACKUP 저장: {bak} ==")

    print("== 적용 전 실측 (DMF0082 / FcstNPrice) ==")
    b40 = probe(cur, "40")
    b81 = probe(cur, "81")

    fixed, total = seg, 0
    for pat, desc in ANCHORS:
        hits = list(re.finditer(pat, fixed))
        if not hits:
            sys.exit(f"[ABORT] 앵커 미발견 ({desc}) — 본문 구조 변동. 중단.")
        # 뒤에서부터 치환해 offset 보존
        for m in reversed(hits):
            ind = m.group(1)
            fixed = fixed[:m.end()] + NL + FILTER_TPL.format(ind=ind) + fixed[m.end():]
            total += 1
        print(f"   {desc}: {len(hits)}곳 삽입")
    print(f"== 총 {total}곳 ==")

    after = before[:s] + fixed + before[e:]
    if after[:s] != before[:s] or after[len(after) - (len(before) - e):] != before[e:]:
        sys.exit("[ABORT] 대상 프로시저 밖이 변경됨 — 중단.")

    if dry:
        io.open(os.path.join(HERE, f"PREVIEW_{PKG}_BODY.sql"), "w",
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
    cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                    AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""", n=PKG)
    st = (cur.fetchone() or ["(없음)"])[0]
    print(f"   {'PASS' if st == 'VALID' else 'FAIL'}  {PKG} BODY STATUS = {st}")
    bad += 0 if st == "VALID" else 1

    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", n=PKG)
    ne = cur.fetchone()[0]
    print(f"   {'PASS' if ne == 0 else 'FAIL'}  ALL_ERRORS {ne}건")
    bad += 0 if ne == 0 else 1

    cur.execute("""SELECT COUNT(*) FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR'
                    AND O.STATUS='INVALID'
                    AND O.OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES
                                           WHERE OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""", n=PKG)
    print(f"   {'PASS' if cur.fetchone()[0] == 0 else 'WARN'}  의존 객체 INVALID 0 확인")

    print(f"{NL}   -- 적용 후 실측 --")
    a40 = probe(cur, "40")
    a81 = probe(cur, "81")

    for label, b, a, want_cust, want_scm, exp_n in (
            ("div 40", b40, a40, False, True, 14),
            ("div 81", b81, a81, True, False, None)):
        ok = a[1] is want_cust and a[2] is want_scm
        print(f"   {'PASS' if ok else 'FAIL'}  {label} CUST_FCST={a[1]}(기대 {want_cust}) · "
              f"SCM_FCST={a[2]}(기대 {want_scm})")
        bad += 0 if ok else 1
        if exp_n is not None:
            ok = a[0] == exp_n
            print(f"   {'PASS' if ok else 'FAIL'}  {label} 행수 {b[0]} → {a[0]} "
                  f"(기대 {exp_n} = AS-IS DMF0082 SHEET_MEASURE 14행)")
            bad += 0 if ok else 1

    # 회귀 — division NULL 호출은 종전대로 전량
    rc = cur.var(oracledb.CURSOR)
    cur.callproc(f"SCM_MGR.{PKG}.{PROC}", ["minyonglee1", "DMF0082", "FcstNPrice", None, rc])
    n_null = len(rc.getvalue().fetchall())
    ok = n_null >= max(b40[0], b81[0])
    print(f"   {'PASS' if ok else 'FAIL'}  division NULL 호출 전량 {n_null}행")
    bad += 0 if ok else 1

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
