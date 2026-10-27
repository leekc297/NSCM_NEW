# -*- coding: utf-8 -*-
"""2a — 액션 → DB 정적 연결 (사용자 지시 2026-10-23: 조회조건·콤보는 DB 안에서 2~3단계를 거쳐야 실제 결과가 나오므로 그 연결까지 담는다)

입력(AsisFacts 산출, 읽기 전용): screens/<ID>/actions.csv · framework_actions/actions.csv · foxquery_endpoints/params/sql_refs.csv ·
      endpoint_usage.csv · calls.csv(03.BIZ) · db/db_module_refs.csv · db/db_code_branches.csv · db/db_params.csv · db/meta/dbo.SCM_ADM_DQ_LIST.csv
출력: screens/<ID>/action_links.csv — 액션 1건이 DB 까지 닿는 체인(홉 단위 1행)
  hop 종류
   PARAM        엔드포인트 요청 파라미터(이름=값 식) — 같은 메서드에서 요청 생성 뒤 Parameters 에 넣은 값
   FW_METHOD    프레임워크 메서드 진입(DataService.GetDMInnerTable 등) · FW_CASE = 넘긴 코드값과 일치하는 switch case 안의 동작(필터·컬럼)
   ENDPOINT     FoxQuery 키 · BIZ(biz:Class.Method) → BLL → DLL → 키
   SP / SQL     엔드포인트가 실행하는 SP 또는 인라인 SQL(참조 테이블)
   SP_BRANCH    SP 안 IF @변수 = '값' 분기 — 넘긴 코드값과 일치(MATCH) / 값 미확정이면 후보(CANDIDATE)
   SP_REF       SP(·하위 SP, 최대 4단계)가 읽고/쓰는 테이블·호출하는 SP
   STORED_QUERY 테이블에 저장된 쿼리(SCM_ADM_DQ_LIST.DQ_TEXT)를 읽는 SP — DQ 행 수·이름
   DATA_SOURCE  목록/그리드 바인딩(LIST_REBIND·GRID_BIND·LIST_BIND)에 넣는 변수가 채워진 행(화면 필드 대입) → 그 행의 체인으로 이어짐
  status: RESOLVED / CANDIDATE(값 미확정 분기 후보) / UNRESOLVED(원천에 없음 — 사유 detail)
한계(명시): 지역 변수 선언(var dt = X())으로 채운 목록 데이터 원천은 아직 추적하지 않음(화면 필드만) · 동적 문자열로 만든 키/SQL 은 UNRESOLVED
사용: python links.py [화면ID ...]   (없으면 전체)
"""
import csv, os, re, sys, collections

csv.field_size_limit(10 ** 9)
OUT = r'C:\Projects\NSCM\Doc\asisfacts'
R = lambda f: csv.DictReader(open(os.path.join(OUT, f), encoding='utf-8-sig'))
norm = lambda s: re.sub(r'^\[?dbo\]?\.', '', (s or '').strip(), flags=re.I).strip('[]').upper()

print('loading facts…', flush=True)
FQ = {r['key']: r for r in R('foxquery_endpoints.csv') if r['commented'] == '0'}
FQI = {k.upper(): v for k, v in FQ.items()}  # 키 대소문자 무시(화면 코드 'DM.UP_FX_GetCommonDataList_DM' ↔ foxml 'UP_FX_GETCOMMONDATALIST_DM')
FQP = collections.defaultdict(list)
for r in R('foxquery_params.csv'):
    if r['commented'] == '0': FQP[r['key'].upper()].append(r['name'])
FQR = collections.defaultdict(list)
for r in R('foxquery_sql_refs.csv'):
    if r['ref_kind'] != 'NONE': FQR[r['key'].upper()].append((r['ref_kind'], r['access'], r['name']))
# DB 사실 자료: SCM(LGCE_SCMDEV, db/) + FP(LGCE_FPDEV_TR, _fpdb/db/ — FP 계열 SP 가 있는 같은 서버의 DB, 2026-10-23 읽기 전용 추출)
#   같은 이름이 양쪽에 있으면 SCM 우선. MDB = 객체가 속한 DB(행 detail 에 표기)
MREF = collections.defaultdict(list); BR = collections.defaultdict(list); DBP = collections.defaultdict(list); MDB = {}
for dbname, sub in (('LGCE_SCMDEV', 'db'), ('LGCE_FPDEV_TR', '_fpdb/db')):
    if not os.path.exists(os.path.join(OUT, sub, 'db_module_refs.csv')): continue
    seen_db = set(MDB)
    loc = collections.defaultdict(list)
    for r in R(f'{sub}/db_module_refs.csv'): loc[norm(r['module'])].append((r['ref_kind'], r['access'], r['name']))
    for k, v in loc.items():
        if k not in seen_db: MREF[k] = v; MDB[k] = dbname
    for r in R(f'{sub}/db_code_branches.csv'):
        if MDB.get(norm(r['module'])) == dbname: BR[norm(r['module'])].append(r)
    for r in R(f'{sub}/db_params.csv'):
        if MDB.get(norm(r['object_name'])) == dbname: DBP[norm(r['object_name'])].append(r['param_name'])
