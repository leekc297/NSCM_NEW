# -*- coding: utf-8 -*-
"""수정분 재점검 범위 결정 — 코드 규칙 + AI 판단 (2026-11-20 사용자 지시)
   "수정분 재점검의 경우에는 이전 수행과 달라진 소스의 범위안에서만 테스트를 진행하고 수정"
   상시 기준: 정합성이 같은 방법만 · 판단이 필요한 곳은 AI · 근거 없는 제외는 받지 않는다(모르면 재측정)

  python tools/Harness/verify/delta_scope.py <ID>            범위 결정 → Doc/verify/<ID>/delta_scope.json · 표준 출력 마지막 줄 JSON
  python tools/Harness/verify/delta_scope.py <ID> --dry      AI 호출 없이 코드 규칙 범위와 AI 에 넘길 항목만
  python tools/Harness/verify/delta_scope.py --selftest

  입력: Doc/verify/<ID>/source_baseline.json(직전 실행 지문) · 지금 지문(source_snap.snapshot) · 직전 원장(verify_ledger.csv 결과 포함)
  결과 mode:
    full     기준선 없음 · 넓은 변경(AI '화면 전반' 또는 바뀐 항목이 기준선의 절반 이상) · AI 가 바뀐 항목 일부를 설명하지 못함 → 전체기능 재점검
    none     바뀐 소스 없음 · 직전 미해결 행 없음 → 재측정 없음
    partial  rules(재측정 규칙) · stages(eg/suite/diff 추가 단계)
  코드로 반드시 넣는 규칙
    ① 직전 결과가 미검증(ERROR·NOT_RUN·빈 값)인 행(2026-11-23 20261121120359_VISION 재측정 단위 = 행: FAIL·판정필요 행은 그 행을 판정하는 검사기·화면 소스가 바뀌지 않았으면 1차 결과를 둠. 종전 = FAIL·판정필요 행의 규칙 전체)
    ② 본문이 바뀐 시험(test 블록)이 판정하는 규칙(judge.test_ownership)
  재측정 단위 = 행(unit row): whole_rules = 바뀐 시험·검사기·화면 소스가 판정하는 규칙(그 규칙 행 전부) · rows_by_rule = 미검증 행과 미검증 분류 처리 대상 행(그 행만)
    run_verify --only 가 rows_by_rule 규칙에서는 대상 행을 고르는 시험만 다시 돌린다(row_targets · test_hits). 대응을 모르는 규칙은 규칙 전체
  AI 판단(읽기 전용 Claude): 바뀐 FE·공용 FE·PROC·메타·검사기 파일마다 '영향 규칙' 또는 '검증 영향 없음(사유)'. 모든 항목을 설명해야 하며 빠지면 full
  단계: 범위 규칙의 행 중 EG- 행이 있으면 eg · ES- 행이면 suite · source ASIS_DIFF 행이면 diff
"""
import collections, csv, datetime, difflib, hashlib, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 8)
UNRESOLVED = ('FAIL', '판정필요', 'ERROR', 'NOT_RUN', '')   # 직전 미해결(사유 문구의 유지 행 수 계산용)
UNVERIFIED = ('ERROR', 'NOT_RUN', '')                       # 2026-11-23 재측정 대상 = 미검증 행
TRIAGE_WORK = ('엔진', '대조표', '판단', '자동')              # 미검증 분류 처리 대상(checklist_run.WORK 와 같은 값)
STORE = os.path.join(ROOT, 'Doc', 'verify', '_src_store')   # 내용 저장소(해시 → 내용) · 다음 수정분 재점검의 차이 본문
MAX_ITEM = 6000; MAX_TOTAL = 90000


