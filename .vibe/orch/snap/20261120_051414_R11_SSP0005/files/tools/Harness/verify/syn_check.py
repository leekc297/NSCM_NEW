# -*- coding: utf-8 -*-
"""화면이 BE 계정(SCMP_APP)으로 접근하는 DB 객체의 시노님·권한 정적 검사 (읽기 전용 — 고치지 않는다)

  python tools/Harness/verify/syn_check.py <MENU_ID> [--app SCMP_APP]
  python tools/Harness/verify/syn_check.py --all            # proc_meta 의 전 화면

  사용자 지시(2026-10-26): "시노님이 없어서 오류가 발생하는 것도 오류로 검출 — 지금 수정할 필요 없음"
  배경(2026-10-25 실측): 사내 BE 접속 계정 = SCMP_APP. SCM_MGR 의 외부 스키마 시노님(FP_MGR·INF_MGR·ENG_SCP 대상)이
    SCMP_APP 에 없으면 콤보 SQL 이 ORA-00942 → HTTP 500 "Sql Error". 권한은 롤(RL_FP_SEL 등) 경유일 수 있다(직접 부여만 보면 오판).

  검사 대상(화면이 SCMP_APP 이름으로 부르는 것)
    ① PROC_M 배선 프로시저/패키지(proc_meta.csv) — 이름 해석(SCMP_APP 자기 객체 → SCMP_APP 시노님 → PUBLIC 시노님) + EXECUTE 권한
    ② 콤보 SQL(SCM_ADM_CMBO_SQL_M) 의 FROM/JOIN 객체·함수 — 화면 FE 소스에 쓰인 콤보 ID + SHEET_COLUMNS.CELL_COMBO_DATA_TYPE
       콤보 SQL 은 SCMP_APP 세션에서 그대로 실행되므로 이름 해석 + SELECT/EXECUTE 권한(직접·PUBLIC·롤 경유)
    (PKG 내부 참조는 정의자 권한(SCM_MGR)이라 대상 아님 — 단 PKG 본문 INVALID 는 별도 표기)
  판정: OK / SYN_MISSING(이름 해석 불가 = ORA-00942·PLS-00201) / PRIV_MISSING(해석은 되나 권한 없음 = ORA-01031·ORA-00942)
        / TARGET_MISSING(시노님은 있으나 대상 객체 없음 = ORA-00980) / INVALID(대상 객체 INVALID) / UNKNOWN(판정 불가 — 사유)
  산출: Doc/verify/<ID>/syn_check.csv · 콘솔 요약. 결과는 mapping_trace.py 가 대조표 'DB 접근' 층 증거로 쓴다.
"""
import argparse, csv, os, re, sys
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

DB = os.path.join(ROOT, 'Doc', 'tobefacts', 'db')
ap = argparse.ArgumentParser()
ap.add_argument('menu', nargs='?')
ap.add_argument('--all', action='store_true')
ap.add_argument('--app', default='SCMP_APP')
ap.add_argument('--owner', default='SCM_MGR')
a = ap.parse_args()

rd = lambda f: list(csv.DictReader(open(os.path.join(DB, f), encoding='utf-8-sig')))
SQL_KW = set('SELECT FROM WHERE AND OR NOT NULL IN IS AS ON JOIN LEFT RIGHT INNER OUTER FULL CROSS GROUP BY ORDER HAVING UNION ALL DISTINCT CASE WHEN THEN ELSE END WITH NVL DECODE TO_CHAR TO_DATE TO_NUMBER SUBSTR INSTR TRIM UPPER LOWER COUNT SUM MAX MIN AVG ROWNUM SYSDATE DUAL LIKE BETWEEN EXISTS ASC DESC OVER PARTITION ROW_NUMBER LISTAGG WITHIN REPLACE COALESCE CAST VARCHAR2 NUMBER DATE LEVEL CONNECT PRIOR START REGEXP_SUBSTR REGEXP_LIKE TRUNC ROUND LPAD RPAD NVL2 MINUS INTERSECT FETCH FIRST ROWS ONLY OFFSET'.split())


