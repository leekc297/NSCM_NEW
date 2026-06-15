"""SCMD_APP user 로 직접 8 SYNONYM 생성"""
import oracledb

conn = oracledb.connect(user="SCMD_APP", password="!SCMroqkf2026", dsn="121.162.245.167:2521/ESSCMD")
cur = conn.cursor()

NAMES = [
    "SYS0013_GET_QUERY_LIST",
    "SYS0013_GET_COLUMNS",
    "SYS0013_GET_PARAMETERS",
    "SYS0013_EXECUTE_QUERY",
    "SYS0013_GET_QUERY_LIST_COMMON",
    "SYS0013_GET_DYNAMIC_QUERYS",
    "SYS0013_GET_ROLE_DATA",
    "PKG_SYS0013",
]

for name in NAMES:
    try:
        cur.execute(f"CREATE OR REPLACE SYNONYM {name} FOR SCM_MGR.{name}")
        print(f"  ✅ {name}")
    except Exception as e:
        print(f"  ❌ {name} : {e}")

conn.commit()
cur.close()
conn.close()
print("\nDone.")
