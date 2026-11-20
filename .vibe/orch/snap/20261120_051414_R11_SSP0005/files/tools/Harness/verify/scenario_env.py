#!/usr/bin/env python3
"""scenario_env.py <ID> [...] — 화면별 데이터 전제 프로필(W8-5, 2026-11-05) → Doc/verify/<ID>/scenario_env.json

  목적: 자동 기대 행(gen_expect)·시나리오 실행기가 '어떤 계정·Division·조회조건이면 데이터가 나오는가'를 사실로 갖고,
        0행 ERROR 가 나면 그 전제가 무엇이었는지 근거에 함께 남긴다(감으로 원인 추정 금지 — 사실만 나열).
  내용(전부 출처 표기):
    division_cond      조회조건에 Division 이 있는가 · TO-BE 라벨(SCP·SSP = 조회조건 기준표 tobe_name)
    divisions_meta     TO-BE division.csv 기본 Division
    divisions_accounts users.json 영역(DM/SCP/SSP) 에 계정이 있는 Division → 그룹:계정
    fixed_division     scenario_env_override.csv(사용자 지정 Division 전용 화면)
    default            생성기 기본 Division·계정(gen_expect Screen.env 와 같은 계산)
    default_account    E2E 기본 로그인과 소속 그룹 · 이 화면 버튼 권한(btn_auth use_yn=Y 합집합)
    required_conds     필수 조회조건(SCP·SSP = 기준표 asis_required/tobe_required 'O' · 그 외 AS-IS 라벨 끝 '*')
    popup_conds        팝업으로 고르는 조회조건(버전 등 — 기준표 tobe_func '팝업' · AS-IS 라벨 Version)
    bucket_cond        Bucket 조회조건 라벨(AS-IS)
    observed           마지막 E2E(e2e_results.json · 시각)의 시나리오 조회 뒤 행 수 최대값 · '조회 0행' 실패 목록(대안 조회 경로)
  소비: gen_expect.py(보고서 env_profile · 기본 Division 에 계정 없으면 경고) · _verify.spec.ts 시나리오 '조회 0행' ERROR 근거에 요약 첨부
"""
import csv
import datetime
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import expect_rows as ER  # noqa: E402
import gen_expect as GEN  # noqa: E402

V = ER.V
ROOT = ER.ROOT


def area_of(mid):
    return 'SCP' if mid.upper().startswith('SCP') else 'SSP' if mid.upper().startswith('SSP') else 'DM'


def users_json():
    p = os.path.join(ROOT, 'tools', 'E2E', 'users.json')
    try:
        with open(p, encoding='utf-8-sig') as f:
            return json.load(f)
    except (OSError, ValueError):
        return {}


def observed(mid):
    p = os.path.join(V, mid, 'e2e_results.json')
    if not os.path.exists(p):
        return {'source': 'e2e_results.json 없음', 'max_rows_after_search': None, 'zero_row_failures': []}
    try:
        with open(p, encoding='utf-8') as f:
            j = json.load(f)
    except (OSError, ValueError) as ex:
        return {'source': f'e2e_results.json 읽기 실패 {ex}', 'max_rows_after_search': None, 'zero_row_failures': []}
    items = j if isinstance(j, list) else j.get('results') or j.get('rows') or []
    mx, zero, n = None, [], 0
    for x in items:
        e = str(x.get('evidence') or '')
        vals = []
        # ① 시나리오 근거 꼬리(11-04 실행기~) 'search:0행·… → <다음 단계>:N행' — 조회 직후 다음 단계 시작 시 행 수
        vals += [int(m.group(1)) for m in re.finditer(r'search0?:\d+행[^→]*→\s*[\w가-힣 ]+:(\d+)행', e)]
        # ② 일반 검사 근거 '조회 N행'(건수 표시·정렬 등 · 그 이전 실행 형식)
        vals += [int(m.group(1).replace(',', '')) for m in re.finditer(r'조회 ([\d,]+)행', e)]
        if vals:
            n += 1
            mx = max(vals) if mx is None else max(mx, max(vals))
        for m in re.finditer(r'조회 0행(?:\(([^)]*)\))?', e):
            zero.append({'row_id': x.get('row_id', ''), 'via': (m.group(1) or e[max(0, m.start() - 40):m.end() + 20])[:80]})
    t = datetime.datetime.fromtimestamp(os.path.getmtime(p)).strftime('%Y-%m-%d %H:%M')
    return {'source': f'e2e_results.json {t} · 행 수 근거 {n}행', 'max_rows_after_search': mx, 'zero_row_failures': zero[:20], 'zero_row_count': len(zero)}


