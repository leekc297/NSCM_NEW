# -*- coding: utf-8 -*-
"""AI 검토 공용 호출기 — 검증 체인(Python)에서 Claude Code 를 읽기 전용으로 불러 JSON 답을 받는다 (2026-11-19 사용자 지시)
   "CheckList의 각각의 단계별 판단을 할 때 필요하면 클로드코드를 활용하도록 기능 보완"

  python tools/Harness/verify/llm_call.py --selftest          Claude 호출 없이 배관 시험
  python tools/Harness/verify/llm_call.py --usage [<MENU_ID>]  사용량 기록 요약(Doc/verify/_llm_usage.csv)

  다른 도구가 쓰는 함수
    cfg()                              tools/Harness/harness.json 의 llmReview* 설정
    enabled(kind)                      이 종류(facts|judge|opinion|desc)를 켰는가
    ask(mid, kind, prompt, rows=0)     Claude 1회 호출 → {'ok','data','why','cached','cost','ms'}
    verify_quote(ref, quote)           인용(경로:줄 + 원문)이 실제로 있는가 — evidence_check.check_source
    budget_left(mid)                   이번 실행에 남은 상한(USD) · None = 상한 없음

  호출 형태(선례 tools/Harness/e2e-judge.js:88-93 과 같음)
    claude -p --output-format json --permission-mode default --allowedTools Read,Glob,Grep
           --disallowedTools Edit,Write,MultiEdit,NotebookEdit,Bash,WebFetch,WebSearch [--model M] [--effort E]
    프롬프트 = stdin · cwd = 저장소 루트 · env VIBE_HARNESS=1, NSCM_SKIP_RULE_READ=1
    + --safe-mode --strict-mcp-config --tools Read,Glob,Grep --disable-slash-commands --no-session-persistence (llmReviewLean, 기본 켬)
    실행 파일 = env CLAUDE_BIN(VM 이 넘김) 없으면 claude · 모델 = harness.json llmReviewModel → env CLAUDE_MODEL → CLI 기본값
  원칙
    - 새 세션, 읽기 전용. 파일 수정·명령 실행 도구는 막는다.
    - 답은 판정이 아니라 의견이다. 판정 반영은 호출한 도구가 verify_quote 로 인용을 확인한 것만 한다.
    - 같은 입력(종류 + 프롬프트 해시)은 캐시(Doc/verify/<ID>/llm_cache.json)에서 읽고 다시 부르지 않는다.
    - 실패(시간 초과·출력 해석 실패·is_error)는 ok=False 로 돌려준다. 체인은 멈추지 않고 기계 판정을 유지한다.
    - 호출마다 Doc/verify/<ID>/llm_usage.csv 와 Doc/verify/_llm_usage.csv 에 토큰·비용·시간을 남긴다.
"""
import csv
import datetime
import hashlib
import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
import evidence_check  # noqa: E402

KINDS = ('facts', 'judge', 'opinion', 'desc')
DEFAULTS = {'llmReview': True, 'llmReviewKinds': list(KINDS), 'llmReviewModel': '', 'llmReviewEffort': 'high', 'llmReviewBudgetUsd': 0, 'llmReviewBatch': 6, 'llmReviewTimeoutMin': 20, 'llmReviewLean': True}
USAGE_COLS = ['at', 'menu_id', 'kind', 'rows', 'model', 'effort', 'input_tokens', 'output_tokens', 'cache_read_tokens', 'cache_creation_tokens', 'cost_usd', 'num_turns', 'ms', 'rc', 'cached', 'why']
_RUN_START = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def cfg():
    c = dict(DEFAULTS)
    try:
        j = json.load(open(os.path.join(ROOT, 'tools', 'Harness', 'harness.json'), encoding='utf-8-sig'))
        for k in DEFAULTS:
            if k in j:
                c[k] = j[k]
    except (OSError, ValueError):
        pass
    if os.environ.get('LLM_REVIEW', '').strip() in ('0', '1'):   # 실행 한 번만 켜고 끄기
        c['llmReview'] = os.environ['LLM_REVIEW'].strip() == '1'
    return c


def enabled(kind):
    c = cfg()
    return bool(c['llmReview']) and kind in (c['llmReviewKinds'] or [])


def vdir(mid):
    d = os.path.join(ROOT, 'Doc', 'verify', mid)
    os.makedirs(d, exist_ok=True)
    return d


