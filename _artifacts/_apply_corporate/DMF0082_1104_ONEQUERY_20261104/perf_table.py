"""measure.py JSON 2본(원본·1104) → 사용자×사업부 3회 중앙값 전후표 (markdown).  python perf_table.py <orig.json> <new.json>"""
import sys, json, statistics
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
A = json.load(open(sys.argv[1], encoding='utf-8')); B = json.load(open(sys.argv[2], encoding='utf-8'))
def med(d):
    m = {}
    for c in d['calls']:
        k = (c['user'], c['div']); m.setdefault(k, []).append(c)
    out = {}
    for k, cs in m.items():
        out[k] = dict(proc=statistics.median(x['proc'] for x in cs), fetch=statistics.median(x['fetch'] for x in cs),
                      total=statistics.median(x['proc'] + x['fetch'] for x in cs), rows=cs[0]['curs'][0]['rows'] if cs[0].get('curs') else None, n=len(cs),
                      at=f"{cs[0]['at']}~{cs[-1]['at']}", digest=len({x['curs'][0]['srt'] for x in cs if x.get('curs')}))
    return out
a, b = med(A), med(B)
print(f"| 사용자 | 사업부 | 원본 {A['pkg']} proc+fetch (중앙값, n) | 측정시각 | 1104 {B['pkg']} proc+fetch (중앙값, n) | 측정시각 | 비 | 행수 A/B |")
print("|---|---|---|---|---|---|---|---|")
for k in sorted(set(a) | set(b)):
    x, y = a.get(k), b.get(k)
    f = lambda v: f"{v['proc']:.1f}s + {v['fetch']:.1f}s = **{v['total']:.1f}s** (n={v['n']})" if v else "미측정"
    ratio = f"{y['total'] / x['total']:.2f}" if x and y and x['total'] else "-"
    print(f"| {k[0]} | {k[1]} | {f(x)} | {x['at'] if x else '-'} | {f(y)} | {y['at'] if y else '-'} | {ratio} | {x['rows'] if x else '-'} / {y['rows'] if y else '-'} |")
print(f"\n원본 env {A['env']} pkginfo {A['pkginfo']} · 1104 env {B['env']} pkginfo {B['pkginfo']}")
print(f"원장 변경 감시(측정 전후 COUNT/MAX(LAST_UPDATE)) 원본: {'동일' if A['ledger_before'] == A['ledger_after'] else '변경 있음 ' + str({k: (A['ledger_before'][k], A['ledger_after'][k]) for k in A['ledger_before'] if A['ledger_before'][k] != A['ledger_after'].get(k)})}")
print(f"원장 변경 감시 1104: {'동일' if B['ledger_before'] == B['ledger_after'] else '변경 있음 ' + str({k: (B['ledger_before'][k], B['ledger_after'][k]) for k in B['ledger_before'] if B['ledger_before'][k] != B['ledger_after'].get(k)})}")
