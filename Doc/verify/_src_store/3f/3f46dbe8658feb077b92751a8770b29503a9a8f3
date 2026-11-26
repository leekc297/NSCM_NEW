# -*- coding: utf-8 -*-
"""judge.py 의 팝업 문장 → 팝업 클래스 해석(T269) 변이 입증

  python tools/Harness/verify/judge_popup_selftest.py --selftest
"""
import os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)


def selftest():
    import judge
    acts = [{'method': 'btnItemId_Click', 'raw': 'DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();', 'target': '', 'value': ''},
            {'method': 'btnOwner_Click', 'raw': 'popOwner = new DMF000_OwnerSet_Popup(sDiv);', 'target': '', 'value': ''},
            {'method': 'A', 'raw': 'pop = new A_Popup();', 'target': '', 'value': ''}, {'method': 'A', 'raw': 'pop = new B_Popup();', 'target': '', 'value': ''},
            {'method': 'B', 'raw': 'pop = new B_Popup();', 'target': '', 'value': ''},
            {'method': 'A', 'raw': 'DataTable dt = new DataTable();', 'target': '', 'value': ''}]
    v = judge.popup_var_classes(acts)
    c = judge.popup_class_of
    cases = [('변수 선언 → 클래스(메서드별)', v.get(('btnItemId_Click', 'popItem')) == 'DM0002_ItembyDivisionPopupEx'),
             ('대입 → 클래스', v.get(('btnOwner_Click', 'popOwner')) == 'DMF000_OwnerSet_Popup'),
             ('같은 메서드·같은 변수·다른 클래스 = 제외', ('A', 'pop') not in v),
             ('다른 메서드의 같은 변수는 따로', v.get(('B', 'pop')) == 'B_Popup'),
             ('팝업이 아닌 new 는 제외', ('A', 'dt') not in v),
             ('new 문장에서 직접', c('new DM0002_ItembyDivisionPopupEx()', v) == 'DM0002_ItembyDivisionPopupEx'),
             ('변수.ShowDialog() — 같은 메서드', c('popItem.ShowDialog()', v, 'btnItemId_Click') == 'DM0002_ItembyDivisionPopupEx'),
             ('변수.Form_Load(인자)', c('popItem.Form_Load(true, sDivision, sTeam)', v, 'btnItemId_Click') == 'DM0002_ItembyDivisionPopupEx'),
             ('다른 메서드의 같은 이름 변수 = 빈 값', c('popItem.ShowDialog()', v, 'btnOther_Click') == ''),
             ('충돌 변수 = 빈 값', c('pop.ShowDialog()', v, 'A') == ''),
             ('팝업 아님 = 빈 값', c('siMain.SetValue(i, 1, x)', v, 'A') == '')]
    # 2026-11-25 T605: 팝업·셀 이벤트 SP 의 A6 TRACE 판정필요 → 정적 정렬 대조 + 골든 순서 결합(judge.a6_offpath_verdict)
    o = judge.a6_offpath_verdict
    pair = [{'menu_id': 'X', 'asis_sp': 'X_GET_A', 'tobe_proc': 'PKG_X.P_X_GET_A'}]
    scp = [{'menu_id': 'X', 'sp': 'X_GET_A', 'tobe_proc': 'PKG_X.P_X_GET_A', 'asis_keys': 'K1', 'tobe_keys': 'K1', 'verdict': 'PASS', 'note': '분기 키 순서 동일'}]
    scf = [{**scp[0], 'verdict': 'FAIL', 'note': '1번째 키부터 다름'}]
    cip = [{'proc': 'PKG_X.P_X_GET_A', 'result': 'PASS', 'why': '문자 키 대소문자 무시'}]
    ci3 = [{'proc': 'PKG_X.P_X_GET_A', 'result': 'NA', 'why': '그리드 비바인딩 룩업 SP — (TO-BE 룰 CR-075 ③ 대상 아님)'}]
    cir = [{'proc': 'PKG_X.P_X_GET_A', 'result': '판정필요', 'why': '소문자 행 있음'}]
    g1 = [{'screen': 'X', 'kind': 'GET', 'asis_sp': 'X_GET_A', 'tobe_proc': 'PKG_X.P_X_GET_A', 'verdict': 'PASS', 'asis_rows': '1', 'tobe_rows': '1', 'common_rows': '1', 'order': 'NA'}]
    g5 = [{**g1[0], 'common_rows': '5', 'asis_rows': '5', 'tobe_rows': '5'}]
    gd = [{**g5[0], 'order': 'DIFF'}]
    gp = [{**g5[0], 'order': 'PASS'}]
    cases += [('T605 정적 PASS + 골든 순서 NA(공통 1행) = PASS · 둘 다 인용', o('X_GET_A', 'X', scp, cip, g1, pair)[0] == 'PASS' and 'sort_check' in o('X_GET_A', 'X', scp, cip, g1, pair)[1] and 'order.csv' in o('X_GET_A', 'X', scp, cip, g1, pair)[1]),
              ('T605 TO-BE PROC 이름으로도 찾음(짝 표)', o('PKG_X.P_X_GET_A', 'X', scp, cip, gp, pair)[0] == 'PASS'),
              ('T605 골든 순서 NA 공통 5행 = PASS 아님(변이)', o('X_GET_A', 'X', scp, cip, g5, pair)[0] == ''),
              ('T605 골든 없음 = 정적만으로 PASS 아님(변이)', o('X_GET_A', 'X', scp, cip, [], pair)[0] == ''),
              ('T605 골든만 있고 정적 대조 없음 = PASS 아님(변이)', o('X_GET_A', 'X', [], [], g1, pair)[0] == ''),
              ('T605 sort_ci 판정필요 = PASS 아님(변이)', o('X_GET_A', 'X', scp, cir, g1, pair)[0] == ''),
              ('T605 CR-075 ③ NA = NA · 룰 인용', o('X_GET_A', 'X', scp, ci3, g1, pair, 'rules.csv:76')[0] == 'NA' and 'CR-075 ③' in o('X_GET_A', 'X', scp, ci3, g1, pair, 'rules.csv:76')[1]),
              ('T605 정적 FAIL = FAIL(CR-075 ③ 보다 우선)', o('X_GET_A', 'X', scf, ci3, g1, pair)[0] == 'FAIL'),
              ('T605 골든 순서 DIFF = FAIL', o('X_GET_A', 'X', scp, cip, gd, pair)[0] == 'FAIL'),
              ('T605 재료 없음 = None', o('X_GET_B', 'X', scp, cip, g1, pair) is None),
              ('T605 다른 화면 재료는 쓰지 않음', o('X_GET_A', 'Y', scp, cip, g1, pair) is None)]
    bad = 0
    for n, ok in cases:
        print(('PASS ' if ok else 'FAIL ') + n); bad += (not ok)
    print(f'selftest {len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(selftest() if '--selftest' in sys.argv else 0)
