#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""COM0008 Item 팝업 조회 — 빈 문자 파라미터가 결과를 전멸시키는 결함 정정.

## 증상 (사용자 신고 2026-08-22)
    DMF0082 그리드에서 Model 모달을 띄우면 **아무것도 조회되지 않는다** (Project 모달은 정상).

## 원인 (실측)
`PKG_COM0000.P_COM0008_GET_ITEM_BY_DIVISION_POPUP` 의 술어가 파라미터별로 갈려 있다.

    PROJECT_CODE / ITEM_ID : NVL(TRIM(P_x), 'ALL') = 'ALL' OR ...      ← 빈값 = 필터 없음(정상)
    DEPT_ID / END_CUSTOMER / SCM_SITE_ID : P_x = 'ALL' OR ...          ← 빈값 = 전멸(결함)

엄격비교라 `''` 는 'ALL' 과 같지 않고, 뒤쪽 `IN (SELECT VALUE FROM SPLIT_x)` 로 넘어가는데
`SPLIT_x = FN_SPLITSTRING(NVL(P_x,'ALL'), ',')` 이므로 Oracle 에서 `''` = NULL → `NVL` 이 'ALL' 을
돌려주고 결국 `TEAM.DEPT_ID IN ('ALL')` 이 되어 **어떤 행도 만나지 못한다**.

실측 (division 40):
    전부 'ALL'          -> 14,458행
    deptId = ''         ->      0행
    endCustomer = ''    ->      0행
    salesSite = ''      ->      0행

AS-IS 는 이 팝업에 빈 문자를 넘긴다(`DMF0082_FcstNPrice_Mgmt.cs:3777` 초기값 `""`) — 즉 빈값은
"조건 없음" 이 AS-IS 계약이다. 변환 과정에서 세 파라미터만 엄격비교로 굳은 것.

## 정정
같은 프로시저가 이미 쓰고 있는 형태로 통일한다:

    P_DEPT_ID='ALL' OR   ->   NVL(TRIM(P_DEPT_ID),'ALL')='ALL' OR

**순수 확대**다 — 'ALL' 이나 실제 값이 오는 기존 경로의 결과는 바뀌지 않고, 지금 0행을 주던
빈값 경로만 "조건 없음" 으로 돌아온다.

## 범위
`P_COM0008_GET_ITEM_BY_DIVISION_POPUP` **한 프로시저의 9곳만**. 같은 패키지의
`P_COM0006_GET_OWNER_DATA` 에도 동일 패턴 3곳이 있으나 **승인 범위 밖이라 손대지 않는다**
(적용 후 잔존 건수로 리포트한다).

멱등: 이미 정정돼 있으면 무변경 종료. 실행: python apply.py  (점검만: --dry)
"""
import io
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402
import oracledb  # noqa: E402

PKG = "PKG_COM0000"
PROC = "P_COM0008_GET_ITEM_BY_DIVISION_POPUP"
PARAMS = ("DEPT_ID", "END_CUSTOMER", "SCM_SITE_ID")
HERE = os.path.dirname(os.path.abspath(__file__))
NL = chr(10)


def fetch_body(cur):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY'
                    ORDER BY LINE""", n=PKG)
    return "".join(r[0] for r in cur.fetchall())


def proc_span(body):
    """대상 프로시저의 [start, end) — 다음 PROCEDURE 선언 직전까지."""
    starts = [(m.start(), m.group(1))
              for m in re.finditer(r"(?im)^\s*PROCEDURE\s+([A-Z0-9_]+)", body)]
    for i, (pos, nm) in enumerate(starts):
        if nm.upper() == PROC:
            return pos, (starts[i + 1][0] if i + 1 < len(starts) else len(body))
    sys.exit(f"[ABORT] 프로시저 {PROC} 를 본문에서 찾지 못함 — 중단.")


