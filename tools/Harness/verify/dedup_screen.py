# -*- coding: utf-8 -*-
"""화면 안 중복 정리 — AI 판단 (2026-11-20 사용자 지시 G2)
   "중복되는 작업에 대해서는 중복제거를 진행해서 목록으로 관리하고, CHECKLIST 진행시에도 중복제거된 목록으로 진행 · 중복판단여부는 AI 가 판단"
   "현재의 대조표는 중복이 많은 것으로 판단됩니다"

  python tools/Harness/verify/dedup_screen.py <MENU_ID>            바뀐 규칙만 AI 판단(규칙별 입력 해시) → 목록 갱신 → 원장에 대표 결과 상속 적용
  python tools/Harness/verify/dedup_screen.py <MENU_ID> --apply    AI 판단 없이 지금 목록으로 원장에 상속만 적용(judge.py 끝에서도 부름)
  python tools/Harness/verify/dedup_screen.py <MENU_ID> --dry      대상 규칙·행·호출 수만
  python tools/Harness/verify/dedup_screen.py --selftest

  배경: 한 화면 원장에 같은 확인이 출처를 달리해 여러 행으로 들어간다(SCP0028 A1 37행 = 대조표 추적 21 · 결함 유형 12 · 화면 규칙 3 · 차등 1, 2026-11-20 실측).
  처리: 규칙마다 원장 행(대상 · 조건 · 기대 · 출처)을 Claude(읽기 전용)에 넘겨 '이 화면에서 같은 요소를 같은 기대로 확인하는 행'끼리 묶는다. 확신이 없으면 묶지 않는다.
        대표 행은 코드가 고른다(직접 측정 출처 우선: RULE_SCREEN > COLUMN > SEARCH > SP > ASIS > ASIS_DIFF > MSG > TRACE > CONFIRMED > DEFECT > GENERAL, 같으면 row_id).
  상속: 묶음 구성원 결과가 미측정(ERROR · NOT_RUN · 판정필요 · 빈 값)이고 대표가 PASS · FAIL · NA 이면 대표 결과를 받는다(근거에 '[중복 정리] 대표 <row_id>').
        구성원이 직접 측정한 결과가 대표와 다르면 그대로 두고 문서에 둘 다 남긴다(묶음 판단 오류를 숨기지 않음).
  산출: Doc/verify/<ID>/dedup_screen.csv(목록 정본) · Doc/verify/<ID>/_dedup/rule_<규칙>.json(규칙별 판단 · 입력 해시)
  쓰는 곳: llm_review.py(대표만 AI 판정 검토) · judge.py 끝(상속 재적용) · make_verify_docs.py(CheckList 는 대표 행만, 구성원은 '중복 정리' 시트)
  끄기: harness.json dedupScreen false
"""
import argparse, collections, concurrent.futures, csv, datetime, hashlib, json, os, sys, threading

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 8)
COLS = ['rule_id', 'group_id', 'row_id', 'rep_row_id', 'source', 'target', 'size', 'why', 'judged_by', 'judged_at']
SRC_RANK = {s: i for i, s in enumerate(['RULE_SCREEN', 'COLUMN', 'SEARCH', 'SP', 'ASIS', 'ASIS_DIFF', 'MSG', 'TRACE', 'CONFIRMED', 'DEFECT', 'GENERAL'])}
UNMEASURED = ('ERROR', 'NOT_RUN', '판정필요', '')
MEASURED = ('PASS', 'FAIL', 'NA')
INHERIT = ('PASS', 'FAIL')   # 2026-11-26 개선안 20261126115652_SELF_3(R235): 상속은 대표 PASS·FAIL 만. 대표가 해당없음이면 구성원은 미검증으로 두고 직접 잼


def P(*a):
    return os.path.join(ROOT, *a)


def vdir(mid):
    return P('Doc', 'verify', mid)


