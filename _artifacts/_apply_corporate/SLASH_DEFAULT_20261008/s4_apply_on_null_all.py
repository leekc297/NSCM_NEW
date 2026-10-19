import json, sys, collections, datetime, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
PKG = r"C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DEFAULT_20261008"
snap = json.load(open(PKG + r"\00_BEFORE_dictionary_snapshot.json", encoding="utf-8")); rows = [r for r in snap['rows'] if r['status'] == 'READY']
no_onnull = [r for r in rows if r['default_on_null'] != 'YES']
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
by_tab = collections.OrderedDict()
for r in no_onnull: by_tab.setdefault(r['table'], []).append(r['column'])
stmts = [f"ALTER TABLE SCM_MGR.{t} MODIFY (" + ", ".join(f"{c} DEFAULT ON NULL '/'" for c in cs) + ")" for t, cs in by_tab.items()]
ok = 0; errs = []
for st in stmts:
    try: cur.execute(st); ok += 1
    except Exception as e: errs.append((st[:100], str(e)[:160]))
print(f"39 컬럼 DEFAULT ON NULL '/' 적용: ok={ok}/{len(stmts)} err={errs}")
before = set(json.load(open(PKG + r"\00_BEFORE_invalid_objects.json", encoding="utf-8")))
for _ in range(2):
    cur.execute("SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); new = [(t, n) for t, n in cur.fetchall() if f"{t} {n}" not in before]
    for ot, on_ in sorted(new, key=lambda x: {'TYPE':1,'VIEW':2,'PACKAGE':3,'FUNCTION':4,'PROCEDURE':5,'PACKAGE BODY':6}.get(x[0], 9)):
        base = {'PACKAGE BODY':'PACKAGE','TYPE BODY':'TYPE'}.get(ot, ot); body = ' BODY' if ot.endswith('BODY') else ''
        try: cur.execute(f"ALTER {base} SCM_MGR.{on_} COMPILE{body}")
        except Exception as e: print("compile fail", ot, on_, str(e)[:100])
    if not new: break
cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); print("INVALID now:", cur.fetchone()[0], "(사전 INVALID 48 과 동일해야 함)")
c = collections.Counter()
for i in range(0, len(rows), 500):
    ch = rows[i:i+500]; b = {}; pr = []
    for k, r in enumerate(ch): b[f"t{k}"] = r['table']; b[f"c{k}"] = r['column']; pr.append(f"(table_name=:t{k} AND column_name=:c{k})")
    cur.execute("SELECT data_default, default_on_null FROM all_tab_columns WHERE owner='SCM_MGR' AND (" + " OR ".join(pr) + ")", b)
    for df, on in cur.fetchall(): c[((df or '').strip(), on)] += 1
