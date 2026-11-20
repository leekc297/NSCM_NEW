# -*- coding: utf-8 -*-
"""AI 판정 검토 — 검사엔진이 FAIL·판정필요·미검증으로 남긴 행을 Claude 가 원문과 대조해 가린다 (2026-11-19 사용자 지시)
   "CheckList 의 각각의 검사엔진으로 판단을 할 때에도 클로드코드를 사용하고 판단을 받으면 품질이 높아질 것"
   사용자 결정(11-19): 근거 확인되면 판정 반영 · 대상 = FAIL·판정필요·미검증 · 오판은 체인 '검증 보완' 단계가 엔진까지 수정

  python tools/Harness/verify/llm_review.py <MENU_ID>                 판정 검토(원장 → llm_review.csv·md·json)
  python tools/Harness/verify/llm_review.py <MENU_ID> --dry           대상·묶음·프롬프트 크기만 출력(Claude 호출 없음)
  python tools/Harness/verify/llm_review.py <MENU_ID> --from <json>   Claude 호출 없이 답 JSON 파일을 반영(배관 시험)
  python tools/Harness/verify/llm_review.py <MENU_ID> --precision     사용자 판정과 대조(Doc/verify/_llm_review_precision.csv · Claude 호출 없음)
  python tools/Harness/verify/llm_review.py --selftest

  하는 일
    1) 원장(Doc/verify/<ID>/verify_ledger.csv) 에서 대상 행을 고른다: 결과 FAIL·판정필요·ERROR.
       검토하지 않는 행(목록에는 '검토 제외'와 사유로 남긴다): 사용자가 판정한 행 · 집계·상속 행(하위 행을 검토) · 스냅샷 승인 대기 · 시험 계정 필요.
       지난 실행에서 AI 검토가 반영된 행은 반영 전 기계 판정(llm_review_base.json)으로 되돌려 다시 본다.
    2) 규칙별로 묶어 Claude 를 부른다(llm_call.ask · 읽기 전용 · 묶음당 harness.json llmReviewBatch 행). 같은 입력은 캐시.
    3) 답의 인용(경로:줄 + 원문)을 기계로 확인한다(llm_call.verify_quote).
    4) 결과 Doc/verify/<ID>/llm_review.csv — judge.py 가 반입한다(apply=Y 행만 · 정적 판정 반입 자리).
       반영 조건: 인용 확인됨 + 판정이 바뀜 + 허용된 방향.
         FAIL → PASS·NA   분류가 검사기오판·TOBE룰이고, AS-IS 원문 인용이 확인됐거나 등록된 룰 번호(CR·DD)가 있고 인용이 확인됨
         판정필요 → PASS·NA·FAIL   인용 확인됨(FAIL 은 AS-IS 원문 인용 필수)
         ERROR(미검증)    반영하지 않는다(재지 못한 행을 PASS·NA 로 바꾸지 않음) — 의견·고칠 곳만 남긴다
         데이터차이       판정필요로 둔다(DB 가 달라 값·건수가 다른 것 — CR-101)
    5) 분류가 검사기오판·TOBE룰(미등록)·추출오류인 행은 unverified_resolve.py 가 처리 대상에 넣어 체인 2단계(검증 보완)가 엔진을 고친다.
  판정을 바꾸지 않는 것: 이 도구는 원장을 고치지 않는다. 반영은 judge.py 가 한다.
  종료코드 0(호출 실패가 있어도 0 — 경고만 · 기계 판정 유지) · 2 인자 오류
"""
import argparse
import csv
import hashlib
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
import llm_call  # noqa: E402

csv.field_size_limit(10 ** 8)
TARGET = ('FAIL', '판정필요', 'ERROR')
CLASSES = ('실결함', '검사기오판', 'TOBE룰', '데이터차이', '추출오류', '확인불가')
VERDICTS = ('FAIL', 'PASS', 'NA', '판정필요')
ENGINE_CLASSES = ('검사기오판', 'TOBE룰', '추출오류')   # 체인 2단계(검증 보완)로 넘기는 분류
AI_REF = 'AI 검토(근거 확인)'
COLS = ['row_id', 'source', 'rule_id', 'target', 'cur_result', 'ev_hash', 'class', 'verdict', 'confidence', 'verified', 'apply', 'apply_why',
        'evidence_ref', 'evidence_quote', 'verify_why', 'rule_ref', 'rule_ok', 'reason', 'fix_hint', 'general', 'at']
# 집계·상속 행 — 원천 행이 따로 있다(judge.evidence_gate 와 같은 머리 문구)
RX_AGG = re.compile(r'^(\[[^\]]*\]\s*|실측\[[A-Z]+-[0-9a-f]+\]: )*(행 집계|진입점 집계|선행 미구현에 종속|선행 대조표 |규칙 [\w-]+ 판정 \d+행|같은 결함 [\w-]+ 측정 행)')
RX_USER = re.compile(r'^(\[사용자판정\]|\[사용자의견|\[정적 판정\] \[사용자 확정)')
RX_GATE = re.compile(r'^(\[(증거 부족|보류 규칙)[^\]]*\]\s*)+')
RX_STAMP = re.compile(r'@?\d{2}-\d{2} \d{2}:\d{2}(:\d{2})?|\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}(:\d{2})?')


def P(*a):
    return os.path.join(ROOT, *a)


