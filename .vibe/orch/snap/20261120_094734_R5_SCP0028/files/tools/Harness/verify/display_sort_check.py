# -*- coding: utf-8 -*-
"""콤보 후보 표시명 정렬(2026-11-03 엔진 갭 EG053)

  python tools/Harness/verify/display_sort_check.py <MENU_ID>   → Doc/verify/<ID>/display_sort.csv (eg_ingest 가 B3 행으로 반입)
  python tools/Harness/verify/display_sort_check.py --selftest   판정 변이 입증

  기준표 Doc/verify/display_sort_expect.csv — 문서가 표시명 순(숫자-영문-한글 · 대소문자 무시)을 확정한 화면·조건만 재다
  입력 Doc/verify/<ID>/combo_runtime.json 의 조회조건 후보(opts) · 전체 선택 항목은 제외 · 후보 없음 = ERROR
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
COLS = ['label', 'result', 'why']
RX_ALL = re.compile(r'^(SELECT ALL|ALL|전체)$', re.I)


def sort_key(s):
    """숫자 → 영문 → 그 밖(한글 등) · 같은 분류 안은 대소문자 무시"""
    t = str(s).strip()
    c = t[:1]
    cls = 0 if c.isdigit() else 1 if c.isascii() and c.isalpha() else 2
    return (cls, t.casefold())


def judge(label, opts):
    """FAIL = 첫 글자 분류(숫자→영문→한글)가 뒤집힘 — 문서가 정한 범위 · 같은 분류 안 어긋남은 기호·중간 글자 처리가 문서에 없어 확인 대상"""
    v = [x for x in opts if not RX_ALL.match(str(x).strip())]
    if not v:
        return 'ERROR', f"[측정 경로 없음] '{label}' 후보 없음"
    soft = None
    for a, b in zip(v, v[1:]):
        ka, kb = sort_key(a), sort_key(b)
        if ka[0] > kb[0]:
            return 'FAIL', f"'{label}' 후보 {len(v)}건 숫자-영문-한글 순 아님 — '{a}' 뒤에 '{b}'"
        if ka[0] == kb[0] and ka[1] > kb[1] and re.sub(r'\W', '', ka[1]) > re.sub(r'\W', '', kb[1]) and not soft:  # 공백·기호를 넣든 빼든 어긋날 때만(All Good < AllCell 은 정상)
            soft = (a, b)
    if soft:
        return 'ERROR', f"[확인 대상] '{label}' 후보 {len(v)}건 분류 순서는 맞음 · 같은 분류 안 어긋남 '{soft[0]}' 뒤에 '{soft[1]}'(기호·중간 글자 정렬 규칙 문서에 없음)"
    return 'PASS', f"'{label}' 후보 {len(v)}건 표시명 순"


def selftest():
    cases = [('정상', judge('L', ['SELECT ALL', '1X', 'abc', 'ABD', '가나'])[0], 'PASS'),
             ('영문이 숫자 앞', judge('L', ['abc', '1X'])[0], 'FAIL'),
             ('한글이 영문 앞', judge('L', ['가나', 'abc'])[0], 'FAIL'),
             ('대소문자 무시 어긋남', judge('L', ['ABD', 'abc'])[0], 'ERROR'),
             ('공백 포함 정상', judge('L', ['All Good', 'AllCell'])[0], 'PASS'),
             ('기호 넣든 빼든 어긋남', judge('L', ['C-Tech', 'C&T'])[0], 'ERROR'),
             ('대소문자 섞임 정상', judge('L', ['acer', 'ABS'][::-1])[0], 'PASS'),
             ('중간 글자 어긋남', judge('L', ['가나일', '가나B'])[0], 'ERROR'),
             ('후보 없음', judge('L', ['SELECT ALL'])[0], 'ERROR')]
    bad = 0
    for n, got, want in cases:
        k = got == want; bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {n} → {got}(기대 {want})")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main(mid):
    with open(os.path.join(ROOT, 'Doc', 'verify', 'display_sort_expect.csv'), encoding='utf-8-sig', newline='') as f:
        want = [r for r in csv.DictReader(f) if r['menu_id'] == mid]
    if not want:
        return 0
    res = []
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_runtime.json')
    search = json.load(open(p, encoding='utf-8-sig')).get('search', {}) if os.path.exists(p) else {}
    for w in want:
        x = next((v for k, v in search.items() if str(k).strip().lower() == w['label'].strip().lower()), None)
        r, why = judge(w['label'], (x or {}).get('opts') or [])
        res.append({'label': w['label'], 'result': r, 'why': f"{why} · 문서 {w['source']}"})
    with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'display_sort.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, COLS); w.writeheader(); w.writerows(res)
    for x in res:
        print(f"[display_sort] {mid} {x['label']}: {x['result']} {x['why']}")
    return 0


if __name__ == '__main__':
    if len(sys.argv) < 2: sys.exit(__doc__)
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
