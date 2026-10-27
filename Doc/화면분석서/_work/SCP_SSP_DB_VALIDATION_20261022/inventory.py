# -*- coding: utf-8 -*-
"""SCP/SSP 화면 -> AS-IS SP 호출 인벤토리 + 하위 EXEC 체인 BFS (다중 패턴)
원천: Doc/asisfacts (2026-10-16 LGCE_SCMDEV 덤프 + C# 스캔 팩)
출력: ui_sp_direct.csv (화면-SP 직접 호출, 근거 패턴별), ui_sp_chain.csv (화면-SP 체인 전체), units.csv (판독 단위 SP/SQL 목록)
"""
import csv, glob, os, re, collections, sys

AF = r'C:/Projects/NSCM/Doc/asisfacts'
OUT = os.path.dirname(os.path.abspath(__file__))
MOD = os.path.join(AF, 'db', 'modules')

def rd(p):
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))

modules = {}  # NAME(upper) -> file
for fn in os.listdir(MOD):
    if fn.lower().endswith('.sql'):
        nm = fn[:-4]
        if '.' in nm:
            nm = nm.split('.', 1)[1]
        modules[nm.upper()] = fn

objtype = {r['name'].upper(): r['type'].strip() for r in rd(os.path.join(AF, 'db', 'db_objects.csv'))}

fox = {}  # key -> (kind, target)
for r in rd(os.path.join(AF, 'foxquery_endpoints.csv')):
    if r['commented'] == '1':
        continue
    if r['element'] == 'procedure' and r['sp_name']:
        fox[r['key']] = ('SP', r['sp_name'])
    elif r['text_file']:
        fox.setdefault(r['key'], ('SQL', r['text_file']))

screens = sorted(d for d in os.listdir(os.path.join(AF, 'screens')) if re.match(r'^(SCP|SSP)\d', d))

direct = []  # screen, unit_kind, unit, member, line, file, pattern, status
COMMON_BIZ = {'biz:CommonData.CommonDataList', 'biz:CommonData.YesOrNo', 'biz:CommonData.CommonDataList_FP',
              'biz:CommonData.CommonDataList_SCP_ALL', 'biz:CommonData.CommonDataList_REPORT'}
excluded = []

def add(sid, kind, unit, r, pattern, status=''):
    direct.append(dict(screen=sid, unit_kind=kind, unit=unit, member=r.get('member', ''), line=r.get('line', ''),
                       file=r.get('file', ''), pattern=pattern, status=status))

SP_RE = re.compile(r'SP\s+([\w\.]+)')
for sid in screens:
    d = os.path.join(AF, 'screens', sid)
    # P1 endpoints.csv (FoxDataRequest/FoxBiz 해석본)
    p = os.path.join(d, 'endpoints.csv')
    if os.path.exists(p):
        for r in rd(p):
            s = r['sp_or_sql']
            if s.startswith('SP '):
                for m in SP_RE.findall(s):
                    add(sid, 'SP', m.split('.')[-1].upper(), r, 'P1_endpoint', r['status'])
            elif s.startswith('[sql]') or s.startswith('[statement]'):
                add(sid, 'SQL', s.split(' ', 1)[1].strip(), r, 'P1_endpoint_sql', r['status'])
            elif s.startswith('[update-batch]'):
                excluded.append((sid, r['key'], r['member'], r['line'], 'update-batch(엑셀 행 일괄 INSERT, 검증 로직 없음 — 직후 validate SQL 별도)'))
            elif r['key'] in COMMON_BIZ:
                excluded.append((sid, r['key'], r['member'], r['line'], '공통 콤보 조회(BIZ CommonData → FP_Common.UI_FP_COMMON) — 룩업, 검증 아님'))
            elif r['status'] == 'UNRESOLVED':
                m = re.search(r'#dbo\.(\w+)', r['candidate'])
                if m:
                    add(sid, 'SP', m.group(1).upper(), r, 'P2_unresolved_dbo', 'UNRESOLVED')
                else:
                    excluded.append((sid, r['candidate'], r['member'], r['line'], 'UNRESOLVED — P4/P5 로 해석'))
            elif r['status'] == 'NOT_IN_FOXQUERY':
                nm = r['key'].split('.')[-1].upper()
                add(sid, 'SP', nm, r, 'P3_not_in_foxquery', 'NOT_IN_FOXQUERY')
            elif r['kind'] == 'biz':
                excluded.append((sid, r['key'], r['member'], r['line'], 'BIZ 범용 호출 — 대상 SP/SQL 은 별도 행(P1)로 해석됨'))
            elif r['status'] == 'TEMPLATE':
                excluded.append((sid, r['candidate'], r['member'], r['line'], 'TEMPLATE(파라미터 의존) — P5 해석'))
    # P4 literals.csv : 화면 .cs 의 문자열 리터럴 중 FoxQuery 키와 일치 (queryId 변수 대입 등 간접 호출)
