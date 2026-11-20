# -*- coding: utf-8 -*-
"""CheckList 설명 문장 작성 — '조치 필요'·'판정 필요' 시트의 설명 칸 정리 문장을 Claude 가 쓴다 (2026-11-19 사용자 지시 · 적용 단계 '설명 문장 작성')
   지금까지: 문서 생성 로그 '[설명 정리 필요] N건' 이 나오면 대화 세션이 Doc/verify/<ID>/action_summary.csv 를 따로 썼다(50_DOC_STYLE.md 'CheckList 설명 칸 틀' 절차 1~5).

  python tools/Harness/verify/llm_desc.py <MENU_ID>                정리 문장이 없는 행(no_summary.json)을 작성해 action_summary.csv 에 덧붙임
  python tools/Harness/verify/llm_desc.py <MENU_ID> --dry          대상·묶음만 출력
  python tools/Harness/verify/llm_desc.py <MENU_ID> --from <json>  Claude 호출 없이 답 JSON 반영(배관 시험)
  python tools/Harness/verify/llm_desc.py --selftest

  입력  Doc/verify/<ID>/no_summary.json(make_verify_docs.py 가 기록 — 정리 문장이 없는 행과 묶인 행) · 원장 · llm_review.csv(판정 검토 사유·근거)
  출력  Doc/verify/<ID>/action_summary.csv 에 행 추가(열 row_id, group, title, tag, where, asis, tobe, gap, action). 이미 문장이 있는 행은 건드리지 않는다.
  규칙  문장은 doc_style(문장 규칙 검사) 위반 0 인 것만 쓴다. 위반이 있으면 doc_style.clean_text 로 고치고, 그래도 남으면 그 행은 쓰지 않는다(로그에 남김).
        같은 원인 행은 group 을 같게 하고 첫 행에만 문장을 쓴다.
  종료코드 0 · 쓴 행이 있으면 마지막 줄 'DESC_WRITTEN n'(run_verify 가 문서 단계를 한 번 더 돌릴지 판단)
"""
import argparse
import csv
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, 'tools', 'Docs'))
import llm_call  # noqa: E402
import llm_review  # noqa: E402

csv.field_size_limit(10 ** 8)
SCOLS = ['row_id', 'group', 'title', 'tag', 'where', 'asis', 'tobe', 'gap', 'action']
TEXT_COLS = ('title', 'where', 'asis', 'tobe', 'gap', 'action')


def P(*a):
    return os.path.join(ROOT, *a)


def style_bad(s):
    """문장 규칙 위반 목록(없으면 빈 목록) — doc_style 을 못 읽으면 검사하지 않는다"""
    try:
        import doc_style
        return [str(v) for v in (doc_style.check_text(s) or [])]
    except Exception:
        return []


def style_clean(s):
    try:
        import doc_style
        return doc_style.clean_text(s)
    except Exception:
        return s


PROMPT_HEAD = """너는 NSCM 전환 프로젝트의 CheckList 문서 작성자다. 화면 {mid} 의 CheckList '조치 필요'·'판정 필요' 시트에 실릴 설명 문장을 쓴다.
아래 행마다 증거, AS-IS 소스, TO-BE 소스를 직접 읽고 확인한 내용만 적는다. 파일을 고치거나 명령을 실행하지 않는다(Read·Glob·Grep 만). 답은 마지막에 JSON 하나만.

## 원천
- AS-IS 화면 ID {asis_id} · 소스: {asis_files}
- TO-BE 화면 소스: {page_dir}/ · 검증 산출물: {verify_dir}/ · AS-IS 사실 추출본: {facts_dir}/

## 설명 칸 틀(행마다)
- title: 오류 한 줄 요약(명사로 끝남. 예 "Plant 후보에 전극 외 Plant 표시")
- tag: "위치 / 성격 / 수정 대상" — 위치(조회조건 · 버튼 · 그리드 컬럼 · 팝업 · 저장 · 메뉴·권한 · 화면 공통) / 성격(표시 · 로직 · 후보값 · 데이터 등) / 수정 대상(FE · DB · FE+DB · 공통 FE · 확인 필요)
- where: 화면에서의 위치(탭, 그리드, 컬럼, 조회조건 항목, 버튼 이름)
- asis: AS-IS 동작과 값(조건, 건수, 화면 소스 줄)
- tobe: TO-BE 실측 동작과 값(조건, 건수, 파일:줄)
- gap: 무엇이 다른지 한 줄. 계정·Division 차이, 같은 동작인 다른 조건
- action: 조치(고칠 곳 또는 정할 것). 모르면 빈 값
- group: 같은 원인인 행은 같은 group 이름(영문 대문자·밑줄). 같은 group 의 둘째 행부터는 title·tag·where·asis·tobe·gap·action 을 빈 값으로 둔다.

## 문장 규칙(지키지 않은 행은 버려진다)
- 업무 담당자가 읽는 문장. 개조식으로 끝낸다(~함, ~임, ~없음, 명사 종결). '~합니다' 금지.
- 수식어(매우·다소·실제로·모두·반드시·정확히·다양한·적절히) 금지. 정도는 수치로.
- 번역투('~에 대한'·'~에 의해'·'~로 인해'·'~를 통해'·'~의 경우'·'~를 수행'·'~것으로 보인다') 금지. 추측 어미('~일 수 있다'·'~로 판단된다') 금지. 확인 못 했으면 '미확인'.
- 줄표(—), 굵은 글씨, 이모지, 'A가 아니라 B' 틀 금지. 접속 부사(또한·따라서·즉)로 시작 금지.
- 검사기 표기(규칙 ID, 평가 불가 0, r1, EG377, 검증 ID 같은 엔진 내부 값)를 쓰지 않는다. 화면 이름, 컬럼 이름, 조건 값, 건수, 계정, 소스 줄을 쓴다.
- AS-IS·TO-BE 원문 라벨·메시지는 따옴표 안에 그대로 옮긴다.
"""

