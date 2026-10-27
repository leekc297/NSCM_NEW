# 배치 출력 무결성 점검: 배정 단위 전원 summary / lines_read==lines_total / validation_count==행수 / 필수필드
import json, os, glob, collections, sys
B = os.path.dirname(os.path.abspath(__file__))
REQ = ['unit','line_from','class','check_type','condition','on_fail','reach','desc_ko']
tot = collections.Counter(); bad = []
for bf in sorted(glob.glob(os.path.join(B,'batches','b*.txt'))):
    bid = os.path.basename(bf)[:-4]
    of = os.path.join(B,'out',bid+'.jsonl')
    if not os.path.exists(of): continue
    assigned = [l.split('\t')[1] for l in open(bf,encoding='utf-8') if l.strip()]
    rows=[]; perr=0
    for i,l in enumerate(open(of,encoding='utf-8'),1):
        if not l.strip(): continue
        try: rows.append(json.loads(l))
        except Exception: perr+=1
    summ = {r['unit']:r for r in rows if r.get('_summary')}
    vc = collections.Counter(r['unit'] for r in rows if not r.get('_summary'))
    miss = [u for u in assigned if u not in summ]
    extra = [u for u in summ if u not in assigned]
    lr = [u for u,s in summ.items() if s.get('lines_total') and s.get('lines_read')!=s.get('lines_total')]
    cnt = [u for u,s in summ.items() if s.get('validation_count')!=vc.get(u,0)]
    fld = sum(1 for r in rows if not r.get('_summary') and any(k not in r for k in REQ))
    cls = collections.Counter(r.get('class') for r in rows if not r.get('_summary'))
    tot['units']+=len(summ); tot['rows']+=sum(vc.values()); tot['batches']+=1
    for k,v in cls.items(): tot['cls_'+str(k)]+=v
    st = 'OK' if not (miss or extra or lr or cnt or fld or perr) else 'NG'
    print(bid, st, 'units',len(summ),'/',len(assigned),'rows',sum(vc.values()), ('miss=%s'%miss if miss else ''), ('extra=%s'%extra if extra else ''), ('lines=%s'%lr if lr else ''), ('cnt=%s'%cnt if cnt else ''), ('fieldNG=%d'%fld if fld else ''), ('parseNG=%d'%perr if perr else ''))
    if st=='NG': bad.append(bid)
print(dict(tot)); print('NG', bad)
