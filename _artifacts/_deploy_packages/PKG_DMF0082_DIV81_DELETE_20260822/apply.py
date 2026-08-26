#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PKG_DMF0082 DIV81 수요 행 삭제 신설 — ACTION='D' 기준 (사용자 지시 2026-08-22).

## 요구 (사용자)

    "AS-IS 는 81 DIVISION 에 대한 편집 권한이 없어 삭제가 필요 없었지만,
     TO-BE 에서는 81 DIVISION 에 대한 편집 권한을 가지고 있으며, 실제 삭제가 되어야 합니다."

## 실측 (정정 전)

`_dmf0082_delete_proof_20260822.py` — 원장 실키로 I(7) 후 D:

    DIV 40  [I] QTY=7 rows=1 → [D] QTY=0 rows=0   PASS
    DIV 81  [I] QTY=7 rows=1 → [D] QTY=0 rows=1   FAIL   ← QTY 만 0 이 되고 행이 남는다

`DM_PLN_MKT_FCST` 대상 DML 전수: MERGE(L13790) · INSERT(L14077 이력) — **DELETE 가 아예 없다.**

## 왜 40 과 같은 'QTY=0 → 삭제' 를 쓰지 않는가

81 MERGE 소스에는 `QTY_PRICE <> 0` 필터가 **없고**, 바로 위 주석이 설계 의도를 명시한다:

    L13789  -- DMF0003 과 동일하게 QTY=0 행도 물리 저장.

즉 81 은 **QTY=0 행을 일부러 남기는** 설계다. 여기에 'QTY=0 → 삭제' 를 걸면 사용자가 값을 0 으로
고친 것까지 사라져 DMF0003 정본과 어긋난다.

⇒ 81 은 **FE 의 행 삭제 플래그**를 기준으로 한다. `GT_PRDM1_T_MAIN.ACTION` 이 곧 `p_active_flag` 다:

    L11592  VALUES ( v_active_flag, ... )      ← ACTION 컬럼 = FE activeFlag
    L12769  -- Delete 가능 - UI에서 MKT_FCST를 D로 보내는 경우가 있어서 작성함.

`ACTION` 을 덮어쓰는 곳은 L12739~12748 하나뿐이고 `WHERE A.MEASURE = 'LOC'` 로 한정돼 있어
수요 measure 의 `ACTION` 은 FE 값 그대로 남는다.

## 정정 (81 분기 전용 — 2곳)

① MERGE(L13790) **앞에** DELETE 신설 — `ACTION='D'` 인 키를 원장에서 제거
② MERGE 소스(L13798)에서 `ACTION='D'` 행 제외 — 안 하면 지운 행을 MERGE 가 QTY=0 으로 되살린다

    삭제 순서가 중요하다: DELETE → MERGE. MERGE 가 D 행을 다시 넣지 않도록 ②가 반드시 함께 가야 한다.

키는 MERGE ON 절과 **동일한 10종**(`DM_PLN_MKT_FCST` 실측 컬럼 — END_CUSTOMER·CELL_PROD_SITE_ID 없음).
비교 연산자도 MERGE ON 과 같은 평비교(`=`)로 맞춘다 — MERGE 가 실제로 매칭되는 것이 실측으로
확인됐으므로(QTY 갱신 성공) 같은 조건이면 DELETE 도 매칭된다.

⚠ 40 분기는 건드리지 않는다. 40 은 `PKG_DMF0082_DEMAND_DELETE_20260822` 로 이미 정정·실증 완료.

## 안전 절차

    BACKUP → 치환 → 사본 패키지(스펙+본문) 컴파일 시험 → 원본 적용 → VERIFY → INVALID 시 자동 원복

