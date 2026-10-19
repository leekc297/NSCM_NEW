import json, subprocess, sys, pathlib
rows=json.load(open("_work/scan_regressions_all.json",encoding="utf-8"))
targets=[r for r in rows if r['new_vs_backup'] and r['otype']!='VIEW']
meta=json.load(open("_work/fresh_all/_meta.json",encoding="utf-8"))
summary=[]
for r in targets:
    ot,nm=r['otype'],r['name']; fn=meta[f"{ot}|{nm}"]['file']
    bak=f"../00_BACKUP_corp/{fn}"; fresh=f"_work/fresh_all/{nm}.{ot.replace(' ','_')}.sql"; out=f"_work/fixed_all/{fn}"
    print(f"\n=== {ot} {nm}")
    p=subprocess.run([sys.executable,"-I","_work/groupby_fix.py",bak,fresh,out],capture_output=True,text=True,encoding="utf-8")
    print(p.stdout.rstrip())
    if p.stderr.strip(): print("STDERR:",p.stderr.strip()[-800:])
    summary.append((nm,p.returncode))
print("\nRESULT:",summary)
