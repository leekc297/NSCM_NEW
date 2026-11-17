import sys
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
sys.stdout.reconfigure(encoding='utf-8')
cur = dbconn.connect('tobe').cursor()
M = """SELECT COUNT(*) FROM SSP_MST_SHIP_MASTER_EE A, SSP_MST_SITE_ITEM_EE_V B, SCM_MST_SITE C
 WHERE B.DIVISION_ID=A.DIVISION_ID AND B.SCM_SITE_ID=A.SCM_SITE_ID AND B.ITEM_ID=A.ITEM_ID
   AND C.DIVISION_ID=A.DIVISION_ID AND C.SCM_SITE_ID=A.SCM_SITE_ID AND (:d IS NULL OR A.DIVISION_ID=:d) AND ({c})"""
P = """SELECT COUNT(*) FROM SSP_MST_SITE_ITEM_EE_V A, SCM_MST_SITE B
 WHERE B.DIVISION_ID=A.DIVISION_ID AND B.SCM_SITE_ID=A.SCM_SITE_ID AND (:d IS NULL OR A.DIVISION_ID=:d) AND ({c})"""
for kind, d, c in [('M','40',"INSTR(UPPER(A.ITEM_ID),'APCAN0002A')>0"),('M','40',"INSTR(UPPER(A.ITEM_ID),'CAN000')>0"),
                   ('M','40',"INSTR(UPPER(A.ITEM_ID),'CAN000')>0 OR INSTR(UPPER(A.ITEM_ID),'CCS0855')>0"),('M',None,"INSTR(UPPER(A.ITEM_ID),'CAN000')>0"),
                   ('P','40',"INSTR(UPPER(A.ITEM_ID),'APCAN0002A')>0"),('P','40',"INSTR(UPPER(A.ITEM_ID),'CAN000')>0"),
                   ('P','40',"INSTR(UPPER(A.ITEM_ID),'CAN000')>0 OR INSTR(UPPER(A.ITEM_ID),'CCS0855')>0")]:
    cur.execute((M if kind=='M' else P).format(c=c), d=d); print('EXPECT', kind, d, c, '=>', cur.fetchone()[0])
