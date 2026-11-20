# -*- coding: utf-8 -*-
"""feature_inventory.py — AS-IS 기능 목록(화면 단위 · 기능 단위) (2026-11-11 · 사용자 목적 "TO-BE 룰을 지키면서 AS-IS 기능을 완벽하게 구현")

"AS-IS 에 어떤 기능이 있었는가"를 사람·AI 의 해석이 아니라 파서 사실(tools/AsisFacts — Roslyn 문장 사실 actions.csv 등)에서 기계적으로 뽑아
기능 단위 목록으로 만든다. 이 목록이 '누락 0' 판정의 분모다 — 목록에 없는 기능은 검사도 생성도 되지 않으므로, 추출 한계는 숨기지 않고 함께 적는다.

입력(전부 Doc/asisfacts/screens/<ID>/ · 파서 산출):
  actions.csv(문장 사실: kind·target·value·guard) · actions_entries.csv(진입점 → 메서드 경로) · events.csv(컨트롤 이벤트 → 핸들러) · lock_rules.csv · cell_rules.csv
기능 유형과 추출 규칙(문장 사실의 구조만 본다 — 이름 관례·의미 추정 없음):
  VALIDATION  같은 메서드에서 MESSAGE 문장 바로 뒤(같은 조건 가지 안)에 RETURN(처리 중단)이 오는 것 = 조건 위반 시 메시지 후 중단
  CONFIRM     MESSAGE 문장 뒤에 RETURN 이 바로 오지 않는 것 = 알림·확인창(결과 분기는 guard 로 이어짐)
  EXPRESSION  행/컬럼 값 대입 문장 중 오른쪽이 연산·호출을 포함하는 것 = 계산식
  ASSIGN      행/컬럼 값 대입 문장 중 오른쪽이 단순 값(상수·변수) = 기본값·복사
  STATE       화면 속성(Visibility·Enabled·ReadOnly 등) 설정 문장 중 조건(guard)이 있는 것 = 조건부 표시/활성
  LOCK        lock_rules.csv 행 = 셀·컬럼 잠금 규칙
  CELL_RULE   cell_rules.csv 행 중 제약이 있는 것(최대 길이·최소/최대·대문자·소수 자리)
  DATA_CALL   ENDPOINT 문장 = 서버 호출(조회·저장) — 호출 지점 단위
  CASCADE     값 변경류 이벤트(events.csv 의 event 가 Changed·Change 로 끝남)의 핸들러 경로 안에 DATA_CALL 이 있는 것 = 값 변경 → 재조회·재적재
한계(이 도구가 못 뽑는 것 — 분모에 없음을 명시):
  · 프레임워크 내부 동작(공용 컨트롤의 기본 검증·단축키) · 디자이너 속성으로만 정해진 초기 상태 · 동적 문자열로 만든 식
  · '의미 확인 필요' 로 남은 외부 호출(actions.csv meaning 에 표기) — 건수를 UNKNOWN_CALL 로 함께 보고한다

  python tools/Harness/verify/feature_inventory.py <MENU_ID> [<MENU_ID> …]
  python tools/Harness/verify/feature_inventory.py --selftest
출력: Doc/asisfacts/screens/<ID>/features.csv (feature_id,type,method,line,key,detail,guard,ref) · 콘솔 요약
"""
import csv, hashlib, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
csv.field_size_limit(10 ** 8)
COLS = ['feature_id', 'type', 'method', 'line', 'key', 'detail', 'guard', 'ref']
RX_SIMPLE = re.compile(r'^\s*(?:"[^"]*"|\'[^\']*\'|-?\d+(?:\.\d+)?[mMdDfFlL]?|true|false|null|string\.Empty|[A-Za-z_][\w.]*|DBNull\.Value)\s*;?\s*$')
RX_STATE = re.compile(r'\b(Visible|Visibility|Enabled|ReadOnly|Locked|Checked|Text)\b')
RX_CHANGE = re.compile(r'(Changed|Change|Changing|Validated|Validating)$')


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='', errors='replace') as f:
        return list(csv.DictReader(f))


def fid(mid, typ, method, line, key):
    return 'F-' + hashlib.md5('|'.join([mid, typ, method, str(line), key]).encode('utf-8')).hexdigest()[:8]


def to_int(s):
    try:
        return int(str(s).strip())
    except ValueError:
        return 0