def read_csv(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as f:
            return list(csv.DictReader(f))
    except OSError:
        return []


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def content_of(key):
    """지문 키 → 지금 내용(텍스트). DB·메타는 source_snap 이 저장한 내용을 쓴다(_src_store)"""
    kind, _, name = key.partition(':')
    if kind == 'test' and name.endswith(':(머리말)'):   # 2026-11-20 스펙 머리말(첫 시험 앞까지 · source_snap.test_blocks 와 같은 경계)
        try:
            return spec_head(open(os.path.join(ROOT, 'Doc', 'e2e', 'specs', name.split(':', 1)[0]), encoding='utf-8').read())
        except OSError:
            return ''
    if kind in ('fe', 'shared', 'lib', 'asis'):
        try:
            return open(os.path.join(ROOT, name), encoding='utf-8', errors='replace').read()
        except OSError:
            return ''
    return ''


def spec_head(src):
    m = re.search(r"""(?m)^\s*test\(\s*(['"`])((?:\\.|(?!\1).)*)\1""", src)
    return src[:m.start()] if m else src


def old_text(key, old_h):
    """이전 내용 — 내용 저장소 → (머리말이면) 검사기 보완 준비 사본에서 같은 지문의 머리말 → None"""
    t = store_get(old_h) if old_h else None
    if t is not None or not old_h or not key.endswith(':(머리말)'):
        return t
    import glob as _g, source_snap as _ss
    spec = key.split(':', 2)[1]
    for p in sorted(_g.glob(os.path.join(ROOT, '.vibe', 'orch', 'snap', 'engine_*', 'Doc', 'e2e', 'specs', spec)), key=os.path.getmtime, reverse=True):
        try:
            h = spec_head(open(p, encoding='utf-8').read())
        except OSError:
            continue
        if _ss.blob(h.encode('utf-8')) == old_h:
            store_put(old_h, h); return h
    return None


def store_put(h, text):
    if not h or not text:
        return
    os.makedirs(STORE, exist_ok=True); p = os.path.join(STORE, h[:2], h)
    if not os.path.exists(p):
        os.makedirs(os.path.dirname(p), exist_ok=True); open(p, 'w', encoding='utf-8').write(text)


def store_get(h):
    try:
        return open(os.path.join(STORE, h[:2], h), encoding='utf-8').read()
    except (OSError, TypeError):
        return None


def remember(snap):
    """기준선을 저장할 때 텍스트 항목 내용을 저장소에 넣는다(다음 차이 본문용 · 같은 해시는 한 번만)"""
    for k, h in (snap.get('items') or {}).items():
        if (k.split(':', 1)[0] in ('fe', 'shared', 'lib') or k.endswith(':(머리말)')) and h and not store_get(h):
            store_put(h, content_of(k))


def diff_text(key, old_h, new_h):
    new = content_of(key); old = store_get(old_h) if old_h else None
    if old is None:
        body = f'(이전 내용 없음 · 지금 내용 앞부분)\n{new[:MAX_ITEM]}'
    else:
        body = ''.join(difflib.unified_diff(old.splitlines(True), new.splitlines(True), 'before', 'after', n=2))
    return body[:MAX_ITEM] + ('\n…(잘림)' if len(body) > MAX_ITEM else '')


def unverified_rows(ledger):
    """{규칙: [row_id]} — 직전 결과가 미검증(ERROR·NOT_RUN·빈 값)인 행"""
    out = {}
    for r in ledger:
        if r.get('rule_id') and (r.get('result') or '') in UNVERIFIED:
            out.setdefault(r['rule_id'].upper(), []).append(r.get('row_id') or '')
    return out


def triage_rows(mid):
    """{규칙: [row_id]} — 미검증 분류(unverified_triage.csv)의 처리 대상 행. checklist_run.recheck_plan 이 범위에 합치는 규칙의 행"""
    out = {}
    for r in read_csv(os.path.join(ROOT, 'Doc', 'verify', mid, 'unverified_triage.csv')):
        if r.get('actor') in TRIAGE_WORK and r.get('rule_id') and r.get('row_id'):
            out.setdefault(r['rule_id'].upper(), []).append(r['row_id'])
    return out


def row_scope(ledger, whole, *row_maps):
    """(rows_by_rule, 대상 행 수) — whole 규칙은 그 규칙 행 전부, 나머지는 row_maps({규칙: [row_id]})에 있는 행만"""
    whole = {x.upper() for x in whole}; rb = {}
    for m in row_maps:
        for rule, ids in (m or {}).items():
            if rule not in whole:
                rb.setdefault(rule, set()).update(i for i in ids if i)
    ids_in = {i for s in rb.values() for i in s}
    n = sum(1 for r in ledger if (r.get('rule_id') or '').upper() in whole or r.get('row_id') in ids_in)
    return {k: sorted(v) for k, v in sorted(rb.items()) if v}, n


def row_targets(sc, only, ledger, prev):
    """run_verify --only 용. {규칙: [대상 원장 행]} — 여기 없는 규칙은 그 규칙 행 전부(규칙 단위). 행 단위 범위를 쓸 수 없으면 None
       sc = delta_scope.json · ledger = 다시 만든 원장 · prev = 직전 원장(row_id → 행). 새로 생긴 행과 조건·기대가 바뀐 행은 지난 결과를 둘 수 없어 대상에 넣는다"""
    if not isinstance(sc, dict) or sc.get('unit') != 'row' or sc.get('mode') not in ('partial', 'none') or prev is None:
        return None
    only = {x.upper() for x in only}
    if not {str(x).upper() for x in (sc.get('rules') or [])} <= only:
        return None   # 이번 실행의 범위와 맞지 않는 판정 파일(다른 실행 것)
    whole = {str(x).upper() for x in (sc.get('whole_rules') or [])}
    rb = {str(k).upper(): set(v or []) for k, v in (sc.get('rows_by_rule') or {}).items()}
    out = {}
    for rule in only:
        if rule in whole or rule not in rb:
            continue
        rows = []
        for r in ledger:
            if (r.get('rule_id') or '').upper() != rule:
                continue
            o = prev.get(r.get('row_id'))
            if r.get('row_id') in rb[rule] or o is None or (r.get('condition') or '') != (o.get('condition') or '') or (r.get('expected') or '') != (o.get('expected') or ''):
                rows.append(r)
        if rows:   # 대상 행이 원장에서 사라졌으면 규칙 단위로 둔다
            out[rule] = rows
    return out


def rule_hit(rule, v, targets):
    """시험(v = judge.test_ownership 값)이 이 규칙의 대상 행을 고르는가. 출처 비교(source === 'X')가 있는 시험은 그 출처 행만 고른다(judge T61 과 같은 근거) · 출처 비교가 없으면 고르는 것으로 본다"""
    if not targets or rule not in targets:
        return True
    srcs = v.get('sources') or set()
    return not srcs or any((r.get('source') or '') in srcs for r in targets[rule])


def test_hits(v, only, targets):
    """시험이 판정하는 규칙(본문 rule_id 비교) 중 이번 범위에 걸리고 대상 행을 고르는 것이 있는가"""
    return any(rule_hit(r, v, targets) for r in (v.get('rules') or set()) & set(only))


def row_in_scope(r, only, targets):
    """원장 행이 이번 재측정 대상인가(규칙이 범위 안 · 행 단위 규칙이면 대상 행)"""
    rule = (r.get('rule_id') or '').upper()
    if rule not in only:
        return False
    return not targets or rule not in targets or any(x.get('row_id') == r.get('row_id') for x in targets[rule])


def code_rules(mid, ledger, changed_tests):
    """(규칙 집합, 사유 목록)"""
    rules = set(); why = []
    unv = unverified_rows(ledger)
    if unv:
        rules |= set(unv); why.append(f"직전 미검증 행 {sum(len(v) for v in unv.values())}행(규칙 {len(unv)}개)")
    kept = sum(1 for r in ledger if r.get('rule_id') and (r.get('result') or '') in ('FAIL', '판정필요'))
    if kept:
        why.append(f"FAIL·판정필요 {kept}행은 그 행을 판정하는 검사기·소스가 바뀌지 않으면 1차 결과 유지")
    if changed_tests:
        try:
            import judge
            sd = os.path.join(ROOT, 'Doc', 'e2e', 'specs')
            raw = judge.test_ownership([os.path.join(sd, n) for n in ('_verify.spec.ts', '_trace.spec.ts')])   # {(runner, 제목): {'sources', 'rules'}}
            # 규칙 = 본문의 rule_id 비교(test_ownership) ∪ 제목의 규칙 토큰(예 '(D4)', 'C1·C4' — run_verify --only 의 시험 고르기와 같은 근거)
            own = {k[1]: set(v.get('rules') or ()) | set(re.findall(r'(?<![A-Za-z0-9])([A-N]\d{1,2}|SC\d|X-[A-Z]+)(?![0-9])', k[1])) for k, v in raw.items() if isinstance(k, tuple)}
        except Exception as e:
            own = None; why.append(f'시험→규칙 대응 읽기 실패({type(e).__name__}) → 바뀐 시험이 있어 전체')
        if own is None:
            return None, why
        hit = set(); unmapped = []
        for t in changed_tests:
            rs = set().union(*[own[title] for title in own if title == t or title.endswith(t) or t.endswith(title)]) if own else set()
            if rs:
                hit |= {x.upper() for x in rs}
            else:
                unmapped.append(t)
        if hit:
            rules |= hit; why.append(f"본문이 바뀐 시험 {len(changed_tests)}개가 판정하는 규칙 {len(hit)}개")
        if unmapped:
            # 규칙을 코드로 알 수 없는 시험(제목 템플릿·규칙 비교문 없음)이 바뀜 → 그 시험이 무엇을 재는지 모르므로 전체(근거 없는 제외 금지)
            why.append(f"규칙 대응을 코드로 못 찾는 시험 {len(unmapped)}개 바뀜: " + ' | '.join(unmapped[:3]))
            return None, why
    return rules, why


# 2026-11-20 사용자 결정 '두 범위 합치기': 검사기 파일 변경 → 코드로 영향 범위(AI 판단 입력에서 뺌 · 종전엔 검사기 파일 차이가 9만 자 한도를 넘겨 6개 화면 중 5개가 전체 재측정)
STAGE_TOOLS = ((re.compile(r'^tools/Harness/verify/(eg_|popup_data_check|auth_)'), 'eg'), (re.compile(r'^tools/Harness/verify/(diff_|sqllog_calls|gen_param_map|asis_live)'), 'diff'),
               (re.compile(r'^tools/Harness/verify/e2e_suite'), 'suite'))
SPEC_DIR = os.path.join(ROOT, 'Doc', 'e2e', 'specs')


RX_TOP = re.compile(r'^(?:export\s+)?(?:default\s+)?(?:async\s+)?(function|const|let|var|class|type|interface|enum)\s+(\w+)', re.M)


def changed_names(key, old_h, new_h):
    """(바뀐 최상위 함수·상수 이름 집합, 전부인가)
       최상위 선언(함수·상수·클래스) 경계로 바뀐 줄을 나눈다. 가져오기(import)·형(type·interface)·주석·빈 줄 변경은 실행 동작이 아니라 뺀다.
       바뀐 것이 상수면 그 상수를 쓰는 같은 파일 함수도 넣는다. 선언 밖 다른 실행 문장이 바뀌거나 이전 내용이 없으면 파일의 모든 이름"""
    new = content_of(key); old = old_text(key, old_h)
    tops = [(new[:m.start()].count('\n'), m.group(1), m.group(2)) for m in RX_TOP.finditer(new)]
    funcs = {n for _, kd, n in tops if kd in ('function', 'const', 'let', 'var', 'class')}
    if old is None or not tops:
        return funcs, True
    nl = new.splitlines(); changed = set()
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, old.splitlines(), nl, autojunk=False).get_opcodes():
        if tag != 'equal':
            changed |= set(range(j1, max(j2, j1 + 1)))
    out = set(); consts = set(); whole = False
    for ln in sorted(changed):
        txt = nl[ln].strip() if ln < len(nl) else ''
        own = [t for t in tops if t[0] <= ln]
        if not own:
            if not txt or txt.startswith(('import ', 'import{', '//', '/*', '*', '*/')) or txt in ('}', ');', '});'):
                continue
            whole = True; continue
        _, kd, n = own[-1]
        if kd in ('type', 'interface'):
            continue
        out.add(n)
        if kd in ('const', 'let', 'var', 'enum'):
            consts.add(n)
    if whole:
        return funcs, True
    if consts:   # 바뀐 상수를 쓰는 함수(같은 파일 · 한 단계)
        bounds = [t[0] for t in tops] + [len(nl)]
        for i, (st, kd, n) in enumerate(tops):
            body = '\n'.join(nl[st:bounds[i + 1]])
            if n not in consts and any(re.search(r'(?<![\w.])' + re.escape(c) + r'(?!\w)', body) for c in consts):
                out.add(n)
    return {n for n in out if n in funcs}, False


