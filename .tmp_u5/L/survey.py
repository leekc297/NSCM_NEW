import csv,glob,os,collections
os.chdir(r'C:\Projects\NSCM\Doc\asisfacts\screens')
vc=collections.Counter(); cnt=0; ex=[]
for sid in os.listdir('.'):
    d=sid
    fp=os.path.join(d,'files.csv'); gc=os.path.join(d,'grid_code.csv'); ga=os.path.join(d,'grid_columns_asis.csv')
    if not (os.path.exists(fp) and os.path.exists(gc) and os.path.exists(ga)): continue
    var={r['file']:r['variant'] for r in csv.DictReader(open(fp,encoding='utf-8-sig'))}
    for v in set(var.values()): vc[v]+=1
    owners=collections.defaultdict(set)
    for r in csv.DictReader(open(gc,encoding='utf-8-sig')):
        if r['kind']=='SHEET' and r['api']=='AddSheet' and r['sheet_hint']:
            owners[r['sheet_hint']].add((var.get(r['file'],'?'),r['class']))
    sheets={r['sheet'] for r in csv.DictReader(open(ga,encoding='utf-8-sig'))}
    for s in sheets:
        o=owners.get(s)
        if o and not any(v=='current' for v,_ in o):
            cnt+=1; ex.append((sid,s,o))
print(vc); print(cnt)
for e in ex: print(e)
