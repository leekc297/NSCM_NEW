# -*- coding: utf-8 -*-
"""CheckList 미검증 자동 해소 1단계: 분류 + 자동 재측정 (2026-11-18 사용자 지시)
   "CHECKLIST 생성 시 미검증 항목이 발생하면 미검증을 해소하도록 하는 기능을 CHECKLIST 에 추가"
   "미검증 건수를 확인하고 미검증해소를 요청하지 않더라도 미검증에 대해서 검증을 진행할 수 있도록 검사엔진을 생성하거나 보완하는 절차"

  python tools/Harness/verify/unverified_resolve.py <MENU_ID> [--no-rerun] [--round N]

  화면 독립. 대상 = 원장(Doc/verify/<ID>/verify_ledger.csv) result=ERROR(미검증) 행 전부.
  1) 분류: 증거 문구를 tools/Harness/verify/unverified_classes.csv 의 정규식으로 유형·담당을 정한다(순서대로 첫 일치).
     담당 = 집계(하위 행을 따라감) · 자동(이 도구가 다시 측정) · 엔진(검사기 신설·보완) · 대조표(근거 보강) · 판단(룰 원장·원문 확인) · 사람(승인·계정)
     어느 정규식에도 안 맞으면 '미분류'(담당 엔진). 미분류는 분류표에 정규식을 더하는 일도 같이 남긴다.
  2) 자동 재측정: 담당 '자동' 행의 규칙을 run_verify.py <ID> --only <규칙> 으로 한 번 다시 잰다(같은 원장 판에서 같은 규칙은 다시 돌리지 않음).
     E2E 4종 결과가 없던 행([미측정])은 e2e_suite.py --kinds <종류> 를 먼저 돌린다.
  3) 다시 분류해서 결과를 쓴다.
       Doc/verify/<ID>/unverified_triage.csv   행별 유형·담당·처리 방법·증거
       Doc/verify/<ID>/unverified_triage.md    유형 → 규칙 묶음(같은 원인 묶음), 엔진 보완 세션이 읽는 작업 목록
       Doc/verify/<ID>/unverified_triage.json  전후 건수 · 담당별 남은 수(actionable = 엔진+대조표+판단+미분류+자동 남음) · 사람 확인 수
       Doc/verify/<ID>/unverified_history.csv  실행마다 1줄(라운드·전후 건수)
  VM 체인: 🔎 CheckList → 이 도구(검증 unverifiedOpen) → actionable 이 남으면 🧪 미검증 해소(Claude · 검사엔진 보완) → 이 도구 재실행(최대 2회)
  이 도구는 판정을 바꾸지 않는다. ERROR 를 NA·PASS 로 고치지 않고, 측정을 다시 하거나 남은 일을 목록으로 만든다.
  종료코드 0 = 분류·기록 완료(미검증이 남아도 0, 남은 수는 json), 3 = 원장 없음
"""
import argparse, collections, csv, datetime, json, os, re, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
CLASSES_CSV = os.path.join(HERE, 'unverified_classes.csv')
WORK_ACTORS = ('엔진', '대조표', '판단')  # Claude 세션이 처리하는 담당(미분류는 엔진)
ES_KIND = re.compile(r'E2E (crud|auth|authcrud|smoke)\b')


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def load_classes(path=CLASSES_CSV):
    out = []
    with open(path, encoding='utf-8') as fh:
        for r in csv.DictReader(fh):
            out.append(dict(r, rx=re.compile(r['pattern']), order=int(r['order'])))
    return sorted(out, key=lambda r: r['order'])


def classify(ev, classes):
    for c in classes:
        if c['rx'].search(ev or ''):
            return c['class'], c['actor'], c['remedy']
    return '미분류', '엔진', '분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완'


def read_ledger(mid):
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv')
    if not os.path.exists(p):
        return None, p
    with open(p, encoding='utf-8-sig', newline='') as fh:
        return list(csv.DictReader(fh)), p


