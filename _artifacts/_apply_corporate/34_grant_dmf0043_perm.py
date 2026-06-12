#!/usr/bin/env python3
"""
DMF0043 권한 보강: ADMIN/DM ADMIN/DM Viewer 3 그룹 × 10 sheet 권한 INSERT (NOT EXISTS 멱등).
GUEST 의 10 row 패턴 그대로 3 그룹 복제 → 총 30 row 신규.

DMF0008 패턴과 동등 (4 그룹 모두 권한).
"""
import datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)

LOG_DIR = Path(__file__).parent / "_logs"


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{ts}_DMF0043_GRANT_PERM.log"
    log = []
    def add(m):
        log.append(m); print(m)

    conn = oracledb.connect(**CONN_PARAMS)
    cur = conn.cursor()

    add("=== Phase 1: BEFORE state ===")
    cur.execute(
        "SELECT USER_GR_ID, COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0043' GROUP BY USER_GR_ID ORDER BY USER_GR_ID"
    )
    for r in cur.fetchall():
        add(f"  {r[0]}: {r[1]} rows")

    add("\n=== Phase 2: INSERT 30 rows (ADMIN/DM ADMIN/DM Viewer × 10 sheet) ===")
    # GUEST 의 row 가져와서 3 그룹으로 복제
    cur.execute("""
        INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
            (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT NEW.USER_GR_ID, NEW.MNU_ID, NEW.SHT_NM, NEW.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
          FROM (
            SELECT 'ADMIN' AS USER_GR_ID, G.MNU_ID, G.SHT_NM, G.MNU_BTN_CD
              FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M G
             WHERE G.USER_GR_ID='GUEST' AND G.MNU_ID='DMF0043'
            UNION ALL
            SELECT 'DM ADMIN', G.MNU_ID, G.SHT_NM, G.MNU_BTN_CD
              FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M G
             WHERE G.USER_GR_ID='GUEST' AND G.MNU_ID='DMF0043'
            UNION ALL
            SELECT 'DM Viewer', G.MNU_ID, G.SHT_NM, G.MNU_BTN_CD
              FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M G
             WHERE G.USER_GR_ID='GUEST' AND G.MNU_ID='DMF0043'
          ) NEW
         WHERE NOT EXISTS (
            SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M X
             WHERE X.USER_GR_ID=NEW.USER_GR_ID AND X.MNU_ID=NEW.MNU_ID
               AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD
         )
    """)
    inserted = cur.rowcount
    conn.commit()
    add(f"  Inserted: {inserted} rows")

    add("\n=== Phase 3: AFTER state ===")
    cur.execute(
        "SELECT USER_GR_ID, COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0043' GROUP BY USER_GR_ID ORDER BY USER_GR_ID"
    )
    for r in cur.fetchall():
        add(f"  {r[0]}: {r[1]} rows")

    # USER_GR_MNU_MPG_M 도 동일 패턴 — 메뉴 자체 권한
    add("\n=== Phase 4: SCM_ADM_USER_GR_MNU_MPG_M check ===")
    cur.execute(
        "SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0043' ORDER BY USER_GR_ID"
    )
    rows = cur.fetchall()
    add(f"  메뉴 자체 권한 그룹: {[r[0] for r in rows]}")

    # DM Viewer 의 메뉴 권한 추가 (있다면)
    cur.execute("""
        INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
            (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT NEW.USER_GR_ID, NEW.MNU_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
          FROM (
            SELECT 'DM Viewer' AS USER_GR_ID, 'DMF0043' AS MNU_ID FROM DUAL
            UNION ALL
            SELECT 'GUEST', 'DMF0043' FROM DUAL
          ) NEW
         WHERE NOT EXISTS (
            SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M X
             WHERE X.USER_GR_ID=NEW.USER_GR_ID AND X.MNU_ID=NEW.MNU_ID
         )
    """)
    add(f"  메뉴 권한 추가: {cur.rowcount} rows")
    conn.commit()

    cur.close()
    conn.close()
    log_file.write_text("\n".join(log), encoding="utf-8")


if __name__ == "__main__":
    main()
