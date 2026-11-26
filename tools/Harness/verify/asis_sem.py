# -*- coding: utf-8 -*-
"""AS-IS C# 의미 분석 조회(2026-11-25 사용자 지시 'VM 의 AS-IS 파서에도 의미 분석 기능이 빠졌으면 추가')

  검사 하네스 사실 추출기(facts_*.py 등)는 AS-IS 원본을 정규식으로 읽는다. 정규식으로 못 푼 값·정의를
  tools/AsisFacts 의 Roslyn 의미 모델(AsisFacts resolve)로 다시 푼다. 요청을 모아 한 번에 보낸다(컴파일은 한 번).

  values([(file, line, expr), ...]) → {(file, line, expr): {'status', 'values': [...], 'unknowns', 'conds'}}
      file = AS-IS 루트(GSCM) 상대경로 · line = 1부터 · expr = 그 줄에 있는 식 원문(공백 차이 무시)
      values 표기: 리터럴 그대로, 매개변수 의존 '{p:이름}', 미결정 '{?식}'
  defs([(file, line, expr), ...]) → {(file, line, expr): [{'rhs', 'file', 'line', 'how'}, ...]}
  target([(file, line, 호출식), ...]) → {(file, line, 호출식): {'params', 'sig', 'file', 'line'} | None}  호출 대상 소스 메서드
      식이 가리키는 변수·필드·속성·매개변수에 값을 넣는 오른쪽 식(how: local·init·assign·caller)

  캐시: Doc/verify/_asis_sem_cache.json — 키 = 종류·파일·줄·식 + 그 파일 sha256(파일이 바뀌면 다시 조회)
  실패(도구 없음·빌드 안 됨·시간 초과): 빈 결과를 돌려주고 호출자는 종전 정규식 결과를 쓴다(누락 없이 종전 동작 유지)
  python tools/Harness/verify/asis_sem.py --selftest
"""
import csv, hashlib, json, os, subprocess, sys, tempfile, threading

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
ASIS = os.path.join(ROOT, 'GSCM')
TOOL = os.path.join(ROOT, 'tools', 'AsisFacts')
DLL = os.path.join(TOOL, '_bin', 'AsisFacts.dll')
CFG = os.path.join(TOOL, 'asisfacts.json')
CACHE = os.path.join(ROOT, 'Doc', 'verify', '_asis_sem_cache.json')
_lock = threading.Lock()
_sha = {}
LAST = {'requested': 0, 'cached': 0, 'resolved': 0, 'error': ''}


def _file_sha(rel):
    if rel not in _sha:
        try:
            with open(os.path.join(ASIS, rel), 'rb') as f:
                _sha[rel] = hashlib.sha256(f.read()).hexdigest()[:16]
        except OSError:
            _sha[rel] = ''
    return _sha[rel]


def _key(kind, file, line, expr):
    return f"{kind}|{file}|{line}|{' '.join(str(expr).split())}|{_file_sha(file)}"


def _load():
    try:
        with open(CACHE, encoding='utf-8') as f:
            return json.load(f)
    except (OSError, ValueError):
        return {}


def _save(c):
    os.makedirs(os.path.dirname(CACHE), exist_ok=True)
    tmp = CACHE + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as f:
        json.dump(c, f, ensure_ascii=False)
    os.replace(tmp, CACHE)