# 2026-11-20 C3(AI 검토 동시 호출): 같은 프로세스 안 여러 스레드가 캐시와 사용량 파일을 같이 쓴다 — 읽고 고쳐 쓰는 구간을 잠근다
import threading as _th
_LOCK = _th.RLock()


def _append(path, row):
  with _LOCK:
    new = not os.path.exists(path)
    with open(path, 'a', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=USAGE_COLS, extrasaction='ignore')
        if new:
            w.writeheader()
        w.writerow(row)


def log_usage(mid, row):
    row = dict({k: '' for k in USAGE_COLS}, **row)
    row['at'] = now(); row['menu_id'] = mid
    for p in (os.path.join(vdir(mid), 'llm_usage.csv'), os.path.join(ROOT, 'Doc', 'verify', '_llm_usage.csv')):
        try:
            _append(p, row)
        except OSError as e:
            print(f'[WARN] 사용량 기록 실패 {os.path.relpath(p, ROOT)}: {e}')


def read_usage(mid=None):
    p = os.path.join(vdir(mid), 'llm_usage.csv') if mid else os.path.join(ROOT, 'Doc', 'verify', '_llm_usage.csv')
    try:
        return list(csv.DictReader(open(p, encoding='utf-8-sig')))
    except OSError:
        return []


def spent(mid, since=None):
    """이번 실행(since 이후)에 이 화면이 쓴 비용 합(USD) — 캐시 적중은 0"""
    since = since or os.environ.get('LLM_RUN_START') or _RUN_START
    t = 0.0
    for r in read_usage(mid):
        if (r.get('at') or '') >= since and r.get('cached') != 'Y':
            try:
                t += float(r.get('cost_usd') or 0)
            except ValueError:
                pass
    return t


def budget_left(mid):
    b = float(cfg().get('llmReviewBudgetUsd') or 0)
    return None if b <= 0 else b - spent(mid)


def _cache_path(mid):
    return os.path.join(vdir(mid), 'llm_cache.json')


def _cache_load(mid):
    try:
        return json.load(open(_cache_path(mid), encoding='utf-8'))
    except (OSError, ValueError):
        return {}


def _cache_save(mid, c):
    # 동시 호출 안전: 저장 직전 파일을 다시 읽어 합친다(다른 스레드가 먼저 쓴 항목 보존)
    with _LOCK:
        cur = _cache_load(mid); cur.update(c)
        tmp = _cache_path(mid) + f'.{os.getpid()}.{_th.get_ident()}.tmp'
        with open(tmp, 'w', encoding='utf-8') as f:
            json.dump(cur, f, ensure_ascii=False)
        os.replace(tmp, _cache_path(mid))


def key_of(kind, prompt):
    return kind + ':' + hashlib.sha1(prompt.encode('utf-8')).hexdigest()


def parse_json(text):
    """답 본문에서 JSON 하나를 꺼낸다(코드펜스·앞뒤 문장 허용) — 실패 = None"""
    t = re.sub(r'^```(?:json)?\s*', '', str(text or '').strip(), flags=re.M)
    t = re.sub(r'```\s*$', '', t, flags=re.M)
    i = t.find('{'); k = t.rfind('}')
    if i < 0 or k < i:
        return None
    try:
        return json.loads(t[i:k + 1])
    except ValueError:
        return None


def claude_cmd():
    b = (os.environ.get('CLAUDE_BIN') or '').strip() or 'claude'
    c = cfg()
    args = ['-p', '--output-format', 'json', '--permission-mode', 'default', '--allowedTools', 'Read,Glob,Grep',
            '--disallowedTools', 'Edit,Write,MultiEdit,NotebookEdit,Bash,WebFetch,WebSearch']
    if c.get('llmReviewLean', True):
        # 2026-11-19 16:14 실측(한 줄 읽기 1회): 기본 호출 1.245 USD · 76초(세션 기본 문맥 약 12만 토큰이 호출마다 실림) → 아래 옵션 0.120 USD · 17초.
        #   CLAUDE.md·메모리·hook·MCP·스킬을 싣지 않는다 — 검토에 필요한 규칙은 프롬프트가 직접 싣는다. 도구는 Read·Glob·Grep 만 정의한다.
        args += ['--safe-mode', '--strict-mcp-config', '--tools', 'Read,Glob,Grep', '--disable-slash-commands', '--no-session-persistence']
    m = str(c.get('llmReviewModel') or '').strip() or (os.environ.get('CLAUDE_MODEL') or '').strip()
    if m:
        args += ['--model', m]
    e = str(c.get('llmReviewEffort') or '').strip().lower()
    if e in ('low', 'medium', 'high', 'xhigh', 'max'):
        args += ['--effort', e]
    return b, args, m, e


