#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PKG_DMF0082 `V_PROC_INPUT` 버퍼 초과(ORA-06502) 정정 — 패키지 전수 (사용자 결정 B, 2026-08-22).

## 장애 (사용자 신고 2026-08-22)

    "방금 추가한 A/S(Free) ROW 에 대해서 DELETE 후 저장 시 SQL ERROR 발생"
    "조금전 LOC 도 저장했는데 조회 시 보이지 않습니다"

BE 로그 실측 (래퍼 `InvocationTargetException: null` 에 가려져 있던 실제 오류):

    ORA-20001: ORA-06502: PL/SQL: 값 또는 변환 오류 : 문자열 버퍼가 너무 작습니다
    ORA-06512: "SCM_MGR.PKG_DMF0082", 11399행

## 원인

`P_DMF0082_SAVE_MAIN_DATA` 시작부에서 **진단 로깅용** 변수에 24개 파라미터 전부를 JSON 으로 담는다.

    L11267  V_PROC_INPUT  VARCHAR2(4000 CHAR);
    L11399  V_PROC_INPUT := JSON_OBJECT('p_active_flag' VALUE p_active_flag, ... 24종 ... );

파라미터는 행 수만큼 `'^'` 로 이어붙인 문자열이다. 실패 저장은 **168행**이었고
`p_scm_site_id` **한 개만 3,863자**("BYD Electronics_CN_SZX" 22자 × 168). 24종을 합치면 수만 자 →
`VARCHAR2(4000)` 즉시 초과.

⚠ **A/S 행과 무관하다.** 저장 행 수가 많으면 measure·division 무관하게 항상 터진다.
⚠ 오류 지점이 **프로시저 시작부**라 아무것도 저장되지 않는다 —
   "LOC 저장했는데 조회에 안 보임" 도 같은 원인(별개 버그 아님)이다.

## 왜 CLOB 선언만으로는 부족한가 (사용자 선택 B 의 구현 방식 조정)

소비처 `PR_DM_SYS_LOG_BATCH` 의 인자는 **VARCHAR2** 이고, 그 안에서 이미 잘라 쓴다:

    PR_DM_SYS_LOG_BATCH L36  c_in_para_len constant pls_integer := 2000;
    PR_DM_SYS_LOG_BATCH L51  v_in_para_data := substr(p_in_para_data, 1, c_in_para_len);
    대상 컬럼            SCM_SYS_LOG_BATCH.IN_PARA_DATA  VARCHAR2(4000)

즉 **로그에는 최대 2,000자만 남는다.** 변수를 CLOB 으로 바꿔도 호출 시 VARCHAR2 로 암묵 변환되어
32,767자를 넘으면 **같은 ORA-06502 가 재발**한다. 근본 처방은 **생성 시점에 잘라 담는 것**이다.

## 정정 (패키지 전수 = 사용자 B 범위)

`V_PROC_INPUT := JSON_OBJECT( ... );` 를 전부 다음으로 바꾼다:

    V_PROC_INPUT := SUBSTR(JSON_OBJECT( ... RETURNING CLOB), 1, 4000);

- `RETURNING CLOB` — `JSON_OBJECT` 기본 반환이 `VARCHAR2(4000)` 이라 **SUBSTR 이전에** 터진다.
  CLOB 으로 받아야 생성 자체가 성공한다.
- `SUBSTR(..., 1, 4000)` — 선언 타입(VARCHAR2(4000)) 을 그대로 두고 안전하게 축약.
  소비처가 2,000자로 다시 자르므로 진단 정보 손실은 없다(원래도 2,000자만 저장됐다).
- 선언부는 **건드리지 않는다** — 호출부 전수 수정이 불필요하고 암묵 변환 위험도 없다.

멱등: 이미 `SUBSTR(JSON_OBJECT` 형태면 무변경. 실행: python apply.py  (점검만: --dry)
"""
import io
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

PKG = "PKG_DMF0082"
HERE = os.path.dirname(os.path.abspath(__file__))
NL = chr(10)
START = "V_PROC_INPUT := JSON_OBJECT("
MARK = "V_PROC_INPUT := SUBSTR(JSON_OBJECT("


def body_of(cur):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY'
                    ORDER BY LINE""", n=PKG)
    return "".join(r[0] for r in cur.fetchall())


