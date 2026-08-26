#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PKG_DMF0082 LOC ACTION 재산출 — 주차 합계가 **일 합계**로 축소된 변환 결함 정정 (2026-08-22).

## 장애 (사용자 신고)

    "단가 수정 시 아래 메세지 발생합니다. 삭제가 아닌 수정인데 삭제금지 메세지가 나오는 원인 확인해주세요.
     MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이내에 존재하므로
     Sales Price 삭제가 불가합니다. ● Sales Site : APRO_KR_ANY / ● Model : MCCH335080B1T000"

## 실측 — 저장 로그 (SCM_COM_SQL_LOG, 2026-08-22 23:21:52)

    activeFlag = M^M^M^M^M^M^M                    ← FE 는 전부 '수정'
    measure    = LOC ×7
    qty        = 5301^0^0^0^0^0^0                 ← 월요일만 5301, 화~일 6일은 0
    yyyymmdd   = 20260817^…^20260823              ← 한 주 7일

FE 는 주 단가를 (월=값, 화~일=0) 로 보낸다. 정상이다 — 주차 대표값 1건이면 충분하다.

## 원인 — MSSQL→Oracle 변환에서 **윈도우 파티션 범위가 깨졌다**

AS-IS (MSSQL) — 파생테이블에서 **전체 LOC 행**에 주차 파티션 합계를 먼저 구하고, **바깥에서** 날짜로 조인:

    UPDATE #T_MAIN SET [ACTION] = DD.[ACTION]
    FROM ( SELECT CASE WHEN SUM(A.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW + D.PARTIAL_WEEK_NAME) = 0
                       THEN 'D' ELSE 'M' END AS [ACTION], D.BASIS_YYYYMMDD
           FROM #T_MAIN A JOIN SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
           WHERE A.MEASURE='LOC' AND A.[ACTION] <> 'I' ) DD
    WHERE YYYYMMDD = DD.BASIS_YYYYMMDD AND MEASURE='LOC'

TO-BE (현행 Oracle) — 상관 조건을 **서브쿼리 안으로** 옮겨 파티션이 **그 날짜 1건**으로 축소:

    UPDATE GT_PRDM1_T_MAIN A
    SET ACTION = ( SELECT CASE WHEN SUM(B.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW||D.PARTIAL_WEEK_NAME) = 0
                              THEN 'D' ELSE 'M' END
                   FROM GT_PRDM1_T_MAIN B JOIN SCM_SYS_CALENDAR_M D ON B.YYYYMMDD = D.BASIS_YYYYMMDD
                   WHERE B.MEASURE='LOC' AND B.ACTION <> 'I'
                     AND B.YYYYMMDD = A.YYYYMMDD          ← ⛔ 여기가 파티션을 1일로 좁힌다
                   FETCH FIRST 1 ROWS ONLY )
    WHERE A.MEASURE='LOC' AND A.ACTION <> 'I';

⇒ "주차 합계" 가 **"일 합계"** 가 된다. 위 페이로드에서 0 인 6일이 각각 `ACTION='D'` 로 재분류되고,
   검증 #18(`WHERE MEASURE='LOC' AND ACTION='D'`, L12801~12803)이 발동해 **수정인데 삭제 검증**에 막힌다.
   AS-IS 라면 주 합계 5301 ≠ 0 → 7일 전부 'M' → 검증 #18 자체가 돌지 않는다.

## 정정 — AS-IS 구조 그대로 (파티션 먼저, 조인 나중)

    MERGE INTO GT_PRDM1_T_MAIN A
    USING ( SELECT BASIS_YYYYMMDD, MAX(ACT) ACT FROM (
                SELECT D.BASIS_YYYYMMDD,
                       CASE WHEN SUM(B.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW||D.PARTIAL_WEEK_NAME) = 0
                            THEN 'D' ELSE 'M' END AS ACT
                FROM GT_PRDM1_T_MAIN B JOIN SCM_SYS_CALENDAR_M D ON B.YYYYMMDD = D.BASIS_YYYYMMDD
                WHERE B.MEASURE='LOC' AND B.ACTION <> 'I' )
            GROUP BY BASIS_YYYYMMDD ) S
    ON (A.YYYYMMDD = S.BASIS_YYYYMMDD AND A.MEASURE = 'LOC')
    WHEN MATCHED THEN UPDATE SET A.ACTION = S.ACT WHERE A.ACTION <> 'I';

· `MAX(ACT)` 는 안전하다 — 같은 날짜는 같은 주차 파티션이라 ACT 가 **행마다 동일**하다(중복 제거용).
· `A.ACTION <> 'I'` 는 ON 이 아니라 **UPDATE 의 WHERE** 에 둔다 — Oracle 은 ON 절 컬럼을 갱신할 수 없다.
· 의미는 AS-IS 와 동일하게 유지한다(주차 합계는 **키 구분 없이** 전 LOC 행 대상 — 임의 개선 금지).

