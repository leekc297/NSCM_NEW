#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PKG_DMF0082 `V_PROC_INPUT` ORA-06502 정정 — 인자 선절단 + 행수 (사용자 결정, 2026-08-22).

## 장애

    ORA-20001: ORA-06502 ... 문자열 버퍼가 너무 작습니다
    ORA-06512: "SCM_MGR.PKG_DMF0082", 11399행

`V_PROC_INPUT VARCHAR2(4000 CHAR)` 에 24개 파라미터를 통째로 JSON 으로 담는데, 파라미터는 행 수만큼
`'^'` 로 이어붙은 문자열이라 168행 저장에서 `p_scm_site_id` 하나만 3,863자였다. 프로시저 **시작부**라
아무것도 저장되지 않는다("LOC 저장했는데 조회에 안 보임" 도 동일 원인).

## 후보 검증 (PL/SQL 익명 블록 실측 — SQL 컨텍스트 아님)

    ① 현행 재현 (5,000자 인자)                → FAIL ORA-06502   ← 장애 메커니즘 확인
    ② SUBSTR(JSON_OBJECT(... RETURNING CLOB)) → FAIL PLS-00684   ← 1차 시도 실패 원인
    ③ 인자 선절단 200자 × 24종                → FAIL ORA-06502   ← 여전히 초과
    ④ 인자 선절단 120자 × 24종                → PASS 3,385자     ← 여유 615자뿐
    ⑤ rows + 인자 선절단 50자 × 24종          → PASS 1,609자     ← 채택

⚠ ②는 **SQL 에서는 통과하고 PL/SQL 에서는 실패**한다. 1차 시도가 SQL `SELECT ... FROM DUAL` 로
   검증해 초록불을 받고 적용 → 패키지 INVALID. 반드시 **익명 블록**으로 검증할 것.

## 채택안 = ⑤ (인자 선절단 50자 + 행수)

    V_PROC_INPUT := JSON_OBJECT(
        'rows'          VALUE REGEXP_COUNT(<첫 파라미터>,'\\^') + 1,
        'p_active_flag' VALUE SUBSTR(p_active_flag, 1, 50),
        ... 전 파라미터 동일 ... );

**왜 이 안인가**
- 소비처 `PR_DM_SYS_LOG_BATCH` 가 `substr(p_in_para_data, 1, 2000)` 으로 자른다(L36/L51).
  1,609자면 **전량 저장**된다. 120자안(3,385자)은 2,000 초과분이 조용히 버려진다.
- 파라미터 **이름은 전부 남는다** — 어떤 인자가 왔는지 추적 가능.
- `rows` 로 **행 수**를 남긴다. 이번 장애처럼 "행이 많아 터지는" 유형에서 가장 필요한 값이다.
- 전체 페이로드는 이미 BE 가 `SCM_COM_SQL_LOG.PARAMS` 에 남긴다(이번 원인도 거기서 찾았다) —
  SP 쪽 전문 JSON 은 중복이라 잘라도 손실이 없다.

## 안전 절차 (1차 실패 재발 방지)

적용 전에 **이름만 바꾼 사본 패키지로 컴파일을 시험**하고, VALID 일 때만 실 패키지에 적용한다.
적용 후 INVALID 면 **즉시 백업으로 자동 원복**한다.

실행: python apply2.py  (점검만: --dry)
"""
import io
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

PKG = "PKG_DMF0082"
PROBE = "PKG_DMF0082_SYNTAXCHK"
HERE = os.path.dirname(os.path.abspath(__file__))
NL = chr(10)
START = "V_PROC_INPUT := JSON_OBJECT("
CUT = 50
DONE_MARK = f", 1, {CUT})"


def body_of(cur, name=PKG):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY'
                    ORDER BY LINE""", n=name)
    return "".join(r[0] for r in cur.fetchall())