def tokens_from_sql(sql):
    """FROM/JOIN 뒤 객체 + 함수 호출 이름 + schema.obj 를 후보로. 바인드(:x)·문자열·주석 제거"""
    s = re.sub(r"--[^\n]*", ' ', sql or '')
    s = re.sub(r"/\*.*?\*/", ' ', s, flags=re.S)
    s = re.sub(r"'(?:[^']|'')*'", "''", s)
    s = s.upper()
    out = set()
    for m in re.finditer(r'\b(?:FROM|JOIN)\s+([A-Z][A-Z0-9_$#]*(?:\.[A-Z][A-Z0-9_$#]*)?)', s):
        out.add(m.group(1))
    for m in re.finditer(r'(?:,)\s*([A-Z][A-Z0-9_$#]*(?:\.[A-Z][A-Z0-9_$#]*)?)\s+[A-Z][A-Z0-9_]*\s*(?=,|\bWHERE\b|\bJOIN\b|$)', s):
        out.add(m.group(1))  # FROM a x, b y 형태의 두 번째 이후 테이블
    for m in re.finditer(r'\b([A-Z][A-Z0-9_$#]*(?:\.[A-Z][A-Z0-9_$#]*)?)\s*\(', s):
        out.add(m.group(1))  # 함수 호출(패키지.함수 포함)
    return {t for t in out if t.split('.')[-1] not in SQL_KW}


