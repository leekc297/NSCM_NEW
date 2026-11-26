import os
p = r'C:\Projects\NSCM\tools\Harness\verify\facts_sortrules.py'
b = open(p, 'rb').read().decode('utf-8'); crlf = '\r\n' in b; s = b.replace('\r\n', '\n')
old = r'''        for ln, line in enumerate(txt.split('\n'), 1):
            for c in re.findall(r'\bnew\s+(?:[\w]+\.)*(\w+)\s*\(', line):
                if c not in own: news.setdefault(c, f"{os.path.basename(rel)}:{ln}")
'''
new = r'''        for ln, line in enumerate(txt.split('\n'), 1):
            # 대화상자로 여는 것만 팝업(변수 = new C(…) 뒤 변수.ShowDialog( · new C(…).ShowDialog() — 패널에 끼우는 하위 폼(DMF0043_Contribute_Main)은 화면 본체로 본다
            for v, c in re.findall(r'(?:\b(\w+)\s*=\s*)?\bnew\s+(?:[\w]+\.)*(\w+)\s*\(', line):
                if c in own: continue
                if (v and re.search(r'\b' + re.escape(v) + r'\s*\.\s*ShowDialog\s*\(', txt)) or re.search(r'\bnew\s+(?:[\w]+\.)*' + re.escape(c) + r'\s*\([^;]*\)\s*\.\s*ShowDialog\s*\(', line):
                    news.setdefault(c, f"{os.path.basename(rel)}:{ln}")
'''
assert s.count(old) == 1
s = s.replace(old, new)
old2 = r"""    open(os.path.join(d, 'src', 'Main.cs'), 'w', encoding='utf-8').write('class Main {\n void A() {\n  var p = new NS.Pop();\n  // new Ghost();\n }\n}\n')"""
new2 = r"""    open(os.path.join(d, 'src', 'Main.cs'), 'w', encoding='utf-8').write('class Main {\n void A() {\n  var p = new NS.Pop();\n  // new Ghost();\n  p.ShowDialog();\n  var q = new Sub();\n  pnl.Controls.Add(q);\n }\n}\n')"""
assert s.count(old2) == 1
s = s.replace(old2, new2)
old3 = r"""Main.cs,Ghost,3,SP X_GET_GHOST\n')"""
new3 = r"""Main.cs,Ghost,3,SP X_GET_GHOST\nSub.cs,Sub,4,SP X_GET_SUB\n')"""
assert s.count(old3) == 1
s = s.replace(old3, new3)
old4 = r"""             ('T563 주석 속 new 는 팝업 근거 아님(변이)', 'X_GET_GHOST' not in r)]"""
new4 = r"""             ('T563 주석 속 new 는 팝업 근거 아님(변이)', 'X_GET_GHOST' not in r),
             ('T563 패널에 끼우는 하위 폼(ShowDialog 없음)은 표시 없음(변이)', 'X_GET_SUB' not in r)]"""
assert s.count(old4) == 1
s = s.replace(old4, new4)
s = s.replace("#   팝업 = 화면 .cs 원문에서 다른 클래스가 new 로 만드는 클래스(화면 본체는 프레임워크가 열어 new 대상 아님). SP 를 부르는 클래스가 전부 팝업일 때만 표시",
              "#   팝업 = 화면 .cs 원문에서 다른 클래스가 new 로 만들어 ShowDialog 로 여는 클래스. SP 를 부르는 클래스가 전부 팝업일 때만 표시")
open(p + '.s_tmp', 'wb').write((s.replace('\n', '\r\n') if crlf else s).encode('utf-8')); os.replace(p + '.s_tmp', p)
print('ok')