def test_blocks(spec):
    """[(시험 제목, 본문)] — test( 시작 위치로 나눈 근사 구간(다음 test( 전까지)"""
    try:
        s = open(os.path.join(SPEC_DIR, spec), encoding='utf-8', errors='replace').read()
    except OSError:
        return []
    pos = [(m.start(), m.group(2)) for m in re.finditer(r"\btest(?:\.\w+)?\(\s*(['\"`])(.+?)\1", s)]
    return [(t, s[p:(pos[i + 1][0] if i + 1 < len(pos) else len(s))]) for i, (p, t) in enumerate(pos)]


def engine_scope(mid, eng_keys, olds, news, ledger):
    """검사기 파일 변경 → (규칙, 단계, 사유). 파이썬 도구 중 facts·static·post 단계 것은 --only 실행에서도 다시 돌므로 규칙 추가 없음"""
    rules, stages, why = set(), set(), []
    py = [k for k in eng_keys if k.endswith('.py')]; ts = [k for k in eng_keys if k.endswith('.ts') and k.startswith('lib:')]
    heads = [k for k in eng_keys if k.endswith(':(머리말)')]
    for k in heads:
        spec = k.split(':', 2)[1]
        n, whole = changed_names(k, olds.get(k), news.get(k))
        if spec == '_open.spec.ts':
            why.append('화면 열기 스펙 머리말 바뀜 — 사전 단계에서 늘 다시 돎'); continue
        if spec.startswith('eg_'):
            stages.add('eg'); rules |= {r['rule_id'].upper() for r in ledger if r['row_id'].startswith('EG-') and r.get('rule_id')}
            why.append(f'{spec} 머리말 바뀜 → 팝업·권한 단계'); continue
        if spec == '_snap.spec.ts':
            rules |= {'H4', 'A5', 'G4', 'K4', 'H6'}; why.append('스냅샷 스펙 머리말 바뀜 → 스냅샷 규칙 5개'); continue
        if not n and not whole:
            why.append(f'{spec} 머리말 바뀜 · 바뀐 함수 없음(가져오기·형·주석)'); continue
        try:
            import judge
            raw = judge.test_ownership([os.path.join(SPEC_DIR, spec)])
            own = {kk[1]: set(v.get('rules') or ()) | set(re.findall(r'(?<![A-Za-z0-9])([A-N]\d{1,2}|SC\d|X-[A-Z]+)(?![0-9])', kk[1])) for kk, v in raw.items() if isinstance(kk, tuple)}
        except Exception:
            own = {}
        rx_h = re.compile(r'(?<![\w.])(' + '|'.join(re.escape(x) for x in sorted(n, key=len, reverse=True)) + r')\b') if n else None
        hit = 0
        for title, body in test_blocks(spec):
            if whole or (rx_h and rx_h.search(body)):
                rs = {x.upper() for x in own.get(title, set())}
                if rs:
                    rules |= rs; hit += 1
        why.append(f"{spec} 머리말 " + ('이전 내용 없음 → 그 스펙 시험 전부' if whole else f'바뀐 함수·상수 {len(n)}개({", ".join(sorted(n)[:5])})') + f'를 쓰는 시험 {hit}개의 규칙')
    py_st = set()
    for k in py:
        for rx, st in STAGE_TOOLS:
            if rx.match(k.split(':', 1)[1]):
                py_st.add(st)
    stages |= py_st
    if py:
        why.append(f"검사기 도구(파이썬) {len(py)}개 바뀜 — 판정·정적 도구는 부분 재측정에서도 전부 다시 돎" + (f" · 단계 {','.join(sorted(py_st))} 추가" if py_st else ''))
    if not ts:
        return rules, stages, why
    names = set(); allf = []
    for k in ts:
        n, whole = changed_names(k, olds.get(k), news.get(k)); names |= n
        if whole:
            allf.append(k.rsplit('/', 1)[-1])
    if not names:
        why.append(f'E2E 라이브러리 {len(ts)}개 바뀜 · 바뀐 함수 없음(주석·빈 줄)'); return rules, stages, why
    rx = re.compile(r'(?<![\w.])(?:\w+\.)?(' + '|'.join(re.escape(x) for x in sorted(names, key=len, reverse=True)) + r')\s*\(')
    try:
        import judge
        raw = judge.test_ownership([os.path.join(SPEC_DIR, n) for n in ('_verify.spec.ts', '_trace.spec.ts')])
        own = {k[1]: set(v.get('rules') or ()) | set(re.findall(r'(?<![A-Za-z0-9])([A-N]\d{1,2}|SC\d|X-[A-Z]+)(?![0-9])', k[1])) for k, v in raw.items() if isinstance(k, tuple)}
    except Exception:
        own = {}
    hit = 0; unmapped = 0
    for spec in ('_verify.spec.ts', '_trace.spec.ts'):
        for title, body in test_blocks(spec):
            if rx.search(body):
                rs = {x.upper() for x in own.get(title, set())}
                if rs:
                    rules |= rs; hit += 1
                else:
                    unmapped += 1
    for spec in os.listdir(SPEC_DIR) if os.path.isdir(SPEC_DIR) else []:
        if spec.startswith('eg_') and spec.endswith('.ts') and any(rx.search(b) for _, b in test_blocks(spec)):
            stages.add('eg'); rules |= {r['rule_id'].upper() for r in ledger if r['row_id'].startswith('EG-') and r.get('rule_id')}
        if spec == '_snap.spec.ts' and any(rx.search(b) for _, b in test_blocks(spec)):
            rules |= {'H4', 'A5', 'G4', 'K4', 'H6'}
    why.append(f"E2E 라이브러리 {len(ts)}개의 바뀐 함수 {len(names)}개" + (f"(파일 전체 {','.join(allf[:4])})" if allf else '') + f"를 쓰는 시험 {hit}개의 규칙"
               + (f" · 규칙을 코드로 못 찾는 시험 {unmapped}개(제목 템플릿 · 그 시험은 판정 규칙 범위 밖)" if unmapped else ''))
    return rules, stages, why