DQ = list(R('db/meta/dbo.SCM_ADM_DQ_LIST.csv')) if os.path.exists(os.path.join(OUT, 'db/meta/dbo.SCM_ADM_DQ_LIST.csv')) else []
# BIZ: biz:Class.Method → BLL [FoxBizMethod] 메서드가 부르는 DLL 메서드 → 그 DLL 메서드의 엔드포인트 키
#   BLL→DLL 은 같은 프로젝트(03.BIZ\<프로젝트>\…) 안에서만 연결 — 이름만 같은 다른 프로젝트 DLL(FPCommonDataDLL.GetCommonDataList) 오연결 방지
proj = lambda f: f.split('\\')[1] if f.count('\\') >= 2 else ''
BLLCALL = collections.defaultdict(set)
for r in R('calls.csv'):
    if r['file'].startswith('03.BIZ') and '\\BLL\\' in r['file']: BLLCALL[(r['class'], r['member'])].add((proj(r['file']), r['callee']))
DLLKEY = collections.defaultdict(set)
for r in R('endpoint_usage.csv'):
    if r['file'].startswith('03.BIZ') and r['key'] and r['active'] == '1' and r['commented'] == '0':
        DLLKEY[(proj(r['file']), r['member'])].add(r['key']); DLLKEY[(proj(r['file']), r['class'], r['member'])].add(r['key'])
#   같은 프로젝트에 같은 이름 DLL 메서드가 여럿이면(CommonData.GetCommonDataList / AppServiceSupport.GetCommonDataList) BLL 과 같은 클래스명 DLL 우선
FW = collections.defaultdict(list)  # (class, method) → 프레임워크 액션 행
fwp = os.path.join(OUT, 'framework_actions', 'actions.csv')
if os.path.exists(fwp):
    for r in csv.DictReader(open(fwp, encoding='utf-8-sig')): FW[(r['class'], r['method'])].append(r)
FWBYNAME = collections.defaultdict(list)
for (c, m) in FW: FWBYNAME[m].append(c)
print(f'facts: foxquery {len(FQ)} · modules {len(MREF)} · branches {len(BR)} · BLL {len(BLLCALL)} · framework methods {len(FW)} · DQ {len(DQ)}', flush=True)

LIT = re.compile(r'^\s*\(?\s*@?"([^"]*)"')
def first_lit(v):
    m = LIT.match(v or ''); return m.group(1) if m else None
def type_lit(v):  # Data_SCP.Common(Data_SCP.Type.OperationGroupEE, …) → OperationGroupEE
    m = re.match(r'^\s*\(\s*[\w.]*Type\.(\w+)', v or ''); return m.group(1) if m else None