멱등: 마커가 이미 있으면 무변경. 실행: python apply.py   (점검만: --dry)
"""
import io
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

PKG = "PKG_DMF0082"
PROBE = "PKG_DMF0082_PROBE81"
HERE = os.path.dirname(os.path.abspath(__file__))
NL = chr(10)
MARK = "E20260822-DIV81DEL"

MERGE_ANCHOR = "        MERGE INTO SCM_MGR.DM_PLN_MKT_FCST A"
SRC_OLD = "WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req'))"
SRC_NEW = ("WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req')" + NL
           + "                     AND NVL(M.ACTION, 'X') <> 'D')   --[" + MARK
           + "] 삭제행은 MERGE 대상에서 제외 (안 하면 지운 행이 QTY=0 으로 되살아난다)")

DELETE_BLOCK = """        --[{mark}] 81 수요 행 삭제 — TO-BE 는 81 편집 권한이 있어 실삭제가 필요하다(사용자 지시 2026-08-22).
        --  40 처럼 'QTY=0 → 삭제' 를 쓸 수 없다: 81 은 QTY=0 행을 물리 저장하는 설계(바로 위 주석)라
        --  값을 0 으로 고친 것까지 지워져 DMF0003 정본과 어긋난다.
        --  그래서 FE 행 삭제 플래그를 기준으로 한다 — GT_PRDM1_T_MAIN.ACTION = p_active_flag (L11592).
        --  키 10종 = 아래 MERGE ON 절과 동일 (DM_PLN_MKT_FCST 에는 END_CUSTOMER·CELL_PROD_SITE_ID 없음).
        DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A
        WHERE A.MEASURE IN ('MKT_FCST', 'VMI_In_Req')
          AND EXISTS (
              SELECT 1
              FROM SCM_MGR.GT_PRDM1_T_MAIN B
              WHERE B.ACTION = 'D'
                AND B.MEASURE IN ('MKT_FCST', 'VMI_In_Req')
                AND B.DIVISION_ID   = A.DIVISION_ID
                AND B.PROJECT_CODE  = A.PROJECT_CODE
                AND B.SCM_SITE_ID   = A.SCM_SITE_ID
                AND B.ITEM_ID       = A.ITEM_ID
                AND B.DOM_EXP       = A.DOM_EXP
                AND B.FCST_TYPE     = A.FCST_TYPE
                AND B.INCOTERMS     = A.INCOTERMS
                AND B.MEASURE       = A.MEASURE
                AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
                AND B.YYYYMMDD      = A.YYYYMMDD
          );

""".format(mark=MARK)


def body_of(cur, name=PKG):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE BODY' ORDER BY LINE""", n=name)
    return "".join(r[0] for r in cur.fetchall())


def transform(body):
    for nm, s in (("MERGE 앵커", MERGE_ANCHOR), ("MERGE 소스", SRC_OLD)):
        c = body.count(s)
        if c != 1:
            sys.exit(f"[ABORT] {nm} 출현 {c}회 (기대 1) — 중단.")
    out = body.replace(MERGE_ANCHOR, DELETE_BLOCK + MERGE_ANCHOR, 1)
    out = out.replace(SRC_OLD, SRC_NEW, 1)
    return out


def compile_probe(cur, con, text):
    """이름만 바꾼 사본(스펙+본문)으로 컴파일 시험 — (VALID여부, 메시지)."""
    probe_ddl = re.sub(r'(PACKAGE\s+BODY\s+")' + PKG + r'(")', r"\1" + PROBE + r"\2",
                       text, count=1, flags=re.I)
    if PROBE not in probe_ddl:
        probe_ddl = re.sub(r"(PACKAGE\s+BODY\s+)" + PKG, r"\1" + PROBE,
                           text, count=1, flags=re.I)
    if PROBE not in probe_ddl:
        return None, "이름 치환 실패"
    probe_ddl = re.sub(r"(\bEND\s+)" + PKG + r"(\s*;)", r"\1" + PROBE + r"\2",
                       probe_ddl, flags=re.I)
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
        return False, str(ex).splitlines()[0][:130]
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
    if MARK in before:
        print("== 이미 정정됨 — 무변경 종료 ==")
        con.close()
        return 0

    bak = os.path.join(HERE, "BACKUP_" + PKG + "_BODY.sql")
    if not os.path.exists(bak):
        io.open(bak, "w", encoding="utf-8", newline="").write(before)
        print(f"== BACKUP: {bak} ==")

    after = transform(before)
    print("== 치환 2곳 (DELETE 신설 + MERGE 소스 제외조건) ==")

    # 회귀 가드
    if after.count("DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A") != 1:
        sys.exit("[ABORT] 신설 DELETE 가 1곳이 아니다 — 중단.")
    if after.count(MARK) != 2:
        sys.exit(f"[ABORT] 마커 {after.count(MARK)}곳 (기대 2) — 중단.")
    if after.count("MERGE INTO") != before.count("MERGE INTO"):
        sys.exit("[ABORT] MERGE 문 개수 변동 — 중단.")
    # DELETE 는 반드시 MERGE 보다 앞이어야 한다(뒤면 MERGE 가 되살린다)
    if after.index("DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A") > after.index(MERGE_ANCHOR):
        sys.exit("[ABORT] DELETE 가 MERGE 뒤에 위치 — 중단.")
    print("   순서 PASS — DELETE 가 MERGE 앞")

    if dry:
        io.open(os.path.join(HERE, "PREVIEW_" + PKG + "_BODY.sql"), "w",
                encoding="utf-8", newline="").write(after)
        i = after.index("DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A")
        print(NL + "== PREVIEW ==" + NL + after[i - 700:i + 1400])

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
    ok2 = fin.count(MARK) == 2
    print(f"   {'PASS' if ok2 else 'FAIL'}  적용 후 마커 {fin.count(MARK)}곳 (기대 2)")
    bad += 0 if ok2 else 1

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
