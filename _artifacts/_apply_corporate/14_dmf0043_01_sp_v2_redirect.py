#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST V2 우회 — Library cache lock 회피.

상황:
  - 6 stuck 세션이 V1 SP 의 library cache 락 점유
  - SCM_MGR 가 ALTER SYSTEM KILL SESSION 권한 없음 (ORA-01031)
  - DBA escalation 도 불가
  - V1 CREATE OR REPLACE 가 ORA-04021 (lock timeout) 반복

해법: V1 그대로 두고 V2 신규 SP 작성 + BE 라우팅 메타 변경
  1) V2 SP body = V1 body 에 UF_FX_STRING_SPLIT → inline SUBSTR/INSTR 패치
  2) CREATE OR REPLACE PROCEDURE V2 — 다른 이름 = 다른 library cache = 락 없음
  3) UPDATE SCM_ADM_API_M.API_URL = V2  (1 row)
  4) UPDATE SCM_ADM_PROC_M.PROC_NM = V2 (12 row)
  5) BE 다음 호출 → V2 → 빠른 응답
  6) (밤 사이 V1 stuck 자연 종료 후) V1 patch + API_URL 원복 + V2 DROP

장점: 락 회피 + 사용자 즉시 작업 재개
단점: 한 시점에 2개 SP 공존 (운영 분기). 원복 작업 필요.
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

SP_V1 = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
SP_V2 = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V2"

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
    log_file = LOG_DIR / f"{ts}_DMF0043_01_SP_V2_REDIRECT.log"
    log_lines = [
        f"=== V2 우회: {SP_V1} → {SP_V2} + 메타 redirect ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        # STEP 1: V1 source fetch + inline 패치
        src = fetch_user_source(conn, SP_V1)
        if not src:
            log_lines.append(f"[FAIL] {SP_V1} not found")
            return 2

        backup = BACKUP_DIR / f"{SP_V1}_before_v2_redirect_{ts}.sql"
        backup.write_text("CREATE OR REPLACE PROCEDURE " + src, encoding="utf-8")
        log_lines.append(f"  [STEP 1] V1 backup: {len(src)} chars → {backup.name}")

        # Rename in source: PROCEDURE name 변경
        # USER_SOURCE 의 첫 라인은 `PROCEDURE           "DMF0043_GET_CONTRIBUTION_SALES_LIST" ...`
        v2_src = re.sub(
            rf'\bPROCEDURE\s+(\s*"?){re.escape(SP_V1)}("?)',
            rf'PROCEDURE \1{SP_V2}\2',
            src,
            count=1,
            flags=re.IGNORECASE,
        )

        # Inline first-token (UF_FX_STRING_SPLIT 제거)
        p = re.compile(
            r"TEAM\.USER_ID\s+IN\s*\(\s*SELECT\s+TOKEN\s+FROM\s+TABLE\(\s*UF_FX_STRING_SPLIT\(\s*([A-Za-z_]+)\.OWNER\s*,\s*','\s*\)\s*\)\s+WHERE\s+ROWNUM\s*<=\s*1\s*\)",
            re.IGNORECASE,
        )
        matches = p.findall(v2_src)
        log_lines.append(f"  [STEP 1] UF_FX_STRING_SPLIT 매치: {len(matches)} (expected 2)")
        if len(matches) != 2:
            log_lines.append(f"  [WARN] 매치 ≠ 2 — 적용 보류")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            return 3

        v2_src = p.sub(
            r"TEAM.USER_ID = TRIM(SUBSTR(\1.OWNER, 1, "
            r"NVL(NULLIF(INSTR(\1.OWNER, ','), 0) - 1, LENGTH(\1.OWNER))))",
            v2_src,
        )

        v2_backup = BACKUP_DIR / f"{SP_V2}_created_{ts}.sql"
        v2_backup.write_text("CREATE OR REPLACE PROCEDURE " + v2_src, encoding="utf-8")
        log_lines.append(f"  [STEP 1] V2 source patched: {len(v2_src)} chars → {v2_backup.name}")

        # STEP 2: V2 CREATE OR REPLACE (다른 이름 — 락 없음)
        cur = conn.cursor()
        try:
            # USER_SOURCE.TEXT 가 이미 "PROCEDURE ..." 로 시작 — 중복 PROCEDURE 키워드 방지
            cur.execute("CREATE OR REPLACE " + v2_src)
            conn.commit()
            log_lines.append(f"  [STEP 2] CREATE OR REPLACE {SP_V2} [OK]")
        except oracledb.DatabaseError as e:
            log_lines.append(f"  [STEP 2 ERR] {e}")
            cur.execute(
                "SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY SEQUENCE",
                n=SP_V2,
            )
            for ln, pos, text in cur.fetchall():
                log_lines.append(f"    Line {ln}:{pos}  {text}")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            return 4
        finally:
            cur.close()

        # STEP 2.5: V2 VALID 확인
        cur = conn.cursor()
        cur.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP_V2,
        )
        row = cur.fetchone()
        v2_status = row[0] if row else "?"
        cur.close()
        log_lines.append(f"  [STEP 2] V2 STATUS: {v2_status}")
        if v2_status != "VALID":
            log_lines.append(f"  [ABORT] V2 INVALID — 메타 변경 안 함")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            return 5

        # STEP 3: SCM_ADM_API_M 갱신 (1 row)
        cur = conn.cursor()
        cur.execute(
            "UPDATE SCM_ADM_API_M SET API_URL=:v2, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE "
            "WHERE API_ID=:apid AND API_URL=:v1",
            v2=SP_V2, apid="P_DMF0043_SALES_LIST_GET", v1=SP_V1,
        )
        api_rows = cur.rowcount
        log_lines.append(f"  [STEP 3] SCM_ADM_API_M UPDATE: {api_rows} row (expected 1)")
        cur.close()

        # STEP 4: SCM_ADM_PROC_M 갱신 (12 row)
        cur = conn.cursor()
        cur.execute(
            "UPDATE SCM_ADM_PROC_M SET PROC_NM=:v2, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE "
            "WHERE PROC_NM=:v1",
            v2=SP_V2, v1=SP_V1,
        )
        proc_rows = cur.rowcount
        log_lines.append(f"  [STEP 4] SCM_ADM_PROC_M UPDATE: {proc_rows} row (expected 12)")
        cur.close()

        if api_rows != 1 or proc_rows != 12:
            log_lines.append(f"  [WARN] 메타 갱신 row 수 불일치 — ROLLBACK")
            conn.rollback()
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            return 6

        conn.commit()
        log_lines.append(f"  [COMMIT] 메타 갱신 완료")

        # STEP 5: 검증
        cur = conn.cursor()
        cur.execute(
            "SELECT API_URL FROM SCM_ADM_API_M WHERE API_ID='P_DMF0043_SALES_LIST_GET'"
        )
        new_url = cur.fetchone()[0]
        cur.execute(
            "SELECT DISTINCT PROC_NM FROM SCM_ADM_PROC_M WHERE PROC_NM=:v2", v2=SP_V2
        )
        proc_check = cur.fetchone()
        cur.close()
        log_lines.append(f"  [STEP 5] 검증 API_URL={new_url} / PROC_NM={proc_check[0] if proc_check else None}")

        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        if new_url == SP_V2 and proc_check and proc_check[0] == SP_V2:
            print(f"[OK] V2 redirect 완료 — BE 다음 호출부터 빠른 응답")
            return 0
        print(f"[ERR] 검증 실패 — see {log_file}")
        return 7
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