## 안전 절차

    BACKUP → 치환 → 사본 패키지(스펙+본문) 컴파일 시험 → 원본 적용 → VERIFY → INVALID 시 자동 원복

멱등: 마커가 있으면 무변경. 실행: python apply.py   (점검만: --dry)
"""
import io
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

PKG = "PKG_DMF0082"
PROBE = "PKG_DMF0082_PROBEWS"
HERE = os.path.dirname(os.path.abspath(__file__))
NL = chr(10)
MARK = "E20260822-LOCWEEKSUM"

OLD = """    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET ACTION = (
        SELECT CASE WHEN SUM(B.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW || D.PARTIAL_WEEK_NAME) = 0 THEN 'D' ELSE 'M' END
        FROM SCM_MGR.GT_PRDM1_T_MAIN B
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON B.YYYYMMDD = D.BASIS_YYYYMMDD
        WHERE B.MEASURE = 'LOC' AND B.ACTION <> 'I'
          AND B.YYYYMMDD = A.YYYYMMDD
        FETCH FIRST 1 ROWS ONLY
    )
    WHERE A.MEASURE = 'LOC' AND A.ACTION <> 'I';"""

NEW = """    --[""" + MARK + """] 주차 합계가 '일 합계' 로 축소된 변환 결함 정정 (2026-08-22).
    --   구 구현은 바깥 행 날짜에 맞추는 상관 조건을 **서브쿼리 안**에 두어, 윈도우 함수가 돌기 전에
    --   행이 그 날짜 1건으로 좁혀졌다 → PARTITION BY 주차가 무의미해지고 **하루치 합계**로 판정됐다.
    --   실사고: FE 가 주 단가를 (월=5301, 화~일=0) 로 보내면 0 인 6일이 각각 ACTION='D' 가 되어
    --   검증 #18(SALES PRICE 삭제 시 52주 FCST 확인)이 **수정인데** 발동, 저장이 막혔다.
    --   AS-IS(MSSQL)는 파생테이블에서 전체 LOC 행에 파티션 합계를 먼저 구하고 **바깥에서** 날짜로 조인한다:
    --       UPDATE #T_MAIN SET [ACTION] = DD.[ACTION]
    --       FROM ( SELECT CASE WHEN SUM(A.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW + D.PARTIAL_WEEK_NAME) = 0
    --                          THEN 'D' ELSE 'M' END AS [ACTION], D.BASIS_YYYYMMDD
    --              FROM #T_MAIN A JOIN SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
    --              WHERE A.MEASURE='LOC' AND A.[ACTION] <> 'I' ) DD
    --       WHERE YYYYMMDD = DD.BASIS_YYYYMMDD AND MEASURE='LOC'
    --   그 구조를 그대로 살린다. MAX(ACT) 는 중복 제거용 — 같은 날짜는 같은 주차라 ACT 가 행마다 동일하다.
    --   `A.ACTION <> 'I'` 는 ON 이 아니라 UPDATE 의 WHERE 에 둔다(Oracle 은 ON 절 컬럼을 갱신 못 함).
    MERGE INTO SCM_MGR.GT_PRDM1_T_MAIN A
    USING (
        SELECT BASIS_YYYYMMDD, MAX(ACT) AS ACT
        FROM (
            SELECT D.BASIS_YYYYMMDD
                 , CASE WHEN SUM(B.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW || D.PARTIAL_WEEK_NAME) = 0
                        THEN 'D' ELSE 'M' END AS ACT
            FROM SCM_MGR.GT_PRDM1_T_MAIN B
            JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON B.YYYYMMDD = D.BASIS_YYYYMMDD
            WHERE B.MEASURE = 'LOC' AND B.ACTION <> 'I'
        )
        GROUP BY BASIS_YYYYMMDD
    ) S
    ON (A.YYYYMMDD = S.BASIS_YYYYMMDD AND A.MEASURE = 'LOC')
    WHEN MATCHED THEN UPDATE SET A.ACTION = S.ACT WHERE A.ACTION <> 'I';"""


def body_of(cur, name=PKG):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE BODY' ORDER BY LINE""", n=name)
    return "".join(r[0] for r in cur.fetchall())


