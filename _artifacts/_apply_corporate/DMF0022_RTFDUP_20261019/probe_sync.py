"""DM_PLN_SALES_PLAN 에 MKT_FCST 를 넣는 객체 · CREATED_BY 'E2026%' 패턴 (사내)"""
import sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("""SELECT NAME, TYPE, COUNT(*) FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND UPPER(TEXT) LIKE '%INTO%DM_PLN_SALES_PLAN%' AND UPPER(TEXT) NOT LIKE '%DM_PLN_SALES_PLAN_%'
                    GROUP BY NAME, TYPE ORDER BY 1""")
    print("INSERT INTO DM_PLN_SALES_PLAN:", cur.fetchall())
    cur.execute("""SELECT NAME, TYPE, COUNT(*) FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND UPPER(TEXT) LIKE '%MERGE%INTO%DM_PLN_SALES_PLAN%' GROUP BY NAME, TYPE ORDER BY 1""")
    print("MERGE INTO DM_PLN_SALES_PLAN:", cur.fetchall())
    cur.execute("""SELECT CREATED_BY, COUNT(*), TO_CHAR(MIN(CREATION_DATE),'YYYY-MM-DD HH24:MI'), TO_CHAR(MAX(CREATION_DATE),'YYYY-MM-DD HH24:MI')
                     FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE DIVISION_ID='40' AND CREATED_BY LIKE 'E20%' GROUP BY CREATED_BY ORDER BY 3 DESC FETCH FIRST 10 ROWS ONLY""")
    print("SALES_PLAN CREATED_BY E20*:", cur.fetchall())
    cur.execute("""SELECT CREATED_BY, COUNT(*), TO_CHAR(MAX(CREATION_DATE),'YYYY-MM-DD HH24:MI') FROM SCM_MGR.DM_PLN_MKT_FCST
                    WHERE DIVISION_ID='40' AND CREATED_BY LIKE 'E20%' GROUP BY CREATED_BY ORDER BY 3 DESC FETCH FIRST 10 ROWS ONLY""")
    print("MKT_FCST CREATED_BY E20*:", cur.fetchall())
    # 같은 키 MKT_FCST 원장의 기간·생성자
    cur.execute("""SELECT INCOTERMS, MIN(YYYYMMDD), MAX(YYYYMMDD), COUNT(*), MIN(CREATED_BY), MAX(CREATED_BY) FROM SCM_MGR.DM_PLN_MKT_FCST
                    WHERE DIVISION_ID='40' AND ITEM_ID='MCCM348014A3' AND SCM_SITE_ID='SCUD_CN_FOC' AND MEASURE='MKT_FCST'
                    GROUP BY INCOTERMS ORDER BY 1""")
    print("MKT_FCST key:", cur.fetchall())
