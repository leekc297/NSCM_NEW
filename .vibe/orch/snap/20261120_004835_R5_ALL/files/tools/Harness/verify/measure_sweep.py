# -*- coding: utf-8 -*-
"""Measure 기준 코드 정합 점검(2026-11-02 엔진 갭 EG453)

  python tools/Harness/verify/measure_sweep.py <MENU_ID>   → Doc/verify/<ID>/measure_sweep.csv (eg_ingest 가 N1 행으로 반입)
  python tools/Harness/verify/measure_sweep.py --all        전역 — MEASURE 이름의 Lookup 유형 전체 표기 유사 점검
  python tools/Harness/verify/measure_sweep.py --selftest   판정 변이 입증

  대상: 화면 콤보 원천(combo_src) 중 이름에 MEASURE 가 든 Lookup 유형 · 데이터 = TO-BE 화면 PKG 본문이 읽는 테이블 중 MEASURE 컬럼이 있는 테이블
  판정: 표기가 거의 같은 활성 코드 쌍(편집 거리 2 이하)·데이터에 없는 활성 코드·기준에 없는 데이터 값 = ERROR(확인 대상)
        미사용·오타 여부는 업무 판단이 필요해 FAIL 로 올리지 않는다 · 기준이 비면 대상 아님
"""
import csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 8)
COLS = ['lookup_type', 'result', 'why']


def dist(a, b, cap=3):
    """편집 거리(cap 이상은 cap)"""
    if abs(len(a) - len(b)) >= cap:
        return cap
    p = list(range(len(b) + 1))
    for i, x in enumerate(a, 1):
        c = [i]
        for j, y in enumerate(b, 1):
            c.append(min(p[j] + 1, c[j - 1] + 1, p[j - 1] + (x != y)))
        p = c
    return min(p[-1], cap)


def judge(active, data):
    """active 활성 코드 · data 데이터 MEASURE 값(None = 데이터 표 없음)"""
    a = sorted(set(active))
    if not a:
        return 'NA', '활성 기준 코드 없음'
    typo = [f'{x}~{y}' for i, x in enumerate(a) for y in a[i + 1:] if min(len(x), len(y)) >= 8 and dist(x.upper(), y.upper()) <= 2 and not re.search(r'\d', x + y)]
    parts = []
    if typo:
        parts.append(f'표기 유사 코드 쌍 {len(typo)}건: {typo[:5]}')
    if data is not None:
        d = set(data)
        unused, orphan = sorted(set(a) - d), sorted(d - set(a))
        if unused:
            parts.append(f'데이터 없는 활성 코드 {len(unused)}건: {unused[:6]}')
        if orphan:
            parts.append(f'기준에 없는 데이터 값 {len(orphan)}건: {orphan[:6]}')
    if parts:
        return 'ERROR', '[확인 대상] ' + ' · '.join(parts)
    return 'PASS', f'활성 코드 {len(a)}건 — 유사 표기 0' + ('' if data is None else ' · 데이터와 일치')


def selftest():
    cases = [('오타 쌍', judge(['Customer FCST', 'Cutomer FCST'], None), 'ERROR'), ('정상', judge(['ALPHA_PLAN', 'OMEGA_RESULT'], ['ALPHA_PLAN', 'OMEGA_RESULT']), 'PASS'), ('미사용', judge(['ALPHA_PLAN', 'OMEGA_RESULT'], ['ALPHA_PLAN']), 'ERROR'), ('기준 없는 값', judge(['ALPHA_PLAN'], ['ALPHA_PLAN', 'ZZZ']), 'ERROR'), ('기준 0', judge([], ['x']), 'NA'), ('숫자 차이 제외', judge(['PLAN_W1', 'PLAN_W2'], None), 'PASS')]
    bad = 0
    for n, got, want in cases:
        k = got[0] == want
        bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {n} → {got[0]}(기대 {want}) {got[1]}")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def sweep_all():
    """전역 — 이름에 MEASURE 가 든 Lookup 유형 전체의 표기 유사 코드(화면 원천에 안 잡히는 전용 목록 포함) → Doc/verify/_global/measure_sweep.csv"""
    from dbconn import connect
    res = []
    with connect('tobe') as cx:
        cur = cx.cursor()
        # 코드 칸이 유형마다 다르다(CUST_FCST_MEASURE SEGMENT1 = Division) — SEGMENT 칸마다 표기 유사를 본다
        cur.execute("select lookup_type, segment1, segment2, segment3, segment4, segment5 from SCM_ADM_LOOKUP_MASTER_DETAIL where upper(lookup_type) like '%MEASURE%' and valid_yn = 'Y'")
        by = {}
        for row in cur.fetchall():
            for k in range(1, 6):
                if row[k] is not None and str(row[k]).strip():
                    by.setdefault((row[0], k), set()).add(str(row[k]))
        for (t, k), codes in sorted(by.items()):
            r, why = judge(sorted(codes), None)
            res.append({'lookup_type': f'{t}.SEGMENT{k}', 'result': r, 'why': why})
    d = os.path.join(ROOT, 'Doc', 'verify', '_global')
    os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, 'measure_sweep.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(res)
    print(f'[measure_sweep] 전역 Lookup {len(res)}종 ' + str({k: sum(1 for x in res if x["result"] == k) for k in sorted({x["result"] for x in res})}))
    for x in res:
        if x['result'] != 'PASS':
            print(' ', x['lookup_type'], x['result'], x['why'][:220])
    return 0


def main(mid):
    fa = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid, 'combo_src.csv')
    if not os.path.exists(fa):
        print(f'[measure_sweep] {mid}: combo_src 없음 — 생략')
        return 0
    types = sorted({(r.get('code') or '') for r in csv.DictReader(open(fa, encoding='utf-8-sig', newline='')) if re.search('MEASURE', r.get('code') or '', re.I) and re.fullmatch(r'\w+', r.get('code') or '')})
    from dbconn import connect
    res = []
    with connect('tobe') as cx:
        cur = cx.cursor()
        # 화면 PKG 본문이 읽는 표 중 MEASURE 컬럼 보유 표
        cur.execute("select distinct referenced_name from all_dependencies where name = :1 and referenced_type = 'TABLE' and referenced_name in (select table_name from all_tab_columns where column_name = 'MEASURE')", [f'PKG_{mid}'])
        tabs = [r[0] for r in cur.fetchall() if re.fullmatch(r'\w+', r[0]) and not r[0].startswith('GT')]
        data = None
        for t in tabs[:6]:
            try:
                cur.execute(f'select distinct MEASURE from {t} where MEASURE is not null fetch first 500 rows only')
                data = (data or set()) | {str(r[0]) for r in cur.fetchall()}
            except Exception as ex:  # noqa: BLE001 — 권한 등으로 못 읽은 표는 건너뛰고 근거에 남긴다
                print(f'[measure_sweep] {t} 읽기 실패: {str(ex)[:100]}')
        for lt in types:
            cur.execute("select segment1 from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = :1 and valid_yn = 'Y' and segment1 is not null", [lt])
            act = [str(r[0]) for r in cur.fetchall()]
            if not act:
                continue
            r, why = judge(act, data)
            res.append({'lookup_type': lt, 'result': r, 'why': why + f' · 데이터 표 {tabs[:6]}'})
    with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'measure_sweep.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(res)
    print(f'[measure_sweep] {mid}: Lookup {types} → ' + ' / '.join(f"{x['lookup_type']} {x['result']} {x['why'][:240]}" for x in res))
    return 0


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1] == '--selftest' else sweep_all() if sys.argv[1] == '--all' else main(sys.argv[1].upper()))
