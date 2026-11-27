# -*- coding: utf-8 -*-
"""dedup_same_measure.py — 같은 측정으로 판정된 행을 CheckList 에서 대표 1행으로 (2026-11-26 사용자 'SCP0005 CheckList 2,000건 넘음, 중복 제거 보완')

SCP0005 v13 실측(2026-11-26 10:3x): 규칙·결과·증거 전문·TO-BE 위치가 같은 묶음 89개 415행. 그중 대상이 서로 다른 확인(컬럼별 H1 정렬 등)은 중복이 아니다.
아래 두 경우만 대표 1행으로 묶는다. 묶인 행은 make_verify_docs '중복 정리' 시트로 옮기고 원장은 바꾸지 않는다.
  1) 같은 대상: 대상에서 '호출 위치(팝업 트리거)'와 '표본 키(저장 감사 칸 TABLE|key)'를 뺀 값이 같음
     예) 'SCP0005 팝업 SCM0002_CitybyCountry BTN:btnFromSrch TITLE' = '… CELL:TO_CITY TITLE' (같은 팝업, 호출 위치만 다름)
  2) 요구 행: 출처 GENERAL(다른 화면 결함 유형) · CONFIRMED(확정 요구) · DEFECT(이 화면 결함) 행이 같은 묶음의 화면 행과 같은 측정으로 판정됨
묶지 않는 경우: 결과 다름 · 증거 전문 다름 · TO-BE 위치 다름 · 해당없음 · 미검증(ERROR) · 사용자판정·사용자의견·CheckList Remark 가 있는 행
  python tools/Harness/verify/dedup_same_measure.py --selftest
  python tools/Harness/verify/dedup_same_measure.py <ID>     원장 기준 묶음 수만 출력(파일 안 씀)
"""
import csv, os, re, sys

REQ_SOURCES = {'GENERAL', 'CONFIRMED', 'DEFECT'}
SKIP_RESULTS = {'NA', '해당없음', 'ERROR', ''}
RX_POPUP = re.compile(r'^(\S+ 팝업 \S+) (?:BTN|CELL|COND|MENU|GRID|KEY|EVT|TAB|COMBO|CHK|TXT)[:\w.\-]*(?: (.*))?$')
RX_SAMPLE = re.compile(r'^(.* 저장 감사 칸 [^|]+)\|.*$')


def target_key(t):
    """대상 → 호출 위치·표본 키를 뺀 비교용 키"""
    t = ' '.join((t or '').split())
    m = RX_POPUP.match(t)
    if m:
        return f"{m.group(1)} · {m.group(2) or ''}".strip()
    m = RX_SAMPLE.match(t)
    if m:
        return m.group(1)
    return t