def _spawn(prompt, timeout):
    b, args, m, e = claude_cmd()
    # .exe 는 직접, .cmd/.bat·이름만(PATH) 은 셸로 — Windows 에서 래퍼 스크립트는 셸이 있어야 실행된다(e2e-judge.js 는 항상 shell)
    direct = b.lower().endswith('.exe') and os.path.isfile(b)
    env = dict(os.environ, VIBE_HARNESS='1', NSCM_SKIP_RULE_READ='1')
    if direct:
        cmd, shell = [b] + args, False
    else:
        q = f'"{b}"' if re.search(r'\s', b) else b
        cmd, shell = ' '.join([q] + [f'"{a}"' if re.search(r'[\s,]', a) else a for a in args]), True
    p = subprocess.run(cmd, input=prompt.encode('utf-8'), cwd=ROOT, env=env, shell=shell, capture_output=True, timeout=timeout)
    return p.returncode, p.stdout.decode('utf-8', 'replace'), p.stderr.decode('utf-8', 'replace'), m, e


def ask(mid, kind, prompt, rows=0, use_cache=True, from_text=None):
    """Claude 1회 호출. from_text 를 주면 호출 없이 그 글을 답으로 해석(배관 시험)"""
    k = key_of(kind, prompt)
    cache = _cache_load(mid) if use_cache else {}
    if use_cache and k in cache and from_text is None:
        log_usage(mid, {'kind': kind, 'rows': rows, 'cached': 'Y', 'rc': 0, 'cost_usd': 0})
        return {'ok': True, 'data': cache[k]['data'], 'why': '캐시', 'cached': True, 'cost': 0.0, 'ms': 0}
    if from_text is not None:
        d = parse_json(from_text)
        return {'ok': d is not None, 'data': d, 'why': '' if d is not None else '답 JSON 해석 실패', 'cached': False, 'cost': 0.0, 'ms': 0}
    left = budget_left(mid)
    if left is not None and left <= 0:
        return {'ok': False, 'data': None, 'why': f"상한 초과(llmReviewBudgetUsd {cfg()['llmReviewBudgetUsd']})", 'cached': False, 'cost': 0.0, 'ms': 0, 'skipped': True}
    t0 = datetime.datetime.now()
    use = {'kind': kind, 'rows': rows, 'cached': 'N'}
    try:
        rc, out, err, m, e = _spawn(prompt, int(cfg().get('llmReviewTimeoutMin') or 20) * 60)
    except subprocess.TimeoutExpired:
        use.update(rc=-1, why='시간 초과', ms=int((datetime.datetime.now() - t0).total_seconds() * 1000)); log_usage(mid, use)
        return {'ok': False, 'data': None, 'why': '시간 초과', 'cached': False, 'cost': 0.0, 'ms': use['ms']}
    except OSError as ex:
        use.update(rc=-2, why=f'실행 실패: {ex}'[:200]); log_usage(mid, use)
        return {'ok': False, 'data': None, 'why': use['why'], 'cached': False, 'cost': 0.0, 'ms': 0}
    ms = int((datetime.datetime.now() - t0).total_seconds() * 1000)
    use.update(rc=rc, ms=ms, model=m, effort=e)
    try:
        j = json.loads(out)
    except ValueError:
        use['why'] = ('출력 해석 실패: ' + (err or out).strip().replace('\n', ' '))[:200]; log_usage(mid, use)
        return {'ok': False, 'data': None, 'why': use['why'], 'cached': False, 'cost': 0.0, 'ms': ms}
    u = j.get('usage') or {}
    cost = float(j.get('total_cost_usd') or 0)
    mu = j.get('modelUsage') or {}
    use.update(input_tokens=u.get('input_tokens', ''), output_tokens=u.get('output_tokens', ''), cache_read_tokens=u.get('cache_read_input_tokens', ''),
               cache_creation_tokens=u.get('cache_creation_input_tokens', ''), cost_usd=cost, num_turns=j.get('num_turns', ''),
               model=m or ','.join(sorted(mu.keys())), ms=j.get('duration_ms') or ms)
    if j.get('is_error'):
        use['why'] = ('Claude 오류: ' + str(j.get('result') or ''))[:200]; log_usage(mid, use)
        return {'ok': False, 'data': None, 'why': use['why'], 'cached': False, 'cost': cost, 'ms': ms}
    d = parse_json(j.get('result'))
    if d is None:
        use['why'] = '답 JSON 해석 실패'; log_usage(mid, use)
        return {'ok': False, 'data': None, 'why': use['why'], 'cached': False, 'cost': cost, 'ms': ms, 'raw': str(j.get('result') or '')[:2000]}
    log_usage(mid, use)
    if use_cache:
        cache = _cache_load(mid); cache[k] = {'at': now(), 'kind': kind, 'data': d}; _cache_save(mid, cache)
    return {'ok': True, 'data': d, 'why': '', 'cached': False, 'cost': cost, 'ms': ms}


