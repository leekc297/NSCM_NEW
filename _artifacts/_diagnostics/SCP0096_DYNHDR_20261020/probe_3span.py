# -*- coding: utf-8 -*-
# SCP0096 동적 헤더 진단 — 사내 ZIOUI1 최신 원문(PKG_COM0000 3SPAN · PKG_SCP0096 GET alias) + 3SPAN 실행 결과(읽기 전용)
import sys
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
import oracledb
cx = connect('tobe')
cur = cx.cursor()
cur.execute("""SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
  FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('PKG_COM0000','PKG_SCP0096')""")
for r in cur: print('OBJ', r)
# 3SPAN 본문
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_COM0000' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
lines = cur.fetchall()
start = None
for i,(ln,tx) in enumerate(lines):
    if 'PROCEDURE P_SCP0009_GET_SHEET_CALENDAR_3SPAN' in tx.upper():
        start = i; break
if start is not None:
    for ln,tx in lines[start:start+90]:
        print(f'{ln:6d} {tx.rstrip()}')
        if tx.strip().upper().startswith('END P_SCP0009_GET_SHEET_CALENDAR_3SPAN'): break
print('---- PKG_SCP0096 GET alias')
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0096' AND TYPE='PACKAGE BODY'
  AND (UPPER(TEXT) LIKE '%''D_''%' OR UPPER(TEXT) LIKE '%''W_''%' OR UPPER(TEXT) LIKE '%''M_''%' OR UPPER(TEXT) LIKE '%PIVOT%') ORDER BY LINE""")
for ln,tx in cur: print(f'{ln:6d} {tx.rstrip()}')
# 3SPAN 실행
print('---- 3SPAN exec 20261020~20261108')
rc = cx.cursor().var(oracledb.CURSOR); rs = cx.cursor().var(oracledb.CURSOR)
cur.callproc('PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN', ['20261020','20261108', rc, rs])
c1 = rc.getvalue()
cols = [d[0] for d in c1.description]; print(cols)
rows = c1.fetchall()
print('rows', len(rows))
for r in rows: print(r)
print('status', rs.getvalue().fetchall())
cx.rollback(); cx.close()
