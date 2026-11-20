# -*- coding: utf-8 -*-
"""사용자의견 자동 처리 — CheckList '사용자의견' 열에 적은 의견을 Claude 가 읽고 처리 구분·근거·답을 만든다 (2026-11-19 사용자 지시 · 적용 단계 '사용자의견 자동 처리')
   지금까지: 사용자가 의견을 적으면 대화 세션이 원인 확인 → 검사엔진 수정 → 전 화면 공용 룰 등록 → 재점검을 손으로 했다(3주 이상 반복).

  python tools/Harness/verify/opinion_intake.py <MENU_ID>                아직 처리하지 않은 의견을 처리
  python tools/Harness/verify/opinion_intake.py <MENU_ID> --dry          대상만 출력
  python tools/Harness/verify/opinion_intake.py <MENU_ID> --from <json>  Claude 호출 없이 답 JSON 반영(배관 시험)
  python tools/Harness/verify/opinion_intake.py --selftest

  대상  CheckList 전 판(Doc/UI_CHECKLIST 등)의 '사용자의견'(행별 최신) 중
        ① 그 행이 지금 원장에 있고 ② 검사엔진 판정(사용자판정·AI 검토 반영 전)이 아직 FAIL·판정필요·ERROR 인 것.
        검사엔진이 이미 PASS·NA 로 판정하는 행의 의견은 끝난 의견이라 다시 보지 않는다. 같은 의견 문구는 한 번만 처리한다(의견 해시).
  처리 구분(class)
    엔진오판   의견이 옳다: 화면은 맞고 검사엔진이 잘못 쟀다 → 체인 2단계(검증 보완)가 엔진을 고친다
    룰등록     의견이 TO-BE 룰(달라도 오류 아님)을 말한다 → 일반 규칙 문장(rule_draft)과 함께 체인 2단계가 confirmed_requirements.csv 에 등록하고 판정 경로에 넣는다
    결함유지   원문을 다시 보니 결함이 맞다(사용자가 '확인 필요'로 물은 것 포함) → 판정 유지 · 답(answer)에 재현 조건
    질문답     사용자가 물은 것에 답한다(무엇이 오류인지, 어느 칸인지 등) → 답은 다음 판 'CheckList Remark' 열에 실린다
    메모       처리할 것이 없는 기록
    확인불가   원문만으로 가릴 수 없음 → 결정 목록
  출력  Doc/verify/<ID>/opinion_intake.csv (row_id, op_hash, opinion, class, action, rule_draft, answer, evidence_ref, evidence_quote, verified, status, at)
        status open = 엔진오판·룰등록 중 검사엔진 판정이 아직 그대로인 것(unverified_resolve.py 가 처리 대상에 넣음) · closed = 그 밖
  판정을 바꾸지 않는다. 사용자의견의 판정 반영은 종전대로 judge.py 가 한다(판정 문구 표).
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
CLASSES = ('엔진오판', '룰등록', '결함유지', '질문답', '메모', '확인불가')
OPEN_CLASSES = ('엔진오판', '룰등록')
COLS = ['row_id', 'op_hash', 'opinion', 'class', 'action', 'rule_draft', 'answer', 'evidence_ref', 'evidence_quote', 'verified', 'status', 'at']


def P(*a):
    return os.path.join(ROOT, *a)


def op_hash(rid, op):
    return hashlib.sha1((rid + '|' + re.sub(r'\s+', ' ', op or '').strip()).encode('utf-8')).hexdigest()[:12]


def machine_result(r, base=None):
    """검사엔진 판정 — 사용자판정·AI 검토가 덮은 행은 note 의 원판정(마지막)"""
    t = r.get('tobe_ref') or ''
    if t == llm_review.AI_REF and base and r['row_id'] in base:
        return base[r['row_id']].get('result') or r.get('result') or ''
    if t.startswith('수동 사용자판정') or t == llm_review.AI_REF:
        o = re.findall(r'원판정:([\w가-힣]+)', r.get('note') or '')
        return o[-1] if o else (r.get('result') or '')
    return r.get('result') or ''


def collect_opinions(mid):
    """{row_id: 의견} — CheckList 전 판(행별 최신)"""
    ops = {}
    try:
        import make_verify_docs as M
        M.USER_OPINION.clear(); M.USER_VERDICT.clear()
        M.load_user_verdicts(mid)
        ops.update({k: v for k, v in M.USER_OPINION.items() if str(v).strip()})
    except Exception as e:
        print(f'[WARN] CheckList 사용자의견 읽기 실패: {e}')
    # 대화로 받은 판정(Doc/verify/_user_verdicts_direct.csv)은 그 대화 세션이 원인 확인·엔진 보완까지 한 기록이라 대상에서 뺀다(스냅샷 자동 승인 기록도 여기에 있다)
    return ops


PROMPT_HEAD = """너는 NSCM 전환 프로젝트(AS-IS C# WinForms → TO-BE React + Spring Boot + Oracle)의 CheckList 사용자의견 처리자다.
화면 {mid} 의 CheckList 에 사용자가 아래 의견을 적었다. 의견마다 원문을 직접 읽고 처리 구분을 정한다.
파일을 고치거나 명령을 실행하지 않는다(Read·Glob·Grep 만). 답은 마지막에 JSON 하나만.

## 원천
- AS-IS 화면 ID {asis_id} · 소스: {asis_files}
- AS-IS 사실 추출본: {facts_dir}/ · AS-IS SP 원문: DB_DDL/ 아래 AsIs_*_DDL.sql
- TO-BE 화면 소스: {page_dir}/ · TO-BE 패키지: To-be_v2_converted/06_Packages/ · 검증 산출물: {verify_dir}/
- TO-BE 룰 원장: tools/Harness/rules/tobe_rule_registry.csv · 확정 요구 원천: tools/Harness/rules/confirmed_requirements.csv
- 검사기 결함 유형: Doc/verify/_checker_defects.md

## 처리 구분(class)
- 엔진오판: 사용자가 '오류 아님'·'판정오류'·'정상' 등으로 적었고 원문으로도 화면이 맞다. 검사엔진이 잘못 잰 원인을 action 에 적는다(검사기 파일과 원인 한 문장. 모르면 어떤 사실이 틀렸는지).
- 룰등록: 사용자가 'TO-BE RULE'·'TO-BE 기준' 등으로 적었다. AS-IS 와 다르지만 허용하는 차이다. rule_draft 에 다른 화면에도 쓸 수 있는 일반 규칙 한 문장(대상·조건·허용하는 차이)을 쓴다. 이미 등록된 룰이면 action 에 그 번호를 적는다.
- 결함유지: 원문을 다시 보니 TO-BE 가 AS-IS 와 다르고 허용 룰이 없다. '확인 필요'로 적힌 의견은 원문 재점검 결과에 따라 엔진오판 또는 결함유지로 가린다. answer 에 재현 조건과 차이를 적는다.
- 질문답: 사용자가 물었다(무엇이 오류인지, 어느 칸·라벨인지, 왜 이 판정인지). answer 에 화면 위치(탭·그리드·컬럼·조회조건 이름)와 AS-IS·TO-BE 값을 들어 답한다.
- 메모: 처리할 것이 없는 기록(중복 제거 요청 등은 action 에 그대로 옮긴다).
- 확인불가: 원문만으로 가릴 수 없다. answer 에 무엇을 확인해야 하는지 적는다.

## 근거 규칙(기계가 확인한다)
- evidence 한 건 = {{"ref":"<경로>:<줄>","quote":"<그 줄 원문 일부를 글자 그대로>"}}. Read 로 연 파일에서 본 줄만 적는다.
- 엔진오판·결함유지는 AS-IS 원문 줄(GSCM/ 또는 DB_DDL/) 인용이 있어야 한다. 근거를 못 찾으면 확인불가.
- 주석 처리된 코드·호출되지 않는 메서드는 AS-IS 동작이 아니다.

## 문장 규칙(action·rule_draft·answer)
- 업무 담당자가 읽는 한국어. 수식어·추측 어미·줄표·굵은 글씨 없이, 컬럼명·버튼명·건수·소스 줄을 적는다. answer 는 4문장 이내.
- 검사기 내부 표기(규칙 ID, 검증 ID)는 answer 에 쓰지 않는다.
"""

PROMPT_TAIL = """
## 출력 — 마지막 메시지에 JSON 하나만(설명 문장·코드펜스 없이). items 는 위 의견 전부를 row_id 로 하나씩.
{"items":[{"row_id":"…","class":"엔진오판|룰등록|결함유지|질문답|메모|확인불가","action":"…","rule_draft":"…","answer":"…","evidence":[{"ref":"경로:줄","quote":"원문"}]}]}"""


def build_prompt(mid, ctx, chunk):
    head = PROMPT_HEAD.format(mid=mid, asis_id=ctx['asis_id'], asis_files=' · '.join(ctx['asis_files']) or '(GSCM/ 에서 화면 ID 로 Glob)', facts_dir=ctx['facts_dir'],
                              page_dir=ctx['page_dir'] or '(nscm-fe/features/**/pages 에서 화면 ID 로 Grep)', verify_dir=ctx['verify_dir'])
    items = []
    for r, op, mres in chunk:
        b = llm_review.row_brief(r); b['machine_result'] = mres; b['user_opinion'] = op[:900]
        items.append(b)
    parts = [head]
    for rid in sorted({r.get('rule_id') or '' for r, _, _ in chunk}):
        rl = llm_review.rules_for(rid)
        if rl:
            parts += [f'## 규칙 {rid} 에 걸린 TO-BE 룰(이미 등록)', *['- ' + x for x in rl], '']
    return '\n'.join(parts + ['## 처리할 의견(machine_result = 검사엔진 판정 · user_opinion = 사용자가 적은 글)', json.dumps(items, ensure_ascii=False, indent=1), PROMPT_TAIL])


def decide(r, op, it, mres):
    cls = it.get('class') if it.get('class') in CLASSES else '확인불가'
    evs = [e for e in (it.get('evidence') or []) if isinstance(e, dict)][:6]
    chk = [(llm_call.verify_quote(e.get('ref'), e.get('quote'))[0], str(e.get('ref') or ''), e.get('quote')) for e in evs]
    ok_asis = any(c[0] and llm_review.is_asis_ref(c[1]) for c in chk)
    if cls in ('엔진오판', '결함유지') and not ok_asis:
        cls_note = f'(원 구분 {cls} — AS-IS 원문 인용 미확인)'; cls = '확인불가'
    else:
        cls_note = ''
    good = [c for c in chk if c[0]] or chk
    q = lambda v: (' | '.join(map(str, v)) if isinstance(v, list) else str(v or ''))
    f = lambda k, n: re.sub(r'[\r\n]+', ' ', str(it.get(k) or '')).strip()[:n]
    return {'row_id': r['row_id'], 'op_hash': op_hash(r['row_id'], op), 'opinion': re.sub(r'\s+', ' ', op)[:500], 'class': cls, 'action': (f('action', 500) + (' ' + cls_note if cls_note else '')).strip(),
            'rule_draft': f('rule_draft', 400), 'answer': f('answer', 800), 'evidence_ref': ' ; '.join(c[1] for c in good)[:400], 'evidence_quote': ' ; '.join(q(c[2]) for c in good)[:600],
            'verified': 'Y' if any(c[0] for c in chk) else 'N', 'status': 'open' if (cls in OPEN_CLASSES and mres in llm_review.TARGET) else 'closed', 'at': llm_call.now()}


def run(mid, dry=False, from_file=None):
    d = P('Doc', 'verify', mid)
    rows = llm_review.read_csv(os.path.join(d, 'verify_ledger.csv'))
    if not rows:
        print(f'[의견 처리] 원장 없음(Doc/verify/{mid}/verify_ledger.csv) — 첫 CheckList 뒤부터 처리'); return 0
    base = llm_review.base_load(mid)
    led = {r['row_id']: r for r in rows}
    ops = collect_opinions(mid)
    prev = llm_review.read_csv(os.path.join(d, 'opinion_intake.csv'))
    done = {(x['row_id'], x['op_hash']): x for x in prev}
    live, todo, closed = [], [], 0
    for rid, op in sorted(ops.items()):
        r = led.get(rid)
        if not r:
            continue
        mres = machine_result(r, base)
        k = (rid, op_hash(rid, op))
        if k in done:
            x = dict(done[k])
            st = 'open' if (x.get('class') in OPEN_CLASSES and mres in llm_review.TARGET) else 'closed'   # 검사엔진이 고쳐져 판정이 바뀌었으면 닫는다
            closed += 1 if (x.get('status') == 'open' and st == 'closed') else 0
            x['status'] = st; live.append(x); continue
        if mres in llm_review.TARGET:
            todo.append((r, op, mres))
    print(f'[의견 처리] 사용자의견 {len(ops)}건(원장에 있는 행 {sum(1 for k in ops if k in led)}) · 처리 기록 {len(live)}건(이번에 닫힘 {closed}) · 새로 처리할 의견 {len(todo)}건', flush=True)
    if dry:
        for r, op, mres in todo[:40]:
            print(f"  {r['row_id']} [{r.get('rule_id')}·{mres}] {re.sub(chr(10), ' ', op)[:100]}")
        return 0
    n = max(1, int(llm_call.cfg().get('llmReviewBatch') or 6))
    todo.sort(key=lambda x: (x[0].get('rule_id') or '', x[0]['row_id']))
    ch = [todo[i:i + n] for i in range(0, len(todo), n)]
    ctx = llm_review.screen_ctx(mid) if ch else {}
    from_data = llm_call.parse_json(open(from_file, encoding='utf-8-sig').read()) if from_file else None
    cost, failed = 0.0, 0
    for i, g in enumerate(ch, 1):
        if from_data is not None:
            res = {'ok': True, 'data': from_data, 'cost': 0.0, 'why': ''}
        else:
            print(f'  · 사용자의견 처리 묶음 {i}/{len(ch)} — {len(g)}건', flush=True)
            res = llm_call.ask(mid, 'opinion', build_prompt(mid, ctx, g), rows=len(g))
        if not res['ok']:
            failed += 1
            print(f"[WARN] 사용자의견 묶음 {i} 결과 없음 — {res['why']} · 다음 실행에 다시 처리", flush=True); continue
        cost += float(res.get('cost') or 0)
        items = {str(it.get('row_id') or ''): it for it in ((res['data'] or {}).get('items') or []) if isinstance(it, dict)}
        for r, op, mres in g:
            if r['row_id'] in items:
                live.append(decide(r, op, items[r['row_id']], mres))
    with open(os.path.join(d, 'opinion_intake.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS, extrasaction='ignore', quoting=csv.QUOTE_ALL)
        w.writeheader(); w.writerows(live)
    by = {}
    for x in live:
        by[x['class']] = by.get(x['class'], 0) + 1
    op_n = sum(1 for x in live if x['status'] == 'open')
    json.dump({'menu_id': mid, 'at': llm_call.now(), 'opinions': len(ops), 'records': len(live), 'open': op_n, 'by_class': by, 'failed_calls': failed, 'cost': cost},
              open(os.path.join(d, 'opinion_intake.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f"[의견 처리] 기록 {len(live)}건 · 엔진 보완·룰 등록 대상(열림) {op_n}건 · 구분 " + ' · '.join(f'{k} {v}' for k, v in sorted(by.items())) + f' · 비용 ${cost:.4f}', flush=True)
    return 0


def selftest():
    ok = True

    def chk(name, cond):
        nonlocal ok
        print(f"  [{'OK' if cond else 'FAIL'}] {name}")
        ok = ok and bool(cond)
    chk('의견 해시 — 공백 차이 무시', op_hash('V-1', '오류  아님\n확인') == op_hash('V-1', '오류 아님 확인') and op_hash('V-1', 'a') != op_hash('V-2', 'a'))
    chk('엔진 판정 — 사용자판정 행은 원판정', machine_result({'row_id': 'V-1', 'result': 'PASS', 'tobe_ref': '수동 사용자판정(CheckList)', 'note': 'x | 원판정:FAIL | 사용자의견:y'}) == 'FAIL')
    chk('엔진 판정 — 일반 행', machine_result({'row_id': 'V-1', 'result': '판정필요', 'tobe_ref': 'E2E', 'note': ''}) == '판정필요')
    chk('엔진 판정 — AI 검토 행은 반영 전 값', machine_result({'row_id': 'V-1', 'result': 'PASS', 'tobe_ref': llm_review.AI_REF, 'note': ''}, {'V-1': {'result': 'FAIL'}}) == 'FAIL')
    me = os.path.relpath(os.path.abspath(__file__), ROOT).replace(os.sep, '/')
    r0 = {'row_id': 'V-1', 'rule_id': 'A1', 'result': 'FAIL', 'evidence': 'x'}
    d = decide(r0, '오류 아님', {'class': '엔진오판', 'action': 'a', 'evidence': [{'ref': me + ':1', 'quote': 'coding: utf-8'}]}, 'FAIL')
    chk('엔진오판 — AS-IS 원문 인용 없으면 확인불가', d['class'] == '확인불가' and d['status'] == 'closed')
    d = decide(r0, 'TO-BE RULE', {'class': '룰등록', 'rule_draft': '규칙', 'evidence': []}, 'FAIL')
    chk('룰등록 — 열림', d['class'] == '룰등록' and d['status'] == 'open')
    d = decide(r0, 'TO-BE RULE', {'class': '룰등록', 'rule_draft': '규칙'}, 'PASS')
    chk('룰등록 — 엔진이 이미 PASS 면 닫힘', d['status'] == 'closed')
    d = decide(r0, '어느 칸?', {'class': '질문답', 'answer': '답\n둘째 줄'}, 'FAIL')
    chk('질문답 — 닫힘 · 줄바꿈 제거', d['status'] == 'closed' and '\n' not in d['answer'])
    p = build_prompt('ZZZ0000', {'asis_id': 'Z', 'asis_files': [], 'page_dir': '', 'facts_dir': 'f', 'verify_dir': 'v'}, [(r0, '오류 아님', 'FAIL')])
    chk('프롬프트 — 의견 포함', '"user_opinion": "오류 아님"' in p)
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        return selftest()
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id'); ap.add_argument('--dry', action='store_true'); ap.add_argument('--from', dest='from_file')
    a = ap.parse_args()
    if not (a.dry or a.from_file) and not llm_call.enabled('opinion'):
        print('[의견 처리] 꺼짐(harness.json llmReview·llmReviewKinds) — 건너뜀'); return 0
    return run(a.menu_id.upper(), dry=a.dry, from_file=a.from_file)


if __name__ == '__main__':
    sys.exit(main())
