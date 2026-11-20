# -*- coding: utf-8 -*-
"""결함 유형 행 중복 정리 — AI 판단 (2026-11-20 사용자 지시)
   "중복되는 작업에 대해서는 중복제거를 진행해서 목록으로 관리하고, CHECKLIST 진행시에도 중복제거된 목록으로 진행 · 중복판단여부는 AI 가 판단"
   "현재의 대조표는 중복이 많은 것으로 판단됩니다"

  python tools/Harness/verify/dedup_general.py                 바뀐 규칙만 AI 판단(규칙별 입력 해시가 같으면 지난 판단 재사용) → 목록 갱신
  python tools/Harness/verify/dedup_general.py --rule A1,G4    지정 규칙만
  python tools/Harness/verify/dedup_general.py --force         전 규칙 다시 판단
  python tools/Harness/verify/dedup_general.py --dry           대상 규칙·항목 수·호출 수만 출력(Claude 호출 없음)
  python tools/Harness/verify/dedup_general.py --selftest

  배경: ledger.py 5-b 가 다른 화면 결함(defects_baseline.csv × defects_classified.csv rule_ids)을 화면마다 'GENERAL' 행으로 넣는다.
        전 화면 공통 후보 727쌍(결함 × 규칙), 화면마다 495~504행(SCP0028 원장 1,612행 중 GENERAL 674행 · 2026-11-20 실측).
        같은 확인(예: '조회 결과 건수 = AS-IS')이 화면별 결함 이름만 달리 10건 넘게 들어가 판정, AI 판정 검토, 문서가 같은 일을 되풀이했다.
  처리: 규칙마다 후보 항목을 Claude(읽기 전용)에 넘겨 '임의 화면에서 같은 확인을 하게 되는 항목'끼리 묶는다. 묶음마다 대표 대상, 조건, 기대 문장.
        확신이 없으면 묶지 않는다(단독 묶음). 모든 항목은 정확히 1개 묶음에 들어가야 한다(빠지거나 겹치면 그 규칙은 전부 단독 묶음으로 둔다).
  산출: Doc/verify/_dedup/general_groups.csv(목록 · 사람이 열어 보는 정본) · Doc/verify/_dedup/rule_<규칙>.json(규칙별 판단, 입력 해시)
        ledger.py 가 harness.json dedupGeneral(기본 true) 이면 이 목록으로 묶음 1개 = GENERAL 행 1개를 만들고 묶인 결함 번호를 asis_ref 에 모두 남긴다.
"""
import argparse, collections, concurrent.futures, csv, datetime, hashlib, json, os, sys, threading

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 8)
OUT = os.path.join(ROOT, 'Doc', 'verify', '_dedup')
LIST = os.path.join(OUT, 'general_groups.csv')
COLS = ['rule_id', 'group_id', 'ref', 'menu_id', 'member_target', 'target', 'condition', 'expected', 'size', 'why', 'judged_by', 'judged_at']


def P(*a):
    return os.path.join(ROOT, *a)