def triage(rows, classes):
    out = []
    for r in rows:
        if (r.get('result') or '') != 'ERROR':
            continue
        ev = r.get('evidence') or ''
        cls, actor, remedy = classify(ev, classes)
        out.append({'row_id': r.get('row_id', ''), 'source': r.get('source', ''), 'rule_id': r.get('rule_id', ''), 'target': r.get('target', ''),
                    'class': cls, 'actor': actor, 'remedy': remedy, 'evidence': re.sub(r'\s+', ' ', ev)[:400]})
    return out


def progress(prev_ids, cur_ids, prev_n, cur_n, ledger_changed):
    """반복 중단 판정 → (stalled, 풀린 행, 새 행). 원장이 바뀌지 않았으면 판정하지 않음(False). 직전 행 ID 가 없으면 건수 비교(종전)"""
    if not ledger_changed or not cur_n:
        return False, set(), set()
    if prev_ids is None:
        return (prev_n is not None and cur_n >= prev_n), set(), set()
    res, new = prev_ids - cur_ids, cur_ids - prev_ids
    return (not res), res, new


AI_ENGINE = {'검사기오판': 'AI검토:검사기오판', '추출오류': 'AI검토:추출오류', 'TOBE룰': 'AI검토:룰등록'}


def ai_review_rows(mid, tri):
    """2026-11-19 AI 판정 검토(llm_review.csv) 가 인용 확인과 함께 '검사엔진 오판·AS-IS 사실 추출 오류·미등록 TO-BE 룰'로 가린 행 → 엔진 보완 대상.
    미검증(ERROR) 행이 아니어도(FAIL·판정필요) 처리 대상에 넣는다 — 사용자가 사용자의견으로 하던 일(오판 지적 → 엔진 수정 → 룰 등록)을 체인 2단계가 잇는다.
    이미 미검증 목록에 있는 행은 처리 방법만 덧붙인다. 반환 = 새로 더한 행 수"""
    try:
        with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'llm_review.csv'), encoding='utf-8-sig', newline='') as fh:
            rv = list(csv.DictReader(fh))
    except OSError:
        return 0
    have = {t['row_id']: t for t in tri}
    n = 0
    for x in rv:
        c = x.get('class') or ''
        if c not in AI_ENGINE or x.get('verified') != 'Y' or (c == 'TOBE룰' and x.get('rule_ok') == 'Y' and x.get('apply') == 'Y'):
            continue   # 등록된 룰로 이미 반영된 행은 엔진이 그 룰을 읽게 하는 일만 남는다 → 아래에서 다루지 않음(룰 원장 NO_ENFORCER 점검 대상)
        hint = ('AI 판정 검토: ' + c + ' — ' + (x.get('fix_hint') or '').strip() + ' / ' + (x.get('reason') or '').strip() + ' / 근거 ' + (x.get('evidence_ref') or '').strip())[:600]
        if x['row_id'] in have:
            t = have[x['row_id']]
            if t['actor'] in ('집계', '사람', '보완'):
                continue
            t['remedy'] = (t['remedy'] + ' · ' + hint)[:900]
            continue
        tri.append({'row_id': x['row_id'], 'source': x.get('source', ''), 'rule_id': x.get('rule_id', ''), 'target': x.get('target', ''), 'class': AI_ENGINE[c], 'actor': '엔진',
                    'remedy': hint + ' → 원인(파일:줄) 확인 · 검사기 수정 · 결함 유형(T번호) 기록 · 전 화면 공통이면 룰 등록(confirmed_requirements.csv → tobe_rule_registry.py --build/--check)',
                    'evidence': re.sub(r'\s+', ' ', f"[{x.get('cur_result', '')}] {x.get('reason', '')}")[:400], '_ai': True})
        n += 1
    have = {t['row_id']: t for t in tri}
    # 사용자의견 처리(opinion_intake.csv) 중 열린 것 = 사용자가 오류 아님·TO-BE RULE 로 적었는데 검사엔진 판정이 아직 그대로인 행
    for x in _read(os.path.join(ROOT, 'Doc', 'verify', mid, 'opinion_intake.csv')):
        if x.get('status') != 'open' or x.get('class') not in ('엔진오판', '룰등록'):
            continue
        hint = (f"사용자의견 처리: {x['class']} — 의견 '{(x.get('opinion') or '')[:120]}' / " + (x.get('action') or '').strip() + (f" / 일반 규칙 초안: {x['rule_draft'].strip()}" if (x.get('rule_draft') or '').strip() else '')
                + (f" / 근거 {x['evidence_ref'].strip()}" if (x.get('evidence_ref') or '').strip() else ''))[:700]
        if x['row_id'] in have:
            t = have[x['row_id']]
            if hint[:40] not in t['remedy']:
                t['remedy'] = (t['remedy'] + ' · ' + hint)[:1200]
            continue
        t = {'row_id': x['row_id'], 'source': '', 'rule_id': '', 'target': '', 'class': 'AI검토:의견-' + x['class'], 'actor': '엔진',
             'remedy': hint + ' → 행을 사용자판정으로 덮는 데서 끝내지 않고 검사엔진 원인 수정 · 전 화면 공통이면 룰 등록(confirmed_requirements.csv → tobe_rule_registry.py --build/--check) · 결함 유형(T번호) 기록',
             'evidence': re.sub(r'\s+', ' ', x.get('opinion') or '')[:400], '_ai': True}
        tri.append(t); have[t['row_id']] = t; n += 1
    # AS-IS 사실 추출 검토(llm_facts.csv) 중 원문 인용이 확인된 후보 = 추출기 보완 대상(행 ID FACT-…)
    for x in _read(os.path.join(ROOT, 'Doc', 'verify', mid, 'llm_facts.csv')):
        if x.get('verified') != 'Y' or not (x.get('fact_id') or '').strip():
            continue
        tri.append({'row_id': x['fact_id'], 'source': 'FACT', 'rule_id': '', 'target': f"{x.get('fact_file', '')} {x.get('key', '')}", 'class': 'AI검토:추출오류', 'actor': '엔진',
                    'remedy': (f"AS-IS 사실 추출 {x.get('kind', '')}: {x.get('detail', '')} / 추출기 원인 {x.get('fix_hint', '')} / 근거 {x.get('evidence_ref', '')}")[:700]
                    + ' → 추출기(tools/Harness/verify/facts_*.py · tools/AsisFacts) 보완 · 사실 파일을 손으로 고치지 않음 · 영향 검사: ' + (x.get('affects') or '미기재'),
                    'evidence': re.sub(r'\s+', ' ', x.get('detail') or '')[:400], '_ai': True})
        n += 1
    return n


