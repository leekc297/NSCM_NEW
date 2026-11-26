import sys, os, json, importlib.util
sys.path.insert(0, r'C:\Projects\NSCM\tools\Harness\verify')
from importlib.machinery import SourceFileLoader; ge = SourceFileLoader("ge", sys.argv[1]).load_module()
ER = ge.ER
ids = sorted({d for d in os.listdir(ER.V) if os.path.exists(os.path.join(ER.V, d, 'verify_ledger.csv'))})
out = {}
for mid in ids:
    try:
        S = ge.Screen(mid)
    except Exception as e:
        out[mid] = {'err': str(e)}; continue
    o = {}
    for fn in (ge.p_popfill, ge.p_modins, ge.p_combo):
        try:
            rows, why = fn(S)
        except Exception as e:
            rows, why = [], [f'EXC {e}']
        o[fn.__name__] = sorted(f"{r['pattern_id']}|{r['name']}|{r['steps']}" for r in rows if r['pattern_id'] in ('P07', 'P23', 'P24'))
    out[mid] = o
json.dump(out, open(sys.argv[2], 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
print(len(ids))
