# -*- coding: utf-8 -*-
"""CheckList 중복 실태표(2026-11-25 사용자 승인 플랜 '검사 대상 중복 제거' D0)

  python tools/Harness/verify/dup_audit.py <MENU_ID> [--since '<YYYY-MM-DDTHH:MM>'] [--until '<…>']   → Doc/verify/<ID>/dup_audit.md · dup_audit.json
  python tools/Harness/verify/dup_audit.py --selftest

  1층 검사 행: 원장 행을 같은 확인 키(규칙, 대상 객체, 조건 종류)로 묶어 출처 조합과 판정 일치 여부를 센다(dedup_pre.check_key 와 같은 키)
  2층 측정 동작: _test_timing.jsonl(시험별 로그인·열기·조회·본문 ms) · calls/*.json(같은 호출 반복) · e2e_test_kind.jsonl(읽기/쓰기 시험)
  3층 문서: 집계 행(GENERAL) 수, 대조표(TRACE) 행 중 다른 출처와 같은 확인인 행 수
  --since/--until = 시험 기록 구간(UTC ISO, _test_timing.jsonl 'at' 기준). 없으면 마지막 전체 측정(run_mode.json full 시각) 뒤
  판정·원장은 바꾸지 않는다(읽기만)
"""
import collections, csv, datetime, glob, hashlib, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 8)


