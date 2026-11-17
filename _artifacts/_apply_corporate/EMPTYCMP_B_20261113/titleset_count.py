# -*- coding: utf-8 -*-
import sys, datetime
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
con = dbconn.connect('tobe'); cur = con.cursor()
cur.execute("SELECT PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COUNT(*), TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE USER_ID='minyonglee1' AND PROGRAM_ID LIKE 'DMF0003%' GROUP BY PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE ORDER BY 1,2,3")
print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'TITLESET_USER minyonglee1 DMF0003%:')
for r in cur: print('  ', r)
con.close()
