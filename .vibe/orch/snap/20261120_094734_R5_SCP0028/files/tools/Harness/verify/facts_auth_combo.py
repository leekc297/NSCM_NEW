# -*- coding: utf-8 -*-
"""facts_auth_combo — 계정·Div 별 조회조건 후보 ↔ AS-IS 원천(같은 계정·보유 그룹 합집합) 대조. EG367·EG061(조회조건)·EG366 교차 (E03 · 2026-10-31)

  python -I tools/Harness/verify/facts_auth_combo.py <ID> <결과 폴더(eg_combos.json 있는 곳)>
  결과 → <결과 폴더>/eg_combo_judge.json · stdout 요약. 계정 ID 는 쓰지 않는다(key).

  AS-IS 실행 = combo_oracle.AsIs(BigFilter: @GROUP_ID·@USER_ID) · dm_inner. 대상 = combo_src.csv SEARCH 행 중 sp=DM_BIGFILTER 이고 code 가 DM_INNER 에 있는 칸만.
  그 밖의 칸 = 판정필요(원천 실행 경로 없음) — 공용 B4(combo_oracle main)가 기본 계정으로 재는 것과 같은 원천을 계정별로 넓힌 것.
  판정: TO-BE ⊄ AS-IS 합집합 → FAIL(권한 밖 후보) · AS-IS ⊄ TO-BE → 판정필요(마스터 차이 설명 전) · 같음 → PASS. AS-IS 에 계정 없음 → ERROR.
"""
import csv
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
import combo_oracle as co  # noqa: E402
from dbconn import connect  # noqa: E402


def key_norm(s):
    return ''.join(ch for ch in (s or '').lower() if ch.isalnum())


def uid_of(uj, key):
    area, dv, role = key.split('/', 2)
    if area == 'SCR':  # 화면별 지정 계정(users.json screens[<ID>].accounts · 2026-11-18)
        return uj['screens'][dv]['accounts'][role]
    return uj['areas'][area]['divisions'][dv][role]


def main():
    sid, folder = sys.argv[1].upper(), sys.argv[2]
    dump = json.load(open(os.path.join(folder, 'eg_combos.json'), encoding='utf-8'))
    with open(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid, 'combo_src.csv'), encoding='utf-8-sig', newline='') as f: src = [r for r in csv.DictReader(f) if r['target_kind'] == 'SEARCH']
    by_label = {}
    for r in src:
        if r['sp'] == 'DM_BIGFILTER' and r['code'] in co.fc.DM_INNER:
            by_label.setdefault(key_norm(r['label']), r)
    uj = json.load(open(os.path.join(ROOT, 'tools', 'E2E', 'users.json'), encoding='utf-8-sig'))
    out = []
    with connect('asis') as acx:
        cur = acx.cursor()
        for d in dump:
            k = key_norm(d['label'])
            base = {'eg': 'EG367', 'screen': sid, 'target': d['label'], 'ctx': f"{d['key']} · Div {d['div']}", 'asis': 'DM_BIGFILTER(@GROUP_ID·@USER_ID) 실행'}
            if not d.get('full'):
                out.append({**base, 'result': 'ERROR', 'expected': '전체 후보(콤보 응답)', 'actual': f'전체 후보 미확보 — DOM 렌더 {d.get("texts")}건만(가상 스크롤), 대조 안 함'}); continue
            r = by_label.get(k)
            if not r:
                out.append({**base, 'result': '판정필요', 'expected': 'AS-IS 원천 실행 경로', 'actual': f'BigFilter 대응 칸 아님 · TO-BE 후보 {len(d["codes"])}개'}); continue
            uid = uid_of(uj, d['key'])
            cur.execute("SELECT DISTINCT GroupID FROM TB_FX_UserGroupAuthExtention WITH(NOLOCK) WHERE UserID=?", uid); grs = [x[0] for x in cur.fetchall()]
            if not grs:
                out.append({**base, 'result': 'ERROR', 'expected': 'AS-IS 계정', 'actual': 'AS-IS 권한표에 계정 없음 — 대조 불가'}); continue
            want = set(); names = {}
            ctx = {'Filter.DIVISION_ID': d['div']}
            for g in grs:
                asis = co.AsIs(acx, g, uid)
                rows, _ = co.dm_inner(asis, r['code'], ctx)
                for x in rows: want.add(x['CODE']); names[x['CODE']] = x['NAME']
            got = {c for c in d['codes'] if c}
            ex, ms = sorted(got - want), sorted(want - got)
            res = 'FAIL' if ex else '판정필요' if ms else 'PASS'
            # 콤보 후보가 가상 스크롤로 일부만 읽혔으면 누락 판단을 하지 않는다
            out.append({**base, 'result': res, 'expected': f'AS-IS {r["code"]} 합집합(그룹 {len(grs)}개) {len(want)}건', 'actual': f'TO-BE {len(got)}건 · 권한 밖 {ex[:8]} · 없는 후보 {ms[:8]}', 'note': r.get('ref', '')})
    json.dump(out, open(os.path.join(folder, 'eg_combo_judge.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
    c = {}
    for x in out: c[x['result']] = c.get(x['result'], 0) + 1
    print(sid, c)
    for x in out:
        if x['result'] in ('FAIL', 'ERROR'): print(' ', x['result'], x['target'], x['ctx'], '|', x['actual'][:200])


if __name__ == '__main__':
    main()