PROMPT = """너는 화면 {mid} 의 CheckList '수정분 재점검' 범위를 정하는 검토자다. 지난 CheckList 뒤에 아래 항목이 바뀌었다.
바뀐 항목마다 이 화면 검증 원장의 어느 규칙(rule_id) 판정이 달라질 수 있는지 고른다. 고른 규칙은 다시 측정하고, 고르지 않은 규칙은 지난 판정을 그대로 쓴다.

지킬 것
- 판정이 달라질 가능성이 조금이라도 있으면 그 규칙을 넣는다. 빼서 생기는 누락이 가장 큰 잘못이다.
- 항목마다 반드시 rules(영향 규칙 목록) 또는 none_why(검증 영향 없음 사유, 예: 주석만 바뀜) 중 하나를 쓴다. 근거로 바뀐 줄을 짧게 인용한다(evidence).
- 화면 공용 구조(레이아웃, 공용 그리드·조회조건 컴포넌트, 화면 전체가 쓰는 훅·상수)가 바뀌어 거의 모든 규칙이 영향 받으면 scope 를 "full" 로 쓴다.
- 규칙 목록에 없는 rule_id 는 쓰지 않는다.

규칙 목록(rule_id · 원장 행 수 · 측정 방법 · 대상 예):
{rules}

바뀐 항목(종류:이름 · 차이):
{items}

답은 JSON 하나만: {{"scope": "partial" | "full", "full_why": "", "items": [{{"key": "fe:...", "rules": ["A5"], "none_why": "", "evidence": "..."}}]}}"""


