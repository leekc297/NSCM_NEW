import openpyxl, json, sys, collections, datetime, re, csv
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
PKG = r"C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DEFAULT_20261008"
f = r"C:\Projects\NSCM\_artifacts\_diagnostics\SLASH_SENTINEL_DMLRISK_20261007\슬래시전환_DEFAULT_DB객체_정리_20261007_v4.xlsx"
ws = openpyxl.load_workbook(f, read_only=True)["1_DEFAULT"]; rows = list(ws.iter_rows(values_only=True)); hdr = rows[0]; hi = {h: i for i, h in enumerate(hdr) if h}
all_slash = [(r[hi['테이블']], r[hi['컬럼']], r[hi['출처']], str(r[hi['현재 DEFAULT']])) for r in rows[1:] if r[hi['적용']] == "'/'"]
rest = [x for x in all_slash if x[3] != "'-'"]
print("적용 '/' 전체:", len(all_slash), "| 이번 추가(현재 DEFAULT 없음):", len(rest))
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
# FRESH-GATE 89
b = {}; pr = []
for k, (t, c, *_rest) in enumerate(rest): b[f"t{k}"] = t; b[f"c{k}"] = c; pr.append(f"(c.table_name=:t{k} AND c.column_name=:c{k})")
cur.execute("SELECT c.table_name, c.column_name, c.data_type, c.data_length, c.nullable, c.data_default, c.default_on_null, t.temporary FROM all_tab_columns c JOIN all_tables t ON t.owner=c.owner AND t.table_name=c.table_name WHERE c.owner='SCM_MGR' AND (" + " OR ".join(pr) + ")", b)
dic = {(r[0], r[1]): r for r in cur.fetchall()}
st = collections.Counter(); ready = []
for t, c, src, cur_def in rest:
    m = dic.get((t, c))
    if not m: st['MISSING'] += 1; continue
    dflt = (m[5] or '').strip()
    if dflt == '': st['NO_DEFAULT'] += 1; ready.append((t, c, m[2], m[4], m[7]))
    elif dflt == "'/'": st['ALREADY_SLASH'] += 1
    else: st[f'OTHER:{dflt}'] += 1
