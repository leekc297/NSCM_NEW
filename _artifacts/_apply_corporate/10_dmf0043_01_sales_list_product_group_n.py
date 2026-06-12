#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST (DMF0043_01 화면): 하드코딩 '' AS PRODUCT_GROUP → 'N'.

배경:
  - DMF0043 메인 grid SP (DMF0043_GET_CONTRIBUTE_MAIN_DATA) 와 동일한 패턴 사고
  - SCM_MST_SITE_ITEM.REPORT_GROUP3 사내 schema 제거 → '' 하드코딩 fallback
  - DM_MST_CONTRIBUTE_RATIO_DTL.PRODUCT_GROUP 는 actual values ('원통형','파우치형','각형','초소형','버튼','N')
  - INNER JOIN A.PRODUCT_GROUP = B.PRODUCT_GROUP 실패 → 화면 데이터 0

대상:
  DMF0043_GET_CONTRIBUTION_SALES_LIST 의 2 곳 (모두 native SQL, escape 불요)
    line 334 : INSERT INTO GT_DMF0043_SALES_LIST_C 의 '' AS PRODUCT_GROUP
    line 561 : 등록 안 된 건 count subquery 의 '' AS PRODUCT_GROUP
  공통 마커: --[Round3 patch] REPORT_GROUP3 제거로 빈값
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
    log_file = LOG_DIR / f"{ts}_DMF0043_01_SALES_LIST_PG_N.log"
    log_lines = [
        f"=== FIX: {SP_NAME} '' AS PRODUCT_GROUP → 'N' (Option A) ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    try:
        src = fetch_user_source(conn, SP_NAME)
        if not src:
            log_lines.append(f"[FAIL] {SP_NAME} not found")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            return 2

        backup = BACKUP_DIR / f"{SP_NAME}_pg_empty_before_{ts}.sql"
        backup.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log_lines.append(f"  [BACKUP] {len(src)} chars → {backup.name}")

        # Pattern: '' AS PRODUCT_GROUP --[Round3 patch] REPORT_GROUP3 제거로 빈값
        # 모두 native SQL — escape 불요. '' → 'N'
        p = re.compile(
            r"''(\s+AS PRODUCT_GROUP --\[Round3 patch\] REPORT_GROUP3 제거로 빈값)"
        )
        matches = p.findall(src)
        patched = p.sub(r"'N'\1", src)
        log_lines.append(f"  [P1 SALES_LIST AS]  매치: {len(matches)} (expected 2)")
        log_lines.append(f"  [PATCHED] size: {len(patched)} (delta {len(patched)-len(src)})")

        if len(matches) != 2:
            log_lines.append("  [WARN] 매치 ≠ 2 — 적용 보류")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[WARN] 매치 {len(matches)} ≠ 2 — see {log_file}")
            return 3

        if patched == src:
            log_lines.append("  [SKIP] 차이 없음 (이미 fix 됐을 수 있음)")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print("[SKIP] 차이 없음")
            return 0

        cursor = conn.cursor()
        try:
            cursor.execute("CREATE OR REPLACE " + patched)
            conn.commit()
            log_lines.append("  [OK] CREATE OR REPLACE")
        except oracledb.DatabaseError as e:
            log_lines.append(f"  [ERR] {e}")
            cursor.execute(
                "SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY SEQUENCE",
                n=SP_NAME,
            )
            for line, pos, text in cursor.fetchall():
                log_lines.append(f"    Line {line}:{pos}  {text}")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[ERR] DDL 실패 — see {log_file}")
            return 4
        finally:
            cursor.close()

        cursor = conn.cursor()
        cursor.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP_NAME,
        )
        status_row = cursor.fetchone()
        cursor.close()
        status = status_row[0] if status_row else "?"
        log_lines.append(f"  [STATUS] {status}")
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