def build(mid):
    S = GEN.Screen(mid)
    G = GEN.glob_facts()
    area = area_of(mid)
    U = users_json()
    divs_acc = {}
    for d, groups in ((U.get('areas') or {}).get(area, {}).get('divisions') or {}).items():
        acc = {g: u for g, u in groups.items() if u}
        if acc:
            divs_acc[d] = acc
    sc = GEN.search_cond_rows(mid)
    if sc:
        dl = [r['tobe_name'] for r in sc if r.get('usage') == 'USE' and re.fullmatch(r'div(ision)?', ER._norm_label(r.get('tobe_name', '')))]
        req = [{'label': r['tobe_name'], 'source': 'search_cond.csv'} for r in sc if r.get('usage') == 'USE' and ('O' in (r.get('tobe_required') or '') or 'O' in (r.get('asis_required') or ''))]
        pops = [{'label': r['tobe_name'], 'popup': r.get('tobe_popup_code') or r.get('asis_popup_name') or '', 'source': 'search_cond.csv'} for r in sc if r.get('usage') == 'USE' and '팝업' in (r.get('tobe_func') or '')]
    else:
        dl = [v for v in S.label.values() if re.fullmatch(r'div(ision)?', ER._norm_label(v))]
        req = [{'label': re.sub(r'\s*\*\s*$', '', v), 'source': 'AS-IS controls 라벨 *'} for v in S.label.values() if (v or '').strip().endswith('*')]
        pops = [{'label': v, 'popup': '', 'source': 'AS-IS controls 라벨'} for v in S.label.values() if re.search(r'version|버전', v or '', re.I)]
    ov = G['env_override'].get(mid) or {}
    grs = sorted(G['user_gr'].get(GEN.DEFAULT_ACCOUNT, set()))
    gl = {g.lower() for g in grs}
    btns = sorted(set().union(*[v for k, v in G['btn_gr'][mid].items() if k.lower() in gl])) if gl and G['btn_gr'].get(mid) else []
    env = S.env
    warn = []
    if env['division'] and env['division'] not in divs_acc and not env.get('user'):
        warn.append(f"기본 Division {env['division']} 에 users.json {area} 계정 없음")
    if S.has_div_cond() and not divs_acc:
        warn.append(f'users.json {area} 영역 Division 계정 없음')
    prof = {
        'menu_id': mid, 'asis_id': S.asis, 'area': area, 'generated': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'division_cond': {'present': S.has_div_cond(), 'labels': sorted(set(dl))},
        'divisions_meta': GEN.base_divisions(),
        'divisions_accounts': divs_acc,
        'fixed_division': {'division': ov.get('division', ''), 'user': ov.get('user', ''), 'source': ov.get('source', '')} if ov else None,
        'default': env,
        'default_account': {'user': GEN.DEFAULT_ACCOUNT, 'groups': grs, 'buttons': btns, 'source': 'user_group_user.csv · btn_auth.csv(use_yn=Y)'},
        'required_conds': req,
        'popup_conds': pops,
        'bucket_cond': next((v for v in S.label.values() if re.search(r'bucket', v or '', re.I)), ''),
        'observed': observed(mid),
        'warnings': warn,
    }
    od = os.path.join(V, mid)
    os.makedirs(od, exist_ok=True)
    with open(os.path.join(od, 'scenario_env.json'), 'w', encoding='utf-8') as f:
        json.dump(prof, f, ensure_ascii=False, indent=1)
    return prof


def summary(p):
    """0행 ERROR 근거에 붙일 한 줄(_verify.spec.ts 와 같은 형식)"""
    o = p['observed']
    parts = [f"Div조건 {'있음' if p['division_cond']['present'] else '없음'}",
             f"기본 Div {p['default']['division'] or '-'}({p['default']['basis'][:30]})",
             f"계정 Div {','.join(sorted(p['divisions_accounts'])) or '없음'}",
             f"필수조건 {','.join(x['label'] for x in p['required_conds']) or '없음'}",
             f"마지막 관측 조회 최대 {o.get('max_rows_after_search') if o.get('max_rows_after_search') is not None else '미측정'}행"]
    return ' · '.join(parts)


def main():
    ids = [a for a in sys.argv[1:] if not a.startswith('-')]
    if not ids:
        print(__doc__)
        sys.exit(2)
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    for mid in ids:
        try:
            p = build(mid)
        except Exception as ex:  # 사실 파일 형식 문제 = ERROR(프로필 없음) — 0 으로 두지 않음
            print(f'{mid}: [ERROR] 프로필 생성 실패 {type(ex).__name__}: {ex}')
            continue
        print(f"[실측 {now}] {mid}: {summary(p)}" + (f" · ⚠ {'; '.join(p['warnings'])}" if p['warnings'] else ''))


if __name__ == '__main__':
    main()