def build(mid, actions, entries, events, locks, cells):
    """문장 사실 → 기능 목록(list of dict) + 통계(dict)"""
    out = []

    def add(typ, method, line, key, detail, guard, ref):
        out.append({'feature_id': fid(mid, typ, method, line, key), 'type': typ, 'method': method, 'line': str(line), 'key': key[:200], 'detail': detail[:400], 'guard': (guard or '')[:400], 'ref': ref})
    by_m = {}
    for a in actions:
        by_m.setdefault((a.get('class', ''), a.get('method', '')), []).append(a)
    endpoints_of = {}
    unknown = 0
    for (cls, m), rows in by_m.items():
        rows.sort(key=lambda r: (to_int(r.get('stmt_no')), to_int(r.get('line'))))
        for i, a in enumerate(rows):
            kind, guard = a.get('kind', ''), a.get('guard', '')
            ref = f"{os.path.basename((a.get('file') or '').replace(chr(92), '/'))}:{a.get('line')}"
            if '의미 확인 필요' in (a.get('meaning') or ''):
                unknown += 1
            if kind == 'MESSAGE':
                msg = re.search(r'"([A-Z]{2,5}\d{3,6})"', a.get('value') or '')
                key = msg.group(1) if msg else (a.get('value') or '')[:60]
                nxt = rows[i + 1] if i + 1 < len(rows) else None
                stop = bool(nxt and nxt.get('kind') == 'RETURN' and (nxt.get('guard') or '') == guard)
                add('VALIDATION' if stop else 'CONFIRM', m, a.get('line'), key, f"{a.get('target')}{a.get('value')}", guard, ref)
            elif (a.get('meaning') or '') == '행/컬럼 값 대입':
                val = a.get('value') or ''
                add('ASSIGN' if RX_SIMPLE.match(val) else 'EXPRESSION', m, a.get('line'), (a.get('target') or '')[:120], f"{a.get('target')} = {val}", guard, ref)
            elif kind == 'UI_PROP' and guard and RX_STATE.search((a.get('target') or '') + ' ' + (a.get('meaning') or '')):
                add('STATE', m, a.get('line'), (a.get('target') or '')[:120], f"{a.get('target')} = {a.get('value')}", guard, ref)
            elif kind == 'ENDPOINT':
                ep = re.search(r'"([^"]+)"', a.get('value') or '')
                key = ep.group(1) if ep else (a.get('endpoint') or a.get('value') or '')[:80]
                add('DATA_CALL', m, a.get('line'), key, f"{a.get('target')}{a.get('value')}", guard, ref)
                endpoints_of.setdefault(m, []).append(key)
    for r in locks:
        add('LOCK', r.get('method', ''), r.get('line', ''), (r.get('columns') or r.get('scope') or '')[:120], f"{r.get('api')} locked={r.get('locked')} {r.get('lock_expr') or ''}", r.get('cond', ''), f"lock_rules:{r.get('line')}")
    for r in cells:
        cons = {k: r.get(k) for k in ('max_length', 'min', 'max', 'decimals', 'uppercase') if (r.get(k) or '').strip() not in ('', '0', 'False', 'false')}
        if cons:
            add('CELL_RULE', '', '', f"{r.get('sheet')}.{r.get('column')}", ' · '.join(f'{k}={v}' for k, v in cons.items()) + f" · {r.get('cell_type')}", '', 'cell_rules')
    # CASCADE: 값 변경류 이벤트의 핸들러 경로에 서버 호출이 있는가
    path_methods = {}
    for e in entries:
        path_methods.setdefault(e.get('handler') or e.get('entry') or '', set()).add(e.get('method') or '')
    for ev in events:
        if not RX_CHANGE.search(ev.get('event') or ''):
            continue
        h = ev.get('handler') or ''
        eps = []
        for m in sorted(path_methods.get(h, set()) | {h}):
            eps += endpoints_of.get(m, [])
        if eps:
            add('CASCADE', h, ev.get('line', ''), f"{ev.get('target')}.{ev.get('event')}", '값 변경 → 호출 ' + ', '.join(dict.fromkeys(eps))[:300], '', f"events:{ev.get('line')}")
    stats = {}
    for f in out:
        stats[f['type']] = stats.get(f['type'], 0) + 1
    stats['UNKNOWN_CALL'] = unknown
    return out, stats


