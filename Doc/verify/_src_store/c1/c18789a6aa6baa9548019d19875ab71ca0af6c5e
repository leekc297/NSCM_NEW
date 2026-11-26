# -*- coding: utf-8 -*-
"""기준 원장(대조표 원장의 기준) 정리 — AS-IS 파싱 목록 · AS-IS 실측 목록 · TO-BE RULE 을 화면 요소에 묶는다 (2026-11-20 사용자 지시)
   "AS-IS 파싱 과 AS-IS 실측에 대한 목록 정리에 AI 사용하고 TO-BE RULE 과 결합해서 대조표원장의 기준으로 만들고 이때 AI를 사용해서 잘 정리될 수 있도록"
   "기준을 잘 정리하는 것 부터가 시작"

  python tools/Harness/verify/criteria_build.py <MENU_ID>                기준 정리(코드 + AI) → Doc/verify/<ID>/criteria/
  python tools/Harness/verify/criteria_build.py <MENU_ID> --no-ai        코드 단계만(요소 목록 · 행 연결 · 실측 연결)
  python tools/Harness/verify/criteria_build.py <MENU_ID> --dry          AI 묶음 수·프롬프트 크기만(호출 없음)
  python tools/Harness/verify/criteria_build.py <MENU_ID> --ledger <csv> 다른 원장 파일로(시범·비교)
  python tools/Harness/verify/criteria_build.py <MENU_ID> --from <json>  AI 호출 없이 답 JSON 으로(배관 시험)
  python tools/Harness/verify/criteria_build.py --selftest

  단계
    B1 코드  요소 목록: TO-BE 그리드 컬럼(sheet_columns.csv) · AS-IS 그리드 컬럼(grid_columns_asis.csv) · 조회조건(원장 SEARCH 행 · AS-IS 조건 컨트롤)
             · 버튼(AS-IS 컨트롤 btn*) · 팝업 · SP(TO-BE proc_meta · AS-IS 실측 SP) · 메시지(MSG 번호) · 화면
    B2 코드  원장 행 → 요소 연결(대상·조건 문장의 컬럼명·조회조건명·MSG·SP·팝업 이름). 화면 규칙·컬럼·조회조건·AS-IS·TRACE·EG·ES·차등 행 = 기준 항목 1개씩
    B3 코드  AS-IS 실측 연결: live_vs_static(SP) · cond_compare(조회조건 인자) · save_compare(저장 인자) · scenario_compare(시나리오 → 대조표 행)
             파싱과 실측이 다른 것(LIVE_ONLY · DIFF)은 '판단 대기'로 기준 목록에 남긴다
    B4 AI    TO-BE RULE 결합: 그 규칙(rule_id)에 걸린 등록 룰(tobe_rule_registry.csv)을 기준 항목에 붙인다(효과 = 기대값 변경 · 대상 아님 · 무관).
             기계 확인 = 등록 룰 번호 실존 + 인용 문장이 그 룰 원문에 있음
    B5 AI    다른 화면 결함 유형(GENERAL) · 확정 요구(CONFIRMED) · 이 화면 결함(DEFECT) 행 정리: 같은 확인인 기준 항목 · 이 화면 요소 · 화면 전체 · 대상 아님.
             '대상 아님' 기계 확인 = AI 가 낸 검색어가 AS-IS 화면 소스 · TO-BE 화면 폴더 · 요소 목록에 0건(있으면 '판단 대기')
    재사용   AI 묶음 입력이 같으면 호출하지 않는다(llm_call 캐시 · 키 = 내용. 행 ID 를 키에 넣지 않는다)
  산출   Doc/verify/<ID>/criteria/criteria.csv(기준 항목) · row_map.csv(원장 행 → 기준 항목) · live_link.csv · criteria.md · criteria.json
  쓰임   judge.py 가 판정 끝에 apply() 로 반영: 대상 아님(기계 확인) 행 = NA · 같은 확인 구성원 = 대표 결과 상속(미측정일 때만) · 룰 적용 = 근거 표시
  종료코드 0 · 2 인자 오류 · 3 원장 없음
"""
import argparse
import collections
import csv
import hashlib
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 8)

FAMILY = ('GENERAL', 'CONFIRMED', 'DEFECT')          # 다른 문서에서 온 행 — AI 가 이 화면 요소에 붙인다(B5)
SRC_RANK = {'COLUMN': 1, 'SEARCH': 1, 'RULE_SCREEN': 2, 'ASIS': 2, 'MSG': 2, 'SP': 2, 'ASIS_DIFF': 3, 'TRACE': 4, 'DEFECT': 5, 'CONFIRMED': 6, 'GENERAL': 7}
UNMEASURED = ('ERROR', 'NOT_RUN', '판정필요', '')
CRIT_COLS = ['crit_id', 'elem_key', 'elem_kind', 'rule_id', 'check', 'expected', 'src_asis', 'src_live', 'src_rule', 'status', 'basis', 'by', 'rep_row', 'rows', 'at']
MAP_COLS = ['row_id', 'source', 'rule_id', 'crit_id', 'role', 'elem_key', 'how', 'decision', 'basis']
BATCH_FAMILY = 24     # AI 묶음당 결함 유형 행 수
BATCH_ITEMS = 60      # AI 묶음에 싣는 같은 규칙 기준 항목 상한
STOP = {'SCP', 'SSP', 'DMF', 'SYS', 'THE', 'AND', 'ALL', 'YES', 'NO', 'ID', 'KO', 'EN', 'CN'}


def P(*a):
    return os.path.join(ROOT, *a)


def checklist_dir():
    """개선안 20261124012048_SELF_2(R83): CheckList 폴더 = harness.json paths.checklistDir 1곳(make_verify_docs·verify_if_stale 와 같은 값) · 없으면 Doc/UI_CHECKLIST"""
    try:
        with open(P('tools', 'Harness', 'harness.json'), encoding='utf-8-sig') as f:
            hp = (json.load(f) or {}).get('paths')
    except (OSError, ValueError):
        hp = None
    d = (hp.get('checklistDir') if isinstance(hp, dict) else None) or 'Doc/UI_CHECKLIST'
    return os.path.normpath(d if os.path.isabs(d) else os.path.join(ROOT, d))


