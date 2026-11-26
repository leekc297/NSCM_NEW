# -*- coding: utf-8 -*-
"""vm_intro.py 규칙 시험(2026-11-24 VM 소개 자료). 실제 저장소를 읽어 측정하고, 출력은 임시 폴더. 출력 줄 = PASS/FAIL, 끝 = ALL PASS/SOME FAIL"""
import os, sys, tempfile, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vm_intro as VI

ok = True


def chk(name, cond, extra=''):
    global ok
    print(('PASS' if cond else 'FAIL'), name, extra)
    ok = ok and bool(cond)


FX = VI.facts()
need = ['vm.version', 'menu.groups', 'menu.items', 'vmw.jobs', 'vm.steps', 'vm.tests', 'rule.hooks', 'rule.tobe', 'out.checklist_screens', 'vmo.applied']
chk('측정 키 = 필수 10개 있음', all(k in FX['facts'] for k in need), str([k for k in need if k not in FX['facts']]))
chk('메뉴 묶음 수 = menus 길이', FX['facts']['menu.groups']['v'] == len(FX['menus']))
for a in VI.AUD:
    d = VI.draft(a, FX); kinds = [s['kind'] for s in d['slides']]
    chk(f'{a} 초안: 첫 장 cover, 끝 장 closing, 로드맵(표 + roadmap) 포함', kinds[0] == 'cover' and kinds[-1] == 'closing' and 'roadmap' in kinds and any('4GL' in s.get('title', '') or 'PowerBuilder' in json.dumps(s, ensure_ascii=False) for s in d['slides']), str(kinds))
    lo, hi = VI.RANGE[a]
    chk(f'{a} 초안 장 수 {len(kinds)} = 범위 {lo}~{hi}', lo <= len(kinds) <= hi)
    f = VI.check(a, d, FX)
    chk(f'{a} 초안 검사 = 작성 필요만 실패(수치, fact 키 실패 없음)', f and all('작성 필요' in x for x in f), str(f[:3]))
# 목표, 가정, 예상 효과(가정 기반 계산)
FX2 = {'facts': dict(FX['facts']), 'menus': FX['menus']}; FX2['facts']['scope.screens'] = {'v': 100, 'unit': '개', 'label': 't', 'src': 't'}
VI.estimates(FX2, {'mdPerScreen': '10', 'months': '10', 'workdays': '20'}); E = FX2['facts']
chk('예상: 수작업 = 화면 × 공수, VM 보정 = 수작업 × 5%, 대체 = (수작업 − 보정) ÷ (개월 × 근무일)', E['est.manual_md']['v'] == 1000 and E['est.vm_md']['v'] == 50 and E['est.replace']['v'] == 4.8, str({k: E[k]['v'] for k in ('est.manual_md', 'est.vm_md', 'est.replace')}))
chk('예상: 바이브 코딩 대비 추가 = (300~400 − 50) ÷ 200', E['est.replace_vs_vibe_lo']['v'] == 1.2 and E['est.replace_vs_vibe_hi']['v'] == 1.8, str((E['est.replace_vs_vibe_lo']['v'], E['est.replace_vs_vibe_hi']['v'])))
chk('목표값 = 사용자 제시(60, 70, 95)', (E['goal.vibe_low']['v'], E['goal.vibe_high']['v'], E['goal.vm']['v']) == (60, 70, 95))
d0 = VI.draft('EXEC', FX2); tt = [x['title'] for x in d0['slides']]
chk('EXEC 초안: 목적, 추진 배경, 차별점, 예상 효과 장', any(t.startswith('목적') for t in tt) and any(t.startswith('추진 배경') for t in tt) and '일반 바이브 코딩과 다른 점' in tt and any(t.startswith('예상 효과') for t in tt), str(tt))
chk('예상 효과 장 = 실측 아님 표시 + 계산식', any('실측 아님' in x.get('lead', '') and any('계산' in i for i in x.get('items', [])) for x in d0['slides']))
FX3 = {'facts': {k: v for k, v in FX['facts'].items() if k != 'scope.screens' and not k.startswith('est.')}, 'menus': FX['menus']}; VI.estimates(FX3, {})
chk('화면 수 미측정 = 예상 계산 안 함(미측정 표시)', 'est.replace' not in FX3['facts'] and '미측정' in str(VI.effect_slide(FX3['facts'])))
bad = {'slides': [{'kind': 'cover', 'title': 'x'}, {'kind': 'kpi', 'title': '수치', 'kpis': [{'fact': 'menu.items', 'value': 999}, {'fact': 'no.such'}]}, {'kind': 'list', 'title': '효과', 'items': ['처리 시간 73 퍼센트 단축함', 'React 18 기준임']}] + [{'kind': 'list', 'title': f't{i}', 'items': ['확인함']} for i in range(8)]}
f = VI.check('EXEC', bad, FX)
chk('검사: 수치 카드 value 직접 씀 = 실패', any('value 직접' in x for x in f))
chk('검사: 없는 fact 키 = 실패', any('fact 키 없음 no.such' in x for x in f))
chk('검사: 본문 숫자 73(측정값 아님) = 실패, React 18(기술 버전) = 통과', any('본문 숫자 73' in x for x in f) and not any('본문 숫자 18' in x for x in f), str(f))
# 출력(모든 장표 종류)
d = VI.draft('SHARE', FX); d['_author'] = VI.AUTHOR; d['_date'] = '2026-11-24'
d['slides'].insert(3, {'kind': 'table', 'title': '표', 'table': {'columns': ['a', 'b'], 'rows': [['1', '2']]}})
tmp = tempfile.mkdtemp()
n = VI.render_pptx(d, FX, os.path.join(tmp, 'a.pptx'), '맑은 고딕')
g = VI.render_pptx(d, FX, os.path.join(tmp, 'g.pptx'), 'Noto Sans KR', True)
h = VI.render_html(d, FX, os.path.join(tmp, 'a.html'))
chk('출력: PPTX, Google Slides PPTX, HTML 장 수 = 내용 장 수', n == g == h == len(d['slides']), f'{n} {g} {h} {len(d["slides"])}')
from pptx import Presentation
P = Presentation(os.path.join(tmp, 'g.pptx'))
fonts = {r.font.name for s in P.slides for sh in s.shapes if sh.has_text_frame for p in sh.text_frame.paragraphs for r in p.runs if r.font.name}
chk('Google Slides 판 글꼴 = Noto Sans KR 하나', fonts == {'Noto Sans KR'}, str(fonts))
texts = [sh.text_frame.text for sh in P.slides[0].shapes if sh.has_text_frame]
chk('표지 작성자 = MARISOFT(VM 솔루션 소개 자료 고정)', VI.AUTHOR == 'MARISOFT', str(texts))
kv = VI.kpi_val(FX['facts'], 'menu.items')
chk('수치 카드 값 = facts 측정값', kv[0].replace(',', '') == str(FX['facts']['menu.items']['v']), str(kv))
print('ALL PASS' if ok else 'SOME FAIL')
sys.exit(0 if ok else 1)
