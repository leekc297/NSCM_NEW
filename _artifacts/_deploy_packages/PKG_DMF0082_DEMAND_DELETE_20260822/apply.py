#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PKG_DMF0082 수요 measure DELETE 누락 정정 — MERGE/DELETE measure 집합 대칭화 (사용자 승인 A안, 2026-08-22).

## 장애 (사용자 신고)

    "AS-IS 는 DELETE 후 삭제하면 저장 후 재조회 시 삭제 확인됩니다.
     TO-BE 는 DELETE 후 삭제하고 저장 후 재조회 시 다시 조회 됩니다."

## 원인 — 같은 프로시저 안의 비대칭

`P_DMF0082_SAVE_MAIN_DATA` 의 40 분기는 "수량 0 = 삭제" 설계다. 그런데 그 규칙이 **절반만** 구현됐다.

    L13760  MERGE 소스  WHERE M.MEASURE IN ('MKT_FCST','VMI_In_Req','MKT_AMT_KRW','MKT_AMT_LOC','SCM_FCST')
    L13761              AND M.QTY_PRICE <> 0            ← 수량 0 은 원천 제외 (UPDATE/INSERT 대상 아님)

    L13695  DELETE      WHERE A.MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC')   ← MKT_AMT 2종만
    L13705              FROM GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC')
    L13708              AND B.QTY_PRICE = 0

⇒ 수요 3종(`MKT_FCST`·`VMI_In_Req`·`SCM_FCST`)은 **MERGE 가 0 을 버리고 DELETE 도 안 지운다.**
   원장 행이 그대로 남아 재조회 시 되살아난다. `MKT_AMT` 만 정상 동작해 왔다.

## 정정 — measure 목록 2곳에 수요 3종 추가

DELETE 블록(L13693~13714)의 measure 목록을 MERGE 소스(L13760)와 **같은 5종**으로 맞춘다.
새 구문·새 블록을 만들지 않는다 — **이미 있는 블록의 대상 집합만 넓힌다.**

    qty <> 0  → MERGE  (UPDATE matched / INSERT unmatched)   ← 기존 그대로
    qty  = 0  → DELETE                                        ← 수요 3종 추가

## 안전성 (FE 실측 — nscm-fe/.../forecast-price/utils/forecast-price.save.ts buildSaveRows)

    crud='I' : qty !== 0 인 셀만 전송      (0 은 애초에 전송하지 않음)
    crud='D' : 전 편집일자 qty='0' 전송
    crud='M' : EditTracker 로 **변경된 셀만** 전송 (손대지 않은 셀은 미전송)

⇒ `QTY_PRICE = 0` 이 SP 에 도달하는 경로는 ①행 삭제 ②사용자가 값을 0 으로 지움 — **둘 다 원장에서
   빠지는 것이 맞다.** 손대지 않은 셀이 휩쓸릴 경로는 없다(미전송이라 GTT 에 존재하지 않음).

⚠ `SCM_FCST` 는 UI 가 INSERT 를 막는 시스템 예측치다. 본 정정 후 0 으로 지우면 삭제된다
   (지금은 조용히 무시). AS-IS 동작 미확인 — 사용자 보고 대상으로 남긴다.

⚠ 범위는 **40 분기 전용**이다. DELETE 블록 자체가 `IF v_is_81 = 'N'` 게이트(L13693) 안에 있다.
   81 분기(`DM_PLN_MKT_FCST`)에는 DELETE 문이 아예 없다 — 별건 결함으로 보고만 한다.

## 안전 절차 (1차 INVALID 사고 재발 방지 — apply2.py 절차 승계)

    BACKUP → 치환 → **사본 패키지(스펙+본문) 컴파일 시험** → 원본 적용 → VERIFY → INVALID 시 자동 원복

