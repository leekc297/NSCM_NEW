"""옛 DMF0027 SP / PKG / SYNONYM DROP"""
import oracledb

SP_NAMES = [
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST",
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS",
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS",
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2",
    "DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON",
    "DMF0027_GET_DM_DYNAMIC_QUERYS",
    "DMF0027_GET_DM_ROLE_DATA",
]

print("=== SCM_MGR: DROP 7 standalone SP + PKG_DMF0027 ===")
conn = oracledb.connect(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/ESSCMD")
cur = conn.cursor()
for name in SP_NAMES:
    try:
        cur.execute(f"DROP PROCEDURE {name}")
        print(f"  ✅ PROCEDURE {name}")
    except Exception as e:
        print(f"  ❌ {name}: {e}")
try:
    cur.execute("DROP PACKAGE PKG_DMF0027")
    print("  ✅ PACKAGE PKG_DMF0027 (spec + body)")
except Exception as e:
    print(f"  ❌ PKG_DMF0027: {e}")
conn.commit()
cur.close()
conn.close()

print("\n=== SCMD_APP: DROP 7 옛 SYNONYM ===")
conn = oracledb.connect(user="SCMD_APP", password="!SCMroqkf2026", dsn="121.162.245.167:2521/ESSCMD")
cur = conn.cursor()
for name in SP_NAMES:
    try:
        cur.execute(f"DROP SYNONYM {name}")
        print(f"  ✅ SYNONYM {name}")
    except Exception as e:
        print(f"  ❌ {name}: {e}")
conn.commit()
cur.close()
conn.close()
print("\nDone.")