for r in rd(os.path.join(AF, 'literals.csv')):
    sid = r['screen_id']
    if sid in screens and r['catalog_match'] and r['value'] in fox:
        k, t = fox[r['value']]
        if k == 'SP':
            add(sid, 'SP', t.split('.')[-1].upper(), r, 'P4_literal_foxkey')
        else:
            add(sid, 'SQL', t, r, 'P4_literal_foxkey')
# P5 SCP0039 Validation Master: PROCEDURE_NAME 그리드 값으로 동적 호출 -> SCP0039_GET_VALIDATION_* 전부
for nm in sorted(modules):
    if nm.startswith('SCP0039_GET_VALIDATION_'):
        add('SCP0039', 'SP', nm, {'member': 'FindData', 'line': '623',
            'file': r'06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0039_ValidationMaster\SCP0039_ValidationMaster.cs'},
            'P5_dynamic_procname')

# 화면 원본 .cs 에서 주석 처리된 호출 제외 목록 (commented_calls.csv) — 이미 endpoints 에서 빠져있음, 기록만
commented = []
for sid in screens:
    p = os.path.join(AF, 'screens', sid, 'commented_calls.csv')
    if os.path.exists(p):
        for r in rd(p):
            commented.append((sid, r['key'] or r['candidate'], r['line'], r['status']))

# 하위 EXEC/FUNC 체인 BFS
refs = collections.defaultdict(set)
dyn = collections.defaultdict(list)
for r in rd(os.path.join(AF, 'db', 'db_module_refs.csv')):
    src = r['module'].split('.', 1)[-1].upper()
    if r['ref_kind'] in ('EXEC', 'FUNC'):
        tgt = r['name'].split('.')[-1].upper()
        refs[src].add((r['ref_kind'], tgt))
    elif r['ref_kind'] == 'DYNAMIC':
        dyn[src].append(r['line'])

SKIP_CHAIN = {'PR_SCM_SYS_LOG_BATCH', 'PR_SCM_SYS_LOG_BATCH_CALL_TRAN', 'SP_EXECUTESQL'}
chain = []  # screen, root, unit, depth, via_kind, parent
units = collections.OrderedDict()
by_screen = collections.defaultdict(set)
for x in direct:
    by_screen[x['screen']].add((x['unit_kind'], x['unit']))
for sid in screens:
    seen = set()
    for kind, root in sorted(by_screen.get(sid, [])):
        if kind == 'SQL':
            chain.append(dict(screen=sid, root=root, unit=root, depth=0, via='', parent=''))
            units.setdefault(('SQL', root), set()).add(sid)
            continue
        q = [(root, 0, '', '')]
        while q:
            u, dep, via, par = q.pop(0)
            key = (root, u)
            if key in seen:
                continue
            seen.add(key)
            chain.append(dict(screen=sid, root=root, unit=u, depth=dep, via=via, parent=par))
            units.setdefault(('SP', u), set()).add(sid)
            for vk, t in sorted(refs.get(u, [])):
                if t in SKIP_CHAIN:
                    continue
                if vk == 'FUNC' and t not in modules:
                    continue  # 내장함수
                q.append((t, dep + 1, vk, u))

def wr(name, rows, cols):
    with open(os.path.join(OUT, name), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f)
        w.writerow(cols)
        for r in rows:
            w.writerow([r[c] for c in cols] if isinstance(r, dict) else r)

wr('ui_sp_direct.csv', direct, ['screen', 'unit_kind', 'unit', 'member', 'line', 'file', 'pattern', 'status'])
wr('ui_sp_chain.csv', chain, ['screen', 'root', 'unit', 'depth', 'via', 'parent'])
urows = []
for (k, u), ss in units.items():
    exists = (u.upper() in modules) if k == 'SP' else os.path.exists(os.path.join(AF, u))
    f = modules.get(u.upper(), '') if k == 'SP' else u
    lines = 0
    if exists:
        p = os.path.join(MOD, f) if k == 'SP' else os.path.join(AF, u)
        with open(p, encoding='utf-8', errors='replace') as fh:
            lines = sum(1 for _ in fh)
    urows.append([k, u, objtype.get(u.upper(), ''), 'Y' if exists else 'N', f, lines, len(ss), ' '.join(sorted(ss)),
                  ' '.join(dyn.get(u.upper(), []))])
wr('units.csv', urows, ['kind', 'unit', 'obj_type', 'source_exists', 'source_file', 'lines', 'screen_cnt', 'screens', 'dynamic_sql_lines'])
wr('excluded.csv', excluded, ['screen', 'key', 'member', 'line', 'reason'])
wr('commented_calls.csv', commented, ['screen', 'key', 'line', 'status'])

pc = collections.Counter(x['pattern'] for x in direct)
print('screens', len(screens), 'with calls', len(by_screen))
print('direct rows', len(direct), dict(pc))
print('direct distinct units', len({(x['unit_kind'], x['unit']) for x in direct}))
print('units total', len(units), 'SP', sum(1 for k in units if k[0] == 'SP'), 'SQL', sum(1 for k in units if k[0] == 'SQL'))
print('missing source', [u for u in urows if u[3] == 'N'])
print('screens without units', [s for s in screens if s not in by_screen])
print('total lines', sum(u[5] for u in urows))