def split_args(inner):
    """JSON_OBJECT 인자 목록을 최상위 콤마로 분리(문자열·괄호 보호)."""
    parts, depth, in_str, cur_ = [], 0, False, []
    for idx, c in enumerate(inner):
        if in_str:
            cur_.append(c)
            if c == "'" and not (idx + 1 < len(inner) and inner[idx + 1] == "'"):
                in_str = False
            continue
        if c == "'":
            in_str = True; cur_.append(c); continue
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
        if c == "," and depth == 0:
            parts.append("".join(cur_)); cur_ = []
        else:
            cur_.append(c)
    if "".join(cur_).strip():
        parts.append("".join(cur_))
    return parts


def transform(body):
    out, i, sites, wrapped = [], 0, 0, 0
    while True:
        j = body.find(START, i)
        if j < 0:
            out.append(body[i:]); break
        out.append(body[i:j])
        k, depth, in_str = j + len(START), 1, False
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
            sys.exit("[ABORT] 닫는 괄호 미발견 — 중단.")
        inner = body[j + len(START):k]
        newargs, first_param = [], None
        for a in split_args(inner):
            m = re.match(r"(\s*)('(?:[^']|'')*')(\s+VALUE\s+)(.+)$", a, re.S | re.I)
            if not m:
                newargs.append(a); continue
            ws, key, mid, expr = m.groups()
            e = expr.strip()
            if first_param is None and re.fullmatch(r"[A-Za-z_][\w$#]*", e):
                first_param = e
            # 이미 절단돼 있으면 그대로
            if DONE_MARK in e:
                newargs.append(a); continue
            # 단순 식별자만 절단 (표현식은 원형 유지 — 예기치 않은 의미 변화 방지)
            if re.fullmatch(r"[A-Za-z_][\w$#]*", e):
                newargs.append(f"{ws}{key}{mid}SUBSTR({e}, 1, {CUT})")
                wrapped += 1
            else:
                newargs.append(a)
        rows = (f"'rows' VALUE REGEXP_COUNT({first_param}, '\\^') + 1, "
                if first_param else "")
        out.append(START + rows + ",".join(newargs) + ")")
        i = k + 1
        sites += 1
    return "".join(out), sites, wrapped