def rule_table(ledger):
    try:
        defs = {r['check']: (r.get('how') or r.get('method') or '')[:80] for r in read_csv(os.path.join(HERE, 'mapping_checkdefs.csv'))}
    except Exception:
        defs = {}
    by = collections.defaultdict(list)
    for r in ledger:
        if r.get('rule_id'):
            by[r['rule_id'].upper()].append(r)
    lines = []
    for rid in sorted(by):
        ex = ' / '.join(dict.fromkeys((x.get('target') or '')[:40] for x in by[rid]))
        lines.append(f"{rid} · {len(by[rid])}행 · {defs.get(rid, '')} · {ex[:160]}")
    return '\n'.join(lines), set(by)


def validate(ans, keys, known):
    """(scope, rules, 설명 못 한 키, 사유)"""
    if not isinstance(ans, dict):
        return 'full', set(), list(keys), 'AI 답 형식 오류'
    if ans.get('scope') == 'full':
        return 'full', set(), [], 'AI 판단 화면 전반: ' + str(ans.get('full_why') or '')[:200]
    got = {}; rules = set()
    for it in ans.get('items') or []:
        if not isinstance(it, dict) or it.get('key') not in keys:
            continue
        rs = {str(x).upper() for x in (it.get('rules') or []) if str(x).upper() in known}
        if rs or str(it.get('none_why') or '').strip():
            got[it['key']] = True; rules |= rs
    miss = [k for k in keys if k not in got]
    if miss:
        return 'full', set(), miss, f'AI 가 바뀐 항목 {len(miss)}개를 설명하지 못함(근거 없는 제외 불가)'
    return 'partial', rules, [], ''