def groups(rows, protected=frozenset()):
    """rows(원장 행 dict: row_id · rule_id · result · evidence · tobe_ref · target · source) → [(구성원 행, 대표 행)]"""
    by = {}
    for r in rows:
        if (r.get('result') or '') in SKIP_RESULTS or r['row_id'] in protected:
            continue
        ev = (r.get('evidence') or '').strip()
        if not ev:
            continue
        by.setdefault((r.get('rule_id') or '', r.get('result') or '', ev, (r.get('tobe_ref') or '').strip()), []).append(r)
    out = []
    for mem in by.values():
        if len(mem) < 2:
            continue
        # 1) 같은 대상 키끼리
        sub = {}
        for r in mem:
            if (r.get('source') or '') not in REQ_SOURCES:
                sub.setdefault(target_key(r.get('target')), []).append(r)
        reps = []
        for k, v in sub.items():
            v = sorted(v, key=lambda x: x['row_id'])
            reps.append(v[0])
            out += [(x, v[0]) for x in v[1:]]
        # 2) 요구 행 = 화면 행이 있으면 그 대표로, 없으면 요구 행끼리 첫 행으로(대상 키가 하나일 때만)
        req = sorted([r for r in mem if (r.get('source') or '') in REQ_SOURCES], key=lambda x: x['row_id'])
        if req:
            if len(reps) == 1:
                out += [(x, reps[0]) for x in req]
            elif not reps:
                out += [(x, req[0]) for x in req[1:]]
    return out


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    chk('팝업 호출 위치 뺌', target_key('SCP0005 팝업 SCM0002_CitybyCountry BTN:btnFromSrch TITLE') == target_key('SCP0005 팝업 SCM0002_CitybyCountry CELL:TO_CITY TITLE'))
    chk('팝업 확인 항목 다르면 다른 키', target_key('SCP0005 팝업 X BTN:a TITLE') != target_key('SCP0005 팝업 X BTN:a SORT'))
    chk('저장 감사 표본 키 뺌', target_key('SCP0005 저장 감사 칸 T|9917') == target_key('SCP0005 저장 감사 칸 T|7305'))
    chk('컬럼 대상은 그대로', target_key('Distribution Route.A_COUNTRY (Country)') != target_key('Distribution Route.A_PORT_CODE (Port)'))
    E = {'rule_id': 'H1', 'result': 'PASS', 'evidence': 'AS-IS center ↔ TO-BE center', 'tobe_ref': 'META'}
    g = groups([dict(E, row_id='V-1', target='S.A (a)', source='COLUMN'), dict(E, row_id='V-2', target='S.B (b)', source='COLUMN')])
    chk('대상 다른 컬럼 행(같은 증거) = 묶지 않음', g == [])
    P = {'rule_id': 'H5', 'result': 'PASS', 'evidence': "제목 'Region Popup'", 'tobe_ref': 'E2E @eg', 'source': 'RULE_SCREEN'}
    g = groups([dict(P, row_id='EG-2', target='S 팝업 C BTN:b TITLE'), dict(P, row_id='EG-1', target='S 팝업 C CELL:c TITLE')])
    chk('같은 팝업 호출 위치만 다름 = 대표 1행', [(a['row_id'], b['row_id']) for a, b in g] == [('EG-2', 'EG-1')])
    S = {'rule_id': 'H4', 'result': 'PASS', 'evidence': '가로 스크롤 없음', 'tobe_ref': 'E2E @trace'}
    rows = [dict(S, row_id='V-9', target='S 화면', source='RULE_SCREEN'), dict(S, row_id='V-1', target='[X 결함 유형] a', source='GENERAL'), dict(S, row_id='V-2', target='b', source='CONFIRMED')]
    g = groups(rows)
    chk('요구 행 = 화면 행 대표로', sorted((a['row_id'], b['row_id']) for a, b in g) == [('V-1', 'V-9'), ('V-2', 'V-9')])
    chk('사용자 의견 있는 행은 남김', sorted(a['row_id'] for a, b in groups(rows, frozenset({'V-2'}))) == ['V-1'])
    chk('결과 다르면 묶지 않음', groups([dict(S, row_id='V-9', target='S 화면', source='RULE_SCREEN'), dict(S, row_id='V-1', target='a', source='GENERAL', result='FAIL')]) == [])
    chk('해당없음·미검증은 묶지 않음', groups([dict(S, row_id='V-1', target='a', source='GENERAL', result='NA'), dict(S, row_id='V-2', target='b', source='GENERAL', result='NA')]) == [])
    rows2 = [dict(S, row_id='V-9', target='S 화면', source='RULE_SCREEN'), dict(S, row_id='V-8', target='S 팝업', source='RULE_SCREEN'), dict(S, row_id='V-1', target='a', source='GENERAL')]
    chk('화면 행이 여럿(대상 다름)이면 요구 행 대표를 정하지 않음', groups(rows2) == [])
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    if len(sys.argv) > 1:
        root = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
        csv.field_size_limit(10 ** 9)
        m = sys.argv[1].upper()
        rows = list(csv.DictReader(open(os.path.join(root, 'Doc', 'verify', m, 'verify_ledger.csv'), encoding='utf-8-sig')))
        g = groups(rows)
        print(f'{m} 원장 {len(rows)}행 · 같은 측정 묶음으로 옮길 행 {len(g)} · 대표 {len({b["row_id"] for a, b in g})}')
