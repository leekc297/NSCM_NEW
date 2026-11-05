import json,sys,collections
sys.stdout.reconfigure(encoding='utf-8')
A,B=sys.argv[1],sys.argv[2]
a=json.load(open(A,encoding='utf-8'));b=json.load(open(B,encoding='utf-8'))
print(len(a),len(b),'cols',len(a[0]),len(b[0]),'colset same',set(a[0])==set(b[0]))
meas=lambda c:c=='QTY' or c[:2] in('D_','W_','M_')
keys=[c for c in a[0] if not meas(c)]
kf=lambda r:tuple(str(r.get(c)) for c in keys)
ka=collections.Counter(map(kf,a));kb=collections.Counter(map(kf,b))
oa=list((ka-kb).elements());ob=list((kb-ka).elements())
print('only A',len(oa),'only B',len(ob))
for name,o in (('onlyA',oa),('onlyB',ob)):
    if not o: continue
    print(name)
    for i,c in enumerate(keys):
        v=collections.Counter(x[i] for x in o)
        if 1<len(v)<=6 or (len(v)==1 and c in('DIVISION_ID','MEASURE','MEASURE_NAME','GROUP_ID','SCM_SITE_ID','FCST_TYPE','END_CUSTOMER')): print(' ',c,dict(v.most_common(6)))
    print('  e.g.',dict(zip(keys[:12],o[0][:12])))
# 같은 키의 값 차이
ma={kf(r):r for r in a};mb={kf(r):r for r in b}
common=set(ma)&set(mb);dc=collections.Counter();n=0
for k in common:
    for c in a[0]:
        if str(ma[k].get(c))!=str(mb[k].get(c)): dc[c]+=1;n+=1
print('common keys',len(common),'value diffs',n,dc.most_common(10))
