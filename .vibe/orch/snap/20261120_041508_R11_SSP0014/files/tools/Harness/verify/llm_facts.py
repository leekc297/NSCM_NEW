# -*- coding: utf-8 -*-
"""AS-IS 사실 추출 검토 — 검사엔진이 기대값으로 쓰는 AS-IS 사실 추출본을 Claude 가 화면 원문과 대조해 누락·오추출을 찾는다 (2026-11-19 사용자 지시 · 적용 단계 'AS-IS 사실 추출 검토')
   왜: 검사기 오판 유형 T4(AS-IS 사실 추출 불완전 — 가드 무시, 주석을 사실로, 다른 시트 규칙)가 기대값을 틀리게 만들어 확신 있는 FAIL·허위 PASS 가 된다. 판정 전에 원인을 줄인다.

  python tools/Harness/verify/llm_facts.py <MENU_ID>                사실 검토(원문·추출본이 지난 검토와 같으면 호출 없음)
  python tools/Harness/verify/llm_facts.py <MENU_ID> --dry          대상 파일·프롬프트 크기만 출력
  python tools/Harness/verify/llm_facts.py <MENU_ID> --from <json>  Claude 호출 없이 답 JSON 반영(배관 시험)
  python tools/Harness/verify/llm_facts.py --selftest

  대상 추출본(Doc/asisfacts/screens/<AS-IS ID>/): grid_effective.csv(표시 컬럼) · edit_expect.csv(편집 가능 여부) · lock_rules.csv(잠금) · cell_rules.csv(셀 형식·범위)
        · combo_src.csv(콤보 원천) · sort_rules.csv(정렬) · cell_prereq.csv · cell_clear.csv · color_rules.csv (있는 것만)
  출력  Doc/verify/<ID>/llm_facts.csv (fact_id, fact_file, key, kind 누락|오추출, detail, affects, evidence_ref, evidence_quote, verified, fix_hint, at) · llm_facts.json
  쓰임  ① judge.py: 인용이 확인된 후보의 key(컬럼·컨트롤 이름)가 대상에 든 FAIL·판정필요 행의 note 에 '사실 검토 후보' 표식(판정은 바꾸지 않음)
        ② llm_review.py: 판정 검토 프롬프트에 후보를 실어 오판 여부 판단에 쓴다
        ③ unverified_resolve.py: 확인된 후보 = 추출기 보완 대상(체인 2단계)
  사실 파일은 고치지 않는다. 종료코드 0
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
import llm_review  # noqa: E402

csv.field_size_limit(10 ** 8)
FACT_FILES = ['grid_effective.csv', 'edit_expect.csv', 'lock_rules.csv', 'cell_rules.csv', 'combo_src.csv', 'sort_rules.csv', 'cell_prereq.csv', 'cell_clear.csv', 'color_rules.csv']
KINDS = ('누락', '오추출')
COLS = ['fact_id', 'fact_file', 'key', 'kind', 'detail', 'affects', 'evidence_ref', 'evidence_quote', 'verified', 'fix_hint', 'at']


def P(*a):
    return os.path.join(ROOT, *a)


def sha(path):
    try:
        return hashlib.sha1(open(path, 'rb').read()).hexdigest()[:12]
    except OSError:
        return ''


def inputs(mid):
    """(ctx, [(추출본 상대경로, 줄 수, 해시)], [(원문 상대경로, 해시)])"""
    ctx = llm_review.screen_ctx(mid)
    facts = []
    for f in FACT_FILES:
        p = P('Doc', 'asisfacts', 'screens', ctx['asis_id'], f)
        if os.path.isfile(p):
            n = sum(1 for _ in open(p, encoding='utf-8-sig', errors='replace')) - 1
            if n > 0:
                facts.append((f"{ctx['facts_dir']}/{f}", n, sha(p)))
    srcs = []
    for s in ctx['asis_files']:
        rel = s.rsplit(' (', 1)[0]
        srcs.append((rel, sha(P(*rel.split('/')))))
    return ctx, facts, srcs


PROMPT_HEAD = """너는 NSCM 전환 프로젝트의 AS-IS 사실 추출 검토자다. 화면 {mid}(AS-IS {asis_id})의 검사엔진은 아래 '사실 추출본'을 AS-IS 동작의 기대값으로 쓴다.
추출본은 정적 분석기가 만들었다. 화면 원문을 직접 읽고 추출본이 원문과 다른 곳(누락·오추출)을 찾는다.
파일을 고치거나 명령을 실행하지 않는다(Read·Glob·Grep 만). 답은 마지막에 JSON 하나만.

## AS-IS 화면 원문(전부 Read 로 끝까지 읽는다 — 화면 .cs 와 .Designer.cs)
{sources}
- 공통 프레임워크(잠금·셀 형식 기본값)가 필요하면 GSCM/01.Framework/ 에서 Grep

