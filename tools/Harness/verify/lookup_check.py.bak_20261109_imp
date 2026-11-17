# -*- coding: utf-8 -*-
"""Lookup 기반 셀 편집 후보 판정(2026-11-01 엔진 갭 EG066)

  python tools/Harness/verify/lookup_check.py <MENU_ID>   → Doc/verify/<ID>/lookup_check.csv (eg_ingest 가 B5 행으로 반입)
  python tools/Harness/verify/lookup_check.py --selftest   판정 변이 입증

  대상: AS-IS 원천에 Lookup 유형(리터럴)이 있는 그리드 콤보(combo_src) — 다른 원천이 섞이면 불일치는 ERROR
  실측: E2E 덤프 combo_runtime.json 의 신규행·기존행 후보 코드 ↔ TO-BE SCM_ADM_LOOKUP_MASTER_DETAIL(새로 조회)
  판정: 비활성(VALID_YN≠Y) 코드 후보 노출·기준에 없는 코드 = FAIL · 활성 코드 누락 = ERROR(화면 조건으로 좁힌 후보일 수 있음)
  한계: 코드 칸 = 후보와 가장 많이 겹치는 SEGMENT(유형마다 다름) · 덤프 시점의 행 상태 1건만 잰다
"""
import csv, json, os, re, sys
from asis_variant import is_cur  # 2026-11-09 T172: variant 'only' 화면(SSP 등 180) = 현행 — 판정 단일 원천

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
csv.field_size_limit(10 ** 8)
COLS = ['side', 'target', 'lookup_type', 'result', 'why', 'ref']


def judge(codes, active, inactive, other=frozenset()):
    codes = {c for c in codes if str(c).strip()}
    if not active and not inactive:
        return 'ERROR', '[측정 경로 없음] 기준 코드 0건 — Lookup 유형 확인 필요'
    if not codes:
        return 'ERROR', '[측정 경로 없음] 후보 코드 0건'
    bad = sorted(codes & (inactive - active))
    unknown = sorted(codes - active - inactive - set(other))
    if bad:
        return 'FAIL', f'비활성 코드 후보 노출 {len(bad)}건: {bad[:8]}'
    if unknown:
        return 'FAIL', f'기준 코드에 없는 후보 {len(unknown)}건: {unknown[:8]}'
    miss = sorted(c for c in active - codes if c not in ('-', '/'))  # 빈 값 센티널 행은 후보 대상이 아니다
    if miss:
        return 'ERROR', f'[확인 대상] 활성 코드 {len(miss)}건 후보에 없음(화면 조건으로 좁힌 후보일 수 있음): {miss[:8]}'
    return 'PASS', f'후보 {len(codes)}건 = 활성 코드 전부 · 비활성 0'


def code_sets(rows, codes):
    """기준 행(SEGMENT1~5, VALID) 중 화면 후보와 가장 많이 겹치는 SEGMENT 를 코드 칸으로 → (활성, 비활성, 그 밖의 칸 값, 칸 번호).
    코드 칸은 유형마다 다르다 — CUST_FCST_MEASURE 는 SEGMENT1 이 Division(2026-11-02 실측). 겹침이 없으면 SEGMENT1"""
    best = max(range(5), key=lambda k: (len(codes & {str(r[k]) for r in rows if r[k] is not None}), -k))
    a, i, o = set(), set(), set()
    for r in rows:
        if r[best] is not None and str(r[best]).strip():
            (a if r[5] == 'Y' else i).add(str(r[best]))
        for k in range(5):
            if k != best and r[k] is not None and str(r[k]).strip():
                o.add(str(r[k]))
    return a, i, o, best + 1