def probe(cur, label, div="40", dept="ALL", ec="ALL", site="ALL", prj="", item="", sw="Y"):
    rc, rr = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
    cur.callproc(f"SCM_MGR.{PKG}.{PROC}", [div, dept, ec, site, prj, item, sw, rc, rr])
    n = len(rc.getvalue().fetchall())
    print(f"     {label:34s} -> {n:7,d}행")
    return n


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = fetch_body(cur)
    s, e = proc_span(before)
    seg = before[s:e]
    hits = {p: len(re.findall(rf"P_{p}\s*=\s*'ALL'\s+OR", seg)) for p in PARAMS}
    total = sum(hits.values())
    print(f"== 대상 프로시저 구간 {len(seg):,} chars · 엄격비교 {total}곳 ==")
    for p, n in hits.items():
        print(f"     P_{p:14s} {n}곳")

    # 원본 보존 (패키지 본문은 테이블 백업이 불가 — 파일이 백업본이다)
    bak = os.path.join(HERE, f"BACKUP_{PKG}_BODY.sql")
    if not os.path.exists(bak):
        io.open(bak, "w", encoding="utf-8", newline="").write(before)
        print(f"== BACKUP 저장: {bak} ==")
    else:
        print(f"== BACKUP 기존 유지: {bak} ==")

    if total == 0:
        print("== 이미 정정됨 — 무변경 종료 ==")
        con.close()
        return 0

    print(f"{NL}== 적용 전 실측 ==")
    n_all = probe(cur, "전부 'ALL'")
    n_empty = {p: probe(cur, f"{p}=''", **{{"DEPT_ID": "dept", "END_CUSTOMER": "ec",
                                            "SCM_SITE_ID": "site"}[p]: ""}) for p in PARAMS}
    if n_all == 0:
        sys.exit("[ABORT] 기준선('ALL')이 0행 — 데이터/권한 이상. 중단.")

    fixed = seg
    for p in PARAMS:
        fixed = re.sub(rf"P_{p}\s*=\s*'ALL'\s+OR", f"NVL(TRIM(P_{p}),'ALL')='ALL' OR", fixed)
    after = before[:s] + fixed + before[e:]

    # 회귀 가드 — 대상 구간 밖은 한 글자도 변하지 않아야 한다
    if after[:s] != before[:s] or after[len(after) - (len(before) - e):] != before[e:]:
        sys.exit("[ABORT] 대상 구간 밖이 변경됨 — 중단.")
    left = len(re.findall(r"P_(?:DEPT_ID|END_CUSTOMER|SCM_SITE_ID)\s*=\s*'ALL'\s+OR",
                          after[s:s + len(fixed)]))
    if left:
        sys.exit(f"[ABORT] 대상 구간에 엄격비교 {left}곳 잔존 — 중단.")
    print(f"{NL}== 치환 {total}곳 완료 (구간 밖 무변경 확인) ==")

    if dry:
        io.open(os.path.join(HERE, f"PREVIEW_{PKG}_BODY.sql"), "w",
                encoding="utf-8", newline="").write(after)
        print("== --dry: DB 미적용, PREVIEW 파일만 생성 ==")
        con.close()
        return 0

    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
    cur.execute("CREATE OR REPLACE " + after)
    con.commit()
    print("== 재컴파일 완료 ==")

    # VERIFY — hook #136: 대상 객체를 직접 실측한다
    print(f"{NL}== VERIFY ==")
    bad = 0
    cur.execute("""SELECT STATUS FROM ALL_OBJECTS
                    WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""",
                n=PKG)
    st = (cur.fetchone() or ["(없음)"])[0]
    print(f"   {'PASS' if st == 'VALID' else 'FAIL'}  {PKG} BODY STATUS = {st}")
    bad += 0 if st == "VALID" else 1

    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY SEQUENCE""", n=PKG)
    errs = cur.fetchall()
    print(f"   {'PASS' if not errs else 'FAIL'}  ALL_ERRORS {len(errs)}건")
    for r in errs[:5]:
        print("        ", r)
    bad += 0 if not errs else 1

    # 의존 객체 연쇄 INVALID 확인 (hook #136)
    cur.execute("""SELECT COUNT(*) FROM ALL_OBJECTS O
                    WHERE O.OWNER='SCM_MGR' AND O.STATUS='INVALID'
                      AND O.OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES
                                             WHERE OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""",
                n=PKG)
    dep = cur.fetchone()[0]
    print(f"   {'PASS' if dep == 0 else 'WARN'}  의존 객체 INVALID {dep}건")

    print(f"{NL}   -- 적용 후 실측 --")
    a_all = probe(cur, "전부 'ALL'")
    ok = a_all == n_all
    print(f"   {'PASS' if ok else 'FAIL'}  기존 경로 불변  전 {n_all:,} / 후 {a_all:,}")
    bad += 0 if ok else 1
    for p in PARAMS:
        k = {"DEPT_ID": "dept", "END_CUSTOMER": "ec", "SCM_SITE_ID": "site"}[p]
        a = probe(cur, f"{p}=''", **{k: ""})
        ok = a == n_all
        print(f"   {'PASS' if ok else 'FAIL'}  {p}='' 복구  전 {n_empty[p]:,} / 후 {a:,} "
              f"(기대 {n_all:,})")
        bad += 0 if ok else 1

    # 승인 범위 밖 잔존 리포트
    cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY'
                      AND REGEXP_LIKE(TEXT, 'P_(DEPT_ID|END_CUSTOMER|SCM_SITE_ID)\s*=\s*''ALL''')""",
                n=PKG)
    print(f"{NL}   [참고] 패키지 전체 엄격비교 잔존 {cur.fetchone()[0]}곳 "
          f"(= P_COM0006_GET_OWNER_DATA 3곳 — 승인 범위 밖, 미변경)")

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