def sp_chain(row, emit, sp, params, depth=0, seen=None):
    """SP → 분기(넘긴 값과 일치)·참조 테이블·하위 SP(재귀 4단계)·저장 쿼리"""
    seen = seen or set()
    key = norm(sp)
    if key in seen or depth > 4: return
    seen.add(key)
    refs = MREF.get(key)
    if key in ('SP_EXECUTESQL', 'EXEC', 'EXECUTE'):
        emit(row, depth, 'DYNAMIC_SQL', sp, '', '', 'CANDIDATE', '동적 SQL 실행 — 실행할 쿼리 문자열은 SP 안에서 실행 시 조립/조회(상위 SP 본문 확인 · 2b 실행 시 확정)'); return
    if refs is None and key.startswith('SP_') or key.startswith('XP_'):
        emit(row, depth, 'SP', sp, '', '', 'RESOLVED', 'SQL Server 시스템 프로시저'); return
    if refs is None:
        emit(row, depth, 'SP', sp, '', '', 'UNRESOLVED', 'AS-IS DB(LGCE_SCMDEV·LGCE_FPDEV_TR) 어디에도 없는 객체 — 삭제·개명 또는 다른 서버, 원문 확인 필요'); return
    pnames = DBP.get(key, [])
    emit(row, depth, 'SP', sp, MDB.get(key, ''), ', '.join(pnames), 'RESOLVED', f'{MDB.get(key, "")} · 파라미터 {len(pnames)} · 참조 {len(refs)}')
    # 분기
    brs = BR.get(key, [])
    byvar = collections.defaultdict(list)
    for b in brs: byvar[b['variable'].upper()].append(b)
    for var, bl in byvar.items():
        pv = None
        for pn, val in params.items():
            if ('@' + pn.lstrip('@')).upper() == var or pn.lstrip('@').upper() == var.lstrip('@'): pv = val
        vals = sorted({b['value'] for b in bl if b['value']})
        if pv is not None and pv in {b['value'] for b in bl}:
            hit = [b for b in bl if b['value'] == pv and b['ref_kind'] != 'NONE']
            emit(row, depth, 'SP_BRANCH', f'{sp} IF {var}={pv!r}', '; '.join(f"{b['access']}:{b['name']}" for b in hit), '', 'RESOLVED', f'넘긴 값과 일치하는 분기 · 참조 {len(hit)}')
            for b in hit:
                if b['ref_kind'] in ('EXEC', 'PROCEDURE'): sp_chain(row, emit, b['name'], {}, depth + 1, seen)
        elif vals:
            emit(row, depth, 'SP_BRANCH', f'{sp} IF {var}', ' | '.join(vals[:60]) + (' …' if len(vals) > 60 else ''), '', 'CANDIDATE', f'분기 값 {len(vals)}개 — 넘긴 값 {pv!r} 미확정/불일치(실행 시 결정)')
    tables = sorted({(a, n) for k, a, n in refs if k in ('TABLE', 'VIEW', 'TEMP', 'TVF', 'FUNCTION')})
    if tables: emit(row, depth, 'SP_REF', sp, '; '.join(f'{a}:{n}' for a, n in tables[:80]) + (' …' if len(tables) > 80 else ''), '', 'RESOLVED', f'테이블·함수 {len(tables)}')
    if any(norm(n) == 'SCM_ADM_DQ_LIST' for _, _, n in refs):
        emit(row, depth, 'STORED_QUERY', sp, 'SCM_ADM_DQ_LIST.DQ_TEXT', '', 'RESOLVED', f'테이블에 저장된 쿼리를 읽어 실행 — DQ {len(DQ)}건(DQ_ID 별 쿼리 본문은 db/meta/dbo.SCM_ADM_DQ_LIST.csv)')
    for k, a, n in refs:
        if k == 'EXEC': sp_chain(row, emit, n, {}, depth + 1, seen)