## 사실 추출본(전부 Read 한다)
{facts}

## 찾을 것
- 누락: 원문에 있는 동작인데 추출본에 행이 없다. 예) 조건부 잠금(if 안의 LockColumn·Locked), 셀 범위(SetNumberCellType·SetReNumerCellType 의 최소·최대·소수 자리), 조건부 표시(Visible = 체크박스 값), 콤보 원천 SP 와 필터, 정렬.
- 오추출: 추출본 값이 원문과 다르다. 예) 가드(if 조건·Division·활성 시트)를 빼고 무조건으로 적음, 다른 시트·다른 컨트롤의 규칙을 이 시트에 적음, 주석 처리되거나 호출되지 않는 코드를 사실로 적음, 줄 번호가 가리키는 문장이 다른 내용임.
- 원문과 추출본이 같으면 적지 않는다. 표현만 다른 것(공백, 대소문자, 같은 뜻의 다른 표기)은 적지 않는다. 확신이 없는 것은 적지 않는다.
- 동적으로 만드는 컬럼(DB 루프·달력 컬럼)은 추출본에 패턴 행으로 적힌다. 패턴이 있으면 누락이 아니다.

## 근거 규칙(기계가 확인한다 — 틀리면 그 후보는 버려진다)
- 후보마다 원문 줄 인용이 있어야 한다: {{"ref":"<경로>:<줄>","quote":"<그 줄 원문 일부를 글자 그대로>"}}. Read 로 연 파일에서 본 줄만 적는다.
- 오추출이면 추출본 쪽 줄도 든다(ref 에 추출본 경로만 쓰고 quote 를 그 행의 토큰 배열로).