멱등: 이미 5종이면 무변경. 실행: python apply.py   (점검만: --dry)
"""
import io
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

PKG = "PKG_DMF0082"
PROBE = "PKG_DMF0082_PROBE"
HERE = os.path.dirname(os.path.abspath(__file__))
NL = chr(10)
Q = chr(39)

OLD_SET = "('MKT_AMT_KRW', 'MKT_AMT_LOC')"
NEW_SET = "('MKT_AMT_KRW', 'MKT_AMT_LOC', 'MKT_FCST', 'VMI_In_Req', 'SCM_FCST')"

# 치환 앵커 — 각 1회 출현을 ASSERT 로 고정한다(유일성 실측 완료)
ANCHORS = [
    ("WHERE A.MEASURE IN " + OLD_SET,
     "WHERE A.MEASURE IN " + NEW_SET),
    ("FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN " + OLD_SET,
     "FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN " + NEW_SET),
]
# 주석도 실제와 맞춘다 — 주석은 근거가 아니지만(hook #138) 거짓 주석을 남기지 않는다
COMMENT = ("-- Phase 1: DELETE MKT_AMT rows where new QTY = 0",
           "-- Phase 1: DELETE rows where new QTY = 0 (MKT_AMT + 수요 3종 = MERGE 소스와 동일 집합)")

# MERGE 소스 집합 — 정정 후 DELETE 집합과 일치해야 한다(대칭성 게이트)
MERGE_SRC = ("WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'MKT_AMT_KRW', "
             "'MKT_AMT_LOC', 'SCM_FCST')")


def measures(s):
    """따옴표 리터럴을 토큰 집합으로 — 순서 차이로 인한 오탐 방지."""
    return sorted(re.findall(Q + r"([A-Za-z_]+)" + Q, s))


def body_of(cur, name=PKG):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE BODY' ORDER BY LINE""", n=name)
    return "".join(r[0] for r in cur.fetchall())


def transform(body):
    out, n = body, 0
    for old, new in ANCHORS:
        c = out.count(old)
        if c != 1:
            sys.exit(f"[ABORT] 앵커 출현 {c}회 (기대 1) — 중단: {old[:60]}")
        out = out.replace(old, new, 1)
        n += 1
    if out.count(COMMENT[0]) == 1:
        out = out.replace(COMMENT[0], COMMENT[1], 1)
    return out, n


