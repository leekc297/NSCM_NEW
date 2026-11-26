p = 'Doc/e2e/specs/eg_popup.spec.ts'
s = open(p, encoding='utf-8', newline='').read()
rep = [('// T565(2026-11-25 SCP0005 M3 EG-f670f773', '// T569(2026-11-25 SCP0005 M3 EG-f670f773'),
       ('// T565(2026-11-25 SCP0005 M3 EG-6a0f18bc', '// T569(2026-11-25 SCP0005 M3 EG-6a0f18bc'),
       ('// T566(2026-11-25 SCP0005 D5 EG-b7b794bd', '// T569(2026-11-25 SCP0005 D5 EG-b7b794bd'),
       ('// T566: 대응 모달', '// T569: 대응 모달'),
       ('// T567(2026-11-25 SCP0005 D5 EG-4041a815', '// T565(2026-11-25 SCP0005 D5 EG-4041a815')]
for a, b in rep:
    assert s.count(a) == 1, a
    s = s.replace(a, b)
open(p, 'w', encoding='utf-8', newline='').write(s)
b = open(p, 'rb').read(); print(b.count(b'\r\n'), b.count(b'\n'), b.count(b'\x08'))