print("최종 1,916 상태:", dict(c))
# 스크립트 1,916 기준·ON NULL 강제 로 재생성
items = ",\n".join("        '" + f"{r['table']}.{r['column']}" + "'" for r in rows)
by_all = collections.OrderedDict()
for r in rows: by_all.setdefault(r['table'], []).append(r['column'])
hdr = f"-- [E20261008-SLASHDEF] NULL 센티널 DEFAULT '-' -> '/' + ON NULL 일괄 (1_DEFAULT 시트: 현재 '-' & 적용 '/' = {len(rows)}컬럼/{len(by_all)}테이블; ON NULL 없던 39 컬럼도 ON NULL 추가 — 사용자 확정 10-08). 데이터 변경 없음(메타만). {datetime.datetime.now():%Y-%m-%d %H:%M}\n"
open(PKG + r"\01_APPLY_CORP_executed.sql", "w", encoding="utf-8").write(hdr + "-- 사내 ZIOUI1 최종 효과와 동일한 문장 (실제 실행은 1,916 적용 → 39 원복 → 39 ON NULL 재적용 순)\n" + ";\n".join(f"ALTER TABLE SCM_MGR.{t} MODIFY (" + ", ".join(f"{c} DEFAULT ON NULL '/'" for c in cs) + ")" for t, cs in by_all.items()) + ";\n")
open(PKG + r"\99_ROLLBACK_DEFAULT_to_dash.sql", "w", encoding="utf-8").write(hdr + "-- 원복: 사내 적용 전 상태 = 1,877 컬럼 DEFAULT ON NULL '-' + 39 컬럼 DEFAULT '-'(ON NULL 없음). 00_BEFORE 스냅샷 근거\n" + ";\n".join(f"ALTER TABLE SCM_MGR.{t} MODIFY (" + ", ".join(f"{c} DEFAULT {'ON NULL ' if next(x for x in rows if x['table']==t and x['column']==c)['default_on_null']=='YES' else ''}'-'" for c in cs) + ")" for t, cs in by_all.items()) + ";\n")
for fn in ("01_APPLY_CLOUD_idempotent.sql", "02_VERIFY.sql"):
    t = open(PKG + "\\" + fn, encoding="utf-8").read()
    t = re.sub(r"v_list(\s+)t_list := t_list\(\n.*?\n    \);", lambda m: "v_list" + m.group(1) + "t_list := t_list(\n" + items + "\n    );", t, flags=re.S, count=1)
    t = re.sub(r"^-- \[E20261008-SLASHDEF\].*\n", hdr, t, count=1, flags=re.M)
    if fn.startswith("01"):
        t = t.replace("        IF v_onnull <> 'YES' THEN\n            n_other := n_other + 1; DBMS_OUTPUT.PUT_LINE('NOT_ON_NULL | ' || v_list(i) || ' (대상 아님, 변경 안 함)');\n        ELSIF v_def = '''-''' THEN", "        IF v_def = '''-''' OR (v_def = '''/''' AND v_onnull <> 'YES') THEN   -- '-' 이면 변경, 이미 '/' 라도 ON NULL 이 없으면 ON NULL 추가")
        t = t.replace("|| ' DEFAULT ' || CASE WHEN v_onnull = 'YES' THEN 'ON NULL ' END || '''/'')'", "|| ' DEFAULT ON NULL ''/'')'   -- ON NULL 일괄 적용(사용자 확정 10-08)")
        t = t.replace("ON NULL 여부는 그 DB 의 DEFAULT_ON_NULL 플래그를 그대로 따른다(사내 값 전제 없음).", "ON NULL 은 일괄 적용(없던 컬럼도 추가). 이미 '/' 인데 ON NULL 만 없는 컬럼도 보정.")
        t = t.replace("        ELSIF v_def = '''/''' THEN\n            n_already := n_already + 1;", "        ELSIF v_def = '''/''' THEN\n            n_already := n_already + 1;   -- 이미 '/' + ON NULL")
    else:
        t = t.replace("IF v_def = '''/''' THEN n_slash := n_slash + 1; IF v_onnull = 'YES' THEN n_onnull := n_onnull + 1; END IF;", "IF v_def = '''/''' THEN n_slash := n_slash + 1; IF v_onnull = 'YES' THEN n_onnull := n_onnull + 1; ELSE DBMS_OUTPUT.PUT_LINE('NO_ON_NULL | ' || v_list(i)); END IF;")
        t = t.replace("(전부 '/' 이어야 함)", "(전부 '/' 이고 on_null 도 전부 YES 이어야 함)")
    open(PKG + "\\" + fn, "w", encoding="utf-8").write(t)
json.dump(dict(final_target=len(rows), tables=len(by_all), on_null_added=[f"{r['table']}.{r['column']}" for r in no_onnull], at=datetime.datetime.now().isoformat(timespec='seconds')), open(PKG + r"\05_FINAL_SCOPE.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("scripts regenerated for", len(rows), "| cloud list count:", open(PKG + r"\01_APPLY_CLOUD_idempotent.sql", encoding="utf-8").read().count("        '"))