def verify_quote(ref, quote):
    """(확인됨, 사유) — ref '경로:줄'·'경로:줄-줄'·'경로' + 그 줄 원문 인용(문자열 또는 한 줄 안 토큰 배열)"""
    if not str(ref or '').strip():
        return False, '근거 경로 없음'
    ev = {'kind': 'source', 'ref': str(ref).strip(), 'expect': quote}
    ok, why = evidence_check.check_source(ev)
    return bool(ok), why


def usage_summary(mid=None):
    rows = read_usage(mid)
    by = {}
    for r in rows:
        k = (r.get('menu_id') or '', r.get('kind') or '')
        a = by.setdefault(k, {'calls': 0, 'cached': 0, 'cost': 0.0, 'in': 0, 'out': 0, 'ms': 0, 'fail': 0})
        if r.get('cached') == 'Y':
            a['cached'] += 1; continue
        a['calls'] += 1
        a['fail'] += 1 if (r.get('why') or '').strip() else 0
        for f, c in (('cost', 'cost_usd'), ('in', 'input_tokens'), ('out', 'output_tokens'), ('ms', 'ms')):
            try:
                a[f] += float(r.get(c) or 0)
            except ValueError:
                pass
    return by


def selftest():
    ok = True

    def chk(name, cond):
        nonlocal ok
        print(f"  [{'OK' if cond else 'FAIL'}] {name}")
        ok = ok and bool(cond)
    chk('JSON 추출 — 코드펜스', parse_json('```json\n{"a":1}\n```') == {'a': 1})
    chk('JSON 추출 — 앞뒤 문장', parse_json('결과입니다 {"items":[{"x":"}"}]} 끝') == {'items': [{'x': '}'}]})
    chk('JSON 추출 — 없음', parse_json('답 없음') is None)
    chk('키 — 같은 입력 같은 키', key_of('judge', 'p') == key_of('judge', 'p') and key_of('judge', 'p') != key_of('desc', 'p'))
    me = os.path.relpath(os.path.abspath(__file__), ROOT).replace(os.sep, '/')
    chk('인용 확인 — 있는 줄', verify_quote(me + ':1', 'coding: utf-8')[0])
    chk('인용 확인 — 없는 원문', not verify_quote(me + ':1', '이 문장은 그 줄에 없다 zzqq')[0])
    chk('인용 확인 — 인용 없음', not verify_quote(me + ':1', '')[0])
    chk('인용 확인 — 없는 파일', not verify_quote('tools/없는파일.py:1', 'x')[0])
    b, args, m, e = claude_cmd()
    chk('명령줄 — 읽기 전용 도구', 'Read,Glob,Grep' in args and 'Edit,Write,MultiEdit,NotebookEdit,Bash,WebFetch,WebSearch' in args and '--permission-mode' in args)
    r = ask('_SELFTEST', 'judge', 'p', from_text='{"items":[]}')
    chk('ask — 배관(from_text)', r['ok'] and r['data'] == {'items': []})
    c = cfg()
    chk('설정 — 기본 키', all(k in c for k in DEFAULTS))
    try:
        os.rmdir(os.path.join(ROOT, 'Doc', 'verify', '_SELFTEST'))
    except OSError:
        pass
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    a = sys.argv[1:]
    if not a:
        print(__doc__); return 2
    if a[0] == '--selftest':
        return selftest()
    if a[0] == '--usage':
        mid = a[1].upper() if len(a) > 1 else None
        by = usage_summary(mid)
        if not by:
            print('사용량 기록 없음'); return 0
        print('menu_id,kind,calls,cached,fail,input_tokens,output_tokens,cost_usd,sec')
        for (m_, k), v in sorted(by.items()):
            print(f"{m_},{k},{v['calls']},{v['cached']},{v['fail']},{int(v['in'])},{int(v['out'])},{v['cost']:.4f},{int(v['ms'] / 1000)}")
        return 0
    print(__doc__); return 2


if __name__ == '__main__':
    sys.exit(main())