def decide(mid, ask=None, dry=False):
    import source_snap
    vd = os.path.join(ROOT, 'Doc', 'verify', mid); out = {'menu_id': mid, 'at': now()}
    base = source_snap.load(mid)
    if not base:
        out.update(mode='full', why='기준선 없음(첫 실행 또는 기준선 저장 전) — 전체기능 재점검으로 실행하고 기준선을 남김'); return finish(vd, out)
    cur = source_snap.snapshot(mid); changed, added, removed = source_snap.diff(base, cur)
    keys = changed + added + removed
    ledger = read_csv(os.path.join(vd, 'verify_ledger.csv'))
    out.update(baseline_at=base.get('at'), last_full=base.get('last_full', ''), changed=len(changed), added=len(added), removed=len(removed), db_error=cur.get('db_error', ''))
    tk = [k.split(':', 2) for k in keys if k.startswith('test:') and not k.endswith('(머리말)')]
    tests = [t for _, sp, t in tk if sp in ('_verify.spec.ts', '_trace.spec.ts')]
    head_changed = [k for k in keys if k.startswith('test:') and k.endswith('(머리말)')]
    out['changed_tests'] = len(tests)   # 2026-11-21 판정 이력(delta_scope_hist.jsonl)의 시험 수
    rules, why = code_rules(mid, ledger, tests)
    if rules is None:
        out.update(mode='full', why=' · '.join(why)); return finish(vd, out)
    # 2026-11-23 재측정 단위 = 행: whole = 바뀐 시험·검사기·화면 소스가 판정하는 규칙(그 규칙 행 전부). 미검증 행만으로 들어온 규칙은 그 행만
    unv = unverified_rows(ledger); tri = triage_rows(mid)
    whole = set(code_rules(mid, [], tests)[0] or ()) if tests else set()
    # 스펙별 처리: 팝업·권한 검사기 시험이 바뀌면 그 검사기 행(EG-) 규칙 + eg 단계 · 스냅샷 시험이 바뀌면 스냅샷 규칙(run_verify snap_rules 와 같음)
    force_stages = set()
    if any(sp.startswith('eg_') for _, sp, _t in tk):
        eg_rules = {r['rule_id'].upper() for r in ledger if r['row_id'].startswith('EG-') and r.get('rule_id')}
        rules |= eg_rules; whole |= eg_rules; force_stages.add('eg'); why.append(f'팝업·권한 검사기 시험이 바뀜 → 그 행 규칙 {len(eg_rules)}개 · eg 단계')
    if any(sp == '_snap.spec.ts' for _, sp, _t in tk):
        rules |= {'H4', 'A5', 'G4', 'K4', 'H6'}; whole |= {'H4', 'A5', 'G4', 'K4', 'H6'}; why.append('스냅샷 시험이 바뀜 → 스냅샷 규칙 5개')
    # AI 에 넘길 항목: 시험 블록 외 바뀐 것(머리말 포함) · 원장 정의는 run_verify 가 새 행·조건 바뀐 행으로 따로 처리
    #   2026-11-20 '두 범위 합치기': 검사기 파일(lib:)은 AI 에 넘기지 않고 engine_scope 로(코드)
    eng_keys = [k for k in keys if k.startswith('lib:') or k.endswith(':(머리말)')]   # 2026-11-20 스펙 머리말도 코드로
    e_rules, e_stages, e_why = engine_scope(mid, eng_keys, base.get('items') or {}, cur.get('items') or {}, ledger)
    rules |= e_rules; whole |= e_rules; force_stages |= e_stages; why += e_why
    ai_keys = [k for k in keys if not k.startswith(('test:', 'lib:')) and k != 'ledger:def']
    scr_items = [k for k in (base.get('items') or {}) if not k.startswith(('lib:', 'test:'))]
    n_base = len(scr_items)
    if n_base and len(ai_keys) * 2 >= n_base:
        out.update(mode='full', why=f'바뀐 화면 소스 항목 {len(ai_keys)}개가 기준선 {n_base}개의 절반 이상'); return finish(vd, out)
    if not ai_keys and not rules:
        rb0, n0 = row_scope(ledger, set(), tri)   # 미검증 분류 처리 대상 행(checklist_run 이 규칙을 합칠 때 그 행의 시험만 돌게)
        out.update(mode='none', why='바뀐 소스 없음 · 직전 미검증 행 없음' + (' · ' + ' · '.join(why) if why else ''), rules=[], unit='row', whole_rules=[], rows_by_rule=rb0, rows_in=n0, rows_keep=len(ledger) - n0)
        return finish(vd, out)
    table, known = rule_table(ledger)
    ai_rules = set(); ai_note = ''
    if ai_keys:
        olds = base.get('items') or {}; news = cur.get('items') or {}; parts = []; total = 0
        for k in ai_keys:
            body = diff_text(k, olds.get(k), news.get(k)) if k.split(':', 1)[0] in ('fe', 'shared', 'lib') else f"(지문 {olds.get(k, '없음')} → {news.get(k, '없음')})"
            seg = f'### {k}\n{body}\n'; total += len(seg); parts.append(seg)
        if total > MAX_TOTAL:
            out.update(mode='full', why=f'바뀐 내용 {total}자가 판단 한도({MAX_TOTAL}자)를 넘는 넓은 변경 · 항목 {len(ai_keys)}개'); return finish(vd, out)
        if dry:
            out.update(mode='dry', rules=sorted(rules), code_why=why, ai_keys=ai_keys); return finish(vd, out)
        prompt = PROMPT.format(mid=mid, rules=table, items='\n'.join(parts))
        if ask is None:
            import llm_call
            ask = lambda p: llm_call.ask(mid, 'delta', p, rows=len(ai_keys), use_cache=True)
        r = ask(prompt)
        scope, ai_rules, miss, note = validate(r.get('data') if r.get('ok') else None, ai_keys, known)
        if not r.get('ok'):
            scope, note = 'full', f"AI 답 없음({r.get('why', '')}) — 모르면 재측정"
        out['ai'] = {'scope': scope, 'rules': sorted(ai_rules), 'missing': miss[:20], 'note': note, 'cost': r.get('cost', 0), 'answer': r.get('data')}
        if scope == 'full':
            out.update(mode='full', why=note); return finish(vd, out)
        ai_note = f'AI 판단 영향 규칙 {len(ai_rules)}개(바뀐 항목 {len(ai_keys)}개)'
    allr = sorted(rules | ai_rules); whole |= ai_rules
    rb, n_in = row_scope(ledger, whole, unv, tri)
    # 단계(eg·suite·diff)는 대상 행으로 정한다: whole 규칙의 행 전부 + 범위 규칙의 미검증 행(미검증 분류 처리 대상 행의 단계는 checklist_run.recheck_plan 이 더함)
    rows_in = [r for r in ledger if (r.get('rule_id') or '').upper() in whole or ((r.get('rule_id') or '').upper() in set(allr) and r.get('row_id') in set(unv.get((r.get('rule_id') or '').upper(), ())))]
    stages = sorted(force_stages | {'eg' for r in rows_in if r['row_id'].startswith('EG-')} | {'suite' for r in rows_in if r['row_id'].startswith('ES-')} | {'diff' for r in rows_in if r.get('source') == 'ASIS_DIFF'})
    keep = len(ledger) - n_in
    out.update(mode='partial' if allr else 'none', rules=allr, stages=stages, code_why=why, ai_note=ai_note, rows_in=n_in, rows_keep=keep, unit='row', whole_rules=sorted(whole), rows_by_rule=rb,
               why=' · '.join(why + ([ai_note] if ai_note else [])) or '범위 없음', head_changed=head_changed)
    return finish(vd, out)


