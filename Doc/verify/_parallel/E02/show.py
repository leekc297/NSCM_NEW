import json, os, sys, collections
sys.stdout.reconfigure(encoding='utf-8')
d = sys.argv[1]
w = int(sys.argv[2]) if len(sys.argv) > 2 else 300
flt = sys.argv[3] if len(sys.argv) > 3 else ''
p = os.path.join(d, 'popup_results.json')
if not os.path.exists(p):
    print('결과 없음', p); sys.exit(0)
R = json.load(open(p, encoding='utf-8'))
print('행', len(R), collections.Counter(r['result'] for r in R))
for r in R:
    if flt and not (r['result'] in flt.split(',') or r['check'] in flt.split(',')):
        continue
    print(f"#{r['call']} {r['check']:<14}{r['result']:<6}| {r['expected'][:w//2]} || {r['actual'][:w]} || {r['basis'][:70]}")
