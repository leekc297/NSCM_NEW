import csv,os,re,collections
os.chdir(r'C:\Projects\NSCM\Doc\asisfacts\screens')
res=[]
for sid in os.listdir('.'):
    gc=os.path.join(sid,'grid_code.csv'); ga=os.path.join(sid,'grid_columns_asis.csv'); ac=os.path.join(sid,'actions.csv')
    if not (os.path.exists(gc) and os.path.exists(ga) and os.path.exists(ac)): continue
    owners=collections.defaultdict(set)
    for r in csv.DictReader(open(gc,encoding='utf-8-sig')):
        if r['kind']=='SHEET' and r['api']=='AddSheet' and r['sheet_hint']:
            owners[r['sheet_hint']].add(r['class'])
    popcls=set()
    for r in csv.DictReader(open(ac,encoding='utf-8-sig')):
        if r['kind']=='POPUP':
            m=re.match(r'new\s+(?:[\w.]+\.)?(\w+)$',r['target'].strip())
            if m and m.group(1)!=r['class']: popcls.add(m.group(1))
    sheets={r['sheet'] for r in csv.DictReader(open(ga,encoding='utf-8-sig'))}
    for s in sorted(sheets):
        o=owners.get(s)
        if o and o<=popcls:
            res.append((sid,s,sorted(o)))
print(len(res))
for x in res: print(x)