## 문장 규칙
- detail: 원문은 어떻게 돼 있고 추출본은 어떻게 적혀 있는지 2문장 이내. 컬럼명·컨트롤명·값을 적는다. 수식어·추측 어미 없이.
- key: 이 사실이 걸린 컬럼명 또는 컨트롤명 하나(예 WORKING_TIME_DEFAULT, chkSum). affects: 영향을 받는 검사 종류를 쉼표로(편집·잠금, 셀 형식, 표시 컬럼, 콤보, 정렬 중).
- fix_hint: 추출기가 놓친 원문 형태 한 문장(예 "foreach 안의 LockColumn 호출을 가드 없이 기록"). 모르면 빈 값.
"""

PROMPT_TAIL = """
## 출력 — 마지막 메시지에 JSON 하나만(설명 문장·코드펜스 없이). 후보가 없으면 items 를 비운다.
{"items":[{"fact_file":"lock_rules.csv","key":"…","kind":"누락|오추출","detail":"…","affects":"…","evidence":[{"ref":"경로:줄","quote":"원문"}],"fix_hint":"…"}]}"""


def build_prompt(mid, ctx, facts, srcs):
    return PROMPT_HEAD.format(mid=mid, asis_id=ctx['asis_id'],
                              sources='\n'.join(f'- {p} (해시 {h})' for p, h in srcs) or '- (files.csv 없음 — GSCM/ 에서 화면 ID 로 Glob)',
                              facts='\n'.join(f'- {p} ({n}행 · 해시 {h})' for p, n, h in facts)) + PROMPT_TAIL


def decide(it):
    evs = [e for e in (it.get('evidence') or []) if isinstance(e, dict)][:6]
    chk = [(llm_call.verify_quote(e.get('ref'), e.get('quote'))[0], str(e.get('ref') or ''), e.get('quote')) for e in evs]
    ok_asis = any(c[0] and llm_review.is_asis_ref(c[1]) for c in chk)
    good = [c for c in chk if c[0]] or chk
    q = lambda v: (' | '.join(map(str, v)) if isinstance(v, list) else str(v or ''))
    f = lambda k, n: re.sub(r'[\r\n]+', ' ', str(it.get(k) or '')).strip()[:n]
    key = re.sub(r'[^A-Za-z0-9_.\[\]]', '', f('key', 80))
    ff = os.path.basename(f('fact_file', 60))
    row = {'fact_file': ff, 'key': key, 'kind': it.get('kind') if it.get('kind') in KINDS else '오추출', 'detail': f('detail', 600), 'affects': f('affects', 80),
           'evidence_ref': ' ; '.join(c[1] for c in good)[:400], 'evidence_quote': ' ; '.join(q(c[2]) for c in good)[:600],
           'verified': 'Y' if ok_asis else 'N', 'fix_hint': f('fix_hint', 300), 'at': llm_call.now()}
    row['fact_id'] = 'FACT-' + hashlib.sha1(f"{ff}|{key}|{row['kind']}|{row['detail'][:80]}".encode('utf-8')).hexdigest()[:8]
    return row


def run(mid, dry=False, from_file=None):
    ctx, facts, srcs = inputs(mid)
    if not facts or not srcs:
        print(f"[사실 검토] 대상 없음 — 추출본 {len(facts)}개 · 원문 {len(srcs)}개(Doc/asisfacts/screens/{ctx['asis_id']})"); return 0
    prompt = build_prompt(mid, ctx, facts, srcs)
    print(f"[사실 검토] AS-IS {ctx['asis_id']} · 추출본 {len(facts)}개({sum(n for _, n, _ in facts)}행) · 원문 {len(srcs)}개 · 프롬프트 {len(prompt)}자", flush=True)
    if dry:
        return 0
    if from_file:
        res = {'ok': True, 'data': llm_call.parse_json(open(from_file, encoding='utf-8-sig').read()) or {}, 'cost': 0.0, 'cached': False, 'why': ''}
    else:
        res = llm_call.ask(mid, 'facts', prompt, rows=sum(n for _, n, _ in facts))
    if not res['ok']:
        print(f"[WARN] 사실 검토 결과 없음 — {res['why']} · 지난 결과 유지", flush=True); return 0
    out = [decide(it) for it in ((res['data'] or {}).get('items') or []) if isinstance(it, dict)]
    d = P('Doc', 'verify', mid); os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, 'llm_facts.csv'), 'w', encoding='utf-8-sig', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=COLS, extrasaction='ignore', quoting=csv.QUOTE_ALL)
        w.writeheader(); w.writerows(out)
    v = sum(1 for x in out if x['verified'] == 'Y')
    json.dump({'menu_id': mid, 'asis_id': ctx['asis_id'], 'at': llm_call.now(), 'candidates': len(out), 'verified': v, 'cached': bool(res.get('cached')), 'cost': float(res.get('cost') or 0),
               'facts': [p for p, _, _ in facts], 'sources': [p for p, _ in srcs]}, open(os.path.join(d, 'llm_facts.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    for x in out:
        print(f"  [{x['kind']}{'' if x['verified'] == 'Y' else ' · 인용 미확인'}] {x['fact_file']} {x['key']} — {x['detail'][:140]}", flush=True)
    print(f"[사실 검토] 후보 {len(out)}건 · 원문 인용 확인 {v}건 · {'캐시' if res.get('cached') else '호출 1회'} · 비용 ${float(res.get('cost') or 0):.4f}", flush=True)
    return 0


def findings(mid, verified_only=True):
    return [x for x in llm_review.read_csv(P('Doc', 'verify', mid, 'llm_facts.csv')) if (x.get('verified') == 'Y' or not verified_only)]


def selftest():
    ok = True

    def chk(name, cond):
        nonlocal ok
        print(f"  [{'OK' if cond else 'FAIL'}] {name}")
        ok = ok and bool(cond)
    me = os.path.relpath(os.path.abspath(__file__), ROOT).replace(os.sep, '/')
    d = decide({'fact_file': 'x/lock_rules.csv', 'key': 'WORKING TIME;DEFAULT', 'kind': '누락', 'detail': 'a\nb', 'evidence': [{'ref': me + ':1', 'quote': 'coding: utf-8'}]})
    chk('후보 정규화 — 파일명·키·줄바꿈', d['fact_file'] == 'lock_rules.csv' and d['key'] == 'WORKINGTIMEDEFAULT' and '\n' not in d['detail'] and d['fact_id'].startswith('FACT-'))
    chk('확인 — AS-IS 원문이 아닌 인용은 미확인', d['verified'] == 'N')
    d2 = decide({'fact_file': 'lock_rules.csv', 'key': 'A', 'kind': '모름', 'detail': 'x', 'evidence': []})
    chk('확인 — 근거 없음 · 종류 기본값', d2['verified'] == 'N' and d2['kind'] == '오추출')
    p = build_prompt('ZZZ0000', {'asis_id': 'Z'}, [('Doc/asisfacts/screens/Z/lock_rules.csv', 5, 'abc')], [('GSCM/x.cs', 'def')])
    chk('프롬프트 — 원문·추출본 해시 포함', 'GSCM/x.cs (해시 def)' in p and 'lock_rules.csv (5행 · 해시 abc)' in p)
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        return selftest()
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id'); ap.add_argument('--dry', action='store_true'); ap.add_argument('--from', dest='from_file')
    a = ap.parse_args()
    if not (a.dry or a.from_file) and not llm_call.enabled('facts'):
        print('[사실 검토] 꺼짐(harness.json llmReview·llmReviewKinds) — 건너뜀'); return 0
    return run(a.menu_id.upper(), dry=a.dry, from_file=a.from_file)


if __name__ == '__main__':
    sys.exit(main())
