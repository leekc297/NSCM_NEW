#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST: cursor 이름 표준화
  p_cursor_main → O_RC1 / p_cursor_sort → O_RC2 / p_cursor_cnt → O_RC3

배경:
  사용자 결정 (2026-06-19) — NSCM 단일 cursor 표준 'o_rc1' 정합. 분리 PR.
  현재 DMF0043_GET_CONTRIBUTION_SALES_LIST (DMF0043_01 main SP) 의 3 OUT cursor
  parameter 이름이 비표준 (p_cursor_*). 같은 SP block (`010_DMF0043_main_SP_bodies.sql`
  L2180~) 의 다른 SP 들은 이미 O_RC1 표준. 본 SP 만 정합.

변경 범위:
  - SP body 3 parameter declaration (L65~67 deploy_package 050 기준)
  - SP body 다수 OPEN/EXCEPTION/ISOPEN 참조 (총 12 hits)
  - PROC_M 메타 (SCM_MGR.SCM_ADM_PROC_M) 3 row — DELETE 후 INSERT
  - FE constants (별도 — git commit 으로 이관)

절차:
  1) BACKUP — USER_SOURCE → _diagnostics/{SP_NAME}_cursor_before_{ts}.sql
  2) PROC_M — 기존 p_cursor_* row DELETE + 신규 o_rc1/o_rc2/o_rc3 INSERT
  3) SP body — USER_SOURCE 읽어 regex rename → CREATE OR REPLACE
  4) VERIFY — USER_OBJECTS STATUS VALID + PROC_M row 정합 + 호출 sanity

Reference: 13_dmf0043_01_remove_table_func.py (동일 패턴)
"""
import re
import datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    # 2026-06-17 변경: SID `ESSCMD` → SERVICE_NAME `OCGSCMD_P01` (EZCONNECT slash form)
    dsn="121.162.245.167:2521/OCGSCMD_P01",
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
    log_file = LOG_DIR / f"{ts}_DMF0043_01_CURSOR_STANDARDIZE.log"
    log_lines = [
        f"=== FIX: {SP_NAME} cursor 표준화 (p_cursor_* → O_RC1/2/3) ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    cur0 = conn.cursor()
    cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    cur0.close()
    try:
        # === Phase 1: BACKUP =====================================
        src = fetch_user_source(conn, SP_NAME)
        if not src:
            log_lines.append(f"[FAIL] {SP_NAME} not found")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[FAIL] SP not found — see {log_file}")
            return 2

        backup = BACKUP_DIR / f"{SP_NAME}_cursor_before_{ts}.sql"
        backup.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log_lines.append(f"  [BACKUP] {len(src)} chars → {backup.name}")

        # === Phase 2: SP body patch =============================
        # 단순 word-level 치환 — p_cursor_main/sort/cnt 가 SP body 안 cursor 이름으로만 사용
        # (다른 의미로 사용 안 됨 — declaration + OPEN/EXCEPTION/ISOPEN).
        # IGNORECASE 로 case-insensitive 매칭.
        before_hits = (
            len(re.findall(r"\bp_cursor_main\b", src, re.IGNORECASE))
            + len(re.findall(r"\bp_cursor_sort\b", src, re.IGNORECASE))
            + len(re.findall(r"\bp_cursor_cnt\b", src, re.IGNORECASE))
        )
        log_lines.append(f"  [SCAN] p_cursor_* total hits: {before_hits} (expected ≥ 12)")

        if before_hits < 9:
            log_lines.append(f"  [WARN] hits {before_hits} < 9 — SP 이미 표준화 또는 다른 변환")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[WARN] hits 부족 — see {log_file}")
            return 3

        patched = re.sub(r"\bp_cursor_main\b", "O_RC1", src, flags=re.IGNORECASE)
        patched = re.sub(r"\bp_cursor_sort\b", "O_RC2", patched, flags=re.IGNORECASE)
        patched = re.sub(r"\bp_cursor_cnt\b", "O_RC3", patched, flags=re.IGNORECASE)

        after_hits = (
            len(re.findall(r"\bp_cursor_main\b", patched, re.IGNORECASE))
            + len(re.findall(r"\bp_cursor_sort\b", patched, re.IGNORECASE))
            + len(re.findall(r"\bp_cursor_cnt\b", patched, re.IGNORECASE))
        )
        log_lines.append(f"  [PATCHED] size: {len(patched)} (delta {len(patched)-len(src)})")
        log_lines.append(f"  [VERIFY-INTERNAL] p_cursor_* 잔존: {after_hits} (expected 0)")
        if after_hits != 0:
            log_lines.append("  [FAIL] 잔존 hit 존재 — DDL 미실행 + 백업 보존")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[FAIL] 잔존 hit — see {log_file}")
            return 4

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
            return 5
        finally:
            cur.close()

        # === Phase 3: STATUS 검증 =================================
        cur = conn.cursor()
        cur.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP_NAME,
        )
        row = cur.fetchone()
        cur.close()
        status = row[0] if row else "?"
        log_lines.append(f"  [STATUS] {status}")
        if status != "VALID":
            log_lines.append("  [WARN] STATUS != VALID — PROC_M 재등록 보류")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            print(f"[WARN] STATUS={status} — see {log_file}")
            return 6

        # === Phase 4: PROC_M 메타 재등록 ==========================
        cur = conn.cursor()
        cur.execute(
            "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:n AND COL_NM IN ('p_cursor_main','p_cursor_sort','p_cursor_cnt')",
            n=SP_NAME,
        )
        old_cnt = cur.fetchone()[0]
        log_lines.append(f"  [PROC_M] 기존 p_cursor_* row: {old_cnt} (expected 3)")

        cur.execute(
            "DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:n AND COL_NM IN ('p_cursor_main','p_cursor_sort','p_cursor_cnt')",
            n=SP_NAME,
        )
        deleted = cur.rowcount
        log_lines.append(f"  [PROC_M] DELETE rowcount: {deleted}")

        # 기존 o_rc1/o_rc2/o_rc3 row 존재 여부 (멱등)
        cur.execute(
            "SELECT COL_NM FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:n AND COL_NM IN ('o_rc1','o_rc2','o_rc3') ORDER BY SORT_ORD",
            n=SP_NAME,
        )
        existing = {r[0] for r in cur.fetchall()}
        log_lines.append(f"  [PROC_M] 기존 o_rc* row: {sorted(existing)}")

        target = [("o_rc1", 10), ("o_rc2", 11), ("o_rc3", 12)]
        for col, sort_ord in target:
            if col in existing:
                continue
            cur.execute(
                "INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD) VALUES (:n, :c, 'CURSOR', 'OUT', :s)",
                n=SP_NAME, c=col, s=sort_ord,
            )
        conn.commit()
        log_lines.append("  [PROC_M] OK — DELETE + INSERT committed")
        cur.close()

        # === Phase 5: 최종 정합 확인 =============================
        cur = conn.cursor()
        cur.execute(
            "SELECT COL_NM, COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:n ORDER BY SORT_ORD",
            n=SP_NAME,
        )
        log_lines.append("  [PROC_M FINAL]")
        for col, tp, sort_ord in cur.fetchall():
            log_lines.append(f"    {sort_ord:>3}  {col:<24}  {tp}")
        cur.close()

        log_lines.append(f"  [DONE] {SP_NAME} cursor 표준화 완료")
        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        print(f"[OK] 완료 — see {log_file}")
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    raise SystemExit(main())