def compile_probe(cur, con, text):
    """이름만 바꾼 사본(스펙+본문)으로 컴파일 시험 — (VALID여부, 메시지)."""
    probe_ddl = re.sub(r'(PACKAGE\s+BODY\s+")' + PKG + r'(")', r"\1" + PROBE + r"\2",
                       text, count=1, flags=re.I)
    if PROBE not in probe_ddl:
        probe_ddl = re.sub(r"(PACKAGE\s+BODY\s+)" + PKG, r"\1" + PROBE,
                           text, count=1, flags=re.I)
    if PROBE not in probe_ddl:
        return None, "이름 치환 실패"
    # 말미 `END PKG_DMF0082;` 도 바꾼다 — 안 바꾸면 PLS-00113 이 나서 진짜 구문오류와 구분 안 된다
    probe_ddl = re.sub(r"(\bEND\s+)" + PKG + r"(\s*;)", r"\1" + PROBE + r"\2",
                       probe_ddl, flags=re.I)
    # 패키지 본문은 스펙이 있어야 컴파일된다(PLS-00201) — 사본 스펙도 함께 만든다
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE' ORDER BY LINE""", n=PKG)
    spec = "".join(r[0] for r in cur.fetchall())
    if not spec:
        return None, "원본 스펙을 읽지 못함"
    spec_ddl = re.sub(r'(PACKAGE\s+")' + PKG + r'(")', r"\1" + PROBE + r"\2",
                      spec, count=1, flags=re.I)
    if PROBE not in spec_ddl:
        spec_ddl = re.sub(r"(PACKAGE\s+)" + PKG, r"\1" + PROBE, spec, count=1, flags=re.I)
    spec_ddl = re.sub(r"(\bEND\s+)" + PKG + r"(\s*;)", r"\1" + PROBE + r"\2", spec_ddl, flags=re.I)
    try:
        cur.execute("CREATE OR REPLACE " + spec_ddl)
        con.commit()
    except Exception as ex:                                    # noqa: BLE001
        return None, "사본 스펙 생성 실패: " + str(ex).splitlines()[0][:90]
    try:
        cur.execute("CREATE OR REPLACE " + probe_ddl)
        con.commit()
    except Exception as ex:                                    # noqa: BLE001
        return False, str(ex).splitlines()[0][:120]
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", n=PROBE)
    ne = cur.fetchone()[0]
    msg = ""
    if ne:
        cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n
                        ORDER BY SEQUENCE FETCH FIRST 3 ROWS ONLY""", n=PROBE)
        msg = " | ".join("L{0}: {1}".format(a, b.strip()[:60]) for a, b in cur.fetchall())
    for ddl in ("DROP PACKAGE BODY SCM_MGR." + PROBE, "DROP PACKAGE SCM_MGR." + PROBE):
        try:
            cur.execute(ddl)
            con.commit()
        except Exception:                                      # noqa: BLE001
            pass
    return (ne == 0), msg


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = body_of(cur)
    print(f"== 본문 {len(before):,} chars ==")
    if before.count("WHERE A.MEASURE IN " + NEW_SET):
        print("== 이미 정정됨 — 무변경 종료 ==")
        con.close()
        return 0

    bak = os.path.join(HERE, "BACKUP_" + PKG + "_BODY.sql")
    if not os.path.exists(bak):
        io.open(bak, "w", encoding="utf-8", newline="").write(before)
        print(f"== BACKUP: {bak} ==")

    after, n = transform(before)
    print(f"== 치환 {n}곳 (measure 목록) ==")

    # 회귀 가드 — 치환 외 구조 변경이 없어야 한다
    if after.count(NEW_SET) != 2:
        sys.exit(f"[ABORT] 신규 집합 {after.count(NEW_SET)}곳 (기대 2) — 중단.")
    for stmt in ("DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN", "MERGE INTO"):
        if after.count(stmt) != before.count(stmt):
            sys.exit(f"[ABORT] '{stmt}' 개수 변동 — 중단.")
    if MERGE_SRC not in after:
        sys.exit("[ABORT] MERGE 소스 집합을 찾지 못함 — 대칭성 확인 불가. 중단.")
    if measures(NEW_SET) != measures(MERGE_SRC):
        sys.exit(f"[ABORT] 대칭성 실패 DELETE{measures(NEW_SET)} != MERGE{measures(MERGE_SRC)}")
    print(f"   대칭성 PASS — DELETE 집합 == MERGE 집합 {measures(NEW_SET)}")

    if dry:
        io.open(os.path.join(HERE, "PREVIEW_" + PKG + "_BODY.sql"), "w",
                encoding="utf-8", newline="").write(after)
        i = after.find("WHERE A.MEASURE IN " + NEW_SET)
        print(NL + "== PREVIEW (치환 지점) ==" + NL + after[i - 300:i + 320])

    print(NL + f"== 사본 컴파일 시험 ({PROBE}) ==")
    ok, msg = compile_probe(cur, con, after)
    if ok is None:
        print(f"   [ABORT] 시험 자체 실패: {msg}")
        con.close()
        return 1
    if not ok:
        print(f"   FAIL — 원본 미적용 유지. {msg}")
        con.close()
        return 1
    print("   PASS — 사본 VALID / ERRORS 0")

    if dry:
        print(NL + "== --dry: DB 미적용 종료 ==")
        con.close()
        return 0

    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
    cur.execute("CREATE OR REPLACE " + after)
    con.commit()
    print(NL + "== 원본 재컴파일 완료 ==")

    print(NL + "== VERIFY ==")
    bad = 0
    cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                    AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""", n=PKG)
    st = (cur.fetchone() or ["(없음)"])[0]
    print(f"   {'PASS' if st == 'VALID' else 'FAIL'}  {PKG} BODY STATUS = {st}")
    bad += 0 if st == "VALID" else 1

    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
                    AND NAME=:n ORDER BY SEQUENCE""", n=PKG)
    errs = cur.fetchall()
    print(f"   {'PASS' if not errs else 'FAIL'}  ALL_ERRORS {len(errs)}건")
    for e in errs[:5]:
        print("        ", e)
    bad += 0 if not errs else 1

    if bad:
        print(NL + "   ⛔ INVALID — 백업으로 자동 원복한다.")
        cur.execute("CREATE OR REPLACE " + before)
        con.commit()
        cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                        AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""", n=PKG)
        print(f"   원복 후 STATUS = {(cur.fetchone() or ['?'])[0]}")
        con.close()
        return 1

    cur.execute("""SELECT COUNT(*) FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR'
                    AND O.STATUS='INVALID'
                    AND O.OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES
                                           WHERE OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""", n=PKG)
    dep = cur.fetchone()[0]
    print(f"   {'PASS' if dep == 0 else 'WARN'}  의존 객체 INVALID {dep}건")

    fin = body_of(cur)
    ok2 = fin.count(NEW_SET) == 2
    print(f"   {'PASS' if ok2 else 'FAIL'}  적용 후 신규 집합 {fin.count(NEW_SET)}곳 (기대 2)")
    bad += 0 if ok2 else 1

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
