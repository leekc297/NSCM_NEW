import json, sys, collections, datetime, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
PKG = r"C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DEFAULT_20261008"
snap = json.load(open(PKG + r"\00_BEFORE_dictionary_snapshot.json", encoding="utf-8")); rows = [r for r in snap['rows'] if r['status'] == 'READY']
no_onnull = [r for r in rows if r['default_on_null'] != 'YES']; keep = [r for r in rows if r['default_on_null'] == 'YES']
print("ON NULL=YES 대상:", len(keep), "| ON NULL 아님(원복 대상):", len(no_onnull), "| 테이블:", sorted({r['table'] for r in no_onnull}))
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
# 1) 39 컬럼 '-' 로 원복 (사내)
by_tab = collections.OrderedDict()
for r in no_onnull: by_tab.setdefault(r['table'], []).append(r['column'])
rb = [f"ALTER TABLE SCM_MGR.{t} MODIFY (" + ", ".join(f"{c} DEFAULT '-'" for c in cs) + ")" for t, cs in by_tab.items()]
ok = 0; errs = []
for st in rb:
    try: cur.execute(st); ok += 1
    except Exception as e: errs.append((st[:100], str(e)[:150]))
print(f"원복 실행: ok={ok}/{len(rb)} err={errs}")
cur.execute("SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); inv = cur.fetchall()
before = set(json.load(open(PKG + r"\00_BEFORE_invalid_objects.json", encoding="utf-8"))); new = [(t, n) for t, n in inv if f"{t} {n}" not in before]
for ot, on_ in sorted(new, key=lambda x: {'TYPE':1,'VIEW':2,'PACKAGE':3,'FUNCTION':4,'PROCEDURE':5,'PACKAGE BODY':6}.get(x[0], 9)):
    base = {'PACKAGE BODY':'PACKAGE','TYPE BODY':'TYPE'}.get(ot, ot); body = ' BODY' if ot.endswith('BODY') else ''
    try: cur.execute(f"ALTER {base} SCM_MGR.{on_} COMPILE{body}")
    except Exception as e: print("compile fail", ot, on_, str(e)[:100])
cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); print("INVALID now:", cur.fetchone()[0], "(recompiled newly-invalid:", len(new), ")")
# 2) 최종 상태 검증: 1,877 은 '/', 39 는 '-'
def dist(lst):
    c = collections.Counter()
    for i in range(0, len(lst), 500):
        ch = lst[i:i+500]; b = {}; pr = []
        for k, r in enumerate(ch): b[f"t{k}"] = r['table']; b[f"c{k}"] = r['column']; pr.append(f"(table_name=:t{k} AND column_name=:c{k})")
        cur.execute("SELECT data_default, default_on_null FROM all_tab_columns WHERE owner='SCM_MGR' AND (" + " OR ".join(pr) + ")", b)
        for df, on in cur.fetchall(): c[((df or '').strip(), on)] += 1
    return dict(c)
print("최종 1,877(ON NULL YES):", dist(keep)); print("최종 39(ON NULL 아님, 원복):", dist(no_onnull))
# 3) 패키지 스크립트 1,877 기준으로 재생성 (ON NULL YES 만, 클라우드도 DEFAULT_ON_NULL='YES' 조건 추가)
items = ",\n".join("        '" + f"{r['table']}.{r['column']}" + "'" for r in keep)
for fn in ("01_APPLY_CLOUD_idempotent.sql", "02_VERIFY.sql"):
    t = open(PKG + "\\" + fn, encoding="utf-8").read()
    t = re.sub(r"v_list\s+t_list := t_list\(\n.*?\n    \);", "v_list t_list := t_list(\n" + items + "\n    );", t, flags=re.S, count=1)
    t = re.sub(r"v_list t_list := t_list\(\n.*?\n    \);", "v_list t_list := t_list(\n" + items + "\n    );", t, flags=re.S, count=1)
    t = t.replace("= 1916컬럼/262테이블", f"= {len(keep)}컬럼/{len({r['table'] for r in keep})}테이블 — ON NULL=YES 만(사용자 확정 10-08)")
    if fn.startswith("01"):
        t = t.replace("        IF v_def = '''-''' THEN\n            v_sql", "        IF v_onnull <> 'YES' THEN\n            n_other := n_other + 1; DBMS_OUTPUT.PUT_LINE('NOT_ON_NULL | ' || v_list(i) || ' (대상 아님, 변경 안 함)');\n        ELSIF v_def = '''-''' THEN\n            v_sql")
    open(PKG + "\\" + fn, "w", encoding="utf-8").write(t)
by_tab_k = collections.OrderedDict()
for r in keep: by_tab_k.setdefault(r['table'], []).append(r['column'])
hdr = f"-- [E20261008-SLASHDEF] NULL 센티널 DEFAULT '-' -> '/' (1_DEFAULT 시트: 현재 '-' & 적용 '/' & ON NULL=YES = {len(keep)}컬럼/{len(by_tab_k)}테이블). 데이터 변경 없음(메타만). {datetime.datetime.now():%Y-%m-%d %H:%M}\n"
open(PKG + r"\01_APPLY_CORP_executed.sql", "w", encoding="utf-8").write(hdr + "-- 사내 ZIOUI1 실행 문장 (1차 1,916 적용 후 ON NULL 아닌 39 컬럼은 '-' 로 원복 → 최종 효과 = 아래 1,877)\n" + ";\n".join(f"ALTER TABLE SCM_MGR.{t} MODIFY (" + ", ".join(f"{c} DEFAULT ON NULL '/'" for c in cs) + ")" for t, cs in by_tab_k.items()) + ";\n")
open(PKG + r"\99_ROLLBACK_DEFAULT_to_dash.sql", "w", encoding="utf-8").write(hdr + "-- 원복: 1,877 컬럼을 DEFAULT ON NULL '-' 로\n" + ";\n".join(f"ALTER TABLE SCM_MGR.{t} MODIFY (" + ", ".join(f"{c} DEFAULT ON NULL '-'" for c in cs) + ")" for t, cs in by_tab_k.items()) + ";\n")
json.dump(dict(final_target=len(keep), tables=len(by_tab_k), reverted_not_on_null=[f"{r['table']}.{r['column']}" for r in no_onnull], at=datetime.datetime.now().isoformat(timespec='seconds')), open(PKG + r"\05_FINAL_SCOPE.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("scripts regenerated for", len(keep))
