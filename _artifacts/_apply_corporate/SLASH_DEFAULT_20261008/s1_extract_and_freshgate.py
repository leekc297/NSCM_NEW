import openpyxl, json, sys, collections, csv, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
PKG = r"C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DEFAULT_20261008"
f = r"C:\Projects\NSCM\_artifacts\_diagnostics\SLASH_SENTINEL_DMLRISK_20261007\슬래시전환_DEFAULT_DB객체_정리_20261007_v4.xlsx"
ws = openpyxl.load_workbook(f, read_only=True)["1_DEFAULT"]; rows = list(ws.iter_rows(values_only=True)); hdr = rows[0]; hi = {h: i for i, h in enumerate(hdr) if h}
tgt = [(r[hi['테이블']], r[hi['컬럼']], r[hi['출처']], r[hi['ON NULL']]) for r in rows[1:] if r[hi['현재 DEFAULT']] == "'-'" and r[hi['적용']] == "'/'"]
print("xlsx target rows (현재 '-' & 적용 '/'):", len(tgt), "| tables:", len({t for t, *_ in tgt}), "| by 출처:", collections.Counter(s for _, _, s, _ in tgt), "| ON NULL:", collections.Counter(o for *_, o in tgt))
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
tables = sorted({t for t, *_ in tgt})
dic = {}
for i in range(0, len(tables), 200):
    chunk = tables[i:i+200]; binds = {f"t{k}": v for k, v in enumerate(chunk)}
    cur.execute(f"SELECT c.table_name, c.column_name, c.data_type, c.data_length, c.nullable, c.data_default, c.default_on_null, t.temporary FROM all_tab_columns c JOIN all_tables t ON t.owner=c.owner AND t.table_name=c.table_name WHERE c.owner='SCM_MGR' AND c.table_name IN ({','.join(':'+k for k in binds)})", binds)
    for tn, cn, dt, dl, nul, dflt, onn, tmp in cur.fetchall(): dic[(tn, cn)] = dict(data_type=dt, data_length=dl, nullable=nul, data_default=(dflt or '').strip() if dflt else None, default_on_null=onn, temporary=tmp)
cur.execute("SELECT table_name FROM all_tables WHERE owner='SCM_MGR'"); exist = {r[0] for r in cur.fetchall()}
cat = collections.Counter(); out = []
for tn, cn, src, onn_x in tgt:
    m = dic.get((tn, cn)); rec = dict(table=tn, column=cn, source=src, xlsx_on_null=onn_x)
    if tn not in exist: st = 'TABLE_MISSING'
    elif m is None: st = 'COLUMN_MISSING'
    else:
        rec.update(m)
        if m['data_default'] == "'-'": st = 'READY'
        elif m['data_default'] == "'/'": st = 'ALREADY_SLASH'
        else: st = 'DEFAULT_DIFF'
        if m['default_on_null'] != ('YES' if onn_x == 'YES' else 'NO'): rec['on_null_mismatch'] = f"xlsx={onn_x} db={m['default_on_null']}"
    rec['status'] = st; cat[st] += 1; out.append(rec)
print("FRESH-GATE (사내 사전 재조회):", dict(cat)); print("on_null mismatch:", sum(1 for r in out if r.get('on_null_mismatch')))
print("temporary(GTT) among READY:", sum(1 for r in out if r['status']=='READY' and r.get('temporary')=='Y'), "| nullable=Y among READY:", sum(1 for r in out if r['status']=='READY' and r.get('nullable')=='Y'))
print("types among READY:", collections.Counter(r.get('data_type') for r in out if r['status']=='READY'))
for st in ('DEFAULT_DIFF','TABLE_MISSING','COLUMN_MISSING','ALREADY_SLASH'):
    ex = [f"{r['table']}.{r['column']}={r.get('data_default')}" for r in out if r['status']==st][:12]
    if ex: print(f"  {st} examples:", ex)
json.dump(dict(snapshot_at=datetime.datetime.now().isoformat(timespec='seconds'), db=d, rows=out), open(PKG + r"\00_BEFORE_dictionary_snapshot.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
with open(PKG + r"\00_BEFORE_dictionary_snapshot.csv", "w", newline="", encoding="utf-8-sig") as fh:
    w = csv.writer(fh); w.writerow(["TABLE","COLUMN","SOURCE","XLSX_ON_NULL","DATA_TYPE","NULLABLE","DATA_DEFAULT","DEFAULT_ON_NULL","TEMPORARY","STATUS","NOTE"])
    for r in out: w.writerow([r['table'], r['column'], r['source'], r['xlsx_on_null'], r.get('data_type'), r.get('nullable'), r.get('data_default'), r.get('default_on_null'), r.get('temporary'), r['status'], r.get('on_null_mismatch','')])
cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); print("INVALID objects before:", cur.fetchone()[0])
cur.execute("SELECT object_type, COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID' GROUP BY object_type"); print("  ", cur.fetchall())