PROMPT_TAIL = """
## 출력 — 마지막 메시지에 JSON 하나만(설명 문장·코드펜스 없이). items 는 위 행 전부를 row_id 로 하나씩.
{"items":[{"row_id":"…","group":"…","title":"…","tag":"위치 / 성격 / 수정 대상","where":"…","asis":"…","tobe":"…","gap":"…","action":"…"}]}"""


def build_prompt(mid, ctx, chunk, review):
    head = PROMPT_HEAD.format(mid=mid, asis_id=ctx['asis_id'], asis_files=' · '.join(ctx['asis_files']) or '(GSCM/ 에서 화면 ID 로 Glob)', facts_dir=ctx['facts_dir'],
                              page_dir=ctx['page_dir'] or '(nscm-fe/features/**/pages 에서 화면 ID 로 Grep)', verify_dir=ctx['verify_dir'])
    items = []
    for r, same in chunk:
        b = llm_review.row_brief(r); b['same_rows'] = same
        rv = review.get(r['row_id'])
        if rv and rv.get('class') in llm_review.CLASSES:
            b['review'] = {'class': rv.get('class'), 'reason': rv.get('reason', ''), 'evidence_ref': rv.get('evidence_ref', '')}
        items.append(b)
    return '\n'.join([head, '## 작성할 행(same_rows = 이 행에 묶여 한 줄로 보이는 다른 행 — 따로 쓰지 않는다)', json.dumps(items, ensure_ascii=False, indent=1), PROMPT_TAIL])


def accept(it):
    """답 1건 → (정리 행 또는 None, 사유)"""
    row = {k: re.sub(r'[\r\n]+', ' ', str(it.get(k) or '')).strip() for k in SCOLS}
    row['group'] = re.sub(r'[^A-Za-z0-9_]', '_', row['group'])[:40]
    if not row['title']:
        return (row, '') if row['group'] else (None, '제목 없음')
    for k in TEXT_COLS:
        if row[k] and style_bad(row[k]):
            row[k] = style_clean(row[k])
    bad = [f'{k}: {v}' for k in TEXT_COLS for v in style_bad(row[k])[:2]]
    if bad:
        return None, '문장 규칙 위반 — ' + ' / '.join(bad)[:200]
    if not (row['asis'] and row['tobe'] and row['gap']):
        return None, 'AS-IS·TO-BE·GAP 중 빈 칸'
    return row, ''


