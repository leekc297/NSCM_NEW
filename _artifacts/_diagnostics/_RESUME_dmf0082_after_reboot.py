# -*- coding: utf-8 -*-
# 재부팅 후 실행: PIVOT 접힘 수정 배포 + 검증 + AS-IS 대조.
#   python _RESUME_dmf0082_after_reboot.py
import time, oracledb
from collections import Counter
from ora import conn_info
u,p,d=conn_info()
cn=oracledb.connect(user=u,password=p,dsn=d); cur=cn.cursor()

# 1) 배포
src=open(r'C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0082_body_datefix_20260712.sql',encoding='utf-8').read().rstrip()
if src.endswith('/'): src=src[:-1].rstrip()
cur.execute(src); cn.commit()
cur.execute("SELECT status FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
print('BODY STATUS=',cur.fetchone()[0])
cur.execute("SELECT line,text FROM user_errors WHERE name='PKG_DMF0082' ORDER BY sequence")
errs=cur.fetchall()
for e in errs[:8]: print(' ERR',e)
if errs: raise SystemExit('COMPILE ERRORS — 중단')

# 2) 검증 (div40, 2026 6개월, minyonglee1)
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYYMMDD'")
cur.execute("ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYYMMDD HH24:MI:SS'")
IN=['40','ALL','ALL','ALL','20260101','20260731','ALL','','Current','N','minyonglee1','minyonglee1']
outs=[cn.cursor() for _ in range(6)]
t0=time.time(); cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", IN+outs); el=time.time()-t0
main=outs[0]; cols=[c[0] for c in main.description]
mi=[i for i,c in enumerate(cols) if c.upper()=='MEASURE']
rows=main.fetchall()
cc=Counter(str(r[mi[0]]) for r in rows) if mi else {}
print(f"\n== PIVOTFIX 검증 {el:.1f}s  MAIN(RC1)_rows={len(rows)} cols={len(cols)}")
print("   MEASURE:", dict(sorted(cc.items(), key=lambda x:-x[1])))
print("   기대: 각 measure 가 distinct 키 수준으로 접힘 (LOC ~수천). AS-IS div40 총 2,924 참고.")
cn.close()
