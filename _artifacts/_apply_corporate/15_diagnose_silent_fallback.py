#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST 의 silent fallback 임시 제거 → 실 ORA-* 노출.

Phase 1: USER_SOURCE 백업 + EXCEPTION block 정밀 확인
Phase 2: silent fallback OPEN ... 을 임시 RAISE 로 변경 (CREATE OR REPLACE)
Phase 3: SP 재호출 → 실 ORA-* 캡쳐
Phase 4: 원인 식별 결과 출력 (Hybrid 복원은 후속 작업)
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
BACKUP_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)


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
    backup_file = BACKUP_DIR / f"{SP_NAME}_before_silent_diag_{ts}.sql"
    log_file = LOG_DIR / f"{ts}_DMF0043_SILENT_FALLBACK_DIAG.log"
    log = []

    def add(msg):
        log.append(msg)
        print(msg)

    add(f"=== Phase 1: Backup + EXCEPTION block 확인 ===")
    add(f"  TIME: {datetime.datetime.now().isoformat()}")

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        src = fetch_user_source(conn, SP_NAME)
        if not src:
            add(f"[FAIL] {SP_NAME} not found")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 1

        backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        add(f"  Backup: {backup_file} ({len(src)} chars)")

        # EXCEPTION block 추출
        m = re.search(r'EXCEPTION\s+WHEN\s+OTHERS\s+THEN.*?END;?\s*$', src, re.I | re.S)
        if m:
            add(f"  EXCEPTION block found @{m.start()}~{m.end()}:")
            add(m.group(0)[:1500])

        add(f"\n=== Phase 2: silent fallback → RAISE 임시 변경 ===")
        # silent fallback 패턴: OPEN ... FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0
        # 또는 OPEN ... FOR SELECT NULL FROM DUAL WHERE 1=0
        fallback_pat = re.compile(
            r'OPEN\s+(\w+)\s+FOR\s+SELECT\s+NULL\s+(?:AS\s+DUMMY\s+)?FROM\s+DUAL\s+WHERE\s+1\s*=\s*0\s*;?',
            re.I,
        )
        matches = list(fallback_pat.finditer(src))
        add(f"  Silent fallback OPEN 검출: {len(matches)}건")
        for mm in matches:
            add(f"    @{mm.start()}: {mm.group(0)[:80]}")

        if not matches:
            add("[INFO] No silent fallback found — already replaced or different pattern")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 0

        # EXCEPTION 안 OPEN ... DUMMY 를 모두 RAISE 로 대체 (단 EXCEPTION 안만)
        # EXCEPTION block 위치 식별
        ex_pos = src.upper().find("EXCEPTION")
        # EXCEPTION 이후 첫 END; 까지
        if ex_pos < 0:
            add("[FAIL] EXCEPTION block not found in body")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 1

        head = src[:ex_pos]
        tail = src[ex_pos:]

        # tail 의 모든 OPEN ... FOR SELECT NULL ... DUMMY 를 RAISE 로 대체
        # 단 첫 OPEN 만 RAISE_APPLICATION_ERROR 로 변경 (나머지는 제거)
        new_tail = fallback_pat.sub(
            "RAISE_APPLICATION_ERROR(-20999, 'DIAG: '||SQLCODE||' '||SUBSTR(SQLERRM,1,200)||' / '||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,1,500));",
            tail,
            count=1,  # 첫 OPEN 만 RAISE — 나머지 제거
        )
        # 나머지 silent fallback 제거
        new_tail = fallback_pat.sub("NULL;", new_tail)

        patched = head + new_tail
        ddl = "CREATE OR REPLACE " + patched

        try:
            cursor = conn.cursor()
            cursor.execute(ddl)
            conn.commit()
            cursor.close()
            add(f"  [OK] CREATE OR REPLACE — silent fallback → RAISE")
        except oracledb.DatabaseError as e:
            add(f"  [ERR] compile: {e}")
            log_file.write_text("\n".join(log), encoding="utf-8")
            return 2

        add(f"\n=== Phase 3: SP 재호출 → 실 ORA-* 노출 ===")
        cursor = conn.cursor()
        rc_main = cursor.var(oracledb.CURSOR)
        rc_sort = cursor.var(oracledb.CURSOR)
        rc_cnt = cursor.var(oracledb.CURSOR)
        try:
            cursor.callproc(
                SP_NAME,
                ["40", "8", "R_B_20250820_V008_C", "", "", "", "N", "N", "minyonglee1",
                 rc_main, rc_sort, rc_cnt],
            )
            add("  [WARN] SP returned without RAISE — 실 에러 없음? 또는 silent block 추가 발견 필요")
        except oracledb.DatabaseError as e:
            err = str(e).strip()
            add(f"  [RAISED] {err}")

        cursor.close()

        add(f"\n=== Phase 4: 복원 (원본 silent fallback) ===")
        # 원본 SP body 복원
        try:
            cursor = conn.cursor()
            cursor.execute("CREATE OR REPLACE " + src)
            conn.commit()
            cursor.close()
            add(f"  [OK] 원본 SP body 복원 완료")
        except oracledb.DatabaseError as e:
            add(f"  [ERR] 복원 실패: {e}")
            add(f"  ⚠️ 백업 {backup_file} 를 sqlplus 로 수동 복원 필요")
            return 3
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
