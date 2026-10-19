"""before.pkl ↔ after.pkl 키(DIVISION·SITE·PROJECT·ITEM) 단위 대조 — 바뀐 컬럼 집계"""
import pickle,collections
b=pickle.load(open('before.pkl','rb'));a=pickle.load(open('after.pkl','rb'))
for div in ('40','81','82'):
    cb,rb,_=b[div];ca,ra,_=a[div]; assert cb==ca
    k=lambda r:(r[cb.index('SCM_SITE_ID')],r[cb.index('PROJECT_CODE')],r[cb.index('ITEM_ID')])
    B={k(r):r for r in rb};A={k(r):r for r in ra}
    assert len(B)==len(rb) and len(A)==len(ra)
    chg=collections.Counter();rows=0;filled=0;emptied=0
    for kk in B:
        if kk not in A: continue
        diffc=[cb[i] for i in range(len(cb)) if B[kk][i]!=A[kk][i]]
        if diffc:
            rows+=1;chg.update(diffc)
            si=cb.index('SOLDTO_CODE')
            if B[kk][si] is None and A[kk][si] is not None: filled+=1
            if B[kk][si] is not None and A[kk][si] is None: emptied+=1
    print(div,'rows',len(rb),'->',len(ra),'| keys only-before',len(set(B)-set(A)),'only-after',len(set(A)-set(B)),'| changed rows',rows,'| Sold-To 빈칸→값',filled,'값→빈칸',emptied,'| cols',dict(chg))