def read_csv(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as f:
            return list(csv.DictReader(f))
    except OSError:
        return []


def write_csv(p, cols, rows):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    tmp = p + '.tmp'
    with open(tmp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols, extrasaction='ignore'); w.writeheader(); w.writerows(rows)
    os.replace(tmp, p)


def now():
    import datetime
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def h(*parts, n=10):
    return hashlib.sha1('|'.join(str(x) for x in parts).encode('utf-8')).hexdigest()[:n]


def norm(s):
    return re.sub(r'\s+', ' ', str(s or '')).strip()


def asis_id(mid):
    for r in read_csv(P('tools', 'Harness', 'rules', 'map_screen.csv')):
        if (r.get('tobe_id') or '').upper() == mid:
            return (r.get('asis_id') or mid).upper()
    return mid


# ───────────────────────── B1 요소 목록 ─────────────────────────
def elements(mid, rows):
    """{elem_key: {'kind', 'name', 'label', 'aliases': set, 'src'}}"""
    aid = asis_id(mid); E = {}
    sd = P('Doc', 'asisfacts', 'screens', aid)

    def put(key, kind, name, label='', src='', aliases=()):
        e = E.setdefault(key, {'kind': kind, 'name': name, 'label': label, 'aliases': set(), 'src': set()})
        if label and not e['label']:
            e['label'] = label
        e['aliases'].update(a for a in ([name, label] + list(aliases)) if a and len(a) >= 2)
        if src:
            e['src'].add(src)
    for c in read_csv(P('Doc', 'tobefacts', 'db', 'sheet_columns.csv')):
        if (c.get('program_id') or '').upper() == mid and c.get('valid_yn', 'Y') != 'N' and c.get('column_name'):
            put(f"COL:{c['column_name'].upper()}", 'COL', c['column_name'].upper(), (c.get('column_label_name') or '').strip(), 'TO-BE sheet_columns')
    for c in read_csv(os.path.join(sd, 'grid_columns_asis.csv')):
        if c.get('column'):
            put(f"COL:{c['column'].upper()}", 'COL', c['column'].upper(), (c.get('label') or '').strip(), 'AS-IS grid_columns_asis')
    for r in rows:   # 조회조건 = 원장 SEARCH 행(기준표 또는 AS-IS 조건 컨트롤에서 ledger.py 가 만든 것)
        m = re.match(r'^조회조건\s+(.+?)\*?$', norm(r.get('target')))
        if r.get('source') == 'SEARCH' and m:
            nm = m.group(1).strip().rstrip('*').strip()
            put(f'COND:{nm.upper()}', 'COND', nm, nm, 'ledger SEARCH')
    for c in read_csv(os.path.join(sd, 'controls.csv')):
        nm = c.get('name') or ''; ty = (c.get('type') or '').split('.')[-1]
        if re.match(r'^btn', nm, re.I):
            base = re.sub(r'^btn', '', nm, flags=re.I)
            put(f'BTN:{base.upper()}', 'BTN', base, base, f'AS-IS controls {nm}', aliases=(nm,))
        elif re.match(r'^(cbo|clb|txt|dte|chk|rdo|lup)', nm, re.I) and not ty.startswith('Layout'):
            base = re.sub(r'^(cbo|clb|txt|dte|chk|rdo|lup)', '', nm, flags=re.I)
            key = next((k for k, e in E.items() if e['kind'] == 'COND' and re.sub(r'\W', '', e['name']).upper() == base.upper()), f'COND:{base.upper()}')
            put(key, 'COND', E.get(key, {}).get('name') or base, '', f'AS-IS controls {nm}', aliases=(nm, base))
    for b in ('Search', 'Insert', 'Delete', 'Save', 'Excel', 'Reset'):   # TO-BE 공통 버튼(메뉴 버튼 메타)
        put(f'BTN:{b.upper()}', 'BTN', b, b, 'TO-BE 공통 버튼')
    for p in read_csv(P('Doc', 'tobefacts', 'db', 'proc_meta.csv')):
        if (p.get('menu_id') or '').upper() == mid and p.get('proc'):
            nm = (p.get('pkg') + '.' if p.get('pkg') else '') + p['proc']
            put(f"SP:{p['proc'].upper()}", 'SP', nm, '', f"TO-BE proc_meta 버튼 {p.get('btn') or ''}", aliases=(p['proc'],))   # 버튼 이름(INSERT 등)은 별칭에 넣지 않는다(버튼 행이 SP 로 연결되던 오류)
    for x in read_csv(P('Doc', 'verify', mid, 'asis_live', 'live_vs_static.csv')):
        if x.get('kind') == 'SP' and x.get('item') and x.get('verdict') != 'FRAMEWORK':
            put(f"SP:{x['item'].upper()}", 'SP', x['item'], '', 'AS-IS 실측 live_vs_static')
    for r in rows:
        t = norm(r.get('target')) + ' ' + norm(r.get('condition'))
        for m in re.finditer(r'\b(MSG\d{5})\b', t):
            put(f'MSG:{m.group(1)}', 'MSG', m.group(1), '', 'ledger')
        for m in re.finditer(r'\b([A-Z]{3}\d{4}_?\w*Popup\w*|[A-Z]{3}\d{4}_\w*POPUP\w*)\b', t):
            put(f'POPUP:{m.group(1).upper()}', 'POPUP', m.group(1), '', 'ledger')
    put('SCREEN', 'SCREEN', mid, '화면 전체', '화면')
    return E


# ───────────────────────── B2 행 → 요소 ─────────────────────────
def link_row(r, E, col_rx):
    """(elem_key, 방법) — 코드로 정할 수 있는 것만. 못 정하면 ('', '')"""
    t = norm(r.get('target')); c = norm(r.get('condition')); src = r.get('source') or ''
    m = re.match(r'^조회조건\s+(.+?)\*?$', t)
    if m:
        k = 'COND:' + m.group(1).strip().rstrip('*').strip().upper()
        if k in E:
            return k, '조회조건 이름'
    m = re.match(r'^[^.]{1,60}\.([A-Z][A-Z0-9_]+)\b', t)   # 시트.컬럼 (라벨)
    if m and f'COL:{m.group(1)}' in E:
        return f'COL:{m.group(1)}', '시트.컬럼'
    m = re.search(r'\b(MSG\d{5})\b', t)
    if m:
        return f'MSG:{m.group(1)}', 'MSG 번호'
    for k, e in E.items():
        if e['kind'] == 'SP' and any(re.search(r'(?<![A-Z0-9_])' + re.escape(a.upper()) + r'(?![A-Z0-9_])', t.upper()) for a in e['aliases'] if len(a) >= 6):
            return k, 'SP 이름'
    for k, e in E.items():
        if e['kind'] == 'POPUP' and e['name'].upper() in t.upper():
            return k, '팝업 이름'
    cols = sorted({x for x in col_rx.findall(t.upper())}) if src not in FAMILY else []
    if len(cols) == 1:
        return f'COL:{cols[0]}', '대상 문장의 컬럼명'
    if src not in FAMILY and re.match(r'^[A-Z]{3}\d{4}\s+(화면|.{0,40}전체)?$', t):
        return 'SCREEN', '화면 전체'
    return '', ''


# ───────────────────────── B3 AS-IS 실측 연결 ─────────────────────────
def live_links(mid, E):
    out = []
    lv = P('Doc', 'verify', mid, 'asis_live')
    for x in read_csv(os.path.join(lv, 'live_vs_static.csv')):
        k = f"SP:{(x.get('item') or '').upper()}"
        if x.get('verdict') == 'FRAMEWORK':
            continue
        out.append({'elem_key': k if k in E else '', 'kind': '실측-파싱 대조', 'item': x.get('item', ''), 'asis_static': x.get('static', ''), 'asis_live': x.get('live', ''),
                    'verdict': x.get('verdict', ''), 'status': '확정' if x.get('verdict') in ('MATCH',) else '판단 대기', 'src': f"Doc/verify/{mid}/asis_live/live_vs_static.csv"})
    lr = P('Doc', 'asislive', mid)
    colkey = {e['name'].upper(): k for k, e in E.items() if e['kind'] == 'COL'}
    condkey = {re.sub(r'\W', '', e['name']).upper(): k for k, e in E.items() if e['kind'] == 'COND'}
    for f, kind in (('cond_compare.csv', '조회 인자'), ('save_compare.csv', '저장 인자')):
        for x in read_csv(os.path.join(lr, f)):
            pn = re.sub(r'^(p_|i_|v_)', '', (x.get('param') or '').lower()).upper()
            k = colkey.get(pn) or condkey.get(re.sub(r'_?(ID|CODE|CD)$', '', pn).replace('_', '')) or condkey.get(pn.replace('_', '')) or ''
            v = x.get('verdict') or ''
            out.append({'elem_key': k, 'kind': kind, 'item': f"{x.get('asis_sp', '')}.{x.get('param', '')}", 'asis_static': '', 'asis_live': (x.get('asis') or '')[:200], 'tobe': (x.get('tobe') or '')[:200],
                        'verdict': v, 'status': '확정' if v in ('SAME', 'ALL_SAME') else '판단 대기', 'src': f'Doc/asislive/{mid}/{f}'})
    return out


# ───────────────────────── B4·B5 AI ─────────────────────────
PROMPT = """너는 NSCM 전환 프로젝트(AS-IS C# WinForms → TO-BE React + Spring Boot + Oracle) 화면 {mid} 의 검증 기준을 정리하는 사람이다.
검증 원장은 여러 출처에서 행을 모은다. 이 묶음은 규칙 {rules} 의 행이다. 할 일은 둘이다. 파일을 고치지 않는다(Read·Glob·Grep 만). 답은 마지막에 JSON 하나만 낸다.

## 화면 원천(저장소 루트 기준 경로)
- AS-IS 화면 소스: {asis_files}
- AS-IS 사실 추출본: Doc/asisfacts/screens/{asis_id}/
- TO-BE 화면 폴더: {page_dir}
- TO-BE 룰 원장: tools/Harness/rules/tobe_rule_registry.csv

## 이 화면 요소 목록(elem_key = 화면 요소 키)
{elements}

## 이 규칙의 기준 항목(검사엔진이 화면 요소마다 만든 확인 · crit_id 로 가리킨다)
{items}

## 할 일 1. 다른 문서에서 온 행 정리(family)
아래 행은 다른 화면 결함 유형(GENERAL) · 확정 요구(CONFIRMED) · 이 화면 결함(DEFECT) 에서 왔다. 행마다 하나를 고른다.
- same: 위 기준 항목 중 같은 요소를 같은 방법으로 확인하고 기대도 같은 항목이 있다 → crit_id 를 적는다.
- element: 이 화면의 요소 하나를 확인하는 행인데 같은 기준 항목이 없다 → elem_key 를 위 요소 목록에서 고른다.
- screen: 화면 전체에 걸린 확인이다(특정 요소가 아님).
- absent: 이 화면에 그 기능·요소가 없다. search_terms 에 그 기능을 찾을 검색어(영문 식별자·화면 문구 2~4개)를 적는다. 기계가 AS-IS 소스·TO-BE 화면 폴더에서 검색해 0건일 때만 대상 아님이 된다.
확신이 없으면 screen 으로 둔다. 근거를 지어내지 않는다.

{family}

## 할 일 2. TO-BE 룰 결합(rules)
아래 등록 룰마다, 위 기준 항목 중 이 룰이 적용되는 항목과 효과를 고른다.
- effect = expected(기대값이 룰 문장대로 바뀜 · new_expected 에 바뀐 기대) · not_applicable(이 룰 때문에 그 항목은 확인 대상이 아님) · none(이 화면 항목과 무관).
- quote 에 룰 원문(requirement) 중 근거 문장을 글자 그대로 적는다(기계가 대조한다).

{rules_block}

## 출력 — JSON 하나만(설명·코드펜스 없이)
{{"family":[{{"key":"…","decision":"same|element|screen|absent","crit_id":"…","elem_key":"…","search_terms":["…"],"reason":"한 문장"}}],
 "rules":[{{"rule_ref":"등록 룰 번호","effect":"expected|not_applicable|none","crit_ids":["…"],"new_expected":"…","quote":"…","reason":"한 문장"}}]}}
reason 은 업무 담당자가 읽는 한국어 한 문장(수식어·추측 어미 없이, 컬럼명·버튼명을 적는다)."""


def registry():
    return read_csv(P('tools', 'Harness', 'rules', 'tobe_rule_registry.csv'))


def rules_for(rule_id, mid, reg):
    out = []
    for x in reg:
        sc = (x.get('scope') or '').upper()
        if sc not in ('ALL', '') and mid not in sc:
            continue
        if (x.get('status') or '').upper() in ('RETIRED', '폐기'):
            continue
        if rule_id in re.split(r'[;,\s]+', x.get('detect_rules') or ''):
            out.append(x)
    return out


def ctx_of(mid):
    import llm_review
    c = llm_review.screen_ctx(mid)
    return c


def elem_lines(E):
    L = []
    for k in sorted(E):
        e = E[k]
        L.append(f"- {k}" + (f" ({e['label']})" if e['label'] and e['label'].upper() != e['name'].upper() else ''))
    return '\n'.join(L)


def build_batches(mid, items, fam_rows, reg):
    """규칙별 묶음 [{rules:[rid..], items:[crit..], family:[row..], reg:[rule..]}] — 결함 유형 행이나 등록 룰이 있는 규칙만"""
    by_rule = collections.defaultdict(lambda: {'items': [], 'family': [], 'reg': []})
    for it in items:
        by_rule[it['rule_id']]['items'].append(it)
    for r in fam_rows:
        by_rule[r.get('rule_id') or '']['family'].append(r)
    for rid in list(by_rule):
        by_rule[rid]['reg'] = rules_for(rid, mid, reg) if rid else []
    out, cur = [], None
    for rid in sorted(by_rule):
        g = by_rule[rid]
        if not g['family'] and not (g['reg'] and g['items']):
            continue
        fam = sorted(g['family'], key=lambda r: fam_key(r))
        for i in range(0, max(1, len(fam)), BATCH_FAMILY):
            part = fam[i:i + BATCH_FAMILY]
            b = {'rules': [rid], 'items': sorted(g['items'], key=lambda x: x['crit_id'])[:BATCH_ITEMS], 'family': part, 'reg': g['reg'] if i == 0 else []}
            # 작은 규칙은 앞 묶음에 합친다(호출 수 줄이기) — 합친 크기 상한 안에서
            if cur and len(cur['family']) + len(part) <= BATCH_FAMILY and len(cur['items']) + len(b['items']) <= BATCH_ITEMS and len(cur['rules']) < 6:
                cur['rules'].append(rid); cur['items'] += b['items']; cur['family'] += part; cur['reg'] += b['reg']
            else:
                cur = b; out.append(cur)
    return out


def fam_key(r):
    """결함 유형 행의 내용 키(행 ID 는 원장 생성마다 바뀔 수 있어 쓰지 않는다)"""
    return 'F' + h(r.get('source'), r.get('rule_id'), norm(r.get('target')), norm(r.get('expected'))[:300], norm(r.get('defect_ref')))


def prompt_of(mid, ctx, E, b):
    fam = [{'key': fam_key(r), 'source': r.get('source'), 'rule_id': r.get('rule_id'), 'target': norm(r.get('target'))[:220],
            'expected': norm(r.get('expected'))[:300], 'defect_ref': r.get('defect_ref', '')} for r in b['family']]
    items = [{'crit_id': x['crit_id'], 'elem_key': x['elem_key'], 'rule_id': x['rule_id'], 'check': x['check'][:160], 'expected': x['expected'][:200]} for x in b['items']]
    regs = [{'rule_ref': x.get('rule_id'), 'kind': x.get('kind'), 'title': (x.get('title') or '')[:80], 'requirement': (x.get('requirement') or '')[:500]} for x in b['reg']]
    return PROMPT.format(mid=mid, rules=','.join(b['rules']), asis_files=' · '.join(ctx['asis_files']) or '(files.csv 없음)', asis_id=ctx['asis_id'],
                         page_dir=ctx['page_dir'] or '(없음)', elements=elem_lines(E),
                         items=json.dumps(items, ensure_ascii=False, indent=0) if items else '(없음)',
                         family=('행(JSON):\n' + json.dumps(fam, ensure_ascii=False, indent=0)) if fam else '(이 묶음에는 정리할 행 없음 — family 는 빈 배열)',
                         rules_block=('등록 룰(JSON):\n' + json.dumps(regs, ensure_ascii=False, indent=0)) if regs else '(이 묶음에는 등록 룰 없음 — rules 는 빈 배열)')


def search_absent(terms, ctx, E):
    """AI 가 낸 검색어가 AS-IS 화면 소스 · TO-BE 화면 폴더 · 요소 목록에 0건인지 — (확인됨, 사유)"""
    terms = [t.strip() for t in (terms or []) if isinstance(t, str) and len(t.strip()) >= 3 and t.strip().upper() not in STOP][:6]
    if not terms:
        return False, '검색어 없음'
    files = []
    for f in ctx.get('asis_files') or []:
        files.append(P(*f.split(' (')[0].split('/')))
    pd = ctx.get('page_dir') or ''
    if pd and os.path.isdir(P(*pd.split('/'))):
        for dp, _, fs in os.walk(P(*pd.split('/'))):
            files += [os.path.join(dp, x) for x in fs if x.endswith(('.ts', '.tsx', '.json', '.md'))]
    hits = collections.Counter()
    names = ' '.join(f"{k} {e['label']} {' '.join(e['aliases'])}" for k, e in E.items()).lower()
    for t in terms:
        if t.lower() in names:
            hits[t] += 1
    for f in files:
        try:
            s = open(f, encoding='utf-8', errors='replace').read().lower()
        except OSError:
            continue
        for t in terms:
            if t.lower() in s:
                hits[t] += 1
    if not files:
        return False, '검색할 화면 소스 없음'
    if hits:
        return False, '검색어가 화면에 있음: ' + ', '.join(f'{k} {v}곳' for k, v in hits.most_common(4))
    return True, f"검색어 {', '.join(terms)}: AS-IS 화면 소스·TO-BE 화면 폴더 {len(files)}개 파일·요소 목록 0건"


def rule_quote_ok(reg_by, ref, quote):
    x = reg_by.get(str(ref or '').strip().upper())
    if not x:
        return False, '등록 룰 없음'
    q = re.sub(r'\s+', '', str(quote or ''))
    src = re.sub(r'\s+', '', (x.get('requirement') or '') + (x.get('title') or ''))
    if len(q) < 6:
        return False, '인용 짧음'
    return (q in src), ('인용 확인' if q in src else '인용이 룰 원문에 없음')


# ───────────────────────── 실행 ─────────────────────────
def build(mid, ledger=None, ai=True, dry=False, from_file=None):
    lp = ledger or P('Doc', 'verify', mid, 'verify_ledger.csv')
    rows = read_csv(lp)
    if not rows:
        print(f'[ERROR] 원장 없음: {lp}'); return 3
    E = elements(mid, rows)
    cols = sorted({e['name'] for e in E.values() if e['kind'] == 'COL' and len(e['name']) >= 4}, key=len, reverse=True)
    col_rx = re.compile(r'(?<![A-Z0-9_])(' + '|'.join(re.escape(c) for c in cols) + r')(?![A-Z0-9_])') if cols else re.compile(r'(?!x)x')
    items, rmap, fam_rows = [], [], []
    for r in rows:
        src = r.get('source') or ''
        if src in FAMILY:
            fam_rows.append(r); continue
        k, how = link_row(r, E, col_rx)
        ek = k or 'SCREEN'
        cid = 'C-' + h(mid, ek, r.get('rule_id'), src, norm(r.get('target')), norm(r.get('condition'))[:300], norm(r.get('expected'))[:300])
        items.append({'crit_id': cid, 'elem_key': ek, 'elem_kind': E.get(ek, {}).get('kind', 'SCREEN'), 'rule_id': r.get('rule_id', ''), 'check': norm(r.get('target'))[:300],
                      'expected': norm(r.get('expected'))[:500], 'src_asis': norm(r.get('asis_ref'))[:300], 'src_live': '', 'src_rule': '', 'status': '확정', 'basis': '검사엔진 행' + (f' · 요소 연결 {how}' if how else ' · 요소 연결 없음(화면 전체로 둠)'),
                      'by': '코드', 'rep_row': r['row_id'], 'rows': r['row_id'], 'at': now()})
        rmap.append({'row_id': r['row_id'], 'source': src, 'rule_id': r.get('rule_id', ''), 'crit_id': cid, 'role': '대표', 'elem_key': ek, 'how': how or '연결 없음', 'decision': 'element', 'basis': ''})
    lk = live_links(mid, E)
    live_by = collections.defaultdict(list)
    for x in lk:
        if x['elem_key']:
            live_by[x['elem_key']].append(f"{x['kind']} {x['item']} {x['verdict']}")
    for it in items:
        if it['elem_key'] in live_by:
            it['src_live'] = ' · '.join(live_by[it['elem_key']][:4])[:300]
    reg = registry(); reg_by = {(x.get('rule_id') or '').upper(): x for x in reg}
    batches = build_batches(mid, items, fam_rows, reg)
    ctx = ctx_of(mid)
    print(f"[기준 정리 {mid}] 원장 {len(rows)}행 · 요소 {len(E)}개(" + ' · '.join(f'{k} {v}' for k, v in sorted(collections.Counter(e['kind'] for e in E.values()).items())) + ')'
          + f" · 검사엔진 행 {len(items)}(요소 연결 {sum(1 for x in rmap if x['how'] != '연결 없음')}) · 결함 유형 행 {len(fam_rows)} · 실측 연결 {sum(1 for x in lk if x['elem_key'])}/{len(lk)} · AI 묶음 {len(batches)}개", flush=True)
    if dry:
        for i, b in enumerate(batches, 1):
            print(f"  묶음 {i}: 규칙 {','.join(b['rules'])} · 결함 유형 {len(b['family'])}행 · 기준 항목 {len(b['items'])} · 등록 룰 {len(b['reg'])} · 프롬프트 {len(prompt_of(mid, ctx, E, b))}자")
        return 0
    fam_dec = {}; rule_dec = []; meta = {'calls': 0, 'cached': 0, 'failed': 0, 'cost': 0.0, 'nochange': 0}
    if ai and batches:
        import llm_call
        from_data = llm_call.parse_json(open(from_file, encoding='utf-8-sig').read()) if from_file else None
        import concurrent.futures as cf
        par = max(1, int(llm_call.cfg().get('llmReviewPar') or 4))

        def one(ib):
            i, b = ib
            if from_data is not None:
                return i, b, {'ok': True, 'data': from_data, 'cached': False, 'cost': 0}
            n = len(b['family']) + len(b['items'])
            res = llm_call.ask(mid, 'criteria', prompt_of(mid, ctx, E, b), rows=n)
            print(f"  · 기준 정리 묶음 {i}/{len(batches)} 규칙 {','.join(b['rules'])}{' · 기억' if res.get('cached') else ''}{'' if res.get('ok') else ' · 실패 ' + str(res.get('why'))[:60]}", flush=True)
            return i, b, res
        with cf.ThreadPoolExecutor(max_workers=par if from_data is None else 1) as ex:
            answers = list(ex.map(one, list(enumerate(batches, 1))))
        for i, b, res in answers:
            if not res.get('ok'):
                meta['failed'] += 1; continue
            meta['cached' if res.get('cached') else 'calls'] += 1; meta['cost'] += float(res.get('cost') or 0)
            d = res.get('data') or {}
            keys = {fam_key(r) for r in b['family']}
            got = 0
            for x in d.get('family') or []:
                if isinstance(x, dict) and x.get('key') in keys:
                    fam_dec[x['key']] = x; got += 1
            for x in d.get('rules') or []:
                if isinstance(x, dict):
                    rule_dec.append(dict(x, _items={it['crit_id'] for it in b['items']})); got += 1 if x.get('effect') in ('expected', 'not_applicable') else 0
            if not got and not res.get('cached'):
                meta['nochange'] += 1
    # 결함 유형 행 반영
    item_by = {x['crit_id']: x for x in items}
    n_same = n_elem = n_absent = n_wait = n_screen = 0
    for r in fam_rows:
        d = fam_dec.get(fam_key(r)) or {}
        dec = d.get('decision') or ''
        basis = norm(d.get('reason'))[:300]
        if dec == 'same' and d.get('crit_id') in item_by and item_by[d['crit_id']]['rule_id'] == r.get('rule_id'):
            it = item_by[d['crit_id']]; it['rows'] += ';' + r['row_id']; n_same += 1
            rmap.append({'row_id': r['row_id'], 'source': r.get('source'), 'rule_id': r.get('rule_id'), 'crit_id': it['crit_id'], 'role': '구성원', 'elem_key': it['elem_key'], 'how': 'AI 같은 확인', 'decision': 'same', 'basis': basis})
            continue
        ek, status, by = 'SCREEN', '확정', 'AI' if dec else '코드'
        if dec == 'element' and d.get('elem_key') in E:
            ek = d['elem_key']; n_elem += 1
        elif dec == 'absent':
            ok, why = search_absent(d.get('search_terms'), ctx, E)
            status = '대상 아님' if ok else '판단 대기'; basis = (basis + ' · ' + why)[:400]
            n_absent += ok; n_wait += (not ok)
        elif dec == 'screen':
            n_screen += 1
        elif not dec:
            status = '판단 대기' if ai else '확정'; basis = '기준 정리 답 없음(AI 꺼짐 또는 실패) — 화면 전체로 둠'
        cid = 'C-' + h(mid, r.get('rule_id'), fam_key(r))   # 내용만으로(AI 결정·요소가 바뀌어도 같은 번호 — 사용자의견 고정용)
        it = {'crit_id': cid, 'elem_key': ek, 'elem_kind': E.get(ek, {}).get('kind', 'SCREEN'), 'rule_id': r.get('rule_id', ''), 'check': norm(r.get('target'))[:300], 'expected': norm(r.get('expected'))[:500],
              'src_asis': norm(r.get('asis_ref'))[:300], 'src_live': ' · '.join(live_by.get(ek, [])[:4])[:300], 'src_rule': '', 'status': status, 'basis': basis or f"{r.get('source')} 행", 'by': by,
              'rep_row': r['row_id'], 'rows': r['row_id'], 'at': now()}
        items.append(it); item_by[cid] = it
        rmap.append({'row_id': r['row_id'], 'source': r.get('source'), 'rule_id': r.get('rule_id'), 'crit_id': cid, 'role': '대표', 'elem_key': ek, 'how': 'AI ' + (dec or '답 없음'), 'decision': dec or '', 'basis': basis})
    # 등록 룰 반영(기계 확인된 것만)
    n_rule = n_rule_bad = 0
    for x in rule_dec:
        eff = x.get('effect')
        if eff not in ('expected', 'not_applicable'):
            continue
        ok, why = rule_quote_ok(reg_by, x.get('rule_ref'), x.get('quote'))
        if not ok:
            n_rule_bad += 1; continue
        for cid in x.get('crit_ids') or []:
            it = item_by.get(cid)
            if not it or cid not in x['_items']:
                continue
            ref = str(x.get('rule_ref')).upper()
            it['src_rule'] = (it['src_rule'] + ';' if it['src_rule'] else '') + ref
            if eff == 'not_applicable':
                it['status'] = '대상 아님'; it['basis'] = (f"TO-BE 룰 {ref}: {norm(x.get('quote'))[:160]} · {norm(x.get('reason'))[:160]}")[:400]; it['by'] = 'AI+룰'
            else:
                it['expected'] = (norm(x.get('new_expected')) or it['expected'])[:500]; it['basis'] = (it['basis'] + f" · 기대값 TO-BE 룰 {ref}")[:400]; it['by'] = 'AI+룰'
            n_rule += 1
    # 사용자의견 고정(CheckList '기준' 시트 · AI 보다 우선)
    uo = user_overrides(mid)
    n_user = 0
    for it in items:
        u = uo.get(it['crit_id'])
        if u and u.get('status'):
            it['status'] = u['status']; it['basis'] = (f"사용자의견 {u.get('at', '')}: {u.get('opinion', '')}")[:400]; it['by'] = '사용자'; n_user += 1
    # 판단 대기 = 실측·파싱 차이
    wait_live = [x for x in lk if x['status'] == '판단 대기']
    # 기록
    od = P('Doc', 'verify', mid, 'criteria')
    write_csv(os.path.join(od, 'criteria.csv'), CRIT_COLS, sorted(items, key=lambda x: (x['elem_key'], x['rule_id'], x['crit_id'])))
    write_csv(os.path.join(od, 'row_map.csv'), MAP_COLS, rmap)
    write_csv(os.path.join(od, 'live_link.csv'), ['elem_key', 'kind', 'item', 'asis_static', 'asis_live', 'tobe', 'verdict', 'status', 'src'], lk)
    st = collections.Counter(x['status'] for x in items)
    j = {'menu_id': mid, 'at': now(), 'ledger': os.path.relpath(lp, ROOT).replace(os.sep, '/'), 'ledger_rows': len(rows), 'elements': len(E), 'items': len(items), 'status': dict(st),
         'family_rows': len(fam_rows), 'family': {'same': n_same, 'element': n_elem, 'screen': n_screen, 'absent_confirmed': n_absent, 'absent_wait': n_wait},
         'rules_applied': n_rule, 'rules_quote_fail': n_rule_bad, 'user_fixed': n_user, 'live_links': len(lk), 'live_wait': len(wait_live), 'ai': meta, 'batches': len(batches)}
    json.dump(j, open(os.path.join(od, 'criteria.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    esc = lambda s: str(s or '').replace('|', '/').replace('\n', ' ')
    L = [f'# {mid} 기준 원장 ({j["at"]})', '',
         f"- 원장 {len(rows)}행 → 기준 항목 {len(items)}개 · 요소 {len(E)}개 · 상태 " + ' · '.join(f'{k} {v}' for k, v in st.items()),
         f"- 다른 문서 행 {len(fam_rows)}행: 같은 확인으로 합침 {n_same} · 요소 지정 {n_elem} · 화면 전체 {n_screen} · 대상 아님(검색 0건 확인) {n_absent} · 판단 대기 {n_wait}",
         f"- TO-BE 룰 결합 {n_rule}건(인용 불일치로 버림 {n_rule_bad}) · AS-IS 실측 연결 {len(lk)}건(판단 대기 {len(wait_live)}) · 사용자의견 고정 {n_user}건",
         f"- AI 호출 {meta['calls']}(기억 {meta['cached']} · 실패 {meta['failed']} · 바꾼 것 없는 호출 {meta['nochange']}) · 비용 출처 Doc/verify/{mid}/llm_usage.csv", '',
         '## 판단 대기(사용자 확인)', '', '| 기준 항목 | 요소 | 규칙 | 확인 | 사유 |', '|---|---|---|---|---|']
    for x in items:
        if x['status'] == '판단 대기':
            L.append(f"| {x['crit_id']} | {x['elem_key']} | {x['rule_id']} | {esc(x['check'])[:120]} | {esc(x['basis'])[:200]} |")
    for x in wait_live:
        L.append(f"| 실측 | {x['elem_key'] or '(요소 없음)'} | - | {esc(x['kind'])} {esc(x['item'])} | AS-IS {esc(x['asis_live'])[:60]} · TO-BE {esc(x.get('tobe', ''))[:60]} · {x['verdict']} |")
    L += ['', '## 대상 아님', '', '| 기준 항목 | 규칙 | 확인 | 근거 |', '|---|---|---|---|']
    for x in items:
        if x['status'] == '대상 아님':
            L.append(f"| {x['crit_id']} | {x['rule_id']} | {esc(x['check'])[:120]} | {esc(x['basis'])[:240]} |")
    open(os.path.join(od, 'criteria.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    if ai and not from_file:
        try:
            import llm_call
            w_ = llm_call.log_effect(mid, 'criteria', calls=meta['calls'], cached=meta['cached'], applied=n_same + n_elem + n_absent + n_rule, nochange_calls=meta['nochange'], note=f'판단 대기 {st.get("판단 대기", 0)}')
            if w_:
                print(w_, flush=True)
        except Exception:
            pass
    print(f"[기준 정리 {mid}] 기준 항목 {len(items)} · " + ' · '.join(f'{k} {v}' for k, v in st.items()) + f" · 합침 {n_same} · 대상 아님 {n_absent} · 판단 대기 {n_wait + len(wait_live)} · 룰 결합 {n_rule} · AI 호출 {meta['calls']}(기억 {meta['cached']} · 실패 {meta['failed']})", flush=True)
    print(f'@@LINK 📐 기준 원장|Doc/verify/{mid}/criteria/criteria.md', flush=True)
    return 0


USER_NA = re.compile(r'대상\s*아님|TO-?BE\s*RULE|오류\s*아님|해당\s*없음', re.I)
USER_OK = re.compile(r'^\s*(확정|맞음|OK)\b', re.I)


def user_overrides(mid):
    """{crit_id: {'status','opinion','at','file'}} — 최신 CheckList 판들의 '기준' 시트 사용자의견을 Doc/verify/<ID>/criteria/criteria_user.csv 에 모아 둔다(뒤 판이 앞 판을 덮음)"""
    od = P('Doc', 'verify', mid, 'criteria'); up = os.path.join(od, 'criteria_user.csv')
    have = {x['crit_id']: x for x in read_csv(up)}
    import glob
    cl = checklist_dir()
    files = sorted({f for pat in (os.path.join(cl, f'{mid}_*_CheckList_v*.xlsx'), os.path.join(cl, 'old', f'{mid}_*_CheckList_v*.xlsx'))
                    for f in glob.glob(pat) if not os.path.basename(f).startswith('~$')}, key=os.path.getmtime)
    seen = {x.get('file') for x in have.values()}
    changed = False
    for f in files:
        rel = os.path.relpath(f, ROOT).replace(os.sep, '/')
        try:
            import openpyxl
            wb = openpyxl.load_workbook(f, read_only=True, data_only=True)
        except Exception:
            continue
        if '기준' not in wb.sheetnames:
            continue
        rs = list(wb['기준'].iter_rows(values_only=True))
        if not rs:
            continue
        hd = [str(c or '') for c in rs[0]]
        if '기준 항목' not in hd or '사용자의견' not in hd:
            continue
        ic, io = hd.index('기준 항목'), hd.index('사용자의견')
        for r in rs[1:]:
            if not r or io >= len(r) or not r[io] or not str(r[io]).strip():
                continue
            o = str(r[io]).strip(); cid = str(r[ic] or '').strip()
            st = '대상 아님' if USER_NA.search(o) else ('확정' if USER_OK.search(o) else '')
            have[cid] = {'crit_id': cid, 'status': st, 'opinion': o[:300], 'at': now(), 'file': rel}; changed = True
    if changed:
        write_csv(up, ['crit_id', 'status', 'opinion', 'at', 'file'], list(have.values()))
    return have


# ───────────────────────── judge 반영 ─────────────────────────
def load_map(mid):
    od = P('Doc', 'verify', mid, 'criteria')
    crit = {x['crit_id']: x for x in read_csv(os.path.join(od, 'criteria.csv'))}
    rm = read_csv(os.path.join(od, 'row_map.csv'))
    return crit, rm


def apply(mid, rows):
    """판정 끝에 기준 원장 반영(제자리 수정) → {'na': n, 'inherit': n}
       ① 기준 항목 상태 '대상 아님'(검색 0건 또는 TO-BE 룰 인용 확인) + 행 결과 미측정·판정필요 → NA(근거 표시 · applicable N)
       ② 같은 확인 구성원(AI same) + 미측정 → 대표 행 결과 상속(대표가 측정됐을 때만)"""
    crit, rm = load_map(mid)
    if not crit:
        return {'na': 0, 'inherit': 0}
    by = {r['row_id']: r for r in rows}; n_na = n_inh = 0
    for m in rm:
        r = by.get(m['row_id']); c = crit.get(m['crit_id'])
        if not r or not c:
            continue
        ev = r.get('evidence') or ''
        if ev.startswith('[기준 정리]'):   # 지난 반영은 다시 계산
            r['result'] = 'NOT_RUN'; r['evidence'] = ''; ev = ''
        if (r.get('evidence') or '').startswith(('[사용자판정]', '[정적 판정] [사용자 확정')) or (r.get('tobe_ref') or '').startswith('수동 '):
            continue
        if c['status'] == '대상 아님' and (r.get('result') or '') in UNMEASURED:
            r['result'] = 'NA'; r['evidence'] = (f"[기준 정리] 대상 아님 — {c['basis']} (Doc/verify/{mid}/criteria/criteria.csv#{c['crit_id']})")[:1500]
            r['tobe_ref'] = '기준 정리(대상 아님)'
            if 'applicable' in r:
                r['applicable'] = 'N'; r['applicable_why'] = c['basis'][:200]
            n_na += 1
        if m.get('decision') in ('element', 'same') and (r.get('applicable') or '') in ('', 'UNKNOWN') and 'applicable' in r:
            r['applicable'] = 'Y'; r['applicable_why'] = f"기준 원장: 이 화면 요소 {m.get('elem_key', '')}"[:200]   # 다른 문서 행이 이 화면 요소에 연결됨(대상불명 아님)
        if c['status'] != '대상 아님' and m['role'] == '구성원' and (r.get('result') or '') in UNMEASURED:
            rep = by.get(c['rep_row'])
            if rep and rep.get('result') in ('PASS', 'FAIL', 'NA') and not (rep.get('evidence') or '').startswith('[기준 정리]'):
                r['result'] = rep['result']; r['evidence'] = (f"[기준 정리] 같은 확인 — 대표 {rep['row_id']} 결과 상속({m['basis'][:120]}): " + (rep.get('evidence') or '')[:600])[:1500]
                r['tobe_ref'] = f"기준 정리(대표 {rep['row_id']})"; n_inh += 1
    return {'na': n_na, 'inherit': n_inh}


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print(('  [OK] ' if c else '  [FAIL] ') + n); ok = ok and bool(c)
    E = {'COL:LOT_SIZE': {'kind': 'COL', 'name': 'LOT_SIZE', 'label': 'Lot Size', 'aliases': {'LOT_SIZE', 'Lot Size'}, 'src': set()},
         'COND:DIVISION': {'kind': 'COND', 'name': 'Division', 'label': 'Division', 'aliases': {'Division'}, 'src': set()},
         'SP:P_X_GET_LIST': {'kind': 'SP', 'name': 'PKG_X.P_X_GET_LIST', 'label': '', 'aliases': {'P_X_GET_LIST'}, 'src': set()},
         'SCREEN': {'kind': 'SCREEN', 'name': 'X', 'label': '', 'aliases': set(), 'src': set()}}
    rx = re.compile(r'(?<![A-Z0-9_])(LOT_SIZE)(?![A-Z0-9_])')
    chk('연결 — 시트.컬럼', link_row({'target': 'Main.LOT_SIZE (Lot Size)', 'source': 'COLUMN'}, E, rx)[0] == 'COL:LOT_SIZE')
    chk('연결 — 조회조건', link_row({'target': '조회조건 Division*', 'source': 'SEARCH'}, E, rx)[0] == 'COND:DIVISION')
    chk('연결 — SP', link_row({'target': 'PKG_X.P_X_GET_LIST', 'source': 'SP'}, E, rx)[0] == 'SP:P_X_GET_LIST')
    chk('연결 — 결함 유형 행은 코드로 컬럼 연결 안 함', link_row({'target': '[DMF0021 결함 유형] LOT_SIZE 편집', 'source': 'GENERAL'}, E, rx)[0] == '')
    k1 = fam_key({'source': 'GENERAL', 'rule_id': 'A1', 'target': 'x  y', 'expected': 'z'}); k2 = fam_key({'source': 'GENERAL', 'rule_id': 'A1', 'target': 'x y', 'expected': 'z', 'row_id': 'V-다름'})
    chk('내용 키 — 행 ID·공백과 무관', k1 == k2)
    reg_by = {'CR-' + '0' * 2 + '1': {'requirement': '모든 그리드 필터 후보는 전체 고유값을 표시한다', 'title': ''}}
    chk('룰 인용 — 원문 일부', rule_quote_ok(reg_by, 'CR-' + '0' * 2 + '1', '전체 고유값을 표시한다')[0])
    chk('룰 인용 — 원문 아님', not rule_quote_ok(reg_by, 'CR-' + '0' * 2 + '1', '전혀 다른 문장입니다')[0])
    chk('룰 인용 — 없는 번호', not rule_quote_ok(reg_by, 'CR-' + '9' * 3, '전체 고유값을 표시한다')[0])
    me = os.path.relpath(os.path.abspath(__file__), ROOT).replace(os.sep, '/')
    ctx = {'asis_files': [me + ' (1줄)'], 'page_dir': ''}
    chk('대상 아님 — 검색어가 소스에 있으면 판단 대기', not search_absent(['search_absent'], ctx, E)[0])
    chk('대상 아님 — 0건이면 확인', search_absent([''.join(['zq', 'xw', 'vu', 'NOT', 'HERE'])], ctx, E)[0])
    chk('대상 아님 — 요소 목록에 있으면 판단 대기', not search_absent(['Lot Size'], ctx, E)[0])
    rows = [{'row_id': 'V-1', 'result': 'PASS', 'evidence': '측정 일치'}, {'row_id': 'V-2', 'result': 'ERROR', 'evidence': '측정 못 함'}, {'row_id': 'V-3', 'result': 'ERROR', 'evidence': 'x', 'applicable': ''}]
    global load_map
    old = load_map
    load_map = lambda mid: ({'C-a': {'crit_id': 'C-a', 'status': '확정', 'rep_row': 'V-1', 'basis': ''}, 'C-b': {'crit_id': 'C-b', 'status': '대상 아님', 'rep_row': 'V-3', 'basis': '검색어 0건'}},
                            [{'row_id': 'V-1', 'crit_id': 'C-a', 'role': '대표', 'basis': ''}, {'row_id': 'V-2', 'crit_id': 'C-a', 'role': '구성원', 'basis': '같은 확인'}, {'row_id': 'V-3', 'crit_id': 'C-b', 'role': '대표', 'basis': ''}])
    try:
        n = apply('X', rows)
        chk('반영 — 구성원 상속 1 · 대상 아님 NA 1', n == {'na': 1, 'inherit': 1} and rows[1]['result'] == 'PASS' and rows[2]['result'] == 'NA' and rows[2]['applicable'] == 'N')
        rows[0]['result'] = 'ERROR'; n = apply('X', rows)
        chk('반영 — 대표가 미측정이면 지난 상속을 지움', rows[1]['result'] == 'NOT_RUN')
    finally:
        load_map = old
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        return selftest()
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id'); ap.add_argument('--ledger'); ap.add_argument('--no-ai', action='store_true'); ap.add_argument('--dry', action='store_true'); ap.add_argument('--from', dest='from_file')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    ai = not a.no_ai
    if ai and not (a.dry or a.from_file):
        try:
            import llm_call
            if not llm_call.enabled('criteria'):
                print('[기준 정리] AI 꺼짐(harness.json llmReviewKinds 에 criteria 없음) — 코드 단계만'); ai = False
        except Exception:
            ai = False
    return build(mid, ledger=a.ledger, ai=ai, dry=a.dry, from_file=a.from_file)


if __name__ == '__main__':
    sys.exit(main())
