# -*- coding: utf-8 -*-
"""콤보 후보의 Active 정책 판정(2026-11-02 엔진 갭 EG055)

  python tools/Harness/verify/active_policy.py --selftest   판정 변이 입증

  규칙(확정 규칙 CR-059): 조회조건 = Active Y/N 무관 전체 · 셀 콤보 = 사용 중(Y)만
  확정 규칙이 'Y 만 후보' 로 정한 대상(CR-069 Plant 등)은 조회조건도 Y 만
  비활성 행이 없는 마스터는 이 정책을 잴 수 없어 판정하지 않는다
"""
import re, sys

VALID_COLS = ('VALID_YN', 'ACTIVE_FLAG', 'ACTIVE_YN', 'USE_YN')


def judge_active(kind, only_y, shown, active, inactive):
    """kind SEARCH|GRID · only_y 확정 규칙이 Y 만으로 정함 · shown 화면 후보 코드 · active·inactive 마스터 코드 → (결과, 근거)"""
    shown, active, inactive = set(shown), set(active), set(inactive) - set(active)
    if not inactive:
        return 'NA', f'비활성 행 없음(활성 {len(active)}건) — 정책 판정 대상 아님'
    hit = sorted(shown & inactive)
    if kind == 'SEARCH' and not only_y:
        miss = sorted(inactive - shown)
        if miss:
            return 'FAIL', f'조회조건은 Y/N 전체 후보인데 비활성 {len(miss)}/{len(inactive)}건 없음: {miss[:6]}'
        return 'PASS', f'비활성 {len(inactive)}건 포함 전체 후보'
    if hit:
        return 'FAIL', f"{'확정 규칙 Y 만' if only_y else '셀 콤보는 사용 중만'} 후보인데 비활성 {len(hit)}건 노출: {hit[:6]}"
    return 'PASS', f'비활성 {len(inactive)}건 후보에 없음'


def master_sets(cur, mst):
    """TO-BE 마스터에서 활성·비활성 코드 — 활성 칸이 없으면 None"""
    tbl, col = (mst.get('tbl') or '').upper(), (mst.get('col') or '').upper()
    if not re.fullmatch(r'\w+', tbl) or not re.fullmatch(r'\w+', col):
        return None
    cur.execute('select column_name from all_tab_columns where table_name = :1', [tbl])
    cols = {r[0] for r in cur.fetchall()}
    v = next((c for c in VALID_COLS if c in cols), None)
    if not v or col not in cols:
        return None
    eqs = {k.upper(): x for k, x in (mst.get('eqs') or {}).items() if k.upper() in cols and k.upper() != v}
    where = ''.join(f' and {k} = :{i + 1}' for i, k in enumerate(eqs))
    cur.execute(f'select {col}, {v} from {tbl} where 1=1{where}', list(eqs.values()))
    a, i = set(), set()
    for c, y in cur.fetchall():
        if c is not None and str(c).strip():
            (a if y == 'Y' else i).add(str(c))
    return a, i


def selftest():
    A, I = {'a', 'b'}, {'x', 'y'}
    cases = [('조회조건 전체', judge_active('SEARCH', False, {'a', 'b', 'x', 'y'}, A, I), 'PASS'), ('조회조건 비활성 없음', judge_active('SEARCH', False, {'a', 'b'}, A, I), 'FAIL'), ('셀 사용 중만', judge_active('GRID', False, {'a', 'b'}, A, I), 'PASS'), ('셀 비활성 노출', judge_active('GRID', False, {'a', 'x'}, A, I), 'FAIL'), ('규칙 Y 만 조회조건', judge_active('SEARCH', True, {'a'}, A, I), 'PASS'), ('규칙 Y 만 위반', judge_active('SEARCH', True, {'a', 'x'}, A, I), 'FAIL'), ('비활성 없음', judge_active('GRID', False, {'a'}, A, set()), 'NA'), ('같은 코드 Y·N', judge_active('GRID', False, {'a'}, A, {'a'}), 'NA')]
    bad = 0
    for n, got, want in cases:
        ok = got[0] == want
        bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {n} → {got[0]}(기대 {want}) {got[1]}")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(selftest())
