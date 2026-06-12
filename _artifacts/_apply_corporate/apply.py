#!/usr/bin/env python3
"""
사내 Oracle DB (121.162.245.167:2521:ESSCMD) SQL 적용 wrapper.
- oracledb thin mode (Oracle Instant Client 미설치 OK)
- sqlplus 토큰 (SET/PROMPT/REM/`/`) 처리
- PL/SQL block (BEGIN..END;/) 단위 execute
- DBMS_OUTPUT capture
- Known error 6 카테고리 분류 (apply.sh 와 동등)

Usage:
    python apply.py <sql_file> [label]
"""
import sys
import os
import re
import datetime
from pathlib import Path

try:
    import oracledb
except ImportError:
    print("[FAIL] oracledb 미설치. 설치: pip install oracledb")
    sys.exit(1)

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)

LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

# Known-acceptable error 패턴 (apply.sh 와 동등)
KNOWN_PATTERNS = [
    (re.compile(r'ORA-01400.*"(MSG_TP_CD|USE_YN|CREATED_BY|LAST_UPDATED_BY)"', re.I), "MSG_M NOT NULL"),
    (re.compile(r'ORA-00942.*SCM_COM_MSG_M', re.I | re.S), "SCM_COM_MSG_M missing"),
    (re.compile(r'ORA-00904.*"BMK_YN"', re.I), "BMK_YN column missing"),
    (re.compile(r'ORA-01653', re.I), "USERS tablespace quota"),
    (re.compile(r'(DBMS_METADATA|UTL_XML|LPX-00210|bad stylesheet)', re.I), "DBMS_METADATA bug"),
]


def is_known_error(err_text: str) -> str | None:
    for pat, name in KNOWN_PATTERNS:
        if pat.search(err_text):
            return name
    return None


def split_statements(sql_text: str):
    """SQL 파일을 statement 단위로 분리.

    - `/` 단독 line = PL/SQL block 종료
    - `;` 끝의 line = 일반 SQL statement
    - sqlplus 토큰 (SET/PROMPT/REM/WHENEVER/SPOOL/DEFINE/EXIT) skip
    - 주석 (--, /* */) 제거 없이 보존 (oracledb 가 처리)
    """
    SQLPLUS_TOKENS = re.compile(
        r'^\s*(SET|PROMPT|REM|REMARK|WHENEVER|SPOOL|DEFINE|UNDEF|ACCEPT|EXIT|QUIT|SHOW|COL(UMN)?|TTITLE|BTITLE|BREAK|COMPUTE|CONNECT|DISCONNECT)\b',
        re.I,
    )

    # CRLF -> LF
    sql_text = sql_text.replace("\r\n", "\n").replace("\r", "\n")
    lines = sql_text.split("\n")

    statements = []  # list of (text, ends_with_slash:bool)
    buf = []
    in_plsql = False

    def flush(slash: bool):
        nonlocal buf
        text = "\n".join(buf).strip()
        if text:
            statements.append((text, slash))
        buf = []

    for line in lines:
        stripped = line.strip()

        # sqlplus 토큰 (PL/SQL block 안에선 처리 안 함)
        if not buf and not in_plsql and SQLPLUS_TOKENS.match(line):
            continue

        # `/` 단독 = PL/SQL block 종료
        if stripped == "/":
            flush(slash=True)
            in_plsql = False
            continue

        # PL/SQL block 시작 감지 (CREATE OR REPLACE PROCEDURE/PACKAGE/FUNCTION/TRIGGER, DECLARE, BEGIN)
        if not in_plsql and not buf:
            head = re.match(
                r'^\s*(CREATE\s+(OR\s+REPLACE\s+)?(PROCEDURE|PACKAGE|FUNCTION|TRIGGER|TYPE)|DECLARE|BEGIN)\b',
                line, re.I,
            )
            if head:
                in_plsql = True

        buf.append(line)

        # 일반 SQL statement (PL/SQL block 안 아닐 때) `;` 종결
        if not in_plsql and stripped.endswith(";"):
            # 마지막 `;` 제거
            buf[-1] = buf[-1].rstrip()[:-1]
            flush(slash=False)

    # 마지막 잔여
    if buf:
        flush(slash=in_plsql)

    return statements


def enable_dbms_output(cursor):
    cursor.callproc("DBMS_OUTPUT.ENABLE", [None])


def fetch_dbms_output(cursor) -> list[str]:
    lines = []
    line_var = cursor.var(str)
    status_var = cursor.var(int)
    while True:
        cursor.callproc("DBMS_OUTPUT.GET_LINE", [line_var, status_var])
        if status_var.getvalue() != 0:
            break
        v = line_var.getvalue()
        if v is not None:
            lines.append(v)
    return lines


