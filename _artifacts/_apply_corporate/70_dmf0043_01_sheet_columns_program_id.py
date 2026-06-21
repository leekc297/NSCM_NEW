#!/usr/bin/env python3
"""
DMF0043_01 SHEET_COLUMNS PROGRAM_ID 정합화
  - 현재: PROGRAM_ID='DMF0043' + SHEET_NAME='ContributeSalesList' (10 row, BASE 9 + EDIT_FLAG)
  - 변경: PROGRAM_ID='DMF0043_01' 로 UPDATE
  - DMF0043 master 는 ContributeSalesList 미사용 (FE grep 결과 0 hit) → 안전

배경:
  사용자 보고 (2026-06-19) — admin UI Category Setup 에서 VISIBLE_FLAG 설정해도 DMF0043_01 grid 반영 안 됨.
  Root cause: SHEET_COLUMNS 가 PROGRAM_ID='DMF0043' 등록 → DMF0002_GET_TITLESET_POPUP(P_PROGRAM_ID='DMF0043_01') 호출 시 0 row →
  ColumnSettingModal fallback 사용 → admin 메타 변경 무시.
  DMF0043_01 화면이 admin SHEET_COLUMNS 의 VISIBLE/WIDTH/ALIGN 등 동적 반영 받으려면 PROGRAM_ID='DMF0043_01' 등록 필수.
"""
import datetime
from pathlib import Path
import oracledb

CONN = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn="121.162.245.167:2521/OCGSCMD_P01",
)

LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== DMF0043_01 SHEET_COLUMNS PROGRAM_ID 정합화 ({ts}) ==="]

    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    try:
        # PRE-CHECK — 기존 DMF0043_01 의 ContributeSalesList row 존재 여부 (중복 방지)
        cur.execute(
            "SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043_01' AND SHEET_NAME='ContributeSalesList'"
        )
        existing = cur.fetchone()[0]
        log.append(f"  [PRE] DMF0043_01/ContributeSalesList 기존 row: {existing}")
        if existing > 0:
            log.append("  [SKIP] DMF0043_01 이미 등록 — UPDATE 안 함")
            (LOG_DIR / f"{ts}_DMF0043_01_SHEET_COLUMNS_PROGRAM_ID.log").write_text("\n".join(log), encoding="utf-8")
            return 0

        # DMF0043 의 ContributeSalesList row 인벤토리 (UPDATE 대상)
        cur.execute(
            "SELECT SORT_ORDER_NO, COLUMN_NAME, VISIBLE_FLAG FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='ContributeSalesList' ORDER BY SORT_ORDER_NO"
        )
        rows = cur.fetchall()
        log.append(f"  [SOURCE] DMF0043/ContributeSalesList row: {len(rows)} (expected 10)")
        for r in rows:
            log.append(f"    SORT={r[0]:>3}  COL={r[1]:<24}  VIS={r[2]}")

        if len(rows) == 0:
            log.append("  [FAIL] DMF0043 source 0 row — UPDATE 안 함")
            (LOG_DIR / f"{ts}_DMF0043_01_SHEET_COLUMNS_PROGRAM_ID.log").write_text("\n".join(log), encoding="utf-8")
            return 2

        # UPDATE — PROGRAM_ID 변경
        cur.execute(
            "UPDATE SCM_MST_SHEET_COLUMNS SET PROGRAM_ID='DMF0043_01', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='ContributeSalesList'"
        )
        updated = cur.rowcount
        conn.commit()
        log.append(f"  [UPDATE] rowcount: {updated}")

        # POST-CHECK
        cur.execute(
            "SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043_01' AND SHEET_NAME='ContributeSalesList'"
        )
        post = cur.fetchone()[0]
        log.append(f"  [POST] DMF0043_01/ContributeSalesList row: {post}")

        cur.execute(
            "SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='ContributeSalesList'"
        )
        post_old = cur.fetchone()[0]
        log.append(f"  [POST] DMF0043/ContributeSalesList row (잔존): {post_old}")

        log.append("  [DONE] UPDATE 완료")
        print("[OK] 완료")
    finally:
        log_file = LOG_DIR / f"{ts}_DMF0043_01_SHEET_COLUMNS_PROGRAM_ID.log"
        log_file.write_text("\n".join(log), encoding="utf-8")
        print(f"log: {log_file}")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
