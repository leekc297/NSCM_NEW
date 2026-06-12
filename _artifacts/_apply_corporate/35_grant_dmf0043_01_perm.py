#!/usr/bin/env python3
"""DMF0043_01 권한 보강 (DMF0043 와 동일 패턴)."""
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)


def main():
    conn = oracledb.connect(**CONN_PARAMS)
    cur = conn.cursor()

    print("=== BEFORE: DMF0043_01 권한 ===")
    cur.execute(
        "SELECT USER_GR_ID, COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0043_01' GROUP BY USER_GR_ID ORDER BY USER_GR_ID"
    )
    for r in cur.fetchall():
        print(f"  {r[0]}: {r[1]}")

    print("\n=== INSERT (ADMIN/DM ADMIN/DM Viewer × DMF0043_01 sheets) ===")
    cur.execute("""
        INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
            (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT NEW.USER_GR_ID, NEW.MNU_ID, NEW.SHT_NM, NEW.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
          FROM (
            SELECT 'ADMIN' AS USER_GR_ID, G.MNU_ID, G.SHT_NM, G.MNU_BTN_CD
              FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M G WHERE G.USER_GR_ID='GUEST' AND G.MNU_ID='DMF0043_01'
            UNION ALL
            SELECT 'DM ADMIN', G.MNU_ID, G.SHT_NM, G.MNU_BTN_CD
              FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M G WHERE G.USER_GR_ID='GUEST' AND G.MNU_ID='DMF0043_01'
            UNION ALL
            SELECT 'DM Viewer', G.MNU_ID, G.SHT_NM, G.MNU_BTN_CD
              FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M G WHERE G.USER_GR_ID='GUEST' AND G.MNU_ID='DMF0043_01'
          ) NEW
         WHERE NOT EXISTS (
            SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M X
             WHERE X.USER_GR_ID=NEW.USER_GR_ID AND X.MNU_ID=NEW.MNU_ID
               AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD
         )
    """)
    print(f"  BTN_MPG inserted: {cur.rowcount}")
    conn.commit()

    cur.execute("""
        INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
            (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT NEW.USER_GR_ID, NEW.MNU_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
          FROM (
            SELECT 'ADMIN' AS USER_GR_ID, 'DMF0043_01' AS MNU_ID FROM DUAL UNION ALL
            SELECT 'DM ADMIN', 'DMF0043_01' FROM DUAL UNION ALL
            SELECT 'DM Viewer', 'DMF0043_01' FROM DUAL UNION ALL
            SELECT 'GUEST', 'DMF0043_01' FROM DUAL
          ) NEW
         WHERE NOT EXISTS (
            SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M X
             WHERE X.USER_GR_ID=NEW.USER_GR_ID AND X.MNU_ID=NEW.MNU_ID
         )
    """)
    print(f"  MNU_MPG inserted: {cur.rowcount}")
    conn.commit()

    print("\n=== AFTER: DMF0043_01 권한 ===")
    cur.execute(
        "SELECT USER_GR_ID, COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0043_01' GROUP BY USER_GR_ID ORDER BY USER_GR_ID"
    )
    for r in cur.fetchall():
        print(f"  {r[0]}: {r[1]}")
    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
