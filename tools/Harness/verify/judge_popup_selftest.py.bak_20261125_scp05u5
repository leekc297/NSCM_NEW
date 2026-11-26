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
    bad = 0
    for n, ok in cases:
        print(('PASS ' if ok else 'FAIL ') + n); bad += (not ok)
    print(f'selftest {len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(selftest() if '--selftest' in sys.argv else 0)