def read_csv(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as f:
            return list(csv.DictReader(f))
    except OSError:
        return []


def ev_norm(ev):
    """증거 문구에서 실행마다 바뀌는 것(시각)과 증거 관문이 붙인 머리 표식을 뺀다 — 같은 기계 판정이면 같은 글"""
    s = RX_GATE.sub('', str(ev or '').strip())
    s = RX_STAMP.sub('', s)
    s = s.replace(' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)', '')   # judge 판정필요 정리(REVIEW_SWEEP)가 붙이는 꼬리 — 같은 기계 판정
    return re.sub(r'\s+', ' ', s).strip()


def ev_hash(ev):
    return hashlib.sha1(ev_norm(ev).encode('utf-8')).hexdigest()[:12]


def skip_reason(r):
    ev = (r.get('evidence') or '').strip(); t = (r.get('tobe_ref') or '').strip()
    if RX_USER.match(ev) or t.startswith('수동 사용자판정') or t.startswith('수동 결정(사람:'):
        return '사용자가 판정한 행'
    if RX_AGG.match(ev) or re.match(r'^(상속|규칙 판정 상속|STATIC [A-Z]+-[0-9a-f]+ 결과 연결)', t):
        return '집계·상속 행(하위 행을 검토)'
    if ev.startswith('[재실측 스냅샷') or '골든 없음' in ev[:200]:
        return '스냅샷 승인 대기(snap_validate·snap_approve 경로)'
    if re.search(r'명부에 .{0,30}없음|users\.json 에 .{0,20}계정 필요|GUEST 전용', ev):
        return '시험 계정 필요(사람)'
    if ev.startswith('[선행 결함'):
        return '선행 결함 종속(선행 행을 검토)'
    return ''


def base_load(mid):
    try:
        return json.load(open(P('Doc', 'verify', mid, 'llm_review_base.json'), encoding='utf-8'))
    except (OSError, ValueError):
        return {}


def load_rows(mid):
    """원장 행. 지난 실행에서 AI 검토가 반영된 행은 반영 전 기계 판정으로 되돌린 값을 쓴다"""
    rows = read_csv(P('Doc', 'verify', mid, 'verify_ledger.csv'))
    base = base_load(mid)
    for r in rows:
        if (r.get('tobe_ref') or '') == AI_REF and r['row_id'] in base:
            r.update({k: v for k, v in base[r['row_id']].items() if k in r})
    return rows


def asis_id(mid):
    for r in read_csv(P('tools', 'Harness', 'rules', 'map_screen.csv')):
        if (r.get('tobe_id') or '').upper() == mid:
            return (r.get('asis_id') or mid).upper()
    return mid


def screen_ctx(mid):
    """화면 문맥 — AS-IS 소스 파일, TO-BE 화면 폴더, 사실 폴더(경로만 싣는다 · 내용은 Claude 가 Read)"""
    aid = asis_id(mid)
    try:
        src_root = json.load(open(P('tools', 'Harness', 'harness.json'), encoding='utf-8-sig')).get('asisSrcRoot') or P('GSCM')
    except (OSError, ValueError):
        src_root = P('GSCM')
    src_rel = os.path.relpath(src_root, ROOT).replace(os.sep, '/')
    files = []
    for f in read_csv(P('Doc', 'asisfacts', 'screens', aid, 'files.csv')):
        if (f.get('variant') or 'current') not in ('current', 'only', ''):
            continue
        p = (f.get('file') or '').replace('\\', '/')
        if p and not p.endswith('AssemblyInfo.cs') and re.search(r'\.(cs|foxml|xml)$', p, re.I):
            files.append(f"{src_rel}/{p} ({f.get('lines', '?')}줄)")
    page = ''
    try:
        import prereq
        d = prereq.page_dir(mid)
        page = os.path.relpath(d, ROOT).replace(os.sep, '/') if d else ''
    except Exception:
        page = ''
    return {'asis_id': aid, 'asis_files': files[:40], 'page_dir': page,
            'facts_dir': f'Doc/asisfacts/screens/{aid}', 'verify_dir': f'Doc/verify/{mid}'}


_REG = None


def registry():
    global _REG
    if _REG is None:
        _REG = read_csv(P('tools', 'Harness', 'rules', 'tobe_rule_registry.csv'))
    return _REG


def rules_for(rule_id, limit=12):
    out = []
    for x in registry():
        if rule_id and rule_id in re.split(r'[;,\s]+', x.get('detect_rules') or ''):
            out.append(f"{x.get('rule_id')}[{x.get('kind', '')}·{x.get('scope', '')}] {(x.get('title') or '')[:60]}: {(x.get('requirement') or '')[:220]}")
    return out[:limit]


def rule_exists(ref):
    ids = {(x.get('rule_id') or '').upper() for x in registry()}
    got = re.findall(r'(?:CR|DD|SPR|AG)-\d{3}', str(ref or '').upper())
    return bool(got) and all(g in ids for g in got)


_UV = None


def past_verdicts(rule_id, mid, limit=6):
    """같은 규칙의 지난 사용자 판정(다른 화면 포함) — 판단 예시"""
    global _UV
    if _UV is None:
        _UV = []
        for x in read_csv(P('Doc', 'verify', '_user_verdicts.csv')):
            if (x.get('class') or '') in ('판정오류', '실제오류확인', '대상아님'):
                _UV.append((x.get('rule_id') or '', x.get('menu_id') or '', x.get('class') or '', (x.get('target') or '')[:60], (x.get('opinion') or '').replace('\n', ' ')[:200]))
        led = {}
        for x in read_csv(P('Doc', 'verify', '_user_verdicts_direct.csv')):
            m = (x.get('menu_id') or '').upper()
            if m not in led:
                led[m] = {r['row_id']: r for r in read_csv(P('Doc', 'verify', m, 'verify_ledger.csv'))}
            lr = led[m].get(x.get('row_id') or '')
            if lr:
                _UV.append((lr.get('rule_id') or '', m, '직접판정 ' + (x.get('verdict') or ''), (lr.get('target') or '')[:60], (x.get('opinion') or '').replace('\n', ' ')[:200]))
    seen, out = set(), []
    for rid, m, c, t, o in _UV:
        if rid == rule_id and (c, o[:60]) not in seen:
            seen.add((c, o[:60])); out.append(f'{m} {t} → {c}: {o}')
    return out[:limit]


_DEF = None


def defect_types(limit=42):
    """검사기 결함 유형표(Doc/verify/_checker_defects.md §1) 한 줄 요약"""
    global _DEF
    if _DEF is None:
        _DEF = []
        try:
            for ln in open(P('Doc', 'verify', '_checker_defects.md'), encoding='utf-8'):
                m = re.match(r'^\|\s*(T\d+)\s*\|\s*\*\*(.+?)\*\*', ln)
                if m:
                    _DEF.append(f'{m.group(1)} {m.group(2)[:70]}')
        except OSError:
            pass
    return _DEF[:limit]


def facts_findings(mid, limit=20):
    """llm_facts.csv 의 확인된 후보 한 줄씩"""
    return [f"{x.get('fact_file')} {x.get('key')} [{x.get('kind')}] {(x.get('detail') or '')[:240]} (근거 {(x.get('evidence_ref') or '')[:120]})"
            for x in read_csv(P('Doc', 'verify', mid, 'llm_facts.csv')) if x.get('verified') == 'Y'][:limit]


def row_brief(r):
    f = lambda k, n: (r.get(k) or '').replace('\r', ' ').strip()[:n]
    return {'row_id': r['row_id'], 'source': r.get('source', ''), 'rule_id': r.get('rule_id', ''), 'result': r.get('result', ''),
            'target': f('target', 200), 'condition': f('condition', 200), 'expected': f('expected', 500), 'asis_ref': f('asis_ref', 300),
            'evidence': ev_norm(r.get('evidence'))[:1200], 'expect_src': f('expect_src', 120), 'method': f('method', 40), 'note': f('note', 200)}


PROMPT_HEAD = """너는 NSCM 전환 프로젝트(AS-IS C# WinForms → TO-BE React + Spring Boot + Oracle)의 CheckList 판정 검토자다.
검사엔진이 화면 {mid} 를 검사해 아래 행들을 FAIL(오류)·판정필요·ERROR(미검증)로 남겼다. 행마다 원문을 직접 읽고 무엇인지 가려라.
파일을 고치거나 명령을 실행하지 않는다(Read·Glob·Grep 만 쓴다). 답은 마지막에 JSON 하나만 낸다.

## 화면 원천(경로는 저장소 루트 기준)
- AS-IS 화면 ID: {asis_id}
- AS-IS 소스: {asis_files}
- AS-IS 사실 추출본(검사엔진이 기대값으로 쓴 것): {facts_dir}/ (grid_effective.csv·lock_rules.csv·cell_rules.csv·combo_src.csv·sort_rules.csv·events.csv·flow.csv 등)
- AS-IS SP 원문: DB_DDL/ 아래 AsIs_*_DDL.sql (SP 이름으로 Grep)
- TO-BE 화면 소스: {page_dir}/
- TO-BE 패키지 원문: To-be_v2_converted/06_Packages/ (PKG 이름으로 Glob)
- 검증 산출물: {verify_dir}/ (verify_ledger.csv 원장 · e2e_results.json · diff/ · mapping_trace.md)
- TO-BE 룰 원장(AS-IS 와 달라도 오류가 아닌 차이·개발 규칙): tools/Harness/rules/tobe_rule_registry.csv (열 rule_id·kind·detect_rules·title·requirement)
- 검사기 결함 유형: Doc/verify/_checker_defects.md

## 분류(행마다 하나)
- 실결함: TO-BE 화면·DB 가 AS-IS 원문 동작과 다르고, 그 차이를 허용하는 TO-BE 룰이 없다.
- 검사기오판: 화면은 맞는데 검사엔진이 잘못 쟀다(기대값 추출 오류, 다른 시트·다른 조건의 규칙 적용, 측정 실패를 결함으로 기록, 주석·미사용 코드를 사실로 봄 등).
- TOBE룰: AS-IS 와 다르지만 TO-BE 룰 원장에 등록된 차이이거나, 전 화면 공통으로 허용해야 할 차이다(등록 번호가 있으면 rule_ref 에 적는다. 없으면 rule_ref 를 비우고 reason 에 일반 규칙 문장을 적는다).
- 데이터차이: AS-IS 개발 DB 와 TO-BE DB 의 데이터가 달라 값·건수가 다르다(로직 차이 아님).
- 추출오류: AS-IS 사실 추출본이 원문과 다르다(누락·오추출) — 검사기오판의 원인이 추출기에 있을 때.
- 확인불가: 원문을 읽어도 가릴 수 없다(화면을 실제로 띄워야 알 수 있는 동작 등).

## 판정(verdict)
- 실결함 → FAIL · 검사기오판·TOBE룰·추출오류 → PASS(동작이 같음) 또는 NA(대상이 없음) · 데이터차이 → 판정필요 · 확인불가 → 지금 결과 그대로
- 재지 못한 행(ERROR)은 원문만으로 PASS 라고 하지 않는다. 대상 자체가 AS-IS 에 없다는 원문 근거가 있을 때만 NA, 아니면 지금 결과 그대로 두고 fix_hint 에 검사기가 재지 못한 원인을 적는다.
- 판정을 PASS·NA 로 낮출 때는 AS-IS 원문 줄(GSCM/ 또는 DB_DDL/) 인용이 있어야 한다. 사실 추출본·원장만 인용해서는 안 된다(그것이 틀렸는지 보는 일이다).

## 근거 규칙(기계가 확인한다 — 틀리면 그 답은 판정에 쓰지 않는다)
- evidence 한 건 = {{"ref":"<경로>:<줄>","quote":"<그 줄 원문 일부를 글자 그대로>"}}. 줄 번호는 Read 로 연 파일에서 본 줄만 적는다. quote 는 그 줄(±3줄) 안에 그대로 있어야 한다.
- CSV 처럼 줄 번호가 어려우면 ref 에 경로만 쓰고 quote 를 배열로(같은 한 줄 안에 모두 나오는 토큰들).
- 실결함이면 AS-IS 원문 줄과 TO-BE 쪽 줄(또는 없음을 확인한 Grep 대상 파일)을 둘 다 든다. TO-BE 에 해당 코드가 없으면 reason 에 '무엇을 어디서 찾았는데 없었는지' 적는다.
- 근거를 못 찾으면 evidence 를 비우고 class 를 확인불가로 둔다. 추측으로 채우지 않는다.
- 주석 처리된 코드·#if 로 빠진 코드·호출되지 않는 메서드는 AS-IS 동작이 아니다.

## 문장 규칙(reason·fix_hint)
- 업무 담당자가 읽는 한국어 문장. 수식어·추측 어미·줄표·굵은 글씨 없이, 컬럼명·버튼명·건수를 적는다. reason 은 3문장 이내.
- fix_hint 는 검사기오판·추출오류일 때만: 고칠 검사기 파일(tools/Harness/verify, tools/E2E, Doc/e2e/specs, tools/AsisFacts 중)과 원인 한 문장. 모르면 비운다.
- general: 다른 화면에도 같은 판단이 적용되면 "Y", 이 화면만이면 "N".
"""

PROMPT_TAIL = """
## 출력 — 마지막 메시지에 JSON 하나만(설명 문장·코드펜스 없이). items 는 위 행 전부를 row_id 로 하나씩.
{"items":[{"row_id":"…","class":"실결함|검사기오판|TOBE룰|데이터차이|추출오류|확인불가","verdict":"FAIL|PASS|NA|판정필요","confidence":"높음|보통|낮음","evidence":[{"ref":"경로:줄","quote":"원문"}],"rule_ref":"등록 룰 번호 또는 빈 값","reason":"…","fix_hint":"…","general":"Y|N"}]}"""


def build_prompt(mid, ctx, chunk):
    head = PROMPT_HEAD.format(mid=mid, asis_id=ctx['asis_id'], asis_files=' · '.join(ctx['asis_files']) or '(files.csv 없음 — GSCM/ 에서 화면 ID 로 Glob)',
                              facts_dir=ctx['facts_dir'], page_dir=ctx['page_dir'] or '(nscm-fe/features/**/pages 에서 화면 ID 로 Grep)', verify_dir=ctx['verify_dir'])
    parts = [head, '## 검사기 결함 유형(지금까지 확인된 오판 원인)', ' / '.join(defect_types()) or '(없음)', '']
    for rid in sorted({r.get('rule_id') or '' for r in chunk}):
        rl = rules_for(rid); pv = past_verdicts(rid, mid)
        if rl:
            parts += [f'## 규칙 {rid} 에 걸린 TO-BE 룰', *['- ' + x for x in rl], '']
        if pv:
            parts += [f'## 규칙 {rid} 의 지난 사용자 판정(참고 — 같은 원인이면 같은 판단)', *['- ' + x for x in pv], '']
    ff = facts_findings(mid)
    if ff:
        parts += ['## AS-IS 사실 추출 검토 후보(추출본이 원문과 다른 곳 — 원문 인용 확인됨. 이 컬럼·컨트롤이 걸린 행은 기대값이 틀렸는지 먼저 본다)', *['- ' + x for x in ff], '']
    parts += ['## 검토할 행', json.dumps([row_brief(r) for r in chunk], ensure_ascii=False, indent=1), PROMPT_TAIL]
    return '\n'.join(parts)


def chunks(targets, n):
    """규칙이 같은 행을 한 묶음에 — 묶음당 n 행. 규칙 순서·행 ID 순서를 고정해 캐시 키가 실행마다 같게 한다"""
    by = {}
    for r in sorted(targets, key=lambda x: (x.get('rule_id') or '', x['row_id'])):
        by.setdefault(r.get('rule_id') or '', []).append(r)
    out, cur = [], []
    for rid in sorted(by):
        g = by[rid]
        while g:
            room = n - len(cur)
            if len(g) > room and cur and len(g) <= n:   # 한 규칙은 가능하면 한 묶음에
                out.append(cur); cur = []; continue
            cur += g[:room]; g = g[room:]
            if len(cur) >= n:
                out.append(cur); cur = []
    if cur:
        out.append(cur)
    return out


def is_asis_ref(ref):
    p = str(ref or '').replace('\\', '/').lstrip('./').lower()
    # AS-IS 원문 = 화면 소스(GSCM/) · SP 원문(DB_DDL/ · Doc/asisfacts/db/modules/ 는 AS-IS DB 에서 받은 모듈 원문). 사실 추출본(Doc/asisfacts/screens/)은 원문이 아니다
    return p.startswith('gscm/') or p.startswith('gscm_') or p.startswith('db_ddl/') or p.startswith('doc/asisfacts/db/modules/')


def decide(r, it):
    """답 1건 → llm_review.csv 행(인용 확인 · 반영 여부)"""
    cur = r.get('result') or ''
    cls = it.get('class') if it.get('class') in CLASSES else '확인불가'
    ver = it.get('verdict') if it.get('verdict') in VERDICTS else cur
    evs = [e for e in (it.get('evidence') or []) if isinstance(e, dict)]
    checked = []
    for e in evs[:6]:
        ok, why = llm_call.verify_quote(e.get('ref'), e.get('quote'))
        checked.append((ok, why, str(e.get('ref') or ''), e.get('quote')))
    ok_any = any(c[0] for c in checked)
    ok_asis = any(c[0] and is_asis_ref(c[2]) for c in checked)
    rule_ref = str(it.get('rule_ref') or '').strip()
    rule_ok = rule_exists(rule_ref) if rule_ref else False
    apply, why = 'N', ''
    if not evs:
        why = '근거 없음'
    elif not ok_any:
        why = '인용 미확인'
    elif cur == 'ERROR':
        why = '미검증 행은 의견만(판정 반영 안 함)'
    elif ver == cur:
        why = '판정 같음'
    elif cls == '확인불가':
        why = '확인불가'
    elif cls == '데이터차이':
        if cur == 'FAIL' and ver == '판정필요':
            apply, why = 'Y', '데이터 차이 — 판정필요(CR-101)'
        else:
            why = '데이터 차이는 판정필요로만'
    elif ver in ('PASS', 'NA'):
        if cls not in ('검사기오판', 'TOBE룰', '추출오류'):
            why = f'분류 {cls} 는 PASS·NA 로 낮추지 않음'
        elif ok_asis or (rule_ok and ok_any):
            apply, why = 'Y', 'AS-IS 원문 인용 확인' if ok_asis else f'등록 룰 {rule_ref} + 인용 확인'
        else:
            why = 'AS-IS 원문 인용 또는 등록 룰 번호 없음'
    elif ver == 'FAIL':
        if cls == '실결함' and ok_asis:
            apply, why = 'Y', 'AS-IS 원문 인용 확인'
        else:
            why = 'FAIL 은 실결함 + AS-IS 원문 인용 필요'
    elif ver == '판정필요':
        why = '판정필요로 바꾸는 것은 데이터차이만'
    good = [c for c in checked if c[0]] or checked
    q = lambda v: (' | '.join(map(str, v)) if isinstance(v, list) else str(v or ''))
    return {'row_id': r['row_id'], 'source': r.get('source', ''), 'rule_id': r.get('rule_id', ''), 'target': (r.get('target') or '')[:200], 'cur_result': cur, 'ev_hash': ev_hash(r.get('evidence')),
            'class': cls, 'verdict': ver, 'confidence': str(it.get('confidence') or '')[:6], 'verified': 'Y' if ok_any else 'N', 'apply': apply, 'apply_why': why,
            'evidence_ref': ' ; '.join(c[2] for c in good)[:500], 'evidence_quote': ' ; '.join(q(c[3]) for c in good)[:800], 'verify_why': ' ; '.join(c[1] for c in checked)[:400],
            'rule_ref': rule_ref[:60], 'rule_ok': 'Y' if rule_ok else ('N' if rule_ref else ''), 'reason': str(it.get('reason') or '').replace('\r', ' ').strip()[:900],
            'fix_hint': str(it.get('fix_hint') or '').replace('\r', ' ').strip()[:500], 'general': 'Y' if str(it.get('general') or '').upper().startswith('Y') else 'N', 'at': llm_call.now()}


def blank(r, cls, why):
    return dict({k: '' for k in COLS}, row_id=r['row_id'], source=r.get('source', ''), rule_id=r.get('rule_id', ''), target=(r.get('target') or '')[:200], cur_result=r.get('result', ''),
                ev_hash=ev_hash(r.get('evidence')), verified='N', apply='N', apply_why=why, at=llm_call.now(), **{'class': cls})


def write_out(mid, out, meta):
    d = P('Doc', 'verify', mid)
    with open(os.path.join(d, 'llm_review.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS, extrasaction='ignore', quoting=csv.QUOTE_ALL)
        w.writeheader(); w.writerows(out)
    by = {}
    for x in out:
        by[x['class']] = by.get(x['class'], 0) + 1
    j = dict(meta, menu_id=mid, at=llm_call.now(), rows=len(out), by_class=by,
             reviewed=sum(1 for x in out if x['class'] in CLASSES), verified=sum(1 for x in out if x['verified'] == 'Y'),
             apply=sum(1 for x in out if x['apply'] == 'Y'), engine_fix=sum(1 for x in out if x['class'] in ENGINE_CLASSES),
             rule_candidates=sum(1 for x in out if x['class'] == 'TOBE룰' and x['rule_ok'] != 'Y'),
             excluded=sum(1 for x in out if x['class'] == '검토 제외'), unreviewed=sum(1 for x in out if x['class'] == '미검토'))
    json.dump(j, open(os.path.join(d, 'llm_review.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    esc = lambda s: str(s or '').replace('|', '/').replace('\n', ' ')
    L = [f'# {mid} AI 판정 검토 ({j["at"]})', '',
         f'- 대상 {j["rows"]}행: 검토 {j["reviewed"]} · 검토 제외 {j["excluded"]} · 미검토 {j["unreviewed"]}',
         f'- 인용 확인 {j["verified"]}행 · 판정 반영 {j["apply"]}행 · 엔진 보완 대상 {j["engine_fix"]}행 · 룰 등록 후보 {j["rule_candidates"]}행',
         f'- 호출 {meta.get("calls", 0)}회(캐시 {meta.get("cached", 0)}) · 실패 {meta.get("failed", 0)}회 · 비용 {meta.get("cost", 0):.4f} USD · 출처 Doc/verify/{mid}/llm_usage.csv', '',
         '| 행 | 규칙 | 지금 | 분류 | AI 판정 | 인용 | 반영 | 사유 | 근거 | 고칠 곳 |', '|---|---|---|---|---|---|---|---|---|---|']
    for x in out:
        L.append(f"| {x['row_id']} | {x['rule_id']} | {x['cur_result']} | {x['class']} | {x['verdict']} | {x['verified']} | {x['apply']} {esc(x['apply_why'])[:40]} | {esc(x['reason'])[:260]} | {esc(x['evidence_ref'])[:120]} | {esc(x['fix_hint'])[:160]} |")
    open(os.path.join(d, 'llm_review.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    return j


def run(mid, dry=False, from_file=None):
    rows = load_rows(mid)
    if not rows:
        print(f'[ERROR] 원장 없음: Doc/verify/{mid}/verify_ledger.csv'); return 0
    cand = [r for r in rows if (r.get('result') or '') in TARGET]
    out, targets = [], []
    # 2026-11-20 중복 정리 G2(dedup_screen.py · AI 판단 목록): 같은 확인으로 묶인 구성원은 대표 행만 검토한다(대표 결과가 같거나 대표도 검토 대상일 때)
    try:
        import dedup_screen as _dd; _dup = _dd.load_map(mid)
    except Exception:
        _dup = {}
    _by = {r['row_id']: r for r in rows}
    for r in cand:
        why = skip_reason(r)
        _rep = _by.get(_dup.get(r['row_id'], ''))
        if not why and _rep and ((_rep.get('result') or '') in TARGET or _rep.get('result') == r.get('result')):
            why = f"중복 정리 구성원(대표 {_rep['row_id']} 를 검토)"
        if why:
            out.append(blank(r, '검토 제외', why))
        else:
            targets.append(r)
    c = llm_call.cfg(); n = max(1, int(c.get('llmReviewBatch') or 6))
    ch = chunks(targets, n); ctx = screen_ctx(mid)
    print(f'[AI 검토] 대상 {len(cand)}행(FAIL·판정필요·미검증) · 검토 {len(targets)}행 · 검토 제외 {len(cand) - len(targets)}행 · 묶음 {len(ch)}개(묶음당 {n}행)', flush=True)
    meta = {'calls': 0, 'cached': 0, 'failed': 0, 'cost': 0.0, 'chunks': len(ch)}
    if dry:
        for i, g in enumerate(ch, 1):
            p = build_prompt(mid, ctx, g)
            print(f"  묶음 {i}: {len(g)}행 · 규칙 {','.join(sorted({x.get('rule_id') or '' for x in g}))} · 프롬프트 {len(p)}자")
        return 0
    from_data = None
    if from_file:
        from_data = llm_call.parse_json(open(from_file, encoding='utf-8-sig').read()) or {}
    # 2026-11-20 C3 동시 호출(harness.json llmReviewPar · 기본 4) · C5 답 JSON 해석 실패는 1번 다시 요청. 결과 순서와 반영 규칙은 종전과 같다(묶음 번호 순으로 처리)
    import concurrent.futures as _cf, threading as _th
    try:
        _par = max(1, int(c.get('llmReviewPar') or 4))
    except (TypeError, ValueError):
        _par = 4
    _plock = _th.Lock(); _pdone = [0]

    def _ask(ig):
        i, g = ig; prompt = build_prompt(mid, ctx, g)
        if from_data is not None:
            return i, g, {'ok': True, 'data': from_data, 'cached': False, 'cost': 0.0, 'why': ''}
        res = llm_call.ask(mid, 'judge', prompt, rows=len(g))
        if not res['ok'] and '해석 실패' in (res.get('why') or ''):
            res = llm_call.ask(mid, 'judge', prompt, rows=len(g), use_cache=False)
            if not res['ok']: res['why'] = '다시 요청 뒤에도 ' + (res.get('why') or '')
        with _plock:
            _pdone[0] += 1
            print(f"  · AI 판정 검토 묶음 {_pdone[0]}/{len(ch)} — {len(g)}행 · 규칙 {','.join(sorted({x.get('rule_id') or '' for x in g}))}{' · 캐시' if res.get('cached') else ''}", flush=True)
        return i, g, res
    with _cf.ThreadPoolExecutor(max_workers=_par if from_data is None else 1) as _ex:
        _answers = list(_ex.map(_ask, list(enumerate(ch, 1))))
    print(f"[AI 검토] 동시 {_par} · 묶음 {len(ch)}개 처리 끝", flush=True)
    for i, g, res in _answers:
        if not res['ok']:
            meta['failed'] += 1
            print(f"[WARN] AI 검토 묶음 {i} 결과 없음 — {res['why']} · 기계 판정 유지", flush=True)
            out += [blank(r, '미검토', res['why'][:120]) for r in g]
            continue
        meta['cached' if res.get('cached') else 'calls'] += 1; meta['cost'] += float(res.get('cost') or 0)
        items = {str(it.get('row_id') or ''): it for it in ((res['data'] or {}).get('items') or []) if isinstance(it, dict)}
        for r in g:
            it = items.get(r['row_id'])
            out.append(decide(r, it) if it else blank(r, '미검토', '답에 이 행이 없음'))
    order = {r['row_id']: k for k, r in enumerate(cand)}
    out.sort(key=lambda x: order.get(x['row_id'], 10 ** 9))
    j = write_out(mid, out, meta)
    if len(out) != len(cand):
        print(f'[ERROR] 행 수 불일치: 대상 {len(cand)} ≠ 기록 {len(out)}')
    print(f"[AI 검토] 묶음 {len(ch)} · 행 {j['reviewed']} · 근거 확인 {j['verified']} · 판정 반영 {j['apply']} · 엔진 보완 대상 {j['engine_fix']} · 미검토 {j['unreviewed']} · 호출 {meta['calls']}(캐시 {meta['cached']} · 실패 {meta['failed']}) · 비용 ${meta['cost']:.4f}", flush=True)
    print(f'@@LINK 🧠 AI 판정 검토|Doc/verify/{mid}/llm_review.md', flush=True)
    return 0


def user_side(mid):
    """{row_id: (사용자 쪽 판정 묶음 OK|FAIL, 원문)} — 회귀 수집본(_user_verdicts.csv)의 분류와 대화 판정(_user_verdicts_direct.csv)"""
    out = {}
    for x in read_csv(P('Doc', 'verify', '_user_verdicts.csv')):
        if (x.get('menu_id') or '').upper() != mid:
            continue
        c = x.get('class') or ''
        g = 'OK' if c in ('판정오류', '대상아님') else 'FAIL' if c == '실제오류확인' else ''
        if g:
            out[x['row_id']] = (g, c + ': ' + (x.get('opinion') or '').replace(chr(10), ' ')[:120])
    for x in read_csv(P('Doc', 'verify', '_user_verdicts_direct.csv')):
        if (x.get('menu_id') or '').upper() != mid:
            continue
        v = x.get('verdict') or ''
        g = 'OK' if v in ('PASS', 'NA', 'SKIP') else 'FAIL' if v == 'FAIL' else ''
        if g:
            out[x['row_id']] = (g, '직접판정 ' + v)
    return out


def precision(mid):
    """AI 판정 검토 ↔ 사용자 판정 대조 — 같은 행에 둘 다 있는 것만. Doc/verify/_llm_review_precision.csv 에 이 화면 행을 다시 쓴다(다른 화면 행 유지).
    사용자가 오류 아님·대상 아님으로 본 행(OK)에 AI 가 PASS·NA, 사용자가 결함으로 본 행(FAIL)에 AI 가 FAIL 이면 일치"""
    us = user_side(mid)
    rv = [x for x in read_csv(P('Doc', 'verify', mid, 'llm_review.csv')) if x.get('class') in CLASSES and x.get('class') != '확인불가']
    rows = []
    for x in rv:
        u = us.get(x['row_id'])
        if not u:
            continue
        ag = 'OK' if x.get('verdict') in ('PASS', 'NA') else 'FAIL' if x.get('verdict') == 'FAIL' else '보류'
        rows.append({'menu_id': mid, 'row_id': x['row_id'], 'rule_id': x.get('rule_id', ''), 'ai_class': x.get('class', ''), 'ai_verdict': x.get('verdict', ''), 'ai_verified': x.get('verified', ''),
                     'user': u[1], 'match': 'Y' if ag == u[0] else ('-' if ag == '보류' else 'N'), 'at': llm_call.now()})
    p = P('Doc', 'verify', '_llm_review_precision.csv')
    keep = [r for r in read_csv(p) if (r.get('menu_id') or '') != mid]
    cols = ['menu_id', 'row_id', 'rule_id', 'ai_class', 'ai_verdict', 'ai_verified', 'user', 'match', 'at']
    if rows or keep:
        with open(p, 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.DictWriter(f, fieldnames=cols, extrasaction='ignore'); w.writeheader(); w.writerows(keep + rows)
    y = sum(1 for r in rows if r['match'] == 'Y'); n = sum(1 for r in rows if r['match'] == 'N')
    print(f'[AI 검토 정확도] {mid} 사용자 판정과 겹치는 행 {len(rows)} · 일치 {y} · 불일치 {n} · 보류 {len(rows) - y - n} → Doc/verify/_llm_review_precision.csv')
    return 0


def selftest():
    ok = True

    def chk(name, cond):
        nonlocal ok
        print(f"  [{'OK' if cond else 'FAIL'}] {name}")
        ok = ok and bool(cond)
    chk('증거 정규화 — 시각·관문 표식 제거', ev_hash('[증거 부족: x] 값 다름 @11-19 10:02') == ev_hash('값  다름 @11-18 09:00'))
    chk('증거 정규화 — 판정필요 정리 꼬리 제거', ev_hash('값 다름 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)') == ev_hash('값 다름'))
    chk('증거 정규화 — 내용이 다르면 다름', ev_hash('값 다름 3행') != ev_hash('값 다름 4행'))
    chk('제외 — 사용자판정', skip_reason({'evidence': '[사용자판정] 판정필요 — x', 'tobe_ref': ''}) != '')
    chk('제외 — 사용자 확정 정적 판정', skip_reason({'evidence': '[정적 판정] [사용자 확정 11-18] 데이터', 'tobe_ref': '정적 판정(원문 대조)'}) != '')
    chk('제외 — 행 집계', skip_reason({'evidence': '행 집계 — 대조표 D00', 'tobe_ref': ''}) != '')
    chk('제외 — 규칙 판정 상속', skip_reason({'evidence': '규칙 N1 판정 3행 중 FAIL 1', 'tobe_ref': '규칙 판정 상속'}) != '')
    chk('제외 — 증거 관문 표식 뒤 집계', skip_reason({'evidence': '[증거 부족: x] 진입점 집계 7검사', 'tobe_ref': ''}) != '')
    chk('대상 — 일반 FAIL', skip_reason({'evidence': "'Sum' 체크박스 없음", 'tobe_ref': 'E2E @verify'}) == '')
    chk('대상 — AI 가 아닌 정적 판정', skip_reason({'evidence': '[정적 판정] 원문 대조 x', 'tobe_ref': '정적 판정(원문 대조)'}) == '')
    rs = [{'row_id': f'V-{i:02d}', 'rule_id': 'A' if i < 5 else ('B' if i < 8 else 'C'), 'result': 'FAIL'} for i in range(10)]
    cs = chunks(rs, 6)
    chk('묶음 — 전 행 1회씩', sorted(x['row_id'] for g in cs for x in g) == sorted(x['row_id'] for x in rs))
    chk('묶음 — 크기 상한', all(len(g) <= 6 for g in cs))
    chk('묶음 — 순서 고정', [[x['row_id'] for x in g] for g in chunks(list(reversed(rs)), 6)] == [[x['row_id'] for x in g] for g in cs])
    me = os.path.relpath(os.path.abspath(__file__), ROOT).replace(os.sep, '/')
    good = [{'ref': me + ':1', 'quote': 'coding: utf-8'}]
    r0 = {'row_id': 'V-1', 'result': 'FAIL', 'evidence': 'x'}
    d = decide(r0, {'class': '검사기오판', 'verdict': 'PASS', 'evidence': good})
    chk('반영 — AS-IS 원문 아닌 인용만으로 PASS 불가', d['verified'] == 'Y' and d['apply'] == 'N')
    d = decide(r0, {'class': '검사기오판', 'verdict': 'PASS', 'evidence': [{'ref': me + ':1', 'quote': '없는 문장 zzqq'}]})
    chk('반영 — 인용 미확인 불가', d['verified'] == 'N' and d['apply'] == 'N')
    d = decide(r0, {'class': '검사기오판', 'verdict': 'PASS', 'evidence': []})
    chk('반영 — 근거 없음 불가', d['apply'] == 'N' and d['apply_why'] == '근거 없음')
    d = decide({'row_id': 'V-2', 'result': 'ERROR', 'evidence': 'x'}, {'class': '검사기오판', 'verdict': 'NA', 'evidence': good})
    chk('반영 — 미검증 행은 의견만', d['apply'] == 'N' and d['class'] == '검사기오판')
    d = decide(r0, {'class': '데이터차이', 'verdict': '판정필요', 'evidence': good})
    chk('반영 — 데이터 차이 FAIL → 판정필요', d['apply'] == 'Y')
    d = decide(r0, {'class': '실결함', 'verdict': 'FAIL', 'evidence': good})
    chk('반영 — 판정 같음', d['apply'] == 'N' and d['apply_why'] == '판정 같음')
    d = decide({'row_id': 'V-3', 'result': '판정필요', 'evidence': 'x'}, {'class': '실결함', 'verdict': 'FAIL', 'evidence': good})
    chk('반영 — FAIL 승격은 AS-IS 원문 인용 필요', d['apply'] == 'N')
    d = decide(r0, {'class': '이상한값', 'verdict': '모름', 'evidence': good})
    chk('답 정규화 — 모르는 분류·판정', d['class'] == '확인불가' and d['verdict'] == 'FAIL' and d['apply'] == 'N')
    chk('AS-IS 경로 판별', is_asis_ref('GSCM/06.UIL/x.cs:10') and is_asis_ref('DB_DDL/AsIs_SP.sql:3') and is_asis_ref('Doc/asisfacts/db/modules/dbo.X.sql:9') and not is_asis_ref('Doc/asisfacts/screens/X/lock_rules.csv'))
    chk('룰 번호 — 없는 번호', not rule_exists('CR-' + '9' * 3) and not rule_exists(''))
    p = build_prompt('ZZZ0000', {'asis_id': 'ZZZ0000', 'asis_files': [], 'page_dir': '', 'facts_dir': 'f', 'verify_dir': 'v'}, [dict(r0, rule_id='A1')])
    chk('프롬프트 — 행·출력 형식 포함', '"row_id": "V-1"' in p and '"items"' in p)
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        return selftest()
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--dry', action='store_true')
    ap.add_argument('--from', dest='from_file')
    ap.add_argument('--precision', action='store_true', help='사용자 판정과 대조만(Claude 호출 없음)')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    if a.precision:
        return precision(mid)
    if not (a.dry or a.from_file) and not llm_call.enabled('judge'):
        print('[AI 검토] 꺼짐(harness.json llmReview·llmReviewKinds) — 건너뜀'); return 0
    return run(mid, dry=a.dry, from_file=a.from_file)


if __name__ == '__main__':
    sys.exit(main())