def selftest():
    st = {'ok': 0, 'n': 0}

    def t(name, cond):
        st['n'] += 1
        st['ok'] += bool(cond)
        print(('PASS ' if cond else 'FAIL ') + name)
    A = lambda **k: dict({'class': 'C', 'file': 'a.cs', 'guard': '', 'meaning': '', 'target': '', 'value': ''}, **k)
    acts = [A(method='Save', line='10', stmt_no='1', kind='BRANCH', target='x == ""'),
            A(method='Save', line='11', stmt_no='2', kind='MESSAGE', target='Msg', value='("MSG00010", null)', guard='if (x == "")'),
            A(method='Save', line='12', stmt_no='3', kind='RETURN', target='return;', guard='if (x == "")'),
            A(method='Save', line='20', stmt_no='4', kind='MESSAGE', target='Msg', value='("MSG00020", null)', guard='if (ok)'),
            A(method='Save', line='21', stmt_no='5', kind='ENDPOINT', target='new Req', value='("SSP.X_SAVE")', guard='if (ok)'),
            A(method='Calc', line='30', stmt_no='1', kind='DATA_OP', meaning='행/컬럼 값 대입', target='dr["AMT"]', value='qty * price'),
            A(method='Calc', line='31', stmt_no='2', kind='DATA_OP', meaning='행/컬럼 값 대입', target='dr["YN"]', value='"Y"'),
            A(method='Init', line='40', stmt_no='1', kind='UI_PROP', meaning='속성 Visibility 설정', target='btnX.Visible', value='false', guard='if (div == "40")'),
            A(method='Init', line='41', stmt_no='2', kind='UI_PROP', meaning='속성 Visibility 설정', target='btnY.Visible', value='false', guard=''),
            A(method='Load', line='50', stmt_no='1', kind='ENDPOINT', target='new Req', value='("SSP.X_GET")'),
            A(method='Ext', line='60', stmt_no='1', kind='CALL_EXT', meaning='외부/프레임워크 호출(사전 미등록 — 의미 확인 필요)', target='Foo.Bar')]
    ents = [{'handler': 'cbo_Changed', 'entry': 'cbo_Changed', 'method': 'Load'}]
    evs = [{'target': 'cboDiv', 'event': 'EditValueChanged', 'handler': 'cbo_Changed', 'line': '5'}, {'target': 'btn', 'event': 'Click', 'handler': 'Save', 'line': '6'}]
    out, s = build('T', acts, ents, evs, [{'method': 'Lock', 'line': '70', 'api': 'LockRange', 'locked': 'true', 'columns': 'A..B', 'cond': 'if (x)'}],
                   [{'sheet': 'S', 'column': 'C1', 'max_length': '10', 'cell_type': 'Text'}, {'sheet': 'S', 'column': 'C2', 'max_length': '0', 'cell_type': 'Text'}])
    ty = lambda x: [f for f in out if f['type'] == x]
    t('메시지 뒤 같은 가지의 중단 = VALIDATION', len(ty('VALIDATION')) == 1 and ty('VALIDATION')[0]['key'] == 'MSG00010' and 'x == ""' in ty('VALIDATION')[0]['guard'])
    t('중단이 뒤따르지 않는 메시지 = CONFIRM(검증으로 세지 않음)', len(ty('CONFIRM')) == 1 and ty('CONFIRM')[0]['key'] == 'MSG00020')
    t('연산이 있는 값 대입 = EXPRESSION', len(ty('EXPRESSION')) == 1 and 'qty * price' in ty('EXPRESSION')[0]['detail'])
    t('단순 값 대입 = ASSIGN(식으로 세지 않음)', len(ty('ASSIGN')) == 1)
    t('조건 있는 속성 설정만 STATE', len(ty('STATE')) == 1 and ty('STATE')[0]['key'] == 'btnX.Visible')
    t('서버 호출 지점 = DATA_CALL', sorted(f['key'] for f in ty('DATA_CALL')) == ['SSP.X_GET', 'SSP.X_SAVE'])
    t('값 변경 이벤트 → 경로에 호출 있음 = CASCADE · Click 은 아님', len(ty('CASCADE')) == 1 and 'SSP.X_GET' in ty('CASCADE')[0]['detail'])
    t('잠금 규칙·제약 있는 셀 규칙만', len(ty('LOCK')) == 1 and len(ty('CELL_RULE')) == 1)
    t('의미 미확인 외부 호출 수를 함께 보고', s['UNKNOWN_CALL'] == 1)
    ids = [f['feature_id'] for f in out]
    t('기능 ID 는 유일', len(ids) == len(set(ids)))
    print(f"{st['ok']}/{st['n']}")
    return 0 if st['ok'] == st['n'] else 1


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    mids = [x.upper().strip('/') for x in a if not x.startswith('--')]
    if not mids:
        print(__doc__)
        return 3
    rc = 0
    for mid in mids:
        d = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid)
        acts = rd(os.path.join(d, 'actions.csv'))
        if not acts:
            print(f'[feature_inventory] {mid}: actions.csv 없음 또는 0행 — 기능 목록을 만들 수 없음(미측정) · AsisFacts pack 먼저')
            rc = 3
            continue
        out, s = build(mid, acts, rd(os.path.join(d, 'actions_entries.csv')), rd(os.path.join(d, 'events.csv')), rd(os.path.join(d, 'lock_rules.csv')), rd(os.path.join(d, 'cell_rules.csv')))
        with open(os.path.join(d, 'features.csv'), 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=COLS)
            w.writeheader()
            w.writerows(out)
        order = ['VALIDATION', 'CONFIRM', 'EXPRESSION', 'ASSIGN', 'STATE', 'LOCK', 'CELL_RULE', 'DATA_CALL', 'CASCADE']
        print(f"[feature_inventory] {mid}: 기능 {len(out)}건(문장 사실 {len(acts)}행에서) — " + ' · '.join(f'{k} {s.get(k, 0)}' for k in order)
              + f" · 의미 미확인 외부 호출 {s.get('UNKNOWN_CALL', 0)}건(분모 밖) → Doc/asisfacts/screens/{mid}/features.csv")
    return rc


if __name__ == '__main__':
    sys.exit(main())
