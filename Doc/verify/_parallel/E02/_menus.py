"""E02 항목별 문서 메뉴 목록 — EG → 문서 원행의 menu_id"""
import csv, re, subprocess, sys, json
sys.stdout.reconfigure(encoding='utf-8')
rows = list(csv.DictReader(open('Doc/verify/_engine_gap.csv', encoding='utf-8-sig')))
ids = [l.split()[0] for l in subprocess.run(['python', '-I', 'tools/Harness/verify/engine_gap_cluster.py', 'E02'], capture_output=True, text=True, encoding='utf-8').stdout.splitlines() if l.startswith('EG')]
R = {r['gap_id']: r for r in rows}
D = {}
for d in csv.DictReader(open('Doc/verify/defects_classified.csv', encoding='utf-8-sig')):
    D[f"{d['src']}-{d['no']}"] = d
out = {}
for i in ids:
    refs = [x for x in re.split(r'[;\s]+', R[i]['doc_refs']) if x]
    out[i] = sorted({D[x]['menu_id'] for x in refs if x in D})
allm = {}
for i, ms in out.items():
    for m in ms:
        allm.setdefault(m, []).append(i)
if __name__ == '__main__':
    for m, l in sorted(allm.items(), key=lambda t: -len(t[1])):
        print(m, len(l), ' '.join(l))
    json.dump(out, open('Doc/verify/_parallel/E02/_eg_menus.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