def read_csv(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as f:
            return list(csv.DictReader(f))
    except OSError:
        return []


def candidates():
    """ledger.py 5-b 와 같은 조건으로 (결함, 규칙) 후보 → {rule_id: [항목]} (화면 구분 없이 전체)"""
    cls = {(r['src'], r['no']): r for r in read_csv(P('Doc', 'verify', 'defects_classified.csv'))}
    out = collections.defaultdict(list)
    for d in read_csv(P('Doc', 'verify', 'defects_baseline.csv')):
        c = cls.get((d['src'], d['no']), {})
        if (c.get('status') or '') in ('DESIGN', 'INFO', 'REQ', 'SPLIT') or (c.get('generalize') or 'Y').strip().upper() == 'N':
            continue
        gen = (c.get('general_rule') or '').strip().upper() == 'Y'
        for rid in [x.strip() for x in (c.get('rule_ids') or '').split(';') if x.strip()]:
            out[rid].append({'ref': f"{d['src']}-{d['no']}", 'menu_id': d['menu_id'], 'target': (c.get('target') or d['test_content'][:60]).strip(),
                             'condition': (c.get('condition') or '').strip()[:200], 'expected': ((c.get('general_rule_text') or '').strip() if gen else '') or (c.get('expected') or '').strip()[:300]})
    for rid in out:
        out[rid].sort(key=lambda x: x['ref'])
    return out


def in_hash(items):
    return hashlib.sha1(json.dumps([[x['ref'], x['target'], x['condition'], x['expected']] for x in items], ensure_ascii=False).encode('utf-8')).hexdigest()[:16]


PROMPT = """너는 화면 검증 목록의 중복을 가르는 검토자다. 아래는 검증 규칙 {rid}({rname})로 분류된, 여러 화면에서 나온 결함 항목 {n}건이다.
이 항목들은 다른 화면 검증 때 '이 화면에도 같은 형태의 오류가 있는지' 확인하는 행으로 하나씩 들어간다.

할 일: 임의의 화면에서 확인할 때 **같은 확인 동작과 같은 기대 결과**가 되는 항목끼리 묶어라.
- 묶는 기준: 확인 대상의 종류(예: 조회 결과 건수, 특정 조회조건의 표시, 팝업 폭)와 기대 결과가 같으면 같은 묶음. 원래 화면 이름, 사업부, 기간 같은 원 결함의 조건 차이는 무시한다.
- 확인 대상의 종류가 다르면(예: Version 조회조건 폭 vs Project 조회조건 표시) 다른 묶음.
- 확신이 없으면 묶지 말고 단독 묶음으로 둔다. 잘못 묶으면 검사가 빠지므로 묶지 않는 쪽이 안전하다.
- 모든 항목 번호(ref)는 정확히 1개 묶음에 들어가야 한다.
- 묶음마다 target(확인 대상, 30자 안팎), condition(확인 조건, 비워도 됨), expected(기대 결과) 를 임의 화면 기준 문장으로 쓴다. 묶인 항목의 대상 낱말(영문 컬럼, 조건 이름)을 expected 에 남긴다.
- why 에 묶은 이유를 한 문장으로 쓴다.

항목(JSON 줄):
{items}

답은 JSON 하나만: {{"groups": [{{"refs": ["GAP-12", "..."], "target": "...", "condition": "...", "expected": "...", "why": "..."}}]}}"""


def rule_names():
    # 검사 정의(mapping_checkdefs.csv: check · 이름 열) — 규칙 이름을 프롬프트에 붙인다
    out = {}
    for r in read_csv(os.path.join(HERE, 'mapping_checkdefs.csv')):
        out[r.get('check', '')] = (r.get('how') or r.get('checker') or '')[:160]
    return out


def validate(items, data):
    """답 검증 → (묶음 목록, 사유). 사유가 있으면 전부 단독 묶음으로 바꾼 목록"""
    refs = [x['ref'] for x in items]; by = {x['ref']: x for x in items}
    single = [{'refs': [r], 'target': by[r]['target'], 'condition': by[r]['condition'], 'expected': by[r]['expected'], 'why': '단독'} for r in refs]
    if not isinstance(data, dict) or not isinstance(data.get('groups'), list):
        return single, '답 형식 오류'
    seen = collections.Counter(); gs = []
    for g in data['groups']:
        rs = [str(x) for x in (g.get('refs') or []) if str(x) in by]
        if not rs:
            continue
        seen.update(rs); gs.append({'refs': rs, 'target': str(g.get('target') or by[rs[0]]['target'])[:120], 'condition': str(g.get('condition') or '')[:200],
                                    'expected': str(g.get('expected') or by[rs[0]]['expected'])[:600], 'why': str(g.get('why') or '')[:300]})
    missing = [r for r in refs if not seen[r]]; dup = [r for r, n in seen.items() if n > 1]
    if missing or dup:
        return single, f"항목 빠짐 {len(missing)} · 겹침 {len(dup)}"
    return gs, ''


def judge_rule(rid, items, rname, ask=None):
    """규칙 1개 판단 → 결과 dict(rule_id, hash, groups, why, by, at)"""
    if len(items) == 1:
        g, _ = validate(items, None)
        return {'rule_id': rid, 'hash': in_hash(items), 'groups': g, 'why': '항목 1건', 'by': '코드', 'at': now()}
    lines = '\n'.join(json.dumps({'ref': x['ref'], 'screen': x['menu_id'], 'target': x['target'], 'condition': x['condition'], 'expected': x['expected']}, ensure_ascii=False) for x in items)
    prompt = PROMPT.format(rid=rid, rname=rname or '', n=len(items), items=lines)
    if ask is None:
        import llm_call
        ask = lambda p: llm_call.ask('_DEDUP', 'dedup', p, rows=len(items), use_cache=False)
    r = ask(prompt)
    gs, why = validate(items, r.get('data') if r.get('ok') else None)
    if not r.get('ok'):
        why = f"AI 답 없음({r.get('why', '')}) · 단독 묶음"
    return {'rule_id': rid, 'hash': in_hash(items), 'groups': gs, 'why': why, 'by': 'AI' if not why else '코드(단독)', 'at': now(), 'cost': r.get('cost', 0)}


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def write_list(cands, results):
    rows = []
    for rid in sorted(results):
        res = results[rid]; by = {x['ref']: x for x in cands.get(rid, [])}
        for gi, g in enumerate(res['groups'], 1):
            for ref in g['refs']:
                x = by.get(ref, {})
                rows.append({'rule_id': rid, 'group_id': f'{rid}-G{gi:02d}', 'ref': ref, 'menu_id': x.get('menu_id', ''), 'member_target': x.get('target', ''), 'target': g['target'],
                             'condition': g['condition'], 'expected': g['expected'], 'size': len(g['refs']), 'why': g.get('why', ''), 'judged_by': res['by'], 'judged_at': res['at']})
    os.makedirs(OUT, exist_ok=True); tmp = LIST + '.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(rows)
    os.replace(tmp, LIST)
    return rows


def load_groups():
    """ledger.py 용: {(rule_id, ref): {group_id, target, condition, expected, size}} · 목록 없으면 {}"""
    out = {}
    for r in read_csv(LIST):
        out[(r['rule_id'], r['ref'])] = r
    return out


def run(rules=None, force=False, dry=False, ask=None, par=None):
    cands = candidates(); names = rule_names(); results = {}; todo = []
    for rid, items in sorted(cands.items()):
        f = os.path.join(OUT, f'rule_{rid}.json'); old = None
        try:
            old = json.load(open(f, encoding='utf-8'))
        except (OSError, ValueError):
            pass
        if (rules and rid not in rules) or (not force and old and old.get('hash') == in_hash(items)):
            if old and old.get('hash') == in_hash(items):
                results[rid] = old
            elif old:
                results[rid] = None  # 입력이 바뀌었지만 이번 대상 아님 → 아래에서 단독 묶음
            continue
        todo.append(rid)
    n_items = sum(len(cands[r]) for r in todo); n_call = sum(1 for r in todo if len(cands[r]) > 1)
    print(f"[중복 정리] 규칙 {len(cands)}개 · 항목 {sum(len(v) for v in cands.values())}건 · 이번 판단 규칙 {len(todo)}개(항목 {n_items}건 · AI 호출 {n_call}회) · 재사용 {sum(1 for v in results.values() if v)}개", flush=True)
    if dry:
        return 0
    if par is None:
        try:
            par = int(json.load(open(P('tools', 'Harness', 'harness.json'), encoding='utf-8-sig')).get('llmReviewPar') or 4)
        except (OSError, ValueError):
            par = 4
    lock = threading.Lock(); done = [0]

    def one(rid):
        res = judge_rule(rid, cands[rid], names.get(rid, ''), ask)
        os.makedirs(OUT, exist_ok=True)
        with open(os.path.join(OUT, f'rule_{rid}.json'), 'w', encoding='utf-8') as f:
            json.dump(res, f, ensure_ascii=False, indent=1)
        with lock:
            done[0] += 1
            print(f"  · 중복 판단 {done[0]}/{len(todo)} {rid} 항목 {len(cands[rid])} → 묶음 {len(res['groups'])}{(' · ' + res['why']) if res['why'] else ''}", flush=True)
        return rid, res
    with concurrent.futures.ThreadPoolExecutor(max_workers=max(1, par)) as ex:
        for rid, res in ex.map(one, todo):
            results[rid] = res
    for rid in cands:
        if not results.get(rid):
            g, _ = validate(cands[rid], None); results[rid] = {'rule_id': rid, 'hash': '', 'groups': g, 'why': '판단 전', 'by': '코드(단독)', 'at': now()}
    rows = write_list(cands, results)
    ng = len({r['group_id'] for r in rows}); ni = len(rows)
    print(f"[중복 정리] 항목 {ni}건 → 묶음 {ng}개(줄어든 행 {ni - ng}) → Doc/verify/_dedup/general_groups.csv", flush=True)
    return 0


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    items = [{'ref': f'GAP-{i}', 'menu_id': 'X', 'target': t, 'condition': '', 'expected': e} for i, (t, e) in enumerate([('조회 건수', '건수=AS-IS'), ('조회 결과 건수', 'AS-IS 동일 건수'), ('Version 폭', '폭 축소')], 1)]
    g, why = validate(items, {'groups': [{'refs': ['GAP-1', 'GAP-2'], 'target': '조회 결과 건수', 'expected': '건수 = AS-IS'}, {'refs': ['GAP-3'], 'target': 'Version 폭'}]})
    chk('정상 답 = 묶음 2개', not why and len(g) == 2 and g[0]['refs'] == ['GAP-1', 'GAP-2'])
    g, why = validate(items, {'groups': [{'refs': ['GAP-1', 'GAP-2']}]})
    chk('항목 빠짐 = 전부 단독', why.startswith('항목 빠짐 1') and len(g) == 3)
    g, why = validate(items, {'groups': [{'refs': ['GAP-1', 'GAP-2']}, {'refs': ['GAP-2', 'GAP-3']}]})
    chk('겹침 = 전부 단독', '겹침 1' in why and len(g) == 3)
    g, why = validate(items, 'x'); chk('형식 오류 = 전부 단독', why == '답 형식 오류' and len(g) == 3)
    res = judge_rule('A1', items, '', ask=lambda p: {'ok': True, 'data': {'groups': [{'refs': ['GAP-1', 'GAP-2'], 'target': 't'}, {'refs': ['GAP-3'], 'target': 'v'}]}, 'cost': 0.1})
    chk('규칙 판단(가짜 AI) = AI 판단 · 묶음 2', res['by'] == 'AI' and len(res['groups']) == 2 and res['hash'] == in_hash(items))
    res = judge_rule('A1', items, '', ask=lambda p: {'ok': False, 'why': '시간 초과'})
    chk('AI 실패 = 단독 묶음 · 사유', res['by'] == '코드(단독)' and len(res['groups']) == 3 and '시간 초과' in res['why'])
    chk('입력 해시: 내용 바뀌면 다름', in_hash(items) != in_hash(items[:2]))
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rule'); ap.add_argument('--force', action='store_true'); ap.add_argument('--dry', action='store_true'); ap.add_argument('--selftest', action='store_true'); ap.add_argument('--par', type=int)
    a = ap.parse_args()
    if a.selftest:
        return selftest()
    rules = {x.strip().upper() for x in a.rule.split(',')} if a.rule else None
    return run(rules=rules, force=a.force, dry=a.dry, par=a.par)


if __name__ == '__main__':
    sys.exit(main())