def compile_probe(cur, con, text):
    """이름만 바꾼 사본으로 컴파일 시험 — VALID 여부 반환."""
    probe_ddl = re.sub(r'(PACKAGE\s+BODY\s+")' + PKG + r'(")', r"\1" + PROBE + r"\2",
                       text, count=1, flags=re.I)
    if PROBE not in probe_ddl:
        probe_ddl = re.sub(r"(PACKAGE\s+BODY\s+)" + PKG, r"\1" + PROBE,
                           text, count=1, flags=re.I)
    if PROBE not in probe_ddl:
        return None, "이름 치환 실패"
    # 말미 `END PKG_DMF0082;` 도 함께 바꾼다 — 안 바꾸면 PLS-00113(식별자 불일치)이 나서
    #   진짜 구문 오류와 구분되지 않는다(1차 --dry 에서 실제로 발생).
    probe_ddl = re.sub(r"(\bEND\s+)" + PKG + r"(\s*;)", r"\1" + PROBE + r"\2",
                       probe_ddl, flags=re.I)
    # 패키지 **본문은 스펙이 있어야** 컴파일된다(PLS-00201/00304) — 사본 스펙도 함께 만든다.
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE' ORDER BY LINE""", n=PKG)
    spec = "".join(r[0] for r in cur.fetchall())
    if not spec:
        return None, "원본 스펙을 읽지 못함"
    spec_ddl = re.sub(r'(PACKAGE\s+")' + PKG + r'(")', r"\1" + PROBE + r"\2",
                      spec, count=1, flags=re.I)
    if PROBE not in spec_ddl:
        spec_ddl = re.sub(r"(PACKAGE\s+)" + PKG, r"\1" + PROBE, spec, count=1, flags=re.I)
    spec_ddl = re.sub(r"(\bEND\s+)" + PKG + r"(\s*;)", r"\1" + PROBE + r"\2",
                      spec_ddl, flags=re.I)
    try:
        cur.execute("CREATE OR REPLACE " + spec_ddl)
        con.commit()
    except Exception as ex:                                   # noqa: BLE001
        return None, f"사본 스펙 생성 실패: {str(ex).splitlines()[0][:90]}"
    try:
        cur.execute("CREATE OR REPLACE " + probe_ddl)
        con.commit()
    except Exception as ex:                                   # noqa: BLE001
        return False, str(ex).splitlines()[0][:120]
    cur.execute("""SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n""", n=PROBE)
    ne = cur.fetchone()[0]
    msg = ""
    if ne:
        cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n
                        ORDER BY SEQUENCE FETCH FIRST 3 ROWS ONLY""", n=PROBE)
        msg = " | ".join(f"L{a}: {b.strip()[:60]}" for a, b in cur.fetchall())
    for ddl in (f"DROP PACKAGE BODY SCM_MGR.{PROBE}", f"DROP PACKAGE SCM_MGR.{PROBE}"):
        try:
            cur.execute(ddl); con.commit()
        except Exception:                                      # noqa: BLE001
            pass
    return (ne == 0), msg


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = body_of(cur)
    print(f"== 본문 {len(before):,} chars · JSON_OBJECT 대입 {before.count(START)}곳 ==")
    bak = os.path.join(HERE, f"BACKUP_{PKG}_BODY.sql")
    if not os.path.exists(bak):
        io.open(bak, "w", encoding="utf-8", newline="").write(before)
    print(f"== BACKUP: {bak} ==")

    after, sites, wrapped = transform(before)
    print(f"== 치환 {sites}곳 · 인자 절단 {wrapped}개 ==")
    if after.count("JSON_OBJECT(") != before.count("JSON_OBJECT("):
        sys.exit("[ABORT] JSON_OBJECT 개수 변동 — 중단.")
    io.open(os.path.join(HERE, f"PREVIEW_{PKG}_BODY.sql"), "w",
            encoding="utf-8", newline="").write(after)

    print(f"{NL}== 사본 컴파일 시험 ({PROBE}) ==")
    ok, msg = compile_probe(cur, con, after)
    if ok is None:
        sys.exit(f"[ABORT] {msg}")
    print(f"   {'PASS' if ok else 'FAIL'}  컴파일 {'성공' if ok else '실패'} {msg}")
    if not ok:
        sys.exit("[ABORT] 사본이 컴파일되지 않음 — 실 패키지 미적용. 중단.")

    if dry:
        print("== --dry: 사본 검증만 하고 종료 (실 패키지 미적용) ==")
        con.close()
        return 0

    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
    cur.execute("CREATE OR REPLACE " + after)
    con.commit()
    print("== 실 패키지 재컴파일 완료 ==")

    print(f"{NL}== VERIFY ==")
    bad = 0
    cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                    AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""", n=PKG)
    st = (cur.fetchone() or ["(없음)"])[0]
    print(f"   {'PASS' if st == 'VALID' else 'FAIL'}  {PKG} STATUS = {st}")
    if st != "VALID":
        print("   !! INVALID — 백업으로 자동 원복")
        cur.execute("CREATE OR REPLACE " + before); con.commit()
        cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                        AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""", n=PKG)
        print("   원복 후 STATUS =", cur.fetchone()[0])
        con.close()
        return 1

    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", n=PKG)
    ne = cur.fetchone()[0]
    print(f"   {'PASS' if ne == 0 else 'FAIL'}  ALL_ERRORS {ne}건")
    bad += 0 if ne == 0 else 1

    cur.execute("""SELECT COUNT(*) FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR'
                    AND O.STATUS='INVALID'
                    AND O.OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES
                                           WHERE OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""", n=PKG)
    print(f"   PASS/WARN  의존 객체 INVALID {cur.fetchone()[0]}건")

    fin = body_of(cur)
    n_sub = fin.count(DONE_MARK)
    print(f"   {'PASS' if n_sub >= wrapped else 'FAIL'}  적용 후 SUBSTR 절단 {n_sub}개 (기대 ≥{wrapped})")
    bad += 0 if n_sub >= wrapped else 1
    print(f"   {'PASS' if 'rows' in fin else 'WARN'}  rows 키 삽입 확인")

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
