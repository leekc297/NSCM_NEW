# -*- coding: utf-8 -*-
"""judge.py 의 저장 성공 메시지(E4) ← F1(CRUD 실저장) 승계 규칙(T292) 변이 입증

  python tools/Harness/verify/judge_e4f1_selftest.py --selftest
"""
import os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)


def selftest():
    import judge
    f = judge.e4_from_f1
    bad = {'evidence': '[자동] 기존 행 Delete → D 저장 요청: 저장 요청 없음'}
    good = {'evidence': '편집 가능 2컬럼 중 왕복 2 · 값 불일치 0'}
    err = {'evidence': '조회 결과 0행 — 실저장 불가'}
    cases = [('저장 성공 실측이 있으면 PASS(다른 시나리오 FAIL 이 있어도)', f(bad, good, None)[0] == 'PASS'),
             ('그 사유에 F1 FAIL 은 별도 조치임을 남긴다', 'F1 행에서 조치' in f(bad, good, None)[1]),
             ('성공 실측만 있으면 PASS · 덧붙임 문구 없음', f(None, good, None) == ('PASS', good['evidence'])),
             ('성공 실측이 없고 FAIL 만 있으면 FAIL 이 아니라 미검증(ERROR)', f(bad, None, None)[0] == 'ERROR' and '미검증' in f(bad, None, None)[1]),
             ('FAIL 만 있을 때 PASS 가 되지 않는다(변이)', f(bad, None, err)[0] != 'PASS'),
             ('ERROR 만 있으면 ERROR', f(None, None, err)[0] == 'ERROR'),
             ('F1 실측 행이 없으면 미검증(T660 · 종전 NA)', f(None, None, None)[0] == 'ERROR')]
    g = judge.p32_result
    t32 = 'SCP0131 시나리오 [자동] OPMZ_PLAN_GR_ID 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사'
    cases += [('T299 후보 밖 값 복사 FAIL = 판정필요', g(t32, "붙여넣기 'PG0031' [기존 행 r1 원값 'PG0031' Copy='PG0031'(이 행 후보 15건 밖)]: ''→''")[0] == '판정필요'),
              ('T299 원값이 - 이면 해당없음', g(t32, "[기존 행 r12 원값 '-' Copy='-'(이 행 후보 12.5건 밖)]")[0] == 'NA'),
              ('T299 원값이 / 이면 해당없음', g(t32, "[기존 행 r19 원값 '/' Copy='/'(이 행 후보 1.5건 밖)]")[0] == 'NA'),
              ('T299 다른 F3 시나리오는 그대로(변이)', g('SCP0131 시나리오 [자동] X 신규 행 콤보 붙여넣기 — 후보 값 반영', "값 '' 이 비어 있음") is None)]
    bad_n = 0
    for n, ok in cases:
        print(('PASS ' if ok else 'FAIL ') + n)
        bad_n += 0 if ok else 1
    print(f'selftest {len(cases) - bad_n}/{len(cases)}')
    return 1 if bad_n else 0


if __name__ == '__main__':
    sys.exit(selftest() if '--selftest' in sys.argv[1:] else 0)
