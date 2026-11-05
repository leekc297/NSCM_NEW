import json,sys,statistics as st
sys.stdout.reconfigure(encoding='utf-8')
A,B=sys.argv[1],sys.argv[2]
a=json.load(open(f'_measure_{A}.json',encoding='utf-8'));b=json.load(open(f'_measure_{B}.json',encoding='utf-8'))
print(A,a['start'],a['end'],a['body']);print(B,b['start'],b['end'],b['body'])
for d in ('40','81','82'):
    ha=[x['sec'] for x in a['http'][d]];hb=[x['sec'] for x in b['http'][d]]
    pa=[x['proc'] for x in a['sp'][d]];pb=[x['proc'] for x in b['sp'][d]]
    fa=[x['fetch'] for x in a['sp'][d]];fb=[x['fetch'] for x in b['sp'][d]]
    print(f"div{d} HTTP {ha} -> {hb} | med {st.median(ha)} -> {st.median(hb)}")
    print(f"div{d} SPproc {pa} -> {pb} | med {st.median(pa)} -> {st.median(pb)}")
    print(f"div{d} SPfetch {fa} -> {fb} | med {st.median(fa)} -> {st.median(fb)}")
    da={x['digest'] for x in a['sp'][d]};db={x['digest'] for x in b['sp'][d]}
    ra={x['digest'].get('fcstNPrice') for x in a['http'][d]};rb={x['digest'].get('fcstNPrice') for x in b['http'][d]}
    print(f"   SP rows {a['sp'][d][0]['rows']} -> {b['sp'][d][0]['rows']} digest same={da==db} (A kinds {len(da)}, B kinds {len(db)}) | HTTP digest same={ra==rb} ({len(ra)},{len(rb)})")
