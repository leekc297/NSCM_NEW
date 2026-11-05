"""현재 사내 PKG_DMF0049 BODY 를 착수 기준본(ASIS)과 비교 — 추가/삭제 줄 출력"""
import sys, difflib
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0049' AND OBJECT_TYPE='PACKAGE BODY'"); print("NOW", cur.fetchone())
cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY' ORDER BY LINE")
now="".join(r[0] for r in cur)
base=open(r"C:/Projects/NSCM/_artifacts/_apply_corporate/DMF0049_DUPKEYMSG_20261028/PKG_DMF0049_BODY.ASIS_20261028_165221.sql",encoding='utf-8',newline='').read()
print("IDENTICAL_TO_ASIS" if now==base else "DIFF")
if now!=base:
    for l in difflib.unified_diff(base.split('\n'), now.split('\n'), lineterm='', n=0):
        if l.startswith(('+','-')) and not l.startswith(('+++','---')): print(l[:200])
if len(sys.argv)>1: open(sys.argv[1],'w',encoding='utf-8',newline='').write(now)
