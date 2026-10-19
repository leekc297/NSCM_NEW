import json, sys, collections, datetime, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
PKG = r"C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DEFAULT_20261008"
snap = json.load(open(PKG + r"\00_BEFORE_dictionary_snapshot.json", encoding="utf-8")); rows = [r for r in snap['rows'] if r['status'] == 'READY']
assert len(rows) == 1916
by_tab = collections.OrderedDict()
for r in rows: by_tab.setdefault(r['table'], []).append(r)
def ddl(tn, cols, val):
    return f"ALTER TABLE SCM_MGR.{tn} MODIFY (" + ", ".join(f"{c['column']} DEFAULT {'ON NULL ' if c['default_on_null']=='YES' else ''}'{val}'" for c in cols) + ")"
apply_stmts = [ddl(t, cs, '/') for t, cs in by_tab.items()]
rollback_stmts = [ddl(t, cs, '-') for t, cs in by_tab.items()]
hdr = f"-- [E20261008-SLASHDEF] NULL 센티널 DEFAULT '-' -> '/' (1_DEFAULT 시트, 현재 '-' & 적용 '/' = {len(rows)}컬럼/{len(by_tab)}테이블). 데이터 변경 없음(메타만). 생성 {datetime.datetime.now():%Y-%m-%d %H:%M}\n"
open(PKG + r"\01_APPLY_CORP_executed.sql", "w", encoding="utf-8").write(hdr + "-- 사내 ZIOUI1 에서 실제 실행한 문장 (테이블 단위 MODIFY, 컬럼별 ON NULL 은 사전 플래그 그대로)\n" + ";\n".join(apply_stmts) + ";\n")
open(PKG + r"\99_ROLLBACK_DEFAULT_to_dash.sql", "w", encoding="utf-8").write(hdr + "-- 원복: 같은 컬럼을 '-' 로 되돌림 (사내 적용 전 전부 '-' 였음, 00_BEFORE 스냅샷 근거)\n" + ";\n".join(rollback_stmts) + ";\n")
# 클라우드용 멱등 블록: 실행 시점 사전을 읽어 현재 DEFAULT 가 '-' 인 컬럼만 변경, ON NULL 은 그 DB 의 플래그 그대로
items = ",\n".join("        '" + f"{r['table']}.{r['column']}" + "'" for r in rows)
cloud = hdr + f"""-- 클라우드 DEV/QA 적용용 — 멱등. SCM_MGR 로 접속, SET SERVEROUTPUT ON 후 실행. 각 컬럼을 실행 시점 사전(ALL_TAB_COLUMNS)으로 확인해
--   현재 DEFAULT 가 '-' 인 것만 '/' 로 바꾼다. ON NULL 여부는 그 DB 의 DEFAULT_ON_NULL 플래그를 그대로 따른다(사내 값 전제 없음).
--   테이블/컬럼이 없으면 MISSING, 이미 '/' 면 ALREADY, 다른 DEFAULT 면 OTHER(변경 안 함), 오류(예: GTT 사용 중 ORA-14450)는 ERROR 로 집계·출력.
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    TYPE t_list IS TABLE OF VARCHAR2(130);
    v_list      t_list := t_list(
{items}
    );
    v_tn        VARCHAR2(128); v_cn VARCHAR2(128);
    v_def       VARCHAR2(4000); v_onnull VARCHAR2(3); v_nullable VARCHAR2(1); v_tmp VARCHAR2(1);
    v_sql       VARCHAR2(1000);
    n_alter     PLS_INTEGER := 0; n_already PLS_INTEGER := 0; n_other PLS_INTEGER := 0; n_miss PLS_INTEGER := 0; n_err PLS_INTEGER := 0;
BEGIN
    FOR i IN 1 .. v_list.COUNT LOOP
        v_tn := SUBSTR(v_list(i), 1, INSTR(v_list(i), '.') - 1);
        v_cn := SUBSTR(v_list(i), INSTR(v_list(i), '.') + 1);
        BEGIN
            SELECT c.data_default, c.default_on_null, c.nullable, t.temporary
              INTO v_def, v_onnull, v_nullable, v_tmp
              FROM all_tab_columns c JOIN all_tables t ON t.owner = c.owner AND t.table_name = c.table_name
             WHERE c.owner = 'SCM_MGR' AND c.table_name = v_tn AND c.column_name = v_cn;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            n_miss := n_miss + 1; DBMS_OUTPUT.PUT_LINE('MISSING | ' || v_list(i)); CONTINUE;
        END;
        v_def := TRIM(v_def);
        IF v_def = '''-''' THEN
            v_sql := 'ALTER TABLE SCM_MGR.' || v_tn || ' MODIFY (' || v_cn || ' DEFAULT ' || CASE WHEN v_onnull = 'YES' THEN 'ON NULL ' END || '''/'')';
            BEGIN
                EXECUTE IMMEDIATE v_sql; n_alter := n_alter + 1;
            EXCEPTION WHEN OTHERS THEN
                n_err := n_err + 1; DBMS_OUTPUT.PUT_LINE('ERROR   | ' || v_list(i) || ' | ' || SQLERRM || ' | ' || v_sql);
            END;
        ELSIF v_def = '''/''' THEN
            n_already := n_already + 1;
        ELSE
            n_other := n_other + 1; DBMS_OUTPUT.PUT_LINE('OTHER   | ' || v_list(i) || ' | default=' || NVL(v_def, 'NULL') || ' (변경 안 함)');
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('SUMMARY | total=' || v_list.COUNT || ' altered=' || n_alter || ' already=' || n_already || ' other=' || n_other || ' missing=' || n_miss || ' error=' || n_err);
END;
/
"""
open(PKG + r"\01_APPLY_CLOUD_idempotent.sql", "w", encoding="utf-8").write(cloud)
verify = hdr + f"""-- 적용 후 검증 (조회 전용). V1 = 대상 {len(rows)}컬럼의 현재 DEFAULT 분포(전부 '/' 이어야 함) · V2 = INVALID 객체 · V3 = 샘플 5컬럼 원문
SET PAGESIZE 0 LINESIZE 300 HEADING OFF FEEDBACK OFF SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    TYPE t_list IS TABLE OF VARCHAR2(130);
    v_list t_list := t_list(
{items}
    );
    v_def VARCHAR2(4000); v_onnull VARCHAR2(3); n_slash PLS_INTEGER := 0; n_dash PLS_INTEGER := 0; n_other PLS_INTEGER := 0; n_miss PLS_INTEGER := 0; n_onnull PLS_INTEGER := 0;
BEGIN
    FOR i IN 1 .. v_list.COUNT LOOP
        BEGIN
            SELECT data_default, default_on_null INTO v_def, v_onnull FROM all_tab_columns
             WHERE owner = 'SCM_MGR' AND table_name = SUBSTR(v_list(i), 1, INSTR(v_list(i), '.') - 1) AND column_name = SUBSTR(v_list(i), INSTR(v_list(i), '.') + 1);
            v_def := TRIM(v_def);
            IF v_def = '''/''' THEN n_slash := n_slash + 1; IF v_onnull = 'YES' THEN n_onnull := n_onnull + 1; END IF;
            ELSIF v_def = '''-''' THEN n_dash := n_dash + 1; DBMS_OUTPUT.PUT_LINE('STILL_DASH | ' || v_list(i));
            ELSE n_other := n_other + 1; DBMS_OUTPUT.PUT_LINE('OTHER | ' || v_list(i) || ' | ' || NVL(v_def, 'NULL')); END IF;
        EXCEPTION WHEN NO_DATA_FOUND THEN n_miss := n_miss + 1; DBMS_OUTPUT.PUT_LINE('MISSING | ' || v_list(i));
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('V1 | total=' || v_list.COUNT || ' slash=' || n_slash || ' (on_null=' || n_onnull || ') dash=' || n_dash || ' other=' || n_other || ' missing=' || n_miss);
END;
/
SELECT 'V2 | INVALID ' || object_type || ' ' || object_name || ' | ddl=' || TO_CHAR(last_ddl_time, 'MM-DD HH24:MI') FROM all_objects WHERE owner = 'SCM_MGR' AND status = 'INVALID' ORDER BY object_type, object_name;
SELECT 'V3 | ' || table_name || '.' || column_name || ' | ' || data_default || ' | on_null=' || default_on_null FROM all_tab_columns WHERE owner = 'SCM_MGR' AND (table_name, column_name) IN (('DM_ANL_CAR_FCST_REF','CAR_MODEL'),('DM_PLN_MKT_FCST','PLANT_SITE_ID'),('DM_PLN_CFM_MKT_DEMAND_PLAN','END_CUSTOMER'),('SCM_MST_FUTURE_PRICE','PLANT_SITE_ID'),('SCM_MST_SITE_H','VALID_YN'));
"""
open(PKG + r"\02_VERIFY.sql", "w", encoding="utf-8").write(verify)
recomp = hdr + """-- 적용 뒤 INVALID 객체 재컴파일 (SCM_MGR 소유 INVALID 전부, 2회 반복). DDL 로 무효화된 의존 PKG/PROC/VIEW 를 바로 되살린다.
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    n PLS_INTEGER;
BEGIN
    FOR pass IN 1 .. 2 LOOP
        n := 0;
        FOR o IN (SELECT object_type, object_name FROM all_objects WHERE owner = 'SCM_MGR' AND status = 'INVALID' AND object_type IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','VIEW','TRIGGER','TYPE','TYPE BODY') ORDER BY DECODE(object_type,'TYPE',1,'VIEW',2,'PACKAGE',3,'FUNCTION',4,'PROCEDURE',5,'PACKAGE BODY',6,'TYPE BODY',7,8), object_name) LOOP
            BEGIN
                EXECUTE IMMEDIATE 'ALTER ' || CASE o.object_type WHEN 'PACKAGE BODY' THEN 'PACKAGE' WHEN 'TYPE BODY' THEN 'TYPE' ELSE o.object_type END || ' SCM_MGR.' || o.object_name || ' COMPILE' || CASE o.object_type WHEN 'PACKAGE BODY' THEN ' BODY' WHEN 'TYPE BODY' THEN ' BODY' END;
                n := n + 1;
            EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('COMPILE FAIL | ' || o.object_type || ' ' || o.object_name || ' | ' || SQLERRM);
            END;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('pass ' || pass || ' compiled=' || n);
    END LOOP;
    SELECT COUNT(*) INTO n FROM all_objects WHERE owner = 'SCM_MGR' AND status = 'INVALID';
    DBMS_OUTPUT.PUT_LINE('remaining INVALID=' || n || ' (적용 전부터 INVALID 였던 객체는 본 작업과 무관 — 원인 분류는 06_CLOUD_INVALID_DIAG.sql · 사내 기준선 48 → 최종 5)');
END;
/
"""
open(PKG + r"\03_RECOMPILE_INVALID.sql", "w", encoding="utf-8").write(recomp)
# ---------- 사내 적용 ----------
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute("SELECT object_type||' '||object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); inv_before = {r[0] for r in cur.fetchall()}
json.dump(sorted(inv_before), open(PKG + r"\00_BEFORE_invalid_objects.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
t0 = time.time(); ok = 0; errs = []
for i, st in enumerate(apply_stmts):
    try: cur.execute(st); ok += 1
    except Exception as e: errs.append((st[:120], str(e)[:200]))
print(f"APPLIED tables ok={ok} err={len(errs)} in {time.time()-t0:.1f}s"); [print("  ERR", e) for e in errs]
# 검증
slash = dash = other = 0; onn = 0
for i in range(0, len(rows), 500):
    chunk = rows[i:i+500]; binds = {}; preds = []
    for k, r in enumerate(chunk): binds[f"t{k}"] = r['table']; binds[f"c{k}"] = r['column']; preds.append(f"(table_name=:t{k} AND column_name=:c{k})")
    cur.execute("SELECT table_name, column_name, data_default, default_on_null FROM all_tab_columns WHERE owner='SCM_MGR' AND (" + " OR ".join(preds) + ")", binds)
    for tn, cn, df, on in cur.fetchall():
        df = (df or '').strip()
        if df == "'/'": slash += 1; onn += (on == 'YES')
        elif df == "'-'": dash += 1
        else: other += 1
print(f"VERIFY after: slash={slash} (on_null={onn}) dash={dash} other={other} of {len(rows)}")
cur.execute("SELECT object_type||' '||object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); inv_after = {r[0] for r in cur.fetchall()}
new_inv = sorted(inv_after - inv_before); print(f"INVALID after DDL: {len(inv_after)} (new {len(new_inv)})")
# 새로 INVALID 된 것만 재컴파일 (2회)
for p_ in range(2):
    cur.execute("SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID' AND object_type||' '||object_name NOT IN (" + ",".join("'"+x.replace("'","''")+"'" for x in inv_before) + ")") if inv_before else cur.execute("SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
    todo = cur.fetchall(); order = {'TYPE':1,'VIEW':2,'PACKAGE':3,'FUNCTION':4,'PROCEDURE':5,'PACKAGE BODY':6,'TYPE BODY':7}
    todo.sort(key=lambda x: (order.get(x[0], 9), x[1])); c = 0
    for ot, on_ in todo:
        base = {'PACKAGE BODY':'PACKAGE','TYPE BODY':'TYPE'}.get(ot, ot); body = ' BODY' if ot in ('PACKAGE BODY','TYPE BODY') else ''
        try: cur.execute(f"ALTER {base} SCM_MGR.{on_} COMPILE{body}"); c += 1
        except Exception as e: print("  compile fail", ot, on_, str(e)[:120])
    print(f"recompile pass {p_+1}: {c} objects")
cur.execute("SELECT object_type||' '||object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); inv_final = {r[0] for r in cur.fetchall()}
still_new = sorted(inv_final - inv_before); print(f"INVALID final: {len(inv_final)} | newly-invalid remaining: {len(still_new)} {still_new[:10]}")
json.dump(dict(applied_at=datetime.datetime.now().isoformat(timespec='seconds'), tables_ok=ok, errors=errs, verify=dict(slash=slash, on_null=onn, dash=dash, other=other), invalid_before=len(inv_before), invalid_after_ddl=len(inv_after), newly_invalid=new_inv, invalid_final=len(inv_final), newly_invalid_remaining=still_new), open(PKG + r"\04_CORP_APPLY_RESULT.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
