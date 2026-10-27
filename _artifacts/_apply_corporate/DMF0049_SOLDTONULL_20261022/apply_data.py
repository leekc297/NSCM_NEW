"""DM_PLN_SALES_ETC_REPORT_C SOLDTO_CODE '-'/'/' → NULL 정리 (사내 ZIOUI1) [E20261022-SOLDTONULL]

저장 SP 의 빈값 치환('-' 08-11~ / '/' 10월~)으로 생긴 행만 대상. 원장 대다수(AS-IS 이관분)는 NULL.
백업: DM_PLN_SALES_ETC_REPORT_C_BAK20261022_SOLDTO (대상 행 전 컬럼) — 이미 있으면 재생성하지 않음(멱등).
이력(_H)은 저장 당시 기록이라 변경하지 않는다.
  python apply_data.py          # 건수만
  python apply_data.py --apply  # 백업 + UPDATE + COMMIT
"""
import sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

T = "DM_PLN_SALES_ETC_REPORT_C"
BAK = "DM_PLN_SALES_ETC_REPORT_C_BAK20261022_SOLDTO"
COND = "SOLDTO_CODE IN ('-','/')"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL")
print("DB", d, cur.fetchone()[0])
cur.execute(f"SELECT NVL(SOLDTO_CODE,'(NULL)'), COUNT(*) FROM {T} WHERE SOLDTO_CODE IS NULL OR {COND} GROUP BY NVL(SOLDTO_CODE,'(NULL)') ORDER BY 1")
print("BEFORE", cur.fetchall())
if "--apply" in sys.argv:
    cur.execute("SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        cur.execute(f"CREATE TABLE {BAK} AS SELECT * FROM {T} WHERE {COND}")
    cur.execute(f"SELECT COUNT(*) FROM {BAK}")
    nb = cur.fetchone()[0]
    cur.execute(f"SELECT COUNT(*) FROM {T} WHERE {COND}")
    nt = cur.fetchone()[0]
    cur.execute(f"SELECT COUNT(*) FROM {T} A WHERE {COND} AND NOT EXISTS (SELECT 1 FROM {BAK} B WHERE B.VERSION_NO=A.VERSION_NO AND B.DIVISION_ID=A.DIVISION_ID AND B.DATA_SEQ=A.DATA_SEQ AND B.MEASURE=A.MEASURE AND B.YYYYMMDD=A.YYYYMMDD)")
    assert cur.fetchone()[0] == 0, "백업에 없는 대상 행 존재 — 중단"
    cur.execute(f"UPDATE {T} SET SOLDTO_CODE = NULL WHERE {COND}")
    nu = cur.rowcount
    con.commit()
    print(f"BACKUP {BAK} {nb}행 · 대상 {nt}행 · UPDATE {nu}행 COMMIT")
    cur.execute(f"SELECT NVL(SOLDTO_CODE,'(NULL)'), COUNT(*) FROM {T} WHERE SOLDTO_CODE IS NULL OR {COND} GROUP BY NVL(SOLDTO_CODE,'(NULL)') ORDER BY 1")
    print("AFTER", cur.fetchall())
