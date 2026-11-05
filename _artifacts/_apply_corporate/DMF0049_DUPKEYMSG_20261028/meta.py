import sys
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
cur.execute("SELECT TEMPORARY, DURATION FROM USER_TABLES WHERE TABLE_NAME='GT_DMF0049_RESULTS_MST'"); print('GT', cur.fetchone())
cur.execute("SELECT LISTAGG(COLUMN_NAME||':'||DATA_TYPE, ', ') WITHIN GROUP (ORDER BY COLUMN_ID) FROM USER_TAB_COLUMNS WHERE TABLE_NAME='GT_DMF0049_RESULTS_MST'"); print(cur.fetchone()[0])
cur.execute("SELECT POSITION, ARGUMENT_NAME, IN_OUT FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0049' AND OBJECT_NAME='P_DMF0049_SAVE_SALES_ETC_REPORT_C' ORDER BY POSITION")
print([f"{a}:{b}" for a,b,c_ in cur])