def _read(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as fh:
            return list(csv.DictReader(fh))
    except OSError:
        return []


def _jsonl(p):
    out = []
    try:
        for ln in open(p, encoding='utf-8'):
            try:
                out.append(json.loads(ln))
            except ValueError:
                continue
    except OSError:
        pass
    return out


def layer_rows(led):
    import dedup_pre as D
    groups = collections.defaultdict(list)
    for r in led:
        k = D.check_key(r)
        if k:
            groups[k].append(r)
    multi = {k: v for k, v in groups.items() if len(v) > 1}
    mix = collections.Counter(' + '.join(sorted({x.get('source', '') for x in v})) for v in multi.values())
    same = sum(1 for v in multi.values() if len({x.get('result') for x in v}) == 1)
    return {'rows': len(led), 'by_source': dict(collections.Counter(r.get('source', '') for r in led).most_common()), 'groups': len(multi),
            'group_rows': sum(len(v) for v in multi.values()), 'members': sum(len(v) - 1 for v in multi.values()), 'same_verdict_groups': same,
            'mixed_verdict_groups': len(multi) - same, 'source_mix': dict(mix.most_common(12)), 'general_rows': sum(1 for r in led if r.get('source') == 'GENERAL'),
            'examples': [[(x['row_id'], x.get('source'), x.get('result')) for x in v] for v in list(multi.values())[:8]]}


def layer_tests(vd, since, until):
    t = [x for x in _jsonl(os.path.join(vd, '_test_timing.jsonl')) if since <= str(x.get('at', '')) < until]
    ms = lambda k: sum(((x.get('ms') or {}).get(k) or 0) for x in t)
    login_bug = sum(max(0, ((x.get('ms') or {}).get('login') or 0) - 5000) for x in t)
    fixed = sum(min(((x.get('ms') or {}).get('login') or 0), 5000) + ((x.get('ms') or {}).get('open') or 0) + ((x.get('ms') or {}).get('search') or 0) for x in t)
    kinds = {}
    for k in _jsonl(os.path.join(vd, 'e2e_test_kind.jsonl')):
        kinds[(k.get('file'), k.get('title'))] = bool(k.get('write'))
    return {'tests': len(t), 'total_min': round(ms('total') / 60000, 1), 'login_wait_over5s_min': round(login_bug / 60000, 1), 'fixed_min': round(fixed / 60000, 1),
            'body_min': round(ms('body') / 60000, 1), 'wait_min': round(ms('wait') / 60000, 1), 'read_tests': sum(1 for v in kinds.values() if not v), 'write_tests': sum(1 for v in kinds.values() if v),
            'by_file': dict(collections.Counter(x.get('file', '') for x in t))}


def layer_calls(vd):
    calls = collections.Counter(); tests = collections.defaultdict(set); dur = collections.defaultdict(float); what = {}
    for f in glob.glob(os.path.join(vd, 'calls', '*.json')):
        try:
            arr = json.load(open(f, encoding='utf-8'))
        except (OSError, ValueError):
            continue
        for c in arr if isinstance(arr, list) else []:
            k = hashlib.md5((str(c.get('url', '')) + '|' + str(c.get('postData', ''))).encode('utf-8')).hexdigest()
            calls[k] += 1; tests[k].add(c.get('test', '')); dur[k] += float(c.get('dur') or 0); what[k] = f"{c.get('sheet', '')}/{c.get('btn', '')}"
    tot = sum(calls.values())
    top = sorted(calls, key=lambda k: -calls[k])[:6]
    return {'calls': tot, 'distinct': len(calls), 'repeats': tot - len(calls), 'repeat_server_sec': round(sum(dur[k] * (calls[k] - 1) / calls[k] for k in calls) / 1000, 1),
            'top': [{'what': what[k], 'n': calls[k], 'tests': len(tests[k]), 'avg_ms': round(dur[k] / calls[k])} for k in top]}


def layer_features(vd, since, until):
    """같은 기능(팝업, 저장)을 여는 시험 — 제목 기준(분류 근거를 문서에 남김)"""
    t = [x for x in _jsonl(os.path.join(vd, '_test_timing.jsonl')) if since <= str(x.get('at', '')) < until]
    cat = collections.defaultdict(list)
    for x in t:
        ti = x.get('title') or ''
        if re.search(r'팝업|POPUP|PCOL|eg_popup|#\d+ \w+Popup', ti, re.I) or (x.get('file') or '').startswith('eg_popup'):
            cat['팝업'].append(x)
        if re.search(r'저장|CRUD|Save', ti):
            cat['저장'].append(x)
    adj = lambda x: ((x.get('ms') or {}).get('total', 0) - max(0, (x.get('ms') or {}).get('login', 0) - 5000)) / 60000
    return {k: {'tests': len(v), 'min': round(sum(adj(x) for x in v), 1), 'titles': sorted({(x.get('file', ''), x.get('title', '')[:80]) for x in v})[:20]} for k, v in cat.items()}


def window(vd):
    """시험 수가 가장 많은 실행(vrun = VERIFY_RUN_ID, 전체 측정)의 시험 기록 구간 — 부분 실행(row_run, --only)은 건너뜀"""
    t = _jsonl(os.path.join(vd, '_test_timing.jsonl'))
    by = collections.defaultdict(list)
    for x in t:
        by[x.get('vrun') or ''].append(str(x.get('at', '')))
    runs = sorted(((len(v), min(v), max(v), k) for k, v in by.items() if k and len(v) >= 30), reverse=True)   # 시험 수가 가장 많은 실행 = 전체 측정
    if not runs:
        return '', '9999'
    _n, lo, hi, _k = runs[0]
    return lo, hi + 'Z'


def main(argv):
    mid = argv[0].upper(); vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    led = _read(os.path.join(vd, 'verify_ledger.csv'))
    if not led:
        print(f'[ERROR] 원장 없음: Doc/verify/{mid}/verify_ledger.csv'); return 3
    since, until = window(vd)
    if '--since' in argv:
        since = argv[argv.index('--since') + 1]
    if '--until' in argv:
        until = argv[argv.index('--until') + 1]
    out = {'menu_id': mid, 'at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'window_utc': [since, until],
           'rows': layer_rows(led), 'tests': layer_tests(vd, since, until), 'calls': layer_calls(vd), 'features': layer_features(vd, since, until)}
    json.dump(out, open(os.path.join(vd, 'dup_audit.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    R, T, C = out['rows'], out['tests'], out['calls']
    md = [f'# {mid} 중복 실태표 · {out["at"]}', '',
          f'- 시험 기록 구간(UTC): {since or "처음"} ~ {until}', '',
          '## 1층 검사 행', '',
          f'- 원장 {R["rows"]}행 · 출처별 ' + ', '.join(f'{k} {v}' for k, v in R['by_source'].items()),
          f'- 같은 확인 묶음 {R["groups"]}개({R["group_rows"]}행, 대표 외 구성원 {R["members"]}행) · 판정 모두 같음 {R["same_verdict_groups"]} · 판정 다름 {R["mixed_verdict_groups"]}',
          '- 출처 조합: ' + ', '.join(f'{k} {v}' for k, v in R['source_mix'].items()),
          f'- 집계 행(GENERAL) {R["general_rows"]}', '',
          '## 2층 측정 동작', '',
          f'- 시험 {T["tests"]}개 · 시험 시간 합 {T["total_min"]}분 · 로그인 5초 초과분 {T["login_wait_over5s_min"]}분 · 시험마다 되풀이한 로그인(5초까지)·열기·조회 {T["fixed_min"]}분 · 본문 {T["body_min"]}분',
          f'- 읽기 시험 {T["read_tests"]} · 쓰기 시험 {T["write_tests"]} · 스펙별 ' + ', '.join(f'{k} {v}' for k, v in T['by_file'].items()),
          f'- 포착 호출 {C["calls"]}건 · 서로 다른 호출 {C["distinct"]}건 · 반복 {C["repeats"]}건 · 반복분 서버 시간 {C["repeat_server_sec"]}초',
          '- 많이 반복된 호출: ' + '; '.join(f'{x["what"]} {x["n"]}회(시험 {x["tests"]}개, 평균 {x["avg_ms"]}ms)' for x in C['top']), '']
    for k, v in out['features'].items():
        md.append(f'- 같은 기능 {k}: 시험 {v["tests"]}개 · {v["min"]}분 · ' + '; '.join(f'{f}:{t}' for f, t in v['titles'][:10]))
    open(os.path.join(vd, 'dup_audit.md'), 'w', encoding='utf-8').write('\n'.join(md) + '\n')
    print('\n'.join(md[4:]), flush=True)
    print(f'@@LINK 📊 중복 실태표|{os.path.join(vd, "dup_audit.md")}', flush=True)
    return 0


def selftest():
    import dedup_pre as D
    ok = True
    led = [{'row_id': 'V-1', 'source': 'ASIS', 'rule_id': 'A6', 'target': 'SCP_GET_X', 'condition': '', 'asis_ref': 'X.cs:10', 'result': 'PASS'},
           {'row_id': 'T-1', 'source': 'TRACE', 'rule_id': 'A6', 'target': 'SCP_GET_X', 'condition': '{"et": "SP"}', 'asis_ref': 'X.cs:10', 'result': 'PASS'},
           {'row_id': 'V-2', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'S.COL', 'condition': '신규행', 'asis_ref': 'X.cs:20', 'result': 'PASS'},
           {'row_id': 'V-3', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'S.COL', 'condition': '기존행', 'asis_ref': 'X.cs:20', 'result': 'PASS'}]
    r = layer_rows(led)
    for n, c in (('SP·TRACE 같은 확인 1묶음, 신규행·기존행은 다른 확인', r['groups'] == 1 and r['members'] == 1),):
        print('PASS' if c else 'FAIL', n); ok &= c
    print('selftest', 'OK' if ok else 'FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1:2] == ['--selftest'] else main(sys.argv[1:]))
