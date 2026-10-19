"""DMF0082_XLSNULL 사내 적용 겸 클라우드 스크립트 리허설 — A_DB 의 SQL 을 그대로 사내 ZIOUI1 에 실행한다.

순서: FRESH-GATE(현재 원문 == build 기준본) → 00 PRECHECK → 10 APPLY → DB 원문 == Python 적용본 대조 → 10 재실행(SKIP)
      → 90 VERIFY → 99 ROLLBACK → DB 원문 == 기준본 → 10 APPLY(최종) → DB 원문 == 적용본 → 90 VERIFY → 00 PRECHECK(적용 후)
CREATE OR REPLACE 는 A_DB/10·99 의 PL/SQL 블록 안에서 USER_SOURCE 를 재조회해 실행된다.

  python run_rehearsal.py
"""
import os
import re
import sys

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
CORP_DIR = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSNULL_20261014"
OUT = os.path.join(HERE, "_rehearsal_out")
SQLPLUS_ONLY = re.compile(r"^\s*(SET|COLUMN|PROMPT|DEFINE)\b", re.I)


def body_now(cur):
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return "".join(r[0] or "" for r in cur).replace("\r\n", "\n")


def split_script(text):
    """SQL*Plus 스크립트 → (kind, stmt) 목록. PL/SQL 블록은 '/' 줄까지, 일반 SQL 은 ';' 까지."""
    out, buf, in_plsql = [], [], False
    for line in text.split("\n"):
        if not in_plsql and (SQLPLUS_ONLY.match(line) or line.strip().startswith("--") or not line.strip()):
            if not buf:
                continue
        if not buf and re.match(r"^\s*(DECLARE|BEGIN)\b", line, re.I):
            in_plsql = True
        if in_plsql:
            if line.strip() == "/":
                out.append(("plsql", "\n".join(buf)))
                buf, in_plsql = [], False
            else:
                buf.append(line)
            continue
        buf.append(line)
        if line.rstrip().endswith(";"):
            out.append(("sql", "\n".join(buf).rstrip().rstrip(";")))
            buf = []
    assert not buf or not "".join(buf).strip(), f"미종결 문장: {buf[:3]}"
    return out


def run_file(cur, name, log):
    text = open(os.path.join(HERE, "A_DB", name), encoding="utf-8").read()
    log.append(f"\n######## {name}")
    for kind, stmt in split_script(text):
        if kind == "plsql":
            cur.callproc("DBMS_OUTPUT.ENABLE", [None])
            cur.execute(stmt)
            line, status = cur.var(str), cur.var(int)
            while True:
                cur.callproc("DBMS_OUTPUT.GET_LINE", (line, status))
                if status.getvalue() != 0:
                    break
                log.append("  OUT: " + str(line.getvalue()))
        else:
            cur.execute(stmt)
            cols = [d[0] for d in cur.description]
            log.append("  " + " | ".join(cols))
            for r in cur.fetchall():
                log.append("  " + " | ".join("" if v is None else str(v) for v in r))


def main():
    os.makedirs(OUT, exist_ok=True)
    asis = open(os.path.join(CORP_DIR, "PKG_DMF0082_BODY.ASIS.raw"), encoding="utf-8").read()
    tobe = open(os.path.join(CORP_DIR, "PKG_DMF0082_BODY.TOBE.raw"), encoding="utf-8").read()
    log = []
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','CON_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
        log.append("DB " + str(cur.fetchone()))
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 기준본
        now = body_now(cur)
        assert now == asis, "FRESH-GATE 실패: build 이후 DB 원문 변경 — 중단·build 재실행"
        log.append("FRESH-GATE PASS (DB 원문 == 기준본)")

        run_file(cur, "00_PRECHECK_CLOUD.sql", log)
        run_file(cur, "10_APPLY_XLSNULL_PATCH.sql", log)
        assert body_now(cur) == tobe, "PL/SQL 패치 결과 != Python 적용본"
        log.append("CHECK 1 PASS — PL/SQL 적용 결과 == Python 적용본 (바이트 동일)")
        run_file(cur, "10_APPLY_XLSNULL_PATCH.sql", log)   # 재실행 = SKIP 기대
        assert body_now(cur) == tobe
        log.append("CHECK 2 PASS — 재실행 무변경")
        run_file(cur, "90_VERIFY.sql", log)
        run_file(cur, "99_ROLLBACK_XLSNULL_PATCH.sql", log)
        assert body_now(cur) == asis, "원복 결과 != 기준본"
        log.append("CHECK 3 PASS — 원복 결과 == 기준본 (바이트 동일)")
        run_file(cur, "10_APPLY_XLSNULL_PATCH.sql", log)   # 최종 적용
        assert body_now(cur) == tobe
        log.append("CHECK 4 PASS — 최종 적용 == Python 적용본")
        run_file(cur, "90_VERIFY.sql", log)
        run_file(cur, "00_PRECHECK_CLOUD.sql", log)
    txt = "\n".join(log)
    open(os.path.join(OUT, "rehearsal.out.txt"), "w", encoding="utf-8").write(txt)
    print(txt)


if __name__ == "__main__":
    main()