def compile_probe(cur, con, text):
    probe = re.sub(r'(PACKAGE\s+BODY\s+")' + PKG + r'(")', r"\1" + PROBE + r"\2",
                   text, count=1, flags=re.I)
    if PROBE not in probe:
        probe = re.sub(r"(PACKAGE\s+BODY\s+)" + PKG, r"\1" + PROBE, text, count=1, flags=re.I)
    if PROBE not in probe:
        return None, "이름 치환 실패"
    probe = re.sub(r"(\bEND\s+)" + PKG + r"(\s*;)", r"\1" + PROBE + r"\2", probe, flags=re.I)
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE' ORDER BY LINE""", n=PKG)
    spec = "".join(r[0] for r in cur.fetchall())
    if not spec:
        return None, "원본 스펙을 읽지 못함"
    sp = re.sub(r'(PACKAGE\s+")' + PKG + r'(")', r"\1" + PROBE + r"\2", spec, count=1, flags=re.I)
    if PROBE not in sp:
        sp = re.sub(r"(PACKAGE\s+)" + PKG, r"\1" + PROBE, spec, count=1, flags=re.I)
    sp = re.sub(r"(\bEND\s+)" + PKG + r"(\s*;)", r"\1" + PROBE + r"\2", sp, flags=re.I)
    try:
        cur.execute("CREATE OR REPLACE " + sp)
        con.commit()
    except Exception as ex:                                    # noqa: BLE001
        return None, "사본 스펙 생성 실패: " + str(ex).splitlines()[0][:90]
    try:
        cur.execute("CREATE OR REPLACE " + probe)
        con.commit()
    except Exception as ex:                                    # noqa: BLE001
        return False, str(ex).splitlines()[0][:130]
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", n=PROBE)
    ne = cur.fetchone()[0]
    msg = ""
    if ne:
        cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n
                        ORDER BY SEQUENCE FETCH FIRST 3 ROWS ONLY""", n=PROBE)
        msg = " | ".join("L{0}: {1}".format(a, b.strip()[:70]) for a, b in cur.fetchall())
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
    c = before.count(OLD)
    if c != 1:
        sys.exit(f"[ABORT] 앵커 출현 {c}회 (기대 1) — 원문이 다르다. 중단.")

    bak = os.path.join(HERE, "BACKUP_" + PKG + "_BODY.sql")
    if not os.path.exists(bak):
        io.open(bak, "w", encoding="utf-8", newline="").write(before)
        print(f"== BACKUP: {bak} ==")

    after = before.replace(OLD, NEW, 1)
    print("== 치환 1곳 (LOC ACTION 재산출) ==")
    # 회귀 가드
    # ⚠ 주석에 AS-IS(MSSQL) 원문을 인용해 두었으므로 `PARTITION BY` 문자열은 2회 나온다
    #   (주석 1 = `SUM(A.QTY_PRICE) … +` / 코드 1 = `SUM(B.QTY_PRICE) … ||`).
    #   **실행되는 코드**만 세도록 별칭까지 포함해 판정한다.
    if after.count("SUM(B.QTY_PRICE) OVER (PARTITION BY") != 1:
        sys.exit(f"[ABORT] 실행 파티션 식 {after.count('SUM(B.QTY_PRICE) OVER (PARTITION BY')}곳 (기대 1) — 중단.")
    # 파티션을 1일로 좁히던 상관 조건이 **딱 1건만** 사라졌는지.
    #   ⚠ 같은 문자열이 패키지 다른 곳에 3곳 더 있다(L13586·13643·13746 — 정상적인 조인 조건).
    #     "완전히 없어졌는가" 로 보면 그 3곳 때문에 항상 실패한다 → **감소량**으로 판정한다.
    CORR = "B.YYYYMMDD = A.YYYYMMDD"
    if before.count(CORR) - after.count(CORR) != 1:
        sys.exit(f"[ABORT] 상관 조건 감소 {before.count(CORR) - after.count(CORR)}건 (기대 1) — 중단.")
    if after.count(MARK) != 1:
        sys.exit("[ABORT] 마커 1곳 아님 — 중단.")

    if dry:
        io.open(os.path.join(HERE, "PREVIEW_" + PKG + "_BODY.sql"), "w",
                encoding="utf-8", newline="").write(after)
        i = after.index(MARK)
        print(NL + "== PREVIEW ==" + NL + after[i - 200:i + 1900])

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
        con.close()
        return 1

    cur.execute("""SELECT COUNT(*) FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR' AND O.STATUS='INVALID'
                    AND O.OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES
                                           WHERE OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""", n=PKG)
    print(f"   {'PASS' if cur.fetchone()[0] == 0 else 'WARN'}  의존 객체 INVALID 확인")
    fin = body_of(cur)
    ok2 = fin.count(MARK) == 1 and fin.count("B.YYYYMMDD = A.YYYYMMDD") == before.count(
        "B.YYYYMMDD = A.YYYYMMDD") - 1
    print(f"   {'PASS' if ok2 else 'FAIL'}  적용 후 마커 1곳 · 구 상관조건 제거")
    con.close()
    return 0 if ok2 else 1


if __name__ == "__main__":
    sys.exit(main())
