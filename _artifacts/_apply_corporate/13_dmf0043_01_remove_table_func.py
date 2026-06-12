#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST: UF_FX_STRING_SPLIT 호출 제거 → SP 안 inline 구현.

진단:
  AS-IS MSSQL: TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM STRING_SPLIT(I.OWNER, ','))
  TO-BE Oracle: TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(I.OWNER, ',')) WHERE ROWNUM <= 1)

UF_FX_STRING_SPLIT body 분석 (SCM_MGR schema):
  - PIPELINED PL/SQL function returning T_UF_FX_STRING_SPLIT_TAB
  - WHILE INSTR + TRIM + SUBSTR 반복 + PIPE ROW
  - 사용처가 첫 TOKEN 만 필요 시에도 setup + 1 iteration 비용 발생
  - 매 row SQL → PL/SQL context switch + collection allocation
  - SITE_ITEM 109K × PLAN 36K join 결과 row 마다 발생 → 수분 지연

Fix (사용자 요구 — function 사용 X, SP 안 inline 구현):
  TEAM.USER_ID = TRIM(SUBSTR(I.OWNER, 1, NVL(NULLIF(INSTR(I.OWNER, ','), 0) - 1, LENGTH(I.OWNER))))

  의미:
    - INSTR(s, ',')      → 첫 comma 위치 (없으면 0)
    - NULLIF(..., 0)     → 0 이면 NULL
    - NULLIF(...) - 1    → comma 위치 - 1 (or NULL)
    - NVL(N-1, LENGTH(s))→ comma 없으면 LENGTH (전체)
    - SUBSTR(s, 1, len)  → 첫 token 추출
    - TRIM(...)          → UF_FX_STRING_SPLIT 의 TRIM 동등성 보장

  순수 scalar built-in 만 사용. PL/SQL context switch 0. REGEXP 도 회피 (regex engine 비용 없음).

대상:
  - line 363: 메인 SELECT 의 TEAM JOIN (per-row hot spot)
  - line 579: count 서브쿼리 의 TEAM JOIN (등록 안된 건)
  - line 164: title cursor 의 DIVISION_ID 멤버십 (1회 — 별도 처리 안 함)
"""
import re
import datetime
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
BACKUP_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR.mkdir(parents=True, exist_ok=True)


def fetch_user_source(conn, name: str) -> str:
    cur = conn.cursor()
    cur.execute(
        "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
        n=name,
    )
    lines = [r[0] or "" for r in cur.fetchall()]
    cur.close()
    return "".join(lines)


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{ts}_DMF0043_01_INLINE_FIRSTTOKEN.log"
    log_lines = [
        f"=== FIX: {SP_NAME} UF_FX_STRING_SPLIT 첫 token → inline SUBSTR/INSTR ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    # DDL_LOCK_TIMEOUT: 락 충돌 시 자동 대기 (default 0 = 즉시 fail)
    # 사용자 세션이 SP 실행 중인 경우 자연 종료 대기 위해 1800s 설정
    cur0 = conn.cursor()
    cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    cur0.close()
    try:
        src = fetch_user_source(conn, SP_NAME)
        if not src:
            log_lines.append(f"[FAIL] {SP_NAME} not found")
            return 2

        backup = BACKUP_DIR / f"{SP_NAME}_table_func_before_{ts}.sql"
        backup.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log_lines.append(f"  [BACKUP] {len(src)} chars → {backup.name}")

        # Pattern: TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(<alias>.OWNER, ',')) WHERE ROWNUM <= 1)
        # Replace: TEAM.USER_ID = TRIM(SUBSTR(<alias>.OWNER, 1, NVL(NULLIF(INSTR(<alias>.OWNER, ','), 0) - 1, LENGTH(<alias>.OWNER))))
        # <alias> = I (line 363) or A (line 579)
        p = re.compile(
            r"TEAM\.USER_ID\s+IN\s*\(\s*SELECT\s+TOKEN\s+FROM\s+TABLE\(\s*UF_FX_STRING_SPLIT\(\s*([A-Za-z_]+)\.OWNER\s*,\s*','\s*\)\s*\)\s+WHERE\s+ROWNUM\s*<=\s*1\s*\)",
            re.IGNORECASE,
        )
        matches = p.findall(src)
        log_lines.append(f"  [MATCH] {len(matches)} 곳 (expected 2)")
        for tbl in matches:
            log_lines.append(f"    - {tbl}.OWNER 첫 token inline 변환")

        if len(matches) != 2:
            log_lines.append(f"  [WARN] 매치 수 {len(matches)} ≠ 2 — 적용 보류")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[WARN] 매치 수 {len(matches)} ≠ 2 — see {log_file}")
            return 3

        # Inline expression — Oracle SQL 으로 PL/SQL context switch 0
        replacement = (
            r"TEAM.USER_ID = TRIM(SUBSTR(\1.OWNER, 1, "
            r"NVL(NULLIF(INSTR(\1.OWNER, ','), 0) - 1, LENGTH(\1.OWNER))))"
        )
        patched = p.sub(replacement, src)
        log_lines.append(f"  [PATCHED] size: {len(patched)} (delta {len(patched)-len(src)})")

        cur = conn.cursor()
        try:
            cur.execute("CREATE OR REPLACE " + patched)
            conn.commit()
            log_lines.append("  [OK] CREATE OR REPLACE")
        except oracledb.DatabaseError as e:
            log_lines.append(f"  [ERR] {e}")
            cur.execute(
                "SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY SEQUENCE",
                n=SP_NAME,
            )
            for ln, pos, text in cur.fetchall():
                log_lines.append(f"    Line {ln}:{pos}  {text}")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[ERR] DDL 실패 — see {log_file}")
            return 4
        finally:
            cur.close()

        cur = conn.cursor()
        cur.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP_NAME,
        )
        row = cur.fetchone()
        cur.close()
        status = row[0] if row else "?"
        log_lines.append(f"  [STATUS] {status}")

        # EXPLAIN PLAN — TEAM join 이 hash join 으로 깔끔하게 잡히는지
        if status == "VALID":
            try:
                cur = conn.cursor()
                cur.execute("""
                    EXPLAIN PLAN FOR
                    SELECT COUNT(*)
                      FROM DM_PLN_SALES_PLAN_REPORT_C P
                           INNER JOIN SCM_MST_SITE_ITEM I
                                  ON P.DIVISION_ID=I.DIVISION_ID AND P.PROJECT_CODE=I.PROJECT_CODE
                                 AND P.SCM_SITE_ID=I.SCM_SITE_ID AND P.ITEM_ID=I.ITEM_ID
                           LEFT JOIN SCM_MST_SSO_USER_INFO U
                                  ON U.USER_ID = TRIM(SUBSTR(I.OWNER, 1,
                                       NVL(NULLIF(INSTR(I.OWNER, ','), 0) - 1, LENGTH(I.OWNER))))
                     WHERE P.DIVISION_ID='40'
                       AND P.VERSION_NO='R_S_20251126_V002_C'
                       AND P.MEASURE='SalesAmt_USD'
                """)
                cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY(NULL,NULL,'BASIC'))")
                log_lines.append(f"  [EXPLAIN PLAN]")
                for r in cur.fetchall():
                    log_lines.append(f"    {r[0]}")
                cur.close()
            except oracledb.DatabaseError as e:
                log_lines.append(f"  [WARN] EXPLAIN: {e}")

        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        if status == "VALID":
            print(f"[OK] {SP_NAME} 갱신 완료 (STATUS=VALID)")
            return 0
        print(f"[ERR] {SP_NAME} STATUS={status} — see {log_file}")
        return 5
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
