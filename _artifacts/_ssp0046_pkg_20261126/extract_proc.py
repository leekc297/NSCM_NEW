# 패키지 BODY 에서 프로시저 1개를 줄 단위로 추출 (ALL_SOURCE 원문)
import oracledb,sys,re,os
env=dict(l.strip().split('=',1) for l in open(r'c:\Projects\NSCM\.env.asis',encoding='utf-8') if '=' in l and not l.startswith('#'))
c=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur=c.cursor(); out=sys.argv[1]
for spec in sys.argv[2:]:
    pkg,proc=spec.split('.')
    cur.execute("SELECT LINE,TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE",n=pkg)
    L=[r[1].rstrip('\r\n') for r in cur]
    st=next((i for i,l in enumerate(L) if re.match(r'\s*PROCEDURE\s+'+proc+r'\b',l,re.I)),None)
    if st is None: print('NOT FOUND',spec); continue
    en=next(i for i in range(st,len(L)) if re.match(r'\s*END\s+'+proc+r'\s*;',L[i],re.I))
    b=st
    while b>0 and L[b-1].strip().startswith('/*'): b-=1
    open(os.path.join(out,spec+'.sql'),'w',encoding='utf-8').write('\n'.join(L[b:en+1])+'\n'); print(spec,en-b+1)
