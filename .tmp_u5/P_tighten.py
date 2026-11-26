p = 'Doc/e2e/specs/eg_popup.spec.ts'
s = open(p, encoding='utf-8', newline='').read()
rep = [
 ("//   나머지 단어가 모두 여는 팝업 클래스 이름 단어(Excel·Upload·Form)면 같은 버튼으로 본다. 나머지 단어가 클래스 단어가 아니면 대응 안 함(Save ↔ Batch Save 같은 다른 버튼 방지)",
  "//   TO-BE 이름 단어가 모두 여는 팝업 클래스 이름 단어(Excel·Upload, Form·Popup 제외)면 같은 버튼으로 본다. 클래스 단어 밖이면 대응 안 함(Save ↔ Batch Save, Form ↔ Excel Form 방지)"),
 (".split(/[\s_\d]+/).map(w => w.toLowerCase()).filter(w => w.length >= 3));\r\n      const texts",
  ".split(/[\s_\d]+/).map(w => w.toLowerCase()).filter(w => w.length >= 3 && !['form', 'popup'].includes(w)));\r\n      const texts"),
 ("return rest.length > 0 && rest.every(w => clsW.has(w)); }",
  "return rest.length > 0 && tw.every(w => clsW.has(w)); }"),
]
for a, b in rep:
    assert s.count(a) == 1, a[:50]
    s = s.replace(a, b)
open(p, 'w', encoding='utf-8', newline='').write(s)
b = open(p, 'rb').read(); print(b.count(b'\r\n'), b.count(b'\n'))