def finish(vd, out):
    os.makedirs(vd, exist_ok=True)
    json.dump(out, open(os.path.join(vd, 'delta_scope.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    if out.get('mode') != 'dry':
        hist_add(vd, out)
    return out


def hist_row(out):
    """판정 이력 1줄 — 규칙 수·행 수·시험 수·단계·사유(2026-11-21 VMO VISION_4: delta_scope.json 은 마지막 1건만 남음)"""
    return {'at': out.get('at'), 'mode': out.get('mode'), 'rules_n': len(out.get('rules') or []), 'rules': out.get('rules') or [],
            'rows_in': out.get('rows_in', 0), 'rows_keep': out.get('rows_keep', 0), 'changed_tests': out.get('changed_tests', 0),
            'changed': out.get('changed', 0), 'added': out.get('added', 0), 'removed': out.get('removed', 0),
            'stages': out.get('stages') or [], 'why': str(out.get('why') or '')[:500]}


def hist_add(vd, out):
    """Doc/verify/<ID>/delta_scope_hist.jsonl 에 회차마다 1줄 덧붙임 · 실패해도 범위 판정 영향 없음"""
    try:
        with open(os.path.join(vd, 'delta_scope_hist.jsonl'), 'a', encoding='utf-8') as f:
            f.write(json.dumps(hist_row(out), ensure_ascii=False) + '\n')
    except OSError as e:
        print(f'[WARN] delta_scope_hist.jsonl 기록 실패({e}) — 판정 영향 없음', flush=True)


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    keys = ['fe:a.tsx', 'db:X.P']; known = {'A5', 'G4', 'A1'}
    s, r, m, _ = validate({'scope': 'partial', 'items': [{'key': 'fe:a.tsx', 'rules': ['A5', 'ZZ']}, {'key': 'db:X.P', 'rules': ['A1']}]}, keys, known)
    chk('모든 항목 설명 → 부분 · 모르는 규칙 제외', s == 'partial' and r == {'A5', 'A1'} and not m)
    s, r, m, _ = validate({'scope': 'partial', 'items': [{'key': 'fe:a.tsx', 'rules': ['A5']}]}, keys, known)
    chk('설명 못 한 항목 있으면 전체', s == 'full' and m == ['db:X.P'])
    s, r, m, _ = validate({'scope': 'partial', 'items': [{'key': 'fe:a.tsx', 'rules': [], 'none_why': '주석만 바뀜'}, {'key': 'db:X.P', 'rules': ['A1']}]}, keys, known)
    chk('영향 없음 사유 인정', s == 'partial' and r == {'A1'})
    s, r, m, _ = validate({'scope': 'partial', 'items': [{'key': 'fe:a.tsx', 'rules': [], 'none_why': ''}, {'key': 'db:X.P', 'rules': ['A1']}]}, keys, known)
    chk('규칙도 사유도 없으면 설명 못 함 → 전체', s == 'full')
    s, r, m, _ = validate({'scope': 'full', 'full_why': '레이아웃'}, keys, known)
    chk('AI 화면 전반 → 전체', s == 'full')
    s, r, m, _ = validate('x', keys, known); chk('형식 오류 → 전체', s == 'full')
    led = [{'row_id': 'V-1', 'rule_id': 'A5', 'result': 'PASS'}, {'row_id': 'V-2', 'rule_id': 'G4', 'result': 'ERROR'}, {'row_id': 'V-3', 'rule_id': 'H2', 'result': 'FAIL'}]
    r, w = code_rules('X', led, [])
    chk('직전 미검증 행 규칙만 코드로 넣음 · FAIL 행 규칙은 1차 결과 유지', r == {'G4'} and any('1차 결과 유지' in x for x in w))
    # 2026-11-23 재측정 단위 = 행
    led2 = [{'row_id': 'V-1', 'rule_id': 'F4', 'source': 'RULE_SCREEN', 'result': 'FAIL', 'condition': 'c', 'expected': 'e'},
            {'row_id': 'T-2', 'rule_id': 'F4', 'source': 'TRACE', 'result': 'ERROR', 'condition': 'c', 'expected': 'e'},
            {'row_id': 'V-3', 'rule_id': 'A5', 'source': 'AUTO', 'result': 'PASS', 'condition': 'c', 'expected': 'e'},
            {'row_id': 'V-4', 'rule_id': 'A5', 'source': 'AUTO', 'result': 'PASS', 'condition': 'c', 'expected': 'e'},
            {'row_id': 'V-5', 'rule_id': 'H11', 'source': 'AUTO', 'result': 'NA', 'condition': 'c', 'expected': 'e'}]
    chk('미검증 행 = ERROR·NOT_RUN·빈 값만', unverified_rows(led2) == {'F4': ['T-2']})
    rb, n = row_scope(led2, {'A5'}, unverified_rows(led2), {'H11': ['V-5'], 'A5': ['V-3']})
    chk('행 범위 — whole 규칙은 행 전부 · 나머지는 지정 행만', rb == {'F4': ['T-2'], 'H11': ['V-5']} and n == 4)
    sc = {'unit': 'row', 'mode': 'partial', 'rules': ['A5', 'F4'], 'whole_rules': ['A5'], 'rows_by_rule': rb}
    prev = {x['row_id']: x for x in led2}
    tg = row_targets(sc, {'A5', 'F4', 'H11', 'G1'}, led2, prev)
    chk('대상 행 — 행 단위 규칙만 담고 whole·모르는 규칙은 규칙 단위', set(tg) == {'F4', 'H11'} and [x['row_id'] for x in tg['F4']] == ['T-2'])
    led3 = [dict(x) for x in led2]; led3[0]['expected'] = 'e2'; led3.append({'row_id': 'V-9', 'rule_id': 'F4', 'source': 'AUTO', 'result': '', 'condition': '', 'expected': ''})
    chk('대상 행 — 조건·기대가 바뀐 행과 새 행 포함', [x['row_id'] for x in row_targets(sc, {'A5', 'F4'}, led3, prev)['F4']] == ['V-1', 'T-2', 'V-9'])
    chk('행 단위 불가 — 규칙 단위 판정 파일 · 범위 불일치 · 직전 원장 없음', row_targets({'mode': 'partial', 'rules': ['F4']}, {'F4'}, led2, prev) is None
        and row_targets(sc, {'F4'}, led2, prev) is None and row_targets(sc, {'A5', 'F4'}, led2, None) is None)
    chk('대상 행이 원장에서 사라진 규칙 = 규칙 단위', 'F4' not in row_targets(dict(sc, rows_by_rule={'F4': ['T-없음']}), {'A5', 'F4'}, led2, prev))
    t_trace = {'rules': {'F4'}, 'sources': {'TRACE'}}; t_screen = {'rules': {'F4'}, 'sources': {'RULE_SCREEN'}}; t_any = {'rules': {'F4', 'A5'}, 'sources': set()}
    chk('시험 고르기 — 대상 행의 출처를 고르는 시험만', test_hits(t_trace, {'A5', 'F4'}, tg) and not test_hits(t_screen, {'A5', 'F4'}, tg))
    chk('시험 고르기 — 출처 비교 없는 시험은 넣음 · 규칙 단위(대상 없음)는 종전과 같음', test_hits(t_any, {'A5', 'F4'}, tg) and test_hits(t_screen, {'A5', 'F4'}, None)
        and test_hits({'rules': {'A5'}, 'sources': {'ZZ'}}, {'A5', 'F4'}, tg) and not test_hits({'rules': {'B1'}, 'sources': set()}, {'A5', 'F4'}, tg))
    chk('범위 행 — 행 단위 규칙은 대상 행만 · 규칙 단위는 행 전부', row_in_scope(led2[1], {'A5', 'F4'}, tg) and not row_in_scope(led2[0], {'A5', 'F4'}, tg)
        and row_in_scope(led2[2], {'A5', 'F4'}, tg) and row_in_scope(led2[0], {'A5', 'F4'}, None) and not row_in_scope(led2[4], {'A5', 'F4'}, tg))
    r, s, w = engine_scope('X', ['lib:tools/Harness/verify/eg_chain.py', 'lib:tools/Harness/verify/judge.py'], {}, {}, led)
    chk('검사기 파이썬 — eg 도구만 단계 추가 · 규칙 추가 없음', s == {'eg'} and not r)
    chk('머리말 경계 — 첫 시험 앞까지', spec_head("import x;\nconst A = 1;\ntest('가', () => {});\n") == "import x;\nconst A = 1;\n")
    r, s, w = engine_scope('X', ['test:eg_popup.spec.ts:(머리말)'], {}, {}, [{'row_id': 'EG-1', 'rule_id': 'H5', 'result': 'PASS'}])
    chk('eg 스펙 머리말 — eg 단계 + EG 규칙', s == {'eg'} and r == {'H5'})
    import tempfile
    with tempfile.TemporaryDirectory() as td:
        finish(td, {'menu_id': 'X', 'at': '1', 'mode': 'partial', 'rules': ['A5', 'G4'], 'rows_in': 7, 'rows_keep': 3, 'changed_tests': 2, 'why': '가'})
        finish(td, {'menu_id': 'X', 'at': '2', 'mode': 'full', 'why': '나'})
        finish(td, {'menu_id': 'X', 'at': '3', 'mode': 'dry', 'rules': []})
        hl = [json.loads(x) for x in open(os.path.join(td, 'delta_scope_hist.jsonl'), encoding='utf-8')]
        chk('판정 이력 — 회차마다 1줄 덧붙임 · dry 제외', len(hl) == 2 and hl[0]['rules_n'] == 2 and hl[0]['rows_in'] == 7 and hl[0]['changed_tests'] == 2 and hl[1]['mode'] == 'full')
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a:
        print(__doc__); return 2
    o = decide(a[0].upper(), dry='--dry' in a)
    print(f"[수정분 범위] {o['menu_id']} {o['mode']} · {o.get('why', '')}"
          + (f" · 재측정 규칙 {len(o.get('rules') or [])}개 · 행 {o.get('rows_in', 0)} · 유지 {o.get('rows_keep', 0)} · 추가 단계 {','.join(o.get('stages') or []) or '없음'}" if o['mode'] == 'partial' else ''), flush=True)
    print(json.dumps({k: o.get(k) for k in ('mode', 'rules', 'stages', 'why')}, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    sys.exit(main())