def endpoint_chain(row, emit, key, params, depth=0):
    if '{' in key or 'PseudoDataClient' in key: return  # 래퍼 전파 일반 템플릿(실행부) — 실제 키는 요청 생성 행/호출부에서 연결
    if key.startswith('biz:'):
        m = re.match(r'biz:(\w+)\.(\w+)(?:\s*\[(\w+)=([^\]]*)\])?', key)
        if not m: emit(row, depth, 'ENDPOINT', key, '', '', 'UNRESOLVED', 'BIZ 키 형식 해석 불가'); return
        cls, meth, pk, pv = m.groups()
        if pk and pv and not pv.startswith('{'): params = dict(params); params[pk] = pv
        # 범용 실행기(GeneralExecuteQuery/UpdateBatch/ExecuteNonQuery …)는 쿼리 ID 를 파라미터(batchId/queryId/id)로 받는다 → FoxQuery '<pagePath>#<id>' 로 해석
        #   pagePath 는 호출부 값이 스캔에 안 잡히는 경우가 많아 '#<id>' 후보 중 BLL 계열(FP* → FP\) 우선, 1개면 확정·여러 개면 후보
        if meth.startswith('General') and pk and pk.lower() in ('batchid', 'queryid', 'id') and pv and not pv.startswith('{'):
            cand = sorted(k for k in FQ if k.upper().endswith('#' + pv.upper()))
            pref = [k for k in cand if k.upper().startswith('FP\\')] if cls.upper().startswith('FP') else [k for k in cand if not k.upper().startswith('FP\\')]
            cand = pref or cand
            if len(cand) == 1:
                emit(row, depth, 'ENDPOINT', key, cand[0], '', 'RESOLVED', f'범용 실행기 {cls}.{meth} — {pk}={pv} → FoxQuery 정의 1건')
                endpoint_chain(row, emit, cand[0], params, depth + 1); return
            if cand:
                emit(row, depth, 'ENDPOINT', key, ' | '.join(cand), '', 'CANDIDATE', f'범용 실행기 {cls}.{meth} — {pk}={pv} 정의 {len(cand)}건(pagePath 는 호출부 값으로 결정)')
                for k in cand: endpoint_chain(row, emit, k, params, depth + 1)
                return
        dlls = BLLCALL.get((cls, meth), set())
        keys = sorted({k for p_, m_ in dlls for k in (DLLKEY.get((p_, cls, m_)) or DLLKEY.get((p_, m_), ()))})
        emit(row, depth, 'ENDPOINT', key, ', '.join(keys), ', '.join(f'{k}={v}' for k, v in params.items()), 'RESOLVED' if keys else 'UNRESOLVED', f'BIZ {cls}.{meth} → DLL {", ".join(sorted(p + ":" + m for p, m in dlls)) or "?"}')
        for k in keys: endpoint_chain(row, emit, k, params, depth + 1)  # BLL 이 같은 이름(대소문자 무시)으로 SP 파라미터에 넘김 — 예: code → @Code
        return
    fq = FQ.get(key) or FQI.get(key.upper())
    if not fq:
        emit(row, depth, 'ENDPOINT', key, '', '', 'UNRESOLVED', 'FoxQuery 정의에 없음'); return
    if fq['sp_name']:
        emit(row, depth, 'ENDPOINT', key, fq['sp_name'], ', '.join(FQP.get(key.upper(), [])), 'RESOLVED', f"FoxQuery {fq['element']} → SP")
        sp_chain(row, emit, fq['sp_name'], params, depth + 1)
    else:
        refs = FQR.get(key.upper(), [])
        emit(row, depth, 'SQL', key, '; '.join(f'{a}:{n}' for _, a, n in refs[:80]), fq['text_file'], 'RESOLVED', f'인라인 SQL 참조 {len(refs)} — 본문 {fq["text_file"]}')
        for k, a, n in refs:
            if k in ('EXEC', 'PROCEDURE'): sp_chain(row, emit, n, {}, depth + 1)


def fw_chain(row, emit, cls, meth, code, depth=0, seen=None):
    """프레임워크 메서드 → (코드값 case) 동작 → 엔드포인트(화면 메서드 BFS 3단계)"""
    seen = seen or set()
    if (cls, meth) in seen or depth > 3: return
    seen.add((cls, meth))
    rows = FW.get((cls, meth), [])
    emit(row, depth, 'FW_METHOD', f'{cls}.{meth}', code or '', '', 'RESOLVED', f'프레임워크 문장 {len(rows)}')
    if code:
        pat = re.compile(r'case\s+(?:[\w.]*\.)?"?' + re.escape(code) + r'"?\s*:?', re.I)
        hit = [r for r in rows if pat.search(r['guard'])]
        if hit:
            body = [r for r in hit if r['kind'] not in ('FLOW', 'BRANCH', 'EXPR', 'LOCAL')]
            emit(row, depth, 'FW_CASE', f'{cls}.{meth} case {code}', ' / '.join(f"{r['kind']}:{r['target']}{r['value'][:60]}" for r in body[:15]), '', 'RESOLVED', f'case 동작 {len(body)}행(L{hit[0]["line"]}~)')
        elif any('switch' in r['guard'] for r in rows):
            emit(row, depth, 'FW_CASE', f'{cls}.{meth} case {code}', '', '', 'UNRESOLVED', '이 코드값의 case 없음(default 경로?)')
    for r in rows:
        if r['kind'] in ('ENDPOINT', 'COMBO_DATA') and r['endpoint']:
            for k in r['endpoint'].split(' | '): endpoint_chain(row, emit, k, {}, depth + 1)
        elif r['kind'] == 'CALL_LOCAL':
            fw_chain(row, emit, cls, r['target'].split('.')[-1], None, depth + 1, seen)


