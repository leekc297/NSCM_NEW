# -*- coding: utf-8 -*-
"""GT_SCP0096_PIVOT DDL 덤프 — 사내오라클 ZIOUI1 (hook #152)"""
import sys, os, datetime
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..', 'tools', 'DbConn'))
from dbconn import connect
OUT = os.path.dirname(os.path.abspath(__file__))
with connect('tobe') as cx:
    cur = cx.cursor()
    cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), TEMPORARY FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='GT_SCP0096_PIVOT'")
    print(cur.fetchall())
    cur.execute("SELECT DURATION FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_SCP0096_PIVOT'")
    print('DURATION', cur.fetchall())
    cur.execute("SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, CHAR_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_SCP0096_PIVOT' ORDER BY COLUMN_ID")
    for r in cur.fetchall(): print(r)
    cur.execute("SELECT DBMS_METADATA.GET_DDL('TABLE','GT_SCP0096_PIVOT','SCM_MGR') FROM DUAL")
    ddl = cur.fetchone()[0]
    ddl = ddl.read() if hasattr(ddl, 'read') else str(ddl)
    with open(os.path.join(OUT, 'DB_GT_SCP0096_PIVOT_DDL.sql'), 'w', encoding='utf-8') as f:
        f.write('-- SOURCE-FRESH: SCM_MGR.GT_SCP0096_PIVOT TABLE FETCHED=%s FROM ZIOUI1\n' % datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        f.write(ddl)
    print(ddl)
