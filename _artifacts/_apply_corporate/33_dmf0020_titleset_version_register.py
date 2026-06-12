#!/usr/bin/env python3
"""
DMF0020 의 titleSet (Grid Column 설정) + version (SP Version) popup 메타 신규 등록.

진단: FE 가 sheetName='titleSet' / 'version' 으로 호출 → BE 메타 미등록 → 권한없음.

Fix (4 테이블 일괄):
  1) SCM_ADM_API_M — 2 row
  2) SCM_ADM_PROC_M — 7 + 9 = 16 row
  3) SCM_ADM_MNU_BTN_MPG_M — 2 row (sht_nm titleSet, version)
  4) SCM_ADM_USER_GR_MNU_BTN_MPG_M — minyonglee1 의 모든 USER_GR 에 권한 부여

SP 매핑:
  titleSet (FE 4 filter) → DMF0002_GET_TITLESET_POPUP (7 args: program, sheet, type, user, division, menu, cursor)
  version  (FE 6 filter) → DMF0073_GET_VERSION_SALESPRICE (9 args: start, end, createdBy, division, type, desc, user, menu, cursor)
"""
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))


def main():
    conn = oracledb.connect(**CONN)
    try:
        cur = conn.cursor()

        # 1) API_M
        items = [
            ('DMF0020_titleSet_SEARCH', 'PROC_SELECT', 'MSG_API_DMF0020_TITLESET_SEARCH', 'DMF0002_GET_TITLESET_POPUP'),
            ('DMF0020_version_SEARCH',  'PROC_SELECT', 'MSG_API_DMF0020_VERSION_SEARCH',  'DMF0073_GET_VERSION_SALESPRICE'),
        ]
        for api_id, tp, msg_id, url in items:
            cur.execute("""MERGE INTO SCM_ADM_API_M t USING (SELECT :i API_ID FROM DUAL) s ON (t.API_ID=s.API_ID)
                WHEN MATCHED THEN UPDATE SET API_URL=:u, API_TP_CD=:t, API_MSG_ID=:m, USE_YN='Y', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                WHEN NOT MATCHED THEN INSERT (API_ID, API_TP_CD, API_MSG_ID, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                VALUES (:i, :t, :m, :u, 'Y', 'admin', SYSDATE, 'admin', SYSDATE)""",
                i=api_id, t=tp, m=msg_id, u=url)
        print(f"[1] API_M MERGE: {len(items)} items")

        # 2) PROC_M
        proc_rows = {
            'DMF0002_GET_TITLESET_POPUP': [
                ('programId',       'IN',  'VARCHAR',     1),
                ('sheetName',       'IN',  'VARCHAR',     2),
                ('columnType',      'IN',  'VARCHAR',     3),
                ('sesUserId',       'IN',  'VARCHAR',     4),
                ('divisionId',      'IN',  'VARCHAR',     5),
                ('mnuId',           'IN',  'VARCHAR',     6),
                ('O_RESULT_CURSOR', 'OUT', 'PROC_RESULT', 7),
            ],
            'DMF0073_GET_VERSION_SALESPRICE': [
                ('startYyyymmdd',   'IN',  'VARCHAR',     1),
                ('endYyyymmdd',     'IN',  'VARCHAR',     2),
                ('createdBy',       'IN',  'VARCHAR',     3),
                ('divisionId',      'IN',  'VARCHAR',     4),
                ('versionType',     'IN',  'VARCHAR',     5),
                ('description',     'IN',  'VARCHAR',     6),
                ('sesUserId',       'IN',  'VARCHAR',     7),
                ('mnuId',           'IN',  'VARCHAR',     8),
                ('o_rc1',           'OUT', 'CURSOR',      9),
            ],
        }
        for proc_nm, rows in proc_rows.items():
            cur.execute("DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM=:p", p=proc_nm)
            for c, t, d, s in rows:
                cur.execute("""INSERT INTO SCM_ADM_PROC_M
                    (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                    VALUES (:p, :c, :d, :t, :s, 'admin', SYSDATE, 'admin', SYSDATE)""",
                    p=proc_nm, c=c, t=t, d=d, s=s)
            print(f"[2] PROC_M {proc_nm}: {len(rows)} row")

        # 3) MNU_BTN_MPG_M (DMF0020 + titleSet/version + SEARCH)
        for sht in ['titleSet', 'version']:
            cur.execute("""MERGE INTO SCM_ADM_MNU_BTN_MPG_M t
                USING (SELECT 'DMF0020' MNU_ID, :s SHT_NM, 'SEARCH' MNU_BTN_CD FROM DUAL) s
                ON (t.MNU_ID=s.MNU_ID AND t.SHT_NM=s.SHT_NM AND t.MNU_BTN_CD=s.MNU_BTN_CD)
                WHEN NOT MATCHED THEN INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                VALUES ('DMF0020', :s, 'SEARCH', 'DMF0020_'||:s||'_SEARCH', 'Y', 'admin', SYSDATE, 'admin', SYSDATE)""",
                s=sht)
        print(f"[3] MNU_BTN_MPG_M MERGE: 2 row")

        # 4) USER_GR_MNU_BTN_MPG_M (모든 user_gr — minyonglee1 의 모든 그룹)
        cur.execute("""SELECT DISTINCT u.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M u WHERE u.USER_ID='minyonglee1'""")
        groups = [r[0] for r in cur.fetchall()]
        # 모든 user_gr 에 권한 부여 — 더 광범위하게 (모든 등록 user_gr)
        cur.execute("""SELECT DISTINCT USER_GR_ID FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
                       WHERE MNU_ID='DMF0020' AND SHT_NM='main' AND MNU_BTN_CD='SEARCH'""")
        all_main_search_groups = [r[0] for r in cur.fetchall()]
        target_groups = sorted(set(groups) | set(all_main_search_groups))
        inserted = 0
        for gr in target_groups:
            for sht in ['titleSet', 'version']:
                cur.execute("""MERGE INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M t
                    USING (SELECT :g USER_GR_ID, 'DMF0020' MNU_ID, :s SHT_NM, 'SEARCH' MNU_BTN_CD FROM DUAL) s
                    ON (t.USER_GR_ID=s.USER_GR_ID AND t.MNU_ID=s.MNU_ID AND t.SHT_NM=s.SHT_NM AND t.MNU_BTN_CD=s.MNU_BTN_CD)
                    WHEN NOT MATCHED THEN INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                    VALUES (:g, 'DMF0020', :s, 'SEARCH', 'Y', 'admin', SYSDATE, 'admin', SYSDATE)""",
                    g=gr, s=sht)
                inserted += cur.rowcount
        print(f"[4] USER_GR_MNU_BTN_MPG_M MERGE: {inserted} row across {len(target_groups)} groups")

        conn.commit()
        print()
        # 검증
        cur.execute("""SELECT b.SHT_NM,
            (SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M u
              WHERE u.MNU_ID=b.MNU_ID AND u.SHT_NM=b.SHT_NM AND u.MNU_BTN_CD=b.MNU_BTN_CD
                AND u.USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID='minyonglee1')) auth
          FROM SCM_ADM_MNU_BTN_MPG_M b
         WHERE b.MNU_ID='DMF0020' AND b.SHT_NM IN ('titleSet','version','exchangeRate','priceBatchInput')""")
        print("Verification:")
        for r in cur.fetchall():
            print(f"  {r[0]:18} auth={r[1]}")
        cur.close()
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
