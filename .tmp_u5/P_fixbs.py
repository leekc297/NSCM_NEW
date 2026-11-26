import sys
p = sys.argv[1]
s = open(p, encoding='utf-8', newline='').read()
n = s.count('\x08')
s = s.replace('\x08', chr(92) + 'b')
open(p, 'w', encoding='utf-8', newline='').write(s)
print(p, 'fixed', n, 'left', open(p, encoding='utf-8', newline='').read().count('\x08'))