def main():
    pm = rd('proc_meta.csv')
    menus = sorted({r['menu_id'] for r in pm if r.get('proc')}) if a.all else [a.menu.upper()]
    combos = {r['sql_id']: r for r in rd('combo_sql.csv')}
    with connect('tobe') as cx:
        c = cx.cursor()
        q = lambda sql, **kw: (c.execute(sql, kw), c.fetchall())[1]
        app, owner = a.app, a.owner
        roles = {r[0] for r in q("SELECT GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTEE=:g", g=app)}
        grantees = {app, 'PUBLIC'} | roles
        app_syn = {r[0]: (r[1], r[2]) for r in q("SELECT SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM DBA_SYNONYMS WHERE OWNER=:o", o=app)}
        pub_syn = {r[0]: (r[1], r[2]) for r in q("SELECT SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM DBA_SYNONYMS WHERE OWNER='PUBLIC' AND TABLE_OWNER IN ('SCM_MGR','FP_MGR','INF_MGR','ENG_SCP','SCMD_MGR')")}
        app_obj = {r[0] for r in q("SELECT OBJECT_NAME FROM DBA_OBJECTS WHERE OWNER=:o AND OBJECT_TYPE <> 'SYNONYM'", o=app)}  # 앱 계정의 '시노님'은 자기 객체가 아니다 — 연쇄를 따라 대상 객체 권한까지 봐야 한다(2026-10-29 SCM_LINE_HIERARCHY_CPS_V_SN 허위 OK)
        owner_obj = {}  # SCM_MGR 이름공간(테이블·뷰·패키지·함수·시노님) — 콤보 SQL 토큰 중 '객체 이름' 판별용
        for n, t, st in q("SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM DBA_OBJECTS WHERE OWNER=:o AND OBJECT_TYPE IN ('TABLE','VIEW','PACKAGE','PROCEDURE','FUNCTION','SYNONYM','SEQUENCE','MATERIALIZED VIEW','TYPE')", o=owner):
            owner_obj.setdefault(n, (t, st))
        owner_syn = {r[0]: (r[1], r[2]) for r in q("SELECT SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM DBA_SYNONYMS WHERE OWNER=:o", o=owner)}
        schemas = {r[0] for r in q("SELECT USERNAME FROM DBA_USERS")}
        obj_cache = {}

        def obj_info(ow, nm):
            k = (ow, nm)
            if k not in obj_cache:
                r = q("SELECT OBJECT_TYPE, STATUS FROM DBA_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE NOT IN ('PACKAGE BODY','TYPE BODY') ORDER BY DECODE(OBJECT_TYPE,'SYNONYM',2,1)", o=ow, n=nm)
                obj_cache[k] = r[0] if r else None
            return obj_cache[k]

        def has_priv(ow, nm, kind):
            if ow == app: return True
            privs = ('EXECUTE',) if kind == 'EXEC' else ('SELECT', 'READ')
            r = q(f"SELECT COUNT(*) FROM DBA_TAB_PRIVS WHERE OWNER=:o AND TABLE_NAME=:n AND PRIVILEGE IN ({','.join(repr(p) for p in privs)}) AND GRANTEE IN ({','.join(repr(g) for g in grantees)})", o=ow, n=nm)
            return r[0][0] > 0

        def resolve(name, kind):
            """SCMP_APP 세션에서 name(비한정 또는 schema.obj) 해석 → (판정, 경로, 대상)"""
            if '.' in name:
                sch, nm = name.split('.', 1)
                if obj_info(sch, nm) is None:
                    # 패키지.함수 형태 — 앞부분을 이름으로 해석
                    return resolve(sch, 'EXEC')
                path = [f'{sch}.{nm}']; ow = sch
            else:
                nm = name
                if nm in app_obj: return ('OK', f'{app}.{nm}(자기 객체)', f'{app}.{nm}')
                if nm in app_syn: ow, nm = app_syn[name]; path = [f'{app}.{name}(시노님)→{ow}.{nm}']
                elif nm in pub_syn: ow, nm = pub_syn[name]; path = [f'PUBLIC.{name}(시노님)→{ow}.{nm}']
                else:
                    hint = f" — {owner} 에는 {'시노님 →' + '.'.join(owner_syn[name]) if name in owner_syn else owner_obj.get(name, ('?',))[0]} 로 존재" if (name in owner_syn or name in owner_obj) else ''
                    return ('SYN_MISSING', f'{app}·PUBLIC 시노님 없음{hint}', '')
            for _ in range(4):  # 시노님 연쇄 추적
                info = obj_info(ow, nm)
                if info is None: return ('TARGET_MISSING', ' → '.join(path) + ' (대상 없음)', f'{ow}.{nm}')
                if info[0] == 'SYNONYM':
                    r = q("SELECT TABLE_OWNER, TABLE_NAME FROM DBA_SYNONYMS WHERE OWNER=:o AND SYNONYM_NAME=:n", o=ow, n=nm)
                    if not r: return ('TARGET_MISSING', ' → '.join(path), f'{ow}.{nm}')
                    ow, nm = r[0]; path.append(f'→{ow}.{nm}'); continue
                break
            info = obj_info(ow, nm)
            k = 'EXEC' if info[0] in ('PACKAGE', 'PROCEDURE', 'FUNCTION', 'TYPE') else kind
            if not has_priv(ow, nm, k): return ('PRIV_MISSING', ' '.join(path) + f" ({'EXECUTE' if k == 'EXEC' else 'SELECT'} 권한 없음 — 직접·PUBLIC·롤 {sorted(roles)} 모두)", f'{ow}.{nm}')
            if info[1] != 'VALID': return ('INVALID', ' '.join(path) + f' (상태 {info[1]})', f'{ow}.{nm}')
            return ('OK', ' '.join(path), f'{ow}.{nm}')

        total = {}
        for menu in menus:
            rows = []
            # ① PROC_M 배선
            # 2026-11-13 사용자: 한 화면이 여러 메뉴에 등록돼 있으면 '사용 가능한 메뉴에 등록된 화면' 기준으로 본다.
            #   이 화면(MNU_ID) 행이 USE_YN=N 이어도 같은 화면 경로(ROUTE_PATH)의 다른 메뉴 행이 USE_YN=Y 면 사용 화면이다 → 메뉴·배선을 '없음' 으로 보지 않는다(배선은 이 MNU_ID 행 것을 그대로 쓴다)
            _mrows = rd('menu.csv'); _me = next((x for x in _mrows if (x.get('mnu_id') or '').upper() == menu), None)
            _route = ((_me or {}).get('route_path') or '').strip()
            _alias = [x.get('mnu_id') for x in _mrows if _route and not _route.startswith('-') and (x.get('route_path') or '').strip() == _route and (x.get('mnu_id') or '').upper() != menu and (x.get('use_yn') or 'Y') != 'N']
            _use_ok = lambda u: (u or 'Y') != 'N' or bool(_alias)
            for r in [x for x in pm if x['menu_id'].upper() == menu and x.get('proc') and _use_ok(x.get('use_yn'))]:
                callee = r['pkg'] or r['proc'].split('.')[0]
                v, path, tgt = resolve(callee, 'EXEC')
                rows.append({'menu_id': menu, 'kind': 'PROC', 'source': f"{r['sheet']}/{r['btn']}", 'name': r['proc'], 'resolved': tgt, 'verdict': v, 'path': path, 'error_if_called': {'SYN_MISSING': 'PLS-00201 / ORA-06550', 'PRIV_MISSING': 'PLS-00201 / ORA-01031', 'TARGET_MISSING': 'ORA-00980', 'INVALID': 'ORA-04063 / ORA-06508'}.get(v, '')})
            # ①-b 메타(CR-076, 2026-10-29): 메뉴·PROC_M(SEARCH)·SHEET_COLUMNS 가 없으면 화면이 뜨지도/조회되지도 않는다 → META_MISSING(차단)
            menus_meta = {m['mnu_id'].upper() for m in _mrows if (m.get('use_yn') or 'Y') != 'N'}
            if _alias and menu not in menus_meta: print(f"   [INFO] {menu}: 메뉴 행은 USE_YN=N 이지만 같은 화면 경로({_route})의 사용 메뉴 {', '.join(str(a) for a in _alias)} 가 있어 사용 화면으로 봄")
            if menu not in menus_meta and not _alias:
                rows.append({'menu_id': menu, 'kind': 'META', 'source': 'SCM_ADM_MNU_M', 'name': f'MENU {menu}', 'resolved': '', 'verdict': 'META_MISSING', 'path': '메뉴 메타(SCM_ADM_MNU_M) 에 이 화면 행이 없음(또는 USE_YN=N)', 'error_if_called': '메뉴 미노출 · 화면 진입 불가'})
            pm_menu = [x for x in pm if x['menu_id'].upper() == menu and x.get('proc') and _use_ok(x.get('use_yn'))]
            if not pm_menu:
                rows.append({'menu_id': menu, 'kind': 'META', 'source': 'SCM_ADM_PROC_M/API_M', 'name': f'PROC_M {menu}', 'resolved': '', 'verdict': 'META_MISSING', 'path': '이 화면의 PROC_M/API_M 배선 행이 없음', 'error_if_called': '조회·저장 call-proc 전부 실패'})
            elif not any((x.get('btn') or '').upper().startswith('SEARCH') for x in pm_menu):
                rows.append({'menu_id': menu, 'kind': 'META', 'source': 'SCM_ADM_PROC_M', 'name': f'PROC_M {menu} SEARCH', 'resolved': '', 'verdict': 'META_MISSING', 'path': 'SEARCH 버튼 PROC_M 배선 없음 — 조회 불가', 'error_if_called': '조회 call-proc 실패'})
            sc_rows = [x for x in rd('sheet_columns.csv') if (x.get('program_id') or '').upper() == menu and (x.get('valid_yn') or 'Y') != 'N']
            # SHEET_COLUMNS — 시트별 판정은 룩업 시트(calendar·routeCnt·site 등 컬럼 메타 없음이 정상)와 구분할 근거가 메타에 없어 하지 않는다 → 화면 전체에 컬럼 메타가 0행일 때만 META_MISSING(2026-10-29)
            if pm_menu and any((x.get('btn') or '').upper().startswith('SEARCH') for x in pm_menu) and not sc_rows:
                rows.append({'menu_id': menu, 'kind': 'META', 'source': 'SCM_MST_SHEET_COLUMNS', 'name': f'SHEET_COLUMNS {menu}', 'resolved': '', 'verdict': 'META_MISSING', 'path': '이 화면(PROGRAM_ID)의 컬럼 메타가 0행 — 그리드 컬럼 0', 'error_if_called': '그리드 비어 있음·titleset 실패'})
            # INVALID 패키지는 컴파일 오류 첫 줄을 붙인다(DB 객체 오류를 CheckList 에 그대로 보이게)
            for rr in rows:
                if rr['verdict'] == 'INVALID' and rr.get('resolved'):
                    ow_, nm_ = (rr['resolved'].split('.') + [''])[:2]
                    er = q("SELECT LINE, POSITION, TEXT FROM DBA_ERRORS WHERE OWNER=:o AND NAME=:n AND TYPE IN ('PACKAGE BODY','PACKAGE','PROCEDURE','FUNCTION','VIEW') ORDER BY SEQUENCE FETCH FIRST 1 ROWS ONLY", o=ow_, n=nm_)
                    if er: rr['path'] = (rr['path'] + f" · 컴파일 오류 L{er[0][0]}:{er[0][1]} {str(er[0][2])[:120]}")
            # ② 콤보 SQL — 화면 FE 소스에 쓰인 콤보 ID + 셀 콤보 메타
            ids = set()
            page = None
            for fe in ('features',):
                base = os.path.join(ROOT, 'nscm-fe', fe)
                for d, _, fs in os.walk(base):
                    if 'node_modules' in d or os.sep + 'dist' in d: continue
                    for f in fs:
                        if f.endswith('.constants.ts'):
                            p = os.path.join(d, f)
                            try:
                                t = open(p, encoding='utf-8').read()
                            except Exception:
                                continue
                            if re.search(r"MENU_ID\s*=\s*'%s'" % menu, t): page = d
                    if page: break
            if page:
                for d, _, fs in os.walk(page):
                    for f in fs:
                        if f.endswith(('.ts', '.tsx')):
                            t = open(os.path.join(d, f), encoding='utf-8', errors='ignore').read()
                            for m in re.finditer(r"'([A-Za-z0-9_]+)'", t):
                                if m.group(1) in combos: ids.add(m.group(1))
            for (cid,) in q("SELECT DISTINCT CELL_COMBO_DATA_TYPE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m AND CELL_COMBO_DATA_TYPE IS NOT NULL", m=menu):
                if cid in combos: ids.add(cid)
            for cid in sorted(ids):
                for tok in sorted(tokens_from_sql(combos[cid]['sql_dtl_ctn'])):
                    # 한정명 X.Y: X 가 스키마면 schema.obj · X 가 패키지(이름공간에 존재)면 패키지.함수 → 패키지로 해석 · 그 외(별칭.컬럼)는 객체 아님
                    if '.' in tok:
                        x = tok.split('.')[0]
                        if x in schemas: pass
                        elif x in owner_obj or x in owner_syn or x in app_syn or x in pub_syn or x in app_obj: tok = x
                        else: continue
                    else:
                        if not (tok in owner_obj or tok in owner_syn or tok in app_syn or tok in pub_syn or tok in app_obj): continue  # 컬럼 별칭·인라인 뷰 이름 등
                    v, path, tgt = resolve(tok, 'SELECT')
                    rows.append({'menu_id': menu, 'kind': 'COMBO', 'source': cid, 'name': tok, 'resolved': tgt, 'verdict': v, 'path': path, 'error_if_called': {'SYN_MISSING': 'ORA-00942 / ORA-00904', 'PRIV_MISSING': 'ORA-00942 / ORA-01031', 'TARGET_MISSING': 'ORA-00980', 'INVALID': 'ORA-04063'}.get(v, '')})
            if not page: rows.append({'menu_id': menu, 'kind': 'NOTE', 'source': '', 'name': '', 'resolved': '', 'verdict': 'UNKNOWN', 'path': 'FE 페이지(MENU_ID 상수)를 찾지 못해 화면 콤보는 셀 메타만 검사', 'error_if_called': ''})
            od = os.path.join(ROOT, 'Doc', 'verify', menu); os.makedirs(od, exist_ok=True)
            cols = ['menu_id', 'kind', 'source', 'name', 'resolved', 'verdict', 'path', 'error_if_called']
            with open(os.path.join(od, 'syn_check.csv'), 'w', encoding='utf-8-sig', newline='') as fp:
                w = csv.DictWriter(fp, fieldnames=cols); w.writeheader(); [w.writerow(r) for r in rows]
            bad = [r for r in rows if r['verdict'] not in ('OK',)]
            total[menu] = (len(rows), len(bad))
            print(f"{menu}: 검사 {len(rows)} · 문제 {len(bad)}" + ''.join(f"\n   [{r['verdict']}] {r['kind']} {r['source']} {r['name']} — {r['path'][:110]}" for r in bad[:12]) + (f"\n   … +{len(bad) - 12}" if len(bad) > 12 else ''))
        if len(menus) > 1:
            print(f'전체 {len(menus)}화면 · 문제 있는 화면 {sum(1 for v in total.values() if v[1])} · 문제 행 {sum(v[1] for v in total.values())}')


if __name__ == '__main__':
    main()