def transform(body):
    """각 `V_PROC_INPUT := JSON_OBJECT(` 문을 SUBSTR(... RETURNING CLOB),1,4000) 으로."""
    out, i, n = [], 0, 0
    while True:
        j = body.find(START, i)
        if j < 0:
            out.append(body[i:])
            break
        out.append(body[i:j])
        # 여는 괄호부터 짝 맞는 닫는 괄호까지 스캔 (문자열 리터럴 안의 괄호는 건너뛴다)
        k = j + len(START)
        depth, in_str = 1, False
        while k < len(body):
            c = body[k]
            if in_str:
                if c == "'":
                    if k + 1 < len(body) and body[k + 1] == "'":
                        k += 1
                    else:
                        in_str = False
            elif c == "'":
                in_str = True
            elif c == "(":
                depth += 1
            elif c == ")":
                depth -= 1
                if depth == 0:
                    break
            k += 1
        if k >= len(body):
            sys.exit("[ABORT] JSON_OBJECT 닫는 괄호를 찾지 못함 — 중단.")
        inner = body[j + len(START):k]          # 인자 목록
        out.append(MARK + inner + " RETURNING CLOB), 1, 4000)")
        i = k + 1
        n += 1
    return "".join(out), n


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = body_of(cur)
    print(f"== 본문 {len(before):,} chars ==")
    already = before.count(MARK)
    todo = before.count(START) - already
    print(f"   이미 정정됨 {already}곳 · 정정 대상 {todo}곳")
    if todo == 0:
        print("== 무변경 종료 ==")
        con.close()
        return 0

    bak = os.path.join(HERE, f"BACKUP_{PKG}_BODY.sql")
    if not os.path.exists(bak):
        io.open(bak, "w", encoding="utf-8", newline="").write(before)
        print(f"== BACKUP 저장: {bak} ==")

    after, n = transform(before)
    print(f"== 치환 {n}곳 ==")

    # 회귀 가드 — 치환 외 변경이 없어야 한다
    if len(after) <= len(before):
        sys.exit("[ABORT] 치환 후 길이가 늘지 않음 — 예상과 다름. 중단.")
    if after.count("JSON_OBJECT(") != before.count("JSON_OBJECT("):
        sys.exit("[ABORT] JSON_OBJECT 개수 변동 — 중단.")
    if after.count("RETURNING CLOB), 1, 4000)") != n:
        sys.exit(f"[ABORT] RETURNING 절 {after.count('RETURNING CLOB), 1, 4000)')}곳 (기대 {n}) — 중단.")

    if dry:
        io.open(os.path.join(HERE, f"PREVIEW_{PKG}_BODY.sql"), "w",
                encoding="utf-8", newline="").write(after)
        print("== --dry: DB 미적용, PREVIEW 생성 ==")
        con.close()
        return 0

    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
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

    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY SEQUENCE""", n=PKG)
    errs = cur.fetchall()
    print(f"   {'PASS' if not errs else 'FAIL'}  ALL_ERRORS {len(errs)}건")
    for e in errs[:5]:
        print("        ", e)
    bad += 0 if not errs else 1

    cur.execute("""SELECT COUNT(*) FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR'
                    AND O.STATUS='INVALID'
                    AND O.OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES
                                           WHERE OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""", n=PKG)
    dep = cur.fetchone()[0]
    print(f"   {'PASS' if dep == 0 else 'WARN'}  의존 객체 INVALID {dep}건")

    fin = body_of(cur)
    ok = fin.count(MARK) == n and fin.count(START) == n
    print(f"   {'PASS' if ok else 'FAIL'}  적용 후 SUBSTR 형태 {fin.count(MARK)}곳 (기대 {n})")
    bad += 0 if ok else 1

    # 실증 — 4000자를 넘는 입력으로 JSON 생성이 통과하는지 (동일 구문 재현)
    big = "X" * 5000
    try:
        cur.execute("SELECT SUBSTR(JSON_OBJECT('a' VALUE :v RETURNING CLOB), 1, 4000) FROM DUAL",
                    v=big)
        got = cur.fetchone()[0]
        got = got.read() if hasattr(got, "read") else got
        print(f"   PASS  5,000자 입력 → 생성 성공 · 결과 {len(got)}자 (4000 이하로 축약)")
    except Exception as ex:                                   # noqa: BLE001
        print(f"   FAIL  구문 실증 오류: {str(ex)[:90]}")
        bad += 1

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
