import pickle, sys
a=pickle.load(open(f'matrix_{sys.argv[1]}.pkl','rb')); b=pickle.load(open(f'matrix_{sys.argv[2]}.pkl','rb'))
bad=0; tb=ta=0
for k in a:
    x,y=a[k],b[k]
    def norm(r): return [tuple(v for i,v in enumerate(row) if a[k]['cols'][i] not in ()) for row in r]
    same = x['cols']==y['cols'] and x['rows']==y['rows'] and x['code']==y['code']
    tb+=x['el']; ta+=y['el']
    if not same: bad+=1
    print(f"{'SAME' if same else 'DIFF'} {k[0][-12:]:<12} {k[1]:<6} {k[2]} {k[3]:<9} rows {len(x['rows']):>5}->{len(y['rows']):<5} {x['el']:5.2f}s -> {y['el']:5.2f}s")
print('DIFF count', bad, f'total {tb:.1f}s -> {ta:.1f}s')
