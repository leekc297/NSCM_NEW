import sys, os, csv
sys.path.insert(0, r'C:\Projects\NSCM\tools\Harness\verify'); sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import gen_param_map as g, pkg_asis_map as m
pm = g.rd(g.P('Doc','tobefacts','db','proc_meta.csv'))
pkgs = sorted({r['proc'].split('.')[0].upper() for r in pm if '.' in (r.get('proc') or '')})
if len(sys.argv) > 1: pkgs = [a.upper() for a in sys.argv[1:]]
ain, tin = {}, {}
for r in g.rd(g.P('Doc','asisfacts','db','db_params.csv')):
    if (r.get('type') or '').strip() == 'P' and r.get('is_output') == '0': ain.setdefault(r['object_name'].upper(), []).append(r['param_name'])
for r in g.rd(g.P('Doc','tobefacts','db','proc_params.csv')):
    if (r.get('col_tp_cd') or '').upper() in ('IN','I'): tin.setdefault(r['proc'].upper(), []).append(r['col_nm'])
src = m.read_live(pkgs)
n = 0
for pkg, (spec, body) in src.items():
    rec, cf, dr = m.parse(pkg, spec, body)
    hp = g.header_pairs(pkg, body, ain, tin)
    for proc, (sp, why) in hp.items():
        same = proc.split('.')[-1][2:]
        flag = 'NEW' if proc not in rec else ('SAME' if rec[proc][0].upper() == sp.upper() else 'DIFF_REC:' + rec[proc][0])
        if flag != 'SAME' or len(sys.argv) > 1: print(flag, proc, '←', sp)
        n += 1
print('pkgs', len(src), 'header pairs', n)