def run(sql_file: Path, label: str):
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{ts}_{label}.log"

    print(f"=== APPLY: {label} ===")
    print(f"  SQL : {sql_file}")
    print(f"  LOG : {log_file}")
    print(f"  TIME: {datetime.datetime.now().strftime('%H:%M:%S')}")

    sql_text = sql_file.read_text(encoding="utf-8", errors="replace")
    statements = split_statements(sql_text)

    log_lines = [
        f"=== APPLY: {label} ===",
        f"  SQL : {sql_file}",
        f"  LOG : {log_file}",
        f"  TIME: {datetime.datetime.now().isoformat()}",
        f"  Statements parsed: {len(statements)}",
        "",
    ]

    all_errors = []
    known_errors = []

    try:
        conn = oracledb.connect(**CONN_PARAMS)
    except Exception as e:
        log_lines.append(f"[FATAL] Connection failed: {e}")
        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        print(f"  [FATAL] connection error: {e}")
        return 3

    try:
        cursor = conn.cursor()
        enable_dbms_output(cursor)

        SQLPLUS_ONLY = re.compile(
            r'^\s*(EXIT|QUIT|SET|PROMPT|REM|REMARK|WHENEVER|SPOOL|DEFINE|UNDEF|ACCEPT|SHOW|COL(UMN)?|TTITLE|BTITLE|BREAK|COMPUTE|CONNECT|DISCONNECT)\b',
            re.I,
        )
        for idx, (stmt, slash) in enumerate(statements, start=1):
            preview = stmt.replace("\n", " ")[:120]
            # statement 자체가 sqlplus 토큰만 = skip
            if SQLPLUS_ONLY.match(stmt):
                log_lines.append(f"--- Statement {idx} (sqlplus token, skip): {preview}")
                continue
            log_lines.append(f"--- Statement {idx} {'(PL/SQL block)' if slash else ''}: {preview}...")
            try:
                cursor.execute(stmt)

                # SELECT 결과 출력
                if cursor.description:
                    rows = cursor.fetchmany(200)
                    cols = [d[0] for d in cursor.description]
                    log_lines.append("  Cols: " + " | ".join(cols))
                    for r in rows:
                        log_lines.append("  Row : " + " | ".join("" if v is None else str(v)[:80] for v in r))
                    if len(rows) >= 200:
                        log_lines.append("  ... (truncated at 200 rows)")

                # DBMS_OUTPUT 추출
                outs = fetch_dbms_output(cursor)
                for o in outs:
                    log_lines.append(f"  OUT : {o}")

                log_lines.append("  [OK]")
            except oracledb.DatabaseError as e:
                err_text = str(e)
                # ORA-XXXXX 추출
                ora_codes = re.findall(r"ORA-\d{5}|PLS-\d{5}", err_text)
                all_errors.extend(ora_codes)
                known = is_known_error(err_text)
                if known:
                    known_errors.extend(ora_codes)
                    log_lines.append(f"  [WARN] known ({known}): {err_text.strip()[:300]}")
                else:
                    log_lines.append(f"  [ERR ] {err_text.strip()[:500]}")

        try:
            conn.commit()
            log_lines.append("\n[COMMIT] OK")
        except Exception as e:
            log_lines.append(f"\n[COMMIT FAIL] {e}")
    finally:
        try:
            conn.close()
        except Exception:
            pass

    # 통계
    total = len(all_errors)
    known_n = len(known_errors)
    real_n = total - known_n
    log_lines.append("")
    log_lines.append(f"=== END: {label} — total={total}, known={known_n}, real={real_n} ===")

    log_file.write_text("\n".join(log_lines), encoding="utf-8")

    if real_n > 0:
        print(f"  [ERR ] real_errors={real_n}  (known={known_n}, total={total})")
        unique = sorted(set(all_errors) - set(known_errors))
        for c in unique[:10]:
            print(f"    - {c}")
        return 2
    if known_n > 0:
        print(f"  [WARN] {known_n} known errors (logged)")
    print(f"  [OK  ] {label}")
    return 0


def main():
    if len(sys.argv) < 2:
        print("Usage: python apply.py <sql_file> [label]")
        sys.exit(1)
    sql_file = Path(sys.argv[1])
    if not sql_file.exists():
        print(f"[FAIL] file not found: {sql_file}")
        sys.exit(1)
    label = sys.argv[2] if len(sys.argv) > 2 else sql_file.stem
    rc = run(sql_file, label)
    sys.exit(rc)


if __name__ == "__main__":
    main()
