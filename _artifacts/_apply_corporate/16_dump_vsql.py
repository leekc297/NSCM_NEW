#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST 의 EXCEPTION block 에 v_sql_text dump 추가.
재호출 → DBMS_OUTPUT 캡쳐 → 동적 SQL 검사 → 원본 복원.
"""
import datetime
import re
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)
SP_NAME = "DMF0043_GET_CONTRIBUTION_SALES_LIST"

BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"


def fetch_user_source(conn, name: str) -> str:
    cursor = conn.cursor()
    cursor.execute(
        "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
        n=name,
    )
    lines = [row[0] or "" for row in cursor.fetchall()]
    cursor.close()
    return "".join(lines)


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = BACKUP_DIR / f"{SP_NAME}_before_dump_{ts}.sql"
    log_file = LOG_DIR / f"{ts}_DMF0043_VSQL_DUMP.log"
    log = []
    def add(msg):
        log.append(msg)
        print(msg)

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        src = fetch_user_source(conn, SP_NAME)
        backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        add(f"Backup: {backup_file} ({len(src)} chars)")

        # 첫 OPEN p_cursor_main FOR (silent fallback 아닌 정상 OPEN) 직전에 dump 삽입
        # 또는 EXCEPTION 시작점 직후에 DBMS_OUTPUT
        # 가장 안전: 마지막 EXCEPTION (top-level) 위치 식별 후 그 안에 dump 추가

        # silent fallback 5건 중 첫 BEGIN OPEN p_cursor_main ... 부분의 EXCEPTION 시작점에 dump 추가
        # 패턴: BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
        # 이 패턴 직전이 EXCEPTION WHEN OTHERS THEN — 그 직후에 PUT_LINE 4줄 삽입

        dump_block = (
            "  DBMS_OUTPUT.PUT_LINE('[DUMP] SQLERRM='||SUBSTR(SQLERRM,1,200));\n"
            "  DBMS_OUTPUT.PUT_LINE('[DUMP] BACKTRACE='||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,1,1000));\n"
            "  DBMS_OUTPUT.PUT_LINE('[DUMP] STACK='||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000));\n"
            "  DBMS_OUTPUT.PUT_LINE('[DUMP] v_sql_text len='||NVL(TO_CHAR(LENGTH(v_sql_text)),'NULL'));\n"
            "  DBMS_OUTPUT.PUT_LINE('[DUMP] SQL_H1: '||SUBSTR(NVL(v_sql_text,'<NULL>'),1,3500));\n"
            "  DBMS_OUTPUT.PUT_LINE('[DUMP] SQL_H2: '||SUBSTR(NVL(v_sql_text,'<NULL>'),3501,3500));\n"
            "  DBMS_OUTPUT.PUT_LINE('[DUMP] SQL_H3: '||SUBSTR(NVL(v_sql_text,'<NULL>'),7001,3500));\n"
            "  DBMS_OUTPUT.PUT_LINE('[DUMP] SQL_TAIL: '||SUBSTR(NVL(v_sql_text,'<NULL>'),GREATEST(1,LENGTH(NVL(v_sql_text,''))-2000),2000));\n"
        )

        # EXCEPTION WHEN OTHERS THEN 의 모든 발생 위치 검색
        ex_positions = [(m.start(), m.end()) for m in re.finditer(r'EXCEPTION\s+WHEN\s+OTHERS\s+THEN', src, re.I)]
        add(f"EXCEPTION WHEN OTHERS THEN 발생 위치: {len(ex_positions)}건")
        for s, e in ex_positions:
            add(f"  @{s}: ...{src[max(0,s-50):e]}...")

        # 첫 EXCEPTION (가장 outer) 의 직후에 dump 삽입
        if not ex_positions:
            add("[FAIL] EXCEPTION 없음")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 1

        # silent fallback 의 EXCEPTION 들 (nested) 보다 outer 의 EXCEPTION 찾기
        # 가장 첫번째 EXCEPTION 이 outermost (line 기준 가장 위)
        # 단, EXCEPTION ... END BEGIN ... 보다 outer 인것

        # 단순 접근: 첫 EXCEPTION (가장 위) 의 직후에 dump 추가
        # 단 nested EXCEPTION (BEGIN ... END 안) 이라면 outer 가 더 위에 있을 것

        # inner EXCEPTION (OPEN p_cursor_main FOR v_sql_text 의 EXCEPTION WHEN OTHERS THEN) 직후에 dump
        # 패턴: OPEN p_cursor_main FOR v_sql_text; ... EXCEPTION WHEN OTHERS THEN <여기에 dump>
        inner_pat = re.compile(
            r'(OPEN\s+p_cursor_main\s+FOR\s+v_sql_text\s*;.*?EXCEPTION\s+WHEN\s+OTHERS\s+THEN)',
            re.I | re.S,
        )
        m_inner = inner_pat.search(src)
        if not m_inner:
            add("[FAIL] inner EXCEPTION (OPEN p_cursor_main FOR v_sql_text) 못 찾음")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 1
        inner_ex_end = m_inner.end()
        add(f"[FOUND] inner EXCEPTION (p_cursor_main) end @{inner_ex_end}")
        patched = src[:inner_ex_end] + "\n" + dump_block + src[inner_ex_end:]
        ddl = "CREATE OR REPLACE " + patched

        try:
            cursor = conn.cursor()
            cursor.execute(ddl)
            conn.commit()
            cursor.close()
            add("[OK] CREATE OR REPLACE (dump 삽입)")
        except oracledb.DatabaseError as e:
            add(f"[ERR] compile: {e}")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 2

        add(f"\n=== SP 재호출 + DBMS_OUTPUT 캡쳐 ===")
        cursor = conn.cursor()
        cursor.callproc("DBMS_OUTPUT.ENABLE", [None])
        rc_main = cursor.var(oracledb.CURSOR)
        rc_sort = cursor.var(oracledb.CURSOR)
        rc_cnt = cursor.var(oracledb.CURSOR)
        try:
            cursor.callproc(
                SP_NAME,
                ["40", "8", "R_B_20250820_V008_C", "", "", "", "N", "N", "minyonglee1",
                 rc_main, rc_sort, rc_cnt],
            )
            add("[OK] SP 호출 완료 (예외 안 던짐)")
        except oracledb.DatabaseError as e:
            add(f"[ERR] callproc: {e}")

        # DBMS_OUTPUT 캡쳐
        line_var = cursor.var(str)
        status_var = cursor.var(int)
        captured = []
        while True:
            cursor.callproc("DBMS_OUTPUT.GET_LINE", [line_var, status_var])
            if status_var.getvalue() != 0:
                break
            v = line_var.getvalue()
            if v is not None:
                captured.append(v)

        add(f"\n--- DBMS_OUTPUT 캡쳐 ({len(captured)} lines) ---")
        for ln in captured:
            add(ln)

        cursor.close()

        add(f"\n=== 원본 복원 ===")
        cursor = conn.cursor()
        try:
            cursor.execute("CREATE OR REPLACE " + src)
            conn.commit()
            add("[OK] 원본 복원")
        except oracledb.DatabaseError as e:
            add(f"[ERR] 복원 실패: {e}")
            add(f"⚠️ 백업 {backup_file} 수동 복원 필요")
        cursor.close()
    finally:
        log_file.write_text("\n".join(log), encoding="utf-8")
        try:
            conn.close()
        except Exception:
            pass

    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
