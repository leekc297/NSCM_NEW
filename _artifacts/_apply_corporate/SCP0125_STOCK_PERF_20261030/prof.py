# SP 1회 실행 + 커서 전량 fetch, 실행 전후 V$SQL(PROGRAM_ID=PKG_SCP0125) 차분으로 문장별 시간
import sys, time, oracledb; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
proc, div, ymd = sys.argv[1], sys.argv[2], sys.argv[3]
item = sys.argv[4] if len(sys.argv)>4 else ''
SNAP = """SELECT SQL_ID, CHILD_NUMBER, PROGRAM_LINE#, EXECUTIONS, ELAPSED_TIME, BUFFER_GETS, ROWS_PROCESSED, PLAN_HASH_VALUE, SUBSTR(SQL_TEXT,1,60)
  FROM V$SQL WHERE PROGRAM_ID IN (SELECT OBJECT_ID FROM DBA_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0125' AND OBJECT_TYPE='PACKAGE BODY')"""
with connect('tobe') as cx, connect('tobe') as mon:
    mc = mon.cursor()
    def snap():
        mc.execute(SNAP); return {(r[0],r[1]):r for r in mc.fetchall()}
    b = snap()
    cur = cx.cursor(); rc = cx.cursor(); code = cur.var(str); msg = cur.var(str)
    t0 = time.time()
    cur.callproc('PKG_SCP0125.'+proc, [div, ymd, '', '', item, rc, code, msg])
    t1 = time.time(); rows = rc.fetchall(); t2 = time.time()
    cx.rollback()
    a = snap()
    print(f"{proc} div={div} ymd={ymd} item={item!r}: call {t1-t0:.2f}s fetch {t2-t1:.2f}s total {t2-t0:.2f}s rows={len(rows)} code={code.getvalue()} msg={msg.getvalue()}")
    out=[]
    for k,r in a.items():
        p=b.get(k); ex=r[3]-(p[3] if p else 0); el=(r[4]-(p[4] if p else 0))/1e6; bg=r[5]-(p[5] if p else 0); rp=r[6]-(p[6] if p else 0)
        if ex>0 or el>0: out.append((el,r[2],ex,bg,rp,r[0],r[7],r[8]))
    for o in sorted(out,reverse=True)[:15]:
        print(f"  {o[0]:8.2f}s line={o[1]:<5} exec={o[2]:<6} gets={o[3]:<10} rows={o[4]:<8} {o[5]} phv={o[6]} {o[7]!r}")