def read_csv(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as f:
            return list(csv.DictReader(f))
    except OSError:
        return []


def enabled():
    try:
        return json.load(open(P('tools', 'Harness', 'harness.json'), encoding='utf-8-sig')).get('dedupScreen', True) is not False
    except (OSError, ValueError):
        return True


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def item_of(r):
    return {'row_id': r['row_id'], 'source': r.get('source', ''), 'target': (r.get('target') or '')[:160], 'condition': (r.get('condition') or '')[:200], 'expected': (r.get('expected') or '')[:300]}


def in_hash(items):
    return hashlib.sha1(json.dumps([[x['row_id'], x['source'], x['target'], x['condition'], x['expected']] for x in items], ensure_ascii=False).encode('utf-8')).hexdigest()[:16]


def user_rows(mid):
    return {r.get('row_id', '') for f in ('_user_verdicts.csv', '_user_verdicts_direct.csv') for r in read_csv(P('Doc', 'verify', f)) if (r.get('menu_id') or '').upper() == mid}


def candidates(mid, rows):
    """{rule_id: [항목]} — 사용자 판정 행은 묶지 않으므로 뺀다"""
    keep = user_rows(mid); out = collections.defaultdict(list)
    # 2026-11-20 구간 B: 기준 원장이 정리한 다른 문서 행(결함 유형·확정 요구·이 화면 결함)은 여기서 묻지 않는다
    crit_done = {x['row_id'] for x in read_csv(os.path.join(vdir(mid), 'criteria', 'row_map.csv')) if x.get('source') in ('GENERAL', 'CONFIRMED', 'DEFECT') and x.get('decision')}
    for r in rows:
        if r['row_id'] in keep or not r.get('rule_id') or r['row_id'] in crit_done:
            continue
        out[r['rule_id']].append(item_of(r))
    for k in out:
        out[k].sort(key=lambda x: x['row_id'])
    return out


PROMPT = """너는 화면 {mid} 검증 원장의 중복을 가르는 검토자다. 아래는 검증 규칙 {rid}({rname})의 원장 행 {n}건이다.
행은 출처가 다르다(RULE_SCREEN 화면 규칙, TRACE 대조표 추적, GENERAL 다른 화면 결함 유형, CONFIRMED 확정 규칙, COLUMN 컬럼 메타, DEFECT 이 화면 결함 등).

할 일: 이 화면에서 **같은 화면 요소를 같은 방법으로 확인하고 기대 결과도 같은 행**끼리 묶어라. 묶인 행은 한 번만 측정하고 결과를 나눠 쓴다.
- 같은 묶음: 대상 요소(같은 컬럼, 같은 조회조건, 같은 버튼, 같은 팝업, 같은 조회 결과)가 같고 기대 결과가 같다. 출처와 문장 표현이 달라도 된다.
- 다른 묶음: 요소가 다르다(다른 컬럼, 다른 조건), 상태가 다르다(신규행 vs 기존행, 조회 전 vs 조회 후), 기대가 다르다.
- 대조표 추적(TRACE) 행이 '구현 위치가 소스에 실존' 처럼 다른 성질을 확인하면 묶지 않는다.
- 확신이 없으면 묶지 말고 단독으로 둔다. 잘못 묶으면 검사가 빠지므로 묶지 않는 쪽이 안전하다.
- 모든 row_id 는 정확히 1개 묶음에 들어가야 한다. why 에 묶은 이유를 한 문장으로.

행(JSON 줄):
{items}

답은 JSON 하나만: {{"groups": [{{"rows": ["V-xxxx", "T-yyyy"], "why": "..."}}]}}"""


def rule_names():
    return {r.get('check', ''): (r.get('how') or r.get('checker') or '')[:160] for r in read_csv(os.path.join(HERE, 'mapping_checkdefs.csv'))}


def validate(items, data):
    ids = [x['row_id'] for x in items]; known = set(ids)
    single = [{'rows': [i], 'why': '단독'} for i in ids]
    if not isinstance(data, dict) or not isinstance(data.get('groups'), list):
        return single, '답 형식 오류'
    seen = collections.Counter(); gs = []
    for g in data['groups']:
        rs = [str(x) for x in (g.get('rows') or []) if str(x) in known]
        if rs:
            seen.update(rs); gs.append({'rows': rs, 'why': str(g.get('why') or '')[:300]})
    miss = [i for i in ids if not seen[i]]; dup = [i for i, n in seen.items() if n > 1]
    if miss or dup:
        return single, f'행 빠짐 {len(miss)} · 겹침 {len(dup)}'
    return gs, ''


def pick_rep(members, src_of):
    return sorted(members, key=lambda i: (SRC_RANK.get(src_of.get(i, ''), 99), i))[0]


def judge_rule(mid, rid, items, rname, ask=None, open_n=None):
    if len(items) == 1:
        return {'rule_id': rid, 'hash': in_hash(items), 'groups': [{'rows': [items[0]['row_id']], 'why': '단독'}], 'why': '행 1건', 'by': '코드', 'at': now(), 'cost': 0}
    if open_n == 0:   # 2026-11-20 A4: 이 규칙 행이 모두 측정됨(PASS·FAIL·NA) — 묶어도 결과를 이어받을 행이 없다. AI 호출 없이 단독(측정 안 된 행이 생기면 다시 판단)
        return {'rule_id': rid, 'hash': in_hash(items), 'groups': [{'rows': [x['row_id']], 'why': '단독'} for x in items], 'why': '미측정 행 없음 — 중복 판단 생략', 'by': '코드', 'at': now(), 'cost': 0, 'open': 0}
    lines = '\n'.join(json.dumps(x, ensure_ascii=False) for x in items)
    prompt = PROMPT.format(mid=mid, rid=rid, rname=rname or '', n=len(items), items=lines)
    if ask is None:
        import llm_call
        ask = lambda p: llm_call.ask(mid, 'dedup', p, rows=len(items), use_cache=False)
    r = ask(prompt)
    gs, why = validate(items, r.get('data') if r.get('ok') else None)
    if not r.get('ok'):
        why = f"AI 답 없음({r.get('why', '')}) · 단독"
    return {'rule_id': rid, 'hash': in_hash(items), 'groups': gs, 'why': why, 'by': 'AI' if not why else '코드(단독)', 'at': now(), 'cost': r.get('cost', 0) or 0}


def load_map(mid):
    """{row_id: rep_row_id} — 구성원만(대표 자신은 제외) · 꺼져 있으면 {}"""
    if not enabled():
        return {}
    return {r['row_id']: r['rep_row_id'] for r in read_csv(os.path.join(vdir(mid), 'dedup_screen.csv')) if r.get('rep_row_id') and r['row_id'] != r['rep_row_id']}


def apply(mid, rows):
    """원장 행 목록에 대표 결과 상속(제자리 수정) → (상속 n, 결과 다름 n)"""
    mp = load_map(mid)
    if not mp:
        return 0, 0
    by = {r['row_id']: r for r in rows}; n = diff = 0
    for r in rows:
        rep_id = mp.get(r['row_id']); rep = by.get(rep_id) if rep_id else None
        if not rep:
            continue
        ev = r.get('evidence') or ''
        if ev.startswith('[중복 정리]'):  # 지난 상속은 다시 계산
            r['result'] = 'NOT_RUN'; ev = ''; r['evidence'] = ''
        if (r.get('result') or '') in UNMEASURED and rep.get('result') in INHERIT:
            r['result'] = rep['result']; r['evidence'] = f"[중복 정리] 대표 {rep_id} 결과 상속(AI 판단 Doc/verify/{mid}/dedup_screen.csv): " + (rep.get('evidence') or '')[:800]
            r['tobe_ref'] = f'중복 정리(대표 {rep_id})'; n += 1
        elif r.get('result') in MEASURED and rep.get('result') in MEASURED and r['result'] != rep['result']:
            diff += 1
    return n, diff


def write_ledger_apply(mid):
    p = os.path.join(vdir(mid), 'verify_ledger.csv'); rows = read_csv(p)
    if not rows:
        return 0, 0
    n, diff = apply(mid, rows)
    if n:
        tmp = p + '.tmp'
        with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
        os.replace(tmp, p)
    return n, diff


def run(mid, dry=False, ask=None, par=None):
    rows = read_csv(os.path.join(vdir(mid), 'verify_ledger.csv'))
    if not rows:
        print(f'[ERROR] 원장 없음: Doc/verify/{mid}/verify_ledger.csv'); return 2
    cands = candidates(mid, rows); names = rule_names(); dd = os.path.join(vdir(mid), '_dedup'); results = {}; todo = []
    _res = {r['row_id']: (r.get('result') or '') for r in rows}
    open_n = {rid: sum(1 for x in items if _res.get(x['row_id'], '') in UNMEASURED) for rid, items in cands.items()}
    for rid, items in sorted(cands.items()):
        old = None
        try:
            old = json.load(open(os.path.join(dd, f'rule_{rid}.json'), encoding='utf-8'))
        except (OSError, ValueError):
            pass
        if old and old.get('hash') == in_hash(items) and not (old.get('open') == 0 and open_n.get(rid)):   # 지난번 '미측정 없음'으로 생략한 규칙에 미측정 행이 생기면 다시 판단
            results[rid] = old
        else:
            todo.append(rid)
    nc = sum(1 for r in todo if len(cands[r]) > 1 and open_n.get(r))
    print(f"[중복 정리 {mid}] 원장 {len(rows)}행 · 규칙 {len(cands)}개 · 이번 판단 규칙 {len(todo)}개(AI 호출 {nc}회) · 재사용 {len(results)}개", flush=True)
    if dry:
        return 0
    if par is None:
        try:
            par = int(json.load(open(P('tools', 'Harness', 'harness.json'), encoding='utf-8-sig')).get('llmReviewPar') or 4)
        except (OSError, ValueError):
            par = 4
    lock = threading.Lock(); done = [0]; os.makedirs(dd, exist_ok=True)

    def one(rid):
        res = judge_rule(mid, rid, cands[rid], names.get(rid, ''), ask, open_n=open_n.get(rid, 0))
        with open(os.path.join(dd, f'rule_{rid}.json'), 'w', encoding='utf-8') as f:
            json.dump(res, f, ensure_ascii=False, indent=1)
        with lock:
            done[0] += 1
            if len(cands[rid]) > 1:
                print(f"  · 중복 판단 {done[0]}/{len(todo)} {rid} 행 {len(cands[rid])} → 묶음 {len(res['groups'])}{(' · ' + res['why']) if res['why'] else ''}", flush=True)
        return rid, res
    with concurrent.futures.ThreadPoolExecutor(max_workers=max(1, par)) as ex:
        for rid, res in ex.map(one, todo):
            results[rid] = res
    src_of = {r['row_id']: r.get('source', '') for r in rows}; tgt_of = {r['row_id']: (r.get('target') or '')[:120] for r in rows}; out = []
    for rid in sorted(results):
        res = results[rid]
        for gi, g in enumerate(res['groups'], 1):
            rep = pick_rep(g['rows'], src_of)
            for i in g['rows']:
                out.append({'rule_id': rid, 'group_id': f'{rid}-G{gi:03d}', 'row_id': i, 'rep_row_id': rep, 'source': src_of.get(i, ''), 'target': tgt_of.get(i, ''),
                            'size': len(g['rows']), 'why': g.get('why', ''), 'judged_by': res['by'], 'judged_at': res['at']})
    p = os.path.join(vdir(mid), 'dedup_screen.csv'); tmp = p + '.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(out)
    os.replace(tmp, p)
    members = sum(1 for x in out if x['row_id'] != x['rep_row_id']); groups = len({x['group_id'] for x in out if int(x['size']) > 1})
    n, diff = write_ledger_apply(mid)
    cost = sum((results[r].get('cost') or 0) for r in todo if r in results)
    print(f"[중복 정리 {mid}] 원장 {len(rows)}행 중 중복 {members}행(묶음 {groups}개) → 대표 {len(rows) - members}행 · 대표 결과 상속 {n}행 · 결과 다름 {diff}행 · 이번 비용 {cost:.2f} USD → Doc/verify/{mid}/dedup_screen.csv", flush=True)
    return 0


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    items = [{'row_id': i, 'source': s, 'target': t, 'condition': '', 'expected': ''} for i, s, t in (('T-1', 'TRACE', '조회 건수'), ('V-2', 'GENERAL', '조회 결과 건수'), ('V-3', 'RULE_SCREEN', '조회 건수'), ('V-4', 'COLUMN', 'LOT_SIZE 편집'))]
    g, why = validate(items, {'groups': [{'rows': ['T-1', 'V-2', 'V-3']}, {'rows': ['V-4']}]}); chk('정상 답 = 묶음 2', not why and len(g) == 2)
    g, why = validate(items, {'groups': [{'rows': ['T-1', 'V-2']}]}); chk('빠짐 = 전부 단독', why.startswith('행 빠짐 2') and len(g) == 4)
    chk('대표 = 화면 규칙 출처 우선', pick_rep(['T-1', 'V-2', 'V-3'], {'T-1': 'TRACE', 'V-2': 'GENERAL', 'V-3': 'RULE_SCREEN'}) == 'V-3')
    import tempfile, shutil
    global vdir
    d = tempfile.mkdtemp(); old_v = vdir; vdir = lambda mid: d
    try:
        with open(os.path.join(d, 'dedup_screen.csv'), 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=COLS); w.writeheader()
            for i in ('T-1', 'V-2', 'V-3', 'V-5'):
                w.writerow({'rule_id': 'A1', 'group_id': 'A1-G001', 'row_id': i, 'rep_row_id': 'V-3', 'size': 4})
        rows = [{'row_id': 'V-3', 'result': 'PASS', 'evidence': '실측 7831건 일치'}, {'row_id': 'T-1', 'result': 'ERROR', 'evidence': '측정 못 함'}, {'row_id': 'V-2', 'result': 'FAIL', 'evidence': '직접 측정 FAIL'},
                {'row_id': 'V-5', 'result': '[x]', 'evidence': ''}, {'row_id': 'V-9', 'result': 'ERROR', 'evidence': ''}]
        rows[3]['result'] = 'NOT_RUN'
        n, diff = apply('X', rows)
        chk('미측정 구성원 = 대표 결과 상속 2행 · 직접 측정이 다른 행 = 그대로(결과 다름 1)', n == 2 and diff == 1 and rows[1]['result'] == 'PASS' and rows[1]['evidence'].startswith('[중복 정리] 대표 V-3') and rows[2]['result'] == 'FAIL' and rows[4]['result'] == 'ERROR')
        rows[0]['result'] = 'ERROR'; n, diff = apply('X', rows)
        chk('대표가 미측정으로 바뀌면 지난 상속을 지움', rows[1]['result'] == 'NOT_RUN' and n == 0)
        rows[0]['result'] = 'NA'; n, diff = apply('X', rows)
        chk('대표가 해당없음이면 상속 없음(구성원 미검증 유지)', rows[1]['result'] == 'NOT_RUN' and n == 0)
    finally:
        vdir = old_v; shutil.rmtree(d, ignore_errors=True)
    res = judge_rule('X', 'A1', items, '', ask=lambda p: {'ok': True, 'data': {'groups': [{'rows': ['T-1', 'V-2', 'V-3']}, {'rows': ['V-4']}]}})
    chk('규칙 판단(가짜 AI) = AI · 묶음 2', res['by'] == 'AI' and len(res['groups']) == 2)
    called = []
    res = judge_rule('X', 'A1', items, '', ask=lambda p: called.append(1) or {'ok': True, 'data': {}}, open_n=0)
    chk('미측정 행 없는 규칙 = AI 호출 없음 · 전부 단독', not called and res['by'] == '코드' and len(res['groups']) == 4)
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id', nargs='?'); ap.add_argument('--apply', action='store_true'); ap.add_argument('--dry', action='store_true'); ap.add_argument('--selftest', action='store_true'); ap.add_argument('--par', type=int)
    a = ap.parse_args()
    if a.selftest:
        return selftest()
    if not a.menu_id:
        print(__doc__); return 2
    mid = a.menu_id.upper()
    if not enabled():
        print(f'[SKIP] harness.json dedupScreen false — 화면 안 중복 정리 꺼짐'); return 0
    if a.apply:
        n, diff = write_ledger_apply(mid); print(f'[중복 정리 {mid}] 대표 결과 상속 {n}행 · 결과 다름 {diff}행'); return 0
    return run(mid, dry=a.dry)


if __name__ == '__main__':
    sys.exit(main())
