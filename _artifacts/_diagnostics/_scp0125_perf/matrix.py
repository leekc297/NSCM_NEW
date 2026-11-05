# 변경 전/후 결과 동일성: 사업부×기준일 행렬로 SP 실행 → 전체 행(정렬 포함) 저장 + 시간
import sys, time, json, pickle, datetime; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
tag = sys.argv[1]
CASES = [('P_SCP0125_GET_STOCK_ADJ', d, y, '') for d in ['81','82','40','81_HD','81_HG','81_HM','81_ST','83'] for y in ['20260608','20260817','20260824','20260831','20260907','20261005']]
CASES += [('P_SCP0125_GET_STOCK_ADJ_UC','81_UC', y, '') for y in ['20260608','20260817','20260824','20260831','20260907','20261005']]
CASES += [('P_SCP0125_GET_STOCK_ADJ','81','20260831','AAEF1090'), ('P_SCP0125_GET_STOCK_ADJ','82','20260824','ACEH,E71')]
out = {}
with connect('tobe') as cx:
    for p,d,y,it in CASES:
        cur=cx.cursor(); rc=cx.cursor(); code=cur.var(str); msg=cur.var(str)
        t=time.time(); cur.callproc('PKG_SCP0125.'+p,[d,y,'','',it,rc,code,msg]); rows=rc.fetchall(); el=time.time()-t
        cols=[c[0] for c in rc.description] if rc.description else []
        cx.rollback()
        out[(p,d,y,it)] = dict(el=el, code=code.getvalue(), msg=msg.getvalue(), cols=cols, rows=rows)
        print(f"{p[-12:]:<12} {d:<6} {y} {it:<10} {el:6.2f}s rows={len(rows):<6} code={code.getvalue()} {msg.getvalue() or ''}", flush=True)
pickle.dump(out, open(f'matrix_{tag}.pkl','wb'))