def _run(kind, items, timeout=1800):
    """items = [(file, line, expr)] → 결과 행 목록(dict). 실패면 None"""
    if not os.path.exists(DLL):
        LAST['error'] = f'AsisFacts 없음: {DLL}'; return None
    d = tempfile.mkdtemp(prefix='asis_sem_')
    req, res = os.path.join(d, 'req.csv'), os.path.join(d, 'res.csv')
    with open(req, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['id', 'file', 'line', 'expr', 'kind'])
        for i, (file, line, expr) in enumerate(items):
            w.writerow([i, file.replace('/', '\\'), line, expr, kind])
    try:
        r = subprocess.run(['dotnet', DLL, 'resolve', '--config', CFG, '--in', req, '--result', res], capture_output=True, text=True,
                           encoding='utf-8', errors='replace', timeout=timeout, cwd=TOOL)
    except (OSError, subprocess.TimeoutExpired) as e:
        LAST['error'] = f'{type(e).__name__}: {e}'; return None
    if r.returncode != 0 or not os.path.exists(res):
        LAST['error'] = f'rc={r.returncode} {(r.stderr or r.stdout)[-300:]}'; return None
    with open(res, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


def _query(kind, items, conv):
    if os.environ.get('ASIS_SEM_OFF') == '1':   # 대조용: 의미 분석 끔(종전 정규식 결과만)
        LAST.update(requested=0, cached=0, resolved=0, error='ASIS_SEM_OFF'); return {}
    items = list(dict.fromkeys((str(f).replace('/', '\\'), int(l), str(e)) for f, l, e in items))
    LAST.update(requested=len(items), cached=0, resolved=0, error='')
    with _lock:
        cache = _load()
        todo = [it for it in items if _key(kind, *it) not in cache]
        LAST['cached'] = len(items) - len(todo)
        if todo:
            rows = _run(kind, todo)
            if rows is not None:
                by = {}
                for r in rows:
                    by.setdefault(int(r['id']), []).append(r)
                for i, it in enumerate(todo):
                    cache[_key(kind, *it)] = conv(by.get(i, []))
                    LAST['resolved'] += 1
                _save(cache)
        return {it: cache.get(_key(kind, *it)) for it in items}


def _conv_value(rows):
    r = rows[0] if rows else {}
    vals = [v for v in (r.get('values') or '').split(' || ')] if r.get('status') == 'OK' else []
    return {'status': r.get('status', 'NONE'), 'values': vals, 'unknowns': int(r.get('unknowns') or 0), 'conds': r.get('conds', '')}


def _conv_defs(rows):
    return [{'rhs': r['values'], 'file': r.get('def_file', ''), 'line': int(r.get('def_line') or 0), 'how': r.get('def_how', '')} for r in rows if r.get('status') == 'OK']


def _conv_target(rows):
    r = rows[0] if rows else {}
    if r.get('status') != 'OK':
        return None
    return {'params': [x for x in (r.get('values') or '').split(',') if x], 'sig': r.get('conds', ''), 'file': r.get('def_file', ''), 'line': int(r.get('def_line') or 0)}


def target(items):
    """호출식 → 호출 대상 소스 메서드 {'params': [매개변수 이름], 'sig': 'Ns.Cls.Method', 'file', 'line'} · 못 정하면 None"""
    return _query('target', items, _conv_target)


def values(items):
    return _query('value', items, _conv_value)


def defs(items):
    return _query('defs', items, _conv_defs)


def is_literal(v):
    return '{p:' not in v and '{?' not in v


_RX_FOX = None


def fox_endpoints(rels):
    """GSCM 상대경로 파일들의 'new FoxDataRequest(<리터럴 아닌 식>' 첫 인자를 한 번에 의미 분석으로 푼다(2026-11-25).
    리터럴 SP 이름은 호출자가 종전 정규식으로 읽는다. → {rel: [(줄, SP 이름), ...]} (값이 리터럴로 정해진 것만 · 후보 여럿이면 모두)"""
    global _RX_FOX
    import re
    if _RX_FOX is None:
        _RX_FOX = re.compile(r'new\s+FoxDataRequest\(\s*([A-Za-z_][\w.]*)\s*[,)]')
    qs, out = [], {}
    for rel in dict.fromkeys(str(r).replace('/', '\\') for r in rels):
        try:
            with open(os.path.join(ASIS, rel), encoding='utf-8-sig', errors='replace') as f:
                lines = f.read().split('\n')
        except OSError:
            continue
        for i, ln in enumerate(lines, 1):
            code = ln.split('//')[0]
            for m in _RX_FOX.finditer(code):
                if m.group(1) not in ('null', 'string.Empty'):
                    qs.append((rel, i, m.group(1)))
    if not qs:
        return out
    for (rel, ln, _e), v in values(qs).items():
        if v and v['status'] == 'OK':
            for x in v['values']:
                if x and is_literal(x):
                    out.setdefault(rel, []).append((ln, x))
    return out


def selftest():
    ok = True

    def chk(n, c, x=''):
        nonlocal ok
        print('PASS' if c else 'FAIL', n, x); ok = ok and bool(c)
    chk('키 = 공백 차이 무시', _key('value', 'a.cs', 1, 'x  +  y').split('|')[3] == 'x + y')
    chk('값 변환: OK', _conv_value([{'status': 'OK', 'values': 'A || B', 'unknowns': '0'}])['values'] == ['A', 'B'])
    chk('값 변환: 실패면 빈 목록', _conv_value([{'status': 'NOT_FOUND', 'values': ''}])['values'] == [])
    chk('정의 변환', _conv_defs([{'status': 'OK', 'values': 'Data.Get()', 'def_file': 'f.cs', 'def_line': '3', 'def_how': 'assign'}])[0]['line'] == 3)
    chk('리터럴 판정', is_literal('DM.X') and not is_literal('{?a}') and not is_literal('{p:x}'))
    if '--live' in sys.argv:   # 실제 AsisFacts 호출(컴파일 수십 초)
        r = values([(r'06.UIL\GSCM.DM.Plan.UIL\DMF0046_GetBODItemPrjRoutePopup.cs', 294, 'procdName')])
        chk('실호출: DMF0046 procdName', list(r.values())[0] and list(r.values())[0]['values'] == ['DM.DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP'], str(r) + LAST['error'])
        fx = fox_endpoints([r'06.UIL\GSCM.DM.Plan.UIL\DMF0046_GetBODItemPrjRoutePopup.cs'])
        chk('실호출: 변수 SP 이름 FoxDataRequest', (294, 'DM.DMF0046_GET_BODITEM_FOR_PRJROUTE_POPUP') in sum(fx.values(), []), str(fx))
    print('ALL PASS' if ok else 'SOME FAIL')
    return 0 if ok else 1


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    print(__doc__)