def selftest():
    A, I = {'a', 'b'}, {'x'}
    cases = [('정상', judge({'a', 'b'}, A, I), 'PASS'), ('비활성 노출', judge({'a', 'x'}, A, I), 'FAIL'), ('구코드·오타', judge({'a', 'zz'}, A, I), 'FAIL'), ('활성 누락', judge({'a'}, A, I), 'ERROR'), ('후보 0', judge(set(), A, I), 'ERROR'), ('기준 0', judge({'a'}, set(), set()), 'ERROR'), ('활성·비활성 겹침', judge({'a', 'b'}, A, {'a'}), 'PASS'), ('다른 SEGMENT 값', judge({'a', 'b', 'q'}, A, I, {'q'}), 'PASS'), ('센티널 행 제외', judge({'a', 'b'}, A | {'-'}, I), 'PASS')]
    R = [('81', 'P1', None, None, None, 'Y'), ('81', 'P2', None, None, None, 'Y'), ('40', 'P3', None, None, None, 'N')]
    x = code_sets(R, {'P1', 'P2'})
    cases += [('코드 칸 SEGMENT2', ('PASS' if x[3] == 2 and x[0] == {'P1', 'P2'} and x[1] == {'P3'} else 'FAIL', str(x)), 'PASS'), ('SEGMENT2 기준 판정', judge({'P1', 'P2'}, x[0], x[1], x[2]), 'PASS')]
    bad = 0
    for n, got, want in cases:
        ok = got[0] == want
        bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {n} → {got[0]}(기대 {want}) {got[1]}")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def lookup_of(r):
    # 공통 목록 SP(UP_FX_GetCommonDataList*)도 코드가 Lookup 유형인 경우가 많다(GetIncotermsType 등) — 유형 실재는 기준 테이블 조회로 가른다
    if not re.search('lookup|GetCommonDataList', (r.get('sp') or '') + (r.get('wrapper') or ''), re.I):
        return ''
    if re.fullmatch(r'[A-Za-z0-9_]+', r.get('code') or ''):  # local:GetLookupValues("코드", …) — facts_combosrc 가 code 칸에 둔다
        return r['code']
    try:
        for a in json.loads(r.get('args') or '[]'):
            m = re.fullmatch(r'"([A-Za-z0-9_]+)"', (a.get('expr') or '').strip())
            if m and re.search('lookup_type|type', a.get('n') or '', re.I):
                return m.group(1)
    except ValueError:
        pass
    m = re.search(r'Get\w*Lookup\w*\(\s*"([A-Za-z0-9_]+)"', r.get('code') or '')
    return m.group(1) if m else ''


def main(mid):
    fa = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid, 'combo_src.csv')
    fr = os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_runtime.json')
    out = os.path.join(ROOT, 'Doc', 'verify', mid, 'lookup_check.csv')
    if not os.path.exists(fa) or not os.path.exists(fr):
        print(f'[lookup_check] {mid}: combo_src 또는 combo_runtime 없음 — 생략')
        return 0
    src = list(csv.DictReader(open(fa, encoding='utf-8-sig', newline='')))
    by = {}
    for r in src:
        if r.get('target_kind') == 'GRID':
            by.setdefault(r['target'], []).append(r)
    rt = json.load(open(fr, encoding='utf-8')).get('grid') or {}
    from dbconn import connect
    res = []; nolk = set()
    # AS-IS 상수 → 컬럼(DMF0082 Incoterms → INCOTERMS) — 덤프 키는 TO-BE binding
    sys.path.insert(0, HERE)
    from facts_cellclear import const_map
    cmap = {}
    for f in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid, 'files.csv'), encoding='utf-8-sig', newline='')):
        if is_cur(f) and f['file'].endswith('.cs') and not f['file'].endswith('.Designer.cs'):
            for k, v in const_map(f['file'].replace('\\', '/')).items():
                cmap.setdefault(k, v)
    with connect('tobe') as cx:
        cur = cx.cursor()
        memo = {}
        for tgt, rows in sorted(by.items()):
            # SheetMeta 는 메타 원천 표시 행 — AS-IS 원천 종류 판단에서 뺀다(2026-11-01 전 화면 0건 원인)
            all_t = [lookup_of(r) for r in rows if r.get('method') != 'SheetMeta']
            types = {t for t in all_t if t}
            d = rt.get(tgt) or rt.get(cmap.get(tgt, ''))
            if not types or not d:
                continue
            lt = ','.join(sorted(types))
            for t in types:
                if t not in memo:
                    cur.execute('select segment1, segment2, segment3, segment4, segment5, valid_yn from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = :1', [t])
                    memo[t] = cur.fetchall()
                    if not memo[t]:
                        nolk.add(t)
            base = [r for t in types for r in memo[t]]
            if not base:  # 전용 목록 코드 — 이 기준으로 잴 수 없다
                continue
            # 다른 원천(비 Lookup·기준 없는 코드)이 섞이면 후보 기준이 하나가 아니다 — 불일치를 FAIL 로 올리지 않는다
            mixed = any(not t for t in all_t) or any(not memo[t] for t in types)
            for side, key in (('신규행', 'newRow'), ('기존행', 'existing')):
                nr = d.get(key) or {}
                if not nr.get('items'):
                    continue
                codes = {str(it.get('c')) for it in nr['items']}
                a, i, o, seg = code_sets(base, codes)
                r, why = judge(codes, a, i, o)
                if mixed and r in ('FAIL', 'ERROR') and not why.startswith('[측정'):
                    r, why = 'ERROR', '[확인 대상] 다른 원천이 섞인 콤보 — ' + why
                res.append({'side': side, 'target': tgt, 'lookup_type': lt, 'result': r, 'why': f'SEGMENT{seg} 기준 · {why}', 'ref': rows[0].get('ref', '')[:120]})
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(res)
    print(f'[lookup_check] {mid}: {len(res)}건 ' + str({k: sum(1 for x in res if x["result"] == k) for k in sorted({x["result"] for x in res})}) + (f' · Lookup 기준 없는 전용 목록 {sorted(nolk)}' if nolk else '') + f' → {out}')
    return 0


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