def _read(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as fh:
            return list(csv.DictReader(fh))
    except OSError:
        return []


def counts(tri):
    unv = [t for t in tri if not t.get('_ai')]   # 미검증(ERROR) 행 — 건수 표시는 이것만
    ai = len(tri) - len(unv)
    by_actor = collections.Counter(t['actor'] for t in unv)
    by_class = collections.Counter(t['class'] for t in unv)
    actionable = sum(by_actor[a] for a in WORK_ACTORS) + by_actor['자동'] + ai
    return {'total': len(unv), 'by_actor': dict(by_actor), 'by_class': dict(by_class), 'actionable': actionable, 'ai_review': ai,
            'human': by_actor['사람'], 'aggregate': by_actor['집계'], 'blocked': by_actor['보완'], 'guide': by_actor['가이드']}  # 보완 = 선행 FAIL(화면 기능 누락) 뒤에만 잴 수 있는 행


def run(cmd, cwd=None):
    print('$ ' + ' '.join(str(c) for c in cmd), flush=True)
    return subprocess.call(cmd, cwd=cwd or ROOT)


def rerun(mid, tri, state):
    """담당 '자동' 행 재측정. 반환 = {'rules': [...], 'rc': n, 'e2e_kinds': [...]} 또는 None(할 것 없음)"""
    auto = [t for t in tri if t['actor'] == '자동']
    if not auto:
        return None
    done = set(state.get('rerun_rules') or []); done_k = set(state.get('rerun_kinds') or [])
    rules = sorted({t['rule_id'].upper() for t in auto if t['rule_id']} - done)
    kinds = sorted({m.group(1) for t in auto if t['row_id'].startswith('ES-') for m in [ES_KIND.search(t['target'] + ' ' + t['evidence'])] if m and m.group(1) != 'smoke'} - done_k)
    if not rules and not kinds:
        print(f'[INFO] 자동 재측정 대상 {len(auto)}행. 같은 원장 판에서 이미 다시 잰 규칙({",".join(sorted(done))})이라 건너뜀. 엔진 보완 대상으로 넘김', flush=True)
        for t in auto:
            t['actor'] = '엔진'; t['remedy'] = '같은 조건 재측정으로 풀리지 않음. 실패 원인(로그)을 찾아 검사기 보완'
        return None
    res = {'rules': rules, 'e2e_kinds': kinds, 'rc': None}
    py = sys.executable
    if kinds:
        res['e2e_rc'] = run([py, os.path.join(HERE, 'e2e_suite.py'), mid, '--kinds', ','.join(kinds), '--force'])
    if rules:
        rc = run([py, os.path.join(HERE, 'run_verify.py'), mid, '--only', ','.join(rules)])
        res['rc'] = rc
        if rc == 4:
            print(f'[ERROR] 같은 화면({mid}) CheckList 실행 중이라 재측정 못 함(미검증 유지)', flush=True)
        elif rc == 5:
            print('[ERROR] FE/BE 미기동이라 재측정 못 함(미검증 유지)', flush=True)
        elif rc == 3:
            print(f'[INFO] --only {",".join(rules)} 재측정 불가(rc 3: 이 규칙을 판정하는 @verify/@trace 테스트 없음 등) → 엔진 보완 대상으로 넘김', flush=True)
        elif rc not in (0, 10):
            print(f'[ERROR] 재측정 실행 rc={rc}', flush=True)
    state['rerun_rules'] = sorted(done | set(rules)); state['rerun_kinds'] = sorted(done_k | set(kinds))
    return res


def group_md(mid, tri, before, after, rr, rnd):
    L = [f'# {mid} 미검증 분류 · {now()} · 라운드 {rnd}', '',
         f'- 원장 미검증(ERROR) {before["total"]} → {after["total"]}행. 처리 대상(엔진·대조표·판단·미분류·자동 남음) {after["actionable"]} · 사람 확인 {after["human"]} · 집계 {after["aggregate"]}',
         '- 집계 행 = 하위 행 판정을 따라감. 하위 행이 풀리면 같이 풀림(따로 고치지 않음).',
         '- 자동 재측정: ' + (('규칙 ' + ','.join(rr['rules']) + ' rc=' + str(rr.get('rc'))) if rr and rr.get('rules') else '없음')
         + (f' · E2E {",".join(rr["e2e_kinds"])} rc={rr.get("e2e_rc")}' if rr and rr.get('e2e_kinds') else ''), '',
         '| 담당 | 유형 | 행 |', '|---|---|---|']
    cc = collections.Counter((t['actor'], t['class']) for t in tri)
    for (a, c), n in sorted(cc.items(), key=lambda x: (-x[1], x[0])):
        L.append(f'| {a} | {c} | {n} |')
    L.append('')
    order = ['엔진', '대조표', '판단', '자동', '가이드', '보완', '사람', '집계']
    for a in order:
        ts = [t for t in tri if t['actor'] == a]
        if not ts:
            continue
        L += [f'## 담당 {a} ({len(ts)}행)', '']
        g = collections.OrderedDict()
        for t in sorted(ts, key=lambda t: (t['class'], t['rule_id'], t['row_id'])):
            g.setdefault((t['class'], t['rule_id']), []).append(t)
        for (c, rid), xs in g.items():
            L.append(f'### {c} · 규칙 {rid or "-"} · {len(xs)}행')
            L.append(f'- 처리: {xs[0]["remedy"]}')
            lim = 3 if a == '집계' else 12
            for t in xs[:lim]:
                L.append(f'- {t["row_id"]} [{t["source"]}] {t["target"][:80]} | {t["evidence"][:220]}')
            if len(xs) > lim:
                L.append(f'- 외 {len(xs) - lim}행(unverified_triage.csv)')
            L.append('')
    return '\n'.join(L) + '\n'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--no-rerun', action='store_true', help='분류만 하고 자동 재측정은 하지 않음')
    ap.add_argument('--round', type=int, default=0, help='VM 체인 라운드 표시용(0 = 첫 실행)')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    rows, lp = read_ledger(mid)
    if rows is None:
        print(f'[ERROR] 원장 없음: {os.path.relpath(lp, ROOT)}. 🔎 CheckList 먼저 실행', flush=True)
        return 3
    classes = load_classes()
    st_p = os.path.join(vd, 'unverified_state.json')
    try:
        state = json.load(open(st_p, encoding='utf-8'))
    except Exception:
        state = {}
    lm = os.path.getmtime(lp)
    # 원장이 CheckList 전체 실행으로 새로 만들어졌으면(run_mode full) 재측정 기록을 비운다. --only 재판정으로 바뀐 원장은 같은 판으로 본다
    try:
        rm = json.load(open(os.path.join(vd, 'run_mode.json'), encoding='utf-8'))
    except Exception:
        rm = {}
    if rm.get('mode') != 'only' and state.get('ledger_mode_at') != rm.get('at'):
        state = {'ledger_mode_at': rm.get('at'), 'rerun_rules': [], 'round': 0}
    rnd = a.round or (int(state.get('round') or 0) + 1)
    print(f'== 미검증 해소 1단계(분류·자동 재측정) {mid} · 라운드 {rnd} · {now()} ==', flush=True)
    # 2026-11-19 사용자: 미검증 해소 보완 뒤 CheckList 재수행 전이면 보완 전 원장 건수를 출력·문서에 보여 주지 않는다(json 값은 VM 체인 판단용으로 유지)
    try:
        import pending_recheck as _PR
        prc = _PR.pending(mid)
    except Exception:
        prc = None
    if prc:
        print(f'[INFO] {prc["note"]} · 원장 {prc["ledger_at"]}', flush=True)
    tri0 = triage(rows, classes); before = counts(tri0)
    print('[세부 1/3] 분류: ' + ('보완 전 원장이라 건수 표시 생략(행 목록 unverified_triage.csv)' if prc else f'미검증 {before["total"]}행 · 담당 ' + ' · '.join(f'{k} {v}' for k, v in sorted(before['by_actor'].items(), key=lambda x: -x[1]))), flush=True)
    rr = None
    if not a.no_rerun and before['total']:
        print('[세부 2/3] 자동 재측정', flush=True)
        rr = rerun(mid, tri0, state)
        if rr:
            rows, lp = read_ledger(mid)
    else:
        print('[세부 2/3] 자동 재측정 건너뜀(' + ('--no-rerun' if a.no_rerun else '미검증 0') + ')', flush=True)
    tri = triage(rows, classes)
    if rr is None:  # 재측정을 안 했거나 이미 한 규칙이면 1차 분류의 담당 변경(자동 → 엔진)을 유지
        moved = {t['row_id'] for t in tri0 if t['actor'] == '엔진' and t['class'] == '재실행'}
        for t in tri:
            if t['row_id'] in moved:
                t['actor'] = '엔진'; t['remedy'] = '같은 조건 재측정으로 풀리지 않음. 실패 원인(로그)을 찾아 검사기 보완'
    elif rr.get('rc') == 3:
        for t in tri:
            if t['actor'] == '자동' and t['rule_id'].upper() in rr['rules']:
                t['actor'] = '엔진'; t['remedy'] = '--only 로 다시 잴 시험이 없음. 이 규칙을 판정하는 검사기 경로 보완'
    # 2026-11-18 사용자(SCP0096 34건 남음): 체인은 --no-rerun 이라 '재실행' 행을 아무도 다시 재지 않았고 🧪 목록에서도 빠졌다.
    #   직전 분류가 다른(앞선) 원장에서 나왔고 그때도 같은 행이 재실행이었으면 = 전체 재측정에서도 같은 실패 → 엔진(검사기 보완) 대상으로 넘긴다.
    lmt = round(lm, 3)
    try:
        prev_meta = json.load(open(os.path.join(vd, 'unverified_triage.json'), encoding='utf-8'))
    except Exception:
        prev_meta = {}
    prev_cls = {}; prev_act_ids = None
    if prev_meta.get('ledger_mtime') not in (None, lmt):
        try:
            with open(os.path.join(vd, 'unverified_triage.csv'), encoding='utf-8-sig') as fh:
                _prev = list(csv.DictReader(fh))
            prev_cls = {r['row_id']: r.get('class', '') for r in _prev}
            prev_act_ids = {r['row_id'] for r in _prev if r.get('actor') in WORK_ACTORS + ('자동',)}
        except Exception:
            prev_cls = {}
    for t in tri:
        if t['actor'] == '자동' and t['class'] == '재실행' and prev_cls.get(t['row_id']) == '재실행':
            t['actor'] = '엔진'; t['remedy'] = f"전체 재측정({prev_meta.get('at', '')} 분류 이후)에도 같은 실패. 실패 원인(로그)을 찾아 검사기 보완"
    # 2026-11-19 사용자(SCP0096 '재수행 2단계에서 종료'): DB MODE(repairScope DB_ONLY)에서는 대조표(FE 폴더 __asis-mapping__.md)를 고칠 수 없어
    #   대조표 담당 행은 재수행해도 줄지 않는데 처리 대상에 남아 반복 중단 조건을 만들었다 → 담당 '가이드'(FE 가이드로 남김 · 결정 목록)로 옮겨 처리 대상에서 뺀다
    try:
        _scope = json.load(open(os.path.join(ROOT, 'tools', 'Harness', 'harness.json'), encoding='utf-8-sig')).get('repairScope', '')
    except Exception:
        _scope = ''
    if _scope == 'DB_ONLY':
        for t in tri:
            if t['actor'] == '대조표':
                t['actor'] = '가이드'; t['remedy'] = 'DB MODE(repairScope DB_ONLY): 대조표(FE 폴더) 수정 불가, FE 가이드(FE_GUIDE_*.md)로 남기고 결정 목록에 적음 · 재수행으로 줄지 않아 처리 대상에서 뺌'
    ai_n = ai_review_rows(mid, tri)
    after = counts(tri)
    print('[세부 3/3] 기록: ' + ('보완 전 원장이라 건수 표시 생략, 건수는 CheckList 재수행 뒤 표시' if prc else f'미검증 {before["total"]} → {after["total"]}행, 처리 대상 {after["actionable"]}(AI 판정 검토가 가린 엔진 보완 대상 {ai_n} 포함), 사람 확인 {after["human"]}, 집계 {after["aggregate"]}'), flush=True)
    os.makedirs(vd, exist_ok=True)
    with open(os.path.join(vd, 'unverified_triage.csv'), 'w', encoding='utf-8-sig', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=['row_id', 'source', 'rule_id', 'target', 'class', 'actor', 'remedy', 'evidence'], extrasaction='ignore')
        w.writeheader(); w.writerows(tri)
    md = group_md(mid, tri, before, after, rr, rnd) if not prc else (
        f'# {mid} 미검증 분류 · {now()} · 라운드 {rnd}\n\n- {prc["note"]}\n- 원장 {prc["ledger_at"]} 은 보완 전 판이라 건수를 싣지 않음. CheckList 재수행 뒤 다시 만듦\n'
        f'- 행 목록(작업용): unverified_triage.csv · 보완 기록: _unverified_work.md · 결정 목록: _unverified_decisions.md\n')
    open(os.path.join(vd, 'unverified_triage.md'), 'w', encoding='utf-8').write(md)
    sheet = None
    try:
        sheet = json.load(open(os.path.join(vd, 'checklist_counts.json'), encoding='utf-8')).get('unverified_sheet')
    except Exception:
        pass
    # 2026-11-18: 체인 반복 조건. 처리 대상이 남았고 직전 기록보다 줄었으면(첫 기록이면) continue=1 → 🧪 보완·재수행을 한 번 더.
    #   줄지 않았으면 stalled = 같은 보완으로 더 줄지 않음 → 반복을 멈추고 결정 목록으로 보고
    prev_act = None
    try:
        with open(os.path.join(vd, 'unverified_history.csv'), encoding='utf-8-sig') as fh:
            hist = list(csv.DictReader(fh))
        if hist:
            prev_act = int(hist[-1].get('actionable') or 0)
    except Exception:
        prev_act = None
    cur_act_ids = {t['row_id'] for t in tri if t['actor'] in WORK_ACTORS + ('자동',)}
    # 2026-11-19 사용자(SCP0096 재수행 2 중단: 처리 대상 3 → 4 = F6 1행 해소 + 부분 실행이 만든 새 미검증 2행): 건수 비교는 해소된 행과 새로 생긴 행을 구분하지 못했다.
    #   직전 처리 대상 행 ID 가 있으면 행 단위로 본다 — 직전 처리 대상 중 하나라도 풀렸으면 진전(계속), 하나도 안 풀렸으면 중단. 새로 생긴 행은 다음 보완 대상으로 넘긴다
    stalled, resolved_ids, new_ids = progress(prev_act_ids, cur_act_ids, prev_act, after['actionable'], prev_meta.get('ledger_mtime') not in (None, lmt))
    cont = 1 if after['actionable'] and not stalled else 0
    out = {'menu_id': mid, 'at': now(), 'round': rnd, 'ledger': os.path.relpath(lp, ROOT), 'before': before, 'after': after,
           'actionable': after['actionable'], 'human': after['human'], 'rerun': rr, 'unverified_sheet': sheet,
           'ledger_mtime': lmt, 'prev_actionable': prev_act, 'continue': cont, 'stalled': stalled,
           'resolved_actionable': sorted(resolved_ids), 'new_actionable': sorted(new_ids), 'pending_recheck': prc,
           'note': '미검증 시트(원장 NA 중 직접 실측 없음)는 참고 수치. 처리 대상은 원장 ERROR 행'}
    json.dump(out, open(os.path.join(vd, 'unverified_triage.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    hp = os.path.join(vd, 'unverified_history.csv'); new = not os.path.exists(hp)
    with open(hp, 'a', encoding='utf-8-sig', newline='') as fh:
        w = csv.writer(fh)
        if new:
            w.writerow(['at', 'round', 'before', 'after', 'actionable', 'human', 'aggregate', 'rerun_rules', 'rerun_rc'])
        w.writerow([out['at'], rnd, before['total'], after['total'], after['actionable'], after['human'], after['aggregate'],
                    ','.join((rr or {}).get('rules') or []), (rr or {}).get('rc')])
    state['round'] = rnd
    json.dump(state, open(st_p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f'@@LINK 📋 미검증 분류|{os.path.join(vd, "unverified_triage.md")}', flush=True)
    if prc:
        print('[INFO] 보완 뒤 CheckList 재수행 전. 남은 건수는 CheckList 재수행 뒤 표시', flush=True)
        return 0
    if stalled:
        print(f'[WARN] 처리 대상 {after["actionable"]}행 · 직전 처리 대상 {prev_act}행 중 풀린 행 0 — 반복 중단, 남은 행은 원인·결정 목록으로 보고', flush=True)
    elif resolved_ids or new_ids:
        print(f'[INFO] 직전 처리 대상 중 풀린 행 {len(resolved_ids)} · 새로 생긴 처리 대상 {len(new_ids)}({", ".join(sorted(new_ids)[:5])}) — 다음 보완 대상', flush=True)
    if after['actionable']:
        print(f'[ERROR] 미검증 처리 대상 {after["actionable"]}행 남음. 검사엔진 보완(🧪 미검증 해소) 필요, 사람 확인 {after["human"]}행은 결정 목록', flush=True)
    elif after['total']:
        print(f'[OK] 처리 대상 0 · 남은 미검증 {after["total"]}행 = 사람 확인 {after["human"]} · 집계 {after["aggregate"]}', flush=True)
    else:
        print('[OK] 미검증 0', flush=True)
    return 0


def selftest():
    cl = load_classes()
    cases = [('규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-1]', '집계'),
             ('행 집계 — 대조표 D00-1-010 의 G1 7요소: ERROR:2', '집계'),
             ('진입점 집계 7검사 — ERROR:6 · PASS:1', '집계'),
             ('[측정 경로 없음] W_ 동적 칸 없음', '엔진'),
             ('조회 결과 2행 — 다중 선택 시험에 3행 이상 필요(조회조건 바꿔 재실행)', '엔진'),
             ('[KEYSET] [차등 검증 #1] sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음', '엔진'),
             ('[재실측 스냅샷 헤더] 골든 없음(승인 전)', '사람'),
             ('기대 TITLESET_USER 보유·미보유 계정쌍 · 실제 명부에 쌍 없음', '사람'),
             ('[다국어 확인 필요] 같은 문구 다른 코드', '판단'),
             ('제외·해당없음 사유·근거(룰·지시·AS-IS 원문·이동 위치)가 서술에 없음 — 사람 확인', '대조표'),
             ('[미측정] E2E crud 결과 기록 없음', '자동'),
             ('Navigation timeout of 30000 ms exceeded', '자동'),
             ('알 수 없는 새 사유', '엔진')]
    bad = []
    for ev, want in cases:
        got = classify(ev, cl)[1]
        if got != want:
            bad.append(f'{ev[:40]} → {got}(기대 {want})')
    # 2026-11-19 반복 중단 판정(행 단위)
    for name, got, want in [('1행 풀림 + 새 2행 = 계속', progress({'A', 'B', 'C'}, {'B', 'C', 'D', 'E'}, 3, 4, True)[0], False),
                            ('풀린 행 0 = 중단', progress({'A', 'B'}, {'A', 'B', 'D'}, 2, 3, True)[0], True),
                            ('원장 그대로 = 판정 안 함', progress({'A'}, {'A'}, 1, 1, False)[0], False),
                            ('직전 ID 없음 · 건수 같음 = 중단', progress(None, {'A'}, 1, 1, True)[0], True),
                            ('처리 대상 0 = 중단 아님', progress({'A'}, set(), 1, 0, True)[0], False)]:
        if got != want:
            bad.append(f'{name} → {got}(기대 {want})')
    return bad


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        b = selftest(); print('selftest', 'OK' if not b else 'FAIL', *b, sep='\n'); sys.exit(1 if b else 0)
    sys.exit(main())