def run(mid, dry=False, from_file=None):
    d = P('Doc', 'verify', mid)
    try:
        need = json.load(open(os.path.join(d, 'no_summary.json'), encoding='utf-8'))
    except (OSError, ValueError):
        print(f'[설명 문장] 대상 목록 없음(Doc/verify/{mid}/no_summary.json — 문서 생성 뒤에 실행)'); return 0
    have = {x['row_id']: x for x in llm_review.read_csv(os.path.join(d, 'action_summary.csv'))}
    led = {r['row_id']: r for r in llm_review.load_rows(mid)}
    todo = [(led[n['row_id']], n.get('same') or []) for n in need if n['row_id'] in led and not (have.get(n['row_id'], {}).get('title') or have.get(n['row_id'], {}).get('group'))]
    c = llm_call.cfg(); n = max(1, int(c.get('llmReviewBatch') or 6))
    todo.sort(key=lambda x: (x[0].get('rule_id') or '', x[0]['row_id']))
    ch = [todo[i:i + n] for i in range(0, len(todo), n)]
    print(f'[설명 문장] 정리 문장 없는 행 {len(need)} · 작성 대상 {len(todo)} · 묶음 {len(ch)}개', flush=True)
    if dry or not todo:
        if not todo:
            print('DESC_WRITTEN 0')
        return 0
    ctx = llm_review.screen_ctx(mid)
    review = {x['row_id']: x for x in llm_review.read_csv(os.path.join(d, 'llm_review.csv'))}
    from_data = llm_call.parse_json(open(from_file, encoding='utf-8-sig').read()) if from_file else None
    new, skipped, cost = [], [], 0.0
    for i, g in enumerate(ch, 1):
        if from_data is not None:
            res = {'ok': True, 'data': from_data, 'cost': 0.0, 'why': ''}
        else:
            print(f'  · 설명 문장 작성 묶음 {i}/{len(ch)} — {len(g)}행', flush=True)
            res = llm_call.ask(mid, 'desc', build_prompt(mid, ctx, g, review), rows=len(g))
        if not res['ok']:
            print(f"[WARN] 설명 문장 묶음 {i} 결과 없음 — {res['why']} · 생성기 임시 문장 유지", flush=True)
            skipped += [(r['row_id'], res['why'][:80]) for r, _ in g]; continue
        cost += float(res.get('cost') or 0)
        items = {str(it.get('row_id') or ''): it for it in ((res['data'] or {}).get('items') or []) if isinstance(it, dict)}
        for r, _ in g:
            it = items.get(r['row_id'])
            row, why = accept(it) if it else (None, '답에 이 행이 없음')
            if row:
                row['row_id'] = r['row_id']; new.append(row)
            else:
                skipped.append((r['row_id'], why))
    # 같은 group 의 문장 있는 행이 하나도 없으면(대표 행이 버려짐) 그 group 의 빈 행도 버린다
    titled = {x['group'] for x in new if x['title'] and x['group']} | {(x.get('group') or '') for x in have.values() if (x.get('title') or '').strip()}
    keep = [x for x in new if x['title'] or x['group'] in titled]
    skipped += [(x['row_id'], '같은 묶음의 대표 문장이 없음') for x in new if x not in keep]
    if keep:
        p = os.path.join(d, 'action_summary.csv'); first = not os.path.exists(p)
        with open(p, 'a', encoding='utf-8-sig' if first else 'utf-8', newline='') as f:
            w = csv.DictWriter(f, fieldnames=SCOLS, extrasaction='ignore')
            if first:
                w.writeheader()
            w.writerows(keep)
    for rid, why in skipped:
        print(f'  [설명 미작성] {rid} — {why}', flush=True)
    print(f'[설명 문장] 작성 {len(keep)}행 · 미작성 {len(skipped)}행 · 비용 ${cost:.4f}', flush=True)
    print(f'DESC_WRITTEN {len(keep)}', flush=True)
    return 0


def selftest():
    ok = True

    def chk(name, cond):
        nonlocal ok
        print(f"  [{'OK' if cond else 'FAIL'}] {name}")
        ok = ok and bool(cond)
    good = {'row_id': 'V-1', 'group': 'plant-shop', 'title': 'Plant 후보에 전극 외 Plant 표시', 'tag': '조회조건 / 후보값 / FE', 'where': '조회조건 Plant',
            'asis': 'Electrode 일 때 Plant 7건 표시', 'tobe': 'Electrode 일 때 Plant 8건 표시', 'gap': 'Plant 후보 필터 누락', 'action': ''}
    r, w = accept(good)
    chk('정상 행 수락 · group 정리', r is not None and r['group'] == 'plant_shop')
    r, w = accept(dict(good, asis=''))
    chk('AS-IS 빈 칸 거부', r is None)
    r, w = accept({'row_id': 'V-2', 'group': 'PLANT_SHOP'})
    chk('묶음 둘째 행(문장 없음) 수락', r is not None and not r['title'])
    r, w = accept({'row_id': 'V-3'})
    chk('제목·묶음 없음 거부', r is None)
    r, w = accept(dict(good, title='Plant 후보\n표시'))
    chk('줄바꿈 제거', r is not None and '\n' not in r['title'])
    p = build_prompt('ZZZ0000', {'asis_id': 'Z', 'asis_files': [], 'page_dir': '', 'facts_dir': 'f', 'verify_dir': 'v'}, [({'row_id': 'V-1', 'rule_id': 'A1', 'result': 'FAIL', 'evidence': 'x'}, ['V-9'])], {})
    chk('프롬프트 — 행·묶인 행 포함', '"row_id": "V-1"' in p and 'V-9' in p)
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        return selftest()
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id'); ap.add_argument('--dry', action='store_true'); ap.add_argument('--from', dest='from_file')
    a = ap.parse_args()
    if not (a.dry or a.from_file) and not llm_call.enabled('desc'):
        print('[설명 문장] 꺼짐(harness.json llmReview·llmReviewKinds) — 건너뜀'); print('DESC_WRITTEN 0'); return 0
    return run(a.menu_id.upper(), dry=a.dry, from_file=a.from_file)


if __name__ == '__main__':
    sys.exit(main())