print("FRESH-GATE 89:", dict(st), "| nullable:", collections.Counter(r[3] for r in ready), "| GTT:", sum(1 for r in ready if r[4]=='Y'), "| types:", collections.Counter(r[2] for r in ready))
before_inv = set(json.load(open(PKG + r"\00_BEFORE_invalid_objects.json", encoding="utf-8")))
cur.execute("SELECT object_type||' '||object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); inv_now = {r[0] for r in cur.fetchall()}
by_tab = collections.OrderedDict()
for t, c, *_ in ready: by_tab.setdefault(t, []).append(c)
stmts = [f"ALTER TABLE SCM_MGR.{t} MODIFY (" + ", ".join(f"{c} DEFAULT ON NULL '/'" for c in cs) + ")" for t, cs in by_tab.items()]
ok = 0; errs = []
for s_ in stmts:
    try: cur.execute(s_); ok += 1
    except Exception as e: errs.append((s_[:110], str(e)[:160]))
print(f"89 적용: tables ok={ok}/{len(stmts)} err={errs}")
for _ in range(2):
    cur.execute("SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); new = [(t, n) for t, n in cur.fetchall() if f"{t} {n}" not in inv_now]
    for ot, on_ in sorted(new, key=lambda x: {'TYPE':1,'VIEW':2,'PACKAGE':3,'FUNCTION':4,'PROCEDURE':5,'PACKAGE BODY':6}.get(x[0], 9)):
        base = {'PACKAGE BODY':'PACKAGE','TYPE BODY':'TYPE'}.get(ot, ot); body = ' BODY' if ot.endswith('BODY') else ''
        try: cur.execute(f"ALTER {base} SCM_MGR.{on_} COMPILE{body}")
        except Exception as e: print("  compile fail", ot, on_, str(e)[:100])
    print("  newly invalid recompiled:", len(new))
    if not new: break
cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); print("INVALID now:", cur.fetchone()[0], "(직전 5)")
# 최종 2,005 검증
cnt = collections.Counter()
for i in range(0, len(all_slash), 500):
    ch = all_slash[i:i+500]; b = {}; pr = []
    for k, (t, c, *_r) in enumerate(ch): b[f"t{k}"] = t; b[f"c{k}"] = c; pr.append(f"(table_name=:t{k} AND column_name=:c{k})")
    cur.execute("SELECT data_default, default_on_null FROM all_tab_columns WHERE owner='SCM_MGR' AND (" + " OR ".join(pr) + ")", b)
    for df, on in cur.fetchall(): cnt[((df or '').strip(), on)] += 1
print("최종 2,005 상태:", dict(cnt))
# 스크립트 2,005 기준 재생성
items = ",\n".join("        '" + f"{t}.{c}" + "'" for t, c, *_ in all_slash)
tabs = len({t for t, *_ in all_slash})
hdr = f"-- [E20261008-SLASHDEF] NULL 센티널 DEFAULT → '/' + ON NULL 일괄 (1_DEFAULT 시트 적용 '/' = {len(all_slash)}컬럼/{tabs}테이블: 현재 '-' 1,916 + DEFAULT 없음 89 — 사용자 최종 확정 10-08). 데이터 변경 없음(메타만). {datetime.datetime.now():%Y-%m-%d %H:%M}\n"
for fn in ("01_APPLY_CLOUD_idempotent.sql", "02_VERIFY.sql"):
    t = open(PKG + "\\" + fn, encoding="utf-8").read()
    t = re.sub(r"v_list(\s+)t_list := t_list\(\n.*?\n    \);", lambda m: "v_list" + m.group(1) + "t_list := t_list(\n" + items + "\n    );", t, flags=re.S, count=1)
    t = re.sub(r"^-- \[E20261008-SLASHDEF\].*\n", hdr, t, count=1, flags=re.M)
    if fn.startswith("01"):
        t = t.replace("        IF v_def = '''-''' OR (v_def = '''/''' AND v_onnull <> 'YES') THEN   -- '-' 이면 변경, 이미 '/' 라도 ON NULL 이 없으면 ON NULL 추가",
                      "        IF v_def = '''-''' OR v_def IS NULL OR (v_def = '''/''' AND v_onnull <> 'YES') THEN   -- '-' 또는 DEFAULT 없음 → 변경, 이미 '/' 라도 ON NULL 없으면 ON NULL 추가")
        t = t.replace("현재 DEFAULT 가 '-' 인 것만 '/' 로 바꾼다.", "현재 DEFAULT 가 '-' 이거나 없는 것을 DEFAULT ON NULL '/' 로 바꾼다.")
    open(PKG + "\\" + fn, "w", encoding="utf-8").write(t)
all_by = collections.OrderedDict()
for t, c, *_ in all_slash: all_by.setdefault(t, []).append(c)
open(PKG + r"\01_APPLY_CORP_executed.sql", "w", encoding="utf-8").write(hdr + "-- 사내 ZIOUI1 최종 효과와 동일한 문장 (실제 실행: 1,916 → 39 원복 → 39 ON NULL 재적용 → 89 추가)\n" + ";\n".join(f"ALTER TABLE SCM_MGR.{t} MODIFY (" + ", ".join(f"{c} DEFAULT ON NULL '/'" for c in cs) + ")" for t, cs in all_by.items()) + ";\n")
snap = json.load(open(PKG + r"\00_BEFORE_dictionary_snapshot.json", encoding="utf-8")); onn = {(r['table'], r['column']): r.get('default_on_null') for r in snap['rows']}
def rb(t, c):
    if (t, c) in onn: return f"{c} DEFAULT {'ON NULL ' if onn[(t,c)]=='YES' else ''}'-'"
    return f"{c} DEFAULT NULL"   # 원래 DEFAULT 없던 89
open(PKG + r"\99_ROLLBACK_DEFAULT_to_dash.sql", "w", encoding="utf-8").write(hdr + "-- 원복: 사내 적용 전 상태 = 1,877 DEFAULT ON NULL '-' + 39 DEFAULT '-' + 89 DEFAULT 없음(DEFAULT NULL 로 제거)\n" + ";\n".join(f"ALTER TABLE SCM_MGR.{t} MODIFY (" + ", ".join(rb(t, c) for c in cs) + ")" for t, cs in all_by.items()) + ";\n")
with open(PKG + r"\00_BEFORE_dictionary_snapshot_extra89.csv", "w", newline="", encoding="utf-8-sig") as fh:
    w = csv.writer(fh); w.writerow(["TABLE","COLUMN","DATA_TYPE","NULLABLE","TEMPORARY","BEFORE_DEFAULT"]); [w.writerow([t, c, dt, nul, tmp, "(none)"]) for t, c, dt, nul, tmp in ready]
json.dump(dict(final_target=len(all_slash), tables=tabs, added_no_default=[f"{t}.{c}" for t, c, *_ in ready], at=datetime.datetime.now().isoformat(timespec='seconds')), open(PKG + r"\05_FINAL_SCOPE.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("scripts regenerated:", len(all_slash), "| cloud list:", open(PKG + r"\01_APPLY_CLOUD_idempotent.sql", encoding="utf-8").read().count("        '"))