def run(sid):
    d = os.path.join(OUT, 'screens', sid); ap = os.path.join(d, 'actions.csv')
    if not os.path.exists(ap): return None
    A = list(csv.DictReader(open(ap, encoding='utf-8-sig')))
    bym = collections.defaultdict(list)
    for r in A: bym[(r['class'], r['method'])].append(r)
    out = []; st = collections.Counter()
    def emit(row, hop, kind, frm, to, cond, status, detail):
        out.append([sid, row['class'], row['method'], row['line'], row['kind'], row['target'], row['value'][:160], hop, kind, frm, to, cond, status, detail]); st[status] += 1
    def params_of(row):
        ps = {}
        ms = bym[(row['class'], row['method'])]; ln = int(row['line'])
        nxt = min([int(r['line']) for r in ms if r['kind'] == 'ENDPOINT' and r['target'].startswith('new ') and int(r['line']) > ln] + [ln + 80])
        for r in ms:
            if ln <= int(r['line']) < nxt and r['kind'] == 'DATA_OP':
                m = re.search(r'Parameters\["(\w+)"\]', r['target'])
                if m: ps[m.group(1)] = (first_lit(r['value']) if first_lit(r['value']) is not None else r['value'][:60])
                elif r['target'].endswith('Parameters.Add'):
                    m2 = re.match(r'^\s*\(\s*"(\w+)"\s*,\s*(.*)\)\s*$', r['value'])
                    if m2: ps[m2.group(1)] = first_lit('(' + m2.group(2)) if first_lit('(' + m2.group(2)) is not None else m2.group(2)[:60]
        return ps
    fields = collections.defaultdict(list)  # 화면 필드 대입 행(데이터 원천)
    for r in A:
        if r['kind'] == 'FLAG': fields[(r['class'], r['target'].replace('this.', ''))].append(r)
    for r in A:
        k = r['kind']
        tmpl = lambda key: '{' in key or 'PseudoDataClient' in key  # 스캐너 래퍼 전파의 일반 템플릿 키(실행부) — 실제 키는 요청 생성 행
        if k == 'ENDPOINT' and r['endpoint'] and r['target'].startswith('new '):
            ps = params_of(r)
            for key in r['endpoint'].split(' | '):
                if tmpl(key): emit(r, 0, 'ENDPOINT', key, '', '', 'UNRESOLVED', '동적 키(변수로 만든 쿼리 ID — 실행 시 결정)'); continue
                if ps: emit(r, 0, 'PARAM', key, ', '.join(f'{a}={b}' for a, b in ps.items()), '', 'RESOLVED', f'요청 파라미터 {len(ps)}')
                endpoint_chain(r, emit, key, ps)
        elif k in ('ENDPOINT', 'COMBO_DATA') and r['endpoint'] and not r['target'].startswith('new '):
            for key in r['endpoint'].split(' | '):
                if not tmpl(key): endpoint_chain(r, emit, key, {})
        elif k in ('COMBO_DATA', 'CALL_EXT', 'CALL_BASE', 'ENDPOINT', 'GRID_BIND') and not r['endpoint']:
            parts = r['target'].split('.'); meth = parts[-1]; cls = parts[-2] if len(parts) > 1 else None
            cands = [cls] if cls and (cls, meth) in FW else FWBYNAME.get(meth, [])
            if k == 'COMBO_DATA' and not cands:
                emit(r, 0, 'FW_METHOD', r['target'], '', '', 'UNRESOLVED', '프레임워크 메서드 본문 없음(외부 DLL?)')
            for c in cands[:3]: fw_chain(r, emit, c, meth, first_lit(r['value']) or type_lit(r['value']))
        if k in ('LIST_REBIND', 'GRID_BIND', 'LIST_BIND'):
            var = (re.match(r'^\s*\(\s*(?:this\.)?(\w+)', r['value']) or re.match(r'^\s*(?:this\.)?(\w+)', r['value']) or [None, None])[1]
            src = fields.get((r['class'], var), []) if var else []
            for s in src:
                emit(r, 0, 'DATA_SOURCE', var, f"{s['method']}:{s['line']} {s['value'][:100]}", s['guard'][:120], 'RESOLVED', '목록/그리드에 넣는 데이터가 채워진 곳 — 그 행의 체인 참조')
            if var and not src: emit(r, 0, 'DATA_SOURCE', var, '', '', 'UNRESOLVED', '화면 필드 대입 없음(지역 변수·매개변수 원천 — 미추적)')
    with open(os.path.join(d, 'action_links.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f, quoting=csv.QUOTE_ALL)
        w.writerow(['screen_id', 'class', 'method', 'line', 'action_kind', 'action_target', 'action_value', 'hop', 'link_kind', 'from', 'to', 'cond', 'status', 'detail'])
        w.writerows(out)
    return len(out), st


ids = [a.upper() for a in sys.argv[1:]] or sorted(x for x in os.listdir(os.path.join(OUT, 'screens')) if os.path.isdir(os.path.join(OUT, 'screens', x)))
tot = collections.Counter(); n = 0
for sid in ids:
    r = run(sid)
    if not r: continue
    n += 1; tot.update(r[1])
    if len(ids) <= 5: print(sid, r[0], dict(r[1]))
print(f'screens {n} · links {sum(tot.values())} · {dict(tot)}')
